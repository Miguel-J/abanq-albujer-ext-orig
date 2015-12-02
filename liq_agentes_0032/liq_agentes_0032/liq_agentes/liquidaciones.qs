/***************************************************************************
                              liquidaciones.qs
                             -------------------
    begin                : jue sep 29 2005
    copyright            : (C) 2005 by InfoSiAL S.L.
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
  var codLiquidacion;
  var docLiquidacion_;
  var tdbDocs_;
  var curFactura_;
  function oficial(context)
  {
    interna(context);
  }
  function agregarFactura(): Boolean {
    return this.ctx.oficial_agregarFactura();
  }
  function eliminarFactura(): Boolean {
    return this.ctx.oficial_eliminarFactura();
  }
  function eliminarFacturas(): Boolean {
    return this.ctx.oficial_eliminarFacturas();
  }
  function asociarFacturas(): Boolean {
    return this.ctx.oficial_asociarFacturas();
  }
  function desasociarFactura(idDoc: String): Boolean {
    return this.ctx.oficial_desasociarFactura(idDoc);
  }
  function cambiarPorcentaje()
  {
    return this.ctx.oficial_cambiarPorcentaje();
  }
  function commonCalculateField(fN: String, cursor: FLSqlCursor): String {
    return this.ctx.oficial_commonCalculateField(fN, cursor);
  }
  function establecerFechasPeriodo()
  {
    return this.ctx.oficial_establecerFechasPeriodo();
  }
  function habilitarPeriodo()
  {
    return this.ctx.oficial_habilitarPeriodo();
  }
  function bufferChanged(fN: String)
  {
    return this.ctx.oficial_bufferChanged(fN);
  }
  function asociaDocumentoTabla()
  {
    return this.ctx.oficial_asociaDocumentoTabla();
  }
  function refrescaTablaTotal()
  {
    return this.ctx.oficial_refrescaTablaTotal();
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

/** @class_declaration puboficial */
//////////////////////////////////////////////////////////////////
//// oficial //////////////////////////////////////////////////
class puboficial extends ifaceCtx
{
  function puboficial(context)
  {
    ifaceCtx(context);
  }
  function pub_commonCalculateField(fN: String, cursor: FLSqlCursor): String {
    return this.commonCalculateField(fN, cursor);
  }
}
const iface = new puboficial(this);
//// oficial ///////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_definition interna */
////////////////////////////////////////////////////////////////////////////
//// DEFINICION ////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
//// INTERNA /////////////////////////////////////////////////////
function interna_init()
{
  this.iface.docLiquidacion_ = flfactppal.iface.pub_valorDefecto("docliquidacion");

  var util: FLUtil = new FLUtil();
  var cursor: FLSqlCursor = this.cursor();

  connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");
  connect(this.child("tbInsert"), "clicked()", this, "iface.agregarFactura");
  connect(this.child("tbDelete"), "clicked()", this, "iface.eliminarFactura");
  connect(this.child("pbAsociar"), "clicked()", this, "iface.asociarFacturas");
  connect(this.child("tbPorcentaje"), "clicked()", this, "iface.cambiarPorcentaje");

  /** \C La tabla de facturas se muestra en modo de sólo lectura
  \end */

  if (cursor.modeAccess() == cursor.Edit) {
    this.child("fdbAgente").setDisabled(true);
  }
  this.iface.codLiquidacion = this.cursor().valueBuffer("codliquidacion");
  this.child("fdbFactura").setDisabled(true);

  this.iface.asociaDocumentoTabla();
  this.iface.tdbDocs_.setReadOnly(true);
  this.iface.habilitarPeriodo();
}

/** \C El total de la liquidación será la suma de las comisiones de las facturas que la componen
\end */
function interna_calculateField(fN: String): String {
  var util: FLUtil = new FLUtil();
  var cursor = this.cursor();
  var res: String;
  switch (fN)
  {
    case "total": {
      res = this.iface.commonCalculateField("total", cursor);
      break;
    }
  }
  return res;
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
/** \D Se agrega un documento a la liquidación.
\end */
function oficial_agregarFactura(): Boolean {
  var util: FLUtil = new FLUtil();

  var accion: String;
  var clave: String;
  switch (this.iface.docLiquidacion_)
  {
    case "Albaranes": {
      accion = "busalbcli";
      clave = "idalbaran";
      break;
    }
    default: {
      accion = "busfactcli";
      clave = "idfactura";
      break;
    }
  }

  var cursor: FLSqlCursor = this.cursor();
  if (cursor.modeAccess() == cursor.Insert)
  {
    var curDocs: FLSqlCursor = this.iface.tdbDocs_.cursor();
    if (!curDocs.commitBufferCursorRelation()) {
      return false;
    }
    /// Para poder quitar facturas con el botón correspondiente
    curDocs.setModeAccess(curDocs.Browse);
    curDocs.refreshBuffer();
  }

  this.child("fdbAgente").setDisabled(true);

  var fDocs: Object = new FLFormSearchDB(accion);
  fDocs.setMainWidget();

  var filtro: String = flfactppal.iface.pub_obtenFiltroFacturas(cursor.valueBuffer("codagente"), cursor.valueBuffer("fechadesde"), cursor.valueBuffer("fechahasta"), cursor.valueBuffer("codejercicio"), this.iface.docLiquidacion_);

  fDocs.cursor().setMainFilter(filtro);
  var idDoc: String = fDocs.exec(clave);
  if (idDoc)
  {
    if (!flfactppal.iface.pub_asociarFacturaLiq(idDoc, this.iface.codLiquidacion, this.iface.docLiquidacion_)) {
      return false;
    }
    this.iface.tdbDocs_.refresh();
    this.child("fdbTotal").setValue(this.iface.calculateField("total"));
  }

  return true;
}

/** \D Se elimina el documento activo de la liquidación
\end */
function oficial_eliminarFactura()
{
  var clave: String;
  switch (this.iface.docLiquidacion_) {
    case "Albaranes": {
      clave = "idalbaran";
      break;
    }
    default: {
      clave = "idfactura";
      break;
    }
  }
  var curDoc: FLSqlCursor = this.iface.tdbDocs_.cursor();
  var idDoc: String = curDoc.valueBuffer(clave);
  if (!idDoc) {
    return true;
  }
  debug("idDoc = " + idDoc);

  if (!this.iface.desasociarFactura(idDoc)) {
    return false;
  }

  this.iface.tdbDocs_.refresh();
  this.child("fdbTotal").setValue(this.iface.calculateField("total"));
}

/** \D Se elimina los documentos asociados actualmente a la liquidación
\end */
function oficial_eliminarFacturas(): Boolean {
  var clave: String, tabla: String;
  switch (this.iface.docLiquidacion_)
  {
    case "Albaranes": {
      tabla = "albaranescli";
      clave = "idalbaran";
      break;
    }
    default: {
      tabla = "facturascli";
      clave = "idfactura";
      break;
    }
  }
  var tdbDocs: Object = this.iface.tdbDocs_;
  var idDoc: String;

  var qryDocs: FLSqlQuery = new FLSqlQuery();
  qryDocs.setTablesList(tabla);
  qryDocs.setSelect(clave);
  qryDocs.setFrom(tabla);
  qryDocs.setWhere("codliquidacion = '" + this.cursor().valueBuffer("codliquidacion") + "'");
  qryDocs.setForwardOnly(true);
  if (!qryDocs.exec())
  {
    return false;
  }
  while (qryDocs.next())
  {
    if (!this.iface.desasociarFactura(qryDocs.value(clave))) {
      return false;
    }
  }

  tdbDocs.refresh();
  this.child("fdbTotal").setValue(this.iface.calculateField("total"));
  return true;
}

/** \D Se quita la asociación entre documento y la liquidación
@param idDoc: Identificador del documento a desasociar
@return true si la asociación se quita correctamente, false en caso contrario
\end */
function oficial_desasociarFactura(idDoc: String): Boolean {
  debug("oficial_desasociarFactura " + idDoc);
  var clave: String, tabla: String, campoLock: String;
  switch (this.iface.docLiquidacion_)
  {
    case "Albaranes": {
      tabla = "albaranescli";
      clave = "idalbaran";
      campoLock = "ptefactura";
      break;
    }
    default: {
      tabla = "facturascli";
      clave = "idfactura";
      campoLock = "editable";
      break;
    }
  }

  var editable: Boolean = true;
  var curDoc: FLSqlCursor = new FLSqlCursor(tabla);
  curDoc.setActivatedCommitActions(false);
  curDoc.select(clave + " = " + idDoc);
  if (!curDoc.first())
  {
    return false;
  }
  curDoc.setModeAccess(curDoc.Browse);
  curDoc.refreshBuffer();

  curDoc.setActivatedCommitActions(false);
  if (!curDoc.valueBuffer(campoLock))
  {
    editable = false;
    curDoc.setUnLock(campoLock, true);
    curDoc.select(clave + " = " + idDoc);
    if (!curDoc.first()) {
      return false;
    }
  }

  curDoc.setModeAccess(curDoc.Edit);
  curDoc.refreshBuffer();
  curDoc.setNull("codliquidacion");
  if (!curDoc.commitBuffer())
  {
    return false;
  }
  if (editable == false)
  {
    curDoc.select(clave + " = " + idDoc);
    if (!curDoc.first()) {
      return false;
    }
    curDoc.setUnLock(campoLock, false);
  }
  debug("oficial_desasociarFactura OK");
  return true;
}

/** \D Asocia automáticamente a la liquidación todas los documentos pendientes de liquidar
con el agente actual
\end */
function oficial_asociarFacturas()
{
  var util: FLUtil = new FLUtil();
  var cursor = this.cursor();

  var curDocs = this.iface.tdbDocs_.cursor();
  if (cursor.modeAccess() == cursor.Insert) {
    curDocs.setModeAccess(curDocs.Insert);
    if (!curDocs.commitBufferCursorRelation()) {
      return false;
    }
    /// Para poder quitar facturas con el botón correspondiente
    curDocs.setModeAccess(curDocs.Browse);
    curDocs.refreshBuffer();
  }

  if (curDocs.size() > 0) {
    if (!this.iface.eliminarFacturas(cursor.valueBuffer("codliquidacion"))) {
      return false;
    }
  }

  this.child("fdbAgente").setDisabled(true);

  var filtro: String = flfactppal.iface.pub_obtenFiltroFacturas(cursor.valueBuffer("codagente"), cursor.valueBuffer("fechadesde"), cursor.valueBuffer("fechahasta"), cursor.valueBuffer("codejercicio"), this.iface.docLiquidacion_);

  if (!flfactppal.iface.pub_asociarFacturasLiq(filtro, this.iface.codLiquidacion, this.iface.docLiquidacion_)) {
    return false;
  }

  this.iface.tdbDocs_.refresh();
  this.child("fdbTotal").setValue(this.iface.calculateField("total"));

  return true;
}

function oficial_cambiarPorcentaje()
{
  var _i = this.iface;
  var util = new FLUtil();

  var clave, tabla, campoLock, tablaLineas, accion;
  switch (this.iface.docLiquidacion_) {
    case "Albaranes": {
      //tabla = "albaranescli";
      clave = "idalbaran";
      //campoLock = "ptefactura";
      //tablaLineas = "lineasalbaranescli";
      accion = "comisionesalbaran";
      break;
    }
    default: {
      //tabla = "facturascli";
      clave = "idfactura";
      //campoLock = "editable";
      //tablaLineas = "lineasfacturascli";
      accion = "comisionesfactura";
      break;
    }
  }
  var idDoc = _i.tdbDocs_.cursor().valueBuffer(clave);
  if (!idDoc) {
    return;
  }
  var f = new FLFormSearchDB(accion);
  var curDoc = f.cursor();
  curDoc.select(clave + " = " + idDoc);
  if (curDoc.first()) {
    curDoc.setModeAccess(curDoc.Edit);
    curDoc.refreshBuffer();
    f.setMainWidget();
    if (!f.exec(clave)) {
      return false;
    }
  }
  _i.refrescaTablaTotal()
  return;

  /*
    var dialog = new Dialog(util.translate("scripts", "Porcentaje de Comisión"), 0);
    dialog.OKButtonText = util.translate("scripts", "Aceptar");
    dialog.cancelButtonText = util.translate("scripts", "Cancelar");

    var comision: NumberEdit = new NumberEdit;
    comision.label = util.translate("scripts", "% Comisión:");
    comision.decimals = 2;
    comision.maximum = 100;
    comision.minimum = 0;
    dialog.add(comision);
    if (!dialog.exec()) {
      return;
    }
    if (!comision.value) {
      return;
    }
    var curDoc: FLSqlCursor = new FLSqlCursor(tabla);
    curDoc.select(clave + " = " + idDoc);
    if (!curDoc.first()) {
      return;
    }
    var editable: Boolean = true;

    if (!curDoc.valueBuffer(campoLock)) {
      editable = false;
      curDoc.setUnLock(campoLock, true);
      curDoc.select(clave + " = " + idDoc);
      if (!curDoc.first()) {
        return;
      }
    }

    curDoc.setModeAccess(curDoc.Edit);
    curDoc.refreshBuffer();
    if (curDoc.valueBuffer("porcomision")) {
      curDoc.setValueBuffer("porcomision", comision.value);
      if (!curDoc.commitBuffer()) {
        return;
      }
    } else {
      if (!util.sqlUpdate(tabla, "porcomision", comision.value, clave + " = " + idDoc)) {
        return false;
      }
    }

    if (!editable) {
      delete curDoc;
      curDoc = new FLSqlCursor(tabla);
      curDoc.select(clave + " = " + idDoc);
      if (!curDoc.first()) {
        return;
      }
      curDoc.setUnLock(campoLock, false);
    }

    this.iface.tdbDocs_.refresh();
    var totalLiq: Number = this.iface.calculateField("total");
    this.child("fdbTotal").setValue(totalLiq);
    */
}

function oficial_refrescaTablaTotal()
{
  var _i = this.iface;
  _i.tdbDocs_.refresh();
  var totalLiq = _i.calculateField("total");
  this.child("fdbTotal").setValue(totalLiq);
}

function oficial_commonCalculateField(fN: String, cursor: FLSqlCursor): String {
  var util: FLUtil = new FLUtil();
  var res: String;

  var tabla: String;
  switch (this.iface.docLiquidacion_)
  {
    case "Albaranes": {
      tabla = "albaranescli";
      break;
    }
    default: {
      tabla = "facturascli";
      break;
    }
  }
  switch (fN)
  {
    case "total": {
      res = flfactppal.iface.pub_calcularLiquidacionAgente(tabla + ".codliquidacion = '" + this.iface.codLiquidacion + "'", this.iface.docLiquidacion_);
      break;
    }
    default: {
      res = this.iface.__commonCalculateField(fN, cursor);
      break;
    }
  }
  return res;
}

function oficial_bufferChanged(fN: String)
{
  debug("oficial_bufferChanged * " + fN);
  switch (fN) {
    case "codejercicio":
    case "tipoperiodo": {
      this.iface.habilitarPeriodo();
      this.iface.establecerFechasPeriodo();
      break;
    }
    case "mes":
    case "trimestre": {
      this.iface.establecerFechasPeriodo();
      break;
    }
  }
}

/** \D Habilita los controles de perído y tipo de período si hay un ejercicio especificado, y muestra el tipo de período (mes, trimestre o año) indicado por el usuario
\*/
function oficial_habilitarPeriodo()
{
  var cursor: FLSqlCursor = this.cursor();

  var codEjercicio: String = cursor.valueBuffer("codejercicio");
  if (codEjercicio && codEjercicio != "") {
    this.child("fdbMes").setDisabled(false);
    this.child("fdbTrimestre").setDisabled(false);
    this.child("fdbTipoPeriodo").setShowAlias(true);
    this.child("fdbTipoPeriodo").setShowEditor(true);
    switch (cursor.valueBuffer("tipoperiodo")) {
      case "Mes": {
        this.child("fdbMes").setShowAlias(true);
        this.child("fdbMes").setShowEditor(true);
        this.child("fdbTrimestre").setShowAlias(false);
        this.child("fdbTrimestre").setShowEditor(false);
        break;
      }
      case "Trimestre": {
        this.child("fdbTrimestre").setShowAlias(true);
        this.child("fdbTrimestre").setShowEditor(true);
        this.child("fdbMes").setShowAlias(false);
        this.child("fdbMes").setShowEditor(false);
        break;
      }
      default: {
        this.child("fdbTrimestre").setShowAlias(false);
        this.child("fdbTrimestre").setShowEditor(false);
        this.child("fdbMes").setShowAlias(false);
        this.child("fdbMes").setShowEditor(false);
      }
    }
  } else {
    this.child("fdbMes").setDisabled(true);
    this.child("fdbTrimestre").setDisabled(true);
    this.child("fdbTipoPeriodo").setShowAlias(false);
    this.child("fdbTipoPeriodo").setShowEditor(false);
    this.child("fdbTrimestre").setShowAlias(false);
    this.child("fdbTrimestre").setShowEditor(false);
    this.child("fdbMes").setShowAlias(false);
    this.child("fdbMes").setShowEditor(false);
  }
}


/** \D Establece las fechas de inicio y fin del período de liquidación
\end */
function oficial_establecerFechasPeriodo()
{
  var util: FLUtil = new FLUtil();
  var cursor: FLSqlCursor = this.cursor();

  var fechaInicio: Date;
  var fechaFin: Date;
  var codEjercicio: String = cursor.valueBuffer("codejercicio");
  if (!codEjercicio || codEjercicio == "") {
    return false;
  }

  var inicioEjercicio = util.sqlSelect("ejercicios", "fechainicio", "codejercicio = '" + codEjercicio + "'");
  if (!inicioEjercicio) {
    return false;
  }

  fechaInicio.setYear(inicioEjercicio.getYear());
  fechaFin.setYear(inicioEjercicio.getYear());
  fechaInicio.setDate(1);

  switch (cursor.valueBuffer("tipoperiodo")) {
    case "Trimestre": {
      switch (cursor.valueBuffer("trimestre")) {
        case "1T": {
          fechaInicio.setMonth(1);
          fechaFin.setMonth(3);
          fechaFin.setDate(31);
          break;
        }
        case "2T": {
          fechaInicio.setMonth(4);
          fechaFin.setMonth(6);
          fechaFin.setDate(30);
          break;
        }
        case "3T":
          fechaInicio.setMonth(7);
          fechaFin.setMonth(9);
          fechaFin.setDate(30);
          break;
        case "4T": {
          fechaInicio.setMonth(10);
          fechaFin.setMonth(12);
          fechaFin.setDate(31);
          break;
        }
        default: {
          fechaInicio = false;
        }
      }
      break;
    }
    case "Mes": {
      var numMes: Number = parseInt(cursor.valueBuffer("mes"));
      fechaInicio.setDate(1);
      fechaInicio.setMonth(numMes);
      fechaFin = util.addMonths(fechaInicio, 1);
      fechaFin = util.addDays(fechaFin, -1);
      break;
    }
    default: {
      fechaInicio.setDate(1);
      fechaInicio.setMonth(1);
      fechaFin = util.addYears(fechaInicio, 1);
      fechaFin = util.addDays(fechaFin, -1);
      break;
    }
  }

  if (fechaInicio) {
    this.child("fdbFechaDesde").setValue(fechaInicio);
    this.child("fdbFechaHasta").setValue(fechaFin);
  }
}

function oficial_asociaDocumentoTabla()
{
  debug("oficial_asociaDocumentoTabla");
  //  var tblDoc:FLTableDB = this.child("tdbFacturas");
  switch (this.iface.docLiquidacion_) {
    case "Albaranes": {
      this.iface.tdbDocs_ = this.child("tdbAlbaranes");
      this.child("tbwDocs").setTabEnabled("albaranes", true);
      this.child("tbwDocs").setTabEnabled("facturas", false);
      //      tblDoc.cursor().setAction("albaranescli");
      //      tblDoc.setTableName("albaranescli");
      //      tblDoc.setForeignField("codliquidacion");
      //      tblDoc.setFieldRelation("codliquidacion");
      //      tblDoc.cursor().setCursorRelation(this.cursor());
      break;
    }
    default: {
      this.iface.tdbDocs_ = this.child("tdbFacturas");
      this.child("tbwDocs").setTabEnabled("albaranes", false);
      this.child("tbwDocs").setTabEnabled("facturas", true);
    }
  }
  //  tblDoc.setFilter("");
  //  tblDoc.refresh(true, true);
}
//// OFICIAL ////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
