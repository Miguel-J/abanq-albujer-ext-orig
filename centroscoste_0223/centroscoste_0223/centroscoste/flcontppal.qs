
/** @class_declaration centroscoste */
/////////////////////////////////////////////////////////////////
//// CENTROS COSTE ///////////////////////////////////////
class centroscoste extends pgc2008
{
  function centroscoste(context)
  {
    pgc2008(context);
  }
  function comprobarCentrosCosteGrupos6y7(idAsiento: Number, manual: Boolean)
  {
    return this.ctx.centroscoste_comprobarCentrosCosteGrupos6y7(idAsiento, manual);
  }
  function crearCentrosCosteAsiento(idAsiento: Number, codCentro: String, codSubCentro: String)
  {
    return this.ctx.centroscoste_crearCentrosCosteAsiento(idAsiento, codCentro, codSubCentro);
  }
  function generarPartidasDotacion(curDotacion, idAsiento, valoresDefecto)
  {
    return this.ctx.centroscoste_generarPartidasDotacion(curDotacion, idAsiento, valoresDefecto);
  }
}
//// CENTROS COSTE ///////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pubCentrosCoste */
/////////////////////////////////////////////////////////////////
//// PUB_CENTROSCOSTE //////////////////////////////////
class pubCentrosCoste extends ifaceCtx
{
  function pubCentrosCoste(context)
  {
    ifaceCtx(context);
  }
  function pub_comprobarCentrosCosteGrupos6y7(idAsiento: Number, manual: Boolean)
  {
    return this.comprobarCentrosCosteGrupos6y7(idAsiento, manual);
  }
  function pub_crearCentrosCosteAsiento(idAsiento: Number, codCentro: String, codSubCentro: String)
  {
    return this.crearCentrosCosteAsiento(idAsiento, codCentro, codSubCentro);
  }
}
//// PUB_CENTROSCOSTE ///////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition centroscoste */
/////////////////////////////////////////////////////////////////
//// CENTROS COSTE //////////////////////////////////////
function centroscoste_generarPartidasDotacion(curDotacion, idAsiento, valoresDefecto)
{
  if (!this.iface.__generarPartidasDotacion(curDotacion, idAsiento, valoresDefecto)) {
    return false;
  }
  if (!this.iface.crearCentrosCosteAsiento(idAsiento)) {
    return false;
  }
  if (!this.iface.comprobarCentrosCosteGrupos6y7(idAsiento)) {
    return false;
  }
  return true;
}

function centroscoste_comprobarCentrosCosteGrupos6y7(idAsiento, manual)
{
  if (!idAsiento) {
    return false;
  }
  var util: FLUtil;

  if (!flfactppal.iface.pub_valorDefectoEmpresa("validarpartidascc")) {
    return true;
  }
  var qryPartidas = new FLSqlQuery();
  qryPartidas.setTablesList("co_partidas");
  qryPartidas.setSelect("idpartida, codsubcuenta, debe-haber, debe, haber");
  qryPartidas.setFrom("co_partidas");
  qryPartidas.setWhere("idasiento = " + idAsiento);
  qryPartidas.setForwardOnly(true);
  if (!qryPartidas.exec()) return false;

  var codSubcuenta, debe, haber;
  while (qryPartidas.next()) {
    codSubcuenta = qryPartidas.value("codsubcuenta");
    debe = qryPartidas.value("debe");
    debe = isNaN(debe) ? 0 : debe;
    haber = qryPartidas.value("haber");
    haber = isNaN(haber) ? 0 : haber;
    if (codSubcuenta && codSubcuenta != "") {
      if (codSubcuenta.startsWith("6") || codSubcuenta.startsWith("7")) {
        var sumCentrosCoste = parseFloat(util.sqlSelect("co_partidascc", "SUM(importe)", "idpartida  = " + qryPartidas.value("idpartida")));
        var importePartida: Number = (debe > 0) ? debe : haber; //parseFloat(qryPartidas.value("debe-haber"));
        if (importePartida && importePartida != 0) {
          /// El signo del importe de CC debe coincidir con el signo del debe o el haber
          if (sumCentrosCoste != importePartida) {
            if (manual) {
              MessageBox.warning(util.translate("scripts",  "Este asiento afecta a subcuentas de los grupos 6 o 7 y su centro de coste no ha sido informado.\nDebe crear manualmente los centros de coste para las partidas correspondientes."), MessageBox.Ok, MessageBox.NoButton);
            } else {
              MessageBox.warning(util.translate("scripts",  "No es posible generar el asiento.\nEste asiento afecta a subcuentas de los grupos 6 o 7 y su centro de coste no ha sido informado o los totales no coinciden."), MessageBox.Ok, MessageBox.NoButton);
            }
            return false;
          }
        }
      }
    }
  }

  return true;
}

function centroscoste_crearCentrosCosteAsiento(idAsiento, codCentro, codSubCentro)
{
  var util: FLUtil;

  if (!idAsiento) {
    return false;
  }

  if (!codCentro || codCentro == "") {
    codCentro = util.sqlSelect("co_asientos", "codcentro", "idasiento = " + idAsiento);
  }
  if (!codCentro || codCentro == "") {
    return true;
  }
  if (!codSubCentro) {
    codSubCentro = util.sqlSelect("co_asientos", "codsubcentro", "idasiento = " + idAsiento);
  }
  if (!codSubCentro) {
    codSubCentro = "";
  }
  var qryPartidas = new FLSqlQuery();
  qryPartidas.setTablesList("co_partidas");
  qryPartidas.setSelect("idpartida, codsubcuenta, debe-haber");
  qryPartidas.setFrom("co_partidas");
  qryPartidas.setWhere("idasiento = " + idAsiento);
  qryPartidas.setForwardOnly(true);
  if (!qryPartidas.exec()) return false;

  var codSubcuenta: String;
  var importe: Number;
  var curTab = new FLSqlCursor("co_partidascc");

  while (qryPartidas.next()) {
    codSubcuenta = qryPartidas.value("codsubcuenta");
    if (codSubcuenta && codSubcuenta != "") {
      if (codSubcuenta.startsWith("6") || codSubcuenta.startsWith("7")) {
        if (!util.sqlSelect("co_partidascc", "idpartidacc", "idpartida  = " + qryPartidas.value("idpartida"))) {
          importe = parseFloat(qryPartidas.value("debe-haber"));
          if (importe && importe != 0) {
            if (importe < 0)
              importe = importe * -1;

            curTab.setModeAccess(curTab.Insert);
            curTab.refreshBuffer();
            curTab.setValueBuffer("idpartida", qryPartidas.value("idpartida"));
            curTab.setValueBuffer("codcentro", codCentro);
            if (codSubCentro && codSubCentro != "")
              curTab.setValueBuffer("codsubcentro", codSubCentro);
            curTab.setValueBuffer("importe", importe);
            curTab.commitBuffer();
          }
        }
      }
    }
  }

  return true;
}

/*
function centroscoste_comprobarAsiento(idAsiento, omitirImporte)
{
  var _i = this.iface;
  if (!_i.__comprobarAsiento(idAsiento, omitirImporte)) {
    return false;
  }
  if (!_i.comprobarCCAsiento(idAsiento)) {
    return false;
  }
  return true;
}

function centroscoste_comprobarCCAsiento(idAsiento)
{
  var util = new FLUtil;
  if (util.sqlSelect("co_asientos a LEFT OUTER JOIN co_partidas p ON a.idasiento = p.idasiento LEFT OUTER JOIN co_partidascc cc ON p.idpartida = cc.idpartida", "a.idasiento", "a.idasiento = " + idAsinto + " AND (p.codsubcuenta LIKE '6%' OR p.codsubcuenta LIKE '7%' AND cc.idpartidacc IS NULL"));
  /// Borrar esta función y la anterior
}
*/

//// CENTROS COSTE ////////////////////////////////////////
/////////////////////////////////////////////////////////////////
