/***************************************************************************
                 centroscoste.qs  -  description
                             -------------------
    begin                : lun abr 26 2004
    copyright            : (C) 2004 by InfoSiAL S.L.
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

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna
{
  function oficial(context)
  {
    interna(context);
  }
  function bufferChanged(fN: String)
  {
    return this.ctx.oficial_bufferChanged(fN);
  }
  function validarFactorAcceso()
  {
    return this.ctx.oficial_validarFactorAcceso();
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
  var util = new FLUtil();
  var cursor = this.cursor();

  connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");

  switch (cursor.modeAccess()) {
    case cursor.Insert: {
      this.child("fdbFactorAcceso").setValue(this.iface.calculateField("factoracceso"));
      break;
    }
    default: {
      this.child("fdbFactorAcceso").setDisabled(!cursor.isNull("factoracceso"));
    }
  }
}

function interna_calculateField(fN)
{
  var util = new FLUtil;
  var cursor = this.cursor();
  var valor;
  switch (fN) {
    case "factoracceso": {
      valor = util.sqlSelect("centroscoste", "MAX(factoracceso)", "1 = 1");
      if (isNaN(valor)) {
        valor = 0;
      } else {
        valor++;
      }
      break;
    }
  }
  return valor;
}

function interna_validateForm()
{
  if (!this.iface.validarFactorAcceso()) {
    return false;
  }
  return true;
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_bufferChanged(fN: String)
{
  var cursor = this.cursor();

  switch (fN) {
    case "campo": {
      break;
    }
  }
}

function oficial_validarFactorAcceso()
{
  var util = new FLUtil;
  var cursor = this.cursor();
  var factorAcceso = cursor.valueBuffer("factoracceso");
  var codCentro = cursor.valueBuffer("codcentro");
  var otroCentro = util.sqlSelect("centroscoste", "codcentro", "factoracceso = " + factorAcceso + " AND codcentro <> '" + codCentro + "'");
  if (otroCentro) {
    MessageBox.warning(util.translate("scripts", "Ya hay otro centro (%1) con factor de acceso %2").arg(otroCentro).arg(factorAcceso), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  return true;
}
//// OFICIAL  /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
////////////////////////////////////////////////////////////////
