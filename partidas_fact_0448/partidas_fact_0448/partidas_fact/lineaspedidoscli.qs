
/** @class_declaration partidasFact */
/////////////////////////////////////////////////////////////////
//// PARTIDAS_FACT //////////////////////////////////////////////
class partidasFact extends numLinea
{
  function partidasFact(context)
  {
    numLinea(context);
  }
  function init()
  {
    return this.ctx.partidasFact_init();
  }
  function commonCalculateField(fN: String, cursor: FLSqlCursor): String {
    return this.ctx.partidasFact_commonCalculateField(fN, cursor);
  }
  function bufferChanged(fN: String)
  {
    return this.ctx.partidasFact_bufferChanged(fN);
  }
}
//// PARTIDAS_FACT //////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition partidasFact */
/////////////////////////////////////////////////////////////////
//// PARTIDAS_FACT //////////////////////////////////////////////
function partidasFact_init()
{
  interna_init();

  var cursor: FLSqlCursor = this.cursor();
  this.child("fdbIdPartidaPed").setFilter("idpedido = " + cursor.valueBuffer("idpedido"));
  if (cursor.modeAccess() == cursor.Insert) {
    var idPartida: String = formRecordpedidoscli.iface.pub_comprobarCapituloActivo();
    if (idPartida && idPartida != "") {
      cursor.setValueBuffer("idpartidaped", idPartida);
    }
  }

  switch (cursor.modeAccess()) {
    case cursor.Insert: {
      this.child("fdbNumLinea").setValue(this.iface.calculateField("numlinea"));
      break;
    }
  }

}

function partidasFact_bufferChanged(fN: String)
{
  var cursor: FLSqlCursor = this.cursor();
  var util: FLUtil = new FLUtil();
  switch (fN) {
    case "idpartidaped": {
      var orden: String = util.sqlSelect("partidasped", "orden", "idpartidaped = " + cursor.valueBuffer("idpartidaped"));
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

function partidasFact_commonCalculateField(fN: String, cursor: FLSqlCursor): String {
  var util: FLUtil = new FLUtil();
  var valor: String;

  switch (fN)
  {
    case "numlinea": {
      var tabla: String = cursor.table();
      var idTabla: String;
      var campoId: String;
      switch (tabla) {
        case "lineaspresupuestoscli": {
          campoId = "idpresupuesto";
          idTabla = cursor.valueBuffer("idpresupuesto");

          if (cursor.valueBuffer("idpartida")) {
            valor = parseInt(util.sqlSelect(tabla, "numlinea", campoId + " = " + idTabla + " AND idpartida = " + cursor.valueBuffer("idpartida") + " ORDER BY numlinea DESC"));
          } else {
            valor = parseInt(util.sqlSelect(tabla, "numlinea", campoId + " = " + idTabla + " AND idpartida IS NULL ORDER BY numlinea DESC"));
          }
          if (isNaN(valor)) {
            valor = 0;
          }
          valor++;
          break;
        }
        case "lineaspedidoscli": {
          campoId = "idpedido";
          idTabla = cursor.valueBuffer("idpedido");
          if (cursor.valueBuffer("idpartidaped")) {
            valor = parseInt(util.sqlSelect(tabla, "numlinea", campoId + " = " + idTabla + " AND idpartidaped = " + cursor.valueBuffer("idpartidaped") + " ORDER BY numlinea DESC"));
          } else {
            valor = parseInt(util.sqlSelect(tabla, "numlinea", campoId + " = " + idTabla + " AND idpartidaped IS NULL ORDER BY numlinea DESC"));
          }
          if (isNaN(valor)) {
            valor = 0;
          }
          valor++;
          break;
        }
        case "lineasalbaranescli": {
          campoId = "idalbaran";
          idTabla = cursor.valueBuffer("idalbaran");

          if (cursor.valueBuffer("idpartidaalb")) {
            valor = parseInt(util.sqlSelect(tabla, "numlinea", campoId + " = " + idTabla + " AND idpartidaalb = " + cursor.valueBuffer("idpartidaalb") + " ORDER BY numlinea DESC"));
          } else {
            valor = parseInt(util.sqlSelect(tabla, "numlinea", campoId + " = " + idTabla + " AND idpartidaalb IS NULL ORDER BY numlinea DESC"));
          }
          if (isNaN(valor)) {
            valor = 0;
          }
          valor++;
          break;
        }
        case "lineasfacturascli": {
          campoId = "idfactura";
          idTabla = cursor.valueBuffer("idfactura");

          if (cursor.valueBuffer("idpartidafact")) {
            valor = parseInt(util.sqlSelect(tabla, "numlinea", campoId + " = " + idTabla + " AND idpartidafact = " + cursor.valueBuffer("idpartidafact") + " ORDER BY numlinea DESC"));
          } else {
            valor = parseInt(util.sqlSelect(tabla, "numlinea", campoId + " = " + idTabla + " AND idpartidafact IS NULL ORDER BY numlinea DESC"));
          }
          if (isNaN(valor)) {
            valor = 0;
          }
          valor++;
          break;
        }
        default: {
          valor = this.iface.__commonCalculateField(fN, cursor);
          break;
        }
      }
      break;
    }
    default: {
      valor = this.iface.__commonCalculateField(fN, cursor);
    }
  }
  return valor;
}

//// PARTIDAS_FACT //////////////////////////////////////////////
////////////////////////////////////////////////////////////////
