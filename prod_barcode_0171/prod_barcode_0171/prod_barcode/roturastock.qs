
/** @class_declaration prodBarcode */
/////////////////////////////////////////////////////////////////
//// PRODUCCIÓN - BARCODE ///////////////////////////////////////
class prodBarcode extends oficial
{
  var BARCODE: Number;
  var TALLA: Number;
  var COLOR: Number;
  function prodBarcode(context)
  {
    oficial(context);
  }
  function iniciarTabla()
  {
    return this.ctx.prodBarcode_iniciarTabla();
  }
  function consultaBusqueda(): FLSqlQuery {
    return this.ctx.prodBarcode_consultaBusqueda();
  }
  function incluirDatosExtraFila(fila: Number, qryDatos: FLSqlQuery)
  {
    return this.ctx.prodBarcode_incluirDatosExtraFila(fila, qryDatos);
  }
  function generarListaArticulos(): Boolean {
    return this.ctx.prodBarcode_generarListaArticulos();
  }
}
//// PRODUCCIÓN - BARCODE ///////////////////////////////////////
/////////////////////////////////////////////////////////////////
/** @class_definition prodBarcode*/
/////////////////////////////////////////////////////////////////
//// PRODUCCIÓN - BARCODE ///////////////////////////////////////
function prodBarcode_iniciarTabla()
{
  var tblArticulos: QTable = this.child("tblArticulos");

  this.iface.INCLUIR = 0;
  this.iface.NUMPEDIDO = 1;
  this.iface.CODPROVEEDOR = 2;
  this.iface.NOMPROVEEDOR = 3;
  this.iface.REFERENCIA = 4;
  this.iface.DESARTICULO = 5;
  this.iface.BARCODE = 6;
  this.iface.TALLA = 7;
  this.iface.COLOR = 8;
  this.iface.FECHAROTURA = 9;
  this.iface.PLAZO = 10;
  this.iface.FECHAPEDIDO = 11;
  this.iface.STOCKACTUAL = 12;
  this.iface.STOCKMIN = 13;
  this.iface.PEDIR = 14;
  this.iface.IDSTOCK = 15;

  tblArticulos.setNumCols(16);
  tblArticulos.setColumnWidth(this.iface.INCLUIR, 50);
  tblArticulos.setColumnWidth(this.iface.NUMPEDIDO, 40);
  tblArticulos.setColumnWidth(this.iface.CODPROVEEDOR, 60);
  tblArticulos.setColumnWidth(this.iface.NOMPROVEEDOR, 120);
  tblArticulos.setColumnWidth(this.iface.REFERENCIA, 80);
  tblArticulos.setColumnWidth(this.iface.DESARTICULO, 100);
  tblArticulos.setColumnWidth(this.iface.BARCODE, 100)
  tblArticulos.setColumnWidth(this.iface.TALLA, 50);
  tblArticulos.setColumnWidth(this.iface.COLOR, 50);
  tblArticulos.setColumnWidth(this.iface.FECHAROTURA, 80);
  tblArticulos.setColumnWidth(this.iface.PLAZO, 50);
  tblArticulos.setColumnWidth(this.iface.FECHAPEDIDO, 80);
  tblArticulos.setColumnWidth(this.iface.STOCKACTUAL, 50);
  tblArticulos.setColumnWidth(this.iface.STOCKMIN, 50);
  tblArticulos.setColumnWidth(this.iface.PEDIR, 50);
  tblArticulos.hideColumn(this.iface.IDSTOCK);

  tblArticulos.setColumnLabels("/", "Incluir/Nº/C.P./Proveedor/Ref./Artículo/Barcode/Talla/ColorF.Pedido/Plazo/F.Rotura/Actual/Mínimo/Pedir/idStock");
}

function prodBarcode_consultaBusqueda(): FLSqlQuery {
  var miWhere: String = this.iface.construirWhere();
  if (!miWhere)
    return false;

  var qryArticulos = new FLSqlQuery;
  with(qryArticulos)
  {
    setTablesList("articulos,articulosprov,stocks,proveedores,atributosarticulos");
    setSelect("ap.codproveedor, p.nombre, a.referencia, a.descripcion, a.stockmin, ap.plazo, s.cantidad, s.idstock, aa.barcode, aa.talla, aa.color");
    setFrom("articulos a LEFT OUTER JOIN articulosprov ap ON a.referencia = ap.referencia INNER JOIN proveedores p ON ap.codproveedor = p.codproveedor LEFT OUTER JOIN atributosarticulos aa ON a.referencia = aa.referencia LEFT OUTER JOIN stocks s ON (a.referencia = s.referencia AND aa.barcode = s.barcode)");
    setWhere(miWhere);
    setForwardOnly(true);
  }
  if (!qryArticulos.exec())
    return false;

  return qryArticulos;
}

function prodBarcode_incluirDatosExtraFila(fila: Number, qryDatos: FLSqlQuery)
{
  var tblArticulos: QTable = this.child("tblArticulos");

  tblArticulos.setText(fila, this.iface.BARCODE, qryDatos.value("aa.barcode"));
  tblArticulos.setText(fila, this.iface.TALLA, qryDatos.value("aa.talla"));
  tblArticulos.setText(fila, this.iface.COLOR, qryDatos.value("aa.color"));
}

/** \D
Elabora un string en el que figuran, los artículos incluidos en la lista. Este string se usará para generar las líneas de pedidos de proveedor.
\end */
function prodBarcode_generarListaArticulos(): Boolean {
  var util: FLUtil = new FLUtil;
  var valor: Boolean = true;
  var cursor: FLSqlCursor = this.cursor();
  var tblArticulos: QTable = this.child("tblArticulos");
  var lista: String = "";
  var fila: Number;
  var maxNumPedido: Number = 0;
  for (fila = 0; fila < tblArticulos.numRows(); fila++)
  {
    if (tblArticulos.text(fila, this.iface.NUMPEDIDO) > maxNumPedido)
      maxNumPedido = tblArticulos.text(fila, this.iface.NUMPEDIDO);
  }
  for (var numPedido: Number = 1; numPedido <= maxNumPedido; numPedido++)
  {
    for (fila = 0; fila < tblArticulos.numRows(); fila++) {
      if (tblArticulos.text(fila, this.iface.INCLUIR) == "Sí" && parseFloat(tblArticulos.text(fila, this.iface.PEDIR)) > 0 && tblArticulos.text(fila, this.iface.NUMPEDIDO) == numPedido) {
        if (lista != "")
          lista += ",";
        lista += tblArticulos.text(fila, this.iface.NUMPEDIDO) + ";" + tblArticulos.text(fila, this.iface.CODPROVEEDOR) + ";" + tblArticulos.text(fila, this.iface.REFERENCIA) + ";" + tblArticulos.text(fila, this.iface.BARCODE) + ";" + util.dateDMAtoAMD(tblArticulos.text(fila, this.iface.FECHAPEDIDO)) + ";" + util.dateDMAtoAMD(tblArticulos.text(fila, this.iface.FECHAROTURA)) + ";" + tblArticulos.text(fila, this.iface.PEDIR);
      }
    }
  }
  debug(lista);
  cursor.setValueBuffer("lista", lista);
  return valor;
}

//// PRODUCCIÓN - BARCODE ///////////////////////////////////////
////////////////////////////////////////////////////////////////
