
/** @class_declaration artesG */
/////////////////////////////////////////////////////////////////
//// ARTES GRÁFICAS /////////////////////////////////////////////
class artesG extends articuloscomp
{
  function artesG(context)
  {
    articuloscomp(context);
  }
  function datosLineaFactura(curLineaAlbaran: FLSqlCursor): Boolean {
    return this.ctx.artesG_datosLineaFactura(curLineaAlbaran);
  }
}
//// ARTES GRÁFICAS /////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition artesG */
/////////////////////////////////////////////////////////////////
//// ARTES GRÁFICAS /////////////////////////////////////////////
function artesG_datosLineaFactura(curLineaAlbaran: FLSqlCursor): Boolean {
  if (!this.iface.__datosLineaFactura(curLineaAlbaran))
    return false;

  with(this.iface.curLineaFactura)
  {
    setValueBuffer("udpapel", curLineaAlbaran.valueBuffer("udpapel"));
    setValueBuffer("cantidadaux", curLineaAlbaran.valueBuffer("cantidadaux"));
    setValueBuffer("unidades", curLineaAlbaran.valueBuffer("unidades"));
    setValueBuffer("pvppliego", curLineaAlbaran.valueBuffer("pvppliego"));
  }
  return true;
}
//// ARTES GRÁFICAS /////////////////////////////////////////////
//////////////////////////////////////////////////////////////
