/***************************************************************************
                 criteriosdistcc.qs  -  description
                             -------------------
    begin                : mie nov 28 2012
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
    this.ctx.interna_init();
  }
  function validateForm()
  {
    return this.ctx.interna_validateForm();
  }
  function calculateField(fN)
  {
    return this.ctx.interna_calculateField(fN);
  }
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

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
  function calculateField(fN: String)
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
  function commonCalculateField(fN, cursor)
  {
    return this.ctx.oficial_commonCalculateField(fN, cursor);
  }
  function bufferChanged(fN)
  {
    return this.ctx.oficial_bufferChanged(fN);
  }
  function tdbPesosCriterioCC_bufferCommited()
  {
    return this.ctx.oficial_tdbPesosCriterioCC_bufferCommited();
  }
  function calculaProporciones(curDC)
  {
    return this.ctx.oficial_calculaProporciones(curDC);
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
  connect(this.child("tdbPesosCriterioCC").cursor(), "bufferCommited()", _i, "tdbPesosCriterioCC_bufferCommited");
}

function interna_calculateField(fN)
{
  var _i = this.iface;
  var cursor = this.cursor();
  var valor;
  switch (fN) {
    default: {
      valor = _i.commonCalculateField(fN, cursor);
    }
  }

  return valor;
}

function interna_validateForm()
{
  var _i = this.iface;
  return true;
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_commonCalculateField(fN, cursor)
{
  var _i = this.iface;
  var valor;
  switch (fN) {
    case "valor": {
      valor = AQUtil.sqlSelect("pesoscriteriocc", "SUM(valor)", "codcriterio = '" + cursor.valueBuffer("codcriterio") + "'");
      valor = isNaN(valor) ? 0 : valor;
    }
    default: {
    }
  }
  // debug("oficial_commonCalculateField " + fN + " = " + valor);

  return valor;
}

function oficial_bufferChanged(fN)
{
  var _i = this.iface;
  var cursor = this.cursor();
  switch (fN) {
    default: {
    }
  }
}

function oficial_tdbPesosCriterioCC_bufferCommited()
{
  var _i = this.iface;
  var cursor = this.cursor();

  sys.setObjText(this, "fdbValor", _i.calculateField("valor"));

  if (!_i.calculaProporciones(cursor)) {
    return false;
  }
  this.child("tdbPesosCriterioCC").refresh();
}

function oficial_calculaProporciones(curDC)
{
  var _i = this.iface;

  var codCriterio = curDC.valueBuffer("codcriterio");
  var total = curDC.valueBuffer("valor");
  var acum = 0, prop;

  var curP = new AQSqlCursor("pesoscriteriocc");
  curP.select("codcriterio = '" + codCriterio + "'");
  while (curP.next()) {
    curP.setModeAccess(AQSql.Edit);
    curP.refreshBuffer();
    prop = curP.valueBuffer("valor") * 100 / total;
    prop = AQUtil.roundFieldValue(prop, "pesoscriteriocc", "proporcion");
    acum += parseFloat(prop);
    curP.setValueBuffer("proporcion", prop);
    if (!curP.commitBuffer()) {
      return false;
    }
  }
  return true;
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
//////////////////////////////////////////////////////