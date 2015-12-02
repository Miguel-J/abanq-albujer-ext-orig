
/** @class_declaration digitContable */
/////////////////////////////////////////////////////////////////
//// DIGIT_CONTABLE /////////////////////////////////////////////
class digitContable extends pgc2008
{
  function digitContable(context)
  {
    pgc2008(context);
  }
  function cabeceraInforme(nodo: FLDomNode, campo: String): String {
    return this.ctx.digitContable_cabeceraInforme(nodo, campo);
  }
  function cargarQryReport(cursor: FLSqlCursor): Array {
    return this.ctx.digitContable_cargarQryReport(cursor);
  }
}
//// DIGIT_CONTABLE /////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition digitContable */
/////////////////////////////////////////////////////////////////
//// DIGIT_CONTABLE /////////////////////////////////////////////
function digitContable_cabeceraInforme(nodo: FLDomNode, campo: String): String {
  var texCampo: String = new String(campo);

  var util: FLUtil = new FLUtil();
  var desc: String;
  var ejAct: String, ejAnt: String;

  var texto: String;
  var sep: String = "       ";

  var qCondiciones: FLSqlQuery = new FLSqlQuery();
  qCondiciones.setTablesList(this.iface.nombreInformeActual);
  qCondiciones.setFrom(this.iface.nombreInformeActual);
  qCondiciones.setWhere("id = " + this.iface.idInformeActual);

  switch (campo)
  {
    case "balancesit": {
      qCondiciones.setSelect("descripcion,i_co__subcuentas_codejercicioact,d_co__asientos_fechaact,h_co__asientos_fechaact,i_co__subcuentas_codejercicioant,d_co__asientos_fechaant,h_co__asientos_fechaant");
      if (!qCondiciones.exec())
        return "";
      if (!qCondiciones.first())
        return "";

      desc = qCondiciones.value(0);
      ejAct = qCondiciones.value(1);

      fchDesde = qCondiciones.value(2).toString().left(10);
      fchHasta = qCondiciones.value(3).toString().left(10);
      fchDesde = util.dateAMDtoDMA(fchDesde);
      fchHasta = util.dateAMDtoDMA(fchHasta);

      ejAnt = qCondiciones.value(4);
      fchDesdeAnt = qCondiciones.value(5);
      fchHastaAnt = qCondiciones.value(6);
      fchDesdeAnt = util.dateAMDtoDMA(fchDesdeAnt);
      fchHastaAnt = util.dateAMDtoDMA(fchHastaAnt);

      texto = "[ " + desc + " ]" + sep + "Ej. " + ejAct + " | Periodo: " + fchDesde + " - " + fchHasta;
      break;
    }
    case "balancepyg08": {
      qCondiciones.setTablesList("co_i_cuentasanuales");
      qCondiciones.setFrom("co_i_cuentasanuales");
      qCondiciones.setSelect("descripcion,i_co__subcuentas_codejercicioact,d_co__asientos_fechaact,h_co__asientos_fechaact");

      if (!qCondiciones.exec())
        return "";
      if (!qCondiciones.first())
        return "";

      desc = qCondiciones.value(0);
      ejAct = qCondiciones.value(1);
      fchDesde = qCondiciones.value(2).toString().left(10);
      fchHasta = qCondiciones.value(3).toString().left(10);
      fchDesde = util.dateAMDtoDMA(fchDesde);
      fchHasta = util.dateAMDtoDMA(fchHasta);

      texto = "[ " + desc + " ]" + sep + "Ejercicio " + ejAct + " | Periodo: " + fchDesde + " - " + fchHasta;
      break;
    }
    default: {
      return this.iface.__cabeceraInforme(nodo, campo);
    }
  }

  if (!texto)
    texto = "";

  return texto;
}

function digitContable_cargarQryReport(cursor: FLSqlCursor): Array {
  var util: FLUtil = new FLUtil;
  var datos: Array;
  var idBalance = cursor.valueBuffer("id");

  if (cursor.valueBuffer("recalculoauto"))
  {
    if (!this.iface.recalcularDatosBalance(cursor))
      return;
  }

  this.iface.resultadoEjercicio08("saldoact", idBalance);
  if (cursor.valueBuffer("i_co__subcuentas_codejercicioant"))
    this.iface.resultadoEjercicio08("saldoant", idBalance);

  if (!util.sqlSelect("co_i_balances08_datos", "id", "idbalance = " + idBalance))
  {
    MessageBox.information(util.translate("scripts", "No existen datos para este informe. Debe crearlos con el boton <<Recalcular>> del formulario"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return;
  }

  var qInforme: FLSqlQuery = new FLSqlQuery("co_i_balancesit_08");
  var nombreInforme: String;
  var where: String;
  var orderBy: String = "";

  var tipo: String = cursor.valueBuffer("tipo");
  var formato: String = cursor.valueBuffer("formato");
  var ejAct: String = cursor.valueBuffer("i_co__subcuentas_codejercicioact");
  var ejAnt: String = cursor.valueBuffer("i_co__subcuentas_codejercicioant");

  this.iface.establecerEjerciciosPYG(ejAct, ejAnt, true);

  switch (tipo)
  {
    case "Situacion":
      where = "(cbl.naturaleza = 'A' OR cbl.naturaleza = 'P')";

      if (formato == "Normal")
        nombreInforme = "co_i_balancesit_08";
      else
        nombreInforme = "co_i_balancesit_08_abr";

      orderBy = "cbl.naturaleza, cbl.nivel1, cbl.nivel2, cbl.orden3, cbl.descripcion4";
      break;

    case "Perdidas y ganancias":
      where = "cbl.naturaleza = 'PG'";
      if (formato == "Normal")
        nombreInforme = "co_i_balancepyg_08";
      else
        nombreInforme = "co_i_balancepyg_08_abr";

      orderBy = "cbl.naturaleza, cbl.nivel1, cbl.nivel2, cbl.orden3, cbl.descripcion4";

      break;

    case "Ingresos y gastos":
      where = "cbl.naturaleza = 'IG'";
      if (formato == "Normal")
        nombreInforme = "co_i_balanceig";
      else
        nombreInforme = "co_i_balanceig_abr";
      orderBy = "cbl.naturaleza, cbl.nivel1, cbl.nivel2, cbl.orden3, cbl.descripcion4";
      break;
  }

  if (idBalance)
    where += " AND buf.idbalance = " + idBalance;

  if (orderBy)
    qInforme.setOrderBy(orderBy);

  qInforme.setWhere(where);
  debug(qInforme.sql());
  debug(qInforme.size());
  if (!qInforme.size())
  {
    return;
  }
  datos["query"] = qInforme;
  datos["report"] = nombreInforme;
  return datos;
}

//// DIGIT_CONTABLE /////////////////////////////////////////////
//////////////////////////////////////////////////////////////
