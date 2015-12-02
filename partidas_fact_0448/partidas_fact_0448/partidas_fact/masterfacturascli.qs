
/** @class_declaration partidas */
/////////////////////////////////////////////////////////////////
//// PARTIDAS_FACT //////////////////////////////////////////////
class partidas extends dtoEspecial
{
  function partidas(context)
  {
    dtoEspecial(context);
  }
  function commonCalculateField(fN: String, cursor: FLSqlCursor): String {
    return this.ctx.partidas_commonCalculateField(fN, cursor);
  }
  function copiadatosFactura(curFactura: FLSqlCursor): Boolean {
    return this.ctx.partidas_copiadatosFactura(curFactura);
  }
  function copiadatosLineaFactura(curLineaFactura: FLSqlCursor): Boolean {
    return this.ctx.partidas_copiadatosLineaFactura(curLineaFactura);
  }
  function copiarFactura(curFactura: FLSqlCursor): Number {
    return this.ctx.partidas_copiarFactura(curFactura);
  }
  function copiaCapitulosFactura(idFacturaOrigen: Number, idFacturaDestino: Number): Boolean {
    return this.ctx.partidas_copiaCapitulosFactura(idFacturaOrigen, idFacturaDestino);
  }
  function datosCapituloFactura(curCapOrigen: FLSqlCursor, curCapDestino: FLSqlCursor): Boolean {
    return this.ctx.partidas_datosCapituloFactura(curCapOrigen, curCapDestino);
  }
}

//// PARTIDAS_FACT //////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition partidas */
/////////////////////////////////////////////////////////////////
//// PARTIDAS_FACT //////////////////////////////////////////////
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
      valor = util.sqlSelect("lineasfacturascli", "SUM((pvptotal * iva * (100 + " + por + ")) / 100 / 100)", "idfactura = " + cursor.valueBuffer("idfactura"));
      valor = parseFloat(util.roundFieldValue(valor, "facturascli", "totaliva"));
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
      valor = util.sqlSelect("lineasfacturascli", "SUM((pvptotal * recargo * (100 + " + por + ")) / 100 / 100)", "idfactura = " + cursor.valueBuffer("idfactura"));
      valor = parseFloat(util.roundFieldValue(valor, "facturascli", "totalrecargo"));
      break;
    }
    /** \C
    El --neto-- es el --netosindtoesp-- menos el --dtoesp-- mas --gastos generales-- mas --beneficio--
    \end */
    case "neto": {
      valor = parseFloat(cursor.valueBuffer("netosindtoesp")) - parseFloat(cursor.valueBuffer("dtoesp")) + parseFloat(cursor.valueBuffer("gastos")) + parseFloat(cursor.valueBuffer("beneficio"));
      valor = parseFloat(util.roundFieldValue(valor, "facturascli", "neto"));
      break;
    }
    /** \C
    El valor --gastos-- es el --netosindtoesp-- menos el porcentaje que marca el --porgastos--
    \end */
    case "gastos": {
      valor = (parseFloat(cursor.valueBuffer("netosindtoesp")) * parseFloat(cursor.valueBuffer("porgastos"))) / 100;
      valor = parseFloat(util.roundFieldValue(valor, "facturascli", "gastos"));
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
      valor = parseFloat(util.roundFieldValue(valor, "facturascli", "porgastos"));
      break;
    }
    /** \C
    El valor --beneficio-- es el --netosindtoesp-- menos el porcentaje que marca el --porbeneficio--
    \end */
    case "beneficio": {
      valor = (parseFloat(cursor.valueBuffer("netosindtoesp")) * parseFloat(cursor.valueBuffer("porbeneficio"))) / 100;
      valor = parseFloat(util.roundFieldValue(valor, "facturascli", "beneficio"));
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
      valor = parseFloat(util.roundFieldValue(valor, "facturascli", "porbeneficio"));
      break;
    }
    default: {
      valor = this.iface.__commonCalculateField(fN, cursor);
      break;
    }
  }
  return valor;
}

function partidas_copiadatosLineaFactura(curLineaFactura: FLSqlCursor): Boolean {
  if (!this.iface.__copiadatosLineaFactura(curLineaFactura))
  {
    return false;
  }

  var util: FLUtil = new FLUtil();
  if (curLineaFactura.valueBuffer("ordenpartida"))
  {
    this.iface.curLineaFactura.setValueBuffer("ordenpartida", curLineaFactura.valueBuffer("ordenpartida"));
  }
  this.iface.curLineaFactura.setValueBuffer("idpartidafact", util.sqlSelect("partidasfact", "idpartidafact", "idfactura = " + this.iface.curLineaFactura.valueBuffer("idfactura") + " AND idpartidao = " + curLineaFactura.valueBuffer("idpartidafact")));

  return true;
}

function partidas_copiarFactura(curFactura: FLSqlCursor): Number {
  var util: FLUtil = new FLUtil();

  if (!this.iface.curFactura)
    this.iface.curFactura = new FLSqlCursor("facturascli");

  util.createProgressDialog(util.translate("scripts", "Copiando Factura...."), 3);
  var progreso = 0;

  this.iface.curFactura.setModeAccess(this.iface.curFactura.Insert);
  this.iface.curFactura.refreshBuffer();

  progreso = 1;
  util.setProgress(progreso);

  if (!this.iface.copiadatosFactura(curFactura))
  {
    util.destroyProgressDialog();
    return false;
  }

  if (!this.iface.curFactura.commitBuffer())
  {
    util.destroyProgressDialog();
    return false;
  }

  var idFactura: Number = this.iface.curFactura.valueBuffer("idfactura");


  if (!this.iface.copiaCapitulosFactura(curFactura.valueBuffer("idfactura"), idFactura))
  {
    return false;
  }

  progreso = 2;
  util.setProgress(progreso);

  if (!this.iface.copiaLineasFactura(curFactura.valueBuffer("idfactura"), idFactura))
  {
    util.destroyProgressDialog();
    return false;
  }

  this.iface.curFactura.select("idfactura = " + idFactura);
  if (this.iface.curFactura.first())
  {
    this.iface.curFactura.setModeAccess(this.iface.curFactura.Edit);
    this.iface.curFactura.refreshBuffer();

    progreso = 3;
    util.setProgress(progreso);

    if (!this.iface.totalesFactura()) {
      util.destroyProgressDialog();
      return false;
    }
    if (this.iface.curFactura.commitBuffer() == false) {
      util.destroyProgressDialog();
      return false;
    }
  }
  util.destroyProgressDialog();
  return idFactura;
}

function partidas_copiaCapitulosFactura(idFacturaOrigen: Number, idFacturaDestino: Number): Boolean {
  var curCapituloFactura: FLSqlCursor = new FLSqlCursor("partidasfact");
  var curCapituloFacturaDestino: FLSqlCursor = new FLSqlCursor("partidasfact");
  curCapituloFactura.select("idfactura = " + idFacturaOrigen);

  while (curCapituloFactura.next())
  {
    curCapituloFactura.setModeAccess(curCapituloFactura.Browse);

    curCapituloFacturaDestino.setModeAccess(curCapituloFacturaDestino.Insert);
    curCapituloFacturaDestino.refreshBuffer();
    curCapituloFacturaDestino.setValueBuffer("idfactura", idFacturaDestino);

    if (!this.iface.datosCapituloFactura(curCapituloFactura, curCapituloFacturaDestino)) {
      return false;
    }

    if (!curCapituloFacturaDestino.commitBuffer())
      return false;

  }
  return true;
}

function partidas_datosCapituloFactura(curCapOrigen: FLSqlCursor, curCapDestino: FLSqlCursor): Boolean {
  with(curCapDestino)
  {
    setValueBuffer("orden", curCapOrigen.valueBuffer("orden"));
    setValueBuffer("descripcion", curCapOrigen.valueBuffer("descripcion"));
    setValueBuffer("codpartidacat", curCapOrigen.valueBuffer("codpartidacat"));
    setValueBuffer("idpartidao", curCapOrigen.valueBuffer("idpartidafact"));
  }
  return true;
}

function partidas_copiadatosFactura(curFactura: FLSqlCursor): Boolean {
  if (!this.iface.__copiadatosFactura(curFactura))
  {
    return false;
  }

  with(this.iface.curFactura)
  {
    setValueBuffer("titulo", curFactura.valueBuffer("titulo"));
    setValueBuffer("porgastos", curFactura.valueBuffer("porgastos"));
    setValueBuffer("gastos", curFactura.valueBuffer("gastos"));
    setValueBuffer("porbeneficio", curFactura.valueBuffer("porbeneficio"));
    setValueBuffer("beneficio", curFactura.valueBuffer("beneficio"));
  }
  return true;
}

//// PARTIDAS_FACT //////////////////////////////////////////////
////////////////////////////////////////////////////////////////
