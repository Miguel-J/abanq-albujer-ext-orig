
/** @class_declaration sgaBarcode */
/////////////////////////////////////////////////////////////////
//// SGA_BARCODE ///////////////////////////////////////////////
class sgaBarcode extends oficial
{
  function sgaBarcode(context)
  {
    oficial(context);
  }
  function crearLineasPicking(idPedido: String, codPedidoPicking: String): Number {
    return this.ctx.sgaBarcode_crearLineasPicking(idPedido, codPedidoPicking);
  }
}
//// SGA_BARCODE ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition sgaBarcode */
/////////////////////////////////////////////////////////////////
//// SGA_BARCODE ///////////////////////////////////////////////
function sgaBarcode_crearLineasPicking(idPedido: String, codPedidoPicking: String): Number {
  var util: FLUtil = new FLUtil;
  var num: Number = 0;
  var cantPicking: Number = 0;
  var codUbicacion: String;
  var idUbicacion: String;
  var qryLineas: FLSqlQuery = new FLSqlQuery;
  with(qryLineas)
  {
    setTablesList("lineaspedidoscli,pedidoscli");
    setSelect("codigo, idlinea, referencia, cantidad, barcode, talla, color");
    setFrom("lineaspedidoscli INNER JOIN pedidoscli ON lineaspedidoscli.idpedido = pedidoscli.idpedido");
    setWhere("lineaspedidoscli.idpedido = " + idPedido);
    setForwardOnly(true);
  }

  if (!qryLineas.exec())
    return false;

  while (qryLineas.next())
  {
    cantPicking = qryLineas.value("cantidad");
    idUbicacion = util.sqlSelect("ubicaciones u INNER JOIN zonas z ON z.codzona = u.codzona INNER JOIN ubicacionesarticulo ub ON u.codubicacion = ub.codubicacion", "ub.id", "ub.referencia = '" + qryLineas.value("referencia") + "' AND z.tipo = 'PICKING'", "ubicaciones,zonas,ubicacionesarticulo");
    if (!idUbicacion || idUbicacion == "") {
      MessageBox.information(util.translate("scripts", "No existe una ubicacion en zona picking para el artículo:\nReferencia %1").arg(qryLineas.value("referencia")), MessageBox.Ok, MessageBox.NoButton);
      return false;
    }

    codUbicacion = util.sqlSelect("ubicacionesarticulo", "codubicacion", "id = " + idUbicacion);
    if (!codUbicacion || codUbicacion == "") {
      MessageBox.information(util.translate("scripts", "No existe código de ubicacion para ese identificador"), MessageBox.Ok, MessageBox.NoButton);
      return false;
    }

    var curPedPic: FLSqlCursor = new FLSqlCursor("lineaspedidospicking");
    curPedPic.setModeAccess(curPedPic.Insert);
    curPedPic.refreshBuffer();
    curPedPic.setValueBuffer("codpedidopicking", codPedidoPicking);
    curPedPic.setValueBuffer("codpedido", qryLineas.value("codigo"));
    curPedPic.setValueBuffer("idpedido", idPedido);
    curPedPic.setValueBuffer("idlinea", qryLineas.value("idlinea"));
    curPedPic.setValueBuffer("referencia", qryLineas.value("referencia"));
    curPedPic.setValueBuffer("barcode", qryLineas.value("barcode"));
    curPedPic.setValueBuffer("talla", qryLineas.value("talla"));
    curPedPic.setValueBuffer("color", qryLineas.value("color"));
    curPedPic.setValueBuffer("cantidad", cantPicking);
    curPedPic.setValueBuffer("codubicacion",  codUbicacion);
    curPedPic.setValueBuffer("id", idUbicacion);
    curPedPic.setValueBuffer("estado", "PTE CESTAS");
    if (!curPedPic.commitBuffer())
      return false;
    num ++;
  }

  if (num == 0)
    return -1;

  return num;
}

//// SGA_BARCODE ///////////////////////////////////////////////
//////////////////////////////////////////////////////////////
