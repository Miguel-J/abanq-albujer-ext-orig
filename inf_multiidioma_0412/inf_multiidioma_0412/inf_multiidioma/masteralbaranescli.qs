
/** @class_declaration infMultiidioma */
/////////////////////////////////////////////////////////////////
//// INF_MULTIIDIOMA ////////////////////////////////////////////
class infMultiidioma extends oficial
{
  function infMultiidioma(context)
  {
    oficial(context);
  }
  //  function imprimir(codAlbaran:String) {
  //    return this.ctx.infMultiidioma_imprimir(codAlbaran);
  //  }
  function dameParamInforme(idAlbaran)
  {
    return this.ctx.infMultiidioma_dameParamInforme(idAlbaran);
  }
}
//// INF_MULTIIDIOMA ////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition infMultiidioma */
/////////////////////////////////////////////////////////////////
//// INF_MULTIIDIOMA ////////////////////////////////////////////
// function infMultiidioma_imprimir(codAlbaran)
// {
//  var util:FLUtil = new FLUtil;
//
//  var idAlbaran;
//  if (codAlbaran) {
//    idAlbaran = util.sqlSelect("albaranescli", "idalbaran", "codigo = '" + codAlbaran + "'");
//  } else {
//    var cursor:FLSqlCursor = this.cursor();
//    idAlbaran = cursor.valueBuffer("idalbaran");
//  }
//  var codIdioma = flfactppal.iface.pub_obtenerIdiomaObjeto("albaranescli", idAlbaran);
//
//  if (!flfactinfo.iface.pub_establecerIdioma(codIdioma)) {
//    return false;
//  }
//  oficial_imprimir(codAlbaran);
// }

function infMultiidioma_dameParamInforme(idAlbaran)
{
  var util = new FLUtil;
  var oParam = this.iface.__dameParamInforme(idAlbaran);
  var codIdioma = flfactppal.iface.pub_obtenerIdiomaObjeto("albaranescli", idAlbaran);
  if (codIdioma && codIdioma != "") {
    oParam.codIdioma = codIdioma;
  }
  return oParam;
}

//// INF_MULTIIDIOMA ////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
