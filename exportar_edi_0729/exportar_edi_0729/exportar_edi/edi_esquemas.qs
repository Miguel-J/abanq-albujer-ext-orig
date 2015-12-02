/***************************************************************************
                              edi_esquemas.qs
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
  var fdbSqlSelect_;
  var fdbSqlFrom_;
  var fdbSqlWhere_;
  var fdbSqlOrderBy_;
  var pbRunSql_;
  var dtbPreviewSql_;
  var pbPlus_;
  var pbMinus_;
  var tdbCampos_;

  function oficial(context)
  {
    interna(context);
  }
  function init()
  {
    this.ctx.oficial_init();
  }

  function previewSql()
  {
    return this.ctx.oficial_previewSql();
  }
  function plusFieldPos()
  {
    this.ctx.oficial_plusFieldPos();
  }
  function minusFieldPos()
  {
    this.ctx.oficial_minusFieldPos();
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
  _i.pbRunSql_ = _i.mw_.child("pbRunSql");
  _i.dtbPreviewSql_ = _i.mw_.child("dtbPreviewSql");
  _i.fdbSqlSelect_ = _i.mw_.child("fdbSqlSelect");
  _i.fdbSqlFrom_ = _i.mw_.child("fdbSqlFrom");
  _i.fdbSqlWhere_ = _i.mw_.child("fdbSqlWhere");
  _i.fdbSqlOrderBy_ = _i.mw_.child("fdbSqlOrderBy");
  _i.pbPlus_ = _i.mw_.child("pbPlus");
  _i.pbMinus_ = _i.mw_.child("pbMinus");
  _i.tdbCampos_ = this.child("tdbCampos");

  connect(_i.pbRunSql_, "clicked()", _i, "previewSql()");
  connect(_i.pbPlus_, "clicked()", _i, "plusFieldPos()");
  connect(_i.pbMinus_, "clicked()", _i, "minusFieldPos()");
}

function oficial_previewSql()
{
  var _i = this.iface;

  var select = _i.fdbSqlSelect_.editor().text;
  var from = _i.fdbSqlFrom_.editor().text;
  var where = _i.fdbSqlWhere_.editor().text;
  var orderby = _i.fdbSqlOrderBy_.editor().text;

  var sql = "select " + select;
  sql += " from " + from;
  if (!where.isEmpty())
    sql += " where " + where;
  if (!orderby.isEmpty())
    sql += " order by " + orderby;

  var selCur = new QSqlSelectCursor("", aqApp.db().dbAux());
  if (!selCur.exec(sql)) {
    var msg = "SQL ERROR\n\n";
    msg += selCur.lastError().driverText();
    msg += selCur.lastError().databaseText();
    sys.errorMsgBox(msg);
    return false;
  }

  _i.dtbPreviewSql_.setSqlCursor(selCur.qSqlCursor(), true, true);
  _i.dtbPreviewSql_.refresh(AQSql.RefreshData);

  return true;
}

function oficial_plusFieldPos()
{
  var _i = this.iface;

  var cur = _i.tdbCampos_.cursor();
  if (!cur || cur.size() == 0 || !cur.isValid())
    return;

  var codEsquema = _i.cur_.valueBuffer("codesquema");
  var pos = cur.valueBuffer("pos");
  var nextPos = AQUtil.sqlSelect("edi_campos", "pos",
                                 "codesquema='" + codEsquema + "'" +
                                 " and pos>" + pos + " order by pos asc");
  if (!nextPos)
    return;

  try {
    AQSql.update("edi_campos", ["pos"], [pos],
                 "codesquema='" + codEsquema + "'" +
                 " and pos=" + nextPos);
    cur.setModeAccess(AQSql.Edit);
    cur.refreshBuffer();
    cur.setValueBuffer("pos", nextPos);
    cur.commitBuffer();
  } catch (e) {
    //sys.errorPopup("" + e);
    debug("" + e);
  }
}

function oficial_minusFieldPos()
{
  var _i = this.iface;

  var cur = _i.tdbCampos_.cursor();
  if (!cur || cur.size() == 0 || !cur.isValid())
    return;

  var codEsquema = _i.cur_.valueBuffer("codesquema");
  var pos = cur.valueBuffer("pos");
  var prevPos = AQUtil.sqlSelect("edi_campos", "pos",
                                 "codesquema='" + codEsquema + "'" +
                                 " and pos<" + pos + " order by pos desc");
  if (!prevPos)
    return;

  try {
    AQSql.update("edi_campos", ["pos"], [pos],
                 "codesquema='" + codEsquema + "'" +
                 " and pos=" + prevPos);
    cur.setModeAccess(AQSql.Edit);
    cur.refreshBuffer();
    cur.setValueBuffer("pos", prevPos);
    cur.commitBuffer();
  } catch (e) {
    //sys.errorPopup("" + e);
    debug("" + e);
  }
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
