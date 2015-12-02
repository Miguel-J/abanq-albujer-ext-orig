/***************************************************************************
                 despachos.qs  -  description
                             -------------------
    begin                : lun jun 29 2009
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
  var bloqProvincia_;
  var tdbAlbaranes: Object;
  var tdbLineasAlbaran: Object;
  var tdbBultos: Object;
  var tdbLineasBulto: Object;
  var tdbEmbalajesBulto: Object;
  function oficial(context)
  {
    interna(context);
  }
  function bufferChanged(fN: String)
  {
    return this.ctx.oficial_bufferChanged(fN);
  }
  function tbnAsociarAlbaran_clicked()
  {
    return this.ctx.oficial_tbnAsociarAlbaran_clicked();
  }
  function tbnQuitarAlbaran_clicked()
  {
    return this.ctx.oficial_tbnQuitarAlbaran_clicked();
  }
  function calculaDireccion()
  {
    return this.ctx.oficial_calculaDireccion();
  }
  function quitarAlbaran(idAlbaran: String): Boolean {
    return this.ctx.oficial_quitarAlbaran(idAlbaran);
  }
  function asociarAlbaran(idAlbaran: String): Boolean {
    return this.ctx.oficial_asociarAlbaran(idAlbaran);
  }
  function filtrarAlbaranes()
  {
    return this.ctx.oficial_filtrarAlbaranes();
  }
  function filtrarLineasAlbaran()
  {
    return this.ctx.oficial_filtrarLineasAlbaran();
  }
  function ordenarLineasAlbaran()
  {
    return this.ctx.oficial_ordenarLineasAlbaran();
  }
  function ponAnchoColumnasLA()
  {
    return this.ctx.oficial_ponAnchoColumnasLA();
  }
  function anchoColumnasLA()
  {
    return this.ctx.oficial_anchoColumnasLA();
  }
  function tbnAnadir1_clicked()
  {
    return this.ctx.oficial_tbnAnadir1_clicked();
  }
  function asociarLineaBulto(curLinea: FLSqlCursor, curBulto: FLSqlCursor, cantidad: Number): Boolean {
    return this.ctx.oficial_asociarLineaBulto(curLinea, curBulto, cantidad);
  }
  function filtrarLineasBulto()
  {
    return this.ctx.oficial_filtrarLineasBulto();
  }
  function tbnQuitar1_clicked()
  {
    return this.ctx.oficial_tbnQuitar1_clicked();
  }
  function quitarLineaBulto(idLineaBulto: String): Boolean {
    return this.ctx.oficial_quitarLineaBulto(idLineaBulto);
  }
  function tbnQuitarTodos_clicked()
  {
    return this.ctx.oficial_tbnQuitarTodos_clicked();
  }
  function tbnAnadirTodos_clicked()
  {
    return this.ctx.oficial_tbnAnadirTodos_clicked();
  }
  function tbnAnadirParcial_clicked()
  {
    return this.ctx.oficial_tbnAnadirParcial_clicked();
  }
  function tbnQuitarParcial_clicked()
  {
    return this.ctx.oficial_tbnQuitarParcial_clicked();
  }
  function tbnAnadirUnico_clicked()
  {
    return this.ctx.oficial_tbnAnadirUnico_clicked();
  }
  function actualizarLineaBulto(idLineaBulto: String, cantidad: Number): Boolean {
    return this.ctx.oficial_actualizarLineaBulto(idLineaBulto, cantidad);
  }
  function totalizarBulto(idBulto: String): Boolean {
    return this.ctx.oficial_totalizarBulto(idBulto);
  }
  function calcularTotales(): Boolean {
    return this.ctx.oficial_calcularTotales();
  }
  function actualizarPesoVolBultos()
  {
    return this.ctx.oficial_actualizarPesoVolBultos();
  }
  function seleccionarLineasBulto()
  {
    return this.ctx.oficial_seleccionarLineasBulto();
  }
  function chkFiltroAlbaran_clicked()
  {
    return this.ctx.oficial_chkFiltroAlbaran_clicked();
  }
  function chkFiltroBulto_clicked()
  {
    return this.ctx.oficial_chkFiltroBulto_clicked();
  }
  function totalizarBultoSel()
  {
    return this.ctx.oficial_totalizarBultoSel();
  }
  function crearBulto(): FLSqlCursor {
    return this.ctx.oficial_crearBulto();
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
  var util: FLUtil = new FLUtil();
  var cursor: FLSqlCursor = this.cursor();

  this.iface.tdbAlbaranes = this.child("tdbAlbaranesCli");
  this.iface.tdbLineasAlbaran = this.child("tdbLineasAlbaranesCli");
  this.iface.tdbBultos = this.child("tdbBultosDespacho");
  this.iface.tdbLineasBulto = this.child("tdbLineasBulto");
  this.iface.tdbEmbalajesBulto = this.child("tdbEmbalajesBulto");

  this.iface.tdbLineasAlbaran.setReadOnly(true);
  this.iface.tdbAlbaranes.setReadOnly(true);
  this.iface.tdbLineasBulto.setReadOnly(true);

  connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");
  connect(this.child("tbnAsociarAlbaran"), "clicked()", this, "iface.tbnAsociarAlbaran_clicked");
  connect(this.child("tbnQuitarAlbaran"), "clicked()", this, "iface.tbnQuitarAlbaran_clicked");
  connect(this.child("tbnAnadir1"), "clicked()", this, "iface.tbnAnadir1_clicked");
  connect(this.child("tbnQuitar1"), "clicked()", this, "iface.tbnQuitar1_clicked");
  connect(this.child("tbnAnadirTodos"), "clicked()", this, "iface.tbnAnadirTodos_clicked");
  connect(this.child("tbnQuitarTodos"), "clicked()", this, "iface.tbnQuitarTodos_clicked");
  connect(this.child("tbnAnadirParcial"), "clicked()", this, "iface.tbnAnadirParcial_clicked");
  connect(this.child("tbnQuitarParcial"), "clicked()", this, "iface.tbnQuitarParcial_clicked");
  connect(this.child("tbnAnadirUnico"), "clicked()", this, "iface.tbnAnadirUnico_clicked");
  connect(this.child("chkFiltroAlbaran"), "clicked()", this, "iface.chkFiltroAlbaran_clicked");
  connect(this.child("chkFiltroBulto"), "clicked()", this, "iface.chkFiltroBulto_clicked");
  connect(this.iface.tdbAlbaranes.cursor(), "newBuffer()", this, "iface.filtrarLineasAlbaran");
  connect(this.iface.tdbLineasAlbaran.cursor(), "newBuffer()", this, "iface.seleccionarLineasBulto");
  connect(this.iface.tdbBultos.cursor(), "newBuffer()", this, "iface.filtrarLineasBulto");
  connect(this.iface.tdbBultos.cursor(), "bufferCommited()", this, "iface.calcularTotales");
  connect(this.iface.tdbEmbalajesBulto.cursor(), "bufferCommited()", this, "iface.totalizarBultoSel");

  //  connect(this.child("tdbLineasAlbaranesCli").cursor(), "bufferCommited()", this, "iface.calcularTotales()");

  this.iface.ordenarLineasAlbaran();
  _i.ponAnchoColumnasLA();

  this.iface.filtrarAlbaranes();
  this.iface.filtrarLineasBulto();
}

function interna_calculateField(fN: String): String {
  var util: FLUtil = new FLUtil();
  var cursor: FLSqlCursor = this.cursor();

  var valor: String;
  switch (fN)
  {
    case "canbultos": {
      valor = parseFloat(util.sqlSelect("bultosdespacho", "COUNT(idbulto)", "iddespacho = " + cursor.valueBuffer("iddespacho")));
      if (isNaN(valor)) {
        valor = 0;
      }
      break;
    }
    case "totalvolumen": {
      valor = parseFloat(util.sqlSelect("bultosdespacho", "SUM(volumen)", "iddespacho = " + cursor.valueBuffer("iddespacho")));
      if (isNaN(valor)) {
        valor = 0;
      }
      break;
    }
    case "totalpesobruto": {
      valor = parseFloat(util.sqlSelect("bultosdespacho", "SUM(pesobruto)", "iddespacho = " + cursor.valueBuffer("iddespacho")));
      if (isNaN(valor)) {
        valor = 0;
      }
      break;
    }
    case "totalpesoneto": {
      valor = parseFloat(util.sqlSelect("bultosdespacho", "SUM(pesoneto)", "iddespacho = " + cursor.valueBuffer("iddespacho")));
      if (isNaN(valor)) {
        valor = 0;
      }
      break;
    }
    case "totalpesovol": {
      valor = parseFloat(util.sqlSelect("bultosdespacho", "SUM(pesovol)", "iddespacho = " + cursor.valueBuffer("iddespacho")));
      if (isNaN(valor)) {
        valor = 0;
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
function oficial_ordenarLineasAlbaran()
{
  var _i = this.iface;
  var camposLineas;
  if (flfactppal.iface.pub_extension("tallcol_barcode")) {
    camposLineas = ["referencia", "descripcion", "cantidad", "talla", "color", "despachado", "candespachada"];
  } else {
    camposLineas = ["referencia", "descripcion", "cantidad", "despachado", "candespachada"];
  }
  _i.tdbLineasAlbaran.setOrderCols(camposLineas);
}

function oficial_ponAnchoColumnasLA()
{
  var _i = this.iface;
  var t = _i.tdbLineasAlbaran;
  var aC = _i.anchoColumnasLA()
  for (var i = 0; i < aC.length; i++) {
    t.setColumnWidth(aC[i][0], aC[i][1]);
  }
}

function oficial_anchoColumnasLA()
{
  if (flfactppal.iface.pub_extension("tallcol_barcode")) {
    return [["referencia", 100], ["talla", 30], ["color", 50], ["cantidad", 50], ["candespachada", 50], ["despachado", 50]];
  } else {
    return [["referencia", 100], ["cantidad", 50], ["candespachada", 50], ["despachado", 50]];
  }
}



function oficial_bufferChanged(fN: String)
{
  var cursor: FLSqlCursor = this.cursor();
  var util: FLUtil = new FLUtil();
  switch (fN) {
    case "codmediotransporte": {
      this.iface.actualizarPesoVolBultos();
      break;
    }
    case "provincia": {
      if (!this.iface.bloqProvincia_) {
        this.iface.bloqProvincia_ = true;
        flfactppal.iface.pub_obtenerProvincia(this);
        this.iface.bloqProvincia_ = false;
      }
      break;
    }
  }
}

function oficial_filtrarAlbaranes()
{
  var cursor: FLSqlCursor = this.cursor();

  var filtro: String = "idalbaran IN (SELECT idalbaran FROM albaranesdespacho WHERE iddespacho= " + cursor.valueBuffer("iddespacho") + ")";

  this.iface.tdbAlbaranes.setFilter(filtro);
  this.iface.tdbAlbaranes.refresh();

  this.iface.filtrarLineasAlbaran();
}

function oficial_filtrarLineasAlbaran()
{
  var cursor: FLSqlCursor = this.cursor();

  var curAlbaran: FLSqlCursor = this.iface.tdbAlbaranes.cursor();
  var idAlbaran: String = curAlbaran.valueBuffer("idalbaran");
  var idDespacho: String = cursor.valueBuffer("iddespacho");

  var filtro: String;
  if (idAlbaran && curAlbaran.size() > 0) {
    if (this.child("chkFiltroAlbaran").checked) {
      filtro = "idalbaran = " + idAlbaran;
    } else {
      filtro = "idalbaran IN (SELECT idalbaran FROM albaranesdespacho WHERE iddespacho = " + idDespacho + ")";
    }
  } else {
    filtro = "1 = 2";
  }
  debug("Filtro líneas = " + filtro);
  this.iface.tdbLineasAlbaran.setFilter(filtro);
  this.iface.tdbLineasAlbaran.refresh();
}

function oficial_filtrarLineasBulto()
{
  var cursor: FLSqlCursor = this.cursor();
  var curBulto: FLSqlCursor = this.iface.tdbBultos.cursor();
  var idBulto: String = curBulto.valueBuffer("idbulto");

  cursor.setValueBuffer("idbulto", idBulto);
  this.iface.tdbEmbalajesBulto.refresh();

  var idDespacho: String = cursor.valueBuffer("iddespacho");

  var filtro: String;
  if (idBulto && curBulto.size() > 0) {
    if (this.child("chkFiltroBulto").checked) {
      filtro = "idbulto = " + idBulto;
    } else {
      filtro = "idbulto IN (SELECT idbulto FROM bultosdespacho WHERE iddespacho = " + idDespacho + ")";
    }
  } else {
    filtro = "1 = 2";
  }
  debug("Filtro líneas = " + filtro);
  this.iface.tdbLineasBulto.setFilter(filtro);
  this.iface.tdbLineasBulto.refresh();
}

function oficial_tbnAsociarAlbaran_clicked()
{
  var _i = this.iface;
  var util: FLUtil = new FLUtil();
  var cursor: FLSqlCursor = this.cursor();

  if (!cursor.valueBuffer("codcliente")) {
    MessageBox.information(util.translate("scripts", "Antes de asociar albaranes deberá informar el cliente"), MessageBox.Yes, MessageBox.NoButton);
    return false;
  }
  var f: Object = new FLFormSearchDB("busalbcli");
  var curF: FLSqlCursor = f.cursor();
  curF.setMainFilter("idalbaran NOT IN (SELECT idalbaran FROM albaranesdespacho WHERE iddespacho = " + cursor.valueBuffer("iddespacho") + ") AND codcliente = '" + cursor.valueBuffer("codcliente") + "'");
  f.setMainWidget();
  var idAlbaran: String = f.exec("idalbaran");

  if (!idAlbaran) {
    return;
  }
  if (!this.iface.asociarAlbaran(idAlbaran)) {
    return;
  }
  _i.calculaDireccion();
  this.iface.filtrarAlbaranes();
}

function oficial_calculaDireccion()
{
  var cursor = this.cursor();

  var q = new AQSqlQuery;
  q.setSelect("a.direccion, a.coddir, a.ciudad, a.codpostal, a.provincia, a.idprovincia, a.codpais");
  q.setFrom("albaranesdespacho ad INNER JOIN albaranescli a ON ad.idalbaran = a.idalbaran");
  q.setWhere("ad.iddespacho = " + cursor.valueBuffer("iddespacho"));
  if (!q.exec()) {
    return false;
  }
  if (!q.first()) {
    return false;
  }
  sys.setObjText(this, "fdbCodDir", q.value("a.coddir"));
  sys.setObjText(this, "fdbDireccion", q.value("a.direccion"));
  sys.setObjText(this, "fdbCiudad", q.value("a.ciudad"));
  sys.setObjText(this, "fdbIdProvincia", q.value("a.idprovincia"));
  sys.setObjText(this, "fdbProvincia", q.value("a.provincia"));
  sys.setObjText(this, "fdbCodPostal", q.value("a.codpostal"));
  sys.setObjText(this, "fdbCodPais", q.value("a.codpais"));
}

function oficial_tbnQuitarAlbaran_clicked()
{
  var util: FLUtil = new FLUtil();
  var cursor: FLSqlCursor = this.cursor();

  var idAlbaran: String = this.iface.tdbAlbaranes.cursor().valueBuffer("idalbaran");
  if (!idAlbaran) {
    return;
  }
  if (!this.iface.quitarAlbaran(idAlbaran)) {
    return;
  }
  this.iface.filtrarAlbaranes();
}

function oficial_quitarAlbaran(idAlbaran: String): Boolean {
  var cursor: FLSqlCursor = this.cursor();

  var curAlbaranDespacho: FLSqlCursor = new FLSqlCursor("albaranesdespacho");
  curAlbaranDespacho.select("idalbaran = '" + idAlbaran + "' AND iddespacho = " + cursor.valueBuffer("iddespacho"));
  while (curAlbaranDespacho.next())
  {
    curAlbaranDespacho.setModeAccess(curAlbaranDespacho.Del);
    curAlbaranDespacho.refreshBuffer();
    if (!curAlbaranDespacho.commitBuffer()) {
      return false;
    }
  }
  return true;
}

function oficial_asociarAlbaran(idAlbaran: String): Boolean {
  var util: FLUtil = new FLUtil();
  var cursor: FLSqlCursor = this.cursor();
  var idDespacho: String = cursor.valueBuffer("iddespacho");

  if (cursor.modeAccess() == cursor.Insert)
  {
    if (!this.child("tdbBultosDespacho").cursor().commitBufferCursorRelation()) {
      return false;
    }
  }

  if (util.sqlSelect("albaranesdespacho", "idalbarandespacho", "idalbaran = '" + idAlbaran + "' AND iddespacho = " + idDespacho))
  {
    return true;
  }

  var curAlbaranDespacho: FLSqlCursor = new FLSqlCursor("albaranesdespacho");
  curAlbaranDespacho.setModeAccess(curAlbaranDespacho.Insert);
  curAlbaranDespacho.refreshBuffer();
  curAlbaranDespacho.setValueBuffer("idalbaran", idAlbaran);
  curAlbaranDespacho.setValueBuffer("iddespacho", idDespacho);
  if (!curAlbaranDespacho.commitBuffer())
  {
    return false;
  }
  return true;
}

function oficial_tbnAnadir1_clicked()
{
  var util: FLUtil = new FLUtil;
  var curLinea: FLSqlCursor = this.iface.tdbLineasAlbaran.cursor();
  var idLinea: String = curLinea.valueBuffer("idlinea");
  if (!idLinea) {
    return false;
  }
  var curBulto: FLSqlCursor = this.iface.tdbBultos.cursor();
  var idBulto: String = curBulto.valueBuffer("idbulto");
  if (!idBulto) {
    MessageBox.warning(util.translate("scripts", "No existen bultos\nAñade primero un bulto"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return false;
  }
  var despachar: Number = parseFloat(curLinea.valueBuffer("cantidad")) - parseFloat(curLinea.valueBuffer("candespachada"));
  if (!despachar || despachar <= 0) {
    MessageBox.warning(util.translate("scripts", "Este artículo ya ha sido despachado."), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return false;
  }
  if (!this.iface.asociarLineaBulto(curLinea, curBulto, despachar)) {
    return false;
  }
  this.iface.tdbLineasBulto.refresh();
  this.iface.filtrarLineasAlbaran();
}

function oficial_tbnAnadirParcial_clicked()
{
  var util: FLUtil = new FLUtil;
  var curLinea: FLSqlCursor = this.iface.tdbLineasAlbaran.cursor();
  var idLinea: String = curLinea.valueBuffer("idlinea");
  if (!idLinea) {
    return false;
  }
  var curBulto: FLSqlCursor = this.iface.tdbBultos.cursor();
  var idBulto: String = curBulto.valueBuffer("idbulto");
  if (!idBulto) {
    MessageBox.warning(util.translate("scripts", "No existen bultos\nAñade primero un bulto"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return false;
  }
  var despachar: Number = parseFloat(curLinea.valueBuffer("cantidad")) - parseFloat(curLinea.valueBuffer("candespachada"));
  if (!despachar || despachar <= 0) {
    MessageBox.warning(util.translate("scripts", "Este artículo ya ha sido despachado."), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return false;
  }
  despachar = Input.getNumber(util.translate("scripts", "Indroduzca cantidad a despachar"), despachar, 2, 0);
  if (!despachar || despachar <= 0) {
    return false;
  }
  if (!this.iface.asociarLineaBulto(curLinea, curBulto, despachar)) {
    return false;
  }
  this.iface.tdbLineasBulto.refresh();
  this.iface.filtrarLineasAlbaran();
}

function oficial_tbnAnadirTodos_clicked()
{
  var util: FLUtil = new FLUtil;
  var curBulto: FLSqlCursor = this.iface.tdbBultos.cursor();
  var idBulto: String = curBulto.valueBuffer("idbulto");
  if (!idBulto) {
    MessageBox.warning(util.translate("scripts", "No existen bultos\nAñade primero un bulto"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return false;
  }
  var curLinea: FLSqlCursor = this.iface.tdbLineasAlbaran.cursor();
  var idLinea: String;
  var despachar: Number;
  if (!curLinea.first()) {
    return false;
  }
  do {
    idLinea = curLinea.valueBuffer("idlinea");
    if (!idLinea) {
      return false;
    }
    despachar = parseFloat(curLinea.valueBuffer("cantidad")) - parseFloat(curLinea.valueBuffer("candespachada"));
    if (!despachar || despachar <= 0) {
      continue;
    }
    if (!this.iface.asociarLineaBulto(curLinea, curBulto, despachar)) {
      return false;
    }
  } while (curLinea.next());

  this.iface.tdbLineasBulto.refresh();
  this.iface.filtrarLineasAlbaran();
}

function oficial_asociarLineaBulto(curLinea, curBulto, cantidad)
{
  var util: FLUtil = new FLUtil;
  var idBulto: String = curBulto.valueBuffer("idbulto");
  var curLineasBulto: FLSqlCursor = new FLSqlCursor("lineasbulto");
  curLineasBulto.setModeAccess(curLineasBulto.Insert);
  curLineasBulto.refreshBuffer();
  curLineasBulto.setValueBuffer("idbulto", idBulto);
  curLineasBulto.setValueBuffer("numbulto", curBulto.valueBuffer("numero"));
  curLineasBulto.setValueBuffer("idlineaalbaran", curLinea.valueBuffer("idlinea"));
  curLineasBulto.setValueBuffer("codalbaran", util.sqlSelect("lineasalbaranescli la INNER JOIN albaranescli a ON la.idalbaran = a.idalbaran", "a.codigo", "la.idlinea = " + curLinea.valueBuffer("idlinea"), "lineasalbaranescli,albaranescli"));
  curLineasBulto.setValueBuffer("referencia", curLinea.valueBuffer("referencia"));
  curLineasBulto.setValueBuffer("descripcion", curLinea.valueBuffer("descripcion"));
  curLineasBulto.setValueBuffer("cantidad", cantidad);
  curLineasBulto.setValueBuffer("volumen", formRecordlineasbulto.iface.pub_commonCalculateField("volumen", curLineasBulto));
  curLineasBulto.setValueBuffer("peso", formRecordlineasbulto.iface.pub_commonCalculateField("peso", curLineasBulto));
  if (flfactppal.iface.pub_extension("tallcol_barcode")) {
    curLineasBulto.setValueBuffer("barcode", curLinea.valueBuffer("barcode"));
    curLineasBulto.setValueBuffer("talla", curLinea.valueBuffer("talla"));
    curLineasBulto.setValueBuffer("color", curLinea.valueBuffer("color"));
  }

  if (!curLineasBulto.commitBuffer()) {
    return false;
  }
  if (!this.iface.totalizarBulto(idBulto)) {
    return false;
  }
  return true;
}

function oficial_tbnQuitar1_clicked()
{
  var curLineaBulto: FLSqlCursor = this.iface.tdbLineasBulto.cursor();
  var idLineaBulto: String = curLineaBulto.valueBuffer("idlinea");
  if (!idLineaBulto) {
    return false;
  }
  if (!this.iface.quitarLineaBulto(idLineaBulto)) {
    return false;
  }
  this.iface.tdbLineasBulto.refresh();
  this.iface.filtrarLineasAlbaran();
}

function oficial_tbnQuitarParcial_clicked()
{
  var util: FLUtil = new FLUtil;
  var curLineaBulto: FLSqlCursor = this.iface.tdbLineasBulto.cursor();
  var idLineaBulto: String = curLineaBulto.valueBuffer("idlinea");
  if (!idLineaBulto) {
    return false;
  }
  var despachar: Number = parseFloat(curLineaBulto.valueBuffer("cantidad"));
  var quitar: Number = Input.getNumber(util.translate("scripts", "Indroduzca cantidad a quitar de la línea"), despachar, 2, 0, despachar);
  if (!quitar || quitar <= 0) {
    return false;
  }
  if (quitar == despachar) {
    if (!this.iface.quitarLineaBulto(idLineaBulto)) {
      return false;
    }
  } else {
    var cantidad: Number = despachar - quitar;
    if (!this.iface.actualizarLineaBulto(idLineaBulto, cantidad)) {
      return false;
    }
  }
  this.iface.tdbLineasBulto.refresh();
  this.iface.filtrarLineasAlbaran();
}

function oficial_tbnQuitarTodos_clicked()
{
  var idLineaBulto: String;
  var idBulto: String;
  var curLineaBulto: FLSqlCursor = new FLSqlCursor("lineasbulto"); //this.iface.tdbLineasBulto.cursor();
  curLineaBulto.select(this.iface.tdbLineasBulto.filter());
  debug("filtro " + this.iface.tdbLineasBulto.filter());
  debug("mainfiltro " + curLineaBulto.mainFilter());
  debug("TamaNNNNNNo = " + curLineaBulto.size());
  if (!curLineaBulto.first()) {
    return false;
  }
  do {
    idLineaBulto = curLineaBulto.valueBuffer("idlinea");
    idBulto = curLineaBulto.valueBuffer("idbulto");
    debug("Quitando " + curLineaBulto.valueBuffer("referencia"));
    if (!idLineaBulto) {
      return false;
    }
    if (!this.iface.quitarLineaBulto(idLineaBulto)) {
      return false;
    }
    if (!this.iface.totalizarBulto(idBulto)) {
      return false;
    }
    debug("FIN Quitando " + curLineaBulto.valueBuffer("referencia"));
  } while (curLineaBulto.next());

  this.iface.tdbLineasBulto.refresh();
  this.iface.filtrarLineasAlbaran();
}

function oficial_quitarLineaBulto(idLineaBulto: String): Boolean {
  var util: FLUtil = new FLUtil;
  var curLineasBulto: FLSqlCursor = new FLSqlCursor("lineasbulto");
  curLineasBulto.select("idlinea = " + idLineaBulto);
  if (!curLineasBulto.first())
  {
    return false;
  }
  var idBulto: String = curLineasBulto.valueBuffer("idbulto");
  curLineasBulto.setModeAccess(curLineasBulto.Del);
  curLineasBulto.refreshBuffer();
  if (!curLineasBulto.commitBuffer())
  {
    return false;
  }
  if (!this.iface.totalizarBulto(idBulto))
  {
    return false;
  }
  return true;
}

function oficial_actualizarLineaBulto(idLineaBulto: String, cantidad: Number): Boolean {
  var util: FLUtil = new FLUtil;
  var curLineasBulto: FLSqlCursor = new FLSqlCursor("lineasbulto");
  curLineasBulto.select("idlinea = " + idLineaBulto);
  if (!curLineasBulto.first())
  {
    return false;
  }
  curLineasBulto.setModeAccess(curLineasBulto.Edit);
  curLineasBulto.refreshBuffer();
  curLineasBulto.setValueBuffer("cantidad", cantidad);
  curLineasBulto.setValueBuffer("volumen", formRecordlineasbulto.iface.pub_commonCalculateField("volumen", curLineasBulto));
  curLineasBulto.setValueBuffer("peso", formRecordlineasbulto.iface.pub_commonCalculateField("peso", curLineasBulto));
  if (!curLineasBulto.commitBuffer())
  {
    return false;
  }
  if (!this.iface.totalizarBulto(curLineasBulto.valueBuffer("idbulto")))
  {
    return false;
  }
  return true;
}

function oficial_totalizarBulto(idBulto: String): Boolean {
  var curBulto: FLSqlCursor = new FLSqlCursor("bultosdespacho"); ///this.iface.tdbBultos.cursor();
  curBulto.select("idbulto = " + idBulto);
  if (!curBulto.first())
  {
    return false;
  }
  curBulto.setModeAccess(curBulto.Edit);
  curBulto.refreshBuffer();
  curBulto.setValueBuffer("pesobruto", formRecordbultosdespacho.iface.pub_commonCalculateField("pesobruto", curBulto));
  curBulto.setValueBuffer("pesoneto", formRecordbultosdespacho.iface.pub_commonCalculateField("pesoneto", curBulto));
  if (formRecordbultosdespacho.iface.pub_validarArticuloSuelto(curBulto))
  {
    curBulto.setValueBuffer("alto", formRecordbultosdespacho.iface.pub_commonCalculateField("alto", curBulto));
    curBulto.setValueBuffer("largo", formRecordbultosdespacho.iface.pub_commonCalculateField("largo", curBulto));
    curBulto.setValueBuffer("ancho", formRecordbultosdespacho.iface.pub_commonCalculateField("ancho", curBulto));
    curBulto.setValueBuffer("volumen", formRecordbultosdespacho.iface.pub_commonCalculateField("volumen", curBulto));
  } else {
    curBulto.setValueBuffer("articulosuelto", false);
    curBulto.setValueBuffer("alto", 0);
    curBulto.setValueBuffer("largo", 0);
    curBulto.setValueBuffer("ancho", 0);
    curBulto.setValueBuffer("volumen", 0);
  }
  if (!curBulto.commitBuffer())
  {
    return false;
  }
  this.child("tdbBultosDespacho").refresh();
  if (!this.iface.calcularTotales())
  {
    return false;
  }
  return true;
}

function oficial_totalizarBultoSel()
{
  var cursor: FLSqlCursor = this.cursor();
  this.iface.totalizarBulto(cursor.valueBuffer("idbulto"));
}

function oficial_calcularTotales(): Boolean {
  this.child("fdbCanBultos").setValue(this.iface.calculateField("canbultos"));
  this.child("fdbTotalVolumen").setValue(this.iface.calculateField("totalvolumen"));
  this.child("fdbTotalPesoBruto").setValue(this.iface.calculateField("totalpesobruto"));
  this.child("fdbTotalPesoNeto").setValue(this.iface.calculateField("totalpesoneto"));
  this.child("fdbTotalPesoVol").setValue(this.iface.calculateField("totalpesovol"));
  return true;
}

function oficial_actualizarPesoVolBultos()
{
  var curBultos: FLSqlCursor = this.iface.tdbBultos.cursor();
  var filtro: String = cursor.mainFilter();
  debug("filtro = " + filtro);
  if (!curBultos.first()) {
    return true;
  }
  do {
    curBultos.setModeAccess(curBultos.Edit);
    curBultos.refreshBuffer();
    curBultos.setValueBuffer("pesovol", formRecordbultosdespacho.iface.pub_commonCalculateField("pesovol", curBultos));
    if (!curBultos.commitBuffer()) {
      return false;
    }
  } while (curBultos.next());
  this.child("fdbTotalPesoVol").setValue(this.iface.calculateField("totalpesovol"));
}

function oficial_seleccionarLineasBulto()
{
  debug("oficial_seleccionarLineasBulto");
  var curLineaAlbaran: FLSqlCursor = this.iface.tdbLineasAlbaran.cursor();
  var idLineaAlbaran: String = curLineaAlbaran.valueBuffer("idlinea");

  this.iface.tdbLineasBulto.clearChecked();
  var qryLineas: FLSqlQuery = new FLSqlQuery;
  qryLineas.setTablesList("lineasbulto");
  qryLineas.setSelect("idlinea");
  qryLineas.setFrom("lineasbulto");
  qryLineas.setWhere("idlineaalbaran = " + idLineaAlbaran);
  qryLineas.setForwardOnly(true);
  if (!qryLineas.exec()) {
    return false;
  }
  while (qryLineas.next()) {
    debug("Activando " + qryLineas.value("idlinea"));
    this.iface.tdbLineasBulto.setPrimaryKeyChecked(qryLineas.value("idlinea"), true);
  }
  this.iface.tdbLineasBulto.refresh();
}

function oficial_chkFiltroAlbaran_clicked()
{
  this.iface.filtrarLineasAlbaran();
}
function oficial_chkFiltroBulto_clicked()
{
  this.iface.filtrarLineasBulto();
}

function oficial_tbnAnadirUnico_clicked()
{
  var curLinea: FLSqlCursor = this.iface.tdbLineasAlbaran.cursor();
  var idLinea: String = curLinea.valueBuffer("idlinea");
  if (!idLinea) {
    return false;
  }
  var curBulto: FLSqlCursor = this.iface.crearBulto();
  if (!curBulto) {
    return false;
  }
  var despachar: Number = parseFloat(curLinea.valueBuffer("cantidad")) - parseFloat(curLinea.valueBuffer("candespachada"));
  if (!despachar || despachar <= 0) {
    return false;
  }
  if (!this.iface.asociarLineaBulto(curLinea, curBulto, despachar)) {
    return false;
  }
  this.iface.tdbLineasBulto.refresh();
  this.iface.filtrarLineasAlbaran();
}

function oficial_crearBulto(): FLSqlCursor {
  var cursor: FLSqlCursor = this.cursor();

  var curBulto: FLSqlCursor = new FLSqlCursor("bultosdespacho");
  curBulto.setModeAccess(curBulto.Insert);
  curBulto.refreshBuffer();
  curBulto.setValueBuffer("iddespacho", cursor.valueBuffer("iddespacho"));
  curBulto.setValueBuffer("numero", formRecordbultosdespacho.iface.pub_commonCalculateField("numero", curBulto));
  curBulto.setValueBuffer("articulosuelto", true);
  if (!curBulto.commitBuffer())
  {
    return false;
  }

  this.child("tdbBultosDespacho").refresh();
  return curBulto;
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
