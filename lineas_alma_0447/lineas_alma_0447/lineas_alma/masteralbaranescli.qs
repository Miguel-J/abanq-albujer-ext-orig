
/** @class_declaration lineasAlma */
/////////////////////////////////////////////////////////////////
//// ALMACÉN POR LÍNEA //////////////////////////////////////////
class lineasAlma extends oficial
{
  function lineasAlma(context)
  {
    oficial(context);
  }
  function datosLineaFactura(curLineaAlbaran: FLSqlCursor): Boolean {
    return this.ctx.lineasAlma_datosLineaFactura(curLineaAlbaran);
  }
}
//// ALMACÉN POR LÍNEA //////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition lineasAlma */
/////////////////////////////////////////////////////////////////
//// ALMACÉN POR LÍNEA //////////////////////////////////////////
function lineasAlma_datosLineaFactura(curLineaAlbaran: FLSqlCursor): Boolean {
  if (!this.iface.__datosLineaFactura(curLineaAlbaran))
  {
    return false;
  }

  with(this.iface.curLineaFactura)
  {
    setValueBuffer("codalmacen", curLineaAlbaran.valueBuffer("codalmacen"));
  }
  return true;
}

//// ALMACÉN POR LÍNEA //////////////////////////////////////////
/////////////////////////////////////////////////////////////////
