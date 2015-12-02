
/** @class_declaration pedMarco */
/////////////////////////////////////////////////////////////////
//// PEDIDOS MARCO //////////////////////////////////////////////
class pedMarco extends oficial
{
  function pedMarco(context)
  {
    oficial(context);
  }
  function datosLineaPedido(curLineaPresupuesto)
  {
    return this.ctx.pedMarco_datosLineaPedido(curLineaPresupuesto);
  }
}
//// PEDIDOS MARCO //////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition pedMarco */
/////////////////////////////////////////////////////////////////
//// PEDIDOS MARCO //////////////////////////////////////////////
function pedMarco_datosLineaPedido(curLineaPresupuesto)
{
  var _i = this.iface;
  if (!_i.__datosLineaPedido(curLineaPresupuesto)) {
    return false;
  }
  if (!curLineaPresupuesto.isNull("idlineapedidomarco")) {
    _i.curLineaPedido.setValueBuffer("idlineapedidomarco", curLineaPresupuesto.valueBuffer("idlineapedidomarco"));
  }
  if (!curLineaPresupuesto.isNull("codpedidomarco")) {
    _i.curLineaPedido.setValueBuffer("codpedidomarco", curLineaPresupuesto.valueBuffer("codpedidomarco"));
  }
  return true;
}
//// PEDIDOS MARCO //////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
