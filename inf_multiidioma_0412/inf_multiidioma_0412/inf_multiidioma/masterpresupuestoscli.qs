
/** @class_declaration infMultiidioma */
/////////////////////////////////////////////////////////////////
//// INF_MULTIIDIOMA ////////////////////////////////////////////
class infMultiidioma extends oficial
{
  function infMultiidioma(context)
  {
    oficial(context);
  }
  //  function imprimir(codPresupuesto:String) {
  //    return this.ctx.infMultiidioma_imprimir(codPresupuesto);
  //  }
  function dameParamInforme(idPresupuesto)
  {
    return this.ctx.infMultiidioma_dameParamInforme(idPresupuesto);
  }
}
//// INF_MULTIIDIOMA ////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition infMultiidioma */
/////////////////////////////////////////////////////////////////
//// INF_MULTIIDIOMA ////////////////////////////////////////////
// function infMultiidioma_imprimir(codPresupuesto)
// {
//  var util:FLUtil = new FLUtil;
//
//  var idPresupuesto;
//  if (codPresupuesto) {
//    idPresupuesto = util.sqlSelect("presupuestoscli", "idpresupuesto", "codigo = '" + codPresupuesto + "'");
//  } else {
//    var cursor:FLSqlCursor = this.cursor();
//    idPresupuesto = cursor.valueBuffer("idpresupuesto");
//  }
//  var codIdioma = flfactppal.iface.pub_obtenerIdiomaObjeto("presupuestoscli", idPresupuesto);
//  if (!flfactinfo.iface.pub_establecerIdioma(codIdioma)) {
//    return false;
//  }
//  oficial_imprimir(codPresupuesto);
// }

function infMultiidioma_dameParamInforme(idPresupuesto)
{
  var util = new FLUtil;
  var oParam = this.iface.__dameParamInforme(idPresupuesto);
  var codIdioma = flfactppal.iface.pub_obtenerIdiomaObjeto("presupuestoscli", idPresupuesto);
  if (codIdioma && codIdioma != "") {
    oParam.codIdioma = codIdioma;
  }
  return oParam;
}
//// INF_MULTIIDIOMA ////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
