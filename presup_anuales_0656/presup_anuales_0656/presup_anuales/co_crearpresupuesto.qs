/***************************************************************************
                 co_crearpresupuesto.qs  -  description
                             -------------------
    begin                : mar ene 24 2012
    copyright            : (C) 2012 by InfoSiAL S.L.
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
  function validateForm(): Boolean {
    return this.ctx.interna_validateForm();
  }
  function calculateField(fN: String): String {
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
  var longSubcuenta;
  var ejercicioActual;
  var bloqueoSubcuenta;
  var bloqueoInicio;
  var posActualPuntoSubcuenta;
  var cPER, cPED, cPEH, cSAL, cSPR;
  var fTOT;
  var t_;

  function oficial(context)
  {
    interna(context);
  }
  function bufferChanged(fN)
  {
    return this.ctx.oficial_bufferChanged(fN);
  }
  function cargaPorEjercicio()
  {
    return this.ctx.oficial_cargaPorEjercicio();
  }
  function validaEjercicio()
  {
    return this.ctx.oficial_validaEjercicio();
  }
  function iniciaTabla()
  {
    return this.ctx.oficial_iniciaTabla();
  }
  function nombrePeriodo(f, periodicidad)
  {
    return this.ctx.oficial_nombrePeriodo(f, periodicidad);
  }
  function cargaSaldos()
  {
    return this.ctx.oficial_cargaSaldos();
  }
  function tblDistribucion_textChanged(f, c)
  {
    return this.ctx.oficial_tblDistribucion_textChanged(f, c);
  }
  function calculaTotal()
  {
    return this.ctx.oficial_calculaTotal();
  }
  function actualizaPartidaFila(f)
  {
    return this.ctx.oficial_actualizaPartidaFila(f);
  }
  function distribuyeTotal()
  {
    return this.ctx.oficial_distribuyeTotal();
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
  var _i = this.iface;
  var cursor = this.cursor();
  _i.t_ = this.child("tblDistribucion");

  this.child("fdbCodEjercicio").setFilter("presupuestario");

  _i.bloqueoSubcuenta = false;
  _i.posActualPuntoSubcuenta = -1;

  if (cursor.modeAccess() == cursor.Edit) {
    _i.cargaPorEjercicio();
  }

  connect(cursor, "bufferChanged(QString)", _i, "bufferChanged");
  connect(_i.t_, "valueChanged(int, int)", _i, "tblDistribucion_textChanged");

  _i.iniciaTabla();
}

function interna_calculateField(fN): String {
  var util = new FLUtil;
  var res;
  var cursor = this.cursor();

  switch (fN)
  {
    case "iva": {
      res = util.sqlSelect("co_subcuentas", "iva", "idsubcuenta = " + cursor.valueBuffer("idsubcuenta"));
      break;
    }
  }

  return res;
}

/** \C La subcuenta establecida debe existir en la tabla de subcuentas
\end */
function interna_validateForm()
{
  var _i = this.iface;

  if (!_i.validaEjercicio()) {
    return false;
  }
  return true;
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_validaEjercicio()
{
  var _i = this.iface;
  var cursor = this.cursor();
  if (!AQUtil.sqlSelect("ejercicios", "presupuestario", "codejercicio = '" + cursor.valueBuffer("codejercicio") + "'")) {
    MessageBox.warning(sys.translate("El ejercicio seleccionado debe ser un ejercicio presupuestario"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return false;
  }
  return true;
}
function oficial_cargaPorEjercicio()
{
  var _i = this.iface;
  var cursor = this.cursor();
  var util = new FLUtil();
  _i.longSubcuenta = util.sqlSelect("ejercicios", "longsubcuenta", "codejercicio = '" + cursor.valueBuffer("codejercicio") + "'");
  this.child("fdbIdSubcuenta").setFilter("codejercicio = '" + cursor.valueBuffer("codejercicio") + "'");
}

function oficial_bufferChanged(fN)
{
  debug("Campo  = " + fN);
  var _i = this.iface;

  switch (fN) {
    case "codejercicio": {
      _i.cargaPorEjercicio();
      _i.iniciaTabla();
      break;
    }
    case "codsubcuenta": {
      if (!_i.bloqueoSubcuenta) {
        _i.bloqueoSubcuenta = true;
        _i.posActualPuntoSubcuenta = flcontppal.iface.pub_formatearCodSubcta(this, "fdbCodSubcuenta", _i.longSubcuenta, _i.posActualPuntoSubcuenta);
        _i.bloqueoSubcuenta = false;
      }
      break;
    }
    case "idsubcuenta": {
      _i.cargaSaldos();
      break;
    }
    case "periodicidad": {
      _i.iniciaTabla();
      break;
    }
  }
}

function oficial_iniciaTabla()
{
  var _i = this.iface;
  var cursor = this.cursor();

  var codEjercicio = cursor.valueBuffer("codejercicio");
  if (!AQUtil.sqlSelect("ejercicios", "codejercicio", "codejercicio = '" + codEjercicio + "'")) {
    return;
  }
  if (!_i.validaEjercicio()) { /// Redundante, por si acaso, para evitar cargarnos un ejercicio de verdad
    return false;
  }

  var t = this.child("tblDistribucion");

  var c = 0, cab = "", sep = "*";
  _i.cPER = c++;
  cab += sys.translate("Período");
  _i.cPED = c++;
  cab += sep;
  cab += sys.translate("Desde");
  _i.cPEH = c++;
  cab += sep;
  cab += sys.translate("Hasta");
  _i.cSAL = c++;
  cab += sep;
  cab += sys.translate("Saldo");
  _i.cSPR = c++;
  cab += sep;
  cab += sys.translate("S.Previo");

  t.setNumCols(c);
  t.setNumRows(0);
  t.setColumnLabels(sep, cab);
  t.hideColumn(_i.cPED);
  t.hideColumn(_i.cPEH);
  t.hideColumn(_i.cSPR);
  t.setColumnReadOnly(_i.cPER, true);
  t.setColumnReadOnly(_i.cPED, true);
  t.setColumnReadOnly(_i.cPEH, true);
  t.setColumnReadOnly(_i.cSPR, true);

  var fila = 0;
  _i.fTOT = fila;
  t.insertRows(fila);
  t.setText(fila, _i.cPER, sys.translate("Total"));
  fila++;

  var fIni = AQUtil.sqlSelect("ejercicios", "fechainicio", "codejercicio = '" + codEjercicio + "'");
  var fFin = AQUtil.sqlSelect("ejercicios", "fechafin", "codejercicio = '" + codEjercicio + "'");
  var f = fIni, fFinPer;
  var periodicidad = cursor.valueBuffer("periodicidad");
  debug(f + " - " + fFin + " hay " + AQUtil.daysTo(f, fFin));

  while (AQUtil.daysTo(f, fFin) > 0) {

    t.insertRows(fila);
    t.setText(fila, _i.cPER, _i.nombrePeriodo(f, periodicidad));
    t.setText(fila, _i.cPED, f);
    switch (periodicidad) {
      case "Mensual": {
        f = AQUtil.addMonths(f, 1);
        break;
      }
      case "Trimestral": {
        f = AQUtil.addMonths(f, 3);
        break;
      }
      case "Semestral": {
        f = AQUtil.addMonths(f, 6);
        break;
      }
      case "Anual": {
        f = AQUtil.addMonths(f, 12);
        break;
      }
      default: {
        return;
      }
    }
    where += " AND '" + fFinPer + "'";
    fFinPer = AQUtil.addDays(f, -1);
    t.setText(fila, _i.cPEH, fFinPer);
    fila++;
  }
  _i.cargaSaldos();
}

function oficial_nombrePeriodo(f, periodicidad)
{
  var mes = f.getMonth();
  var nombre;
  switch (periodicidad) {
    case "Mensual": {
      switch (mes) {
        case 1: {
          nombre = sys.translate("Enero");
          break;
        }
        case 2: {
          nombre = sys.translate("Febrero");
          break;
        }
        case 3: {
          nombre = sys.translate("Marzo");
          break;
        }
        case 4: {
          nombre = sys.translate("Abril");
          break;
        }
        case 5: {
          nombre = sys.translate("Mayo");
          break;
        }
        case 6: {
          nombre = sys.translate("Junio");
          break;
        }
        case 7: {
          nombre = sys.translate("Julio");
          break;
        }
        case 8: {
          nombre = sys.translate("Agosto");
          break;
        }
        case 9: {
          nombre = sys.translate("Septiembre");
          break;
        }
        case 10: {
          nombre = sys.translate("Octubre");
          break;
        }
        case 11: {
          nombre = sys.translate("Novimbre");
          break;
        }
        case 12: {
          nombre = sys.translate("Diciembre");
          break;
        }
      }
      break;
    }
    case "Trimestral": {
      var trim = Math.ceil(mes / 3);
      nombre = sys.translate("Trimestre %1").arg(trim);
      break;
    }
    case "Semestral": {
      var sem = Math.ceil(mes / 6);
      nombre = sys.translate("Semestre %1").arg(sem);
      break;
    }
    case "Anual": {
      nombre = f.getYear();
      break;
    }
  }
  return nombre;
}

function oficial_cargaSaldos()
{
  var _i = this.iface;
  var cursor = this.cursor();
  var t = this.child("tblDistribucion");
  if (!t.numRows()) {
    return;
  }
  this.child("fdbCodEjercicio").setDisabled(true);

  var where, saldo;
  var idSubcuenta = cursor.valueBuffer("idsubcuenta");
  if (idSubcuenta) {
    var codSubcuenta = AQUtil.sqlSelect("co_subcuentas", "codsubcuenta", "idsubcuenta = " + idSubcuenta);
    this.child("gbxDistribucion").title = sys.translate("Distribución de subcuenta %1").arg(codSubcuenta);
  } else {
    this.child("gbxDistribucion").title = sys.translate("Distribución (subcuenta por especificar)");
  }
  for (var f = (_i.fTOT + 1); f < t.numRows(); f++) {
    if (idSubcuenta) {
      where = "p.idsubcuenta = " + cursor.valueBuffer("idsubcuenta") + " AND a.fecha BETWEEN '" + t.text(f, _i.cPED) + "' AND '" + t.text(f, _i.cPEH) + "'";
      saldo = parseFloat(AQUtil.sqlSelect("co_partidas p INNER JOIN co_asientos a ON p.idasiento = a.idasiento", "SUM(p.debe-p.haber)", where, "co_partidas,co_asientos"));
      saldo = isNaN(saldo) ? 0 : saldo;
      saldo = AQUtil.roundFieldValue(saldo, "co_partidas", "debe");
    } else {
      saldo = "";
    }
    t.setText(f, _i.cSAL, saldo);
    t.setText(f, _i.cSPR, saldo);
  }
  _i.calculaTotal();
}

function oficial_calculaTotal()
{
  var _i = this.iface;
  var cursor = this.cursor();
  var t = this.child("tblDistribucion");

  var total = 0;
  var idSubcuenta = cursor.valueBuffer("idsubcuenta");
  if (!idSubcuenta) {
    t.setText(_i.fTOT, _i.cSAL, "");
    return;
  }
  for (var f = (_i.fTOT + 1); f < t.numRows(); f++) {
    total += parseFloat(t.text(f, _i.cSAL));
  }
  total = AQUtil.roundFieldValue(total, "co_partidas", "debe");
  t.setText(_i.fTOT, _i.cSAL, total);
}

function oficial_tblDistribucion_textChanged(f, c)
{
  var _i = this.iface;
  if (c != _i.cSAL) {
    return;
  }
  if (f == _i.fTOT) {
    _i.distribuyeTotal();
    return true;
  } else {
    if (!_i.actualizaPartidaFila(f)) {
      return false;
    }
    _i.calculaTotal();
  }
}

function oficial_actualizaPartidaFila(f)
{
  var _i = this.iface;
  var cursor = this.cursor();
  var t = _i.t_;
  var idSubcuenta = cursor.valueBuffer("idsubcuenta");
  if (!idSubcuenta) {
    return false;
  }
  var codEjercicio = cursor.valueBuffer("codejercicio");
  var q = new FLSqlQuery;
  if (!AQSql.del("co_partidas",  "idsubcuenta = " + idSubcuenta + " AND idasiento IN (select idasiento from co_asientos where fecha BETWEEN '" + t.text(f, _i.cPED) + "' AND '" + t.text(f, _i.cPEH) + "' AND codejercicio = '" + codEjercicio + "')")) {
    return false;
  }
  var oPartida = new Object;
  oPartida.idSubcuenta = idSubcuenta;
  oPartida.codEjercicio = codEjercicio;
  oPartida.fecha = t.text(f, _i.cPED);
  oPartida.codCentro =  false;
  oPartida.saldo = t.text(f, _i.cSAL);

  if (!flcontppal.iface.pub_creaPartidaPresupTrans(oPartida)) {
    t.setText(f, _i.cSAL, t.text(f, _i.cSPR));
    return false;
  }
  t.setText(f, _i.cSPR, oPartida.saldo);
  return true;
}

function oficial_distribuyeTotal()
{
  var cursor = this.cursor();
  var _i = this.iface;
  var periodos;
  switch (cursor.valueBuffer("periodicidad")) {
    case "Mensual": {
      periodos = 12;
      break;
    }
    case "Trimestral": {
      periodos = 4;
      break;
    }
    case "Semestral": {
      periodos = 2;
      break;
    }
    case "Anual": {
      periodos = 1;
      break;
    }
    default: {
      return;
    }
  }
  var t = _i.t_;
  var total = parseFloat(t.text(_i.fTOT, _i.cSAL));
  total = isNaN(total) ? 0 : total;
  var saldoPer = total / periodos;
  saldoPer = AQUtil.roundFieldValue(saldoPer, "co_partidas", "debe");
  saldoUltimo = total - (saldoPer * (periodos - 1));
  saldoUltimo = AQUtil.roundFieldValue(saldoUltimo, "co_partidas", "debe");
  var f1 = t.numRows() - 1
  for (var f = (_i.fTOT + 1); f < f1; f++) {
    t.setText(f, _i.cSAL, saldoPer);
    if (!_i.actualizaPartidaFila(f)) {
      _i.calculaTotal();
      return false;
    }
    t.setText(f, _i.cSPR, saldoPer);
  }
  var f = t.numRows() - 1;
  t.setText(f, _i.cSAL, saldoUltimo);
  t.setText(f, _i.cSPR, saldoUltimo);
  if (!_i.actualizaPartidaFila(f)) {
    _i.calculaTotal();
    return false;
  }
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////