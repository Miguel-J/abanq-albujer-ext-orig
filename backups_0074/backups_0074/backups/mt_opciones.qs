/***************************************************************************
                 mt_opciones.qs  -  description
                             -------------------
    begin                : lun sep 21 2004
    copyright            : (C) 2004 by InfoSiAL S.L.
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
  function oficial(context)
  {
    interna(context);
  }
  function cambiarDirBackups()
  {
    return this.ctx.oficial_cambiarDirBackups() ;
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

function main()
{
  this.iface.main();
}

function interna_init()
{
  var util: FLUtil = new FLUtil();
  connect(this.child("pbnCambiarDirBackups"), "clicked()", this, "iface.cambiarDirBackups");
  this.child("lblDirBackups").text = util.readSettingEntry("scripts/flmantppal/dirRutaBackups");
}

function interna_main()
{
  var f = new FLFormSearchDB("mt_opciones");
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
    f.close();
  }
}


//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////

function oficial_cambiarDirBackups()
{
  var util: FLUtil = new FLUtil();
  var ruta: String = FileDialog.getExistingDirectory(util.translate("scripts", ""), util.translate("scripts", "Ruta a los backups"));

  if (!ruta)
    return;

  if (!File.isDir(ruta)) {
    MessageBox.information(util.translate("scripts", "Ruta errónea"),
                           MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return;
  }

  util.writeSettingEntry("scripts/flmantppal/dirRutaBackups", ruta);
  this.child("lblDirBackups").text = ruta;
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
