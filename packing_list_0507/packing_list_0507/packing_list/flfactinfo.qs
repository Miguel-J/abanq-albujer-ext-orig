
/** @class_declaration packing */
/////////////////////////////////////////////////////////////////
//// PACKING LIST ///////////////////////////////////////////////
class packing extends oficial
{
  function packing(context)
  {
    oficial(context);
  }
  function direccionBulto(nodo, campo)
  {
    return this.ctx.packing_direccionBulto(nodo, campo);
  }
}
//// PACKING LIST ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition packing */
/////////////////////////////////////////////////////////////////
//// PACKING LIST ///////////////////////////////////////////////
function packing_direccionBulto(nodo, campo)
{
  var d = "";
  switch (campo) {
    case "empresa": {
      d += nodo.attributeValue("empresa.direccion");
      d += "\n";
      d += nodo.attributeValue("empresa.codpostal") + " " + nodo.attributeValue("empresa.ciudad");
      d += "\n";
      d += nodo.attributeValue("paises2.nombre");
      break;
    }
    case "cliente": {
      d += nodo.attributeValue("despachos.direccion");
      d += "\n";
      d += nodo.attributeValue("despachos.codpostal") + " " + nodo.attributeValue("despachos.ciudad");
      break;
    }
  }
  return d;
}
//// PACKING LIST ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
