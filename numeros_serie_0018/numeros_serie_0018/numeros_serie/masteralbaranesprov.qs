
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
//// FUN_NUMEROS_SERIE //////////////////////////////////////////

function funNumSerie_init()
{
  this.iface.__init();
  connect(this.child("toolButtonPrintNS"), "clicked()", this, "iface.imprimirNS");
}

/** \D Copia los datos de una línea de albarán en una línea de factura
@param  curLineaAlbaran: Cursor que contiene los datos a incluir en la línea de factura
@return True si el cálculo se realiza correctamente, false en caso contrario
\end */
function funNumSerie_datosLineaFactura(curLineaAlbaran: FLSqlCursor): Boolean {

  with(this.iface.curLineaFactura)
  {
    setValueBuffer("numserie", curLineaAlbaran.valueBuffer("numserie"));
  }

  if (!this.iface.__datosLineaFactura(curLineaAlbaran))
    return false;

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
    var curImprimir: FLSqlCursor = new FLSqlCursor("i_albaranesprov");
    curImprimir.setModeAccess(curImprimir.Insert);
    curImprimir.refreshBuffer();
    curImprimir.setValueBuffer("descripcion", "temp");
    curImprimir.setValueBuffer("d_albaranesprov_codigo", codigo);
    curImprimir.setValueBuffer("h_albaranesprov_codigo", codigo);
    flfactinfo.iface.pub_lanzarInforme(curImprimir, "i_albaranesprov_ns");
  } else
    flfactppal.iface.pub_msgNoDisponible("Informes");
}

//// FUN_NUMEROS_SERIE /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
