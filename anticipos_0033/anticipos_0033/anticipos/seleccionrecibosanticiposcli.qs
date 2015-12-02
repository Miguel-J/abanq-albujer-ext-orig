/***************************************************************************
                 seleccionrecibosanticiposcli.qs  -  description
                             -------------------
    begin                : lun abr 26 2004
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
  var lblTotalTexto_;
  function oficial(context)
  {
    interna(context);
  }
  function incluirRecibo()
  {
    return this.ctx.oficial_incluirRecibo();
  }
  function calcularImporte(listado)
  {
    return this.ctx.oficial_calcularImporte(listado);
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
  function pub_imprimir(codRecibo: String)
  {
    return this.imprimir(codRecibo);
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
  var _i = this.iface;
  this.child("tableDBRecords").setEditOnly(true);
  connect(this.child("tableDBRecords"), "primaryKeyToggled(QVariant, bool)", _i, "incluirRecibo()");
  _i.lblTotalTexto_ = this.child("lblTotal").text;
  sys.setObjText(this, "lblTotal", _i.lblTotalTexto_ + 0);
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////

function oficial_incluirRecibo()
{
  var _i = this.iface;
  var cursor = this.cursor();
  var aListado = this.child("tableDBRecords").primarysKeysChecked();
  if (aListado && aListado.length > 0) {
    formRecordanticiposcli.iface.pub_ponListaRecibos(aListado);
  } else {
    formRecordanticiposcli.iface.pub_ponListaRecibos(false);
  }
  sys.setObjText(this, "lblTotal", _i.lblTotalTexto_ + _i.calcularImporte(aListado));
}

function oficial_calcularImporte(listado)
{
  var _i = this.iface;
  var cursor = this.cursor();
  var total = 0;
  if (listado && listado.length > 0) {
    total = AQUtil.sqlSelect("reciboscli", "SUM(importe)", "idrecibo IN (" + listado + ")");
  }
  total = isNaN(total) ? 0 : total;
  total = AQUtil.formatoMiles(AQUtil.roundFieldValue(total, "reciboscli", "importe"));
  return total;
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
////////////////////////////////////////////////////////////////