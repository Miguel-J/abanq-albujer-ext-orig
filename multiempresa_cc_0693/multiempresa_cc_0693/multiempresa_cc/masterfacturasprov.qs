
/** @class_declaration multiempresaCCoste */
/////////////////////////////////////////////////////////////////
//// MULTIEMPRESAS CENTROS DE COSTE /////////////////////////////
class multiempresaCCoste extends oficial
{
  var mensajeNOempresa_;
  var mensajeYAfacturado_;
  var mensajeFacturados_;

  function multiempresaCCoste(context)
  {
    oficial(context);
  }
  function init()
  {
    return this.ctx.multiempresaCCoste_init();
  }
  function tbnFacturaEmpresa_clicked()
  {
    return this.ctx.multiempresaCCoste_tbnFacturaEmpresa_clicked();
  }
  function crearFacturaClienteReparto(idEmpresa)
  {
    return this.ctx.multiempresaCCoste_crearFacturaClienteReparto(idEmpresa);
  }
  function datosFacturaMultiCoste(curFacturaCli, idEmpresa)
  {
    return this.ctx.multiempresaCCoste_datosFacturaMultiCoste(curFacturaCli, idEmpresa);
  }
  function datosDireccionFacturaMultiCoste(curFacturaCli, q)
  {
    return this.ctx.multiempresaCCoste_datosDireccionFacturaMultiCoste(curFacturaCli, q);
  }
  function datosLineaFacturaMultiCoste(idFacturaCli, importe, codCentro)
  {
    return this.ctx.multiempresaCCoste_datosLineaFacturaMultiCoste(idFacturaCli, importe, codCentro);
  }
  function totalesFacturaReparto(curFacturaCli)
  {
    return this.ctx.multiempresaCCoste_totalesFacturaReparto(curFacturaCli);
  }
}
//// MULTIEMPRESAS CENTROS DE COSTE /////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition multiempresaCCoste */
/////////////////////////////////////////////////////////////////
//// MULTIEMPRESAS CENTROS DE COSTE /////////////////////////////

function multiempresaCCoste_init()
{
  var _i = this.iface;
  var cursor = this.cursor();

  _i.__init();
  _i.mensajeNOempresa_ = "";
  _i.mensajeYAfacturado_ = "";
  _i.mensajeFacturados_ = "";

  connect(this.child("tbnFacturaEmpresa"), "clicked()", _i, "tbnFacturaEmpresa_clicked");
}

function multiempresaCCoste_tbnFacturaEmpresa_clicked()
{
  var _i = this.iface;
  var cursor = this.cursor();

  _i.mensajeNOempresa_ = "";
  _i.mensajeYAfacturado_ = "";
  _i.mensajeFacturados_ = "";

  var dialog = new Dialog;
  dialog.okButtonText = sys.translate("Aceptar");
  dialog.cancelButtonText = sys.translate("Cancelar");
  dialog.title = sys.translate("Seleccione la empresa a facturar:");
  var bgroup = new GroupBox;
  dialog.add(bgroup);

  var chkEmpresas = [];
  var aIdEmpresas = [];
  var empresaActual = flfactppal.iface.pub_empresaActual();

  var q = new FLSqlQuery();
  q.setSelect("id,nombre");
  q.setFrom("empresa");
  q.setWhere("1 = 1 AND id <> '" + empresaActual + "' ORDER BY id");
  q.setForwardOnly(true);

  if (!q.exec()) {
    return;
  }

  if (q.size() > 0) {
    var i = 0;
    while (q.next()) {
      chkEmpresas[i] = new CheckBox;
      bgroup.add(chkEmpresas[i]);
      chkEmpresas[i].text = q.value(1);
      chkEmpresas[i].checked = true;
      aIdEmpresas[i] = q.value(0);
      i++;
    }
    if (chkEmpresas.length > 0) {
      if (dialog.exec()) {
        var aIE = [];
        var j = 0;
        for (i = 0; i < chkEmpresas.length; i++) {
          if (chkEmpresas[i].checked == true) {
            aIE[j] = aIdEmpresas[i];
            j++;
          }
        }
        if (aIE.length > 0) {
          flfactppal.iface.pub_creaDialogoProgreso(sys.translate("Creando facturas de reparto a empresas..."), aIE.length);
          var progreso = 0;
          for (i = 0; i < aIE.length; i++) {
            AQUtil.setProgress(progreso++);
            if (!_i.crearFacturaClienteReparto(aIE[i])) {
              AQUtil.destroyProgressDialog();
              sys.warnMsgBox(sys.translate("Error al generar las facturas de cliente de las empresas seleccionadas."));
              return;
            }
          }
          AQUtil.destroyProgressDialog();
          if (_i.mensajeFacturados_ != "") {
            sys.infoMsgBox("Facturas creadas satisfactoriamente:\n" + _i.mensajeFacturados_);
          }
          if (_i.mensajeYAfacturado_ != "") {
            sys.infoMsgBox("Factura/s ya creada/s con anterioridad para la/s empresa/s: \n" + _i.mensajeYAfacturado_);
          }
          if (_i.mensajeNOempresa_ != "") {
            sys.infoMsgBox("Listado de empresas sin partidas a facturar en el registro seleccionado: \n" + _i.mensajeNOempresa_);
          }
        }
      }
    }
  } else {
    sys.warnMsgBox(sys.translate("Fallo al buscar las empresas para seleccionar una que facturar.\nContacte con el administrador."));
  }
}

function multiempresaCCoste_crearFacturaClienteReparto(idEmpresa)
{
  var _i = this.iface;
  var cursor = this.cursor();

  var hayRegistro = AQUtil.sqlSelect("facturasprov INNER JOIN co_partidas ON facturasprov.idasiento = co_partidas.idasiento INNER JOIN co_partidascc ON co_partidas.idpartida = co_partidascc.idpartida INNER JOIN centroscoste ON co_partidascc.codcentro = centroscoste.codcentro INNER JOIN empresa ON centroscoste.idempresa = empresa.id", "centroscoste.idempresa", "facturasprov.idfactura = " + cursor.valueBuffer("idfactura") + " AND centroscoste.idempresa = " + idEmpresa, "facturasprov,co_partidas,co_partidascc,centroscoste,empresa");

  var nombreEmpresa = AQUtil.sqlSelect("empresa", "nombre", "id = " + idEmpresa);
  /// Si no hay registro significa que para la empresa pasada por parámetro no hay ninguna partida repartida en su centro de coste.
  if (!hayRegistro) {
    _i.mensajeNOempresa_ += "-" + nombreEmpresa + "\n";
    return true;
  }

  var codCliente = AQUtil.sqlSelect("empresa", "codclienteemp", "id = " + idEmpresa);
  hayRegistro = AQUtil.sqlSelect("facturascli", "codigo", "idfacturareparto = " + cursor.valueBuffer("idfactura") + " AND codcliente = '" + codCliente + "'");

  /// Si hay registro significa que ya se ha creado la factura de cliente para ese reparto de gastos por centro de coste y empresa.
  if (hayRegistro) {
    _i.mensajeYAfacturado_ += "-" + nombreEmpresa + " (Código factura de cliente: " + hayRegistro + ")\n";
    return true;
  }

  var curFacturaCli = new FLSqlCursor("facturascli");

  curFacturaCli.setModeAccess(curFacturaCli.Insert);
  curFacturaCli.refreshBuffer();

  if (!_i.datosFacturaMultiCoste(curFacturaCli, idEmpresa)) {
    return false;
  }
  if (!curFacturaCli.commitBuffer()) {
    return false;
  }

  var idFactura = curFacturaCli.valueBuffer("idfactura");

  var q = new FLSqlQuery();
  q.setSelect("SUM(co_partidascc.importe),centroscoste.codcentro");
  q.setFrom("facturasprov INNER JOIN co_partidas ON facturasprov.idasiento = co_partidas.idasiento INNER JOIN co_partidascc ON co_partidas.idpartida = co_partidascc.idpartida INNER JOIN centroscoste ON co_partidascc.codcentro = centroscoste.codcentro INNER JOIN empresa ON centroscoste.idempresa = empresa.id");
  q.setWhere("facturasprov.idfactura = " + cursor.valueBuffer("idfactura") + "AND centroscoste.idempresa = " + idEmpresa + " GROUP BY centroscoste.codcentro");
  q.setForwardOnly(true);

  if (!q.exec()) {
    return false;
  }
  while (q.next()) {
    if (!_i.datosLineaFacturaMultiCoste(idFactura, q.value("SUM(co_partidascc.importe)"), q.value("centroscoste.codcentro"))) {
      return false;
    }
  }

  curFacturaCli.select("idfactura = " + idFactura);
  curFacturaCli.first();
  curFacturaCli.setModeAccess(curFacturaCli.Edit);
  curFacturaCli.refreshBuffer();
  var codFactura = curFacturaCli.valueBuffer("codigo");
  _i.totalesFacturaReparto(curFacturaCli);

  if (!curFacturaCli.commitBuffer()) {
    return false;
  }
  _i.mensajeFacturados_ += "-" + nombreEmpresa + ": Factura de cliente " + codFactura + "\n";
  return true;
}

function multiempresaCCoste_datosFacturaMultiCoste(curFacturaCli, idEmpresa)
{
  var _i = this.iface;
  var cursor = this.cursor();

  var codCliente = AQUtil.sqlSelect("empresa", "codclienteemp", "id = " + idEmpresa);

  if (!codCliente) {
    sys.warnMsgBox(sys.translate("NO hay un cliente de facturación para la empresa de código: ") + idEmpresa);
    return false;
  }

  var q = new FLSqlQuery();
  q.setSelect("c.nombre, c.cifnif, c.coddivisa, d.tasaconv, c.codserie, c.codpago, dc.direccion, dc.ciudad, dc.provincia, dc.idprovincia, dc.codpostal, dc.codpais, dc.apartado");
  q.setFrom("clientes c LEFT JOIN dirclientes dc ON c.codcliente = dc.codcliente LEFT OUTER JOIN divisas d ON c.coddivisa = d.coddivisa");
  q.setWhere("c.codcliente = '" + codCliente + "' AND dc.domfacturacion");
  q.setForwardOnly(true);

  if (!q.exec()) {
    return false;
  }
  if (q.first()) {
    var fecha = new Date;
    with(curFacturaCli) {
      setValueBuffer("codcliente", codCliente);
      setValueBuffer("nombrecliente", q.value("c.nombre"));
      setValueBuffer("cifnif", q.value("c.cifnif"));
      setValueBuffer("coddivisa", q.value("c.coddivisa"));
      setValueBuffer("direccion", q.value("dc.direccion"));
      setValueBuffer("tasaconv", q.value("d.tasaconv"));
      setValueBuffer("recfinanciero", cursor.valueBuffer("recfinanciero"));
      setValueBuffer("codpago", q.value("c.codpago"));
      setValueBuffer("codalmacen", cursor.valueBuffer("codalmacen"));
      setValueBuffer("fecha", fecha);
      setValueBuffer("hora", fecha);
      setValueBuffer("codejercicio", flfactppal.iface.pub_ejercicioActual());
      setValueBuffer("codserie", q.value("c.codserie"));
      setValueBuffer("irpf", cursor.valueBuffer("irpf"));
      setValueBuffer("automatica", true);
      setValueBuffer("observaciones", cursor.valueBuffer("observaciones"));
      setValueBuffer("idfacturareparto", cursor.valueBuffer("idfactura"));
      setValueBuffer("codcentro", cursor.valueBuffer("codcentro"));
      setValueBuffer("codsubcentro", cursor.valueBuffer("codsubcentro"));
    }
    if (flfactppal.iface.pub_extension("iva_nav")) {
      var codGrupoIvaNeg = AQUtil.sqlSelect("clientes", "codgrupoivaneg", "codcliente = '" + codCliente + "'");
      curFacturaCli.setValueBuffer("codgrupoivaneg", codGrupoIvaNeg);
    }
    _i.datosDireccionFacturaMultiCoste(curFacturaCli, q);
  }

  return true;
}

function multiempresaCCoste_datosDireccionFacturaMultiCoste(curFacturaCli, q)
{
  var _i = this.iface;
  var cursor = this.cursor();

  if (q.value("dc.codpostal") && q.value("dc.codpostal") != 0 && q.value("dc.codpostal") != "") {
    curFacturaCli.setValueBuffer("codpostal", q.value("dc.codpostal"));
  }
  if (q.value("dc.ciudad") && q.value("dc.ciudad") != 0 && q.value("dc.ciudad") != "") {
    curFacturaCli.setValueBuffer("ciudad", q.value("dc.ciudad"));
  }
  if (q.value("dc.idprovincia") && q.value("dc.idprovincia") != 0 && q.value("dc.idprovincia") != "") {
    curFacturaCli.setValueBuffer("idprovincia", q.value("dc.idprovincia"));
  }
  if (q.value("dc.provincia") && q.value("dc.provincia") != 0 && q.value("dc.provincia") != "") {
    curFacturaCli.setValueBuffer("provincia", q.value("dc.provincia"));
  }
  if (q.value("dc.apartado") && q.value("dc.apartado") != 0 && q.value("dc.apartado") != "") {
    curFacturaCli.setValueBuffer("apartado", q.value("dc.apartado"));
  }
  if (q.value("dc.codpais") && q.value("dc.codpais") != 0 && q.value("dc.codpais") != "") {
    curFacturaCli.setValueBuffer("codpais", q.value("dc.codpais"));
  }
}

function multiempresaCCoste_datosLineaFacturaMultiCoste(idFacturaCli, importe, codCentro)
{
  var _i = this.iface;
  var cursor = this.cursor();

  var referencia = AQUtil.sqlSelect("lineasfacturasprov", "referencia", "idfactura = " + cursor.valueBuffer("idfactura") + " ORDER BY idlinea");

  var curLineaFacturaCli = new FLSqlCursor("lineasfacturascli");
  with(curLineaFacturaCli) {
    setModeAccess(Insert);
    refreshBuffer();
    setValueBuffer("idfactura", idFacturaCli);
    setValueBuffer("referencia", referencia);
    setValueBuffer("descripcion", "Centro coste: " + codCentro + " / " + AQUtil.sqlSelect("articulos", "descripcion", "referencia = '" + referencia + "'"));
    setValueBuffer("cantidad", 1);
    setValueBuffer("codsubcuenta", AQUtil.sqlSelect("articulos", "codsubcuentaven", "referencia = '" + referencia + "'"));
    setValueBuffer("codimpuesto", AQUtil.sqlSelect("articulos", "codimpuesto", "referencia = '" + referencia + "'"));
    setValueBuffer("iva", AQUtil.sqlSelect("impuestos", "iva", "codimpuesto = '" + AQUtil.sqlSelect("articulos", "codimpuesto", "referencia = '" + referencia + "'") + "'"));
    setValueBuffer("codcentro", codCentro);
  }

  if (flfactppal.iface.pub_extension("iva_incluido")) {
    var importeSinIva = parseFloat(importe) / (1 + (parseFloat(curLineaFacturaCli.valueBuffer("iva")) / 100));

    curLineaFacturaCli.setValueBuffer("pvpsindto", importeSinIva);
    curLineaFacturaCli.setValueBuffer("pvpunitario", importeSinIva);
    curLineaFacturaCli.setValueBuffer("pvptotal", importeSinIva);

    curLineaFacturaCli.setValueBuffer("pvpsindtoiva", importe);
    curLineaFacturaCli.setValueBuffer("pvpunitarioiva", importe);
    curLineaFacturaCli.setValueBuffer("pvptotaliva", importe);
  } else {
    curLineaFacturaCli.setValueBuffer("pvpsindto", importe);
    curLineaFacturaCli.setValueBuffer("pvpunitario", importe);
    curLineaFacturaCli.setValueBuffer("pvptotal", importe);
  }

  if (!curLineaFacturaCli.commitBuffer()) {
    return false;
  }

  return true;
}

function multiempresaCCoste_totalesFacturaReparto(curFacturaCli)
{
  with(curFacturaCli) {
    setValueBuffer("neto", formfacturascli.iface.pub_commonCalculateField("neto", this));
    setValueBuffer("totaliva", formfacturascli.iface.pub_commonCalculateField("totaliva", this));
    setValueBuffer("totalirpf", formfacturascli.iface.pub_commonCalculateField("totalirpf", this));
    setValueBuffer("totalrecargo", formfacturascli.iface.pub_commonCalculateField("totalrecargo", this));
    setValueBuffer("total", formfacturascli.iface.pub_commonCalculateField("total", this));
    setValueBuffer("totaleuros", formfacturascli.iface.pub_commonCalculateField("totaleuros", this));
  }
}
//// MULTIEMPRESAS CENTROS DE COSTE /////////////////////////////
/////////////////////////////////////////////////////////////////
