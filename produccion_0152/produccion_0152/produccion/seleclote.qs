/**************************************************************************
                 seleclote.qs  -  description
                             -------------------
    begin                : mar mov 27 2007
    copyright            : (C) 2007 by InfoSiAL S.L.
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
  var tbnAceptar: Object;
  var tbnCancelar: Object;
  function oficial(context)
  {
    interna(context);
  }
  function aceptarFormulario()
  {
    return this.ctx.oficial_aceptarFormulario();
  }
  function cancelarFormulario()
  {
    return this.ctx.oficial_cancelarFormulario();
  }
  function filtrar()
  {
    return this.ctx.oficial_filtrar();
  }
  function bufferChanged(fN)
  {
    return this.ctx.oficial_bufferChanged(fN);
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
  var cursor = this.cursor();
  _i.tbnAceptar = this.child("pushButtonAccept");
  disconnect(_i.tbnAceptar, "clicked()", this.obj(), "accept()");
  connect(_i.tbnAceptar, "clicked()", _i, "aceptarFormulario");
  connect(cursor, "bufferChanged(QString)", _i, "bufferChanged");

  connect(this, "formReady()", _i, "filtrar");
}

function interna_calculateField(fN)
{
  var _i = this.iface;
  var cursor = this.cursor();
  var valor;
  switch (fN) {
    case "cantidad": {
      var canPte = cursor.valueBuffer("canlote");
      var canDisponible = AQUtil.sqlSelect("lotesstock", "candisponible", "codlote = '" + cursor.valueBuffer("codlote") + "'");
      canDisponible = isNaN(canDisponible) ? 0 : canDisponible;
      valor = (canPte > canDisponible) ? canDisponible : canPte;
      break;
    }
  }
  debug("valor de " + fN + " es " + valor);
  return valor;
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_filtrar()
{
  var cursor = this.cursor();
  if (this.child("fdbCodLote")) {
    this.child("fdbCodLote").setFilter("referencia = '" + cursor.valueBuffer("referencia") + "' AND candisponible > 0");
  }
}

function oficial_aceptarFormulario()
{
  var cursor = this.cursor();
  var codLote = cursor.valueBuffer("codlote");
  var referencia = cursor.valueBuffer("referencia");
  if (!codLote || codLote == "") {
    MessageBox.warning(sys.translate("Debe establecer un código de Lote"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton , "AbanQ");
    return false;
  }
  if (!AQUtil.sqlSelect("lotesstock", "codlote", "codlote = '" + codLote + "' AND referencia = '" + referencia + "'")) {
    MessageBox.warning(sys.translate("El lote establecido no existe para el artículo %1").arg(referencia), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton, "AbanQ");
    return false;
  }
  var canLote = parseFloat(cursor.valueBuffer("canlote"));
  var resto = parseFloat(cursor.valueBuffer("resto"));
  if (canLote > resto) {
    var res = MessageBox.warning(sys.translate("La cantidad total de los lotes asignados es mayor que la cantidad de la línea de pedido.\n¿Desea continuar?"), MessageBox.Yes, MessageBox.No, MessageBox.NoButton, "AbanQ");
    if (res != MessageBox.Yes) {
      return false;
    }
  }
  this.accept();
}

function oficial_cancelarFormulario()
{
  this.child("pushButtonCancel").animateClick();
}

function oficial_bufferChanged(fN)
{
  var _i = this.iface;
  switch (fN) {
    case "codlote": {
      sys.setObjText(this, "fdbCantidad", _i.calculateField("cantidad"));
      break;
    }
  }
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
