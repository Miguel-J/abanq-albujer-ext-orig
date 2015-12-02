
/** @class_declaration puntosTpv */
//////////////////////////////////////////////////////////////////
//// PUNTOSTPV ///////////////////////////////////////////////////
class puntosTpv extends oficial
{
  function puntosTpv(context)
  {
    oficial(context);
  }
  var bloqueo_;
  function init()
  {
    this.ctx.puntosTpv_init();
  }
  function bufferChanged(fN: String)
  {
    return this.ctx.puntosTpv_bufferChanged(fN);
  }
  function calculateField(fN)
  {
    return this.ctx.puntosTpv_calculateField(fN);
  }
  function dameCanNoEfectivo()
  {
    return this.ctx.puntosTpv_dameCanNoEfectivo();
  }
  function controlarCantidadPuntos()
  {
    return this.ctx.puntosTpv_controlarCantidadPuntos();
  }
  function controlarCantidadPuntosTarjeta()
  {
    return this.ctx.puntosTpv_controlarCantidadPuntosTarjeta();
  }
  function aceptarFormulario()
  {
    return this.ctx.puntosTpv_aceptarFormulario();
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

  _i.bloqueo_ = false;
  _i.__init();

  cursor.setValueBuffer("importepuntos", 0);
  cursor.setValueBuffer("ctdadpuntos", 0);

}


function puntosTpv_bufferChanged(fN)
{
  var _i = this.iface;

  var cursor = this.cursor();

  switch (fN) {
    case "importepuntos": {
      if (!_i.bloqueo_) {
        _i.bloqueo_ = true;
        sys.setObjText(this, "fdbCtdadPuntos", _i.calculateField("ctdadpuntos"));
        _i.bloqueo_ = false;
      }
      sys.setObjText(this, "fdbImporteTarjeta", _i.calculateField("importetarjeta"));
      break;
    }
    case "ctdadpuntos": {
      if (!_i.bloqueo_) {
        _i.bloqueo_ = true;
        sys.setObjText(this, "fdbImportePuntos", _i.calculateField("importepuntos"));
        _i.bloqueo_ = false;
      }
      break;
    }
    default: {
      _i.__bufferChanged(fN);
      break;
    }
  }
}

function puntosTpv_calculateField(fN)
{
  var _i = this.iface;

  var cursor = this.cursor();
  var valor;

  switch (fN) {
    case "importetarjeta": {
      var val = parseFloat(cursor.valueBuffer("importevales"));
      val = isNaN(val) ? 0 : val;
      var ef = parseFloat(cursor.valueBuffer("importeefectivo"));
      ef = isNaN(ef) ? 0 : ef;
      var pun = parseFloat(cursor.valueBuffer("importepuntos"));
      pun = isNaN(pun) ? 0 : pun;
      var importe = parseFloat(cursor.valueBuffer("importe"));
      var total = val + ef + pun;
      valor = importe > total ? (importe - total) : 0;

      break;
    }
    case "ctdadpuntos": {
      var ctdadeuros = parseFloat(cursor.valueBuffer("importepuntos"));
      val = isNaN(ctdadeuros) ? 0 : ctdadeuros;
      var valorPuntosEuro = parseFloat(AQUtil.sqlSelect("factalma_general", "valoreuros", "1=1"));
      val = isNaN(valorPuntosEuro) ? 0 : valorPuntosEuro;
      valor = ctdadeuros * valorPuntosEuro;
      valor = Math.ceil(valor);
      ///valor = valor < 0 ? 0 : valor;
      break;
    }
    case "importepuntos": {
      var ctdadPuntos = parseFloat(cursor.valueBuffer("ctdadpuntos"));
      val = isNaN(ctdadPuntos) ? 0 : ctdadPuntos;
      var valorPuntosEuro = AQUtil.sqlSelect("factalma_general", "valoreuros", "1=1");
      val = isNaN(valorPuntosEuro) ? 0 : valorPuntosEuro;
      valor = ctdadPuntos / valorPuntosEuro;
      ///valor = valor < 0 ? 0 : valor;
      break;
    }
    default: {
      valor = _i.__calculateField(fN);
    }
  }
  return valor;
}

function puntosTpv_controlarCantidadPuntos()
{
  var _i = this.iface;
  var cursor = this.cursor();

  var puntos = parseFloat(cursor.valueBuffer("importepuntos"));
  if (!puntos || puntos == 0) {
    return true;
  }

  var importe = parseFloat(cursor.valueBuffer("importe"));
  var val = parseFloat(cursor.valueBuffer("importevales"));
  val = isNaN(val) ? 0 : val;
  var ef = parseFloat(cursor.valueBuffer("importeefectivo"));
  ef = isNaN(ef) ? 0 : ef;
  var tar = parseFloat(cursor.valueBuffer("importetarjeta"));
  tar = isNaN(tar) ? 0 : tar;
  var sumaPagos = parseFloat(val) + parseFloat(ef) + parseFloat(tar);
  var pendiente = parseFloat(importe) - parseFloat(sumaPagos);
  pendiente = pendiente < 0 ? 0 : pendiente;

  if (importe < puntos && importe > 0) {
    return false;
  }
  return true;
}

function puntosTpv_controlarCantidadPuntosTarjeta()
{
  var _i = this.iface;
  var cursor = this.cursor();

  var saldoPuntos = parseFloat(cursor.valueBuffer("saldopuntos"));
  if (isNaN(saldoPuntos)) {
    saldoPuntos = 0;
  }
  var canPuntos = this.child("fdbCtdadPuntos").value();
  if (isNaN(canPuntos)) {
    canPuntos = 0;
  }
  if (saldoPuntos < canPuntos) {
    return false;
  }
  return true;
}

function puntosTpv_dameCanNoEfectivo()
{
  var _i = this.iface;
  var cursor = this.cursor();

  var cNE = parseFloat(_i.__dameCanNoEfectivo());
  var importe = parseFloat(cursor.valueBuffer("importe"));
  var importeEfectivo = parseFloat(cursor.valueBuffer("importeefectivo"))

  if (importeEfectivo > 0) {
    var importePuntos = parseFloat(this.child("fdbImportePuntos").value());
    if (importePuntos <= importeEfectivo) {
      importePuntos = isNaN(importePuntos) ? 0 : importePuntos;
    } else {
      importePuntos = importeEfectivo;
    }
    cNE += parseFloat(importePuntos);
    cNE = AQUtil.roundFieldValue(cNE, "tpv_cantidadpago", "importe");
  }
  return cNE;
}

function puntosTpv_aceptarFormulario()
{
  var _i = this.iface;
  var cursor = this.cursor();

  if (!_i.controlarCantidadPuntos()) {
    MessageBox.warning(sys.translate("La cantidad de puntos no puede ser mayor a la cantidad pendiente por pagar."), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  if (!_i.controlarCantidadPuntosTarjeta()) {
    MessageBox.warning(sys.translate("La cantidad de puntos no puede ser mayor a la cantidad disponible en la tarjeta."), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }

  if (!_i.__aceptarFormulario()) {
    return false;
  }
}

//// PUNTOS TPV /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
