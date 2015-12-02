
/** @class_declaration cCoste */
/////////////////////////////////////////////////////////////////
//// CENTROS COSTE //////////////////////////////////////////////
class cCoste extends oficial
{
  function cCoste(context)
  {
    oficial(context);
  }
  function accionesFinPaso(curPlanPartida)
  {
    return this.ctx.cCoste_accionesFinPaso(curPlanPartida);
  }
  function comprobarCentroCoste(curPlanPartida)
  {
    return this.ctx.cCoste_comprobarCentroCoste(curPlanPartida);
  }
}
//// CENTROS COSTE //////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition cCoste */
/////////////////////////////////////////////////////////////////
//// CENTROS COSTE //////////////////////////////////////////////
function cCoste_accionesFinPaso(curPlanPartida)
{
  if (!this.iface.__accionesFinPaso(curPlanPartida)) {
    return false;
  }
  if (!this.iface.comprobarCentroCoste(curPlanPartida)) {
    return false;
  }
  return true;
}

function cCoste_comprobarCentroCoste(curPlanPartida)
{
  var codCentro = curPlanPartida.valueBuffer("codcentro");
  if (!codCentro || codCentro == "") {
    return true;
  }
  var codSubcentro = curPlanPartida.valueBuffer("codsubcentro");
  if (!this.child("tdbPartidasCC").cursor().commitBufferCursorRelation()) {
    return false;
  }
  var cursor = this.cursor();
  var curPartidaCC = new FLSqlCursor("co_partidascc");
  curPartidaCC.setModeAccess(curPartidaCC.Insert);
  curPartidaCC.refreshBuffer();
  curPartidaCC.setValueBuffer("idpartida", cursor.valueBuffer("idpartida"));
  curPartidaCC.setValueBuffer("codcentro", codCentro);
  curPartidaCC.setValueBuffer("codsubcentro", codSubcentro);
  var debe = parseFloat(cursor.valueBuffer("debe"));
  debe = isNaN(debe) ? 0 : debe;
  var haber = parseFloat(cursor.valueBuffer("haber"));
  haber = isNaN(haber) ? 0 : haber;
  curPartidaCC.setValueBuffer("importe", debe != 0 ? debe : haber);
  if (!curPartidaCC.commitBuffer()) {
    return false;
  }
  return true;
}
//// CENTROS COSTE //////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
