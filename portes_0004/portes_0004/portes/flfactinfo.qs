
/** @class_declaration portes */
/////////////////////////////////////////////////////////////////
//// PORTES /////////////////////////////////////////////////////
class portes extends oficial
{
  function portes(context)
  {
    oficial(context);
  }
  function porIVA(nodo, campo)
  {
    return this.ctx.portes_porIVA(nodo, campo);
  }
}
//// PORTES /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition portes */
/////////////////////////////////////////////////////////////////
//// PORTES /////////////////////////////////////////////////////
function portes_porIVA(nodo, campo)
{
  var _i = this.iface;

  var util = new FLUtil;
  var idDocumento: String;
  var tablaPadre: String;
  var tabla: String;
  var campoClave: String;
  var textoPorIva = _i.__porIVA(nodo, campo);
  if (_i.variosIvas_) {
    return textoPorIva;
  }
  switch (campo) {
    case "facturacli": {
      tablaPadre = "facturascli";
      tabla = "lineasfacturascli";
      campoClave = "idfactura";
      break;
    }
    case "albarancli": {
      tablaPadre = "albaranescli";
      tabla = "lineasalbaranescli";
      campoClave = "idalbaran";
      break;
    }
    case "pedidocli": {
      tablaPadre = "pedidoscli";
      tabla = "lineaspedidoscli";
      campoClave = "idpedido";
      break;
    }
    case "presupuestocli": {
      tablaPadre = "presupuestoscli";
      tabla = "lineaspresupuestoscli";
      campoClave = "idpresupuesto";
      break;
    }
    default: {
      return textoPorIva;
    }
  }
  idDocumento = nodo.attributeValue(tablaPadre + "." + campoClave);
  var porIva2 = parseFloat(util.sqlSelect(tabla, "iva", campoClave + " = " + idDocumento));
  if (!porIva2) {
    porIva2 = 0;
  }
  if (util.sqlSelect(tablaPadre, "ivaportes", campoClave + " = " + idDocumento) != porIva2) {
    _i.variosIvas_ = true;
  }
  if (_i.variosIvas_) {
    return "I.V.A.";
  } else {
    return textoPorIva;
  }
}
//// PORTES /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
