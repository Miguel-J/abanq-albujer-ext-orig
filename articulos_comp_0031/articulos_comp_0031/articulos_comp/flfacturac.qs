
/** @class_declaration articomp */
/////////////////////////////////////////////////////////////////
//// ARTÍCULOS COMPUESTOS ///////////////////////////////////////
class articomp extends oficial
{
  function articomp(context)
  {
    oficial(context);
  }
  function beforeCommit_lineaspedidoscli(curLP)
  {
    return this.ctx.articomp_beforeCommit_lineaspedidoscli(curLP);
  }
  function beforeCommit_lineaspedidosprov(curLP)
  {
    return this.ctx.articomp_beforeCommit_lineaspedidosprov(curLP);
  }
  function beforeCommit_lineasalbaranescli(curLA)
  {
    return this.ctx.articomp_beforeCommit_lineasalbaranescli(curLA);
  }
  function beforeCommit_lineasalbaranesprov(curLA)
  {
    return this.ctx.articomp_beforeCommit_lineasalbaranesprov(curLA);
  }
  function beforeCommit_lineasfacturascli(curLF)
  {
    return this.ctx.articomp_beforeCommit_lineasfacturascli(curLF);
  }
  function beforeCommit_lineasfacturasprov(curLF)
  {
    return this.ctx.articomp_beforeCommit_lineasfacturasprov(curLF);
  }
}
//// ARTÍCULOS COMPUESTOS ///////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition articomp */
/////////////////////////////////////////////////////////////////
//// ARTÍCULOS COMPUESTOS ///////////////////////////////////////
function articomp_beforeCommit_lineaspedidoscli(curLP)
{
  var _i = this.iface;
  if (!_i.__beforeCommit_lineaspedidoscli(curLP)) {
    return false;
  }
  if (!flfactalma.iface.pub_controlStockBCPedidosCli(curLP)) {
    return false;
  }
  return true;
}

function articomp_beforeCommit_lineaspedidosprov(curLP)
{
  var _i = this.iface;
  if (!_i.__beforeCommit_lineaspedidosprov(curLP)) {
    return false;
  }
  if (!flfactalma.iface.pub_controlStockBCPedidosProv(curLP)) {
    return false;
  }
  return true;
}

function articomp_beforeCommit_lineasalbaranescli(curLA)
{
  var _i = this.iface;
  if (!_i.__beforeCommit_lineasalbaranescli(curLA)) {
    return false;
  }
  if (!flfactalma.iface.pub_controlStockBCAlbaranesCli(curLA)) {
    return false;
  }
  return true;
}

function articomp_beforeCommit_lineasalbaranesprov(curLA)
{
  var _i = this.iface;
  if (!_i.__beforeCommit_lineasalbaranesprov(curLA)) {
    return false;
  }
  if (!flfactalma.iface.pub_controlStockBCAlbaranesProv(curLA)) {
    return false;
  }
  return true;
}

function articomp_beforeCommit_lineasfacturascli(curLF)
{
  var _i = this.iface;
  if (!_i.__beforeCommit_lineasfacturascli(curLF)) {
    return false;
  }
  if (!flfactalma.iface.pub_controlStockBCFacturasCli(curLF)) {
    return false;
  }
  return true;
}

function articomp_beforeCommit_lineasfacturasprov(curLF)
{
  var _i = this.iface;
  if (!_i.__beforeCommit_lineasfacturasprov(curLF)) {
    return false;
  }
  if (!flfactalma.iface.pub_controlStockBCFacturasProv(curLF)) {
    return false;
  }
  return true;
}
//// ARTÍCULOS COMPUESTOS ///////////////////////////////////////
/////////////////////////////////////////////////////////////////
