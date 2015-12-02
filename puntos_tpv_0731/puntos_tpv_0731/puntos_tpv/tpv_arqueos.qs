
/** @class_declaration puntosTpv */
//////////////////////////////////////////////////////////////////
//// PUNTOSTPV ///////////////////////////////////////////////////
class puntosTpv extends oficial
{
  function puntosTpv(context)
  {
    oficial(context);
  }

  function calcularValores()
  {
    return this.ctx.puntosTpv_calcularValores();
  }
  function commonCalculateField(fN, cursor)
  {
    return this.ctx.puntosTpv_commonCalculateField(fN, cursor);
  }
  function bufferChanged(fN)
  {
    return this.ctx.puntosTpv_bufferChanged(fN);
  }
}

/** @class_definition puntosTpv */
/////////////////////////////////////////////////////////////////
//// PUNTOS TPV /////////////////////////////////////////////////

function puntosTpv_bufferChanged(fN)
{
  var _i = this.iface;
  var cursor = this.cursor();

  switch (fN) {
    case "totalpuntos": {
      _i.calcularValores();
      break;
    }
    default: {
      _i.__bufferChanged(fN);
    }
  }
}

function puntosTpv_calcularValores()
{
  var _i = this.iface;
  var cursor = this.cursor();

  _i.__calcularValores();

  var total;

  total = _i.calculateField("calculadoPuntos");
  this.child("lblCalculadoPuntos").setText(AQUtil.formatoMiles(total));

  total = _i.calculateField("diferenciaPuntos");
  this.child("lblDiferenciaPuntos").setText(AQUtil.formatoMiles(total));
  cursor.setValueBuffer("diferenciapuntos", total);
}

function puntosTpv_commonCalculateField(fN, cursor)
{
  var valor;
  var _i = this.iface;

  switch (fN) {
    case "calculadoPuntos": {
      valor = parseFloat(_i.commonCalculateField("pagospuntos", cursor));
      valor = AQUtil.roundFieldValue(valor, "tpv_arqueos", "totalpuntos");
      break;
    }
    case "diferenciaPuntos": {
      valor = parseFloat(cursor.valueBuffer("totalpuntos")) - parseFloat(_i.commonCalculateField("calculadoPuntos", cursor));
      valor = AQUtil.roundFieldValue(valor, "tpv_arqueos", "totalpuntos");
      break;
    }
    case "pagospuntos": {
      var codPago = AQUtil.sqlSelect("tpv_datosgenerales", "pagopunto", "1 = 1");
      valor = AQUtil.sqlSelect("tpv_pagoscomanda", "SUM(importe)", "idtpv_arqueo = '" + cursor.valueBuffer("idtpv_arqueo") + "' AND codpago = '" + codPago + "'");
      if (!valor || isNaN(valor)) {
        valor = 0;
      }
      valor = AQUtil.roundFieldValue(valor, "tpv_arqueos", "totalpuntos");
      break;
    }
    case "totalpagos": {
      valor = parseFloat(_i.__commonCalculateField(fN, cursor));
      valor += parseFloat(cursor.valueBuffer("pagospuntos"));
      valor = AQUtil.roundFieldValue(valor, "tpv_arqueos", "totalcaja");
      break;
    }
    default: {
      valor = _i.__commonCalculateField(fN, cursor);
    }
  }
  return valor;
}
//// PUNTOS TPV /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
