/***************************************************************************
                       anticiposcli.qs  -  description
                             -------------------
    begin                : lun dic 05 2005
    copyright            : (C) 2005 by InfoSiAL S.L.
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
  function calculateField(fN: String): String { return this.ctx.interna_calculateField(fN); }
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna
{
  var ejercicioActual: String;
  var bloqueoSubcuenta: Boolean;
  var longSubcuenta: Number;
  var contabActivada: Boolean;
  var bngTasaCambio: Object;
  var divisaEmpresa: String;
  var posActualPuntoSubcuenta: Number;
  var sumaAnticipos_: Number;
  var sldPorcentaje: Object;
  var connSld: Boolean;
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
  function habilitaPorDivisa()
  {
    return this.ctx.oficial_habilitaPorDivisa();
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
  var cursor: FLSqlCursor = this.cursor();
  var util: FLUtil = new FLUtil();
  this.iface.bngTasaCambio = this.child("bngTasaCambio");
  this.iface.sldPorcentaje = this.child("sldPorcentaje");
  this.iface.divisaEmpresa = util.sqlSelect("empresa", "coddivisa", "1 = 1");

  this.iface.idPedido_ = cursor.valueBuffer("idpedido");
  if (!this.iface.idPedido_) {
    this.iface.idPedido_ = false;
  }
  this.iface.idAlbaran_ = cursor.valueBuffer("idalbaran");
  if (!this.iface.idAlbaran_) {
    this.iface.idAlbaran_ = false;
  }
  this.iface.asociado_ = this.iface.idPedido_ || this.iface.idAlbaran_;

  this.iface.contabActivada = sys.isLoadedModule("flcontppal") && util.sqlSelect("empresa", "contintegrada", "1 = 1");

  if (this.iface.idPedido_) {
    this.iface.sumaAnticipos_ = util.sqlSelect("anticiposcli", "SUM(importe)", "idpedido = " + this.iface.idPedido_ + " AND idanticipo <> " + cursor.valueBuffer("idanticipo"));
  } else if (this.iface.idAlbaran_) {
    this.iface.sumaAnticipos_ = util.sqlSelect("anticiposcli", "SUM(importe)", "idalbaran = " + this.iface.idAlbaran_ + " AND idanticipo <> " + cursor.valueBuffer("idanticipo"));
  } else {
    this.iface.sumaAnticipos_ = 0;
  }

  this.iface.ejercicioActual = flfactppal.iface.pub_ejercicioActual();
  if (this.iface.contabActivada) {
    this.iface.longSubcuenta = util.sqlSelect("ejercicios", "longsubcuenta", "codejercicio = '" + this.iface.ejercicioActual + "'");
    this.child("fdbIdSubcuenta").setFilter("codejercicio = '" + this.iface.ejercicioActual + "'");
    this.iface.posActualPuntoSubcuenta = -1;
  } else {
    this.child("tbwAnticiposCli").setTabEnabled("contabilidad", false);
  }

  //   this.child("fdbTasaConv").setDisabled(true);
  this.child("tdbPartidas").setReadOnly(true);

  if (this.iface.asociado_) {
    connect(this.iface.sldPorcentaje, "valueChanged(int)", this, "iface.sldPorcentajeChanged");
    connect(this.child("bngTasaCambio"), "clicked(int)", this, "iface.bngTasaCambio_clicked");
  } else {
    this.iface.sldPorcentaje.close();
    this.child("spinValPor").close();
    this.child("lblCtePor").close();
    this.child("bngTasaCambio").close();
    this.child("fdbCodCliente").setDisabled(false);
    this.child("fdbNombreCliente").setDisabled(false);
  }
  this.iface.connSld = true;

  switch (cursor.modeAccess()) {
    case cursor.Insert:
      this.iface.iniciarDatos();
      break;
    case cursor.Edit:
      if (cursor.valueBuffer("idsubcuenta") == "0") {
        cursor.setValueBuffer("idsubcuenta", "");
      }
      this.iface.sincronizarControlesImporte();
      this.child("fdbCodEjercicio").setDisabled(true);
      this.child("lblAvisoPtes").text = _i.calculateField("avisoptes");
      break;
    case cursor.Browse:
      this.iface.bngTasaCambio.enabled = false;
      this.iface.sldPorcentaje.enabled = false;
      this.child("spinValPor").enabled = false;
      this.child("lblAvisoPtes").text = _i.calculateField("avisoptes");
  }
  _i.habilitaPorDivisa();

  connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");
  connect(this.child("tbnAgregarRec"), "clicked()", _i, "tbnAgregarRec_clicked");
  connect(this.child("tbnQuitarRec"), "clicked()", _i, "tbnQuitarRec_clicked") ;
}

function interna_validateForm()
{
  var util: FLUtil = new FLUtil();

  if (!this.iface.validarSubcuenta()) {
    return false;
  }
  if (!this.iface.validarImporte()) {
    return false;
  }
  return true;
}

function interna_calculateField(fN)
{
  var _i = this.iface;
  var util: FLUtil = new FLUtil();
  var cursor: FLSqlCursor = this.cursor();
  var valor;
  switch (fN) {
      /** \D
      La subcuenta contable por defecto será la asociada a la cuenta bancaria. Si ésta está vacía, será la subcuenta correspondienta a Caja
      \end */
    case "idsubcuentadefecto":
      if (this.iface.contabActivada) {
        var codSubcuenta = util.sqlSelect("cuentasbanco", "codsubcuenta", "codcuenta = '" + cursor.valueBuffer("codcuenta") + "'");
        if (codSubcuenta)
          valor = util.sqlSelect("co_subcuentas", "idsubcuenta", "codsubcuenta = '" + codSubcuenta + "' AND codejercicio = '" + this.iface.ejercicioActual + "'");
        else {
          var qrySubcuenta: FLSqlQuery = new FLSqlQuery();
          qrySubcuenta.setTablesList("co_cuentas,co_subcuentas");
          qrySubcuenta.setSelect("s.idsubcuenta");
          qrySubcuenta.setFrom("co_cuentas c INNER JOIN co_subcuentas s ON c.idcuenta = s.idcuenta");
          qrySubcuenta.setWhere("c.codejercicio = '" + this.iface.ejercicioActual + "'" + " AND c.idcuentaesp = 'CAJA'");

          if (!qrySubcuenta.exec())
            return false;
          if (!qrySubcuenta.first())
            return false;
          valor = qrySubcuenta.value(0);
        }
      }
      break;
    case "idsubcuenta":
      var codSubcuenta: String = cursor.valueBuffer("codsubcuenta").toString();
      if (codSubcuenta.length == this.iface.longSubcuenta)
        valor = util.sqlSelect("co_subcuentas", "idsubcuenta", "codsubcuenta = '" + codSubcuenta + "' AND codejercicio = '" + this.iface.ejercicioActual + "'");
      break;
      /** \C
      La cuenta bancaria por defecto será la asociada al cliente (Cuenta 'Remesar en'). Si el cliente no está informado o no tiene especificada la cuenta, se tomará la cuenta asociada a la forma de pago asignada a la factura del recibo.
      \end */
    case "codcuenta":
      valor = false;
      var codCliente = cursor.valueBuffer("codcliente");
      if (codCliente) {
        valor = util.sqlSelect("clientes", "codcuentarem", "codcliente = '" + codCliente + "'");
      }
      if (!valor && this.iface.idPedido_) {
        valor = cursor.cursorRelation()
                ? util.sqlSelect("formaspago", "codcuenta", "codpago = '" + cursor.cursorRelation().valueBuffer("codpago") + "'")
                : util.sqlSelect("pedidoscli p INNER JOIN formaspago fp ON p.codpago = fp.codpago", "fp.codpago", "p.idpedido = " + this.iface.idPedido_, "pedidoscli,formaspago");
      }
      if (!valor && this.iface.idAlbaran_) {
        valor = cursor.cursorRelation()
                ? util.sqlSelect("formaspago", "codcuenta", "codpago = '" + cursor.cursorRelation().valueBuffer("codpago") + "'")
                : util.sqlSelect("albaranescli a INNER JOIN formaspago fp ON a.codpago = fp.codpago", "fp.codpago", "a.idalbaran = " + this.iface.idAlbaran_, "albaranescli,formaspago");
      }
      if (!valor) {
        valor = "";
      }
      break;
    case "dc":
      var entidad: String = cursor.valueBuffer("ctaentidad");
      var agencia: String = cursor.valueBuffer("ctaagencia");
      var cuenta: String = cursor.valueBuffer("cuenta");
      if (!entidad.isEmpty() && !agencia.isEmpty() && ! cuenta.isEmpty()
          && entidad.length == 4 && agencia.length == 4 && cuenta.length == 10) {
        var util: FLUtil = new FLUtil();
        var dc1: String = util.calcularDC(entidad + agencia);
        var dc2: String = util.calcularDC(cuenta);
        valor = dc1 + dc2;
      }
      break;
    case "avisoptes": {
      var pte = util.sqlSelect("reciboscli", "SUM(importe)", "codcliente = '" + cursor.valueBuffer("codcliente") + "' AND estado IN ('Emitido', 'Devuelto')");
      if (pte && pte > 0) {
        pte = util.roundFieldValue(pte, "reciboscli", "importe");
        valor = sys.translate("El cliente tiene recibos pendientes por %1").arg(pte);
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
      if (!this.iface.bloqueoSubcuenta) {
        this.iface.bloqueoSubcuenta = true;
        this.iface.posActualPuntoSubcuenta = flcontppal.iface.pub_formatearCodSubcta(this, "fdbCodSubcuenta", this.iface.longSubcuenta, this.iface.posActualPuntoSubcuenta);
        this.iface.bloqueoSubcuenta = false;
      }
      if (!this.iface.bloqueoSubcuenta && this.child("fdbCodSubcuenta").value().length == this.iface.longSubcuenta) {
        this.child("fdbIdSubcuenta").setValue(this.iface.calculateField("idsubcuenta"));
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
      debug("idsubcuenta " + this.iface.calculateField("idsubcuentadefecto"));
      this.child("fdbIdSubcuenta").setValue(this.iface.calculateField("idsubcuentadefecto"));
      this.child("fdbDc").setValue(this.iface.calculateField("dc"));
      break;
    }
    case "importe": {
      debug("Bch importe");
      this.iface.sincronizarControlesImporte();
      this.child("fdbImporteEuros").setValue(_i.calculateField("importeeuros"));
      this.child("fdbPendiente").setValue(_i.calculateField("pendiente"));
      break;
    }
    case "pendiente": {
      this.child("fdbPendienteEuros").setValue(_i.calculateField("pendienteeuros"));
      break;
    }
    case "codcliente": {
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
  if (!this.iface.asociado_) {
    return;
  }
  var cursor = this.cursor();
  var util = new FLUtil;
  var total = 0;
  if (this.iface.idPedido_) {
    total = cursor.cursorRelation()
            ? parseFloat(cursor.cursorRelation().valueBuffer("total"))
            : util.sqlSelect("pedidoscli", "total", "idpedido = " + this.iface.idPedido_);
  } else if (this.iface.idAlbaran_) {
    total = cursor.cursorRelation()
            ? parseFloat(cursor.cursorRelation().valueBuffer("total"))
            : util.sqlSelect("albaranescli", "total", "idalbaran = " + this.iface.idAlbaran_);
  }
  if (total != 0) {
    this.iface.connSld = false;
    var importe = parseFloat(this.cursor().valueBuffer("importe"));
    var newPor ;
    newPor = importe * 100 / total;
    this.child("spinValPor").setValue(newPor);
    this.iface.connSld = true;
  }
  return true;
}

/** \D
Establece el valor de --tasaconv-- obteniéndolo del pedido o del cambio actual de la divisa del recibo
@param  opcion: Origen de la tasa: tasa actual o tasa de la factura original
\end */
function oficial_bngTasaCambio_clicked(opcion)
{
  var util: FLUtil = new FLUtil();
  var cursor: FLSqlCursor = this.cursor();
  var tasaConv = 1;
  switch (opcion) {
    case 0: { // Tasa actual
      if (this.iface.idPedido_) {
        tasaConv = cursor.cursorRelation()
                   ? util.sqlSelect("divisas", "tasaconv", "coddivisa = '" + cursor.cursorRelation().valueBuffer("coddivisa") + "'")
                   : util.sqlSelect("pedidoscli p INNER JOIN divisas d ON p.coddivisa = d.coddivisa", "d.tasaconv", "p.idpedido = " + this.iface.idPedido_, "pedidoscli,divisas");
      }
      if (this.iface.idAlbaran_) {
        tasaConv = cursor.cursorRelation()
                   ? util.sqlSelect("divisas", "tasaconv", "coddivisa = '" + cursor.cursorRelation().valueBuffer("coddivisa") + "'")
                   : util.sqlSelect("albaranescli a INNER JOIN divisas d ON a.coddivisa = d.coddivisa", "d.tasaconv", "a.idalbaran = " + this.iface.idAlbaran_, "albaranescli,divisas");
      }
      break;
    }
    case 1: { // Tasa del documento asociado
      if (this.iface.idPedido_) {
        tasaConv = util.sqlSelect("pedidoscli", "tasaconv", "idpedido = " + this.iface.idPedido_);
      }
      if (this.iface.idAlbaran_) {
        tasaConv = util.sqlSelect("albaranescli", "tasaconv", "idalbaran = " + this.iface.idAlbaran_);
      }
      break;
    }
  }
  this.child("fdbTasaConv").setValue(tasaConv);
}

function oficial_sldPorcentajeChanged(valor: Number)
{
  if (!this.iface.connSld) {
    return;
  }
  var util: FLUtil = new FLUtil();
  var cursor = this.cursor();
  var importe = parseFloat(this.child("fdbImporte").value());
  var newImporte, total;
  if (this.iface.idPedido_) {
    total = cursor.cursorRelation()
            ? cursor.cursorRelation().valueBuffer("total")
            : util.sqlSelect("pedidoscli", "total", "idpedido = " + this.iface.idPedido_);
  }
  if (this.iface.idAlbaran_) {
    total = cursor.cursorRelation()
            ? cursor.cursorRelation().valueBuffer("total")
            : util.sqlSelect("albaranescli", "total", "idalbaran = " + this.iface.idAlbaran_);
  }
  newImporte = parseFloat(total) * valor / 100;
  this.child("fdbImporte").setValue(newImporte);
}

function oficial_iniciarDatos()
{
  var util = new FLUtil;
  var cursor = this.cursor();
  this.child("fdbCodCuenta").setValue(this.iface.calculateField("codcuenta"));
  this.child("fdbCodEjercicio").setValue(flfactppal.iface.pub_ejercicioActual());

  if (this.iface.contabActivada) {
    this.child("fdbIdSubcuenta").setValue(this.iface.calculateField("idsubcuentadefecto"));
  }
  if (this.iface.asociado_) {
    if (cursor.cursorRelation().valueBuffer("coddivisa") != this.iface.divisaEmpresa) {
      this.child("fdbTasaConv").setDisabled(false);
      this.child("rbnTasaActual").checked = true;
      this.iface.bngTasaCambio_clicked(0);
    }
    var numero = cursor.size() + 1;
    var codDoc = cursor.cursorRelation().valueBuffer("codigo");
    var codigo = this.iface.idPedido_
                 ? "P" + codDoc + "-" + numero
                 : "A" + codDoc + "-" + numero;
    var concepto = this.iface.idPedido_
                   ? sys.translate("Pago anticipado pedido %1").arg(codDoc)
                   : sys.translate("Pago anticipado albarán %1").arg(codDoc);
    this.child("fdbCodigo").setValue(codigo);
    this.child("fdbConcepto").setValue(concepto);
    this.child("fdbImporte").setValue(cursor.cursorRelation().valueBuffer("total") - this.iface.sumaAnticipos_);
    this.child("fdbCodCliente").setValue(cursor.cursorRelation().valueBuffer("codcliente"));
    this.child("fdbNombreCliente").setValue(cursor.cursorRelation().valueBuffer("nombrecliente"));
    this.child("fdbCodDivisa").setValue(cursor.cursorRelation().valueBuffer("coddivisa"));
  }
}

function oficial_validarSubcuenta()
{
  var util: FLUtil = new FLUtil();
  /** \C
  Si la contabilidad está integrada, se debe seleccionar una subcuenta válida a la que asignar el asiento de pago o devolución
  \end */
  if (this.iface.contabActivada && !this.child("fdbNoGenerarAsiento").value() && (this.child("fdbCodSubcuenta").value().isEmpty() || this.child("fdbIdSubcuenta").value() == 0)) {
    MessageBox.warning(sys.translate("Debe seleccionar una subcuenta válida a la que asignar el asiento de pago o devolución"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton, "AbanQ");
    return false;
  }
  return true;
}

function oficial_validarImporte()
{
  var util = new FLUtil();
  var cursor = this.cursor();

  /** \C
  El importe del anticipo debe ser mayor que cero
  \end */
  var importe = parseFloat(cursor.valueBuffer("importe"));
  if (importe <= 0) {
    MessageBox.warning(sys.translate("El importe debe ser mayor que cero"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton, "AbanQ");
    return false;
  }

  var cancelado = parseFloat(cursor.valueBuffer("cancelado"));
  if (importe < cancelado) {
    MessageBox.warning(sys.translate("El importe debe ser mayor o igual que el total cancelado"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton, "AbanQ");
    return false;
  }

  /** \C
  La suma de anticipos no puede superior al total del documento
  \end */
  if (this.iface.asociado_) {
    var total = 0;
    if (cursor.cursorRelation()) {
      total = cursor.cursorRelation().valueBuffer("total");
    } else if (this.iface.idPedido_) {
      total = util.sqlSelect("pedidoscli", "total", "idpedido = " + this.iface.idPedido_);
    } else if (this.iface.idAlbaran_) {
      total = util.sqlSelect("albaranescli", "total", "idalbaran = " + this.iface.idAlbaran_);
    }
    var difAnticipos = this.iface.sumaAnticipos_ + parseFloat(this.child("fdbImporte").value()) - parseFloat(total);
    difAnticipos = parseFloat(util.roundFieldValue(difAnticipos, "pedidoscli", "total"));
    if (difAnticipos > 0) {
      MessageBox.warning(sys.translate("La suma de anticipos no puede superar el total del documento"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
      return false;
    }
  }
  return true;
}

function oficial_commonCalculateField(fN, cursor)
{
  var _i = this.iface;
  var valor;

  switch (fN) {
    case "pendiente": {
      valor = cursor.valueBuffer("importe") - cursor.valueBuffer("cancelado");
      valor = AQUtil.roundFieldValue(valor, "anticiposcli", "pendiente");
      break;
    }
    case "cancelado": {
      valor = AQUtil.sqlSelect("reciboscli", "SUM(importe)", "idanticipo = " + cursor.valueBuffer("idanticipo"));
      valor = isNaN(valor) ? 0 : valor;
      valor = AQUtil.roundFieldValue(valor, "anticiposcli", "cancelado");
      break;
    }
    case "importeeuros": {
      var tC = cursor.valueBuffer("tasaconv");
      valor = cursor.valueBuffer("importe") * tC;
      valor = AQUtil.roundFieldValue(valor, "anticiposcli", "importeeuros");
      break;
    }
    case "canceladoeuros": {
      valor = AQUtil.sqlSelect("reciboscli", "SUM(importeeuros)", "idanticipo = " + cursor.valueBuffer("idanticipo"));
      valor = isNaN(valor) ? 0 : valor;
      valor = AQUtil.roundFieldValue(valor, "anticiposcli", "cancelado");
      break;
    }
    case "pendienteeuros": {
      var canceladoEuros = _i.commonCalculateField("canceladoeuros", cursor);
      valor = cursor.valueBuffer("importeeuros") - canceladoEuros;
      //      valor = cursor.valueBuffer("importe") - cursor.valueBuffer("cancelado");
      //      var tC = cursor.valueBuffer("tasaconv");
      //      valor = cursor.valueBuffer("pendiente") * tC;
      valor = AQUtil.roundFieldValue(valor, "anticiposcli", "pendienteeuros");
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

  var f = new FLFormSearchDB("seleccionrecibosanticiposcli");
  curF = f.cursor();
  curF.setMainFilter("codcliente = '" + cursor.valueBuffer("codcliente") + "' AND coddivisa = '" + cursor.valueBuffer("coddivisa") + "' AND idanticipo = 0 AND estado IN ('Emitido', 'Devuelto')");
  f.setMainWidget();
  f.exec();
  if (!f.accepted()) {
    return false;
  }
  if (!_i.aRecibos_) {
    return;
  }
  var curR  = new FLSqlCursor("reciboscli");
  var numRecibos = 0;
  var sRecibos = _i.aRecibos_.join(",");
  var importeRecibos = AQUtil.sqlSelect("reciboscli", "SUM(importe)", "idrecibo IN (" + sRecibos + ")");
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
      break;
    }
    curR.select("idrecibo = " + _i.aRecibos_[i]);
    if (!curR.next()) {
      return false;
    }
    if (!flfactteso.iface.pub_aplicarAnticipo(curR, cursor, false)) {
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
  var cursor = this.cursor();
  var idAnticipo = cursor.valueBuffer("idanticipo");
  var _i = this.iface;
  var curR = this.child("tdbRecibos").cursor();
  if (!flfactteso.iface.pub_desvincularReciboAnticipo(curR.valueBuffer("idrecibo"), idAnticipo, false)) {
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
