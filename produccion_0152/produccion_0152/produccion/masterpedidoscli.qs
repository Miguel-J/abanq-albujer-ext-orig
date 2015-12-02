
/** @class_declaration prod */
/////////////////////////////////////////////////////////////////
//// PRODUCCIÓN /////////////////////////////////////////////////
class prod extends articuloscomp
{
  var tbnRoturaStock;
  var curSelecLote;
  function prod(context)
  {
    articuloscomp(context);
  }
  function init()
  {
    return this.ctx.prod_init();
  }
  function copiaLineaPedido(curLineaPedido, idAlbaran)
  {
    return this.ctx.prod_copiaLineaPedido(curLineaPedido, idAlbaran);
  }
  function controlAlbaranadoLineaTrazable(curLineaPedido, idAlbaran, idLineaAlbaran)
  {
    return this.ctx.prod_controlAlbaranadoLineaTrazable(curLineaPedido, idAlbaran, idLineaAlbaran);
  }
  function obtenerAlmacenPedido(curLineaPedido)
  {
    return this.ctx.prod_obtenerAlmacenPedido(curLineaPedido);
  }
  function buscarLoteLineaAlbaran(curLineaPedido, curMSOrigen, oDatos)
  {
    return this.ctx.prod_buscarLoteLineaAlbaran(curLineaPedido, curMSOrigen, oDatos);
  }
  function masDatosSelecLote(curLineaPedido)
  {
    return this.ctx.prod_masDatosSelecLote(curLineaPedido);
  }
  function comprobarStockEnAlbaranado(curLineaPedido, cantidad)
  {
    return this.ctx.prod_comprobarStockEnAlbaranado(curLineaPedido, cantidad);
  }
  function tbnRoturaStock_clicked()
  {
    return this.ctx.prod_tbnRoturaStock_clicked();
  }
  function datosAlbaran(curPedido: FLSqlCursor, where: String, datosAgrupacion: Array): Boolean {
    return this.ctx.prod_datosAlbaran(curPedido, where, datosAgrupacion);
  }
  function abrirCerrarPedido()
  {
    return this.ctx.prod_abrirCerrarPedido();
  }
}
//// PRODUCCIÓN /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition prod */
/////////////////////////////////////////////////////////////////
//// PRODUCCIÓN ////////////////////////////////////////////////
function prod_copiaLineaPedido(curLineaPedido, idAlbaran)
{
  var _i = this.iface;
  var idLineaAlbaran = _i.__copiaLineaPedido(curLineaPedido, idAlbaran);
  if (!idLineaAlbaran) {
    return false;
  }
  if (!_i.curLineaAlbaran.commitBuffer()) { /// Se hace el commit que antes no se había hecho por ser 0 la cantidad de la línea
    return false;
  }
  debug("idLineaAlbaran " + idLineaAlbaran);

  if (!_i.controlAlbaranadoLineaTrazable(curLineaPedido, idAlbaran, idLineaAlbaran)) {
    return false;
  }
  return idLineaAlbaran;
}

function prod_controlAlbaranadoLineaTrazable(curLineaPedido, idAlbaran, idLineaAlbaran)
{
  var _i = this.iface;
  debug("trazable " + flfactalma.iface.pub_esTrazable(curLineaPedido.valueBuffer("referencia")));
  if (!flfactalma.iface.pub_esTrazable(curLineaPedido.valueBuffer("referencia"))) {
    return true;
  }

  var canLinea = parseFloat(curLineaPedido.valueBuffer("cantidad")) - parseFloat(curLineaPedido.valueBuffer("totalenalbaran"));
  if (!canLinea || canLinea == 0) {
    return idLineaAlbaran;
  }
  var canTotal = 0;
  var curMSOrigen = new FLSqlCursor("movistock");
  var idLineaPedido = curLineaPedido.valueBuffer("idlinea");
  curMSOrigen.select("idlineapc = " + idLineaPedido + " AND estado = 'PTE'");
  if (curMSOrigen.size() != 1) {
    if (!flfactalma.iface.unificarMovPtePC(idLineaPedido)) {
      return false;
    }
    curMSOrigen.select("idlineapc = " + idLineaPedido + " AND estado = 'PTE'");
    if (curMSOrigen.size() != 1) {
      return false;
    }
  }
  if (!curMSOrigen.first()) {
    return false;
  }
  curMSOrigen.setModeAccess(curMSOrigen.Edit);
  curMSOrigen.refreshBuffer();

  var referencia = curLineaPedido.valueBuffer("referencia");
  var codAlmacen = _i.obtenerAlmacenPedido(curLineaPedido);
  var oArticulo = new Object;
  oArticulo.referencia = referencia;
  var idStock = flfactalma.iface.pub_dameIdStock(codAlmacen, oArticulo);
  if (!idStock) {
    return false;
  }
  var horaAlbaran = AQUtil.sqlSelect("albaranescli", "hora", "idalbaran = " + idAlbaran);

  var oDatos = new Object;
  oDatos.fecha = AQUtil.sqlSelect("albaranescli", "fecha", "idalbaran = " + idAlbaran);
  oDatos.hora = horaAlbaran.toString().right(8);
  oDatos.idStock = idStock;
  oDatos.idLineaAlbaran = idLineaAlbaran;
  oDatos.canLinea = canLinea;

  var oLLA;
  do {
    oLLA = _i.buscarLoteLineaAlbaran(curLineaPedido, curMSOrigen, oDatos);
    if (!oLLA) {
      return false;
    }
  } while (!oLLA.fin && !oLLA.cierraLinea);

  if (oLLA.fin && curMSOrigen.valueBuffer("cantidad") >= 0) { /// Positivo en cliente significa todo servido
    curMSOrigen.setModeAccess(curMSOrigen.Del);
    curMSOrigen.refreshBuffer();
  }
  if (!curMSOrigen.commitBuffer()) {
    return false;
  }
  var curLA = _i.curLineaAlbaran;
  curLA.select("idlinea = " + idLineaAlbaran);
  if (!curLA.first()) {
    return false;
  }
  curLA.setModeAccess(curLA.Edit);
  curLA.refreshBuffer();
  curLA.setValueBuffer("cantidad", formRecordlineasalbaranescli.iface.pub_commonCalculateField("cantidadtrazable", curLA));
  curLA.setValueBuffer("pvpsindto", formRecordlineaspedidoscli.iface.pub_commonCalculateField("pvpsindto", curLA));
  curLA.setValueBuffer("pvptotal", formRecordlineaspedidoscli.iface.pub_commonCalculateField("pvptotal", curLA));
  //  if (!flfactalma.iface.pub_consistenciaLinea(curLA)) {
  //    return false;
  //  }
  if (!curLA.commitBuffer()) {
    return false;
  }
  if (oLLA.cierraLinea) {
    if (!AQSql.update("lineaspedidoscli", ["cerrada"], [true], "idlinea = " + idLineaPedido)) {
      return false;
    }
    if (!flfacturac.iface.pub_actualizarEstadoPedidoCli(curLineaPedido.valueBuffer("idpedido"))) {
      return false;
    }
  }
  return idLineaAlbaran;
}

function prod_obtenerAlmacenPedido(curLineaPedido)
{
  var _i = this.iface;
  var codAlmacen = AQUtil.sqlSelect("pedidoscli", "codalmacen", "idpedido = " + curLineaPedido.valueBuffer("idpedido"));
  codAlmacen = codAlmacen ? codAlmacen : "";
  return codAlmacen;
}

function prod_buscarLoteLineaAlbaran(curLineaPedido, curMSOrigen, oDatos)
{
  var _i = this.iface;
  var idUsuario = sys.nameUser();
  var canLote;
  var descArticulo = curLineaPedido.valueBuffer("descripcion");
  var referencia = curLineaPedido.valueBuffer("referencia");

  var canLote = curMSOrigen.valueBuffer("cantidad") * -1;
  var res = new Object;
  res.fin = false;
  res.cierraLinea = false;
  var f = new FLFormSearchDB("seleclote");
  delete _i.curSelecLote;
  _i.curSelecLote = f.cursor();
  _i.curSelecLote.select("idusuario = '" + idUsuario + "'");
  if (!_i.curSelecLote.first()) {
    _i.curSelecLote.setModeAccess(_i.curSelecLote.Insert);
  } else {
    _i.curSelecLote.setModeAccess(_i.curSelecLote.Edit);
  }
  f.setMainWidget();

  //  canLote = canLinea - oDatos.canTotal;
  _i.curSelecLote.refreshBuffer();
  _i.curSelecLote.setValueBuffer("idusuario", idUsuario);
  _i.curSelecLote.setValueBuffer("referencia", referencia);
  _i.curSelecLote.setValueBuffer("descripcion", descArticulo);
  _i.curSelecLote.setValueBuffer("canlinea", oDatos.canLinea);
  _i.curSelecLote.setValueBuffer("canlote", canLote);
  _i.curSelecLote.setValueBuffer("resto", canLote);
  if (!_i.masDatosSelecLote(curLineaPedido)) {
    return false;
  }
  var acpt = f.exec("id");
  if (!acpt) {
    return false;
  }
  var curMS = flfactalma.iface.curMoviStock;
  if (!curMS) {
    curMS = new FLSqlCursor("movistock");
  }
  var nuevaCantidad = parseFloat(_i.curSelecLote.valueBuffer("canlote"));
  var codLote = _i.curSelecLote.valueBuffer("codlote");
  res.cierraLinea = _i.curSelecLote.valueBuffer("cierralinea");
  res.fin = _i.curSelecLote.valueBuffer("fin");

  if (codLote) {
    curMS.setModeAccess(curMS.Insert);
    curMS.refreshBuffer();

    curMS.setValueBuffer("referencia", referencia);
    curMS.setValueBuffer("codlote", codLote);
    curMS.setValueBuffer("idlineapc", curLineaPedido.valueBuffer("idlinea"));
    curMS.setValueBuffer("idlineaac", oDatos.idLineaAlbaran);
    curMS.setValueBuffer("estado", "HECHO");
    curMS.setValueBuffer("cantidad", (nuevaCantidad * -1));
    curMS.setValueBuffer("fechaprev", curMSOrigen.valueBuffer("fechaprev"));
    curMS.setValueBuffer("fechareal", oDatos.fecha);
    curMS.setValueBuffer("horareal", oDatos.hora);
    curMS.setValueBuffer("idstock", oDatos.idStock);
    //    if(!this.iface.masDatosMoviLote())
    //      return false;
    if (!curMS.commitBuffer()) {
      return false;
    }
  }
  canLote -= nuevaCantidad;
  curMSOrigen.setValueBuffer("cantidad", canLote * -1);
  if (canLote <= 0) {
    res.fin = true;
  }
  return res;
}

function prod_masDatosSelecLote(curLineaPedido)
{
  var _i = this.iface;
  return true;
}

function prod_comprobarStockEnAlbaranado(curLineaPedido, cantidad)
{
  var _i = this.iface;
  if (!flfactalma.iface.pub_esTrazable(curLineaPedido.valueBuffer("referencia"))) {
    return _i.__comprobarStockEnAlbaranado(curLineaPedido, cantidad);
  }
  /// Los artículos trazables se albaranan a 0 y luego se van sumando cantidades a través de movimientos con lote asociado
  var aDatos = [];
  aDatos.ok = true;
  aDatos.haystock = false;
  aDatos.cantidad = 0;

  return aDatos;
}


function prod_init()
{
  this.iface.__init();
  this.iface.tbnRoturaStock = this.child("tbnRoturaStock");

  connect(this.iface.tbnRoturaStock, "clicked()", this, "iface.tbnRoturaStock_clicked");
}

function prod_tbnRoturaStock_clicked()
{
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();
  if (!cursor.isValid())
    return false;

  var f: Object = new FLFormSearchDB("roturastock");
  var curRS: FLSqlCursor = f.cursor();

  curRS.select("idusuario = '" + sys.nameUser() + "'");
  if (!curRS.first())
    curRS.setModeAccess(curRS.Insert);
  else
    curRS.setModeAccess(curRS.Edit);

  f.setMainWidget();
  curRS.refreshBuffer();
  curRS.setValueBuffer("idusuario", sys.nameUser());
  curRS.setValueBuffer("idpedidocli", cursor.valueBuffer("idpedido"));
  var acpt: String = f.exec("codejercicio");
  var lista: String;
  if (acpt) {
    if (!curRS.commitBuffer())
      return false;
    var curRoturaStock: FLSqlCursor = new FLSqlCursor("roturastock");
    curRoturaStock.select("idusuario = '" + sys.nameUser() + "'");
    if (curRoturaStock.first()) {
      lista = curRoturaStock.valueBuffer("lista");
      if (!lista || lista == "")
        return;

      var curPedido: FLSqlCursor = new FLSqlCursor("pedidosprov");
      curPedido.transaction(false);
      try {
        if (!formpedidosprov.iface.pub_generarRoturaStock(lista, curRoturaStock)) {
          curPedido.rollback();
          util.destroyProgressDialog();
        } else {
          curPedido.commit();
          util.destroyProgressDialog();
        }
      } catch (e) {
        curPedido.rollback();
        util.destroyProgressDialog();
        MessageBox.critical(util.translate("scripts", "Hubo un error al generar los pedidos de artículos con rotura de stock: ") + e, MessageBox.Ok, MessageBox.NoButton);
      }
    }
  }
  f.close();
  this.iface.tdbRecords.refresh();
}

function prod_datosAlbaran(curPedido: FLSqlCursor, where: String, datosAgrupacion: Array): Boolean {
  if (!this.iface.__datosAlbaran(curPedido, where, datosAgrupacion))
  {
    return false;
  }

  var hora: String;
  if (datosAgrupacion)
  {
    hora = datosAgrupacion["hora"];
  } else {
    var hoy: Date = new Date();
    hora = hoy.toString().right(8);
  }

  this.iface.curAlbaran.setValueBuffer("hora", hora);

  return true;
}

function prod_abrirCerrarPedido()
{
  /// Quitado para Euromoda ¿Tiene sentido en la producción normal?
  var _i = this.iface;
  return _i.__abrirCerrarPedido();

  var util: FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  var idPedido: Number = cursor.valueBuffer("idpedido");
  if (!idPedido) {
    MessageBox.warning(util.translate("scripts", "No hay ningún registro seleccionado"), MessageBox.Ok, MessageBox.NoButton);
  }

  var cerrar: Boolean = true;
  var res: Number;
  if (util.sqlSelect("lineaspedidoscli LEFT OUTER JOIN articulos on lineaspedidoscli.referencia = articulos.referencia", "cerrada", "idpedido = " + idPedido + " AND (articulos.fabricado IS NULL OR NOT articulos.fabricado) AND cerrada", "lineaspedidoscli,articulos")) {
    cerrar = false;
    res = MessageBox.information(util.translate("scripts", "El pedido seleccionado tiene líneas cerradas.\n¿Seguro que desa abrirlas?"), MessageBox.Yes, MessageBox.No);
  } else {
    if (!cursor.valueBuffer("editable")) {
      MessageBox.warning(util.translate("scripts", "El pedido ya ha sido servido completamente."), MessageBox.Ok, MessageBox.NoButton);
      return;
    }

    if (util.sqlSelect("lineaspedidoscli LEFT OUTER JOIN articulos on lineaspedidoscli.referencia = articulos.referencia", "idlinea", "idpedido = " + idPedido + " AND articulos.fabricado AND (cerrada = false OR cerrada IS NULL)", "lineaspedidoscli,articulos")) {
      res = MessageBox.warning(util.translate("scripts", "El pedido contiene líneas de artículos de fabricación que no se cerrarán.\n¿Desea continuar de todas formas?"), MessageBox.Yes, MessageBox.No);
    } else {
      res = MessageBox.warning(util.translate("scripts", "Se va a cerrar el pedido y no podrá terminar de servirse.\n¿Desea continuar?"), MessageBox.Yes, MessageBox.No);
    }
  }
  if (res != MessageBox.Yes)
    return;

  if (!util.sqlUpdate("lineaspedidoscli", "cerrada", cerrar, "idpedido = " + idPedido + " AND referencia NOT IN (select referencia from articulos where fabricado)"))
    return;

  if (!flfacturac.iface.pub_actualizarEstadoPedidoCli(idPedido))
    return;

  this.iface.tdbRecords.refresh();
}
//// PRODUCCIÓN ////////////////////////////////////////////////
////////////////////////////////////////////////////////////////
