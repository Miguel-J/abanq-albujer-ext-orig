
/** @class_declaration multitienda */
/////////////////////////////////////////////////////////////////
//// MULTITIENDA ////////////////////////////////////////////
class multitienda extends oficial
{
  function multitienda(context)
  {
    oficial(context);
  }
  function init()
  {
    return this.ctx.multitienda_init();
  }
  function informarEmpresa()
  {
    return this.ctx.multitienda_informarEmpresa();
  }
  function validateForm()
  {
    return this.ctx.multitienda_validateForm();
  }
}
//// MULTITIENDA ////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition multitienda */
//////////////////////////////////////////////////////////////////
//// MULTITIENDA /////////////////////////////////////////////
function multitienda_init()
{
  var _i = this.iface;
  var cursor = this.cursor();

  _i.__init();

  switch (cursor.modeAccess()) {
    case cursor.Insert: {
      _i.informarEmpresa();
      break;
    }
  }
}

function multitienda_informarEmpresa()
{
  var idEmpresa = AQUtil.sqlSelect("empresa", "id", "1 = 1");
  if (!idEmpresa || idEmpresa == 0)
    return;

  this.cursor().setValueBuffer("idempresa", idEmpresa);
}

function multitienda_validateForm()
{
  var _i = this.iface;
  var cursor = this.cursor();

  if (!_i.__validateForm()) {
    return false;
  }

  cursor.commitBufferCursorRelation();
  var codTienda = cursor.valueBuffer("codtienda");
  var codAlmacenPpal = cursor.valueBuffer("codalmacen");
  var hayAlmacenPpal = AQUtil.sqlSelect("tpv_almacenestienda", "codalmacen", "codtienda = '" + codTienda + "' AND codalmacen = '" + codAlmacenPpal + "'");
  if (!hayAlmacenPpal) {
    var curAlmacenes = this.child("tableDBRecords").cursor();
    curAlmacenes.setModeAccess(curAlmacenes.Insert);
    curAlmacenes.refreshBuffer();
    curAlmacenes.setValueBuffer("codtienda", codTienda);
    curAlmacenes.setValueBuffer("codalmacen", codAlmacenPpal);
    curAlmacenes.setValueBuffer("nombre", this.child("fdbNombreAlmacen").value());
    if (!curAlmacenes.commitBuffer()) {
      return false;
    }
    this.child("tableDBRecords").refresh();
  }
  return true;
}

//// MULTITIENDA /////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
