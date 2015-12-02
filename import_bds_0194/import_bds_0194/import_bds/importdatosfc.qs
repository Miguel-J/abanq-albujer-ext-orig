/***************************************************************************
                 importdatosfc.qs  -  description
                             -------------------
    begin                : lun sep 21 2004
    copyright            : (C) 2007 by InfoSiAL S.L.
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
  function main()
  {
    this.ctx.interna_main();
  }
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna
{
  var incRemesa: Number;
  var conexion: String;
  var tablas: Array;
  var seriesImportables: String;
  var importando: Boolean;
  var tedResultados: Object;
  var bd_;
  function oficial(context)
  {
    interna(context);
  }

  function conectar(): Boolean {
    return this.ctx.oficial_conectar();
  }
  function desconectar(): Boolean {
    return this.ctx.oficial_desconectar();
  }

  function bajarDatos(): Boolean {
    return this.ctx.oficial_bajarDatos();
  }
  function bajarClientes(): Boolean {
    return this.ctx.oficial_bajarClientes();
  }
  function bajarProveedores(): Boolean {
    return this.ctx.oficial_bajarProveedores();
  }
  function bajarFacturasCli(): Boolean {
    return this.ctx.oficial_bajarFacturasCli();
  }
  function bajarAlbaranesCli(): Boolean {
    return this.ctx.oficial_bajarAlbaranesCli();
  }
  function bajarRemesas(): Boolean {
    return this.ctx.oficial_bajarRemesas();
  }
  function bajarPD(): Boolean {
    return this.ctx.oficial_bajarPD();
  }
  function bajarFacturasProv(): Boolean {
    return this.ctx.oficial_bajarFacturasProv();
  }
  function bajarAlbaranesProv(): Boolean {
    return this.ctx.oficial_bajarAlbaranesProv();
  }

  function importarClientes(): Number {
    return this.ctx.oficial_importarClientes();
  }
  function importarProveedores(): Number {
    return this.ctx.oficial_importarProveedores();
  }
  function importarTabla(tabla: String, nomTabla: String, valoresClave: Array, facturacion: Boolean, limite: Number): Number {
    return this.ctx.oficial_importarTabla(tabla, nomTabla, valoresClave, facturacion, limite);
  }
  function importarLineas(tablaPadre: String, codigoPadre: String): Boolean {
    return this.ctx.oficial_importarLineas(tablaPadre, codigoPadre);
  }
  function importarPD(tabla: String, tablaPadre: String, idRemesa: Number): Number {
    return this.ctx.oficial_importarPD(tabla, tablaPadre, idRemesa);
  }
  function pagosLocal(idRecibo: Number): Boolean {
    return this.ctx.oficial_pagosLocal(idRecibo);
  }
  function importarRemesas(): Number {
    return this.ctx.oficial_importarRemesas();
  }
  function actualizarEstadoRecibo(tabla: String, tablaPadre: String, idRecibo: String): Boolean {
    return this.ctx.oficial_actualizarEstadoRecibo(tabla, tablaPadre, idRecibo);
  }
  function eliminarLocales(tabla: String, nomTabla: String, valoresClave: Array): Number {
    return this.ctx.oficial_eliminarLocales(tabla, nomTabla, valoresClave);
  }

  function obtenerListaCampos(tabla: String): Array {
    return this.ctx.oficial_obtenerListaCampos(tabla);
  }
  function anotarRegistrosImportados(yaActualizados: Array, tabla: String)
  {
    return this.ctx.oficial_anotarRegistrosImportados(yaActualizados, tabla);
  }
  function crearTuplas()
  {
    return this.ctx.oficial_crearTuplas();
  }
  function crearTuplasTabla(tabla: String, valoresClave: Array)
  {
    return this.ctx.oficial_crearTuplasTabla(tabla, valoresClave);
  }
  function actualizarTuplaClaves(tabla: String, claveLoc, claveRem)
  {
    return this.ctx.oficial_actualizarTuplaClaves(tabla, claveLoc, claveRem);
  }
  function eliminarTuplaClaves(tabla: String, claveLoc: String, claveRem: String)
  {
    return this.ctx.oficial_eliminarTuplaClaves(tabla, claveLoc, claveRem);
  }
  function totalesFacturacion(curFacturacion: FLSqlCursor, aCero: Boolean): FLSqlCursor {
    return this.ctx.oficial_totalesFacturacion(curFacturacion, aCero);
  }
  function anotarRegistroExportado(tabla: String, claveRem: String)
  {
    return this.ctx.oficial_anotarRegistroExportado(tabla, claveRem);
  }
  function actualizarIDfacturaAlbaranCli(curLoc: FLSqlCursor)
  {
    return this.ctx.oficial_actualizarIDfacturaAlbaranCli(curLoc);
  }
  function actualizarIDfacturaAlbaranProv(curLoc: FLSqlCursor)
  {
    return this.ctx.oficial_actualizarIDfacturaAlbaranProv(curLoc);
  }
  function popularTodosModificados()
  {
    return this.ctx.oficial_popularTodosModificados();
  }
  function popularTodosModificadosTabla(tabla: String, codEjercicio: String)
  {
    return this.ctx.oficial_popularTodosModificadosTabla(tabla, codEjercicio);
  }
  function coordinarArticulos(): Number {
    return this.ctx.oficial_coordinarArticulos();
  }
  function subirRiesgo(): Number {
    return this.ctx.oficial_subirRiesgo();
  }
  function coordinarFamilias(): Number {
    return this.ctx.oficial_coordinarFamilias();
  }
  function coordinarClientes(): Number {
    return this.ctx.oficial_coordinarClientes();
  }
  function coordinarDirClientes(): Number {
    return this.ctx.oficial_coordinarDirClientes();
  }
  function consolidarCuentasBcoCli()
  {
    return this.ctx.oficial_consolidarCuentasBcoCli();
  }

  function coordinarProveedores(): Number {
    return this.ctx.oficial_coordinarProveedores();
  }
  function coordinarDirProveedores(): Number {
    return this.ctx.oficial_coordinarDirProveedores();
  }
  function consolidarCuentasBcoPro()
  {
    return this.ctx.oficial_consolidarCuentasBcoPro();
  }

  function actualizarDescripcionesSubctasCli(codCliente: String)
  {
    return this.ctx.oficial_actualizarDescripcionesSubctasCli(codCliente);
  }
  function actualizarDescripcionesSubctasProv(codProveedor: String)
  {
    return this.ctx.oficial_actualizarDescripcionesSubctasProv(codProveedor);
  }

  function estoyImportando(): Number {
    return this.ctx.estoyImportando();
  }
  function imprimirResultados()
  {
    return this.ctx.oficial_imprimirResultados();
  }
  function procesarCadena(cadenaO: String): String {
    return this.ctx.oficial_procesarCadena(cadenaO);
  }
  function estableceUsuario()
  {
    return this.ctx.oficial_estableceUsuario();
  }
  function actualizarDatosConexion()
  {
    return this.ctx.oficial_actualizarDatosConexion();
  }
  function pbnActivarConexion_clicked()
  {
    return this.ctx.oficial_pbnActivarConexion_clicked();
  }
  function activarConexion(idConexion)
  {
    return this.ctx.oficial_activarConexion(idConexion);
  }
  function borrarConexionActiva()
  {
    return this.ctx.oficial_borrarConexionActiva();
  }
  function masDatosActivarConexion(cursor, qry)
  {
    return this.ctx.oficial_masDatosActivarConexion(cursor, qry);
  }
  function mostrarSeries()
  {
    return this.ctx.oficial_mostrarSeries();
  }
  function cambioTab(tab)
  {
    return this.ctx.oficial_cambioTab(tab);
  }
  function mostrarAlias()
  {
    return this.ctx.oficial_mostrarAlias();
  }
  function masDatosCursorLocal(tabla, curLoc)
  {
    return this.ctx.oficial_masDatosCursorLocal(tabla, curLoc);
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

function main()
{
  this.iface.main();
}

function interna_init()
{
  var _i = this.iface;
  _i.importando = true;
  _i.bd_ = false;
  _i.conexion = "remota";
  connect(this.child("pbnDown"), "clicked()", _i, "bajarDatos");
  connect(this.child("pbnDownClientes"), "clicked()", _i, "bajarClientes");
  connect(this.child("pbnDownProveedores"), "clicked()", _i, "bajarProveedores");
  connect(this.child("pbnTuplas"), "clicked()", _i, "crearTuplas");
  connect(this.child("pbnTodosModificados"), "clicked()", _i, "popularTodosModificados");
  connect(this.child("pbnArticulos"), "clicked()", _i, "coordinarArticulos");
  connect(this.child("pbnRiesgo"), "clicked()", _i, "subirRiesgo");
  connect(this.child("pbnDirecciones"), "clicked()", _i, "coordinarDirClientes");
  connect(this.child("pbnImprimirResultados"), "clicked()", _i, "imprimirResultados");
  connect(this.child("tdbConexiones").cursor(), "bufferCommited()", _i, "actualizarDatosConexion");
  connect(this.child("pbnActivarConexion"), "clicked()", _i, "pbnActivarConexion_clicked");
  connect(this.child("tabImportDatos"), "currentChanged(QString)", this, "iface.cambioTab");

  if (sys.nameUser() != "facturalux" && sys.nameUser() != "infosial" && sys.nameUser() != "arodriguez" && sys.nameUser() != "lorena") {
    this.child("gbxAdmin").setDisabled(true);
    this.child("gbxAdmin2").setDisabled(true);
    //    this.child( "pbnDown" ).setDisabled(true);
    //    this.child( "gbxSeries" ).setDisabled(true);
    //    this.child( "gbxDatosConn" ).setDisabled(true);
  } else {
    connect(this.child("pbnDownFacturasCli"), "clicked()", _i, "bajarFacturasCli");
    connect(this.child("pbnDownAlbaranesCli"), "clicked()", _i, "bajarAlbaranesCli");
    connect(this.child("pbnDownFacturasProv"), "clicked()", _i, "bajarFacturasProv");
    connect(this.child("pbnDownAlbaranesProv"), "clicked()", _i, "bajarAlbaranesProv");
    connect(this.child("pbnDownRemesas"), "clicked()", _i, "bajarRemesas");
    connect(this.child("pbnDownPD"), "clicked()", _i, "bajarPD");
  }

  _i.seriesImportables = this.cursor().valueBuffer("seriesimportables");/*"ð";*/
  _i.mostrarSeries();
  _i.mostrarAlias();

  /*var curTab:FLSqlCursor = new FLSqlCursor("seriesimportables");
  curTab.select();
  while(curTab.next())
    this.iface.seriesImportables += curTab.valueBuffer("codserie") + "ð";*/

  _i.tedResultados = this.child("tedResultados");
  _i.tedResultados.clear();

  _i.estableceUsuario();
}

function interna_main()
{
  var util: FLUtil = new FLUtil();

  var f = new FLFormSearchDB("importdatosfc");
  var cursor: FLSqlCursor = f.cursor();

  cursor.select();
  if (!cursor.first())
    cursor.setModeAccess(cursor.Insert);
  else
    cursor.setModeAccess(cursor.Edit);

  f.setMainWidget();
  cursor.refreshBuffer();
  var commitOk: Boolean = false;
  var acpt: Boolean;
  cursor.transaction(false);
  while (!commitOk) {
    acpt = false;
    f.exec("id");
    acpt = f.accepted();
    if (!acpt) {
      if (cursor.rollback())
        commitOk = true;
    } else {
      if (cursor.commitBuffer()) {
        cursor.commit();
        commitOk = true;
      }
    }

  }

}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////

function oficial_bajarDatos()
{
  var util: FLUtil = new FLUtil();
  this.iface.incRemesa = 5000;

  this.iface.tedResultados.clear();

  /*  var res = MessageBox.information(util.translate("scripts", "A continuación se establecerá una conexión con la base de datos remota\ny se descargarán los nuevos datos\n\n¿Desea continuar?"),
      MessageBox.Yes, MessageBox.No, MessageBox.NoButton);
    if (res != MessageBox.Yes)
      return false;*/

  if (!this.iface.conectar())
    return false;

  var msgResumen: String = "";
  var numEliminados: Number;
  var numImportados: Number;

  // 1. BORRADO

  msgResumen += util.translate("scripts", "Registros eliminados:");

  numEliminados = this.iface.eliminarLocales("remesas", "Remesas");
  if (numEliminados)
    msgResumen += "<br>       " + util.translate("scripts", "Remesas") + ": " + numEliminados;

  valoresClave = new Array("codigo");
  numEliminados = this.iface.eliminarLocales("albaranescli", "Albaranes de cliente", valoresClave);
  if (numEliminados)
    msgResumen += "<br>       " + util.translate("scripts", "Albaranes de cliente") + ": " + numEliminados;

  valoresClave = new Array("codigo");
  numEliminados = this.iface.eliminarLocales("albaranesprov", "Albaranes de proveedor", valoresClave);
  if (numEliminados)
    msgResumen += "<br>       " + util.translate("scripts", "Albaranes de proveedor") + ": " + numEliminados;

  valoresClave = new Array("codigo");
  numEliminados = this.iface.eliminarLocales("facturascli", "Facturas de cliente", valoresClave);
  if (numEliminados)
    msgResumen += "<br>       " + util.translate("scripts", "Facturas de cliente") + ": " + numEliminados;

  valoresClave = new Array("codigo");
  numEliminados = this.iface.eliminarLocales("facturasprov", "Facturas de proveedor", valoresClave);
  if (numEliminados)
    msgResumen += "<br>       " + util.translate("scripts", "Facturas de proveedor") + ": " + numEliminados;

  valoresClave = new Array("codcliente", "codcliente", "ctaentidad", "ctaagencia", "cuenta");
  numEliminados = this.iface.eliminarLocales("cuentasbcocli", "Cuentas bancarias de clientes", valoresClave);
  if (numEliminados)
    msgResumen += "<br>       " + util.translate("scripts", "Cuentas bancarias de clientes") + ": " + numEliminados;

  valoresClave = new Array("codcliente", "direccion");
  numEliminados = this.iface.eliminarLocales("dirclientes", "Direcciones de clientes", valoresClave);
  if (numEliminados)
    msgResumen += "<br>       " + util.translate("scripts", "Direcciones de clientes") + ": " + numEliminados;

  numEliminados = this.iface.eliminarLocales("clientes", "Clientes");
  if (numEliminados)
    msgResumen += "<br>       " + util.translate("scripts", "Clientes") + ": " + numEliminados;


  valoresClave = new Array("codproveedor", "codproveedor", "ctaentidad", "ctaagencia", "cuenta");
  numEliminados = this.iface.eliminarLocales("cuentasbcopro", "Cuentas bancarias de proveedores", valoresClave);
  if (numEliminados)
    msgResumen += "<br>       " + util.translate("scripts", "Cuentas bancarias de proveedores") + ": " + numEliminados;

  valoresClave = new Array("codproveedor", "direccion");
  numEliminados = this.iface.eliminarLocales("dirproveedores", "Direcciones de proveedores", valoresClave);
  if (numEliminados)
    msgResumen += "<br>       " + util.translate("scripts", "Direcciones de proveedores") + ": " + numEliminados;

  numEliminados = this.iface.eliminarLocales("proveedores", "Proveedores");
  if (numEliminados)
    msgResumen += "<br>       " + util.translate("scripts", "Proveedores") + ": " + numEliminados;


  msgResumen += "<br><br>" + util.translate("scripts", "Registros nuevos o actualizados:");

  // 2. INSERCIÓN Y ACTUALIZACIÓN

  numImportados = this.iface.importarClientes();
  if (numImportados == -1)
    return;
  if (numImportados)
    msgResumen += "<br>       " + util.translate("scripts", "Clientes") + ": " + numImportados;

  valoresClave = new Array("codcliente", "direccion");
  numImportados = this.iface.importarTabla("dirclientes", "Direcciones de clientes", valoresClave);
  if (numImportados)
    msgResumen += "<br>       " + util.translate("scripts", "Direcciones de clientes") + ": " + numImportados;

  valoresClave = new Array("codcliente", "codcliente", "ctaentidad", "ctaagencia", "cuenta");
  numImportados = this.iface.importarTabla("cuentasbcocli", "Cuentas bancarias de clientes", valoresClave);
  if (numImportados)
    msgResumen += "<br>       " + util.translate("scripts", "Cuentas bancarias de clientes") + ": " + numImportados;

  //  valoresClave = new Array("codsubcuenta");
  //  numImportados = this.iface.importarTabla("co_subcuentas", "Subcuentas", valoresClave);
  //  if (numImportados)
  //    msgResumen += "<br>       " + util.translate("scripts", "Subcuentas") + ": " + numImportados;

  this.iface.tedResultados.append("<h3>Importando facturas de cliente</h3>");

  valoresClave = new Array("codigo");
  numImportados = this.iface.importarTabla("facturascli", "Facturas de clientes", valoresClave, true);
  if (numImportados)
    msgResumen += "<br>       " + util.translate("scripts", "Facturas de clientes") + ": " + numImportados;

  this.iface.tedResultados.append("<h3>Importando albaranes de cliente</h3>");

  valoresClave = new Array("codigo");
  numImportados = this.iface.importarTabla("albaranescli", "Albaranes de clientes", valoresClave, true);
  if (numImportados)
    msgResumen += "<br>       " + util.translate("scripts", "Albaranes de clientes") + ": " + numImportados;

  this.iface.tedResultados.append("<h3>Importando remesas</h3>");

  numImportados = this.iface.importarRemesas();
  if (numImportados)
    msgResumen += "<br>       " + util.translate("scripts", "Remesas") + ": " + numImportados;

  this.iface.tedResultados.append("<h3>Importando pagos y devoluciones</h3>");

  numImportados = this.iface.importarPD("pagosdevolcli", "reciboscli");
  if (numImportados)
    msgResumen += "<br>       " + util.translate("scripts", "Pagos y devoluciones") + ": " + numImportados;


  numImportados = this.iface.importarProveedores();
  if (numImportados == -1)
    return;
  if (numImportados)
    msgResumen += "<br>       " + util.translate("scripts", "Proveedores") + ": " + numImportados;

  valoresClave = new Array("codproveedor", "direccion");
  numImportados = this.iface.importarTabla("dirproveedores", "Direcciones de proveedores", valoresClave);
  if (numImportados)
    msgResumen += "<br>       " + util.translate("scripts", "Direcciones de proveedores") + ": " + numImportados;

  valoresClave = new Array("codproveedor", "codproveedor", "ctaentidad", "ctaagencia", "cuenta");
  numImportados = this.iface.importarTabla("cuentasbcopro", "Cuentas bancarias de proveedores", valoresClave);
  if (numImportados)
    msgResumen += "<br>       " + util.translate("scripts", "Cuentas bancarias de proveedores") + ": " + numImportados;


  this.iface.tedResultados.append("<h3>Importando facturas de proveedor</h3>");

  valoresClave = new Array("codigo");
  numImportados = this.iface.importarTabla("facturasprov", "Facturas de proveedores", valoresClave, true);
  if (numImportados)
    msgResumen += "<br>       " + util.translate("scripts", "Facturas de proveedores") + ": " + numImportados;

  this.iface.tedResultados.append("<h3>Importando albaranes de proveedor</h3>");

  valoresClave = new Array("codigo");
  numImportados = this.iface.importarTabla("albaranesprov", "Albaranes de proveedores", valoresClave, true);
  if (numImportados)
    msgResumen += "<br>       " + util.translate("scripts", "Albaranes de proveedores") + ": " + numImportados;


  this.iface.tedResultados.append(msgResumen);
  this.iface.desconectar();

  return;
}


function oficial_bajarClientes()
{
  var util: FLUtil = new FLUtil();

  if (!this.iface.conectar())
    return false;

  var msgResumen: String = "";
  var numEliminados: Number;
  var numImportados: Number;

  this.iface.tedResultados.clear();

  // 1. BORRADO

  msgResumen += util.translate("scripts", "Registros eliminados:");

  valoresClave = new Array("codcliente", "codcliente", "ctaentidad", "ctaagencia", "cuenta");
  numEliminados = this.iface.eliminarLocales("cuentasbcocli", "Cuentas bancarias de Clientes", valoresClave);
  if (numEliminados)
    msgResumen += "<br>       " + util.translate("scripts", "Cuentas bancarias de clientes") + ": " + numEliminados;

  valoresClave = new Array("codcliente", "direccion");
  numEliminados = this.iface.eliminarLocales("dirclientes", "Direcciones de clientes", valoresClave);
  if (numEliminados)
    msgResumen += "<br>       " + util.translate("scripts", "Direcciones de clientes") + ": " + numEliminados;

  numEliminados = this.iface.eliminarLocales("clientes", "Clientes");
  if (numEliminados)
    msgResumen += "<br>       " + util.translate("scripts", "Clientes") + ": " + numEliminados;

  msgResumen += "<br><br>" + util.translate("scripts", "Registros nuevos o actualizados:");

  // 2. INSERCIÓN Y ACTUALIZACIÓN

  numImportados = this.iface.importarClientes();
  if (numImportados == -1)
    return;
  if (numImportados)
    msgResumen += "<br>       " + util.translate("scripts", "Clientes") + ": " + numImportados;

  valoresClave = new Array("codcliente", "direccion");
  numImportados = this.iface.importarTabla("dirclientes", "Direcciones de Clientes", valoresClave);
  if (numImportados)
    msgResumen += "<br>       " + util.translate("scripts", "Direcciones de clientes") + ": " + numImportados;

  valoresClave = new Array("codcliente", "codcliente", "ctaentidad", "ctaagencia", "cuenta");
  numImportados = this.iface.importarTabla("cuentasbcocli", "Cuentas bancarias de Clientes", valoresClave);
  if (numImportados)
    msgResumen += "<br>       " + util.translate("scripts", "Cuentas bancarias de clientes") + ": " + numImportados;

  this.iface.tedResultados.append(msgResumen);

  this.iface.consolidarCuentasBcoCli();
  this.iface.desconectar();

  return;
}

function oficial_bajarProveedores()
{
  var util: FLUtil = new FLUtil();

  if (!this.iface.conectar())
    return false;

  var msgResumen: String = "";
  var numEliminados: Number;
  var numImportados: Number;

  this.iface.tedResultados.clear();

  // 1. BORRADO

  msgResumen += util.translate("scripts", "Registros eliminados:");

  valoresClave = new Array("codproveedor", "codproveedor", "ctaentidad", "ctaagencia", "cuenta");
  numEliminados = this.iface.eliminarLocales("cuentasbcopro", "Cuentas bancarias de proveedores", valoresClave);
  if (numEliminados)
    msgResumen += "<br>       " + util.translate("scripts", "Cuentas bancarias de proveedores") + ": " + numEliminados;

  valoresClave = new Array("codproveedor", "direccion");
  numEliminados = this.iface.eliminarLocales("dirproveedores", "Direcciones de proveedores", valoresClave);
  if (numEliminados)
    msgResumen += "<br>       " + util.translate("scripts", "Direcciones de proveedores") + ": " + numEliminados;

  numEliminados = this.iface.eliminarLocales("proveedores", "Proveedores");
  if (numEliminados)
    msgResumen += "<br>       " + util.translate("scripts", "Proveedores") + ": " + numEliminados;

  msgResumen += "<br><br>" + util.translate("scripts", "Registros nuevos o actualizados:");

  // 2. INSERCIÓN Y ACTUALIZACIÓN

  numImportados = this.iface.importarProveedores();
  if (numImportados == -1)
    return;
  if (numImportados)
    msgResumen += "<br>       " + util.translate("scripts", "Proveedores") + ": " + numImportados;

  valoresClave = new Array("codproveedor", "direccion");
  numImportados = this.iface.importarTabla("dirproveedores", "Direcciones de Proveedores", valoresClave);
  if (numImportados)
    msgResumen += "<br>       " + util.translate("scripts", "Direcciones de proveedores") + ": " + numImportados;

  valoresClave = new Array("codproveedodr", "codproveedor", "ctaentidad", "ctaagencia", "cuenta");
  numImportados = this.iface.importarTabla("cuentasbcopro", "Cuentas bancarias de proveedores", valoresClave);
  if (numImportados)
    msgResumen += "<br>       " + util.translate("scripts", "Cuentas bancarias de proveedores") + ": " + numImportados;

  this.iface.tedResultados.append(msgResumen);

  this.iface.consolidarCuentasBcoCli();
  this.iface.desconectar();

  return;
}

function oficial_bajarFacturasCli()
{
  var util: FLUtil = new FLUtil();

  if (!this.iface.conectar())
    return false;

  var msgResumen: String = "";
  this.iface.tedResultados.clear();
  var limite: Number = this.child("fdbLimite").value();

  valoresClave = new Array("codigo");
  numImportados = this.iface.importarTabla("facturascli", "Facturas de cliente", valoresClave, true, limite);
  if (numImportados)
    msgResumen += util.translate("scripts", "Facturas de clientes") + ": " + numImportados;
  else
    msgResumen += util.translate("scripts", "No se encontraron facturas a importar");

  this.iface.tedResultados.append(msgResumen);
  this.iface.desconectar();

  return;
}

function oficial_bajarAlbaranesCli()
{
  var util: FLUtil = new FLUtil();

  if (!this.iface.conectar())
    return false;

  var msgResumen: String = "";
  this.iface.tedResultados.clear();
  var limite: Number = this.child("fdbLimite").value();

  valoresClave = new Array("codigo");
  numImportados = this.iface.importarTabla("albaranescli", "Albaranes de cliente", valoresClave, true, limite);
  if (numImportados)
    msgResumen += util.translate("scripts", "Albaranes de clientes") + ": " + numImportados;
  else
    msgResumen += util.translate("scripts", "No se encontraron albaranes a importar");

  this.iface.tedResultados.append(msgResumen);
  this.iface.desconectar();

  return;
}

function oficial_bajarPD()
{
  var util: FLUtil = new FLUtil();

  if (!this.iface.conectar())
    return false;

  var msgResumen: String = "<h3>Resultados de importación de Pagos y Devoluciones</h3>";

  this.iface.tedResultados.clear();

  numImportados = this.iface.importarPD("pagosdevolcli", "reciboscli");
  if (numImportados)
    msgResumen += "\n       " + util.translate("scripts", "Pagos y devoluciones") + ": " + numImportados;
  else
    msgResumen += "\n" + util.translate("scripts", "No se encontraron pagos y devoluciones a importar");

  this.iface.tedResultados.append(msgResumen);
  this.iface.desconectar();

  return;
}

function oficial_bajarRemesas()
{
  var util: FLUtil = new FLUtil();

  if (!this.iface.conectar())
    return false;

  var msgResumen: String = "";
  this.iface.tedResultados.clear();

  numEliminados = this.iface.eliminarLocales("remesas", "Remesas");
  if (numEliminados)
    msgResumen += "<br>       " + util.translate("scripts", "Remesas eliminadas") + ": " + numEliminados;

  numImportados = this.iface.importarRemesas();
  if (numImportados)
    msgResumen += "<br>       " + util.translate("scripts", "Remesas nuevas o modificadas") + ": " + numImportados;

  if (!msgResumen)
    msgResumen = util.translate("scripts", "No se encontraron remesas para importar");

  this.iface.tedResultados.append(msgResumen);
  this.iface.desconectar();

  return;
}


function oficial_bajarFacturasProv()
{
  var util: FLUtil = new FLUtil();

  if (!this.iface.conectar())
    return false;

  var msgResumen: String = "";
  this.iface.tedResultados.clear();
  var limite: Number = this.child("fdbLimite").value();

  valoresClave = new Array("codigo");
  numImportados = this.iface.importarTabla("facturasprov", "Facturas de proveedor", valoresClave, true, limite);
  if (numImportados)
    msgResumen += util.translate("scripts", "Facturas de proveedores") + ": " + numImportados;
  else
    msgResumen += util.translate("scripts", "No se encontraron facturas a importar");

  this.iface.tedResultados.append(msgResumen);
  this.iface.desconectar();

  return;
}

function oficial_bajarAlbaranesProv()
{
  var util: FLUtil = new FLUtil();

  if (!this.iface.conectar())
    return false;

  var msgResumen: String = "";
  this.iface.tedResultados.clear();
  var limite: Number = this.child("fdbLimite").value();

  valoresClave = new Array("codigo");
  numImportados = this.iface.importarTabla("albaranesprov", "Albaranes de proveedor", valoresClave, true, limite);
  if (numImportados)
    msgResumen += util.translate("scripts", "Albaranes de proveedores") + ": " + numImportados;
  else
    msgResumen += util.translate("scripts", "No se encontraron albaranes a importar");

  this.iface.tedResultados.append(msgResumen);
  this.iface.desconectar();

  return;
}

/** \D Popula la tabla de tuplas (correspondenciasreg) con las correspondencias entre
registros de ambas bases de datos. Para lanzar una vez al inicio.
*/
function oficial_crearTuplas()
{
  var util: FLUtil = new FLUtil();

  if (!this.iface.conectar())
    return false;

  var msgResumen: String = util.translate("scripts", "Correspondencias creadas:\n");

  // Para el control de los clientes creados simultáneamente con los mismos códigos
  valoresClave = new Array("codcliente");
  numTuplas = this.iface.crearTuplasTabla("clientes", valoresClave);
  msgResumen += "\n" + util.translate("scripts", "Clientes") + ": " + numTuplas;

  valoresClave = new Array("codcliente", "direccion", "ciudad");
  numTuplas = this.iface.crearTuplasTabla("dirclientes", valoresClave);
  msgResumen += "\n" + util.translate("scripts", "Direcciones de clientes") + ": " + numTuplas;

  valoresClave = new Array("codcliente", "ctaentidad", "ctaagencia", "cuenta");
  numTuplas = this.iface.crearTuplasTabla("cuentasbcocli", valoresClave);
  msgResumen += "\n" + util.translate("scripts", "Cuentas bancarias de clientes") + ": " + numTuplas;

  MessageBox.information(msgResumen, MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);

  this.iface.desconectar();

  return;
}

function oficial_conectar()
{
  var util: FLUtil = new FLUtil();
  var cursor: FLSqlCursor = this.cursor();

  var driver: String = cursor.valueBuffer("driver");
  var nombreBD: String = cursor.valueBuffer("nombrebd");
  var usuario: String = cursor.valueBuffer("usuario");
  var host: String = cursor.valueBuffer("host");
  var puerto: String = cursor.valueBuffer("puerto");

  this.iface.bd_ = nombreBD;

  var tipoDriver: String;
  if (sys.nameDriver().search("PSQL") > -1)
    tipoDriver = "PostgreSQL";
  else
    tipoDriver = "MySQL";

  if (host == sys.nameHost() && nombreBD == sys.nameBD() && driver == tipoDriver && puerto == sys.portBD()) {
    MessageBox.warning(util.translate("scripts",
                                      "Los datos de conexión son los de la presente base de datos\nDebe indicar los datos de conexión de la base de datos remota"),
                       MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return false;
  }

  if (!driver || !nombreBD || !usuario || !host) {
    MessageBox.warning(util.translate("scripts",
                                      "Debe indicar el tipo de base de datos, nombre de la misma, usuario y servidor"),
                       MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return false;
  }

  var password = Input.getText(util.translate("scripts", "Password de conexión (en caso necesario)"));
  flfacturac.iface.pub_ponUltimoPwd(password);
  //  password = "";

  util.createProgressDialog(util.translate("scripts", "Conectando..."), 10);
  util.setProgress(2);

  if (!sys.addDatabase(driver, nombreBD, usuario, password, host, puerto, this.iface.conexion)) {
    util.destroyProgressDialog();
    return false;
  }

  util.destroyProgressDialog();
  return true;
}

function oficial_desconectar()
{
  var cursor: FLSqlCursor = this.cursor();
  var nombreBD: String = cursor.valueBuffer("nombrebd");

  if (!sys.removeDatabase(this.iface.conexion));
  return false;

  this.iface.bd_ = false;

  return true;
}


/** \D
@param valoresClave. Array con los valores que definen si el
registro existe en local. Puede ir vacio en cuyo caso se toma la
clave primaria
*/
function oficial_importarTabla(tabla: String, nomTabla: String, valoresClave: Array, facturacion: Boolean, limite: Number)
{
  var _i = this.iface;
  var util: FLUtil = new FLUtil();

  var curMod: FLSqlCursor = new FLSqlCursor("registrosmodificados", this.iface.conexion);

  curMod.select("tabla = '" + tabla + "' AND modificado = true");
  if (curMod.size() == 0)
    return 0;

  var paso: Number = 0;
  var modificados: Array = [];
  while (curMod.next()) {
    modificados[paso] = new Array(2);
    modificados[paso]["idmod"] = curMod.valueBuffer("id");
    modificados[paso]["clave"] = curMod.valueBuffer("clave");

    paso++;

    if (limite && paso >= limite)
      break;
  }

  // Registros de registromodificados correctamente importados. Para eliminar después
  var yaActualizados: Array = [];

  var curLoc: FLSqlCursor = new FLSqlCursor(tabla);
  var curRem: FLSqlCursor = new FLSqlCursor(tabla, this.iface.conexion);
  campoClave = curLoc.primaryKey();

  var listaCampos: Array = this.iface.obtenerListaCampos(tabla);

  var valorClave;
  var importados: Number = 0;
  var valor;
  var validarProv: Boolean;

  util.createProgressDialog(util.translate("scripts", "Importando ") + nomTabla, modificados.length);
  util.setProgress(1);

  for (var i: Number = 0; i < modificados.length; i++) {
    util.setProgress(i);

    // Situamos el cursor remoto. Si no existe, se borra el registro de modificado
    curRem.select(campoClave + " = '" + modificados[i]["clave"] + "'");
    if (curRem.first())
      curRem.setModeAccess(curRem.Browse);
    else {
      yaActualizados[yaActualizados.length] = modificados[i]["idmod"];
      continue;
    }

    // Sólo se importan las series registradas
    if (facturacion)
      if (this.iface.seriesImportables.search(curRem.valueBuffer("codserie")) == -1)
        continue;


    var valorClave: String;
    if (valoresClave) {

      // 1. Probamos en la tabla de correspondencias
      claveLocTupla = util.sqlSelect("correspondenciasreg", "claveloc", "bd = '" + _i.bd_ + "' and tabla = '" + tabla + "' AND claverem = '" + modificados[i]["clave"] + "'");
      if (claveLocTupla)
        selectLocal = campoClave + " = '" + claveLocTupla + "'";

      // 2. Buscamos por campos compuestos
      else {
        selectLocal = "";
        for (var j: Number; j < valoresClave.length; j++) {
          if (selectLocal) {
            selectLocal += " AND ";
          }
          if (curRem.fieldType(valoresClave[j]) == 3) {
            valorClave = this.iface.procesarCadena(curRem.valueBuffer(valoresClave[j]));
          } else {
            valorClave = curRem.valueBuffer(valoresClave[j]);
          }
          selectLocal += valoresClave[j] + " = '" + valorClave + "'";
        }
      }
    } else
      selectLocal = campoClave + " = '" + modificados[i]["clave"] + "'";

    curLoc = new FLSqlCursor(tabla);

    curLoc.select(selectLocal);
    debug(selectLocal);

    if (curLoc.first()) {
      curLoc.setModeAccess(curLoc.Edit);
      curLoc.refreshBuffer();
    } else {
      curLoc.setModeAccess(curLoc.Insert);
      curLoc.refreshBuffer();

      // Si es campo counter
      if (curLoc.fieldType(campoClave) == 3 && valoresClave)
        curLoc.setValueBuffer(campoClave, util.nextCounter(campoClave, curLoc));
    }


    // Bucle de campos
    for (var i = 0; i < listaCampos.length; i++) {

      // Si buscamos por valores clave no copiamos el id/código
      if (valoresClave && listaCampos[i] == campoClave)
        continue;

      // Excepciones *****************
      if ((listaCampos[i] == "idpagodevol" || listaCampos[i] == "idasiento" || listaCampos[i] == "editable" || listaCampos[i] == "genrecibos") && (tabla == "facturascli" || tabla == "facturasprov"))
        continue;
      if (listaCampos[i] == "coddir" && (tabla == "facturascli" || tabla == "albaranescli")) {
        curLoc.setNull("coddir");
        continue;
      }

      valor = curRem.valueBuffer(listaCampos[i]);
      curLoc.setValueBuffer(listaCampos[i], valor);
    }
    if (curLoc.valueBuffer("idprovincia")) {

      validarProv = util.sqlSelect("paises", "validarprov", "codpais = '" + curLoc.valueBuffer("codpais") + "'");

      valor = util.sqlSelect("provincias", "idprovincia", "codpais='" + curLoc.valueBuffer("codpais") + "' and provincia = '" + curLoc.valueBuffer("provincia") + "'");
      if (!valor && validarProv) {
        MessageBox.warning(util.translate("scripts", "No se encuentra la provincia %0. Debes introducirla") .arg(curLoc.valueBuffer("provincia")), MessageBox.Yes, MessageBox.NoButton, MessageBox.NoButton);
        continue;
      }

      if (valor)
        curLoc.setValueBuffer("idprovincia", valor);
      else
        curLoc.setNull("idprovincia");
    } else
      curLoc.setNull("idprovincia");


    if (facturacion && (tabla == "facturascli" || tabla == "facturasprov")) {
      curLoc = this.iface.totalesFacturacion(curLoc, true);
      curLoc.setValueBuffer("nogenerarasiento", true);
    }

    if (!this.iface.masDatosCursorLocal(tabla, curLoc))
      return false;

    comitLocal = curLoc.commitBuffer();
    this.iface.actualizarTuplaClaves(tabla, curLoc.valueBuffer(campoClave), curRem.valueBuffer(campoClave));

    // Actualizar líneas si es necesario
    if (comitLocal && facturacion) {

      if (!this.iface.importarLineas(tabla, curRem.valueBuffer("codigo")))
        continue;

      // Para acciones de commit (recalcular el asiento en facturas, etc)
      curLoc.select(selectLocal);
      curLoc.first();
      curLoc.setModeAccess(curLoc.Edit);
      curLoc.refreshBuffer();
      curLoc = this.iface.totalesFacturacion(curLoc);
      if (tabla == "facturascli" || tabla == "facturasprov")
        curLoc.setValueBuffer("nogenerarasiento", false);
      if (curLoc.commitBuffer()) {
        if (tabla == "albaranescli")
          this.iface.actualizarIDfacturaAlbaranCli(curLoc);
        if (tabla == "albaranesprov")
          this.iface.actualizarIDfacturaAlbaranProv(curLoc);
        this.iface.anotarRegistroExportado(tabla, curRem.valueBuffer("codigo"));
        this.iface.tedResultados.append("Importado " + tabla + " " + curRem.valueBuffer("codigo"));
      } else
        this.iface.tedResultados.append("Importación errónea " + tabla + " " + curRem.valueBuffer("codigo"));

    }

    // OK local
    if (comitLocal) {
      yaActualizados[yaActualizados.length] = modificados[i]["idmod"];
      importados++;
    }
    // Error
    else
      debug(util.translate("scripts", "Error al importar en la tabla remota %0 el código/id ").arg(tabla) + valorClave);

  }

  this.iface.anotarRegistrosImportados(yaActualizados, tabla);

  util.destroyProgressDialog();
  return importados;
}

/** \D Procesa una cadena a copiar para evitar las comillas simples
@param  cadenaO: Cadena a copiar
@return cadena procesada
\end */
function oficial_procesarCadena(cadenaO: String): String {
  if (!cadenaO || cadenaO == "")
  {
    return "";
  }
  var caracter: String;
  var cadenaD: String = "";
  for (var i: Number = 0; i < cadenaO.length; i++)
  {
    caracter = cadenaO.charAt(i);
    switch (caracter) {
      case "'": {
        cadenaD += "''";
        break;
      }
      default: {
        cadenaD += caracter;
      }
    }
  }
  return cadenaD;
}

/** \D Importa las líneas de una factura/albarán
*/
function oficial_importarLineas(tablaPadre: String, codigoPadre: String): Boolean {
  debug("LINEAS de " + tablaPadre + " " + codigoPadre);

  var util: FLUtil = new FLUtil();

  var tabla: String, campoClave: String, campoClaveRel: String;

  switch (tablaPadre)
  {
    case "facturascli":
      tabla = "lineasfacturascli";
      campoClaveRel = "idfactura";
      campoClave = "idlinea";
      break;

    case "albaranescli":
      tabla = "lineasalbaranescli";
      campoClaveRel = "idalbaran";
      campoClave = "idlinea";
      break;

    case "facturasprov":
      tabla = "lineasfacturasprov";
      campoClaveRel = "idfactura";
      campoClave = "idlinea";
      break;

    case "albaranesprov":
      tabla = "lineasalbaranesprov";
      campoClaveRel = "idalbaran";
      campoClave = "idlinea";
      break;
  }

  var idPadreRem: Number = util.sqlSelect(tablaPadre, campoClaveRel, "codigo = '" + codigoPadre + "'", "", this.iface.conexion);
  var idPadreLoc: Number = util.sqlSelect(tablaPadre, campoClaveRel, "codigo = '" + codigoPadre + "'");

  var curLoc: FLSqlCursor = new FLSqlCursor(tabla);
  var curRem: FLSqlCursor = new FLSqlCursor(tabla, this.iface.conexion);
  campoClave = curLoc.primaryKey();

  var listaCampos: Array = this.iface.obtenerListaCampos(tabla);

  var valorClave;
  var importados: Number = 0;
  var valor;

  curRem.select(campoClaveRel + " = " + idPadreRem);
  if (curRem.size() == 0)
    return 0;

  // borrar líneas en local si existen
  util.sqlDelete(tabla, campoClaveRel + " = " + idPadreLoc);

  var paso: Number = 0;
  while (curRem.next())
  {

    curLoc = new FLSqlCursor(tabla);

    curLoc.setModeAccess(curLoc.Insert);
    curLoc.refreshBuffer();

    // Bucle de campos
    for (var i = 0; i < listaCampos.length; i++) {

      // idlinea / idapgodevol *****************
      if (listaCampos[i] == campoClave)
        continue;

      if (listaCampos[i] == campoClaveRel) {
        curLoc.setValueBuffer(campoClaveRel, idPadreLoc);
        continue;
      }

      // Excepciones *****************
      if (listaCampos[i] == "idsubcuenta" && tabla == "lineasfacturasprov")
        continue;

      valor = curRem.valueBuffer(listaCampos[i]);
      curLoc.setValueBuffer(listaCampos[i], valor);

    }

    // OK local
    if (curLoc.commitBuffer())
      importados++;

    // Error
    else {
      debug(util.translate("scripts", "Error al importar en la tabla remota %0 el código/id ").arg(tabla) + valorClave);
      return false
    }
  }

         return true;
}



/** \D Importa sólo los clientes controlando si se han creado simultáneamente en local y remoto
*/
function oficial_importarClientes()
{
  var _i = this.iface;
  var util: FLUtil = new FLUtil();
  var tabla: String = "clientes";
  var nomTabla: String = "Clientes";
  var campoClave: String = "codcliente";

  var curMod: FLSqlCursor = new FLSqlCursor("registrosmodificados", this.iface.conexion);

  curMod.select("tabla = '" + tabla + "' AND modificado = true");
  if (curMod.size() == 0)
    return 0;

  var paso: Number = 0;
  var modificados: Array = [];
  while (curMod.next()) {
    modificados[paso] = new Array(2);
    modificados[paso]["idmod"] = curMod.valueBuffer("id");
    modificados[paso]["clave"] = curMod.valueBuffer("clave");
    paso++;
  }

  this.iface.tedResultados.append("<h3>Importando clientes</h3>");

  // Registros de registromodificados correctamente importados. Para eliminar después
  var yaActualizados: Array = [];

  var curLoc: FLSqlCursor = new FLSqlCursor(tabla);
  var curRem: FLSqlCursor = new FLSqlCursor(tabla, this.iface.conexion);

  var listaCampos: Array = this.iface.obtenerListaCampos(tabla);

  var valorClave;
  var importados: Number = 0;
  var valor;

  util.createProgressDialog(util.translate("scripts", "Importando ") + nomTabla, modificados.length);
  util.setProgress(1);

  for (var i: Number = 0; i < modificados.length; i++) {

    // Situamos el cursor remoto. Si no existe, se borra el registro de modificado
    curRem.select(campoClave + " = '" + modificados[i]["clave"] + "'");
    if (curRem.first())
      curRem.setModeAccess(curRem.Browse);
    else {
      yaActualizados[yaActualizados.length] = modificados[i]["idmod"];
      continue;
    }

    selectLocal = campoClave + " = '" + modificados[i]["clave"] + "'";
    debug("	selectLocal " + selectLocal);
    curLoc = new FLSqlCursor(tabla);
    curLoc.select(selectLocal);

    if (curLoc.first()) {
      debug("ha cliente");
      // Si no hay tupla, se ha creado el mismo cliente en local y remoto
      if (!util.sqlSelect("correspondenciasreg", "id", "bd = '" + _i.bd_ + "' and tabla = 'clientes' AND claveloc = '" + modificados[i]["clave"] + "'")) {
        var res = MessageBox.warning(util.translate("scripts", "Atención!\n\nEl cliente %0 ha sido creado simultáneamente en local y remoto:\n\nNombre en local: %0\nNombre en remoto: %0\n\nPulsa SÍ si se trata del mismo cliente (situación correcta)\nPulsa NO para saltar la actualización de este cliente\nPulsa CANCELAR para parar todo el proceso").arg(modificados[i]["clave"]).arg(curLoc.valueBuffer("nombre")).arg(curRem.valueBuffer("nombre")),
                                     MessageBox.Yes, MessageBox.No, MessageBox.Cancel);

        switch (res) {
          case MessageBox.Yes:

            break;
          case MessageBox.No:
            continue;
            break;
          case MessageBox.Cancel:
            this.iface.anotarRegistrosImportados(yaActualizados, tabla);
            util.destroyProgressDialog();
            return -1;
            break;
        }
      }

      this.iface.tedResultados.append("Cliente modificado " +  modificados[i]["clave"]);

      curLoc.setModeAccess(curLoc.Edit);
      curLoc.refreshBuffer();
    } else {
      debug("ceando nuevo");
      curLoc.setModeAccess(curLoc.Insert);
      curLoc.refreshBuffer();
      this.iface.tedResultados.append("Cliente nuevo " +  modificados[i]["clave"]);
    }


    // Bucle de campos
    for (var i = 0; i < listaCampos.length; i++) {

      switch (listaCampos[i]) {

        case "codserie":
          if (curRem.valueBuffer(listaCampos[i]) == "EF")
            valor = "FE";
          else
            valor = flfactppal.iface.valorDefectoEmpresa("codserie");
          break;

        case "codcuentadom":
          // Si no hay codcuentadom en remoto, en local tampoco
          if (curRem.valueBuffer(listaCampos[i])) {
            if (curLoc.modeAccess() == curLoc.Insert || !curLoc.valueBuffer(listaCampos[i]))
              valor = "XXX";
            else
              continue;
          } else
            valor = "";
          break;

        default:
          valor = curRem.valueBuffer(listaCampos[i]);
      }

      debug(listaCampos[i] + " -> " + valor);
      curLoc.setValueBuffer(listaCampos[i], valor);
    }

    comitLocal = curLoc.commitBuffer();
    this.iface.actualizarTuplaClaves(tabla, curLoc.valueBuffer(campoClave), curRem.valueBuffer(campoClave));

    // OK local
    if (comitLocal) {
      this.iface.anotarRegistroExportado(tabla, modificados[i]["clave"]);
      yaActualizados[yaActualizados.length] = modificados[i]["idmod"];
      importados++;
      this.iface.actualizarDescripcionesSubctasCli(modificados[i]["clave"]);
    }
    // Error
    else
      debug(util.translate("scripts", "Error al importar en la tabla remota %0 el código/id ").arg(tabla) + valorClave);

    util.setProgress(i);
  }

  this.iface.anotarRegistrosImportados(yaActualizados, tabla);

  util.destroyProgressDialog();
  return importados;
}

function oficial_actualizarDescripcionesSubctasCli(codCliente: String)
{
  var util: FLUtil = new FLUtil();
  var codEjercicio: String = flfactppal.iface.pub_ejercicioActual();

  var q: FLSqlQuery = new FLSqlQuery();
  q.setTablesList("clientes,co_subcuentascli,co_subcuentas");
  q.setFrom("clientes c inner join co_subcuentascli sc on c.codcliente=sc.codcliente inner join co_subcuentas s on sc.idsubcuenta=s.idsubcuenta");
  q.setSelect("s.idsubcuenta,c.nombre,c.codcliente");
  q.setWhere("c.nombre <> s.descripcion and c.codcliente = '" + codCliente + "'");

  var curTab: FLSqlCursor = new FLSqlCursor("co_subcuentas");

  q.exec();

  while (q.next()) {

    curTab.select("idsubcuenta = " + q.value(0));
    if (!curTab.first())
      continue;

    curTab.setModeAccess(curTab.Edit);
    curTab.refreshBuffer();
    curTab.setValueBuffer("descripcion", q.value(1));
    curTab.commitBuffer();

    this.iface.tedResultados.append("Actualizando descripcion de subcuentas del cliente " + codCliente);
  }
}



/** \D Importa sólo los proveedores controlando si se han creado simultáneamente en local y remoto
*/
function oficial_importarProveedores()
{
  var util: FLUtil = new FLUtil();
  var tabla: String = "proveedores";
  var nomTabla: String = "Proveedores";
  var campoClave: String = "codproveedor";

  var curMod: FLSqlCursor = new FLSqlCursor("registrosmodificados", this.iface.conexion);

  curMod.select("tabla = '" + tabla + "' AND modificado = true");
  if (curMod.size() == 0)
    return 0;

  var paso: Number = 0;
  var modificados: Array = [];
  while (curMod.next()) {
    modificados[paso] = new Array(2);
    modificados[paso]["idmod"] = curMod.valueBuffer("id");
    modificados[paso]["clave"] = curMod.valueBuffer("clave");
    paso++;
  }

  this.iface.tedResultados.append("<h3>Importando proveedores</h3>");

  // Registros de registromodificados correctamente importados. Para eliminar después
  var yaActualizados: Array = [];

  var curLoc: FLSqlCursor = new FLSqlCursor(tabla);
  var curRem: FLSqlCursor = new FLSqlCursor(tabla, this.iface.conexion);

  var listaCampos: Array = this.iface.obtenerListaCampos(tabla);

  var valorClave;
  var importados: Number = 0;
  var valor;

  util.createProgressDialog(util.translate("scripts", "Importando ") + nomTabla, modificados.length);
  util.setProgress(1);

  for (var i: Number = 0; i < modificados.length; i++) {

    // Situamos el cursor remoto. Si no existe, se borra el registro de modificado
    curRem.select(campoClave + " = '" + modificados[i]["clave"] + "'");
    if (curRem.first())
      curRem.setModeAccess(curRem.Browse);
    else {
      yaActualizados[yaActualizados.length] = modificados[i]["idmod"];
      continue;
    }

    selectLocal = campoClave + " = '" + modificados[i]["clave"] + "'";

    curLoc = new FLSqlCursor(tabla);
    curLoc.select(selectLocal);

    if (curLoc.first()) {

      // Si no hay tupla, se ha creado el mismo cliente en local y remoto
      if (!util.sqlSelect("correspondenciasreg", "id", "bd = '" + _i.bd_ + "' and tabla = 'proveedores' AND claveloc = '" + modificados[i]["clave"] + "'")) {
        var res = MessageBox.warning(util.translate("scripts", "Atención!\n\nEl proveedor %0 ha sido creado simultáneamente en local y remoto:\n\nNombre en local: %0\nNombre en remoto: %0\n\nPulsa SÍ si se trata del mismo proveedor (situación correcta)\nPulsa NO para saltar la actualización de este proveedor\nPulsa CANCELAR para parar todo el proceso").arg(modificados[i]["clave"]).arg(curLoc.valueBuffer("nombre")).arg(curRem.valueBuffer("nombre")),
                                     MessageBox.Yes, MessageBox.No, MessageBox.Cancel);

        switch (res) {
          case MessageBox.Yes:

            break;
          case MessageBox.No:
            continue;
            break;
          case MessageBox.Cancel:
            this.iface.anotarRegistrosImportados(yaActualizados, tabla);
            util.destroyProgressDialog();
            return -1;
            break;
        }
      }

      this.iface.tedResultados.append("Proveedor modificado " +  modificados[i]["clave"]);

      curLoc.setModeAccess(curLoc.Edit);
      curLoc.refreshBuffer();
    } else {
      curLoc.setModeAccess(curLoc.Insert);
      curLoc.refreshBuffer();
      this.iface.tedResultados.append("Proveedor nuevo " +  modificados[i]["clave"]);
    }


    // Bucle de campos
    for (var i = 0; i < listaCampos.length; i++) {

      switch (listaCampos[i]) {

        case "codserie":
          if (curRem.valueBuffer(listaCampos[i]) == "EF")
            valor = "FE";
          else
            valor = flfactppal.iface.valorDefectoEmpresa("codserie");
          break;

        case "codcuentadom":
          // Si no hay codcuentadom en remoto, en local tampoco
          if (curRem.valueBuffer(listaCampos[i])) {
            if (curLoc.modeAccess() == curLoc.Insert || !curLoc.valueBuffer(listaCampos[i]))
              valor = "XXX";
            else
              continue;
          } else
            valor = "";
          break;

        default:
          valor = curRem.valueBuffer(listaCampos[i]);
      }

      debug(listaCampos[i] + " -> " + valor);
      curLoc.setValueBuffer(listaCampos[i], valor);
    }

    comitLocal = curLoc.commitBuffer();
    this.iface.actualizarTuplaClaves(tabla, curLoc.valueBuffer(campoClave), curRem.valueBuffer(campoClave));

    // OK local
    if (comitLocal) {
      this.iface.anotarRegistroExportado(tabla, modificados[i]["clave"]);
      yaActualizados[yaActualizados.length] = modificados[i]["idmod"];
      importados++;
      this.iface.actualizarDescripcionesSubctasProv(modificados[i]["clave"]);
    }
    // Error
    else
      debug(util.translate("scripts", "Error al importar en la tabla remota %0 el código/id ").arg(tabla) + valorClave);

    util.setProgress(i);
  }

  this.iface.anotarRegistrosImportados(yaActualizados, tabla);

  util.destroyProgressDialog();
  return importados;
}

function oficial_actualizarDescripcionesSubctasProv(codProveedor: String)
{
  var util: FLUtil = new FLUtil();
  var codEjercicio: String = flfactppal.iface.pub_ejercicioActual();

  var q: FLSqlQuery = new FLSqlQuery();
  q.setTablesList("proveedores,co_subcuentasprov,co_subcuentas");
  q.setFrom("proveedores p inner join co_subcuentasprov sp on p.codproveedor=sp.codproveedor inner join co_subcuentas s on sp.idsubcuenta=s.idsubcuenta");
  q.setSelect("s.idsubcuenta,p.nombre,p.codproveedor");
  q.setWhere("p.nombre <> s.descripcion and p.codproveedor = '" + codProveedor + "'");

  var curTab: FLSqlCursor = new FLSqlCursor("co_subcuentas");

  q.exec();

  while (q.next()) {

    curTab.select("idsubcuenta = " + q.value(0));
    if (!curTab.first())
      continue;

    curTab.setModeAccess(curTab.Edit);
    curTab.refreshBuffer();
    curTab.setValueBuffer("descripcion", q.value(1));
    curTab.commitBuffer();

    this.iface.tedResultados.append("Actualizando descripcion de subcuentas del proveedor " + codProveedor);
  }
}



/** \D Importa o actualiza las remesas. El id de remesa en local es idLocal = 5000 + idRemoto
*/
function oficial_importarRemesas()
{
  this.iface.incRemesa = 5000;

  var util: FLUtil = new FLUtil();
  var tabla: String = "remesas";
  var nomTabla: String = "Remesas";
  var campoClave: String = "idremesa";
  var codEjercicio: String = flfactppal.iface.pub_ejercicioActual();

  var curMod: FLSqlCursor = new FLSqlCursor("registrosmodificados", this.iface.conexion);

  curMod.select("tabla = '" + tabla + "' AND modificado = true");
  if (curMod.size() == 0)
    return 0;

  var limite: Number = this.child("fdbLimite").value();

  var paso: Number = 0;
  var modificados: Array = [];
  while (curMod.next()) {
    modificados[paso] = new Array(2);
    modificados[paso]["idmod"] = curMod.valueBuffer("id");
    modificados[paso]["clave"] = curMod.valueBuffer("clave");

    if (paso >= limite)
      break;

    paso++;
  }

  // Registros de registromodificados correctamente importados. Para eliminar después
  var yaActualizados: Array = [];

  var curLoc: FLSqlCursor = new FLSqlCursor(tabla);
  var curRem: FLSqlCursor = new FLSqlCursor(tabla, this.iface.conexion);

  var listaCampos: Array = this.iface.obtenerListaCampos(tabla);

  var valorClave;
  var importados: Number = 0;
  var valor;

  util.createProgressDialog(util.translate("scripts", "Importando ") + nomTabla, modificados.length);
  util.setProgress(1);

  var claveLoc: Number;

  for (var i: Number = 0; i < modificados.length; i++) {
    util.setProgress(i);
    util.setLabelText("Remesa " + modificados[i]["clave"]);
    debug("Remesa " + modificados[i]["clave"]);

    // Situamos el cursor remoto. Si no existe, se borra el registro de modificado
    curRem.select(campoClave + " = " + modificados[i]["clave"]);
    if (curRem.first())
      curRem.setModeAccess(curRem.Browse);
    else {
      yaActualizados[yaActualizados.length] = modificados[i]["idmod"];
      continue;
    }

    fechaRemesa = curRem.valueBuffer("fecha");
    if (!util.sqlSelect("ejercicios", "codejercicio", "codejercicio = '" + codEjercicio + "' AND fechainicio <= '" + fechaRemesa + "'" + " AND fechafin >= '" + fechaRemesa + "'" + " AND estado = 'ABIERTO'")) {
      MessageBox.warning(util.translate("scripts",  "La remesa %0 no se importará porque no pertenece al ejercicio activo\nCambia el ejercicio y repite la importación").arg(modificados[i]["clave"]), MessageBox.Ok, MessageBox.NoButton);
      continue;
    }

    claveLoc = parseFloat(modificados[i]["clave"]) + this.iface.incRemesa;
    selectLocal = campoClave + " = '" + claveLoc + "'";

    curLoc = new FLSqlCursor(tabla);

    curLoc.select(selectLocal);
    existeLocal = false;

    if (curLoc.first()) {
      existeLocal = true;
      curLoc.setModeAccess(curLoc.Edit);
      curLoc.refreshBuffer();
    } else {
      curLoc.setModeAccess(curLoc.Insert);
      curLoc.refreshBuffer();
    }

    // Bucle de campos
    for (var i = 0; i < listaCampos.length; i++) {
      if (listaCampos[i] == "idasiento")
        continue;
      valor = curRem.valueBuffer(listaCampos[i]);
      curLoc.setValueBuffer(listaCampos[i], valor);
    }

    debug("A" + curLoc.valueBuffer("idasiento"));

    // Local = remoto + incRemesa (ej. 5000)
    curLoc.setValueBuffer("idremesa", claveLoc);

    idSubcuenta = util.sqlSelect("co_subcuentas", "idsubcuenta", "codsubcuenta = '" + curRem.valueBuffer("codsubcuenta") + "' AND codejercicio = '" + codEjercicio + "'");
    if (!idSubcuenta) {
      MessageBox.warning(util.translate("scripts",
                                        "No es posible importar la remesa %0 porque no existe la subcuenta %0 en el ejercicio actual").arg(curRem.valueBuffer("idremesa")).arg(curRem.valueBuffer("codsubcuenta")),
                         MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
      continue;
    }
    curLoc.setValueBuffer("idsubcuenta", idSubcuenta);

    // Si es nueva, se guarda primero para que existan los pagos/devoluciones cuando se crea la remesa
    if (!existeLocal) {
      curLoc.setActivatedCommitActions(false);
      comitLocal = curLoc.commitBuffer();
    }

    util.sqlDelete("pagosdevolcli", "idremesa = " + claveLoc);
    this.iface.importarPD("pagosdevolcli", "reciboscli", curRem.valueBuffer("idremesa"));

    curLoc.setActivatedCommitActions(true);

    // Para regenerar el asiento de la remesa
    curLoc.setModeAccess(curLoc.Edit);
    curLoc.refreshBuffer();
    comitLocal = curLoc.commitBuffer();

    this.iface.actualizarTuplaClaves(tabla, curLoc.valueBuffer(campoClave), curRem.valueBuffer(campoClave)); // Just in case

    // OK local
    if (comitLocal) {
      yaActualizados[yaActualizados.length] = modificados[i]["idmod"];
      this.iface.anotarRegistroExportado(tabla, curRem.valueBuffer("idremesa"));
      importados++;
    }
    // Error
    else
      debug(util.translate("scripts", "Error al importar en la tabla remota %0 el código/id ").arg(tabla) + valorClave);

  }

  this.iface.anotarRegistrosImportados(yaActualizados, tabla);

  util.destroyProgressDialog();
  return importados;
}




/** \D Importa pagos y devoluciones de un recibo
*/
function oficial_importarPD(tabla: String, tablaPadre: String, idRemesa: Number)
{
  var util: FLUtil = new FLUtil();
  var _i = this.iface;
  var curPad: FLSqlCursor = new FLSqlCursor(tablaPadre);
  var curLoc: FLSqlCursor = new FLSqlCursor(tabla);
  var curRem: FLSqlCursor = new FLSqlCursor(tabla, this.iface.conexion);

  var curMod: FLSqlCursor = new FLSqlCursor("registrosmodificados", this.iface.conexion);

  curMod.select("tabla = '" + tabla + "'");
  if (curMod.size() == 0)
    return 0;

  var limite: Number = this.child("fdbLimite").value();
  var codEjercicio: String = flfactppal.iface.pub_ejercicioActual();

  var paso: Number = 0;
  var modificados: Array = [];
  var idAsientoRemesa: Number;

  // Si es una remesa, se importan todos los pagos
  if (idRemesa) {
    curRem.select("idremesa = " + idRemesa);
    while (curRem.next()) {
      modificados[paso] = new Array(3);
      modificados[paso]["idmod"] = 0;
      modificados[paso]["clave"] = curRem.valueBuffer("idpagodevol");
      modificados[paso]["borrado"] = false;
      paso++;
    }

    idRemesaLoc = parseFloat(idRemesa) + this.iface.incRemesa;
    idAsientoRemesa = util.sqlSelect("remesas", "idasiento", "idremesa = " + idRemesaLoc);
  }

  else {
    while (curMod.next()) {
      modificados[paso] = new Array(3);
      modificados[paso]["idmod"] = curMod.valueBuffer("id");
      modificados[paso]["clave"] = curMod.valueBuffer("clave");
      modificados[paso]["borrado"] = curMod.valueBuffer("borrado");

      if (paso >= limite)
        break;

      paso++;
    }
  }

  // Registros de registromodificados correctamente importados. Para eliminar después
  var yaActualizados: Array = [];

  campoClave = curLoc.primaryKey();

  var listaCampos: Array = this.iface.obtenerListaCampos(tabla);

  var valorClave;
  var importados: Number = 0;
  var valor;
  var codRecibo: String, codCliente: String, idReciboLoc: Number;
  var pagosSimultaneos: String = "";
  var recibosNoLocal: String = "";
  var recibosPartidos: String = "";
  var pagosFueraFecha: String = "";
  var importeRem: Number, importeLoc: Number;
  var codEjercicio: String = flfactppal.iface.pub_ejercicioActual();

  util.createProgressDialog(util.translate("scripts", "Importando ") + tabla, modificados.length);
  util.setProgress(1);

  for (var i: Number = 0; i < modificados.length; i++) {
    util.setProgress(i);

    if (idRemesa)
      util.setLabelText(util.translate("scripts", "Importando pagos/devoluciones de remesa ") + idRemesa);

    // Buscamos la tupla por si el pago/dev existe ya
    claveLocTupla = util.sqlSelect("correspondenciasreg", "claveloc", "bd = '" + _i.bd_ + "' and tabla = '" + tabla + "' AND claverem = '" + modificados[i]["clave"] + "'");

    curLoc = new FLSqlCursor(tabla);

    // Situamos el cursor remoto.
    curRem.select(campoClave + " = '" + modificados[i]["clave"] + "'");
    if (curRem.first())
      curRem.setModeAccess(curRem.Browse);

    // No está. Se trata de un borrado? Existe la tupla (existe en local)?
    else {
      if (modificados[i]["borrado"] && claveLocTupla) {

        selectLocal = campoClave + " = '" + claveLocTupla + "'";
        curLoc.select(selectLocal);
        if (!curLoc.first()) {
          yaActualizados[yaActualizados.length] = modificados[i]["idmod"];
          continue;
        }

        idReciboLoc = curLoc.valueBuffer("idrecibo");
        curLoc.setModeAccess(curLoc.Del);
        curLoc.refreshBuffer();
        comitLocal = curLoc.commitBuffer();

        // OK local
        if (comitLocal) {
          this.iface.actualizarEstadoRecibo(tabla, tablaPadre, idReciboLoc);
          importados++;
        }
      }

      yaActualizados[yaActualizados.length] = modificados[i]["idmod"];
      continue;
    }


    // Código del recibo que contiene el pago/dev
    codRecibo = util.sqlSelect(tablaPadre, "codigo", "idrecibo = " + curRem.valueBuffer("idrecibo"), "", this.iface.conexion);
    codCliente = util.sqlSelect(tablaPadre, "codcliente", "idrecibo = " + curRem.valueBuffer("idrecibo"), "", this.iface.conexion);
    importeRem = util.sqlSelect(tablaPadre, "importe", "idrecibo = " + curRem.valueBuffer("idrecibo"), "", this.iface.conexion);

    // Id e improte del recibo local
    idReciboLoc = util.sqlSelect(tablaPadre, "idrecibo", "codigo = '" + codRecibo + "'");
    importeLoc = util.sqlSelect(tablaPadre, "importe", "codigo = '" + codRecibo + "'");

    if (!idReciboLoc) {
      recibosNoLocal += "<br>" + codRecibo;
      debug(util.translate("scripts", "Error al importar los pagos para el recibo %0. Este recibo no existe en local").arg(codRecibo));
      continue;
    }

    if (parseFloat(importeRem) != parseFloat(importeLoc)) {
      this.iface.tedResultados.append("Detectado recibo con importe modificado " + codRecibo);
      debug(util.translate("scripts", "Detectado recibo con importe modificado").arg(codRecibo));

      if (parseFloat(importeRem) < parseFloat(importeLoc)) {
        curPad.select("idrecibo = " + idReciboLoc);
        if (curPad.first()) {
          curPad.setModeAccess(curPad.Edit);
          curPad.refreshBuffer();
          curPad.setValueBuffer("importe", importeRem);
          curPad.commitBuffer();
        } else {
          recibosPartidos += "<br>" + codRecibo;
          continue;
        }
      } else {
        recibosPartidos += "<br>" + codRecibo;
        continue;
      }
      this.iface.tedResultados.append("Modificado el importe del recibo " + codRecibo);
    }

    debug("Pagos para el recibo " + codRecibo + " " + idReciboLoc);
    this.iface.tedResultados.append("Importado pagos para el recibo " + codRecibo);

    fechaPD = curRem.valueBuffer("fecha");
    if (!util.sqlSelect("ejercicios", "codejercicio", "codejercicio = '" + codEjercicio + "' AND fechainicio <= '" + fechaPD + "'" + " AND fechafin >= '" + fechaPD + "'" + " AND estado = 'ABIERTO'")) {
      pagosFueraFecha += "<br>" + codRecibo;
      continue;
    }

    curLoc = new FLSqlCursor(tabla);

    if (claveLocTupla) {
      selectLocal = campoClave + " = '" + claveLocTupla + "'";
      curLoc.select(selectLocal);

      if (curLoc.first()) {
        editable = curLoc.valueBuffer("editable");
        if (!editable) {
          curLoc.setUnLock("editable", true);
          curLoc.select(selectLocal);
          curLoc.first();
        }
        curLoc.setModeAccess(curLoc.Edit);
      } else
        curLoc.setModeAccess(curLoc.Insert);
    }

    // Nuevo pago/dev
    else {
      // tiene ya pagos en local?
      if (this.iface.pagosLocal(idReciboLoc)) {
        pagosSimultaneos += "<br>" + codRecibo;
        continue;
      }
      curLoc.setModeAccess(curLoc.Insert);
    }


    curLoc.refreshBuffer();

    // Bucle de campos
    for (var i = 0; i < listaCampos.length; i++) {

      // Si buscamos por valores clave no copiamos el id/código
      // Excepciones *****************
      if (listaCampos[i] == "idpagodevol")
        continue;

      if (listaCampos[i] == "idasiento") {
        if (idAsientoRemesa)
          curLoc.setValueBuffer(listaCampos[i], idAsientoRemesa);
        continue;
      }

      if (curRem.isNull(listaCampos[i])) {
        curLoc.setNull(listaCampos[i]);
      } else {
        valor = curRem.valueBuffer(listaCampos[i]);
        curLoc.setValueBuffer(listaCampos[i], valor);
      }
    }

    idSubcuenta = util.sqlSelect("co_subcuentas", "idsubcuenta", "codsubcuenta = '" + curRem.valueBuffer("codsubcuenta") + "' AND codejercicio = '" + codEjercicio + "'");
    curLoc.setValueBuffer("idsubcuenta", idSubcuenta);

    // Si es de remesa: idRemesa local = irRemesa remoto + incRemesa
    if (curLoc.valueBuffer("idremesa")) {
      valor = parseFloat(curLoc.valueBuffer("idremesa")) + this.iface.incRemesa;
      debug("REMESA PARA EL RECIBO " + valor);
      curLoc.setValueBuffer("idremesa", valor);
    }

    curLoc.setValueBuffer("idrecibo", idReciboLoc);

    comitLocal = curLoc.commitBuffer();
    this.iface.actualizarTuplaClaves(tabla, curLoc.valueBuffer(campoClave), curRem.valueBuffer(campoClave));

    // OK local
    if (comitLocal) {
      this.iface.actualizarEstadoRecibo(tabla, tablaPadre, idReciboLoc);
      if (!idRemesa)
        yaActualizados[yaActualizados.length] = modificados[i]["idmod"];
      importados++;
    }
    // Error
    else
      debug(util.translate("scripts", "Error al importar en la tabla remota %0 el código/id ").arg(tabla) + valorClave);

  }

  if (!idRemesa)
    this.iface.anotarRegistrosImportados(yaActualizados, tabla);

  util.destroyProgressDialog();

  var msg: String = "";
  if (pagosSimultaneos) {
    msg += "<h3>Pagos simultáneos</h3>";
    msg += "Algunos recibos han sido pagados o devueltos simultáneamente local y remotamente.<br>Deberás eliminar los pagos/devoluciones de local o remoto y repetir la importación.<br><br>Los recibos afectados son:<br>" + pagosSimultaneos;
  }

  if (recibosPartidos) {
    msg += "<h3>Recibos de importe modificado en local/remoto</h3>";
    msg += "Algunos recibos tienen distinto importe en local y remoto, posiblemente debido a que se han dividido. Deberás realizar la misma división en local y remoto y repetir la importación<br><br>Los recibos afectados son:<br>" + recibosPartidos;
  }

  if (recibosNoLocal) {
    msg += "<h3>Recibos inexistentes en local</h3>";
    msg += "Algunos pagos corresponden a recibos que no existen en local<br><br>Los recibos afectados son:<br>" + recibosNoLocal;
  }

  if (pagosFueraFecha) {
    msg += "<h3>Pagos fuera de ejercicio</h3>";
    msg += "Algunos pagos corresponden a recibos de un ejercicio que no es el activo.<br>Deberás cambiar el ejercicio y repetir la importacion<br><br>Los recibos afectados son:<br>" + pagosFueraFecha;
  }

  this.iface.tedResultados.append(msg);
  return importados;
}

/** Se busca si existe algún pago/devolución para el recibo que no tenga asociada
una tupla, es decir, que haya sido introducido en local y no importado.
*/
function oficial_pagosLocal(idRecibo: Number): Boolean {
  var _i = this.iface;
  var util: FLUtil = new FLUtil();
  debug("Buscando pagos para el recibo " + idRecibo);

  var curTab: FLSqlCursor = new FLSqlCursor("pagosdevolcli");
  curTab.select("idrecibo = " + idRecibo);
  while (curTab.next())
  {
    if (!util.sqlSelect("correspondenciasreg", "claveloc", "bd = '" + _i.bd_ + "' and claveloc = '" + curTab.valueBuffer("idpagodevol") + "' AND tabla = 'pagosdevolcli'"))
      return true;
  }

  return false;
}

function oficial_actualizarEstadoRecibo(tabla: String, tablaPadre: String, idRecibo: String)
{
  var util: FLUtil = new FLUtil();
  debug("Actualizando el estado del recibo " + idRecibo);

  var curTab: FLSqlCursor = new FLSqlCursor(tablaPadre);
  curTab.select("idrecibo = '" + idRecibo + "'");
  if (!curTab.first()) {
    debug(util.translate("scripts", "Error al actualizar el estado del %0 con idrecibo ").arg(tablaPadre) + idRecibo);
    return;
  }

  var estado: String = "Emitido";

  var tipoUltimoPD: String = util.sqlSelect(tabla, "tipo", "idrecibo = " + idRecibo + " ORDER BY fecha DESC, idpagodevol DESC");

  if (tipoUltimoPD == "Pago")
    estado = "Pagado";
  else if (tipoUltimoPD)
    estado = "Devuelto";

  curTab.setModeAccess(curTab.Edit);
  curTab.refreshBuffer();
  curTab.setValueBuffer("estado", estado);
  if (!curTab.commitBuffer())
    debug(util.translate("scripts", "Error al actualizar el estado del %0 con código ").arg(tabla) + idRecibo);
}


function oficial_totalesFacturacion(curFacturacion: FLSqlCursor, aCero: Boolean): FLSqlCursor {
  if (aCero)
  {
    curFacturacion.setValueBuffer("neto", 0);
    curFacturacion.setValueBuffer("totaliva", 0);
    curFacturacion.setValueBuffer("totalirpf", 0);
    curFacturacion.setValueBuffer("totalrecargo", 0);
    curFacturacion.setValueBuffer("total", 0);
    curFacturacion.setValueBuffer("totaleuros", 0);
  }

  else {
    switch (curFacturacion.table())
    {
      case "facturascli":
        curFacturacion.setValueBuffer("neto", formfacturascli.iface.pub_commonCalculateField("neto", curFacturacion));
        curFacturacion.setValueBuffer("totaliva", formfacturascli.iface.pub_commonCalculateField("totaliva", curFacturacion));
        curFacturacion.setValueBuffer("totalirpf", formfacturascli.iface.pub_commonCalculateField("totalirpf", curFacturacion));
        curFacturacion.setValueBuffer("totalrecargo", formfacturascli.iface.pub_commonCalculateField("totalrecargo", curFacturacion));
        curFacturacion.setValueBuffer("total", formfacturascli.iface.pub_commonCalculateField("total", curFacturacion));
        curFacturacion.setValueBuffer("totaleuros", formfacturascli.iface.pub_commonCalculateField("totaleuros", curFacturacion));
        break;

      case "facturasprov":
        curFacturacion.setValueBuffer("neto", formfacturasprov.iface.pub_commonCalculateField("neto", curFacturacion));
        curFacturacion.setValueBuffer("totaliva", formfacturasprov.iface.pub_commonCalculateField("totaliva", curFacturacion));
        curFacturacion.setValueBuffer("totalirpf", formfacturasprov.iface.pub_commonCalculateField("totalirpf", curFacturacion));
        curFacturacion.setValueBuffer("totalrecargo", formfacturasprov.iface.pub_commonCalculateField("totalrecargo", curFacturacion));
        curFacturacion.setValueBuffer("total", formfacturasprov.iface.pub_commonCalculateField("total", curFacturacion));
        curFacturacion.setValueBuffer("totaleuros", formfacturasprov.iface.pub_commonCalculateField("totaleuros", curFacturacion));
        break;

      case "albaranescli":
        curFacturacion.setValueBuffer("neto", formalbaranescli.iface.pub_commonCalculateField("neto", curFacturacion));
        curFacturacion.setValueBuffer("totaliva", formalbaranescli.iface.pub_commonCalculateField("totaliva", curFacturacion));
        curFacturacion.setValueBuffer("totalirpf", formalbaranescli.iface.pub_commonCalculateField("totalirpf", curFacturacion));
        curFacturacion.setValueBuffer("totalrecargo", formalbaranescli.iface.pub_commonCalculateField("totalrecargo", curFacturacion));
        curFacturacion.setValueBuffer("total", formalbaranescli.iface.pub_commonCalculateField("total", curFacturacion));
        curFacturacion.setValueBuffer("totaleuros", formalbaranescli.iface.pub_commonCalculateField("totaleuros", curFacturacion));
        break;

      case "albaranesprov":
        curFacturacion.setValueBuffer("neto", formalbaranesprov.iface.pub_commonCalculateField("neto", curFacturacion));
        curFacturacion.setValueBuffer("totaliva", formalbaranesprov.iface.pub_commonCalculateField("totaliva", curFacturacion));
        curFacturacion.setValueBuffer("totalirpf", formalbaranesprov.iface.pub_commonCalculateField("totalirpf", curFacturacion));
        curFacturacion.setValueBuffer("totalrecargo", formalbaranesprov.iface.pub_commonCalculateField("totalrecargo", curFacturacion));
        curFacturacion.setValueBuffer("total", formalbaranesprov.iface.pub_commonCalculateField("total", curFacturacion));
        curFacturacion.setValueBuffer("totaleuros", formalbaranesprov.iface.pub_commonCalculateField("totaleuros", curFacturacion));
        break;
    }
  }

  return curFacturacion;
}

/** Actualiza el idfactura en albaranes y el idalbaran en lineas de facturas
para facturas automáticas
*/
function oficial_actualizarIDfacturaAlbaranCli(curAlb: FLSqlCursor)
{
  var util: FLUtil = new FLUtil();
  var _i = this.iface;
  if (curAlb.table() != "albaranescli")
    return;

  var idAlbaranLoc: Number = curAlb.valueBuffer("idalbaran");

  var idAlbaranRem: Number = util.sqlSelect("correspondenciasreg", "claverem", "bd = '" + _i.bd_ + "' and tabla='albaranescli' AND claveloc = '" + idAlbaranLoc + "'");

  var idFacturaRem: Number = util.sqlSelect("albaranescli", "idfactura", "idalbaran = " + idAlbaranRem, "", this.iface.conexion);
  if (!idFacturaRem)
    return;

  var idFacturaLoc: Number = util.sqlSelect("correspondenciasreg", "claveloc", "bd = '" + _i.bd_ + "' and tabla='facturascli' AND claverem = '" + idFacturaRem + "'");
  if (!idFacturaLoc)
    return;

  util.sqlUpdate("lineasfacturascli", "idalbaran", idAlbaranLoc, "idfactura = " + idFacturaLoc + " AND idalbaran = " + idAlbaranRem);

  curAlb.setUnLock("ptefactura", true);
  curAlb.setModeAccess(curAlb.Edit);
  curAlb.refreshBuffer();
  curAlb.setValueBuffer("idfactura", idFacturaLoc);
  //  curAlb.setValueBuffer("ptefactura", false);
  curAlb = this.iface.totalesFacturacion(curAlb);
  curAlb.commitBuffer();
}


/** Actualiza el idfactura en albaranes y el idalbaran en lineas de facturas
para facturas automáticas
*/
function oficial_actualizarIDfacturaAlbaranProv(curAlb: FLSqlCursor)
{
  var util: FLUtil = new FLUtil();
  var _i = this.iface;
  if (curAlb.table() != "albaranesprov")
    return;

  var idAlbaranLoc: Number = curAlb.valueBuffer("idalbaran");

  var idAlbaranRem: Number = util.sqlSelect("correspondenciasreg", "claverem", "bd = '" + _i.bd_ + "' and tabla='albaranesprov' AND claveloc = '" + idAlbaranLoc + "'");

  var idFacturaRem: Number = util.sqlSelect("albaranesprov", "idfactura", "idalbaran = " + idAlbaranRem, "", this.iface.conexion);
  if (!idFacturaRem)
    return;

  var idFacturaLoc: Number = util.sqlSelect("correspondenciasreg", "claveloc", "bd = '" + _i.bd_ + "' and tabla='facturasprov' AND claverem = '" + idFacturaRem + "'");
  if (!idFacturaLoc)
    return;

  util.sqlUpdate("lineasfacturasprov", "idalbaran", idAlbaranLoc, "idfactura = " + idFacturaLoc + " AND idalbaran = " + idAlbaranLoc);

  curAlb.setUnLock("ptefactura", true);
  curAlb.setModeAccess(curAlb.Edit);
  curAlb.refreshBuffer();
  curAlb.setValueBuffer("idfactura", idFacturaLoc);
  //  curAlb.setValueBuffer("ptefactura", false);
  curAlb = this.iface.totalesFacturacion(curAlb);
  curAlb.commitBuffer();
}

/** \D Elimina los registros en local que fueron eliminados en remoto
*/
function oficial_eliminarLocales(tabla: String, nomTabla: String, valoresClave: Array)
{
  var util: FLUtil = new FLUtil();
  var _i = this.iface;
  debug("Borrando " + tabla);

  var curMod: FLSqlCursor = new FLSqlCursor("registrosmodificados", this.iface.conexion);

  curMod.select("tabla = '" + tabla + "' AND borrado = true");
  if (curMod.size() == 0)
    return 0;

  var paso: Number = 0;
  var modificados: Array = [];
  while (curMod.next()) {
    modificados[paso] = new Array(2);
    modificados[paso]["idmod"] = curMod.valueBuffer("id");
    modificados[paso]["clave"] = curMod.valueBuffer("clave");
    paso++;
  }

  // Registros de registromodificados correctamente borrados. Para eliminar después
  var yaActualizados: Array = [];

  var curLoc: FLSqlCursor = new FLSqlCursor(tabla);
  var curRem: FLSqlCursor = new FLSqlCursor(tabla, this.iface.conexion);
  campoClave = curLoc.primaryKey();

  var listaCampos: Array = this.iface.obtenerListaCampos(tabla);

  var valorClave;
  var borrados: Number = 0;
  var valor;

  util.createProgressDialog(util.translate("scripts", "Borrando ") + nomTabla, modificados.length);
  util.setProgress(1);

  for (var i: Number = 0; i < modificados.length; i++) {
    util.setProgress(i);

    if (valoresClave) {

      // 1. Probamos en la tabla de correspondencias
      claveLocTupla = util.sqlSelect("correspondenciasreg", "claveloc", "bd = '" + _i.bd_ + "' and tabla = '" + tabla + "' AND claverem = '" + modificados[i]["clave"] + "'");
      if (claveLocTupla)
        selectLocal = campoClave + " = '" + claveLocTupla + "'";

      // 2. Buscamos por campos compuestos
      else {
        selectLocal = "";
        for (var j: Number; j < valoresClave.length; j++) {
          if (selectLocal)
            selectLocal += " AND ";
          selectLocal += valoresClave[j] + " = '" + curRem.valueBuffer(valoresClave[j]) + "'";
        }
      }
    } else
      selectLocal = campoClave + " = '" + modificados[i]["clave"] + "'";

    if (tabla == "remesas") {
      claveLoc = parseFloat(modificados[i]["clave"]) + this.iface.incRemesa;
      selectLocal = campoClave + " = '" + claveLoc + "'";
    }


    debug("Borrando " + selectLocal);

    curLoc = new FLSqlCursor(tabla);

    curLoc.select(selectLocal);

    // Si no existe no hacemos nada
    if (!curLoc.first()) {
      yaActualizados[yaActualizados.length] = modificados[i]["idmod"];
      continue;
    }

    curLoc.setModeAccess(curLoc.Del);
    curLoc.refreshBuffer();
    comitLocal = curLoc.commitBuffer();
    this.iface.eliminarTuplaClaves(tabla, curLoc.valueBuffer(campoClave), modificados[i]["clave"]);

    // OK local
    if (comitLocal) {
      yaActualizados[yaActualizados.length] = modificados[i]["idmod"];
      borrados++;
    }
    // Error
    else
      debug(util.translate("scripts", "Error al borrar en la tabla remota %0 el código/id ").arg(tabla) + valorClave);

  }

  this.iface.anotarRegistrosImportados(yaActualizados, tabla);

  util.destroyProgressDialog();
  return borrados;
}








/** \D
@param valoresClave. Array con los valores que definen si el
registro existe en local. Puede ir vacio en cuyo caso se toma la
clave primaria
*/
function oficial_crearTuplasTabla(tabla: String, valoresClave: Array)
{
  var util: FLUtil = new FLUtil();
  var _i = this.iface;
  var curLoc: FLSqlCursor = new FLSqlCursor(tabla);
  var curRem: FLSqlCursor = new FLSqlCursor(tabla, this.iface.conexion);
  var curTup: FLSqlCursor = new FLSqlCursor("correspondenciasreg");
  var importados: Number = 0;
  var paso: Number = 0;

  campoClave = curLoc.primaryKey();
  var claveLoc, claveRem;


  curRem.select();
  util.createProgressDialog(util.translate("scripts", "Creando tuplas de ") + tabla, curRem.size());

  while (curRem.next()) {

    util.setProgress(paso++);

    curRem.setModeAccess(curRem.Browse);
    claveRem = curRem.valueBuffer(campoClave);

    // Si ya existe la tupla saltamos
    curTup = new FLSqlCursor("correspondenciasreg");
    curTup.select("bd = '" + _i.bd_ + "' and tabla = '" + tabla + "' AND claverem = '" + claveRem + "'");
    if (curTup.first())
      continue;

    curLoc = new FLSqlCursor(tabla);

    selectLocal = "";
    for (var j: Number; j < valoresClave.length; j++) {
      if (selectLocal)
        selectLocal += " AND ";
      selectLocal += valoresClave[j] + " = '" + curRem.valueBuffer(valoresClave[j]) + "'";
    }

    curLoc.select(selectLocal);

    if (curLoc.first()) {
      curLoc.setModeAccess(curRem.Browse);
      claveLoc = curLoc.valueBuffer(campoClave);
    } else
      continue;

    importados++;
    this.iface.actualizarTuplaClaves(tabla, claveLoc, claveRem);
  }

  util.destroyProgressDialog();
  return importados;
}



function oficial_actualizarTuplaClaves(tabla: String, claveLoc, claveRem)
{
  var _i = this.iface;
  debug("nueva tupla " + tabla + "   " + claveLoc + " " + claveRem);

  var curTab: FLSqlCursor = new FLSqlCursor("correspondenciasreg");

  curTab.select("bd = '" + _i.bd_ + "' and tabla = '" + tabla + "' AND claveloc = '" + claveLoc + "'");
  if (!curTab.first())
    curTab.setModeAccess(curTab.Insert);
  else
    curTab.setModeAccess(curTab.Edit);

  curTab.refreshBuffer();
  curTab.setValueBuffer("tabla", tabla);
  curTab.setValueBuffer("claveloc", claveLoc);
  curTab.setValueBuffer("claverem", claveRem);
  curTab.setValueBuffer("bd", _i.bd_);
  curTab.commitBuffer();
}


function oficial_eliminarTuplaClaves(tabla: String, claveLoc: String, claveRem: String)
{
  var _i = this.iface;
  var curTab: FLSqlCursor = new FLSqlCursor("correspondenciasreg");

  curTab.select("bd = '" + _i.bd_  + "' and tabla = '" + tabla + "' AND (claveloc = '" + claveLoc + "' OR claverem = '" + claveRem + "')");
  while (curTab.next()) {
    curTab.setModeAccess(curTab.Del);
    curTab.refreshBuffer();
    curTab.commitBuffer();
  }
}



function oficial_obtenerListaCampos(tabla: String): Array {
  var util: FLUtil = new FLUtil();
  var contenido: String = util.sqlSelect("flfiles", "contenido", "nombre = '" + tabla + ".mtd'");

  var xmlContenido = new FLDomDocument();
  xmlContenido.setContent(contenido);

  var listaCampos: FLDomNodeList;
  listaCampos = xmlContenido.elementsByTagName("field");

  var arrayCampos: Array = [];
  var paso: Number = 0;
  for (var i = 0; i < listaCampos.length(); i++)
  {
    if (!listaCampos.item(i).namedItem("name"))
      continue;
    arrayCampos[paso] = listaCampos.item(i).namedItem("name").toElement().text();
    paso++;
  }
  return arrayCampos;
}

/** Guarda los registros correctamente importados
*/
function oficial_anotarRegistroExportado(tabla: String, claveRem: String)
{
  var curTab: FLSqlCursor = new FLSqlCursor("registrosexportados");

  curTab.select("tabla = '" + tabla + "' AND clave = '" + claveRem + "'");
  if (curTab.first())
    return;

  curTab.setModeAccess(curTab.Insert);
  curTab.refreshBuffer();
  curTab.setValueBuffer("tabla", tabla);
  curTab.setValueBuffer("clave", claveRem);
  curTab.commitBuffer();
}



/** Guarda los registros modificados que han sido importados correctamente
*/
function oficial_anotarRegistrosImportados(yaActualizados: Array, tabla: String)
{
  var util: FLUtil = new FLUtil();
  var curTab: FLSqlCursor = new FLSqlCursor("registrosimportados");

  for (var i: Number = 0; i < yaActualizados.length; i++) {
    curTab.select("id = " + yaActualizados[i]);
    if (curTab.first())
      continue;

    curTab.setModeAccess(curTab.Insert);
    curTab.refreshBuffer();
    curTab.setValueBuffer("idmodificados", yaActualizados[i]);
    if (!curTab.commitBuffer())
      debug(util.translate("scripts", "Error al anotar el registro importado de la tabla local %0 el código/id ").arg(tabla) + yaActualizados[i]);
  }
}


/** Rellena la tabla de registros modificados con las facturas/albaranes y pagos/devoluciones
correspondientes al ejercicio actual

Usado para una primera importación total
*/
function oficial_popularTodosModificados()
{
  var util: FLUtil = new FLUtil();
  var codEjercicio: String = flfactppal.iface.pub_ejercicioActual();

  var res = MessageBox.information(util.translate("scripts", "A continuación se va a preparar la lista de registro a importar para el ejericio %0\n\n¿Desea continuar?").arg(codEjercicio),
                                   MessageBox.Yes, MessageBox.No, MessageBox.NoButton);
  if (res != MessageBox.Yes)
    return;

  if (!this.iface.conectar())
    return;

  this.iface.popularTodosModificadosTabla("cuentasbcocli", codEjercicio);
  this.iface.popularTodosModificadosTabla("facturascli", codEjercicio);
  this.iface.popularTodosModificadosTabla("albaranescli", codEjercicio);
  this.iface.popularTodosModificadosTabla("pagosdevolcli", codEjercicio);
  this.iface.popularTodosModificadosTabla("remesas", codEjercicio);
  this.iface.popularTodosModificadosTabla("cuentasbcopro", codEjercicio);
  this.iface.popularTodosModificadosTabla("facturasprov", codEjercicio);
  this.iface.popularTodosModificadosTabla("albaranesprov", codEjercicio);

  this.iface.desconectar();
  MessageBox.information(util.translate("scripts", "Proceso finalizado"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
}

function oficial_popularTodosModificadosTabla(tabla: String, codEjercicio: String)
{
  var util: FLUtil = new FLUtil();
  var curMod: FLSqlCursor = new FLSqlCursor("registrosmodificados", this.iface.conexion);
  var curRem: FLSqlCursor = new FLSqlCursor(tabla, this.iface.conexion);
  var campoClave = curRem.primaryKey();
  var paso: Number = 0;

  switch (tabla) {

    case "facturasprov":
    case "albaranesprov":
    case "facturascli":
    case "albaranescli":
      curRem.select("codejercicio = '" + codEjercicio + "'");
      break;

    case "pagosdevolcli":
      curRem.select("idrecibo IN (select idrecibo from reciboscli where codigo like '" + codEjercicio + "%')");
      break;

    case "remesas":
      curRem.select("idremesa IN (select distinct idremesa from reciboscli where codigo like '" + codEjercicio + "%') and idremesa > 0");
      break;

    case "cuentasbcopro":
    case "cuentasbcocli":
      curRem.select();
      break;

  }

  util.createProgressDialog(util.translate("scripts", "Registrando...") + tabla, curRem.size());

  while (curRem.next()) {

    util.setProgress(paso++);

    curMod.select("tabla = '" + tabla + "' AND clave = '" + curRem.valueBuffer(campoClave) + "'")
    if (curMod.first())
      continue;

    curMod.setModeAccess(curMod.Insert);
    curMod.refreshBuffer();
    curMod.setValueBuffer("tabla", tabla);
    curMod.setValueBuffer("clave", curRem.valueBuffer(campoClave));
    curMod.setValueBuffer("modificado", true);
    curMod.setValueBuffer("borrado", false);
    curMod.commitBuffer();
  }

  util.destroyProgressDialog();
}

/** \D Importa los artículos de remoto que faltan en local
*/
function oficial_coordinarArticulos()
{
  //  this.iface.coordinarClientes();
  //  this.iface.coordinarFamilias();

  var util: FLUtil = new FLUtil();
  var tabla: String = "articulos";
  var nomTabla: String = "Artículos";
  var campoClave: String = "referencia";

  if (!this.iface.conectar())
    return false;

  var curLoc: FLSqlCursor = new FLSqlCursor(tabla);
  var curRem: FLSqlCursor = new FLSqlCursor(tabla, this.iface.conexion);

  var listaCampos: Array = this.iface.obtenerListaCampos(tabla);

  var importados: Number = 0;
  var paso: Number = 0;
  var referencia: String;
  var valor;

  curRem.select();

  util.createProgressDialog(util.translate("scripts", "Importando ") + nomTabla, curRem.size());

  while (curRem.next()) {

    util.setProgress(paso++);

    referencia = curRem.valueBuffer("referencia");

    // Buscamos el artículo en local. Si existe, saltamos
    curLoc.select("referencia = '" + referencia + "'");
    if (curLoc.first())
      continue;

    curLoc.setModeAccess(curLoc.Insert);
    curLoc.refreshBuffer();

    // Bucle de campos
    for (var i = 0; i < listaCampos.length; i++) {
      if (listaCampos[i] == "idsubcuentacom")
        continue;
      if (listaCampos[i] == "idsubcuentairpfcom")
        continue;
      valor = curRem.valueBuffer(listaCampos[i]);
      curLoc.setValueBuffer(listaCampos[i], valor);
    }

    // OK local
    if (curLoc.commitBuffer())
      importados++;
    // Error
    else
      debug(util.translate("scripts", "Error al importar en la tabla remota %0 el código/id ").arg(tabla) + referencia);

  }

  var msgResumen: String = util.translate("scripts", "Artículos importados") + ": " + importados;

  this.iface.tedResultados.append(msgResumen);

  this.iface.desconectar();

  util.destroyProgressDialog();
  return importados;
}

function oficial_subirRiesgo()
{
  var util: FLUtil = new FLUtil();
  var tabla: String = "clientes";
  var nomTabla: String = "Clientes";
  var campoClave: String = "codcliente";

  if (!this.iface.conectar())
    return false;

  var curLoc: FLSqlCursor = new FLSqlCursor(tabla);
  var curRem: FLSqlCursor = new FLSqlCursor(tabla, this.iface.conexion);

  var actualizados: Number = 0;
  var paso: Number = 0;
  var referencia: String;
  var valor;

  this.iface.tedResultados.append("<h3>Actualizando riesgo de clientes</h3>");

  curLoc.select("");

  util.createProgressDialog(util.translate("scripts", "Comprobando riesgos de ") + nomTabla, curLoc.size());

  while (curLoc.next()) {

    util.setProgress(paso++);

    codCliente = curLoc.valueBuffer("codcliente");

    // Buscamos el cliente en remoto. Si no existe, saltamos
    curRem.select("codcliente = '" + codCliente + "'");
    if (!curRem.first())
      continue;

    riesgo = curLoc.valueBuffer("riesgoalcanzado");
    riesgoMax = curLoc.valueBuffer("riesgomax");
    dudosoCobro = curLoc.valueBuffer("dudosocobro");

    riesgoRem = curRem.valueBuffer("riesgoalcanzado");
    riesgoMaxRem = curRem.valueBuffer("riesgomax");
    dudosoCobroRem = curRem.valueBuffer("dudosocobro");


    if (riesgo == riesgoRem && riesgoMax == riesgoMaxRem && dudosoCobro == dudosoCobroRem)
      continue;

    curRem.setModeAccess(curRem.Edit);
    curRem.refreshBuffer();
    curRem.setValueBuffer("riesgoalcanzado", curLoc.valueBuffer("riesgoalcanzado"));
    curRem.setValueBuffer("riesgomax", curLoc.valueBuffer("riesgomax"));
    curRem.setValueBuffer("dudosocobro", curLoc.valueBuffer("dudosocobro"));

    if (curRem.commitBuffer()) {
      actualizados++;
      this.iface.tedResultados.append("Actualizando riesgo del cliente " + codCliente);
    } else
      debug(util.translate("scripts", "Error al importar en la tabla remota %0 el código/id ").arg(tabla) + referencia);
  }

  var msgResumen: String = util.translate("scripts", "Clientes actualizados") + ": " + actualizados;

  this.iface.tedResultados.append(msgResumen);

  this.iface.desconectar();

  util.destroyProgressDialog();
  return actualizados;
}

/** \D Importa los artículos de remoto que faltan en local
*/
function oficial_coordinarFamilias()
{
  var util: FLUtil = new FLUtil();
  var tabla: String = "familias";
  var nomTabla: String = "Familias";
  var campoClave: String = "codfamilia";

  if (!this.iface.conectar())
    return false;

  var curLoc: FLSqlCursor = new FLSqlCursor(tabla);
  var curRem: FLSqlCursor = new FLSqlCursor(tabla, this.iface.conexion);

  var listaCampos: Array = this.iface.obtenerListaCampos(tabla);

  var importados: Number = 0;
  var paso: Number = 0;
  var referencia: String;
  var valor;

  curRem.select();

  util.createProgressDialog(util.translate("scripts", "Importando ") + nomTabla, curRem.size());

  while (curRem.next()) {

    util.setProgress(paso++);

    codfamilia = curRem.valueBuffer("codfamilia");

    // Buscamos el artículo en local. Si existe, saltamos
    curLoc.select("codfamilia = '" + codfamilia + "'");
    if (curLoc.first())
      continue;

    curLoc.setModeAccess(curLoc.Insert);
    curLoc.refreshBuffer();

    // Bucle de campos
    for (var i = 0; i < listaCampos.length; i++) {
      if (listaCampos[i] == "idsubcuentacom")
        continue;
      if (listaCampos[i] == "idsubcuentairpfcom")
        continue;
      valor = curRem.valueBuffer(listaCampos[i]);
      curLoc.setValueBuffer(listaCampos[i], valor);
    }

    // OK local
    if (curLoc.commitBuffer())
      importados++;
    // Error
    else
      debug(util.translate("scripts", "Error al importar en la tabla remota %0 el código/id ").arg(tabla) + codfamilia);

  }

  var msgResumen: String = util.translate("scripts", "Familias importados") + ": " + importados;

  MessageBox.information(msgResumen, MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);

  this.iface.desconectar();

  util.destroyProgressDialog();
  return importados;
}

/** \D Importa los artículos de remoto que faltan en local
*/
function oficial_coordinarClientes()
{
  var util: FLUtil = new FLUtil();
  var tabla: String = "clientes";
  var nomTabla: String = "Clientes";
  var campoClave: String = "codcliente";

  if (!this.iface.conectar())
    return false;

  var curLoc: FLSqlCursor = new FLSqlCursor(tabla);
  var curRem: FLSqlCursor = new FLSqlCursor(tabla, this.iface.conexion);

  var listaCampos: Array = this.iface.obtenerListaCampos(tabla);

  var importados: Number = 0;
  var paso: Number = 0;
  var referencia: String;
  var valor;

  curRem.select();

  util.createProgressDialog(util.translate("scripts", "Importando ") + nomTabla, curRem.size());

  while (curRem.next()) {

    util.setProgress(paso++);

    codCliente = curRem.valueBuffer("codcliente");

    // Buscamos el artículo en local. Si existe, saltamos
    curLoc.select("codcliente = '" + codCliente + "'");
    if (curLoc.first())
      continue;

    curLoc.setModeAccess(curLoc.Insert);
    curLoc.refreshBuffer();

    // Bucle de campos
    for (var i = 0; i < listaCampos.length; i++) {
      valor = curRem.valueBuffer(listaCampos[i]);
      curLoc.setValueBuffer(listaCampos[i], valor);
    }

    // OK local
    if (curLoc.commitBuffer())
      importados++;
    // Error
    else
      debug(util.translate("scripts", "Error al importar en la tabla remota %0 el código/id ").arg(tabla) + referencia);

  }

  var msgResumen: String = util.translate("scripts", "Clientes importados") + ": " + importados;

  MessageBox.information(msgResumen, MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);

  this.iface.desconectar();

  util.destroyProgressDialog();
  return importados;
}


/** \D Importa los artículos de remoto que faltan en local
*/
function oficial_coordinarDirClientes()
{
  var util: FLUtil = new FLUtil();
  var tabla: String = "dirclientes";
  var nomTabla: String = "Direcciones de Clientes";

  if (!this.iface.conectar())
    return false;

  var curLoc: FLSqlCursor = new FLSqlCursor(tabla);
  var curRem: FLSqlCursor = new FLSqlCursor(tabla, this.iface.conexion);

  var listaCampos: Array = this.iface.obtenerListaCampos(tabla);

  var importados: Number = 0;
  var paso: Number = 0;
  var referencia: String;
  var valor;

  curRem.select();

  util.createProgressDialog(util.translate("scripts", "Importando ") + nomTabla, curRem.size());

  while (curRem.next()) {

    util.setProgress(paso++);

    codCliente = curRem.valueBuffer("codcliente");
    if (!util.sqlSelect("clientes", "codcliente", "codcliente = '" + codCliente + "'"))
      continue;

    util.sqlDelete("dirclientes", "codcliente = '" + codCliente + "'");

    curLoc.setModeAccess(curLoc.Insert);
    curLoc.refreshBuffer();

    // Bucle de campos
    for (var i = 0; i < listaCampos.length; i++) {
      if (listaCampos[i] == "id")
        continue;
      valor = curRem.valueBuffer(listaCampos[i]);
      curLoc.setValueBuffer(listaCampos[i], valor);
    }

    // OK local
    if (curLoc.commitBuffer())
      importados++;
    // Error
    else
      debug(util.translate("scripts", "Error al importar en la tabla remota %0 el código/id ").arg(tabla) + referencia);

  }

  var msgResumen: String = util.translate("scripts", "Clientes importados") + ": " + importados;

  MessageBox.information(msgResumen, MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);

  this.iface.desconectar();

  util.destroyProgressDialog();
  return importados;
}


/** \D Consolisa el campo de cuenta de domiciliación de los clientes
*/
function oficial_consolidarCuentasBcoCli()
{
  var util: FLUtil = new FLUtil();

  var q: FLSqlQuery = new FLSqlQuery();
  q.setTablesList("clientes,cuentasbcocli");
  q.setSelect("c.codcliente,c.codcuentadom,cb.codcuenta,cb.ctaentidad,cb.ctaagencia,cb.cuenta");
  q.setFrom("clientes c inner join cuentasbcocli cb on c.codcliente=cb.codcliente");
  q.setWhere("c.codcuentadom <> cb.codcuenta");

  if (!q.exec())
    return;

  if (!q.size())
    return;

  var curLoc: FLSqlCursor = new FLSqlCursor("clientes");

  while (q.next()) {

    codCuentaDomRem = util.sqlSelect("clientes inner join cuentasbcocli on clientes.codcliente = cuentasbcocli.codcliente", "codcuentadom", "clientes.codcuentadom = cuentasbcocli.codcuenta AND clientes.codcliente = '" + q.value(0) + "' AND ctaentidad = '" + q.value(3) + "' AND ctaagencia = '" + q.value(4) + "' AND cuenta = '" + q.value(5) + "'", "clientes,cuentasbcocli", this.iface.conexion);
    if (codCuentaDomRem) {
      curLoc.select("codcliente = '" + q.value(0) + "'");
      if (!curLoc.first())
        continue;
      curLoc.setModeAccess(curLoc.Edit);
      curLoc.refreshBuffer();
      curLoc.setValueBuffer("codcuentadom", q.value(2));
      curLoc.commitBuffer();
    }
  }
}


/** \D Importa los artículos de remoto que faltan en local
*/
function oficial_coordinarProveedores()
{
  var util: FLUtil = new FLUtil();
  var tabla: String = "proveedores";
  var nomTabla: String = "Proveedores";
  var campoClave: String = "codproveedor";

  if (!this.iface.conectar())
    return false;

  var curLoc: FLSqlCursor = new FLSqlCursor(tabla);
  var curRem: FLSqlCursor = new FLSqlCursor(tabla, this.iface.conexion);

  var listaCampos: Array = this.iface.obtenerListaCampos(tabla);

  var importados: Number = 0;
  var paso: Number = 0;
  var referencia: String;
  var valor;

  curRem.select();

  util.createProgressDialog(util.translate("scripts", "Importando ") + nomTabla, curRem.size());

  while (curRem.next()) {

    util.setProgress(paso++);

    codProveedor = curRem.valueBuffer("codproveedor");

    // Buscamos el artículo en local. Si existe, saltamos
    curLoc.select("codproveedor = '" + codProveedor + "'");
    if (curLoc.first())
      continue;

    curLoc.setModeAccess(curLoc.Insert);
    curLoc.refreshBuffer();

    // Bucle de campos
    for (var i = 0; i < listaCampos.length; i++) {
      valor = curRem.valueBuffer(listaCampos[i]);
      curLoc.setValueBuffer(listaCampos[i], valor);
    }

    // OK local
    if (curLoc.commitBuffer())
      importados++;
    // Error
    else
      debug(util.translate("scripts", "Error al importar en la tabla remota %0 el código/id ").arg(tabla) + referencia);

  }

  var msgResumen: String = util.translate("scripts", "Proveedores importados") + ": " + importados;

  MessageBox.information(msgResumen, MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);

  this.iface.desconectar();

  util.destroyProgressDialog();
  return importados;
}


/** \D Importa los artículos de remoto que faltan en local
*/
function oficial_coordinarDirProveedores()
{
  var util: FLUtil = new FLUtil();
  var tabla: String = "dirproveedores";
  var nomTabla: String = "Direcciones de Proveedores";

  if (!this.iface.conectar())
    return false;

  var curLoc: FLSqlCursor = new FLSqlCursor(tabla);
  var curRem: FLSqlCursor = new FLSqlCursor(tabla, this.iface.conexion);

  var listaCampos: Array = this.iface.obtenerListaCampos(tabla);

  var importados: Number = 0;
  var paso: Number = 0;
  var referencia: String;
  var valor;

  curRem.select();

  util.createProgressDialog(util.translate("scripts", "Importando ") + nomTabla, curRem.size());

  while (curRem.next()) {

    util.setProgress(paso++);

    codProveedor = curRem.valueBuffer("codproveedor");
    if (!util.sqlSelect("proveedores", "codproveedodr", "codproveedor = '" + codProveedor + "'"))
      continue;

    util.sqlDelete("dirproveedores", "codproveedor = '" + codProveedor + "'");

    curLoc.setModeAccess(curLoc.Insert);
    curLoc.refreshBuffer();

    // Bucle de campos
    for (var i = 0; i < listaCampos.length; i++) {
      if (listaCampos[i] == "id")
        continue;
      valor = curRem.valueBuffer(listaCampos[i]);
      curLoc.setValueBuffer(listaCampos[i], valor);
    }

    // OK local
    if (curLoc.commitBuffer())
      importados++;
    // Error
    else
      debug(util.translate("scripts", "Error al importar en la tabla remota %0 el código/id ").arg(tabla) + referencia);

  }

  var msgResumen: String = util.translate("scripts", "Proveedores importados") + ": " + importados;

  MessageBox.information(msgResumen, MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);

  this.iface.desconectar();

  util.destroyProgressDialog();
  return importados;
}


/** \D Consolisa el campo de cuenta de domiciliación de los proveedores
*/
function oficial_consolidarCuentasBcoPro()
{
  var util: FLUtil = new FLUtil();

  var q: FLSqlQuery = new FLSqlQuery();
  q.setTablesList("proveedores,cuentasbcopro");
  q.setSelect("p.codproveedor,p.codcuentadom,cb.codcuenta,cb.ctaentidad,cb.ctaagencia,cb.cuenta");
  q.setFrom("proveedores p inner join cuentasbcopro cb on p.codproveedor=cb.codproveedor");
  q.setWhere("p.codcuentadom <> cb.codcuenta");

  if (!q.exec())
    return;

  if (!q.size())
    return;

  var curLoc: FLSqlCursor = new FLSqlCursor("proveedores");

  while (q.next()) {

    codCuentaDomRem = util.sqlSelect("proveedores inner join cuentasbcopro on proveedores.codproveedor = cuentasbcopro.codproveedor", "codcuentadom", "proveedores.codcuentadom = cuentasbcopro.codcuenta AND proveedores.codproveedor = '" + q.value(0) + "' AND ctaentidad = '" + q.value(3) + "' AND ctaagencia = '" + q.value(4) + "' AND cuenta = '" + q.value(5) + "'", "proveedores,cuentasbcopro", this.iface.conexion);
    if (codCuentaDomRem) {
      curLoc.select("codproveedor = '" + q.value(0) + "'");
      if (!curLoc.first())
        continue;
      curLoc.setModeAccess(curLoc.Edit);
      curLoc.refreshBuffer();
      curLoc.setValueBuffer("codcuentadom", q.value(2));
      curLoc.commitBuffer();
    }
  }
}


function oficial_estoyImportando()
{
  return this.iface.importando;
}


function oficial_imprimirResultados()
{
  var tedResultados = this.child("tedResultados");

  if (tedResultados.text.isEmpty())
    return;

  sys.printTextEdit(tedResultados);
}

function oficial_estableceUsuario()
{
  //  sys.setObjText(this, "fdbUsuario", sys.nameUser());
}

function oficial_actualizarDatosConexion()
{
  var _i = this.iface;
  var curConexiones = this.child("tdbConexiones").cursor();

  var idConexionActiva = AQUtil.sqlSelect("coneximportdatosfc", "idconexion", "activa");
  if (!idConexionActiva || idConexionActiva == 0) {
    idConexionActiva = AQUtil.sqlSelect("coneximportdatosfc", "idconexion", "1=1 order by aliasconexion")
  }
  if (!idConexionActiva || idConexionActiva == 0) {
    _i.borrarConexionActiva();
    return;
  }

  if (!_i.activarConexion(idConexionActiva)) {
    MessageBox.warning(sys.translate("No pudo activarse la conexión"), MessageBox.Ok, MessageBox.NoButton);
    return;
  }
}

function oficial_pbnActivarConexion_clicked()
{
  var _i = this.iface;

  var curConexiones = this.child("tdbConexiones").cursor();
  var idConexion = curConexiones.valueBuffer("idconexion");
  if (!idConexion || idConexion == 0) {
    MessageBox.information(sys.translate("No hay ninguna conexión seleccionada"),
                           MessageBox.Ok, MessageBox.NoButton);
    return;
  }

  if (AQUtil.sqlSelect("coneximportdatosfc", "activa", "idconexion = " + idConexion)) {
    MessageBox.information(sys.translate("La conexion ya está activa."),
                           MessageBox.Ok, MessageBox.NoButton);
    return;
  }

  if (!_i.activarConexion(idConexion)) {
    MessageBox.warning(sys.translate("No pudo activarse la conexión seleccionada."),
                       MessageBox.Ok, MessageBox.NoButton);
    return;
  }

  this.child("tdbConexiones").refresh();
}

function oficial_activarConexion(idConexion)
{
  var _i = this.iface;
  var cursor = this.cursor();

  if (!AQUtil.sqlUpdate("coneximportdatosfc", "activa", false, "1=1")) {
    return false;
  }

  if (!AQUtil.sqlUpdate("coneximportdatosfc", "activa", true, "idconexion = " + idConexion)) {
    return false;
  }

  var qryDatosConexion = new FLSqlQuery();
  qryDatosConexion.setFrom("coneximportdatosfc");
  qryDatosConexion.setSelect("driver,nombrebd,usuario,host,puerto,seriesimportables,aliasconexion,idconexion");
  qryDatosConexion.setWhere("idconexion = " + idConexion);
  if (!qryDatosConexion.exec()) {
    return false
  }
  if (!qryDatosConexion.first()) {
    return false;
  }

  cursor.setValueBuffer("driver", qryDatosConexion.value("driver"));
  cursor.setValueBuffer("nombrebd", qryDatosConexion.value("nombrebd"));
  cursor.setValueBuffer("usuario", qryDatosConexion.value("usuario"));
  cursor.setValueBuffer("password", qryDatosConexion.value("password"));
  cursor.setValueBuffer("host", qryDatosConexion.value("host"));
  cursor.setValueBuffer("puerto", qryDatosConexion.value("puerto"));
  cursor.setValueBuffer("seriesimportables", qryDatosConexion.value("seriesimportables"));

  if (!_i.masDatosActivarConexion(cursor, qryDatosConexion))
    return false;

  this.child("tblAlias").text = "Conexión: " + qryDatosConexion.value("aliasconexion");
  this.child("tblAliasAdmin").text = "Conexión: " + qryDatosConexion.value("seriesimportables");
  _i.mostrarAlias();
  _i.seriesImportables = qryDatosConexion.value("seriesimportables");
  _i.mostrarSeries();

  return true;
}

function oficial_masDatosActivarConexion(cursor, qry)
{
  return true;
}

function oficial_borrarConexionActiva()
{
  var _i = this.iface;
  var cursor = this.cursor();

  cursor.setValueBuffer("driver", "");
  cursor.setValueBuffer("nombrebd", "");
  cursor.setValueBuffer("usuario", "");
  cursor.setValueBuffer("password", "");
  cursor.setValueBuffer("host", "");
  cursor.setValueBuffer("puerto", "");
  cursor.setValueBuffer("seriesimportables", "");

  _i.seriesImportables = "";
  _i.mostrarSeries();
  _i.mostrarAlias();

  MessageBox.warning(sys.translate("No tiene ninguna conexión activa. No podrá realizar la sincronización"), MessageBox.Ok, MessageBox.NoButton);
}

function oficial_mostrarSeries()
{
  var _i = this.iface;

  var series = "";

  if (!_i.seriesImportables || _i.seriesImportables == "") {
    series = "";
  } else {
    series = _i.seriesImportables.split("ð").toString();
    series = series.substring(1, series.length - 1);
  }

  this.child("lblSeries").text = series;
}

function oficial_cambioTab(tab)
{
  switch (tab) {
    case "conexiones": {
      if (AQUtil.sqlSelect("registrosexportados", "id", "1=1") || AQUtil.sqlSelect("registrosimportados", "id", "1=1")) {
        this.child("gbxConexiones").setDisabled(true);
      }
      break;
    }
  }
}

function oficial_mostrarAlias()
{
  var alias = AQUtil.sqlSelect("coneximportdatosfc", "aliasconexion", "activa");
  if (!alias) {
    alias = "";
  }
  this.child("tblAlias").text = "Conexión: " + alias;
  this.child("tblAliasAdmin").text = "Conexión: " + alias;
}

function oficial_masDatosCursorLocal(tabla, curLoc)
{
  return true;
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////
//// INTERFACE  /////////////////////////////////////////////////

//// INTERFACE  /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
