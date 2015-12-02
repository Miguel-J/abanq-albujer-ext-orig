
/** @class_declaration ivaNav */
/////////////////////////////////////////////////////////////////
//// IVA NAV ////////////////////////////////////////////////////
class ivaNav extends oficial
{
  function ivaNav(context)
  {
    oficial(context);
  }
  function actualizarLineasIva(curFactura: FLSqlCursor): Boolean {
    return this.ctx.ivaNav_actualizarLineasIva(curFactura);
  }
  function bufferChanged(fN)
  {
    return this.ctx.ivaNav_bufferChanged(fN);
  }
  function compruebaIvaLineas()
  {
    return this.ctx.ivaNav_compruebaIvaLineas();
  }
}
//// IVA NAV ////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition ivaNav */
/////////////////////////////////////////////////////////////////
//// IVA NAV ////////////////////////////////////////////////////
function ivaNav_actualizarLineasIva(curFactura)
{
  var _i = this.iface;
  var idFactura = curFactura.valueBuffer("idfactura");

  var porDto = parseFloat(curFactura.valueBuffer("pordtoesp"));
  porDto = isNaN(porDto) ? 0 : porDto;

  var netoExacto = curFactura.valueBuffer("neto");
  /*
  var lineasSinIVA:Number = util.sqlSelect("lineasfacturasprov", "SUM(pvptotal)", "idfactura = " + idFactura + " AND iva IS NULL");
  lineasSinIVA = (isNaN(lineasSinIVA) ? 0 : lineasSinIVA);
  netoExacto -= lineasSinIVA;
  */
  netoExacto = AQUtil.roundFieldValue(netoExacto, "facturasprov", "neto");

  var codGrupoIvaNeg = curFactura.valueBuffer("codgrupoivaneg");
  var ivaExacto = AQUtil.sqlSelect("lineasfacturasprov lf INNER JOIN gruposcontablesivaproneg g ON (lf.codimpuesto = g.codimpuesto AND g.codgrupoivaneg = '" + codGrupoIvaNeg + "')", "SUM((lf.pvptotal * lf.iva * (100 - " + porDto + ")) / 100 / 100)", "lf.idfactura = " + idFactura + " AND g.tipocalculo <> 'Reversión'", "lineasfacturasprov");
  ivaExacto = isNaN(ivaExacto) ? 0 : ivaExacto;
  var reExacto = AQUtil.sqlSelect("lineasfacturasprov", "SUM((pvptotal * recargo * (100 - " + porDto + ")) / 100 / 100)", "idfactura = " + idFactura);
  reExacto = isNaN(reExacto) ? 0 : reExacto;

  if (!AQUtil.sqlDelete("lineasivafactprov", "idfactura = " + idFactura)) {
    return false;
  }

  var codImpuestoAnt = "", codImpuesto = "";
  var iva, recargo;
  var totalNeto = 0, totalIva = 0, totalRecargo = 0, totalLinea = 0;
  var acumNeto = 0, acumIva = 0, acumRecargo = 0;

  var curLineaIva = new FLSqlCursor("lineasivafactprov");
  var qryLineasFactura = new FLSqlQuery;
  with(qryLineasFactura) {
    setTablesList("lineasfacturasprov");
    setSelect("lf.codimpuesto, lf.iva, lf.recargo, lf.pvptotal, g.tipocalculo");
    setFrom("lineasfacturasprov lf INNER JOIN gruposcontablesivaproneg g ON (lf.codimpuesto = g.codimpuesto AND g.codgrupoivaneg = '" + codGrupoIvaNeg + "')");
    setWhere("idfactura = " + idFactura + " AND pvptotal <> 0 ORDER BY codimpuesto");
    setForwardOnly(true);
  }
  debug(qryLineasFactura.sql());
  if (!qryLineasFactura.exec()) {
    return false;
  }
  //var regIva = flfacturac.iface.pub_regimenIVACliente(curFactura);

  while (qryLineasFactura.next()) {
    codImpuesto = qryLineasFactura.value("lf.codimpuesto");
    if (codImpuestoAnt != "" && codImpuestoAnt != codImpuesto) {
      totalNeto = (totalNeto * (100 - porDto)) / 100;
      totalNeto = AQUtil.roundFieldValue(totalNeto, "lineasivafactprov", "neto");
      if (qryLineasFactura.value("g.tipocalculo") != "Reversión") {
        totalIva = AQUtil.roundFieldValue((iva * totalNeto) / 100, "lineasivafactprov", "totaliva");
        totalRecargo = AQUtil.roundFieldValue((recargo * totalNeto) / 100, "lineasivafactprov", "totalrecargo");
      } else {
        totalIva = 0;
        totalRecargo = 0;
      }
      totalLinea = parseFloat(totalNeto) + parseFloat(totalIva) + parseFloat(totalRecargo);
      totalLinea = AQUtil.roundFieldValue(totalLinea, "lineasivafactprov", "totallinea");

      acumNeto += parseFloat(totalNeto);
      acumIva += parseFloat(totalIva);
      acumRecargo += parseFloat(totalRecargo);

      with(curLineaIva) {
        setModeAccess(Insert);
        refreshBuffer();
        setValueBuffer("idfactura", idFactura);
        setValueBuffer("codimpuesto", codImpuestoAnt);
        setValueBuffer("iva", iva);
        setValueBuffer("recargo", recargo);
        setValueBuffer("neto", totalNeto);
        setValueBuffer("totaliva", totalIva);
        setValueBuffer("totalrecargo", totalRecargo);
        setValueBuffer("totallinea", totalLinea);
      }
      if (!curLineaIva.commitBuffer()) {
        return false;
      }
      totalNeto = 0;
    }

    codImpuestoAnt = codImpuesto;
    //    if (regIva == "U.E." || regIva == "Exento" || regIva == "Exportaciones") {
    //      ivaExacto = 0;
    //      reExacto = 0;
    //      iva = 0;
    //      recargo = 0;
    //    } else {
    iva = parseFloat(qryLineasFactura.value("lf.iva"));
    recargo = parseFloat(qryLineasFactura.value("lf.recargo"));
    if (isNaN(recargo)) {
      recargo = 0;
    }
    //    }
    totalNeto += parseFloat(qryLineasFactura.value("lf.pvptotal"));
  }

  if (totalNeto != 0) {
    totalNeto = AQUtil.roundFieldValue(netoExacto - acumNeto, "lineasivafactprov", "neto");
    totalIva = AQUtil.roundFieldValue(ivaExacto - acumIva, "lineasivafactprov", "totaliva");
    totalRecargo = AQUtil.roundFieldValue(reExacto - acumRecargo, "lineasivafactprov", "totalrecargo");
    totalLinea = parseFloat(totalNeto) + parseFloat(totalIva) + parseFloat(totalRecargo);
    totalLinea = AQUtil.roundFieldValue(totalLinea, "lineasivafactprov", "totallinea");

    with(curLineaIva) {
      setModeAccess(Insert);
      refreshBuffer();
      setValueBuffer("idfactura", idFactura);
      setValueBuffer("codimpuesto", codImpuestoAnt);
      setValueBuffer("iva", iva);
      setValueBuffer("recargo", recargo);
      setValueBuffer("neto", totalNeto);
      setValueBuffer("totaliva", totalIva);
      setValueBuffer("totalrecargo", totalRecargo);
      setValueBuffer("totallinea", totalLinea);
    }
    if (!curLineaIva.commitBuffer()) {
      return false;
    }
  }
  return true;
}

function ivaNav_bufferChanged(fN)
{
  var _i = this.iface;
  var cursor = this.cursor();
  switch (fN) {
    case "codgrupoivaneg": {
      _i.compruebaIvaLineas();
      break;
    }
    default: {
      _i.__bufferChanged(fN);
    }
  }
}

function ivaNav_compruebaIvaLineas()
{
  var _i = this.iface;
  var cursor = this.cursor();
  var codGrupoIvaNeg = cursor.valueBuffer("codgrupoivaneg");
  if (!AQUtil.sqlSelect("gruposcontablesivaneg", "codgrupoivaneg", "codgrupoivaneg = '" + codGrupoIvaNeg + "'")) {
    return;
  }
  var curL = new FLSqlCursor("lineasfacturasprov");
  curL.setActivatedCommitActions(false);
  curL.setActivatedCheckIntegrity(false);
  curL.select("idfactura = " + cursor.valueBuffer("idfactura"));
  while (curL.next()) {
    curL.setModeAccess(curL.Edit);
    curL.refreshBuffer();
    curL.setValueBuffer("iva", flfacturac.iface.pub_campoImpuesto("iva", curL.valueBuffer("codimpuesto"), cursor.valueBuffer("fecha"), codGrupoIvaNeg));
    curL.setValueBuffer("recargo", flfacturac.iface.pub_campoImpuesto("recargo", curL.valueBuffer("codimpuesto"), cursor.valueBuffer("fecha"), codGrupoIvaNeg));
    if (!curL.commitBuffer()) {
      return false;
    }
  }
  _i.calcularTotales();
  this.child("tdbLineasFacturasProv").refresh();
}
//// IVA NAV ////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
