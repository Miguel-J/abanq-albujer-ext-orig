/***************************************************************************
                 pedidoscliparciales.qs  -  description
                             -------------------
    begin                : vie ene 18 2008
    copyright            : (C) 2008 by InfoSiAL S.L.
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
  var tdbLineasPedidosCli: Object;
  var tbnAbrirCerrar: Object;
  function oficial(context)
  {
    interna(context);
  }
  function incluirExcluir()
  {
    return this.ctx.oficial_incluirExcluir();
  }
  function limpiaLineas()
  {
    return this.ctx.oficial_limpiaLineas();
  }
  function ordenarCols()
  {
    return this.ctx.oficial_ordenarCols();
  }
  function incluirParcial()
  {
    return this.ctx.oficial_incluirParcial();
  }
  function lineaServida(curLinea)
  {
    return this.ctx.oficial_lineaServida(curLinea);
  }
  function incluirLineaAlbaran(curLinea, canAlbaran)
  {
    return this.ctx.oficial_incluirLineaAlbaran(curLinea, canAlbaran);
  }
  function incluir(parcial: Boolean): Boolean {
    return this.ctx.oficial_incluir(parcial);
  }
  function calcularTotales()
  {
    return this.ctx.oficial_calcularTotales();
  }
  function incluirTodos()
  {
    return this.ctx.oficial_incluirTodos();
  }
  function abrirCerrarLinea()
  {
    return this.ctx.oficial_abrirCerrarLinea();
  }
  function calculaSiIncluirLinea(incluir, curLineas)
  {
    return this.ctx.oficial_calculaSiIncluirLinea(incluir, curLineas);
  }
  function datosIncluirLinea(curLinea)
  {
    return this.ctx.oficial_datosIncluirLinea(curLinea);
  }
  function datosLimpiarLinea(curLinea)
  {
    return this.ctx.oficial_datosLimpiarLinea(curLinea);
  }
  function datosAbrirCerrarLinea(curLinea)
  {
    return this.ctx.oficial_datosAbrirCerrarLinea(curLinea);
  }
  function maxCantidadAIncluir(curLineas)
  {
    return this.ctx.oficial_maxCantidadAIncluir(curLineas);
  }
  function dameCantidadParcial(curLinea)
  {
    return this.ctx.oficial_dameCantidadParcial(curLinea);
  }
  function colorCantidad(fN, fV, cursor, fT, sel)
  {
    return this.ctx.oficial_colorCantidad(fN, fV, cursor, fT, sel);
  }
  function saltarLineaInclusion(curLineas)
  {
    return this.ctx.oficial_saltarLineaInclusion(curLineas);
  }
  function pbnExcluir_clicked()
  {
    return this.ctx.oficial_pbnExcluir_clicked();
  }
  function pbnExcluirTodos_clicked()
  {
    return this.ctx.oficial_pbnExcluirTodos_clicked();
  }
  function datosExcluirLinea(curLinea)
  {
    return this.ctx.oficial_datosExcluirLinea(curLinea);
  }
  function pbnExcluirTodos_clicked()
  {
    return this.ctx.oficial_pbnExcluirTodos_clicked();
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
  function pub_colorCantidad(fN, fV, cursor, fT, sel)
  {
    return this.colorCantidad(fN, fV, cursor, fT, sel);
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
Este formulario realiza la gestión de los pedidos de clientes.

Los pedidos pueden ser generados de forma manual o a partir de un presupuesto previo.
\end */
function interna_init()
{
  var _i = this.iface;
  var util = new FLUtil();
  var cursor = this.cursor();

  this.iface.tdbLineasPedidosCli = this.child("tdbLineasPedidosCli");
  this.iface.tbnAbrirCerrar = this.child("tbnAbrirCerrar");

  connect(this.child("pbnIncluir"), "clicked()", this, "iface.incluirExcluir");
  connect(this.child("pbnExcluir"), "clicked()", _i, "pbnExcluir_clicked");
  connect(this.child("pbnIncluirParcial"), "clicked()", this, "iface.incluirParcial");
  connect(this.child("pbnIncluirTodos"), "clicked()", this, "iface.incluirTodos");
  connect(this.child("pbnExcluirTodos"), "clicked()", _i, "pbnExcluirTodos_clicked");
  connect(this.iface.tbnAbrirCerrar, "clicked()", this, "iface.abrirCerrarLinea()");

  _i.ordenarCols();

  var idPedido = cursor.valueBuffer("idpedido");
  if (idPedido) {
    _i.limpiaLineas();
  }

  this.iface.tdbLineasPedidosCli.refresh();

  connect(this.child("tdbLineasPedidosCli").cursor(), "bufferCommited()", this, "iface.calcularTotales()");
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_pbnExcluir_clicked()
{
  var _i = this.iface;
  var curLinea = _i.tdbLineasPedidosCli.cursor();
  if (!curLinea.isValid()) {
    return false;
  }
  if (!curLinea.valueBuffer("incluiralbaran")) {
    return true;
  }
  with(curLinea) {
    setModeAccess(Edit);
    refreshBuffer();
    setValueBuffer("incluiralbaran", false);
    setValueBuffer("canalbaran", 0);
  }
  if (!_i.datosExcluirLinea(curLinea)) {
    return false;
  }
  if (!curLinea.commitBuffer()) {
    return false;
  }
  _i.tdbLineasPedidosCli.refresh();
  return true;
}

function oficial_pbnExcluirTodos_clicked()
{
  var _i = this.iface;
  var curLineas = _i.tdbLineasPedidosCli.cursor();
  if (!curLineas.first()) {
    return;
  }
  var cantidad, servida, cerrada;

  var idPedido = curLineas.valueBuffer("idpedido");
  var incluir = false;

  do {
    cantidad = parseFloat(curLineas.valueBuffer("cantidad"));
    servida = parseFloat(curLineas.valueBuffer("totalenalbaran"));
    cerrada = curLineas.valueBuffer("cerrada");

    if (cantidad == servida || cerrada) {
      continue;
    }
    curLineas.setModeAccess(curLineas.Edit);
    curLineas.refreshBuffer();
    curLineas.setValueBuffer("incluiralbaran", incluir);
    curLineas.setValueBuffer("canalbaran", 0);
    if (!_i.datosExcluirLinea(curLineas)) {
      return false;
    }
    if (!curLineas.commitBuffer()) {
      return false;
    }
  } while (curLineas.next());
  _i.tdbLineasPedidosCli.refresh();
}

function oficial_datosExcluirLinea(curLinea)
{
  return true;
}

function oficial_ordenarCols()
{
  var _i = this.iface;
  var lineas = ["referencia", "descripcion", "cantidad", "totalenalbaran", "cerrada", "incluiralbaran", "canalbaran"];
  _i.tdbLineasPedidosCli.setOrderCols(lineas);
}

function oficial_limpiaLineas()
{
  var _i = this.iface;
  var cursor = this.cursor();

  var curLinea = new FLSqlCursor("lineaspedidoscli");
  curLinea.setActivatedCommitActions(false);
  curLinea.select("idpedido = " + cursor.valueBuffer("idpedido"));
  while (curLinea.next()) {
    curLinea.setModeAccess(curLinea.Edit);
    curLinea.refreshBuffer();
    curLinea.setValueBuffer("incluiralbaran", false);
    curLinea.setValueBuffer("canalbaran", 0);
    if (!_i.datosLimpiarLinea(curLinea)) {
      return false;
    }
    if (!curLinea.commitBuffer()) {
      return false;
    }
  }
  return true;
}

function oficial_incluirExcluir()
{
  this.iface.incluir(false);
}

function oficial_incluir(parcial)
{
  var util = new FLUtil;
  var _i = this.iface;

  var curLinea = this.iface.tdbLineasPedidosCli.cursor();
  if (!curLinea.isValid()) {
    return false;
  }
  var cantidad = parseFloat(curLinea.valueBuffer("cantidad"));
  var servida = parseFloat(curLinea.valueBuffer("totalenalbaran"));
  var cerrada = curLinea.valueBuffer("cerrada");
  if (_i.lineaServida(curLinea)) {
    MessageBox.warning(sys.translate("La línea seleccionada ya está servida"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  if (cerrada) {
    MessageBox.warning(util.translate("scripts", "La línea seleccionada está cerrada"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }

  var canAlbaran;
  curLinea.setModeAccess(curLinea.Edit);
  curLinea.refreshBuffer();
  if (parcial) {
    canAlbaran = _i.dameCantidadParcial(curLinea);
    if (!canAlbaran) {
      return false;
    }
  } else {
    canAlbaran = _i.maxCantidadAIncluir(curLinea); //cantidad - servida;
  }
  curLinea.setValueBuffer("incluiralbaran", _i.incluirLineaAlbaran(curLinea, canAlbaran));
  curLinea.setValueBuffer("canalbaran", canAlbaran);
  if (!_i.datosIncluirLinea(curLinea)) {
    return false;
  }
  if (!curLinea.commitBuffer()) {
    return false;
  }
  _i.tdbLineasPedidosCli.refresh();
}

function oficial_incluirLineaAlbaran(curLinea, canAlbaran)
{
  return canAlbaran ? true : false;
}


function oficial_lineaServida(curLinea)
{
  var cantidad = parseFloat(curLinea.valueBuffer("cantidad"));
  var servida = parseFloat(curLinea.valueBuffer("totalenalbaran"));
  return (cantidad == servida);
}


function oficial_datosIncluirLinea(curLinea)
{
  return true;
}
function oficial_datosLimpiarLinea(curLinea)
{
  return true;
}
function oficial_datosAbrirCerrarLinea(curLinea)
{
  return true;
}


function oficial_incluirParcial()
{
  this.iface.incluir(true);
}

/** \U
Calcula los campos que son resultado de una suma de las líneas de pedido
\end */
function oficial_calcularTotales()
{
  var cursor: FLSqlCursor = this.cursor();
  this.child("fdbNeto").setValue(formpedidoscli.iface.pub_commonCalculateField("neto", cursor));
  this.child("fdbTotalIva").setValue(formpedidoscli.iface.pub_commonCalculateField("totaliva", cursor));
  this.child("fdbTotalRecargo").setValue(formpedidoscli.iface.pub_commonCalculateField("totalrecargo", cursor));
  this.child("fdbTotalIrpf").setValue(formpedidoscli.iface.pub_commonCalculateField("totalirpf", cursor));
  this.child("fdbTotal").setValue(formpedidoscli.iface.pub_commonCalculateField("total", cursor));
}

function oficial_incluirTodos()
{
  var _i = this.iface;
  var util: FLUtil;
  var curLineas: FLSqlCursor = this.iface.tdbLineasPedidosCli.cursor();
  if (!curLineas.first())
    return;

  var cantidad: Number;
  var servida, canAlbaran;
  var cerrada: Boolean;

  var idPedido = curLineas.valueBuffer("idpedido");
  var incluir = true;

  do {
    cantidad = parseFloat(curLineas.valueBuffer("cantidad"));
    servida = parseFloat(curLineas.valueBuffer("totalenalbaran"));
    cerrada = curLineas.valueBuffer("cerrada");

    if (cantidad == servida || cerrada) {
      continue;
    }
    curLineas.setModeAccess(curLineas.Edit);
    curLineas.refreshBuffer();
    canAlbaran = _i.maxCantidadAIncluir(curLineas);
    curLineas.setValueBuffer("incluiralbaran", _i.calculaSiIncluirLinea(incluir, curLineas))
    curLineas.setValueBuffer("canalbaran", canAlbaran);
    if (!_i.datosIncluirLinea(curLineas)) {
      return false;
    }
    if (!curLineas.commitBuffer()) {
      return false;
    }

  } while (curLineas.next());
  _i.tdbLineasPedidosCli.refresh();
}

function oficial_calculaSiIncluirLinea(incluir, curLineas)
{
  var _i = this.iface;
  var canAlbaran = _i.maxCantidadAIncluir(curLineas);
  return (incluir && canAlbaran);
}

function oficial_abrirCerrarLinea()
{
  var _i = this.iface;
  var util: FLUtil;
  var curPedido = this.cursor();
  var cursor = this.iface.tdbLineasPedidosCli .cursor();

  var idLinea = cursor.valueBuffer("idlinea");
  if (!idLinea) {
    MessageBox.warning(util.translate("scripts", "No hay ningún registro seleccionado"), MessageBox.Ok, MessageBox.NoButton);
    return;
  }

  var cerrar: Boolean = true;
  var res: Number;
  if (util.sqlSelect("lineaspedidoscli", "cerrada", "idlinea = " + idLinea + " AND cerrada")) {
    cerrar = false;
    res = MessageBox.information(util.translate("scripts", "La linea seleccionada está cerrada.\n¿Seguro que desea abrirla?"), MessageBox.Yes, MessageBox.No);
  } else {
    if (cursor.valueBuffer("cantidad") == cursor.valueBuffer("totalenalbaran")) {
      MessageBox.warning(util.translate("scripts", "La línea ya ha sido servida completamente."), MessageBox.Ok, MessageBox.NoButton);
      return;
    }
    res = MessageBox.information(util.translate("scripts", "Se va a cerrar la línea y no podrá terminar de servirse.\n¿Desea continuar?"), MessageBox.Yes, MessageBox.No);
  }
  if (res != MessageBox.Yes)
    return;

  var curLinea = new FLSqlCursor("lineaspedidoscli");
  curLinea.select("idlinea = " + idLinea);
  if (!curLinea.first()) {
    return false;
  }
  curLinea.setModeAccess(curLinea.Edit);
  curLinea.refreshBuffer();
  curLinea.setValueBuffer("cerrada", cerrar);
  if (!_i.datosAbrirCerrarLinea(curLinea)) {
    return false;
  }
  if (!curLinea.commitBuffer()) {
    return false;
  }

  var idPedido = curPedido.valueBuffer("idpedido"); //AQUtil.sqlSelect("lineaspedidoscli","idpedido","idlinea = " + idLinea);
  if (!flfacturac.iface.pub_actualizarEstadoPedidoCli(idPedido)) {
    return;
  }

  this.iface.tdbLineasPedidosCli.refresh();
}

function oficial_maxCantidadAIncluir(curLineas)
{
  var cantidad = parseFloat(curLineas.valueBuffer("cantidad"));
  var servida = parseFloat(curLineas.valueBuffer("totalenalbaran"));
  return cantidad - servida;
}

function oficial_dameCantidadParcial(curLinea)
{
  var cantidad = parseFloat(curLinea.valueBuffer("cantidad"));
  var servida = parseFloat(curLinea.valueBuffer("totalenalbaran"));
  return Input.getNumber(sys.translate("Indique la cantidad"), cantidad - servida, 2, 0);
}

function oficial_colorCantidad(fN, fV, cursor, fT, sel)
{
  if (!flfactppal.iface.pub_dameColor) {
    return;
  }
  var _i = this.iface;
  if (fN != "canalbaran") {
    return;
  }
  cantidad = parseFloat(cursor.valueBuffer("totalenalbaran")) + parseFloat(cursor.valueBuffer("canalbaran"))
             var color = "";
  if (cantidad > cursor.valueBuffer("cantidad")) {
    color = flfactppal.iface.pub_dameColor("fondo_rojo");
  } else if (cantidad == cursor.valueBuffer("cantidad")) {
    color = flfactppal.iface.pub_dameColor("fondo_verde");
  } else if (cantidad > 0) {
    color = flfactppal.iface.pub_dameColor("fondo_amarillo");
  }
  if (color != "") {
    var a = [color, "#000000", "SolidPattern", "SolidPattern"];
    return a;
  }
}

function oficial_saltarLineaInclusion(curLineas)
{
  var cantidad = parseFloat(curLineas.valueBuffer("cantidad"));
  var servida = parseFloat(curLineas.valueBuffer("totalenalbaran"));
  var cerrada = curLineas.valueBuffer("cerrada");
  return (cantidad == servida || cerrada);
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
