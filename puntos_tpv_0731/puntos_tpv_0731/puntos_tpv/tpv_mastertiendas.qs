
/** @class_declaration puntosTpv */
/////////////////////////////////////////////////////////////////
//// PUNTOS TPV /////////////////////////////////////////////////
class puntosTpv extends oficial
{
  function puntosTpv(context)
  {
    oficial(context);
  }
  function sincronizarComanda(curVentasTienda, cxCentral, cxTienda)
  {
    return this.ctx.puntosTpv_sincronizarComanda(curVentasTienda, cxCentral, cxTienda);
  }
}
//// PUNTOS TPV /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition puntosTpv */
/////////////////////////////////////////////////////////////////
//// PUNTOS TPV /////////////////////////////////////////////////
function puntosTpv_sincronizarComanda(curVentasTienda, cxCentral, cxTienda)
{
  var _i = this.iface;
  if (!_i.__sincronizarComanda(curVentasTienda, cxCentral, cxTienda)) {
    return false;
  }
  if (!flfact_tpv.iface.gestionPuntos(_i.curComandaCentral_)) {
    return false;
  }

  return true;
}
//// PUNTOS TPV /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
