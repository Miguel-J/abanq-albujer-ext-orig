
/** @class_declaration ivaNav */
/////////////////////////////////////////////////////////////////
//// IVA NAV ////////////////////////////////////////////////////
class ivaNav extends oficial
{
  function ivaNav(context)
  {
    oficial(context);
  }
  function revisarFacturas()
  {
    return this.ctx.ivaNav_revisarFacturas();
  }
}
//// IVA NAV ////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition ivaNav */
/////////////////////////////////////////////////////////////////
//// IVA NAV ////////////////////////////////////////////////////
function ivaNav_revisarFacturas()
{
  var _i = this.iface;
  _i.actualizarWhereFechas();
  var cursor = this.cursor();

  var fechaDesde = this.child("fdbFechaInicio").value();
  var fechaHasta = this.child("fdbFechaFin").value();
  var codEjercicio = this.child("fdbCodEjercicio").value();

  var whereFacturas = "a.codejercicio = '" + codEjercicio + "' AND a.fecha BETWEEN '" + fechaDesde + "' AND '" + fechaHasta + "' AND excluir303 <> true";
  var qryFacturasCli = new FLSqlQuery();
  with(qryFacturasCli) {
    setTablesList("clientes,facturascli,co_asientos,co_partidas,co_subcuentas");
    setSelect("p.idpartida");
    setFrom("facturascli f INNER JOIN co_asientos a ON f.idasiento = a.idasiento INNER JOIN co_partidas p ON a.idasiento = p.idasiento");
    setWhere(whereFacturas + " GROUP BY p.idpartida");
    setForwardOnly(true);
  }
  debug(qryFacturasCli.sql());
  if (!qryFacturasCli.exec()) {
    return false;
  }

  var totalPasos = qryFacturasCli.size();
  var paso = 0;
  AQUtil.createProgressDialog(sys.translate("Limpiando partidas de facturas de cliente"), totalPasos);
  while (qryFacturasCli.next()) {
    AQUtil.setProgress(++paso);
    if (!_i.actualizarCasilla303Partida(qryFacturasCli.value("p.idpartida"), "NULL")) {
      AQUtil.destroyProgressDialog();
      return false;
    }
  }
  AQUtil.destroyProgressDialog();

  with(qryFacturasCli) {
    setFrom("facturascli f INNER JOIN co_asientos a ON f.idasiento = a.idasiento INNER JOIN co_partidas p ON a.idasiento = p.idasiento INNER JOIN gruposcontablesivaproneg g ON (p.codimpuesto = g.codimpuesto AND p.codgrupoivaneg = g.codgrupoivaneg)");
    setSelect("p.idpartida, p.codsubcuenta, p.recargo, p.codimpuesto, p.codgrupoivaneg, g.casilla303rep, g.casilla303rec, g.codsubcuentarec");
    setWhere(whereFacturas);
  }
  debug(qryFacturasCli.sql());
  if (!qryFacturasCli.exec()) {
    return false;
  }
  totalPasos = qryFacturasCli.size();
  paso = 0;
  AQUtil.createProgressDialog(sys.translate("Procesando facturas de cliente"), totalPasos);

  var idCuentaEsp;
  var casilla;
  var codSubcuenta;
  var recargo;
  while (qryFacturasCli.next()) {
    AQUtil.setProgress(++paso);
    codSubcuenta = qryFacturasCli.value("p.codsubcuenta");
    if (codSubcuenta && codSubcuenta == qryFacturasCli.value("g.codsubcuentarec")) {
      casilla = qryFacturasCli.value("g.casilla303rec");
    } else {
      casilla = qryFacturasCli.value("g.casilla303rep");
    }
    if (!casilla || casilla == "") {
      continue;
    }

    if (!_i.actualizarCasilla303Partida(qryFacturasCli.value("p.idpartida"), casilla)) {
      AQUtil.destroyProgressDialog();
      return false;
    }
  }
  AQUtil.destroyProgressDialog();

  var qryFacturasProv = new FLSqlQuery();
  with(qryFacturasProv) {
    setSelect("p.idpartida");
    setFrom("facturasprov f INNER JOIN co_asientos a ON f.idasiento = a.idasiento INNER JOIN co_partidas p ON a.idasiento = p.idasiento");
    setWhere(whereFacturas + " GROUP BY p.idpartida");
    setForwardOnly(true);
  }
  debug("facturasprov");
  if (!qryFacturasProv.exec()) {
    return false;
  }

  totalPasos = qryFacturasProv.size();
  paso = 0;
  AQUtil.createProgressDialog(sys.translate("Limpiando partidas de facturas de proveedor"), totalPasos);
  while (qryFacturasProv.next()) {
    AQUtil.setProgress(++paso);
    if (!_i.actualizarCasilla303Partida(qryFacturasProv.value("p.idpartida"), "NULL")) {
      AQUtil.destroyProgressDialog();
      return false;
    }
  }
  AQUtil.destroyProgressDialog();


  with(qryFacturasProv) {
    setFrom("facturasprov f INNER JOIN co_asientos a ON f.idasiento = a.idasiento INNER JOIN co_partidas p ON a.idasiento = p.idasiento INNER JOIN gruposcontablesivaproneg g ON (p.codimpuesto = g.codimpuesto AND p.codgrupoivaneg = g.codgrupoivaneg)");
    setSelect("p.idpartida, p.codsubcuenta, p.recargo, p.codimpuesto, p.codgrupoivaneg, g.casilla303rev, g.casilla303sop, g.codsubcuentarev");
    setWhere(whereFacturas);
  }
  debug(qryFacturasProv.sql());

  if (!qryFacturasProv.exec()) {
    return false;
  }

  totalPasos = qryFacturasProv.size();
  paso = 0;
  AQUtil.createProgressDialog(sys.translate("Procesando facturas de proveedor"), totalPasos);
  while (qryFacturasProv.next()) {
    AQUtil.setProgress(++paso);
    codSubcuenta = qryFacturasProv.value("p.codsubcuenta");
    if (codSubcuenta && codSubcuenta == qryFacturasProv.value("g.codsubcuentarev")) {
      casilla = qryFacturasProv.value("g.casilla303rev");
    } else {
      casilla = qryFacturasProv.value("g.casilla303sop");
    }
    if (!casilla || casilla == "") {
      continue;
    }
    /*
    switch (idCuentaEsp) {
      case "IVASOP":
      case "IVASSE": {
        var tipoBienes:String = this.iface.dameTipoBienes(qryFacturasProv.value("p.idasiento"));
        if (!tipoBienes) {
          util.destroyProgressDialog();
          return false;
        }
        switch (tipoBienes) {
          case "corrientes": {
            casilla = "[22]-[23]";
            break;
          }
          case "inversion": {
            casilla = "[24]-[25]";
            break;
          }
          case "indefinido": {
            MessageBox.warning(util.translate("scripts", "No se ha podido determinar si la factura %1 corresponde a la compra de bienes corrientes o de inversión.\nLa factura no será incluida de forma automática en el modelo").arg(qryFacturasProv.value("f.codigo")), MessageBox.Ok, MessageBox.NoButton);
            continue;
          }
        }
        break;
      }
      case "IVASIM": {
        var tipoBienes:String = this.iface.dameTipoBienes(qryFacturasProv.value("p.idasiento"));
        if (!tipoBienes) {
          util.destroyProgressDialog();
          return false;
        }
        switch (tipoBienes) {
          case "corrientes": {
            casilla = "[26]-[27]";
            break;
          }
          case "inversion": {
            casilla = "[28]-[29]";
            break;
          }
          case "indefinido": {
            MessageBox.warning(util.translate("scripts", "No se ha podido determinar si la factura %1 corresponde a la compra de bienes corrientes o de inversión.\nLa factura no será incluida de forma automática en el modelo").arg(qryFacturasProv.value("f.codigo")), MessageBox.Ok, MessageBox.NoButton);
            continue;
          }
        }
        break;
      }
      case "IVASUE": {
        var tipoBienes:String = this.iface.dameTipoBienes(qryFacturasProv.value("p.idasiento"));
        if (!tipoBienes) {
          util.destroyProgressDialog();
          return false;
        }
        switch (tipoBienes) {
          case "corrientes": {
            casilla = "[30]-[31]";
            break;
          }
          case "inversion": {
            casilla = "[32]-[33]";
            break;
          }
          case "indefinido": {
            MessageBox.warning(util.translate("scripts", "No se ha podido determinar si la factura %1 corresponde a la compra de bienes corrientes o de inversión.\nLa factura no será incluida de forma automática en el modelo").arg(qryFacturasProv.value("f.codigo")), MessageBox.Ok, MessageBox.NoButton);
            continue;
          }
        }
        break;
      }
      case "IVASRA": {
        casilla = "[34]";
        break;
      }
      default: {
        continue;
      }
    }
    */

    if (!_i.actualizarCasilla303Partida(qryFacturasProv.value("p.idpartida"), casilla)) {
      AQUtil.destroyProgressDialog();
      return false;
    }
  }
  AQUtil.destroyProgressDialog();

  return true;
}
//// IVA NAV ////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

