
/** @class_declaration multitienda */
/////////////////////////////////////////////////////////////////
//// MULTITIENDA ////////////////////////////////////////////
class multitienda extends oficial
{
  function multitienda(context)
  {
    oficial(context);
  }
  function afterCommit_lineaspedidoscli(curLP)
  {
    return this.ctx.multitienda_afterCommit_lineaspedidoscli(curLP);
  }
  function afterCommit_lineaspedidosprov(curLP)
  {
    return this.ctx.multitienda_afterCommit_lineaspedidosprov(curLP);
  }
  function actualizarCantidadesTransStock(curLinea)
  {
    return this.ctx.multitienda_actualizarCantidadesTransStock(curLinea);
  }
}
//// MULTITIENDA ////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition multitienda */
/////////////////////////////////////////////////////////////////
//// MULTITIENDA ////////////////////////////////////////////
function multitienda_afterCommit_lineaspedidoscli(curLP)
{
  var _i = this.iface;
  if (!_i.__afterCommit_lineaspedidoscli(curLP))
    return false;

  var idMultiTc = curLP.valueBuffer("idlineamultitc");

  if (idMultiTc && idMultiTc != 0) {
    if (!_i.actualizarCantidadesTransStock(curLP))
      return false;
  }

  return true;
}

function multitienda_afterCommit_lineaspedidosprov(curLP)
{
  var _i = this.iface;
  if (!_i.__afterCommit_lineaspedidosprov(curLP))
    return false;

  var idMultiTc = curLP.valueBuffer("idlineamultitc");
  if (idMultiTc && idMultiTc != 0) {
    if (!_i.actualizarCantidadesTransStock(curLP))
      return false;
  }

  return true;
}

///NOTA Santi: La función estaba declarada como function balonman_actualizarCantidadesTransStock.
function multitienda_actualizarCantidadesTransStock(curLinea)
{
  var _i = this.iface;
  var idMultiTc = curLinea.valueBuffer("idlineamultitc");
  if (!idMultiTc || idMultiTc == 0)
    return true;

  var cantidad = 0
                 var cantPte = 0;

  switch (curLinea.modeAccess()) {
    case curLinea.Del: {
      cantidad = 0;
      cantPte = parseFloat(curLinea.valueBuffer("cantidad"));
      break;
    }
    case curLinea.Insert: {
      return true;
      break;
    }
    case curLinea.Edit: {
      cantidad = parseFloat(curLinea.valueBuffer("totalenalbaran"));
      if (!curLinea.valueBuffer("cerrada")) {
        cantPte = parseFloat(curLinea.valueBuffer("cantidad")) - parseFloat(curLinea.valueBuffer("totalenalbaran"));
      }
      break;
    }
  }

  var curLineaMultiTc = new FLSqlCursor("tpv_lineasmultitransstock");
  curLineaMultiTc.select("idlinea = " + idMultiTc);
  if (!curLineaMultiTc.first())
    return false;

  curLineaMultiTc.setModeAccess(curLineaMultiTc.Edit);
  curLineaMultiTc.refreshBuffer();
  switch (curLinea.table()) {
    case "lineaspedidoscli": {
      curLineaMultiTc.setValueBuffer("cantenviada", cantidad);
      curLineaMultiTc.setValueBuffer("cantpteenvio", cantPte);
      break;
    }
    case "lineaspedidosprov": {
      curLineaMultiTc.setValueBuffer("cantrecibida", cantidad);
      curLineaMultiTc.setValueBuffer("cantpterecibir", cantPte);
      break;
    }
  }
  var estado;
  if (curLineaMultiTc.valueBuffer("cantpteenvio") == 0) {
    if (curLineaMultiTc.valueBuffer("cantpterecibir") == 0) {
      if (curLineaMultiTc.valueBuffer("cantrecibida") == curLineaMultiTc.valueBuffer("cantidad")) {
        estado = "RECIBIDO";
      } else {
        estado = "RECIBIDO PARCIAL";
      }
    } else {
      estado = "EN TRANSITO";
    }
  } else {
    if (curLineaMultiTc.valueBuffer("cantenviada") == 0) {
      estado = "PTE ENVIO";
    } else {
      estado = "ENVIADO PARCIAL";
    }
  }
  curLineaMultiTc.setValueBuffer("estado", estado);

  if (!curLineaMultiTc.commitBuffer()) {
    return false;
  }
  return true;
}
//// MULTITIENDA ////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
