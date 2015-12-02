
/** @class_declaration funServiciosCli */
//////////////////////////////////////////////////////////////////
//// FUN_SERVICIOS_CLI /////////////////////////////////////////////////////
class funServiciosCli extends oficial
{
  var SERVICIOS: Number;
  function funServiciosCli(context)
  {
    oficial(context);
  }
  function init()
  {
    return this.ctx.funServiciosCli_init();
  }
  function datosServicioCli(codigo: String)
  {
    return this.ctx.funServiciosCli_datosServicioCli(codigo);
  }
  function dibOrigenSerCli(codigo: String, fila: Number): Number {
    return this.ctx.funServiciosCli_dibOrigenSerCli(codigo, fila);
  }
  function dibDestinoSerCli(codigo: String, fila: Number): Number {
    return this.ctx.funServiciosCli_dibDestinoSerCli(codigo, fila);
  }
  function dibOrigenAlbCli(codigo: String, fila: Number): Number {
    return this.ctx.funServiciosCli_dibOrigenAlbCli(codigo, fila);
  }
  function crearTabla()
  {
    return this.ctx.funServiciosCli_crearTabla();
  }
  function cargarTraza()
  {
    return this.ctx.funServiciosCli_cargarTraza();
  }
  function dibDestinoPedCli(codigo: String, fila: Number): Number {
    return this.ctx.funServiciosCli_dibDestinoPedCli(codigo, fila);
  }
}
//// FUN_SERVICIOS_CLI /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_definition funServiciosCli */
/////////////////////////////////////////////////////////////////
//// FUN_SERVICIOS_CLI /////////////////////////////////////////////////
function funServiciosCli_init()
{
  this.iface.__init();
}

function funServiciosCli_cargarTraza()
{
  var cursor: FLSqlCursor = this.cursor();
  var tipo: String = cursor.valueBuffer("tipo");
  var codigo: String = cursor.valueBuffer("codigo");

  switch (tipo) {
    case "servicioscli": {
      this.iface.tblDocs.insertRows(this.iface.tblDocs.numRows());
      this.iface.tblDocs.setText(0, this.iface.SERVICIOS, codigo);
      this.iface.dibDestinoSerCli(codigo, 0);
      this.iface.dibOrigenSerCli(codigo, 0);
      this.iface.clienteProveedor = "cliente";
      break;
    }
    default: {
      this.iface.__cargarTraza();
    }
  }
}

function funServiciosCli_crearTabla()
{
  this.iface.PRESUPUESTOS = 0;
  this.iface.PEDIDOS = 1;
  this.iface.ALBARANES = 3;
  this.iface.FACTURAS = 4;
  this.iface.RECIBOS = 5;
  this.iface.PAGOS = 6;
  this.iface.PAGOS_ID = 7;
  this.iface.SERVICIOS = 2;

  this.iface.tblDocs.setNumCols(8);
  this.iface.tblDocs.setColumnWidth(this.iface.PRESUPUESTOS, 100);
  this.iface.tblDocs.setColumnWidth(this.iface.PEDIDOS, 100);
  this.iface.tblDocs.setColumnWidth(this.iface.ALBARANES, 100);
  this.iface.tblDocs.setColumnWidth(this.iface.FACTURAS, 100);
  this.iface.tblDocs.setColumnWidth(this.iface.RECIBOS, 100);
  this.iface.tblDocs.setColumnWidth(this.iface.PAGOS, 100);
  this.iface.tblDocs.setColumnWidth(this.iface.SERVICIOS, 100);
  this.iface.tblDocs.hideColumn(this.iface.PAGOS_ID);
  this.iface.tblDocs.setColumnLabels("/", "Presupuestos/Pedidos/Servicios/Albaranes/Facturas/Recibos/Pagos/Pagos");

  this.iface.filaActual = 0;
}

/** \D Muestra los datos principales de la factura indicada
@param  codigo: Código del albarán
\end */
function funServiciosCli_datosServicioCli(codigo: String)
{
  var util: FLUtil = new FLUtil;
  var qry: FLSqlQuery = new FLSqlQuery();
  with(qry) {
    setTablesList("servicioscli");
    setSelect("codcliente, total, fecha");
    setFrom("servicioscli");
    setWhere("codigo = '" + codigo + "'");
    setForwardOnly(true);
  }
  if (!qry.exec())
    return false;
  if (!qry.first())
    return false;

  var texto: String = util.translate("scripts", "Servicio %1\nCliente %2 - \nImporte: %3\nFecha: %4").arg(codigo).arg(qry.value("codcliente")).arg(util.roundFieldValue(qry.value("total"), "servicioscli", "total")).arg(util.dateAMDtoDMA(qry.value("fecha")));
  this.child("lblDatosDoc").text = texto;
}


/** Dibuja los pedidos que originan el albarán de cliente indicado, a partir de la fila de la tabla indicada
@param  codigo: Código del albarán
@param  fila: Fila en la que comenzar a dibujar
@return última fila dibujada
\end */
function funServiciosCli_dibOrigenAlbCli(codigo: String, fila: Number): Number {
  var qryServicios: FLSqlQuery = new FLSqlQuery();
  with(qryServicios)
  {
    setTablesList("servicioscli,albaranescli");
    setSelect("s.numservicio");
    setFrom("servicioscli s INNER JOIN albaranescli a ON s.idalbaran = a.idalbaran");
    setWhere("a.codigo = '" + codigo + "' GROUP BY s.numservicio ORDER BY s.numservicio");
    setForwardOnly(true);
  }
  if (!qryServicios.exec())
    return this.iface.__dibOrigenAlbCli(codigo, fila);

  if (!qryServicios.size())
    return this.iface.__dibOrigenAlbCli(codigo, fila);

  while (qryServicios.next())
  {
    fila++;
    if (this.iface.tblDocs.numRows() == fila) {
      this.iface.tblDocs.insertRows(fila);
    }
    this.iface.tblDocs.setText(fila, this.iface.SERVICIOS, qryServicios.value("s.numservicio"));
    fila = this.iface.dibOrigenSerCli(qryServicios.value("s.numservicio"), fila);
    if (fila == -1) {
      return -1;
    }
  }
  return fila;
}


/** Dibuja los albaranes destino del servicio de cliente indicado, a partir de la fila de la tabla indicada
@param  codigo: Código del servicio
@param  fila: Fila en la que comenzar a dibujar
@return última fila dibujada
\end */
function funServiciosCli_dibDestinoSerCli(codigo: String, fila: Number): Number {
  var qryAlbaranes: FLSqlQuery = new FLSqlQuery();
  with(qryAlbaranes)
  {
    setTablesList("servicioscli,albaranescli,lineasalbaranescli");
    setSelect("a.codigo");
    setFrom("servicioscli s INNER JOIN albaranescli a ON s.idalbaran = a.idalbaran");
    setWhere("s.numservicio = '" + codigo + "' GROUP BY a.codigo ORDER BY a.codigo");
    setForwardOnly(true);
  }

  if (!qryAlbaranes.exec())
    return -1;
  while (qryAlbaranes.next())
  {
    fila++;

    if (this.iface.tblDocs.numRows() == fila)
      this.iface.tblDocs.insertRows(fila);
    this.iface.tblDocs.setText(fila, this.iface.ALBARANES, qryAlbaranes.value("a.codigo"));
    fila = this.iface.dibDestinoAlbCli(qryAlbaranes.value("a.codigo"), fila);
    if (fila == -1)
      return -1;
  }
  return fila;
}

function funServiciosCli_dibOrigenSerCli(codigo, fila)
{
  var _i = this.iface;
  var qryPedidos = new FLSqlQuery();
  with(qryPedidos) {
    setTablesList("pedidoscli,servicioscli");
    setSelect("p.codigo");
    setFrom("servicioscli s INNER JOIN pedidoscli p ON s.idpedido = p.idpedido");
    setWhere("s.numservicio = '" + codigo + "' GROUP BY p.codigo ORDER BY p.codigo");
    setForwardOnly(true);
  }
  if (!qryPedidos.exec()) {
    return -1;
  }
  while (qryPedidos.next()) {
    fila++;

    if (_i.tblDocs.numRows() == fila) {
      _i.tblDocs.insertRows(fila);
    }
    _i.tblDocs.setText(fila, this.iface.PEDIDOS, qryPedidos.value("p.codigo"));
    fila = _i.dibOrigenPedCli(qryPedidos.value("p.codigo"), fila);
    if (fila == -1) {
      return -1;
    }
  }
  return fila;
}

/** Dibuja los servicios que origina el pedido de cliente indicado, a partir de la fila de la tabla indicada
@param  codigo: Código del pedido
@param  fila: Fila en la que comenzar a dibujar
@return última fila dibujada
\end */
function funServiciosCli_dibDestinoPedCli(codigo, fila)
{
  var qryServicios = new FLSqlQuery();
  with(qryServicios) {
    setTablesList("servicioscli,pedidoscli");
    setSelect("s.numservicio");
    setFrom("pedidoscli p INNER JOIN servicioscli s ON p.idpedido = s.idpedido");
    setWhere("p.codigo = '" + codigo + "' GROUP BY s.numservicio ORDER BY s.numservicio");
    setForwardOnly(true);
  }
  if (!qryServicios.exec())
    return this.iface.__dibDestinoPedCli(codigo, fila);

  if (!qryServicios.size())
    return this.iface.__dibDestinoPedCli(codigo, fila);

  while (qryServicios.next()) {
    fila++;
    if (this.iface.tblDocs.numRows() == fila) {
      this.iface.tblDocs.insertRows(fila);
    }
    this.iface.tblDocs.setText(fila, this.iface.SERVICIOS, qryServicios.value("s.numservicio"));
    fila = this.iface.dibDestinoSerCli(qryServicios.value("s.numservicio"), fila);
    if (fila == -1) {
      return -1;
    }
  }
  return fila;
}
//// FUN_SERVICIOS_CLI ///////////////////////////////////////////
/////////////////////////////////////////////////////////////////

