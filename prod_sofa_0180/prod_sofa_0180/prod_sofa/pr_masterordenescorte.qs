/***************************************************************************
                 pr_masterordenescorte.qs  -  description
                             -------------------
    begin                : mar jul 17 2007
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
/** \C
El formulario permite borrar órdenes sólo si están en estado PTE
\end */
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
  var tbnImprimir: Object;
  var tbnBorrar: Object;
  var tdbRecords: Object;
  var tbnImprimirEtiquetas: Object;
  var pbnAsociarOP: Object;
  function oficial(context)
  {
    interna(context);
  }
  function imprimir()
  {
    this.ctx.oficial_imprimir();
  }
  function tbnBorrar_clicked()
  {
    this.ctx.oficial_tbnBorrar_clicked();
  }
  function borrarOrden(codOrden: String): Boolean {
    return this.ctx.oficial_borrarOrden(codOrden);
  }
  //  function sacarLS(uP:String):Boolean {
  //    return this.ctx.oficial_sacarLS(uP);
  //  }
  function sacarProceso(idProceso: String): Boolean {
    return this.ctx.oficial_sacarProceso(idProceso);
  }
  function imprimirEtiquetas()
  {
    this.ctx.oficial_imprimirEtiquetas();
  }
  function asociarOrdenesProduccion_clicked()
  {
    return this.ctx.oficial_asociarOrdenesProduccion_clicked();
  }
  function crearOrdenCorte(codOrden: String): Boolean {
    return this.ctx.oficial_crearOrdenCorte(codOrden);
  }
  //  function generarProcesoLote(codLote:String, referencia:String):Boolean {
  //    return this.ctx.oficial_generarProcesoLote(codLote, referencia);
  //  }
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
  function pub_sacarLS(uP: String): Boolean {
    return this.sacarLS(uP);
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

  this.iface.tbnImprimir = this.child("toolButtonPrint");
  this.iface.tbnBorrar = this.child("toolButtonDelete");
  this.iface.tdbRecords = this.child("tableDBRecords");
  this.iface.tbnImprimirEtiquetas = this.child("tbnImprimirEtiquetas");
  this.iface.pbnAsociarOP = this.child("pbnAsociarOP");

  connect(this.iface.tbnImprimir, "clicked()", this, "iface.imprimir");;
  connect(this.iface.tbnBorrar, "clicked()", this, "iface.tbnBorrar_clicked");
  connect(this.iface.tbnImprimirEtiquetas, "clicked()", this, "iface.imprimirEtiquetas");;
  connect(this.iface.pbnAsociarOP, "clicked()", this, "iface.asociarOrdenesProduccion_clicked()");

  cursor.setMainFilter("tipoorden = 'C'");
  this.iface.tdbRecords.refresh();
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////

/** \D
Imprime la orden de corte seleccionada
\end */
function oficial_imprimir()
{
  if (!this.cursor().isValid())
    return;
  if (!sys.isLoadedModule("flprodinfo")) {
    flfactppal.iface.pub_msgNoDisponible("Informes");
    return;
  }
  if (!this.cursor().isValid())
    return;

  var codOrden: String = this.cursor().valueBuffer("codorden");
  if (!codOrden || codOrden == "")
    return;

  var curImprimir: FLSqlCursor = new FLSqlCursor("pr_i_ordenescorte");
  curImprimir.setModeAccess(curImprimir.Insert);
  curImprimir.refreshBuffer();
  curImprimir.setValueBuffer("descripcion", "temp");
  curImprimir.setValueBuffer("d_pr__ordenesproduccion_codorden", codOrden);
  curImprimir.setValueBuffer("h_pr__ordenesproduccion_codorden", codOrden);

  formpr_i_ordenescorte.iface.pub_lanzar(curImprimir);
}

/** \C
Para borrar una orden de producción, ésta debe estar en estado PTE. El borrado consiste en las siguientes acciones:
Borrado del proceso y tareas de producción asociados
Desasignación de las unidades de producto asociados de la orden de producción a borrar
\end */
function oficial_tbnBorrar_clicked()
{
  var util: FLUtil = new FLUtil();
  var curOrden: FLSqlCursor = this.cursor();
  var estado: String = curOrden.valueBuffer("estado");

  if (!estado) {
    MessageBox.warning(util.translate("scripts", "No hay ninguna orden seleccionada"),  MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return false;
  }
  if (estado != "PTE") {
    MessageBox.warning(util.translate("scripts", "No se puede borrar la orden seleccionada, porque no está en estado PTE"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return false;
  }
  var codOrden: String = curOrden.valueBuffer("codorden");
  if (!codOrden)
    return false;

  var resp: Number = MessageBox.information(util.translate("scripts", "La orden seleccionada será borrada\n ¿está seguro?"), MessageBox.Yes, MessageBox.No, MessageBox.NoButton);
  if (resp != MessageBox.Yes)
    return false;

  curOrden.transaction(false);
  try {
    if (this.iface.borrarOrden(codOrden)) {
      curOrden.commit();
    } else {
      curOrden.rollback();
      return false;
    }
  } catch (e) {
    curOrden.rollback();
    MessageBox.critical(util.translate("scripts", "Error al borrar la orden de corte: ") + e, MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  this.iface.tdbRecords.refresh();
}

function oficial_borrarOrden(codOrden: String): Boolean {
  var util: FLUtil = new FLUtil;

  util.createProgressDialog(util.translate("scripts", "Eliminando orden de corte"), 100);
  util.setProgress(1);

  var qryProcesos: FLSqlQuery = new FLSqlQuery();

  qryProcesos.setTablesList("pr_procesos");
  qryProcesos.setSelect("idproceso");
  qryProcesos.setFrom("pr_procesos");
  qryProcesos.setWhere("codordenproduccion = '" + codOrden + "'");
  if (!qryProcesos.exec())
  {
    util.destroyProgressDialog();
    return false;
  }
  var totalProcesos: Number = qryProcesos.size();
  var progreso: Number = 1;

  util.setTotalSteps(totalProcesos);
  while (qryProcesos.next())
  {
    if (!this.iface.sacarProceso(qryProcesos.value("idproceso"))) {
      util.destroyProgressDialog();
      return false;
    }
    util.setProgress(progreso++);
  }

  if (!util.sqlDelete("pr_ordenesproduccion", "codorden = '" + codOrden + "'"))
  {
    //    MessageBox.warning(util.translate("scripts", "Hubo un error al eliminar la orden de corte"), MessageBox.Ok, MessageBox.NoButton);
    util.destroyProgressDialog();
    return false;
  }

  if (!util.sqlUpdate("pr_ordenesproduccion", "codordencorte", "NULL",  "codordencorte = '" + codOrden + "'"))
  {
    util.destroyProgressDialog();
    return false;
  }

  util.setProgress(totalProcesos);
  util.destroyProgressDialog();

  return true;
}

/** \D
Cancela el proceso de producción, lo saca de la orden de corte, y lo deja en estado OFF
@param  idProceso: Proceso a sacar
@return Verdadero si la desasignación se realiza correctamente, falso si no puede realizarse o hay error
\end */
function oficial_sacarProceso(idProceso: String): Boolean {
  var util: FLUtil = new FLUtil;

  if (!flcolaproc.iface.pub_pasarOFFProcesoProd(idProceso))
  {
    MessageBox.warning(util.translate("scripts", "Error al anular el proceso %1").arg(idProceso), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }

  //  if (!flcolaproc.iface.pub_borrarProceso(idProceso)) {
  //    MessageBox.warning(util.translate("scripts", "El proceso ya está en producción y no se puede sacar de la orden.\n\nProceso de producto: %1").arg(idProceso), MessageBox.Ok, MessageBox.NoButton);
  //    return false;
  //  }

  return true;
}

/* \D
Cancela el proceso de producción asociado a un lote de producto y lo saca de la orden de producción
@param  codLote: Lote de producto
@return Verdadero si la desasignación se realiza correctamente, falso si no puede realizarse o hay error
\end */
// function oficial_sacarLS(codLote:String):Boolean
// {
//  var util:FLUtil = new FLUtil;
//
//  var idTipoProceso:String;
//  idTipoProceso = util.sqlSelect("lotesstock ls INNER JOIN articulos a ON ls.referencia = a.referencia", "a.idtipoproceso", "ls.codlote = '" + codLote + "'", "lotesstock,articulos");
//  if (!idTipoProceso)
//    return false;
//
//  var codOrden:String = util.sqlSelect("lotesstock","codordenproduccion","codlote = '" + codLote + "'");
//  if(!codOrden)
//    return false;
//
//  var idProceso:Number = util.sqlSelect("pr_procesos", "idproceso", "idobjeto = '" + codLote + "' AND idtipoproceso = '" + idTipoProceso + "'");
//
//  if(!idProceso)
//    return false;
//
//  var estadoProceso:String = util.sqlSelect("pr_procesos", "estado", "idproceso = " + idProceso);
//  if (estadoProceso != "PTE") {
//    MessageBox.warning(util.translate("scripts", "Borrar proceso: El proceso debe estar en estado OFF o PTE"), MessageBox.Ok, MessageBox.NoButton);
//    return false;
//  }
//
//  var hayTareasIniciadas:Number = util.sqlSelect("pr_tareas", "idtarea", "idproceso = " + idProceso + " AND estado NOT IN ('PTE', 'OFF')");
//  if (hayTareasIniciadas) {
//    MessageBox.warning(util.translate("scripts", "Borrar proceso: Todas las tareas del proceso deben estar en estado OFF o PTE"), MessageBox.Ok, MessageBox.NoButton);
//    return false;
//  }
//
//  if (!util.sqlDelete("movistock","idproceso = " + idProceso + " AND codlote = '" + codLote + "'"))
//    return false;
//
//  if (!util.sqlUpdate("lotesstock", "codordenproduccion", "NULL",  "codlote = '" + codLote + "'"))
//    return false;
//
//  if (idProceso) {
//    if (!flcolaproc.iface.pub_borrarProceso(idProceso)) {
//      MessageBox.warning(util.translate("scripts", "No se puede eliminar el lote porque el proceso ya está en producción"), MessageBox.Ok, MessageBox.NoButton);
//      util.destroyProgressDialog();
//      return false;
//    }
//  }
//
//  return true;
// }

/** \D
Imprime las etiquetas de la orden de corte seleccionada
\end */
function oficial_imprimirEtiquetas()
{
  if (!this.cursor().isValid())
    return;
  if (!sys.isLoadedModule("flprodinfo")) {
    flfactppal.iface.pub_msgNoDisponible("Informes");
    return;
  }
  if (!this.cursor().isValid())
    return;

  var codOrden: String = this.cursor().valueBuffer("codorden");
  if (!codOrden || codOrden == "")
    return;

  var curImprimir: FLSqlCursor = new FLSqlCursor("pr_i_ordenescorte");
  curImprimir.setModeAccess(curImprimir.Insert);
  curImprimir.refreshBuffer();
  curImprimir.setValueBuffer("descripcion", "temp");
  curImprimir.setValueBuffer("d_pr__ordenesproduccion_codorden", codOrden);
  curImprimir.setValueBuffer("h_pr__ordenesproduccion_codorden", codOrden);

  flprodinfo.iface.pub_lanzarInforme(curImprimir, "pr_i_pegascorte", "", "", false);
}

function oficial_asociarOrdenesProduccion_clicked()
{
  var util: FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  var f: Object = new FLFormSearchDB("pr_asociarordenesprod");
  var curSelOrdenes: FLSqlCursor = f.cursor();
  curSelOrdenes.select();
  if (!curSelOrdenes.first())
    curSelOrdenes.setModeAccess(curSelOrdenes.Insert);
  else
    curSelOrdenes.setModeAccess(curSelOrdenes.Edit);

  curSelOrdenes.refreshBuffer();

  f.setMainWidget();
  curSelOrdenes.setValueBuffer("idordendesde", "");
  curSelOrdenes.setValueBuffer("idordenhasta", "");
  curSelOrdenes.setValueBuffer("fechadesde", "");
  curSelOrdenes.setValueBuffer("fechahasta", "");
  curSelOrdenes.setValueBuffer("codruta", "");
  curSelOrdenes.setValueBuffer("idordencorte", "");

  var curEmpresa: FLSqlCursor = new FLSqlCursor("empresa");
  curEmpresa.transaction(false);
  try {
    f.exec("id");
    if (f.accepted()) {
      var codOrden: String = curSelOrdenes.valueBuffer("idordencorte");
      if (codOrden && codOrden != "") {
        if (!this.iface.crearOrdenCorte(codOrden))
          curEmpresa.rollback();
        else
          curEmpresa.commit();
      } else
        curEmpresa.rollback();
    } else
      curEmpresa.rollback();
  } catch (e) {
    curEmpresa.rollback();
    MessageBox.critical(util.translate("scripts", "Hubo un error en la asociación de órdenes de producción:") + "\n" + e, MessageBox.Ok, MessageBox.NoButton);
  }

  this.iface.tdbRecords.refresh();
}

function oficial_crearOrdenCorte(codOrden: String): Boolean {
  var util: FLUtil;
  var hoy: Date = new Date();

  var totalLotes: Number = 0;
  var codRuta: String = "";

  var qry: FLSqlQuery = new FLSqlQuery();
  qry.setTablesList("lotesstock");
  qry.setSelect("procesoscorte.idproceso,cortes.codlote,cortes.cantidad,cortes.referencia");
  qry.setFrom("pr_procesos procesosprod INNER JOIN pr_ordenesproduccion ordenesprod ON procesosprod.codordenproduccion = ordenesprod.codorden INNER JOIN lotesstock modulos ON modulos.codlote = procesosprod.idobjeto INNER JOIN movistock cortes ON cortes.codloteprod = modulos.codlote INNER JOIN pr_procesos procesoscorte ON procesoscorte.idobjeto = cortes.codlote");
  qry.setWhere("ordenesprod.codordencorte = '" + codOrden + "' AND cortes.codlote IS NOT NULL AND cortes.codlote <> '' AND procesoscorte.estado = 'OFF'");

  if (!qry.exec())
    return false;

  if (qry.size() == 0)
    return false;

  var codLote: String;
  var cantidad: String;
  var referencia: String;
  var totalFilas: Number = 0;

  flprodppal.iface.pub_limpiarMemoria();

  var datosLote: Array = [];

  var curOCS: FLSqlCursor = new FLSqlCursor("pr_ordenesproduccion");
  curOCS.setModeAccess(curOCS.Insert);
  curOCS.refreshBuffer();
  curOCS.setValueBuffer("codorden", codOrden);
  curOCS.setValueBuffer("fecha", hoy);
  curOCS.setValueBuffer("estado", "PTE");
  curOCS.setValueBuffer("totallotes", 0);
  curOCS.setValueBuffer("tipoorden", "C");
  curOCS.setValueBuffer("planificacion", "");
  if (!curOCS.commitBuffer())
    return false;



  var totalFilas: Number = 0;
  while (qry.next())
  {
    datosLote = [];
    datosLote["idProceso"] = qry.value("procesoscorte.idproceso");
    datosLote["codLote"] = qry.value("cortes.codlote");
    datosLote["cantidad"] = qry.value("cortes.cantidad");
    datosLote["referencia"] = qry.value("cortes.referencia");

    if (!flprodppal.iface.pub_cargarTareasLote(datosLote))
      return false;

    totalFilas ++;
  }

  if (!flprodppal.iface.pub_establecerSecuencias())
    return false;

  if (!flprodppal.iface.pub_iniciarCentrosCoste())
    return false;

  if (!flprodppal.iface.pub_aplicarAlgoritmo("FIFO"))
    return false;

  var planificacion: String = flprodppal.iface.htmlPlanificacion();
  var curOCS: FLSqlCursor = new FLSqlCursor("pr_ordenesproduccion");
  curOCS.select("codorden = '" + codOrden + "'");
  if (!curOCS.first())
    return false;
  curOCS.setModeAccess(curOCS.Edit);
  curOCS.refreshBuffer();
  curOCS.setValueBuffer("totallotes", totalFilas);
  curOCS.setValueBuffer("planificacion", planificacion);
  if (!curOCS.commitBuffer())
    return false;

  if (!qry.first())
    return false;

  do {
    if (!formRecordpr_ordenescorte.iface.pub_activarProcesoLote(qry.value("cortes.codlote"), qry.value("procesoscorte.idproceso"), codOrden))
      return false;
  } while (qry.next());

  return true;
}

// function oficial_generarProcesoLote(codLote:String, referencia:String):Boolean
// {
//  var util:FLUtil;
//
//  var idTipoProceso:String = util.sqlSelect("articulos", "idtipoproceso", "referencia = '" + referencia + "'");
//  if (!idTipoProceso) {
//    MessageBox.warning(util.translate("scripts", "Error al obtener el tipo de proceso correspondiente al artículo %1").arg(referencia), MessageBox.Ok, MessageBox.NoButton);
//    return false;
//  }
//  var idProceso = flcolaproc.iface.pub_crearProceso(idTipoProceso, "lotesstock", codLote);
//  if (!idProceso)
//    return false;
//
//  if (!flprodppal.iface.pub_actualizarTareasProceso(idProceso, codLote))
//    return false;
//
//  // Movimiento de stock positivo PTE para la fecha prevista de finalización del proceso.
//  var curProceso:FLSqlCursor = new FLSqlCursor("pr_procesos");
//  curProceso.select("idproceso = " + idProceso);
//  if (!curProceso.first())
//    return false;
//
//  var cantidad:Number = parseFloat(util.sqlSelect("lotesstock", "canlote", "codlote = '" + codLote + "'"));
//  if (!cantidad || isNaN(cantidad))
//    return false;
//  if (!flfactalma.iface.pub_generarMoviStock(curProceso, codLote, cantidad))
//    return false;
//
//  return true;
// }
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
