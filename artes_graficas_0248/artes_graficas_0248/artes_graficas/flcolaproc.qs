
/** @class_declaration artesG */
/////////////////////////////////////////////////////////////////
//// ARTES GRÁFICAS /////////////////////////////////////////////
class artesG extends prod
{
  function artesG(context)
  {
    prod(context);
  }
  function tareaInicialProceso(idTipoProceso: String): Number {
    return this.ctx.artesG_tareaInicialProceso(idTipoProceso);
  }
  function crearXMLParametrosProceso(curLote: FLSqlCursor, xmlProceso: FLDomNode): Boolean {
    return this.ctx.artesG_crearXMLParametrosProceso(curLote, xmlProceso);
  }
  function crearXMLProcesoProd(curProceso: FLSqlCursor): FLDomDocument {
    return this.ctx.artesG_crearXMLProcesoProd(curProceso);
  }
  function datosTareaOFF(curTipoTareaPro: FLSqlCursor, xmlTarea: FLDomNode): Boolean {
    return this.ctx.artesG_datosTareaOFF(curTipoTareaPro, xmlTarea);
  }
  function datosProcesoOFF(referencia: String, codLote: String, idLineaPedidoCli: String): Boolean {
    return this.ctx.artesG_datosProcesoOFF(referencia, codLote, idLineaPedidoCli);
  }
  //  function crearProceso(tipoProceso:String, tipoObjeto:String, idObjeto:String, xmlProceso:FLDomNode):Number {
  //    return this.ctx.artesG_crearProceso(tipoProceso, tipoObjeto, idObjeto, xmlProceso);
  //  }
  function tareasNoSaltadas(idTareasIniciales: Array, idTipoTareaPro: String, tipoProceso: String, idProceso: String, xmlProceso: FLDomNode): Boolean {
    return this.ctx.artesG_tareasNoSaltadas(idTareasIniciales, idTipoTareaPro, tipoProceso, idProceso, xmlProceso);
  }
  function activarSiguientesTareas(curTareas: FLSqlCursor): Boolean {
    return this.ctx.artesG_activarSiguientesTareas(curTareas);
  }
  function desactivarSiguientesTareas(curTareas: FLSqlCursor): Boolean {
    return this.ctx.artesG_desactivarSiguientesTareas(curTareas);
  }
  function convertirTiempoMS(tiempoProceso: Number, idProceso: String): Number {
    return this.ctx.artesG_convertirTiempoMS(tiempoProceso, idProceso);
  }
  function valoresDefectoFiltroS()
  {
    return this.ctx.artesG_valoresDefectoFiltroS();
  }
  function activacionPosibleTarea(idProceso: String, idTipoTareaPro: String, numCiclo: String): Number {
    return this.ctx.artesG_activacionPosibleTarea(idProceso, idTipoTareaPro, numCiclo);
  }
  function activarProcesoProd(idProceso: String, mostrarProgreso: Boolean): Boolean {
    return this.ctx.artesG_activarProcesoProd(idProceso, mostrarProgreso);
  }
  function asignarTareas(idProceso: String, idTipoProceso: String): Boolean {
    return this.ctx.artesG_asignarTareas(idProceso, idTipoProceso);
  }
}
//// ARTES GRÁFICAS /////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pubArtesG */
/////////////////////////////////////////////////////////////////
//// PUB_ARTESG /////////////////////////////////////////////////
class pubArtesG extends pubProd
{
  function pubArtesG(context)
  {
    pubProd(context);
  }
  function pub_tareaInicialProceso(idTipoProceso: String): Number {
    return this.tareaInicialProceso(idTipoProceso);
  }
  //  function pub_crearProceso(tipoProceso:String, tipoObjeto:String, idObjeto:String, xmlProceso:FLDomNode):Number {
  //    return this.crearProceso(tipoProceso, tipoObjeto, idObjeto, xmlProceso);
  //  }
}
//// PUB_ARTESG /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition artesG */
/////////////////////////////////////////////////////////////////
//// ARTES GRÁFICAS /////////////////////////////////////////////
function artesG_tareaInicialProceso(idTipoProceso: String): Number {
  var util: FLUtil = new FLUtil;
  var idTipoTarea: String = util.sqlSelect("pr_tipostareapro", "idtipotareapro", "idtipoproceso = '" + idTipoProceso + "' AND tareainicial = true");

  return idTipoTarea;
}

function artesG_crearXMLParametrosProceso(curLote: FLSqlCursor, xmlProceso: FLDomNode): Boolean {
  return true;
}

function artesG_crearXMLProcesoProd(curProceso: FLSqlCursor): FLDomDocument {
  var util: FLUtil = new FLUtil;
  debug(curProceso.valueBuffer("idobjeto"));
  debug(util.sqlSelect("lotesstock", "iditinerario", "codlote = '" + curProceso.valueBuffer("idobjeto") + "'"));
  var contenido: String = util.sqlSelect("itinerarioslp i INNER JOIN lotesstock ls ON i.iditinerario = ls.iditinerario", "i.xmlparametros", "ls.codlote = '" + curProceso.valueBuffer("idobjeto") + "'", "itinerarioslp,lotesstock");
  if (!contenido)
  {
    MessageBox.warning(util.translate("scripts", "Error al buscar los parámetros del itinerario asociado al proceso %1").arg(curProceso.valueBuffer("idproceso")), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  var docXMLProceso: FLDomDocument = new FLDomDocument;
  if (!docXMLProceso.setContent(contenido))
  {
    MessageBox.warning(util.translate("scripts", "Error al establecer los parámetros XML del itinerario asociado al proceso %1").arg(curProceso.valueBuffer("idproceso")), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  return docXMLProceso;
}

function artesG_datosTareaOFF(curTipoTareaPro: FLSqlCursor, xmlTarea: FLDomNode): Boolean {
  var util: FLUtil = new FLUtil;

  var desProceso: String = xmlTarea.parentNode().parentNode().toElement().attribute("Desc");
  var desTarea: String = desProceso + ": " + curTipoTareaPro.valueBuffer("descripcion");
  if (desTarea.length > 197)
  {
    desTarea = desTarea.left(197) + "...";
  }
  if (xmlTarea)
  {
    var eTarea: FLDomElement = xmlTarea.toElement();
    var codCentro: String = util.sqlSelect("pr_centroscoste", "codcentro", "codtipocentro = '" + eTarea.attribute("CodTipoCentro") + "' ORDER BY codcentro");
    var prioridad: String = util.sqlSelect("pr_procesos p INNER JOIN lineaspedidoscli lp ON p.idlineapedidocli = lp.idlinea INNER JOIN pedidoscli pe ON lp.idpedido = pe.idpedido INNER JOIN clientes c ON pe.codcliente = c.codcliente", "c.prioridad", "p.idproceso = " + this.iface.curTareas_.valueBuffer("idproceso"), "pr_procesos,lineaspedidoscli,pedidoscli,clientes");
    var hoy: Date = new Date;
    with(this.iface.curTareas_) {
      setValueBuffer("observaciones", eTarea.attribute("Instrucciones"));
      setValueBuffer("descripcion", desTarea);
      setValueBuffer("codcentro", codCentro);
      setValueBuffer("prioridad", prioridad);
      setValueBuffer("diainicio", hoy.toString());
    }
  }
  return true;
}

function artesG_datosProcesoOFF(referencia: String, codLote: String, idLineaPedidoCli: String): Boolean {
  var util: FLUtil = new FLUtil;
  var datosProceso: Array = flfactppal.iface.pub_ejecutarQry("lineaspedidoscli lp INNER JOIN pedidoscli p ON lp.idpedido = p.idpedido", "lp.descripcion,p.nombrecliente", "lp.idlinea = " + idLineaPedidoCli, "lineaspedidoscli,pedidoscli");
  if (datosProceso["result"] == -1)
  {
    MessageBox.warning(util.translate("scripts", "Error al obtener la descripción del proceso"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  if (idLineaPedidoCli)
  {
    this.iface.curProceso_.setValueBuffer("idlineapedidocli", idLineaPedidoCli);
    this.iface.curProceso_.setValueBuffer("descripcion", datosProceso["p.nombrecliente"] + " - " + datosProceso["lp.descripcion"]);
  }
  return true;
}

/** \D Activa las tareas siguientes a una determinada tarea, según las secuencias en las que dicha tarea es la tarea inicial
\param  curTareas: Cursor con las tarea inicial
\end */
function artesG_activarSiguientesTareas(curTareas: FLSqlCursor): Boolean {
  return true; /// Todas las tareas se activan al iniciarse el proceso
  // debug("prod_activarSiguientesTareas");
  var tipoObjeto: String = curTareas.valueBuffer("tipoobjeto");
  if (tipoObjeto != "lotesstock")
  {
    return this.iface.__activarSiguientesTareas(curTareas);
  }

  var util: FLUtil = new FLUtil;
  var idTipoTareaPro: String = curTareas.valueBuffer("idtipotareapro");
  var idProceso: String = curTareas.valueBuffer("idproceso");
  var tipoProceso: String = util.sqlSelect("pr_procesos", "idtipoproceso", "idproceso = " + idProceso);
  var idObjeto: String = curTareas.valueBuffer("idobjeto");

  var xmlProceso: FLDomNode = this.iface.dameXMLProceso(idProceso);
  var xmlTarea: FLDomNode = flfacturac.iface.pub_dameNodoXML(xmlProceso, "Tareas/Tarea[@IdTipoTareaPro=" + idTipoTareaPro + "]");
  if (!xmlTarea)
  {
    return false;
  }

  var xmlSiguientesTareas: FLDomNodeList = xmlTarea.elementsByTagName("SiguienteTarea");
  var idSiguienteTarea: String;
  var idTareasiniciales: Array;

  if (xmlSiguientesTareas)
  {
    for (var i: Number = 0; i < xmlSiguientesTareas.length(); i++) {
      idSiguienteTarea = xmlSiguientesTareas.item(i).toElement().attribute("IdTipoTareaPro");

      idTareasIniciales = [];
      if (!this.iface.tareasNoSaltadas(idTareasIniciales, idSiguienteTarea, tipoProceso, idProceso, xmlProceso)) {
        return false;
      }
      for (var i: Number = 0; i < idTareasIniciales.length; i++) {
        debug("idtarea = " + idTareasIniciales[i]);
        if (!this.iface.activarTarea(curTareas, idTareasIniciales[i])) {
          return false; // Hola
        }
      }
    }
  }

  if (!util.sqlSelect("pr_tareas", "idtarea", "idproceso = " + idProceso + " AND estado <> 'TERMINADA'"))
  {
    if (!this.iface.terminarProceso(idProceso)) {
      return false;
    }
  }

  return true;
}

/** \D Activa las tareas siguientes a una determinada tarea, según las secuencias en las que dicha tarea es la tarea inicial
\param  curTareas: Cursor con las tarea inicial
\end */
function artesG_desactivarSiguientesTareas(curTareas: FLSqlCursor): Boolean {
  return true; /// Todas las tareas se activan al iniciarse el proceso
  // debug("prod_activarSiguientesTareas");
  var tipoObjeto: String = curTareas.valueBuffer("tipoobjeto");
  if (tipoObjeto != "lotesstock")
  {
    return this.iface.__desactivarSiguientesTareas(curTareas);
  }

  var util: FLUtil = new FLUtil;
  var idTipoTareaPro: String = curTareas.valueBuffer("idtipotareapro");
  var idProceso: String = curTareas.valueBuffer("idproceso");
  var tipoProceso: String = util.sqlSelect("pr_procesos", "idtipoproceso", "idproceso = " + idProceso);
  var idObjeto: String = curTareas.valueBuffer("idobjeto");

  var xmlProceso: FLDomNode = this.iface.dameXMLProceso(idProceso);
  var xmlTarea: FLDomNode = flfacturac.iface.pub_dameNodoXML(xmlProceso, "Tareas/Tarea[@IdTipoTareaPro=" + idTipoTareaPro + "]");
  if (!xmlTarea)
  {
    return false;
  }

  var xmlSiguientesTareas: FLDomNodeList = xmlTarea.elementsByTagName("SiguienteTarea");
  if (!xmlSiguientesTareas || xmlSiguientesTareas.length() == 0)
  {
    if (!this.iface.deshacerProcesoTerminado(idProceso)) {
      return false;
    }
  }

  var idSiguienteTarea: String;
  var idTareasiniciales: Array;

  if (xmlSiguientesTareas)
  {
    for (var i: Number = 0; i < xmlSiguientesTareas.length(); i++) {
      idSiguienteTarea = xmlSiguientesTareas.item(i).toElement().attribute("IdTipoTareaPro");

      idTareasIniciales = [];
      if (!this.iface.tareasNoSaltadas(idTareasIniciales, idSiguienteTarea, tipoProceso, idProceso, xmlProceso)) {
        return false;
      }
      for (var i: Number = 0; i < idTareasIniciales.length; i++) {
        if (util.sqlSelect("pr_tareas", "estado", "idproceso = " + idProceso + " AND idtipotareapro = " + idTareasIniciales[i]) != "PTE") {
          MessageBox.warning(util.translate("scripts", "La tarea a deshacer debe tener todas sus tareas subsiguientes en estado OFF o PTE"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
          return false;
        }
        if (!util.sqlUpdate("pr_tareas", "estado", "OFF", "idproceso = " + idProceso + " AND idtipotareapro = " + idTareasIniciales[i])) {
          return false;
        }
      }
    }
  }

  return true;
}

function artesG_tareasNoSaltadas(idTareasIniciales: Array, idTipoTareaPro: String, tipoProceso: String, idProceso: String, xmlProceso: FLDomNode): Boolean {
  var util: FLUtil = new FLUtil();

  var xmlTarea: FLDomNode = false;
  // debug(idTipoTareaPro);
  if (xmlProceso)
  {
    // debug("hay proceso");
    // var d:FLDomDocument = new FLDomDocument;
    // d.appendChild(xmlProceso.cloneNode());
    // debug(d.toString(4));
    xmlTarea = flprodppal.iface.pub_dameNodoXML(xmlProceso, "Tareas/Tarea[@IdTipoTareaPro=" + idTipoTareaPro + "]");
  }
  var saltada: Boolean = false;
  if (!xmlTarea)
  {
    return false;
  }

  if (xmlTarea.toElement().attribute("Estado") != "Saltada")
  {
    idTareasIniciales[idTareasIniciales.length] = idTipoTareaPro; ///util.sqlSelect("pr_tareas", "idtipotarea", "idproceso = '" + idProceso + "' AND idtipotareapro = " + idTipoTareaPro);
  } else {

    var xmlSiguientesTareas: FLDomNodeList = xmlTarea.elementsByTagName("SiguienteTarea");
    var idSiguienteTarea: String;

    if (xmlSiguientesTareas)
    {
      for (var i: Number = 0; i < xmlSiguientesTareas.length(); i++) {
        idSiguienteTarea = xmlSiguientesTareas.item(i).toElement().attribute("IdTipoTareaPro");

        if (!this.iface.tareasNoSaltadas(idTareasIniciales, idSiguienteTarea, tipoProceso, idProceso, xmlProceso)) {
          return false;
        }
      }
    }
  }
  return true;
}

function artesG_convertirTiempoMS(tiempoProceso: Number, idProceso: String): Number {
  var util: FLUtil = new FLUtil;
  var valor: Number;
  var unidades: String;
  unidades = util.sqlSelect("pr_procesos p INNER JOIN pr_tiposproceso tp ON p.idtipoproceso = tp.idtipoproceso", "tp.unidad", "p.idproceso = " + idProceso, "pr_procesos,pr_tiposproceso");
  switch (unidades)
  {
    case "Segundos": {
      valor = tiempoProceso;
      break;
    }
    case "Minutos": {
      valor = tiempoProceso * 60;
      break;
    }
    case "Horas": {
      valor = tiempoProceso * 60 * 60;
      break;
    }
    case "Días": {
      valor = tiempoProceso * 24 * 60 * 60;
      break;
    }
  }
  valor = valor * 1000;
  return valor;
}

function artesG_valoresDefectoFiltroS()
{
  if (!this.iface.container_)
    return this.iface.__valoresDefectoFiltroS();

  if (!this.iface.container_.cursor())
    return this.iface.__valoresDefectoFiltroS();

  var accionContenedor: String = this.iface.container_.cursor().action();
  switch (accionContenedor) {
    case "pr_terminal": {
      if (this.iface.chkMiasS) {
        this.iface.chkMiasS.checked = true;
      }
      if (this.iface.chkDeMiGrupoS) {
        this.iface.chkDeMiGrupoS.checked = true;
      }
      break;
    }
    default: {
      this.iface.__valoresDefectoFiltroS();
    }
  }
}

/** \D Todas las tareas son activadas sin comprobar si sus predecesoras han terminado
\end */
function artesG_activacionPosibleTarea(idProceso: String, idTipoTareaPro: String, numCiclo: String): Number {
  return 1;
}

/** \D Activa (pone en estado PTE) un proceso de producción. Activa todas las tareas excepto las tareas saltadas
@param  idProceso: Identificador del proceso
\end */
function artesG_activarProcesoProd(idProceso: String, mostrarProgreso: Boolean): Boolean {
  var util: FLUtil = new FLUtil;

  var curProceso: FLSqlCursor = new FLSqlCursor("pr_procesos");
  curProceso.select("idproceso = " + idProceso);
  if (!curProceso.first())
  {
    MessageBox.warning(util.translate("scripts", "Error al activar el proceso %1: El proceso no existe").arg(idProceso), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  if (curProceso.valueBuffer("estado") != "OFF")
  {
    MessageBox.warning(util.translate("scripts", "Error al activar el proceso %1: El proceso no está en estado OFF").arg(idProceso), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  var idTipoProceso: String = curProceso.valueBuffer("idtipoproceso");
  var codLote: String = curProceso.valueBuffer("idobjeto");
  with(curProceso)
  {
    setModeAccess(curProceso.Edit);
    refreshBuffer();
    setValueBuffer("estado", "PTE");
  }
  if (!curProceso.commitBuffer())
  {
    return false;
  }

  var xmlProceso: FLDomNode = this.iface.dameXMLProceso(idProceso);

  var qryTareasIniciales: FLSqlQuery = new FLSqlQuery;
  with(qryTareasIniciales)
  {
    setTablesList("pr_tipostareapro");
    setSelect("idtipotareapro");
    setFrom("pr_tipostareapro");
    setWhere("idtipoproceso = '" + idTipoProceso + "'");
    setForwardOnly(true);
  }
  if (!qryTareasIniciales.exec())
  {
    return false;
  }

  if (mostrarProgreso)
  {
    util.createProgressDialog(util.translate("scripts", "Activando tareas ..."), qryTareasIniciales.size());
  }
  var progress: Number = 0;

  var idTipoTareaPro: String;
  var xmlTarea: FLDomNode;
  while (qryTareasIniciales.next())
  {
    if (mostrarProgreso) {
      util.setProgress(progress++);
    }
    idTipoTareaPro = qryTareasIniciales.value("idtipotareapro");

    xmlTarea = flprodppal.iface.pub_dameNodoXML(xmlProceso, "Tareas/Tarea[@IdTipoTareaPro=" + idTipoTareaPro + "]");
    if (!xmlTarea) {
      continue;
    }
    if (xmlTarea.toElement().attribute("Estado") == "Saltada") {
      continue;
    }

    if (!this.iface.activarTarea(curProceso, idTipoTareaPro)) {
      if (mostrarProgreso) {
        util.destroyProgressDialog();
      }
      return false;
    }
  }

  if (mostrarProgreso)
  {
    util.destroyProgressDialog();
  }
  return idProceso;
}

function artesG_asignarTareas(idProceso: String, idTipoProceso: String): Boolean {
  var util: FLUtil = new FLUtil;
  var arrayAlias: Array = [];
  var qryAlias: FLSqlQuery = new FLSqlQuery();

  qryAlias.setTablesList("pr_aliasproceso");
  qryAlias.setSelect("idalias, alias, idusuariodef, idgrupodef");
  qryAlias.setFrom("pr_aliasproceso");
  qryAlias.setWhere("idtipoproceso = '" + idTipoProceso + "'");
  qryAlias.setForwardOnly(true);
  if (!qryAlias.exec())
  {
    return false;
  }

  var usuarioActual: String = sys.nameUser();
  var idUser: String;
  var idGroup: String;
  var idAsignacion: String;
  while (qryAlias.next())
  {
    var qryAsignarAlias: FLSqlQuery = new FLSqlQuery;
    qryAsignarAlias.setTablesList("pr_tareas,pr_tipostareapro");
    qryAsignarAlias.setSelect("t.idtarea");
    qryAsignarAlias.setFrom("pr_tareas t INNER JOIN pr_tipostareapro tp ON t.idtipotareapro = tp.idtipotareapro");
    qryAsignarAlias.setWhere("t.idproceso = " + idProceso + " AND tp.idalias = " + qryAlias.value("idalias"));
    qryAsignarAlias.setForwardOnly(true);
    if (!qryAsignarAlias.exec()) {
      return false;
    }
    while (qryAsignarAlias.next()) {
      idUser = qryAlias.value("idusuariodef");
      if (!idUser) {
        idUser = "NULL";
      }
      idGroup = qryAlias.value("idgrupodef");;
      if (!idGroup) {
        idGroup = "NULL";
      }
      if (!util.sqlUpdate("pr_tareas", "iduser,idgroup", idUser + "," + idGroup, "idtarea = '" + qryAsignarAlias.value("t.idtarea") + "'")) {
        return false;
      }
    }
  }

  return true;
}
//// ARTES GRÁFICAS /////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
