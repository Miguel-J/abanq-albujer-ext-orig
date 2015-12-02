/***************************************************************************
                 rx_pedidosprov.qs  -  description
                             -------------------
    begin                : jue dic 13 2012
    copyright            : (C) 2004-2012 by InfoSiAL S.L.
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
  var ctx;
  function interna(context)
  {
    this.ctx = context;
  }
  function init()
  {
    return this.ctx.interna_init();
  }
  function calculateField(fN)
  {
    return this.ctx.interna_calculateField(fN);
  }
  function main()
  {
    return this.ctx.interna_main();
  }
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna
{
  var fila_clicked_, columna_clicked_;
  var modo_;
  var blanco_, gris_, verde_, amarillo_, rojo_;
  var tdbLineasPedidos_;
  var cPED, cPROV, cFEC, cREF, cDES, cCPD, cCRA, cCPT, cCRC, cPVP, cLIN, cIMP, cIVA, cREC, cDTOL, cPDTO, cIRPF, cPVPSD, cIDPED;
  var busquedaAnterior_;
  var cabecera_;

  function oficial(context)
  {
    interna(context);
  }
  function bufferChanged(fN)
  {
    return this.ctx.oficial_bufferChanged(fN);
  }
  function construirTabla()
  {
    return this.ctx.oficial_construirTabla();
  }
  function pushButtonAccept_clicked()
  {
    return this.ctx.oficial_pushButtonAccept_clicked();
  }
  function crearFecha(cFecha)
  {
    return this.ctx.oficial_crearFecha(cFecha);
  }
  function creaFrom()
  {
    return this.ctx.oficial_creaFrom();
  }
  function creaSelect()
  {
    return this.ctx.oficial_creaSelect();
  }
  function creaWhere()
  {
    return this.ctx.oficial_creaWhere();
  }
  function guardar()
  {
    return this.ctx.oficial_guardar();
  }
  function creaCabeceraAlbaran(fila)
  {
    return this.ctx.oficial_creaCabeceraAlbaran(fila);
  }
  function creaLineaAlbaran(idAlbaran, fila)
  {
    return this.ctx.oficial_creaLineaAlbaran(idAlbaran, fila);
  }
  function totalizarAlbaran(idAlbaran)
  {
    return this.ctx.oficial_totalizarAlbaran(idAlbaran);
  }
  function pushButtonCancel_clicked()
  {
    return this.ctx.oficial_pushButtonCancel_clicked();
  }
  function tbnBuscar_clicked()
  {
    return this.ctx.oficial_tbnBuscar_clicked();
  }
  function establecerCantidadRecibida(fila, col)
  {
    return this.ctx.oficial_establecerCantidadRecibida(fila, col);
  }
  function cargarTabla(q)
  {
    return this.ctx.oficial_cargarTabla(q);
  }
  function cambiarModo(modo)
  {
    return this.ctx.oficial_cambiarModo(modo);
  }
  function tbnCancelar_clicked()
  {
    return this.ctx.oficial_tbnCancelar_clicked();
  }
  function colores()
  {
    return this.ctx.oficial_colores();
  }
  function refrescaFila(f)
  {
    return this.ctx.oficial_refrescaFila(f);
  }
  function pintarFila(fila, cantPendiente)
  {
    return this.ctx.oficial_pintarFila(fila, cantPendiente);
  }
  function pintarCeldas(fila, color)
  {
    return this.ctx.oficial_pintarCeldas(fila, color);
  }
  function incluirFila(fila, col)
  {
    return this.ctx.oficial_incluirFila(fila, col);
  }
  function dameSerieAlbaran(codSerie)
  {
    return this.ctx.oficial_dameSerieAlbaran(codSerie);
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
function interna_init()
{
  var _i = this.iface;
  _i.colores();

  var cursor = this.cursor();

  _i.tdbLineasPedidos_ = this.child("tdbLineasPedidos");

  connect(cursor, "bufferChanged(QString)", _i, "bufferChanged");
  connect(this.child("tbnBuscar"), "clicked()", _i, "tbnBuscar_clicked");
  connect(this.child("tbnCancelar"), "clicked()", _i, "tbnCancelar_clicked");

  disconnect(this.child("pushButtonAccept"), "clicked()", this.obj(), "accept()");
  disconnect(this.child("pushButtonCancel"), "clicked()", this.obj(), "reject()");

  connect(this.child("tbnGuardar"), "clicked()", _i, "pushButtonAccept_clicked");
  connect(_i.tdbLineasPedidos_, "valueChanged(int, int)", _i, "establecerCantidadRecibida");
  connect(_i.tdbLineasPedidos_, "doubleClicked(int, int)", _i, "incluirFila");
  connect(this.child("pushButtonAccept"), "clicked()", _i, "pushButtonAccept_clicked");
  connect(this.child("pushButtonCancel"), "clicked()", _i, "pushButtonCancel_clicked");

  this.child("pushButtonAccept").close();

  _i.modo_ = "Buscar";
  _i.construirTabla();
  _i.busquedaAnterior_ = false;

}

function interna_calculateField(fN)
{
  var _i = this.iface;
  var cursor = this.cursor();
  var valor;

  switch (fN) {
    case "x": {
      break;
    }
  }
  return valor;
}

function interna_main()
{
  var f = new FLFormSearchDB("rx_pedidosprov");
  var cursor = f.cursor();

  cursor.select();
  if (!cursor.first()) {
    cursor.setModeAccess(cursor.Insert);
  } else {
    cursor.setModeAccess(cursor.Edit);
  }
  f.setMainWidget();

  cursor.refreshBuffer();

  f.exec("");
  acpt = f.accepted();

}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_pushButtonAccept_clicked()
{
  var _i = this.iface;

  if (!_i.guardar()) {
    return;
  }
}

function oficial_construirTabla()
{
  var _i = this.iface;
  var t = _i.tdbLineasPedidos_;

  _i.cabecera_ = "";
  var c = 0;
  _i.cPED = c++;
  _i.cabecera_ += sys.translate("Cod. Pedido") + "/";
  _i.cPROV = c++;
  _i.cabecera_ += sys.translate("Proveedor") + "/";
  _i.cFEC = c++;
  _i.cabecera_ += sys.translate("Fecha ped.") + "/";
  _i.cREF = c++;
  _i.cabecera_ += sys.translate("Referencia") + "/";
  _i.cDES = c++;
  _i.cabecera_ += sys.translate("Descripción") + "/";
  _i.cCPD = c++;
  _i.cabecera_ += sys.translate("C.Pedido") + "/";
  _i.cCRA = c++;
  _i.cabecera_ += sys.translate("R.Anterior") + "/";
  _i.cCPT = c++;
  _i.cabecera_ += sys.translate("Pendiente") + "/";
  _i.cCRC = c++;
  _i.cabecera_ += sys.translate("Recibida") + "/";
  /// A partir de aquí no se ven en la tabla pero las necesitamos para posteriores cálculos
  _i.cIMP = c++;
  _i.cabecera_ += sys.translate("cod impuesto") + "/";
  _i.cLIN = c++;
  _i.cabecera_ += sys.translate("id linea") + "/";
  _i.cPVP = c++;
  _i.cabecera_ += sys.translate("pvp unitario") + "/";
  _i.cIVA = c++;
  _i.cabecera_ += sys.translate("iva") + "/";
  _i.cIRPF = c++;
  _i.cabecera_ += sys.translate("irpf") + "/";
  _i.cREC = c++;
  _i.cabecera_ += sys.translate("recargo") + "/";
  _i.cPDTO = c++;
  _i.cabecera_ += sys.translate("dto porcentaje") + "/";
  _i.cDTOL = c++;
  _i.cabecera_ += sys.translate("dto lineal") + "/";
  _i.cPVPSD = c++;
  _i.cabecera_ += sys.translate("pvp sin dto") + "/";
  _i.cIDPED = c++;
  _i.cabecera_ += sys.translate("id Pedido") + "/";

  t.setNumCols(c);
  //t.hideColumn(_i.cPED);
  t.hideColumn(_i.cLIN);
  t.hideColumn(_i.cPVP);
  t.hideColumn(_i.cIMP);
  t.hideColumn(_i.cIVA);
  t.hideColumn(_i.cREC);
  t.hideColumn(_i.cDTOL);
  t.hideColumn(_i.cPDTO);
  t.hideColumn(_i.cIRPF);
  t.hideColumn(_i.cPVPSD);
  t.hideColumn(_i.cIDPED);

  t.setColumnWidth(_i.cPED, 100);
  t.setColumnWidth(_i.cPROV, 100);
  t.setColumnWidth(_i.cFEC, 75);
  t.setColumnWidth(_i.cREF, 80);
  t.setColumnWidth(_i.cDES, 120);
  t.setColumnWidth(_i.cCPD, 70);
  t.setColumnWidth(_i.cCRA, 70);
  t.setColumnWidth(_i.cCPT, 70);
  t.setColumnWidth(_i.cCRC, 70);
  t.setColumnWidth(_i.cIMP, 70);
  t.setColumnWidth(_i.cLIN, 70);
  t.setColumnWidth(_i.cPVP, 70);
  t.setColumnWidth(_i.cIVA, 70);
  t.setColumnWidth(_i.cIRPF, 70);
  t.setColumnWidth(_i.cREC, 70);
  t.setColumnWidth(_i.cDTOL, 70);
  t.setColumnWidth(_i.cPDTO, 70);
  t.setColumnWidth(_i.cPVPSD, 70);
  t.setColumnWidth(_i.cIDPED, 70);

  t.setColumnReadOnly(_i.cPED, true);
  t.setColumnReadOnly(_i.cPROV, true);
  t.setColumnReadOnly(_i.cFEC, true);
  t.setColumnReadOnly(_i.cREF, true);
  t.setColumnReadOnly(_i.cDES, true);
  t.setColumnReadOnly(_i.cCPD, true);
  t.setColumnReadOnly(_i.cCRA, true);
  t.setColumnReadOnly(_i.cCPT, true);
  t.setColumnReadOnly(_i.cIMP, true);
  t.setColumnReadOnly(_i.cPVP, true);
  t.setColumnReadOnly(_i.cLIN, true);
  t.setColumnReadOnly(_i.cIVA, true);
  t.setColumnReadOnly(_i.cREC, true);
  t.setColumnReadOnly(_i.cDTOL, true);
  t.setColumnReadOnly(_i.cPDTO, true);
  t.setColumnReadOnly(_i.cIRPF, true);
  t.setColumnReadOnly(_i.cPVPSD, true);
  t.setColumnReadOnly(_i.cIDPED, true);
  t.setColumnReadOnly(_i.cCRC, false);

  t.setColumnLabels("/", _i.cabecera_);

}

function oficial_cargarTabla(q)
{
  var _i = this.iface;
  var cursor = this.cursor();

  var t = _i.tdbLineasPedidos_;
  t.setNumRows(0);

  var f = 0;
  var pendiente = 0;
  var color;
  var fecha = "";

  var p = 0;
  AQUtil.createProgressDialog(sys.translate("Insertando registros..."), q.size());

  while (q.next()) {
    AQUtil.setProgress(p++);
    t.insertRows(f, 1);
    pendiente = parseFloat(q.value("cantidad")) - parseFloat(q.value("totalenalbaran"));
    if (fecha = "" || fecha != q.value("fecha")) {
      fecha = _i.crearFecha(q.value("fecha"));
    }
    t.setText(f, _i.cPED, q.value("codigo"));
    t.setText(f, _i.cPROV, q.value("codproveedor"));
    t.setText(f, _i.cFEC, fecha);
    t.setText(f, _i.cREF, q.value("referencia"));
    t.setText(f, _i.cDES, q.value("descripcion"));
    t.setText(f, _i.cCPD, q.value("cantidad"));
    t.setText(f, _i.cCRA, q.value("totalenalbaran"));
    t.setText(f, _i.cPVP, q.value("pvpunitario"));
    t.setText(f, _i.cIMP, q.value("codimpuesto"));
    t.setText(f, _i.cLIN, q.value("idlinea"));
    t.setText(f, _i.cPVPSD, q.value("pvpsindto"));
    t.setText(f, _i.cIDPED, q.value("pedidosprov.idpedido"));
    t.setText(f, _i.cIVA, q.value("iva"));
    t.setText(f, _i.cIRPF, q.value("lineaspedidosprov.irpf"));
    t.setText(f, _i.cREC, q.value("recargo"));
    t.setText(f, _i.cDTOL, q.value("dtolineal"));
    t.setText(f, _i.cPDTO, q.value("dtopor"));
    t.setText(f, _i.cCPT, pendiente);
    t.setText(f, _i.cCRC, 0);

    _i.pintarFila(f, pendiente);
    f++;
  }
  sys.AQTimer.singleShot(0, AQUtil.destroyProgressDialog);
}

function oficial_crearFecha(cFecha)
{
  var _i = this.iface;
  var cursor = this.cursor();
  var fecha, dia, mes, anyo;

  dia = cFecha.getDate().toString();
  if (dia.length < 2) {
    dia = "0" + dia;
  }
  mes = cFecha.getMonth().toString();
  if (mes.length < 2) {
    mes = "0" + mes;
  }
  anyo = cFecha.getYear().toString();
  fecha = dia + "/" + mes + "/" + anyo;

  return fecha;
}

function oficial_creaWhere()
{
  var _i = this.iface;
  var cursor = this.cursor();

  var codProveedor = cursor.valueBuffer("codproveedor");
  var idPedido = cursor.valueBuffer("idpedido");

  ///var where = "lineaspedidosprov.idpedido = pedidosprov.idpedido AND pedidosprov.servido <> 'Sí'";
  var where = "lineaspedidosprov.idpedido = pedidosprov.idpedido";

  if (codProveedor && codProveedor != "") {
    where += " AND pedidosprov.codproveedor = '" + codProveedor + "'";
  }
  if (idPedido && idPedido != "") {
    where += " AND lineaspedidosprov.idpedido = " + idPedido;
  }
  where += " ORDER BY pedidosprov.codigo";
  return where;
}

function oficial_creaSelect()
{
  var _i = this.iface;
  var cursor = this.cursor();

  var select = "idlinea, codigo, referencia, cantidad, descripcion, pvpunitario, codproveedor, fecha, totalenalbaran, codimpuesto, dtopor, dtolineal, pvpsindto, lineaspedidosprov.irpf, iva, recargo, pedidosprov.idpedido";

  return select;
}

function oficial_creaFrom()
{
  var _i = this.iface;
  var cursor = this.cursor();

  var from = "lineaspedidosprov,pedidosprov";

  return from;
}


function oficial_guardar()
{
  var _i = this.iface;
  var cursor = this.cursor();

  var t = _i.tdbLineasPedidos_;
  _i.cambiarModo("Pendiente");
  var numFilas = _i.tdbLineasPedidos_.numRows();
  var numColumnas = _i.tdbLineasPedidos_.numCols();

  var oPedidos = new Object();
  var codProveedor, idAlbaran;

  for (var f = 0; f < numFilas; f++) {
    codProveedor = t.text(f, _i.cPROV);
    if (parseFloat(t.text(f, _i.cCRC)) == 0) {
      continue;
    }
    if (codProveedor in oPedidos) {
      idAlbaran = oPedidos[codProveedor];
    } else {
      idAlbaran = _i.creaCabeceraAlbaran(f);
      if (!idAlbaran) {
        return false;
      }
      oPedidos[codProveedor] = idAlbaran;
    }
    if (!_i.creaLineaAlbaran(idAlbaran, f)) {
      return false;
    }
  }

  for (var cP in oPedidos) {
    if (!_i.totalizarAlbaran(oPedidos[cP])) {
      return false;
    }
  }

  MessageBox.information(sys.translate("Las cantidades recibidas han sido guardadas correctamente."), MessageBox.Ok, MessageBox.NoButton);
  _i.busquedaAnterior_ = true;
  _i.tbnBuscar_clicked();
  _i.busquedaAnterior_ = false;
  return true;
}

function oficial_creaCabeceraAlbaran(fila)
{
  var _i = this.iface;
  var cursor = this.cursor();

  var fecha = new Date();
  fecha = fecha.toString();
  var hora = fecha.right(8);

  var t = _i.tdbLineasPedidos_;
  var codProveedor = t.text(fila, _i.cPROV);

  var q = new FLSqlQuery;
  q.setSelect("nombre, cifnif, coddivisa, codpago, codserie");
  q.setFrom("proveedores");
  q.setWhere("codproveedor = '" + codProveedor + "'");
  q.setForwardOnly(true);

  if (!q.exec()) {
    return false;
  }
  if (!q.first()) {
    return false;
  }

  var tasaConv = AQUtil.sqlSelect("divisas", "tasaconv", "coddivisa = '" + q.value("coddivisa") + "'");
  var codEjercicio = flfactppal.iface.pub_ejercicioActual();
  var codAlmacen = flfactppal.iface.pub_valorDefectoEmpresa("codalmacen");

  var curAlbaran = new FLSqlCursor("albaranesprov");

  curAlbaran.setModeAccess(curAlbaran.Insert);
  curAlbaran.refreshBuffer();
  with(curAlbaran) {
    setValueBuffer("codproveedor", codProveedor);
    setValueBuffer("nombre", q.value("nombre"));
    setValueBuffer("cifnif", q.value("cifnif"));
    setValueBuffer("coddivisa", q.value("coddivisa"));
    setValueBuffer("tasaconv", tasaConv);
    setValueBuffer("codpago", q.value("codpago"));
    setValueBuffer("codalmacen", codAlmacen);
    setValueBuffer("fecha", fecha);
    setValueBuffer("hora", hora);
    setValueBuffer("codserie", _i.dameSerieAlbaran(q.value("codserie")));
    setValueBuffer("codejercicio", codEjercicio);
    setValueBuffer("observaciones", "Albarán creado automáticamente desde recepción de pedidos");
  }

  if (!curAlbaran.commitBuffer()) {
    return false;
  }

  var idAlbaran = curAlbaran.valueBuffer("idalbaran");
  return idAlbaran;
}

function oficial_creaLineaAlbaran(idAlbaran, fila)
{
  var _i = this.iface;
  var cursor = this.cursor();

  var t = _i.tdbLineasPedidos_;
  var codProveedor = t.text(fila, _i.cPROV);
  var cantidad = parseFloat(t.text(fila, _i.cCRC));
  var idPedido = t.text(fila, _i.cIDPED);
  var referencia = t.text(fila, _i.cREF);
  var descripcion = t.text(fila, _i.cDES);
  var pvpUnitario = parseFloat(t.text(fila, _i.cPVP));
  var idLinea = t.text(fila, _i.cLIN);
  var codImpuesto = t.text(fila, _i.cIMP);
  var recargo = parseFloat(t.text(fila, _i.cREC));
  var iva = parseFloat(t.text(fila, _i.cIVA));
  var irpf = parseFloat(t.text(fila, _i.cIRPF));
  var dtoLineal = parseFloat(t.text(fila, _i.cDTOL));
  var dtoPor = parseFloat(t.text(fila, _i.cPDTO));
  var pvpSinDto = parseFloat(t.text(fila, _i.cPVPSD));
  var cantPedido = parseFloat(t.text(fila, _i.cCPD));

  pvpSinDto = pvpSinDto * parseFloat(cantidad) / parseFloat(cantPedido);
  pvpSinDto = AQUtil.roundFieldValue(pvpSinDto, "lineasalbaranesprov", "pvpsindto");

  var curLineaAlbaran = new FLSqlCursor("lineasalbaranesprov");

  curLineaAlbaran.setModeAccess(curLineaAlbaran.Insert);
  curLineaAlbaran.refreshBuffer();

  with(curLineaAlbaran) {
    setValueBuffer("idalbaran", idAlbaran);
    setValueBuffer("idlineapedido", idLinea);
    setValueBuffer("idpedido", idPedido);
    setValueBuffer("referencia", referencia);
    setValueBuffer("descripcion", descripcion);
    setValueBuffer("pvpunitario", pvpUnitario);
    setValueBuffer("cantidad", cantidad);
    setValueBuffer("codimpuesto", codImpuesto);
    if (!iva) {
      setNull("iva");
    } else {
      if (iva != 0 && codImpuesto && codImpuesto != "") {
        iva = formRecordlineaspedidosprov.iface.pub_commonCalculateField("iva", curLineaAlbaran); /// Para cambio de IVA según fechas
      }
      setValueBuffer("iva", iva);
    }
    if (!recargo) {
      setNull("recargo");
    } else {
      if (recargo != 0 && codImpuesto && codImpuesto != "") {
        recargo = formRecordlineaspedidosprov.iface.pub_commonCalculateField("recargo", curLineaAlbaran); /// Para cambio de IVA según fechas
      }
      setValueBuffer("recargo", recargo);
    }
    setValueBuffer("irpf", irpf);
    setValueBuffer("dtolineal", dtoLineal);
    setValueBuffer("dtopor", dtoPor);
    setValueBuffer("pvpsindto", pvpSinDto);
    setValueBuffer("pvptotal", formRecordlineaspedidosprov.iface.pub_commonCalculateField("pvptotal", curLineaAlbaran));
  }

  if (!curLineaAlbaran.commitBuffer()) {
    return false;
  }

  return true;
}

function oficial_totalizarAlbaran(idAlbaran)
{
  var curAlbaran = new FLSqlCursor("albaranesprov");

  curAlbaran.select("idalbaran = '" + idAlbaran + "'");
  if (!curAlbaran.first()) {
    return false;
  }
  curAlbaran.setModeAccess(curAlbaran.Edit);
  curAlbaran.refreshBuffer();

  formpedidosprov.iface.curAlbaran = curAlbaran;
  formpedidosprov.iface.totalesAlbaran();
  if (!curAlbaran.commitBuffer()) {
    return false;
  }

  return true;
}

function oficial_pushButtonCancel_clicked()
{
  var _i = this.iface;
  if (_i.modo_ == "Editar") {
    var res = MessageBox.information(sys.translate("Va a cerrar el formulario. Se perderán todos los cambios que no se hayan guardado.\n¿Está seguro?"), MessageBox.Yes, MessageBox.No);
    if (res != MessageBox.Yes) {
      return false;
    }
  }
  this.close();
}

function oficial_bufferChanged(fN)
{
  var _i = this.iface;
  var cursor = this.cursor();
  switch (fN) {
    case "X": {
      break;
    }
    default: {
      if (_i.modo_ == "Pendiente") {
        _i.cambiarModo("Buscar");
      }
      break;
    }
  }
}

function oficial_tbnBuscar_clicked()
{
  var _i = this.iface;
  var cursor = this.cursor();

  var select = _i.creaSelect();
  var from = _i.creaFrom();
  var where = _i.creaWhere();

  var q = new FLSqlQuery;
  q.setSelect(select);
  q.setFrom(from);
  q.setWhere(where);
  q.setForwardOnly(true);
  debug(q.sql());
  if (!q.exec()) {
    return;
  }
  if (!_i.busquedaAnterior_) {
    if (q.size() == 0) {
      MessageBox.information(sys.translate("La búsqueda no ha dado ningún resultado compatible con los filtros puestos."), MessageBox.Ok, MessageBox.NoButton);
      return;
    }

    if (q.size() > 500) {
      var res = MessageBox.information(sys.translate("La búsqueda ha encontrado %1 resultados.\n¿Quiere continuar cargando la tabla?").arg(q.size()), MessageBox.Yes, MessageBox.No);
      if (res != MessageBox.Yes) {
        return;
      }
    }
  }
  _i.cargarTabla(q);
}


function oficial_establecerCantidadRecibida(fila, col)
{
  var _i = this.iface;
  var cursor = this.cursor();
  var cantPendiente;
  var t = _i.tdbLineasPedidos_;

  _i.cambiarModo("Editar");

  if (col == _i.cCRC) {
    if (parseFloat(t.text(fila, _i.cCPT)) == 0) {
      MessageBox.information(sys.translate("La línea ya ha sido recibida por completo y albaranada."), MessageBox.Ok, MessageBox.NoButton);
      t.setText(fila, col, 0);
    }
    if (isNaN(t.text(fila, col))) {
      MessageBox.information(sys.translate("La cantidad recibida debe de ser un número."), MessageBox.Ok, MessageBox.NoButton);
      t.setText(fila, col, 0);
    }
    if (parseFloat(t.text(fila, col)) < 0) {
      MessageBox.information(sys.translate("No se pueden recibir cantidades negativas."), MessageBox.Ok, MessageBox.NoButton);
      t.setText(fila, col, 0);
    }
    cantPendiente = parseFloat(_i.tdbLineasPedidos_.text(fila, _i.cCPD)) - parseFloat(_i.tdbLineasPedidos_.text(fila, _i.cCRA));
    if (t.text(fila, col) > cantPendiente) {
      MessageBox.information(sys.translate("La cantidad recibida debe de ser igual o inferior a la pendiente."), MessageBox.Ok, MessageBox.NoButton);
      t.setText(fila, col, cantPendiente);
    }
    cantPendiente = cantPendiente - parseFloat(t.text(fila, col));

    _i.pintarFila(fila, cantPendiente);
  }
  _i.refrescaFila(fila);
}

function oficial_pintarFila(fila, cantPendiente)
{
  var _i = this.iface;
  var cursor = this.cursor();
  var t = _i.tdbLineasPedidos_;

  switch (cantPendiente) {
    case 0: {
      color = _i.verde_;
      break;
    }
    case parseFloat(t.text(fila, _i.cCPD)): {
      color = _i.rojo_;
      break;
    }
    default: {
      color = _i.amarillo_;
    }
  }
  _i.pintarCeldas(fila, color);
}

function oficial_pintarCeldas(fila, color)
{
  var _i = this.iface;
  var cursor = this.cursor();
  var t = _i.tdbLineasPedidos_;

  t.setCellBackgroundColor(fila, _i.cPED, color);
  t.setCellBackgroundColor(fila, _i.cPROV, color);
  t.setCellBackgroundColor(fila, _i.cFEC, color);
  t.setCellBackgroundColor(fila, _i.cREF, color);
  t.setCellBackgroundColor(fila, _i.cDES, color);
  t.setCellBackgroundColor(fila, _i.cCPD, color);
  t.setCellBackgroundColor(fila, _i.cCRA, color);
  t.setCellBackgroundColor(fila, _i.cCPT, color);
}

function oficial_cambiarModo(modo)
{
  var _i = this.iface;
  _i.modo_ = modo;
}

function oficial_tbnCancelar_clicked()
{
  var _i = this.iface;
  if (_i.modo_ != "Editar") {
    return;
  }
  var res = MessageBox.warning(sys.translate("Se cancelarán todos los cambios realizados en la tabla actual.\n¿Continuar?"), MessageBox.Yes, MessageBox.No);
  if (res != MessageBox.Yes) {
    return;
  }
  _i.busquedaAnterior_ = true;
  _i.tbnBuscar_clicked();
  _i.busquedaAnterior_ = false;
}

function oficial_colores()
{
  var _i = this.iface;
  _i.gris_ = new Color(200, 200, 200);
  _i.blanco_ = new Color(255, 255, 255);
  _i.verde_ = new Color(185, 255, 185);
  _i.amarillo_ = new Color(255, 255, 127);
  _i.rojo_ = new Color(250, 150, 150);
}

function oficial_refrescaFila(f)
{
  var _i = this.iface;
  var numColumnas = _i.tdbLineasPedidos_.numCols();
  var v;
  for (var c = 0; c < numColumnas; c++) {
    _i.tdbLineasPedidos_.setText(f, c, _i.tdbLineasPedidos_.text(f, c));
  }
}

function oficial_incluirFila(fila, col)
{
  var _i = this.iface;
  if (_i.tdbLineasPedidos_.numRows() == 0) {
    return;
  }
  _i.cambiarModo("Editar");
  var cantPendiente = parseFloat(_i.tdbLineasPedidos_.text(fila, _i.cCPD)) - parseFloat(_i.tdbLineasPedidos_.text(fila, _i.cCRA));

  _i.tdbLineasPedidos_.setText(fila, _i.cCRC, cantPendiente);
  _i.pintarFila(fila, 0);
  _i.refrescaFila(fila);
}

function oficial_dameSerieAlbaran(codSerie)
{
  var _i = this.iface;
  return codSerie;
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
