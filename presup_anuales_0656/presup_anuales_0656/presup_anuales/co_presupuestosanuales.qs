/***************************************************************************
                 presupuestosanuales.qs  -  description
                             -------------------
    begin                : lun abr 26 2004
    copyright            : (C) 2004 by InfoSiAL S.L.
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
  var tlbReal: Object;
  var tlbPresupuestaria: Object;
  var tbnFiltrar: Object;
  var tbnGenrarPartidas: Object;
  var tbnBorrarUno: Object;
  var tbnBorrarTodos: Object;

  var posActualPuntoSubcuentaI: Number;
  var posActualPuntoSubcuentaF: Number;
  var ejercicioActual: String;
  var longSubcuenta: Number;
  var bloqueoSubcuentaI: Boolean;
  var bloqueoSubcuentaF: Boolean;

  var filaSeleccionada: Number;
  const FECHA = 0;
  const CODIGO = 1;
  const DESCCC = 2;
  const SALDO = 3;
  const DESCRIPCION = 4;
  const CODCC = 5;

  var porCC_;
  function oficial(context)
  {
    interna(context);
  }
  function mostrarPartidas()
  {
    return this.ctx.oficial_mostrarPartidas()
  }
         function mostrarPartidasReales()
  {
    return this.ctx.oficial_mostrarPartidasReales();
  }
  function generarPartidasPresupuestarias()
  {
    return this.ctx.oficial_generarPartidasPresupuestarias();
  }
  function mostrarPartidasPresupuestarias()
  {
    return this.ctx.oficial_mostrarPartidasPresupuestarias();
  }
  function borrarTodos_clicked()
  {
    return this.ctx.oficial_borrarTodos_clicked();
  }
  function borrarUno_clicked()
  {
    return this.ctx.oficial_borrarUno_clicked();
  }
  function borrarUno(fila: Number)
  {
    return this.ctx.oficial_borrarUno(fila);
  }
  function tablaPresupuestaria_clicked(fila: Number, col: Number)
  {
    return this.ctx.oficial_tablaPresupuestaria_clicked(fila, col);
  }
  function bufferChanged(fN)
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
  this.iface.tlbReal = this.child("tlbReal");
  this.iface.tlbPresupuestaria = this.child("tlbPresupuestaria");
  this.iface.tbnFiltrar = this.child("tbnFiltrar");
  this.iface.tbnGenrarPartidas = this.child("tbnGenrarPartidas");
  this.iface.tbnBorrarUno = this.child("tbnBorrarUno");
  this.iface.tbnBorrarTodos = this.child("tbnBorrarTodos");
  this.iface.filaSeleccionada = -1;

  this.iface.ejercicioActual = flfactppal.iface.pub_ejercicioActual();
  this.iface.longSubcuenta = util.sqlSelect("ejercicios", "longsubcuenta",  "codejercicio = '" + this.iface.ejercicioActual + "'");
  this.iface.posActualPuntoSubcuentaI = -1;
  this.iface.posActualPuntoSubcuentaF = -1;
  this.iface.bloqueoSubcuentaI = false;
  this.iface.bloqueoSubcuentaF = false;
  this.child("fdbIdSubcuentaInicio").setFilter("codejercicio = '" + this.iface.ejercicioActual + "'");
  this.child("fdbIdSubcuentaFin").setFilter("codejercicio = '" + this.iface.ejercicioActual + "'");

  this.iface.tlbReal.setNumCols(6);
  this.iface.tlbReal.setColumnWidth(this.iface.FECHA, 80);
  this.iface.tlbReal.setColumnWidth(this.iface.CODIGO, 80);
  this.iface.tlbReal.setColumnWidth(this.iface.DESCCC, 130);
  this.iface.tlbReal.setColumnWidth(this.iface.SALDO, 60);
  this.iface.tlbReal.setColumnWidth(this.iface.DESCRIPCION, 100);
  this.iface.tlbReal.setColumnWidth(this.iface.CODCC, 60);
  this.iface.tlbReal.setColumnLabels("/", util.translate("scripts", "FECHA/COD SCTA./DESC C COSTE/SALDO/DESC SCTA/COD CC"));

  this.iface.tlbPresupuestaria.setNumCols(6);
  this.iface.tlbPresupuestaria.setColumnWidth(this.iface.FECHA, 80);
  this.iface.tlbPresupuestaria.setColumnWidth(this.iface.CODIGO, 80);
  this.iface.tlbPresupuestaria.setColumnWidth(this.iface.DESCCC, 130);
  this.iface.tlbPresupuestaria.setColumnWidth(this.iface.SALDO, 60);
  this.iface.tlbPresupuestaria.setColumnWidth(this.iface.DESCRIPCION, 100);
  this.iface.tlbPresupuestaria.setColumnWidth(this.iface.CODCC, 60);
  this.iface.tlbPresupuestaria.setColumnLabels("/", util.translate("scripts", "FECHA/COD SCTA./DESC C COSTE/SALDO/DESC SCTA/COD CC"));

  connect(this.iface.tbnFiltrar, "clicked()", this, "iface.mostrarPartidas");
  connect(this.iface.tbnGenrarPartidas, "clicked()", this, "iface.generarPartidasPresupuestarias");
  connect(this.iface.tbnBorrarUno, "clicked()", this, "iface.borrarUno_clicked()");
  connect(this.iface.tbnBorrarTodos, "clicked()", this, "iface.borrarTodos_clicked()");
  connect(this.iface.tlbPresupuestaria, "clicked(int, int)", this, "iface.tablaPresupuestaria_clicked");
  connect(this.cursor(), "bufferChanged(QString)", this, "iface.bufferChanged");
  this.iface.mostrarPartidas();

  switch (this.cursor().modeAccess()) {
    case this.cursor().Edit: {
      if (util.sqlSelect("co_asientos", "idasiento", "codejercicio = '" + this.cursor().valueBuffer("codejerciciopresupuesto") + "'")) {
        this.child("fdbPeriodicidad").setDisabled(true);
      }
      break;
    }
  }
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
///////////////////////////////////////////////////////////////////
//// OFICIAL ////////////////////////////////////////////////////
function oficial_mostrarPartidas()
{
  this.iface.mostrarPartidasReales();
  this.iface.mostrarPartidasPresupuestarias();
}
function oficial_mostrarPartidasReales()
{
  var cursor: FLSqlCursor = this.cursor();
  var util: FLUtil;
  var _i = this.iface;

  var filas: Number = this.iface.tlbReal.numRows();

  try {
    this.iface.tlbReal.clear();
  } catch (e) {
    var i: Number = 0;
    while (filas >= 0) {
      i++;
      util.setProgress(i);
      this.iface.tlbReal.removeRow(i);
      filas = filas - 1;
    }
  }

  var where: String = "";
  var whereFechas: String = "";
  var codEjercicio: String = cursor.valueBuffer("codejercicioorigen");
  if (codEjercicio && codEjercicio != "") {
    where = "a.codejercicio = '" + codEjercicio + "'";
  }

  _i.porCC_ = false;
  var codCentroInicio = cursor.valueBuffer("codcentroinicio");
  if (codCentroInicio && codCentroInicio != "") {
    _i.porCC_ = true;
    if (where != "") {
      where += " AND ";
    }
    where += "pcc.codcentro >= '" + codCentroInicio + "'";

    var codCentroFin: String = cursor.valueBuffer("codcentrofin");
    if (codCentroFin && codCentroFin != "") {
      if (where != "") {
        where += " AND ";
      }
      where += "pcc.codcentro <= '" + codCentroFin + "'";
    }
  }

  var codSubcuentaInicio: String = cursor.valueBuffer("codsubcuentainicio");
  if (codSubcuentaInicio && codSubcuentaInicio != "") {
    if (where != "")
      where += " AND ";
    where += "p.codsubcuenta >= '" + codSubcuentaInicio + "'";
  }

  var codSubcuentaFin: String = cursor.valueBuffer("codsubcuentafin");
  if (codSubcuentaFin && codSubcuentaFin != "") {
    if (where != "")
      where += " AND ";
    where += "p.codsubcuenta <= '" + codSubcuentaFin + "'";
  }

  if (where == "")
    where = "1=1";

  var fInicio: Date = cursor.valueBuffer("fechainicio");
  fInicio = fInicio.setDate(1);
  var fFin: Date = cursor.valueBuffer("fechafin");

  if (!fInicio || fInicio == "" || !fFin || fFin == "")
    return;

  var meses: Number = 0;
  var periodicidad: String = cursor.valueBuffer("periodicidad");
  switch (periodicidad) {
    case "Mensual": {
      meses = 1;
      break;
    }
    case "Trimestral": {
      meses = 3;
      break;
    }
    case "Semestral": {
      meses = 6;
      break;
    }
    case "Anual": {
      meses = 12;
      break;
    }
  }

  var fInicioP: Date  = cursor.valueBuffer("fechainicio");
  fInicioP = fInicioP.setDate(1);
  var fFinP: Date = cursor.valueBuffer("fechafin");
  filas = 0;
  while (util.daysTo(fInicioP, fFin) >= 0) {

    fFinP = util.addMonths(fInicioP, meses);
    fFinP = util.addDays(fFinP, -1);

    if (util.daysTo(fFinP, fFin) < 0)
      fFinP = fFin;

    if (fInicioP && fInicioP != "") {
      whereFechas = " AND a.fecha >= '" + fInicioP + "'";
    }
    if (fInicioP && fInicioP != "") {
      whereFechas += " AND a.fecha <= '" + fFinP + "'";
    }

    debug("whereFechas " + whereFechas);
    var qry: FLSqlQuery = new FLSqlQuery();
    if (_i.porCC_) {
      qry.setTablesList("co_asientos,co_partidas,co_subcuentas,centroscoste");
      qry.setSelect("p.codsubcuenta,sc.descripcion,pcc.codcentro,cc.descripcion, SUM(p.debe-p.haber), SUM(pcc.importe)");
      qry.setFrom("co_asientos a INNER JOIN co_partidas p ON a.idasiento = p.idasiento INNER JOIN co_subcuentas sc ON p.idsubcuenta = sc.idsubcuenta INNER JOIN co_partidascc pcc ON p.idpartida = pcc.idpartida INNER JOIN centroscoste cc ON pcc.codcentro = cc.codcentro");
      qry.setWhere(where + whereFechas + " GROUP BY p.codsubcuenta,sc.descripcion,pcc.codcentro,cc.descripcion ORDER BY p.codsubcuenta");
    } else {
      qry.setTablesList("co_asientos,co_partidas,co_subcuentas,centroscoste");
      qry.setSelect("p.codsubcuenta, sc.descripcion, SUM(p.debe-p.haber)");
      qry.setFrom("co_asientos a INNER JOIN co_partidas p ON a.idasiento = p.idasiento INNER JOIN co_subcuentas sc ON p.idsubcuenta = sc.idsubcuenta LEFT OUTER JOIN co_partidascc pcc ON p.idpartida = pcc.idpartida");
      qry.setWhere(where + whereFechas + " AND pcc.idpartida IS NULL GROUP BY p.codsubcuenta,sc.descripcion ORDER BY p.codsubcuenta");
    }
    qry.setForwardOnly(true);
    if (!qry.exec())
      return false;
    debug(qry.sql());

    var saldo;
    while (qry.next()) {
      this.iface.tlbReal.insertRows(filas);
      this.iface.tlbReal.setText(filas, this.iface.FECHA, util.dateAMDtoDMA(fInicioP));
      this.iface.tlbReal.setText(filas, this.iface.CODIGO, qry.value("p.codsubcuenta"));
      this.iface.tlbReal.setText(filas, this.iface.DESCRIPCION, qry.value("sc.descripcion"));
      if (_i.porCC_) {
        this.iface.tlbReal.setText(filas, this.iface.CODCC, qry.value("pcc.codcentro"));
        this.iface.tlbReal.setText(filas, this.iface.DESCCC, qry.value("cc.descripcion"));
        saldo = qry.value("SUM(pcc.importe)");
        saldo = qry.value("SUM(p.debe-p.haber)") < 0 ? saldo * -1 : saldo;
      } else {
        saldo = qry.value("SUM(p.debe-p.haber)");
      }
      this.iface.tlbReal.setText(filas, this.iface.SALDO, saldo);
      filas ++;
    }
    fInicioP = util.addDays(fFinP, 1);

  }
}

function oficial_mostrarPartidasPresupuestarias()
{
  var util: FLUtil;
  var cursor: FLSqlCursor = this.cursor();
  var codEjercicioPres: String = cursor.valueBuffer("codejerciciopresupuesto");
  if (!codEjercicioPres || codEjercicioPres == "")
    return;

  var codEjercicio: String = cursor.valueBuffer("codejercicioorigen");
  if (!codEjercicio || codEjercicio == "")
    return;

  var anioO: Number = parseInt(util.sqlSelect("ejercicios", "fechainicio", "codejercicio = '" + codEjercicio + "'").toString().left(4));
  var anioD: Number = parseInt(util.sqlSelect("ejercicios", "fechainicio", "codejercicio = '" + codEjercicioPres + "'").toString().left(4));
  var anios: Number = anioD - anioO;

  var filas: Number = this.iface.tlbPresupuestaria.numRows();

  try {
    this.iface.tlbPresupuestaria.clear();
  } catch (e) {
    var i: Number = 0;
    while (filas >= 0) {
      i++;
      util.setProgress(i);
      this.iface.tlbPresupuestaria.removeRow(i);
      filas = filas - 1;
    }
  }

  filas = 0;
  var curAsiento: FLSqlCursor = new FLSqlCursor("co_asientos");
  var curPartida: FLSqlCursor = new FLSqlCursor("co_partidas");
  var incremento: Number = parseFloat(cursor.valueBuffer("incsaldosporcentual"));
  var saldo: Number = 0;

  for (var i = 0; i < this.iface.tlbReal.numRows(); i++) {
    fecha = util.dateDMAtoAMD(this.iface.tlbReal.text(i, this.iface.FECHA));
    fecha = util.addYears(fecha, anios);

    var masWhere: String = "";
    if (this.iface.tlbReal.text(i, this.iface.CODCC) && this.iface.tlbReal.text(i, this.iface.CODCC) != "")
      masWhere = " AND codcentro = '" + this.iface.tlbReal.text(i, this.iface.CODCC) + "'";
    else {
      if (this.iface.tlbReal.text(i, this.iface.CODCC) == "")
        masWhere = " AND (codcentro is null or codcentro = '')";
    }

    var idAsiento: Number = util.sqlSelect("co_asientos", "idasiento", "codejercicio = '" + codEjercicioPres + "' AND fecha = '" + fecha + "'" + masWhere);
    if (!idAsiento) {
      curAsiento.setModeAccess(curAsiento.Insert);
      curAsiento.refreshBuffer();
      curAsiento.setValueBuffer("codejercicio", codEjercicioPres);
      curAsiento.setValueBuffer("numero", flcontppal.iface.siguienteNumero(codEjercicioPres, "nasiento"));
      curAsiento.setValueBuffer("fecha", fecha);
      curAsiento.setValueBuffer("codcentro", this.iface.tlbReal.text(i, this.iface.CODCC));
      if (!curAsiento.commitBuffer())
        return false;

      idAsiento = curAsiento.valueBuffer("idasiento");
      if (!idAsiento)
        return false;
    }

    saldo = util.sqlSelect("co_partidas", "debe-haber", "idasiento = " + idAsiento + " AND codsubcuenta = '" + this.iface.tlbReal.text(i, this.iface.CODIGO) + "'");
    if (!saldo)
      saldo = 0;
    this.iface.tlbPresupuestaria.insertRows(filas);
    this.iface.tlbPresupuestaria.setText(filas, this.iface.FECHA, util.dateAMDtoDMA(fecha));
    this.iface.tlbPresupuestaria.setText(filas, this.iface.CODIGO, this.iface.tlbReal.text(i, this.iface.CODIGO));
    this.iface.tlbPresupuestaria.setText(filas, this.iface.DESCRIPCION, util.sqlSelect("co_subcuentas", "descripcion", "codsubcuenta = '" + this.iface.tlbReal.text(i, this.iface.CODIGO) + "'"));
    this.iface.tlbPresupuestaria.setText(filas, this.iface.CODCC, this.iface.tlbReal.text(i, this.iface.CODCC));
    if (this.iface.tlbReal.text(i, this.iface.CODCC) && this.iface.tlbReal.text(i, this.iface.CODCC) != "")
      this.iface.tlbPresupuestaria.setText(filas, this.iface.DESCCC, util.sqlSelect("centroscoste", "descripcion", "codcentro = '" + this.iface.tlbReal.text(i, this.iface.CODCC) + "'"));
    this.iface.tlbPresupuestaria.setText(filas, this.iface.SALDO, saldo);
    filas ++;
  }

  if (util.sqlSelect("co_asientos", "idasiento", "codejercicio = '" + codEjercicioPres + "'"))
    this.child("fdbPeriodicidad").setDisabled(true);
}

function oficial_generarPartidasPresupuestarias()
{
  var util: FLUtil;
  var cursor: FLSqlCursor = this.cursor();
  var codEjercicioPres: String = cursor.valueBuffer("codejerciciopresupuesto");
  if (!codEjercicioPres || codEjercicioPres == "")
    return;

  var codEjercicio: String = cursor.valueBuffer("codejercicioorigen");
  if (!codEjercicio || codEjercicio == "")
    return;

  var anioO: Number = parseInt(util.sqlSelect("ejercicios", "fechainicio", "codejercicio = '" + codEjercicio + "'").toString().left(4));
  var anioD: Number = parseInt(util.sqlSelect("ejercicios", "fechainicio", "codejercicio = '" + codEjercicioPres + "'").toString().left(4));
  var anios: Number = anioD - anioO;

  var filas: Number = this.iface.tlbPresupuestaria.numRows();

  try {
    this.iface.tlbPresupuestaria.clear();
  } catch (e) {
    var i: Number = 0;
    while (filas >= 0) {
      i++;
      util.setProgress(i);
      this.iface.tlbPresupuestaria.removeRow(i);
      filas = filas - 1;
    }
  }
  filas = 0;
  var curAsiento: FLSqlCursor = new FLSqlCursor("co_asientos");
  var curPartida: FLSqlCursor = new FLSqlCursor("co_partidas");
  var incremento: Number = parseFloat(cursor.valueBuffer("incsaldosporcentual"));
  var saldo: Number = 0;

  for (var i = 0; i < this.iface.tlbReal.numRows(); i++) {
    fecha = util.dateDMAtoAMD(this.iface.tlbReal.text(i, this.iface.FECHA));
    fecha = util.addYears(fecha, anios);
    saldo = parseFloat(this.iface.tlbReal.text(i, this.iface.SALDO)) * (100 + incremento) / 100;
    var idSubcuenta: Number = util.sqlSelect("co_subcuentas", "idsubcuenta", "codejercicio = '" + codEjercicioPres + "' AND codsubcuenta = '" + this.iface.tlbReal.text(i, this.iface.CODIGO) + "'");
    var codCentro = this.iface.tlbReal.text(i, this.iface.CODCC);

    var oPartida = new Object;
    oPartida.idSubcuenta = idSubcuenta;
    oPartida.codEjercicio = codEjercicioPres;
    oPartida.fecha = fecha;
    oPartida.codCentro =  this.iface.tlbReal.text(i, this.iface.CODCC);
    oPartida.saldo = saldo;

    if (!flcontppal.iface.pub_creaPartidaPresupTrans(oPartida)) {
      return false;
    }

    this.iface.tlbPresupuestaria.insertRows(filas);
    this.iface.tlbPresupuestaria.setText(filas, this.iface.FECHA, util.dateAMDtoDMA(fecha));
    this.iface.tlbPresupuestaria.setText(filas, this.iface.CODIGO, this.iface.tlbReal.text(i, this.iface.CODIGO));
    this.iface.tlbPresupuestaria.setText(filas, this.iface.DESCRIPCION, util.sqlSelect("co_subcuentas", "descripcion", "codsubcuenta = '" + this.iface.tlbReal.text(i, this.iface.CODIGO) + "'"));
    this.iface.tlbPresupuestaria.setText(filas, this.iface.CODCC, this.iface.tlbReal.text(i, this.iface.CODCC));
    if (this.iface.tlbReal.text(i, this.iface.CODCC) && this.iface.tlbReal.text(i, this.iface.CODCC) != "")
      this.iface.tlbPresupuestaria.setText(filas, this.iface.DESCCC, util.sqlSelect("centroscoste", "descripcion", "codcentro = '" + this.iface.tlbReal.text(i, this.iface.CODCC) + "'"));
    this.iface.tlbPresupuestaria.setText(filas, this.iface.SALDO, saldo);
    filas ++;
  }
}

function oficial_borrarTodos_clicked()
{
  for (var i = 0; i < this.iface.tlbPresupuestaria.numRows(); i++) {
    this.iface.borrarUno(i);
  }
}

function oficial_borrarUno_clicked()
{
  debug("this.iface.filaSeleccionada " + this.iface.filaSeleccionada);
  if (this.iface.filaSeleccionada > -1)
    this.iface.borrarUno(this.iface.filaSeleccionada);
}

function oficial_borrarUno(fila: Number)
{
  debug("oficial_borrarUno " + fila);
  var util: FLUtil;
  var cursor: FLSqlCursor = this.cursor();
  var codEjercicioPres: String = cursor.valueBuffer("codejerciciopresupuesto");
  if (!codEjercicioPres || codEjercicioPres == "")
    return;

  fecha = util.dateDMAtoAMD(this.iface.tlbPresupuestaria.text(fila, this.iface.FECHA));
  if (!fecha)
    return;

  var masWhere: String = "";
  if (this.iface.tlbPresupuestaria.text(fila, this.iface.CODCC) && this.iface.tlbPresupuestaria.text(fila, this.iface.CODCC) != "")
    masWhere = " AND codcentro = '" + this.iface.tlbPresupuestaria.text(fila, this.iface.CODCC) + "'";

  var idAsiento: Number = util.sqlSelect("co_asientos", "idasiento", "codejercicio = '" + codEjercicioPres + "' AND fecha = '" + fecha + "'" + masWhere);
  if (idAsiento) {
    if (!util.sqlDelete("co_partidas", "idasiento = " + idAsiento))
      return;
    this.iface.tlbPresupuestaria.setText(fila, this.iface.SALDO, 0);
  }
}

function oficial_tablaPresupuestaria_clicked(fila: Number, col: Number)
{
  this.iface.filaSeleccionada = fila;
}

function oficial_bufferChanged(fN)
{
  var util: FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  switch (fN) {
    case "codejercicioorigen": {
      var codEjercicio: String = cursor.valueBuffer("codejercicioorigen");
      if (codEjercicio && codEjercicio != "") {
        this.child("fdbFechaInicio").setValue(util.sqlSelect("ejercicios", "fechainicio", "codejercicio = '" + codEjercicio + "'"));
        this.child("fdbFechaFin").setValue(util.sqlSelect("ejercicios", "fechafin", "codejercicio = '" + codEjercicio + "'"));
      }
      break;
    }
    case "codcentroinicio": {
      var codCentro: String = cursor.valueBuffer("codcentroinicio");
      if (!cursor.valueBuffer("codcentrofin") || cursor.valueBuffer("codcentrofin") == "") {
        if (util.sqlSelect("centroscoste", "codcentro", "codcentro = '" + codCentro + "'"))
          this.child("fdbCodCentroFin").setValue(codCentro);
      }
      break;
    }
    case "codsubcuentainicio": {
      if (!this.iface.bloqueoSubcuentaI) {
        this.iface.bloqueoSubcuentaI = true;
        this.iface.posActualPuntoSubcuentaI = flcontppal.iface.pub_formatearCodSubcta(this, "fdbCodSubcuentaInicio", this.iface.longSubcuenta, this.iface.posActualPuntoSubcuentaI);
        this.iface.bloqueoSubcuentaI = false;

        var codScta: String = cursor.valueBuffer("codsubcuentainicio");
        if (!cursor.valueBuffer("codsubcuentafin") || cursor.valueBuffer("codsubcuentafin") == "") {
          if (util.sqlSelect("co_subcuentas", "idsubcuenta", "codsubcuenta = '" + codScta + "'"))
            this.child("fdbCodSubcuentaFin").setValue(codScta);
        }
      }
      break;
    }
    case "codsubcuentafin": {
      if (!this.iface.bloqueoSubcuentaF) {
        this.iface.bloqueoSubcuentaF = true;
        this.iface.posActualPuntoSubcuentaF = flcontppal.iface.pub_formatearCodSubcta(this, "fdbCodSubcuentaFin", this.iface.longSubcuenta, this.iface.posActualPuntoSubcuentaF);
        this.iface.bloqueoSubcuentaF = false;
      }
      break;
    }
  }
}
//// OFICIAL ////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
////////////////////////////////////////////////////////////