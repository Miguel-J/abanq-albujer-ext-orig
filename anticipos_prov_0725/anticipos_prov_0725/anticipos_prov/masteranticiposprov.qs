/***************************************************************************
                 masteranticiposprov.qs  -  description
                             -------------------
    begin                : lun ene 09 2012
    copyright            : (C) 2012 by InfoSiAL S.L.
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
  function dameListaCancelables()
  {
    return this.ctx.oficial_dameListaCancelables();
  }
  function chkCancelables_clicked()
  {
    return this.ctx.oficial_chkCancelables_clicked();
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
  var _i = this.iface;

  connect(this.child("chkCancelables"), "clicked()", _i, "chkCancelables_clicked");

}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_chkCancelables_clicked()
{
  var _i = this.iface;
  var cursor = this.cursor();
  var f = "";
  if (this.child("chkCancelables").checked) {
    var lista = _i.dameListaCancelables();
    if (lista != "") {
      f = "idanticipo IN (" + lista + ")";
    }
  }
  cursor.setMainFilter(f);
  this.child("tableDBRecords").refresh();
}

function oficial_dameListaCancelables()
{
  var _i = this.iface;
  var cursor = this.cursor();
  var q = new FLSqlQuery;
  q.setSelect("a.idanticipo");
  q.setFrom("anticiposcli a INNER JOIN recibosprov r ON a.codcliente = r.codcliente");
  q.setWhere("a.pendiente > 0 AND r.estado IN ('Emitido', 'Devuelto')");
  q.setForwardOnly(true);
  if (!q.exec()) {
    return false;
  }
  var lista = "";
  while (q.next()) {
    lista += lista != "" ? ", " : "";
    lista += q.value("a.idanticipo");
  }
  return lista;
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
////////////////////////////////////////////////////////////////