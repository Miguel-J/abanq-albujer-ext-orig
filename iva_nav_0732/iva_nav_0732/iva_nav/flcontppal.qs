
/** @class_declaration ivaNav */
/////////////////////////////////////////////////////////////////
//// IVA NAV ////////////////////////////////////////////////////
class ivaNav extends oficial
{
  function ivaNav(context)
  {
    oficial(context);
  }
  function comprobarRegIVA(idSubcuenta, idAsiento)
  {
    return this.ctx.ivaNav_comprobarRegIVA(idSubcuenta, idAsiento);
  }
  function calcularSaldo(idSubcuenta)
  {
    return this.ctx.ivaNav_calcularSaldo(idSubcuenta);
  }
}
//// IVA NAV ////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition ivaNav */
/////////////////////////////////////////////////////////////////
//// IVA NAV ////////////////////////////////////////////////////
function ivaNav_comprobarRegIVA(idSubcuenta, idAsiento)
{
  if (!idSubcuenta) {
    return true;
  }
  var _i = this.iface;
  return _i.__comprobarRegIVA(idSubcuenta, idAsiento);
}

function ivaNav_calcularSaldo(idSubcuenta)
{
  if (!idSubcuenta) {
    return true;
  }
  var _i = this.iface;
  return _i.__calcularSaldo(idSubcuenta);
}
//// IVA NAV ////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
