
/** @class_declaration infMultiidioma */
/////////////////////////////////////////////////////////////////
//// INF_MULTIIDIOMA ////////////////////////////////////////////
class infMultiidioma extends oficial
{
  function infMultiidioma(context)
  {
    oficial(context);
  }
  //  function imprimir(codPedido:String) {
  //    return this.ctx.infMultiidioma_imprimir(codPedido);
  //  }
  function dameParamInforme(idPedido)
  {
    return this.ctx.infMultiidioma_dameParamInforme(idPedido);
  }
}
//// INF_MULTIIDIOMA ////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition infMultiidioma */
/////////////////////////////////////////////////////////////////
//// INF_MULTIIDIOMA ////////////////////////////////////////////
// function infMultiidioma_imprimir(codPedido)
// {
//  var util:FLUtil = new FLUtil;
//
//  var idPedido;
//  if (codPedido) {
//    idPedido = util.sqlSelect("pedidoscli", "idpedido", "codigo = '" + codPedido + "'");
//  } else {
//    var cursor:FLSqlCursor = this.cursor();
//    idPedido = cursor.valueBuffer("idpedido");
//  }
//  var codIdioma = flfactppal.iface.pub_obtenerIdiomaObjeto("pedidoscli", idPedido);
//
//  if (!flfactinfo.iface.pub_establecerIdioma(codIdioma)) {
//    return false;
//  }
//  oficial_imprimir(codPedido);
// }

function infMultiidioma_dameParamInforme(idPedido)
{
  var util = new FLUtil;
  var oParam = this.iface.__dameParamInforme(idPedido);
  var codIdioma = flfactppal.iface.pub_obtenerIdiomaObjeto("pedidoscli", idPedido);
  if (codIdioma && codIdioma != "") {
    oParam.codIdioma = codIdioma;
  }
  return oParam;
}
//// INF_MULTIIDIOMA ////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
