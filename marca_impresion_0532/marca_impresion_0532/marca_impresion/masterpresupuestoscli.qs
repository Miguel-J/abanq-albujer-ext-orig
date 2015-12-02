
/** @class_declaration marcaImpresion */
/////////////////////////////////////////////////////////////////
//// MARCA_IMPRESION ////////////////////////////////////////////
class marcaImpresion extends oficial
{
  function marcaImpresion(context)
  {
    oficial(context);
  }
  function marcarPresupuestoImpreso(idPresupuesto: String, impreso: Boolean): Boolean {
    return this.ctx.marcaImpresion_marcarPresupuestoImpreso(idPresupuesto, impreso);
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
  function pub_marcarPresupuestoImpreso(idPresupuesto: String, impreso: Boolean): Boolean {
    return this.marcarPresupuestoImpreso(idPresupuesto, impreso);
  }
}
//// PUB_MARCA_IMPRESION ////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition marcaImpresion */
/////////////////////////////////////////////////////////////////
//// MARCA_IMPRESION ////////////////////////////////////////////
function marcaImpresion_marcarPresupuestoImpreso(idPresupuesto: String, impreso: Boolean): Boolean {
  if (impreso)
  {
    return false;
  }

  var util: FLUtil = new FLUtil();
  var bloqueado: Boolean = false;
  var curPresupuesto: FLSqlCursor = new FLSqlCursor("presupuestoscli");
  curPresupuesto.select("idpresupuesto = " + idPresupuesto);
  curPresupuesto.first();
  curPresupuesto.setActivatedCommitActions(false);
  curPresupuesto.setActivatedCheckIntegrity(false);

  if (curPresupuesto.valueBuffer("editable") == false)
  {
    curPresupuesto.select("idpresupuesto = " + idPresupuesto);
    curPresupuesto.first();
    curPresupuesto.setUnLock("editable", true);
    bloqueado = true;
  }
  curPresupuesto.select("idpresupuesto = " + idPresupuesto);
  curPresupuesto.first();
  curPresupuesto.setModeAccess(curPresupuesto.Edit);
  curPresupuesto.refreshBuffer();
  curPresupuesto.setValueBuffer("impreso", true);
  if (!curPresupuesto.commitBuffer())
  {
    return false;
  }

  if (bloqueado)
  {
    curPresupuesto.select("idpresupuesto = " + idPresupuesto);
    curPresupuesto.first();
    curPresupuesto.setUnLock("editable", false);
  }
  return true;
}

//// MARCA_IMPRESION ////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
