/***************************************************************************
                 salida.qs  -  description
                             -------------------
    begin                : jue jun 05 2008
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
    this.ctx.interna_init();
  }
  function calculateField(fN: String): String {
    return this.ctx.interna_calculateField(fN);
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
  function buscar()
  {
    return this.ctx.oficial_buscar();
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

/** @class_definition interna */
////////////////////////////////////////////////////////////////////////////
//// DEFINICION ////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
//// INTERNA /////////////////////////////////////////////////////
/** \C
\end */
function interna_init()
{
  var cursor: FLSqlCursor = this.cursor();
  var util: FLUtil = new FLUtil();
  connect(this.child("ledArticulo"), "returnPressed()", this, "iface.buscar");
  connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");

  this.child("fdbReferencia").setDisabled(true);
  this.child("fdbCanEnvase").setDisabled(true);
  this.child("fdbCanTotal").setDisabled(true);
}

function interna_calculateField(fN: String): String {
  var cursor: FLSqlCursor = this.cursor();
  var valor: String = "";
  switch (fN)
  {
    case "cantotal": {
      valor = parseFloat(cursor.valueBuffer("cantidad") * cursor.valueBuffer("canenvase"));
      break;
    }
  }
  return valor;
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////

function oficial_buscar()
{
  var cursor: FLSqlCursor = this.cursor();
  var valores: Array = [];
  var id: String = this.child("ledArticulo").text;
  if (!id || id == "")
    return false;
  valores = flfactalma.iface.pub_buscarArticulo(id);

  cursor.setValueBuffer("referencia", valores["referencia"]);
  cursor.setValueBuffer("canenvase", valores["canenvase"]);

  this.child("fdbCantidad").setFocus();
}

function oficial_bufferChanged(fN: String)
{
  var cursor: FLSqlCursor = this.cursor();

  switch (fN) {
    case "cantidad": {
      this.child("fdbCanTotal").setValue(this.iface.calculateField("cantotal"));
      break;
    }
    case "canenvase": {
      this.child("fdbCanTotal").setValue(this.iface.calculateField("cantotal"));
      break;
    }
  }
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
