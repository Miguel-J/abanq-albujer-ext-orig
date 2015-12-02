/***************************************************************************
                 tpv_masterrecepcionestx.qs  -  description
                             -------------------
    begin                : vie sep 14 2012
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
    return this.ctx.interna_init();
  }
  function preloadMainFilter()
  {
    return this.ctx.interna_preloadMainFilter();
  }
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna
{
  var codAlmaTienda_, curLinea_;
  function oficial(context)
  {
    interna(context);
  }
  function ordenColumnas()
  {
    return this.ctx.oficial_ordenColumnas();
  }
  function ponAnchoColumnas()
  {
    return this.ctx.oficial_ponAnchoColumnas();
  }
  function anchoColumnas()
  {
    return this.ctx.oficial_anchoColumnas();
  }
  function tbnOK_clicked()
  {
    return this.ctx.oficial_tbnOK_clicked();
  }
  function tbnOKParcial_clicked()
  {
    return this.ctx.oficial_tbnOKParcial_clicked();
  }
  function tbnOKUno_clicked()
  {
    return this.ctx.oficial_tbnOKUno_clicked();
  }
  function establecerFiltros()
  {
    return this.ctx.oficial_establecerFiltros();
  }
  function buscarViaje()
  {
    return this.ctx.oficial_buscarViaje();
  }
  function tbnBuscarOrigen_clicked()
  {
    return this.ctx.oficial_tbnBuscarOrigen_clicked();
  }
  function colorEstado(fN, fV, cursor, fT, sel)
  {
    return this.ctx.oficial_colorEstado(fN, fV, cursor, fT, sel);
  }
  function dedDesde_valueChanged(d)
  {
    return this.ctx.oficial_dedDesde_valueChanged(d);
  }
  function tbnBorrar_clicked()
  {
    return this.ctx.oficial_tbnBorrar_clicked();
  }
  function iniciarFechas()
  {
    return this.ctx.oficial_iniciarFechas();
  }
  function dameFiltro(precarga)
  {
    return this.ctx.oficial_dameFiltro(precarga);
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
function interna_preloadMainFilter()
{
  var _i = this.iface;
  var f = _i.dameFiltro(true);
  return f;
}

function interna_init()
{
  var _i = this.iface;
  var cursor = this.cursor();

  this.child("tableDBRecords").setOrderCols(_i.ordenColumnas());
  _i.ponAnchoColumnas();

  //  var filtro = "1 = 1";
  //  var codAlmaTienda = flfact_tpv.iface.pub_almacenActual();
  //  if(codAlmaTienda && codAlmaTienda != "") {
  //    filtro = "codalmadestino = '" + codAlmaTienda + "'";
  //  }
  //
  //  debug("filtro " + filtro);
  //  this.child("tableDBRecords").cursor().setMainFilter(filtro);
  _i.iniciarFechas();
  //  this.child("tableDBRecords").refresh();

  connect(this.child("tbnOK"), "clicked()", _i, "tbnOK_clicked");
  connect(this.child("tbnBorrar"), "clicked()", _i, "tbnBorrar_clicked");
  connect(this.child("tbnBuscarEnvios"), "clicked()", _i, "establecerFiltros");
  connect(this.child("chkPtes"), "clicked()", _i, "establecerFiltros");
  connect(this.child("tbnOKParcial"), "clicked()", _i, "tbnOKParcial_clicked");
  connect(this.child("tbnOkUno"), "clicked()", _i, "tbnOKUno_clicked");
  connect(this.child("tbnBuscarViaje"), "clicked()", _i, "buscarViaje()");
  connect(this.child("tbnBuscarOrigen"), "clicked()", _i, "tbnBuscarOrigen_clicked()");


  if (flfactppal.iface.pub_extension("tallcol_barcode")) {
    this.child("tlbReferencia").text = "Barcode:";
  }
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_ordenColumnas()
{
  if (flfactppal.iface.pub_extension("tallcol_barcode")) {
    return ["idviajemultitrans", "codalmaorigen", "referencia", "barcode", "descripcion", "talla", "color", "cantpterecibir", "cantrecibida", "estado", "fecharx", "horarx", "rxcentral", "rxtienda", "codagenterx", "comentariosrx"];
  } else {
    return ["idviajemultitrans", "codalmaorigen", "referencia", "descripcion", "cantpterecibir", "cantrecibida", "estado", "fecharx", "horarx", "rxcentral", "rxtienda", "codagenterx", "comentariosrx"];
  }
}

function oficial_ponAnchoColumnas()
{
  var _i = this.iface;
  var t = this.child("tableDBRecords");
  var aC = _i.anchoColumnas()
  for (var i = 0; i < aC.length; i++) {
    t.setColumnWidth(aC[i][0], aC[i][1]);
  }
}

function oficial_anchoColumnas()
{
  if (flfactppal.iface.pub_extension("tallcol_barcode")) {
    return [["idviajemultitrans", 100], ["codalmaorigen", 80], ["referencia", 100], ["barcode", 120], ["descripcion", 350], ["talla", 30], ["color", 30], ["cantpterecibir", 50], ["cantrecibida", 50], ["estado", 100], ["fecharx", 80], ["horarx", 80], ["rxcentral", 50], ["rxtienda" , 50], ["codagenterx", 100], ["comentariosrx", 200]];
  } else {
    return [["idviajemultitrans", 100], ["codalmaorigen", 80], ["referencia", 100], ["descripcion", 350], ["cantpterecibir", 50], ["cantrecibida", 50], ["estado", 100], ["fecharx", 80], ["horarx", 80], ["rxcentral", 50], ["rxtienda" , 50], ["codagenterx", 100], ["comentariosrx", 200]];
  }
}

function oficial_tbnOK_clicked()
{
  var cursor = this.cursor();
  if (!cursor.isValid()) {
    return false;
  }

  var codAgente =  formRecordtpv_recepcionestx.iface.pub_commonCalculateField("codagenterx", cursor);
  if (!codAgente || codAgente == "") {
    MessageBox.warning(sys.translate("No se ha encontrado el agente"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return false;
  }

  cursor.setModeAccess(cursor.Edit);
  cursor.refreshBuffer();
  cursor.setValueBuffer("cantrecibida", cursor.valueBuffer("cantpterecibir"));
  cursor.setValueBuffer("rxcentral", formRecordtpv_recepcionestx.iface.pub_commonCalculateField("rxcentral", cursor));
  cursor.setValueBuffer("rxtienda", formRecordtpv_recepcionestx.iface.pub_commonCalculateField("rxtienda", cursor));
  cursor.setValueBuffer("estado", formRecordtpv_recepcionestx.iface.pub_commonCalculateField("estado", cursor));
  cursor.setValueBuffer("codagenterx", codAgente);
  if (!cursor.commitBuffer()) {
    return false;
  }
  this.child("tableDBRecords").refresh();
  return true;
}

function oficial_tbnOKParcial_clicked()
{
  var _i = this.iface;
  var cursor = this.cursor();
  if (!cursor.isValid()) {
    return false;
  }

  if (!_i.curLinea_) {
    _i.curLinea_ = new FLSqlCursor("tpv_lineasmultitransstock");
    _i.curLinea_.setAction("tpv_recepcionestx");
  }
  _i.curLinea_.select("idlinea = " + cursor.valueBuffer("idlinea"));
  if (!_i.curLinea_.first()) {
    return false;
  }
  connect(_i.curLinea_, "commited()", this.child("tableDBRecords"), "refresh()");
  _i.curLinea_.editRecord();

  return true;
}

function oficial_tbnOKUno_clicked()
{
  var idViaje = this.child("lneViaje").text;
  var cursor = this.cursor();
  if (!cursor.isValid()) {
    return false;
  }

  var codAgente =  formRecordtpv_recepcionestx.iface.pub_commonCalculateField("codagenterx", cursor);
  if (!codAgente || codAgente == "") {
    return false;
  }

  var referencia = this.child("lneReferencia").text;
  if (flfactppal.iface.pub_extension("tallcol_barcode")) {
    if (!referencia || !AQUtil.sqlSelect("atributosarticulos", "barcode", "barcode = '" + referencia + "'")) {
      MessageBox.warning(sys.translate("No existe el artículo con barcode %1").arg(referencia), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton, "AbanQ");
      return false;
    }
  } else {
    if (!referencia || !AQUtil.sqlSelect("articulos", "referencia", "referencia = '" + referencia + "'")) {
      MessageBox.warning(sys.translate("No existe el artículo con referencia %1").arg(referencia), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton, "AbanQ");
      return false;
    }
  }

  var where = this.child("tableDBRecords").cursor().mainFilter();
  if (!where || where == "")
    where = "1=1";
  if (flfactppal.iface.pub_extension("tallcol_barcode")) {
    where += " and barcode = '" + referencia + "'";
  } else {
    where += " and referencia = '" + referencia + "'";
  }

  if (flfact_tpv.iface.pub_esUnaTienda()) {
    where += " AND (rxtienda = 'PTE' OR rxcentral = 'PTE')";
  } else {
    where += " AND rxcentral = 'PTE'";
  }

  if (AQUtil.sqlSelect("tpv_lineasmultitransstock", "count(idlinea)", where) > 1) {
    MessageBox.warning(sys.translate("Se han encontrado varios registros que coinciden con la búsqueda.\nSeleccione la recepción manualmente."), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
  }

  var curLV = new FLSqlCursor("tpv_lineasmultitransstock");

  if (flfactppal.iface.pub_extension("tallcol_barcode")) {
    curLV.select("cantpterecibir > 0 and barcode = '" + referencia + "' AND idviajemultitrans = '" + idViaje + "'");
  } else {
    curLV.select("cantpterecibir > 0 and referencia = '" + referencia + "' AND idviajemultitrans = '" + idViaje + "'");
  }
  if (!curLV.first()) {
    MessageBox.warning(sys.translate("No hay registros pendientes de recepción para el artículo %1").arg(referencia), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton, "AbanQ");
    return false;
  }

  curLV.setModeAccess(curLV.Edit);
  curLV.refreshBuffer();
  var cant = parseFloat(curLV.valueBuffer("cantrecibida")) + 1;
  if (cant > parseFloat(curLV.valueBuffer("cantpterecibir"))) {
    MessageBox.warning(sys.translate("No hay registros pendientes de recepción para el artículo %1").arg(referencia), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton, "AbanQ");
    return false;
  }

  curLV.setValueBuffer("cantrecibida", cant);
  curLV.setValueBuffer("rxcentral", formRecordtpv_recepcionestx.iface.pub_commonCalculateField("rxcentral", curLV));
  curLV.setValueBuffer("rxtienda", formRecordtpv_recepcionestx.iface.pub_commonCalculateField("rxtienda", curLV));
  curLV.setValueBuffer("estado", formRecordtpv_recepcionestx.iface.pub_commonCalculateField("estado", curLV));
  curLV.setValueBuffer("codagenterx", codAgente);

  if (!curLV.commitBuffer()) {
    return false;
  }
  this.child("tableDBRecords").refresh();
  this.child("lneReferencia").text = "";
  this.child("lneReferencia").setFocus();
  return true;
}

function oficial_establecerFiltros()
{
  var _i = this.iface;
  this.child("tableDBRecords").cursor().setMainFilter(_i.dameFiltro());
  this.child("tableDBRecords").refresh();
}

function oficial_dameFiltro(precarga)
{
  var _i = this.iface;

  var filtro = "1 = 1";

  if (!_i.codAlmaTienda_ || _i.codAlmaTienda_ != "NO") {
    _i.codAlmaTienda_ = flfact_tpv.iface.pub_almacenActual();
    if (!_i.codAlmaTienda_) {
      _i.codAlmaTienda_ = "NO";
    }
  }
  if (_i.codAlmaTienda_ != "NO") {
    filtro = "tpv_lineasmultitransstock.codalmadestino = '" + _i.codAlmaTienda_ + "'";
  }

  var idViaje = this.child("lneViaje") ? this.child("lneViaje").text : "";
  var hoy = new Date;
  hoy = hoy.toString().left(10);
  var codAlmaOrigen = this.child("lneOrigen") ? this.child("lneOrigen").text : "";
  var fechaDesde = precarga ? hoy : this.child("dedDesde").date;
  var fechaHasta = precarga ? hoy : this.child("dedHasta").date;

  if (idViaje && idViaje != "") {
    if (AQUtil.sqlSelect("tpv_viajesmultitransstock", "idviajemultitrans", "idviajemultitrans = '" + idViaje + "'"))
      filtro += " and idviajemultitrans = '" + idViaje + "'";
  }
  if (codAlmaOrigen && codAlmaOrigen != "") {
    filtro += " AND tpv_lineasmultitransstock.codalmaorigen = '" + codAlmaOrigen + "'";
  }
  if (this.child("chkPtes").checked) {
    filtro += " AND tpv_lineasmultitransstock.estado IN ('EN TRANSITO', 'RECIBIDO PARCIAL')";
  }
  if (fechaDesde || fechaHasta) {
    if (fechaDesde) {
      filtro += filtro != "" ? " AND " : ""
                filtro += "tpv_viajesmultitransstock.fecha >= '" + fechaDesde + "'";
    }
    if (fechaHasta) {
      filtro += filtro != "" ? " AND " : ""
                filtro += "tpv_viajesmultitransstock.fecha <= '" + fechaHasta + "'";
    }
  }
  return filtro;
}

function oficial_buscarViaje()
{
  var _i = this.iface;
  var f = new FLFormSearchDB("tpv_viajesmultitransstock");

  //  var filtro = "1=1";
  if (flfact_tpv.iface.pub_esUnaTienda()) {
    var codAlmaTienda = flfact_tpv.iface.pub_almacenActual();
    codAlmaTienda = codAlmaTienda ? codAlmaTienda : "ALL";
    if (codAlmaTienda && codAlmaTienda != "") {
      try {
        formSearchtpv_viajesmultitransstock.iface.pub_ponAlmaOrigen(false);
      } catch (e) {
        formtpv_viajesmultitransstock.iface.pub_ponAlmaOrigen(false);
      }
      try {
        formSearchtpv_viajesmultitransstock.iface.pub_ponAlmaDestino(codAlmaTienda);
      } catch (e) {
        formtpv_viajesmultitransstock.iface.pub_ponAlmaDestino(codAlmaTienda);
      }
    }
  }

  //  f.cursor().setMainFilter(filtro);
  f.setMainWidget();
  //  f.child("tableDBRecords").setFilter(filtro);
  var idViaje = f.exec("idviajemultitrans");
  if (idViaje) {
    this.child("dedDesde").date = "";
    this.child("dedHasta").date = "";
    this.child("lneOrigen").text = "";
    this.child("lneViaje").text = idViaje;
    _i.establecerFiltros();
  }
}

function oficial_tbnBuscarOrigen_clicked()
{
  var _i = this.iface;
  var f = new FLFormSearchDB("almacenes");

  var filtro = "1=1";
  if (flfact_tpv.iface.pub_esUnaTienda()) {
    var codAlmaTienda = flfact_tpv.iface.pub_almacenActual();
    if (codAlmaTienda && codAlmaTienda != "")
      filtro = "codalmacen <> '" + codAlmaTienda + "'";
  }

  f.setMainWidget();
  f.cursor().setMainFilter(filtro);
  var codAlmacen = f.exec("codalmacen");
  if (codAlmacen) {
    this.child("lneOrigen").text = codAlmacen;
    _i.establecerFiltros();
  }
}

function oficial_colorEstado(fN, fV, cursor, fT, sel)
{
  return formtpv_enviostx.iface.pub_colorEstado(fN, fV, cursor, fT, sel);
}

function oficial_dedDesde_valueChanged(d)
{
  this.child("dedHasta").date = d;
}

function oficial_tbnBorrar_clicked()
{
  var _i = this.iface;
  this.child("dedDesde").date = "";
  this.child("dedHasta").date = "";
  this.child("lneViaje").text = "";
  this.child("lneOrigen").text = "";
  _i.establecerFiltros();

}

function oficial_iniciarFechas()
{
  var _i = this.iface;
  var d = new Date;
  this.child("dedDesde").date = d;
  this.child("dedHasta").date = d;
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
