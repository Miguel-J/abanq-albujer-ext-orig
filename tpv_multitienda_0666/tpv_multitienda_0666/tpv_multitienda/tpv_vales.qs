
/** @class_declaration multi */
/////////////////////////////////////////////////////////////////
//// TPV MULTITIENDA ///////////////////////////////////////
class multi extends oficial
{
  function multi(context)
  {
    oficial(context);
  }
  function incluirDatosLinea(curLinea, curLineaPadre)
  {
    return this.ctx.multi_incluirDatosLinea(curLinea, curLineaPadre);
  }
}
//// TPV MULTITIENDA ///////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition multi */
/////////////////////////////////////////////////////////////////
//// TPV MULTITIENDA ///////////////////////////////////////
function multi_incluirDatosLinea(curLinea, curLineaPadre)
{
  var _i = this.iface;
  var cursor = this.cursor();

  if (!_i.__incluirDatosLinea(curLinea, curLineaPadre))
    return false;

  var idTpvComanda = cursor.valueBuffer("idtpv_comanda");
  var codTienda = AQUtil.sqlSelect("tpv_comandas", "codtienda", "idtpv_comanda = " + idTpvComanda);
  if (codTienda && codTienda != "")
    curLinea.setValueBuffer("codtienda", codTienda);

  return true;
}
//// TPV MULTITIENDA ///////////////////////////////////////
/////////////////////////////////////////////////////////////////
