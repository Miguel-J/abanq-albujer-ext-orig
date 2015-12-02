/***************************************************************************
                 ubicaciones.qs  -  description
                             -------------------
    begin                : jue mar 29 2007
    copyright            : (C) 2007 by InfoSiAL S.L.
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
  function calculateField(fN: String): String {
    return this.ctx.interna_calculateField(fN);
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

  function oficial(context)
  {
    interna(context);
  }
  function bufferChanged(fN: String)
  {
    return this.ctx.oficial_bufferChanged(fN);
  }
  function genCodBar(fN: String)
  {
    return this.ctx.oficial_genCodBar(fN);
  }
  function espaciosIzquierda(numero: String, totalCifras: Number): String {
    return this.ctx.oficial_espaciosIzquierda(numero, totalCifras);
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
  var cursor: FLSqlCursor = this.cursor();
  connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");
  this.iface.genCodBar("codubicacion");
  this.child("fdbCodZona").setDisabled(false);
}

function interna_calculateField(fN: String): String {
  var cursor: FLSqlCursor = this.cursor();
  var util: FLUtil = new FLUtil;
  var valor: String = "";
  switch (fN)
  {
    case "codubicacion": {
      var codZona: String = cursor.valueBuffer("codzona");
      if (!codZona)
        codZona = "";
      var tipo: String = util.sqlSelect("zonas", "tipo", "codzona = '" + codZona + "'");
      switch (tipo) {
        case "PICKING":
        case "MASIVO": {
          var codEstanteria: String = cursor.valueBuffer("codestanteria");
          if (!codEstanteria)
            codEstanteria = "";
          codEstanteria = this.iface.espaciosIzquierda(codEstanteria, 2);

          var estante: String = cursor.valueBuffer("estante");
          if (!estante)
            estante = "";
          estante = this.iface.espaciosIzquierda(estante, 2);

          var altura: String = cursor.valueBuffer("altura");
          if (!altura)
            altura = "";
          altura = this.iface.espaciosIzquierda(altura, 2);

          var hueco: String = cursor.valueBuffer("hueco");
          if (!hueco)
            hueco = "";
          hueco = this.iface.espaciosIzquierda(hueco, 2);

          if (hueco == "")
            valor = codEstanteria + "-" + estante + "-" + altura;
          else
            valor = codEstanteria + "-" + estante + "-" + altura + "-" + hueco;
          break;
        }
        case "CESTAS":
        case "CONSOLIDACIÓN": {
          var numCesta: String = cursor.valueBuffer("numcesta");
          if (!numCesta) {
            numCesta = "";
          }
          valor = codZona + "-" + this.iface.espaciosIzquierda(numCesta, 2);
          break;
        }
      }
      break;
    }
  }
  return valor;
}

function interna_validateForm(): Boolean {
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();
  var codZona: String = cursor.valueBuffer("codzona");
  var tipo: String = util.sqlSelect("zonas", "tipo", "codzona = '" + codZona + "'");
  switch (tipo)
  {
    case "PICKING":
    case "MASIVO": {
      var codEstanteria: String = cursor.valueBuffer("codestanteria");
      if (!codEstanteria || codEstanteria == "") {
        MessageBox.warning(util.translate("scripts", "El campo Estanteria no puede ser nulo"), MessageBox.Ok, MessageBox.NoButton);
        return false;
      }
      var estante: String = cursor.valueBuffer("estante");
      if (!estante || estante == "") {
        MessageBox.warning(util.translate("scripts", "El campo Estante no puede ser nulo"), MessageBox.Ok, MessageBox.NoButton);
        return false;
      }
      var altura: String = cursor.valueBuffer("altura");
      if (!altura || altura == "") {
        MessageBox.warning(util.translate("scripts", "El campo Altura no puede ser nulo"), MessageBox.Ok, MessageBox.NoButton);
        return false;
      }
      var hueco: String = cursor.valueBuffer("hueco");
      if (!hueco || hueco == "") {
        MessageBox.warning(util.translate("scripts", "El campo Hueco no puede ser nulo"), MessageBox.Ok, MessageBox.NoButton);
        return false;
      }
      break;
    }
    case "CESTAS":
    case "CONSOLIDACIÓN": {
      var numCesta: String = cursor.valueBuffer("numcesta");
      if (!numCesta || numCesta == "") {
        MessageBox.warning(util.translate("scripts", "El campo Nº Cesta / U.C. no puede ser nulo"), MessageBox.Ok, MessageBox.NoButton);
        return false;
      }
      break;
    }
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
  var cursor: FLSqlCursor = this.cursor();

  switch (fN) {
    case "codestanteria":
    case "estante":
    case "altura":
    case "hueco":
    case "codzona":
    case "numcesta":
    case "referencia": {
      this.child("fdbCodUbicacion").setValue(this.iface.calculateField("codubicacion"));
      break;
    }
    case "codubicacion": {
      this.iface.genCodBar(fN);
      break;
    }
  }
}

function oficial_genCodBar(fN: String)
{
  if (fN == "codubicacion") {
    var cursor: FLSqlCursor = this.cursor();
    var type: String = "Code39";
    var value: String = cursor.valueBuffer("codubicacion");

    var auxCodBar: FLCodBar = new FLCodBar(0);
    var codBar: FLCodBar = new FLCodBar(value, auxCodBar.nameToType(type), 10, 1, 0, 0, true);
    var pixmap: Object = codBar.pixmap();
    if (codBar.validBarcode())
      this.child("pixmapCodBar").setPixmap(pixmap);
    else
      this.child("pixmapCodBar").setPixmap(codBar.pixmapError());
  }
}

function oficial_espaciosIzquierda(numero: String, totalCifras: Number): String {
  var ret: String = numero.toString();
  var numEspacios: Number = totalCifras - ret.length;
  for (; numEspacios > 0 ; --numEspacios)
    ret = " " + ret;
  return ret;
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
//////////////////////////////////////////////////////////////