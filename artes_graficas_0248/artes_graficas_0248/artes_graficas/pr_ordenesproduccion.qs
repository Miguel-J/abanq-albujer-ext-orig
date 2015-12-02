
/** @class_declaration artesG */
/////////////////////////////////////////////////////////////////
//// ARTES GRÁFICAS /////////////////////////////////////////////
class artesG extends oficial
{
  function artesG(context)
  {
    oficial(context);
  }
  //  function generarProcesoLote(codLote:String, referencia:String):Boolean {
  //    return this.ctx.artesG_generarProcesoLote(codLote, referencia);
  //  }
}
//// ARTES GRÁFICAS /////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition artesG */
/////////////////////////////////////////////////////////////////
//// ARTES GRÁFICAS /////////////////////////////////////////////
/** \D Genera el proceso de fabricación asociado a un determinado lote
@param  codLote: Código del lote
@param  referencia: Referencia del artículo
@return true si la función termina correctamente, false en caso contrario
\end */
// function artesG_generarProcesoLote(codLote:String, referencia:String):Boolean
// {
//  var util:FLUtil = new FLUtil;
//  var cursor:FLSqlCursor = this.cursor();
//
//  if (cursor.modeAccess() == cursor.Insert) {
//    if (!this.child("tdbLotesStock").cursor().commitBufferCursorRelation())
//      return false;
//  }
//
//  var xmlProceso:FLDomNode = flprodppal.iface.pub_dameXMLProcesoLote(codLote);
//  if (!xmlProceso) {
//    MessageBox.warning(util.translate("scripts", "Error al obtener el documento XML de parámetros correspondiente al lote %1").arg(codLote), MessageBox.Ok, MessageBox.NoButton);
//    return false;
//  }
//  var idTipoProceso:String = util.sqlSelect("articulos", "idtipoproceso", "referencia = '" + referencia + "'");
//  if (!idTipoProceso) {
//    MessageBox.warning(util.translate("scripts", "Error al obtener el tipo de proceso correspondiente al artículo %1").arg(referencia), MessageBox.Ok, MessageBox.NoButton);
//    return false;
//  }
//  var idProceso = flcolaproc.iface.pub_crearProceso(idTipoProceso, "lotesstock", codLote, xmlProceso);
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
//// ARTES GRÁFICAS /////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
