
/** @class_declaration prodSofa */
/////////////////////////////////////////////////////////////////
//// PRODSOFA ///////////////////////////////////////////////////
class prodSofa extends oficial
{
  function prodSofa(context)
  {
    oficial(context);
  }
  //  function asignarCentroCosteTarea(iTarea:Number):Boolean {
  //    return this.ctx.prodSofa_asignarCentroCosteTarea(iTarea);
  //  }
  //  function actualizarTareasProceso(idProceso:String,codLote:String):Boolean {
  //    return this.ctx.prodSofa_actualizarTareasProceso(idProceso,codLote);
  //  }
  //  function cargarTareas(cantidad:String, nGrupos:Number):Boolean {
  //    return this.ctx.prodSofa_cargarTareas(cantidad, nGrupos);
  //  }
  //  function costeCentroTarea(codTipoCentro:String,referencia:String,iTarea:Number,iLote:Number,codCentro:String):Number {
  //    return this.ctx.prodSofa_costeCentroTarea(codTipoCentro,referencia,iTarea,iLote,codCentro);
  //  }
  function establecerSecuencias(permitirRestricciones: Boolean): Boolean {
    return this.ctx.prodSofa_establecerSecuencias(permitirRestricciones);
  }
  function restriccionesConsumo(permitirRestricciones: Boolean): Boolean {
    return this.ctx.prodSofa_restriccionesConsumo(permitirRestricciones);
  }
  function buscarPedidoFechaMinima(codLote: String, criterios: String): Array {
    return this.ctx.prodSofa_buscarPedidoFechaMinima(codLote, criterios);
  }
}
//// PRODSOFA ///////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pubSofa */
/////////////////////////////////////////////////////////////////
//// PUBSOFA  ///////////////////////////////////////////////////
class pubSofa extends ifaceCtx
{
  function pubSofa(context)
  {
    ifaceCtx(context);
  }
  function pub_asignarCentroCosteTarea(iTarea: Number): Boolean {
    return this.asignarCentroCosteTarea(iTarea);
  }
  function pub_actualizarTareasProceso(idProceso: String, codLote: String): Boolean {
    return this.actualizarTareasProceso(idProceso, codLote);
  }
  function pub_cargarTareas(cantidad: String, nGrupos: Number): Boolean {
    return this.cargarTareas(cantidad, nGrupos);
  }
  function pub_establecerSecuencias(permitirRestricciones: Boolean): Boolean {
    return this.establecerSecuencias(permitirRestricciones);
  }
}
//// PUBSOFA  ///////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition prodSofa */
/////////////////////////////////////////////////////////////////
//// PRODSOFA ///////////////////////////////////////////////////
// function prodSofa_asignarCentroCosteTarea(iTarea:Number):Boolean
// {
//  var util:FLUtil = new FLUtil;
//  var idTipoTareaPro:String = this.iface.tareaMemo[iTarea]["idtipotareapro"];
//  var idTipoProceso:String = util.sqlSelect("pr_tipostareapro","idtipoproceso","idtipotareapro = " + idTipoTareaPro);
//  var tipoObjeto:String = util.sqlSelect("pr_tiposproceso","tipoobjeto","idtipoproceso = '" + idTipoProceso + "'");
//
//  if (tipoObjeto != "pr_ordenesproduccion")
//    return this.iface.__asignarCentroCosteTarea(iTarea);
//
//  var fechaMinTarea:Date = this.iface.fechaMinimaTarea(iTarea);
//
//
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
// //     this.iface.costeCentroTare(codTipoCentro,referencia:String,codCentro)
//    var cantidad:Number = this.iface.tareaMemo[iTarea]["cantidad"];
//    var nGrupos:Number = this.iface.tareaMemo[iTarea]["nGrupos"];
//
// //     var cantidad:Number = 0;
// //     var nGrupos:Number = 0;
// //     var refGrupo:String = "";
// //     for (var fila:Number = 0; fila < this.iface.tblArticulos.numRows(); fila++) {
// //       if (this.iface.tblArticulos.text(fila, this.iface.INCLUIR) == "Sí") {
// //         cantidad += parseFloat(this.iface.tblArticulos.text(fila, this.iface.TOTAL));
// //         if (refGrupo != this.iface.tblArticulos.text(fila, this.iface.REFERENCIA)) {
// //           nGrupos += 1;
// //           refGrupo = this.iface.tblArticulos.text(fila, this.iface.REFERENCIA);
// //         }
// //       }
// //     }
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
//
// /** \D Actualiza las fechas y horas desde y hasta de ejecución prevista de las tareas del proceso asociado a un lote de fabricación
// @param idProceso: Identificador del proceso
// @param codLote: Código del lote
// @return true si la función termina correctamente, false en caso contrario
// \end */
// function prodSofa_actualizarTareasProceso(idProceso:String,codLote:String):Boolean
// {
//  var util:FLUtil = new FLUtil;
//
//  var idTipoProceso:String = util.sqlSelect("pr_procesos","idtipoproceso","idproceso = '" + idProceso + "'");
//  var tipoObjeto:String = util.sqlSelect("pr_tiposproceso","tipoobjeto","idtipoproceso = '" + idTipoProceso + "'");
//
//  if (tipoObjeto != "pr_ordenesproduccion")
//    return this.iface.__actualizarTareasProceso(idProceso,codLote);
//
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
//
// function prodSofa_cargarTareas(cantidad:String,nGrupos:Number):Boolean
// {
//  var util:FLUtil = new FLUtil;
//
//  var idTipoProceso:String = "CORTE";
//
//  var qryTareas:FLSqlQuery = new FLSqlQuery();
//  with (qryTareas) {
//    setTablesList("pr_tipostareapro");
//    setSelect("idtipotareapro,idtipotarea");
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
//    this.iface.tareaMemo[indice] = this.iface.nuevaTarea();
//    this.iface.tareaMemo[indice]["idtipotareapro"] = idTipoTareaPro;
//    this.iface.tareaMemo[indice]["idtipotarea"] = qryTareas.value("idtipotarea");
//    this.iface.tareaMemo[indice]["cantidad"] = cantidad;
//    this.iface.tareaMemo[indice]["nGrupos"] = nGrupos;
//  }
//  return true;
// }

// function prodSofa_costeCentroTarea(codTipoCentro:String,referencia:String,iTarea:Number,iLote:Number,codCentro:String):Number
// {
//  var util:FLUtil;
//
//  if(util.sqlSelect("articulos","codfamilia","referencia = '" + referencia + "'") != "CORT")
//    return this.iface.__costeCentroTarea(codTipoCentro,referencia,iTarea,iLote,codCentro);
//
//
//  var tiempo:Number;
//
//  var qryCostes:FLSqlQuery = new FLSqlQuery;
//  qryCostes.setTablesList("pr_costestarea");
//  qryCostes.setSelect("costeinicial,costeunidad");
//  qryCostes.setFrom("pr_costestarea");
//  qryCostes.setForwardOnly(true);
//  qryCostes.setWhere("codtipocentro = '" + codTipoCentro + "' AND referencia = '" + referencia + "'");
//
//  if (!qryCostes.exec())
//    return -1;
//
//  if (!qryCostes.first()) {
//    qryCostes.setWhere("codtipocentro = '" + codTipoCentro + "' AND referencia IS NULL");
//    if (!qryCostes.exec())
//      return -1;
//
//    if (!qryCostes.first()) {
//      return -1;
//    }
//  }
//
//  var costeFijo:Number = parseFloat(qryCostes.value("costeinicial"));
//  if (!costeFijo || isNaN(costeFijo))
//    costeFijo = 0;
//
//  var costeUnidad:Number = parseFloat(qryCostes.value("costeunidad"));
//  if (!costeUnidad || isNaN(costeUnidad))
//    costeUnidad = 0;
//
//  var cantidad:Number = this.iface.tareaMemo[iTarea]["cantidad"];
//  var nGrupos:Number = this.iface.tareaMemo[iTarea]["nGrupos"];
//
//  tiempo = costeFijo + (costeUnidad * cantidad) + (costeGrupo * nGrupos);
//  tiempo = this.iface.convetirTiempoMS(tiempo, codCentro);
//
//  return tiempo;
// }

function prodSofa_establecerSecuencias(permitirRestricciones: Boolean): Boolean {
  var codLote: String;
  var idTipoTarea: String;
  var iTarea: Number = 0;
  var totalTareas: Number = this.iface.tareaMemo.length;
  for (var iLote: Number = 0; iLote < this.iface.loteMemo.length; iLote++)
  {
    codLote = this.iface.loteMemo[iLote]["codlote"];
    while (iTarea < totalTareas && this.iface.tareaMemo[iTarea]["codlote"] == codLote) {
      if (!this.iface.establecerSecuenciasTarea(iTarea, iLote))
        return false;
      iTarea++;
    }
  }
  if (!this.iface.restriccionesConsumo(permitirRestricciones))
    return false;

  return true;
}

function prodSofa_restriccionesConsumo(permitirRestricciones: Boolean): Boolean {
  var util: FLUtil = new FLUtil;
  var codLote: String;
  var idTipoTareaPro: String;
  var idProceso: Number;
  var iTarea: Number;
  var iLoteComsumo: Number;
  var estadoLoteConsumo: String;
  var codLoteConsumo: Number;
  var qryConsumos: FLSqlQuery = new FLSqlQuery;


  for (iLote = 0; iLote < this.iface.loteMemo.length; iLote++)
  {
    codLote = this.iface.loteMemo[iLote]["codlote"];

    with(qryConsumos) {
      setTablesList("movistock");
      setSelect("ms.codlote, a.idtipoproceso, ac.idtipotareapro");
      setFrom("movistock ms INNER JOIN articuloscomp ac ON ms.idarticulocomp = ac.id INNER JOIN articulos a ON ac.refcomponente = a.referencia");
      setWhere("ms.codloteprod = '" + codLote + "' AND a.fabricado = true");
      setForwardOnly(true);
    }
    if (!qryConsumos.exec())
      return false;

    while (qryConsumos.next()) {
      idTipoTareaPro = qryConsumos.value("ac.idtipotareapro");
      iTarea = this.iface.buscarTarea(codLote, idTipoTareaPro);
      if (iTarea < 0) {
        MessageBox.warning(util.translate("scripts", "Restricciones de consumo: Error al buscar la tarea:\n%1\nAsiciada al lote %2.").arg(this.iface.datosTarea(idTipoTareaPro)).arg(codLote), MessageBox.Ok, MessageBox.NoButton);
        return false;
      }

      codLoteConsumo = qryConsumos.value("ms.codlote");
      idProceso = util.sqlSelect("pr_procesos", "idproceso", "idtipoproceso = '" + qryConsumos.value("a.idtipoproceso") + "' AND idobjeto = '" + codLoteConsumo + "'");
      if (idProceso && !isNaN(idProceso)) {
        ///// POR HACER
      } else {
        iLoteComsumo = this.iface.buscarLote(codLoteConsumo);
        estadoLoteConsumo = util.sqlSelect("lotesstock", "estado", "codlote = '" + codLoteConsumo + "'");
        if (!permitirRestricciones) {
          if (estadoLoteConsumo != "TERMINADO") {
            if (iLoteComsumo < 0) {
              MessageBox.warning(util.translate("scripts", "Para fabricar el lote %1 es necesario tener disponible el lote %2.\nDicho lote no está fabricado ni incluido en esta orden.").arg(codLote).arg(codLoteConsumo), MessageBox.Ok, MessageBox.NoButton);
              return false;
            }
          }
        }
        var tareasFin: Array = this.iface.tareasFinales(codLoteConsumo);
        if (tareasFin.length > 0) {
          for (var i: Number = 0; i < tareasFin.length; i++) {
            if (!this.iface.establecerSecuencia(tareasFin[i], iTarea))
              return false;

          }
        }
      }
    }
  }
  return true;
}

function prodSofa_buscarPedidoFechaMinima(codLote: String, criterios: String): Array {
  var util: FLUtil;

  if (codLote.startsWith("CO"))
    codLote = util.sqlSelect("movistock", "codloteprod", "codlote = '" + codLote + "' AND codloteprod IS NOT NULL AND codloteprod <> ''");

  return this.iface.__buscarPedidoFechaMinima(codLote, criterios);
}
//// PRODSOFA ///////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
