/***************************************************************************
                 embalajesbulto.qs  -  description
                             -------------------
    begin                : mar jun 30 2009
    copyright            : (C) 2009 by InfoSiAL S.L.
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
////////////////////////////////////////////////////////////////////////////
//// DECLARACION ///////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

/** @class_declaration interna */
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
  function commonCalculateField(fN: String, cursor: FLSqlCursor): String {
    return this.ctx.oficial_commonCalculateField(fN, cursor);
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
  function pub_commonCalculateField(fN: String, cursor: FLSqlCursor): String {
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
/** \C
\end */
function interna_init()
{
  debug("init");
  var util: FLUtil = new FLUtil();
  var cursor: FLSqlCursor = this.cursor();

  connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");

  switch (cursor.modeAccess()) {
    case cursor.Insert: {
      break;
    }
  }

  this.child("fdbReferencia").setFilter("embalaje = true");
}

function interna_calculateField(fN: String): String {
  debug("cf " + fN);
  var util: FLUtil = new FLUtil();
  var cursor: FLSqlCursor = this.cursor();

  var valor: String;
  switch (fN)
  {
    default: {
      valor = this.iface.commonCalculateField(fN, cursor);
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
  var util: FLUtil = new FLUtil();
  switch (fN) {
    case "referencia":
    case "cantidad": {
      this.child("fdbPeso").setValue(this.iface.calculateField("peso"));
      this.child("fdbVolumen").setValue(this.iface.calculateField("volumen"));
      break;
    }
  }
}

function oficial_commonCalculateField(fN: String, cursor: FLSqlCursor): String {
  debug("oficial_commonCalculateField " + fN);
  var util: FLUtil = new FLUtil();
  var valor: String;
  switch (fN)
  {
    case "volumen": {
      var codUnidadVolumen: String = util.sqlSelect("articulos", "codunidadvolumen", "referencia = '" + cursor.valueBuffer("referencia") + "'");
      var volumenUnidad: Number = parseFloat(util.sqlSelect("articulos", "volumen", "referencia = '" + cursor.valueBuffer("referencia") + "'"));
      if (isNaN(volumenUnidad)) {
        volumenUnidad = 0;
      }
      volumenUnidad = flfactalma.iface.pub_convertirValorUnidades(volumenUnidad, codUnidadVolumen, "m3");
      valor = volumenUnidad * parseFloat(cursor.valueBuffer("cantidad"));
      break;
    }
    case "peso": {
      var codUnidadPeso: String = util.sqlSelect("articulos", "codunidadpeso", "referencia = '" + cursor.valueBuffer("referencia") + "'");
      var pesoUnidad: Number = parseFloat(util.sqlSelect("articulos", "peso", "referencia = '" + cursor.valueBuffer("referencia") + "'"));
      if (isNaN(pesoUnidad)) {
        pesoUnidad = 0;
      }
      pesoUnidad = flfactalma.iface.pub_convertirValorUnidades(pesoUnidad, codUnidadPeso, "kg");
      valor = pesoUnidad * parseFloat(cursor.valueBuffer("cantidad"));
      break;
    }
  }
  debug("valor " + valor);
  return valor;
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
