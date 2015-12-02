
/** @class_declaration lineasAlma */
/////////////////////////////////////////////////////////////////
//// ALMACÉN POR LÍNEA /////////////////////////////////////////
class lineasAlma extends scab
{
  function lineasAlma(context)
  {
    scab(context);
  }
  function controlStockAlbaranesCli(curLA: FLSqlCursor): Boolean {
    return this.ctx.lineasAlma_controlStockAlbaranesCli(curLA);
  }
  function controlStockAlbaranesProv(curLA: FLSqlCursor): Boolean {
    return this.ctx.lineasAlma_controlStockAlbaranesProv(curLA);
  }
  function controlStockFacturasCli(curLF: FLSqlCursor): Boolean {
    return this.ctx.lineasAlma_controlStockFacturasCli(curLF);
  }
  function controlStockFacturasProv(curLF: FLSqlCursor): Boolean {
    return this.ctx.lineasAlma_controlStockFacturasProv(curLF);
  }
  function controlStockPedidosCli(curLP: FLSqlCursor): Boolean {
    return this.ctx.lineasAlma_controlStockPedidosCli(curLP);
  }
  function controlStockPedidosProv(curLP: FLSqlCursor): Boolean {
    return this.ctx.lineasAlma_controlStockPedidosProv(curLP);
  }
  function controlStockFisicoLinea(curLinea: FLSqlCursor, campo): Boolean {
    return this.ctx.lineasAlma_controlStockFisicoLinea(curLinea, campo);
  }
  function controlStockLineasReservado(curLinea: FLSqlCursor): Boolean {
    return this.ctx.lineasAlma_controlStockLineasReservado(curLinea);
  }
  function controlStockLineasPteRecibir(curLinea: FLSqlCursor): Boolean {
    return this.ctx.lineasAlma_controlStockLineasPteRecibir(curLinea);
  }
}
//// ALMACÉN POR LÍNEA /////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pubLineasAlma */
/////////////////////////////////////////////////////////////////
//// PUB ALMACEN POR LINEA //////////////////////////////////////
class pubLineasAlma extends ifaceCtx
{
  function pubLineasAlma(context)
  {
    ifaceCtx(context);
  }
  function pub_controlStockLineasAlbaranesCli(curLA: FLSqlCursor): Boolean {
    return this.controlStockLineasAlbaranesCli(curLA);
  }
  function pub_controlStockLineasAlbaranesProv(curLA: FLSqlCursor): Boolean {
    return this.controlStockLineasAlbaranesProv(curLA);
  }
  function pub_controlStockLineasFacturasCli(curLF: FLSqlCursor): Boolean {
    return this.controlStockLineasFacturasCli(curLF);
  }
  function pub_controlStockLineasFacturasProv(curLF: FLSqlCursor): Boolean {
    return this.controlStockLineasFacturasProv(curLF);
  }
  function pub_controlStockLineasPedidosCli(curLP: FLSqlCursor): Boolean {
    return this.controlStockLineasPedidosCli(curLP);
  }
  function pub_controlStockLineasPedidosProv(curLP: FLSqlCursor): Boolean {
    return this.controlStockLineasPedidosProv(curLP);
  }
}
//// PUB ALMACEN POR LINEA //////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition lineasAlma */
/////////////////////////////////////////////////////////////////
//// ALMACÉN POR LÍNEA //////////////////////////////////////////
function lineasAlma_controlStockFisicoLinea(curLinea: FLSqlCursor, campo: String): Boolean {
  var util: FLUtil = new FLUtil;

  var referencia: String = curLinea.valueBuffer("referencia");
  if (util.sqlSelect("articulos", "nostock", "referencia = '" + referencia  + "'"))
  {
    return true;
  }

  var codAlmacen: String = curLinea.valueBuffer("codalmacen");
  if (referencia && referencia != "")
  {
    var oArticulo = new Object();
    oArticulo.referencia = referencia;
    if (!this.iface.actualizarStockFisico(oArticulo, codAlmacen, campo)) {
      return false;
    }
  }

  var referenciaPrevia: String = curLinea.valueBufferCopy("referencia");
  var codAlmacenPrevio: String = curLinea.valueBufferCopy("codalmacen");
  if ((referenciaPrevia && referenciaPrevia != "" && referenciaPrevia != referencia) || (codAlmacenPrevio && codAlmacenPrevio != "" && codAlmacenPrevio != codAlmacen))
  {
    var oArticuloPrevio = new Object();
    oArticuloPrevio.referencia = referenciaPrevia;
    if (!this.iface.actualizarStockFisico(oArticuloPrevio, codAlmacenPrevio, campo)) {
      return false;
    }
  }

  return true;
}

function lineasAlma_controlStockAlbaranesCli(curLA: FLSqlCursor): Boolean {
  var util: FLUtil = new FLUtil;
  var curRel: FLSqlCursor = curLA.cursorRelation();
  if (curRel && curRel.action() == "albaranescli")
  {
    return true;
  }

  if (!this.iface.controlStockFisicoLinea(curLA, "cantidadac"))
  {
    return false;
  }

  return true;
}

function lineasAlma_controlStockAlbaranesProv(curLA: FLSqlCursor): Boolean {
  var util: FLUtil = new FLUtil;
  var curRel: FLSqlCursor = curLA.cursorRelation();
  if (curRel && curRel.action() == "albaranesprov")
  {
    return true;
  }

  if (!this.iface.controlStockFisicoLinea(curLA, "cantidadap"))
  {
    return false;
  }

  return true;
}

function lineasAlma_controlStockFacturasCli(curLF: FLSqlCursor): Boolean {
  var util: FLUtil = new FLUtil;
  var curRel: FLSqlCursor = curLF.cursorRelation();
  if (curRel && curRel.action() == "facturascli")
  {
    return true;
  }

  if (util.sqlSelect("facturascli", "automatica", "idfactura = " + curLF.valueBuffer("idfactura")))
  {
    return true;
  }

  if (!this.iface.controlStockFisicoLinea(curLF, "cantidadfc"))
  {
    return false;
  }

  return true;
}

function lineasAlma_controlStockFacturasProv(curLF: FLSqlCursor): Boolean {
  var util: FLUtil = new FLUtil;
  var curRel: FLSqlCursor = curLF.cursorRelation();
  if (curRel && curRel.action() == "facturasprov")
  {
    return true;
  }

  if (util.sqlSelect("facturasprov", "automatica", "idfactura = " + curLF.valueBuffer("idfactura")))
  {
    return true;
  }

  if (!this.iface.controlStockFisicoLinea(curLF, "cantidadfp"))
  {
    return false;
  }

  return true;
}

function lineasAlma_controlStockPedidosCli(curLP: FLSqlCursor): Boolean {
  var util: FLUtil = new FLUtil;
  var curRel: FLSqlCursor = curLP.cursorRelation();
  if (curRel && curRel.action() == "pedidoscli")
  {
    return true;
  }

  if (util.sqlSelect("articulos", "nostock", "referencia = '" + curLP.valueBuffer("referencia") + "'"))
    return true;

  var stockPedidos: Boolean = flfactppal.iface.pub_valorDefectoEmpresa("stockpedidos");

  if (!this.iface.controlStockLineasReservado(curLP))
  {
    return false;
  }


  return true;
}

function lineasAlma_controlStockLineasReservado(curLinea: FLSqlCursor): Boolean {
  var util: FLUtil = new FLUtil;

  var idPedido: String = curLinea.valueBuffer("idpedido");
  var referencia: String = curLinea.valueBuffer("referencia");
  var codAlmacen: String = curLinea.valueBuffer("codalmacen");
  var oArticulo = new Object();
  oArticulo.referencia = referencia;
  if (referencia && referencia != "")
  {
    if (!this.iface.actualizarStockReservado(oArticulo, codAlmacen, idPedido)) {
      return false;
    }
  }

  var referenciaPrevia: String = curLinea.valueBufferCopy("referencia");
  var codAlmacenPrevio: String = curLinea.valueBufferCopy("codalmacen");
  if ((referenciaPrevia && referenciaPrevia != "" && referenciaPrevia != referencia) || (codAlmacenPrevio && codAlmacenPrevio != "" && codAlmacenPrevio != codAlmacen))
  {
    var oArticuloPrevio = new Object();
    oArticuloPrevio.referencia = referenciaPrevia;
    if (!this.iface.actualizarStockReservado(oArticuloPrevio, codAlmacenPrevio, idPedido)) {
      return false;
    }
  }

  return true;
}

function lineasAlma_controlStockPedidosProv(curLP: FLSqlCursor): Boolean {
  var util: FLUtil = new FLUtil;
  var curRel: FLSqlCursor = curLP.cursorRelation();
  if (curRel && curRel.action() == "pedidosprov")
  {
    return true;
  }

  if (util.sqlSelect("articulos", "nostock", "referencia = '" + curLP.valueBuffer("referencia") + "'"))
    return true;

  if (!this.iface.controlStockLineasPteRecibir(curLP))
  {
    return false;
  }

  return true;
}

function lineasAlma_controlStockLineasPteRecibir(curLinea: FLSqlCursor): Boolean {
  var util: FLUtil = new FLUtil;

  var referencia = curLinea.valueBuffer("referencia");
  var idPedido: String = curLinea.valueBuffer("idpedido");
  var codAlmacen: String = curLinea.valueBuffer("codalmacen");
  var oArticulo = new Object();
  oArticulo.referencia = referencia;
  if (referencia && referencia != "")
  {
    if (!this.iface.actualizarStockPteRecibir(oArticulo, codAlmacen, idPedido)) {
      return false;
    }
  }

  var referenciaPrevia: String = curLinea.valueBufferCopy("referencia");
  var codAlmacenPrevio: String = curLinea.valueBufferCopy("codalmacen");
  if ((referenciaPrevia && referenciaPrevia != "" && referenciaPrevia != referencia) || (codAlmacenPrevio && codAlmacenPrevio != "" && codAlmacenPrevio != codAlmacen))
  {
    var oArticuloPrevio = new Object();
    oArticuloPrevio.referencia = referenciaPrevia;
    if (!this.iface.actualizarStockPteRecibir(oArticuloPrevio, codAlmacenPrevio, idPedido)) {
      return false;
    }
  }

  return true;
}

//// ALMACÉN POR LÍNEA //////////////////////////////////////////
////////////////////////////////////////////////////////////////
