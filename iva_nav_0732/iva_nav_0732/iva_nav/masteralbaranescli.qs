
/** @class_declaration ivaNav */
/////////////////////////////////////////////////////////////////
//// IVA NAV ////////////////////////////////////////////////////
class ivaNav extends oficial
{
  function ivaNav(context)
  {
    oficial(context);
  }
  function datosFactura(curAlbaran, where, datosAgrupacion)
  {
    return this.ctx.ivaNav_datosFactura(curAlbaran, where, datosAgrupacion);
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
function ivaNav_datosFactura(curAlbaran, where, datosAgrupacion)
{
  var _i = this.iface;
  if (!_i.__datosFactura(curAlbaran, where, datosAgrupacion)) {
    return false;
  }
  _i.curFactura.setValueBuffer("codgrupoivaneg", curAlbaran.valueBuffer("codgrupoivaneg"));
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
      valor = AQUtil.sqlSelect("lineasalbaranescli", "SUM((pvptotal * iva * (100 - " + porDto + ")) / 100 / 100)", "idalbaran = " + cursor.valueBuffer("idalbaran"), undefined, cx);
      valor = parseFloat(AQUtil.roundFieldValue(valor, "albaranescli", "totaliva"));
      break;
    }
    case "totalrecargo": {
      var porDto = _i.damePorDtoCabecera(cursor);
      valor = AQUtil.sqlSelect("lineasalbaranescli", "SUM((pvptotal * recargo * (100 - " + porDto + ")) / 100 / 100)", "idalbaran = " + cursor.valueBuffer("idalbaran"), undefined, cx);
      valor = parseFloat(AQUtil.roundFieldValue(valor, "albaranescli", "totalrecargo"));
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
