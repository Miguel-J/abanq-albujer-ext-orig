
/** @class_declaration pedAutoDto */
/////////////////////////////////////////////////////////////////
//// PEDIDOS_AUTO + DTO_ESPECIAL ///////////////////////////////
class pedAutoDto extends oficial
{
  function pedAutoDto(context)
  {
    oficial(context);
  }
  function totalesPedido(): Boolean {
    return this.ctx.pedAutoDto_totalesPedido();
  }
}
//// PEDIDOS_AUTO + DTO_ESPECIAL ///////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition pedAutoDto */
/////////////////////////////////////////////////////////////////
//// PEDIDOS_AUTO + DTO_ESPECIAL ///////////////////////////////
/** \D Informa los datos de un pedido referentes a totales (I.V.A., neto, etc. NETOSINDTOESP)
@return True si el cálculo se realiza correctamente, false en caso contrario
\end */
function pedAutoDto_totalesPedido(): Boolean {
  var util: FLUtil = new FLUtil;
  var curPedido: FLSqlCursor = this.iface.curPedido;
  with(this.iface.curPedido)
  {
    setValueBuffer("netosindtoesp", formpedidosprov.iface.pub_commonCalculateField("netosindtoesp", curPedido));
    setValueBuffer("neto", formpedidosprov.iface.pub_commonCalculateField("neto", curPedido));
    setValueBuffer("totaliva", formpedidosprov.iface.pub_commonCalculateField("totaliva", curPedido));
    setValueBuffer("totalirpf", formpedidosprov.iface.pub_commonCalculateField("totalirpf", curPedido));
    setValueBuffer("totalrecargo", formpedidosprov.iface.pub_commonCalculateField("totalrecargo", curPedido));
    setValueBuffer("total", formpedidosprov.iface.pub_commonCalculateField("total", curPedido));
    setValueBuffer("totaleuros", formpedidosprov.iface.pub_commonCalculateField("totaleuros", curPedido));
  }
  return true;
}

//// PEDIDOS_AUTO + DTO_ESPECIAL ///////////////////////////////
/////////////////////////////////////////////////////////////////
