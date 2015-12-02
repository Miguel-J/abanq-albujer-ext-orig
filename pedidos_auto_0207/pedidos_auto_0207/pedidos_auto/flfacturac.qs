
/** @class_declaration pedidosauto */
/////////////////////////////////////////////////////////////////
//// PEDIDOS_AUTO ///////////////////////////////////////////////
class pedidosauto extends oficial
{
  function pedidosauto(context)
  {
    oficial(context);
  }
  function beforeCommit_pedidosprov(curPedido: FLSqlCursor): Boolean {
    return this.ctx.pedidosauto_beforeCommit_pedidosprov(curPedido);
  }
  function cambiarStockOrd(referencia: String, variacion: Number): Boolean {
    return this.ctx.pedidosauto_cambiarStockOrd(referencia, variacion);
  }
}
//// PEDIDOS_AUTO ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pubPedAuto */
/////////////////////////////////////////////////////////////////
//// PUB_PEDIDOSAUTO ///////////////////////////////////////////////
class pubPedAuto extends ifaceCtx
{
  function pubPedAuto(context)
  {
    ifaceCtx(context);
  }
  function pub_cambiarStockOrd(referencia: String, variacion: Number): Boolean {
    return this.cambiarStockOrd(referencia, variacion);
  }
}
//// PUB_PEDIDOSAUTO ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition pedidosauto */
/////////////////////////////////////////////////////////////////
//// PEDIDOS_AUTO //////////////////////////////////////////////
function pedidosauto_beforeCommit_pedidosprov(curPedido: FLSqlCursor)
{
  var util: FLUtil = new FLUtil();

  if (!this.iface.__beforeCommit_pedidosprov(curPedido))
    return false;

  var idPedido: Number = curPedido.valueBuffer("idpedido");

  var qryLineasPedProv: FLSqlQuery = new FLSqlQuery();
  with(qryLineasPedProv) {
    setTablesList("lineaspedidosprov");
    setSelect("referencia,cantidad");
    setFrom("lineaspedidosprov");
    setWhere("idpedido = " + idPedido);
    setForwardOnly(true);
  }
  if (!qryLineasPedProv.exec())
    return false;

  while (qryLineasPedProv.next())
    if (!this.iface.cambiarStockOrd(qryLineasPedProv.value("referencia"), qryLineasPedProv.value("cantidad")))
      return false;

  return true;
}

/** \D Cambia el valor del stock pedido de un articulo.

@param referencia Referencia del artículo
@param variación Variación en el número de existencias del artículo
@return True si la modificación tuvo éxito, false en caso contrario
\end */
function pedidosauto_cambiarStockOrd(referencia: String, variacion: Number): Boolean {
  debug(referencia);

  var util: FLUtil = new FLUtil();
  if (!referencia)
    return true;

  var stockOrd: Number = util.sqlSelect("lineaspedidosprov", "sum(cantidad-totalenalbaran)", "referencia = '" + referencia + "'");
  debug(stockOrd);
  if (!stockOrd)
    stockOrd = 0;

  stockOrd = parseFloat(stockOrd);

  var curArticulos: FLSqlCursor = new FLSqlCursor("articulos");
  curArticulos.select("referencia = '" + referencia + "'");
  if (!curArticulos.first())
    return true;
  curArticulos.setModeAccess(curArticulos.Edit);
  curArticulos.refreshBuffer();
  curArticulos.setValueBuffer("stockord", stockOrd);
  if (!curArticulos.commitBuffer())
    return false;

  return true;
}
//// PEDIDOS_AUTO ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

