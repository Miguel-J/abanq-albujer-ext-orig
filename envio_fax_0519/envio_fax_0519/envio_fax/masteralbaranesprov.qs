
/** @class_declaration envioFax */
/////////////////////////////////////////////////////////////////
//// ENVIO_FAX //////////////////////////////////////////////////
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
//// ENVIO_FAX //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition envioFax */
/////////////////////////////////////////////////////////////////
//// ENVIO_FAX //////////////////////////////////////////////////
function envioFax_imprimir(codAlbaran: String)
{
  var util: FLUtil = new FLUtil;

  var datosFax: Array = [];
  datosFax["tipoInforme"] = "albaranesprov";
  var codProveedor: String;
  if (codAlbaran && codAlbaran != "") {
    datosFax["numFax"] = util.sqlSelect("albaranesprov INNER JOIN proveedores ON albaranesprov.codproveedor = proveedores.codproveedor", "proveedores.fax", "albaranesprov.codigo = '" + codAlbaran + "'", "albaranesprov,proveedores");
    datosFax["codDocumento"] = codAlbaran;
  } else {
    var cursor: FLSqlCursor = this.cursor();
    datosFax["numFax"] = util.sqlSelect("proveedores", "fax", "codproveedor = '" + cursor.valueBuffer("codproveedor") + "'");
    datosFax["codDocumento"] = cursor.valueBuffer("codigo");
  }
  flfactinfo.iface.datosFax = datosFax;
  this.iface.__imprimir(codAlbaran);
}

//// ENVIO_FAX //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
