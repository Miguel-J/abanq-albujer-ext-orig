/***************************************************************************
                 rutas.qs  -  description
                             -------------------
    begin                : jue dic 04 2008
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
  var tbnUp: Object;
  var tbnDown: Object;
  var tdbParadas: Object;
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
  function oficial(context)
  {
    interna(context);
  }
  function tbnUp_clicked()
  {
    return this.ctx.oficial_tbnUp_clicked();
  }
  function tbnDown_clicked()
  {
    return this.ctx.oficial_tbnDown_clicked();
  }
  function moveStep(direction: Number)
  {
    return this.ctx.oficial_moveStep(direction);
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
  this.iface.tdbParadas = this.child("tdbParadas");
  this.iface.tbnUp = this.child("toolButtonUp");
  this.iface.tbnDown = this.child("toolButtonDown");

  connect(this.iface.tbnUp, "clicked()", this, "iface.tbnUp_clicked");
  connect(this.iface.tbnDown, "clicked()", this, "iface.tbnDown_clicked");

  var col: Array = ["orden", "codcliente", "nombre", "direccion", "ciudad", "provincia", "codpais"];
  this.child("tdbParadas").setOrderCols(col);
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_tbnUp_clicked()
{
  this.iface.moveStep(-1);
}

function oficial_tbnDown_clicked()
{
  this.iface.moveStep(1);
}

function oficial_moveStep(direction: Number)
{
  var cursor: FLSqlCursor = this.iface.tdbParadas.cursor();
  if (!cursor.isValid()) {
    return;
  }

  var codruta: String = cursor.valueBuffer("codruta");
  if (!codruta) {
    return;
  }

  var orden: Number = cursor.valueBuffer("orden");
  var orden2: Number;
  var row: Number = this.iface.tdbParadas.currentRow();
  var util: FLUtil = new FLUtil();

  if (direction == -1) {
    orden2 = util.sqlSelect("paradas", "orden", "codruta = '" + codruta + "' AND orden < " + orden +  " ORDER BY orden DESC");
  } else {
    orden2 = util.sqlSelect("paradas", "orden", "codruta = '" + codruta + "' AND orden > " + orden +  " ORDER BY orden");
  }

  if (!orden2) {
    return;
  }

  var curParada: FLSqlCursor = new FLSqlCursor("paradas");
  curParada.select("codruta = '" + codruta + "' AND orden = '" + orden2 + "'");
  if (!curParada.first()) {
    return;
  }

  curParada.setModeAccess(curParada.Edit);
  curParada.refreshBuffer();
  curParada.setValueBuffer("orden", "-1");
  curParada.commitBuffer();

  cursor.setModeAccess(cursor.Edit);
  cursor.refreshBuffer();
  cursor.setValueBuffer("orden", orden2);
  cursor.commitBuffer();

  curParada.select("codruta = '" + codruta + "' AND orden = -1");
  curParada.first();
  curParada.setModeAccess(curParada.Edit);
  curParada.refreshBuffer();
  curParada.setValueBuffer("orden", orden);
  curParada.commitBuffer();

  this.iface.tdbParadas.refresh();
  row += direction;
  this.iface.tdbParadas.setCurrentRow(row);
}

//// OFICIAL ////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////




