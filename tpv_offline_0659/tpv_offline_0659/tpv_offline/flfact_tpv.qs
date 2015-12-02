
/** @class_declaration offline */
/////////////////////////////////////////////////////////////////
//// TPV OFF LINE////////////////////////////////////////////////
class offline extends oficial
{
  function offline(context)
  {
    oficial(context);
  }
  function comprobarSincronizacion(curComanda: FLSqlCursor): Boolean {
    return this.ctx.offline_comprobarSincronizacion(curComanda);
  }
  function beforeCommit_tpv_pagoscomanda(curPago: FLSqlCursor): Boolean {
    return this.ctx.offline_beforeCommit_tpv_pagoscomanda(curPago);
  }
  function init(): Boolean {
    return this.ctx.offline_init();
  }
  function comprobarSincroCatalogo()
  {
    return this.ctx.offline_comprobarSincroCatalogo();
  }
}
//// TPV OFF LINE////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pubOffline */
/////////////////////////////////////////////////////////////////
//// PUB TPV OFFLINE ////////////////////////////////////////////
class pubOffline extends ifaceCtx
{
  function pubOffline(context)
  {
    ifaceCtx(context);
  }
  function pub_modificarFactura(curComanda: FLSqlCursor, idFactura: String): Number {
    return this.modificarFactura(curComanda, idFactura);
  }
  function pub_generarRecibos(curComanda: FLSqlCursor): Boolean {
    return this.generarRecibos(curComanda);
  }
}
//// PUB TPV OFFLINE ////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition offline */
/////////////////////////////////////////////////////////////////
//// TPV OFF LINE////////////////////////////////////////////////
function offline_comprobarSincronizacion(curComanda: FLSqlCursor): Boolean {
  if (this.iface.pub_valorDefectoTPV("bdoffline"))
  {
    return true;
  }
  if (!this.iface.__comprobarSincronizacion(curComanda))
  {
    return false;
  }
  return true;
}

function offline_beforeCommit_tpv_pagoscomanda(curPago: FLSqlCursor): Boolean {
  if (this.iface.pub_valorDefectoTPV("bdoffline"))
  {
    return true;
  }
  if (!this.iface.__beforeCommit_tpv_pagoscomanda(curPago))
  {
    return false;
  }
  return true;
}

function offline_init()
{
  debug("offline_init");
  this.iface.__init();
  this.iface.comprobarSincroCatalogo();
}

function offline_comprobarSincroCatalogo()
{
  debug("offline_comprobarSincroCatalogo");
  var util: FLUtil = new FLUtil();

  var codTerminal: String = util.readSettingEntry("scripts/fltpv_ppal/codTerminal");
  debug("offline_comprobarSincroCatalogo codTerminal" + codTerminal);
  var codTienda: String = util.sqlSelect("tpv_puntosventa", "codtienda", "codtpv_puntoventa ='" + codTerminal + "'");
  debug("offline_comprobarSincroCatalogo codTienda" + codTienda);
  if (!codTienda || codTienda == "") {
    debug(0);
    return;
  }
  var curTienda: FLSqlCursor = new FLSqlCursor("tpv_tiendas");
  curTienda.select("codtienda = '" + codTienda + "'");
  if (!curTienda.first()) {
    debug(1);
    return;
  }
  var sincroCatAuto: Boolean = curTienda.valueBuffer("sincrocatauto");
  if (!sincroCatAuto) {
    debug(2);
    return;
  }
  var ultSincroCat: Date = curTienda.valueBuffer("ultsincrocat");
  debug("offline_comprobarSincroCatalogo ultSincroCat " + ultSincroCat);
  var hoy: Date = new Date();
  if (!ultSincroCat || util.daysTo(ultSincroCat, hoy) > 0) {
    var ret: Number = MessageBox.information(util.translate("scripts", "La tienda %1 no está sincronizada ¿Desea sincronizarla ahora?").arg(codTienda), MessageBox.Yes, MessageBox.No);
    if (ret != MessageBox.Yes) {
      return false;
    }
  } else {
    return;
  }
  if (!formtpv_tiendas.iface.pub_sincroCatalogo(curTienda)) {
    return false;
  }

  curTienda.setModeAccess(curTienda.Edit);
  curTienda.refreshBuffer();
  curTienda.setValueBuffer("ultsincrocat", hoy.toString());
  if (!curTienda.commitBuffer()) {
    return;
  }
}
//// TPV OFF LINE////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
