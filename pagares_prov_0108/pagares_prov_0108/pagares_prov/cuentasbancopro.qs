
/** @class_declaration pagareProv */
/////////////////////////////////////////////////////////////////
//// PAGARE PROV ////////////////////////////////////////////////
class pagareProv extends oficial
{
  function pagareProv(context)
  {
    oficial(context);
  }
  function init()
  {
    this.ctx.pagareProv_init();
  }
}
//// PAGARE PROV ////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition pagareProv */
/////////////////////////////////////////////////////////////////
//// PAGARE PROV ////////////////////////////////////////////////
function pagareProv_init()
{
  this.iface.__init();
}
//// PAGARE PROV ////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////