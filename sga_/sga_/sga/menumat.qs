/***************************************************************************
                 menumat.qs  -  description
                             -------------------
    begin                : jue may 29 2008
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
  var pbnEntrada: Object;
  var pbnSalida: Object;
  var pbnTransferencia: Object;
  var pbnRegularizaciones: Object;
  function oficial(context)
  {
    interna(context);
  }
  function entradaClicked()
  {
    return this.ctx.oficial_entradaClicked();
  }
  function salidaClicked()
  {
    return this.ctx.oficial_salidaClicked();
  }
  function transferenciaClicked()
  {
    return this.ctx.oficial_transferenciaClicked();
  }
  function regularizacionesClicked()
  {
    return this.ctx.oficial_regularizacionesClicked();
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
  this.iface.pbnEntrada = this.child("pbnEntrada");
  connect(this.iface.pbnEntrada, "clicked()", this, "iface.entradaClicked");
  this.iface.pbnSalida = this.child("pbnSalida");
  connect(this.iface.pbnSalida, "clicked()", this, "iface.salidaClicked");
  this.iface.pbnTransferencia = this.child("pbnTransferencia");
  connect(this.iface.pbnTransferencia, "clicked()", this, "iface.transferenciaClicked");
  this.iface.pbnRegularizaciones = this.child("pbnRegularizaciones");
  connect(this.iface.pbnRegularizaciones, "clicked()", this, "iface.regularizacionesClicked");

}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_entradaClicked()
{
  var cursor: FLSqlCursor = new FLSqlCursor("movimat");
  cursor.setAction("entradasmatpda");
  cursor.insertRecord();
}

function oficial_salidaClicked()
{
  var cursor: FLSqlCursor = new FLSqlCursor("movimat");
  cursor.setAction("salidasmatpda");
  cursor.insertRecord();
}

function oficial_transferenciaClicked()
{
  var cursor: FLSqlCursor = new FLSqlCursor("movimat");
  cursor.setAction("transferenciasmatpda");
  cursor.insertRecord();
}

function oficial_regularizacionesClicked()
{
  var cursor: FLSqlCursor = new FLSqlCursor("movimat");
  cursor.setAction("regularizacionesmatpda");
  flfactalma.iface.pub_establecerValoresRegMat(false);
  cursor.insertRecord();
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
//////////////////////////////////////////////////////////////