
/** @class_declaration pagaresMultipago */
/////////////////////////////////////////////////////////////////
//// PAGARES MULTIPAGO  /////////////////////////////////////////
class pagaresMultipago extends pagareProv
{
  function pagaresMultipago(context)
  {
    pagareProv(context);
  }

  function beforeCommit_pagospagareprov(curPD)
  {
    return this.ctx.pagaresMultipago_beforeCommit_pagospagareprov(curPD);
  }
  function beforeCommit_pagosdevolprov(curPD)
  {
    return this.ctx.pagaresMultipago_beforeCommit_pagosdevolprov(curPD);
  }
  function dameHaberPartidasBancoPagProv(curPD, pagare)
  {
    return this.ctx.pagaresMultipago_dameHaberPartidasBancoPagProv(curPD, pagare);
  }
  function dameDebePartidasPtePagProv(curPD, pagare)
  {
    return this.ctx.pagaresMultipago_dameDebePartidasPtePagProv(curPD, pagare);
  }
  function controlarCantidadDebe(curPD, debe, pagare)
  {
    return this.ctx.pagaresMultipago_controlarCantidadDebe(curPD, debe, pagare);
  }
  function cambiaUltimoPagoPagProv(idPagare, idPagoDevol, unlock)
  {
    return this.ctx.pagaresMultipago_cambiaUltimoPagoPagProv(idPagare, idPagoDevol, unlock);
  }
}
//// PAGARES MULTIPAGO  /////////////////////////////////////////
/////////////////////////////////////////////////////////////////


/** @class_definition pagaresMultipago */
/////////////////////////////////////////////////////////////////
//// PAGARES MULTIPAGO //////////////////////////////////////////

function pagaresMultipago_beforeCommit_pagosdevolprov(curPD)
{
  var _i = this.iface;

  if (sys.isLoadedModule("flcontppal") && AQUtil.sqlSelect("empresa", "contintegrada", "1 = 1") && !curPD.valueBuffer("nogenerarasiento") && curPD.valueBuffer("tipo") == "Pago" && curPD.valueBuffer("estado") == "Pendiente") {
    return true;
  }

  return _i.__beforeCommit_pagosdevolprov(curPD);
}

function pagaresMultipago_beforeCommit_pagospagareprov(curPD)
{
  var _i = this.iface;

  if (sys.isLoadedModule("flcontppal") && AQUtil.sqlSelect("empresa", "contintegrada", "1 = 1") && !curPD.valueBuffer("nogenerarasiento") && curPD.valueBuffer("tipo") == "Pago" && curPD.valueBuffer("estado") == "Pendiente") {
    return true;
  }

  return _i.__beforeCommit_pagospagareprov(curPD);
}

function pagaresMultipago_dameHaberPartidasBancoPagProv(curPD, pagare)
{
  return curPD.valueBuffer("importe");
}

function pagaresMultipago_dameDebePartidasPtePagProv(curPD, pagare)
{
  return curPD.valueBuffer("importe");
}

function pagaresMultipago_controlarCantidadDebe(curPD, debe, pagare)
{
  var _i = this.iface;

  var idPagareProv = curPD.valueBuffer("idpagare");

  var sumPago = AQUtil.sqlSelect("pagospagareprov", "SUM(importe)", "tipo = 'Pago' AND idpagare = '" + idPagareProv + "'");

  if (curPD.modeAccess == curPD.Insert) {
    sumPago = parseFloat(sumPago) + parseFloat(debe);
  }

  var sumDevolucion = AQUtil.sqlSelect("pagospagareprov", "SUM(importe)", "tipo = 'Devolución' AND idpagare = '" + idPagareProv + "'");
  debe = parseFloat(sumPago) - parseFloat(sumDevolucion);

  if (parseFloat(debe) > parseFloat(pagare.total)) {
    MessageBox.warning(sys.translate("Error: La suma de pagos de los recibos en el pagaré (%1) - la suma de las devoluciones (%2)\nno coincide con el total del pagaré (%3)").arg(AQUtil.roundFieldValue(sumPago, "co_partidas", "debe")).arg(AQUtil.roundFieldValue(sumDevolucion, "co_partidas", "debe")).arg(AQUtil.roundFieldValue(pagare.total, "co_partidas", "debe")), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  return true;
}

function pagaresMultipago_cambiaUltimoPagoPagProv(idPagare, idPagoDevol, unlock)
{
  var curPagosDevol = new FLSqlCursor("pagospagareprov");
  curPagosDevol.select("idpagare = " + idPagare + " AND idpagodevol <> " + idPagoDevol + " ORDER BY fecha, idpagodevol");
  if (curPagosDevol.last()) {
    curPagosDevol.setUnLock("editable", true);
  }
  return true;
}
//// PAGARES MULTIPAGO //////////////////////////////////////////
/////////////////////////////////////////////////////////////////
