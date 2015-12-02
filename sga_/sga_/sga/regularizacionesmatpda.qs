/***************************************************************************
                 regularizacionesmatpda.qs  -  description
                             -------------------
    begin                : mar abr 10 2007
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
  function calculateField(fN: String): String {
    return this.ctx.interna_calculateField(fN);
  }
  function validateForm(): Boolean {
    return this.ctx.interna_validateForm();
  }
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna
{

  var referenciaActual: String = "";
  var idArticuloActual: String = "";
  var arrayUbicaciones: Array;
  var posArray: Number;
  var cantidadRestante: Number = 0;

  function oficial(context)
  {
    interna(context);
  }
  function calcularCantidad()
  {
    return this.ctx.oficial_calcularCantidad();
  }
  function datosUbicacion()
  {
    return this.ctx.oficial_datosUbicacion();
  }
  function tbnFin_clicked()
  {
    return this.ctx.oficial_tbnFin_clicked();
  }
  function tbnFinContinue_clicked()
  {
    return this.ctx.oficial_tbnFinContinue_clicked();
  }
  function crearMovimiento(continuar: Boolean)
  {
    return this.ctx.oficial_crearMovimiento(continuar);
  }
  function calcularDiferencia()
  {
    return this.ctx.oficial_calcularDiferencia();
  }
  function bufferChanged(fN: String)
  {
    return this.ctx.oficial_bufferChanged(fN);
  }
  function mostrarArticuloUbicacion()
  {
    return this.ctx.oficial_mostrarArticuloUbicacion();
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
  this.child("pbnBuscar").close();
  var cursor: FLSqlCursor = this.cursor();
  var util: FLUtil = new FLUtil();
  this.child("ledAxB").text = "";
  this.child("ledB").text = "1";
  this.child("ledMotivoRegularizacion").text = "Regularización ordinaria";
  this.child("ledDiferencia").text = "";

  connect(this.child("ledA"), "returnPressed()", this, "iface.calcularCantidad");
  connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");
  connect(this.child("tbnFin"), "clicked()", this, "iface.tbnFin_clicked");
  connect(this.child("tbnFinContinue"), "clicked()", this, "iface.tbnFinContinue_clicked");
  this.child("pushButtonAccept").close();
  if (this.child("pushButtonAcceptContinue"))
    this.child("pushButtonAcceptContinue").close();

  var valores: Array = flfactalma.iface.pub_obtenerValoresRegMat();
  if (valores) {
    flfactalma.iface.pub_establecerValoresRegMat(false);
    this.child("ledDiferencia").text = "";
    this.child("ledArticulo").text = valores["idArticulo"];
    this.child("fdbIdUbicacion").setValue(valores["id"]);
    this.iface.datosUbicacion();
  }
  if (!this.iface.cantidadRestante || this.iface.cantidadRestante == 0) {
    this.child("ledCantidadAct").text = "";
    this.child("ledArticulo").text = "";
    this.child("ledDesArticulo").text = "";
    this.child("ledA").text = "";
    this.child("ledAxB").text = "";
    this.child("ledDiferencia").text = "";

  }
  this.iface.bufferChanged("idubiarticulo");
}

function interna_calculateField(fN: String): String {
  var valor: String = "";
  switch (fN)
  {
    case "cantidad": {
      valor = parseFloat(this.child("ledA").text) * parseFloat(this.child("ledB").text);
      break;
    }
  }
  return valor;
}

function interna_validateForm(): Boolean {
  return true;
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////

function oficial_mostrarArticuloUbicacion()
{
  var cursor: FLSqlCursor = this.cursor();
  var idUbicacion: String = cursor.valueBuffer("idubiarticulo");

  var q: FLSqlQuery = new FLSqlQuery();
  q.setTablesList("ubicacionesarticulo");
  q.setSelect("referencia");
  q.setFrom("ubicacionesarticulo");
  q.setWhere("id = " + idUbicacion);
  if (!q.exec())
    return;

  if (q.first()) {
    if (q.value("referencia") && q.value("referencia") != "") {
      var qryArticulo: FLSqlQuery = new FLSqlQuery();
      qryArticulo.setTablesList("articulos");
      qryArticulo.setSelect("descripcion");
      qryArticulo.setFrom("articulos");
      qryArticulo.setWhere("referencia = '" + q.value("referencia") + "'");
      if (!qryArticulo.exec())
        return;

      if (qryArticulo.first()) {
        this.child("ledArticulo").text = q.value("referencia");
        this.child("ledDesArticulo").text = qryArticulo.value("descripcion");
        this.iface.referenciaActual = q.value("referencia");
      }
    }
  }
  this.iface.datosUbicacion();
  this.child("ledA").setFocus();
}

function oficial_calcularCantidad()
{
  this.child("ledAxB").text = this.iface.calculateField("cantidad");
  this.iface.calcularDiferencia();
}

function oficial_datosUbicacion()
{
  this.iface.arrayUbicaciones = [];
  this.iface.posArray = 0;
  var util: FLUtil = new FLUtil();
  var cursor: FLSqlCursor = this.cursor();

  var qryUbicaciones: FLSqlQuery = new FLSqlQuery();
  qryUbicaciones.setTablesList("ubicacionesarticulo");
  qryUbicaciones.setSelect("id, codubicacion, capacidadmax, cantidadactual, referencia");
  qryUbicaciones.setFrom("ubicacionesarticulo");
  qryUbicaciones.setWhere("id = " + cursor.valueBuffer("idubiarticulo"));
  if (!qryUbicaciones.exec())
    return false;

  if (qryUbicaciones.first()) {
    this.child("ledCantidadAct").text =  util.roundFieldValue(qryUbicaciones.value("cantidadactual"), "ubicacionesarticulo", "cantidadactual") + " / " +  util.roundFieldValue(qryUbicaciones.value("capacidadmax"), "ubicacionesarticulo", "capacidadmax");
  }
}

function oficial_crearMovimiento(continuar)
{
  var cursor: FLSqlCursor = this.cursor();
  var util: FLUtil = new FLUtil();
  var hoy: Date = new Date();
  var diferencia: String = this.child("ledDiferencia").text;

  if (!this.iface.referenciaActual)
    return false;

  if (this.child("ledDiferencia").text == "") {
    MessageBox.information(util.translate("scripts", "Debe establecer una cantidad distinta de 0"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }

  var idUbicacion: String = cursor.valueBuffer("idubiarticulo");
  var codUbicacion: String = util.sqlSelect("ubicacionesarticulo", "codubicacion", "id = " + idUbicacion);
  cursor.setValueBuffer("tipo", "Regularización");
  cursor.setValueBuffer("usuario", sys.nameUser())
  cursor.setValueBuffer("fecha", hoy);
  cursor.setValueBuffer("hora", hoy.toString().right(8));
  cursor.setValueBuffer("referencia", this.iface.referenciaActual);
  cursor.setValueBuffer("codubicacion", codUbicacion);
  cursor.setValueBuffer("idubiarticulo", idUbicacion);
  cursor.setValueBuffer("descripcion", this.child("ledMotivoRegularizacion").text);

  if (this.child("ledDiferencia").text > 0) {
    cursor.setValueBuffer("cantidad", diferencia);
  } else {
    cursor.setValueBuffer("cantidad", diferencia);
  }

  if (continuar == false)
    this.accept();
  else
    this.child("pushButtonAcceptContinue").animateClick();
}

function oficial_tbnFin_clicked()
{
  this.iface.crearMovimiento(false);
}

function oficial_tbnFinContinue_clicked()
{
  this.iface.crearMovimiento(true);
}

function oficial_calcularDiferencia()
{
  var util: FLUtil = new FLUtil();
  if (!this.child("ledA") || (this.child("ledA").text == "")) {
    this.child("ledDiferencia").text = "";
    return;
  }

  var idUbicacion: String = this.child("fdbIdUbicacion").value();
  var cantidadActual: String = util.sqlSelect("ubicacionesarticulo", "cantidadactual", "id = " + idUbicacion);
  var nuevaCantidad: String = this.child("ledAxB").text;
  var diferencia: String = parseFloat(nuevaCantidad - cantidadActual);

  this.child("ledDiferencia").text = diferencia;
}

function oficial_bufferChanged(fN: String)
{
  switch (fN) {
    case "idubiarticulo": {
      this.iface.mostrarArticuloUbicacion();
      this.iface.datosUbicacion();
      break;
    }
  }
}


// OFICIAL ////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////

/** @class_definition head */
///////////////////////////////////////////////////////////////
// DESARROLLO /////////////////////////////////////////////////

// DESARROLLO /////////////////////////////////////////////////
///////////////////////////////////////////////////////////////