
/** @class_declaration prodSofa */
/////////////////////////////////////////////////////////////////
//// PROD_SOFA //////////////////////////////////////////////////
class prodSofa extends articuloscomp
{
  var toolButtonPrintEti: Object
  function prodSofa(context)
  {
    articuloscomp(context);
  }
  function init()
  {
    return this.ctx.prodSofa_init();
  }
  function imprimirEti()
  {
    return this.ctx.prodSofa_imprimirEti();
  }
}
//// PROD_SOFA //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition prodSofa */
/////////////////////////////////////////////////////////////////
//// PROD_SOFA //////////////////////////////////////////////////
function prodSofa_init()
{
  this.iface.__init();

  this.iface.toolButtonPrintEti = this.child("toolButtonPrintEti");

  connect(this.iface.toolButtonPrintEti, "clicked()", this, "iface.imprimirEti()");
}

function prodSofa_imprimirEti()
{
  debug("prodSofa_imprimirEti");

  var util: FLUtil;
  if (sys.isLoadedModule("flfactinfo")) {
    var codigo: String;

    if (!this.cursor().isValid())
      return;
    codigo = this.cursor().valueBuffer("codigo");

    var nombreInforme: String = "i_pegasalbaranescli";
    var idAlbaran: Number = util.sqlSelect("albaranescli", "idalbaran", "codigo = '" + codigo + "'");
    debug("idAlbaran " + idAlbaran);
    if (!idAlbaran)
      return;

    var curImprimir: FLSqlCursor = new FLSqlCursor("i_pegasalbaranescli");
    curImprimir.setModeAccess(curImprimir.Insert);
    curImprimir.refreshBuffer();
    curImprimir.setValueBuffer("descripcion", "temp");
    curImprimir.setValueBuffer("d_albaranescli_codigo", codigo);
    curImprimir.setValueBuffer("h_albaranescli_codigo", codigo);
    flfactinfo.iface.pub_lanzarInforme(curImprimir, nombreInforme);
  } else
    flfactppal.iface.pub_msgNoDisponible("Informes");
}
//// PROD_SOFA //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
