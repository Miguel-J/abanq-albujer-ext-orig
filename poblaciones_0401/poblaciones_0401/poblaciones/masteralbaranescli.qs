
/** @class_declaration pobla */
/////////////////////////////////////////////////////////////////
//// POBLACIONES ////////////////////////////////////////////////
class pobla extends oficial
{
  function pobla(context)
  {
    oficial(context);
  }
  function commonCalculateField(fN: String, cursor: FLSqlCursor): String {
    return this.ctx.pobla_commonCalculateField(fN, cursor);
  }
}
//// POBLACIONES ////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition pobla */
/////////////////////////////////////////////////////////////////
//// POBLACIONES ////////////////////////////////////////////////
function pobla_commonCalculateField(fN: String, cursor: FLSqlCursor): String {
  var util: FLUtil = new FLUtil();
  var valor: String;

  switch (fN)
  {
    case "ciudad": {
      valor = util.sqlSelect("dirclientes", "ciudad", "id = " + cursor.valueBuffer("coddir"));
      if (!valor) {
        valor = cursor.valueBuffer("ciudad");
      }
      break;
    }
    default: {
      valor = this.iface.__commonCalculateField(fN, cursor);
      break;
    }
  }
  return valor;
}
//// POBLACIONES ////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
