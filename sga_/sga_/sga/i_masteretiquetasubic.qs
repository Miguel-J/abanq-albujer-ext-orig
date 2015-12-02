/***************************************************************************
                 i_masteretiquetasubic.qs  -  description
                             -------------------
    begin                : jun jue 05 2008
    copyright            : (C) 2008 by InfoSiAL S.L.
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
  var cursor: FLSqlCursor = this.cursor();
  var masWhere: String = "1 = 1";
  var ubicaciones: String = "";
  var util: FLUtil = new FLUtil();

  var impresora: String = flfactppal.iface.pub_valorDefectoEmpresa("impresoraeti");
  if (!impresora || impresora == "") {
    MessageBox.warning(util.translate("scripts", "Para imprimir etiquetas debe definir antes el nombre de la impresora en el formulario de empresa"), MessageBox.Ok, MessageBox.NoButton);
    return;
  }
  var codZona: String = cursor.valueBuffer("codzona");
  if (codZona && codZona != "")
    masWhere += " AND codzona = '" + codZona + "'";
  var codEstanteria: String = cursor.valueBuffer("i_ubicaciones_codestanteria");
  if (codEstanteria && codEstanteria != "")
    masWhere += " AND codestanteria = '" + codEstanteria + "'";
  var estanteDesde: String = cursor.valueBuffer("d_ubicaciones_estante");
  if (estanteDesde && estanteDesde != "")
    masWhere += " AND estante >= '" + estanteDesde + "'";
  var estanteHasta: String = cursor.valueBuffer("h_ubicaciones_estante");
  if (estanteHasta && estanteHasta != "")
    masWhere += " AND estante <= '" + estanteHasta + "'";
  var alturaDesde: String = cursor.valueBuffer("d_ubicaciones_altura");
  if (alturaDesde && alturaDesde != "")
    masWhere += " AND altura >= '" + alturaDesde + "'";
  var alturaHasta: String = cursor.valueBuffer("h_ubicaciones_altura");
  if (alturaHasta && alturaHasta != "")
    masWhere += " AND altura <= '" + alturaHasta + "'";
  var codUbicacion: String = cursor.valueBuffer("codubicacion");
  if (codUbicacion && codUbicacion != "")
    masWhere += " AND codubicacion = '" + codUbicacion + "'";

  var qryUbicaciones: FLSqlQuery = new FLSqlQuery();
  qryUbicaciones.setTablesList("ubicaciones");
  qryUbicaciones.setSelect("codubicacion");
  qryUbicaciones.setFrom("ubicaciones");
  qryUbicaciones.setWhere(masWhere);
  if (!qryUbicaciones.exec())
    return false;

  while (qryUbicaciones.next()) {
    ubicaciones += "\nN \nB15,15,0,3,3,7,180,N,\"" +
                   qryUbicaciones.value("codubicacion") + "\"\nA110,195,0,5,1,1,N,\"" +
                   qryUbicaciones.value("codubicacion") + "\"\nP1";
  }
  File.write("tmpUbi.txt", ubicaciones);
  Process.execute("lpr tmpUbi.txt -oraw -P " + impresora + " -l");
  if (Process.stderr != "") {
    MessageBox.warning(util.translate("scripts", "Hubo un error al imprimir las etiquetas: %1").arg(Process.stderr), MessageBox.Ok, MessageBox.NoButton);
  } else {
    MessageBox.information(util.translate("scripts", "Impresión de etiquetas lanzada"), MessageBox.Ok, MessageBox.NoButton);
  }
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////


/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
////////////////////////////////////////////////////////////////