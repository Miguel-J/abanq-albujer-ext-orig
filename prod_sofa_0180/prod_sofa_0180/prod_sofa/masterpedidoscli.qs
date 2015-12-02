
/** @class_declaration sofa */
/////////////////////////////////////////////////////////////////
//// PROD_SOFA //////////////////////////////////////////////////
class sofa extends prod
{
  var modoOriginal_: String;
  function sofa(context)
  {
    prod(context);
  }
  function datosLineaAlbaran(curLineaPedido: FLSqlCursor): Boolean {
    return this.ctx.sofa_datosLineaAlbaran(curLineaPedido);
  }
  function setModoOriginal(modo: String)
  {
    return this.ctx.sofa_setModoOriginal(modo);
  }
  function getModoOriginal(): String {
    return this.ctx.sofa_getModoOriginal();
  }
}
//// PROD_SOFA //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pubSofa */
/////////////////////////////////////////////////////////////////
//// PUB_SOFA ///////////////////////////////////////////////////
class pubSofa extends ifaceCtx
{
  function pubSofa(context)
  {
    ifaceCtx(context);
  }
  function pub_setModoOriginal(modo: String)
  {
    return this.setModoOriginal(modo);
  }
  function pub_getModoOriginal(): String {
    return this.getModoOriginal();
  }
}
//// PUB_SOFA ////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition sofa */
/////////////////////////////////////////////////////////////////
//// PROD_SOFA //////////////////////////////////////////////////
function sofa_datosLineaAlbaran(curLineaPedido: FLSqlCursor): Boolean {
  if (!this.iface.__datosLineaAlbaran(curLineaPedido))
    return false;

  this.iface.curLineaAlbaran.setValueBuffer("idserietela", curLineaPedido.valueBuffer("idserietela"));
  this.iface.curLineaAlbaran.setValueBuffer("valorpunto", curLineaPedido.valueBuffer("valorpunto"));

  return true;
}

function sofa_setModoOriginal(modo: String)
{
  this.iface.modoOriginal_ = modo;
}

function sofa_getModoOriginal(): String {
  return this.iface.modoOriginal_;
}

//// PROD_SOFA //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
