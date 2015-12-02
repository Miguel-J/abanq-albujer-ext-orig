
/** @class_declaration anticiposProv */
/////////////////////////////////////////////////////////////////
//// ANTICIPOS PROV /////////////////////////////////////////////
class anticiposProv extends recibosProv
{
  var sIDD, sIDT, sFEC, sTIP, sDOC, sEST, sINI, sPEN, sVEN, sSAL;
  var cAnt, cRec;
  var curRA;
  var tblSaldo_;
  function anticiposProv(context)
  {
    recibosProv(context);
  }
  function init()
  {
    return this.ctx.anticiposProv_init();
  }
  function tbnRecargarSaldo_clicked()
  {
    return this.ctx.anticiposProv_tbnRecargarSaldo_clicked();
  }
  function construyeTablaSaldos()
  {
    return this.ctx.anticiposProv_construyeTablaSaldos();
  }
  function filtraAnticipos()
  {
    return this.ctx.anticiposProv_filtraAnticipos();
  }
  function tbwDocumentos_currentChanged(tab)
  {
    return this.ctx.anticiposProv_tbwDocumentos_currentChanged(tab);
  }
  function cargaTablaSaldo()
  {
    return this.ctx.anticiposProv_cargaTablaSaldo();
  }
  function ordenaDocsSaldo(d1, d2)
  {
    return this.ctx.anticiposProv_ordenaDocsSaldo(d1, d2);
  }
  function coloresSaldo()
  {
    return this.ctx.anticiposProv_coloresSaldo();
  }
  function cargaOtrosSaldos(aDatos)
  {
    return this.ctx.anticiposProv_cargaOtrosSaldos(aDatos);
  }
  function dameWhereRecibosSaldo()
  {
    return this.ctx.anticiposProv_dameWhereRecibosSaldo();
  }
  function tbnCancelaAnticipo_clicked()
  {
    return this.ctx.anticiposProv_tbnCancelaAnticipo_clicked();
  }
  function commonCalculateField(fN, cursor)
  {
    return this.ctx.anticiposProv_commonCalculateField(fN, cursor);
  }
  function tbnEditaAR_clicked()
  {
    return this.ctx.anticiposProv_tbnEditaAR_clicked();
  }
  function curRA_bufferCommited()
  {
    return this.ctx.anticiposProv_curRA_bufferCommited();
  }
  function dameFilasSeleccionSaldo()
  {
    return this.ctx.anticiposProv_dameFilasSeleccionSaldo();
  }
  function cancelaAnticipoSaldo(aFilas)
  {
    return this.ctx.anticiposProv_cancelaAnticipoSaldo(aFilas);
  }
  //  function compensaRecibos(curR1, curR2) {
  //    return this.ctx.anticiposProv_compensaRecibos(curR1, curR2);
  //  }
}
//// ANTICIPOS PROV /////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition anticiposProv */
/////////////////////////////////////////////////////////////////
//// ANTICIPOS PROV /////////////////////////////////////////////
function anticiposProv_init()
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

function anticiposProv_tbnRecargarSaldo_clicked()
{
  var _i = this.iface;
  _i.cargaTablaSaldo();
}

function anticiposProv_construyeTablaSaldos()
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


function anticiposProv_filtraAnticipos()
{
  var f = "";
  if (this.child("chkAnticiposPtes").checked) {
    f = "pendiente <> 0";
  }
  this.child("tdbAnticipos").setFilter(f);
  this.child("tdbAnticipos").refresh();
}

function anticiposProv_tbwDocumentos_currentChanged(tab)
{
  var _i = this.iface;
  if (tab != "saldo") {
    return;
  }
  _i.cargaTablaSaldo();
}

function anticiposProv_cargaTablaSaldo()
{
  var _i = this.iface;
  var cursor = this.cursor();
  var codProveedor = cursor.valueBuffer("codproveedor");

  var qRecibos = new FLSqlQuery;
  qRecibos.setSelect("idrecibo, fecha, fechav, estado, codigo, importeeuros");
  qRecibos.setFrom("recibosprov");
  qRecibos.setWhere("codproveedor = '" + codProveedor + "' AND " + _i.dameWhereRecibosSaldo());
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
  qAnticipos.setFrom("anticiposprov");
  qAnticipos.setWhere("codproveedor = '" + codProveedor + "' AND pendiente <> 0");
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
      saldo += parseFloat(aDatos[f]["importepte"]);
      color = _i.cAnt;
    } else {
      saldo -= parseFloat(aDatos[f]["importepte"]);
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
    //    t.setText(f, _i.sINI, AQUtil.formatoMiles(AQUtil.roundFieldValue(aDatos[f]["importeinicial"], "recibosprov", "importe")));
    //    t.setText(f, _i.sPEN, AQUtil.formatoMiles(AQUtil.roundFieldValue(aDatos[f]["importepte"], "recibosprov", "importe")));
    //    t.setText(f, _i.sSAL, AQUtil.formatoMiles(AQUtil.roundFieldValue(saldo, "recibosprov", "importe")));
    t.setText(f, _i.sINI, (AQUtil.roundFieldValue(aDatos[f]["importeinicial"], "recibosprov", "importe")));
    t.setText(f, _i.sPEN, (AQUtil.roundFieldValue(aDatos[f]["importepte"], "recibosprov", "importe")));
    t.setText(f, _i.sSAL, (AQUtil.roundFieldValue(saldo, "recibosprov", "importe")));
  }
}

function anticiposProv_cargaOtrosSaldos(aDatos)
{
  return true;
}

function anticiposProv_coloresSaldo()
{
  var _i = this.iface;

  _i.cAnt = new Color(200, 255, 185);
  _i.cRec = new Color(220, 220, 255);
  //  _i.cMax = new Color(200,100,150);
}


function anticiposProv_ordenaDocsSaldo(d1, d2)
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

function anticiposProv_dameWhereRecibosSaldo()
{
  return "estado IN ('Emitido', 'Devuelto')";
}

function anticiposProv_dameFilasSeleccionSaldo()
{
  var _i = this.iface;
  var t = _i.tblSaldo_;
  var filasSel = t.selectedRows();
  if (!filasSel || filasSel == "") {
    return false;
  }
  var aFilas = filasSel.toString().split(",");
  if (aFilas.length != 2) {
    MessageBox.warning(sys.translate("Debe escoger dos registros para realizar la cancelación"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  return aFilas;
}

function anticiposProv_tbnCancelaAnticipo_clicked()
{
  var _i = this.iface;
  var t = _i.tblSaldo_;

  var aFilas = _i.dameFilasSeleccionSaldo();
  if (!aFilas) {
    return false;
  }

  if (!_i.cancelaAnticipoSaldo(aFilas)) {
    return false;
  }
  return true;
}

function anticiposProv_cancelaAnticipoSaldo(aFilas)
{
  var _i = this.iface;
  var t = _i.tblSaldo_;

  /*if (t.text(aFilas[0], _i.sIDT) == "RECIBO" && t.text(aFilas[1], _i.sIDT) == "RECIBO") { /// Recibos a compensar
    var curR1 = new FLSqlCursor("recibosprov");
    var curR2 = new FLSqlCursor("recibosprov");
    curR1.select("idrecibo = " + t.text(aFilas[0], _i.sIDD));
    curR2.select("idrecibo = " + t.text(aFilas[1], _i.sIDD));
    if (!curR1.first()) {
      MessageBox.warning(sys.translate("Error al localizar el recibo %1").arg(t.text(aFilas[0], _i.sIDD)), MessageBox.Ok, MessageBox.NoButton);
      return false;
    }
    if (!curR2.first()) {
      MessageBox.warning(sys.translate("Error al localizar el recibo %1").arg(t.text(aFilas[1], _i.sIDD)), MessageBox.Ok, MessageBox.NoButton);
      return false;
    }

    var curT = new FLSqlCursor("empresa");
    curT.transaction(false);
    try {
      if (_i.compensaRecibos(curR1, curR2)) {
        curT.commit();
      } else {
        curT.rollback();
        MessageBox.critical(sys.translate("Error al compensar los recibos"), MessageBox.Ok, MessageBox.NoButton);
        return false;
      }
    } catch (e) {
      curT.rollback();
      MessageBox.critical(sys.translate("Error al compensar los recibos: ") + e, MessageBox.Ok, MessageBox.NoButton);
      return false;
    }
  } else {*/ /// Aplicar anticipo
  if (t.text(aFilas[0], _i.sIDT) == t.text(aFilas[1], _i.sIDT)) {
    MessageBox.warning(sys.translate("Debe escoger un recibo y un pago para realizar la cancelación"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  var curR = new FLSqlCursor("recibosprov");
  var curA = new FLSqlCursor("anticiposprov");
  if (t.text(aFilas[0], _i.sIDT) == "RECIBO") {
    curR.select("idrecibo = " + t.text(aFilas[0], _i.sIDD));
    curA.select("idanticipo = " + t.text(aFilas[1], _i.sIDD));
  } else {
    curA.select("idanticipo = " + t.text(aFilas[0], _i.sIDD));
    curR.select("idrecibo = " + t.text(aFilas[1], _i.sIDD));
  }
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
    if (flfactteso.iface.pub_aplicarAnticipoProv(curR, curA, true)) {
      curT.commit();
    } else {
      curT.rollback();
      MessageBox.critical(AQUtil.translate("scripts", "Error al vincular el anticipo"), MessageBox.Ok, MessageBox.NoButton);
      return false;
    }
  } catch (e) {
    curT.rollback();
    MessageBox.critical(AQUtil.translate("scripts", "Error al vincular el anticipo: ") + e, MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  //  }
  _i.cargaTablaSaldo();
}

// function anticiposProv_compensaRecibos(curR1, curR2)
// {
//  if (curR1.valueBuffer("importe") != (curR2.valueBuffer("importe") * -1)) {
//    MessageBox.warning(sys.translate("El importe de los recibos no coincide"), MessageBox.Ok, MessageBox.NoButton);
//    return false;
//  }
//  curR1.setModeAccess(curR1.Edit);
//  curR1.refreshBuffer();
//  curR2.setModeAccess(curR2.Edit);
//  curR2.refreshBuffer();
//  curR1.setValueBuffer("estado", "Compensado");
//  curR1.setValueBuffer("idrecibocomp", curR2.valueBuffer("idrecibo"));
//  curR2.setValueBuffer("estado", "Compensado");
//  curR2.setValueBuffer("idrecibocomp", curR1.valueBuffer("idrecibo"));
//  if (!curR1.commitBuffer()) {
//    return false;
//  }
//  if (!curR2.commitBuffer()) {
//    return false;
//  }
//  return true;
// }

function anticiposProv_commonCalculateField(fN, cursor)
{
  var _i = this.iface;
  var valor;
  switch (fN) {
    case "saldoanticipos": {
      var saldoR = parseFloat(AQUtil.sqlSelect("recibosprov", "SUM(importeeuros)", "codproveedor = '" + cursor.valueBuffer("codproveedor") + "' AND " + _i.dameWhereRecibosSaldo()));
      saldoR = isNaN(saldoR) ? 0 : saldoR;
      var saldoA = parseFloat(AQUtil.sqlSelect("anticiposprov", "SUM(pendienteeuros)", "codproveedor = '" + cursor.valueBuffer("codproveedor") + "'"));
      saldoA = isNaN(saldoA) ? 0 : saldoA;
      valor = saldoA - saldoR;
      break;
    }
    default: {
      valor = _i.__commonCalculateField(fN, cursor);
    }
  }
  return valor;
}

function anticiposProv_tbnEditaAR_clicked()
{
  var _i = this.iface;
  var t = _i.tblSaldo_;
  var f = t.currentRow();
  if (_i.curRA) {
    delete _i.curRA;
  }
  if (t.text(f, _i.sIDT) == "RECIBO") {
    _i.curRA = new FLSqlCursor("recibosprov");
    _i.curRA.select("idrecibo = " + t.text(f, _i.sIDD));
  } else {
    _i.curRA = new FLSqlCursor("anticiposprov");
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

function anticiposProv_curRA_bufferCommited()
{
  var _i = this.iface;
  _i.cargaTablaSaldo();
  sys.setObjText(this, "fdbSaldoAnticipos", _i.calculateField("saldoanticipos"));
}
//// ANTICIPOS PROV /////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
