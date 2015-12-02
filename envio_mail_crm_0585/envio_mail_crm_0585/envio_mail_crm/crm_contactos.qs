
/** @class_declaration envioMailCrm */
/////////////////////////////////////////////////////////////////
//// ENVIO MAIL CRM /////////////////////////////////////////////
class envioMailCrm extends oficial
{
  function envioMailCrm(context)
  {
    oficial(context);
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
function envioMailCrm_enviarEmailContacto()
{
  var cursor: FLSqlCursor = this.cursor();
  var util: FLUtil = new FLUtil();

  var emailContacto: String = cursor.valueBuffer("email");
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
//// ENVIO MAIL CRM /////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
