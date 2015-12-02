
/** @class_declaration pedMarco */
/////////////////////////////////////////////////////////////////
//// PEDIDOS MARCO //////////////////////////////////////////////
class pedMarco extends oficial
{
  function pedMarco(context)
  {
    oficial(context);
  }
  function afterCommit_lineaspedidoscli(curL)
  {
    return this.ctx.pedMarco_afterCommit_lineaspedidoscli(curL);
  }
  function controlPedidoMarco(curL)
  {
    return this.ctx.pedMarco_controlPedidoMarco(curL);
  }
  function actualizaLineaPedidoMarco(idLineaPM)
  {
    return this.ctx.pedMarco_actualizaLineaPedidoMarco(idLineaPM);
  }
  function actualizaPedidoMarco(curL)
  {
    return this.ctx.pedMarco_actualizaPedidoMarco(curL);
  }
}
//// PEDIDOS MARCO //////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition pedMarco */
/////////////////////////////////////////////////////////////////
//// PEDIDOS MARCO //////////////////////////////////////////////
function pedMarco_afterCommit_lineaspedidoscli(curL)
{
  var _i = this.iface;
  if (!_i.__afterCommit_lineaspedidoscli(curL)) {
    return false;
  }
  if (!_i.controlPedidoMarco(curL)) {
    return false;
  }
  return true;
}

function pedMarco_controlPedidoMarco(curL)
{
  var _i = this.iface;
  var idLineaPM = curL.valueBuffer("idlineapedidomarco");
  idLineaPM = isNaN(idLineaPM) ? 0 : idLineaPM;

  if (idLineaPM) {
    if (!_i.actualizaLineaPedidoMarco(idLineaPM)) {
      return false;
    }
  }
  switch (curL.modeAccess()) {
    case curL.Edit: {
      var idLineaPMPrevia = curL.valueBufferCopy("idlineapedidomarco");
      idLineaPMPrevia = isNaN(idLineaPMPrevia) ? 0 : idLineaPMPrevia;
      if (idLineaPM) {
        if (!_i.actualizaLineaPedidoMarco(idLineaPM)) {
          return false;
        }
      }
      break;
    }
  }
  return true;
}

function pedMarco_actualizaLineaPedidoMarco(idLineaPM)
{
  var _i = this.iface;
  var curL = new FLSqlCursor("lineaspedidomarcocli");
  curL.select("idlinea = " + idLineaPM);
  if (!curL.first()) {
    return false;
  }
  var _iLPM = formRecordlineaspedidomarcocli.iface;
  curL.setModeAccess(curL.Edit);
  curL.refreshBuffer();
  var codPM = curL.valueBuffer("codpedidomarco");
  curL.setValueBuffer("canpedida", _iLPM.pub_commonCalculateField("canpedida", curL));
  curL.setValueBuffer("canpendiente", _iLPM.pub_commonCalculateField("canpendiente", curL));
  curL.setValueBuffer("importepedido", _iLPM.pub_commonCalculateField("importepedido", curL));
  curL.setValueBuffer("importependiente", _iLPM.pub_commonCalculateField("importependiente", curL));
  if (!curL.commitBuffer()) {
    return false;
  }
  if (!_i.actualizaPedidoMarco(codPM)) {
    return false;
  }
  return true;
}

function pedMarco_actualizaPedidoMarco(codPM)
{
  var _i = this.iface;
  var curPM = new FLSqlCursor("pedidosmarcocli");
  curPM.select("codpedidomarco = '" + codPM + "'");
  if (!curPM.first()) {
    return false;
  }
  var _iPM = formRecordpedidosmarcocli.iface;
  curPM.setModeAccess(curPM.Edit);
  curPM.refreshBuffer();
  curPM.setValueBuffer("totalpedido", _iPM.pub_commonCalculateField("totalpedido", curPM));
  curPM.setValueBuffer("totalpendiente", _iPM.pub_commonCalculateField("totalpendiente", curPM));
  if (!curPM.commitBuffer()) {
    return false;
  }
  return true;
}
//// PEDIDOS MARCO //////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
