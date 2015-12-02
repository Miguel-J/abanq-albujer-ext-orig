/***************************************************************************
         pr_ordenescorte.qs  -  description
                             -------------------
    begin                : jue jul 12 2007
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
  function calculateCounter(): String {
    return this.ctx.interna_calculateCounter();
  }
  function validateForm(): Boolean {
    return this.ctx.interna_validateForm();
  }
  function calculateField(fN: String): Number {
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
  var tblArticulos: Object;
  var tbnBuscar: Object;
  var tbnCalcular: Object;
  var tbnSubir: Object;
  var tbnBajar: Object;
  var tbnLanzarOrden: Object;
  var tbnSacarProceso: Object;
  var tbnEditarLote: Object;
  var tbnEstadoAtras: Object;
  var chkConTela: Object;
  var chkCompletos: Object;
  var curLote_: FLSqlCursor;
  var pedidosIncluidos: String;
  var pedidosNoIncluidos: String;

  var CODLOTE: Number;
  var REFERENCIA: Number;
  var TIPOPROCESO: Number;
  var PEDIDO: Number;
  var CLIENTE: Number;
  var TOTAL: Number;
  var FPRODUCCION: Number;
  var FSALIDA: Number;
  var INCLUIR: Number;
  var ENSTOCK: Number;
  var IDPROCESO: Number;
  var tareaMemo: Array;
  var loteMemo: Array;
  var centroMemo: Array;
  var colorLote: Array;
  var iColorLote: Number;

  var estado_: String;

  function oficial(context)
  {
    interna(context);
  }
  function buscar()
  {
    this.ctx.oficial_buscar();
  }
  function tblArticulos_doubleClicked(fila: Number, col: Number)
  {
    this.ctx.oficial_tblArticulos_doubleClicked(fila, col);
  }
  function establecerTablas()
  {
    this.ctx.oficial_establecerTablas();
  }
  //  function sacarLote() {
  //    this.ctx.oficial_sacarLote();
  //  }
  function sacarProceso()
  {
    this.ctx.oficial_sacarProceso();
  }
  function calcular()
  {
    return this.ctx.oficial_calcular();
  }
  function cargarDatos(): Boolean {
    return this.ctx.oficial_cargarDatos();
  }
  //  function cargarTareas(cantidad:String):Boolean {
  //    return this.ctx.oficial_cargarTareas(cantidad);
  //  }
  //  function establecerSecuencias():Boolean {
  //    return this.ctx.oficial_establecerSecuencias();
  //  }
  //  function establecerSecuenciasTarea(iTarea:Number):Boolean {
  //    return this.ctx.oficial_establecerSecuenciasTarea(iTarea);
  //  }
  //  function buscarTarea(idTipoTareaPro:String):Number {
  //    return this.ctx.oficial_buscarTarea(idTipoTareaPro);
  //  }
  //  function buscarLote(codLote:String):Number {
  //    return this.ctx.oficial_buscarLote(codLote);
  //  }
  //  function buscarCentroCoste(codCentro:String):Number {
  //    return this.ctx.oficial_buscarCentroCoste(codCentro);
  //  }
  function mostrarDatosTareas()
  {
    return this.ctx.oficial_mostrarDatosTareas();
  }
  function mostrarDatosCentros()
  {
    return this.ctx.oficial_mostrarDatosCentros();
  }
  //  function nuevaTarea():Array {
  //    return this.ctx.oficial_nuevaTarea();
  //  }
  //  function nuevoCentroCoste():Array {
  //    return this.ctx.oficial_nuevoCentroCoste();
  //  }
  //  function aplicarAlgoritmo(algoritmo:String):Boolean {
  //    return this.ctx.oficial_aplicarAlgoritmo(algoritmo);
  //  }
  //  function aplicarAlgoritmoFIFO():Boolean {
  //    return this.ctx.oficial_aplicarAlgoritmoFIFO();
  //  }
  //  function asignarTareaFIFO(iTarea:Number):Boolean {
  //    return this.ctx.oficial_asignarTareaFIFO(iTarea);
  //  }
  //  function tareasFinales(codLote:String):Array {
  //    return this.ctx.oficial_tareasFinales(codLote);
  //  }
  //  function establecerSecuencia(iTareaInicial, iTareaFinal):Boolean {
  //    return this.ctx.oficial_establecerSecuencia(iTareaInicial, iTareaFinal);
  //  }
  //  function asignarCentroCosteTarea(iTarea:Number):Boolean {
  //    return this.ctx.oficial_asignarCentroCosteTarea(iTarea);
  //  }
  //  function iniciarCentrosCoste():Boolean {
  //    return this.ctx.oficial_iniciarCentrosCoste();
  //  }
  //  function convetirTiempoMS(tiempo:Number, codCentro:String):Number {
  //    return this.ctx.oficial_convetirTiempoMS(tiempo, codCentro);
  //  }
  //  function sumarTiempo(fecha:Date, tiempo:Number, codCentro:String):Number {
  //    return this.ctx.oficial_sumarTiempo(fecha, tiempo, codCentro);
  //  }
  //  function compararFechas(fecha1:Date, fecha2:Date):Number {
  //    return this.ctx.oficial_compararFechas(fecha1, fecha2);
  //  }
  //  function datosTarea(idTipoTareaPro:String):String {
  //    return this.ctx.oficial_datosTarea(idTipoTareaPro);
  //  }
  //  function tareasCentroCoste(codCentro:String):Array {
  //    return this.ctx.oficial_tareasCentroCoste(codCentro);
  //  }
  //  function fechaMinimaTarea(iTarea:Number):Date {
  //    return this.ctx.oficial_fechaMinimaTarea(iTarea);
  //  }
  //  function buscarFechaMinimaTarea():Date {
  //    return this.ctx.oficial_buscarFechaMinimaTarea();
  //  }
  //  function buscarFechaMaximaTarea():Date {
  //    return this.ctx.oficial_buscarFechaMaximaTarea();
  //  }
  function htmlCentroCoste(codCentro: String, minFecha: Date, maxFecha: Date): String {
    return this.ctx.oficial_htmlCentroCoste(codCentro, minFecha, maxFecha);
  }
  function lanzarOrdenClicked()
  {
    return this.ctx.oficial_lanzarOrdenClicked();
  }
  function lanzarOrden(): Boolean {
    return this.ctx.oficial_lanzarOrden();
  }
  function actualizarTareasProceso(idProceso: String): Boolean {
    return this.ctx.oficial_actualizarTareasProceso(idProceso);
  }
  function establecerEstadoBotones(estado: String)
  {
    return this.ctx.oficial_establecerEstadoBotones(estado);
  }
  //  function limpiarMemoria() {
  //    return this.ctx.oficial_limpiarMemoria();
  //  }
  //  function buscarSiguienteTiempoFin(fecha:Date):Date {
  //    return this.ctx.oficial_buscarSiguienteTiempoFin(fecha);
  //  }
  //  function buscarSiguienteTiempoInicio(fecha:Date):Date {
  //    return this.ctx.oficial_buscarSiguienteTiempoInicio(fecha);
  //  }
  function tbnEditarLote_clicked()
  {
    this.ctx.oficial_tbnEditarLote_clicked();
  }
  function tbnEstadoAtras_clicked()
  {
    this.ctx.oficial_tbnEstadoAtras_clicked();
  }
  function hayArticulosSinStock(): Boolean {
    return this.ctx.oficial_hayArticulosSinStock();
  }
  //  function generarProcesoLote(codLote:String, referencia:String):Boolean {
  //    return this.ctx.oficial_generarProcesoLote(codLote, referencia);
  //  }
  function hayTelaPedido(codPedido: String): Boolean {
    return this.ctx.oficial_hayTelaPedido(codPedido);
  }
  function habilitarPestanas()
  {
    return this.ctx.oficial_habilitarPestanas();
  }
  function activarProcesoLote(codLote: String, idProceso: String, codOrden: String): Boolean {
    return this.ctx.oficial_activarProcesoLote(codLote, idProceso, codOrden);
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
  function pub_activarProcesoLote(codLote: String, idProceso: String, codOrden: String): Boolean {
    return this.activarProcesoLote(codLote, idProceso, codOrden);
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
  //  this.child("tbnCambiarUP").close();
  this.iface.tblArticulos = this.child("tblArticulos");

  this.iface.tbnBuscar = this.child("tbnBuscar");
  this.iface.tbnCalcular = this.child("tbnCalcular");
  this.iface.tbnSubir = this.child("tbnSubir");
  this.iface.tbnBajar = this.child("tbnBajar");
  this.iface.tbnLanzarOrden = this.child("tbnLanzarOrden");
  this.iface.tbnSacarProceso = this.child("tbnSacarProceso");
  this.iface.tbnEditarLote = this.child("tbnEditarLote");
  this.iface.tbnEstadoAtras = this.child("tbnEstadoAtras");
  this.iface.chkConTela = this.child("chkConTela");
  this.iface.chkCompletos = this.child("chkCompletos");

  this.iface.chkConTela.checked = false;
  this.iface.chkCompletos.checked = false

                                    this.child("tdbProcesos").setReadOnly(true);
  this.iface.establecerTablas()

  connect(this.iface.tbnBuscar, "clicked()", this, "iface.buscar");
  connect(this.iface.tbnCalcular, "clicked()", this, "iface.calcular");
  connect(this.iface.tbnLanzarOrden, "clicked()", this, "iface.lanzarOrdenClicked");
  connect(this.iface.tbnSacarProceso, "clicked()", this, "iface.sacarProceso");
  connect(this.iface.tblArticulos, "doubleClicked(int, int)", this, "iface.tblArticulos_doubleClicked");
  connect(this.iface.tbnEditarLote, "clicked()", this, "iface.tbnEditarLote_clicked");
  connect(this.iface.tbnEstadoAtras, "clicked()", this, "iface.tbnEstadoAtras_clicked");

  this.iface.tbnSubir.close();
  this.iface.tbnBajar.close();
  this.child("fdbCodFamilia").close();
  this.child("fdbDesFamilia").close();
  this.child("fdbReferencia").setFilter("codfamilia = 'CORT'");

  /** \C
  La búsqueda de unidades puede realizarse por cliente o por ruta de reparto
  \end
  connect(this.iface.tbnBuscarCliente, "clicked()", this, "iface.tbnBuscarCliente_clicked");
  connect(this.iface.tbnCambiarUP, "clicked()", this, "iface.tbnCambiarUP_clicked");
  */
  var cursor: FLSqlCursor = this.cursor();

  if (cursor.modeAccess() == cursor.Insert) {
    /** \C
    El valor por defecto de la fecha de servicio será la fecha actual. Se buscarán los pedidos cuya fecha de producción sea anterior a la fecha de servicio.
    \end
    var fechaActual:Date = new Date();
    this.child("dedFechaProduccion").date = fechaActual;
    */
    this.child("fdbEstado").setValue("PTE");
    this.iface.habilitarPestanas()

    //    this.child("pushButtonAccept").enabled = false;
    //    this.child("pushButtonAcceptContinue").close();
    cursor.setValueBuffer("tipoorden", "C");
  } else {
    /** \C
    Una vez aceptada la órden de producción, ésta no podrá ser modificada
    \end */
    this.iface.habilitarPestanas()
    //    this.child("tbwOrdenes").setTabEnabled("buscar", false);
    //    this.child("tbwOrdenes").currentPage = 1;
  }

  this.iface.colorLote = ["#0000FF", "#FF0000", "#00FF00"];
  this.iface.iColorLote = 0;

  this.child("fdbReferencia").setFilter("codfamilia = 'CORT'");

  this.iface.establecerEstadoBotones("buscar");
  this.iface.curLote_ = new FLSqlCursor("lotesstock");

  connect(this.iface.curLote_, "bufferCommited()", this, "iface.buscar");
  //  connect (cursor, "bufferChanged(QString)", this, "iface.bufferChanged");
  // //   this.iface.bufferChanged("codfamilia");
}

function interna_calculateCounter(): String {
  var util: FLUtil = new FLUtil();
  var cod: String = "OC00000001";
  var codUltima: String = util.sqlSelect("pr_ordenesproduccion", "codorden", "codorden LIKE 'OC%' ORDER BY codorden DESC");
  if (codUltima)
  {
    var numUltima: Number = parseFloat(codUltima.right(8));
    cod = "OC" + flfactppal.iface.pub_cerosIzquierda((++numUltima).toString(), 8);
  }

  return cod;
}

function interna_validateForm(): Boolean {

  /** \C El número de totallotes incluidas en la orden de producto debe ser superior a 0
  \end */
  this.child("fdbTotalLotes").setValue(this.iface.calculateField("totallotes"));
  return true;

  var util: FLUtil = new FLUtil;
  var totalFilas: Number = this.iface.tblArticulos.numRows();
  var cursor: FLSqlCursor = this.cursor();

  if (cursor.modeAccess() != cursor.Insert)
    return true;

  if (totalFilas == 0 || parseFloat(cursor.valueBuffer("totallotes")) == 0)
  {
    MessageBox.warning(util.translate("scripts", "No hay totallotes seleccionadas"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return false;
  }

  /** \C
  Asocia las unidades de producto incluidas en la orden a la misma, cambiando su estado a EN PRODUCCION. Para cada unidad de producto se inicia un proceso de producción
  \end */

  //  util.createProgressDialog(util.translate("scripts", "Generando procesos de producción"), totalFilas);
  //  util.setProgress(1);
  //
  //  var idOrden:String = cursor.valueBuffer("idorden");
  //  cursor.commitBuffer();
  //  cursor.select("idorden = '" + idOrden + "'");
  //  cursor.first();
  //  cursor.setModeAccess(cursor.Edit);
  //  cursor.refreshBuffer();
  //
  //  for (var fila:Number = 0; fila < totalFilas; fila++) {
  //    var valor:String = this.iface.tblArticulos.text(fila, 8);
  //    var idUP:String = this.iface.tblArticulos.text(fila, 2);
  //    var idTipoProceso:String;
  //    if (valor == "Sí") {
  //      if (!util.sqlUpdate("pr_unidadesproducto", "idordenproduccion", idOrden,  "idunidad = '" + idUP + "'")) {
  //        util.destroyProgressDialog();
  //        return false;
  //      }
  //      idTipoProceso = util.sqlSelect("modulos m INNER JOIN pr_unidadesproducto up ON m.idmodulo = up.idmodulo", "m.idtipoproceso", "up.idunidad = '" + idUP + "'", "modulos,pr_unidadesproducto");
  //      if (!idTipoProceso)
  //        idTipoProceso = "PROD";
  //      if (!flprodproc.iface.pub_crearProceso(idTipoProceso, "pr_ordenesproduccion", idOrden)) {
  //        util.destroyProgressDialog();
  //        return false;
  //      }
  //    }
  //    util.setProgress(fila + 1);
  //  }
  //
  //  util.setProgress(totalFilas);
  //  util.destroyProgressDialog();
  return true;
}

function interna_calculateField(fN: String): Number {
  var res: Number;
  switch (fN)
  {
    case "totallotes": {
      /*U Número de totallotes a incluir en la orden de producción.
      \end */
      var cursor: FLSqlCursor = this.cursor();

      if (cursor.modeAccess() == cursor.Insert) {
        res = 0;
        var totalFilas: Number = this.iface.tblArticulos.numRows();
        for (var fila: Number = 0; fila < totalFilas; fila++) {
          if (this.iface.tblArticulos.text(fila, 8) == "Sí") {
            res++;
          }
        }
      } else {
        var util: FLUtil = new FLUtil;
        res = parseInt(util.sqlSelect("pr_procesos", "count(*)", "codordenproduccion='" + cursor.valueBuffer("codorden") + "'"));
      }
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
// function oficial_cargarTareas(cantidad:String):Boolean
// {
//  var util:FLUtil = new FLUtil;
//
//  var idTipoProceso:String = "CORTE";
//  if (!idTipoProceso) {
//    MessageBox.warning(util.translate("scripts", "Error al obtener el tipo de proceso"), MessageBox.Ok, MessageBox.NoButton);
//    return false;
//  }
//
//  var qryTareas:FLSqlQuery = new FLSqlQuery();
//  with (qryTareas) {
//    setTablesList("pr_tipostareapro");
//    setSelect("idtipotareapro");
//    setFrom("pr_tipostareapro");
//    setWhere("idtipoproceso = '" + idTipoProceso + "'");
//    setForwardOnly(true);
//  }
//  if (!qryTareas.exec())
//    return false;
//
//  var indice:Number;
//  var idTipoTareaPro:String;
//  while (qryTareas.next()) {
//    idTipoTareaPro = qryTareas.value("idtipotareapro");
//    indice = this.iface.tareaMemo.length;
//    this.iface.tareaMemo[indice] = flprodppal.iface.pub_nuevaTarea();
//    this.iface.tareaMemo[indice]["idtipotareapro"] = idTipoTareaPro;
//    this.iface.tareaMemo[indice]["cantidad"] = cantidad;
//  }
//  return true;
// }

/** \C
Muestra los cortes que cumplen los criterios de búsqueda
\end */
function oficial_buscar()
{
  var util: FLUtil = new FLUtil();
  var cursor: FLSqlCursor = this.cursor();

  var totalFilas: Number = this.iface.tblArticulos.numRows();
  var referencia: String = cursor.valueBuffer("referencia");
  var codRuta: String = cursor.valueBuffer("codruta");
  var fechaDesde: Date;
  var fechaHasta: Date;
  var criteriosBusqueda: String = "";
  this.iface.pedidosIncluidos = "";
  this.iface.pedidosNoIncluidos = "";

  if (!cursor.isNull("fechadesde")) {
    fechaDesde = cursor.valueBuffer("fechadesde");
    criteriosBusqueda += " AND ls.fechafabricacion >= '" + fechaDesde + "'";
  } else {
    fechaDesde = false;
  }

  if (!cursor.isNull("fechahasta")) {
    fechaHasta = cursor.valueBuffer("fechahasta");
    criteriosBusqueda += " AND ls.fechafabricacion <= '" + fechaHasta + "'";
  } else {
    fechaHasta = false;
  }

  criteriosBusqueda +=  " AND a.codfamilia = 'CORT'";
  if (referencia && referencia != "")
    criteriosBusqueda += " AND ls.referencia = '" + referencia + "'";
  if (codRuta && codRuta != "")
    criteriosBusqueda += " AND dirclientes.codruta = '" + codRuta + "'";

  var qryProcesos: FLSqlQuery = new FLSqlQuery();
  with(qryProcesos) {
    setTablesList("lotesstock,articulos,pr_procesos");
    setSelect("ls.codlote, ls.referencia, ls.canlote, ls.fechafabricacion,p.idproceso,p.idtipoproceso,pc.codigo,pc.codcliente,pc.nombrecliente");
    setFrom("lotesstock ls INNER JOIN articulos a ON a.referencia = ls.referencia INNER JOIN pr_procesos p ON ls.codlote = p.idobjeto LEFT OUTER JOIN lineaspedidoscli lpc ON P.idlineapedidocli = lpc.idlinea INNER JOIN pedidoscli pc ON lpc.idpedido = pc.idpedido INNER JOIN dirclientes ON pc.coddir = dirclientes.id");
    setWhere("p.estado = 'OFF'" + criteriosBusqueda);
  }

  if (!qryProcesos.exec())
    return;

  debug(qryProcesos.sql());

  if (qryProcesos.size() == 0) {
    MessageBox.information(util.translate("scripts", "No hay procesos de corte que cumplan los criterios establecidos"), MessageBox.Ok, MessageBox.NoButton);
    return;
  }

  var fechaMinima: Date = "";
  var fechaFabricacion: String = "";
  var fechaMinMov: String = "";
  var fechaMinComp: String = "";
  var codPedido: String = "";
  var nombreCliente: String = "";
  var idPedidoMov: Number;
  var idPedidoComp: Number;
  var datosPedidoComp: Array;
  var idTipoProceso: String;

  while (qryProcesos.next()) {
    idTipoProceso = qryProcesos.value("p.idtipoproceso");
    nombreCliente = qryProcesos.value("pc.nombrecliente");
    codPedido = qryProcesos.value("pc.codigo");

    //    datosPedidoComp = flprodppal.iface.pub_buscarPedidoFechaMinima(qryProcesos.value("ls.codlote"), criteriosBusqueda);

    /*
        if (criteriosBusqueda != "")
          if (!datosPedidoComp)
            continue;
    */
    //    fechaMinima = "";
    //    codPedido = "";
    //    nombreCliente = "";
    //
    //    if (datosPedidoComp) {
    //      fechaMinima = datosPedidoComp["fecha"];
    //      codPedido = datosPedidoComp["codigo"];
    //      nombreCliente = datosPedidoComp["nombreCliente"];
    //    }

    var qryComponentes: FLSqlQuery = new FLSqlQuery();
    with(qryComponentes) {
      setTablesList("movistock,pr_tipostareapro");
      setSelect("ms.idstock, ms.fechaprev, ms.codlote,ttp.idtipoproceso");
      setFrom("movistock ms INNER JOIN pr_tipostareapro ttp ON ms.idtipotareapro = ttp.idtipotareapro");
      setWhere("codloteprod = '" + qryProcesos.value("ls.codlote") + "' AND cantidad < 0 AND ttp.idtipoproceso = '" + idTipoProceso + "'");
      setForwardOnly(true);
    }
    if (!qryComponentes.exec())
      return;

    var arrayEvolStock: Array;
    var idStock: Number;
    var hoy: Date = new Date();
    var indice: Number;
    var enStock: String = util.translate("scripts", "Sí");
    var fechaConsumo: String;
    var codLote: String;

    while (qryComponentes.next()) {
      codLote = qryComponentes.value("ms.codlote");
      if (codLote && codLote != "") {
        if (util.sqlSelect("lotesstock", "estado", "codlote = '" + codLote + "'") == "TERMINADO") {
          continue;
        } else {
          enStock = util.translate("scripts", "No");
          break;
        }
      }

      arrayEvolStock = flfactalma.iface.pub_datosEvolStock(qryComponentes.value("ms.idstock"), hoy.toString());
      if (qryComponentes.value("ms.fechaprev")) {
        fechaConsumo = qryComponentes.value("ms.fechaprev");
      } else {
        fechaConsumo = hoy.toString();
      }

      indice = flfactalma.iface.pub_buscarIndiceAES(fechaConsumo, arrayEvolStock);

      if (indice >= 0) {
        if (arrayEvolStock[indice]["NN"] > 0) {
          enStock = util.translate("scripts", "No");
          break;
        }
      } else {
        enStock = util.translate("scripts", "No");
        break;
      }
    }
    if (this.iface.chkCompletos.checked) {
      if (this.iface.pedidosNoIncluidos.find("'" + codPedido + "'") != -1)
        continue;
      if (this.iface.pedidosIncluidos.find("'" + codPedido + "'") == -1) {
        if (this.iface.hayTelaPedido(codPedido)) {
          if (this.iface.pedidosIncluidos != "")
            this.iface.pedidosIncluidos += ", "
                                           this.iface.pedidosIncluidos += "'" + codPedido + "'";
        } else {
          if (this.iface.pedidosNoIncluidos != "")
            this.iface.pedidosNoIncluidos += ", "
                                             this.iface.pedidosNoIncluidos += "'" + codPedido + "'";
          continue;
        }
      }
    } else if (enStock == "No" && this.iface.chkConTela.checked)
      continue;
    filaActual = this.iface.tblArticulos.numRows();

    fechaFabricacion = qryProcesos.value("ls.fechafabricacion");
    this.iface.tblArticulos.insertRows(filaActual);
    this.iface.tblArticulos.setText(filaActual, this.iface.CODLOTE, qryProcesos.value("ls.codlote"));
    this.iface.tblArticulos.setText(filaActual, this.iface.REFERENCIA, qryProcesos.value("ls.referencia"));
    this.iface.tblArticulos.setText(filaActual, this.iface.TIPOPROCESO, idTipoProceso);
    this.iface.tblArticulos.setText(filaActual, this.iface.PEDIDO, codPedido);
    this.iface.tblArticulos.setText(filaActual, this.iface.CLIENTE, nombreCliente);
    this.iface.tblArticulos.setText(filaActual, this.iface.TOTAL, qryProcesos.value("ls.canlote"));
    this.iface.tblArticulos.setText(filaActual, this.iface.FPRODUCCION, util.dateAMDtoDMA(fechaFabricacion));
    this.iface.tblArticulos.setText(filaActual, this.iface.FSALIDA, util.dateAMDtoDMA(fechaMinima));
    this.iface.tblArticulos.setText(filaActual, this.iface.ENSTOCK, enStock);
    this.iface.tblArticulos.setText(filaActual, this.iface.INCLUIR, "Sí");
    this.iface.tblArticulos.setText(filaActual, this.iface.IDPROCESO, qryProcesos.value("p.idproceso"));
  }

  this.child("fdbTotalLotes").setValue(this.iface.calculateField("totallotes"));

  if (this.iface.tblArticulos.numRows() > 0) {
    this.iface.establecerEstadoBotones("calcular");
  } else {
    MessageBox.information(util.translate("scripts", "No hay procesos de corte los criterios establecidos"), MessageBox.Ok, MessageBox.NoButton);
  }
}

function oficial_hayTelaPedido(codPedido: String): Boolean {
  var qryLotes: FLSqlQuery = new FLSqlQuery();
  with(qryLotes)
  {
    setTablesList("movistock,pedidoscli,lineaspedidoscli");
    setSelect("ls.codlote");
    setFrom("pedidoscli p INNER JOIN lineaspedidoscli lp ON p.idpedido = lp.idpedido INNER JOIN lotesstock ls ON lp.idlinea = ls.idlineapc INNER JOIN pr_procesos ON lp.idlinea = pr_procesos.idlineapedidocli INNER JOIN articulos a ON a.referencia = ls.referencia");
    setWhere("ls.estado = 'PTE' AND pr_procesos.estado = 'OFF' AND a.fabricado AND p.codigo = '" + codPedido + "' AND a.codfamilia = 'CORT'");
  }

  if (!qryLotes.exec())
    return false;

  if (qryLotes.size() == 0)
    return false;

  var hoy: Date = new Date();
  var arrayEvolStock: Array;
  var indice: Number;


  while (qryLotes.next())
  {
    var qryComponentes: FLSqlQuery = new FLSqlQuery();
    with(qryComponentes) {
      setTablesList("movistock");
      setSelect("idstock, fechaprev");
      setFrom("movistock");
      setWhere("codloteprod = '" + qryLotes.value("corte.codlote") + "' AND cantidad < 0");
      setForwardOnly(true);
    }
    if (!qryComponentes.exec())
      return false;

    if (qryComponentes.size() == 0)
      return false;

    while (qryComponentes.next()) {
      arrayEvolStock = flfactalma.iface.pub_datosEvolStock(qryComponentes.value("idstock"), hoy.toString());
      indice = flfactalma.iface.pub_buscarIndiceAES(qryComponentes.value("fechaprev"), arrayEvolStock);

      if (indice >= 0) {
        if (arrayEvolStock[indice]["NN"] > 0) {
          return false;
        }
      } else {
        return false;
      }
    }
  }

  return true;
}

/** \D
Pasa de Sí a No o viceversa el valor de la columna 'Cargar' de la tabla de unidades
@param  fila: Fila sobre la que se ha hecho doble clic
@param  col: Columna sobre la que se ha hecho doble clic
\end */
function oficial_tblArticulos_doubleClicked(fila: Number, col: Number)
{
  var idUP: String;
  if (col == this.iface.INCLUIR) {
    if (this.iface.tblArticulos.text(fila, this.iface.INCLUIR) == "Sí") {
      this.iface.tblArticulos.setText(fila, this.iface.INCLUIR, "No");
    } else if (this.iface.tblArticulos.text(fila, this.iface.INCLUIR) == "No") {
      this.iface.tblArticulos.setText(fila, this.iface.INCLUIR, "Sí");
    }
    this.child("fdbTotalLotes").setValue(this.iface.calculateField("totallotes"));
    this.iface.establecerEstadoBotones("calcular");
  }
}

function oficial_establecerTablas()
{
  this.iface.CODLOTE = 0;
  this.iface.REFERENCIA = 1;
  this.iface.TIPOPROCESO = 2;
  this.iface.PEDIDO = 3;
  this.iface.CLIENTE = 4;
  this.iface.TOTAL = 5;
  this.iface.FPRODUCCION = 6;
  this.iface.FSALIDA = 7;
  this.iface.ENSTOCK = 8;
  this.iface.INCLUIR = 9;
  this.iface.IDPROCESO = 10;

  this.iface.tblArticulos.setNumCols(11);
  this.iface.tblArticulos.setColumnWidth(this.iface.CODLOTE, 100);
  this.iface.tblArticulos.setColumnWidth(this.iface.REFERENCIA, 120);
  this.iface.tblArticulos.setColumnWidth(this.iface.TIPOPROCESO, 100);
  this.iface.tblArticulos.setColumnWidth(this.iface.PEDIDO, 120);
  this.iface.tblArticulos.setColumnWidth(this.iface.CLIENTE, 200);
  this.iface.tblArticulos.setColumnWidth(this.iface.TOTAL, 80);
  this.iface.tblArticulos.setColumnWidth(this.iface.FSALIDA, 90);
  this.iface.tblArticulos.setColumnWidth(this.iface.FPRODUCCION, 90);
  this.iface.tblArticulos.setColumnWidth(this.iface.ENSTOCK, 70);
  this.iface.tblArticulos.setColumnWidth(this.iface.INCLUIR, 70);
  this.iface.tblArticulos.setColumnWidth(this.iface.IDPROCESO, 70);
  //this.iface.tblArticulos.hideColumn(this.iface.IDPROCESO);

  this.iface.tblArticulos.setColumnLabels("/", "Lote/Referencia/Proceso/Pedido/Cliente/Total/F.Producción/F.Salida/En Stock/Incluir/Proceso");
}

// function oficial_sacarLote()
// {
//  var util:FLUtil = new FLUtil();
//  var cursor:FLSqlCursor = this.child("tdbProcesos").cursor();
//  var codLote:String = cursor.valueBuffer("codLote");
//  var codOrden:String = this.cursor().valueBuffer("codorden");
//
//  var res:Number = MessageBox.warning(util.translate("scripts", "¿Desea sacar el corte seleccionado de la orden?"), MessageBox.Yes, MessageBox.No);
//  if (res != MessageBox.Yes)
//    return false;
//
//  var curOrden:FLSqlCursor = new FLSqlCursor("pr_ordenesproduccion");
//  curOrden.transaction(false);
//  try {
//    if (formpr_ordenescorte.iface.pub_sacarLS(codLote)) {
//      curOrden.commit();
//    } else {
//      curOrden.rollback();
//      return false;
//    }
//  } catch (e) {
//    curOrden.rollback();
//    MessageBox.critical(util.translate("scripts", "Error al sacar el corte de la orden: ") + e, MessageBox.Ok, MessageBox.NoButton);
//    return false;
//  }
//
//  cursor.refresh();
//  this.child("tdbProcesos").refresh();
// }
/** \D Saca el lote de producto seleccionado de la orden. El lote de producto debe estar en estado PTE
*/
function oficial_sacarProceso()
{
  var util: FLUtil = new FLUtil();

  var curProceso: FLSqlCursor = this.child("tdbProcesos").cursor();
  var idProceso: String = curProceso.valueBuffer("idproceso");

  var res: Number = MessageBox.warning(util.translate("scripts", "¿Desea sacar el proceso %1 de la orden?").arg(idProceso), MessageBox.Yes, MessageBox.No);
  if (res != MessageBox.Yes) {
    return;
  }

  if (!formpr_ordenesproduccion.iface.pub_sacarProceso(idProceso)) {
    return false;
  }

  this.child("tdbProcesos").refresh();
  this.iface.habilitarPestanas();
  //  curProceso.refresh();
  //  if (!curProceso.size()) {
  //    this.child("tbwOrdenes").setTabEnabled("procesos", false);
  //    this.child("tbwOrdenes").setTabEnabled("buscar", true);
  //    this.child("tbwOrdenes").currentPage = 0;
  //  }
}

function oficial_hayArticulosSinStock(): Boolean {
  var util: FLUtil;

  for (var fila: Number = 0; fila < this.iface.tblArticulos.numRows(); fila++)
  {
    if (this.iface.tblArticulos.text(fila, this.iface.INCLUIR) == "Sí") {
      if (this.iface.tblArticulos.text(fila, this.iface.ENSTOCK) == "No") {
        var res: Number = MessageBox.warning(util.translate("scripts", "Hay lotes para los que no hay stock de componentes suficiente. ¿Desea continuar?"), MessageBox.Yes, MessageBox.No);
        if (res != MessageBox.Yes)
          return false;
        else
          return true;
      }

    }
  }
  return true;
}

function oficial_calcular()
{
  if (!this.iface.hayArticulosSinStock())
    return false;

  flprodppal.iface.pub_limpiarMemoria();

  if (!this.iface.cargarDatos())
    return false;

  if (!flprodppal.iface.pub_aplicarAlgoritmo("FIFO"))
    return false;

  this.child("fdbPlanificacion").setValue(flprodppal.iface.htmlPlanificacion());
  //  this.iface.mostrarDatosTareas();
  /*
  if (!this.iface.mostrarCalculo())
    return false;
  */
  this.iface.establecerEstadoBotones("lanzar");
  return true;
}

// function oficial_aplicarAlgoritmo(algoritmo:String):Boolean
// {
//  switch (algoritmo) {
//    case "FIFO": {
//      if (!this.iface.aplicarAlgoritmoFIFO())
//        return false;
//      break;
//    }
//  }
//  return true;
// }
//
// function oficial_aplicarAlgoritmoFIFO():Boolean
// {
//  for (var iTarea:Number = 0; iTarea < this.iface.tareaMemo.length; iTarea++) {debug("FOR TAREA");
//    if (!this.iface.asignarTareaFIFO(iTarea))
//      return false;
//  }
//  return true;
// }

// function oficial_asignarTareaFIFO(iTarea:Number):Boolean
// {
//  if (this.iface.tareaMemo[iTarea]["asignada"])
//    return true;
//
//  var totalPredecesoras:Number = this.iface.tareaMemo[iTarea]["predecesora"].length;
//  for (var iPredecesora:Number = 0; iPredecesora < totalPredecesoras; iPredecesora++) {
//    debug("FOR PREDECESORA");if (!this.iface.asignarTareaFIFO(this.iface.tareaMemo[iTarea]["predecesora"][iPredecesora]))
//      return false;
//  }
//  if (!this.iface.asignarCentroCosteTarea(iTarea))
//    return false;
//
//  return true;
// }

/** \D Obtiene la fecha mínima de comienzo de una tarea en función de la máxima fecha de finalización de sus tareas predecesoras
@param iTarea: Indice de la tarea
@return fecha mínima de inicio
|end */
// function oficial_fechaMinimaTarea(iTarea:Number):Date
// {
//  var fechaMin:Date = false;
//  var totalPredecesoras:Number = this.iface.tareaMemo[iTarea]["predecesora"].length;
//  var iTP:Number;
//  for (var iPredecesora:Number = 0; iPredecesora < totalPredecesoras; iPredecesora++) {
//    iTP = this.iface.tareaMemo[iTarea]["predecesora"][iPredecesora];
//    if (!fechaMin) {
//      fechaMin = this.iface.tareaMemo[iTP]["fechafin"];
//    } else {
//      if (this.iface.compararFechas(this.iface.tareaMemo[iTP]["fechafin"], fechaMin) == 1) {
//        fechaMin = this.iface.tareaMemo[iTP]["fechafin"];
//      }
//    }
//  }
//  return fechaMin;
// }
// function oficial_asignarCentroCosteTarea(iTarea:Number):Boolean
// {
//  var util:FLUtil = new FLUtil;
//
//  var fechaMinTarea:Date = this.iface.fechaMinimaTarea(iTarea);
//
//  var idTipoTareaPro:String = this.iface.tareaMemo[iTarea]["idtipotareapro"];
//  var qryCentros:FLSqlQuery = new FLSqlQuery;
//  with (qryCentros) {
//    setTablesList("pr_costestarea,pr_centroscoste");
//    setSelect("cc.codcentro, ct.costeinicial, ct.costeunidad, ct.costegrupo");
//    setFrom("pr_costestarea ct INNER JOIN pr_centroscoste cc ON ct.codtipocentro = cc.codtipocentro");
//    setWhere("ct.idtipotareapro = " + idTipoTareaPro);
//    setForwardOnly(true);
//  }
//  if (!qryCentros.exec()) {
//    return false;
//  }
//
//  var minFechaInicio:Date = false;
//  var minFechaFin:Date = false;
//  var minICentro:Number = -1;
//  var minTiempo:Number;
//
//  var fechaFin:Date;
//  var fechaInicio:Date;
//  var minCentro:String;
//  var iCentro:Number;
//  var dia:Date;
//  var tiempo:Number;
//  var costeFijo:Number;
//  var costeUnidad:Number;
//  var codCentro:String;
//
//  while (qryCentros.next()) {
//    costeFijo = parseFloat(qryCentros.value("ct.costeinicial"));
//    if (!costeFijo || isNaN(costeFijo))
//      costeFijo = 0;
//    costeUnidad = parseFloat(qryCentros.value("ct.costeunidad"));
//    if (!costeUnidad || isNaN(costeUnidad))
//      costeUnidad = 0;
//
//    costeGrupo = parseFloat(qryCentros.value("ct.costegrupo"));
//    if (!costeGrupo || isNaN(costeGrupo))
//      costeGrupo = 0;
//
//    codCentro = qryCentros.value("cc.codcentro");
//    iCentro = this.iface.buscarCentroCoste(codCentro);
//    if (iCentro < 0) {
//      MessageBox.warning(util.translate("scripts", "Error al buscar los datos del centro de coste %1").arg(codCentro), MessageBox.Ok, MessageBox.NoButton);
//      return false;
//    }
//
//    var cantidad:Number = 0;
//    var nGrupos:Number = 0;
//    var refGrupo:String = "";
//    for (var fila:Number = 0; fila < this.iface.tblArticulos.numRows(); fila++) {
//      if (this.iface.tblArticulos.text(fila, this.iface.INCLUIR) == "Sí") {
//        cantidad += parseFloat(this.iface.tblArticulos.text(fila, this.iface.TOTAL));
//        if (refGrupo != this.iface.tblArticulos.text(fila, this.iface.REFERENCIA)) {
//          nGrupos += 1;
//          refGrupo = this.iface.tblArticulos.text(fila, this.iface.REFERENCIA);
//        }
//      }
//    }
//
//    tiempo = costeFijo + (costeUnidad * cantidad) + (costeGrupo * nGrupos);
//    tiempo = this.iface.convetirTiempoMS(tiempo, codCentro);
//
//    if (fechaMinTarea && this.iface.compararFechas(fechaMinTarea, this.iface.centroMemo[iCentro]["fechainicio"]) == 1)
//      fechaInicio = fechaMinTarea;
//    else
//      fechaInicio = this.iface.centroMemo[iCentro]["fechainicio"];
//
//    if (!util.sqlSelect("pr_calendario","fecha","1 = 1")) {
//      MessageBox.warning(util.translate("scripts", "Antes de calcular el tiempo de finalización de la tarea debe generar el calendario laboral."), MessageBox.Ok, MessageBox.NoButton);
//      return false;
//    }
//
//    fechaFin = this.iface.sumarTiempo(fechaInicio, tiempo, codCentro);
//    if (minFechaFin && this.iface.compararFechas(minFechaFin, fechaFin) == 2)
//      continue;
//
//    minFechaInicio = fechaInicio;
//    minFechaFin = fechaFin;
//    minCodCentro = codCentro;
//    minTiempo = tiempo;
//    minICentro = iCentro;
//  }
//
//  if (minICentro < 0) {
//    MessageBox.warning(util.translate("scripts", "No se ha podido asignar centro de coste a la tarea:\n%1\nAsociada al lote %2").arg(this.iface.datosTarea(idTipoTareaPro)).arg(codLote), MessageBox.Ok, MessageBox.NoButton);
//    return false;
//  }
//  this.iface.tareaMemo[iTarea]["codcentrocoste"] = minCodCentro;
//  this.iface.tareaMemo[iTarea]["fechainicio"] = minFechaInicio;
//  this.iface.tareaMemo[iTarea]["fechafin"] = minFechaFin;
//
//  this.iface.tareaMemo[iTarea]["duracion"] = minTiempo;
//  this.iface.tareaMemo[iTarea]["asignada"] = true;
//
//  this.iface.centroMemo[minICentro]["fechainicio"] = minFechaFin;
//
//  return true;
// }

/** \D Pasa el tiempo a milisegundos. Función a sobrecargar para calcular los milisegundos en función de la unidad en la que trabaja cada centro de coste. Por defecto, se convierte de minutos a milisegundos
@param  tiempo: Tiempo en minutos
@param  codCentro: Código de centro
@return Tiempo en milisegundos
\end */
// function oficial_convetirTiempoMS(tiempo:Number, codCentro:String):Number
// {
//  var resultado:Number;
//  resultado = tiempo * 60000;
//  return resultado;
// }

/** \D Suma el tiempo en milisegundos a una fecha, teniendo en cuena el horario del centro de coste
@param  fechaInicio: Fecha inicial
@param  tiempo: Tiempo en ms
@param  codCentro: Código de centro
@return Fecha final
\end */
// function oficial_sumarTiempo(fecha:Date, tiempo:Number, codCentro:String):Date
// {
//  var tiempoInicio:Number = fecha.getTime(); //Date.parse(fecha);
//
//  var fechaFin:Date = this.iface.buscarSiguienteTiempoFin(fecha);
//  var tiempoFin:Number = fechaFin.getTime();
//
//  var tiempoAux:Number = tiempoFin - tiempoInicio;
//
//  if (tiempoAux >= tiempo) {
//    tiempoFin = tiempoInicio + tiempo;
//    fechaFin = new Date(tiempoFin);
//    return fechaFin;
//  }
//
//  tiempo = tiempo - tiempoAux;
//
//  var fechaInicio:Date = this.iface.buscarSiguienteTiempoInicio(fechaFin);
//  return this.iface.sumarTiempo(fechaInicio,tiempo,codCentro);
//
// //   var fecha:Date = new Date(tiempoFin);
// //   return fecha;
// }

/*unction oficial_buscarSiguienteTiempoFin(fecha):Date
{
  var util:FLUtil;
  var d:Date = new Date( fecha.getYear(), fecha.getMonth(), fecha.getDate());
  var tiempoFinManana:Date = util.sqlSelect("pr_calendario","horasalidamanana","fecha = '" + d + "'");
  tiempoFinManana = tiempoFinManana.setYear(d.getYear());
  tiempoFinManana = tiempoFinManana.setMonth(d.getMonth());
  tiempoFinManana = tiempoFinManana.setDate(d.getDate());

  var comparar:Number = flprodppal.iface.compararHoras(fecha,tiempoFinManana);
  if (comparar == 2){
    return tiempoFinManana;
  }

  var tiempoFinTarde:Date = util.sqlSelect("pr_calendario","horasalidatarde","fecha = '" + d + "'");
  tiempoFinTarde = tiempoFinTarde.setYear(d.getYear());
  tiempoFinTarde = tiempoFinTarde.setMonth(d.getMonth());
  tiempoFinTarde = tiempoFinTarde.setDate(d.getDate());

  comparar = flprodppal.iface.compararHoras(fecha,tiempoFinTarde);
  if (comparar == 2){
    return tiempoFinTarde;
  }

  var fecha2:Date = new Date(fecha.getYear(), fecha.getMonth(), fecha.getDate());

  var qry:FLSqlQuery = new FLSqlQuery();
  qry.setTablesList("pr_calendario");
  qry.setSelect("horasalidamanana,horasalidatarde");
  qry.setFrom("pr_calendario")

  do {
    fecha2 = util.addDays(fecha2,1);
    var fechaAux:Date = new Date(fecha2.getYear(), fecha2.getMonth(), fecha2.getDate());

    qry.setWhere("fecha = '" + fechaAux + "'");

    if (!qry.exec())
      return false;

    if (!qry.first()) {
      MessageBox.warning(util.translate("scripts", "No se ha encontrado un registro para el día " + util.dateAMDtoDMA(fechaAux) + " en el Calendario Laboral"), MessageBox.Ok, MessageBox.NoButton);
      return false;
    }

    fecha2 = qry.value("horasalidamanana");
    fecha2 = fecha2.setYear(fechaAux.getYear());
    fecha2 = fecha2.setMonth(fechaAux.getMonth());
    fecha2 = fecha2.setDate(fechaAux.getDate());

    if (!fecha2) {
      fecha2 = qry.value("horasalidatarde");
      fecha2 = fecha2.setYear(fechaAux.getYear());
      fecha2 = fecha2.setMonth(fechaAux.getMonth());
      fecha2 = fecha2.setDate(fechaAux.getDate());
    }

  } while (!fecha2);

  return fecha2;
}

function oficial_buscarSiguienteTiempoInicio(fecha):Date
{
  var util:FLUtil;
  var d:Date = new Date( fecha.getYear(), fecha.getMonth(), fecha.getDate());
  var tiempoInicioManana:Date = util.sqlSelect("pr_calendario","horaentradamanana","fecha = '" + d + "'");
  tiempoInicioManana = tiempoInicioManana.setYear(d.getYear());
  tiempoInicioManana = tiempoInicioManana.setMonth(d.getMonth());
  tiempoInicioManana = tiempoInicioManana.setDate(d.getDate());

  var comparar:Number = flprodppal.iface.compararHoras(fecha,tiempoInicioManana);
  if (comparar == 2){
    return tiempoInicioManana;
  }

  var tiempoInicioTarde:Date = util.sqlSelect("pr_calendario","horaentradatarde","fecha = '" + d + "'");
  tiempoInicioTarde = tiempoInicioTarde.setYear(d.getYear());
  tiempoInicioTarde = tiempoInicioTarde.setMonth(d.getMonth());
  tiempoInicioTarde = tiempoInicioTarde.setDate(d.getDate());

  comparar = flprodppal.iface.compararHoras(fecha,tiempoInicioTarde);
  if (comparar == 2){
    return tiempoInicioTarde;
  }

  var fecha2:Date = new Date(fecha.getYear(), fecha.getMonth(), fecha.getDate());

  var qry:FLSqlQuery = new FLSqlQuery();
  qry.setTablesList("pr_calendario");
  qry.setSelect("horaentradamanana,horaentradatarde");
  qry.setFrom("pr_calendario")

  do {
    fecha2 = util.addDays(fecha2,1);
    var fechaAux:Date = new Date(fecha2.getYear(), fecha2.getMonth(), fecha2.getDate());

    qry.setWhere("fecha = '" + fechaAux + "'");

    if (!qry.exec())
      return false;

    if (!qry.first()) {
      MessageBox.warning(util.translate("scripts", "No se ha encontrado un registro para el día " + util.dateAMDtoDMA(fechaAux) + " en el Calendario Laboral"), MessageBox.Ok, MessageBox.NoButton);
      return false;
    }

    fecha2 = qry.value("horaentradamanana");
    fecha2 = fecha2.setYear(fechaAux.getYear());
    fecha2 = fecha2.setMonth(fechaAux.getMonth());
    fecha2 = fecha2.setDate(fechaAux.getDate());

    if (!fecha2) {
      fecha2 = qry.value("horaentradatarde");
      fecha2 = fecha2.setYear(fechaAux.getYear());
      fecha2 = fecha2.setMonth(fechaAux.getMonth());
      fecha2 = fecha2.setDate(fechaAux.getDate());
    }

  } while (!fecha2);

  return fecha2;
}*/

/** \D Compara dos fechs
@param  fecha1: Fecha
@param  fecha2: Fecha
@return 0 Si son iguales, 1 si la primera es mayor, 2 si la segunda es mayor
\end */
// function oficial_compararFechas(fecha1:Date, fecha2:Date):Number
// {
//  if (fecha1.getTime() > fecha2.getTime())
//    return 1;
//  else if (fecha2.getTime() > fecha1.getTime())
//    return 2;
//  else
//    return 0;
// }

function oficial_cargarDatos(): Boolean {
  var util: FLUtil = new FLUtil;
  var datosLote: Array = [];
  var seleccionados: Number = 0;
  for (var fila: Number = 0; fila < this.iface.tblArticulos.numRows(); fila++)
  {
    if (this.iface.tblArticulos.text(fila, this.iface.INCLUIR) == "Sí") {
      datosLote["codLote"] = this.iface.tblArticulos.text(fila, this.iface.CODLOTE);
      datosLote["cantidad"] = this.iface.tblArticulos.text(fila, this.iface.TOTAL);
      datosLote["referencia"] = this.iface.tblArticulos.text(fila, this.iface.REFERENCIA);
      datosLote["idProceso"] = this.iface.tblArticulos.text(fila, this.iface.IDPROCESO);
      if (!flprodppal.iface.pub_cargarTareasLote(datosLote))
        return false;
      seleccionados++;
    }
  }
  if (seleccionados == 0)
  {
    MessageBox.warning(util.translate("scripts", "No ha seleccionado ningún proceso"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }

  if (!flprodppal.iface.pub_establecerSecuencias())
    return false;

  if (!flprodppal.iface.pub_iniciarCentrosCoste())
    return false;
  return true;

  //  var cantidad:String = 0;
  //
  //  var nGrupos:Number = 0;
  //  var refGrupo:String = "";
  //  for (var fila:Number = 0; fila < this.iface.tblArticulos.numRows(); fila++) {
  //    if (this.iface.tblArticulos.text(fila, this.iface.INCLUIR) == "Sí")
  //      cantidad += parseFloat(this.iface.tblArticulos.text(fila, this.iface.TOTAL));
  //        if (refGrupo != this.iface.tblArticulos.text(fila, this.iface.REFERENCIA)) {
  //          nGrupos += 1;
  //          refGrupo = this.iface.tblArticulos.text(fila, this.iface.REFERENCIA);
  //        }
  //  }
  //  if (!flprodppal.iface.pub_cargarTareas(cantidad,nGrupos))
  //    return false;
  //
  //  if (!flprodppal.iface.pub_establecerSecuencias())
  //    return false;
  //
  //  if (!flprodppal.iface.pub_iniciarCentrosCoste())
  //    return false;
  //
  //  return true;
}

// function oficial_iniciarCentrosCoste():Boolean
// {
//  var util:FLUtil = new FLUtil;
//
//  var qryCentros:FLSqlQuery = new FLSqlQuery;
//  with (qryCentros) {
//    setTablesList("pr_centroscoste");
//    setSelect("codcentro");
//    setFrom("pr_centroscoste");
//    setWhere("1 = 1");
//    setForwardOnly(true);
//  }
//  if (!qryCentros.exec())
//    return false;
//
//  var iCentro:Number = this.iface.centroMemo.length;
//  var maxFechaPrev:Date;
//  var maxFechaPrevS:String;
//  var maxFecha:String;
//  var hoy:Date;
//  while (qryCentros.next()) {
//    this.iface.centroMemo[iCentro] = this.iface.nuevoCentroCoste();
//    this.iface.centroMemo[iCentro]["codcentro"] = qryCentros.value("codcentro");
//    this.iface.centroMemo[iCentro]["codtipocentro"] = qryCentros.value("codtipocentro");
//    this.iface.centroMemo[iCentro]["idtipotareapro"] = qryCentros.value("idtipotareapro");
//    this.iface.centroMemo[iCentro]["costeinicial"] = qryCentros.value("costeinicial");
//    this.iface.centroMemo[iCentro]["costeunidad"] = qryCentros.value("costeunidad");
//
//    //maxFechaPrev = util.sqlSelect("pr_tareas", "MAX(diafin)", "codcentro = '" + qryCentros.value("codcentro") + "'");
//    maxFechaPrevS = util.sqlSelect("pr_tareas", "MAX(fechafinprev)", "codcentro = '" + qryCentros.value("codcentro") + "'");
//    hoy = new Date;
//    if (maxFechaPrevS) {
//      maxFechaPrev = new Date(Date.parse(maxFechaPrevS));
//      if (util.daysTo(maxFechaPrev, hoy) < 0)
//        this.iface.centroMemo[iCentro]["fechainicio"] = hoy;
//      else
//        this.iface.centroMemo[iCentro]["fechainicio"] = maxFechaPrev;
//    } else {
//      this.iface.centroMemo[iCentro]["fechainicio"] = hoy;
//    }
//    iCentro++;
//  }
//  return true;
// }

// function oficial_establecerSecuencias():Boolean
// {
//  var idTipoTarea:String;
//  var iTarea:Number = 0;
//  var totalTareas:Number = this.iface.tareaMemo.length;
//    while (iTarea < totalTareas) {
//      if (!flprodppal.iface.pub_establecerSecuenciasTarea(iTarea))
//        return false;
//      iTarea++;
//    }
//
//  return true;
// }

// function oficial_establecerSecuenciasTarea(iTarea:Number):Boolean
// {
//  var util:FLUtil = new FLUtil;
//  var qrySucesoras:FLSqlQuery = new FLSqlQuery();
//  var sucesora:Array;
//  var iSucesora:Number;
//  var qryPredecesoras:FLSqlQuery = new FLSqlQuery();
//  var predecesora:Array;
//  var iPredecesora:Number;
//
// //   var codLote:String = this.iface.loteMemo[iLote]["codlote"];
//  var idTipoTareaPro:String = this.iface.tareaMemo[iTarea]["idtipotareapro"];
//
//  with (qrySucesoras) {
//    setTablesList("pr_secuencias");
//    setSelect("tareafin");
//    setFrom("pr_secuencias");
//    setWhere("tareainicio = " + idTipoTareaPro);
//    setForwardOnly(true);
//  }
//  if (!qrySucesoras.exec())
//    return false;
//
//  var iTareaSucesora:Number;
//  while (qrySucesoras.next()) {
//    iTareaSucesora = this.iface.buscarTarea(qrySucesoras.value("tareafin"));
//    if (iTareaSucesora < 0) {
//      MessageBox.warning(util.translate("scripts", "Ha habido un error al buscar la tarea: %1").arg(this.iface.datosTarea(qrySucesoras.value("tareafin"))), MessageBox.Ok, MessageBox.NoButton);
//      return false;
//    }
//    if (!this.iface.establecerSecuencia(iTarea, iTareaSucesora))
//      return false;
//  }
//  return true;
// }

// function oficial_tareasFinales(codLote:String):Array
// {
//  var tareasFinales:Array = [];
//  var totalTareas:Number = this.iface.tareaMemo.length;
//  for (var iTarea:Number = 0; iTarea < totalTareas; iTarea++) {
//    if (this.iface.tareaMemo[iTarea]["codlote"] == codLote && this.iface.tareaMemo[iTarea]["sucesora"].length == 0) {
//      tareasFinales[tareasFinales.length] = iTarea;
//    }
//  }
//  return tareasFinales;
// }

// function oficial_establecerSecuencia(iTareaInicial:Number, iTareaFinal:Number):Boolean
// {
//  var iSucesora:Number = this.iface.tareaMemo[iTareaInicial]["sucesora"].length;
//  this.iface.tareaMemo[iTareaInicial]["sucesora"][iSucesora] = iTareaFinal;
//
//  var iPredecesora:Number = this.iface.tareaMemo[iTareaFinal]["predecesora"].length;
//  this.iface.tareaMemo[iTareaFinal]["predecesora"][iPredecesora] = iTareaInicial;
//
//  return true;
// }

// function oficial_buscarTarea(idTipoTareaPro:String):Number
// {
//  var i:Number;
//  for (i = 0; i < this.iface.tareaMemo.length; i++) {
//    if (this.iface.tareaMemo[i]["idtipotareapro"] == idTipoTareaPro)
//      return i;
//  }
//  return -1;
// }

// function oficial_buscarLote(codLote:String):Number
// {
//  var i:Number;
//  for (i = 0; i < this.iface.loteMemo.length; i++) {
//    if (this.iface.loteMemo[i]["codlote"] == codLote)
//      return i;
//  }
//  return -1;
// }

// function oficial_buscarCentroCoste(codCentro:String):Number
// {
//  var i:Number;
//  for (i = 0; i < this.iface.centroMemo.length; i++) {
//    if (this.iface.centroMemo[i]["codcentro"] == codCentro)
//      return i;
//  }
//  return -1;
// }

function oficial_mostrarDatosTareas()
{
  var util: FLUtil = new FLUtil;

  var idTipoTarea: String;
  var iTarea: Number = 0;
  var iTareaAux: Number = 0;

  var totalTareas: Number = this.iface.tareaMemo.length;
  var texto: String = "";

  while (iTarea < totalTareas) {
    texto += "\n>> TAREA: " + util.sqlSelect("pr_tipostareapro", "idtipotarea", "idtipotareapro = " + this.iface.tareaMemo[iTarea]["idtipotareapro"]) + "\n";
    texto += ">> >> ASIGNADA A: " + this.iface.tareaMemo[iTarea]["codcentrocoste"] + " INICIO: " + this.iface.tareaMemo[iTarea]["fechainicio"] + " FIN " + this.iface.tareaMemo[iTarea]["fechafin"] + " DURACIÓN " + this.iface.tareaMemo[iTarea]["duracion"] + "\n";
    texto += ">> >> PREDECESORAS: ";
    for (var iPrecedente: Number = 0; iPrecedente < this.iface.tareaMemo[iTarea]["predecesora"].length; iPrecedente++) {
      iTareaAux = this.iface.tareaMemo[iTarea]["predecesora"][iPrecedente];

      texto += util.sqlSelect("pr_tipostareapro", "idtipotarea", "idtipotareapro = " + this.iface.tareaMemo[iTareaAux]["idtipotareapro"]);
    }
    texto += "\n>> >> SUCESORAS: ";
    for (var iSucesora: Number = 0; iSucesora < this.iface.tareaMemo[iTarea]["sucesora"].length; iSucesora++) {
      iTareaAux = this.iface.tareaMemo[iTarea]["sucesora"][iSucesora];

      texto += util.sqlSelect("pr_tipostareapro", "idtipotarea", "idtipotareapro = " + this.iface.tareaMemo[iTareaAux]["idtipotareapro"]) + " - ";
    }
    texto += "\n";
    iTarea++;
  }

  this.iface.mostrarDatosCentros();

  var codCentro: String;
  var html: String = "<font size=\"1\"><table width=\"100%\" border=\"1\" cellspacing=\"0\">\n";
  var minFecha: Date = this.iface.buscarFechaMinimaTarea();
  var maxFecha: Date = this.iface.buscarFechaMaximaTarea();
  minFecha.setHours(0);
  minFecha.setMinutes(0);
  minFecha.setSeconds(0);
  maxFecha.setHours(23);
  maxFecha.setMinutes(59);
  maxFecha.setSeconds(59);
  var dias: Number = util.daysTo(minFecha, maxFecha);
  var qryCC: FLSqlQuery = new FLSqlQuery;
  with(qryCC) {
    setTablesList("pr_centroscoste");
    setSelect("codcentro");
    setFrom("pr_centroscoste");
    setWhere("1 = 1");
    setForwardOnly(true);
  }
  if (!qryCC.exec())
    return false;

  html += "\t<tr>";
  html += "<td width=\"20%\">" + "C.C." + "</td>";
  var numFechas: Number = 0;
  for (var iFecha: Date = minFecha; util.daysTo(iFecha, maxFecha) >= 0; iFecha = util.addDays(iFecha, 1)) {
    html += "<td>" + iFecha.getDate() + "</td>";
    numFechas++
  }
  html += "\t</tr>\n";
  while (qryCC.next()) {
    codCentro = qryCC.value("codcentro");
    html += "\t<tr>";
    html += "<td>" + codCentro + "</td>";
    html += "<td colspan=\"" + numFechas + "\">" + this.iface.htmlCentroCoste(codCentro, minFecha, maxFecha) + "</td>";

    html += "\t</tr>\n";
  }
  html += "\n</table></font>";
  this.child("fdbPlanificacion").setValue(html);
}

/** \D Genera una línea html consistente en una tabla de una única fila en la que cada celda representa una tarea asignada al centro de coste
@param  codCentro: Centro de coste
@param  minFecha: Fecha mínima considerada
@param  maxFecha: Fecha máxima considerada
@return html con la tabla
\end */
function oficial_htmlCentroCoste(codCentro: String, minFecha: Date, maxFecha: Date): String {
  var util: FLUtil = new FLUtil;
  var html: String = "\n\t<font size=\"1\"><table width=\"100%\" height=\"100%\" cellspacing=\"0\" border=\"0\"><tr>\n";
  var tareasCentro: Array = this.iface.tareasCentroCoste(codCentro);
  var tiempoTotal: Number = maxFecha.getTime() - minFecha.getTime();
  var iTarea: Number;
  var fecha: Date = minFecha;
  var compFechas: Number;
  var porcentaje: Number;
  var tiempoTarea: Number;
  var tiempoHueco: Number;
  var iLote: Number;
  var color: String;
  for (var iTC: Number = 0; iTC < tareasCentro.length; iTC++)
  {
    iTarea = tareasCentro[iTC];

    compFechas = this.iface.compararFechas(fecha, this.iface.tareaMemo[iTarea]["fechainicio"]);
    switch (compFechas) {
      case 1: {
        MessageBox.warning(util.translate("scripts", "Error al mostrar las tareas del centro de coste %1:\nLas tareas se solapan").arg(codCentro), MessageBox.Ok, MessageBox.NoButton);
        return false;
        break;
      }
      case 2: {
        tiempoHueco = this.iface.tareaMemo[iTarea]["fechainicio"].getTime() - fecha.getTime();
        porcentaje = Math.round(tiempoHueco * 100 / tiempoTotal);
        html += "\t\t<td width=\"" + porcentaje + "%\">" + "<p><span style=\"font-size:7pt\"></span></p>" + "</td>\n";
        break;
      }
    }
    tiempoTarea = this.iface.tareaMemo[iTarea]["fechafin"].getTime() - this.iface.tareaMemo[iTarea]["fechainicio"].getTime();
    porcentaje = Math.round(tiempoTarea * 100 / tiempoTotal);
    html += "\t\t<td bgcolor=\"" + color + "\" width=\"" + porcentaje + "%\">" + "<p><span style=\"font-size:7pt\"></span></p>" + "</td>\n";

    fecha = this.iface.tareaMemo[iTarea]["fechafin"];
  }

  if (this.iface.compararFechas(maxFecha, fecha) == 1)
  {
    tiempoHueco = maxFecha.getTime() - fecha.getTime();
    porcentaje = Math.round(tiempoHueco * 100 / tiempoTotal);
    html += "\t\t<td width=\"" + porcentaje + "%\"><p><span style=\"font-size:7pt\"></span></p></td>\n";
  }
  html += "\t</tr></table></font>\n";
  return html;
}

/** \D Busca la mínima fecha de inicio de entre todas las tareas consideradas
@return fecha mínima
\end */
// function oficial_buscarFechaMinimaTarea():Date
// {
//  var fechaMin:Date = false;
//  for (var iTarea:Number = 0; iTarea < this.iface.tareaMemo.length; iTarea++) {
//    if (!fechaMin) {
//      fechaMin = this.iface.tareaMemo[iTarea]["fechainicio"];
//    } else {
//      if (this.iface.compararFechas(fechaMin, this.iface.tareaMemo[iTarea]["fechainicio"]) == 1) {
//        fechaMin = this.iface.tareaMemo[iTarea]["fechainicio"];
//      }
//    }
//  }
//  var ret:Date = new Date(fechaMin.getTime());
//  return ret;
// }

/** \D Busca la máxima fecha de fin de entre todas las tareas consideradas
@return fecha máxima
\end */
// function oficial_buscarFechaMaximaTarea():Date
// {
//  var fechaMax:Date = false;
//  for (var iTarea:Number = 0; iTarea < this.iface.tareaMemo.length; iTarea++) {
//    if (!fechaMax) {
//      fechaMax = this.iface.tareaMemo[iTarea]["fechafin"];
//    } else {
//      if (this.iface.compararFechas(fechaMax, this.iface.tareaMemo[iTarea]["fechafin"]) == 2) {
//        fechaMax = this.iface.tareaMemo[iTarea]["fechafin"];
//      }
//    }
//  }
//  var ret:Date = new Date(fechaMax.getTime());
//  return ret;
// }

function oficial_mostrarDatosCentros()
{
  var util: FLUtil = new FLUtil;
  var codCentro: String;
  var idTipoTarea: String;
  var iTarea: Number = 0;
  var iTareaAux: Number = 0;
  var iLoteAux: Number = 0;
  var totalTareas: Number = this.iface.tareaMemo.length;
  var texto: String = "";
  var tareasCentro: Array;
  for (var iCentro: Number = 0; iCentro < this.iface.centroMemo.length; iCentro++) {
    codCentro = this.iface.centroMemo[iCentro]["codcentro"];
    texto += "\nCENTRO: " + this.iface.centroMemo[iCentro]["codcentro"] + "\n";
    tareasCentro = this.iface.tareasCentroCoste(codCentro);
    for (var iTC: Number = 0; iTC < tareasCentro.length; iTC++) {
      texto += "TAREA: " + this.iface.datosTarea(this.iface.tareaMemo[tareasCentro[iTC]]["idtipotareapro"]) + "D: " + this.iface.tareaMemo[tareasCentro[iTC]]["fechainicio"] + " H: " + this.iface.tareaMemo[tareasCentro[iTC]]["fechafin"] + " U: " + this.iface.tareaMemo[tareasCentro[iTC]]["duracion"] + "\n";
    }
  }
}

/** \D Construye un array con los índices de las tareas asociadas a un centro de coste ordenadas por fecha de inicio
@param codCentro: Centro en el que se buscan las tareas
@return array de índices ordenado
\end */
// function oficial_tareasCentroCoste(codCentro:String):Array
// {
//  var tareas:Array = [];
//  var fechaNueva:Date;
//  var fechaTarea:Date;
//  var iTareaMod:Number;
//  var longTareas:Number;
//  for (var iTarea:Number = 0; iTarea < this.iface.tareaMemo.length; iTarea++) {
//    if (this.iface.tareaMemo[iTarea]["codcentrocoste"] != codCentro)
//      continue;
//    fechaNueva = this.iface.tareaMemo[iTarea]["fechainicio"];
//    var iTareaCoste:Number;
//    for (iTareaCoste = 0; iTareaCoste < tareas.length; iTareaCoste++) {
//      fechaTarea = this.iface.tareaMemo[tareas[iTareaCoste]]["fechainicio"];
//      if (this.iface.compararFechas(fechaTarea, fechaNueva) == 1)
//        break;
//    }
//    longTareas = tareas.length;
//    for (var iTareaCam:Number = iTareaCoste + 1; iTareaCam <= longTareas; iTareaCam++) {
//      tareas[iTareaCam] = tareas[iTareaCam - 1]
//    }
//    tareas[iTareaCoste] = iTarea;
//  }
//  return tareas;
// }

// function oficial_nuevaTarea():Array
// {
//  var tarea:Array = [];
//  tarea["idtipotareapro"] = false;
//  tarea["predecesora"] = [];
//  tarea["sucesora"] = [];
//  tarea["codcentrocoste"] = false;
//  tarea["fechainicio"] = false;
//  tarea["duracion"] = false;
//  tarea["fechafin"] = false;
//  tarea["cantidad"] = false;
//  tarea["asignada"] = false;
//
//  return tarea;
// }

// function oficial_nuevoCentroCoste():Array
// {
//  var centro:Array = [];
//  centro["codcentro"] = false;
//  centro["codtipocentro"] = false;
//  centro["idtipotareapro"] = false;
//  centro["costeinicial"] = false;
//  centro["costeunidad"] = false;
//  centro["fechainicio"] = false;
//
//  return centro;
// }

// function oficial_datosTarea(idTipoTareaPro:String):String
// {
//  var util:FLUtil = new FLUtil;
//  var texto:String = "";
//  var qryDatos:FLSqlQuery = new FLSqlQuery;
//  with (qryDatos) {
//    setTablesList("pr_tipostareapro");
//    setSelect("idtipotarea, descripcion, idtipoproceso");
//    setFrom("pr_tipostareapro");
//    setWhere("idtipotareapro = " + idTipoTareaPro);
//    setForwardOnly(true);
//  }
//  if (!qryDatos.exec())
//    return false;
//
//  if (!qryDatos.first())
//    return false;
//
//  texto = util.translate("scripts", "Tarea %1: %2 (Proceso %3)").arg(qryDatos.value("idtipotarea")).arg(qryDatos.value("descripcion")).arg(qryDatos.value("idtipoproceso"));
//
//  return texto;
// }

function oficial_lanzarOrdenClicked()
{
  var util: FLUtil = new FLUtil;
  var curTrans: FLSqlCursor = new FLSqlCursor("pr_ordenesproduccion");
  curTrans.transaction(false);
  try {
    if (this.iface.lanzarOrden()) {
      var res: Number = MessageBox.information(util.translate("scripts", "Los procesos de fabricación se han lanzado correctamente."), MessageBox.Ok, MessageBox.Cancel);
      if (res != MessageBox.Ok) {
        curTrans.rollback();
        return;
      }
      curTrans.commit();
      this.child("pushButtonAccept").enabled = true;
      this.child("pushButtonAccept").animateClick();
    } else {
      curTrans.rollback();
    }
  } catch (e) {
    curTrans.rollback();
    MessageBox.critical(util.translate("scripts", "Hubo un error al lanzar los procesos de fabricación:\n") + e, MessageBox.Ok, MessageBox.NoButton);
    return;
  }
}

function oficial_lanzarOrden(): Boolean {
  //  var util:FLUtil = new FLUtil;
  //  var cursor:FLSqlCursor = this.cursor();
  //  var totalFilas:Number = this.iface.tblArticulos.numRows();
  //
  //  for (var iFila:Number = 0; iFila < totalFilas; iFila++) {
  //    if (this.iface.tblArticulos.text(iFila, this.iface.INCLUIR) == "Sí") {
  //      var referencia:String = this.iface.tblArticulos.text(iFila, this.iface.REFERENCIA);
  //      if (util.sqlSelect("articulos","codfamilia","referencia = '" + referencia + "'") == "CORT") {
  //        var codLote:String = this.iface.tblArticulos.text(iFila, this.iface.CODLOTE);
  //        if (util.sqlSelect("movistock","idmovimiento","codloteprod = '" + codLote + "' AND (codlote IS NULL OR codlote  = '') AND cantidad < 0")) {
  //            MessageBox.warning(util.translate("scripts", "No se puede generar el proceso porque el lote %1 no tiene un rollo de tela asociado.").arg(codLote), MessageBox.Ok, MessageBox.NoButton);
  //            return;
  //        }
  //      }
  //    }
  //  }
  //
  //  var codOrden:String = cursor.valueBuffer("codorden");
  //
  //  if (cursor.modeAccess() == cursor.Insert) {
  //    if (!this.child("tdbProcesos").cursor().commitBufferCursorRelation())
  //      return false;
  //  }
  //
  //  var idTipoProceso:String = "CORTE";
  //  var idProceso = flcolaproc.iface.pub_crearProceso(idTipoProceso, "pr_ordenesproduccion", codOrden);
  //  if (!idProceso)
  //    return false;
  //
  // // Movimiento de stock positivo PTE para la fecha prevista de finalización del proceso.
  //  var curProceso:FLSqlCursor = new FLSqlCursor("pr_procesos");
  //  curProceso.select("idproceso = " + idProceso);
  //  if (!curProceso.first())
  //    return false;
  //
  //  if (!flprodppal.iface.pub_actualizarTareasProceso(idProceso))
  //    return false;
  //
  //  var codLote:String;
  //  var totalFilas:Number = this.iface.tblArticulos.numRows();
  //
  //  for (var iFila:Number = 0; iFila < totalFilas; iFila++) {
  //    codLote = this.iface.tblArticulos.text(iFila, this.iface.CODLOTE);
  //
  //    if (this.iface.tblArticulos.text(iFila, this.iface.INCLUIR) == "Sí") {
  //      var cantidad:Number = parseFloat(util.sqlSelect("lotesstock", "canlote", "codlote = '" + codLote + "'"));
  //      if (!cantidad || isNaN(cantidad))
  //        return false;
  //
  //      if (!flfactalma.iface.pub_generarMoviStock(curProceso, codLote, cantidad))
  //        return false;
  //
  //      if (!util.sqlUpdate("lotesstock", "codordenproduccion", codOrden, "codlote = '" + codLote + "'")) {
  //        return false;
  //      }
  //    }
  //  }

  var util: FLUtil = new FLUtil();
  var codLote: String;
  var idProceso: String;
  var totalFilas: Number = this.iface.tblArticulos.numRows();
  util.createProgressDialog(util.translate("scripts", "Generando procesos de corte..."), totalFilas);
  for (var iFila: Number = 0; iFila < totalFilas; iFila++)
  {
    util.setProgress(iFila + 1);
    codLote = this.iface.tblArticulos.text(iFila, this.iface.CODLOTE);
    idProceso = this.iface.tblArticulos.text(iFila, this.iface.IDPROCESO);
    if (this.iface.tblArticulos.text(iFila, this.iface.INCLUIR) == "Sí") {
      if (!this.iface.activarProcesoLote(codLote, idProceso)) {
        util.destroyProgressDialog()
        return false;
      }
    }
  }
  util.destroyProgressDialog()

  return true;
}

/** \D Activa el proceso de producción asociado a un determinado lote
@param  codLote: Código del lote
@param  idProceso: Identificador del proceso a activar
@return true si la función termina correctamente, false en caso contrario
\end */
function oficial_activarProcesoLote(codLote: String, idProceso: String, codOrden: String): Boolean {
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  if (!codOrden || codOrden == "")
  {
    if (cursor.modeAccess() == cursor.Insert) {
      if (!this.child("tdbProcesos").cursor().commitBufferCursorRelation())
        return false;
    }
    codOrden = cursor.valueBuffer("codorden");
  }

  if (!codOrden)
    return false;

  /// Podrá obtenerse de la tabla de búsqueda
  var idTipoProceso: String = util.sqlSelect("pr_procesos", "idtipoproceso", "idproceso = '" + idProceso + "'");
  if (!idTipoProceso)
  {
    MessageBox.warning(util.translate("scripts", "Error al obtener el tipo de proceso correspondiente al artículo %1").arg(referencia), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }

  if (!flcolaproc.iface.pub_activarProcesoProd(idProceso))
    return false;

  if (!flprodppal.iface.pub_actualizarTareasProceso(idProceso, codLote))
    return false;

  // Movimiento de stock positivo PTE para la fecha prevista de finalización del proceso (si es de fabricación)
  if (flcolaproc.iface.pub_esProcesoFabricacion(idTipoProceso))
  {
    var curProceso: FLSqlCursor = new FLSqlCursor("pr_procesos");
    curProceso.select("idproceso = " + idProceso);
    if (!curProceso.first())
      return false;

    var cantidad: Number = parseFloat(util.sqlSelect("lotesstock", "canlote", "codlote = '" + codLote + "'"));
    if (!cantidad || isNaN(cantidad))
      return false;
    if (!flfactalma.iface.pub_generarMoviStock(curProceso, codLote, cantidad))
      return false;
  }

  if (!util.sqlUpdate("pr_procesos", "codordenproduccion", codOrden, "idproceso = " + idProceso))
    return false;

  return true;
}

/** \D Genera el proceso de fabricación asociado a un determinado lote
@param  codLote: Código del lote
@param  referencia: Referencia del artículo
@return true si la función termina correctamente, false en caso contrario
\end */
// function oficial_generarProcesoLote(codLote:String, referencia:String):Boolean
// {
//  var util:FLUtil = new FLUtil;
//  var cursor:FLSqlCursor = this.cursor();
//
//  if (cursor.modeAccess() == cursor.Insert) {
//    if (!this.child("tdbProcesos").cursor().commitBufferCursorRelation())
//      return false;
//  }
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
//  if (!util.sqlUpdate("lotesstock", "codordenproduccion", cursor.valueBuffer("codorden"), "codlote = '" + codLote + "'"))
//    return false;
//
//  return true;
// }


/** \D Actualiza las fechas y horas desde y hasta de ejecución prevista de las tareas del proceso asociado a un lote de fabricación
@param  idProceso: Identificador del proceso
@param  codLote: Código del lote
@return true si la función termina correctamente, false en caso contrario
\end */
// function oficial_actualizarTareasProceso(idProceso:String):Boolean
// {
//  var util:FLUtil = new FLUtil;
//  var fechaInicio:String;
//  var horaInicio:String;
//  var fechaFin:String;
//  var horaFin:String;
//  var fechaAux:Date;
//  var idTipoTareaPro:String;
//  var codCentro:String;
//  var curTareas:FLSqlCursor = new FLSqlCursor("pr_tareas");
//  for (var iTarea:Number = 0; iTarea < this.iface.tareaMemo.length; iTarea++) {
//    idTipoTareaPro = this.iface.tareaMemo[iTarea]["idtipotareapro"];
//    codCentro = this.iface.tareaMemo[iTarea]["codcentrocoste"];
//    fechaInicio = this.iface.tareaMemo[iTarea]["fechainicio"].toString().left(10);
//    horaInicio = this.iface.tareaMemo[iTarea]["fechainicio"].toString().right(8);
//    fechaFin = this.iface.tareaMemo[iTarea]["fechafin"].toString().left(10);
//    horaFin = this.iface.tareaMemo[iTarea]["fechafin"].toString().right(8);
//    with (curTareas) {
//      select("idproceso = " + idProceso + " AND idtipotareapro = " + idTipoTareaPro);
//      if (!first()) {
//        MessageBox.warning(util.translate("scripts", "Error al obtener la tarea:\n%1").arg(this.iface.datosTarea(idTipoTareaPro)), MessageBox.Ok, MessageBox.NoButton);
//        return false;
//      }
//      setModeAccess(Edit);
//      refreshBuffer();
//      setValueBuffer("fechainicioprev", fechaInicio);
//      setValueBuffer("horainicioprev", horaInicio);
//      setValueBuffer("fechafinprev", fechaFin);
//      setValueBuffer("horafinprev", horaFin);
//      setValueBuffer("codcentro", codCentro);
//      if (!commitBuffer())
//        return false;
//    }
//  }
//  return true;
// }

function oficial_tbnEstadoAtras_clicked()
{
  switch (this.iface.estado_) {
    case "calcular": {
      this.iface.establecerEstadoBotones("buscar");
      break;
    }
    case "lanzar": {
      this.iface.establecerEstadoBotones("calcular");
      break;
    }
  }
}

/** \D
Muestra el formulario de unidades de producto filtrado con las características de la unidad seleccionada
\end
*/
function oficial_tbnEditarLote_clicked()
{
  var iFila: Number = this.iface.tblArticulos.currentRow();
  if (iFila < 0)
    return;

  var codLote: String = this.iface.tblArticulos.text(iFila, this.iface.CODLOTE);
  this.iface.curLote_.select("codlote = '" + codLote + "'");
  if (!this.iface.curLote_.first())
    return;


  this.iface.curLote_.editRecord();
}

function oficial_establecerEstadoBotones(estado: String)
{
  var util: FLUtil = new FLUtil;
  this.iface.estado_ = estado;

  switch (this.iface.estado_) {
    case "buscar": {
      var totalFilas: Number = this.iface.tblArticulos.numRows();
      for (var fila: Number = 0; fila < totalFilas; fila++)
        this.iface.tblArticulos.removeRow(0);
      this.iface.tbnBuscar.enabled = true;
      this.iface.tbnCalcular.enabled = false;
      this.iface.tbnLanzarOrden.enabled = false;
      this.iface.tbnEditarLote.enabled = false;
      this.iface.tbnEstadoAtras.enabled = false;
      this.child("lblEstado").text = util.translate("scripts", "Buscando procesos...");
      this.child("gbxFiltros").enabled = true;
      break;
    }
    case "calcular": {
      flprodppal.iface.pub_limpiarMemoria();
      this.iface.tbnBuscar.enabled = false;
      this.iface.tbnCalcular.enabled = true;
      this.iface.tbnLanzarOrden.enabled = false;
      this.iface.tbnEditarLote.enabled = true;
      this.iface.tbnEstadoAtras.enabled = true;
      this.child("lblEstado").text = util.translate("scripts", "Planificando producción...");
      this.child("gbxFiltros").enabled = false;
      break;
    }
    case "lanzar": {
      this.iface.tbnBuscar.enabled = false;
      this.iface.tbnCalcular.enabled = false;
      this.iface.tbnLanzarOrden.enabled = true;
      this.iface.tbnEditarLote.enabled = false;
      this.iface.tbnEstadoAtras.enabled = true;
      this.child("lblEstado").text = util.translate("scripts", "Lanzando procesos...");
      this.child("gbxFiltros").enabled = false;
      break;
    }
  }
}

// function oficial_limpiarMemoria()
// {
//  delete this.iface.tareaMemo;
//  this.iface.tareaMemo = [];
//
//  delete this.iface.centroMemo;
//  this.iface.centroMemo = [];
//
//  this.iface.iColorLote = 0;
// }

function oficial_habilitarPestanas()
{
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  if (!util.sqlSelect("pr_procesos", "idproceso", "codordenproduccion = '" + cursor.valueBuffer("codorden") + "'")) {
    this.child("tbwOrdenes").setTabEnabled("buscar", true);
    this.child("tbwOrdenes").setTabEnabled("procesos", false);
    this.child("tbwOrdenes").currentPage = 0;

    this.child("pushButtonAccept").enabled = false;
    this.child("pushButtonAcceptContinue").close();
  } else {
    this.child("tbwOrdenes").setTabEnabled("buscar", false);
    this.child("tbwOrdenes").setTabEnabled("procesos", true);
    this.child("tbwOrdenes").currentPage = 1;
  }
}
// OFICIAL /////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
