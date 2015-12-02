
/** @class_declaration ivaNav */
/////////////////////////////////////////////////////////////////
//// IVA NAV ////////////////////////////////////////////////////
class ivaNav extends oficial
{
  function ivaNav(context)
  {
    oficial(context);
  }
  function cargarFacturasEmitidas()
  {
    return this.ctx.ivaNav_cargarFacturasEmitidas();
  }
  function cargarFacturasRecibidas()
  {
    return this.ctx.ivaNav_cargarFacturasRecibidas();
  }
  function dameClienteQry(qryEmitidas)
  {
    return this.ctx.ivaNav_dameClienteQry(qryEmitidas);
  }
  function dameWhereEmi()
  {
    return this.ctx.ivaNav_dameWhereEmi();
  }
  function dameWhereRec()
  {
    return this.ctx.ivaNav_dameWhereRec();
  }
}
//// IVA NAV ////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition ivaNav */
/////////////////////////////////////////////////////////////////
//// IVA NAV ////////////////////////////////////////////////////
function ivaNav_dameClienteQry(qryEmitidas)
{
  var _i = this.iface;
  var cursor = this.cursor();

  var codEjercicio = cursor.valueBuffer("codejercicio");
  var codSubcuentaCli = qryEmitidas.value("co_partidas.codcontrapartida");
  var codCliente = AQUtil.sqlSelect("co_subcuentascli", "codcliente", "codsubcuenta = '" + codSubcuentaCli + "' AND codejercicio = '" + codEjercicio + "'");
  return codCliente;
}

function ivaNav_cargarFacturasEmitidas()
{
  var _i = this.iface;
  var cursor = this.cursor();

  var idModelo = cursor.valueBuffer("idmodelo");
  var codEjercicio = cursor.valueBuffer("codejercicio");
  var fechaInicioE = AQUtil.sqlSelect("ejercicios", "fechainicio", "codejercicio = '" + codEjercicio + "'");
  var anoF = fechaInicioE.getYear();

  if (!_i.limpiarFacturasEmitidas()) {
    return false;
  }
  var qryEmitidas = new FLSqlQuery("co_i_facturasemi");
  var where = _i.dameWhereEmi();

  qryEmitidas.setWhere(where);
  qryEmitidas.setForwardOnly(true);
  if (!qryEmitidas.exec()) {
    return false;
  }
  var qryDatosCliente: FLSqlQuery = new FLSqlQuery;
  qryDatosCliente.setTablesList("clientes,dirclientes,paises");
  qryDatosCliente.setSelect("p.codiso, c.tipoidfiscal");
  qryDatosCliente.setFrom("clientes c INNER JOIN dirclientes dc ON (c.codcliente = dc.codcliente AND dc.domfacturacion = true) LEFT OUTER JOIN paises p ON dc.codpais = p.codpais");

  var qryFactura: FLSqlQuery = new FLSqlQuery;
  qryFactura.setTablesList("facturascli");
  qryFactura.setSelect("codcliente, nombrecliente, cifnif, idfactura, codigo, deabono, idfacturarect, codigo");
  qryFactura.setFrom("facturascli");

  var curEmitidas = new FLSqlCursor("co_facturasemi340");
  var cifNif, codPais;
  var base, cuota, importe, cuotaRecargo;
  var idAsiento, idFactura, operacion;
  var codFacRectificada, codFactura;
  var numAsiento, codSubcuentaRec, codImpuesto;
  var razonSocial, codCliente, tipoIdFiscal;
  AQUtil.createProgressDialog(sys.translate("Cargando facturas emitidas..."), qryEmitidas.size());
  var paso = 0;
  while (qryEmitidas.next()) {
    AQUtil.setProgress(++paso);
    tipoIdFiscal = "1";
    operacion = "";
    idFactura = "";
    codFacRectificada = "";
    idAsiento = qryEmitidas.value("co_asientos.idasiento");
    numAsiento = qryEmitidas.value("co_asientos.numero");
    //     codTipoEspecial = qryEmitidas.value("sc1.idcuentaesp");

    qryFactura.setWhere("idasiento = " + idAsiento);
    if (!qryFactura.exec()) {
      AQUtil.destroyProgressDialog();
      return false;
    }
    if (qryFactura.first()) {
      codCliente = qryFactura.value("codcliente");
      cifNif = qryFactura.value("cifnif");
      idFactura = qryFactura.value("idfactura");
      codFactura = qryFactura.value("codigo");
      if (qryFactura.value("deabono")) {
        codFacRectificada = AQUtil.sqlSelect("facturascli", "codigo", "idfactura = " + qryFactura.value("idfacturarect"));
        if (codFacRectificada && codFacRectificada != "") {
          operacion = "D";
        }
      }
      razonSocial = qryFactura.value("nombrecliente");
      qryDatosCliente.setWhere("c.codcliente = '" + codCliente + "'");
      codFactura = qryFactura.value("codigo");
    } else {
      codCliente = _i.dameClienteQry(qryEmitidas);
      if (!codCliente) {
        MessageBox.warning(sys.translate("Error al cargar los datos del asiento %1.\nNo se ha encontrado el cliente asociado a la subcuenta %2 y el ejercicio %3").arg(numAsiento).arg(codSubcuentaCli).arg(codEjercicio), MessageBox.Ok, MessageBox.NoButton);
        return false;
      }
      qryDatosCliente.setWhere("c.codcliente = '" + codCliente + "'");
      razonSocial = qryEmitidas.value("sc2.descripcion");
      cifNif = qryEmitidas.value("co_partidas.cifnif");
      codFactura = qryEmitidas.value("co_partidas.documento");
    }
    razonSocial = razonSocial.left(40);
    razonSocial = this.iface.formatearTexto340(razonSocial)

    if (!qryDatosCliente.exec()) {
      AQUtil.destroyProgressDialog();
      return false;
    }
    if (qryDatosCliente.first()) {
      tipoIdFiscal = qryDatosCliente.value("c.tipoidfiscal");
      codPais = qryDatosCliente.value("p.codiso");
    }
    if (!codPais || codPais == "") {
      codPais = "ES";
    }

    curEmitidas.setModeAccess(curEmitidas.Insert);
    curEmitidas.refreshBuffer();
    curEmitidas.setValueBuffer("idmodelo", idModelo);
    if (codPais == "ES") {
      cifNif = flcontmode.iface.pub_limpiarCifNif(cifNif);
      if (cifNif.length > 9) {
        var mensaje;
        if (idFactura != "") {
          mensaje = sys.translate("El N.I.F. %1 de la factura %2 (%3) tiene más de 9 caracteres.\nPulse Calcelar para cancelar la operación o Ignorar para ignorar esta factura").arg(cifNif).arg(codFactura).arg(razonSocial);
        } else {
          mensaje = sys.translate("El N.I.F. %1 del asiento %2 (%3) tiene más de 9 caracteres.\nPulse Calcelar para cancelar la operación o Ignorar para ignorar esta factura").arg(cifNif).arg(numAsiento).arg(razonSocial);
        }
        var res = MessageBox.warning(mensaje, MessageBox.Ignore, MessageBox.Cancel);
        if (res == MessageBox.Ignore) {
          continue;
        } else {
          AQUtil.destroyProgressDialog();
          return false;
        }
      }
      curEmitidas.setValueBuffer("cifnif", cifNif);
    } else {
      if (!cifNif.startsWith(codPais)) {
        cifNif = codPais + cifNif;
      }
      curEmitidas.setValueBuffer("numidentificacion", cifNif);
    }
    if (!cifNif || cifNif == "") {
      var mensaje;
      if (idFactura != "") {
        mensaje = sys.translate("La factura %1 (%2) no tiene Identificador Fiscal asociado.\nPulse Calcelar para cancelar la operación o Ignorar para ignorar esta factura").arg(codFactura).arg(razonSocial);
      } else {
        mensaje = sys.translate("El asiento (%2) no tiene Identificador Fiscal asociado.\nPulse Calcelar para cancelar la operación o Ignorar para ignorar esta factura").arg(numAsiento).arg(razonSocial);
      }
      var res = MessageBox.warning(mensaje, MessageBox.Ignore, MessageBox.Cancel);
      if (res == MessageBox.Ignore) {
        continue;
      } else {
        AQUtil.destroyProgressDialog();
        return false;
      }
    }
    curEmitidas.setValueBuffer("apellidosnomrs", razonSocial);
    curEmitidas.setValueBuffer("codpais", codPais);
    if (tipoIdFiscal != "1") {
      tipoIdFiscal = _i.obtenerTipoIdFiscal(tipoIdFiscal);
      if ((tipoIdFiscal != "1" && codPais == "ES") || (tipoIdFiscal == "1" && codPais != "ES")) {
        var res: Number = MessageBox.warning(sys.translate("Los datos de Tipo de Identificación Fiscal y país del cliente no son coherentes para:\n%1\nFactura / Asiento: %2").arg(razonSocial).arg(idFactura != "" ? codFactura : numAsiento), MessageBox.Ignore, MessageBox.Cancel);
        if (res == MessageBox.Ignore) {
          continue;
        } else {
          AQUtil.destroyProgressDialog();
          return false;
        }
      }
    }
    curEmitidas.setValueBuffer("claveidentificacion", tipoIdFiscal);
    curEmitidas.setValueBuffer("tipolibro", "E");
    if (operacion == "") {
      curEmitidas.setNull("operacion");
    } else {
      curEmitidas.setValueBuffer("operacion", operacion);
    }
    curEmitidas.setValueBuffer("fechaexpedicion", qryEmitidas.value("co_asientos.fecha"));
    curEmitidas.setValueBuffer("fechaoperacion", qryEmitidas.value("co_asientos.fecha"));
    curEmitidas.setValueBuffer("tipoimpositivo", qryEmitidas.value("co_partidas.iva"));
    base = qryEmitidas.value("co_partidas.baseimponible");
    curEmitidas.setValueBuffer("baseimponible", base);
    cuota = qryEmitidas.value("(co_partidas.haber - co_partidas.debe)");
    curEmitidas.setValueBuffer("cuotaimpuesto", cuota);
    importe = parseFloat(base) + parseFloat(cuota);
    curEmitidas.setValueBuffer("importetotal", AQUtil.roundFieldValue(importe, "co_facturasemi340", "importetotal"));
    curEmitidas.setValueBuffer("baseimponiblecoste", 0);
    curEmitidas.setValueBuffer("idenfactura", codFactura);
    curEmitidas.setValueBuffer("numregistro", numAsiento);
    curEmitidas.setValueBuffer("numfacturas", 1);
    curEmitidas.setValueBuffer("desgloseregistro", 1);
    if (codFacRectificada && codFacRectificada != "" && operacion == "D") {
      curEmitidas.setValueBuffer("identfacturarect", codFacRectificada);
    }
    codSubcuentaRec = qryEmitidas.value("gpn.codsubcuentarec");
    codImpuesto = qryEmitidas.value("co_partidas.codimpuesto");
    if (codSubcuentaRec) {
      var d = flfactppal.iface.pub_ejecutarQry("co_partidas", "recargo,(haber - debe)", "idasiento = " + idAsiento + " AND codsubcuenta = '" + codSubcuentaRec + "' AND recargo <> 0 AND codimpuesto = '" + codImpuesto + "'");
      if (d.result == 1) {
        recargo = qryEmitidas.value("co_partidas.recargo");
        curEmitidas.setValueBuffer("tiporecequi", d["recargo"]);
        curEmitidas.setValueBuffer("cuotarecequi", d["(haber - debe)"]);
        //        cuotaRecargo = base * recargo / 100;
        //        curEmitidas.setValueBuffer("cuotarecequi", AQUtil.roundFieldValue(cuotaRecargo, "co_facturasemi340", "cuotarecequi"));
      }
    }
    curEmitidas.setValueBuffer("idasiento", idAsiento);
    if (idFactura && idFactura != "") {
      curEmitidas.setValueBuffer("idfactura", idFactura);
    }
    curEmitidas.setValueBuffer("ejerciciometalico", anoF);
    if (!curEmitidas.commitBuffer()) {
      AQUtil.destroyProgressDialog();
      return false;
    }
  }
  AQUtil.destroyProgressDialog();

  if (!_i.cargarVariosIVAEmi()) {
    return false;
  }

  if (!_i.cargaCobrosEfectivo()) {
    return false;
  }
  return true;
}

function ivaNav_dameWhereEmi()
{
  var cursor = this.cursor();
  /// No se cargan las partidas con recargo, se obtienen luego una a una
  var where = "co_asientos.codejercicio = '" + cursor.valueBuffer("codejercicio") + "' AND co_partidas.codimpuesto IS NOT NULL AND co_partidas.codgrupoivaneg IS NOT NULL AND co_partidas.recargo = 0 AND co_asientos.tipodocumento = 'Factura de cliente' AND co_asientos.fecha BETWEEN '" + cursor.valueBuffer("fechainicio") + "' AND '" + cursor.valueBuffer("fechafin") + "'";
  return where;
}

function ivaNav_cargarFacturasRecibidas()
{
  var _i = this.iface;
  var cursor = this.cursor();

  var codEjercicio = cursor.valueBuffer("codejercicio");
  var idModelo = cursor.valueBuffer("idmodelo");

  if (!_i.limpiarFacturasRecibidas()) {
    return false;
  }
  var qryRecibidas = new FLSqlQuery("co_i_facturasrec");
  var where = _i.dameWhereRec();

  qryRecibidas.setWhere(where);
  qryRecibidas.setForwardOnly(true);
  if (!qryRecibidas.exec()) {
    return false;
  }
  var qryDatosProveedor = new FLSqlQuery;
  qryDatosProveedor.setTablesList("proveedores,dirproveedores,paises");
  qryDatosProveedor.setSelect("p.codiso, pr.tipoidfiscal");
  qryDatosProveedor.setFrom("proveedores pr INNER JOIN dirproveedores dp ON (pr.codproveedor = dp.codproveedor AND dp.direccionppal = true) LEFT OUTER JOIN paises p ON dp.codpais = p.codpais");

  var qryFactura = new FLSqlQuery;
  qryFactura.setTablesList("facturasprov");
  qryFactura.setSelect("codproveedor, nombre, cifnif, idfactura, codigo, deabono, idfacturarect, numproveedor");
  qryFactura.setFrom("facturasprov");

  var curRecibidas = new FLSqlCursor("co_facturasrec340");
  var cifNif;
  var codPais;
  var base, cuota, importe, cuotaRecargo;
  var idAsiento, idFactura, operacion, codFacRectificada, codFactura, razonSocial, numAsiento, codProveedor;
  AQUtil.createProgressDialog(sys.translate("Cargando facturas recibidas..."), qryRecibidas.size());
  var paso = 0;
  var tipoIdFiscal;
  var tipoCalculo;
  while (qryRecibidas.next()) {
    AQUtil.setProgress(++paso);
    tipoIdFiscal = "1";
    operacion = "";
    idFactura = "";
    codFacRectificada = "";
    idAsiento = qryRecibidas.value("co_asientos.idasiento");
    numAsiento = qryRecibidas.value("co_asientos.numero");
    codFactura = qryRecibidas.value("co_partidas.documento"); /// No se toma el código de factura porque puede ser el nº proveedor o el DUA en import

    qryFactura.setWhere("idasiento = " + idAsiento);
    if (!qryFactura.exec()) {
      AQUtil.destroyProgressDialog();
      return false;
    }
    if (qryFactura.first()) {
      codProveedor = qryFactura.value("codproveedor");
      cifNif = qryFactura.value("cifnif");
      idFactura = qryFactura.value("idfactura");
      if (!codFactura || codFactura == "") {
        codFactura = qryFactura.value("codigo");
      }
      if (qryFactura.value("deabono")) {
        /** Sólo para emitidas
        codFacRectificada = util.sqlSelect("facturasprov", "codigo", "idfactura = " + qryFactura.value("idfacturarect"));
        if (codFacRectificada && codFacRectificada != "") {
          operacion = "D";
        } */
      }
      qryDatosProveedor.setWhere("pr.codproveedor = '" + codProveedor + "'");
      razonSocial = qryFactura.value("nombre");
    } else {
      cifNif = qryRecibidas.value("co_partidas.cifnif");
      var codSubcuentaProv = qryRecibidas.value("co_partidas.codcontrapartida");
      codProveedor = util.sqlSelect("co_subcuentasprov", "codproveedor", "codsubcuenta = '" + codSubcuentaProv + "' AND codejercicio = '" + codEjercicio + "'");
      if (!codProveedor) {
        MessageBox.warning(sys.translate("Error al cargar los datos del asiento %1.\nNo se ha encontrado el proveedor asociado a la subcuenta %2 y el ejercicio %3").arg(numAsiento).arg(codSubcuentaProv).arg(codEjercicio), MessageBox.Ok, MessageBox.NoButton);
        return false;
      }
      qryDatosProveedor.setWhere("pr.codproveedor = '" + codProveedor + "'");
      razonSocial = qryRecibidas.value("sc2.descripcion");
      idFactura = qryFactura.value("idfactura"); /// Para cuando es IVASIM
    }
    razonSocial = razonSocial.left(40);
    razonSocial = _i.formatearTexto340(razonSocial)

    if (!qryDatosProveedor.exec()) {
      AQUtil.destroyProgressDialog();
      return false;
    }
    if (qryDatosProveedor.first()) {
      codPais = qryDatosProveedor.value("p.codiso");
      tipoIdFiscal = qryDatosProveedor.value("pr.tipoidfiscal");
    }
    if (!codPais || codPais == "") {
      codPais = "ES";
    }

    curRecibidas.setModeAccess(curRecibidas.Insert);
    curRecibidas.refreshBuffer();
    curRecibidas.setValueBuffer("idmodelo", idModelo);
    if (codPais == "ES") {
      cifNif = flcontmode.iface.pub_limpiarCifNif(cifNif);
      if (cifNif.length > 9) {
        var mensaje: String;
        if (idFactura != "") {
          mensaje = sys.translate("El N.I.F. %1 de la factura %2 (%3) tiene más de 9 caracteres.\nPulse Calcelar para cancelar la operación o Ignorar para ignorar esta factura").arg(cifNif).arg(codFactura).arg(razonSocial);
        } else {
          mensaje = sys.translate("El N.I.F. %1 del asiento %2 (%3) tiene más de 9 caracteres.\nPulse Calcelar para cancelar la operación o Ignorar para ignorar esta factura").arg(cifNif).arg(numAsiento).arg(razonSocial);
        }
        var res = MessageBox.warning(mensaje, MessageBox.Cancel, MessageBox.Ignore);
        if (res == MessageBox.Ignore) {
          continue;
        } else {
          AQUtil.destroyProgressDialog();
          return false;
        }
      }
      curRecibidas.setValueBuffer("cifnif", cifNif);
    } else {
      if (!cifNif.startsWith(codPais)) {
        cifNif = codPais + cifNif;
      }
      curRecibidas.setValueBuffer("numidentificacion", cifNif);
    }
    if (!cifNif || cifNif == "") {
      var mensaje: String;
      if (idFactura != "") {
        mensaje = sys.translate("La factura %1 (%2) no tiene Identificador Fiscal asociado.\nPulse Calcelar para cancelar la operación o Ignorar para ignorar esta factura").arg(codFactura).arg(razonSocial);
      } else {
        mensaje = sys.translate("El asiento (%2) no tiene Identificador Fiscal asociado.\nPulse Calcelar para cancelar la operación o Ignorar para ignorar esta factura").arg(numAsiento).arg(razonSocial);
      }
      var res = MessageBox.warning(mensaje, MessageBox.Ignore, MessageBox.Cancel);
      if (res == MessageBox.Ignore) {
        continue;
      } else {
        AQUtil.destroyProgressDialog();
        return false;
      }
    }
    curRecibidas.setValueBuffer("apellidosnomrs", razonSocial);
    curRecibidas.setValueBuffer("codpais", codPais);
    if (tipoIdFiscal != "1") {
      tipoIdFiscal = this.iface.obtenerTipoIdFiscal(tipoIdFiscal);
      if ((tipoIdFiscal != "1" && codPais == "ES") || (tipoIdFiscal == "1" && codPais != "ES")) {
        var res = MessageBox.warning(sys.translate("Los datos de Tipo de Identificación Fiscal y país del proveedor no son coherentes para:\n%1\nFactura / Asiento: %2").arg(razonSocial).arg(idFactura != "" ? codFactura : numAsiento), MessageBox.Ignore, MessageBox.Cancel);
        if (res == MessageBox.Ignore) {
          continue;
        } else {
          AQUtil.destroyProgressDialog();
          return false;
        }
      }
    }
    curRecibidas.setValueBuffer("claveidentificacion", tipoIdFiscal);
    curRecibidas.setValueBuffer("tipolibro", "R");
    if (operacion == "") {
      curRecibidas.setNull("operacion");
    } else {
      curRecibidas.setValueBuffer("operacion", operacion);
    }
    curRecibidas.setValueBuffer("fechaexpedicion", qryRecibidas.value("co_asientos.fecha"));
    curRecibidas.setValueBuffer("fechaoperacion", qryRecibidas.value("co_asientos.fecha"));
    curRecibidas.setValueBuffer("tipoimpositivo", qryRecibidas.value("co_partidas.iva"));
    base = qryRecibidas.value("co_partidas.baseimponible");
    curRecibidas.setValueBuffer("baseimponible", base);
    cuota = qryRecibidas.value("(co_partidas.debe - co_partidas.haber)");
    curRecibidas.setValueBuffer("cuotaimpuesto", cuota);
    importe = parseFloat(base) + parseFloat(cuota);
    curRecibidas.setValueBuffer("importetotal", AQUtil.roundFieldValue(importe, "co_facturasemi340", "importetotal"));
    curRecibidas.setValueBuffer("baseimponiblecoste", 0);
    curRecibidas.setValueBuffer("idenfactura", codFactura);
    curRecibidas.setValueBuffer("numregistro", numAsiento);
    curRecibidas.setValueBuffer("numfacturas", 1);
    curRecibidas.setValueBuffer("desgloseregistro", 1);
    curRecibidas.setValueBuffer("idasiento", idAsiento);
    if (idFactura && idFactura != "") {
      curRecibidas.setValueBuffer("idfactura", idFactura);
    }
    tipoCalculo = qryRecibidas.value("gpn.tipocalculo");
    switch (tipoCalculo) {
      case "Reversión": {
        curRecibidas.setValueBuffer("cuotadeducible", cuota);
        break;
      }
    }
    if (!curRecibidas.commitBuffer()) {
      AQUtil.destroyProgressDialog();
      return false;
    }
  }
  AQUtil.destroyProgressDialog();

  if (!_i.cargarVariosIVARec()) {
    return false;
  }

  return true;
}

function ivaNav_dameWhereRec()
{
  var cursor = this.cursor();
  var where = "co_asientos.codejercicio = '" + cursor.valueBuffer("codejercicio") + "' AND co_partidas.codimpuesto IS NOT NULL and co_partidas.codgrupoivaneg IS NOT NULL AND co_asientos.tipodocumento = 'Factura de proveedor' AND (co_partidas.codsubcuenta <> gpn.codsubcuentarev OR gpn.codsubcuentarev IS NULL) AND co_asientos.fecha BETWEEN '" + cursor.valueBuffer("fechainicio") + "' AND '" + cursor.valueBuffer("fechafin") + "'";
  return where;
}

//// IVA NAV ////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
