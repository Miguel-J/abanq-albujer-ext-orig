
/** @class_declaration liqAgentes */
//////////////////////////////////////////////////////////////////
//// LIQAGENTES //////////////////////////////////////////////////
class liqAgentes extends oficial
{
  function liqAgentes(context)
  {
    oficial(context);
  }
  function validateForm(): Boolean {
    return this.ctx.liqAgentes_validateForm();
  }
  function comprobarLiquidacion(): Boolean {
    return this.ctx.liqAgentes_comprobarLiquidacion();
  }
}
//// LIQAGENTES ///////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_definition liqAgentes */
//////////////////////////////////////////////////////////////////
//// LIQAGENTES /////////////////////////////////////////////////////
function liqAgentes_validateForm(): Boolean {
  if (!this.iface.__validateForm())
  {
    return false;
  }

  if (!this.iface.comprobarLiquidacion())
  {
    return false;
  }
  return true;
}

function liqAgentes_comprobarLiquidacion(): Boolean {
  var util: FLUtil = new FLUtil();
  var cursor: FLSqlCursor = this.cursor();
  var codLiquidacion: String = cursor.valueBuffer("codliquidacion");
  if (cursor.modeAccess() == cursor.Edit && codLiquidacion)
  {
    var res: Number = MessageBox.warning(util.translate("scripts", "La factura que intenta modificar pertenece a la liquidación %1.\n¿Desea continuar?").arg(codLiquidacion), MessageBox.Yes, MessageBox.No);
    if (res != MessageBox.Yes) {
      return false;
    }
    var curLiq: FLSqlCursor = new FLSqlCursor("liquidaciones");
    curLiq.select("codliquidacion = '" + cursor.valueBuffer("codliquidacion") + "'");
    if (!curLiq.first()) {
      return false;
    }
    curLiq.setModeAccess(curLiq.Edit);
    curLiq.refreshBuffer();
    curLiq.setValueBuffer("total", formRecordliquidaciones.iface.pub_commonCalculateField("total", curLiq));
    if (!curLiq.commitBuffer()) {
      return false;
    }
  }
  return true;
}
//// LIQAGENTES /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
