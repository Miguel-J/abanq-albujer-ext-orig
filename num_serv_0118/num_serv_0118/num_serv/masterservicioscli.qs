
/** @class_declaration nsServicios */
//////////////////////////////////////////////////////////////////
//// NS_SERVICIOS /////////////////////////////////////////////////////
class nsServicios extends oficial
{
  function nsServicios(context)
  {
    oficial(context);
  }
  function init()
  {
    return this.ctx.nsServicios_init();
  }
  function imprimirNS()
  {
    return this.ctx.nsServicios_imprimirNS();
  }
  function copiaLineaServicio(curLineaServicio: FLSqlCursor, idAlbaran: Number): Number {
    return this.ctx.nsServicios_copiaLineaServicio(curLineaServicio, idAlbaran);
  }
}
//// NS_SERVICIOS /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_definition nsServicios */
/////////////////////////////////////////////////////////////////
//// NS_SERVICIOS /////////////////////////////////////////////////

function nsServicios_init()
{
  this.iface.__init();
  connect(this.child("toolButtonPrintNS"), "clicked()", this, "iface.imprimirNS");
}

/** \D
Imprime los números de serie
\end */
function nsServicios_imprimirNS()
{
  var util: FLUtil = new FLUtil;

  if (sys.isLoadedModule("flfactinfo")) {
    if (!this.cursor().isValid())
      return;
    var numServicio: String = this.cursor().valueBuffer("numservicio");
    var curImprimir: FLSqlCursor = new FLSqlCursor("i_servicioscli");
    curImprimir.setModeAccess(curImprimir.Insert);
    curImprimir.refreshBuffer();
    curImprimir.setValueBuffer("descripcion", "temp");
    curImprimir.setValueBuffer("d_servicioscli_numservicio", numServicio);
    curImprimir.setValueBuffer("h_servicioscli_numservicio", numServicio);
    flfactinfo.iface.pub_lanzarInforme(curImprimir, "i_servicioscli", "", "", false, false, "", "i_servicioscli_ns");
  } else
    flfactppal.iface.pub_msgNoDisponible("Informes");
}

/** Copia el número de serie si procede
*/
function nsServicios_copiaLineaServicio(curLineaServicio: FLSqlCursor, idAlbaran: Number): Number {
  var idLinea = this.iface.__copiaLineaServicio(curLineaServicio, idAlbaran);

  if (!curLineaServicio.valueBuffer("numserie"))
    return idLinea;

  var curLA: FLSqlCursor = new FLSqlCursor("lineasalbaranescli");
  curLA.select("idlinea = " + idLinea);
  if (curLA.first())
  {
    curLA.setModeAccess(curLA.Edit);
    curLA.refreshBuffer();
    curLA.setValueBuffer("numserie", curLineaServicio.valueBuffer("numserie"));
    if (!curLA.commitBuffer())
      return false;
  }

  return idLinea;
}

//// NS_SERVICIOS /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
