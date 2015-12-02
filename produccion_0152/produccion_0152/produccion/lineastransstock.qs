
/** @class_declaration prod */
/////////////////////////////////////////////////////////////////
//// PRODUCCION /////////////////////////////////////////////////
class prod extends oficial
{
  function prod(context)
  {
    oficial(context);
  }
  function init()
  {
    return this.ctx.prod_init();
  }
}
//// PRODUCCION /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition prod */
/////////////////////////////////////////////////////////////////
//// PRODUCCION /////////////////////////////////////////////////
function prod_init()
{
  var _i = this.iface;
  _i.__init();

  var cursor = this.cursor();

  this.child("tdbMoviStock").cursor().setMainFilter("idlineats = " + cursor.valueBuffer("idlinea"));
  this.child("tdbMoviStock").refresh();
  this.child("tdbLotesStock").cursor().setMainFilter("codlote IN (SELECT codlote FROM movistock WHERE idlineats = " + cursor.valueBuffer("idlinea") + ")");
  this.child("tdbLotesStock").refresh();
}
//// PRODUCCION /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
