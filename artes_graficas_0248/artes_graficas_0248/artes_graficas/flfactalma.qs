
/** @class_declaration artesG */
/////////////////////////////////////////////////////////////////
//// ARTES GRAFICAS /////////////////////////////////////////////
class artesG extends prod
{
  function artesG(context)
  {
    prod(context);
  }
  function buscarLoteDisponible(curLinea: FLSqlCursor, cantidad: Number, curArticuloComp: FLSqlCursor): Boolean {
    return this.ctx.artesG_buscarLoteDisponible(curLinea, cantidad, curArticuloComp);
  }
  function crearLote(datosArt: Array, cantidad: Number, idLinea: Number): String {
    return this.ctx.artesG_crearLote(datosArt, cantidad, idLinea);
  }
  function crearComposicion(curLoteStock: FLSqlCursor, curComponente: FLSqlCursor, referencia: String, idProceso: String): Boolean {
    return this.ctx.artesG_crearComposicion(curLoteStock, curComponente, referencia, idProceso);
  }
  function consistenciaLinea(curLinea: FLSqlCursor): Boolean {
    return this.ctx.artesG_consistenciaLinea(curLinea);
  }
  function crearConsumoXML(codLoteProd: String, idProceso: String, xmlTarea: FLDomNode, xmlConsumo: FLDomNode): Boolean {
    return this.ctx.artesG_crearConsumoXML(codLoteProd, idProceso, xmlTarea, xmlConsumo);
  }
}
//// ARTES GRAFICAS /////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition artesG */
/////////////////////////////////////////////////////////////////
//// ARTES GRÁFICAS /////////////////////////////////////////////
/** \D Si se trata de un lote de producto de artes gráficas se genera siempre un nuevo lote
@param  cantidad: Cantidad a reservar
@param  curArticuloComp: Cursor del componente cuyo lote se busca, para los casos de fabricación
@return True si la función termina correctamente, false en caso contrario
\end */
function artesG_buscarLoteDisponible(curLinea: FLSqlCursor, cantidad: Number, curArticuloComp: FLSqlCursor): Boolean {
  var util: FLUtil = new FLUtil;
  var codLote: String;
  var referencia: String
  var datosArt: Array;

  if (curLinea.table() != "lineaspedidoscli")
  {
    return this.iface.__buscarLoteDisponible(curLinea, cantidad, curArticuloComp);
  }

  var codFamilia: String = util.sqlSelect("articulos", "codfamilia", "referencia = '" + curLinea.valueBuffer("referencia") + "'");
  if (codFamilia != "PROD")
  {
    return this.iface.__buscarLoteDisponible(curLinea, cantidad, curArticuloComp);
  }

  /*  var fabricado:Boolean = util.sqlSelect("articulos", "fabricado", "referencia = '" + datosArt["referencia"] + "'");*/

  var qryProductos: FLSqlQuery = new FLSqlQuery;
  with(qryProductos)
  {
    setTablesList("productoslp,itinerarioslp");
    setSelect("p.referencia, i.iditinerario");
    setFrom("productoslp p INNER JOIN itinerarioslp i ON p.idproducto = i.idproducto");
    setWhere("p.idlinea = " + curLinea.valueBuffer("idlineapresupuesto") + " AND i.escogido = true");
    setForwardOnly(true);
  }
  if (!qryProductos.exec())
    return false;
  debug(qryProductos.sql());
  while (qryProductos.next())
  {
    datosArt["referencia"] = qryProductos.value("p.referencia");
    datosArt["iditinerario"] = qryProductos.value("i.iditinerario");
    debug("Llamada");
    codLote = this.iface.crearLote(datosArt, 1, curLinea.valueBuffer("idlinea"));
    debug("Fin Llamada");
    if (!codLote) {
      return false;
    }
    //    if (!flcolaproc.iface.pub_crearProcesoProd(datosArt["referencia"], codLote, curLinea.valueBuffer("idlinea"))) {
    //      MessageBox.warning(util.translate("scripts", "Error al crear el proceso para el lote %2").arg(codLote), MessageBox.Ok, MessageBox.NoButton);
    //      return false;
    //    }
    if (!this.iface.generarMoviStock(curLinea, codLote))
      return false;
  }

  return true;
}

function artesG_crearLote(datosArt: Array, cantidad: Number, idLinea: Number): String {
  var curLoteStock: FLSqlCursor = new FLSqlCursor("lotesstock");
  curLoteStock.setModeAccess(curLoteStock.Insert);
  curLoteStock.refreshBuffer();
  curLoteStock.setValueBuffer("referencia", datosArt["referencia"]);
  var codLote: String = formRecordlotesstock.iface.pub_calculateCounter(curLoteStock);
  curLoteStock.setValueBuffer("codlote", codLote);
  curLoteStock.setValueBuffer("estado", "PTE");
  curLoteStock.setValueBuffer("canlote", cantidad);
  curLoteStock.setValueBuffer("cantotal", 0);
  curLoteStock.setValueBuffer("canusada", 0);
  curLoteStock.setValueBuffer("candisponible", 0);
  curLoteStock.setValueBuffer("iditinerario", datosArt["iditinerario"]);
  curLoteStock.setValueBuffer("idlineapc", idLinea);

  if (!curLoteStock.commitBuffer())
    return false;

  return codLote;
}

function artesG_crearComposicion(curLoteStock: FLSqlCursor, curComponente: FLSqlCursor, referencia: String, idProceso: String): Boolean {
  debug("artesG_crearComposicion");
  var util: FLUtil = new FLUtil;

  var codLote: String = curLoteStock.valueBuffer("codlote");
  var refLote: String = curLoteStock.valueBuffer("referencia");
  var codFamilia: String = util.sqlSelect("articulos", "codfamilia", "referencia = '" + refLote + "'");
  if (codFamilia != "PROD")
  {
    return this.iface.__crearComposicion(curLoteStock, curComponente, referencia, idProceso);
  }

  var contenido: String = util.sqlSelect("pr_procesos", "xmlparametros", "idproceso = " + idProceso);
  var xmlDoc: FLDomDocument = new FLDomDocument;
  if (!xmlDoc.setContent(contenido))
  {
    MessageBox.warning(util.translate("scripts", "Crear composición: Error al cargar los parámetros XML del proceso"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  var xmlTareas: FLDomNodeList = xmlDoc.firstChild().namedItem("Tareas").childNodes();
  if (!xmlTareas)
  {
    return false;
  }
  var xmlConsumos: FLDomNodeList;
  for (var i: Number = 0; i < xmlTareas.length(); i++)
  {
    xmlConsumos = xmlTareas.item(i).namedItem("Consumos").childNodes();
    if (!xmlConsumos) {
      continue;
    }
    for (var k: Number = 0; k < xmlConsumos.length(); k++) {
      if (!this.iface.crearConsumoXML(codLote, idProceso, xmlTareas.item(i), xmlConsumos.item(k))) {
        return false;
      }
    }
  }
  return true;
}

function artesG_crearConsumoXML(codLoteProd: String, idProceso: String, xmlTarea: FLDomNode, xmlConsumo: FLDomNode): Boolean {
  debug("artesG_crearConsumoXML");
  var util: FLUtil = new FLUtil;
  var hoy: Date = new Date();
  var eTarea: FLDomElement = xmlTarea.toElement();
  var eConsumo: FLDomElement = xmlConsumo.toElement();

  var referencia: String = eConsumo.attribute("Referencia");
  var idTipoTareaPro: String = eTarea.attribute("IdTipoTareaPro");

  var codAlmacen: String = this.iface.almacenFabricacion();
  var idStock: String = util.sqlSelect("stocks", "idstock", "referencia = '" + referencia + "' AND codalmacen = '" + codAlmacen + "'");
  if (!idStock || idStock == "")
  {
    var datosArt: Array = [];
    datosArt["referencia"] = referencia;
    idStock = this.iface.crearStock(codAlmacen, datosArt);
    if (!idStock || idStock == "") {
      MessageBox.critical(util.translate("scripts", "Error: No pudo crearse el stock para el artículo %1 y el almacén %2").arg(datosArt["referencia"]).arg(codAlmacen), MessageBox.Ok, MessageBox.NoButton);
      return false;
    }
  }

  var curMoviStock: FLSqlCursor = new FLSqlCursor("movistock");
  curMoviStock.setModeAccess(curMoviStock.Insert);
  curMoviStock.refreshBuffer();
  curMoviStock.setValueBuffer("referencia", referencia);
  curMoviStock.setValueBuffer("estado", "PTE");
  curMoviStock.setValueBuffer("cantidad", eConsumo.attribute("Cantidad"));
  curMoviStock.setValueBuffer("fechaprev", hoy.toString());
  curMoviStock.setValueBuffer("idstock", idStock);
  curMoviStock.setValueBuffer("codloteprod", codLoteProd);
  curMoviStock.setValueBuffer("idproceso", idProceso);
  curMoviStock.setValueBuffer("idtipotareapro", idTipoTareaPro);
  curMoviStock.setValueBuffer("idtarea", util.sqlSelect("pr_tareas", "idtarea", "idproceso = " + idProceso + " AND idtipotareapro = " + idTipoTareaPro));
  if (!curMoviStock.commitBuffer())
  {
    return false;
  }
  return true;
}

function artesG_consistenciaLinea(curLinea: FLSqlCursor): Boolean {
  var util: FLUtil = new FLUtil;

  var referencia: String = curLinea.valueBuffer("referencia");
  var codFamilia: String = util.sqlSelect("articulos", "codfamilia", "referencia = '" + referencia + "'");
  if (codFamilia == "PROD")
  {
    return true;
  }

  return this.iface.__consistenciaLinea(curLinea);
}
//// ARTES GRÁFICAS /////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
