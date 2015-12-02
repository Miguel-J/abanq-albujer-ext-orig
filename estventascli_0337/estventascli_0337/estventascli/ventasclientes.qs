/***************************************************************************
                 ventasclientes.qs  -  description
                             -------------------
    begin                : lun abr 26 2004
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
  var tblVentas: QTable;
  function oficial(context)
  {
    interna(context);
  }
  function loadVentas()
  {
    return this.ctx.oficial_loadVentas();
  }
  function clickedVenta(fil: Number, col: Number)
  {
    return this.ctx.oficial_clickedVenta(fil, col);
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
  this.iface.tblVentas = this.child("tblVentas");

  connect(this.iface.tblVentas, "doubleClicked(int,int)", this, "iface.clickedVenta");
  this.iface.loadVentas();
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////

function oficial_loadVentas()
{
  var cursor: FLSqlCursor = this.cursor();
  var codCliente: String = cursor.valueBuffer("codcliente");
  var referencia: String = cursor.valueBuffer("referencia");
  var util: FLUtil = new FLUtil();

  var fila: Number = 0;

  var q: FLSqlQuery = new FLSqlQuery();
  q.setTablesList("albaranescli,lineasalbaranescli");
  q.setFrom("albaranescli a inner join lineasalbaranescli l on a.idalbaran = l.idalbaran");
  q.setSelect("a.fecha,a.codigo,l.pvpunitario,l.cantidad,l.pvptotal");
  q.setWhere("a.codcliente = '" + codCliente + "' AND referencia = '" + referencia + "' order by a.fecha");

  if (!q.exec())
    return;

  util.createProgressDialog(util.translate("scripts", "Cargando datos de ventas"), q.size());

  this.iface.tblVentas.clear();
  while (q.next()) {

    this.iface.tblVentas.insertRows(fila, 1);

    this.iface.tblVentas.setText(fila, 0, util.dateAMDtoDMA(q.value(0)));
    this.iface.tblVentas.setText(fila, 1, q.value(1));
    this.iface.tblVentas.setText(fila, 2, q.value(2));
    this.iface.tblVentas.setText(fila, 3, q.value(3));
    this.iface.tblVentas.setText(fila, 4, q.value(4));

    util.setProgress(fila++);
  }

  util.destroyProgressDialog();
}

function oficial_clickedVenta(fil: Number, col: Number)
{
  var curTab: FLSqlCursor = new FLSqlCursor("albaranescli");
  var codAlbaran: String = this.iface.tblVentas.text(fil, 1);

  curTab.select("codigo = '" + codAlbaran + "'");
  if (curTab.first())
    curTab.browseRecord();
}

//// OFICIAL /////////////////////////////////////////////////
////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
