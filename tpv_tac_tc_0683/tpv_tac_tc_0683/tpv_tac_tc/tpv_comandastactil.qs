
/** @class_declaration tallCol */
/////////////////////////////////////////////////////////////////
//// TALLAS Y COLORES ///////////////////////////////////////////
class tallCol extends oficial
{
  var tipoArticulo_; /// Indica si el artículo seleccionado es una artículo o un barcode
  var aArticuloTC_; /// Array con los datos del artículo
  function tallCol(context)
  {
    oficial(context);
  }
  function clickedTabla(fil, col)
  {
    return this.ctx.tallCol_clickedTabla(fil, col);
  }
  function construirArrayArticulosTC(aArticulo)
  {
    return this.ctx.tallCol_construirArrayArticulosTC(aArticulo);
  }
  function mostrarPaginaTC(aArticulo)
  {
    return this.ctx.tallCol_mostrarPaginaTC(aArticulo);
  }
  function buscarEnArray(patron, aArray)
  {
    return this.ctx.tallCol_buscarEnArray(patron, aArray);
  }
  function dameIndiceTC(aBarcodes, fila, col)
  {
    return this.ctx.tallCol_dameIndiceTC(aBarcodes, fila, col);
  }
  function probarInsercionLineaTC()
  {
    return this.ctx.tallCol_probarInsercionLineaTC();
  }
  function datosIdArticuloLineaVenta(aArticulo)
  {
    return this.ctx.tallCol_datosIdArticuloLineaVenta(aArticulo);
  }
  function construirArrayArticulos(nivel)
  {
    return this.ctx.tallCol_construirArrayArticulos(nivel);
  }
  function mostrarPagina()
  {
    return this.ctx.tallCol_mostrarPagina();
  }
  function tbnOK_clicked()
  {
    return this.ctx.tallCol_tbnOK_clicked();
  }
  function nivelAnterior()
  {
    return this.ctx.tallCol_nivelAnterior();
  }
  function tbnStock_clicked()
  {
    return this.ctx.tallCol_tbnStock_clicked();
  }
}
//// TALLAS Y COLORES ///////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition tallCol */
/////////////////////////////////////////////////////////////////
//// TALLAS Y COLORES ///////////////////////////////////////////
function tallCol_clickedTabla(fil: Number, col: Number)
{
  var tipo;
  var indice;
  debug("this.iface.tipoArticulo_ " + this.iface.tipoArticulo_);
  if (this.iface.tipoArticulo_ == "barcode") {
    tipo = "barcode";
  } else {
    indice = this.iface.dameIndiceCelda(fil, col);
    if (indice < 0) {
      return false;
    }
    tipo = this.iface.arrayArticulos[this.iface.nivelActual][indice]["tipo"];
  }
  debug("tipo " + tipo);
  switch (tipo) {
    case "articulo": {
      if (!this.iface.construirArrayArticulosTC(this.iface.arrayArticulos[this.iface.nivelActual][indice])) {
        this.iface.__clickedTabla(fil, col);
      }
      break;
    }
    case "barcode": {
      if (this.iface.secuenciaLinea_ == "Cantidad_Referencia") {
        if (!this.iface.probarInsercionLineaTC()) {
          break;
        }
        this.iface.modificarCantidad(1);
      }
      break;
    }
    default : {
      this.iface.__clickedTabla(fil, col);
    }
  }
}

function tallCol_construirArrayArticulosTC(aArticulo)
{
  var util = new FLUtil;
  if (!util.sqlSelect("atributosarticulos", "barcode", "referencia = '" + aArticulo["id"] + "'")) {
    return false;
  }
  this.iface.tipoArticulo_ = "barcode";

  //  aArticulo["numtallas"] = util.sqlSelect("atributosarticulos", "COUNT(DISTINCT(talla))", "referencia = '" + aArticulo["id"] + "'");
  var qryBarcode = new FLSqlQuery;
  qryBarcode.setTablesList("atributosarticulos");
  qryBarcode.setSelect("barcode, talla, color");
  qryBarcode.setFrom("atributosarticulos");
  qryBarcode.setWhere("referencia = '" + aArticulo["id"] + "' ORDER by talla, color");
  qryBarcode.setForwardOnly(true);
  var aTallas = [], aColores = [], aBarcodes = [], aBarcode = [];
  var iTalla = 0, iColor = 0;
  var maxTalla = "", maxColor = "";
  var talla, color;
  if (!qryBarcode.exec()) {
    return false;
  }
  while (qryBarcode.next()) {
    talla = qryBarcode.value("talla");
    color = qryBarcode.value("color");
    if (talla > maxTalla || maxTalla == "") {
      aTallas.push(talla);
      maxTalla = talla;
      debug("Añado talla " + talla);
    }
    if (color > maxColor || maxColor == "") {
      aColores.push(color);
      maxColor = color;
      debug("Añado color " + color);
    }
    aBarcode = [];
    aBarcode["id"] = qryBarcode.value("barcode");
    aBarcode["talla"] = talla;
    aBarcode["color"] = color;
    aBarcode["x"] = this.iface.buscarEnArray(talla, aTallas);
    aBarcode["y"] = this.iface.buscarEnArray(color, aColores);
    debug("barcode en x = " + aBarcode["x"] + " y = " + aBarcode["y"]);
    aBarcodes.push(aBarcode);
  }
  aArticulo["tc"] = aBarcodes;
  aArticulo["tallas"] = aTallas;
  aArticulo["colores"] = aColores;
  this.iface.aArticuloTC_ = aArticulo;
  if (!this.iface.mostrarPaginaTC()) {
    return false;
  }
  return true;
}

function tallCol_buscarEnArray(patron, aArray)
{
  if (!aArray || aArray.length == 0) {
    return -1;
  }
  for (var i = 0; i < aArray.length; i++) {
    if (aArray[i] == patron) {
      return i;
    }
  }
  return -1;
}

function tallCol_dameIndiceTC(aBarcodes, fila, col)
{
  if (!aBarcodes || aBarcodes.length == 0) {
    return -1;
  }
  for (var i = 0; i < aBarcodes.length; i++) {
    if (aBarcodes[i]["x"] == col && aBarcodes[i]["y"] == fila) {
      return i;
    }
  }
  return -1;
}

function tallCol_mostrarPaginaTC()
{
  aArticulo = this.iface.aArticuloTC_;
  var aBarcodes = aArticulo["tc"];
  var aTallas = aArticulo["tallas"];
  var aColores = aArticulo["colores"];

  this.iface.tableArticulos.clear();

  var sizeTabla = this.child("gbxArticulos").size;
  var anchoTC = sizeTabla.width - 5; /// Evita que la pantalla crezca en cada selección
  var altoTC = sizeTabla.height - 5;

  var indice = 0;
  var numFilas = aColores.length;
  var numCols = aTallas.length;
  var alto = altoTC / numFilas;
  var ancho = anchoTC / numCols;
  debug("numFilas " + numFilas);
  debug("numCols " + numCols);

  var pixSize: Size, pixScaleAlto: Number, pixScaleAncho: Number;
  this.iface.tableArticulos.setNumRows(numFilas);
  this.iface.tableArticulos.setNumCols(numCols);
  for (var f = 0; f < numFilas; f++) {
    //    this.iface.tableArticulos.insertRows(f);
    this.iface.tableArticulos.setRowHeight(f, alto);
    for (var c = 0; c < numCols; c++) {
      this.iface.tableArticulos.setColumnWidth(c, ancho);
      indice = this.iface.dameIndiceTC(aBarcodes, f, c);
      //      if(this.iface.arrayArticulos[this.iface.nivelActual].length > indice) {
      if (indice >= 0) {
        //        var pic = new Picture;
        //        var pixNew = new Pixmap;
        //        var clr = new Color;
        //
        //        clr.setRgb(255,255,255);
        //        pixNew.resize(ancho, alto );
        //        pixNew.fill(clr);
        //
        //        pic.begin();
        //        pic.drawPixmap(0, 0, pixNew);
        //
        //        var pixOrig = sys.toPixmap(this.iface.arrayArticulos[this.iface.nivelActual][indice]["imagen"]);
        //        pixSize = pixOrig.size;
        //        if (pixSize.width && pixSize.height) {
        //
        //          pixScaleAlto = (alto - 25) / pixSize.height;
        //          debug("pixScaleAlto " + pixScaleAlto + " = alto " + alto + "/ pixSize.height " + pixSize.height);;
        //          pixScaleAncho = (ancho - 10) / pixSize.width;
        //          pixScaleAlto = 1;
        //          pixScaleAncho = 1;
        //          if (pixScaleAncho > pixScaleAlto) {
        //            pixScaleAncho = pixScaleAlto;
        //          } else {
        //            pixScaleAlto = pixScaleAncho;
        //          }
        //          pic.scale(pixScaleAncho, pixScaleAlto);
        //          debug("5 + ((ancho - 10 - (pixSize.width * pixScaleAncho)) / 2)");
        //          var x= 5 + ((ancho - 10 - (pixSize.width * pixScaleAncho)) / 2);
        //          debug("5 + ((" + ancho + " - 10 - (" + pixSize.width + " * " + pixScaleAncho + ")) / 2) = " + x);
        //          pic.drawPixmap((5 + ((ancho - 10 - (pixSize.width)) / 2)) / pixScaleAncho, 5, pixOrig);
        //        }
        //        pixNew = pic.playOnPixmap(pixNew);
        //        pic.end();
        //
        //        pic.begin();
        //        pic.drawText(5, alto - 5, this.iface.arrayArticulos[this.iface.nivelActual][indice]["desc"]);
        //        pixNew = pic.playOnPixmap(pixNew);
        //        pic.end();

        //        this.iface.tableArticulos.setPixmap(f, c, pixNew);
        this.iface.tableArticulos.setText(f, c, aBarcodes[indice]["talla"] + " x " + aBarcodes[indice]["color"]);
        //        this.iface.tableArticulos.setPixmap(f,c,sys.toPixmap(this.iface.arrayArticulos[this.iface.nivelActual][indice]["imagen"]));
      } else {
        this.iface.tableArticulos.setText(f, c, "");
      }
    }
  }
}

/** \D Comprueba si es posible insertar una línea, y si no es, se hace
\end */
function tallCol_probarInsercionLineaTC()
{
  var util = new FLUtil;
  aArticulo = this.iface.aArticuloTC_;
  if (!aArticulo) {
    MessageBox.warning(util.translate("scripts", "No hay un artículo de tallas y colores seleccionado"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  var aBarcodes = aArticulo["tc"];

  var cantidad = parseFloat(this.iface.tlbCantidad.text);
  if (!cantidad || cantidad == 0) {
    return false;
  }
  var fil = this.iface.tableArticulos.currentRow();
  var col = this.iface.tableArticulos.currentColumn();
  indice = this.iface.dameIndiceTC(aBarcodes, fil, col);
  if (indice < 0) {
    return false;
  }
  var aArtTC = [];
  aArtTC["referencia"] = aArticulo["id"];
  if (!aArtTC["referencia"] || aArtTC["referencia"] == "") {
    return false;
  }
  aArtTC["barcode"] = aBarcodes[indice]["id"];
  if (!aArtTC["barcode"] || aArtTC["barcode"] == "") {
    return false;
  }
  this.iface.insertarLinea(aArtTC, cantidad);
  this.iface.modificarCantidad(10); /// CE
  if (this.iface.volverNivelBase_) {
    this.iface.construirArrayArticulos(this.iface.nivelOrigen);
  }
  return true;
}

function tallCol_datosIdArticuloLineaVenta(aArticulo)
{
  var util = new FLUtil;
  if (!this.iface.__datosIdArticuloLineaVenta(aArticulo)) {
    return false;
  }
  var barcode;
  try {
    barcode = aArticulo["barcode"];
  } catch (e) {
    barcode == "";
  }
  if (barcode && barcode != "") {
    this.iface.curLineas.setValueBuffer("barcode", barcode);
    this.iface.curLineas.setValueBuffer("talla", util.sqlSelect("atributosarticulos", "talla", "barcode = '" + barcode + "'"));
    this.iface.curLineas.setValueBuffer("color", util.sqlSelect("atributosarticulos", "color", "barcode = '" + barcode + "'"));
  }
  return true;
}

function tallCol_construirArrayArticulos(nivel)
{
  this.iface.tipoArticulo_ = "referencia";

  debug("this.iface.tipoArticulo_ " + this.iface.tipoArticulo_);
  return this.iface.__construirArrayArticulos(nivel);
}

function tallCol_mostrarPagina()
{
  this.iface.tipoArticulo_ = "referencia";
  return this.iface.__mostrarPagina();
}

function tallCol_tbnOK_clicked()
{
  if (this.iface.tipoArticulo_ == "barcode") {
    if (!this.iface.probarInsercionLineaTC()) {
      return false;
    }
  } else {
    if (!this.iface.__tbnOK_clicked()) {
      return false;
    }
  }
}

function tallCol_nivelAnterior()
{
  if (this.iface.tipoArticulo_ == "barcode") {
    this.iface.mostrarPagina();
  } else {
    this.iface.__nivelAnterior();
  }
}

function tallCol_tbnStock_clicked()
{
  if (this.iface.tipoArticulo_ == "referencia") {
    return this.iface.__tbnStock_clicked();
  }

  var aArticulo = this.iface.aArticuloTC_;
  if (!aArticulo) {
    MessageBox.warning(util.translate("scripts", "No hay un artículo de tallas y colores seleccionado"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  var aBarcodes = aArticulo["tc"];

  var fil = this.iface.tableArticulos.currentRow();
  var col = this.iface.tableArticulos.currentColumn();
  indice = this.iface.dameIndiceTC(aBarcodes, fil, col);
  if (indice < 0) {
    return false;
  }

  var oArticulo = new Object();
  oArticulo.referencia = aArticulo["id"];
  oArticulo.barcode = aBarcodes[indice]["id"];
  if (!flfact_tpv.iface.pub_consultarStock(oArticulo)) {
    return false;
  }
  return true;
}
//// TALLAS Y COLORES ///////////////////////////////////////////
/////////////////////////////////////////////////////////////////
