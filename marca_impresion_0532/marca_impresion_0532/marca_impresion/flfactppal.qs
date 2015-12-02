
/** @class_declaration marcaImpresion */
/////////////////////////////////////////////////////////////////
//// SINCRO TPV /////////////////////////////////////////////////
class marcaImpresion extends oficial
{
  function marcaImpresion(context)
  {
    oficial(context);
  }
  function extension(nE)
  {
    return this.ctx.marcaImpresion_extension(nE);
  }
}
//// SINCRO TPV /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition marcaImpresion */
/////////////////////////////////////////////////////////////////
//// MARCA IMPRESION ////////////////////////////////////////////
function marcaImpresion_extension(nE)
{
  var _i = this.iface;
  if (nE == "marca_impresion") {
    return true;
  }
  return _i.__extension(nE);
}
//// MARCA IMPRESION ////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
