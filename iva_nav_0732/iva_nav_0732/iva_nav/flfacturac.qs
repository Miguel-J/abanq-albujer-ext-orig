
/** @class_declaration ivaNav */
/////////////////////////////////////////////////////////////////
//// IVA NAV ////////////////////////////////////////////////////
class ivaNav extends cambioIva
{
  function ivaNav(context)
  {
    cambioIva(context);
  }
  function generarPartidasIVACli(curFactura, idAsiento, valoresDefecto, ctaCliente)
  {
    return this.ctx.ivaNav_generarPartidasIVACli(curFactura, idAsiento, valoresDefecto, ctaCliente);
  }
  function generarPartidasIVAProv(curFactura, idAsiento, valoresDefecto, ctaProveedor, concepto)
  {
    return this.ctx.ivaNav_generarPartidasIVAProv(curFactura, idAsiento, valoresDefecto, ctaProveedor, concepto);
  }
  function dameDatosIvaVenta(codGrupoIvaNeg, codImpuesto, codEjercicio)
  {
    return this.ctx.ivaNav_dameDatosIvaVenta(codGrupoIvaNeg, codImpuesto, codEjercicio);
  }
  function dameDatosIvaCompra(codGrupoIvaNeg, codImpuesto, codEjercicio)
  {
    return this.ctx.ivaNav_dameDatosIvaCompra(codGrupoIvaNeg, codImpuesto, codEjercicio);
  }
  function validarIvaRecargoCliente(codCliente, id, tabla, identificador)
  {
    return this.ctx.ivaNav_validarIvaRecargoCliente(codCliente, id, tabla, identificador);
  }
  function validarIvaRecargoProveedor(codProveedor, id, tabla, identificador)
  {
    return this.ctx.ivaNav_validarIvaRecargoProveedor(codProveedor, id, tabla, identificador);
  }
  function campoImpuesto(campo, codImpuesto, fecha, cliProv, codGrupoIvaNeg)
  {
    return this.ctx.ivaNav_campoImpuesto(campo, codImpuesto, fecha, cliProv, codGrupoIvaNeg);
  }
  function actualizarIvaLineasFecha(tabla, nombrePK, valorClave, fecha, codGrupoIvaNeg)
  {
    return this.ctx.ivaNav_actualizarIvaLineasFecha(tabla, nombrePK, valorClave, fecha, codGrupoIvaNeg);
  }
  function validarIvas(curDoc)
  {
    return this.ctx.ivaNav_validarIvas(curDoc);
  }
  function habilitaPorIva(miForm)
  {
    return this.ctx.ivaNav_habilitaPorIva(miForm);
  }
}
//// IVA NAV ////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pubIvaNav */
/////////////////////////////////////////////////////////////////
//// PUB IVA NAV ////////////////////////////////////////////////
class pubIvaNav extends ifaceCtx
{
  function pubIvaNav(context)
  {
    ifaceCtx(context);
  }
  function pub_campoImpuesto(campo, codImpuesto, fecha, cliProv, codGrupoIvaNeg)
  {
    return this.campoImpuesto(campo, codImpuesto, fecha, cliProv, codGrupoIvaNeg);
  }
  function pub_habilitaPorIva(miForm)
  {
    return this.habilitaPorIva(miForm);
  }
}
//// PUB IVA NAV ////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition ivaNav */
/////////////////////////////////////////////////////////////////
//// IVA NAV ////////////////////////////////////////////////////
function ivaNav_validarIvas(curDoc)
{
  var _i = this.iface;
  var util = new FLUtil;
  var tabla = curDoc.table();
  var nombrePK = curDoc.primaryKey();
  var valorClave = curDoc.valueBuffer(nombrePK);
  var tablaLineas;
  switch (tabla) {
    case "presupuestoscli": {
      tablaLineas = "lineaspresupuestoscli";
      break;
    }
    case "pedidoscli": {
      tablaLineas = "lineaspedidoscli";
      break;
    }
    case "albaranescli": {
      tablaLineas = "lineasalbaranescli";
      break;
    }
    case "facturascli": {
      tablaLineas = "lineasfacturascli";
      break;
    }
    case "pedidosprov": {
      tablaLineas = "lineaspedidosprov";
      break;
    }
    case "albaranesprov": {
      tablaLineas = "lineasalbaranesprov";
      break;
    }
    case "facturasprov": {
      tablaLineas = "lineasfacturasprov";
      break;
    }
    default: {
      return -1;
    }
  }
  var cliProv = (tabla == "pedidosprov" || tabla == "albaranesprov" || tabla == "facturasprov") ? "prov" : "cli";

  var qryLineas: FLSqlQuery = new FLSqlQuery();
  qryLineas.setTablesList(tablaLineas);
  qryLineas.setSelect("codimpuesto, iva, recargo");
  qryLineas.setFrom(tablaLineas);
  qryLineas.setWhere(nombrePK + " = " + valorClave + " GROUP BY codimpuesto, iva, recargo");
  qryLineas.setForwardOnly(true);
  if (!qryLineas.exec()) {
    return false;
  }
  var fecha = curDoc.valueBuffer("fecha");
  var codImpuesto, iva, recargo, valorActualIva, valorActualRecargo;
  var codGrupoIvaNeg = curDoc.valueBuffer("codgrupoivaneg");
  while (qryLineas.next()) {
    codImpuesto = qryLineas.value("codimpuesto");
    if (!codImpuesto || codImpuesto == "") {
      continue;
    }
    iva = qryLineas.value("iva");
    if (!isNaN(iva) && iva != 0) {
      valorActualIva = flfacturac.iface.pub_campoImpuesto("iva", codImpuesto, fecha, cliProv, codGrupoIvaNeg);
      if (valorActualIva != iva) {
        var res: Number = MessageBox.warning(sys.translate("Alguna de las líneas contiene un valor de IVA no adecuado a la fecha del documento.\n¿Desea recalcular automáticamente estos valores?"), MessageBox.Yes, MessageBox.No, MessageBox.Ignore);
        switch (res) {
          case MessageBox.Yes: {
            if (!_i.actualizarIvaLineasFecha(tablaLineas, nombrePK, valorClave, fecha, codGrupoIvaNeg)) {
              return -1;
            }
            return 1;
          }
          case MessageBox.No: {
            return -1;
          }
          case MessageBox.Ignore: {
            return 0;
          }
        }
      }
    }
    recargo = qryLineas.value("recargo");
    if (!isNaN(recargo) && recargo != 0) {
      valorActualRecargo = flfacturac.iface.pub_campoImpuesto("recargo", codImpuesto, fecha, cliProv, codGrupoIvaNeg);
      if (valorActualRecargo != recargo) {
        var res: Number = MessageBox.warning(sys.translate("Alguna de las líneas contiene un valor de Recargo de Equivalencia no adecuado a la fecha del documento.\n¿Desea recalcular automáticamente estos valores?"), MessageBox.Yes, MessageBox.No, MessageBox.Ignore);
        switch (res) {
          case MessageBox.Yes: {
            if (!_i.actualizarIvaLineasFecha(tablaLineas, nombrePK, valorClave, fecha, codGrupoIvaNeg)) {
              return -1;
            }
            return 1;
          }
          case MessageBox.No: {
            return -1;
          }
          case MessageBox.Ignore: {
            return 0;
          }
        }
      }
    }
  }

  return 0;
}

function ivaNav_actualizarIvaLineasFecha(tabla, nombrePK, valorClave, fecha, codGrupoIvaNeg)
{
  var _i = this.iface;
  if (_i.curLineaDoc_) {
    delete _i.curLineaDoc_;
  }
  var cliProv = (tabla == "lineaspedidosprov" || tabla == "lineasalbaranesprov" || tabla == "lineasfacturasprov") ? "prov" : "cli";

  _i.curLineaDoc_ = new FLSqlCursor(tabla);
  _i.curLineaDoc_.setActivatedCommitActions(false);
  _i.curLineaDoc_.setActivatedCheckIntegrity(false);
  _i.curLineaDoc_.select(nombrePK + " = " + valorClave);

  var codImpuesto, iva, recargo, valorActualIva, valorActualRecargo;
  var cambiado;
  while (_i.curLineaDoc_.next()) {
    cambiado = false;
    _i.curLineaDoc_.setModeAccess(_i.curLineaDoc_.Edit);
    _i.curLineaDoc_.refreshBuffer();
    codImpuesto = _i.curLineaDoc_.valueBuffer("codimpuesto");
    if (!codImpuesto || codImpuesto == "") {
      continue;
    }
    iva = _i.curLineaDoc_.valueBuffer("iva");
    if (!isNaN(iva) && iva != 0) {
      valorActualIva = flfacturac.iface.pub_campoImpuesto("iva", codImpuesto, fecha, cliProv, codGrupoIvaNeg);
      if (valorActualIva != iva) {
        _i.curLineaDoc_.setValueBuffer("iva", valorActualIva);
        cambiado = true;
      }
    }
    recargo = _i.curLineaDoc_.valueBuffer("recargo");
    if (!isNaN(recargo) && recargo != 0) {
      valorActualRecargo = flfacturac.iface.pub_campoImpuesto("recargo", codImpuesto, fecha, cliProv, codGrupoIvaNeg);
      if (valorActualRecargo != recargo) {
        _i.curLineaDoc_.setValueBuffer("recargo", valorActualRecargo);
        cambiado = true;
      }
    }
    if (cambiado) {
      if (!_i.datosLineaDocIva()) {
        return false;
      }
      if (!_i.curLineaDoc_.commitBuffer()) {
        return false;
      }
    }
  }
  return true;
}

function ivaNav_generarPartidasIVACli(curFactura, idAsiento, valoresDefecto, ctaCliente)
{
  var _i = this.iface;
  var haber = 0, haberME, baseImponible = 0;
  var codImpuesto, recargo, iva;
  debug(1);
  var codGrupoIvaNeg = curFactura.valueBuffer("codgrupoivaneg");

  var monedaSistema = (valoresDefecto.coddivisa == curFactura.valueBuffer("coddivisa"));
  var qryIva = new FLSqlQuery();
  qryIva.setTablesList("lineasivafactcli");
  qryIva.setSelect("neto, iva, totaliva, recargo, totalrecargo, codimpuesto");
  qryIva.setFrom("lineasivafactcli");
  qryIva.setWhere("idfactura = " + curFactura.valueBuffer("idfactura"));
  qryIva.setForwardOnly(true);
  if (!qryIva.exec()) {
    return false;
  }
  debug(2);
  while (qryIva.next()) {
    codImpuesto = qryIva.value("codimpuesto");
    iva = parseFloat(qryIva.value("iva"));
    iva = isNaN(iva) ? 0 : iva;
    recargo = parseFloat(qryIva.value("recargo"));
    recargo = isNaN(recargo) ? 0 : recargo;
    debug("codImpuesto " + codImpuesto);
    var datosIvaVenta = _i.dameDatosIvaVenta(codGrupoIvaNeg, codImpuesto, valoresDefecto.codejercicio);
    var textoError;
    if (datosIvaVenta.error != 0) {
      MessageBox.information(AQUtil.translate("scripts", "Error al obtener los datos de IVA asociados al grupo de IVA negocio %1 y producto %2.").arg(codGrupoIvaNeg).arg(codImpuesto), MessageBox.Ok, MessageBox.NoButton);
      return false;
    }
    //    if (datosIvaVenta.iva != iva || datosIvaVenta.recargo != recargo) {
    //      MessageBox.information(AQUtil.translate("scripts", "Error al obtener los datos de IVA asociados al grupo de IVA negocio %1 y producto %2. \nLos tipos de IVA y/o recargo no coinciden con los esperados").arg(codGrupoIvaNeg).arg(codImpuesto), MessageBox.Ok, MessageBox.NoButton);
    //      return false;
    //    }
    switch (datosIvaVenta.tipoCalculo) {
      case "Normal": {
        break;
      }
    }

    //    if ((datosIvaVenta.codSubcuentaRep == datosIvaVenta.codSubcuentaRec || !datosIvaVenta.codSubcuentaRec) && recargo != 0) {
    //      haber = parseFloat(qryIva.value("totaliva")) + parseFloat(qryIva.value("totalrecargo"));
    //      haberME = 0;
    //      baseImponible = parseFloat(qryIva.value("neto"));
    //    } else {
    haber = parseFloat(qryIva.value("totaliva"));
    haberME = 0;
    baseImponible = parseFloat(qryIva.value("neto"));
    //    }

    if (!monedaSistema) {
      haberME = haber;
      haber *= parseFloat(curFactura.valueBuffer("tasaconv"));
      baseImponible *= parseFloat(curFactura.valueBuffer("tasaconv"));
    }
    haber = AQUtil.roundFieldValue(haber, "co_partidas", "haber");
    haberME = AQUtil.roundFieldValue(haberME, "co_partidas", "haberme");
    baseImponible = AQUtil.roundFieldValue(baseImponible, "co_partidas", "baseimponible");

    var curPartida: FLSqlCursor = new FLSqlCursor("co_partidas");
    with(curPartida) {
      setModeAccess(curPartida.Insert);
      refreshBuffer();
      if (datosIvaVenta.idSubcuentaRep) {
        setValueBuffer("idsubcuenta", datosIvaVenta.idSubcuentaRep);
        setValueBuffer("codsubcuenta", datosIvaVenta.codSubcuentaRep);
      } else {
        if (parseFloat(haber) != 0) {
          debug("haber " + haber);
          return false;
        }
        setNull("idsubcuenta");
        setNull("codsubcuenta");
      }
      setValueBuffer("codgrupoivaneg", codGrupoIvaNeg);
      setValueBuffer("codimpuesto", codImpuesto);
      setValueBuffer("idasiento", idAsiento);
      setValueBuffer("debe", 0);
      setValueBuffer("haber", haber);
      setValueBuffer("baseimponible", baseImponible);
      setValueBuffer("iva", iva);
      setValueBuffer("recargo", 0);
      setValueBuffer("coddivisa", curFactura.valueBuffer("coddivisa"));
      setValueBuffer("tasaconv", curFactura.valueBuffer("tasaconv"));
      setValueBuffer("idcontrapartida", ctaCliente.idsubcuenta);
      setValueBuffer("codcontrapartida", ctaCliente.codsubcuenta);
      setValueBuffer("debeME", 0);
      setValueBuffer("haberME", haberME);
      setValueBuffer("codserie", curFactura.valueBuffer("codserie"));
      setValueBuffer("cifnif", curFactura.valueBuffer("cifnif"));
    }

    _i.datosPartidaFactura(curPartida, curFactura, "cliente")

    if (!curPartida.commitBuffer()) {
      debug("commit");
      return false;
    }

    //    if (datosIvaVenta.codSubcuentaRep != datosIvaVenta.codSubcuentaRec && datosIvaVenta.codSubcuentaRec && recargo != 0) {
    if (recargo != 0) {
      if (!datosIvaVenta.idSubcuentaRec) {
        MessageBox.warning(sys.translate("No hay una subcuenta de recargo de equivalencia definida para el grupo de IVA cliente %1 y el grupo de IVA producto %2").arg(codGrupoIvaNeg).arg(codImpuesto), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton, "AbanQ");
        return false;
      }
      haber = parseFloat(qryIva.value("totalrecargo"));
      haberME = 0;
      baseImponible = parseFloat(qryIva.value("neto"));

      if (!monedaSistema) {
        haberME = haber;
        haber *= parseFloat(curFactura.valueBuffer("tasaconv"));
        baseImponible *= parseFloat(curFactura.valueBuffer("tasaconv"));
      }

      haber = AQUtil.roundFieldValue(haber, "co_partidas", "haber");
      haberME = AQUtil.roundFieldValue(haberME, "co_partidas", "haberme");
      baseImponible = AQUtil.roundFieldValue(baseImponible, "co_partidas", "baseimponible");

      var curPartida: FLSqlCursor = new FLSqlCursor("co_partidas");
      with(curPartida) {
        setModeAccess(curPartida.Insert);
        refreshBuffer();
        setValueBuffer("idsubcuenta", datosIvaVenta.idSubcuentaRec);
        setValueBuffer("codsubcuenta", datosIvaVenta.codSubcuentaRec);
        setValueBuffer("codgrupoivaneg", codGrupoIvaNeg);
        setValueBuffer("codimpuesto", codImpuesto);
        setValueBuffer("idasiento", idAsiento);
        setValueBuffer("debe", 0);
        setValueBuffer("haber", haber);
        setValueBuffer("baseimponible", baseImponible);
        setValueBuffer("iva", 0);
        setValueBuffer("recargo", recargo);
        setValueBuffer("coddivisa", curFactura.valueBuffer("coddivisa"));
        setValueBuffer("tasaconv", curFactura.valueBuffer("tasaconv"));
        setValueBuffer("idcontrapartida", ctaCliente.idsubcuenta);
        setValueBuffer("codcontrapartida", ctaCliente.codsubcuenta);
        setValueBuffer("debeME", 0);
        setValueBuffer("haberME", haberME);
        setValueBuffer("codserie", curFactura.valueBuffer("codserie"));
        setValueBuffer("cifnif", curFactura.valueBuffer("cifnif"));
      }

      _i.datosPartidaFactura(curPartida, curFactura, "cliente")

      if (!curPartida.commitBuffer()) {
        return false;
      }
    }
  }
  return true;
}

function ivaNav_generarPartidasIVAProv(curFactura, idAsiento, valoresDefecto, ctaProveedor, concepto)
{
  var _i = this.iface;
  var haber = 0, haberME, baseImponible = 0;
  var codImpuesto, recargo, iva;
  debug(1);
  var codGrupoIvaNeg = curFactura.valueBuffer("codgrupoivaneg");

  var monedaSistema: Boolean = (valoresDefecto.coddivisa == curFactura.valueBuffer("coddivisa"));

  var qryIva: FLSqlQuery = new FLSqlQuery();
  qryIva.setTablesList("lineasivafactprov");
  qryIva.setSelect("neto, iva, totaliva, recargo, totalrecargo, codimpuesto");
  qryIva.setFrom("lineasivafactprov");
  qryIva.setWhere("idfactura = " + curFactura.valueBuffer("idfactura"));
  try {
    qryIva.setForwardOnly(true);
  } catch (e) {}
  if (!qryIva.exec())
    return false;


  while (qryIva.next()) {
    codImpuesto = qryIva.value("codimpuesto");
    iva = parseFloat(qryIva.value("iva"));
    iva = isNaN(iva) ? 0 : iva;
    recargo = parseFloat(qryIva.value("recargo"));
    recargo = isNaN(recargo) ? 0 : recargo;
    debug("codImpuesto " + codImpuesto);

    var datosIvaCompra = _i.dameDatosIvaCompra(codGrupoIvaNeg, codImpuesto, valoresDefecto.codejercicio);
    var textoError;
    if (datosIvaCompra.error != 0) {
      MessageBox.information(AQUtil.translate("scripts", "Error al obtener los datos de IVA asociados al grupo de IVA negocio %1 y producto %2.").arg(codGrupoIvaNeg).arg(codImpuesto), MessageBox.Ok, MessageBox.NoButton);
      return false;
    }
    switch (datosIvaCompra.tipoCalculo) {
      case "Reversión": {
        //        if (iva != 0 || recargo != 0) {
        //          MessageBox.information(AQUtil.translate("scripts", "Error al obtener los datos de IVA asociados al grupo de IVA negocio %1 y producto %2.\nEn el cálculo de reversión el IVA y recargo deben ser 0").arg(codGrupoIvaNeg).arg(codImpuesto), MessageBox.Ok, MessageBox.NoButton);
        //          return false;
        //        }
        //        iva = datosIvaCompra.iva;
        //        recargo = datosIvaCompra.recargo;
        break;
      }
    }
    //    if (datosIvaCompra.iva != iva || datosIvaCompra.recargo != recargo) {
    //      MessageBox.information(AQUtil.translate("scripts", "Error al obtener los datos de IVA asociados al grupo de IVA negocio %1 y producto %2. \nLos tipos de IVA y/o recargo no coinciden con los esperados").arg(codGrupoIvaNeg).arg(codImpuesto), MessageBox.Ok, MessageBox.NoButton);
    //      return false;
    //    }

    debeME = 0;
    baseImponible = parseFloat(qryIva.value("neto"));
    switch (datosIvaCompra.tipoCalculo) {
      case "Reversión": {
        debe = baseImponible * (parseFloat(iva) + parseFloat(recargo)) / 100;
        break;
      }
      default: {
        if (recargo != 0) {
          debe = parseFloat(qryIva.value("totaliva")) + parseFloat(qryIva.value("totalrecargo"));
        } else {
          debe = parseFloat(qryIva.value("totaliva"));
        }
        break;
      }
    }
    if (!monedaSistema) {
      debeME = debe;
      debe = debe *= parseFloat(curFactura.valueBuffer("tasaconv"));
      baseImponible *= parseFloat(curFactura.valueBuffer("tasaconv"));
    }
    debe = AQUtil.roundFieldValue(debe, "co_partidas", "debe");
    debeME = AQUtil.roundFieldValue(debeME, "co_partidas", "debeme");
    baseImponible = AQUtil.roundFieldValue(baseImponible, "co_partidas", "baseimponible");

    var curPartida: FLSqlCursor = new FLSqlCursor("co_partidas");
    with(curPartida) {
      setModeAccess(curPartida.Insert);
      refreshBuffer();
      if (datosIvaCompra.idSubcuentaSop) {
        setValueBuffer("idsubcuenta", datosIvaCompra.idSubcuentaSop);
        setValueBuffer("codsubcuenta", datosIvaCompra.codSubcuentaSop);
      } else {
        if (parseFloat(debe) != 0) {
          return false;
        }
        setNull("idsubcuenta");
        setNull("codsubcuenta");
      }
      setValueBuffer("codgrupoivaneg", codGrupoIvaNeg);
      setValueBuffer("codimpuesto", codImpuesto);
      setValueBuffer("idasiento", idAsiento);
      setValueBuffer("debe", debe);
      setValueBuffer("haber", 0);
      setValueBuffer("baseimponible", baseImponible);
      setValueBuffer("iva", iva);
      setValueBuffer("recargo", recargo);
      setValueBuffer("coddivisa", curFactura.valueBuffer("coddivisa"));
      setValueBuffer("tasaconv", curFactura.valueBuffer("tasaconv"));
      setValueBuffer("idcontrapartida", ctaProveedor.idsubcuenta);
      setValueBuffer("codcontrapartida", ctaProveedor.codsubcuenta);
      setValueBuffer("debeME", debeME);
      setValueBuffer("haberME", 0);
      setValueBuffer("codserie", curFactura.valueBuffer("codserie"));
      setValueBuffer("cifnif", curFactura.valueBuffer("cifnif"));
    }
    _i.datosPartidaFactura(curPartida, curFactura, "proveedor")

    if (!curPartida.commitBuffer()) {
      return false;
    }
    switch (datosIvaCompra.tipoCalculo) {
      case "Reversión": {
        haber = debe;
        haberME = debeME;
        with(curPartida) {
          setModeAccess(curPartida.Insert);
          refreshBuffer();
          setValueBuffer("idsubcuenta", datosIvaCompra.idSubcuentaRev);
          setValueBuffer("codsubcuenta", datosIvaCompra.codSubcuentaRev);
          setValueBuffer("codgrupoivaneg", codGrupoIvaNeg);
          setValueBuffer("codimpuesto", codImpuesto);
          setValueBuffer("idasiento", idAsiento);
          setValueBuffer("debe", 0);
          setValueBuffer("haber", haber);
          setValueBuffer("baseimponible", baseImponible);
          setValueBuffer("iva", iva);
          setValueBuffer("recargo", recargo);
          setValueBuffer("coddivisa", curFactura.valueBuffer("coddivisa"));
          setValueBuffer("tasaconv", curFactura.valueBuffer("tasaconv"));
          setValueBuffer("idcontrapartida", ctaProveedor.idsubcuenta);
          setValueBuffer("codcontrapartida", ctaProveedor.codsubcuenta);
          setValueBuffer("debeME", 0);
          setValueBuffer("haberME", haberME);
          setValueBuffer("codserie", curFactura.valueBuffer("codserie"));
          setValueBuffer("cifnif", curFactura.valueBuffer("cifnif"));
        }
        _i.datosPartidaFactura(curPartida, curFactura, "proveedor", concepto)
        if (!curPartida.commitBuffer()) {
          return false;
        }
        break;
      }
    }
    /*
        /// Caso de que la empresa aplique recargo
        if (monedaSistema) {
          debe = parseFloat(qryIva.value("totalrecargo"));
          debeME = 0;
        } else {
          debe = parseFloat(qryIva.value("totalrecargo")) * parseFloat(curFactura.valueBuffer("tasaconv"));
          debeME = parseFloat(qryIva.value("totalrecargo"));
        }
        debe = util.roundFieldValue(debe, "co_partidas", "debe");
        debeME = util.roundFieldValue(debeME, "co_partidas", "debeme");

        if (parseFloat(debe) != 0) {
          var ctaRecargo:Array = this.iface.datosCtaIVA("IVADEU", valoresDefecto.codejercicio, qryIva.value("codimpuesto"));
          if (ctaRecargo.error != 0)
            return false;
          var curPartida:FLSqlCursor = new FLSqlCursor("co_partidas");
          with (curPartida) {
            setModeAccess(curPartida.Insert);
            refreshBuffer();
            setValueBuffer("idsubcuenta", ctaRecargo.idsubcuenta);
            setValueBuffer("codsubcuenta", ctaRecargo.codsubcuenta);
            setValueBuffer("idasiento", idAsiento);
            setValueBuffer("debe", debe);
            setValueBuffer("haber", 0);
            setValueBuffer("baseimponible", baseImponible);
            setValueBuffer("iva", iva);
            setValueBuffer("recargo", recargo);
            setValueBuffer("coddivisa", curFactura.valueBuffer("coddivisa"));
            setValueBuffer("tasaconv", curFactura.valueBuffer("tasaconv"));
            setValueBuffer("idcontrapartida", ctaProveedor.idsubcuenta);
            setValueBuffer("codcontrapartida", ctaProveedor.codsubcuenta);
            setValueBuffer("debeME", debeME);
            setValueBuffer("haberME", 0);
            setValueBuffer("codserie", curFactura.valueBuffer("codserie"));
            setValueBuffer("cifnif", curFactura.valueBuffer("cifnif"));
          }

          this.iface.datosPartidaFactura(curPartida, curFactura, "proveedor", concepto)

          if (!curPartida.commitBuffer())
            return false;
        }
        */
  }

  return true;
}

function ivaNav_dameDatosIvaVenta(codGrupoIvaNeg, codImpuesto, codEjercicio)
{
  var oDatos = new Object;
  oDatos.error = 1;
  oDatos.desError = "";
  var q = new FLSqlQuery;
  q.setSelect("g.tipocalculo, g.codsubcuentarep, srep.idsubcuenta, g.codsubcuentarec, srec.idsubcuenta, g.iva, g.recargo");
  q.setFrom("gruposcontablesivaproneg g LEFT OUTER JOIN co_subcuentas srep ON (g.codsubcuentarep = srep.codsubcuenta AND srep.codejercicio = '" + codEjercicio + "') LEFT OUTER JOIN co_subcuentas srec ON (g.codsubcuentarec = srec.codsubcuenta AND srec.codejercicio = '" + codEjercicio + "')");
  q.setWhere("g.codgrupoivaneg = '" + codGrupoIvaNeg + "' AND g.codimpuesto = '" + codImpuesto + "'");
  q.setForwardOnly(true);
  debug(q.sql());
  if (!q.exec()) {
    return oDatos;
  }
  if (!q.first()) {
    return oDatos;
  }
  oDatos.codSubcuentaRep = q.value("g.codsubcuentarep");
  oDatos.idSubcuentaRep = q.value("srep.idsubcuenta");
  oDatos.codSubcuentaRec = q.value("g.codsubcuentarec");
  oDatos.idSubcuentaRec = q.value("srec.idsubcuenta");
  oDatos.tipoCalculo = q.value("g.tipocalculo");
  switch (oDatos.tipoCalculo) {
    case "No sujeto":
    case "Reversión": {
      oDatos.iva = 0;
      oDatos.recargo = 0;
      oDatos.idSubcuentaRep = false;
      oDatos.codSubcuentaRep = false;
      break;
    }
    case "Total": /// Viene de Navision
    case "Normal": {
      if (!q.value("g.codsubcuentarep") || (q.value("g.codsubcuentarep") && !q.value("srep.idsubcuenta"))) {
        oDatos.desError = sys.translate("Error al obtener la subcuenta de IVA repercutido");
        return oDatos;
      }
      if (q.value("g.codsubcuentarec") && !q.value("srec.idsubcuenta")) {
        oDatos.desError = sys.translate("Error al obtener la subcuenta de recargo");
        return oDatos;
      }

      oDatos.iva = q.value("g.iva");
      oDatos.recargo = q.value("g.recargo");
      break;
    }
    default: {
      oDatos.desError = sys.translate("Tipo de cálculo IVA (%1) no soportado").arg(oDatos.tipoCalculo);
      return oDatos;
    }
  }
  oDatos.error = 0;
  return oDatos;
}

function ivaNav_dameDatosIvaCompra(codGrupoIvaNeg, codImpuesto, codEjercicio)
{
  debug("ivaNav_dameDatosIvaCompra");
  var oDatos = new Object;
  oDatos.error = 1;
  oDatos.desError = "";
  var q = new FLSqlQuery;
  q.setSelect("g.tipocalculo, g.codsubcuentasop, ssop.idsubcuenta, g.codsubcuentarev, srev.idsubcuenta, g.iva, g.recargo");
  q.setFrom("gruposcontablesivaproneg g LEFT OUTER JOIN co_subcuentas ssop ON (g.codsubcuentasop = ssop.codsubcuenta AND ssop.codejercicio = '" + codEjercicio + "') LEFT OUTER JOIN co_subcuentas srev ON (g.codsubcuentarev = srev.codsubcuenta AND srev.codejercicio = '" + codEjercicio + "')");
  q.setWhere("g.codgrupoivaneg = '" + codGrupoIvaNeg + "' AND g.codimpuesto = '" + codImpuesto + "'");
  q.setForwardOnly(true);
  debug(q.sql());
  if (!q.exec()) {
    debug("no exec");
    return oDatos;
  }
  if (!q.first()) {
    debug("no first");
    return oDatos;
  }
  oDatos.codSubcuentaSop = q.value("g.codsubcuentasop");
  oDatos.idSubcuentaSop = q.value("ssop.idsubcuenta");
  oDatos.codSubcuentaRev = q.value("g.codsubcuentarev");
  oDatos.idSubcuentaRev = q.value("srev.idsubcuenta");
  oDatos.tipoCalculo = q.value("g.tipocalculo");
  debug("tipocalculo " + oDatos.tipoCalculo);
  switch (oDatos.tipoCalculo) {
    case "No sujeto": {
      //      oDatos.iva = 0;
      //      oDatos.recargo = 0;
      oDatos.idSubcuentaSop = false;
      oDatos.codSubcuentaSop = false;
      break;
    }
    case "Total": /// Viene de Navision
    case "Normal": {
      if (!q.value("g.codsubcuentasop") || (q.value("g.codsubcuentasop") && !q.value("ssop.idsubcuenta"))) {
        debug("error normal");
        oDatos.desError = sys.translate("Error al obtener la subcuenta de IVA soportado");
        return oDatos;
      }
      //      oDatos.iva = q.value("g.iva");
      //      oDatos.recargo = q.value("g.recargo");
      break;
    }
    case "Reversión": {
      if (!q.value("g.codsubcuentasop") || (q.value("g.codsubcuentasop") && !q.value("ssop.idsubcuenta"))) {
        oDatos.desError = sys.translate("Error al obtener la subcuenta de IVA soportado");
        return oDatos;
      }
      if (!q.value("g.codsubcuentarev") || (q.value("g.codsubcuentarev") && !q.value("srev.idsubcuenta"))) {
        oDatos.desError = sys.translate("Error al obtener la subcuenta de reversión de IVA");
        return oDatos;
      }
      //      oDatos.iva = q.value("g.iva");
      //      oDatos.recargo = q.value("g.recargo");
      break;
    }
    default: {
      oDatos.desError = sys.translate("Tipo de cálculo IVA (%1) no soportado").arg(oDatos.tipoCalculo);
      return oDatos;
    }
  }
  debug("sin error ");
  oDatos.error = 0;
  return oDatos;
}

function ivaNav_validarIvaRecargoCliente(codCliente, id, tabla, identificador)
{
  return true;
}

function ivaNav_validarIvaRecargoProveedor(codProveedor, id, tabla, identificador)
{
  return true;
}

function ivaNav_campoImpuesto(campo, codImpuesto, fecha, cliProv, codGrupoIvaNeg)
{
  var q = new FLSqlQuery;
  q.setSelect("p.iva, p.recargo, gn.aplicarrecargo, gn.siniva, g.tipocalculo");
  q.setFrom("gruposcontablesivaproneg g INNER JOIN periodos p ON g.codimpuesto = p.codimpuesto INNER JOIN gruposcontablesivaneg gn ON g.codgrupoivaneg = gn.codgrupoivaneg");
  q.setWhere("g.codimpuesto = '" + codImpuesto + "' AND gn.codgrupoivaneg = '" + codGrupoIvaNeg + "' AND fechadesde <= '" + fecha + "' AND (fechahasta >= '" + fecha + "' OR fechahasta IS NULL)");
  q.setForwardOnly(true);
  if (!q.exec()) {
    return false;
  }
  if (!q.first()) {
    return 0;
  }
  var valor;
  debug("tc " + q.value("g.tipocalculo") + " " + cliProv);
  switch (q.value("g.tipocalculo")) {
    case "No sujeto": {
      valor = 0;
      break;
    }
    case "Reversión": {
      valor = 0;
      if (cliProv == "cli") {
        break;
      }
      if (campo == "iva") {
        valor = q.value("p.iva");
      } else if (campo == "recargo" && q.value("gn.aplicarrecargo")) {
        valor = q.value("p.recargo");
      }
      break;
    }
    case "Normal": {
      valor = 0;
      if (campo == "iva" && !q.value("gn.siniva")) {
        valor = q.value("p.iva");
      } else if (campo == "recargo" && q.value("gn.aplicarrecargo")) {
        valor = q.value("p.recargo");
      }
      break;
    }
  }
  return valor;
}

function ivaNav_habilitaPorIva(miForm)
{
  var cursor = miForm.cursor();
  var codImpuesto = cursor.valueBuffer("codimpuesto");

  var habilitar = AQUtil.sqlSelect("impuestos", "habilitartipos", "codimpuesto = '" + codImpuesto + "'");
  miForm.child("fdbIva").setDisabled(!habilitar);
  miForm.child("fdbRecargo").setDisabled(!habilitar);
}
//// IVA NAV ////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

