/***************************************************************************
                 masterrecibosprov.qs  -  description
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
  function oficial(context)
  {
    interna(context);
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

/** @class_declaration proveed */
//////////////////////////////////////////////////////////////////
//// PROVEED /////////////////////////////////////////////////////
class proveed extends oficial
{
  function proveed(context)
  {
    oficial(context);
  }
  function imprimir(codRecibo: String)
  {
    return this.ctx.proveed_imprimir(codRecibo)
  }
}
       //// PROVEED /////////////////////////////////////////////////////
       //////////////////////////////////////////////////////////////////

       /** @class_declaration head */
       /////////////////////////////////////////////////////////////////
       //// DESARROLLO /////////////////////////////////////////////////
       class head extends proveed
{
  function head(context)
  {
    proveed(context);
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

function init()
{
  this.iface.init();
}

function interna_init()
{
  var _i = this.iface;
  form.child("tableDBRecords").setEditOnly(true);
  connect(form.child("toolButtonPrint"), "clicked()", this, "iface.imprimir");
  connect(this.child("chkPendientes"), "clicked()", _i, "filtrarTabla");

  _i.filtrarTabla()
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////


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
  return "'Emitido', 'Devuelto', 'Remesado'";
}
//// OFICIAL ////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition proveed */
/////////////////////////////////////////////////////////////////
//// PROVEED ////////////////////////////////////////////////////
/** \D
Crea un informe con el listado de registros de la remesa. Funciona cuando está cargado el módulo de informes
\end */
function proveed_imprimir(codRecibo: String)
{
  if (sys.isLoadedModule("flfactinfo")) {
    var codigo: String;
    if (codRecibo) {
      codigo = codRecibo;
    } else {
      if (!this.cursor().isValid())
        return;
      codigo = this.cursor().valueBuffer("codigo");
    }
    var curImprimir: FLSqlCursor = new FLSqlCursor("i_recibosprov");
    curImprimir.setModeAccess(curImprimir.Insert);
    curImprimir.refreshBuffer();
    curImprimir.setValueBuffer("descripcion", "temp");
    curImprimir.setValueBuffer("d_recibosprov_codigo", codigo);
    curImprimir.setValueBuffer("h_recibosprov_codigo", codigo);
    flfactinfo.iface.pub_lanzarInforme(curImprimir, "i_recibosprov");
  } else
    flfactppal.iface.pub_msgNoDisponible("Informes");
}
//// PROVEED ////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition ifaceCtx */
/////////////////////////////////////////////////////////////////
//// INTERFACE  /////////////////////////////////////////////////

//// INTERFACE  /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
