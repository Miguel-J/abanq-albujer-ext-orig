/***************************************************************************
                 masterpedidosclialmacen.qs  -  description
                             -------------------
    begin                : vie jun 06 2008
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
  function darPrioridad()
  {
    this.ctx.oficial_darPrioridad();
  }
  function quitarPrioridad()
  {
    return this.ctx.oficial_quitarPrioridad();
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
  var cursor: FLSqlCursor = this.cursor();
  connect(this.child("tbnMasPrioridad"), "clicked()", this, "iface.darPrioridad()");
  connect(this.child("tbnMenosPrioridad"), "clicked()", this, "iface.quitarPrioridad()");
  cursor.setMainFilter("enpreparacion = true");
  var cols: Array = ["prioridad", "codigo", "enpreparacion", "codpedidopicking", "estadopicking", "codcesta"];
  this.child("tableDBRecords").setOrderCols(cols);
  this.child("tableDBRecords").refresh();
}


//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////

function oficial_darPrioridad()
{
  var cursor: FLSqlCursor = this.cursor();
  var util: FLUtil = new FLUtil;
  var prioridad: String = cursor.valueBuffer("prioridad");

  cursor.setModeAccess(cursor.Edit);
  cursor.refreshBuffer();
  if (prioridad != 0) {
    prioridad --;
    cursor.setValueBuffer("prioridad", prioridad);
    if (!cursor.commitBuffer())
      return false;
  } else
    MessageBox.information(util.translate("scripts", "El pedido ya tiene la máxima prioridad"), MessageBox.Ok, MessageBox.NoButton);

  this.child("tableDBRecords").refresh();
}

function oficial_quitarPrioridad()
{
  var cursor: FLSqlCursor = this.cursor();
  var util: FLUtil = new FLUtil;
  var prioridad: String = cursor.valueBuffer("prioridad");

  cursor.setModeAccess(cursor.Edit);
  cursor.refreshBuffer();
  if (prioridad != 9) {
    prioridad ++;
    cursor.setValueBuffer("prioridad", prioridad);
    if (!cursor.commitBuffer())
      return false;
  } else
    MessageBox.information(util.translate("scripts", "El pedido ya tiene la mínima prioridad"), MessageBox.Ok, MessageBox.NoButton);

  this.child("tableDBRecords").refresh();
}


//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
//////////////////////////////////////////////////////////////