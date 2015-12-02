
/** @class_declaration canarias */
/////////////////////////////////////////////////////////////////
//// CANARIAS ///////////////////////////////////////////////////
class canarias extends oficial
{
  function canarias(context)
  {
    oficial(context);
  }
  function datosPieFactura(nodo: FLDomNode, campo: String): Number {
    return this.ctx.canarias_datosPieFactura(nodo, campo);
  }
}
//// CANARIAS ///////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition canarias */
/////////////////////////////////////////////////////////////////
//// CANARIAS ///////////////////////////////////////////////////
function canarias_datosPieFactura(nodo: FLDomNode, campo: String): Number {
  var util: FLUtil = new FLUtil();
  var sCampo: String = campo.toString();
  var tablaFacturas: String;
  var tablaIva: String;
  if (sCampo.charAt(0) == "P" && sCampo.charAt(1) == "_")
  {
    campo = "";
    for (var i: Number = 2; i < sCampo.length; i++)
      campo += sCampo.charAt(i);
    tablaFacturas = "facturasprov";
    tablaIva = "lineasivafactprov";
  } else {
    tablaFacturas = "facturascli";
    tablaIva = "lineasivafactcli";
  }

  var idFactura: Number = nodo.attributeValue(tablaFacturas + ".idfactura");
  var util: FLUtil = new FLUtil;
  var res: Number;
  if (campo == "BI_IGIC")
  {
    res = util.sqlSelect(tablaIva, "neto", "idfactura = " + idFactura);
  } else if (campo == "IGIC")
  {
    res = util.sqlSelect(tablaIva, "totaliva", "idfactura = " + idFactura);
  } else if (campo == "RE_IGIC")
  {
    res = util.sqlSelect(tablaIva, "totalrecargo", "idfactura = " + idFactura);
  } else if (campo == "POR_RE_IGIC")
  {
    res = util.sqlSelect(tablaIva, "recargo", "idfactura = " + idFactura + " AND iva = 5");
    if (res && parseFloat(res) != 0)
      res += "%";
  } else if (campo == "T_IGIC")
  {
    res = util.sqlSelect(tablaIva, "totallinea", "idfactura = " + idFactura);
  } else {
    return this.iface.__datosPieFactura(nodo, campo);
  }
  if (parseFloat(res) == 0 || !res)
    res = "";
  return res;
}
//// CANARIAS ///////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
