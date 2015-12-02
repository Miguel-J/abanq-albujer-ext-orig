
/** @class_declaration sincro */
/////////////////////////////////////////////////////////////////
//// SINCRO /////////////////////////////////////////////////
class sincro extends multi
{
  function sincro(context)
  {
    multi(context);
  }
  function init()
  {
    return this.ctx.sincro_init();
  }
  function datosLineaVenta()
  {
    return this.ctx.sincro_datosLineaVenta();
  }
  function datosLineaVentaSincro()
  {
    return this.ctx.sincro_datosLineaVentaSincro();
  }
  function datosPago(curPago, formaPago, refVale)
  {
    return this.ctx.sincro_datosPago(curPago, formaPago, refVale);
  }
  function commonCalculateField(fN, cursor)
  {
    return this.ctx.sincro_commonCalculateField(fN, cursor);
  }
  function habilitaPorSincroCliente()
  {
    return this.ctx.sincro_habilitaPorSincroCliente();
  }
  function habilitaControlesSC(habilitar)
  {
    return this.ctx.sincro_habilitaControlesSC(habilitar);
  }
  function bufferChanged(fN)
  {
    return this.ctx.sincro_bufferChanged(fN);
  }
  function listaCamposCli()
  {
    return this.ctx.sincro_listaCamposCli();
  }
  function validateForm()
  {
    return this.ctx.sincro_validateForm();
  }
  function validaSincroCliente()
  {
    return this.ctx.sincro_validaSincroCliente();
  }
  function guardarComandaImpresion()
  {
    return this.ctx.sincro_guardarComandaImpresion();
  }
}
//// SINCRO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition sincro */
/////////////////////////////////////////////////////////////////
//// TPV SINCRO /////////////////////////////////////////////////
function sincro_init()
{
  var _i = this.iface;
  _i.__init();
  var cursor = this.cursor();

  switch (cursor.modeAccess()) {
    case cursor.Edit: {
      var idComanda = cursor.valueBuffer("idtpv_comanda");
      if (cursor.valueBuffer("sincronizada")) {
        MessageBox.warning(sys.translate("La venta está sincronizada con la central.\nNo se permitirá la edición de líneas"), MessageBox.Ok, MessageBox.NoButton);
        this.child("gbxInsercionRapida").enabled = false;
        this.child("gbxLineas").enabled = false;
        break;
      }
      if (AQUtil.sqlSelect("tpv_pagoscomanda p INNER JOIN tpv_arqueos a ON p.idtpv_arqueo = a.idtpv_arqueo", "a.sincronizado", "p.idtpv_comanda = " + idComanda, "tpv_pagoscomanda,tpv_arqueos")) {
        MessageBox.warning(sys.translate("La venta contiene al menos un pago asociado a un arqueo ya sincronizado.\nNo se permitirá la edición de líneas"), MessageBox.Ok, MessageBox.NoButton);
        this.child("gbxInsercionRapida").enabled = false;
        this.child("gbxLineas").enabled = false;
      }
      break;
    }
  }
  _i.habilitaPorSincroCliente();
}

function sincro_commonCalculateField(fN, cursor)
{
  var _i = this.iface;
  var valor;
  switch (fN) {
    case "saldonosincro": {
      if (flfact_tpv.iface.pub_esBDLocal()) {
        valor = AQUtil.sqlSelect("tpv_pagoscomanda p INNER JOIN tpv_comandas c ON p.idtpv_comanda = c.idtpv_comanda", "SUM(p.importe)", "p.refvale = '" + cursor.valueBuffer("codigo") + "' AND NOT c.sincronizada", "tpv_pagoscomanda,tpv_comandas");
        valor = isNaN(valor) ? 0 : valor;
      } else {
        MessageBox.warning(sys.translate("No puede calcularse el saldo no sincronizado en la central"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton, "AbanQ");
        valor = false;
      }
      break;
    }
    case "saldoconsumido": {
      if (flfact_tpv.iface.pub_esBDLocal()) {
        valor = cursor.valueBuffer("saldoconsumido");
      } else {
        valor = _i.__commonCalculateField(fN, cursor);
      }
      break;
    }
    case "saldopendiente": {
      if (flfact_tpv.iface.pub_esBDLocal()) {
        var saldoInicial = parseFloat(cursor.valueBuffer("total")) * (-1);
        var saldoNoSincro = cursor.valueBuffer("saldonosincro");
        var saldoConsumido = cursor.valueBuffer("saldoconsumido");
        valor = parseFloat(saldoInicial) - parseFloat(saldoConsumido) - parseFloat(saldoNoSincro);
        valor = isNaN(valor) ? 0 : valor;
      } else {
        valor = _i.__commonCalculateField(fN, cursor);
      }
      break;
    }
    default: {
      valor = _i.__commonCalculateField(fN, cursor);
    }
  }
  return valor;
}

function sincro_datosLineaVenta()
{
  debug("sincro_datosLineaVenta");
  var _i = this.iface;
  if (!_i.__datosLineaVenta()) {
    return false;
  }
  if (!_i.datosLineaVentaSincro()) {
    return false;
  }
  return true;
}

function sincro_datosLineaVentaSincro()
{
  var _i = this.iface;
  var cursor = this.cursor();
  var codComanda = cursor.valueBuffer("codigo");
  if (codComanda == "0") {
    MessageBox.warning(sys.translate("Error al generar la línea de comanda. El código de comanda no puede ser 0"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton, "AbanQ");
    return false;
  }
  _i.curLineas.setValueBuffer("codcomanda", codComanda);
  _i.curLineas.setValueBuffer("idsincro", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("idsincro", _i.curLineas));
  return true;
}

function sincro_datosPago(curPago, formaPago, refVale)
{
  var _i = this.iface;
  var cursor = this.cursor();
  if (!_i.__datosPago(curPago, formaPago, refVale)) {
    return false;
  }
  curPago.setValueBuffer("codcomanda", cursor.valueBuffer("codigo"));
  curPago.setValueBuffer("idsincro", formRecordtpv_pagoscomanda.iface.pub_commonCalculateField("idsincro", curPago));
  return true;
}

function sincro_habilitaPorSincroCliente()
{
  var _i = this.iface;
  var cursor = this.cursor();
  if (cursor.valueBuffer("ptesincrocli")) {
    _i.habilitaControlesSC(true);
  } else {
    _i.habilitaControlesSC(false);
  }
}

function sincro_habilitaControlesSC(habilitar)
{
  var _i = this.iface;
  var cursor = this.cursor();
  var listaC = _i.listaCamposCli();
  for (var i = 0; i < listaC.length; i++) {
    if (this.child(listaC[i])) {
      if (listaC[i] == "fdbNombreCliente" || listaC[i] == "fdbCifNif") {
        if (cursor.valueBuffer("codcliente") != "" && !cursor.isNull("codcliente")) {
          this.child(listaC[i]).setDisabled(true);
        } else {
          this.child(listaC[i]).setDisabled(!habilitar);
        }
      } else {
        this.child(listaC[i]).setDisabled(!habilitar);
      }
    }
  }
  return true;
}

function sincro_listaCamposCli()
{
  return ["fdbNombreCliente", "fdbCodDir", "fdbDireccion", "fdbProvincia", "fdbCiudad", "fdbCodPostal", "fdbCodPais", "fdbCifNif"];
}

function sincro_bufferChanged(fN)
{
  var _i = this.iface;
  var cursor = this.cursor();
  switch (fN) {
    case "codcliente":
    case "ptesincrocli": {
      _i.__bufferChanged(fN);
      if (!cursor.valueBuffer("ptesincrocli") && cursor.valueBuffer("codcliente") == "") {
        var listaC = _i.listaCamposCli();
        for (var i = 0; i < listaC.length; i++) {
          if (this.child(listaC[i])) {
            this.child(listaC[i]).setValue("");
          }
        }
      }
      _i.habilitaPorSincroCliente();
      break;
    }
    default: {
      _i.__bufferChanged(fN);
    }
  }
}

function sincro_validateForm()
{
  var _i = this.iface;
  if (!_i.__validateForm()) {
    return false;
  }
  if (!_i.validaSincroCliente()) {
    return false;
  }
  return true;
}

function sincro_validaSincroCliente()
{
  var cursor = this.cursor();
  if (cursor.valueBuffer("ptesincrocli")) {
    var direccion = cursor.valueBuffer("direccion");
    var nombre = cursor.valueBuffer("nombrecliente");
    var cifNif = cursor.valueBuffer("cifnif");
    if (!direccion || direccion == "" || !nombre || nombre == "" || !cifNif || cifNif == "") {
      MessageBox.warning(sys.translate("Si va a indicar datos de cliente debe informar al menos nombre, N.I.F. y dirección"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton, "AbanQ");
      return false;
    }
  }
  return true;
}

function sincro_guardarComandaImpresion()
{
  var _i = this.iface;
  var cursor = this.cursor();

  var cambiaCliente = (cursor.valueBuffer("codcliente") != cursor.valueBufferCopy("codcliente"));
  if (!cursor.valueBuffer("sincronizada") || cursor.valueBuffer("ptesincrocli") || cambiaCliente) {
    return _i.__guardarComandaImpresion();
  }

  return true;
}
//// TPV SINCRO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
