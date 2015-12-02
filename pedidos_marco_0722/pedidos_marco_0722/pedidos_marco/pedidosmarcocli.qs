/***************************************************************************
                 pedidosmarcocli.qs  -  description
                             -------------------
    begin                : vie nov 18 2011
    copyright            : (C) 2011 by InfoSiAL S.L.
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
////////////////////////////////////////////////////////////////////////////
//// DECLARACION ///////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

/** @class_declaration interna */
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
  function calculateField(fN)
  {
    return this.ctx.interna_calculateField(fN);
  }
  function validateForm()
  {
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
  function bufferChanged(fN)
  {
    return this.ctx.oficial_bufferChanged(fN);
  }
  function calcularTotales()
  {
    return this.ctx.oficial_calcularTotales();
  }
  function commonCalculateField(fN, cursor)
  {
    return this.ctx.oficial_commonCalculateField(fN, cursor);
  }
  function validarFechas()
  {
    return this.ctx.oficial_validarFechas();
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

  connect(this.cursor(), "bufferChanged(QString)", _i, "bufferChanged");
  connect(this.child("tdbLineasPedidoMarco").cursor(), "bufferCommited()", _i, "calcularTotales()");
}

/** \U
Los valores de los campos de este formulario se calculan en el script asociado al formulario maestro
\end */
function interna_calculateField(fN)
{
  var _i = this.iface;
  var cursor = this.cursor();
  return _i.commonCalculateField(fN, cursor);
}

function interna_validateForm()
{
  var _i = this.iface;
  var cursor = this.cursor();

  if (!_i.validarFechas()) {
    return false;
  }

  return true;
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_bufferChanged(fN)
{
  var _i = this.iface;
  var cursor = this.cursor();
  switch (fN) {
    case "neto": {
      break;
    }
  }
}

function oficial_calcularTotales()
{
  var _i = this.iface;
  this.child("fdbTotal").setValue(_i.calculateField("total"));
  this.child("fdbTotalPendiente").setValue(_i.calculateField("totalpendiente"));
  this.child("fdbTotalPedido").setValue(_i.calculateField("totalpedido"));
}

function oficial_commonCalculateField(fN, cursor)
{
  var valor;
  switch (fN) {
    case "total": {
      valor = AQUtil.sqlSelect("lineaspedidomarcocli", "SUM(importetotal)", "codpedidomarco = '" + cursor.valueBuffer("codpedidomarco") + "'");
      valor = isNaN(valor) ? 0 : valor;
      break;
    }
    case "totalpendiente": {
      valor = AQUtil.sqlSelect("lineaspedidomarcocli", "SUM(importependiente)", "codpedidomarco = '" + cursor.valueBuffer("codpedidomarco") + "'");
      valor = isNaN(valor) ? 0 : valor;
      break;
    }
    case "totalpedido": {
      valor = AQUtil.sqlSelect("lineaspedidomarcocli", "SUM(importepedido)", "codpedidomarco = '" + cursor.valueBuffer("codpedidomarco") + "'");
      valor = isNaN(valor) ? 0 : valor;
      break;
    }
  }
  return valor;
}

function oficial_validarFechas()
{
  var _i = this.iface;
  var cursor = this.cursor();

  if (cursor.isNull("validezdesde") || cursor.isNull("validezhasta")) {
    MessageBox.warning(sys.translate("Debe indicar el intervalo de fechas"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton, "AbanQ");
    return false;
  }
  var fD = cursor.valueBuffer("validezdesde");
  var fH = cursor.valueBuffer("validezhasta");
  if (AQUtil.daysTo(fD, fH) < 0) {
    MessageBox.warning(sys.translate("La fecha hasta no puede ser inferior a la fecha desde"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton, "AbanQ");
    return false;
  }

  var codPedidoMarco = cursor.valueBuffer("codpedidomarco");
  var codCliente = cursor.valueBuffer("codcliente");
  if (cursor.valueBuffer("activo")) {
    var qLineas = new FLSqlQuery;
    qLineas.setSelect("referencia");
    qLineas.setFrom("lineaspedidomarcocli");
    qLineas.setWhere("codpedidomarco = '" + codPedidoMarco + "'");
    qLineas.setForwardOnly(true);
    if (!qLineas.exec()) {
      return false;
    }
    var referencia, codPM;
    while (qLineas.next()) {
      referencia = qLineas.value("referencia");
      debug(" select  pm.codpedidomarco from pedidosmarcocli pm INNER JOIN lineaspedidomarcocli lpm ON pm.codpedidomarco = lpm.codpedidomarco where lpm.referencia = '" + referencia + "' AND codcliente = '" + codCliente + "' AND activo AND pm.codpedidomarco <> '" + codPedidoMarco + "' AND validezdesde < '" + fH + "' AND validezhasta > '" + fD + "'");
      codPM = AQUtil.sqlSelect("pedidosmarcocli pm INNER JOIN lineaspedidomarcocli lpm ON pm.codpedidomarco = lpm.codpedidomarco", "pm.codpedidomarco", "lpm.referencia = '" + referencia + "' AND codcliente = '" + codCliente + "' AND activo AND pm.codpedidomarco <> '" + codPedidoMarco + "' AND validezdesde < '" + fH + "' AND validezhasta > '" + fD + "'", "pedidosmarcocli,lineaspedidomarcocli");
      if (codPM) {
        MessageBox.warning(sys.translate("Ya existe un pedido marco activo (%1)  para el mismo cliente que define el precio del artículo %2 en un intervalo de fechas que se solapa con el actual").arg(codPM).arg(referencia), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton, "AbanQ");
        return false;
      }
    }
  }
  return true && true;
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
