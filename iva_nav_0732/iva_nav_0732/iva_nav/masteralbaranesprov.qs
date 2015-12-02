
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
  var _i = this.iface;
  var valor;

  switch (fN) {
    case "totaliva": {
      var porDto = cursor.valueBuffer("pordtoesp"); /// Por si está instalada la extensión
      porDto = isNaN(porDto) ? 0 : porDto;

      var codGrupoIvaNeg = cursor.valueBuffer("codgrupoivaneg");
      valor = AQUtil.sqlSelect("lineasalbaranesprov la INNER JOIN gruposcontablesivaproneg g ON (la.codimpuesto = g.codimpuesto AND g.codgrupoivaneg = '" + codGrupoIvaNeg + "')", "SUM((la.pvptotal * la.iva * (100 - " + porDto + ")) / 100 / 100)", "la.idalbaran = " + cursor.valueBuffer("idalbaran") + " AND g.tipocalculo <> 'Reversión'", "lineasalbaranesprov");
      valor = parseFloat(AQUtil.roundFieldValue(valor, "albaranesprov", "totaliva"));
      break;
    }
    case "totalrecargo": {
      var porDto = cursor.valueBuffer("pordtoesp"); /// Por si está instalada la extensión
      porDto = isNaN(porDto) ? 0 : porDto;

      var codGrupoIvaNeg = cursor.valueBuffer("codgrupoivaneg");
      valor = AQUtil.sqlSelect("lineasalbaranesprov la INNER JOIN gruposcontablesivaproneg g ON (la.codimpuesto = g.codimpuesto AND g.codgrupoivaneg = '" + codGrupoIvaNeg + "')", "SUM((la.pvptotal * la.recargo * (100 - " + porDto + ")) / 100 / 100)", "la.idalbaran = " + cursor.valueBuffer("idalbaran") + " AND g.tipocalculo <> 'Reversión'", "lineasalbaranesprov");
      valor = parseFloat(AQUtil.roundFieldValue(valor, "albaranesprov", "totaliva"));
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
