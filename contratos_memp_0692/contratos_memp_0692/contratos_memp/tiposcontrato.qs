
/** @class_declaration multi */
/////////////////////////////////////////////////////////////////
//// MULTIEMPRESA ///////////////////////////////////////////////
class multi extends oficial
{
  function multi(context)
  {
    oficial(context);
  }
  function init()
  {
    return this.ctx.multi_init();
  }
}
//// MULTIEMPRESA ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition multi */
/////////////////////////////////////////////////////////////////
//// MULTIEMPRESA ///////////////////////////////////////////////
function multi_init()
{
  this.iface.__init();

  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  if (cursor.modeAccess() == cursor.Insert) {
    var codEjercicio: String = flfactppal.iface.pub_ejercicioActual();
    var idEmpresa = util.sqlSelect("ejercicios", "idempresa", "codejercicio = '" + codEjercicio + "'");
    cursor.setValueBuffer("idempresa", idEmpresa);
  }
}
//// MULTIEMPRESA ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
