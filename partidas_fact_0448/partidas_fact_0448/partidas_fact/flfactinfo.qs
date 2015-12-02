
/** @class_declaration partidas */
/////////////////////////////////////////////////////////////////
//// PARTIDAS //////////////////////////////////////////////
class partidas extends oficial
{
  function partidas(context)
  {
    oficial(context);
  }
  function calcularPrecioCapitulo(nodo: FLDomNode, campo: String): Number {
    return this.ctx.partidas_calcularPrecioCapitulo(nodo, campo);
  }
  function calcularPorCapitulo(nodo: FLDomNode, campo: String): Number {
    return this.ctx.partidas_calcularPorCapitulo(nodo, campo);
  }
  function mostrarDescuento(nodo: FLDomNode, campo: String): String {
    return this.ctx.partidas_mostrarDescuento(nodo, campo);
  }
  function mostrarLabelDescuento(nodo: FLDomNode, campo: String): String {
    return this.ctx.partidas_mostrarLabelDescuento(nodo, campo);
  }
}
//// PARTIDAS //////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pubPartidasFact */
/////////////////////////////////////////////////////////////////
//// PUB_PARTIDAS_FACT //////////////////////////////////////////
class pubPartidasFact extends ifaceCtx
{
  function pubPartidasFact(context)
  {
    ifaceCtx(context);
  }
  function pub_calcularPrecioCapitulo(nodo: FLDomNode, campo: String): Number {
    return this.calcularPrecioCapitulo(nodo, campo);
  }
  function pub_calcularPorCapitulo(nodo: FLDomNode, campo: String): Number {
    return this.calcularPorCapitulo(nodo, campo);
  }
  function pub_mostrarDescuento(nodo: FLDomNode, campo: String): String {
    return this.mostrarDescuento(nodo, campo);
  }
  function pub_mostrarLabelDescuento(nodo: FLDomNode, campo: String): String {
    return this.mostrarLabelDescuento(nodo, campo);
  }
}
//// PUB_PARTIDAS_FACT //////////////////////////////////////////
/////////////////////////////////////////////////////////////////


/** @class_definition partidas */
/////////////////////////////////////////////////////////////////
//// PARTIDAS //////////////////////////////////////////////////
function partidas_calcularPrecioCapitulo(nodo: FLDomNode, campo: String): Number {
  var util: FLUtil = new FLUtil();
  var precio: Number = 0;
  if (nodo.attributeValue("partidas.idpartida"))
  {
    precio = util.sqlSelect("lineaspresupuestoscli", "SUM(pvptotal)", "idpartida = " + nodo.attributeValue("partidas.idpartida"));
  }
  return precio;
}

function partidas_calcularPorCapitulo(nodo: FLDomNode, campo: String): Number {
  var util: FLUtil = new FLUtil();
  var porcentaje: Number;
  var totalPartida: Number = 0;
  var totalPresupuesto: Number = util.sqlSelect("lineaspresupuestoscli", "SUM(pvptotal)", "idpresupuesto = " + nodo.attributeValue("presupuestoscli.idpresupuesto"));
  if (nodo.attributeValue("partidas.idpartida"))
  {
    totalPartida = util.sqlSelect("lineaspresupuestoscli", "SUM(pvptotal)", "idpartida = " + nodo.attributeValue("partidas.idpartida"));
  }
  if (totalPresupuesto != 0)
  {
    porcentaje = (totalPartida * 100) / totalPresupuesto;
  }
  return porcentaje;
}

function partidas_mostrarDescuento(nodo: FLDomNode, campo: String): String {
  var util: FLUtil = new FLUtil();
  var valor: String;
  if (nodo.attributeValue(campo) != 0)
  {
    valor = nodo.attributeValue(campo);
    valor = util.roundFieldValue(valor, "presupuestoscli", "pordtoesp");
    valor += "%";
  } else {
    valor = "";
  }
  return valor;
}

function partidas_mostrarLabelDescuento(nodo: FLDomNode, campo: String): String {
  var valor: String;
  if (nodo.attributeValue(campo) != 0)
  {
    valor = "Dto.";
  } else {
    valor = " ";
  }
  return valor;
}

//// PARTIDAS ///////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
