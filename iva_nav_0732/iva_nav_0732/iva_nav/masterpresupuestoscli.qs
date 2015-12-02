
/** @class_declaration ivaNav */
/////////////////////////////////////////////////////////////////
//// IVA NAV ////////////////////////////////////////////////////
class ivaNav extends oficial
{
  function ivaNav(context)
  {
    oficial(context);
  }
  function datosPedido(curPresupuesto, where, datosAgrupacion)
  {
    return this.ctx.ivaNav_datosPedido(curPresupuesto, where, datosAgrupacion);
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
function ivaNav_datosPedido(curPresupuesto, where, datosAgrupacion)
{
  var _i = this.iface;
  if (!_i.__datosPedido(curPresupuesto, where, datosAgrupacion)) {
    return false;
  }
  _i.curPedido.setValueBuffer("codgrupoivaneg", curPresupuesto.valueBuffer("codgrupoivaneg"));
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
      valor = AQUtil.sqlSelect("lineaspresupuestoscli", "SUM((pvptotal * iva * (100 - " + porDto + ")) / 100 / 100)", "idpresupuesto = " + cursor.valueBuffer("idpresupuesto"), undefined, cx);
      valor = parseFloat(AQUtil.roundFieldValue(valor, "presupuestoscli", "totaliva"));
      break;
    }
    case "totalrecargo": {
      var porDto = _i.damePorDtoCabecera(cursor);
      valor = AQUtil.sqlSelect("lineaspresupuestoscli", "SUM((pvptotal * recargo * (100 - " + porDto + ")) / 100 / 100)", "idpresupuesto = " + cursor.valueBuffer("idpresupuesto"), undefined, cx);
      valor = parseFloat(AQUtil.roundFieldValue(valor, "presupuestoscli", "totalrecargo"));
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
