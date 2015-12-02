
/** @class_declaration numerosLinea */
/////////////////////////////////////////////////////////////////
//// NUMEROS LINEA /////////////////////////////////////////////
class numerosLinea extends oficial
{
  function numerosLinea(context)
  {
    oficial(context);
  }
  function copiadatosLineaFactura(curLineaFactura: FLSqlCursor): Boolean {
    return this.ctx.numerosLinea_copiadatosLineaFactura(curLineaFactura);
  }
}
//// NUMEROS LINEA /////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition numerosLinea */
/////////////////////////////////////////////////////////////////
//// NUMEROS LINEA /////////////////////////////////////////////
function numerosLinea_copiadatosLineaFactura(curLineaFactura: FLSqlCursor): Boolean {
  if (!this.iface.__copiadatosLineaFactura(curLineaFactura))
  {
    return false;
  }

  with(this.iface.curLineaFactura)
  {
    setValueBuffer("numlinea", curLineaFactura.valueBuffer("numlinea"));
  }
  return true;
}

//// NUMEROS LINEA /////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
