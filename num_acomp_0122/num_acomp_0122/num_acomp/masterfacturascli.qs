
/** @class_declaration funNumAcomp */
//////////////////////////////////////////////////////////////////
//// FUN_NUM_ACOMP /////////////////////////////////////////////////////

class funNumAcomp extends funNumSerie
{
  function funNumAcomp(context)
  {
    funNumSerie(context);
  }
  function imprimirNS()
  {
    return this.ctx.funNumAcomp_imprimirNS();
  }
}

//// FUN_NUM_ACOMP /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_definition funNumAcomp */
/////////////////////////////////////////////////////////////////
//// FUN_NUM_ACOMP /////////////////////////////////////////////////

/** \C
Opción de imprimir compuestos con NS
\end */
function funNumAcomp_imprimirNS()
{
  if (sys.isLoadedModule("flfactinfo")) {
    var util: FLUtil = new FLUtil();
    if (!this.cursor().isValid())
      return;

    var dialog: Dialog = new Dialog(util.translate("scripts", "Imprimir Factura"), 0, "imprimir");

    dialog.OKButtonText = util.translate("scripts", "Aceptar");
    dialog.cancelButtonText = util.translate("scripts", "Cancelar");

    var bgroup: GroupBox = new GroupBox;
    dialog.add(bgroup);

    var impFactura: CheckBox = new CheckBox;
    impFactura.text = util.translate("scripts", "Imprimir artículos con sus componentes");
    impFactura.checked = false;
    bgroup.add(impFactura);

    if (!dialog.exec())
      return true;

    var nombreInforme: String;

    if (impFactura.checked == true) {
      nombreInforme = "i_facturasclicomp_ns";
      flfactinfo.iface.pub_crearTabla("FC", this.cursor().valueBuffer("idfactura"));
    } else
      nombreInforme = "i_facturascli_ns";

    var codigo: String = this.cursor().valueBuffer("codigo");
    var curImprimir: FLSqlCursor = new FLSqlCursor("i_facturascli");
    curImprimir.setModeAccess(curImprimir.Insert);
    curImprimir.refreshBuffer();
    curImprimir.setValueBuffer("descripcion", "temp");
    curImprimir.setValueBuffer("d_facturascli_codigo", codigo);
    curImprimir.setValueBuffer("h_facturascli_codigo", codigo);

    flfactinfo.iface.pub_lanzarInforme(curImprimir, nombreInforme);
  } else
    flfactppal.iface.pub_msgNoDisponible("Informes");
}

//// FUN_NUM_ACOMP /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
