
/** @class_declaration magento */
/////////////////////////////////////////////////////////////////
//// MAGENTO ////////////////////////////////////////////////////
class magento extends traducciones
{
  var bloqueoWS_;
  function magento(context)
  {
    traducciones(context);
  }
  function init()
  {
    return this.ctx.magento_init();
  }
  function tdbWebSites_primaryKeyToggled(codWebsite, on)
  {
    return this.ctx.magento_tdbWebSites_primaryKeyToggled(codWebsite, on);
  }
  function cargaWebsites()
  {
    return this.ctx.magento_cargaWebsites();
  }
  function bufferChanged(fN)
  {
    return this.ctx.magento_bufferChanged(fN);
  }
  function marcaWebsites()
  {
    return this.ctx.magento_marcaWebsites();
  }
  function activaWebsite(codWebsite, on)
  {
    return this.ctx.magento_activaWebsite(codWebsite, on);
  }
}
//// MAGENTO ////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition magento */
/////////////////////////////////////////////////////////////////
//// MAGENTO ////////////////////////////////////////////////////
function magento_init()
{
  var _i = this.iface;
  var cursor = this.cursor();

  _i.__init();

  connect(this.child("tdbWebSites"), "primaryKeyToggled(QVariant, bool)", _i, "tdbWebSites_primaryKeyToggled");

  _i.bloqueoWS_ = true;
  _i.cargaWebsites();
  _i.bloqueoWS_ = false;
}

function magento_tdbWebSites_primaryKeyToggled(codWebsite, on)
{
  var _i = this.iface;
  if (_i.bloqueoWS_) {
    return true;
  }
  var cursor = this.cursor();

  debug("magento_tdbWebSites_primaryKeyToggled " + codWebsite + " " + on);
  var referencia = cursor.valueBuffer("referencia");
  if (!_i.activaWebsite(codWebsite, on)) {
    return false;
  }

  if (on) {
    _i.bloqueoWS_ = true;
    sys.setObjText(this, "fdbMgVisibleWeb", true);
    _i.bloqueoWS_ = false;
  } else {
    if (!AQUtil.quickSqlSelect("mg_artwebsite", "idaw", "referencia = '" + referencia + "' AND activo")) {
      _i.bloqueoWS_ = true;
      sys.setObjText(this, "fdbMgVisibleWeb", false);
      _i.bloqueoWS_ = false;
    }
  }
}

function magento_activaWebsite(codWebsite, on)
{
  var _i = this.iface;
  var cursor = this.cursor();
  var referencia = cursor.valueBuffer("referencia");
  var curAW = new FLSqlCursor("mg_artwebsite");
  curAW.select("referencia = '" + referencia + "' AND codwebsite = '" + codWebsite + "'");
  if (curAW.first()) {
    curAW.setModeAccess(curAW.Edit);
    curAW.refreshBuffer();
  } else {
    curAW.setModeAccess(curAW.Insert);
    curAW.refreshBuffer();
    curAW.setValueBuffer("referencia", referencia);
    curAW.setValueBuffer("codwebsite", codWebsite);
  }
  curAW.setValueBuffer("activo", on);
  if (!curAW.commitBuffer()) {
    return false;
  }
  return true;
}

function magento_cargaWebsites()
{
  var _i = this.iface;
  var cursor = this.cursor();

  var t = this.child("tdbWebSites");
  t.clearChecked();

  var q = new AQSqlQuery;
  q.setSelect("codwebsite");
  q.setFrom("mg_artwebsite");
  q.setWhere("referencia = '" + cursor.valueBuffer("referencia") + "' AND activo");
  if (!q.exec()) {
    return false;
  }
  while (q.next()) {
    t.setPrimaryKeyChecked(q.value("codwebsite"), true);
  }
  t.refresh();
}

function magento_bufferChanged(fN)
{
  var _i = this.iface;
  var cursor = this.cursor();

  switch (fN) {
    case "mgvisibleweb": {
      _i.marcaWebsites();
      break;
    }
    default: {
      _i.__bufferChanged(fN);
    }
  }
}

function magento_marcaWebsites()
{
  var _i = this.iface;
  var cursor = this.cursor();
  debug("magento_marcaWebsites " + _i.bloqueoWS_ + " " + cursor.valueBuffer("mgvisibleweb"));

  if (!_i.bloqueoWS_) {
    _i.bloqueoWS_ = true;
    if (cursor.valueBuffer("mgvisibleweb")) {
      var q = new AQSqlQuery();
      q.setSelect("codwebsite");
      q.setFrom("mg_websites");
      q.setWhere("1 = 1");
      if (!q.exec()) {
        return false;
      }
      var curAW = new FLSqlCursor("mg_artwebsite");
      while (q.next()) {
        debug("Activando " + q.value("codwebsite"));
        if (!_i.activaWebsite(q.value("codwebsite"), true)) {
          return false;
        }
      }
    } else {
      debug("Desactivando ");
      if (!AQSql.update("mg_artwebsite", ["activo"], [false], "referencia = '" + cursor.valueBuffer("referencia") + "'")) {
        return false;
      }
    }
    _i.cargaWebsites();
    _i.bloqueoWS_ = false;
  }
}
//// MAGENTO ////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
