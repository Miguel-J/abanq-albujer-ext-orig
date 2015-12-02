
/** @class_declaration anticipos */
/////////////////////////////////////////////////////////////////
//// ANTICIPOS //////////////////////////////////////////////////
class anticipos extends oficial
{
  var sIDD, sIDT, sFEC, sTIP, sDOC, sEST, sINI, sPEN, sVEN, sSAL;
  var cAnt, cRec;
  var curRA;
  var tblSaldo_;
  function anticipos(context)
  {
    oficial(context);
  }
  function init()
  {
    return this.ctx.anticipos_init();
  }
  function tbnRecargarSaldo_clicked()
  {
    return this.ctx.anticipos_tbnRecargarSaldo_clicked();
  }
  function filtraAnticipos()
  {
    return this.ctx.anticipos_filtraAnticipos();
  }
  function construyeTablaSaldos()
  {
    return this.ctx.anticipos_construyeTablaSaldos();
  }
  function tbwDocumentos_currentChanged(tab)
  {
    return this.ctx.anticipos_tbwDocumentos_currentChanged(tab);
  }
  function cargaTablaSaldo()
  {
    return this.ctx.anticipos_cargaTablaSaldo();
  }
  function ordenaDocsSaldo(d1, d2)
  {
    return this.ctx.anticipos_ordenaDocsSaldo(d1, d2);
  }
  function coloresSaldo()
  {
    return this.ctx.anticipos_coloresSaldo();
  }
  function cargaOtrosSaldos(aDatos)
  {
    return this.ctx.anticipos_cargaOtrosSaldos(aDatos);
  }
  function dameWhereRecibosSaldo()
  {
    return this.ctx.anticipos_dameWhereRecibosSaldo();
  }
  function tbnCancelaAnticipo_clicked()
  {
    return this.ctx.anticipos_tbnCancelaAnticipo_clicked();
  }
  function commonCalculateField(fN, cursor)
  {
    return this.ctx.anticipos_commonCalculateField(fN, cursor);
  }
  function tbnEditaAR_clicked()
  {
    return this.ctx.anticipos_tbnEditaAR_clicked();
  }
  function curRA_bufferCommited()
  {
    return this.ctx.anticipos_curRA_bufferCommited();
  }
  function dameFilasSeleccionSaldo()
  {
    return this.ctx.anticipos_dameFilasSeleccionSaldo();
  }
  function cancelaAnticipoSaldo(aFilas, aTipos)
  {
    return this.ctx.anticipos_cancelaAnticipoSaldo(aFilas, aTipos);
  }
  function dameTiposFila(aFilas)
  {
    return this.ctx.anticipos_dameTiposFila(aFilas);
  }
  function agrupaRecibos(aFilas, aTipos)
  {
    return this.ctx.anticipos_agrupaRecibos(aFilas, aTipos);
  }
  function cancelaRecibosAnticipo(aFilas, aTipos)
  {
    return this.ctx.anticipos_cancelaRecibosAnticipo(aFilas, aTipos);
  }
}
//// ANTICIPOS //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition anticipos */
/////////////////////////////////////////////////////////////////
//// ANTICIPOS //////////////////////////////////////////////////
function anticipos_init()
{
  var _i = this.iface;
  _i.__init();
  connect(this.child("chkAnticiposPtes"), "clicked()", _i, "filtraAnticipos");
  connect(this.child("tbwDocumentos"), "currentChanged(QString)", _i, "tbwDocumentos_currentChanged");
  connect(this.child("tbnCancelaAnticipo"), "clicked()", _i, "tbnCancelaAnticipo_clicked");
  connect(this.child("tbnRecargarSaldo"), "clicked()", _i, "tbnRecargarSaldo_clicked");
  connect(this.child("tbnEditaAR"), "clicked()", _i, "tbnEditaAR_clicked");
  connect(this.child("tblSaldo"), "doubleClicked(int, int)", _i, "tbnEditaAR_clicked");


  _i.coloresSaldo();
  _i.tblSaldo_ = this.child("tblSaldo");
  _i.filtraAnticipos();
  _i.construyeTablaSaldos();
}

function anticipos_tbnRecargarSaldo_clicked()
{
  var _i = this.iface;
  _i.cargaTablaSaldo();
}

function anticipos_construyeTablaSaldos()
{
  var _i = this.iface;
  var c = 0, cH = [];

  _i.sIDD = c++;
  _i.sIDT = c++;
  _i.sFEC = c++;
  _i.sTIP = c++;
  _i.sDOC = c++;
  _i.sEST = c++;
  _i.sVEN = c++;
  _i.sINI = c++;
  _i.sPEN = c++;
  _i.sSAL = c++;

  cH[_i.sIDD] = sys.translate("Id Doc");
  cH[_i.sIDT] = sys.translate("Id Tipo");
  cH[_i.sFEC] = sys.translate("F.Registro");
  cH[_i.sTIP] = sys.translate("Tipo");
  cH[_i.sDOC] = sys.translate("N.Doc.");
  cH[_i.sEST] = sys.translate("Estado");
  cH[_i.sINI] = sys.translate("Imp.Inicial");
  cH[_i.sPEN] = sys.translate("Imp.Pte.");
  cH[_i.sVEN] = sys.translate("Vencimiento");
  cH[_i.sSAL] = sys.translate("Saldo");

  var t = this.child("tblSaldo");
  t.setNumCols(c);
  t.hideColumn(_i.sIDD);
  t.hideColumn(_i.sIDT);
  t.setColumnWidth(_i.sFEC, 80);
  t.setColumnWidth(_i.sTIP, 100);
  t.setColumnWidth(_i.sDOC, 120);
  t.setColumnWidth(_i.sEST, 120);
  t.setColumnWidth(_i.sINI, 100);
  t.setColumnWidth(_i.sPEN, 100);
  t.setColumnWidth(_i.sVEN, 80);
  t.setColumnWidth(_i.sSAL, 100);

  t.setColumnLabels("*", cH.join("*"));
}

function anticipos_filtraAnticipos()
{
  var f = "";
  if (this.child("chkAnticiposPtes").checked) {
    f = "pendiente <> 0";
  }
  this.child("tdbAnticipos").setFilter(f);
  this.child("tdbAnticipos").refresh();
}

function anticipos_tbwDocumentos_currentChanged(tab)
{
  var _i = this.iface;
  if (tab != "saldo") {
    return;
  }
  _i.cargaTablaSaldo();
}

function anticipos_cargaTablaSaldo()
{
  var _i = this.iface;
  var cursor = this.cursor();
  var codCliente = cursor.valueBuffer("codcliente");

  var qRecibos = new FLSqlQuery;
  qRecibos.setSelect("idrecibo, fecha, fechav, estado, codigo, importeeuros");
  qRecibos.setFrom("reciboscli");
  qRecibos.setWhere("codcliente = '" + codCliente + "' AND " + _i.dameWhereRecibosSaldo());
  qRecibos.setForwardOnly(true)
  if (!qRecibos.exec()) {
    return false;
  }
  var aDatos = [];
  var i = 0;
  while (qRecibos.next()) {
    aDatos[i] = new Object;
    aDatos[i]["id"] = qRecibos.value("idrecibo");
    aDatos[i]["tipo"] = "RECIBO";
    aDatos[i]["destipo"] = sys.translate("Recibo");
    aDatos[i]["fecha"] = qRecibos.value("fecha");
    aDatos[i]["vencimiento"] = qRecibos.value("fechav");
    aDatos[i]["estado"] = qRecibos.value("estado");
    aDatos[i]["codigo"] = qRecibos.value("codigo");
    aDatos[i]["importeinicial"] = qRecibos.value("importeeuros");
    aDatos[i]["importepte"] = qRecibos.value("importeeuros");
    i++;
  }

  var qAnticipos = new FLSqlQuery;
  qAnticipos.setSelect("idanticipo, codigo, fecha, importeeuros, pendienteeuros");
  qAnticipos.setFrom("anticiposcli");
  qAnticipos.setWhere("codcliente = '" + codCliente + "' AND pendiente <> 0");
  qAnticipos.setForwardOnly(true)
  if (!qAnticipos.exec()) {
    return false;
  }
  while (qAnticipos.next()) {
    aDatos[i] = new Object;
    aDatos[i]["id"] = qAnticipos.value("idanticipo");
    aDatos[i]["tipo"] = "ANTICIPO";
    aDatos[i]["destipo"] = sys.translate("Pago");
    aDatos[i]["fecha"] = qAnticipos.value("fecha");
    aDatos[i]["vencimiento"] = "";
    aDatos[i]["estado"] = sys.translate("Pendiente");
    aDatos[i]["codigo"] = qAnticipos.value("codigo");
    aDatos[i]["importeinicial"] = qAnticipos.value("importeeuros");
    aDatos[i]["importepte"] = qAnticipos.value("pendienteeuros");
    aDatos[i]["importeinicial"] = isNaN(aDatos[i]["importeinicial"]) ? 0 : aDatos[i]["importeinicial"];
    aDatos[i]["importepte"] = isNaN(aDatos[i]["importepte"]) ? 0 : aDatos[i]["importepte"];
    i++;
  }
  if (!_i.cargaOtrosSaldos(aDatos)) {
    return false;
  }
  var numFilas = aDatos.length;

  aDatos.sort(_i.ordenaDocsSaldo);

  var t = this.child("tblSaldo");
  var nC = t.numCols();
  t.setNumRows(0);
  var saldo = 0, color;
  for (var f = 0; f < numFilas; f++) {
    t.insertRows(f);
    if (aDatos[f]["tipo"] == "ANTICIPO") {
      saldo -= parseFloat(aDatos[f]["importepte"]);
      color = _i.cAnt;
    } else {
      saldo += parseFloat(aDatos[f]["importepte"]);
      color = _i.cRec;
    }
    for (var c = 0; c < nC; c++) {
      t.setCellBackgroundColor(f, c, color);
    }
    t.setText(f, _i.sIDD, aDatos[f]["id"]);
    t.setText(f, _i.sIDT, aDatos[f]["tipo"]);
    t.setText(f, _i.sFEC, AQUtil.dateAMDtoDMA(aDatos[f]["fecha"]));
    t.setText(f, _i.sTIP, aDatos[f]["destipo"]);
    t.setText(f, _i.sVEN, AQUtil.dateAMDtoDMA(aDatos[f]["vencimiento"]));
    t.setText(f, _i.sEST, aDatos[f]["estado"]);
    t.setText(f, _i.sDOC, aDatos[f]["codigo"]);
    /// Hasta que se pueda centrar a la derecha correctamente
    //    t.setText(f, _i.sINI, AQUtil.formatoMiles(AQUtil.roundFieldValue(aDatos[f]["importeinicial"], "reciboscli", "importe")));
    //    t.setText(f, _i.sPEN, AQUtil.formatoMiles(AQUtil.roundFieldValue(aDatos[f]["importepte"], "reciboscli", "importe")));
    //    t.setText(f, _i.sSAL, AQUtil.formatoMiles(AQUtil.roundFieldValue(saldo, "reciboscli", "importe")));
    t.setText(f, _i.sINI, (AQUtil.roundFieldValue(aDatos[f]["importeinicial"], "reciboscli", "importe")));
    t.setText(f, _i.sPEN, (AQUtil.roundFieldValue(aDatos[f]["importepte"], "reciboscli", "importe")));
    t.setText(f, _i.sSAL, (AQUtil.roundFieldValue(saldo, "reciboscli", "importe")));
  }
}

function anticipos_cargaOtrosSaldos(aDatos)
{
  return true;
}

function anticipos_coloresSaldo()
{
  var _i = this.iface;

  _i.cAnt = new Color(200, 255, 185);
  _i.cRec = new Color(220, 220, 255);
  //  _i.cMax = new Color(200,100,150);
}


function anticipos_ordenaDocsSaldo(d1, d2)
{
  var dif = AQUtil.daysTo(d1["fecha"], d2["fecha"]);
  if (dif > 0) {
    return -1;
  } else if (dif < 0) {
    return 1;
  } else {
    if (d1["codigo"] > d2["codigo"]) {
      return 1;
    } else if (d1["codigo"] < d2["codigo"]) {
      return -1;
    } else {
      return 0;
    }
  }
}

function anticipos_dameWhereRecibosSaldo()
{
  return "estado IN ('Emitido', 'Devuelto')";
}

function anticipos_dameFilasSeleccionSaldo()
{
  var _i = this.iface;
  var t = _i.tblSaldo_;
  var filasSel = t.selectedRows();
  if (!filasSel || filasSel == "") {
    return false;
  }
  var aFilas = filasSel.toString().split(",");
  //  if (aFilas.length != 2) {
  //    MessageBox.warning(sys.translate("Debe escoger dos registros para realizar la cancelación"), MessageBox.Ok, MessageBox.NoButton);
  //    return false;
  //  }
  return aFilas;
}

function anticipos_tbnCancelaAnticipo_clicked()
{
  var _i = this.iface;
  var t = _i.tblSaldo_;

  var aFilas = _i.dameFilasSeleccionSaldo();
  if (!aFilas) {
    return false;
  }
  var aTipos = _i.dameTiposFila(aFilas);
  if (!aTipos) {
    return false;
  }

  if (!_i.cancelaAnticipoSaldo(aFilas, aTipos)) {
    return false;
  }
  return true;
}



function anticipos_dameTiposFila(aFilas)
{
  var _i = this.iface;
  var t = _i.tblSaldo_;
  var aT = new Object;
  aT["recibos"] = 0;
  aT["anticipos"] = 0;
  aT["listarec"] = [];
  aT["listaant"] = [];
  for (var i = 0; i < aFilas.length; i++) {
    switch (t.text(aFilas[i], _i.sIDT)) {
      case "RECIBO": {
        aT["recibos"]++;
        aT["listarec"].push(t.text(aFilas[i], _i.sIDD));
        break;
      }
      case "ANTICIPO": {
        aT["anticipos"]++;
        aT["listaant"].push(t.text(aFilas[i], _i.sIDD));
        break;
      }
    }
  }
  return aT;
}

function anticipos_cancelaAnticipoSaldo(aFilas, aTipos)
{
  var _i = this.iface;
  var t = _i.tblSaldo_;

  if (aTipos["recibos"] > 0 && aTipos["anticipos"] == 0) {
    if (!_i.agrupaRecibos(aFilas, aTipos)) {
      return false;
    }
  } else if (aTipos["recibos"] == 1 && aTipos["anticipos"] == 1) {
    if (!_i.cancelaRecibosAnticipo(aFilas, aTipos)) {
      return false;
    }
  } else {
    MessageBox.warning(sys.translate("La combinación de anticipos y recibos seleccionada no es válida"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton, "AbanQ");
    return false;
  }
  _i.cargaTablaSaldo();
  return true;
}

function anticipos_agrupaRecibos(aFilas, aTipos)
{
  var _i = this.iface;
  var oParam = new Object;
  oParam.errorMsg = sys.translate("Error al crear el grupo de recibos");

  var f;
  oParam.aRecibos = aTipos["listarec"];
  if (!oParam.aRecibos || oParam.aRecibos.length == 0) {
    return false;
  }
  f = new Function("oParam", "return flfactteso.iface.pub_creaGrupoRecibosMultiCli(oParam)");
  if (!sys.runTransaction(f, oParam)) {
    return false;
  }
  return true;
}

function anticipos_cancelaRecibosAnticipo(aFilas, aTipos)
{
  var _i = this.iface;
  var t = _i.tblSaldo_;

  var curR = new FLSqlCursor("reciboscli");
  var curA = new FLSqlCursor("anticiposcli");
  curR.select("idrecibo = " + aTipos["listarec"][0]);
  curA.select("idanticipo = " + aTipos["listaant"][0]);
  if (!curR.first()) {
    MessageBox.warning(sys.translate("Error al localizar el recibo"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  if (!curA.first()) {
    MessageBox.warning(sys.translate("Error al localizar el anticipo"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }

  var curT = new FLSqlCursor("empresa");
  curT.transaction(false);
  try {
    if (flfactteso.iface.pub_aplicarAnticipo(curR, curA, true)) {
      curT.commit();
    } else {
      curT.rollback();
      MessageBox.critical(sys.translate("Error al vincular el anticipo"), MessageBox.Ok, MessageBox.NoButton);
      return false;
    }
  } catch (e) {
    curT.rollback();
    MessageBox.critical(sys.translate("Error al vincular el anticipo: ") + e, MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  return true;
}

function anticipos_commonCalculateField(fN, cursor)
{
  var _i = this.iface;
  var valor;
  switch (fN) {
    case "saldoanticipos": {
      var saldoR = parseFloat(AQUtil.sqlSelect("reciboscli", "SUM(importeeuros)", "codcliente = '" + cursor.valueBuffer("codcliente") + "' AND " + _i.dameWhereRecibosSaldo()));
      saldoR = isNaN(saldoR) ? 0 : saldoR;
      var saldoA = parseFloat(AQUtil.sqlSelect("anticiposcli", "SUM(pendiente)", "codcliente = '" + cursor.valueBuffer("codcliente") + "'"));
      saldoA = isNaN(saldoA) ? 0 : saldoA;
      valor = saldoR - saldoA; /// Distinto signo del de proveedores para que coincida con el signo de la subcuenta contable del cliente
      break;
    }
    default: {
      valor = _i.__commonCalculateField(fN, cursor);
    }
  }
  return valor;
}

function anticipos_tbnEditaAR_clicked()
{
  var _i = this.iface;
  var t = _i.tblSaldo_;
  var f = t.currentRow();
  if (_i.curRA) {
    delete _i.curRA;
  }
  if (t.text(f, _i.sIDT) == "RECIBO") {
    _i.curRA = new FLSqlCursor("reciboscli");
    _i.curRA.select("idrecibo = " + t.text(f, _i.sIDD));
  } else {
    _i.curRA = new FLSqlCursor("anticiposcli");
    _i.curRA.select("idanticipo = " + t.text(f, _i.sIDD));
  }
  if (!_i.curRA.first()) {
    MessageBox.warning(sys.translate("Error al localizar el documento"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  disconnect(_i.curRA, "bufferCommited()", _i, "curRA_bufferCommited");
  connect(_i.curRA, "bufferCommited()", _i, "curRA_bufferCommited");
  _i.curRA.editRecord();
}

function anticipos_curRA_bufferCommited()
{
  var _i = this.iface;
  _i.cargaTablaSaldo();
  sys.setObjText(this, "fdbSaldoAnticipos", _i.calculateField("saldoanticipos"));
}
//// ANTICIPOS //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
