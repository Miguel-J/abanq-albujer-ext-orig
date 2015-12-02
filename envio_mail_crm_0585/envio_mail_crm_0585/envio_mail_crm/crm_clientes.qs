
/** @class_declaration envioMailCrm */
/////////////////////////////////////////////////////////////////
//// ENVIO MAIL CRM /////////////////////////////////////////////
class envioMailCrm extends oficial
{
  function envioMailCrm(context)
  {
    oficial(context);
  }
  function enviarEmail()
  {
    return this.ctx.envioMailCrm_enviarEmail();
  }
  function accesoWeb(): Boolean {
    return this.ctx.envioMailCrm_accesoWeb();
  }
  function enviarEmailContacto()
  {
    return this.ctx.envioMailCrm_enviarEmailContacto();
  }
}
//// ENVIO MAIL CRM /////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition envioMailCrm */
/////////////////////////////////////////////////////////////////
//// ENVIO MAIL CRM /////////////////////////////////////////////
function envioMailCrm_enviarEmail()
{
  var cursor: FLSqlCursor = this.cursor();
  var util: FLUtil = new FLUtil();

  var codCliente: String = cursor.valueBuffer("codcliente");
  var tabla: String = "clientes";
  var emailCliente: String = flfactppal.iface.pub_componerListaDestinatarios(codCliente, tabla);

  if (!emailCliente) {
    return;
  }
  var cuerpo: String = "";
  var asunto: String = "";

  var arrayDest: Array = [];
  arrayDest[0] = [];
  arrayDest[0]["tipo"] = "to";
  arrayDest[0]["direccion"] = emailCliente;

  var arrayAttach: Array = [];

  flfactppal.iface.pub_enviarCorreo(cuerpo, asunto, arrayDest, false);
}

function envioMailCrm_accesoWeb(): Boolean {
  var cursor: FLSqlCursor = this.cursor();
  var util: FLUtil = new FLUtil();

  var nombreNavegador = util.readSettingEntry("scripts/flfactinfo/nombrenavegador");
  if (!nombreNavegador || nombreNavegador == "")
  {
    MessageBox.warning(util.translate("scripts", "No tiene establecido el nombre del navegador.\nDebe establecer este valor en la pestaña Correo del formulario de empresa"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }

  var webCliente: String = cursor.valueBuffer("web");
  if (!webCliente)
  {
    MessageBox.warning(util.translate("scripts", "Debe informar la web del cliente"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }

  var comando: Array = [nombreNavegador, webCliente];
  var res: Array = flfactppal.iface.pub_ejecutarComandoAsincrono(comando);

  return true;
}

function envioMailCrm_enviarEmailContacto()
{
  var cursor: FLSqlCursor = this.cursor();
  var util: FLUtil = new FLUtil();

  var emailContacto: String = this.child("tdbContactos").cursor().valueBuffer("email");

  if (!emailContacto || emailContacto == "") {
    MessageBox.warning(util.translate("scripts", "El contacto no tiene el campo email informado."), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  var cuerpo: String = "";
  var asunto: String = "";

  var arrayDest: Array = [];
  arrayDest[0] = [];
  arrayDest[0]["tipo"] = "to";
  arrayDest[0]["direccion"] = emailContacto;

  var arrayAttach: Array = [];

  flfactppal.iface.pub_enviarCorreo(cuerpo, asunto, arrayDest, false);
}
//// ENVIO MAIL CRM /////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
