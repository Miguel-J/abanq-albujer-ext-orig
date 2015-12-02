
/** @class_declaration multi */
/////////////////////////////////////////////////////////////////
//// TPV MULTITIENDA ////////////////////////////////////////////
class multi extends oficial
{
  function multi(context)
  {
    oficial(context);
  }
  function valoresLocales()
  {
    return this.ctx.multi_valoresLocales();
  }
  function datosLineaVenta()
  {
    return this.ctx.multi_datosLineaVenta();
  }
  function datosLineaVentaMulti()
  {
    return this.ctx.multi_datosLineaVentaMulti();
  }
  function datosPago(curPago, formaPago, refVale)
  {
    return this.ctx.multi_datosPago(curPago, formaPago, refVale);
  }
}
//// TPV MULTITIENDA ////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition multi */
/////////////////////////////////////////////////////////////////
//// TPV MULTITIENDA ////////////////////////////////////////////
function multi_valoresLocales()
{
  var _i = this.iface;
  var cursor = this.cursor();

  if (!_i.__valoresLocales()) {
    return false;
  }
  if (this.child("fdbCodTienda")) {
    sys.setObjText(this, "fdbCodTienda", AQUtil.sqlSelect("tpv_puntosventa", "codtienda", "codtpv_puntoventa = '" + cursor.valueBuffer("codtpv_puntoventa") + "'"));
  }
  return true;
}

function multi_datosLineaVenta()
{
  var _i = this.iface;
  if (!_i.__datosLineaVenta()) {
    return false;
  }
  if (!_i.datosLineaVentaMulti()) {
    return false;
  }
  return true;
}

function multi_datosLineaVentaMulti()
{
  var _i = this.iface;
  var cursor = this.cursor();
  _i.curLineas.setValueBuffer("codtienda", cursor.valueBuffer("codtienda"));
  return true;
}

function multi_datosPago(curPago, formaPago, refVale)
{
  var _i = this.iface;
  var cursor = this.cursor();
  if (!_i.__datosPago(curPago, formaPago, refVale)) {
    return false;
  }
  curPago.setValueBuffer("codtienda", cursor.valueBuffer("codtienda"));
  return true;
}


//// TPV MULTITIENDA ////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
