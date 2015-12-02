
/** @class_declaration pagareProv */
/////////////////////////////////////////////////////////////////
//// PAGARE PROV ////////////////////////////////////////////////
class pagareProv extends proveed
{
  function pagareProv(context)
  {
    proveed(context);
  }
  function generarAsientoPagoDevolProv(curPD)
  {
    return this.ctx.pagareProv_generarAsientoPagoDevolProv(curPD);
  }
  function beforeCommit_pagaresprov(curPagare)
  {
    return this.ctx.pagareProv_beforeCommit_pagaresprov(curPagare);
  }
  function beforeCommit_pagospagareprov(curPD)
  {
    return this.ctx.pagareProv_beforeCommit_pagospagareprov(curPD);
  }
  function afterCommit_pagospagareprov(curPD)
  {
    return this.ctx.pagareProv_afterCommit_pagospagareprov(curPD);
  }
  function generarPartidasBancoPagProv(curPD, valoresDefecto, datosAsiento, pagare)
  {
    return this.ctx.pagareProv_generarPartidasBancoPagProv(curPD, valoresDefecto, datosAsiento, pagare);
  }
  function generarPartidasPtePagProv(curPD, valoresDefecto, datosAsiento, pagare)
  {
    return this.ctx.pagareProv_generarPartidasPtePagProv(curPD, valoresDefecto, datosAsiento, pagare);
  }
  function dameHaberPartidasBancoPagProv(curPD, pagare)
  {
    return this.ctx.pagareProv_dameHaberPartidasBancoPagProv(curPD, pagare);
  }
  function dameDebePartidasPtePagProv(curPD, pagare)
  {
    return this.ctx.pagareProv_dameDebePartidasPtePagProv(curPD, pagare);
  }
  function generarAsientoPagoPagareProv(curPD)
  {
    return this.ctx.pagareProv_generarAsientoPagoPagareProv(curPD);
  }
  function controlarCantidadDebe(curPD, debe, pagare)
  {
    return this.ctx.pagareProv_controlarCantidadDebe(curPD, debe, pagare);
  }
  function cambiaUltimoPagoPagProv(idPagare, idPagoDevol, unlock)
  {
    return this.ctx.pagareProv_cambiaUltimoPagoPagProv(idPagare, idPagoDevol, unlock);
  }
  function comprobarFechasPagares(curPagare)
  {
    return this.ctx.pagareProv_comprobarFechasPagares(curPagare);
  }
}
//// PAGARE PROV ////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition pagareProv */
/////////////////////////////////////////////////////////////////
//// PAGARE PROV ////////////////////////////////////////////////
function pagareProv_generarAsientoPagoDevolProv(curPD)
{
  var util: FLUtil = new FLUtil();
  if (curPD.modeAccess() != curPD.Insert && curPD.modeAccess() != curPD.Edit)
    return true;

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
  valoresDefecto["coddivisa"] = AQUtil.sqlSelect("empresa", "coddivisa", "1 = 1");

  var curTransaccion = new FLSqlCursor("empresa");
  curTransaccion.transaction(false);
  try {
    datosAsiento = flfacturac.iface.pub_regenerarAsiento(curPD, valoresDefecto);
    if (datosAsiento.error == true) {
      throw AQUtil.translate("scripts", "Error al regenerar el asiento");
    }
    var recibo = flfactppal.iface.pub_ejecutarQry("recibosprov", "coddivisa,importe,importeeuros,idfactura,codigo,nombreproveedor,codproveedor", "idrecibo = " + curPD.valueBuffer("idrecibo"));
    if (recibo.result != 1) {
      throw AQUtil.translate("scripts", "Error al obtener los datos del recibo");
    }
    if (!this.iface.generarPartidasProv(curPD, valoresDefecto, datosAsiento, recibo)) {
      throw AQUtil.translate("scripts", "Error al generar la partida de proveedor");
    }
    if (!this.iface.generarPartidasBancoProv(curPD, valoresDefecto, datosAsiento, recibo)) {
      throw AQUtil.translate("scripts", "Error al generar la partida de banco");
    }
    if (!this.iface.generarPartidasCambioProv(curPD, valoresDefecto, datosAsiento, recibo)) {
      throw AQUtil.translate("scripts", "Error al generar la partida de diferencias por cambio");
    }
    if (!flcontppal.iface.pub_comprobarAsiento(datosAsiento.idasiento)) {
      throw AQUtil.translate("scripts", "Error al comprobar el asiento");
    }
    curPD.setValueBuffer("idasiento", datosAsiento.idasiento);
  } catch (e) {
    curTransaccion.rollback();
    var codRecibo = AQUtil.sqlSelect("reciboscli", "codigo", "idrecibo = " + curPD.valueBuffer("idrecibo"));
    MessageBox.warning(AQUtil.translate("scripts", "Error al generar el asiento correspondiente a %1 del recibo %2:").arg(curPD.valueBuffer("tipo")).arg(codRecibo) + "\n" + e, MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  curTransaccion.commit();

  return true;
}

function pagareProv_beforeCommit_pagaresprov(curPagare)
{
  var util: FLUtil = new FLUtil();
  switch (curPagare.modeAccess()) {
      /** \C El pagaré puede borrarse si todos los recibos asociados pueden ser excluidos
      \end */
    case curPagare.Del: {
      if (curPagare.valueBuffer("estado") != "Emitido") {
        MessageBox.warning(AQUtil.translate("scripts", "No puede borrar un pagaré en estado %1.\nSi realmente quiere borrarlo debe eliminar los pagos y devoluciones").arg(curPagare.valueBuffer("estado")), MessageBox.Ok, MessageBox.NoButton);
        return false;
      }
      var idPagare = curPagare.valueBuffer("idpagare");
      var qryRecibos: FLSqlQuery = new FLSqlQuery;
      qryRecibos.setTablesList("pagosdevolprov");
      qryRecibos.setSelect("DISTINCT(idrecibo)");
      qryRecibos.setFrom("pagosdevolprov");
      qryRecibos.setWhere("idpagare = " + idPagare);
      qryRecibos.setForwardOnly(true);
      if (!qryRecibos.exec())
        return false;
      while (qryRecibos.next()) {
        if (!formRecordpagaresprov.iface.pub_excluirReciboPagare(qryRecibos.value(0), idPagare))
          return false;
      }
    }
    case curPagare.Insert:
    case curPagare.Edit: {
      if (!this.iface.comprobarFechasPagares(curPagare))
        return false;

      if (curPagare.valueBuffer("numero") == "") {
        MessageBox.warning(AQUtil.translate("scripts", "El pagaré debe tener un número establecido"), MessageBox.Ok, MessageBox.NoButton);
        return false;
      }
      if (AQUtil.sqlSelect("pagaresprov", "idpagare", "numero = '" + curPagare.valueBuffer("numero") + "' AND idpagare <> " + curPagare.valueBuffer("idpagare"))) {
        MessageBox.warning(AQUtil.translate("scripts", "Ya existe un pagaré con el número %1").arg(curPagare.valueBuffer("numero")), MessageBox.Ok, MessageBox.NoButton);
        return false;
      }
    }
  }
  return true;
}

function pagareProv_beforeCommit_pagospagareprov(curPD)
{
  var util: FLUtil = new FLUtil;

  if (sys.isLoadedModule("flcontppal") && !curPD.valueBuffer("nogenerarasiento") && AQUtil.sqlSelect("empresa", "contintegrada", "1 = 1")) {
    if (!this.iface.generarAsientoPagoPagareProv(curPD))
      return false;
  }

  return true;
}

/** \C Se elimina, si es posible, el asiento contable asociado al pago o devolución
\end */
function pagareProv_afterCommit_pagospagareprov(curPD)
{
  var idPagare = curPD.valueBuffer("idpagare");

  /** \C Se cambia el pago anterior al actual para que sólo el último sea editable
  \end */
  switch (curPD.modeAccess()) {
    case curPD.Insert:
    case curPD.Edit: {
      if (!this.iface.cambiaUltimoPagoPagProv(idPagare, curPD.valueBuffer("idpagodevol"), false))
        return false;
      break;
    }
    case curPD.Del: {
      if (!this.iface.cambiaUltimoPagoPagProv(idPagare, curPD.valueBuffer("idpagodevol"), true))
        return false;
      break;
    }
  }

  var util: FLUtil = new FLUtil();
  if (sys.isLoadedModule("flcontppal") == false || AQUtil.sqlSelect("empresa", "contintegrada", "1 = 1") == false)
    return true;

  if (curPD.modeAccess() == curPD.Del) {
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
  }
  return true;
}

function pagareProv_generarAsientoPagoPagareProv(curPD)
{
  var util: FLUtil = new FLUtil();
  if (curPD.modeAccess() != curPD.Insert && curPD.modeAccess() != curPD.Edit) {
    return true;
  }
  var codEjercicio = flfactppal.iface.pub_ejercicioActual();
  var datosDoc = flfacturac.iface.pub_datosDocFacturacion(curPD.valueBuffer("fecha"), codEjercicio, "pagosdevolprov");
  if (!datosDoc.ok) {
    return false;
  }
  if (datosDoc.modificaciones == true) {
    codEjercicio = datosDoc.codEjercicio;
    curPD.setValueBuffer("fecha", datosDoc.fecha);
  }

  var datosAsiento = [];
  var valoresDefecto: Array;
  valoresDefecto["codejercicio"] = codEjercicio;
  valoresDefecto["coddivisa"] = AQUtil.sqlSelect("empresa", "coddivisa", "1 = 1");

  var curTransaccion = new FLSqlCursor("empresa");
  curTransaccion.transaction(false);
  try {
    datosAsiento = flfacturac.iface.pub_regenerarAsiento(curPD, valoresDefecto);
    if (datosAsiento.error == true) {
      throw AQUtil.translate("scripts", "Error al regenerar el asiento");
    }

    var pagare = flfactppal.iface.pub_ejecutarQry("pagaresprov", "numero,total,nombreproveedor,coddivisa,codsubcuentap", "idpagare = " + curPD.valueBuffer("idpagare"));
    if (pagare.result != 1) {
      throw AQUtil.translate("scripts", "Error al obtener los datos del pagaré");
    }
    if (!this.iface.generarPartidasPtePagProv(curPD, valoresDefecto, datosAsiento, pagare)) {
      throw AQUtil.translate("scripts", "Error al obtener la partida pendiente de pago");
    }
    if (!this.iface.generarPartidasBancoPagProv(curPD, valoresDefecto, datosAsiento, pagare)) {
      throw AQUtil.translate("scripts", "Error al obtener la partida de banco");
    }

    if (!flcontppal.iface.pub_comprobarAsiento(datosAsiento.idasiento)) {
      throw AQUtil.translate("scripts", "Error al comprobar el asiento");
    }
    curPD.setValueBuffer("idasiento", datosAsiento.idasiento);
  } catch (e) {
    curTransaccion.rollback();
    var codPagare = AQUtil.sqlSelect("pagaresprov", "numero", "idpagare = " + curPD.valueBuffer("idpagare"));
    MessageBox.warning(AQUtil.translate("scripts", "Error al generar el asiento correspondiente a pago del pagaré %1:").arg(codPagare) + "\n" + e, MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  curTransaccion.commit();

  return true;
}

function pagareProv_generarPartidasBancoPagProv(curPD, valoresDefecto, datosAsiento, pagare)
{
  var _i = this.iface;
  var util: FLUtil = new FLUtil();
  var ctaHaber = [];

  ctaHaber.codsubcuenta = curPD.valueBuffer("codsubcuenta");
  ctaHaber.idsubcuenta = AQUtil.sqlSelect("co_subcuentas", "idsubcuenta", "codsubcuenta = '" + ctaHaber.codsubcuenta + "' AND codejercicio = '" + valoresDefecto.codejercicio + "'");
  if (!ctaHaber.idsubcuenta) {
    MessageBox.warning(AQUtil.translate("scripts", "No tiene definida la subcuenta %1 en el ejercicio %2.\nAntes de dar el pago debe crear la subcuenta o modificar el ejercicio").arg(ctaHaber.codsubcuenta).arg(valoresDefecto.codejercicio), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }

  var haber = 0;
  var haberME = 0;

  haber =  _i.dameHaberPartidasBancoPagProv(curPD, pagare);
  haberMe = 0;
  haber = AQUtil.roundFieldValue(haber, "co_partidas", "haber");
  haberME = AQUtil.roundFieldValue(haberME, "co_partidas", "haberme");

  var curPartida = new FLSqlCursor("co_partidas");
  with(curPartida) {
    setModeAccess(curPartida.Insert);
    refreshBuffer();
    setValueBuffer("concepto", curPD.valueBuffer("tipo") + " pagaré prov. " + pagare.numero + " - " + pagare.nombreproveedor);
    setValueBuffer("idsubcuenta", ctaHaber.idsubcuenta);
    setValueBuffer("codsubcuenta", ctaHaber.codsubcuenta);
    setValueBuffer("idasiento", datosAsiento.idasiento);
    setValueBuffer("coddivisa", pagare.coddivisa);
    setValueBuffer("tasaconv", 1);
    setValueBuffer("debeME", 0);
    setValueBuffer("haberME", haberME);
  }
  if (curPD.valueBuffer("tipo") == "Pago") {
    curPartida.setValueBuffer("debe", 0);
    curPartida.setValueBuffer("haber", haber);
  } else {
    curPartida.setValueBuffer("debe", haber);
    curPartida.setValueBuffer("haber", 0);
  }
  if (!curPartida.commitBuffer())
    return false;

  return true;
}

function pagareProv_dameHaberPartidasBancoPagProv(curPD, pagare)
{
  return pagare.total;
}

function pagareProv_dameDebePartidasPtePagProv(curPD, pagare)
{
  var _i = this.iface;

  var debe;
  var idPagare = curPD.valueBuffer("idpagare");
  var codCuentaBanco = AQUtil.sqlSelect("pagaresprov", "codcuenta", "idpagare = " + idPagare);
  var codSubcuentaPBanco = AQUtil.sqlSelect("cuentasbanco", "codsubcuentap", "codcuenta = '" + codCuentaBanco + "'");

  if (pagare.codsubcuentap == codSubcuentaPBanco) {
    debe = AQUtil.sqlSelect("pagosdevolprov pd INNER JOIN co_partidas p ON pd.idasiento = p.idasiento", "SUM(haber - debe)", "pd.idpagare = " + idPagare + " AND p.codsubcuenta = '" + pagare.codsubcuentap + "'", "pagosdevolprov,co_subcuentas");
  } else {
    debe = AQUtil.sqlSelect("pagosdevolprov pd INNER JOIN recibosprov r ON pd.idrecibo = r.idrecibo", "SUM(r.importe)", "pd.idpagare = " + idPagare, "pagosdevolprov,recibosprov");
  }
  return debe;
}

/** \D Genera la partida correspondiente a la subcuenta de efectos pendientes de pago
@param  curPD: Cursor del pago o devolución
@param  valoresDefecto: Array de valores por defecto (ejercicio, divisa, etc.)
@param  datosAsiento: Array con los datos del asiento
@param  pagare: Array con los datos del pagaré asociado al pago
@return true si la generación es correcta, false en caso contrario
\end */
function pagareProv_generarPartidasPtePagProv(curPD, valoresDefecto, datosAsiento, pagare)
{
  var _i = this.iface;
  var ctaDebe = [];

  ctaDebe.codsubcuenta = pagare.codsubcuentap;
  ctaDebe.idsubcuenta = AQUtil.sqlSelect("co_subcuentas", "idsubcuenta", "codsubcuenta = '" + ctaDebe.codsubcuenta + "' AND codejercicio = '" + valoresDefecto.codejercicio + "'");
  if (!ctaDebe.idsubcuenta) {
    MessageBox.warning(AQUtil.translate("scripts", "No tiene definida la subcuenta %1 en el ejercicio %2.\nAntes de dar el pago debe crear la subcuenta o modificar el ejercicio").arg(ctaDebe.codsubcuenta).arg(valoresDefecto.codejercicio), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }

  var debe = _i.dameDebePartidasPtePagProv(curPD, pagare);
  var debeME = 0;
  var tasaconvDebe = 1;

  debe = AQUtil.roundFieldValue(debe, "co_partidas", "debe");
  debeME = AQUtil.roundFieldValue(debeME, "co_partidas", "debeme");

  if (!_i.controlarCantidadDebe(curPD, debe, pagare)) {
    return false;
  }

  var curPartida = new FLSqlCursor("co_partidas");
  with(curPartida) {
    setModeAccess(curPartida.Insert);
    refreshBuffer();

    setValueBuffer("concepto", curPD.valueBuffer("tipo") + " pagaré prov. " + pagare.numero + " - " + pagare.nombreproveedor);
    setValueBuffer("idsubcuenta", ctaDebe.idsubcuenta);
    setValueBuffer("codsubcuenta", ctaDebe.codsubcuenta);
    setValueBuffer("idasiento", datosAsiento.idasiento);
    setValueBuffer("coddivisa", pagare.coddivisa);
    setValueBuffer("tasaconv", tasaconvDebe);
    setValueBuffer("debeME", debeME);
    setValueBuffer("haberME", 0);
  }

  if (curPD.valueBuffer("tipo") == "Pago") {
    curPartida.setValueBuffer("debe", debe);
    curPartida.setValueBuffer("haber", 0);
  } else {
    curPartida.setValueBuffer("haber", debe);
    curPartida.setValueBuffer("debe", 0);
  }

  if (!curPartida.commitBuffer())
    return false;

  return true;
}

function pagareProv_controlarCantidadDebe(curPD, debe, pagare)
{
  var _i = this.iface;

  if (parseFloat(debe) != parseFloat(pagare.total)) {
    MessageBox.warning(sys.translate("Error: La suma de pagos de los recibos en el pagaré (%1)\nno coincide con el total del pagaré (%2)").arg(AQUtil.roundFieldValue(debe, "co_partidas", "debe")).arg(AQUtil.roundFieldValue(pagare.total, "co_partidas", "debe")), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  return true;
}

/** \D Cambia la el estado del último pago anterior al especificado, de forma que se mantenga como único pago editable el último de todos
@param  idPagare: Identificador del pagaré al que pertenecen los pagos tratados
@param  idPagoDevol: Identificador del pago que ha cambiado
@param  unlock: Indicador de si el últim pago debe ser editable o no
@return true si la verificación del estado es correcta, false en caso contrario
\end */
function pagareProv_cambiaUltimoPagoPagProv(idPagare, idPagoDevol, unlock)
{
  var curPagosDevol = new FLSqlCursor("pagospagareprov");
  curPagosDevol.select("idpagare = " + idPagare + " AND idpagodevol <> " + idPagoDevol + " ORDER BY fecha, idpagodevol");
  if (curPagosDevol.last())
    curPagosDevol.setUnLock("editable", unlock);

  return true;
}

function pagareProv_comprobarFechasPagares(curPagare)
{
  var util: FLUtil = new FLUtil();

  if (AQUtil.daysTo(curPagare.valueBuffer("fecha"), curPagare.valueBuffer("fechav")) < 0) {
    MessageBox.warning(AQUtil.translate("scripts", "La fecha de emisión debe ser menor o igual a la fecha de vencimiento"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  return true;
}
//// PAGARE PROV ////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
