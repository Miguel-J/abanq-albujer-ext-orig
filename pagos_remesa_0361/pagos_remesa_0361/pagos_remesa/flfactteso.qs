
/** @class_declaration pagosRemesa */
/////////////////////////////////////////////////////////////////
//// PAGOS_REMESA ///////////////////////////////////////////////
class pagosRemesa extends oficial
{
  function pagosRemesa(context)
  {
    oficial(context);
  }
  function beforeCommit_pagosdevolcli(curPD: FLSqlCursor): Boolean {
    return this.ctx.pagosRemesa_beforeCommit_pagosdevolcli(curPD);
  }
  function generarAsientoPagoDevolCli(curPD: FLSqlCursor)
  {
    return this.ctx.pagosRemesa_generarAsientoPagoDevolCli(curPD);
  }
  function generarPartidasBancoPagoRem(curPD: FLSqlCursor, valoresDefecto: Array, datosAsiento: Array, recibo: Array): Boolean {
    return this.ctx.pagosRemesa_generarPartidasBancoPagoRem(curPD, valoresDefecto, datosAsiento, recibo);
  }
  function afterCommit_pagosdevolcli(curPD: FLSqlCursor): Boolean {
    return this.ctx.pagosRemesa_afterCommit_pagosdevolcli(curPD);
  }
}
//// PAGOS_REMESA ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition pagosRemesa */
/////////////////////////////////////////////////////////////////
//// PAGOS_REMESA ///////////////////////////////////////////////
/** \C Se regenera, si es posible, el asiento contable asociado al pago o devolución siempre que no pertenezca a una remesa de pago indirecto
\end */
function pagosRemesa_beforeCommit_pagosdevolcli(curPD: FLSqlCursor): Boolean {
  var util: FLUtil = new FLUtil();
  if (sys.isLoadedModule("flcontppal") && flfactppal.iface.pub_valorDefectoEmpresa("contintegrada") && !curPD.valueBuffer("nogenerarasiento"))
  {
    if (curPD.valueBuffer("tipo") !=  "Remesa") {
      if (util.sqlSelect("factteso_general", "pagoindirecto", "1 = 1")) {
        if (!this.iface.generarAsientoPagoDevolCli(curPD))
          return false;
      } else {
        if (!this.iface.__generarAsientoPagoDevolCli(curPD))
          return false;
      }
    }
  }
  return true;
}

function pagosRemesa_generarAsientoPagoDevolCli(curPD: FLSqlCursor): Boolean {
  var util: FLUtil = new FLUtil();
  if (curPD.modeAccess() != curPD.Insert && curPD.modeAccess() != curPD.Edit)
    return true;

  if (curPD.valueBuffer("nogenerarasiento"))
  {
    curPD.setNull("idasiento");
    return true;
  }

  var codEjercicio: String = flfactppal.iface.pub_ejercicioActual();
  var datosDoc: Array = flfacturac.iface.pub_datosDocFacturacion(curPD.valueBuffer("fecha"), codEjercicio, "pagosdevolcli");
  if (!datosDoc.ok)
    return false;
  if (datosDoc.modificaciones == true)
  {
    codEjercicio = datosDoc.codEjercicio;
    curPD.setValueBuffer("fecha", datosDoc.fecha);
  }

  var datosAsiento: Array = [];
  var valoresDefecto: Array;
  valoresDefecto["codejercicio"] = codEjercicio;
  valoresDefecto["coddivisa"] = util.sqlSelect("empresa", "coddivisa", "1 = 1");

  datosAsiento = flfacturac.iface.pub_regenerarAsiento(curPD, valoresDefecto);
  if (datosAsiento.error == true)
    return false;

  if (curPD.valueBuffer("tipo") == "Pago")
  {
    var recibo: Array = flfactppal.iface.pub_ejecutarQry("reciboscli", "coddivisa,importe,importeeuros,idfactura,codigo,nombrecliente", "idrecibo = " + curPD.valueBuffer("idrecibo"));
    if (recibo.result != 1)
      return false;

    if (!this.iface.generarPartidasCli(curPD, valoresDefecto, datosAsiento, recibo))
      return false;

    if (!this.iface.generarPartidasBancoPagoRem(curPD, valoresDefecto, datosAsiento, recibo))
      return false;

    if (!this.iface.generarPartidasCambio(curPD, valoresDefecto, datosAsiento, recibo))
      return false;
  } else
    return this.iface.__generarAsientoPagoDevolCli(curPD);

  curPD.setValueBuffer("idasiento", datosAsiento.idasiento);

  if (!flcontppal.iface.pub_comprobarAsiento(datosAsiento.idasiento))
    return false;

  return true;
}

function pagosRemesa_generarPartidasBancoPagoRem(curPD: FLSqlCursor, valoresDefecto: Array, datosAsiento: Array, recibo: Array): Boolean {
  var util: FLUtil = new FLUtil();
  var ctaDebe: Array = [];
  var idRemesa: Number = util.sqlSelect("reciboscli", "idremesa", "idrecibo = " + curPD.valueBuffer("idrecibo"));
  var codCuenta: String = util.sqlSelect("remesas", "codcuenta", "idremesa = " + idRemesa);
  ctaDebe.codsubcuenta = util.sqlSelect("cuentasbanco", "codsubcuentaecgc", "codcuenta = '" + codCuenta + "'");

  if (!ctaDebe.codsubcuenta || ctaDebe.codsubcuenta == "")
  {
    MessageBox.warning(util.translate("scripts", "No tiene definida una subcuenta de pago de remesas"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }

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
    debe = recibo.importe;
    debeME = 0;
  } else {
    tasaconvDebe = curPD.valueBuffer("tasaconv");
    debe = parseFloat(recibo.importe) * parseFloat(tasaconvDebe);
    debeME = parseFloat(recibo.importe);
  }
  debe = util.roundFieldValue(debe, "co_partidas", "debe");
  debeME = util.roundFieldValue(debeME, "co_partidas", "debeme");

  var esAbono: Boolean = util.sqlSelect("reciboscli r INNER JOIN facturascli f ON r.idfactura = f.idfactura", "deabono", "idrecibo = " + curPD.valueBuffer("idrecibo"), "reciboscli,facturascli");

  var curPartida: FLSqlCursor = new FLSqlCursor("co_partidas");
  with(curPartida)
  {
    setModeAccess(curPartida.Insert);
    refreshBuffer();
    setValueBuffer("concepto", curPD.valueBuffer("tipo") + " recibo " + recibo.codigo + " - " + recibo.nombrecliente);
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

function pagosRemesa_afterCommit_pagosdevolcli(curPD: FLSqlCursor): Boolean {
  if (!this.iface.__afterCommit_pagosdevolcli(curPD))
    return false;

  var idRecibo: String = curPD.valueBuffer("idrecibo");

  var curRecibo: FLSqlCursor = new FLSqlCursor("reciboscli");
  curRecibo.select("idrecibo = " + idRecibo);
  if (curRecibo.first())
  {
    curRecibo.setModeAccess(curRecibo.Edit);
    curRecibo.refreshBuffer();
    curRecibo.setValueBuffer("estado", formRecordreciboscli.iface.pub_obtenerEstado(idRecibo));
    if (!curRecibo.commitBuffer())
      return false;
  }

  return true;
}
//// PAGOS_REMESA ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
