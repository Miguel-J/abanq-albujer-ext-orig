
/** @class_declaration centroscoste */
/////////////////////////////////////////////////////////////////
//// CENTROSCOSTE ////////////////////////////////////////
class centroscoste extends oficial
{
  function centroscoste(context)
  {
    oficial(context);
  }
  function validateForm(): Boolean {
    return this.ctx.centroscoste_validateForm();
  }
}
//// CENTROSCOSTE ////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition centroscoste */
/////////////////////////////////////////////////////////////////
//// CENTROSCOSTE ////////////////////////////////////////
function centroscoste_validateForm(): Boolean {
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  if (!this.iface.__validateForm())
    return false;

  var idAsiento: Number = cursor.valueBuffer("idasiento");
  if (!idAsiento)
    return false;

  var codCentro: String = cursor.valueBuffer("codcentro");
  var codSubCentro: String = cursor.valueBuffer("codsubcentro");

  if (codCentro && codCentro != "")
  {
    if (!flcontppal.iface.pub_crearCentrosCosteAsiento(idAsiento, codCentro, codSubCentro))
      return false;
  }

  if (!flcontppal.iface.pub_comprobarCentrosCosteGrupos6y7(idAsiento, true))
    return false;

  return true;
}
//// CENTROSCOSTE ////////////////////////////////////////
/////////////////////////////////////////////////////////////////
