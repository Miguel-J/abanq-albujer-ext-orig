
/** @class_declaration bMultiempresa */
/////////////////////////////////////////////////////////////////
//// FUN_BMULTIEMPRESA //////////////////////////////////////////////////
class bMultiempresa extends oficial
{
  function bMultiempresa(context)
  {
    oficial(context);
  }
  function lanzar()
  {
    return this.ctx.bMultiempresa_lanzar();
  }
  function datosInforme(nombrebd: String, codEjercicio: String, fechaDesde: String, fechaHasta: String, subcuentaDesde: String, subcuentaHasta: String)
  {
    return this.ctx.bMultiempresa_datosInforme(nombrebd, codEjercicio, fechaDesde, fechaHasta, subcuentaDesde, subcuentaHasta);
  }
}
//// FUN_BMULTIEMPRESA //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition bMultiempresa */
/////////////////////////////////////////////////////////////////
//// FUN_BMULTIEMPRESA //////////////////////////////////////////////////

/** \D
Se recaban datos para el balance de varias empresas, se introducen en la tabla buffer y se lanza el informe sobre la nueva tabla
\end */
function bMultiempresa_lanzar()
{
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor()
                            if (!cursor.isValid())
                              return;

  // Si es consolidado con la empresa actual, lanzamos el informe normal
  if (cursor.valueBuffer("ejercicioanterior"))
    return this.iface.__lanzar();

  // Si no hay otras empresas lanzamos el informe normal
  if (!util.sqlSelect("co_ejerciciosempresas_sis", "id", "idbalance = " + cursor.valueBuffer("id"))) {
    return this.iface.__lanzar();
  }

  // Vaciar el buffer
  flcontinfo.iface.pub_vaciarBuffer("co_i_balancesis_bmulti_buffer");

  // Recabar datos de esta empresa
  this.iface.datosInforme(sys.nameBD(), cursor.valueBuffer("i_co__subcuentas_codejercicio"), cursor.valueBuffer("d_co__asientos_fecha"), cursor.valueBuffer("h_co__asientos_fecha"), cursor.valueBuffer("d_co__subcuentas_codsubcuenta"), cursor.valueBuffer("h_co__subcuentas_codsubcuenta"));

  // Recabar datos del resto de empresas
  var curTab: FLSqlCursor = new FLSqlCursor("co_ejerciciosempresas_sis");
  curTab.select("idbalance = " + cursor.valueBuffer("id"));
  while (curTab.next())
    this.iface.datosInforme(curTab.valueBuffer("nombrebd"), curTab.valueBuffer("codejercicio"), curTab.valueBuffer("fechadesde"), curTab.valueBuffer("fechahasta"), cursor.valueBuffer("d_co__subcuentas_codsubcuenta"), cursor.valueBuffer("h_co__subcuentas_codsubcuenta"));


  flcontinfo.iface.pub_establecerInformeActual(cursor.valueBuffer("id"), "co_i_balancesis");

  // Lanzar el informe
  var nombreInforme: String = "co_i_balancesis_multi";
  var nombreReport: String = nombreInforme;

  var groupBy: String = "b.codcuenta,b.desccuenta,b.codsubcuenta,b.descsubcuenta";
  var q: FLSqlQuery = new FLSqlQuery(nombreInforme);
  q.setWhere("1=1 GROUP BY " + groupBy);

  if (!q.exec()) {
    MessageBox.critical(util.translate("scripts", "Falló la consulta"),
                        MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
  }

  if (cursor.valueBuffer("nivel") == util.translate("scripts", "Cuenta"))
    nombreReport = "co_i_balancesis_res_multi";

  var rptViewer: FLReportViewer = new FLReportViewer();
  rptViewer.setReportTemplate(nombreReport);
  rptViewer.setReportData(q);
  util.destroyProgressDialog();
  rptViewer.renderReport();
  rptViewer.exec();
}


/** \D
Se recaban datos para el balance de varias empresas, se introducen en la tabla buffer y se lanza el informe sobre la nueva tabla
\end */
function bMultiempresa_datosInforme(nombrebd: String, codEjercicio: String, fechaDesde: String, fechaHasta: String, subcuentaDesde: String, subcuentaHasta: String)
{
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor()

                            var asientoPyG: String;
  var asientoCierre: String;

  var groupBy: String = "co_cuentas.codcuenta," +
                        "co_cuentas.descripcion, co_subcuentas.idsubcuenta, co_subcuentas.codsubcuenta,"
                        + "co_subcuentas.descripcion, co_subcuentas.codcuenta";

  var where: String = "co_asientos.codejercicio = '" + codEjercicio + "'";
  if (fechaDesde)
    where += " AND co_asientos.fecha >= '" + fechaDesde + "'";
  if (fechaHasta)
    where += " AND co_asientos.fecha <= '" + fechaHasta + "'";
  if (subcuentaDesde)
    where += " AND co_partidas.codsubcuenta >= '" + subcuentaDesde + "'";
  if (subcuentaHasta)
    where += " AND co_partidas.codsubcuenta <= '" + subcuentaHasta + "'";

  if (cursor.valueBuffer("ignorarcierre")) {
    asientoPyG = util.sqlSelect("ejercicios", "idasientopyg", "codejercicio = '" + codEjercicio + "'");
    if (!asientoPyG)
      asientoPyG = -1;

    asientoCierre = util.sqlSelect("ejercicios", "idasientocierre", "codejercicio = '" + codEjercicio + "'");
    if (!asientoCierre)
      asientoCierre = -1;

    where += " AND co_asientos.idasiento NOT IN (" + asientoPyG + ", "  + asientoCierre + ")";
  }

  // Conectamos
  var q: FLSqlQuery;
  if (nombrebd != sys.nameBD()) {
    var conexion: String = nombrebd + "_conn";
    if (!flcontinfo.iface.pub_conectar(nombrebd))
      return;
    q = new FLSqlQuery("co_i_balancesis_bmulti", conexion);
  } else
    q = new FLSqlQuery("co_i_balancesis_bmulti");


  q.setWhere(where + " GROUP BY " + groupBy);

  var curTab: FLSqlCursor = new FLSqlCursor("co_i_balancesis_bmulti_buffer");

  if (!q.exec()) {
    MessageBox.critical(util.translate("scripts", "Falló la consulta"),
                        MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
  }

  var paso: Number = 0;
  util.createProgressDialog(util.translate("scripts", "Recabando datos de ") + nombrebd, q.size());

  while (q.next()) {
    curTab.setModeAccess(curTab.Insert);
    curTab.refreshBuffer();
    curTab.setValueBuffer("codejercicio", codEjercicio);
    curTab.setValueBuffer("nombrebd", nombrebd);
    curTab.setValueBuffer("codcuenta", q.value(0));
    curTab.setValueBuffer("desccuenta", q.value(1));
    curTab.setValueBuffer("codsubcuenta", q.value(2));
    curTab.setValueBuffer("descsubcuenta", q.value(3));
    curTab.setValueBuffer("debe", q.value(4));
    curTab.setValueBuffer("haber", q.value(5));
    curTab.setValueBuffer("saldo", q.value(6));
    curTab.commitBuffer();
    util.setProgress(paso++);
  }
  util.destroyProgressDialog();
}

//// FUN_BMULTIEMPRESA /////////////////////////////////////////////////
////////////////////////////////////////////////////////////////

