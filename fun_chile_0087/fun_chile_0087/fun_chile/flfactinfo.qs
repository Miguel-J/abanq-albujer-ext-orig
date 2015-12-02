
/** @class_declaration funChile */
/////////////////////////////////////////////////////////////////
//// FUN_CHILE //////////////////////////////////////////////////

class funChile extends oficial
{
  function funChile(context)
  {
    oficial(context);
  }
  function datosPieFactura(nodo: FLDomNode, campo: String): Number {
    return this.ctx.funChile_datosPieFactura(nodo, campo);
  }
}

//// FUN_CHILE //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition funChile */
/////////////////////////////////////////////////////////////////
//// FUN_CHILE //////////////////////////////////////////////////

function funChile_datosPieFactura(nodo: FLDomNode, campo: String)
{
  var util: FLUtil = new FLUtil();
  var sCampo: String = campo.toString();
  var tablaFacturas: String;
  var tablaIva: String;
  var tablaLineasFactura: String;

  if (sCampo.charAt(0) == "P"
      && sCampo.charAt(1) == "_") {
    tablaFacturas = "facturasprov";
    tablaIva = "lineasivafactprov";
    tablaLineasFactura = "lineasfacturasprov";
    campo = "";
    for (var i: Number = 2; i < sCampo.length; i++)
      campo += sCampo.charAt(i);
  } else {
    tablaFacturas = "facturascli";
    tablaIva = "lineasivafactcli";
    tablaLineasFactura = "lineasfacturascli";
  }

  var idFactura: Number = nodo.attributeValue(tablaFacturas + ".idfactura");
  var iva: Number = parseFloat(nodo.attributeValue(tablaLineasFactura + ".iva"));
  var pvpunitario: Number = parseFloat(nodo.attributeValue(tablaLineasFactura + ".pvpunitario"));
  var pvptotal: Number = parseFloat(nodo.attributeValue(tablaLineasFactura + ".pvptotal"));
  var util: FLUtil = new FLUtil;
  var res: Number;

  if (campo == "BI19") {
    res = util.sqlSelect(tablaIva, "neto", "idfactura = " + idFactura + " AND iva = 19");
  } else if (campo == "IVA19") {
    res = util.sqlSelect(tablaIva, "totaliva", "idfactura = " + idFactura + " AND iva = 19");
  } else if (campo == "T19") {
    res = util.sqlSelect(tablaIva, "totallinea", "idfactura = " + idFactura + " AND iva = 19");
  } else if (campo == "TL") {
    res = util.sqlSelect(tablaFacturas, "total", "idfactura = " + idFactura);
    return util.enLetraMoneda(res, "");
  } else if (campo == "PVPUNIIVA") {
    res = util.buildNumber((pvpunitario * iva / 100) + pvpunitario, 'f', 2);
  } else if (campo == "PVPTOTIVA") {
    res = util.buildNumber((pvptotal * iva / 100) + pvptotal, 'f', 2);
  }

  if (parseFloat(res) == 0 || !res)
    res = "";
  return res;
}

//// FUN_CHILE //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
