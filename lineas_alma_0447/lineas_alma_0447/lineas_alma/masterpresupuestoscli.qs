
/** @class_declaration lineasAlma */
/////////////////////////////////////////////////////////////////
//// ALMACÉN POR LÍNEA //////////////////////////////////////////
class lineasAlma extends oficial
{
  function lineasAlma(context)
  {
    oficial(context);
  }
  function datosLineaPedido(curLineaPresupuesto: FLSqlCursor): Boolean {
    return this.ctx.lineasAlma_datosLineaPedido(curLineaPresupuesto);
  }
}
//// ALMACÉN POR LÍNEA //////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition lineasAlma */
/////////////////////////////////////////////////////////////////
//// ALMACÉN POR LÍNEA //////////////////////////////////////////
function lineasAlma_datosLineaPedido(curLineaPresupuesto: FLSqlCursor): Boolean {
  if (!this.iface.__datosLineaPedido(curLineaPresupuesto))
  {
    return false;
  }

  with(this.iface.curLineaPedido)
  {
    setValueBuffer("codalmacen", curLineaPresupuesto.valueBuffer("codalmacen"));
  }
  return true;
}

//// ALMACÉN POR LÍNEA //////////////////////////////////////////
/////////////////////////////////////////////////////////////////
