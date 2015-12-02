
/** @class_declaration rappel */
/////////////////////////////////////////////////////////////////
//// RAPPEL /////////////////////////////////////////////////////
class rappel extends oficial
{
  function rappel(context)
  {
    oficial(context);
  }
  function datosLineaFactura(curLineaAlbaran: FLSqlCursor): Boolean {
    return this.ctx.rappel_datosLineaFactura(curLineaAlbaran);
  }
}
//// RAPPEL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition rappel */
/////////////////////////////////////////////////////////////////
//// RAPPEL /////////////////////////////////////////////////////
/** \D Copia los datos de una línea de albarán en una línea de factura añadiendo el dato de descuento por rappel a una línea de factura
@param  curLineaAlbaran: Cursor que contiene los datos a incluir en la línea de factura
@return True si la copia se realiza correctamente, false en caso contrario
\end */
function rappel_datosLineaFactura(curLineaAlbaran: FLSqlCursor): Boolean {
  if (!this.iface.__datosLineaFactura(curLineaAlbaran))
    return false;

  with(this.iface.curLineaFactura)
  {
    setValueBuffer("dtorappel", curLineaAlbaran.valueBuffer("dtorappel"));
  }
  return true;
}
//// RAPPEL /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////
