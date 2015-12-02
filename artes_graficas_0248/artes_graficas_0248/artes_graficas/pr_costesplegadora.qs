/***************************************************************************
         pr_costesplegadora.qs  -  description
                             -------------------
    begin                : mie abr 02 2007
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

}

function interna_validateForm(): Boolean {
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  if (!cursor.isNull("copiasmin") && !cursor.isNull("copiasmax"))
  {
    if (cursor.valueBuffer("copiasmin") > cursor.valueBuffer("copiasmax")) {
      MessageBox.warning(util.translate("scripts", "El límite inferior no puede ser mayor que el límite superior"), MessageBox.Ok, MessageBox.NoButton);
      return false;
    }
  }
  var datos: String = "";
  var where: String = "codtipocentro = '" + cursor.valueBuffer("codtipocentro") + "'";
  where += " AND id <> " + cursor.valueBuffer("id");

  if (cursor.isNull("copiasmin"))
  {
    if (util.sqlSelect("pr_costesplegadora", "id", where + " AND copiasmin IS NULL")) {
      MessageBox.warning(util.translate("scripts", "El límite inferior de copias indicado se solapa con un intervalo ya existente."), MessageBox.Ok, MessageBox.NoButton);
      return false;
    }
  } else {
    if (util.sqlSelect("pr_costesplegadora", "id", where + " AND (copiasmin <= " + cursor.valueBuffer("copiasmin") + " OR copiasmin IS NULL) AND (copiasmax >= " + cursor.valueBuffer("copiasmin") + " OR copiasmax IS NULL)"))
    {
      MessageBox.warning(util.translate("scripts", "El límite inferior de copias indicado se solapa con un intervalo ya existente."), MessageBox.Ok, MessageBox.NoButton);
      return false;
    }
  }

  if (cursor.isNull("copiasmax"))
  {
    if (util.sqlSelect("pr_costesplegadora", "id", where + " AND copiasmax IS NULL")) {
      MessageBox.warning(util.translate("scripts", "El límite superior de copias indicado se solapa con un intervalo ya existente."), MessageBox.Ok, MessageBox.NoButton);
      return false;
    }
  } else {
    if (util.sqlSelect("pr_costesplegadora", "id", where + " AND (copiasmin <= " + cursor.valueBuffer("copiasmax") + " OR copiasmin IS NULL) AND (copiasmax >= " + cursor.valueBuffer("copiasmax") + " OR copiasmax IS NULL)"))
    {
      MessageBox.warning(util.translate("scripts", "El límite superior de copias indicado se solapa con un intervalo ya existente."), MessageBox.Ok, MessageBox.NoButton);
      return false;
    }
  }
  return true;
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
