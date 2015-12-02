
/** @class_declaration tallasColores */
/////////////////////////////////////////////////////////////////
//// TALLASCOLORES //////////////////////////////////////////////////
class tallasColores extends oficial
{
  function tallasColores(context)
  {
    oficial(context);
  }
  function datosLineaPedido(curLineaPresupuesto: FLSqlCursor): Boolean {
    return this.ctx.tallasColores_datosLineaPedido(curLineaPresupuesto);
  }
}
//// TALLASCOLORES //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition tallasColores */
/////////////////////////////////////////////////////////////////
//// TALLASCOLORES //////////////////////////////////////////////////
/** \D Copia los datos de una línea de presupuesto en una línea de pedido
@param  curLineaPresupuesto: Cursor que contiene los datos a incluir en la línea de pedido
@return True si la copia se realiza correctamente, false en caso contrario
\end */
function tallasColores_datosLineaPedido(curLineaPresupuesto: FLSqlCursor): Boolean {
  if (!this.iface.__datosLineaPedido(curLineaPresupuesto))
    return false;

  with(this.iface.curLineaPedido)
  {
    setValueBuffer("talla", curLineaPresupuesto.valueBuffer("talla"));
    setValueBuffer("color", curLineaPresupuesto.valueBuffer("color"));
  }
  return true;
}


//// TALLASCOLORES //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

