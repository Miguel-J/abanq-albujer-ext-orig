/***************************************************************************
                 t1_elementos.qs  -  description
                             -------------------
    begin                : lun sep 13 2010
    copyright            : (C) 2010 by InfoSiAL S.L.
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
  function tbnIncluyeCampo_clicked()
  {
    return this.ctx.oficial_tbnIncluyeCampo_clicked();
  }
  function incluirCampoTexto(campo: String): Boolean {
    return this.ctx.oficial_incluirCampoTexto(campo);
  }
  function tbnIncluyeCampoElemento_clicked()
  {
    return this.ctx.oficial_tbnIncluyeCampoElemento_clicked();
  }
  function incluirCampoTextoElemento(campo: String): Boolean {
    return this.ctx.oficial_incluirCampoTextoElemento(campo);
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
  var util: FLUtil = new FLUtil;
  connect(this.child("tbnIncluyeCampo"), "clicked()", this, "iface.tbnIncluyeCampo_clicked");
  connect(this.child("tbnIncluyeCampoElemento"), "clicked()", this, "iface.tbnIncluyeCampoElemento_clicked");
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_tbnIncluyeCampo_clicked()
{
  var util: FLUtil = new FLUtil;
  if (!formt1_principal.iface.aDatosElemento_) {
    return false;
  }
  var aIndiceDE: Array = formt1_principal.iface.aDatosElemento_["i"];
  //  var aDatos:Array = formt1_principal.iface.aDatosElemento_;

  var idOpcion: Number = flfactppal.iface.elegirOpcion(aIndiceDE, util.translate("scripts", "Seleccione campo"));
  if (idOpcion < 0) {
    return false;
  }
  this.iface.incluirCampoTexto(aIndiceDE[idOpcion]);
}

function oficial_incluirCampoTexto(campo: String): Boolean {
  var cursor: FLSqlCursor = this.cursor();
  var contenido: String = cursor.valueBuffer("xmlpic");
  if (!contenido || contenido == "")
  {
    contenido = "<Picture/>";
  }
  var xmlPic: FLDomDocument = new FLDomDocument();
  if (!xmlPic.setContent(contenido))
  {
    return false;
  }
  var nodoPic: FLDomNode = xmlPic.firstChild();
  var eText: FLDomElement = xmlPic.createElement("Text");
  eText.setAttribute("x", "0%");
  eText.setAttribute("y", "50%");
  eText.setAttribute("width", "100%");
  eText.setAttribute("height", "50%");
  eText.setAttribute("halignment", "AlignHCenter");
  eText.setAttribute("valignment", "AlignVCenter");
  eText.setAttribute("style", "normal");
  nodoPic.appendChild(eText);
  var tTexto: FLDomNode = xmlPic.createTextNode(campo)
  eText.appendChild(tTexto);
  cursor.setValueBuffer("xmlpic", xmlPic.toString(4));
}

function oficial_tbnIncluyeCampoElemento_clicked()
{
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  if (!formt1_principal.iface.aDatosElemento_) {
    return false;
  }

  var aElemento: Array = formt1_principal.iface.pub_dameElementoActual();
  if (!aElemento) {
    return false;
  }
  debug("Tipo " + aElemento["tipo"]);
  debug("Relacion " + cursor.valueBuffer("relacion"));
  var aDatos: Array = formt1_principal.iface.dameArrayCamposElementoRel(aElemento["tipo"], cursor.valueBuffer("relacion"));
  if (!aDatos) {
    return false;
  }
  debug(aDatos["i"].length);
  var idOpcion: Number = flfactppal.iface.elegirOpcion(aDatos["i"], util.translate("scripts", "Seleccione campo"));
  if (idOpcion < 0) {
    return false;
  }
  this.iface.incluirCampoTextoElemento(aDatos["i"][idOpcion]);
}

function oficial_incluirCampoTextoElemento(campo: String): Boolean {
  var cursor: FLSqlCursor = this.cursor();
  var contenido: String = cursor.valueBuffer("xmlpicelemento");
  if (!contenido || contenido == "")
  {
    contenido = "<Picture/>";
  }
  var xmlPic: FLDomDocument = new FLDomDocument();
  if (!xmlPic.setContent(contenido))
  {
    return false;
  }
  var nodoPic: FLDomNode = xmlPic.firstChild();
  var eText: FLDomElement = xmlPic.createElement("Text");
  eText.setAttribute("x", "0%");
  eText.setAttribute("y", "50%");
  eText.setAttribute("width", "100%");
  eText.setAttribute("height", "50%");
  eText.setAttribute("halignment", "AlignHCenter");
  eText.setAttribute("valignment", "AlignVCenter");
  eText.setAttribute("style", "normal");
  nodoPic.appendChild(eText);
  var tTexto: FLDomNode = xmlPic.createTextNode(campo)
  eText.appendChild(tTexto);
  cursor.setValueBuffer("xmlpicelemento", xmlPic.toString(4));
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
