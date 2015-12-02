
/** @class_declaration tarifasFact */
//////////////////////////////////////////////////////////////////
//// tarifasFact //////////////////////////////////////////////////////
class tarifasFact extends oficial
{
  function tarifasFact(context)
  {
    oficial(context);
  }
  function datosAlbaran(curPedido: FLSqlCursor, where: String, datosAgrupacion: Array): Boolean {
    return this.ctx.tarifasFact_datosAlbaran(curPedido, where, datosAgrupacion);
  }
  function commonCalculateField(fN: String, cursor: FLSqlCursor): String {
    return this.ctx.tarifasFact_commonCalculateField(fN, cursor);
  }
}
//// tarifasFact //////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_definition tarifasFact */
/////////////////////////////////////////////////////////////////
//// tarifasFact /////////////////////////////////////////////////////

function tarifasFact_datosAlbaran(curPedido: FLSqlCursor, where: String, datosAgrupacion: Array): Boolean {
  if (!this.iface.__datosAlbaran(curPedido, where, datosAgrupacion))
    return false;

  with(this.iface.curAlbaran)
  {
    setValueBuffer("codtarifa", curPedido.valueBuffer("codtarifa"));
  }

  return true;
}

function tarifasFact_commonCalculateField(fN: String, cursor: FLSqlCursor): String {
  var util = new FLUtil();
  var valor;

  switch (fN)
  {
    case "codtarifa":
      valor = util.sqlSelect("clientes c inner join gruposclientes g on c.codgrupo = g.codgrupo", "g.codtarifa", "c.codcliente = '" + cursor.valueBuffer("codcliente") + "'", "clientes,gruposclientes");
      if (!valor)
        valor = "";
      break;
    default:
      return this.iface.__commonCalculateField(fN, cursor);
  }
  return valor;
}

//// tarifasFact /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
