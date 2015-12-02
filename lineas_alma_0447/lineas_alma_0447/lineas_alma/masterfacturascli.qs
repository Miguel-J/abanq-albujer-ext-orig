
/** @class_declaration lineasAlma */
/////////////////////////////////////////////////////////////////
//// LINEAS ALMACEN /////////////////////////////////////////////
class lineasAlma extends oficial
{
  function lineasAlma(context)
  {
    oficial(context);
  }
  function copiadatosLineaFactura(curLineaFactura: FLSqlCursor): Boolean {
    return this.ctx.lineasAlma_copiadatosLineaFactura(curLineaFactura);
  }
}
//// LINEAS ALMACEN /////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition lineasAlma */
/////////////////////////////////////////////////////////////////
//// LINEAS ALMACEN ////////////////////////////////////////////
function lineasAlma_copiadatosLineaFactura(curLineaFactura: FLSqlCursor): Boolean {
  if (!this.iface.__copiadatosLineaFactura(curLineaFactura))
  {
    return false;
  }
  with(this.iface.curLineaFactura)
  {
    setValueBuffer("codalmacen", curLineaFactura.valueBuffer("codalmacen"));
  }
  return true;
}

//// LINEAS ALMACEN ////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
