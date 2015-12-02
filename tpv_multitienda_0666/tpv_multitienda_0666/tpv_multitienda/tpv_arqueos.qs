
/** @class_declaration multi */
/////////////////////////////////////////////////////////////////
//// TPV MULTITIENDA ////////////////////////////////////////////
class multi extends oficial
{
  function multi(context)
  {
    oficial(context);
  }
  function init()
  {
    return this.ctx.multi_init();
  }
  function valoresInitTienda()
  {
    return this.ctx.multi_valoresInitTienda();
  }
}
//// TPV MULTITIENDA ////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition multi */
/////////////////////////////////////////////////////////////////
//// TPV MULTITIENDA ////////////////////////////////////////////
function multi_init()
{
  var _i = this.iface;
  _i.__init();

  _i.valoresInitTienda();
}

function multi_valoresInitTienda()
{
  debug("multi_valoresInitTienda");
  var cursor = this.cursor();
  if (cursor.modeAccess() == cursor.Insert) {
    debug("pto " + cursor.valueBuffer("ptoventa"));
    cursor.setValueBuffer("codtienda", AQUtil.sqlSelect("tpv_puntosventa", "codtienda", "codtpv_puntoventa = '" + cursor.valueBuffer("ptoventa") + "'"));
  }
}
//// TPV MULTITIENDA ////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
