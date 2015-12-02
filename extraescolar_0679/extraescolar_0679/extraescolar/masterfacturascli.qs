
/** @class_declaration extraescolar */
/////////////////////////////////////////////////////////////////
//// EXTRAESCOLAR ///////////////////////////////////////////////
class extraescolar extends oficial
{
  function extraescolar(context)
  {
    oficial(context);
  }
  function commonCalculateField(fN, cursor)
  {
    return this.ctx.extraescolar_commonCalculateField(fN, cursor);
  }
}
//// EXTRAESCOLAR ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition extraescolar */
/////////////////////////////////////////////////////////////////
//// EXTRAESCOLAR ///////////////////////////////////////////////
function extraescolar_commonCalculateField(fN, cursor)
{
  var util = new FLUtil();
  var valor;
  switch (fN) {
      /** \C
      Busca el centro para el primer alumno que encuentra del cliente
      \end */
    case "codcentroesc": {
      valor = util.sqlSelect("clientes", "codcentroesc", "codcliente = '" + cursor.valueBuffer("codcliente") + "'");
      break;
    }
    default: {
      valor = this.iface.__commonCalculateField(fN, cursor);
      break;
    }
  }
  return valor;
}
//// EXTRAESCOLAR ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
