/***************************************************************************
                 mastercodigomercancias.qs  -  description
                             -------------------
    begin                : lun dic 15 2008
    copyright            : (C) 2008 by InfoSiAL S.L.
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
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna
{
  var numfila: Number;
  var ano: Number;
  var codigo: String;
  var descripcion: Number;
  var unidades: Number;
  var descripcionuds: Number;
  var i_codigo: Number;
  var i_descripcion: Number;
  var i_unidades: Number;
  var i_descripcionuds: Number;

  function oficial(context)
  {
    interna(context);
  }
  function importarMercancias()
  {
    return this.ctx.oficial_importarMercancias();
  }
  function quitarEspacios(cadena: String): String {
    return this.ctx.oficial_quitarEspacios(cadena);
  }
  function importar(): Boolean {
    return this.ctx.oficial_importar();
  }
  function marcarFavorito()
  {
    return this.ctx.oficial_marcarFavorito();
  }
  function mostrarFavoritos(on: Boolean)
  {
    return this.ctx.oficial_mostrarFavoritos(on);
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
  connect(this.child("tbnImportarMercancias"), "clicked()", this, "iface.importarMercancias()");
  connect(this.child("tbnMarcarFavorito"), "clicked()", this, "iface.marcarFavorito()");
  connect(this.child("chkMostrarFavoritos"), "toggled(bool)", this, "iface.mostrarFavoritos()");

  this.iface.i_codigo = 0;
  this.iface.i_descripcion = 1;
  this.iface.i_unidades = 2;
  this.iface.i_descripcionuds = 3;
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_importarMercancias()
{
  var cursor: FLSqlCursor = this.cursor();
  var util: FLUtil = new FLUtil();

  var fichero: String = FileDialog.getOpenFileName(util.translate("scripts", "(*)"), util.translate("scripts", "Elegir fichero a importar"));

  if (!fichero) {
    return;
  }
  if (!File.exists(fichero)) {
    MessageBox.information(util.translate("scripts", "Ruta errónea"), MessageBox.Ok, MessageBox.NoButton);
    return;
  }

  var dialog = new Dialog;
  dialog.caption = "Introducir año";

  var first = new LineEdit;
  first.label = "Año";
  dialog.add(first);

  if (!dialog.exec()) {
    return false;
  }
  var ano = first.text;
  if (util.sqlSelect("codigomercancias", "idmercancia", "ano = '" + ano + "'")) {
    var res: Number = MessageBox.information(util.translate("scripts", "Ya existen datos de mercancías para el año %1.\nSe borrarán todos los datos antes de importar.\n¿Desea continuar?").arg(ano), MessageBox.Yes, MessageBox.No);
    if (res != MessageBox.Yes) {
      return false;
    }
  }

  util.sqlDelete("codigomercancias", "ano = '" + ano + "'");
  this.child("tableDBRecords").refresh();

  var todo: String = File.read(fichero);
  var lineas: Array = todo.split("\n");

  var i: Number;
  var numfila: Number = 0;
  var campos: Array;
  util.createProgressDialog(util.translate("scripts", "Importando mercancías"), lineas.length);
  util.setProgress(0);

  for (i = 1; i  < lineas.length - 1; i++) {
    campos = lineas[i].split("|");
    numfila = numfila + 1;
    this.iface.numfila = numfila;
    this.iface.ano = ano;
    this.iface.codigo = campos[this.iface.i_codigo];
    this.iface.codigo = this.iface.quitarEspacios(this.iface.codigo);
    this.iface.descripcion = campos[this.iface.i_descripcion];
    this.iface.unidades = campos[this.iface.i_unidades];
    this.iface.descripcionuds = campos[this.iface.i_descripcionuds];

    if (!this.iface.importar()) {
      MessageBox.information(util.translate("scripts", "La importación no es correcta"), MessageBox.Ok, MessageBox.NoButton);
      return false;
    }
    util.setProgress(i);
  }

  util.setProgress(lineas.length);
  util.destroyProgressDialog();

  MessageBox.information(util.translate("scripts", "El proceso de importación ha finalizado correctamente"), MessageBox.Ok, MessageBox.NoButton);

  this.child("tableDBRecords").refresh();

  return true;
}

function oficial_quitarEspacios(cadena: String): String {
  var i: Number;
  var cadenaSinEspacios: String = "";
  for (i = 0; i < cadena.length; i++)
  {
    if (cadena.charAt(i) && cadena.charAt(i) != " ") {
      cadenaSinEspacios += cadena.charAt(i);
    } else {
      continue;
    }
  }
  return cadenaSinEspacios;
}

function oficial_importar(): Boolean {
  var util: FLUtil = new FLUtil();
  var cursor: FLSqlCursor = this.cursor();

  var curCodMercancia: FLSqlCursor = new FLSqlCursor("codigomercancias");
  curCodMercancia.setModeAccess(curCodMercancia.Insert);
  curCodMercancia.refreshBuffer();
  curCodMercancia.setValueBuffer("numfila", this.iface.numfila);
  curCodMercancia.setValueBuffer("ano", this.iface.ano);
  curCodMercancia.setValueBuffer("codigo", this.iface.codigo);
  curCodMercancia.setValueBuffer("descripcion", this.iface.descripcion);
  curCodMercancia.setValueBuffer("unidades", this.iface.unidades);
  curCodMercancia.setValueBuffer("descripcionuds", this.iface.descripcionuds);
  if (!curCodMercancia.commitBuffer())
    return false;

  return true;
}

function oficial_marcarFavorito()
{
  var cursor: FLSqlCursor = this.cursor();
  var util: FLUtil = new FLUtil();

  cursor.setModeAccess(cursor.Edit);
  cursor.refresh();
  cursor.setValueBuffer("favorito", true);
  if (!cursor.commitBuffer()) {
    return false;
  }
}

function oficial_mostrarFavoritos(on: Boolean)
{
  if (on) {
    this.child("tableDBRecords").setFilter("favorito = true");
  } else {
    this.child("tableDBRecords").setFilter("1 = 1");
  }

  this.child("tableDBRecords").refresh();
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
