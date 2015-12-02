
/** @class_declaration scab */
/////////////////////////////////////////////////////////////////
//// STOCKS CABECERA ////////////////////////////////////////////
class scab extends oficial
{
  function scab(context)
  {
    oficial(context);
  }
  function afterCommit_albaranescli(curAlbaran)
  {
    return this.ctx.scab_afterCommit_albaranescli(curAlbaran);
  }
  function afterCommit_albaranesprov(curAlbaran)
  {
    return this.ctx.scab_afterCommit_albaranesprov(curAlbaran);
  }
  function afterCommit_facturascli(curFactura)
  {
    return this.ctx.scab_afterCommit_facturascli(curFactura);
  }
  function afterCommit_facturasprov(curFactura)
  {
    return this.ctx.scab_afterCommit_facturasprov(curFactura);
  }
}
//// STOCKS CABECERA ////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition scab */
/////////////////////////////////////////////////////////////////
//// STOCKS CABECERA ////////////////////////////////////////////
function scab_afterCommit_albaranescli(curAlbaran)
{
  if (!this.iface.__afterCommit_albaranescli(curAlbaran)) {
    return false;
  }
  if (!flfactalma.iface.pub_procesaStocksAfectados("cantidadac")) {
    return false;
  }
  return true;
}

function scab_afterCommit_albaranesprov(curAlbaran)
{
  if (!this.iface.__afterCommit_albaranesprov(curAlbaran)) {
    return false;
  }
  if (!flfactalma.iface.pub_procesaStocksAfectados("cantidadap")) {
    return false;
  }
  return true;
}

function scab_afterCommit_facturascli(curFactura)
{
  if (!this.iface.__afterCommit_facturascli(curFactura)) {
    return false;
  }
  if (!flfactalma.iface.pub_procesaStocksAfectados("cantidadfc")) {
    return false;
  }
  return true;
}

function scab_afterCommit_facturasprov(curFactura)
{
  if (!this.iface.__afterCommit_facturasprov(curFactura)) {
    return false;
  }
  if (!flfactalma.iface.pub_procesaStocksAfectados("cantidadfp")) {
    return false;
  }
  return true;
}
//// STOCKS CABECERA ////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
