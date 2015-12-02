
/** @class_declaration ivaNav */
/////////////////////////////////////////////////////////////////
//// IVA NAV ////////////////////////////////////////////////////
class ivaNav extends oficial
{
  function ivaNav(context)
  {
    oficial(context);
  }
  function calcularValores()
  {
    return this.ctx.ivaNav_calcularValores();
  }
}
//// IVA NAV ////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition ivaNav */
/////////////////////////////////////////////////////////////////
//// IVA NAV ////////////////////////////////////////////////////
function ivaNav_calcularValores()
{
  var _i = this.iface;
  if (!_i.limpiarValores()) {
    return false;
  }

  var cursor = this.cursor();

  if (cursor.modeAccess() == cursor.Insert) {
    this.child("tdbOperaciones").cursor().commitBufferCursorRelation();
  }

  var qryOperaciones = new FLSqlQuery;
  qryOperaciones.setTablesList("co_partidas,co_subcuentascli,co_asientos");
  qryOperaciones.setSelect("p.idpartida, p.idasiento, f.codcliente, f.idfactura, p.baseimponible, f.clavemodelo349");
  qryOperaciones.setFrom("co_asientos a INNER JOIN co_partidas p ON a.idasiento = p.idasiento INNER JOIN gruposcontablesivaneg g ON p.codgrupoivaneg = g.codgrupoivaneg LEFT OUTER JOIN co_subcuentas s ON p.idsubcuenta = s.idsubcuenta INNER JOIN facturascli f ON f.idasiento = a.idasiento");
  qryOperaciones.setWhere("a.codejercicio = '" + cursor.valueBuffer("codejercicio") + "' AND g.modelo349 AND a.fecha BETWEEN '" + cursor.valueBuffer("fechainicio") + "' AND '" + cursor.valueBuffer("fechafin") + "' ORDER BY f.codcliente");
  qryOperaciones.setForwardOnly(true);
  debug(qryOperaciones.sql());
  if (!qryOperaciones.exec()) {
    MessageBox.critical(sys.translate("Falló la consulta de operaciones de entrega"), MessageBox.Ok, MessageBox.NoButton);
    return;
  }

  AQUtil.createProgressDialog(sys.translate("Generando operaciones de entregas"), qryOperaciones.size());
  var paso: Number = 0;
  AQUtil.setProgress(++paso);
  var curOperaciones = new FLSqlCursor("co_operaciones349"); //this.child("tdbOperaciones").cursor();
  var curRectificaciones = new FLSqlCursor("co_rectificaciones349"); //this.child("tdbRectificaciones").cursor();
  var idModelo = cursor.valueBuffer("idmodelo");
  var datosOp;
  var importe;
  var codCliente;
  var idOperacion;
  var idRectificacion, fechaRectificada, periodoRec, idModeloRec, codEjercicioRec;
  var clave;
  var idPartida;
  var rectificacion;
  while (qryOperaciones.next()) {
    AQUtil.setProgress(++paso);
    idPartida = qryOperaciones.value("p.idpartida");
    codCliente = qryOperaciones.value("f.codcliente");
    clave = qryOperaciones.value("f.clavemodelo349");
    if (!clave || clave == "" || clave == "Auto") {
      clave = "E";
    }

    importe = parseFloat(qryOperaciones.value("p.baseimponible"));
    if (importe == 0) {
      continue;
    }
    rectificacion = false;
    fechaRectificada = AQUtil.sqlSelect("facturascli f INNER JOIN facturascli fr ON f.idfacturarect = fr.idfactura", "fr.fecha", "f.idfactura = " + qryOperaciones.value("f.idfactura"));
    if (fechaRectificada) {
      codEjercicioRec = AQUtil.sqlSelect("facturascli f INNER JOIN facturascli fr ON f.idfacturarect = fr.idfactura", "fr.codejercicio", "f.idfactura = " + qryOperaciones.value("f.idfactura"), "facturascli");
      periodoRec = this.iface.obtenerPeriodo(fechaRectificada);
      if (codEjercicioRec != cursor.valueBuffer("codejercicio") || periodoRec != cursor.valueBuffer("periodo")) {
        rectificacion = true;
      }
    }
    if (rectificacion) {
      idRectificacion = AQUtil.sqlSelect("co_rectificaciones349", "id", "idmodelo = " + idModelo + " AND codcliente = '" + codCliente + "' AND periodo = '" + periodoRec + "' AND codejercicio = '" + codEjercicioRec + "'");
      if (!idRectificacion) {
        datosOp = this.iface.datosOperacionE(codCliente);
        if (!datosOp.ok) {
          AQUtil.destroyProgressDialog();
          MessageBox.critical(AQUtil.translate("scripts", "Falló la obtención de datos del cliente %1.\nAsegúrese de que el cliente tiene una dirección de facturación y un país asociado a la misma.").arg(codCliente), MessageBox.Ok, MessageBox.NoButton);
          return;
        }
        idModeloRec = AQUtil.sqlSelect("co_modelo349", "idmodelo", "periodo = '" + periodoRec + "' AND EXTRACT(YEAR FROM fechainicio) = '" + codEjercicioRec + "'");
        if (idModeloRec) {
          biAnterior = parseFloat(AQUtil.sqlSelect("co_operaciones349", "baseimponible", "idmodelo = " + idModeloRec + " AND codcliente = '" + codCliente + "'"));
          if (isNaN(biAnterior)) {
            biAnterior = 0;
          }
        } else {
          biAnterior = 0;
        }
        biRectificada = biAnterior + importe;
        with(curRectificaciones) {
          setModeAccess(Insert);
          refreshBuffer();
          setValueBuffer("idmodelo", idModelo);
          if (idModeloRec) {
            setValueBuffer("idmodelorec", idModeloRec);
          }
          setValueBuffer("codejercicio", codEjercicioRec);
          setValueBuffer("periodo", periodoRec);
          setValueBuffer("clave", clave);
          setValueBuffer("codpais", datosOp.codPais);
          setValueBuffer("codue", datosOp.codIso);
          setValueBuffer("codcliente", codCliente);
          setValueBuffer("cifnif", datosOp.cifNif);
          setValueBuffer("nombre", datosOp.nombre);
          setValueBuffer("bianterior", biAnterior);
          setValueBuffer("birectificada", 0);
          if (!commitBuffer()) {
            AQUtil.destroyProgressDialog();
            MessageBox.critical(sys.translate("Falló la inserción de rectificación para el cliente: %1.").arg(codCliente), MessageBox.Ok, MessageBox.NoButton);
            return;
          }
          idRectificacion = curRectificaciones.valueBuffer("id");
        }
      }
      debug("asociando rect = " + idRectificacion);
      if (!_i.asociarPartidaRectificacion(idPartida, idRectificacion)) {
        AQUtil.destroyProgressDialog();
        return false;
      }
    } else {
      idOperacion = AQUtil.sqlSelect("co_operaciones349", "id", "idmodelo = " + idModelo + " AND codcliente = '" + codCliente + "'");
      if (!idOperacion) {
        datosOp = _i.datosOperacionE(codCliente);
        if (!datosOp.ok) {
          AQUtil.destroyProgressDialog();
          MessageBox.critical(sys.translate("Falló la obtención de datos del cliente %1.\nAsegúrese de que el cliente tiene una dirección de facturación y un país asociado a la misma.").arg(codCliente), MessageBox.Ok, MessageBox.NoButton);
          return;
        }
        with(curOperaciones) {
          setModeAccess(Insert);
          refreshBuffer();
          setValueBuffer("idmodelo", cursor.valueBuffer("idmodelo"));
          setValueBuffer("clave", clave);
          setValueBuffer("codpais", datosOp.codPais);
          setValueBuffer("codue", datosOp.codIso);
          setValueBuffer("codcliente", codCliente);
          setValueBuffer("cifnif", datosOp.cifNif);
          setValueBuffer("nombre", datosOp.nombre);
          setValueBuffer("baseimponible", 0);
          if (!commitBuffer()) {
            MessageBox.critical(sys.translate("Falló la inserción de operación para el cliente: %1.").arg(codCliente), MessageBox.Ok, MessageBox.NoButton);
            return;
          }
        }
        idOperacion = curOperaciones.valueBuffer("id");
        debug("idOperacion cliente = " + idOperacion);
      }
      if (!_i.asociarPartidaOperacion(idPartida, idOperacion)) {
        AQUtil.destroyProgressDialog();
        return false;
      }
    }
  }
  AQUtil.destroyProgressDialog();

  qryOperaciones.setTablesList("co_partidas,co_subcuentasprov,co_asientos");
  qryOperaciones.setSelect("f.codproveedor, f.idfactura, p.idpartida, p.idasiento, p.baseimponible, f.clavemodelo349");
  qryOperaciones.setFrom("co_asientos a INNER JOIN co_partidas p ON a.idasiento = p.idasiento INNER JOIN gruposcontablesivaproneg gpn ON (p.codgrupoivaneg = gpn.codgrupoivaneg AND p.codimpuesto = gpn.codimpuesto) INNER JOIN gruposcontablesivaneg g ON p.codgrupoivaneg = g.codgrupoivaneg INNER JOIN facturasprov f ON a.idasiento = f.idasiento");
  qryOperaciones.setWhere("a.codejercicio = '" + cursor.valueBuffer("codejercicio") + "' AND g.modelo349 AND a.fecha BETWEEN '" + cursor.valueBuffer("fechainicio") + "' AND '" + cursor.valueBuffer("fechafin") + "' AND p.codsubcuenta <> gpn.codsubcuentarev ORDER BY f.codproveedor");
  qryOperaciones.setForwardOnly(true);
  if (!qryOperaciones.exec()) {
    MessageBox.critical(sys.translate("Falló la consulta de operaciones de adquisición"), MessageBox.Ok, MessageBox.NoButton);
    return;
  }
  AQUtil.createProgressDialog(sys.translate("Generando operaciones de adquisiciones"), qryOperaciones.size());
  paso = 0;

  var codProveedor;
  while (qryOperaciones.next()) {
    AQUtil.setProgress(++paso);
    idPartida = qryOperaciones.value("p.idpartida");
    codProveedor = qryOperaciones.value("f.codproveedor");
    clave = qryOperaciones.value("f.clavemodelo349");
    if (!clave || clave == "" || clave == "Auto") {
      clave = "A";
    }
    importe = parseFloat(qryOperaciones.value("p.baseimponible"));
    if (importe == 0) {
      continue;
    }

    rectificacion = false;
    fechaRectificada = AQUtil.sqlSelect("facturasprov f INNER JOIN facturasprov fr ON f.idfacturarect = fr.idfactura", "fr.fecha", "f.idfactura = " + qryOperaciones.value("f.idfactura"), "facturasprov");
    if (fechaRectificada) {
      codEjercicioRec = AQUtil.sqlSelect("facturasprov f INNER JOIN facturasprov fr ON f.idfacturarect = fr.idfactura", "fr.codejercicio", "f.idfactura = " + qryOperaciones.value("f.idfactura"), "facturasprov");
      periodoRec = _i.obtenerPeriodo(fechaRectificada);
      if (codEjercicioRec != cursor.valueBuffer("codejercicio") || periodoRec != cursor.valueBuffer("periodo")) {
        rectificacion = true;
      }
    }
    if (rectificacion) {
      idRectificacion = AQUtil.sqlSelect("co_rectificaciones349", "id", "idmodelo = " + idModelo + " AND codproveedor = '" + codProveedor + "' AND periodo = '" + periodoRec + "' AND codejercicio = '" + codEjercicioRec + "'");
      if (!idRectificacion) {
        datosOp = this.iface.datosOperacionA(codProveedor);
        if (!datosOp.ok) {
          AQUtil.destroyProgressDialog();
          MessageBox.critical(sys.translate("Falló la obtención de datos del proveedor %1.\nAsegúrese de que el proveedor tiene una dirección principal y un país asociado a la misma.").arg(codProveedor), MessageBox.Ok, MessageBox.NoButton);
          return;
        }
        idModeloRec = AQUtil.sqlSelect("co_modelo349", "idmodelo", "periodo = '" + periodoRec + "' AND EXTRACT(YEAR FROM fechainicio) = '" + codEjercicioRec + "'");
        if (idModeloRec) {
          biAnterior = parseFloat(AQUtil.sqlSelect("co_operaciones349", "baseimponible", "idmodelo = " + idModeloRec + " AND codproveedor = '" + codProveedor + "'"));
          if (isNaN(biAnterior)) {
            biAnterior = 0;
          }
        } else {
          biAnterior = 0;
        }
        biRectificada = biAnterior + importe;
        with(curRectificaciones) {
          setModeAccess(Insert);
          refreshBuffer();
          setValueBuffer("idmodelo", idModelo);
          if (idModeloRec) {
            setValueBuffer("idmodelorec", idModeloRec);
          }
          setValueBuffer("codejercicio", codEjercicioRec);
          setValueBuffer("periodo", periodoRec);
          setValueBuffer("clave", clave);
          setValueBuffer("codpais", datosOp.codPais);
          setValueBuffer("codue", datosOp.codIso);
          setValueBuffer("codproveedor", codProveedor);
          setValueBuffer("cifnif", datosOp.cifNif);
          setValueBuffer("nombre", datosOp.nombre);
          setValueBuffer("bianterior", biAnterior);
          setValueBuffer("birectificada", 0);
          if (!commitBuffer()) {
            AQUtil.destroyProgressDialog();
            MessageBox.critical(sys.translate("Falló la inserción de rectificación para el proveor: %1.").arg(codProveedor), MessageBox.Ok, MessageBox.NoButton);
            return;
          }
          idRectificacion = curRectificaciones.valueBuffer("id");
        }
      }
      if (!_i.asociarPartidaRectificacion(idPartida, idRectificacion)) {
        AQUtil.destroyProgressDialog();
        return false;
      }
    } else {
      debug("partida = " + idPartida);
      idOperacion = AQUtil.sqlSelect("co_operaciones349", "id", "idmodelo = " + idModelo + " AND codproveedor = '" + codProveedor + "'");
      debug("idOperacion = " + idOperacion);
      if (!idOperacion) {
        datosOp = _i.datosOperacionA(codProveedor);
        if (!datosOp.ok) {
          AQUtil.destroyProgressDialog();
          MessageBox.critical(sys.translate("Falló la obtención de datos del proveedor %1.\nAsegúrese de que el proveedor tiene una dirección principal y un país asociado a la misma.").arg(codProveedor), MessageBox.Ok, MessageBox.NoButton);
          return;
        }
        with(curOperaciones) {
          setModeAccess(Insert);
          refreshBuffer();
          setValueBuffer("idmodelo", cursor.valueBuffer("idmodelo"));
          setValueBuffer("clave", clave);
          setValueBuffer("codpais", datosOp.codPais);
          setValueBuffer("codue", datosOp.codIso);
          setValueBuffer("codproveedor", codProveedor);
          setValueBuffer("cifnif", datosOp.cifNif);
          setValueBuffer("nombre", datosOp.nombre);
          setValueBuffer("baseimponible", 0);
          if (!commitBuffer()) {
            MessageBox.critical(sys.translate("Falló la inserción de operación para el proveedor: %1.").arg(codProveedor), MessageBox.Ok, MessageBox.NoButton);
            return;
          }
        }
        idOperacion = curOperaciones.valueBuffer("id");
        debug("idOperacion = " + idOperacion);
      }
      if (!_i.asociarPartidaOperacion(idPartida, idOperacion)) {
        debug("!falló asociar");
        AQUtil.destroyProgressDialog();
        return false;
      }
    }
  }
  AQUtil.destroyProgressDialog();

  _i.calcularParciales();
}
//// IVA NAV ////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
