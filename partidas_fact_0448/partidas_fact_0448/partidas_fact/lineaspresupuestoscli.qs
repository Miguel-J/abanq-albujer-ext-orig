
/** @class_declaration partidas */
/////////////////////////////////////////////////////////////////
//// PARTIDAS FACT //////////////////////////////////////////////
class partidas extends oficial
{
  function partidas(context)
  {
    oficial(context);
  }

  function init()
  {
    return this.ctx.partidas_init();
  }
  function bufferChanged(fN: String)
  {
    return this.ctx.partidas_bufferChanged(fN);
  }
}
//// PARTIDAS FACT //////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition partidas */
/////////////////////////////////////////////////////////////////
//// PARTIDAS FACT //////////////////////////////////////////////
function partidas_init()
{
  this.iface.__init();

  var cursor: FLSqlCursor = this.cursor();
  this.child("fdbIdPartida").setFilter("idpresupuesto = " + cursor.valueBuffer("idpresupuesto"));

  if (cursor.modeAccess() == cursor.Insert) {
    var idPartida: String = formRecordpresupuestoscli.iface.pub_comprobarCapituloActivo();
    if (idPartida && idPartida != "") {
      cursor.setValueBuffer("idpartida", idPartida);
    }
  }
}

function partidas_bufferChanged(fN: String)
{
  var cursor: FLSqlCursor = this.cursor();
  var util: FLUtil = new FLUtil();
  switch (fN) {
    case "idpartida": {
      var orden: String = util.sqlSelect("partidas", "orden", "idpartida = " + cursor.valueBuffer("idpartida"));
      if (orden) {
        cursor.setValueBuffer("ordenpartida", orden);
      }
      break;
    }
    default: {
      this.iface.__bufferChanged(fN);
    }
  }
}

//// PARTIDAS FACT //////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
