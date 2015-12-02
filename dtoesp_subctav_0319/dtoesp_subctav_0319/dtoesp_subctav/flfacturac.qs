
/** @class_declaration dtoEspCtaVta */
//////////////////////////////////////////////////////////////////
//// CTA_VENTA_ART////////////////////////////////////////////////
class dtoEspCtaVta extends ctaVentaArt
{
  function dtoEspCtaVta(context)
  {
    ctaVentaArt(context);
  }
  function generarPartidasVenta(curFactura: FLSqlCursor, idAsiento: Number, valoresDefecto: Array): Boolean {
    return this.ctx.dtoEspCtaVta_generarPartidasVenta(curFactura, idAsiento, valoresDefecto);
  }
}
//// CTA_VENTA_ART////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////



/** @class_definition dtoEspCtaVta */
/////////////////////////////////////////////////////////////////
//// DTOESP CTAVTA ////////////////////////////////////////////////

function dtoEspCtaVta_generarPartidasVenta(curFactura: FLSqlCursor, idAsiento: Number, valoresDefecto: Array, concepto: String): Boolean {
  if (!this.iface.generarPartidasDtoEspCli(curFactura, idAsiento, valoresDefecto))
    return false;

  return this.iface.__generarPartidasVenta(curFactura, idAsiento, valoresDefecto, concepto);
}

//// DTOESP CTAVTA ////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
