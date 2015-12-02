/***************************************************************************
                 mastercalendariolab.qs  -  description
                             -------------------
    begin                : mar abr 10 2007
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
  function oficial(context)
  {
    interna(context);
  }
}
//// OFICIAL /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////


/** @class_declaration calendariolab */
//////////////////////////////////////////////////////////////////
//// CALENDARIO_LAB /////////////////////////////////////////////////////
class calendariolab extends oficial
{
  var pbncalcular: Object;
  var pbnCambiarHorarios: Object;
  var pbnimprimir: Object;
  var tableDBRecords: FLTableDB;
  var tedCalendario: Object;
  var colores: Array;
  var dias: Array;
  var meses: Array;
  var mesesTabla: Array;
  var anyo: Number;
  function calendariolab(context)
  {
    oficial(context);
  }
  function init()
  {
    this.ctx.calendariolab_init();
  }
  function activarHorarioAgentes()
  {
    this.ctx.calendariolab_activarHorarioAgentes();
  }
  function activarCalendariosObjeto()
  {
    this.ctx.calendariolab_activarCalendariosObjeto();
  }
  function calcularCalendario()
  {
    return this.ctx.calendariolab_calcularCalendario();
  }
  function crearDia(fecha: Date)
  {
    return this.ctx.calendariolab_crearDia(fecha);
  }
  function imprimir()
  {
    return this.ctx.calendariolab_imprimir();
  }
  function dibujarCalendario()
  {
    return this.ctx.calendariolab_dibujarCalendario();
  }
  function establecerArrays()
  {
    return this.ctx.calendariolab_establecerArrays();
  }
  function sumarAnyo()
  {
    return this.ctx.calendariolab_sumarAnyo();
  }
  function restarAnyo()
  {
    return this.ctx.calendariolab_restarAnyo();
  }
  function tituloCalendario()
  {
    return this.ctx.calendariolab_tituloCalendario();
  }
  function cambiarHorarios()
  {
    return this.ctx.calendariolab_cambiarHorarios();
  }
  function regenerarCalendario(fechaInicial: Date, fechaFinal: Date): Boolean {
    return this.ctx.calendariolab_regenerarCalendario(fechaInicial, fechaFinal);
  }
  function regenerarDiasCalendario(fechaInicial: Date, fechaFinal: Date): Boolean {
    return this.ctx.calendariolab_regenerarDiasCalendario(fechaInicial, fechaFinal);
  }
  function regenerarDiasAgentes(fechaInicial: Date, fechaFinal: Date, codAgenteR: String): Boolean {
    return this.ctx.calendariolab_regenerarDiasAgentes(fechaInicial, fechaFinal, codAgenteR);
  }
  function pbnHorarioAgentes_clicked()
  {
    return this.ctx.calendariolab_pbnHorarioAgentes_clicked();
  }
  function pbnSemanaAgentes_clicked()
  {
    return this.ctx.calendariolab_pbnSemanaAgentes_clicked();
  }
  function tbnCalObjetoMes_clicked()
  {
    return this.ctx.calendariolab_tbnCalObjetoMes_clicked();
  }
  function crearIntervaloCal(dDesde: Date, dHasta: Date, campo: String, clave: String, curIntervalo: FLSqlCursor): Boolean {
    return this.ctx.calendariolab_crearIntervaloCal(dDesde, dHasta, campo, clave, curIntervalo);
  }
}
//// CALENDARIO_LAB /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////
class head extends calendariolab
{
  function head(context)
  {
    calendariolab(context);
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
  function pub_regenerarDiasAgentes(fechaInicial: Date, fechaFinal: Date, codAgenteR: String): Boolean {
    return this.regenerarDiasAgentes(fechaInicial, fechaFinal, codAgenteR);
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
  var cursor: FLSqlCursor = this.cursor();
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition calendariolab */
//////////////////////////////////////////////////////////////////
//// CALENDARIO_LAB /////////////////////////////////////////////////////
function calendariolab_init()
{
  var _i = this.iface;
  this.iface.__init();
  this.iface.pbncalcular = this.child("pbnCalcularDias");
  this.iface.pbnimprimir = this.child("pbnImprimir");
  this.iface.tableDBRecords = this.child("tableDBRecords");
  this.iface.tedCalendario = this.child("tedCalendario");
  this.iface.pbnCambiarHorarios = this.child("pbnCambiarHorarios");
  connect(this.iface.pbncalcular, "clicked()", this, "iface.calcularCalendario()");
  connect(this.child("pbnActualizar"), "clicked()", this, "iface.dibujarCalendario()");
  connect(this.child("pbnAnyoSiguiente"), "clicked()", this, "iface.sumarAnyo()");
  connect(this.child("pbnAnyoAnterior"), "clicked()", this, "iface.restarAnyo()");
  connect(this.iface.pbnimprimir, "clicked()", this, "iface.imprimir()");
  connect(this.iface.tableDBRecords.cursor(), "bufferCommited()", this, "iface.calcularCalendario()");
  connect(this.iface.pbnCambiarHorarios, "clicked()", this, "iface.cambiarHorarios");
  var hoy: Date = new Date();
  this.iface.anyo = hoy.getYear();
  this.iface.establecerArrays();
  this.iface.dibujarCalendario();

  this.child("pbnHorarioAgentes").close();
  this.child("pbnSemanaAgentes").close();
  this.iface.activarHorarioAgentes(); /// Funcionalidad de ejemplo para ver el funcionamiento de horarios sobre objetos de AbanQ. No debe estar visible en extensión oficial

  this.child("tbnCalObjetoMes").close();
  _i.activarCalendariosObjeto();
}

function calendariolab_activarCalendariosObjeto()
{
  var _i = this.iface;
  this.child("tbnCalObjetoMes").show();
  connect(this.child("tbnCalObjetoMes"), "clicked()", _i, "tbnCalObjetoMes_clicked");
}

function calendariolab_activarHorarioAgentes()
{
  this.child("pbnHorarioAgentes").show();
  this.child("pbnSemanaAgentes").show();
  connect(this.child("pbnHorarioAgentes"), "clicked()", this, "iface.pbnHorarioAgentes_clicked()");
  connect(this.child("pbnSemanaAgentes"), "clicked()", this, "iface.pbnSemanaAgentes_clicked()");
}

function calendariolab_sumarAnyo()
{
  if (this.iface.anyo) {
    this.iface.anyo++;
    this.child("tlbAnyo").text = this.iface.anyo;
    this.iface.dibujarCalendario();
  }
}

function calendariolab_restarAnyo()
{
  if (this.iface.anyo) {
    this.iface.anyo--;
    this.child("tlbAnyo").text = this.iface.anyo;
    this.iface.dibujarCalendario();
  }
}

function calendariolab_imprimir()
{
  var util: FLUtil = new FLUtil;

  if (this.iface.tedCalendario.text.isEmpty())
    return;

  sys.printTextEdit(this.iface.tedCalendario);

  //  MessageBox.information(util.translate("scripts", "Este boton permite imprimir el calendario laboral"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
}

function calendariolab_calcularCalendario()
{
  var util: FLUtil = new FLUtil;
  var hoy: Date = new Date;

  var dialog = new Dialog;
  dialog.caption = "Intervalo de Fechas";
  dialog.okButtonText = "Calcular"
                        dialog.cancelButtonText = "Cancelar";

  var fecha1 = new DateEdit;
  fecha1.label = "Fecha Inicial: ";
  fecha1.date = hoy;
  dialog.add(fecha1);

  var fecha2 = new DateEdit;
  fecha2.label = "Fecha Final: ";
  dialog.add(fecha2);

  if (!dialog.exec())
    return false;

  var fechaInicial: Date = fecha1.date;
  var fechaFinal: Date = fecha2.date;
  if (!fechaInicial || fechaInicial == "" || !fechaFinal || fechaFinal == "") {
    MessageBox.warning(util.translate("scripts", "Debe establecer las fechas inicial y final"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  //  if (util.daysTo(fechaInicial,hoy) > 0) {
  var anyoActual: Number = hoy.getYear();
  if (fechaInicial.getYear < anyoActual) {
    MessageBox.warning(util.translate("scripts", "La fecha inicial no puede ser anterior al año actual"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }

  var curT: FLSqlCursor = new FLSqlCursor("factppal_general");
  curT.transaction(false);
  try {
    if (this.iface.regenerarCalendario(fechaInicial, fechaFinal)) {
      curT.commit();
    } else {
      curT.rollback();
      MessageBox.critical(util.translate("scripts", "Error al regenerar el calendario laboral"), MessageBox.Ok, MessageBox.NoButton);
      return false;
    }
  } catch (e) {
    curT.rollback();
    MessageBox.critical(util.translate("scripts", "Error al regenerar el calendario laboral: ") + e, MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  this.iface.tableDBRecords.refresh();
}

function calendariolab_regenerarCalendario(fechaInicial: Date, fechaFinal: Date): Boolean {
  if (!this.iface.regenerarDiasCalendario(fechaInicial, fechaFinal))
  {
    return false;
  }
  if (!this.iface.regenerarDiasAgentes(fechaInicial, fechaFinal))
  {
    return false;
  }
  return true;
}

/** \D Muestra el formulario de tabla de horario de agentes
\end */
function calendariolab_pbnHorarioAgentes_clicked()
{
  var hoy: Date = new Date;
  hoy.setDate(5)
  var f: Object = new FLFormSearchDB("horariolabagentes");
  var cursor: FLSqlCursor = f.cursor();
  var where: String;
  cursor.select();
  if (!cursor.first()) {
    cursor.setModeAccess(cursor.Insert);
  } else {
    cursor.setModeAccess(cursor.Edit);
  }
  f.setMainWidget();
  cursor.refreshBuffer();
  cursor.setValueBuffer("fechadesde", hoy.toString().left(10));
  f.exec("id");
}

function calendariolab_pbnSemanaAgentes_clicked()
{
  var hoy: Date = new Date;
  hoy.setDate(5)
  var f: Object = new FLFormSearchDB("semanalabagentes");
  var cursor: FLSqlCursor = f.cursor();
  var where: String;
  cursor.select();
  if (!cursor.first()) {
    cursor.setModeAccess(cursor.Insert);
  } else {
    cursor.setModeAccess(cursor.Edit);
  }
  f.setMainWidget();
  cursor.refreshBuffer();
  cursor.setValueBuffer("fechadesde", hoy.toString().left(10));
  f.exec("id");
}

function calendariolab_tbnCalObjetoMes_clicked()
{
  var hoy = new Date;
  hoy.setDate(1)
  var f = new FLFormSearchDB("calobjetomes");
  var cursor = f.cursor();
  cursor.select();
  if (!cursor.first()) {
    cursor.setModeAccess(cursor.Insert);
  } else {
    cursor.setModeAccess(cursor.Edit);
  }
  f.setMainWidget();
  cursor.refreshBuffer();
  cursor.setValueBuffer("fechadesde", hoy.toString().left(10));
  cursor.setValueBuffer("tipoobjeto", "test");
  cursor.setValueBuffer("idobjeto", "test");
  f.exec("id");
  if (!f.accepted()) {
    return false;
  }
  debug("Respuesta = " + cursor.valueBuffer("respuesta"));
}

/** \D Genera todo el horario laboral de uno o todos los agentes entre dos fechas, respetando los intervalos horarios ya reservados
@param  fechaInicial: Fecha desde del recálculo del horario
@param  fechaFinal: Fecha desde del recálculo del horario
@param  codAgenteR: Agente que hay que recalcular. Si no está informado se recalculará para todos los agentes.
\end */
function calendariolab_regenerarDiasAgentes(fechaInicial: Date, fechaFinal: Date, codAgenteR: String): Boolean {
  //debug("regenerarDiasAgentes ");
  var util: FLUtil = new FLUtil;
  var fechaCalculada: Date = fechaInicial;
  var dias: Number = util.daysTo(fechaCalculada, fechaFinal);

  var t: Number = 0;

  var qryCal: FLSqlQuery = new FLSqlQuery();
  qryCal.setTablesList("calendariolab");
  qryCal.setSelect("fecha, horaentradamanana, horasalidamanana, horaentradatarde, horasalidatarde");
  qryCal.setFrom("calendariolab");
  qryCal.setWhere("fecha BETWEEN '" + fechaInicial.toString() + "' AND '" + fechaFinal.toString() + "' ORDER BY fecha ASC");
  qryCal.setForwardOnly(true);

  var qryAgente: FLSqlQuery = new FLSqlQuery;
  qryAgente.setTablesList("agentes");
  qryAgente.setSelect("codagente, nombreap");
  qryAgente.setFrom("agentes");
  if (codAgenteR)
  {
    qryAgente.setWhere("codagente = '" + codAgenteR + "' ORDER BY codagente");
  } else {
    qryAgente.setWhere("1 = 1 ORDER BY codagente");
  }
  qryAgente.setForwardOnly(true);
  if (!qryAgente.exec())
  {
    return false;
  }
  if (!qryAgente.exec())
  {
    return false;
  }

  var qryIntervalos: FLSqlQuery = new FLSqlQuery;
  qryIntervalos.setTablesList("intervaloscal");
  qryIntervalos.setSelect("fechainicio, horainicio, fechafin, horafin");
  qryIntervalos.setFrom("intervaloscal");
  qryIntervalos.setForwardOnly(true);

  var codAgente: String = qryAgente.value("codagente");
  var hayIntervalo: Boolean;
  var hayCalendario: Boolean;
  var sTiempo: String;
  var dIntervaloDesde: Date = false, dIntervaloHasta: Date, dCalIni1: Date, dCalFin1: Date, dCalIni2: Date, dCalFin2: Date, dIntIni: Date, dIntFin: Date;
  var tIntervaloDesde: Number, tIntervaloHasta: Number, tCalIni1: Number, tCalFin1: Number, tCalIni2: Number, tCalFin2: Number, tIntIni: Number, tIntFin: Number;
  var curIntervalo: FLSqlCursor = new FLSqlCursor("intervaloscal");
  while (qryAgente.next())
  {
    dIntervaloDesde = false;
    dIntervaloHasta = false;
    codAgente = qryAgente.value("codagente");
    //debug("codAgente " + codAgente);
    if (!util.sqlDelete("intervaloscal", "codagente = '" + codAgente + "' AND fechainicio >= '" + fechaInicial.toString() + "' AND fechafin <= '" + fechaFinal.toString() + "' AND ocupado = false")) {
      return false;
    }
    qryIntervalos.setWhere("codagente = '" + codAgente + "' AND fechainicio >= '" + fechaInicial.toString() + "' AND ocupado = true ORDER BY fechainicio, horainicio");
    //debug(qryIntervalos.sql());
    if (!qryIntervalos.exec()) {
      return false;
    }
    if (!qryCal.exec()) {
      return false;
    }
    util.createProgressDialog(util.translate("scripts", "Regenerando Calendario para agente %1 - %2").arg(codAgente).arg(qryAgente.value("nombreap")), qryCal.size());
    util.setProgress(0);
    var i: Number = 0;

    hayIntervalo = qryIntervalos.first();
    if (hayIntervalo) {
      //debug("hayIntervalo " + hayIntervalo);
      sTiempo = qryIntervalos.value("fechainicio").toString().left(10) + "T" + qryIntervalos.value("horainicio").toString().right(8);
      //debug("sTiempoIni " + sTiempo);
      dIntIni = new Date(Date.parse(sTiempo));
      sTiempo = qryIntervalos.value("fechafin").toString().left(10) + "T" + qryIntervalos.value("horafin").toString().right(8);
      //debug("sTiempoFin " + sTiempo);
      dIntFin = new Date(Date.parse(sTiempo));
      tIntIni = dIntIni.getTime();
      tIntFin = dIntFin.getTime();
    }
    hayCalendario = qryCal.first();
    if (hayCalendario) {
      sTiempo = qryCal.value("fecha").toString().left(10) + "T" + qryCal.value("horaentradamanana").toString().right(8);
      //debug("dCalIni1 " + sTiempo);
      dCalIni1 = new Date(Date.parse(sTiempo));
      sTiempo = qryCal.value("fecha").toString().left(10) + "T" + qryCal.value("horasalidamanana").toString().right(8);
      //debug("dCalFin1 " + sTiempo);
      dCalFin1 = new Date(Date.parse(sTiempo));
      tCalIni1 = dCalIni1.getTime();
      tCalFin1 = dCalFin1.getTime();

      sTiempo = qryCal.value("fecha").toString().left(10) + "T" + qryCal.value("horaentradatarde").toString().right(8);
      //debug("dCalIni2 " + sTiempo);
      dCalIni2 = new Date(Date.parse(sTiempo));
      sTiempo = qryCal.value("fecha").toString().left(10) + "T" + qryCal.value("horasalidatarde").toString().right(8);
      //debug("dCalFin2 " + sTiempo);
      dCalFin2 = new Date(Date.parse(sTiempo));
      tCalIni2 = dCalIni2.getTime();
      tCalFin2 = dCalFin2.getTime();
    }
    var evaluarManana: Boolean = true;
    while (hayCalendario) {
      util.setProgress(i++);
      /// Calendario = hueco temporal de calendario disponible
      /// Intervalo = hueco temporal ya reservado
      /// Período de mañana
      if (evaluarManana) {
        if (hayIntervalo && hayCalendario) {
          //debug("Calendario " + dCalIni1.toString());
          //debug("Intervalo " + dIntIni.toString());
          if (tIntIni > tCalFin1) { /// No hay solape. El intervalo es posterior al calendario
            //debug("/// No hay solape. El intervalo es posterior al calendario");
            if (!dIntervaloDesde) {
              dIntervaloDesde = dCalIni1;
              dIntervaloHasta = dCalFin1;
              tIntervaloDesde = tCalIni1;
              tIntervaloHasta = tCalFin1;
            } else {
              if (tCalIni1 == tIntervaloHasta) {
                tIntervaloHasta = tCalFin1;
                dIntervaloHasta = dCalFin1;
              } else {
                if (!this.iface.crearIntervaloCal(dIntervaloDesde, dIntervaloHasta, "codagente", codAgente, curIntervalo)) {
                  return false;
                }
                dIntervaloDesde = dCalIni1;
                dIntervaloHasta = dCalFin1;
                tIntervaloDesde = tCalIni1;
                tIntervaloHasta = tCalFin1;
              }
            }
          } else if (tIntFin < tCalIni1) { /// El intervalo es anterior al calendario, se busca el siguiente intervalo
            //debug("/// El intervalo es anterior al calendario, se busca el siguiente intervalo");
            hayIntervalo = qryIntervalos.next();
            if (hayIntervalo) {
              sTiempo = qryIntervalos.value("fechainicio").toString().left(10) + "T" + qryIntervalos.value("horainicio").toString().right(8);
              dIntIni = new Date(Date.parse(sTiempo));
              sTiempo = qryIntervalos.value("fechafin").toString().left(10) + "T" + qryIntervalos.value("horafin").toString().right(8);
              dIntFin = new Date(Date.parse(sTiempo));
              tIntIni = dIntIni.getTime();
              tIntFin = dIntFin.getTime();
            }
            continue;
          } else if ((tIntIni >= tCalIni1) && (tIntFin <= tCalFin1)) { /// Calendario solapa totalmente intervalo
            //debug("/// Calendario solapa totalmente intervalo ");
            if (tCalIni1 == tIntervaloHasta) {
              if (!this.iface.crearIntervaloCal(dIntervaloDesde, dIntIni, "codagente", codAgente, curIntervalo)) {
                return false;
              }
            } else {
              if (dIntervaloDesde) {
                if (!this.iface.crearIntervaloCal(dIntervaloDesde, dIntervaloHasta, "codagente", codAgente, curIntervalo)) {
                  return false;
                }
              }
              if (!this.iface.crearIntervaloCal(dCalIni1, dIntIni, "codagente", codAgente, curIntervalo)) {
                return false;
              }
            }
            tCalIni1 = tIntFin;
            dCalIni1 = new Date(tCalIni1);

            dIntervaloDesde = dIntFin;
            dIntervaloHasta = dIntFin;
            //          dIntervaloHasta = dCalFin1;

            tIntervaloDesde = tIntFin;
            tIntervaloHasta = tIntFin;
            //          tIntervaloHasta = tCalFin1;

            hayIntervalo = qryIntervalos.next();
            if (hayIntervalo) {
              sTiempo = qryIntervalos.value("fechainicio").toString().left(10) + "T" + qryIntervalos.value("horainicio").toString().right(8);
              dIntIni = new Date(Date.parse(sTiempo));
              sTiempo = qryIntervalos.value("fechafin").toString().left(10) + "T" + qryIntervalos.value("horafin").toString().right(8);
              dIntFin = new Date(Date.parse(sTiempo));
              tIntIni = dIntIni.getTime();
              tIntFin = dIntFin.getTime();
            }
            continue;
          } else if (tIntIni > tCalIni1 && tIntIni < tCalFin1) { /// Calendario solapa parcialmente intervalo. El intervalo es posterior.
            //debug("/// Calendario solapa parcialmente intervalo. El intervalo es anterior.");
            if (tCalIni1 == tIntervaloHasta) {
              if (!this.iface.crearIntervaloCal(dIntervaloDesde, dIntIni, "codagente", codAgente, curIntervalo)) {
                return false;
              }
            } else {
              if (dIntervaloDesde) {
                if (!this.iface.crearIntervaloCal(dIntervaloDesde, dIntervaloHasta, "codagente", codAgente, curIntervalo)) {
                  return false;
                }
              }
              if (!this.iface.crearIntervaloCal(dCalIni1, dIntIni, "codagente", codAgente, curIntervalo)) {
                return false;
              }
            }
            dIntervaloDesde = false;
            dIntervaloHasta = false;

            hayIntervalo = qryIntervalos.next();
            if (hayIntervalo) {
              sTiempo = qryIntervalos.value("fechainicio").toString().left(10) + "T" + qryIntervalos.value("horainicio").toString().right(8);
              dIntIni = new Date(Date.parse(sTiempo));
              sTiempo = qryIntervalos.value("fechafin").toString().left(10) + "T" + qryIntervalos.value("horafin").toString().right(8);
              dIntFin = new Date(Date.parse(sTiempo));
              tIntIni = dIntIni.getTime();
              tIntFin = dIntFin.getTime();
            }
            continue;
          } else if (tIntFin > tCalIni1 && tIntFin < tCalFin1) { /// Calendario solapa parcialmente intervalo. El intervalo es anterior.
            //debug("/// Calendario solapa parcialmente intervalo. El intervalo es anterior.");
            if (dIntervaloDesde) {
              if (!this.iface.crearIntervaloCal(dIntervaloDesde, dIntervaloHasta, "codagente", codAgente, curIntervalo)) {
                return false;
              }
            }
            dIntervaloDesde = dIntFin;
            dIntervaloHasta = dCalFin1;
            tIntervaloDesde = tIntFin;
            tIntervaloHasta = tCalFin1;

            tCalIni1 = tIntFin;
            dCalIni1 = new Date(tCalIni1);

            dIntervaloDesde = dIntFin;
            dIntervaloHasta = dIntFin;
            //          dIntervaloHasta = dCalFin1;

            tIntervaloDesde = tIntFin;
            tIntervaloHasta = tIntFin;
            //          tIntervaloHasta = tCalFin1;

            hayIntervalo = qryIntervalos.next();
            if (hayIntervalo) {
              sTiempo = qryIntervalos.value("fechainicio").toString().left(10) + "T" + qryIntervalos.value("horainicio").toString().right(8);
              dIntIni = new Date(Date.parse(sTiempo));
              sTiempo = qryIntervalos.value("fechafin").toString().left(10) + "T" + qryIntervalos.value("horafin").toString().right(8);
              dIntFin = new Date(Date.parse(sTiempo));
              tIntIni = dIntIni.getTime();
              tIntFin = dIntFin.getTime();
            }
            continue;
          }
        } else if (!hayIntervalo && hayCalendario) {
          //debug("/// !Hay Intervalo");
          if (!dIntervaloDesde) {
            dIntervaloDesde = dCalIni1;
            dIntervaloHasta = dCalFin1;
            tIntervaloDesde = tCalIni1;
            tIntervaloHasta = tCalFin1;
          } else {
            if (tCalIni1 == tIntervaloHasta) {
              tIntervaloHasta = tCalFin1;
              dIntervaloHasta = dCalFin1;
            } else {
              if (!this.iface.crearIntervaloCal(dIntervaloDesde, dIntervaloHasta, "codagente", codAgente, curIntervalo)) {
                return false;
              }
              dIntervaloDesde = dCalIni1;
              dIntervaloHasta = dCalFin1;
              tIntervaloDesde = tCalIni1;
              tIntervaloHasta = tCalFin1;
            }
          }
        }
      }
      evaluarManana = true;
      //debug("/// Tarde");
      /// Período de tarde
      //debug("Calendario " + dCalIni2.toString());
      if (hayIntervalo && hayCalendario) {
        if (tIntIni > tCalFin2) { /// No hay solape. El intervalo es posterior al calendario
          //debug("/// No hay solape. El intervalo es posterior al calendario");
          if (!dIntervaloDesde) {
            dIntervaloDesde = dCalIni2;
            dIntervaloHasta = dCalFin2;
            tIntervaloDesde = tCalIni2;
            tIntervaloHasta = tCalFin2;
          } else {
            if (tCalIni2 == tIntervaloHasta) {
              tIntervaloHasta = tCalFin2;
              dIntervaloHasta = dCalFin2;
            } else {
              if (!this.iface.crearIntervaloCal(dIntervaloDesde, dIntervaloHasta, "codagente", codAgente, curIntervalo)) {
                return false;
              }
              dIntervaloDesde = dCalIni2;
              dIntervaloHasta = dCalFin2;
              tIntervaloDesde = tCalIni2;
              tIntervaloHasta = tCalFin2;
            }
          }
        } else if (tIntFin < tCalIni2) { /// El intervalo es anterior al calendario, se busca el siguiente intervalo
          //debug("/// El intervalo es anterior al calendario, se busca el siguiente intervalo");
          hayIntervalo = qryIntervalos.next();
          if (hayIntervalo) {
            sTiempo = qryIntervalos.value("fechainicio").toString().left(10) + "T" + qryIntervalos.value("horainicio").toString().right(8);
            dIntIni = new Date(Date.parse(sTiempo));
            sTiempo = qryIntervalos.value("fechafin").toString().left(10) + "T" + qryIntervalos.value("horafin").toString().right(8);
            dIntFin = new Date(Date.parse(sTiempo));
            tIntIni = dIntIni.getTime();
            tIntFin = dIntFin.getTime();
          }
          evaluarManana = false;
          continue;
        } else if ((tIntIni >= tCalIni2) && (tIntFin <= tCalFin2)) { /// Calendario solapa totalmente intervalo
          //debug("/// Calendario solapa totalmente intervalo ");
          if (tCalIni2 == tIntervaloHasta) {
            if (!this.iface.crearIntervaloCal(dIntervaloDesde, dIntIni, "codagente", codAgente, curIntervalo)) {
              return false;
            }
          } else {
            if (dIntervaloDesde) {
              if (!this.iface.crearIntervaloCal(dIntervaloDesde, dIntervaloHasta, "codagente", codAgente, curIntervalo)) {
                return false;
              }
            }
            if (!this.iface.crearIntervaloCal(dCalIni2, dIntIni, "codagente", codAgente, curIntervalo)) {
              return false;
            }
          }

          tCalIni2 = tIntFin;
          dCalIni2 = new Date(tCalIni2);

          dIntervaloDesde = dIntFin;
          dIntervaloHasta = dIntFin;
          //          dIntervaloHasta = dCalFin2;

          tIntervaloDesde = tIntFin;
          tIntervaloHasta = tIntFin;
          //          tIntervaloHasta = tCalFin2;

          hayIntervalo = qryIntervalos.next();
          if (hayIntervalo) {
            sTiempo = qryIntervalos.value("fechainicio").toString().left(10) + "T" + qryIntervalos.value("horainicio").toString().right(8);
            dIntIni = new Date(Date.parse(sTiempo));
            sTiempo = qryIntervalos.value("fechafin").toString().left(10) + "T" + qryIntervalos.value("horafin").toString().right(8);
            dIntFin = new Date(Date.parse(sTiempo));
            tIntIni = dIntIni.getTime();
            tIntFin = dIntFin.getTime();
          }
          evaluarManana = false;
          continue;
        } else if (tIntIni > tCalIni2 && tIntIni < tCalFin2) { /// Calendario solapa parcialmente intervalo. El intervalo es posterior.
          //debug("/// Calendario solapa parcialmente intervalo. El intervalo es posterior. ");
          if (tCalIni2 == tIntervaloHasta) {
            if (!this.iface.crearIntervaloCal(dIntervaloDesde, dIntIni, "codagente", codAgente, curIntervalo)) {
              return false;
            }
          } else {
            if (dIntervaloDesde) {
              if (!this.iface.crearIntervaloCal(dIntervaloDesde, dIntervaloHasta, "codagente", codAgente, curIntervalo)) {
                return false;
              }
            }
            if (!this.iface.crearIntervaloCal(dCalIni2, dIntIni, "codagente", codAgente, curIntervalo)) {
              return false;
            }
          }
          dIntervaloDesde = false;
          dIntervaloHasta = false;
        } else if (tIntFin > tCalIni2 && tIntFin < tCalFin2) { /// Calendario solapa parcialmente intervalo. El intervalo es anterior.
          //debug("/// Calendario solapa parcialmente intervalo. El intervalo es posterior.");
          if (dIntervaloDesde) {
            if (!this.iface.crearIntervaloCal(dIntervaloDesde, dIntervaloHasta, "codagente", codAgente, curIntervalo)) {
              return false;
            }
          }

          tCalIni2 = tIntFin;
          dCalIni2 = new Date(tCalIni2);

          dIntervaloDesde = dIntFin;
          dIntervaloHasta = dIntFin;
          //          dIntervaloHasta = dCalFin2;

          tIntervaloDesde = tIntFin;
          tIntervaloHasta = tIntFin;
          //          tIntervaloHasta = tCalFin2;

          hayIntervalo = qryIntervalos.next();
          if (hayIntervalo) {
            sTiempo = qryIntervalos.value("fechainicio").toString().left(10) + "T" + qryIntervalos.value("horainicio").toString().right(8);
            dIntIni = new Date(Date.parse(sTiempo));
            sTiempo = qryIntervalos.value("fechafin").toString().left(10) + "T" + qryIntervalos.value("horafin").toString().right(8);
            dIntFin = new Date(Date.parse(sTiempo));
            tIntIni = dIntIni.getTime();
            tIntFin = dIntFin.getTime();
          }
          evaluarManana = false;
          continue;
        }
      } else if (!hayIntervalo && hayCalendario) {
        //debug("/// !hayIntervalo");
        if (!dIntervaloDesde) {
          dIntervaloDesde = dCalIni2;
          dIntervaloHasta = dCalFin2;
          tIntervaloDesde = tCalIni2;
          tIntervaloHasta = tCalFin2;
        } else {
          if (tCalIni2 == tIntervaloHasta) {
            tIntervaloHasta = tCalFin2;
            dIntervaloHasta = dCalFin2;
          } else {
            if (!this.iface.crearIntervaloCal(dIntervaloDesde, dIntervaloHasta, "codagente", codAgente, curIntervalo)) {
              return false;
            }
            dIntervaloDesde = dCalIni2;
            dIntervaloHasta = dCalFin2;
            tIntervaloDesde = tCalIni2;
            tIntervaloHasta = tCalFin2;
          }
        }
      }

      hayCalendario = qryCal.next();
      if (hayCalendario) {
        sTiempo = qryCal.value("fecha").toString().left(10) + "T" + qryCal.value("horaentradamanana").toString().right(8);
        //debug("dCalIni1 " + sTiempo);
        dCalIni1 = new Date(Date.parse(sTiempo));
        sTiempo = qryCal.value("fecha").toString().left(10) + "T" + qryCal.value("horasalidamanana").toString().right(8);
        //debug("dCalFin1 " + sTiempo);
        dCalFin1 = new Date(Date.parse(sTiempo));
        tCalIni1 = dCalIni1.getTime();
        tCalFin1 = dCalFin1.getTime();

        sTiempo = qryCal.value("fecha").toString().left(10) + "T" + qryCal.value("horaentradatarde").toString().right(8);
        //debug("dCalIni2 " + sTiempo);
        dCalIni2 = new Date(Date.parse(sTiempo));
        sTiempo = qryCal.value("fecha").toString().left(10) + "T" + qryCal.value("horasalidatarde").toString().right(8);
        //debug("dCalFin2 " + sTiempo);
        dCalFin2 = new Date(Date.parse(sTiempo));
        tCalIni2 = dCalIni2.getTime();
        tCalFin2 = dCalFin2.getTime();
      }
    }
    if (dIntervaloDesde &&  dIntervaloHasta) {
      if (!this.iface.crearIntervaloCal(dIntervaloDesde, dIntervaloHasta, "codagente", codAgente, curIntervalo)) {
        return false;
      }
    }
    util.destroyProgressDialog();
  }
  return true;
}

function calendariolab_crearIntervaloCal(dDesde: Date, dHasta: Date, campo: String, clave: String, curIntervalo: FLSqlCursor): Boolean {
  if (!curIntervalo)
  {
    curIntervalo = new FLSqlCursor("intervaloscal");
  }
  var tDesde: Number = dDesde.getTime();
  var tHasta: Number = dHasta.getTime();
  if (tHasta > tDesde)
  {
    //debug("insertando " + dDesde.toString() + " a " + dHasta.toString());
    //debug("insertando " + tDesde + " a " + tHasta);
    curIntervalo.setModeAccess(curIntervalo.Insert);
    curIntervalo.refreshBuffer();
    curIntervalo.setValueBuffer(campo, clave);
    curIntervalo.setValueBuffer("fechainicio", dDesde.toString().left(10));
    curIntervalo.setValueBuffer("horainicio", dDesde.toString().right(8));
    curIntervalo.setValueBuffer("fechafin", dHasta.toString().left(10));
    curIntervalo.setValueBuffer("horafin", dHasta.toString().right(8));
    curIntervalo.setValueBuffer("ms", tHasta - tDesde);
    if (!curIntervalo.commitBuffer()) {
      return false;
    }
  }
  return true;
}

function calendariolab_regenerarDiasCalendario(fechaInicial: Date, fechaFinal: Date): Boolean {
  var util: FLUtil = new FLUtil;
  var fechaCalculada: Date = fechaInicial;
  var dias: Number = util.daysTo(fechaCalculada, fechaFinal);

  util.createProgressDialog(util.translate("scripts", "Regenerando Calendario"), dias);
  util.setProgress(0);
  var i: Number = 0;

  while (util.daysTo(fechaCalculada, fechaFinal) >= 0)
  {
    if (!this.iface.crearDia(fechaCalculada)) {
      util.destroyProgressDialog();
      return false;
    }
    fechaCalculada = util.addDays(fechaCalculada, 1);
    util.setProgress(i++);
  }
  util.setProgress(dias);
  util.destroyProgressDialog();
  return true;
}

function calendariolab_crearDia(fecha: Date): Boolean {
  var util: FLUtil;
  var diaSemana: Number = fecha.getDay();
  var horaInicioManana: String = "";
  var horaFimManana: String = "";
  var horaInicioTarde: String = "";
  var horaFinTarde: String = "";
  var totalhoras: Number = 0;

  var  horarioLaboral: String = flfactppal.iface.pub_valorDefecto("codhorariodl");
  var  horarioSabado: String = flfactppal.iface.pub_valorDefecto("codhorariosab");
  var  horarioDomingo: String = flfactppal.iface.pub_valorDefecto("codhorariodom");
  var horario: String = "";
  if (!horarioLaboral || horarioLaboral == "")
  {
    MessageBox.warning(util.translate("scripts", "Debe establecer un tipo de horario para los dias laborales"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }

  switch (diaSemana)
  {
    case 1:
    case 2:
    case 3:
    case 4:
    case 5:
      horaInicioManana = util.sqlSelect("horarioslab", "horaentradamanana", "codhorario = '" + horarioLaboral + "'");
      horaFinManana = util.sqlSelect("horarioslab", "horasalidamanana", "codhorario = '" + horarioLaboral + "'");
      horaInicioTarde = util.sqlSelect("horarioslab", "horaentradatarde", "codhorario = '" + horarioLaboral + "'");
      horaFinTarde = util.sqlSelect("horarioslab", "horasalidatarde", "codhorario = '" + horarioLaboral + "'");
      //debug("horaFinTarde " + horaFinTarde);
      totalhoras = util.sqlSelect("horarioslab", "totalhoras", "codhorario = '" + horarioLaboral + "'");
      horario = horarioLaboral;

      break;
    case 6:
      if (horarioSabado && horarioSabado != "") {
        horaInicioManana = util.sqlSelect("horarioslab", "horaentradamanana", "codhorario = '" + horarioSabado + "'");
        horaFinManana = util.sqlSelect("horarioslab", "horasalidamanana", "codhorario = '" + horarioSabado + "'");
        horaInicioTarde = util.sqlSelect("horarioslab", "horaentradatarde", "codhorario = '" + horarioSabado + "'");
        horaFinTarde = util.sqlSelect("horarioslab", "horasalidatarde", "codhorario = '" + horarioSabado + "'");
        totalhoras = util.sqlSelect("horarioslab", "totalhoras", "codhorario = '" + horarioSabado + "'");
      } else {
        horaInicioManana = "";
        horaFinManana = "";
        horaInicioTarde = "";
        horaFinTarde = "";
        horarioSabado = "";
        totalhoras = 0;
      }
      horario = horarioSabado;
      break;
    case 7:
      if (horarioDomingo && horarioDomingo != "") {
        horaInicioManana = util.sqlSelect("horarioslab", "horaentradamanana", "codhorario = '" + horarioDomingo + "'");
        horaFinManana = util.sqlSelect("horarioslab", "horasalidamanana", "codhorario = '" + horarioDomingo + "'");
        horaInicioTarde = util.sqlSelect("horarioslab", "horaentradatarde", "codhorario = '" + horarioDomingo + "'");
        horaFinTarde = util.sqlSelect("horarioslab", "horasalidatarde", "codhorario = '" + horarioDomingo + "'");
        totalhoras = util.sqlSelect("horarioslab", "totalhoras", "codhorario = '" + horarioDomingo + "'");
      } else {
        horaInicioManana = "";
        horaFinManana = "";
        horaInicioTarde = "";
        horaFinTarde = "";
        horarioDomingo = "";
        totalhoras = 0;
      }
      horario = horarioDomingo;
      break;
    default:
      return false;
  }

  var curCalendario: FLSqlCursor = new FLSqlCursor("calendariolab");
  //debug("Buscando fecha " + fecha);
  if (util.sqlSelect("calendariolab", "fecha", "fecha = '" + fecha + "'"))
  {
    curCalendario.select("fecha = '" + fecha + "'");
    curCalendario.setModeAccess(curCalendario.Edit);
    if (!curCalendario.first()) {
      return false;
    }
    curCalendario.refreshBuffer();
  } else {
    curCalendario.setModeAccess(curCalendario.Insert);
    curCalendario.refreshBuffer();
    curCalendario.setValueBuffer("fecha", fecha);
  }

  var semana = [ util.translate("scripts", "Lunes"), util.translate("scripts", "Martes"), util.translate("scripts", "Miércoles"), util.translate("scripts", "Jueves"), util.translate("scripts", "Viernes"), util.translate("scripts", "Sábado"), util.translate("scripts", "Domingo")];

  curCalendario.setValueBuffer("codhorario", horario);
  curCalendario.setValueBuffer("descripcion", semana[diaSemana - 1]);
  curCalendario.setValueBuffer("horaentradamanana", horaInicioManana);
  curCalendario.setValueBuffer("horasalidamanana", horaFinManana);
  curCalendario.setValueBuffer("horaentradatarde", horaInicioTarde);
  curCalendario.setValueBuffer("horasalidatarde", horaFinTarde);
  curCalendario.setValueBuffer("totalhoras", totalhoras);

  if (!curCalendario.commitBuffer())
  {
    return false;
  }
  return true;
}

function calendariolab_dibujarCalendario()
{
  var util: FLUtil = new FLUtil();

  var tamMeses: Array = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
  var html: String = "";
  var hoy: Date = new Date();

  if ((this.iface.anyo % 4 == 0) && ((this.iface.anyo % 100 != 0) || (this.iface.anyo % 400 == 0)))
    tamMeses[1] = 29;

  var fechaIni: Date = new Date(this.iface.anyo, 1, 1);
  var diaIni: Number = fechaIni.getDay();

  html += "<center><h3>" + this.iface.tituloCalendario() + "</h3></center><p>";
  html += "<center><table border=\"0\" cellpadding=0 cellspacing=4>";
  var dia: Number = -1;
  var indiceMes: Number = 0;
  for (var fila = 1; fila <= 3; fila++) {
    html += "<tr>";
    for (var columna = 1; columna <= 4; columna++) {
      html += "<td>"
              html += "<table border=\"0\" cellpadding=0 cellspacing=0>";
      html += "<tr align=center>";
      html += "<th colspan=7><h4>" + this.iface.meses[indiceMes] + "</h4></th>"
              html += "</tr>";
      html += "<tr align=center>";
      for (var ndia = 0; ndia < 7; ndia++)
        html += "<th><font size=2><b>" + this.iface.dias[ndia] + "</b></font></th>";
      html += "</tr>";

      for (var semana = 1; semana <= 6; semana++) {
        html += "<tr align=right>";
        for (var ndia = 1; ndia <= 7; ndia++) {
          if (semana == 1 && dia == -1) {
            var diaUno: Date = new Date(this.iface.anyo, indiceMes + 1, 1);
            var diaSem: Number = diaUno.getDay();
            if (diaSem == ndia)
              dia = 1;
          } else {
            if (dia != -1) {
              dia ++;
              if (dia > tamMeses[indiceMes])
                dia = -1;
            }
          }
          var fecha: Date = new Date(this.iface.anyo, indiceMes + 1, dia)
          var existeDia = util.sqlSelect("calendariolab", "fecha", "fecha = '" + fecha + "'");

          if (dia != -1 && existeDia) {
            var codHorario: String = util.sqlSelect("calendariolab", "codHorario", "fecha = '" + fecha + "'");
            var etiColor: String = "";
            if (codHorario && codHorario != "") {
              var color: String = util.sqlSelect("horarioslab", "color", "codhorario = '" + codHorario + "'");
              if (color && color != "Blanco")
                etiColor = " bgcolor=" + this.iface.colores[color] + " ";
            }
            html += "<td width=5 height=4" + etiColor + "><font size=2>" + dia + "</font></td>";
          } else
            html += "<td  width=5 height=4></td>";
        }
        html += "</tr>";
      }

      html += "</table>";
      var descMes: String = util.sqlSelect("anyoscalendario", this.iface.mesesTabla[indiceMes].lower(), "anyo = '" + this.iface.anyo + "'");
      if (!descMes)
        descMes = "";
      html += "<font size=2>" +  descMes + "</font>";
      html += "</td>";
      indiceMes++;
      dia = -1;
    }
    html += "</tr>";
  }

  html += "</table></center>";


  var qry: FLSqlQuery = new FLSqlQuery();
  qry.setTablesList("horarioslab");
  qry.setSelect("color,descripcion");
  qry.setFrom("horarioslab");
  qry.setWhere("1=1 ORDER BY codhorario");

  if (!qry.exec())
    return false;

  var descAnyo: String = util.sqlSelect("anyoscalendario", "general", "anyo = '" + this.iface.anyo + "'");
  if (!descAnyo)
    descAnyo = "";

  while (descAnyo.find("\n") >= 0) {
    descAnyo = descAnyo.replace("\n", "<br>");
  }
  html += "<center><table border=\"0\" cellpadding=0 cellspacing=3>";
  html += "<tr>";
  html += "<td width=550><font size=2>" + descAnyo + "</font></tr>";
  html += "<td align=right>";
  html += "<table border=\"0\" cellpadding=0 cellspacing=3>";
  var abrirTr: Boolean = true;
  while (qry.next()) {
    if (abrirTr)
      html += "<tr>";

    if (qry.value("color") != "Blanco") {
      html += "<td width=10 height=8 bgcolor=" + this.iface.colores[qry.value("color")] + "></td>";
    } else {
      html += "<td></td>";
    }
    html += "<td width=90><font size=2>" + qry.value("descripcion") + "</font></td>";
    if (abrirTr) {
      html += "</tr>";
      abrirTr = false;
    } else {
      abrirTr = true;
    }
  }
  html += "</table>";
  html += "</td>";
  html += "</tr>";
  html += "</table></center>";

  this.iface.tedCalendario.clear();
  this.iface.tedCalendario.append(html);
}

function calendariolab_calcularMes(fila: Number, ndia: Number, dia: Number): Number {

  var indDia: Number = ndia;
  var mes: Number;
  switch (fila)
  {
    case 1:
      mes = 1;
      break;
    case 2:
      mes = 5;
      break;
    case 3:
      mes = 9;
      break;
  }
  while (indDia > 7)
  {
    indDia = indDia - 7;
    mes ++;
  }

  return mes;
}

function calendariolab_establecerArrays()
{
  this.iface.colores = new Array();
  this.iface.colores["Gris"] = "#CCCCCC";
  this.iface.colores["Amarillo"] = "#FFFF66";
  this.iface.colores["Rojo"] = "#FF3333";
  this.iface.colores["Verde"] = "#00CC66";
  this.iface.colores["Azul"] = "#99CFFF";

  this.iface.dias = [ "Lun", "Mar", "Mie", "Jue", "Vie", "Sab", "Dom" ];
  this.iface.meses = [ "ENERO", "FEBRERO", "MARZO", "ABRIL", "MAYO", "JUNIO", "JULIO", "AGOSTO", "SEPTIEMBRE", "OCTUBRE", "NOVIEMBRE", "DICIEMBRE" ];
  this.iface.mesesTabla = [ "ENERO", "FEBRERO", "MARZO", "ABRIL", "MAYO", "JUNIO", "JULIO", "AGOSTO", "SEPTIEMBRE", "OCTUBRE", "NOVIEMBRE", "DICIEMBRE" ];
}

function calendariolab_tituloCalendario()
{
  return "Calendario laboral " + this.iface.anyo;
}

function calendariolab_cambiarHorarios()
{
  var f: Object = new FLFormSearchDB("cambiarhorario");
  var cursor: FLSqlCursor = f.cursor();

  cursor.select();
  cursor.first();
  cursor.setModeAccess(cursor.Edit);
  f.setMainWidget();
  cursor.refreshBuffer();
  cursor.transaction(false);
  var acpt: Boolean = false;
  f.exec("nombre");
  acpt = f.accepted();
  if (!acpt)
    cursor.rollback();
  else {
    if (cursor.commitBuffer())
      cursor.commit();
  }
}
//// CALENDARIO_LAB /////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
