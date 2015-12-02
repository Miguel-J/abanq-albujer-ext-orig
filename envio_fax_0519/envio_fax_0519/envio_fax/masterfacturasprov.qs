
/** @class_declaration envioFax */
/////////////////////////////////////////////////////////////////
//// ENVIO_FAX //////////////////////////////////////////////////
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
//// ENVIO_FAX //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition envioFax */
/////////////////////////////////////////////////////////////////
//// ENVIO_FAX //////////////////////////////////////////////////
function envioFax_imprimir(codFactura: String)
{
  var util: FLUtil = new FLUtil;

  var datosFax: Array = [];
  datosFax["tipoInforme"] = "facturasprov";
  var codProveedor: String;
  if (codFactura && codFactura != "") {
    datosFax["numFax"] = util.sqlSelect("facturasprov INNER JOIN proveedores ON facturasprov.codproveedor = proveedores.codproveedor", "proveedores.fax", "facturasprov.codigo = '" + codFactura + "'", "facturasprov,proveedores");
    datosFax["codDocumento"] = codFactura;
  } else {
    var cursor: FLSqlCursor = this.cursor();
    datosFax["numFax"] = util.sqlSelect("proveedores", "fax", "codproveedor = '" + cursor.valueBuffer("codproveedor") + "'");
    datosFax["codDocumento"] = cursor.valueBuffer("codigo");
  }
  flfactinfo.iface.datosFax = datosFax;
  this.iface.__imprimir(codFactura);
}

//// ENVIO_FAX //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
