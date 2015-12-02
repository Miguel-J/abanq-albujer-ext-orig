
/** @class_declaration envioWeb */
/////////////////////////////////////////////////////////////////
//// CONSULTA ENVIO /////////////////////////////////////////////
class envioWeb extends oficial
{
  function envioWeb(context)
  {
    oficial(context);
  }
  function init()
  {
    return this.ctx.envioWeb_init();
  }
  function tbnConsultaEnvio_clicked()
  {
    return this.ctx.envioWeb_tbnConsultaEnvio_clicked();
  }
}
//// CONSULTA ENVIO /////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition envioWeb */
/////////////////////////////////////////////////////////////////
//// CONSULTA ENVIO /////////////////////////////////////////////
function envioWeb_init()
{
  this.iface.__init();
  connect(this.child("tbnConsultaEnvio"), "clicked()", this, "iface.tbnConsultaEnvio_clicked()");
}

function envioWeb_tbnConsultaEnvio_clicked()
{
  var curAlbaran: FLSqlCursor = this.child("tdbAlbaranes").cursor();
  if (!curAlbaran) {
    return;
  }
  formalbaranescli.iface.pub_consultarEnvio(curAlbaran);
}

//// CONSULTA ENVIO /////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
