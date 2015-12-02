/***************************************************************************
                 recibosprov.qs  -  description
                             -------------------
    begin                : lun abr 26 2004
    copyright            : (C) 2004 by InfoSiAL S.L.
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
    this.ctx.interna_init();
  }
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna
{
  function oficial(context)
  {
    interna(context);
  }
}
//// OFICIAL /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration proveed */
//////////////////////////////////////////////////////////////////
//// PROVEED /////////////////////////////////////////////////////
class proveed extends oficial
{
  var curReciboDiv: FLSqlCursor;
  var importeInicial: Number;
  function proveed(context)
  {
    oficial(context);
  }
  function init()
  {
    return this.ctx.proveed_init();
  }
  function recordDelAfterpagosdevolprov()
  {
    return this.ctx.proveed_recordDelAfterpagosdevolprov();
  }
  function validateForm()
  {
    return this.ctx.proveed_validateForm();
  }
  function acceptedForm()
  {
    return this.ctx.proveed_acceptedForm();
  }
  function calculateField(fN: String)
  {
    return this.ctx.proveed_calculateField(fN);
  }
  function bufferChanged(fN: String)
  {
    return this.ctx.proveed_bufferChanged(fN);
  }
  function cambiarEstado()
  {
    return this.ctx.proveed_cambiarEstado();
  }
  function commonCalculateField(fN: String, cursor: FLSqlCursor)
  {
    return this.ctx.proveed_commonCalculateField(fN, cursor);
  }
  function copiarCampoReciboDiv(nombreCampo: String, cursor: FLSqlCursor, campoInformado: Array)
  {
    return this.ctx.proveed_copiarCampoReciboDiv(nombreCampo, cursor, campoInformado);
  }
  function tdbPagosDevolProv_bufferCommited()
  {
    return this.ctx.proveed_tdbPagosDevolProv_bufferCommited();
  }
  function divisionRecibo(cursor, importeInicial)
  {
    return this.ctx.proveed_divisionRecibo(cursor, importeInicial);
  }
}
//// PROVEED /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////
class head extends proveed
{
  function head(context)
  {
    proveed(context);
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
  function pub_divisionRecibo(cursor, importeInicial)
  {
    return this.divisionRecibo(cursor, importeInicial);
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
/**
\D Se almacena el valor del importe inicial del recibo
\end
\C Los campos --fechav--, --importe--, --codcuenta-- y --coddir-- estarán deshabilitados.
\end
\end */
function interna_init()
{
  var cursor = form.cursor();
  if (cursor.modeAccess() == cursor.Edit)
    this.iface.importeInicial = parseFloat(cursor.valueBuffer("importe"));
  connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");
  connect(form.child("tdbPagosDevolProv").cursor(), "cursorUpdated()", this, "iface.tdbPagosDevolProv_bufferCommited");
  if (cursor.modeAccess() == cursor.Edit)
    form.child("pushButtonAcceptContinue").close();
  this.iface.bufferChanged("codcuenta");
  this.iface.cambiarEstado();
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition proveed */
//////////////////////////////////////////////////////////////////
//// PROVEED /////////////////////////////////////////////////////
function proveed_init()
{
  this.iface.__init();
}

/** \C Se busca en la lista de pagos y devoluciones el último movimiento. Si es un pago, la factura originaria pasa a ser editable. Si es una devolución la factura no será editable. Si no quedan pagos/devoluciones, la factura originaria pasa a ser editable.
\end */
function proveed_recordDelAfterpagosdevolprov()
{
  var cursor = form.cursor();
  var idFactura = cursor.valueBuffer("idfactura");
  var idRecibo = cursor.valueBuffer("idrecibo");
  var curRecibos = new FLSqlCursor("recibosprov");

  curRecibos.select("idfactura = " + idFactura + " AND estado = 'Pagado' AND idrecibo <> " + idRecibo);
  if (curRecibos.size() == 0) {
    var curFactura = new FLSqlCursor("facturasprov");
    curFactura.select("idfactura = " + idFactura);
    var curPagoDevol = new FLSqlCursor("pagosdevolprov");
    curPagoDevol.select("idrecibo = " + idRecibo + " ORDER BY fecha, idpagodevol");
    if (curPagoDevol.last()) {
      curPagoDevol.setModeAccess(curPagoDevol.Browse);
      curPagoDevol.refreshBuffer();
      if (curFactura.first())
        if (curPagoDevol.valueBuffer("tipo") != "Pago")
          curFactura.setUnLock("editable", true);
        else
          curFactura.setUnLock("editable", false);
      curPagoDevol.setUnLock("editable", true);
    } else {
      if (curFactura.first())
        curFactura.setUnLock("editable", true);
    }
  }
}

/** \C
El importe del recibo debe ser menor o igual del que tenía anteriormente. Si es menor el recibo se fraccionará.
La fecha de vencimiento debe ser siempre igual o posterior a la fecha de emisión del recibo.
\end */
function proveed_validateForm()
{
  var util = new FLUtil();
  var cursor = form.cursor();

  var importeActual = parseFloat(cursor.valueBuffer("importe"));
  //    if ((this.iface.importeInicial >= 0 && this.iface.importeInicial < importeActual) || (this.iface.importeInicial < 0 && this.iface.importeInicial > importeActual)) {
  //        MessageBox.warning(util.translate("scripts",
  //            "El importe del recibo debe ser menor o igual del que tenía anteriormente.\nSi es menor el recibo se fraccionará."),
  //            MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
  //        form.child("fdbImporte").setFocus();
  //        return false;
  //    }

  if (util.daysTo(cursor.valueBuffer("fecha"), cursor.valueBuffer("fechav")) < 0) {
    MessageBox.warning(util.translate("scripts",
                                      "La fecha de vencimiento debe ser siempre igual o posterior\na la fecha de emisión del recibo."),
                       MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return false;
  }

  return true;
}

function proveed_acceptedForm()
{
  var _i = this.iface;
  var cursor = this.cursor();
  if (!_i.divisionRecibo(cursor, _i.importeInicial)) {
    return false;
  }
  /** \C
  Si el importe ha disminuido, genera un recibo complementario por la diferencia
  \end
  var importeActual = parseFloat(form.cursor().valueBuffer("importe"));
  if (importeActual != this.iface.importeInicial) {
    var cursor = form.cursor();
    var tasaConv = parseFloat(util.sqlSelect("facturasprov", "tasaconv", "idfactura = " + cursor.valueBuffer("idfactura")));

    cursor.setValueBuffer("importeeuros", importeActual * tasaConv);

    if (!this.iface.curReciboDiv) {
      this.iface.curReciboDiv = new FLSqlCursor("recibosprov");
    }
    this.iface.curReciboDiv.setModeAccess(this.iface.curReciboDiv.Insert);
    this.iface.curReciboDiv.refreshBuffer();

    var camposRecibo= util.nombreCampos("recibosprov");
    var totalCampos= camposRecibo[0];

    var campoInformado= [];
    for (var i= 1; i <= totalCampos; i++) {
      campoInformado[camposRecibo[i]] = false;
    }
    for (var i= 1; i <= totalCampos; i++) {
      if (!this.iface.copiarCampoReciboDiv(camposRecibo[i], cursor, campoInformado)) {
        return false;
      }
    }
    this.iface.curReciboDiv.commitBuffer();
  }
  */
}

function proveed_divisionRecibo(cursor, importeInicial)
{
  var util = new FLUtil();

  /** \C
  Si el importe ha disminuido, genera un recibo complementario por la diferencia
  \end */
  var importeActual = parseFloat(cursor.valueBuffer("importe"));
  importeActual = isNaN(importeActual) ? 0 : importeActual;
  importeInicial = isNaN(importeInicial) ? 0 : importeInicial;
  var nuevoImporte;
  if (AQUtil.roundFieldValue(importeActual, "recibosprov", "importe") != AQUtil.roundFieldValue(importeInicial, "recibosprov", "importe")) {
    var tasaConv = parseFloat(util.sqlSelect("facturasprov", "tasaconv", "idfactura = " + cursor.valueBuffer("idfactura")));

    cursor.setValueBuffer("importeeuros", importeActual * tasaConv);

    if (!this.iface.curReciboDiv) {
      this.iface.curReciboDiv = new FLSqlCursor("recibosprov");
    }
    this.iface.curReciboDiv.setModeAccess(this.iface.curReciboDiv.Insert);
    this.iface.curReciboDiv.refreshBuffer();

    var camposRecibo = util.nombreCampos("recibosprov");
    var totalCampos = camposRecibo[0];

    var campoInformado = [];
    for (var i = 1; i <= totalCampos; i++) {
      campoInformado[camposRecibo[i]] = false;
    }
    nuevoImporte = importeInicial - parseFloat(cursor.valueBuffer("importe"));
    this.iface.curReciboDiv.setValueBuffer("importe", AQUtil.roundFieldValue(nuevoImporte, "recibosprov", "importe"));
    campoInformado["importe"] = true;
    for (var i = 1; i <= totalCampos; i++) {
      if (!this.iface.copiarCampoReciboDiv(camposRecibo[i], cursor, campoInformado)) {
        return false;
      }
    }
    if (!this.iface.curReciboDiv.commitBuffer()) {
      return false;
    }
  }
  return true;
}

function proveed_copiarCampoReciboDiv(nombreCampo, cursor, campoInformado)
{
  var util = new FLUtil;

  if (campoInformado[nombreCampo]) {
    return true;
  }
  var nulo = false;

  switch (nombreCampo) {
    case "idrecibo": {
      return true;
      break;
    }
    case "numero": {
      valor = parseInt(util.sqlSelect("recibosprov", "numero", "idfactura = " + cursor.valueBuffer("idfactura") + " ORDER BY numero DESC")) + 1;
      break;
    }
    /*
    case "importe": {
      valor = this.iface.importeInicial - parseFloat(cursor.valueBuffer("importe"));
      break;
    }
    */
    case "importeeuros": {
      if (!campoInformado["importe"]) {
        if (!this.iface.copiarCampoReciboDiv("importe", cursor, campoInformado)) {
          return false;
        }
      }
      var tasaConv = parseFloat(util.sqlSelect("facturasprov", "tasaconv", "idfactura = " + cursor.valueBuffer("idfactura")));
      valor = this.iface.curReciboDiv.valueBuffer("importe") * tasaConv;
      break;
    }
    case "codigo": {
      var codFactura = util.sqlSelect("facturasprov", "codigo", "idfactura = " + cursor.valueBuffer("idfactura"));
      if (!campoInformado["numero"]) {
        if (!this.iface.copiarCampoReciboDiv("numero", cursor, campoInformado)) {
          return false;
        }
      }
      //      var numRecibo= parseInt(util.sqlSelect("recibosprov", "numero", "idfactura = " + cursor.valueBuffer("idfactura") + " ORDER BY numero DESC")) + 1;
      valor = codFactura + "-" + flfacturac.iface.pub_cerosIzquierda(this.iface.curReciboDiv.valueBuffer("numero"), 2);
      break;
    }
    case "estado": {
      valor = "Emitido";
      break;
    }
    case "fechapago":
    case "codcuentapagoprov": {
      nulo = true;
      break;
    }
    case "texto": {
      if (!campoInformado["coddivisa"]) {
        if (!this.iface.copiarCampoReciboDiv("coddivisa", cursor, campoInformado)) {
          return false;
        }
      }
      if (!campoInformado["importe"]) {
        if (!this.iface.copiarCampoReciboDiv("importe", cursor, campoInformado)) {
          return false;
        }
      }
      var moneda = util.sqlSelect("divisas", "descripcion", "coddivisa = '" + cursor.valueBuffer("coddivisa") + "'");
      valor = util.enLetraMoneda(this.iface.curReciboDiv.valueBuffer("importe"), moneda);
      break;
    }
    default: {
      if (cursor.isNull(nombreCampo)) {
        nulo = true;
      } else {
        valor = cursor.valueBuffer(nombreCampo);
      }
    }
  }
  if (nulo) {
    this.iface.curReciboDiv.setNull(nombreCampo);
  } else {
    this.iface.curReciboDiv.setValueBuffer(nombreCampo, valor);
  }
  campoInformado[nombreCampo] = true;

  return true;
}

function proveed_calculateField(fN: String)
{
  var util = new FLUtil();
  var cursor = form.cursor();
  var valor: String;

  valor = this.iface.commonCalculateField(fN, cursor);

  return valor;
}

function proveed_bufferChanged(fN: String)
{
  if (fN == "importe") {
    form.child("fdbTexto").setValue(this.iface.calculateField("texto"));
    this.child("gbxPagDev").setDisabled(true);
  }

  /** \C
  El --dc-- de la cuenta bancaria se calcula automáticamente en base al resto de valores de la cuenta
  \end */
  if (fN == "codcuenta" || fN == "ctaentidad" || fN == "ctaagencia" || fN == "cuenta")
    form.child("fdbDc").setValue(this.iface.calculateField("dc"));
}

/** \D
Cambia el valor del estado del recibo entre Emitido, Cobrado y Devuelto
\end */
function proveed_cambiarEstado()
{
  var estado = this.iface.calculateField("estado");
  this.child("fdbEstado").setValue(estado);
  if (estado != "Emitido")
    this.child("fdbImporte").setDisabled(true);
  else
    this.child("fdbImporte").setDisabled(false);
}

function proveed_commonCalculateField(fN: String, cursor: FLSqlCursor)
{
  var util = new FLUtil();
  var valor: String;
  switch (fN) {
    case "estado": {
      valor = "Emitido";
      var curPagosDevol = new FLSqlCursor("pagosdevolprov");
      curPagosDevol.select("idrecibo = '" + cursor.valueBuffer("idrecibo") +
                           "' ORDER BY fecha DESC, idpagodevol DESC");
      if (curPagosDevol.first()) {
        curPagosDevol.setModeAccess(curPagosDevol.Browse);
        curPagosDevol.refreshBuffer();
        if (curPagosDevol.valueBuffer("tipo") == "Pago")
          valor = "Pagado";
        else
          valor = "Devuelto";
      }
      break;
    }
    case "texto": {
      var importe = parseFloat(cursor.valueBuffer("importe"));
      var moneda = util.sqlSelect("divisas", "descripcion", "coddivisa = '" + cursor.valueBuffer("coddivisa") + "'");
      valor = util.enLetraMoneda(importe, moneda);
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
    case "fechapago": {
      valor = util.sqlSelect("pagosdevolprov", "fecha", "idrecibo = " + cursor.valueBuffer("idrecibo") + " ORDER by idpagodevol DESC");
      if (!valor) valor = "NULL";
      break;
    }
    case "codcuentapagoprov": {
      if (cursor.valueBuffer("estado") != "Emitido") {
        valor = util.sqlSelect("pagosdevolprov", "codcuenta", "idrecibo = " + cursor.valueBuffer("idrecibo") + " ORDER by idpagodevol DESC");
      } else {
        valor = AQUtil.sqlSelect("formaspago p INNER JOIN facturasprov f ON p.codpago = f.codpago", "p.codcuenta", "f.idfactura = '" + cursor.valueBuffer("idfactura") + "'", "formaspago,facturasprov");
      }
      if (!valor) {
        valor = "";
      }
      break;
    }
  }
  return valor;
}

function proveed_tdbPagosDevolProv_bufferCommited()
{
  this.child("fdbFechaPago").setValue(this.iface.calculateField("fechapago"));
  this.child("fdbCodCuentaPagoProv").setValue(this.iface.calculateField("codcuentapagoprov"));
  this.iface.cambiarEstado();
}
//// PROVEED /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition ifaceCtx */
/////////////////////////////////////////////////////////////////
//// INTERFACE  /////////////////////////////////////////////////

//// INTERFACE  /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
