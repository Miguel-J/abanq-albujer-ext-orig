/***************************************************************************
                 tpv_tarjetaspuntos.qs  -  description
                             -------------------
    begin                : mar ago 14 2012
    copyright            : Por ahora (C) 2012 by InfoSiAL S.L.
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
    this.ctx.interna_init();
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
  function commonCalculateField(fN, cursor)
  {
    return this.ctx.oficial_commonCalculateField(fN, cursor);
  }
  function bufferChanged(fN)
  {
    return this.ctx.oficial_bufferChanged(fN);
  }
  function actualizarSaldoPuntos()
  {
    return this.ctx.oficial_actualizarSaldoPuntos();
  }
  function gestionSincro()
  {
    return this.ctx.oficial_gestionSincro();
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

  connect(this.child("tdbMovPuntos").cursor(), "bufferCommited()", _i, "actualizarSaldoPuntos()");

  _i.gestionSincro();
}

function interna_calculateField(fN)
{
  var _i = this.iface;
  var cursor = this.cursor();
  return _i.__commonCalculateField(fN, cursor);
}

/** \C
No se puede crear más de un arqueo para un mismo punto de venta con un mismo intervalo
Si al aceptar el formulario de arqueos existe una cantidad para el movimiento de cierre nos preguntará si deseamos cerrar el arqueo
*/
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

  switch (fN) {
    case "saldopuntos": {
      var tablaPuntos = flfact_tpv.iface.pub_dameTablaPuntos();
      if (tablaPuntos == "tpv_movpuntos") {
        valor = AQUtil.sqlSelect("tpv_movpuntos", "SUM(canpuntos)", "codtarjetapuntos = '" + cursor.valueBuffer("codtarjetapuntos") + "'");
        valor = isNaN(valor) ? 0 : valor;
        valor = valor < 0 ? 0 : valor;
      } else {
        var saldoSinc = parseFloat(cursor.valueBuffer("saldopuntossinc"));
        saldoSinc = isNaN(saldoSinc) ? 0 : saldoSinc;
        valor = AQUtil.sqlSelect("tpv_movpuntosnosinc", "SUM(canpuntos)", "codtarjetapuntos = '" + cursor.valueBuffer("codtarjetapuntos") + "'");
        valor = isNaN(valor) ? 0 : valor;
        valor += saldoSinc;
        valor = valor < 0 ? 0 : valor;
      }
      break;
    }
    default: {
      valor = _i.__commonCalculateField(fN, cursor);
    }
  }
  return valor;
}

function oficial_bufferChanged(fN)
{
  var _i = this.iface;
  var cursor = this.cursor();

  switch (fN) {
    case "m001": {
      break;
    }
  }
}

function oficial_actualizarSaldoPuntos()
{
  var _i = this.iface;

  sys.setObjText(this, "fdbSaldoPuntos", _i.calculateField("saldopuntos"));
}

function oficial_gestionSincro()
{
  var cursor = this.cursor();
  if (cursor.modeAccess() != cursor.Insert) {
    return;
  }
  var tablaPuntos = flfact_tpv.iface.pub_dameTablaPuntos();
  if (tablaPuntos == "tpv_movpuntos") {
    cursor.setValueBuffer("sincronizada", true);
  } else {
    cursor.setValueBuffer("sincronizada", false);
  }
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
