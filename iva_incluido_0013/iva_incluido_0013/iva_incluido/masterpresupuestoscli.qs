
/** @class_declaration ivaIncluido */
//////////////////////////////////////////////////////////////////
//// IVAINCLUIDO /////////////////////////////////////////////////////
class ivaIncluido extends oficial
{
  function ivaIncluido(context)
  {
    oficial(context);
  }
  function datosLineaPedido(curLineaPresupuesto: FLSqlCursor): Boolean {
    return this.ctx.ivaIncluido_datosLineaPedido(curLineaPresupuesto);
  }
  function totalesPedido(): Boolean {
    return this.ctx.ivaIncluido_totalesPedido();
  }
}
//// IVAINCLUIDO /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////


/** @class_definition ivaIncluido */
//////////////////////////////////////////////////////////////////
//// IVAINCLUIDO /////////////////////////////////////////////////////
/** \D Copia los datos de una línea de presupuesto en una línea de pedido
@param  curLineaPresupuesto: Cursor que contiene los datos a incluir en la línea de pedido
@return True si la copia se realiza correctamente, false en caso contrario
\end */
function ivaIncluido_datosLineaPedido(curLineaPresupuesto: FLSqlCursor): Boolean {
  if (!this.iface.__datosLineaPedido(curLineaPresupuesto))
  {
    return false;
  }
  with(this.iface.curLineaPedido)
  {
    setValueBuffer("ivaincluido", curLineaPresupuesto.valueBuffer("ivaincluido"));
    setValueBuffer("pvpunitarioiva", curLineaPresupuesto.valueBuffer("pvpunitarioiva"));
  }
  /// El cambio puede deberse a que la fecha del nuevo documento esté asociada a un tipo de IVA distinto del documento origens
  if (curLineaPresupuesto.valueBuffer("iva") != this.iface.curLineaPedido.valueBuffer("iva"))
  {
    if (this.iface.curLineaPedido.valueBuffer("ivaincluido")) {
      //      this.iface.curLineaPedido.setValueBuffer("pvpunitario", formRecordlineaspedidoscli.iface.pub_commonCalculateField("pvpunitario2", this.iface.curLineaPedido));
      //      this.iface.curLineaPedido.setValueBuffer("pvpsindto", formRecordlineaspedidoscli.iface.pub_commonCalculateField("pvpsindto", this.iface.curLineaPedido));
      //      this.iface.curLineaPedido.setValueBuffer("pvptotal", formRecordlineaspedidoscli.iface.pub_commonCalculateField("pvptotal", this.iface.curLineaPedido));

      this.iface.curLineaPedido.setValueBuffer("pvpunitario", formRecordlineaspedidoscli.iface.pub_commonCalculateField("pvpunitario2", this.iface.curLineaPedido));
      this.iface.curLineaPedido.setValueBuffer("pvpsindtoiva", formRecordlineaspedidoscli.iface.pub_commonCalculateField("pvpsindtoiva2", this.iface.curLineaPedido));
      this.iface.curLineaPedido.setValueBuffer("pvpsindto", formRecordlineaspedidoscli.iface.pub_commonCalculateField("pvpsindto2", this.iface.curLineaPedido));
      this.iface.curLineaPedido.setValueBuffer("pvptotaliva", formRecordlineaspedidoscli.iface.pub_commonCalculateField("pvptotaliva2", this.iface.curLineaPedido));
      this.iface.curLineaPedido.setValueBuffer("pvptotal", formRecordlineaspedidoscli.iface.pub_commonCalculateField("pvptotal2", this.iface.curLineaPedido));
    } else {
      this.iface.curLineaPedido.setValueBuffer("pvpunitarioiva", formRecordlineaspedidoscli.iface.pub_commonCalculateField("pvpunitarioiva2", this.iface.curLineaPedido));
      this.iface.curLineaPedido.setValueBuffer("pvpsindto", formRecordlineaspedidoscli.iface.pub_commonCalculateField("pvpsindto", this.iface.curLineaPedido));
      this.iface.curLineaPedido.setValueBuffer("pvpsindtoiva", formRecordlineaspedidoscli.iface.pub_commonCalculateField("pvpsindtoiva", this.iface.curLineaPedido));
      this.iface.curLineaPedido.setValueBuffer("pvptotal", formRecordlineaspedidoscli.iface.pub_commonCalculateField("pvptotal", this.iface.curLineaPedido));
      this.iface.curLineaPedido.setValueBuffer("pvptotaliva", formRecordlineaspedidoscli.iface.pub_commonCalculateField("pvptotaliva", this.iface.curLineaPedido));
    }
  } else {
    this.iface.curLineaPedido.setValueBuffer("pvpsindtoiva", curLineaPresupuesto.valueBuffer("pvpsindtoiva"));
    this.iface.curLineaPedido.setValueBuffer("pvptotaliva", curLineaPresupuesto.valueBuffer("pvptotaliva"));
  }

  return true;
}

function ivaIncluido_totalesPedido(): Boolean {
  this.iface.__totalesPedido();

  // Comprobar redondeo y recalcular totales
  formRecordfacturascli.iface.comprobarRedondeoIVA(this.iface.curPedido, "idpedido")
  with(this.iface.curPedido)
  {
    setValueBuffer("total", formpedidoscli.iface.pub_commonCalculateField("total", this));
    setValueBuffer("totaleuros", formpedidoscli.iface.pub_commonCalculateField("totaleuros", this));
  }
  return true;
}

//// IVAINCLUIDO /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

