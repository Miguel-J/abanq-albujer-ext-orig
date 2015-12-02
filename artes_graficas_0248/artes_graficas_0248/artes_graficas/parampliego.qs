/***************************************************************************
                 parapmliego.qs  -  description
                             -------------------
    begin                : mar abr 02 2008
    copyright            : (C) 2008 by InfoSiAL S.L.
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
  function cargarDatos()
  {
    return this.ctx.oficial_cargarDatos();
  }
  function mostrarGrafico(nodoPliego: FLDomNode)
  {
    return this.ctx.oficial_mostrarGrafico(nodoPliego);
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
  this.iface.cargarDatos();

}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_cargarDatos()
{
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  var xmlParamPliego: FLDomDocument = new FLDomDocument;
  if (!xmlParamPliego.setContent(cursor.valueBuffer("xml"))) {
    MessageBox.warning(util.translate("scripts", "Error al cargar los datos del pliego"), MessageBox.Ok, MessageBox.NoButton);
    return;
  }
  debug(xmlParamPliego.toString(4));
  //  var xmlProceso:FLDomNode = xmlParamPliego.firstChild();
  debug(1);
  this.iface.mostrarGrafico(xmlParamPliego);
  debug(2);
  var nodoParam: FLDomNode = flfacturac.iface.pub_dameNodoXML(xmlParamPliego, "Parametros/TrabajosPliegoParam");
  debug(3);
  var eParam: FLDomElement = nodoParam.toElement();

  var texto: String = "";
  texto += util.translate("scripts", "Dimensiones: %1").arg(cursor.valueBuffer("anchopi") + "x" + cursor.valueBuffer("altopi"));
  texto += "\n";
  texto += "\n";
  texto += util.translate("scripts", "Trabajos: %1").arg(eParam.attribute("NumTrabajos"));
  texto += "\n";
  texto += util.translate("scripts", "Cortes: %1").arg(eParam.attribute("NumCortes"));
  texto += "\n";
  texto += "\n";
  texto += util.translate("scripts", "Margen superior: %1").arg(eParam.attribute("MargenSuperior"));
  texto += "\n";
  texto += util.translate("scripts", "Margen inferior: %1").arg(eParam.attribute("MargenInferior"));
  texto += "\n";
  texto += util.translate("scripts", "Margen izquierdo: %1").arg(eParam.attribute("MargenIzquierdo"));
  texto += "\n";
  texto += util.translate("scripts", "Margen derecho: %1").arg(eParam.attribute("MargenDerecho"));


  this.child("lblDatosPliego").text = texto;
}

function oficial_mostrarGrafico(nodoPliego: FLDomNode)
{
  var cursor: FLSqlCursor = this.cursor();
  var dimPI: String = cursor.valueBuffer("anchopi") + "x" + cursor.valueBuffer("altopi");

  var dimPix: Array = [];
  dimPix["x"] = 400;
  dimPix["y"] = 400;
  flfacturac.iface.pub_mostrarTrabajosPliego(this.child("lblDiagPliego"), nodoPliego, dimPI, dimPix);
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////