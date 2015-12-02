
/** @class_declaration  baseTpv */
/////////////////////////////////////////////////////////////////
//// BASE TPV ///////////////////////////////////////////////////
class baseTpv extends oficial
{
  function baseTpv(context)
  {
    oficial(context);
  }
  function generarPartidasBanco(curPD, valoresDefecto, datosAsiento, recibo)
  {
    return this.ctx.baseTpv_generarPartidasBanco(curPD, valoresDefecto, datosAsiento, recibo);
  }
  function dameDatosReciboCli(curPD)
  {
    return this.ctx.baseTpv_dameDatosReciboCli(curPD);
  }
  function importeReciboPagoBanco(curPD, recibo)
  {
    return this.ctx.baseTpv_importeReciboPagoBanco(curPD, recibo);
  }
  function generarPartidasComisionTpv(curPD, valoresDefecto, datosAsiento, recibo)
  {
    return this.ctx.baseTpv_generarPartidasComisionTpv(curPD, valoresDefecto, datosAsiento, recibo);
  }
  function importeReciboPagoComTpv(curPD, recibo)
  {
    return this.ctx.baseTpv_importeReciboPagoComTpv(curPD, recibo);
  }
}
//// BASE TPV ///////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition baseTpv */
/////////////////////////////////////////////////////////////////
//// BASE TPV ////////////////////////////////////////////////////

function baseTpv_generarPartidasBanco(curPD, valoresDefecto, datosAsiento, recibo)
{
  var _i = this.iface;

  var ctaDebe = [];
  ctaDebe.codsubcuenta = curPD.valueBuffer("codsubcuenta");
  ctaDebe.idsubcuenta = AQUtil.sqlSelect("co_subcuentas", "idsubcuenta", "codsubcuenta = '" + ctaDebe.codsubcuenta + "' AND codejercicio = '" + valoresDefecto.codejercicio + "'");
  if (!ctaDebe.idsubcuenta) {
    MessageBox.warning(sys.translate("No tiene definida la subcuenta %1 en el ejercicio %2.\nAntes de dar el pago debe crear la subcuenta o modificar el ejercicio").arg(ctaDebe.codsubcuenta).arg(valoresDefecto.codejercicio), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }

  var comisionTpv = recibo.porcomisiontpv;
  if (comisionTpv > 0) {
    if (!_i.generarPartidasComisionTpv(curPD, valoresDefecto, datosAsiento, recibo)) {
      return false;
    }
  }

  var debe = 0;
  var debeME = 0;
  var tasaConvDebe = 1;

  var importeTotal = _i.importeReciboPagoBanco(curPD, recibo);
  if (valoresDefecto.coddivisa == recibo.coddivisa) {
    debe = importeTotal;
    debeMe = 0;
  } else {
    tasaConvDebe = AQUtil.sqlSelect("reciboscli r INNER JOIN facturascli f ON r.idfactura = f.idfactura ", "tasaconv", "idrecibo = " + curPD.valueBuffer("idrecibo"), "reciboscli,facturascli");
    debe = parseFloat(importeTotal) * parseFloat(tasaConvDebe);
    debeME = parseFloat(importeTotal);
  }

  debe = AQUtil.roundFieldValue(debe, "co_partidas", "debe");
  debeME = AQUtil.roundFieldValue(debeME, "co_partidas", "debeme");

  var esAbono = AQUtil.sqlSelect("reciboscli r INNER JOIN facturascli f ON r.idfactura = f.idfactura", "deabono", "idrecibo = " + curPD.valueBuffer("idrecibo"), "reciboscli,facturascli");
  var esPago = this.iface.esPagoEstePagoDevol(curPD);

  var curPartida = new FLSqlCursor("co_partidas");
  with(curPartida) {
    setModeAccess(curPartida.Insert);
    refreshBuffer();
    try {
      setValueBuffer("concepto", datosAsiento.concepto);
    } catch (e) {
      setValueBuffer("concepto", curPD.valueBuffer("tipo") + " recibo " + recibo.codigo + " - " + recibo.nombrecliente);
    }
    setValueBuffer("idsubcuenta", ctaDebe.idsubcuenta);
    setValueBuffer("codsubcuenta", ctaDebe.codsubcuenta);
    setValueBuffer("idasiento", datosAsiento.idasiento);
    if (esPago) {
      if (esAbono) {
        setValueBuffer("debe", 0);
        setValueBuffer("haber", debe * -1);
      } else {
        setValueBuffer("debe", debe);
        setValueBuffer("haber", 0);
      }
    } else {
      if (esAbono) {
        setValueBuffer("haber", 0);
        setValueBuffer("debe", debe * -1);
      } else {
        setValueBuffer("haber", debe);
        setValueBuffer("debe", 0);
      }
    }

    setValueBuffer("coddivisa", recibo.coddivisa);
    setValueBuffer("tasaconv", tasaConvDebe);
    setValueBuffer("debeME", debeME);
    setValueBuffer("haberME", 0);
  }
  if (!curPartida.commitBuffer())
    return false;

  return true;
}

function baseTpv_dameDatosReciboCli(curPD)
{
  var _i = this.iface;

  var d = _i.__dameDatosReciboCli(curPD);
  if (d.result != 1) {
    return d;
  }
  d.porcomisiontpv = 0;
  d.codsubcuentacomtpv = undefined;
  var codPago = d.codpago;
  if (codPago) {
    var dCom = flfactppal.iface.pub_ejecutarQry("formaspago fp INNER JOIN cuentasbanco cb ON fp.codcuenta = cb.codcuenta", "porcomisiontpv,codsubcuentacomtpv", "fp.codpago = '" + codPago + "'", "formaspago,cuentasbanco");
    if (dCom.result != -1) {
      d.porcomisiontpv = dCom.porcomisiontpv;
      d.codsubcuentacomtpv = dCom.codsubcuentacomtpv;
    }
  }
  return d;
}

function baseTpv_importeReciboPagoBanco(curPD, recibo)
{
  var _i = this.iface;
  var importe = recibo.importe - (_i.importeReciboPagoComTpv(curPD, recibo));
  importe = AQUtil.roundFieldValue(importe, "co_partidas", "debe");
  return importe;
}


function baseTpv_generarPartidasComisionTpv(curPD, valoresDefecto, datosAsiento, recibo)
{
  var _i = this.iface;

  var ctaDebe = [];
  ctaDebe.codsubcuenta = recibo.codsubcuentacomtpv;
  ctaDebe.idsubcuenta = AQUtil.sqlSelect("co_subcuentas", "idsubcuenta", "codsubcuenta = '" + ctaDebe.codsubcuenta + "' AND codejercicio = '" + valoresDefecto.codejercicio + "'");
  if (!ctaDebe.idsubcuenta) {
    MessageBox.warning(sys.translate("No tiene definida la subcuenta %1 en el ejercicio %2.\nAntes de dar el pago debe crear la subcuenta o modificar el ejercicio").arg(ctaDebe.codsubcuenta).arg(valoresDefecto.codejercicio), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }

  var debe = 0;
  var debeME = 0;
  var tasaConvDebe = 1;

  var importeTotal = _i.importeReciboPagoComTpv(curPD, recibo);
  if (!importeTotal) {
    return false;
  }
  if (valoresDefecto.coddivisa == recibo.coddivisa) {
    debe = importeTotal;
    debeMe = 0;
  } else {
    tasaConvDebe = AQUtil.sqlSelect("reciboscli r INNER JOIN facturascli f ON r.idfactura = f.idfactura ", "tasaconv", "idrecibo = " + curPD.valueBuffer("idrecibo"), "reciboscli,facturascli");
    debe = parseFloat(importeTotal) * parseFloat(tasaConvDebe);
    debeME = parseFloat(importeTotal);
  }

  debe = AQUtil.roundFieldValue(debe, "co_partidas", "debe");
  debeME = AQUtil.roundFieldValue(debeME, "co_partidas", "debeme");

  var esAbono = AQUtil.sqlSelect("reciboscli r INNER JOIN facturascli f ON r.idfactura = f.idfactura", "deabono", "idrecibo = " + curPD.valueBuffer("idrecibo"), "reciboscli,facturascli");
  var esPago = this.iface.esPagoEstePagoDevol(curPD);

  var curPartida = new FLSqlCursor("co_partidas");
  with(curPartida) {
    setModeAccess(curPartida.Insert);
    refreshBuffer();
    try {
      setValueBuffer("concepto", datosAsiento.concepto);
    } catch (e) {
      setValueBuffer("concepto", curPD.valueBuffer("tipo") + " recibo " + recibo.codigo + " - " + recibo.nombrecliente);
    }
    setValueBuffer("idsubcuenta", ctaDebe.idsubcuenta);
    setValueBuffer("codsubcuenta", ctaDebe.codsubcuenta);
    setValueBuffer("idasiento", datosAsiento.idasiento);
    if (esPago) {
      if (esAbono) {
        setValueBuffer("debe", 0);
        setValueBuffer("haber", debe * -1);
      } else {
        setValueBuffer("debe", debe);
        setValueBuffer("haber", 0);
      }
    } else {
      if (esAbono) {
        setValueBuffer("haber", 0);
        setValueBuffer("debe", debe * -1);
      } else {
        setValueBuffer("haber", debe);
        setValueBuffer("debe", 0);
      }
    }

    setValueBuffer("coddivisa", recibo.coddivisa);
    setValueBuffer("tasaconv", tasaConvDebe);
    setValueBuffer("debeME", debeME);
    setValueBuffer("haberME", 0);
  }
  if (!curPartida.commitBuffer())
    return false;

  return true;
}


function baseTpv_importeReciboPagoComTpv(curPD, recibo)
{
  var _i = this.iface;
  var importe = recibo.importe * recibo.porcomisiontpv / 100;
  importe = AQUtil.roundFieldValue(importe, "co_partidas", "debe");
  return importe;
}

//// BASE TPV ////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
