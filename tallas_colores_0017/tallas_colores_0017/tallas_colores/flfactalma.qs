
/** @class_declaration tallasColores */
/////////////////////////////////////////////////////////////////
//// TALLASCOLORES //////////////////////////////////////////////////
class tallasColores extends oficial
{
  function tallasColores(context)
  {
    oficial(context);
  }
  function cambiarStock(codAlmacen: String, referencia: String, talla: String, color: String, variacion: Number): Boolean {
    return this.ctx.tallasColores_cambiarStock(codAlmacen, referencia, talla, color, variacion);
  }
  function controlStockPedidosCli(curLP: FLSqlCursor): Boolean {
    return this.ctx.tallasColores_controlStockPedidosCli(curLP);
  }
  function controlStockPedidosProv(curLP: FLSqlCursor): Boolean {
    return this.ctx.tallasColores_controlStockPedidosProv(curLP);
  }
  function controlStockAlbaranesCli(curLA: FLSqlCursor): Boolean {
    return this.ctx.tallasColores_controlStockAlbaranesCli(curLA);
  }
  function controlStockAlbaranesProv(curLA: FLSqlCursor): Boolean {
    return this.ctx.tallasColores_controlStockAlbaranesProv(curLA);
  }
  function controlStockFacturasCli(curLF: FLSqlCursor): Boolean {
    return this.ctx.tallasColores_controlStockFacturasCli(curLF);
  }
  function controlStockFacturasProv(curLF: FLSqlCursor): Boolean {
    return this.ctx.tallasColores_controlStockFacturasProv(curLF);
  }
}
//// TALLASCOLORES //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition tallasColores */
/////////////////////////////////////////////////////////////////
//// TALLASCOLORES //////////////////////////////////////////////////

function tallasColores_cambiarStock(codAlmacen: String, referencia: String, talla: String, color: String, variacion: Number): Boolean {
  var util: FLUtil = new FLUtil();
  if (referencia == "" || !referencia)
    return true;

  var cantidadPrevia: Number;
  var controlStock: Boolean;
  var curStock: FLSqlCursor = new FLSqlCursor("stocks");

  var where: String = "referencia = '" + referencia + "' AND codalmacen = '" + codAlmacen + "'";
  if (talla)
    where += " AND talla = '" + talla + "'";
  if (color)
    where += " AND color = '" + color + "'";

  curStock.select(where);
  var hayStock: Boolean = curStock.first();
  if (hayStock)
  {
    curStock.setModeAccess(curStock.Edit);
    curStock.refreshBuffer();
    cantidadPrevia = parseFloat(curStock.valueBuffer("cantidad"));
  } else
    cantidadPrevia = 0;
  var nuevaCantidad: Number = cantidadPrevia + parseFloat(variacion);
  if (parseFloat(nuevaCantidad) < 0)
  {
    controlStock = util.sqlSelect("articulos", "controlstock", "referencia = '" + referencia + "'");
    if (controlStock == false) {
      MessageBox.warning(util.translate("scripts",
      "No hay stock suficiente para el artículo " + referencia + " en el almacen " + codAlmacen),
      MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
      return false;
    }
  }

  var nombreAlmacen: String = util.sqlSelect("almacenes", "nombre", "codalmacen = '" + codAlmacen + "'");
  if (!hayStock)
  {
    curStock.setModeAccess(curStock.Insert);
    curStock.refreshBuffer();
    curStock.setValueBuffer("referencia", referencia);
    curStock.setValueBuffer("talla", talla);
    curStock.setValueBuffer("color", color);
    curStock.setValueBuffer("codalmacen", codAlmacen);
  }
  curStock.setValueBuffer("nombre", nombreAlmacen);
  curStock.setValueBuffer("cantidad", nuevaCantidad);
  curStock.commitBuffer();
  return true;
}

function tallasColores_controlStockPedidosCli(curLP: FLSqlCursor): Boolean {
  var util: FLUtil = new FLUtil();
  var codAlmacen: String = util.sqlSelect("pedidoscli", "codalmacen", "idpedido = " + curLP.valueBuffer("idpedido"));
  if (codAlmacen == false)
    codAlmacen = curLP.cursorRelation().valueBuffer("codalmacen");
  switch (curLP.modeAccess())
  {
    case curLP.Insert:
      var cantidad: Number = -1 * parseFloat(curLP.valueBuffer("cantidad"));
      if (!flfactalma.iface.cambiarStock(codAlmacen, curLP.valueBuffer("referencia"), curLP.valueBuffer("talla"), curLP.valueBuffer("color"), cantidad))
        return false;
      break;
    case curLP.Del:
      if (!flfactalma.iface.cambiarStock(codAlmacen, curLP.valueBuffer("referencia"), curLP.valueBuffer("talla"), curLP.valueBuffer("color"), curLP.valueBuffer("cantidad")))
        return false;
      break;
    case curLP.Edit:
      if (curLP.valueBuffer("referencia") != curLP.valueBufferCopy("referencia")
      || curLP.valueBuffer("cantidad") != curLP.valueBufferCopy("cantidad")
      || curLP.valueBuffer("talla") != curLP.valueBufferCopy("talla")
      || curLP.valueBuffer("color") != curLP.valueBufferCopy("color")) {
        var cantidad: Number = -1 * parseFloat(curLP.valueBuffer("cantidad"));
        if (flfactalma.iface.cambiarStock(codAlmacen, curLP.valueBufferCopy("referencia"), curLP.valueBufferCopy("talla"), curLP.valueBufferCopy("color"), curLP.valueBufferCopy("cantidad"))) {
          if (!flfactalma.iface.cambiarStock(codAlmacen, curLP.valueBuffer("referencia"), curLP.valueBuffer("talla"), curLP.valueBuffer("color"), cantidad))
            return false;
        } else
          return false;
      }
      break;
  }
  return true;
}

function tallasColores_controlStockPedidosProv(curLP: FLSqlCursor): Boolean {
  return true;
}

function tallasColores_controlStockAlbaranesCli(curLA: FLSqlCursor): Boolean {
  if (curLA.valueBuffer("idlineapedido") != 0)
    return true;

  var util: FLUtil = new FLUtil();
  var codAlmacen: String = util.sqlSelect("albaranescli", "codalmacen", "idalbaran = " + curLA.valueBuffer("idalbaran"));
  if (!codAlmacen || codAlmacen == "")
    return true;

  switch (curLA.modeAccess())
  {
    case curLA.Insert:
      var cantidad: Number = -1 * parseFloat(curLA.valueBuffer("cantidad"));
      if (!flfactalma.iface.cambiarStock(codAlmacen, curLA.valueBuffer("referencia"), curLA.valueBuffer("talla"), curLA.valueBuffer("color"), cantidad))
        return false;
      break;
    case curLA.Del:
      if (!flfactalma.iface.cambiarStock(codAlmacen, curLA.valueBuffer("referencia"), curLA.valueBuffer("talla"), curLA.valueBuffer("color"), curLA.valueBuffer("cantidad")))
        return false;
      break;
    case curLA.Edit:
      if (curLA.valueBuffer("referencia") != curLA.valueBufferCopy("referencia")
      || curLA.valueBuffer("cantidad") != curLA.valueBufferCopy("cantidad")
      || curLA.valueBuffer("talla") != curLA.valueBufferCopy("talla")
      || curLA.valueBuffer("color") != curLA.valueBufferCopy("color")) {
        var cantidad: Number = -1 * parseFloat(curLA.valueBuffer("cantidad"));
        if (flfactalma.iface.cambiarStock(codAlmacen, curLA.valueBufferCopy("referencia"), curLA.valueBufferCopy("talla"), curLA.valueBufferCopy("color"), curLA.valueBufferCopy("cantidad"))) {
          if (!flfactalma.iface.cambiarStock(codAlmacen, curLA.valueBuffer("referencia"), curLA.valueBuffer("talla"), curLA.valueBuffer("color"), cantidad))
            return false;
        } else
          return false;
      }
      break;
  }
  return true;
}

function tallasColores_controlStockFacturasCli(curLF: FLSqlCursor): Boolean {
  var util: FLUtil = new FLUtil();
  var automatica: Boolean = util.sqlSelect("facturascli", "automatica", "idfactura = " + curLF.valueBuffer("idfactura"));
  if (automatica == false)
  {
    var codAlmacen = util.sqlSelect("facturascli", "codalmacen", "idfactura = " + curLF.valueBuffer("idfactura"));
    if (!codAlmacen || codAlmacen == "")
      return true;
    switch (curLF.modeAccess()) {
      case curLF.Insert:
        var cantidad: Number = -1 * parseFloat(curLF.valueBuffer("cantidad"));
        if (!flfactalma.iface.cambiarStock(codAlmacen, curLF.valueBuffer("referencia"), curLF.valueBuffer("talla"), curLF.valueBuffer("color"), cantidad))
          return false;
        break;
      case curLF.Del:
        if (!flfactalma.iface.cambiarStock(codAlmacen, curLF.valueBuffer("referencia"), curLF.valueBuffer("talla"), curLF.valueBuffer("color"), curLF.valueBuffer("cantidad")))
          return false;
        break;
      case curLF.Edit:
        if (curLF.valueBuffer("referencia") != curLF.valueBufferCopy("referencia")
        || curLF.valueBuffer("cantidad") != curLF.valueBufferCopy("cantidad")
        || curLF.valueBuffer("talla") != curLF.valueBufferCopy("talla")
        || curLF.valueBuffer("color") != curLF.valueBufferCopy("color")) {
          var cantidad: Number = -1 * parseFloat(curLF.valueBuffer("cantidad"));
          if (flfactalma.iface.cambiarStock(codAlmacen, curLF.valueBufferCopy("referencia"), curLF.valueBufferCopy("talla"), curLF.valueBufferCopy("color"), curLF.valueBufferCopy("cantidad"))) {
            if (!flfactalma.iface.cambiarStock(codAlmacen, curLF.valueBuffer("referencia"), curLF.valueBuffer("talla"), curLF.valueBuffer("color"), cantidad))
              return false;
          } else
            return false;
        }
        break;
    }
  }
  return true;
}

function tallasColores_controlStockAlbaranesProv(curLA: FLSqlCursor): Boolean {
  var util: FLUtil = new FLUtil();
  var codAlmacen: String = util.sqlSelect("albaranesprov", "codalmacen", "idalbaran = " + curLA.valueBuffer("idalbaran"));
  if (!codAlmacen || codAlmacen == "")
    return true;
  switch (curLA.modeAccess())
  {
    case curLA.Insert:
      if (!flfactalma.iface.cambiarStock(codAlmacen, curLA.valueBuffer("referencia"), curLA.valueBuffer("talla"), curLA.valueBuffer("color"), curLA.valueBuffer("cantidad")))
        return false;
      break;
    case curLA.Del: {
      var cantidad: Number = -1 * parseFloat(curLA.valueBuffer("cantidad"));
      if (!flfactalma.iface.cambiarStock(codAlmacen, curLA.valueBuffer("referencia"), curLA.valueBuffer("talla"), curLA.valueBuffer("color"), cantidad))
        return false;
      break;
    }
    case curLA.Edit:
      if (curLA.valueBuffer("referencia") != curLA.valueBufferCopy("referencia")
          || curLA.valueBuffer("cantidad") != curLA.valueBufferCopy("cantidad")
          || curLA.valueBuffer("talla") != curLA.valueBufferCopy("talla")
          || curLA.valueBuffer("color") != curLA.valueBufferCopy("color")) {
        var cantidad: Number = -1 * parseFloat(curLA.valueBufferCopy("cantidad"));
        if (flfactalma.iface.cambiarStock(codAlmacen, curLA.valueBufferCopy("referencia"), curLA.valueBufferCopy("talla"), curLA.valueBufferCopy("color"), cantidad)) {
          if (!flfactalma.iface.cambiarStock(codAlmacen, curLA.valueBuffer("referencia"), curLA.valueBuffer("talla"), curLA.valueBuffer("color"), curLA.valueBuffer("cantidad")))
            return false;
        } else
          return false;
      }
      break;
  }
  return true;
}

function tallasColores_controlStockFacturasProv(curLF: FLSqlCursor): Boolean {
  var util: FLUtil = new FLUtil();
  var automatica: Boolean = util.sqlSelect("facturasprov", "automatica", "idfactura = " + curLF.valueBuffer("idfactura"));
  if (automatica == false)
  {
    var codAlmacen: String = util.sqlSelect("facturasprov", "codalmacen", "idfactura = " + curLF.valueBuffer("idfactura"));
    if (!codAlmacen || codAlmacen == "")
      return true;
    switch (curLF.modeAccess()) {
      case curLF.Insert:
        if (!flfactalma.iface.cambiarStock(codAlmacen, curLF.valueBuffer("referencia"), curLF.valueBuffer("talla"), curLF.valueBuffer("color"), curLF.valueBuffer("cantidad")))
          return false;
        break;
      case curLF.Del:
        var cantidad: Number = -1 * parseFloat(curLF.valueBuffer("cantidad"));
        if (!flfactalma.iface.cambiarStock(codAlmacen, curLF.valueBuffer("referencia"), curLF.valueBuffer("talla"), curLF.valueBuffer("color"), cantidad))
          return false;
        break;
      case curLF.Edit:
        if (curLF.valueBuffer("referencia") != curLF.valueBufferCopy("referencia")
        || curLF.valueBuffer("cantidad") != curLF.valueBufferCopy("cantidad")
        || curLF.valueBuffer("talla") != curLF.valueBufferCopy("talla")
        || curLF.valueBuffer("color") != curLF.valueBufferCopy("color")) {
          var cantidad: Number = -1 * parseFloat(curLF.valueBufferCopy("cantidad"));
          if (flfactalma.iface.cambiarStock(codAlmacen, curLF.valueBufferCopy("referencia"), curLF.valueBufferCopy("talla"), curLF.valueBufferCopy("color"), cantidad)) {
            if (!flfactalma.iface.cambiarStock(codAlmacen, curLF.valueBuffer("referencia"), curLF.valueBuffer("talla"), curLF.valueBuffer("color"), curLF.valueBuffer("cantidad")))
              return false;
          } else
            return false;
        }
        break;
    }
  }
  return true;
}


//// TALLASCOLORES //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

