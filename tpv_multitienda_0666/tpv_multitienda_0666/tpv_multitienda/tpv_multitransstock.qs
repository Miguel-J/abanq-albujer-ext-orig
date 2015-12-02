/***************************************************************************
                 tpv_multitransstock.qs  -  description
                             -------------------
    begin                : mie nov 15 2006
    copyright            : Por ahora (C) 2006 by InfoSiAL S.L.
    email                : mail@infosial.com
 ***************************************************************************/
/***************************************************************************
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License, or     *
 *   (at your option) any later versios                                    *
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
  function validateForm()
  {
    this.ctx.interna_validateForm();
  }
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna
{
  var bloqueoCarga_;
  var filtroSelArt_;
  var filtroSelAlm_;
  var tblTransstock_;
  var hayCampoEmpresa_;
  var idArticulos_; /// Objeto con las referencias / ids de los artículos
  var stockOrigenPositivo_, stockOrigenNegativo_, stockDestinoPositivo_, stockDestinoNegativo_, reposicionPositivo_, reposicionNegativo_, cFAMILIA, cARTICULO, cREFERENCIA, cORIGEN, cRECOM, cSTOCKDESTINO, cSTOCKORIGEN;
  var cDESTINO, cREPONER;
  function oficial(context)
  {
    interna(context);
  }
  function colores()
  {
    return this.ctx.oficial_colores();
  }
  function construirTablaTransferencias()
  {
    return this.ctx.oficial_construirTablaTransferencias();
  }
  function cargarTablaTransferencias()
  {
    return this.ctx.oficial_cargarTablaTransferencias();
  }
  function cargarTablaReposiciones()
  {
    return this.ctx.oficial_cargarTablaReposiciones();
  }
  function tbnLimpiarTabla_clicked()
  {
    return this.ctx.oficial_tbnLimpiarTabla_clicked();
  }
  function limpiarTabla()
  {
    return this.ctx.oficial_limpiarTabla();
  }
  function cargaLineas(q, tipoConsulta)
  {
    return this.ctx.oficial_cargaLineas(q, tipoConsulta);
  }
  function creaFila(f, q, tipoConsulta)
  {
    return this.ctx.oficial_creaFila(f, q, tipoConsulta);
  }
  function datosFila(f, q, tipoConsulta)
  {
    return this.ctx.oficial_datosFila(f, q, tipoConsulta);
  }
  function datosArticuloFila(f, q, tipoConsulta)
  {
    return this.ctx.oficial_datosArticuloFila(f, q, tipoConsulta);
  }
  function objetoArticulo(q)
  {
    return this.ctx.oficial_objetoArticulo(q);
  }
  function stockArticulo(codAlmOrigen, oArticulo)
  {
    return this.ctx.oficial_stockArticulo(codAlmOrigen, oArticulo);
  }
  function pbnIncluirArt_clicked()
  {
    return this.ctx.oficial_pbnIncluirArt_clicked();
  }
  function ponFiltroSelArt(f)
  {
    return this.ctx.oficial_ponFiltroSelArt(f);
  }
  function articulosMasivo()
  {
    return this.ctx.oficial_articulosMasivo();
  }
  function incluirArticulo(w, forzar)
  {
    return this.ctx.oficial_incluirArticulo(w, forzar);
  }
  function referenciaStockPos(referencia, codAlmacen)
  {
    return this.ctx.oficial_referenciaStockPos(referencia, codAlmacen);
  }
  function pbnIncluirAlm_clicked()
  {
    return this.ctx.oficial_pbnIncluirAlm_clicked();
  }
  function ponFiltroSelAlm(f)
  {
    return this.ctx.oficial_ponFiltroSelAlm(f);
  }
  function cambiarTab(tab)
  {
    return this.ctx.oficial_cambiarTab(tab);
  }
  function mostrarTransferencias()
  {
    return this.ctx.oficial_mostrarTransferencias();
  }
  function actualizarTransferencias(f, c)
  {
    return this.ctx.oficial_actualizarTransferencias(f, c);
  }
  function prevalidaLinea()
  {
    return this.ctx.oficial_prevalidaLinea();
  }
  function borrarLinea(codMulti, oArticulo, codAlmaDestino)
  {
    return this.ctx.oficial_borrarLinea(codMulti, oArticulo, codAlmaDestino);
  }
  function obtenerLineaMultiTransStock(codMulti, oArticulo, codAlmaDestino)
  {
    return this.ctx.oficial_obtenerLineaMultiTransStock(codMulti, oArticulo, codAlmaDestino);
  }
  function obtenerCantidadRecom(oArticulo, codAlmaDestino)
  {
    return this.ctx.oficial_obtenerCantidadRecom(oArticulo, codAlmaDestino);
  }
  function masDatosLineaMultiTransStock(curL, oArticulo)
  {
    return this.ctx.oficial_masDatosLineaMultiTransStock(curL, oArticulo);
  }
  function masDatosMultiTransStock(curV, codAlmaOrigen, codAlmaDestino)
  {
    return this.ctx.oficial_masDatosMultiTransStock(curV, codAlmaOrigen, codAlmaDestino);
  }
  function obtenerDescripcion(oArticulo)
  {
    return this.ctx.oficial_obtenerDescripcion(oArticulo);
  }
  function idViaje(curV)
  {
    return this.ctx.oficial_idViaje(curV);
  }
  function procesaLinea(oArticulo, codAlmaOrigen, codAlmaDestino, cantidad)
  {
    return this.ctx.oficial_procesaLinea(oArticulo, codAlmaOrigen, codAlmaDestino, cantidad);
  }
  function existeReferencia(referencia)
  {
    return this.ctx.oficial_existeReferencia(referencia);
  }
  function filtrarLineas()
  {
    return this.ctx.oficial_filtrarLineas();
  }
  function eliminarArticulo()
  {
    return this.ctx.oficial_eliminarArticulo();
  }
  function eliminarAlmacen()
  {
    return this.ctx.oficial_eliminarAlmacen();
  }
  function obtenerCantidadReponer(codMulti, oArticulo, codAlmaDestino)
  {
    return this.ctx.oficial_obtenerCantidadReponer(codMulti, oArticulo, codAlmaDestino);
  }
  function tbnCrearPedidos_clicked()
  {
    return this.ctx.oficial_tbnCrearPedidos_clicked();
  }
  function creaPedidoProv(curViaje)
  {
    return this.ctx.oficial_creaPedidoProv(curViaje);
  }
  function dameProveedorAlmacen(codAlmacen)
  {
    return this.ctx.oficial_dameProveedorAlmacen(codAlmacen);
  }
  function datosLineaProv(idPedido, curLinea, curLineaProv)
  {
    return this.ctx.oficial_datosLineaProv(idPedido, curLinea, curLineaProv);
  }
  function datosLineaCli(idPedido, curLinea, curLineaCli)
  {
    return this.ctx.oficial_datosLineaCli(idPedido, curLinea, curLineaCli);
  }
  function creaPedidoCli(curViaje)
  {
    return this.ctx.oficial_creaPedidoCli(curViaje);
  }
  function creaLinea(fN, idPedido, curLinea)
  {
    return this.ctx.oficial_creaLinea(fN, idPedido, curLinea);
  }
  function datosPedidoCli(curPedidoCli, curViaje)
  {
    return this.ctx.oficial_datosPedidoCli(curPedidoCli, curViaje);
  }
  function dameEjercicioAlmacen(codAlmacen, fecha)
  {
    return this.ctx.oficial_dameEjercicioAlmacen(codAlmacen, fecha);
  }
  function creaTotal(fN, cursor)
  {
    return this.ctx.oficial_creaTotal(fN, cursor);
  }
  function datosPedidoProv(curPedidoProv, curViaje)
  {
    return this.ctx.oficial_datosPedidoProv(curPedidoProv, curViaje);
  }
  function eliminaPedidoProv(codMultitransstock)
  {
    return this.ctx.oficial_eliminaPedidoProv(codMultitransstock);
  }
  function eliminaPedidoCli(codMultitransstock)
  {
    return this.ctx.oficial_eliminaPedidoCli(codMultitransstock);
  }
  function habilitarPorEstado()
  {
    return this.ctx.oficial_habilitarPorEstado();
  }
  function cargaAlmacenes()
  {
    return this.ctx.oficial_cargaAlmacenes();
  }
  function inhabilitarAlmacenes()
  {
    return this.ctx.oficial_inhabilitarAlmacenes();
  }
  function listaAlmacenes()
  {
    return this.ctx.oficial_listaAlmacenes();
  }
  function tdbAlmacenes_primaryKeyToggled(codAlmacen, on)
  {
    return this.ctx.oficial_tdbAlmacenes_primaryKeyToggled(codAlmacen, on);
  }
  function fechasRecom()
  {
    return this.ctx.oficial_fechasRecom();
  }
  function tbnRefrescarRecom_clicked()
  {
    return this.ctx.oficial_tbnRefrescarRecom_clicked();
  }
  function cargaHayEmpresa()
  {
    return this.ctx.oficial_cargaHayEmpresa();
  }
  function tbnImprimePedCli_clicked()
  {
    return this.ctx.oficial_tbnImprimePedCli_clicked();
  }
  function dameParamInformePedCli()
  {
    return this.ctx.oficial_dameParamInformePedCli();
  }
  function habilitaPestanaSets()
  {
    return this.ctx.oficial_habilitaPestanaSets();
  }
  function tbnInsertaLinea_clicked()
  {
    return this.ctx.oficial_tbnInsertaLinea_clicked();
  }
  function ponCantidad1(f)
  {
    return this.ctx.oficial_ponCantidad1(f);
  }
  function tbnCalcular_clicked()
  {
    return this.ctx.oficial_tbnCalcular_clicked();
  }
  function idFila(q, tipoConsulta)
  {
    return this.ctx.oficial_idFila(q, tipoConsulta);
  }
  function mainFilterAlmacenes()
  {
    return this.ctx.oficial_mainFilterAlmacenes();
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
  function pub_ponFiltroSelArt(f)
  {
    return this.ponFiltroSelArt(f);
  }
  function pub_ponFiltroSelAlm(f)
  {
    return this.ponFiltroSelAlm(f);
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
*/
function interna_init()
{
  var _i = this.iface;
  var cursor = this.cursor();

  _i.tblTransstock_ = this.child("tblTransstock");
  connect(this.child("pbnIncluirArt"), "clicked()", _i, "pbnIncluirArt_clicked()");
  if (this.child("tbnLimpiarTabla")) {
    //    this.child("tbnLimpiarTabla").close();
    connect(this.child("tbnLimpiarTabla"), "clicked()", _i, "tbnLimpiarTabla_clicked()");
  }
  connect(this.child("tbnCalcular"), "clicked()", _i, "tbnCalcular_clicked()");


  //  connect(this.child("pbnIncluirAlm"), "clicked()", _i, "pbnIncluirAlm_clicked()");
  connect(this.child("tbwMultiTransStock"), "currentChanged(QString)", _i, "cambiarTab()");
  connect(_i.tblTransstock_, "valueChanged(int, int)", _i, "actualizarTransferencias");
  connect(this.child("tdbViajes"), "currentChanged()", _i, "filtrarLineas()");
  connect(this.child("chkFiltroLineas"), "clicked()", _i, "filtrarLineas()");
  connect(this.child("toolButtonDeleteArt"), "clicked()", _i, "eliminarArticulo");
  //  connect(this.child("toolButtonDeleteAlm"), "clicked()", _i, "eliminarAlmacen");
  connect(this.child("tbnCrearPedidos"), "clicked()", _i, "tbnCrearPedidos_clicked");
  connect(this.child("tbnRefrescarRecom"), "clicked()", _i, "tbnRefrescarRecom_clicked");
  connect(this.child("tbnImprimePedCli"), "clicked()", _i, "tbnImprimePedCli_clicked");

  connect(this.child("tdbAlmacenes"), "primaryKeyToggled(QVariant, bool)", _i, "tdbAlmacenes_primaryKeyToggled");
  connect(this.child("tbnInsertaLinea"), "clicked()", _i, "tbnInsertaLinea_clicked");

  _i.mainFilterAlmacenes();
  if (cursor.valueBuffer("codalmaorigen") == "" || !cursor.valueBuffer("codalmaorigen")) {
    var codAlmacen = flfact_tpv.iface.pub_almacenActual();
    if (!codAlmacen || codAlmacen == "") {
      codAlmacen = flfactppal.iface.pub_valorDefectoEmpresa("codalmacen");
    }
    this.child("fdbAlmaOrigen").setValue(codAlmacen);
  }

  if (flfact_tpv.iface.pub_esBDLocal() && cursor.valueBuffer("codalmaorigen") != "" && cursor.valueBuffer("codalmaorigen")) {
    this.child("fdbAlmaOrigen").setDisabled(true);
  }

  _i.bloqueoCarga_ = true;
  _i.cargaAlmacenes();
  _i.bloqueoCarga_ = false;
  _i.habilitarPorEstado();
  _i.colores();

  if (cursor.valueBuffer("codalmaorigen") && cursor.valueBuffer("codalmaorigen")  != "") {
    this.child("tdbAlmacenes").setFilter("codalmacen <> '" + cursor.valueBuffer("codalmaorigen")  + "'");
    this.child("tdbAlmacenes").refresh();
  }

  if (cursor.modeAccess() == cursor.Edit) {
    debug("editando");
    _i.habilitaPestanaSets();
  }

  _i.fechasRecom();
  _i.cargaHayEmpresa();
}

function interna_validateForm()
{
  var _i = this.iface;
  return true;
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_mainFilterAlmacenes()
{
  //  this.child("tdbAlmacenes").cursor().setMainFilter("codalmacen like 'A%'");
}

function oficial_tbnInsertaLinea_clicked()
{
  var _i = this.iface;
  var referencia = this.child("lneReferencia").text;
  if (!referencia || referencia == "") {
    return false;
  }
  var cursor = this.cursor();
  var codMultiTrans = cursor.valueBuffer("codmultitransstock");
  var encontrado = true;
  if (!_i.existeReferencia(referencia)) {
    encontrado = false;
    if (!_i.incluirArticulo("referencia = '" + referencia + "'", true)) {
      return false;
    }

    var q = new FLSqlQuery;
    q.setSelect("a.referencia,a.descripcion,a.codfamilia");
    q.setFrom("tpv_artmultitransstock m INNER JOIN articulos a ON m.referencia = a.referencia");
    q.setWhere("m.codmultitransstock = '" + codMultiTrans + "' AND m.referencia = '" + referencia + "' order by a.codfamilia,a.descripcion");
    q.setForwardOnly(true);
    debug(q.sql());
    if (!q.exec()) {
      return;
    }
    _i.cargaLineas(q, "TAB");
  }
  var f = _i.idArticulos_[referencia];
  if (!encontrado) {
    if (!_i.ponCantidad1(f)) {
      return false;
    }
  }
  _i.tblTransstock_.clearSelection();
  _i.tblTransstock_.selectRow(f);

  this.child("lneReferencia").text = "";
  this.child("lneReferencia").setFocus();
}

function oficial_ponCantidad1(f)
{
  var _i = this.iface;
  for (var i = 0; i < _i.cDESTINO.length; i++) {
    codAlmaDestino = _i.cDESTINO[i]["codalmacen"];
    if (!codAlmaDestino) {
      return;
    }
    var c = parseFloat(_i.tblTransstock_.text(f, _i.cREPONER[i]));
    c = isNaN(c) ? 0 : c;
    c = c + 1;
    _i.tblTransstock_.setText(f, _i.cREPONER[i], c);
    _i.actualizarTransferencias(f, _i.cREPONER[i]);
  }
  return true;
}

function oficial_habilitaPestanaSets()
{
  var _i = this.iface;
  var cursor = this.cursor();
  var lineas = AQUtil.sqlSelect("tpv_lineasmultitransstock", "idlinea", "codmultitransstock = '" + cursor.valueBuffer("codmultitransstock") + "'");
  if (lineas) {
    this.child("gbxArticulos").setDisabled(true);
    this.child("gbxAlmacenesGen").setDisabled(true);
    _i.inhabilitarAlmacenes();
  }
}

function oficial_pbnIncluirArt_clicked()
{
  var _i = this.iface;
  var cursor = this.cursor();

  var codAlmaOrigen = cursor.valueBuffer("codalmaorigen");
  if (!codAlmaOrigen) {
    MessageBox.warning(sys.translate("Debe indicar el almacén origen"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton, "AbanQ");
    return false;
  }

  var f = new FLFormSearchDB("tpv_selectart");
  f.setMainWidget();
  f.exec();
  if (!f.accepted()) {
    return false;
  }
  if (_i.filtroSelArt_ == "") {
    return false;
  }

  _i.articulosMasivo();
}

function oficial_ponFiltroSelArt(f)
{
  var _i = this.iface;
  _i.filtroSelArt_ = f;
}

function oficial_articulosMasivo()
{
  var _i = this.iface;
  var cursor = this.cursor();

  if (cursor.modeAccess() == cursor.Insert) {
    if (!this.child("tdbArticulos").cursor().commitBufferCursorRelation()) {
      return false;
    }
  }
  if (!_i.incluirArticulo(_i.filtroSelArt_)) {
    return false;
  }
  this.child("tdbArticulos").refresh();
}

function oficial_incluirArticulo(w, forzar)
{
  var _i = this.iface;
  var cursor = this.cursor();

  var q = new FLSqlQuery;
  q.setSelect("referencia, descripcion");
  q.setFrom("articulos");
  q.setWhere(w);
  q.setForwardOnly(true);
  debug(q.sql());
  if (!q.exec()) {
    return;
  }

  if (q.size() > 100) {
    var res = MessageBox.warning(AQUtil.translate("scripts", "La búsqueda que va a lanzar ha encontrado %1 registros.\n¿Desea continuar?").arg(q.size()), MessageBox.Yes, MessageBox.No, MessageBox.NoButton, "AbanQ");
    if (res != MessageBox.Yes)
      return;

  }

  var codAlmaOrigen = cursor.valueBuffer("codalmaorigen");
  var curArtMP = new FLSqlCursor("tpv_artmultitransstock");
  var referencia;

  var p = 0;
  AQUtil.createProgressDialog(sys.translate("Insertando selección de artículos"), q.size());

  while (q.next()) {
    AQUtil.setProgress(p++);
    referencia = q.value("referencia");
    if (!forzar) {
      if (cursor.valueBuffer("solostockpos")) {
        if (!_i.referenciaStockPos(referencia, codAlmaOrigen)) {
          continue;
        }
      }
    }

    curArtMP.setModeAccess(curArtMP.Insert);
    curArtMP.refreshBuffer();
    curArtMP.setValueBuffer("referencia", q.value("referencia"));
    curArtMP.setValueBuffer("codmultitransstock", cursor.valueBuffer("codmultitransstock"));
    curArtMP.setValueBuffer("descripcion", q.value("descripcion"));

    if (!curArtMP.commitBuffer()) {
      AQUtil.destroyProgressDialog();
      return;
    }
  }
  AQUtil.destroyProgressDialog();
  return true;
}

function oficial_referenciaStockPos(referencia, codAlmacen)
{
  var _i = this.iface;
  if (!AQUtil.sqlSelect("stocks", "idstock", "referencia = '" + referencia + "' AND codalmacen = '" + codAlmacen + "' AND disponible > 0")) {
    return false;
  }
  return true;
}


function oficial_pbnIncluirAlm_clicked()
{
  var _i = this.iface;
  var cursor = this.cursor();
  var filtro = "";
  var f = new FLFormSearchDB("tpv_selectalm");
  f.setMainWidget();
  f.exec();
  if (!f.accepted()) {
    return false;
  }
  if (_i.filtroSelAlm_ == "") {
    return false;
  }

  if (cursor.modeAccess() == cursor.Insert) {
    if (!this.child("tdbAlmacenes").cursor().commitBufferCursorRelation()) {
      return false;
    }
  }

  var q = new FLSqlQuery;
  q.setSelect("codalmacen, nombre");
  q.setFrom("almacenes");
  q.setWhere(_i.filtroSelAlm_);
  q.setForwardOnly(true);
  if (!q.exec()) {
    return;
  }
  while (q.next()) {
    var curAlmMP = new FLSqlCursor("tpv_almamultitransstock");
    curAlmMP.setModeAccess(curAlmMP.Insert);
    curAlmMP.refreshBuffer();
    curAlmMP.setValueBuffer("codalmacen", q.value("codalmacen"));
    curAlmMP.setValueBuffer("codmultitransstock", cursor.valueBuffer("codmultitransstock"));
    curAlmMP.setValueBuffer("nombre", q.value("nombre"));
    if (!curAlmMP.commitBuffer()) {
      return false;
    }
  }
  this.child("tdbAlmacenes").refresh();
}

function oficial_ponFiltroSelAlm(f)
{
  var _i = this.iface;
  _i.filtroSelAlm_ = f;
}

function oficial_cambiarTab(tab)
{
  var _i = this.iface;
  if (tab && tab == "tabTransferencias") {
    if (_i.tblTransstock_.numRows() == 0) {
      _i.mostrarTransferencias();
    }
  }
}

function oficial_mostrarTransferencias()
{
  var _i = this.iface;
  _i.construirTablaTransferencias();
  _i.cargarTablaTransferencias();
}

function oficial_colores()
{
  var _i = this.iface;
  _i.stockOrigenPositivo_ = new Color("green");
  _i.stockOrigenNegativo_ = new Color("red");
  _i.stockDestinoPositivo_ = new Color("yellow");
  _i.stockDestinoNegativo_ = new Color(220, 220, 220);
  _i.reposicionPositivo_ = new Color(231, 88, 244);

  _i.reposicionNegativo_ = new Color(220, 220, 220);
}

function oficial_construirTablaTransferencias()
{
  var cabecera = "";
  var _i = this.iface;
  var cursor = this.cursor();
  var c = 0;

  var codMultiTrans = cursor.valueBuffer("codmultitransstock");
  if (!codMultiTrans || codMultiTrans == "")
    return;

  _i.cFAMILIA = c++;
  cabecera += AQUtil.translate("scripts", "Familia") + "/";
  _i.cARTICULO = c++;
  cabecera += AQUtil.translate("scripts", "Artículo") + "/";
  _i.cREFERENCIA = c++;
  cabecera += AQUtil.translate("scripts", "Referencia") + "/";
  _i.cORIGEN = c++;
  cabecera += AQUtil.sqlSelect("almacenes", "nombre", "codalmacen = '" + cursor.valueBuffer("codalmaorigen") + "'") + "/";
  _i.cSTOCKORIGEN = c++;
  cabecera += AQUtil.translate("scripts", "S.Origen") + "/";
  _i.cDESTINO = [];
  _i.cREPONER = [];
  _i.cRECOM = [];
  _i.cSTOCKDESTINO = [];
  var qryAlm = new FLSqlQuery;
  qryAlm.setSelect("tpv_almamultitransstock.codalmacen,almacenes.nombre");
  qryAlm.setFrom("tpv_almamultitransstock INNER JOIN almacenes ON almacenes.codalmacen = tpv_almamultitransstock.codalmacen");
  qryAlm.setWhere("codmultitransstock = '" + codMultiTrans + "'");
  qryAlm.setForwardOnly(true);

  if (!qryAlm.exec()) {
    return;
  }

  var i = 0;
  while (qryAlm.next()) {
    _i.cDESTINO[i] = [];
    _i.cDESTINO[i]["col"] = c++;
    _i.cDESTINO[i]["codalmacen"] = qryAlm.value("tpv_almamultitransstock.codalmacen");
    cabecera += qryAlm.value("almacenes.nombre") + "/";

    _i.cSTOCKDESTINO[i] = c++;
    cabecera += qryAlm.value("tpv_almamultitransstock.codalmacen") + sys.translate("-Act") + "/";

    _i.cRECOM[i] = c++;;
    cabecera += AQUtil.translate("scripts", "Rec.") + "/";

    _i.cREPONER[i] = c++;;
    cabecera += AQUtil.translate("scripts", "Envio") + "/";
    i++;
  }

  _i.tblTransstock_.setNumCols(c);

  _i.tblTransstock_.setColumnWidth(_i.cFAMILIA, 60);
  _i.tblTransstock_.setColumnWidth(_i.cARTICULO, 200);
  _i.tblTransstock_.setColumnWidth(_i.cREFERENCIA, 80);
  _i.tblTransstock_.setColumnWidth(_i.cORIGEN, 60);
  _i.tblTransstock_.setColumnWidth(_i.cSTOCKORIGEN, 60);

  _i.tblTransstock_.setColumnReadOnly(_i.cFAMILIA, true);
  _i.tblTransstock_.setColumnReadOnly(_i.cARTICULO, true);
  _i.tblTransstock_.setColumnReadOnly(_i.cREFERENCIA, true);
  _i.tblTransstock_.setColumnReadOnly(_i.cORIGEN, true);
  _i.tblTransstock_.setColumnReadOnly(_i.cSTOCKORIGEN, true);

  _i.tblTransstock_.hideColumn(_i.cSTOCKORIGEN);

  for (var i = 0; i < _i.cDESTINO.length; i++) {
    _i.tblTransstock_.setColumnWidth(_i.cDESTINO[i]["col"], 60);
    _i.tblTransstock_.setColumnWidth(_i.cSTOCKDESTINO[i], 60);
    _i.tblTransstock_.setColumnWidth(_i.cRECOM[i], 40);
    _i.tblTransstock_.setColumnWidth(_i.cREPONER[i], 40);

    _i.tblTransstock_.hideColumn(_i.cRECOM[i]);

    _i.tblTransstock_.setColumnReadOnly(_i.cDESTINO[i]["col"], true);
    _i.tblTransstock_.setColumnReadOnly(_i.cSTOCKDESTINO[i], true);
    _i.tblTransstock_.setColumnReadOnly(_i.cRECOM[i], true);

    _i.tblTransstock_.hideColumn(_i.cSTOCKDESTINO[i]);
  }

  _i.tblTransstock_.setColumnLabels("/", cabecera);
}

function oficial_cargarTablaTransferencias()
{
  var _i = this.iface;
  var cursor = this.cursor();

  _i.tblTransstock_.clear();

  var codMultiTrans = cursor.valueBuffer("codmultitransstock");
  if (!codMultiTrans || codMultiTrans == "") {
    return;
  }
  var q = new FLSqlQuery;
  q.setSelect("a.referencia, a.descripcion, a.codfamilia, l.codalmadestino, l.cantidad");
  q.setFrom("tpv_artmultitransstock m INNER JOIN articulos a ON m.referencia = a.referencia LEFT OUTER JOIN tpv_lineasmultitransstock l ON (m.referencia = l.referencia AND m.codmultitransstock = l.codmultitransstock)");
  q.setWhere("m.codmultitransstock = '" + codMultiTrans + "' order by a.codfamilia,a.descripcion");
  q.setForwardOnly(true);
  debug(q.sql());
  if (!q.exec()) {
    return;
  }
  _i.idArticulos_ = new Object;
  _i.cargaLineas(q, "TAB");

  _i.habilitaPestanaSets();
  _i.tblTransstock_.repaintContents();

}

function oficial_tbnLimpiarTabla_clicked()
{
  var _i = this.iface;
  _i.limpiarTabla()
}

function oficial_limpiarTabla()
{
  var _i = this.iface;
  var nF = _i.tblTransstock_.numRows();
  var c, v;
  AQUtil.createProgressDialog(sys.translate("Limpiando tabla..."), nF);
  for (var f = 0; f < nF; f++) {
    AQUtil.setProgress(f);
    for (var i = 0; i < _i.cREPONER.length; i++) {
      c = _i.cREPONER[i];
      v = _i.tblTransstock_.text(f, c);
      if (v && !isNaN(v)) {
        _i.tblTransstock_.setText(f, c, "");
        _i.actualizarTransferencias(f, c);
      }
    }
  }
  AQUtil.destroyProgressDialog();
  return true;
}

function oficial_cargarTablaReposiciones()
{
  var _i = this.iface;
  var cursor = this.cursor();

  //   _i.tblTransstock_.clear();
  var codMultiTrans = cursor.valueBuffer("codmultitransstock");
  if (!codMultiTrans || codMultiTrans == "") {
    return;
  }
  var codAlmaOrigen = cursor.valueBuffer("codalmaorigen");
  if (!codAlmaOrigen || codAlmaOrigen == "") {
    return;
  }
  var lA = _i.listaAlmacenes();
  if (lA == "") {
    return;
  }
  var wStockPos = "";
  if (cursor.valueBuffer("solostockpos")) {
    wStockPos = " AND s.disponible > 0";
  }
  var wFechas = "";
  var desde = cursor.valueBuffer("fdesderecom");
  if (desde) {
    wFechas += " AND c.fecha >= '" + desde + "'";
  }
  var hasta = cursor.valueBuffer("fhastarecom");
  if (desde) {
    wFechas += " AND c.fecha <= '" + hasta + "'";
  }
  var q = new FLSqlQuery;
  q.setSelect("a.referencia,a.descripcion,a.codfamilia, c.codalmacen, SUM(lc.cantidad)");
  q.setFrom("tpv_comandas c INNER JOIN tpv_lineascomanda lc ON c.idtpv_comanda = lc.idtpv_comanda INNER JOIN articulos a ON lc.referencia = a.referencia INNER JOIN stocks s ON (a.referencia = s.referencia AND s.codalmacen = '" + codAlmaOrigen + "')");
  q.setWhere("c.codalmacen IN (" + lA + ") " + wFechas + wStockPos + " GROUP BY a.referencia,a.descripcion,a.codfamilia, c.codalmacen HAVING SUM(lc.cantidad) > 0 ORDER BY a.codfamilia, a.descripcion, c.codalmacen");
  q.setForwardOnly(true);
  debug(q.sql());
  if (!q.exec()) {
    return;
  }
  if (!_i.idArticulos_) {
    _i.idArticulos_ = new Object;
  }
  _i.cargaLineas(q, "REP");

  _i.habilitaPestanaSets();
  _i.tblTransstock_.repaintContents();

}

function oficial_cargaLineas(q, tipoConsulta)
{
  var _i = this.iface;
  var cursor = this.cursor();

  var f = _i.tblTransstock_.numRows();
  var filaCarga;
  AQUtil.createProgressDialog(AQUtil.translate("scripts", "Cargando tabla..."), q.size());
  var p = 0;
  var idArt;
  while (q.next()) {
    AQUtil.setProgress(p++);
    idArt = _i.idFila(q, tipoConsulta)
    if (!_i.existeReferencia(idArt)) {
      if (tipoConsulta == "REP") {
        if (q && q.select().startsWith("aa.barcode")) {
          if (!_i.incluirBarcode(q)) {
            AQUtil.destroyProgressDialog();
            return false;
          }
        } else {
          if (!_i.incluirArticulo("referencia = '" + q.value(0) + "'", true)) {
            AQUtil.destroyProgressDialog();
            return false;
          }
        }
      }
      if (!_i.creaFila(f, q, tipoConsulta)) {
        AQUtil.destroyProgressDialog();
        return false;
      }
      _i.idArticulos_[idArt] = f;
      filaCarga = f;
      f++;
    } else {
      filaCarga = _i.idArticulos_[idArt];
    }
    if (!_i.datosFila(filaCarga, q, tipoConsulta)) {
      AQUtil.destroyProgressDialog();
      return false;
    }
  }
  AQUtil.destroyProgressDialog();
  return true;
}

function oficial_idFila(q, tipoConsulta)
{
  return q.value(0);
}

function oficial_creaFila(f, q, tipoConsulta)
{
  var _i = this.iface;
  _i.tblTransstock_.insertRows(f, 1);

  var cursor = this.cursor();

  var codMultiTrans = cursor.valueBuffer("codmultitransstock");
  if (!codMultiTrans || codMultiTrans == "") {
    return false;
  }
  var codAlmOrigen = cursor.valueBuffer("codalmaorigen");
  if (!codAlmOrigen) {
    return false;
  }
  var oArticulo = _i.objetoArticulo(q)

                  //   var valorRecomendado = cursor.valueBuffer("valorrecomendado");
                  //  var stockDestino;

  if (!_i.datosArticuloFila(f, q, tipoConsulta)) {
    return false;
  }

  var stockOrigen = _i.stockArticulo(codAlmOrigen, oArticulo);
  //  var reponerLinea, canRecom;
  _i.tblTransstock_.setText(f, _i.cSTOCKORIGEN, stockOrigen);

  var codAlmacen = q.value("c.codalmacen");
  var canRep;
  //  if (codAlmacen) {
  //    var iAlma = 0
  //    for (iAlma = 0; iAlma < _i.cDESTINO.length; iAlma++) {
  //      if (codAlmacen == _i.cDESTINO[iAlma]["codalmacen"]) {
  //        break;
  //      }
  //    }
  //    if (iAlma == _i.cDESTINO.length) {
  //      return;
  //    }
  //    reponerLinea = q.value("SUM(lc.cantidad)");
  //
  //    stockDestino = _i.stockArticulo(codAlmacen, oArticulo);
  //    _i.tblTransstock_.setText(f, _i.cSTOCKDESTINO[iAlma], stockDestino);
  //
  //    stockDestino = stockDestino + reponerLinea;
  //
  //
  //    if (stockDestino > 0) {
  //      _i.tblTransstock_.setCellBackgroundColor(f, _i.cDESTINO[iAlma]["col"], _i.stockDestinoPositivo_);
  //    } else {
  //      _i.tblTransstock_.setCellBackgroundColor(f, _i.cDESTINO[iAlma]["col"], _i.stockDestinoNegativo_);
  //    }
  //
  //    _i.tblTransstock_.setText(f, _i.cDESTINO[iAlma]["col"], stockDestino);
  //
  //    _i.tblTransstock_.setCellBackgroundColor(f, _i.cREPONER[iAlma], _i.reposicionPositivo_);
  //
  //    _i.tblTransstock_.setText(f, _i.cREPONER[iAlma], reponerLinea);
  //    _i.tblTransstock_.setText(f, _i.cRECOM[iAlma], reponerLinea);
  //
  //    for (var i = 0; i < _i.cDESTINO.length; i++) {
  //      canRep = parseFloat(_i.tblTransstock_.text(f, _i.cREPONER[i]));
  //      canRep = isNaN(canRep) ? 0 : canRep;
  //      stockOrigen = stockOrigen - canRep;
  //    }
  //  } else {
  for (var i = 0; i < _i.cDESTINO.length; i++) {
    codAlmaDestino = _i.cDESTINO[i]["codalmacen"];
    if (!codAlmaDestino) {
      return;
    }
    //      reponerLinea = _i.obtenerCantidadReponer(codMultiTrans, oArticulo, codAlmaDestino);

    stockDestino = _i.stockArticulo(codAlmaDestino, oArticulo);
    _i.tblTransstock_.setText(f, _i.cSTOCKDESTINO[i], stockDestino);

    //      stockDestino = stockDestino + reponerLinea;
    //      stockOrigen = stockOrigen - reponerLinea;
    //
    if (stockDestino > 0) {
      _i.tblTransstock_.setCellBackgroundColor(f, _i.cDESTINO[i]["col"], _i.stockDestinoPositivo_);
    } else {
      _i.tblTransstock_.setCellBackgroundColor(f, _i.cDESTINO[i]["col"], _i.stockDestinoNegativo_);
    }
    //
    _i.tblTransstock_.setText(f, _i.cDESTINO[i]["col"], stockDestino);
    //
    //      if (reponerLinea > 0) {
    //        _i.tblTransstock_.setCellBackgroundColor(f, _i.cREPONER[i], _i.reposicionPositivo_);
    //      } else {
    //        _i.tblTransstock_.setCellBackgroundColor(f, _i.cDESTINO[i]["col"], _i.reposicionNegativo_);
    //      }
    //
    //      _i.tblTransstock_.setText(f, _i.cREPONER[i], reponerLinea);
    //
    //      canRecom = _i.obtenerCantidadRecom(oArticulo, codAlmaDestino);
    //      _i.tblTransstock_.setText(f, _i.cRECOM[i], canRecom);

  }

  //  }
  if (stockOrigen > 0) {
    _i.tblTransstock_.setCellBackgroundColor(f, _i.cORIGEN, _i.stockOrigenPositivo_);
  } else {
    _i.tblTransstock_.setCellBackgroundColor(f, _i.cORIGEN, _i.stockOrigenNegativo_);
  }
  _i.tblTransstock_.setText(f, _i.cORIGEN, stockOrigen);
  return true;
}

function oficial_datosArticuloFila(f, q, tipoConsulta)
{
  var _i = this.iface;
  _i.tblTransstock_.setText(f, _i.cFAMILIA, q.value("a.codfamilia"));
  _i.tblTransstock_.setText(f, _i.cARTICULO, q.value("a.descripcion"));
  _i.tblTransstock_.setText(f, _i.cREFERENCIA, q.value("a.referencia"));
  return true;
}

function oficial_objetoArticulo(q)
{
  var oArticulo = [];
  oArticulo["referencia"] = q.value("a.referencia");
  return oArticulo;
}

function oficial_stockArticulo(codAlmOrigen, oArticulo)
{
  var stock = AQUtil.sqlSelect("stocks", "disponible", "codalmacen = '" + codAlmOrigen + "' AND referencia = '" + oArticulo.referencia + "'");
  stock = stock ? stock : 0;
  return stock;
}

function oficial_datosFila(f, q, tipoConsulta)
{
  var _i = this.iface;
  var cursor = this.cursor();

  var codMultiTrans = cursor.valueBuffer("codmultitransstock");
  if (!codMultiTrans || codMultiTrans == "") {
    return;
  }
  var codAlmOrigen = cursor.valueBuffer("codalmaorigen");
  if (!codAlmOrigen) {
    return;
  }
  var oArticulo = _i.objetoArticulo(q)

                  var stockDestino, stockOrigen;

  if (!_i.datosArticuloFila(f, q, tipoConsulta)) {
    return false;
  }

  var cAlmacen, cCantidad;
  switch (tipoConsulta) {
    case "TAB": {
      cAlmacen = "l.codalmadestino";
      cCantidad = "l.cantidad";
      break;
    }
    case "REP": {
      cAlmacen = "c.codalmacen";
      cCantidad = "SUM(lc.cantidad)";
      break;
    }
    default: {
      return false;
    }
  }
  var codAlmacen = q.value(cAlmacen);
  if (!codAlmacen || codAlmacen == "") {
    return true;
  }
  var canActual;
  var cantidad = parseFloat(q.value(cCantidad));
  cantidad = isNaN(cantidad) ? 0 : cantidad;

  var iAlma = 0;
  for (iAlma = 0; iAlma < _i.cDESTINO.length; iAlma++) {
    if (codAlmacen == _i.cDESTINO[iAlma]["codalmacen"]) {
      break;
    }
  }
  if (iAlma == _i.cDESTINO.length) {
    return;
  }

  stockOrigen = parseFloat(_i.tblTransstock_.text(f, _i.cSTOCKORIGEN));
  stockOrigen = isNaN(stockOrigen) ? 0 : stockOrigen;

  stockDestino = parseFloat(_i.tblTransstock_.text(f, _i.cSTOCKDESTINO[iAlma]));
  stockDestino = isNaN(stockDestino) ? 0 : stockDestino;

  stockDestino = stockDestino + cantidad;


  if (stockDestino > 0) {
    _i.tblTransstock_.setCellBackgroundColor(f, _i.cDESTINO[iAlma]["col"], _i.stockDestinoPositivo_);
  } else {
    _i.tblTransstock_.setCellBackgroundColor(f, _i.cDESTINO[iAlma]["col"], _i.stockDestinoNegativo_);
  }

  _i.tblTransstock_.setText(f, _i.cDESTINO[iAlma]["col"], stockDestino);

  _i.tblTransstock_.setCellBackgroundColor(f, _i.cREPONER[iAlma], _i.reposicionPositivo_);


  canActual = parseFloat(_i.tblTransstock_.text(f, _i.cREPONER[iAlma]));
  canActual = isNaN(canActual) ? 0 : canActual;
  if (canActual != cantidad) {
    _i.tblTransstock_.setText(f, _i.cREPONER[iAlma], cantidad);
    if (tipoConsulta != "TAB") {
      _i.actualizarTransferencias(f, _i.cREPONER[iAlma]);
    }
  }
  //_i.tblTransstock_.setText(f, _i.cRECOM[iAlma], reponerLinea);

  var canRep;
  for (var i = 0; i < _i.cDESTINO.length; i++) {
    canRep = parseFloat(_i.tblTransstock_.text(f, _i.cREPONER[i]));
    canRep = isNaN(canRep) ? 0 : canRep;
    stockOrigen = stockOrigen - canRep;
  }

  if (stockOrigen > 0) {
    _i.tblTransstock_.setCellBackgroundColor(f, _i.cORIGEN, _i.stockOrigenPositivo_);
  } else {
    _i.tblTransstock_.setCellBackgroundColor(f, _i.cORIGEN, _i.stockOrigenNegativo_);
  }
  _i.tblTransstock_.setText(f, _i.cORIGEN, stockOrigen);

  return true;
}

// function oficial_datosFila(f, q)
// {
//  var _i = this.iface;
//  var cursor = this.cursor();
//
//   var codMultiTrans = cursor.valueBuffer("codmultitransstock");
//   if (!codMultiTrans || codMultiTrans == "") {
//     return;
//  }
//   var codAlmOrigen = cursor.valueBuffer("codalmaorigen");
//   if (!codAlmOrigen) {
//     return;
//  }
//  var oArticulo = _i.objetoArticulo(q)
//
//   var valorRecomendado = cursor.valueBuffer("valorrecomendado");
//  var stockDestino;
//
//  if (!_i.datosArticuloFila(f, q)) {
//    return false;
//  }
//
//   var stockOrigen = _i.stockArticulo(codAlmOrigen, oArticulo);
//  var reponerLinea, canRecom;
//  _i.tblTransstock_.setText(f, _i.cSTOCKORIGEN, stockOrigen);
//
//  var codAlmacen = q.value("c.codalmacen");
//  var canRep;
//  if (codAlmacen) {
//    var iAlma = 0
//    for (iAlma = 0; iAlma < _i.cDESTINO.length; iAlma++) {
//      if (codAlmacen == _i.cDESTINO[iAlma]["codalmacen"]) {
//        break;
//      }
//    }
//    if (iAlma == _i.cDESTINO.length) {
//      return;
//    }
//    reponerLinea = q.value("SUM(lc.cantidad)");
//
//    stockDestino = _i.stockArticulo(codAlmacen, oArticulo);
//    _i.tblTransstock_.setText(f, _i.cSTOCKDESTINO[iAlma], stockDestino);
//
//    stockDestino = stockDestino + reponerLinea;
//
//
//    if (stockDestino > 0) {
//      _i.tblTransstock_.setCellBackgroundColor(f, _i.cDESTINO[iAlma]["col"], _i.stockDestinoPositivo_);
//    } else {
//      _i.tblTransstock_.setCellBackgroundColor(f, _i.cDESTINO[iAlma]["col"], _i.stockDestinoNegativo_);
//    }
//
//    _i.tblTransstock_.setText(f, _i.cDESTINO[iAlma]["col"], stockDestino);
//
//    _i.tblTransstock_.setCellBackgroundColor(f, _i.cREPONER[iAlma], _i.reposicionPositivo_);
//
//    _i.tblTransstock_.setText(f, _i.cREPONER[iAlma], reponerLinea);
//    _i.tblTransstock_.setText(f, _i.cRECOM[iAlma], reponerLinea);
//
//    for (var i = 0; i < _i.cDESTINO.length; i++) {
//      canRep = parseFloat(_i.tblTransstock_.text(f, _i.cREPONER[i]));
//      canRep = isNaN(canRep) ? 0 : canRep;
//      stockOrigen = stockOrigen - canRep;
//    }
//  } else {
//    for (var i = 0; i < _i.cDESTINO.length; i++) {
//      codAlmaDestino = _i.cDESTINO[i]["codalmacen"];
//      if (!codAlmaDestino) {
//        return;
//      }
//      reponerLinea = _i.obtenerCantidadReponer(codMultiTrans, oArticulo, codAlmaDestino);
//
//      stockDestino = _i.stockArticulo(codAlmaDestino, oArticulo);
//      _i.tblTransstock_.setText(f, _i.cSTOCKDESTINO[i], stockDestino);
//
//      stockDestino = stockDestino + reponerLinea;
//      stockOrigen = stockOrigen - reponerLinea;
//
//      if (stockDestino > 0) {
//        _i.tblTransstock_.setCellBackgroundColor(f, _i.cDESTINO[i]["col"], _i.stockDestinoPositivo_);
//      } else {
//        _i.tblTransstock_.setCellBackgroundColor(f, _i.cDESTINO[i]["col"], _i.stockDestinoNegativo_);
//      }
//
//      _i.tblTransstock_.setText(f, _i.cDESTINO[i]["col"], stockDestino);
//
//      if (reponerLinea > 0) {
//        _i.tblTransstock_.setCellBackgroundColor(f, _i.cREPONER[i], _i.reposicionPositivo_);
//      } else {
//        _i.tblTransstock_.setCellBackgroundColor(f, _i.cDESTINO[i]["col"], _i.reposicionNegativo_);
//      }
//
//      _i.tblTransstock_.setText(f, _i.cREPONER[i], reponerLinea);
//
//      canRecom = _i.obtenerCantidadRecom(oArticulo, codAlmaDestino);
//      _i.tblTransstock_.setText(f, _i.cRECOM[i], canRecom);
//  //    _i.actualizarTransferencias(f, _i.cREPONER[i]);
//
//    }
//
//  }
//  if (stockOrigen > 0) {
//    _i.tblTransstock_.setCellBackgroundColor(f, _i.cORIGEN, _i.stockOrigenPositivo_);
//  } else {
//    _i.tblTransstock_.setCellBackgroundColor(f, _i.cORIGEN, _i.stockOrigenNegativo_);
//  }
//  _i.tblTransstock_.setText(f, _i.cORIGEN, stockOrigen);
//  return true;
// }

function oficial_actualizarTransferencias(f, c)
{
  var _i = this.iface;

  var referencia = _i.tblTransstock_.text(f, _i.cREFERENCIA);
  if (!referencia)
    return;

  var oArticulo = [];
  oArticulo["referencia"] = referencia;

  var codAlmOrigen = this.cursor().valueBuffer("codalmaorigen");
  if (!codAlmOrigen)
    return;

  var stockOrigen = parseFloat(_i.tblTransstock_.text(f, _i.cSTOCKORIGEN));
  stockOrigen = isNaN(stockOrigen) ? 0 : stockOrigen;

  var totalDestino = 0;
  var reponer = 0, stockDestino;
  for (var i = 0; i < _i.cDESTINO.length; i++) {
    codAlmDestino = _i.cDESTINO[i]["codalmacen"];
    if (!codAlmDestino) {
      return;
    }

    stockDestino = _i.tblTransstock_.text(f, _i.cSTOCKDESTINO[i]);
    stockDestino = stockDestino ? stockDestino : 0;

    reponer = parseFloat(_i.tblTransstock_.text(f, _i.cREPONER[i]));
    reponer = isNaN(reponer) ? 0 : reponer
              totalDestino += reponer;

    if (reponer > 0) {
      _i.tblTransstock_.setCellBackgroundColor(f, _i.cREPONER[i], _i.reposicionPositivo_);
    } else {
      _i.tblTransstock_.setCellBackgroundColor(f, _i.cREPONER[i], _i.reposicionNegativo_);
    }

    stockDestino = parseFloat(stockDestino) + parseFloat(reponer);

    _i.tblTransstock_.setText(f, _i.cDESTINO[i]["col"], stockDestino);
    if (stockDestino > 0) {
      _i.tblTransstock_.setCellBackgroundColor(f, _i.cDESTINO[i]["col"], _i.stockDestinoPositivo_);
    } else {
      _i.tblTransstock_.setCellBackgroundColor(f, _i.cDESTINO[i]["col"], _i.stockDestinoNegativo_);
    }

    if (_i.cREPONER[i] == c) {
      var cantidad = parseFloat(_i.tblTransstock_.text(f, c));
      cantidad = isNaN(cantidad) ? 0 : cantidad
                 codAlmDestLinea = _i.cDESTINO[i]["codalmacen"];
      if (!_i.procesaLinea(oArticulo, codAlmOrigen, codAlmDestLinea, cantidad)) {
        return true;
      }
    }
  }

  stockOrigen -= parseFloat(totalDestino);

  if (stockOrigen > 0) {
    _i.tblTransstock_.setCellBackgroundColor(f, _i.cORIGEN, _i.stockOrigenPositivo_);
  } else {
    _i.tblTransstock_.setCellBackgroundColor(f, _i.cORIGEN, _i.stockOrigenNegativo_);
  }
  _i.tblTransstock_.setText(f, _i.cORIGEN, stockOrigen);
}

function oficial_prevalidaLinea()
{
  return true;
}

function oficial_borrarLinea(codMulti, oArticulo, codAlmaDestino)
{
  if (!AQSql.del("tpv_lineasmultitransstock", "codmultitransstock = '" + codMulti + "' AND referencia = '" + oArticulo.referencia + "' AND codalmadestino = '" + codAlmaDestino + "'")) {
    return false;
  }

  return true;
}

function oficial_obtenerLineaMultiTransStock(codMulti, oArticulo, codAlmaDestino)
{
  return AQUtil.sqlSelect("tpv_lineasmultitransstock", "idlinea", "codmultitransstock = '" + codMulti + "' AND referencia = '" + oArticulo.referencia + "' AND codalmadestino = '" + codAlmaDestino + "'");
}

function oficial_obtenerCantidadReponer(codMulti, oArticulo, codAlmaDestino)
{
  var cantidad = parseFloat(AQUtil.sqlSelect("tpv_lineasmultitransstock", "cantidad", "codmultitransstock = '" + codMulti + "' AND referencia = '" + oArticulo.referencia + "' AND codalmadestino = '" + codAlmaDestino + "'"));
  if (!cantidad)
    cantidad = 0;

  return cantidad;
}

function oficial_obtenerCantidadRecom(oArticulo, codAlmaDestino)
{
  var cursor = this.cursor();
  var fechaDesde = cursor.valueBuffer("fdesderecom");
  var fechaHasta = cursor.valueBuffer("fhastarecom");

  var cantidad = parseFloat(AQUtil.sqlSelect("tpv_lineascomanda lc INNER JOIN tpv_comandas c ON c.idtpv_comanda = lc.idtpv_comanda", "SUM(lc.cantidad)", "c.fecha BETWEEN '" + fechaDesde + "' AND '" + fechaHasta + "' AND c.codalmacen = '" + codAlmaDestino + "' AND lc.referencia = '" + oArticulo.referencia + "'", "tpv_comandas"));

  cantidad = isNaN(cantidad) ? 0 : cantidad;
  cantidad = cantidad < 0 ? 0 : cantidad;

  return cantidad;
}

function oficial_masDatosLineaMultiTransStock(curL, oArticulo)
{
  return true;
}

function oficial_masDatosMultiTransStock(curV, codAlmaOrigen, codAlmaDestino)
{
  return true;
}

function oficial_obtenerDescripcion(oArticulo)
{
  return AQUtil.sqlSelect("articulos", "descripcion", "referencia = '" + oArticulo.referencia + "'")
}

       function oficial_idViaje(curV)
{
  return AQUtil.nextCounter("idviajemultitrans", curV);
}

function oficial_procesaLinea(oArticulo, codAlmaOrigen, codAlmaDestino, cantidad)
{
  var _i = this.iface;
  var cursor = this.cursor();
  if (!_i.prevalidaLinea()) {
    return false;
  }

  var codMulti = cursor.valueBuffer("codmultitransstock");

  if (cantidad == 0) {
    _i.borrarLinea(codMulti, oArticulo, codAlmaDestino);
  } else {
    var idViaje = AQUtil.sqlSelect("tpv_viajesmultitransstock", "idviajemultitrans", "codmultitransstock = '" + codMulti + "' AND codalmaorigen = '" + codAlmaOrigen + "' AND codalmadestino = '" + codAlmaDestino + "'");
    if (!idViaje) {
      var curV = new FLSqlCursor("tpv_viajesmultitransstock");
      curV.setModeAccess(curV.Insert);
      curV.refreshBuffer();
      curV.setValueBuffer("idviajemultitrans", _i.idViaje(curV));
      curV.setValueBuffer("codmultitransstock", codMulti);
      curV.setValueBuffer("fecha", cursor.valueBuffer("fecha"));
      curV.setValueBuffer("codalmaorigen", codAlmaOrigen);
      curV.setValueBuffer("codalmadestino", codAlmaDestino);
      curV.setValueBuffer("ptesincroenvio", true);

      _i.masDatosMultiTransStock(curV, codAlmaOrigen, codAlmaDestino);

      if (!curV.commitBuffer()) {
        return false;
      }
      idViaje = curV.valueBuffer("idviajemultitrans");
    }
    var idLinea = _i.obtenerLineaMultiTransStock(codMulti, oArticulo, codAlmaDestino);

    if (idLinea) {
      if (!AQSql.update("tpv_lineasmultitransstock", ["cantidad", "cantpteenvio"], [cantidad, cantidad], "idlinea = " + idLinea)) {
        return false;
      }
      //       if (!AQUtil.sqlUpdate("tpv_lineasmultitransstock", "cantidad", cantidad, "idlinea = " + idLinea)) {
      //         return false;
      //       }
    } else {
      var curL = new FLSqlCursor("tpv_lineasmultitransstock");
      curL.setModeAccess(curL.Insert);
      curL.refreshBuffer();
      curL.setValueBuffer("codmultitransstock", cursor.valueBuffer("codmultitransstock"));
      curL.setValueBuffer("idviajemultitrans", idViaje);
      curL.setValueBuffer("codalmadestino", codAlmaDestino);
      curL.setValueBuffer("codalmaorigen", codAlmaOrigen);
      curL.setValueBuffer("referencia", oArticulo.referencia);
      var descripcion = _i.obtenerDescripcion(oArticulo);
      curL.setValueBuffer("descripcion", descripcion);
      curL.setValueBuffer("cantidad", cantidad);
      curL.setValueBuffer("cantenviada", 0);
      curL.setValueBuffer("cantrecibida", 0);
      curL.setValueBuffer("cantpteenvio", cantidad);
      curL.setValueBuffer("cantpterecepcion", 0);

      _i.masDatosLineaMultiTransStock(curL, oArticulo);

      if (!curL.commitBuffer()) {
        return false;
      }
    }
  }

  this.child("tdbViajes").refresh();
  this.child("tdbLineas").refresh();

  return true;
}

function oficial_existeReferencia(referencia)
{
  var _i = this.iface;
  return (referencia in _i.idArticulos_);
  //   var numRows = _i.tblTransstock_.numRows();
  //   if (numRows == 0)
  //     return false;
  //
  //   for (var f = 0; f < numRows; f++) {
  //     if (_i.tblTransstock_.text(f, _i.cREFERENCIA) == referencia)
  //       return true;
  //   }
  //
  //   return false;
}

function oficial_filtrarLineas()
{
  var _i = this.iface;
  var filtro = "";
  if (!this.child("chkFiltroLineas").checked) {
    var curViaje = this.child("tdbViajes").cursor();
    var codAlmaDestino = curViaje.valueBuffer("codalmadestino");
    if (codAlmaDestino) {
      filtro = "codalmadestino = '" + codAlmaDestino + "'";
    }
  }
  this.child("tdbLineas").setFilter(filtro);
  this.child("tdbLineas").refresh();
}

function oficial_eliminarArticulo()
{
  var _i = this.iface;
  var codMulti = this.cursor().valueBuffer("codmultitransstock");

  var referencia = this.child("tdbArticulos").cursor().valueBuffer("referencia");
  if (!referencia || referencia == "") {
    MessageBox.warning(AQUtil.translate("scripts", "No hay ningún registro seleccionado."), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton, "AbanQ");
    return;
  }

  var res = MessageBox.information(AQUtil.translate("scripts", "El registro activo y las líneas relacionadas serán borradas ¿Está seguro?."), MessageBox.Yes, MessageBox.No, MessageBox.NoButton);
  if (res != MessageBox.Yes)
    return;

  if (!AQUtil.sqlDelete("tpv_lineasmultitransstock", "codmultitransstock = '" + codMulti + "' AND referencia = '" + referencia + "'"))
    return;

  if (!AQUtil.sqlDelete("tpv_artmultitransstock", "codmultitransstock = '" + codMulti + "' AND referencia = '" + referencia + "'"))
    return;

  this.child("tdbArticulos").refresh();
  this.child("tdbLineas").refresh();
}

function oficial_eliminarAlmacen()
{
  var _i = this.iface;
  var codMulti = this.cursor().valueBuffer("codmultitransstock");

  var codAlmacen = this.child("tdbAlmacenes").cursor().valueBuffer("codalmacen");
  if (!codAlmacen || codAlmacen == "") {
    MessageBox.warning(AQUtil.translate("scripts", "No hay ningún registro seleccionado."), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return;
  }

  var res = MessageBox.information(AQUtil.translate("scripts", "El registro activo, los viajes y líneas relacionadas serán borradas ¿Está seguro?."), MessageBox.Yes, MessageBox.No, MessageBox.NoButton);
  if (res != MessageBox.Yes)
    return;

  var idViaje = AQUtil.sqlSelect("tpv_viajesmultitransstock", "idviajemultitrans", "codalmadestino = '" + codAlmacen + "' AND codmultitransstock = '" + codMulti + "'");
  if (!idViaje || idViaje == 0)
    return;

  if (!AQUtil.sqlDelete("tpv_lineasmultitransstock", "codmultitransstock = '" + codMulti + "' AND idviajemultitrans = '" + idViaje + "'"))
    return;

  if (!AQUtil.sqlDelete("tpv_viajesmultitransstock", "codmultitransstock = '" + codMulti + "' AND idviajemultitrans = '" + idViaje + "'"))
    return;

  if (!AQUtil.sqlDelete("tpv_almamultitransstock", "codmultitransstock = '" + codMulti + "' AND codalmacen = '" + codAlmacen + "'"))
    return;

  this.child("tdbAlmacenes").refresh();
  this.child("tdbViajes").refresh();
  this.child("tdbLineas").refresh();
}

function oficial_tbnCrearPedidos_clicked()
{
  var _i = this.iface;
  var cursor = this.cursor();
  var codMultitransstock = cursor.valueBuffer("codmultitransstock");
  // Contadores a usar de argumento en los mensajes de informacion.
  var numPedidosCli = 0;
  var numPedidosProv = 0;

  if (cursor.modeAccess() == cursor.Insert) {
    if (!this.child("tdbViajes").cursor().commitBufferCursorRelation()) {
      return false;
    }
  }
  this.child("tdbViajes").refresh();
  if (this.child("tdbViajes").cursor().size() == 0) {
    MessageBox.information(sys.translate("No hay pedidos que generar."), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton, "AbanQ");
    return;
  }

  var progress = 0; // Contador de la barra de progreso.
  var curViaje =  new FLSqlCursor("tpv_viajesmultitransstock");

  // Para sacar el tamaño de la barra de progreso.
  var tam = AQUtil.sqlSelect("tpv_viajesmultitransstock", "count(*)", "codmultitransstock = '" + cursor.valueBuffer("codmultitransstock") + "'");

  // Se crea la barra de progreso que tiene tamaño como lineas hay. Dependiendo del estado se crean o eliminan los pedidos.
  var numPedidosAct = parseFloat(AQUtil.sqlSelect("pedidoscli", "count(*)", "codmultitransstock = '" + cursor.valueBuffer("codmultitransstock") + "'")) + parseFloat(AQUtil.sqlSelect("pedidosprov", "count(*)", "codmultitransstock = '" + cursor.valueBuffer("codmultitransstock") + "'"));

  if (!numPedidosAct)
    numPedidosAct = 0;

  if (numPedidosAct == 0) {
    AQUtil.createProgressDialog(AQUtil.translate("scripts", "Creando pedidos..."), tam);
  } else { //Mensaje de confirmación de eliminación de pedidos.
    var res = MessageBox.warning(sys.translate("¡¡¡ATENCION!!!\n\nEstá a punto de eliminar TODOS los pedidos realizados\na través del formulario de transferencias de stock %1.\n\n                     ¿Desea continuar?").arg(cursor.valueBuffer("codmultitransstock")), MessageBox.Ok, MessageBox.Cancel, MessageBox.NoButton, "AbanQ");
    if (res != MessageBox.Ok) {
      return;
    }
    AQUtil.createProgressDialog(AQUtil.translate("scripts", "Eliminando pedidos..."), tam);
  }
  // Para saber los viajes asociados a este multipedido.
  curViaje.select("codmultitransstock = '" + cursor.valueBuffer("codmultitransstock") + "'");

  // cursor para controlar todo el proceso y si algo no funciona correctamente se hace un rollback de toda la operación.
  var curT = new FLSqlCursor("empresa");
  curT.transaction(false);

  // Estado "Pendiente": creo los pedidos.

  if (numPedidosAct == 0) {
    while (curViaje.next()) {
      curViaje.setModeAccess(curViaje.Browse);
      curViaje.refreshBuffer();
      progress++;
      AQUtil.setProgress(progress);

      try {
        if (!_i.creaPedidoCli(curViaje)) {
          curT.rollback();
          AQUtil.destroyProgressDialog();
          MessageBox.warning(sys.translate("Error al crear el pedido de cliente del viaje %1").arg(curViaje.valueBuffer("idviajemultitrans")), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton, "AbanQ");
          return;
        }
        numPedidosCli++;

        if (_i.creaPedidoProv(curViaje)) {
          numPedidosProv++;
        } else {
          curT.rollback();
          AQUtil.destroyProgressDialog();
          MessageBox.warning(sys.translate("Error al crear el pedido de proveedor del viaje %1").arg(curViaje.valueBuffer("idviajemultitrans")), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton, "AbanQ");
          return;
        }
      } catch (e) {
        curT.rollback();
        AQUtil.destroyProgressDialog();
        MessageBox.warning(sys.translate("Error al crear el pedido del viaje %1: ").arg(curViaje.valueBuffer("idviajemultitrans") + e), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton, "AbanQ");
        return;
      }
    }

    curT.commit();
    AQUtil.destroyProgressDialog();
    this.cursor().setValueBuffer("estado", "Aceptado");
    MessageBox.information(sys.translate("Se han creado %1 pedidos a proveedor\ny %2 pedidos a clientes.").arg(numPedidosProv).arg(numPedidosCli), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton, "AbanQ");
  }
  //Estado "Aceptado": elimino los pedidos.
  else {
    if (!_i.eliminaPedidoCli(codMultitransstock)) {
      curT.rollback();
      AQUtil.destroyProgressDialog();
      MessageBox.warning(sys.translate("No se han eliminado los pedidos al haber alguno servido."), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton, "AbanQ");
      return;
    }
    if (!_i.eliminaPedidoProv(codMultitransstock)) {
      curT.rollback();
      AQUtil.destroyProgressDialog();
      MessageBox.warning(sys.translate("No se han eliminado los pedidos al haber alguno servido."), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton, "AbanQ");
      return;
    }

    curT.commit();
    AQUtil.destroyProgressDialog();
    this.cursor().setValueBuffer("estado", "Pendiente");
    MessageBox.information(sys.translate("Se han eliminado TODOS los pedidos."), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton, "AbanQ");
  }


  this.child("tdbPedidosProv").refresh();
  this.child("tdbPedidosCli").refresh();
  //  if this.cursor().valueBuffer("estado") == "Pendiente"){
  //
  // //     AQUtil.sqlUpdate("multipedidos", "procesado", true, "idmulti = " + cursor.valueBuffer("idmulti"));
  //  }
  //  else{
  //    this
  // //     AQUtil.sqlUpdate("multipedidos", "procesado", false, "idmulti = " + cursor.valueBuffer("idmulti"));
  //  }
  _i.habilitarPorEstado();
  return true;
}

function oficial_eliminaPedidoProv(codMultitransstock)
{

  var servido = AQUtil.sqlSelect("pedidosprov", "servido", "codmultitransstock = '" + codMultitransstock + "' AND servido <> 'No'");
  if (!servido) {
    if (!AQUtil.sqlDelete("pedidosprov", "codmultitransstock = '" + codMultitransstock + "'")) {
      return false;
    }
  } else {
    if (!AQUtil.sqlSelect("pedidosprov", "idpedido", "codmultitransstock = '" + codMultitransstock + "'"))
      return true;
    return false;
  }
  return true;
}

function oficial_eliminaPedidoCli(codMultitransstock)
{
  var servido = AQUtil.sqlSelect("pedidoscli", "servido", "codmultitransstock = '" + codMultitransstock + "' AND servido <> 'No'");

  if (!servido) {
    if (!AQUtil.sqlDelete("pedidoscli", "codmultitransstock = '" + codMultitransstock + "'")) {
      return false;
    }
  } else {
    if (!AQUtil.sqlSelect("pedidoscli", "idpedido", "codmultitransstock = '" + codMultitransstock + "'")) {
      return true;
    }

    return false;
  }

  return true;
}

function oficial_datosPedidoProv(curPedidoProv, curViaje)
{
  var _i = this.iface;
  var cursor = this.cursor();
  var hoy = new Date();
  var fecha = hoy.getDate() + "-" + hoy.getMonth() + "-" + hoy.getYear();

  var almacenOrigen = curViaje.valueBuffer("codalmaorigen");
  var codAlmaDestino = curViaje.valueBuffer("codalmadestino");
  if (!almacenOrigen || almacenOrigen  == "") {
    MessageBox.warning(sys.translate("No se ha encontrado el almacén de origen"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }

  var codEjercicio = _i.dameEjercicioAlmacen(codAlmaDestino, hoy);
  if (!codEjercicio) {
    MessageBox.warning(sys.translate("No se ha encontrado el ejercicio asociado al almacén %1").arg(codAlmaDestino), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton, "AbanQ");
    return false;
  }

  var codProveedor = _i.dameProveedorAlmacen(almacenOrigen);
  if (!codProveedor || codProveedor == "") {
    MessageBox.warning(sys.translate("No se ha encontrado el proveedor correspondiente al almacén de origen"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton, "AbanQ");
    return false;
  }

  //  var idEmpresa = AQUtil.sqlSelect("tpv_tiendas","idempresa","codtienda = '" + codTienda + "'");
  //  if(!idEmpresa || idEmpresa == 0) {
  //    MessageBox.warning(sys.translate("No se ha encontrado la empresa correspondiente al almacén de origen"), MessageBox.Ok, MessageBox.NoButton);
  //    return false;
  //  }

  var codDivisa = AQUtil.sqlSelect("proveedores", "coddivisa", "codproveedor = '" + codProveedor + "'");
  //  var codEjercicio = AQUtil.sqlSelect("empresa", "codejercicio", "id = " + idEmpresa);
  var codPago = AQUtil.sqlSelect("proveedores", "codpago", "codproveedor = '" + codProveedor + "'");

  curPedidoProv.setValueBuffer("codmultitransstock", cursor.valueBuffer("codmultitransstock"));
  curPedidoProv.setValueBuffer("idviajemultitrans", curViaje.valueBuffer("idviajemultitrans"));
  curPedidoProv.setValueBuffer("fecha", hoy);
  curPedidoProv.setValueBuffer("fechaentrada", hoy);
  curPedidoProv.setValueBuffer("nombre", AQUtil.sqlSelect("proveedores", "nombre", "codproveedor = '" + codProveedor + "'"));
  curPedidoProv.setValueBuffer("cifnif", AQUtil.sqlSelect("proveedores", "cifnif", "codproveedor = '" + codProveedor + "'"));
  curPedidoProv.setValueBuffer("codproveedor", codProveedor);
  curPedidoProv.setValueBuffer("coddivisa", codDivisa);
  curPedidoProv.setValueBuffer("codalmacen", codAlmaDestino);
  curPedidoProv.setValueBuffer("tasaconv", AQUtil.sqlSelect("divisas", "tasaconv", "coddivisa = '" + codDivisa + "'"));
  curPedidoProv.setValueBuffer("codejercicio", codEjercicio);
  curPedidoProv.setValueBuffer("codserie", AQUtil.sqlSelect("secuenciasejercicios", "codserie", "codejercicio = '" + codEjercicio + "' ORDER BY codserie"));
  curPedidoProv.setValueBuffer("codpago", codPago);

  return true;
}

function oficial_dameProveedorAlmacen(codAlmacen)
{
  var _i = this.iface;
  var codTienda = AQUtil.sqlSelect("almacenes", "codtienda", "codalmacen = '" + codAlmacen + "'");
  var codProveedor = false;
  if (codTienda && codTienda != "") {
    codProveedor = AQUtil.sqlSelect("tpv_tiendas", "codproveedor", "codtienda = '" + codTienda + "'");
  } else {
    if (_i.hayCampoEmpresa_) {
      var idEmpresa = AQUtil.sqlSelect("almacenes", "idempresa", "codalmacen = '" + codAlmacen + "'");
      codProveedor = AQUtil.sqlSelect("empresa", "codproveedor", "idempresa = " + idEmpresa);
    } else {
      codProveedor = flfactppal.iface.pub_valorDefectoEmpresa("codproveedoremp");
    }
  }

  if (!codProveedor || codProveedor == "") {
    MessageBox.warning(sys.translate("No se ha encontrado el proveedor correspondiente al almacén %1").arg(codAlmacen), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  return codProveedor;
}

function oficial_creaPedidoProv(curViaje)
{
  var _i = this.iface;
  var cursor = this.cursor();

  var curPedidoProv =  new FLSqlCursor("pedidosprov");
  curPedidoProv.setModeAccess(curPedidoProv.Insert);
  curPedidoProv.refreshBuffer();

  if (!_i.datosPedidoProv(curPedidoProv, curViaje)) {
    return false;
  }

  if (!curPedidoProv.commitBuffer()) {
    return false;
  }
  var idPedido = curPedidoProv.valueBuffer("idpedido");

  var curLinea =  new FLSqlCursor("tpv_lineasmultitransstock");
  // Saco las lineas que están en el mismo viaje.
  curLinea.select("codmultitransstock = '" + cursor.valueBuffer("codmultitransstock") + "' AND idviajemultitrans = '" + curViaje.valueBuffer("idviajemultitrans") + "'");

  // Por cada linea de lineasmultipedido del mismo viaje que hay hago un registro en lineaspedidosprov.
  while (curLinea.next()) {
    if (!_i.creaLinea("proveedor", idPedido, curLinea)) {
      return false;
    }
  }

  curPedidoProv.select("idpedido = " + idPedido);
  if (!curPedidoProv.first()) {
    return false;
  }
  curPedidoProv.setModeAccess(curPedidoProv.Edit);
  curPedidoProv.refreshBuffer();
  _i.creaTotal("proveedor", curPedidoProv);

  if (!curPedidoProv.commitBuffer()) {
    MessageBox.warning(sys.translate("Problema al calcular el total del pedido %1.").arg(curViaje.valueBuffer("idviajemulti")), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  return true;
}

function oficial_datosLineaProv(idPedido, curLinea, curLineaProv)
{
  curLineaProv.setValueBuffer("idpedido", idPedido);
  /// Debe ir antes que el cálculo de precio para tener en cuenta si es o no una línea de multitransferencia
  curLineaProv.setValueBuffer("idlineamultitc", curLinea.valueBuffer("idlinea"));
  curLineaProv.setValueBuffer("referencia", curLinea.valueBuffer("referencia"));
  curLineaProv.setValueBuffer("descripcion", curLinea.valueBuffer("descripcion"));
  curLineaProv.setValueBuffer("pvpunitario", formRecordlineaspedidosprov.iface.pub_commonCalculateField("pvpunitario", curLineaProv));
  curLineaProv.setValueBuffer("cantidad", curLinea.valueBuffer("cantidad"));
  curLineaProv.setValueBuffer("pvpsindto", formRecordlineaspedidosprov.iface.pub_commonCalculateField("pvpsindto", curLineaProv));
  curLineaProv.setValueBuffer("dtolineal", 0);
  curLineaProv.setValueBuffer("codimpuesto", formRecordlineaspedidosprov.iface.pub_commonCalculateField("codimpuesto", curLineaProv));
  curLineaProv.setValueBuffer("iva", formRecordlineaspedidosprov.iface.pub_commonCalculateField("iva", curLineaProv));
  curLineaProv.setValueBuffer("recargo", formRecordlineaspedidosprov.iface.pub_commonCalculateField("recargo", curLineaProv));
  curLineaProv.setValueBuffer("dtopor", formRecordlineaspedidosprov.iface.pub_commonCalculateField("dtopor", curLineaProv));
  curLineaProv.setValueBuffer("pvptotal", formRecordlineaspedidosprov.iface.pub_commonCalculateField("pvptotal", curLineaProv));

  return true;
}

function oficial_datosLineaCli(idPedido, curLinea, curLineaCli)
{
  curLineaCli.setValueBuffer("idpedido", idPedido);
  /// Debe ir antes que el cálculo de precio para tener en cuenta si es o no una línea de multitransferencia
  curLineaCli.setValueBuffer("idlineamultitc", curLinea.valueBuffer("idlinea"));
  curLineaCli.setValueBuffer("referencia", curLinea.valueBuffer("referencia"));
  curLineaCli.setValueBuffer("descripcion", curLinea.valueBuffer("descripcion"));
  curLineaCli.setValueBuffer("pvpunitario", formRecordlineaspedidoscli.iface.pub_commonCalculateField("pvpunitario", curLineaCli));
  curLineaCli.setValueBuffer("cantidad", curLinea.valueBuffer("cantidad"));
  curLineaCli.setValueBuffer("pvpsindto", formRecordlineaspedidoscli.iface.pub_commonCalculateField("pvpsindto", curLineaCli));
  curLineaCli.setValueBuffer("dtolineal", 0);
  curLineaCli.setValueBuffer("codimpuesto", formRecordlineaspedidoscli.iface.pub_commonCalculateField("codimpuesto", curLineaCli));
  curLineaCli.setValueBuffer("iva", formRecordlineaspedidoscli.iface.pub_commonCalculateField("iva", curLineaCli));
  curLineaCli.setValueBuffer("recargo", formRecordlineaspedidoscli.iface.pub_commonCalculateField("recargo", curLineaCli));
  curLineaCli.setValueBuffer("dtopor", formRecordlineaspedidoscli.iface.pub_commonCalculateField("dtopor", curLineaCli));
  curLineaCli.setValueBuffer("pvptotal", formRecordlineaspedidoscli.iface.pub_commonCalculateField("pvptotal", curLineaCli));

  return true;
}

function oficial_creaLinea(fN, idPedido, curLinea)
{
  var _i = this.iface;
  var cursor = this.cursor();

  switch (fN) {
    case "proveedor": {
      var curLineaProv = new FLSqlCursor("lineaspedidosprov");
      curLineaProv.setModeAccess(curLineaProv.Insert);
      curLineaProv.refreshBuffer();
      if (!_i.datosLineaProv(idPedido, curLinea, curLineaProv))
        return false;
      if (!curLineaProv.commitBuffer()) {
        return false;
      }
      break;
    }
    case "cliente": {
      var curLineaCli = new FLSqlCursor("lineaspedidoscli");
      curLineaCli.setModeAccess(curLineaCli.Insert);
      curLineaCli.refreshBuffer();
      if (!_i.datosLineaCli(idPedido, curLinea, curLineaCli))
        return false;
      if (!curLineaCli.commitBuffer()) {
        return false;
      }
      break;
    }
  }
  return true;
}

function oficial_dameEjercicioAlmacen(codAlmacen, fecha)
{
  var _i = this.iface;
  var codEjercicio;
  if (_i.hayCampoEmpresa_) {
    var idEmpresa = AQUtil.sqlSelect("almacenes", "idempresa", "codalmacen = '" + codAlmacen + "'");
    if (!idEmpresa) {
      MessageBox.warning(sys.translate("No se ha encontrado la empresa asociada al almacén %1").arg(codAlmacen), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton, "AbanQ");
      return false;
    }
    codEjercicio = AQUtil.sqlSelect("ejercicios", "codejercicio", "fechainicio <= '" + fecha + "' AND fechafin >= '" + fecha + "' AND idempresa = " + idEmpresa);
  } else {
    codEjercicio = AQUtil.sqlSelect("ejercicios", "codejercicio", "fechainicio <= '" + fecha + "' AND fechafin >= '" + fecha + "'");
  }
  return codEjercicio;
}


function oficial_datosPedidoCli(curPedidoCli, curViaje)
{
  var _i = this.iface;
  var cursor = this.cursor();
  var hoy = new Date();
  var fecha = hoy.getDate() + "-" + hoy.getMonth() + "-" + hoy.getYear();

  var almacenDestino = curViaje.valueBuffer("codalmadestino");
  var codAlmaOrigen = curViaje.valueBuffer("codalmaorigen");
  if (!almacenDestino || almacenDestino == "") {
    MessageBox.warning(sys.translate("No se ha encontrado el almacén de destino"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton, "AbanQ");
    return false;
  }

  var codEjercicio = _i.dameEjercicioAlmacen(codAlmaOrigen, hoy);
  if (!codEjercicio) {
    MessageBox.warning(sys.translate("No se ha encontrado el ejercicio asociado al almacén %1").arg(codAlmaOrigen), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton, "AbanQ");
    return false;
  }

  var codTienda = AQUtil.sqlSelect("almacenes", "codtienda", "codalmacen = '" + almacenDestino + "'");
  if (!codTienda || codTienda == "") {
    MessageBox.warning(sys.translate("No se ha encontrado la tienda de destino"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }

  var codCliente = AQUtil.sqlSelect("tpv_tiendas", "codcliente", "codtienda = '" + codTienda + "'");
  if (!codCliente || codCliente == "") {
    MessageBox.warning(sys.translate("No se ha encontrado el cliente correspondiente a la tienda de destino"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }

  //  var idEmpresa = AQUtil.sqlSelect("tpv_tiendas","idempresa","codtienda = '" + codTienda + "'");
  //  if(!idEmpresa || idEmpresa == 0) {
  //    MessageBox.warning(sys.translate("No se ha encontrado la empresa correspondiente a la tienda de destino"), MessageBox.Ok, MessageBox.NoButton);
  //    return false;
  //  }

  var codDivisa = AQUtil.sqlSelect("clientes", "coddivisa", "codcliente = '" + codCliente + "'");
  //  var codEjercicio = AQUtil.sqlSelect("empresa", "codejercicio", "id = " + idEmpresa);

  curPedidoCli.setValueBuffer("codmultitransstock", cursor.valueBuffer("codmultitransstock"));
  curPedidoCli.setValueBuffer("idviajemultitrans", curViaje.valueBuffer("idviajemultitrans"));
  curPedidoCli.setValueBuffer("fecha", hoy);
  curPedidoCli.setValueBuffer("fechaentrada", hoy);
  curPedidoCli.setValueBuffer("fechasalida", hoy);
  curPedidoCli.setValueBuffer("nombrecliente", AQUtil.sqlSelect("clientes", "nombre", "codcliente = '" + codCliente + "'"));
  curPedidoCli.setValueBuffer("cifnif", AQUtil.sqlSelect("clientes", "cifnif", "codcliente = '" + codCliente + "'"));
  curPedidoCli.setValueBuffer("codcliente", codCliente);
  curPedidoCli.setValueBuffer("coddivisa", codDivisa);
  curPedidoCli.setValueBuffer("codpago", AQUtil.sqlSelect("clientes", "codpago", "codcliente = '" + codCliente + "'"));
  curPedidoCli.setValueBuffer("direccion", AQUtil.sqlSelect("almacenes", "direccion", "codalmacen = '" + almacenDestino + "'", "empresa,almacenes"));
  curPedidoCli.setValueBuffer("codpostal", AQUtil.sqlSelect("almacenes", "codpostal", "codalmacen = '" + almacenDestino + "'", "empresa,almacenes"));
  curPedidoCli.setValueBuffer("ciudad", AQUtil.sqlSelect("almacenes", "poblacion", "codalmacen = '" + almacenDestino + "'", "empresa,almacenes"));
  curPedidoCli.setValueBuffer("provincia", AQUtil.sqlSelect("almacenes", "provincia", "codalmacen = '" + almacenDestino + "'", "empresa,almacenes"));
  curPedidoCli.setValueBuffer("codpais", AQUtil.sqlSelect("almacenes", "codpais", "codalmacen = '" + almacenDestino + "'", "empresa,almacenes"));
  curPedidoCli.setValueBuffer("apartado", AQUtil.sqlSelect("almacenes", "apartado", "codalmacen = '" + almacenDestino + "'", "empresa,almacenes"));
  curPedidoCli.setValueBuffer("codalmacen", codAlmaOrigen);
  curPedidoCli.setValueBuffer("tasaconv", AQUtil.sqlSelect("divisas", "tasaconv", "coddivisa = '" + codDivisa + "'"));
  curPedidoCli.setValueBuffer("codejercicio", codEjercicio);
  curPedidoCli.setValueBuffer("codserie", AQUtil.sqlSelect("secuenciasejercicios", "codserie", "codejercicio = '" + codEjercicio + "' ORDER BY codserie"));

  return true;
}

function oficial_creaPedidoCli(curViaje)
{
  var _i = this.iface;
  var cursor = this.cursor();

  var curPedidoCli =  new FLSqlCursor("pedidoscli");
  curPedidoCli.setModeAccess(curPedidoCli.Insert);
  curPedidoCli.refreshBuffer();

  if (!_i.datosPedidoCli(curPedidoCli, curViaje)) {
    return false;
  }
  if (!curPedidoCli.commitBuffer()) {
    return false;
  }
  var idPedido = curPedidoCli.valueBuffer("idpedido");

  var curLinea =  new FLSqlCursor("tpv_lineasmultitransstock");
  // Saco las lineas que están en el mismo viaje.
  curLinea.select("codmultitransstock = '" + cursor.valueBuffer("codmultitransstock") + "' AND idviajemultitrans = '" + curViaje.valueBuffer("idviajemultitrans") + "'");

  // Por cada linea de lineasmultipedido del mismo viaje que hay hago un registro en lineaspedidoscli.
  while (curLinea.next()) {
    if (!_i.creaLinea("cliente", idPedido, curLinea)) {
      return false;
    }
  }
  curPedidoCli.select("idpedido = " + idPedido);
  if (!curPedidoCli.first()) {
    return false;
  }
  curPedidoCli.setModeAccess(curPedidoCli.Edit);
  curPedidoCli.refreshBuffer();
  _i.creaTotal("cliente", curPedidoCli);

  if (!curPedidoCli.commitBuffer()) {
    MessageBox.warning(sys.translate("Problema al calcular el total del pedido %1.").arg(curViaje.valueBuffer("idviajemulti")), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  return true;
}

function oficial_creaTotal(fN, cursor)
{

  switch (fN) {
    case "proveedor": {
      with(cursor) {
        setValueBuffer("netosindto", formpedidosprov.iface.pub_commonCalculateField("netosindto", cursor));
        setValueBuffer("neto", formpedidosprov.iface.pub_commonCalculateField("neto", cursor));
        setValueBuffer("totaliva", formpedidosprov.iface.pub_commonCalculateField("totaliva", cursor));
        setValueBuffer("totalirpf", formpedidosprov.iface.pub_commonCalculateField("totalirpf", cursor));
        setValueBuffer("totalrecargo", formpedidosprov.iface.pub_commonCalculateField("totalrecargo", cursor));
        setValueBuffer("total", formpedidosprov.iface.pub_commonCalculateField("total", cursor));
      }
      break;
    }
    case "cliente": {
      with(cursor) {
        setValueBuffer("netosindto", formpedidoscli.iface.pub_commonCalculateField("netosindto", cursor));
        setValueBuffer("neto", formpedidoscli.iface.pub_commonCalculateField("neto", cursor));
        setValueBuffer("totaliva", formpedidoscli.iface.pub_commonCalculateField("totaliva", cursor));
        setValueBuffer("totalirpf", formpedidoscli.iface.pub_commonCalculateField("totalirpf", cursor));
        setValueBuffer("totalrecargo", formpedidoscli.iface.pub_commonCalculateField("totalrecargo", cursor));
        setValueBuffer("total", formpedidoscli.iface.pub_commonCalculateField("total", cursor));
      }
      break;
    }
  }
}

function oficial_habilitarPorEstado()
{
  if (this.cursor().valueBuffer("estado") == "Aceptado") {
    this.child("gbxTransferencias").setDisabled(true);
    this.child("gbxArticulos").setDisabled(true);
    this.child("gbxAlmacenesGen").setDisabled(true);
  } else {
    this.child("gbxTransferencias").setDisabled(false);
    this.child("gbxArticulos").setDisabled(false);
    this.child("gbxAlmacenesGen").setDisabled(false);
  }
}

function oficial_cargaAlmacenes()
{
  var cursor = this.cursor();
  var _i = this.iface;

  var q = new FLSqlQuery();
  q.setSelect("codalmacen");
  q.setFrom("tpv_almamultitransstock");
  q.setWhere("codmultitransstock = '" + cursor.valueBuffer("codmultitransstock") + "'");
  if (!q.exec()) {
    return false;
  }
  while (q.next()) {
    this.child("tdbAlmacenes").setPrimaryKeyChecked(q.value(0), true);
  }
  return true;
}

function oficial_listaAlmacenes()
{
  var cursor = this.cursor();
  var _i = this.iface;

  var q = new FLSqlQuery();
  q.setSelect("codalmacen");
  q.setFrom("tpv_almamultitransstock");
  q.setWhere("codmultitransstock = '" + cursor.valueBuffer("codmultitransstock") + "'");
  if (!q.exec()) {
    return false;
  }

  var filtro = "";
  while (q.next()) {
    if (filtro != "")
      filtro += ",";
    filtro += "'" + q.value("codalmacen") + "'";
  }
  return filtro;
}

function oficial_inhabilitarAlmacenes()
{
  var cursor = this.cursor();
  var _i = this.iface;
  var filtro = _i.listaAlmacenes();

  this.child("tdbAlmacenes").setCheckColumnEnabled(false);
  if (filtro && filtro != "") {
    this.child("tdbAlmacenes").setFilter("codalmacen IN (" + filtro + ")");
    this.child("tdbAlmacenes").refresh();
  }

  return true;
}

function oficial_tdbAlmacenes_primaryKeyToggled(codAlmacen, on)
{
  var _i = this.iface;
  if (_i.bloqueoCarga_) {
    return;
  }
  var cursor = this.cursor();

  if (cursor.modeAccess() == cursor.Insert) {
    if (!this.child("tdbArticulos").cursor().commitBufferCursorRelation()) {
      return false;
    }
  }
  if (on) {
    AQSql.insert("tpv_almamultitransstock", ["codalmacen", "codmultitransstock"], [codAlmacen, cursor.valueBuffer("codmultitransstock")]);
  } else {
    AQSql.del("tpv_almamultitransstock", "codalmacen = '" + codAlmacen + "' AND codmultitransstock = '" + cursor.valueBuffer("codmultitransstock") + "'");
  }
}

function oficial_fechasRecom()
{
  var _i = this.iface;
  var cursor = this.cursor();

  if (cursor.modeAccess() != cursor.Insert) {
    return;
  }

  var hoy = new Date;
  var diaS = hoy.getDay();
  var desde = AQUtil.addDays(hoy, (diaS == 7 ? -2 : -1));
  var hasta = AQUtil.addDays(hoy, -1);
  sys.setObjText(this, "fdbFDesdeRecom", desde);
  sys.setObjText(this, "fdbFHastaRecom", hasta);
}

function oficial_tbnRefrescarRecom_clicked()
{
  var _i = this.iface;
  _i.cargarTablaReposiciones()

  //   var t = _i.tblTransstock_;
  //   var cursor = this.cursor();
  //
  //   var oArticulo = new Object;
  //   var codAlmaDestino;
  //   var canRecom = 0;
  //
  // //   var valorRecomendado = cursor.valueBuffer("valorrecomendado");
  //
  //   for (var f = 0; f < t.numRows(); f++) {
  //     oArticulo.referencia = t.text(f, _i.cREFERENCIA);
  //     for (var a = 0; a < _i.cDESTINO.length; a++) {
  //       codAlmaDestino = _i.cDESTINO[a]["codalmacen"];
  //       canRecom = _i.obtenerCantidadRecom(oArticulo, codAlmaDestino);
  //       t.setText(f, _i.cRECOM[a], canRecom);
  //
  //       if (valorRecomendado) {
  //         t.setText(f, _i.cREPONER[a], canRecom);
  //       }
  //
  //       _i.actualizarTransferencias(f, _i.cREPONER[a]);
  //     }
  //   }
}

function oficial_cargaHayEmpresa()
{
  var _i = this.iface;

  var mgr = aqApp.db().manager();

  var mtdT = mgr.metadata("almacenes");
  var mtdF = mtdT.field("idempresa");

  _i.hayCampoEmpresa_ = mtdF ? true : false;
}

function oficial_tbnImprimePedCli_clicked()
{
  var _i = this.iface;
  var oParam = _i.dameParamInformePedCli();
  if (!oParam) {
    return;
  }
  var curImprimir: FLSqlCursor = new FLSqlCursor("i_pedidoscli");
  curImprimir.setModeAccess(curImprimir.Insert);
  curImprimir.refreshBuffer();
  curImprimir.setValueBuffer("descripcion", "temp");
  flfactinfo.iface.pub_lanzaInforme(curImprimir, oParam);
}

function oficial_dameParamInformePedCli()
{
  var cursor = this.cursor();
  var oParam = flfactinfo.iface.pub_dameParamInforme();
  oParam.nombreInforme = "i_pedidoscli";
  oParam.whereFijo = "codmultitransstock = '" + cursor.valueBuffer("codmultitransstock") + "'";
  return oParam;
}

function oficial_tbnCalcular_clicked()
{
  var _i = this.iface;
  if (!_i.limpiarTabla()) {
    return false;
  }

  var cursor = this.cursor();

  //   _i.tblTransstock_.clear();
  var codMultiTrans = cursor.valueBuffer("codmultitransstock");
  if (!codMultiTrans || codMultiTrans == "") {
    return;
  }
  var codAlmaOrigen = cursor.valueBuffer("codalmaorigen");
  if (!codAlmaOrigen || codAlmaOrigen == "") {
    return;
  }
  var lA = _i.listaAlmacenes();
  if (lA == "") {
    return;
  }
  var wStockPos = "";
  if (cursor.valueBuffer("solostockpos")) {
    wStockPos = " AND s.disponible > 0";
  }
  var wFechas = "";
  var desde = cursor.valueBuffer("fdesderecom");
  if (desde) {
    wFechas += " AND c.fecha >= '" + desde + "'";
  }
  var hasta = cursor.valueBuffer("fhastarecom");
  if (desde) {
    wFechas += " AND c.fecha <= '" + hasta + "'";
  }
  var q = new FLSqlQuery;
  q.setSelect("a.referencia,a.descripcion,a.codfamilia, c.codalmacen, SUM(lc.cantidad)");
  q.setFrom("tpv_comandas c INNER JOIN tpv_lineascomanda lc ON c.idtpv_comanda = lc.idtpv_comanda INNER JOIN articulos a ON lc.referencia = a.referencia INNER JOIN stocks s ON (a.referencia = s.referencia AND s.codalmacen = '" + codAlmaOrigen + "') INNER JOIN tpv_artmultitransstock m ON (a.referencia = m.referencia AND m.codmultitransstock = '" + codMultiTrans + "')");
  q.setWhere("c.codalmacen IN (" + lA + ") " + wFechas + wStockPos + " GROUP BY a.referencia,a.descripcion,a.codfamilia, c.codalmacen HAVING SUM(lc.cantidad) > 0 ORDER BY a.codfamilia, a.descripcion, c.codalmacen");
  q.setForwardOnly(true);
  debug(q.sql());
  if (!q.exec()) {
    return;
  }
  if (!_i.idArticulos_) {
    _i.idArticulos_ = new Object;
  }
  _i.cargaLineas(q, "REP");

  _i.habilitaPestanaSets();
  _i.tblTransstock_.repaintContents();
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
