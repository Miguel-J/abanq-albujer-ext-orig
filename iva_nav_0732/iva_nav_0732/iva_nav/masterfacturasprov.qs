
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
  var _i = this.iface;
  var valor;

  switch (fN) {
    case "totaliva": {
      var porDto = cursor.valueBuffer("pordtoesp"); /// Por si está instalada la extensión
      porDto = isNaN(porDto) ? 0 : porDto;

      var codGrupoIvaNeg = cursor.valueBuffer("codgrupoivaneg");
      valor = AQUtil.sqlSelect("lineasfacturasprov lf INNER JOIN gruposcontablesivaproneg g ON (lf.codimpuesto = g.codimpuesto AND g.codgrupoivaneg = '" + codGrupoIvaNeg + "')", "SUM((lf.pvptotal * lf.iva * (100 - " + porDto + ")) / 100 / 100)", "lf.idfactura = " + cursor.valueBuffer("idfactura") + " AND g.tipocalculo <> 'Reversión'", "lineasfacturasprov");
      valor = parseFloat(AQUtil.roundFieldValue(valor, "facturasprov", "totaliva"));
      break;
    }
    case "totalrecargo": {
      var porDto = cursor.valueBuffer("pordtoesp"); /// Por si está instalada la extensión
      porDto = isNaN(porDto) ? 0 : porDto;
      valor = AQUtil.sqlSelect("lineasfacturasprov", "SUM((pvptotal * recargo * (100 - " + porDto + ")) / 100 / 100)", "idfactura = " + cursor.valueBuffer("idfactura"));
      valor = parseFloat(AQUtil.roundFieldValue(valor, "facturasprov", "totalrecargo"));
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
