/***************************************************************************
                 opcionescomp.qs  -  description
                             -------------------
    begin                : jue mar 13 2008
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
  //  var pbnAsociarOpcionCorte:Object;
  //  var pbnQuitarOpcionCorte:Object;
  //  var tdbTiposCorte:Object;
  function oficial(context)
  {
    interna(context);
  }
  /*function asociarOpcionCorte() {
    return this.ctx.oficial_asociarOpcinCorte();
  }
  function quitarOpcionCorte() {
    return this.ctx.oficial_quitarOpcinCorte();
  }*/
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
  //  var util:FLUtil = new FLUtil();
  //
  //  this.iface.pbnAsociarOpcionCorte = this.child("pbnAsociarOpcionCorte");
  //  this.iface.pbnQuitarOpcionCorte = this.child("pbnQuitarOpcionCorte");
  //  this.iface.tdbTiposCorte = this.child("tdbTiposCorte");
  //
  //  connect(this.iface.pbnAsociarOpcionCorte, "clicked()", this, "iface.asociarOpcionCorte()");
  //  connect(this.iface.pbnQuitarOpcionCorte, "clicked()", this, "iface.quitarOpcionCorte()");
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
// function oficial_asociarOpcionCorte()
// {
//  var util:FLUtil;
//  var cursor:FLSqlCursor = this.cursor();
//
//  var idOpcion:Number = cursor.valueBuffer("idopcion");
//  if(!idOpcion)
//    return;
//
//  var parte:String = "";
//
//  var f:Object = new FLFormSearchDB("tiposcorte");
//  var curTiposCorte:FLSqlCursor = f.cursor();
//  curTiposCorte.select();
//  if (!curTiposCorte.first())
//    return;
//  curTiposCorte.setModeAccess(curTiposCorte.Browse);
//  curTiposCorte.refreshBuffer();
//  f.setMainWidget();
//  curTiposCorte.refreshBuffer()
//  var parte = f.exec("parte");
//
//  if(!parte || parte == "")
//    return;
//
//  var curCorteOpcion:FLSqlCursor = new FLSqlCursor("cortesopcion");
//  curCorteOpcion.select();
//  if (!curTiposCorte.first())
//    return;
//  curTiposCorte.setModeAccess(curTiposCorte.Browse);
//  curTiposCorte.refreshBuffer();
//
//
//
//
//  this.iface.tdbTiposCorte.refresh();
// }
//
// function oficial_quitarOpcionCorte()
// {
//
//  this.iface.tdbTiposCorte.refresh();
// }
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
