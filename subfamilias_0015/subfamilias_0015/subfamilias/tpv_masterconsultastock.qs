
/** @class_declaration subfamilias */
/////////////////////////////////////////////////////////////////
//// SUBFAMILIAS ////////////////////////////////////////////
class subfamilias extends oficial
{
  function subfamilias(context)
  {
    oficial(context);
  }
  function construirWhereStocks()
  {
    return this.ctx.subfamilias_construirWhereStocks();
  }
}
//// SUBFAMILIAS ////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition subfamilias */
/////////////////////////////////////////////////////////////////
//// SUBFAMILIAS ////////////////////////////////////////////
function subfamilias_construirWhereStocks()
{
  var _i = this.iface;

  var where = _i.__construirWhereStocks();

  var codSubfamilia = this.child("fdbCodSubfamilia").value();

  if (codSubfamilia && codSubfamilia != "") {
    if (where != "")
      where += " and ";
    where += "a.codsubfamilia = '" + codSubfamilia + "'";
  }

  return where;
}
//// SUBFAMILIAS ////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
