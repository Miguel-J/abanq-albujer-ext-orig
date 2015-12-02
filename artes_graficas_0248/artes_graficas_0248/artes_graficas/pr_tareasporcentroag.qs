/***************************************************************************
                 pr_tareasporcentroag.qs  -  description
                             -------------------
    begin                : jue nov 26 2009
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
////////////////////////////////////////////////////////////////////////////
//// DECLARACION ///////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

/** @class_declaration interna */
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
  var C_PRIORIDAD: Number;
  var C_FECHA: Number;
  var C_CLIENTE: Number;
  var C_TAREA: Number;
  var C_TRABAJO: Number;
  var C_IDTAREA: Number;
  var tblTareas_: FLTable;
  var centroCoste_: String;
  var filaActual_: Number;
  function oficial(context)
  {
    interna(context);
  }
  function crearTabla()
  {
    return this.ctx.oficial_crearTabla();
  }
  function tbnBuscarCentro_clicked()
  {
    return this.ctx.oficial_tbnBuscarCentro_clicked();
  }
  function buscar()
  {
    return this.ctx.oficial_buscar();
  }
  function bgPrioridad_clicked(prioridad: Number)
  {
    return this.ctx.oficial_bgPrioridad_clicked(prioridad);
  }
  function tblTareas_currentChanged(fila: Number, col: Number)
  {
    return this.ctx.oficial_tblTareas_currentChanged(fila, col);
  }
  function tbnLanzarInforme_clicked()
  {
    return this.ctx.oficial_tbnLanzarInforme_clicked();
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

////////////////////////////////////////////////////////////////////////////
//// DEFINICION ////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

/** @class_definition interna */
//////////////////////////////////////////////////////////////////
//// INTERNA /////////////////////////////////////////////////////
function interna_init()
{
  debug("init");
  var util: FLUtil = new FLUtil();

  this.iface.tblTareas_ = this.child("tblTareas");
  this.iface.centroCoste_ = false;
  this.iface.filaActual_ = 0;

  this.iface.crearTabla();

  connect(this.child("tbnBuscarCentro"), "clicked()", this, "iface.tbnBuscarCentro_clicked");
  connect(this.child("tbnLanzarInforme"), "clicked()", this, "iface.tbnLanzarInforme_clicked");
  connect(this.child("bgPrioridad"), "clicked(int)", this, "iface.bgPrioridad_clicked");
  connect(this.iface.tblTareas_, "currentChanged(int, int)", this, "iface.tblTareas_currentChanged");

}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
/** \C
\end */
function oficial_crearTabla()
{
  var util: FLUtil = new FLUtil();

  this.iface.C_PRIORIDAD = 0;
  this.iface.C_FECHA = 1;
  this.iface.C_CLIENTE = 2;
  this.iface.C_TAREA = 3;
  this.iface.C_TRABAJO = 4;
  this.iface.C_IDTAREA = 5;

  this.iface.tblTareas_.setNumCols(6);
  this.iface.tblTareas_.setColumnWidth(this.iface.C_PRIORIDAD, 60);
  this.iface.tblTareas_.setColumnWidth(this.iface.C_FECHA, 100);
  this.iface.tblTareas_.setColumnWidth(this.iface.C_CLIENTE, 150);
  this.iface.tblTareas_.setColumnWidth(this.iface.C_TAREA, 150);
  this.iface.tblTareas_.setColumnWidth(this.iface.C_TRABAJO, 150);
  this.iface.tblTareas_.setColumnWidth(this.iface.C_IDTAREA, 100);
  this.iface.tblTareas_.setColumnLabels("/", "Prioridad/Fecha/Cliente/Tarea/Trabajo/Id.Tarea");
}

function oficial_tbnBuscarCentro_clicked()
{
  var util: FLUtil = new FLUtil();
  var f: Object = new FLFormSearchDB("pr_centroscoste");

  //  var codCliente:String = cursor.valueBuffer("codcliente");
  //  var masFiltro:String = "";
  //  if (codCliente)
  //    masFiltro += " AND codcliente = '" + codCliente + "'";
  //
  //  if (cursor.modeAccess() == cursor.Insert)
  //    curFacturas.setMainFilter("deabono = false" + masFiltro);
  //  else
  //    curFacturas.setMainFilter("deabono = false and idfactura <> " + this.cursor().valueBuffer("idfactura") + masFiltro);

  f.setMainWidget();
  this.iface.centroCoste_ = f.exec("codcentro");
  if (this.iface.centroCoste_) {
    this.child("lblCentro").text = util.sqlSelect("pr_centroscoste", "descripcion", "codcentro = '" + this.iface.centroCoste_ + "'");
  } else {
    this.child("lblCentro").text = util.translate("scripts", "Seleccione centro de coste");
  }

  this.iface.buscar();
}

function oficial_buscar()
{
  var util: FLUtil = new FLUtil;
  this.iface.tblTareas_.setNumRows(0);
  if (!this.iface.centroCoste_) {
    return;
  }
  var qryTareas: FLSqlQuery = new FLSqlQuery;
  qryTareas.setTablesList("pr_tareas,pr_procesos,lineaspedidoscli,pedidoscli");
  qryTareas.setSelect("t.idtarea, t.prioridad, t.diainicio, pe.nombrecliente, t.descripcion, lp.descripcion");
  qryTareas.setFrom("pr_tareas t INNER JOIN pr_procesos p ON t.idproceso = p.idproceso INNER JOIN lineaspedidoscli lp ON p.idlineapedidocli = lp.idlinea INNER JOIN pedidoscli pe ON lp.idpedido = pe.idpedido");
  qryTareas.setWhere("t.codcentro = '" + this.iface.centroCoste_ + "' AND t.estado IN ('PTE', 'EN CURSO', 'OFF') ORDER BY t.prioridad DESC, t.diainicio ASC");
  qryTareas.setForwardOnly(true);
  if (!qryTareas.exec()) {
    return false;
  }
  // debug(qryTareas.sql());
  var iFila: Number = 0;
  while (qryTareas.next()) {
    this.iface.tblTareas_.insertRows(iFila);
    this.iface.tblTareas_.setText(iFila, this.iface.C_PRIORIDAD, qryTareas.value("t.prioridad"));
    this.iface.tblTareas_.setText(iFila, this.iface.C_FECHA, util.dateAMDtoDMA(qryTareas.value("t.diainicio")));
    this.iface.tblTareas_.setText(iFila, this.iface.C_CLIENTE, qryTareas.value("pe.nombrecliente"));
    this.iface.tblTareas_.setText(iFila, this.iface.C_TAREA, qryTareas.value("t.descripcion"));
    this.iface.tblTareas_.setText(iFila, this.iface.C_TRABAJO, qryTareas.value("lp.descripcion"));
    this.iface.tblTareas_.setText(iFila, this.iface.C_IDTAREA, qryTareas.value("t.idtarea"));
    iFila++;
  }
}

function oficial_bgPrioridad_clicked(prioridad: Number)
{
  var iFila: Number = this.iface.filaActual_;
  var filas: Number = this.iface.tblTareas_.numRows();
  if (iFila >= filas) {
    return;
  }
  var idTarea: Number = this.iface.tblTareas_.text(iFila, this.iface.C_IDTAREA);
  debug("idTarea = " + idTarea);
  var cursor: FLSqlCursor = new FLSqlCursor("pr_tareas");
  cursor.setActivatedCheckIntegrity(false);
  cursor.setActivatedCommitActions(false);
  cursor.select("idtarea = '" + idTarea + "'");
  cursor.first();
  cursor.setModeAccess(cursor.Edit);
  cursor.refreshBuffer();
  cursor.setValueBuffer("prioridad", prioridad);
  cursor.commitBuffer();
  this.iface.buscar();
}

function oficial_tblTareas_currentChanged(fila: Number, col: Number)
{
  this.iface.filaActual_ = fila;
}

function oficial_tbnLanzarInforme_clicked()
{
  var util: FLUtil = new FLUtil;
  var q: FLSqlQuery = new FLSqlQuery("pr_i_tareasporcentro");
  q.setWhere("t.codcentro = '" + this.iface.centroCoste_ + "' AND t.estado IN ('PTE', 'EN CURSO', 'OFF') ORDER BY t.prioridad DESC, t.diainicio ASC");
  debug(q.sql());
  if (q.exec() == false) {
    MessageBox.critical(util.translate("scripts", "Falló la consulta"), MessageBox.Ok, MessageBox.NoButton);
    return;
  } else {
    if (q.first() == false) {
      MessageBox.warning(util.translate("scripts", "No hay registros que cumplan los criterios de búsqueda establecidos"), MessageBox.Ok, MessageBox.NoButton);
      return;
    }
  }

  var nombreReport = "pr_i_tareasporcentro";

  var rptViewer: FLReportViewer = new FLReportViewer();
  rptViewer.setReportTemplate(nombreReport);
  rptViewer.setReportData(q);
  rptViewer.renderReport();
  rptViewer.exec();
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////



//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////