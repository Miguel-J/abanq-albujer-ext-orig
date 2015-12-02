
/** @class_declaration ivaNav */
/////////////////////////////////////////////////////////////////
//// IVA NAV ////////////////////////////////////////////////////
class ivaNav extends oficial
{
  function ivaNav(context)
  {
    oficial(context);
  }
  function extension(nE)
  {
    return this.ctx.ivaNav_extension(nE);
  }
}
//// IVA NAV ////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition ivaNav */
/////////////////////////////////////////////////////////////////
//// IVA NAV ////////////////////////////////////////////////////
function ivaNav_extension(nE)
{
  var _i = this.iface;
  if (nE == "iva_nav") {
    return true;
  }
  return _i.__extension(nE);
}
//// IVA NAV ////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
