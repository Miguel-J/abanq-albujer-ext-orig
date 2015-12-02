
/** @class_declaration pagosRemesa */
/////////////////////////////////////////////////////////////////
//// PAGOS_REMESA ///////////////////////////////////////////////
class pagosRemesa extends oficial
{
  function pagosRemesa(context)
  {
    oficial(context);
  }
  function asociarReciboRemesa(idRecibo: String, curRemesa: FLSqlCursor): Boolean {
    return this.ctx.pagosRemesa_asociarReciboRemesa(idRecibo, curRemesa);
  }
  function excluirReciboRemesa(idRecibo: String, idRemesa: String): Boolean {
    return this.ctx.pagosRemesa_excluirReciboRemesa(idRecibo, idRemesa);
  }
}
//// PAGOS_REMESA ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition pagosRemesa */
/////////////////////////////////////////////////////////////////
//// PAGOS_REMESA ///////////////////////////////////////////////
function pagosRemesa_asociarReciboRemesa(idRecibo: String, curRemesa: FLSqlCursor): Boolean {
  var util: FLUtil = new FLUtil;
  var idRemesa: String = curRemesa.valueBuffer("idremesa");
  debug("idRemesa " + idRemesa);
  if (util.sqlSelect("reciboscli", "coddivisa", "idrecibo = " + idRecibo) != curRemesa.valueBuffer("coddivisa"))
  {
    MessageBox.warning(util.translate("scripts", "No es posible incluir el recibo.\nLa divisa del recibo y de la remesa deben ser la misma."), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return;
  }

  var datosCuenta: Array = flfactppal.iface.pub_ejecutarQry("cuentasbanco", "ctaentidad,ctaagencia,cuenta", "codcuenta = '" + curRemesa.valueBuffer("codcuenta") + "'");
  if (datosCuenta.result != 1)
    return false;
  var dc: String = util.calcularDC(datosCuenta.ctaentidad + datosCuenta.ctaagencia) + util.calcularDC(datosCuenta.cuenta);

  var curRecibos: FLSqlCursor = new FLSqlCursor("reciboscli");
  var idFactura: Number;

  var fecha: String = curRemesa.valueBuffer("fecha");
  if (!this.iface.curPagosDev)
    this.iface.curPagosDev = new FLSqlCursor("pagosdevolcli");
  this.iface.curPagosDev.select("idrecibo = " + idRecibo + " ORDER BY fecha,idpagodevol");
  if (this.iface.curPagosDev.last())
  {
    if (util.daysTo(this.iface.curPagosDev.valueBuffer("fecha"), fecha) < 0) {
      var codRecibo: String = util.sqlSelect("reciboscli", "codigo", "idrecibo = " + idRecibo);
      MessageBox.warning(util.translate("scripts", "Existen pagos o devoluciones con fecha igual o porterior a la de la remesa para el recibo %1").arg(codRecibo), MessageBox.Ok, MessageBox.NoButton);
      return false;
    }
  }

  curRecibos.select("idrecibo = " + idRecibo);
  if (curRecibos.next())
  {
    curRecibos.setActivatedCheckIntegrity(false);
    curRecibos.setModeAccess(curRecibos.Edit);
    curRecibos.refreshBuffer();
    curRecibos.setValueBuffer("idremesa", idRemesa);
    if (this.iface.pagoIndirecto_)
      curRecibos.setValueBuffer("estado", "Remesado");
    else
      curRecibos.setValueBuffer("estado", "Pagado");
    idFactura = curRecibos.valueBuffer("idfactura");
    curRecibos.commitBuffer();
  }

  if (this.iface.curPagosDev.last())
  {
    this.iface.curPagosDev.setUnLock("editable", false);
  }
  this.iface.curPagosDev.setModeAccess(this.iface.curPagosDev.Insert);
  this.iface.curPagosDev.refreshBuffer();
  this.iface.curPagosDev.setValueBuffer("idrecibo", idRecibo);
  this.iface.curPagosDev.setValueBuffer("fecha", fecha);

  if (this.iface.pagoIndirecto_)
    this.iface.curPagosDev.setValueBuffer("tipo", "Remesa");
  else
    this.iface.curPagosDev.setValueBuffer("tipo", "Pago");

  this.iface.curPagosDev.setValueBuffer("codcuenta", curRemesa.valueBuffer("codcuenta"));
  this.iface.curPagosDev.setValueBuffer("ctaentidad", datosCuenta.ctaentidad);
  this.iface.curPagosDev.setValueBuffer("ctaagencia", datosCuenta.ctaagencia);
  this.iface.curPagosDev.setValueBuffer("dc", dc);
  this.iface.curPagosDev.setValueBuffer("cuenta", datosCuenta.cuenta);
  this.iface.curPagosDev.setValueBuffer("idremesa", idRemesa);
  this.iface.curPagosDev.setValueBuffer("nogenerarasiento", curRemesa.valueBuffer("nogenerarasiento"));
  if (parseFloat(curRemesa.valueBuffer("idsubcuenta")) == 0)
  {
    this.iface.curPagosDev.setNull("idsubcuenta");
    this.iface.curPagosDev.setNull("codsubcuenta");
  } else {
    this.iface.curPagosDev.setValueBuffer("idsubcuenta", curRemesa.valueBuffer("idsubcuenta"));
    this.iface.curPagosDev.setValueBuffer("codsubcuenta", curRemesa.valueBuffer("codsubcuenta"));
  }
  if (!this.iface.datosPagosDev(idRecibo, curRemesa))
    return false;
  if (!this.iface.curPagosDev.commitBuffer())
    return false;
  return true;
}

function pagosRemesa_excluirReciboRemesa(idRecibo: String, idRemesa: String): Boolean {
  var util: FLUtil = new FLUtil;

  var estado: String = util.sqlSelect("reciboscli", "estado", "idrecibo = " + idRecibo);
  if (estado != "Remesado")
  {
    MessageBox.warning(util.translate("scripts", "No se puede sacar un recibo en estado %1 de la remesa. Debe estar en estado Remesado.").arg(estado), MessageBox.Ok, MessageBox.NoButton);
    return false;
  } else
    return this.iface.__excluirReciboRemesa(idRecibo, idRemesa);
  return true;
}
//// PAGOS_REMESA ////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
