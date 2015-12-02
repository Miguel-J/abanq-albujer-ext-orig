
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

/** \C
Al pulsar el botón imprimir se lanzará el informe correspondiente al albarán seleccionado imcluyendo la impresión de números de serie
\end */
function funNumSerie_imprimirNS()
{
  if (sys.isLoadedModule("flfactinfo")) {
    if (!this.cursor().isValid())
      return;
    var codigo: String = this.cursor().valueBuffer("codigo");
    var curImprimir: FLSqlCursor = new FLSqlCursor("i_facturasprov");
    curImprimir.setModeAccess(curImprimir.Insert);
    curImprimir.refreshBuffer();
    curImprimir.setValueBuffer("descripcion", "temp");
    curImprimir.setValueBuffer("d_facturasprov_codigo", codigo);
    curImprimir.setValueBuffer("h_facturasprov_codigo", codigo);
    flfactinfo.iface.pub_lanzarInforme(curImprimir, "i_facturasprov_ns");
  } else
    flfactppal.iface.pub_msgNoDisponible("Informes");
}

//// FUN_NUMEROS_SERIE /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

