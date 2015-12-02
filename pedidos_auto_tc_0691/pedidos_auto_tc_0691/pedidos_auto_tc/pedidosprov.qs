
/** @class_declaration pedautotc */
/////////////////////////////////////////////////////////////////
//// PEDIDOS_AUTO_TC ////////////////////////////////////////////
class pedautotc extends pedidosauto
{
  function pedautotc(context)
  {
    pedidosauto(context);
  }
  function datosLineaPedido(idPedido, eArticulo)
  {
    return this.ctx.pedautotc_datosLineaPedido(idPedido, eArticulo);
  }
}
//// PEDIDOS_AUTO_TC ////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition pedautotc */
/////////////////////////////////////////////////////////////////
//// PEDIDOS_AUTO_TC ////////////////////////////////////////////
function pedautotc_datosLineaPedido(idPedido, eArticulo)
{
  if (!this.iface.__datosLineaPedido(idPedido, eArticulo)) {
    return false;
  }

  var barcode = eArticulo.attribute("Barcode");
  var talla = eArticulo.attribute("Talla");
  var color = eArticulo.attribute("Color");

  with(this.iface.curLineaPedido) {
    setValueBuffer("barcode", barcode);
    setValueBuffer("talla", talla);
    setValueBuffer("color", color);
  }
  return true;
}

//// PEDIDOS_AUTO_TC ////////////////////////////////////////////
//////////////////////////////////////////////////////////////
