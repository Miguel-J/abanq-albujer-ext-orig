
/** @class_declaration prodSofa */
/////////////////////////////////////////////////////////////////
//// PROD_SOFA //////////////////////////////////////////////////
class prodSofa extends oficial
{
  function prodSofa(context)
  {
    oficial(context);
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
  connect(this.child("tbnImprimirP"), "clicked()", this, "iface.imprimirP");
}
/** \D
Lanza el informe de pegatinas correspondiente a la mercancía recibida
*/
function prodSofa_imprimirP(): Boolean {
  var util: FLUtil = new FLUtil();
  var cursor: FLSqlCursor = this.cursor();

  var masWhere: String = "";
  if (!sys.isLoadedModule("flfactinfo"))
  {
    flfactppal.iface.pub_msgNoDisponible("Informes");
    return;
  }

  var opciones: Array = new Array(2);
  opciones[0] = "Todas las unidades";
  opciones[1] = "Unidad seleccionada";
  var opcion: Number = flfactppal.iface.pub_elegirOpcion(opciones);
  if (opcion < 0)
    return false;

  var curImprimir: FLSqlCursor = new FLSqlCursor("i_pegasunidadesstock");
  curImprimir.setModeAccess(curImprimir.Insert);
  curImprimir.refreshBuffer();
  curImprimir.setValueBuffer("descripcion", "temp");
  curImprimir.setNull("i_lotesstock_codlote");
  if (opcion == 1)
  {
    var idLinea: String = this.child("tdbLineasAlbaranesProv").cursor().valueBuffer("idlinea");
    if (!idLinea)
      return;
    masWhere = "codlote IN (SELECT codlote FROM movistock ms INNER JOIN lineasalbaranesprov lap ON ms.idlineaap = lap.idlinea WHERE lap.idlinea = " + idLinea + ")";
  } else {
    masWhere = "codlote IN (SELECT codlote FROM movistock ms INNER JOIN lineasalbaranesprov lap ON ms.idlineaap = lap.idlinea WHERE lap.idalbaran = " + cursor.valueBuffer("idalbaran") + ")";
  }

  flfactinfo.iface.pub_lanzarInforme(curImprimir, "i_pegasunidadesstock", "lotesstock.codlote", "", false, false, masWhere);
}

//// PROD_SOFA ///////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
