/***************************************************************************
                 rutas.qs  -  description
                             -------------------
    begin                : mar nov 06 2007
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
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna
{
  var tbnUp: Object;
  var tbnDown: Object;
  var tdbDirecciones: Object;
  var tbnAsociarDireccion: Object;
  var tbnQuitarDireccion: Object;
  function oficial(context)
  {
    interna(context);
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
  function asociarDireccion()
  {
    this.ctx.oficial_asociarDireccion();
  }
  function quitarDireccion()
  {
    this.ctx.oficial_quitarDireccion();
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
  this.iface.tdbDirecciones = this.child("tdbDirecciones");
  this.iface.tbnUp = this.child("toolButtonUp");
  this.iface.tbnDown = this.child("toolButtonDown");
  this.iface.tbnAsociarDireccion = this.child("tbnAsociarDireccion");
  this.iface.tbnQuitarDireccion = this.child("tbnQuitarDireccion");

  connect(this.iface.tbnUp, "clicked()", this, "iface.tbnUp_clicked");
  connect(this.iface.tbnDown, "clicked()", this, "iface.tbnDown_clicked");
  connect(this.iface.tbnAsociarDireccion, "clicked()", this, "iface.asociarDireccion");
  connect(this.iface.tbnQuitarDireccion, "clicked()", this, "iface.quitarDireccion");

  this.iface.tdbDirecciones.putFirstCol("ordenruta");
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_asociarDireccion()
{
  var util: FLUtil;

  var codRuta: String = this.cursor().valueBuffer("codruta");
  if (!codRuta)
    return false;

  var f: Object = new FLFormSearchDB("selectdirclientes");
  var curDirclientes: FLSqlCursor = f.cursor();
  curDirclientes.select("codruta IS NULL OR codruta = ''");
  curDirclientes.first();
  curDirclientes.setModeAccess(curDirclientes.Edit);
  f.setMainWidget();
  curDirclientes.refreshBuffer();
  f.exec("id");

  var codDir: String;
  if (f.accepted()) {
    curDirclientes.commitBuffer();
    codDir = curDirclientes.valueBuffer("id");
  }
  if (!codDir)
    return;

  if (!util.sqlUpdate("dirclientes", "codruta", codRuta, "id = '" + codDir + "'"))
    return false;

  this.iface.tdbDirecciones.refresh();
}

function oficial_quitarDireccion()
{
  var util: FLUtil;
  var codDir: String = this.iface.tdbDirecciones.cursor().valueBuffer("id");
  if (!codDir || codDir == "") {
    MessageBox.information(util.translate("scripts", "No hay ningún registro seleccionado."), MessageBox.Ok, MessageBox.NoButton)
    return false;
  }
  var res: Number = MessageBox.information(util.translate("scripts", "Se va a eliminar la dirección seleccionada de la ruta.\n¿Desea continuar?"), MessageBox.Yes, MessageBox.No)
                    if (res != MessageBox.Yes)
                      return false;

  if (!util.sqlUpdate("dirclientes", "codruta", "NULL", "id = '" + codDir + "'"))
    return false;

  this.iface.tdbDirecciones.refresh();
}

function oficial_tbnUp_clicked()
{
  this.iface.moveStep(-1);
}

function oficial_tbnDown_clicked()
{
  this.iface.moveStep(1);
}

function oficial_moveStep(direction: Number)
{
  var cursor: FLSqlCursor = this.iface.tdbDirecciones.cursor();
  if (!cursor.isValid())
    return;

  var codruta: String = cursor.valueBuffer("codruta");
  if (!codruta)
    return;

  var orden: Number = cursor.valueBuffer("ordenruta");
  var orden2: Number;
  var row: Number = this.iface.tdbDirecciones.currentRow();
  var util: FLUtil = new FLUtil();

  if (direction == -1) {
    orden2 = util.sqlSelect("dirclientes", "ordenruta", "codruta = '" + codruta + "' AND ordenruta < " + orden + " ORDER BY ordenruta DESC");
  } else {
    orden2 = util.sqlSelect("dirclientes", "ordenruta", "codruta = '" + codruta + "' AND ordenruta > " + orden + " ORDER BY ordenruta");
  }

  if (!orden2)
    return;

  var curDirecciones: FLSqlCursor = new FLSqlCursor("dirclientes");
  curDirecciones.select("codruta = '" + codruta + "' AND ordenruta = '" + orden2 + "'");
  if (!curDirecciones.first())
    return;

  curDirecciones.setModeAccess(curDirecciones.Edit);
  curDirecciones.refreshBuffer();
  curDirecciones.setValueBuffer("ordenruta", "-1");
  curDirecciones.commitBuffer();

  cursor.setModeAccess(cursor.Edit);
  cursor.refreshBuffer();
  cursor.setValueBuffer("ordenruta", orden2);
  cursor.commitBuffer();

  curDirecciones.select("codruta = '" + codruta + "' AND ordenruta = -1");
  curDirecciones.first();
  curDirecciones.setModeAccess(curDirecciones.Edit);
  curDirecciones.refreshBuffer();
  curDirecciones.setValueBuffer("ordenruta", orden);
  curDirecciones.commitBuffer();

  this.iface.tdbDirecciones.refresh();
  row += direction;
  this.iface.tdbDirecciones.setCurrentRow(row);
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////




