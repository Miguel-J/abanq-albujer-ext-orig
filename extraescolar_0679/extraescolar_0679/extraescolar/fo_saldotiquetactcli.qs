/***************************************************************************
                 fo_saldotiquetactcli.qs  -  description
                             -------------------
    begin                : mie may 05 2011
    copyright            : (C) 2004-2011 by InfoSiAL S.L.
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
    return this.ctx.interna_init();
  }
  function calculateField(fN)
  {
    return this.ctx.interna_calculateField(fN);
  }
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna
{
  var COL_FECHA: Number;
  var COL_CANTIDAD: Number;
  var COL_ACUMULADO: Number;
  var COL_ORIGEN: Number;
  var COL_DESORIGEN: Number;
  var COL_DOCUMENTO: Number;
  var COL_IDDOCUMENTO: Number;
  var listaMovimientos_: Array;
  var tblMovimientos: Object;
  var filaMovActual_: Number;
  function oficial(context)
  {
    interna(context);
  }
  function bufferChanged(fN: String)
  {
    return this.ctx.oficial_bufferChanged(fN);
  }
  function commonCalculateField(fN, cursor)
  {
    return this.ctx.oficial_commonCalculateField(fN, cursor);
  }
  function calcularMovimientos()
  {
    return this.ctx.oficial_calcularMovimientos();
  }
  function cargarListaMovimientos()
  {
    return this.ctx.oficial_cargarListaMovimientos();
  }
  function crearMovimiento(qryMovimientos, factor, origen)
  {
    return this.ctx.oficial_crearMovimiento(qryMovimientos, factor, origen);
  }
  function tblMovimientos_currentChanged(row, col)
  {
    return this.ctx.oficial_tblMovimientos_currentChanged(row, col);
  }
  function tbnVerDocumento_clicked()
  {
    return this.ctx.oficial_tbnVerDocumento_clicked();
  }
  function mostrarDocumento(fila, col)
  {
    return this.ctx.oficial_mostrarDocumento(fila, col);
  }
  function descripcionOrigen(origen)
  {
    return this.ctx.oficial_descripcionOrigen(origen);
  }
  function dameIdDocumento(origen, qryMovimientos)
  {
    return this.ctx.oficial_dameIdDocumento(origen, qryMovimientos);
  }
  function cargarFacturasCli()
  {
    return this.ctx.oficial_cargarFacturasCli();
  }
  function cargarAsistencias()
  {
    return this.ctx.oficial_cargarAsistencias();
  }
  function mostrarListaMovimientos()
  {
    return this.ctx.oficial_mostrarListaMovimientos();
  }
  function insertarLineaTabla(indice)
  {
    return this.ctx.oficial_insertarLineaTabla(indice);
  }
  function compararMovimientos(mov1, mov2)
  {
    return this.ctx.oficial_compararMovimientos(mov1, mov2);
  }
  function generarTabla()
  {
    return this.ctx.oficial_generarTabla();
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
  function pub_commonCalculateField(fN, cursor)
  {
    return this.commonCalculateField(fN, cursor);
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
  this.iface.tblMovimientos = this.child("tblMovimientos");

  connect(this.child("tbnVerDocumento"), "clicked()", this, "iface.tbnVerDocumento_clicked");
  connect(this.iface.tblMovimientos, "doubleClicked(int, int)", this, "iface.mostrarDocumento");
  connect(this.iface.tblMovimientos, "currentChanged(int, int)", this, "iface.tblMovimientos_currentChanged");

  this.iface.generarTabla();
  this.iface.calcularMovimientos();
}

function interna_calculateField(fN)
{
  var cursor: FLSqlCursor = this.cursor();
  return this.iface.commonCalculateField(fN, cursor);
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_commonCalculateField(fN, cursor)
{
  var util: FLUtil = new FLUtil;
  var valor;
  switch (fN) {
    case "saldo": {
      valor = parseFloat(cursor.valueBuffer("comprado")) - parseFloat(cursor.valueBuffer("usado"));
      break;
    }
    case "comprado": {
      var referencia = util.sqlSelect("fo_actividades", "refasistenciaesp", "codactividad = '" + cursor.valueBuffer("codactividad") + "'");
      if (!referencia) {
        return false;
      }
      valor = util.sqlSelect("facturascli f INNER JOIN lineasfacturascli lf ON f.idfactura = lf.idfactura", "SUM(lf.cantidad)", "f.codcliente = '" + cursor.valueBuffer("codcliente") + "' AND lf.referencia = '" + referencia + "'", "lineasfacturascli,facturascli");
      if (!valor || isNaN(valor)) {
        valor = 0;
      }
      break;
    }
    case "usado": {
      valor = util.sqlSelect("fo_asistenciaact aa INNER JOIN fo_alumnos a ON aa.codalumno = a.codalumno ", "COUNT(aa.id)", "a.codcliente = '" + cursor.valueBuffer("codcliente") + "' AND aa.codactividad = '" + cursor.valueBuffer("codactividad") + "' AND aa.asistencia = 'E'", "fo_asistenciaact,fo_alumnos");
      if (!valor || isNaN(valor)) {
        valor = 0;
      }
      break;
    }
  }
  debug("valor " + valor);
  return valor;
}

function oficial_calcularMovimientos()
{
  var util: FLUtil = new FLUtil;

  if (this.iface.listaMovimientos_) {
    delete this.iface.listaMovimientos_
  }
  this.iface.listaMovimientos_ = [];

  if (!this.iface.cargarListaMovimientos()) {
    MessageBox.warning(util.translate("scripts", "Error al cargar la lista de movimientos"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }

  if (!this.iface.mostrarListaMovimientos()) {
    MessageBox.warning(util.translate("scripts", "Error al mostrar la lista de movimientos"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  return true;
}

function oficial_cargarListaMovimientos()
{
  var util: FLUtil = new FLUtil;
  //  if (!this.iface.cargarUltReg()) {
  //    MessageBox.warning(util.translate("scripts", "Error al cargar el movimiento de última regularización"), MessageBox.Ok, MessageBox.NoButton);
  //    return false;
  //  }
  if (!this.iface.cargarFacturasCli()) {
    MessageBox.warning(util.translate("scripts", "Error al cargar los movimientos de facturas de cliente"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  if (!this.iface.cargarAsistencias()) {
    MessageBox.warning(util.translate("scripts", "Error al cargar los movimientos de asistencia"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  return true;
}

function oficial_crearMovimiento(qryMovimientos, factor, origen)
{
  var util: FLUtil = new FLUtil;
  var campoCodigo: String;
  var campoCantidad: String;
  var campoFecha;
  var cantidad;
  switch (origen) {
    case "AS": {
      campoCodigo = "d.id";
      campoFecha = "d.fecha";
      cantidad = 1;
      break;
    }
    default: {
      campoCodigo = "d.codigo";
      campoCantidad = "ld.cantidad";
      campoFecha = "d.fecha";
    }
  }
  var fecha = qryMovimientos.value(campoFecha)
  if (cantidad == undefined) {
    cantidad = parseFloat(qryMovimientos.value(campoCantidad));
  }
  cantidad = cantidad * factor;
  var codigo: String = qryMovimientos.value(campoCodigo);
  if (!codigo) {
    codigo = "";
  }
  debug("Fecha movimiento = " + fecha.toString() + " / " + fecha.getTime());
  var movimiento: Array = [];
  movimiento["fecha"] = util.dateAMDtoDMA(fecha);
  movimiento["msec"] = fecha.getTime();
  movimiento["cantidad"] = cantidad;
  movimiento["origen"] = origen;
  movimiento["desorigen"] = this.iface.descripcionOrigen(origen);
  movimiento["documento"] = " " + codigo;
  movimiento["iddocumento"] = this.iface.dameIdDocumento(origen, qryMovimientos);
  return movimiento;
}

function oficial_tblMovimientos_currentChanged(row, col)
{
  this.iface.filaMovActual_ = row;
}

function oficial_tbnVerDocumento_clicked()
{
  this.iface.mostrarDocumento(this.iface.filaMovActual_, false);
}

function oficial_mostrarDocumento(fila, col)
{
  var curDocumento: FLSqlCursor;
  var origen: String = this.iface.tblMovimientos.text(fila, this.iface.COL_ORIGEN);
  var idDocumento: String = this.iface.tblMovimientos.text(fila, this.iface.COL_IDDOCUMENTO);
  switch (origen) {
    case "AS": {
      curDocumento = new FLSqlCursor("fo_asistenciaact");
      curDocumento.select("id = " + idDocumento);
      break;
    }
    case "FC": {
      curDocumento = new FLSqlCursor("facturascli");
      curDocumento.select("idfactura = " + idDocumento);
      break;
    }
    default: {
      return;
    }
  }
  if (curDocumento && curDocumento.first()) {
    curDocumento.browseRecord();
  }
}

function oficial_descripcionOrigen(origen)
{
  var util: FLUtil = new FLUtil;
  var descripcion: String = "";
  switch (origen) {
    case "AS": {
      descripcion = util.translate("scripts", "Asistencia");
      break;
    }
    case "FC": {
      descripcion = util.translate("scripts", "Fra.Cliente");
      break;
    }
  }
  return descripcion;
}

function oficial_dameIdDocumento(origen, qryMovimientos)
{
  var util: FLUtil = new FLUtil;
  var idDocumento: String = "";
  switch (origen) {
    case "AS": {
      idDocumento = qryMovimientos.value("d.id");
      break;
    }
    case "FC": {
      idDocumento = qryMovimientos.value("d.idfactura");
      break;
    }
  }
  return idDocumento;
}

function oficial_cargarFacturasCli()
{
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  var referencia = util.sqlSelect("fo_actividades", "refasistenciaesp", "codactividad = '" + cursor.valueBuffer("codactividad") + "'");
  if (!referencia) {
    return false;
  }

  var qryMovimientos: FLSqlQuery = new FLSqlQuery;
  qryMovimientos.setTablesList("facturascli,lineasfacturascli");
  qryMovimientos.setSelect("d.fecha, ld.cantidad, d.codigo, d.idfactura");
  qryMovimientos.setFrom("facturascli d INNER JOIN lineasfacturascli ld ON d.idfactura = ld.idfactura");
  qryMovimientos.setWhere("d.codcliente = '" + cursor.valueBuffer("codcliente") + "' AND ld.referencia = '" + referencia + "'");
  qryMovimientos.setForwardOnly(true);
  if (!qryMovimientos.exec()) {
    return false;
  }
  var iMovimiento: Number = this.iface.listaMovimientos_.length;
  while (qryMovimientos.next()) {
    this.iface.listaMovimientos_[iMovimiento] = this.iface.crearMovimiento(qryMovimientos, 1, "FC");
    iMovimiento++;
  }
  return true;
}

function oficial_cargarAsistencias()
{
  var util = new FLUtil;
  var cursor = this.cursor();

  var qryMovimientos = new FLSqlQuery;
  qryMovimientos.setTablesList("fo_asistenciaact");
  qryMovimientos.setSelect("d.fecha, d.id");
  qryMovimientos.setFrom("fo_asistenciaact d INNER JOIN fo_alumnos a ON d.codalumno = a.codalumno");
  qryMovimientos.setWhere("a.codcliente = '" + cursor.valueBuffer("codcliente") + "' AND d.codactividad = '" + cursor.valueBuffer("codactividad") + "'  AND d.asistencia = 'E'");
  qryMovimientos.setForwardOnly(true);
  if (!qryMovimientos.exec()) {
    return false;
  }
  var iMovimiento = this.iface.listaMovimientos_.length;
  while (qryMovimientos.next()) {
    this.iface.listaMovimientos_[iMovimiento] = this.iface.crearMovimiento(qryMovimientos, -1, "AS");
    iMovimiento++;
  }
  return true;
}


// function oficial_cargarUltReg():Boolean
// {
//  var util:FLUtil = new FLUtil;
//  var cursor:FLSqlCursor = this.cursor();
//
//  if (!cursor.isNull("fechaultreg")) {
//    var iMovimiento:Number = this.iface.listaMovimientos_.length;
//    this.iface.listaMovimientos_[iMovimiento] = [];
//
//    var util:FLUtil = new FLUtil;
//    var fecha:Date = cursor.valueBuffer("fechaultreg");
//    var hora:Date = cursor.valueBuffer("horaultreg");
//    fecha.setHours(hora.getHours());
//    fecha.setMinutes(hora.getMinutes());
//    fecha.setSeconds(hora.getSeconds());
//
//    var cantidad:Number = parseFloat(cursor.valueBuffer("cantidadultreg"));
//    var origen:String = "RS";
//    var movimiento:Array = [];
//    this.iface.listaMovimientos_[iMovimiento]["fecha"] = util.dateAMDtoDMA(fecha);
//    this.iface.listaMovimientos_[iMovimiento]["hora"] = fecha.toString().right(8);
//    this.iface.listaMovimientos_[iMovimiento]["msec"] = fecha.getTime();
//    this.iface.listaMovimientos_[iMovimiento]["cantidad"] = cantidad;
//    this.iface.listaMovimientos_[iMovimiento]["origen"] = origen;
//    this.iface.listaMovimientos_[iMovimiento]["desorigen"] = this.iface.descripcionOrigen(origen);
//    this.iface.listaMovimientos_[iMovimiento]["documento"] = "-";
//    this.iface.listaMovimientos_[iMovimiento]["iddocumento"] = 0;
//  }
//  return true;
// }

function oficial_mostrarListaMovimientos()
{
  var util: FLUtil = new FLUtil;
  this.iface.listaMovimientos_.sort(this.iface.compararMovimientos);

  var numFilas: Number = this.iface.tblMovimientos.numRows();
  for (fila = numFilas - 1; fila >= 0 ; fila--) {
    this.iface.tblMovimientos.removeRow(fila);
  }

  for (var i: Number = 0; i < this.iface.listaMovimientos_.length; i++) {
    debug(this.iface.listaMovimientos_[i]["fecha"] + " - " + this.iface.listaMovimientos_[i]["cantidad"] + " - " + this.iface.listaMovimientos_[i]["origen"] + " - " + this.iface.listaMovimientos_[i]["documento"] + " - " + this.iface.listaMovimientos_[i]["msec"]);
    if (!this.iface.insertarLineaTabla(i)) {
      return false;
    }
  }
  return true;
}

function oficial_insertarLineaTabla(indice)
{
  var util: FLUtil = new FLUtil;
  var acumulado: Number = 0;
  if (indice > 0) {
    acumulado = parseFloat(this.iface.tblMovimientos.text((indice - 1), this.iface.COL_ACUMULADO));
  }
  var cantidad: Number = parseFloat(this.iface.listaMovimientos_[indice]["cantidad"]);
  acumulado += cantidad;

  cantidad = util.roundFieldValue(cantidad, "stocks", "cantidad");
  acumulado = util.roundFieldValue(acumulado, "stocks", "cantidad");

  this.iface.tblMovimientos.insertRows(indice);
  this.iface.tblMovimientos.setText(indice, this.iface.COL_FECHA, this.iface.listaMovimientos_[indice]["fecha"]);
  this.iface.tblMovimientos.setText(indice, this.iface.COL_DESORIGEN, this.iface.listaMovimientos_[indice]["desorigen"]);
  this.iface.tblMovimientos.setText(indice, this.iface.COL_DOCUMENTO, this.iface.listaMovimientos_[indice]["documento"]);
  this.iface.tblMovimientos.setText(indice, this.iface.COL_CANTIDAD, cantidad);
  this.iface.tblMovimientos.setText(indice, this.iface.COL_ACUMULADO, acumulado);
  this.iface.tblMovimientos.setText(indice, this.iface.COL_IDDOCUMENTO, this.iface.listaMovimientos_[indice]["iddocumento"]);
  this.iface.tblMovimientos.setText(indice, this.iface.COL_ORIGEN, this.iface.listaMovimientos_[indice]["origen"]);
  return true;
}

function oficial_compararMovimientos(mov1, mov2)
{
  debug("Comparando " + mov1["fecha"] + " / " + mov1["msec"] + " con " + mov2["fecha"] + " / " + mov2["msec"]);
  var resultado: Number;
  if (mov1["msec"] > mov2["msec"]) {
    resultado = 1;
  } else if (mov1["msec"] < mov2["msec"]) {
    resultado = -1;
  } else {
    resultado = 0;
  }
  return resultado;
}

function oficial_generarTabla()
{
  this.iface.COL_FECHA = 0;
  this.iface.COL_CANTIDAD = 1;
  this.iface.COL_ACUMULADO = 2;
  this.iface.COL_DESORIGEN = 3;
  this.iface.COL_DOCUMENTO = 4;
  this.iface.COL_ORIGEN = 5;
  this.iface.COL_IDDOCUMENTO = 6;

  this.iface.tblMovimientos.setNumCols(7);
  this.iface.tblMovimientos.setColumnWidth(this.iface.COL_FECHA, 100);
  this.iface.tblMovimientos.setColumnWidth(this.iface.COL_CANTIDAD, 100);
  this.iface.tblMovimientos.setColumnWidth(this.iface.COL_ACUMULADO, 100);
  this.iface.tblMovimientos.setColumnWidth(this.iface.COL_ORIGEN, 100);
  this.iface.tblMovimientos.setColumnWidth(this.iface.COL_DOCUMENTO, 120);
  this.iface.tblMovimientos.setColumnLabels("/", "Fecha/Cantidad/Saldo/Origen/Documento");
  this.iface.tblMovimientos.hideColumn(this.iface.COL_ORIGEN);
  this.iface.tblMovimientos.hideColumn(this.iface.COL_IDDOCUMENTO);
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
