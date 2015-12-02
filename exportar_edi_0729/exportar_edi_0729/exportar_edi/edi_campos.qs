/***************************************************************************
                              edi_campos.qs
                             -------------------
    begin                : mar 22 2012
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
  var ctx;
  function interna(context)
  {
    this.ctx = context;
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
  var cur_;
  var mw_;
  var fdbTipoValor_;
  var fdbValor_;
  var fdbLongi_;
  var cbxVal_;

  function oficial(context)
  {
    interna(context);
  }
  function init()
  {
    this.ctx.oficial_init();
  }
  function bufferChanged(fN)
  {
    this.ctx.oficial_bufferChanged(fN);
  }

  function updateGuiValues(type)
  {
    this.ctx.oficial_updateGuiValues(type);
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
function interna_validateForm()
{
  var _i = this.iface;

  if (_i.cur_.isNull("longi") ||
      _i.cur_.isNull("ini") ||
      _i.cur_.isNull("fin"))
    return true;

  var ini = _i.cur_.valueBuffer("ini");
  var fin = _i.cur_.valueBuffer("fin");
  var longi = parseInt(_i.cur_.valueBuffer("longi"));
  if (isNaN(longi))
    longi = 0;

  if (ini > fin) {
    var msg = sys.translate(
                "La columna de inicio del campo no debe ser mayor que la columna de fin"
              );
    sys.errorMsgBox(msg);
    return false;
  }

  if (longi != (fin - ini + 1)) {
    var msg = sys.translate("Longitud del campo incoherente ");
    msg +=  sys.translate("debe ser; columna fin - columna inicio + 1");
    sys.errorMsgBox(msg);
    return false;
  }

  var pos = _i.cur_.valueBuffer("pos");
  var lastFin = AQUtil.sqlSelect("edi_campos", "fin",
                                 "codesquema='" + _i.cur_.valueBuffer("codesquema") + "'" +
                                 " and pos<" + pos + " order by fin desc");
  if (!lastFin)
    lastFin = 0;
  if (ini <= lastFin) {
    var msg = sys.translate(
                "La columna de inicio de este campo(%1) debe ser mayor\nque la columna final del campo anterior(%2)"
              );
    sys.errorMsgBox(msg.arg(ini).arg(lastFin));
    return false;
  }

  var nextIni = AQUtil.sqlSelect("edi_campos", "ini",
                                 "codesquema='" + _i.cur_.valueBuffer("codesquema") + "'" +
                                 " and pos>" + pos + " order by ini asc");
  if (nextIni) {
    if (fin >= nextIni) {
      var msg = sys.translate(
                  "La columna de fin de este campo(%1) debe ser menor\nque la columna de inicio del campo siguiente(%2)"
                );
      sys.errorMsgBox(msg.arg(fin).arg(nextIni));
      return false;
    }
  }

  return true;
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_init()
{
  var _i = this.iface;

  _i.cur_ = this.cursor();
  _i.mw_ = this.mainWidget();
  _i.fdbTipoValor_ = _i.mw_.child("fdbTipoValor");
  _i.fdbValor_ = _i.mw_.child("fdbValor");
  _i.fdbLongi_ = _i.mw_.child("fdbLongi");
  _i.cbxVal_ = _i.mw_.child("cbxVal");

  if (_i.cur_.modeAccess() == AQSql.Insert) {
    var pos = _i.cur_.size() + 1;
    _i.cur_.setValueBuffer("pos", pos);

    var lastFin = AQUtil.sqlSelect("edi_campos", "fin",
                                   "codesquema='" + _i.cur_.valueBuffer("codesquema") + "'" +
                                   " and pos<" + pos + " order by fin desc");
    if (!lastFin)
      lastFin = 0;
    _i.cur_.setValueBuffer("ini", ++lastFin);
  }

  connect(_i.cbxVal_, "activated(QString)",
          _i.fdbValor_.editor(), "setText()");
  connect(_i.fdbTipoValor_.editor(), "activated(QString)",
          _i, "updateGuiValues()");
  _i.updateGuiValues();

  connect(_i.cur_, "bufferChanged(QString)", _i, "bufferChanged()");
}

function oficial_bufferChanged(fN)
{
  var _i = this.iface;

  switch (fN) {
    case "fin":
    case "ini": {
      if (_i.cur_.isNull("ini") ||
          _i.cur_.isNull("fin"))
        break;
      var ini = _i.cur_.valueBuffer("ini");
      var fin = _i.cur_.valueBuffer("fin");
      if (ini > fin)
        break;
      var l = fin - ini + 1;
      if (!_i.cur_.isNull("longi")) {
        var longi = _i.cur_.valueBuffer("longi");
        var arrLo = longi.split(',');
        arrLo[0] = l;
        _i.fdbLongi_.setValue(arrLo.join(','));
      } else
        _i.fdbLongi_.setValue(l);
    }
    break;
  }
}

function oficial_updateGuiValues(type)
{
  var _i = this.iface;

  if (type == undefined)
    type = _i.cur_.valueBuffer("tipovalor");

  switch (type) {
    case "campo": {
      _i.fdbValor_.setDisabled(true);
      _i.cbxVal_.setDisabled(false);

      var curRel = _i.cur_.cursorRelation();
      var qry = new AQSqlQuery;
      qry.setSelect(curRel.valueBuffer("sqlselect"));
      qry.setFrom(curRel.valueBuffer("sqlfrom"));
      qry.setWhere(curRel.valueBuffer("sqlwhere"));
      qry.setOrderBy(curRel.valueBuffer("sqlorderby"));
      if (!qry.exec())
        return;

      _i.cbxVal_.clear();
      _i.cbxVal_.insertStringList(qry.fieldList());
    }
    break;

    case "funcion": {
      _i.fdbValor_.setDisabled(true);
      _i.cbxVal_.setDisabled(false);

      var qry = new AQSqlQuery;
      qry.setSelect("name");
      qry.setFrom("edi_funciones");
      qry.setWhere("codesquema='" + _i.cur_.valueBuffer("codesquema") + "'");
      if (!qry.exec())
        return;

      var list = [];
      while (qry.next())
        list.push(qry.value(0).toString());

      _i.cbxVal_.clear();
      _i.cbxVal_.insertStringList(list);
    }
    break;

    case "fijo": {
      _i.fdbValor_.setDisabled(false);
      _i.cbxVal_.setDisabled(true);
    }
    break;
  }
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
