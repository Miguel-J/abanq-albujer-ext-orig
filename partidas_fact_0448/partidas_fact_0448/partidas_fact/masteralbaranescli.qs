
/** @class_declaration partidas */
/////////////////////////////////////////////////////////////////
//// PARTIDAS FACT //////////////////////////////////////////////
class partidas extends numLinea
{
  var curPartidaFactura: FLSqlCursor;
  function partidas(context)
  {
    numLinea(context);
  }
  function datosLineaFactura(curLineaAlbaran: FLSqlCursor): Boolean {
    return this.ctx.partidas_datosLineaFactura(curLineaAlbaran);
  }
  function datosFactura(curAlbaran: FLSqlCursor, where: String, datosAgrupacion: Array): Boolean {
    return this.ctx.partidas_datosFactura(curAlbaran, where, datosAgrupacion);
  }
  function commonCalculateField(fN: String, cursor: FLSqlCursor): String {
    return this.ctx.partidas_commonCalculateField(fN, cursor);
  }
  function generarFactura(where: String, curAlbaran: FLSqlCursor, datosAgrupacion: Array): Number {
    return this.ctx.partidas_generarFactura(where, curAlbaran, datosAgrupacion);
  }
  function copiaPartidas(idAlbaran: Number, idFactura: Number): Boolean {
    return this.ctx.partidas_copiaPartidas(idAlbaran, idFactura);
  }
  function copiaPartidaAlbaran(curPartAlbaran: FLSqlCursor, idFactura: Number): Number {
    return this.ctx.partidas_copiaPartidaAlbaran(curPartAlbaran, idFactura);
  }
  function datosPartidaFactura(curPartAlbaran: FLSqlCursor, idFactura: String): Boolean {
    return this.ctx.partidas_datosPartidaFactura(curPartAlbaran, idFactura);
  }
}
//// PARTIDAS FACT //////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition partidas */
/////////////////////////////////////////////////////////////////
//// PARTIDAS FACT //////////////////////////////////////////////
function partidas_datosLineaFactura(curLineaAlbaran: FLSqlCursor): Boolean {
  var util: FLUtil = new FLUtil();
  if (!this.iface.__datosLineaFactura(curLineaAlbaran))
  {

    return false;
  }

  var idPartidaFact: String = util.sqlSelect("partidasfact", "idpartidafact", "idfactura = " + this.iface.curLineaFactura.valueBuffer("idfactura") + " AND idpartidao = " + curLineaAlbaran.valueBuffer("idpartidaalb"));

  var ordenPartidaFact: String = util.sqlSelect("partidasfact", "orden", "idfactura = " + this.iface.curLineaFactura.valueBuffer("idfactura") + " AND idpartidao = " + curLineaAlbaran.valueBuffer("idpartidaalb"));

  with(this.iface.curLineaFactura)
  {
    if (!curLineaAlbaran.isNull("idpartidaalb")) {
      setValueBuffer("idpartidafact", idPartidaFact);
    }

    setValueBuffer("numlinea", curLineaAlbaran.valueBuffer("numlinea"));

    if (curLineaAlbaran.isNull("ordenpartida")) {
      setNull("ordenpartida");
    } else {
      setValueBuffer("ordenpartida", ordenPartidaFact);
    }
  }

  return true;
}

function partidas_datosFactura(curAlbaran: FLSqlCursor, where: String, datosAgrupacion: Array): Boolean {
  if (!this.iface.__datosFactura(curAlbaran, where, datosAgrupacion))
    return false;

  this.iface.curFactura.setValueBuffer("titulo", curAlbaran.valueBuffer("titulo"));
  this.iface.curFactura.setValueBuffer("porgastos", curAlbaran.valueBuffer("porgastos"));
  this.iface.curFactura.setValueBuffer("gastos", curAlbaran.valueBuffer("gastos"));
  this.iface.curFactura.setValueBuffer("porbeneficio", curAlbaran.valueBuffer("porbeneficio"));
  this.iface.curFactura.setValueBuffer("beneficio", curAlbaran.valueBuffer("beneficio"));

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
      valor = util.sqlSelect("lineasalbaranescli", "SUM((pvptotal * iva * (100 + " + por + ")) / 100 / 100)", "idalbaran = " + cursor.valueBuffer("idalbaran"));
      valor = parseFloat(util.roundFieldValue(valor, "albaranescli", "totaliva"));
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
      valor = util.sqlSelect("lineasalbaranescli", "SUM((pvptotal * recargo * (100 + " + por + ")) / 100 / 100)", "idalbaran = " + cursor.valueBuffer("idalbaran"));
      valor = parseFloat(util.roundFieldValue(valor, "albaranescli", "totalrecargo"));
      break;
    }
    /** \C
    El --neto-- es el --netosindtoesp-- menos el --dtoesp-- mas --gastos generales-- mas --beneficio--
    \end */
    case "neto": {
      valor = parseFloat(cursor.valueBuffer("netosindtoesp")) - parseFloat(cursor.valueBuffer("dtoesp")) + parseFloat(cursor.valueBuffer("gastos")) + parseFloat(cursor.valueBuffer("beneficio"));
      valor = parseFloat(util.roundFieldValue(valor, "albaranescli", "neto"));
      break;
    }
    /** \C
    El valor --gastos-- es el --netosindtoesp-- menos el porcentaje que marca el --porgastos--
    \end */
    case "gastos": {
      valor = (parseFloat(cursor.valueBuffer("netosindtoesp")) * parseFloat(cursor.valueBuffer("porgastos"))) / 100;
      valor = parseFloat(util.roundFieldValue(valor, "albaranescli", "gastos"));
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
      valor = parseFloat(util.roundFieldValue(valor, "albaranescli", "porgastos"));
      break;
    }
    /** \C
    El valor --beneficio-- es el --netosindtoesp-- menos el porcentaje que marca el --porbeneficio--
    \end */
    case "beneficio": {
      valor = (parseFloat(cursor.valueBuffer("netosindtoesp")) * parseFloat(cursor.valueBuffer("porbeneficio"))) / 100;
      valor = parseFloat(util.roundFieldValue(valor, "albaranescli", "beneficio"));
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
      valor = parseFloat(util.roundFieldValue(valor, "albaranescli", "porbeneficio"));
      break;
    }
    default: {
      valor = this.iface.__commonCalculateField(fN, cursor);
      break;
    }
  }
  return valor;
}

function partidas_generarFactura(where: String, curAlbaran: FLSqlCursor, datosAgrupacion: Array): Number {
  this.iface.numLinea_ = 0;

  if (!this.iface.curFactura)
    this.iface.curFactura = new FLSqlCursor("facturascli");

  this.iface.curFactura.setModeAccess(this.iface.curFactura.Insert);
  this.iface.curFactura.refreshBuffer();

  if (!this.iface.datosFactura(curAlbaran, where, datosAgrupacion))
  {
    return false;
  }

  if (!this.iface.curFactura.commitBuffer())
  {
    return false;
  }

  var idFactura: Number = this.iface.curFactura.valueBuffer("idfactura");

  if (!this.iface.copiaPartidas(curAlbaran.valueBuffer("idalbaran"), idFactura))
  {
    return false;
  }

  var curAlbaranes: FLSqlCursor = new FLSqlCursor("albaranescli");
  curAlbaranes.select(where);
  var idAlbaran: Number;
  while (curAlbaranes.next())
  {
    curAlbaranes.setModeAccess(curAlbaranes.Edit);
    curAlbaranes.refreshBuffer();
    idAlbaran = curAlbaranes.valueBuffer("idalbaran");
    if (!this.iface.copiaLineasAlbaran(idAlbaran, idFactura)) {
      return false;
    }
    curAlbaranes.setValueBuffer("idfactura", idFactura);
    curAlbaranes.setValueBuffer("ptefactura", false);
    if (!curAlbaranes.commitBuffer()) {
      return false;
    }
  }

  this.iface.curFactura.select("idfactura = " + idFactura);
  if (this.iface.curFactura.first())
  {

    this.iface.curFactura.setModeAccess(this.iface.curFactura.Edit);
    this.iface.curFactura.refreshBuffer();

    if (!this.iface.totalesFactura())
      return false;

    if (this.iface.curFactura.commitBuffer() == false)
      return false;
  }
  if (!this.iface.validarFactura(idFactura))
  {
    return false;
  }
  return idFactura;
}

function partidas_copiaPartidas(idAlbaran: Number, idFactura: Number): Boolean {
  var curPartAlbaran: FLSqlCursor = new FLSqlCursor("partidasalb");
  curPartAlbaran.select("idalbaran = " + idAlbaran);
  while (curPartAlbaran.next())
  {
    curPartAlbaran.setModeAccess(curPartAlbaran.Browse);
    curPartAlbaran.refreshBuffer();
    if (!this.iface.copiaPartidaAlbaran(curPartAlbaran, idFactura))
      return false;
  }
  return true;
}

function partidas_copiaPartidaAlbaran(curPartAlbaran: FLSqlCursor, idFactura: Number): Number {
  if (!this.iface.curPartidaFactura)
    this.iface.curPartidaFactura = new FLSqlCursor("partidasfact");

  with(this.iface.curPartidaFactura)
  {
    setModeAccess(Insert);
    refreshBuffer();
    setValueBuffer("idfactura", idFactura);
  }

  if (!this.iface.datosPartidaFactura(curPartAlbaran, idFactura))
    return false;

  this.iface.curPartidaFactura.setActivatedCommitActions(false);
  if (!this.iface.curPartidaFactura.commitBuffer())
    return false;

  return this.iface.curPartidaFactura.valueBuffer("idpartidafact");
}

function partidas_datosPartidaFactura(curPartAlbaran: FLSqlCursor, idFactura: String): Boolean {
  with(this.iface.curPartidaFactura)
  {
    setValueBuffer("idfactura", idFactura);
    setValueBuffer("orden", curPartAlbaran.valueBuffer("orden"));
    setValueBuffer("descripcion", curPartAlbaran.valueBuffer("descripcion"));
    setValueBuffer("codpartidacat", curPartAlbaran.valueBuffer("codpartidacat"));
    setValueBuffer("idpartidao", curPartAlbaran.valueBuffer("idpartidaalb"));
  }
  return true;
}

//// PARTIDAS FACT //////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
