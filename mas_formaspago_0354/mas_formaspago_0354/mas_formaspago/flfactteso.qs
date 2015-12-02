
/** @class_declaration masFormasPago */
/////////////////////////////////////////////////////////////////
//// MAS_FORMASPAGO /////////////////////////////////////////////
class masFormasPago extends proveed
{
  function masFormasPago(context)
  {
    proveed(context);
  }
  function regenerarRecibosCli(cursor: FLSqlCursor): Boolean {
    return this.ctx.masFormasPago_regenerarRecibosCli(cursor);
  }
  function regenerarRecibosProv(cursor: FLSqlCursor, forzarEmitirComo: String): Boolean {
    return this.ctx.masFormasPago_regenerarRecibosProv(cursor, forzarEmitirComo);
  }
  function calcFechaVencimientoCli(curFactura: FLSqlCursor, numPlazo: Number, diasAplazado: Number, mesesCompletos: Boolean, conCadencia: Number): String {
    return this.ctx.masFormasPago_calcFechaVencimientoCli(curFactura, numPlazo, diasAplazado, mesesCompletos, conCadencia);
  }
  function calcFechaVencimientoProv(curFactura: FLSqlCursor, numPlazo: Number, diasAplazado: Number, mesesCompletos: Boolean, conCadencia: Number): String {
    return this.ctx.masFormasPago_calcFechaVencimientoProv(curFactura, numPlazo, diasAplazado, mesesCompletos, conCadencia);
  }
}
//// MAS_FORMASPAGO /////////////////////////////////////////////
/////////////////////////////////////////////////////////////////


/** @class_definition masFormasPago */
/////////////////////////////////////////////////////////////////
//// MAS_FORMASPAGO ////////////////////////////////////////////

/* \D Regenera los recibos asociados a una factura a cliente.
Si la contabilidad está activada, genera los correspondientes asientos de pago y devolución.

@param cursor: Cursor posicionado en el registro de facturascli correspondiente a la factura
@return True: Regeneración realizada con éxito, False: Error
\end */
function masFormasPago_regenerarRecibosCli(cursor: FLSqlCursor): Boolean {
  var util: FLUtil = new FLUtil();
  var contActiva: Boolean = sys.isLoadedModule("flcontppal") && util.sqlSelect("empresa", "contintegrada", "1 = 1");

  var idFactura: Number = cursor.valueBuffer("idfactura");
  var total: Number = parseFloat(cursor.valueBuffer("total"));

  /* //FP if (!util.sqlSelect("anticiposcli a inner join pedidoscli p on a.idpedido=p.idpedido inner join lineasalbaranescli la on la.idpedido=p.idpedido inner join albaranescli ab on ab.idalbaran=la.idalbaran inner join facturascli f on f.idfactura=ab.idfactura", "idanticipo,importe", "f.idfactura = " + idFactura + " group by idanticipo,importe",  "anticiposcli,pedidoscli,lineasalbaranescli,albaranescli,facturascli")) //ANT
    return this.iface.__regenerarRecibosCli(cursor);//ANT //FP */

  if (!this.iface.borrarRecibosCli(idFactura))
    return false;

  if (total == 0)
    return true;

  var codPago: String = cursor.valueBuffer("codpago");
  var codCliente: String = cursor.valueBuffer("codcliente");

  var emitirComo: String = util.sqlSelect("formaspago", "genrecibos", "codpago = '" + codPago + "'");
  var mesesCompletos: Boolean = util.sqlSelect("formaspago", "mesescompletos", "codpago = '" + codPago + "'"); //FP
  var datosCuentaDom = this.iface.obtenerDatosCuentaDom(codCliente);
  if (datosCuentaDom.error == 2)
    return false;

  var numRecibo: Number = 1;
  var numPlazo: Number = 1;
  var importe: Number;
  var diasAplazado: Number;
  var fechaVencimiento: String;
  var diasAplazado: Number; //FP
  var tipoPlazo: Number; // 0: Porcentual, 1: Número de plazos, 2: Importe fijo //FP
  var nPlazos: Number; //FP
  var cadencia: Number = 0; //FP
  var importeFijo: Number; //FP
  var importeMinimo: Number; //FP
  var contador: Number; //FP
  var datosCuentaEmp: Array = false;
  var datosSubcuentaEmp: Array = false;
  var hayAnticipos: Boolean = false; //ANT

  if (emitirComo == "Pagados")
  {
    emitirComo = "Pagado";
    /* \D Si los recibos deben emitirse como pagados, se generarán los registros de pago asociados a cada recibo. Si el módulo Principal de contabilidad está cargado, se generará el correspondienta asiento. La subcuenta contable del Debe del apunte corresponderá a la subcuenta contable asociada a la cuenta corriente correspondiente a la forma de pago de la factura. Si dicha cuenta corriente no está especificada, la subcuenta contable del Debe del asiento será la correspondiente a la cuenta especial Caja.
    \end */
    datosCuentaEmp = this.iface.obtenerDatosCuentaEmp(codCliente, codPago);
    if (datosCuentaEmp.error == 2)
      return false;
    if (contActiva) {
      datosSubcuentaEmp = this.iface.obtenerDatosSubcuentaEmp(datosCuentaEmp);
      if (datosSubcuentaEmp.error == 2)
        return false;
    }
  } else
    emitirComo = "Emitido";

  var importeAcumulado: Number = 0;
  var curPlazos: FLSqlCursor = new FLSqlCursor("plazos");
  curPlazos.select("codpago = '" + codPago + "'  ORDER BY dias");
  if (curPlazos.size() == 0)
  {
    MessageBox.warning(util.translate("scripts", "No se pueden generar los recibos, la forma de pago ") + codPago + util.translate("scripts", "no tiene plazos de pago asociados"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return false;
  }

  /** \C En el caso de que existan anticipos crea un recibo como pagado para cada uno de ellos.
    \end */
  qryAnticipos = new FLSqlQuery();
  qryAnticipos.setTablesList("anticiposcli,pedidoscli,lineasalbaranescli,albaranescli,facturascli");
  qryAnticipos.setSelect("idanticipo,importe");
  qryAnticipos.setFrom("anticiposcli a inner join pedidoscli p on a.idpedido=p.idpedido inner join lineasalbaranescli la on la.idpedido=p.idpedido inner join albaranescli ab on ab.idalbaran=la.idalbaran inner join facturascli f on f.idfactura=ab.idfactura");
  qryAnticipos.setWhere("f.idfactura = " + idFactura + " group by idanticipo,importe");

  if (!qryAnticipos.exec())
    return false;

  while (qryAnticipos.next())
  {
    if (!this.iface.generarReciboAnticipo(cursor, numRecibo, qryAnticipos.value(0), datosCuentaDom))
      return false;
    total -= parseFloat(qryAnticipos.value(1));
    numRecibo++;
    hayAnticipos = true;
  }

  while (curPlazos.next())
  {
    diasAplazado = curPlazos.valueBuffer("dias");
    /* //FP importe = (total * parseFloat(curPlazos.valueBuffer("aplazado"))) / 100;
    if ( curPlazos.at() == ( curPlazos.size() - 1 ) )
      importe = total - importeAcumulado;
    else {
      importe = Math.round( importe );
      importeAcumulado += importe;
    }
    if ( importe < 0 )
      break;*/

    tipoPlazo = curPlazos.valueBuffer("tipoplazo");
    if (tipoPlazo == 1) { // Número de plazos
      nPlazos = curPlazos.valueBuffer("nplazos");
      cadencia = curPlazos.valueBuffer("cadencia");
      importe = (total - importeAcumulado) / nPlazos;
      importe = Math.round(importe);
    }
    if (tipoPlazo == 2) { // Importe fijo
      importeFijo = curPlazos.valueBuffer("importefijo");
      importeMinimo = curPlazos.valueBuffer("importeminimo");
      cadencia = curPlazos.valueBuffer("cadencia");
    }
    contador = 0;
    while (contador != -1) {
      conCadencia = contador * cadencia;
      if (tipoPlazo == 0) { // Porcentual
        importe = (total * parseFloat(curPlazos.valueBuffer("aplazado"))) / 100;
        importe = Math.round(importe);
        if (curPlazos.at() == (curPlazos.size() - 1))
          importe = total - importeAcumulado;
        contador = -1;
      }
      if (tipoPlazo == 1) { // Número de plazos
        if (contador == (nPlazos - 1)) {
          importe = total - importeAcumulado;
          contador = -1;
        } else {
          contador++;
        }
      }
      if (tipoPlazo == 2) { // Importe fijo
        if ((importeAcumulado + importeFijo + importeMinimo) >= total) {
          importe = total - importeAcumulado;
          contador = -1;
        } else {
          importe = importeFijo;
          contador++;
        }
      }
      importeAcumulado += importe;
      fechaVencimiento = this.iface.calcFechaVencimientoCli(cursor, numPlazo, diasAplazado, mesesCompletos, conCadencia);
      if (!this.iface.generarReciboCli(cursor, numRecibo, importe, fechaVencimiento, emitirComo, datosCuentaDom, datosCuentaEmp, datosSubcuentaEmp))
        return false;
      numRecibo++;
      numPlazo++;
    }
    /* //FP fechaVencimiento = this.iface.calcFechaVencimientoCli(cursor, numPlazo, diasAplazado);

    if (!this.iface.generarReciboCli(cursor, numRecibo, importe, fechaVencimiento, emitirComo, datosCuentaDom, datosCuentaEmp, datosSubcuentaEmp))
      return false;
    numRecibo++;
    numPlazo++;*/
  }

  if (emitirComo == "Pagado")
  {
    if (!this.iface.calcularEstadoFacturaCli(false, idFactura))
      return false;
  }

  if (cursor.valueBuffer("codcliente"))
    if (sys.isLoadedModule("flfactteso"))
      this.iface.actualizarRiesgoCliente(codCliente);

  return true;
}

/* \D Regenera los recibos asociados a una factura a proveedor.
Si la contabilidad está activada, genera los correspondientes asientos de pago y devolución.

@param cursor: Cursor posicionado en el registro de facturasprov correspondiente a la factura
@param forzarEmitirComo: Fuerza que el recibo sea pagado o emitido, independientemente de lo elegido en la forma de pago.
@return True: Regeneración realizada con éxito, False: Error
\end */
function masFormasPago_regenerarRecibosProv(cursor: FLSqlCursor, forzarEmitirComo: String): Boolean {
  var util: FLUtil = new FLUtil();
  var contActiva: Boolean = sys.isLoadedModule("flcontppal") && util.sqlSelect("empresa", "contintegrada", "1 = 1");
  var idFactura: Number = cursor.valueBuffer("idfactura");

  if (!this.iface.curReciboProv)
    this.iface.curReciboProv = new FLSqlCursor("recibosprov");

  if (!this.iface.borrarRecibosProv(idFactura))
    return false;

  if (parseFloat(cursor.valueBuffer("total")) == 0)
    return true;

  var codPago: String = cursor.valueBuffer("codpago");

  var emitirComo: String;
  if (forzarEmitirComo)
    emitirComo = forzarEmitirComo;
  else
    emitirComo = util.sqlSelect("formaspago", "genrecibos", "codpago = '" + codPago + "'");
  var mesesCompletos: Boolean = util.sqlSelect("formaspago", "mesescompletos", "codpago = '" + codPago + "'"); //FP

  var total: Number = parseFloat(cursor.valueBuffer("total"));
  var idRecibo: Number;
  var numRecibo: Number = 1;
  var importeRecibo: Number, importeEuros: Number;
  var diasAplazado: Number, fechaVencimiento: String;
  var tipoPlazo: Number; // 0: Porcentual, 1: Número de plazos, 2: Importe fijo //FP desde aquí
  var nPlazos: Number;
  var cadencia: Number = 0;
  var importeMinimo: Number;
  var contador: Number; //FP hasta aquí
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
  var numPlazo: Number = 1;
  var curPlazos: FLSqlCursor = new FLSqlCursor("plazos");
  var conCadencia: Number; //FP
  var importeAcumulado: Number = 0; //FP
  curPlazos.select("codpago = '" + codPago + "' ORDER BY dias");
  if (curPlazos.size() == 0)
  {
    MessageBox.warning(util.translate("scripts", "No se pueden generar los recibos, la forma de pago ") + codPago + util.translate("scripts", "no tiene plazos de pago asociados"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return false;
  }
  while (curPlazos.next())
  {
    /*FP importeRecibo = (total * parseFloat(curPlazos.valueBuffer("aplazado"))) / 100;
    importeEuros = importeRecibo * tasaConv;*/
    diasAplazado = curPlazos.valueBuffer("dias");
    //FP desde aquí
    tipoPlazo = curPlazos.valueBuffer("tipoplazo");
    contador = 0;
    if (tipoPlazo == 1) { // Número de plazos
      nPlazos = curPlazos.valueBuffer("nplazos");
      cadencia = curPlazos.valueBuffer("cadencia");
      if (nPlazos == 0) nPlazos = 1;
      importeRecibo = (total - importeAcumulado) / nPlazos;
      importeRecibo = Math.round(importeRecibo);
    }
    if (tipoPlazo == 2) { // Importe fijo
      cadencia = curPlazos.valueBuffer("cadencia");
      importeMinimo = curPlazos.valueBuffer("importeminimo");
      importeRecibo = curPlazos.valueBuffer("importefijo");
    }

    while (contador != -1) { // bucle para los plazos del tipo de pago elegido
      conCadencia = contador * cadencia;
      if (tipoPlazo == 0) { // Porcentual
        importeRecibo = (total * parseFloat(curPlazos.valueBuffer("aplazado"))) / 100;
        contador = -1; // Sólo un plazo para la forma de pago "Porcentual"
      }
      if (tipoPlazo == 1) { // Número de plazos
        if (contador == nPlazos - 1) {
          importeRecibo = total - importeAcumulado;
          contador = -1;
        } else {
          contador++;
        }
      }
      if (tipoPlazo == 2) { // Importe fijo
        if (importeAcumulado + importeRecibo + importeMinimo >= total) {
          importeRecibo = total - importeAcumulado;
          contador = -1;
        } else {
          contador++;
        }
      }
      importeAcumulado += importeRecibo;
      importeEuros = importeRecibo * tasaConv;
      //FP hasta aquí
      with(this.iface.curReciboProv) {
        setModeAccess(Insert);
        refreshBuffer();
        setValueBuffer("numero", numRecibo);
        setValueBuffer("idfactura", idFactura);
        setValueBuffer("importe", importeRecibo);
        setValueBuffer("texto", util.enLetraMoneda(importeRecibo, divisa));
        setValueBuffer("importeeuros", importeEuros);
        setValueBuffer("coddivisa", cursor.valueBuffer("coddivisa"));
        setValueBuffer("codigo", cursor.valueBuffer("codigo") + "-" + flfacturac.iface.pub_cerosIzquierda(numRecibo, 2));
        setValueBuffer("codproveedor", codProveedor);
        setValueBuffer("nombreproveedor", cursor.valueBuffer("nombre"));
        setValueBuffer("cifnif", cursor.valueBuffer("cifnif"));
        setValueBuffer("fecha", cursor.valueBuffer("fecha"));
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

      //FP fechaVencimiento = this.iface.calcFechaVencimientoProv(cursor, numPlazo, diasAplazado);
      fechaVencimiento = this.iface.calcFechaVencimientoProv(cursor, numPlazo, diasAplazado, mesesCompletos, conCadencia);//FP
      this.iface.curReciboProv.setValueBuffer("fechav", fechaVencimiento);

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
    }
  }

  if (emitirComo == "Pagado")
  {
    if (!this.iface.calcularEstadoFacturaProv(false, idFactura))
      return false;
  }

  return true;
}

/* \D Calcula la fecha de vencimiento de un recibo en base a los días de pago y vacaciones del cliente
@param curFactura: Cursor posicionado en el registro de facturas correspondiente a la factura
@param numPlazo: Número del plazo actual
@param diasAplazado: Días de aplazamiento del pago
@param mesesCompletos: Ajusta a la duración del mes en caso de que diasAplazado sea múltiplo de 30
@param conCadencia: Días añadidos por formas de pago a plazos o por importe fijo
@return Fecha de vencimiento
\end */
function masFormasPago_calcFechaVencimientoCli(curFactura: FLSqlCursor, numPlazo: Number, diasAplazado: Number, mesesCompletos: Boolean, conCadencia: Number): String {
  var util: FLUtil = new FLUtil;
  var fechaFactura: String = curFactura.valueBuffer("fecha");
  //FP var f:String = this.iface.__calcFechaVencimientoCli(curFactura, numPlazo, diasAplazado);
  var f: String;

  //FP desde aquí
  if (mesesCompletos == true && (conCadencia + diasAplazado) % 30 == 0)
    f = util.addMonths(fechaFactura, (diasAplazado + conCadencia) / 30).toString();
  else if (mesesCompletos == true && conCadencia % 30 == 0)
    f = util.addMonths(util.addDays(fechaFactura, diasAplazado).toString(), conCadencia / 30).toString();
  else f = util.addDays(fechaFactura, diasAplazado + conCadencia).toString();
  //FP hasta aquí
  var codCliente: String = curFactura.valueBuffer("codcliente");
  if (!codCliente || codCliente == "")
    return f;

  var diasPago: Array;
  var cadenaDiasPago: String = util.sqlSelect("clientes", "diaspago", "codcliente = '" + codCliente + "'");
  if (!cadenaDiasPago || cadenaDiasPago == "")
    diasPago = "";
  else
    diasPago = cadenaDiasPago.split(",");

  var buscarDia: String = util.sqlSelect("clientes", "buscardia", "codcliente = '" + codCliente + "'");
  if (buscarDia == "Anterior")
  {
    fechaVencimiento = this.iface.procesarDiasPagoCliAnt(f, diasPago);
    if (util.daysTo(fechaVencimiento, fechaFactura) > 0)
      fechaVencimiento = this.iface.procesarDiasPagoCli(f, diasPago);
  } else
    fechaVencimiento = this.iface.procesarDiasPagoCli(f, diasPago);

  return fechaVencimiento;
}

/* \D Calcula la fecha de vencimiento de un recibo en base a los días de pago y vacaciones del proveedor
@param curFactura: Cursor posicionado en el registro de facturas correspondiente a la factura
@param numPlazo: Número del plazo actual
@param diasAplazado: Días de aplazamiento del pago
@param mesesCompletos: Ajusta a la duración del mes en caso de que diasAplazado sea múltiplo de 30
@param conCadencia: Días añadidos por formas de pago a plazos o por importe fijo
@return Fecha de vencimiento
\end */
function masFormasPago_calcFechaVencimientoProv(curFactura: FLSqlCursor, numPlazo: Number, diasAplazado: Number, mesesCompletos: Boolean, conCadencia: Number): String {
  var util: FLUtil = new FLUtil;
  var fechaFactura: String = curFactura.valueBuffer("fecha");
  var f: String; //FP = this.iface.__calcFechaVencimientoProv(curFactura, numPlazo, diasAplazado);
  //FP desde aquí
  if (mesesCompletos == true && (conCadencia + diasAplazado) % 30 == 0)
    f = util.addMonths(fechaFactura, (diasAplazado + conCadencia) / 30).toString();

  else if (mesesCompletos == true && conCadencia % 30 == 0)
    f = util.addMonths(util.addDays(fechaFactura, diasAplazado).toString(), conCadencia / 30).toString();

  else f = util.addDays(fechaFactura, diasAplazado + conCadencia).toString();
  //FP hasta aquí
  var codProveedor: String = curFactura.valueBuffer("codproveedor");
  if (!codProveedor || codProveedor == "")
    return f;

  var diasPago: Array;
  var cadenaDiasPago: String = util.sqlSelect("proveedores", "diaspago", "codproveedor = '" + codProveedor + "'");
  if (!cadenaDiasPago || cadenaDiasPago == "")
    diasPago = "";
  else
    diasPago = cadenaDiasPago.split(",");

  var buscarDia: String = util.sqlSelect("proveedores", "buscardia", "codproveedor = '" + codProveedor + "'");
  if (buscarDia == "Posterior")
    fechaVencimiento = this.iface.procesarDiasPagoProv(f, diasPago);
  else {
    fechaVencimiento = this.iface.procesarDiasPagoProvAnt(f, diasPago);
    if (util.daysTo(fechaVencimiento, fechaFactura) > 0)
      fechaVencimiento = this.iface.procesarDiasPagoProv(f, diasPago);
  }

  return fechaVencimiento;
}

//// MAS_FORMASPAGO ////////////////////////////////////////////
////////////////////////////////////////////////////////////////

