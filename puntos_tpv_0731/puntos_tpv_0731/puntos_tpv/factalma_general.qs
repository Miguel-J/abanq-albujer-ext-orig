
/** @class_declaration puntosTpv */
//////////////////////////////////////////////////////////////////
//// PUNTOSTPV ///////////////////////////////////////////////////
class puntosTpv extends oficial
{
  function puntosTpv(context)
  {
    oficial(context);
  }
  function init()
  {
    return this.ctx.puntosTpv_init();
  }
  function habilitarPuntos()
  {
    return this.ctx.puntosTpv_habilitarPuntos();
  }
  function bufferChanged(fN: String)
  {
    return this.ctx.puntosTpv_bufferChanged(fN);
  }
}

//// PUNTOSTPV ///////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_definition puntosTpv */
/////////////////////////////////////////////////////////////////
//// PUNTOS TPV /////////////////////////////////////////////////
function puntosTpv_init()
{
  var _i = this.iface;
  var cursor = this.cursor();
  _i.habilitarPuntos();
  _i.__init();
}

function puntosTpv_habilitarPuntos()
{
  var cursor = this.cursor();
  if (cursor.valueBuffer("programapuntos")) {
    this.child("fdbValorPuntos").setDisabled(false);
  } else {
    this.child("fdbValorPuntos").setDisabled(true);
  }
}

function puntosTpv_bufferChanged(fN: String)
{
  var _i = this.iface;

  switch (fN) {
    case "programapuntos": {
      _i.habilitarPuntos();
      break;
    }
    default: {
      _i.__bufferChanged(fN);
    }
  }
}
//// PUNTOS TPV /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
