
/** @class_declaration multiTc */
/////////////////////////////////////////////////////////////////
//// MULTITC /////////////////////////////////////////////////
class multiTc extends multi
{
  function multiTc(context)
  {
    multi(context);
  }
  function afterCommit_tpv_artmultitransstock(curArtMultiTS)
  {
    return this.ctx.multiTc_afterCommit_tpv_artmultitransstock(curArtMultiTS);
  }
  function controlBarcodesMultiTransStock(curArtMultiTS)
  {
    return this.ctx.multiTc_controlBarcodesMultiTransStock(curArtMultiTS);
  }
}
//// MULTITC /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition multiTc */
/////////////////////////////////////////////////////////////////
//// MULTITC /////////////////////////////////////////////////
function multiTc_afterCommit_tpv_artmultitransstock(curArtMultiTS)
{
  var _i = this.iface;

  if (!_i.controlBarcodesMultiTransStock(curArtMultiTS))
    return false

           return true;
}

function multiTc_controlBarcodesMultiTransStock(curArtMultiTS)
{
  switch (curArtMultiTS.modeAccess()) {
    case curArtMultiTS.Insert: {
      if (!curArtMultiTS.cursorRelation() || curArtMultiTS.cursorRelation().table() != "tpv_multitransstock") {
        return true;
      }

      var soloStockPos = curArtMultiTS.cursorRelation().valueBuffer("solostockpos");
      var codAlmaOrigen = curArtMultiTS.cursorRelation().valueBuffer("codalmaorigen");

      var q = new FLSqlQuery;
      q.setSelect("referencia, barcode, talla, color");
      q.setFrom("atributosarticulos");
      q.setWhere("referencia = '" + curArtMultiTS.valueBuffer("referencia") + "'");
      q.setForwardOnly(true);
      if (!q.exec()) {
        return false;
      }

      var barcode;
      var p = 0;
      AQUtil.createProgressDialog(sys.translate("Insertando barcodes del articulos seleccionado."), q.size());

      while (q.next()) {
        AQUtil.setProgress(p++);
        barcode = q.value("barcode");
        if (soloStockPos) {
          if (!formRecordtpv_multitransstock.iface.barcodeStockPos(barcode, codAlmaOrigen)) {
            continue;
          }
        }

        var curBC = new FLSqlCursor("tpv_barcodemultitransstock");
        curBC.setModeAccess(curBC.Insert);
        curBC.refreshBuffer();
        curBC.setValueBuffer("barcode", barcode);
        curBC.setValueBuffer("codmultitransstock", curArtMultiTS.valueBuffer("codmultitransstock"));
        curBC.setValueBuffer("referencia", q.value("referencia"));
        curBC.setValueBuffer("talla", q.value("talla"));
        curBC.setValueBuffer("color", q.value("color"));
        if (!curBC.commitBuffer()) {
          AQUtil.destroyProgressDialog();
          return false;
        }
      }
      AQUtil.destroyProgressDialog();
      break;
    }
    case curArtMultiTS.Del: {
      if (!AQUtil.sqlDelete("tpv_barcodemultitransstock", "codmultitransstock = '" + curArtMultiTS.valueBuffer("codmultitransstock") + "' AND referencia = '" + curArtMultiTS.valueBuffer("referencia") + "'")) {
        return false;
      }
      break;
    }
  }

  return true;
}
//// MULTITC /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
