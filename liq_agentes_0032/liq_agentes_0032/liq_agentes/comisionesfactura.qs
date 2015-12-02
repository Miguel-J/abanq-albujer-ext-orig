/***************************************************************************
                 comisionesfactura.qs  -  description
                             -------------------
    begin                : lun dic 12 2011
    copyright            : (C) 2011 by InfoSiAL S.L.
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
  var tblLineas_;
  var cIDL, cREF, cDES, cIMP, cPOR;
  function oficial(context)
  {
    interna(context);
  }
  function bufferChanged(fN: String)
  {
    return this.ctx.oficial_bufferChanged(fN);
  }
  function aceptar()
  {
    return this.ctx.oficial_aceptar();
  }
  function cargaTabla()
  {
    return this.ctx.oficial_cargaTabla();
  }
  function tblLineas_currentChanged(f, c)
  {
    return this.ctx.oficial_tblLineas_currentChanged(f, c);
  }
  function actualizaTotalComision()
  {
    return this.ctx.oficial_actualizaTotalComision();
  }
  function pbnAplicarComision_clicked()
  {
    return this.ctx.oficial_pbnAplicarComision_clicked();
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
  var _i = this.iface;
  var cursor = this.cursor();

  _i.tblLineas_ = this.child("tblLineas");

  disconnect(this.child("pushButtonAccept"), "clicked()", this.obj(), "accept()");
  connect(this.child("pushButtonAccept"), "clicked()", _i, "aceptar()");
  connect(cursor, "bufferChanged(QString)", _i, "bufferChanged");
  connect(_i.tblLineas_, "currentChanged(int, int)", _i, "tblLineas_currentChanged");
  connect(this.child("pbnAplicarComision"), "clicked()", _i, "pbnAplicarComision_clicked");
  this.child("fdbCodCliente").setDisabled(true);
  this.child("fdbNombreCliente").setDisabled(true);
  this.child("fdbFecha").setDisabled(true);

  _i.cargaTabla();
  _i.actualizaTotalComision();
}

function interna_calculateField(fN)
{
  var cursor = this.cursor();
  var valor = "";
  switch (fN) {
    case "X": {
      break;
    }
  }
  return valor;
}

function interna_validateForm(): Boolean {
  var cursor = this.cursor();

  return true;
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_bufferChanged(fN: String)
{
  var _i = this.iface;
  var cursor = this.cursor();

  switch (fN) {
    case "X": {
      break;
    }
  }
}

function oficial_cargaTabla()
{
  var cursor = this.cursor();
  var _i = this.iface;
  var c = 0, cols = "", s = "*";
  _i.cIDL = c++;
  cols += sys.translate("Id.Línea");
  _i.cREF = c++;
  cols += s;
  cols += sys.translate("Referencia");
  _i.cDES = c++;
  cols += s;
  cols += sys.translate("Descripción");
  _i.cIMP = c++;
  cols += s;
  cols += sys.translate("Importe");
  _i.cPOR = c++;
  cols += s;
  cols += sys.translate("%Comisión");
  _i.tblLineas_.setNumCols(c);
  _i.tblLineas_.setColumnLabels(s, cols);
  _i.tblLineas_.hideColumn(_i.cIDL);
  _i.tblLineas_.setColumnReadOnly(_i.cREF, true);
  _i.tblLineas_.setColumnReadOnly(_i.cDES, true);
  _i.tblLineas_.setColumnReadOnly(_i.cIMP, true);
  _i.tblLineas_.setColumnWidth(_i.cDES, 150);

  var q = new FLSqlQuery();
  q.setSelect("idlinea, referencia, descripcion, pvptotal, porcomision");
  if (cursor.table() == "facturascli") {
    q.setFrom("lineasfacturascli");
    q.setWhere("idfactura = " + cursor.valueBuffer("idfactura") + " ORDER BY referencia");
  } else {
    q.setFrom("lineasalbaranescli");
    q.setWhere("idalbaran = " + cursor.valueBuffer("idalbaran") + " ORDER BY referencia");
  }
  q.setForwardOnly(true);
  if (!q.exec()) {
    return false;
  }
  var f = 0;
  while (q.next()) {
    _i.tblLineas_.insertRows(f);
    _i.tblLineas_.setText(f, _i.cIDL, q.value("idlinea"));
    _i.tblLineas_.setText(f, _i.cREF, q.value("referencia"));
    _i.tblLineas_.setText(f, _i.cDES, q.value("descripcion"));
    _i.tblLineas_.setText(f, _i.cIMP, AQUtil.roundFieldValue(q.value("pvptotal"), "lineasfacturascli", "pvptotal"));
    _i.tblLineas_.setText(f, _i.cPOR, AQUtil.roundFieldValue(q.value("porcomision"), "lineasfacturascli", "porcomision"));
  }
}

function oficial_aceptar()
{
  var _i = this.iface;
  var nF = _i.tblLineas_.numRows();
  var cursor = this.cursor();
  var curLF = new FLSqlCursor((cursor.table() == "facturascli") ? "lineasfacturascli" : "lineasalbaranescli");
  var idLinea, porComision;
  for (var f = 0; f < nF; f++) {
    idLinea = _i.tblLineas_.text(f, _i.cIDL);
    porComision = _i.tblLineas_.text(f, _i.cPOR);
    if (isNaN(porComision)) {
      return;
    }
    curLF.select("idlinea = " + idLinea);
    if (!curLF.first()) {
      return;
    }
    curLF.setModeAccess(curLF.Edit);
    curLF.refreshBuffer();
    curLF.setValueBuffer("porcomision", porComision);
    if (!curLF.commitBuffer()) {
      return;
    }
  }
  this.accept();
}

function oficial_tblLineas_currentChanged(f, c)
{
  var _i = this.iface;
  _i.actualizaTotalComision();
}

function oficial_actualizaTotalComision()
{
  var _i = this.iface;
  var nF = _i.tblLineas_.numRows();
  var neto, porComision, total = 0;
  for (var f = 0; f < nF; f++) {
    porComision = _i.tblLineas_.text(f, _i.cPOR);
    if (isNaN(porComision)) {
      return;
    }
    neto = _i.tblLineas_.text(f, _i.cIMP);
    total += ((porComision * neto) / 100);
  }
  total = AQUtil.roundFieldValue(total, "facturascli", "total");
  this.child("lblComision").text = total;
}

function oficial_pbnAplicarComision_clicked()
{
  var porC = this.child("ledPorComision").text;
  debug("porC " + porC);
  debug(isNaN(porC));
  porC = parseFloat(porC);
  var _i = this.iface;
  var nF = _i.tblLineas_.numRows();
  var curLF = new FLSqlCursor("lineasfacturascli");
  for (var f = 0; f < nF; f++) {
    _i.tblLineas_.setText(f, _i.cPOR, AQUtil.roundFieldValue(porC, "lineasfacturascli", "porcomision"));
  }
  _i.actualizaTotalComision();
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
