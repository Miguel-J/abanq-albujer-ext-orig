
/** @class_declaration multi */
/////////////////////////////////////////////////////////////////
//// MULTITIENDA /////////////////////////////////////////////////
class multi extends oficial
{
  var hayCampoEmpresa_;
  function multi(context)
  {
    oficial(context);
  }
  function init()
  {
    return this.ctx.multi_init();
  }
  function validateForm()
  {
    return this.ctx.multi_validateForm();
  }
  function cargaHayEmpresa()
  {
    return this.ctx.multi_cargaHayEmpresa();
  }
  function validaTiendaEmpresa()
  {
    return this.ctx.multi_validaTiendaEmpresa();
  }
}
//// MULTITIENDA /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition multi */
/////////////////////////////////////////////////////////////////
//// MULTITIENDA ////////////////////////////////////////////////
function multi_validateForm()
{
  var _i = this.iface;

  if (!_i.__validateForm()) {
    return false;
  }
  if (!_i.validaTiendaEmpresa()) {
    return false;
  }
  return true;
}

function multi_init()
{
  var _i = this.iface;
  _i.__init();
  _i.cargaHayEmpresa();
}

function multi_cargaHayEmpresa()
{
  var _i = this.iface;

  var mgr = aqApp.db().manager();

  var mtdT = mgr.metadata("almacenes");
  var mtdF = mtdT.field("idempresa");

  _i.hayCampoEmpresa_ = mtdF ? true : false;
}

function multi_validaTiendaEmpresa()
{
  var _i = this.iface;
  var cursor = this.cursor();

  if (!_i.hayCampoEmpresa_) {
    return true;
  }
  var codTienda = cursor.valueBuffer("codtienda");
  var idEmpresa = cursor.valueBuffer("idempresa");
  if (codTienda && idEmpresa) {
    var idEmpresaT = AQUtil.sqlSelect("tpv_tiendas", "idempresa", "codtienda = '" + codTienda + "'");
    if (idEmpresaT != idEmpresa) {
      MessageBox.warning(sys.translate("Las empresas de tienda y almacén no coinciden"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton, "AbanQ");
      return false;
    }
  }
  return true;
}
//// MULTITIENDA ////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
