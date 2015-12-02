/***************************************************************************
                 i_masterprevcobros.qs  -  description
                             -------------------
    begin                : lun abr 26 2006
    copyright            : (C) 2004 by InfoSiAL S.L.
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
  function lanzar()
  {
    return this.ctx.oficial_lanzar();
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
  connect(this.child("toolButtonPrint"), "clicked()", this, "iface.lanzar()");
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_lanzar()
{
  var util: FLUtil = new FLUtil();

  if (!util.sqlSelect("flmetadata", "tabla", "tabla = 'recibosprov'")) {
    MessageBox.critical(util.translate("scripts", "Para ver este informe es necesaria la funcionalidad de Recibos de Proveedor"), MessageBox.Ok, MessageBox.NoButton);
    return;
  }

  var cursor: FLSqlCursor = this.cursor();
  var nombreInforme: String = cursor.action();

  var where: String = "";

  if (cursor.valueBuffer("emitidos"))
    where += "recibosprov.estado = '" + util.translate("scripts", "Emitido") + "'";

  if (cursor.valueBuffer("pagados")) {
    if (where)  where += " OR";
    where += " recibosprov.estado = '" + util.translate("scripts", "Pagado") + "'";
  }

  if (cursor.valueBuffer("devueltos")) {
    if (where)  where += " OR";
    where += " recibosprov.estado = '" + util.translate("scripts", "Devuelto") + "'";
  }

  if (where)
    where = "(" + where + ")";

  var orderBy: String = "facturasprov.codproveedor,recibosprov.codigo";

  flfactinfo.iface.pub_establecerInformeActual(cursor.valueBuffer("id"));
  flfactinfo.iface.pub_lanzarInforme(cursor, nombreInforme, orderBy, "", false, false, where);
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
