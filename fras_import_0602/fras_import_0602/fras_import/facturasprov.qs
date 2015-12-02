
/** @class_declaration frasImport */
/////////////////////////////////////////////////////////////////
//// FRAS IMPORT ////////////////////////////////////////////////
class frasImport extends oficial
{
  var tdbLineas;
  var refImport;
  function frasImport(context)
  {
    oficial(context);
  }
  function init()
  {
    return this.ctx.frasImport_init();
  }
  function crearLinea_clicked()
  {
    return this.ctx.frasImport_crearLinea_clicked();
  }
  function crearLinea(): Boolean {
    return this.ctx.frasImport_crearLinea();
  }
  function buscarFacturaImport()
  {
    return this.ctx.frasImport_buscarFacturaImport();
  }
  function actualizarLineasIva(curFactura)
  {
    return this.ctx.frasImport_actualizarLineasIva(curFactura);
  }
  function dameFiltroFacturasImport()
  {
    return this.ctx.frasImport_dameFiltroFacturasImport();
  }
}
//// FRAS IMPORT ////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition frasImport */
/////////////////////////////////////////////////////////////////
//// FRAS IMPORT ////////////////////////////////////////////////
function frasImport_init()
{
  var _i = this.iface;
  _i.__init();

  this.iface.tdbLineas = this.child("tdbLineasFacturasProv");
  var cursor: FLSqlCursor = this.cursor();
  connect(this.child("tbnCrearLinea"), "clicked()", this, "iface.crearLinea_clicked()");
  connect(this.child("tbnBuscarFacturaImport"), "clicked()", this, "iface.buscarFacturaImport()");

  _i.refImport = flfactalma.iface.pub_valorDefectoAlmacen("refivaimport");
}

function frasImport_buscarFacturaImport()
{
  var _i = this.iface;
  var cursor = this.cursor();
  var f: Object = new FLFormSearchDB("busfactprov");
  var curFacturas = f.cursor();
  curFacturas.setMainFilter(_i.dameFiltroFacturasImport());
  f.setMainWidget();
  var idFactura: String = f.exec("idfactura");
  if (!idFactura) {
    return false;
  } else {
    cursor.setValueBuffer("idfacturaimport", idFactura);
  }
}

function frasImport_dameFiltroFacturasImport()
{
  return "idfacturadua IS NULL";
}

function frasImport_crearLinea_clicked()
{
  var cursor: FLSqlCursor = this.cursor();
  if (cursor.modeAccess() == cursor.Insert) {
    if (!this.iface.tdbLineas.cursor().commitBufferCursorRelation()) {
      return false;
    }
  }
  var util: FLUtil = new FLUtil();
  var curTrans: FLSqlCursor = new FLSqlCursor("empresa");
  curTrans.transaction(false);
  try {
    if (this.iface.crearLinea()) {
      curTrans.commit();
    } else {
      curTrans.rollback();
    }
  } catch (e) {
    curTrans.rollback();
    MessageBox.critical(util.translate("scripts", "Hubo un error al crear la línea:") + "\n" + e, MessageBox.Ok, MessageBox.NoButton);
  }

  this.iface.tdbLineas.refresh();
}

function frasImport_crearLinea()
{
  var _i = this.iface;
  var util: FLUtil = new FLUtil();
  var cursor: FLSqlCursor = this.cursor();
  if (!_i.refImport) {
    MessageBox.warning(util.translate("scripts", "Antes de crear la línea deberá crear la referencia correspondiente a la línea de IVA\n(con la subcuenta de compras marcada como cuenta especial IVASIM)\n y asociarla en el formulario de datos generales del módulo de almacen"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  var curLinea: FLSqlCursor = new FLSqlCursor("lineasfacturasprov");
  curLinea.select("idfactura = " + cursor.valueBuffer("idfactura") + " AND referencia = '" + _i.refImport + "'");
  if (curLinea.first()) {
    MessageBox.information(util.translate("scripts", "Ya existe una línea creada para el IVA importación"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }

  var qryArt: FLSqlQuery = new FLSqlQuery();
  qryArt.setTablesList("articulos");
  qryArt.setSelect("descripcion,idsubcuentacom,codsubcuentacom,codimpuesto");
  qryArt.setFrom("articulos");
  qryArt.setWhere("referencia = '" + _i.refImport + "'");
  if (!qryArt.exec()) {
    return false;
  }
  if (!qryArt.first()) {
    return false;
  }

  curLinea.setModeAccess(curLinea.Insert);
  curLinea.refreshBuffer();
  curLinea.setValueBuffer("idfactura", cursor.valueBuffer("idfactura"));
  curLinea.setValueBuffer("referencia", _i.refImport);
  curLinea.setValueBuffer("descripcion", qryArt.value("descripcion"));
  curLinea.setValueBuffer("cantidad", 1);
  curLinea.setValueBuffer("pvpunitario", cursor.valueBuffer("cuotaimport"));
  curLinea.setValueBuffer("pvpsindto", cursor.valueBuffer("cuotaimport"));
  curLinea.setValueBuffer("pvptotal", cursor.valueBuffer("cuotaimport"));
  curLinea.setValueBuffer("idsubcuenta", qryArt.value("idsubcuentacom"));
  curLinea.setValueBuffer("codsubcuenta", qryArt.value("codsubcuentacom"));
  curLinea.setValueBuffer("codimpuesto", qryArt.value("codimpuesto"));
  curLinea.setValueBuffer("iva", formRecordlineaspedidosprov.iface.pub_commonCalculateField("iva", curLinea));

  if (!curLinea.commitBuffer()) {
    return false;
  }
  this.iface.calcularTotales();
  return true;
}

function frasImport_actualizarLineasIva(curFactura)
{
  var _i = this.iface;

  if (!_i.__actualizarLineasIva(curFactura)) {
    return false;
  }
  return true;
}
//// FRAS IMPORT ////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
