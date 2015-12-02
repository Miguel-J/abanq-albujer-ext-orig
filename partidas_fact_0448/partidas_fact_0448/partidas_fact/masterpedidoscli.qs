
/** @class_declaration partidas */
/////////////////////////////////////////////////////////////////
//// PARTIDAS FACT //////////////////////////////////////////////
class partidas extends numLinea
{
  var curPartidaAlbaran: FLSqlCursor;
  function partidas(context)
  {
    numLinea(context);
  }
  function datosLineaAlbaran(curLineaPedido: FLSqlCursor): Boolean {
    return this.ctx.partidas_datosLineaAlbaran(curLineaPedido);
  }
  function datosAlbaran(curPedido: FLSqlCursor, where: String, datosAgrupacion: Array): Boolean {
    return this.ctx.partidas_datosAlbaran(curPedido, where, datosAgrupacion);
  }
  function commonCalculateField(fN: String, cursor: FLSqlCursor): String {
    return this.ctx.partidas_commonCalculateField(fN, cursor);
  }
  function generarAlbaran(where: String, curPedido: FLSqlCursor, datosAgrupacion: Array): Number {
    return this.ctx.partidas_generarAlbaran(where, curPedido, datosAgrupacion);
  }
  function copiaPartidas(idPedido: Number, idAlbaran: Number): Boolean {
    return this.ctx.partidas_copiaPartidas(idPedido, idAlbaran);
  }
  function copiaPartidaPedido(curPartPedido: FLSqlCursor, idAlbaran: Number): Number {
    return this.ctx.partidas_copiaPartidaPedido(curPartPedido, idAlbaran);
  }
  function datosPartidaAlbaran(curPartPedido: FLSqlCursor, idAlbaran: String): Boolean {
    return this.ctx.partidas_datosPartidaAlbaran(curPartPedido, idAlbaran);
  }
}
//// PARTIDAS FACT //////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition partidas */
/////////////////////////////////////////////////////////////////
//// PARTIDAS FACT //////////////////////////////////////////////
function partidas_datosLineaAlbaran(curLineaPedido: FLSqlCursor): Boolean {
  var util: FLUtil = new FLUtil();
  if (!this.iface.__datosLineaAlbaran(curLineaPedido))
  {
    return false;
  }

  var idPartidaAlb: String = util.sqlSelect("partidasalb", "idpartidaalb", "idalbaran = " + this.iface.curLineaAlbaran.valueBuffer("idalbaran") + " AND idpartidao = " + curLineaPedido.valueBuffer("idpartidaped"));

  var ordenPartidaAlb: String = util.sqlSelect("partidasalb", "orden", "idalbaran = " + this.iface.curLineaAlbaran.valueBuffer("idalbaran") + " AND idpartidao = " + curLineaPedido.valueBuffer("idpartidaped"));

  with(this.iface.curLineaAlbaran)
  {
    if (!curLineaPedido.isNull("idpartidaped")) {
      setValueBuffer("idpartidaalb", idPartidaAlb);
    }

    setValueBuffer("numlinea", curLineaPedido.valueBuffer("numlinea"));

    if (curLineaPedido.isNull("ordenpartida")) {
      setNull("ordenpartida");
    } else {
      setValueBuffer("ordenpartida", ordenPartidaAlb);
    }
  }
  return true;
}

function partidas_datosAlbaran(curPedido: FLSqlCursor, where: String, datosAgrupacion: Array): Boolean {
  if (!this.iface.__datosAlbaran(curPedido, where, datosAgrupacion))
    return false;

  this.iface.curAlbaran.setValueBuffer("titulo", curPedido.valueBuffer("titulo"));
  this.iface.curAlbaran.setValueBuffer("porgastos", curPedido.valueBuffer("porgastos"));
  this.iface.curAlbaran.setValueBuffer("gastos", curPedido.valueBuffer("gastos"));
  this.iface.curAlbaran.setValueBuffer("porbeneficio", curPedido.valueBuffer("porbeneficio"));
  this.iface.curAlbaran.setValueBuffer("beneficio", curPedido.valueBuffer("beneficio"));

  return true;
}

function partidas_commonCalculateField(fN: String, cursor: FLSqlCursor): String {
  var util = new FLUtil();
  var valor;

  switch (fN)
  {
    case "totaliva": {
      var porDto: Number = cursor.valueBuffer("pordtoesp");
      porDto = (isNaN(porDto) ? 0 : porDto);
      var porGastos: Number = cursor.valueBuffer("porgastos");
      porGastos = (isNaN(porGastos) ? 0 : porGastos);
      var porBeneficio: Number = cursor.valueBuffer("porbeneficio");
      porBeneficio = (isNaN(porBeneficio) ? 0 : porBeneficio);
      if (porGastos == 0 && porBeneficio == 0) {
        valor = this.iface.__commonCalculateField(fN, cursor);
        break;
      }
      var por: Number = parseFloat(porGastos) + parseFloat(porBeneficio) - parseFloat(porDto);
      valor = util.sqlSelect("lineaspedidoscli", "SUM((pvptotal * iva * (100 + " + por + ")) / 100 / 100)", "idpedido = " + cursor.valueBuffer("idpedido"));
      valor = parseFloat(util.roundFieldValue(valor, "pedidoscli", "totaliva"));
      break;
    }
    case "totalrecargo": {
      var porDto: Number = cursor.valueBuffer("pordtoesp");
      var porGastos: Number = cursor.valueBuffer("porgastos");
      var porBeneficio: Number = cursor.valueBuffer("porbeneficio");
      if (!porGastos || porGastos == 0 && !porBeneficio || porBeneficio == 0) {
        valor = this.iface.__commonCalculateField(fN, cursor);
        break;
      }
      var por: Number = parseFloat(porGastos) + parseFloat(porBeneficio) - parseFloat(porDto);
      valor = util.sqlSelect("lineaspedidoscli", "SUM((pvptotal * recargo * (100 + " + por + ")) / 100 / 100)", "idpedido = " + cursor.valueBuffer("idpedido"));
      valor = parseFloat(util.roundFieldValue(valor, "pedidoscli", "totalrecargo"));
      break;
    }
    /** \C
    El --neto-- es el --netosindtoesp-- menos el --dtoesp-- mas --gastos generales-- mas --beneficio--
    \end */
    case "neto": {
      valor = parseFloat(cursor.valueBuffer("netosindtoesp")) - parseFloat(cursor.valueBuffer("dtoesp")) + parseFloat(cursor.valueBuffer("gastos")) + parseFloat(cursor.valueBuffer("beneficio"));
      valor = parseFloat(util.roundFieldValue(valor, "pedidoscli", "neto"));
      break;
    }
    /** \C
    El valor --gastos-- es el --netosindtoesp-- menos el porcentaje que marca el --porgastos--
    \end */
    case "gastos": {
      valor = (parseFloat(cursor.valueBuffer("netosindtoesp")) * parseFloat(cursor.valueBuffer("porgastos"))) / 100;
      valor = parseFloat(util.roundFieldValue(valor, "pedidoscli", "gastos"));
      break;
    }
    /** \C
    El --porgastos-- es el valor --gastos-- entre el --netosindtoesp-- por 100
    \end */
    case "porgastos": {
      if (parseFloat(cursor.valueBuffer("netosindtoesp")) != 0) {
        valor = (parseFloat(cursor.valueBuffer("gastos")) / parseFloat(cursor.valueBuffer("netosindtoesp"))) * 100;
      } else {
        valor = cursor.valueBuffer("porgastos");
      }
      valor = parseFloat(util.roundFieldValue(valor, "pedidoscli", "porgastos"));
      break;
    }
    /** \C
    El valor --beneficio-- es el --netosindtoesp-- menos el porcentaje que marca el --porbeneficio--
    \end */
    case "beneficio": {
      valor = (parseFloat(cursor.valueBuffer("netosindtoesp")) * parseFloat(cursor.valueBuffer("porbeneficio"))) / 100;
      valor = parseFloat(util.roundFieldValue(valor, "pedidoscli", "beneficio"));
      break;
    }
    /** \C
    El --porbeneficio-- es el valor --beneficio-- entre el --netosindtoesp-- por 100
    \end */
    case "porbeneficio": {
      if (parseFloat(cursor.valueBuffer("netosindtoesp")) != 0) {
        valor = (parseFloat(cursor.valueBuffer("beneficio")) / parseFloat(cursor.valueBuffer("netosindtoesp"))) * 100;
      } else {
        valor = cursor.valueBuffer("porbeneficio");
      }
      valor = parseFloat(util.roundFieldValue(valor, "pedidoscli", "porbeneficio"));
      break;
    }
    default: {
      valor = this.iface.__commonCalculateField(fN, cursor);
      break;
    }
  }
  return valor;
}

function partidas_generarAlbaran(where: String, curPedido: FLSqlCursor, datosAgrupacion: Array): Number {
  this.iface.numLinea_ = 0;

  if (!this.iface.curAlbaran)
    this.iface.curAlbaran = new FLSqlCursor("albaranescli");

  this.iface.curAlbaran.setModeAccess(this.iface.curAlbaran.Insert);
  this.iface.curAlbaran.refreshBuffer();

  if (!this.iface.datosAlbaran(curPedido, where, datosAgrupacion))
    return false;

  if (!this.iface.curAlbaran.commitBuffer())
  {
    return false;
  }

  var idAlbaran: Number = this.iface.curAlbaran.valueBuffer("idalbaran");

  if (!this.iface.copiaPartidas(curPedido.valueBuffer("idpedido"), idAlbaran))
  {
    return false;
  }

  var qryPedidos: FLSqlQuery = new FLSqlQuery();
  qryPedidos.setTablesList("pedidoscli");
  qryPedidos.setSelect("idpedido");
  qryPedidos.setFrom("pedidoscli");
  qryPedidos.setWhere(where);

  if (!qryPedidos.exec())
    return false;

  var idPedido: String;
  while (qryPedidos.next())
  {
    idPedido = qryPedidos.value(0);
    if (!this.iface.copiaLineas(idPedido, idAlbaran))
      return false;
  }

  this.iface.curAlbaran.select("idalbaran = " + idAlbaran);
  if (this.iface.curAlbaran.first())
  {
    this.iface.curAlbaran.setModeAccess(this.iface.curAlbaran.Edit);
    this.iface.curAlbaran.refreshBuffer();

    if (!this.iface.totalesAlbaran())
      return false;

    if (this.iface.curAlbaran.commitBuffer() == false)
      return false;
  }
  return idAlbaran;
}

function partidas_copiaPartidas(idPedido: Number, idAlbaran: Number): Boolean {
  var curPartPedido: FLSqlCursor = new FLSqlCursor("partidasped");
  curPartPedido.select("idpedido = " + idPedido);
  while (curPartPedido.next())
  {
    curPartPedido.setModeAccess(curPartPedido.Browse);
    curPartPedido.refreshBuffer();
    if (!this.iface.copiaPartidaPedido(curPartPedido, idAlbaran))
      return false;
  }
  return true;
}

function partidas_copiaPartidaPedido(curPartPedido: FLSqlCursor, idAlbaran: Number): Number {
  if (!this.iface.curPartidaAlbaran)
    this.iface.curPartidaAlbaran = new FLSqlCursor("partidasalb");

  with(this.iface.curPartidaAlbaran)
  {
    setModeAccess(Insert);
    refreshBuffer();
    setValueBuffer("idalbaran", idAlbaran);
  }

  if (!this.iface.datosPartidaAlbaran(curPartPedido, idAlbaran))
    return false;

  this.iface.curPartidaAlbaran.setActivatedCommitActions(false);
  if (!this.iface.curPartidaAlbaran.commitBuffer())
    return false;

  return this.iface.curPartidaAlbaran.valueBuffer("idpartidaalb");
}

function partidas_datosPartidaAlbaran(curPartPedido: FLSqlCursor, idAlbaran: String): Boolean {
  with(this.iface.curPartidaAlbaran)
  {
    setValueBuffer("idalbaran", idAlbaran);
    setValueBuffer("orden", curPartPedido.valueBuffer("orden"));
    setValueBuffer("descripcion", curPartPedido.valueBuffer("descripcion"));
    setValueBuffer("codpartidacat", curPartPedido.valueBuffer("codpartidacat"));
    setValueBuffer("idpartidao", curPartPedido.valueBuffer("idpartidaped"));
  }
  return true;
}

//// PARTIDAS FACT //////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
