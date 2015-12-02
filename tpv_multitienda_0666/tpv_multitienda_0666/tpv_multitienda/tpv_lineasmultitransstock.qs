/***************************************************************************
                 tpv_lineasmultitransstock.qs  -  description
                             -------------------
    begin                : vie sep 14 2012
    copyright            : (C) 2012 by InfoSiAL S.L.
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
  function calculateField(fN)
  {
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
  function bufferChanged(fN)
  {
    return this.ctx.oficial_bufferChanged(fN);
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
function interna_init()
{
  var _i = this.iface;
  var cursor = this.cursor();

  connect(cursor, "bufferChanged(QString)", _i, "bufferChanged");
}

function interna_calculateField(fN)
{
  var _i = this.iface;
  var cursor = this.cursor();

  return _i.commonCalculateField(fN, cursor);
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
    case "cantenviada": {
      break;
    }
  }
}

function oficial_commonCalculateField(fN, cursor)
{
  var _i = this.iface;
  var valor = "";

  switch (fN) {
    case "estado": {
      if (cursor.valueBuffer("cantrecibida") > 0) {
        if (cursor.valueBuffer("cantrecibida") >= cursor.valueBuffer("cantpterecibir")) {
          valor = "RECIBIDO";
        } else {
          valor = "RECIBIDO PARCIAL";
        }
      } else if (cursor.valueBuffer("cantenviada") > 0) {
        if (cursor.valueBuffer("cantenviada") >= cursor.valueBuffer("cantpteenvio")) {
          valor = "EN TRANSITO";
        } else {
          if (cursor.valueBuffer("cerradoex")) {
            valor = "EN TRANSITO";
          } else {
            valor = "ENVIADO PARCIAL";
          }
        }
      } else {
        if (cursor.valueBuffer("cerradoex"))
          valor = "CANCELADO";
        else
          valor = "PTE ENVIO";
      }
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
