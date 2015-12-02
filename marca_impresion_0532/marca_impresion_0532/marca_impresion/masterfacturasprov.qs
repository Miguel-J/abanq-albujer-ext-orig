
/** @class_declaration marcaImpresion */
/////////////////////////////////////////////////////////////////
//// MARCAR_IMPRESION ///////////////////////////////////////////
class marcaImpresion extends oficial
{
  function marcaImpresion(context)
  {
    oficial(context);
  }
  function marcarFacturaImpresa(idFactura: String, impreso: Boolean): Boolean {
    return this.ctx.marcaImpresion_marcarFacturaImpresa(idFactura, impreso);
  }
}
//// MARCAR_IMPRESION ///////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pubMarcaImpresion */
/////////////////////////////////////////////////////////////////
//// PUB_MARCA_IMPRESION ////////////////////////////////////////
class pubMarcaImpresion extends ifaceCtx
{
  function pubMarcaImpresion(context)
  {
    ifaceCtx(context);
  }
  function pub_marcarFacturaImpresa(idFactura: String, impreso: Boolean): Boolean {
    return this.marcarFacturaImpresa(idFactura, impreso);
  }
}
//// PUB_MARCA_IMPRESION ////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition marcaImpresion */
/////////////////////////////////////////////////////////////////
//// MARCA_IMPRESION ////////////////////////////////////////////
function marcaImpresion_marcarFacturaImpresa(idFactura: String, impreso: Boolean): Boolean {
  if (impreso)
  {
    return false;
  }

  var util: FLUtil = new FLUtil();
  var curFactura: FLSqlCursor = new FLSqlCursor("facturasprov");
  curFactura.select("idfactura = " + idFactura);
  curFactura.first();
  curFactura.setActivatedCommitActions(false);
  curFactura.setActivatedCheckIntegrity(false);
  curFactura.setModeAccess(curFactura.Edit);
  curFactura.refreshBuffer();
  curFactura.setValueBuffer("impreso", true);
  if (!curFactura.commitBuffer())
  {
    return false;
  }

  return true;
}

//// MARCA_IMPRESION ////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
