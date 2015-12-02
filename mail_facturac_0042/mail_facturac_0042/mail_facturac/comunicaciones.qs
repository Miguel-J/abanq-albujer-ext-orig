/***************************************************************************
                 se_comunicaciones.qs  -  description
                             -------------------
    begin                : lun jun 21 2005
    copyright            : (C) 2005 by InfoSiAL S.L.
    email                : mail@infosial.com
 ***************************************************************************/

/***************************************************************************
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
//  ***************************************************************************/

/** @file */
////////////////////////////////////////////////////////////////////////////
//// DECLARACION ///////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

/** @class_declaration interna */
//////////////////////////////////////////////////////////////////
//// INTERNA /////////////////////////////////////////////////////
class interna
{
  var ctx: Object;
  function interna(context)
  {
    this.ctx = context;
  }
  function init()
  {
    this.ctx.interna_init();
  }
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna
{
  var procesoMail: FLProcess;
  function oficial(context)
  {
    interna(context);
  }
  function selecDestinatario()
  {
    return this.ctx.oficial_selecDestinatario();
  }
  function setHora(cursor: FLSqlCursor)
  {
    return this.ctx.oficial_setHora(cursor);
  }
  function enviarDoc(cursor: FLSqlCursor, adjuntarDocumento: Boolean)
  {
    return this.ctx.oficial_enviarDoc(cursor, adjuntarDocumento);
  }
  function enviarMail(curCom: FLSqlCursor, fichPDF: String): Boolean { return this.ctx.oficial_enviarMail(curCom, fichPDF); }
  function generarPDF(accion: String, codigo: String): String { return this.ctx.oficial_generarPDF(accion, codigo); }
  function selecAdjuntos()
  {
    return this.ctx.oficial_selecAdjuntos();
  }
  function borrarAdjuntos()
  {
    return this.ctx.oficial_borrarAdjuntos();
  }
  function comprobarOpciones(): Boolean { return this.ctx.oficial_comprobarOpciones(); }
  function selecContacto(): Boolean { return this.ctx.oficial_selecContacto(); }
  function procesarEnvio(): Boolean { return this.ctx.oficial_procesarEnvio(); }
  function guardarPendiente(): Boolean { return this.ctx.oficial_guardarPendiente(); }
}
//// OFICIAL /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////
class head extends oficial
{
  function head(context)
  {
    oficial(context);
  }
}
//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration ifaceCtx */
/////////////////////////////////////////////////////////////////
//// INTERFACE  /////////////////////////////////////////////////
class ifaceCtx extends head
{
  function ifaceCtx(context)
  {
    head(context);
  }
  function pub_enviarMail(curCom: FLSqlCursor, fichPDF: String)
  {
    return this.enviarMail(curCom, fichPDF);
  }
  function pub_generarPDF(accion: String, codigo: String)
  {
    return this.generarPDF(accion, codigo);
  }
  function pub_enviarDoc(cursor: FLSqlCursor, adjuntarDocumento: Boolean)
  {
    return this.enviarDoc(cursor, adjuntarDocumento);
  }
}

const iface = new ifaceCtx(this);
//// INTERFACE  /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition interna */
////////////////////////////////////////////////////////////////////////////
//// DEFINICION ////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
//// INTERNA /////////////////////////////////////////////////////

function interna_init()
{
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  connect(this.child("pbnSelecDestinatario"), "clicked()", this, "iface.selecDestinatario");
  connect(this.child("pbnAdjuntos"), "clicked()", this, "iface.selecAdjuntos");
  connect(this.child("pbnBorrarAdjuntos"), "clicked()", this, "iface.borrarAdjuntos");
  connect(this.child("pbnSeleccionar"), "clicked()", this, "iface.selecContacto");
  connect(this.child("pbnEnviar"), "clicked()", this, "iface.procesarEnvio");
  connect(this.child("pbnGuardar"), "clicked()", this, "iface.guardarPendiente");

  if (cursor.modeAccess() == cursor.Insert)
    this.iface.setHora(cursor);

  this.child("fdbEstado").setDisabled(true);

  if (cursor.modeAccess() == cursor.Edit)
    this.child("pbnGuardar").setDisabled(true);

  if (this.child("fdbEstado").value() == 1)
    this.child("pbnEnviar").setDisabled(true);
  else
    this.child("pbnEnviar").setDisabled(false);

  //  this.child("gbxAdjuntos").setDisabled(true);
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////


/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////

/** \D Recibe el cursor de un documento de facturación y prepara el cursor de la comunicación
@param cursor Cursor del documento
*/
function oficial_enviarDoc(cursor: FLSqlCursor, adjuntarDocumento: Boolean)
{
  if (!this.iface.comprobarOpciones())
    return;

  var util: FLUtil = new FLUtil;

  var codigo: String = "";
  if (adjuntarDocumento)
    codigo = cursor.valueBuffer("codigo");

  var fecha = new Date();
  var nomEmpresa: String = flfactppal.iface.pub_valorDefectoEmpresa("nombre");

  //  var enviadoPor:String = nomEmpresa + " <" + flfactppal.iface.pub_valorDefectoEmpresa("email") + ">";

  // Datos del usuario
  var datosUsuario: Array;
  var miUsuario: String = util.readSettingEntry("scripts/flfactppal/miUsuario");
  if (miUsuario)
    datosUsuario = flfactppal.iface.pub_ejecutarQry("usuarios", "nombre,apellidos,email,firma", "codigo = '" + miUsuario + "'");
  else
    datosUsuario = flfactppal.iface.pub_ejecutarQry("usuarios", "nombre,apellidos,email,firma", "usuario = '" + sys.nameUser() + "'");

  var enviadoPor: String;
  if (datosUsuario.result > 0)
    enviadoPor = datosUsuario.email;
  if (!enviadoPor)
    enviadoPor = flfactppal.iface.pub_valorDefectoEmpresa("email");

  var tipoDoc: String = cursor.action();

  var asunto: String;
  switch (tipoDoc) {
    case "presupuestoscli":
      asunto = util.translate("scripts", "Presupuesto");
      break;
    case "pedidoscli":
    case "pedidosprov":
      asunto = util.translate("scripts", "Pedido");
      break;
    case "albaranescli":
    case "albaranesprov":
      asunto = util.translate("scripts", "Albarán");
      break;
    case "facturascli":
    case "facturasprov":
      asunto = util.translate("scripts", "Factura");
      break;
    case "clientes":
      asunto = util.translate("scripts", "Comunicación de cliente");
      break;
    case "proveedores":
      asunto = util.translate("scripts", "Comunicación de proveedor");
      break;
  }

  var para: String;
  var accionCom: String;
  // Cliente o proveedor
  switch (tipoDoc) {
    case "presupuestoscli":
    case "pedidoscli":
    case "albaranescli":
    case "facturascli":
    case "clientes":
      accionCom = "factcomunicacionescli";
      para = util.sqlSelect("clientes", "email", "codcliente = '" + cursor.valueBuffer("codcliente") + "'");
      break;
    case "pedidosprov":
    case "albaranesprov":
    case "facturasprov":
    case "proveedores":
      accionCom = "factcomunicacionesprov";
      para = util.sqlSelect("proveedores", "email", "codproveedor = '" + cursor.valueBuffer("codproveedor") + "'");
      break;
  }

  var f: Object = new FLFormSearchDB(accionCom);
  var curCom: FLSqlCursor = f.cursor();
  f.setMainWidget();

  curCom.setActivatedCheckIntegrity(false);
  curCom.setModeAccess(curCom.Insert);
  curCom.refreshBuffer();

  if (accionCom == "factcomunicacionescli")
    curCom.setValueBuffer("codcliente", cursor.valueBuffer("codcliente"));
  else
    curCom.setValueBuffer("codproveedor", cursor.valueBuffer("codproveedor"));

  var texto: String = "";
  /*  if (adjuntarDocumento)
      texto = util.translate ( "scripts", "Adjuntamos ") + asunto + " " + codigo;*/

  var cabecera: String = util.sqlSelect("comunicacionesopc", "cabecera", "");
  if (cabecera)
    texto = cabecera + "\n" + texto;

  var firma: String;
  if (datosUsuario.result > 0)
    firma = datosUsuario.firma;
  if (firma)
    texto += "\n" + firma;

  var pie: String = util.sqlSelect("comunicacionesopc", "pie", "");
  if (pie)
    texto += "\n" + pie;

  curCom.setValueBuffer("enviadopor", enviadoPor);
  curCom.setValueBuffer("para", para);
  curCom.setValueBuffer("fecha", fecha);
  curCom.setValueBuffer("hora", fecha.toString().substring(11, 16));
  curCom.setValueBuffer("texto", texto);
  curCom.setValueBuffer("asunto", asunto + " " + codigo);
  curCom.setValueBuffer("codigo", codigo);
  curCom.setValueBuffer("tipodoc", tipoDoc);

  flfactppal.iface.pub_setCurCom(curCom);

  var acpt: String = f.exec("id");
  if (acpt) {
    if (!curCom.commitBuffer())
      MessageBox.critical(util.translate("scripts", "Se produjo un error al registrar la comunicación"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
  }
}


function oficial_procesarEnvio(): Boolean {
  var util: FLUtil = new FLUtil;

  var curCom: FLSqlCursor = this.cursor();
  if (!curCom.valueBuffer("para"))
    curCom = flfactppal.iface.pub_getCurCom();

  var tipoDoc: String = curCom.action();

  if (!curCom.valueBuffer("para") || !curCom.valueBuffer("asunto") || !curCom.valueBuffer("enviadopor") || !curCom.valueBuffer("texto"))
  {
    MessageBox.information(util.translate("scripts", "Debes rellenar los valores de para, de, asunto y texto"),
    MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return;
  }

  util.createProgressDialog(util.translate("scripts", "Procesando datos"), 3);
  util.setProgress(1);

  var fichPDF: String = "";

  if (curCom.valueBuffer("codigo"))
  {
    util.setLabelText(util.translate("scripts", "Generando PDF"));
    fichPDF = this.iface.generarPDF(curCom.valueBuffer("tipodoc"), curCom.valueBuffer("codigo"));
    if (!fichPDF) {
      MessageBox.critical(util.translate("scripts", "Se produjo un error al generar el PDF. No se enviará el mensaje"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
      util.destroyProgressDialog();
      return;
    }
  }

  util.setLabelText(util.translate("scripts", "Enviando mensaje"));
  util.setProgress(2);

  if (!this.iface.enviarMail(curCom, fichPDF))
  {
    MessageBox.critical(util.translate("scripts", "Se produjo un error al enviar el mensaje."), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    util.destroyProgressDialog();
    return;
  }

  util.setProgress(3);
  util.destroyProgressDialog();

  var res = MessageBox.information(util.translate("scripts", "Pulse \"Aceptar\" para registrar la comunicación"),
                                   MessageBox.Ok, MessageBox.Cancel, MessageBox.NoButton);

  this.setDisabled(false);

  if (res == MessageBox.Ok)
  {
    var hoy = new Date();

    var ahora: String = hoy.toString().mid(11, 5);
    curCom.setValueBuffer("fecha", hoy);
    curCom.setValueBuffer("hora", ahora);
    curCom.setValueBuffer("estado", "Enviado");
    if (!curCom.commitBuffer())
      MessageBox.critical(util.translate("scripts", "Se produjo un error al registrar la comunicación"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    this.child("pushButtonAccept").animateClick();
  }

  return true;
}


function oficial_guardarPendiente(): Boolean {
  var util: FLUtil = new FLUtil;

  var curCom: FLSqlCursor = this.cursor();
  if (!curCom.valueBuffer("id"))
    curCom = flfactppal.iface.pub_getCurCom();

  var res = MessageBox.information(util.translate("scripts", "¿Guardar el mensaje como pendiente?"),
  MessageBox.Yes, MessageBox.No);

  if (res == MessageBox.Yes)
  {
    var hoy = new Date();
    var ahora: String = hoy.toString().mid(11, 5);
    curCom.setValueBuffer("fecha", hoy);
    curCom.setValueBuffer("hora", ahora);
    curCom.setValueBuffer("estado", "Pendiente");
    if (!curCom.commitBuffer())
      MessageBox.critical(util.translate("scripts", "Se produjo un error al registrar la comunicación"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    this.child("pushButtonAccept").animateClick();
  }

  return true;
}


/** \D Crea los campos de texto necesarios para el correo: asunto, cuerpo,
destino, etc. Estos campos son pasados como parámetros al comando kmail.
Para ejecutar el comando se introduce el mismo en un fichero ejecutable y se
ejecuta el mismo
\end */
function oficial_enviarMail(curCom: FLSqlCursor, fichPDF: String): Boolean {
  if (!curCom)
  {
    curCom = this.cursor();
  }

  var util: FLUtil = new FLUtil();

  var asunto: String = "\"" + curCom.valueBuffer("asunto") + "\"";
  var destinatario: String = curCom.valueBuffer("para");
  var enviadoPor: String =  "\"" + curCom.valueBuffer("enviadopor") + "\"";
  var cc: String = curCom.valueBuffer("cc");
  var bcc: String = curCom.valueBuffer("bcc");
  var adjuntos: String = curCom.valueBuffer("adjuntos");
  var cuerpo: String = curCom.valueBuffer("texto");
  var patternRE: RegExp = new RegExp("\"");
  patternRE.global = true;
  cuerpo = cuerpo.replace(patternRE, "'");

  var pathLocal: String = util.readSettingEntry("scripts/flfacturac/pathLocal");
  var programa: String = util.readSettingEntry("scripts/flfacturac/programaMail");
  var numArg: Number = 0;
  var argumentos: Array;
  var comando: String;

  var f = new File(pathLocal + "cuerpo.txt");
  f.open(File.WriteOnly);
  f.write(cuerpo);
  f.close();

  var opciones: Array;
  // Comando
  switch (programa)
  {
    case "mail":
      comando = "mail " + "-s " + asunto + " -r " + enviadoPor;
      if (cc) {
        comando += " -c " + cc;
      }
      if (bcc) {
        comando += " -b " + bcc;
      }
      if (adjuntos) {
        var arrayAdjuntos = adjuntos.split(",");
        for (var i: Number = 0; i < arrayAdjuntos.length; i++) {
          comando += " -a " + arrayAdjuntos[i];
        }
      }
      if (fichPDF && adjuntos != fichPDF) {
        comando += " -a " + fichPDF;
      }
      comando += " " + destinatario + " < " + pathLocal + "cuerpo.txt";
      break;

    case "kmail":
      comando = "kmail \"" + destinatario + "\" -s " + asunto + " --body \"" + cuerpo + "\"";
      if (cc) {
        comando += " -c " + cc;
      }
      if (bcc) {
        comando += " -b " + bcc;
      }
      if (adjuntos) {
        var arrayAdjuntos = adjuntos.split(",");
        for (var i: Number = 0; i < arrayAdjuntos.length; i++) {
          comando += " -attach " + arrayAdjuntos[i];
        }
      }
      if (fichPDF && adjuntos != fichPDF) {
        comando += " -attach " + fichPDF;
      }
      break;

    case "personalizado":

      comando = util.readSettingEntry("scripts/flfactppal/opcionComandoMailComando");
      comando += " " + util.readSettingEntry("scripts/flfactppal/opcionComandoMailAsunto");
      comando += " " + asunto;

      if (enviadoPor) {
        comando += " " + util.readSettingEntry("scripts/flfactppal/opcionComandoRemitente");
        comando += " " + enviadoPor;
      }
      if (cc) {
        comando += " " + util.readSettingEntry("scripts/flfactppal/opcionComandoCC");
        comando += " " + cc;
      }
      if (bcc) {
        comando += " " + util.readSettingEntry("scripts/flfactppal/opcionComandoBCC");
        comando += " " + bcc;
      }
      if (adjuntos) {
        var arrayAdjuntos = adjuntos.split(",");
        for (var i: Number = 0; i < arrayAdjuntos.length; i++) {
          comando += " " + util.readSettingEntry("scripts/flfactppal/opcionComandoAdjunto");
          comando += " " + arrayAdjuntos[i];
        }
      }
      if (fichPDF && adjuntos != fichPDF) {
        comando += " " + util.readSettingEntry("scripts/flfactppal/opcionComandoAdjunto");
        comando += " " + fichPDF;
      }
      comando += " " + destinatario + " < " + pathLocal + "cuerpo.txt";

      break;
  }

  var f = new File(pathLocal + "comandomail");
  f.open(File.WriteOnly);
  f.write(comando);
  f.close();

  Process.execute("chmod +x " + pathLocal + "comandomail");
  var proceso = new Process(pathLocal + "comandomail");

  //  this.iface.procesoMail = new FLProcess(pathLocal + "comandomail");
  //    connect(this.iface.procesoMail, "exited()", this, "iface.mailEnviado");

  try {
    proceso.start();
  } catch (e)
  {
    MessageBox.critical(util.translate("scripts", "Se produjo un error al ejecutar el comando de email."), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return false;
  }

  return true;
}



/** \D Genera el documento PDF en disco
@param accion Nombre de la accion (presupuestoscli, pedidoscli, etc)
@param codigo Código del documento de facturación a convertir
@return Ruta completa al fichero PDF resultante
*/
function oficial_generarPDF(accion: String, codigo: String): String {
  var util: FLUtil = new FLUtil();

  var pathLocal: String = util.readSettingEntry("scripts/flfacturac/pathLocal");

  var fichPS: String = pathLocal + "tmp.ps";
  var fichPDF: String = pathLocal + codigo + ".pdf";
  var nombreReport: String = "i_" + accion;
  var q: FLSqlQuery = new FLSqlQuery(nombreReport);
  q.setWhere(accion + ".codigo = '" + codigo + "'");

  if (!q.exec())
  {
    MessageBox.critical(util.translate("scripts", "Falló la consulta"), MessageBox.Ok, MessageBox.NoButton);
    return;
  }

  var rptViewer: FLReportViewer = new FLReportViewer(nombreReport);
  rptViewer.setReportTemplate(nombreReport);
  rptViewer.setReportData(q);
  rptViewer.renderReport(0, 0);
  rptViewer.printReportToPDF(fichPDF);

  return fichPDF;
}

/** \D Busca el destinatario en la tabla de clientes/proveedores. Cuando hay varios
contactos en la agenda del cliente permite seleccionar uno de ellos
\end */
function oficial_selecDestinatario()
{
  var util: FLUtil = new FLUtil();
  var arrayMails: Array = [];

  var nomCampo: String, nomTabla: String, nomFdb: String;

  if (this.child("fdbCodCliente")) {
    nomCampo = "codcliente" ;
    nomTabla = "clientes" ;
    nomFdb = "fdbCodCliente" ;
  } else {
    nomCampo = "codproveedor" ;
    nomTabla = "proveedores" ;
    nomFdb = "fdbCodProveedor" ;
  }

  var emailPrincipal: String = util.sqlSelect(nomTabla, "email", nomCampo + " = '" + this.child(nomFdb).value() + "'");
  var nombrePrincipal: String = util.sqlSelect(nomTabla, "nombre", nomCampo + " = '" + this.child(nomFdb).value() + "'");

  var q: FLSqlQuery = new FLSqlQuery();
  q.setTablesList("contactos" + nomTabla);
  q.setFrom("contactos" + nomTabla);
  q.setSelect("email,contacto");
  q.setWhere(nomCampo + " = '" + this.child(nomFdb).value() + "'");
  if (!q.exec()) return false;

  var dialog = new Dialog(util.translate("scripts", "Contactos"), 0);
  dialog.caption = "Selecciona el destinatario";
  dialog.OKButtonText = util.translate("scripts", "Aceptar");
  dialog.cancelButtonText = util.translate("scripts", "Cancelar");

  var bgroup: GroupBox = new GroupBox;
  dialog.add(bgroup);
  var cB: Array = [];
  var nEmails: Number = 0;

  cB[nEmails] = new CheckBox;
  cB[nEmails].text = util.translate("scripts", nombrePrincipal + " (" + emailPrincipal + ")");
  arrayMails[nEmails] = emailPrincipal;
  cB[nEmails].checked = true;
  bgroup.add(cB[nEmails]);
  nEmails ++;

  while (q.next())  {
    cB[nEmails] = new CheckBox;
    cB[nEmails].text = util.translate("scripts", q.value(1) + " (" + q.value(0) + ")");
    arrayMails[nEmails] = q.value(0);
    cB[nEmails].checked = false;
    bgroup.add(cB[nEmails]);
    nEmails ++;
  }
  if (nEmails > 1) {
    nEmails --;
    var lista: String = "";
    if (dialog.exec()) {
      for (var i: Number = 0; i <= nEmails; i++)
        if (cB[i].checked == true)
          lista += arrayMails[i] + ",";
    } else
      return;
    lista = lista.left(lista.length - 1)
            if (lista == "")
              return;
    this.child("fdbPara").setValue(lista);
  } else
    this.child("fdbPara").setValue(emailPrincipal);

}

/** \D Actualiza el campo de hora a la hora actual
*/
function oficial_setHora(curCom: FLSqlCursor)
{
  var d = new Date();
  var s: String = d.toString(); // s == "1975-12-25T22:30:00"
  curCom.setValueBuffer("hora", s.substring(11, 16));
}

function oficial_selecAdjuntos()
{
  var util: FLUtil = new FLUtil();
  var arrayAdjuntos = FileDialog.getOpenFileNames("", "", util.translate("scripts", "Buscar adjuntos"));
  if (!arrayAdjuntos)
    return;

  adjuntos = "";
  this.child("fdbAdjuntos").setValue("");
  this.child("lblAdjuntos").text = "";

  var file;
  for (var i: Number = 0; i < arrayAdjuntos.length; i++) {

    if (this.child("lblAdjuntos").text) {
      adjuntos += ",";
      this.child("lblAdjuntos").text += ",";
    }

    file = new File(arrayAdjuntos[i]);
    this.child("lblAdjuntos").text += file.name;

    adjuntos += arrayAdjuntos[i];
  }

  this.child("fdbAdjuntos").setValue(adjuntos);
}

function oficial_borrarAdjuntos()
{
  var util: FLUtil = new FLUtil();
  this.child("lblAdjuntos").text = "";
  this.child("fdbAdjuntos").setValue("");
}

function oficial_comprobarOpciones(): Boolean {
  var util: FLUtil = new FLUtil;

  var pathLocal: String = util.readSettingEntry("scripts/flfacturac/pathLocal");
  var programa: String = util.readSettingEntry("scripts/flfacturac/programaMail");

  if (!pathLocal || !programa)
  {
    MessageBox.information(util.translate("scripts", "Debe establecer las opciones para las comunicaciones"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return false;
  }
  return true;
}

/** \D Establece la dirección del destinatario desde la pestaña de contactos
\end */
function oficial_selecContacto()
{
  var util: FLUtil = new FLUtil();

  var curTab: FLSqlCursor = this.child("tdbContactos").cursor();
  var email: String = curTab.valueBuffer("email");

  if (!email) {
    MessageBox.information(util.translate("scripts", "No hay un contacto seleccionado o el contacto no tiene email"),
                           MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return;
  }

  this.child("fdbPara").setValue(email);

  MessageBox.information(util.translate("scripts", "Se ha establecido el email del contacto como destinatario"),
                         MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
