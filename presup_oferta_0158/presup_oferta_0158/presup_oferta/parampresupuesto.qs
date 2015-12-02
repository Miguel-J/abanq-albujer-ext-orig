/***************************************************************************
                 parampresupuesto.qs  -  description
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
  function cambiarRutaFichero()
  {
    return this.ctx.oficial_cambiarRutaFichero() ;
  }
  function bufferChanged(fN: String)
  {
    return this.ctx.oficial_bufferChanged(fN);
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
  connect(this.cursor(), "bufferChanged(QString)", this, "iface.bufferChanged");
  this.iface.bufferChanged("codparametro");
}

function interna_init()
{
  var util: FLUtil = new FLUtil();
  connect(this.child("pbnCambiarRutaFichero"), "clicked()", this, "iface.cambiarRutaFichero");
}


//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////


function oficial_cambiarRutaFichero()
{
  var util: FLUtil = new FLUtil();
  var ruta: String = FileDialog.getOpenFileName("*.png;*.jpg;*.gif", util.translate("scripts", "Fichero gráfico"));

  if (!ruta)
    return;

  if (!File.exists(ruta)) {
    MessageBox.information(util.translate("scripts", "Ruta errónea"),
                           MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return;
  }

  this.child("fdbValor").setValue(ruta);
}

function oficial_bufferChanged(fN: String)
{
  var util: FLUtil = new FLUtil();
  var cursor: FLSqlCursor = this.cursor();
  switch (fN) {
    case "codparametro":
      if (cursor.modeAccess() == cursor.Insert)
        this.child("fdbValor").setValue("");
      if (util.sqlSelect("paraminforme", "tipo", "codigo = '" + cursor.valueBuffer("codparametro") + "'") == "Imagen") {
        this.child("fdbValor").setDisabled(true);
        this.child("pbnCambiarRutaFichero").setDisabled(false);
        this.child("leTipo").text = util.translate("scripts", "Parámetro tipo Gráfico");
      } else {
        this.child("fdbValor").setDisabled(false);
        this.child("pbnCambiarRutaFichero").setDisabled(true);
        this.child("leTipo").text = util.translate("scripts", "Parámetro tipo Texto");
      }
      break;
  }
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
