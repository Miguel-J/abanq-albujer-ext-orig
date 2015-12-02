
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
  function mostrarArticuloUbicacion()
  {
    return this.ctx.sgaBarcode_mostrarArticuloUbicacion();
  }
  function crearMovimiento(continuar: Boolean)
  {
    return this.ctx.sgaBarcode_crearMovimiento(continuar);
  }
}
//// SGA_BARCODE ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition sgaBarcode*/
///////////////////////////////////////////////////////////////
// SGA_BARCODE ///////////////////////////////////////////////
function sgaBarcode_mostrarArticuloUbicacion()
{
  var cursor: FLSqlCursor = this.cursor();
  var idUbicacion: String = cursor.valueBuffer("idubiarticulo");

  var q: FLSqlQuery = new FLSqlQuery();
  q.setTablesList("ubicacionesarticulo");
  q.setSelect("referencia, barcode");
  q.setFrom("ubicacionesarticulo");
  q.setWhere("id = " + idUbicacion);
  if (!q.exec())
    return;

  if (q.first()) {
    if (q.value("barcode") && q.value("barcode") != "") {
      var qryAtributos: FLSqlQuery = new FLSqlQuery();
      qryAtributos.setTablesList("atributosarticulos,articulos");
      qryAtributos.setSelect("a.descripcion, at.talla, at.color, at.barcode");
      qryAtributos.setFrom("atributosarticulos at INNER JOIN articulos a ON at.referencia = a.referencia");
      qryAtributos.setWhere("barcode = '" + q.value("barcode") + "'");
      if (!qryAtributos.exec())
        return;

      if (qryAtributos.first()) {
        this.child("ledArticulo").text = q.value("barcode");
        this.child("ledDesArticulo").text = qryAtributos.value("a.descripcion");
        this.child("ledTalla").text = qryAtributos.value("at.talla");
        this.child("ledColor").text = qryAtributos.value("at.color");
        this.iface.barcodeActual = q.value("barcode");
        this.iface.referenciaActual = "";
      }
    } else if (q.value("referencia") && q.value("referencia") != "") {
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
        this.child("ledTalla").text = "";
        this.child("ledColor").text = "";
        this.iface.barcodeActual = "";
        this.iface.referenciaActual = q.value("referencia");
      }
    }
  }
  this.iface.datosUbicacion();
  this.child("ledA").setFocus();
}

function sgaBarcode_crearMovimiento(continuar)
{
  var cursor: FLSqlCursor = this.cursor();
  var util: FLUtil = new FLUtil();
  var hoy: Date = new Date();
  var diferencia: String = this.child("ledDiferencia").text;

  if (this.iface.barcodeActual && !this.iface.referenciaActual) {
    this.iface.referenciaActual = util.sqlSelect("atributosarticulos", "referencia", "barcode = '" + this.iface.barcodeActual + "'");
    if (!this.iface.referenciaActual)
      return false;
  }

  if (this.child("ledDiferencia").text == "") {
    MessageBox.information(util.translate("scripts", "Debe establecer una cantidad distinta de 0"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }

  var idUbicacion: String = cursor.valueBuffer("idubiarticulo");
  var codUbicacion: String = util.sqlSelect("ubicacionesarticulo", "codubicacion", "id = " + idUbicacion);
  var talla: String = util.sqlSelect("atributosarticulos", "talla", "barcode = '" + this.iface.barcodeActual + "'");
  var color: String = util.sqlSelect("atributosarticulos", "color", "barcode = '" + this.iface.barcodeActual + "'");

  cursor.setValueBuffer("tipo", "Regularización");
  cursor.setValueBuffer("usuario", sys.nameUser())
  cursor.setValueBuffer("fecha", hoy);
  cursor.setValueBuffer("hora", hoy.toString().right(8));
  cursor.setValueBuffer("referencia", this.iface.referenciaActual);
  cursor.setValueBuffer("barcode", this.iface.barcodeActual);
  cursor.setValueBuffer("talla", talla);
  cursor.setValueBuffer("color", color);
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

// SGA_BARCODE /////////////////////////////////////////////////
///////////////////////////////////////////////////////////////
