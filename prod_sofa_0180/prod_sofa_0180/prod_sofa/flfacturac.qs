
/** @class_declaration prodSofa */
/////////////////////////////////////////////////////////////////
//// PROD_SOFA //////////////////////////////////////////////////
class prodSofa extends prod
{
  //  var modoOriginal_:String;
  var lotesPedido_: Array;
  function prodSofa(context)
  {
    prod(context);
  }
  function simetrica(param: String): Boolean {
    return this.ctx.prodSofa_simetrica(param);
  }
  //  function setModoOriginal(modo:String) {
  //    return this.ctx.prodSofa_setModoOriginal(modo);
  //  }
  //  function getModoOriginal():String {
  //    return this.ctx.prodSofa_getModoOriginal();
  //  }
  function beforeCommit_lineaspedidoscli(curLP: FLSqlCursor): Boolean  {
    return this.ctx.prodSofa_beforeCommit_lineaspedidoscli(curLP);
  }
  //  function eliminarLote(loteModulo:String):Boolean {
  //    return this.ctx.prodSofa_eliminarLote(loteModulo);
  //  }
  function afterCommit_lineaspedidoscli(curLA: FLSqlCursor): Boolean {
    return this.ctx.prodSofa_afterCommit_lineaspedidoscli(curLA);
  }
}
//// PROD_SOFA //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pubProdSofa */
/////////////////////////////////////////////////////////////////
//// PUB_PRODSOFA ///////////////////////////////////////////////
class pubProdSofa extends ifaceCtx
{
  function pubProdSofa(context)
  {
    ifaceCtx(context);
  }
  function pub_simetrica(param: String): String {
    return this.simetrica(param);
  }
  //  function pub_setModoOriginal(modo:String) {
  //    return this.setModoOriginal(modo);
  //  }
  //  function pub_getModoOriginal():String {
  //    return this.getModoOriginal();
  //  }
  //  function pub_eliminarLote(loteModulo:String):Boolean {
  //    return this.eliminarLote(loteModulo);
  //  }
}
//// PUB_PRODSOFA ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////


/** @class_definition prodSofa */
////////////////////////////////////////////////////////////////
//// PROD_SOFA /////////////////////////////////////////////////
/** \D
Obtiene la cadena simétrica a la especificada
@param  param: Cadena
@return string que es la cadena simétrica a la dada
*/
function prodSofa_simetrica(param: String): String {
  var cadena: String = param.toString();
  var ret: String = "";
  for (var i: Number = (cadena.length - 1); i >= 0; i--)
  {
    ret += cadena.charAt(i);
  }
  return ret;
}

// function prodSofa_setModoOriginal(modo:String)
// {
//  this.iface.modoOriginal_ = modo;
// }
//
// function prodSofa_getModoOriginal():String
// {
//  return this.iface.modoOriginal_;
// }

function prodSofa_beforeCommit_lineaspedidoscli(curLP: FLSqlCursor): Boolean {
  var util: FLUtil;
  var idLinea: Number = curLP.valueBuffer("idlinea");

  var codFamilia: String = util.sqlSelect("articulos", "codfamilia", "referencia = '" + curLP.valueBuffer("referencia") + "'");
  if (codFamilia == "MOD")
  {
    switch (curLP.modeAccess()) {
      case curLP.Del: {
        this.iface.lotesPedido_ = new Array();
        var qryModulos: FLSqlQuery = new FLSqlQuery();
        qryModulos.setTablesList("movistock");
        qryModulos.setSelect("codlote");
        qryModulos.setFrom("movistock");
        qryModulos.setWhere("idlineapc = " + idLinea);

        if (!qryModulos.exec())
          return false;
        while (qryModulos.next()) {
          var loteModulo: String = qryModulos.value("codlote");
          if (!loteModulo || loteModulo == "")
            return false;

          this.iface.lotesPedido_[this.iface.lotesPedido_.length] = loteModulo;
          //
          //          if(!this.iface.eliminarLote(loteModulo))
          //            return false;
        }
        break;
      }
      //      default: {
      //        return this.iface.__beforeCommit_lineaspedidoscli(curLP);
      //        break;
      //      }
    }
  }

  return true;
}

function prodSofa_afterCommit_lineaspedidoscli(curLP: FLSqlCursor): Boolean {
  var util: FLUtil;
  var idLinea: Number = curLP.valueBuffer("idlinea");

  if (!this.iface.__afterCommit_lineaspedidoscli(curLP))
    return false;

  var codFamilia: String = util.sqlSelect("articulos", "codfamilia", "referencia = '" + curLP.valueBuffer("referencia") + "'");

  if (codFamilia == "MOD")
  {
    switch (curLP.modeAccess()) {
      case curLP.Edit: {
        if (curLP.valueBuffer("referencia") != "MOD-TELA-METRAJE") {
          var cantidad: Number = parseInt(curLP.valueBuffer("cantidad"));
          var canLote: Number = parseInt(util.sqlSelect("movistock INNER JOIN lotesstock ON movistock.codlote = lotesstock.codlote", "SUM(lotesstock.canlote)", "movistock.idlineapc = " + idLinea, "lotesstock,movistock"));

          if (cantidad != canLote) {
            var idPedido: Number = curLP.valueBuffer("idpedido");
            var codPedido: String = util.sqlSelect("pedidoscli", "codigo", "idpedido = " + idPedido);
            var res: Number = MessageBox.critical(util.translate("scripts", "ERROR: Para el pedido %3 y el artículo %4 la cantidad de la línea (%1) es distinta a la cantidad de los lotes asociados (%2).\nSi continúa puede dar lugar a un error grave, por favor contacte con Infosial.\n ¿Seguro que desea continuar?").arg(cantidad).arg(canLote).arg(codPedido).arg(curLP.valueBuffer("referencia")), MessageBox.No, MessageBox.Yes);
            if (res != MessageBox.Yes)
              return false;
          }
        }
        break;
      }
      case curLP.Del: {
        var idLinea: Number = curLP.valueBuffer("idlinea");
        for (var i = 0; i < this.iface.lotesPedido_.length; i++) {
          var lote: Boolean = false;
          var movimientos: Boolean = false;
          lote = util.sqlSelect("lotesstock", "codlote", "codLote = '" + this.iface.lotesPedido_[i] + "'");
          movimientos = util.sqlSelect("movistock", "idmovimiento", "codlote = '" + this.iface.lotesPedido_[i] + "' OR codloteprod = '" + this.iface.lotesPedido_[i] + "'");
          if ((lote && lote != "") || (movimientos && movimientos != "")) {
            MessageBox.warning(util.translate("scripts", "Alguno de los lotes asociados al pedido no se ha eliminado correctamente."), MessageBox.Ok, MessageBox.NoButton);
            return false;
          }
        }
        break;
      }
    }
  }

  return true;
}

// function prodSofa_eliminarLote(loteModulo:String):Boolean
// {
//  var util:FLUtil;
//
//  var loteCorte:String = util.sqlSelect("movistock","codlote","codloteprod = '" + loteModulo + "' AND codlote IS NOT NULL AND codlote <> ''");
//  if(!loteCorte || loteCorte == "")
//    return false;
//
//  var qryTareas:FLSqlQuery = new FLSqlQuery();
//  qryTareas.setTablesList("pr_tareas");
//  qryTareas.setSelect("estado,idproceso,idtarea");
//  qryTareas.setFrom("pr_tareas");
//  qryTareas.setWhere("tipoobjeto = 'lotesstock' AND (idobjeto = '" + loteModulo + "' OR idobjeto = '" + loteCorte + "')");
//
//  if (!qryTareas.exec())
//    return false;
//
//  var noPte:Boolean = false;
//  var procesos:String = "";
//  var tareas:String = "";
//  while (qryTareas.next()) {
//    if(qryTareas.value("estado") != "PTE" && qryTareas.value("estado") != "OFF")
//      noPte = true;
//    if(procesos != "")
//      procesos += ",";
//    procesos += qryTareas.value("idproceso");
//    if(tareas != "")
//      tareas += ",";
//    tareas += "'" + qryTareas.value("idtarea") + "'";
//  }
//
//  var referencia:String = util.sqlSelect("lotesstock","referencia","codlote = '" + loteModulo + "'");
//  if(noPte) {
//    var res:Number = MessageBox.information(util.translate("scripts", "El módulo %1 se encuentra en proceso de producción. Si continúa se cancelará el proceso de producción y se sacará de la orden correspondiente. \n¿Desea continuar?").arg(referencia), MessageBox.Yes, MessageBox.No);
//    if(res != MessageBox.Yes)
//      return false;
//  }
//
//  if(tareas && tareas != "") {
//    if(!util.sqlDelete("pr_tareas","idtarea IN (" + tareas + ")"))
//      return false;
//  }
//
//  if(procesos && procesos != "") {
//    var arrayProcesos:Array = procesos.split(",");
//    for(var i=0;i<arrayProcesos.length;i++) {
//      if(!util.sqlSelect("pr_tareas","idtarea","idproceso = " + arrayProcesos[i])) {
//        if(!util.sqlDelete("pr_procesos","idproceso = " + arrayProcesos[i]))
//          return false;
//      }
//    }
//  }
//
//  var qryOrdenes:FLSqlQuery = new FLSqlQuery();
//  qryOrdenes.setTablesList("lotesstock");
//  qryOrdenes.setSelect("codordenproduccion");
//  qryOrdenes.setFrom("lotesstock");
//  qryOrdenes.setWhere("codlote = '" + loteModulo + "' OR codlote = '" + loteCorte + "'");
//
//  if (!qryOrdenes.exec())
//    return false;
//
//  var ordenes:String = "";
//  while (qryOrdenes.next()) {
//    if(ordenes != "")
//      ordenes += ",";
//    ordenes += "'" + qryOrdenes.value("codordenproduccion") + "'";
//  }
//
//  if (!util.sqlUpdate("lotesstock", "codordenproduccion", "NULL",  "codlote = '" + loteModulo + "' OR codlote = '" + loteCorte + "'"))
//    return false;
//
//  if(ordenes && ordenes != "") {
//    var arrayOrdenes:Array = ordenes.split(",");
//    for(var i=0;i<arrayOrdenes.length;i++) {
//      if(!util.sqlSelect("lotesstock","codlote","codordenproduccion = " + arrayOrdenes[i])) {
//        if(!util.sqlDelete("pr_ordenesproduccion","codorden = " + arrayOrdenes[i]))
//          return false;
//      }
//    }
//  }
//  if(!util.sqlDelete("movistock","codlote = '" + loteModulo + "' OR codloteprod = '" + loteModulo + "' OR codlote = '" + loteCorte + "'" ))
//    return false;
//
//  if(!util.sqlSelect("movistock","idmovimiento","codlote = '" + loteModulo + "'")) {
//    if(!util.sqlDelete("lotesstock","codlote = '" + loteModulo + "'"))
//      return false;
//  }
//  if(!util.sqlSelect("movistock","idmovimiento","codlote = '" + loteCorte + "'")) {
//    if(!util.sqlDelete("lotesstock","codlote = '" + loteCorte + "'"))
//      return false;
//  }
//
//  return true;
// }
//// PROD_SOFA /////////////////////////////////////////////////
////////////////////////////////////////////////////////////////
