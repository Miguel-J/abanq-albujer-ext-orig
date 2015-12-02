
/** @class_declaration envioFax */
/////////////////////////////////////////////////////////////////
//// ENVIO FAX //////////////////////////////////////////////////
class envioFax extends oficial
{
  function envioFax(context)
  {
    oficial(context);
  }
  function imprimir(codPresupuesto: String)
  {
    return this.ctx.envioFax_imprimir(codPresupuesto);
  }
}
//// ENVIO FAX //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition envioFax */
/////////////////////////////////////////////////////////////////
//// ENVIO FAX //////////////////////////////////////////////////
function envioFax_imprimir(codPresupuesto: String)
{
  var util: FLUtil = new FLUtil;
  var datosFax: Array = [];

  datosFax["tipoInforme"] = "presupuestoscli";
  var codCliente: String;
  if (codPresupuesto && codPresupuesto != "") {
    datosFax["numFax"] = util.sqlSelect("presupuestoscli INNER JOIN clientes ON presupuestoscli.codcliente = clientes.codcliente", "clientes.fax", "presupuestoscli.codigo = '" + codPresupuesto + "'", "presupuestoscli,clientes");
    datosFax["codDocumento"] = codPresupuesto;
  } else {
    var cursor: FLSqlCursor = this.cursor();
    datosFax["numFax"] = util.sqlSelect("clientes", "fax", "codcliente = '" + cursor.valueBuffer("codcliente") + "'");
    datosFax["codDocumento"] = cursor.valueBuffer("codigo");
  }
  flfactinfo.iface.datosFax = datosFax;
  this.iface.__imprimir(codPresupuesto);
}

//// ENVIO FAX //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
