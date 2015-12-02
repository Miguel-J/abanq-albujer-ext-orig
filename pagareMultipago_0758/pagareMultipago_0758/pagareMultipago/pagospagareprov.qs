
/** @class_declaration pagaresMultipago */
/////////////////////////////////////////////////////////////////
//// PAGARES MULTIPAGO  ////////////////////////////////////////
class pagaresMultipago extends oficial
{

  var importeInicial_;
  function pagaresMultipago(context)
  {
    oficial(context);
  }
  function init()
  {
    this.ctx.pagaresMultipago_init();
  }
  function datosAperturaFormulario()
  {
    return this.ctx.pagaresMultipago_datosAperturaFormulario();
  }
  function bufferChanged(fN)
  {
    return this.ctx.pagaresMultipago_bufferChanged(fN);
  }
  function calculateField(fN)
  {
    return this.ctx.pagaresMultipago_calculateField(fN);
  }
  function validateForm()
  {
    return this.ctx.pagaresMultipago_validateForm();
  }/**
  function ponerFechaPagoDevolucion() {
    return this.ctx.pagaresMultipago_ponerFechaPagoDevolucion();
  }*/
  function comprobarFechas()
  {
    return this.ctx.pagaresMultipago_comprobarFechas();
  }
  function comprobarImporteDevolucion()
  {
    return this.ctx.pagaresMultipago_comprobarImporteDevolucion();
  }
  function comprobarImportePago()
  {
    return this.ctx.pagaresMultipago_comprobarImportePago();
  }
  function comprobarFechasValidate()
  {
    return this.ctx.pagaresMultipago_comprobarFechasValidate();
  }
}

//// PAGARES MULTIPAGO  /////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition pagaresMultipago */
/////////////////////////////////////////////////////////////////
//// PAGARES MULTIPAGO //////////////////////////////////////////

function pagaresMultipago_init()
{
  var _i = this.iface;
  var cursor = this.cursor();

  _i.__init();

}

function pagaresMultipago_datosAperturaFormulario()
{
  var _i = this.iface;
  var cursor = this.cursor();

  switch (cursor.modeAccess()) {
    case cursor.Insert: {
      this.child("fdbCodCuenta").setValue(_i.calculateField("codcuenta"));
      if (_i.contabActivada) {
        this.child("fdbIdSubcuenta").setValue(_i.calculateField("idsubcuentadefecto"));
      }
      sys.setObjText(this, "fdbImporte", _i.calculateField("importe"));
      _i.importeInicial_ = parseFloat(_i.calculateField("importe"));
      break;
    }
    case cursor.Edit: {
      if (cursor.valueBuffer("tipo") == "Devolución") {
        this.child("fdbEstado").setDisabled(true);
      }
      _i.importeInicial_ = parseFloat(_i.calculateField("importe")) + parseFloat(cursor.valueBuffer("importe"));
      break;
    }
  }
  this.child("fdbTipo").setDisabled(false);

  if (cursor.valueBuffer("Estado") == "Pendiente") {
    this.child("fdbFecha").setDisabled(true);
    this.child("fdbFechaVencimiento").setDisabled(true);
  } else {
    this.child("fdbFecha").setDisabled(false);
    this.child("fdbFechaVencimiento").setDisabled(false);
  }
}

function pagaresMultipago_bufferChanged(fN)
{
  var _i = this.iface;
  var cursor = this.cursor();

  switch (fN) {
    case "tipo": {
      if (cursor.valueBuffer("tipo") == "Pago") {
        this.child("fdbEstado").setValue("Pendiente");
        this.child("fdbEstado").setDisabled(false);
      } else {
        this.child("fdbEstado").setValue("Pagado");
        this.child("fdbEstado").setDisabled(true);
      }
      sys.setObjText(this, "fdbImporte", _i.calculateField("importe"));
      break;
    }
    case "estado": {
      if (cursor.valueBuffer("estado") == "Pendiente") {
        this.child("fdbFecha").setDisabled(true);
        this.child("fdbFechaVencimiento").setDisabled(true);
        sys.setObjText(this, "fdbFecha", "");
        sys.setObjText(this, "fdbFechaVencimiento", "");
      } else {
        this.child("fdbFecha").setDisabled(false);
        this.child("fdbFechaVencimiento").setDisabled(false);

        var hoy = new Date;
        sys.setObjText(this, "fdbFecha", hoy);
        sys.setObjText(this, "fdbFechaVencimiento", AQUtil.addDays(hoy, 1));
      }
      break;
    }
    default: {
      _i.__bufferChanged(fN);
    }
  }
}

function pagaresMultipago_validateForm()
{
  var _i = this.iface;
  var cursor = this.cursor();

  /**
  if(!_i.ponerFechaPagoDevolucion()){
    return false;
  }*/
  if (!_i.comprobarFechas()) {
    return false;
  }
  if (!_i.comprobarImporteDevolucion()) {
    return false;
  }
  if (!_i.comprobarImportePago()) {
    return false;
  }
  if (!_i.__validateForm()) {
    return false;
  }
  return true;
}

/**
function pagaresMultipago_ponerFechaPagoDevolucion()
{
  var _i = this.iface;
  var cursor = this.cursor();

  if(((cursor.valueBuffer("tipo") == "Pago" && cursor.valueBuffer("estado") == "Pagado") || (cursor.valueBuffer("tipo") == "Devolución")) && (!cursor.valueBuffer("fecha") || cursor.valueBuffer("fecha") == 0)){
    var hoy = new Date();
    cursor.setValueBuffer("fecha", hoy);
  }
  return true;
}*/

function pagaresMultipago_comprobarFechas()
{
  var _i = this.iface;
  var cursor = this.cursor();

  if (cursor.valueBuffer("estado") == "Pagado") {
    if (cursor.valueBuffer("fecha") > cursor.valueBuffer("fechavencimiento")) {
      sys.infoMsgBox("La fecha de Pago/Devolución no puede ser inferior a la del Vencimiento.");
      return false;
    }
  }
  return true;
}

function pagaresMultipago_comprobarImporteDevolucion()
{
  var _i = this.iface;
  var cursor = this.cursor();

  if (cursor.valueBuffer("tipo") == "Pago") {
    return true;
  }

  var sumPago = AQUtil.sqlSelect("pagospagareprov", "SUM(importe)", "tipo = 'Pago'");
  var sumDevolucion = AQUtil.sqlSelect("pagospagareprov", "SUM(importe)", "tipo = 'Devolución'");

  var saldoRestante = parseFloat(sumPago) - parseFloat(sumDevolucion);
  var importeDevolucion = parseFloat(cursor.valueBuffer("importe"));

  if (importeDevolucion > saldoRestante) {
    MessageBox.information(sys.translate("El importe de la devolución no puede ser superior a lo pagado (%1).").arg(AQUtil.roundFieldValue(saldoRestante, "pagospagareprov", "importe"), MessageBox.Ok, MessageBox.NoButton));
    return false;
  }

  return true;
}

function pagaresMultipago_calculateField(fN)
{
  var _i = this.iface;
  var cursor = this.cursor();

  var res;
  switch (fN) {
    case "importe": {
      var idPagare = cursor.valueBuffer("idpagare");
      var sumPago = AQUtil.sqlSelect("pagospagareprov", "SUM(importe)", "tipo = 'Pago' AND idpagare = '" + idPagare + "'");
      var sumDevolucion = AQUtil.sqlSelect("pagospagareprov", "SUM(importe)", "tipo = 'Devolución' AND idpagare = '" + idPagare + "'");
      var totalPagare = AQUtil.sqlSelect("pagaresprov", "total", "idpagare = '" + cursor.valueBuffer("idpagare") + "'");

      if (isNaN(sumPago)) {
        sumPago = 0;
      }
      if (isNaN(sumDevolucion)) {
        sumDevolucion = 0;
      }
      if (isNaN(totalPagare)) {
        totalPagare = 0;
      }
      if (cursor.valueBuffer("tipo") == "Pago") {
        res = parseFloat(totalPagare) - (parseFloat(sumPago) - parseFloat(sumDevolucion));
      } else {
        res = parseFloat(sumPago) - parseFloat(sumDevolucion);
      }
      break;
    }
    default: {
      res = _i.__calculateField(fN);
    }
  }
  return res;
}

function pagaresMultipago_comprobarFechasValidate()
{
  var _i = this.iface;
  var cursor = this.cursor();

  if (cursor.valueBuffer("estado") != "Pagado") {
    return true;
  } else {
    return _i.__comprobarFechasValidate();
  }
}

/** \C
Si la suma de pagos - la suma de devoluciones es mayor que el total del pagaré no permitir guardar.
\end */
function pagaresMultipago_comprobarImportePago()
{
  var _i = this.iface;
  var cursor = this.cursor();

  if (cursor.valueBuffer("tipo") != "Pago") {
    return true;
  }

  var idPagare = cursor.valueBuffer("idpagare");

  var importe = parseFloat(cursor.valueBuffer("importe"));

  if (importe > _i.importeInicial_) {
    sys.warnMsgBox("El importe del pago debe de ser como máximo el importe restante del pagaré por pagar (" + AQUtil.formatoMiles(AQUtil.roundFieldValue(_i.importeInicial_, "pagospagareprov", "importe")) + ")");
    return false;
  }
  if (importe <= 0) {
    sys.warnMsgBox("El importe del pago debe de ser mayor que 0,00");
    return false;
  }

  return true;
}

//// PAGARES MULTIPAGO //////////////////////////////////////////
/////////////////////////////////////////////////////////////////
