
/** @class_declaration envases */
/////////////////////////////////////////////////////////////////
//// ENVASES ////////////////////////////////////////////////////
class envases extends oficial
{
  function envases(context)
  {
    oficial(context);
  }
  function commonCalculateField(fN: String, cursor: FLSqlCursor): String {
    return this.ctx.envases_commonCalculateField(fN, cursor);
  }
  function bufferChanged(fN: String)
  {
    return this.ctx.envases_bufferChanged(fN);
  }
}
//// ENVASES ////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition envases */
/////////////////////////////////////////////////////////////////
//// ENVASES ////////////////////////////////////////////////////
function envases_bufferChanged(fN: String)
{
  var cursor: FLSqlCursor = this.cursor();
  switch (fN) {
    case "canenvases":
    case "valormetrico":
      this.child("fdbCantidad").setValue(this.iface.calculateField("cantidad"));
      break;
      /** \C Al seleccionar un --codenvase--, se establece automáticamente los valores --referencia-- y --valormetrico-- asociados
      \end */
    case "codenvase":
      this.child("fdbReferencia").setValue(this.iface.calculateField("referencia"));
      this.child("fdbValorMetrico").setValue(this.iface.calculateField("valormetrico"));
      break;
    default:
      this.iface.__bufferChanged(fN);
      break;
  }
}

function envases_commonCalculateField(fN: String, cursor: FLSqlCursor): String {
  var util: FLUtil = new FLUtil();
  var valor: String;

  switch (fN)
  {
      /** \C --cantidad-- es el producto de --valormetrico-- por --canenvases--
      \end */
    case "cantidad":
      valor = parseFloat(cursor.valueBuffer("canenvases")) * parseFloat(cursor.valueBuffer("valormetrico"));
      break;
    case "referencia":
      var codEnvase = cursor.valueBuffer("codEnvase");
      var referencia = util.sqlSelect("envases", "referencia", "codEnvase = '" + codEnvase + "'");
      if (referencia)
        valor = referencia;
      break;
    case "valormetrico":
      var codEnvase = cursor.valueBuffer("codEnvase");
      var cantidad = util.sqlSelect("envases", "cantidad", "codEnvase = '" + codEnvase + "'");
      valor = 1;
      if (cantidad)
        valor = cantidad;
      break;
    default:
      valor = this.iface.__commonCalculateField(fN, cursor);
      break;
  }
  return valor;
}
//// ENVASES ////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////
