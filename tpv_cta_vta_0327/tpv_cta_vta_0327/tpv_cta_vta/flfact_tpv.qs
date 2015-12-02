
/** @class_declaration tpvCtaVta */
//////////////////////////////////////////////////////////////////
//// TPV CTA VTA /////////////////////////////////////////////////////
class tpvCtaVta extends oficial
{
  function tpvCtaVta(context)
  {
    oficial(context);
  }
  function datosLineaFactura(curLineaComanda: FLSqlCursor): Boolean {
    return this.ctx.tpvCtaVta_datosLineaFactura(curLineaComanda);
  }
}
//// TPV CTA VTA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_definition tpvCtaVta */
/////////////////////////////////////////////////////////////////
//// TPV CTA VTA /////////////////////////////////////////////////

function tpvCtaVta_datosLineaFactura(curLineaComanda: FLSqlCursor): Boolean {
  this.iface.__datosLineaFactura(curLineaComanda);

  if (!curLineaComanda.valueBuffer("codsubcuenta"))
    return true;

  with(this.iface.curLineaFactura)
  {
    setValueBuffer("codsubcuenta", curLineaComanda.valueBuffer("codsubcuenta"));
  }
  return true;
}

//// TPV CTA VTA /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
