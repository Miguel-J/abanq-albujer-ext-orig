/***************************************************************************
                 pedidosprovparciales.qs  -  description
                             -------------------
    begin                : mier oct 24 2007
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
  var tdbLineasPedidosProv: Object;
  function oficial(context)
  {
    interna(context);
  }
  function incluirExcluir()
  {
    return this.ctx.oficial_incluirExcluir();
  }
  function pbnExcluir_clicked()
  {
    return this.ctx.oficial_pbnExcluir_clicked();
  }
  function datosExcluirLinea(curLinea)
  {
    return this.ctx.oficial_datosExcluirLinea(curLinea);
  }
  function incluirParcial()
  {
    return this.ctx.oficial_incluirParcial();
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
  function pbnExcluirTodos_clicked()
  {
    return this.ctx.oficial_pbnExcluirTodos_clicked();
  }
  function abrirCerrarLinea()
  {
    return this.ctx.oficial_abrirCerrarLinea();
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
  function limpiaLineas()
  {
    return this.ctx.oficial_limpiaLineas();
  }
  function ordenarCols()
  {
    return this.ctx.oficial_ordenarCols();
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
Este formulario realiza la gestión de los pedidos de proveedores.

Los pedidos pueden ser generados de forma manual o a partir de un presupuesto previo.
\end */
function interna_init()
{
  var _i = this.iface;
  var util: FLUtil = new FLUtil();
  var cursor: FLSqlCursor = this.cursor();

  this.iface.tdbLineasPedidosProv = this.child("tdbLineasPedidosProv");

  connect(this.child("pbnIncluir"), "clicked()", this, "iface.incluirExcluir");
  connect(this.child("pbnExcluir"), "clicked()", _i, "pbnExcluir_clicked");
  connect(this.child("pbnIncluirParcial"), "clicked()", this, "iface.incluirParcial");
  connect(this.child("pbnIncluirTodos"), "clicked()", this, "iface.incluirTodos");
  connect(this.child("pbnExcluirTodos"), "clicked()", _i, "pbnExcluirTodos_clicked");
  connect(this.child("tbnAbrirCerrar"), "clicked()", this, "iface.abrirCerrarLinea()");

  _i.ordenarCols();

  var idPedido = cursor.valueBuffer("idpedido");
  if (idPedido) {
    _i.limpiaLineas();
  }

  this.iface.tdbLineasPedidosProv.refresh();

  connect(this.child("tdbLineasPedidosProv").cursor(), "bufferCommited()", this, "iface.calcularTotales()");
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_ordenarCols()
{
  var _i = this.iface;
  var lineas: Array = ["referencia", "descripcion", "cantidad", "totalenalbaran", "cerrada", "incluiralbaran", "canalbaran"];
  _i.tdbLineasPedidosProv.setOrderCols(lineas);
}

function oficial_limpiaLineas()
{
  var _i = this.iface;
  var cursor = this.cursor();

  var curLinea = new FLSqlCursor("lineaspedidosprov");
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

function oficial_pbnExcluir_clicked()
{
  var _i = this.iface;
  var curLinea = _i.tdbLineasPedidosProv.cursor();
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
  _i.tdbLineasPedidosProv.refresh();
  return true;
}

function oficial_datosExcluirLinea(curLinea)
{
  return true;
}

function oficial_incluir(parcial)
{
  var _i = this.iface;
  var util = new FLUtil;
  var curLinea = this.iface.tdbLineasPedidosProv.cursor();
  if (!curLinea.isValid()) {
    return false;
  }
  var cantidad = parseFloat(curLinea.valueBuffer("cantidad"));
  var servida = parseFloat(curLinea.valueBuffer("totalenalbaran"));
  var cerrada = curLinea.valueBuffer("cerrada");
  if (cantidad == servida) {
    MessageBox.warning(util.translate("scripts", "La línea seleccionada ya está servida"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  if (cerrada) {
    MessageBox.warning(util.translate("scripts", "La línea seleccionada está cerrada"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  var canAlbaran;
  with(curLinea) {
    setModeAccess(Edit);
    refreshBuffer();
    if (parcial) {
      canAlbaran = Input.getNumber(util.translate("scripts", "Indique la cantidad"), cantidad - servida, 2, 0);
      if (!canAlbaran)
        return false;
    } else {
      canAlbaran = cantidad - servida;
    }
    setValueBuffer("incluiralbaran", true);
    setValueBuffer("canalbaran", canAlbaran);
  }
  if (!_i.datosIncluirLinea(curLinea)) {
    return false;
  }
  if (!curLinea.commitBuffer()) {
    return false;
  }
  this.iface.tdbLineasPedidosProv.refresh();
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
  this.child("fdbNeto").setValue(formpedidosprov.iface.pub_commonCalculateField("neto", cursor));
  this.child("fdbTotalIva").setValue(formpedidosprov.iface.pub_commonCalculateField("totaliva", cursor));
  this.child("fdbTotalRecargo").setValue(formpedidosprov.iface.pub_commonCalculateField("totalrecargo", cursor));
  this.child("fdbTotalIrpf").setValue(formpedidosprov.iface.pub_commonCalculateField("totalirpf", cursor));
  this.child("fdbTotal").setValue(formpedidosprov.iface.pub_commonCalculateField("total", cursor));
}

function oficial_incluirTodos()
{
  var _i = this.iface;
  var curLineas = _i.tdbLineasPedidosProv.cursor();
  if (!curLineas.first()) {
    return;
  }
  var cantidad, servida, cerrada;

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
    curLineas.setValueBuffer("incluiralbaran", incluir);
    curLineas.setValueBuffer("canalbaran", cantidad - servida);
    if (!_i.datosIncluirLinea(curLineas)) {
      return false;
    }
    if (!curLineas.commitBuffer()) {
      return false;
    }

  } while (curLineas.next());
  _i.tdbLineasPedidosProv.refresh();
}

function oficial_pbnExcluirTodos_clicked()
{
  var _i = this.iface;
  var curLineas = _i.tdbLineasPedidosProv.cursor();
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
  _i.tdbLineasPedidosProv.refresh();
}

function oficial_abrirCerrarLinea()
{
  var _i = this.iface;
  var util: FLUtil;
  var curPedido = this.cursor();
  var cursor: FLSqlCursor = this.iface.tdbLineasPedidosProv .cursor();

  var idLinea = cursor.valueBuffer("idlinea");
  if (!idLinea) {
    MessageBox.warning(util.translate("scripts", "No hay ningún registro seleccionado"), MessageBox.Ok, MessageBox.NoButton);
    return;
  }

  var cerrar: Boolean = true;
  var res: Number;
  if (util.sqlSelect("lineaspedidosprov", "cerrada", "idlinea = " + idLinea + " AND cerrada")) {
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

  var curLinea = new FLSqlCursor("lineaspedidosprov");
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
  if (!flfacturac.iface.pub_actualizarEstadoPedidoProv(idPedido))
    return;

  this.iface.tdbLineasPedidosProv.refresh();
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
