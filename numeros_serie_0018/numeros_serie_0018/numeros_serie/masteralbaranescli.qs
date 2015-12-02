
/** @class_declaration funNumSerie */
/////////////////////////////////////////////////////////////////
//// FUN_NUMEROS_SERIE /////////////////////////////////////////////////
class funNumSerie extends oficial
{
  function funNumSerie(context)
  {
    oficial(context);
  }
  function init()
  {
    this.ctx.funNumSerie_init();
  }
  function imprimirNS()
  {
    return this.ctx.funNumSerie_imprimirNS();
  }
  function datosLineaFactura(curLineaAlbaran: FLSqlCursor): Boolean {
    return this.ctx.funNumSerie_datosLineaFactura(curLineaAlbaran);
  }
}
//// FUN_NUMEROS_SERIE //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////


/** @class_definition funNumSerie */
/////////////////////////////////////////////////////////////////
//// FUN_NUMEROS_SERIE /////////////////////////////////////////////////

function funNumSerie_init()
{
  this.iface.__init();
  connect(this.child("toolButtonPrintNS"), "clicked()", this, "iface.imprimirNS");
}

/** \D Copia los datos de una línea de albarán en una línea de factura
@param  curLineaAlbaran: Cursor que contiene los datos a incluir en la línea de factura
@return True si la copia se realiza correctamente, false en caso contrario
\end */
function funNumSerie_datosLineaFactura(curLineaAlbaran: FLSqlCursor): Boolean {
  if (!this.iface.__datosLineaFactura(curLineaAlbaran))
    return false;

  with(this.iface.curLineaFactura)
  {
    setValueBuffer("numserie", curLineaAlbaran.valueBuffer("numserie"));
  }
  return true;
}


/** \C
Al pulsar el botón imprimir se lanzará el informe correspondiente al albarán seleccionado imcluyendo la impresión de números de serie
\end */
function funNumSerie_imprimirNS()
{
  if (sys.isLoadedModule("flfactinfo")) {
    if (!this.cursor().isValid())
      return;
    var codigo: String = this.cursor().valueBuffer("codigo");
    var curImprimir: FLSqlCursor = new FLSqlCursor("i_albaranescli");
    curImprimir.setModeAccess(curImprimir.Insert);
    curImprimir.refreshBuffer();
    curImprimir.setValueBuffer("descripcion", "temp");
    curImprimir.setValueBuffer("d_albaranescli_codigo", codigo);
    curImprimir.setValueBuffer("h_albaranescli_codigo", codigo);
    flfactinfo.iface.pub_lanzarInforme(curImprimir, "i_albaranescli_ns");
  } else
    flfactppal.iface.pub_msgNoDisponible("Informes");
}

//// FUN_NUMEROS_SERIE /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
