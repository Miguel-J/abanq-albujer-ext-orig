
/** @class_declaration presupanuales */
/////////////////////////////////////////////////////////////////
//// PRESUP_ANUALES /////////////////////////////////////
class presupanuales extends pgc2008
{
  function presupanuales(context)
  {
    pgc2008(context);
  }
  function comprobarAsiento(idAsiento: String, omitirImporte: Boolean): Boolean {
    return this.ctx.presupanuales_comprobarAsiento(idAsiento, omitirImporte);
  }
}
//// PRESUP_ANUALES /////////////////////////////////////
/////////////////////////////////////////////////////////////////


/** @class_declaration contPres */
/////////////////////////////////////////////////////////////////
//// PRESUPUESTOS ANUALES ///////////////////////////////////////
class contPres extends centroscoste
{
  function contPres(context)
  {
    centroscoste(context);
  }
  function creaPartidaPresup(oPar)
  {
    return this.ctx.contPres_creaPartidaPresup(oPar);
  }
  function creaPartidaPresupTrans(oPar)
  {
    return this.ctx.contPres_creaPartidaPresupTrans(oPar);
  }
}
//// PRESUPUESTOS ANUALES ///////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pubContPres */
/////////////////////////////////////////////////////////////////
//// PUB PRESUPUESTOS ANUALES ///////////////////////////////////
class pubContPres extends ifaceCtx
{
  function pubContPres(context)
  {
    ifaceCtx(context);
  }
  function pub_creaPartidaPresupTrans(oPar)
  {
    return this.creaPartidaPresupTrans(oPar);
  }
}
//// PUB PRESUPUESTOS ANUALES ///////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition presupanuales */
/////////////////////////////////////////////////////////////////
//// PRESUP_ANUALES ////////////////////////////////////
function presupanuales_comprobarAsiento(idAsiento: String, omitirImporte: Boolean): Boolean {
  var util: FLUtil = new FLUtil;

  var codEjercicio: String = util.sqlSelect("co_asientos", "codejercicio", "idasiento = " + idAsiento);
  if (util.sqlSelect("ejercicios", "presupuestario", "codejercicio = '" + codEjercicio + "'"))
    return true;

  return this.iface.__comprobarAsiento(idAsiento, omitirImporte);
}
//// PRESUP_ANUALES ////////////////////////////////////
////////////////////////////////////////////////////////////////

/** @class_definition contPres */
/////////////////////////////////////////////////////////////////
//// PRESUPUESTOS ANUALES ///////////////////////////////////////
function contPres_creaPartidaPresupTrans(oPar)
{
  var _i = this.iface;
  var curT = new FLSqlCursor("empresa");
  curT.transaction(false);
  try {
    if (_i.creaPartidaPresup(oPar)) {
      curT.commit();
    } else {
      curT.rollback();
      return false;
    }
  } catch (e) {
    curT.rollback();
    MessageBox.warning(sys.translate("Error al crear la partida presupuestaria: ") + e, MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton, "AbanQ");
    return false;
  }
  return true;
}

function contPres_creaPartidaPresup(oPar)
{
  var _i = this.iface;
  var util = new FLUtil;
  var masWhere = "";
  var codCentro = oPar.codCentro;
  if (codCentro && codCentro != "") {
    masWhere = " AND codcentro = '" + codCentro + "'";
  } else {
    masWhere = " AND (codcentro is null or codcentro = '')";
  }

  var idAsiento = util.sqlSelect("co_asientos", "idasiento", "codejercicio = '" + oPar.codEjercicio + "' AND fecha = '" + oPar.fecha + "'" + masWhere);
  var crearPartida = false;
  if (!idAsiento) {
    var curAsiento = new FLSqlCursor("co_asientos");
    curAsiento.setModeAccess(curAsiento.Insert);
    curAsiento.refreshBuffer();
    curAsiento.setValueBuffer("codejercicio", oPar.codEjercicio);
    curAsiento.setValueBuffer("numero", flcontppal.iface.siguienteNumero(oPar.codEjercicio, "nasiento"));
    curAsiento.setValueBuffer("fecha", oPar.fecha);
    if (codCentro) {
      curAsiento.setValueBuffer("codcentro", codCentro);
    }
    if (!curAsiento.commitBuffer()) {
      return false;
    }
    idAsiento = curAsiento.valueBuffer("idasiento");
    if (!idAsiento) {
      return false;
    }
    crearPartida = true;
  } else {
    if (util.sqlSelect("co_partidas", "debe-haber", "idasiento = " + idAsiento + " AND idsubcuenta = " + oPar.idSubcuenta) != oPar.saldo) {
      if (!util.sqlDelete("co_partidas", "idasiento = " + idAsiento + " AND idsubcuenta = " + oPar.idSubcuenta)) {
        return;
      }
      crearPartida = true;
    }
  }
  if (crearPartida) {
    var curPartida = new FLSqlCursor("co_partidas");
    curPartida.setModeAccess(curPartida.Insert);
    curPartida.refreshBuffer();
    curPartida.setValueBuffer("idasiento", idAsiento);
    curPartida.setValueBuffer("codsubcuenta", AQUtil.sqlSelect("co_subcuentas", "codsubcuenta", "idsubcuenta = " + oPar.idSubcuenta));
    curPartida.setValueBuffer("idsubcuenta", oPar.idSubcuenta);
    if (oPar.saldo > 0) {
      curPartida.setValueBuffer("debe", oPar.saldo);
      curPartida.setValueBuffer("haber", 0);
    } else {
      curPartida.setValueBuffer("debe", 0);
      curPartida.setValueBuffer("haber", oPar.saldo * -1);
    }
    if (!curPartida.commitBuffer()) {
      return false;
    }
  }

  if (!_i.crearCentrosCosteAsiento(idAsiento)) {
    return false;
  }
  if (!_i.comprobarCentrosCosteGrupos6y7(idAsiento)) {
    return false;
  }
  return true;
}
//// PRESUPUESTOS ANUALES ///////////////////////////////////////
/////////////////////////////////////////////////////////////////
