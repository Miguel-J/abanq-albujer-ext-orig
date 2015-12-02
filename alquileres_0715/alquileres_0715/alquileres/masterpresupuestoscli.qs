
/** @class_declaration alquiler */
/////////////////////////////////////////////////////////////////
//// ALQUILER ///////////////////////////////////////////////////
class alquiler extends oficial
{
  function alquiler(context)
  {
    oficial(context);
  }
  function datosLineaPedido(curLineaPresupuesto)
  {
    return this.ctx.alquiler_datosLineaPedido(curLineaPresupuesto);
  }
}
//// ALQUILER ///////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition alquiler */
/////////////////////////////////////////////////////////////////
//// ALQUILER ///////////////////////////////////////////////////
function alquiler_datosLineaPedido(curLineaPre)
{
  var util = new FLUtil;
  debug("alquiler_datosLineaPedido");
  var _i = this.iface;
  if (!_i.__datosLineaPedido(curLineaPre)) {
    return false;
  }
  if (!curLineaPre.isNull("fechadesdealq")) {
    _i.curLineaPedido.setValueBuffer("fechadesdealq", curLineaPre.valueBuffer("fechadesdealq"));
  }
  if (!curLineaPre.isNull("horadesdealq")) {
    _i.curLineaPedido.setValueBuffer("horadesdealq", curLineaPre.valueBuffer("horadesdealq"));
  }
  if (!curLineaPre.isNull("fechahastaalq")) {
    _i.curLineaPedido.setValueBuffer("fechahastaalq", curLineaPre.valueBuffer("fechahastaalq"));
  }
  if (!curLineaPre.isNull("horahastaalq")) {
    _i.curLineaPedido.setValueBuffer("horahastaalq", curLineaPre.valueBuffer("horahastaalq"));
  }
  if (!curLineaPre.isNull("idperiodoalq")) {
    var idPA = curLineaPre.valueBuffer("idperiodoalq");
    if (!util.sqlUpdate("alquilerarticulos", "reservado", true, "idperiodoalq = " + idPA)) {
      return false;
    }
    _i.curLineaPedido.setValueBuffer("idperiodoalq", idPA);
  }
  return true;
}
//// ALQUILER ///////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
