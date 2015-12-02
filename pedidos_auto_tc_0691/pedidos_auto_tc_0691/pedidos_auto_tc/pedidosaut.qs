
/** @class_declaration pedautotc */
/////////////////////////////////////////////////////////////////
//// PEDIDOS_AUTO_TC ///////////////////////////////////////////
class pedautotc extends oficial
{
  function pedautotc(context)
  {
    oficial(context);
  }
  function seleccionarLineas()
  {
    return this.ctx.pedautotc_seleccionarLineas();
  }
  function insertarLinea(idPedidoAut, eArticulo, codProveedor)
  {
    return this.ctx.pedautotc_insertarLinea(idPedidoAut, eArticulo, codProveedor);
  }
}
//// PEDIDOS_AUTO_TC ///////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition pedautotc */
/////////////////////////////////////////////////////////////////
//// PEDIDOS_AUTO_TC ////////////////////////////////////////////
/** \D Se agrega articulos a la remesa.
\end */
function pedautotc_seleccionarLineas()
{
  var util: FLUtil = new FLUtil();
  var cursor: FLSqlCursor = this.cursor();
  var codProveedor: String = cursor.valueBuffer("codproveedor");
  var codAlmacen: String = cursor.valueBuffer("codalmacen");
  var datos: String = "";

  if (!codProveedor) {
    MessageBox.warning(util.translate("scripts", "Es necesario seleccionar un proveedor"), MessageBox.Ok, MessageBox.NoButton);
    return;
  }

  if (!codAlmacen) {
    MessageBox.warning(util.translate("scripts", "Es necesario seleccionar un almacen"), MessageBox.Ok, MessageBox.NoButton);
    return;
  }

  var f: Object = new FLFormSearchDB("seleccionarticulos");
  var curLineas: FLSqlCursor = f.cursor();
  var fecha: String = cursor.valueBuffer("fecha");

  if (cursor.modeAccess() != cursor.Browse)
    if (!cursor.checkIntegrity())
      return;

  curLineas.select();
  if (!curLineas.first()) {
    curLineas.setModeAccess(curLineas.Insert);
  } else {
    curLineas.setModeAccess(curLineas.Edit);
  }

  // preset already selected articles (datos = referencias in lineaspedidosaut )
  var qryLineasSel: FLSqlQuery = new FLSqlQuery();
  with(qryLineasSel) {
    setTablesList("lineaspedidosaut");
    setSelect("referencia, barcode, talla, color, cantidad");
    setFrom("lineaspedidosaut");
    setWhere("idpedidoaut = " + cursor.valueBuffer("idpedidoaut") + " ORDER BY referencia");
    setForwardOnly(true);
  }
  if (!qryLineasSel.exec()) {
    return;
  }

  var xmlDatos: FLDomDocument = new FLDomDocument;
  xmlDatos.setContent("<PedidoAuto/>");
  var eArticulo: FLDomElement;
  while (qryLineasSel.next()) {
    eArticulo = xmlDatos.createElement("Articulo");
    eArticulo.setAttribute("Referencia", qryLineasSel.value("referencia"));
    eArticulo.setAttribute("Barcode", qryLineasSel.value("barcode"));
    eArticulo.setAttribute("Talla", qryLineasSel.value("talla"));
    eArticulo.setAttribute("Color", qryLineasSel.value("color"));
    eArticulo.setAttribute("Pedir", qryLineasSel.value("cantidad"));
    xmlDatos.firstChild().appendChild(eArticulo);
  }

  f.setMainWidget();
  curLineas.refreshBuffer();
  curLineas.setValueBuffer("datos", xmlDatos.toString(4));

  if (codProveedor && codProveedor != "") {
    curLineas.setValueBuffer("codproveedor", codProveedor);
  }

  if (codAlmacen && codAlmacen != "") {
    curLineas.setValueBuffer("codalmacen", codAlmacen);
  }

  datos = f.exec("datos");
  if (!datos || datos == "")
    return false;

  if (!this.iface.insertarLineas(datos, cursor))
    return false;

  this.child("tdbArticulos").refresh();
  this.child("fdbDivisa").setDisabled(true);
}

function pedautotc_insertarLinea(idPedidoAut, eArticulo, codProveedor)
{
  var util = new FLUtil;
  var referencia = eArticulo.attribute("Referencia");
  var barcode = eArticulo.attribute("Barcode");
  var talla = eArticulo.attribute("Talla");
  var color = eArticulo.attribute("Color");
  var cantidad = eArticulo.attribute("Pedir");
  var descripcion = util.sqlSelect("articulos", "descripcion", "referencia = '" + referencia + "'");

  var curLineasOrder: FLSqlCursor = new FLSqlCursor("lineaspedidosaut");
  with(curLineasOrder) {
    setModeAccess(Insert);
    refreshBuffer();
    setActivatedCheckIntegrity(false);
    setValueBuffer("idpedidoaut", idPedidoAut);
    setValueBuffer("referencia", referencia);
    setValueBuffer("barcode", barcode);
    setValueBuffer("talla", talla);
    setValueBuffer("color", color);
    setValueBuffer("descripcion", descripcion);
    setValueBuffer("cantidad", cantidad);
  }

  if (!curLineasOrder.commitBuffer()) {
    debug("!curLineasOrder.commitBuffer");
    return false;
  }
  debug("return true");
  return true;
}


//// PEDIDOS_AUTO_TC ////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
