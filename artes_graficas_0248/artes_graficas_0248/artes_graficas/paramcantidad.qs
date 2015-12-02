/***************************************************************************
                 paramcantidades.qs  -  description
                             -------------------
    begin                : mar abr 02 2008
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
  function validateForm(): Boolean {
    return this.ctx.interna_validateForm();
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
  var modelos_: Array;
  function oficial(context)
  {
    interna(context);
  }
  function bufferChanged(fN: String)
  {
    return this.ctx.oficial_bufferChanged(fN);
  }
  function xmlCantidades(cursor: FLSqlCursor): String {
    return this.ctx.oficial_xmlCantidades(cursor);
  }
  function cargarModelos()
  {
    return this.ctx.oficial_cargarModelos();
  }
  function habilitarPorCantidad()
  {
    return this.ctx.oficial_habilitarPorCantidad();
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
  function pub_xmlCantidades(cursor: FLSqlCursor): String {
    return this.xmlCantidades(cursor);
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
  debug("Interna _ cantidad");
  var cursor: FLSqlCursor = this.cursor();

  connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");

  switch (cursor.modeAccess()) {
    case cursor.Insert: {
      cursor.setValueBuffer("idparamiptico", formRecordparamiptico.cursor().valueBuffer("id"));
      break;
    }
  }

  this.iface.cargarModelos();
  this.iface.habilitarPorCantidad();
}

function interna_validateForm(): Boolean {
  var cursor: FLSqlCursor = this.cursor();

  var xml: String = this.iface.xmlCantidades(cursor);
  if (!xml)
  {
    return false;
  }
  debug(xml);
  cursor.setValueBuffer("xml", xml);

  return true;
}

function interna_calculateField(fN: String): String {
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();
  var valor: String;

  switch (fN)
  {
    case "total": {
      valor = this.iface.commonCalculateField(fN, cursor);
      break;
    }
    case "numpaginas": {
      if (cursor.valueBuffer("cantidadespormodelo")) {
        valor = 0;
        var valorCampo: Number;
        var numPaginas: Number = 0;
        for (var i: Number = 0; i < 10; i++) {
          valorCampo = cursor.valueBuffer("cantidad" + this.iface.modelos_[i]);
          if (valorCampo && valorCampo != 0) {
            numPaginas++;
          }
        }
        valor = numPaginas;
      }
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
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  if (fN && fN != "" && fN.startsWith("cantidad") && cursor.valueBuffer("cantidadespormodelo")) {
    this.child("fdbNumPaginas").setValue(this.iface.calculateField("numpaginas"));
    this.child("fdbTotal").setValue(this.iface.calculateField("total"));
  }

  switch (fN) {
    case "numpaginas":
    case "numcopias": {
      if (!cursor.valueBuffer("cantidadespormodelo")) {
        this.child("fdbTotal").setValue(this.iface.calculateField("total"));
      }
      break;
    }
    case "cantidadespormodelo": {
      this.iface.habilitarPorCantidad();
      this.child("fdbTotal").setValue(this.iface.calculateField("total"));
      break;
    }
  }
}


function oficial_habilitarPorCantidad()
{
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  if (cursor.valueBuffer("cantidadespormodelo")) {
    this.child("gbxCantidades").setEnabled(true);
    this.child("fdbNumCopias").setValue("");
    this.child("fdbNumCopias").setDisabled(true);
    this.child("fdbNumPaginas").setDisabled(true);
  } else {
    this.child("gbxCantidades").setEnabled(false);
    for (var i: Number = 0; i < 10; i++) {
      this.child("fdbCantidad" + this.iface.modelos_[i]).setValue("");
    }
    this.child("fdbNumCopias").setDisabled(false);
    this.child("fdbNumPaginas").setDisabled(false);
  }
}


function oficial_xmlCantidades(cursor: FLSqlCursor): String {
  if (!this.iface.modelos_)
  {
    this.iface.cargarModelos();
  }

  var util: FLUtil = new FLUtil;

  var listaC: String = "";
  var cantidad: Number;
  var numPaginas: String = cursor.valueBuffer("numpaginas");
  var numCopias: String = cursor.valueBuffer("numcopias");
  var total: String = cursor.valueBuffer("total");
  var cantidadesPorModelo: Boolean = cursor.valueBuffer("cantidadespormodelo");
  if (cantidadesPorModelo)
  {
    for (var i: Number = 0; i < 10 ; i++) {
      cantidad = cursor.valueBuffer("cantidad" +  this.iface.modelos_[i]);
      if (cantidad && !isNaN(cantidad)) {
        listaC += "\n<Modelo Nombre=\"" + this.iface.modelos_[i] + "\" Cantidad=\"" + cantidad + "\"/>";
      }
    }
  }
  var contenido: String = "<PaginasParam ";
  contenido += "NumPaginas=\"" + numPaginas + "\" ";
  contenido += "Total=\"" + total + "\" ";
  if (cantidadesPorModelo)
  {
    contenido += "CantidadesPorModelo=\"true\" ";
    contenido += "NumCopias =\"\" >";
    contenido += "\n\t<Modelos>";
    contenido += listaC;
    contenido += "\n\t</Modelos>";
  } else {
    contenido += "CantidadesPorModelo=\"false\" ";
    contenido += "NumCopias=\"" + numCopias + "\" >";
  }
  contenido += "\n</PaginasParam>";

  return contenido;
}

function oficial_cargarModelos()
{
  this.iface.modelos_ = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J"];
}

function oficial_commonCalculateField(fN: String, cursor: FLSqlCursor): String {
  var util: FLUtil = new FLUtil;
  var valor: String;

  switch (fN)
  {
    case "total": {
      if (cursor.valueBuffer("cantidadespormodelo")) {
        valor = 0;
        var valorCampo: Number;
        for (var i: Number = 0; i < 10; i++) {
          valorCampo = cursor.valueBuffer("cantidad" + this.iface.modelos_[i]);
          if (isNaN(valorCampo)) {
            valorCampo = 0;
          }
          valor += valorCampo;
        }
      } else {
        valor = parseInt(cursor.valueBuffer("numpaginas")) * parseInt(cursor.valueBuffer("numcopias"));
      }
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