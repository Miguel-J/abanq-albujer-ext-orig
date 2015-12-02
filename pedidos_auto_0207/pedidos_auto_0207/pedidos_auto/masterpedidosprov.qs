
/** @class_declaration pedidosauto */
/////////////////////////////////////////////////////////////////
//// PEDIDOS_AUTO ///////////////////////////////////////////////
class pedidosauto extends oficial
{
  function pedidosauto(context)
  {
    oficial(context);
  }
  function recordDelBeforepedidosprov()
  {
    return this.ctx.pedidosauto_recordDelBeforepedidosprov()
  };
}
//// PEDIDOS_AUTO ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition pedidosauto */
/////////////////////////////////////////////////////////////////
//// PEDIDOS_AUTO //////////////////////////////////////////////

function pedidosauto_recordDelBeforepedidosprov()
{
  var cursor: FLSqlCursor = this.cursor();
  if (!cursor.isValid())
    return false;

  if (cursor.modeAccess() != cursor.Del)
    return true;

  var curTab: FLSqlCursor = new FLSqlCursor("pedidosaut");
  curTab.select("idpedidoaut = " + cursor.valueBuffer("idpedidoaut"));
  if (!curTab.first())
    return true;

  with(curTab) {
    setUnLock("editable", true);
    setModeAccess(Edit);
    refreshBuffer();
    commitBuffer();
  }

  return true;
}
//// PEDIDOS_AUTO //////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
