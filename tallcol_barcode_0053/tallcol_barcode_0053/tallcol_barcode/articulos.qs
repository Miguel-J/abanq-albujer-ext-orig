
/** @class_declaration barCode */
/////////////////////////////////////////////////////////////////
//// TALLAS Y COLORES POR BARCODE ///////////////////////////////
class barCode extends oficial
{
  var aTallas_, aColores_;
  var tblTallas: QTable;
  var tblColores: QTable;
  var tblMatrizPrecios: QTable;
  var tblMatrizBarcodes: QTable;
  var tblStock: QTable;
  var listaTallas: String;
  var listaColores: String;
  var tbwTC: Object;
  var arrayStock: Array;
  var datosModificados: Boolean;
  var ultimoBarcode_: String;
  var calculoBarcode_: String;
  var digitosBarcode_: String;
  var prefijoBarcode_: String;
  var stockMinModificado_;
  var stockMaxModificado_;

  function barCode(context)
  {
    oficial(context);
  }
  function init()
  {
    return this.ctx.barCode_init();
  }
  function columnasVentas()
  {
    return this.ctx.barCode_columnasVentas();
  }
  function columnasCompras()
  {
    return this.ctx.barCode_columnasCompras();
  }
  function validateForm(): Boolean {
    return this.ctx.barCode_validateForm();
  }
  function bufferChanged(fN: String)
  {
    return this.ctx.barCode_bufferChanged(fN);
  }
  function tblStockMin_valueChanged(fila, col)
  {
    return this.ctx.barCode_tblStockMin_valueChanged(fila, col);
  }
  function tblStockMax_valueChanged(fila, col)
  {
    return this.ctx.barCode_tblStockMax_valueChanged(fila, col);
  }
  function refrescarTablaStock(tblStock: FLTable, arrayStock: Array, cursor: FLSqlCursor): Array {
    return this.ctx.barCode_refrescarTablaStock(tblStock, arrayStock, cursor);
  }
  function pbnTransferir_clicked()
  {
    return this.ctx.barCode_pbnTransferir_clicked();
  }
  function pbnRegularizar_clicked()
  {
    return this.ctx.barCode_pbnRegularizar_clicked();
  }
  function pbnGuardarStockMin_clicked()
  {
    return this.ctx.barCode_pbnGuardarStockMin_clicked();
  }
  function pbnGuardarStockMax_clicked()
  {
    return this.ctx.barCode_pbnGuardarStockMax_clicked();
  }
  function guardarStockMinMax(minOMax)
  {
    return this.ctx.barCode_guardarStockMinMax(minOMax);
  }
  function refrescarColores()
  {
    return this.ctx.barCode_refrescarColores();
  }
  function generarTC()
  {
    return this.ctx.barCode_generarTC();
  }
  function guardarTC()
  {
    return this.ctx.barCode_guardarTC();
  }
  function guardarPreciosTarifas()
  {
    return this.ctx.barCode_guardarPreciosTarifas();
  }
  function reloadTallas()
  {
    return this.ctx.barCode_reloadTallas();
  }
  function reloadColores()
  {
    return this.ctx.barCode_reloadColores();
  }
  function reloadMatrizPrecios()
  {
    return this.ctx.barCode_reloadMatrizPrecios();
  }
  function reloadMatrizPreciosTarifas()
  {
    return this.ctx.barCode_reloadMatrizPreciosTarifas();
  }
  function clickedTalla(fil: Number, col: Number)
  {
    return this.ctx.barCode_clickedTalla(fil, col);
  }
  function clickedColor(fil: Number, col: Number)
  {
    return this.ctx.barCode_clickedColor(fil, col);
  }
  function clickedBC(fil: Number, col: Number)
  {
    return this.ctx.barCode_clickedBC(fil, col);
  }
  function clickedPrecios(fil: Number, col: Number)
  {
    return this.ctx.barCode_clickedPrecios(fil, col);
  }
  function obtenerPrecioTC(referencia, numT, numC)
  {
    return this.ctx.barCode_obtenerPrecioTC(referencia, numT, numC);
  }
  function obtenerBarcode(referencia: String, codTalla: String, codColor: String): String {
    return this.ctx.barCode_obtenerBarcode(referencia, codTalla, codColor);
  }
  function digitoControlEAN(valorSinDC: String): String {
    return this.ctx.barCode_digitoControlEAN(valorSinDC);
  }
  function validarModStockMinMax()
  {
    return this.ctx.barCode_validarModStockMinMax();
  }
  function ponStockModificado(minOMax, modificado)
  {
    return this.ctx.barCode_ponStockModificado(minOMax, modificado);
  }
  function cargaArraysTC()
  {
    return this.ctx.barCode_cargaArraysTC();
  }
  function dameArrayTallas()
  {
    return this.ctx.barCode_dameArrayTallas();
  }
  function dameArrayColores()
  {
    return this.ctx.barCode_dameArrayColores();
  }
  function ponArrayTallas(aT)
  {
    return this.ctx.barCode_ponArrayTallas(aT);
  }
  function ponArrayColores(aC)
  {
    return this.ctx.barCode_ponArrayColores(aC);
  }
  function pbnTCRapida_clicked()
  {
    return this.ctx.barCode_pbnTCRapida_clicked();
  }
}
//// TALLAS Y COLORES POR BARCODE ///////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pubBarCode */
/////////////////////////////////////////////////////////////////
//// PUB TALLAS Y COLORES ///////////////////////////////////////
class pubBarCode extends ifaceCtx
{
  function pubBarCode(context)
  {
    ifaceCtx(context);
  }
  function pub_refrescarTablaStock(tblStock: FLTable, arrayStock: Array, cursor: FLSqlCursor): Array {
    return this.refrescarTablaStock(tblStock, arrayStock, cursor);
  }
  function pub_obtenerBarcode(referencia: String, codTalla: String, codColor: String): String {
    return this.obtenerBarcode(referencia, codTalla, codColor);
  }
  function pub_digitoControlEAN(valorSinDC)
  {
    return this.digitoControlEAN(valorSinDC);
  }
}
//// PUB TALLAS Y COLORES ///////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition barCode */
/////////////////////////////////////////////////////////////////
//// TALLAS Y COLORES POR BARCODE ///////////////////////////////
function barCode_columnasVentas()
{
  return ["codigo", "fecha", "codcliente", "talla", "color", "nombre", "pvpunitario", "cantidad", "pvpsindto", "pvptotal"];
}

function barCode_columnasCompras()
{
  return ["codigo", "fecha", "codproveedor", "nombre", "talla", "color", "pvpunitario", "cantidad", "pvpsindto", "pvptotal"];
}

function barCode_init()
{
  var _i = this.iface;
  _i.__init();

  _i.tblStock = this.child("tblStock");
  _i.tblTallas = this.child("tblTallas");
  _i.tblColores = this.child("tblColores");
  _i.tbwTC = this.child("tbwTC");
  _i.tblMatrizPrecios = this.child("tblMatrizPrecios");
  _i.tblMatrizBarcodes = this.child("tblMatrizBarcodes");
  _i.ultimoBarcode_ = false;
  _i.calculoBarcode_ = flfactalma.iface.pub_valorDefectoAlmacen("calculobarcode");
  _i.digitosBarcode_ = flfactalma.iface.pub_valorDefectoAlmacen("digitosbarcode");
  _i.prefijoBarcode_ = flfactalma.iface.pub_valorDefectoAlmacen("prefijobarcode");
  if (!_i.prefijoBarcode_ || _i.prefijoBarcode_ == "NULL") {
    _i.prefijoBarcode_ = "";
  }

  connect(this.child("pbnTCRapida"), "clicked()", _i, "pbnTCRapida_clicked()");
  connect(this.child("pbnTransferir"), "clicked()", this, "iface.pbnTransferir_clicked()");
  connect(this.child("pbnRegularizar"), "clicked()", this, "iface.pbnRegularizar_clicked()");
  connect(this.child("pbnGenerarTC"), "clicked()", this, "iface.generarTC()");
  connect(this.child("pbnGenerarPrecios"), "clicked()", this, "iface.reloadMatrizPrecios()");
  connect(this.child("pbnGuardarTC"), "clicked()", this, "iface.guardarTC()");
  connect(this.child("pbnGenerarPreciosTarifas"), "clicked()", this, "iface.reloadMatrizPreciosTarifas()");
  connect(this.child("pbnGuardarPreciosTarifas"), "clicked()", this, "iface.guardarPreciosTarifas()");
  connect(this.child("pbnGuardarStockMin"), "clicked()", this, "iface.pbnGuardarStockMin_clicked");
  connect(this.child("pbnGuardarStockMax"), "clicked()", this, "iface.pbnGuardarStockMax_clicked");
  connect(_i.tblTallas, "clicked(int,int)", this, "iface.clickedTalla");
  connect(_i.tblColores, "clicked(int,int)", this, "iface.clickedColor");
  connect(_i.tblMatrizBarcodes, "clicked(int,int)", this, "iface.clickedBC");
  connect(_i.tblMatrizPrecios, "clicked(int,int)", this, "iface.clickedPrecios");
  connect(_i.tblMatrizPrecios, "clicked(int,int)", this, "iface.clickedPrecios");
  connect(this.child("tblStockMin"), "valueChanged(int, int)", this, "iface.tblStockMin_valueChanged()");
  connect(this.child("tblStockMax"), "valueChanged(int, int)", this, "iface.tblStockMax_valueChanged()");

  this.child("pbnGenerarPrecios").setDisabled(true);
  this.child("pbnGuardarTC").setDisabled(true);
  this.child("pbnGuardarPreciosTarifas").setDisabled(true);

  var cursor = this.cursor();

  if (cursor.modeAccess() == cursor.Edit) {
    _i.generarTC();
    _i.reloadMatrizPrecios();
  }

  if (cursor.modeAccess() == cursor.Insert) {
    this.child("fdbCodAlmacenStock").setValue(flfactppal.iface.pub_valorDefectoEmpresa("codalmacen"));
  } else {
    _i.arrayStock = _i.refrescarTablaStock(_i.tblStock, _i.arrayStock, cursor);
  }
  _i.ponStockModificado("min", false);
  _i.ponStockModificado("max", false);
}

function barCode_pbnTCRapida_clicked()
{
  var _i = this.iface;
  var cursor = this.cursor();

  if (cursor.modeAccess() == cursor.Insert) {
    if (!this.child("tdbAtributosArticulos").cursor().commitBufferCursorRelation()) {
      return false;
    }
  }

  if (!_i.cargaArraysTC()) {
    return false;
  }
  var f = new FLFormSearchDB("altatcrapida");
  var curTC = f.cursor();
  curTC.setModeAccess(curTC.Insert);
  curTC.refreshBuffer();
  curTC.setValueBuffer("referencia", cursor.valueBuffer("referencia"));
  f.setMainWidget();
  f.exec("id");
  if (!f.accepted()) {
    return;
  }
  _i.reloadTallas();
  _i.reloadColores();
  _i.tblMatrizBarcodes.clear();
  _i.reloadMatrizPrecios();
}

function barCode_cargaArraysTC()
{
  var _i = this.iface;
  var cursor = this.cursor();

  var referencia = cursor.valueBuffer("referencia");
  var qryTallas = new FLSqlQuery;
  qryTallas.setTablesList("atributosarticulos,tallas");
  qryTallas.setSelect("a.talla, t.orden");
  qryTallas.setFrom("atributosarticulos a INNER JOIN tallas t ON a.talla = t.codtalla");
  qryTallas.setWhere("a.referencia = '" + referencia + "' AND a.talla IS NOT NULL GROUP BY a.talla, t.orden ORDER BY t.orden");
  qryTallas.setForwardOnly(true);
  if (!qryTallas.exec()) {
    return;
  }
  _i.aTallas_ = new Array(qryTallas.size());
  var i = 0;
  while (qryTallas.next()) {
    _i.aTallas_ [i++] = qryTallas.value("a.talla");
  }

  var qryColores: FLSqlQuery = new FLSqlQuery;
  qryColores.setTablesList("coloresarticulo");
  qryColores.setSelect("codcolor");
  qryColores.setFrom("coloresarticulo");
  qryColores.setWhere("referencia = '" + referencia + "' ORDER BY codcolor");
  qryColores.setForwardOnly(true);
  if (!qryColores.exec()) {
    return;
  }
  _i.aColores_ = new Array(qryColores.size());
  i = 0;
  while (qryColores.next()) {
    _i.aColores_ [i++] = qryColores.value("codcolor");
  }
  return true;
}

function barCode_dameArrayTallas()
{
  var _i = this.iface;
  return _i.aTallas_;
}

function barCode_dameArrayColores()
{
  var _i = this.iface;
  return _i.aColores_;
}

function barCode_ponArrayTallas(aT)
{
  var _i = this.iface;
  _i.aTallas_ = aT;
}

function barCode_ponArrayColores(aC)
{
  var _i = this.iface;
  _i.aColores_ = aC;
}

function barCode_tblStockMin_valueChanged(fila, col)
{
  this.iface.ponStockModificado("min", true);
}

function barCode_tblStockMax_valueChanged(fila, col)
{
  this.iface.ponStockModificado("max", true);
}

function barCode_bufferChanged(fN: String)
{
  var cursor: FLSqlCursor = this.cursor();

  switch (fN) {
    case "codalmacenstock": {
      this.iface.arrayStock = this.iface.refrescarTablaStock(this.iface.tblStock, this.iface.arrayStock, this.cursor());
      break;
    }
    default: {
      this.iface.__bufferChanged(fN);
    }
  }
}

/** \D Compone una tabla de tantas filas como tallas y tantas columnas como colores hay definidos para el artículo seleccionado, indicando en cada celda la cantidad existente para la combinación talla / color en el almacén seleccionado */
function barCode_refrescarTablaStock(tblStock: FLTable, arrayStock: Array, cursor: FLSqlCursor): Array {
  var util: FLUtil = new FLUtil;
  var referencia: String = cursor.valueBuffer("referencia");
  var codAlmacen: String = cursor.valueBuffer("codalmacenstock");

  var tblStockMin = this.child("tblStockMin");
  var tblStockMax = this.child("tblStockMax");
  var bMinMax = (cursor.table() == "articulos" && tblStockMin);

  if (!referencia || !codAlmacen || referencia == "" || codAlmacen == "")
    return;

  var numFilas: Number = tblStock.numRows();
  var numColumnas: Number;

  tblStock.setNumRows(0);
  if (bMinMax)
  {
    tblStockMin.setNumRows(0);
    tblStockMax.setNumRows(0);
  }
  //  for (var i:Number = (numFilas - 1); i >= 0; i--)
  //    tblStock.removeRow(i);

  var codGrupoTalla: String = util.sqlSelect("articulos", "codgrupotalla", "referencia = '" + referencia + "'");
  var listaTallas: String = "";
  var tallas: Array = [];
  var qryTallas: FLSqlQuery = new FLSqlQuery;

  qryTallas.setTablesList("atributosarticulos,tallas");
  qryTallas.setSelect("a.talla, t.orden");
  qryTallas.setFrom("atributosarticulos a INNER JOIN tallas t ON a.talla = t.codtalla");
  qryTallas.setWhere("a.referencia = '" + referencia + "' AND a.talla IS NOT NULL GROUP BY a.talla, t.orden ORDER BY t.orden");

  qryTallas.setForwardOnly(true);
  if (!qryTallas.exec())
    return;
  numColumnas = 0;
  var sep: String = "|";
  while (qryTallas.next())
  {
    tallas[numColumnas++] = qryTallas.value(0);
    if (listaTallas)
      listaTallas += sep;
    listaTallas += qryTallas.value(0);
  }
  tblStock.setNumCols(numColumnas);
  tblStock.setColumnLabels(sep, listaTallas);
  if (bMinMax)
  {
    tblStockMin.setNumCols(numColumnas);
    tblStockMin.setColumnLabels(sep, listaTallas);
    tblStockMax.setNumCols(numColumnas);
    tblStockMax.setColumnLabels(sep, listaTallas);
  }

  var listaColores: String = "";
  var colores: Array = [];
  var qryColores: FLSqlQuery = new FLSqlQuery;
  qryColores.setTablesList("coloresarticulo");
  qryColores.setSelect("codcolor");
  qryColores.setFrom("coloresarticulo");
  qryColores.setWhere("referencia = '" + referencia + "' ORDER BY codcolor");
  if (!qryColores.exec())
    return;
  numFilas = 0;
  while (qryColores.next())
  {
    colores[numFilas++] = qryColores.value("codcolor");
    if (listaColores)
      listaColores += sep;
    listaColores += qryColores.value("codcolor");
  }
  tblStock.insertRows(0, numFilas);
  tblStock.setRowLabels(sep, listaColores);
  if (bMinMax)
  {
    tblStockMin.insertRows(0, numFilas);
    tblStockMin.setRowLabels(sep, listaColores);
    tblStockMax.insertRows(0, numFilas);
    tblStockMax.setRowLabels(sep, listaColores);
  }
  if (arrayStock)
    delete arrayStock;
  arrayStock = new Array(numFilas);
  for (var i: Number = 0; i < numFilas; i++)
  {
    arrayStock[i] = new Array(numColumnas);
    for (var k: Number = 0; k < numColumnas; k++) {
      arrayStock[i][k] = new Array(3);
      arrayStock[i][k]["idstock"] = false;
      arrayStock[i][k]["talla"] = tallas[k];
      arrayStock[i][k]["color"] = colores[i];
    }
  }

  var qryStock: FLSqlQuery = new FLSqlQuery;
  qryStock.setTablesList("stocks,atributosarticulos");
  qryStock.setSelect("aa.talla, aa.color, s.cantidad, s.stockmin, s.stockmax, s.idstock");
  qryStock.setFrom("atributosarticulos aa INNER JOIN stocks s ON s.barcode = aa.barcode");
  qryStock.setWhere("aa.referencia = '" + referencia + "' AND s.codalmacen = '" + codAlmacen + "'");
  if (!qryStock.exec())
    return false;

  var cantidad, stockMin, stockMax;
  while (qryStock.next())
  {
    for (numFilas = 0; numFilas < colores.length; numFilas++) {
      if (colores[numFilas] == qryStock.value("aa.color"))
        break;
    }
    if (numFilas == colores.length)
      continue;

    for (numColumnas = 0; numColumnas < tallas.length; numColumnas++) {
      if (tallas[numColumnas ] == qryStock.value("aa.talla"))
        break;
    }
    if (numColumnas == tallas.length)
      continue;

    cantidad = parseInt(qryStock.value("s.cantidad"));
    cantidad = !cantidad || isNaN(cantidad) ? 0 : cantidad;
    stockMin = parseInt(qryStock.value("s.stockmin"));
    stockMin = !stockMin || isNaN(stockMin) ? 0 : stockMin;
    stockMax = parseInt(qryStock.value("s.stockmax"));
    stockMax = !stockMin || isNaN(stockMax) ? 0 : stockMax;

    tblStock.setText(numFilas, numColumnas, cantidad);
    if (bMinMax) {
      tblStockMin.setText(numFilas, numColumnas, stockMin);
      tblStockMax.setText(numFilas, numColumnas, stockMax);
    }
    arrayStock[numFilas][numColumnas]["idstock"] = qryStock.value("s.idstock");
    arrayStock[numFilas][numColumnas]["talla"] = qryStock.value("aa.talla");
    arrayStock[numFilas][numColumnas]["color"] = qryStock.value("aa.color");
  }
  return arrayStock;
}

function barCode_pbnTransferir_clicked()
{
  var util: FLUtil = new FLUtil;
  var curTransStock: FLSqlCursor = new FLSqlCursor("transstock");
  curTransStock.insertRecord();
  /*
    var idStock = this.iface.arrayStock[this.iface.tblStock.currentRow()][this.iface.tblStock.currentColumn()]["idstock"];
    if (!idStock) {
      MessageBox.information(util.translate("scripts", "Debe seleccionar un stock existente para realizar la transferencia"), MessageBox.Ok, MessageBox.NoButton);
      return;
    }
    if (!formregstocks.iface.pub_transferirStock(idStock))
      return;
    this.iface.arrayStock = this.iface.refrescarTablaStock(this.iface.tblStock, this.iface.arrayStock, this.cursor());
  */
}

function barCode_pbnRegularizar_clicked()
{
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();
  var referencia: String = cursor.valueBuffer("referencia");

  formregstocks.iface.pub_insertarRegularizaciones(referencia, cursor.valueBuffer("codalmacenstock"));
  this.iface.arrayStock = this.iface.refrescarTablaStock(this.iface.tblStock, this.iface.arrayStock, cursor);
  this.child("fdbStockFisico").setValue(util.sqlSelect("stocks", "SUM(cantidad)", "referencia = '" + referencia + "'"));
}

function barCode_pbnGuardarStockMin_clicked()
{
  var util = new FLUtil;
  var curTrans: FLSqlCursor = new FLSqlCursor("empresa");
  curTrans.transaction(false);
  try {
    if (this.iface.guardarStockMinMax("min")) {
      curTrans.commit();
      this.iface.ponStockModificado("min", false)
      MessageBox.information(util.translate("scripts", "Datos de stock mínimo guardados"), MessageBox.Ok, MessageBox.NoButton);
    } else {
      curTrans.rollback();
      return false;
    }
  } catch (e) {
    curTrans.rollback();
    MessageBox.critical(util.translate("scripts", "Error al guardar los datos de stock mínimo"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
}

function barCode_pbnGuardarStockMax_clicked()
{
  var util = new FLUtil;
  var curTrans: FLSqlCursor = new FLSqlCursor("empresa");
  curTrans.transaction(false);
  try {
    if (this.iface.guardarStockMinMax("max")) {
      curTrans.commit();
      this.iface.ponStockModificado("max", false)
      MessageBox.information(util.translate("scripts", "Datos de stock máximo guardados"), MessageBox.Ok, MessageBox.NoButton);
    } else {
      curTrans.rollback();
      return false;
    }
  } catch (e) {
    curTrans.rollback();
    MessageBox.critical(util.translate("scripts", "Error al guardar los datos de stock máximo"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
}

function barCode_guardarStockMinMax(minOMax)
{
  var util = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();
  var codAlmacen = cursor.valueBuffer("codalmacenstock");
  var referencia = cursor.valueBuffer("referencia");
  var tblStock, campoStock, valorStock, nombreStock;
  if (minOMax == "min") {
    tblStock = this.child("tblStockMin");
    campoStock = "stockmin";
    nombreStock = "mínimo";
  } else {
    tblStock = this.child("tblStockMax");
    campoStock = "stockmax";
    nombreStock = "máximo";
  }
  var curStock = new FLSqlCursor("stocks");
  curStock.setActivatedCommitActions(false);
  var stockMin, idStock, barcode, talla, color, oArticulo;
  oArticulo = new Object();
  oArticulo["referencia"] = false;
  oArticulo["barcode"] = false;
  for (var f = 0; f < tblStock.numRows(); f++) {
    for (var c = 0; c < tblStock.numCols(); c++) {
      valorStock = tblStock.text(f, c);
      if (valorStock != "" && !isNaN(valorStock)) {
        idStock = this.iface.arrayStock[f][c]["idstock"]
                  talla = this.iface.arrayStock[f][c]["talla"]
                          color = this.iface.arrayStock[f][c]["color"]
        if (!idStock || idStock == undefined) {
          barcode = util.sqlSelect("atributosarticulos", "barcode", "referencia = '" + referencia + "' AND talla = '" + talla + "' AND color = '" + color + "'");
          if (!barcode) {
            MessageBox.warning(util.translate("scripts", "Error al guardar el stock %1. No existe un barcode para la combinación %2 - %3 - %4.\nBorre el valor de stock mínimo o cree el barcode correspondiente").arg(nombreStock).arg(referencia).arg(talla).arg(color), MessageBox.Ok, MessageBox.NoButton);
            return false;
          }
          oArticulo["referencia"] = referencia;
          oArticulo["barcode"] = barcode;
          idStock = flfactalma.iface.pub_crearStock(codAlmacen, oArticulo);
          if (!idStock) {
            MessageBox.warning(util.translate("scripts", "Error al crear el stock para la combinación %1 - %2 - %3.").arg(referencia).arg(talla).arg(color), MessageBox.Ok, MessageBox.NoButton);
            return false;
          }
          this.iface.arrayStock[f][c]["idstock"] = idStock;
        }
        curStock.select("idstock = " + idStock);
        if (!curStock.first()) {
          return false;
        }
        curStock.setModeAccess(curStock.Edit);
        curStock.refreshBuffer();
        curStock.setValueBuffer(campoStock, valorStock);
        if (!curStock.commitBuffer()) {
          return false;
        }
      }
    }
  }
  return true;
}

function barCode_refrescarColores()
{
  this.child("tdbColoresArticulo").refresh();
}

function barCode_generarTC()
{
  var util: FLUtil = new FLUtil();

  var cursor: FLSqlCursor = this.cursor();
  if (cursor.modeAccess() == cursor.Insert) {
    var curAA: FLSqlCursor = this.child("tdbAtributosArticulos").cursor();
    curAA.setModeAccess(curAA.Insert);
    if (!curAA.commitBufferCursorRelation())
      return false;
  }

  if (this.iface.tblTallas.numRows() || this.iface.tblColores.numRows()) {
    res = MessageBox.information(util.translate("scripts", "Si recarga las tallas y colores se eliminarán los cambios no guardados\n\n¿Continuar?"), MessageBox.Yes, MessageBox.No, MessageBox.NoButton);
    if (res != MessageBox.Yes)
      return;
  }

  this.iface.reloadTallas();
  this.iface.reloadColores();
  this.iface.tbwTC.showPage("tallas");
  this.child("pbnGenerarPrecios").setDisabled(false);
}

function barCode_reloadTallas()
{
  var util = new FLUtil();
  var cursor = this.cursor();
  var _i = this.iface;

  var referencia = cursor.valueBuffer("referencia");
  if (!referencia)
    return;

  var curTabA = new FLSqlCursor("tallasarticulo");

  var codSet = this.cursor().valueBuffer("codsettallas");
  var pvp = this.cursor().valueBuffer("pvp");

  var qryTab: FLSqlQuery = new FLSqlQuery;
  if (codSet) {
    qryTab.setTablesList("tallasset,tallas");
    qryTab.setSelect("ts.codset,t.codtalla,t.orden");
    qryTab.setFrom("tallasset ts INNER JOIN tallas t ON ts.codtalla = t.codtalla");
    qryTab.setWhere("codset = '" + codSet + "' ORDER BY t.orden");
  } else {
    qryTab.setTablesList("atributosarticulos,tallas");
    qryTab.setSelect("t.codtalla, t.orden");
    qryTab.setFrom("atributosarticulos a INNER JOIN tallas t ON a.talla = t.codtalla");
    qryTab.setWhere("a.referencia = '" + referencia + "' AND a.talla IS NOT NULL GROUP BY t.codtalla, t.orden ORDER BY t.orden");

  }
  if (!qryTab.exec()) {
    return false;
  }

  var fila: Number;
  _i.tblTallas.clear();

  fila = 0;
  var codTalla;

  while (qryTab.next()) {
    codTalla = qryTab.value("t.codtalla");

    _i.tblTallas.insertRows(fila, 1);
    _i.tblTallas.setText(fila, 0, /*curTab.valueBuffer("codtalla")*/ codTalla);

    curTabA.select("referencia = '" + referencia + "' AND codtalla = '" + /*curTab.valueBuffer("codtalla")*/codTalla + "'");
    if (curTabA.first()) {
      _i.tblTallas.setText(fila, 2, curTabA.valueBuffer("pvp"));
      if (curTabA.valueBuffer("activo"))
        this.iface.tblTallas.setText(fila, 3, "X");
    } else {
      _i.tblTallas.setText(fila, 2, pvp);
      _i.tblTallas.setText(fila, 3, "X");
    }

    descTalla = util.sqlSelect("tallas", "descripcion", "codtalla = '" + /*curTab.valueBuffer("codtalla")*/codTalla + "'");
    _i.tblTallas.setText(fila, 1, descTalla);

    fila++;
  }

  _i.tblTallas.setColumnReadOnly(0, true);
  _i.tblTallas.setColumnReadOnly(1, true);
  _i.tblTallas.setColumnReadOnly(3, true);
}

function barCode_reloadColores()
{
  var cursor = this.cursor();
  var _i = this.iface;
  var referencia = cursor.valueBuffer("referencia");
  if (!referencia) {
    return;
  }
  var curTab = new FLSqlCursor("coloresset");
  var curTabA = new FLSqlCursor("coloresarticulo");

  var codSet: String = cursor.valueBuffer("codsetcolores");

  var util = new FLUtil();

  var fila: Number;
  _i.tblColores.clear();

  fila = 0;
  if (codSet) {
    curTab.select("codset = '" + codSet + "'");
    while (curTab.next()) {
      _i.tblColores.insertRows(fila, 1);
      _i.tblColores.setText(fila, 0, curTab.valueBuffer("codcolor"));
      curTabA.select("referencia = '" + referencia + "' AND codcolor = '" + curTab.valueBuffer("codcolor") + "'");
      if (curTabA.first()) {
        _i.tblColores.setText(fila, 2, curTabA.valueBuffer("incporcentual"));
        _i.tblColores.setText(fila, 3, curTabA.valueBuffer("inclineal"));
        if (curTabA.valueBuffer("activo"))
          _i.tblColores.setText(fila, 4, "X");
      } else {
        _i.tblColores.setText(fila, 2, 0);
        _i.tblColores.setText(fila, 3, 0);
        _i.tblColores.setText(fila, 4, "X");
      }
      descColor = util.sqlSelect("colores", "descripcion", "codcolor = '" + curTab.valueBuffer("codcolor") + "'");
      _i.tblColores.setText(fila, 1, descColor);
      fila++;
    }
  } else {
    curTabA.select("referencia = '" + referencia + "'");
    while (curTabA.next()) {
      _i.tblColores.insertRows(fila, 1);
      _i.tblColores.setText(fila, 0, curTabA.valueBuffer("codcolor"));
      _i.tblColores.setText(fila, 2, curTabA.valueBuffer("incporcentual"));
      _i.tblColores.setText(fila, 3, curTabA.valueBuffer("inclineal"));
      if (curTabA.valueBuffer("activo")) {
        _i.tblColores.setText(fila, 4, "X");
      }
      descColor = util.sqlSelect("colores", "descripcion", "codcolor = '" + curTabA.valueBuffer("codcolor") + "'");
      _i.tblColores.setText(fila, 1, descColor);
      fila++;
    }
  }

  _i.tblColores.setColumnReadOnly(0, true);
  _i.tblColores.setColumnReadOnly(1, true);
  _i.tblColores.setColumnReadOnly(4, true);
}

function barCode_reloadMatrizPrecios()
{
  var util: FLUtil = new FLUtil();

  if (this.iface.tblMatrizBarcodes.numRows()) {
    res = MessageBox.information(util.translate("scripts", "Si regenera los precios y barcodes se eliminarán los cambios no guardados\n\n¿Continuar?"), MessageBox.Yes, MessageBox.No, MessageBox.NoButton);
    if (res != MessageBox.Yes)
      return;
  }

  this.iface.listaTallas = "";
  this.iface.listaColores = "";

  var listaTallasBC: String = "";
  var preciosTallas: Array = [];
  var codigosTallas: Array = [];

  var sep: String = "|";

  var fila: Number = 0;
  var col: Number = 0;

  var referencia: String = this.cursor().valueBuffer("referencia");

  this.iface.tblMatrizPrecios.clear();
  this.iface.tblMatrizBarcodes.clear();

  for (numT = 0; numT < this.iface.tblTallas.numRows(); numT++) {

    if (!this.iface.tblTallas.text(numT, 3))
      continue;

    if (this.iface.listaTallas)
      this.iface.listaTallas += sep;

    this.iface.listaTallas += this.iface.tblTallas.text(numT, 0);
    listaTallasBC += sep + this.iface.tblTallas.text(numT, 0);
    listaTallasBC += sep + util.translate("scripts", "Activo");

    codigosTallas[col] = this.iface.tblTallas.text(numT, 0);
    preciosTallas[col] = this.iface.tblTallas.text(numT, 2);
    col++;
  }

  if (!col)
    return;

  this.iface.tblMatrizPrecios.setNumCols(col);
  this.iface.tblMatrizPrecios.setColumnLabels(sep, this.iface.listaTallas);

  this.iface.tblMatrizBarcodes.setNumCols(col * 2);
  this.iface.tblMatrizBarcodes.setColumnLabels(sep, listaTallasBC);

  for (numT = 0; numT < col; numT++)
    this.iface.tblMatrizBarcodes.setColumnWidth(numT * 2 + 1, 45);

  for (numC = 0; numC < this.iface.tblColores.numRows(); numC++) {

    if (!this.iface.tblColores.text(numC, 4))
      continue;

    if (this.iface.listaColores)
      this.iface.listaColores += sep;

    this.iface.listaColores += this.iface.tblColores.text(numC, 0);

    this.iface.tblMatrizPrecios.insertRows(fila, 1);
    this.iface.tblMatrizBarcodes.insertRows(fila, 1);

    for (numT = 0; numT < col; numT++) {

      precio = this.iface.obtenerPrecioTC(referencia, numT, numC);
      //        precio = parseFloat(preciosTallas[numT]);
      //        incPor = parseFloat(this.iface.tblColores.text(numC, 2));
      //        incLin = parseFloat(this.iface.tblColores.text(numC, 3));
      //
      //        precio = precio + precio*incPor/100 + incLin;
      this.iface.tblMatrizPrecios.setText(fila, numT, precio);

      barcode = this.iface.obtenerBarcode(referencia, codigosTallas[numT], this.iface.tblColores.text(numC, 0));
      if (!barcode) {
        break;
      }
      this.iface.tblMatrizBarcodes.setText(fila, numT * 2, barcode);
      this.iface.tblMatrizBarcodes.setText(fila, numT * 2 + 1, "X");
    }

    fila++;
  }

  if (!fila)
    return;

  this.iface.tblMatrizPrecios.setRowLabels(sep, this.iface.listaColores);
  this.iface.tblMatrizBarcodes.setRowLabels(sep, this.iface.listaColores);

  this.iface.tbwTC.showPage("precios");
  this.child("pbnGuardarTC").setDisabled(false);
}

function barCode_obtenerPrecioTC(referencia, numT, numC)
{
  var precio = parseFloat(this.iface.tblTallas.text(numT, 2)); //parseFloat(preciosTallas[numT]);
  var incPor = parseFloat(this.iface.tblColores.text(numC, 2));
  var incLin = parseFloat(this.iface.tblColores.text(numC, 3));

  precio + precio * incPor / 100 + incLin;
  return precio;
}


function barCode_obtenerBarcode(referencia: String, codTalla: String, codColor: String): String {
  var util: FLUtil = new FLUtil;
  var valor: String;
  if (!this.iface.calculoBarcode_ || this.iface.calculoBarcode_ == "")
  {
    if (flfactalma.iface.pub_valorDefectoAlmacen("calculobarcode") == "") {
      MessageBox.information(util.translate("scripts", "Para calcular los códigos barcode debe establecer el tipo de cálculo automático de barcode en \ndatos generales del módulo de almacén"), MessageBox.Ok, MessageBox.NoButton);
      return;
    }
    this.iface.calculoBarcode_ = flfactalma.iface.pub_valorDefectoAlmacen("calculobarcode");
  }


  switch (this.iface.calculoBarcode_)
  {
    case "Referencia+Talla+Color": {
      valor = referencia + codTalla + codColor;
      break;
    }
    case "Autonumérico": {
      var numero: Number;
      var cadenaNumero: String;
      var filtroPrefijo: String = "";
      var longPrefijo: Number = 0;
      if (this.iface.prefijoBarcode_ != "") {
        filtroPrefijo = " AND barcode LIKE '" + this.iface.prefijoBarcode_ + "%'";
        longPrefijo = this.iface.prefijoBarcode_.length;
      }
      var longNumero: Number = this.iface.digitosBarcode_ - longPrefijo;

      if (this.iface.ultimoBarcode_) {
        cadenaNumero = this.iface.ultimoBarcode_;
      } else {
        cadenaNumero = util.sqlSelect("atributosarticulos", "barcode", "LENGTH(barcode) = " + this.iface.digitosBarcode_ + filtroPrefijo + " ORDER BY barcode DESC");
      }
      if (cadenaNumero && cadenaNumero != "") {
        cadenaNumero = cadenaNumero.right(longNumero);
        numero = parseFloat(cadenaNumero);
        if (isNaN(numero)) {
          return false;
        }
      } else {
        numero = 0;
      }
      numero++;
      valor = this.iface.prefijoBarcode_ + flfactppal.iface.pub_cerosIzquierda(numero, longNumero);
      this.iface.ultimoBarcode_ = valor;
      break;
    }
    case "Autonumérico EAN13":
    case "Autonumérico EAN14": {
      var numero: Number;
      var cadenaNumero: String;
      var filtroPrefijo: String = "";
      var longPrefijo: Number = 0;
      if (this.iface.prefijoBarcode_ != "") {
        filtroPrefijo = " AND barcode LIKE '" + this.iface.prefijoBarcode_ + "%'";
        longPrefijo = this.iface.prefijoBarcode_.length;
      }
      var longNumero: Number = this.iface.digitosBarcode_ - longPrefijo - 1;
      if (this.iface.ultimoBarcode_) {
        cadenaNumero = this.iface.ultimoBarcode_;
      } else {
        cadenaNumero = util.sqlSelect("atributosarticulos", "barcode", "LENGTH(barcode) = " + this.iface.digitosBarcode_ + filtroPrefijo + " ORDER BY barcode DESC");
      }
      debug("cadenaNumero " + cadenaNumero);
      if (cadenaNumero && cadenaNumero != "") {
        cadenaNumero = cadenaNumero.mid(longPrefijo, longNumero);
        numero = parseFloat(cadenaNumero);
        debug("numeroparse " + numero);
        if (isNaN(numero)) {
          return false;
        }
      } else {
        numero = 0;
      }
      numero++;
      debug("numero " + numero);

      valor = this.iface.prefijoBarcode_ + flfactppal.iface.pub_cerosIzquierda(numero, longNumero);
      var dc: String = this.iface.digitoControlEAN(valor)
                       valor += dc;
      debug("valor = " + valor);
      this.iface.ultimoBarcode_ = valor;
      break;
    }
  }
  return valor;
}

function barCode_digitoControlEAN(valorSinDC: String): String {
  var pesos: Array;
  if (!valorSinDC || valorSinDC == "")
  {
    return false;
  }
  debug("dc para " + valorSinDC);
  var longValorSinDC: Number = valorSinDC.length;
  switch (longValorSinDC)
  {
    case 12: { /// EAN 13
      pesos = [1, 3, 1, 3, 1, 3, 1, 3, 1, 3, 1, 3];
      break;
    }
    case 13: { /// EAN 14
      pesos = [3, 1, 3, 1, 3, 1, 3, 1, 3, 1, 3, 1, 3];
      break;
    }
    default: {
      return false;
    }
  }
  var suma: Number = 0;
  for (var i: Number = 0; i < longValorSinDC; i++)
  {
    suma += parseInt(valorSinDC.charAt(i)) * parseInt(pesos[i]);
  }
  debug("suma = " + suma);
  var decenaSuperior: Number = (Math.floor(suma / 10) + 1) * 10;
  debug("decenaSuperior = " + decenaSuperior);
  var valor: Number = decenaSuperior - suma;
  if (valor == 10)
  {
    valor = 0;
  }
  debug("valor = " + valor);
  return valor.toString();
}

function barCode_reloadMatrizPreciosTarifas()
{
  var util: FLUtil = new FLUtil();
  var cursor: FLSqlCursor = this.cursor();

  if (this.iface.tblMatrizPrecios.numRows()) {
    res = MessageBox.information(util.translate("scripts", "Si regenera los precios se eliminarán los cambios no guardados\n\n¿Continuar?"), MessageBox.Yes, MessageBox.No, MessageBox.NoButton);
    if (res != MessageBox.Yes)
      return;
  }

  var preciosTallas: Array = [];
  var codigosTallas: Array = [];

  var sep: String = "|";

  var fila: Number = 0;
  var col: Number = 0;

  var referencia: String = cursor.valueBuffer("referencia");
  var codTarifaTC: String = cursor.valueBuffer("codtarifatc");
  var incLinTarifa: Number = 0;
  var incPorTarifa: Number = 0;

  var datosTarifa: Array;
  if (codTarifaTC) {
    datosTarifa = flfactppal.iface.pub_ejecutarQry("tarifas", "nombre,inclineal,incporcentual", "codtarifa = '" + codTarifaTC + "'");
    if (datosTarifa.result > 0) {
      incLinTarifa = parseFloat(datosTarifa.inclineal);
      incPorTarifa = parseFloat(datosTarifa.incporcentual);
      this.child("leTarifaCargada").text = util.translate("scripts", "Tarifa cargada") + ":  " + codTarifaTC + " - " + datosTarifa.nombre;
    }
  }

  for (numT = 0; numT < this.iface.tblTallas.numRows(); numT++) {

    if (!this.iface.tblTallas.text(numT, 3))
      continue;

    if (this.iface.listaTallas)
      this.iface.listaTallas += sep;

    this.iface.listaTallas += this.iface.tblTallas.text(numT, 0);

    codigosTallas[col] = this.iface.tblTallas.text(numT, 0);
    preciosTallas[col] = this.iface.tblTallas.text(numT, 2);
    col++;
  }

  if (!col) {
    MessageBox.information(util.translate("scripts", "Debe seleccionar al menos una talla"), MessageBox.Ok, MessageBox.NoButton);
    return;
  }


  for (numC = 0; numC < this.iface.tblColores.numRows(); numC++) {

    if (!this.iface.tblColores.text(numC, 4))
      continue;

    for (numT = 0; numT < col; numT++) {

      precio = parseFloat(preciosTallas[numT]);
      incPor = parseFloat(this.iface.tblColores.text(numC, 2));
      incLin = parseFloat(this.iface.tblColores.text(numC, 3));
      precio = precio + precio * incPor / 100 + incLin;

      if (codTarifaTC)
        precio = precio + precio * incPorTarifa / 100 + incLinTarifa;

      this.iface.tblMatrizPrecios.setText(fila, numT, precio);
    }

    fila++;
  }

  if (!fila) {
    MessageBox.information(util.translate("scripts", "Debe seleccionar al menos un color"), MessageBox.Ok, MessageBox.NoButton);
    return;
  }

  this.iface.tbwTC.showPage("precios");
  this.child("pbnGuardarPreciosTarifas").setDisabled(false);
}

function barCode_clickedTalla(fil: Number, col: Number)
{
  if (col != 3)
    return;

  if (this.iface.tblTallas.text(fil, col))
    this.iface.tblTallas.setText(fil, col, "");
  else
    this.iface.tblTallas.setText(fil, col, "X");

  this.iface.datosModificados = true;
}

function barCode_clickedColor(fil: Number, col: Number)
{
  if (col != 4)
    return;

  if (this.iface.tblColores.text(fil, col))
    this.iface.tblColores.setText(fil, col, "");
  else
    this.iface.tblColores.setText(fil, col, "X");

  this.iface.datosModificados = true;
}

function barCode_clickedBC(fil: Number, col: Number)
{
  if (col % 2 == 0)
    return;

  if (this.iface.tblMatrizBarcodes.text(fil, col))
    this.iface.tblMatrizBarcodes.setText(fil, col, "");
  else
    this.iface.tblMatrizBarcodes.setText(fil, col, "X");

  this.iface.datosModificados = true;
}

function barCode_clickedPrecios(fil: Number, col: Number)
{
  this.iface.datosModificados = true;
}

function barCode_guardarTC()
{
  var cursor: FLSqlCursor = this.cursor();

  var referencia: String = this.cursor().valueBuffer("referencia");
  if (!referencia)
    return;

  var pvpBase: Number = this.cursor().valueBuffer("pvp");
  if (!pvpBase)
    pvpBase = 0;

  var util: FLUtil = new FLUtil();
  var sep: String = "|";
  var t: Number, c: Number;

  var barcode: String;
  var precio: Number;

  var tallas: Array = this.iface.listaTallas.split(sep);
  var colores: Array = this.iface.listaColores.split(sep);

  var curTab: FLSqlCursor = new FLSqlCursor("atributosarticulos");

  for (c = 0; c < colores.length; c++)
    for (t = 0; t < tallas.length; t++) {

      if (!this.iface.tblMatrizBarcodes.text(c, t * 2 + 1))
        continue;

      barcode = this.iface.tblMatrizBarcodes.text(c, t * 2);
      if (!barcode)
        continue;

      precio = this.iface.tblMatrizPrecios.text(c, t);

      curTab.select("barcode = '" + barcode + "'");
      if (curTab.first()) {
        curTab.setModeAccess(curTab.Edit);
        curTab.refreshBuffer();
      } else {
        curTab.setModeAccess(curTab.Insert);
        curTab.refreshBuffer();
        curTab.setValueBuffer("referencia", referencia);
        curTab.setValueBuffer("barcode", barcode);
        curTab.setValueBuffer("talla", tallas[t]);
        curTab.setValueBuffer("color", colores[c]);
      }

      if (precio != pvpBase) {
        curTab.setValueBuffer("pvpespecial", true);
        curTab.setValueBuffer("pvp", precio);
      } else {
        curTab.setValueBuffer("pvpespecial", false);
        curTab.setNull("pvp");
      }

      curTab.commitBuffer();
    }

  var curTabC: FLSqlCursor = new FLSqlCursor("tallasarticulo");
  for (c = 0; c < this.iface.tblTallas.numRows(); c++) {
    curTabC.select("referencia = '" + referencia + "' AND codtalla = '" + this.iface.tblTallas.text(c, 0) + "'");
    if (curTabC.first()) {
      curTabC.setModeAccess(curTabC.Edit);
      curTabC.refreshBuffer();
    } else {
      curTabC.setModeAccess(curTabC.Insert);
      curTabC.refreshBuffer();
      curTabC.setValueBuffer("referencia", referencia);
      curTabC.setValueBuffer("codtalla", this.iface.tblTallas.text(c, 0));
    }
    curTabC.setValueBuffer("destalla", this.iface.tblTallas.text(c, 1));
    curTabC.setValueBuffer("pvp", this.iface.tblTallas.text(c, 2));
    if (this.iface.tblTallas.text(c, 3))
      curTabC.setValueBuffer("activo", true);
    else
      curTabC.setValueBuffer("activo", false);

    curTabC.commitBuffer();
  }


  var curTabC: FLSqlCursor = new FLSqlCursor("coloresarticulo");
  for (c = 0; c < this.iface.tblColores.numRows(); c++) {
    curTabC.select("referencia = '" + referencia + "' AND codcolor = '" + this.iface.tblColores.text(c, 0) + "'");
    if (curTabC.first()) {
      curTabC.setModeAccess(curTabC.Edit);
      curTabC.refreshBuffer();
    } else {
      curTabC.setModeAccess(curTabC.Insert);
      curTabC.refreshBuffer();
      curTabC.setValueBuffer("referencia", referencia);
      curTabC.setValueBuffer("codcolor", this.iface.tblColores.text(c, 0));
    }
    curTabC.setValueBuffer("descolor", this.iface.tblColores.text(c, 1));
    curTabC.setValueBuffer("incporcentual", this.iface.tblColores.text(c, 2));
    curTabC.setValueBuffer("inclineal", this.iface.tblColores.text(c, 3));
    if (this.iface.tblColores.text(c, 4))
      curTabC.setValueBuffer("activo", true);
    else
      curTabC.setValueBuffer("activo", false);

    curTabC.commitBuffer();
  }

  this.iface.datosModificados = false;

  this.iface.tbwTC.showPage("barcodes");
  this.child("tdbAtributosArticulos").refresh();
  this.child("tdbColoresArticulo").refresh();
}


function barCode_guardarPreciosTarifas()
{
  var cursor: FLSqlCursor = this.cursor();

  var referencia: String = this.cursor().valueBuffer("referencia");
  if (!referencia)
    return;

  var codTarifaTC: String = cursor.valueBuffer("codtarifatc");
  if (!codTarifaTC)
    return;

  var util: FLUtil = new FLUtil();

  res = MessageBox.information(util.translate("scripts", "A continuación se actualizarán todos los precios para la tarifa %0\n\n¿Continuar?").arg(codTarifaTC), MessageBox.Yes, MessageBox.No, MessageBox.NoButton);
  if (res != MessageBox.Yes)
    return;

  var sep: String = "|";
  var t: Number, c: Number;

  var barcode: String;
  var precio: Number;

  var tallas: Array = this.iface.listaTallas.split(sep);
  var colores: Array = this.iface.listaColores.split(sep);

  var curTab: FLSqlCursor = new FLSqlCursor("atributostarifas");

  for (c = 0; c < colores.length; c++)
    for (t = 0; t < tallas.length; t++) {

      if (!this.iface.tblMatrizBarcodes.text(c, t * 2 + 1))
        continue;

      barcode = this.iface.tblMatrizBarcodes.text(c, t * 2);
      if (!barcode)
        continue;

      precio = this.iface.tblMatrizPrecios.text(c, t);

      curTab.select("barcode = '" + barcode + "' and codtarifa = '" + codTarifaTC + "'");
      if (curTab.first()) {
        curTab.setModeAccess(curTab.Edit);
        curTab.refreshBuffer();
      } else {
        curTab.setModeAccess(curTab.Insert);
        curTab.refreshBuffer();
        curTab.setValueBuffer("barcode", barcode);
        curTab.setValueBuffer("codtarifa", codTarifaTC);
      }

      curTab.setValueBuffer("pvp", precio);
      curTab.commitBuffer();
    }

  this.iface.tbwTC.showPage("barcodes");
  this.child("tdbAtributosArticulos").refresh();
}

function barCode_validateForm(): Boolean {
  var util: FLUtil = new FLUtil();

  if (!this.iface.__validateForm())
    return false;

  if (this.iface.datosModificados)
  {
    var res = MessageBox.warning(util.translate("scripts", "Algunos valores de tallas, colores o precios han sido modificados.\nLos cambios aún no se guardaron como barcodes.\n\n¿Continuar?"), MessageBox.Yes, MessageBox.No, MessageBox.NoButton);
    if (res != MessageBox.Yes)
      return false;
  }

  if (!this.iface.validarModStockMinMax())
  {
    return false;
  }

  return true;
}

function barCode_validarModStockMinMax()
{
  var util = new FLUtil();
  var res;
  if (this.iface.stockMinModificado_) {
    res = MessageBox.warning(util.translate("scripts", "Algunos valores de stocks mínimo han sido modificados.\nLos cambios aún no se han guardado.\n\n¿Continuar?"), MessageBox.Yes, MessageBox.No);
    if (res != MessageBox.Yes) {
      return false;
    }
  }
  if (this.iface.stockMaxModificado_) {
    res = MessageBox.warning(util.translate("scripts", "Algunos valores de stocks máximo han sido modificados.\nLos cambios aún no se han guardado.\n\n¿Continuar?"), MessageBox.Yes, MessageBox.No);
    if (res != MessageBox.Yes) {
      return false;
    }
  }
  return true;
}

function barCode_ponStockModificado(minOMax, modificado)
{
  var util = new FLUtil();
  if (minOMax == "min") {
    this.iface.stockMinModificado_ = modificado;
  } else {
    this.iface.stockMaxModificado_ = modificado;
  }
  var lblStockMinMod = minOMax == "min" ? this.child("lblStockMinMod") : this.child("lblStockMaxMod");
  lblStockMinMod.text = modificado ? util.translate("scripts", "Datos modificados") : "";
  this.child("fdbCodAlmacenStockMin").setDisabled(this.iface.stockMinModificado_ || this.iface.stockMaxModificado_);
}

//// TALLAS Y COLORES POR BARCODE ///////////////////////////////
/////////////////////////////////////////////////////////////////
