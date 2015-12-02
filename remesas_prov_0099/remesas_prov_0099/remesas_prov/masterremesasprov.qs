/***************************************************************************
                      masterremesas_prov.qs  -  description
                             -------------------
    begin                : jue dic 21 2006
    copyright            : (C) 2006 by InfoSiAL S.L.
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
  function imprimir()
  {
    return this.ctx.oficial_imprimir();
  }
  function filtrarTabla()
  {
    return this.ctx.oficial_filtrarTabla();
  }
  function filtroTabla()
  {
    return this.ctx.oficial_filtroTabla();
  }
  function dameEstadosPtes()
  {
    return this.ctx.oficial_dameEstadosPtes();
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
  var _i = this.iface;

  connect(this.child("toolButtonPrint"), "clicked()", this, "iface.imprimir");
  connect(this.child("chkPendientes"), "clicked()", _i, "filtrarTabla");

  _i.filtrarTabla()
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
/** \D Crea un informe con el listado de registros de la remesa. Funciona cuando está cargado el módulo de informes
\end */
function oficial_imprimir()
{
  if (this.cursor().size() == 0)
    return;

  if (sys.isLoadedModule("flfactinfo")) {
    var idRemesa: Number = this.cursor().valueBuffer("idremesa");
    var curImprimir: FLSqlCursor = new FLSqlCursor("i_recibosprov");
    curImprimir.setModeAccess(curImprimir.Insert);
    curImprimir.refreshBuffer();
    curImprimir.setValueBuffer("descripcion", "temp");
    flfactinfo.iface.pub_lanzarInforme(curImprimir, "i_resrecibosprov", "recibosprov.codigo", "", false, false, "idrecibo IN (SELECT idrecibo FROM pagosdevolprov WHERE idremesa = " + idRemesa + ")");
  } else
    flfactppal.iface.pub_msgNoDisponible("Informes");
}

function oficial_filtrarTabla()
{
  var _i = this.iface;
  var filtro = _i.filtroTabla();
  this.cursor().setMainFilter(filtro);
  this.child("tableDBRecords").refresh();
  return true;
}

function oficial_filtroTabla()
{
  var _i = this.iface;
  var filtro = "";
  var ptes = this.child("chkPendientes").checked;
  if (ptes) {
    filtro = "estado IN (" + _i.dameEstadosPtes() + ")";
  }
  return filtro;
}

function oficial_dameEstadosPtes()
{
  return "'Emitida'";
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
