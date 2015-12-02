
/** @class_declaration modelo347 */
/////////////////////////////////////////////////////////////////
//// MODELO 347 /////////////////////////////////////////////
class modelo347 extends oficial
{
  function modelo347(context)
  {
    oficial(context);
  }
  function beforeCommit_cobrosterceros(curCT)
  {
    return this.ctx.modelo347_beforeCommit_cobrosterceros(curCT);
  }
  function afterCommit_cobrosterceros(curCT)
  {
    return this.ctx.modelo347_afterCommit_cobrosterceros(curCT);
  }
  function generarAsientoCobro(curCT)
  {
    return this.ctx.modelo347_generarAsientoCobro(curCT);
  }
  function generarAsientoPago(curCT)
  {
    return this.ctx.modelo347_generarAsientoPago(curCT)
  }
         function generarPartidasCobroCliente(curCT, idAsiento, valoresDefecto, ctaCliente)
  {
    return this.ctx.modelo347_generarPartidasCobroCliente(curCT, idAsiento, valoresDefecto, ctaCliente);
  }
  function generarPartidasCobroBanco(curCT, valoresDefecto, datosAsiento)
  {
    return this.ctx.modelo347_generarPartidasCobroBanco(curCT, valoresDefecto, datosAsiento);
  }
}
//// MODELO 347 /////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition modelo347 */
/////////////////////////////////////////////////////////////////
//// MODELO 347 /////////////////////////////////////////////
function modelo347_beforeCommit_cobrosterceros(curCT)
{
  var _i = this.iface;
  if (curCT.modeAccess() == curCT.Insert || curCT.modeAccess() == curCT.Edit) {
    if (sys.isLoadedModule("flcontppal")) {
      if (_i.generarAsientoCobro(curCT) == false) {
        return false;
      }

      if (curCT.valueBuffer("pagado")) {
        if (_i.generarAsientoPago(curCT) == false) {
          return false;
        }
      }
    }
  }

  return true;
}

function modelo347_afterCommit_cobrosterceros(curCT)
{
  var _i = this.iface;

  switch (curCT.modeAccess()) {
    case curCT.Del: {
      if (!curCT.isNull("idasientocobro")) {
        var idAsientoCobro = curCT.valueBuffer("idasientocobro");
        if (flfacturac.iface.pub_asientoBorrable(idAsientoCobro) == false)
          return false;

        if (!flfacturac.iface.pub_eliminarAsiento(idAsientoCobro)) {
          return false;
        }
      }

      if (!curCT.isNull("idasientopago")) {
        var idAsientoPago = curCT.valueBuffer("idasientopago");
        if (flfacturac.iface.pub_asientoBorrable(idAsientoPago) == false)
          return false;

        if (!flfacturac.iface.pub_eliminarAsiento(idAsientoPago)) {
          return false;
        }
      }
      break;
    }
    case curCT.Edit: {
      var idAsientoAnteriorC = curCT.valueBufferCopy("idasientocobro");
      if (idAsientoAnteriorC && idAsientoAnteriorC != "") {
        if (!flfacturac.iface.pub_eliminarAsiento(idAsientoAnteriorC))
          return false;
      }

      var idAsientoAnteriorP = curCT.valueBufferCopy("idasientopago");
      if (idAsientoAnteriorP && idAsientoAnteriorP != "") {
        if (!flfacturac.iface.pub_eliminarAsiento(idAsientoAnteriorP)) {
          return false;
        }
      }
      break;
    }
  }
  return true;
}

function modelo347_generarAsientoPago(curCT)
{
  var _i = this.iface;

  if (curCT.modeAccess() != curCT.Insert && curCT.modeAccess() != curCT.Edit)
    return true;

  var datosAsiento = [];
  var valoresDefecto = [];
  valoresDefecto["codejercicio"] = curCT.valueBuffer("codejercicio");
  valoresDefecto["coddivisa"] = flfactppal.iface.pub_valorDefectoEmpresa("coddivisa");
  valoresDefecto["campofecha"] = "fechapago";

  var idAsientoCobro = curCT.valueBuffer("idasientocobro");
  if (!idAsientoCobro)
    return false;

  var curTransaccion = new FLSqlCursor("empresa");
  curTransaccion.transaction(false);
  try {
    datosAsiento = flfacturac.iface.pub_regenerarAsiento(curCT, valoresDefecto);
    if (datosAsiento.error == true)
      throw AQUtil.translate("scripts", "Error al regenerar el asiento");

    if (!_i.generarAsientoInverso(datosAsiento.idasiento, idAsientoCobro, curCT.valueBuffer("concepto"), valoresDefecto.codejercicio))
      throw AQUtil.translate("scripts", "Error al generar las parrtidas de pago");

    curCT.setValueBuffer("idasientopago", datosAsiento.idasiento);

    if (!flcontppal.iface.pub_comprobarAsiento(datosAsiento.idasiento))
      throw AQUtil.translate("scripts", "Error al comprobar el asiento");

  } catch (e) {
    curTransaccion.rollback();
    MessageBox.warning(AQUtil.translate("scripts", "Error al generar el asiento de pago") + "\n" + e, MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  curTransaccion.commit();

  return true;
}

function modelo347_generarAsientoCobro(curCT)
{
  var _i = this.iface;

  if (curCT.modeAccess() != curCT.Insert && curCT.modeAccess() != curCT.Edit)
    return true;

  var datosAsiento = [];
  var valoresDefecto = [];
  valoresDefecto["codejercicio"] = curCT.valueBuffer("codejercicio");
  valoresDefecto["coddivisa"] = flfactppal.iface.pub_valorDefectoEmpresa("coddivisa");
  valoresDefecto["campofecha"] = "fechacobro";

  var curTransaccion = new FLSqlCursor("empresa");
  curTransaccion.transaction(false);
  try {
    datosAsiento = flfacturac.iface.pub_regenerarAsiento(curCT, valoresDefecto);
    if (datosAsiento.error == true)
      throw AQUtil.translate("scripts", "Error al regenerar el asiento");

    var ctaCliente = flfactppal.iface.pub_datosCtaCliente(curCT.valueBuffer("codcliente"), valoresDefecto);
    if (ctaCliente.error != 0)
      throw AQUtil.translate("scripts", "Error al leer los datos de subcuenta de cliente");

    if (!_i.generarPartidasCobroCliente(curCT, datosAsiento.idasiento, valoresDefecto, ctaCliente))
      throw AQUtil.translate("scripts", "Error al generar las partidas de cliente");

    if (!_i.generarPartidasCobroBanco(curCT, valoresDefecto, datosAsiento))
      throw AQUtil.translate("scripts", "Error al generar las partidas de venta");

    curCT.setValueBuffer("idasientocobro", datosAsiento.idasiento);

    if (!flcontppal.iface.pub_comprobarAsiento(datosAsiento.idasiento))
      throw AQUtil.translate("scripts", "Error al comprobar el asiento");

  } catch (e) {
    curTransaccion.rollback();
    MessageBox.warning(AQUtil.translate("scripts", "Error al generar el asiento de cobro") + "\n" + e, MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  curTransaccion.commit();

  return true;
}

function modelo347_generarPartidasCobroCliente(curCT, idAsiento, valoresDefecto, ctaCliente)
{
  var _i = this.iface;
  var haber = 0;
  var haberME = 0;

  haber = parseFloat(curCT.valueBuffer("importe"));
  haberME = haber;

  haber = AQUtil.roundFieldValue(haber, "co_partidas", "debe");
  haberME = AQUtil.roundFieldValue(haberME, "co_partidas", "debeme");

  var curPartida = new FLSqlCursor("co_partidas");

  with(curPartida) {
    setModeAccess(curPartida.Insert);
    refreshBuffer();
    setValueBuffer("idsubcuenta", ctaCliente.idsubcuenta);
    setValueBuffer("codsubcuenta", ctaCliente.codsubcuenta);
    setValueBuffer("concepto", curCT.valueBuffer("concepto"));
    setValueBuffer("idasiento", idAsiento);
    setValueBuffer("debe", 0);
    setValueBuffer("haber", haber);
    setValueBuffer("coddivisa", valoresDefecto.coddivisa);
    setValueBuffer("tasaconv", 1);
    setValueBuffer("debeME", 0);
    setValueBuffer("haberME", haberME);
  }

  if (!curPartida.commitBuffer())
    return false;

  return true;
}

function modelo347_generarPartidasCobroBanco(curCT, valoresDefecto, datosAsiento)
{
  var _i = this.iface;

  var ctaDebe = [];
  var codCuenta = curCT.valueBuffer("codcuenta");
  if (!codCuenta || codCuenta == "")
    return false;

  ctaDebe.codsubcuenta = AQUtil.sqlSelect("cuentasbanco", "codsubcuenta", "codcuenta = '" + codCuenta + "'");
  ctaDebe.idsubcuenta = AQUtil.sqlSelect("co_subcuentas", "idsubcuenta", "codsubcuenta = '" + ctaDebe.codsubcuenta + "' AND codejercicio = '" + valoresDefecto.codejercicio + "'");
  if (!ctaDebe.idsubcuenta) {
    MessageBox.warning(sys.translate("No tiene definida la subcuenta %1 en el ejercicio %2.\nAntes de crear el cobro debe crear la subcuenta o modificar el ejercicio").arg(ctaDebe.codsubcuenta).arg(valoresDefecto.codejercicio), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }

  var debe = 0;
  var debeME = 0;
  var tasaConvDebe = 1;

  debe = parseFloat(curCT.valueBuffer("importe"));
  debeME = debe;

  debe = AQUtil.roundFieldValue(debe, "co_partidas", "debe");
  debeME = AQUtil.roundFieldValue(debeME, "co_partidas", "debeme");

  var curPartida = new FLSqlCursor("co_partidas");
  with(curPartida) {
    setModeAccess(curPartida.Insert);
    refreshBuffer();

    setValueBuffer("concepto", datosAsiento.concepto);

    setValueBuffer("idsubcuenta", ctaDebe.idsubcuenta);
    setValueBuffer("codsubcuenta", ctaDebe.codsubcuenta);
    setValueBuffer("idasiento", datosAsiento.idasiento);

    setValueBuffer("debe", debe);
    setValueBuffer("haber", 0);

    setValueBuffer("coddivisa", valoresDefecto.coddivisa);
    setValueBuffer("tasaconv", tasaConvDebe);
    setValueBuffer("debeME", debeME);
    setValueBuffer("haberME", 0);
  }
  if (!curPartida.commitBuffer())
    return false;

  return true;
}
//// MODELO 347 /////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
