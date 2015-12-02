/***************************************************************************
                       anticiposprov.qs  -  description
                             -------------------
    begin                : lun ene 09 2012
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

/** @ file */

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
    this.ctx.interna_init();
  }
  function validateForm()
  {
    return this.ctx.interna_validateForm();
  }
  function calculateField(fN)
  {
    return this.ctx.interna_calculateField(fN);
  }
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna
{
  var ejercicioActual;
  var bloqueoSubcuenta;
  var longSubcuenta;
  var contabActivada;
  var bngTasaCambio;
  var divisaEmpresa;
  var posActualPuntoSubcuenta;
  var sumaAnticipos_;
  var sldPorcentaje;
  var connSld;
  var idPedido_;
  var idAlbaran_;
  var asociado_;
  var aRecibos_;

  function oficial(context)
  {
    interna(context);
  }
  function bufferChanged(fN)
  {
    return this.ctx.oficial_bufferChanged(fN);
  }
  function bngTasaCambio_clicked(opcion: Number)
  {
    return this.ctx.oficial_bngTasaCambio_clicked(opcion);
  }
  function sldPorcentajeChanged(valor: Number)
  {
    return this.ctx.oficial_sldPorcentajeChanged(valor);
  }
  function iniciarDatos()
  {
    return this.ctx.oficial_iniciarDatos();
  }
  function sincronizarControlesImporte()
  {
    return this.ctx.oficial_sincronizarControlesImporte();
  }
  function validarSubcuenta()
  {
    return this.ctx.oficial_validarSubcuenta();
  }
  function validarImporte()
  {
    return this.ctx.oficial_validarImporte();
  }
  function commonCalculateField(fN, cursor)
  {
    return this.ctx.oficial_commonCalculateField(fN, cursor);
  }
  function tbnAgregarRec_clicked()
  {
    return this.ctx.oficial_tbnAgregarRec_clicked();
  }
  function tbnQuitarRec_clicked()
  {
    return this.ctx.oficial_tbnQuitarRec_clicked();
  }
  function actualizaTotales()
  {
    return this.ctx.oficial_actualizaTotales();
  }
  function habilitaPorDivisa()
  {
    return this.ctx.oficial_habilitaPorDivisa();
  }
  function ponListaRecibos(l)
  {
    return this.ctx.oficial_ponListaRecibos(l);
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
  function pub_commonCalculateField(fN, cursor)
  {
    return this.commonCalculateField(fN, cursor);
  }
  function pub_ponListaRecibos(l)
  {
    return this.ponListaRecibos(l);
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
/** \C El marco 'Contabilidad' se habilitará en caso de que esté cargado el módulo principal de contabilidad.
\end */
function interna_init()
{
  var _i = this.iface;
  var cursor = this.cursor();
  var util = new FLUtil();
  _i.bngTasaCambio = this.child("bngTasaCambio");
  _i.sldPorcentaje = this.child("sldPorcentaje");
  _i.divisaEmpresa = util.sqlSelect("empresa", "coddivisa", "1 = 1");

  /** Copiado de anticipos a clientes, se deja por si se incorporan anticipos a pedidos y albaranes de proveedores
  _i.idPedido_ = cursor.valueBuffer("idpedido");
  if (!_i.idPedido_) {
    _i.idPedido_ = false;
  }
  _i.idAlbaran_ = cursor.valueBuffer("idalbaran");
  if (!_i.idAlbaran_) {
    _i.idAlbaran_ = false;
  }
  _i.asociado_ = _i.idPedido_ || _i.idAlbaran_;
  */
  _i.asociado_ = false;
  _i.idPedido_ = false;
  _i.idAlbaran_ = false;

  if (_i.idPedido_) {
    _i.sumaAnticipos_ = util.sqlSelect("anticiposcli", "SUM(importe)", "idpedido = " + _i.idPedido_ + " AND idanticipo <> " + cursor.valueBuffer("idanticipo"));
  } else if (_i.idAlbaran_) {
    _i.sumaAnticipos_ = util.sqlSelect("anticiposcli", "SUM(importe)", "idalbaran = " + _i.idAlbaran_ + " AND idanticipo <> " + cursor.valueBuffer("idanticipo"));
  } else {
    _i.sumaAnticipos_ = 0;
  }


  _i.contabActivada = sys.isLoadedModule("flcontppal") && util.sqlSelect("empresa", "contintegrada", "1 = 1");
  _i.ejercicioActual = flfactppal.iface.pub_ejercicioActual();
  if (_i.contabActivada) {
    _i.longSubcuenta = util.sqlSelect("ejercicios", "longsubcuenta", "codejercicio = '" + _i.ejercicioActual + "'");
    this.child("fdbIdSubcuenta").setFilter("codejercicio = '" + _i.ejercicioActual + "'");
    _i.posActualPuntoSubcuenta = -1;
  } else {
    this.child("tbwAnticipos").setTabEnabled("contabilidad", false);
  }

  this.child("fdbTasaConv").setDisabled(true);
  this.child("tdbPartidas").setReadOnly(true);

  if (_i.asociado_) {
    connect(_i.sldPorcentaje, "valueChanged(int)", this, "iface.sldPorcentajeChanged");
    connect(this.child("bngTasaCambio"), "clicked(int)", this, "iface.bngTasaCambio_clicked");
  } else {
    _i.sldPorcentaje.close();
    this.child("spinValPor").close();
    this.child("lblCtePor").close();
    this.child("bngTasaCambio").close();
    this.child("fdbCodProveedor").setDisabled(false);
    this.child("fdbNombreProveedor").setDisabled(false);
  }
  _i.connSld = true;

  switch (cursor.modeAccess()) {
    case cursor.Insert:
      _i.iniciarDatos();
      break;
    case cursor.Edit:
      if (cursor.valueBuffer("idsubcuenta") == "0") {
        cursor.setValueBuffer("idsubcuenta", "");
      }
      _i.sincronizarControlesImporte();
      this.child("fdbCodEjercicio").setDisabled(true);
      this.child("lblAvisoPtes").text = _i.calculateField("avisoptes");
      break;
    case cursor.Browse:
      _i.bngTasaCambio.enabled = false;
      _i.sldPorcentaje.enabled = false;
      this.child("spinValPor").enabled = false;
      this.child("lblAvisoPtes").text = _i.calculateField("avisoptes");
  }

  connect(cursor, "bufferChanged(QString)", _i, "bufferChanged");
  connect(this.child("tbnAgregarRec"), "clicked()", _i, "tbnAgregarRec_clicked");
  connect(this.child("tbnQuitarRec"), "clicked()", _i, "tbnQuitarRec_clicked") ;

  _i.habilitaPorDivisa();
}

function interna_validateForm()
{
  var _i = this.iface;

  if (!_i.validarSubcuenta()) {
    return false;
  }
  if (!_i.validarImporte()) {
    return false;
  }
  return true;
}

function interna_calculateField(fN)
{
  var _i = this.iface;
  var util = new FLUtil();
  var cursor = this.cursor();
  var valor;
  switch (fN) {
      /** \D
      La subcuenta contable por defecto será la asociada a la cuenta bancaria. Si ésta está vacía, será la subcuenta correspondienta a Caja
      \end */
    case "idsubcuentadefecto": {
      if (_i.contabActivada) {
        var codSubcuenta = util.sqlSelect("cuentasbanco", "codsubcuenta", "codcuenta = '" + cursor.valueBuffer("codcuenta") + "'");
        if (codSubcuenta) {
          valor = util.sqlSelect("co_subcuentas", "idsubcuenta", "codsubcuenta = '" + codSubcuenta + "' AND codejercicio = '" + _i.ejercicioActual + "'");
        } else {
          var qrySubcuenta: FLSqlQuery = new FLSqlQuery();
          qrySubcuenta.setTablesList("co_cuentas,co_subcuentas");
          qrySubcuenta.setSelect("s.idsubcuenta");
          qrySubcuenta.setFrom("co_cuentas c INNER JOIN co_subcuentas s ON c.idcuenta = s.idcuenta");
          qrySubcuenta.setWhere("c.codejercicio = '" + _i.ejercicioActual + "'" + " AND c.idcuentaesp = 'CAJA'");
          if (!qrySubcuenta.exec()) {
            return false;
          }
          if (!qrySubcuenta.first()) {
            return false;
          }
          valor = qrySubcuenta.value(0);
        }
      }
      break;
    }
    case "idsubcuenta": {
      var codSubcuenta = cursor.valueBuffer("codsubcuenta").toString();
      if (codSubcuenta.length == _i.longSubcuenta)
        valor = util.sqlSelect("co_subcuentas", "idsubcuenta", "codsubcuenta = '" + codSubcuenta + "' AND codejercicio = '" + _i.ejercicioActual + "'");
      break;
    }
    case "codcuenta": {
      valor = "";
      break;
    }
    case "dc": {
      var entidad = cursor.valueBuffer("ctaentidad");
      var agencia = cursor.valueBuffer("ctaagencia");
      var cuenta = cursor.valueBuffer("cuenta");
      if (!entidad.isEmpty() && !agencia.isEmpty() && ! cuenta.isEmpty() && entidad.length == 4 && agencia.length == 4 && cuenta.length == 10) {
        var dc1 = util.calcularDC(entidad + agencia);
        var dc2 = util.calcularDC(cuenta);
        valor = dc1 + dc2;
      }
      break;
    }
    case "avisoptes": {
      var pte = util.sqlSelect("recibosprov", "SUM(importe)", "codproveedor = '" + cursor.valueBuffer("codproveedor") + "' AND estado IN ('Emitido', 'Devuelto')");
      if (pte && pte > 0) {
        pte = util.roundFieldValue(pte, "recibosprov", "importe");
        valor = util.translate("scripts", "El proveedor tiene recibos pendientes por %1").arg(pte);
      } else {
        valor = "";
      }
      break;
    }
    case "tasaconv": {
      if (cursor.valueBuffer("coddivisa") == _i.divisaEmpresa) {
        valor = 1;
      } else {
        valor = AQUtil.sqlSelect("divisas", "tasaconv", "coddivisa = '" + cursor.valueBuffer("coddivisa") + "'");
      }
      debug("valor = " + valor);
      break;
    }
    default: {
      valor = _i.commonCalculateField(fN, cursor);
      break;
    }
  }
  return valor;
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_habilitaPorDivisa()
{
  var _i = this.iface;
  var cursor = this.cursor();
  if (cursor.valueBuffer("coddivisa") == _i.divisaEmpresa) {
    this.child("fdbTasaConv").setDisabled(true);
  } else {
    this.child("fdbTasaConv").setDisabled(false);
  }
}

function oficial_bufferChanged(fN)
{
  var _i = this.iface;
  var util = new FLUtil();
  var cursor = this.cursor();
  switch (fN) {
      /** \C
      Si el usuario pulsa la tecla del punto '.', la subcuenta se informa automaticamente con el código de cuenta más tantos ceros como sea necesario para completar la longitud de subcuenta asociada al ejercicio actual.
      \end */
    case "codsubcuenta": {
      if (!_i.bloqueoSubcuenta) {
        _i.bloqueoSubcuenta = true;
        _i.posActualPuntoSubcuenta = flcontppal.iface.pub_formatearCodSubcta(this, "fdbCodSubcuenta", _i.longSubcuenta, _i.posActualPuntoSubcuenta);
        _i.bloqueoSubcuenta = false;
      }
      if (!_i.bloqueoSubcuenta && this.child("fdbCodSubcuenta").value().length == _i.longSubcuenta) {
        this.child("fdbIdSubcuenta").setValue(_i.calculateField("idsubcuenta"));
      }
      break;
    }
    /** \C
    Si el usuario selecciona una cuenta bancaria, se tomará su cuenta contable asociada como cuenta contable para el pago. La subcuenta contable por defecto será la asociada a la cuenta bancaria. Si ésta está vacía, será la subcuenta correspondienta a Caja
    \end */
    case "codcuenta":
    case "ctaentidad":
    case "ctaagencia":
    case "cuenta": {
      debug("idsubcuenta " + _i.calculateField("idsubcuentadefecto"));
      this.child("fdbIdSubcuenta").setValue(_i.calculateField("idsubcuentadefecto"));
      this.child("fdbDc").setValue(_i.calculateField("dc"));
      break;
    }
    case "importe": {
      _i.sincronizarControlesImporte();
      this.child("fdbImporteEuros").setValue(_i.calculateField("importeeuros"));
      this.child("fdbPendiente").setValue(_i.calculateField("pendiente"));
      break;
    }
    case "importeeuros": {
      this.child("fdbPendienteEuros").setValue(_i.calculateField("pendienteeuros"));
      break;
    }
    case "codproveedor": {
      this.child("fdbCodCuenta").setValue(_i.calculateField("codcuenta"));
      this.child("lblAvisoPtes").text = _i.calculateField("avisoptes");
      break;
    }
    case "coddivisa": {
      _i.habilitaPorDivisa();
      this.child("fdbTasaConv").setValue(_i.calculateField("tasaconv"));
    }
    case "tasaconv": {
      this.child("fdbImporteEuros").setValue(_i.calculateField("importeeuros"));
      this.child("fdbPendienteEuros").setValue(_i.calculateField("pendienteeuros"));
      break;
    }
  }
}

function oficial_sincronizarControlesImporte()
{
  var _i = this.iface;
  if (!_i.asociado_) {
    return;
  }
  var cursor = this.cursor();
  var util = new FLUtil;
  var total = 0;
  if (_i.idPedido_) {
    total = cursor.cursorRelation()
            ? parseFloat(cursor.cursorRelation().valueBuffer("total"))
            : util.sqlSelect("pedidoscli", "total", "idpedido = " + _i.idPedido_);
  } else if (_i.idAlbaran_) {
    total = cursor.cursorRelation()
            ? parseFloat(cursor.cursorRelation().valueBuffer("total"))
            : util.sqlSelect("albaranescli", "total", "idalbaran = " + _i.idAlbaran_);
  }
  if (total != 0) {
    _i.connSld = false;
    var importe = parseFloat(this.cursor().valueBuffer("importe"));
    var newPor ;
    newPor = importe * 100 / total;
    this.child("spinValPor").setValue(newPor);
    _i.connSld = true;
  }
  return true;
}

/** \D
Establece el valor de --tasaconv-- obteniéndolo del pedido o del cambio actual de la divisa del recibo
@param  opcion: Origen de la tasa: tasa actual o tasa de la factura original
\end */
function oficial_bngTasaCambio_clicked(opcion)
{
  var _i = this.iface;
  var util: FLUtil = new FLUtil();
  var cursor: FLSqlCursor = this.cursor();
  var tasaConv = 1;
  switch (opcion) {
    case 0: { // Tasa actual
      if (_i.idPedido_) {
        tasaConv = cursor.cursorRelation()
                   ? util.sqlSelect("divisas", "tasaconv", "coddivisa = '" + cursor.cursorRelation().valueBuffer("coddivisa") + "'")
                   : util.sqlSelect("pedidoscli p INNER JOIN divisas d ON p.coddivisa = d.coddivisa", "d.tasaconv", "p.idpedido = " + _i.idPedido_, "pedidoscli,divisas");
      }
      if (_i.idAlbaran_) {
        tasaConv = cursor.cursorRelation()
                   ? util.sqlSelect("divisas", "tasaconv", "coddivisa = '" + cursor.cursorRelation().valueBuffer("coddivisa") + "'")
                   : util.sqlSelect("albaranescli a INNER JOIN divisas d ON a.coddivisa = d.coddivisa", "d.tasaconv", "a.idalbaran = " + _i.idAlbaran_, "albaranescli,divisas");
      }
      break;
    }
    case 1: { // Tasa del documento asociado
      if (_i.idPedido_) {
        tasaConv = util.sqlSelect("pedidoscli", "tasaconv", "idpedido = " + _i.idPedido_);
      }
      if (_i.idAlbaran_) {
        tasaConv = util.sqlSelect("albaranescli", "tasaconv", "idalbaran = " + _i.idAlbaran_);
      }
      break;
    }
  }
  this.child("fdbTasaConv").setValue(tasaConv);
}

function oficial_sldPorcentajeChanged(valor: Number)
{
  var _i = this.iface;
  if (!_i.connSld) {
    return;
  }
  var util: FLUtil = new FLUtil();
  var cursor = this.cursor();
  var importe = parseFloat(this.child("fdbImporte").value());
  var newImporte, total;
  if (_i.idPedido_) {
    total = cursor.cursorRelation()
            ? cursor.cursorRelation().valueBuffer("total")
            : util.sqlSelect("pedidoscli", "total", "idpedido = " + _i.idPedido_);
  }
  if (_i.idAlbaran_) {
    total = cursor.cursorRelation()
            ? cursor.cursorRelation().valueBuffer("total")
            : util.sqlSelect("albaranescli", "total", "idalbaran = " + _i.idAlbaran_);
  }
  newImporte = parseFloat(total) * valor / 100;
  this.child("fdbImporte").setValue(newImporte);
}

function oficial_iniciarDatos()
{
  var _i = this.iface;
  var util = new FLUtil;
  var cursor = this.cursor();
  this.child("fdbCodCuenta").setValue(_i.calculateField("codcuenta"));
  this.child("fdbCodEjercicio").setValue(flfactppal.iface.pub_ejercicioActual());

  if (_i.contabActivada) {
    this.child("fdbIdSubcuenta").setValue(_i.calculateField("idsubcuentadefecto"));
  }
  if (_i.asociado_) {
    if (cursor.cursorRelation().valueBuffer("coddivisa") != _i.divisaEmpresa) {
      this.child("fdbTasaConv").setDisabled(false);
      this.child("rbnTasaActual").checked = true;
      _i.bngTasaCambio_clicked(0);
    }
    var numero = cursor.size() + 1;
    var codDoc = cursor.cursorRelation().valueBuffer("codigo");
    var codigo = _i.idPedido_
                 ? "P" + codDoc + "-" + numero
                 : "A" + codDoc + "-" + numero;
    var concepto = _i.idPedido_
                   ? util.translate("scripts", "Pago anticipado pedido %1").arg(codDoc)
                   : util.translate("scripts", "Pago anticipado albarán %1").arg(codDoc);
    this.child("fdbCodigo").setValue(codigo);
    this.child("fdbConcepto").setValue(concepto);
    this.child("fdbImporte").setValue(cursor.cursorRelation().valueBuffer("total") - _i.sumaAnticipos_);
    this.child("fdbCodProveedor").setValue(cursor.cursorRelation().valueBuffer("codproveedor"));
    this.child("fdbNombreProveedor").setValue(cursor.cursorRelation().valueBuffer("nombre"));
    this.child("fdbCodDivisa").setValue(cursor.cursorRelation().valueBuffer("coddivisa"));
  }
}

function oficial_validarSubcuenta()
{
  var _i = this.iface;
  var util: FLUtil = new FLUtil();
  /** \C
  Si la contabilidad está integrada, se debe seleccionar una subcuenta válida a la que asignar el asiento de pago o devolución
  \end */
  if (_i.contabActivada && !this.child("fdbNoGenerarAsiento").value() && (this.child("fdbCodSubcuenta").value().isEmpty() || this.child("fdbIdSubcuenta").value() == 0)) {
    MessageBox.warning(util.translate("scripts", "Debe seleccionar una subcuenta válida a la que asignar el asiento de pago o devolución"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton, "AbanQ");
    return false;
  }
  return true;
}

function oficial_validarImporte()
{
  var _i = this.iface;
  var util = new FLUtil();
  var cursor = this.cursor();

  /** \C
  El importe del anticipo debe ser mayor que cero
  \end */
  var importe = parseFloat(cursor.valueBuffer("importe"));
  if (importe <= 0) {
    MessageBox.warning(util.translate("scripts", "El importe debe ser mayor que cero"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton, "AbanQ");
    return false;
  }

  var cancelado = parseFloat(cursor.valueBuffer("cancelado"));
  if (importe < cancelado) {
    MessageBox.warning(util.translate("scripts", "El importe debe ser mayor o igual que el total cancelado"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton, "AbanQ");
    return false;
  }

  /** \C
  La suma de anticipos no puede superior al total del documento
  \end */
  if (_i.asociado_) {
    var total = 0;
    if (cursor.cursorRelation()) {
      total = cursor.cursorRelation().valueBuffer("total");
    } else if (_i.idPedido_) {
      total = util.sqlSelect("pedidoscli", "total", "idpedido = " + _i.idPedido_);
    } else if (_i.idAlbaran_) {
      total = util.sqlSelect("albaranescli", "total", "idalbaran = " + _i.idAlbaran_);
    }
    var difAnticipos = _i.sumaAnticipos_ + parseFloat(this.child("fdbImporte").value()) - parseFloat(total);
    difAnticipos = parseFloat(util.roundFieldValue(difAnticipos, "pedidoscli", "total"));
    if (difAnticipos > 0) {
      MessageBox.warning(util.translate("scripts", "La suma de anticipos no puede superar el total del documento"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
      return false;
    }
  }
  return true;
}

function oficial_commonCalculateField(fN, cursor)
{
  var _i = this.iface;
  var util = new FLUtil;
  var valor;
  switch (fN) {
    case "pendiente": {
      valor = cursor.valueBuffer("importe") - cursor.valueBuffer("cancelado");
      valor = AQUtil.roundFieldValue(valor, "anticiposprov", "pendiente");
      break;
    }
    case "cancelado": {
      valor = util.sqlSelect("recibosprov", "SUM(importe)", "idanticipo = " + cursor.valueBuffer("idanticipo"));
      valor = isNaN(valor) ? 0 : valor;
      valor = AQUtil.roundFieldValue(valor, "anticiposprov", "cancelado");
      break;
    }
    case "importeeuros": {
      var tC = cursor.valueBuffer("tasaconv");
      valor = cursor.valueBuffer("importe") * tC;
      valor = AQUtil.roundFieldValue(valor, "anticiposprov", "importeeuros");
      break;
    }
    case "canceladoeuros": {
      valor = AQUtil.sqlSelect("recibosprov", "SUM(importeeuros)", "idanticipo = " + cursor.valueBuffer("idanticipo"));
      valor = isNaN(valor) ? 0 : valor;
      valor = AQUtil.roundFieldValue(valor, "anticiposprov", "importeeuros");
      break;
    }
    case "pendienteeuros": {
      var canceladoEuros = _i.commonCalculateField("canceladoeuros", cursor);
      valor = cursor.valueBuffer("importeeuros") - canceladoEuros;
      valor = AQUtil.roundFieldValue(valor, "anticiposprov", "pendienteeuros");
      break;
    }
  }
  return valor;
}

function oficial_tbnAgregarRec_clicked()
{
  var _i = this.iface;
  var cursor = this.cursor();
  var idAnticipo = cursor.valueBuffer("idanticipo");
  if (!this.child("tdbRecibos").cursor().commitBufferCursorRelation()) {
    return false;
  }

  if (parseFloat(cursor.valueBuffer("pendiente")) == 0) {
    MessageBox.information(sys.translate("Debe añadir un importe al anticipo para poder seleccionar recibos a abonar."), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton, "AbanQ");
    return;
  }

  var f = new FLFormSearchDB("seleccionrecibosanticiposprov");
  curF = f.cursor();
  curF.setMainFilter("codproveedor = '" + cursor.valueBuffer("codproveedor") + "' AND coddivisa = '" + cursor.valueBuffer("coddivisa") + "' AND idanticipo = 0 AND estado IN ('Emitido', 'Devuelto')");
  f.setMainWidget();
  f.exec("datos");
  if (!f.accepted()) {
    return false;
  }
  if (!_i.aRecibos_) {
    return;
  }
  var curR  = new FLSqlCursor("recibosprov");
  var numRecibos = 0;
  var sRecibos = _i.aRecibos_.join(",");
  var importeRecibos = AQUtil.sqlSelect("recibosprov", "SUM(importe)", "idrecibo IN (" + sRecibos + ")");
  importeRecibos = isNaN(importeRecibos) ? 0 : importeRecibos;
  if (importeRecibos > cursor.valueBuffer("pendiente")) {
    var res = MessageBox.warning(sys.translate("La suma de los importes de los recibos es superior al pendiente del anticipo.\nSe añadirán recibos mientras quede anticipo pendiente y el último recibo se dividirá.\n¿Está seguro?"), MessageBox.Yes, MessageBox.No);
    if (res != MessageBox.Yes) {
      return false;
    }
  }
  for (var i = 0; i < _i.aRecibos_.length; i++) {
    if (parseFloat(cursor.valueBuffer("pendiente")) == 0) {
      MessageBox.information(sys.translate("No se pueden añadir más recibos.\nEl pago a cuenta pendiente se ha agotado."), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton, "AbanQ");
      i = _i.aRecibos_.length;
      continue;
    }
    curR.select("idrecibo = " + _i.aRecibos_[i]);
    if (!curR.next()) {
      return false;
    }
    if (!flfactteso.iface.pub_aplicarAnticipoProv(curR, cursor, false)) {
      return false;
    }
    _i.actualizaTotales();
    numRecibos++;
  }

  this.child("tdbRecibos").refresh();

  MessageBox.information(sys.translate("Se han añadido %1 recibos al anticipo.").arg(numRecibos), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton, "AbanQ");
}

function oficial_ponListaRecibos(l)
{
  var _i = this.iface;
  _i.aRecibos_ = l;
}

function oficial_tbnQuitarRec_clicked()
{
  var _i = this.iface;
  var cursor = this.cursor();
  var idAnticipo = cursor.valueBuffer("idanticipo");
  var curR = this.child("tdbRecibos").cursor();
  if (!flfactteso.iface.pub_desvincularReciboAnticipoProv(curR.valueBuffer("idrecibo"), idAnticipo, false)) {
    return false;
  }
  _i.actualizaTotales();
  this.child("tdbRecibos").refresh();
}

function oficial_actualizaTotales()
{
  var _i = this.iface;
  this.child("fdbCancelado").setValue(_i.calculateField("cancelado"));
  this.child("fdbPendiente").setValue(_i.calculateField("pendiente"));
  this.child("fdbPendienteEuros").setValue(_i.calculateField("pendienteeuros"));
  this.child("lblAvisoPtes").text = _i.calculateField("avisoptes");
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
