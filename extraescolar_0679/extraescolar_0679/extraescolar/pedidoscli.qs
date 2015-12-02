
/** @class_declaration extraescolar */
/////////////////////////////////////////////////////////////////
//// EXTRAESCOLAR //////////////////////////////////////////////
class extraescolar extends oficial
{
  function extraescolar(context)
  {
    oficial(context);
  }
  function init()
  {
    return this.ctx.extraescolar_init();
  }
  function bufferChanged(fN)
  {
    return this.ctx.extraescolar_bufferChanged(fN);
  }
  function establecerFiltroCentro()
  {
    return this.ctx.extraescolar_establecerFiltroCentro();
  }
}
//// EXTRAESCOLAR //////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition extraescolar */
/////////////////////////////////////////////////////////////////
//// EXTRAESCOLAR //////////////////////////////////////////////
function extraescolar_init()
{
  this.iface.__init();

  this.iface.establecerFiltroCentro();
}

function extraescolar_bufferChanged(fN)
{
  var cursor: FLSqlCursor = this.cursor();
  switch (fN) {
    case "codcliente": {
      this.child("fdbCodCentroEsc").setValue(this.iface.calculateField("codcentroesc"));
      this.iface.establecerFiltroCentro();
      this.iface.__bufferChanged(fN);
      break;
    }
  }
}

function extraescolar_establecerFiltroCentro()
{
  var cursor = this.cursor();
  var filtro;
  if (cursor.valueBuffer("codcliente")) {
    filtro = "codcentro IN (SELECT codcentro FROM fo_alumnos WHERE codcliente = '" + cursor.valueBuffer("codcliente") + "')";
  } else {
    filtro = "";
  }
  this.child("fdbCodCentroEsc").setFilter(filtro);
}

//// EXTRAESCOLAR //////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
