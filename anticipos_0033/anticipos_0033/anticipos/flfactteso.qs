
/** @class_declaration anticipos */
//////////////////////////////////////////////////////////////////
//// ANTICIPOS ///////////////////////////////////////////////////
class anticipos extends oficial
{
  function anticipos(context)
  {
    oficial(context);
  }
  function afterCommit_anticiposcli(curA)
  {
    return this.ctx.anticipos_afterCommit_anticiposcli(curA);
  }
  function afterCommit_reciboscli(curR)
  {
    return this.ctx.anticipos_afterCommit_reciboscli(curR);
  }
  function actualizaSaldoCliente(curRA)
  {
    return this.ctx.anticipos_actualizaSaldoCliente(curRA);
  }
  function beforeCommit_anticiposcli(curA)
  {
    return this.ctx.anticipos_beforeCommit_anticiposcli(curA);
  }
  function borrarAsientoAnticipo(curA)
  {
    return this.ctx.anticipos_borrarAsientoAnticipo(curA);
  }
  function desvincularReciboAnticipo(idRecibo, idAnticipo, actualizaPte)
  {
    return this.ctx.anticipos_desvincularReciboAnticipo(idRecibo, idAnticipo, actualizaPte);
  }
  //  function generarReciboAnticipo(curFactura, numRecibo, idAnticipo, datosCuentaDom) {
  //    return this.ctx.anticipos_generarReciboAnticipo(curFactura, numRecibo, idAnticipo, datosCuentaDom);
  //  }
  function generaRecibosPreviosCli(curFactura, oRecibo)
  {
    return this.ctx.anticipos_generaRecibosPreviosCli(curFactura, oRecibo);
  }
  function datosPartidaDebeAnticipo(curPartida, curA)
  {
    return this.ctx.anticipos_datosPartidaDebeAnticipo(curPartida, curA);
  }
  function datosPartidaHaberAnticipo(curPartida, curA)
  {
    return this.ctx.anticipos_datosPartidaHaberAnticipo(curPartida, curA);
  }
  //  function regenerarRecibosCli(cursor) {
  //    return this.ctx.anticipos_regenerarRecibosCli(cursor);
  //  }
  function generarCodigoAnticipoCli(curA)
  {
    return this.ctx.anticipos_generarCodigoAnticipoCli(curA);
  }
  function generarAsientoAnticipoCli(oParam)
  {
    return this.ctx.anticipos_generarAsientoAnticipoCli(oParam);
  }
  function datosReciboCli(curFactura, oRecibo)
  {
    return this.ctx.anticipos_datosReciboCli(curFactura, oRecibo);
  }
  function actualizaPteAnticipo(idAnticipo)
  {
    return this.ctx.anticipos_actualizaPteAnticipo(idAnticipo);
  }
  function aplicarAnticipo(curR, curA, actualizaPte)
  {
    return this.ctx.anticipos_aplicarAnticipo(curR, curA, actualizaPte);
  }
  function init()
  {
    return this.ctx.anticipos_init();
  }
  function iniciaPteAnticipos()
  {
    return this.ctx.anticipos_iniciaPteAnticipos();
  }
  function calcularEstadoFacturaCli(idRecibo, idFactura)
  {
    return this.ctx.anticipos_calcularEstadoFacturaCli(idRecibo, idFactura);
  }
}
//// ANTICIPOS ///////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration pubAnticipos */
/////////////////////////////////////////////////////////////////
//// PUB ANTICIPOS //////////////////////////////////////////////
class pubAnticipos extends ifaceCtx
{
  function pubAnticipos(context)
  {
    ifaceCtx(context);
  }
  function pub_actualizaPteAnticipo(idAnticipo)
  {
    return this.actualizaPteAnticipo(idAnticipo);
  }
  function pub_aplicarAnticipo(curR, curA, actualizaPte)
  {
    return this.aplicarAnticipo(curR, curA, actualizaPte);
  }
  function pub_desvincularReciboAnticipo(idRecibo, idAnticipo, actualizaPte)
  {
    return this.desvincularReciboAnticipo(idRecibo, idAnticipo, actualizaPte);
  }
  function pub_actualizaSaldoCliente(curRA)
  {
    return this.actualizaSaldoCliente(curRA);
  }
}
//// PUB ANTICIPOS //////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
/** @class_definition anticipos */
//////////////////////////////////////////////////////////////////
//// ANTICIPOS ///////////////////////////////////////////////////
/** \C Se elimina, si es posible, el asiento contable asociado al anticipo
\end */
function anticipos_afterCommit_anticiposcli(curA)
{
  var _i = this.iface;
  if (!_i.borrarAsientoAnticipo(curA)) {
    return false;
  }
  if (curA.modeAccess() == curA.Del) {
    var idAnticipo = curA.valueBuffer("idanticipo");
    var q = new FLSqlQuery;
    q.setSelect("idrecibo");
    q.setFrom("reciboscli");
    q.setWhere("idanticipo = " + idAnticipo);
    q.setForwardOnly(true);
    if (!q.exec()) {
      return false;
    }
    while (q.next()) {
      if (!_i.desvincularReciboAnticipo(q.value("idrecibo"), curA.valueBuffer("idanticipo"), false)) {
        return false;
      }
    }
  }
  if (!_i.actualizaSaldoCliente(curA)) {
    return false;
  }
  return true;
}

function anticipos_afterCommit_reciboscli(curR)
{
  var _i = this.iface;
  if (!_i.__afterCommit_reciboscli(curR)) {
    return false;
  }
  if (!_i.actualizaSaldoCliente(curR)) {
    return false;
  }
  return true;
}

function anticipos_actualizaSaldoCliente(curRA)
{
  var codCliente = curRA.valueBuffer("codcliente");
  if (!codCliente || codCliente == "") {
    return false;
  }
  var curCliente = new FLSqlCursor("clientes");
  curCliente.setActivatedCommitActions(false);
  curCliente.setActivatedCheckIntegrity(false);
  curCliente.select("codcliente = '" + codCliente + "'");
  if (!curCliente.first()) {
    return false;
  }
  curCliente.setModeAccess(curCliente.Edit);
  curCliente.refreshBuffer();
  curCliente.setValueBuffer("saldoanticipos", formRecordclientes.iface.pub_commonCalculateField("saldoanticipos", curCliente));
  if (!curCliente.commitBuffer()) {
    return false;
  }
  return true;
}

function anticipos_borrarAsientoAnticipo(curA)
{
  var util = new FLUtil();
  if (sys.isLoadedModule("flcontppal") == false || util.sqlSelect("empresa", "contintegrada", "1 = 1") == false) {
    return true;
  }
  if (curA.modeAccess() == curA.Del) {
    if (curA.isNull("idasiento")) {
      return true;
    }
    var idAsiento: Number = curA.valueBuffer("idasiento");
    if (flfacturac.iface.pub_asientoBorrable(idAsiento) == false) {
      return false;
    }
    var curAsiento: FLSqlCursor = new FLSqlCursor("co_asientos");
    curAsiento.select("idasiento = " + idAsiento);
    if (curAsiento.first()) {
      curAsiento.setUnLock("editable", true);
      curAsiento.setModeAccess(curAsiento.Del);
      curAsiento.refreshBuffer();
      if (!curAsiento.commitBuffer()) {
        return false;
      }
    }
  }
  return true;
}

function anticipos_desvincularReciboAnticipo(idRecibo, idAnticipo, actualizaPte)
{
  var _i = this.iface;
  if (!_i.curReciboCli) {
    _i.curReciboCli = new FLSqlCursor("reciboscli");
  }
  _i.curReciboCli.select("idrecibo = " + idRecibo);
  if (!_i.curReciboCli.first()) {
    return true;
  }
  _i.curReciboCli.setModeAccess(_i.curReciboCli.Edit);
  _i.curReciboCli.refreshBuffer();
  var idFactura = _i.curReciboCli.valueBuffer("idfactura");
  var idRecibo = _i.curReciboCli.valueBuffer("idrecibo");
  if (idAnticipo != _i.curReciboCli.valueBuffer("idanticipo")) {
    return false;
  }
  _i.curReciboCli.setValueBuffer("idanticipo", 0);
  _i.curReciboCli.setValueBuffer("estado", "Emitido");
  if (!_i.totalesReciboCli()) {
    return false;
  }
  if (!_i.curReciboCli.commitBuffer()) {
    return false;
  }
  if (!_i.calcularEstadoFacturaCli(idRecibo, idFactura)) {
    return false;
  }
  if (actualizaPte) {
    if (!_i.actualizaPteAnticipo(idAnticipo)) {
      return false;
    }
  }
  return true;
}

/** \C Se crea o se regenera, si es posible, el asiento contable asociado al anticipo
\end */
function anticipos_beforeCommit_anticiposcli(curA)
{
  if (!this.iface.generarCodigoAnticipoCli(curA)) {
    return false;
  }
  var oParam = new Object;
  oParam.curA = curA;
  oParam.errorMsg = sys.translate("Error al crear el asiento de anticipo");
  var f = new Function("oParam", "return flfactteso.iface.generarAsientoAnticipoCli(oParam)");
  if (!sys.runTransaction(f, oParam)) {
    return false;
  }

  //   if (!this.iface.generarAsientoAnticipoCli(curA)) {
  //     return false;
  //   }
  return true;
}

function anticipos_generarCodigoAnticipoCli(curA)
{
  switch (curA.modeAccess()) {
    case curA.Insert: {
      if (curA.valueBuffer("codigo") != 0) {
        return true;
      }
      var codEjercicio = curA.valueBuffer("codejercicio");
      var numero = flfactppal.iface.pub_siguienteSecuenciaEjercicio(codEjercicio, "nanticipo");
      if (!numero) {
        return false;
      }
      var codigo = codEjercicio + flfactppal.iface.pub_cerosIzquierda(numero, 6);
      curA.setValueBuffer("codigo", codigo);
      break;
    }
  }
  return true;
}

function anticipos_generarAsientoAnticipoCli(oParam)
{
  var curA = oParam.curA;
  var _i = this.iface;
  if (!sys.isLoadedModule("flcontppal") || !flfactppal.iface.pub_valorDefectoEmpresa("contintegrada") || curA.valueBuffer("nogenerarasiento")) {
    return true;
  }
  if (curA.modeAccess() != curA.Insert && curA.modeAccess() != curA.Edit) {
    return true;
  }
  var util = new FLUtil();
  var codEjercicio = curA.valueBuffer("codejercicio");
  var datosAsiento: Array = [];
  var valoresDefecto: Array;
  valoresDefecto["codejercicio"] = codEjercicio;
  valoresDefecto["coddivisa"] = util.sqlSelect("empresa", "coddivisa", "1 = 1");
  datosAsiento = flfacturac.iface.pub_regenerarAsiento(curA, valoresDefecto);
  if (datosAsiento.error == true) {
    return false;
  }
  var ctaDebe: Array = [];
  var ctaHaber: Array = [];
  var codCliente = curA.isNull("codcliente")
                   ? util.sqlSelect("pedidoscli", "codcliente", "idpedido = " + curA.valueBuffer("idpedido"))
                   : curA.valueBuffer("codcliente");
  ctaHaber = flfactppal.iface.pub_datosCtaCliente(codCliente, valoresDefecto);
  if (ctaHaber.error != 0) {
    return false;
  }
  ctaDebe.idsubcuenta = util.sqlSelect("co_subcuentas", "idsubcuenta", "codsubcuenta = '" + curA.valueBuffer("codsubcuenta") + "' AND codejercicio = '" + valoresDefecto.codejercicio + "'");
  if (!ctaDebe.idsubcuenta) {
    MessageBox.warning(sys.translate("No existe la subcuenta para el ejercicio seleccionado:") + "\n" + curA.valueBuffer("codsubcuenta") + "\n" + valoresDefecto.codejercicio, MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  ctaDebe.codsubcuenta = curA.valueBuffer("codsubcuenta");

  var debe: Number = 0;
  var haber: Number = 0;
  var debeME: Number = 0;
  var haberME: Number = 0;
  var tasaconvDebe: Number = 1;
  var tasaconvHaber: Number = 1;
  var diferenciaCambio: Number = 0;
  var pedido;
  if (!curA.isNull("idpedido")) {
    pedido = flfactppal.iface.pub_ejecutarQry("pedidoscli", "coddivisa,codigo,tasaconv,nombrecliente", "idpedido = " + curA.valueBuffer("idpedido"));
    if (pedido.result != 1) {
      return false;
    }
  } else if (!curA.isNull("idalbaran")) {
    pedido = flfactppal.iface.pub_ejecutarQry("albaranescli", "coddivisa,codigo,tasaconv,nombrecliente", "idalbaran = " + curA.valueBuffer("idalbaran"));
    if (pedido.result != 1) {
      return false;
    }
  } else {
    pedido = [];
    pedido.coddivisa = curA.valueBuffer("coddivisa");
    pedido.codigo = "";
    pedido.tasaconv = curA.valueBuffer("tasaconv");
    pedido.nombrecliente = curA.valueBuffer("nombrecliente");
  }

  if (valoresDefecto.coddivisa == pedido.coddivisa) {
    debe = curA.valueBuffer("importe");
    debeME = 0;
    haber = debe;
    haberMe = 0;
  } else {
    tasaconvDebe = curA.valueBuffer("tasaconv");
    tasaconvHaber = pedido.tasaconv;
    debe = parseFloat(curA.valueBuffer("importe")) * parseFloat(tasaconvDebe);
    debeME = parseFloat(curA.valueBuffer("importe"));
    haber = parseFloat(curA.valueBuffer("importe")) * parseFloat(tasaconvHaber);
    haberME = parseFloat(curA.valueBuffer("importe"));
    diferenciaCambio = debe - haber;
    if (util.buildNumber(diferenciaCambio, "f", 2) == "0.00" || util.buildNumber(diferenciaCambio, "f", 2) == "-0.00") {
      diferenciaCambio = 0;
      debe = haber;
    }
  }
  debug("partidadebe");
  var concepto = sys.translate("Anticipo %1 - %2").arg(curA.valueBuffer("codigo")).arg(pedido.nombrecliente);
  var curPartida = new FLSqlCursor("co_partidas");
  with(curPartida) {
    setModeAccess(curPartida.Insert);
    refreshBuffer();
    setValueBuffer("concepto", concepto);
    setValueBuffer("idsubcuenta", ctaDebe.idsubcuenta);
    setValueBuffer("codsubcuenta", ctaDebe.codsubcuenta);
    setValueBuffer("idasiento", datosAsiento.idasiento);
    setValueBuffer("debe", debe);
    setValueBuffer("haber", 0);
    setValueBuffer("coddivisa", pedido.coddivisa);
    setValueBuffer("tasaconv", tasaconvDebe);
    setValueBuffer("debeME", debeME);
    setValueBuffer("haberME", 0);
  }
  if (!_i.datosPartidaDebeAnticipo(curPartida, curA)) {
    return false;
  }
  if (!curPartida.commitBuffer()) {
    return false;
  }
  debug("partidadebe OK");
  with(curPartida) {
    setModeAccess(curPartida.Insert);
    refreshBuffer();
    setValueBuffer("concepto", concepto);
    setValueBuffer("idsubcuenta", ctaHaber.idsubcuenta);
    setValueBuffer("codsubcuenta", ctaHaber.codsubcuenta);
    setValueBuffer("idasiento", datosAsiento.idasiento);
    setValueBuffer("debe", 0);
    setValueBuffer("haber", haber);
    setValueBuffer("coddivisa", pedido.coddivisa);
    setValueBuffer("tasaconv", tasaconvHaber);
    setValueBuffer("debeME", 0);
    setValueBuffer("haberME", haberME);
  }
  if (!_i.datosPartidaHaberAnticipo(curPartida, curA)) {
    return false;
  }
  if (!curPartida.commitBuffer()) {
    return false;
  }
  /** \C En el caso de que la divisa sea extranjera y la tasa de cambio haya variado, la diferencia se imputará a la correspondiente cuenta de diferencias de cambio.
    \end */
  debug("partida haberok");
  //   if (diferenciaCambio != 0) {
  //    debug("partidadebe");
  //     var ctaDifCambio: Array = [];
  //     var debeDifCambio: Number = 0;
  //     var haberDifCambio: Number = 0;
  //     if (diferenciaCambio > 0) {
  //       ctaDifCambio = flfacturac.iface.pub_datosCtaEspecial("CAMPOS", valoresDefecto.codejercicio);
  //       if (ctaDifCambio.error != 0)
  //         return false;
  //       debeDifCambio = 0;
  //       haberDifCambio = diferenciaCambio;
  //     } else {
  //       ctaDifCambio = flfacturac.iface.pub_datosCtaEspecial("CAMNEG", valoresDefecto.codejercicio);
  //       if (ctaDifCambio.error != 0)
  //         return false;
  //       diferenciaCambio = 0 - diferenciaCambio;
  //       debeDifCambio = diferenciaCambio;
  //       haberDifCambio = 0;
  //     }
  //
  //     with(curPartida) {
  //       setModeAccess(curPartida.Insert);
  //       refreshBuffer();
  //       setValueBuffer("concepto", concepto);
  //       setValueBuffer("idsubcuenta", ctaDifCambio.idsubcuenta);
  //       setValueBuffer("codsubcuenta", ctaDifCambio.codsubcuenta);
  //       setValueBuffer("idasiento", datosAsiento.idasiento);
  //       setValueBuffer("debe", debeDifCambio);
  //       setValueBuffer("haber", haberDifCambio);
  //       setValueBuffer("coddivisa", valoresDefecto.coddivisa);
  //       setValueBuffer("tasaconv", 1);
  //       setValueBuffer("debeME", 0);
  //       setValueBuffer("haberME", 0);
  //     }
  //     if (!curPartida.commitBuffer()) {
  //       return false;
  //     }
  //   }
  curA.setValueBuffer("idasiento", datosAsiento.idasiento);

  if (!flcontppal.iface.pub_comprobarAsiento(datosAsiento.idasiento)) {
    throw util.translate("scripts", "Error al comprobar el asiento");
  }

  return true;
}

function anticipos_datosPartidaDebeAnticipo(curPartida, curA)
{
  return true;
}
function anticipos_datosPartidaHaberAnticipo(curPartida, curA)
{
  return true;
}

function anticipos_generaRecibosPreviosCli(curFactura, oRecibo)
{
  var util: FLUtil = new FLUtil();

  var idFactura = curFactura.valueBuffer("idfactura");
  var total = parseFloat(curFactura.valueBuffer("total"));
  var codCliente = curFactura.valueBuffer("codcliente");
  var numRecibo: Number = 1;
  var importe, idRecibo;

  var oldEmitirComo = oRecibo["emitircomo"];
  oRecibo["emitircomo"] = "Emitido";

  /** \C En el caso de que existan anticipos de pedido crea un recibo como pagado para cada uno de ellos.
  \end */
  qryAnticipos = new FLSqlQuery();
  qryAnticipos.setTablesList("anticiposcli,pedidoscli,lineasalbaranescli,albaranescli,facturascli");
  qryAnticipos.setSelect("idanticipo, importe, a.fecha");
  qryAnticipos.setFrom("anticiposcli a inner join pedidoscli p on a.idpedido = p.idpedido inner join lineasalbaranescli la on la.idpedido = p.idpedido inner join albaranescli ab on ab.idalbaran = la.idalbaran inner join facturascli f on f.idfactura = ab.idfactura");
  qryAnticipos.setWhere("f.idfactura = " + idFactura + " group by idanticipo, importe, a.fecha");
  if (!qryAnticipos.exec()) {
    return false;
  }
  while (qryAnticipos.next()) {
    importe = parseFloat(qryAnticipos.value("importe"));
    oRecibo["numrecibo"] = numRecibo;
    oRecibo["importe"] = importe;
    oRecibo["fechavto"] = qryAnticipos.value("a.fecha");
    oRecibo["idanticipo"] = qryAnticipos.value("idanticipo");
    if (!this.iface.generaReciboCli(curFactura, oRecibo)) {
      return false;
    }
    idRecibo = this.iface.curReciboCli.valueBuffer("idrecibo");
    if (!this.iface.actualizarTotalesReciboCli(idRecibo)) {
      return false;
    }
    total -= importe;
    numRecibo++;
  }

  /** \C En el caso de que existan anticipos de albarán crea un recibo como pagado para cada uno de ellos.
  \end */
  qryAnticipos = new FLSqlQuery();
  qryAnticipos.setTablesList("anticiposcli,albaranescli,facturascli");
  qryAnticipos.setSelect("idanticipo, importe, a.fecha");
  qryAnticipos.setFrom("anticiposcli a inner join albaranescli ab on a.idalbaran = ab.idalbaran inner join facturascli f on f.idfactura = ab.idfactura");
  qryAnticipos.setWhere("f.idfactura = " + idFactura + " group by idanticipo, importe, a.fecha");
  if (!qryAnticipos.exec()) {
    return false;
  }
  while (qryAnticipos.next()) {
    importe = parseFloat(qryAnticipos.value("importe"));
    oRecibo["numrecibo"] = numRecibo;
    oRecibo["importe"] = importe;
    oRecibo["fechavto"] = qryAnticipos.value("a.fecha");
    oRecibo["idanticipo"] = qryAnticipos.value("idanticipo");
    if (!this.iface.generaReciboCli(curFactura, oRecibo)) {
      return false;
    }
    idRecibo = this.iface.curReciboCli.valueBuffer("idrecibo");
    if (!this.iface.actualizarTotalesReciboCli(idRecibo)) {
      return false;
    }
    total -= importe;
    numRecibo++;
  }

  var aDatos = new Object();
  aDatos["numrecibo"] = numRecibo;
  aDatos["totalpendiente"] = total;

  oRecibo["emitircomo"] = oldEmitirComo;
  oRecibo["idanticipo"] = false;
  return aDatos;
}

function anticipos_datosReciboCli(curFactura, oRecibo)
{
  if (!this.iface.__datosReciboCli(curFactura, oRecibo)) {
    return false;
  }
  if ("idanticipo" in oRecibo && oRecibo["idanticipo"]) {
    this.iface.curReciboCli.setValueBuffer("idanticipo", oRecibo.idanticipo);
    this.iface.curReciboCli.setValueBuffer("estado", "Pagado");
  }
  return true;
}

function anticipos_actualizaPteAnticipo(idAnticipo)
{
  var curA = new FLSqlCursor("anticiposcli");
  curA.select("idanticipo = " + idAnticipo);
  if (!curA.first()) {
    return false;
  }
  curA.setModeAccess(curA.Edit);
  curA.refreshBuffer();
  curA.setValueBuffer("cancelado", formRecordanticiposcli.iface.pub_commonCalculateField("cancelado", curA));
  curA.setValueBuffer("pendiente", formRecordanticiposcli.iface.pub_commonCalculateField("pendiente", curA));
  curA.setValueBuffer("pendienteeuros", formRecordanticiposcli.iface.pub_commonCalculateField("pendienteeuros", curA));
  if (!curA.commitBuffer()) {
    return false;
  }
  return true;
}

function anticipos_aplicarAnticipo(curR, curA, actualizaPte)
{
  var _i = this.iface;
  var util = new FLUtil;
  var idRecibo = curR.valueBuffer("idrecibo");
  var idAnticipo = curA.valueBuffer("idanticipo");
  var codCliente = curR.valueBuffer("codcliente");
  var importeR = curR.valueBuffer("importe");
  var importeA = parseFloat(curA.valueBuffer("pendiente"));
  if (!_i.curReciboCli) {
    _i.curReciboCli = new FLSqlCursor("reciboscli");
  }
  if (curR.valueBuffer("codcliente") != curA.valueBuffer("codcliente")) {
    MessageBox.warning(sys.translate("Los clientes de recibo y pago no coinciden"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  if (curR.valueBuffer("coddivisa") != curA.valueBuffer("coddivisa")) {
    MessageBox.warning(sys.translate("Las divisas de recibo y pago no coinciden"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  var curRecibo = _i.curReciboCli;
  curRecibo.select("idrecibo = " + idRecibo);
  if (!curRecibo.first()) {
    return false;
  }
  curRecibo.setModeAccess(curRecibo.Edit);
  curRecibo.refreshBuffer();
  var idFactura = curRecibo.valueBuffer("idfactura");
  var idRecibo = curRecibo.valueBuffer("idrecibo");
  if (importeA < importeR) {
    if (curR.isNull("idfactura")) {
      MessageBox.warning(sys.translate("El importe del anticipo nº %1 (%2) es menor que el del recibo %3 (%4). Dado que el recibo es agrupado, éste no puede dividirse").arg(curA.valueBuffer("codigo")).arg(AQUtil.formatoMiles(AQUtil.roundFieldValue(curA.valueBuffer("pendiente"), "anticiposcli", "pendiente"))).arg(curRecibo.valueBuffer("codigo")).arg(AQUtil.formatoMiles(AQUtil.roundFieldValue(curRecibo.valueBuffer("importe"), "reciboscli", "importe"))), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton, "AbanQ");
      return false;
    }
    var res = MessageBox.warning(sys.translate("El importe del anticipo nº %1 (%2) no coincide con el del recibo %3 (%4). El recibo se dividirá.\n¿Está seguro?").arg(curA.valueBuffer("codigo")).arg(AQUtil.formatoMiles(AQUtil.roundFieldValue(curA.valueBuffer("pendiente"), "anticiposcli", "pendiente"))).arg(curRecibo.valueBuffer("codigo")).arg(AQUtil.formatoMiles(AQUtil.roundFieldValue(curRecibo.valueBuffer("importe"), "reciboscli", "importe"))), MessageBox.Yes, MessageBox.No);
    if (res != MessageBox.Yes) {
      return false;
    }
    curRecibo.setValueBuffer("importe", importeA);
    curRecibo.setValueBuffer("importesingd", importeA - curRecibo.valueBuffer("gastodevol")); /// Ext. gasto_devol_cli
    if (!formRecordreciboscli.iface.pub_divisionRecibo(curRecibo, importeR)) {
      return false;
    }
  }
  curRecibo.setValueBuffer("estado", "Pagado");
  curRecibo.setValueBuffer("idanticipo", idAnticipo);
  if (!flfactteso.iface.totalesReciboCli()) {
    return true;
  }
  if (!curRecibo.commitBuffer()) {
    return false;
  }
  if (actualizaPte) {
    if (!flfactteso.iface.pub_actualizaPteAnticipo(idAnticipo)) {
      return false;
    }
  }
  if (!_i.calcularEstadoFacturaCli(idRecibo, idFactura)) {
    return false;
  }

  return true;
}

function anticipos_init()
{
  var _i = this.iface;
  _i.__init();

  _i.iniciaPteAnticipos();
}

function anticipos_iniciaPteAnticipos()
{
  var codDivisaEmpresa = flfactppal.iface.pub_valorDefectoEmpresa("coddivisa");
  var curA = new FLSqlCursor("anticiposcli");
  curA.setActivatedCheckIntegrity(false);
  curA.setActivatedCommitActions(false);
  curA.select("importe <> (cancelado + pendiente) OR (importe <> 0 AND importeeuros = 0)");
  while (curA.next()) {
    curA.setModeAccess(curA.Edit);
    curA.refreshBuffer();
    curA.setValueBuffer("pendiente", formRecordanticiposcli.iface.pub_commonCalculateField("pendiente", curA));
    if (curA.valueBuffer("importeeuros") == 0) {
      if (curA.isNull("coddivisa")) {
        curA.setValueBuffer("coddivisa", codDivisaEmpresa);
        curA.setValueBuffer("tasaconv", 1);
      }
      curA.setValueBuffer("importeeuros", formRecordanticiposcli.iface.pub_commonCalculateField("importeeuros", curA));
      curA.setValueBuffer("pendienteeuros", formRecordanticiposcli.iface.pub_commonCalculateField("pendienteeuros", curA));
    }
    if (!curA.commitBuffer()) {
      return false;
    }
  }
  return true;
}

function anticipos_calcularEstadoFacturaCli(idRecibo, idFactura)
{
  var _i = this.iface;
  if (!idFactura) {
    idFactura = AQUtil.sqlSelect("reciboscli", "idfactura", "idrecibo = " + idRecibo);
    if (!idFactura) { /// Recibo agrupado
      return true;
    }
  }

  if (!AQUtil.sqlSelect("reciboscli", "idrecibo", "idfactura = " + idFactura + " AND estado = 'Pagado' AND idanticipo <> 0")) {
    return _i.__calcularEstadoFacturaCli(idRecibo, idFactura);
  }
  var curFactura = new FLSqlCursor("facturascli");
  curFactura.select("idfactura = " + idFactura);
  curFactura.first();
  curFactura.setUnLock("editable", false);
  return true;
}

//// ANTICIPOS ///////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
