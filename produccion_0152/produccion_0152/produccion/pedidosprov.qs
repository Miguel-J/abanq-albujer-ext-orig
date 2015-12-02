
/** @class_declaration prod */
/////////////////////////////////////////////////////////////////
//// PRODUCCION /////////////////////////////////////////////////
class prod extends oficial
{
  function prod(context)
  {
    oficial(context);
  }
  function validateForm(): Boolean {
    return this.ctx.prod_validateForm();
  }
}
//// PRODUCCION /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition prod */
/////////////////////////////////////////////////////////////////
//// PRODUCCION /////////////////////////////////////////////////
function prod_validateForm(): Boolean {
  if (!this.iface.__validateForm())
    return false;

  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  if (cursor.valueBuffer("fechaentrada") != cursor.valueBufferCopy("fechaentrada"))
  {
    if (!flfactalma.iface.pub_modificarFechaPedidoProv(cursor))
      return false;
  }
  //  var qryStocks:FLSqlQuery = new FLSqlQuery()
  //  with (qryStocks) {
  //    setTablesList("movistock,lineaspedidosprov");
  //    setSelect("ms.idstock");
  //    setFrom("lineaspedidosprov lp INNER JOIN movistock ms ON lp.idlinea = ms.idlineapp");
  //    setWhere("lp.idpedido = " + cursor.valueBuffer("idpedido") + " AND ms.estado = 'PTE' GROUP BY idstock");
  //    setForwardOnly(true);
  //  }
  //  if (!qryStocks.exec())
  //    return false;
  //  while (qryStocks.next()) {
  //    if (!flfactalma.iface.pub_comprobarEvolStock(qryStocks.value("ms.idstock")))
  //      return false;
  //  }
  return true;
}

//// PRODUCCION /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

