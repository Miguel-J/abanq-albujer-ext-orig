/***************************************************************************
                 pr_asociarordenesprod.qs  -  description
                             -------------------
    begin                : jue nov 08 2007
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
  var pbnAddT: Object;
  var pbnAddU: Object;
  var pbnDelT: Object;
  var pbnDelU: Object;
  var pbnFiltrar: Object;
  var tblTodas: Object;
  var tblSeleccionadas: Object;
  var codOrdenCorte: String;
  function oficial(context)
  {
    interna(context);
  }
  function anadirTodas()
  {
    return this.ctx.oficial_anadirTodas();
  }
  function anadirUna(idLineaPedido: Number)
  {
    return this.ctx.oficial_anadirUna(idLineaPedido);
  }
  function borrarTodas()
  {
    return this.ctx.oficial_borrarTodas();
  }
  function borrarUna(idLineaAlbaran: Number)
  {
    return this.ctx.oficial_borrarUna(idLineaAlbaran);
  }
  function filtrarOrdenes()
  {
    return this.ctx.oficial_filtrarOrdenes();
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

/** @class_declaration ifaceCtx*/
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
  var util: FLUtil = new FLUtil();
  var cursor: FLSqlCursor = this.cursor();

  this.iface.pbnAddT = this.child("pbnAddT");
  this.iface.pbnAddU = this.child("pbnAddU");
  this.iface.pbnDelT = this.child("pbnDelT");
  this.iface.pbnDelU = this.child("pbnDelU");
  this.iface.tblTodas = this.child("tblTodas");
  this.iface.pbnFiltrar = this.child("pbnFiltrar");
  this.iface.tblSeleccionadas = this.child("tblSeleccionadas");

  this.iface.tblTodas.setReadOnly(true);
  this.iface.tblSeleccionadas.setReadOnly(true);

  this.iface.codOrdenCorte = "OC00000001";
  var codUltima: String = util.sqlSelect("pr_ordenesproduccion", "codorden", "codorden LIKE 'OC%' ORDER BY codorden DESC");
  if (codUltima) {
    var numUltima: Number = parseFloat(codUltima.right(8));
    this.iface.codOrdenCorte = "OC" + flfactppal.iface.pub_cerosIzquierda((++numUltima).toString(), 8);
  }

  cursor.setValueBuffer("idordencorte", this.iface.codOrdenCorte);

  this.iface.tblSeleccionadas.cursor().setMainFilter("tipoorden = 'P' AND codordencorte = '" + this.iface.codOrdenCorte + "'");
  this.iface.tblSeleccionadas.refresh();

  connect(this.iface.pbnAddT, "clicked()", this, "iface.anadirTodas");
  connect(this.iface.pbnAddU, "clicked()", this, "iface.anadirUna");
  connect(this.iface.pbnDelT, "clicked()", this, "iface.borrarTodas");
  connect(this.iface.pbnDelU, "clicked()", this, "iface.borrarUna");
  connect(this.iface.pbnFiltrar, "clicked()", this, "iface.filtrarOrdenes");

  this.iface.filtrarOrdenes();
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_anadirTodas()
{
  var util: FLUtil;
  var filtro: Number = this.iface.tblTodas.cursor().mainFilter();

  if (!util.sqlUpdate("pr_ordenesproduccion", "codordencorte", this.iface.codOrdenCorte, filtro))
    return;

  this.iface.tblTodas.refresh();
  this.iface.tblSeleccionadas.refresh();

  if (this.iface.tblSeleccionadas.cursor().size() != 0)
    this.child("gbxFiltros").enabled = false;
  else
    this.child("gbxFiltros").enabled = true;
}

function oficial_anadirUna(idLineaPedido: Number)
{
  var util: FLUtil;
  var codOrden: Number = this.iface.tblTodas.cursor().valueBuffer("codorden");
  if (!codOrden || codOrden == "")
    return;

  if (!util.sqlUpdate("pr_ordenesproduccion", "codordencorte", this.iface.codOrdenCorte, "codorden = '" + codOrden + "'"))
    return;

  this.iface.tblTodas.refresh();
  this.iface.tblSeleccionadas.refresh();

  if (this.iface.tblSeleccionadas.cursor().size() == 0)
    this.child("gbxFiltros").enabled = false;
  else
    this.child("gbxFiltros").enabled = true;
}

function oficial_borrarTodas()
{
  var util: FLUtil;
  var filtro: Number = this.iface.tblSeleccionadas.cursor().mainFilter();

  if (!util.sqlUpdate("pr_ordenesproduccion", "codordencorte", "NULL", filtro))
    return;

  this.iface.tblTodas.refresh();
  this.iface.tblSeleccionadas.refresh();

  if (this.iface.tblSeleccionadas.cursor().size() != 0)
    this.child("gbxFiltros").enabled = false;
  else
    this.child("gbxFiltros").enabled = true;
}

function oficial_borrarUna(idLineaAlbaran: Number)
{
  var util: FLUtil;
  var codOrden: Number = this.iface.tblSeleccionadas.cursor().valueBuffer("codorden");
  if (!codOrden || codOrden == "")
    return;

  if (!util.sqlUpdate("pr_ordenesproduccion", "codordencorte", "NULL", "codorden = '" + codOrden + "'"))
    return;

  this.iface.tblTodas.refresh();
  this.iface.tblSeleccionadas.refresh();

  if (this.iface.tblSeleccionadas.cursor().size() != 0)
    this.child("gbxFiltros").enabled = false;
  else
    this.child("gbxFiltros").enabled = true;
}

function oficial_filtrarOrdenes()
{
  var util: FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  var ordenDesde: String = cursor.valueBuffer("idordendesde");
  var ordenHasta: String = cursor.valueBuffer("idordenhasta");
  var fechaDesde: Date = cursor.valueBuffer("fechadesde");
  var fechaHasta: Date = cursor.valueBuffer("fechahasta");
  var codRuta: String = cursor.valueBuffer("codruta");

  var filtro: String = "tipoorden = 'P' AND (codordencorte IS NULL OR codordencorte = '')";

  if (ordenDesde && ordenDesde != "")
    filtro += " AND codorden >= '" + ordenDesde + "'";

  if (ordenHasta && ordenHasta != "")
    filtro += " AND codorden <= '" + ordenHasta + "'";

  if (fechaDesde && fechaDesde != "")
    filtro += " AND fecha >= '" + fechaDesde + "'";

  if (fechaHasta && fechaHasta != "")
    filtro += " AND fecha <= '" + fechaHasta + "'";

  if (codRuta && codRuta != "")
    filtro += " AND codruta = '" + codRuta + "'";

  this.iface.tblTodas.cursor().setMainFilter(filtro);
  this.iface.tblTodas.refresh();
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
