
/** @class_declaration rappelServicios */
//////////////////////////////////////////////////////////////////
//// RAPPEL SERVICIOS /////////////////////////////////////////////////////
class rappelServicios extends oficial
{
  function rappelServicios(context)
  {
    oficial(context);
  }
  function copiaLineaServicio(curLineaServicio: FLSqlCursor, idAlbaran: Number): Number {
    return this.ctx.rappelServicios_copiaLineaServicio(curLineaServicio, idAlbaran);
  }
}
//// RAPPEL SERVICIOS /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_definition rappelServicios */
/////////////////////////////////////////////////////////////////
//// RAPPEL SERVICIOS /////////////////////////////////////////////////

/** Copia el dto por rappel si procede
*/
function rappelServicios_copiaLineaServicio(curLineaServicio: FLSqlCursor, idAlbaran: Number): Number {
  var idLinea = this.iface.__copiaLineaServicio(curLineaServicio, idAlbaran);

  var curLA: FLSqlCursor = new FLSqlCursor("lineasalbaranescli");
  curLA.select("idlinea = " + idLinea);
  if (curLA.first())
  {
    curLA.setModeAccess(curLA.Edit);
    curLA.refreshBuffer();
    curLA.setValueBuffer("dtorappel", curLineaServicio.valueBuffer("dtorappel"));
    if (!curLA.commitBuffer())
      return false;
  }

  return idLinea;
}

//// RAPPEL SERVICIOS /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
