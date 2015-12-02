
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
  function consultarEnvio(curAlbaran: FLSqlCursor): Boolean {
    return this.ctx.envioWeb_consultarEnvio(curAlbaran);
  }
}
//// CONSULTA ENVIO /////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pubEnvioWeb */
/////////////////////////////////////////////////////////////////
//// PUB ENVIO WEB //////////////////////////////////////////////
class pubEnvioWeb extends ifaceCtx
{
  function pubEnvioWeb(context)
  {
    ifaceCtx(context);
  }
  function pub_consultarEnvio(curAlbaran: FLSqlCursor)
  {
    return this.consultarEnvio(curAlbaran);
  }
}
//// PUB ENVIO WEB //////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition envioWeb */
/////////////////////////////////////////////////////////////////
//// CONSULTA ENVIO /////////////////////////////////////////////
function envioWeb_init()
{
  this.iface.__init();
  connect(this.child("tbnConsultaEnvio"), "clicked()", this, "iface.tbnConsultaEnvio_clicked");
}

function envioWeb_tbnConsultaEnvio_clicked()
{
  var cursor: FLSqlCursor = this.cursor();
  if (!cursor.isValid()) {
    return;
  }
  this.iface.consultarEnvio(cursor);
}

function envioWeb_consultarEnvio(curAlbaran: FLSqlCursor): Boolean {
  var util: FLUtil = new FLUtil;
  var codAlbaran: String = curAlbaran.valueBuffer("codigo");
  if (!codAlbaran || codAlbaran == "")
  {
    return false;
  }

  var codAgencia: String = curAlbaran.valueBuffer("codagencia");
  if (!codAgencia || codAgencia == "")
  {
    MessageBox.warning(util.translate("scrits", "El albarán seleccionado no tiene asignada una agencia de transporte"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }

  var numExpedicion: String = curAlbaran.valueBuffer("numexpedicion");
  if (!numExpedicion || numExpedicion == "")
  {
    MessageBox.warning(util.translate("scrits", "El albarán seleccionado no tiene asignado un número de expedición"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }

  var url: String = util.sqlSelect("agenciastrans", "urlconsulta", "codagencia = '" + codAgencia + "'");
  if (!url || url == "")
  {
    MessageBox.warning(util.translate("scrits", "La agencia %1 no tiene definida una U.R.L. de consulta de envíos").arg(codAgencia), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }

  var nombreNavegador = util.readSettingEntry("scripts/flfactinfo/nombrenavegador");
  if (!nombreNavegador || nombreNavegador == "")
  {
    MessageBox.warning(util.translate("scripts", "No tiene establecido el nombre del navegador.\nDebe establecer este valor en la pestaña Configuración local del formulario de empresa"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }

  var codPostal: String = curAlbaran.valueBuffer("codpostal");
  url = url.replace("[CP]", codPostal);
  url = url.replace("[NE]", numExpedicion);
  var comando: Array = [nombreNavegador, url];
  var res: Array = flfactppal.iface.pub_ejecutarComandoAsincrono(comando);
}
//// CONSULTA ENVIO /////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
