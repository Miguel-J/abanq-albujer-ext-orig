
/** @class_declaration envioFax */
/////////////////////////////////////////////////////////////////
//// ENVIO FAX //////////////////////////////////////////////////
class envioFax extends oficial
{
  function envioFax(context)
  {
    oficial(context);
  }
  function imprimir(codFactura: String)
  {
    return this.ctx.envioFax_imprimir(codFactura);
  }
}
//// ENVIO FAX //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition envioFax */
/////////////////////////////////////////////////////////////////
//// ENVIO FAX //////////////////////////////////////////////////
function envioFax_imprimir(codFactura: String)
{
  var util: FLUtil = new FLUtil;

  var datosFax: Array = [];
  datosFax["tipoInforme"] = "facturascli";
  var codCliente: String;
  if (codFactura && codFactura != "") {
    datosFax["numFax"] = util.sqlSelect("facturascli INNER JOIN clientes ON facturascli.codcliente = clientes.codcliente", "clientes.fax", "facturascli.codigo = '" + codFactura + "'", "facturascli,clientes");
    datosFax["codDocumento"] = codFactura;
  } else {
    var cursor: FLSqlCursor = this.cursor();
    datosFax["numFax"] = util.sqlSelect("clientes", "fax", "codcliente = '" + cursor.valueBuffer("codcliente") + "'");
    datosFax["codDocumento"] = cursor.valueBuffer("codigo");
  }
  flfactinfo.iface.datosFax = datosFax;
  this.iface.__imprimir(codFactura);
}
//// ENVIO FAX //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
