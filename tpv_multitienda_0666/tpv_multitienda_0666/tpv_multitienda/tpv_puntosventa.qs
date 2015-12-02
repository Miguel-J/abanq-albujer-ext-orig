
/** @class_declaration tiendas */
/////////////////////////////////////////////////////////////////
//// TPV_MULTITIENDA ////////////////////////////////////////////
class tiendas extends oficial
{
  function tiendas(context)
  {
    oficial(context);
  }
  function validateForm(): Boolean {
    return this.ctx.tiendas_validateForm();
  }
  function comprobarAlmacenTienda(): Boolean {
    return this.ctx.tiendas_comprobarAlmacenTienda();
  }
}
//// TPV_MULTITIENDA ////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition tiendas */
/////////////////////////////////////////////////////////////////
//// TPV_MULTITIENDA ////////////////////////////////////////////
function tiendas_validateForm(): Boolean {
  //  if (!this.iface.__validateForm()) {
  //    return false;
  //  }
  if (!this.iface.comprobarAlmacenTienda())
  {
    return false;
  }
  return true;
}

function tiendas_comprobarAlmacenTienda(): Boolean {
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();
  var codAlmacen: String = cursor.valueBuffer("codalmacen");
  if (!codAlmacen || codAlmacen == "")
  {
    MessageBox.warning(util.translate("scripts", "Debe indicar el almacén"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  var codTienda: String = cursor.valueBuffer("codtienda");
  if (!codTienda || codTienda == "")
  {
    MessageBox.warning(util.translate("scripts", "Debe indicar la tienda"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  if (!util.sqlSelect("tpv_almacenestienda", "codtienda", "codtienda = '" + codTienda + "' AND codalmacen = '" + codAlmacen + "'"))
  {
    MessageBox.warning(util.translate("scripts", "El almacén %1 no corresponde a la tienda %2").arg(codAlmacen).arg(codTienda), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  return true;
}
//// TPV_MULTITIENDA ////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
