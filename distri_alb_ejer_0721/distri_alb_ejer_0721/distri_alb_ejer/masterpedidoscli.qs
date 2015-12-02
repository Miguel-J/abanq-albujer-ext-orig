
/** @class_declaration distEjer */
/////////////////////////////////////////////////////////////////
//// DISTIBUCIÓN EJERCICIOS /////////////////////////////////////
class distEjer extends oficial
{
  function distEjer(context)
  {
    oficial(context);
  }
  function datosLineaAlbaran(curLineaPedido)
  {
    return this.ctx.distEjer_datosLineaAlbaran(curLineaPedido);
  }
}
//// DISTIBUCIÓN EJERCICIOS /////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition distEjer */
/////////////////////////////////////////////////////////////////
//// DISTRIBUCIÓN EJERCICIOS ////////////////////////////////////
function distEjer_datosLineaAlbaran(curLineaPedido)
{
  var _i = this.iface;

  var oCantidad = _i.dameCantidadLineaAlbaran(curLineaPedido);
  if (!oCantidad) {
    return false;
  }

  _i.curLineaAlbaran.setValueBuffer("canfactura", oCantidad.cantidad);
  if (!_i.__datosLineaAlbaran(curLineaPedido)) {
    return false;
  }

  return true;
}
//// DISTRIBUCIÓN EJERCICIOS ////////////////////////////////////
/////////////////////////////////////////////////////////////////
