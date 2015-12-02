
/** @class_declaration funNumAcomp */
//////////////////////////////////////////////////////////////////
//// FUN_NUM_ACOMP /////////////////////////////////////////////////////

class funNumAcomp extends funNumSerie
{
  function funNumAcomp(context)
  {
    funNumSerie(context);
  }
  function afterCommit_lineasalbaranesclins(curL: FLSqlCursor): Boolean {
    return this.ctx.funNumAcomp_afterCommit_lineasalbaranesclins(curL);
  }
  function afterCommit_lineasfacturasclins(curL: FLSqlCursor): Boolean {
    return this.ctx.funNumAcomp_afterCommit_lineasfacturasclins(curL);
  }
}

//// FUN_NUM_ACOMP /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////


/** @class_definition funNumAcomp */
/////////////////////////////////////////////////////////////////
//// FUN_NUM_ACOMP /////////////////////////////////////////////////

/** \D Actualiza el id de albarán de compra para un número de serie.
*/
function funNumAcomp_afterCommit_lineasalbaranesclins(curL: FLSqlCursor): Boolean {
  if (!curL.valueBuffer("numserie")) return true;

  var util: FLUtil = new FLUtil();

  var curNS: FLSqlCursor = new FLSqlCursor("numerosserie");
  var idAlbaran = util.sqlSelect("lineasalbaranescli", "idalbaran", "idlinea = " + curL.valueBuffer("idlineaalbaran"));

  switch (curL.modeAccess())
  {

    case curL.Edit:
      // Control cuando cambia un número por otro, se libera el primero
      if (curL.valueBuffer("numserie") != curL.valueBufferCopy("numserie")) {
        curNS.select("referencia = '" + curL.valueBuffer("referencia") + "' AND numserie = '" + curL.valueBufferCopy("numserie") + "'");
        if (curNS.first()) {
          curNS.setModeAccess(curNS.Edit);
          curNS.refreshBuffer();
          curNS.setValueBuffer("idalbaranventa", -1)
          curNS.setValueBuffer("vendido", "false")
          if (!curNS.commitBuffer()) return false;
        }
      }

    case curL.Insert:
      curNS.select("referencia = '" + curL.valueBuffer("referencia") + "' AND numserie = '" + curL.valueBuffer("numserie") + "'");
      if (curNS.first()) {
        curNS.setModeAccess(curNS.Edit);
        curNS.refreshBuffer();
        curNS.setValueBuffer("idalbaranventa", idAlbaran)
        curNS.setValueBuffer("vendido", "true")
        if (!curNS.commitBuffer()) return false;
      }


      break;

    case curL.Del:
      curNS.select("referencia = '" + curL.valueBuffer("referencia") + "' AND numserie = '" + curL.valueBuffer("numserie") + "'");
      if (curNS.first()) {
        curNS.setModeAccess(curNS.Edit);
        curNS.refreshBuffer();
        curNS.setValueBuffer("idalbaranventa", -1)
        curNS.setValueBuffer("vendido", "false")
        if (!curNS.commitBuffer()) return false;
      }
      break;
  }
  return true;
}

/** \D Actualiza el id de factura de compra para un número de serie.
*/
function funNumAcomp_afterCommit_lineasfacturasclins(curL: FLSqlCursor): Boolean {
  if (!curL.valueBuffer("numserie")) return true;

  var util: FLUtil = new FLUtil();

  var curNS: FLSqlCursor = new FLSqlCursor("numerosserie");
  var idAlbaran = util.sqlSelect("lineasfacturascli", "idfactura", "idlinea = " + curL.valueBuffer("idlineafactura"));

  switch (curL.modeAccess())
  {

    case curL.Edit:
      // Control cuando cambia un número por otro, se libera el primero
      if (curL.valueBuffer("numserie") != curL.valueBufferCopy("numserie")) {
        curNS.select("referencia = '" + curL.valueBuffer("referencia") + "' AND numserie = '" + curL.valueBufferCopy("numserie") + "'");
        if (curNS.first()) {
          curNS.setModeAccess(curNS.Edit);
          curNS.refreshBuffer();
          curNS.setValueBuffer("idfacturaventa", -1)
          curNS.setValueBuffer("vendido", "false")
          if (!curNS.commitBuffer()) return false;
        }
      }

      break;

    case curL.Insert:
      curNS.select("referencia = '" + curL.valueBuffer("referencia") + "' AND numserie = '" + curL.valueBuffer("numserie") + "'");
      if (curNS.first()) {
        curNS.setModeAccess(curNS.Edit);
        curNS.refreshBuffer();
        curNS.setValueBuffer("idfacturaventa", idAlbaran)
        curNS.setValueBuffer("vendido", "true")
        if (!curNS.commitBuffer()) return false;
      }

      break;

    case curL.Del:
      curNS.select("referencia = '" + curL.valueBuffer("referencia") + "' AND numserie = '" + curL.valueBuffer("numserie") + "'");
      if (curNS.first()) {
        curNS.setModeAccess(curNS.Edit);
        curNS.refreshBuffer();
        curNS.setValueBuffer("idfacturaventa", -1)
        if (!idAlbaran)
          curNS.setValueBuffer("vendido", "false")
          if (!curNS.commitBuffer()) return false;
      }
      break;
  }
  return true;
}

//// FUN_NUM_ACOMP /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

