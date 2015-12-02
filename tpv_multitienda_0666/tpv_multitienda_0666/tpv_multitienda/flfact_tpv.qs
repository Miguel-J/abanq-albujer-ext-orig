
/** @class_declaration multi */
/////////////////////////////////////////////////////////////////
//// MULTI TIENDA////////////////////////////////////////////////
class multi extends oficial
{
  var costeAcT_, totalAcT_;
  function multi(context)
  {
    oficial(context);
  }
  function obtenerSerieFactura(curComanda: String): String {
    return this.ctx.multi_obtenerSerieFactura(curComanda);
  }
  function iniciarTotalesTienda(nodo, campo)
  {
    return this.ctx.multi_iniciarTotalesTienda(nodo, campo);
  }
  function calcularBeneficio(nodo, campo)
  {
    return this.ctx.multi_calcularBeneficio(nodo, campo);
  }
  function mostrarTotalesTienda(nodo, campo)
  {
    return this.ctx.multi_mostrarTotalesTienda(nodo, campo);
  }
  function afterCommit_tpv_lineasmultitransstock(curL)
  {
    return this.ctx.multi_afterCommit_tpv_lineasmultitransstock(curL);
  }
  function beforeCommit_tpv_lineasmultitransstock(curL)
  {
    return this.ctx.multi_beforeCommit_tpv_lineasmultitransstock(curL);
  }
  function comprobarViaje(curL)
  {
    return this.ctx.multi_comprobarViaje(curL);
  }
  function controlFechasEnvioRx(curL)
  {
    return this.ctx.multi_controlFechasEnvioRx(curL);
  }
  function totalizarViaje(codMulti, idVM)
  {
    return this.ctx.multi_totalizarViaje(codMulti, idVM);
  }
  function tiendaActual()
  {
    return this.ctx.multi_tiendaActual();
  }
  function almacenActual()
  {
    return this.ctx.multi_almacenActual();
  }
  function esBDLocal()
  {
    return this.ctx.multi_esBDLocal();
  }
  function obtenerAgenteRecepcionesCerradas(cursor)
  {
    return this.ctx.multi_obtenerAgenteRecepcionesCerradas(cursor);
  }
}
//// MULTI TIENDA////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pubMulti */
/////////////////////////////////////////////////////////////////
//// PUB MULTITIENDA ////////////////////////////////////////////
class pubMulti extends ifaceCtx
{
  function pubMulti(context)
  {
    ifaceCtx(context);
  }
  function pub_iniciarTotalesTienda(nodo, campo)
  {
    return this.iniciarTotalesTienda(nodo, campo);
  }
  function pub_mostrarTotalesTienda(nodo, campo)
  {
    return this.mostrarTotalesTienda(nodo, campo);
  }
  function pub_tiendaActual()
  {
    return this.tiendaActual();
  }
  function pub_comprobarViaje(curL)
  {
    return this.comprobarViaje(curL);
  }
  function pub_almacenActual()
  {
    return this.almacenActual();
  }
  function pub_obtenerAgenteRecepcionesCerradas(cursor)
  {
    return this.obtenerAgenteRecepcionesCerradas(cursor);
  }
}
//// PUB MULTITIENDA ////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition multi */
/////////////////////////////////////////////////////////////////
//// MULTI TIENDA ///////////////////////////////////////////////
function multi_obtenerSerieFactura(curComanda: String): String {
  var util: FLUtil = new FLUtil;
  var codSerie: String = util.sqlSelect("tpv_puntosventa pv INNER JOIN tpv_tiendas t ON pv.codtienda = t.codtienda", "t.codserie", "pv.codtpv_puntoventa = '" + curComanda.valueBuffer("codtpv_puntoventa") + "'", "tpv_puntosventa,tpv_tiendas");
  if (!codSerie)
  {
    codSerie = this.iface.__obtenerSerieFactura(curComanda);
  }
  return codSerie;
}

function multi_iniciarTotalesTienda(nodo, campo)
{
  this.iface.costeAcT_ = 0;
  this.iface.totalAcT_ = 0;
}

function multi_calcularBeneficio(nodo, campo)
{
  var _i = this.iface;
  var valor;
  var coste = parseFloat(nodo.attributeValue("tpv_lineascomanda.cantidad * tpv_lineascomanda.costeunitario"));
  coste = isNaN(coste) ? 0 : coste;
  var venta = parseFloat(nodo.attributeValue("tpv_lineascomanda.pvptotal"));
  coste = isNaN(coste) ? 0 : coste;
  _i.costeAcT_ += coste;
  _i.totalAcT_ += venta;

  valor = _i.__calcularBeneficio(nodo, campo);
  return valor;
}

function multi_mostrarTotalesTienda(nodo, campo)
{
  var _i = this.iface;
  var valor;
  switch (campo) {
    case "coste": {
      valor = _i.costeAcT_;
      break;
    }
    case "total": {
      valor = _i.totalAcT_;
      break;
    }
    case "beneficio": {
      valor = _i.totalAcT_ - _i.costeAcT_;
      break;
    }
    case "porbeneficio": {
      if (_i.costeAcT_ == 0) {
        valor =  100;
      } else {
        valor = ((_i.totalAcT_ - _i.costeAcT_) / _i.costeAcT_) * 100;
      }
      if (!valor || isNaN(valor)) {
        valor = 0;
      }
      break;
    }
  }
  return valor;
}

function multi_afterCommit_tpv_lineasmultitransstock(curL)
{
  var _i = this.iface;
  if (!_i.comprobarViaje(curL)) {
    return false;
  }
  if (!flfactalma.iface.pub_controlStockMultitrans(curL)) {
    return false;
  }
  return true;
}

function multi_beforeCommit_tpv_lineasmultitransstock(curL)
{
  var _i = this.iface;
  if (!_i.controlFechasEnvioRx(curL)) {
    return false;
  }
  if (!flfactalma.iface.pub_controlStockBCMultitrans(curL)) {
    return false;
  }
  return true;
}

function multi_controlFechasEnvioRx(curL)
{
  switch (curL.modeAccess()) {
    case curL.Insert:
    case curL.Edit: {
      var exTienda1 = curL.valueBufferCopy("extienda");
      var exTienda2 = curL.valueBuffer("extienda");
      var exCentral1 = curL.valueBufferCopy("excentral");
      var exCentral2 = curL.valueBuffer("excentral");
      if ((exTienda2 == "OK" && exTienda2 != exTienda1) || (exCentral2 == "OK" && exCentral2 != exCentral1)) {
        var ahora = (new Date).toString();
        curL.setValueBuffer("fechaex", ahora.left(10));
        curL.setValueBuffer("horaex", ahora.right(8));
      } else if ((exTienda2 != "OK" && exTienda2 != exTienda1) || (exCentral2 != "OK" && exCentral2 != exCentral1)) {
        curL.setNull("fechaex");
        curL.setNull("horaex");
      }
      var rxTienda1 = curL.valueBufferCopy("rxtienda");
      var rxTienda2 = curL.valueBuffer("rxtienda");
      var rxCentral1 = curL.valueBufferCopy("rxcentral");
      var rxCentral2 = curL.valueBuffer("rxcentral");
      if ((rxTienda2 == "OK" && rxTienda2 != rxTienda1) || (rxCentral2 == "OK" && rxCentral2 != rxCentral1)) {
        var ahora = (new Date).toString();
        curL.setValueBuffer("fecharx", ahora.left(10));
        curL.setValueBuffer("horarx", ahora.right(8));
      } else if ((rxTienda2 != "OK" && rxTienda2 != rxTienda1) || (rxCentral2 != "OK" && rxCentral2 != rxCentral1)) {
        curL.setNull("fecharx");
        curL.setNull("horarx");
      }
      break;
    }
  }
  return true;
}

function multi_comprobarViaje(curL)
{
  var _i = this.iface;
  var idViajeMulti = curL.valueBuffer("idviajemultitrans");
  if (!idViajeMulti) {
    return true;
  }
  var codMulti = curL.valueBuffer("codmultitransstock");
  switch (curL.modeAccess()) {
    case curL.Del: {
      if (!AQUtil.sqlSelect("tpv_lineasmultitransstock", "idlinea", "codmultitransstock = '" + codMulti + "' AND idviajemultitrans = '" + idViajeMulti + "'")) {
        if (!AQSql.del("tpv_viajesmultitransstock", "idviajemultitrans = '" + idViajeMulti + "'")) {
          return false;
        }
      } else {
        if (!_i.totalizarViaje(codMulti, idViajeMulti)) {
          return false;
        }
      }
      break;
    }
    default: {
      if (!_i.totalizarViaje(codMulti, idViajeMulti)) {
        return false;
      }
      break;
    }
  }

  return true;
}

function multi_totalizarViaje(codMulti, idVM)
{
  debug("multi_totalizarViaje");
  var canTotal = 0;

  var q = new FLSqlQuery;
  q.setSelect("l.cantidad, l.estado");
  q.setFrom("tpv_lineasmultitransstock l INNER JOIN articulos a ON l.referencia = a.referencia");
  q.setWhere("l.idviajemultitrans = '" + idVM + "'");
  q.setForwardOnly(true);
  if (!q.exec()) {
    return false;
  }
  var estadoV = "RECIBIDO";
  var estadoL;

  var totalLineas = q.size();
  var canceladas = 0;

  while (q.next()) {
    // debug("sumando " + q.value("l.cantidad"));
    canTotal += parseFloat(q.value("l.cantidad"));
    // debug("canTotal " + canTotal);
    estadoL = q.value("l.estado");
    switch (estadoL) {
      case "CANCELADO": {
        canceladas++;
        break;
      }
      case "RECIBIDO": {
        break;
      }
      case "RECIBIDO PARCIAL": {
        if (estadoV == "RECIBIDO") {
          estadoV = estadoL;
        }
        break;
      }
      case "EN TRANSITO": {
        if (estadoV == "RECIBIDO" || estadoV == "RECIBIDO PARCIAL") {
          estadoV = estadoL;
        }
        break;
      }
      case "ENVIADO PARCIAL": {
        if (estadoV == "RECIBIDO" || estadoV == "RECIBIDO PARCIAL" || estadoV == "EN TRANSITO") {
          estadoV = estadoL;
        }
        break;
      }
      case "PTE ENVIO": {
        if (estadoV == "RECIBIDO" || estadoV == "RECIBIDO PARCIAL" || estadoV == "EN TRANSITO" || estadoV == "ENVIADO PARCIAL") {
          estadoV = estadoL;
        }
        break;
      }
    }
  }

  if (canceladas == totalLineas)
    estadoV = "CANCELADO";

  var curViaje = new FLSqlCursor("tpv_viajesmultitransstock");
  curViaje.select("idviajemultitrans = '" + idVM + "'");
  if (!curViaje.first()) {
    return false;
  }
  curViaje.setModeAccess(curViaje.Edit);
  curViaje.refreshBuffer();
  curViaje.setValueBuffer("cantidad", canTotal);
  curViaje.setValueBuffer("estado", estadoV);
  if (!curViaje.commitBuffer()) {
    return false;
  }
  return true;
}

function multi_tiendaActual()
{
  var codTerminal = flfact_tpv.iface.pub_valorDefectoTPV("codterminal");
  var codTienda = AQUtil.sqlSelect("tpv_puntosventa", "codtienda", "codtpv_puntoventa ='" + codTerminal + "'");
  return codTienda;
}

function multi_almacenActual()
{
  var _i = this.iface;
  var codAlmacen = "";

  var codTerminal = flfact_tpv.iface.pub_valorDefectoTPV("codterminal");
  if (codTerminal && AQUtil.sqlSelect("tpv_puntosventa", "codtpv_puntoventa", "codtpv_puntoventa ='" + codTerminal + "'")) {
    codAlmacen = AQUtil.sqlSelect("tpv_puntosventa", "codalmacen", "codtpv_puntoventa = '" + codTerminal + "'");
  }
  if (!codAlmacen || codAlmacen == "") {
    codAlmacen = false;
  }

  return codAlmacen;
}

function multi_esBDLocal()
{
  var _i = this.iface;
  return _i.valorDefectoTPV("tiendasincro");
}

function multi_obtenerAgenteRecepcionesCerradas(cursor)
{
  return formRecordtpv_recepcionestx.iface.pub_commonCalculateField("codagenterx", cursor);
}
//// MULTI TIENDA ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
