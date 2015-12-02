
/** @class_declaration infMultiidioma */
/////////////////////////////////////////////////////////////////
//// INF_MULTIIDIOMA ////////////////////////////////////////////
class infMultiidioma extends oficial
{
  function infMultiidioma(context)
  {
    oficial(context);
  }
  //  function imprimir(codFactura:String) {
  //    return this.ctx.infMultiidioma_imprimir(codFactura);
  //  }
  function dameParamInforme(idFactura)
  {
    return this.ctx.infMultiidioma_dameParamInforme(idFactura);
  }
}
//// INF_MULTIIDIOMA ////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition infMultiidioma */
/////////////////////////////////////////////////////////////////
//// INF_MULTIIDIOMA ////////////////////////////////////////////
// function infMultiidioma_imprimir(codFactura)
// {
//  var util:FLUtil = new FLUtil;
//
//  var idFactura;
//  if (codFactura) {
//    idFactura = util.sqlSelect("facturascli", "idfactura", "codigo = '" + codFactura + "'");
//  } else {
//    var cursor:FLSqlCursor = this.cursor();
//    idFactura = cursor.valueBuffer("idfactura");
//  }
//  var codIdioma = flfactppal.iface.pub_obtenerIdiomaObjeto("facturascli", idFactura);
//
//  if (!flfactinfo.iface.pub_establecerIdioma(codIdioma)) {
//    return false;
//  }
//
//  oficial_imprimir(codFactura);
// }

function infMultiidioma_dameParamInforme(idFactura)
{
  var util = new FLUtil;
  var oParam = this.iface.__dameParamInforme(idFactura);
  var codIdioma = flfactppal.iface.pub_obtenerIdiomaObjeto("facturascli", idFactura);
  if (codIdioma && codIdioma != "") {
    oParam.codIdioma = codIdioma;
  }
  return oParam;
}

//// INF_MULTIIDIOMA ////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
