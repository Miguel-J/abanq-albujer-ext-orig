
/** @class_declaration multiempresa */
/////////////////////////////////////////////////////////////////
//// MULTIEMPRESA //////////////////////////////////////////////
class multiempresa extends oficial
{
  function multiempresa(context)
  {
    oficial(context);
  }
  function logo(nodo: FLDomNode, campo: String): String {
    return this.ctx.multiempresa_logo(nodo, campo);
  }
}
//// MULTIEMPRESA //////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition multiempresa */
/////////////////////////////////////////////////////////////////
//// MULTIEMPRESA //////////////////////////////////////////////
/** \D
Obtiene el xpm del logo de la empresa asociada al ejercicio seleccionado
@return xpm del logo
*/
function multiempresa_logo(nodo: FLDomNode, campo: String): String {
  var util: FLUtil = new FLUtil;
  switch (campo)
  {
    case "presupuestoscli":
    case "pedidoscli":
    case "albaranescli":
    case "facturascli":
    case "pedidosprov":
    case "albaranesprov":
    case "facturasprov": {
      valor = util.sqlSelect("empresa e INNER JOIN ejercicios ej ON e.id = ej.idempresa", "e.logo", "ej.codejercicio = '" + nodo.attributeValue(campo + ".codejercicio") + "'", "empresa,ejercicios");
      break;
    }
    default: {
      valor = this.iface.__logo(nodo, campo);
    }
  }
  return valor;
}

//// MULTIEMPRESA //////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
