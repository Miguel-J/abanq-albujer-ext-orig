
/** @class_declaration sgaBarcode */
/////////////////////////////////////////////////////////////////
//// SGA_BARCODE ////////////////////////////////////////////////
class sgaBarcode extends oficial
{
  var barcodeActual: String;
  function sgaBarcode(context)
  {
    oficial(context);
  }
  function buscarArticulo()
  {
    return this.ctx.sgaBarcode_buscarArticulo();
  }
  function buscarUbicacionesOrigen()
  {
    return this.ctx.sgaBarcode_buscarUbicacionesOrigen();
  }
  function buscarUbicacionesDestino()
  {
    return this.ctx.sgaBarcode_buscarUbicacionesDestino();
  }
  function crearSalida(cantidadEntrada: Number): Boolean {
    return this.ctx.sgaBarcode_crearSalida(cantidadEntrada);
  }
  function crearEntrada(): Number {
    return this.ctx.sgaBarcode_crearEntrada();
  }
  function buscarUbicacionManualDestino()
  {
    return this.ctx.sgaBarcode_buscarUbicacionManualDestino();
  }
}
//// SGA_BARCODE ////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition sgaBarcode */
/////////////////////////////////////////////////////////////////
//// SGA_BARCODE ///////////////////////////////////////////////
function sgaBarcode_buscarArticulo()
{
  var util: FLUtil = new FLUtil();
  var id: String = this.child("ledArticulo").text;
  var datosArticulo: Array = flfactalma.iface.pub_buscarArticulo(id);

  if (datosArticulo["error"])
    return false;

  if (!datosArticulo["encontrado"])
    return false;

  this.child("ledDesArticulo").text = datosArticulo["descripcion"];
  this.child("ledTalla").text = datosArticulo["talla"];
  this.child("ledColor").text = datosArticulo["color"];
  this.child("ledB").text = datosArticulo["canenvase"];
  this.iface.referenciaActual = datosArticulo["referencia"];
  this.iface.barcodeActual = datosArticulo["barcode"];

  this.child("ledA").setFocus();
  this.iface.buscarUbicacionesOrigen();
  this.iface.buscarUbicacionesDestino();
  this.iface.posArrayOrigen = 0;
  this.iface.posArrayDestino = 0;
  this.iface.mostrarUbicacionOrigen();
}

function sgaBarcode_buscarUbicacionesOrigen()
{
  this.iface.arrayUbicacionesOrigen = [];
  var util: FLUtil = new FLUtil();
  var qryUbicaciones: FLSqlQuery = new FLSqlQuery();

  qryUbicaciones.setTablesList("ubicacionesarticulo");
  qryUbicaciones.setSelect("id, codubicacion, cantidadactual, capacidadmax");
  qryUbicaciones.setFrom("ubicacionesarticulo");
  qryUbicaciones.setWhere("referencia = '" + this.iface.referenciaActual + "'");

  if (this.iface.barcodeActual && this.iface.barcodeActual != "")
    qryUbicaciones.setWhere("barcode = '" + this.iface.barcodeActual + "'");
  else
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

function sgaBarcode_buscarUbicacionesDestino()
{
  if (this.iface.barcodeActual && !this.iface.referenciaActual)
    this.child("fdbIdUbicacionDestino").setFilter("barcode = '" + this.iface.barcodeActual + "'");

  else if (this.iface.referenciaActual)
    this.child("fdbIdUbicacionDestino").setFilter("barcode = '" + this.iface.barcodeActual + "'");

  this.iface.arrayUbicacionesDestino = [];
  var util: FLUtil = new FLUtil();
  var qryUbicaciones: FLSqlQuery = new FLSqlQuery();

  qryUbicaciones.setTablesList("ubicacionesarticulo");
  qryUbicaciones.setSelect("id, codubicacion, cantidadactual, capacidadmax");
  qryUbicaciones.setFrom("ubicacionesarticulo");
  qryUbicaciones.setWhere("referencia = '" + this.iface.referenciaActual + "'");

  if (this.iface.barcodeActual && this.iface.barcodeActual != "")
    qryUbicaciones.setWhere("barcode = '" + this.iface.barcodeActual + "'");
  else
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

function sgaBarcode_crearEntrada(): Number {
  var util: FLUtil = new FLUtil();
  var cursor: FLSqlCursor = this.cursor();

  if (this.iface.barcodeActual && !this.iface.referenciaActual)
  {
    this.iface.referenciaActual = util.sqlSelect("atributosarticulos", "referencia", "barcode = '" + this.iface.barcodeActual + "'");
    if (!this.iface.referenciaActual)
      return false;
  }

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
  var talla: String = util.sqlSelect("atributosarticulos", "talla", "barcode = '" + this.iface.barcodeActual + "'");
  var color: String = util.sqlSelect("atributosarticulos", "color", "barcode = '" + this.iface.barcodeActual + "'");

  cursor.setValueBuffer("tipo", "Entrada");
  cursor.setValueBuffer("usuario", sys.nameUser());
  cursor.setValueBuffer("fecha", hoy);
  cursor.setValueBuffer("hora", hoy.toString().right(8));
  cursor.setValueBuffer("referencia", this.iface.referenciaActual);
  cursor.setValueBuffer("barcode", this.iface.barcodeActual);
  cursor.setValueBuffer("talla", talla);
  cursor.setValueBuffer("color", color);
  cursor.setValueBuffer("cantidad", cantidad);
  cursor.setValueBuffer("codtransferencia", this.iface.codTransferencia);
  cursor.setValueBuffer("idubiarticulo", this.iface.arrayUbicacionesDestino[this.iface.posArrayDestino]["id"]);
  cursor.setValueBuffer("codubicacion", this.iface.arrayUbicacionesDestino[this.iface.posArrayDestino]["codubicacion"]);

  return cantidad;
}


function sgaBarcode_crearSalida(cantidadEntrada: Number): Boolean {
  var util: FLUtil = new FLUtil();
  var curSalida: FLSqlCursor = new FLSqlCursor("movimat");

  curSalida.setModeAccess(curSalida.Insert);
  curSalida.refreshBuffer();

  var hoy: Date = new Date();
  var talla: String = util.sqlSelect("atributosarticulos", "talla", "barcode = '" + this.iface.barcodeActual + "'");
  var color: String = util.sqlSelect("atributosarticulos", "color", "barcode = '" + this.iface.barcodeActual + "'");

  curSalida.setValueBuffer("idubiarticulo", this.iface.arrayUbicacionesOrigen[this.iface.posArrayOrigen]["id"]);
  curSalida.setValueBuffer("codubicacion", this.iface.arrayUbicacionesOrigen[this.iface.posArrayOrigen]["codubicacion"]);
  curSalida.setValueBuffer("tipo", "Salida");
  curSalida.setValueBuffer("usuario", sys.nameUser());
  curSalida.setValueBuffer("fecha", hoy);
  curSalida.setValueBuffer("hora", hoy.toString().right(8));
  curSalida.setValueBuffer("referencia", this.iface.referenciaActual);
  curSalida.setValueBuffer("barcode", this.iface.barcodeActual);
  curSalida.setValueBuffer("talla", talla);
  curSalida.setValueBuffer("color", color);
  curSalida.setValueBuffer("cantidad", (cantidadEntrada * -1));
  curSalida.setValueBuffer("codtransferencia", this.iface.codTransferencia);

  if (!curSalida.commitBuffer())
    return false;

  return true;
}

function sgaBarcode_buscarUbicacionManualDestino()
{
  var idUbicacion: String = flfactalma.iface.pub_crearUbicacion(this.iface.referenciaActual, this.iface.barcodeActual);
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

//// SGA_BARCODE ///////////////////////////////////////////////
//////////////////////////////////////////////////////////////
