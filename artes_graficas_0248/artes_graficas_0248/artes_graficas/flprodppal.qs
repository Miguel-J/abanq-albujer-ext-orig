
/** @class_declaration artesG */
/////////////////////////////////////////////////////////////////
//// ARTES GRAFICAS /////////////////////////////////////////////
class artesG extends oficial
{
  function artesG(context)
  {
    oficial(context);
  }
  function incluirProcesoOrden(codOrden: String, codLote: String, idProceso: String): Boolean {
    return this.ctx.artesG_incluirProcesoOrden(codOrden, codLote, idProceso);
  }
}
//// ARTES GRAFICAS /////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pubArtesG */
/////////////////////////////////////////////////////////////////
//// PUB_ARTESG /////////////////////////////////////////////////
class pubArtesG extends ifaceCtx
{
  function pubArtesG(context)
  {
    ifaceCtx(context);
  }
  function pub_incluirProcesoOrden(codOrden: String, codLote: String, idProceso: String): Boolean {
    return this.incluirProcesoOrden(codOrden, codLote, idProceso);
  }
}
//// PUB_ARTESG /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition artesG */
/////////////////////////////////////////////////////////////////
//// ARTES GRAFICAS /////////////////////////////////////////////
/** \D Asocia un proceso a una orden de producción
@param  codOrden: Código de orden
@param  codLote: Código del lote
@param  idProceso: Identificador del proceso a activar
@return true si la función termina correctamente, false en caso contrario
\end */
function artesG_incluirProcesoOrden(codOrden: String, codLote: String, idProceso: String): Boolean {
  var util: FLUtil = new FLUtil;
  /// Podrá obtenerse de la tabla de búsqueda
  var idTipoProceso: String = util.sqlSelect("pr_procesos", "idtipoproceso", "idproceso = '" + idProceso + "'");
  if (!idTipoProceso)
  {
    MessageBox.warning(util.translate("scripts", "Error al obtener el tipo de proceso correspondiente al artículo %1").arg(referencia), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }

  if (!flcolaproc.iface.pub_activarProcesoProd(idProceso, false))
  {
    return false;
  }

  //  if (!flprodppal.iface.pub_actualizarTareasProceso(idProceso, codLote, false)) {
  //    return false;
  //  }

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
  {
    return false;
  }

  return true;
}
//// ARTES GRAFICAS /////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
