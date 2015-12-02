
/** @class_declaration comisionPagos */
//////////////////////////////////////////////////////////////////
//// COMISION_PAGOS /////////////////////////////////////////////////
class comisionPagos extends proveed
{
  function comisionPagos(context)
  {
    proveed(context);
  }

  function generarPartidasBanco(curPD: FLSqlCursor, valoresDefecto: Array, datosAsiento: Array, recibo: Array): Boolean {
    return this.ctx.comisionPagos_generarPartidasBanco(curPD, valoresDefecto, datosAsiento, recibo);
  }
  function generarPartidasGastos(curPD: FLSqlCursor, valoresDefecto: Array, datosAsiento: Array, recibo: Array): Boolean {
    return this.ctx.comisionPagos_generarPartidasGastos(curPD, valoresDefecto, datosAsiento, recibo);
  }
  function restarComision(curPD: FLSqlCursor, valoresDefecto: Array, datosAsiento: Array, recibo: Array): Boolean {
    return this.ctx.comisionPagos_restarComision(curPD, valoresDefecto, datosAsiento, recibo);
  }
  function generarAsientoPagoDevolCli(curPD: FLSqlCursor)
  {
    return this.ctx.comisionPagos_generarAsientoPagoDevolCli(curPD);
  }

  function generarPartidasBancoProv(curPD: FLSqlCursor, valoresDefecto: Array, datosAsiento: Array, recibo: Array): Boolean {
    return this.ctx.comisionPagos_generarPartidasBancoProv(curPD, valoresDefecto, datosAsiento, recibo);
  }
  function generarPartidasGastosProv(curPD: FLSqlCursor, valoresDefecto: Array, datosAsiento: Array, recibo: Array): Boolean {
    return this.ctx.comisionPagos_generarPartidasGastosProv(curPD, valoresDefecto, datosAsiento, recibo);
  }
  function restarComisionProv(curPD: FLSqlCursor, valoresDefecto: Array, datosAsiento: Array, recibo: Array): Boolean {
    return this.ctx.comisionPagos_sumarComisionProv(curPD, valoresDefecto, datosAsiento, recibo);
  }
  function generarAsientoPagoDevolProv(curPD: FLSqlCursor)
  {
    return this.ctx.comisionPagos_generarAsientoPagoDevolProv(curPD);
  }
}
//// COMISION_PAGOS /////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_definition comisionPagos */
/////////////////////////////////////////////////////////////////
//// COMISION_PAGOS /////////////////////////////////////////////////

function comisionPagos_generarPartidasBanco(curPD: FLSqlCursor, valoresDefecto: Array, datosAsiento: Array, recibo: Array): Boolean {
  if (!this.iface.__generarPartidasBanco(curPD, valoresDefecto, datosAsiento, recibo))
    return false;

  if (!this.iface.generarPartidasGastos(curPD, valoresDefecto, datosAsiento, recibo))
    return false;

  return this.iface.restarComision(curPD, valoresDefecto, datosAsiento, recibo);
}

/** Crea la partida de gasto por comisión
*/
function comisionPagos_generarPartidasGastos(curPD: FLSqlCursor, valoresDefecto: Array, datosAsiento: Array, recibo: Array): Boolean {
  var gasto: Number = parseFloat(curPD.valueBuffer("gasto"));
  if (!gasto)
    return true;

  var util: FLUtil = new FLUtil();
  var ctaDebe: Array = [];
  ctaDebe.codsubcuenta = curPD.valueBuffer("codsubcuentagasto");
  ctaDebe.idsubcuenta = util.sqlSelect("co_subcuentas", "idsubcuenta", "codsubcuenta = '" + ctaDebe.codsubcuenta + "' AND codejercicio = '" + valoresDefecto.codejercicio + "'");
  if (!ctaDebe.idsubcuenta)
  {
    MessageBox.warning(util.translate("scripts", "No tiene definida la subcuenta %1 en el ejercicio %2.\nAntes de dar el pago debe crear la subcuenta o modificar el ejercicio").arg(ctaDebe.codsubcuenta).arg(valoresDefecto.codejercicio), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }

  var debe: Number = 0;
  var debeME: Number = 0;
  var tasaconvDebe: Number = 1;
  if (valoresDefecto.coddivisa == recibo.coddivisa)
  {
    debe = curPD.valueBuffer("gasto");
    debeME = 0;
  } else {
    tasaconvDebe = curPD.valueBuffer("tasaconv");
    debe = parseFloat(gasto) * parseFloat(tasaconvDebe);
    debeME = parseFloat(gasto);
  }
  debe = util.roundFieldValue(debe, "co_partidas", "debe");
  debeME = util.roundFieldValue(debeME, "co_partidas", "debeme");

  var esAbono: Boolean = util.sqlSelect("reciboscli r INNER JOIN facturascli f ON r.idfactura = f.idfactura", "deabono", "idrecibo = " + curPD.valueBuffer("idrecibo"), "reciboscli,facturascli");
  var concepto: String;
  if (curPD.table() == "pagosdevolcli")
    concepto = "Gastos recibo " + recibo.codigo + " - " + recibo.nombrecliente;
  else
    concepto = "Gastos recibo " + recibo.codigo + " - " + recibo.nombreproveedor;

  var curPartida: FLSqlCursor = new FLSqlCursor("co_partidas");
  with(curPartida)
  {
    setModeAccess(curPartida.Insert);
    refreshBuffer();
    setValueBuffer("concepto", concepto);
    setValueBuffer("idsubcuenta", ctaDebe.idsubcuenta);
    setValueBuffer("codsubcuenta", ctaDebe.codsubcuenta);
    setValueBuffer("idasiento", datosAsiento.idasiento);
    if (esAbono) {
      setValueBuffer("debe", 0);
      setValueBuffer("haber", debe * -1);
    } else {
      setValueBuffer("debe", debe);
      setValueBuffer("haber", 0);
    }
    setValueBuffer("coddivisa", recibo.coddivisa);
    setValueBuffer("tasaconv", tasaconvDebe);
    setValueBuffer("debeME", debeME);
    setValueBuffer("haberME", 0);
  }
  if (!curPartida.commitBuffer())
    return false;

  return true;
}

/** Resta el valor de la comisión de la partida de banco
*/
function comisionPagos_restarComision(curPD: FLSqlCursor, valoresDefecto: Array, datosAsiento: Array, recibo: Array): Boolean {
  var util: FLUtil = new FLUtil();
  var ctaDebe: Array = [];
  ctaDebe.codsubcuenta = curPD.valueBuffer("codsubcuenta");
  ctaDebe.idsubcuenta = util.sqlSelect("co_subcuentas", "idsubcuenta", "codsubcuenta = '" + ctaDebe.codsubcuenta + "' AND codejercicio = '" + valoresDefecto.codejercicio + "'");
  if (!ctaDebe.idsubcuenta)
  {
    MessageBox.warning(util.translate("scripts", "No tiene definida la subcuenta %1 en el ejercicio %2.\nAntes de dar el pago debe crear la subcuenta o modificar el ejercicio").arg(ctaDebe.codsubcuenta).arg(valoresDefecto.codejercicio), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }

  var gasto: Number = curPD.valueBuffer("gasto");
  var nuevoImporte = parseFloat(recibo.importe) - parseFloat(gasto);

  var debe: Number = 0;
  var debeME: Number = 0;
  var tasaconvDebe: Number = 1;
  if (valoresDefecto.coddivisa == recibo.coddivisa)
  {
    debe = nuevoImporte;
    debeME = 0;
  } else {
    tasaconvDebe = curPD.valueBuffer("tasaconv");
    debe = parseFloat(nuevoImporte) * parseFloat(tasaconvDebe);
    debeME = parseFloat(nuevoImporte);
  }
  debe = util.roundFieldValue(debe, "co_partidas", "debe");
  debeME = util.roundFieldValue(debeME, "co_partidas", "debeme");

  var esAbono: Boolean = util.sqlSelect("reciboscli r INNER JOIN facturascli f ON r.idfactura = f.idfactura", "deabono", "idrecibo = " + curPD.valueBuffer("idrecibo"), "reciboscli,facturascli");

  var curPartida: FLSqlCursor = new FLSqlCursor("co_partidas");
  curPartida.select("codsubcuenta = '" + ctaDebe.codsubcuenta + "' AND idasiento = " + datosAsiento.idasiento);
  if (curPartida.first())
  {
    with(curPartida) {
      setModeAccess(curPartida.Edit);
      refreshBuffer();
      if (esAbono) {
        setValueBuffer("debe", 0);
        setValueBuffer("haber", debe * -1);
      } else {
        setValueBuffer("debe", debe);
        setValueBuffer("haber", 0);
      }
      setValueBuffer("debeME", debeME);
      setValueBuffer("haberME", 0);
    }
    if (!curPartida.commitBuffer())
      return false;
  }

  return true;
}

/** \D Genera el asiento inverso y llama a la restitución de las partidas si había gastos
\end */
function oficial_generarAsientoInverso(idAsientoDestino: Number, idAsientoOrigen: Number, concepto: String, codEjercicio: String): Boolean {
  var util: FLUtil = new FLUtil;
  var curPartida: FLSqlCursor = new FLSqlCursor("co_partidas");
  curPartida.select("idasiento = " + idAsientoDestino);
  qryPartidaOriginal = new FLSqlQuery();
  with(qryPartidaOriginal)
  {
    setTablesList("co_partidas");
    setSelect("codsubcuenta, debe, haber, coddivisa, tasaconv, debeME, haberME");
    setFrom("co_partidas");
    setWhere("idasiento = " + idAsientoOrigen);
  }
  try { qryPartidaOriginal.setForwardOnly(true); } catch (e) {}
  if (!qryPartidaOriginal.exec())
    return false;

  while (qryPartidaOriginal.next())
  {
    var idSubcuenta: Number = util.sqlSelect("co_subcuentas", "idsubcuenta", "codsubcuenta = '" + qryPartidaOriginal.value(0) + "' AND codejercicio = '" + codEjercicio + "'");
    if (!idSubcuenta) {
      MessageBox.warning(util.translate("scripts", "No existe la subcuenta ")  + qryPartidaOriginal.value(0) + util.translate("scripts", " correspondiente al ejercicio ") + codEjercicio + util.translate("scripts", ".\nPara poder realizar el asiento debe crear antes esta subcuenta"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
      return false;
    }
    with(curPartida) {
      setModeAccess(curPartida.Insert);
      refreshBuffer();
      setValueBuffer("concepto", concepto);
      setValueBuffer("idsubcuenta", idSubcuenta);
      setValueBuffer("codsubcuenta", qryPartidaOriginal.value(0));
      setValueBuffer("idasiento", idAsientoDestino);
      setValueBuffer("debe", qryPartidaOriginal.value(2));
      setValueBuffer("haber", qryPartidaOriginal.value(1));
      setValueBuffer("coddivisa", qryPartidaOriginal.value(3));
      setValueBuffer("tasaconv", qryPartidaOriginal.value(4));
      setValueBuffer("debeME", qryPartidaOriginal.value(6));
      setValueBuffer("haberME", qryPartidaOriginal.value(5));
    }
    if (!curPartida.commitBuffer())
      return false;
  }
  return true;
}





function comisionPagos_generarPartidasBancoProv(curPD: FLSqlCursor, valoresDefecto: Array, datosAsiento: Array, recibo: Array): Boolean {
  if (!this.iface.__generarPartidasBancoProv(curPD, valoresDefecto, datosAsiento, recibo))
    return false;

  if (!this.iface.generarPartidasGastos(curPD, valoresDefecto, datosAsiento, recibo))
    return false;

  return this.iface.restarComisionProv(curPD, valoresDefecto, datosAsiento, recibo);
}

/** Suma el valor de la comisión de la partida de banco
*/
function comisionPagos_sumarComisionProv(curPD: FLSqlCursor, valoresDefecto: Array, datosAsiento: Array, recibo: Array): Boolean {
  var util: FLUtil = new FLUtil();
  var ctaHaber: Array = [];
  ctaHaber.codsubcuenta = curPD.valueBuffer("codsubcuenta");
  ctaHaber.idsubcuenta = util.sqlSelect("co_subcuentas", "idsubcuenta", "codsubcuenta = '" + ctaHaber.codsubcuenta + "' AND codejercicio = '" + valoresDefecto.codejercicio + "'");
  if (!ctaHaber.idsubcuenta)
  {
    MessageBox.warning(util.translate("scripts", "No tiene definida la subcuenta %1 en el ejercicio %2.\nAntes de dar el pago debe crear la subcuenta o modificar el ejercicio").arg(ctaHaber.codsubcuenta).arg(valoresDefecto.codejercicio), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }

  var gasto: Number = curPD.valueBuffer("gasto");
  var nuevoImporte = parseFloat(recibo.importe) + parseFloat(gasto);

  var haber: Number = 0;
  var haberME: Number = 0;
  var tasaconvhaber: Number = 1;
  if (valoresDefecto.coddivisa == recibo.coddivisa)
  {
    haber = nuevoImporte;
    haberME = 0;
  } else {
    tasaconvhaber = curPD.valueBuffer("tasaconv");
    haber = parseFloat(nuevoImporte) * parseFloat(tasaconvhaber);
    haberME = parseFloat(nuevoImporte);
  }
  haber = util.roundFieldValue(haber, "co_partidas", "haber");
  haberME = util.roundFieldValue(haberME, "co_partidas", "haberme");

  var esAbono: Boolean = util.sqlSelect("reciboscli r INNER JOIN facturascli f ON r.idfactura = f.idfactura", "deabono", "idrecibo = " + curPD.valueBuffer("idrecibo"), "reciboscli,facturascli");

  var curPartida: FLSqlCursor = new FLSqlCursor("co_partidas");
  curPartida.select("codsubcuenta = '" + ctaHaber.codsubcuenta + "' AND idasiento = " + datosAsiento.idasiento);
  if (curPartida.first())
  {
    with(curPartida) {
      setModeAccess(curPartida.Edit);
      refreshBuffer();
      if (esAbono) {
        setValueBuffer("haber", 0);
        setValueBuffer("debe", haber * -1);
      } else {
        setValueBuffer("haber", haber);
        setValueBuffer("debe", 0);
      }
      setValueBuffer("haberME", haberME);
      setValueBuffer("debeME", 0);
    }
    if (!curPartida.commitBuffer())
      return false;
  }

  return true;
}


/** Cuando se trata de una devolución, si ha habido gastos en
el pago previo debemos compensar las partidas
*/
function comisionPagos_generarAsientoPagoDevolCli(curDev: FLSqlCursor): Boolean {
  if (!this.iface.__generarAsientoPagoDevolCli(curDev))
    return false;

  // Sólo si es una devolución
  if (curDev.valueBuffer("tipo") == "Pago")
    return true;

  if (curDev.modeAccess() != curDev.Insert && curDev.modeAccess() != curDev.Edit)
    return true;

  // Cursor sobre el pago anterior
  var datosPago = flfactppal.iface.pub_ejecutarQry("pagosdevolcli", "gasto,idsubcuenta,idsubcuentagasto", "idrecibo = " + curDev.valueBuffer("idrecibo") + " AND  tipo = 'Pago' ORDER BY fecha DESC, idpagodevol DESC");
  if (datosPago.result < 1)
    return false;

  if (!datosPago.gasto)
    return true;

  var util: FLUtil = new FLUtil();
  var idAsiento: Number = curDev.valueBuffer("idasiento");

  var nuevoImporte = parseFloat(curDev.cursorRelation().valueBuffer("importe"));
  var haber: Number = 0;
  var haberME: Number = 0;
  var tasaconvhaber: Number = 1;
  if (flfactppal.iface.pub_valorDefectoEmpresa("coddivisa") == curDev.cursorRelation().valueBuffer("coddivisa"))
  {
    haber = nuevoImporte;
    haberME = 0;
  } else {
    tasaconvhaber = curDev.valueBuffer("tasaconv");
    haber = parseFloat(nuevoImporte) * parseFloat(tasaconvhaber);
    haberME = parseFloat(nuevoImporte);
  }
  haber = util.roundFieldValue(haber, "co_partidas", "haber");
  haberME = util.roundFieldValue(haberME, "co_partidas", "haberme");


  var esAbono: Boolean = util.sqlSelect("reciboscli r INNER JOIN facturascli f ON r.idfactura = f.idfactura", "deabono", "idrecibo = " + curDev.valueBuffer("idrecibo"), "reciboscli,facturascli");

  // Actualizar la partida de banco
  var curPartida: FLSqlCursor = new FLSqlCursor("co_partidas");
  curPartida.select("idsubcuenta = '" + datosPago.idsubcuenta + "' AND idasiento = " + idAsiento);
  if (curPartida.first())
  {
    with(curPartida) {
      setModeAccess(curPartida.Edit);
      refreshBuffer();
      if (esAbono) {
        setValueBuffer("haber", 0);
        setValueBuffer("debe", haber * -1);
      } else {
        setValueBuffer("haber", haber);
        setValueBuffer("debe", 0);
      }
      setValueBuffer("haberME", haberME);
      setValueBuffer("debeME", 0);
    }
    if (!curPartida.commitBuffer())
      return false;
  }

  // Borrar la partida de gasto generada por el asiento inverso
  curPartida.select("idsubcuenta = '" + datosPago.idsubcuentagasto + "' AND idasiento = " + idAsiento + " AND debe+haber= " + datosPago.gasto);
  if (curPartida.first())
  {
    with(curPartida) {
      setModeAccess(curPartida.Del);
      refreshBuffer();
    }
    if (!curPartida.commitBuffer())
      return false;
  }

  return true;
}


/** Cuando se trata de una devolución, si ha habido gastos en
el pago previo debemos compensar las partidas
*/
function comisionPagos_generarAsientoPagoDevolProv(curDev: FLSqlCursor): Boolean {
  if (!this.iface.__generarAsientoPagoDevolProv(curDev))
    return false;

  // Sólo si es una devolución
  if (curDev.valueBuffer("tipo") == "Pago")
    return true;

  if (curDev.modeAccess() != curDev.Insert && curDev.modeAccess() != curDev.Edit)
    return true;

  // Cursor sobre el pago anterior
  var datosPago = flfactppal.iface.pub_ejecutarQry("pagosdevolprov", "gasto,idsubcuenta,idsubcuentagasto", "idrecibo = " + curDev.valueBuffer("idrecibo") + " AND  tipo = 'Pago' ORDER BY fecha DESC, idpagodevol DESC");
  if (datosPago.result < 1)
    return false;

  if (!datosPago.gasto)
    return true;

  var util: FLUtil = new FLUtil();
  var idAsiento: Number = curDev.valueBuffer("idasiento");

  var nuevoImporte = parseFloat(curDev.cursorRelation().valueBuffer("importe"));
  var debe: Number = 0;
  var debeME: Number = 0;
  var tasaconvdebe: Number = 1;
  if (flfactppal.iface.pub_valorDefectoEmpresa("coddivisa") == curDev.cursorRelation().valueBuffer("coddivisa"))
  {
    debe = nuevoImporte;
    debeME = 0;
  } else {
    tasaconvdebe = curDev.valueBuffer("tasaconv");
    debe = parseFloat(nuevoImporte) * parseFloat(tasaconvdebe);
    debeME = parseFloat(nuevoImporte);
  }
  debe = util.roundFieldValue(debe, "co_partidas", "debe");
  debeME = util.roundFieldValue(debeME, "co_partidas", "debeme");


  var esAbono: Boolean = util.sqlSelect("recibosprov r INNER JOIN facturasprov f ON r.idfactura = f.idfactura", "deabono", "idrecibo = " + curDev.valueBuffer("idrecibo"), "recibosprov,facturasprov");

  // Actualizar la partida de banco
  var curPartida: FLSqlCursor = new FLSqlCursor("co_partidas");
  curPartida.select("idsubcuenta = '" + datosPago.idsubcuenta + "' AND idasiento = " + idAsiento);
  if (curPartida.first())
  {
    with(curPartida) {
      setModeAccess(curPartida.Edit);
      refreshBuffer();
      if (esAbono) {
        setValueBuffer("debe", 0);
        setValueBuffer("haber", debe * -1);
      } else {
        setValueBuffer("debe", debe);
        setValueBuffer("haber", 0);
      }
      setValueBuffer("debeME", debeME);
      setValueBuffer("haberME", 0);
    }
    if (!curPartida.commitBuffer())
      return false;
  }

  // Borrar la partida de gasto generada por el asiento inverso
  curPartida.select("idsubcuenta = '" + datosPago.idsubcuentagasto + "' AND idasiento = " + idAsiento + " AND debe+haber= " + datosPago.gasto);
  if (curPartida.first())
  {
    with(curPartida) {
      setModeAccess(curPartida.Del);
      refreshBuffer();
    }
    if (!curPartida.commitBuffer())
      return false;
  }

  return true;
}

//// COMISION_PAGOS ////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
