
/** @class_declaration nsServicios */
//////////////////////////////////////////////////////////////////
//// NS_SERVICIOS /////////////////////////////////////////////////////
class nsServicios extends funNumSerie
{
  function nsServicios(context)
  {
    funNumSerie(context);
  }
  function afterCommit_lineasservicioscli(curLS: FLSqlCursor): Boolean {
    return this.ctx.nsServicios_afterCommit_lineasservicioscli(curLS);
  }
}
//// NS_SERVICIOS /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_definition nsServicios */
/////////////////////////////////////////////////////////////////
//// NS_SERVICIOS /////////////////////////////////////////////////

/** \D Actualiza el id de albarán de compra para un número de serie.
*/
function nsServicios_afterCommit_lineasservicioscli(curLS: FLSqlCursor): Boolean {
  if (!curLS.valueBuffer("numserie")) return true;

  var curNS: FLSqlCursor = new FLSqlCursor("numerosserie");

  switch (curLS.modeAccess())
  {

    case curLS.Edit:
      // Control cuando cambia un número por otro, se libera el primero
      if (curLS.valueBuffer("numserie") != curLS.valueBufferCopy("numserie")) {
        curNS.select("referencia = '" + curLS.valueBuffer("referencia") + "' AND numserie = '" + curLS.valueBufferCopy("numserie") + "'");
        if (curNS.first()) {
          curNS.setModeAccess(curNS.Edit);
          curNS.refreshBuffer();
          curNS.setValueBuffer("idservicioventa", -1)
          curNS.setValueBuffer("vendido", "false")
          if (!curNS.commitBuffer()) return false;
        }
      }
      break;

    case curLS.Insert:
      curNS.select("referencia = '" + curLS.valueBuffer("referencia") + "' AND numserie = '" + curLS.valueBuffer("numserie") + "'");
      if (curNS.first()) {
        curNS.setModeAccess(curNS.Edit);
        curNS.refreshBuffer();
        curNS.setValueBuffer("idservicioventa", curLS.valueBuffer("idservicio"))
        curNS.setValueBuffer("vendido", "true")
        if (!curNS.commitBuffer()) return false;
      }


      break;

    case curLS.Del:
      curNS.select("referencia = '" + curLS.valueBuffer("referencia") + "' AND numserie = '" + curLS.valueBuffer("numserie") + "'");
      if (curNS.first()) {
        curNS.setModeAccess(curNS.Edit);
        curNS.refreshBuffer();
        curNS.setValueBuffer("idservicioventa", -1)
        curNS.setValueBuffer("vendido", "false")
        if (!curNS.commitBuffer()) return false;
      }
      break;
  }
  return true;
}

//// NS_SERVICIOS /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////


