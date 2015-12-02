
/** @class_declaration venFacturasCli */
/////////////////////////////////////////////////////////////////
//// VENFACTURASCLI ///////////////////////////////////////////////
class venFacturasCli extends oficial
{
  function venFacturasCli(context)
  {
    oficial(context);
  }
  function regenerarRecibosCli(cursor: FLSqlCursor): Boolean {
    return this.ctx.venFacturasCli_regenerarRecibosCli(cursor);
  }
}
//// VENFACTURASCLI ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition venFacturasCli */
//////////////////////////////////////////////////////////////////
//// VENFACTURASCLI ////////////////////////////////////////////////

/* \D Regenera los recibos asociados a una factura a cliente en caso de que haya
vencimientos personalizados asociados a la factura

@param cursor: Cursor posicionado en el registro de facturascli correspondiente a la factura
@return True: Regeneración realizada con éxito, False: Error
\end */
function venFacturasCli_regenerarRecibosCli(cursor: FLSqlCursor): Boolean {
  var util: FLUtil = new FLUtil();

  var qVen: FLSqlQuery = new FLSqlQuery();
  qVen.setTablesList("venfacturascli");
  qVen.setFrom("venfacturascli");
  qVen.setSelect("fecha,aplazado,importe");
  qVen.setWhere("idfactura = " + cursor.valueBuffer("idfactura") + " order by fecha");

  if (!qVen.exec())
    return this.iface.__regenerarRecibosCli(cursor);

  if (!qVen.size())
    return this.iface.__regenerarRecibosCli(cursor);

  var contActiva: Boolean = sys.isLoadedModule("flcontppal") && util.sqlSelect("empresa", "contintegrada", "1 = 1");

  var idFactura: Number = cursor.valueBuffer("idfactura");
  var total: Number = parseFloat(cursor.valueBuffer("total"));

  if (!this.iface.borrarRecibosCli(idFactura))
    return false;

  if (total == 0)
    return true;

  var codPago: String = cursor.valueBuffer("codpago");
  var codCliente: String = cursor.valueBuffer("codcliente");

  var emitirComo: String = util.sqlSelect("formaspago", "genrecibos", "codpago = '" + codPago + "'");
  var datosCuentaDom = this.iface.obtenerDatosCuentaDom(codCliente);
  if (datosCuentaDom.error == 2)
    return false;

  var numRecibo: Number = 1;
  var numPlazo: Number = 1;
  var importe: Number;
  var diasAplazado: Number;
  var fechaVencimiento: String;
  var datosCuentaEmp: Array = false;
  var datosSubcuentaEmp: Array = false;

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
  var importeQuery: Number = 0;
  while (qVen.next())
  {
    fechaVencimiento = qVen.value(0);
    importeQuery = qVen.value("importe");
    if (!importeQuery || isNaN(importeQuery) || importeQuery == 0) {
      importe = (total * parseFloat(qVen.value("aplazado"))) / 100;
      importe = Math.round(importe);
    } else {
      importe = importeQuery;
    }

    if (numPlazo == qVen.size())
      importe = total - importeAcumulado;
    else {
      importeAcumulado += importe;
    }
    if (!this.iface.generarReciboCli(cursor, numRecibo, importe, fechaVencimiento, emitirComo, datosCuentaDom, datosCuentaEmp, datosSubcuentaEmp))
      return false;
    numRecibo++;
    numPlazo++;
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

//// VENFACTURASCLI //////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
