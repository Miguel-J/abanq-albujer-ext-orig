
/** @class_declaration alquiler */
/////////////////////////////////////////////////////////////////
//// ALQUILER ///////////////////////////////////////////////////
class alquiler extends oficial
{
  function alquiler(context)
  {
    oficial(context);
  }
  function datosLineaFactura(curLineaAlbaran)
  {
    return this.ctx.alquiler_datosLineaFactura(curLineaAlbaran);
  }
}
//// ALQUILER ///////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition alquiler */
/////////////////////////////////////////////////////////////////
//// ALQUILER ///////////////////////////////////////////////////
function alquiler_datosLineaFactura(curLineaAlb)
{
  var _i = this.iface;
  if (!_i.__datosLineaFactura(curLineaAlb)) {
    return false;
  }
  if (!curLineaAlb.isNull("fechadesdealq")) {
    _i.curLineaFactura.setValueBuffer("fechadesdealq", curLineaAlb.valueBuffer("fechadesdealq"));
  }
  if (!curLineaAlb.isNull("horadesdealq")) {
    _i.curLineaFactura.setValueBuffer("horadesdealq", curLineaAlb.valueBuffer("horadesdealq"));
  }
  if (!curLineaAlb.isNull("fechahastaalq")) {
    _i.curLineaFactura.setValueBuffer("fechahastaalq", curLineaAlb.valueBuffer("fechahastaalq"));
  }
  if (!curLineaAlb.isNull("horahastaalq")) {
    _i.curLineaFactura.setValueBuffer("horahastaalq", curLineaAlb.valueBuffer("horahastaalq"));
  }
  if (!curLineaAlb.isNull("idperiodoalq")) {
    _i.curLineaFactura.setValueBuffer("idperiodoalq", curLineaAlb.valueBuffer("idperiodoalq"));
  }
  return true;
}
