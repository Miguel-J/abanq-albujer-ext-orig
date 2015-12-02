
/** @class_declaration venFacturasProv */
/////////////////////////////////////////////////////////////////
//// VENFACTURASPROV ///////////////////////////////////////////////
class venFacturasProv extends proveed
{
  function venFacturasProv(context)
  {
    proveed(context);
  }
  function regenerarRecibosProv(cursor: FLSqlCursor): Boolean {
    return this.ctx.venFacturasProv_regenerarRecibosProv(cursor);
  }
}
//// VENFACTURASPROV ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition venFacturasProv */
//////////////////////////////////////////////////////////////////
//// VENFACTURASPROV ////////////////////////////////////////////////

/* \D Regenera los recibos asociados a una factura a proveedor en caso de que haya
vencimientos personalizados asociados a la factura

@param cursor: Cursor posicionado en el registro de facturasprov correspondiente a la factura
@return True: Regeneración realizada con éxito, False: Error
\end */
function venFacturasProv_regenerarRecibosProv(cursor: FLSqlCursor): Boolean {
  var util: FLUtil = new FLUtil();

  var qVen: FLSqlQuery = new FLSqlQuery();
  qVen.setTablesList("venfacturasprov");
  qVen.setSelect("fecha,aplazado,importe");
  qVen.setFrom("venfacturasprov");
  qVen.setWhere("idfactura = " + cursor.valueBuffer("idfactura") + " order by fecha");

  if (!qVen.exec())
    return this.iface.__regenerarRecibosProv(cursor);

  if (!qVen.size())
    return this.iface.__regenerarRecibosProv(cursor);

  var contActiva: Boolean = sys.isLoadedModule("flcontppal") && util.sqlSelect("empresa", "contintegrada", "1 = 1");
  var idFactura: Number = cursor.valueBuffer("idfactura");

  if (!this.iface.curReciboProv)
    this.iface.curReciboProv = new FLSqlCursor("recibosprov");

  if (!this.iface.borrarRecibosProv(idFactura))
    return false;

  if (parseFloat(cursor.valueBuffer("total")) == 0)
    return true;

  var codPago: String = cursor.valueBuffer("codpago");

  var emitirComo: String = cursor.valueBuffer("genrecibos");
  if (!emitirComo)
    emitirComo = util.sqlSelect("formaspago", "genrecibos", "codpago = '" + codPago + "'");

  var total: Number = parseFloat(cursor.valueBuffer("total"));
  var idRecibo: Number;
  var numRecibo: Number = 1;
  var numPlazo: Number = 1;
  var importeRecibo: Number, importeEuros: Number;
  var importeAcumulado: Number = 0;
  var diasAplazado: Number, fechaVencimiento: String;
  var tasaConv: Number = parseFloat(cursor.valueBuffer("tasaconv"));
  var divisa: String = util.sqlSelect("divisas", "descripcion", "coddivisa = '" + cursor.valueBuffer("coddivisa") + "'");

  var codCuentaEmp: String = "";
  var desCuentaEmp: String = "";
  var ctaEntidadEmp: String = "";
  var ctaAgenciaEmp: String = "";
  var dCEmp: String = "";
  var cuentaEmp: String = "";
  var codSubcuentaEmp: String = "";
  var idSubcuentaEmp: String = "";
  var codProveedor: String = cursor.valueBuffer("codproveedor");
  if (emitirComo == "Pagados")
  {
    emitirComo = "Pagado";
    /*D Si los recibos deben emitirse como pagados, se generarán los registros de pago asociados a cada recibo. Si el módulo Principal de contabilidad está cargado, se generará el correspondienta asiento. La subcuenta contable del Debe del apunte corresponderá a la subcuenta contable asociada a la cuenta corriente correspondiente a la cuenta de pago del proveedor, o en su defecto a la forma de pago de la factura. Si dicha cuenta corriente no está especificada, la subcuenta contable del Debe del asiento será la correspondiente a la cuenta especial Caja.
    \end */
    codCuentaEmp = cursor.valueBuffer("codcuenta");

    if (!codCuentaEmp)
      codCuentaEmp = util.sqlSelect("proveedores", "codcuentapago", "codproveedor = '" + codProveedor + "'");

    if (!codCuentaEmp)
      codCuentaEmp = util.sqlSelect("formaspago", "codcuenta", "codpago = '" + codPago + "'");

    var datosCuentaEmp: Array = [];
    if (codCuentaEmp.toString().isEmpty()) {
      if (contActiva) {
        var qrySubcuenta: FLSqlQuery = new FLSqlQuery();
        with(qrySubcuenta) {
          setTablesList("co_cuentas,co_subcuentas");
          setSelect("s.idsubcuenta, s.codsubcuenta");
          setFrom("co_cuentas c INNER JOIN co_subcuentas s ON c.idcuenta = s.idcuenta");
          setWhere("c.codejercicio = '" + cursor.valueBuffer("codejercicio") + "'" + " AND c.idcuentaesp = 'CAJA'");
        }
        if (!qrySubcuenta.exec()) {
          return false;
        }
        if (!qrySubcuenta.first())
          return false;
        idSubcuentaEmp = qrySubcuenta.value(0);
        codSubcuentaEmp = qrySubcuenta.value(1);
      }
    } else {
      datosCuentaEmp = flfactppal.iface.pub_ejecutarQry("cuentasbanco", "descripcion,ctaentidad,ctaagencia,cuenta,codsubcuenta", "codcuenta = '" + codCuentaEmp + "'");
      idSubcuentaEmp = util.sqlSelect("co_subcuentas", "idsubcuenta", "codsubcuenta = '" + datosCuentaEmp.codsubcuenta + "'" + " AND codejercicio = '" + cursor.valueBuffer("codEjercicio") + "'");
      desCuentaEmp = datosCuentaEmp.descripcion;
      ctaEntidadEmp = datosCuentaEmp.ctaentidad;
      ctaAgenciaEmp = datosCuentaEmp.ctaagencia;
      cuentaEmp = datosCuentaEmp.cuenta;
      var dc1: String = util.calcularDC(ctaEntidadEmp + ctaAgenciaEmp);
      var dc2: String = util.calcularDC(cuentaEmp);
      dCEmp = dc1 + dc2;
      codSubcuentaEmp =  datosCuentaEmp.codsubcuenta;
    }
  } else
    emitirComo = "Emitido";


  while (qVen.next())
  {

    fechaVencimiento = qVen.value("fecha");
    importeRecibo = (total * parseFloat(qVen.value("aplazado"))) / 100;

    importeQuery = qVen.value("importe");
    debug("IQ = " + importeQuery);
    if (!importeQuery || isNaN(importeQuery) || importeQuery == 0) {
      importe = importeRecibo;
      importe = Math.round(importe);
    } else {
      importe = importeQuery;
    }

    if (numPlazo == qVen.size())
      importe = total - importeAcumulado;
    else {
      importeAcumulado += importe;
    }
    importeEuros = importeRecibo * tasaConv;
    debug(importe);
    with(this.iface.curReciboProv) {
      setModeAccess(Insert);
      refreshBuffer();
      setValueBuffer("numero", numRecibo);
      setValueBuffer("idfactura", idFactura);
      setValueBuffer("importe", importe);
      setValueBuffer("texto", util.enLetraMoneda(importeRecibo, divisa));
      setValueBuffer("importeeuros", importeEuros);
      setValueBuffer("coddivisa", cursor.valueBuffer("coddivisa"));
      setValueBuffer("codigo", cursor.valueBuffer("codigo") + "-" + flfacturac.iface.pub_cerosIzquierda(numRecibo, 2));
      setValueBuffer("codproveedor", codProveedor);
      setValueBuffer("nombreproveedor", cursor.valueBuffer("nombre"));
      setValueBuffer("cifnif", cursor.valueBuffer("cifnif"));
      setValueBuffer("fecha", cursor.valueBuffer("fecha"));
      setValueBuffer("fechav", fechaVencimiento);
      setValueBuffer("estado", emitirComo);
    }
    if (codProveedor && codProveedor != "") {
      var qryDir: FLSqlQuery = new FLSqlQuery;
      with(qryDir) {
        setTablesList("dirproveedores");
        setSelect("id, direccion, ciudad, codpostal, provincia, codpais");
        setFrom("dirproveedores");
        setWhere("codproveedor = '" + codProveedor + "' AND direccionppal = true");
        setForwardOnly(true);
      }
      if (!qryDir.exec())
        return false;
      if (qryDir.first()) {
        with(this.iface.curReciboProv) {
          setValueBuffer("coddir", qryDir.value("id"));
          setValueBuffer("direccion", qryDir.value("direccion"));
          setValueBuffer("ciudad", qryDir.value("ciudad"));
          setValueBuffer("codpostal", qryDir.value("codpostal"));
          setValueBuffer("provincia", qryDir.value("provincia"));
          setValueBuffer("codpais", qryDir.value("codpais"));
        }
      }
    }

    if (!this.iface.datosReciboProv())
      return false;

    if (!this.iface.curReciboProv.commitBuffer())
      return false;

    if (emitirComo == "Pagado") {
      idRecibo = this.iface.curReciboProv.valueBuffer("idrecibo");

      var curPago: FLSqlCursor = new FLSqlCursor("pagosdevolprov");
      with(curPago) {
        setModeAccess(Insert);
        refreshBuffer();
        setValueBuffer("idrecibo", idRecibo);
        setValueBuffer("tipo", "Pago");
        setValueBuffer("fecha", cursor.valueBuffer("fecha"));
        setValueBuffer("codcuenta", codCuentaEmp);
        setValueBuffer("descripcion", desCuentaEmp);
        setValueBuffer("ctaentidad", ctaEntidadEmp);
        setValueBuffer("ctaagencia", ctaAgenciaEmp);
        setValueBuffer("dc", dCEmp);
        setValueBuffer("cuenta", cuentaEmp);
        setValueBuffer("codsubcuenta", codSubcuentaEmp);
        setValueBuffer("idSubcuenta", idSubcuentaEmp);
        setValueBuffer("tasaconv", cursor.valueBuffer("tasaconv"));
      }

      if (!curPago.commitBuffer())
        return false;
    }

    numRecibo++;
    numPlazo++;
  }

  if (emitirComo == "Pagado")
  {
    if (!this.iface.calcularEstadoFacturaProv(false, idFactura))
      return false;
  }

  return true;
}

//// VENFACTURASPROV ////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
