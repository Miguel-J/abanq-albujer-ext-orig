
/** @class_declaration asoPresup */
/////////////////////////////////////////////////////////////////
//// ASOCIAR PRESUPUESTOS ///////////////////////////////////////
class asoPresup extends oficial
{
  function asoPresup(context)
  {
    oficial(context);
  }
  function generarPedido(curPresupuesto: FLSqlCursor, where: String): Number {
    return this.ctx.asoPresup_generarPedido(curPresupuesto, where);
  }
  function datosPedido(curPresupuesto: FLSqlCursor): Boolean {
    return this.ctx.asoPresup_datosPedido(curPresupuesto);
  }
  function datosLineaPedido(curLineaPresupuesto: FLSqlCursor): Boolean {
    return this.ctx.asoPresup_datosLineaPedido(curLineaPresupuesto);
  }
}
//// ASOCIAR PRESUPUESTOS ///////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pubAsoPresup */
/////////////////////////////////////////////////////////////////
//// PUB ASOCIAR PRESUPUESTOS////////////////////////////////////
class pubAsoPresup extends ifaceCtx
{
  function pubAsoPresup(context)
  {
    ifaceCtx(context);
  }
}
//// PUB ASOCIAR PRESUPUESTOS////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition asoPresup */
/////////////////////////////////////////////////////////////////
//// ASOCIAR PRESUPUESTOS ///////////////////////////////////////
/** \D
Genera el pedido asociado a uno o más presupuestos
@param cursor: Cursor con los datos principales que se copiarán del presupuesto al pedido
@param where: Sentencia where para la consulta de búsqueda de los presupuestos a agrupar
@return Identificador del pedido generado. FALSE si hay error
\end */
function asoPresup_generarPedido(curPresupuesto: FLSqlCursor, where: String): Number {
  if (!this.iface.curPedido)
    this.iface.curPedido = new FLSqlCursor("pedidoscli");

  if (!where)
    where = "idpresupuesto = " + curPresupuesto.valueBuffer("idpresupuesto");

  this.iface.curPedido.setModeAccess(this.iface.curPedido.Insert);
  this.iface.curPedido.refreshBuffer();

  if (!this.iface.datosPedido(curPresupuesto))
    return false;

  if (!this.iface.curPedido.commitBuffer())
  {
    return false;
  }

  var idPedido: Number = this.iface.curPedido.valueBuffer("idpedido");
  var curPresupuestos: FLSqlCursor = new FLSqlCursor("presupuestoscli");
  curPresupuestos.select(where);
  var idPresupuesto: Number;
  while (curPresupuestos.next())
  {
    curPresupuestos.setModeAccess(curPresupuestos.Edit);
    curPresupuestos.refreshBuffer();
    idPresupuesto = curPresupuestos.valueBuffer("idpresupuesto");
    if (!this.iface.copiaLineas(idPresupuesto, idPedido))
      return false;
    curPresupuestos.setValueBuffer("idpedido", idPedido);
    curPresupuestos.setValueBuffer("editable", false);
    if (!curPresupuestos.commitBuffer()) {
      return false;
    }
  }

  this.iface.curPedido.select("idpedido = " + idPedido);
  if (this.iface.curPedido.first())
  {
    this.iface.curPedido.setModeAccess(this.iface.curPedido.Edit);
    this.iface.curPedido.refreshBuffer();

    if (!this.iface.totalesPedido())
      return false;

    if (this.iface.curPedido.commitBuffer() == false)
      return false;
  }
  return idPedido;
}

/** \D Informa los datos de un pedido a partir de los de un presupuesto
Marca el pedido como automático, por venir de uno o más presupuestos
@param  curPresupuesto: Cursor que contiene los datos a incluir en el pedido
@return True si el cálculo se realiza correctamente, false en caso contrario
\end */
function asoPresup_datosPedido(curPresupuesto: FLSqlCursor): Boolean {
  if (!this.iface.__datosPedido(curPresupuesto))
    return false;

  this.iface.curPedido.setValueBuffer("automatico", "true");
  return true;
}

/** \D Copia los datos de una línea de presupuesto en una línea de pedido
Copia el identificador del presupuesto del que proviene el pedido
@param  curLineaPresupuesto: Cursor que contiene los datos a incluir en la línea de pedido
@return True si la copia se realiza correctamente, false en caso contrario
\end */
function asoPresup_datosLineaPedido(curLineaPresupuesto: FLSqlCursor): Boolean {
  if (!this.iface.__datosLineaPedido(curLineaPresupuesto))
    return false;

  this.iface.curLineaPedido.setValueBuffer("idpresupuesto", curLineaPresupuesto.valueBuffer("idpresupuesto"));

  return true;
}

//// ASOCIAR PRESUPUESTOS ///////////////////////////////////////
/////////////////////////////////////////////////////////////////
