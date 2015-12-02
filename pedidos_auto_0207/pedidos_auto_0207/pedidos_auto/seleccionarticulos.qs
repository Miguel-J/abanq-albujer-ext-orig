/***************************************************************************
                 seleccionarticulos.qs  -  descripcion
                             -------------------
    begin                : 22-01-2007
    copyright            : (C) 2007 by Mathias Behrle
    email                : mathiasb@behrle.dyndns.org
    partly based on code by
    copyright            : (C) 2004 by InfoSiAL S.L.
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
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna
{
  var pbnRStockOrd: Object;
  //  var tdbArticulos:Object;
  //  var tdbArticulosSel:Object;
  var pbnAceptar: Object;
  var COL_REF: Number;
  var COL_DES: Number;
  var COL_SMIN: Number;
  //  var COL_SFIS:Number;
  var COL_SDIS: Number;
  var COL_PREC: Number;
  var COL_PEDIR: Number;
  var COL_SEL: Number;
  var tblArticulos: FLTable;
  var colorVerde: Color;
  var colorBlanco: Color;

  function oficial(context)
  {
    interna(context);
  }
  function desconectar()
  {
    return this.ctx.oficial_desconectar();
  }
  function incluirFila(iFila: Number, iCol: Number, sel: String)
  {
    return this.ctx.oficial_incluirFila(iFila, iCol, sel);
  }
  function generarTabla()
  {
    return this.ctx.oficial_generarTabla();
  }
  function cargarTabla()
  {
    return this.ctx.oficial_cargarTabla();
  }
  function limpiarTabla()
  {
    return this.ctx.oficial_limpiarTabla();
  }
  function buscar()
  {
    return this.ctx.oficial_buscar();
  }
  function colorearFila(iFila: Number)
  {
    return this.ctx.oficial_colorearFila(iFila);
  }
  function pbnResetearStockOrd_clicked()
  {
    return this.ctx.oficial_pbnResetearStockOrd_clicked();
  }
  function seleccionar()
  {
    return this.ctx.oficial_seleccionar();
  }
  function seleccionarTodos()
  {
    return this.ctx.oficial_seleccionarTodos();
  }
  function quitar()
  {
    return this.ctx.oficial_quitar();
  }
  function quitarTodos()
  {
    return this.ctx.oficial_quitarTodos();
  }
  function guardarDatos()
  {
    return this.ctx.oficial_guardarDatos();
  }
  function chkFiltrarArtStockOrd_clicked()
  {
    return this.ctx.oficial_chkFiltrarArtStockOrd_clicked();
  }
  function habilitarPorStockOrd()
  {
    return this.ctx.oficial_habilitarPorStockOrd();
  }
  function dameDisponibleCompuestos(oArticulo, codAlmacen)
  {
    return this.ctx.oficial_dameDisponibleCompuestos(oArticulo, codAlmacen);
  }
  function valoresIniciales()
  {
    return this.ctx.oficial_valoresIniciales();
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
Este formulario muestra una lista de lineas de proveedor que cumplen un determinado filtro, y permite al usuario seleccionar uno o más lineas de la lista
\end */
function interna_init()
{
  var cursor: FLSqlCursor = this.cursor();

  this.iface.pbnRStockOrd = this.child("pbnResetearStockOrd");
  this.iface.tblArticulos = this.child("tblArticulos");
  this.iface.pbnAceptar = this.child("pushButtonAccept");

  this.iface.valoresIniciales();

  connect(this.iface.tblArticulos, "clicked(int, int)", this, "iface.incluirFila");

  disconnect(this.iface.pbnAceptar, "clicked()", this, "accept()");
  connect(this.iface.pbnAceptar, "clicked()", this, "iface.guardarDatos()");
  connect(this.iface.pbnRStockOrd, "clicked()", this, "iface.pbnResetearStockOrd_clicked");
  connect(this.child("chkFiltrarArtProv"), "clicked()", this, "iface.buscar");
  connect(this.child("chkFiltrarArtStockFis"), "clicked()", this, "iface.buscar");
  connect(this.child("chkFiltrarArtStockMin"), "clicked()", this, "iface.buscar");
  connect(this.child("chkFiltrarArtStockOrd"), "clicked()", this, "iface.chkFiltrarArtStockOrd_clicked");
  connect(this.child("pbnSeleccionar"), "clicked()", this, "iface.seleccionar()");
  connect(this.child("pbnSeleccionarTodos"), "clicked()", this, "iface.seleccionarTodos()");
  connect(this.child("pbnQuitar"), "clicked()", this, "iface.quitar()");
  connect(this.child("pbnQuitarTodos"), "clicked()", this, "iface.quitarTodos()");
  connect(form, "closed()", this, "iface.desconectar");

  this.iface.generarTabla();
  this.iface.cargarTabla();
  this.child("fdbProveedor").setFocus();
  this.iface.habilitarPorStockOrd();
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_valoresIniciales()
{
  this.iface.colorVerde = new Color();
  this.iface.colorBlanco = new Color();
  this.iface.colorVerde.setRgb(150, 200, 150);
  this.iface.colorBlanco.setRgb(230, 230, 230);

  this.child("chkFiltrarArtProv").checked = true;
  this.child("chkFiltrarArtStockFis").checked = true;
  this.child("chkFiltrarArtStockMin").checked = true;
  this.child("chkFiltrarArtStockOrd").checked = true;
}

function oficial_incluirFila(iFila: Number, iCol: Number, sel: String)
{
  if (iCol == this.iface.COL_PEDIR) {
    return;
  }
  if (!sel) {
    sel = this.iface.tblArticulos.text(iFila, this.iface.COL_SEL);
    if (sel == "S") {
      sel = "N";
    } else {
      sel = "S";
    }
  }
  this.iface.tblArticulos.setText(iFila, this.iface.COL_SEL, sel);
  this.iface.colorearFila(iFila);
}

function oficial_generarTabla()
{
  var util: FLUtil = new FLUtil;

  this.iface.COL_SEL = 0;
  this.iface.COL_REF = 1;
  this.iface.COL_DES = 2;
  this.iface.COL_SMIN = 3;
  this.iface.COL_SDIS = 4;
  this.iface.COL_PREC = 5;
  this.iface.COL_PEDIR = 6;

  this.iface.tblArticulos.setNumCols(7);
  this.iface.tblArticulos.setColumnWidth(this.iface.COL_REF, 120);
  this.iface.tblArticulos.setColumnWidth(this.iface.COL_DES, 350);
  this.iface.tblArticulos.setColumnWidth(this.iface.COL_SMIN, 80);
  this.iface.tblArticulos.setColumnWidth(this.iface.COL_SDIS, 80);
  this.iface.tblArticulos.setColumnWidth(this.iface.COL_PREC, 80);
  this.iface.tblArticulos.setColumnWidth(this.iface.COL_PEDIR, 80);

  this.iface.tblArticulos.setColumnReadOnly(this.iface.COL_REF, true);
  this.iface.tblArticulos.setColumnReadOnly(this.iface.COL_DES, true);
  this.iface.tblArticulos.setColumnReadOnly(this.iface.COL_SMIN, true);
  this.iface.tblArticulos.setColumnReadOnly(this.iface.COL_SDIS, true);
  this.iface.tblArticulos.setColumnReadOnly(this.iface.COL_PREC, true);
  this.iface.tblArticulos.setColumnReadOnly(this.iface.COL_PEDIR, false);

  var cabeceras: String = " /" + util.translate("scripts", "Referencia") + "/" + util.translate("scripts", "Descripción") + "/" + util.translate("scripts", "S.Mínimo (M)") + "/" + util.translate("scripts", "S.Disponible (D)") + "/" + util.translate("scripts", "S.Por Recibir (R)") + "/" + util.translate("scripts", "A Pedir (P=M-D-R)");
  this.iface.tblArticulos.setColumnLabels("/", cabeceras);
  this.iface.tblArticulos.hideColumn(this.iface.COL_SEL);
}

function oficial_cargarTabla()
{
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  this.iface.limpiarTabla();

  var codAlmacen = cursor.valueBuffer("codalmacen");
  var datos: String = cursor.valueBuffer("datos");
  var xmlDatos: FLDomDocument = new FLDomDocument;
  if (!xmlDatos.setContent(datos)) {
    return false;
  }
  var xmlArticulos: FLDomNodeList = xmlDatos.elementsByTagName("Articulo");
  if (xmlArticulos && xmlArticulos.count() > 0) {
    var eArticulo: FLDomElement;
    var referencia: String;
    var sMin: Number;
    var sDis: Number;
    var pteRecibir: Number;
    var pedir: Number;
    var groupBy: String = " GROUP BY a.descripcion, s.stockmin";

    var qryStock: FLSqlQuery = new FLSqlQuery;
    qryStock.setTablesList("articulos,stocks");
    qryStock.setSelect("a.descripcion, s.stockmin, SUM(s.pterecibir), SUM(s.disponible)");
    qryStock.setFrom("articulos a LEFT OUTER JOIN stocks s ON (a.referencia = s.referencia AND s.codalmacen = '" + codAlmacen + "')");
    qryStock.setForwardOnly(true);
    var oArticulo = new Object();
    for (var i: Number = 0; i < xmlArticulos.count(); i++) {
      eArticulo = xmlArticulos.item(i).toElement();
      referencia = eArticulo.attribute("Referencia");
      oArticulo.referencia = referencia;
      qryStock.setWhere("a.referencia = '" + referencia + "'" + groupBy);
      if (!qryStock.exec()) {
        return false;
      }
      if (!qryStock.first()) {
        return false;
      }

      sMin = (isNaN(qryStock.value("s.stockmin")) ? 0 : qryStock.value("s.stockmin"));
      sDis = (isNaN(qryStock.value("SUM(s.disponible)")) ? 0 : qryStock.value("SUM(s.disponible)"));
      sDis += this.iface.dameDisponibleCompuestos(oArticulo, codAlmacen);
      pteRecibir = (isNaN(qryStock.value("SUM(s.pterecibir)")) ? 0 : qryStock.value("SUM(s.pterecibir)"));
      pedir = eArticulo.attribute("Pedir");

      this.iface.tblArticulos.insertRows(i);
      this.iface.tblArticulos.setText(i, this.iface.COL_REF, referencia);
      this.iface.tblArticulos.setText(i, this.iface.COL_DES, qryStock.value("a.descripcion"));
      this.iface.tblArticulos.setText(i, this.iface.COL_SMIN, sMin);
      this.iface.tblArticulos.setText(i, this.iface.COL_SDIS, sDis);
      this.iface.tblArticulos.setText(i, this.iface.COL_PREC, pteRecibir);
      this.iface.tblArticulos.setText(i, this.iface.COL_PEDIR, pedir);
      this.iface.tblArticulos.setText(i, this.iface.COL_SEL, "S");
      this.iface.colorearFila(i);
    }
  } else {
    this.iface.buscar();
  }
}

function oficial_limpiarTabla()
{
  var numFilas: Number = this.iface.tblArticulos.numRows();
  for (var iFila: Number = (numFilas - 1); iFila >= 0; iFila--) {
    this.iface.tblArticulos.removeRow(iFila);
  }
}

function oficial_buscar()
{
  debug("Buscando");
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();
  var codAlmacen = cursor.valueBuffer("codalmacen");

  this.iface.limpiarTabla();

  var filtro: String = "1 = 1";
  var fromSelect: String = "articulos a LEFT OUTER JOIN stocks s ON (a.referencia = s.referencia AND s.codalmacen = '" + codAlmacen + "')";
  if (this.child("chkFiltrarArtProv").checked) {
    filtro += " AND ap.codproveedor = '" + cursor.valueBuffer("codproveedor") + "'";
    fromSelect += " INNER JOIN articulosprov ap ON a.referencia = ap.referencia";
  }
  if (this.child("chkFiltrarArtStockMin").checked) {
    filtro += " AND a.stockmin > 0";
  }

  var groupBy: String = " GROUP BY a.referencia, a.descripcion, s.stockmin ORDER BY a.referencia";
  var qryStock: FLSqlQuery = new FLSqlQuery;
  qryStock.setTablesList("articulos,stocks,articulosprov");
  qryStock.setSelect("a.referencia, a.descripcion, s.stockmin, SUM(s.disponible), SUM(s.pterecibir)");
  qryStock.setFrom(fromSelect);
  qryStock.setWhere(filtro + groupBy);
  qryStock.setForwardOnly(true);
  if (!qryStock.exec()) {
    return false;
  }
  var totalArticulos: Number = qryStock.size();
  var referencia: String;
  var sMin: Number;
  var sDis: Number;
  var pteRecibir: Number;
  var pedir: Number;

  var iFila: Number = 0;
  util.createProgressDialog(util.translate("scripts", "Informando tabla de artículos"), totalArticulos);
  var oArticulo = new Object();
  while (qryStock.next()) {
    util.setProgress(iFila);
    referencia = qryStock.value("a.referencia");
    oArticulo.referencia = referencia;
    sMin = (isNaN(qryStock.value("s.stockmin")) ? 0 : qryStock.value("s.stockmin"));
    sDis = (isNaN(qryStock.value("SUM(s.disponible)")) ? 0 : qryStock.value("SUM(s.disponible)"));
    sDis += this.iface.dameDisponibleCompuestos(oArticulo, codAlmacen);
    pteRecibir = (isNaN(qryStock.value("SUM(s.pterecibir)")) ? 0 : qryStock.value("SUM(s.pterecibir)"));
    pedir = sMin - (sDis + pteRecibir);
    if (pedir < 0) {
      pedir = 0;
    }

    if (this.child("chkFiltrarArtStockFis").checked) {
      if (sMin <= (sDis + pteRecibir)) {
        continue;
      }
    }
    if (this.child("chkFiltrarArtStockOrd").checked) {
      if ((sMin - (sDis + pteRecibir)) < cursor.valueBuffer("cantidadmin")) {
        continue;
      }
    }

    this.iface.tblArticulos.insertRows(iFila);
    this.iface.tblArticulos.setText(iFila, this.iface.COL_REF, referencia);
    this.iface.tblArticulos.setText(iFila, this.iface.COL_DES, qryStock.value("a.descripcion"));
    this.iface.tblArticulos.setText(iFila, this.iface.COL_SMIN, sMin);
    this.iface.tblArticulos.setText(iFila, this.iface.COL_SDIS, sDis);
    this.iface.tblArticulos.setText(iFila, this.iface.COL_PREC, pteRecibir);
    this.iface.tblArticulos.setText(iFila, this.iface.COL_PEDIR, pedir);
    this.iface.tblArticulos.setText(iFila, this.iface.COL_SEL, "N");
    this.iface.colorearFila(iFila);
    iFila++;
  }
  util.destroyProgressDialog();
}

function oficial_dameDisponibleCompuestos(oArticulo, codAlmacen)
{
  /// Función a sobrecargar por las extensiones de artículos compuestos
  return 0;
}

function oficial_colorearFila(iFila: Number)
{
  var numCols: Number = this.iface.tblArticulos.numCols();
  for (var iCol: Number = 0; iCol < numCols; iCol++) {
    if (this.iface.tblArticulos.text(iFila, this.iface.COL_SEL) == "S") {
      this.iface.tblArticulos.setCellBackgroundColor(iFila, iCol, this.iface.colorVerde);
    } else {
      this.iface.tblArticulos.setCellBackgroundColor(iFila, iCol, this.iface.colorBlanco);
    }
    this.iface.tblArticulos.adjustColumn(iCol);
  }
}

function oficial_desconectar()
{
  disconnect(this.child("chkFiltrarArtProv"), "clicked()", this, "iface.filtrarArtProv");
  disconnect(this.child("chkFiltrarArtStockFis"), "clicked()", this, "iface.filtrarArtStockFis");
  disconnect(this.child("chkFiltrarArtStockMin"), "clicked()", this, "iface.filtrarArtStockMin");
}

/** \C
Al pulsar el botón de resetear les unidades pedidos
\end */
function oficial_pbnResetearStockOrd_clicked()
{
  var numFilas: Number = this.iface.tblArticulos.numRows();
  for (var iFila: Number = 0; iFila < numFilas; iFila++) {
    this.iface.tblArticulos.setText(iFila, this.iface.COL_PEDIR, 0);
  }
}

/** \D Incluye un articulo en la lista de datos
*/
function oficial_seleccionar()
{
  var iFila: Number = this.iface.tblArticulos.currentRow();
  if (iFila < 0) {
    return;
  }
  this.iface.incluirFila(iFila, 0, "S");
}

/** \D Incluye todos los articulos en la lista de datos
*/
function oficial_seleccionarTodos()
{
  var numFilas: Number = this.iface.tblArticulos.numRows();
  for (var iFila: Number = 0; iFila < numFilas; iFila++) {
    this.iface.incluirFila(iFila, 0, "S");
  }
}

/** \D Quira un articulo de la lista de datos
*/
function oficial_quitar()
{
  var iFila: Number = this.iface.tblArticulos.currentRow();
  if (iFila < 0) {
    return;
  }
  this.iface.incluirFila(iFila, 0, "N");
}

/** \D Quira todos los articulos de la lista de datos
*/
function oficial_quitarTodos()
{
  var numFilas: Number = this.iface.tblArticulos.numRows();
  for (var iFila: Number = 0; iFila < numFilas; iFila++) {
    this.iface.incluirFila(iFila, 0, "N");
  }
}


function oficial_guardarDatos()
{
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  var numFilas: Number = this.iface.tblArticulos.numRows();
  var xmlDatos: FLDomDocument = new FLDomDocument;
  xmlDatos.setContent("<PedidoAuto/>");
  var eArticulo: FLDomElement;
  for (var iFila: Number = 0; iFila < numFilas; iFila++) {
    if (this.iface.tblArticulos.text(iFila, this.iface.COL_SEL) == "N") {
      continue;
    }
    eArticulo = xmlDatos.createElement("Articulo");
    eArticulo.setAttribute("Referencia", this.iface.tblArticulos.text(iFila, this.iface.COL_REF));
    eArticulo.setAttribute("Pedir", this.iface.tblArticulos.text(iFila, this.iface.COL_PEDIR));
    xmlDatos.firstChild().appendChild(eArticulo);
  }
  debug(xmlDatos.toString(4));
  cursor.setValueBuffer("datos", xmlDatos.toString(4));
  this.accept();
}

function oficial_chkFiltrarArtStockOrd_clicked()
{
  this.iface.habilitarPorStockOrd()
  this.iface.buscar();
}

function oficial_habilitarPorStockOrd()
{
  if (this.child("chkFiltrarArtStockOrd").checked) {
    this.child("fdbCantidadMin").setDisabled(true);
  } else {
    this.child("fdbCantidadMin").setDisabled(false);
  }
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
