/***************************************************************************
                 horariolabagentes.qs  -  description
                             -------------------
    begin                : dom ene 02 2011
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
  var tblHorario_: FLTable;
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
  function cambiarDia(incremento: Number)
  {
    return this.ctx.oficial_cambiarDia(incremento);
  }
  function bufferChanged(fN: String)
  {
    return this.ctx.oficial_bufferChanged(fN);
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
function oficial_pbnSiguiente_clicked()
{
  this.iface.cambiarDia(1);
}

function oficial_pbnPrevio_clicked()
{
  this.iface.cambiarDia(-1);
}

function oficial_cambiarDia(incremento: Number)
{
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  var dia: Date = cursor.valueBuffer("fechadesde");
  var diaNuevo: Date = util.addDays(dia, incremento);

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
  this.child("fdbFechaDesde").setValue(diaNuevo);
  //  this.iface.cargarHorario();
}

function oficial_configurarTabla()
{
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  this.iface.tblHorario_ = this.child("tblHorario");
  var numFilas: Number = Math.ceil((this.iface.horaMax_ - this.iface.horaMin_) / this.iface.intervalo_);
  this.iface.aFilas_ = new Array(numFilas);
  this.iface.tblHorario_.setNumRows(numFilas);
  var qryAgentes: FLSqlQuery = new FLSqlQuery;
  qryAgentes.setTablesList("agentes");
  qryAgentes.setSelect("codagente");
  qryAgentes.setFrom("agentes");
  qryAgentes.setWhere("1 = 1 ORDER BY codagente");
  qryAgentes.setForwardOnly(true);
  if (!qryAgentes.exec()) {
    return false;
  }
  var numCols: Number = qryAgentes.size();
  this.iface.tblHorario_.setNumCols(numCols);
  var sCabecera: String = "", sep: String = "*";
  var col: Number = 0;
  var codAgente: String;
  this.iface.aCols_ = new Array(numCols);
  this.iface.aIndiceCol_ = [];
  while (qryAgentes.next()) {
    codAgente = qryAgentes.value("codagente");
    this.iface.aCols_[col] = [];
    this.iface.aCols_[col]["codagente"] = codAgente;
    this.iface.aIndiceCol_[codAgente] = col;
    col++;
    sCabecera += sCabecera == "" ? "" : sep;
    sCabecera += codAgente;
  }
  this.iface.tblHorario_.setColumnLabels(sep, sCabecera);
  sCabecera = ""
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

function oficial_cargarHorario()
{
  var cursor: FLSqlCursor = this.cursor();

  var qryAgentes: FLSqlQuery = new FLSqlQuery;
  qryAgentes.setTablesList("agentes");
  qryAgentes.setSelect("codagente");
  qryAgentes.setFrom("agentes");
  qryAgentes.setWhere("1 = 1 ORDER BY codagente");
  qryAgentes.setForwardOnly(true);
  if (!qryAgentes.exec()) {
    return false;
  }

  var qryIntervalos: FLSqlQuery = new FLSqlQuery;

  var codAgente: String;
  while (qryAgentes.next()) {
    codAgente = qryAgentes.value("codagente");

    qryIntervalos.setTablesList("intervaloscal");
    qryIntervalos.setSelect("fechainicio, horainicio, fechafin, horafin, ocupado");
    qryIntervalos.setFrom("intervaloscal");
    qryIntervalos.setWhere("fechainicio = '" + cursor.valueBuffer("fechadesde") + "' AND codagente = '" + codAgente + "' ORDER BY fechainicio, horainicio");
    qryIntervalos.setForwardOnly(true);
    debug(qryIntervalos.sql());
    if (!qryIntervalos.exec()) {
      return false;
    }

    var fila: Number = 0;
    var col: Number = this.iface.aIndiceCol_[codAgente];
    var numFilas: Number = this.iface.aFilas_.length;
    var hayIntervalo: Boolean = qryIntervalos.first();
    var dIntDesde: Date, dIntHasta: Date;
    var sTiempo: String;
    while (fila < numFilas) {
      debug("Fila " + fila);
      if (hayIntervalo) {
        sTiempo = qryIntervalos.value("fechainicio").toString().left(10) + "T" + qryIntervalos.value("horainicio").toString().right(8);
        dIntDesde = new Date(Date.parse(sTiempo));
        sTiempo = qryIntervalos.value("fechafin").toString().left(10) + "T" + qryIntervalos.value("horafin").toString().right(8);
        dIntHasta = new Date(Date.parse(sTiempo));
        debug("Intervalo desde  " + dIntDesde.toString() + "hasta " + dIntHasta.toString());
        if (this.iface.compara(this.iface.aFilas_[fila]["hasta"], dIntDesde) == 2) { /// Intervalo posterior a fila, siguiente fila
          debug("Intervalo posterior a fila, siguiente fila");
          this.iface.tblHorario_.setText(fila, col, "NO DISP");
          fila++;
          continue;
        } else if (this.iface.compara(this.iface.aFilas_[fila]["desde"], dIntHasta) != 2) { /// Intervalo anterior a fila, siguiente intervalo
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
    case "fechadesde": {
      var fecha: Date = cursor.valueBuffer("fechadesde");
      try {
        if (!isNaN(Date.parse(fecha.toString()))) {
          this.iface.cargarHorario();
        }
      } catch (e) {}
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
