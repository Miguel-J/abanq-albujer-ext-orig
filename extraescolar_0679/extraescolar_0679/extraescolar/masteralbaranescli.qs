
/** @class_declaration extraescolar */
/////////////////////////////////////////////////////////////////
//// EXTRAESCOLAR ///////////////////////////////////////////////
class extraescolar extends ivaIncluido
{
  function extraescolar(context)
  {
    ivaIncluido(context);
  }
  function datosFactura(curAlbaran, where, datosAgrupacion)
  {
    return this.ctx.extraescolar_datosFactura(curAlbaran, where, datosAgrupacion);
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
function extraescolar_datosFactura(curAlbaran, where, datosAgrupacion)
{
  var _i = this.iface;
  if (!_i.__datosFactura(curAlbaran, where, datosAgrupacion)) {
    return false;
  }
  _i.curFactura.setValueBuffer("codcentroesc", curAlbaran.valueBuffer("codcentroesc"));
  return true;
}

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
