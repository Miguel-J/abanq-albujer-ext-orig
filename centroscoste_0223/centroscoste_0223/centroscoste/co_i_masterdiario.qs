
/** @class_declaration centrosCoste */
//////////////////////////////////////////////////////////////////
//// CENTROS COSTE /////////////////////////////////////////////////
class centrosCoste extends oficial
{
  function centrosCoste(context)
  {
    oficial(context);
  }
  function lanzar()
  {
    return this.ctx.centrosCoste_lanzar();
  }
}
//// CENTROS COSTE /////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_definition centrosCoste */
/////////////////////////////////////////////////////////////////
//// CENTROS COSTE /////////////////////////////////////////////
function centrosCoste_lanzar()
{
  debug("centrosCoste_lanzar");
  var cursor: FLSqlCursor = this.cursor()
  if (!cursor.isValid()) {
    return;
  }
  var idInforme: Number = cursor.valueBuffer("id");

  var q: FLSqlQuery = new FLSqlQuery;

  q.setTablesList("co_i_centrosdiario");
  q.setFrom("co_i_centrosdiario");
  q.setSelect("codcentro");
  q.setWhere("idinforme = " + idInforme);
  if (!q.exec()) {
    return;
  }
  debug(q.sql());
  if (!q.size()) {
    debug("__lanzar");
    return this.iface.__lanzar();
  }
  debug("sigue");
  var listaCentros: String = "";
  while (q.next()) {
    if (listaCentros) {
      listaCentros += ",";
    }
    listaCentros += "'" + q.value(0) + "'";
  }

  q.setTablesList("co_i_subcentrosdiario");
  q.setFrom("co_i_subcentrosdiario");
  q.setSelect("codsubcentro");
  q.setWhere("idinforme = " + idInforme);
  if (!q.exec()) {
    return;
  }
  var listaSubcentros: String = "";
  while (q.next()) {
    if (listaSubcentros) {
      listaSubcentros += ",";
    }
    listaSubcentros += "'" + q.value(0) + "'";
  }

  var masWhere: String;
  if (listaSubcentros) {
    masWhere = " AND co_partidascc.codsubcentro IN (" + listaSubcentros + ")";
  } else {
    masWhere = " AND co_partidascc.codcentro IN (" + listaCentros + ")";
  }

  // this.iface.ultimaSubcuenta = 0;
  // this.iface.calcularSaldoInicial = cursor.valueBuffer("saldoinicial");

  var nombreReport: String = "co_i_diario_b";
  var nombreInforme: String = "co_i_diario";

  if (cursor.valueBuffer("datosIva")) {
    nombreReport = nombreReport + "_iva";
  }


  var orderBy: String = "";
  /** \D Si el informe se debe agrupar por meses se añade '_mes' al final del nombre del reporte
  \end */
  if (cursor.valueBuffer("agruparmeses")) {
    nombreReport = nombreReport + "_mes";
    nombreInforme = nombreInforme + "_mes";
    orderBy = "co_asientos.fecha";
  }

  var o: String = "";
  for (var i: Number = 1; i <= 1; i++) {
    o = this.iface.obtenerOrden(i, cursor);
    if (o) {
      if (orderBy == "") {
        orderBy = o;
      } else {
        orderBy += ", " + o;
      }
    }
  }
  var groupBy: String = ""; // co_subcuentas.idsubcuenta, co_subcuentas.codsubcuenta, co_subcuentas.descripcion, co_subcuentas.debe, co_subcuentas.haber, co_subcuentas.saldo, co_asientos.numero, co_asientos.fecha, co_partidas.concepto, co_partidas.debe, co_partidas.haber";

  nombreReport += "_cc";
  nombreInforme += "_cc";
  debug("nombreReport " + nombreReport);
  debug("nombreInforme " + nombreInforme);

  flcontinfo.iface.pub_lanzarInforme(cursor, nombreInforme, nombreReport, orderBy, groupBy, masWhere, cursor.valueBuffer("id"));
}
//// CENTROS COSTE /////////////////////////////////////////////
////////////////////////////////////////////////////////////////
