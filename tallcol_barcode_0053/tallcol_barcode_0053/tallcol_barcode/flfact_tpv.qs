
/** @class_declaration barcode */
//////////////////////////////////////////////////////////////////
////////////////// BARCODE ///////////////////////////////////////
class barcode extends oficial
{
  function barcode(context)
  {
    oficial(context);
  }
  function datosLineaFactura(curLineaComanda: FLSqlCursor): Boolean {
    return this.ctx.barcode_datosLineaFactura(curLineaComanda);
  }
}
////////////////// BARCODE ///////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_definition barcode */
//////////////////////////////////////////////////////////////////
////////////////// BARCODE ///////////////////////////////////////
/** \D Copia campo a campo los datos de IVA incluido y tallas y colores de una linea de la comanda en una línea de la factura
@param curLineaComanda cursor de las lineas de la comanda
@return Boolean, true si la linea se ha copiado correctamente y false si ha habido algún errror
*/
function barcode_datosLineaFactura(curLineaComanda: FLSqlCursor): Boolean {
  if (!this.iface.__datosLineaFactura(curLineaComanda))
    return false;

  with(this.iface.curLineaFactura)
  {
    setValueBuffer("barcode", curLineaComanda.valueBuffer("barcode"));
    setValueBuffer("talla", curLineaComanda.valueBuffer("talla"));
    setValueBuffer("color", curLineaComanda.valueBuffer("color"));
  }
  return true;
}
////////////////// BARCODE ///////////////////////////////////////
//////////////////////////////////////////////////////////////////
