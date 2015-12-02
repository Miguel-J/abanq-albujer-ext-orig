
/** @class_declaration presupanuales */
/////////////////////////////////////////////////////////////////
//// PRESUP_ANUALES //////////////////////////////////////
class presupanuales extends oficial
{
  function presupanuales(context)
  {
    oficial(context);
  }
  function validateForm(): Boolean {
    return this.ctx.presupanuales_validateForm();
  }
}
//// PRESUP_ANUALES //////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition presupanuales */
/////////////////////////////////////////////////////////////////
//// PRESUP_ANUALES //////////////////////////////////////
function presupanuales_validateForm(): Boolean {
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  cursor.setValueBuffer("importe", this.iface.calculateField("importe"));
  this.iface.calculaDescuadre();

  var codEjercicio = cursor.valueBuffer("codejercicio");
  if (util.sqlSelect("ejercicios", "presupuestario", "codejercicio = '" + codEjercicio + "'"))
    return true;

  return this.iface.__validateForm();
}

//// PRESUP_ANUALES //////////////////////////////////////
/////////////////////////////////////////////////////////////////
