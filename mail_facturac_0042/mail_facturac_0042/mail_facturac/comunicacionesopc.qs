/***************************************************************************
                 comunicacionesopc.qs  -  description
                             -------------------
    begin                : mar jun 20 2006
    copyright            : (C) 2006 by InfoSiAL S.L.
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
  function cambiarPathLocal()
  {
    return this.ctx.oficial_cambiarPathLocal() ;
  }
  function cambiarPrograma(programa)
  {
    return this.ctx.oficial_cambiarPrograma(programa) ;
  }
  function borrarCabecera()
  {
    return this.ctx.oficial_borrarCabecera() ;
  }
  function borrarPie()
  {
    return this.ctx.oficial_borrarPie() ;
  }
  function leerOpciones()
  {
    return this.ctx.oficial_leerOpciones() ;
  }
  function escribirOpciones()
  {
    return this.ctx.oficial_escribirOpciones() ;
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
  var cursor: FLSqlCursor = this.cursor();

  this.child("lblPathLocal").text = util.readSettingEntry("scripts/flfacturac/pathLocal");

  switch (util.readSettingEntry("scripts/flfacturac/programaMail")) {
    case "mail":
      this.child("rbnMail").setChecked(true);
      break;
    case "kmail":
      this.child("rbnKmail").setChecked(true);
      break;
    case "personalizado":
      this.child("rbnPersonal").setChecked(true);
      break;
  }

  connect(this.child("pbnCambiarPathLocal"), "clicked()", this, "iface.cambiarPathLocal");
  connect(this.child("btgPrograma"), "clicked(int)", this, "iface.cambiarPrograma");
  connect(this.child("pbnBorrarCabecera"), "clicked()", this, "iface.borrarCabecera");
  connect(this.child("pbnBorrarPie"), "clicked()", this, "iface.borrarPie");

  this.iface.leerOpciones();
}

function interna_main()
{
  var f = new FLFormSearchDB("comunicacionesopc");
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
        this.iface.escribirOpciones();
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


function oficial_cambiarPathLocal()
{
  var util: FLUtil = new FLUtil();
  var ruta: String = FileDialog.getExistingDirectory(util.translate("scripts", ""), util.translate("scripts", "RUTA A LOS MODULOS"));

  if (!File.isDir(ruta)) {
    MessageBox.information(util.translate("scripts", "Ruta errónea"),
                           MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return;
  }
  this.child("lblPathLocal").text = ruta;
  util.writeSettingEntry("scripts/flfacturac/pathLocal", ruta);
}

function oficial_cambiarPrograma(programa)
{
  var util: FLUtil = new FLUtil();
  switch (programa) {
    case 0: //mail
      util.writeSettingEntry("scripts/flfacturac/programaMail", "mail");
      break;
    case 1: //kmail
      util.writeSettingEntry("scripts/flfacturac/programaMail", "kmail");
      break;
    case 2: //personalizado
      util.writeSettingEntry("scripts/flfacturac/programaMail", "personalizado");
      break;
  }
}

function oficial_borrarCabecera()
{
  this.cursor().setValueBuffer("cabecera", "");
  this.child("txtCabecera").text = "";
}

function oficial_borrarPie()
{
  this.cursor().setValueBuffer("pie", "");
  this.child("txtPie").text = "";
}

function oficial_leerOpciones()
{
  var util: FLUtil = new FLUtil();
  var opciones = new Array("Comando", "Asunto", "CC", "BCC", "Adjunto", "Remitente");
  for (i = 0; i < opciones.length; i++)
    this.child("le" + opciones[i]).text = util.readSettingEntry("scripts/flfactppal/opcionComandoMail" + opciones[i]);
}

function oficial_escribirOpciones()
{
  var util: FLUtil = new FLUtil();
  var opciones = new Array("Comando", "Asunto", "CC", "BCC", "Adjunto", "Remitente");
  for (i = 0; i < opciones.length; i++)
    util.writeSettingEntry("scripts/flfactppal/opcionComandoMail" + opciones[i], this.child("le" + opciones[i]).text);
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
