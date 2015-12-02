/**************************************************************************
                 pagorecibosremesados.qs  -  description
                             -------------------
    begin                : lun jun 09 2008
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
  var tbnIncluirQuitar: Object;
  var tbnIncluirQuitarUno: Object;
  var tbnActualizar: Object;
  var date: Object;
  var tdbRecibos: Object;
  var tbnGenerarPagos: Object;
  function oficial(context)
  {
    interna(context);
  }
  function actualizaListaRecibos()
  {
    return this.ctx.oficial_actualizaListaRecibos();
  }
  function aceptarFormulario()
  {
    return this.ctx.oficial_aceptarFormulario();
  }
  function incluirQuitarTodos()
  {
    return this.ctx.oficial_incluirQuitarTodos();
  }
  function incluirQuitarUno()
  {
    return this.ctx.oficial_incluirQuitarUno();
  }
  function estadoBotones()
  {
    return this.ctx.oficial_estadoBotones();
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
  this.iface.tbnIncluirQuitar = this.child("tbnIncluirQuitar");
  this.iface.tbnIncluirQuitarUno = this.child("tbnIncluirQuitarUno");
  this.iface.tbnActualizar = this.child("tbnActualizar");
  this.iface.date = this.child("date");
  this.iface.tdbRecibos = this.child("tdbRecibos");
  this.iface.tbnGenerarPagos = this.child("tbnGenerarPagos");

  this.child("pushButtonAccept").close();

  connect(this.iface.tdbRecibos, "currentChanged()", this, "iface.estadoBotones()");
  connect(this.iface.tbnActualizar, "clicked()", this, "iface.actualizaListaRecibos()");
  connect(this.iface.tbnIncluirQuitar, "clicked()", this, "iface.incluirQuitarTodos()");
  connect(this.iface.tbnIncluirQuitarUno, "clicked()", this, "iface.incluirQuitarUno()");
  connect(this.iface.tbnGenerarPagos, "clicked()", this, "iface.aceptarFormulario()");

  var hoy: Date = new Date();
  this.iface.date.date = hoy;
  var util: FLUtil;
  util.sqlUpdate("reciboscli", "pagar", false, "1=1");
  var listaCampos: Array = ["codigo", "pagar"];
  this.iface.tdbRecibos.setOrderCols(listaCampos);
  this.iface.actualizaListaRecibos();
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_actualizaListaRecibos()
{
  var fecha: String = this.iface.date.date.toString();

  this.iface.tdbRecibos.cursor().setMainFilter("fechav <= '" + fecha + "' AND estado = 'Remesado'");
  this.iface.tdbRecibos.refresh();
}

function oficial_aceptarFormulario()
{
  //  var recibos:String = this.iface.tdbRecibos.primarysKeysChecked().toString();
  var util: FLUtil;
  var recibos: String = "";
  var fecha: String = this.iface.date.date.toString();

  var qryRecibos: FLSqlQuery = new FLSqlQuery;
  qryRecibos.setTablesList("reciboscli");
  qryRecibos.setSelect("idrecibo")
  qryRecibos.setFrom("reciboscli")
  qryRecibos.setWhere("fechav <= '" + fecha + "' AND estado = 'Remesado' AND pagar");
  qryRecibos.setForwardOnly(true);
  if (!qryRecibos.exec())
    return;

  while (qryRecibos.next()) {
    if (recibos != "")
      recibos += ",";
    recibos += qryRecibos.value("idrecibo");
  }

  this.cursor().setValueBuffer("recibos", recibos);

  util.sqlUpdate("reciboscli", "pagar", false, "1=1");
  this.child("pushButtonAccept").animateClick();
}

function oficial_estadoBotones()
{
  if (this.iface.tdbRecibos.cursor().valueBuffer("pagar")) {
    this.iface.tbnIncluirQuitarUno.on = true;
    this.iface.tbnIncluirQuitarUno.text = "Quitar &uno";
  } else {
    this.iface.tbnIncluirQuitarUno.on = false;
    this.iface.tbnIncluirQuitarUno.text = "Incluir &uno";
  }


  var fecha: String = this.iface.date.date.toString();
  var util: FLUtil;
  if (!util.sqlSelect("reciboscli", "idrecibo", "fechav <= '" + fecha + "' AND estado = 'Remesado' AND pagar")) {
    this.iface.tbnIncluirQuitar.on = false;
    this.iface.tbnIncluirQuitar.text = "Incluir &todos";
  }

  if (!util.sqlSelect("reciboscli", "idrecibo", "fechav <= '" + fecha + "' AND estado = 'Remesado' AND pagar = false")) {
    this.iface.tbnIncluirQuitar.on = true;
    this.iface.tbnIncluirQuitar.text = "Quitar &todos";
  }
  //  curRecibos.refreshBuffer();
}

function oficial_incluirQuitarTodos()
{
  var util: FLUtil;
  var incluir: Boolean = this.iface.tbnIncluirQuitar.on;

  var texto: String = "";
  if (incluir)
    texto = "Quitar &todos";
  else
    texto = "Incluir &todos";

  this.iface.tbnIncluirQuitar.text = texto;

  var fecha: String = this.iface.date.date.toString();
  var curRecibos: FLSqlCursor = new FLSqlCursor("reciboscli");
  curRecibos.select("fechav <= '" + fecha + "' AND estado = 'Remesado'");
  curRecibos.refreshBuffer();
  while (curRecibos.next()) {
    curRecibos.setModeAccess(curRecibos.Edit);
    curRecibos.refreshBuffer();
    curRecibos.setValueBuffer("pagar", incluir);
    if (!curRecibos.commitBuffer())
      return false;
    //    this.iface.tdbRecibos.setPrimaryKeyChecked(curRecibos.valueBuffer("idrecibo"),incluir);
  }
  this.iface.tdbRecibos.refresh();
  this.iface.estadoBotones();
}

function oficial_incluirQuitarUno()
{
  var util: FLUtil;
  var incluir: Boolean = this.iface.tbnIncluirQuitarUno.on;

  var texto: String = "";
  if (incluir)
    texto = "Quitar &uno";
  else
    texto = "Incluir &uno";

  this.iface.tbnIncluirQuitarUno.text = texto;

  var idRecibo: Number = this.iface.tdbRecibos.cursor().valueBuffer("idrecibo");
  //  this.cursor().setValueBuffer("pagar",incluir);
  var curRecibos: FLSqlCursor = new FLSqlCursor("reciboscli");
  curRecibos.select("idrecibo = " + idRecibo);
  curRecibos.refreshBuffer();
  if (curRecibos.first()) {
    curRecibos.setModeAccess(curRecibos.Edit);
    curRecibos.refreshBuffer();
    curRecibos.setValueBuffer("pagar", incluir);
    if (!curRecibos.commitBuffer())
      return false;
  }
  //  var fecha:String = this.iface.date.date.toString();
  //  var curRecibos:FLSqlCursor = new FLSqlCursor("reciboscli");
  //  curRecibos.select("fechav >= '" + fecha + "' AND estado = 'Remesado'");
  //  curRecibos.refreshBuffer();
  //  while(curRecibos.next()) {
  //    curRecibos.setModeAccess(curRecibos.Edit);
  //    curRecibos.refreshBuffer();
  //    curRecibos.setValueBuffer("pagar",incluir);
  //    if(!curRecibos.commitBuffer())
  //      return false;
  // //     this.iface.tdbRecibos.setPrimaryKeyChecked(curRecibos.valueBuffer("idrecibo"),incluir);
  //  }
  this.iface.tdbRecibos.refresh();
  this.iface.estadoBotones();
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
