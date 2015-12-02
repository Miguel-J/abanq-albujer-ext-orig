
/** @class_declaration prod */
/////////////////////////////////////////////////////////////////
//// PRODUCCION /////////////////////////////////////////////////
class prod extends oficial
{
  function prod(context)
  {
    oficial(context);
  }
  function imprimir()
  {
    this.ctx.prod_imprimir();
  }
}
//// PRODUCCION /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition prod */
/////////////////////////////////////////////////////////////////
//// PRODUCCION /////////////////////////////////////////////////
/** \D
Imprime la orden de producción seleccionada
Si hay tareas nuevas pendietnes de imprimir preguntrá si se desea imprimir un anexo con esas tareas.
\end */
function prod_imprimir()
{
  var util: FLUtil;

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

  var curImprimir: FLSqlCursor = new FLSqlCursor("pr_i_ordenesproduccion");
  curImprimir.setModeAccess(curImprimir.Insert);
  curImprimir.refreshBuffer();
  curImprimir.setValueBuffer("descripcion", "temp");
  curImprimir.setValueBuffer("d_pr__ordenesproduccion_codorden", codOrden);
  curImprimir.setValueBuffer("h_pr__ordenesproduccion_codorden", codOrden);

  var nombreInforme: String = "pr_i_ordenesproduccion";
  var where: String = "";
  if (util.sqlSelect("pr_tareas INNER JOIN pr_procesos ON pr_tareas.idproceso = pr_procesos.idproceso", "pr_tareas.anexo", "pr_procesos.codordenproduccion = '" + codOrden + "' AND pr_tareas.anexo", "pr_tareas,pr_procesos")) {

    var dialog = new Dialog;
    dialog.caption = "Imprimir Orden";
    dialog.okButtonText = "Aceptar"
                          dialog.cancelButtonText = "Cancelar";

    var normal = new RadioButton;
    normal.text = "Imprimir Normal";
    normal.checked = false;
    dialog.add(normal);

    var anexo = new RadioButton;
    anexo.text = "Imprimir Anexo";
    anexo.checked = true;
    dialog.add(anexo);

    if (!dialog.exec())
      return false;

    if (anexo.checked)
      where = "pr_tareas.anexo";

  }

  flprodinfo.iface.pub_lanzarInforme(curImprimir, nombreInforme, "", "", false, false, where);

  if (where == "pr_tareas.anexo") {
    var res = MessageBox.information(util.translate("scripts", "¿Desea marcar el anexo como impreso?\n(Si elije si no podrá volver a imprimirlo)"), MessageBox.Yes, MessageBox.No);
    if (res == MessageBox.Yes)
      util.sqlUpdate("pr_tareas", "anexo", false, "pr_tareas.idproceso IN (SELECT idproceso from pr_procesos where pr_procesos.codordenproduccion = '" + codOrden + "')");
  }
}
//// PRODUCCION /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
