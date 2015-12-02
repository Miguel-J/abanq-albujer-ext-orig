
/** @class_declaration chequesCli */
//////////////////////////////////////////////////////////////////
//// CHEQUES CLI ///////////////////////////////////////////
class chequesCli extends oficial
{
  function chequesCli(context)
  {
    oficial(context);
  }
  function beforeCommit_pagosdevolcli(curPD: FLSqlCursor)
  {
    return this.ctx.chequesCli_beforeCommit_pagosdevolcli(curPD);
  }
  function beforeCommit_remesaschequescli(curRem: FLSqlCursor)
  {
    return this.ctx.chequesCli_beforeCommit_remesaschequescli(curRem);
  }
  function afterCommit_remesaschequescli(curRem: FLSqlCursor)
  {
    return this.ctx.chequesCli_afterCommit_remesaschequescli(curRem);
  }
  //  function generarReciboCli(curFactura:FLSqlCursor, numRecibo:String, importe:Number, fechaVto:String, emitirComo:String, datosCuentaDom:Array, datosCuentaEmp:Array, datosSubcuentaEmp:Array) {
  //    return this.ctx.chequesCli_generarReciboCli(curFactura, numRecibo, importe, fechaVto, emitirComo, datosCuentaDom, datosCuentaEmp, datosSubcuentaEmp);
  //  }
  function generarAsientoRemesaChequesCli(curRem: FLSqlCursor)
  {
    return this.ctx.chequesCli_generarAsientoRemesaChequesCli(curRem);
  }
  function generarPartidasCheques(curRem: FLSqlCursor, valoresDefecto: Array, datosAsiento: Array)
  {
    return this.ctx.chequesCli_generarPartidasCheques(curRem, valoresDefecto, datosAsiento);
  }
  function generarPartidaChequesBanco(curRem: FLSqlCursor, valoresDefecto: Array, datosAsiento: Array)
  {
    return this.ctx.chequesCli_generarPartidaChequesBanco(curRem, valoresDefecto, datosAsiento);
  }
  function totalesReciboCli()
  {
    return this.ctx.chequesCli_totalesReciboCli();
  }
  function datosPagoDevolCli(curFactura)
  {
    return this.ctx.chequesCli_datosPagoDevolCli(curFactura);
  }
  function desvincularChequesRemesa(curRemesa)
  {
    return this.ctx.chequesCli_desvincularChequesRemesa(curRemesa);
  }
}
//// CHEQUES CLI ///////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_definition chequesCli */
/////////////////////////////////////////////////////////////////
//// CHEQUES CLI //////////////////////////////////////////

/** Si el pago es por un cheque remesado, no se puede eliminar
*/
function chequesCli_beforeCommit_pagosdevolcli(curPD: FLSqlCursor)
{
  var util = new FLUtil();

  if (curPD.modeAccess() == curPD.Del && curPD.valueBuffer("idremesacheque")) {
    MessageBox.warning(util.translate("scripts", "No se puede eliminar el pago porque el cheque ha sido remesado en la remesa %0\nAntes deberá excluir este cheque de la remesa ").arg(curPD.valueBuffer("idremesacheque")), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return false;
  }

  return this.iface.__beforeCommit_pagosdevolcli(curPD);
}

/** Se genera el asiento correspondiente a la remesa
*/
function chequesCli_beforeCommit_remesaschequescli(curRemesa: FLSqlCursor)
{
  switch (curRemesa.modeAccess()) {
    case curRemesa.Insert:
    case curRemesa.Edit:
      this.iface.generarAsientoRemesaChequesCli(curRemesa);
      break;

  }
  return true;
}

/** \C Si se elimina la remesa se elimina, si es posible, el asiento contable asociado
y se liberan los pagos
\end */
function chequesCli_afterCommit_remesaschequescli(curRemesa: FLSqlCursor)
{
  var util = new FLUtil;
  switch (curRemesa.modeAccess()) {
    case curRemesa.Del: {
      if (sys.isLoadedModule("flcontppal") && util.sqlSelect("empresa", "contintegrada", "1 = 1")) {
        var idAsiento = curRemesa.valueBuffer("idasiento");
        if (idAsiento) {
          if (!flfacturac.iface.pub_eliminarAsiento(idAsiento)) {
            return false;
          }
        }
      }
      if (!this.iface.desvincularChequesRemesa(curRemesa)) {
        return false;
      }
      break;
    }
  }
  return true;
}

function chequesCli_desvincularChequesRemesa(curRemesa)
{
  var util = new FLUtil;
  var bloq: Boolean;
  var curTab = new FLSqlCursor("pagosdevolcli");
  //  curTab.setActivatedCommitActions(false);
  //  var curTab2= new FLSqlCursor("pagosdevolcli");
  //  curTab2.setActivatedCommitActions(false);

  var idRemesa = curRemesa.valueBuffer("idremesa");
  curTab.select("idremesacheque = " + idRemesa);
  var idRecibo, idPago;
  while (curTab.next()) {
    idPago = curTab.valueBuffer("idpagodevol");
    if (!formRecordremesaschequescli.iface.pub_excluirChequeRemesa(idPago, idRemesa)) {
      return false;
    }
    //    bloq = false;
    //
    //    curTab2.select("idpagodevol = " + curTab.valueBuffer("idpagodevol"));
    //    curTab2.first();
    //    if (!curTab2.valueBuffer("editable")) {
    //      bloq = true;
    //      curTab2.setUnLock("editable", true);
    //    }
    //
    //    curTab.setModeAccess(curTab.Edit);
    //    curTab.refreshBuffer();
    //    idRecibo = curTab.valueBuffer("idrecibo");
    //    curTab.setValueBuffer("idremesacheque", 0);
    //    curTab.commitBuffer();
    //
    //    if (bloq) {
    //      curTab2.select("idpagodevol = " + curTab.valueBuffer("idpagodevol"));
    //      curTab2.first();
    //      curTab2.setUnLock("editable", false);
    //    }
    //    if (!this.iface.actualizarTotalesReciboCli(idRecibo)) {
    //      return false;
    //    }
  }

  return true;
}

/** Si la factura tiene datos de cheque, se rellenan dichos datos en el propio pago.
La factura se fuerza previamente a tener una forma de pago con recibos pagados y plazo único
*/
//function chequesCli_generarReciboCli(curFactura:FLSqlCursor, numRecibo:String, importe:Number, fechaVto:String, emitirComo:String, datosCuentaDom:Array, datosCuentaEmp:Array, datosSubcuentaEmp:Array)
//{
//  if (!this.iface.__generarReciboCli(curFactura, numRecibo, importe, fechaVto, emitirComo, datosCuentaDom, datosCuentaEmp, datosSubcuentaEmp))
//    return false;
//
//  if (!curFactura.valueBuffer("pagoporcheque"))
//    return true;
//
//  var curPago = new FLSqlCursor("pagosdevolcli");
//  curPago.select("idrecibo = " + this.iface.curReciboCli.valueBuffer("idrecibo"));
//  if (!curPago.first())
//    return true;
//
//  curPago.setModeAccess(curPago.Edit);
//  curPago.refreshBuffer();
//  curPago.setValueBuffer("entidadcheque", curFactura.valueBuffer("entidadcheque"));
//  curPago.setValueBuffer("fechavtocheque", curFactura.valueBuffer("fechavtocheque"));
//  curPago.setValueBuffer("numerocheque", curFactura.valueBuffer("numerocheque"));
//  curPago.setValueBuffer("pagoporcheque", true);
//  if (!curPago.commitBuffer())
//    return false;
//
//  return true;
//}

function chequesCli_datosPagoDevolCli(curFactura)
{
  if (!this.iface.__datosPagoDevolCli(curFactura)) {
    return false;
  }
  if (!curFactura.valueBuffer("pagoporcheque")) {
    return true;
  }
  this.iface.curPagoDevolCli_.setValueBuffer("entidadcheque", curFactura.valueBuffer("entidadcheque"));
  this.iface.curPagoDevolCli_.setValueBuffer("fechavtocheque", curFactura.valueBuffer("fechavtocheque"));
  this.iface.curPagoDevolCli_.setValueBuffer("numerocheque", curFactura.valueBuffer("numerocheque"));
  this.iface.curPagoDevolCli_.setValueBuffer("pagoporcheque", true);
  return true;
}

function chequesCli_generarAsientoRemesaChequesCli(curRem: FLSqlCursor)
{
  var util = new FLUtil();
  if (curRem.modeAccess() != curRem.Insert && curRem.modeAccess() != curRem.Edit)
    return true;

  var codEjercicio = flfactppal.iface.pub_ejercicioActual();
  var datosDoc = flfacturac.iface.pub_datosDocFacturacion(curRem.valueBuffer("fecha"), codEjercicio);
  if (!datosDoc.ok)
    return false;
  if (datosDoc.modificaciones == true) {
    codEjercicio = datosDoc.codEjercicio;
    curRem.setValueBuffer("fecha", datosDoc.fecha);
  }

  var datosAsiento = [];
  var valoresDefecto: Array;
  valoresDefecto["codejercicio"] = codEjercicio;
  valoresDefecto["coddivisa"] = util.sqlSelect("empresa", "coddivisa", "1 = 1");

  var curTransaccion = new FLSqlCursor("empresa");
  curTransaccion.transaction(false);
  try {
    debug(1);
    datosAsiento = flfacturac.iface.pub_regenerarAsiento(curRem, valoresDefecto);
    if (datosAsiento.error == true) {
      throw util.translate("scripts", "Error al regenerar el asiento");
    }
    debug(2);
    if (!this.iface.generarPartidasCheques(curRem, valoresDefecto, datosAsiento)) {
      throw util.translate("scripts", "Error al generar la partida de cheque");
    }
    debug(3);
    if (!this.iface.generarPartidaChequesBanco(curRem, valoresDefecto, datosAsiento)) {
      throw util.translate("scripts", "Error al regenerar la partida de banco del cheque");
    }
    debug(4);
    curRem.setValueBuffer("idasiento", datosAsiento.idasiento);
    debug(5);
    if (!flcontppal.iface.pub_comprobarAsiento(datosAsiento.idasiento)) {
      throw util.translate("scripts", "Error al comprobar el asiento");
    }
    debug(6);
  } catch (e) {
    curTransaccion.rollback();
    MessageBox.warning(util.translate("scripts", "Error al generar el asiento correspondiente a la remesa de cheques") + "\n" + e, MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  debug(7);
  curTransaccion.commit();
  debug(8);
  return true;
}

/** Genera las partidas de cheques de una remesa en el haber
*/
function chequesCli_generarPartidasCheques(curRem: FLSqlCursor, valoresDefecto: Array, datosAsiento: Array)
{
  var util = new FLUtil();

  var q = new FLSqlQuery;
  q.setTablesList("reciboscli,pagosdevolcli");
  q.setSelect("r.importe, pd.codsubcuenta, pd.idsubcuenta, pd.tasaconv, pd.numerocheque, r.codcliente, r.coddivisa")
  q.setFrom("reciboscli r INNER JOIN pagosdevolcli pd ON r.idrecibo = pd.idrecibo")
  q.setWhere("pd.idremesacheque = " + curRem.valueBuffer("idremesa"));

  if (!q.exec())
    return;

  var ctaHaber = [];
  var debe: Number;
  var debeME: Number;
  var tasaconvDebe: Number;

  while (q.next()) {

    ctaHaber.codsubcuenta = q.value(1);
    debug(11);
    if (ctaHaber.codsubcuenta && ctaHaber.codsubcuenta != "") {
      debug(12);
      ctaHaber.idsubcuenta = util.sqlSelect("co_subcuentas", "idsubcuenta", "codsubcuenta = '" + ctaHaber.codsubcuenta + "' AND codejercicio = '" + valoresDefecto["codejercicio"] + "'");
    }
    debug(13);

    if (!ctaHaber.idsubcuenta) {
      ctaHaber = flfacturac.iface.pub_datosCtaEspecial("CAJCHE", valoresDefecto["codejercicio"]);
      if (!ctaHaber.codsubcuenta) {
        MessageBox.warning(util.translate("scripts", "No tiene definida ninguna cuenta de tipo CAJCHE (caja de cheques).\nDebe crear este tipo especial y asociarlo a una cuenta\nen el módulo principal de contabilidad"), MessageBox.Ok, MessageBox.NoButton);
        return false;
      }
    }

    if (valoresDefecto.coddivisa != q.value(6)) {
      MessageBox.warning(util.translate("scripts", "No es posible remesar recibos de moneda extranjera"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
      return false;
    }

    haber = q.value(0);
    haber = util.roundFieldValue(haber, "co_partidas", "haber");

    var curPartida = new FLSqlCursor("co_partidas");
    with(curPartida) {
      setModeAccess(curPartida.Insert);
      refreshBuffer();
      setValueBuffer("concepto", "Cheque " + q.value(4) + " - Cliente " + q.value(5));
      setValueBuffer("idsubcuenta", ctaHaber.idsubcuenta);
      setValueBuffer("codsubcuenta", ctaHaber.codsubcuenta);
      setValueBuffer("idasiento", datosAsiento.idasiento);
      setValueBuffer("haber", haber);
      setValueBuffer("debe", 0);
      setValueBuffer("coddivisa", q.value(6));
      setValueBuffer("tasaconv", 1);
      setValueBuffer("haberME", 0);
      setValueBuffer("debeME", 0);
    }
    if (!curPartida.commitBuffer())
      return false;
  }

  return true;
}

/** Genera las partidas de cheques de una remesa en el haber
*/
function chequesCli_generarPartidaChequesBanco(curRem: FLSqlCursor, valoresDefecto: Array, datosAsiento: Array)
{
  var util = new FLUtil();

  var q = new FLSqlQuery;
  q.setTablesList("reciboscli,pagosdevolcli");
  q.setSelect("sum(r.importe)")
  q.setFrom("reciboscli r INNER JOIN pagosdevolcli pd ON r.idrecibo = pd.idrecibo")
  q.setWhere("pd.idremesacheque = " + curRem.valueBuffer("idremesa"));

  if (!q.exec())
    return;

  if (!q.first())
    return;

  var debe = util.roundFieldValue(q.value(0), "co_partidas", "haber");;

  var curPartida = new FLSqlCursor("co_partidas");
  with(curPartida) {
    setModeAccess(curPartida.Insert);
    refreshBuffer();
    setValueBuffer("concepto", "Remesa de cheques " + curRem.valueBuffer("idremesa"));
    setValueBuffer("idsubcuenta", curRem.valueBuffer("idsubcuenta"));
    setValueBuffer("codsubcuenta", curRem.valueBuffer("codsubcuenta"));
    setValueBuffer("idasiento", datosAsiento.idasiento);
    setValueBuffer("haber", 0);
    setValueBuffer("debe", debe);
    setValueBuffer("coddivisa", valoresDefecto.coddivisa);
    setValueBuffer("tasaconv", 1);
    setValueBuffer("haberME", 0);
    setValueBuffer("debeME", 0);
  }
  if (!curPartida.commitBuffer())
    return false;

  return true;
}

function chequesCli_totalesReciboCli()
{
  if (!this.iface.__totalesReciboCli()) {
    return false;
  }
  this.iface.curReciboCli.setValueBuffer("pagoporcheque", formRecordreciboscli.iface.pub_commonCalculateField("pagoporcheque", this.iface.curReciboCli));
  return true;
}
//// CHEQUES CLI //////////////////////////////////////////
/////////////////////////////////////////////////////////////////