
/** @class_declaration puntosTpv */
//////////////////////////////////////////////////////////////////
//// PUNTOSTPV ///////////////////////////////////////////////////
class puntosTpv extends ivaIncluido
{
  var bloqueoCliente_;
  var valorPuntoGeneral_;
  var programaPuntos_;
  function puntosTpv(context)
  {
    ivaIncluido(context);
  }

  function init(fN)
  {
    return this.ctx.puntosTpv_init(fN);
  }
  function bufferChanged(fN: String)
  {
    return this.ctx.puntosTpv_bufferChanged(fN);
  }
  function informarTarjetaPuntos()
  {
    return this.ctx.puntosTpv_informarTarjetaPuntos();
  }
  function informarDatosClienteTarjetaPtos(fN)
  {
    return this.ctx.puntosTpv_informarDatosClienteTarjetaPtos(fN);
  }
  function datosPago(curPago, formaPago, refVale)
  {
    return this.ctx.puntosTpv_datosPago(curPago, formaPago, refVale);
  }
  function iniciaBufferCanPago(curCantidadPago)
  {
    return this.ctx.puntosTpv_iniciaBufferCanPago(curCantidadPago);
  }
  function procesaCantidadPuntos(curCantidadPago)
  {
    return this.ctx.puntosTpv_procesaCantidadPuntos(curCantidadPago);
  }
  function procesaCantidadesPago(curCantidadPago)
  {
    return this.ctx.puntosTpv_procesaCantidadesPago(curCantidadPago);
  }
  function dameImporteEntregado(curCantidadPago)
  {
    return this.ctx.puntosTpv_dameImporteEntregado(curCantidadPago);
  }
  function datosLineaVenta()
  {
    return this.ctx.puntosTpv_datosLineaVenta();
  }
  function datosLineaVentaPuntos()
  {
    return this.ctx.puntosTpv_datosLineaVentaPuntos();
  }
  function calculaPuntosVenta()
  {
    return this.ctx.puntosTpv_calculaPuntosVenta();
  }
  function sumarUno(idLinea)
  {
    return this.ctx.puntosTpv_sumarUno(idLinea);
  }
  function restarUno(idLinea)
  {
    return this.ctx.puntosTpv_restarUno(idLinea);
  }

}
//// PUNTOSTPV ///////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_definition puntosTpv */
/////////////////////////////////////////////////////////////////
//// PUNTOS TPV /////////////////////////////////////////////////

function puntosTpv_init()
{
  var _i = this.iface;
  var cursor = this.cursor();
  _i.__init();

  _i.bloqueoCliente_ = false;
  _i.valorPuntoGeneral_ =  flfactalma.iface.pub_valorDefectoAlmacen("valorpuntos");
  _i.programaPuntos_ =  flfactalma.iface.pub_valorDefectoAlmacen("programapuntos");

  if (cursor.modeAccess() == cursor.Insert) {
    _i.informarTarjetaPuntos();
  }

}

function puntosTpv_bufferChanged(fN: String)
{
  var _i = this.iface;
  var cursor = this.cursor();
  switch (fN) {
    case "tipopago": {
      if (cursor.valueBuffer("tipopago") == "Efectivo") {
        var pagoEfectivo = AQUtil.sqlSelect("tpv_datosgenerales", "pagoefectivo", "1=1");
        if (!pagoEfectivo || pagoEfectivo == "") {
          MessageBox.information(AQUtil.translate("scripts", "No tiene configurada la forma de pago efectivo en el formulario de datos generales"), MessageBox.Ok, MessageBox.NoButton);
          this.child("pbnPagar").setDisabled(true);
        } else {
          _i.verificarHabilitaciones();
        }
        cursor.setValueBuffer("codpago", pagoEfectivo);
      } else if (cursor.valueBuffer("tipopago") == "Tarjeta") {
        var pagoTarjeta = AQUtil.sqlSelect("tpv_datosgenerales", "pagotarjeta", "1=1");
        if (!pagoTarjeta || pagoTarjeta == "") {
          MessageBox.information(AQUtil.translate("scripts", "No tiene configurada la forma de pago tarjeta en el formulario de datos generales"), MessageBox.Ok, MessageBox.NoButton);
          this.child("pbnPagar").setDisabled(true);
        } else {
          _i.verificarHabilitaciones();
        }
        cursor.setValueBuffer("codpago", pagoTarjeta);
      } else if (cursor.valueBuffer("tipopago") == "Vale") {
        var pagoVale = AQUtil.sqlSelect("tpv_datosgenerales", "pagovale", "1=1");
        if (!pagoVale || pagoVale == "") {
          MessageBox.information(AQUtil.translate("scripts", "No tiene configurada la forma de pago vale en el formulario de datos generales"), MessageBox.Ok, MessageBox.NoButton);
          this.child("pbnPagar").setDisabled(true);
        } else {
          _i.verificarHabilitaciones();
        }
        cursor.setValueBuffer("codpago", pagoVale);
      } else {
        var pagoPuntos = AQUtil.sqlSelect("tpv_datosgenerales", "pagopunto", "1=1");
        if (!pagoPuntos || pagoPuntos == "") {
          MessageBox.information(AQUtil.translate("scripts", "No tiene configurada la forma de pago Puntos en el formulario de datos generales"), MessageBox.Ok, MessageBox.NoButton);
          this.child("pbnPagar").setDisabled(true);
        } else {
          _i.verificarHabilitaciones();
        }
        cursor.setValueBuffer("codpago", pagoPuntos);
      }
      break;
    }
    case "codtarjetapuntos": {
      if (!_i.bloqueoCliente_) {
        _i.bloqueoCliente_ = true;
        _i.informarDatosClienteTarjetaPtos("tarjeta");
        _i.__bufferChanged("codcliente");
        _i.bloqueoCliente_ = false;
      }
      break;
    }
    case "codcliente": {
      if (!_i.bloqueoCliente_) {
        _i.bloqueoCliente_ = true;
        _i.informarDatosClienteTarjetaPtos("cliente");
        _i.__bufferChanged(fN);
        _i.bloqueoCliente_ = false;
      }
      break;
    }
    default: {
      _i.__bufferChanged(fN);
    }
  }
}

function puntosTpv_informarTarjetaPuntos()
{
  var _i = this.iface;
  var cursor = this.cursor();
  var codCliente = cursor.valueBuffer("codcliente");

  _i.bloqueoCliente_ = true;
  codTarjeta = AQUtil.sqlSelect("clientes", "codtarjetapuntos", "codcliente = '" + codCliente + "'");
  if (!codTarjeta) {
    codTarjeta = "";
  }
  cursor.setValueBuffer("codtarjetapuntos", codTarjeta);

  _i.bloqueoCliente_ = false;
}

function puntosTpv_informarDatosClienteTarjetaPtos(fN)
{
  var _i = this.iface;
  var cursor = this.cursor();
  var codTarjeta = cursor.valueBuffer("codtarjetapuntos");
  var codCliente = cursor.valueBuffer("codcliente");

  switch (fN) {
    case "cliente": {
      codTarjeta = AQUtil.sqlSelect("clientes", "codtarjetapuntos", "codcliente = '" + codCliente + "'");
      if (!codTarjeta) {
        codTarjeta = "";
      }
      cursor.setValueBuffer("codtarjetapuntos", codTarjeta);
      break;
    }
    case "tarjeta": {
      codCliente = AQUtil.sqlSelect("clientes", "codcliente", "codtarjetapuntos = '" + codTarjeta + "'");
      if (!codCliente) {
        cursor.setNull("codcliente");
        break;
      }
      cursor.setValueBuffer("codcliente", codCliente);
      break;
    }
  }
}

function puntosTpv_dameImporteEntregado(curCantidadPago)
{
  var _i = this.iface;
  var iE = _i.__dameImporteEntregado(curCantidadPago);
  var importePuntos = curCantidadPago.isNull("importepuntos") ? 0 : curCantidadPago.valueBuffer("importepuntos");
  return  iE + importePuntos;
}

function puntosTpv_iniciaBufferCanPago(curCantidadPago)
{
  var _i = this.iface;
  var cursor = this.cursor();
  if (!_i.__iniciaBufferCanPago(curCantidadPago)) {
    return false;
  }
  var saldoPuntos = AQUtil.sqlSelect("tpv_tarjetaspuntos", "saldopuntos", "codtarjetapuntos = '" + cursor.valueBuffer("codtarjetapuntos") + "'");
  saldoPuntos = isNaN(saldoPuntos) ? 0 : saldoPuntos;

  curCantidadPago.setNull("importepuntos");
  curCantidadPago.setValueBuffer("saldopuntos", saldoPuntos);
  return true;
}

function puntosTpv_procesaCantidadPuntos(curCantidadPago)
{
  var _i = this.iface;
  var cursor = this.cursor();

  var importePuntos = curCantidadPago.isNull("importepuntos") ? 0 : curCantidadPago.valueBuffer("importepuntos");
  if (importePuntos != 0) {
    if (!_i.crearPago(importePuntos, "Puntos")) {
      return false;
    }
  }
  return true;
}

function puntosTpv_procesaCantidadesPago(curCantidadPago)
{
  var _i = this.iface;

  if (!_i.__procesaCantidadesPago(curCantidadPago)) {
    return false;
  }

  if (!_i.procesaCantidadPuntos(curCantidadPago)) {
    return false;
  }
  return true;
}

function puntosTpv_datosPago(curPago, formaPago, refVale)
{
  var _i = this.iface;

  if (!_i.__datosPago(curPago, formaPago, refVale)) {
    return false;
  }
  switch (formaPago) {
    case "Puntos": {
      var cursor = this.cursor();
      var pagoPuntos = AQUtil.sqlSelect("tpv_datosgenerales", "pagopunto", "1=1");
      if (!pagoPuntos || pagoPuntos == "") {
        MessageBox.warning(sys.translate("No tiene configurada la forma de pago por puntos en el formulario de datos generales"), MessageBox.Ok, MessageBox.NoButton);
      }
      var codTarjetaPuntos = cursor.valueBuffer("codtarjetapuntos");
      if (!codTarjetaPuntos || codTarjetaPuntos == "") {
        MessageBox.warning(sys.translate("Para pagar con puntos debe especificar una tarjeta de puntos"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton, "AbanQ");
      }
      curPago.setValueBuffer("codpago", pagoPuntos);
      curPago.setValueBuffer("codtarjetapuntos", codTarjetaPuntos);
      break;
    }
  }
  return true;
}

function puntosTpv_datosLineaVenta()
{
  var _i = this.iface;

  if (!_i.__datosLineaVenta()) {
    return false;
  }
  if (!_i.datosLineaVentaPuntos()) {
    return false;
  }
  return true;
}

function puntosTpv_datosLineaVentaPuntos()
{
  var _i = this.iface;
  var cursor = this.cursor();

  _i.curLineas.setValueBuffer("canpuntos", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("canpuntos", _i.curLineas));
  return true;
}

function puntosTpv_calculaPuntosVenta()
{
  var _i = this.iface;
  var cursor = this.cursor();

  var canPuntos = AQUtil.sqlSelect("tpv_lineascomanda", "SUM(canpuntos)", "idtpv_comanda = " + cursor.valueBuffer("idtpv_comanda"));

  return canPuntos;
}

function puntosTpv_sumarUno(idLinea)
{
  var _i = this.iface;
  var cursor = this.cursor();

  if (!_i.__sumarUno(idLinea)) {
    return false;
  }

  _i.curLineas.select("idtpv_linea = " + idLinea);
  _i.curLineas.first();

  _i.curLineas.setModeAccess(_i.curLineas.Edit);
  _i.curLineas.refreshBuffer();

  _i.curLineas.setValueBuffer("canpuntos", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("canpuntos", _i.curLineas));

  if (!_i.curLineas.commitBuffer()) {
    return;
  }
  this.child("tdbLineasComanda").refresh();
  return true;
}

function puntosTpv_restarUno(idLinea)
{
  var _i = this.iface;
  var cursor = this.cursor();

  if (!_i.__restarUno(idLinea)) {
    return false;
  }

  _i.curLineas.select("idtpv_linea = " + idLinea);
  _i.curLineas.first();

  _i.curLineas.setModeAccess(_i.curLineas.Edit);
  _i.curLineas.refreshBuffer();

  _i.curLineas.setValueBuffer("canpuntos", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("canpuntos", _i.curLineas));

  if (!_i.curLineas.commitBuffer()) {
    return;
  }
  this.child("tdbLineasComanda").refresh();
  return true;
}
//// PUNTOS TPV /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
