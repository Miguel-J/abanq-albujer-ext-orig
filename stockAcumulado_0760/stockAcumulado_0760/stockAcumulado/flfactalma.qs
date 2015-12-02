
/** @class_declaration stockAcumulado */
/////////////////////////////////////////////////////////////////
//// STOCK ACUMULADO ////////////////////////////////////////////
class stockAcumulado extends articomp
{
  var stocksPtes_;
  function stockAcumulado(context)
  {
    articomp(context);
  }

  function actualizarStock(idStock)
  {
    return this.ctx.stockAcumulado_actualizarStock(idStock);
  }
  function actualizarStockPteRecibir2(idStock)
  {
    return this.ctx.stockAcumulado_actualizarStockPteRecibir2(idStock);
  }
  function procesaStocks()
  {
    return this.ctx.stockAcumulado_procesaStocks();
  }
  function actualizarStockPteRecibir(idStock)
  {
    return this.ctx.stockAcumulado_actualizarStockPteRecibir(idStock);
  }
  function actualizarStockPteServir(idStock)
  {
    return this.ctx.stockAcumulado_actualizarStockPteServir(idStock);
  }
  function actualizarStockPteServir2(idStock)
  {
    return this.ctx.stockAcumulado_actualizarStockPteServir2(idStock);
  }
  function actualizarStock2(idStock)
  {
    return this.ctx.stockAcumulado_actualizarStock2(idStock);
  }
  function processEndTran(obj)
  {
    return this.ctx.stockAcumulado_processEndTran(obj);
  }
  function processRollbackTran()
  {
    return this.ctx.stockAcumulado_processRollbackTran();
  }
  function procesaStocks()
  {
    return this.ctx.stockAcumulado_procesaStocks();
  }
}

//// STOCK ACUMULADO ////////////////////////////////////////////
/////////////////////////////////////////////////////////////////


/** @class_definition stockAcumulado */
//////////////////////////////////////////////////////////////////
//// STOCK ACUMULADO /////////////////////////////////////////////

function stockAcumulado_actualizarStock(idStock)
{
  debug("**************************************************** stockAcumulado_actualizarStock");
  var _i = this.iface;
  // debug("sys.transactionLevel() = " + sys.transactionLevel());
  if (sys.transactionLevel() == 0) {
    return _i.actualizarStock2(idStock);
  }
  // debug("aqApp.notifyEndTransaction() " + aqApp.notifyEndTransaction());
  if (!aqApp.notifyEndTransaction()) {
    aqApp.setNotifyEndTransaction(true);
    connect(aqApp.self(), "transactionEnd(QObject*)", _i,
            "processEndTran()");
  }
  if (!aqApp.notifyRollbackTransaction()) {
    aqApp.setNotifyRollbackTransaction(true);
    connect(aqApp.self(), "transactionRollback(QObject*)", _i,
            "processRollbackTran()");
  }
  if (!_i.stocksPtes_) {
    _i.stocksPtes_ = [];
  }
  var oStock = new Object;
  oStock.id = idStock;
  oStock.calcType = "STOCK_FISICO";
  _i.stocksPtes_.push(oStock);

  return true;
}

function stockAcumulado_actualizarStockPteRecibir2(idStock)
{
  var _i = this.iface;
  return _i.__actualizarStockPteRecibir(idStock);
}

function stockAcumulado_actualizarStockPteServir2(idStock)
{
  var _i = this.iface;
  return _i.__actualizarStockPteServir(idStock);
}

function stockAcumulado_actualizarStockPteServir(idStock)
{
  // debug("stockAcumulado_actualizarStockPteServir");
  var _i = this.iface;
  // debug("sys.transactionLevel() = " + sys.transactionLevel());
  if (sys.transactionLevel() == 0) {
    return _i.actualizarStockPteServir2(idStock);
  }
  // debug("aqApp.notifyEndTransaction() " + aqApp.notifyEndTransaction());
  if (!aqApp.notifyEndTransaction()) {
    aqApp.setNotifyEndTransaction(true);
    connect(aqApp.self(), "transactionEnd(QObject*)", _i,
            "processEndTran()");
  }
  if (!aqApp.notifyRollbackTransaction()) {
    aqApp.setNotifyRollbackTransaction(true);
    connect(aqApp.self(), "transactionRollback(QObject*)", _i,
            "processRollbackTran()");
  }
  // debug("aqApp.notifyEndTransaction() " + aqApp.notifyEndTransaction());
  if (!_i.stocksPtes_) {
    _i.stocksPtes_ = [];
  }
  var oStock = new Object;
  oStock.id = idStock;
  oStock.calcType = "PTE_SERVIR";
  _i.stocksPtes_.push(oStock);
  return true;
}

function stockAcumulado_actualizarStockPteRecibir(idStock)
{
  var _i = this.iface;
  if (sys.transactionLevel() == 0) {
    return _i.actualizarStockPteRecibir2(idStock);
  }
  if (!aqApp.notifyEndTransaction()) {
    aqApp.setNotifyEndTransaction(true);
    connect(aqApp.self(), "transactionEnd(QObject*)", _i,
            "processEndTran()");
  }
  if (!aqApp.notifyRollbackTransaction()) {
    aqApp.setNotifyRollbackTransaction(true);
    connect(aqApp.self(), "transactionRollback(QObject*)", _i,
            "processRollbackTran()");
  }
  if (!_i.stocksPtes_) {
    _i.stocksPtes_ = [];
  }
  var oStock = new Object;
  oStock.id = idStock;
  oStock.calcType = "PTE_RECIBIR";
  _i.stocksPtes_.push(oStock);

  return true;
}

function stockAcumulado_processEndTran(obj)
{
  debug("oficial_processEndTran");
  debug(obj);
  debug(obj.name);
  debug(obj.metadata().name);
  debug(obj.lastQuery());
  print("====");

  var _i = this.iface;
  if (!_i.procesaStocks()) {
    return false;
  }
}

function stockAcumulado_processRollbackTran()
{
  var _i = this.iface;
  debug("Borrando caché stocks....");
  if (!_i.stocksPtes_) {
    return false;
  }
  delete _i.stocksPtes_;
}

function stockAcumulado_procesaStocks()
{
  debug("Procesa stocks");
  var _i = this.iface;
  if (!_i.stocksPtes_) {
    return false;
  }
  var oStock;
  var lFisico = new Object;
  for (var i = 0; i < _i.stocksPtes_.length; i++) {
    oStock = _i.stocksPtes_[i];
    debug("oStock.calcType " + oStock.calcType);
    switch (oStock.calcType) {
      case "STOCK_FISICO": {
        if (oStock.id in lFisico) {
          break;
        }
        if (!_i.actualizarStock2(oStock.id)) {
          return false;
        }
        lFisico[oStock.id] = true;
        break;
      }
      case "PTE_SERVIR": {
        debug("pte servir");
        if (!_i.actualizarStockPteServir2(oStock.id)) {
          return false;
        }
        break;
      }
      case "PTE_RECIBIR": {
        debug("pte recibir");
        if (!_i.actualizarStockPteRecibir2(oStock.id)) {
          return false;
        }
        break;
      }
    }
  }
  _i.stocksPtes_ = [];
  return true;
}

function stockAcumulado_actualizarStock2(idStock)
{
  var curStock: FLSqlCursor = new FLSqlCursor("stocks");
  curStock.select("idstock = " + idStock);
  if (!curStock.first()) {
    return false;
  }
  curStock.setModeAccess(curStock.Edit);
  curStock.refreshBuffer();
  curStock.setValueBuffer("cantidad",
                          formRecordregstocks.iface.pub_commonCalculateField("cantidad", curStock));
  curStock.setValueBuffer("disponible",
                          formRecordregstocks.iface.pub_commonCalculateField("disponible", curStock));
  debug("Actualizando stock de " + curStock.valueBuffer("barcode") + ", " +
        curStock.valueBuffer("codalmacen") + " a " + curStock.valueBuffer("cantidad"));
  if (!curStock.commitBuffer()) {
    return false;
  }
  return true;
}
//// STOCK ACUMULADO /////////////////////////////////////////////
//////////////////////////////////////////////////////////////////


