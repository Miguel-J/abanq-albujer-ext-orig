
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
  function tratarCantidad(accion: String): Boolean {
    return this.ctx.lotesEnv_tratarCantidad(accion);
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
  var cursor: FLSqlCursor = this.cursor();
  var util: FLUtil = new FLUtil;
  connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");

  var valorMetrico: Number = cursor.cursorRelation().valueBuffer("valormetrico");
  switch (cursor.modeAccess()) {
    case cursor.Insert: {
      if (valorMetrico) {
        this.child("fdbValorMetrico").setValue(valorMetrico);
      }
    }
    case cursor.Edit: {
      if (valorMetrico) {
        this.child("fdbCantidad").setDisabled(true);
      } else {
        this.child("fdbCanEnvases").setDisabled(true);
      }
      break;
    }
  }

  var docOrigen: String = cursor.valueBuffer("docorigen");
  switch (docOrigen) {
    case "AP": {
      if (util.sqlSelect("movilote", "id", "idlineaap = " + cursor.valueBuffer("idlineaap") + " AND id <> " + cursor.valueBuffer("id")))
        this.child("fdbValorMetrico").setDisabled(true);
      break;
    }
    case "FP": {
      if (util.sqlSelect("movilote", "id", "idlineafp = " + cursor.valueBuffer("idlineafp") + " AND id <> " + cursor.valueBuffer("id")))
        this.child("fdbValorMetrico").setDisabled(true);
      break;
    }
    case "AC": {
      if (util.sqlSelect("movilote", "id", "idlineaac = " + cursor.valueBuffer("idlineaac") + " AND id <> " + cursor.valueBuffer("id")))
        this.child("fdbValorMetrico").setDisabled(true);
      break;
    }
    case "FC": {
      if (util.sqlSelect("movilote", "id", "idlineafc = " + cursor.valueBuffer("idlineafc") + " AND id <> " + cursor.valueBuffer("id"))) {
        this.child("fdbValorMetrico").setDisabled(true);
      }
      break;
    }
    case "VC": {
      if (util.sqlSelect("movilote", "id", "idlineavc = " + cursor.valueBuffer("idlineavc") + " AND id <> " + cursor.valueBuffer("id")))
        this.child("fdbValorMetrico").setDisabled(true);
      break;
    }
    case "TI": {
      if (util.sqlSelect("movilote", "id", "idlineati = " + cursor.valueBuffer("idlineati") + " AND id <> " + cursor.valueBuffer("id")))
        this.child("fdbValorMetrico").setDisabled(true);
      break;
    }
  }
}

function lotesEnv_bufferChanged(fN: String)
{
  var cursor: FLSqlCursor = this.cursor();

  switch (fN) {
    case "valormetrico":
    case "canenvases": {
      this.child("fdbCantidad").setValue(this.iface.calculateField("cantidad"));
      break;
    }
  }
}

function lotesEnv_calculateField(fN: String): String {
  var cursor: FLSqlCursor = this.cursor();
  var valor: String;

  switch (fN)
  {
      /** \C Para los envases la --cantidad-- es el producto la --canenvases-- y el --valormetrico--
      \end */
    case "cantidad": {
      valor = parseFloat(cursor.valueBuffer("canenvases")) * parseFloat(cursor.valueBuffer("valormetrico"));
      break;
    }
    default: {
      valor = this.iface.__calculateField(fN);
      break;
    }
  }
  return valor;
}

/** \D En los documentos de cliente la cantidad se muestra cambiada de signo para facilitar su edición. Para ello se cambia el signo al iniciarse y cerrarse el formulario.
@param accion: Nombre de la acción desde la que se llama al formulario de movimiento de lotes
\end */
function lotesEnv_tratarCantidad(accion: String): Boolean {
  var cursor: FLSqlCursor = this.cursor();

  switch (accion)
  {
    case "lineasalbaranescli":
    case "lineasfacturascli":
    case "tpv_lineascomanda": {
      this.child("fdbCanEnvases").setValue(parseFloat(cursor.valueBuffer("canenvases")) * -1);
      break;
    }
  }
  return true;
}
//// LOTES + ENVASES ////////////////////////////////////////////
////////////////////////////////////////////////////////////////
