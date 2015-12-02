
/** @class_declaration alquiler */
/////////////////////////////////////////////////////////////////
//// ALQUILER ///////////////////////////////////////////////////
class alquiler extends oficial
{
  function alquiler(context)
  {
    oficial(context);
  }
  function datosLineaAlbaran(curLineaPedido)
  {
    return this.ctx.alquiler_datosLineaAlbaran(curLineaPedido);
  }
}
//// ALQUILER ///////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition alquiler */
/////////////////////////////////////////////////////////////////
//// ALQUILER ///////////////////////////////////////////////////
function alquiler_datosLineaAlbaran(curLineaPed)
{
  debug("alquiler_datosLineaAlbaran ");
  var _i = this.iface;
  if (!_i.__datosLineaAlbaran(curLineaPed)) {
    return false;
  }
  if (!curLineaPed.isNull("fechadesdealq")) {
    _i.curLineaAlbaran.setValueBuffer("fechadesdealq", curLineaPed.valueBuffer("fechadesdealq"));
  }
  if (!curLineaPed.isNull("horadesdealq")) {
    _i.curLineaAlbaran.setValueBuffer("horadesdealq", curLineaPed.valueBuffer("horadesdealq"));
  }
  if (!curLineaPed.isNull("fechahastaalq")) {
    _i.curLineaAlbaran.setValueBuffer("fechahastaalq", curLineaPed.valueBuffer("fechahastaalq"));
  }
  if (!curLineaPed.isNull("horahastaalq")) {
    _i.curLineaAlbaran.setValueBuffer("horahastaalq", curLineaPed.valueBuffer("horahastaalq"));
  }
  if (!curLineaPed.isNull("idperiodoalq")) {
    _i.curLineaAlbaran.setValueBuffer("idperiodoalq", curLineaPed.valueBuffer("idperiodoalq"));
  }
  return true;
}
