
/** @class_declaration extraescolar */
/////////////////////////////////////////////////////////////////
//// EXTRAESCOLAR ///////////////////////////////////////////////
class extraescolar extends oficial
{
  function extraescolar(context)
  {
    oficial(context);
  }
  function datosReciboCli(curFactura, oRecibo)
  {
    return this.ctx.extraescolar_datosReciboCli(curFactura, oRecibo);
  }
}
//// EXTRAESCOLAR ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition extraescolar */
/////////////////////////////////////////////////////////////////
//// EXTRAESCOLAR ///////////////////////////////////////////////
function extraescolar_datosReciboCli(curFactura, oRecibo)
{
  debug("extraescolar_datosReciboCli");
  var _i = this.iface;
  if (!_i.__datosReciboCli(curFactura, oRecibo)) {
    return false;
  }
  debug("extraescolar_datosReciboCli " + curFactura.valueBuffer("codcentroesc"));
  _i.curReciboCli.setValueBuffer("codcentroesc", curFactura.valueBuffer("codcentroesc"));
  return true;
}
//// EXTRAESCOLAR ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
