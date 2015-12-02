
/** @class_declaration puntosTpv */
//////////////////////////////////////////////////////////////////
//// PUNTOS TPV ///////////////////////////////////////////////////
class puntosTpv extends oficial
{
  function puntosTpv(context)
  {
    oficial(context);
  }
  function init()
  {
    this.ctx.puntosTpv_init();
  }
  function commonCalculateField(fN: String, cursor: FLSqlCursor): String {
    return this.ctx.puntosTpv_commonCalculateField(fN, cursor);
  }
  function actualizarSaldoPuntos()
  {
    this.ctx.puntosTpv_actualizarSaldoPuntos();
  }
}
//// PUNTOS TPV ///////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////


/** @class_definition puntosTpv */
/////////////////////////////////////////////////////////////////
//// PUNTOS TPV /////////////////////////////////////////////////

function puntosTpv_init()
{
  var _i = this.iface;
  var cursor = this.cursor();
  _i.__init();

  connect(this.child("tdbMovPuntos").cursor(), "bufferCommited()", _i, "actualizarSaldoPuntos()");
}

function puntosTpv_commonCalculateField(fN, cursor)
{
  var _i = this.iface;

  switch (fN) {
      //    case "saldopuntos": {
      //      valor = AQUtil.sqlSelect("tpv_movpuntos", "SUM(canpuntos)", "codcliente = '" + cursor.valueBuffer("codcliente") + "'");
      //      break;
      //    }
    default: {
      valor = _i.__commonCalculateField(fN, cursor);
    }
  }
  return valor;
}

function puntosTpv_actualizarSaldoPuntos()
{
  var _i = this.iface;

  //  this.child("fdbSaldoPuntos").setMapValue();
  //  this.child("fdbSaldoPuntos").show();
  //  sys.setObjText(this, "fdbSaldoPuntos", _i.calculateField("saldopuntos"));
}

//// PUNTOS TPV /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
