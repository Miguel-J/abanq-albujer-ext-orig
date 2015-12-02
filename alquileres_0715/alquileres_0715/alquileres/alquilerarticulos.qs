/***************************************************************************
                 alquilerarticulos.qs  -  description
                             -------------------
    begin                : lun oct 10 2012
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
  var bloqAlq_;
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

  _i.bloqAlq_ = false;
  connect(cursor, "bufferChanged(QString)", _i, "bufferChanged");
}

function interna_calculateField(fN)
{
  var _i = this.iface;
  var util = new FLUtil;
  var cursor = this.cursor();
  var valor;

  switch (fN) {
    case "datehasta": {
      var fD = cursor.valueBuffer("fechadesde");
      if (!fD || fD == undefined) {
        return;
      }
      var hD = cursor.valueBuffer("horadesde");
      if (!hD || hD == undefined) {
        return;
      }
      var sDesde = fD.toString().left(10) + "T" + hD.toString().right(8);
      var tDesde = Date.parse(sDesde);
      var h = cursor.valueBuffer("horas");
      h = isNaN(h) ? 0 : h;
      var tHasta = tDesde + (h * 60 * 60 * 1000);
      var dHasta = new Date(tHasta);
      valor = dHasta;
      break;
    }
    case "horas": {
      var fD = cursor.valueBuffer("fechadesde");
      if (!fD || fD == undefined) {
        return false;
      }
      var hD = cursor.valueBuffer("horadesde");
      if (!hD || hD == undefined) {
        return false;
      }
      var sDesde = fD.toString().left(10) + "T" + hD.toString().right(8);
      var tDesde = Date.parse(sDesde);
      if (!tDesde) {
        return false;
      }
      var fH = cursor.valueBuffer("fechahasta");
      if (!fH || fH == undefined) {
        return false;
      }
      var hH = cursor.valueBuffer("horahasta");
      if (!hH || hH == undefined) {
        return false;
      }
      var sHasta = fH.toString().left(10) + "T" + hH.toString().right(8);
      var tHasta = Date.parse(sHasta);
      if (!tHasta) {
        return false;
      }
      var ms = tHasta - tDesde;
      var h = ms / (60 * 60 * 1000);
      valor = util.roundFieldValue(h, "alquilerarticulos", "horas");
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
function oficial_bufferChanged(fN)
{
  var _i = this.iface;
  switch (fN) {
    case "fechadesde":
    case "horadesde":
    case "horas": {
      if (!_i.bloqAlq_) {
        _i.bloqAlq_ = true;
        var dHasta = _i.calculateField("datehasta");
        if (dHasta) {
          this.child("fdbFechaHasta").setValue(dHasta);
          this.child("fdbHoraHasta").setValue(dHasta);
        }
        _i.bloqAlq_ = false;
      }
      break;
    }
    case "fechahasta":
    case "horahasta": {
      if (!_i.bloqAlq_) {
        _i.bloqAlq_ = true;
        var h = _i.calculateField("horas");
        if (!isNaN(h)) {
          this.child("fdbHoras").setValue(h);
        }
        _i.bloqAlq_ = false;
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
