/***************************************************************************
                 subcuentascriteriocc.qs  -  description
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
  var ejercicioActual, longSubcuenta, posActualPuntoSubcuenta, bloqueoSubcuenta;

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
  function validaSubcuenta()
  {
    return this.ctx.oficial_validaSubcuenta();
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

  _i.ejercicioActual = flfactppal.iface.pub_ejercicioActual();
  _i.longSubcuenta = AQUtil.sqlSelect("ejercicios", "longsubcuenta", "codejercicio = '" + _i.ejercicioActual + "'");
  _i.bloqueoSubcuenta = false;
  _i.posActualPuntoSubcuenta = -1;

  connect(cursor, "bufferChanged(QString)", _i, "bufferChanged");
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

  if (!_i.validaSubcuenta()) {
    return false;
  }
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
    case "codsubcuenta": {
      if (!_i.bloqueoSubcuenta) {
        _i.bloqueoSubcuenta = true;
        _i.posActualPuntoSubcuenta = flcontppal.iface.pub_formatearCodSubcta(this, "fdbCodSubcuenta", _i.longSubcuenta, _i.posActualPuntoSubcuenta);
        _i.bloqueoSubcuenta = false;
      }
      break;
    }
    default: {
    }
  }
}

function oficial_validaSubcuenta()
{
  var _i = this.iface;
  var cursor = this.cursor();

  var codSubcuenta = cursor.valueBuffer("codsubcuenta");
  if (!AQUtil.sqlSelect("co_subcuentas", "idsubcuenta", "codsubcuenta = '" + codSubcuenta + "' AND codejercicio = '" + _i.ejercicioActual + "'")) {
    MessageBox.warning(sys.translate("La subcuenta %1 no existe para el ejercicio %2").arg(codSubcuenta).arg(_i.ejercicioActual), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton, "AbanQ");
    return false;
  }

  if (codSubcuenta && codSubcuenta != "" && !codSubcuenta.startsWith("6") && !codSubcuenta.startsWith("7")) {
    MessageBox.warning(sys.translate("La subcuenta debe ser una subcuenta asociada a los grupos 6 ó 7"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton, "AbanQ");
    return false;
  }

  var codCriterio2 = AQUtil.sqlSelect("subcuentascriteriocc", "codcriterio", "codsubcuenta = '" + codSubcuenta + "' AND idsub <> " + cursor.valueBuffer("idsub"));
  if (codCriterio2) {
    MessageBox.warning(sys.translate("La subcuenta %1 ya se distribuye por el criterio %2").arg(codSubcuenta).arg(codCriterio2), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton, "AbanQ");
    return false;
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