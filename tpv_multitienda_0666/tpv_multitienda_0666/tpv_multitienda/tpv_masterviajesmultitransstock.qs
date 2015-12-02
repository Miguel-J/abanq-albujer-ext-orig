/***************************************************************************
                 tpv_masteragentes.qs  -  description
                             -------------------
    begin                : mar feb 15 2010
    copyright            : Por ahora (C) 2010 by InfoSiAL S.L.
    email                : lveb@telefonica.net
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
  var codAlmaOrigen_, codAlmaDestino_;
  function oficial(context)
  {
    interna(context);
  }
  function filtra()
  {
    return this.ctx.oficial_filtra();
  }
  function ponAlmaOrigen(a)
  {
    return this.ctx.oficial_ponAlmaOrigen(a);
  }
  function ponAlmaDestino(a)
  {
    return this.ctx.oficial_ponAlmaDestino(a);
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
  function pub_ponAlmaOrigen(a)
  {
    return this.ponAlmaOrigen(a);
  }
  function pub_ponAlmaDestino(a)
  {
    return this.ponAlmaDestino(a);
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
  connect(this.child("chkPendientes"), "clicked()", _i, "filtra");
  _i.filtra();
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_filtra()
{
  var _i = this.iface;
  var cursor = this.cursor();
  var filtro = "";
  if (_i.codAlmaOrigen_) {
    if (_i.codAlmaOrigen_ != "ALL") {
      filtro = "codalmaorigen = '" + _i.codAlmaOrigen_ + "'";
    }
    if (this.child("chkPendientes").checked) {
      filtro += (filtro != "") ? " AND " : "";
      filtro += "estado IN ('PTE ENVIO', 'ENVIADO PARCIAL')";
    }
  }
  if (_i.codAlmaDestino_) {
    if (_i.codAlmaDestino_ != "ALL") {
      filtro = "codalmadestino = '" + _i.codAlmaDestino_ + "'";
    }
    if (this.child("chkPendientes").checked) {
      filtro += (filtro != "") ? " AND " : "";
      filtro += "estado IN ('EN TRANSITO', 'RECIBIDO PARCIAL')";
    }
  }
  if (!_i.codAlmaDestino_ && !_i.codAlmaOrigen_) {
    if (this.child("chkPendientes").checked) {
      filtro += (filtro != "") ? " AND " : "";
      filtro += "estado IN ('PTE ENVIO', 'ENVIADO PARCIAL', 'EN TRANSITO', 'RECIBIDO PARCIAL')";
    }
  }
  debug("filtro " + filtro);
  cursor.setMainFilter(filtro);
  this.child("tableDBRecords").refresh();
}

function oficial_ponAlmaOrigen(a)
{
  debug("oficial_ponAlmaOrigen " + a);
  var _i = this.iface;
  _i.codAlmaOrigen_ = a;
}

function oficial_ponAlmaDestino(a)
{
  debug("oficial_ponAlmaDestino " + a);
  var _i = this.iface;
  _i.codAlmaDestino_ = a;
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
