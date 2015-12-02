
/** @class_declaration envioFax */
/////////////////////////////////////////////////////////////////
//// ENVIO FAX //////////////////////////////////////////////////
class envioFax extends oficial
{
  function envioFax(context)
  {
    oficial(context);
  }
  function imprimir(codAlbaran: String)
  {
    return this.ctx.envioFax_imprimir(codAlbaran);
  }
}
//// ENVIO FAX //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition envioFax */
/////////////////////////////////////////////////////////////////
//// ENVIO FAX //////////////////////////////////////////////////
function envioFax_imprimir(codAlbaran: String)
{
  var util: FLUtil = new FLUtil;

  var datosFax: Array = [];
  datosFax["tipoInforme"] = "albaranescli";
  var codCliente: String;
  if (codAlbaran && codAlbaran != "") {
    datosFax["numFax"] = util.sqlSelect("albaranescli INNER JOIN clientes ON albaranescli.codcliente = clientes.codcliente", "clientes.fax", "albaranescli.codigo = '" + codAlbaran + "'", "albaranescli,clientes");
    datosFax["codDocumento"] = codAlbaran;
  } else {
    var cursor: FLSqlCursor = this.cursor();
    datosFax["numFax"] = util.sqlSelect("clientes", "fax", "codcliente = '" + cursor.valueBuffer("codcliente") + "'");
    datosFax["codDocumento"] = cursor.valueBuffer("codigo");
  }
  flfactinfo.iface.datosFax = datosFax;
  this.iface.__imprimir(codAlbaran);
}
//// ENVIO FAX //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
