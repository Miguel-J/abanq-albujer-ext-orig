/***************************************************************************
                 entradasmatpda.qs  -  description
                             -------------------
    begin                : jue may 29 2008
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
  var barcodeActual: String = "";
  var idArticuloActual: String = "";
  var arrayUbicaciones: Array;
  var posArray: Number;
  var cantidadRestante: Number = 0;

  function oficial(context)
  {
    interna(context);
  }
  function buscarArticulo()
  {
    return this.ctx.oficial_buscarArticulo();
  }
  function mostrarArticuloManual()
  {
    return this.ctx.oficial_mostrarArticuloManual();
  }
  function calcularCantidad()
  {
    return this.ctx.oficial_calcularCantidad();
  }
  function buscarUbicaciones()
  {
    return this.ctx.oficial_buscarUbicaciones();
  }
  function mostrarUbicacion()
  {
    return this.ctx.oficial_mostrarUbicacion();
  }
  function siguienteUbicacion()
  {
    return this.ctx.oficial_siguienteUbicacion();
  }
  function buscarUbicacionManual()
  {
    return this.ctx.oficial_buscarUbicacionManual();
  }
  function tbnFin_clicked()
  {
    return this.ctx.oficial_tbnFin_clicked();
  }
  function tbnFinContinue_clicked()
  {
    return this.ctx.oficial_tbnFinContinue_clicked();
  }
  function guardarEntrada(continuar: Boolean)
  {
    return this.ctx.oficial_guardarEntrada(continuar);
  }
  function regularizar()
  {
    return this.ctx.oficial_regularizar();
  }
  function bufferChanged(fN: String)
  {
    return this.ctx.oficial_bufferChanged(fN);
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
  var cursor: FLSqlCursor = this.cursor();
  this.child("fdbCodUbicacion").setDisabled(true);
  this.child("fdbCantidad").setDisabled(true);
  this.child("ledB").text = "1";
  connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");
  connect(this.child("ledArticulo"), "returnPressed()", this, "iface.buscarArticulo");
  connect(this.child("ledA"), "returnPressed()", this, "iface.calcularCantidad");
  connect(this.child("pbnBuscar"), "clicked()", this, "iface.mostrarArticuloManual");
  connect(this.child("pbnSiguienteUbi"), "clicked()", this, "iface.siguienteUbicacion");
  connect(this.child("pbnRegularizacion"), "clicked()", this, "iface.regularizar");
  connect(this.child("pbnBuscar2"), "clicked()", this, "iface.buscarUbicacionManual");
  connect(this.child("tbnFin"), "clicked()", this, "iface.tbnFin_clicked");
  connect(this.child("tbnFinContinue"), "clicked()", this, "iface.tbnFinContinue_clicked");
  this.child("pushButtonAccept").close();
  this.child("pushButtonAcceptContinue").close();

  if (this.iface.cantidadRestante || this.iface.cantidadRestante != 0) {

    this.child("ledCantidadAct").text = "";
    this.child("txtEntradaMaterial").text = "ENTRADA MATERIAL RESTANTE";
    if (this.iface.idArticuloActual && this.iface.idArticuloActual != "") {
      this.child("ledArticulo").text = this.iface.idArticuloActual;
      this.iface.buscarArticulo();
      this.child("ledA").text = this.iface.cantidadRestante;
      this.iface.calcularCantidad();
    }
  } else {
    this.child("ledArticulo").text = "";
    this.child("ledReferencia").text = "";
    this.child("ledDesArticulo").text = "";
    this.child("ledA").text = "";
    this.child("ledCantidadAct").text = "";
  }

  var hoy: Date = new Date();
  cursor.setValueBuffer("fecha", hoy);
  cursor.setValueBuffer("hora", hoy.toString().right(8));

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
function oficial_buscarArticulo()
{
  var util: FLUtil = new FLUtil();
  var codBarras: String = this.child("ledArticulo").text;
  var datosArticulo: Array = flfactalma.iface.pub_buscarArticulo(codBarras);

  if (datosArticulo["error"])
    return false;

  if (!datosArticulo["encontrado"])
    return false;

  this.child("ledDesArticulo").text = datosArticulo["descripcion"];
  this.child("ledB").text = datosArticulo["canenvase"];
  this.iface.referenciaActual = datosArticulo["referencia"];
  this.child("ledReferencia").text = this.iface.referenciaActual;

  this.child("ledA").setFocus();
  this.iface.buscarUbicaciones();
  this.iface.posArray = 0;
  this.iface.mostrarUbicacion();

}

function oficial_mostrarArticuloManual()
{
  var codBarras: String = flfactalma.iface.pub_buscarArticuloManual();
  if (!codBarras || codBarras == "")
    return;
  this.child("ledArticulo").text = codBarras;
  this.iface.buscarArticulo();
}

function oficial_calcularCantidad()
{
  this.child("fdbCantidad").setValue(this.iface.calculateField("cantidad"));
  this.child("pbnSiguienteUbi").setFocus();
}

function oficial_buscarUbicaciones()
{
  if (this.iface.arrayUbicaciones) {
    delete this.iface.arrayUbicaciones;
  }
  this.iface.arrayUbicaciones = [];
  var util: FLUtil = new FLUtil();
  var qryUbicaciones: FLSqlQuery = new FLSqlQuery();
  qryUbicaciones.setTablesList("ubicacionesarticulo");
  qryUbicaciones.setSelect("id, codubicacion, capacidadmax, cantidadactual");
  qryUbicaciones.setFrom("ubicacionesarticulo");
  qryUbicaciones.setWhere("referencia = '" + this.iface.referenciaActual + "'");

  if (!qryUbicaciones.exec())
    return false;

  var indice: Number = 0;
  while (qryUbicaciones.next()) {
    this.iface.arrayUbicaciones[indice] = [];
    this.iface.arrayUbicaciones[indice]["id"] = qryUbicaciones.value("id");
    this.iface.arrayUbicaciones[indice]["capacidadmax"] = util.roundFieldValue(qryUbicaciones.value("capacidadmax"), "ubicacionesarticulo", "capacidadmax");
    this.iface.arrayUbicaciones[indice]["cantidadactual"] = util.roundFieldValue(qryUbicaciones.value("cantidadactual"), "ubicacionesarticulo", "cantidadactual");
    indice++;
  }
}

function oficial_siguienteUbicacion()
{
  if (!this.iface.arrayUbicaciones)
    return;

  if (this.iface.arrayUbicaciones.length == 0)
    return;

  this.iface.posArray ++;
  if (this.iface.posArray >= this.iface.arrayUbicaciones.length) {
    this.iface.posArray = 0;
  }
  this.iface.mostrarUbicacion();
}

/** \D Muestra las cantidades actual y máxima de la ubicación seleccionada
\end */
function oficial_mostrarUbicacion()
{
  if (this.iface.arrayUbicaciones.length == 0) {
    this.child("fdbIdUbicacion").setValue("");
    this.child("fdbCodUbicacion").setValue("");
    this.child("ledCantidadAct").text = "";
    return;
  }
  this.child("fdbIdUbicacion").setValue(this.iface.arrayUbicaciones[this.iface.posArray]["id"]);
  this.child("ledCantidadAct").text = this.iface.arrayUbicaciones[this.iface.posArray]["cantidadactual"] + " / " + this.iface.arrayUbicaciones[this.iface.posArray]["capacidadmax"];
}

function oficial_buscarUbicacionManual()
{
  var idUbicacion: String = flfactalma.iface.pub_crearUbicacion(this.iface.referenciaActual);

  if (!idUbicacion)
    return false;

  this.iface.buscarUbicaciones();
  var i: Number;
  for (i = 0; i < this.iface.arrayUbicaciones.length; i++) {
    if (this.iface.arrayUbicaciones[i]["id"] == idUbicacion)
      break;
  }
  if (i >= this.iface.arrayUbicaciones.length)
    return;
  this.iface.posArray = i;
  this.iface.mostrarUbicacion();
}

function oficial_guardarEntrada(continuar: Boolean)
{
  var util: FLUtil = new FLUtil();
  var cursor: FLSqlCursor = this.cursor();

  if (!this.iface.referenciaActual)
    return false;

  var qryUbicaciones: FLSqlQuery = new FLSqlQuery;
  with(qryUbicaciones) {
    setTablesList("ubicacionesarticulo");
    setSelect("capacidadmax, cantidadactual, codubicacion, id");
    setFrom("ubicacionesarticulo");
    setWhere("id = " + cursor.valueBuffer("idubiarticulo"));
    setForwardOnly(true);
  }
  if (!qryUbicaciones.exec())
    return false;

  if (!qryUbicaciones.first())
    return false;

  if (this.child("fdbCantidad").value() == "") {
    MessageBox.information(util.translate("scripts", "Debe establecer una cantidad distinta de 0"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }

  var capacidadMaxima: Number = parseFloat(qryUbicaciones.value("capacidadmax"));
  if (!capacidadMaxima || isNaN(capacidadMaxima))
    capacidadMaxima = 0;
  var cantidadActual: Number = parseFloat(qryUbicaciones.value("cantidadactual"));
  if (!cantidadActual || isNaN(cantidadActual))
    cantidadActual = 0;
  var cantidad = cursor.valueBuffer("cantidad");

  if (cantidad > (capacidadMaxima - cantidadActual)) {
    var respuesta: Number = MessageBox.information(util.translate("scripts", "La ubicación especificada no tiene capacidad para toda la cantidad.\n¿Desea continuar?"), MessageBox.Yes, MessageBox.No);
    if (respuesta != MessageBox.Yes)
      return;
    this.iface.idArticuloActual = this.child("ledArticulo").text;
    this.iface.cantidadRestante = cantidad - (capacidadMaxima - cantidadActual);
    cantidad = capacidadMaxima - cantidadActual;
  } else {
    this.iface.cantidadRestante = 0;
    this.iface.idArticuloActual = "";
  }
  var codUbicacion: String = util.sqlSelect("ubicacionesarticulo", "codubicacion", "id = " + qryUbicaciones.value("id"));

  var hoy: Date = new Date();
  cursor.setValueBuffer("tipo", "Entrada");
  cursor.setValueBuffer("usuario", sys.nameUser());
  cursor.setValueBuffer("fecha", hoy);
  cursor.setValueBuffer("hora", hoy.toString().right(8));
  cursor.setValueBuffer("referencia", this.iface.referenciaActual);
  cursor.setValueBuffer("cantidad", cantidad);
  cursor.setValueBuffer("idubiarticulo", this.iface.arrayUbicaciones[this.iface.posArray]["id"]);
  cursor.setValueBuffer("codubicacion", codUbicacion);

  if (this.iface.cantidadRestante == 0) {
    if (continuar == false)
      this.accept();
    else
      this.child("pushButtonAcceptContinue").animateClick();
  } else
    this.child("pushButtonAcceptContinue").animateClick();

  return true;
}

function oficial_tbnFin_clicked()
{
  this.iface.guardarEntrada(false);
}

function oficial_tbnFinContinue_clicked()
{
  this.iface.guardarEntrada(true);
}

function oficial_regularizar()
{
  var valores: Array = [];
  valores["idArticulo"] = this.child("ledArticulo").text;
  valores["id"] = this.child("fdbIdUbicacion").value();
  flfactalma.iface.pub_establecerValoresRegMat(valores);

  var f: Object = new FLFormSearchDB("regularizacionesmatpda");
  var curReg: FLSqlCursor = f.cursor();
  curReg.setModeAccess(curReg.Insert);
  curReg.refreshBuffer();

  f.setMainWidget();
  var codMovimiento: String = f.exec("codmovimiento");
  if (!codMovimiento)
    return;

  curReg.commitBuffer();
  this.iface.buscarUbicaciones();
  this.iface.mostrarUbicacion();
}

function oficial_bufferChanged(fN: String)
{
  var cursor: FLSqlCursor = this.cursor();

  switch (fN) {
    case "idubiarticulo": {
      var i: Number;
      for (i = 0; i < this.iface.arrayUbicaciones.length; i++) {
        if (this.iface.arrayUbicaciones[i]["id"] == cursor.valueBuffer("idubiarticulo"))
          break;
      }
      if (i >= this.iface.arrayUbicaciones.length)
        return;
      this.iface.posArray = i;
      this.iface.mostrarUbicacion();
      break;
    }
  }
}


//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
//////////////////////////////////////////////////////////////