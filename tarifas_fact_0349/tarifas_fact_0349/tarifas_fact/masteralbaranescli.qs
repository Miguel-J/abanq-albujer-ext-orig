
/** @class_declaration tarifasFact */
//////////////////////////////////////////////////////////////////
//// tarifasFact //////////////////////////////////////////////////////
class tarifasFact extends oficial
{
  function tarifasFact(context)
  {
    oficial(context);
  }
  function datosFactura(curAlbaran: FLSqlCursor, where: String, datosAgrupacion: Array): Boolean {
    return this.ctx.tarifasFact_datosFactura(curAlbaran, where, datosAgrupacion);
  }
}
//// tarifasFact //////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_definition tarifasFact */
/////////////////////////////////////////////////////////////////
//// tarifasFact /////////////////////////////////////////////////////

function tarifasFact_datosFactura(curAlbaran: FLSqlCursor, where: String, datosAgrupacion: Array): Boolean {
  if (!this.iface.__datosFactura(curAlbaran, where, datosAgrupacion))
    return false;

  with(this.iface.curFactura)
  {
    setValueBuffer("codtarifa", curAlbaran.valueBuffer("codtarifa"));
  }

  return true;
}

//// tarifasFact /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
