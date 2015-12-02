/***************************************************************************
                 gruposcontablesivaproneg.qs  -  description
                             -------------------
    begin                : jue abr 05 2012
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
  function validateForm(): Boolean {
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
  var ejercicioActual;
  var longSubcuenta;
  var posActualRep, posActualRec, posActualSop, posActualRev;
  var bloqueoSubcuenta;

  function oficial(context)
  {
    interna(context);
  }
  function bufferChanged(fN)
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
function interna_init()
{
  var _i = this.iface;
  var cursor = this.cursor();
  _i.ejercicioActual = flfactppal.iface.pub_ejercicioActual();
  _i.longSubcuenta = AQUtil.sqlSelect("ejercicios", "longsubcuenta", "codejercicio = '" + _i.ejercicioActual + "'");
  _i.bloqueoSubcuenta = false;
  _i.posActualRep = _i.posActualRec = _i.posActualSop = _i.posActualRev = -1;

  this.child("fdbIdSubcuentaRep").setFilter("codejercicio = '" + _i.ejercicioActual + "'");
  this.child("fdbIdSubcuentaRec").setFilter("codejercicio = '" + _i.ejercicioActual + "'");
  this.child("fdbIdSubcuentaSop").setFilter("codejercicio = '" + _i.ejercicioActual + "'");
  this.child("fdbIdSubcuentaRev").setFilter("codejercicio = '" + _i.ejercicioActual + "'");

  connect(cursor, "bufferChanged(QString)", _i, "bufferChanged");
}

function interna_validateForm()
{
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
    case "codsubcuentarep": {
      if (!_i.bloqueoSubcuenta) {
        _i.bloqueoSubcuenta = true;
        _i.posActualRep = flcontppal.iface.pub_formatearCodSubcta(this, "fdbCodSubcuentaRep", _i.longSubcuenta, _i.posActualRep);
        _i.bloqueoSubcuenta = false;
      }
      break;
    }
    case "codsubcuentarec": {
      if (!_i.bloqueoSubcuenta) {
        _i.bloqueoSubcuenta = true;
        _i.posActualRec = flcontppal.iface.pub_formatearCodSubcta(this, "fdbCodSubcuentaRec", _i.longSubcuenta, _i.posActualRec);
        _i.bloqueoSubcuenta = false;
      }
      break;
    }
    case "codsubcuentasop": {
      if (!_i.bloqueoSubcuenta) {
        _i.bloqueoSubcuenta = true;
        _i.posActualSop = flcontppal.iface.pub_formatearCodSubcta(this, "fdbCodSubcuentaSop", _i.longSubcuenta, _i.posActualSop);
        _i.bloqueoSubcuenta = false;
      }
      break;
    }
    case "codsubcuentarev": {
      if (!_i.bloqueoSubcuenta) {
        _i.bloqueoSubcuenta = true;
        _i.posActualRev = flcontppal.iface.pub_formatearCodSubcta(this, "fdbCodSubcuentaRev", _i.longSubcuenta, _i.posActualRev);
        _i.bloqueoSubcuenta = false;
      }
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
