
/** @class_declaration puntosTpv */
//////////////////////////////////////////////////////////////////
//// PUNTOS TPV //////////////////////////////////////////////////
class puntosTpv extends ivaIncluido
{
  var bloqueoPrecio;
  function puntosTpv(context)
  {
    ivaIncluido(context);
  }
  function commonCalculateField(fN, cursor)
  {
    return this.ctx.puntosTpv_commonCalculateField(fN, cursor);
  }
  function bufferChanged(fN)
  {
    return this.ctx.puntosTpv_bufferChanged(fN);
  }
}
//// PUNTOS TPV  /////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_definition puntosTpv */
//////////////////////////////////////////////////////////////////
//// PUNTOS TPV //////////////////////////////////////////////////
function puntosTpv_bufferChanged(fN)
{
  var _i = this.iface;
  var cursor = this.cursor();

  switch (fN) {
    case "pvptotaliva":
    case "cantidad":
    case "referencia": {
      _i.__bufferChanged(fN);
      this.child("fdbCanPuntos").setValue(_i.calculateField("canpuntos"));
      break;
    }
    default: {
      return _i.__bufferChanged(fN);
    }
  }
}

function puntosTpv_commonCalculateField(fN, cursor)
{
  var _i = this.iface;
  var valor;
  var referencia = cursor.valueBuffer("referencia");

  switch (fN) {
    case "canpuntos": {
      var puntosEspeciales;
      var valorPuntoArticulo;
      var valorPuntoGeneral =  flfactalma.iface.pub_valorDefectoAlmacen("valorpuntos");
      puntosEspeciales = AQUtil.sqlSelect("articulos", "programapuntosespeciales", "referencia = '" + referencia + "' AND programapuntosespeciales");
      if (puntosEspeciales) {
        valorPuntoArticulo = AQUtil.sqlSelect("articulos", "valorpuntosespeciales", "referencia = '" + referencia + "'");
      } else {
        valorPuntoArticulo = valorPuntoGeneral;
      }
      var v = cursor.valueBuffer("pvptotaliva");
      v = (v > 0) ? Math.floor(v) : Math.ceil(v);
      valor = valorPuntoArticulo * v;
      break;
    }
    default: {
      valor = _i.__commonCalculateField(fN, cursor);
    }
  }
  return valor;
}

//// PUNTOS TPV //////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
