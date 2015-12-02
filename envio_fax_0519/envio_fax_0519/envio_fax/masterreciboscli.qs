
/** @class_declaration envioFax */
/////////////////////////////////////////////////////////////////
//// ENVIO_FAX //////////////////////////////////////////////////
class envioFax extends oficial
{
  function envioFax(context)
  {
    oficial(context);
  }
  function imprimir(codRecibo: String)
  {
    return this.ctx.envioFax_imprimir(codRecibo)
  }
}
       //// ENVIO_FAX //////////////////////////////////////////////////
       /////////////////////////////////////////////////////////////////

       /** @class_definition envioFax */
       /////////////////////////////////////////////////////////////////
       //// ENVIO_FAX //////////////////////////////////////////////////
       function envioFax_imprimir(codRecibo: String)
{
  debug("envioFax_imprimir " + codRecibo);
  var util: FLUtil = new FLUtil;

  var datosFax: Array = [];
  datosFax["tipoInforme"] = "reciboscli";
  var codCliente: String;
  if (codRecibo && codRecibo != "") {
    datosFax["numFax"] = util.sqlSelect("reciboscli INNER JOIN clientes ON reciboscli.codcliente = clientes.codcliente", "clientes.fax", "reciboscli.codigo = '" + codRecibo + "'", "reciboscli,clientes");
    datosFax["codDocumento"] = codRecibo;
  } else {
    var cursor: FLSqlCursor = this.cursor();
    datosFax["numFax"] = util.sqlSelect("clientes", "fax", "codcliente = '" + cursor.valueBuffer("codcliente") + "'");
    datosFax["codDocumento"] = cursor.valueBuffer("codigo");
  }
  flfactinfo.iface.datosFax = datosFax;
  this.iface.__imprimir(codRecibo);
}

//// ENVIO_FAX //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
