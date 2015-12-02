
/** @class_declaration pedidosauto */
/////////////////////////////////////////////////////////////////
//// PEDIDOS_AUTO ///////////////////////////////////////////////
class pedidosauto extends oficial
{
  function pedidosauto(context)
  {
    oficial(context);
  }
  //  function controlStockAlbaranesCli(curLA:FLSqlCursor):Boolean {
  //    return this.ctx.pedidosauto_controlStockAlbaranesCli(curLA);
  //  }
  //  function controlStockAlbaranesProv(curLA:FLSqlCursor):Boolean {
  //    return this.ctx.pedidosauto_controlStockAlbaranesProv(curLA);
  //  }
}
//// PEDIDOS_AUTO ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition pedidosauto */
/////////////////////////////////////////////////////////////////
//// PEDIDOS_AUTO ///////////////////////////////////////////////
/** \C
Actualiza el stock correspondiente al artículo seleccionado en la línea
\end */
// function pedidosauto_controlStockAlbaranesCli(curLA:FLSqlCursor):Boolean
// {
//  var util:FLUtil = new FLUtil();
//  var codAlmacen:String = util.sqlSelect("albaranescli", "codalmacen", "idalbaran = " + curLA.valueBuffer("idalbaran"));
//  if (!codAlmacen || codAlmacen == "")
//    return true;
//
//  switch(curLA.modeAccess()) {
//    case curLA.Insert:
//      // if provided through automatic order and if stock control is done via orders, silently return
//      if ((curLA.valueBuffer("idlineapedido") != 0) && flfactppal.iface.pub_valorDefectoEmpresa("stockpedidos"))
//        return true;
//  }
//
//  return this.iface.__controlStockAlbaranesCli(curLA);
// }

// function pedidosauto_controlStockAlbaranesProv(curLA:FLSqlCursor):Boolean
// {
//  var util:FLUtil = new FLUtil();
//
//  if (!this.iface.__controlStockAlbaranesProv(curLA))
//    return false;
//
//  var pedAuto:Boolean = false;
//  if (util.sqlSelect("lineaspedidosprov", "idpedidoaut", "idlinea = " + curLA.valueBuffer("idlineapedido")))
//    pedAuto = true;
//
//
//  if (pedAuto) {
//    var cantidad:Number = -1 * parseFloat(curLA.valueBuffer("cantidad"));
//    if (!flfacturac.iface.pub_cambiarStockOrd(curLA.valueBuffer("referencia"), cantidad))
//      return false;
//  }
//
//  return true;
// }
//// PEDIDOS_AUTO ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
