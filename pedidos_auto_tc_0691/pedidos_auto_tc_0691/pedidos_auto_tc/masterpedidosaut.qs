
/** @class_declaration pedautotc */
/////////////////////////////////////////////////////////////////
//// PEDIDOS_AUTO_TC ////////////////////////////////////////////
class pedautotc extends oficial
{
  function pedautotc(context)
  {
    oficial(context);
  }
  function datosLineaPedido(curLineaPedidoAut: FLSqlCursor): Boolean {
    return this.ctx.pedautotc_datosLineaPedido(curLineaPedidoAut);
  }
}
//// PEDIDOS_AUTO_TC ////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition pedautotc */
/////////////////////////////////////////////////////////////////
//// PEDIDOS_AUTO_TC ///////////////////////////////////////////
function pedautotc_datosLineaPedido(curLineaPedidoAut)
{
  if (!this.iface.__datosLineaPedido(curLineaPedidoAut)) {
    return false;
  }
  with(this.iface.curLineaPedido) {
    setValueBuffer("barcode", curLineaPedidoAut.valueBuffer("barcode"));
    setValueBuffer("talla", curLineaPedidoAut.valueBuffer("talla"));
    setValueBuffer("color", curLineaPedidoAut.valueBuffer("color"));
  }
  return true;
}

//// PEDIDOS_AUTO_TC ///////////////////////////////////////////
/////////////////////////////////////////////////////////////////
