
/** @class_declaration envioFax */
/////////////////////////////////////////////////////////////////
//// ENVIO FAX //////////////////////////////////////////////////
class envioFax extends oficial
{
  function envioFax(context)
  {
    oficial(context);
  }
  function imprimir(codPedido: String)
  {
    return this.ctx.envioFax_imprimir(codPedido);
  }
}
//// ENVIO FAX //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition envioFax */
/////////////////////////////////////////////////////////////////
//// ENVIO FAX //////////////////////////////////////////////////
function envioFax_imprimir(codPedido: String)
{
  var util: FLUtil = new FLUtil;

  var datosFax: Array = [];
  datosFax["tipoInforme"] = "pedidoscli";
  var codCliente: String;
  if (codPedido && codPedido != "") {
    datosFax["numFax"] = util.sqlSelect("pedidoscli INNER JOIN clientes ON pedidoscli.codcliente = clientes.codcliente", "clientes.fax", "pedidoscli.codigo = '" + codPedido + "'", "pedidoscli,clientes");
    datosFax["codDocumento"] = codPedido;
  } else {
    var cursor: FLSqlCursor = this.cursor();
    datosFax["numFax"] = util.sqlSelect("clientes", "fax", "codcliente = '" + cursor.valueBuffer("codcliente") + "'");
    datosFax["codDocumento"] = cursor.valueBuffer("codigo");
  }
  flfactinfo.iface.datosFax = datosFax;
  this.iface.__imprimir(codPedido);
}
//// ENVIO FAX //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
