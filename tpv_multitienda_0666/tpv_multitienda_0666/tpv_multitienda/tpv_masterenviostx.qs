/***************************************************************************
                 tpv_masterenviostx.qs  -  description
                             -------------------
    begin                : vie sep 14 2012
    copyright            : (C) 2012 by InfoSiAL S.L.
    email                : mail@infosial.com
 ***************************************************************************/
/***************************************************************************
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
 ***************************************************************************/

/** @file */

/** @class_declaration interna */
////////////////////////////////////////////////////////////////////////////
//// DECLARACION ///////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
//// INTERNA /////////////////////////////////////////////////////
class interna
{
  var ctx: Object;
  function interna(context)
  {
    this.ctx = context;
  }
  function init()
  {
    return this.ctx.interna_init();
  }
  function preloadMainFilter()
  {
    return this.ctx.interna_preloadMainFilter();
  }
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna
{
  var codAlmaTienda_, curLinea_;
  function oficial(context)
  {
    interna(context);
  }
  function ordenColumnas()
  {
    return this.ctx.oficial_ordenColumnas();
  }
  function ponAnchoColumnas()
  {
    return this.ctx.oficial_ponAnchoColumnas();
  }
  function anchoColumnas()
  {
    return this.ctx.oficial_anchoColumnas();
  }
  function tbnOK_clicked()
  {
    return this.ctx.oficial_tbnOK_clicked();
  }
  function tbnOKParcial_clicked()
  {
    return this.ctx.oficial_tbnOKParcial_clicked();
  }
  function tbnOKUno_clicked()
  {
    return this.ctx.oficial_tbnOKUno_clicked();
  }
  function establecerFiltros()
  {
    return this.ctx.oficial_establecerFiltros();
  }
  function buscarViaje()
  {
    return this.ctx.oficial_buscarViaje();
  }
  function tbnBuscarDestino_clicked()
  {
    return this.ctx.oficial_tbnBuscarDestino_clicked();
  }
  function tbnOKViaje_clicked()
  {
    return this.ctx.oficial_tbnOKViaje_clicked();
  }
  function enviarLineaTotal(idLinea, codAgente)
  {
    return this.ctx.oficial_enviarLineaTotal(idLinea, codAgente);
  }
  function colorEstado(fN, fV, cursor, fT, sel)
  {
    return this.ctx.oficial_colorEstado(fN, fV, cursor, fT, sel);
  }
  function tbnCerrarEnvios_clicked()
  {
    return this.ctx.oficial_tbnCerrarEnvios_clicked();
  }
  function dedDesde_valueChanged(d)
  {
    return this.ctx.oficial_dedDesde_valueChanged(d);
  }
  function tbnBorrar_clicked()
  {
    return this.ctx.oficial_tbnBorrar_clicked();
  }
  function iniciarFechas()
  {
    return this.ctx.oficial_iniciarFechas();
  }
  function dameFiltro(precarga)
  {
    return this.ctx.oficial_dameFiltro(precarga);
  }
}
//// OFICIAL /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////
class head extends oficial
{
  function head(context)
  {
    oficial(context);
  }
}
//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration ifaceCtx */
/////////////////////////////////////////////////////////////////
//// INTERFACE  /////////////////////////////////////////////////
class ifaceCtx extends head
{
  function ifaceCtx(context)
  {
    head(context);
  }
  function pub_colorEstado(fN, fV, cursor, fT, sel)
  {
    return this.colorEstado(fN, fV, cursor, fT, sel);
  }
}

const iface = new ifaceCtx(this);
//// INTERFACE  /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition interna */
////////////////////////////////////////////////////////////////////////////
//// DEFINICION ////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
//// INTERNA /////////////////////////////////////////////////////
function interna_preloadMainFilter()
{
  var _i = this.iface;
  var f = _i.dameFiltro(true);
  return f;
}

function interna_init()
{
  var _i = this.iface;
  var cursor = this.cursor();

  this.child("tableDBRecords").setOrderCols(_i.ordenColumnas());
  _i.ponAnchoColumnas();

  _i.iniciarFechas();

  connect(this.child("tbnOK"), "clicked()", _i, "tbnOK_clicked");
  connect(this.child("tbnBorrar"), "clicked()", _i, "tbnBorrar_clicked");
  connect(this.child("tbnBuscarEnvios"), "clicked()", _i, "establecerFiltros");
  connect(this.child("chkPtes"), "clicked()", _i, "establecerFiltros");
  connect(this.child("tbnBuscarDestino"), "clicked()", _i, "tbnBuscarDestino_clicked");
  connect(this.child("tbnOKParcial"), "clicked()", _i, "tbnOKParcial_clicked");
  connect(this.child("tbnOkUno"), "clicked()", _i, "tbnOKUno_clicked");
  connect(this.child("tbnBuscarViaje"), "clicked()", _i, "buscarViaje");
  connect(this.child("tbnOKViaje"), "clicked()", _i, "tbnOKViaje_clicked");
  connect(this.child("tbnCerrarEnvios"), "clicked()", _i, "tbnCerrarEnvios_clicked");

  if (flfact_tpv.iface.pub_esUnaTienda()) {
    this.child("tbnOKViaje").close();
  }

  if (flfactppal.iface.pub_extension("tallcol_barcode")) {
    this.child("tlbReferencia").text = "Barcode:";
  }
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_ordenColumnas()
{
  if (flfactppal.iface.pub_extension("tallcol_barcode")) {
    return ["idviajemultitrans", "codalmadestino", "referencia", "barcode", "descripcion", "talla", "color", "cantpteenvio", "cantenviada", "estado", "fechaex", "horaex", "excentral", "extienda", "codagentetx", "comentariostx"];
  } else {
    return ["idviajemultitrans", "codalmadestino", "referencia", "descripcion", "cantpteenvio", "cantenviada", "estado", "fechaex", "horaex", "excentral", "extienda", "codagentetx", "comentariostx"];
  }
}

function oficial_ponAnchoColumnas()
{
  var _i = this.iface;
  var t = this.child("tableDBRecords");
  var aC = _i.anchoColumnas()
  for (var i = 0; i < aC.length; i++) {
    t.setColumnWidth(aC[i][0], aC[i][1]);
  }
}

function oficial_anchoColumnas()
{
  if (flfactppal.iface.pub_extension("tallcol_barcode")) {
    return [["idviajemultitrans", 100], ["codalmaorigen", 80], ["referencia", 100], ["barcode", 120], ["descripcion", 350], ["talla", 30], ["color", 30], ["cantpteenvio", 50], ["cantenviada", 50], ["estado", 100], ["fechaex", 80], ["horaex", 80], ["excentral", 50], ["extienda" , 50], ["codagentetx", 100], ["comentariostx", 200]];
  } else {
    return [["idviajemultitrans", 100], ["codalmaorigen", 80], ["referencia", 100], ["descripcion", 350], ["cantpteenvio", 50], ["cantenviada", 50], ["estado", 100], ["fechaex", 80], ["horaex", 80], ["excentral", 50], ["extienda" , 50], ["codagentetx", 100], ["comentariostx", 200]];
  }
}


function oficial_tbnOK_clicked()
{
  var _i = this.iface;
  var cursor = this.cursor();
  if (!cursor.isValid()) {
    return false;
  }

  var codAgente =  formRecordtpv_enviostx.iface.pub_commonCalculateField("codagentetx", cursor);
  //No se compara con "" porque si no se encuentra siempre devolverá falso. En el ganso es necesario qeu devuelva "" y siga funcionando.
  if (!codAgente && codAgente != "") {
    return false;
  }

  var idLinea = cursor.valueBuffer("idlinea");
  if (!idLinea) {
    return false;
  }
  if (!_i.enviarLineaTotal(idLinea, codAgente)) {
    return false;
  }
  this.child("tableDBRecords").refresh();
  return true;
}

function oficial_tbnOKParcial_clicked()
{
  var _i = this.iface;
  var cursor = this.cursor();
  if (!cursor.isValid()) {
    return false;
  }

  var codAgente =  formRecordtpv_enviostx.iface.pub_commonCalculateField("codagentetx", cursor);
  //No se compara con "" porque si no se encuentra siempre devolverá falso. En el ganso es necesario qeu devuelva "" y siga funcionando.
  if (!codAgente && codAgente != "") {
    return false;
  }
  if (!_i.curLinea_) {
    _i.curLinea_ = new FLSqlCursor("tpv_lineasmultitransstock");
    _i.curLinea_.setAction("tpv_enviostx");
  }
  _i.curLinea_.select("idlinea = " + cursor.valueBuffer("idlinea"));
  if (!_i.curLinea_.first()) {
    return false;
  }
  connect(_i.curLinea_, "commited()", this.child("tableDBRecords"), "refresh()");
  _i.curLinea_.editRecord();

  return true;
}

function oficial_tbnOKUno_clicked()
{
  var idViaje = this.child("lneViaje").text;

  if (!idViaje || idViaje == "") {
    MessageBox.warning(sys.translate("Debe establecer el viaje para continuar"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton, "AbanQ");
    return false;
  }

  var cursor = this.cursor();
  if (!cursor.isValid()) {
    return false;
  }

  var codAgente =  formRecordtpv_enviostx.iface.pub_commonCalculateField("codagentetx", cursor);
  //No se compara con "" porque si no se encuentra siempre devolverá falso. En el ganso es necesario qeu devuelva "" y siga funcionando.
  if (!codAgente && codAgente != "") {
    return false;
  }

  var referencia = this.child("lneReferencia").text;
  debug("referencia " + referencia);
  if (flfactppal.iface.pub_extension("tallcol_barcode")) {
    if (!referencia || !AQUtil.sqlSelect("atributosarticulos", "barcode", "barcode = '" + referencia + "'")) {
      MessageBox.warning(sys.translate("No existe el artículo con barcode %1").arg(referencia), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton, "AbanQ");
      return false;
    }
  } else {
    if (!referencia || !AQUtil.sqlSelect("articulos", "referencia", "referencia = '" + referencia + "'")) {
      MessageBox.warning(sys.translate("No existe el artículo con referencia %1").arg(referencia), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton, "AbanQ");
      return false;
    }
  }

  var where = this.child("tableDBRecords").cursor().mainFilter();
  if (!where || where == "")
    where = "1=1";
  if (flfactppal.iface.pub_extension("tallcol_barcode")) {
    where += " and barcode = '" + referencia + "'";
  } else {
    where += " and referencia = '" + referencia + "'";
  }

  var whereOk = "";
  if (flfact_tpv.iface.pub_esUnaTienda()) {
    whereOk += " AND (extienda = 'PTE' OR excentral = 'PTE')";
  } else {
    whereOk += " AND excentral = 'PTE'";
  }
  where += whereOk;
  if (AQUtil.sqlSelect("tpv_lineasmultitransstock", "count(idlinea)", where) > 1) {
    MessageBox.warning(sys.translate("Se han encontrado varios registros que coinciden con la búsqueda.\nSeleccione el envío manualmente."), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
  }

  var curE = new FLSqlCursor("tpv_lineasmultitransstock");
  if (flfactppal.iface.pub_extension("tallcol_barcode")) {
    curE.select("cantpteenvio > 0 and barcode = '" + referencia + "' AND idviajemultitrans = '" + idViaje + "'");
  } else {
    curE.select("cantpteenvio > 0 and referencia = '" + referencia + "' AND idviajemultitrans = '" + idViaje + "'");
  }
  if (!curE.first()) {
    MessageBox.warning(sys.translate("No hay registros pendientes de envío para el artículo %1").arg(referencia), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton, "AbanQ");
    return false;
  }

  curE.setModeAccess(curE.Edit);
  curE.refreshBuffer();
  var cant = curE.valueBuffer("cantenviada") + 1;
  //  if (cant > cursor.valueBuffer("cantidad")) {
  //      MessageBox.warning(sys.translate("La línea ya ha sido enviada"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton, "AbanQ");
  //    return false;
  //  }

  curE.setValueBuffer("cantenviada", cant);
  curE.setValueBuffer("cantpterecibir", formRecordtpv_enviostx.iface.pub_commonCalculateField("cantpterecibir", curE));
  curE.setValueBuffer("excentral", formRecordtpv_enviostx.iface.pub_commonCalculateField("excentral", curE));
  curE.setValueBuffer("extienda", formRecordtpv_enviostx.iface.pub_commonCalculateField("extienda", curE));
  curE.setValueBuffer("estado", formRecordtpv_enviostx.iface.pub_commonCalculateField("estado", curE));
  curE.setValueBuffer("codagentetx", codAgente);
  if (!curE.commitBuffer()) {
    return false;
  }

  this.child("tableDBRecords").refresh();
  this.child("lneReferencia").text = "";
  return true;
}

function oficial_establecerFiltros()
{
  var _i = this.iface;
  this.child("tableDBRecords").cursor().setMainFilter(_i.dameFiltro());
  this.child("tableDBRecords").refresh();
}

function oficial_dameFiltro(precarga)
{
  var _i = this.iface;
  var filtro = "1 = 1";
  if (!_i.codAlmaTienda_ || _i.codAlmaTienda_ != "NO") {
    _i.codAlmaTienda_ = flfact_tpv.iface.pub_almacenActual();
    if (!_i.codAlmaTienda_) {
      _i.codAlmaTienda_ = "NO";
    }
  }
  if (_i.codAlmaTienda_ != "NO") {
    filtro = "tpv_lineasmultitransstock.codalmaorigen = '" + _i.codAlmaTienda_ + "'";
  }

  var idViaje = this.child("lneViaje") ? this.child("lneViaje").text : "";
  var hoy = new Date;
  hoy = hoy.toString().left(10);
  var codAlmaDestino = this.child("lneDestino") ? this.child("lneDestino").text : "";
  var fechaDesde = precarga ? hoy : this.child("dedDesde").date;
  var fechaHasta = precarga ? hoy : this.child("dedHasta").date;

  if (idViaje && idViaje != "") {
    if (AQUtil.sqlSelect("tpv_viajesmultitransstock", "idviajemultitrans", "idviajemultitrans = '" + idViaje + "'")) {
      filtro += " AND idviajemultitrans = '" + idViaje + "'";
    }
  }
  if (codAlmaDestino && codAlmaDestino != "") {
    filtro += " AND tpv_lineasmultitransstock.codalmadestino = '" + codAlmaDestino + "'";
  }
  if (this.child("chkPtes").checked) {
    filtro += " AND tpv_lineasmultitransstock.estado IN ('PTE ENVIO', 'ENVIADO PARCIAL')";
  }

  if (fechaDesde || fechaHasta) {
    if (fechaDesde) {
      filtro += filtro != "" ? " AND " : ""
                filtro += "tpv_viajesmultitransstock.fecha >= '" + fechaDesde + "'";
    }
    if (fechaHasta) {
      filtro += filtro != "" ? " AND " : ""
                filtro += "tpv_viajesmultitransstock.fecha <= '" + fechaHasta + "'";
    }
  }
  return filtro;
}

function oficial_buscarViaje()
{
  var _i = this.iface;
  var f = new FLFormSearchDB("tpv_viajesmultitransstock");

  var filtro = "1=1";
  if (flfact_tpv.iface.pub_esUnaTienda()) {
    var codAlmaTienda = flfact_tpv.iface.pub_almacenActual();
    codAlmaTienda = codAlmaTienda ? codAlmaTienda : "ALL";
    if (codAlmaTienda && codAlmaTienda != "") {
      try {
        formSearchtpv_viajesmultitransstock.iface.pub_ponAlmaOrigen(codAlmaTienda);
      } catch (e) {
        formtpv_viajesmultitransstock.iface.pub_ponAlmaOrigen(codAlmaTienda);
      }
      try {
        formSearchtpv_viajesmultitransstock.iface.pub_ponAlmaDestino(false);
      } catch (e) {
        formtpv_viajesmultitransstock.iface.pub_ponAlmaDestino(false);
      }
    }
  }

  f.setMainWidget();
  //  f.child("tableDBRecords").setFilter(filtro);
  var idViaje = f.exec("idviajemultitrans");
  if (idViaje) {
    this.child("dedDesde").date = "";
    this.child("dedHasta").date = "";
    this.child("lneDestino").text = "";
    this.child("lneViaje").text = idViaje;
    _i.establecerFiltros();
  }
}

function oficial_tbnBuscarDestino_clicked()
{
  var _i = this.iface;
  var f = new FLFormSearchDB("almacenes");

  var filtro = "1=1";
  if (flfact_tpv.iface.pub_esUnaTienda()) {
    var codAlmaTienda = flfact_tpv.iface.pub_almacenActual();
    if (codAlmaTienda && codAlmaTienda != "")
      filtro = "codalmacen <> '" + codAlmaTienda + "'";
  }

  f.setMainWidget();
  f.cursor().setMainFilter(filtro);
  var codAlmacen = f.exec("codalmacen");
  if (codAlmacen) {
    this.child("lneDestino").text = codAlmacen;
    _i.establecerFiltros();
  }
}

function oficial_tbnOKViaje_clicked()
{
  var _i = this.iface;

  var idViaje = this.child("lneViaje").text;
  if (!idViaje || idViaje == "") {
    MessageBox.warning(sys.translate("Debe establecer el viaje para continuar"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton, "AbanQ");
    return false;
  }

  var qryL = new FLSqlQuery();
  qryL.setSelect("idlinea");
  qryL.setFrom("tpv_lineasmultitransstock");
  qryL.setWhere("idviajemultitrans = '" + idViaje + "' AND cantpteenvio > cantenviada");
  debug(qryL.sql());
  if (!qryL.exec())
    return false;

  var codAgente =  formRecordtpv_enviostx.iface.pub_commonCalculateField("codagentetx", cursor);
  //No se compara con "" porque si no se encuentra siempre devolverá falso. En el ganso es necesario qeu devuelva "" y siga funcionando.
  if (!codAgente && codAgente != "") {
    return false;
  }

  AQUtil.createProgressDialog(sys.translate("Procesando envíos..."), qryL.size());
  var i = 0;

  var cursor = new FLSqlCursor("tpv_lineasmultitransstock");
  while (qryL.next()) {
    AQUtil.setProgress(i++);
    cursor.select("idlinea = " + qryL.value("idlinea"));
    if (!cursor.first()) {
      sys.AQTimer.singleShot(0, AQUtil.destroyProgressDialog);
      return false;
    }

    cursor.setModeAccess(cursor.Edit);
    cursor.refreshBuffer();
    cursor.setValueBuffer("cantenviada", cursor.valueBuffer("cantpteenvio"));
    cursor.setValueBuffer("cantpterecibir", formRecordtpv_enviostx.iface.pub_commonCalculateField("cantpterecibir", cursor));
    cursor.setValueBuffer("excentral", formRecordtpv_enviostx.iface.pub_commonCalculateField("excentral", cursor));
    cursor.setValueBuffer("extienda", formRecordtpv_enviostx.iface.pub_commonCalculateField("extienda", cursor));
    cursor.setValueBuffer("estado", formRecordtpv_enviostx.iface.pub_commonCalculateField("estado", cursor));
    cursor.setValueBuffer("codagentetx", codAgente);
    if (!cursor.commitBuffer()) {
      sys.AQTimer.singleShot(0, AQUtil.destroyProgressDialog);
      return false;
    }
  }
  sys.AQTimer.singleShot(0, AQUtil.destroyProgressDialog);

  this.child("tableDBRecords").refresh();

  return true;
}

function oficial_enviarLineaTotal(idLinea, codAgente)
{
  var cursor = new FLSqlCursor("tpv_lineasmultitransstock");
  cursor.select("idlinea = " + idLinea);
  if (!cursor.first())
    return false;
  cursor.setModeAccess(cursor.Edit);
  cursor.refreshBuffer();
  cursor.setValueBuffer("cantenviada", cursor.valueBuffer("cantpteenvio"));
  cursor.setValueBuffer("cantpterecibir", formRecordtpv_enviostx.iface.pub_commonCalculateField("cantpterecibir", cursor));
  cursor.setValueBuffer("excentral", formRecordtpv_enviostx.iface.pub_commonCalculateField("excentral", cursor));
  cursor.setValueBuffer("extienda", formRecordtpv_enviostx.iface.pub_commonCalculateField("extienda", cursor));
  cursor.setValueBuffer("estado", formRecordtpv_enviostx.iface.pub_commonCalculateField("estado", cursor));
  cursor.setValueBuffer("codagentetx", codAgente);
  if (!cursor.commitBuffer()) {
    return false;
  }

  return true;
}

function oficial_colorEstado(fN, fV, cursor, fT, sel)
{
  //return; /// Porque se vuelve loco al editar la línea

  var _i = this.iface;
  if (fN != "estado") {
    return;
  }
  var color = "";
  switch (fV) {
    case "PTE ENVIO": {
      color = "#FFFFAA";
      break;
    }
    case "ENVIADO PARCIAL": {
      color = "#AAFFFF";
      break;
    }
    case "EN TRANSITO": {
      color = "#55FFFF";
      break;
    }
    case "RECIBIDO PARCIAL": {
      color = "#AAFF7F";
      break;
    }
    case "RECIBIDO": {
      color = "#55FF7F";
      break;
    }
  }
  if (color != "") {
    var a = [color, "#000000", "SolidPattern", "SolidPattern"];
    return a;
  }
}

function oficial_tbnCerrarEnvios_clicked()
{
  var _i = this.iface;

  var idViaje = this.child("lneViaje").text;
  if (!idViaje || idViaje == "") {
    MessageBox.warning(sys.translate("Debe establecer el viaje para continuar"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton, "AbanQ");
    return false;
  }

  var qryL = new FLSqlQuery();
  qryL.setSelect("idlinea");
  qryL.setFrom("tpv_lineasmultitransstock");
  qryL.setWhere("idviajemultitrans = '" + idViaje + "' AND cantpteenvio > cantenviada");
  debug(qryL.sql());
  if (!qryL.exec())
    return false;

  var codAgente =  formRecordtpv_enviostx.iface.pub_commonCalculateField("codagentetx", cursor);
  //No se compara con "" porque si no se encuentra siempre devolverá falso. En el ganso es necesario qeu devuelva "" y siga funcionando.
  if (!codAgente && codAgente != "") {
    return false;
  }

  AQUtil.createProgressDialog(sys.translate("Cerrando envíos..."), qryL.size());
  var i = 0;

  var cursor = new FLSqlCursor("tpv_lineasmultitransstock");
  while (qryL.next()) {
    AQUtil.setProgress(i++);
    cursor.select("idlinea = " + qryL.value("idlinea"));
    if (!cursor.first()) {
      sys.AQTimer.singleShot(0, AQUtil.destroyProgressDialog);
      return false;
    }

    cursor.setModeAccess(cursor.Edit);
    cursor.refreshBuffer();
    cursor.setValueBuffer("cerradoex", true);
    cursor.setValueBuffer("cantpterecibir", formRecordtpv_enviostx.iface.pub_commonCalculateField("cantpterecibir", cursor));
    cursor.setValueBuffer("excentral", formRecordtpv_enviostx.iface.pub_commonCalculateField("excentral", cursor));
    cursor.setValueBuffer("extienda", formRecordtpv_enviostx.iface.pub_commonCalculateField("extienda", cursor));
    cursor.setValueBuffer("rxcentral", formRecordtpv_recepcionestx.iface.pub_commonCalculateField("rxcentral", cursor));
    cursor.setValueBuffer("rxtienda", formRecordtpv_recepcionestx.iface.pub_commonCalculateField("rxtienda", cursor));
    cursor.setValueBuffer("estado", formRecordtpv_enviostx.iface.pub_commonCalculateField("estado", cursor));
    cursor.setValueBuffer("codagentetx", codAgente);

    if (!cursor.commitBuffer()) {
      sys.AQTimer.singleShot(0, AQUtil.destroyProgressDialog);
      return false;
    }
  }
  sys.AQTimer.singleShot(0, AQUtil.destroyProgressDialog);

  this.child("tableDBRecords").refresh();

  return true;
}

function oficial_dedDesde_valueChanged(d)
{
  this.child("dedHasta").date = d;
}

function oficial_tbnBorrar_clicked()
{
  var _i = this.iface;
  this.child("dedDesde").date = "";
  this.child("dedHasta").date = "";
  this.child("lneViaje").text = "";
  this.child("lneDestino").text = "";
  _i.establecerFiltros();

}

function oficial_iniciarFechas()
{
  var _i = this.iface;
  var d = new Date;
  this.child("dedDesde").date = d;
  this.child("dedHasta").date = d;
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////


/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
////////////////////////////////////////////////////////////////