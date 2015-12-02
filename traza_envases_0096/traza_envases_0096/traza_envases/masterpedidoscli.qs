
/** @class_declaration lotesEnv */
/////////////////////////////////////////////////////////////////
//// LOTES + ENVASES ////////////////////////////////////////////
class lotesEnv extends envases
{
  function lotesEnv(context)
  {
    envases(context);
  }
  function masDatosSelecLote(curLineaPedido: FLSqlCursor): Boolean {
    return this.ctx.lotesEnv_masDatosSelecLote(curLineaPedido);
  }
  function masDatosMoviLote(): Boolean {
    return this.ctx.lotesEnv_masDatosMoviLote();
  }
}
//// LOTES + ENVASES ////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition lotesEnv */
/////////////////////////////////////////////////////////////////
//// LOTES + ENVASES ////////////////////////////////////////////
function lotesEnv_masDatosSelecLote(curLineaPedido: FLSqlCursor): Boolean {
  var codEnvase: String  = curLineaPedido.valueBuffer("codenvase");
  if (!codEnvase)
    return true;

  var valorMetrico: Number = parseFloat(curLineaPedido.valueBuffer("valormetrico"));

  this.iface.curLote.setValueBuffer("codenvase", codEnvase);
  this.iface.curLote.setValueBuffer("canenvaseslinea", curLineaPedido.valueBuffer("canenvases"));
  var canLote: Number = parseFloat(this.iface.curLote.valueBuffer("canlote"));
  var canEnvases: Number = canLote / valorMetrico;
  this.iface.curLote.setValueBuffer("canenvases", canEnvases);

  return true;
}

function lotesEnv_masDatosMoviLote(): Boolean {
  var canEnvases = parseFloat(this.iface.curLote.valueBuffer("canenvases")) * -1;
  var canLote: Number = parseFloat(this.iface.curLote.valueBuffer("canlote")) * -1;
  if (!canEnvases || canEnvases == 0)
    canEnvases = canLote;

  var valorMetrico: Number = canLote / canEnvases

  this.iface.curMoviLote.setValueBuffer("canenvases", canEnvases);
  this.iface.curMoviLote.setValueBuffer("valormetrico", valorMetrico);

  return true;
}
//// LOTES + ENVASES ////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
