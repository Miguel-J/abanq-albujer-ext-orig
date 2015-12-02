/***************************************************************************
                 cl_mastermaquinas.qs  -  description
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
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna
{
  var toolButtonReviPend: Object;
  var chkMaquinasActivas: Object;
  var tableDBRecords: Object;

  function oficial(context)
  {
    interna(context);
  }
  function cambiochkMaquinasActivas()
  {
    return this.ctx.oficial_cambiochkMaquinasActivas();
  }
  function informeRevisionesPtes(): Boolean {
    return this.ctx.oficial_informeRevisionesPtes();
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
  this.iface.chkMaquinasActivas = this.child("chkMaquinasActivas");
  this.iface.tableDBRecords = this.child("tableDBRecords")
                              this.iface.toolButtonReviPend = this.child("toolButtonReviPend");

  connect(this.iface.toolButtonReviPend, "clicked()", this, "iface.informeRevisionesPtes");
  connect(this.iface.chkMaquinasActivas, "clicked()", this, "iface.cambiochkMaquinasActivas");
  this.iface.chkMaquinasActivas.checked = true;
  //this.iface.cambiochkMaquinasActivas();
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////

function oficial_cambiochkMaquinasActivas()
{
  var util: FLUtil = new FLUtil();

  if (this.iface.chkMaquinasActivas.checked) {
    this.iface.tableDBRecords.cursor().setMainFilter("debaja = false");
  } else {
    this.iface.tableDBRecords.cursor().setMainFilter("");
  }
  this.iface.tableDBRecords.refresh();
}

function oficial_informeRevisionesPtes(): Boolean {
  var util: FLUtil = new FLUtil;
  var hoy: Date = new Date;

  var qryRevisiones: FLSqlQuery = new FLSqlQuery("i_revisionespendientes");
  qryRevisiones.setWhere("cl_maquinas.estado = 'En funcionamiento' AND CURRENT_DATE + cl_tiposaveriasrevision.diasinteraviso::integer >= cl_tiposrevisionmaquina.fechaproxima");
  qryRevisiones.setOrderBy("cl_tiposrevisionmaquina.fechaproxima, cl_maquinas.codmaquina, cl_tiposrevisionmaquina.codtipo");
  debug(qryRevisiones.sql());
  if (!qryRevisiones.exec())
  {
    return false;
  }

  var rptViewer: FLReportViewer = new FLReportViewer();
  rptViewer.setReportTemplate("i_revisionespendientes");
  rptViewer.setReportData(qryRevisiones);
  rptViewer.renderReport();
  rptViewer.exec();

  return true;
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
