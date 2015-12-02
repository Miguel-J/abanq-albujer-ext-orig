/***************************************************************************
                 fo_alumnosactividad.qs  -  description
                             -------------------
    begin                : mie feb 23 2011
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
  function establecerFiltroAlumno()
  {
    return this.ctx.oficial_establecerFiltroAlumno();
  }
  function establecerFiltroTarifa()
  {
    return this.ctx.oficial_establecerFiltroTarifa();
  }
  function bufferChanged(fN)
  {
    return this.ctx.oficial_bufferChanged(fN);
  }
  function validarDatos()
  {
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
  var cursor = this.cursor();
  connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");

  this.iface.establecerFiltroAlumno();
  this.iface.establecerFiltroTarifa();
}

function interna_validateForm()
{
  if (!this.iface.validarDatos()) {
    return false;
  }
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_validarDatos()
{
  debug("oficial_validarDatos");
  var cursor = this.cursor();
  var util = new FLUtil();
  var codAlumno = cursor.valueBuffer("codalumno");
  var codCliente = util.sqlSelect("contratos", "codcliente", "codigo = '" + cursor.valueBuffer("codcontrato") + "'");
  if (codCliente != util.sqlSelect("fo_alumnos", "codcliente", "codalumno = '" + codAlumno + "'")) {
    MessageBox.information(util.translate("scripts", "El alumno %1 no pertenece al cliente establecido en el contrato").arg(codAlumno), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }

  var codTarifa = cursor.valueBuffer("codtarifa");
  var codCentroAlumno = util.sqlSelect("fo_alumnos", "codcentro", "codalumno = '" + codAlumno + "'");
  var codCentroTarifa = util.sqlSelect("tarifas", "codcentroesc", "codtarifa = '" + codTarifa + "'");
  if (codCentroAlumno != codCentroTarifa) {
    MessageBox.information(util.translate("scripts", "La tarifa %1 no está asociada al centro del alumno").arg(codTarifa), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }

  var tarBeca = util.sqlSelect("tarifas", "beca", "codtarifa = '" + codTarifa + "'");
  var codBecador = cursor.valueBuffer("codbecador");
  if (tarBeca && (!codBecador || codBecador == "")) {
    MessageBox.information(util.translate("scripts", "La tarifa %1 está marcada como Beca. Debe establecer el Organismo Becador").arg(codTarifa), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  if (!tarBeca && codBecador && codBecador != "") {
    MessageBox.information(util.translate("scripts", "La tarifa %1 no está marcada como Beca. No debe informar el Organismo Becador").arg(codTarifa), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  debug("oficial_validarDatos OK");
  return true;
}

function oficial_establecerFiltroAlumno()
{
  var cursor = this.cursor();
  this.child("fdbCodAlumno").setFilter("codalumno IN (SELECT a.codalumno FROM fo_alumnos a INNER JOIN contratos c ON a.codcliente = c.codcliente WHERE c.codigo = '" + cursor.valueBuffer("codcontrato") + "')");
}

function oficial_establecerFiltroTarifa()
{
  var util = new FLUtil;
  var cursor = this.cursor();
  var codCentroAlumno = util.sqlSelect("fo_alumnos", "codcentro", "codalumno = '" + cursor.valueBuffer("codalumno") + "'");
  this.child("fdbCodTarifa").setFilter("codcentroesc = '" + codCentroAlumno  + "'");
}

function oficial_bufferChanged(fN)
{
  var util = new FLUtil;
  var cursor = this.cursor();

  switch (fN) {
    case "codalumno": {
      this.iface.establecerFiltroTarifa();
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
