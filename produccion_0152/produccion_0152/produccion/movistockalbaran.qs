/***************************************************************************
                 movistockalbaran.qs  -  description
                             -------------------
    begin                : lun may 28 2012
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
  var ctx: Object;
  function interna(context)
  {
    this.ctx = context;
  }
  function init()
  {
    this.ctx.interna_init();
  }
  function calculateField(fN)
  {
    return this.ctx.interna_calculateField(fN);
  }
  function validateForm()
  {
    return this.ctx.interna_validateForm();
  }
  function formReady()
  {
    return this.ctx.interna_formReady();
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
  function bufferChanged(fN)
  {
    return this.ctx.oficial_bufferChanged(fN);
  }
  function validaLote()
  {
    return this.ctx.oficial_validaLote();
  }
  function validaCantidadLote()
  {
    return this.ctx.oficial_validaCantidadLote();
  }
  function iniciaValores()
  {
    return this.ctx.oficial_iniciaValores();
  }
  function filtroLotes()
  {
    return this.ctx.oficial_filtroLotes();
  }
  function informaConcepto()
  {
    return this.ctx.oficial_informaConcepto();
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
  connect(cursor, "bufferChanged(QString)", _i, "bufferChanged");
  connect(this, "formReady()", _i, "formReady");

  _i.iniciaValores();
}

function interna_calculateField(fN)
{
  var _i = this.iface;
  var cursor = this.cursor();
  var valor;
  switch (fN) {
    case "referencia_albaran": {
      valor = cursor.cursorRelation().valueBuffer("referencia");
      break;
    }
    case "idstock_albaran": {
      var referencia = cursor.cursorRelation().valueBuffer("referencia");
      var curAlbaran = cursor.cursorRelation().cursorRelation();
      var codAlmacen = curAlbaran.valueBuffer("codalmacen");
      var oArticulo = new Object;
      oArticulo.referencia = referencia;
      valor = flfactalma.iface.pub_dameIdStock(codAlmacen, oArticulo);
      break;
    }
    case "cantidad_inversa": {
      var cantidad = cursor.valueBuffer("cantidad");
      cantidad = isNaN(cantidad) ? 0 : cantidad;
      valor = cantidad * -1;
      break;
    }
  }
  return valor;
}

function interna_formReady()
{
  var _i = this.iface;
}

function interna_validateForm()
{
  var _i = this.iface;
  var cursor = this.cursor();

  if (!_i.validaLote()) {
    return false;
  }
  if (!_i.validaCantidadLote()) {
    return false;
  }
  if (!_i.informaConcepto()) {
    return false;
  }
  return true;
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_informaConcepto()
{
  var _i = this.iface;
  var cursor = this.cursor();

  var aD = flfactalma.iface.pub_dameDatosStockLinea(cursor.cursorRelation());
  if (aD && aD.concepto != "") {
    cursor.setValueBuffer("concepto", aD.concepto);
  }
  return true;
}

function oficial_iniciaValores()
{
  var _i = this.iface;
  var cursor = this.cursor();
  var curR = cursor.cursorRelation();

  this.child("fdbReferencia").setDisabled(true);
  this.child("fdbIdStock").setDisabled(true);

  switch (cursor.modeAccess()) {
    case cursor.Insert: {
      sys.setObjText(this, "fdbReferencia", _i.calculateField("referencia_albaran"));
      sys.setObjText(this, "fdbIdStock", _i.calculateField("idstock_albaran"));
      var hoy = new Date;
      sys.setObjText(this, "fdbFechaReal", hoy);
      sys.setObjText(this, "fdbHoraReal", hoy);
      cursor.setValueBuffer("estado", "HECHO");
      break;
    }
    case cursor.Edit: {
      sys.setObjText(this, "fdbCantidad", _i.calculateField("cantidad_inversa"));
      break;
    }
  }
  this.child("fdbCodLote").setFilter(_i.filtroLotes());
}

function oficial_filtroLotes()
{
  var _i = this.iface;
  var cursor = this.cursor();

  var filtro = "referencia = '" + cursor.valueBuffer("referencia") + "' AND candisponible > 0";
  return filtro;
}

function oficial_bufferChanged(fN)
{
  var _i = this.iface;
  var cursor = this.cursor();
  switch (fN) {
    case "codlote": {
      //      sys.setObjText(this, "fdbCantidad", _i.calculateField("disponiblelote"));
      break;
    }
  }
}

function oficial_validaLote()
{
  var _i = this.iface;
  var cursor = this.cursor();
  var codLote = cursor.valueBuffer("codlote");
  if (!codLote || codLote == "") {
    MessageBox.warning(sys.translate("Debe indicar un lote"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton, "AbanQ");
    return false;
  }
  var refLote = AQUtil.sqlSelect("lotesstock", "referencia", "codlote = '" + codLote + "'");
  if (refLote != refLote) {
    MessageBox.warning(sys.translate("La referencia del lote no coincide con la del movimiento"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton, "AbanQ");
    return false;
  }
  return true;
}

function oficial_validaCantidadLote()
{
  var _i = this.iface;
  var cursor = this.cursor();

  var codLote = cursor.valueBuffer("codlote");
  var cantidad = cursor.valueBuffer("cantidad");
  var disponible = AQUtil.sqlSelect("lotesstock", "candisponible", "codlote = '" + codLote + "'");
  if (codLote == cursor.valueBufferCopy("codlote")) {
    disponible -= parseFloat(cursor.valueBufferCopy("cantidad"));
  }
  if (cantidad > disponible) {
    MessageBox.warning(sys.translate("La cantidad supera el disponible del lote seleccionado"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton, "AbanQ");
    return false;
  }
  sys.setObjText(this, "fdbCantidad", _i.calculateField("cantidad_inversa"));
  return true;
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
////////////////////////////////////////////////////////////////