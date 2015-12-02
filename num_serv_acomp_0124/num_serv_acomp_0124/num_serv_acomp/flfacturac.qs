
/** @class_declaration funNumServAcomp */
//////////////////////////////////////////////////////////////////
//// FUN_NUM_SERV_ACOMP /////////////////////////////////////////////////////

class funNumServAcomp extends nsServicios
{
  function funNumServAcomp(context)
  {
    nsServicios(context);
  }
  function afterCommit_lineasserviciosclins(curL: FLSqlCursor): Boolean {
    return this.ctx.funNumAcomp_afterCommit_lineasserviciosclins(curL);
  }
}

//// FUN_NUM_SERV_ACOMP /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////


/** @class_definition funNumServAcomp */
/////////////////////////////////////////////////////////////////
//// FUN_NUM_SERV_ACOMP /////////////////////////////////////////////////

/** \D Actualiza el id de servicio de venta para un número de serie.
*/
function funNumAcomp_afterCommit_lineasserviciosclins(curL: FLSqlCursor): Boolean {
  debug(curL.valueBuffer("numserie"));
  if (!curL.valueBuffer("numserie")) return true;

  var util: FLUtil = new FLUtil();

  var curNS: FLSqlCursor = new FLSqlCursor("numerosserie");
  var idServicio = util.sqlSelect("lineasservicioscli", "idservicio", "idlinea = " + curL.valueBuffer("idlineaservicio"));

  switch (curL.modeAccess())
  {

    case curL.Edit:
      // Control cuando cambia un número por otro, se libera el primero
      if (curL.valueBuffer("numserie") != curL.valueBufferCopy("numserie")) {
        debug("referencia = '" + curL.valueBuffer("referencia") + "' AND numserie = '" + curL.valueBufferCopy("numserie") + "'");
        curNS.select("referencia = '" + curL.valueBuffer("referencia") + "' AND numserie = '" + curL.valueBufferCopy("numserie") + "'");
        if (curNS.first()) {
          curNS.setModeAccess(curNS.Edit);
          curNS.refreshBuffer();
          curNS.setValueBuffer("idservicioventa", -1)
          curNS.setValueBuffer("vendido", "false")
          if (!curNS.commitBuffer()) return false;
        }
      }

    case curL.Insert:
      debug("referencia = '" + curL.valueBuffer("referencia") + "' AND numserie = '" + curL.valueBuffer("numserie") + "'");
      curNS.select("referencia = '" + curL.valueBuffer("referencia") + "' AND numserie = '" + curL.valueBuffer("numserie") + "'");
      if (curNS.first()) {
        curNS.setModeAccess(curNS.Edit);
        curNS.refreshBuffer();
        curNS.setValueBuffer("idservicioventa", idServicio)
        curNS.setValueBuffer("vendido", "true")
        if (!curNS.commitBuffer()) return false;
      }


      break;

    case curL.Del:
      curNS.select("referencia = '" + curL.valueBuffer("referencia") + "' AND numserie = '" + curL.valueBuffer("numserie") + "'");
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

//// FUN_NUM_SERV_ACOMP /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

