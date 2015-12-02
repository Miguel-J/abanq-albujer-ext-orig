
/** @class_declaration gym */
/////////////////////////////////////////////////////////////////
//// GIMNASIOS //////////////////////////////////////////////////
class gym extends oficial
{
  function gym(context)
  {
    oficial(context);
  }
  function init()
  {
    return this.ctx.gym_init();
  }
  function bufferChanged(fN: String)
  {
    return this.ctx.gym_bufferChanged(fN);
  }
  function habilitarSesiones()
  {
    return this.ctx.gym_habilitarSesiones();
  }
  function calculateField(fN: String): String {
    return this.ctx.gym_calculateField(fN);
  }
}
//// GIMNASIOS //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition gym */
/////////////////////////////////////////////////////////////////
//// GIMNASIOS //////////////////////////////////////////////////
function gym_init()
{
  this.iface.__init();

  this.iface.habilitarSesiones();
}

function gym_bufferChanged(fN: String)
{
  switch (fN) {
    case "codfamilia": {
      this.iface.__bufferChanged(fN);
      this.iface.habilitarSesiones();
      this.child("fdbSeCompra").setValue(this.iface.calculateField("secompra"));
    }
    default: {
      this.iface.__bufferChanged(fN);
    }
  }
}

function gym_calculateField(fN: String): String {
  var cursor: FLSqlCursor = this.cursor();
  var valor: String;
  switch (fN)
  {
    case "secompra": {
      if (cursor.valueBuffer("codfamilia") == "BONO") {
        valor = false;
      } else {
        valor = this.iface.__calculateField(fN);
      }
      break;
    }
    default: {
      valor = this.iface.__calculateField(fN);
    }
  }
  return valor;
}

function gym_habilitarSesiones()
{
  var cursor: FLSqlCursor = this.cursor();
  if (cursor.valueBuffer("codfamilia") == "BONO") {
    this.child("gbxSesiones").enabled = true;
  } else {
    this.child("gbxSesiones").enabled = false;
  }
}
//// GIMNASIOS //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
