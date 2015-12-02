/***************************************************************************
                 ubicacionesarticulo.qs  -  description
                             -------------------
    begin                : mie jue 18 2008
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
  function calculateField(fN: String): String {
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
  function borrarMovimientosUbicacion()
  {
    return this.ctx.oficial_borrarMovimientosUbicacion();
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
  debug("interna_ init");
  var cursor: FLSqlCursor = this.cursor();
  connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");

  if (cursor.valueBuffer("referencia") == "" || cursor.isNull("referencia")) {
    this.child("fdbBarcode").setFilter("");
  } else {
    this.child("fdbBarcode").setFilter("referencia = '" + cursor.valueBuffer("referencia") + "'");
  }

  if (cursor.modeAccess() == cursor.Del) {
    if (cursor.valueBuffer("cantidadactual") != 0) {
      MessageBox.warning(util.translate("scripts", "No se puede borrar la ubicación.\nLa cantidad actual es distinta de 0"), MessageBox.Ok, MessageBox.NoButton);
      return false;
    }
    this.iface.borrarMovimientosUbicacion();
  }
}

function interna_calculateField(fN: String): String {
  var cursor: FLSqlCursor = this.cursor();
  var util: FLUtil = new FLUtil;
  var valor: String = "";
  switch (fN)
  {
    case "referencia": {
      valor = util.sqlSelect("atributosarticulos", "referencia", "barcode = '" + cursor.valueBuffer("barcode") + "'");
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
function oficial_bufferChanged(fN: String)
{
  var cursor: FLSqlCursor = this.cursor();

  switch (fN) {
    case "barcode": {
      this.child("fdbReferencia").setValue(this.iface.calculateField("referencia"));
      break;
    }
    case "referencia": {
      if (cursor.valueBuffer("referencia") == "" || cursor.isNull("referencia"))
        this.child("fdbBarcode").setFilter("");
      else
        this.child("fdbBarcode").setFilter("referencia = '" + cursor.valueBuffer("referencia") + "'");
      break;
    }
  }
}

function oficial_borrarMovimientosUbicacion()
{
  var cursor: FLSqlCursor = this.cursor();
  var util: FLUtil = new FLUtil();
  util.sqlDelete("movimat", "idubibarcode = " + cursor.valueBuffer("id"));
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
//////////////////////////////////////////////////////////////