/***************************************************************************
                 co_libroscontables.qs  -  description
                             -------------------
    begin                : lun may 18 2009
    copyright            : (C) 2009 by InfoSiAL S.L.
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
  function validateForm(): Boolean { return this.ctx.interna_validateForm(); }
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
  function bufferChanged(fN: String)
  {
    return this.ctx.oficial_bufferChanged(fN);
  }
  function recalcularDatos()
  {
    return this.ctx.oficial_recalcularDatos();
  }
  function filtroDatos()
  {
    return this.ctx.oficial_filtroDatos();
  }
  function recalcularXbrl(): Boolean {
    return this.ctx.oficial_recalcularXbrl();
  }
  function dameContexto(anno: String, codBalance: String): String {
    return this.ctx.oficial_dameContexto(anno, codBalance);
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
/** \C
Si no existe otro ejercicio más antiguo que el actual, los campos de ejercicio anterior aparecerán deshabilitados. Si existe algún ejercicio previo al actual, aparecerá como ejercicio anterior en el formulario aquel ejercicio más reciente de entre los pasados.
\end */
function interna_init()
{
  this.child("fdbEjercicioAct").setFilter("plancontable = '08'");
  this.child("fdbEjercicioAnt").setFilter("plancontable = '08'");

  connect(this.child("pbnRecalcular"), "clicked()", this, "iface.recalcularDatos");

  this.iface.filtroDatos();
}

/** \C
La fecha de inicio del período de un ejercicio no puede ser posterior que la fecha de fin

Las fechas deben estar comprendidas dentro del período de cada ejercicio

Para poder realizar el balance sobre más de un ejercicio es necesario que ambos tengan igual número de dígitos en las subcuentas
\end */
function interna_validateForm(): Boolean {
  var fechaDesde: String;
  var fechaHasta: String;
  var fechaInicio: String;
  var fechaFin: String;

  var fechaInicioAct: String;
  var fechaFinAnt: String;

  var util: FLUtil = new FLUtil();
  var q: FLSqlQuery = new FLSqlQuery();

  var ejercicioAct: String = this.child("fdbEjercicioAct").value();
  if (!ejercicioAct)
    return true;

  fechaDesde = this.child("fdbFechaDesdeAct").value();
  fechaHasta = this.child("fdbFechaHastaAct").value();

  if (util.daysTo(fechaDesde, fechaHasta) < 0)
  {
    MessageBox.critical(util.translate("scripts", "La fecha de inicio del ejercicio actual debe ser menor que la de fin"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return false;
  }

  q.setTablesList("ejercicios");
  q.setSelect("fechainicio, fechafin");
  q.setFrom("ejercicios");
  q.setWhere("codejercicio = '" + ejercicioAct + "';");

  q.exec();

  if (q.next())
  {
    fechaInicio = q.value(0);
    fechaFin = q.value(1);
    fechaFinAnt = fechaFin;
  }

  if ((util.daysTo(fechaHasta, fechaFin) < 0) || (util.daysTo(fechaDesde, fechaInicio) > 0))
  {
    MessageBox.critical(util.translate("scripts", "Las fechas de inicio y fin del ejercicio actual deben estar dentro del propio intervalo del ejercicio"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return false;
  }

  var ejercicioAnt: String = this.child("fdbEjercicioAnt").value();
  if (!ejercicioAnt)
    return true;

  if (!flcontinfo.iface.pub_comprobarConsolidacion(ejercicioAct, ejercicioAnt))
  {
    MessageBox.critical(util.translate("scripts", "Las subcuentas de los ejercicios deben tener la misma longitud"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return false;
  }

  fechaDesde = this.child("fdbFechaDesdeAnt").value();
  fechaHasta = this.child("fdbFechaHastaAnt").value();

  if (util.daysTo(fechaDesde, fechaHasta) < 0)
  {
    MessageBox.critical(util.translate("scripts", "La fecha de inicio del ejercicio anterior debe ser menor que la de fin"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return false;
  }

  q.setTablesList("ejercicios");
  q.setSelect("fechainicio, fechafin");
  q.setFrom("ejercicios");
  q.setWhere("codejercicio = '" + ejercicioAnt + "';");
  q.exec();

  if (q.next())
  {
    fechaInicio = q.value(0);
    fechaFin = q.value(1);
    fechaFinAnt = fechaFin;
  }

  if ((util.daysTo(fechaHasta, fechaFin) < 0) || (util.daysTo(fechaDesde, fechaInicio) > 0))
  {
    MessageBox.critical(util.translate("scripts", "Las fechas de inicio y fin del ejercicio anterior deben estar dentro del propio intervalo del ejercicio"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return false;
  }

  return true;
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial*/
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////

function oficial_recalcularDatos()
{
  var cursor: FLSqlCursor = this.cursor();
  var util: FLUtil = new FLUtil();

  if (cursor.modeAccess() == cursor.Insert) {
    var curD: FLSqlCursor = this.child("tdbDatos08").cursor();
    curD.setModeAccess(curD.Insert);
    if (!curD.commitBufferCursorRelation()) {
      return;
    }
  }

  this.child("tdbDatos08").cursor().setMainFilter("");
  flcontinfo.iface.recalcularDatosBalance(cursor);
  this.iface.filtroDatos();

  this.iface.recalcularXbrl();

  MessageBox.information(util.translate("scripts", "Se recalcularon los datos del balance"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
}

function oficial_filtroDatos()
{
  var filtro: String = "";
  switch (this.cursor().valueBuffer("tipo")) {
    case "Situacion":
      filtro = "codbalance LIKE 'A-%' OR codbalance LIKE 'P-%'"
               break;
    case "Perdidas y ganancias":
      filtro = "codbalance LIKE 'PG-%'"
               break;
      filtro = "codbalance LIKE 'IG-%'"
               break;
  }

  //  this.child("tdbDatos08").cursor().setMainFilter(filtro);

  this.child("tdbDatos08").refresh();
  this.child("tdbSubtotales").refresh();
}

/** \C Calcula los códigos de balance acumulados a partir de los datos ya calculados para un balance normal
\end */
function oficial_recalcularXbrl(): Boolean {
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  var idBalance: String = cursor.valueBuffer("id");
  if (!util.sqlDelete("co_xbrlbalances08_datos", "idbalance = " + idBalance))
  {
    return false;
  }
  var qryXbrlBalance: FLSqlQuery = new FLSqlQuery;
  qryXbrlBalance.setTablesList("co_xbrlbalances08");
  qryXbrlBalance.setSelect("codbalance, nivel, nodoxbrl");
  qryXbrlBalance.setFrom("co_xbrlbalances08");
  qryXbrlBalance.setWhere("1 = 1");
  qryXbrlBalance.setForwardOnly(true);
  if (!qryXbrlBalance.exec())
  {
    return false;
  }

  var datosXbrl: Array = [];
  var indiceXbrl: Array = [];
  var codBalance: String;
  var k: Number = 0;
  while (qryXbrlBalance.next())
  {
    codBalance = qryXbrlBalance.value("codbalance");
    datosXbrl[codBalance] = [];
    datosXbrl[codBalance]["nodoxbrl"] = qryXbrlBalance.value("nodoxbrl");
    datosXbrl[codBalance]["usado"] = false;
    datosXbrl[codBalance]["saldoact"] = 0;
    datosXbrl[codBalance]["saldoant"] = 0;
    indiceXbrl[k++] = codBalance;
  }

  var qryCodBalances08: FLSqlCursor = new FLSqlQuery();
  qryCodBalances08.setTablesList("co_i_balances08_datos,co_codbalances08");
  qryCodBalances08.setSelect("b.codbalance, d.saldoact, d.saldoant, b.naturaleza, b.codcompleto1, b.codcompleto2, b.codcompleto3");
  qryCodBalances08.setFrom("co_i_balances08_datos d INNER JOIN co_codbalances08 b ON d.codbalance = b.codbalance");
  qryCodBalances08.setWhere("d.idbalance = " + idBalance);
  qryCodBalances08.setForwardOnly(true);
  if (!qryCodBalances08.exec())
  {
    return false;
  }
  var codNivel0: String;
  var codNivel1: String;
  var codNivel2: String;
  var codNivel3: String;
  var codNivel4: String;
  while (qryCodBalances08.next())
  {
    codNivel0 = qryCodBalances08.value("b.naturaleza");
    try {
      datosXbrl[codNivel0]["usado"] = true;
      datosXbrl[codNivel0]["saldoact"] += parseFloat(qryCodBalances08.value("d.saldoact"));;
      datosXbrl[codNivel0]["saldoant"] += parseFloat(qryCodBalances08.value("d.saldoant"));;
    } catch (e) {}

    codNivel1 = qryCodBalances08.value("b.codcompleto1");
    try {
      datosXbrl[codNivel1]["usado"] = true;
      datosXbrl[codNivel1]["saldoact"] += parseFloat(qryCodBalances08.value("d.saldoact"));;
      datosXbrl[codNivel1]["saldoant"] += parseFloat(qryCodBalances08.value("d.saldoant"));;
    } catch (e) {}

    codNivel2 = qryCodBalances08.value("b.codcompleto2");
    try {
      datosXbrl[codNivel2]["usado"] = true;
      datosXbrl[codNivel2]["saldoact"] += parseFloat(qryCodBalances08.value("d.saldoact"));;
      datosXbrl[codNivel2]["saldoant"] += parseFloat(qryCodBalances08.value("d.saldoant"));;
    } catch (e) {}

    codNivel3 = qryCodBalances08.value("b.codcompleto3");
    try {
      datosXbrl[codNivel3]["usado"] = true;
      datosXbrl[codNivel3]["saldoact"] += parseFloat(qryCodBalances08.value("d.saldoact"));;
      datosXbrl[codNivel3]["saldoant"] += parseFloat(qryCodBalances08.value("d.saldoant"));;
    } catch (e) {}

    codNivel4 = qryCodBalances08.value("b.codbalance");
    try {
      datosXbrl[codNivel4]["usado"] = true;
      datosXbrl[codNivel4]["saldoact"] += parseFloat(qryCodBalances08.value("d.saldoact"));;
      datosXbrl[codNivel4]["saldoant"] += parseFloat(qryCodBalances08.value("d.saldoant"));;
    } catch (e) {}
  }

  var codEjercicioAct: String = cursor.valueBuffer("i_co__subcuentas_codejercicioact");
  var fechaInicioAct: Date = cursor.valueBuffer("d_co__asientos_fechaact");
  var annoAct: Number = fechaInicioAct.getYear();

  var codEjercicioAnt: String = cursor.valueBuffer("i_co__subcuentas_codejercicioant");
  var hayEjercicioAnt: Boolean = false;
  var fechaInicioAnt: Date;
  var annoAnt: Number;
  if (codEjercicioAnt && codEjercicioAnt != "")
  {
    hayEjercicioAnt = true;
    fechaInicioAnt = cursor.valueBuffer("d_co__asientos_fechaant");
    annoAnt = fechaInicioAnt.getYear();
  }

  var curXbrlBalance08: FLSqlCursor = new FLSqlCursor("co_xbrlbalances08_datos");
  for (var i: Number = 0; i < indiceXbrl.length; i++)
  {
    codBalance = indiceXbrl[i];
    if (!datosXbrl[codBalance]["usado"]) {
      continue;
    }
    curXbrlBalance08.setModeAccess(curXbrlBalance08.Insert);
    curXbrlBalance08.refreshBuffer();
    curXbrlBalance08.setValueBuffer("idbalance", idBalance);
    curXbrlBalance08.setValueBuffer("codbalance", codBalance);
    curXbrlBalance08.setValueBuffer("nodoxbrl", datosXbrl[codBalance]["nodoxbrl"]);
    curXbrlBalance08.setValueBuffer("saldo", datosXbrl[codBalance]["saldoact"]);
    curXbrlBalance08.setValueBuffer("contexto", this.iface.dameContexto(annoAct, codBalance));

    if (!curXbrlBalance08.commitBuffer()) {
      return false;
    }

    if (hayEjercicioAnt) {
      curXbrlBalance08.setModeAccess(curXbrlBalance08.Insert);
      curXbrlBalance08.refreshBuffer();
      curXbrlBalance08.setValueBuffer("idbalance", idBalance);
      curXbrlBalance08.setValueBuffer("codbalance", codBalance);
      curXbrlBalance08.setValueBuffer("nodoxbrl", datosXbrl[codBalance]["nodoxbrl"]);
      curXbrlBalance08.setValueBuffer("saldo", datosXbrl[codBalance]["saldoant"]);
      curXbrlBalance08.setValueBuffer("contexto", this.iface.dameContexto(annoAnt, codBalance));

      if (!curXbrlBalance08.commitBuffer()) {
        return false;
      }

    }
  }
  /// Crear tabla co_xbrlbalances08_datos, poner pestaña para ver sus datos en libroscontables.ui, programar botón generación XML, completar Array de códigos
  return true;
}

function oficial_dameContexto(anno: String, codBalance: String): String {
  var contexto: String = "";
  var sufijo: String = "";
  if (codBalance.startsWith("PG"))
  {
    sufijo = "PYG";
  } else if (codBalance.startsWith("A") || codBalance.startsWith("P"))
  {
    sufijo = "Balance";
  }
  contexto = "Y1_" + anno.toString() + "_" + sufijo;
  return contexto;
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
