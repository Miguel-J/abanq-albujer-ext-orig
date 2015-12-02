
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
  var _i = this.iface;
  var valor;

  switch (fN) {
    case "totaliva": {
      var porDto = cursor.valueBuffer("pordtoesp"); /// Por si está instalada la extensión
      porDto = isNaN(porDto) ? 0 : porDto;

      var codGrupoIvaNeg = cursor.valueBuffer("codgrupoivaneg");
      valor = AQUtil.sqlSelect("lineaspedidosprov lp INNER JOIN gruposcontablesivaproneg g ON (lp.codimpuesto = g.codimpuesto AND g.codgrupoivaneg = '" + codGrupoIvaNeg + "')", "SUM((lp.pvptotal * lp.iva * (100 - " + porDto + ")) / 100 / 100)", "lp.idpedido = " + cursor.valueBuffer("idpedido") + " AND g.tipocalculo <> 'Reversión'", "lineaspedidosprov");
      valor = parseFloat(AQUtil.roundFieldValue(valor, "pedidosprov", "totaliva"));
      break;
    }
    case "totalrecargo": {
      var porDto = cursor.valueBuffer("pordtoesp"); /// Por si está instalada la extensión
      porDto = isNaN(porDto) ? 0 : porDto;

      var codGrupoIvaNeg = cursor.valueBuffer("codgrupoivaneg");
      valor = AQUtil.sqlSelect("lineaspedidosprov lp INNER JOIN gruposcontablesivaproneg g ON (lp.codimpuesto = g.codimpuesto AND g.codgrupoivaneg = '" + codGrupoIvaNeg + "')", "SUM((lp.pvptotal * lp.recargo * (100 - " + porDto + ")) / 100 / 100)", "lp.idpedido = " + cursor.valueBuffer("idpedido") + " AND g.tipocalculo <> 'Reversión'", "lineaspedidosprov");
      valor = parseFloat(AQUtil.roundFieldValue(valor, "pedidosprov", "totaliva"));
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
