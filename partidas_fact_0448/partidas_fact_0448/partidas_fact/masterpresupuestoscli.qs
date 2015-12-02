
/** @class_declaration partidas */
/////////////////////////////////////////////////////////////////
//// PARTIDAS FACT //////////////////////////////////////////////
class partidas extends numLinea
{
  var curPartidaPres_: FLSqlCursor;
  var curPartidaPedido: FLSqlCursor;
  function partidas(context)
  {
    numLinea(context);
  }
  function datosLineaPedido(curLineaPresupuesto: FLSqlCursor): Boolean {
    return this.ctx.partidas_datosLineaPedido(curLineaPresupuesto);
  }
  function duplicarHijosPresupuesto(idPresOrigen: String, idPresDestino: String): Boolean {
    return this.ctx.partidas_duplicarHijosPresupuesto(idPresOrigen, idPresDestino);
  }
  function duplicarPartidasPresupuesto(idPresOrigen: String, idPresDestino: String): String {
    return this.ctx.partidas_duplicarPartidasPresupuesto(idPresOrigen, idPresDestino);
  }
  function copiarCampoPartidaPresupuesto(nombreCampo: String, curPartidaOrigen: FLSqlCursor, campoInformado: Array): Boolean {
    return this.ctx.partidas_copiarCampoPartidaPresupuesto(nombreCampo, curPartidaOrigen, campoInformado);
  }
  function datosPedido(curPresupuesto: FLSqlCursor): Boolean {
    return this.ctx.partidas_datosPedido(curPresupuesto);
  }
  function imprimir(codPresupuesto: String)
  {
    return this.ctx.partidas_imprimir(codPresupuesto);
  }
  function commonCalculateField(fN: String, cursor: FLSqlCursor): String {
    return this.ctx.partidas_commonCalculateField(fN, cursor);
  }
  function copiarCampoLineaPresupuesto(nombreCampo: String, cursor: FLSqlCursor, campoInformado: Array): Boolean {
    return this.ctx.partidas_copiarCampoLineaPresupuesto(nombreCampo, cursor, campoInformado);
  }
  function generarPedido(curPresupuesto: FLSqlCursor): Number {
    return this.ctx.partidas_generarPedido(curPresupuesto);
  }
  function copiaPartidas(idPresupuesto: Number, idPedido: Number): Boolean {
    return this.ctx.partidas_copiaPartidas(idPresupuesto, idPedido);
  }
  function copiaPartidaPresupuesto(curPartPresupuesto: FLSqlCursor, idPedido: Number): Number {
    return this.ctx.partidas_copiaPartidaPresupuesto(curPartPresupuesto, idPedido);
  }
  function datosPartidaPedido(curPartPresupuesto: FLSqlCursor, idPedido: String): Boolean {
    return this.ctx.partidas_datosPartidaPedido(curPartPresupuesto, idPedido);
  }
}

//// PARTIDAS FACT //////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition partidas */
/////////////////////////////////////////////////////////////////
//// PARTIDAS FACT //////////////////////////////////////////////
function partidas_datosLineaPedido(curLineaPresupuesto: FLSqlCursor): Boolean {
  var util: FLUtil = new FLUtil();
  if (!this.iface.__datosLineaPedido(curLineaPresupuesto))
  {
    return false;
  }

  var idPartidaPed: String = util.sqlSelect("partidasped", "idpartidaped", "idpedido = " + this.iface.curLineaPedido.valueBuffer("idpedido") + " AND idpartidao = " + curLineaPresupuesto.valueBuffer("idpartida"));

  var ordenPartidaPed: String = util.sqlSelect("partidasped", "orden", "idpedido = " + this.iface.curLineaPedido.valueBuffer("idpedido") + " AND idpartidao = " + curLineaPresupuesto.valueBuffer("idpartida"));

  with(this.iface.curLineaPedido)
  {
    if (!curLineaPresupuesto.isNull("idpartida")) {
      setValueBuffer("idpartidaped", idPartidaPed);
    }

    setValueBuffer("numlinea", curLineaPresupuesto.valueBuffer("numlinea"));

    if (curLineaPresupuesto.isNull("ordenpartida")) {
      setNull("ordenpartida");
    } else {
      setValueBuffer("ordenpartida", ordenPartidaPed);
    }
  }
  return true;
}

function partidas_duplicarHijosPresupuesto(idPresOrigen: String, idPresDestino: String): Boolean {
  if (!this.iface.duplicarPartidasPresupuesto(idPresOrigen, idPresDestino))
  {
    return false;
  }

  if (!this.iface.__duplicarHijosPresupuesto(idPresOrigen, idPresDestino))
  {
    return false;
  }
  return true;
}

function partidas_duplicarPartidasPresupuesto(idPresOrigen: String, idPresDestino: String): String {
  var util: FLUtil = new FLUtil;

  if (!this.iface.curPartidaPres_)
  {
    this.iface.curPartidaPres_ = new FLSqlCursor("partidas");
  }

  var campos: Array = util.nombreCampos("partidas");
  var totalCampos: Number = campos[0];

  var campoInformado: Array = [];

  var curPartidaOrigen: FLSqlCursor = new FLSqlCursor("partidas");
  curPartidaOrigen.select("idpresupuesto = " + idPresOrigen);
  while (curPartidaOrigen.next())
  {
    for (var i: Number = 1; i <= totalCampos; i++) {
      campoInformado[campos[i]] = false;
    }
    this.iface.curPartidaPres_.setModeAccess(this.iface.curPartidaPres_.Insert);
    this.iface.curPartidaPres_.refreshBuffer();
    this.iface.curPartidaPres_.setValueBuffer("idpresupuesto", idPresDestino);

    for (var i: Number = 1; i <= totalCampos; i++) {
      if (!this.iface.copiarCampoPartidaPresupuesto(campos[i], curPartidaOrigen, campoInformado)) {
        return false;
      }
    }
    if (!this.iface.curPartidaPres_.commitBuffer()) {
      return false;
    }
  }
  return true;
}

function partidas_copiarCampoPartidaPresupuesto(nombreCampo: String, curPartidaOrigen: FLSqlCursor, campoInformado: Array): Boolean {
  if (campoInformado[nombreCampo])
  {
    return true;
  }
  var nulo: Boolean = false;
  var valor: String;

  switch (nombreCampo)
  {
    case "idpartida":
    case "idpresupuesto": {
      return true;
      break;
    }
    case "idpartidao": {
      valor = curPartidaOrigen.valueBuffer("idpartida");
      break;
    }
    default: {
      if (curPartidaOrigen.isNull(nombreCampo)) {
        nulo = true;
      } else {
        valor = curPartidaOrigen.valueBuffer(nombreCampo);
      }
    }
  }
  if (nulo)
  {
    this.iface.curPartidaPres_.setNull(nombreCampo);
  } else {
    this.iface.curPartidaPres_.setValueBuffer(nombreCampo, valor);
  }
  campoInformado[nombreCampo] = true;

  return true;
}

function partidas_datosPedido(curPresupuesto: FLSqlCursor): Boolean {
  if (!this.iface.__datosPedido(curPresupuesto))
    return false;

  this.iface.curPedido.setValueBuffer("titulo", curPresupuesto.valueBuffer("titulo"));
  this.iface.curPedido.setValueBuffer("porgastos", curPresupuesto.valueBuffer("porgastos"));
  this.iface.curPedido.setValueBuffer("gastos", curPresupuesto.valueBuffer("gastos"));
  this.iface.curPedido.setValueBuffer("porbeneficio", curPresupuesto.valueBuffer("porbeneficio"));
  this.iface.curPedido.setValueBuffer("beneficio", curPresupuesto.valueBuffer("beneficio"));

  return true;
}

function partidas_imprimir(codPresupuesto: String)
{
  var util: FLUtil = new FLUtil();
  var cursor: FLSqlCursor = this.cursor();
  var dialog: Dialog = new Dialog(util.translate("scripts", "Imprimir Presupuesto"), 0, "imprimir");
  dialog.OKButtonText = util.translate("scripts", "Aceptar");
  dialog.cancelButtonText = util.translate("scripts", "Cancelar");

  var bgroup: GroupBox = new GroupBox;
  dialog.add(bgroup);

  var presupuesto: CheckBox = new CheckBox;
  presupuesto.text = util.translate("scripts", "Presupuesto");
  presupuesto.checked = true;
  bgroup.add(presupuesto);

  var resumen: CheckBox = new CheckBox;
  resumen.text = util.translate("scripts", "Resumen por capítulo");
  resumen.checked = false;
  bgroup.add(resumen);

  if (!dialog.exec()) {
    return true;
  }

  if (presupuesto.checked == true && resumen.checked == false) {
    this.iface.__imprimir(codPresupuesto);
  }

  if (presupuesto.checked == false && resumen.checked == true) {
    var rptViewer: FLReportViewer = new FLReportViewer();

    if (util.sqlSelect("partidas", "idpartida", "idpresupuesto = " + cursor.valueBuffer("idpresupuesto"))) {
      var qResumen: FLSqlQuery = new FLSqlQuery("i_resumencapitulos");
      qResumen.setWhere("partidas.idpresupuesto = " + cursor.valueBuffer("idpresupuesto"));
      qResumen.setOrderBy("partidas.orden");
      rptViewer.setReportTemplate("i_resumencapitulos");
      rptViewer.setReportData(qResumen);
      rptViewer.renderReport();
      rptViewer.exec();
    } else {
      MessageBox.information(util.translate("scripts", "No hay capítulos asociados al presupuesto"), MessageBox.Ok, MessageBox.NoButton);
      return false;
    }
  }

  var rptViewer: FLReportViewer = new FLReportViewer();
  if (presupuesto.checked == true && resumen.checked == true) {
    var qPresupuesto: FLSqlQuery = new FLSqlQuery("i_presupuestoscli");
    qPresupuesto.setWhere("presupuestoscli.idpresupuesto = " + cursor.valueBuffer("idpresupuesto"));
    rptViewer.setReportTemplate("i_presupuestoscli");
    rptViewer.setReportData(qPresupuesto);
    rptViewer.renderReport(0, 0, false, false);

    if (util.sqlSelect("partidas", "idpartida", "idpresupuesto = " + cursor.valueBuffer("idpresupuesto"))) {
      var qResumen: FLSqlQuery = new FLSqlQuery("i_resumencapitulos");
      qResumen.setWhere("partidas.idpresupuesto = " + cursor.valueBuffer("idpresupuesto"));
      rptViewer.setReportTemplate("i_resumencapitulos");
      rptViewer.setReportData(qResumen);
      rptViewer.renderReport(0, 0, true, true);
      rptViewer.exec();
    } else {
      MessageBox.information(util.translate("scripts", "No hay capítulos asociados al presupuesto"), MessageBox.Ok, MessageBox.NoButton);
      this.iface.__imprimir(codPresupuesto);
    }
  }

  if (presupuesto.checked == false && resumen.checked == false) {
    MessageBox.information(util.translate("scripts", "Debe seleccionar una opción para imprimir"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
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
      valor = util.sqlSelect("lineaspresupuestoscli", "SUM((pvptotal * iva * (100 + " + por + ")) / 100 / 100)", "idpresupuesto = " + cursor.valueBuffer("idpresupuesto"));
      valor = parseFloat(util.roundFieldValue(valor, "presupuestoscli", "totaliva"));
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
      valor = util.sqlSelect("lineaspresupuestoscli", "SUM((pvptotal * recargo * (100 + " + por + ")) / 100 / 100)", "idpresupuesto = " + cursor.valueBuffer("idpresupuesto"));
      valor = parseFloat(util.roundFieldValue(valor, "presupuestoscli", "totalrecargo"));
      break;
    }
    /** \C
    El --neto-- es el --netosindtoesp-- menos el --dtoesp-- mas --gastos generales-- mas --beneficio--
    \end */
    case "neto": {
      valor = parseFloat(cursor.valueBuffer("netosindtoesp")) - parseFloat(cursor.valueBuffer("dtoesp")) + parseFloat(cursor.valueBuffer("gastos")) + parseFloat(cursor.valueBuffer("beneficio"));
      valor = parseFloat(util.roundFieldValue(valor, "presupuestoscli", "neto"));
      break;
    }
    /** \C
    El valor --gastos-- es el --netosindtoesp-- menos el porcentaje que marca el --porgastos--
    \end */
    case "gastos": {
      valor = (parseFloat(cursor.valueBuffer("netosindtoesp")) * parseFloat(cursor.valueBuffer("porgastos"))) / 100;
      valor = parseFloat(util.roundFieldValue(valor, "presupuestoscli", "gastos"));
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
      valor = parseFloat(util.roundFieldValue(valor, "presupuestoscli", "porgastos"));
      break;
    }
    /** \C
    El valor --beneficio-- es el --netosindtoesp-- menos el porcentaje que marca el --porbeneficio--
    \end */
    case "beneficio": {
      valor = (parseFloat(cursor.valueBuffer("netosindtoesp")) * parseFloat(cursor.valueBuffer("porbeneficio"))) / 100;
      valor = parseFloat(util.roundFieldValue(valor, "presupuestoscli", "beneficio"));
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
      valor = parseFloat(util.roundFieldValue(valor, "presupuestoscli", "porbeneficio"));
      break;
    }
    default: {
      valor = this.iface.__commonCalculateField(fN, cursor);
      break;
    }
  }
  return valor;
}

function partidas_copiarCampoLineaPresupuesto(nombreCampo: String, curLineaOrigen: FLSqlCursor, campoInformado: Array): Boolean {
  var util: FLUtil = new FLUtil;
  if (campoInformado[nombreCampo])
  {
    return true;
  }
  var nulo: Boolean = false;
  var valor: String;
  switch (nombreCampo)
  {
    case "idpartida": {
      valor = util.sqlSelect("partidas", "idpartida", "idpresupuesto = " + this.iface.curLineaPres_.valueBuffer("idpresupuesto") + " AND idpartidao = " + curLineaOrigen.valueBuffer("idpartida"));
      break;
    }
    default: {
      return this.iface.__copiarCampoLineaPresupuesto(nombreCampo, curLineaOrigen, campoInformado);
    }
  }
  if (nulo)
  {
    this.iface.curLineaPres_.setNull(nombreCampo);
  } else {
    this.iface.curLineaPres_.setValueBuffer(nombreCampo, valor);
  }
  campoInformado[nombreCampo] = true;

  return true;
}

function partidas_generarPedido(curPresupuesto: FLSqlCursor): Number {
  this.iface.numLinea_ = 0;

  if (!this.iface.curPedido)
    this.iface.curPedido = new FLSqlCursor("pedidoscli");

  var idPresupuesto: String = curPresupuesto.valueBuffer("idpresupuesto");

  this.iface.curPedido.setModeAccess(this.iface.curPedido.Insert);
  this.iface.curPedido.refreshBuffer();
  this.iface.curPedido.setValueBuffer("idpresupuesto", idPresupuesto);

  if (!this.iface.datosPedido(curPresupuesto))
    return false;

  if (!this.iface.curPedido.commitBuffer())
    return false;

  var idPedido: Number = this.iface.curPedido.valueBuffer("idpedido");

  if (!this.iface.copiaPartidas(curPresupuesto.valueBuffer("idpresupuesto"), idPedido))
  {
    return false;
  }

  var curPresupuestos: FLSqlCursor = new FLSqlCursor("presupuestoscli");
  curPresupuestos.select("idpresupuesto = " + idPresupuesto);
  if (!curPresupuestos.first())
    return false;

  curPresupuestos.setModeAccess(curPresupuestos.Edit);
  curPresupuestos.refreshBuffer();
  if (!this.iface.copiaLineas(idPresupuesto, idPedido))
    return false;
  curPresupuestos.setValueBuffer("editable", false);
  if (!curPresupuestos.commitBuffer())
    return false;

  this.iface.curPedido.select("idpedido = " + idPedido);
  if (this.iface.curPedido.first())
  {
    this.iface.curPedido.setModeAccess(this.iface.curPedido.Edit);
    this.iface.curPedido.refreshBuffer();
    this.iface.curPedido.setValueBuffer("idpresupuesto", idPresupuesto);

    if (!this.iface.totalesPedido())
      return false;

    if (this.iface.curPedido.commitBuffer() == false)
      return false;
  }
  return idPedido;
}

function partidas_copiaPartidas(idPresupuesto: Number, idPedido: Number): Boolean {
  var curPartPresupuesto: FLSqlCursor = new FLSqlCursor("partidas");
  curPartPresupuesto.select("idpresupuesto = " + idPresupuesto);
  while (curPartPresupuesto.next())
  {
    curPartPresupuesto.setModeAccess(curPartPresupuesto.Browse);
    curPartPresupuesto.refreshBuffer();
    if (!this.iface.copiaPartidaPresupuesto(curPartPresupuesto, idPedido))
      return false;
  }
  return true;
}

function partidas_copiaPartidaPresupuesto(curPartPresupuesto: FLSqlCursor, idPedido: Number): Number {
  if (!this.iface.curPartidaPedido)
    this.iface.curPartidaPedido = new FLSqlCursor("partidasped");

  with(this.iface.curPartidaPedido)
  {
    setModeAccess(Insert);
    refreshBuffer();
    setValueBuffer("idpedido", idPedido);
  }

  if (!this.iface.datosPartidaPedido(curPartPresupuesto, idPedido))
    return false;

  this.iface.curPartidaPedido.setActivatedCommitActions(false);
  if (!this.iface.curPartidaPedido.commitBuffer())
    return false;

  return this.iface.curPartidaPedido.valueBuffer("idpartidaped");
}

function partidas_datosPartidaPedido(curPartPresupuesto: FLSqlCursor, idPedido: String): Boolean {
  with(this.iface.curPartidaPedido)
  {
    setValueBuffer("idpedido", idPedido);
    setValueBuffer("orden", curPartPresupuesto.valueBuffer("orden"));
    setValueBuffer("descripcion", curPartPresupuesto.valueBuffer("descripcion"));
    setValueBuffer("codpartidacat", curPartPresupuesto.valueBuffer("codpartidacat"));
    setValueBuffer("idpartidao", curPartPresupuesto.valueBuffer("idpartida"));
  }
  return true;
}

//// PARTIDAS FACT //////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
