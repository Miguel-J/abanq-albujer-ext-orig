/***************************************************************************
                 fo_asistenciamensual.qs  -  description
                             -------------------
    begin                : vie ene 28 2011
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
  function calculateField(fN: String)
  {
    return this.ctx.interna_calculateField(fN);
  }
  function main()
  {
    return this.ctx.interna_main();
  }
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna
{
  var aColsLectivas, aAlumnoFila, aValoresContrato, aValoresSinContrato, fila_clicked_, columna_clicked_, aClientes;
  var modo_;
  var blanco_, gris_, verde_, amarillo_, rojo_;
  var tdbMes;
  function oficial(context)
  {
    interna(context);
  }
  function bufferChanged(fN: String)
  {
    return this.ctx.oficial_bufferChanged(fN);
  }
  function pushButtonAccept_clicked()
  {
    return this.ctx.oficial_pushButtonAccept_clicked();
  }
  function guardar()
  {
    return this.ctx.oficial_guardar();
  }
  function pushButtonCancel_clicked()
  {
    return this.ctx.oficial_pushButtonCancel_clicked();
  }
  function formReady()
  {
    return this.ctx.oficial_formReady();
  }
  function tbnCalcular_clicked()
  {
    return this.ctx.oficial_tbnCalcular_clicked();
  }
  function calcular()
  {
    return this.ctx.oficial_calcular();
  }
  function cargarArrays()
  {
    return this.ctx.oficial_cargarArrays();
  }
  function establecerAsistencia(fila, col)
  {
    return this.ctx.oficial_establecerAsistencia(fila, col);
  }
  /*  function calcularSaldoTiquets(codCliente) {
      return this.ctx.oficial_calcularSaldoTiquets(codCliente);
    }*/
  function siguienteValorArray(array, valorActual)
  {
    return this.ctx.oficial_siguienteValorArray(array, valorActual);
  }
  function tieneContrato(codAlumno)
  {
    return this.ctx.oficial_tieneContrato(codAlumno);
  }
  function tbnEnfermedad_clicked()
  {
    return this.ctx.oficial_tbnEnfermedad_clicked();
  }
  function actualizarTiquesCliente(codCliente)
  {
    return this.ctx.oficial_actualizarTiquesCliente(codCliente);
  }
  function cargarAsistencias()
  {
    return this.ctx.oficial_cargarAsistencias();
  }
  function establecerColorAsistencia(asistencia)
  {
    return this.ctx.oficial_establecerColorAsistencia(asistencia);
  }
  function imprimir()
  {
    return this.ctx.oficial_imprimir();
  }
  function habilitarPorModo()
  {
    return this.ctx.oficial_habilitarPorModo();
  }
  function cambiarModo(modo)
  {
    return this.ctx.oficial_cambiarModo(modo);
  }
  function tbnCancelar_clicked()
  {
    return this.ctx.oficial_tbnCancelar_clicked();
  }
  function colores()
  {
    return this.ctx.oficial_colores();
  }
  function filtrarPorCentro()
  {
    return this.ctx.oficial_filtrarPorCentro();
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
  this.iface.colores();
  debug("init");
  var cursor = this.cursor();

  _i.tdbMes = this.child("tdbMes");

  connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");
  connect(this, "formReady()", this, "iface.formReady");
  connect(this.child("tbnCalcular"), "clicked()", this, "iface.tbnCalcular_clicked");
  connect(this.child("tbnEnfermedad"), "clicked()", this, "iface.tbnEnfermedad_clicked");
  connect(_i.tdbMes, "clicked(int,int)", this, "iface.establecerAsistencia");
  disconnect(this.child("pushButtonAccept"), "clicked()", this.obj(), "accept()");
  connect(this.child("pushButtonAccept"), "clicked()", this, "iface.pushButtonAccept_clicked");
  connect(this.child("tbnGuardar"), "clicked()", this, "iface.pushButtonAccept_clicked");
  connect(this.child("tbnCancelar"), "clicked()", this, "iface.tbnCancelar_clicked");
  disconnect(this.child("pushButtonCancel"), "clicked()", this.obj(), "reject()");
  connect(this.child("pushButtonCancel"), "clicked()", this, "iface.pushButtonCancel_clicked");
  connect(this.child("tbnImprimir"), "clicked()", this, "iface.imprimir");

  this.child("pushButtonAccept").close();

  _i.modo_ = "Buscar";
  _i.habilitarPorModo();
  _i.filtrarPorCentro();
}

function interna_calculateField(fN: String)
{
  var util = new FLUtil;
  var cursor = this.cursor();
  var valor: String;

  switch (fN) {
    case "x": {
      break;
    }
  }
  return valor;
}

function interna_main()
{
  debug("va");
  var f = new FLFormSearchDB("fo_asistenciamensual");
  var cursor = f.cursor();

  cursor.select();
  if (!cursor.first()) {
    cursor.setModeAccess(cursor.Insert);
  } else {
    cursor.setModeAccess(cursor.Edit);
  }
  f.setMainWidget();
  //  if (cursor.modeAccess() == cursor.Insert) {
  //    f.child("pushButtonCancel").setDisabled(true);
  //  }
  cursor.refreshBuffer();
  //  var commitOk= false;
  var acpt: Boolean;
  //  cursor.transaction(false);
  //  while (!commitOk) {
  acpt = false;
  f.exec("nombre");
  acpt = f.accepted();
  if (!acpt) {
    //      if (cursor.rollback())
    //        commitOk = true;
  } else {
    //      if (cursor.commitBuffer()) {
    //        cursor.commit();
    //        commitOk = true;
    //      }
  }
  //  }
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_pushButtonAccept_clicked()
{
  if (!this.iface.guardar()) {
    return;
  }
  this.iface.cambiarModo("Pendiente");
  //  this.accept();
}

function oficial_guardar()
{
  var util = new FLUtil();
  var cursor = this.cursor();
  var _i = this.iface;
  var numFilas = _i.tdbMes.numRows();
  var numColumnas = _i.tdbMes.numCols();
  var i, j, textoCelda, codAlumno, fecha;
  var codActividad = cursor.valueBuffer("codactividad");
  var curAsistencia = new FLSqlCursor("fo_asistenciaact");
  curAsistencia.setActivatedCommitActions(false);

  util.createProgressDialog(util.translate("scripts", "Guardando datos..."), numFilas);
  for (i = 1; i < numFilas; i++) {
    util.setProgress(i);
    codAlumno = this.iface.aAlumnoFila[i]["codalumno"];
    for (j = 2; j < numColumnas; j++) {
      fecha = this.iface.aColsLectivas[j]["fecha"];
      textoCelda = _i.tdbMes.text(i, j);
      if (textoCelda == "" || textoCelda == " ") {
        util.sqlDelete("fo_asistenciaact", "codactividad = '" + codActividad + "' AND fecha = '" + fecha + "' AND codalumno = '" + codAlumno + "'");
      } else {
        curAsistencia.select("codactividad = '" + codActividad + "' AND fecha = '" + fecha + "' AND codalumno = '" + codAlumno + "'");
        if (!curAsistencia.first()) {
          curAsistencia.setModeAccess(curAsistencia.Insert);
          curAsistencia.refreshBuffer();
          curAsistencia.setValueBuffer("codalumno", codAlumno);
          curAsistencia.setValueBuffer("fecha", fecha);
          curAsistencia.setValueBuffer("codactividad", codActividad);
          curAsistencia.setValueBuffer("asistencia", textoCelda);
          if (!curAsistencia.commitBuffer()) {
            util.destroyProgressDialog();
            return false;
          }
        } else {
          curAsistencia.setModeAccess(curAsistencia.Edit);
          curAsistencia.refreshBuffer();
          curAsistencia.setValueBuffer("asistencia", textoCelda);
          if (!curAsistencia.commitBuffer()) {
            util.destroyProgressDialog();
            return false;
          }
        }
      }
    }

    /// Totalización de saldos
    debug("/// Totalización de saldos");
    curAsistencia.setModeAccess(curAsistencia.Insert);
    curAsistencia.refreshBuffer();
    debug("codAlumno " + codAlumno);
    curAsistencia.setValueBuffer("codalumno", codAlumno);
    curAsistencia.setValueBuffer("codactividad", codActividad);
    if (!flformppal.iface.pub_controlTiquesActividadesAs(curAsistencia)) {
      util.destroyProgressDialog();
      debug("false");
      return false;
    }
  }
  util.destroyProgressDialog();

  return true;
}

function oficial_pushButtonCancel_clicked()
{
  var util = new FLUtil();
  if (this.iface.modo_ == "Editar") {
    var res = MessageBox.information(util.translate("scripts", "Va a cerrar el formulario. Se perderán todos los cambios que no se hayan guardado.\n¿Está seguro?"), MessageBox.Yes, MessageBox.No);
    if (res != MessageBox.Yes) {
      return false;
    }
  }
  this.close();
}

function oficial_bufferChanged(fN: String)
{
  var util = new FLUtil;
  var cursor = this.cursor();
  switch (fN) {
    case "X": {
      break;
    }
    default: {
      if (this.iface.modo_ == "Pendiente") {
        this.iface.cambiarModo("Buscar");
      }
      break;
    }
  }
}

function oficial_formReady()
{
}

function oficial_tbnCalcular_clicked()
{
  this.iface.calcular()
}
function oficial_calcular()
{
  var _i = this.iface;
  _i.tdbMes.setTopMargin(0);
  _i.tdbMes.setLeftMargin(0);
  var util = new FLUtil;
  var cursor = this.cursor();
  var idGrupo = cursor.valueBuffer("idgrupo");
  if (!idGrupo) {
    return false;
  }
  var codCentro = util.sqlSelect("fo_gruposcurso", "codcentro", "idgrupo = " + idGrupo);
  if (!codCentro || codCentro == "") {
    MessageBox.waning(util.translate("scripts", "El grupo escogido no tiene centro asociado"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton, "AbanQ");
    return false;
  }
  var fecha = cursor.valueBuffer("fecha");
  if (!fecha) {
    return false;
  }

  var actividad = cursor.valueBuffer("codactividad");
  if (!actividad) {
    return false;
  }
  fecha.setDate(1);
  var colInicial = 1;
  var fechaFinMes = new Date(Date.parse(fecha.toString()));
  fechaFinMes = util.addMonths(fechaFinMes, 1);
  var numDias = util.daysTo(fecha, fechaFinMes);
  var numCols = numDias + colInicial + 1;
  _i.tdbMes.setNumCols(numCols);
  _i.tdbMes.setColumnWidth(0, 150);
  _i.tdbMes.setColumnWidth(1, 60);

  var qryAlumnos = new FLSqlQuery;
  qryAlumnos.setTablesList("fo_alumnosgrupocurso,fo_alumnos");
  qryAlumnos.setSelect("a.codalumno, a.nombre, a.codcliente");
  qryAlumnos.setFrom("fo_alumnosgrupocurso ag INNER JOIN fo_alumnos a ON ag.codalumno = a.codalumno");
  qryAlumnos.setWhere("idgrupo = " + idGrupo + " ORDER BY a.nombre");
  qryAlumnos.setForwardOnly(true);
  if (!qryAlumnos.exec()) {
    return false;
  }
  var totalAlumnos = qryAlumnos.size();
  if (this.iface.aAlumnoFila == undefined) {
    this.iface.aAlumnoFila = new Array(totalAlumnos);
  } else {
    this.iface.aAlumnoFila.length = totalAlumnos;
  }

  _i.tdbMes.setNumRows(totalAlumnos + 1);
  var fil = 1;
  this.iface.aAlumnoFila[0] = totalAlumnos;
  var codAlumno, codCliente;
  while (qryAlumnos.next()) {
    //if (!(fil in this.iface.aAlumnoFila)) {
    this.iface.aAlumnoFila[fil] = [];
    //}
    codAlumno = qryAlumnos.value("a.codalumno");
    _i.tdbMes.setText(fil, 0, qryAlumnos.value("a.nombre"));
    this.iface.aAlumnoFila[fil]["codalumno"] = codAlumno;
    this.iface.aAlumnoFila[fil]["contrato"] = this.iface.tieneContrato(codAlumno);
    codCliente = qryAlumnos.value("a.codcliente");
    this.iface.aAlumnoFila[fil]["codcliente"] = codCliente;

    fil++;
  }

  var codHorario;
  var codHorarioFest = util.sqlSelect("fo_centros", "codhorariodom", "codcentro = '" + codCentro + "'");
  if (this.iface.aColsLectivas == undefined) {
    this.iface.aColsLectivas = new Array(numCols);
  } else {
    this.iface.aColsLectivas.length = numCols;
  }
  var fechaDia = fecha;
  _i.tdbMes.setText(0, colInicial, "Tiquets");
  for (var dia = 1; dia <= numDias; dia++) {
    var fila;
    col = colInicial + dia;
    //if (!(col in this.iface.aColsLectivas)) {
    this.iface.aColsLectivas[col] = [];
    //}
    _i.tdbMes.setText(0, col, dia.toString());
    _i.tdbMes.setColumnWidth(col, 20);

    codHorario = util.sqlSelect("calendariolab", "codhorario", "fecha = '" + fechaDia.toString().left(10) + "' AND codcentroesc = '" + codCentro + "'");
    if (codHorario == codHorarioFest) {
      this.iface.aColsLectivas[col]["lectivo"] = false;
    } else {
      this.iface.aColsLectivas[col]["lectivo"] = true;
    }
    this.iface.aColsLectivas[col]["fecha"] = fechaDia;
    fechaDia = util.addDays(fechaDia, 1);
  }
  this.iface.cargarArrays();

  this.iface.cargarAsistencias();
  this.iface.cambiarModo("Pendiente");
}

function oficial_cargarAsistencias()
{
  var util = new FLUtil();
  var cursor = this.cursor();

  var actividad = cursor.valueBuffer("codactividad");
  if (!actividad) {
    return false;
  }
  // #### Si no se hace esto hay una fuga de memoria en cada 'child()'
  var _i = this.iface;

  var numFilas = _i.tdbMes.numRows();
  var numColumnas = _i.tdbMes.numCols();
  var i, j, codAlumno, fecha, asistencia, color;
  var codActividad = cursor.valueBuffer("codactividad");

  this.iface.aClientes = new Array();
  var aCliente, saldoTiquets, codCliente;

  util.createProgressDialog(util.translate("scripts", "Cargando datos..."), numFilas);
  for (i = 1; i < numFilas; i++) {
    util.setProgress(i);
    codAlumno = this.iface.aAlumnoFila[i]["codalumno"];
    codCliente = this.iface.aAlumnoFila[i]["codcliente"];
    if (!codCliente || codCliente == "" || this.iface.aAlumnoFila[i]["contrato"]) {
      saldoTiquets = "";
    } else {
      if (codCliente in this.iface.aClientes) {
        aCliente = this.iface.aClientes[codCliente];
      } else {
        this.iface.aClientes[codCliente] = [];
        var saldo = util.sqlSelect("fo_saldotiquetactcli", "saldo", "codcliente = '" + codCliente + "' AND codactividad = '" + actividad + "'"); //flformppal.iface.pub_calcularSaldoTiquets(codCliente, actividad);
        saldo = !saldo || isNaN(saldo) ? 0 : saldo;
        this.iface.aClientes[codCliente]["saldotiquets"] = saldo;
        aCliente = this.iface.aClientes[codCliente];
      }
      saldoTiquets = aCliente["saldotiquets"];
    }
    _i.tdbMes.setText(i, 1, saldoTiquets);

    for (j = 2; j < numColumnas; j++) {
      fecha = this.iface.aColsLectivas[j]["fecha"];
      asistencia = util.sqlSelect("fo_asistenciaact", "asistencia", "codalumno = '" + codAlumno + "' AND fecha = '" + fecha + "' AND codactividad = '" + codActividad + "'");
      if (asistencia && asistencia != "") {
        color = this.iface.establecerColorAsistencia(asistencia);
      } else {
        asistencia = "";
        if (this.iface.aColsLectivas[j]["lectivo"]) {
          color = this.iface.blanco_;
        } else {
          color = this.iface.gris_;
        }
      }
      _i.tdbMes.setText(i, j, asistencia);
      _i.tdbMes.setCellBackgroundColor(i, j, color);
    }
  }
  util.destroyProgressDialog();
  return true;
}

function oficial_establecerColorAsistencia(asistencia)
{
  var color;
  switch (asistencia) {
    case "X":
    case "E": {
      color = new Color(185, 255, 185);
      break;
    }
    case "FC": {
      color = new Color(255, 255, 127);
      break;
    }
    case "FS": {
      color = new Color(225, 80, 64);
      break;
    }
    case "O": {
      color = new Color(207, 137, 105);
      break;
    }
  }
  return color;
}

// function oficial_calcularSaldoTiquets(codCliente)
// {
//  var cursor = this.cursor();
//  var util = new FLUtil();
//  var refEsp = util.sqlSelect("fo_actividades", "refasistenciaesp",  "codactividad = '" + cursor.valueBuffer("codactividad") + "'");
//  var saldo = util.sqlSelect("lineaspedidoscli l INNER JOIN pedidoscli p ON p.idpedido = l.idpedido", "SUM(l.restante)", "p.codcliente = '" + codCliente + "' AND l.referencia = '" + refEsp + "'", "lineaspedidoscli,pedidoscli");
//  if (!saldo || isNaN(saldo)) {
//    saldo = 0;
//  }
//  return saldo;
// }

function oficial_cargarArrays()
{
  var cursor = this.cursor();
  var util = new FLUtil();
  var iCon = 0, iSin = 0;
  this.iface.aValoresContrato = new Array();
  this.iface.aValoresSinContrato = new Array();
  this.iface.aValoresContrato[iCon] = [];
  this.iface.aValoresContrato[iCon]["texto"] = " ";
  this.iface.aValoresContrato[iCon]["color"] = this.iface.blanco_;
  this.iface.aValoresSinContrato[iSin] = [];
  this.iface.aValoresSinContrato[iSin]["texto"] = " ";
  this.iface.aValoresSinContrato[iSin]["color"] = this.iface.blanco_;
  var codActividad = cursor.valueBuffer("codactividad");
  var refAsistencia = util.sqlSelect("fo_actividades", "refasistenciacon", "codactividad = '" + codActividad + "'");
  if (refAsistencia) {
    iCon++;
    this.iface.aValoresContrato[iCon] = [];
    this.iface.aValoresContrato[iCon]["texto"] = "X";
    this.iface.aValoresContrato[iCon]["color"] = this.iface.verde_;
  }
  var refNoAsistenciaCon = util.sqlSelect("fo_actividades", "refnoasisprecon", "codactividad = '" + codActividad + "'");
  if (refNoAsistenciaCon) {
    iCon++;
    this.iface.aValoresContrato[iCon] = [];
    this.iface.aValoresContrato[iCon]["texto"] = "FC";
    this.iface.aValoresContrato[iCon]["color"] = this.iface.amarillo_;
  }
  var refNoAsistenciaSin = util.sqlSelect("fo_actividades", "refnoasiscon", "codactividad = '" + codActividad + "'");
  if (refNoAsistenciaSin) {
    iCon++;
    this.iface.aValoresContrato[iCon] = [];
    this.iface.aValoresContrato[iCon]["texto"] = "FS";
    this.iface.aValoresContrato[iCon]["color"] = this.iface.rojo_;
  }

  var refAsistenciaEsp = util.sqlSelect("fo_actividades", "refasistenciaesp", "codactividad = '" + codActividad + "'");
  if (refAsistenciaEsp) {
    iSin++;
    this.iface.aValoresSinContrato[iSin] = [];
    this.iface.aValoresSinContrato[iSin]["texto"] = "E";
    this.iface.aValoresSinContrato[iSin]["color"] = this.iface.verde_;
  }
}

function oficial_establecerAsistencia(fila, col)
{
  var util = new FLUtil;

  switch (this.iface.modo_) {
    case "Pendiente": {
      this.iface.cambiarModo("Editar");
      break;
    }
    case "Buscar": {
      return;
    }
  }
  this.iface.fila_clicked_ = fila;
  this.iface.columna_clicked_ = col;

  var _i = this.iface;
  var numFilas = _i.tdbMes.numRows();
  var numColumnas = _i.tdbMes.numCols();
  var codCliente;
  var valoresArray;
  if (fila > 0 && fila < numFilas && col > 1 && col < numColumnas && this.iface.aColsLectivas[col]["lectivo"]) {
    if (this.iface.aAlumnoFila[fila]["contrato"]) {
      valoresArray = this.iface.siguienteValorArray(this.iface.aValoresContrato, _i.tdbMes.text(fila, col));
      _i.tdbMes.setText(fila, col, valoresArray["texto"]);
      _i.tdbMes.setCellBackgroundColor(fila, col, valoresArray["color"]);
    } else {
      codCliente = this.iface.aAlumnoFila[fila]["codcliente"];
      if (codCliente && codCliente != "") {
        valoresArray = this.iface.siguienteValorArray(this.iface.aValoresSinContrato, _i.tdbMes.text(fila, col));
        _i.tdbMes.setText(fila, col, valoresArray["texto"]);
        _i.tdbMes.setCellBackgroundColor(fila, col, valoresArray["color"]);
        if (valoresArray["texto"] == "E") {
          this.iface.aClientes[codCliente]["saldotiquets"]--;
        } else {
          this.iface.aClientes[codCliente]["saldotiquets"]++;
        }
        this.iface.actualizarTiquesCliente(codCliente);
      } else {
        MessageBox.warning(util.translate("scripts", "El alumno seleccionado no tiene contrato ni cliente asociados"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton, "AbanQ");
      }
    }
  }
}

function oficial_actualizarTiquesCliente(codCliente)
{
  var _i = this.iface;
  for (var fila = 1; fila <= this.iface.aAlumnoFila[0]; fila++) {
    if (this.iface.aAlumnoFila[fila]["codcliente"] == codCliente) {
      _i.tdbMes.setText(fila, 1, this.iface.aClientes[codCliente]["saldotiquets"]);
    }
  }
}

function oficial_siguienteValorArray(array, valorActual)
{
  var iDato = 0;
  valorActual = valorActual == "" ? " " : valorActual;
  for (var i = 0; i < array.length; i++) {
    if (array[i]["texto"] == valorActual) {
      iDato = i + 1;
    }
  }
  if (iDato >= array.length) {
    iDato = 0;
  }
  return array[iDato];
}

function oficial_tieneContrato(codAlumno)
{
  var cursor = this.cursor();
  var codActividad = cursor.valueBuffer("codactividad");
  var util = new FLUtil();
  var codContrato = util.sqlSelect("contratos c INNER JOIN fo_alumnos a ON c.codcliente = a.codcliente INNER JOIN fo_alumnosactividad aa ON c.codigo = aa.codcontrato", "c.codigo", "a.codalumno = '" + codAlumno + "' AND c.fechainicio <= '" + cursor.valueBuffer("fecha") + "' AND c.estado = 'Vigente' AND aa.codalumno = '" + codAlumno + "' AND aa.codactividad = '" + codActividad + "'", "contratos,fo_alumnos,fo_alumnosactividad");
  if (!codContrato || codContrato == "") {
    return false;
  }
  return true;
}

function oficial_tbnEnfermedad_clicked()
{
  var util = new FLUtil();
  var _i = this.iface;
  var numFilas = _i.tdbMes.numRows();
  var numColumnas = _i.tdbMes.numCols();
  if (this.iface.fila_clicked_ > 0 && this.iface.fila_clicked_ < numFilas && this.iface.columna_clicked_ > 1 && this.iface.columna_clicked_ < numColumnas) {
    if (this.iface.aAlumnoFila[this.iface.fila_clicked_]["contrato"]) {
      if (this.iface.aColsLectivas[this.iface.columna_clicked_]["lectivo"]) {
        var colorEnfermedad = new Color(207, 137, 105);
        _i.tdbMes.setText(this.iface.fila_clicked_, this.iface.columna_clicked_, "O");
        _i.tdbMes.setCellBackgroundColor(this.iface.fila_clicked_, this.iface.columna_clicked_, colorEnfermedad);
      }
    } else {
      MessageBox.information(util.translate("scripts", "El alumno no tiene contrato asociado.\nNo es necesario registrar el día de enfermedad"), MessageBox.Ok, MessageBox.NoButton);
    }
  }
}

function oficial_imprimir()
{
  var cursor = this.cursor();
  var util = new FLUtil();
  var _i = this.iface;
  var grupo = util.sqlSelect("fo_gruposcurso", "descripcion", "idgrupo = " + cursor.valueBuffer("idgrupo"));
  var fecha = cursor.valueBuffer("fecha");
  var mes = fecha.getMonth();
  var actividad = util.sqlSelect("fo_actividades", "descripcion", "codactividad = '" + cursor.valueBuffer("codactividad") + "'");
  var numFilas = _i.tdbMes.numRows();
  var numColumnas = _i.tdbMes.numCols();
  var nombreEmpresa = flfactppal.iface.pub_valorDefectoEmpresa("nombre");
  var centro = util.sqlSelect("fo_gruposcurso g INNER JOIN fo_centros c ON g.codcentro = c.codcentro", "c.nombre", "g.idgrupo = " + cursor.valueBuffer("idgrupo"), "fo_gruposcurso,fo_centros");
  var nombreAlumno, fila, columna;

  var xmlKD = new FLDomDocument;
  xmlKD.setContent("<!DOCTYPE KUGAR_DATA><KugarData/>");
  var eRow: FLDomElement;
  for (fila = 1; fila < numFilas; fila++) {
    nombreAlumno = util.sqlSelect("fo_alumnos", "nombre", "codalumno = '" + this.iface.aAlumnoFila[fila]["codalumno"] + "'");
    eRow = xmlKD.createElement("Row");
    eRow.setAttribute("nombreempresa", nombreEmpresa);
    eRow.setAttribute("centro", centro);
    eRow.setAttribute("grupo", grupo);
    eRow.setAttribute("actividad", actividad);
    eRow.setAttribute("mes", mes);
    eRow.setAttribute("nombrealumno", nombreAlumno);
    eRow.setAttribute("tiquets", _i.tdbMes.text(fila, 1));
    eRow.setAttribute("a1", _i.tdbMes.text(fila, 2));
    eRow.setAttribute("a2", _i.tdbMes.text(fila, 3));
    eRow.setAttribute("a3", _i.tdbMes.text(fila, 4));
    eRow.setAttribute("a4", _i.tdbMes.text(fila, 5));
    eRow.setAttribute("a5", _i.tdbMes.text(fila, 6));
    eRow.setAttribute("a6", _i.tdbMes.text(fila, 7));
    eRow.setAttribute("a7", _i.tdbMes.text(fila, 8));
    eRow.setAttribute("a8", _i.tdbMes.text(fila, 9));
    eRow.setAttribute("a9", _i.tdbMes.text(fila, 10));
    eRow.setAttribute("a10", _i.tdbMes.text(fila, 11));
    eRow.setAttribute("a11", _i.tdbMes.text(fila, 12));
    eRow.setAttribute("a12", _i.tdbMes.text(fila, 13));
    eRow.setAttribute("a13", _i.tdbMes.text(fila, 14));
    eRow.setAttribute("a14", _i.tdbMes.text(fila, 15));
    eRow.setAttribute("a15", _i.tdbMes.text(fila, 16));
    eRow.setAttribute("a16", _i.tdbMes.text(fila, 17));
    eRow.setAttribute("a17", _i.tdbMes.text(fila, 18));
    eRow.setAttribute("a18", _i.tdbMes.text(fila, 19));
    eRow.setAttribute("a19", _i.tdbMes.text(fila, 20));
    eRow.setAttribute("a20", _i.tdbMes.text(fila, 21));
    eRow.setAttribute("a21", _i.tdbMes.text(fila, 22));
    eRow.setAttribute("a22", _i.tdbMes.text(fila, 23));
    eRow.setAttribute("a23", _i.tdbMes.text(fila, 24));
    eRow.setAttribute("a24", _i.tdbMes.text(fila, 25));
    eRow.setAttribute("a25", _i.tdbMes.text(fila, 26));
    eRow.setAttribute("a26", _i.tdbMes.text(fila, 27));
    eRow.setAttribute("a27", _i.tdbMes.text(fila, 28));
    eRow.setAttribute("a28", _i.tdbMes.text(fila, 29));
    eRow.setAttribute("a29", _i.tdbMes.text(fila, 30));
    eRow.setAttribute("a30", _i.tdbMes.text(fila, 31));
    eRow.setAttribute("a31", _i.tdbMes.text(fila, 32));
    eRow.setAttribute("level", 0);
    xmlKD.firstChild().appendChild(eRow);
  }
  debug(xmlKD.toString(4));

  var rptViewer = new FLReportViewer();
  rptViewer.setReportTemplate("fo_i_asistenciamensual");
  rptViewer.setReportData(xmlKD);
  rptViewer.renderReport();
  rptViewer.exec();
}

function oficial_cambiarModo(modo)
{
  this.iface.modo_ = modo;
  this.iface.habilitarPorModo();
}

function oficial_habilitarPorModo()
{
  var _i = this.iface;
  debug("modo " + this.iface.modo_);
  var util = new FLUtil;
  var titulo;
  switch (this.iface.modo_) {
    case "Buscar": {
      this.child("gbxBuscar").enabled = true;
      this.child("gbxEditar").enabled = false;
      _i.tdbMes.enabled = false;
      _i.tdbMes.setNumRows(0);
      titulo = util.translate("sctipts", "Buscando...");
      break;
    }
    case "Editar": {
      this.child("gbxBuscar").enabled = false;
      this.child("gbxEditar").setEnabled(true);
      _i.tdbMes.enabled = true;
      titulo = util.translate("sctipts", "Editando...");
      break;
    }
    case "Pendiente": {
      this.child("gbxBuscar").enabled = true;
      this.child("gbxEditar").setEnabled(true);
      _i.tdbMes.enabled = true;
      titulo = "";
      break;
    }
  }
  this.child("gbxCabecera").title = titulo;
}
function oficial_tbnCancelar_clicked()
{
  var util = new FLUtil;
  if (this.iface.modo_ != "Editar") {
    return;
  }
  var res = MessageBox.warning(util.translate("scripts", "Se calcelarán todos los cambios realizados en el mes actual.\n¿Continuar?"), MessageBox.Yes, MessageBox.No);
  if (res != MessageBox.Yes) {
    return;
  }
  this.iface.cargarAsistencias();
  this.iface.cambiarModo("Pendiente");
}

function oficial_colores()
{
  this.iface.gris_ = new Color(200, 200, 200);
  this.iface.blanco_ = new Color(255, 255, 255);
  this.iface.verde_ = new Color(185, 255, 185);
  this.iface.amarillo_ = new Color(255, 255, 127);
  this.iface.rojo_ = new Color(225, 80, 64);
}

function oficial_filtrarPorCentro()
{
  var util = new FLUtil;
  var idUsuario = sys.nameUser();
  var codCentro = util.sqlSelect("usuarios", "codcentroesc", "idusuario = '" + idUsuario + "'");
  if (codCentro && codCentro != "") {
    this.child("fdbIdGrupo").setFilter("codcentro = '" + codCentro + "'");
  }
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
