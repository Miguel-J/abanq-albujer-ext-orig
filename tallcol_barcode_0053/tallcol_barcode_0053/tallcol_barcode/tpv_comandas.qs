
/** @class_declaration barcode */
/////////////////////////////////////////////////////////////////
//// BARCODE ///////////////////////////////////////////////////
class barcode extends oficial
{
  var tipoBarcode_;
  var introReferencia_;
  function barcode(context)
  {
    oficial(context);
  }
  function init()
  {
    return this.ctx.barcode_init();
  }
  function bufferChanged(fN)
  {
    return this.ctx.barcode_bufferChanged(fN);
  }
  function calculateField(fN)
  {
    return this.ctx.barcode_calculateField(fN);
  }
  function datosLineaVentaArt()
  {
    return this.ctx.barcode_datosLineaVentaArt();
  }
  function insertarLineaClicked()
  {
    return this.ctx.barcode_insertarLineaClicked();
  }
  function buscarArticuloClicked()
  {
    return this.ctx.barcode_buscarArticuloClicked();
  }
  function datosVisorArt(curLineas)
  {
    return this.ctx.barcode_datosVisorArt(curLineas);
  }
  function fdbReferencia_lostFocus()
  {
    return this.ctx.barcode_fdbReferencia_lostFocus();
  }
  function cursorAPosicionInicial()
  {
    return this.ctx.barcode_cursorAPosicionInicial();
  }
  function fdbReferencia_returnPressed()
  {
    return this.ctx.barcode_fdbReferencia_returnPressed();
  }
  function tbnStock_clicked()
  {
    return this.ctx.barcode_tbnStock_clicked();
  }
}
//// BARCODE ///////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition barcode */
/////////////////////////////////////////////////////////////////
//// BARCODE ///////////////////////////////////////////////////
function barcode_init()
{
  var _i = this.iface;

  _i.__init();
  if (_i.hayValoresLocales_) {
    var fdbReferencia = this.child("fdbReferencia");
    connect(fdbReferencia.editor(), "lostFocus()", _i, "fdbReferencia_lostFocus()");
    connect(this.child("tbnBuscar"), "clicked()", _i, "buscarArticuloClicked()");
    if (this.child("fdbCodBarras")) {
      this.child("fdbCodBarras").close();
    }
  }
}

function barcode_cursorAPosicionInicial()
{
  var _i = this.iface;
  var posInicial = _i.config_["ircursorinicio"];
  switch (posInicial) {
    case "Cod.Barras":
    case "Referencia": {
      this.child("fdbReferencia").setFocus();
      break;
    }
    case "Cantidad": {
      this.child("txtCanArticulo").setFocus();
      break;
    }
  }
}

/// Probar cuando funcione la conexión y quitar barcode_insertarLineaClicked()
function barcode_fdbReferencia_returnPressed()
{
  var _i = this.iface;
  var cursor = this.cursor();
  var barcode = cursor.valueBuffer("barcode");
  if (!barcode || barcode == "") {
    _i.txtDesArticulo.text = _i.txtVarios_;
  }
  _i.bufferChanged("barcodeLinea");
  if (_i.config_["irultrarrapida"]) {
    _i.insertarLineaClicked();
  } else {
    this.child("txtDesArticulo").setFocus();
  }
}

function barcode_fdbReferencia_lostFocus()
{
  var _i = this.iface;
  var cursor = this.cursor();
  var barcode = cursor.valueBuffer("barcode");

  if (!barcode || barcode == "") {
    _i.txtDesArticulo.text = AQUtil.translate("scripts", "VARIOS");
  }
}

function barcode_buscarArticuloClicked()
{
  var _i = this.iface;
  var valor = "";

  var f = new FLFormSearchDB("articulos"); //tpv_buscarreferencia");
  f.setMainWidget();
  valor = f.exec("referencia");
  if (!valor) {
    return;
  }
  if (AQUtil.sqlSelect("atributosarticulos", "barcode", "referencia = '" + valor + "'")) {
    delete f;
    f = new FLFormSearchDB("tpv_buscarbarcode");
    f.setMainWidget();
    f.cursor().setMainFilter("referencia = '" + valor + "'");
    valor = f.exec("barcode");
    if (!valor) {
      return;
    }
  } else {
    var barcode = AQUtil.sqlSelect("articulos", "codbarras", "referencia = '" + valor + "'");
    if (barcode && barcode != "") {
      valor = barcode;
    }
  }
  this.child("fdbReferencia").setValue(valor);
  _i.bufferChanged("barcodeLinea");
}

function barcode_insertarLineaClicked()
{
  var _i = this.iface;
  var cursor = this.cursor();
  var barcode = cursor.valueBuffer("barcode");
  if (barcode && barcode != "") {
    //_i.bufferChanged("barcodeLinea"); /// Quitado porque cuando se cambia el precio a mano y se pulsa la estrella recalcula el precio
  } else {
    _i.tipoBarcode_ = "referencia";
    //_i.referencia_ = "";
    cursor.setValueBuffer("referencia", "");
  }

  _i.__insertarLineaClicked()
}

function barcode_bufferChanged(fN)
{
  var _i = this.iface;
  var cursor = this.cursor();
  switch (fN) {
    case "barcode": {
      var referencia = AQUtil.sqlSelect("atributosarticulos", "referencia", "barcode = '" + cursor.valueBuffer("barcode") + "'");
      if (!referencia) {
        _i.txtDesArticulo.text = "";
        _i.txtPvpArticulo.text = "";
        break;
      }
      if (referencia != cursor.valueBuffer("referencia")) {
        cursor.setValueBuffer("referencia", referencia);
      }
      break;
    }
    case "barcodeLinea": {
      /// Esto se hace para evitar que el lector de código de barras dé lecturas erróneas al lanzarse contínuamente el bufferChanged
      var barcode = cursor.valueBuffer("barcode");
      _i.tipoBarcode_ = false;
      var referencia = false;
      if (barcode && barcode != "") {
        referencia = AQUtil.sqlSelect("articulos", "referencia", "referencia = '" + barcode + "'");
        if (!referencia) {
          referencia = AQUtil.sqlSelect("articulos", "referencia", "codbarras = '" + barcode + "'");
        }
        if (referencia) {
          _i.tipoBarcode_ = "articulo";
        } else {
          referencia = AQUtil.sqlSelect("atributosarticulos", "referencia", "barcode = '" + barcode + "'");
          if (referencia)
            _i.tipoBarcode_ = "barcode";
        }
      }
      if (referencia) {
        cursor.setValueBuffer("referencia", referencia);
      } else {
        cursor.setValueBuffer("referencia", "");
      }
      //      _i.bufferChanged("barcode");
      break;
    }
    default: {
      _i.__bufferChanged(fN);
    }
  }
}

function barcode_calculateField(fN)
{
  var _i = this.iface;
  var valor;
  var cursor = this.cursor();

  switch (fN) {
      //    case "desarticulo": {
      //      valor = AQUtil.sqlSelect("articulos", "descripcion", "referencia = '" + _i.referencia_ + "'");
      //      if (!valor)
      //        valor = "";
      //      break;
      //    }
      //    case "pvparticulo": {
      //      valor = formRecordtpv_lineascomanda.iface.calcularPvpTarifa(_i.referencia_, cursor.valueBuffer("codtarifa"));
      //      if (!valor)
      //        valor = "0";
      //      valor = AQUtil.roundFieldValue(valor, "tpv_lineascomanda", "pvpunitario");
      //      break;
      //    }
      //    case "ivaarticulo": {
      //      var codSerie= "";
      //      var codCliente= AQUtil.sqlSelect("tpv_comandas", "codcliente", "idtpv_comanda = '" + cursor.valueBuffer("idtpv_comanda") + "'");
      //      if (flfacturac.iface.pub_tieneIvaDocCliente(codSerie, codCliente)) {
      //        valor = AQUtil.sqlSelect("articulos", "codimpuesto", "referencia = '" + _i.referencia_ + "'");
      //      } else {
      //        valor = "";
      //      }
      //      break;
      //    }
    default: {
      valor = _i.__calculateField(fN);
      break;
    }
  }
  return valor;
}

/** |D Establece los datos de la línea de ventas a crear mediante la inserción rápida
\end */
function barcode_datosLineaVentaArt()
{
  var _i = this.iface;
  var cursor = this.cursor();
  if (!_i.__datosLineaVentaArt()) {
    return false;
  }
  if (_i.tipoBarcode_ == "barcode") {
    _i.curLineas.setValueBuffer("barcode", cursor.valueBuffer("barcode"));
    _i.curLineas.setValueBuffer("talla", AQUtil.sqlSelect("atributosarticulos", "talla", "barcode = '" + cursor.valueBuffer("barcode") + "'"));
    _i.curLineas.setValueBuffer("color", AQUtil.sqlSelect("atributosarticulos", "color", "barcode = '" + cursor.valueBuffer("barcode") + "'"));
  }
  return true;
}

function barcode_datosVisorArt(curLineas)
{
  var _i = this.iface;
  var cursor = this.cursor();

  var codPuntoVenta = cursor.valueBuffer("codtpv_puntoventa");

  var datos = [];

  var qry = new FLSqlQuery();
  qry.setTablesList("atributosarticulos");
  qry.setSelect("referencia, talla, color");
  qry.setFrom("atributosarticulos");
  qry.setWhere("barcode = '" + cursor.valueBuffer("barcode") + "'");
  if (!qry.exec())
    return;
  if (qry.first()) {
    var numDatos = 0;
    datos[numDatos] = qry.value("referencia");
    numDatos ++;
    if (qry.value("talla") && qry.value("talla") != "") {
      var talla = AQUtil.sqlSelect("tallas", "descripcion", "codtalla = '" + qry.value("talla") + "'");
      datos[numDatos] = talla;
      numDatos ++;
    }
    if (qry.value("color") && qry.value("color") != "") {
      var color = AQUtil.sqlSelect("colores", "descripcion", "codcolor = '" + qry.value("color") + "'");
      datos[numDatos] = color;
      numDatos++;
    }
  } else {
    var ref = AQUtil.sqlSelect("articulos", "referencia", "codbarras = '" + cursor.valueBuffer("barcode") + "'");
    if (!ref) {
      ref = "";
    }
    datos[0] = ref;
    var des;
    if (ref != "") {
      des = AQUtil.sqlSelect("articulos", "descripcion", "referencia = '" + ref + "'");
    } else {
      des = _i.txtDesArticulo.text;
    }
    datos[1] = des;
  }

  var otrosDatos = [];
  otrosDatos[0] = "PVP";

  var precio = AQUtil.roundFieldValue(this.child("txtPvpArticulo").text, "tpv_comandas", "total");
  if (!precio || precio == "")
    precio = 0;
  otrosDatos[1] = precio;

  var linea1 = _i.formatearLineaVisor(codPuntoVenta, 1, datos, "CONCAT");
  var linea2 = _i.formatearLineaVisor(codPuntoVenta, 2, otrosDatos, "SEPARAR");
  var datosVisor = [];
  datosVisor[0] = linea1;
  datosVisor[1] = linea2;
  _i.escribirEnVisor(codPuntoVenta, datosVisor);
}

function barcode_conectarInsercionRapida()
{
  var _i = this.iface;
  try {
    connect(this.child("fdbReferencia"), "keyReturnPressed()", _i, "fdbReferencia_returnPressed");
  } catch (e) {
    var fdbReferencia = this.child("fdbReferencia");
    _i.introReferencia_ = fdbReferencia.insertAccel("Return");
    _i.introReferencia_ = fdbReferencia.insertAccel("Enter");
    connect(fdbReferencia, "activatedAccel(int)", _i, "insertarLineaClicked()");
  }
  return true;
}

function barcode_tbnStock_clicked()
{
  var cursor = this.cursor();
  var curLinea = this.child("tdbLineasComanda").cursor();
  if (!curLinea) {
    return false;
  }

  var oArticulo = new Object;
  oArticulo.referencia = curLinea.valueBuffer("referencia");
  oArticulo.barcode = curLinea.valueBuffer("barcode");
  if (!flfact_tpv.iface.pub_consultarStock(oArticulo)) {
    return false;
  }
  return true;
}


//// BARCODE ///////////////////////////////////////////////////
////////////////////////////////////////////////////////////////
