/***************************************************************************
                          mt_backups.qs
                            -------------------
   begin                : jue ene 20 2005
   copyright            : (C) 2005 by InfoSiAL S.L.
   email                : mail@infosial.com
***************************************************************************/
/***************************************************************************
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; version 2 of the License.               *
 ***************************************************************************/
/***************************************************************************
   Este  programa es software libre. Puede redistribuirlo y/o modificarlo
   bajo  los  términos  de  la  Licencia  Pública General de GNU   en  su
   versión 2, publicada  por  la  Free  Software Foundation.
 ***************************************************************************/

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
  function validateForm(): Boolean { return this.ctx.interna_validateForm(); }
  function calculateCounter(): String { return this.ctx.interna_calculateCounter(); }
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna
{
  var procesoBackup: FLProcess;
  var procesoBorrar: FLProcess;
  var procesoCrear: FLProcess;
  var procesoRestaurar: FLProcess;
  function oficial(context)
  {
    interna(context);
  }
  function lanzarBackup()
  {
    return this.ctx.oficial_lanzarBackup();
  }
  function lanzarPreRestauracion()
  {
    return this.ctx.oficial_lanzarPreRestauracion();
  }
  function lanzarRestauracion()
  {
    return this.ctx.oficial_lanzarRestauracion();
  }
  function lanzarCreacion()
  {
    return this.ctx.oficial_lanzarCreacion();
  }
  function checkBackup()
  {
    return this.ctx.oficial_checkBackup();
  }
  function checkBorrado()
  {
    return this.ctx.oficial_checkBorrado();
  }
  function checkCreacion()
  {
    return this.ctx.oficial_checkCreacion();
  }
  function checkRestore()
  {
    return this.ctx.oficial_checkRestore();
  }
  function cambioTipoBD(tipoBD: Number)
  {
    return this.ctx.oficial_cambioTipoBD(tipoBD);
  }
  function sustituyeString(texto, cadena1, cadena2): String {
    return this.ctx.oficial_sustituyeString(texto, cadena1, cadena2);
  }
  function selecMsg(campo: String): String {
    return this.ctx.oficial_selecMsg(campo);
  }
  function selecComando(campo: String): String {
    return this.ctx.oficial_selecComando(campo);
  }
  function bloquearForm(bloqueo: Boolean)
  {
    return this.ctx.oficial_bloquearForm(bloqueo);
  }
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
}

const iface = new ifaceCtx(this);
//// INTERFACE  /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////
//// DEFINICION ////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

/** @class_definition interna */
//////////////////////////////////////////////////////////////////
//// INTERNA /////////////////////////////////////////////////////

function init()
{
  this.iface.init();
}

/** \C
\end */
function interna_init()
{
  var cursor: FLSqlCursor = this.cursor();
  connect(this.child("pbnLanzarBakup"), "clicked()", this, "iface.lanzarBackup()");
  connect(this.child("pbnLanzarRestauracion"), "clicked()", this, "iface.lanzarPreRestauracion()");

  if (this.child("fdbBaseDatosRestExi").value())
    this.child("rbnExistente").setChecked(true);
  if (this.child("fdbBaseDatosRestNue").value())
    this.child("rbnNueva").setChecked(true);

  this.iface.cambioTipoBD();
  connect(this.child("bgtTipoBD"), "clicked(int)", this, "iface.cambioTipoBD");

  if (cursor.modeAccess() == cursor.Insert) {
    this.child("fdbFichero").setValue(this.child("fdbBaseDatos").value() + "_" + this.child("fdbFecha").value() + ".sql");
    this.child("gbxRestaurar").setDisabled(true);
  } else
    this.child("gbxBackup").setDisabled(true);

  this.child("fdbFecha").setDisabled(true);
  this.child("fdbFechaRest").setDisabled(true);
}

function interna_validateForm(): Boolean {
  if (this.cursor().modeAccess() != this.cursor().Insert)
    return true;

  var util: FLUtil = new FLUtil();
  var fichero: String = this.child("fdbFichero").value();
  var rutaTrabajo: String = util.readSettingEntry("scripts/flmantppal/dirRutaBackups");

  if (!File.exists(rutaTrabajo + fichero))
  {
    MessageBox.critical(util.translate("scripts", "No existe el fichero. Para guardar el registro deberá crear el backup"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return false;
  }

  return true;
}

function interna_calculateCounter()
{
}


//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////

function oficial_lanzarBackup()
{
  var util: FLUtil = new FLUtil();

  var comando: String = this.iface.selecComando("comandobackup");
  if (!comando) {
    MessageBox.critical(util.translate("scripts", "No existe un comando de volcado de backup definido para el sistema opertativo actual\nDebe definir el comando en la tabla de comandos"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return;
  }

  var baseDatos: String = this.child("fdbBaseDatos").value()
                          var usuario: String = sys.nameUser();
  var fichero: String = this.child("fdbFichero").value();
  var rutaTrabajo: String = util.readSettingEntry("scripts/flmantppal/dirRutaBackups");

  if (!baseDatos || !fichero) {
    MessageBox.critical(util.translate("scripts", "La base de datos y el fichero no pueden ser nulos"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return;
  }

  if (!rutaTrabajo) {
    MessageBox.critical(util.translate("scripts", "No se ha definido la ruta en disco a los ficheros de backup\nDebe definir la ruta en las opciones"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return;
  }

  if (!File.isDir(rutaTrabajo)) {
    MessageBox.critical(util.translate("scripts", "La ruta en disco a los ficheros de backup es incorrecta\nDebe corregir la ruta en las opciones"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return;
  }

  if (File.exists(rutaTrabajo + fichero)) {
    var res = MessageBox.information(util.translate("scripts", "El fichero ya existe\n¿Desea sobreescribirlo?"), MessageBox.Yes, MessageBox.No, MessageBox.NoButton);
    if (res != MessageBox.Yes)
      return;
  }

  if (!this.iface.selecMsg("backupok")) {
    MessageBox.critical(util.translate("scripts", "No se ha definido el mensajes de volcado de backup\nHágalo en las opciones"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return;
  }

  comando = this.iface.sustituyeString(comando, "%base_datos%", baseDatos);
  comando = this.iface.sustituyeString(comando, "%usuario%", usuario);
  comando = this.iface.sustituyeString(comando, "%fichero%", fichero);

  this.child("leEstado").text = util.translate("scripts", "Creando backup...")
                                this.iface.bloquearForm(true);

  var argumentos: Array = comando.split(" ");
  this.iface.procesoBackup = new FLProcess(argumentos[0]);
  this.iface.procesoBackup.setWorkingDirectory(rutaTrabajo);
  for (var i = 1; i < argumentos.length; i++) {
    this.iface.procesoBackup.addArgument(argumentos[i]);
  }

  connect(this.iface.procesoBackup, "exited()", this, "iface.checkBackup");
  this.iface.procesoBackup.start();
}


function oficial_lanzarPreRestauracion()
{
  var util: FLUtil = new FLUtil();

  var comando: String = this.iface.selecComando("comandorestore");
  if (!comando) {
    MessageBox.critical(util.translate("scripts", "No existe un comando de restauración de backup definido para el sistema opertativo actual\nDebe definir el comando en la tabla de comandos"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return;
  }

  var comandoCreate: String = this.iface.selecComando("comandocreate");
  if (!comandoCreate) {
    MessageBox.critical(util.translate("scripts", "No existe un comando de creación de base de datos definido para el sistema opertativo actual\nDebe definir el comando en la tabla de comandos"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return;
  }

  var baseDatos: String;
  var tipoBD: String = "";

  if (this.child("fdbBaseDatosRestExi").value()) {
    tipoBD = "existente";
    baseDatos = this.child("fdbBaseDatosRestExi").value();
  }
  if (this.child("fdbBaseDatosRestNue").value()) {
    tipoBD = "nueva";
    baseDatos = this.child("fdbBaseDatosRestNue").value();
  }

  if (!this.iface.selecMsg("createok") || !this.iface.selecMsg("delok")) {
    MessageBox.critical(util.translate("scripts", "No se ha definido alguno de los mensajes de creación/eliminación de base de datos\nHágalo en las opciones"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return;
  }

  if (!tipoBD) {
    MessageBox.critical(util.translate("scripts", "Debe indicar una base de datos, existente o nueva"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return;
  }

  if (sys.nameBD() == baseDatos) {
    MessageBox.critical(util.translate("scripts", "No es posible restaurar el backup en la base de datos en uso"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return;
  }

  if (tipoBD == "existente") {
    var res = MessageBox.warning(util.translate("scripts", "ATENCION!!!\n\nPara restaurar un backup en una base de datos existente, se eliminará la base de datos completa.\nTodos los datos actuales de dicha base de datos se perderán.\n\nAsegúrese de que no hay ningún usuario conectado a la base de datos\n\nSi está COMPLETAMENTE SEGURO de lo que hace, pulse Aceptar"), MessageBox.Ok, MessageBox.Cancel, MessageBox.NoButton);
    if (res != MessageBox.Ok)
      return;
  }

  var usuario: String = sys.nameUser();
  var fichero: String = this.child("fdbFichero").value();
  var rutaTrabajo: String = util.readSettingEntry("scripts/flmantppal/dirRutaBackups");

  if (!baseDatos || !fichero) {
    MessageBox.critical(util.translate("scripts", "La base de datos y el fichero no pueden ser nulos"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return;
  }

  if (!rutaTrabajo) {
    MessageBox.critical(util.translate("scripts", "No se ha definido la ruta en disco a los ficheros de backup\nDebe definir la ruta en las opciones"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return;
  }

  if (!File.isDir(rutaTrabajo)) {
    MessageBox.critical(util.translate("scripts", "La ruta en disco a los ficheros de backup es incorrecta\nDebe corregir la ruta en las opciones"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return;
  }

  if (!File.exists(rutaTrabajo + fichero)) {
    MessageBox.critical(util.translate("scripts", "No existe el fichero. No es posible realizar la restauración"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return;
  }

  this.iface.bloquearForm(true);

  // Borrar base de datos
  if (tipoBD == "existente") {

    var comandoDel: String = this.iface.selecComando("comandodel");
    if (!comandoDel) {
      MessageBox.critical(util.translate("scripts", "No existe un comando de eliminación de base de datos definido para el sistema opertativo actual\nDebe definir el comando en la tabla de comandos"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
      return;
    }

    comandoDel = this.iface.sustituyeString(comandoDel, "%base_datos%", baseDatos);
    comandoDel = this.iface.sustituyeString(comandoDel, "%usuario%", usuario);

    var argumentos: Array = comandoDel.split(" ");
    this.iface.procesoBorrar = new FLProcess(argumentos[0]);
    for (var i = 1; i < argumentos.length; i++) {
      this.iface.procesoBorrar.addArgument(argumentos[i]);
    }

    connect(this.iface.procesoBorrar, "exited()", this, "iface.checkBorrado");
    this.iface.procesoBorrar.start();

  } else
    this.iface.lanzarCreacion();
}


function oficial_lanzarRestauracion()
{
  var util: FLUtil = new FLUtil();
  this.child("leEstado").text = util.translate("scripts", "Restaurando base de datos...")

                                var comando: String = this.iface.selecComando("comandorestore");

  var baseDatos: String;
  var tipoBD: String = "";

  if (this.child("fdbBaseDatosRestExi").value()) {
    baseDatos = this.child("fdbBaseDatosRestExi").value();
  }
  if (this.child("fdbBaseDatosRestNue").value()) {
    baseDatos = this.child("fdbBaseDatosRestNue").value();
  }

  var usuario: String = sys.nameUser();
  var fichero: String = this.child("fdbFichero").value();
  var rutaTrabajo: String = util.readSettingEntry("scripts/flmantppal/dirRutaBackups");

  comando = this.iface.sustituyeString(comando, "%base_datos%", baseDatos);
  comando = this.iface.sustituyeString(comando, "%usuario%", usuario);
  comando = this.iface.sustituyeString(comando, "%fichero%", fichero);

  var argumentos: Array = comando.split(" ");
  this.iface.procesoRestaurar = new FLProcess(argumentos[0]);
  this.iface.procesoRestaurar.setWorkingDirectory(rutaTrabajo);
  for (var i = 1; i < argumentos.length; i++) {
    this.iface.procesoRestaurar.addArgument(argumentos[i]);
  }

  connect(this.iface.procesoRestaurar, "exited()", this, "iface.checkRestore");
  this.iface.procesoRestaurar.start();
}


function oficial_lanzarCreacion()
{
  var util: FLUtil = new FLUtil();
  this.child("leEstado").text = util.translate("scripts", "Creando la nueva base de datos...")

                                var comando: String = this.iface.selecComando("comandocreate");

  var baseDatos: String;

  if (this.child("fdbBaseDatosRestExi").value()) {
    baseDatos = this.child("fdbBaseDatosRestExi").value();
  }
  if (this.child("fdbBaseDatosRestNue").value()) {
    baseDatos = this.child("fdbBaseDatosRestNue").value();
  }

  var usuario: String = sys.nameUser();
  var fichero: String = this.child("fdbFichero").value();
  var rutaTrabajo: String = util.readSettingEntry("scripts/flmantppal/dirRutaBackups");

  comando = this.iface.sustituyeString(comando, "%base_datos%", baseDatos);
  comando = this.iface.sustituyeString(comando, "%usuario%", usuario);
  comando = this.iface.sustituyeString(comando, "%fichero%", fichero);

  debug(comando);
  var argumentos: Array = comando.split(" ");
  this.iface.procesoCrear = new FLProcess(argumentos[0]);
  this.iface.procesoCrear.setWorkingDirectory(rutaTrabajo);
  for (var i = 1; i < argumentos.length; i++) {
    this.iface.procesoCrear.addArgument(argumentos[i]);
  }

  connect(this.iface.procesoCrear, "exited()", this, "iface.checkCreacion");
  this.iface.procesoCrear.start();
}


function oficial_checkBackup()
{
  this.iface.bloquearForm(false);

  var util: FLUtil = new FLUtil();
  this.child("leEstado").text = util.translate("scripts", "Verificando el backup...")

                                var fichero: String = this.child("fdbFichero").value();
  var rutaTrabajo: String = util.readSettingEntry("scripts/flmantppal/dirRutaBackups");

  if (!File.exists(rutaTrabajo + fichero)) {
    MessageBox.critical(util.translate("scripts", "No se creó el fichero de backup.\nVerifique que la base de datos existe y que el comando es correcto"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return;
  }

  var msgOK: String = this.iface.selecMsg("backupok");
  if (!msgOK) {
    MessageBox.critical(util.translate("scripts", "No se reconoce el driver de base de datos"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    this.child("leEstado").text = util.translate("scripts", "El proceso no finalizó correctamente")
                                  return;
  }

  var dump = File.read(rutaTrabajo + fichero);

  if (dump.search(msgOK) == -1) {
    MessageBox.critical(util.translate("scripts", "El fichero de backup no se generó correctamente"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    this.child("leEstado").text = util.translate("scripts", "El proceso no finalizó correctamente")
                                  return;
  }

  this.child("leEstado").text = util.translate("scripts", "Backup creado")
                                MessageBox.information(util.translate("scripts", "Se generó fichero de backup:\n") + rutaTrabajo + fichero, MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
  this.child("pushButtonAccept").animateClick();
}

function oficial_checkBorrado()
{
  var util: FLUtil = new FLUtil();
  this.child("leEstado").text = util.translate("scripts", "Verificando eliminación...")

                                var salida: String = this.iface.procesoBorrar.readStdout();
  var msgOK: String = this.iface.selecMsg("delok");

  debug(salida);
  debug(msgOK);

  if (salida.toString().left(msgOK.length) != msgOK) {
    MessageBox.critical(util.translate("scripts", "No fue posible eliminar la base de datos.\nAsegúrese de que tiene los permisos necesarios y de que la base de datos no está siendo utilizada\nTambién es posible que la base de datos no exista, en ese caso debe rellenar la casilla de base de datos nueva"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    this.child("leEstado").text = util.translate("scripts", "El proceso no finalizó correctamente")
                                  this.iface.bloquearForm(false);
    return;
  }

  this.iface.lanzarCreacion();
}

function oficial_checkCreacion()
{
  var util: FLUtil = new FLUtil();
  this.child("leEstado").text = util.translate("scripts", "Verficando la creación de la base de datos...")

                                var salida: String = this.iface.procesoCrear.readStdout();
  var msgOK: String = this.iface.selecMsg("createok");

  debug(salida);
  debug(msgOK);

  if (salida.toString().left(msgOK.length) != msgOK) {
    MessageBox.critical(util.translate("scripts", "No fue posible crear la base de datos.\nAsegúrese de que tiene los permisos necesarios y de que la base de datos no existe"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    this.child("leEstado").text = util.translate("scripts", "El proceso no finalizó correctamente")
                                  this.iface.bloquearForm(false);
    return;
  }

  this.iface.lanzarRestauracion();
}

function oficial_checkRestore()
{
  var util: FLUtil = new FLUtil();
  var hoy = new Date();

  this.child("leEstado").text = util.translate("scripts", "Restauración completa")
                                this.child("fdbFechaRest").setValue(hoy);
  this.iface.bloquearForm(false);
  MessageBox.information(util.translate("scripts", "Se restauró la base de datos"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
  this.child("pushButtonAccept").animateClick();
}


function oficial_sustituyeString(texto, cadena1, cadena2): String {
  var patternRE: RegExp = new RegExp(cadena1);
  patternRE.global = true;
  return texto.replace(patternRE, cadena2);
}

function oficial_cambioTipoBD(tipoBD: Number)
{
  switch (tipoBD) {
    case 0: //existente
      this.child("fdbBaseDatosRestNue").setValue("");
      this.child("fdbBaseDatosRestNue").setDisabled(true);
      this.child("fdbBaseDatosRestExi").setDisabled(false);
      break;
    case 1: //nueva
      this.child("fdbBaseDatosRestExi").setValue("");
      this.child("fdbBaseDatosRestExi").setDisabled(true);
      this.child("fdbBaseDatosRestNue").setDisabled(false);
      break;
  }
}

function oficial_selecMsg(campo: String): String {
  var util: FLUtil = new FLUtil();
  var msg: String = "";

  var driver: String = sys.nameDriver();
  if (driver.search("FLQPSQL") > -1)
    msg = util.sqlSelect("mt_opciones", campo + "pg", "1=1");
  if (driver.search("FLQMYSQL") > -1)
    msg = util.sqlSelect("mt_opciones", campo + "mysql", "1=1");

  return msg;
}

function oficial_selecComando(campo: String): String {
  var util: FLUtil = new FLUtil();
  var comando: String = "";
  //  var so:String = util.getOS();
  var so: String = "LINUX";
  switch (so)
  {
    case "WIN32":
      comando = util.sqlSelect("mt_comandos", campo, "so='Windows'");
      break;
    case "LINUX":
      comando = util.sqlSelect("mt_comandos", campo, "so='Linux'");
      break;
    case "MACX":
      comando = util.sqlSelect("mt_comandos", campo, "so='Mac OSX'");
      break;
  }

  return comando;
}

function oficial_bloquearForm(bloqueo: Boolean)
{
  if (this.cursor().modeAccess() != this.cursor().Insert) {
    this.child("pushButtonFirst").setDisabled(bloqueo);
    this.child("pushButtonPrevious").setDisabled(bloqueo);
    this.child("pushButtonNext").setDisabled(bloqueo);
    this.child("pushButtonLast").setDisabled(bloqueo);
  } else
    this.child("gbxBackup").setDisabled(bloqueo);

  this.child("gbxGeneral").setDisabled(bloqueo);
  this.child("gbxRestaurar").setDisabled(bloqueo);

  this.child("pushButtonAccept").setDisabled(bloqueo);
  this.child("pushButtonAcceptContinue").setDisabled(bloqueo);
  this.child("pushButtonCancel").setDisabled(bloqueo);
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////