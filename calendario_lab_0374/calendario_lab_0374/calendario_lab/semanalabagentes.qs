/***************************************************************************
                 semanalabagentes.qs  -  description
                             -------------------
    begin                : vie mar 04 2011
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
  var horaMin_ = 9;
  var horaMax_: Number = 19;
  var intervalo_ = 1;
  var tblHorario_;
  var aFilas_: Array;
  var aCols_: Array;
  var aIndiceCol_: Array;
  var altoFila_;
  function oficial(context)
  {
    interna(context);
  }
  function configurarTabla()
  {
    return this.ctx.oficial_configurarTabla();
  }
  function bufferChanged(fN: String)
  {
    return this.ctx.oficial_bufferChanged(fN);
  }
  function cargarHorario()
  {
    return this.ctx.oficial_cargarHorario();
  }
  function compara(d1: Date, d2: Date): Boolean {
    return this.ctx.oficial_compara(d1, d2);
  }
  function pbnSiguiente_clicked()
  {
    return this.ctx.oficial_pbnSiguiente_clicked();
  }
  function pbnPrevio_clicked()
  {
    return this.ctx.oficial_pbnPrevio_clicked();
  }
  function cambiarSemana(incremento: Number)
  {
    return this.ctx.oficial_cambiarSemana(incremento);
  }
  function bufferChanged(fN: String)
  {
    return this.ctx.oficial_bufferChanged(fN);
  }
  function actualizaColumnas()
  {
    return this.ctx.oficial_actualizaColumnas();
  }
  function lunificaFecha()
  {
    return this.ctx.oficial_lunificaFecha();
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
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();
  this.iface.lunificaFecha();
  this.iface.configurarTabla();
  this.iface.cargarHorario();

  connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");
  connect(this.child("pbnPrevio"), "clicked()", this, "iface.pbnPrevio_clicked");
  connect(this.child("pbnSiguiente"), "clicked()", this, "iface.pbnSiguiente_clicked");

  this.iface.altoFila_ = 40;
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_lunificaFecha()
{
  var util = new FLUtil;
  var cursor = this.cursor();
  var dia = cursor.valueBuffer("fechadesde");
  var dDia = new Date(Date.parse(dia.toString()));
  var iDiaSemana = dDia.getDay();
  var hastaLunes = 1 - iDiaSemana;
  var lunes = util.addDays(dia, hastaLunes);
  cursor.setValueBuffer("fechadesde", lunes);
}

function oficial_pbnSiguiente_clicked()
{
  this.iface.cambiarSemana(1);
}

function oficial_pbnPrevio_clicked()
{
  this.iface.cambiarSemana(-1);
}

function oficial_cambiarSemana(incremento: Number)
{
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  var dia: Date = cursor.valueBuffer("fechadesde");
  var diaNuevo: Date = util.addDays(dia, incremento * 7);

  for (var i: Number = 0; i < this.iface.aFilas_.length; i++) {
    this.iface.aFilas_[i]["desde"].setYear(diaNuevo.getYear());
    this.iface.aFilas_[i]["desde"].setMonth(diaNuevo.getMonth());
    this.iface.aFilas_[i]["desde"].setDate(diaNuevo.getDate());
    this.iface.aFilas_[i]["hasta"].setYear(diaNuevo.getYear());
    this.iface.aFilas_[i]["hasta"].setMonth(diaNuevo.getMonth());
    this.iface.aFilas_[i]["hasta"].setDate(diaNuevo.getDate());

    debug("Nuevo desde = " + this.iface.aFilas_[i]["desde"].toString());
    debug("Nuevo hasta = " + this.iface.aFilas_[i]["hasta"].toString());

  }
  cursor.setValueBuffer("fechadesde", diaNuevo);
  //  this.child("fdbFechaDesde").setValue(diaNuevo);
  if (!this.iface.actualizaColumnas()) {
    return false;
  }
  this.iface.cargarHorario();
}

function oficial_configurarTabla()
{
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  this.iface.tblHorario_ = this.child("tblHorario");
  var numFilas: Number = Math.ceil((this.iface.horaMax_ - this.iface.horaMin_) / this.iface.intervalo_);
  this.iface.aFilas_ = new Array(numFilas);
  this.iface.tblHorario_.setNumRows(numFilas);
  /*
    var qryAgentes:FLSqlQuery = new FLSqlQuery;
    qryAgentes.setTablesList("agentes");
    qryAgentes.setSelect("codagente");
    qryAgentes.setFrom("agentes");
    qryAgentes.setWhere("1 = 1 ORDER BY codagente");
    qryAgentes.setForwardOnly(true);
    if (!qryAgentes.exec()) {
      return false;
    }
    var numCols:Number = qryAgentes.size();
  */
  var numCols: Number = 7;
  this.iface.aCols_ = new Array(numCols);
  this.iface.aIndiceCol_ = [];

  this.iface.tblHorario_.setNumCols(numCols);
  if (!this.iface.actualizaColumnas()) {
    return false;
  }
  var sCabecera = "";
  var sep = "*";
  var fila: Number = 0;
  for (var i: Number = this.iface.horaMin_; i < this.iface.horaMax_; i += this.iface.intervalo_) {
    this.iface.tblHorario_.setRowHeight(fila, this.iface.altoFila_);
    this.iface.aFilas_[fila] = [];
    this.iface.aFilas_[fila]["desde"] = new Date(Date.parse(cursor.valueBuffer("fechadesde").toString()));
    this.iface.aFilas_[fila]["desde"].setHours(i);
    this.iface.aFilas_[fila]["desde"].setMinutes(0);
    this.iface.aFilas_[fila]["desde"].setSeconds(0);
    this.iface.aFilas_[fila]["hasta"] = new Date(Date.parse(cursor.valueBuffer("fechadesde").toString()));
    this.iface.aFilas_[fila]["hasta"].setHours(i + this.iface.intervalo_ - 1);
    this.iface.aFilas_[fila]["hasta"].setMinutes(59);
    this.iface.aFilas_[fila]["hasta"].setSeconds(59);
    fila++;
    sCabecera += i == this.iface.horaMin_ ? "" : sep;
    sCabecera += flfactppal.iface.pub_cerosIzquierda(i, 2) + ":00";
  }
  this.iface.tblHorario_.setRowLabels(sep, sCabecera);
}

function oficial_actualizaColumnas()
{
  var cursor = this.cursor();
  var sCabecera = "", sep = "*", semana = "";
  //  var col:Number = 0;
  //  var codAgente:String;
  var util = new FLUtil;
  var aMes = ["", util.translate("scripts", "Ene"), util.translate("scripts", "Feb"), util.translate("scripts", "Mar"), util.translate("scripts", "Abr"), util.translate("scripts", "May"), util.translate("scripts", "Jun"), util.translate("scripts", "Jul"), util.translate("scripts", "Ago"), util.translate("scripts", "Sep"), util.translate("scripts", "Oct"), util.translate("scripts", "Nov"), util.translate("scripts", "Dic")];
  var aDias = [util.translate("scripts", "Lun"), util.translate("scripts", "Mar"), util.translate("scripts", "Mie"), util.translate("scripts", "Jue"), util.translate("scripts", "Vie"), util.translate("scripts", "Sab"), util.translate("scripts", "Dom")];
  //while (qryAgentes.next()) {
  var dDia = cursor.valueBuffer("fechadesde");
  var mes;
  for (var col = 0; col < 7; col++) {
    //    codAgente = qryAgentes.value("codagente");
    this.iface.aCols_[col] = [];
    //    this.iface.aCols_[col]["codagente"] = codAgente;
    this.iface.aCols_[col]["dia"] = new Date(Date.parse(dDia.toString()));
    if (col == 0) {
      mes = aMes[this.iface.aCols_[col]["dia"].getMonth()];
      semana = util.translate("scripts", "Del %1 %2").arg(this.iface.aCols_[col]["dia"].getDate()).arg(mes);
    }
    if (col == 6) {
      mes = aMes[this.iface.aCols_[col]["dia"].getMonth()];
      semana += util.translate("scripts", " al %1 %2").arg(this.iface.aCols_[col]["dia"].getDate()).arg(mes);
    }
    //    this.iface.aIndiceCol_[codAgente] = col;
    sCabecera += sCabecera == "" ? "" : sep;
    sCabecera += aDias[col] + ". " + util.dateAMDtoDMA(dDia);
    dDia = util.addDays(dDia, 1);
  }
  this.iface.tblHorario_.setColumnLabels(sep, sCabecera);
  this.child("lblSemana").text = semana;
  return true;
}

function oficial_cargarHorario()
{
  var cursor: FLSqlCursor = this.cursor();
  /*
    var qryAgentes:FLSqlQuery = new FLSqlQuery;
    qryAgentes.setTablesList("agentes");
    qryAgentes.setSelect("codagente");
    qryAgentes.setFrom("agentes");
    qryAgentes.setWhere("1 = 1 ORDER BY codagente");
    qryAgentes.setForwardOnly(true);
    if (!qryAgentes.exec()) {
      return false;
    }
  */
  var qryIntervalos: FLSqlQuery = new FLSqlQuery;

  var codAgente = cursor.valueBuffer("codagente");
  var dia = cursor.valueBuffer("fechadesde");
  //  while (qryAgentes.next()) {
  for (var col = 0; col < 7; col++) {
    //    codAgente = qryAgentes.value("codagente");

    qryIntervalos.setTablesList("intervaloscal");
    qryIntervalos.setSelect("fechainicio, horainicio, fechafin, horafin, ocupado");
    qryIntervalos.setFrom("intervaloscal");
    qryIntervalos.setWhere("fechainicio = '" + dia + "' AND codagente = '" + codAgente + "' ORDER BY fechainicio, horainicio");
    qryIntervalos.setForwardOnly(true);
    debug(qryIntervalos.sql());
    if (!qryIntervalos.exec()) {
      return false;
    }

    var fila = 0;
    //    var col:Number = this.iface.aIndiceCol_[codAgente];
    var numFilas = this.iface.aFilas_.length;
    var hayIntervalo = qryIntervalos.first();
    var dIntDesde: Date, dIntHasta: Date;
    var sTiempo: String;
    var dFilaDesde, dFilaHasta;
    while (fila < numFilas) {
      debug("Fila " + fila);
      if (hayIntervalo) {
        sTiempo = qryIntervalos.value("fechainicio").toString().left(10) + "T" + qryIntervalos.value("horainicio").toString().right(8);
        dIntDesde = new Date(Date.parse(sTiempo));
        sTiempo = qryIntervalos.value("fechafin").toString().left(10) + "T" + qryIntervalos.value("horafin").toString().right(8);
        dIntHasta = new Date(Date.parse(sTiempo));
        debug("Intervalo desde  " + dIntDesde.toString() + "hasta " + dIntHasta.toString());
        dFilaDesde = new Date(Date.parse(dia.toString()));
        dFilaDesde.setHours(this.iface.aFilas_[fila]["desde"].getHours());
        dFilaDesde.setMinutes(this.iface.aFilas_[fila]["desde"].getMinutes());
        dFilaDesde.setSeconds(this.iface.aFilas_[fila]["desde"].getSeconds());

        dFilaHasta = new Date(Date.parse(dia.toString()));
        dFilaHasta.setHours(this.iface.aFilas_[fila]["hasta"].getHours());
        dFilaHasta.setMinutes(this.iface.aFilas_[fila]["hasta"].getMinutes());
        dFilaHasta.setSeconds(this.iface.aFilas_[fila]["hasta"].getSeconds());
        if (this.iface.compara(dFilaHasta, dIntDesde) == 2) { /// Intervalo posterior a fila, siguiente fila
          debug("Intervalo posterior a fila, siguiente fila");
          this.iface.tblHorario_.setText(fila, col, "NO DISP");
          fila++;
          continue;
        } else if (this.iface.compara(dFilaDesde, dIntHasta) != 2) { /// Intervalo anterior a fila, siguiente intervalo
          debug("Intervalo anterior a fila, siguiente intervalo");
          hayIntervalo = qryIntervalos.next();
          continue;
        } else {
          /// Solapados
          debug("Solapados");
          if (qryIntervalos.value("ocupado")) {
            this.iface.tblHorario_.setText(fila, col, "XXX");
          } else {
            this.iface.tblHorario_.setText(fila, col, "Libre");
          }
        }
      } else { /// Sin intervalo
        this.iface.tblHorario_.setText(fila, col, "NO DISP");
      }
      fila++;
    }
  }
}

/** \D Indica si la hora indicada está incluida en el intervalo indicado
@param dHora: Hora a comprobar
@param dDesde: Momento desde
@param dHasta: Momento hasta
\end */
function oficial_haySolape(dHora, dDesde, dHasta): Boolean {
  var tHora: Number = dHora.getTime();
  var tDesde: Number = dDesde.getTime();
  var tHasta: Number = dHasta.getTime();

  var hay: Boolean = (tDesde <= tHora && tHasta >= tHora);
  return hay;
}

/** \D Compara dos momentos
@param d1: Momento 1
@param d2: Momento 2
@return 0 si son iguales, 1 si el primero es mayor, 2 si el segundo es mayor
\end */
function oficial_compara(d1: Date, d2: Date): Boolean {
  debug("Compara " + d1.toString() + " con " + d2.toString());
  var t1: Number = d1.getTime();
  var t2: Number = d2.getTime();

  var res: Number = 0;
  if (t1 > t2)
  {
    debug("mayor el primero");
    res = 1;
  } else if (t2 > t1)
  {
    debug("mayor el segundo");
    res = 2;
  }
  return res;
}

function oficial_bufferChanged(fN: String)
{
  var cursor: FLSqlCursor = this.cursor();
  switch (fN) {
      /*
      case "fechadesde": {
        var fecha:Date = cursor.valueBuffer("fechadesde");
        try {
          if (!isNaN(Date.parse(fecha.toString()))) {
            this.iface.cargarHorario();
          }
        } catch (e) {}
        break;
      }
      */
    case "codagente": {
      this.iface.cargarHorario();
      break;
    }
  }
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
