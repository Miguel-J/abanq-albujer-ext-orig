
/** @class_declaration sgaBarcode */
/////////////////////////////////////////////////////////////////
//// SGA_BARCODE ///////////////////////////////////////////////
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
  function mostrarArticuloManual()
  {
    return this.ctx.sgaBarcode_mostrarArticuloManual();
  }
  function buscarUbicaciones()
  {
    return this.ctx.sgaBarcode_buscarUbicaciones();
  }
  function guardarSalida(continuar: Boolean)
  {
    return this.ctx.sgaBarcode_guardarSalida(continuar);
  }
}
//// SGA_BARCODE ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition sgaBarcode */
/////////////////////////////////////////////////////////////////
//// SGA_BARCODE ////////////////////////////////////////////////
function sgaBarcode_buscarArticulo()
{
  var util: FLUtil = new FLUtil();
  var codBarras: String = this.child("ledArticulo").text;
  var datosArticulo: Array = flfactalma.iface.pub_buscarArticulo(codBarras);

  if (datosArticulo["error"])
    return false;

  if (!datosArticulo["encontrado"])
    return false;

  this.child("ledDesArticulo").text = datosArticulo["descripcion"];
  this.child("ledTalla").text = datosArticulo["talla"];
  this.child("ledColor").text = datosArticulo["color"];
  this.child("ledB").text = datosArticulo["canenvase"];
  this.iface.barcodeActual = datosArticulo["barcode"];
  this.iface.referenciaActual = datosArticulo["referencia"];
  this.child("ledReferencia").text = this.iface.referenciaActual;

  this.child("ledA").setFocus();
  this.iface.buscarUbicaciones();
  this.iface.posArray = 0;
  this.iface.mostrarUbicacion();
}

function sgaBarcode_mostrarArticuloManual()
{
  var util: FLUtil = new FLUtil();
  var codBarras: String = flfactalma.iface.pub_buscarArticuloManual();
  if (!codBarras || codBarras == "")
    return;
  this.child("ledArticulo").text = codBarras;
  var talla: String = util.sqlSelect("atributosarticulos", "talla", "barcode = '" + codBarras + "'");
  if (!talla)
    talla = "";
  var color: String = util.sqlSelect("atributosarticulos", "color", "barcode = '" + codBarras + "'");
  if (!color)
    color = "";
  this.child("ledTalla").text = talla;
  this.child("ledColor").text = color;

  this.iface.buscarArticulo();
}

function sgaBarcode_buscarUbicaciones()
{
  if (this.iface.barcodeActual && !this.iface.referenciaActual)
    this.child("fdbIdUbicacion").setFilter("barcode = '" + this.iface.barcodeActual + "'");
  else if (this.iface.referenciaActual)
    this.child("fdbIdUbicacion").setFilter("referencia = '" + this.iface.referenciaActual + "'");

  this.iface.arrayUbicaciones = [];
  var util: FLUtil = new FLUtil();
  var qryUbicaciones: FLSqlQuery = new FLSqlQuery();
  qryUbicaciones.setTablesList("ubicacionesarticulo");
  qryUbicaciones.setSelect("id, codubicacion, cantidadactual, capacidadmax");
  qryUbicaciones.setFrom("ubicacionesarticulo");
  if (this.iface.barcodeActual && this.iface.barcodeActual != "")
    qryUbicaciones.setWhere("barcode = '" + this.iface.barcodeActual + "'");
  else
    qryUbicaciones.setWhere("referencia = '" + this.iface.referenciaActual + "'");

  if (!qryUbicaciones.exec())
    return false;

  var indice: Number = 0;
  while (qryUbicaciones.next()) {
    this.iface.arrayUbicaciones[indice] = [];
    this.iface.arrayUbicaciones[indice]["id"] = qryUbicaciones.value("id");
    this.iface.arrayUbicaciones[indice]["codubicacion"] = qryUbicaciones.value("codubicacion");
    this.iface.arrayUbicaciones[indice]["cantidadactual"] = util.roundFieldValue(qryUbicaciones.value("cantidadactual"), "ubicacionesarticulo", "cantidadactual");
    this.iface.arrayUbicaciones[indice]["capacidadmax"] = util.roundFieldValue(qryUbicaciones.value("capacidadmax"), "ubicacionesarticulo", "capacidadmax");
    indice++;
  }
}

function sgaBarcode_guardarSalida(continuar: Boolean)
{
  var util: FLUtil = new FLUtil();
  var cursor: FLSqlCursor = this.cursor();

  if (this.iface.barcodeActual && !this.iface.referenciaActual) {
    this.iface.referenciaActual = util.sqlSelect("atributosarticulos", "referencia", "barcode = '" + this.iface.barcodeActual + "'");
    if (!this.iface.referenciaActual)
      return false;
  }

  var qryUbicaciones: FLSqlQuery = new FLSqlQuery;
  with(qryUbicaciones) {
    setTablesList("ubicacionesarticulo");
    setSelect("capacidadmax, cantidadactual");
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
  var cantidad = parseFloat(cursor.valueBuffer("cantidad"));
  if (!cantidad || isNaN(cantidad))
    cantidad = 0;

  if (cantidad > cantidadActual) {
    var respuesta: Number = MessageBox.information(util.translate("scripts", "La ubicación especificada no contiene suficiente material.\n¿Desea continuar?"), MessageBox.Yes, MessageBox.No);
    if (respuesta != MessageBox.Yes)
      return;

    this.iface.idArticuloActual = this.child("ledArticulo").text;
    if (this.iface.idArticuloActual.length == 14) {
      var ledA: Number = parseFloat(this.child("ledA").text);
      var capEnvase: Number = parseFloat(this.child("ledB").text);
      var salen: Number = cantidadActual;
      cantidad = (salen - (salen % capEnvase));
      if (cantidad == 0)
        return false;
      this.iface.cantidadRestante = ledA - (cantidad / capEnvase);
    } else {
      this.iface.cantidadRestante = cantidad - cantidadActual;
      cantidad = cantidadActual;
    }
  } else {
    this.iface.cantidadRestante = 0;
    this.iface.idArticuloActual = "";
  }

  cantidad = parseFloat(cantidad) * -1;
  var hoy: Date = new Date();
  var talla: String = util.sqlSelect("atributosarticulos", "talla", "barcode = '" + this.iface.barcodeActual + "'");
  var color: String = util.sqlSelect("atributosarticulos", "color", "barcode = '" + this.iface.barcodeActual + "'");
  cursor.setValueBuffer("tipo", "Salida");
  cursor.setValueBuffer("usuario", sys.nameUser());
  cursor.setValueBuffer("fecha", hoy);
  cursor.setValueBuffer("hora", hoy.toString().right(8));
  cursor.setValueBuffer("referencia", this.iface.referenciaActual);
  cursor.setValueBuffer("barcode", this.iface.barcodeActual);
  cursor.setValueBuffer("talla", talla);
  cursor.setValueBuffer("color", color);
  cursor.setValueBuffer("cantidad", cantidad);
  cursor.setValueBuffer("idubiarticulo", this.iface.arrayUbicaciones[this.iface.posArray]["id"]);
  cursor.setValueBuffer("codubicacion", this.iface.arrayUbicaciones[this.iface.posArray]["codubicacion"]);


  if (this.iface.cantidadRestante == 0) {
    if (continuar == false)
      this.accept();
    else
      this.child("pushButtonAcceptContinue").animateClick();
  } else
    this.child("pushButtonAcceptContinue").animateClick();

  return true;
}

//// SGA_BARCODE ////////////////////////////////////////////////
//////////////////////////////////////////////////////////////
