/***************************************************************************
                 cl_partidascertificacion.qs  -  description
                             -------------------
    begin                : mie dic 5 2007
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
    return this.ctx.interna_init();
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
  function oficial(context)
  {
    interna(context);
  }
  function bufferChanged(fN)
  {
    return this.ctx.oficial_bufferChanged(fN);
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
//////////////////////////////////////////////////////////////////
//// INTERNA /////////////////////////////////////////////////////
function interna_init()
{
  debug("init")
  var cursor: FLSqlCursor = this.cursor();
  connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");

  if (cursor.modeAccess() == cursor.Insert)
    cursor.setValueBuffer("fechaproxima", this.iface.calculateField("fechaproxima"));
}

function interna_calculateField(fN: String): String {
  var cursor: FLSqlCursor = this.cursor();
  var resul: String;
  var util: FLUtil = new FLUtil;

  switch (fN)
  {

    case "fechaproxima":
      var fechaUltima = cursor.valueBuffer("fechaultima");

      var numMeses: Number = util.sqlSelect("cl_tiposaveriasrevision", "intervalo", "tipoperiodicidad = 'Por meses' AND codtipo = '" + cursor.valueBuffer("codtipo") + "'");
      if (!numMeses)
        resul = cursor.valueBuffer("fechaproxima");
      else
        resul = util.addMonths(fechaUltima, numMeses);
      break;
  }

  return resul;
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////

function oficial_bufferChanged(fN: String)
{
  var cursor: FLSqlCursor = this.cursor();

  switch (fN) {
    case "codtipo":
    case "fechaultima":
      cursor.setValueBuffer("fechaproxima", this.iface.calculateField("fechaproxima"));
      break;
  }
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
////////////////////////////////////////////////////////////////