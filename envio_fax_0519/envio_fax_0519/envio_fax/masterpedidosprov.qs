
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
  datosFax["tipoInforme"] = "pedidosprov";
  var codProveedor: String;
  if (codPedido && codPedido != "") {
    datosFax["numFax"] = util.sqlSelect("pedidosprov INNER JOIN proveedores ON pedidosprov.codproveedor = proveedores.codproveedor", "proveedores.fax", "pedidosprov.codigo = '" + codPedido + "'", "pedidosprov,proveedores");
    datosFax["codDocumento"] = codPedido;
  } else {
    var cursor: FLSqlCursor = this.cursor();
    datosFax["numFax"] = util.sqlSelect("proveedores", "fax", "codproveedor = '" + cursor.valueBuffer("codproveedor") + "'");
    datosFax["codDocumento"] = cursor.valueBuffer("codigo");
  }
  flfactinfo.iface.datosFax = datosFax;
  this.iface.__imprimir(codPedido);
}
//// ENVIO FAX //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
