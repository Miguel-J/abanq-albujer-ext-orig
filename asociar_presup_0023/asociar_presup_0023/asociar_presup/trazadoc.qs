
/** @class_declaration asoPresup */
/////////////////////////////////////////////////////////////////
//// ASOCIAR PRESUPUESTOS ///////////////////////////////////////
class asoPresup extends oficial
{
  function asoPresup(context)
  {
    oficial(context);
  }
  function dibOrigenPedCli(codigo: String, fila: Number): Number {
    return this.ctx.asoPresup_dibOrigenPedCli(codigo, fila);
  }
  function dibDestinoPreCli(codigo: String, fila: Number): Number {
    return this.ctx.asoPresup_dibDestinoPreCli(codigo, fila);
  }
}
//// ASOCIAR PRESUPUESTOS ///////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition asoPresup */
/////////////////////////////////////////////////////////////////
//// ASOCIAR PRESUPUESTOS ///////////////////////////////////////
/** Dibuja los presupuestos que originan el pedido de cliente indicado, a partir de la fila de la tabla indicada
@param  codigo: Código del pedido
@param  fila: Fila en la que comenzar a dibujar
@return última fila dibujada
\end */
function asoPresup_dibOrigenPedCli(codigo: String, fila: Number): Number {
  var qryPresupuestos: FLSqlQuery = new FLSqlQuery();
  with(qryPresupuestos)
  {
    setTablesList("pedidoscli,lineaspedidoscli,presupuestoscli");
    setSelect("pr.codigo");
    setFrom("pedidoscli p INNER JOIN lineaspedidoscli lp ON p.idpedido = lp.idpedido INNER JOIN presupuestoscli pr ON lp.idpresupuesto = pr.idpresupuesto");
    setWhere("p.codigo = '" + codigo + "' GROUP BY pr.codigo ORDER BY pr.codigo");
    setForwardOnly(true);
  }
  if (!qryPresupuestos.exec())
  {
    return -1;
  }
  while (qryPresupuestos.next())
  {
    fila++;
    if (this.iface.tblDocs.numRows() == fila) {
      this.iface.tblDocs.insertRows(fila);
    }
    this.iface.tblDocs.setText(fila, this.iface.PRESUPUESTOS, qryPresupuestos.value("pr.codigo"));
  }
  return fila;
}

/** Dibuja los pedidos destino del presupuesto de cliente indicado, a partir de la fila de la tabla indicada
@param  codigo: Código del presupuesto
@param  fila: Fila en la que comenzar a dibujar
@return última fila dibujada
\end */
function asoPresup_dibDestinoPreCli(codigo: String, fila: Number): Number {
  var qryPedidos: FLSqlQuery = new FLSqlQuery();
  with(qryPedidos)
  {
    setTablesList("pedidoscli,lineaspedidoscli,presupuestoscli");
    setSelect("p.codigo");
    setFrom("presupuestoscli pr INNER JOIN lineaspedidoscli lp ON pr.idpresupuesto = lp.idpresupuesto INNER JOIN pedidoscli p ON lp.idpedido = p.idpedido");
    setWhere("pr.codigo = '" + codigo + "' GROUP BY p.codigo ORDER BY p.codigo");
    setForwardOnly(true);
  }
  if (!qryPedidos.exec())
  {
    return -1;
  }
  while (qryPedidos.next())
  {
    fila++;
    if (this.iface.tblDocs.numRows() == fila) {
      this.iface.tblDocs.insertRows(fila);
    }
    this.iface.tblDocs.setText(fila, this.iface.PEDIDOS, qryPedidos.value("p.codigo"));
    fila = this.iface.dibDestinoPedCli(qryPedidos.value("p.codigo"), fila);
    if (fila == -1) {
      return -1;
    }
  }
  return fila;
}

//// ASOCIAR PRESUPUESTOS ///////////////////////////////////////
/////////////////////////////////////////////////////////////////
