
/** @class_declaration serviciosCli */
//////////////////////////////////////////////////////////////////
//// SERVICIOS_CLI /////////////////////////////////////////////////
class serviciosCli extends oficial
{
  var curServicio;
  var curLineaServicio;
  var pbnGServicio;

  function serviciosCli(context)
  {
    oficial(context);
  }
  function init()
  {
    this.ctx.serviciosCli_init();
  }
  function pbnGenerarServicio_clicked()
  {
    return this.ctx.serviciosCli_pbnGenerarServicio_clicked();
  }
  function generarServicio(where, cursor)
  {
    return this.ctx.serviciosCli_generarServicio(where, cursor);
  }
  function datosServicio(curPedido, where)
  {
    return this.ctx.serviciosCli_datosServicio(curPedido, where);
  }
  function totalesServicio()
  {
    return this.ctx.serviciosCli_totalesServicio();
  }
  function copiaLineasServicio(idPedido, idServicio)
  {
    return this.ctx.serviciosCli_copiaLineasServicio(idPedido, idServicio);
  }
  function copiaLineaServicio(curLineaPedido, idServicio)
  {
    return this.ctx.serviciosCli_copiaLineaServicio(curLineaPedido, idServicio);
  }
  function datosLineaServicio(curLineaPedido)
  {
    return this.ctx.serviciosCli_datosLineaServicio(curLineaPedido);
  }
  function actualizarDatosPedidoServ(where)
  {
    return this.ctx.serviciosCli_actualizarDatosPedidoServ(where);
  }
  function procesarEstado()
  {
    return this.ctx.serviciosCli_procesarEstado();
  }
}
//// SERVICIOS_CLI /////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_definition serviciosCli */
/////////////////////////////////////////////////////////////////
//// SERVICIOS_CLI /////////////////////////////////////////////////

function serviciosCli_init()
{
  this.iface.pbnGServicio = this.child("pbnGenerarServicio");
  connect(this.iface.pbnGServicio, "clicked()", this, "iface.pbnGenerarServicio_clicked()");

  this.iface.__init();
}

/** \C
Al pulsar el botón de generar servicio se creará el servicio correspondiente al pedido seleccionado.
\end */
function serviciosCli_pbnGenerarServicio_clicked()
{
  var _i = this.iface;
  var util = new FLUtil;
  var cursor = this.cursor();
  var where = "idpedido = " + cursor.valueBuffer("idpedido");

  if (cursor.valueBuffer("editable") == false) {
    MessageBox.warning(util.translate("scripts", "El pedido ya está servido o generó un servicio"), MessageBox.Ok, MessageBox.NoButton);
    this.iface.procesarEstado();
    return;
  }
  _i.pbnGServicio.setEnabled(false);
  _i.pbnGAlbaran.setEnabled(false);
  _i.pbnGFactura.setEnabled(false);

  var ok: Boolean;
  cursor.transaction(false);

  try {
    if (_i.generarServicio(where, cursor)) {
      cursor.commit();
    } else {
      cursor.rollback();
      MessageBox.warning(util.translate("scripts", "Error en la generación del servicio"), MessageBox.Ok, MessageBox.NoButton);
      return;
    }
  } catch (e) {
    cursor.rollback();
    MessageBox.critical(util.translate("scripts", "Hubo un error en la generación del servicio:") + "\n" + e, MessageBox.Ok, MessageBox.NoButton);
    return;
  }

  _i.tdbRecords.refresh();
  _i.procesarEstado();
}

/** \D
Genera el servicio asociado a uno o más pedidos
@param where: Sentencia where para la consulta de búsqueda de los pedidos a agrupar
@param cursor: Cursor con los datos principales que se copiarán del pedido al servicio
@return Identificador del servicio generado. FALSE si hay error
\end */
function serviciosCli_generarServicio(where, curPedido)
{
  var _i = this.iface;
  if (!_i.curServicio) {
    _i.curServicio = new FLSqlCursor("servicioscli");
  }
  _i.curServicio.setModeAccess(_i.curServicio.Insert);
  _i.curServicio.refreshBuffer();

  if (!_i.datosServicio(curPedido, where)) {
    return false;
  }
  if (!_i.curServicio.commitBuffer()) {
    return false;
  }

  var idServicio = _i.curServicio.valueBuffer("idservicio");

  var qryPedidos = new FLSqlQuery();
  qryPedidos.setTablesList("pedidoscli");
  qryPedidos.setSelect("idpedido");
  qryPedidos.setFrom("pedidoscli");
  qryPedidos.setWhere(where);

  if (!qryPedidos.exec()) {
    return false;
  }
  var idPedido;
  while (qryPedidos.next()) {
    idPedido = qryPedidos.value(0);
    if (!_i.copiaLineasServicio(idPedido, idServicio)) {
      return false;
    }
  }

  _i.curServicio.select("idservicio = " + idServicio);
  if (_i.curServicio.first()) {
    _i.curServicio.setModeAccess(_i.curServicio.Edit);
    _i.curServicio.refreshBuffer();

    if (!_i.totalesServicio()) {
      return false;
    }
    if (!_i.curServicio.commitBuffer()) {
      return false;
    }
  }

  if (!_i.actualizarDatosPedidoServ(where)) {
    return false;
  }
  return idServicio;
}

/** \D Informa los datos de un servicio a partir de los de un pedido
@param  curPedido: Cursor que contiene los datos a incluir en el servicio
@return True si el cálculo se realiza correctamente, false en caso contrario
\end */
function serviciosCli_datosServicio(curPedido, where)
{
  var _i = this.iface;
  var util = new FLUtil();
  var fecha;
  if (curPedido.action() == "pedidoscli") {
    var hoy = new Date();
    fecha = hoy.toString();
  } else {
    fecha = curPedido.valueBuffer("fecha");
  }
  var codEjercicio = curPedido.valueBuffer("codejercicio");
  var datosDoc: Array = flfacturac.iface.pub_datosDocFacturacion(fecha, codEjercicio, "servicioscli");
  if (!datosDoc.ok) {
    return false;
  }
  if (datosDoc.modificaciones == true) {
    codEjercicio = datosDoc.codEjercicio;
    fecha = datosDoc.fecha;
  }

  _i.curServicio.setValueBuffer("numservicio", util.nextCounter("numservicio", _i.curServicio));
  _i.curServicio.setValueBuffer("codserie", curPedido.valueBuffer("codserie"));
  _i.curServicio.setValueBuffer("fecha", fecha);
  _i.curServicio.setValueBuffer("codagente", curPedido.valueBuffer("codagente"));
  _i.curServicio.setValueBuffer("porcomision", curPedido.valueBuffer("porcomision"));
  _i.curServicio.setValueBuffer("tasaconv", curPedido.valueBuffer("tasaconv"));
  _i.curServicio.setValueBuffer("codcliente", curPedido.valueBuffer("codcliente"));
  _i.curServicio.setValueBuffer("nombrecliente", curPedido.valueBuffer("nombrecliente"));
  _i.curServicio.setValueBuffer("contratomant", util.sqlSelect("clientes", "contratomant", "codcliente = '" + curPedido.valueBuffer("codcliente") + "'"));
  _i.curServicio.setValueBuffer("idpedido", curPedido.valueBuffer("idpedido"));
  _i.curServicio.setValueBuffer("observaciones", curPedido.valueBuffer("observaciones"));

  return true;
}

/** \D Informa los datos de un albarán referentes a totales (I.V.A., neto, etc.)
@return True si el cálculo se realiza correctamente, false en caso contrario
\end */
function serviciosCli_totalesServicio()
{
  var _i = this.iface;
  with(_i.curServicio) {
    setValueBuffer("neto", formservicioscli.iface.pub_commonCalculateField("neto", this));
    setValueBuffer("totaliva", formservicioscli.iface.pub_commonCalculateField("totaliva", this));
    setValueBuffer("totalrecargo", formservicioscli.iface.pub_commonCalculateField("totalrecargo", this));
    setValueBuffer("total", formservicioscli.iface.pub_commonCalculateField("total", this));
  }
  return true;
}

function serviciosCli_copiaLineasServicio(idPedido, idServicio)
{
  var _i = this.iface;
  var cantidad;
  var curLineaPedido = new FLSqlCursor("lineaspedidoscli");
  curLineaPedido.select("idpedido = " + idPedido);
  while (curLineaPedido.next()) {
    if (!_i.copiaLineaServicio(curLineaPedido, idServicio)) {
      return false;
    }
  }
  return true;
}

/** \D
Copia una líneas de un pedido en su servicio asociado
@param curdPedido: Cursor posicionado en la línea de pedido a copiar
@param idAlbaran: Identificador del albarán
@return identificador de la línea de albarán creada si no hay error. FALSE en otro caso.
\end */
function serviciosCli_copiaLineaServicio(curLineaPedido, idServicio)
{
  var _i = this.iface;
  if (!_i.curLineaServicio) {
    _i.curLineaServicio = new FLSqlCursor("lineasservicioscli");
  }
  with(_i.curLineaServicio) {
    setModeAccess(Insert);
    refreshBuffer();
    setValueBuffer("idservicio", idServicio);
  }

  if (!_i.datosLineaServicio(curLineaPedido)) {
    return false;
  }
  if (!_i.curLineaServicio.commitBuffer()) {
    return false;
  }
  return _i.curLineaServicio.valueBuffer("idlinea");
}

/** \D Copia los datos de una línea de pedido en una línea de servicio
@param  curLineaPedido: Cursor que contiene los datos a incluir en la línea de servicio
@return True si la copia se realiza correctamente, false en caso contrario
\end */
function serviciosCli_datosLineaServicio(curLineaPedido)
{
  var _i = this.iface;
  var util = new FLUtil;

  with(_i.curLineaServicio) {
    setValueBuffer("referencia", curLineaPedido.valueBuffer("referencia"));
    setValueBuffer("descripcion", curLineaPedido.valueBuffer("descripcion"));
    setValueBuffer("pvpunitario", curLineaPedido.valueBuffer("pvpunitario"));
    setValueBuffer("cantidad", curLineaPedido.valueBuffer("cantidad"));
    setValueBuffer("codimpuesto", curLineaPedido.valueBuffer("codimpuesto"));
    setValueBuffer("iva", curLineaPedido.valueBuffer("iva"));
    setValueBuffer("recargo", curLineaPedido.valueBuffer("recargo"));
    setValueBuffer("dtolineal", curLineaPedido.valueBuffer("dtolineal"));
    setValueBuffer("dtopor", curLineaPedido.valueBuffer("dtopor"));
    setValueBuffer("pvpsindto", curLineaPedido.valueBuffer("pvpsindto"));
    setValueBuffer("pvptotal", formRecordlineaspedidoscli.iface.pub_commonCalculateField("pvptotal", this));
  }
  return true;
}

function serviciosCli_actualizarDatosPedidoServ(where)
{
  var _i = this.iface;
  var curPedidos = new FLSqlCursor("pedidoscli");
  curPedidos.select(where);
  while (curPedidos.next()) {
    curPedidos.setModeAccess(curPedidos.Edit);
    curPedidos.refreshBuffer();
    curPedidos.setValueBuffer("editable", false);
    if (!curPedidos.commitBuffer()) {
      return false;
    }
  }
  return true;
}

function serviciosCli_procesarEstado()
{
  var _i = this.iface;
  _i.__procesarEstado();

  if (this.cursor().valueBuffer("editable")) {
    _i.pbnGServicio.setEnabled(true);
  } else {
    _i.pbnGServicio.setEnabled(false);
  }
}
//// SERVICIOS_CLI ////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
