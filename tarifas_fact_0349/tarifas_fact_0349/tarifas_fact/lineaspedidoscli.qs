
/** @class_declaration tarifasFact */
//////////////////////////////////////////////////////////////////
//// tarifasFact //////////////////////////////////////////////////////
class tarifasFact extends oficial
{
  function tarifasFact(context)
  {
    oficial(context);
  }
  function obtenerTarifa(codCliente: String, cursor: FLSqlCursor): String {
    return this.ctx.tarifasFact_obtenerTarifa(codCliente, cursor);
  }
}
//// tarifasFact //////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_definition tarifasFact */
/////////////////////////////////////////////////////////////////
//// tarifasFact /////////////////////////////////////////////////////

function tarifasFact_obtenerTarifa(codCliente: String, cursor: FLSqlCursor): String {
  var util: FLUtil = new FLUtil;

  var codTarifa: String = cursor.cursorRelation().valueBuffer("codtarifa");
  if (codTarifa)
    return codTarifa;

  return util.sqlSelect("clientes c INNER JOIN gruposclientes gc ON c.codgrupo = gc.codgrupo", "gc.codtarifa", "codcliente = '" + codCliente + "'", "clientes,gruposclientes");
}

//// tarifasFact /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
