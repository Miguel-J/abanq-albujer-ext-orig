
/** @class_declaration lineasAlma */
/////////////////////////////////////////////////////////////////
//// ALMACÉN POR LÍNEA //////////////////////////////////////////
class lineasAlma extends oficial
{
  function lineasAlma(context)
  {
    oficial(context);
  }
  function datosLineaAlbaran(curLineaPedido: FLSqlCursor): Boolean {
    return this.ctx.lineasAlma_datosLineaAlbaran(curLineaPedido);
  }
}
//// ALMACÉN POR LÍNEA //////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition lineasAlma */
/////////////////////////////////////////////////////////////////
//// ALMACÉN POR LÍNEA //////////////////////////////////////////
function lineasAlma_datosLineaAlbaran(curLineaPedido: FLSqlCursor): Boolean {
  if (!this.iface.__datosLineaAlbaran(curLineaPedido))
  {
    return false;
  }

  with(this.iface.curLineaAlbaran)
  {
    setValueBuffer("codalmacen", curLineaPedido.valueBuffer("codalmacen"));
  }
  return true;
}

//// ALMACÉN POR LÍNEA //////////////////////////////////////////
/////////////////////////////////////////////////////////////////
