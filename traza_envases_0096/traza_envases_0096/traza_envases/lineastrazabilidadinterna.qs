
/** @class_declaration trazaEnvases */
/////////////////////////////////////////////////////////////////
//// TRAZA_ENVASES //////////////////////////////////////////////
class trazaEnvases extends oficial
{
  function trazaEnvases(context)
  {
    oficial(context);
  }
  function bufferChanged(fN: String)
  {
    return this.ctx.trazaEnvases_bufferChanged(fN);
  }
  function calculateField(fN: String): String {
    return this.ctx.trazaEnvases_calculateField(fN);
  }
  function habilitarControlesPorLotes()
  {
    return this.ctx.trazaEnvases_habilitarControlesPorLotes();
  }
  function calcularCantidad()
  {
    return this.ctx.trazaEnvases_calcularCantidad();
  }
}
//// TRAZA_ENVASES //////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition trazaEnvases */
/////////////////////////////////////////////////////////////////
//// TRAZA_ENVASES //////////////////////////////////////////////
function trazaEnvases_bufferChanged(fN: String)
{
  var cursor: FLSqlCursor = this.cursor();
  switch (fN) {
    case "canenvases":
    case "valormetrico": {
      this.child("fdbCantidad").setValue(this.iface.calculateField("cantidad"));
      break;
    }
    /** \C Al seleccionar un --codenvase--, se establece automáticamente los valores --referencia-- y --valormetrico-- asociados
    \end */
    case "codenvase": {
      this.child("fdbReferencia").setValue(this.iface.calculateField("referencia"));
      this.child("fdbValorMetrico").setValue(this.iface.calculateField("valormetrico"));
      break;
    }
    case "referencia": {
      this.iface.habilitarControlesPorLotes();
      break;
    }
  }
}

function trazaEnvases_calculateField(fN: String): String {
  debug("CF " + fN);
  var util: FLUtil = new FLUtil();
  var valor: String;
  var cursor: FLSqlCursor = this.cursor();

  switch (fN)
  {
      /** \C --cantidad-- es el producto de --valormetrico-- por --canenvases--
      \end */
    case "cantidad": {
      valor = parseFloat(cursor.valueBuffer("canenvases")) * parseFloat(cursor.valueBuffer("valormetrico"));
      break;
    }
    case "referencia": {
      var codEnvase = cursor.valueBuffer("codenvase");
      var referencia = util.sqlSelect("envases", "referencia", "codenvase = '" + codEnvase + "'");
      if (referencia)
        valor = referencia;
      break;
    }
    case "valormetrico": {
      var codEnvase = cursor.valueBuffer("codenvase");
      var cantidad = util.sqlSelect("envases", "cantidad", "codenvase = '" + codEnvase + "'");
      valor = 1;
      if (cantidad)
        valor = cantidad;
      break;
    }
    case "canenvases": {
      debug(cursor.valueBuffer("idlinea"));
      if (this.iface.porLotes) {
        valor  = util.sqlSelect("movilote", "SUM(canenvases)", "idlineati = " + cursor.valueBuffer("idlinea"));
      } else {
        valor = 0;
      }
      break;
    }
    default: {
      valor = this.iface.__calculateField(fN, cursor);
      break;
    }
  }
  debug("Valor " + valor);
  return valor;
}

function trazaEnvases_habilitarControlesPorLotes()
{
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();
  this.iface.porLotes = util.sqlSelect("articulos", "porlotes", "referencia = '" + cursor.valueBuffer("referencia") + "'");
  if (this.iface.porLotes) {
    this.child("gbxMoviLote").setDisabled(false);
    this.child("fdbCantidad").setDisabled(true);
    this.child("fdbCanEnvases").setDisabled(true);
    this.child("fdbValorMetrico").setDisabled(true);
    this.iface.calcularCantidad();
  } else {
    this.child("gbxMoviLote").setDisabled(true);
    this.child("fdbCantidad").setDisabled(false);
    this.child("fdbCanEnvases").setDisabled(false);
    this.child("fdbValorMetrico").setDisabled(false);
    this.child("fdbReferencia").setDisabled(false);
    this.child("fdbCodEnvase").setDisabled(false);
  }
}

/** \D Calcula la cantidad como suma de los movimientos asociados a la línea.

Si hay uno o más movimientos, la referencia no podrá ser modificada
\end */
function trazaEnvases_calcularCantidad()
{
  var util: FLUtil = new FLUtil;
  if (this.child("tdbMoviLote").cursor().size() > 0) {
    this.child("fdbReferencia").setDisabled(true);
    this.child("fdbCodEnvase").setDisabled(true);
    this.child("fdbValorMetrico").setValue(util.sqlSelect("movilote", "valormetrico", "docorigen = 'TI' AND idlineati = " + this.cursor().valueBuffer("idlinea")));
  } else {
    this.child("fdbReferencia").setDisabled(false);
    this.child("fdbCodEnvase").setDisabled(false);
  }

  this.cursor().setValueBuffer("canenvases", this.iface.calculateField("canenvases"));
}
//// TRAZA_ENVASES //////////////////////////////////////////////
////////////////////////////////////////////////////////////////
