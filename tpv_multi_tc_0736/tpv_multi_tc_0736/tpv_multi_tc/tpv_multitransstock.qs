
/** @class_declaration multiTc */
/////////////////////////////////////////////////////////////////
//// MULTI_TC /////////////////////////////////////////////////
class multiTc extends oficial
{
  var cBARCODE, cTALLA, cCOLOR
  function multiTc(context)
  {
    oficial(context);
  }
  function init()
  {
    return this.ctx.multiTc_init();
  }
  function incluirBarCodes()
  {
    return this.ctx.multiTc_incluirBarCodes();
  }
  function articulosMasivo()
  {
    return this.ctx.multiTc_articulosMasivo();
  }
  function incluirBarcode(q)
  {
    return this.ctx.multiTc_incluirBarcode(q);
  }
  function construirTablaTransferencias()
  {
    return this.ctx.multiTc_construirTablaTransferencias();
  }
  function cargarTablaTransferencias()
  {
    return this.ctx.multiTc_cargarTablaTransferencias();
  }
  function obtenerCantidadReponer(codMulti, oArticulo, codAlmaDestino)
  {
    return this.ctx.multiTc_obtenerCantidadReponer(codMulti, oArticulo, codAlmaDestino);
  }
  function actualizarTransferencias(f, c)
  {
    return this.ctx.multiTc_actualizarTransferencias(f, c);
  }
  function masDatosLineaMultiTransStock(curL, oArticulo)
  {
    return this.ctx.multiTc_masDatosLineaMultiTransStock(curL, oArticulo);
  }
  function datosLineaProv(idPedido, curLinea, curLineaProv)
  {
    return this.ctx.multiTc_datosLineaProv(idPedido, curLinea, curLineaProv);
  }
  function datosLineaCli(idPedido, curLinea, curLineaCli)
  {
    return this.ctx.multiTc_datosLineaCli(idPedido, curLinea, curLineaCli);
  }
  //  function tbnRefrescarRecom_clicked() {
  //    return this.ctx.multiTc_tbnRefrescarRecom_clicked();
  //  }
  function obtenerCantidadRecom(oArticulo, codAlmaDestino)
  {
    return this.ctx.multiTc_obtenerCantidadRecom(oArticulo, codAlmaDestino);
  }
  function obtenerLineaMultiTransStock(codMulti, oArticulo, codAlmaDestino)
  {
    return this.ctx.multiTc_obtenerLineaMultiTransStock(codMulti, oArticulo, codAlmaDestino);
  }
  function borrarLinea(codMulti, oArticulo, codAlmaDestino)
  {
    return this.ctx.multiTc_borrarLinea(codMulti, oArticulo, codAlmaDestino);
  }
  function referenciaStockPos(referencia, codAlmacen)
  {
    return this.ctx.multiTc_referenciaStockPos(referencia, codAlmacen);
  }
  function barcodeStockPos(barcode, codAlmacen)
  {
    return this.ctx.multiTc_barcodeStockPos(barcode, codAlmacen);
  }
  function eliminarArticulo()
  {
    return this.ctx.multiTc_eliminarArticulo();
  }
  function objetoArticulo(q)
  {
    return this.ctx.multiTc_objetoArticulo(q);
  }
  function stockArticulo(codAlmOrigen, oArticulo)
  {
    return this.ctx.multiTc_stockArticulo(codAlmOrigen, oArticulo);
  }
  function datosArticuloFila(f, q, tipoConsulta)
  {
    return this.ctx.multiTc_datosArticuloFila(f, q, tipoConsulta);
  }
  function tbnInsertaLinea_clicked()
  {
    return this.ctx.multiTc_tbnInsertaLinea_clicked();
  }
  function tbnCalcular_clicked()
  {
    return this.ctx.multiTc_tbnCalcular_clicked();
  }
  function cargarTablaReposiciones()
  {
    return this.ctx.multiTc_cargarTablaReposiciones();
  }
}
//// MULTI_TC /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition multiTc */
/////////////////////////////////////////////////////////////////
//// MULTI_TC /////////////////////////////////////////////////
function multiTc_init()
{
  var _i = this.iface;

  _i.__init();

  //Quitado porque no se pueden volver a borrar e insertar todos los barcodes de todos los artículos cada vez que se haga un commit sobre uno de ellos. Está hecho en el after commit.
  //  connect(this.child("tdbArticulos").cursor(), "bufferCommited()", _i, "incluirBarCodes()");
  connect(this.child("tdbArticulos").cursor(), "bufferCommited()", this.child("tdbBarCodes"), "refresh()");
}

function multiTc_incluirBarCodes()
{
  var _i = this.iface;
  var cursor = this.cursor();

  var codAlmaOrigen = cursor.valueBuffer("codalmaorigen");

  var curArt = this.child("tdbArticulos").cursor();
  if (!curArt.commitBufferCursorRelation()) {
    return;
  }
  /// Recojo los atributos de los artículos (todos los diferentes barcodes, tallas y colores) que están en el multipedido por medio de su referencia.
  var q = new FLSqlQuery;
  q.setSelect("a.referencia, aa.barcode, aa.talla, aa.color");
  q.setFrom("atributosarticulos aa INNER JOIN tpv_artmultitransstock a ON aa.referencia = a.referencia");
  q.setWhere("a.codmultitransstock = '" + cursor.valueBuffer("codmultitransstock") + "' GROUP BY a.referencia, aa.barcode, aa.talla, aa.color");
  q.setForwardOnly(true);
  if (!q.exec()) {
    return;
  }
  /// Si ya hay un multipedido que tiene barcodes entonces los elimino todos para volver a recorrer los artículos e insertar en barcodesmultipedido los artículos que se encuentran en ese momento en la tabla de articulosmultipedido.
  if (AQUtil.sqlSelect("tpv_barcodemultitransstock", "barcode", "codmultitransstock = '" + cursor.valueBuffer("codmultitransstock") + "'")) {
    if (!AQUtil.sqlDelete("tpv_barcodemultitransstock", "codmultitransstock = '" + cursor.valueBuffer("codmultitransstock") + "'")) {
      return;
    }
  }
  /// Mientras hay artículos en el multipedido inserto en barcodesmultipedido sus atributos.
  var barcode;
  var p = 0;
  AQUtil.createProgressDialog(sys.translate("Insertando barcodes de los articulos seleccionados."), q.size());

  while (q.next()) {
    AQUtil.setProgress(p++);
    barcode = q.value("aa.barcode");
    if (cursor.valueBuffer("solostockpos")) {
      if (!_i.barcodeStockPos(barcode, codAlmaOrigen)) {
        continue;
      }
    }
    if (!_i.incluirBarcode(q)) {
      AQUtil.destroyProgressDialog();
      return false;
    }
    AQUtil.destroyProgressDialog();
    this.child("tdbBarCodes").refresh();
  }
}

function multiTc_incluirBarcode(q)
{
  var _i = this.iface;
  var cursor = this.cursor();
  var curBC = new FLSqlCursor("tpv_barcodemultitransstock");
  curBC.setModeAccess(curBC.Insert);
  curBC.refreshBuffer();
  curBC.setValueBuffer("barcode", q.value("aa.barcode"));
  curBC.setValueBuffer("codmultitransstock", cursor.valueBuffer("codmultitransstock"));
  curBC.setValueBuffer("referencia", q.value("a.referencia"));
  curBC.setValueBuffer("talla", q.value("aa.talla"));
  curBC.setValueBuffer("color", q.value("aa.color"));
  if (!curBC.commitBuffer()) {
    return false;
  }
  /*
  var q = new FLSqlQuery;
  q.setSelect("referencia");
  q.setFrom("tpv_artmultitransstock");
  q.setWhere("codmultitransstock = '" + cursor.valueBuffer("codmultitransstock") + "' AND referencia = '" + q.value("a.referencia") + "'");
  q.setForwardOnly(true);
  if (!q.exec()) {
    return;
  }
  */
  if (!AQUtil.sqlSelect("tpv_artmultitransstock", "referencia", "referencia = '" + q.value("a.referencia")  + "' AND codmultitransstock = '" + cursor.valueBuffer("codmultitransstock") + "'")) {
    if (!_i.incluirArticulo("referencia = '" + q.value("a.referencia") + "'", true)) {
      return false;
    }
  }

  return true;
}

function multiTc_articulosMasivo()
{
  var _i = this.iface;

  _i.__articulosMasivo();
  _i.incluirBarCodes();
}

function multiTc_construirTablaTransferencias()
{
  var cabecera = "";
  var _i = this.iface;
  var cursor = this.cursor();
  var c = 0;

  var codMultiTrans = cursor.valueBuffer("codmultitransstock");
  if (!codMultiTrans || codMultiTrans == "")
    return;

  _i.cFAMILIA = c++;
  cabecera += AQUtil.translate("scripts", "Familia") + "/";
  _i.cBARCODE = c++;
  cabecera += AQUtil.translate("scripts", "Barcode") + "/";
  _i.cARTICULO = c++;
  cabecera += AQUtil.translate("scripts", "Artículo") + "/";
  _i.cREFERENCIA = c++;
  cabecera += AQUtil.translate("scripts", "Referencia") + "/";
  _i.cTALLA = c++;
  cabecera += AQUtil.translate("scripts", "Talla") + "/";
  _i.cCOLOR = c++;
  cabecera += AQUtil.translate("scripts", "Color") + "/";
  _i.cORIGEN = c++;
  cabecera += AQUtil.sqlSelect("almacenes", "nombre", "codalmacen = '" + cursor.valueBuffer("codalmaorigen") + "'")  + "/";
  _i.cSTOCKORIGEN = c++;
  cabecera += AQUtil.translate("scripts", "S.Origen") + "/";
  _i.cDESTINO = [];
  _i.cREPONER = [];
  _i.cRECOM = [];
  _i.cSTOCKDESTINO = [];
  var qryAlm = new FLSqlQuery;
  qryAlm.setSelect("tpv_almamultitransstock.codalmacen,almacenes.nombre");
  qryAlm.setFrom("tpv_almamultitransstock INNER JOIN almacenes ON almacenes.codalmacen = tpv_almamultitransstock.codalmacen");
  qryAlm.setWhere("codmultitransstock = '" + codMultiTrans + "'");
  qryAlm.setForwardOnly(true);

  if (!qryAlm.exec()) {
    return;
  }

  var i = 0;
  while (qryAlm.next()) {
    _i.cDESTINO[i] = [];
    _i.cDESTINO[i]["col"] = c++;
    _i.cDESTINO[i]["codalmacen"] = qryAlm.value("tpv_almamultitransstock.codalmacen");
    cabecera += qryAlm.value("almacenes.nombre") + "/";

    _i.cSTOCKDESTINO[i] = c++;
    cabecera += qryAlm.value("almacenes.nombre") + sys.translate("-Act") + "/";

    _i.cRECOM[i] = c++;;
    cabecera += AQUtil.translate("scripts", "Rec.") + "/";

    _i.cREPONER[i] = c++;;
    cabecera += AQUtil.translate("scripts", "Envio") + "/";
    i++;
  }
  _i.tblTransstock_.setNumCols(c);

  _i.tblTransstock_.setColumnWidth(_i.cFAMILIA, 60);
  _i.tblTransstock_.setColumnWidth(_i.cBARCODE, 100);
  _i.tblTransstock_.setColumnWidth(_i.cARTICULO, 200);
  _i.tblTransstock_.setColumnWidth(_i.cREFERENCIA, 80);
  _i.tblTransstock_.setColumnWidth(_i.cTALLA, 40);
  _i.tblTransstock_.setColumnWidth(_i.cCOLOR, 40);
  _i.tblTransstock_.setColumnWidth(_i.cORIGEN, 60);
  _i.tblTransstock_.setColumnWidth(_i.cSTOCKORIGEN, 60);

  _i.tblTransstock_.setColumnReadOnly(_i.cFAMILIA, true);
  _i.tblTransstock_.setColumnReadOnly(_i.cBARCODE, true);
  _i.tblTransstock_.setColumnReadOnly(_i.cARTICULO, true);
  _i.tblTransstock_.setColumnReadOnly(_i.cREFERENCIA, true);
  _i.tblTransstock_.setColumnReadOnly(_i.cORIGEN, true);
  _i.tblTransstock_.setColumnReadOnly(_i.cSTOCKORIGEN, true);
  _i.tblTransstock_.setColumnReadOnly(_i.cTALLA, true);
  _i.tblTransstock_.setColumnReadOnly(_i.cCOLOR, true);

  _i.tblTransstock_.hideColumn(_i.cSTOCKORIGEN);

  for (var i = 0; i < _i.cDESTINO.length; i++) {
    _i.tblTransstock_.setColumnWidth(_i.cDESTINO[i]["col"], 60);
    _i.tblTransstock_.setColumnWidth(_i.cSTOCKDESTINO[i], 60);
    _i.tblTransstock_.setColumnWidth(_i.cRECOM[i], 40);
    _i.tblTransstock_.setColumnWidth(_i.cREPONER[i], 40);

    _i.tblTransstock_.hideColumn(_i.cRECOM[i]);

    _i.tblTransstock_.setColumnReadOnly(_i.cDESTINO[i]["col"], true);
    _i.tblTransstock_.setColumnReadOnly(_i.cSTOCKDESTINO[i], true);
    _i.tblTransstock_.setColumnReadOnly(_i.cRECOM[i], true);

    _i.tblTransstock_.hideColumn(_i.cSTOCKDESTINO[i]);
  }

  _i.tblTransstock_.setColumnLabels("/", cabecera);
}



function multiTc_cargarTablaTransferencias()
{
  var _i = this.iface;

  _i.tblTransstock_.clear();

  var cursor = this.cursor();

  var codMultiTrans = cursor.valueBuffer("codmultitransstock");
  if (!codMultiTrans || codMultiTrans == "") {
    return;
  }
  var codAlmOrigen = cursor.valueBuffer("codalmaorigen");
  if (!codAlmOrigen) {
    return;
  }

  var valorRecomendado = cursor.valueBuffer("valorrecomendado");

  var q = new FLSqlQuery;
  q.setSelect("a.referencia, a.descripcion, a.codfamilia, l.codalmadestino, l.cantidad");
  q.setFrom("tpv_artmultitransstock m INNER JOIN articulos a ON m.referencia = a.referencia LEFT OUTER JOIN tpv_lineasmultitransstock l ON (m.referencia = l.referencia AND m.codmultitransstock = l.codmultitransstock)");
  q.setWhere("m.codmultitransstock = '" + codMultiTrans + "' AND m.referencia NOT in (select referencia from atributosarticulos where referencia = m.referencia) order by m.referencia,a.codfamilia,a.descripcion");
  q.setForwardOnly(true);
  debug(q.sql());
  if (!q.exec()) {
    debug("false");
    return;
  }

  _i.idArticulos_ = new Object;
  if (!_i.cargaLineas(q, "TAB")) {
    return false;
  }

  q.setSelect("aa.barcode, a.descripcion, a.referencia, a.codfamilia, aa.talla, aa.color, l.codalmadestino, l.cantidad");
  q.setFrom("tpv_barcodemultitransstock b INNER JOIN atributosarticulos aa ON b.barcode = aa.barcode INNER JOIN articulos a ON b.referencia = a.referencia LEFT OUTER JOIN tpv_lineasmultitransstock l ON (b.codmultitransstock = l.codmultitransstock AND b.barcode = l.barcode)");
  q.setWhere("b.codmultitransstock = '" + codMultiTrans + "' order by a.codfamilia,a.descripcion");
  q.setForwardOnly(true);
  debug(q.sql());
  if (!q.exec()) {
    return;
  }

  if (!_i.cargaLineas(q, "TAB")) {
    return false;
  }
  return true;
}

function multiTc_cargarTablaReposiciones()
{
  var _i = this.iface;
  var cursor = this.cursor();

  //   _i.tblTransstock_.clear();

  var codMultiTrans = cursor.valueBuffer("codmultitransstock");
  if (!codMultiTrans || codMultiTrans == "") {
    return;
  }
  var codAlmaOrigen = cursor.valueBuffer("codalmaorigen");
  if (!codAlmaOrigen || codAlmaOrigen == "") {
    return;
  }
  var lA = _i.listaAlmacenes();
  if (lA == "") {
    return;
  }
  var wStockPos = "";
  if (cursor.valueBuffer("solostockpos")) {
    wStockPos = " AND s.disponible > 0";
  }
  if (!_i.idArticulos_) {
    _i.idArticulos_ = new Object;
  }
  var wFechas = "";
  var desde = cursor.valueBuffer("fdesderecom");
  if (desde) {
    wFechas += " AND c.fecha >= '" + desde + "'";
  }
  var hasta = cursor.valueBuffer("fhastarecom");
  if (desde) {
    wFechas += " AND c.fecha <= '" + hasta + "'";
  }
  var q = new FLSqlQuery;
  q.setSelect("a.referencia,a.descripcion,a.codfamilia, c.codalmacen, SUM(lc.cantidad)");
  q.setFrom("tpv_comandas c INNER JOIN tpv_lineascomanda lc ON c.idtpv_comanda = lc.idtpv_comanda INNER JOIN articulos a ON lc.referencia = a.referencia LEFT OUTER JOIN atributosarticulos aa ON a.referencia = aa.referencia INNER JOIN stocks s ON (a.referencia = s.referencia AND s.codalmacen = '" + codAlmaOrigen + "' AND s.barcode IS NULL)");
  q.setWhere("c.codalmacen IN (" + lA + ")" + wFechas + wStockPos + " AND aa.referencia IS NULL GROUP BY a.referencia, a.descripcion, a.codfamilia, c.codalmacen HAVING SUM(lc.cantidad) > 0 ORDER BY a.codfamilia, a.descripcion, c.codalmacen");
  q.setForwardOnly(true);
  debug(q.sql());
  if (!q.exec()) {
    return;
  }
  _i.cargaLineas(q, "REP");

  var q = new FLSqlQuery;
  q.setSelect("aa.barcode, a.referencia,a.descripcion,a.codfamilia, aa.talla, aa.color, c.codalmacen, SUM(lc.cantidad)");
  q.setFrom("tpv_comandas c INNER JOIN tpv_lineascomanda lc ON c.idtpv_comanda = lc.idtpv_comanda INNER JOIN articulos a ON lc.referencia = a.referencia INNER JOIN atributosarticulos aa ON a.referencia = aa.referencia INNER JOIN stocks s ON (aa.barcode = s.barcode AND s.codalmacen = '" + codAlmaOrigen + "')");
  q.setWhere("c.codalmacen IN (" + lA + ")"  + wFechas + wStockPos + " GROUP BY a.referencia, a.descripcion, a.codfamilia, c.codalmacen, aa.barcode, aa.talla, aa.color HAVING SUM(lc.cantidad) > 0 ORDER BY a.codfamilia, a.descripcion, c.codalmacen");
  q.setForwardOnly(true);
  debug(q.sql());
  if (!q.exec()) {
    return;
  }
  _i.cargaLineas(q, "REP");

  _i.habilitaPestanaSets();
  _i.tblTransstock_.repaintContents();

}

// function oficial_obtenerLineaMultiTransStock(codMulti,oArticulo,codAlmaDestino)
// {
//  return AQUtil.sqlSelect("tpv_lineasmultitransstock", "idlinea", "codmultitransstock = '" + codMulti + "' AND referencia = '" + oArticulo.referencia + "' AND codalmacen = '" + codAlmaDestino + "'");
// }

function multiTc_obtenerCantidadReponer(codMulti, oArticulo, codAlmaDestino)
{
  var whereBarcode = "";
  if ("barcode" in oArticulo) {
    if (oArticulo.barcode) {
      whereBarcode = " AND barcode = '" + oArticulo.barcode + "'";
    }
  }
  var cantidad = parseFloat(AQUtil.sqlSelect("tpv_lineasmultitransstock", "cantidad", "codmultitransstock = '" + codMulti + "' AND referencia = '" + oArticulo.referencia + "'" + whereBarcode + " AND codalmadestino = '" + codAlmaDestino + "'"));
  cantidad = isNaN(cantidad) ? 0 : cantidad;

  return cantidad;
}

function multiTc_obtenerCantidadRecom(oArticulo, codAlmaDestino)
{
  var _i = this.iface;

  if (!("barcode" in oArticulo && oArticulo.barcode != "")) {
    return _i.__obtenerCantidadRecom(oArticulo, codAlmaDestino);
  }
  var cursor = this.cursor();
  var fechaDesde = cursor.valueBuffer("fdesderecom");
  var fechaHasta = cursor.valueBuffer("fhastarecom");

  var cantidad = parseFloat(AQUtil.sqlSelect("tpv_lineascomanda lc INNER JOIN tpv_comandas c ON c.idtpv_comanda = lc.idtpv_comanda", "SUM(lc.cantidad)", "c.fecha BETWEEN '" + fechaDesde + "' AND '" + fechaHasta + "' AND c.codalmacen = '" + codAlmaDestino + "' AND lc.barcode = '" + oArticulo.barcode + "'", "tpv_comandas"));
  cantidad = isNaN(cantidad) ? 0 : cantidad;
  cantidad = cantidad < 0 ? 0 : cantidad;

  return cantidad;
}

function multiTc_actualizarTransferencias(f, c)
{
  var _i = this.iface;
  var cursor = this.cursor();

  var referencia = _i.tblTransstock_.text(f, _i.cREFERENCIA);
  if (!referencia) {
    return;
  }
  var whereBarcode = "";
  var barcode = _i.tblTransstock_.text(f, _i.cBARCODE);
  if (!barcode) {
    barcode = "";
  } else {
    whereBarcode = " AND barcode = '" + barcode + "'";
  }
  var oArticulo = [];
  oArticulo["referencia"] = referencia;
  oArticulo["barcode"] = barcode;

  codAlmOrigen = cursor.valueBuffer("codalmaorigen");
  if (!codAlmOrigen) {
    return;
  }
  var stockOrigen = parseFloat(_i.tblTransstock_.text(f, _i.cSTOCKORIGEN));
  stockOrigen = isNaN(stockOrigen) ? 0 : stockOrigen;

  var totalDestino = 0;
  var reponer = 0;
  for (var i = 0; i < _i.cDESTINO.length; i++) {
    codAlmDestino = _i.cDESTINO[i]["codalmacen"];
    if (!codAlmDestino) {
      return;
    }
    stockDestino = _i.tblTransstock_.text(f, _i.cSTOCKDESTINO[i]);
    stockDestino = stockDestino ? stockDestino : 0;

    reponer = parseFloat(_i.tblTransstock_.text(f, _i.cREPONER[i]));
    reponer = isNaN(reponer) ? 0 : reponer
              totalDestino += reponer;

    if (reponer > 0) {
      _i.tblTransstock_.setCellBackgroundColor(f, _i.cREPONER[i], _i.reposicionPositivo_);
    } else {
      _i.tblTransstock_.setCellBackgroundColor(f, _i.cREPONER[i], _i.reposicionNegativo_);
    }
    stockDestino = parseFloat(stockDestino) + parseFloat(reponer);

    _i.tblTransstock_.setText(f, _i.cDESTINO[i]["col"], stockDestino);
    if (stockDestino > 0)
      _i.tblTransstock_.setCellBackgroundColor(f, _i.cDESTINO[i]["col"], _i.stockDestinoPositivo_);
    else
      _i.tblTransstock_.setCellBackgroundColor(f, _i.cDESTINO[i]["col"], _i.stockDestinoNegativo_);

    if (_i.cREPONER[i] == c) {
      var cantidad = parseFloat(_i.tblTransstock_.text(f, c));
      cantidad = isNaN(cantidad) ? 0 : cantidad
                 codAlmDestLinea = _i.cDESTINO[i]["codalmacen"];
      if (!_i.procesaLinea(oArticulo, codAlmOrigen, codAlmDestLinea, cantidad)) {
        return true;
      }
    }
  }
  stockOrigen -= totalDestino;

  if (stockOrigen > 0) {
    _i.tblTransstock_.setCellBackgroundColor(f, _i.cORIGEN, _i.stockOrigenPositivo_);
  } else {
    _i.tblTransstock_.setCellBackgroundColor(f, _i.cORIGEN, _i.stockOrigenNegativo_);
  }
  _i.tblTransstock_.setText(f, _i.cORIGEN, stockOrigen);
}

function multiTc_masDatosLineaMultiTransStock(curL, oArticulo)
{
  if ("barcode" in oArticulo) {
    if (oArticulo.barcode) {
      curL.setValueBuffer("barcode", oArticulo.barcode);
      curL.setValueBuffer("talla", AQUtil.sqlSelect("atributosarticulos", "talla", "barcode = '" + oArticulo.barcode + "'"));
      curL.setValueBuffer("color", AQUtil.sqlSelect("atributosarticulos", "color", "barcode = '" + oArticulo.barcode + "'"));
    }
  }
  return true;
}

function multiTc_datosLineaProv(idPedido, curLinea, curLineaProv)
{
  var _i = this.iface;

  if (!_i.__datosLineaProv(idPedido, curLinea, curLineaProv)) {
    return false;
  }
  curLineaProv.setValueBuffer("barcode", curLinea.valueBuffer("barcode"));
  curLineaProv.setValueBuffer("talla", curLinea.valueBuffer("talla"));
  curLineaProv.setValueBuffer("color", curLinea.valueBuffer("color"));

  return true;
}

function multiTc_datosLineaCli(idPedido, curLinea, curLineaCli)
{
  var _i = this.iface;

  if (!_i.__datosLineaCli(idPedido, curLinea, curLineaCli)) {
    return false;
  }
  curLineaCli.setValueBuffer("barcode", curLinea.valueBuffer("barcode"));
  curLineaCli.setValueBuffer("talla", curLinea.valueBuffer("talla"));
  curLineaCli.setValueBuffer("color", curLinea.valueBuffer("color"));

  return true;
}

// function multiTc_tbnRefrescarRecom_clicked()
// {
//  var _i = this.iface;
//  var t = _i.tblTransstock_;
//
//  var oArticulo = new Object;
//  var codAlmaDestino;
//  for (var f = 0; f < t.numRows(); f++) {
//    oArticulo.referencia = t.text(f, _i.cREFERENCIA);
//    oArticulo.barcode = t.text(f, _i.cBARCODE);
//    for (var a = 0; a < _i.cDESTINO.length; a++) {
//      codAlmaDestino = _i.cDESTINO[a]["codalmacen"];
//      t.setText(f, _i.cRECOM[a], _i.obtenerCantidadRecom(oArticulo, codAlmaDestino));
//    }
//  }
// }

function multiTc_obtenerLineaMultiTransStock(codMulti, oArticulo, codAlmaDestino)
{
  var _i = this.iface;
  if (!("barcode" in oArticulo && oArticulo.barcode != "")) {
    return _i.__obtenerLineaMultiTransStock(codMulti, oArticulo, codAlmaDestino);
  }
  return AQUtil.sqlSelect("tpv_lineasmultitransstock", "idlinea", "codmultitransstock = '" + codMulti + "' AND barcode = '" + oArticulo.barcode + "' AND codalmadestino = '" + codAlmaDestino + "'");
}

function multiTc_borrarLinea(codMulti, oArticulo, codAlmaDestino)
{
  var _i = this.iface;
  if (!("barcode" in oArticulo && oArticulo.barcode != "")) {
    return _i.__borrarLinea(codMulti, oArticulo, codAlmaDestino);
  }
  if (!AQSql.del("tpv_lineasmultitransstock", "codmultitransstock = '" + codMulti + "' AND barcode = '" + oArticulo.barcode + "' AND codalmadestino = '" + codAlmaDestino + "'")) {
    return false;
  }

  return true;
}

function multiTc_referenciaStockPos(referencia, codAlmacen)
{
  var _i = this.iface;
  if (AQUtil.sqlSelect("stocks", "idstock", "referencia = '" + referencia + "' AND codalmacen = '" + codAlmacen + "' AND ((barcode IS NULL AND disponible > 0) OR barcode IS NOT NULL)")) {
    return true;
  }
  return false;
}

function multiTc_barcodeStockPos(barcode, codAlmacen)
{
  var _i = this.iface;
  if (!AQUtil.sqlSelect("stocks", "idstock", "barcode = '" + barcode + "' AND codalmacen = '" + codAlmacen + "' AND disponible > 0")) {
    return false;
  }
  return true;
}

function multiTc_eliminarArticulo()
{
  var _i = this.iface;

  _i.__eliminarArticulo();
  this.child("tdbBarCodes").refresh();
}

function multiTc_objetoArticulo(q)
{
  var oArticulo = [];
  oArticulo["referencia"] = q.value("a.referencia");
  var barcode = q.value("aa.barcode");
  barcode = barcode ? barcode : "";
  oArticulo["barcode"] = barcode;
  return oArticulo;
}


function multiTc_stockArticulo(codAlmOrigen, oArticulo)
{
  var w = "codalmacen = '" + codAlmOrigen + "' AND referencia = '" + oArticulo.referencia + "'";
  if (oArticulo.barcode != "") {
    w += " AND barcode = '" + oArticulo.barcode + "'";
  }
  var stock = AQUtil.sqlSelect("stocks", "disponible", w);
  stock = stock ? stock : 0;
  return stock;
}

function multiTc_datosArticuloFila(f, q, tipoConsulta)
{
  var _i = this.iface;

  _i.tblTransstock_.setText(f, _i.cFAMILIA, q.value("a.codfamilia"));
  _i.tblTransstock_.setText(f, _i.cBARCODE, q.value("aa.barcode"));
  _i.tblTransstock_.setText(f, _i.cARTICULO, q.value("a.descripcion"));
  _i.tblTransstock_.setText(f, _i.cREFERENCIA, q.value("a.referencia"));
  _i.tblTransstock_.setText(f, _i.cTALLA, q.value("aa.talla"));
  _i.tblTransstock_.setText(f, _i.cCOLOR, q.value("aa.color"));
  return true;
}

function multiTc_tbnInsertaLinea_clicked()
{
  var _i = this.iface;
  var barcode = this.child("lneReferencia").text;
  var cursor = this.cursor();
  var codMultiTrans = cursor.valueBuffer("codmultitransstock");
  //  var encontrado = true;
  if (!_i.existeReferencia(barcode)) {
    //    encontrado = false;
    var q = new AQSqlQuery;
    q.setSelect("aa.barcode, aa.talla, aa.color, a.referencia, a.descripcion, a.codfamilia");
    q.setFrom("atributosarticulos aa INNER JOIN articulos a ON aa.referencia = a.referencia");
    q.setWhere("aa.barcode = '" + barcode + "'");
    if (!q.exec()) {
      return false;
    }
    if (!q.first()) {
      return false;
    }
    if (!_i.incluirBarcode(q)) {
      return false;
    }

    q.setSelect("aa.barcode,a.descripcion,a.referencia,a.codfamilia,aa.talla,aa.color");
    q.setFrom("tpv_barcodemultitransstock b INNER JOIN atributosarticulos aa ON b.barcode = aa.barcode INNER JOIN articulos a ON b.referencia = a.referencia");
    q.setWhere("b.codmultitransstock = '" + codMultiTrans + "' AND b.barcode = '" + barcode + "' order by a.codfamilia,a.descripcion");
    q.setForwardOnly(true);
    debug(q.sql());
    if (!q.exec()) {
      return;
    }

    if (!_i.cargaLineas(q, "TAB")) {
      return false;
    }
  }

  if (!_i.existeReferencia(barcode))
    return false;

  var f = _i.idArticulos_[barcode];
  //  if (!encontrado) {
  if (!_i.ponCantidad1(f)) {
    return false;
  }
  //  }
  _i.tblTransstock_.clearSelection();
  _i.tblTransstock_.selectRow(f);

  this.child("lneReferencia").text = "";
  this.child("lneReferencia").setFocus();
}

function multiTc_tbnCalcular_clicked()
{
  var _i = this.iface;
  if (!_i.limpiarTabla()) {
    return false;
  }

  var cursor = this.cursor();

  //   _i.tblTransstock_.clear();
  var codMultiTrans = cursor.valueBuffer("codmultitransstock");
  if (!codMultiTrans || codMultiTrans == "") {
    return;
  }
  var codAlmaOrigen = cursor.valueBuffer("codalmaorigen");
  if (!codAlmaOrigen || codAlmaOrigen == "") {
    return;
  }
  var lA = _i.listaAlmacenes();
  if (lA == "") {
    return;
  }
  var wStockPos = "";
  if (cursor.valueBuffer("solostockpos")) {
    wStockPos = " AND s.disponible > 0";
  }
  var wFechas = "";
  var desde = cursor.valueBuffer("fdesderecom");
  if (desde) {
    wFechas += " AND c.fecha >= '" + desde + "'";
  }
  var hasta = cursor.valueBuffer("fhastarecom");
  if (desde) {
    wFechas += " AND c.fecha <= '" + hasta + "'";
  }

  var q = new FLSqlQuery;
  q.setSelect("a.referencia,a.descripcion,a.codfamilia, c.codalmacen, SUM(lc.cantidad)");
  q.setFrom("tpv_comandas c INNER JOIN tpv_lineascomanda lc ON c.idtpv_comanda = lc.idtpv_comanda INNER JOIN articulos a ON lc.referencia = a.referencia LEFT OUTER JOIN atributosarticulos aa ON a.referencia = aa.referencia INNER JOIN stocks s ON (a.referencia = s.referencia AND s.codalmacen = '" + codAlmaOrigen + "' AND s.barcode IS NULL) INNER JOIN tpv_artmultitransstock m ON (a.referencia = m.referencia AND m.codmultitransstock = '" + codMultiTrans + "')");
  q.setWhere("c.codalmacen IN (" + lA + ")" + wFechas + wStockPos + " AND aa.referencia IS NULL GROUP BY a.referencia, a.descripcion, a.codfamilia, c.codalmacen HAVING SUM(lc.cantidad) > 0 ORDER BY a.codfamilia, a.descripcion, c.codalmacen");
  q.setForwardOnly(true);
  debug(q.sql());
  if (!q.exec()) {
    return;
  }
  _i.cargaLineas(q, "REP");

  q = new FLSqlQuery;
  q.setSelect("aa.barcode, a.referencia,a.descripcion,a.codfamilia, aa.talla, aa.color, c.codalmacen, SUM(lc.cantidad)");
  q.setFrom("tpv_comandas c INNER JOIN tpv_lineascomanda lc ON c.idtpv_comanda = lc.idtpv_comanda INNER JOIN articulos a ON lc.referencia = a.referencia INNER JOIN atributosarticulos aa ON a.referencia = aa.referencia INNER JOIN stocks s ON (aa.barcode = s.barcode AND s.codalmacen = '" + codAlmaOrigen + "') INNER JOIN tpv_barcodemultitransstock b ON (aa.barcode = b.barcode AND b.codmultitransstock = '" + codMultiTrans + "')");
  q.setWhere("c.codalmacen IN (" + lA + ")"  + wFechas + wStockPos + " GROUP BY a.referencia, a.descripcion, a.codfamilia, c.codalmacen, aa.barcode, aa.talla, aa.color HAVING SUM(lc.cantidad) > 0 ORDER BY a.codfamilia, a.descripcion, c.codalmacen");
  q.setForwardOnly(true);
  debug(q.sql());
  if (!q.exec()) {
    return;
  }
  _i.cargaLineas(q, "REP");


  _i.habilitaPestanaSets();
  _i.tblTransstock_.repaintContents();
}
//// MULTI_TC /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
