
/** @class_declaration envioMailCrm */
/////////////////////////////////////////////////////////////////
//// ENVIO MIAL CRM /////////////////////////////////////////////
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
  function enviarEmailContactoPrincipal()
  {
    return this.ctx.envioMailCrm_enviarEmailContactoPrincipal();
  }
}
//// ENVIO MIAL CRM /////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition envioMailCrm */
/////////////////////////////////////////////////////////////////
//// ENVIO MIAL CRM /////////////////////////////////////////////
function envioMailCrm_enviarEmail()
{
  var cursor: FLSqlCursor = this.cursor();
  var util: FLUtil = new FLUtil();

  var codigo: String = "";
  var tabla: String = "";

  switch (cursor.valueBuffer("tipo")) {
    case "Cliente": {
      codigo = cursor.valueBuffer("codcliente");
      tabla = "clientes";
      break;
    }
    case "Proveedor": {
      codigo = cursor.valueBuffer("codproveedor");
      tabla = "proveedores";
      break;
    }
  }



  var email: String = flfactppal.iface.pub_componerListaDestinatarios(codigo, tabla);

  if (!email) {
    return;
  }
  var cuerpo: String = "";
  var asunto: String = "";

  var arrayDest: Array = [];
  arrayDest[0] = [];
  arrayDest[0]["tipo"] = "to";
  arrayDest[0]["direccion"] = email;

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

  var web: String = cursor.valueBuffer("web");
  if (!web)
  {
    MessageBox.warning(util.translate("scripts", "Debe informar la web."), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }

  var comando: Array = [nombreNavegador, web];
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

function envioMailCrm_enviarEmailContactoPrincipal()
{
  debug("envioMailCrm_enviarEmailContactoPrincipal");
  var cursor: FLSqlCursor = this.cursor();
  var util: FLUtil = new FLUtil();

  var codContacto: String = cursor.valueBuffer("codcontacto");
  if (!codContacto || codContacto == "")
    return;

  var emailContacto: String = util.sqlSelect("crm_contactos", "email", "codcontacto = '" + codContacto + "'");
  if (!emailContacto)
    return;

  var cuerpo: String = "";
  var asunto: String = "";

  var arrayDest: Array = [];
  arrayDest[0] = [];
  arrayDest[0]["tipo"] = "to";
  arrayDest[0]["direccion"] = emailContacto;

  var arrayAttach: Array = [];

  flfactppal.iface.pub_enviarCorreo(cuerpo, asunto, arrayDest, false);
}
//// ENVIO MIAL CRM /////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
