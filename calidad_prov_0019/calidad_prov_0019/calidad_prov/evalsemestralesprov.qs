/***************************************************************************
                 evalsemestralesprov.qs  -  description
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
}
//// OFICIAL /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////


/** @class_declaration calidadProv */
/////////////////////////////////////////////////////////////////
//// CALIDAD_PROV /////////////////////////////////////////////////
class calidadProv extends oficial
{
  var idAnterior: Number = -1;
  function calidadProv(context)
  {
    oficial(context);
  }
  function init()
  {
    return this.ctx.calidadProv_init();
  }
  function validateForm()
  {
    return this.ctx.calidadProv_validateForm();
  }
  function generarEvaluacion()
  {
    return this.ctx.calidadProv_generarEvaluacion();
  }
  function validarEvaluacion()
  {
    return this.ctx.calidadProv_validarEvaluacion();
  }
  function generarSeguimientos()
  {
    return this.ctx.calidadProv_generarSeguimientos();
  }
  function vaciarSeguimientos()
  {
    return this.ctx.calidadProv_vaciarSeguimientos();
  }
  function inicializarValores(): Number { return this.ctx.calidadProv_inicializarValores(); }
  function refrescarTablas(): Number { return this.ctx.calidadProv_refrescarTablas(); }

  function agregarProveedor(): Boolean {
    return this.ctx.oficial_agregarProveedor();
  }
  function eliminarProveedor()
  {
    return this.ctx.oficial_eliminarProveedor();
  }
  function eliminarTodosProveedor()
  {
    return this.ctx.oficial_eliminarTodosProveedor();
  }
  function bufferChanged(fN: String)
  {
    this.ctx.calidadProv_bufferChanged(fN);
  }
  function calculateField(fN: String)
  {
    return this.ctx.calidadProv_calculateField(fN);
  }
}
//// CALIDAD_PROV /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////


/** @class_declaration head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////
class head extends calidadProv
{
  function head(context)
  {
    calidadProv(context);
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
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition calidadProv */
/////////////////////////////////////////////////////////////////
//// CALIDAD_PROV /////////////////////////////////////////////////
function calidadProv_init()
{
  var cursor: FLSqlCursor = this.cursor();
  this.iface.inicializarValores();
  connect(this.child("pbnGenerarSeguimientos"), "clicked()", this, "iface.generarSeguimientos");

  connect(this.child("tbInsert"), "clicked()", this, "iface.agregarProveedor");
  connect(this.child("tbDelete"), "clicked()", this, "iface.eliminarProveedor");
  connect(this.child("tbDeleteAll"), "clicked()", this, "iface.eliminarTodosProveedor");
  connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");
}

function calidadProv_validateForm()
{
  return this.iface.validarEvaluacion();
}

function calidadProv_generarSeguimientos()
{
  var util: FLUtil = new FLUtil();

  var res = MessageBox.warning(util.translate("scripts", "Se va a proceder a la evaluación automática\nLos registros existentes serán eliminados.\n\n¿Continuar?"), MessageBox.No, MessageBox.Yes, MessageBox.NoButton);

  if (res != MessageBox.Yes) return;

  this.setDisabled(true);
  if (!this.iface.validarEvaluacion()) {
    this.setDisabled(false);
    return;
  }

  this.iface.vaciarSeguimientos();

  var cursor = this.cursor();
  if (!cursor.isValid()) {
    this.setDisabled(false);
    return;
  }

  cursor.commitBuffer();

  var fechaDesde: String = cursor.valueBuffer("fechadesdeevaluacion");
  var fechaHasta: String = cursor.valueBuffer("fechaevaluacion");

  var exigenciaSubida: Number = cursor.valueBuffer("exigenciasubida");
  var exigenciaBajada: Number = cursor.valueBuffer("exigenciabajada");
  var registradaPor: String = cursor.valueBuffer("evaluadopor");

  var idEvaluacion: String = cursor.valueBuffer("id");
  var codProveedor, nomProveedor, nivelAnterior, nivelActual, causaCambio: String;
  var suspendidaHomol: Boolean;
  var valorIncidencias: Number;

  var curSeg: FLSqlCursor = new FLSqlCursor("seguimientosprov");

  var q: FLSqlQuery = new FLSqlQuery();
  q.setFrom("incidenciasprov");
  q.setTablesList("incidenciasprov");
  q.setSelect("to_char(sum(valor),'99999999')");

  var qProv: FLSqlQuery = new FLSqlQuery();
  qProv.setFrom("proveedores p INNER JOIN proveedoreseval pe ON p.codproveedor = pe.codproveedor");
  qProv.setTablesList("proveedores,proveedoreseval");
  qProv.setSelect("p.codproveedor,p.nombre,p.nivelactual,p.suspendidahomol");
  qProv.setWhere("pe.idevaluacion = " + idEvaluacion);

  if (!qProv.exec()) {
    this.setDisabled(false);
    return;
  }

  var where: String = "";
  var paso: Number = 1;
  util.createProgressDialog(util.translate("scripts", "Generando Evaluaciones"), qProv.size());
  util.setProgress(paso);


  while (qProv.next()) {

    codProveedor = qProv.value(0);
    nomProveedor = qProv.value(1);
    nivelAnterior = qProv.value(2);
    suspendidaHomol = qProv.value(3);

    if (suspendidaHomol) {
      this.setDisabled(false);
      continue;
    }

    where = "codproveedor = '" + codProveedor + "'";
    if (fechaDesde)
      where += " AND fecha >= '" + fechaDesde + "'";
    if (fechaHasta)
      where += " AND fecha <= '" + fechaHasta + "'";

    q.setWhere(where + " group by codproveedor");
    if (!q.exec()) {
      this.setDisabled(false);
      continue;
    }

    valorIncidencias = 0;
    if (q.first()) valorIncidencias = q.value(0);

    nivelActual = nivelAnterior;
    causaCambio = "Se mantiene";

    if (nivelAnterior != "Baja" && parseFloat(valorIncidencias) >= parseFloat(exigenciaSubida))
      nivelActual = "A";

    if (nivelAnterior != "Baja" && parseFloat(valorIncidencias) <= parseFloat(exigenciaBajada))
      nivelActual = "B";

    switch (nivelActual) {
      case "A":
        causaCambio = "Cumple los criterios de calidad siguientes: valor de incidencias >= " + exigenciaSubida;
        break;
      case "B":
        causaCambio = "NO cumple los criterios de calidad siguientes: valor de incidencias > " + exigenciaBajada;
        break;
      case "Baja":
        causaCambio = "Es baja";
        break;
    }

    curSeg.setModeAccess(curSeg.Insert);
    curSeg.refreshBuffer();
    curSeg.setValueBuffer("codproveedor", codProveedor);
    curSeg.setValueBuffer("registradapor", registradaPor);
    curSeg.setValueBuffer("nombreproveedor", nomProveedor);
    curSeg.setValueBuffer("idevaluacion", idEvaluacion);
    curSeg.setValueBuffer("fechaevaluacion", fechaHasta);
    curSeg.setValueBuffer("nivelanterior", nivelAnterior);
    curSeg.setValueBuffer("resultado", nivelActual);
    curSeg.setValueBuffer("valorincidencias", valorIncidencias);
    curSeg.setValueBuffer("observaciones", causaCambio);

    curSeg.commitBuffer();

    util.setProgress(paso++);
  }

  util.destroyProgressDialog();
  this.iface.refrescarTablas();
  this.setDisabled(false);
}

function calidadProv_vaciarSeguimientos()
{
  var util: FLUtil = new FLUtil();

  var cursor: FLSqlCursor = this.cursor();
  if (!this.cursor().isValid())return;

  var idEvaluacion: String = cursor.valueBuffer("id");
  var curSeg: FLSqlCursor = new FLSqlCursor("seguimientosprov");

  var paso: Number = 1;
  util.createProgressDialog(util.translate("scripts", "Eliminando Evaluaciones"), curSeg.size());
  util.setProgress(paso);

  curSeg.select("idevaluacion = " + idEvaluacion);
  while (curSeg.next()) {
    curSeg.setModeAccess(curSeg.Del);
    curSeg.refreshBuffer();
    curSeg.commitBuffer();
    util.setProgress(paso++);
  }
  util.destroyProgressDialog();
}

function calidadProv_inicializarValores()
{
  var util: FLUtil = new FLUtil();
  var cursor: FLSqlCursor = this.cursor();
  var idEvaluacion: String = cursor.valueBuffer("id");

  var q: FLSqlQuery = new FLSqlQuery();
  q.setFrom("evalsemestralesprov");
  q.setTablesList("evalsemestralesprov");
  q.setSelect("id,exigenciasubida,exigenciabajada,fechaevaluacion");
  q.setWhere("1=1 order by fechaevaluacion desc");

  if (!q.exec()) return;

  this.iface.idAnterior = -1;

  if (q.first()) {
    this.iface.idAnterior = q.value(0);
    if (cursor.modeAccess() == cursor.Insert) {
      this.child("fdbExigenciaSubida").setValue(q.value(1));
      this.child("fdbExigenciaBajada").setValue(q.value(2));
      this.child("fdbFechaDesdeEvaluacion").setValue(util.addDays(q.value(3), 1));
    }
  }
  this.iface.refrescarTablas();
}

function calidadProv_validarEvaluacion(): Boolean {
  var util: FLUtil = new FLUtil();
  var cursor: FLSqlCursor = this.cursor();
  if (!this.cursor().isValid()) return;

  var fechaDesde: String = cursor.valueBuffer("fechadesdeevaluacion");
  var fechaHasta: String = cursor.valueBuffer("fechaevaluacion");

  if (fechaDesde > fechaHasta)
  {
    MessageBox.warning(util.translate("scripts",
    "La fecha de evaluación debe ser posterior a la fecha de inicio del período"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return false;
  }

  var exigenciaSubida: String = cursor.valueBuffer("exigenciasubida");
  var exigenciaBajada: String = cursor.valueBuffer("exigenciabajada");

  if (parseInt(exigenciaBajada) >= parseInt(exigenciaSubida))
  {
    MessageBox.warning(util.translate("scripts",
    "La exigencia de subida debe ser estrictamente mayor que la exigencia de bajada"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return false;
  }
  return true;
}

function calidadProv_refrescarTablas()
{
  var idEvaluacion: String = this.cursor().valueBuffer("id");
  var where: String;

  where = "idevaluacion = " + idEvaluacion;
  this.child("tdbSegTodos").cursor().setMainFilter(where);
  this.child("tdbSegTodos").refresh();

  where = "nivelanterior <> 'A' AND resultado = 'A' AND idevaluacion = " + idEvaluacion;
  this.child("tdbSegSuben").cursor().setMainFilter(where);
  this.child("tdbSegSuben").refresh();

  where = "nivelanterior <> 'B' AND resultado = 'B' AND idevaluacion = " + idEvaluacion;
  this.child("tdbSegBajan").cursor().setMainFilter(where);
  this.child("tdbSegBajan").refresh();

  where = "resultado <> 'Baja' AND nivelanterior = resultado AND idevaluacion = " + idEvaluacion;
  this.child("tdbSegMantienen").cursor().setMainFilter(where);
  this.child("tdbSegMantienen").refresh();

  where = "resultado = 'Baja' AND idevaluacion = " + idEvaluacion;
  this.child("tdbSegSonBaja").cursor().setMainFilter(where);
  this.child("tdbSegSonBaja").refresh();
}


function oficial_agregarProveedor(): Boolean {
  var util: FLUtil = new FLUtil();
  var cursor: FLSqlCursor = this.cursor();
  var idEval: Number = cursor.valueBuffer("id");

  if (cursor.modeAccess() == cursor.Insert)
  {
    var curP: FLSqlCursor = this.child("tdbProveedores").cursor();
    curP.setModeAccess(curP.Insert);
    curP.commitBufferCursorRelation();
  }

  var listaProveedores: String = "";
  var filtro: String = "";
  var curTab: FLSqlCursor = new FLSqlCursor("proveedoreseval");
  curTab.select("idevaluacion = " + idEval);
  while (curTab.next())
  {
    if (listaProveedores)
      listaProveedores += ",";
    listaProveedores += "'" + curTab.valueBuffer("codproveedor") + "'";
  }

  if (listaProveedores)
    filtro = "codproveedor NOT IN (" + listaProveedores + ")";


  var f: Object = new FLFormSearchDB("seleccionproveedoreseval");
  var curProveedores: FLSqlCursor = f.cursor();

  if (cursor.modeAccess() != cursor.Browse)
    if (!cursor.checkIntegrity())
      return;

  curProveedores.select();
  if (!curProveedores.first())
    curProveedores.setModeAccess(curProveedores.Insert);
  else
    curProveedores.setModeAccess(curProveedores.Edit);

  f.setMainWidget();
  curProveedores.refreshBuffer();
  curProveedores.setValueBuffer("datos", "");
  curProveedores.setValueBuffer("filtro", filtro);

  var ret = f.exec("datos");

  if (!f.accepted())
    return false;

  var datos: String = new String(ret);

  if (datos.isEmpty())
    return false;

  var regExp: RegExp = new RegExp("'");
  regExp.global = true;
  datos = datos.replace(regExp, "");

  var proveedores: Array = datos.split(",");
  var curTab: FLSqlCursor = new FLSqlCursor("proveedoreseval");

  var paso: Number = 1;
  util.createProgressDialog(util.translate("scripts", "Agregando proveedores"), proveedores.length);

  for (var i: Number = 0; i < proveedores.length; i++)
  {
    codProveedor = proveedores[i];
    util.setProgress(paso++);

    curTab.select("codproveedor = '" + codProveedor + "' AND idevaluacion = " + idEval);
    if (!curTab.first()) {
      curTab.setModeAccess(curTab.Insert);
      curTab.refreshBuffer();
      curTab.setValueBuffer("idevaluacion", idEval);
      curTab.setValueBuffer("codproveedor", codProveedor);
      curTab.setValueBuffer("nombreproveedor", util.sqlSelect("proveedores", "nombre", "codproveedor = '" + codProveedor + "'"));
      curTab.commitBuffer();
    }
  }

  util.destroyProgressDialog();
  this.child("tdbProveedores").refresh();
}

function oficial_eliminarProveedor()
{
  if (!this.child("tdbProveedores").cursor().isValid())
    return;

  var idEval: Number = this.cursor().valueBuffer("id");
  var codProveedor: String = this.child("tdbProveedores").cursor().valueBuffer("codproveedor");

  var curTab: FLSqlCursor = new FLSqlCursor("proveedoreseval");
  curTab.select("codproveedor = '" + codProveedor + "' AND idevaluacion = " + idEval);
  if (curTab.first()) {
    curTab.setModeAccess(curTab.Del);
    curTab.refreshBuffer();
    curTab.commitBuffer();
  }

  this.child("tdbProveedores").refresh();
}

function oficial_eliminarTodosProveedor()
{
  if (!this.child("tdbProveedores").cursor().isValid())
    return;

  var util: FLUtil = new FLUtil();
  var res = MessageBox.warning(util.translate("scripts", "Se quitarán todos los proveedores\n\n¿Continuar?"), MessageBox.No, MessageBox.Yes, MessageBox.NoButton);
  if (res != MessageBox.Yes)
    return;

  var idEval: Number = this.cursor().valueBuffer("id");
  var codProveedor: String = this.child("tdbProveedores").cursor().valueBuffer("codproveedor");

  var curTab: FLSqlCursor = new FLSqlCursor("proveedoreseval");
  curTab.select("idevaluacion = " + idEval);

  var paso: Number = 1;
  util.createProgressDialog(util.translate("scripts", "Quitando proveedores"), curTab.size());

  while (curTab.next()) {
    util.setProgress(paso++);
    curTab.setModeAccess(curTab.Del);
    curTab.refreshBuffer();
    curTab.commitBuffer();
  }

  util.destroyProgressDialog();
  this.child("tdbProveedores").refresh();
}

function calidadProv_bufferChanged(fN)
{
  var cursor: FLSqlCursor = this.cursor();
  switch (fN) {
    case "fechadesdeevaluacion":
    case "periodo": {
      this.child("fdbFechaEvaluacion").setValue(this.iface.calculateField("fechaevaluacion"));
      break;
    }
  }
}

function calidadProv_calculateField(fN: String): String {
  var util: FLUtil = new FLUtil();
  var cursor: FLSqlCursor = this.cursor();
  var res: String;

  switch (fN)
  {
    case "fechaevaluacion": {
      var fechaDesde: Date = cursor.valueBuffer("fechadesdeevaluacion");
      var periodo: String = cursor.valueBuffer("periodo");
      var meses: Number;
      switch (periodo) {
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
      if (fechaDesde) {
        res = util.addMonths(fechaDesde, meses);
      }
      break;
    }
  }
  return res;
}

//// CALIDAD_PROV /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////


/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
