/***************************************************************************
                 mastericonos.qs  -  description
                             -------------------
    begin                : lun abr 08 2013
    copyright            : (C) 2013 by InfoSiAL S.L.
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
  function oficial(context)
  {
    interna(context);
  }
  function generarIconos_clicked()
  {
    return this.ctx.oficial_generarIconos_clicked();
  }
  function generarIconos(cursor)
  {
    return this.ctx.oficial_generarIconos(cursor);
  }
  function abrirDirectorio()
  {
    return this.ctx.oficial_abrirDirectorio();
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
  var _i = this.iface;
  var tbnGenerarIconos = this.child("toolButtonGenerarIconos");

  connect(tbnGenerarIconos, "clicked()", _i, "generarIconos_clicked");
  var tbnAbrirDirectorio = this.child("toolButtonAbrirDirectorio");
  connect(tbnAbrirDirectorio, "clicked()", _i, "abrirDirectorio");
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_generarIconos_clicked()
{
  var _i = this.iface;
  var cursor = this.cursor();
  cursor.setModeAccess(cursor.Edit);
  cursor.refreshBuffer();

  if (!_i.generarIconos(cursor)) {
    return false;
  }
  if (!cursor.commitBuffer()) {
    return false;
  }
  return true;
}

function oficial_generarIconos(cursor)
{
  var _i = this.iface;

  var p0 = cursor.valueBuffer("i128x128");
  var pix0 = sys.toPixmap(p0);

  var p1 = sys.scalePixmap(pix0, 64, 64);
  var p2 = sys.scalePixmap(pix0, 48, 48);
  var p3 = sys.scalePixmap(pix0, 32, 32);
  var p4 = sys.scalePixmap(pix0, 16, 16);

  cursor.setValueBuffer("i64x64", sys.fromPixmap(p1));
  cursor.setValueBuffer("i48x48", sys.fromPixmap(p2));
  cursor.setValueBuffer("i32x32", sys.fromPixmap(p3));
  cursor.setValueBuffer("i16x16", sys.fromPixmap(p4));
}

function oficial_abrirDirectorio()
{
  var cursor = this.cursor();
  var _i = this.iface;
  var util = new FLUtil();

  var dir = new Dir(FileDialog.getExistingDirectory("/usr/share/icons/", "Selecciona un directorio de Iconos"));
  var content = dir.entryList("*.png");

  util.createProgressDialog(util.translate("scripts", "Importando iconos"), content.length);
  var paso = 0;

  for (var i = 0; i < content.length; ++i) {
    cursor.select("nombre = '" + content[i].left(content[i].length - 4) + "'");

    if (!cursor.first()) {
      var pix0 = new Pixmap(dir.path + "/" + content[i]);

      cursor.setModeAccess(cursor.Insert);
      cursor.refreshBuffer();
      cursor.setValueBuffer("nombre", content[i].left(content[i].length - 4));
      cursor.setValueBuffer("i128x128", sys.fromPixmap(pix0));

      _i.generarIconos(cursor);

      if (!cursor.commitBuffer()) {
        return false;
      }
    }
    util.setProgress(paso++);
  }
  util.destroyProgressDialog();
  return true;
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
