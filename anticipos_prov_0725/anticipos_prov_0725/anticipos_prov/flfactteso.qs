
/** @class_declaration anticiposprov */
//////////////////////////////////////////////////////////////////
//// ANTICIPOS A PROVEEDORES /////////////////////////////////////
class anticiposprov extends proveed
{
  function anticiposprov(context)
  {
    proveed(context);
  }
  function init(curA)
  {
    return this.ctx.anticiposprov_init(curA);
  }
  function iniciaPteAnticiposProv()
  {
    return this.ctx.anticiposprov_iniciaPteAnticiposProv();
  }
  function afterCommit_anticiposprov(curA)
  {
    return this.ctx.anticiposprov_afterCommit_anticiposprov(curA);
  }
  function afterCommit_recibosprov(curR)
  {
    return this.ctx.anticiposprov_afterCommit_recibosprov(curR);
  }
  function actualizaSaldoProveedor(curRA)
  {
    return this.ctx.anticiposprov_actualizaSaldoProveedor(curRA);
  }
  function beforeCommit_anticiposprov(curA)
  {
    return this.ctx.anticiposprov_beforeCommit_anticiposprov(curA);
  }
  function borrarAsientoAnticipoProv(curA)
  {
    return this.ctx.anticiposprov_borrarAsientoAnticipoProv(curA);
  }
  function desvincularReciboAnticipoProv(idRecibo, idAnticipo, actualizaPte)
  {
    return this.ctx.anticiposprov_desvincularReciboAnticipoProv(idRecibo, idAnticipo, actualizaPte);
  }
  function generaRecibosPreviosCli(curFactura, oRecibo)
  {
    return this.ctx.anticiposprov_generaRecibosPreviosProv(curFactura, oRecibo);
  }
  function datosPartidaDebeAnticipoProv(curPartida, curA)
  {
    return this.ctx.anticiposprov_datosPartidaDebeAnticipoProv(curPartida, curA);
  }
  function datosPartidaHaberAnticipoProv(curPartida, curA)
  {
    return this.ctx.anticiposprov_datosPartidaHaberAnticipoProv(curPartida, curA);
  }
  function generarCodigoAnticipoProv(curA)
  {
    return this.ctx.anticiposprov_generarCodigoAnticipoProv(curA);
  }
  function generarAsientoAnticipoProv(oParam)
  {
    return this.ctx.anticiposprov_generarAsientoAnticipoProv(oParam);
  }
  function datosReciboProv(curFactura, oRecibo)
  {
    return this.ctx.anticiposprov_datosReciboProv(curFactura, oRecibo);
  }
  function actualizaPteAnticipoProv(idAnticipo)
  {
    return this.ctx.anticiposprov_actualizaPteAnticipoProv(idAnticipo);
  }
  function aplicarAnticipoProv(curR, curA, actualizaPte)
  {
    return this.ctx.anticiposprov_aplicarAnticipoProv(curR, curA, actualizaPte);
  }
  function calcularEstadoFacturaProv(idRecibo, idFactura)
  {
    return this.ctx.anticiposprov_calcularEstadoFacturaProv(idRecibo, idFactura);
  }
}
//// ANTICIPOS A PROVEEDORES /////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration pubAnticiposProv */
/////////////////////////////////////////////////////////////////
//// PUB ANTICIPOS A PROVEEDORES ////////////////////////////////
class pubAnticiposProv extends pubProveed
{
  function pubAnticiposProv(context)
  {
    pubProveed(context);
  }
  function pub_actualizaPteAnticipoProv(idAnticipo)
  {
    return this.actualizaPteAnticipoProv(idAnticipo);
  }
  function pub_aplicarAnticipoProv(curR, curA, actualizaPte)
  {
    return this.aplicarAnticipoProv(curR, curA, actualizaPte);
  }
  function pub_desvincularReciboAnticipoProv(idRecibo, idAnticipo, actualizaPte)
  {
    return this.desvincularReciboAnticipoProv(idRecibo, idAnticipo, actualizaPte);
  }
  function pub_actualizaSaldoProveedor(curRA)
  {
    return this.actualizaSaldoProveedor(curRA);
  }
}
//// PUB ANTICIPOS A PROVEEDORES ////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition anticiposprov */
//////////////////////////////////////////////////////////////////
//// ANTICIPOS A PROVEEDORES /////////////////////////////////////
/** \C Se elimina, si es posible, el asiento contable asociado al anticipo
\end */
function anticiposprov_afterCommit_anticiposprov(curA)
{
  var _i = this.iface;
  if (!_i.borrarAsientoAnticipoProv(curA)) {
    return false;
  }
  if (curA.modeAccess() == curA.Del) {
    var idAnticipo = curA.valueBuffer("idanticipo");
    var q = new FLSqlQuery;
    q.setSelect("idrecibo");
    q.setFrom("recibosprov");
    q.setWhere("idanticipo = " + idAnticipo);
    q.setForwardOnly(true);
    if (!q.exec()) {
      return false;
    }
    while (q.next()) {
      if (!this.iface.desvincularReciboAnticipoProv(q.value("idrecibo"), curA.valueBuffer("idanticipo"), false)) {
        return false;
      }
    }
  }
  if (!_i.actualizaSaldoProveedor(curA)) {
    return false;
  }
  return true;
}

function anticiposprov_afterCommit_recibosprov(curR)
{
  var _i = this.iface;
  //  if (!_i.__afterCommit_recibosprov(curR)) {
  //    return false;
  //  }
  if (!_i.actualizaSaldoProveedor(curR)) {
    return false;
  }
  return true;
}

function anticiposprov_actualizaSaldoProveedor(curRA)
{
  var codProveedor = curRA.valueBuffer("codproveedor");
  if (!codProveedor || codProveedor == "") {
    return false;
  }
  var curProveedor = new FLSqlCursor("proveedores");
  curProveedor.setActivatedCommitActions(false);
  curProveedor.setActivatedCheckIntegrity(false);
  curProveedor.select("codproveedor = '" + codProveedor + "'");
  if (!curProveedor.first()) {
    return false;
  }
  curProveedor.setModeAccess(curProveedor.Edit);
  curProveedor.refreshBuffer();
  curProveedor.setValueBuffer("saldoanticipos", formRecordproveedores.iface.pub_commonCalculateField("saldoanticipos", curProveedor));
  if (!curProveedor.commitBuffer()) {
    return false;
  }
  return true;
}

function anticiposprov_borrarAsientoAnticipoProv(curA)
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

function anticiposprov_desvincularReciboAnticipoProv(idRecibo, idAnticipo, actualizaPte)
{
  var _i = this.iface;
  if (!_i.curReciboProv) {
    _i.curReciboProv = new FLSqlCursor("recibosprov");
  }
  _i.curReciboProv.select("idrecibo = " + idRecibo);
  if (!_i.curReciboProv.first()) {
    return true;
  }
  _i.curReciboProv.setModeAccess(_i.curReciboProv.Edit);
  _i.curReciboProv.refreshBuffer();
  var idFactura = _i.curReciboProv.valueBuffer("idfactura");
  if (idAnticipo != _i.curReciboProv.valueBuffer("idanticipo")) {
    return false;
  }
  _i.curReciboProv.setValueBuffer("idanticipo", 0);
  _i.curReciboProv.setValueBuffer("estado", "Emitido");
  if (!_i.totalesReciboProv()) {
    return false;
  }
  if (!_i.curReciboProv.commitBuffer()) {
    return false;
  }
  if (!_i.calcularEstadoFacturaProv(false, idFactura)) {
    return false;
  }
  if (actualizaPte) {
    if (!_i.actualizaPteAnticipoProv(idAnticipo)) {
      return false;
    }
  }
  return true;
}
/** \C Se crea o se regenera, si es posible, el asiento contable asociado al anticipo
\end */
function anticiposprov_beforeCommit_anticiposprov(curA)
{
  var _i = this.iface;
  if (!_i.generarCodigoAnticipoProv(curA)) {
    return false;
  }
  var oParam = new Object;
  oParam.curA = curA;
  oParam.errorMsg = sys.translate("Error al crear el asiento de anticipo");
  var f = new Function("oParam", "return flfactteso.iface.generarAsientoAnticipoProv(oParam)");
  if (!sys.runTransaction(f, oParam)) {
    return false;
  }
  //   if (!_i.generarAsientoAnticipoProv(curA)) {
  //     return false;
  //   }
  return true;
}

function anticiposprov_generarCodigoAnticipoProv(curA)
{
  switch (curA.modeAccess()) {
    case curA.Insert: {
      if (curA.valueBuffer("codigo") != 0) {
        return true;
      }
      var codEjercicio = curA.valueBuffer("codejercicio");
      var numero = flfactppal.iface.pub_siguienteSecuenciaEjercicio(codEjercicio, "nanticipoprov");
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

function anticiposprov_generarAsientoAnticipoProv(oParam)
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
  var datosAsiento = [];
  var valoresDefecto = [];
  valoresDefecto["codejercicio"] = codEjercicio;
  valoresDefecto["coddivisa"] = util.sqlSelect("empresa", "coddivisa", "1 = 1");
  datosAsiento = flfacturac.iface.pub_regenerarAsiento(curA, valoresDefecto);
  if (datosAsiento.error == true) {
    return false;
  }
  var ctaDebe = [];
  var ctaHaber = [];
  var codProveedor = curA.valueBuffer("codproveedor");
  ctaDebe = flfactppal.iface.pub_datosCtaProveedor(codProveedor, valoresDefecto);
  if (ctaDebe.error != 0) {
    return false;
  }
  ctaHaber.idsubcuenta = util.sqlSelect("co_subcuentas", "idsubcuenta", "codsubcuenta = '" + curA.valueBuffer("codsubcuenta") + "' AND codejercicio = '" + valoresDefecto.codejercicio + "'");
  if (!ctaHaber.idsubcuenta) {
    MessageBox.warning(util.translate("scripts", "No existe la subcuenta para el ejercicio seleccionado:") + "\n" + curA.valueBuffer("codsubcuenta") + "\n" + valoresDefecto.codejercicio, MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  ctaHaber.codsubcuenta = curA.valueBuffer("codsubcuenta");

  var debe = 0;
  var haber = 0;
  var debeME = 0;
  var haberME = 0;
  var tasaconvDebe = 1;
  var tasaconvHaber = 1;
  var diferenciaCambio = 0;

  if (valoresDefecto.coddivisa == curA.valueBuffer("coddivisa")) {
    debe = curA.valueBuffer("importe");
    debeME = 0;
    haber = debe;
    haberMe = 0;
  } else {
    tasaconvHaber = curA.valueBuffer("tasaconv");
    tasaconvDebe = curA.valueBuffer("tasaconv");
    debe = parseFloat(curA.valueBuffer("importeeuros"));
    debeME = parseFloat(curA.valueBuffer("importe"));
    haber = parseFloat(curA.valueBuffer("importeeuros"));
    haberME = parseFloat(curA.valueBuffer("importe"));
    //     diferenciaCambio = debe - haber;
    //     if (util.buildNumber(diferenciaCambio, "f", 2) == "0.00" || util.buildNumber(diferenciaCambio, "f", 2) == "-0.00") {
    //       diferenciaCambio = 0;
    //       debe = haber;
    //     }
  }
  var concepto = util.translate("scripts", "Anticipo %1 - %2").arg(curA.valueBuffer("codigo")).arg(curA.valueBuffer("nombreproveedor"));
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
    setValueBuffer("coddivisa", curA.valueBuffer("coddivisa"));
    setValueBuffer("tasaconv", tasaconvDebe);
    setValueBuffer("debeME", debeME);
    setValueBuffer("haberME", 0);
  }
  if (!_i.datosPartidaDebeAnticipoProv(curPartida, curA)) {
    return false;
  }
  if (!curPartida.commitBuffer()) {
    return false;
  }
  with(curPartida) {
    setModeAccess(curPartida.Insert);
    refreshBuffer();
    setValueBuffer("concepto", concepto);
    setValueBuffer("idsubcuenta", ctaHaber.idsubcuenta);
    setValueBuffer("codsubcuenta", ctaHaber.codsubcuenta);
    setValueBuffer("idasiento", datosAsiento.idasiento);
    setValueBuffer("debe", 0);
    setValueBuffer("haber", haber);
    setValueBuffer("coddivisa", curA.valueBuffer("coddivisa"));
    setValueBuffer("tasaconv", tasaconvHaber);
    setValueBuffer("debeME", 0);
    setValueBuffer("haberME", haberME);
  }
  if (!_i.datosPartidaHaberAnticipoProv(curPartida, curA)) {
    return false;
  }
  if (!curPartida.commitBuffer()) {
    return false;
  }
  /** \C En el caso de que la divisa sea extranjera y la tasa de cambio haya variado, la diferencia se imputará a la correspondiente cuenta de diferencias de cambio.
    \end */
  //   if (diferenciaCambio != 0) {
  //     var ctaDifCambio = [];
  //     var debeDifCambio = 0;
  //     var haberDifCambio = 0;
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

function anticiposprov_datosPartidaDebeAnticipoProv(curPartida, curA)
{
  return true;
}

function anticiposprov_datosPartidaHaberAnticipoProv(curPartida, curA)
{
  return true;
}

function anticiposprov_generaRecibosPreviosProv(curFactura, oRecibo)
{
  return true;

  /** Copiado de anticipos a clientes, se deja por si se incorporan anticipos a pedidos y albaranes de proveedores
  var util = new FLUtil();

  var idFactura = curFactura.valueBuffer("idfactura");
  var total = parseFloat(curFactura.valueBuffer("total"));
  var codProveedor = curFactura.valueBuffer("codproveedor");
  var numRecibo = 1;
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

function anticiposprov_datosReciboProv(curFactura, oRecibo)
{
  return true;

  /** Esto solo se da cuando se genera el recibo directamente asociado a un anticipo (cuando se asocia al pedido o albarán)
  var _i = this.iface;
  if (!_i.__datosReciboProv(curFactura, oRecibo)) {
    return false;
  }
  if ("idanticipo" in oRecibo && oRecibo["idanticipo"]) {
    _i.curReciboProv.setValueBuffer("idanticipo", oRecibo.idanticipo);
    _i.curReciboProv.setValueBuffer("estado", "Pagado");
  }
  return true;
  */
}

function anticiposprov_actualizaPteAnticipoProv(idAnticipo)
{
  var curA = new FLSqlCursor("anticiposprov");
  curA.select("idanticipo = " + idAnticipo);
  if (!curA.first()) {
    return false;
  }
  curA.setModeAccess(curA.Edit);
  curA.refreshBuffer();
  curA.setValueBuffer("cancelado", formRecordanticiposprov.iface.pub_commonCalculateField("cancelado", curA));
  curA.setValueBuffer("pendiente", formRecordanticiposprov.iface.pub_commonCalculateField("pendiente", curA));
  curA.setValueBuffer("pendienteeuros", formRecordanticiposprov.iface.pub_commonCalculateField("pendienteeuros", curA));
  if (!curA.commitBuffer()) {
    return false;
  }
  return true;
}

function anticiposprov_aplicarAnticipoProv(curR, curA, actualizaPte)
{
  var _i = this.iface;
  var util = new FLUtil;
  var idRecibo = curR.valueBuffer("idrecibo");
  var idAnticipo = curA.valueBuffer("idanticipo");
  var codProveedor = curR.valueBuffer("codproveedor");
  var importeR = curR.valueBuffer("importe");
  var importeA = parseFloat(curA.valueBuffer("pendiente"));
  if (!_i.curReciboProv) {
    _i.curReciboProv = new FLSqlCursor("recibosprov");
  }
  if (curR.valueBuffer("codproveedor") != curA.valueBuffer("codproveedor")) {
    MessageBox.warning(sys.translate("Los proveedores de recibo y pago no coinciden"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  if (curR.valueBuffer("coddivisa") != curA.valueBuffer("coddivisa")) {
    MessageBox.warning(sys.translate("Las divisas de recibo y pago no coinciden"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  var curRecibo = _i.curReciboProv;
  curRecibo.select("idrecibo = " + idRecibo);
  if (!curRecibo.first()) {
    return false;
  }
  curRecibo.setModeAccess(curRecibo.Edit);
  curRecibo.refreshBuffer();
  var idFactura = curRecibo.valueBuffer("idfactura");
  if (importeA < importeR) {
    var res = MessageBox.warning(util.translate("scripts", "Los importes de anticipo y recibo no coinciden. El recibo se dividirá.\n¿Está seguro?"), MessageBox.Yes, MessageBox.No);
    if (res != MessageBox.Yes) {
      return false;
    }
    curRecibo.setValueBuffer("importe", importeA);
    if (!formRecordrecibosprov.iface.pub_divisionRecibo(curRecibo, importeR)) {
      return false;
    }
  }
  curRecibo.setValueBuffer("estado", "Pagado");
  curRecibo.setValueBuffer("idanticipo", idAnticipo);
  if (!_i.totalesReciboProv()) {
    return true;
  }
  if (!curRecibo.commitBuffer()) {
    return false;
  }
  if (actualizaPte) {
    if (!_i.actualizaPteAnticipoProv(idAnticipo)) {
      return false;
    }
  }
  if (!_i.calcularEstadoFacturaProv(false, idFactura)) {
    return false;
  }

  return true;
}

function anticiposprov_init()
{
  var _i = this.iface;
  _i.__init();

  _i.iniciaPteAnticiposProv();
}

function anticiposprov_iniciaPteAnticiposProv()
{
  var codDivisaEmpresa = flfactppal.iface.pub_valorDefectoEmpresa("coddivisa");
  var curA = new FLSqlCursor("anticiposprov");
  curA.setActivatedCheckIntegrity(false);
  curA.setActivatedCommitActions(false);
  curA.select("importe <> (cancelado + pendiente) OR (importe <> 0 AND importeeuros = 0)");
  while (curA.next()) {
    curA.setModeAccess(curA.Edit);
    curA.refreshBuffer();
    curA.setValueBuffer("pendiente", formRecordanticiposprov.iface.pub_commonCalculateField("pendiente", curA));
    if (curA.valueBuffer("importeeuros") == 0) {
      if (curA.isNull("coddivisa")) {
        curA.setValueBuffer("coddivisa", codDivisaEmpresa);
        curA.setValueBuffer("tasaconv", 1);
      }
      curA.setValueBuffer("importeeuros", formRecordanticiposprov.iface.pub_commonCalculateField("importeeuros", curA));
      curA.setValueBuffer("pendienteeuros", formRecordanticiposprov.iface.pub_commonCalculateField("pendienteeuros", curA));
    }
    if (!curA.commitBuffer()) {
      return false;
    }
  }
  return true;
}

function anticiposprov_calcularEstadoFacturaProv(idRecibo, idFactura)
{
  var _i = this.iface;
  if (!idFactura) {
    idFactura = AQUtil.sqlSelect("recibosprov", "idfactura", "idrecibo = " + idRecibo);
  }

  if (!AQUtil.sqlSelect("recibosprov", "idrecibo", "idfactura = " + idFactura + " AND estado = 'Pagado' AND idanticipo <> 0")) {
    return _i.__calcularEstadoFacturaProv(idRecibo, idFactura);
  }
  var curFactura = new FLSqlCursor("facturasprov");
  curFactura.select("idfactura = " + idFactura);
  curFactura.first();
  curFactura.setUnLock("editable", false);
  return true;
}

//// ANTICIPOS A PROVEEDORES /////////////////////////////////////
//////////////////////////////////////////////////////////////////
