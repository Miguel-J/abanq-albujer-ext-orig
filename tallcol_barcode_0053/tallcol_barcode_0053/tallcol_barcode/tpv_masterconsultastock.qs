
/** @class_declaration barcode */
/////////////////////////////////////////////////////////////////
//// TALLAS Y COLORES POR BARCODE ///////////////////////////////
class barcode extends oficial
{
  var COL_TAL;
  var COL_COL;

  function barcode(context)
  {
    oficial(context);
  }
  //  function iniciaFiltro() {
  //    return this.ctx.barcode_iniciaFiltro();
  //  }
  function init()
  {
    return this.ctx.barcode_init();
  }
  function filtrarStock(refBarcode)
  {
    return this.ctx.barcode_filtrarStock(refBarcode);
  }
  function preparaTabla()
  {
    return this.ctx.barcode_preparaTabla();
  }
  function construirWhereStocks()
  {
    return this.ctx.barcode_construirWhereStocks();
  }
}
//// TALLAS Y COLORES POR BARCODE ///////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition barcode */
/////////////////////////////////////////////////////////////////
//// TALLAS Y COLORES POR BARCODE ///////////////////////////////
// function barcode_iniciaFiltro()
// {
//  var oArticulo = flfact_tpv.iface.dameArtConsultaStock();
//  if (!oArticulo) {
//    return;
//  }
//  var referencia = oArticulo.referencia;
//  var barcode = oArticulo.barcode;
//  if (!referencia || referencia == "") {
//    return;
//  }
//  this.child("ledArticulo").text = barcode && barcode != "" ? barcode : referencia;
//  this.iface.ledArticulo_returnPressed();
// }

function barcode_construirWhereStocks()
{
  var _i = this.iface;
  var where = _i.__construirWhereStocks();

  var barcode = this.child("fdbBarcode").value();
  var talla = this.child("fdbTalla").value();
  var color = this.child("fdbColor").value();

  if (barcode && barcode != "") {
    if (where != "")
      where += " and ";
    where += "s.barcode = '" + barcode + "'";
  }

  if (talla && talla != "") {
    if (where != "")
      where += " and ";
    where += "aa.talla = '" + talla + "'";
  }

  if (color && color != "") {
    if (where != "")
      where += " and ";
    where += "aa.color = '" + color + "'";
  }

  var fA = flfactalma.iface.pub_dameFiltroArt(this, "a");
  if (fA && fA != "") {
    where += where != "" ? " AND " : "";
    where += fA;
  }
  debug("where " + where);
  debug("fA " + fA);
  return where;
}

function barcode_filtrarStock(refBarcode)
{
  var util = new FLUtil();
  var _i = this.iface;
  var where = _i.__construirWhereStocks();

  this.iface.tblStock_.setNumRows(0);
  var qryStock = _i.dameNuevaConsulta();

  if (!qryStock) {
    MessageBox.warning(sys.translate("No se ha podido realizar la consulta a la base de datos."), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return false;
  }

  qryStock.setTablesList("stocks,articulos");
  qryStock.setSelect("s.referencia, s.barcode, s.cantidad, s.codalmacen, a.descripcion, aa.talla, aa.color");
  qryStock.setFrom("stocks s INNER JOIN articulos a ON s.referencia = a.referencia LEFT OUTER JOIN atributosarticulos aa ON s.barcode = aa.barcode");
  qryStock.setWhere(where + " ORDER BY s.referencia, s.barcode");
  debug(qryStock.sql());
  qryStock.setForwardOnly(true);
  if (!qryStock.exec()) {
    return false;
  }
  if (qryStock.size() > _i.maxQuery_) {
    var res = MessageBox.warning(sys.translate("La consulta devuelve %1 resultados. ¿Continuar?").arg(qryStock.size()), MessageBox.Yes, MessageBox.No, MessageBox.NoButton, "AbanQ");
    if (res != MessageBox.Yes) {
      return false;
    }
  }
  var barcodeAnterior = "", barcode, referencia, codAlmacen, cantidad, fila = -1, col;
  while (qryStock.next()) {
    referencia = qryStock.value("s.referencia");
    barcode  = qryStock.value("s.barcode");
    barcode = barcode && barcode != "" ? barcode : referencia;
    codAlmacen = qryStock.value("s.codalmacen");
    cantidad = qryStock.value("s.cantidad");
    if (barcodeAnterior == "" || barcodeAnterior != barcode) {
      fila++;
      this.iface.tblStock_.insertRows(fila);
      this.iface.tblStock_.setText(fila, this.iface.COL_REF, barcode);
      this.iface.tblStock_.setText(fila, this.iface.COL_DES, qryStock.value("a.descripcion"));
      this.iface.tblStock_.setText(fila, this.iface.COL_TAL, qryStock.value("aa.talla"));
      this.iface.tblStock_.setText(fila, this.iface.COL_COL, qryStock.value("aa.color"));
    }
    col = this.iface.aAlmacenes_[codAlmacen]["col"];
    this.iface.tblStock_.setText(fila, col, cantidad);
    barcodeAnterior = barcode;
  }
}

function barcode_preparaTabla()
{
  this.iface.tblStock_ = this.child("tblStock");

  var util = new FLUtil;
  if (!this.iface.cargaAlmacenes()) {
    return false;
  }
  var numAlmacenes = this.iface.aAlmacenesI_.length;

  this.iface.COL_REF = 0;
  this.iface.COL_DES = 1;
  this.iface.COL_TAL = 2;
  this.iface.COL_COL = 3;
  this.iface.colsIzquierda_ = 4;
  var numCols = this.iface.colsIzquierda_ + numAlmacenes;
  var sep = "*";
  var cabecera = util.translate("scripts", "Ref.") + sep + util.translate("scripts", "Artículo") + sep + util.translate("scripts", "Talla") + sep + util.translate("scripts", "Color");

  this.iface.tblStock_.setNumCols(numCols);
  this.iface.tblStock_.setColumnWidth(this.iface.COL_REF, 80);
  this.iface.tblStock_.setColumnWidth(this.iface.COL_DES, 130);
  this.iface.tblStock_.setColumnWidth(this.iface.COL_TAL, 50);
  this.iface.tblStock_.setColumnWidth(this.iface.COL_COL, 50);
  var codAlmacen: String, col: Number;
  for (var i = 0 ; i < numAlmacenes; i++) {
    codAlmacen = this.iface.aAlmacenesI_[i];
    col = this.iface.colsIzquierda_ + i;
    this.iface.tblStock_.setColumnWidth(col, 100);
    cabecera += sep + this.iface.aAlmacenes_[codAlmacen]["nombre"];
    this.iface.aAlmacenes_[codAlmacen]["col"] = col;
  }
  this.iface.tblStock_.setColumnLabels(sep, cabecera);

}

function barcode_init()
{
  var _i = this.iface;
  _i.__init();

  flfactalma.iface.pub_iniciaFiltroArt(this);
  if (this.child("lyoutFamilia")) {
    this.child("lyoutFamilia").close();
  }
}
//// TALLAS Y COLORES POR BARCODE ///////////////////////////////
/////////////////////////////////////////////////////////////////
