
/** @class_declaration rappel */
/////////////////////////////////////////////////////////////////
//// RAPPEL /////////////////////////////////////////////////////
class rappel extends oficial
{
  function rappel(context)
  {
    oficial(context);
  }
  function datosLineaAlbaran(curLineaPedido: FLSqlCursor): Boolean {
    return this.ctx.rappel_datosLineaAlbaran(curLineaPedido);
  }
}
//// RAPPEL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition rappel */
/////////////////////////////////////////////////////////////////
//// RAPPEL /////////////////////////////////////////////////////
/** \D Copia los datos de una línea de pedido en una línea de albarán añadiendo el dato de descuento por rappel a una línea de albarán
@param  curLineaPedido: Cursor que contiene los datos a incluir en la línea de albarán
@return True si la copia se realiza correctamente, false en caso contrario
\end */
function rappel_datosLineaAlbaran(curLineaPedido: FLSqlCursor): Boolean {
  with(this.iface.curLineaAlbaran)
  {
    setValueBuffer("dtorappel", curLineaPedido.valueBuffer("dtorappel"));
  }

  if (!this.iface.__datosLineaAlbaran(curLineaPedido))
    return false;

  return true;
}

//// RAPPEL /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////
