
/** @class_declaration proveed */
//////////////////////////////////////////////////////////////////
//// PROVEED /////////////////////////////////////////////////////
class proveed extends oficial
{
  var curReciboProv: FLSqlCursor;
  var curPagoDevolProv_;
  var pagoIndirectoRemProv_, pagoDiferidoRemProv_;
  function proveed(context)
  {
    oficial(context);
  }
  function tienePagosDevProv(idRecibo: Number)
  {
    return this.ctx.proveed_tienePagosDevProv(idRecibo);
  }
  function regenerarRecibosProv(cursor: FLSqlCursor, forzarEmitirComo: String)
  {
    return this.ctx.proveed_regenerarRecibosProv(cursor, forzarEmitirComo);
  }
  function afterCommit_pagosdevolprov(curPD: FLSqlCursor)
  {
    return this.ctx.proveed_afterCommit_pagosdevolprov(curPD);
  }
  function beforeCommit_pagosdevolprov(curPD: FLSqlCursor)
  {
    return this.ctx.proveed_beforeCommit_pagosdevolprov(curPD);
  }
  function calcFechaVencimientoProv(curFactura, numPlazo, diasAplazado)
  {
    return this.ctx.proveed_calcFechaVencimientoProv(curFactura, numPlazo, diasAplazado);
  }
  function dameFechaEmisionProv(curFactura)
  {
    return this.ctx.proveed_dameFechaEmisionProv(curFactura);
  }
  function datosReciboProv(curFactura)
  {
    return this.ctx.proveed_datosReciboProv(curFactura);
  }
  function cambiaUltimoPagoProv(idRecibo: String, idPagoDevol: String, unlock: Boolean)
  {
    return this.ctx.proveed_cambiaUltimoPagoProv(idRecibo, idPagoDevol, unlock);
  }
  function calcularEstadoFacturaProv(idRecibo: String, idFactura: String)
  {
    return this.ctx.proveed_calcularEstadoFacturaProv(idRecibo, idFactura);
  }
  function borrarRecibosProv(idFactura: Number)
  {
    return this.ctx.proveed_borrarRecibosProv(idFactura);
  }
  function generarPartidasProv(curPD: FLSqlCursor, valoresDefecto: Array, datosAsiento: Array, recibo: Array)
  {
    return this.ctx.proveed_generarPartidasProv(curPD, valoresDefecto, datosAsiento, recibo);
  }
  function generarPartidasBancoProv(curPD: FLSqlCursor, valoresDefecto: Array, datosAsiento: Array, recibo: Array)
  {
    return this.ctx.proveed_generarPartidasBancoProv(curPD, valoresDefecto, datosAsiento, recibo);
  }
  function generarPartidasCambioProv(curPD: FLSqlCursor, valoresDefecto: Array, datosAsiento: Array, recibo: Array)
  {
    return this.ctx.proveed_generarPartidasCambioProv(curPD, valoresDefecto, datosAsiento, recibo);
  }
  function generarAsientoPagoDevolProv(curPD: FLSqlCursor)
  {
    return this.ctx.proveed_generarAsientoPagoDevolProv(curPD);
  }
  function dameSubcuentaProvPD(curPD, valoresDefecto, datosAsiento, recibo)
  {
    return this.ctx.proveed_dameSubcuentaProvPD(curPD, valoresDefecto, datosAsiento, recibo);
  }
  function codCuentaPagoProv(curFactura: FLSqlCursor)
  {
    return this.ctx.proveed_codCuentaPagoProv(curFactura);
  }
  function siGenerarRecibosProv(curFactura: FLSqlCursor, masCampos: Array)
  {
    return this.ctx.provee_siGenerarRecibosProv(curFactura, masCampos);
  }
  function obtenerDatosCuentaDomProv(codProveedor: String)
  {
    return this.ctx.provee_obtenerDatosCuentaDomProv(codProveedor);
  }
  function totalesReciboProv()
  {
    return this.ctx.provee_totalesReciboProv();
  }
  function datosPagoDevolProv(curFactura)
  {
    return this.ctx.provee_datosPagoDevolProv(curFactura);
  }
  function actualizarTotalesReciboProv(idRecibo)
  {
    return this.ctx.provee_actualizarTotalesReciboProv(idRecibo);
  }
  function pagoIndirectoRemesasProv()
  {
    return this.ctx.provee_pagoIndirectoRemesasProv();
  }
  function pagoDiferidoRemesasProv()
  {
    return this.ctx.provee_pagoDiferidoRemesasProv();
  }
  function cargaValoresDefecto()
  {
    return this.ctx.provee_cargaValoresDefecto();
  }
}
//// PROVEED /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration pubProveed */
/////////////////////////////////////////////////////////////////
//// PUB PROVEEDORES ////////////////////////////////////////////
class pubProveed extends ifaceCtx
{
  function pubProveed(context)
  {
    ifaceCtx(context);
  }
  function pub_calcularEstadoFacturaProv(idRecibo: String, idFactura: String)
  {
    return this.calcularEstadoFacturaProv(idRecibo, idFactura);
  }
  function pub_actualizarTotalesReciboProv(idRecibo)
  {
    return this.actualizarTotalesReciboProv(idRecibo);
  }
}
//// PUB PROVEEDORES ////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition proveed */
/////////////////////////////////////////////////////////////////
//// PROVEED ////////////////////////////////////////////////////
/** \D
Indica si un determinado recibo tiene pagos y/o devoluciones asociadas.
@param idRecibo: Identificador del recibo
@return True: Tiene, False: No tiene
\end */
function proveed_tienePagosDevProv(idRecibo: Number)
{
  var curPagosDev = new FLSqlCursor("pagosdevolprov");
  curPagosDev.select("idrecibo = " + idRecibo);
  return curPagosDev.next();
}

function proveed_regenerarRecibosProv(cursor: FLSqlCursor, forzarEmitirComo: String)
{
  if (!this.iface.siGenerarRecibosProv(cursor)) {
    return true;
  }

  var util = new FLUtil();
  var contActiva = sys.isLoadedModule("flcontppal") && util.sqlSelect("empresa", "contintegrada", "1 = 1");
  var idFactura = cursor.valueBuffer("idfactura");

  if (!this.iface.curReciboProv) {
    this.iface.curReciboProv = new FLSqlCursor("recibosprov");
  }
  if (!this.iface.borrarRecibosProv(idFactura)) {
    return false;
  }
  if (parseFloat(cursor.valueBuffer("total")) == 0) {
    return true;
  }

  var codPago = cursor.valueBuffer("codpago");
  var emitirComo: String;
  if (forzarEmitirComo) {
    emitirComo = forzarEmitirComo;
  } else {
    emitirComo = util.sqlSelect("formaspago", "genrecibos", "codpago = '" + codPago + "'");
  }

  var codProveedor = cursor.valueBuffer("codproveedor");
  var datosCuentaDom = this.iface.obtenerDatosCuentaDomProv(codProveedor);
  if (datosCuentaDom.error == 2) {
    return false;
  }

  var total = parseFloat(cursor.valueBuffer("total"));
  var idRecibo: Number;
  var numRecibo = 1;
  var importeRecibo: Number, importeEuros: Number;
  var diasAplazado: Number, fechaVencimiento: String;
  var tasaConv = parseFloat(cursor.valueBuffer("tasaconv"));
  var divisa = util.sqlSelect("divisas", "descripcion", "coddivisa = '" + cursor.valueBuffer("coddivisa") + "'");

  var codCuentaEmp = "";
  var desCuentaEmp = "";
  var ctaEntidadEmp = "";
  var ctaAgenciaEmp = "";
  var dCEmp = "";
  var cuentaEmp = "";
  var codSubcuentaEmp = "";
  var idSubcuentaEmp = "";
  if (emitirComo == "Pagados") {
    emitirComo = "Pagado";
    /*D Si los recibos deben emitirse como pagados, se generarán los registros de pago asociados a cada recibo. Si el módulo Principal de contabilidad está cargado, se generará el correspondienta asiento. La subcuenta contable del Debe del apunte corresponderá a la subcuenta contable asociada a la cuenta corriente correspondiente a la cuenta de pago del proveedor, o en su defecto a la forma de pago de la factura. Si dicha cuenta corriente no está especificada, la subcuenta contable del Debe del asiento será la correspondiente a la cuenta especial Caja.
    \end */
    codCuentaEmp = this.iface.codCuentaPagoProv(cursor);

    if (!codCuentaEmp) {
      codCuentaEmp = util.sqlSelect("proveedores", "codcuentapago", "codproveedor = '" + codProveedor + "'");
    }
    if (!codCuentaEmp) {
      codCuentaEmp = util.sqlSelect("formaspago", "codcuenta", "codpago = '" + codPago + "'");
    }
    var datosCuentaEmp = [];
    if (codCuentaEmp.toString().isEmpty()) {
      if (contActiva) {
        var qrySubcuenta = new FLSqlQuery();
        with(qrySubcuenta) {
          setTablesList("co_cuentas,co_subcuentas");
          setSelect("s.idsubcuenta, s.codsubcuenta");
          setFrom("co_cuentas c INNER JOIN co_subcuentas s ON c.idcuenta = s.idcuenta");
          setWhere("c.codejercicio = '" + cursor.valueBuffer("codejercicio") + "'" + " AND c.idcuentaesp = 'CAJA'");
        }
        if (!qrySubcuenta.exec()) {
          return false;
        }
        if (!qrySubcuenta.first())
          return false;
        idSubcuentaEmp = qrySubcuenta.value(0);
        codSubcuentaEmp = qrySubcuenta.value(1);
      }
    } else {
      datosCuentaEmp = flfactppal.iface.pub_ejecutarQry("cuentasbanco", "descripcion,ctaentidad,ctaagencia,cuenta,codsubcuenta", "codcuenta = '" + codCuentaEmp + "'");
      idSubcuentaEmp = util.sqlSelect("co_subcuentas", "idsubcuenta", "codsubcuenta = '" + datosCuentaEmp.codsubcuenta + "'" + " AND codejercicio = '" + cursor.valueBuffer("codEjercicio") + "'");
      desCuentaEmp = datosCuentaEmp.descripcion;
      ctaEntidadEmp = datosCuentaEmp.ctaentidad;
      ctaAgenciaEmp = datosCuentaEmp.ctaagencia;
      cuentaEmp = datosCuentaEmp.cuenta;
      var dc1 = util.calcularDC(ctaEntidadEmp + ctaAgenciaEmp);
      var dc2 = util.calcularDC(cuentaEmp);
      dCEmp = dc1 + dc2;
      codSubcuentaEmp =  datosCuentaEmp.codsubcuenta;
    }
  } else
    emitirComo = "Emitido";
  var numPlazo = 1;
  var curPlazos = new FLSqlCursor("plazos");
  var importeAcumulado = 0;
  curPlazos.select("codpago = '" + codPago + "' ORDER BY dias");
  while (curPlazos.next()) {
    if (curPlazos.at() == (curPlazos.size() - 1)) {
      importeRecibo = parseFloat(total) - parseFloat(importeAcumulado);
    } else {
      importeRecibo = (parseFloat(total) * parseFloat(curPlazos.valueBuffer("aplazado"))) / 100;
    }
    importeRecibo = util.roundFieldValue(importeRecibo, "recibosprov", "importe");
    importeAcumulado = parseFloat(importeAcumulado) + parseFloat(importeRecibo);

    importeEuros = importeRecibo * tasaConv;
    diasAplazado = curPlazos.valueBuffer("dias");

    with(this.iface.curReciboProv) {
      setModeAccess(Insert);
      refreshBuffer();
      setValueBuffer("numero", numRecibo);
      setValueBuffer("idfactura", idFactura);
      setValueBuffer("importe", importeRecibo);
      setValueBuffer("texto", util.enLetraMoneda(importeRecibo, divisa));
      setValueBuffer("importeeuros", importeEuros);
      setValueBuffer("coddivisa", cursor.valueBuffer("coddivisa"));
      setValueBuffer("codigo", cursor.valueBuffer("codigo") + "-" + flfacturac.iface.pub_cerosIzquierda(numRecibo, 2));
      setValueBuffer("codproveedor", codProveedor);
      setValueBuffer("nombreproveedor", cursor.valueBuffer("nombre"));
      setValueBuffer("cifnif", cursor.valueBuffer("cifnif"));
      setValueBuffer("estado", emitirComo);

      if (datosCuentaDom.error == 0) {
        setValueBuffer("codcuenta", datosCuentaDom.codcuenta);
        setValueBuffer("descripcion", datosCuentaDom.descripcion);
        setValueBuffer("ctaentidad", datosCuentaDom.ctaentidad);
        setValueBuffer("ctaagencia", datosCuentaDom.ctaagencia);
        setValueBuffer("cuenta", datosCuentaDom.cuenta);
        setValueBuffer("dc", datosCuentaDom.dc);
      }
    }

    this.iface.curReciboProv.setValueBuffer("codcuentapagoprov", formRecordrecibosprov.iface.pub_commonCalculateField("codcuentapagoprov", this.iface.curReciboProv));
    this.iface.curReciboProv.setValueBuffer("fecha", this.iface.dameFechaEmisionProv(cursor));

    if (codProveedor && codProveedor != "") {
      var qryDir = new FLSqlQuery;
      with(qryDir) {
        setTablesList("dirproveedores");
        setSelect("id, direccion, ciudad, codpostal, provincia, codpais");
        setFrom("dirproveedores");
        setWhere("codproveedor = '" + codProveedor + "' AND direccionppal = true");
        setForwardOnly(true);
      }
      if (!qryDir.exec())
        return false;
      if (qryDir.first()) {
        with(this.iface.curReciboProv) {
          setValueBuffer("coddir", qryDir.value("id"));
          setValueBuffer("direccion", qryDir.value("direccion"));
          setValueBuffer("ciudad", qryDir.value("ciudad"));
          setValueBuffer("codpostal", qryDir.value("codpostal"));
          setValueBuffer("provincia", qryDir.value("provincia"));
          setValueBuffer("codpais", qryDir.value("codpais"));
        }
      }
    }

    fechaVencimiento = this.iface.calcFechaVencimientoProv(cursor, numPlazo, diasAplazado);
    this.iface.curReciboProv.setValueBuffer("fechav", fechaVencimiento);

    if (!this.iface.datosReciboProv(cursor))
      return false;

    if (!this.iface.curReciboProv.commitBuffer())
      return false;

    if (emitirComo == "Pagado") {
      idRecibo = this.iface.curReciboProv.valueBuffer("idrecibo");

      this.iface.curPagoDevolProv_ = new FLSqlCursor("pagosdevolprov");
      with(this.iface.curPagoDevolProv_) {
        setModeAccess(Insert);
        refreshBuffer();
        setValueBuffer("idrecibo", idRecibo);
        setValueBuffer("tipo", "Pago");
        setValueBuffer("fecha", cursor.valueBuffer("fecha"));
        setValueBuffer("codcuenta", codCuentaEmp);
        setValueBuffer("descripcion", desCuentaEmp);
        setValueBuffer("ctaentidad", ctaEntidadEmp);
        setValueBuffer("ctaagencia", ctaAgenciaEmp);
        setValueBuffer("dc", dCEmp);
        setValueBuffer("cuenta", cuentaEmp);
        setValueBuffer("codsubcuenta", codSubcuentaEmp);
        setValueBuffer("idSubcuenta", idSubcuentaEmp);
        setValueBuffer("tasaconv", cursor.valueBuffer("tasaconv"));
      }
      if (!this.iface.datosPagoDevolProv(cursor)) {
        return false;
      }
      if (!this.iface.curPagoDevolProv_.commitBuffer()) {
        return false;
      }
      if (!this.iface.actualizarTotalesReciboProv(idRecibo)) {
        return false;
      }
    }
    numRecibo++;
  }

  if (emitirComo == "Pagado") {
    if (!this.iface.calcularEstadoFacturaProv(false, idFactura))
      return false;
  }

  return true;
}

/** \C Se elimina, si es posible, el asiento contable asociado al pago o devolución
\end */
function proveed_afterCommit_pagosdevolprov(curPD: FLSqlCursor)
{
  var _i = this.iface;
  var idRecibo = curPD.valueBuffer("idrecibo");

  /** \C Se cambia el pago anterior al actual para que sólo el último sea editable
  \end */
  switch (curPD.modeAccess()) {
    case curPD.Insert:
    case curPD.Edit: {
      if (!this.iface.cambiaUltimoPagoProv(idRecibo, curPD.valueBuffer("idpagodevol"), false))
        return false;
      break;
    }
    case curPD.Del: {
      if (!this.iface.cambiaUltimoPagoProv(idRecibo, curPD.valueBuffer("idpagodevol"), true))
        return false;
      break;
    }
  }

  if (!this.iface.calcularEstadoFacturaProv(idRecibo))
    return false;

  var util = new FLUtil();
  if (sys.isLoadedModule("flcontppal") == false || util.sqlSelect("empresa", "contintegrada", "1 = 1") == false)
    return true;

  switch (curPD.modeAccess()) {
    case curPD.Del: {
      if (curPD.isNull("idasiento"))
        return true;

      var idAsiento = curPD.valueBuffer("idasiento");
      if (flfacturac.iface.pub_asientoBorrable(idAsiento) == false)
        return false;

      var curAsiento = new FLSqlCursor("co_asientos");
      curAsiento.select("idasiento = " + idAsiento);
      if (curAsiento.first()) {
        curAsiento.setUnLock("editable", true);
        curAsiento.setModeAccess(curAsiento.Del);
        curAsiento.refreshBuffer();
        if (!curAsiento.commitBuffer())
          return false;
      }
      break;
    }
    case curPD.Edit: {
      if (curPD.valueBuffer("nogenerarasiento")) {
        var idAsientoAnterior = curPD.valueBufferCopy("idasiento");
        if (idAsientoAnterior && idAsientoAnterior != "") {
          if (!flfacturac.iface.pub_eliminarAsiento(idAsientoAnterior))
            return false;
        }
      }
      break;
    }
  }
  return true;
}

/** \C Se regenera, si es posible, el asiento contable asociado al pago o devolución
\end */
function proveed_beforeCommit_pagosdevolprov(curPD: FLSqlCursor)
{
  var util = new FLUtil();
  if (sys.isLoadedModule("flcontppal") && util.sqlSelect("empresa", "contintegrada", "1 = 1") && !curPD.valueBuffer("nogenerarasiento")) {
    if (!this.iface.generarAsientoPagoDevolProv(curPD))
      return false;
  }
  return true;
}

function proveed_generarAsientoPagoDevolProv(curPD)
{
  var _i = this.iface;
  var util = new FLUtil();
  if (curPD.modeAccess() != curPD.Insert && curPD.modeAccess() != curPD.Edit)
    return true;

  if (curPD.valueBuffer("nogenerarasiento")) {
    curPD.setNull("idasiento");
    return true;
  }

  var codEjercicio = flfactppal.iface.pub_ejercicioActual();
  var datosDoc = flfacturac.iface.pub_datosDocFacturacion(curPD.valueBuffer("fecha"), codEjercicio, "pagosdevolprov");
  if (!datosDoc.ok)
    return false;
  if (datosDoc.modificaciones == true) {
    codEjercicio = datosDoc.codEjercicio;
    curPD.setValueBuffer("fecha", datosDoc.fecha);
  }

  var datosAsiento = [];
  var valoresDefecto: Array;
  valoresDefecto["codejercicio"] = codEjercicio;
  valoresDefecto["coddivisa"] = util.sqlSelect("empresa", "coddivisa", "1 = 1");

  var curTransaccion = new FLSqlCursor("empresa");
  curTransaccion.transaction(false);
  try {
    datosAsiento = flfacturac.iface.pub_regenerarAsiento(curPD, valoresDefecto);
    if (datosAsiento.error == true) {
      throw util.translate("scripts", "Error al regenerar el asiento");
    }
    switch (curPD.valueBuffer("tipo")) {
      case "Pago": {
        debug("PD es pago");
        debug("nada dif " + _i.pagoDiferidoRemesasProv() + " indi " + _i.pagoIndirectoRemesasProv());
        //      if (curPD.valueBuffer("idremesa") && _i.pagoDiferidoRemesasProv() && !_i.pagoIndirectoRemesasProv(curPD)) {
        //        /// El asiento se genera por pago de remesa, no por pago de recibo.
        //        curPD.setNull("idasiento"); /// para remesas a medio al hacer el cambio en programación de generación de asiento de pago por pago a pago por remesa
        //      } else {
        var recibo = flfactppal.iface.pub_ejecutarQry("recibosprov", "coddivisa,importe,importeeuros,idfactura,codigo,nombreproveedor,codproveedor", "idrecibo = " + curPD.valueBuffer("idrecibo"));
        if (recibo.result != 1) {
          throw util.translate("scripts", "Error al obtener los datos del recibo");
        }
        if (!this.iface.generarPartidasProv(curPD, valoresDefecto, datosAsiento, recibo)) {
          throw util.translate("scripts", "Error al obtener la partida de proveedor");
        }
        if (!this.iface.generarPartidasBancoProv(curPD, valoresDefecto, datosAsiento, recibo)) {
          throw util.translate("scripts", "Error al obtener la partida de banco");
        }
        if (!this.iface.generarPartidasCambioProv(curPD, valoresDefecto, datosAsiento, recibo)) {
          throw util.translate("scripts", "Error al obtener la partida de diferencias por cambio");
        }
        break;
      }
      case "Remesado": { /// El asiento, si existe, será borrado en el aftercommit
        curPD.setNull("idasiento");
        break;
      }
      case "Devuelto": {
        /** \D En el caso de dar una devolución, las subcuentas del asiento contable serán las inversas al asiento contable correspondiente al último pago
        \end */
        var idAsientoPago = util.sqlSelect("pagosdevolprov", "idasiento", "idrecibo = " + curPD.valueBuffer("idrecibo") + " AND  tipo = 'Pago' ORDER BY fecha DESC");
        if (this.iface.generarAsientoInverso(datosAsiento.idasiento, idAsientoPago, datosAsiento.concepto, valoresDefecto.codejercicio) == false) {
          throw util.translate("scripts", "Error al generar el asiento inverso al pago");
        }
        break;
      }
    }

    curPD.setValueBuffer("idasiento", datosAsiento.idasiento);

    if (!flcontppal.iface.pub_comprobarAsiento(datosAsiento.idasiento)) {
      throw util.translate("scripts", "Error al comprobar el asiento");
    }
  } catch (e) {
    curTransaccion.rollback();
    var codRecibo = util.sqlSelect("recibosprov", "codigo", "idrecibo = " + curPD.valueBuffer("idrecibo"));
    MessageBox.warning(util.translate("scripts", "Error al generar el asiento correspondiente a %1 del recibo %2:").arg(curPD.valueBuffer("tipo")).arg(codRecibo) + "\n" + e, MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  curTransaccion.commit();

  return true;
}

function proveed_dameSubcuentaProvPD(curPD, valoresDefecto, datosAsiento, recibo)
{
  var _i = this.iface;
  /** \C La cuenta del debe del asiento de pago será la misma cuenta de tipo PROVEE que se usó para realizar el asiento de la correspondiente factura
  \end */
  var ctaDebe = [];
  var idAsientoFactura = AQUtil.sqlSelect("recibosprov r INNER JOIN facturasprov f" + " ON r.idfactura = f.idfactura", "f.idasiento", "r.idrecibo = " + curPD.valueBuffer("idrecibo"), "facturasprov,recibosprov");
  if (!idAsientoFactura) {
    codEjercicioFac = false;
  } else {
    codEjercicioFac = AQUtil.sqlSelect("co_asientos", "codejercicio", "idasiento = " + idAsientoFactura);
  }
  var codProveedor = AQUtil.sqlSelect("recibosprov", "codproveedor", "idrecibo = " + curPD.valueBuffer("idrecibo"));
  if (codEjercicioFac == valoresDefecto.codejercicio) {
    ctaDebe.codsubcuenta = AQUtil.sqlSelect("co_subcuentasprov", "codsubcuenta", "codproveedor = '" + codProveedor + "' AND codejercicio = '" + codEjercicioFac + "'");
    if (!ctaDebe.codsubcuenta) {
      ctaDebe.codsubcuenta = AQUtil.sqlSelect("co_partidas p INNER JOIN co_subcuentas s ON p.idsubcuenta = s.idsubcuenta INNER JOIN co_cuentas c ON c.idcuenta = s.idcuenta", "s.codsubcuenta", "p.idasiento = " + idAsientoFactura + " AND c.idcuentaesp = 'PROVEE'", "co_partidas,co_subcuentas,co_cuentas");
    } else {
      ctaDebe.codsubcuenta = AQUtil.sqlSelect("co_partidas p INNER JOIN co_subcuentas s ON p.idsubcuenta = s.idsubcuenta", "s.codsubcuenta", "p.idasiento = " + idAsientoFactura + " AND s.codsubcuenta = '" + ctaDebe.codsubcuenta + "'", "co_partidas,co_subcuentas");
    }
    if (!ctaDebe.codsubcuenta) {
      MessageBox.warning(sys.translate("No se ha encontrado la subcuenta de proveedor del asiento contable correspondiente a la factura a pagar"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
      return false;
    }
  } else {
    if (codProveedor && codProveedor != "") {
      ctaDebe.codsubcuenta = AQUtil.sqlSelect("co_subcuentasprov", "codsubcuenta", "codproveedor = '" + codProveedor + "' AND codejercicio = '" + valoresDefecto.codejercicio + "'");
      if (!ctaDebe.codsubcuenta) {
        MessageBox.warning(sys.translate("El proveedor %1 no tiene definida ninguna subcuenta en el ejercicio %2.\nEspecifique la subcuenta en la pestaña de contabilidad del formulario de proveedores").arg(codProveedor).arg(valoresDefecto.codejercicio), MessageBox.Ok, MessageBox.NoButton);
        return false;
      }
    } else {
      ctaDebe = flfacturac.iface.pub_datosCtaEspecial("PROVEE", valoresDefecto.codejercicio);
      if (!ctaDebe.codsubcuenta) {
        MessageBox.warning(sys.translate("No tiene definida ninguna cuenta de tipo PROVEE.\nDebe crear este tipo especial y asociarlo a una cuenta\nen el módulo principal de contabilidad"), MessageBox.Ok, MessageBox.NoButton);
        return false;
      }
    }
  }

  ctaDebe.idsubcuenta = AQUtil.sqlSelect("co_subcuentas", "idsubcuenta", "codsubcuenta = '" + ctaDebe.codsubcuenta +  "' AND codejercicio = '" + valoresDefecto.codejercicio + "'");
  if (!ctaDebe.idsubcuenta) {
    MessageBox.warning(sys.translate("No existe la subcuenta %1 correspondiente al ejercicio %2.\nPara poder realizar el pago debe crear antes esta subcuenta."), arg(ctaDebe.codsubcuenta).arg(valoresDefecto.codejercicio), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton, "AbanQ");
    return false;
  }
  return ctaDebe;
}

/** \D Genera la partida correspondiente al proveedor del asiento de pago
@param  curPD: Cursor del pago o devolución
@param  valoresDefecto: Array de valores por defecto (ejercicio, divisa, etc.)
@param  datosAsiento: Array con los datos del asiento
@param  recibo: Array con los datos del recibo asociado al pago
@return true si la generación es correcta, false en caso contrario
\end */
function proveed_generarPartidasProv(curPD: FLSqlCursor, valoresDefecto: Array, datosAsiento: Array, recibo: Array)
{
  var _i = this.iface;
  var util = new FLUtil();
  var codEjercicioFac: String;

  var ctaDebe = _i.dameSubcuentaProvPD(curPD, valoresDefecto, datosAsiento, recibo);
  if (!ctaDebe) {
    return false;
  }

  var debe = 0;
  var debeME = 0;
  var tasaconvDebe = 1;

  if (valoresDefecto.coddivisa == recibo.coddivisa) {
    debe = parseFloat(recibo.importe);
    debeME = 0;
  } else {
    tasaconvDebe = util.sqlSelect("recibosprov r INNER JOIN facturasprov f ON r.idfactura = f.idfactura ", "tasaconv", "idrecibo = " + curPD.valueBuffer("idrecibo"), "recibosprov,facturasprov");
    debe = parseFloat(recibo.importeeuros);
    debeME = parseFloat(recibo.importe);
  }

  debe = util.roundFieldValue(debe, "co_partidas", "debe");
  debeME = util.roundFieldValue(debeME, "co_partidas", "debeme");
  var esAbono = util.sqlSelect("recibosprov r INNER JOIN facturasprov f ON r.idfactura = f.idfactura", "deabono", "idrecibo = " + curPD.valueBuffer("idrecibo"), "recibosprov,facturasprov");

  var curPartida = new FLSqlCursor("co_partidas");
  with(curPartida) {
    setModeAccess(curPartida.Insert);
    refreshBuffer();
    try {
      setValueBuffer("concepto", datosAsiento.concepto);
    } catch (e) {
      setValueBuffer("concepto", curPD.valueBuffer("tipo") + " recibo prov. " + recibo.codigo + " - " + recibo.nombreproveedor);
    }
    setValueBuffer("idsubcuenta", ctaDebe.idsubcuenta);
    setValueBuffer("codsubcuenta", ctaDebe.codsubcuenta);
    setValueBuffer("idasiento", datosAsiento.idasiento);
    if (esAbono) {
      setValueBuffer("debe", 0);
      setValueBuffer("haber", debe * -1);
    } else {
      setValueBuffer("debe", debe);
      setValueBuffer("haber", 0);
    }
    setValueBuffer("coddivisa", recibo.coddivisa);
    setValueBuffer("tasaconv", tasaconvDebe);
    setValueBuffer("debeME", debeME);
    setValueBuffer("haberME", 0);
  }
  if (!curPartida.commitBuffer())
    return false;

  return true;
}

function proveed_generarPartidasBancoProv(curPD: FLSqlCursor, valoresDefecto: Array, datosAsiento: Array, recibo: Array)
{
  var util = new FLUtil();
  var ctaHaber = [];

  ctaHaber.codsubcuenta = curPD.valueBuffer("codsubcuenta");
  ctaHaber.idsubcuenta = util.sqlSelect("co_subcuentas", "idsubcuenta", "codsubcuenta = '" + ctaHaber.codsubcuenta + "' AND codejercicio = '" + valoresDefecto.codejercicio + "'");
  if (!ctaHaber.idsubcuenta) {
    MessageBox.warning(util.translate("scripts", "No tiene definida la subcuenta %1 en el ejercicio %2.\nAntes de dar el pago debe crear la subcuenta o modificar el ejercicio").arg(ctaHaber.codsubcuenta).arg(valoresDefecto.codejercicio), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }

  var haber = 0;
  var haberME = 0;
  var tasaconvHaber = 1;

  if (valoresDefecto.coddivisa == recibo.coddivisa) {
    haber = parseFloat(recibo.importe);
    haberMe = 0;
  } else {
    tasaconvHaber = curPD.valueBuffer("tasaconv");
    haber = parseFloat(recibo.importe) * parseFloat(tasaconvHaber);
    haberME = parseFloat(recibo.importe);
  }
  haber = util.roundFieldValue(haber, "co_partidas", "haber");
  haberME = util.roundFieldValue(haberME, "co_partidas", "haberme");

  var esAbono = util.sqlSelect("recibosprov r INNER JOIN facturasprov f ON r.idfactura = f.idfactura", "deabono", "idrecibo = " + curPD.valueBuffer("idrecibo"), "recibosprov,facturasprov");

  var curPartida = new FLSqlCursor("co_partidas");
  with(curPartida) {
    setModeAccess(curPartida.Insert);
    refreshBuffer();
    try {
      setValueBuffer("concepto", datosAsiento.concepto);
    } catch (e) {
      setValueBuffer("concepto", curPD.valueBuffer("tipo") + " recibo prov. " + recibo.codigo + " - " + recibo.nombreproveedor);
    }
    setValueBuffer("idsubcuenta", ctaHaber.idsubcuenta);
    setValueBuffer("codsubcuenta", ctaHaber.codsubcuenta);
    setValueBuffer("idasiento", datosAsiento.idasiento);
    if (esAbono) {
      setValueBuffer("debe", haber * -1);
      setValueBuffer("haber", 0);
    } else {
      setValueBuffer("debe", 0);
      setValueBuffer("haber", haber);
    }
    setValueBuffer("coddivisa", recibo.coddivisa);
    setValueBuffer("tasaconv", tasaconvHaber);
    setValueBuffer("debeME", 0);
    setValueBuffer("haberME", haberME);
  }
  if (!curPartida.commitBuffer())
    return false;

  return true;
}

/** \D Genera, si es necesario, la partida de diferecias positivas o negativas de cambio
@param  curPD: Cursor del pago o devolución
@param  valoresDefecto: Array de valores por defecto (ejercicio, divisa, etc.)
@param  datosAsiento: Array con los datos del asiento
@param  recibo: Array con los datos del recibo asociado al pago
@return true si la generación es correcta, false en caso contrario
\end */
function proveed_generarPartidasCambioProv(curPD: FLSqlCursor, valoresDefecto: Array, datosAsiento: Array, recibo: Array)
{
  /** \C En el caso de que la divisa sea extranjera y la tasa de cambio haya variado desde el momento de la emisión de la factura, la diferencia se imputará a la correspondiente cuenta de diferencias de cambio.
  \end */
  if (valoresDefecto.coddivisa == recibo.coddivisa)
    return true;

  var util = new FLUtil();
  var debe = 0;
  var haber = 0;
  var tasaconvDebe = 1;
  var tasaconvHaber = 1;
  var diferenciaCambio = 0;


  tasaconvHaber = curPD.valueBuffer("tasaconv");
  tasaconvDebe = util.sqlSelect("recibosprov r INNER JOIN facturasprov f ON r.idfactura = f.idfactura ", "tasaconv", "idrecibo = " + curPD.valueBuffer("idrecibo"), "recibosprov,facturasprov");
  haber = parseFloat(recibo.importe) * parseFloat(tasaconvHaber);
  haber = util.roundFieldValue(haber, "co_partidas", "haber");

  debe = parseFloat(recibo.importeeuros);
  debe = util.roundFieldValue(debe, "co_partidas", "debe");
  diferenciaCambio = debe - haber;
  if (util.buildNumber(diferenciaCambio, "f", 2) == "0.00" || util.buildNumber(diferenciaCambio, "f", 2) == "-0.00") {
    diferenciaCambio = 0;
    return true;
  }
  diferenciaCambio = util.roundFieldValue(diferenciaCambio, "co_partidas", "haber");

  var ctaDifCambio = [];
  var debeDifCambio = 0;
  var haberDifCambio = 0;
  if (diferenciaCambio > 0) {
    ctaDifCambio = flfacturac.iface.pub_datosCtaEspecial("CAMPOS", valoresDefecto.codejercicio);
    if (ctaDifCambio.error != 0)
      return false;
    debeDifCambio = 0;
    haberDifCambio = diferenciaCambio;
  } else {
    ctaDifCambio = flfacturac.iface.pub_datosCtaEspecial("CAMNEG", valoresDefecto.codejercicio);
    if (ctaDifCambio.error != 0)
      return false;
    diferenciaCambio = 0 - diferenciaCambio;
    debeDifCambio = diferenciaCambio;
    haberDifCambio = 0;
  }

  /// Esto lo usan algunas extensiones
  if (curPD.valueBuffer("tipo") == "Devolución") {
    var aux = debeDifCambio;
    debeDifCambio = haberDifCambio;
    haberDifCambio = aux;
  }

  var curPartida = new FLSqlCursor("co_partidas");
  with(curPartida) {
    setModeAccess(curPartida.Insert);
    refreshBuffer();
    try {
      setValueBuffer("concepto", datosAsiento.concepto);
    } catch (e) {
      setValueBuffer("concepto", curPD.valueBuffer("tipo") + " recibo prov. " + recibo.codigo + " - " + recibo.nombreproveedor);
    }
    setValueBuffer("idsubcuenta", ctaDifCambio.idsubcuenta);
    setValueBuffer("codsubcuenta", ctaDifCambio.codsubcuenta);
    setValueBuffer("idasiento", datosAsiento.idasiento);
    setValueBuffer("debe", debeDifCambio);
    setValueBuffer("haber", haberDifCambio);
    setValueBuffer("coddivisa", valoresDefecto.coddivisa);
    setValueBuffer("tasaconv", 1);
    setValueBuffer("debeME", 0);
    setValueBuffer("haberME", 0);
  }
  if (!curPartida.commitBuffer())
    return false;

  return true;
}

/** \D Calcula la fecha de vencimiento de un recibo de proveedor, como la fecha de facturación más los días del plazo correspondiente
@param curFactura: Cursor posicionado en el registro de facturas correspondiente a la factura
@param numPlazo: Número del plazo actual
@param diasAplazado: Días de aplazamiento del pago
@return Fecha de vencimiento
\end */
function proveed_calcFechaVencimientoProv(curFactura, numPlazo, diasAplazado)
{
  var util = new FLUtil;
  var fechaEmision = this.iface.dameFechaEmisionProv(curFactura);
  return util.addDays(fechaEmision, diasAplazado);
}

function proveed_dameFechaEmisionProv(curFactura)
{
  return curFactura.valueBuffer("fecha");
}

/* \D Función para sobrecargar. Sirve para añadir al cursor del recibo los datos que añada la extensión
\end */
function proveed_datosReciboProv(curFactura)
{
  return true;
}

/** \D Cambia la el estado del último pago anterior al especificado, de forma que se mantenga como único pago editable el último de todos
@param  idRecibo: Identificador del recibo al que pertenecen los pagos tratados
@param  idPagoDevol: Identificador del pago que ha cambiado
@param  unlock: Indicador de si el últim pago debe ser editable o no
@return true si la verificación del estado es correcta, false en caso contrario
\end */
function proveed_cambiaUltimoPagoProv(idRecibo: String, idPagoDevol: String, unlock: Boolean)
{
  var curPagosDevol = new FLSqlCursor("pagosdevolprov");
  curPagosDevol.select("idrecibo = " + idRecibo + " AND idpagodevol <> " + idPagoDevol + " ORDER BY fecha, idpagodevol");
  if (curPagosDevol.last())
    curPagosDevol.setUnLock("editable", unlock);

  return true;
}

/** \D Cambia la factura relacionada con un recibo a editable o no editable en función de si tiene pagos asociados o no
@param  idRecibo: Identificador de un recibo asociado a la factura
@param  idFactura: Identificador de la factura
@return true si la verificación del estado es correcta, false en caso contrario
\end */
function proveed_calcularEstadoFacturaProv(idRecibo: String, idFactura: String)
{
  var util = new FLUtil();
  if (!idFactura)
    idFactura = util.sqlSelect("recibosprov", "idfactura", "idrecibo = " + idRecibo);

  var qryPagos = new FLSqlQuery();
  qryPagos.setTablesList("recibosprov,pagosdevolprov");
  qryPagos.setSelect("p.idpagodevol");
  qryPagos.setFrom("recibosprov r INNER JOIN pagosdevolprov p ON r.idrecibo = p.idrecibo");
  qryPagos.setWhere("r.idfactura = " + idFactura);
  try {
    qryPagos.setForwardOnly(true);
  } catch (e) {}
  if (!qryPagos.exec())
    return false;

  var curFactura = new FLSqlCursor("facturasprov");
  curFactura.select("idfactura = " + idFactura);
  curFactura.first();
  if (qryPagos.size() == 0)
    curFactura.setUnLock("editable", true);
  else
    curFactura.setUnLock("editable", false);
  return true
}

       /* \D Borra los recibos asociados a una factura.

       @param idFactura: Identificador de la factura de la que provienen los recibos
       @return False si hay error o si el recibo no se puede borrar, true si los recibos se borran correctamente
       \end */
       function proveed_borrarRecibosProv(idFactura: Number)
{
  var curRecibos = new FLSqlCursor("recibosprov");
  curRecibos.select("idfactura = " + idFactura);
  while (curRecibos.next()) {
    curRecibos.setModeAccess(curRecibos.Browse);
    curRecibos.refreshBuffer();
    if (this.iface.tienePagosDevProv(curRecibos.valueBuffer("idrecibo"))) {
      return false;
    }
  }
  curRecibos.select("idfactura = " + idFactura);
  while (curRecibos.next()) {
    curRecibos.setModeAccess(curRecibos.Del);
    curRecibos.refreshBuffer();
    if (!curRecibos.commitBuffer())
      return false;
  }
  return true;
}

/** Para sobrecargar en extensiones
*/
function proveed_codCuentaPagoProv(curFactura: FLSqlCursor)
{
  return "";
}

function provee_siGenerarRecibosProv(curFactura: FLSqlCursor, masCampos: Array)
{
  var camposAcomprobar = new Array("codproveedor", "total", "codpago", "fecha");

  for (var i = 0; i < camposAcomprobar.length; i++)
    if (curFactura.valueBuffer(camposAcomprobar[i]) != curFactura.valueBufferCopy(camposAcomprobar[i]))
      return true;

  if (masCampos) {
    for (i = 0; i < masCampos.length; i++)
      if (curFactura.valueBuffer(masCampos[i]) != curFactura.valueBufferCopy(masCampos[i]))
        return true;
  }

  return false;
}

/** \D Obtiene los datos de la cuenta de domiciliación de un proveedor

@param codProveedor: Identificador del cliente
@return Array con los datos de la cuenta o false si no existe o hay un error. Los elementos de este array son:
  descripcion: Descripcion de la cuenta
  ctaentidad: Código de entidad bancaria
  ctaagencia: Código de oficina
  cuenta: Número de cuenta
  dc: Dígitos de control
  codcuenta: Código de la cuenta en la tabla de cuentas
  error: 0.Sin error 1.Datos no encontrados 2.Error
\end */
function provee_obtenerDatosCuentaDomProv(codProveedor: String)
{
  var datosCuentaDom = [];
  var util = new FLUtil;
  var domiciliarEn = util.sqlSelect("proveedores", "codcuentadom", "codproveedor= '" + codProveedor + "'");

  if (domiciliarEn != "") {
    datosCuentaDom = flfactppal.iface.pub_ejecutarQry("cuentasbcopro", "descripcion,ctaentidad,ctaagencia,cuenta,codcuenta", "codcuenta = '" + domiciliarEn + "'");
    switch (datosCuentaDom.result) {
      case -1:
        datosCuentaDom.error = 1;
        break;
      case 0:
        datosCuentaDom.error = 2;
        break;
      case 1:
        datosCuentaDom.dc = util.calcularDC(datosCuentaDom.ctaentidad + datosCuentaDom.ctaagencia) + util.calcularDC(datosCuentaDom.cuenta);
        datosCuentaDom.error = 0;
        break;
    }
  } else {
    datosCuentaDom.error = 1;
  }

  return datosCuentaDom;
}

function provee_datosPagoDevolProv(curFactura)
{
  return true;
}

function provee_totalesReciboProv()
{
  this.iface.curReciboProv.setValueBuffer("fechapago", formRecordrecibosprov.iface.pub_commonCalculateField("fechapago", this.iface.curReciboProv));
  this.iface.curReciboProv.setValueBuffer("codcuentapagoprov", formRecordrecibosprov.iface.pub_commonCalculateField("codcuentapagoprov", this.iface.curReciboProv));
  return true;
}

function provee_actualizarTotalesReciboProv(idRecibo)
{
  debug("ACt totales");
  this.iface.curReciboProv = new FLSqlCursor("recibosprov");
  this.iface.curReciboProv.select("idrecibo = " + idRecibo);
  if (!this.iface.curReciboProv.first()) {
    return false;
  }
  this.iface.curReciboProv.setModeAccess(this.iface.curReciboProv.Edit);
  this.iface.curReciboProv.refreshBuffer();
  if (!this.iface.totalesReciboProv()) {
    return false;
  }
  if (!this.iface.curReciboProv.commitBuffer()) {
    return false;
  }
  return true;
}

function provee_pagoIndirectoRemesasProv()
{
  var _i = this.iface;
  if (_i.pagoIndirectoRemProv_ == undefined) {
    _i.cargaValoresDefecto();
    if (_i.pagoIndirectoRemProv_ == undefined) {
      MessageBox.critical(sys.translate("Error al obtener los valores por defecto del módulo de tesorería"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton, "AbanQ");
      return false;
    }
  }
  return _i.pagoIndirectoRemProv_;
}

function provee_pagoDiferidoRemesasProv()
{
  var _i = this.iface;
  if (_i.pagoDiferidoRemProv_ == undefined) {
    _i.cargaValoresDefecto();
    if (_i.pagoDiferidoRemProv_ == undefined) {
      MessageBox.critical(sys.translate("Error al obtener los valores por defecto del módulo de tesorería"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton, "AbanQ");
      return false;
    }
  }
  return _i.pagoDiferidoRemProv_;
}

function provee_cargaValoresDefecto()
{
  var _i = this.iface;
  _i.__cargaValoresDefecto();
  /// Se obtienen en la extensión de remesas_prov
  _i.pagoIndirectoRemProv_ = false;
  _i.pagoDiferidoRemProv_ = false;
}

//// PROVEED ////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////