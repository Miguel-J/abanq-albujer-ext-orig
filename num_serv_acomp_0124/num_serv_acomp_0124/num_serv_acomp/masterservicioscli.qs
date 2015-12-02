
/** @class_declaration funNumServAcomp */
//////////////////////////////////////////////////////////////////
//// FUN_NUM_SERV_ACOMP /////////////////////////////////////////////////////

class funNumServAcomp extends nsServicios
{
  function funNumServAcomp(context)
  {
    nsServicios(context);
  }
  function copiaLineaServicio(curLineaServicio: FLSqlCursor, idAlbaran: Number): Number {
    return this.ctx.funNumServAcomp_copiaLineaServicio(curLineaServicio, idAlbaran);
  }
}

//// FUN_NUM_SERV_ACOMP /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////


/** @class_definition funNumServAcomp */
/////////////////////////////////////////////////////////////////
//// FUN_NUM_SERV_ACOMP /////////////////////////////////////////////////

/** \D Si la línea es de un compuesto, crea las líneas de factura por NS si procede
@param  curLineaServicio: Cursor que contiene los datos a incluir en la línea de factura
@return True si la copia se realiza correctamente, false en caso contrario
\end */
function funNumServAcomp_copiaLineaServicio(curLineaServicio: FLSqlCursor, idAlbaran: Number): Number {
  var idLinea = this.iface.__copiaLineaServicio(curLineaServicio, idAlbaran);
  if (!idLinea)
    return false;

  var util: FLUtil = new FLUtil;

  var curLNS: FLSqlCursor = new FLSqlCursor("lineasserviciosclins");
  var curLNA: FLSqlCursor = new FLSqlCursor("lineasalbaranesclins");

  curLNS.select("idlineaservicio = " + curLineaServicio.valueBuffer("idlinea"));
  while (curLNS.next())
  {
    curLNA.setModeAccess(curLNA.Insert);
    curLNA.refreshBuffer();
    curLNA.setValueBuffer("idlineaalbaran", idLinea);
    curLNA.setValueBuffer("referencia", curLNS.valueBuffer("referencia"));
    curLNA.setValueBuffer("numserie", curLNS.valueBuffer("numserie"));
    curLNA.commitBuffer();
  }

  return true;
}

//// FUN_NUM_SERV_ACOMP /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
