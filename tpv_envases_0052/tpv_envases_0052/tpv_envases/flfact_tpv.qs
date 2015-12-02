
/** @class_declaration envases */
/////////////////////////////////////////////////////////////////
//// ENVASES ////////////////////////////////////////////////////
class envases extends oficial
{
  function envases(context)
  {
    oficial(context);
  }
  function datosLineaFactura(curLineaComanda: FLSqlCursor): Boolean {
    return this.ctx.envases_datosLineaFactura(curLineaComanda);
  }
}
//// ENVASES ////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition envases */
/////////////////////////////////////////////////////////////////
//// ENVASES ////////////////////////////////////////////////////
/** \D Copia los datos de una línea de ventas en una línea de factura añadiendo los datos relativos al envase (--codenvase--, --valormetrico-- y --canenvases--)
@param  curLineaComanda: Cursor que contiene los datos a incluir en la línea de factura
@return True si la copia se realiza correctamente, false en caso contrario
\end */
function envases_datosLineaFactura(curLineaComanda: FLSqlCursor): Boolean {
  with(this.iface.curLineaFactura)
  {
    setValueBuffer("valormetrico", curLineaComanda.valueBuffer("valormetrico"));
    setValueBuffer("canenvases", curLineaComanda.valueBuffer("canenvases"));
    setValueBuffer("codenvase", curLineaComanda.valueBuffer("codenvase"));
  }

  if (!this.iface.__datosLineaFactura(curLineaComanda))
    return false;

  return true;
}

//// ENVASES ////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////
