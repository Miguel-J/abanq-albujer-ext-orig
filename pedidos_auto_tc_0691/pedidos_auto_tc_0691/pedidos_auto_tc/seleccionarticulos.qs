
/** @class_declaration pedautotc */
/////////////////////////////////////////////////////////////////
//// PEDIDOS_AUTO_TC ////////////////////////////////////////////
class pedautotc extends oficial
{
  var COL_BARC;
  var COL_TALLA;
  var COL_COLOR;
  function pedautotc(context)
  {
    oficial(context);
  }
  function generarTabla()
  {
    return this.ctx.pedautotc_generarTabla();
  }
  function cargarTabla()
  {
    return this.ctx.pedautotc_cargarTabla();
  }
  function buscar()
  {
    return this.ctx.pedautotc_buscar();
  }
  function guardarDatos()
  {
    return this.ctx.pedautotc_guardarDatos();
  }
}
//// PEDIDOS_AUTO_TC ////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition pedautotc */
/////////////////////////////////////////////////////////////////
//// PEDIDOS_AUTO_TC ///////////////////////////////////////////
function pedautotc_generarTabla()
{
  var util: FLUtil = new FLUtil;

  this.iface.COL_SEL = 0;
  this.iface.COL_REF = 1;
  this.iface.COL_BARC = 2;
  this.iface.COL_TALLA = 3;
  this.iface.COL_COLOR = 4;
  this.iface.COL_DES = 5;
  this.iface.COL_SMIN = 6;
  this.iface.COL_SDIS = 7;
  this.iface.COL_PREC = 8;
  this.iface.COL_PEDIR = 9;

  this.iface.tblArticulos.setNumCols(10);
  this.iface.tblArticulos.setColumnWidth(this.iface.COL_REF, 120);
  this.iface.tblArticulos.setColumnWidth(this.iface.COL_BARC, 120);
  this.iface.tblArticulos.setColumnWidth(this.iface.COL_TALLA, 50);
  this.iface.tblArticulos.setColumnWidth(this.iface.COL_COLOR, 50);
  this.iface.tblArticulos.setColumnWidth(this.iface.COL_DES, 350);
  this.iface.tblArticulos.setColumnWidth(this.iface.COL_SMIN, 80);
  this.iface.tblArticulos.setColumnWidth(this.iface.COL_SDIS, 80);
  this.iface.tblArticulos.setColumnWidth(this.iface.COL_PREC, 80);
  this.iface.tblArticulos.setColumnWidth(this.iface.COL_PEDIR, 80);

  this.iface.tblArticulos.setColumnReadOnly(this.iface.COL_REF, true);
  this.iface.tblArticulos.setColumnReadOnly(this.iface.COL_BARC, true);
  this.iface.tblArticulos.setColumnReadOnly(this.iface.COL_TALLA, true);
  this.iface.tblArticulos.setColumnReadOnly(this.iface.COL_COLOR, true);
  this.iface.tblArticulos.setColumnReadOnly(this.iface.COL_DES, true);
  this.iface.tblArticulos.setColumnReadOnly(this.iface.COL_SMIN, true);
  this.iface.tblArticulos.setColumnReadOnly(this.iface.COL_SDIS, true);
  this.iface.tblArticulos.setColumnReadOnly(this.iface.COL_PREC, true);
  this.iface.tblArticulos.setColumnReadOnly(this.iface.COL_PEDIR, false);

  var cabeceras: String = " /" + util.translate("scripts", "Referencia") + "/" + util.translate("scripts", "Barcode") + "/" + util.translate("scripts", "Talla") + "/" + util.translate("scripts", "Color") + "/" + util.translate("scripts", "Descripción") + "/" + util.translate("scripts", "S.Mínimo (M)") + "/" + util.translate("scripts", "S.Disponible (D)") + "/" + util.translate("scripts", "S.Por Recibir (R)") + "/" + util.translate("scripts", "A Pedir (P=M-D-R)");
  this.iface.tblArticulos.setColumnLabels("/", cabeceras);
  this.iface.tblArticulos.hideColumn(this.iface.COL_SEL);
}

function pedautotc_cargarTabla()
{
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();
  var codAlmacen = cursor.valueBuffer("codalmacen");

  this.iface.limpiarTabla();

  var datos: String = cursor.valueBuffer("datos");
  var xmlDatos: FLDomDocument = new FLDomDocument;
  if (!xmlDatos.setContent(datos)) {
    return false;
  }
  var xmlArticulos: FLDomNodeList = xmlDatos.elementsByTagName("Articulo");
  if (xmlArticulos && xmlArticulos.count() > 0) {
    var eArticulo: FLDomElement;
    var referencia: String;
    var barcode: String;
    var sMin: Number;
    var sDis: Number;
    var pteRecibir: Number;
    var pedir: Number;
    var groupBy: String = " GROUP BY a.descripcion, at.barcode, at.talla, at.color, s.stockmin";
    var oArticulo = new Object;

    var qryStock: FLSqlQuery = new FLSqlQuery;
    qryStock.setTablesList("articulos,atributosarticulos,stocks");
    qryStock.setSelect("a.descripcion, at.barcode, at.talla, at.color, s.stockmin, SUM(s.pterecibir), SUM(s.disponible)");
    qryStock.setFrom("articulos a LEFT OUTER JOIN atributosarticulos at ON a.referencia = at.referencia LEFT OUTER JOIN stocks s ON ((at.barcode = s.barcode OR (a.referencia = s.referencia AND at.barcode IS NULL)) AND codalmacen = '" + codAlmacen + "')");
    qryStock.setForwardOnly(true);

    for (var i: Number = 0; i < xmlArticulos.count(); i++) {
      eArticulo = xmlArticulos.item(i).toElement();
      referencia = eArticulo.attribute("Referencia");
      barcode = eArticulo.attribute("Barcode");
      oArticulo.referencia = referencia;
      oArticulo.barcode = barcode;
      if (barcode) {
        qryStock.setWhere("s.barcode = '" + barcode + "'" + groupBy);
      } else {
        qryStock.setWhere("s.referencia = '" + referencia + "'" + groupBy);
      }
      if (!qryStock.exec()) {
        return false;
      }
      if (!qryStock.first()) {
        return false;
      }

      sMin = (isNaN(qryStock.value("s.stockmin")) ? 0 : qryStock.value("s.stockmin"));
      sDis = (isNaN(qryStock.value("SUM(s.disponible)")) ? 0 : qryStock.value("SUM(s.disponible)"));
      sDis += this.iface.dameDisponibleCompuestos(oArticulo, codAlmacen);
      pteRecibir = (isNaN(qryStock.value("SUM(s.pterecibir)")) ? 0 : qryStock.value("SUM(s.pterecibir)"));
      pedir = eArticulo.attribute("Pedir");

      this.iface.tblArticulos.insertRows(i);
      this.iface.tblArticulos.setText(i, this.iface.COL_REF, referencia);
      this.iface.tblArticulos.setText(i, this.iface.COL_BARC, qryStock.value("at.barcode"));
      this.iface.tblArticulos.setText(i, this.iface.COL_TALLA, qryStock.value("at.talla"));
      this.iface.tblArticulos.setText(i, this.iface.COL_COLOR, qryStock.value("at.color"));
      this.iface.tblArticulos.setText(i, this.iface.COL_DES, qryStock.value("a.descripcion"));
      this.iface.tblArticulos.setText(i, this.iface.COL_SMIN, sMin);
      this.iface.tblArticulos.setText(i, this.iface.COL_SDIS, sDis);
      this.iface.tblArticulos.setText(i, this.iface.COL_PREC, pteRecibir);
      this.iface.tblArticulos.setText(i, this.iface.COL_PEDIR, pedir);
      this.iface.tblArticulos.setText(i, this.iface.COL_SEL, "S");
      this.iface.colorearFila(i);
    }
  } else {
    this.iface.buscar();
  }
}

function pedautotc_buscar()
{
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();
  var codAlmacen = cursor.valueBuffer("codalmacen");

  this.iface.limpiarTabla();

  var filtro: String = "1 = 1";
  var fromSelect: String = "articulos a LEFT OUTER JOIN atributosarticulos at ON a.referencia = at.referencia LEFT OUTER JOIN stocks s ON ((at.barcode = s.barcode OR (a.referencia = s.referencia AND at.barcode IS NULL)) AND codalmacen = '" + codAlmacen + "')";
  if (this.child("chkFiltrarArtProv").checked) {
    filtro += " AND ap.codproveedor = '" + cursor.valueBuffer("codproveedor") + "'";
    fromSelect += " INNER JOIN articulosprov ap ON a.referencia = ap.referencia";
  }
  if (this.child("chkFiltrarArtStockMin").checked) {
    filtro += " AND a.stockmin > 0";
  }

  var groupBy: String = " GROUP BY a.referencia, at.barcode, at.talla, at.color, a.descripcion, s.stockmin ORDER BY a.referencia";
  var qryStock: FLSqlQuery = new FLSqlQuery;
  qryStock.setTablesList("articulos,atributosarticulos,stocks,articulosprov");
  qryStock.setSelect("a.referencia, at.barcode, at.talla, at.color, a.descripcion, s.stockmin, SUM(s.disponible), SUM(s.pterecibir)");
  qryStock.setFrom(fromSelect);
  qryStock.setWhere(filtro + groupBy);
  qryStock.setForwardOnly(true);
  debug("q = " + qryStock.sql());
  if (!qryStock.exec()) {
    return false;
  }
  var totalArticulos: Number = qryStock.size();
  var referencia: String;
  var sMin: Number;
  var sDis: Number;
  var pteRecibir: Number;
  var pedir: Number;
  var oArticulo = new Object();

  var iFila: Number = 0;
  util.createProgressDialog(util.translate("scripts", "Informando tabla de artículos"), totalArticulos);
  while (qryStock.next()) {
    util.setProgress(iFila);
    oArticulo.referencia = qryStock.value("a.referencia");
    oArticulo.barcode = qryStock.value("at.barcode");
    sMin = (isNaN(qryStock.value("s.stockmin")) ? 0 : qryStock.value("s.stockmin"));
    sDis = (isNaN(qryStock.value("SUM(s.disponible)")) ? 0 : qryStock.value("SUM(s.disponible)"));
    sDis += this.iface.dameDisponibleCompuestos(oArticulo, codAlmacen);
    pteRecibir = (isNaN(qryStock.value("SUM(s.pterecibir)")) ? 0 : qryStock.value("SUM(s.pterecibir)"));
    pedir = sMin - (sDis + pteRecibir);
    if (pedir < 0) {
      pedir = 0;
    }

    if (this.child("chkFiltrarArtStockFis").checked) {
      if (sMin <= (sDis + pteRecibir)) {
        continue;
      }
    }
    if (this.child("chkFiltrarArtStockOrd").checked) {
      if ((sMin - (sDis + pteRecibir)) < cursor.valueBuffer("cantidadmin")) {
        continue;
      }
    }

    this.iface.tblArticulos.insertRows(iFila);
    this.iface.tblArticulos.setText(iFila, this.iface.COL_REF, qryStock.value("a.referencia"));
    this.iface.tblArticulos.setText(iFila, this.iface.COL_BARC, qryStock.value("at.barcode"));
    this.iface.tblArticulos.setText(iFila, this.iface.COL_TALLA, qryStock.value("at.talla"));
    this.iface.tblArticulos.setText(iFila, this.iface.COL_COLOR, qryStock.value("at.color"));
    this.iface.tblArticulos.setText(iFila, this.iface.COL_DES, qryStock.value("a.descripcion"));
    this.iface.tblArticulos.setText(iFila, this.iface.COL_SMIN, sMin);
    this.iface.tblArticulos.setText(iFila, this.iface.COL_SDIS, sDis);
    this.iface.tblArticulos.setText(iFila, this.iface.COL_PREC, pteRecibir);
    this.iface.tblArticulos.setText(iFila, this.iface.COL_PEDIR, pedir);
    this.iface.tblArticulos.setText(iFila, this.iface.COL_SEL, "N");
    this.iface.colorearFila(iFila);
    iFila++;
  }
  util.destroyProgressDialog();
}

function pedautotc_guardarDatos()
{
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  var numFilas: Number = this.iface.tblArticulos.numRows();
  var xmlDatos: FLDomDocument = new FLDomDocument;
  xmlDatos.setContent("<PedidoAuto/>");
  var eArticulo: FLDomElement;
  for (var iFila: Number = 0; iFila < numFilas; iFila++) {
    if (this.iface.tblArticulos.text(iFila, this.iface.COL_SEL) == "N") {
      continue;
    }
    eArticulo = xmlDatos.createElement("Articulo");
    eArticulo.setAttribute("Referencia", this.iface.tblArticulos.text(iFila, this.iface.COL_REF));
    eArticulo.setAttribute("Barcode", this.iface.tblArticulos.text(iFila, this.iface.COL_BARC));
    eArticulo.setAttribute("Talla", this.iface.tblArticulos.text(iFila, this.iface.COL_TALLA));
    eArticulo.setAttribute("Color", this.iface.tblArticulos.text(iFila, this.iface.COL_COLOR));
    eArticulo.setAttribute("Pedir", this.iface.tblArticulos.text(iFila, this.iface.COL_PEDIR));
    xmlDatos.firstChild().appendChild(eArticulo);
  }
  cursor.setValueBuffer("datos", xmlDatos.toString(4));
  this.accept();
}


//// PEDIDOS_AUTO_TC ///////////////////////////////////////////
/////////////////////////////////////////////////////////////////
