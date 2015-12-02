/***************************************************************************
                 bonosgym.qs  -  description
                             -------------------
    begin                : lun ago 10 2009
    copyright            : (C) 2009 by InfoSiAL S.L.
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
  function calculateField(fN: String): String {
    return this.ctx.interna_calculateField(fN);
  }
  function validateForm(): Boolean {
    return this.ctx.interna_validateForm();
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
  function bufferChanged(fN: String)
  {
    return this.ctx.oficial_bufferChanged(fN);
  }
  function commonCalculateField(fN: String, cursor: FLSqlCursor): String {
    return this.ctx.oficial_commonCalculateField(fN, cursor);
  }
  function habilitarPorFacturar()
  {
    return this.ctx.oficial_habilitarPorFacturar();
  }
  function validarFormaPago(): Boolean {
    return this.ctx.oficial_validarFormaPago();
  }
  function validarTipoContrato(): Boolean {
    return this.ctx.oficial_validarTipoContrato();
  }
  function validarBonoRegalo(): Boolean {
    return this.ctx.oficial_validarBonoRegalo();
  }
  function datosFactura()
  {
    return this.ctx.oficial_datosFactura();
  }
  function habilitarPorTipo()
  {
    return this.ctx.oficial_habilitarPorTipo();
  }
  function dameOrderColsSesiones(): Array {
    return this.ctx.oficial_dameOrderColsSesiones();
  }
  function totalizarSesiones()
  {
    return this.ctx.oficial_totalizarSesiones();
  }
  function habilitarPorRegalo()
  {
    return this.ctx.oficial_habilitarPorRegalo();
  }
  function formReady()
  {
    return this.ctx.oficial_formReady();
  }
  function desconectar()
  {
    return this.ctx.oficial_desconectar();
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
  function pub_commonCalculateField(fN: String, cursor: FLSqlCursor): String {
    return this.commonCalculateField(fN, cursor);
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
/** \C Si en la tabla de direcciones de clientes no hay todavía ninguna dirección asociada al cliente, la primera dirección introducida se tomará como dirección de facturación y dirección de envío
\end */
function interna_init()
{
  var cursor: FLSqlCursor = this.cursor();

  this.child("fdbReferencia").setFilter("codfamilia = 'BONO'");

  this.iface.habilitarPorTipo();
  this.iface.habilitarPorFacturar();
  this.iface.habilitarPorRegalo();

  switch (cursor.modeAccess()) {
    case cursor.Insert: {
      debug("oficial_formReady I");
      var curRel: FLSqlCursor = cursor.cursorRelation();
      if (curRel && curRel.table() == "clientes") {
        this.child("fdbNombreCliente").setValue(curRel.valueBuffer("nombre"));
        this.child("fdbCodClienteFact").setValue(curRel.valueBuffer("codcliente"));
      }
      break;
    }
    case cursor.Edit: {
      this.child("fdbTipo").setDisabled(true);
      break;
    }
  }

  connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");
  connect(this.child("tdbSesionesAlumno").cursor(), "bufferCommited()", this, "iface.totalizarSesiones");
  connect(this, "closed()", this, "iface.desconectar");

  var orderColsSesiones: Array = this.iface.dameOrderColsSesiones();
  this.child("tdbSesionesAlumno").setOrderCols(orderColsSesiones);
  this.child("tdbSesionesAlumno").refresh();
}

function interna_calculateField(fN: String): String {
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();
  var valor: String;

  valor = this.iface.commonCalculateField(fN, cursor);

  return valor;
}

function interna_validateForm(): Boolean {
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  if (!this.iface.validarFormaPago())
  {
    return false;
  }
  if (!this.iface.validarTipoContrato())
  {
    return false;
  }
  if (!this.iface.validarBonoRegalo())
  {
    return false;
  }

  return true;
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_bufferChanged(fN: String)
{
  var util: FLUtil = new FLUtil();
  var cursor: FLSqlCursor = this.cursor();

  switch (fN) {
    case "cansesionescon":
    case "cansesiones": {
      this.child("fdbCanSesionesDisp").setValue(this.iface.calculateField("cansesionesdisp"));
      break;
    }
    case "facturar": {
      this.iface.habilitarPorFacturar();
      this.iface.datosFactura();
      break;
    }
    case "referencia": {
      this.child("fdbPvp").setValue(this.iface.calculateField("pvp"));
      this.child("fdbFechaCaducidad").setValue(this.iface.calculateField("fechacaducidad"));
      break;
    }
    case "tipo": {
      this.iface.habilitarPorTipo();
      break;
    }
    case "bonoregalo": {
      this.iface.habilitarPorRegalo();
      if (!cursor.valueBuffer("bonoregalo")) {
        this.child("fdbCodClienteFact").setValue(cursor.valueBuffer("codcliente"));
      }
      break;
    }
    case "codcliente": {
      if (!cursor.valueBuffer("bonoregalo")) {
        this.child("fdbCodClienteFact").setValue(cursor.valueBuffer("codcliente"));
      }
      break;
    }
  }
}

function oficial_habilitarPorRegalo()
{
  var cursor: FLSqlCursor = this.cursor();
  if (cursor.valueBuffer("bonoregalo")) {
    this.child("tbwBono").setTabEnabled("bonoregalo", true);
    this.child("fdbCodClienteFact").setDisabled(false);
  } else {
    this.child("tbwBono").setTabEnabled("bonoregalo", false);
    this.child("fdbCodClienteFact").setDisabled(true);
  }
}

function oficial_commonCalculateField(fN: String, cursor: FLSqlCursor): String {
  debug("Calculando " + fN);
  var util: FLUtil = new FLUtil;
  var valor: String;
  switch (fN)
  {
    case "cansesionesdisp": {
      var canSesiones: Number = parseInt(cursor.valueBuffer("cansesiones"));
      if (isNaN(canSesiones) || canSesiones == 0) {
        valor = 0;
      } else {
        valor = canSesiones - parseInt(cursor.valueBuffer("cansesionescon"));
      }
      break;
    }
    case "cansesionescon": {
      valor = parseInt(util.sqlSelect("fo_sesionesalumno", "COUNT(*)", "codbono = '" + cursor.valueBuffer("codbono") + "' AND asiste = true"));
      debug("valor = " + valor);
      if (isNaN(valor)) {
        valor = 0;
      }
      break;
    }
    case "pvp": {
      valor = parseFloat(util.sqlSelect("articulos", "pvp", "referencia = '" + cursor.valueBuffer("referencia") + "'"));
      if (isNaN(valor)) {
        valor = 0;
      }
      break;
    }
    case "fechacaducidad": {
      var mesesCaducidad: Number = parseInt(util.sqlSelect("articulos", "mesescaducidad", "referencia = '" + cursor.valueBuffer("referencia") + "'"));
      if (isNaN(mesesCaducidad)) {
        mesesCaducidad = 0;
      }
      debug("meses = " + mesesCaducidad);
      if (mesesCaducidad == 0) {
        valor = "NULL";
      } else {
        var fechaCompra: String = cursor.valueBuffer("fechacompra");
        fechaCompra = fechaCompra.toString();
        valor = util.addMonths(fechaCompra, mesesCaducidad);
      }
      break;
    }
  }
  debug("Fin valor = " + valor);
  return valor;
}

/** \D Habilita los datos de la factura dependiendo del indicador
\end */
function oficial_habilitarPorFacturar()
{
  var cursor: FLSqlCursor = this.cursor();
  if (cursor.valueBuffer("facturar")) {
    this.child("gbxFactura").setEnabled(true);
  } else {
    this.child("gbxFactura").setEnabled(false);
  }
}

/** \D Establece los datos por defecto de la factura o los borra dependiendo del indicador
\end */
function oficial_datosFactura()
{
  var cursor: FLSqlCursor = this.cursor();
  if (!cursor.valueBuffer("facturar")) {
    this.child("fdbPvp").setValue("");
    this.child("fdbCodPago").setValue("");
  } else {
    this.child("fdbPvp").setValue(this.iface.calculateField("pvp"));
  }
}

/** \C Si el tipo es Bono y va a facturarlo debe indicar la forma de pago
\end */
function oficial_validarFormaPago(): Boolean {
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();
  var codPago: String = cursor.valueBuffer("codpago");

  if (cursor.valueBuffer("tipo") == "Bono" && cursor.valueBuffer("facturar") && (!codPago || codPago == ""))
  {
    MessageBox.warning(util.translate("scripts", "Si el tipo es Bono y va a facturarlo debe indicar la forma de pago"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  return true;
}

/** \C Si el tipo es suscripción debe indicar el tipo de contrato
\end */
function oficial_validarTipoContrato(): Boolean {
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();
  var codTipoContrato: String = cursor.valueBuffer("codtipocontrato");
  if (cursor.valueBuffer("tipo") == "Suscripción" && (!codTipoContrato || codTipoContrato == ""))
  {
    MessageBox.warning(util.translate("scripts", "Si el tipo es suscripción debe indicar el tipo de contrato"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  return true;
}

/** \C Si el bono es regalado debe establecerse el cliente de facturación
\end */
function oficial_validarBonoRegalo(): Boolean {
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();
  var codClienteFact: String = cursor.valueBuffer("codclientefact");
  if (cursor.valueBuffer("bonoregalo") && (!codClienteFact || codClienteFact == ""))
  {
    MessageBox.warning(util.translate("scripts", "Si el bono es regalado debe establecerse el cliente de facturación"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  return true;
}

function oficial_habilitarPorTipo()
{
  var cursor: FLSqlCursor = this.cursor();
  if (cursor.valueBuffer("tipo") == "Bono") {
    this.child("gbxBono").show();
    this.child("gbxSuscripcion").close();
    this.child("tbwBono").setTabEnabled("contrato", false);
    this.child("tdbFacturasCli").setFilter("idfactura = " + cursor.valueBuffer("idfactura"));
    this.child("tdbFacturasCli").refresh();
    this.child("tdbRecibosCli").setFilter("idfactura = " + cursor.valueBuffer("idfactura"));
    this.child("tdbRecibosCli").refresh();
  } else {
    this.child("gbxBono").close();
    this.child("gbxSuscripcion").show();
    this.child("tbwBono").setTabEnabled("contrato", true);
    this.child("tdbFacturasCli").setFilter("idfactura IN (SELECT idfactura FROM periodoscontratos WHERE codcontrato = '" + cursor.valueBuffer("codcontrato") + "')");
    this.child("tdbFacturasCli").refresh();
    this.child("tdbRecibosCli").setFilter("idfactura IN (SELECT idfactura FROM periodoscontratos WHERE codcontrato = '" + cursor.valueBuffer("codcontrato") + "')");
    this.child("tdbRecibosCli").refresh();
  }
}

function oficial_dameOrderColsSesiones(): Array {
  var campos: Array = ["codigo", "fecha", "codhorario", "horadesde", "horahasta", "estado", "asiste"];
  return campos;
}

function oficial_totalizarSesiones()
{
  this.child("fdbCanSesionesCon").setValue(this.iface.calculateField("cansesionescon"));
}

function oficial_formReady()
{
  var cursor: FLSqlCursor = this.cursor();
}

function oficial_desconectar()
{
  var cursor: FLSqlCursor = this.cursor();
  connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
