/***************************************************************************
                 intrastat.qs  -  description
                             -------------------
    begin                : vie dic 12 2008
    copyright            : (C) 2008 by InfoSiAL S.L.
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
  function validateForm(): Boolean {
    return this.ctx.interna_validateForm();
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
  function bufferChanged(fN)
  {
    return this.ctx.oficial_bufferChanged(fN);
  }
  function establecerFechasPeriodo()
  {
    return this.ctx.oficial_establecerFechasPeriodo();
  }
  function comprobarFechas(): Boolean {
    return this.ctx.oficial_comprobarFechas();
  }
  function borrarAsignaciones(): Boolean {
    return this.ctx.oficial_borrarAsignaciones();
  }
  function crearAsignaciones(): Boolean {
    return this.ctx.oficial_crearAsignaciones();
  }
  function consultaAsignaciones(): FLSqlQuery {
    return this.ctx.oficial_consultaAsignaciones();
  }
  function validarAlbaran(idAlbaran: String): Number {
    return this.ctx.oficial_validarAlbaran(idAlbaran);
  }
  function incluirLineasCli(): Boolean {
    return this.ctx.oficial_incluirLineasCli();
  }
  function crearLineaCli(qry: FLSqlQuery): Boolean {
    return this.ctx.oficial_crearLineaCli(qry);
  }
  function agregarAlbaranCli()
  {
    return this.ctx.oficial_agregarAlbaranCli();
  }
  function asociarAlbaranDeclaracion(idAlbaran: String): Boolean {
    return this.ctx.oficial_asociarAlbaranDeclaracion(idAlbaran);
  }
  function eliminarAlbaranCli()
  {
    return this.ctx.oficial_eliminarAlbaranCli();
  }
  function excluirAlbaranDeclaracion(idAlbaran: String): Boolean {
    return this.ctx.oficial_excluirAlbaranDeclaracion(idAlbaran);
  }
  function borrarAsignacionesProv(): Boolean {
    return this.ctx.oficial_borrarAsignacionesProv();
  }
  function crearAsignacionesProv(): Boolean {
    return this.ctx.oficial_crearAsignacionesProv();
  }
  function consultaAsignacionesProv(): FLSqlQuery {
    return this.ctx.oficial_consultaAsignacionesProv();
  }
  function validarAlbaranProv(idAlbaran: String): Number {
    return this.ctx.oficial_validarAlbaranProv(idAlbaran);
  }
  function incluirLineasProv(): Boolean {
    return this.ctx.oficial_incluirLineasProv();
  }
  function crearLineaProv(qry: FLSqlQuery): Boolean {
    return this.ctx.oficial_crearLineaProv(qry);
  }
  function agregarAlbaranProv()
  {
    return this.ctx.oficial_agregarAlbaranProv();
  }
  function asociarAlbaranProvDeclaracion(idAlbaran: String): Boolean {
    return this.ctx.oficial_asociarAlbaranProvDeclaracion(idAlbaran);
  }
  function eliminarAlbaranProv()
  {
    return this.ctx.oficial_eliminarAlbaranProv();
  }
  function excluirAlbaranProvDeclaracion(idAlbaran: String): Boolean {
    return this.ctx.oficial_excluirAlbaranProvDeclaracion(idAlbaran);
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
  function pub_asociarAlbaranDeclaracion(idAlbaran: String): Boolean {
    return this.asociarAlbaranDeclaracion(idAlbaran);
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
  connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");
  connect(this.child("tbInsertAlbCli"), "clicked()", this, "iface.agregarAlbaranCli");
  connect(this.child("tbDeleteAlbCli"), "clicked()", this, "iface.eliminarAlbaranCli");
  connect(this.child("tbnIncluirLineasCli"), "clicked()", this, "iface.incluirLineasCli");
  connect(this.child("tbInsertAlbProv"), "clicked()", this, "iface.agregarAlbaranProv");
  connect(this.child("tbDeleteAlbProv"), "clicked()", this, "iface.eliminarAlbaranProv");
  connect(this.child("tbnIncluirLineasProv"), "clicked()", this, "iface.incluirLineasProv");

  if (cursor.modeAccess() == cursor.Insert) {
    cursor.setValueBuffer("codejercicio", flfactppal.iface.pub_valorDefectoEmpresa("codejercicio"));
    this.iface.establecerFechasPeriodo();
  }
  this.child("tdbLineasIntrastatCli").setReadOnly(true);
  this.child("tdbLineasIntrastatProv").setReadOnly(true);
}

function interna_validateForm(): Boolean {
  var util: FLUtil = new FLUtil();
  var cursor: FLSqlCursor = this.cursor();
  /** \C Las fechas que definen el período deben ser coherentes (fin > inicio) y pertenecer al ejercicio seleccionado
  \end */
  if (!this.iface.comprobarFechas())
  {
    return false;
  }

  /** \C La declaración debe tener al menos una línea
  \end */
  if (!util.sqlSelect("lineasintrastatcli", "idlinea", "idintrastat = " + cursor.valueBuffer("idintrastat")) && !util.sqlSelect("lineasintrastatprov", "idlinea", "idintrastat = " + cursor.valueBuffer("idintrastat")))
  {
    MessageBox.warning(util.translate("scripts", "La declaración debe tener al menos una línea."), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }

  return true;
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_bufferChanged(fN)
{
  var cursor: FLSqlCursor = this.cursor();
  switch (fN) {
    case "codejercicio":
    case "periodo": {
      this.iface.establecerFechasPeriodo();
      break;
    }
  }
}


/** \D Establece las fechas de inicio y fin del periodo
\end */
function oficial_establecerFechasPeriodo()
{
  var util: FLUtil = new FLUtil();
  var fechaInicio: Date;
  var fechaFin: Date;
  var codEjercicio: String = this.child("fdbCodEjercicio").value();
  if (!codEjercicio) {
    return false;
  }
  var inicioEjercicio = util.sqlSelect("ejercicios", "fechainicio", "codejercicio = '" + codEjercicio + "'");

  if (!inicioEjercicio) {
    MessageBox.warning(util.translate("scripts", "Debe establecer el ejercicio al que pertenece el periodo"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }

  fechaInicio.setYear(inicioEjercicio.getYear());
  fechaInicio.setMonth(this.child("fdbPeriodo").value() + 1);
  fechaFin.setYear(inicioEjercicio.getYear());
  fechaFin.setMonth(this.child("fdbPeriodo").value() + 1);
  fechaInicio.setDate(1);

  switch (this.child("fdbPeriodo").value()) {
    case 0:
      fechaFin.setDate(31);
      break;
    case 1:
      fechaFin.setDate(28);
      break;
    case 2:
      fechaFin.setDate(31);
      break;
    case 3:
      fechaFin.setDate(30);
      break;
    case 4:
      fechaFin.setDate(31);
      break;
    case 5:
      fechaFin.setDate(30);
      break;
    case 6:
      fechaFin.setDate(31);
      break;
    case 7:
      fechaFin.setDate(31);
      break;
    case 8:
      fechaFin.setDate(30);
      break;
    case 9:
      fechaFin.setDate(31);
      break;
    case 10:
      fechaFin.setDate(30);
      break;
    case 11:
      fechaFin.setDate(31);
      break;
  }

  this.child("fdbFechaInicio").setValue(fechaInicio);
  this.child("fdbFechaFin").setValue(fechaFin);
}

/** \D Comprueba que fechainicio < fechafin y que ambas pertenecen al ejercicio seleccionado

@return True si la comprobación es buena, false en caso contrario
\end */
function oficial_comprobarFechas(): Boolean {
  var util: FLUtil = new FLUtil();

  var codEjercicio: String = this.child("fdbCodEjercicio").value();
  var fechaInicio: String = this.child("fdbFechaInicio").value();
  var fechaFin: String = this.child("fdbFechaFin").value();

  if (util.daysTo(fechaInicio, fechaFin) < 0)
  {
    MessageBox.critical(util.translate("scripts", "La fecha de inicio debe ser menor que la de fin"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return false;
  }

  var inicioEjercicio: String = util.sqlSelect("ejercicios", "fechainicio", "codejercicio = '" + codEjercicio + "'");
  var finEjercicio: String = util.sqlSelect("ejercicios", "fechafin", "codejercicio = '" + codEjercicio + "'");

  if ((util.daysTo(inicioEjercicio, fechaInicio) < 0) || (util.daysTo(fechaFin, finEjercicio) < 0))
  {
    MessageBox.critical(util.translate("scripts", "Las fechas seleccionadas no corresponden al ejercicio"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return false;
  }

  return true;
}


//CLIENTES
function oficial_borrarAsignaciones(): Boolean {
  var cursor: FLSqlCursor = this.cursor();
  var idIntrastat: String = cursor.valueBuffer("idintrastat");
  var curAlbaranes: FLSqlCursor = new FLSqlCursor("albaranescli");
  curAlbaranes.setActivatedCommitActions(false);
  curAlbaranes.setActivatedCheckIntegrity(false);
  curAlbaranes.select("idintrastat = " + idIntrastat);

  var campos: Array = new Array("idintrastat", "rw");
  curAlbaranes.setAcTable("r-");
  curAlbaranes.setAcosTable(campos);
  curAlbaranes.setAcosCondition("ptefactura", cursor.Value, false);

  while (curAlbaranes.next())
  {
    curAlbaranes.setModeAccess(curAlbaranes.Edit);
    curAlbaranes.refreshBuffer();
    curAlbaranes.setNull("idintrastat");
    if (!curAlbaranes.commitBuffer()) {
      return false;
    }
  }
  return true;
}

function oficial_consultaAsignaciones(): FLSqlQuery {
  var cursor: FLSqlCursor = this.cursor();
  var fechaInicio: String = cursor.valueBuffer("fechainicio");
  var fechaFin: String = cursor.valueBuffer("fechafin");
  var codPaisEmpresa: String = flfactppal.iface.pub_valorDefectoEmpresa("codpais");

  var q: FLSqlQuery = new FLSqlQuery;
  q.setTablesList("albaranescli,paises");
  q.setSelect("idalbaran,codigo");
  q.setFrom("albaranescli a LEFT OUTER JOIN paises p ON a.codpais = p.codpais");
  q.setWhere("a.fecha BETWEEN '" + fechaInicio + "' AND '" + fechaFin + "' AND a.codpais <> '" + codPaisEmpresa + "' AND a.codpais IS NOT NULL AND p.intrastat = true");
  q.setForwardOnly(true);

  return q;
}

function oficial_crearAsignaciones(): Boolean {
  var cursor: FLSqlCursor = this.cursor();
  var util: FLUtil = new FLUtil();
  var qryAsignaciones: FLSqlQuery = this.iface.consultaAsignaciones();
  var idIntrastat: String = cursor.valueBuffer("idintrastat");

  var curAlbaranes: FLSqlCursor = new FLSqlCursor("albaranescli");
  curAlbaranes.setActivatedCommitActions(false);
  curAlbaranes.setActivatedCheckIntegrity(false);

  var campos: Array = new Array("idintrastat", "rw");
  curAlbaranes.setAcTable("r-");
  curAlbaranes.setAcosTable(campos);
  curAlbaranes.setAcosCondition("ptefactura", cursor.Value, false);

  if (!qryAsignaciones.exec())
  {
    return false;
  }
  var result: Number;
  while (qryAsignaciones.next())
  {
    result = this.iface.validarAlbaran(qryAsignaciones.value(0));
    switch (result) {
      case 0: {
        break;
      }
      case 1: {
        MessageBox.information(util.translate("scripts", "No se va a incluir el albarán %1 en la declaracion.\nAlguna de sus líneas no tiene informado el código CN8 del artículo").arg(qryAsignaciones.value(1)), MessageBox.Ok, MessageBox.NoButton);
        continue;
      }
      case 2: {
        MessageBox.information(util.translate("scripts", "Hay un error al incluir el albarán %1 en la declaracion.\n").arg(qryAsignaciones.value(1)), MessageBox.Ok, MessageBox.NoButton);
        continue;
      }
    }
    curAlbaranes.select("idalbaran = " + qryAsignaciones.value(0));
    if (!curAlbaranes.first()) {
      return false;
    }
    curAlbaranes.setModeAccess(curAlbaranes.Edit);
    curAlbaranes.refreshBuffer();
    if (curAlbaranes.valueBuffer("nointrastat")) {
      continue;
    }
    curAlbaranes.setValueBuffer("idintrastat", idIntrastat);
    if (!curAlbaranes.commitBuffer()) {
      return false;
    }
  }
  return true;
}

/** \D Comprueba que todas las líneas del albarán son válidas para incluir en la declaración de intrastat
return 0 si es correcto
  1 si hay alguna línea que no es válida
  2 si hay error.
*/
/** A TENER EN CUENTA: si incluimos alguna condición a comprobar para las líneas tendremos que incluirla también en la funcion que crea las líneas de intrastat (incluirLineasCli())
*/
function oficial_validarAlbaran(idAlbaran: String): Number {
  var util: FLUtil = new FLUtil();
  var qryLineasAlbaran: FLSqlQuery = new FLSqlQuery();
  qryLineasAlbaran.setTablesList("albaranescli,lineasalbaranescli,articulos");
  qryLineasAlbaran.setSelect("l.referencia");
  qryLineasAlbaran.setFrom("albaranescli al INNER JOIN lineasalbaranescli l ON al.idalbaran = l.idalbaran INNER JOIN articulos a ON l.referencia = a.referencia");
  qryLineasAlbaran.setWhere("al.idalbaran = " + idAlbaran);
  if (!qryLineasAlbaran.exec())
  {
    return 2;
  }
  var codCn8: String;
  if (qryLineasAlbaran.size() == 0)
  {
    return 2;
  }
  while (qryLineasAlbaran.next())
  {
    codCn8 = util.sqlSelect("articulos", "codigocn8", "referencia = '" + qryLineasAlbaran.value("l.referencia") + "'");
    if (!codCn8 && codCn8 == "") {
      return 1;
    }
  }
  return 0;
}

function oficial_incluirLineasCli(): Boolean {
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  if (!this.iface.borrarAsignaciones())
  {
    return false;
  }

  if (!this.iface.crearAsignaciones())
  {
    return false;
  }

  if (!util.sqlDelete("lineasintrastatcli", "idintrastat = " + cursor.valueBuffer("idintrastat")))
  {
    return false;
  }
  if (cursor.modeAccess() == cursor.Insert)
  {
    if (!this.child("tdbLineasIntrastatCli").cursor().commitBufferCursorRelation()) {
      return false;
    }
  }

  var qryLineasAlbaran: FLSqlQuery = new FLSqlQuery();
  qryLineasAlbaran.setTablesList("albaranescli,lineasalbaranescli,articulos");
  qryLineasAlbaran.setSelect("a.codigocn8, al.codpais, al.codprovincia, al.codcondicionentrega, al.codnaturaleza, al.codmodotransporte, al.codpuerto, al.codregimen, SUM(a.peso * l.cantidad), SUM(l.cantidad), SUM(l.pvptotal)");
  qryLineasAlbaran.setFrom("albaranescli al INNER JOIN lineasalbaranescli l ON al.idalbaran = l.idalbaran INNER JOIN articulos a ON l.referencia = a.referencia");
  qryLineasAlbaran.setWhere("al.idintrastat = " + cursor.valueBuffer("idintrastat") + " AND a.codigocn8 <> '' AND a.codigocn8 IS NOT NULL GROUP BY a.codigocn8, al.codpais, al.codprovincia, al.codcondicionentrega, al.codnaturaleza, al.codmodotransporte, al.codpuerto, al.codregimen");
  if (!qryLineasAlbaran.exec())
  {
    return false;
  }
  while (qryLineasAlbaran.next())
  {
    if (!this.iface.crearLineaCli(qryLineasAlbaran)) {
      continue;
    }
  }
  this.child("tdbLineasIntrastatCli").refresh();
  return true;
}

function oficial_crearLineaCli(qry: FLSqlQuery): Boolean {
  var cursor: FLSqlCursor = this.cursor();
  var util: FLUtil = new FLUtil();
  var curLinea = new FLSqlCursor("lineasintrastatcli");
  curLinea.setModeAccess(curLinea.Insert);
  curLinea.refreshBuffer();
  var codIso: String = util.sqlSelect("paises", "codiso", "codpais = '" + qry.value("al.codpais") + "'");
  if (!codIso)
  {
    MessageBox.information(util.translate("scripts", "Debe informar el código ISO del país %1 para la declaración Intrastat").arg(qry.value("al.codpais")), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  curLinea.setValueBuffer("idintrastat", cursor.valueBuffer("idintrastat"));
  curLinea.setValueBuffer("codiso", codIso);
  curLinea.setValueBuffer("codprovincia", qry.value("al.codprovincia"));
  curLinea.setValueBuffer("codcondicionentrega", qry.value("al.codcondicionentrega"));
  curLinea.setValueBuffer("codnaturaleza", qry.value("al.codnaturaleza"));
  curLinea.setValueBuffer("codmodotransporte", qry.value("al.codmodotransporte"));
  curLinea.setValueBuffer("codpuerto", qry.value("al.codpuerto"));
  curLinea.setValueBuffer("codmercancia", qry.value("a.codigocn8"));
  curLinea.setValueBuffer("codpaisorigen", qry.value("al.codpais"));
  curLinea.setValueBuffer("codregimen", qry.value("al.codregimen"));
  curLinea.setValueBuffer("masaneta", qry.value("SUM(a.peso * l.cantidad)"));
  curLinea.setValueBuffer("udssuplementarias", qry.value("SUM(l.cantidad)"));
  curLinea.setValueBuffer("valorestadistico", qry.value("SUM(l.pvptotal)"));
  curLinea.setValueBuffer("importefacturado", qry.value("SUM(l.pvptotal)"));
  /*  if (qry.value("SUM(l.pvptotal)") == 0) {
      MessageBox.information(util.translate("scripts", "El importe facturado de la línea intrastat no puede ser cero.\nPaís: %1 - Mercancía: %2").arg(qry.value("al.codpais")).arg(qry.value("a.codigocn8")), MessageBox.Ok, MessageBox.NoButton);
      return false;
    }*/

  if (!curLinea.commitBuffer())
  {
    return false;
  }
  return true;
}

function oficial_agregarAlbaranCli()
{
  var util: FLUtil = new FLUtil();
  var cursor: FLSqlCursor = this.cursor();

  var f: Object = new FLFormSearchDB("i_seleccionalbaranescli");
  var curAlbaran: FLSqlCursor = f.cursor();

  var qryIncluir: FLSqlQuery = this.iface.consultaAsignaciones();
  var consulta: String = qryIncluir.sql();
  if (consulta && consulta != "" && consulta.endsWith(";")) {
    consulta = consulta.left(consulta.length - 1);
  }
  var filtro: String = "idalbaran IN (" + consulta + ") AND idintrastat IS NULL";
  curAlbaran.setMainFilter(filtro);
  f.setMainWidget();
  var idAlbaran = f.exec("idalbaran");
  if (!idAlbaran) {
    return false;
  }

  if (!this.iface.asociarAlbaranDeclaracion(idAlbaran)) {
    return false;
  }

  if (!this.iface.incluirLineasCli()) {
    return false;
  }
  this.child("tdbLineasIntrastatCli").refresh();
}

function oficial_asociarAlbaranDeclaracion(idAlbaran: String): Boolean {
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();
  var idIntrastat: String = cursor.valueBuffer("idintrastat");

  var curAlbaranes: FLSqlCursor = new FLSqlCursor("albaranescli");
  curAlbaranes.select("idalbaran = " + idAlbaran);
  if (curAlbaranes.next())
  {
    curAlbaranes.setModeAccess(curAlbaranes.Edit);
    curAlbaranes.refreshBuffer();
    if (curAlbaranes.valueBuffer("nointrastat")) {
      var res: Number = MessageBox.warning(util.translate("scripts", "El albarán seleccionado ha sido marcado manualmente para incluirse en Intrastat.\n¿Desea continuar?"), MessageBox.Yes, MessageBox.No);
      if (res != MessageBox.Yes) {
        return true;
      }
    }
    curAlbaranes.setValueBuffer("idintrastat", idIntrastat);
    curAlbaranes.setValueBuffer("nointrastat", false);
    if (!curAlbaranes.commitBuffer()) {
      return false;
    }
  }
  return true;
}

function oficial_eliminarAlbaranCli()
{
  var util: FLUtil = new FLUtil();
  var cursor: FLSqlCursor = this.cursor();

  var f: Object = new FLFormSearchDB("i_seleccionalbaranescli");
  var curAlbaran: FLSqlCursor = f.cursor();

  var filtro: String = "idintrastat = " + cursor.valueBuffer("idintrastat");
  curAlbaran.setMainFilter(filtro);
  f.setMainWidget();
  var idAlbaran = f.exec("idalbaran");
  if (!idAlbaran) {
    return false;
  }

  if (!this.iface.excluirAlbaranDeclaracion(idAlbaran)) {
    return false;
  }

  if (!this.iface.incluirLineasCli()) {
    return false;
  }
  this.child("tdbLineasIntrastatCli").refresh();
}

function oficial_excluirAlbaranDeclaracion(idAlbaran: String): Boolean {
  var util: FLUtil = new FLUtil;
  var curAlbaranes: FLSqlCursor = new FLSqlCursor("albaranescli");
  curAlbaranes.select("idalbaran = " + idAlbaran);

  if (!curAlbaranes.first())
  {
    return false;
  }

  curAlbaranes.setModeAccess(curAlbaranes.Edit);
  curAlbaranes.refreshBuffer();
  curAlbaranes.setNull("idintrastat");
  curAlbaranes.setValueBuffer("nointrastat", true);

  if (!curAlbaranes.commitBuffer())
  {
    return false;
  }
  return true;
}

//PROVEEDORES
function oficial_borrarAsignacionesProv(): Boolean {
  var cursor: FLSqlCursor = this.cursor();
  var idIntrastat: String = cursor.valueBuffer("idintrastat");
  var curAlbaranes: FLSqlCursor = new FLSqlCursor("albaranesprov");
  curAlbaranes.setActivatedCommitActions(false);
  curAlbaranes.setActivatedCheckIntegrity(false);
  curAlbaranes.select("idintrastat = " + idIntrastat);

  var campos: Array = new Array("idintrastat", "rw");
  curAlbaranes.setAcTable("r-");
  curAlbaranes.setAcosTable(campos);
  curAlbaranes.setAcosCondition("ptefactura", cursor.Value, false);

  while (curAlbaranes.next())
  {
    curAlbaranes.setModeAccess(curAlbaranes.Edit);
    curAlbaranes.refreshBuffer();
    curAlbaranes.setNull("idintrastat");
    if (!curAlbaranes.commitBuffer()) {
      return false;
    }
  }
  return true;
}

function oficial_consultaAsignacionesProv(): FLSqlQuery {
  var cursor: FLSqlCursor = this.cursor();
  var fechaInicio: String = cursor.valueBuffer("fechainicio");
  var fechaFin: String = cursor.valueBuffer("fechafin");
  var codPaisEmpresa: String = flfactppal.iface.pub_valorDefectoEmpresa("codpais");
  var q: FLSqlQuery = new FLSqlQuery;
  q.setTablesList("albaranesprov,paises");
  q.setSelect("idalbaran,codigo");
  q.setFrom("albaranesprov a LEFT OUTER JOIN paises p ON a.codpais = p.codpais");
  q.setWhere("a.fecha BETWEEN '" + fechaInicio + "' AND '" + fechaFin + "' AND a.codpais <> '" + codPaisEmpresa + "' AND a.codpais IS NOT NULL AND p.intrastat = true");
  q.setForwardOnly(true);

  return q;
}

function oficial_crearAsignacionesProv(): Boolean {
  var cursor: FLSqlCursor = this.cursor();
  var util: FLUtil = new FLUtil();
  var qryAsignaciones: FLSqlQuery = this.iface.consultaAsignacionesProv();
  var idIntrastat: String = cursor.valueBuffer("idintrastat");

  var curAlbaranes: FLSqlCursor = new FLSqlCursor("albaranesprov");
  curAlbaranes.setActivatedCommitActions(false);
  curAlbaranes.setActivatedCheckIntegrity(false);

  var campos: Array = new Array("idintrastat", "rw");
  curAlbaranes.setAcTable("r-");
  curAlbaranes.setAcosTable(campos);
  curAlbaranes.setAcosCondition("ptefactura", cursor.Value, false);

  if (!qryAsignaciones.exec())
  {
    return false;
  }
  var result: Number;
  while (qryAsignaciones.next())
  {
    result = this.iface.validarAlbaranProv(qryAsignaciones.value(0));
    switch (result) {
      case 0: {
        break;
      }
      case 1: {
        MessageBox.information(util.translate("scripts", "No se va a incluir el albarán %1 en la declaracion.\nAlguna de sus líneas no tiene informado el código CN8 del artículo").arg(qryAsignaciones.value(1)), MessageBox.Ok, MessageBox.NoButton);
        continue;
      }
      case 2: {
        MessageBox.information(util.translate("scripts", "Hay un error al incluir el albarán %1 en la declaracion.\n").arg(qryAsignaciones.value(1)), MessageBox.Ok, MessageBox.NoButton);
        continue;
      }
    }
    curAlbaranes.select("idalbaran = " + qryAsignaciones.value(0));
    if (!curAlbaranes.first()) {
      return false;
    }
    curAlbaranes.setModeAccess(curAlbaranes.Edit);
    curAlbaranes.refreshBuffer();
    if (curAlbaranes.valueBuffer("nointrastat")) {
      continue;
    }
    curAlbaranes.setValueBuffer("idintrastat", idIntrastat);
    if (!curAlbaranes.commitBuffer()) {
      return false;
    }
  }
  return true;
}

/** \D Comprueba que todas las líneas del albarán son válidas para incluir en la declaración de intrastat
return 0 si es correcto
  1 si hay alguna línea que no es válida
  2 si hay error.
*/
/** A TENER EN CUENTA: si incluimos alguna condición a comprobar para las líneas tendremos que incluirla también en la funcion que crea las líneas de intrastat (incluirLineasProv())
*/
function oficial_validarAlbaranProv(idAlbaran: String): Number {
  var util: FLUtil = new FLUtil();
  var qryLineasAlbaran: FLSqlQuery = new FLSqlQuery();
  qryLineasAlbaran.setTablesList("albaranesprov,lineasalbaranesprov,articulos");
  qryLineasAlbaran.setSelect("l.referencia");
  qryLineasAlbaran.setFrom("albaranesprov al INNER JOIN lineasalbaranesprov l ON al.idalbaran = l.idalbaran INNER JOIN articulos a ON l.referencia = a.referencia");
  qryLineasAlbaran.setWhere("al.idalbaran = " + idAlbaran);
  if (!qryLineasAlbaran.exec())
  {
    return 2;
  }
  var codCn8: String;
  if (qryLineasAlbaran.size() == 0)
  {
    return 2;
  }
  while (qryLineasAlbaran.next())
  {
    codCn8 = util.sqlSelect("articulos", "codigocn8", "referencia = '" + qryLineasAlbaran.value("l.referencia") + "'");
    if (!codCn8 && codCn8 == "") {
      return 1;
    }
  }
  return 0;
}

function oficial_incluirLineasProv(): Boolean {
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  if (!this.iface.borrarAsignacionesProv())
  {
    return false;
  }

  if (!this.iface.crearAsignacionesProv())
  {
    return false;
  }

  if (!util.sqlDelete("lineasintrastatprov", "idintrastat = " + cursor.valueBuffer("idintrastat")))
  {
    return false;
  }
  if (cursor.modeAccess() == cursor.Insert)
  {
    if (!this.child("tdbLineasIntrastatProv").cursor().commitBufferCursorRelation()) {
      return false;
    }
  }

  var qryLineasAlbaran: FLSqlQuery = new FLSqlQuery();
  qryLineasAlbaran.setTablesList("albaranesprov,lineasalbaranesprov,articulos");
  qryLineasAlbaran.setSelect("a.codigocn8, al.codpais, al.codprovincia, al.codcondicionentrega, al.codnaturaleza, al.codmodotransporte, al.codpuerto, al.codregimen, SUM(a.peso * l.cantidad), SUM(l.cantidad), SUM(l.pvptotal)");
  qryLineasAlbaran.setFrom("albaranesprov al INNER JOIN lineasalbaranesprov l ON al.idalbaran = l.idalbaran INNER JOIN articulos a ON l.referencia = a.referencia");
  qryLineasAlbaran.setWhere("al.idintrastat = " + cursor.valueBuffer("idintrastat") + " AND a.codigocn8 <> '' AND a.codigocn8 IS NOT NULL GROUP BY a.codigocn8, al.codpais, al.codprovincia, al.codcondicionentrega, al.codnaturaleza, al.codmodotransporte, al.codpuerto, al.codregimen");
  if (!qryLineasAlbaran.exec())
  {
    return false;
  }

  while (qryLineasAlbaran.next())
  {
    if (!this.iface.crearLineaProv(qryLineasAlbaran)) {
      return false;
    }
  }
  this.child("tdbLineasIntrastatProv").refresh();
  return true;
}

function oficial_crearLineaProv(qry: FLSqlQuery): Boolean {
  var cursor: FLSqlCursor = this.cursor();
  var util: FLUtil = new FLUtil();
  var curLinea = new FLSqlCursor("lineasintrastatprov");
  curLinea.setModeAccess(curLinea.Insert);
  curLinea.refreshBuffer();
  var codIso: String = util.sqlSelect("paises", "codiso", "codpais = '" + qry.value("al.codpais") + "'");
  if (!codIso)
  {
    MessageBox.information(util.translate("scripts", "Debe informar el código ISO del país %1 para la declaración Intrastat").arg(qry.value("al.codpais")), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  curLinea.setValueBuffer("idintrastat", cursor.valueBuffer("idintrastat"));
  curLinea.setValueBuffer("codiso", codIso);
  curLinea.setValueBuffer("codprovincia", qry.value("al.codprovincia"));
  curLinea.setValueBuffer("codcondicionentrega", qry.value("al.codcondicionentrega"));
  curLinea.setValueBuffer("codnaturaleza", qry.value("al.codnaturaleza"));
  curLinea.setValueBuffer("codmodotransporte", qry.value("al.codmodotransporte"));
  curLinea.setValueBuffer("codpuerto", qry.value("al.codpuerto"));
  curLinea.setValueBuffer("codmercancia", qry.value("a.codigocn8"));
  curLinea.setValueBuffer("codpaisorigen", qry.value("al.codpais"));
  curLinea.setValueBuffer("codregimen", qry.value("al.codregimen"));
  curLinea.setValueBuffer("masaneta", qry.value("SUM(a.peso * l.cantidad)"));
  curLinea.setValueBuffer("udssuplementarias", qry.value("SUM(l.cantidad)"));
  curLinea.setValueBuffer("valorestadistico", qry.value("SUM(l.pvptotal)"));
  curLinea.setValueBuffer("importefacturado", qry.value("SUM(l.pvptotal)"));
  /*  if (qry.value("SUM(l.pvptotal)") == 0) {
      MessageBox.information(util.translate("scripts", "El importe facturado de la línea intrastat no puede ser cero.\nPaís: %1 - Mercancía: %2").arg(qry.value("al.codpais")).arg(qry.value("a.codigocn8")), MessageBox.Ok, MessageBox.NoButton);
      return false;
    }*/
  if (!curLinea.commitBuffer())
  {
    return false;
  }
  return true;
}

function oficial_agregarAlbaranProv()
{
  var util: FLUtil = new FLUtil();
  var cursor: FLSqlCursor = this.cursor();

  var f: Object = new FLFormSearchDB("i_seleccionalbaranesprov");
  var curAlbaran: FLSqlCursor = f.cursor();

  var qryIncluir: FLSqlQuery = this.iface.consultaAsignacionesProv();
  var consulta: String = qryIncluir.sql();
  if (consulta && consulta != "" && consulta.endsWith(";")) {
    consulta = consulta.left(consulta.length - 1);
  }
  var filtro: String = "idalbaran IN (" + consulta + ") AND idintrastat IS NULL";
  curAlbaran.setMainFilter(filtro);
  f.setMainWidget();
  var idAlbaran = f.exec("idalbaran");
  if (!idAlbaran) {
    return false;
  }

  if (!this.iface.asociarAlbaranProvDeclaracion(idAlbaran)) {
    return false;
  }

  if (!this.iface.incluirLineasProv()) {
    return false;
  }
  this.child("tdbLineasIntrastatProv").refresh();
}

function oficial_asociarAlbaranProvDeclaracion(idAlbaran: String): Boolean {
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();
  var idIntrastat: String = cursor.valueBuffer("idintrastat");

  var curAlbaranes: FLSqlCursor = new FLSqlCursor("albaranesprov");
  curAlbaranes.select("idalbaran = " + idAlbaran);
  if (curAlbaranes.next())
  {
    curAlbaranes.setModeAccess(curAlbaranes.Edit);
    curAlbaranes.refreshBuffer();
    if (curAlbaranes.valueBuffer("nointrastat")) {
      var res: Number = MessageBox.warning(util.translate("scripts", "El albarán seleccionado ha sido marcado manualmente para incluirse en Intrastat.\n¿Desea continuar?"), MessageBox.Yes, MessageBox.No);
      if (res != MessageBox.Yes) {
        return true;
      }
    }
    curAlbaranes.setValueBuffer("idintrastat", idIntrastat);
    curAlbaranes.setValueBuffer("nointrastat", false);
    if (!curAlbaranes.commitBuffer()) {
      return false;
    }
  }
  return true;
}

function oficial_eliminarAlbaranProv()
{
  var util: FLUtil = new FLUtil();
  var cursor: FLSqlCursor = this.cursor();

  var f: Object = new FLFormSearchDB("i_seleccionalbaranesprov");
  var curAlbaran: FLSqlCursor = f.cursor();

  var filtro: String = "idintrastat = " + cursor.valueBuffer("idintrastat");
  curAlbaran.setMainFilter(filtro);
  f.setMainWidget();
  var idAlbaran = f.exec("idalbaran");
  if (!idAlbaran) {
    return false;
  }

  if (!this.iface.excluirAlbaranProvDeclaracion(idAlbaran)) {
    return false;
  }

  if (!this.iface.incluirLineasProv()) {
    return false;
  }
  this.child("tdbLineasIntrastatProv").refresh();
}

function oficial_excluirAlbaranProvDeclaracion(idAlbaran: String): Boolean {
  var util: FLUtil = new FLUtil;
  var curAlbaranes: FLSqlCursor = new FLSqlCursor("albaranesprov");
  curAlbaranes.select("idalbaran = " + idAlbaran);

  if (!curAlbaranes.first())
  {
    return false;
  }

  curAlbaranes.setModeAccess(curAlbaranes.Edit);
  curAlbaranes.refreshBuffer();
  curAlbaranes.setNull("idintrastat");
  curAlbaranes.setValueBuffer("nointrastat", true);

  if (!curAlbaranes.commitBuffer())
  {
    return false;
  }
  return true;
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
