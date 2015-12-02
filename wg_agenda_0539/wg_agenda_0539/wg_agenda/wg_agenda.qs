/***************************************************************************
                 wg_agenda.qs  -  description
                             -------------------
    begin                : vie sep 25 2009
    copyright            : (C) 2009 by InfoSiAL S.L.
    email                : mail@infosial.com
 ***************************************************************************/
/***************************************************************************
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
 ***************************************************************************/

/** @file */

/** @class_declaration interna */
////////////////////////////////////////////////////////////////////////////
//// DECLARACION ///////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

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
    return this.ctx.interna_init();
  }
  function main()
  {
    return this.ctx.interna_main();
  }
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna
{
  var curConfig: FLSqlCursor;
  var tablaSel: String;
  var claveSel: String;
  var mailSel: String;
  function oficial(context)
  {
    interna(context);
  }
  function habilitarDatos()
  {
    return this.ctx.oficial_habilitarDatos();
  }
  function buscar()
  {
    return this.ctx.oficial_buscar();
  }
  function buscarCliente()
  {
    return this.ctx.oficial_buscarCliente();
  }
  function buscarProveedor()
  {
    return this.ctx.oficial_buscarProveedor();
  }
  function buscarAgente()
  {
    return this.ctx.oficial_buscarAgente();
  }
  function buscarContacto()
  {
    return this.ctx.oficial_buscarContacto();
  }
  function construirDireccion(codigo: String, tabla: String): String {
    return this.ctx.oficial_construirDireccion(codigo, tabla);
  }
  function configurarAgenda()
  {
    return this.ctx.oficial_configurarAgenda();
  }
  function informarCamposAgenda()
  {
    return this.ctx.oficial_informarCamposAgenda();
  }
  function verSeleccionado()
  {
    return this.ctx.oficial_verSeleccionado();
  }
  function enviarMail()
  {
    return this.ctx.oficial_enviarMail();
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

/** @class_definition interna */
////////////////////////////////////////////////////////////////////////////
//// DEFINICION ////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
//// INTERNA /////////////////////////////////////////////////////
function interna_init()
{
  var util: FLUtil = new FLUtil();
  var cursor: FLSqlCursor = this.cursor();
  var idUsuario: String = sys.nameUser();

  cursor.select("idusuario = '" + idUsuario + "'");
  if (!cursor.first()) {
    cursor = new FLSqlCursor("wg_agenda");
    cursor.setModeAccess(cursor.Insert);
    cursor.refreshBuffer();
    cursor.setValueBuffer("idusuario", idUsuario);
    cursor.commitBuffer();
    cursor.select("idusuario = '" + idUsuario + "'");
    if (cursor.first()) {
      return false;
    }
  }

  util.sqlDelete("wg_lineasagenda", "idagenda = " + cursor.valueBuffer("idagenda"));

  connect(this.child("tbnBuscar"), "clicked()", this, "iface.buscar()");
  connect(this.child("tbnConfig"), "clicked()", this, "iface.configurarAgenda()");
  connect(this.child("tbnVerSeleccionado"), "clicked()", this, "iface.verSeleccionado()");
  connect(this.child("tbnEnviarMail"), "clicked()", this, "iface.enviarMail()");

  this.child("fdbIdUsuario").setValue(idUsuario);
  this.child("fdbIdUsuario").close();
  this.child("gbxMensaje").close();
  this.child("pushButtonCancel").close();

  this.iface.curConfig = new FLSqlCursor("wg_agendaconfig");
  this.iface.curConfig.select("idusuario = '" + idUsuario + "'");
  this.iface.curConfig.first();

  this.child("lbNombre").setText("Nombre: ");
  this.child("lbDireccion").setText("Dirección: ");
  this.child("lbTelefono").setText("Tel.: ");
  this.child("lbEmail").setText("E-mail: ");
  this.child("lbMensaje").setText("");
  this.iface.habilitarDatos();
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_habilitarDatos()
{
  if (!this.iface.curConfig.valueBuffer("nombre")) {
    this.child("lbNombre").close();
  }
  if (!this.iface.curConfig.valueBuffer("direccion")) {
    this.child("lbDireccion").close();
  }
  if (!this.iface.curConfig.valueBuffer("telefono")) {
    this.child("lbTelefono").close();
  }
  if (!this.iface.curConfig.valueBuffer("email")) {
    this.child("lbEmail").close();
  }
}

function oficial_buscar()
{
  var util: FLUtil = new FLUtil();
  var cursor: FLSqlCursor = this.cursor();
  util.sqlDelete("wg_lineasagenda", "idagenda = " + cursor.valueBuffer("idagenda"));

  var cliente: Boolean = this.iface.curConfig.valueBuffer("cliente");
  if (cliente) {
    this.iface.buscarCliente();
  }
  var proveedor: Boolean = this.iface.curConfig.valueBuffer("proveedor");
  if (proveedor) {
    this.iface.buscarProveedor();
  }
  var agente: Boolean = this.iface.curConfig.valueBuffer("agente");
  if (agente) {
    this.iface.buscarAgente();
  }
  var contacto: Boolean = this.iface.curConfig.valueBuffer("contacto");
  if (contacto) {
    this.iface.buscarContacto();
  }
  this.iface.informarCamposAgenda();
}

function oficial_buscarCliente()
{
  var nombreCliente: String = this.child("ldBusqueda").text;
  var cursor: FLSqlCursor = this.cursor();
  var qryCliente: FLSqlQuery = new FLSqlQuery();
  qryCliente.setTablesList("clientes");
  qryCliente.setSelect("codcliente,nombre,telefono1,email");
  qryCliente.setFrom("clientes");
  qryCliente.setWhere("UPPER(nombre) LIKE '%" + nombreCliente.toUpperCase() + "%'");
  qryCliente.setForwardOnly(true);
  if (!qryCliente.exec()) {
    return false;
  }
  var curLineaAgen: FLSqlCursor = new FLSqlCursor("wg_lineasagenda");
  while (qryCliente.next()) {
    curLineaAgen.setModeAccess(curLineaAgen.Insert);
    curLineaAgen.refreshBuffer();
    curLineaAgen.setValueBuffer("idagenda", cursor.valueBuffer("idagenda"));
    curLineaAgen.setValueBuffer("tabla", "clientes");
    curLineaAgen.setValueBuffer("clave", qryCliente.value("codcliente"));
    curLineaAgen.setValueBuffer("nombre", qryCliente.value("nombre"));
    curLineaAgen.setValueBuffer("direccion", this.iface.construirDireccion(qryCliente.value("codcliente"), "dirclientes"));
    curLineaAgen.setValueBuffer("telefono", qryCliente.value("telefono1"));
    curLineaAgen.setValueBuffer("email", qryCliente.value("email"));
    if (!curLineaAgen.commitBuffer()) {
      continue;
    }
  }
}

function oficial_buscarProveedor()
{
  var nombreProveedor: String = this.child("ldBusqueda").text;
  var cursor: FLSqlCursor = this.cursor();
  var qryProveedor: FLSqlQuery = new FLSqlQuery();
  qryProveedor.setTablesList("proveedores");
  qryProveedor.setSelect("codproveedor,nombre,telefono1,email");
  qryProveedor.setFrom("proveedores");
  qryProveedor.setWhere("UPPER(nombre) LIKE '%" + nombreProveedor.toUpperCase() + "%'");
  qryProveedor.setForwardOnly(true);
  if (!qryProveedor.exec()) {
    return false;
  }

  var curLineaAgen: FLSqlCursor = new FLSqlCursor("wg_lineasagenda");
  while (qryProveedor.next()) {
    curLineaAgen.setModeAccess(curLineaAgen.Insert);
    curLineaAgen.refreshBuffer();
    curLineaAgen.setValueBuffer("idagenda", cursor.valueBuffer("idagenda"));
    curLineaAgen.setValueBuffer("tabla", "proveedores");
    curLineaAgen.setValueBuffer("clave", qryProveedor.value("codproveedor"));
    curLineaAgen.setValueBuffer("nombre", qryProveedor.value("nombre"));
    curLineaAgen.setValueBuffer("direccion", this.iface.construirDireccion(qryProveedor.value("codproveedor"), "dirproveedores"));
    curLineaAgen.setValueBuffer("telefono", qryProveedor.value("telefono1"));
    curLineaAgen.setValueBuffer("email", qryProveedor.value("email"));
    if (!curLineaAgen.commitBuffer()) {
      continue;
    }
  }
}

function oficial_construirDireccion(codigo: String, tabla: String): String {
  var codCliProv: String;
  var tipoDireccion: String;
  if (tabla == "dirclientes")
  {
    codCliProv = "codcliente";
    tipoDireccion = "domfacturacion";
  }
  if (tabla == "dirproveedores")
  {
    codCliProv = "codproveedor";
    tipoDireccion = "direccionppal";
  }
  var direccion: String;
  var qryDir: FLSqlQuery = new FLSqlQuery();
  qryDir.setTablesList(tabla);
  qryDir.setSelect("direccion,codpostal,ciudad,provincia");
  qryDir.setFrom(tabla);
  qryDir.setWhere(codCliProv + " = '" + codigo + "' AND " + tipoDireccion + " = true");
  qryDir.setForwardOnly(true);
  if (!qryDir.exec())
  {
    return false;
  }
  if (qryDir.first())
  {
    direccion = qryDir.value("direccion") + "\n " + qryDir.value("codpostal") + " - " + qryDir.value("ciudad") + " (" + qryDir.value("provincia") + ")";
  }
  return direccion;
}

function oficial_buscarAgente()
{
  var nombreAgente: String = this.child("ldBusqueda").text;
  var cursor: FLSqlCursor = this.cursor();
  var qryAgente: FLSqlQuery = new FLSqlQuery();
  qryAgente.setTablesList("agentes");
  qryAgente.setSelect("codagente,nombreap,direccion,ciudad,codpostal,provincia,telefono,email");
  qryAgente.setFrom("agentes");
  qryAgente.setWhere("UPPER(nombreap) LIKE '%" + nombreAgente.toUpperCase() + "%'");
  qryAgente.setForwardOnly(true);
  if (!qryAgente.exec()) {
    return false;
  }
  debug(qryAgente.sql());
  var curLineaAgen: FLSqlCursor = new FLSqlCursor("wg_lineasagenda");
  while (qryAgente.next()) {
    curLineaAgen.setModeAccess(curLineaAgen.Insert);
    curLineaAgen.refreshBuffer();
    curLineaAgen.setValueBuffer("idagenda", cursor.valueBuffer("idagenda"));
    curLineaAgen.setValueBuffer("tabla", "agentes");
    curLineaAgen.setValueBuffer("clave", qryAgente.value("codagente"));
    curLineaAgen.setValueBuffer("nombre", qryAgente.value("nombreap"));
    curLineaAgen.setValueBuffer("direccion", qryAgente.value("direccion") + "\n " + qryAgente.value("codpostal") + qryAgente.value("ciudad") + "(" + qryAgente.value("provincia") + ")");
    curLineaAgen.setValueBuffer("telefono", qryAgente.value("telefono"));
    curLineaAgen.setValueBuffer("email", qryAgente.value("email"));
    if (!curLineaAgen.commitBuffer()) {
      continue;
    }
  }
}

function oficial_buscarContacto()
{
  var nombreContacto: String = this.child("ldBusqueda").text;
  var cursor: FLSqlCursor = this.cursor();
  var qryContacto: FLSqlQuery = new FLSqlQuery();
  qryContacto.setTablesList("crm_contactos");
  qryContacto.setSelect("codcontacto,nombre,direccion,ciudad,codpostal,provincia,telefono1,email");
  qryContacto.setFrom("crm_contactos");
  qryContacto.setWhere("UPPER(nombre) LIKE '%" + nombreContacto.toUpperCase() + "%'");
  qryContacto.setForwardOnly(true);
  if (!qryContacto.exec()) {
    return false;
  }
  var curLineaAgen: FLSqlCursor = new FLSqlCursor("wg_lineasagenda");
  while (qryContacto.next()) {
    curLineaAgen.setModeAccess(curLineaAgen.Insert);
    curLineaAgen.refreshBuffer();
    curLineaAgen.setValueBuffer("idagenda", cursor.valueBuffer("idagenda"));
    curLineaAgen.setValueBuffer("tabla", "crm_contactos");
    curLineaAgen.setValueBuffer("clave", qryContacto.value("codcontacto"));
    curLineaAgen.setValueBuffer("nombre", qryContacto.value("nombre"));
    curLineaAgen.setValueBuffer("direccion", qryContacto.value("direccion") + "\n " + qryContacto.value("codpostal") + qryContacto.value("ciudad") + "(" + qryContacto.value("provincia") + ")");
    curLineaAgen.setValueBuffer("telefono", qryContacto.value("telefono"));
    curLineaAgen.setValueBuffer("email", qryContacto.value("email"));
    if (!curLineaAgen.commitBuffer()) {
      continue;
    }
  }
}

function oficial_configurarAgenda()
{
  var idUsuario: String = sys.nameUser();
  var curConfigAgenda: FLSqlCursor = new FLSqlCursor("wg_agendaconfig");
  curConfigAgenda.select("idusuario = '" + idUsuario + "'");
  if (curConfigAgenda.first()) {
    curConfigAgenda.editRecord();
  } else {
    curConfigAgenda.setModeAccess(curConfigAgenda.Insert);
    curConfigAgenda.refreshBuffer();
    curConfigAgenda.setValueBuffer("idusuario", idUsuario);
    curConfigAgenda.commitBuffer();
    curConfigAgenda.select("idusuario = '" + idUsuario + "'");
    curConfigAgenda.first();
    curConfigAgenda.editRecord();
  }
}

function oficial_informarCamposAgenda()
{
  var cursor: FLSqlCursor = this.cursor();
  var util: FLUtil = new FLUtil();
  var qry: FLSqlQuery = new FLSqlQuery();
  qry.setTablesList("wg_lineasagenda");
  qry.setSelect("tabla,clave,nombre,direccion,telefono,email");
  qry.setFrom("wg_lineasagenda");
  qry.setWhere("idagenda = " + cursor.valueBuffer("idagenda"));
  qry.setForwardOnly(true);
  if (!qry.exec()) {
    return false;
  }
  qry.first();
  if (qry.size() == 0) {
    this.child("gbxMensaje").show();
    this.child("gbxDatos").close();
    this.child("lbNombre").setText("");
    this.child("lbDireccion").setText("");
    this.child("lbTelefono").setText("");
    this.child("lbEmail").setText("");
    this.child("lbMensaje").setText("NO HAY DATOS");
    return false;
  } else if (qry.size() == 1) {
    this.child("gbxMensaje").close();
    this.child("gbxDatos").show();
    this.child("lbNombre").setText("Nombre: " + qry.value("nombre"));
    this.child("lbDireccion").setText("Dirección: " + qry.value("direccion"));
    this.child("lbTelefono").setText("Telf.: " + qry.value("telefono"));
    this.child("lbEmail").setText("E-mail: " + qry.value("email"));
    this.iface.tablaSel = qry.value("tabla");
    this.iface.claveSel = qry.value("clave");
    this.iface.mailSel = qry.value("email");
  } else {
    this.child("gbxMensaje").close();
    this.child("gbxDatos").show();
    var f: Object = new FLFormSearchDB("wg_lineasagenda");
    var curLinea: FLSqlCursor = f.cursor();
    f.setMainWidget();
    var idLinea: String = f.exec("idlinea");
    this.obj().show();
    this.child("lbNombre").setText("Nombre: " + curLinea.valueBuffer("nombre"));
    this.child("lbDireccion").setText("Dirección: " + curLinea.valueBuffer("direccion"));
    this.child("lbTelefono").setText("Telf.: " + curLinea.valueBuffer("telefono"));
    this.child("lbEmail").setText("E-mail: " + curLinea.valueBuffer("email"));
    this.iface.tablaSel = curLinea.valueBuffer("tabla");
    this.iface.claveSel = curLinea.valueBuffer("clave");
    this.iface.mailSel = curLinea.valueBuffer("email");
  }
}

function oficial_verSeleccionado()
{
  var cursor: FLSqlCursor;
  switch (this.iface.tablaSel) {
    case "clientes": {
      cursor = new FLSqlCursor("clientes");
      cursor.select("codcliente = '" + this.iface.claveSel + "'");
      cursor.first();
      cursor.editRecord();
      break;
    }
    case "proveedores": {
      cursor = new FLSqlCursor("proveedores");
      cursor.select("codproveedor = '" + this.iface.claveSel + "'");
      cursor.first();
      cursor.editRecord();
      break;
    }
    case "agentes": {
      cursor = new FLSqlCursor("agentes");
      cursor.select("codagente = '" + this.iface.claveSel + "'");
      cursor.first();
      cursor.editRecord();
      break;
    }
    case "crm_contactos": {
      cursor = new FLSqlCursor("crm_contactos");
      cursor.select("codcontacto = '" + this.iface.claveSel + "'");
      cursor.first();
      cursor.editRecord();
      break;
    }
  }
}

function oficial_enviarMail()
{
  var util: FLUtil = new FLUtil();
  var cursor: FLSqlCursor = this.cursor();
  var mail: Boolean = flfactppal.iface.pub_existeEnvioMail();
  if (!mail) {
    MessageBox.information(util.translate("scripts", "No tiene la extensión para el envío automático de mail.\n"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  } else {
    var arrayDest: Array = [];
    arrayDest[0] = [];
    arrayDest[0]["tipo"] = "to";
    arrayDest[0]["direccion"] = this.iface.mailSel;
    flfactppal.iface.pub_enviarCorreo("", "", arrayDest, "");
  }
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
