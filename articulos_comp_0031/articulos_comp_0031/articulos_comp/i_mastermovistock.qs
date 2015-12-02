/***************************************************************************
                 i_mastermovistock.qs  -  description
                             -------------------
    begin                : vie abr 26 2013
    copyright            : (C) 2013 by InfoSiAL S.L.
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
  var stock_;
  var regularizaciones_;
  var iRegularizada_;
  var cantRegularizada_;
  var totalEntradas_;
  var totalSalidas_;
  function oficial(context)
  {
    interna(context);
  }
  function lanzar()
  {
    return this.ctx.oficial_lanzar();
  }
  function obtenerParamInforme()
  {
    return this.ctx.oficial_obtenerParamInforme();
  }
  function actualizaCantidadInicial()
  {
    return this.ctx.oficial_actualizaCantidadInicial();
  }
  function dameCantidadInicial()
  {
    return this.ctx.oficial_dameCantidadInicial();
  }
  function dameCantidadParcial(nodo, campo)
  {
    return this.ctx.oficial_dameCantidadParcial(nodo, campo);
  }
  function dameCantidadRegularizada()
  {
    return this.ctx.oficial_dameCantidadRegularizada();
  }
  function obtenerRegularizaciones()
  {
    return this.ctx.oficial_obtenerRegularizaciones();
  }
  function dameStockParcial(nodo, campo)
  {
    return this.ctx.oficial_dameStockParcial(nodo, campo);
  }
  function dameCantidadMovimiento(nodo, campo)
  {
    return this.ctx.oficial_dameCantidadMovimiento(nodo, campo);
  }
  function dameTotalCantidades(nodo, campo)
  {
    return this.ctx.oficial_dameTotalCantidades(nodo, campo);
  }
  function dameFecha(nodo, campo)
  {
    return this.ctx.oficial_dameFecha(nodo, campo);
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
  connect(this.child("toolButtonPrint"), "clicked()", this, "iface.lanzar()");
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_lanzar()
{
  var _i = this.iface;
  var cursor = this.cursor();

  var pI = this.iface.obtenerParamInforme();
  if (!pI) {
    return;
  }

  _i.stock_ = _i.actualizaCantidadInicial();
  _i.obtenerRegularizaciones();

  _i.totalEntradas_ = 0;
  _i.totalSalidas_ = 0;

  flfactinfo.iface.pub_lanzaInforme(cursor, pI);
}

/** \D Obtiene un array con los parámetros necesarios para establecer el informe
@return array de parámetros o false si hay error
\end */
function oficial_obtenerParamInforme()
{
  var cursor = this.cursor();
  var seleccion = cursor.valueBuffer("id");
  if (!seleccion) {
    return false;
  }
  var paramInforme = flfactinfo.iface.pub_dameParamInforme();
  paramInforme.nombreInforme = "i_movistock";
  paramInforme.whereFijo = "movistock.estado = 'HECHO'";

  return paramInforme;
}

function oficial_actualizaCantidadInicial()
{
  var _i = this.iface;
  var cursor = this.cursor();

  var stockRef = cursor.valueBuffer("i_stocks_referencia");
  var stockAlma = cursor.valueBuffer("i_stocks_codalmacen");
  var stockDesde = cursor.valueBuffer("d_movistock_fechareal");

  var curStock = new FLSqlCursor("stocks");

  var stockId = AQUtil.sqlSelect("stocks", "idstock", "referencia = '" + stockRef + "' AND codalmacen = '" + stockAlma + "'");
  curStock.setValueBuffer("idstock", stockId);
  if (!stockId) {
    return 0;
  }
  curStock.select("idstock = " + stockId);
  if (!curStock.first()) {
    return false;
  }

  var oP = new Object;
  oP.fechaMax = stockDesde;
  var cantidad = formRecordregstocks.iface.pub_commonCalculateField("cantidad", curStock, oP);

  return cantidad;
}

function oficial_dameCantidadParcial(nodo, campo)
{
  var _i = this.iface;

  var cantidadMov = nodo.attributeValue("movistock.cantidad");

  _i.stock_ = parseFloat(_i.stock_) + parseFloat(cantidadMov);

  return _i.stock_;
}

function oficial_dameCantidadRegularizada()
{
  var _i = this.iface;

  if (_i.cantRegularizada_ == 0) {
    return "";
  }

  var c = AQUtil.roundFieldValue(_i.cantRegularizada_, "movistock", "cantidad");
  var cantidadReg = "* (" + c + ")";

  return cantidadReg;
}

function oficial_dameCantidadInicial()
{
  var _i = this.iface;

  return _i.stock_;
}

function oficial_obtenerRegularizaciones()
{
  var _i = this.iface;
  var cursor = this.cursor();

  var stockRef = cursor.valueBuffer("i_stocks_referencia");
  var stockAlma = cursor.valueBuffer("i_stocks_codalmacen");
  var stockDesde = cursor.valueBuffer("d_movistock_fechareal");
  var stockHasta = cursor.valueBuffer("h_movistock_fechareal");

  var q = new AQSqlQuery;
  q.setSelect("l.fecha, l.hora, l.cantidadfin");
  q.setFrom("stocks s LEFT OUTER JOIN lineasregstocks l ON s.idstock = l.idstock");
  q.setWhere("s.referencia = '" + stockRef + "' AND s.codalmacen = '" + stockAlma + "' AND fecha < '" + stockHasta + "' AND fecha > '" + stockDesde + "' ORDER BY fecha, hora");
  if (!q.exec()) {
    return false;
  }
  var i = 0;
  var s, d;
  _i.regularizaciones_ = [];
  while (q.next()) {
    _i.regularizaciones_[i] = new Object;
    _i.regularizaciones_[i]["fecha"] = q.value("l.fecha");
    _i.regularizaciones_[i]["hora"] = q.value("l.hora");
    s = q.value("l.fecha").toString().left(10) + "T" + q.value("l.hora").toString().right(8);
    d = new Date(Date.parse(s));
    _i.regularizaciones_[i]["tiempo"] = d.getTime();
    _i.regularizaciones_[i]["cantidad"] = q.value("l.cantidadfin");
    i++;
  }
  _i.iRegularizada_ = -1;
}

function oficial_dameStockParcial(nodo, campo)
{
  var _i = this.iface;

  var fecha = nodo.attributeValue("movistock.fechareal");
  var hora = nodo.attributeValue("movistock.horareal");

  var s = fecha.toString().left(10) + "T" + hora.toString().right(8);
  var d = new Date(Date.parse(s));
  var tiempoMov = d.getTime();

  var nuevaI = -5;
  for (var i = _i.iRegularizada_ + 1; i < _i.regularizaciones_.length; i++) {
    if (tiempoMov > _i.regularizaciones_[i]["tiempo"]) {
      nuevaI = i;
    } else {
      break;
    }
  }
  if (nuevaI == -5) {
    _i.cantRegularizada_ = 0;
    return _i.dameCantidadParcial(nodo, campo);
  }
  _i.iRegularizada_ = nuevaI;
  _i.cantRegularizada_ = _i.regularizaciones_[nuevaI]["cantidad"];
  _i.stock_ = _i.regularizaciones_[nuevaI]["cantidad"];
  var cp = _i.dameCantidadParcial(nodo, campo);
  return cp;
}

function oficial_dameCantidadMovimiento(nodo, campo)
{
  var _i = this.iface;

  var cant = nodo.attributeValue("movistock.cantidad");

  if (cant > 0 && campo == "entrada") {
    _i.totalEntradas_ = parseFloat(_i.totalEntradas_) + parseFloat(cant);
    return cant;
  } else if (cant < 0 && campo == "salida") {
    _i.totalSalidas_ = parseFloat(_i.totalSalidas_) + parseFloat(cant * (-1));
    return cant * (-1);
  } else {
    return "";
  }
}

function oficial_dameTotalCantidades(nodo, campo)
{
  var _i = this.iface;

  if (campo == "entrada") {
    return _i.totalEntradas_;
  } else {
    return _i.totalSalidas_;
  }
}

function oficial_dameFecha(nodo, campo)
{
  var _i = this.iface;
  var cursor = this.cursor();

  var fecha;

  if (campo == "desde") {
    fecha = cursor.valueBuffer("d_movistock_fechareal");
  } else {
    fecha = cursor.valueBuffer("h_movistock_fechareal");
  }

  var dia = fecha.getDate();
  var mes = fecha.getMonth();
  var anio = fecha.getYear();

  if (dia < 10) {
    dia = "0" + dia;
  }

  if (mes < 10) {
    mes = "0" + mes;
  }

  fecha = dia + "-" + mes + "-" + anio;

  return fecha;
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
