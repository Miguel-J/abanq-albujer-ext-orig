
/** @class_declaration centrosCoste */
/////////////////////////////////////////////////////////////////
//// CENTROS COSTE ///////////////////////////////////////
class centrosCoste extends oficial
{
  function centrosCoste(context)
  {
    oficial(context);
  }
  function rellenarDatos(idImpresion: String, cursor: FLSqlCursor)
  {
    return this.ctx.centrosCoste_rellenarDatos(idImpresion, cursor);
  }
}
//// CENTROS COSTE ///////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition centrosCoste */
/////////////////////////////////////////////////////////////////
//// CENTROS COSTE ///////////////////////////////////////
function centrosCoste_rellenarDatos(idImpresion: String, cursor: FLSqlCursor): FLDomDocument {
  var util: FLUtil = new FLUtil;

  var idInforme: Number = cursor.valueBuffer("id");

  var q: FLSqlQuery = new FLSqlQuery;

  q.setTablesList("co_i_centrosbalancesis");
  q.setFrom("co_i_centrosbalancesis");
  q.setSelect("codcentro");
  q.setWhere("idinforme = " + idInforme);
  if (!q.exec())
    return;

  if (!q.size())
    return this.iface.__rellenarDatos(idImpresion, cursor);

  var listaCentros: String = "";
  while (q.next())
  {
    if (listaCentros)
      listaCentros += ",";
    listaCentros += "'" + q.value(0) + "'";
  }

  q.setTablesList("co_i_subcentrosbalancesis");
  q.setFrom("co_i_subcentrosbalancesis");
  q.setSelect("codsubcentro");
  q.setWhere("idinforme = " + idInforme);
  if (!q.exec())
    return;

  var listaSubcentros: String = "";
  while (q.next())
  {
    if (listaSubcentros)
      listaSubcentros += ",";
    listaSubcentros += "'" + q.value(0) + "'";
  }

  var masWhere: String;
  if (listaSubcentros)
    masWhere = " AND co_partidascc.codsubcentro IN (" + listaSubcentros + ")";
  else
    masWhere = " AND co_partidascc.codcentro IN (" + listaCentros + ")";

  var groupBy: String = "co_cuentas.codcuenta, co_cuentas.descripcion, co_subcuentas.codsubcuenta, co_subcuentas.descripcion";
  var orderBy: String = "co_cuentas.codcuenta, co_cuentas.descripcion, co_subcuentas.codsubcuenta, co_subcuentas.descripcion";

  var ejAct: String = cursor.valueBuffer("i_co__subcuentas_codejercicio");
  var desdeAct: String = cursor.valueBuffer("d_co__asientos_fecha");
  var hastaAct: String = cursor.valueBuffer("h_co__asientos_fecha");
  var desdeScta: String = cursor.valueBuffer("d_co__subcuentas_codsubcuenta");
  var hastaScta: String = cursor.valueBuffer("h_co__subcuentas_codsubcuenta");

  var nivel: Number

  // Subcuenta por compatibilidad hacia atras
  if (cursor.valueBuffer("nivel") == "Cuenta" || cursor.valueBuffer("nivel") == "Subcuenta")
    nivel = 0;
  else
    nivel = parseFloat(cursor.valueBuffer("nivel"));

  var where: String = "(co_asientos.codejercicio = '" + ejAct + "'" +
  " AND co_asientos.fecha >= '" + desdeAct + "'" +
  " AND co_asientos.fecha <= '" + hastaAct + "'";

  if (desdeScta)
    where += " AND co_partidas.codsubcuenta >= '" + desdeScta + "'";

  if (hastaScta)
    where += " AND co_partidas.codsubcuenta <= '" + hastaScta + "'";

  var listaAsientos: String = this.iface.quitarAsientos(ejAct, cursor);
  if (listaAsientos && listaAsientos != "")
  {
    where += " AND co_asientos.idasiento NOT IN (" + listaAsientos + ")";
  }

  where += ")";


  var consolidar: Boolean = false;
  if (cursor.valueBuffer("ejercicioanterior") == 1)
    consolidar = true;

  if (consolidar)
  {
    var ejAnt: String = cursor.valueBuffer("codejercicioant");
    var desdeAnt: String = cursor.valueBuffer("fechaant_d");
    var hastaAnt: String = cursor.valueBuffer("fechaant_h");
    desdeScta = cursor.valueBuffer("d_co__subcuentas_codsubcuenta");
    hastaScta = cursor.valueBuffer("h_co__subcuentas_codsubcuenta");

    where +=  " OR (co_asientos.codejercicio = '" + ejAnt + "'" +
    " AND co_asientos.fecha >= '" + desdeAnt + "'" +
    " AND co_asientos.fecha <= '" + hastaAnt + "'" +
    " AND co_partidas.codsubcuenta >= '" + desdeScta + "'" +
    " AND co_partidas.codsubcuenta <= '" + hastaScta + "'";

    var listaAsientosAnt: String = this.iface.quitarAsientos(ejAnt, cursor);
    if (listaAsientosAnt && listaAsientosAnt != "") {
      where += " AND co_asientos.idasiento NOT IN (" + listaAsientos + ")";
    }

    where += ")";
  }

  where += masWhere;

  var codCuenta: String;

  var curTab: FLSqlCursor = new FLSqlCursor("co_i_balancesis_buffer");
  var paso0;
  var debe: Number, haber: Number, saldo: Number;
  var codCuentaAnt;

  var q: FLSqlQuery = new FLSqlQuery();
  q.setTablesList("co_cuentas,co_subcuentas,co_partidas,co_asientos,co_partidascc");
  q.setFrom("co_cuentas INNER JOIN co_subcuentas ON co_cuentas.idcuenta = co_subcuentas.idcuenta INNER JOIN co_partidas ON co_subcuentas.idsubcuenta = co_partidas.idsubcuenta INNER JOIN co_asientos ON co_partidas.idasiento = co_asientos.idasiento INNER JOIN co_partidascc ON co_partidas.idpartida = co_partidascc.idpartida");
  q.setSelect("co_cuentas.codcuenta, co_cuentas.descripcion, co_subcuentas.codsubcuenta, co_subcuentas.descripcion, SUM(co_partidascc.importe)");
  q.setWhere(where + "AND co_partidas.debe >= co_partidas.haber group by " + groupBy + " ORDER BY " + orderBy);

  if (!q.exec())
  {
    MessageBox.critical(util.translate("scripts", "Falló la consulta"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return;
  }

  util.createProgressDialog(util.translate("scripts", "Recabando datos (1 de 2)..."), q.size());
  paso = 0;
  codCuentaAnt = "";
  while (q.next())
  {

    util.setProgress(paso++);

    debe = util.roundFieldValue(q.value("SUM(co_partidascc.importe)"), "co_subcuentas", "debe");
    haber = 0;
    saldo = debe;

    codSubcuenta = q.value("co_subcuentas.codsubcuenta");
    if (nivel == 0) {
      codCuenta = q.value("co_cuentas.codcuenta");
    } else {
      codCuenta = codSubcuenta.left(nivel);
    }

    switch (nivel) {
      case 0:
        descCuenta = util.sqlSelect("co_cuentas", "descripcion", "codcuenta = '" + codCuenta + "' AND codejercicio = '" + ejAct + "'");
        break;
      case 2:
        descCuenta = util.sqlSelect("co_epigrafes", "descripcion", "codepigrafe = '" + codCuenta + "' AND codejercicio = '" + ejAct + "'");
        break;
      case 3:
        descCuenta = util.sqlSelect("co_cuentas", "descripcion", "codcuenta LIKE '" + codCuenta + "%' AND codejercicio = '" + ejAct + "'");
        break;
      case 4:
      case 5:
        descCuenta = util.sqlSelect("co_cuentas", "descripcion", "codcuenta = '" + codCuenta + "' AND codejercicio = '" + ejAct + "'");
        if (!descCuenta)
          descCuenta = util.sqlSelect("co_cuentas", "descripcion", "codcuenta LIKE '" + codCuenta.left(3) + "%' AND codejercicio = '" + ejAct + "'");
        break;
    }

    if (!descCuenta)
      descCuenta = q.value("co_subcuentas.descripcion");

    curTab.select("idimpresion = '" + idImpresion + "' AND codsubcuenta = '" + codSubcuenta + "'");

    if (curTab.first()) {
      curTab.setModeAccess(curTab.Edit);
      curTab.refreshBuffer();
      curTab.setValueBuffer("debe", parseFloat(curTab.valueBuffer("debe")) + parseFloat(debe));
      curTab.setValueBuffer("haber", parseFloat(curTab.valueBuffer("haber")) + parseFloat(haber));
      curTab.setValueBuffer("saldo", parseFloat(curTab.valueBuffer("saldo")) + parseFloat(saldo));
    } else {
      curTab.setModeAccess(curTab.Insert);
      curTab.refreshBuffer();
      curTab.setValueBuffer("idimpresion", idImpresion);
      curTab.setValueBuffer("codsubcuenta", codSubcuenta);
      curTab.setValueBuffer("codcuenta", codCuenta);
      curTab.setValueBuffer("descripcion", q.value("co_subcuentas.descripcion"));
      curTab.setValueBuffer("descripcioncuenta", descCuenta);
      curTab.setValueBuffer("debe", debe);
      curTab.setValueBuffer("haber", haber);
      curTab.setValueBuffer("saldo", saldo);
    }

    curTab.commitBuffer();
  }
  util.destroyProgressDialog();

  q.setTablesList("co_cuentas,co_subcuentas,co_partidas,co_asientos,co_partidascc");
  q.setFrom("co_cuentas INNER JOIN co_subcuentas ON co_cuentas.idcuenta = co_subcuentas.idcuenta INNER JOIN co_partidas ON co_subcuentas.idsubcuenta = co_partidas.idsubcuenta INNER JOIN co_asientos ON co_partidas.idasiento = co_asientos.idasiento INNER JOIN co_partidascc ON co_partidas.idpartida = co_partidascc.idpartida");
  q.setSelect("co_cuentas.codcuenta, co_cuentas.descripcion, co_subcuentas.codsubcuenta, co_subcuentas.descripcion, SUM(co_partidascc.importe)");
  q.setWhere(where + "AND co_partidas.debe < co_partidas.haber group by " + groupBy + " ORDER BY " + orderBy);

  if (!q.exec())
  {
    MessageBox.critical(util.translate("scripts", "Falló la consulta"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return;
  }

  util.createProgressDialog(util.translate("scripts", "Recabando datos (2 de 2)..."), q.size());
  paso = 0;
  codCuentaAnt = "";
  while (q.next())
  {

    util.setProgress(paso++);

    debe = 0;
    haber = util.roundFieldValue(q.value("SUM(co_partidascc.importe)"), "co_subcuentas", "haber");
    saldo = parseFloat(haber) * -1;

    codSubcuenta = q.value("co_subcuentas.codsubcuenta");
    if (nivel == 0) {
      codCuenta = q.value("co_cuentas.codcuenta");
    } else {
      codCuenta = codSubcuenta.left(nivel);
    }

    switch (nivel) {
      case 0:
        descCuenta = util.sqlSelect("co_cuentas", "descripcion", "codcuenta = '" + codCuenta + "' AND codejercicio = '" + ejAct + "'");
        break;
      case 2:
        descCuenta = util.sqlSelect("co_epigrafes", "descripcion", "codepigrafe = '" + codCuenta + "' AND codejercicio = '" + ejAct + "'");
        break;
      case 3:
        descCuenta = util.sqlSelect("co_cuentas", "descripcion", "codcuenta LIKE '" + codCuenta + "%' AND codejercicio = '" + ejAct + "'");
        break;
      case 4:
      case 5:
        descCuenta = util.sqlSelect("co_cuentas", "descripcion", "codcuenta = '" + codCuenta + "' AND codejercicio = '" + ejAct + "'");
        if (!descCuenta)
          descCuenta = util.sqlSelect("co_cuentas", "descripcion", "codcuenta LIKE '" + codCuenta.left(3) + "%' AND codejercicio = '" + ejAct + "'");
        break;
    }

    if (!descCuenta)
      descCuenta = q.value("co_subcuentas.descripcion");

    curTab.select("idimpresion = '" + idImpresion + "' AND codsubcuenta = '" + codSubcuenta + "'");

    if (curTab.first()) {
      curTab.setModeAccess(curTab.Edit);
      curTab.refreshBuffer();
      curTab.setValueBuffer("debe", parseFloat(curTab.valueBuffer("debe")) + parseFloat(debe));
      curTab.setValueBuffer("haber", parseFloat(curTab.valueBuffer("haber")) + parseFloat(haber));
      curTab.setValueBuffer("saldo", parseFloat(curTab.valueBuffer("saldo")) + parseFloat(saldo));
    } else {
      curTab.setModeAccess(curTab.Insert);
      curTab.refreshBuffer();
      curTab.setValueBuffer("idimpresion", idImpresion);
      curTab.setValueBuffer("codsubcuenta", codSubcuenta);
      curTab.setValueBuffer("codcuenta", codCuenta);
      curTab.setValueBuffer("descripcion", q.value("co_subcuentas.descripcion"));
      curTab.setValueBuffer("descripcioncuenta", descCuenta);
      curTab.setValueBuffer("debe", debe);
      curTab.setValueBuffer("haber", haber);
      curTab.setValueBuffer("saldo", saldo);
    }

    curTab.commitBuffer();
  }
  util.destroyProgressDialog();
}
//// CENTROS COSTE ///////////////////////////////////////
/////////////////////////////////////////////////////////////////
