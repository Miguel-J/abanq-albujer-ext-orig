/***************************************************************************
                 reglotestock.qs  -  description
                             -------------------
    begin                : mar oct 16 2007
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
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna
{
  var bloqueo_;
  function oficial(context)
  {
    interna(context);
  }
  function bufferChanged(fN: String)
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
/** \C
\end */
function interna_init()
{
  var _i = this.iface;
  var util = new FLUtil();
  var cursor = this.cursor();

  connect(cursor, "bufferChanged(QString)", _i, "bufferChanged");

  _i.bloqueo_ = false;
  sys.setObjText(this, "lblDesLote", _i.calculateField("deslote"));

  switch (cursor.modeAccess()) {
    case cursor.Insert: {
      sys.setObjText(this, "fdbActual", _i.calculateField("actual"));
      var curRel = cursor.cursorRelation();
      if (curRel && curRel.action() == "inventarios") {
        sys.setObjText(this, "fdbCodAlmacen", curRel.valueBuffer("codalmacen"));
      }
      break;
    }
  }

  this.child("tdbMoviStock").cursor().setMainFilter("idreglotestock = " + cursor.valueBuffer("id"));
  this.child("tdbMoviStock").refresh();

}

/** \D
\end */
function interna_calculateField(fN)
{
  var _i = this.iface;
  var util = new FLUtil();
  var cursor = this.cursor();

  var res;
  switch (fN) {
    case "movimiento": {
      res = parseFloat(cursor.valueBuffer("nueva")) - parseFloat(cursor.valueBuffer("actual"));
      break;
    }
    case "nueva": {
      res = parseFloat(cursor.valueBuffer("actual")) + parseFloat(cursor.valueBuffer("movimiento"));
      break;
    }
    case "actual": {
      res = AQUtil.sqlSelect("lotesstock", "cantotal - canusada", "codlote = '" + cursor.valueBuffer("codlote") + "'");
      res = isNaN(res) ? 0 : res;
      break;
    }
    case "deslote": {
      var q = new FLSqlQuery;
      q.setSelect("a.referencia, a.descripcion, l.candisponible");
      q.setFrom("lotesstock l INNER JOIN articulos a ON l.referencia = a.referencia");
      q.setWhere("l.codlote = '" + cursor.valueBuffer("codlote") + "'");
      q.setForwardOnly(true);
      if (!q.exec()) {
        return false;
      }
      if (q.first()) {
        res = q.value("a.referencia") + " " + q.value("a.descripcion");
      } else {
        res = "";
      }
    }
  }

  return res;
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
/** \D
\end */
function oficial_bufferChanged(fN)
{
  var _i = this.iface;
  var util = new FLUtil();
  var cursor = this.cursor();


  switch (fN) {
    case "movimiento": {
      if (!_i.bloqueo_) {
        _i.bloqueo_ = true;
        this.child("fdbNueva").setValue(_i.calculateField("nueva"));
        _i.bloqueo_ = false;
      }
      break;
    }
    case "nueva":
    case "actual": {
      if (!_i.bloqueo_) {
        _i.bloqueo_ = true;
        sys.setObjText(this, "fdbMovimiento", _i.calculateField("movimiento"));
        _i.bloqueo_ = false;
      }
      break;
    }
    case "codlote": {
      sys.setObjText(this, "lblDesLote", _i.calculateField("deslote"));
      sys.setObjText(this, "fdbActual", _i.calculateField("actual"));
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
