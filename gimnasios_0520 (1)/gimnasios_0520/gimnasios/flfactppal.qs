
/** @class_declaration gym */
/////////////////////////////////////////////////////////////////
//// GIMNASIOS //////////////////////////////////////////////////
class gym extends oficial
{
  var curContrato_: FLSqlCursor;
  function gym(context)
  {
    oficial(context);
  }
  function beforeCommit_bonosgym(curBono: FLSqlCursor): Boolean {
    return this.ctx.gym_beforeCommit_bonosgym(curBono);
  }
  function sincronizarBonoFact(curBono: FLSqlCursor): Boolean {
    return this.ctx.gym_sincronizarBonoFact(curBono);
  }
  function borrarFacturaBono(idFactura: String): Boolean {
    return this.ctx.gym_borrarFacturaBono(idFactura);
  }
  function cambioFacturaBono(curBono: FLSqlCursor): Boolean {
    return this.ctx.gym_cambioFacturaBono(curBono);
  }
  function sincronizarBonoCont(curBono: FLSqlCursor): Boolean {
    return this.ctx.gym_sincronizarBonoCont(curBono);
  }
  function crearContratoBono(curBono: FLSqlCursor): String {
    return this.ctx.gym_crearContratoBono(curBono);
  }
  function datosContrato(curBono: FLSqlCursor): Boolean {
    return this.ctx.gym_datosContrato(curBono);
  }
  function actualizarSesionesCliente(curBono: FLSqlCursor): Boolean {
    return this.ctx.gym_actualizarSesionesCliente(curBono);
  }
}
//// GIMNASIOS //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition gym */
/////////////////////////////////////////////////////////////////
//// GIMNASIOS //////////////////////////////////////////////////
function gym_beforeCommit_bonosgym(curBono: FLSqlCursor): Boolean {
  if (curBono.valueBuffer("tipo") == "Bono")
  {
    if (!this.iface.sincronizarBonoFact(curBono)) {
      return false;
    }
  } else {
    if (!this.iface.sincronizarBonoCont(curBono))
    {
      return false;
    }
  }
  if (!this.iface.actualizarSesionesCliente(curBono))
  {
    return false;
  }
  return true;
}

/** \D Actualiza los datos de sesiones disponibles del cliente asociado al bono
@param curBono: Cursor del bono
\end */
function gym_actualizarSesionesCliente(curBono: FLSqlCursor): Boolean {
  var util: FLUtil = new FLUtil;
  var curRel: FLSqlCursor = curBono.cursorRelation();
  if (curRel && curRel.table() == "clientes")
  {
    return true;
  }
  var codCliente: String = curBono.valueBuffer("codcliente");
  var codClientePrevio: String = curBono.valueBufferCopy("codcliente");
  var curCliente: FLSqlCursor = new FLSqlCursor("clientes");
  curCliente.setActivatedCommitActions(false);

  if (codCliente && codCliente != "")
  {
    curCliente.select("codcliente = '" + codCliente + "'");
    if (!curCliente.first()) {
      MessageBox.warning(util.translate("scripts", "Error al actualizar los datos de sesiones del cliente %1").arg(codCliente), MessageBox.Ok, MessageBox.NoButton);
      return false;
    }

    curCliente.setModeAccess(curCliente.Edit);
    curCliente.refreshBuffer();
    curCliente.setValueBuffer("cansesionesdisp", formRecordclientes.iface.pub_commonCalculateField("cansesionesdisp", curCliente));
    if (!curCliente.commitBuffer()) {
      return false;
    }
  }
  if (codClientePrevio && codClientePrevio != "" && codClientePrevio != codCliente)
  {
    curCliente.select("codcliente = '" + codClientePrevio + "'");
    if (!curCliente.first()) {
      MessageBox.warning(util.translate("scripts", "Error al actualizar los datos de sesiones del cliente %1").arg(codClientePrevio), MessageBox.Ok, MessageBox.NoButton);
      return false;
    }

    curCliente.setModeAccess(curCliente.Edit);
    curCliente.refreshBuffer();
    curCliente.setValueBuffer("cansesionesdisp", formRecordclientes.iface.pub_commonCalculateField("cansesionesdisp", curCliente));
    if (!curCliente.commitBuffer()) {
      return false;
    }
  }

  return true;
}

/** \D Sincroniza un bono de tipo Bono con su correspondiente factura
@param curBono: Cursor del bono
\end */
function gym_sincronizarBonoFact(curBono: FLSqlCursor): Boolean {
  var util: FLUtil;

  var idFactura: String;
  switch (curBono.modeAccess())
  {
    case curBono.Insert: {
      if (curBono.valueBuffer("facturar")) {
        idFactura = formalbaranescli.iface.pub_crearFacturaBono(curBono);
        if (!idFactura) {
          return false;
        }
        curBono.setValueBuffer("idfactura", idFactura);
        curBono.setValueBuffer("codfactura", util.sqlSelect("facturascli", "codigo", "idfactura = " + idFactura));
      }
      break;
    }
    case curBono.Edit: {
      var idFactura: String;
      if (!this.iface.cambioFacturaBono(curBono)) {
        break;
      }
      idFactura = curBono.valueBuffer("idfactura");
      if (!this.iface.borrarFacturaBono(idFactura)) {
        return false;
      }
      if (curBono.valueBuffer("facturar")) {
        idFactura = formalbaranescli.iface.pub_crearFacturaBono(curBono);
        if (!idFactura) {
          return false;
        }
        curBono.setValueBuffer("idfactura", idFactura);
        curBono.setValueBuffer("codfactura", util.sqlSelect("facturascli", "codigo", "idfactura = " + idFactura));
      } else {
        curBono.setNull("idfactura");
        curBono.setNull("codfactura");
      }
      break;
    }
    case curBono.Del: {
      idFactura = curBono.valueBuffer("idfactura");
      if (!this.iface.borrarFacturaBono(idFactura)) {
        return false;
      }
      break;
    }
  }
  return true;
}

/** \D Sincroniza un bono de tipo Suscripción con su correspondiente contrato
@param curBono: Cursor del bono
\end */
function gym_sincronizarBonoCont(curBono: FLSqlCursor): Boolean {
  var util: FLUtil;

  var codContrato: String;
  switch (curBono.modeAccess())
  {
    case curBono.Insert: {
      codContrato = this.iface.crearContratoBono(curBono);
      if (!codContrato) {
        return false;
      }
      curBono.setValueBuffer("codcontrato", codContrato);
      break;
    }
    case curBono.Edit: {
      break;
    }
    case curBono.Del: {
      var codContrato: String = util.sqlSelect("contratos", "codigo", "codigo = '" + curBono.valueBuffer("codcontrato") + "'");
      if (codContrato && codContrato != "") {
        MessageBox.warning(util.translate("scripts", "Antes de borrar la suscripción debe borrar su contrato asociado (Nº %1)").arg(codContrato), MessageBox.Ok, MessageBox.NoButton);
        return false;
      }
      //      codContrato = curBono.valueBuffer("codcontrato");
      //      if (!this.iface.borrarContratoBono(codContrato)) {
      //        return false;
      //      }
      break;
    }
  }
  return true;
}

/** \D Crea un contrato asociado a un bono
@param curBono: Cursor del bono
@return Código del contrato
\end */
function gym_crearContratoBono(curBono: FLSqlCursor): String {
  if (!this.iface.curContrato_)
  {
    this.iface.curContrato_ = new FLSqlCursor("contratos");
  }

  this.iface.curContrato_.setModeAccess(this.iface.curContrato_.Insert);
  this.iface.curContrato_.refreshBuffer();

  if (!this.iface.datosContrato(curBono))
  {
    return false;
  }

  var codContrato: String = this.iface.curContrato_.valueBuffer("codigo");
  if (!this.iface.curContrato_.commitBuffer())
  {
    return false;
  }

  return codContrato;
}

/** \D Crea un contrato asociado a un bono
@param curBono: Cursor del bono
@return Código del contrato
\end */
function gym_datosContrato(curBono: FLSqlCursor): Boolean {
  var util: FLUtil = new FLUtil;

  var codTipoContrato: String = curBono.valueBuffer("codtipocontrato");
  var codCliente: String = curBono.valueBuffer("codclientefact");
  var referencia: String = util.sqlSelect("tiposcontrato", "referencia", "codigo = '" + codTipoContrato + "'")
  this.iface.curContrato_.setValueBuffer("codigo", util.nextCounter("codigo", this.iface.curContrato_));
  this.iface.curContrato_.setValueBuffer("estado", "Vigente");
  this.iface.curContrato_.setValueBuffer("codcliente", codCliente);
  this.iface.curContrato_.setValueBuffer("nombrecliente", util.sqlSelect("clientes", "nombre", "codcliente = '" + codCliente + "'"));
  this.iface.curContrato_.setValueBuffer("periodopago", util.sqlSelect("tiposcontrato", "periodopago", "codigo = '" + codTipoContrato + "'"));
  this.iface.curContrato_.setValueBuffer("factprimeromes", util.sqlSelect("tiposcontrato", "factprimeromes", "codigo = '" + codTipoContrato + "'"));
  this.iface.curContrato_.setValueBuffer("fechainicio", curBono.valueBuffer("fechainicio"));
  this.iface.curContrato_.setValueBuffer("tipocontrato", codTipoContrato);
  this.iface.curContrato_.setValueBuffer("referencia", referencia);
  this.iface.curContrato_.setValueBuffer("descripcion", util.translate("scripts", "Suscripción %1 de %2 para %3").arg(codTipoContrato).arg(util.dateAMDtoDMA(curBono.valueBuffer("fechainicio"))).arg(curBono.valueBuffer("nombrecliente")));
  this.iface.curContrato_.setValueBuffer("codimpuesto", util.sqlSelect("articulos", "codimpuesto", "referencia = '" + referencia + "'"));
  this.iface.curContrato_.setValueBuffer("coste", util.sqlSelect("tiposcontrato", "coste", "codigo = '" + codTipoContrato + "'"));

  return true;
}


/** \D Indica si en el cursor ha cambiado algún campo que implique la regeneración de la factura asociada
@param curBono: Cursor del bono
\end */
function gym_cambioFacturaBono(curBono: FLSqlCursor): Boolean {
  if (curBono.valueBufferCopy("facturar") != curBono.valueBuffer("facturar") || curBono.valueBufferCopy("pvp") != curBono.valueBuffer("pvp") || curBono.valueBufferCopy("codpago") != curBono.valueBuffer("codpago") || curBono.valueBufferCopy("fechacompra") != curBono.valueBuffer("fechacompra") || curBono.valueBufferCopy("codclientefact") != curBono.valueBuffer("codclientefact"))
  {
    return true;
  }
  return false;
}

function gym_borrarFacturaBono(idFactura: String): Boolean {
  var util: FLUtil = new FLUtil;

  if (!idFactura)
  {
    return true;
  }

  if (sys.isLoadedModule("flfactteso") && util.sqlSelect("reciboscli", "idrecibo", "idfactura = " + idFactura + " AND estado <> 'Emitido'"))
  {

    var codFactura: String = util.sqlSelect("facturascli", "codigo", "idfactura = " + idFactura);
    var res: Number = MessageBox.warning(util.translate("scripts", "La factura actual %1 asociada al bono tiene recibos ya pagados.\nPara continuar dichos pagos serán eliminados.\n¿Desea continuar?").arg(codFactura), MessageBox.Yes, MessageBox.No);
    if (res != MessageBox.Yes) {
      return false;
    }

    var qryRecibos: FLSqlQuery = new FLSqlQuery();
    qryRecibos.setTablesList("reciboscli,pagosdevolcli");
    qryRecibos.setSelect("idpagodevol");
    qryRecibos.setFrom("reciboscli r INNER JOIN pagosdevolcli p ON r.idrecibo = p.idrecibo");
    qryRecibos.setWhere("r.idfactura = " + idFactura + " ORDER BY p.idrecibo, p.fecha DESC, p.idpagodevol DESC");
    try {
      qryRecibos.setForwardOnly(true);
    } catch (e) {}
    if (!qryRecibos.exec()) {
      return false;
    }

    var curPagos: FLSqlCursor = new FLSqlCursor("pagosdevolcli");
    while (qryRecibos.next()) {
      curPagos.select("idpagodevol = " + qryRecibos.value(0));
      if (!curPagos.first())
        return false;

      curPagos.setModeAccess(curPagos.Del);
      if (!curPagos.refreshBuffer())
        return false;;

      if (!curPagos.commitBuffer())
        return false;
    }
  }

  if (!util.sqlDelete("facturascli", "idfactura = " + idFactura))
  {
    return false;
  }

  return true;
}

//// GIMNASIOS //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
