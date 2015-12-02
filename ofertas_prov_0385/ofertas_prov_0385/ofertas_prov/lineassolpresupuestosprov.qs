/***************************************************************************
                 lineassolpresupuestosprov.qs  -  description
                             -------------------
    begin                : vie sep 05 2008
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
  function calculateField(fN: String): String { return this.ctx.interna_calculateField(fN); }
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
  function commonBufferChanged(fN: String, miForm: Object)
  {
    return this.ctx.oficial_commonBufferChanged(fN, miForm);
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
Este formulario realiza la gestión de las líneas de solicitudes de ofertas de proveedores.
\end */
function interna_init()
{
  var util: FLUtil = new FLUtil();
  var cursor: FLSqlCursor = this.cursor();
  connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");
}

function interna_calculateField(fN: String): String {
  return this.iface.commonCalculateField(fN, this.cursor());
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_bufferChanged(fN: String)
{
  this.iface.commonBufferChanged(fN, form);
}

function oficial_commonBufferChanged(fN: String, miForm: Object)
{
  switch (fN) {
    case "referencia": {
      var referencia: String = miForm.cursor().valueBuffer("referencia");
      var codProveedor: String = miForm.cursor().valueBuffer("codproveedor");
      miForm.child("fdbPvpUnitario").setValue(this.iface.commonCalculateField("pvpunitario", miForm.cursor()));
      if (referencia && referencia != "" && codProveedor && codProveedor != "") {
        miForm.child("fdbCoste").setValue(this.iface.commonCalculateField("coste", miForm.cursor()));
        miForm.child("fdbDto").setValue(this.iface.commonCalculateField("pordtocoste", miForm.cursor()));
      } else {
        miForm.child("fdbCoste").setValue("");
        miForm.child("fdbDto").setValue("");
        miForm.child("fdbMargen").setValue("");
        miForm.child("fdbBeneficio").setValue("");
      }
      break;
    }
    case "codproveedor": {
      var referencia: String = miForm.cursor().valueBuffer("referencia");
      var codProveedor: String = miForm.cursor().valueBuffer("codproveedor");
      if (referencia && referencia != "" && codProveedor && codProveedor != "") {
        miForm.child("fdbCoste").setValue(this.iface.commonCalculateField("coste", miForm.cursor()));
        miForm.child("fdbDto").setValue(this.iface.commonCalculateField("pordtocoste", miForm.cursor()));
      } else {
        miForm.child("fdbCoste").setValue("");
        miForm.child("fdbDto").setValue("");
        miForm.child("fdbMargen").setValue("");
        miForm.child("fdbBeneficio").setValue("");
      }
      break;
    }
    case "pvpunitario":
    case "coste":
    case "pordtocoste": {
      miForm.child("fdbMargen").setValue(this.iface.commonCalculateField("margen", miForm.cursor()));
      miForm.child("fdbBeneficio").setValue(this.iface.commonCalculateField("beneficio", miForm.cursor()));
      break;
    }
  }
}

function oficial_commonCalculateField(fN: String, cursor: FLSqlCursor): String {
  var valor: String;
  var util: FLUtil = new FLUtil();
  var referencia: String = cursor.valueBuffer("referencia");
  var codProveedor: String = cursor.valueBuffer("codproveedor");
  switch (fN)
  {
    case "pvpunitario": {
      valor = util.sqlSelect("articulos", "pvp", "referencia = '" + referencia + "'");
      break;
    }
    case "coste": {
      valor = util.sqlSelect("articulosprov", "coste", "referencia = '" + referencia + "' AND codproveedor = '" + codProveedor + "'");
      if (!valor)
        valor = 0;
      break;
    }
    case "pordtocoste": {
      valor = util.sqlSelect("articulosprov", "dto", "referencia = '" + referencia + "' AND codproveedor = '" + codProveedor + "'");
      if (!valor)
        valor = 0;
      break;
    }
    case "margen": {
      var valorDto: Number = (cursor.valueBuffer("coste") * cursor.valueBuffer("pordtocoste")) / 100;
      valor = parseFloat((cursor.valueBuffer("pvpunitario") - (cursor.valueBuffer("coste") - valorDto)) * 100 / cursor.valueBuffer("pvpunitario"));
      break;
    }
    case "beneficio": {
      valor = cursor.valueBuffer("pvpunitario") - cursor.valueBuffer("coste") * (100 - cursor.valueBuffer("pordtocoste")) / 100;
      break;
    }
  }
  return valor;
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
