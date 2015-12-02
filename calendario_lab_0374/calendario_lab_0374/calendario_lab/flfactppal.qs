
/** @class_declaration calendario */
/////////////////////////////////////////////////////////////////
//// CALENDARIO LABORAL /////////////////////////////////////////
class calendario extends oficial
{
  function calendario(context)
  {
    oficial(context);
  }
  function afterCommit_agentes(curAgente: FLSqlCursor): Boolean {
    return this.ctx.calendario_afterCommit_agentes(curAgente);
  }
  function regenerarCalendarioAgente(curAgente: FLSqlCursor): Boolean {
    return this.ctx.calendario_regenerarCalendarioAgente(curAgente);
  }
}
//// CALENDARIO LABORAL /////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition calendario */
/////////////////////////////////////////////////////////////////
//// CALENDARIO LABORAL /////////////////////////////////////////
function calendario_afterCommit_agentes(curAgente: FLSqlCursor): Boolean {
  //  if (!this.iface.__afterCommit_agentes(curAgente)) {
  //    return false;
  //  }
  /// Funcionalidad de ejemplo para ver el funcionamiento de horarios sobre objetos de AbanQ. No debe estar visible en extensión oficial
  if (!this.iface.regenerarCalendarioAgente(curAgente))
  {
    return false;
  }
  return true;
}

/** \D Si se crea un nuevo agente, su calendario laboral se creará a la vez
\end */
function calendario_regenerarCalendarioAgente(curAgente: FLSqlCursor): Boolean {
  var util: FLUtil = new FLUtil();
  switch (curAgente.modeAccess())
  {
    case curAgente.Insert: {
      var hoy: Date = new Date;
      var hastaCal: Date = util.sqlSelect("calendariolab", "fecha", "1 = 1ORDER BY fecha DESC");
      if (hastaCal) {
        if (!formcalendariolab.iface.pub_regenerarDiasAgentes(hoy, hastaCal, curAgente.valueBuffer("codagente"))) {
          return false;
        }
      }
      break;
    }
    default: {
      return true;
    }
  }
  return true;
}

// function calendario_afterCommit_calendariolab(curCal:FLSqlCursor):Boolean
// {
//  if (!this.iface.recalcularHuecosCal(curCal)) {
//    return false;
//  }
//  return true;
// }
//
// /**\D Función que recalcula los huecos de tiempo asociados a un día del calendario laboral para cada tipo de registro afectado (que deba mantener una planificación temporal)
// \end */
// function calendario_recalcularHuecosCal(curCal:FLSqlCursor):Boolean
// {
//  if (!this.iface.recalcularHuecosCalAgentes(curCal)) {
//    return false;
//  }
//  return true;
// }
//
// function calendario_recalcularHuecosCalAgentes(curCal:FLSqlCursor):Boolean
// {
//
// }
//// CALENDARIO LABORAL /////////////////////////////////////////
/////////////////////////////////////////////////////////////////
