
/** @class_declaration prodSofa */
/////////////////////////////////////////////////////////////////
//// PROD_SOFA //////////////////////////////////////////////////
class prodSofa extends prod
{
  function prodSofa(context)
  {
    prod(context);
  }
  function init()
  {
    return this.ctx.prodSofa_init();
  }
  function imprimirP(): Boolean {
    return this.ctx.prodSofa_imprimirP();
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
}
/** \D
Lanza el informe de pegatinas correspondiente a la mercancía recibida
*/
function prodSofa_imprimirP(): Boolean {
  //  var util:FLUtil = new FLUtil();
  //  var masWhere:String = "";
  //  if (!sys.isLoadedModule("flfactinfo")) {
  //    flfactppal.iface.pub_msgNoDisponible("Informes");
  //    return;
  //  }
  //
  //  var opciones:Array = new Array(2);
  //  opciones[0] = "Todos los lotes";
  //  opciones[1] = "Lote seleccionado";
  //  var opcion:Number = flfactppal.iface.pub_elegirOpcion(opciones);
  //  if (opcion < 0)
  //    return false;
  //
  //  var curImprimir:FLSqlCursor = new FLSqlCursor("i_pegasunidadesstock");
  //  curImprimir.setModeAccess(curImprimir.Insert);
  //  curImprimir.refreshBuffer();
  //  curImprimir.setValueBuffer("descripcion", "temp");
  //  curImprimir.setNull("i_lotesstock_codlote");
  //  curImprimir.setNull("i_movistock_idlineaap");
  //  if (opcion == 0) {
  //    var idAlbaran = this.cursor.valueBuffer("idAlbara
  // //     curImprimir.setNull("d_unidadesstock_idunidad");
  // //     curImprimir.setNull("h_unidadesstock_idunidad");
  //  }
  //  else {
  //    curImprimir.setValueBuffer("i_movistock_idlineaap", this.cursor().valueBuffer("idlinea"));
  //  }
  //  flfactinfo.iface.pub_lanzarInforme(curImprimir, "i_pegasunidadesstock", "lotesstock.codlote", "", true, false);
}

//// PROD_SOFA ///////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
