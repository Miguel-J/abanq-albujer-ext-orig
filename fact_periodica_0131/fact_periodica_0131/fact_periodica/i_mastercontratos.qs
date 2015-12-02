/***************************************************************************
                 i_masterclientes.qs  -  description
                             -------------------
    begin                : mar jun 27 2006
    copyright            : (C) 2006 by InfoSiAL S.L.
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
  function lanzar()
  {
    return this.ctx.oficial_lanzar();
  }
  function obtenerParamInforme(): Array {
    return this.ctx.oficial_obtenerParamInforme();
  }
  function obtenerOrden(nivel: Number, cursor: FLSqlCursor): String {
    return this.ctx.oficial_obtenerOrden(nivel, cursor);
  }
  function mostrarFiltro(nodo: FLDomNode)
  {
    return this.ctx.oficial_mostrarFiltro(nodo);
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
  connect(this.child("toolButtonPrint"), "clicked()", this, "iface.lanzar()");
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_lanzar()
{
  var cursor: FLSqlCursor = this.cursor();

  var pI = this.iface.obtenerParamInforme();
  if (!pI)
    return;

  flfactinfo.iface.pub_lanzarInforme(cursor, pI.nombreInforme, pI.orderBy, pI.groupBy, pI.etiquetas, pI.impDirecta, pI.whereFijo, pI.nombreReport);
}

/** \D Obtiene un array con los parámetros necesarios para establecer el informe
@return array de parámetros o false si hay error
\end */
function oficial_obtenerParamInforme(): Array {
  var paramInforme: Array = [];
  paramInforme["nombreInforme"] = false;
  paramInforme["orderBy"] = "";
  paramInforme["groupBy"] = false;
  paramInforme["etiquetas"] = false;
  paramInforme["impDirecta"] = false;
  paramInforme["whereFijo"] = false;
  paramInforme["nombreReport"] = false;
  paramInforme["numCopias"] = false;

  var cursor: FLSqlCursor = this.cursor();
  var seleccion: String = cursor.valueBuffer("id");
  if (!seleccion)
    return;

  paramInforme.nombreInforme = cursor.action();

  paramInforme.whereFijo = "";

  var orderBy: String = "";
  var o: String = "";

  if (paramInforme.nombreInforme != "i_contratos")
  {
    return false;
  }

  if (cursor.valueBuffer("codintervalo"))
  {
    var intervalo: Array = [];
    intervalo = flfactppal.iface.pub_calcularIntervalo(cursor.valueBuffer("codintervalo"));
    cursor.setValueBuffer("d_contratos_fechainicio", intervalo.desde);
    cursor.setValueBuffer("h_contratos_fechainicio", intervalo.hasta);
  }

  if (paramInforme.orderBy && orderBy)
    paramInforme.orderBy += ", ";

  paramInforme.orderBy += orderBy;
  return paramInforme;
}

function oficial_mostrarFiltro(nodo: FLDomNode)
{
  var util: FLUtil = new FLUtil();
  var cursor = this.cursor();
  var valor = "";

  if (cursor.valueBuffer("i_contratos_codigo")) {
    valor += "Núm. Contrato: " + cursor.valueBuffer("i_contratos_codigo") + "\n";
  }

  if (cursor.valueBuffer("i_contratos_periodopago")) {
    valor += "Periodo: " + cursor.valueBuffer("i_contratos_periodopago") + "\n";
  }

  if (cursor.valueBuffer("i_contratos_tipocontrato")) {
    valor += "Tipo: " + cursor.valueBuffer("i_contratos_tipocontrato") + "\n";
  }

  if (cursor.valueBuffer("i_contratos_estado")) {
    valor += "Estado: " + cursor.valueBuffer("i_contratos_estado") + "\n";
  }

  if (cursor.valueBuffer("d_contratos_fechainicio")) {
    valor += "Desde fecha: " + util.dateAMDtoDMA(cursor.valueBuffer("d_contratos_fechainicio")) + "\n";
  }

  if (cursor.valueBuffer("h_contratos_fechainicio")) {
    valor += "Hasta fecha: " + util.dateAMDtoDMA(cursor.valueBuffer("h_contratos_fechainicio")) + "\n";
  }

  if (cursor.valueBuffer("d_contratos_codcliente")) {
    valor += "Desde cliente: " + cursor.valueBuffer("d_contratos_codcliente") + "\n";
  }

  if (cursor.valueBuffer("h_contratos_codcliente")) {
    valor += "Hasta cliente: " + cursor.valueBuffer("h_contratos_codcliente") + "\n";
  }

  if (cursor.valueBuffer("i_contratos_referencia")) {
    valor += "Referencia: " + cursor.valueBuffer("i_contratos_referencia") + "\n";
  }

  if (valor == "")
    valor = "Todos los contratos";

  return valor;
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
////////////////////////////////////////////////////////////////