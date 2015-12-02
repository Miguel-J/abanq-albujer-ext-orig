/***************************************************************************
                 masterdatosofertaprov.qs  -  description
                             -------------------
    begin                : mar sep 09 2008
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
  var COL_IDLINEA;
  var COL_REFERENCIA;
  var COL_DESCRIPCION;
  var COL_CANTIDAD;
  var COL_COSTE;
  var COL_DTO;
  var COL_PLAZO;
  var tablaLineas: FLTable;
  var arrayLineas: Array;
  var bloqueoCantidad: Boolean;
  function oficial(context)
  {
    interna(context);
  }
  //  function insertar() {
  //    return this.ctx.oficial_insertar();
  //  }
  //  function refrescarTabla(){
  //    return this.ctx.oficial_refrescarTabla();
  //  }
  //  function insertarLineaTabla(qryLineasOferta:FLSqlQuery):Boolean {
  //    return this.ctx.oficial_insertarLineaTabla(qryLineasOferta);
  //  }
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
  this.iface.tablaLineas = this.child("tblValores");
  this.iface.arrayLineas = [];
  var cursor: FLSqlCursor = this.cursor();

  var pbAccept = this.child("pushButtonAccept");
  disconnect(pbAccept, "clicked()", this.obj(), "accept()");
  connect(pbAccept, "clicked()", this, "iface.insertar()");

  this.iface.refrescarTabla();

  var referencia: String = cursor.valueBuffer("referencia")
  if (referencia && referencia != "") {
    this.child("fdbReferencia").setValue("");
    this.child("fdbReferencia").setValue(referencia);
  }
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
/** \D Compone una tabla de tantas filas como líneas tiene la oferta seleccionada*/
// function oficial_refrescarTabla()
// {
//  var util:FLUtil = new FLUtil;
//  var cursor:FLSqlCursor = this.cursor();
//
//  this.iface.COL_IDLINEA = 0;
//  this.iface.COL_REFERENCIA = 1;
//  this.iface.COL_DESCRIPCION = 2;
//  this.iface.COL_CANTIDAD = 3;
//  this.iface.COL_COSTE = 4;
//  this.iface.COL_DTO = 5;
//  this.iface.COL_PLAZO = 6;
//
//  this.iface.tablaLineas.setNumCols(7);
//  this.iface.tablaLineas.setColumnWidth(this.iface.COL_IDLINEA, 0);
//  this.iface.tablaLineas.setColumnWidth(this.iface.COL_REFERENCIA, 100);
//  this.iface.tablaLineas.setColumnWidth(this.iface.COL_DESCRIPCION, 170);
//  this.iface.tablaLineas.setColumnWidth(this.iface.COL_CANTIDAD, 50);
//  this.iface.tablaLineas.setColumnWidth(this.iface.COL_COSTE, 80);
//  this.iface.tablaLineas.setColumnWidth(this.iface.COL_DTO, 60);
//  this.iface.tablaLineas.setColumnWidth(this.iface.COL_PLAZO, 110);
//
//  this.iface.tablaLineas.setColumnLabels("/", "IdLinea/Referencia/Descripcion/Cant./P.Coste/Dto/Plazo Entrega");
//  this.iface.tablaLineas.setColumnReadOnly(this.iface.COL_REFERENCIA, true);
//  this.iface.tablaLineas.setColumnReadOnly(this.iface.COL_DESCRIPCION, true);
//  this.iface.tablaLineas.setColumnReadOnly(this.iface.COL_CANTIDAD, true);
//  this.iface.tablaLineas.hideColumn(this.iface.COL_IDLINEA);
//
//  var qryLineasOferta:FLSqlQuery = new FLSqlQuery;
//  with (qryLineasOferta) {
//    setTablesList("lineaspresupuestosprov");
//    setSelect("idlinea, referencia, descripcion, cantidad, pvpunitario, dto, plazo");
//    setFrom("lineaspresupuestosprov");
//    setWhere("idpresupuesto = " + cursor.valueBuffer("idpresupuestoprov"));
//    setForwardOnly(true);
//  }
//  if (!qryLineasOferta.exec()) {
//    return false;
//  }
//  while (qryLineasOferta.next()) {
//    if (!this.iface.insertarLineaTabla(qryLineasOferta)) {
//      return false;
//    }
//  }
// }


// function oficial_insertarLineaTabla(qryLineasOferta:FLSqlQuery):Boolean
// {
//  var util:FLUtil = new FLUtil;
//  var numLinea:Number = this.iface.tablaLineas.numRows();
//  this.iface.tablaLineas.insertRows(numLinea);
//
//  this.iface.tablaLineas.setText(numLinea, this.iface.COL_IDLINEA, qryLineasOferta.value("idlinea"));
//  this.iface.tablaLineas.setText(numLinea, this.iface.COL_REFERENCIA, qryLineasOferta.value("referencia"));
//  this.iface.tablaLineas.setText(numLinea, this.iface.COL_DESCRIPCION, qryLineasOferta.value("descripcion"));
//  this.iface.tablaLineas.setText(numLinea, this.iface.COL_CANTIDAD, qryLineasOferta.value("cantidad"));
//  this.iface.tablaLineas.setText(numLinea, this.iface.COL_COSTE, qryLineasOferta.value("pvpunitario"));
//  this.iface.tablaLineas.setText(numLinea, this.iface.COL_DTO, qryLineasOferta.value("dto"));
//  this.iface.tablaLineas.setText(numLinea, this.iface.COL_PLAZO, qryLineasOferta.value("plazo"));
//
//  return true;
// }


// function oficial_insertar()
// {
//  var cursor:FLSqlCursor = this.cursor();
//  var util:FLUtil = new FLUtil;
//  var datos:String = "";
//
//  datos = "<Lineas>\n";
//  for (var i:Number = 0; i < this.iface.tablaLineas.numRows(); i++) {
//    datos += "<Linea IdLinea = '" + this.iface.tablaLineas.text(i,this.iface.COL_IDLINEA) + "' Referencia = '" + this.iface.tablaLineas.text(i,this.iface.COL_REFERENCIA) + "' Descripcion = '" + this.iface.tablaLineas.text(i,this.iface.COL_DESCRIPCION) + "' Cantidad = '" + this.iface.tablaLineas.text(i,this.iface.COL_CANTIDAD) + "' Coste = '" + this.iface.tablaLineas.text(i,this.iface.COL_COSTE) + "' Dto = '" + this.iface.tablaLineas.text(i,this.iface.COL_DTO) + "' Plazo = '" + this.iface.tablaLineas.text(i,this.iface.COL_PLAZO) + "'/>\n";
//  }
//  datos += "</Lineas>";
//
//  cursor.setValueBuffer("datos", datos);
//
//  this.obj().accept();
//
//  MessageBox.information(util.translate("scripts", "Las cantidades indicadas han sido actualizadas correctamente"), MessageBox.Ok, MessageBox.NoButton);
// }

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
