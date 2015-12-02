
/** @class_declaration batchServired */
//////////////////////////////////////////////////////////////////
//// BATCH_SERVIRED //////////////////////////////////////////////
class batchServired extends oficial
{
  function batchServired(context)
  {
    oficial(context);
  }

  function generarReciboCli(curFactura: FLSqlCursor, numRecibo: String, importe: Number, fechaVto: String, emitirComo: String, datosCuentaDom: Array, datosCuentaEmp: Array, datosSubcuentaEmp: Array): Boolean {
    return this.ctx.batchServired_generarReciboCli(curFactura, numRecibo, importe, fechaVto, emitirComo, datosCuentaDom, datosCuentaEmp, datosSubcuentaEmp);
  }
}
//// BATCH_SERVIRED ///////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_definition batchServired */
//////////////////////////////////////////////////////////////////
//// BATCH_SERVIRED /////////////////////////////////////////////
function batchServired_generarReciboCli(curFactura: FLSqlCursor, numRecibo: String, importe: Number, fechaVto: String, emitirComo: String, datosCuentaDom: Array, datosCuentaEmp: Array, datosSubcuentaEmp: Array): Boolean {
  if (!this.iface.curReciboCli)
    this.iface.curReciboCli = new FLSqlCursor("reciboscli");

  var util: FLUtil = new FLUtil();
  var importeEuros: Number  = importe * parseFloat(curFactura.valueBuffer("tasaconv"));
  var divisa: String = util.sqlSelect("divisas", "descripcion", "coddivisa = '" + curFactura.valueBuffer("coddivisa") + "'");
  var codDir: Number = curFactura.valueBuffer("coddir");
  with(this.iface.curReciboCli)
  {
    setModeAccess(Insert);
    refreshBuffer();
    setValueBuffer("numero", numRecibo);
    setValueBuffer("idfactura", curFactura.valueBuffer("idfactura"));
    setValueBuffer("importe", importe);
    setValueBuffer("texto", util.enLetraMoneda(importe, divisa));
    setValueBuffer("importeeuros", importeEuros);
    setValueBuffer("coddivisa", curFactura.valueBuffer("coddivisa"));
    setValueBuffer("codigo", curFactura.valueBuffer("codigo") + "-" + flfacturac.iface.pub_cerosIzquierda(numRecibo, 2));
    setValueBuffer("codcliente", curFactura.valueBuffer("codcliente"));
    setValueBuffer("nombrecliente", curFactura.valueBuffer("nombrecliente"));
    setValueBuffer("cifnif", curFactura.valueBuffer("cifnif"));
    if (codDir == 0)
      setNull("coddir");
    else
      setValueBuffer("coddir", codDir);
    setValueBuffer("direccion", curFactura.valueBuffer("direccion"));
    setValueBuffer("codpostal", curFactura.valueBuffer("codpostal"));
    setValueBuffer("ciudad", curFactura.valueBuffer("ciudad"));
    setValueBuffer("provincia", curFactura.valueBuffer("provincia"));
    setValueBuffer("codpais", curFactura.valueBuffer("codpais"));
    setValueBuffer("fecha", curFactura.valueBuffer("fecha"));

    setValueBuffer("tipocc", curFactura.valueBuffer("tipocc"));
    setValueBuffer("numerocc", curFactura.valueBuffer("numerocc"));
    setValueBuffer("cvvcc", curFactura.valueBuffer("cvvcc"));
    setValueBuffer("titularcc", curFactura.valueBuffer("titularcc"));
    setValueBuffer("mescc", curFactura.valueBuffer("mescc"));
    setValueBuffer("anocc", curFactura.valueBuffer("anocc"));

    if (datosCuentaDom.error == 0) {
      setValueBuffer("codcuenta", datosCuentaDom.codcuenta);
      setValueBuffer("descripcion", datosCuentaDom.descripcion);
      setValueBuffer("ctaentidad", datosCuentaDom.ctaentidad);
      setValueBuffer("ctaagencia", datosCuentaDom.ctaagencia);
      setValueBuffer("cuenta", datosCuentaDom.cuenta);
      setValueBuffer("dc", datosCuentaDom.dc);
    }
    setValueBuffer("fechav", fechaVto);
    setValueBuffer("estado", emitirComo);
  }
  if (!this.iface.datosReciboCli())
    return false;

  if (!this.iface.curReciboCli.commitBuffer())
    return false;

  if (emitirComo == "Pagado")
  {
    var idRecibo = this.iface.curReciboCli.valueBuffer("idrecibo");
    var curPago = new FLSqlCursor("pagosdevolcli");
    with(curPago) {
      setModeAccess(Insert);
      refreshBuffer();
      setValueBuffer("idrecibo", idRecibo);
      setValueBuffer("tipo", "Pago");
      setValueBuffer("fecha", curFactura.valueBuffer("fecha"));
      setValueBuffer("tasaconv", curFactura.valueBuffer("tasaconv"));
      if (datosCuentaEmp.error == 0) {
        setValueBuffer("codcuenta", datosCuentaEmp.codcuenta);
        setValueBuffer("descripcion", datosCuentaEmp.descripcion);
        setValueBuffer("ctaentidad", datosCuentaEmp.ctaentidad);
        setValueBuffer("ctaagencia", datosCuentaEmp.ctaagencia);
        setValueBuffer("dc", datosCuentaEmp.dc);
        setValueBuffer("cuenta", datosCuentaEmp.cuenta);
      }
      if (datosSubcuentaEmp && datosSubcuentaEmp.error == 0) {
        setValueBuffer("codsubcuenta", datosSubcuentaEmp.codsubcuenta);
        setValueBuffer("idsubcuenta", datosSubcuentaEmp.idsubcuenta);
      }
    }
    if (!curPago.commitBuffer())
      return false;
  }
  return true;
}
//// BATCH_SERVIRED //////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
