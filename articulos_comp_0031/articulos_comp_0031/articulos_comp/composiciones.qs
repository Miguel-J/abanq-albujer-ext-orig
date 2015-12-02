/***************************************************************************
                 composiciones.qs  -  description
                             -------------------
    begin                : mar mar 8 2011
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
  function calculateField(fN)
  {
    return this.ctx.interna_calculateField(fN);
  }
  function init()
  {
    return this.ctx.interna_init();
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
  function datosIniciales()
  {
    return this.ctx.oficial_datosIniciales();
  } function pbnGenerarComposicion_clicked()
  {
    return this.ctx.oficial_pbnGenerarComposicion_clicked();
  }
  function borrarLineas()
  {
    return this.ctx.oficial_borrarLineas();
  }
  function validarControlComponentes()
  {
    return this.ctx.oficial_validarControlComponentes();
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
  this.iface.datosIniciales();

  var cursor = this.cursor();
  connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");
  connect(this.child("pbnGenerarComposicion"), "clicked()", this, "iface.pbnGenerarComposicion_clicked");
}

function interna_calculateField(fN)
{
  return ;
}

function interna_validateForm()
{
  if (!this.iface.validarControlComponentes()) {
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
}

function oficial_datosIniciales()
{
  var cursor = this.cursor();
  switch (cursor.modeAccess()) {
    case cursor.Insert: {
      this.child("fdbCodAlmacen").setValue(flfactppal.iface.pub_valorDefectoEmpresa("codalmacen"));
      this.child("fdbIdUsuario").setValue(sys.nameUser());
      break;
    }
  }
}

function oficial_pbnGenerarComposicion_clicked()
{
  var util = new FLUtil;
  if (!this.iface.borrarLineas()) {
    return false;
  }
  var cursor = this.cursor();
  var qryComp = new FLSqlQuery;
  qryComp.setTablesList("articuloscomp,articulos");
  qryComp.setSelect("ac.refcomponente, ac.cantidad, a.descripcion");
  qryComp.setFrom("articuloscomp ac INNER JOIN articulos a ON ac.refcomponente = a.referencia");
  qryComp.setWhere("ac.refcompuesto = '" + cursor.valueBuffer("referencia") + "'");
  qryComp.setForwardOnly(true);
  if (!qryComp.exec()) {
    return false;
  }
  var curLineas = this.child("tdbLineasComposicion").cursor();
  var cantidad = cursor.valueBuffer("cantidad");
  cantidad = isNaN(cantidad) ? 0 : cantidad;
  var canComponente;
  while (qryComp.next()) {
    curLineas.setModeAccess(curLineas.Insert);
    curLineas.refreshBuffer();
    curLineas.setValueBuffer("idcomposicion", cursor.valueBuffer("idcomposicion"));
    curLineas.setValueBuffer("referencia", qryComp.value("ac.refcomponente"));
    curLineas.setValueBuffer("descripcion", qryComp.value("a.descripcion"));
    canComponente = cantidad * qryComp.value("ac.cantidad");
    canComponente = util.roundFieldValue(canComponente, "articuloscomp", "cantidad");
    curLineas.setValueBuffer("cantidad", canComponente);
    curLineas.setValueBuffer("codalmacen", cursor.valueBuffer("codalmacen"));
    if (!curLineas.commitBuffer()) {
      return false;
    }
  }
}

function oficial_borrarLineas()
{
  var cursor = this.cursor();
  var curLineas = new FLSqlCursor("lineascomposicion");
  curLineas.select("idcomposicion = " + cursor.valueBuffer("idcomposicion"));
  while (curLineas.next()) {
    curLineas.setModeAccess(curLineas.Del);
    curLineas.refreshBuffer();
    if (!curLineas.commitBuffer()) {
      return false;
    }
  }
  return true;
}

function oficial_validarControlComponentes()
{
  var util = new FLUtil;
  var cursor = this.cursor();
  var referencia = cursor.valueBuffer("referencia");
  if (util.sqlSelect("articulos", "stockcomp", "referencia = '" + referencia + "'")) {
    MessageBox.warning(util.translate("scripts", "El artículo compuesto tiene activado el indicador de Control stock componentes.\nEsto es incompatible con la creación de composiciones"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  return true;
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

