
/** @class_declaration funNumAcomp */
//////////////////////////////////////////////////////////////////
//// FUN_NUM_ACOMP /////////////////////////////////////////////////////

class funNumAcomp extends funNumSerie
{
  function funNumAcomp(context)
  {
    funNumSerie(context);
  }
  function copiaLineaAlbaran(curLineaAlbaran: FLSqlCursor, idFactura: Number): Number {
    return this.ctx.funNumAcomp_copiaLineaAlbaran(curLineaAlbaran, idFactura);
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

/** \D Si la línea es de un compuesto, crea las líneas de factura por NS si procede
@param  curLineaAlbaran: Cursor que contiene los datos a incluir en la línea de factura
@return True si la copia se realiza correctamente, false en caso contrario
\end */
function funNumAcomp_copiaLineaAlbaran(curLineaAlbaran: FLSqlCursor, idFactura: Number): Number {
  var idLinea = this.iface.__copiaLineaAlbaran(curLineaAlbaran, idFactura);
  if (!idLinea)
    return false;

  var util: FLUtil = new FLUtil;

  var curLNA: FLSqlCursor = new FLSqlCursor("lineasalbaranesclins");
  var curLNF: FLSqlCursor = new FLSqlCursor("lineasfacturasclins");

  curLNA.select("idlineaalbaran = " + curLineaAlbaran.valueBuffer("idlinea"));
  while (curLNA.next())
  {

    if (!curLNA.valueBuffer("numserie")) {
      MessageBox.warning(util.translate("scripts", "No es posible generar la factura.\n\nEl albarán contiene componentes de artículos compuestos\ncuyo número de serie no se ha establecido"), MessageBox.Ok, MessageBox.NoButton);
      return false;
    }

    curLNF.setModeAccess(curLNF.Insert);
    curLNF.refreshBuffer();
    curLNF.setValueBuffer("idlineafactura", idLinea);
    curLNF.setValueBuffer("referencia", curLNA.valueBuffer("referencia"));
    curLNF.setValueBuffer("numserie", curLNA.valueBuffer("numserie"));
    curLNF.commitBuffer();
  }

  return true;
}

/** \C
Opción de imprimir compuestos con NS
\end */
function funNumAcomp_imprimirNS()
{
  if (sys.isLoadedModule("flfactinfo")) {
    var util: FLUtil = new FLUtil();
    if (!this.cursor().isValid())
      return;

    var dialog: Dialog = new Dialog(util.translate("scripts", "Imprimir Albaran"), 0, "imprimir");

    dialog.OKButtonText = util.translate("scripts", "Aceptar");
    dialog.cancelButtonText = util.translate("scripts", "Cancelar");

    var bgroup: GroupBox = new GroupBox;
    dialog.add(bgroup);

    var impAlbaran: CheckBox = new CheckBox;
    impAlbaran.text = util.translate("scripts", "Imprimir artículos con sus componentes");
    impAlbaran.checked = false;
    bgroup.add(impAlbaran);

    if (!dialog.exec())
      return true;

    var nombreInforme: String;

    if (impAlbaran.checked == true) {
      nombreInforme = "i_albaranesclicomp_ns";
      flfactinfo.iface.pub_crearTabla("AC", this.cursor().valueBuffer("idalbaran"));
    } else
      nombreInforme = "i_albaranescli_ns";

    var codigo: String = this.cursor().valueBuffer("codigo");
    var curImprimir: FLSqlCursor = new FLSqlCursor("i_albaranescli");
    curImprimir.setModeAccess(curImprimir.Insert);
    curImprimir.refreshBuffer();
    curImprimir.setValueBuffer("descripcion", "temp");
    curImprimir.setValueBuffer("d_albaranescli_codigo", codigo);
    curImprimir.setValueBuffer("h_albaranescli_codigo", codigo);

    flfactinfo.iface.pub_lanzarInforme(curImprimir, nombreInforme);
  } else
    flfactppal.iface.pub_msgNoDisponible("Informes");
}

//// FUN_NUM_ACOMP /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
