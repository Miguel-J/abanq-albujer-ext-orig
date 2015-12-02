
/** @class_declaration explot */
/////////////////////////////////////////////////////////////////
//// INFORME CUENTA EXPLOTACION /////////////////////////////////
class explot extends oficial
{
  function explot(context)
  {
    oficial(context);
  }
  function datosSubcuenta(curSubcuentaAnt: FLSqlCursor): Boolean {
    return this.ctx.explot_datosSubcuenta(curSubcuentaAnt);
  }
}
//// INFORME CUENTA EXPLOTACION /////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition explot */
/////////////////////////////////////////////////////////////////
//// INFORME CUENTA EXPLOTACION /////////////////////////////////
function explot_datosSubcuenta(curSubcuentaAnt: FLSqlCursor): Boolean {
  if (!this.iface.__datosSubcuenta(curSubcuentaAnt))
  {
    return false;
  }
  this.iface.curSubcuenta_.setValueBuffer("codcuentaexp", curSubcuentaAnt.valueBuffer("codcuentaexp"));

  return true;
}
//// INFORME CUENTA EXPLOTACION /////////////////////////////////
/////////////////////////////////////////////////////////////////
