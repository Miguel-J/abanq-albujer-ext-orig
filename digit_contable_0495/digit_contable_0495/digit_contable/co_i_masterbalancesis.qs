
/** @class_declaration digitContable */
/////////////////////////////////////////////////////////////////
//// DIGIT_CONTABLE /////////////////////////////////////////////
class digitContable extends oficial
{
  function digitContable(context)
  {
    oficial(context);
  }
  function cargarQryReport(cursor: FLSqlCursor, idImpresion: String): Array {
    return this.ctx.digitContable_cargarQryReport(cursor, idImpresion);
  }
}
//// DIGIT_CONTABLE /////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition digitContable */
/////////////////////////////////////////////////////////////////
//// DIGIT_CONTABLE //////////////////////////////////////////////
function digitContable_cargarQryReport(cursor: FLSqlCursor, idImpresion: String): Array {
  var util: FLUtil = new FLUtil();
  var nombreInforme: String = cursor.table();
  var nombreReport: String = nombreInforme;
  var datos: Array;
  if (cursor.valueBuffer("resumido"))
    nombreReport = "co_i_balancesis_res";
  if (cursor.valueBuffer("nivel") == "Subcuenta")
    nombreReport = "co_i_balancesis_scta";

  flcontinfo.iface.pub_establecerInformeActual(cursor.valueBuffer("id"), nombreInforme);

  this.iface.rellenarDatos(idImpresion, cursor);

  var q: FLSqlQuery = new FLSqlQuery(nombreInforme);
  q.setWhere("idimpresion = '" + idImpresion + "'");

  if (!q.exec())
  {
    MessageBox.critical(util.translate("scripts", "Falló la consulta"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return;
  }

  if (!q.size())
  {
    /*    MessageBox.warning(util.translate("scripts","No hay registros que cumplan los criterios de búsqueda establecidos"), MessageBox.NoButton);*/
    return;
  }
  debug("nombreReport " + nombreReport);
  datos["query"] = q;
  datos["report"] = nombreReport;
  return datos;
}

//// DIGIT_CONTABLE //////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
