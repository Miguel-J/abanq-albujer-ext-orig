
/** @class_declaration lotesEnv */
/////////////////////////////////////////////////////////////////
//// LOTES + ENVASES ////////////////////////////////////////////
class lotesEnv extends oficial
{
  function lotesEnv(context)
  {
    oficial(context);
  }
  function init()
  {
    return this.ctx.lotesEnv_init();
  }
  function bufferChanged(fN: String)
  {
    return this.ctx.lotesEnv_bufferChanged(fN);
  }
  function calculateField(fN: String): String {
    return this.ctx.lotesEnv_calculateField(fN);
  }
}
//// LOTES + ENVASES ////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition lotesEnv */
/////////////////////////////////////////////////////////////////
//// LOTES + ENVASES ////////////////////////////////////////////
function lotesEnv_init()
{
  this.iface.__init();

  var codEnvase: String = this.cursor().valueBuffer("codenvase");
  if (!codEnvase || codEnvase == "")
    this.child("fdbCanEnvases").setDisabled(true);
  else
    this.child("fdbCantidad").setDisabled(true);

  connect(this.cursor(), "bufferChanged(QString)", this, "iface.bufferChanged");
}

function lotesEnv_bufferChanged(fN: String)
{
  var util: FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  switch (fN) {
    case "canenvases": {
      this.child("fdbCantidad").setValue(this.iface.calculateField("canlote"));
      break;
    }
  }
}

function lotesEnv_calculateField(fN: String): String {
  var util: FLUtil = new FLUtil();
  var cursor: FLSqlCursor = this.cursor();
  var valor: String = "";

  switch (fN)
  {
    case "canlote": {
      var codEnvase: String = cursor.valueBuffer("codenvase");
      if (!codEnvase)
        break;

      var valorMetrico: Number = parseFloat(util.sqlSelect("envases", "cantidad", "codenvase = '" + codEnvase + "'"));
      if (!valorMetrico)
        valorMetrico = 0;

      var cantidad: Number = parseFloat(cursor.valueBuffer("canenvases")) * valorMetrico;
      if (!cantidad)
        cantidad = 0;
      valor = cantidad.toString();
      break;
    }
  }

  return valor;
}
//// LOTES + ENVASES ////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
