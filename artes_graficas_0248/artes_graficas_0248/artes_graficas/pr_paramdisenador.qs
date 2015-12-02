/***************************************************************************
                 pr_paramdisenador.qs  -  description
                             -------------------
    begin                : lun may 05 2008
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
  function cargarDatos()
  {
    return this.ctx.oficial_cargarDatos();
  }
  function bufferChanged(fN: String)
  {
    return this.ctx.oficial_bufferChanged(fN);
  }
  function guardarDatos(): Boolean {
    return this.ctx.oficial_guardarDatos();
  }
  function tbnOk_clicked()
  {
    return this.ctx.oficial_tbnOk_clicked();
  }
  function validarDatos(): Boolean {
    return this.ctx.oficial_validarDatos();
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
  var cursor: FLSqlCursor = this.cursor();
  //  this.iface.cargarDatos();

  connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");
  //  connect(this.child("tbnOk"), "clicked()", this, "iface.tbnOk_clicked");
  //this.child("pushButtonAccept").enabled = false;

  switch (cursor.modeAccess()) {
    case cursor.Insert: {
      cursor.setValueBuffer("codtipocentro", formRecordpr_tiposcentrocoste.cursor().valueBuffer("codtipocentro"));
      cursor.setValueBuffer("idusuario", "yo");
      break;
    }
  }
}

function interna_validateForm(): Boolean {
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  //  var xmlDocParam:FLDomDocument = this.iface.guardarDatos();
  //  if (!xmlDocParam) {
  //    MessageBox.warning(util.translate("scripts", "Error al guardar los parámetros a formato xml"), MessageBox.Ok, MessageBox.NoButton);
  //    return false;
  //  }
  //  cursor.setValueBuffer("xml", xmlDocParam.toString());
  cursor.setValueBuffer("xml", "");

  return true;
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_cargarDatos()
{
  var cursor: FLSqlCursor = this.cursor();
  var contenido: String = cursor.valueBuffer("xml");

  var xmlParam: FLDomDocument = new FLDomDocument;
  if (!xmlParam.setContent(contenido))
    return;

  var xmlAux: FLDomNode;
  var nodoParam: FLDomNode = xmlParam.firstChild();
  var eParam: FLDomElement = nodoParam.toElement();

  this.child("fdbTiempoModelo").setValue(eParam.attribute("TiempoModelo"));
  this.child("fdbTiempoAjusteTrab").setValue(eParam.attribute("TiempoAjusteTrab"));
  this.child("fdbMinAjusteTrab").setValue(eParam.attribute("MinAjusteTrab"));
}

function oficial_bufferChanged(fN: String)
{
  var cursor: FLSqlCursor = this.cursor();
  switch (fN) {
    case "": {
      break;
    }
  }
}

function oficial_guardarDatos(): FLDomDocument {
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();
  var xmlParamOriginal: FLDomDocument = new FLDomDocument;
  var xmlParam: FLDomDocument = new FLDomDocument;

  xmlParamOriginal.setContent(cursor.valueBuffer("xml"));

  xmlParam.appendChild(xmlParamOriginal.firstChild().cloneNode());
  var nodoParam: FLDomNode = xmlParam.firstChild();
  var eParam: FLDomNode = nodoParam.toElement();

  var tiempoModelo: String = cursor.valueBuffer("tiempomodelo");
  if (isNaN(tiempoModelo))
  {
    tiempoModelo = 0;
  }
  tiempoModelo = util.roundFieldValue(tiempoModelo, "pr_paramdisenador", "tiempomodelo");
  eParam.setAttribute("TiempoModelo", tiempoModelo);

  var tiempoAjusteTrab: String = cursor.valueBuffer("tiempoajustetrab");
  if (isNaN(tiempoAjusteTrab))
  {
    tiempoAjusteTrab = 0;
  }
  tiempoAjusteTrab = util.roundFieldValue(tiempoAjusteTrab, "pr_paramdisenador", "tiempoajustetrab");
  eParam.setAttribute("TiempoAjusteTrab", tiempoAjusteTrab);

  var minAjusteTrab: String = cursor.valueBuffer("minajustetrab");
  if (isNaN(minAjusteTrab))
  {
    minAjusteTrab = 0;
  }
  minAjusteTrab = util.roundFieldValue(minAjusteTrab, "pr_paramdisenador", "minajustetrab");
  eParam.setAttribute("MinAjusteTrab", minAjusteTrab);

  return xmlParam;
}

function oficial_tbnOk_clicked()
{
  if (!this.iface.validarDatos())
    return false;

  var xmlDocParam: FLDomDocument = this.iface.guardarDatos();
  if (!xmlDocParam)
    return false;

  var cursor: FLSqlCursor = this.cursor();
  cursor.setValueBuffer("xml", xmlDocParam.toString());

  this.child("pushButtonAccept").enabled = true;
  this.child("pushButtonAccept").animateClick();
}

function oficial_validarDatos(): Boolean {
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  return true;
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////