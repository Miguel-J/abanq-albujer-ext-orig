/***************************************************************************
                 t1_elementosug.qs  -  description
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
  function pbnAnadir_clicked()
  {
    return this.ctx.oficial_pbnAnadir_clicked();
  }
  function pbnQuitar_clicked()
  {
    return this.ctx.oficial_pbnQuitar_clicked();
  }
  function pbnAnadirTodos_clicked()
  {
    return this.ctx.oficial_pbnAnadirTodos_clicked();
  }
  function pbnQuitarTodos_clicked()
  {
    return this.ctx.oficial_pbnQuitarTodos_clicked();
  }
  function refrescar()
  {
    return this.ctx.oficial_refrescar();
  }
  function reordenar()
  {
    return this.ctx.oficial_reordenar();
  }
  function anadirRelacion(curRelaciones: FLSqlCursor, orden: Number): Boolean {
    return this.ctx.oficial_anadirRelacion(curRelaciones, orden);
  }
  function quitarRelacion(curRelacionesUG: FLSqlCursor): Boolean {
    return this.ctx.oficial_quitarRelacion(curRelacionesUG);
  }
  function tbnUp_clicked()
  {
    return this.ctx.oficial_tbnUp_clicked();
  }
  function tbnDown_clicked()
  {
    return this.ctx.oficial_tbnDown_clicked();
  }
  function moveStep(direction: Number)
  {
    return this.ctx.oficial_moveStep(direction);
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
  var cursor: FLSqlCursor = this.cursor();

  connect(this.child("pbnAnadir"), "clicked()", this, "iface.pbnAnadir_clicked");
  connect(this.child("pbnAnadirTodos"), "clicked()", this, "iface.pbnAnadirTodos_clicked");
  connect(this.child("pbnQuitar"), "clicked()", this, "iface.pbnQuitar_clicked");
  connect(this.child("pbnQuitarTodos"), "clicked()", this, "iface.pbnQuitarTodos_clicked");
  connect(this.child("tbnDown"), "clicked()", this, "iface.tbnDown_clicked");
  connect(this.child("tbnUp"), "clicked()", this, "iface.tbnUp_clicked");

  //  this.child("tdbRelacionesElemento").setFilter("idrelacionelemento NOT IN (SELECT idrelacionelemento from t1_relacioneselementoug where idelementoug = " + cursor.valueBuffer("idelementoug") + ")");
  this.iface.refrescar();
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_refrescar()
{
  this.child("tdbRelacionesElemento").refresh();
  this.child("tdbRelacionesElementoUG").refresh();
}

function oficial_pbnAnadir_clicked()
{
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  var curRelaciones: FLSqlCursor = this.child("tdbRelacionesElemento").cursor();

  var orden: Number = util.sqlSelect("t1_relacioneselementoug", "orden", "idelementoug = " + cursor.valueBuffer("idelementoug") + " ORDER BY orden DESC");
  if (!orden || isNaN(orden)) {
    orden = 0;
  }
  orden++;

  var elementoSel: String = curRelaciones.valueBuffer("elemento");
  if (!this.iface.anadirRelacion(curRelaciones, orden)) {
    return false;
  }
  this.iface.refrescar();
}

function oficial_pbnQuitar_clicked()
{
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  var curRelacionesUG: FLSqlCursor = this.child("tdbRelacionesElementoUG").cursor();
  if (!curRelacionesUG.isValid()) {
    return false;
  }
  if (!this.iface.quitarRelacion(curRelacionesUG)) {
    return false;
  }
  this.iface.reordenar();
  this.iface.refrescar();
}

function oficial_reordenar()
{
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  var curRelacionesUG: FLSqlCursor = new FLSqlCursor("t1_relacioneselementoug");
  curRelacionesUG.setForwardOnly(true);
  curRelacionesUG.select("idelementoug = " + cursor.valueBuffer("idelementoug") + " ORDER BY orden ASC");
  var orden: Number = 1;
  while (curRelacionesUG.next()) {
    curRelacionesUG.setModeAccess(curRelacionesUG.Edit);
    curRelacionesUG.refreshBuffer();
    curRelacionesUG.setValueBuffer("orden", orden++);
    if (!curRelacionesUG.commitBuffer()) {
      return false;
    }
  }
}

function oficial_pbnAnadirTodos_clicked()
{
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  var orden: Number = util.sqlSelect("t1_relacioneselementoug", "orden", "idelementoug = " + cursor.valueBuffer("idelementoug") + " ORDER BY orden DESC");
  if (!orden || isNaN(orden)) {
    orden = 0;
  }

  var curRelaciones: FLSqlCursor = this.child("tdbRelacionesElemento").cursor();
  if (!curRelaciones.first()) {
    return;
  }
  do {
    orden++;
    if (!this.iface.anadirRelacion(curRelaciones, orden)) {
      return false;
    }
  } while (curRelaciones.next());

  this.iface.refrescar();
}

function oficial_pbnQuitarTodos_clicked()
{
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  var curRelacionesUG: FLSqlCursor = new FLSqlCursor("t1_relacioneselementoug");
  curRelacionesUG.select("idelementoug = " + cursor.valueBuffer("idelementoug"));
  curRelacionesUG.setForwardOnly(true);
  if (!curRelacionesUG.first()) {
    return;
  }
  do {
    if (!this.iface.quitarRelacion(curRelacionesUG)) {
      return false;
    }
  } while (curRelacionesUG.next());

  this.iface.refrescar();
}

function oficial_anadirRelacion(curRelaciones: FLSqlCursor, orden: Number): Boolean {
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();
  if (cursor.modeAccess() == cursor.Insert)
  {
    this.child("tdbRelacionesElementoUG").cursor().commitBufferCursorRelation();
  }

  var curRelacionesUG: FLSqlCursor = this.child("tdbRelacionesElementoUG").cursor();
  curRelacionesUG.setModeAccess(curRelacionesUG.Insert);
  curRelacionesUG.refreshBuffer();
  curRelacionesUG.setValueBuffer("orden", orden);
  curRelacionesUG.setValueBuffer("idelementoug", cursor.valueBuffer("idelementoug"));
  curRelacionesUG.setValueBuffer("idrelacionelemento", curRelaciones.valueBuffer("idrelacionelemento"));
  curRelacionesUG.setValueBuffer("relacion", curRelaciones.valueBuffer("relacion"));
  curRelacionesUG.setValueBuffer("xmlpicrelacion", curRelaciones.valueBuffer("xmlpicrelacion"));
  //  curRelacionesUG.setValueBuffer("xmlpicelemento", curRelaciones.valueBuffer("xmlpicelemento"));
  if (!curRelacionesUG.commitBuffer())
  {
    return false;
  }

  return true;
}

function oficial_quitarRelacion(curRelacionesUG: FLSqlCursor): Boolean {
  curRelacionesUG.setModeAccess(curRelacionesUG.Del);
  curRelacionesUG.refreshBuffer();
  if (!curRelacionesUG.commitBuffer())
  {
    return false;
  }

  return true;
}

/** \D Desplaza la prueba seleccionada hacia arriba (antes) en el orden de ejecución
*/
function oficial_tbnUp_clicked()
{
  this.iface.moveStep(-1);
}

/** \D Desplaza la prueba seleccionada hacia abajo (después) en el orden de ejecución
*/
function oficial_tbnDown_clicked()
{
  this.iface.moveStep(1);
}

/** \D Mueve la prueba seleccionada una posición en el orden de ejecución

@param  direction: Sentido en el cual se mueve la prueba: -1 hacia arriba (antes), 1 hacia abajo (después)
*/
function oficial_moveStep(direction: Number)
{
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();
  var tdbRelacionesUG: FLTableDB = this.child("tdbRelacionesElementoUG");

  var idElementoUG: String = cursor.valueBuffer("idelementoug");

  var curRelacionUG: FLSqlCursor = tdbRelacionesUG.cursor();
  var idRelacionUG: String = curRelacionUG.valueBuffer("idrelacionelementoug");
  var orden: Number = curRelacionUG.valueBuffer("orden");
  var testNumber2: Number;
  var row: Number = tdbRelacionesUG.currentRow();

  if (direction == -1) {
    orden2 = util.sqlSelect("t1_relacioneselementoug", "orden", "idelementoug = " + idElementoUG + " AND orden < " + orden + " ORDER BY orden DESC");
  } else {
    orden2 = util.sqlSelect("t1_relacioneselementoug", "orden", "idelementoug = " + idElementoUG + " AND orden > " + orden + " ORDER BY orden");
  }
  if (!orden2) {
    return;
  }
  var curRel: FLSqlCursor = new FLSqlCursor("t1_relacioneselementoug");
  curRel.select("idelementoug = " + idElementoUG + " AND orden = " + orden2);
  if (!curRel.first()) {
    return;
  }
  curRel.setModeAccess(curRel.Edit);
  curRel.refreshBuffer();
  curRel.setValueBuffer("orden", "-1");
  curRel.commitBuffer();

  curRelacionUG.setModeAccess(curRelacionUG.Edit);
  curRelacionUG.refreshBuffer();
  curRelacionUG.setValueBuffer("orden", orden2);
  curRelacionUG.commitBuffer();

  curRel.setModeAccess(curRel.Edit);
  curRel.refreshBuffer();
  curRel.setValueBuffer("orden", orden);
  curRel.commitBuffer();

  tdbRelacionesUG.refresh();
  row += direction;
  tdbRelacionesUG.setCurrentRow(row);
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
