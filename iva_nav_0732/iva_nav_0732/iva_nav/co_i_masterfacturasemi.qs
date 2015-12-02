
/** @class_declaration ivaNav */
/////////////////////////////////////////////////////////////////
//// IVA NAV ////////////////////////////////////////////////////
class ivaNav extends oficial
{
  function ivaNav(context)
  {
    oficial(context);
  }
  function dameMasWhere()
  {
    return this.ctx.ivaNav_dameMasWhere();
  }
  function dameOrderBy()
  {
    return this.ctx.ivaNav_dameOrderBy();
  }
  function lanzar()
  {
    return this.ctx.ivaNav_lanzar();
  }
}
//// IVA NAV ////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition ivaNav */
/////////////////////////////////////////////////////////////////
//// IVA NAV ////////////////////////////////////////////////////
function ivaNav_dameMasWhere()
{
  return " AND gpn.tipocalculo <> 'No sujeto' AND co_partidas.codimpuesto IS NOT NULL AND co_partidas.codgrupoivaneg IS NOT NULL";
}

function ivaNav_dameOrderBy()
{
  var cursor = this.cursor();
  var orderBy = "";
  var numeracionAuto = cursor.valueBuffer("numeracionauto");
  if (numeracionAuto) {
    orderBy = "co_partidas.codserie, co_asientos.fecha, co_partidas.idasiento, (co_partidas.haber - co_partidas.debe) DESC";
  } else {
    orderBy = "co_partidas.codserie, co_partidas.factura, co_asientos.fecha, co_partidas.idasiento, (co_partidas.haber - co_partidas.debe) DESC";
  }
  if (cursor.valueBuffer("agruparivaneg")) {
    orderBy = "co_partidas.codgrupoivaneg, " + orderBy;
  }
  return orderBy;
}

function ivaNav_lanzar()
{
  var _i = this.iface;
  var cursor = this.cursor()
  if (!cursor.isValid()) {
    return;
  }

  if (!cursor.valueBuffer("agruparivaneg")) {
    _i.__lanzar();
    return;
  }
  var nombreInforme = "co_i_facturasemi_neg";
  var nombreReport = nombreInforme;

  if (cursor.valueBuffer("numeracionauto")) {
    /// nombreReport = nombreReport + "_n"; Ya ne se usa el informe _n, se usa un campo calculado en el informe normal
    flcontinfo.iface.pub_resetearNumFactura(parseFloat(cursor.valueBuffer("numdesde")));
  } else {
    flcontinfo.iface.pub_resetearNumFactura(parseFloat(-1));
  }
  var masWhere: String = _i.dameMasWhere();
  var orderBy: String = _i.dameOrderBy();

  flcontinfo.iface.pub_lanzarInforme(cursor, nombreInforme, nombreReport, orderBy, "", masWhere, cursor.valueBuffer("id"));
}

//// IVA NAV ////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
