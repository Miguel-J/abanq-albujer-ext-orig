
/** @class_declaration envioFax */
/////////////////////////////////////////////////////////////////
//// ENVIO FAX //////////////////////////////////////////////////
class envioFax extends oficial
{
  var datosFax: Array;
  function envioFax(context)
  {
    oficial(context);
  }
  function mostrarInformeVisor(visor: FLReportViewer): Boolean {
    return this.ctx.envioFax_mostrarInformeVisor(visor);
  }
}
//// ENVIO FAX //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition envioFax */
/////////////////////////////////////////////////////////////////
//// ENVIO FAX ///////////////////////////////////////////////////
function envioFax_mostrarInformeVisor(visor: FLReportViewer): Boolean {
  this.iface.visor_ = visor;
  this.iface.visor_.exec();
  return true;

  /*  try {
      this.iface.visor_ = visor;

      var f = new FLFormSearchDB( "customviewer" );
      f.setMainWidget();
      f.exec();
    } catch (e) {
      this.iface.__mostrarInformeVisor(visor);
    }*/
}
//// ENVIO FAX ///////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
