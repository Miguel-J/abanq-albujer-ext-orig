
/** @class_declaration packing */
/////////////////////////////////////////////////////////////////
//// PACKING LIST ///////////////////////////////////////////////
class packing extends oficial
{
  function packing(context)
  {
    oficial(context);
  }
  function bufferChanged(fN: String)
  {
    return this.ctx.packing_bufferChanged(fN);
  }
  function calculateField(fN: String): String {
    return this.ctx.packing_calculateField(fN);
  }
}
//// PACKING LIST ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition packing */
//////////////////////////////////////////////////////////////////
//// PACKING LIST ////////////////////////////////////////////////
function packing_bufferChanged(fN: String)
{
  debug("packing_bufferChanged " + fN);
  var cursor: FLSqlCursor = this.cursor();

  switch (fN) {
    case "largo":
    case "ancho":
    case "alto":
    case "codunidadlargo":
    case "codunidadancho":
    case "codunidadalto":
    case "codunidadvolumen": {
      this.child("fdbVolumen").setValue(this.iface.calculateField("volumen"));
      break;
    }
    default: {
      this.iface.__bufferChanged(fN);
    }
  }
}

function packing_calculateField(fN: String): String {
  var cursor: FLSqlCursor = this.cursor();
  var valor: String;
  switch (fN)
  {
    case "volumen": {
      var largoM: Number = flfactalma.iface.pub_convertirValorUnidades(parseFloat(cursor.valueBuffer("largo")), cursor.valueBuffer("codUnidadLargo"), "m");
      var anchoM: Number = flfactalma.iface.pub_convertirValorUnidades(parseFloat(cursor.valueBuffer("ancho")), cursor.valueBuffer("codUnidadAncho"), "m");
      var altoM: Number = flfactalma.iface.pub_convertirValorUnidades(parseFloat(cursor.valueBuffer("alto")), cursor.valueBuffer("codUnidadAlto"), "m");
      var volM3: Number = altoM * largoM * anchoM;
      valor = flfactalma.iface.pub_convertirValorUnidades(volM3, "m3", cursor.valueBuffer("codUnidadVolumen"));
      break;
    }
    default: {
      valor = this.iface.__calculateField(fN);
    }
  }
  return valor;
}

//// PACKING LIST ////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
