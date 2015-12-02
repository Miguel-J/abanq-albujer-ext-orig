/***************************************************************************
                 calobjetomes.qs  -  description
                             -------------------
    begin                : jue oct 13 2011
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
  var tblCalendario_;
  var aDiasMes_, aDiaTabla_;
  var diaInicio_, diaFin_;
  var anchoCol_, altoFila_, aMeses_, clrDia_, clrDiaNoMes_, fontDia_;
  var container_;
  var pbnMesPrevio_, pbnMesSiguiente_, lblMesActual_;
  var dia1MesActual_;

  function oficial(context)
  {
    interna(context);
  }
  function configurarTabla()
  {
    return this.ctx.oficial_configurarTabla();
  }
  function medidasTabla()
  {
    return this.ctx.oficial_medidasTabla();
  }
  function conectaTabla()
  {
    return this.ctx.oficial_conectaTabla();
  }
  function cargaOcupacion()
  {
    return this.ctx.oficial_cargaOcupacion();
  }
  function pbnMesSiguiente_clicked()
  {
    return this.ctx.oficial_pbnMesSiguiente_clicked();
  }
  function pbnMesPrevio_clicked()
  {
    return this.ctx.oficial_pbnMesPrevio_clicked();
  }
  function cambiaMes(incremento)
  {
    return this.ctx.oficial_cambiaMes(incremento);
  }
  function lunificaFecha(dia)
  {
    return this.ctx.oficial_lunificaFecha(dia);
  }
  function actualizaTabla()
  {
    return this.ctx.oficial_actualizaTabla();
  }
  function textoMes(fecha)
  {
    return this.ctx.oficial_textoMes(fecha);
  }
  function cargaOcupacion()
  {
    return this.ctx.oficial_cargaOcupacion();
  }
  function aceptaFormulario()
  {
    return this.ctx.oficial_aceptaFormulario();
  }
  function damePixCelda(fecha, clrFondo)
  {
    return this.ctx.oficial_damePixCelda(fecha, clrFondo);
  }
  function calObjetoMesOn(container, oDatos)
  {
    return this.ctx.oficial_calObjetoMesOn(container, oDatos);
  }
  function calObjetoMesOff()
  {
    return this.ctx.oficial_calObjetoMesOff();
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
  function pub_calObjetoMesOn(container, oDatos)
  {
    return this.calObjetoMesOn(container, oDatos);
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
  var util = new FLUtil;
  var cursor = this.cursor();

  disconnect(this.child("pushButtonAccept"), "clicked()", this.obj(), "accept()");
  connect(this.child("pushButtonAccept"), "clicked()", _i, "aceptaFormulario()");

  var oDatosCal = new Object;
  oDatosCal.fechaInicio = cursor.valueBuffer("fechadesde");
  _i.calObjetoMesOn(this, oDatosCal);
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
/// Esta función permite empotrar el calendario en otros formularios
function oficial_calObjetoMesOn(container, oDatos)
{
  var util = new FLUtil;
  var _i = this.iface;

  if (!container) {
    return false;
  }
  if (_i.container_) {
    _i.calObjetoMesOff();
  }

  _i.container_ = container;
  _i.tblCalendario_ = container.child("tblCalendario");
  if (!_i.tblCalendario_) {
    return false;
  }
  _i.pbnMesPrevio_ = container.child("pbnMesPrevio");
  _i.pbnMesSiguiente_ = container.child("pbnMesSiguiente");
  _i.lblMesActual_ = container.child("lblMesActual");

  _i.dia1MesActual_ = oDatos.fechaInicio;
  if (!_i.dia1MesActual_) {
    return false;
  }
  _i.dia1MesActual_.setDate(1);
  _i.medidasTabla();
  _i.configurarTabla();
  _i.actualizaTabla();

  connect(_i.pbnMesPrevio_, "clicked()", _i, "pbnMesPrevio_clicked");
  connect(_i.pbnMesSiguiente_, "clicked()", _i, "pbnMesSiguiente_clicked");

  return true;
}

function oficial_calObjetoMesOff()
{

}

function oficial_aceptaFormulario()
{
  var util = new FLUtil;
  var _i = this.iface;
  var cursor = this.cursor();

  var f = _i.tblCalendario_.currentRow();
  var c = _i.tblCalendario_.currentColumn();
  if (f < 0 || c < 0) {
    MessageBox.warning(util.translate("scripts", "Debe escoger una fecha"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton, "AbanQ");
    return;
  }
  var fecha = _i.aDiasMes_[f][c];
  cursor.setValueBuffer("respuesta", fecha.toString());
  this.accept();
}

function oficial_cargaOcupacion()
{
  return true;
}

function oficial_lunificaFecha(dia)
{
  var util = new FLUtil;
  var dDia = new Date(Date.parse(dia.toString()));
  var iDiaSemana = dDia.getDay();
  var hastaLunes = 1 - iDiaSemana;
  var lunes = util.addDays(dia, hastaLunes);
  return lunes;
}

function oficial_pbnMesSiguiente_clicked()
{
  this.iface.cambiaMes(1);
}

function oficial_pbnMesPrevio_clicked()
{
  this.iface.cambiaMes(-1);
}

function oficial_cambiaMes(incremento)
{
  var _i = this.iface;
  var util = new FLUtil;
  var cursor = this.cursor();

  _i.dia1MesActual_ = util.addMonths(_i.dia1MesActual_, incremento * 1);
  /*
  var dia = _i.dia1MesActual_;
  var diaNuevo = util.addMonths(dia, incremento * 1);

  cursor.setValueBuffer("fechadesde", diaNuevo);
  */
  _i.actualizaTabla();
}

function oficial_textoMes(fecha)
{
  var _i = this.iface;
  var mes = fecha.getMonth();
  mes--;
  var anno = fecha.getYear();
  var sMes = _i.aMeses_[mes];
  var texto = sMes + " " + anno;
  return texto;
}

function oficial_actualizaTabla()
{
  var _i = this.iface;
  var util = new FLUtil;
  var cursor = this.cursor();

  var dia = _i.dia1MesActual_; //cursor.valueBuffer("fechadesde");

  _i.lblMesActual_.text = _i.textoMes(dia);

  dia.setDate(1);
  var mes = dia.getMonth();
  var anno = dia.getYear();
  var lunes = _i.lunificaFecha(dia);
  _i.aDiasMes_ = [];
  _i.aDiaTabla_ = [];

  _i.tblCalendario_.setNumRows(0);
  var f = 0, c, nDia;
  var fecha = lunes;
  var clrFondo = new Color;
  clrFondo.setRgb(255, 255, 255);
  var diaFecha;
  _i.diaInicio_ = new Date(fecha.getTime());
  while (fecha.getYear() < anno || (fecha.getYear() == anno && fecha.getMonth() <= mes)) {
    _i.tblCalendario_.insertRows(f);
    _i.aDiasMes_[f] = [];
    _i.tblCalendario_.setRowHeight(f, _i.altoFila_);

    for (c = 0; c < 7; c++) {
      var pixCelda = _i.damePixCelda(fecha, clrFondo);
      _i.tblCalendario_.setPixmap(f, c, pixCelda);
      _i.aDiasMes_[f][c] = fecha;
      diaFecha = fecha.toString().left(10);
      _i.aDiaTabla_[diaFecha] = new Object();
      _i.aDiaTabla_[diaFecha].f = f;
      _i.aDiaTabla_[diaFecha].c = c;
      _i.aDiaTabla_[diaFecha].ocupado = false;
      _i.diaFin_ = new Date(fecha.getTime());
      fecha = util.addDays(fecha, 1);
    }
    f++;
  }
  _i.tblCalendario_.repaintContents()
  _i.cargaOcupacion();
  return true;
}

function oficial_damePixCelda(fecha, clrFondo)
{
  var _i = this.iface;
  var cursor = this.cursor();
  var dia = _i.dia1MesActual_;
  var mes = dia.getMonth();

  var nDia = fecha.getDate();
  var pic = new Picture;
  var pixNew = new Pixmap;
  pixNew.resize(_i.anchoCol_, _i.altoFila_);
  pixNew.fill(clrFondo);
  pic.begin();
  pic.setFont(_i.fontDia_);
  pic.setPen(fecha.getMonth() == mes ? _i.clrDia_ : _i.clrDiaNoMes_, 1);
  pic.drawText(0, 0, _i.anchoCol_, _i.altoFila_, pic.AlignCenter, nDia.toString(), -1);
  pixNew = pic.playOnPixmap(pixNew);
  pic.end();
  return pixNew;
}

function oficial_configurarTabla()
{
  var _i = this.iface;
  var util = new FLUtil;
  var cursor = this.cursor();

  _i.tblCalendario_.setLeftMargin(0);
  _i.tblCalendario_.setNumRows(0);

  var numCols = 7;
  for (var c = 0; c < numCols; c++) {
    _i.tblCalendario_.setColumnWidth(c, _i.anchoCol_);
  }

  _i.tblCalendario_.setNumCols(numCols);
  var aLabelCols = [util.translate("scripts", "Lunes"), util.translate("scripts", "Martes"), util.translate("scripts", "Miércoles"), util.translate("scripts", "Jueves"), util.translate("scripts", "Viernes"), util.translate("scripts", "Sábado"), util.translate("scripts", "Domingo")];
  var sep = "*";
  var sCabecera = aLabelCols.join(sep);
  _i.tblCalendario_.setColumnLabels(sep, sCabecera);

  _i.conectaTabla();

  return true;
}

function oficial_conectaTabla()
{
  var _i = this.iface;
  connect(_i.tblCalendario_, "doubleClicked(int, int)", _i, "aceptaFormulario");
}

function oficial_medidasTabla()
{
  var util = new FLUtil;
  var _i = this.iface;

  _i.anchoCol_ = 100;
  _i.altoFila_ = 40;
  _i.clrDia_ = new Color("black");
  _i.clrDiaNoMes_ = new Color("grey");
  _i.fontDia_ = new Font;
  _i.fontDia_.pointSize = 12;
  _i.fontDia_.family = "Arial";

  _i.aMeses_ = [util.translate("scripts", "Enero"), util.translate("scripts", "Febrero"), util.translate("scripts", "Marzo"), util.translate("scripts", "Abril"), util.translate("scripts", "Mayo"), util.translate("scripts", "Junio"), util.translate("scripts", "Julio"), util.translate("scripts", "Agosto"), util.translate("scripts", "Septiembre"), util.translate("scripts", "Octubre"), util.translate("scripts", "Noviembre"), util.translate("scripts", "Diciembre")];
}


//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
