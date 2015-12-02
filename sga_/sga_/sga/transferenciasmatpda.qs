/***************************************************************************
                 transferenciasmatpda.qs  -  description
                             -------------------
    begin                : jue jun 05 2008
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
  var arrayUbicacionesOrigen: Array;
  var arrayUbicacionesDestino: Array;
  var posArrayOrigen: Number;
  var posArrayDestino: Number;
  var cantidadRestante: Number = 0;
  var codTransferencia: String = "";
  var ubiOrigenActual: Number;

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
  function buscarUbicacionesOrigen()
  {
    return this.ctx.oficial_buscarUbicacionesOrigen();
  }
  function buscarUbicacionesDestino()
  {
    return this.ctx.oficial_buscarUbicacionesDestino();
  }
  function siguienteUbicacionOrigen()
  {
    return this.ctx.oficial_siguienteUbicacionOrigen();
  }
  function mostrarUbicacionOrigen()
  {
    return this.ctx.oficial_mostrarUbicacionOrigen();
  }
  function siguienteUbicacionDestino()
  {
    return this.ctx.oficial_siguienteUbicacionDestino();
  }
  function mostrarUbicacionDestino()
  {
    return this.ctx.oficial_mostrarUbicacionDestino();
  }
  function buscarUbicacionManualDestino()
  {
    return this.ctx.oficial_buscarUbicacionManualDestino();
  }
  function tbnFin_clicked()
  {
    return this.ctx.oficial_tbnFin_clicked();
  }
  function tbnFinContinue_clicked()
  {
    return this.ctx.oficial_tbnFinContinue_clicked();
  }
  function guardar(continuar: Boolean)
  {
    return this.ctx.oficial_guardar(continuar);
  }
  function crearSalida(cantidadEntrada: Number): Boolean {
    return this.ctx.oficial_crearSalida(cantidadEntrada);
  }
  function crearEntrada(): Number {
    return this.ctx.oficial_crearEntrada();
  }
  function validarUbiSalida(): Boolean {
    return this.ctx.oficial_validarUbiSalida();
  }
  function regularizarEntrada()
  {
    return this.ctx.oficial_regularizarEntrada();
  }
  function regularizarSalida()
  {
    return this.ctx.oficial_regularizarSalida();
  }
  function bufferChanged(fN: String)
  {
    return this.ctx.oficial_bufferChanged(fN);
  }
  function localizarUbiOrigenAnterior()
  {
    return this.ctx.oficial_localizarUbiOrigenAnterior();
  }
  function limpiarVariables()
  {
    return this.ctx.oficial_limpiarVariables();
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
  this.child("fdbCodUbicacionDestino").setDisabled(true);
  this.child("fdbCantidad").setDisabled(true);
  this.child("ledB").text = "1";
  connect(this.child("ledArticulo"), "returnPressed()", this, "iface.buscarArticulo");
  connect(this.child("pbnBuscar1"), "clicked()", this, "iface.mostrarArticuloManual");
  connect(this.child("ledA"), "returnPressed()", this, "iface.calcularCantidad");
  connect(this.child("pbnSiguienteUbiOrigen"), "clicked()", this, "iface.siguienteUbicacionOrigen");
  connect(this.child("pbnSiguienteUbiDestino"), "clicked()", this, "iface.siguienteUbicacionDestino");
  connect(this.child("pbnBuscar3"), "clicked()", this, "iface.buscarUbicacionManualDestino");
  connect(this.child("pbnRegularizacionEnt"), "clicked()", this, "iface.regularizarEntrada");
  connect(this.child("pbnRegularizacionSal"), "clicked()", this, "iface.regularizarSalida");
  connect(this.child("tbnFin"), "clicked()", this, "iface.tbnFin_clicked");
  connect(this.child("tbnFinContinue"), "clicked()", this, "iface.tbnFinContinue_clicked");
  connect(this.cursor(), "bufferChanged(QString)", this, "iface.bufferChanged");
  connect(this, "closed()", this, "iface.limpiarVariables");


  this.child("pushButtonAccept").close();
  this.child("pushButtonAcceptContinue").close();


  if (this.iface.cantidadRestante || this.iface.cantidadRestante != 0) {
    this.child("txtTransferenciaMaterial").text = "TRANSFERENCIA MATERIAL RESTANTE";
    this.child("ledCantidadActDestino").text = "";
    if (this.iface.idArticuloActual && this.iface.idArticuloActual != "") {
      this.child("ledArticulo").text = this.iface.idArticuloActual;
      this.iface.buscarArticulo();
      this.iface.localizarUbiOrigenAnterior();
      this.child("ledA").text = this.iface.cantidadRestante;
      this.iface.calcularCantidad();
    }
  } else {
    this.child("ledArticulo").text = "";
    this.child("ledDesArticulo").text = "";
    this.child("ledA").text = "";
    this.child("ledCodUbicacionOrigen").text = "";
    this.child("ledCantidadActOrigen").text = "";
    this.child("ledCantidadActDestino").text = "";
  }
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
  var id: String = this.child("ledArticulo").text;
  var datosArticulo: Array = flfactalma.iface.pub_buscarArticulo(id);

  if (datosArticulo["error"])
    return false;

  if (!datosArticulo["encontrado"])
    return false;

  this.child("ledDesArticulo").text = datosArticulo["descripcion"];
  this.child("ledB").text = datosArticulo["canenvase"];
  this.iface.referenciaActual = datosArticulo["referencia"];

  this.child("ledA").setFocus();
  this.iface.buscarUbicacionesOrigen();
  this.iface.buscarUbicacionesDestino();
  this.iface.posArrayOrigen = 0;
  this.iface.posArrayDestino = 0;
  this.iface.mostrarUbicacionOrigen();
}

function oficial_mostrarArticuloManual()
{
  var idArticulo: String = flfactalma.iface.pub_buscarArticuloManual();
  if (!idArticulo || idArticulo == "")
    return;
  this.child("ledArticulo").text = idArticulo;
  this.iface.buscarArticulo();
}

function oficial_calcularCantidad()
{
  this.child("fdbCantidad").setValue(this.iface.calculateField("cantidad"));
  this.child("pbnSiguienteUbiOrigen").setFocus();
}

function oficial_buscarUbicacionesOrigen()
{
  this.iface.arrayUbicacionesOrigen = [];
  var util: FLUtil = new FLUtil();
  var qryUbicaciones: FLSqlQuery = new FLSqlQuery();

  qryUbicaciones.setTablesList("ubicacionesarticulo");
  qryUbicaciones.setSelect("id, codubicacion, cantidadactual, capacidadmax");
  qryUbicaciones.setFrom("ubicacionesarticulo");
  qryUbicaciones.setWhere("referencia = '" + this.iface.referenciaActual + "'");

  if (!qryUbicaciones.exec())
    return false;

  var indice: Number = 0;
  while (qryUbicaciones.next()) {
    this.iface.arrayUbicacionesOrigen[indice] = [];
    this.iface.arrayUbicacionesOrigen[indice]["id"] = qryUbicaciones.value("id");
    this.iface.arrayUbicacionesOrigen[indice]["codubicacion"] = qryUbicaciones.value("codubicacion");
    this.iface.arrayUbicacionesOrigen[indice]["cantidadactual"] = util.roundFieldValue(qryUbicaciones.value("cantidadactual"), "ubicacionesarticulo", "cantidadactual");
    this.iface.arrayUbicacionesOrigen[indice]["capacidadmax"] = util.roundFieldValue(qryUbicaciones.value("capacidadmax"), "ubicacionesarticulo", "capacidadmax");
    indice++;
  }
}

function oficial_buscarUbicacionesDestino()
{
  this.iface.arrayUbicacionesDestino = [];
  var util: FLUtil = new FLUtil();
  var qryUbicaciones: FLSqlQuery = new FLSqlQuery();

  qryUbicaciones.setTablesList("ubicacionesarticulo");
  qryUbicaciones.setSelect("id, codubicacion, cantidadactual, capacidadmax");
  qryUbicaciones.setFrom("ubicacionesarticulo");
  qryUbicaciones.setWhere("referencia = '" + this.iface.referenciaActual + "'");

  if (!qryUbicaciones.exec())
    return false;

  var indice: Number = 0;
  while (qryUbicaciones.next()) {
    this.iface.arrayUbicacionesDestino[indice] = [];
    this.iface.arrayUbicacionesDestino[indice]["id"] = qryUbicaciones.value("id");
    this.iface.arrayUbicacionesDestino[indice]["codubicacion"] = qryUbicaciones.value("codubicacion");
    this.iface.arrayUbicacionesDestino[indice]["cantidadactual"] = util.roundFieldValue(qryUbicaciones.value("cantidadactual"), "ubicacionesarticulo", "cantidadactual");
    this.iface.arrayUbicacionesDestino[indice]["capacidadmax"] = util.roundFieldValue(qryUbicaciones.value("capacidadmax"), "ubicacionesarticulo", "capacidadmax");
    indice++;
  }
}

function oficial_siguienteUbicacionOrigen()
{
  if (!this.iface.arrayUbicacionesOrigen)
    return;

  if (this.iface.arrayUbicacionesOrigen.length == 0)
    return;

  this.iface.posArrayOrigen ++;
  if (this.iface.posArrayOrigen >= this.iface.arrayUbicacionesOrigen.length) {
    this.iface.posArrayOrigen = 0;
  }
  this.iface.mostrarUbicacionOrigen();
}

/** \D Muestra las cantidades actual y máxima de la ubicación origen seleccionada
\end */
function oficial_mostrarUbicacionOrigen()
{
  if (this.iface.arrayUbicacionesOrigen.length == 0) {
    this.child("ledCodUbicacionOrigen").text = "";
    this.child("ledCantidadActOrigen").text = "";
    return;
  }

  this.child("ledCodUbicacionOrigen").text =  this.iface.arrayUbicacionesOrigen[this.iface.posArrayOrigen]["codubicacion"];
  this.child("ledCantidadActOrigen").text = this.iface.arrayUbicacionesOrigen[this.iface.posArrayOrigen]["cantidadactual"] + " / " + this.iface.arrayUbicacionesOrigen[this.iface.posArrayOrigen]["capacidadmax"];
}

function oficial_siguienteUbicacionDestino()
{
  if (!this.iface.arrayUbicacionesDestino)
    return;

  if (this.iface.arrayUbicacionesDestino.length == 0)
    return;

  this.iface.posArrayDestino ++;
  if (this.iface.posArrayDestino >= this.iface.arrayUbicacionesDestino.length) {
    this.iface.posArrayDestino = 0;
  }

  this.iface.mostrarUbicacionDestino();
}

/** \D Muestra las cantidades actual y máxima de la ubicación destino seleccionada
\end */
function oficial_mostrarUbicacionDestino()
{
  var cursor: FLSqlCursor = this.cursor();
  if (this.iface.arrayUbicacionesDestino.length == 0) {
    this.child("fdbCodUbicacionDestino").setValue("");
    this.child("ledCantidadActDestino").text = "";
    return;
  }
  this.child("fdbIdUbicacionDestino").setValue(this.iface.arrayUbicacionesDestino[this.iface.posArrayDestino]["id"]);
  this.child("fdbCodUbicacionDestino").setValue(this.iface.arrayUbicacionesDestino[this.iface.posArrayDestino]["codubicacion"]);
  this.child("ledCantidadActDestino").text = this.iface.arrayUbicacionesDestino[this.iface.posArrayDestino]["cantidadactual"] + " / " + this.iface.arrayUbicacionesDestino[this.iface.posArrayDestino]["capacidadmax"];

}

function oficial_buscarUbicacionManualDestino()
{
  var idUbicacion: String = flfactalma.iface.pub_crearUbicacion(this.iface.referenciaActual);
  if (!idUbicacion)
    return false;
  this.iface.buscarUbicacionesDestino();
  var i: Number;
  for (i = 0; i < this.iface.arrayUbicacionesDestino.length; i++) {
    if (this.iface.arrayUbicacionesDestino[i]["id"] == idUbicacion)
      break;
  }
  if (i >= this.iface.arrayUbicacionesDestino.length)
    return;
  this.iface.posArrayDestino = i;
  this.iface.mostrarUbicacionDestino();

}

function oficial_guardar(continuar: Boolean)
{
  var util: FLUtil = new FLUtil();
  var cursor: FLSqlCursor = new FLSqlCursor("ubicacionesarticulo");

  this.iface.ubiOrigenActual = this.iface.arrayUbicacionesOrigen[this.iface.posArrayOrigen]["id"];
  if (!this.iface.referenciaActual) {
    this.close();
    return false;
  }

  if (!this.iface.validarUbiSalida())
    return false;

  cursor.transaction(false);
  var cantidadEntrada: Number;
  try {
    cantidadEntrada = this.iface.crearEntrada();
    if (!cantidadEntrada) {
      cursor.rollback();
      return false;
    }

    if (!this.iface.crearSalida(cantidadEntrada)) {
      cursor.rollback();
      return false;
    }
    cursor.commit();
  } catch (e) {
    cursor.rollback();
    MessageBox.critical(util.translate("scripts", "Hubo un error al generar la transferencia: ") + e, MessageBox.Ok, MessageBox.NoButton);
  }
  if (this.iface.cantidadRestante == 0) {
    if (continuar == false)
      this.accept();
    else
      this.child("pushButtonAcceptContinue").animateClick();
  } else
    this.child("pushButtonAcceptContinue").animateClick();
}

function oficial_tbnFin_clicked()
{
  this.iface.guardar(false);
}

function oficial_tbnFinContinue_clicked()
{
  this.iface.guardar(true);
}


function oficial_crearEntrada(): Number {
  var util: FLUtil = new FLUtil();
  var cursor: FLSqlCursor = this.cursor();

  if (!this.iface.referenciaActual)
    return false;

  var qryUbicaciones: FLSqlQuery = new FLSqlQuery;
  with(qryUbicaciones)
  {
    setTablesList("ubicacionesarticulo");
    setSelect("capacidadmax, cantidadactual");
    setFrom("ubicacionesarticulo");
    setWhere("id = " + cursor.valueBuffer("idubiarticulo"));
    setForwardOnly(true);
  }
  if (!qryUbicaciones.exec())
    return false;

  if (!qryUbicaciones.first())
  {
    return false;
  }

  var capacidadMaxima: Number = parseFloat(qryUbicaciones.value("capacidadmax"));
  if (!capacidadMaxima || isNaN(capacidadMaxima))
    capacidadMaxima = 0;

  var cantidadActual: Number = parseFloat(qryUbicaciones.value("cantidadactual"));
  if (!cantidadActual || isNaN(cantidadActual))
    cantidadActual = 0;

  var cantidad = parseFloat(cursor.valueBuffer("cantidad"));
  if (!cantidad  || isNaN(cantidad))
    cantidad  = 0;

  var cantidadATransferir: Number = capacidadMaxima - cantidadActual;
  if (cantidadATransferir == 0)
  {
    MessageBox.warning(util.translate("scripts", "No hay disponibilidad de espacio en la ubicación de destino.\nModifique la capacidad máxima de esta ubicación o seleccione otra."), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  if (cantidad > cantidadATransferir)
  {
    var respuesta: Number = MessageBox.information(util.translate("scripts", "La ubicación especificada no tiene capacidad para toda la cantidad.\n¿Desea continuar transfiriendo únicamente %1 unidades?").arg(cantidadATransferir), MessageBox.Yes, MessageBox.No);
    if (respuesta != MessageBox.Yes)
      return false;

    this.iface.idArticuloActual = this.child("ledArticulo").text;
    this.iface.cantidadRestante = cantidad - (capacidadMaxima - cantidadActual);
    cantidad = capacidadMaxima - cantidadActual;
  } else {
    this.iface.cantidadRestante = 0;
    this.iface.idArticuloActual = "";
  }

  this.iface.codTransferencia = util.nextCounter("codtransferencia", cursor);

  var hoy: Date = new Date();
  cursor.setValueBuffer("tipo", "Entrada");
  cursor.setValueBuffer("usuario", sys.nameUser());
  cursor.setValueBuffer("fecha", hoy);
  cursor.setValueBuffer("hora", hoy.toString().right(8));
  cursor.setValueBuffer("referencia", this.iface.referenciaActual);
  cursor.setValueBuffer("cantidad", cantidad);
  cursor.setValueBuffer("codtransferencia", this.iface.codTransferencia);
  cursor.setValueBuffer("idubiarticulo", this.iface.arrayUbicacionesDestino[this.iface.posArrayDestino]["id"]);
  cursor.setValueBuffer("codubicacion", this.iface.arrayUbicacionesDestino[this.iface.posArrayDestino]["codubicacion"]);

  return cantidad;
}


function oficial_crearSalida(cantidadEntrada: Number): Boolean {
  var util: FLUtil = new FLUtil();
  var curSalida: FLSqlCursor = new FLSqlCursor("movimat");

  curSalida.setModeAccess(curSalida.Insert);
  curSalida.refreshBuffer();

  var hoy: Date = new Date();
  curSalida.setValueBuffer("idubiarticulo", this.iface.arrayUbicacionesOrigen[this.iface.posArrayOrigen]["id"]);
  curSalida.setValueBuffer("codubicacion", this.iface.arrayUbicacionesOrigen[this.iface.posArrayOrigen]["codubicacion"]);
  curSalida.setValueBuffer("tipo", "Salida");
  curSalida.setValueBuffer("usuario", sys.nameUser());
  curSalida.setValueBuffer("fecha", hoy);
  curSalida.setValueBuffer("hora", hoy.toString().right(8));
  curSalida.setValueBuffer("referencia", this.iface.referenciaActual);
  curSalida.setValueBuffer("cantidad", (cantidadEntrada * -1));
  curSalida.setValueBuffer("codtransferencia", this.iface.codTransferencia);

  if (!curSalida.commitBuffer())
    return false;

  return true;
}

function oficial_validarUbiSalida(): Boolean {
  var util: FLUtil = new FLUtil;

  if (this.child("fdbCantidad").value() == "")
  {
    MessageBox.information(util.translate("scripts", "Debe establecer una cantidad distinta de 0"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }

  var idUbicacion: Number = this.iface.arrayUbicacionesOrigen[this.iface.posArrayOrigen]["id"];
  var cantidadActual: String = parseFloat(util.sqlSelect("ubicacionesarticulo", "cantidadactual", "id = " + idUbicacion));
  if (!cantidadActual || isNaN(cantidadActual))
    cantidadActual = 0;
  var cantidad: Number = this.child("ledA").text;
  if (!cantidad || isNaN(cantidad))
    cantidad = 0;

  if (cantidad > cantidadActual)
  {
    MessageBox.information(util.translate("scripts", "La ubicación especificada no se puede seleccionar. \nLa cantidad de material es inferior a la cantidad establecida."), MessageBox.Ok, MessageBox.NoButton);
    this.child("pbnSiguienteUbiOrigen").setFocus();
    return false;
  }

  return true;
}

function oficial_regularizarEntrada()
{
  var valores: Array = [];
  valores["idArticulo"] = this.child("ledArticulo").text;
  valores["id"] = this.iface.arrayUbicacionesOrigen[this.iface.posArrayOrigen]["id"];
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
  this.iface.buscarUbicacionesOrigen();
  this.iface.mostrarUbicacionOrigen();
}

function oficial_regularizarSalida()
{
  var valores: Array = [];
  valores["idArticulo"] = this.child("ledArticulo").text;
  valores["id"] = this.iface.arrayUbicacionesDestino[this.iface.posArrayDestino]["id"];
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
  this.iface.buscarUbicacionesDestino();
  this.iface.mostrarUbicacionDestino();
}

function oficial_bufferChanged(fN: String)
{
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  switch (fN) {
    case "idubiarticulo": {
      var i: Number;
      for (i = 0; i < this.iface.arrayUbicacionesDestino.length; i++) {
        if (this.iface.arrayUbicacionesDestino[i]["id"] == cursor.valueBuffer("idubiarticulo"))
          break;
      }
      if (i >= this.iface.arrayUbicacionesDestino.length)
        return;
      this.iface.posArrayDestino = i;
      var capMax: Number = util.sqlSelect("ubicacionesarticulo", "capacidadmax", "id = " + cursor.valueBuffer("idubiarticulo"));
      this.iface.arrayUbicacionesDestino[i]["capacidadmax"] = util.roundFieldValue(capMax, "ubicacionesarticulo", "capacidadmax");
      this.iface.mostrarUbicacionDestino();
      break;
    }
  }
}

function oficial_localizarUbiOrigenAnterior()
{
  var i: Number;
  for (i = 0; i < this.iface.arrayUbicacionesOrigen.length; i++) {
    if (this.iface.arrayUbicacionesOrigen[i]["id"] == this.iface.ubiOrigenActual)
      break;
  }
  if (i >= this.iface.arrayUbicacionesOrigen.length)
    return;
  this.iface.posArrayOrigen = i;
  this.iface.mostrarUbicacionOrigen();
}

function oficial_limpiarVariables()
{
  this.iface.cantidadRestante = 0;
  this.iface.referenciaActual = "";
  this.iface.barcodeActual = "";
  this.iface.idArticuloActual = "";
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
//////////////////////////////////////////////////////////////