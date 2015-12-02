
/** @class_declaration tpvNsAcomp */
//////////////////////////////////////////////////////////////////
//// TPV_NS_ACOMP /////////////////////////////////////////////////////

class tpvNsAcomp extends funNumSerie
{
  function tpvNsAcomp(context)
  {
    funNumSerie(context);
  }
  function copiarLinea(idFactura: Number, curLineaComanda: FLSqlCursor): Boolean {
    return this.ctx.tpvNsAcomp_copiarLinea(idFactura, curLineaComanda);
  }
  function afterCommit_tpv_lineascomandans(curL: FLSqlCursor): Boolean {
    return this.ctx.tpvNsAcomp_afterCommit_tpv_lineascomandans(curL);
  }
}

//// TPV_NS_ACOMP /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////


/** @class_definition tpvNsAcomp */
/////////////////////////////////////////////////////////////////
//// TPV_NS_ACOMP /////////////////////////////////////////////////

/** \D Actualiza el id de comanda de venta para un número de serie.
*/
function tpvNsAcomp_afterCommit_tpv_lineascomandans(curL: FLSqlCursor): Boolean {
  if (!curL.valueBuffer("numserie")) return true;

  var util: FLUtil = new FLUtil();

  var curNS: FLSqlCursor = new FLSqlCursor("numerosserie");
  var idComanda = util.sqlSelect("tpv_lineascomanda", "idtpv_comanda", "idtpv_linea = " + curL.valueBuffer("idlineacomanda"));

  switch (curL.modeAccess())
  {

    case curL.Edit:
      // Control cuando cambia un número por otro, se libera el primero
      if (curL.valueBuffer("numserie") != curL.valueBufferCopy("numserie")) {
        curNS.select("referencia = '" + curL.valueBuffer("referencia") + "' AND numserie = '" + curL.valueBufferCopy("numserie") + "'");
        if (curNS.first()) {
          curNS.setModeAccess(curNS.Edit);
          curNS.refreshBuffer();
          curNS.setValueBuffer("idcomandaventa", -1)
          curNS.setValueBuffer("vendido", "false")
          if (!curNS.commitBuffer()) return false;
        }
      }

    case curL.Insert:
      curNS.select("referencia = '" + curL.valueBuffer("referencia") + "' AND numserie = '" + curL.valueBuffer("numserie") + "'");
      if (curNS.first()) {
        curNS.setModeAccess(curNS.Edit);
        curNS.refreshBuffer();
        curNS.setValueBuffer("idcomandaventa", idComanda)
        curNS.setValueBuffer("vendido", "true")
        if (!curNS.commitBuffer()) return false;
      }


      break;

    case curL.Del:
      curNS.select("referencia = '" + curL.valueBuffer("referencia") + "' AND numserie = '" + curL.valueBuffer("numserie") + "'");
      if (curNS.first()) {
        curNS.setModeAccess(curNS.Edit);
        curNS.refreshBuffer();
        curNS.setValueBuffer("idcomandaventa", -1)
        curNS.setValueBuffer("vendido", "false")
        if (!curNS.commitBuffer()) return false;
      }
      break;
  }
  return true;
}


function tpvNsAcomp_copiarLinea(idFactura: Number, curLineaComanda: FLSqlCursor): Boolean {
  var idLinea = this.iface.__copiarLinea(idFactura, curLineaComanda);
  if (!idLinea)
    return false;

  var util: FLUtil = new FLUtil;

  var curLNA: FLSqlCursor = new FLSqlCursor("tpv_lineascomandans");
  var curLNF: FLSqlCursor = new FLSqlCursor("lineasfacturasclins");

  curLNA.select("idlineacomanda = " + curLineaComanda.valueBuffer("idtpv_linea"));
  while (curLNA.next())
  {

    if (!curLNA.valueBuffer("numserie")) {
      MessageBox.warning(util.translate("scripts", "No es posible generar la factura.\n\nLa comandantiene componentes de artículos compuestos\ncuyo número de serie no se ha establecido"), MessageBox.Ok, MessageBox.NoButton);
      return false;
    }

    curLNF.setModeAccess(curLNF.Insert);
    curLNF.refreshBuffer();
    curLNF.setValueBuffer("idlineafactura", idLinea);
    curLNF.setValueBuffer("referencia", curLNA.valueBuffer("referencia"));
    curLNF.setValueBuffer("numserie", curLNA.valueBuffer("numserie"));
    curLNF.commitBuffer();
  }

  return true;
}


//// TPV_NS_ACOMP /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
