
/** @class_declaration servclinl */
/////////////////////////////////////////////////////////////////
//// NUM LÍNEA POR SERV CLI ////////////////////////////
class servclinl extends oficial
{
  function servclinl(context)
  {
    oficial(context);
  }
  function datosLineaServicio(datosArt: Array): Boolean {
    return this.ctx.servclinl_datosLineaServicio(datosArt);
  }
}
//// NUM LÍNEA POR SERV CLI ////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition servclinl */
/////////////////////////////////////////////////////////////////
//// NUM LÍNEA POR SERV CLI ////////////////////////////
function servclinl_datosLineaServicio(datosArt: Array): Boolean {
  this.iface.curLineaServicio_.setValueBuffer("numlinea", formRecordlineaspedidoscli.iface.pub_commonCalculateField("numlinea", this.iface.curLineaServicio_));
  return true;
}
//// NUM LÍNEA POR SERV CLI ////////////////////////////
/////////////////////////////////////////////////////////////////
