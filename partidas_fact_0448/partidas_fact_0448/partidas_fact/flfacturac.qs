
/** @class_declaration partidasFact */
/////////////////////////////////////////////////////////////////
//// PARTIDAS FACTURACION ///////////////////////////////////////
class partidasFact extends dtoEspecial
{
  var curLineaPar_: FLSqlCursor;
  function partidasFact(context)
  {
    dtoEspecial(context);
  }
  function init()
  {
    return this.ctx.partidasFact_init();
  }
  function afterCommit_partidas(curPartida: FLSqlCursor): Boolean {
    return this.ctx.partidasFact_afterCommit_partidas(curPartida);
  }
  function afterCommit_partidasped(curPartidaPed: FLSqlCursor): Boolean {
    return this.ctx.partidasFact_afterCommit_partidasped(curPartidaPed);
  }
  function afterCommit_partidasalb(curPartidaAlb: FLSqlCursor): Boolean {
    return this.ctx.partidasFact_afterCommit_partidasalb(curPartidaAlb);
  }
  function afterCommit_partidasfact(curPartidaFact: FLSqlCursor): Boolean {
    return this.ctx.partidasFact_afterCommit_partidasfact(curPartidaFact);
  }
  function generarComponentesPartida(curPartida: FLSqlCursor): Boolean {
    return this.ctx.partidasFact_generarComponentesPartida(curPartida);
  }
  function generarComponentesPartidaPed(curPartidaPed: FLSqlCursor): Boolean {
    return this.ctx.partidasFact_generarComponentesPartidaPed(curPartidaPed);
  }
  function generarComponentesPartidaAlb(curPartidaAlb: FLSqlCursor): Boolean {
    return this.ctx.partidasFact_generarComponentesPartidaAlb(curPartidaAlb);
  }
  function generarComponentesPartidaFact(curPartidaFact: FLSqlCursor): Boolean {
    return this.ctx.partidasFact_generarComponentesPartidaFact(curPartidaFact);
  }
  function datosLineaPar(): Boolean {
    return this.ctx.partidasFact_datosLineaPar();
  }
  function generarPartidasVenta(curFactura: FLSqlCursor, idAsiento: Number, valoresDefecto: Array): Boolean {
    return this.ctx.partidasFact_generarPartidasVenta(curFactura, idAsiento, valoresDefecto);
  }
  function generarPartidasGastosCli(curFactura: FLSqlCursor, idAsiento: Number, valoresDefecto: Array): Boolean {
    return this.ctx.partidasFact_generarPartidasGastosCli(curFactura, idAsiento, valoresDefecto);
  }
  function datosCtaGastos(codEjercicio: String): Array {
    return this.ctx.partidasFact_datosCtaGastos(codEjercicio);
  }
  function generarPartidasBeneficiosCli(curFactura: FLSqlCursor, idAsiento: Number, valoresDefecto: Array): Boolean {
    return this.ctx.partidasFact_generarPartidasBeneficiosCli(curFactura, idAsiento, valoresDefecto);
  }
  function datosCtaBeneficio(codEjercicio: String): Array {
    return this.ctx.partidasFact_datosCtaBeneficio(codEjercicio);
  }
  function afterCommit_componentespar(curComponente: FLSqlCursor): Boolean {
    return this.ctx.partidasFact_afterCommit_componentespar(curComponente);
  }
  function renumerarComponentes(curComponente: FLSqlCursor): Boolean {
    return this.ctx.partidasFact_renumerarComponentes(curComponente);
  }
  function renumerarPartidas(curPartida: FLSqlCursor, tabla: String): Boolean {
    return this.ctx.partidasFact_renumerarPartidas(curPartida, tabla);
  }
  function renumerarOrdenLineas(curPartida: FLSqlCursor, tabla: String): Boolean {
    return this.ctx.partidasFact_renumerarOrdenLineas(curPartida, tabla);
  }
  function afterCommit_lineaspresupuestoscli(curLinea: FLSqlCursor): Boolean {
    return this.ctx.partidasFact_afterCommit_lineaspresupuestoscli(curLinea);
  }
  function afterCommit_lineaspedidoscli(curLinea: FLSqlCursor): Boolean {
    return this.ctx.partidasFact_afterCommit_lineaspedidoscli(curLinea);
  }
  function afterCommit_lineasalbaranescli(curLinea: FLSqlCursor): Boolean {
    return this.ctx.partidasFact_afterCommit_lineasalbaranescli(curLinea);
  }
  function afterCommit_lineasfacturascli(curLinea: FLSqlCursor): Boolean {
    return this.ctx.partidasFact_afterCommit_lineasfacturascli(curLinea);
  }
  function renumerarLineas(curLinea: FLSqlCursor, tabla: String): Boolean {
    return this.ctx.partidasFact_renumerarLineas(curLinea, tabla);
  }
}
//// PARTIDAS FACTURACION ///////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition partidasFact */
/////////////////////////////////////////////////////////////////
//// PARTIDAS FACTURACIÓN ///////////////////////////////////////
function partidasFact_init()
{
  this.iface.__init();

  if (!sys.isLoadedModule("flcontppal"))
    return;
  var cursor: FLSqlCursor = new FLSqlCursor("empresa");
  var util: FLUtil = new FLUtil();
  cursor.select();
  if (!util.sqlSelect("co_cuentasesp", "idcuentaesp", "idcuentaesp = 'GASGEN'")) {
    MessageBox.information(util.translate("scripts",
                                          "Se crearán algunas cuentas especiales para empezar a trabajar."),
                           MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    var cursor: FLSqlCursor = new FLSqlCursor("co_cuentasesp");

    var cuentas: Array =
      [["GASGEN", "Gastos Generales"]];
    for (var i: Number = 0; i < cuentas.length; i++) {
      with(cursor) {
        setModeAccess(cursor.Insert);
        refreshBuffer();
        setValueBuffer("idcuentaesp", cuentas[i][0]);
        setValueBuffer("descripcion", cuentas[i][1]);
        commitBuffer();
      }
    }
    delete cursor;
  }
}

function partidasFact_afterCommit_partidas(curPartida: FLSqlCursor): Boolean {
  switch (curPartida.modeAccess())
  {
    case curPartida.Insert: {
      if (curPartida.isNull("idpartidao")) {
        if (!this.iface.generarComponentesPartida(curPartida)) {
          return false;
        }
      }
      break;
    }
  }

  if (curPartida.modeAccess() == curPartida.Insert || (curPartida.modeAccess() == curPartida.Edit && curPartida.valueBufferCopy("orden") != curPartida.valueBuffer("orden")))
  {
    if (!this.iface.renumerarPartidas(curPartida, "presupuestoscli")) {
      return false;
    }
  }
  return true;
}

function partidasFact_afterCommit_partidasped(curPartidaPed: FLSqlCursor): Boolean {
  switch (curPartidaPed.modeAccess())
  {
    case curPartidaPed.Insert: {
      if (curPartidaPed.isNull("idpartidao")) {
        if (!this.iface.generarComponentesPartidaPed(curPartidaPed)) {
          return false;
        }
      }
      break;
    }
  }
  if (curPartidaPed.modeAccess() == curPartidaPed.Insert || (curPartidaPed.modeAccess() == curPartidaPed.Edit && curPartidaPed.valueBufferCopy("orden") != curPartidaPed.valueBuffer("orden")))
  {
    if (!this.iface.renumerarPartidas(curPartidaPed, "pedidoscli")) {
      return false;
    }
  }
  return true;
}

function partidasFact_afterCommit_partidasalb(curPartidaAlb: FLSqlCursor): Boolean {
  switch (curPartidaAlb.modeAccess())
  {
    case curPartidaAlb.Insert: {
      if (curPartidaAlb.isNull("idpartidao")) {
        if (!this.iface.generarComponentesPartidaAlb(curPartidaAlb)) {
          return false;
        }
      }
      break;
    }
  }
  if (curPartidaAlb.modeAccess() == curPartidaAlb.Insert || (curPartidaAlb.modeAccess() == curPartidaAlb.Edit && curPartidaAlb.valueBufferCopy("orden") != curPartidaAlb.valueBuffer("orden")))
  {
    if (!this.iface.renumerarPartidas(curPartidaAlb, "albaranescli")) {
      return false;
    }
  }
  return true;
}

function partidasFact_afterCommit_partidasfact(curPartidaFact: FLSqlCursor): Boolean {
  switch (curPartidaFact.modeAccess())
  {
    case curPartidaFact.Insert: {
      if (curPartidaFact.isNull("idpartidao")) {
        if (!this.iface.generarComponentesPartidaFact(curPartidaFact)) {
          return false;
        }
      }
      break;
    }
  }
  if (curPartidaFact.modeAccess() == curPartidaFact.Insert || (curPartidaFact.modeAccess() == curPartidaFact.Edit && curPartidaFact.valueBufferCopy("orden") != curPartidaFact.valueBuffer("orden")))
  {
    if (!this.iface.renumerarPartidas(curPartidaFact, "facturascli")) {
      return false;
    }
  }
  return true;
}

function partidasFact_generarComponentesPartida(curPartida: FLSqlCursor): Boolean {
  var util: FLUtil = new FLUtil;

  var idPresupuesto: String = curPartida.valueBuffer("idpresupuesto");
  if (!idPresupuesto || idPresupuesto == "")
  {
    return true;
  }
  var codPartidaCat: String = curPartida.valueBuffer("codpartidacat");
  if (!codPartidaCat || codPartidaCat == "")
  {
    return true;
  }

  var idPartida: String = curPartida.valueBuffer("idpartida");

  var qryComponentes: FLSqlQuery = new FLSqlQuery;
  qryComponentes.setTablesList("componentespar");
  qryComponentes.setSelect("referencia, descripcion, cantidad");
  qryComponentes.setFrom("componentespar");
  qryComponentes.setWhere("codpartidacat = '" + codPartidaCat + "' ORDER BY orden");
  qryComponentes.setForwardOnly(true);
  if (!qryComponentes.exec())
  {
    return false;
  }

  this.iface.curLineaPar_ = new FLSqlCursor("lineaspresupuestoscli");
  while (qryComponentes.next())
  {
    this.iface.curLineaPar_.setModeAccess(this.iface.curLineaPar_.Insert);
    this.iface.curLineaPar_.refreshBuffer();
    this.iface.curLineaPar_.setValueBuffer("idpresupuesto", idPresupuesto);
    this.iface.curLineaPar_.setValueBuffer("idpartida", idPartida);
    this.iface.curLineaPar_.setValueBuffer("referencia", qryComponentes.value("referencia"));
    this.iface.curLineaPar_.setValueBuffer("descripcion", qryComponentes.value("descripcion"));
    this.iface.curLineaPar_.setValueBuffer("cantidad", qryComponentes.value("cantidad"));

    this.iface.curLineaPar_.setValueBuffer("numlinea", formRecordlineaspedidoscli.iface.commonCalculateField("numlinea", this.iface.curLineaPar_));
    this.iface.curLineaPar_.setValueBuffer("ordenpartida", curPartida.valueBuffer("orden"));


    if (!this.iface.datosLineaPar()) {
      return false;
    }
    if (!this.iface.curLineaPar_.commitBuffer()) {
      return false;
    }
  }

  return true;
}

function partidasFact_generarComponentesPartidaPed(curPartidaPed: FLSqlCursor): Boolean {
  var util: FLUtil = new FLUtil;

  var idPedido: String = curPartidaPed.valueBuffer("idpedido");
  if (!idPedido || idPedido == "")
  {
    return true;
  }
  var codPartidaCat: String = curPartidaPed.valueBuffer("codpartidacat");
  if (!codPartidaCat || codPartidaCat == "")
  {
    return true;
  }

  var idPartida: String = curPartidaPed.valueBuffer("idpartidaped");

  var qryComponentes: FLSqlQuery = new FLSqlQuery;
  qryComponentes.setTablesList("componentespar");
  qryComponentes.setSelect("referencia, descripcion, cantidad");
  qryComponentes.setFrom("componentespar");
  qryComponentes.setWhere("codpartidacat = '" + codPartidaCat + "' ORDER BY orden");
  qryComponentes.setForwardOnly(true);
  if (!qryComponentes.exec())
  {
    return false;
  }
  this.iface.curLineaPar_ = new FLSqlCursor("lineaspedidoscli");
  while (qryComponentes.next())
  {
    this.iface.curLineaPar_.setModeAccess(this.iface.curLineaPar_.Insert);
    this.iface.curLineaPar_.refreshBuffer();
    this.iface.curLineaPar_.setValueBuffer("idpedido", idPedido);
    this.iface.curLineaPar_.setValueBuffer("idpartidaped", idPartida);
    this.iface.curLineaPar_.setValueBuffer("referencia", qryComponentes.value("referencia"));
    this.iface.curLineaPar_.setValueBuffer("descripcion", qryComponentes.value("descripcion"));
    this.iface.curLineaPar_.setValueBuffer("cantidad", qryComponentes.value("cantidad"));

    this.iface.curLineaPar_.setValueBuffer("numlinea", formRecordlineaspedidoscli.iface.commonCalculateField("numlinea", this.iface.curLineaPar_));
    this.iface.curLineaPar_.setValueBuffer("ordenpartida", curPartidaPed.valueBuffer("orden"));


    if (!this.iface.datosLineaPar()) {
      return false;
    }
    if (!this.iface.curLineaPar_.commitBuffer()) {
      return false;
    }
  }

  return true;
}

function partidasFact_generarComponentesPartidaAlb(curPartidaAlb: FLSqlCursor): Boolean {
  var util: FLUtil = new FLUtil;

  var idAlbaran: String = curPartidaAlb.valueBuffer("idalbaran");
  if (!idAlbaran || idAlbaran == "")
  {
    return true;
  }
  var codPartidaCat: String = curPartidaAlb.valueBuffer("codpartidacat");
  if (!codPartidaCat || codPartidaCat == "")
  {
    return true;
  }

  var idPartida: String = curPartidaAlb.valueBuffer("idpartidaalb");

  var qryComponentes: FLSqlQuery = new FLSqlQuery;
  qryComponentes.setTablesList("componentespar");
  qryComponentes.setSelect("referencia, descripcion, cantidad");
  qryComponentes.setFrom("componentespar");
  qryComponentes.setWhere("codpartidacat = '" + codPartidaCat + "' ORDER BY orden");
  qryComponentes.setForwardOnly(true);
  if (!qryComponentes.exec())
  {
    return false;
  }
  this.iface.curLineaPar_ = new FLSqlCursor("lineasalbaranescli");
  while (qryComponentes.next())
  {
    this.iface.curLineaPar_.setModeAccess(this.iface.curLineaPar_.Insert);
    this.iface.curLineaPar_.refreshBuffer();
    this.iface.curLineaPar_.setValueBuffer("idalbaran", idAlbaran);
    this.iface.curLineaPar_.setValueBuffer("idpartidaalb", idPartida);
    this.iface.curLineaPar_.setValueBuffer("referencia", qryComponentes.value("referencia"));
    this.iface.curLineaPar_.setValueBuffer("descripcion", qryComponentes.value("descripcion"));
    this.iface.curLineaPar_.setValueBuffer("cantidad", qryComponentes.value("cantidad"));
    this.iface.curLineaPar_.setValueBuffer("numlinea", formRecordlineaspedidoscli.iface.commonCalculateField("numlinea", this.iface.curLineaPar_));
    this.iface.curLineaPar_.setValueBuffer("ordenpartida", curPartidaAlb.valueBuffer("orden"));

    if (!this.iface.datosLineaPar()) {
      return false;
    }
    if (!this.iface.curLineaPar_.commitBuffer()) {
      return false;
    }
  }
  return true;
}

function partidasFact_generarComponentesPartidaFact(curPartidaFact: FLSqlCursor): Boolean {
  var util: FLUtil = new FLUtil;

  var idFactura: String = curPartidaFact.valueBuffer("idfactura");
  if (!idFactura || idFactura == "")
  {
    return true;
  }
  var codPartidaCat: String = curPartidaFact.valueBuffer("codpartidacat");
  if (!codPartidaCat || codPartidaCat == "")
  {
    return true;
  }

  var idPartida: String = curPartidaFact.valueBuffer("idpartidafact");

  var qryComponentes: FLSqlQuery = new FLSqlQuery;
  qryComponentes.setTablesList("componentespar");
  qryComponentes.setSelect("referencia, descripcion, cantidad");
  qryComponentes.setFrom("componentespar");
  qryComponentes.setWhere("codpartidacat = '" + codPartidaCat + "' ORDER BY orden");
  qryComponentes.setForwardOnly(true);
  if (!qryComponentes.exec())
  {
    return false;
  }
  this.iface.curLineaPar_ = new FLSqlCursor("lineasfacturascli");
  while (qryComponentes.next())
  {
    this.iface.curLineaPar_.setModeAccess(this.iface.curLineaPar_.Insert);
    this.iface.curLineaPar_.refreshBuffer();
    this.iface.curLineaPar_.setValueBuffer("idfactura", idFactura);
    this.iface.curLineaPar_.setValueBuffer("idpartidafact", idPartida);
    this.iface.curLineaPar_.setValueBuffer("referencia", qryComponentes.value("referencia"));
    this.iface.curLineaPar_.setValueBuffer("descripcion", qryComponentes.value("descripcion"));
    this.iface.curLineaPar_.setValueBuffer("cantidad", qryComponentes.value("cantidad"));
    this.iface.curLineaPar_.setValueBuffer("numlinea", formRecordlineaspedidoscli.iface.commonCalculateField("numlinea", this.iface.curLineaPar_));
    this.iface.curLineaPar_.setValueBuffer("ordenpartida", curPartidaFact.valueBuffer("orden"));

    if (!this.iface.datosLineaPar()) {
      return false;
    }
    if (!this.iface.curLineaPar_.commitBuffer()) {
      return false;
    }
  }
  return true;
}

function partidasFact_datosLineaPar(): Boolean {
  var referencia: String = this.iface.curLineaPar_.valueBuffer("referencia");
  if (referencia && referencia != "")
  {
    this.iface.curLineaPar_.setValueBuffer("pvpunitario", formRecordlineaspedidoscli.iface.pub_commonCalculateField("pvpunitario", this.iface.curLineaPar_));
  } else {
    this.iface.curLineaPar_.setValueBuffer("pvpunitario", 0);
  }
  this.iface.curLineaPar_.setValueBuffer("pvpsindto", formRecordlineaspedidoscli.iface.pub_commonCalculateField("pvpsindto", this.iface.curLineaPar_));
  this.iface.curLineaPar_.setValueBuffer("dtopor", formRecordlineaspedidoscli.iface.pub_commonCalculateField("dtopor", this.iface.curLineaPar_));
  this.iface.curLineaPar_.setValueBuffer("pvptotal", formRecordlineaspedidoscli.iface.pub_commonCalculateField("pvptotal", this.iface.curLineaPar_));
  this.iface.curLineaPar_.setValueBuffer("codimpuesto", formRecordlineaspedidoscli.iface.pub_commonCalculateField("codimpuesto", this.iface.curLineaPar_));
  this.iface.curLineaPar_.setValueBuffer("iva", formRecordlineaspedidoscli.iface.pub_commonCalculateField("iva", this.iface.curLineaPar_));
  this.iface.curLineaPar_.setValueBuffer("recargo", formRecordlineaspedidoscli.iface.pub_commonCalculateField("recargo", this.iface.curLineaPar_));
  this.iface.curLineaPar_.setValueBuffer("irpf", formRecordlineaspedidoscli.iface.pub_commonCalculateField("irpf", this.iface.curLineaPar_));
  this.iface.curLineaPar_.setValueBuffer("porcomision", formRecordlineaspedidoscli.iface.pub_commonCalculateField("porcomision", this.iface.curLineaPar_));

  return true;
}


function partidasFact_generarPartidasVenta(curFactura: FLSqlCursor, idAsiento: Number, valoresDefecto: Array): Boolean {
  if (!this.iface.__generarPartidasVenta(curFactura, idAsiento, valoresDefecto))
  {
    return false;
  }

  if (!this.iface.generarPartidasGastosCli(curFactura, idAsiento, valoresDefecto))
  {
    return false;
  }

  if (!this.iface.generarPartidasBeneficiosCli(curFactura, idAsiento, valoresDefecto))
  {
    return false;
  }

  return true;
}

/** \D Genera la parte del asiento de factura correspondiente al gasto general de la factura de un cliente
@param  curFactura: Cursor de la factura
@param  idAsiento: Id del asiento asociado
@param  valoresDefecto: Array con los valores por defecto de ejercicio y divisa
@return VERDADERO si no hay error, FALSO en otro caso
\end */
function partidasFact_generarPartidasGastosCli(curFactura: FLSqlCursor, idAsiento: Number, valoresDefecto: Array): Boolean {
  if (parseFloat(curFactura.valueBuffer("gastos")) == 0)
  {
    return true;
  }

  var util: FLUtil = new FLUtil();
  var ctaGastos: Array = this.iface.datosCtaGastos(valoresDefecto.codejercicio);

  if (ctaGastos.error != 0)
    return false;

  var haber: Number = 0;
  var haberME: Number = 0;
  var monedaSistema: Boolean = (valoresDefecto.coddivisa == curFactura.valueBuffer("coddivisa"));
  if (monedaSistema)
  {
    haber = curFactura.valueBuffer("gastos");
    haberME = 0;
  } else {
    haber = parseFloat(curFactura.valueBuffer("gastos")) * parseFloat(curFactura.valueBuffer("tasaconv"));
    haberME = curFactura.valueBuffer("neto");
  }
  haber = util.roundFieldValue(haber, "co_partidas", "debe");
  haberME = util.roundFieldValue(haberME, "co_partidas", "debeme");

  var curPartida: FLSqlCursor = new FLSqlCursor("co_partidas");
  with(curPartida)
  {
    setModeAccess(curPartida.Insert);
    refreshBuffer();
    setValueBuffer("concepto", util.translate("scripts", "Nuestra factura ") + curFactura.valueBuffer("codigo") + " - " + curFactura.valueBuffer("nombrecliente"));
    setValueBuffer("idsubcuenta", ctaGastos.idsubcuenta);
    setValueBuffer("codsubcuenta", ctaGastos.codsubcuenta);
    setValueBuffer("idasiento", idAsiento);
    setValueBuffer("debe", 0);
    setValueBuffer("haber", haber);
    setValueBuffer("coddivisa", curFactura.valueBuffer("coddivisa"));
    setValueBuffer("tasaconv", curFactura.valueBuffer("tasaconv"));
    setValueBuffer("debeME", 0);
    setValueBuffer("haberME", haberME);
  }
  if (!curPartida.commitBuffer())
    return false;

  return true;
}

/** \D Devuelve el código e id de la subcuenta de gastos
@param codEjercicio: Ejercicio actual
@return Los datos componen un vector de tres valores:
error: 0.Sin error 1.Datos no encontrados 2.Error al ejecutar la query
idsubcuenta: Identificador de la subcuenta
codsubcuenta: Código de la subcuenta
\end */
function partidasFact_datosCtaGastos(codEjercicio: String): Array {
  var util: FLUtil = new FLUtil();
  var datosCta: Array = this.iface.datosCtaEspecial("GASGEN", codEjercicio);
  if (datosCta.error != 0)
  {
    MessageBox.warning(util.translate("scripts", "No se puede generar el asiento correspondiente a esta factura,\nantes debe asociar una cuenta contable a la cuenta especial GASGEN"), MessageBox.Ok, MessageBox.NoButton);
  }
  return datosCta;
}

/** \D Genera la parte del asiento de factura correspondiente al beneficio de la factura de un cliente
@param  curFactura: Cursor de la factura
@param  idAsiento: Id del asiento asociado
@param  valoresDefecto: Array con los valores por defecto de ejercicio y divisa
@return VERDADERO si no hay error, FALSO en otro caso
\end */
function partidasFact_generarPartidasBeneficiosCli(curFactura: FLSqlCursor, idAsiento: Number, valoresDefecto: Array): Boolean {
  if (parseFloat(curFactura.valueBuffer("beneficio")) == 0)
  {
    return true;
  }

  var util: FLUtil = new FLUtil();
  var ctaBeneficio: Array = this.iface.datosCtaBeneficio(valoresDefecto.codejercicio);

  if (ctaBeneficio.error != 0)
    return false;

  var haber: Number = 0;
  var haberME: Number = 0;
  var monedaSistema: Boolean = (valoresDefecto.coddivisa == curFactura.valueBuffer("coddivisa"));
  if (monedaSistema)
  {
    haber = curFactura.valueBuffer("beneficio");
    haberME = 0;
  } else {
    haber = parseFloat(curFactura.valueBuffer("beneficio")) * parseFloat(curFactura.valueBuffer("tasaconv"));
    haberME = curFactura.valueBuffer("neto");
  }
  haber = util.roundFieldValue(haber, "co_partidas", "debe");
  haberME = util.roundFieldValue(haberME, "co_partidas", "debeme");

  var curPartida: FLSqlCursor = new FLSqlCursor("co_partidas");
  with(curPartida)
  {
    setModeAccess(curPartida.Insert);
    refreshBuffer();
    setValueBuffer("concepto", util.translate("scripts", "Nuestra factura ") + curFactura.valueBuffer("codigo") + " - " + curFactura.valueBuffer("nombrecliente"));
    setValueBuffer("idsubcuenta", ctaBeneficio.idsubcuenta);
    setValueBuffer("codsubcuenta", ctaBeneficio.codsubcuenta);
    setValueBuffer("idasiento", idAsiento);
    setValueBuffer("debe", 0);
    setValueBuffer("haber", haber);
    setValueBuffer("coddivisa", curFactura.valueBuffer("coddivisa"));
    setValueBuffer("tasaconv", curFactura.valueBuffer("tasaconv"));
    setValueBuffer("debeME", 0);
    setValueBuffer("haberME", haberME);
  }
  if (!curPartida.commitBuffer())
    return false;

  return true;
}

/** \D Devuelve el código e id de la subcuenta de beneficio industrial
@param codEjercicio: Ejercicio actual
@return Los datos componen un vector de tres valores:
error: 0.Sin error 1.Datos no encontrados 2.Error al ejecutar la query
idsubcuenta: Identificador de la subcuenta
codsubcuenta: Código de la subcuenta
\end */
function partidasFact_datosCtaBeneficio(codEjercicio: String): Array {
  var util: FLUtil = new FLUtil();
  var datosCta: Array = this.iface.datosCtaEspecial("BENIND", codEjercicio);
  if (datosCta.error != 0)
  {
    MessageBox.warning(util.translate("scripts", "No se puede generar el asiento correspondiente a esta factura,\nantes debe asociar una cuenta contable a la cuenta especial BENIND"), MessageBox.Ok, MessageBox.NoButton);
  }
  return datosCta;
}

function partidasFact_afterCommit_componentespar(curComponente: FLSqlCursor): Boolean {
  switch (curComponente.modeAccess())
  {
    case curComponente.Insert:
    case curComponente.Edit: {
      if (!this.iface.renumerarComponentes(curComponente)) {
        return false;
      }
      break;
    }
  }
  return true;
}

function partidasFact_renumerarComponentes(curComponente: FLSqlCursor): Boolean {
  var iOrden: Number = curComponente.valueBuffer("orden");
  var curComponentesPart: FLSqlCursor = new FLSqlCursor("componentespar");
  curComponentesPart.select("codpartidacat = '" + curComponente.valueBuffer("codpartidacat") + "' AND orden >= " + iOrden + " AND idcomponente != " + curComponente.valueBuffer("idcomponente") + "ORDER BY orden");
  while (curComponentesPart.next())
  {
    if (iOrden < curComponente.valueBuffer("orden")) {
      break;
    } else {
      iOrden++;
      curComponentesPart.setModeAccess(curComponentesPart.Edit);
      curComponentesPart.refreshBuffer();
      curComponentesPart.setValueBuffer("orden", iOrden);
      curComponentesPart.setActivatedCommitActions(false);
      if (!curComponentesPart.commitBuffer()) {
        return false;
      }
    }
  }
  return true;
}

function partidasFact_renumerarPartidas(curPartida: FLSqlCursor, tabla: String): Boolean {
  var iOrden: Number = curPartida.valueBuffer("orden");
  var curPartidas: FLSqlCursor;
  switch (tabla)
  {
    case "presupuestoscli": {
      curPartidas = new FLSqlCursor("partidas");
      curPartidas.select("idpresupuesto = " + curPartida.valueBuffer("idpresupuesto") + " AND orden >= " + iOrden + " AND idpartida != " + curPartida.valueBuffer("idpartida") + "ORDER BY orden");
      break;
    }
    case "pedidoscli": {
      curPartidas = new FLSqlCursor("partidasped");
      curPartidas.select("idpedido = " + curPartida.valueBuffer("idpedido") + " AND orden >= " + iOrden + " AND idpartidaped != " + curPartida.valueBuffer("idpartidaped") + "ORDER BY orden");
      break;
    }
    case "albaranescli": {
      curPartidas = new FLSqlCursor("partidasalb");
      curPartidas.select("idalbaran = " + curPartida.valueBuffer("idalbaran") + " AND orden >= " + iOrden + " AND idpartidaalb != " + curPartida.valueBuffer("idpartidaalb") + "ORDER BY orden");
      break;
    }
    case "facturascli": {
      curPartidas = new FLSqlCursor("partidasfact");
      curPartidas.select("idfactura = " + curPartida.valueBuffer("idfactura") + " AND orden >= " + iOrden + " AND idpartidafact != " + curPartida.valueBuffer("idpartidafact") + "ORDER BY orden");
      break;
    }
  }

  curPartidas.setActivatedCommitActions(false);
  curPartidas.setActivatedCheckIntegrity(false);
  while (curPartidas.next())
  {
    if (iOrden < curPartida.valueBuffer("orden")) {
      break;
    } else {
      iOrden++;
      curPartidas.setModeAccess(curPartidas.Edit);
      curPartidas.refreshBuffer();
      curPartidas.setValueBuffer("orden", iOrden);

      if (!curPartidas.commitBuffer()) {
        return false;
      }
      if (!this.iface.renumerarOrdenLineas(curPartidas, tabla)) {
        return false;
      }
    }
  }
  if (!this.iface.renumerarOrdenLineas(curPartida, tabla))
  {
    return false;
  }
  return true;
}

function partidasFact_renumerarOrdenLineas(curPartida: FLSqlCursor, tabla: String): Boolean {
  var util: FLUtil = new FLUtil();
  var curLinea: FLSqlCursor;
  switch (tabla)
  {
    case "presupuestoscli": {
      curLinea = new FLSqlCursor("lineaspresupuestoscli");
      curLinea.select("idpartida = " + curPartida.valueBuffer("idpartida"));
      break;
    }
    case "pedidoscli": {
      curLinea = new FLSqlCursor("lineaspedidoscli");
      curLinea.select("idpartidaped = " + curPartida.valueBuffer("idpartidaped"));
      break;
    }
    case "albaranescli": {
      curLinea = new FLSqlCursor("lineasalbaranescli");
      curLinea.select("idpartidaalb = " + curPartida.valueBuffer("idpartidaalb"));
      break;
    }
    case "facturascli": {
      curLinea = new FLSqlCursor("lineasfacturascli");
      curLinea.select("idpartidafact = " + curPartida.valueBuffer("idpartidafact"));
      break;
    }
  }
  curLinea.setActivatedCommitActions(false);
  curLinea.setActivatedCheckIntegrity(false);
  while (curLinea.next())
  {
    curLinea.setModeAccess(curLinea.Edit);
    curLinea.refreshBuffer();
    curLinea.setValueBuffer("ordenpartida", curPartida.valueBuffer("orden"));
    if (!curLinea.commitBuffer()) {
      return false;
    }
  }
  return true;
}

function partidasFact_afterCommit_lineaspresupuestoscli(curLinea: FLSqlCursor): Boolean {
  if (curLinea.modeAccess() == curLinea.Insert || (curLinea.modeAccess() == curLinea.Edit && curLinea.valueBufferCopy("numlinea") != curLinea.valueBuffer("numlinea")))
  {
    if (!this.iface.renumerarLineas(curLinea, "presupuestoscli")) {
      return false;
    }
  }
  return true;
}

function partidasFact_afterCommit_lineaspedidoscli(curLinea: FLSqlCursor): Boolean {
  if (!this.iface.__afterCommit_lineaspedidoscli(curLinea))
  {
    return false;
  }

  if (curLinea.modeAccess() == curLinea.Insert || (curLinea.modeAccess() == curLinea.Edit && curLinea.valueBufferCopy("numlinea") != curLinea.valueBuffer("numlinea")))
  {
    if (!this.iface.renumerarLineas(curLinea, "pedidoscli")) {
      return false;
    }
  }
  return true;
}

function partidasFact_afterCommit_lineasalbaranescli(curLinea: FLSqlCursor): Boolean {
  if (!this.iface.__afterCommit_lineasalbaranescli(curLinea))
  {
    return false;
  }

  if (curLinea.modeAccess() == curLinea.Insert || (curLinea.modeAccess() == curLinea.Edit && curLinea.valueBufferCopy("numlinea") != curLinea.valueBuffer("numlinea")))
  {
    if (!this.iface.renumerarLineas(curLinea, "albaranescli")) {
      return false;
    }
  }
  return true;
}

function partidasFact_afterCommit_lineasfacturascli(curLinea: FLSqlCursor): Boolean {
  if (!this.iface.__afterCommit_lineasfacturascli(curLinea))
  {
    return false;
  }

  if (curLinea.modeAccess() == curLinea.Insert || (curLinea.modeAccess() == curLinea.Edit && curLinea.valueBufferCopy("numlinea") != curLinea.valueBuffer("numlinea")))
  {
    if (!this.iface.renumerarLineas(curLinea, "facturascli")) {
      return false;
    }
  }
  return true;
}

function partidasFact_renumerarLineas(curLinea: FLSqlCursor, tabla: String): Boolean {
  var numLinea: Number = curLinea.valueBuffer("numlinea");
  var curLineas_: FLSqlCursor;
  switch (tabla)
  {
    case "presupuestoscli": {
      curLineas_ = new FLSqlCursor("lineaspresupuestoscli");
      curLineas_.select("idpresupuesto = " + curLinea.valueBuffer("idpresupuesto") + " AND numlinea >= " + numLinea + " AND idpartida = " + curLinea.valueBuffer("idpartida") + " AND idlinea != " + curLinea.valueBuffer("idlinea") + "ORDER BY numlinea");
      break;
    }
    case "pedidoscli": {
      curLineas_ = new FLSqlCursor("lineaspedidoscli");
      curLineas_.select("idpedido = " + curLinea.valueBuffer("idpedido") + " AND numlinea >= " + numLinea + " AND idpartidaped = " + curLinea.valueBuffer("idpartidaped") + " AND idlinea != " + curLinea.valueBuffer("idlinea") + "ORDER BY numlinea");
      break;
    }
    case "albaranescli": {
      curLineas_ = new FLSqlCursor("lineasalbaranescli");
      curLineas_.select("idalbaran = " + curLinea.valueBuffer("idalbaran") + " AND numlinea >= " + numLinea + " AND idpartidaalb = " + curLinea.valueBuffer("idpartidaalb") + " AND idlinea != " + curLinea.valueBuffer("idlinea") + "ORDER BY numlinea");
      break;
    }
    case "facturascli": {
      curLineas_ = new FLSqlCursor("lineasfacturascli");
      curLineas_.select("idfactura = " + curLinea.valueBuffer("idfactura") + " AND numlinea >= " + numLinea + " AND idpartidafact = " + curLinea.valueBuffer("idpartidafact") + " AND idlinea != " + curLinea.valueBuffer("idlinea") + "ORDER BY numlinea");
      break;
    }
  }
  curLineas_.setActivatedCommitActions(false);
  curLineas_.setActivatedCheckIntegrity(false);
  while (curLineas_.next())
  {
    if (numLinea < curLineas_.valueBuffer("numlinea")) {
      break;
    } else {
      numLinea++;
      curLineas_.setModeAccess(curLineas_.Edit);
      curLineas_.refreshBuffer();
      curLineas_.setValueBuffer("numlinea", numLinea);
      if (!curLineas_.commitBuffer()) {
        return false;
      }
    }
  }
  return true;
}

//// PARTIDAS FACTURACIÓN ///////////////////////////////////////
/////////////////////////////////////////////////////////////////
