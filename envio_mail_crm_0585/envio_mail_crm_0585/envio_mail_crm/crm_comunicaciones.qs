
/** @class_declaration envioMailCrm */
/////////////////////////////////////////////////////////////////
//// ENVIO MAIL CRM /////////////////////////////////////////////
class envioMailCrm extends oficial
{
  function envioMailCrm(context)
  {
    oficial(context);
  }
  function enviarMail()
  {
    return this.ctx.envioMailCrm_enviarMail();
  }
}
//// ENVIO MAIL CRM /////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition envioMailCrm */
/////////////////////////////////////////////////////////////////
//// ENVIO MAIL CRM /////////////////////////////////////////////
function envioMailCrm_enviarMail()
{
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  if (cursor.valueBuffer("canal") != "E-mail") {
    MessageBox.warning(util.translate("scripts", "Para eviar un correo el canal de comunicación debe ser E-mail"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }

  if (cursor.valueBuffer("estado") == "Enviado") {
    var res: Number = MessageBox.information(util.translate("scripts", "El mensaje ya está marcado como enviado.\n¿Desea enviarlo de nuevo?"), MessageBox.Yes, MessageBox.No);
    if (res != MessageBox.Yes) {
      return;
    }
  }

  var qryAttach: FLSqlQuery = new FLSqlQuery;
  with(qryAttach) {
    setTablesList("crm_adjuntoscom");
    setSelect("ruta, nombre");
    setFrom("crm_adjuntoscom");
    setWhere("codcomunicacion = '" + cursor.valueBuffer("codcomunicacion") + "'");
    setForwardOnly(true);
  }
  if (!qryAttach.exec())
    return false;

  var arrayAttach: Array = [];
  var rutaFichero: String, i: Number = 0;
  while (qryAttach.next()) {
    rutaFichero = qryAttach.value("ruta") + "/" + qryAttach.value("nombre");
    if (!File.exists(rutaFichero)) {
      MessageBox.warning(util.translate("scripts", "No existe el fichero a adjuntar:\n%1").arg(rutaFichero), MessageBox.Ok, MessageBox.NoButton);
      return false;
    }
    arrayAttach[i] = rutaFichero;
    i++;
  }

  var cuerpo: String = cursor.valueBuffer("contenido");
  var asunto: String = cursor.valueBuffer("asunto");

  var arrayDest: Array = [];
  arrayDest[0] = [];
  arrayDest[0]["tipo"] = "to";
  arrayDest[0]["direccion"] = cursor.valueBuffer("destino");

  flfactppal.iface.pub_enviarCorreo(cuerpo, asunto, arrayDest, arrayAttach);

  var res: Number = MessageBox.information(util.translate("scripts", "¿Ha enviado correctamente el mensaje?"), MessageBox.Yes, MessageBox.No);
  if (res == MessageBox.Yes) {
    cursor.setValueBuffer("estado", "Enviado");
    this.accept();
  }
}
//// ENVIO MAIL CRM /////////////////////////////////////////////
/////////////////////////////////////////////////////////////////