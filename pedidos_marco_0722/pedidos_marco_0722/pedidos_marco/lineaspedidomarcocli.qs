/***************************************************************************
                 lineaspedidomarcocli.qs  -  description
                             -------------------
    begin                : vie nov 18 2011
    copyright            : (C) 2011 by InfoSiAL S.L.
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
  var ctx;
  function interna(context)
  {
    this.ctx = context;
  }
  function init()
  {
    return this.ctx.interna_init();
  }
  function calculateField(fN)
  {
    return this.ctx.interna_calculateField(fN);
  }
  function validateForm()
  {
    return this.ctx.interna_validateForm();
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
  function bufferChanged(fN)
  {
    return this.ctx.oficial_bufferChanged(fN);
  }
  function habilitaciones()
  {
    return this.ctx.oficial_habilitaciones();
  }
  function commonCalculateField(fN, cursor)
  {
    return this.ctx.oficial_commonCalculateField(fN, cursor);
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
  function pub_commonCalculateField(fN, cursor)
  {
    return this.commonCalculateField(fN, cursor);
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
Este formulario realiza la gestión de las líneas de pedidos a clientes.
\end */
function interna_init()
{
  var _i = this.iface;
  var cursor = this.cursor();

  connect(cursor, "bufferChanged(QString)", _i, "bufferChanged");

  this.child("tdbLineasPedidoCli").setReadOnly(true);

  _i.habilitaciones();
}

function interna_calculateField(fN)
{
  var _i = this.iface;
  var cursor = this.cursor();
  return _i.commonCalculateField(fN, cursor);
}

function interna_validateForm()
{
  var _i = this.iface;
  var cursor = this.cursor();

  return true;
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_bufferChanged(fN)
{
  var _i = this.iface;
  var cursor = this.cursor();

  switch (fN) {
    case "cantidad": {
      this.child("fdbCanPendiente").setValue(_i.calculateField("canpendiente"));
      this.child("fdbImporteTotal").setValue(_i.calculateField("importetotal"));
      break;
    }
    case "canpendiente": {
      this.child("fdbImportePendiente").setValue(_i.calculateField("importependiente"));
      break;
    }
    case "pvpunitario": {
      this.child("fdbImportePedido").setValue(_i.calculateField("importepedido"));
      this.child("fdbImportePendiente").setValue(_i.calculateField("importependiente"));
      this.child("fdbImporteTotal").setValue(_i.calculateField("importetotal"));
      break;
    }
  }
}

function oficial_habilitaciones()
{
  var _i = this.iface;
  var cursor = this.cursor();

  if (cursor.modeAccess() == cursor.Edit && cursor.valueBuffer("canpedida") != 0) {
    this.child("fdbReferencia").setDisabled(true);
    this.child("fdbDescripcion").setDisabled(true);
  }
}

function oficial_commonCalculateField(fN, cursor)
{
  var valor;
  switch (fN) {
    case "canpendiente": {
      valor = cursor.valueBuffer("cantidad") - cursor.valueBuffer("canpedida");
      valor = valor < 0 ? 0 : valor;
      break;
    }
    case "importependiente": {
      valor = cursor.valueBuffer("canpendiente") * cursor.valueBuffer("pvpunitario");
      break;
    }
    case "importepedido": {
      valor = cursor.valueBuffer("canpedida") * cursor.valueBuffer("pvpunitario");
      break;
    }
    case "importetotal": {
      valor = cursor.valueBuffer("cantidad") * cursor.valueBuffer("pvpunitario");
      break;
    }
    case "canpedida": {
      valor = AQUtil.sqlSelect("lineaspedidoscli", "SUM(cantidad)", "idlineapedidomarco = " + cursor.valueBuffer("idlinea"));
      break;
    }
  }
  return valor;
}


//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
