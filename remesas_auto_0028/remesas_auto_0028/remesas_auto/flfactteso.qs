
/** @class_declaration remesasAuto */
/////////////////////////////////////////////////////////////////
//// REMESAS AUTO ///////////////////////////////////////////////
class remesasAuto extends oficial
{
  function remesasAuto(context)
  {
    oficial(context);
  }
  function generarReciboCli(curFactura: FLSqlCursor, numRecibo: String, importe: Number, fechaVto: String, emitirComo: String, datosCuentaDom: Array, datosCuentaEmp: Array, datosSubcuentaEmp: Array): Boolean {
    return this.ctx.remesasAuto_generarReciboCli(curFactura, numRecibo, importe, fechaVto, emitirComo, datosCuentaDom, datosCuentaEmp, datosSubcuentaEmp);
  }
}
//// REMESAS AUTO ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition remesasAuto */
/////////////////////////////////////////////////////////////////
//// REMESAS AUTO ///////////////////////////////////////////////
function remesasAuto_generarReciboCli(curFactura: FLSqlCursor, numRecibo: String, importe: Number, fechaVto: String, emitirComo: String, datosCuentaDom: Array, datosCuentaEmp: Array, datosSubcuentaEmp: Array): Boolean {
  var util: FLUtil = new FLUtil;

  if (!this.iface.__generarReciboCli(curFactura, numRecibo, importe, fechaVto, emitirComo, datosCuentaDom, datosCuentaEmp, datosSubcuentaEmp))
    return false;

  /*
  var emitirComoFP:String = util.sqlSelect("formaspago", "genrecibos", "codpago = '" + curFactura.valueBuffer("codpago") + "'");
  if (emitirComoFP == "Remesados") {
    var importeMinimo:Number = flfactppal.iface.pub_valorDefectoEmpresa("minimoremesa");
    if (!importeMinimo)
      importeMinimo = 0;
    if (importe <= importeMinimo)
      return true;

    var curRemesa:FLSqlCursor = new FLSqlCursor("remesas");
    curRemesa.select("activa = true");
    if (!curRemesa.first()) {
      MessageBox.warning(util.translate("scripts", "Se intenta generar un recibo Remesado, peso no existe ninguna remesa activa.\nDebe crear la remesa activa antes de generar los recibos."), MessageBox.Ok, MessageBox.NoButton);
      return false;
    }
    var idRecibo:String = util.sqlSelect("reciboscli", "idrecibo", "idfactura = " + curFactura.valueBuffer("idfactura") + " AND numero = " + numRecibo);
    if (!formRecordremesas.iface.pub_asociarReciboRemesa(idRecibo, curRemesa))
      return false;
    curRemesa.setModeAccess(curRemesa.Edit);
    curRemesa.refreshBuffer();
    curRemesa.setValueBuffer("total", util.sqlSelect("reciboscli", "SUM(importe)", "idremesa = " + curRemesa.valueBuffer("idremesa")));
    if (!curRemesa.commitBuffer())
      return false;
  }
  */
  return true;
}
//// REMESAS AUTO ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
