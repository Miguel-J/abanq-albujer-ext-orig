
/** @class_declaration prodSofa */
/////////////////////////////////////////////////////////////////
//// PRODSOFA ///////////////////////////////////////////////////
class prodSofa extends prod
{
  function prodSofa(context)
  {
    prod(context);
  }
  function iniciarTareaEsp(curTareas: FLSqlCursor): Boolean {
    return this.ctx.prodSofa_iniciarTareaEsp(curTareas);
  }
  function afterCommit_pr_tareas(curTarea: FLSqlCursor): Boolean {
    return this.ctx.prodSofa_afterCommit_pr_tareas(curTarea);
  }
  function actualizarEstadoPedido(idPedido: Number): Boolean {
    return this.ctx.prodSofa_actualizarEstadoPedido(idPedido);
  }
  function descripcionTarea(curTarea: FLSqlCursor): String {
    return this.ctx.prodSofa_descripcionTarea(curTarea);
  }
  function terminarTareaEsp(curTareas: FLSqlCursor): Boolean {
    return this.ctx.prodSofa_terminarTareaEsp(curTareas);
  }
  function deshacerTareaTerminadaEsp(curTareas: FLSqlCursor): Boolean {
    return this.ctx.prodSofa_deshacerTareaTerminadaEsp(curTareas);
  }
  function datosTareaOFF(curTipoTareaPro: FLSqlCursor, xmlTarea: FLDomNode): Boolean {
    return this.ctx.prodSofa_datosTareaOFF(curTipoTareaPro, xmlTarea);
  }
  function obtenerOpcionLote(codLote: String, idTipoOpcion: String): String {
    return this.ctx.prodSofa_obtenerOpcionLote(codLote, idTipoOpcion);
  }
}
//// PRODSOFA ///////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition prodSofa */
/////////////////////////////////////////////////////////////////
//// PRODSOFA ///////////////////////////////////////////////////
/** \D Realiza acciones asociadas al tipo de tarea que se está iniciando (PTE >> EN CURSO)
@param  curTareas: Cursor posicionado en la tarea a iniciar
@return Verdadero si las acciones se realizaron correctemente, falso en caso contrario
\end */
function prodSofa_iniciarTareaEsp(curTareas: FLSqlCursor): Boolean {
  var util: FLUtil = new FLUtil;

  if (!this.iface.esTareaProduccion(curTareas))
  {
    return this.iface.__iniciarTareaEsp(curTareas);
  }

  var idTipoTarea: String = curTareas.valueBuffer("idtipotarea");
  var idTipoTareaPro: String = curTareas.valueBuffer("idtipotareapro");
  var idTarea: Number = curTareas.valueBuffer("idtarea");
  var idProceso: Number = curTareas.valueBuffer("idproceso");
  var res: Number;
  debug("idTipoTarea " + idTipoTarea);

  if (idTipoTarea == "CORTE")
  {
    var codLoteCorte: String = util.sqlSelect("pr_procesos", "idobjeto", "idproceso = " + idProceso);

    var f: Object = new FLFormSearchDB("pr_tareacorte");
    var curTarea: FLSqlCursor = f.cursor();
    curTarea.select("idtarea = '" + idTarea + "'");
    if (!curTarea.first())
      return;
    curTarea.setModeAccess(curTarea.Browse);
    curTarea.refreshBuffer();
    f.setMainWidget();
    res = f.exec("idtarea");
    if (!res)
      return false;
  }

  return this.iface.__iniciarTareaEsp(curTareas);
}

function prodSofa_afterCommit_pr_tareas(curTarea: FLSqlCursor): Boolean {
  var util: FLUtil;
  //  if(!this.iface.__afterCommit_pr_tareas(curTarea))
  //    return false;
  //
  //  var idProceso:String = curTarea.valueBuffer("idproceso");
  //  if(!idProceso)
  //    return false;
  //
  //  var codLote:String = curTarea.valueBuffer("idobjeto");
  // debug("codLote " + codLote);
  //  if(!codLote  || codLote == "")
  //    return false;
  //
  //  var codLoteProd:String = util.sqlSelect("movistock","codloteprod","codlote = '" + codLote + "' AND codloteprod IS NOT NULL AND codloteprod <> ''");
  // debug("codLoteProd " + codLoteProd);
  //  var codLoteAnt:String = codLote;
  //  if(codLoteProd && codLoteProd != "")
  //    codLote = codLoteProd;
  //
  //  var idLinea:Number = util.sqlSelect("movistock","idlineapc","codlote = '" + codLote + "'");
  // debug("idLinea " + idLinea);
  //  if(!idLinea)
  //    return false;
  //
  //  var idPedido:Number = util.sqlSelect("lineaspedidoscli","idpedido","idlinea = " + idLinea);
  // debug("idPedido " + idPedido);
  //  if(!idPedido)
  //    return false;
  //
  //  var estado:String = util.sqlSelect("pr_procesos","subestado","idproceso = " + idProceso);
  //  var tipoProceso:String = util.sqlSelect("pr_procesos","idtipoproceso","idproceso = " + idProceso);
  //
  //  if(tipoProceso = "CORTE") {
  //    if(!estado)
  //      estado = "PTE";
  //  }
  //  if(tipoProceso = "COSIDO") {
  //    if(util.sqlSelect("pr_tareas t INNER JOIN pr_procesos p ON t.idproceso = p.idproceso","t.idtarea","t.estado = 'PTE' AND p.idtipoproceso = 'COSIDO' AND t.idobjeto = '" + codLoteAnt + "' AND t.idtarea <> '" + curTarea.valueBuffer("idtarea") + "'","pr_tareas,pr_procesos"))
  //      estado = "";
  //  }
  //
  // debug("estado " + estado);
  //  if(estado && estado != "")
  //    if(!util.sqlUpdate("pedidoscli","estado",estado,"idpedido = " + idPedido))
  //      return false;


  var util: FLUtil;

  if (curTarea.valueBuffer("tipoobjeto") == "lotesstock")
  {
    var codLote: String = curTarea.valueBuffer("idobjeto");

    if (!codLote  || codLote == "") {
      MessageBox.warning(util.translate("scripts", "El lote asociado a la tarea %1 no existe").arg(curTarea.valueBuffer("idtarea")), MessageBox.Ok, MessageBox.NoButton);
      return false;
    }

    var codLoteProd: String = util.sqlSelect("movistock", "codloteprod", "codlote = '" + codLote + "' AND codloteprod IS NOT NULL AND codloteprod <> ''");
    if (codLoteProd && codLoteProd != "")
      codLote = codLoteProd;

    var idLinea: Number = util.sqlSelect("movistock", "idlineapc", "codlote = '" + codLote + "' AND idlineapc IS NOT NULL AND idlineapc <> 0");

    if (idLinea) {
      var idPedido: Number = util.sqlSelect("lineaspedidoscli", "idpedido", "idlinea = " + idLinea);

      if (!idPedido) {
        MessageBox.warning(util.translate("scripts", "No hay un pedido de cliente para el lote %1").arg(codLote), MessageBox.Ok, MessageBox.NoButton);
        return false;
      }

      if (curTarea.modeAccess() == curTarea.Insert) {
        if (!util.sqlUpdate("pedidoscli", "estado", "PTE", "idpedido = " + idPedido)) {
          MessageBox.warning(util.translate("scripts", "Error al actualizar el pedido de cliente correspondiente al lote %1").arg(codLote), MessageBox.Ok, MessageBox.NoButton);
          return false;
        }
        return true;
      }

      if (!this.iface.actualizarEstadoPedido(idPedido)) {
        MessageBox.warning(util.translate("scripts", "Error al actualizar el estado del pedido de cliente correspondiente al lote %1").arg(codLote), MessageBox.Ok, MessageBox.NoButton);
        return false;
      }
    }
  }
  return true;
}

function prodSofa_actualizarEstadoPedido(idPedido: Number): Boolean {
  var util: FLUtil;

  var estadoPrevio = util.sqlSelect("pedidoscli", "estado", "idpedido = " + idPedido);
  var estado: String = "";

  if (util.sqlSelect("lineaspedidoscli lp INNER JOIN pr_procesos p ON lp.idlinea = p.idlineapedidocli", "p.idproceso", "lp.idpedido = " + idPedido + " AND p.estado <> 'OFF'", "lineaspedidoscli,pr_procesos"))
  {

    estado = "CORTADO";

    var qryProcesos: FLSqlQuery = new FLSqlQuery();
    with(qryProcesos) {
      setTablesList("lineaspedidoscli,pr_procesos");
      setSelect("p.estado");
      setFrom("lineaspedidoscli lp INNER JOIN pr_procesos p ON lp.idlinea = p.idlineapedidocli");
      setWhere("lp.idpedido = " + idPedido + " AND idtipoproceso = 'CORTE' AND p.estado <> 'OFF'");
    }

    if (!qryProcesos.exec())
      return false;

    if (qryProcesos.size() > 0) {
      while (qryProcesos.next() && estado == "CORTADO") {
        if (qryProcesos.value("p.estado") != "TERMINADO")
          estado = "PTE";
      }
    }

    if (!util.sqlSelect("lineaspedidoscli lp INNER JOIN pr_procesos p ON lp.idlinea = p.idlineapedidocli", "p.idproceso", "lp.idpedido = " + idPedido + " AND idtipoproceso <> 'CORTE' AND p.estado <> 'TERMINADO'", "lineaspedidoscli,pr_procesos") && estado == "CORTADO")
      estado = "TERMINADO";
  }


  if (estado == estadoPrevio)
    return true;

  var editable: Boolean;
  var curPedido: FLSqlCursor = new FLSqlCursor("pedidoscli");
  curPedido.setActivatedCommitActions(false);
  curPedido.select("idpedido = " + idPedido);
  if (!curPedido.first())
    return false;
  editable = curPedido.valueBuffer("editable");

  if (!editable)
  {
    curPedido.setUnLock("editable", true);
    curPedido.select("idpedido = " + idPedido);
    if (!curPedido.first())
      return false;
  }

  curPedido.setModeAccess(curPedido.Edit);
  curPedido.refreshBuffer();
  curPedido.setValueBuffer("estado", estado);
  if (!curPedido.commitBuffer())
    return false;

  if (!editable)
  {
    curPedido.select("idpedido = " + idPedido);
    if (!curPedido.first())
      return false;
    curPedido.setUnLock("editable", false);
  }

  //  if(!util.sqlUpdate("pedidoscli","estado",estado,"idpedido = " + idPedido))
  //    return false;

  return true;
}

// function prodSofa_actualizarEstadoPedido(idPedido:Number):Boolean
// {
//  var util:FLUtil;
//
//  var qryTareas:FLSqlQuery = new FLSqlQuery();
//  with (qryTareas) {
//    setTablesList("lineaspedidoscli,movistock,pr_tareas");
//    setSelect("t.idtarea,t.estado,t.idtipotarea");
//    setFrom("movistock m INNER JOIN movistock c ON m.codlote = c.codloteprod INNER JOIN lineaspedidoscli lp ON lp.idlinea = m.idlineapc INNER JOIN pr_tareas t ON c.codloteprod = t.idobjeto OR c.codlote = t.idobjeto");
//    setWhere("lp.idpedido = " + idPedido + " AND c.codlote is not null AND c.codlote <> '' GROUP BY t.idtarea,t.estado,t.idtipotarea");
//  }
//
//  if (!qryTareas.exec())
//    return false;
//
//  var hayCortes:Boolean = false;
//  var hayProduccion:Boolean = false;
//  var corte:Boolean = true;
//  var cosido:Boolean = true;
//  var cosidom:Number = 0;
//  var cosidof:Number = 0;
//  var relleno:Boolean = false;
//  var montaje:Boolean = false;
//  var embalado:Boolean = true;
//
//  var estado:String = "PTE";
//
//  if(qryTareas.size() > 0) {
//    while (qryTareas.next()) {
//      var estado:String = qryTareas.value("t.estado");
//      switch(qryTareas.value("t.idtipotarea")) {
//        case "CORTE": {
//          hayCortes = true;
//          if (estado != "TERMINADA")
//            corte = false;
//          break;
//        }
//        case "COSIDO": {
//          hayProduccion = true;
//          if (estado != "TERMINADA")
//            cosido = false;
//          break;
//        }
//        case "COSIDOM": {
//          hayProduccion = true;
//          cosidom = 2;
//          if (estado != "TERMINADA")
//            cosidom = 1;
//          break;
//        }
//        case "COSIDOF": {
//          hayProduccion = true;
//          cosidof = 2;
//          if (estado != "TERMINADA")
//            cosidof = 1;
//          break;
//        }
//        case "RELLENO": {
//          hayProduccion = true;
//          if (estado == "TERMINADA" || estado == "EN CURSO")
//            relleno = true;
//          break;
//        }
//        case "MONTAJE": {
//          hayProduccion = true;
//          if (estado == "TERMINADA" || estado == "EN CURSO")
//            montaje = true;
//          break;
//        }
//        case "EMBALADO": {
//          hayProduccion = true;
//          if (estado != "TERMINADA")
//            embalado = false;
//          break;
//        }
//      }
//    }
//
//    if(hayCortes) {
//      if(corte)
//        estado = "CORTADO";
//    }
//    if(hayProduccion) {
//      if(embalado)
//        estado = "TERMINADO";
//      else {
//        if (relleno || montaje) {
//          estado = "EN PRODUCCION";
//        }
//        else {
//          // cosidom y cosidof valen:
//          //  0 >> cuando no existen tareas de este tipo
//          //  1 >> cuando existen pero no están terminadas
//          //  2 >> cuando están terminadas
//          //
//          // Si no existen de este tipo es por que existe la de tipo COSIDO
//
//          if(cosidom > 0 && cosidof > 0) {
//            if(cosidom == 2 && cosidof == 2)
//              estado = "COSIDO";
//          }
//          else {
//            if (cosido)
//              estado = "COSIDO";
//          }
//        }
//      }
//    }
//  }
//
//  if(!util.sqlUpdate("pedidoscli","estado",estado,"idpedido = " + idPedido))
//    return false;
//
//  return true;
// }

/** \D Obtiene la descripción de la tarea
@param  curTarea: Cursor con los datos de la tarea
@return Descripción
\end */
function prodSofa_descripcionTarea(curTarea: FLSqlCursor): String {
  var util: FLUtil = new FLUtil;
  var descripcion: String = "";
  var codLote: String = curTarea.valueBuffer("idObjeto");
  var idTipoTarea: String = curTarea.valueBuffer("idtipotarea");
  if (codLote && idTipoTarea && codLote != "" && idTipoTarea != "")
  {
    var idProceso: Number = curTarea.valueBuffer("idproceso");
    var idLinea: Number = util.sqlSelect("pr_procesos", "idlineapedidocli", "idproceso = " + idProceso + " AND idlineapedidocli IS NOT NULL AND idlineapedidocli <> 0");
    if (idLinea && idLinea != 0) {
      if (formRecordlineaspedidoscli.child("fdbDescripcion"))
        descripcion = idTipoTarea + " - " + formRecordlineaspedidoscli.cursor().valueBuffer("descripcion");
      else
        descripcion = idTipoTarea + " - " + util.sqlSelect("lineaspedidoscli", "descripcion", "idlinea = " + idLinea);
    }
  }

  if (!descripcion || descripcion == "")
    descripcion = this.iface.__descripcionTarea(curTarea);

  return descripcion;
}

function prodSofa_terminarTareaEsp(curTareas: FLSqlCursor): Boolean {
  var util: FLUtil;
  var idTipoTarea: String = curTareas.valueBuffer("idtipotarea");
  switch (idTipoTarea)
  {
    case "CORTE": {
      var idObjeto: String = curTareas.valueBuffer("idobjeto");
      var codLote: String = util.sqlSelect("movistock", "codloteprod", "codlote = '" + idObjeto + "' AND codloteprod <> '' AND codloteprod is not null");
      if (!codLote || codLote == "")
        return false;

      if (!util.sqlUpdate("lotesstock", "estado", "CORTADO", "codlote = '" + codLote + "'"))
        return false;
      break;
    }
    case "COSIDO": {
      var codLote: String = curTareas.valueBuffer("idobjeto");
      var estadoOtra: String = util.sqlSelect("pr_tareas", "estado", "idobjeto = '" + codLote + "' AND idtipotarea = 'COSIDO' AND idtarea <> '" + curTareas.valueBuffer("idtarea") + "'");
      if (estadoOtra == "TERMINADA") {
        if (!util.sqlUpdate("lotesstock", "estado", "COSIDO", "codlote = '" + codLote + "'"))
          return false;
      }
      break;
    }
  }

  return true;
}

function prodSofa_deshacerTareaTerminadaEsp(curTareas: FLSqlCursor): Boolean {
  var util: FLUtil;
  var idTipoTarea: String = curTareas.valueBuffer("idtipotarea");
  switch (idTipoTarea)
  {
    case "CORTE": {
      var idObjeto: String = curTareas.valueBuffer("idobjeto");
      var codLote: String = util.sqlSelect("movistock", "codloteprod", "codlote = '" + idObjeto + "' AND codloteprod <> '' AND codloteprod is not null");
      if (!codLote || codLote == "")
        return false;

      var estadoLote: String = util.sqlSelect("lotesstock", "estado", "codlote = '" + codLote + "'");
      if (estadoLote != "CORTADO") {
        MessageBox.warning(util.translate("scripts", "No se puede deshacer la tarea de CORTE que el lote %1 está en estado %2").arg(codLote).arg(estadoLote), MessageBox.Ok, MessageBox.NoButton);
        return false;
      }
      if (!util.sqlUpdate("lotesstock", "estado", "PTE", "codlote = '" + codLote + "'"))
        return false;

      break;
    }
    case "COSIDO": {
      var codLote: String = curTareas.valueBuffer("idobjeto");
      if (!util.sqlUpdate("lotesstock", "estado", "CORTADO", "codlote = '" + codLote + "'"))
        return false;
      break;
    }
    case "RELLENO": {
      var codLote: String = curTareas.valueBuffer("idobjeto");
      if (!util.sqlUpdate("lotesstock", "estado", "COSIDO", "codlote = '" + codLote + "'"))
        return false;
      break;
    }
  }

  return true;
}

function prodSofa_datosTareaOFF(curTipoTareaPro: FLSqlCursor, xmlTarea: FLDomNode): Boolean {
  if (!this.iface.__datosTareaOFF(curTipoTareaPro, xmlTarea))
    return false;

  this.iface.curTareas_.setValueBuffer("descripcion", this.iface.descripcionTarea(this.iface.curTareas_));

  return true;
}

function prodSofa_obtenerOpcionLote(codLote: String, idTipoOpcion: String)
{
  var util: FLUtil = new FLUtil;
  var referencia: String = util.sqlSelect("lotesstock", "referencia", "codlote = '" + codLote + "'");

  if (!referencia || referencia == "") {
    return false;
  }
  var codFamilia: String = util.sqlSelect("articulos", "codfamilia", "referencia = '" + referencia + "'");

  if (codFamilia != "CORT") {
    return this.iface.__obtenerOpcionLote(codLote, idTipoOpcion);
  }

  var idTipoOpcionArtPed: String;
  if (formRecordlineaspedidoscli.cursor()) {
    idTipoOpcionArtPed = formRecordlineaspedidoscli.iface.obtenerIdTipoOpcionArtMarcada();
    if (!idTipoOpcionArtPed) {
      return this.iface.__obtenerOpcionLote(codLote, idTipoOpcion);
    }
    var idTipoOpcionPed: Number = util.sqlSelect("tiposopcionartcomp", "idtipoopcion", "idtipoopcionart = " + idTipoOpcionArtPed + " AND referencia = '" + referencia + "'");
    if (idTipoOpcionPed != idTipoOpcion) {
      return this.iface.__obtenerOpcionLote(codLote, idTipoOpcion);
    }
    idMarcada = formRecordlineaspedidoscli.iface.pub_obtenerMarcada();

  } else {
    var idLinea: Number = util.sqlSelect("pr_procesos", "idlineapedidocli", "idobjeto = '" + codLote + "'");
    if (!idLinea) {
      return false;
    }
    idMarcada = util.sqlSelect("lineaspedidoscli", "idopcionarticulo", "idlinea = " + idLinea);
  }
  if (!idMarcada) {
    return false;
  }
  idValorOpcion = util.sqlSelect("opcionesarticulocomp", "idopcion", "idopcionarticulo = " + idMarcada);
  return idValorOpcion;
}
//// PRODSOFA ///////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
