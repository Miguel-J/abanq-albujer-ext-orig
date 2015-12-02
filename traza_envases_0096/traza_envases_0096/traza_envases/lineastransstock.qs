
/** @class_declaration lotesEnv */
/////////////////////////////////////////////////////////////////
//// LOTES + ENVASES ////////////////////////////////////////////
class lotesEnv extends envases
{
  function lotesEnv(context)
  {
    envases(context);
  }
  function masDatosSelecLote(curLineaPedido)
  {
    return this.ctx.lotesEnv_masDatosSelecLote(curLineaPedido);
  }
  function masDatosMoviLote()
  {
    return this.ctx.lotesEnv_masDatosMoviLote();
  }
  function calcularCantidadO()
  {
    return this.ctx.lotesEnv_calcularCantidadO();
  }
  function calcularCantidadD()
  {
    return this.ctx.lotesEnv_calcularCantidadD();
  }
  function calculateField(fN)
  {
    return this.ctx.lotesEnv_calculateField(fN);
  }
}
//// LOTES + ENVASES ////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition lotesEnv */
/////////////////////////////////////////////////////////////////
//// LOTES + ENVASES ////////////////////////////////////////////
function lotesEnv_masDatosSelecLote(): Boolean {
  var cursor: FLSqlCursor = this.cursor();
  var codEnvase: String  = cursor.valueBuffer("codenvase");
  if (!codEnvase)
    return true;

  var valorMetrico: Number = parseFloat(cursor.valueBuffer("valormetrico"));

  this.iface.curLote.setValueBuffer("codenvase", codEnvase);
  this.iface.curLote.setValueBuffer("canenvaseslinea", cursor.valueBuffer("cantenvases"));
  var canLote: Number = parseFloat(this.iface.curLote.valueBuffer("canlote"));
  var canEnvases: Number = canLote / valorMetrico;
  this.iface.curLote.setValueBuffer("canenvases", canEnvases);

  return true;
}

function lotesEnv_masDatosMoviLote(): Boolean {
  var canEnvases = parseFloat(this.iface.curLote.valueBuffer("canenvases"));
  var canLote: Number = parseFloat(this.iface.curLote.valueBuffer("canlote"));
  if (!canEnvases || canEnvases == 0)
    canEnvases = canLote;

  var valorMetrico: Number = canLote / canEnvases

  this.iface.curMoviLote.setValueBuffer("canenvases", canEnvases);
  this.iface.curMoviLote.setValueBuffer("valormetrico", valorMetrico);

  return true;
}

function lotesEnv_calcularCantidadO()
{
  var _i = this.iface;
  var cursor = this.cursor();

  var codEnvase = cursor.valueBuffer("codenvase");
  if (codEnvase && codEnvase != "") {
    this.child("fdbCanEnvases").setValue(_i.calculateField("canenvaseso"));
  }
  _i.__calcularCantidadO();
}

function lotesEnv_calcularCantidadD()
{
  var _i = this.iface;
  var cursor = this.cursor();

  var codEnvase = cursor.valueBuffer("codenvase");
  if (codEnvase && codEnvase != "") {
    this.child("fdbCantEnvases").setValue(_i.calculateField("canenvasesd"));
  }
  _i.__calcularCantidadD();
}

function lotesEnv_calculateField(fN)
{
  var util = new FLUtil;
  var valor = "";
  var cursor = this.cursor();
  var curTS = cursor.cursorRelation();
  var _i = this.iface;

  switch (fN) {
    case "canenvaseso": {
      var referencia = cursor.valueBuffer("referencia");
      var idStock = util.sqlSelect("stocks", "idstock", "codalmacen = '" + curTS.valueBuffer("codalmaorigen") + "' AND referencia = '" + referencia + "'");
      if (!idStock) {
        valor = 0;
        break;
      }
      valor = util.sqlSelect("movilote", "SUM(canenvases)", "idlineats = " + cursor.valueBuffer("idlinea") + " AND idstock = " + idStock);
      valor = isNaN(valor) ? 0 : valor;
      valor *= -1;
      break;
    }
    case "canenvasesd": {
      var referencia = cursor.valueBuffer("referencia");
      var idStock = util.sqlSelect("stocks", "idstock", "codalmacen = '" + curTS.valueBuffer("codalmadestino") + "' AND referencia = '" + referencia + "'");
      if (!idStock) {
        valor = 0;
        break;
      }
      valor = util.sqlSelect("movilote", "SUM(canenvases)", "idlineats = " + cursor.valueBuffer("idlinea") + " AND idstock = " + idStock);
      valor = isNaN(valor) ? 0 : valor;
      break;
    }
    default: {
      valor = _i.__calculateField(fN);
    }
  }
  return valor;
}
//// LOTES + ENVASES ////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
