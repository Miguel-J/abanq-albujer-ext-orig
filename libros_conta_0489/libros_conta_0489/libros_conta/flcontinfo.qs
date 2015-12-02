
/** @class_declaration libros */
/////////////////////////////////////////////////////////////////
//// LIBROS /////////////////////////////////////////////////////
class libros extends pgc2008
{
  function libros(context)
  {
    pgc2008(context);
  }
  function obtenerCriteriosBalance(curTab: FLSqlCursor): Array {
    return this.ctx.libros_obtenerCriteriosBalance(curTab);
  }
}
//// LIBROS /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition libros */
/////////////////////////////////////////////////////////////////
//// LIBROS /////////////////////////////////////////////////////
/** Recalcula todos los datos para el balance
*/
function libros_recalcularDatosBalance(curTab: FLSqlCursor): Boolean {
  var util: FLUtil = new FLUtil();

  var criterios: Array = this.iface.obtenerCriteriosBalance(curTab);

  var idBalance: Number = criterios["idBalance"];
  if (!this.iface.vaciarBuffer08(idBalance))
  {
    return;
  }

  var esAbreviado: Boolean = false;
  var tablaCB: String = "co_cuentascb";

  if (criterios["formato"] == "Abreviado")
  {
    esAbreviado = true;
    tablaCB = "co_cuentascbba";
  }

  if (!this.iface.cuentasSinCB(criterios["ejercicioAct"], esAbreviado))
  {
    return false;
  }

  if (criterios["ejercicioAnt"])
  {
    if (!this.iface.cuentasSinCB(criterios["ejercicioAnt"], esAbreviado)) {
      return false;
    }
  }

  this.iface.pgc2008_vaciarBuffer08(criterios["idBalance"]);
  this.iface.popularBuffer(ejercicioAct, "saldoact", criterios["idBalance"], criterios["fechaDesdeAct"], criterios["fechaHastaAct"], tablaCB);
  if (ejercicioAnt)
  {
    this.iface.popularBuffer(criterios["ejercicioAnt"], "saldoant", criterios["idBalance"], criterios["fechaDesdeAnt"], criterios["fechaHastaAnt"], tablaCB);
  }

  if (criterios["formato"] != "Abreviado")
  {
    this.iface.completarPGB18("saldoact", criterios["idBalance"])
    if (criterios["ejercicioAnt"]) {
      this.iface.completarPGB18("saldoant", criterios["idBalance"]);
    }
  }

  this.iface.calcularSubTotalesBalances08(criterios["idBalance"]);
  return true;
}

function libros_obtenerCriteriosBalance(curTab: FLSqlCursor): Array {
  var criterios: Array = [];
  switch (curTab.table())
  {
    case "i_cuentasanuales": {
      criterios["ejercicioAct"] = curTab.valueBuffer("i_co__subcuentas_codejercicioact");
      criterios["fechaDesdeAct"] = curTab.valueBuffer("d_co__asientos_fechaact");
      criterios["fechaHastaAct"] = curTab.valueBuffer("h_co__asientos_fechaact");

      criterios["ejercicioAnt"] = curTab.valueBuffer("i_co__subcuentas_codejercicioant");
      criterios["fechaDesdeAnt"] = curTab.valueBuffer("d_co__asientos_fechaant");
      criterios["fechaHastaAnt"] = curTab.valueBuffer("h_co__asientos_fechaant");

      criterios["idBalance"] = curTab.valueBuffer("id");
      criterios["formato"] = curTab.valueBuffer("formato");
      break;
    }
    case "i_libroscontables": {
      criterios["ejercicioAct"] = curTab.valueBuffer("codejercicioact");
      criterios["fechaDesdeAct"] = util.sqlSelect("ejercicios", "fechaini", "codejercicio = '" + criterios["ejercicioAct"] + "'");
      criterios["fechaHastaAct"] = util.sqlSelect("ejercicios", "fechafin", "codejercicio = '" + criterios["ejercicioAct"] + "'");

      var ejercicioAnt: String = curTab.valueBuffer("codejercicioant");
      if (ejercicioAnt && ejercicioAnt != "") {
        criterios["ejercicioAnt"] = ejercicioAnt;
        criterios["fechaDesdeAnt"] = util.sqlSelect("ejercicios", "fechaini", "codejercicio = '" + criterios["ejercicioAnt"] + "'");
        criterios["fechaHastaAnt"] = util.sqlSelect("ejercicios", "fechafin", "codejercicio = '" + criterios["ejercicioAnt"] + "'");
      } else {
        criterios["ejercicioAnt"] = false;
        criterios["fechaDesdeAnt"] = false;
        criterios["fechaHastaAnt"] = false;
      }

      criterios["idBalance"] = curTab.valueBuffer("id");
      criterios["formato"] = curTab.valueBuffer("formato");
      break;
    }
  }
  return criterios;
}


//// LIBROS /////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////
