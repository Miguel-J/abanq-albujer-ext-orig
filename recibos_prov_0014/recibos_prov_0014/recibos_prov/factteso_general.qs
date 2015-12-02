
/** @class_declaration provee */
/////////////////////////////////////////////////////////////////
//// RECIBOS PROVEEDOR //////////////////////////////////////////
class provee extends oficial
{
  function provee(context)
  {
    oficial(context);
  }
  function init()
  {
    this.ctx.provee_init();
  }
  function tbnActFechasPago_clicked()
  {
    return this.ctx.provee_tbnActFechasPago_clicked();
  }
  function actualizarFechasPagoProv()
  {
    return this.ctx.provee_actualizarFechasPagoProv();
  }
}
//// RECIBOS PROVEEDOR //////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition provee */
/////////////////////////////////////////////////////////////////
//// RECIBOS PROVEEDOR //////////////////////////////////////////
function provee_init()
{
  this.iface.__init();
  connect(this.child("tbnActFechasPago"), "clicked()", this, "iface.tbnActFechasPago_clicked");
}

function provee_tbnActFechasPago_clicked()
{
  var util = new FLUtil;
  var res = MessageBox.warning(util.translate("scripts", "Va a actualizar los campos de fecha y cuenta de pago de todos los recibos de proveedor.\n¿Está seguro?"), MessageBox.Yes, MessageBox.No);
  if (res != MessageBox.Yes) {
    return;
  }
  var curT = new FLSqlCursor("empresa");
  curT.transaction(false);
  try {
    if (this.iface.actualizarFechasPagoProv()) {
      curT.commit();
    } else {
      curT.rollback();
      MessageBox.critical(util.translate("scripts", "Hubo un error en la actualización de fechas y cuentas de pago"), MessageBox.Ok, MessageBox.NoButton);
      return;
    }
  } catch (e) {
    curT.rollback();
    MessageBox.critical(util.translate("scripts", "Hubo un error en la actualización de fechas y cuentas de pago") + "\n" + e, MessageBox.Ok, MessageBox.NoButton);
    return;
  }
  MessageBox.information(util.translate("scripts", "Los recibos han sido actalizados correctamente"), MessageBox.Ok, MessageBox.NoButton);
}

function provee_actualizarFechasPagoProv()
{
  var util = new FLUtil;
  flfactteso.iface.curReciboProv = new FLSqlCursor("recibosprov");
  var curRecibo = flfactteso.iface.curReciboProv;
  curRecibo.setActivatedCommitActions(false);
  curRecibo.setActivatedCheckIntegrity(false);
  curRecibo.setForwardOnly(true);
  curRecibo.select();
  var totalRecibos = curRecibo.size();
  var paso = 0;
  util.createProgressDialog(util.translate("scripts", "Actualizando recibos"), totalRecibos);
  while (curRecibo.next()) {
    curRecibo.setModeAccess(curRecibo.Edit);
    curRecibo.refreshBuffer();
    if (!flfactteso.iface.totalesReciboProv()) {
      return false;
    }
    if (!curRecibo.commitBuffer()) {
      util.destroyProgressDialog();
      return false;
    }
    util.setProgress(++paso);
  }
  util.destroyProgressDialog();
  return true;
}
//// RECIBOS PROVEEDOR //////////////////////////////////////////
/////////////////////////////////////////////////////////////////
