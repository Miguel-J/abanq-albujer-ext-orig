
/** @class_declaration tpvCtaVta */
//////////////////////////////////////////////////////////////////
//// TPV CTA VTA //////////////////////////////////////////////
class tpvCtaVta extends oficial
{
  function tpvCtaVta(context)
  {
    oficial(context);
  }
  function datosLineaVenta(): Boolean {
    return this.ctx.tpvCtaVta_datosLineaVenta();
  }
}
//// TPV CTA VTA //////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_definition tpvCtaVta */
/////////////////////////////////////////////////////////////////
//// TPV CTA VTA //////////////////////////////////////////////

function tpvCtaVta_datosLineaVenta(): Boolean {
  this.iface.__datosLineaVenta();

  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  datosCta = flfactppal.iface.pub_ejecutarQry("articulos", "idsubcuentaven,codsubcuentaven", "referencia = '" + cursor.valueBuffer("referencia") + "'");
  if (datosCta.result < 1)
    return true;

  this.iface.curLineas.setValueBuffer("codsubcuenta", datosCta.codsubcuentaven);

  return true;
}

//// TPV CTA VTA //////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

