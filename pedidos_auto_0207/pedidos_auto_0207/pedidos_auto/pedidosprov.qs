
/** @class_declaration pedidosauto */
/////////////////////////////////////////////////////////////////
//// PEDIDOS_AUTO //////////////////////////////////////////////
class pedidosauto extends oficial
{
  var curLineaPedido;
  function pedidosauto(context)
  {
    oficial(context);
  }
  function init()
  {
    return this.ctx.pedidosauto_init();
  }
  function seleccionarLineas_clicked()
  {
    return this.ctx.pedidosauto_seleccionarLineas_clicked();
  }
  function insertarLinea(idPedido, eArticulo)
  {
    return this.ctx.pedidosauto_insertarLinea(idPedido, eArticulo);
  }
  function datosLineaPedido(idPedido, eArticulo)
  {
    return this.ctx.pedidosauto_datosLineaPedido(idPedido, eArticulo);
  }
}
//// PEDIDOS_AUTO //////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition pedidosauto */
/////////////////////////////////////////////////////////////////
//// PEDIDOS_AUTO ///////////////////////////////////////////////
function pedidosauto_init()
{
  this.iface.__init();
  connect(this.child("tbInsert"), "clicked()", this, "iface.seleccionarLineas_clicked");
}

function pedidosauto_seleccionarLineas_clicked()
{
  var cursor = this.cursor();
  var util = new FLUtil();
  var codProveedor = cursor.valueBuffer("codproveedor");
  if (!codProveedor || codProveedor == "") {
    MessageBox.information(util.translate("scripts", "Debe establecer el proveedor"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }

  var codAlmacen = cursor.valueBuffer("codalmacen");
  if (!codAlmacen || codAlmacen == "") {
    MessageBox.information(util.translate("scripts", "Debe establecer el almacén"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }

  var curLineas = this.child("tdbArticulosPedProv").cursor();
  if (!curLineas.commitBufferCursorRelation()) {
    return false;
  }

  var f: Object = new FLFormSearchDB("seleccionarticulos");
  var curLineas: FLSqlCursor = f.cursor();
  var datos: String = "";
  curLineas.select();
  if (!curLineas.first()) {
    curLineas.setModeAccess(curLineas.Insert);
  } else {
    curLineas.setModeAccess(curLineas.Edit);
  }

  f.setMainWidget();
  curLineas.refreshBuffer();

  if (codProveedor && codProveedor != "") {
    curLineas.setValueBuffer("codproveedor", codProveedor);
  }

  if (codAlmacen && codAlmacen != "") {
    curLineas.setValueBuffer("codalmacen", codAlmacen);
  }

  datos = f.exec("datos");
  if (!datos || datos == "")
    return false;

  var xmlDatos: FLDomDocument = new FLDomDocument;
  if (!xmlDatos.setContent(datos)) {
    return false;
  }
  var xmlArticulos: FLDomNodeList = xmlDatos.elementsByTagName("Articulo");
  if (xmlArticulos && xmlArticulos.count() > 0) {
    for (var i: Number = 0; i < xmlArticulos.count(); i++) {
      eArticulo = xmlArticulos.item(i).toElement();
      referencia = eArticulo.attribute("Referencia");

      if (!this.iface.insertarLinea(cursor.valueBuffer("idpedido"), eArticulo)) {
        return false;
      }
    }
  }

  this.child("tdbArticulosPedProv").refresh();
}

function pedidosauto_insertarLinea(idPedido, eArticulo)
{
  debug("pedidosauto_insertarLinea");
  var util: FLUtil = new FLUtil();

  this.iface.curLineaPedido = new FLSqlCursor("lineaspedidosprov");
  this.iface.curLineaPedido.setModeAccess(this.iface.curLineaPedido.Insert);
  this.iface.curLineaPedido.refreshBuffer();

  if (!this.iface.datosLineaPedido(idPedido, eArticulo)) {
    return false;
  }

  if (!this.iface.curLineaPedido.commitBuffer()) {
    return false;
  }

  this.iface.calcularTotales();

  return true;
}

function pedidosauto_datosLineaPedido(idPedido, eArticulo)
{
  var util = new FLUtil();
  var referencia: String = eArticulo.attribute("Referencia");
  var descripcion = util.sqlSelect("articulos", "descripcion", "referencia = '" + referencia + "'");
  var cantidad: Number = eArticulo.attribute("Pedir");

  this.iface.curLineaPedido.setValueBuffer("idpedido", idPedido);
  this.iface.curLineaPedido.setValueBuffer("referencia", referencia);
  this.iface.curLineaPedido.setValueBuffer("descripcion", descripcion);
  this.iface.curLineaPedido.setValueBuffer("cantidad", cantidad);
  this.iface.curLineaPedido.setValueBuffer("pvpunitario", formRecordlineaspedidosprov.iface.pub_commonCalculateField("pvpunitario", this.iface.curLineaPedido));
  this.iface.curLineaPedido.setValueBuffer("pvpsindto", formRecordlineaspedidosprov.iface.pub_commonCalculateField("pvpsindto", this.iface.curLineaPedido));
  this.iface.curLineaPedido.setValueBuffer("codimpuesto", formRecordlineaspedidosprov.iface.pub_commonCalculateField("codimpuesto", this.iface.curLineaPedido));
  this.iface.curLineaPedido.setValueBuffer("iva", formRecordlineaspedidosprov.iface.pub_commonCalculateField("iva", this.iface.curLineaPedido));
  this.iface.curLineaPedido.setValueBuffer("recargo", formRecordlineaspedidosprov.iface.pub_commonCalculateField("recargo", this.iface.curLineaPedido));
  this.iface.curLineaPedido.setValueBuffer("dtopor", formRecordlineaspedidosprov.iface.pub_commonCalculateField("dtopor", this.iface.curLineaPedido));
  this.iface.curLineaPedido.setValueBuffer("dtolineal", 0);
  this.iface.curLineaPedido.setValueBuffer("pvptotal", formRecordlineaspedidosprov.iface.pub_commonCalculateField("pvptotal", this.iface.curLineaPedido));

  var irpfSeriePed: String;
  irpfSeriePed = util.sqlSelect("pedidosprov p INNER JOIN series s ON p.codserie = s.codserie", "s.irpf", "p.idpedido = " + this.iface.curLineaPedido.valueBuffer("idpedido"), "pedidosprov,series");
  if (irpfSeriePed) {
    this.iface.curLineaPedido.setValueBuffer("irpf", irpfSeriePed);
  }

  return true;
}

//// PEDIDOS_AUTO ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
