
/** @class_declaration remesaProv */
/////////////////////////////////////////////////////////////////
//// REMESAS DE RECIBOS DE PROVEEDOR ////////////////////////////
class remesaProv extends proveed
{
  function remesaProv(context)
  {
    proveed(context);
  }
  function beforeCommit_remesasprov(curRemesa: FLSqlCursor): Boolean {
    return this.ctx.remesaProv_beforeCommit_remesasprov(curRemesa);
  }
  function generarPartidasEFCOGP(curPR: FLSqlCursor, valoresDefecto: Array, datosAsiento: Array, remesa: Array): Boolean {
    return this.ctx.remesaProv_generarPartidasEFCOGP(curPR, valoresDefecto, datosAsiento, remesa);
  }
  function generarAsientoPagoRemesaProv(curPR: FLSqlCursor): Boolean {
    return this.ctx.remesaProv_generarAsientoPagoRemesaProv(curPR);
  }
  function generarPartidasBancoRemProv(curPR: FLSqlCursor, valoresDefecto: Array, datosAsiento: Array, remesa: Array): Boolean {
    return this.ctx.remesaProv_generarPartidasBancoRemProv(curPR, valoresDefecto, datosAsiento, remesa);
  }
  function beforeCommit_pagosdevolremprov(curPR: FLSqlCursor): Boolean {
    return this.ctx.remesaProv_beforeCommit_pagosdevolremprov(curPR);
  }
  function afterCommit_pagosdevolremprov(curPD: FLSqlCursor): Boolean {
    return this.ctx.remesaProv_afterCommit_pagosdevolremprov(curPD);
  }
  function generarAsientoPagoDevolProv(curPD)
  {
    return this.ctx.remesaProv_generarAsientoPagoDevolProv(curPD);
  }
  function afterCommit_pagosdevolprov(curPD)
  {
    return this.ctx.remesaProv_afterCommit_pagosdevolprov(curPD);
  }
  function modificaEstadoPagosRemesaProv(idRemesa, estado, datosPago)
  {
    return this.ctx.remesaProv_modificaEstadoPagosRemesaProv(idRemesa, estado, datosPago);
  }
  function totalesReciboProv()
  {
    return this.ctx.remesaProv_totalesReciboProv();
  }
  function generarPartidasProveedorRemProv(curPR, valoresDefecto, datosAsiento, remesa)
  {
    return this.ctx.remesaProv_generarPartidasProveedorRemProv(curPR, valoresDefecto, datosAsiento, remesa);
  }
  function datosPartidaProvRem(curPartida, curPD, valoresDefecto, datosAsiento, remesa)
  {
    return this.ctx.remesaProv_datosPartidaProvRem(curPartida, curPD, valoresDefecto, datosAsiento, remesa);
  }
  function cargaValoresDefecto()
  {
    return this.ctx.remesaProv_cargaValoresDefecto();
  }
}
//// REMESAS DE RECIBOS DE PROVEEDOR ////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pubRemesaProv */
/////////////////////////////////////////////////////////////////
//// PUB REMESA PROV ////////////////////////////////////////////
class pubRemesaProv extends pubProveed
{
  function pubRemesaProv(context)
  {
    pubProveed(context);
  }
  function pub_modificaEstadoPagosRemesaProv(idRemesa, estado, datosPago)
  {
    return this.modificaEstadoPagosRemesaProv(idRemesa, estado, datosPago);
  }
}
//// PUB REMESA PROV ////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition remesaProv */
/////////////////////////////////////////////////////////////////
//// REMESAS DE RECIBOS DE PROVEEDOR ////////////////////////////
function remesaProv_beforeCommit_remesasprov(curRemesa: FLSqlCursor): Boolean {

  switch (curRemesa.modeAccess())
  {
      /** \C La remesa puede borrarse si todos los pagos asociados pueden ser excluidos
      \end */
    case curRemesa.Del: {
      var idRemesa: Number = curRemesa.valueBuffer("idremesa");
      var qryRecibos: FLSqlQuery = new FLSqlQuery;
      qryRecibos.setTablesList("pagosdevolprov");
      qryRecibos.setSelect("DISTINCT(idrecibo)");
      qryRecibos.setFrom("pagosdevolprov");
      qryRecibos.setWhere("idremesa = " + idRemesa);
      if (!qryRecibos.exec())
        return false;
      while (qryRecibos.next()) {
        if (!formRecordremesasprov.iface.pub_excluirReciboRemesa(qryRecibos.value(0), idRemesa))
          return false;
      }
    }
  }
  return true;
}
/**
@param  curPR: Cursor del pago de la remesa de proveedor
@param  idAsiento: Id del asiento asociado
@param  valoresDefecto: Array con los valores por defecto de ejercicio y divisa
@return VERDADERO si no hay error, FALSO en otro caso
\end */
function remesaProv_generarPartidasEFCOGP(curPR: FLSqlCursor, valoresDefecto: Array, datosAsiento: Array, remesa: Array): Boolean {
  var util: FLUtil = new FLUtil();

  var haber: Number = 0;
  var haberME: Number = 0;
  var ctaHaber: Array = [];
  ctaHaber.codsubcuenta = util.sqlSelect("cuentasbanco", "codsubcuentaecgp", "codcuenta = '" + remesa.codcuenta + "'");

  if (!ctaHaber.codsubcuenta || ctaHaber.codsubcuenta == "")
  {
    MessageBox.warning(util.translate("scripts", "No tiene definida de efectos comerciales de gestión de pago para la cuenta %1").arg(remesa.codcuenta), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }

  ctaHaber.idsubcuenta = util.sqlSelect("co_subcuentas", "idsubcuenta", "codsubcuenta = '" + ctaHaber.codsubcuenta + "' AND codejercicio = '" + valoresDefecto.codejercicio + "'");
  if (!ctaHaber.idsubcuenta)
  {
    MessageBox.warning(util.translate("scripts", "No tiene definida la subcuenta %1 en el ejercicio %2.\nAntes de dar el pago debe crear la subcuenta o modificar el ejercicio").arg(ctaDebe.codsubcuenta).arg(valoresDefecto.codejercicio), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }

  debe = remesa.total;
  debeME = 0;
  debe = util.roundFieldValue(debe, "co_partidas", "debe");
  debeME = util.roundFieldValue(debeME, "co_partidas", "debeme");

  var curPartida: FLSqlCursor = new FLSqlCursor("co_partidas");
  with(curPartida)
  {
    setModeAccess(curPartida.Insert);
    refreshBuffer();
    setValueBuffer("concepto", curPR.valueBuffer("tipo") + " " + util.translate("scripts", "remesa") + " " + remesa.idremesa);
    setValueBuffer("idsubcuenta", ctaHaber.idsubcuenta);
    setValueBuffer("codsubcuenta", ctaHaber.codsubcuenta);
    setValueBuffer("idasiento", datosAsiento.idasiento);
    setValueBuffer("debe", debe);
    setValueBuffer("haber", 0);
    setValueBuffer("debeME", debeME);
    setValueBuffer("haberME", 0);
  }

  if (!curPartida.commitBuffer())
    return false;

  return true;
}

/** \Genera o regenera el asiento contable asociado a un pago de una remesa de proveedor
@param  curPR: Cursor posicionado en el pago cuyo asiento se va a regenerar
@return true si la regeneración se realiza correctamente, false en caso contrario
\end */
/*
function remesaProv_generarAsientoPagoRemesaProv(curPR:FLSqlCursor):Boolean
{
  var util:FLUtil = new FLUtil();
  if (curPR.modeAccess() != curPR.Insert && curPR.modeAccess() != curPR.Edit)
    return true;

  if (curPR.valueBuffer("nogenerarasiento")) {
    curPR.setNull("idasiento");
    return true;
  }
  var codEjercicio:String = flfactppal.iface.pub_ejercicioActual();
  var datosDoc:Array = flfacturac.iface.pub_datosDocFacturacion(curPR.valueBuffer("fecha"), codEjercicio, "pagosdevolremprov");
  if (!datosDoc.ok)
    return false;
  if (datosDoc.modificaciones == true) {
    codEjercicio = datosDoc.codEjercicio;
    curPR.setValueBuffer("fecha", datosDoc.fecha);
  }

  var datosAsiento:Array = [];
  var valoresDefecto:Array;
  valoresDefecto["codejercicio"] = codEjercicio;
  valoresDefecto["coddivisa"] = util.sqlSelect("empresa", "coddivisa", "1 = 1");

  datosAsiento = flfacturac.iface.pub_regenerarAsiento(curPR, valoresDefecto);
  if (datosAsiento.error == true)
    return false;

  var remesa:Array = flfactppal.iface.pub_ejecutarQry("remesasprov", "coddivisa,total,fecha,idremesa,codsubcuenta,codcuenta", "idremesa = " + curPR.valueBuffer("idremesa"));
    if (remesa.result != 1)
      return false;

  if (curPR.valueBuffer("tipo") == "Pago") {
    if (!this.iface.generarPartidasEFCOGP(curPR, valoresDefecto, datosAsiento, remesa))
      return false;

    if (!this.iface.generarPartidasBancoRemProv(curPR, valoresDefecto, datosAsiento, remesa))
      return false;
  }
  curPR.setValueBuffer("idasiento", datosAsiento.idasiento);
  if (!flcontppal.iface.pub_comprobarAsiento(datosAsiento.idasiento))
    return false;

  return true;
}*/

function remesaProv_generarAsientoPagoRemesaProv(curPR)
{
  var _i = this.iface;
  var util = new FLUtil();
  if (curPR.modeAccess() != curPR.Insert && curPR.modeAccess() != curPR.Edit)
    return true;

  if (curPR.valueBuffer("nogenerarasiento")) {
    curPR.setNull("idasiento");
    return true;
  }
  var codEjercicio = flfactppal.iface.pub_ejercicioActual();
  var datosDoc = flfacturac.iface.pub_datosDocFacturacion(curPR.valueBuffer("fecha"), codEjercicio, "pagosdevolremprov");
  if (!datosDoc.ok)
    return false;
  if (datosDoc.modificaciones == true) {
    codEjercicio = datosDoc.codEjercicio;
    curPR.setValueBuffer("fecha", datosDoc.fecha);
  }

  var datosAsiento = [];
  var valoresDefecto: Array;
  valoresDefecto["codejercicio"] = codEjercicio;
  valoresDefecto["coddivisa"] = util.sqlSelect("empresa", "coddivisa", "1 = 1");

  var pagoIndirecto = flfactteso.iface.pub_valorDefectoTesoreria("pagoindirectoprov");
  var pagoDiferido = flfactteso.iface.pub_valorDefectoTesoreria("pagodiferidoprov");

  var curTransaccion = new FLSqlCursor("empresa");
  curTransaccion.transaction(false);
  try {
    if (pagoIndirecto) {
      datosAsiento = flfacturac.iface.pub_regenerarAsiento(curPR, valoresDefecto);
      if (datosAsiento.error == true) {
        throw util.translate("scripts", "Error al regenerar el asiento");
      }
      var remesa: Array = flfactppal.iface.pub_ejecutarQry("remesasprov", "coddivisa,total,fecha,idremesa,codsubcuenta,codcuenta", "idremesa = " + curPR.valueBuffer("idremesa"));
      if (remesa.result != 1) {
        throw util.translate("scripts", "Error al obtener los datos de la remesa");
      }
      if (curPR.valueBuffer("tipo") == "Pago") {
        if (!this.iface.generarPartidasEFCOGP(curPR, valoresDefecto, datosAsiento, remesa)) {
          throw util.translate("scripts", "Error al obtener la partida de efectos comerciales de gestión de cobro");
        }
        if (!this.iface.generarPartidasBancoRemProv(curPR, valoresDefecto, datosAsiento, remesa)) {
          throw util.translate("scripts", "Error al generar la partida de banco");
        }

        curPR.setValueBuffer("idasiento", datosAsiento.idasiento);
        if (!flcontppal.iface.pub_comprobarAsiento(datosAsiento.idasiento)) {
          throw util.translate("scripts", "Error al comprobar el asiento");
        }
      }
    } else { /// Pago diferido. Los registros de pago pasan a tipo Pago,lo cual fuerza la creación de su asiento correspondiente
      datosAsiento = flfacturac.iface.pub_regenerarAsiento(curPR, valoresDefecto);
      if (datosAsiento.error == true) {
        throw util.translate("scripts", "Error al regenerar el asiento");
      }
      var remesa: Array = flfactppal.iface.pub_ejecutarQry("remesasprov", "coddivisa,total,fecha,idremesa,codsubcuenta,codcuenta", "idremesa = " + curPR.valueBuffer("idremesa"));
      if (remesa.result != 1) {
        throw util.translate("scripts", "Error al obtener los datos de la remesa");
      }
      if (curPR.valueBuffer("tipo") == "Pago") {
        if (!this.iface.generarPartidasProveedorRemProv(curPR, valoresDefecto, datosAsiento, remesa)) {
          throw util.translate("scripts", "Error al obtener las partidas de proveedor");
        }
        if (!this.iface.generarPartidasBancoRemProv(curPR, valoresDefecto, datosAsiento, remesa)) {
          throw util.translate("scripts", "Error al generar la partida de banco");
        }

        curPR.setValueBuffer("idasiento", datosAsiento.idasiento);
        if (!flcontppal.iface.pub_comprobarAsiento(datosAsiento.idasiento)) {
          throw util.translate("scripts", "Error al comprobar el asiento");
        }
      }
      var datosPago = new Object;
      datosPago.fecha = curPR.valueBuffer("fecha");
      if (!_i.modificaEstadoPagosRemesaProv(curPR.valueBuffer("idremesa"), "Pago", datosPago)) {
        throw util.translate("scripts", "Error al modificar el estado de pagos de la remesa");
      }
    }
  } catch (e) {
    curTransaccion.rollback();
    MessageBox.warning(util.translate("scripts", "Error al generar el asiento de la remesa:") + "\n" + e, MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  curTransaccion.commit();

  return true;
}

/** \D Genera la partida correspondiente al banco o a caja del asiento de pago de la remesa de proveedor
@param  curPR: Cursor del pago de la remesa de proveedor
@param  valoresDefecto: Array de valores por defecto (ejercicio, divisa, etc.)
@param  datosAsiento: Array con los datos del asiento
@param  recibo: Array con los datos del recibo de proveedor asociado al pago de la remesa
@return true si la generación es correcta, false en caso contrario
\end */
function remesaProv_generarPartidasBancoRemProv(curPR: FLSqlCursor, valoresDefecto: Array, datosAsiento: Array, remesa: Array): Boolean {
  var util: FLUtil = new FLUtil();
  var ctaHaber: Array = [];
  ctaHaber.codsubcuenta = util.sqlSelect("cuentasbanco", "codsubcuenta", "codcuenta = '" + remesa.codcuenta + "'");
  ctaHaber.idsubcuenta = util.sqlSelect("co_subcuentas", "idsubcuenta", "codsubcuenta = '" + ctaHaber.codsubcuenta + "' AND codejercicio = '" + valoresDefecto.codejercicio + "'");
  if (!ctaHaber.idsubcuenta)
  {
    MessageBox.warning(util.translate("scripts", "No tiene definida la subcuenta %1 en el ejercicio %2.\nAntes de dar el pago debe crear la subcuenta o modificar el ejercicio").arg(ctaHaber.codsubcuenta).arg(valoresDefecto.codejercicio), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }

  var haber: Number = 0;
  var haberME: Number = 0;
  var tasaconvHaber: Number = 1;
  if (valoresDefecto.coddivisa == remesa.coddivisa)
  {
    haber = parseFloat(remesa.total);
    haberME = 0;
  } else {
    tasaconvHaber = curPR.valueBuffer("tasaconv");
    haber = parseFloat(remesa.total) * parseFloat(tasaconvHaber);
    haberME = parseFloat(remesa.total);
  }
  haber = util.roundFieldValue(haber, "co_partidas", "haber");
  haberME = util.roundFieldValue(haberME, "co_partidas", "haberme");

  var curPartida: FLSqlCursor = new FLSqlCursor("co_partidas");
  with(curPartida)
  {
    setModeAccess(curPartida.Insert);
    refreshBuffer();
    setValueBuffer("concepto", curPR.valueBuffer("tipo") + " " + util.translate("scripts", "remesa") + " " + remesa.idremesa);
    setValueBuffer("idsubcuenta", ctaHaber.idsubcuenta);
    setValueBuffer("codsubcuenta", ctaHaber.codsubcuenta);
    setValueBuffer("idasiento", datosAsiento.idasiento);
    setValueBuffer("debe", 0);
    setValueBuffer("haber", haber);
    setValueBuffer("coddivisa", remesa.coddivisa);
    setValueBuffer("tasaconv", tasaconvHaber);
    setValueBuffer("debeME", 0);
    setValueBuffer("haberME", haberME);
  }
  if (!curPartida.commitBuffer())
    return false;

  return true;
}

/** \C Se regenera, si es posible, el asiento contable asociado al pago de una remesa de proveedor
\end */
function remesaProv_beforeCommit_pagosdevolremprov(curPR: FLSqlCursor): Boolean {
  var util: FLUtil = new FLUtil();
  if (sys.isLoadedModule("flcontppal") && flfactppal.iface.pub_valorDefectoEmpresa("contintegrada") && !curPR.valueBuffer("nogenerarasiento"))
  {
    if (!this.iface.generarAsientoPagoRemesaProv(curPR)) {
      debug(1);
      return false;
    }
  }

  return true;
}

/** \C Se elimina, si es posible, el asiento contable asociado al pago o devolución
\end */
function remesaProv_afterCommit_pagosdevolremprov(curPD: FLSqlCursor): Boolean {
  var _i = this.iface;
  var util: FLUtil = new FLUtil();
  if (sys.isLoadedModule("flcontppal") == false || util.sqlSelect("empresa", "contintegrada", "1 = 1") == false)
    return true;

  var pagoIndirecto = _i.valorDefectoTesoreria("pagoindirectoprov");
  var pagoDiferido = _i.valorDefectoTesoreria("pagodiferidoprov");
  switch (curPD.modeAccess())
  {
    case curPD.Del: {
      /// AL contrario que las remesas de cliente, si (pagoDiferido && !pagoIndirecto) los recibos  se marcan como pagados uno a uno.
      //       if (pagoDiferido && !pagoIndirecto) {
      //         /// Pago diferido. Se cambia el estado para forzar el borrado de los asientos de pago
      //         if (!_i.modificaEstadoPagosRemesaProv(curPD.valueBuffer("idremesa"), "Remesado")) {
      //           return false;
      //         }
      //       }
      var idAsiento: Number = curPD.valueBuffer("idasiento");
      if (flfacturac.iface.pub_asientoBorrable(idAsiento) == false)
        return false;

      var curAsiento: FLSqlCursor = new FLSqlCursor("co_asientos");
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
        var idAsientoAnterior: String = curPD.valueBufferCopy("idasiento");
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

function remesaProv_generarAsientoPagoDevolProv(curPD)
{
  var _i = this.iface;
  var util = new FLUtil();
  if (curPD.modeAccess() != curPD.Insert && curPD.modeAccess() != curPD.Edit) {
    return true;
  }

  if (curPD.valueBuffer("nogenerarasiento")) {
    curPD.setNull("idasiento");
    return true;
  }

  if (curPD.valueBuffer("tipo") != "Remesado") {
    return _i.__generarAsientoPagoDevolProv(curPD);
  }
  /// El asiento se genera cuando el tipo pasa a Pago
  curPD.setNull("idasiento"); /// Actúa en el caso de que se borre el pago de la remesa y haya que eliminar los asientos asociados a los pagos que pasan a de Pago a Remesado
  return true;
}

function remesaProv_afterCommit_pagosdevolprov(curPD)
{
  var _i = this.iface;
  if (!_i.__afterCommit_pagosdevolprov(curPD)) {
    return false;
  }

  switch (curPD.modeAccess()) {
    case curPD.Edit: {
      if (curPD.valueBuffer("tipo") == "Remesado") { /// Actúa cuando se cambia el estado del pago
        var idAsientoAnterior = curPD.valueBufferCopy("idasiento");
        if (idAsientoAnterior && idAsientoAnterior != "") {
          if (!flfacturac.iface.pub_eliminarAsiento(idAsientoAnterior)) {
            return false;
          }
        }
      }
      break;
    }
  }

  return true;
}

function remesaProv_modificaEstadoPagosRemesaProv(idRemesa, estado, datosPago)
{
  var _i = this.iface;
  if (!datosPago) {
    datosPago = new Object;
  }
  var idRecibo;
  var curR = new FLSqlCursor("pagosdevolprov");
  var where = "idremesa = " + idRemesa;
  if ("idrecibo" in datosPago) {
    where += " AND idrecibo = " + datosPago.idrecibo;
  }

  curR.select(where);
  if (!_i.curReciboProv) {
    _i.curReciboProv = new FLSqlCursor("recibosprov");
  }
  while (curR.next()) {
    curR.setModeAccess(curR.Edit);
    curR.refreshBuffer();
    idRecibo = curR.valueBuffer("idrecibo");
    curR.setValueBuffer("tipo", estado);
    if ("fecha" in datosPago) {
      curR.setValueBuffer("fecha", datosPago.fecha);
    }
    if (!curR.commitBuffer()) {
      return false;
    }
    _i.curReciboProv.select("idrecibo = " + idRecibo);
    if (!_i.curReciboProv.first()) {
      return false;
    }
    _i.curReciboProv.setModeAccess(_i.curReciboProv.Edit);
    _i.curReciboProv.refreshBuffer();
    _i.curReciboProv.setValueBuffer("estado", formRecordrecibosprov.iface.pub_commonCalculateField("estado", _i.curReciboProv));
    if (!_i.totalesReciboProv()) {
      return false;
    }
    if (!_i.curReciboProv.commitBuffer()) {
      return false;
    }
  }
  return true;
}

function remesaProv_totalesReciboProv()
{
  var _i = this.iface;
  if (!_i.__totalesReciboProv()) {
    return false;
  }
  _i.curReciboProv.setValueBuffer("situacion", formRecordrecibosprov.iface.pub_commonCalculateField("situacion", _i.curReciboProv));
  return true;
}

/** \D Genera la parte del asiento del pago correspondiente a la subcuentas de clientes de una remesa
@param  curPR: Cursor del pago de la remesa
@param  idAsiento: Id del asiento asociado
@param  valoresDefecto: Array con los valores por defecto de ejercicio y divisa
@return VERDADERO si no hay error, FALSO en otro caso
\end */
function remesaProv_generarPartidasProveedorRemProv(curPR, valoresDefecto, datosAsiento, remesa)
{
  var _i = this.iface;

  var debe = 0;
  var debeME = 0;
  var ctaDebe = [];

  var curPartida = new FLSqlCursor("co_partidas");
  var curPD = new FLSqlCursor("pagosdevolprov");
  curPD.select("idremesa = " + remesa.idremesa);
  var codRecibo;
  while (curPD.next()) {
    curPD.setModeAccess(curPD.Browse);
    curPD.refreshBuffer();
    codRecibo = AQUtil.sqlSelect("recibosprov", "codigo", "idrecibo = " + curPD.valueBuffer("idrecibo"));
    ctaDebe = _i.dameSubcuentaProvPD(curPD, valoresDefecto, datosAsiento, remesa);
    if (!ctaDebe) {
      return false;
    }
    debe = AQUtil.sqlSelect("recibosprov", "importe", "idrecibo = " + curPD.valueBuffer("idrecibo"));
    debe = isNaN(debe) ? 0 : debe;
    debeME = 0;
    debe = AQUtil.roundFieldValue(debe, "co_partidas", "debe");
    debeME = AQUtil.roundFieldValue(debeME, "co_partidas", "debeme");

    with(curPartida) {
      setModeAccess(curPartida.Insert);
      refreshBuffer();
      setValueBuffer("concepto", sys.translate("Recibo remesado %1").arg(codRecibo));
      setValueBuffer("idsubcuenta", ctaDebe.idsubcuenta);
      setValueBuffer("codsubcuenta", ctaDebe.codsubcuenta);
      setValueBuffer("idasiento", datosAsiento.idasiento);
      setValueBuffer("debe", debe);
      setValueBuffer("haber", 0);
      setValueBuffer("debeME", debeME);
      setValueBuffer("haberME", 0);
    }
    if (!_i.datosPartidaProvRem(curPartida, curPD, valoresDefecto, datosAsiento, remesa)) {
      return false;
    }

    if (!curPartida.commitBuffer()) {
      return false;
    }
  }

  return true;
}

function remesaProv_datosPartidaProvRem(curPartida, curPD, valoresDefecto, datosAsiento, remesa)
{
  return true;
}

function remesaProv_cargaValoresDefecto()
{
  var _i = this.iface;
  _i.__cargaValoresDefecto();
  _i.pagoIndirectoRemProv_ = _i.valorDefectoTesoreria("pagoindirectoprov");
  _i.pagoDiferidoRemProv_ = _i.valorDefectoTesoreria("pagodiferidoprov");
}


//// REMESAS DE RECIBOS DE PROVEEDOR ////////////////////////////
////////////////////////////////////////////////////////////////
