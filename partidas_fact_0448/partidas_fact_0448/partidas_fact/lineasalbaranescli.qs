
/** @class_declaration partidas */
/////////////////////////////////////////////////////////////////
//// PARTIDAS ///////////////////////////////////////////////////
class partidas extends numLinea
{
  function partidas(context)
  {
    numLinea(context);
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
//// PARTIDAS ///////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition partidas */
/////////////////////////////////////////////////////////////////
//// PARTIDAS ///////////////////////////////////////////////////
function partidas_init()
{
  interna_init();

  var cursor: FLSqlCursor = this.cursor();
  this.child("fdbIdPartidaAlb").setFilter("idalbaran = " + cursor.valueBuffer("idalbaran"));

  if (cursor.modeAccess() == cursor.Insert) {
    var idPartida: String = formRecordalbaranescli.iface.pub_comprobarCapituloActivo();
    if (idPartida && idPartida != "") {
      cursor.setValueBuffer("idpartidaalb", idPartida);
    }
  }

  switch (cursor.modeAccess()) {
    case cursor.Insert: {
      this.child("fdbNumLinea").setValue(this.iface.calculateField("numlinea"));
      break;
    }
  }
}

function partidas_bufferChanged(fN: String)
{
  var cursor: FLSqlCursor = this.cursor();
  var util: FLUtil = new FLUtil();
  switch (fN) {
    case "idpartidaalb": {
      var orden: String = util.sqlSelect("partidasalb", "orden", "idpartidaalb = " + cursor.valueBuffer("idpartidaalb"));
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

//// PARTIDAS ///////////////////////////////////////////////////
////////////////////////////////////////////////////////////////
