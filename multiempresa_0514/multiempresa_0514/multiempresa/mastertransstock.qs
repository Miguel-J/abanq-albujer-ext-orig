
/** @class_declaration multiEmpresa */
//////////////////////////////////////////////////////////////////
//// MULTIEMPRESA ////////////////////////////////////////////////
class multiEmpresa extends oficial
{
  function multiEmpresa(context)
  {
    oficial(context);
  }
  function imprimir(imprimir)
  {
    return this.ctx.multiEmpresa_imprimir();
  }
}
//// MULTIEMPRESA ////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_definition multiEmpresa */
//////////////////////////////////////////////////////////////////
//// MULTIEMPRESA ////////////////////////////////////////////////
function multiEmpresa_imprimir()
{
  var cursor: FLSqlCursor = this.cursor();
  var curImprimir: FLSqlCursor = new FLSqlCursor("i_transstock");
  curImprimir.setModeAccess(curImprimir.Insert);
  curImprimir.refreshBuffer();
  curImprimir.setValueBuffer("descripcion", "temp");
  curImprimir.setValueBuffer("i_transstock_idtrans", cursor.valueBuffer("idtrans"));
  var idEmpresa: String = flfactppal.iface.pub_valorDefectoEmpresa("id");
  var whereFijo = "empresa.id = " + idEmpresa;
  flfactinfo.iface.pub_lanzarInforme(curImprimir, "i_transstock", "", "", false, false, whereFijo);
}
//// MULTIEMPRESA ////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
