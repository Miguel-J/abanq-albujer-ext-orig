/***************************************************************************
                 masterevalsemestralesprov.qs  -  description
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
  function imprimir()
  {
    return this.ctx.oficial_imprimir();
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
/** \C El botón de plan general contable aparece habilitado cuando está cargado el módulo principal de contabilidad
\end */
function interna_init()
{
  var imprimir: Object = this.child("toolButtonPrint");
  connect(imprimir, "clicked()", this, "iface.imprimir");
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
/** \D Imprime un listado de ejercicios
\end */
function oficial_imprimir()
{
  if (!this.cursor().isValid()) return;

  var q: FLSqlQuery = new FLSqlQuery();

  q.setFrom("proveedores inner join proveedoreseval on proveedores.codproveedor = proveedoreseval.codproveedor inner join evalsemestralesprov on proveedoreseval.idevaluacion = evalsemestralesprov.id");
  q.setTablesList("proveedores,proveedoreseval,evalsemestralesprov");
  q.setSelect("proveedores.codproveedor, nombre, nivelactual, fechaevaluacion, idevaluacion,evalsemestralesprov.periodo");
  q.setWhere("evalsemestralesprov.id = " + this.cursor().valueBuffer("id") + " AND suspendidahomol <> true");
  q.setOrderBy("nivelactual,proveedores.codproveedor");

  q.exec();
  if (!q.size())
    debug("vacio");

  debug(q.sql());

  var rptViewer: FLReportViewer = new FLReportViewer();
  rptViewer.setReportTemplate("seguimientosproveval");
  rptViewer.setReportData(q);
  rptViewer.renderReport();
  rptViewer.exec();
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
