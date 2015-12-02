
/** @class_declaration ivaNav */
/////////////////////////////////////////////////////////////////
//// IVA NAV ////////////////////////////////////////////////////
class ivaNav extends oficial
{
  function ivaNav(context)
  {
    oficial(context);
  }
  function datosAlbaran(curPedido, where, datosAgrupacion)
  {
    return this.ctx.ivaNav_datosAlbaran(curPedido, where, datosAgrupacion);
  }
  function commonCalculateField(fN, cursor)
  {
    return this.ctx.ivaNav_commonCalculateField(fN, cursor);
  }
}
//// IVA NAV ////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition ivaNav */
/////////////////////////////////////////////////////////////////
//// IVA NAV ////////////////////////////////////////////////////
function ivaNav_datosAlbaran(curPedido, where, datosAgrupacion)
{
  var _i = this.iface;
  if (!_i.__datosAlbaran(curPedido, where, datosAgrupacion)) {
    return false;
  }
  _i.curAlbaran.setValueBuffer("codgrupoivaneg", curPedido.valueBuffer("codgrupoivaneg"));
  return true;
}


function ivaNav_commonCalculateField(fN, cursor)
{
  var cx;
  try {
    cx = cursor.connectionName();
  } catch (e) {
    cx = "default";
  }
  var _i = this.iface;
  var valor;

  switch (fN) {
    case "totaliva": {
      var porDto = _i.damePorDtoCabecera(cursor);
      valor = AQUtil.sqlSelect("lineaspedidoscli", "SUM((pvptotal * iva * (100 - " + porDto + ")) / 100 / 100)", "idpedido = " + cursor.valueBuffer("idpedido"), undefined, cx);
      valor = parseFloat(AQUtil.roundFieldValue(valor, "pedidoscli", "totaliva"));
      break;
    }
    case "totalrecargo": {
      var porDto = _i.damePorDtoCabecera(cursor);
      valor = AQUtil.sqlSelect("lineaspedidoscli", "SUM((pvptotal * recargo * (100 - " + porDto + ")) / 100 / 100)", "idpedido = " + cursor.valueBuffer("idpedido"), undefined, cx);
      valor = parseFloat(AQUtil.roundFieldValue(valor, "pedidoscli", "totalrecargo"));
      break;
    }
    default: {
      valor = _i.__commonCalculateField(fN, cursor);
    }
  }
  return valor;
}
//// IVA NAV ////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
