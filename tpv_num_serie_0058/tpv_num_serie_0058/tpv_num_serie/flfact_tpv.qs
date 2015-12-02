
/** @class_declaration funNumSerie */
/////////////////////////////////////////////////////////////////
//// FUN_NUMEROS_SERIE /////////////////////////////////////////////////
class funNumSerie extends oficial
{
  function funNumSerie(context)
  {
    oficial(context);
  }
  function datosLineaFactura(curLineaComanda: FLSqlCursor): Boolean {
    return this.ctx.funNumSerie_datosLineaFactura(curLineaComanda);
  }
}
//// FUN_NUMEROS_SERIE //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition funNumSerie */
/////////////////////////////////////////////////////////////////
//// FUN_NUMEROS_SERIE /////////////////////////////////////////////////
/** \D Copia los datos de una línea de comanda en una línea de factura
@param  curLineaComanda: Cursor que contiene los datos a incluir en la línea de factura
@return True si la copia se realiza correctamente, false en caso contrario
\end */
function funNumSerie_datosLineaFactura(curLineaComanda: FLSqlCursor): Boolean {
  if (!this.iface.__datosLineaFactura(curLineaComanda))
    return false;

  with(this.iface.curLineaFactura)
  {
    setValueBuffer("numserie", curLineaComanda.valueBuffer("numserie"));
  }
  return true;
}
//// FUN_NUMEROS_SERIE /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
