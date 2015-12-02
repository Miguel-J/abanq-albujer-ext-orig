
/** @class_declaration centrosCoste */
//////////////////////////////////////////////////////////////////
//// CENTROS COSTE /////////////////////////////////////////////////
class centrosCoste extends oficial
{
  function centrosCoste(context)
  {
    oficial(context);
  }
  //  function regenerarAsiento(curFactura:FLSqlCursor, valoresDefecto:Array) {
  //    return this.ctx.centrosCoste_regenerarAsiento(curFactura, valoresDefecto);
  //  }
  function generarAsientoFacturaCli(curFactura: FLSqlCursor)
  {
    return this.ctx.centrosCoste_generarAsientoFacturaCli(curFactura);
  }
  function generarAsientoFacturaProv(curFactura: FLSqlCursor)
  {
    return this.ctx.centrosCoste_generarAsientoFacturaProv(curFactura);
  }
  function crearPartidasCC(curFactura: FLSqlCursor)
  {
    return this.ctx.centrosCoste_crearPartidasCC(curFactura);
  }
  function datosAsientoRegenerado(cur: FLSqlCursor, valoresDefecto: Array)
  {
    return this.ctx.centrosCoste_datosAsientoRegenerado(cur, valoresDefecto);
  }
  function distribuyePartidaCC(qP, importe, curTab)
  {
    return this.ctx.centrosCoste_distribuyePartidaCC(qP, importe, curTab);
  }
}
//// CENTROS COSTE /////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_definition centrosCoste */
/////////////////////////////////////////////////////////////////
//// CENTROS COSTE /////////////////////////////////////////////////

// function centrosCoste_regenerarAsiento(curFactura:FLSqlCursor, valoresDefecto:Array)
// {
//  var asiento= this.iface.__regenerarAsiento(curFactura, valoresDefecto);
//
//  if (asiento.error)
//    return asiento;
//
//  if (!curFactura.valueBuffer("codcentro"))
//    return asiento;
//
//  var curAsiento= new FLSqlCursor("co_asientos");
//  var idAsiento= asiento.idasiento;
//
//  curAsiento.select("idasiento = " + idAsiento);
//  if (!curAsiento.first()) {
//    asiento.error = true;
//    return asiento;
//  }
//  curAsiento.setUnLock("editable", true);
//
//  curAsiento.select("idasiento = " + idAsiento);
//  if (!curAsiento.first()) {
//    asiento.error = true;
//    return asiento;
//  }
//  curAsiento.setModeAccess(curAsiento.Edit);
//  curAsiento.refreshBuffer();
//  curAsiento.setValueBuffer("codcentro", curFactura.valueBuffer("codcentro"));
//  curAsiento.setValueBuffer("codsubcentro", curFactura.valueBuffer("codsubcentro"));
//
//  if (!curAsiento.commitBuffer()) {
//    asiento.error = true;
//    return asiento;
//  }
//  curAsiento.select("idasiento = " + idAsiento);
//  if (!curAsiento.first()) {
//    asiento.error = true;
//    return asiento;
//  }
//  curAsiento.setUnLock("editable", false);
//
//  asiento.error = false;
//  return asiento;
// }

function centrosCoste_generarAsientoFacturaCli(curFactura: FLSqlCursor)
{
  if (!this.iface.__generarAsientoFacturaCli(curFactura))
    return false;

  var idAsiento = curFactura.valueBuffer("idasiento");
  if (!idAsiento)
    return true;

  if (!this.iface.crearPartidasCC(curFactura))
    return false;

  if (!flcontppal.iface.pub_comprobarCentrosCosteGrupos6y7(idAsiento))
    return false;

  return true;
}

function centrosCoste_generarAsientoFacturaProv(curFactura: FLSqlCursor)
{
  if (!this.iface.__generarAsientoFacturaProv(curFactura))
    return false;

  var idAsiento = curFactura.valueBuffer("idasiento");
  if (!idAsiento)
    return true;

  if (!this.iface.crearPartidasCC(curFactura))
    return false;

  if (!flcontppal.iface.pub_comprobarCentrosCosteGrupos6y7(idAsiento))
    return false;

  return true;
}

function centrosCoste_crearPartidasCC(curFactura)
{
  var _i = this.iface;
  var util = new FLUtil();

  var tabla = curFactura.table();
  if (tabla != "facturascli" && tabla != "facturasprov")
    return true;

  var idAsiento = curFactura.valueBuffer("idasiento");
  if (!idAsiento)
    return true;

  var tablaLineas = "lineas" + tabla;
  var camposTL =  util.nombreCampos(tablaLineas);
  var hayCampoSubcuenta = false;
  for (var i = 1; i <= camposTL[0]; i++) {
    if (camposTL[i] == "idsubcuenta") {
      hayCampoSubcuenta = true;
    }
  }
  var datosCta: Array;
  debug(tabla);

  var qPartidas = new FLSqlQuery();
  qPartidas.setTablesList("co_partidas");
  qPartidas.setSelect("idsubcuenta, idpartida, debe, haber, codsubcuenta");
  qPartidas.setFrom("co_partidas");

  switch (tabla) {
    case "facturascli":
      qPartidas.setWhere("idAsiento = " + idAsiento + " and codsubcuenta like '7%'");
      break;
    case "facturasprov":
      qPartidas.setWhere("idAsiento = " + idAsiento + " and codsubcuenta like '6%'");
      break;
  }

  if (!qPartidas.exec())
    return;

  var q = new FLSqlQuery();
  q.setTablesList(tablaLineas);
  q.setSelect("codcentro,codsubcentro,sum(pvptotal)");
  q.setFrom(tablaLineas);
  var idPartida: Number;
  var codCentro: String;
  var codSubcentro: String;
  var codCentroF = curFactura.valueBuffer("codcentro");
  var codSubcentroF = curFactura.valueBuffer("codsubcentro");
  var saldo, codSubcuenta, aCtaDtoN, aCtaDtoI;
  var curTab = new FLSqlCursor("co_partidascc");
  var dtoEsp = curFactura.valueBuffer("dtoesp");
  dtoEsp = isNaN(dtoEsp) ? 0 : dtoEsp;
  var importe;
  while (qPartidas.next()) {
    idPartida = qPartidas.value("idpartida");
    if (!util.sqlDelete("co_partidascc", "idpartida = " + idPartida)) {
      return false;
    }
    codSubcuenta = qPartidas.value("codsubcuenta");
    /// Control descuento especial
    if (tabla == "facturascli") {
      aCtaDtoN = this.iface.datosCtaEspecial("DESNAC", curFactura.valueBuffer("codejercicio"));
      aCtaDtoI = this.iface.datosCtaEspecial("DESINT", curFactura.valueBuffer("codejercicio"));
      saldo = qPartidas.value("haber") - qPartidas.value("debe");
    } else {
      aCtaDtoN = this.iface.datosCtaEspecial("DENAPR", curFactura.valueBuffer("codejercicio"));
      aCtaDtoI = this.iface.datosCtaEspecial("DEINPR", curFactura.valueBuffer("codejercicio"));
      saldo = qPartidas.value("debe") - qPartidas.value("haber");
    }
    saldo = isNaN(saldo) ? 0 : saldo;
    if (((aCtaDtoN && aCtaDtoN.error == 0 && aCtaDtoN.codsubcuenta == codSubcuenta) || (aCtaDtoI && aCtaDtoI.error == 0 && aCtaDtoI.codsubcuenta == codSubcuenta)) && saldo == dtoEsp) {
      if (!codCentroF || codCentroF == "") {
        continue;
      }
      curTab.setModeAccess(curTab.Insert);
      curTab.refreshBuffer();
      curTab.setValueBuffer("idpartida", idPartida);
      curTab.setValueBuffer("codcentro", codCentroF);
      if (codSubcentroF) {
        curTab.setValueBuffer("codsubcentro", codSubcentroF);
      }
      curTab.setValueBuffer("importe", saldo);
      if (!curTab.commitBuffer()) {
        return false;
      }
      continue;
    }

    if (hayCampoSubcuenta) {
      q.setWhere("idfactura = " + curFactura.valueBuffer("idfactura") + " AND idsubcuenta = " + qPartidas.value("idsubcuenta") + " GROUP BY codcentro,codsubcentro");

      q.setWhere("idfactura = " + curFactura.valueBuffer("idfactura") + " AND idsubcuenta = " + qPartidas.value("idsubcuenta") + " GROUP BY codcentro,codsubcentro");
      if (!q.exec())
        return;

      if (q.size() == 0)
        q.setWhere("idfactura = " + curFactura.valueBuffer("idfactura") + " AND idsubcuenta IS NULL GROUP BY codcentro,codsubcentro");

      if (!q.exec())
        return;
    } else {
      q.setWhere("idfactura = " + curFactura.valueBuffer("idfactura") + " GROUP BY codcentro,codsubcentro");

      if (!q.exec())
        return;
    }
    while (q.next()) {

      if (q.value(0) && q.value(0) != "") {
        codCentro = q.value(0);
        codSubcentro = q.value(1);
      } else {
        codCentro = codCentroF;
        codSubcentro = codSubcentroF;
      }

      importe = isNaN(q.value(2)) ? 0 : q.value(2);
      importe = q.value("sum(pvptotal)");
      if (curFactura.valueBuffer("deabono")) {
        importe *= -1;
      }
      if (!codCentro || codCentro == "") {
        if (!_i.distribuyePartidaCC(qPartidas, importe, curTab)) {
          return false;
        }
        continue;
      }
      curTab.setModeAccess(curTab.Insert);
      curTab.refreshBuffer();
      curTab.setValueBuffer("idpartida", idPartida);
      curTab.setValueBuffer("codcentro", codCentro);
      if (codSubcentro) {
        curTab.setValueBuffer("codsubcentro", codSubcentro);
      }
      importe = util.roundFieldValue(importe, "co_partidascc", "importe");
      curTab.setValueBuffer("importe", importe);
      if (!curTab.commitBuffer()) {
        return false;
      }
    }
  }

  return true;
}

function centrosCoste_distribuyePartidaCC(qP, importe, curTab)
{
  var acum = 0, parte, i = 0;
  var q = new AQSqlQuery;
  q.setSelect("p.proporcion, p.codcentro");
  q.setFrom("subcuentascriteriocc s INNER JOIN pesoscriteriocc p ON s.codcriterio = p.codcriterio");
  q.setWhere("s.codsubcuenta = '" + qP.value("codsubcuenta") + "'");
  if (!q.exec()) {
    return false;
  }
  debug(q.sql());
  var numCC = q.size();
  while (q.next()) {
    i++;
    curTab.setModeAccess(curTab.Insert);
    curTab.refreshBuffer();
    curTab.setValueBuffer("idpartida", qP.value("idpartida"));
    curTab.setValueBuffer("codcentro", q.value("p.codcentro"));
    if (i == numCC) {
      parte = importe - acum;
    } else {
      parte = importe * q.value("p.proporcion") / 100;
    }
    debug("prop = " + q.value("p.proporcion"));
    debug("parte = " + parte);
    parte = AQUtil.roundFieldValue(parte, "co_partidascc", "importe");
    acum += parseFloat(parte);
    debug("acum = " + acum);
    curTab.setValueBuffer("importe", parte);
    if (!curTab.commitBuffer()) {
      return false;
    }
  }
  return true;
}

function centrosCoste_datosAsientoRegenerado(cur: FLSqlCursor, valoresDefecto: Array)
{
  if (!this.iface.__datosAsientoRegenerado(cur, valoresDefecto))
    return false;

  var util = new FLUtil;
  var tabla = cur.table();
  switch (tabla) {
    case "co_dotaciones": {
      var curAmortizacion = cur.cursorRelation();
      var codCentro, codSubcentro;
      if (curAmortizacion) {
        codCentro = curAmortizacion.valueBuffer("codcentro");
        codSubcentro = curAmortizacion.valueBuffer("codsubcentro");
      } else {
        codCentro = util.sqlSelect("co_amortizaciones", "codcentro", "codamortizacion = '" + cur.valueBuffer("codamortizacion") + "'");
        codSubcentro = util.sqlSelect("co_amortizaciones", "codsubcentro", "codamortizacion = '" + cur.valueBuffer("codamortizacion") + "'");
      }
      if (codCentro && codCentro != "") {
        this.iface.curAsiento_.setValueBuffer("codcentro", codCentro);
      } else {
        this.iface.curAsiento_.setNull("codcentro");
      }
      if (codSubcentro && codSubcentro != "") {
        this.iface.curAsiento_.setValueBuffer("codsubcentro", codSubcentro);
      } else {
        this.iface.curAsiento_.setNull("codsubcentro");
      }
      break;
    }
    default: {
      if (!cur.valueBuffer("codcentro"))
        this.iface.curAsiento_.setNull("codcentro");
      else
        this.iface.curAsiento_.setValueBuffer("codcentro", cur.valueBuffer("codcentro"));

      if (!cur.valueBuffer("codsubcentro"))
        this.iface.curAsiento_.setNull("codsubcentro");
      else
        this.iface.curAsiento_.setValueBuffer("codsubcentro", cur.valueBuffer("codsubcentro"));
    }
  }
  return true;
}
//// CENTROS COSTE ////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
