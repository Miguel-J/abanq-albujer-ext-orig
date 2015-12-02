
/** @class_declaration numLinea */
/////////////////////////////////////////////////////////////////
//// NUMEROS DE LÍNEA ///////////////////////////////////////////
class numLinea extends oficial
{
  var numLinea_;
  function numLinea(context)
  {
    oficial(context);
  }
  function crearFactura(curComanda)
  {
    return this.ctx.numLinea_crearFactura(curComanda);
  }
  function datosLineaFactura(curLineaComanda)
  {
    return this.ctx.numLinea_datosLineaFactura(curLineaComanda);
  }
  function modificarFactura(curComanda, idFactura)
  {
    return this.ctx.numLinea_modificarFactura(curComanda, idFactura);
  }
}
//// NUMEROS DE LÍNEA ///////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition numLinea */
/////////////////////////////////////////////////////////////////
//// NÚMEROS DE LÍNEA ///////////////////////////////////////////
function numLinea_crearFactura(curComanda)
{
  var _i = this.iface;
  _i.numLinea_ = 0;

  var idFactura = _i.__crearFactura(curComanda);
  if (!idFactura) {
    return false;
  }
  return idFactura;
}

function numLinea_modificarFactura(curComanda, idFactura)
{
  var _i = this.iface;
  _i.numLinea_ = 0;

  var idFactura = _i.__modificarFactura(curComanda, idFactura);
  if (!idFactura) {
    return false;
  }
  return idFactura;
}

function numLinea_datosLineaFactura(curLineaComanda)
{
  var _i = this.iface;
  if (!_i.__datosLineaFactura(curLineaComanda)) {
    return false;
  }

  _i.numLinea_++;
  _i.curLineaFactura.setValueBuffer("numlinea", _i.numLinea_);

  return true;
}
//// NÚMEROS DE LÍNEA ///////////////////////////////////////////
/////////////////////////////////////////////////////////////////
