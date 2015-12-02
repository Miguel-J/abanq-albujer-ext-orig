/***************************************************************************
                 roturastock.qs  -  description
                             -------------------
    begin                : lun jun 18 2007
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
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna
{
  var INCLUIR, NUMPEDIDO, CODPROVEEDOR, NOMPROVEEDOR, REFERENCIA, DESARTICULO, FECHAPEDIDO, PLAZO, FECHAROTURA, STOCKACTUAL, STOCKMIN, STOCKMAX, PEDIR, IDSTOCK;
  var estado, currentRow_, totalDatosES;
  function oficial(context)
  {
    interna(context);
  }
  function tblArticulos_currentChanged(row, col)
  {
    return this.ctx.oficial_tblArticulos_currentChanged(row, col);
  }
  function pbnAddDel_clicked()
  {
    return this.ctx.oficial_pbnAddDel_clicked();
  }
  function incluirFila(fila, col)
  {
    return this.ctx.oficial_incluirFila(fila, col);
  }
  function bufferChanged(fN)
  {
    return this.ctx.oficial_bufferChanged(fN);
  }
  function gestionEstado()
  {
    return this.ctx.oficial_gestionEstado();
  }
  function actualizar()
  {
    return this.ctx.oficial_actualizar();
  }
  function generarListaArticulos()
  {
    return this.ctx.oficial_generarListaArticulos();
  }
  function construirWhere()
  {
    return this.ctx.oficial_construirWhere();
  }
  function dameOrderBy()
  {
    return this.ctx.oficial_dameOrderBy();
  }
  function construirWherePedidoCli()
  {
    return this.ctx.oficial_construirWherePedidoCli();
  }
  function listaRefPedido(qryMov)
  {
    return this.ctx.oficial_listaRefPedido(qryMov);
  }
  function tbnEvolStock_clicked()
  {
    return this.ctx.oficial_tbnEvolStock_clicked();
  }
  function initDatosLinea()
  {
    return this.ctx.oficial_initDatosLinea();
  }
  function calculoNecesidades()
  {
    return this.ctx.oficial_calculoNecesidades();
  }
  function hayRoturaStock(datosLinea)
  {
    return this.ctx.oficial_hayRoturaStock(datosLinea);
  }
  function agruparPedidos()
  {
    return this.ctx.oficial_agruparPedidos();
  }
  function cambiarFechas(fechaPedido, fechaRotura, filaDesde, filaHasta, numPedido)
  {
    return this.ctx.oficial_cambiarFechas(fechaPedido, fechaRotura, filaDesde, filaHasta, numPedido);
  }
  function datosEvolStockActual()
  {
    return this.ctx.oficial_datosEvolStockActual();
  }
  function numerarPedidosFecha()
  {
    return this.ctx.oficial_numerarPedidosFecha();
  }
  function numerarPedidosArticulo()
  {
    return this.ctx.oficial_numerarPedidosArticulo();
  }
  function consultaBusqueda()
  {
    return this.ctx.oficial_consultaBusqueda();
  }
  function iniciarTabla()
  {
    return this.ctx.oficial_iniciarTabla();
  }
  function incluirDatosExtraFila(fila, qryDatos)
  {
    return this.ctx.oficial_incluirDatosExtraFila(fila, qryDatos);
  }
  function tbnStock_clicked()
  {
    return this.ctx.oficial_tbnStock_clicked();
  }
  function mensajeTiempoSuficiente()
  {
    return this.ctx.oficial_mensajeTiempoSuficiente();
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
  function pub_datosEvolStockActual(): Array {
    return this.datosEvolStockActual();
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
Este formulario agrupa distintos pedidos del mismo proveedor un único albarán. Es posible especificar los criterios que deben cumplir los pedidos a incluir. De la lista de pedidos que cumplen los criterios de búsqueda se generará un albarán por proveedor (ej. si los pedidos corresponden a dos proveedores se generarán dos albaranes).
\end */
function interna_init()
{
  var _i = this.iface;
  _i.estado = "Buscando";
  _i.gestionEstado();
  var tblArticulos = this.child("tblArticulos");
  var cursor = this.cursor();

  connect(this.child("pbnRefresh"), "clicked()", _i, "actualizar");
  connect(cursor, "bufferChanged(QString)", _i, "bufferChanged");
  connect(tblArticulos, "doubleClicked(int, int)", _i, "incluirFila");
  connect(tblArticulos, "currentChanged(int, int)", _i, "tblArticulos_currentChanged");
  connect(this.child("pushButtonAccept"), "clicked()", _i, "generarListaArticulos");
  connect(this.child("tbnEvolStock"), "clicked()", _i, "tbnEvolStock_clicked");
  connect(this.child("tbnStock"), "clicked()", _i, "tbnStock_clicked");
  connect(this.child("tbnCalcuNece"), "clicked()", _i, "calculoNecesidades");
  connect(this.child("pbnAddDel"), "clicked()", _i, "pbnAddDel_clicked");

  this.child("fdbCodAlmacen").setValue(flfactppal.iface.pub_valorDefectoEmpresa("codalmacen"));
  this.child("fdbCodEjercicio").setValue(flfactppal.iface.pub_ejercicioActual());
  this.child("fdbCodSerie").setValue(flfactppal.iface.pub_valorDefectoEmpresa("codserie"));
  this.child("fdbCodDivisa").setValue(flfactppal.iface.pub_valorDefectoEmpresa("coddivisa"));
  this.child("fdbCodEjercicio").setDisabled(true);

  var hoy = new Date();
  this.child("fdbFecha").setValue(hoy);

  _i.iniciarTabla()
  cursor.setValueBuffer("lista", "");

  if (!cursor.isNull("idpedidocli")) {
    this.child("lblPedidoCli").text = sys.translate("Pedido %1").arg(AQUtil.sqlSelect("pedidoscli", "codigo", "idpedido = " + cursor.valueBuffer("idpedidocli")));
    this.child("fdbCodProveedor").setValue("");
    this.child("fdbReferencia").setValue("");
    this.child("fdbCodProveedor").setDisabled(true);
    this.child("fdbReferencia").setDisabled(true);
    _i.actualizar();
  }

  if (cursor.isNull("codpago") || cursor.valueBuffer("codpago") == "") {
    this.child("fdbCodPago").setValue(flfactppal.iface.pub_valorDefectoEmpresa("codpago"));
  }
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_iniciarTabla()
{
  var _i = this.iface;
  var tblArticulos = this.child("tblArticulos");

  var c = 0, sep = "*", cab = "";
  _i.INCLUIR = c++;
  cab += sys.translate("Incluir") + sep;
  _i.NUMPEDIDO = c++;
  cab += sys.translate("Nº") + sep;
  _i.CODPROVEEDOR = c++;
  cab += sys.translate("C.P.") + sep;
  _i.NOMPROVEEDOR = c++;
  cab += sys.translate("Proveedor") + sep;
  _i.REFERENCIA = c++;
  cab += sys.translate("Ref.") + sep;
  _i.DESARTICULO = c++;
  cab += sys.translate("Artículo") + sep;
  _i.FECHAPEDIDO = c++;
  cab += sys.translate("F.Pedido") + sep;
  _i.PLAZO = c++;
  cab += sys.translate("Plazo") + sep;
  _i.FECHAROTURA = c++;
  cab += sys.translate("F.Rotura") + sep;
  _i.STOCKACTUAL = c++;
  cab += sys.translate("Actual") + sep;
  _i.STOCKMIN = c++;
  cab += sys.translate("Mínimo") + sep;
  _i.STOCKMAX = c++;
  cab += sys.translate("Máximo") + sep;
  _i.PEDIR = c++;
  cab += sys.translate("Pedir") + sep;
  _i.IDSTOCK = c++;
  cab += sys.translate("idStock") + sep;

  tblArticulos.setNumCols(c);
  tblArticulos.setColumnLabels(sep, cab);

  tblArticulos.setColumnWidth(_i.INCLUIR, 40);
  tblArticulos.setColumnWidth(_i.NUMPEDIDO, 40);
  tblArticulos.setColumnWidth(_i.CODPROVEEDOR, 60);
  tblArticulos.setColumnWidth(_i.NOMPROVEEDOR, 150);
  tblArticulos.setColumnWidth(_i.REFERENCIA, 80);
  tblArticulos.setColumnWidth(_i.DESARTICULO, 150);
  tblArticulos.setColumnWidth(_i.FECHAPEDIDO, 80);
  tblArticulos.setColumnWidth(_i.PLAZO, 50);
  tblArticulos.setColumnWidth(_i.FECHAROTURA, 80);
  tblArticulos.setColumnWidth(_i.STOCKACTUAL, 50);
  tblArticulos.setColumnWidth(_i.STOCKMIN, 50);
  tblArticulos.setColumnWidth(_i.STOCKMAX, 50);
  tblArticulos.setColumnWidth(_i.PEDIR, 50);
  tblArticulos.hideColumn(_i.IDSTOCK);
}

function oficial_tblArticulos_currentChanged(row, col)
{
  var _i = this.iface;
  _i.currentRow_ = row;
}

function oficial_pbnAddDel_clicked()
{
  var _i = this.iface;
  _i.incluirFila(_i.currentRow_, _i.INCLUIR);
}

function oficial_incluirFila(fila, col)
{
  var _i = this.iface;
  if (col != _i.INCLUIR) {
    return;
  }
  var tblArticulos = this.child("tblArticulos");
  if (tblArticulos.numRows() == 0) {
    return;
  }
  if (tblArticulos.text(fila, _i.INCLUIR) == "Sí") {
    tblArticulos.setText(fila, _i.INCLUIR, "No");
  } else {
    tblArticulos.setText(fila, _i.INCLUIR, "Sí");
  }
}

function oficial_bufferChanged(fN)
{
  var _i = this.iface;
  switch (fN) {
      /** \C
      La modificación de alguno de los criterios de búsqueda habilita el botón 'Actualizar', de forma que puede realizarse una búsqueda de acuerdo a los nuevos criterios utilizados.
      \end */
    case "codproveedor":
    case "referencia":
    case "codalmacen":
    case "agrupar": {
      if (_i.estado == "Seleccionando") {
        _i.estado = "Buscando";
        _i.gestionEstado();
      }
      break;
    }
  }
}

/** \D
El estado 'Buscando' define la situación en la que el usuario está especificando los criterios de búsqueda.
El estado 'Seleccionando' define la situación en la que el usuario ya ha buscado y puede generar la factura o facturas
\end */
function oficial_gestionEstado()
{
  var _i = this.iface;
  switch (_i.estado) {
    case "Buscando": {
      this.child("pbnRefresh").enabled = true;
      this.child("pushButtonAccept").enabled = false;
      break;
    }
    case "Seleccionando": {
      this.child("pbnRefresh").enabled = false;
      this.child("pushButtonAccept").enabled = true;
      break;
    }
  }
}

/** \D
Actualiza la lista de pedidos en función de los criterios de búsqueda especificados
\end */
function oficial_actualizar()
{
  var _i = this.iface;
  var util = new FLUtil;
  var cursor = this.cursor();

  if (_i.totalDatosES) {
    delete _i.totalDatosES;
  }
  _i.totalDatosES = [];

  var tblArticulos = this.child("tblArticulos");
  var fila = 0;
  var hoy = new Date;

  tblArticulos.setNumRows(0);

  var referencia, incluir, datosRotura, fechaPedido, fechaRotura;
  var codAlmacen: String = cursor.valueBuffer("codalmacen");
  var codProveedor, nomProveedor, plazo, stockMinimo, cantidad, idStock;

  var qryArticulos = _i.consultaBusqueda()
  if (!qryArticulos) {
    return false;
  }
  if (!qryArticulos.exec()) {
    return false;
  }
  AQUtil.createProgressDialog(sys.translate("Buscando artículos..."), qryArticulos.size());
  AQUtil.setProgress(0);
  var i = 1;
  var avisar = true;
  while (qryArticulos.next()) {
    AQUtil.setProgress(i);
    i++;
    referencia = qryArticulos.value("a.referencia");
    codProveedor = qryArticulos.value("ap.codproveedor");
    if (!codProveedor) {
      codProveedor = cursor.valueBuffer("codproveedorped");
    }
    if (codProveedor) {
      nomProveedor = AQUtil.sqlSelect("proveedores", "nombre", "codproveedor = '" + codProveedor + "'");
    }

    plazo = qryArticulos.value("ap.plazo");
    if (!plazo || isNaN(plazo)) {
      plazo = 0;
    }
    stockMinimo = qryArticulos.value("a.stockmin");
    if (!stockMinimo || isNaN(stockMinimo)) {
      stockMinimo = 0;
    }
    stockMaximo = qryArticulos.value("a.stockmax");
    if (!stockMaximo || isNaN(stockMaximo)) {
      stockMaximo = 0;
    }
    idStock = qryArticulos.value("s.idstock");
    _i.totalDatosES[fila] = flfactalma.iface.pub_datosEvolStock(qryArticulos, hoy.toString(), avisar);


    if (!_i.totalDatosES[fila]) {
      AQUtil.destroyProgressDialog();
      return false;
    }

    if (!_i.totalDatosES[fila]["avisar"]) {
      avisar = false;
    }
    _i.totalDatosES[fila] = flfactalma.iface.pub_planificarPedStock(_i.totalDatosES[fila], plazo)
    if (!_i.totalDatosES[fila]) {
      AQUtil.destroyProgressDialog();
      return false;
    }

    var idRotura = -1, idPedido = -1;
    for (var i = 0; i < _i.totalDatosES[fila].length; i++) {
      if (_i.totalDatosES[fila][i]["RPP"] > 0) {
        idRotura = i;
      }
      if (_i.totalDatosES[fila][i]["LPP"] > 0) {
        idPedido = i;
      }
    }
    if (idRotura == -1 && cursor.isNull("idpedidocli")) {
      continue;
    }
    if (idRotura > -1) {
      incluir = AQUtil.translate("scripts", "Sí");
      cantidad = _i.totalDatosES[fila][idRotura]["RPP"];
      fechaRotura = _i.totalDatosES[fila][idRotura]["fecha"];
      fechaPedido = _i.totalDatosES[fila][idPedido]["fecha"];
    } else {
      incluir = sys.translate("No");
      cantidad = 0;
      fechaRotura = "";
      fechaPedido = "";
    }

    cantidad = AQUtil.roundFieldValue(cantidad, "lineaspedidosprov", "cantidad");
    var valorCero = 0;
    valorCero = AQUtil.roundFieldValue(valorCero, "lineaspedidosprov", "cantidad");
    if (cantidad <= valorCero) {
      incluir = sys.translate("No");
    }
    if (cursor.valueBuffer("agrupar") != "Proveedor (Usar fecha mínima)") {
      var datosArticulo: Array = flfactalma.iface.pub_datosArticuloStock(idStock);
      if (fechaRotura && fechaPedido && AQUtil.daysTo(fechaPedido, fechaRotura) < plazo) {
        if (nomProveedor) {
          _i.mensajeTiempoSuficiente(datosArticulo["nombre"], nomProveedor, AQUtil.dateAMDtoDMA(fechaRotura));
        }
      }
    }

    tblArticulos.insertRows(fila);
    tblArticulos.setText(fila, _i.INCLUIR, incluir);
    tblArticulos.setText(fila, _i.CODPROVEEDOR, codProveedor);
    tblArticulos.setText(fila, _i.NOMPROVEEDOR, nomProveedor);
    tblArticulos.setText(fila, _i.REFERENCIA, referencia);
    tblArticulos.setText(fila, _i.DESARTICULO, qryArticulos.value("a.descripcion"));
    tblArticulos.setText(fila, _i.FECHAROTURA, util.dateAMDtoDMA(fechaRotura));
    tblArticulos.setText(fila, _i.PLAZO, plazo);
    tblArticulos.setText(fila, _i.FECHAPEDIDO, util.dateAMDtoDMA(fechaPedido));
    tblArticulos.setText(fila, _i.STOCKACTUAL, qryArticulos.value("s.cantidad"));
    tblArticulos.setText(fila, _i.STOCKMIN, stockMinimo);
    tblArticulos.setText(fila, _i.STOCKMAX, stockMaximo);
    tblArticulos.setText(fila, _i.PEDIR, cantidad);
    tblArticulos.setText(fila, _i.IDSTOCK, idStock);
    _i.incluirDatosExtraFila(fila, qryArticulos);
    fila++;
  }

  AQUtil.setProgress(qryArticulos.size());
  AQUtil.destroyProgressDialog();

  if (cursor.valueBuffer("agrupar") == "Proveedor (Usar fecha mínima)") {
    if (!_i.agruparPedidos()) {
      MessageBox.warning(sys.translate("Hubo un error al agrupar los pedidos por las fechas mínimas de pedido y rotura"), MessageBox.Ok, MessageBox.NoButton);
    }
  } else if (cursor.valueBuffer("agrupar") == "Proveedor y F.Pedido/F.Rotura") {
    if (!_i.numerarPedidosFecha()) {
      MessageBox.warning(sys.translate("Hubo un error al asignar número a los pedidos"), MessageBox.Ok, MessageBox.NoButton);
    }
  } else {
    if (!_i.numerarPedidosArticulo()) {
      MessageBox.warning(sys.translate("Hubo un error al asignar número a los pedidos"), MessageBox.Ok, MessageBox.NoButton);
    }
  }

  _i.estado = "Seleccionando";
  _i.gestionEstado();

  if (tblArticulos.numRows() == 0) {
    this.child("pushButtonAccept").enabled = false;
  }
}

function oficial_incluirDatosExtraFila(fila, qryArticulos)
{
  return true;
}

function oficial_consultaBusqueda()
{
  var _i = this.iface;
  var cursor: FLSqlCursor = this.cursor();
  var miWhere;
  if (cursor.isNull("idpedidocli")) {
    miWhere = _i.construirWhere();
  } else {
    miWhere = _i.construirWherePedidoCli();
  }
  if (!miWhere) {
    return false;
  }
  var oB = _i.dameOrderBy();
  if (oB && oB != "") {
    miWhere += " ORDER BY " + oB;
  }

  var qryArticulos = new FLSqlQuery;
  with(qryArticulos) {
    setTablesList("articulos,articulosprov,stocks,proveedores");
    setSelect("ap.codproveedor, p.nombre, a.referencia, a.descripcion, a.stockmin, a.stockmax, ap.plazo, s.cantidad, s.idstock");
    setFrom("articulos a LEFT OUTER JOIN articulosprov ap ON a.referencia = ap.referencia LEFT OUTER JOIN proveedores p ON (ap.codproveedor = p.codproveedor  AND ap.pordefecto) LEFT OUTER JOIN stocks s ON a.referencia = s.referencia");
    setWhere(miWhere);
    setForwardOnly(true);
  }
  if (!qryArticulos.exec()) {
    return false;
  }

  return qryArticulos;
}

function oficial_numerarPedidosFecha()
{
  var _i = this.iface;
  var tblArticulos = this.child("tblArticulos");
  var totalFilas = tblArticulos.numRows();
  var numPedido = 1;
  for (var fila = 0; fila < totalFilas; fila++) {
    if (tblArticulos.text(fila, _i.NUMPEDIDO) != "") {
      continue;
    }
    tblArticulos.setText(fila, _i.NUMPEDIDO, numPedido);
    for (var f2 = fila + 1; f2 < totalFilas; f2++) {
      if (tblArticulos.text(fila, _i.CODPROVEEDOR) == tblArticulos.text(f2, _i.CODPROVEEDOR) && tblArticulos.text(fila, _i.FECHAPEDIDO) == tblArticulos.text(f2, _i.FECHAPEDIDO) && tblArticulos.text(fila, _i.FECHAROTURA) == tblArticulos.text(f2, _i.FECHAROTURA)) {
        tblArticulos.setText(f2, this.iface.NUMPEDIDO, numPedido);
      }
    }
    numPedido++;
  }
  return true;
}

function oficial_numerarPedidosArticulo()
{
  var _i = this.iface;
  var tblArticulos = this.child("tblArticulos");
  var totalFilas = tblArticulos.numRows();
  var numPedido = 1;
  for (var fila = 0; fila < totalFilas; fila++) {
    tblArticulos.setText(fila, _i.NUMPEDIDO, numPedido);
    numPedido++;
  }
  return true;
}

function oficial_agruparPedidos()
{
  var _i = this.iface;
  var codProveedor;
  var codProveedorPrevio;
  var filaInicioP;
  var fechaPedidoMin, fechaRoturaMin, fechaPedido, fechaRotura;
  var numPedido = 0;

  var tblArticulos = this.child("tblArticulos");
  var totalFilas = tblArticulos.numRows();

  for (var fila = 0; fila < totalFilas; fila++) {
    codProveedor = tblArticulos.text(fila, _i.CODPROVEEDOR);
    if (codProveedor != codProveedorPrevio) {
      if (codProveedorPrevio) {
        if (!_i.cambiarFechas(fechaPedidoMin, fechaRoturaMin, filaInicioP, fila - 1, numPedido)) {
          return false;
        }
      }
      filaInicioP = fila;
      codProveedorPrevio = codProveedor;
      fechaPedidoMin = false;
      fechaRoturaMin = false;
      numPedido++;
    }
    fechaPedido = AQUtil.dateDMAtoAMD(tblArticulos.text(fila, _i.FECHAPEDIDO));
    fechaRotura = AQUtil.dateDMAtoAMD(tblArticulos.text(fila, _i.FECHAROTURA));
    if (!fechaPedidoMin || AQUtil.daysTo(fechaPedido, fechaPedidoMin) > 0) {
      fechaPedidoMin = fechaPedido;
    }
    if (!fechaRoturaMin || AQUtil.daysTo(fechaRotura, fechaRoturaMin) > 0) {
      fechaRoturaMin = fechaRotura;
    }
  }
  if (!_i.cambiarFechas(fechaPedidoMin, fechaRoturaMin, filaInicioP, totalFilas - 1, numPedido)) {
    return false;
  }
  return true;
}

/** \D Cambia las fechas de pedido y rotura desde una fila hasta otra
@param  fechaPedido: Nueva fecha de pedido
@param  fechaRotura: Nueva fecha de rotura
@param  filaDesde: Fila de inicio en la tabla
@param  filaHasta: Fila de fin en la tabla
\end */
function oficial_cambiarFechas(fechaPedido, fechaRotura, filaDesde, filaHasta, numPedido)
{
  var _i = this.iface;
  var tblArticulos = this.child("tblArticulos");

  var fechaPedPrevia, fechaRotPrevia;
  var indice, cantidad;

  for (var filaPP = filaDesde; filaPP <= filaHasta; filaPP++) {
    if (tblArticulos.text(filaPP, _i.INCLUIR) == "No") {
      continue;
    }
    fechaPedPrevia = AQUtil.dateDMAtoAMD(tblArticulos.text(filaPP, _i.FECHAPEDIDO));
    indice = flfactalma.iface.pub_buscarIndiceAES(fechaPedPrevia, _i.totalDatosES[filaPP]);
    if (indice < 0) {
      return false;
    }
    cantidad = _i.totalDatosES[filaPP][indice]["LPP"];
    _i.totalDatosES[filaPP][indice]["LPP"] = 0;

    indice = flfactalma.iface.pub_buscarIndiceAES(fechaPedido, _i.totalDatosES[filaPP]);
    if (indice < 0) {
      return false;
    }
    _i.totalDatosES[filaPP][indice]["LPP"] = cantidad;
    tblArticulos.setText(filaPP, this.iface.FECHAPEDIDO, AQUtil.dateAMDtoDMA(fechaPedido));

    fechaRotPrevia = AQUtil.dateDMAtoAMD(tblArticulos.text(filaPP, _i.FECHAROTURA));
    indice = flfactalma.iface.pub_buscarIndiceAES(fechaRotPrevia, _i.totalDatosES[filaPP]);
    if (indice < 0) {
      return false;
    }
    cantidad = _i.totalDatosES[filaPP][indice]["RPP"];
    _i.totalDatosES[filaPP][indice]["RPP"] = 0;

    indice = flfactalma.iface.pub_buscarIndiceAES(fechaRotura, _i.totalDatosES[filaPP]);
    if (indice < 0) {
      return false;
    }
    _i.totalDatosES[filaPP][indice]["RPP"] = cantidad;
    tblArticulos.setText(filaPP, _i.FECHAROTURA, AQUtil.dateAMDtoDMA(fechaRotura));

    plazo = tblArticulos.text(filaPP, this.iface.PLAZO)
    if (AQUtil.daysTo(fechaPedido, fechaRotura) < plazo) {
      _i.mensajeTiempoSuficiente("Referencia " + tblArticulos.text(filaPP, _i.REFERENCIA), tblArticulos.text(filaPP, _i.NOMPROVEEDOR), AQUtil.dateAMDtoDMA(fechaRotura));
    }

    tblArticulos.setText(filaPP, _i.NUMPEDIDO, numPedido);
  }
  return true;
}

function oficial_construirWhere()
{
  var _i = this.iface;
  var cursor = this.cursor();

  var where = "a.tipostock <> 'Sin stock'";
  var codProveedor = cursor.valueBuffer("codproveedor");
  if (codProveedor && codProveedor != "") {
    where += " AND ap.codproveedor = '" + codProveedor + "'";
  }

  var referencia = cursor.valueBuffer("referencia");
  if (referencia && referencia != "") {
    where += " AND a.referencia = '" + referencia + "'";
  }

  var codAlmacen = cursor.valueBuffer("codalmacen");
  if (!codAlmacen || codAlmacen == "") {
    MessageBox.warning(AQUtil.translate("scripts", "Debe especificar un almacén"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  where += " AND s.codalmacen = '" + codAlmacen + "'";

  var codFamilia = cursor.valueBuffer("codfamilia");
  if (codFamilia && codFamilia != "") {
    where += " AND a.codfamilia = '" + codFamilia + "'";
  }


  return where;
}

function oficial_dameOrderBy()
{
  return "ap.codproveedor, a.referencia";
}

function oficial_construirWherePedidoCli()
{
  var _i = this.iface;
  var cursor = this.cursor();
  var listaRef: String = "(";
  var subLista: String;

  var qryLineas: FLSqlQuery = new FLSqlQuery;
  with(qryLineas) {
    setTablesList("lineaspedidoscli,movistock,articulos");
    setSelect("ms.idmovimiento, ms.referencia, ms.codlote, a.fabricado");
    setFrom("lineaspedidoscli lp INNER JOIN movistock ms ON lp.idlinea = ms.idlineapc INNER JOIN articulos a ON ms.referencia = a.referencia");
    setWhere("idpedido = " + cursor.valueBuffer("idpedidocli"));
    setForwardOnly(true);
  }
  if (!qryLineas.exec()) {
    return false;
  }

  while (qryLineas.next()) {
    subLista = _i.listaRefPedido(qryLineas);
    if (subLista && subLista != "") {
      if (listaRef != "(") {
        listaRef += ", ";
      }
      listaRef += subLista;
    }
  }
  listaRef += ")";

  if (listaRef == "()") {
    MessageBox.warning(sys.translate("El pedido seleccionado no tiene artículos asociados.\nAsegúrese de que los artículos tienen un proveedor por defecto asociado."), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  var where: String = "a.referencia IN " + listaRef;

  var codAlmacen = cursor.valueBuffer("codalmacen");
  if (!codAlmacen || codAlmacen == "") {
    MessageBox.warning(sys.translate("Debe especificar un almacén"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  where += " AND s.codalmacen = '" + codAlmacen + "'";

  return where;
}

function oficial_listaRefPedido(qryMov)
{
  var _i = this.iface;
  var lista = "", subLista;
  var codLote = qryMov.value("ms.codlote");
  if (!codLote || codLote == "" || !qryMov.value("a.fabricado")) {
    if (lista != "") {
      lista += ", ";
    }
    lista += "'" + qryMov.value("ms.referencia") + "'";
  } else {
    var qryConsumos: FLSqlQuery = new FLSqlQuery;
    with(qryConsumos) {
      setTablesList("movistock,articulos");
      setSelect("ms.idmovimiento, ms.referencia, ms.codlote, a.fabricado");
      setFrom("movistock ms INNER JOIN articulos a ON ms.referencia = a.referencia");
      setWhere("ms.codloteprod = '" + codLote + "'");
      setForwardOnly(true);
    }
    if (!qryConsumos.exec()) {
      return false;
    }
    while (qryConsumos.next()) {
      subLista = _i.listaRefPedido(qryConsumos);
      if (subLista && subLista != "") {
        if (lista != "")
          lista += ", ";
        lista += subLista;
      }
    }
  }
  return lista;
}

/** \D
Elabora un string en el que figuran, los artículos incluidos en la lista. Este string se usará para generar las líneas de pedidos de proveedor.
\end */
function oficial_generarListaArticulos()
{
  var _i = this.iface;
  var valor = true;
  var cursor = this.cursor();
  var tblArticulos = this.child("tblArticulos");

  var xmlDoc = new FLDomDocument;
  xmlDoc.setContent("<RoturaStock/>");
  var eLinea;

  var fila;
  var maxNumPedido = 0;
  var numPedidoActual;
  for (fila = 0; fila < tblArticulos.numRows(); fila++) {
    numPedidoActual = parseFloat(tblArticulos.text(fila, _i.NUMPEDIDO));
    if (!isNaN(numPedidoActual) && numPedidoActual > maxNumPedido) {
      maxNumPedido = tblArticulos.text(fila, _i.NUMPEDIDO);
    }
  }
  for (var numPedido = 1; numPedido <= maxNumPedido; numPedido++) {
    for (fila = 0; fila < tblArticulos.numRows(); fila++) {
      if (tblArticulos.text(fila, _i.INCLUIR) == sys.translate("Sí") && parseFloat(tblArticulos.text(fila, _i.PEDIR)) > 0 && tblArticulos.text(fila, _i.NUMPEDIDO) == numPedido) {
        eLinea = xmlDoc.createElement("Linea");
        eLinea.setAttribute("NumPedido", tblArticulos.text(fila, _i.NUMPEDIDO));
        eLinea.setAttribute("CodProveedor", tblArticulos.text(fila, _i.CODPROVEEDOR));
        eLinea.setAttribute("Referencia", tblArticulos.text(fila, _i.REFERENCIA));
        eLinea.setAttribute("FechaPedido", AQUtil.dateDMAtoAMD(tblArticulos.text(fila, _i.FECHAPEDIDO)));
        eLinea.setAttribute("FechaEntrada", AQUtil.dateDMAtoAMD(tblArticulos.text(fila, _i.FECHAROTURA)));
        eLinea.setAttribute("Cantidad", tblArticulos.text(fila, _i.PEDIR));
        xmlDoc.firstChild().appendChild(eLinea);
      }
    }
  }
  var lista = xmlDoc.toString(4);
  cursor.setValueBuffer("lista", lista);
  return valor;
}

function oficial_tbnEvolStock_clicked()
{
  var _i = this.iface;
  var cursor = this.cursor();

  var tblArticulos = this.child("tblArticulos");
  var filaActual = tblArticulos.currentRow();
  if (filaActual < 0) {
    return;
  }
  var idStock = tblArticulos.text(filaActual , _i.IDSTOCK);
  flfactalma.iface.pub_graficoStock(idStock, false);
}

function oficial_calculoNecesidades()
{
  var _i = this.iface;
  var cursor = this.cursor();

  var tblArticulos = this.child("tblArticulos");
  var filaActual = tblArticulos.currentRow();
  if (filaActual < 0) {
    return;
  }
  var referencia = tblArticulos.text(filaActual, _i.REFERENCIA);
  var codAlmacen = cursor.valueBuffer("codalmacen");
  if (!codAlmacen || codAlmacen == "") {
    return;
  }
  var f = new FLFormSearchDB("calcunecesidades");
  var curCN = f.cursor();

  curCN.select("idusuario = '" + sys.nameUser() + "'");
  if (!curCN.first()) {
    curCN.setModeAccess(curCN.Insert);
  } else {
    curCN.setModeAccess(curCN.Edit);
  }
  f.setMainWidget();
  curCN.refreshBuffer();
  curCN.setValueBuffer("referencia", referencia);
  curCN.setValueBuffer("codalmacen", codAlmacen);

  var acpt = f.exec("id");
  if (acpt) {
    curCN.commitBuffer();
  }
  f.close();
}

function oficial_datosEvolStockActual()
{
  var _i = this.iface;
  if (!_i.totalDatosES) {
    return false;
  }
  return _i.totalDatosES[_i.currentRow_];
}

/** \D Calcula las necesidades de stock y devuelve los datos de los pedidos a realizar
@param datosLinea: Datos de una línea de la tabla
@return Array con los datos del pedido a generar
\end */
function oficial_hayRoturaStock(qryRS)
{
  var _i = this.iface;

  var datosRotura = [];
  var hoy = new Date;
  datosRotura["rotura"] = false;

  var arrayEvolStock = flfactalma.iface.pub_datosEvolStock(false, qryRS.value("referencia"), datosLinea["codalmacen"], hoy.toString(), true);
  if (!arrayEvolStock) {
    return false;
  }
  arrayEvolStock = flfactalma.iface.pub_planificarPedStock(arrayEvolStock, datosLinea["plazo"]);
  if (!arrayEvolStock) {
    return false;
  }
  var idRotura = -1, idPedido = -1;
  for (var i = 0; i < arrayEvolStock.length; i++) {
    if (arrayEvolStock[i]["RPP"] > 0) {
      idRotura = i;
    }
    if (arrayEvolStock[i]["LPP"] > 0) {
      idPedido = i;
    }
  }
  if (idRotura == -1) {
    return datosRotura;
  }
  datosRotura["rotura"] = true;
  datosRotura["cantidad"] = arrayEvolStock[idRotura]["RPP"];
  datosRotura["fecharotura"] = arrayEvolStock[idRotura]["fecha"];
  datosRotura["fechapedido"] = arrayEvolStock[idPedido]["fecha"];

  if (AQUtil.daysTo(datosRotura["fechapedido"], datosRotura["fecharotura"]) < datosLinea["plazo"]) {
    _i.mensajeTiempoSuficiente("Referencia " + datosLinea["referencia"], datosLinea["nombreproveedor"], AQUtil.dateAMDtoDMA(datosRotura["fecharotura"]));
  }
  return datosRotura;
}

function oficial_tbnStock_clicked()
{
  var _i = this.iface;
  var cursor = this.cursor();

  var tblArticulos = this.child("tblArticulos");
  var filaActual = tblArticulos.currentRow();
  if (filaActual < 0) {
    return;
  }
  var referencia = tblArticulos.text(filaActual, _i.REFERENCIA);
  var codAlmacen = cursor.valueBuffer("codalmacen");
  if (!codAlmacen || codAlmacen == "") {
    return;
  }
  var curStock = new FLSqlCursor("stocks");
  curStock.select("referencia = '" + referencia + "' AND codalmacen = '" + codAlmacen + "'");
  if (!curStock.first()) {
    return;
  }
  curStock.browseRecord();
}

function oficial_mensajeTiempoSuficiente(articulo, proveedor, fecha)
{
  MessageBox.warning(sys.translate("%1:\nNo hay tiempo suficiente para recibir el material del proveedor %2 antes de la fecha de rotura (%3)").arg(articulo).arg(proveedor).arg(fecha), MessageBox.Ok, MessageBox.NoButton);
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
