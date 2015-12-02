
/** @class_declaration offline */
/////////////////////////////////////////////////////////////////
//// TPV OFFLINE ////////////////////////////////////////////////
class offline extends oficial
{
  function offline(context)
  {
    oficial(context);
  }
  function init()
  {
    return this.ctx.offline_init();
  }
  function tbnSincronizarCat_clicked()
  {
    return this.ctx.offline_tbnSincronizarCat_clicked();
  }
}
//// TPV OFFLINE ////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition offline */
/////////////////////////////////////////////////////////////////
//// TPV OFFLINE ////////////////////////////////////////////////
function offline_init()
{
  this.iface.__init();
  connect(this.child("tbnSincronizarCat"), "clicked()", this, "iface.tbnSincronizarCat_clicked");

  if (flfact_tpv.iface.pub_valorDefectoTPV("bdoffline")) {
    this.child("gbxSincroCat").close();
  }
}

function offline_tbnSincronizarCat_clicked()
{
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();
  var codTienda: String = cursor.valueBuffer("codtienda");
  if (!codTienda) {
    return false;
  }

  var res: Number = MessageBox.information(util.translate("scripts", "Va a sincronizar el catálogo de la tienda %1.\n¿Está seguro?").arg(codTienda), MessageBox.Yes, MessageBox.No);
  if (res != MessageBox.Yes) {
    return false;
  }
  if (!formtpv_tiendas.iface.pub_sincroCatalogo(cursor)) {
    return false;
  }
  var hoy: Date = new Date;
  this.child("fdbUltSincroCat").setValue(hoy);
}
//// TPV OFFLINE ////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
