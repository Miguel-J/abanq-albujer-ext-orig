/***************************************************************************
                 asociarlineaspedido.qs  -  description
                             -------------------
    begin                : mar oct 30 2007
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
  var tblPedidos: Object;
  var tblLineasPedidos: Object;
  var tblLineasAlbaran: Object;
  function oficial(context)
  {
    interna(context);
  }
  function actualizarTablas()
  {
    return this.ctx.oficial_actualizarTablas();
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
  function filtrarLineasPedido()
  {
    return this.ctx.oficial_filtrarLineasPedido();
  }
  function filtrarPedidos()
  {
    return this.ctx.oficial_filtrarPedidos();
  }
  function filtrarLineasAlbaran()
  {
    return this.ctx.oficial_filtrarLineasAlbaran();
  }
  function bufferChanged(fN: String)
  {
    return this.ctx.oficial_bufferChanged(fN);
  }
  function habilitarDeshabilitarBotones()
  {
    return this.ctx.oficial_habilitarDeshabilitarBotones();
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
/** \C
Este formulario realiza la gestión de las líneas de albaranes a proveedores.
\end */
function interna_init()
{
  var util: FLUtil = new FLUtil();
  var cursor: FLSqlCursor = this.cursor();

  this.iface.pbnAddT = this.child("pbnAddT");
  this.iface.pbnAddU = this.child("pbnAddU");
  this.iface.pbnDelT = this.child("pbnDelT");
  this.iface.pbnDelU = this.child("pbnDelU");
  this.iface.tblPedidos = this.child("tblPedidos");
  this.iface.tblLineasPedidos = this.child("tblLineasPedidos");
  this.iface.tblLineasAlbaran = this.child("tblLineasAlbaran");

  this.iface.tblPedidos.setReadOnly(true);
  this.iface.tblLineasPedidos.setReadOnly(true);
  this.iface.tblLineasAlbaran.setReadOnly(true);

  connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");
  connect(this.iface.pbnAddT, "clicked()", this, "iface.anadirTodas");
  connect(this.iface.pbnAddU, "clicked()", this, "iface.anadirUna");
  connect(this.iface.pbnDelT, "clicked()", this, "iface.borrarTodas");
  connect(this.iface.pbnDelU, "clicked()", this, "iface.borrarUna");
  connect(this.iface.tblPedidos.cursor(), "newBuffer()", this, "iface.filtrarLineasPedido");
  connect(this.iface.tblLineasAlbaran.cursor(), "newBuffer()", this, "iface.habilitarDeshabilitarBotones");
  connect(this.iface.tblLineasAlbaran.cursor(), "bufferCommited()", this, "iface.actualizarTablas");

  this.iface.actualizarTablas();
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_bufferChanged(fN: String)
{
  switch (fN) {
    case "referencia": {
      this.iface.actualizarTablas();
      break;
    }
  }
}

function oficial_actualizarTablas()
{
  this.iface.filtrarPedidos();
  this.iface.filtrarLineasPedido();
  this.iface.filtrarLineasAlbaran();

}

function oficial_anadirTodas()
{
  var idPedido: Number = this.iface.tblPedidos.cursor().valueBuffer("idpedido");
  if (!idPedido)
    return;

  var referencia: String = this.cursor().valueBuffer("referencia");
  var masWhere: String = "";
  if (referencia && referencia != "")
    masWhere += " AND referencia = '" + referencia + "'";

  var query: FLSqlQuery = new FLSqlQuery();
  query.setTablesList("lineaspedidosprov");
  query.setSelect("idlinea");
  query.setFrom("lineaspedidosprov");
  query.setWhere("idpedido = " + idPedido + " and cantidad > totalenalbaran" + masWhere);
  if (!query.exec())
    return false;

  while (query.next())
    this.iface.anadirUna(query.value("idlinea"));

  this.iface.actualizarTablas();
}

function oficial_anadirUna(idLineaPedido: Number)
{
  var util: FLUtil;
  var idAlbaran: Number = this.cursor().valueBuffer("idalbaran");
  if (!idAlbaran)
    return;

  if (!idLineaPedido)
    idLineaPedido = this.iface.tblLineasPedidos.cursor().valueBuffer("idlinea");

  if (!idLineaPedido) {
    MessageBox.warning(util.translate("scripts", "No hay ninguna línea seleccionada"), MessageBox.Ok, MessageBox.NoButton);
    return;
  }

  var curLineaPedido: FLSqlCursor = new FLSqlCursor("lineaspedidosprov");
  curLineaPedido.select("idlinea = " + idLineaPedido);
  if (!curLineaPedido.first())
    return;
  curLineaPedido.setModeAccess(curLineaPedido.Edit)
  curLineaPedido.refreshBuffer();
  var cantidad: Number = curLineaPedido.valueBuffer("cantidad");
  var idLineaAlbaran: Number = formpedidosprov.iface.copiaLineaPedido(curLineaPedido, idAlbaran);
  if (!idLineaAlbaran)
    return false;

  var codSerieAlbaran: String = util.sqlSelect("albaranesprov", "codserie", "idalbaran = " + idAlbaran);
  var sinIva: Boolean = util.sqlSelect("series", "siniva", "codserie = '" + codSerieAlbaran + "'");
  var ivaLineaAlbaran: String = util.sqlSelect("lineasalbaranesprov", "iva", "idlinea = " + idLineaAlbaran);
  if (sinIva && ivaLineaAlbaran != 0 && ivaLineaAlbaran) {
    if (!util.sqlUpdate("lineasalbaranesprov", "codimpuesto,iva", "NULL,0", "idlinea = " + idLineaAlbaran))
      return false;
  }
  if (!sinIva && !ivaLineaAlbaran) {
    var codImpuesto: String = util.sqlSelect("articulos", "codimpuesto", "referencia = '" + curLineaPedido.valueBuffer("referencia") + "'");
    if (codImpuesto && codImpuesto != "") {
      var fecha: String = util.dateAMDtoDMA(util.sqlSelect("albaranesprov", "fecha", "idalbaran = " + idAlbaran));
      var iva: Number = flfacturac.iface.pub_campoImpuesto("iva", codImpuesto, fecha);
      if (iva && iva != 0) {
        if (!util.sqlUpdate("lineasalbaranesprov", "codimpuesto,iva", codImpuesto + "," + iva, "idlinea = " + idLineaAlbaran))
          return false;
      }
    }
  }
  curLineaPedido.setValueBuffer("totalenalbaran", cantidad);
  if (!curLineaPedido.commitBuffer())
    return false;

  this.iface.actualizarTablas();
}

function oficial_borrarTodas()
{
  var idAlbaran: Number = this.cursor().valueBuffer("idalbaran");
  if (!idAlbaran)
    return;

  var query: FLSqlQuery = new FLSqlQuery();
  query.setTablesList("lineasalbaranesprov");
  query.setSelect("idlinea");
  query.setFrom("lineasalbaranesprov");
  query.setWhere("idalbaran = " + idAlbaran + " AND idlineapedido IS NOT NULL");
  if (!query.exec())
    return false;

  while (query.next())
    this.iface.borrarUna(query.value("idlinea"));

  this.iface.actualizarTablas();
}

function oficial_borrarUna(idLineaAlbaran: Number)
{
  var util: FLUtil;
  if (!idLineaAlbaran)
    idLineaAlbaran = this.iface.tblLineasAlbaran.cursor().valueBuffer("idlinea");

  if (!idLineaAlbaran) {
    MessageBox.warning(util.translate("scripts", "No hay ninguna línea seleccionada"), MessageBox.Ok, MessageBox.NoButton);
    return;
  }

  var idLineaPedido: Number = parseFloat(util.sqlSelect("lineasalbaranesprov", "idlineapedido", "idlinea = " + idLineaAlbaran));
  if (!idLineaPedido)
    return false;

  var cantidadAlbaran: Number = parseFloat(util.sqlSelect("lineasalbaranesprov", "cantidad", "idlinea = " + idLineaAlbaran));

  var curLineaPedido: FLSqlCursor = new FLSqlCursor("lineaspedidosprov");
  curLineaPedido.select("idlinea = " + idLineaPedido);
  if (!curLineaPedido.first())
    return;
  curLineaPedido.setModeAccess(curLineaPedido.Edit)
  curLineaPedido.refreshBuffer();
  var totalEnAlbaran: Number = parseFloat(curLineaPedido.valueBuffer("totalenalbaran"));
  if (!util.sqlDelete("lineasalbaranesprov", "idlinea = " + idLineaAlbaran))
    return false;
  curLineaPedido.setValueBuffer("totalenalbaran", (totalEnAlbaran - cantidadAlbaran));
  if (!curLineaPedido.commitBuffer())
    return false;

  this.iface.actualizarTablas();
}

function oficial_filtrarPedidos()
{
  var codProveedor: String = this.cursor().valueBuffer("codproveedor");
  if (!codProveedor || codProveedor == "")
    return;

  var referencia: String = this.cursor().valueBuffer("referencia");
  var masWhere: String = "";
  if (referencia && referencia != "")
    masWhere += " AND referencia = '" + referencia + "'";

  this.iface.tblPedidos.cursor().setMainFilter("codproveedor = '" + codProveedor + "' AND idpedido  IN (SELECT idpedido FROM lineaspedidosprov WHERE cantidad > totalenalbaran" + masWhere + ")");
  this.iface.tblPedidos.refresh();
}

function oficial_filtrarLineasPedido()
{
  var idPedido: Number = this.iface.tblPedidos.cursor().valueBuffer("idpedido");
  if (!idPedido) {
    this.iface.tblLineasPedidos.cursor().setMainFilter("1 = 2");
    return;
  }

  var referencia: String = this.cursor().valueBuffer("referencia");
  var masWhere: String = "";
  if (referencia && referencia != "")
    masWhere += " AND referencia = '" + referencia + "'";

  this.iface.tblLineasPedidos.cursor().setMainFilter("idpedido = " + idPedido + " AND cantidad > totalenalbaran" + masWhere);
  this.iface.tblLineasPedidos.refresh();
}

function oficial_filtrarLineasAlbaran()
{
  var idAlbaran: Number = this.cursor().valueBuffer("idalbaran");
  if (!idAlbaran)
    return;

  this.iface.tblLineasAlbaran.cursor().setMainFilter("idalbaran = " + idAlbaran);
  this.iface.tblLineasAlbaran.refresh();
}

function oficial_habilitarDeshabilitarBotones()
{
  var idLineaAlbaran: Number = this.iface.tblLineasAlbaran.cursor().valueBuffer("idlinea");

  if (!idLineaAlbaran)
    return;

  var idLineaPedido: Number = this.iface.tblLineasAlbaran.cursor().valueBuffer("idlineapedido");
  if (!idLineaPedido)
    this.iface.pbnDelU.enabled = false;
  else
    this.iface.pbnDelU.enabled = true;
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
