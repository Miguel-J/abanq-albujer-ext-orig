
/** @class_declaration clientesPot */
/////////////////////////////////////////////////////////////////
//// CLIENTESPOT //////////////////////////////////////////////////
class clientesPot extends oficial
{
  function clientesPot(context)
  {
    oficial(context);
  }
  function generarPedido(cursor: FLSqlCursor): Number {
    return this.ctx.clientesPot_generarPedido(cursor);
  }
}
//// CLIENTESPOT //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition clientesPot */
/////////////////////////////////////////////////////////////////
//// CLIENTESPOT //////////////////////////////////////////////////

/** \D Si el cliente del presupuesto es potencial, se pregunta la posibilidad de
pasarlo a cliente real
*/
function clientesPot_generarPedido(curPresupuesto: FLSqlCursor): Number {
  if (!curPresupuesto.valueBuffer("clientepot"))
    return this.iface.__generarPedido(curPresupuesto);

  var codigo: String =  curPresupuesto.valueBuffer("codclientepot");
  if (!codigo)
    return this.iface.__generarPedido(curPresupuesto);

  var util: FLUtil = new FLUtil;
  var res: Object = MessageBox.information(util.translate("scripts",  "Este presupuesto está asociado a un cliente potencial\nA continuación se va a crear un cliente real a partir del cliente potencial\n\n¿Continuar?"), MessageBox.Yes, MessageBox.No, MessageBox.NoButton);

  if (res != MessageBox.Yes)
    return false;

  var curTab: FLSqlCursor = new FLSqlCursor("clientespot");
  curTab.select("codigo = '" + codigo + "'");

  // Código no válido
  if (!curTab.first())
    MessageBox.information(util.translate("scripts",  "El código del cliente potencial del presupuesto no es válido"), MessageBox.Ok, MessageBox.Cancel, MessageBox.NoButton);

  var codCliente: String = formclientespot.iface.pub_aprobarCliente(curTab);
  if (!codCliente)
    return false;

  var curPres: FLSqlCursor = new FLSqlCursor("presupuestoscli");
  curPres.select("idpresupuesto = " + curPresupuesto.valueBuffer("idpresupuesto"));
  if (!curPres.first())
  {
    return false;
  }
  curPres.setActivatedCommitActions(false);
  curPres.setModeAccess(curPres.Edit);
  curPres.refreshBuffer();
  curPres.setValueBuffer("codcliente", codCliente);
  if (!curPres.commitBuffer())
  {
    return false;
  }
  return this.iface.__generarPedido(curPresupuesto);
}
//// CLIENTESPOT //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
