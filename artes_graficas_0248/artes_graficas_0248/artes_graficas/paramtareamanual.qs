/***************************************************************************
                 paramtareamanual.qs  -  description
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
  function validateForm(): Boolean {
    return this.ctx.interna_validateForm();
  }
  function calculateField(fN: String): String {
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
  var bloqueoCoste_: Boolean = false;
  function oficial(context)
  {
    interna(context);
  }
  function bufferChanged(fN: String)
  {
    return this.ctx.oficial_bufferChanged(fN);
  }
  function guardarDatos(cursor: FLSqlCursor): FLDomDocument {
    return this.ctx.oficial_guardarDatos(cursor);
  }
  function validarDatos(xmlProceso: FLDomNode): Boolean {
    return this.ctx.oficial_validarDatos(xmlProceso);
  }
  function commonCalculateField(fN: String, cursor: FLSqlCursor): String {
    return this.ctx.oficial_commonCalculateField(fN, cursor);
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
  function pub_guardarDatos(cursor: FLSqlCursor): FLDomDocument {
    return this.guardarDatos(cursor);
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
function interna_init()
{
  var cursor: FLSqlCursor = this.cursor();

  connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");

  switch (cursor.modeAccess()) {
    case cursor.Insert: {
      break;
    }
  }
  this.iface.bloqueoCoste_ = false;
}

function interna_validateForm(): Boolean {
  var cursor: FLSqlCursor = this.cursor();
  var xmlDocParam: FLDomDocument = this.iface.guardarDatos(cursor);
  if (!xmlDocParam)
  {
    return false;
  }

  if (!this.iface.validarDatos(xmlDocParam.firstChild()))
  {
    return false;
  }

  debug(xmlDocParam.toString());

  cursor.setValueBuffer("xml", xmlDocParam.toString());

  return true;
}

function interna_calculateField(fN: String): String {
  debug("CF " + fN);
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();
  var valor: String = this.iface.commonCalculateField(fN, cursor);

  return valor;
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_bufferChanged(fN: String)
{
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  switch (fN) {
    case "unidades":
    case "costeunidad": {
      if (!this.iface.bloqueoCoste_) {
        this.iface.bloqueoCoste_ = true;
        this.child("fdbCosteTotal").setValue(this.iface.calculateField("costetotal"));
        this.iface.bloqueoCoste_ = false;
      }
      break;
    }
    case "costetotal": {
      if (!this.iface.bloqueoCoste_) {
        this.iface.bloqueoCoste_ = true;
        this.child("fdbCosteUnidad").setValue(this.iface.calculateField("costeunidad"));
        this.iface.bloqueoCoste_ = false;
      }
      break;
    }
  }
}

function oficial_guardarDatos(cursor: FLSqlCursor): FLDomDocument {
  var util: FLUtil = new FLUtil;

  var xmlParam: FLDomDocument = new FLDomDocument;
  xmlParam.setContent("<Parametros/>");
  var nodoParam: FLDomNode = xmlParam.firstChild();
  var nodoAux: FLDomNode;
  var eParametro: FLDomElement;

  eDatos = xmlParam.createElement("DatosParam");
  nodoParam.appendChild(eDatos);

  var descripcion: String = cursor.valueBuffer("descripcion");
  eDatos.setAttribute("Descripcion", descripcion);

  var costeTotal: Number = parseFloat(cursor.valueBuffer("costetotal"));
  if (isNaN(costeTotal) || costeTotal == 0)
  {
    MessageBox.warning(util.translate("scripts", "Debe establecer el coste total"), MessageBox.Ok, MessageBox.NoButton);
    return;
  }
  eDatos.setAttribute("CosteTotal", costeTotal);

  var costeUnidad: Number = parseFloat(cursor.valueBuffer("costeunidad"));
  if (isNaN(costeUnidad) || costeUnidad == 0)
  {
    MessageBox.warning(util.translate("scripts", "Debe establecer el coste por unidad"), MessageBox.Ok, MessageBox.NoButton);
    return;
  }
  eDatos.setAttribute("CosteUnidad", costeUnidad);

  var unidades: Number = parseFloat(cursor.valueBuffer("unidades"));
  if (isNaN(unidades) || unidades == 0)
  {
    MessageBox.warning(util.translate("scripts", "Debe establecer las unidades"), MessageBox.Ok, MessageBox.NoButton);
    return;
  }
  eDatos.setAttribute("Unidades", unidades);

  var costeFijo: String;
  if (cursor.valueBuffer("costefijo"))
  {
    costeFijo = "true";
  } else {
    costeFijo = "false";
  }
  eDatos.setAttribute("CosteFijo", costeFijo);

  var curConsumos: FLSqlCursor = new FLSqlCursor("consumostareamanual");
  var eConsumos: FLDomElement = xmlParam.createElement("ConsumosParam");
  nodoParam.appendChild(eConsumos);
  var eConsumo: FLDomElement;
  curConsumos.select("idparamtareamanual = " + cursor.valueBuffer("id"));
  while (curConsumos.next())
  {
    curConsumos.setModeAccess(curConsumos.Browse);
    curConsumos.refreshBuffer();
    eConsumo = xmlParam.createElement("Consumo");
    eConsumos.appendChild(eConsumo);
    eConsumo.setAttribute("Referencia", curConsumos.valueBuffer("referencia"));
    eConsumo.setAttribute("Coste", curConsumos.valueBuffer("coste"));
    eConsumo.setAttribute("Cantidad", curConsumos.valueBuffer("cantidad"));
    eConsumo.setAttribute("PorBeneficio", curConsumos.valueBuffer("porbeneficio"));
  }

  return xmlParam;
}

function oficial_validarDatos(xmlProceso: FLDomNode): Boolean {
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  return true;
}

function oficial_commonCalculateField(fN: String, cursor: FLSqlCursor): String {
  debug("CF " + fN);
  var util: FLUtil = new FLUtil;
  var valor: String;

  switch (fN)
  {
    case "costetotal": {
      valor = parseFloat(cursor.valueBuffer("unidades")) * parseFloat(cursor.valueBuffer("costeunidad"));
      break;
    }
    case "costeunidad": {
      var unidades: Number = parseFloat(cursor.valueBuffer("unidades"));
      if (isNaN(unidades) || unidades == 0) {
        valor = 0;
      } else {
        valor = parseFloat(cursor.valueBuffer("costetotal")) / unidades;
      }
      break;
    }
  }

  return valor;
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////