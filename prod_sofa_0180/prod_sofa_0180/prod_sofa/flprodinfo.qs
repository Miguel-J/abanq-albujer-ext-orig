
/** @class_declaration prodSofa */
/////////////////////////////////////////////////////////////////
//// PRODSOFA /////////////////////////////////////////////////
class prodSofa extends oficial
{
  var valoresCorte: Array = [];
  function prodSofa(context)
  {
    oficial(context);
  }
  function totalMetrosOC(nodo: FLDomNode, campo: String): String {
    return this.ctx.prodSofa_totalMetrosOC(nodo, campo);
  }
  function desTela(nodo: FLDomNode, campo: String): String {
    return this.ctx.prodSofa_desTela(nodo, campo);
  }
  function observacionesMontaje(nodo: FLDomNode, campo: String): String {
    return this.ctx.prodSofa_observacionesMontaje(nodo, campo);
  }
  /*  function valoresOrdenCorte(nodo:FLDomNode, campo:String):String {
      return this.ctx.prodSofa_valoresOrdenCorte(nodo, campo);
    }
    function ejecutarConsulta(codLote:String):Boolean {
      return this.ctx.prodSofa_ejecutarConsulta(codLote)
    }*/
  function datosEtiCorte(nodo: FLDomNode, campo: String): String {
    return this.ctx.prodSofa_datosEtiCorte(nodo, campo);
  }
}
//// PRODSOFA ///////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pubProdSofa */
/////////////////////////////////////////////////////////////////
//// PUBPRODSOFA ////////////////////////////////////////////////
class pubProdSofa extends ifaceCtx
{
  function pubProdSofa(context)
  {
    ifaceCtx(context);
  }
  function pub_totalMetrosOC(nodo: FLDomNode, campo: String): String {
    return this.totalMetrosOC(nodo, campo);
  }
  function pub_valoresOrdenCorte(nodo: FLDomNode, campo: String): String {
    return this.valoresOrdenCorte(nodo, campo);
  }
  function pub_desTela(nodo: FLDomNode, campo: String): String {
    return this.desTela(nodo, campo);
  }
  function pub_datosEtiCorte(nodo: FLDomNode, campo: String): String {
    return this.datosEtiCorte(nodo, campo);
  }
  function pub_observacionesMontaje(nodo: FLDomNode, campo: String): String {
    return this.observacionesMontaje(nodo, campo);
  }
}
//// PUBPRODSOFA ////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition prodSofa */
/////////////////////////////////////////////////////////////////
//// PRODSOFA ///////////////////////////////////////////////////
/** \D Obtiene la longitud de tela a cortar para una orden de corte
\end */
function prodSofa_totalMetrosOC(nodo: FLDomNode, campo: String): String {
  var codOrden: String = nodo.attributeValue("pr_ordenesproduccion.codorden");
  var util: FLUtil = new FLUtil;
  var totalMetros: Number = 0;

  var qryCortes: FLSqlQuery = new FLSqlQuery;
  with(qryCortes)
  {
    setTablesList("pr_ordenesproduccion,lotesstock,pr_procesos,pr_tareas,pr_tiposproceso,movistock,articulos");
    setSelect("SUM(lineaspedidoscli.cantidad),telascorte.longitud");
    setFrom("pr_ordenesproduccion INNER JOIN lotesstock ON pr_ordenesproduccion.codorden = lotesstock.codordenproduccion LEFT OUTER JOIN pr_procesos ON pr_ordenesproduccion.codorden = pr_procesos.idobjeto INNER JOIN pr_tiposproceso ON pr_tiposproceso.idtipoproceso = pr_procesos.idtipoproceso AND pr_tiposproceso.tipoobjeto = 'pr_ordenesproduccion' LEFT OUTER JOIN pr_tareas ON pr_procesos.idproceso = pr_tareas.idproceso INNER JOIN movistock ON lotesstock.codlote = movistock.codloteprod INNER JOIN lotesstock rollos ON rollos.codlote = movistock.codlote INNER JOIN articulos ON lotesstock.referencia = articulos.referencia INNER JOIN articulos telas ON rollos.referencia = telas.referencia LEFT OUTER JOIN telascorte ON articulos.referencia = telascorte.referencia AND telas.anchura = telascorte.anchura INNER JOIN movistock corte ON movistock.codloteprod = corte.codlote INNER JOIN movistock modulo ON corte.codloteprod = modulo.codlote INNER JOIN lineaspedidoscli ON modulo.idlineapc = lineaspedidoscli.idlinea LEFT OUTER JOIN pedidoscli ON pedidoscli.idpedido = lineaspedidoscli.idpedido")
    setWhere("pr_ordenesproduccion.codorden = '" + codOrden + "' GROUP BY telascorte.longitud");
  }
  if (!qryCortes.exec())
    return false;

  while (qryCortes.next())
    totalMetros += parseFloat(qryCortes.value("SUM(lineaspedidoscli.cantidad)")) * parseFloat(qryCortes.value("telascorte.longitud"));

  return totalMetros;
}

function prodSofa_desTela(nodo: FLDomNode, campo: String): String {
  var util: FLUtil = new FLUtil();
  var valor: String = util.sqlSelect("articulos", "descripcion", "referencia = '" + nodo.attributeValue("movistock.referencia") + "'");
  return valor;
}

function prodSofa_observacionesMontaje(nodo: FLDomNode, campo: String): String {
  var util: FLUtil = new FLUtil();
  var valor: String = nodo.attributeValue("lotesstock.observacionesmontaje");
  var tipoTarea: String = nodo.attributeValue("pr_tareas.idtipotarea");
  if (tipoTarea == "MONTAJE")
    return valor;
  else
    return "";
}

/*function prodSofa_valoresOrdenCorte(nodo:FLDomNode, campo:String):String
{
  var util:FLUtil = new FLUtil();
  var valor:String;

  switch (campo) {
    case "parte": {
      var codLote:String = nodo.attributeValue("lotesstock.codlote");
      this.iface.ejecutarConsulta(codLote);
      valor = this.iface.valoresCorte["parte"];
      break;
    }
    case "tela": {
      valor = this.iface.valoresCorte["tela"];
      break;
    }
    case "rollo": {
      valor = this.iface.valoresCorte["rollo"];
      break;
    }
    case "longitud": {
      valor = this.iface.valoresCorte["longitud"];
      break;
    }
  }

  return valor;
}

function prodSofa_ejecutarConsulta(codLote:String):Boolean
{
  this.iface.valoresCorte["parte"] = "";
  this.iface.valoresCorte["tela"] = "";
  this.iface.valoresCorte["rollo"] = "";
  this.iface.valoresCorte["longitud"] = "";

  var qry:FLSqlQuery = new FLSqlQuery;
  qry.setTablesList("movistock,articuloscomp,tiposopcionartcomp");
  qry.setSelect("ac.desccomponente, ms.referencia, ms.codlote, ms.cantidad");
  qry.setFrom("movistock ms INNER JOIN articuloscomp ac ON ms.idarticulocomp = ac.id ");
  qry.setWhere("ms.codloteprod = '" + codLote + "'");
  qry.setForwardOnly(true);

  if (!qry.exec()) {
    return false;
  }

  while (qry.next()) {
    this.iface.valoresCorte["parte"] += qry.value("ac.desccomponente") + "\n";
    this.iface.valoresCorte["tela"] += qry.value("ms.referencia") + "\n";
    this.iface.valoresCorte["rollo"] += qry.value("ms.codlote") + "\n";
    this.iface.valoresCorte["longitud"] += qry.value("ms.cantidad") + "\n";
  }
  return true;
}*/


function prodSofa_datosEtiCorte(nodo: FLDomNode, campo: String): String {
  var util: FLUtil = new FLUtil();
  var valor: String;

  switch (campo)
  {
      //    case "descripcion":
      //    case "idmodelo":
      //    case "configuracion": {
      //      var codLote:String = nodo.attributeValue("lotesstock.codlote");
      //      var loteProd:String = util.sqlSelect("movistock","codloteprod","codlote = '" + codLote + "'");
      //      if(!loteProd || loteProd == "")
      //        return "";
      //
      //      var referencia:String = util.sqlSelect("lotesstock","referencia","codlote = '" + loteProd + "'");
      //      if (!referencia || referencia == "")
      //        return "";
      //
      //      valor = util.sqlSelect("articulos",campo,"referencia = '" + referencia + "'");
      //      if(!valor)
      //        valor = "";
      //
      //      break;
      //    }
    case "observaciones": {
      var codLote: String = nodo.attributeValue("lotesstock.codlote");
      var loteProd: String = util.sqlSelect("movistock", "codloteprod", "codlote = '" + codLote + "'");
      if (!loteProd || loteProd == "")
        return "";

      var idLinea: Number = util.sqlSelect("movistock", "idlineapc", "codlote = '" + loteProd + "'");
      if (!idLinea)
        return "";

      var idPedido: Number = util.sqlSelect("lineaspedidoscli", "idpedido", "idlinea = " + idLinea);
      if (!idPedido)
        return "";

      valor = util.sqlSelect("pedidoscli", "observaciones", "idpedido = " + idPedido);
      if (!valor)
        valor = "";
      break;
    }
    //    case "rollo": {
    //      var codLote:String = nodo.attributeValue("lotesstock.codlote");
    //      valor = util.sqlSelect("movistock","codlote","codloteprod = '" + codLote + "'");
    //      debug("codLote " + codLote);
    //      debug("valor " + valor);
    //      if(!valor)
    //        valor = "";
    //      break;
    //    }
    //    case "tela": {
    //      var codLote:String = nodo.attributeValue("lotesstock.codlote");
    //      var rollo:String = util.sqlSelect("movistock","codlote","codloteprod = '" + codLote + "'");
    //      if(!rollo || rollo == "")
    //        return "";
    //
    //      var refTela:String = util.sqlSelect("lotesstock","referencia","codlote = '" + rollo + "'");
    //      if(!refTela || refTela == "")
    //        return "";
    //
    //      valor = util.sqlSelect("articulos","descripcion","referencia = '" + refTela + "'");
    //      if (!valor)
    //        valor = "";
    //      break;
    //    }
  }

  return valor;
}
//// PRODSOFA ///////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
