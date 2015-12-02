
/** @class_declaration marcaImpresion */
/////////////////////////////////////////////////////////////////
//// MARCA_IMPRESION ////////////////////////////////////////////
class marcaImpresion extends oficial
{
  function marcaImpresion(context)
  {
    oficial(context);
  }
  function marcarAlbaranImpreso(idAlbaran: String, impreso: Boolean): Boolean {
    return this.ctx.marcaImpresion_marcarAlbaranImpreso(idAlbaran, impreso);
  }
}
//// MARCA_IMPRESION ////////////////////////////////////////////
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
  function pub_marcarAlbaranImpreso(idAlbaran: String, impreso: Boolean): Boolean {
    return this.marcarAlbaranImpreso(idAlbaran, impreso);
  }
}
//// PUB_MARCA_IMPRESION ////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition marcaImpresion */
/////////////////////////////////////////////////////////////////
//// MARCA_IMPRESION ////////////////////////////////////////////
function marcaImpresion_marcarAlbaranImpreso(idAlbaran: String, impreso: Boolean): Boolean {
  if (impreso)
  {
    return false;
  }

  var util: FLUtil = new FLUtil();
  var bloqueado: Boolean = false;
  var curAlbaran: FLSqlCursor = new FLSqlCursor("albaranescli");
  curAlbaran.select("idalbaran = " + idAlbaran);
  curAlbaran.first();
  curAlbaran.setActivatedCommitActions(false);
  curAlbaran.setActivatedCheckIntegrity(false);

  if (curAlbaran.valueBuffer("ptefactura") == false)
  {
    curAlbaran.select("idalbaran = " + idAlbaran);
    curAlbaran.first();
    curAlbaran.setUnLock("ptefactura", true);
    bloqueado = true;
  }
  curAlbaran.select("idalbaran = " + idAlbaran);
  curAlbaran.first();
  curAlbaran.setModeAccess(curAlbaran.Edit);
  curAlbaran.refreshBuffer();
  curAlbaran.setValueBuffer("impreso", true);
  if (!curAlbaran.commitBuffer())
  {
    return false;
  }

  if (bloqueado)
  {
    curAlbaran.select("idalbaran = " + idAlbaran);
    curAlbaran.first();
    curAlbaran.setUnLock("ptefactura", false);
  }
  return true;
}

//// MARCA_IMPRESION ////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
