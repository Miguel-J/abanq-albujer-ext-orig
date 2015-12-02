/***************************************************************************
                 distribuiralbaranescli.qs  -  description
                             -------------------
    begin                : lun nov 01 2011
    copyright            : (C) 2011 by InfoSiAL S.L.
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
  var cLIN, cREF, cDES, cCAN, cDIS, cIUN, cITO, cIDI;
  var clrNoDist_, clrDist_, clrDistParcial_;
  var t_, filasPie_;
  var cL_, pL_, sol_, solMin_, solMax_, mejorSol_, minSolDif_;
  function oficial(context)
  {
    interna(context);
  }
  function aceptar()
  {
    return this.ctx.oficial_aceptar();
  }
  function construirTabla()
  {
    return this.ctx.oficial_construirTabla();
  }
  function cargarTabla()
  {
    return this.ctx.oficial_cargarTabla();
  }
  function calculaImportes(f)
  {
    return this.ctx.oficial_calculaImportes(f);
  }
  function tblLineas_clicked(f, c)
  {
    return this.ctx.oficial_tblLineas_clicked(f, c);
  }
  function tblLineas_valueChanged(f, c)
  {
    return this.ctx.oficial_tblLineas_valueChanged(f, c);
  }
  function calculaTotales()
  {
    return this.ctx.oficial_calculaTotales();
  }
  function tbnTodas_clicked()
  {
    return this.ctx.oficial_tbnTodas_clicked();
  }
  function pbnCalcular_clicked()
  {
    return this.ctx.oficial_pbnCalcular_clicked();
  }
  function comprobarNumero()
  {
    return this.ctx.oficial_comprobarNumero();
  }
  function ponValorPorcentaje()
  {
    return this.ctx.oficial_ponValorPorcentaje();
  }
  function damePesos(aPesos)
  {
    return this.ctx.oficial_damePesos(aPesos);
  }
  function controlMejorSol(aP, sol)
  {
    return this.ctx.oficial_controlMejorSol(aP, sol);
  }
  function valora(aP)
  {
    return this.ctx.oficial_valora(aP);
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
  var _i = this.iface;

  _i.t_ = this.child("tblLineas");

  var cursor = this.cursor();
  if (!cursor.valueBuffer("idalbaran")) {
    MessageBox.warning(sys.translate("No está posicionado en un albarán"), MessageBox.Ok, MessageBox.NoButton);
    this.close();
    return;
  }

  disconnect(this.child("pushButtonAccept"), "clicked()", this.obj(), "accept()");
  connect(this.child("pushButtonAccept"), "clicked()", _i, "aceptar()");
  connect(this.child("tbnTodas"), "clicked()", _i, "tbnTodas_clicked()");

  connect(this.child("tblLineas"), "clicked(int, int)", _i, "tblLineas_clicked()");
  connect(this.child("tblLineas"), "valueChanged(int, int)", _i, "tblLineas_valueChanged()");
  connect(this.child("pbnCalcular"), "clicked()", _i, "pbnCalcular_clicked()");
  connect(this.child("txtPorcentaje"), "textChanged(QString)", _i, "comprobarNumero()");

  _i.construirTabla();
  _i.cargarTabla();
  _i.ponValorPorcentaje();
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_tblLineas_clicked(f, c)
{
  var _i = this.iface;
  if (!(c == _i.cREF || c == _i.cDES || c == _i.cCAN)) {
    return;
  }
  var t = _i.t_;
  var nF = t.numRows();
  nF -= _i.filasPie_;
  if (f >= nF || f < 0) {
    return;
  }
  canDist = parseFloat(t.text(f, _i.cDIS));
  if (canDist == 0) {
    canDist = t.text(f, _i.cCAN);
  } else {
    canDist = 0;
  }
  t.setText(f, _i.cDIS, canDist);
  _i.tblLineas_valueChanged(f, _i.cDIS)
}

function oficial_tbnTodas_clicked()
{
  var _i = this.iface;
  var t = _i.t_;
  var nF = t.numRows();
  nF -= _i.filasPie_;
  for (var f = 0; f < nF; f++) {
    t.setText(f, _i.cDIS, t.text(f, _i.cCAN));
    _i.tblLineas_valueChanged(f, _i.cDIS)
  }
}

function oficial_tblLineas_valueChanged(f, c)
{
  var _i = this.iface;
  if (c != _i.cDIS) {
    return;
  }
  var v = _i.t_.text(f, _i.cDIS);
  v = !v || isNaN(v) ? 0 : v;
  var c = _i.t_.text(f, _i.cCAN);
  c = !c || isNaN(c) ? 0 : c;

  if (parseFloat(v) > parseFloat(c)) {
    v = c;
    _i.t_.setText(f, _i.cDIS, v);
  }

  if (v == 0) {
    _i.t_.setCellBackgroundColor(f, _i.cDIS, _i.clrNoDist_);
  } else if (v == c) {
    _i.t_.setCellBackgroundColor(f, _i.cDIS, _i.clrDist_);
  } else {
    _i.t_.setCellBackgroundColor(f, _i.cDIS, _i.clrDistParcial_);
  }
  _i.calculaImportes(f);
  _i.calculaTotales();
}

function oficial_construirTabla()
{
  var _i = this.iface;
  var t = _i.t_;

  var cabecera = "";
  var c = 0;
  _i.cLIN = c++;
  cabecera += sys.translate("Línea") + "/";
  _i.cREF = c++;
  cabecera += sys.translate("Referencia") + "/";
  _i.cDES = c++;
  cabecera += sys.translate("Artículo") + "/";
  _i.cCAN = c++;
  cabecera += sys.translate("Total") + "/";
  _i.cDIS = c++;
  cabecera += sys.translate("Distribuida") + "/";
  _i.cITO = c++;
  cabecera += sys.translate("Imp.Total") + "/";
  _i.cIDI = c++;
  cabecera += sys.translate("Imp.Dist.") + "/";
  _i.cIUN = c++;
  cabecera += sys.translate("Imp.Unit.") + "/";

  t.setNumCols(c);
  t.hideColumn(_i.cLIN);
  t.setColumnWidth(_i.cREF, 120);
  t.setColumnReadOnly(_i.cREF, true);
  t.setColumnWidth(_i.cDES, 250);
  t.setColumnReadOnly(_i.cDES, true);
  t.setColumnWidth(_i.cCAN, 50);
  t.setColumnReadOnly(_i.cCAN, true);
  t.setColumnWidth(_i.cDIS, 80);
  t.setColumnWidth(_i.cITO, 80);
  t.setColumnReadOnly(_i.cITO, true);
  t.setColumnWidth(_i.cIDI, 80);
  t.setColumnReadOnly(_i.cIDI, true);
  t.hideColumn(_i.cIUN);

  t.setColumnLabels("/", cabecera);

  _i.clrNoDist_ = new Color(250, 250, 250);
  _i.clrDist_ = new Color(50, 200, 50);
  _i.clrDistParcial_ = new Color(255, 255, 127);
}

function oficial_cargarTabla()
{
  var _i = this.iface;
  var cursor = this.cursor();
  var t = _i.t_;
  t.setNumRows(0);

  var tabla = "lineasalbaranescli"
              var q = new FLSqlQuery;
  q.setTablesList(tabla);
  q.setSelect("idlinea, referencia, cantidad, descripcion, pvpunitario");
  q.setFrom(tabla);
  switch (tabla) {
    case "lineasalbaranescli": {
      q.setWhere("idalbaran = " + cursor.valueBuffer("idalbaran") + " ORDER BY referencia");
      break;
    }
    default: {
      return;
    }
  }
  q.setForwardOnly(true);
  if (!q.exec()) {
    return;
  }
  var f = 0;
  while (q.next()) {
    t.insertRows(f, 1);
    t.setText(f, _i.cLIN, q.value("idlinea"));
    t.setText(f, _i.cREF, q.value("referencia"));
    t.setText(f, _i.cDES, q.value("descripcion"));
    t.setText(f, _i.cCAN, q.value("cantidad"));
    t.setText(f, _i.cDIS, 0);
    t.setText(f, _i.cIUN, q.value("pvpunitario"));
    _i.calculaImportes(f);
    f++;
  }
  _i.filasPie_ = 2
                 t.insertRows(f, _i.filasPie_);
  t.setRowReadOnly(f, true);
  t.setText(f, _i.cDES, sys.translate("Total"));
  f++;
  t.setRowReadOnly(f, true);
  t.setText(f, _i.cDES, sys.translate("Total (%)"));
  _i.calculaTotales();
}

function oficial_calculaTotales()
{
  var _i = this.iface;
  var t = _i.t_;
  var nF = t.numRows();
  nF -= _i.filasPie_;
  var importeTotal = 0, importeDist = 0;
  for (var f = 0; f < nF; f++) {
    importeTotal += parseFloat(t.text(f, _i.cITO));
    importeDist += parseFloat(t.text(f, _i.cIDI));
  }
  var porTotal = 100;
  var porDist = importeDist / importeTotal * 100;
  importeTotal = AQUtil.roundFieldValue(importeTotal, "albaranescli", "total");
  importeDist = AQUtil.roundFieldValue(importeDist, "albaranescli", "total");
  porTotal = AQUtil.roundFieldValue(porTotal, "albaranescli", "total") + "%";
  porDist = AQUtil.roundFieldValue(porDist, "albaranescli", "total") + "%";
  t.setText(nF, _i.cITO, importeTotal);
  t.setText(nF, _i.cIDI, importeDist);
  //  t.setCellAlignment(nF + 1, _i.cITO, t.AlignRight);
  //  t.setCellAlignment(nF + 1, _i.cIDI, t.AlignRight);
  t.setText(nF + 1, _i.cITO, porTotal);
  t.setText(nF + 1, _i.cIDI, porDist);
  //  t.repaintContents();
}

function oficial_calculaImportes(f)
{
  var _i = this.iface;
  var t = _i.t_;
  var importeTotal = parseFloat(t.text(f, _i.cIUN)) * parseFloat(t.text(f, _i.cCAN));
  importeTotal = AQUtil.roundFieldValue(importeTotal, "albaranescli", "total");
  t.setText(f, _i.cITO, importeTotal);
  var importeDist = parseFloat(t.text(f, _i.cIUN)) * parseFloat(t.text(f, _i.cDIS));
  importeDist = AQUtil.roundFieldValue(importeDist, "albaranescli", "total");
  t.setText(f, _i.cIDI, importeDist);
}

function oficial_aceptar()
{
  var _i = this.iface;
  var t = _i.t_;
  var tF = t.numRows();
  tF -= _i.filasPie_;

  var aValores = [];
  var i = 0, v, c;
  for (var f = 0; f < tF; f++) {
    v = t.text(f, _i.cDIS);
    v = isNaN(v) ? 0 : v;
    if (v == 0) {
      continue;
    }
    c = t.text(f, _i.cCAN);
    c = isNaN(c) ? 0 : c;
    if (Math.abs(v) > Math.abs(c)) {
      MessageBox.warning(sys.translate("El valor distibuido no puede superar la cantidad original"), MessageBox.Ok, MessageBox.NoButton);
      return;
    }
    aValores[i] = new Object;
    aValores[i]["idlinea"] = t.text(f, _i.cLIN);
    aValores[i]["cantidad"] = v;
    i++;
  }
  var tabla = "lineasalbaranescli";
  switch (tabla) {
    case "lineasalbaranescli": {
      formalbaranescli.iface.pub_ponArrayLineasDist(aValores);
      break;
    }
  }
  this.accept();
}

function oficial_ponValorPorcentaje()
{
  var _i = this.iface;
  var cursor = this.cursor();

  var porDistDefecto = flfacturac.iface.pub_valorDefecto("pordistribuir");
  if (!porDistDefecto || porDistDefecto == "") {
    porDistDefecto = 0;
  }
  this.child("txtPorcentaje").setText(porDistDefecto);
  _i.comprobarNumero();
}

function oficial_comprobarNumero()
{
  var _i = this.iface;
  var cursor = this.cursor();

  var porcentaje = this.child("txtPorcentaje").text;
  if (isNaN(porcentaje)) {
    MessageBox.warning(sys.translate("Introduzca un número. Ej.: 15.2"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    this.child("txtPorcentaje").setText("0");
  }
  if (parseFloat(porcentaje) > 100) {
    MessageBox.warning(sys.translate("El mayor porcentaje permitido es el 100%"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    this.child("txtPorcentaje").setText("0");
  }
}

function oficial_pbnCalcular_clicked()
{
  var _i = this.iface;
  var cursor = this.cursor();
  var t = _i.t_;
  var nF = t.numRows();
  var inverso = false;

  _i.comprobarNumero();
  var porcentaje = parseFloat(this.child("txtPorcentaje").text);
  if (porcentaje <= 0) {
    return;
  }
  if (porcentaje > 50) {
    porcentaje = 100 - porcentaje;
    inverso = true;
  }
  var importePorcentaje = parseFloat(t.text((nF - 2), _i.cITO)) * parseFloat(porcentaje) / 100;
  var tolerancia = importePorcentaje * 0.05;
  _i.sol_ = importePorcentaje;
  _i.solMin_ = importePorcentaje - tolerancia;
  _i.solMax_ = importePorcentaje + tolerancia;
  _i.minSolDif_ = Number.MAX_VALUE;
  _i.mejorSol_ = false;

  debug("_i.solMin_ " + _i.solMin_);
  debug("_i.solMax_ " + _i.solMax_);

  var numL = nF - 2;
  _i.cL_ = new Array(numL);
  _i.pL_ = new Array(numL);
  for (var f = 0; f < numL; f++) {
    _i.cL_[f] = t.text(f, _i.cCAN);
    _i.pL_[f] = t.text(f, _i.cIUN);
  }


  var oParam = [];
  oParam.caption = "Calculando cantidades distribuidas";
  flfactppal.iface.pub_creaDialogoEstado(oParam);

  var p = _i.damePesos([]);

  flfactppal.iface.pub_destruyeDialogoEstado();
  if (!p) {
    if (_i.mejorSol_) {
      p = _i.mejorSol_;
    } else {
      MessageBox.warning(sys.translate("No se ha encontrado una distribución de cantidades que alcance el objetivo"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton, "AbanQ");
      return;
    }
  }
  debug("Solución " + p);
  for (var f = 0; f < numL; f++) {
    if (!inverso) {
      t.setText(f, _i.cDIS, p.length > f ? p[f] : 0);
    } else {
      t.setText(f, _i.cDIS, p.length > f ? parseFloat(t.text(f, _i.cCAN)) - parseFloat(p[f]) : parseFloat(t.text(f, _i.cCAN)));
    }
    _i.tblLineas_valueChanged(f, _i.cDIS);
  }
}

function oficial_damePesos(aPesos)
{
  var _i = this.iface;
  var l = aPesos.length;
  var aP, sol, aP2;
  //flfactppal.iface.pub_creaDialogoProgreso("Calculando cantidades a distribuir...",_i.cL_[l].length);
  for (var j = 0; j <= _i.cL_[l]; j++) {
    AQUtil.setProgress(j);
    aP = aPesos.concat([j]);
    sol = _i.valora(aP);
    if (sol > _i.solMin_ && sol < _i.solMax_) {
      //      AQUtil.setProgress(_i.cL_[l].length);
      //      AQUtil.destroyProgressDialog();
      return aP;
    }
    _i.controlMejorSol(aP, sol);
    if (sol > _i.solMax_) {
      break;
    } else {
      if (aP.length < _i.cL_.length) {
        aP2 = _i.damePesos(aP);
        if (aP2) {
          //          AQUtil.setProgress(_i.cL_[l].length);
          //          AQUtil.destroyProgressDialog();
          return aP2;
        }
      }
    }
  }
  //  AQUtil.destroyProgressDialog();
  return false;
}

function oficial_controlMejorSol(aP, sol)
{
  var _i = this.iface;
  var dif = Math.abs(_i.sol_ - sol);
  if (dif < _i.minSolDif_) {
    _i.minSolDif_ = dif;
    _i.mejorSol_ = [];
    for (var s = 0; s < aP.length; s++) {
      _i.mejorSol_[s] = aP[s];
    }
  }
}

function oficial_valora(aP)
{
  var _i = this.iface;
  var v = 0;
  for (var i = 0; i < aP.length; i++) {
    v += parseFloat(aP[i] * _i.pL_[i]);
  }
  flfactppal.iface.pub_ponLogDialogo("Porcentaje calculado " + v);
  debug("Valorando " + aP + " valor " + v);
  return v;
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
