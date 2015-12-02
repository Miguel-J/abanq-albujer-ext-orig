
/** @class_declaration intrastat */
/////////////////////////////////////////////////////////////////
//// INTRASTAT /////////////////////////////////////////////////
class intrastat extends oficial
{
  function intrastat(context)
  {
    oficial(context);
  }
  function init()
  {
    return this.ctx.intrastat_init();
  }
}
//// INTRASTAT /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition intrastat */
/////////////////////////////////////////////////////////////////
//// INTRASTAT //////////////////////////////////////////////////
function intrastat_init()
{
  this.iface.__init();
  this.child("fdbCodRegimenCli").setFilter("tipo = 'E'");
  this.child("fdbCodRegimenProv").setFilter("tipo = 'I'");
}

//// INTRASTAT //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
