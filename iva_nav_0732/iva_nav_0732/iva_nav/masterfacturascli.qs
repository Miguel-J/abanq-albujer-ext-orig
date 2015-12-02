
/** @class_declaration ivaNav */
/////////////////////////////////////////////////////////////////
//// IVA NAV ////////////////////////////////////////////////////
class ivaNav extends oficial
{
  function ivaNav(context)
  {
    oficial(context);
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
      valor = AQUtil.sqlSelect("lineasfacturascli", "SUM((pvptotal * iva * (100 - " + porDto + ")) / 100 / 100)", "idfactura = " + cursor.valueBuffer("idfactura"), undefined, cx);
      valor = parseFloat(AQUtil.roundFieldValue(valor, "facturascli", "totaliva"));
      break;
    }
    case "totalrecargo": {
      var porDto = _i.damePorDtoCabecera(cursor);
      valor = AQUtil.sqlSelect("lineasfacturascli", "SUM((pvptotal * recargo * (100 - " + porDto + ")) / 100 / 100)", "idfactura = " + cursor.valueBuffer("idfactura"), undefined, cx);
      valor = parseFloat(AQUtil.roundFieldValue(valor, "facturascli", "totalrecargo"));
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
