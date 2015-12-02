
/** @class_declaration puntosTpv */
//////////////////////////////////////////////////////////////////
//// PUNTOSTPV ///////////////////////////////////////////////////
class puntosTpv extends ivaIncluido
{
  function puntosTpv(context)
  {
    ivaIncluido(context);
  }

  function afterCommit_tpv_comandas(curComanda)
  {
    return this.ctx.puntosTpv_afterCommit_tpv_comandas(curComanda);
  }
  function afterCommit_tpv_pagoscomanda(curPago)
  {
    return this.ctx.puntosTpv_afterCommit_tpv_pagoscomanda(curPago);
  }
  function afterCommit_tpv_movpuntos(curComanda)
  {
    return this.ctx.puntosTpv_afterCommit_tpv_movpuntos(curComanda);
  }
  function afterCommit_tpv_movpuntosnosinc(curMP)
  {
    return this.ctx.puntosTpv_afterCommit_tpv_movpuntosnosinc(curMP);
  }
  function gestionPuntos(curComanda)
  {
    return this.ctx.puntosTpv_gestionPuntos(curComanda);
  }
  function asignaPuntosComanda(curComanda)
  {
    return this.ctx.puntosTpv_asignaPuntosComanda(curComanda);
  }
  function calculaPuntosComanda(curComanda)
  {
    return this.ctx.puntosTpv_calculaPuntosComanda(curComanda);
  }
  function quitaPuntosComanda(curComanda)
  {
    return this.ctx.puntosTpv_quitaPuntosComanda(curComanda);
  }
  function gestionPuntosPago(curPago)
  {
    return this.ctx.puntosTpv_gestionPuntosPago(curPago);
  }
  function asignaPuntosPago(curPago)
  {
    return this.ctx.puntosTpv_asignaPuntosPago(curPago);
  }
  function quitaPuntosPago(curPago)
  {
    return this.ctx.puntosTpv_quitaPuntosPago(curPago);
  }
  function totalizarPuntos(curComanda)
  {
    return this.ctx.puntosTpv_totalizarPuntos(curComanda);
  }
  function beforeCommit_tpv_tarjetaspuntos(curTP)
  {
    return this.ctx.puntosTpv_beforeCommit_tpv_tarjetaspuntos(curTP);
  }
  function dameTablaPuntos()
  {
    return this.ctx.puntosTpv_dameTablaPuntos();
  }
  function controlDevolEfectivo(curPago)
  {
    return this.ctx.puntosTpv_controlDevolEfectivo(curPago);
  }
  function totalizaPagosArqueo(codArqueo, codPago)
  {
    return this.ctx.puntosTpv_totalizaPagosArqueo(codArqueo, codPago);
  }
}
//// PUNTOSTPV ///////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////


/** @class_declaration pubPuntosTpv */
/////////////////////////////////////////////////////////////////
//// PUB PUNTOS TPV /////////////////////////////////////////////
class pubPuntosTpv extends ifaceCtx
{
  function pubPuntosTpv(context)
  {
    ifaceCtx(context);
  }
  function pub_ejecutarQry(tabla, campos, where, listaTablas)
  {
    return this.ejecutarQry(tabla, campos, where, listaTablas);
  }
  function pub_dameTablaPuntos()
  {
    return this.dameTablaPuntos();
  }
  function pub_gestionPuntos(curComanda)
  {
    return this.gestionPuntos(curComanda);
  }
  function pub_calculaPuntosComanda(curComanda)
  {
    return this.calculaPuntosComanda(curComanda);
  }
  function pub_gestionPuntosPago(curP)
  {
    return this.gestionPuntosPago(curP);
  }
}
//// PUB PUNTOS TPV /////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition puntosTpv */
/////////////////////////////////////////////////////////////////
//// PUNTOS TPV /////////////////////////////////////////////////

function puntosTpv_afterCommit_tpv_comandas(curComanda)
{

  var _i = this.iface;

  if (!_i.__afterCommit_tpv_comandas(curComanda)) {
    return false;
  }

  if (curComanda.valueBuffer("estado") == "Cerrada") {
    if (!_i.gestionPuntos(curComanda)) {
      return false;
    }
  }
  return true;
}

function puntosTpv_afterCommit_tpv_pagoscomanda(curPago)
{

  var _i = this.iface;
  if (!_i.__afterCommit_tpv_pagoscomanda(curPago)) {
    return false;
  }
  if (!_i.gestionPuntosPago(curPago)) {
    return false;
  }
  return true;
}

function puntosTpv_afterCommit_tpv_movpuntos(curMP)
{

  var _i = this.iface;

  if (!_i.totalizarPuntos(curMP)) {
    return false;
  }
  return true;
}

function puntosTpv_afterCommit_tpv_movpuntosnosinc(curMP)
{
  var _i = this.iface;

  if (!_i.totalizarPuntos(curMP)) {
    return false;
  }
  return true;
}

function puntosTpv_gestionPuntos(curComanda)
{
  if (!flfactalma.iface.pub_valorDefectoAlmacen("programapuntos")) {
    return true;
  }

  var _i = this.iface;
  switch (curComanda.modeAccess()) {
    case curComanda.Insert: {
      if (!_i.asignaPuntosComanda(curComanda)) {
        return false;
      }
      break;
    }
    case curComanda.Edit: {
      if (!_i.quitaPuntosComanda(curComanda)) {
        return false;
      }
      if (!_i.asignaPuntosComanda(curComanda)) {
        return false;
      }
      break;
    }
    case curComanda.Del: {
      if (!_i.quitaPuntosComanda(curComanda)) {
        return false;
      }
      break;
    }
  }

  return true;
}

function puntosTpv_gestionPuntosPago(curPago)
{
  var _i = this.iface;

  switch (curPago.modeAccess()) {
    case curPago.Insert: {
      if (!_i.asignaPuntosPago(curPago)) {
        return false;
      }
      break;
    }
    case curPago.Edit: {
      if (!_i.quitaPuntosPago(curPago)) {
        return false;
      }
      if (!_i.asignaPuntosPago(curPago)) {
        return false;
      }
      break;
    }
    case curPago.Del: {
      if (!_i.quitaPuntosPago(curPago)) {
        return false;
      }
      break;
    }
  }

  return true;
}

function puntosTpv_asignaPuntosComanda(curComanda)
{
  var _i = this.iface;

  var codTarjetaPuntos = curComanda.valueBuffer("codtarjetapuntos");
  if (codTarjetaPuntos) {
    var canPuntos = _i.calculaPuntosComanda(curComanda);

    var tablaPuntos = _i.dameTablaPuntos();
    var curMovPuntos = new FLSqlCursor(tablaPuntos);
    curMovPuntos.setModeAccess(curMovPuntos.Insert);
    curMovPuntos.refreshBuffer();
    curMovPuntos.setValueBuffer("codtarjetapuntos", curComanda.valueBuffer("codtarjetapuntos"));
    curMovPuntos.setValueBuffer("idtpv_comanda", curComanda.valueBuffer("idtpv_comanda"));
    curMovPuntos.setValueBuffer("fecha",  curComanda.valueBuffer("fecha"));
    curMovPuntos.setValueBuffer("canpuntos", canPuntos);

    if (!curMovPuntos.commitBuffer()) {
      return false;
    }
  }
  return true;
}

function puntosTpv_calculaPuntosComanda(curComanda)
{
  var _i = this.iface;
  var canPuntos = 0;

  var codTarjetaPuntos = curComanda.valueBuffer("codtarjetapuntos");
  if (!AQUtil.sqlSelect("tpv_tarjetaspuntos", "activa", "codtarjetapuntos = '" + codTarjetaPuntos + "'")) {
    return canPuntos;
  }

  canPuntos = AQUtil.sqlSelect("tpv_lineascomanda", "SUM(canpuntos)", "idtpv_comanda = " + curComanda.valueBuffer("idtpv_comanda"));

  /**var qL = new FLSqlQuery();
  qL.setSelect("referencia, pvptotaliva");
  qL.setFrom("tpv_lineascomanda");
  qL.setWhere("idtpv_comanda = '"+ curComanda.valueBuffer("idtpv_comanda") +"'");
  qL.setForwardOnly(true);
  if (!qL.exec()) {
    return canPuntos;
  }

  var puntosEspeciales;
  var valorPuntoArticulo;
  var valorPuntoGeneral =  flfactalma.iface.pub_valorDefectoAlmacen("valorpuntos");

  while (qL.next()) {
    puntosEspeciales = AQUtil.sqlSelect("articulos", "programapuntosespeciales", "referencia = '" + qL.value("referencia") + "' AND programapuntosespeciales");
    if (puntosEspeciales) {
      valorPuntoArticulo = AQUtil.sqlSelect("articulos", "valorpuntosespeciales", "referencia = '" + qL.vaplue("referencia") + "'");
    } else {
      valorPuntoArticulo = valorPuntoGeneral;
    }
    if(qL.value("pvptotaliva") > 0){
      canPuntos = canPuntos + (valorPuntoArticulo * Math.floor(qL.value("pvptotaliva")));
    }
    else{
      canPuntos = canPuntos + (valorPuntoArticulo * Math.ceil(qL.value("pvptotaliva")));
    }
  }*/
  return canPuntos;
}

function puntosTpv_quitaPuntosComanda(curComanda)
{
  var _i = this.iface;
  var tablaPuntos = _i.dameTablaPuntos();

  var codTarjetaPuntos = curComanda.valueBuffer("codtarjetapuntos");
  if (codTarjetaPuntos) {
    if (!AQUtil.sqlSelect("tpv_tarjetaspuntos", "activa", "codtarjetapuntos = '" + codTarjetaPuntos + "'")) {
      return true;
    }
    var curMovPuntos = new FLSqlCursor(tablaPuntos);
    curMovPuntos.select("idtpv_comanda = " + curComanda.valueBuffer("idtpv_comanda"));
    while (curMovPuntos.next()) {
      curMovPuntos.setModeAccess(curMovPuntos.Del);
      curMovPuntos.refreshBuffer();

      if (!curMovPuntos.commitBuffer()) {
        debug("puntosTpv_quitaPuntosComanda false");
        return false;
      }
    }
  }
  return true;
}

function puntosTpv_dameTablaPuntos()
{
  var mgr = aqApp.db().manager();
  var mtd = mgr.metadata("tpv_datosgenerales");
  var mtdTS = mtd.field("tiendasincro");
  var tiendaSincro;
  if (mtdTS) {
    tiendaSincro = flfact_tpv.iface.pub_valorDefectoTPV("tiendasincro");
  } else {
    tiendaSincro = false;
  }
  var tP = tiendaSincro ? "tpv_movpuntosnosinc" : "tpv_movpuntos";
  return tP;
}

function puntosTpv_asignaPuntosPago(curPago)
{
  var _i = this.iface;

  var codTarjetaPuntos = curPago.valueBuffer("codtarjetapuntos");
  if (!codTarjetaPuntos || codTarjetaPuntos == "") {
    return true;
  }

  var tablaPuntos = _i.dameTablaPuntos();
  var pagoPuntos = AQUtil.sqlSelect("tpv_datosgenerales", "pagopunto", "1=1");
  if (!pagoPuntos || pagoPuntos == "") {
    return true;
  }

  if (pagoPuntos != curPago.valueBuffer("codpago")) {
    return true;
  }
  if (codTarjetaPuntos && codTarjetaPuntos != "") {
    if (!AQUtil.sqlSelect("tpv_tarjetaspuntos", "activa", "codtarjetapuntos = '" + codTarjetaPuntos + "'")) {
      return true;
    }
    canPuntos = curPago.valueBuffer("importe") * -1;
    var valorPuntosEuro = AQUtil.sqlSelect("factalma_general", "valoreuros", "1=1");
    valorPuntosEuro = isNaN(valorPuntosEuro) ? 0 : valorPuntosEuro;
    canPuntos = canPuntos * valorPuntosEuro;

    var curMovPuntos = new FLSqlCursor(tablaPuntos);
    curMovPuntos.setModeAccess(curMovPuntos.Insert);
    curMovPuntos.refreshBuffer();
    curMovPuntos.setValueBuffer("codtarjetapuntos", codTarjetaPuntos);
    curMovPuntos.setValueBuffer("idpago", curPago.valueBuffer("idpago"));
    curMovPuntos.setValueBuffer("fecha",  curPago.valueBuffer("fecha"));
    curMovPuntos.setValueBuffer("canpuntos", canPuntos);

    if (!curMovPuntos.commitBuffer()) {
      debug("puntosTpv_asignaPuntosPago false");
      return false;
    }
  }
  return true;
}

function puntosTpv_quitaPuntosPago(curPago)
{
  debug("puntosTpv_quitaPuntosPago");
  var _i = this.iface;

  var tablaPuntos = _i.dameTablaPuntos();
  var curMovPuntos = new FLSqlCursor(tablaPuntos);
  curMovPuntos.select("idpago = " + curPago.valueBuffer("idpago"));
  while (curMovPuntos.next()) {
    curMovPuntos.setModeAccess(curMovPuntos.Del);
    curMovPuntos.refreshBuffer();

    if (!curMovPuntos.commitBuffer()) {
      return false;
    }
  }
  return true;
}

function puntosTpv_totalizarPuntos(curMP)
{
  var _i = this.iface;

  var curTarjeta = new FLSqlCursor("tpv_tarjetaspuntos");
  curTarjeta.select("codtarjetapuntos = '" + curMP.valueBuffer("codtarjetapuntos") + "'");
  if (!curTarjeta.first()) {
    return false;
  }
  curTarjeta.setModeAccess(curTarjeta.Edit);
  curTarjeta.refreshBuffer();
  var saldoPuntos = formRecordtpv_tarjetaspuntos.iface.pub_commonCalculateField("saldopuntos", curTarjeta);
  curTarjeta.setValueBuffer("saldopuntos", saldoPuntos);
  var tablaPuntos = _i.dameTablaPuntos();
  if (tablaPuntos == "tpv_movpuntos") {
    curTarjeta.setValueBuffer("saldopuntossinc", saldoPuntos);
  }
  if (!curTarjeta.commitBuffer()) {
    return false;
  }
  return true;
}

function puntosTpv_beforeCommit_tpv_tarjetaspuntos(curTP)
{
  var _i = this.iface;

  if (!_i.controlDatosMod(curTP)) {
    return false;
  }

  return true;
}

function puntosTpv_controlDevolEfectivo(curPago)
{
  var _i = this.iface;

  if (!_i.__controlDevolEfectivo(curPago)) {
    return false;
  }

  var codPago = curPago.valueBuffer("codpago");
  var codPagoPuntos = flfact_tpv.iface.pub_valorDefectoTPV("pagopunto");
  if (!codPagoPuntos || codPagoPuntos == "") {
    MessageBox.information(sys.translate("No tiene configurada la forma de pago con puntos en el formulario de datos generales"), MessageBox.Ok, MessageBox.NoButton);
  }
  if (codPago == codPagoPuntos) {
    return true;
  }
  return true;
}

function puntosTpv_totalizaPagosArqueo(codArqueo, codPago)
{
  var _i = this.iface;
  if (!_i.codPagosTPV_) {
    _i.codPagosTPV_ = new Object;
    _i.codPagosTPV_[_i.valorDefectoTPV("pagoefectivo")] = "pagosefectivo";
    _i.codPagosTPV_[_i.valorDefectoTPV("pagotarjeta")] = "pagostarjeta";
    _i.codPagosTPV_[_i.valorDefectoTPV("pagovale")] = "pagosvale";
    _i.codPagosTPV_[_i.valorDefectoTPV("pagopunto")] = "pagospuntos";
  }
  if (!_i.__totalizaPagosArqueo(codArqueo, codPago)) {
    return false;
  }
  return true;
}

//// PUNTOS TPV /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

