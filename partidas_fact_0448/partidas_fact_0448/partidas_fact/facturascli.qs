
/** @class_declaration partidas */
/////////////////////////////////////////////////////////////////
//// PARTIDAS_FACT /////////////////////////////////////////////
class partidas extends dtoEspecial
{
  var bloqueoGastos: Boolean;
  var bloqueoBeneficio: Boolean;
  var curLineaPar_: FLSqlCursor;
  function partidas(context)
  {
    dtoEspecial(context);
  }
  function init()
  {
    return this.ctx.partidas_init();
  }
  function bufferChanged(fN: String)
  {
    return this.ctx.partidas_bufferChanged(fN);
  }
  function actualizarLineasIva(curFactura: FLSqlCursor): Boolean {
    return this.ctx.partidas_actualizarLineasIva(curFactura);
  }
  function calcularTotales()
  {
    return this.ctx.partidas_calcularTotales();
  }
  function filtrarLineas()
  {
    return this.ctx.partidas_filtrarLineas();
  }
  function insertarLinea()
  {
    return this.ctx.partidas_insertarLinea();
  }
  function editarLinea()
  {
    return this.ctx.partidas_editarLinea();
  }
  function borrarLinea()
  {
    return this.ctx.partidas_borrarLinea();
  }
  function guardar()
  {
    return this.ctx.partidas_guardar();
  }
  function comprobarCapituloActivo(): String {
    return this.ctx.partidas_comprobarCapituloActivo();
  }
}
//// PARTIDAS_FACT /////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pubPartidas */
/////////////////////////////////////////////////////////////////
//// PUB_PARTIDAS ///////////////////////////////////////////////
class pubPartidas extends ifaceCtx
{
  function pubPartidas(context)
  {
    ifaceCtx(context);
  }
  function pub_comprobarCapituloActivo(): String {
    return this.comprobarCapituloActivo();
  }
}

//// PUB_PARTIDAS ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition partidas */
/////////////////////////////////////////////////////////////////
//// PARTIDAS_FACT //////////////////////////////////////////////
function partidas_init()
{
  this.iface.__init();
  connect(this.child("tdbPartidasFact").cursor(), "bufferCommited()", this, "iface.calcularTotales()");
  connect(this.child("tdbPartidasFact").cursor(), "newBuffer()", this, "iface.filtrarLineas");
  this.iface.filtrarLineas();
  connect(this.child("chkMostrarTodas"), "clicked()", this, "iface.filtrarLineas");

  connect(this.child("toolButtomInsert"), "clicked()", this, "iface.insertarLinea");
  connect(this.child("toolButtonEdit"), "clicked()", this, "iface.editarLinea");
  connect(this.child("toolButtonDelete"), "clicked()", this, "iface.borrarLinea");
  this.iface.bloqueoGastos = false;
  this.iface.bloqueoBeneficio = false;
}

function partidas_bufferChanged(fN: String)
{
  switch (fN) {
    case "netosindtoesp": {
      if (!this.iface.bloqueoDto) {
        this.iface.bloqueoDto = true;
        this.child("fdbDtoEsp").setValue(this.iface.calculateField("dtoesp"));
        this.iface.bloqueoDto = false;
      }
      if (!this.iface.bloqueoGastos) {
        this.iface.bloqueoGastos = true;
        this.child("fdbGastos").setValue(this.iface.calculateField("gastos"));
        this.iface.bloqueoGastos = false;
      }
      if (!this.iface.bloqueoBeneficio) {
        this.iface.bloqueoBeneficio = true;
        this.child("fdbBeneficio").setValue(this.iface.calculateField("beneficio"));
        this.iface.bloqueoBeneficio = false;
      }
      break;
    }
    case "porgastos": {
      if (!this.iface.bloqueoGastos) {
        this.iface.bloqueoGastos = true;
        this.child("fdbGastos").setValue(this.iface.calculateField("gastos"));
        this.iface.bloqueoGastos = false;
      }
      break;
    }
    case "gastos": {
      if (!this.iface.bloqueoGastos) {
        this.iface.bloqueoGastos = true;
        this.child("fdbPorGastos").setValue(this.iface.calculateField("porgastos"));
        this.iface.bloqueoGastos = false;
      }
      this.child("fdbNeto").setValue(this.iface.calculateField("neto"));
      break;
    }
    case "porbeneficio": {
      if (!this.iface.bloqueoBeneficio) {
        this.iface.bloqueoBeneficio = true;
        this.child("fdbBeneficio").setValue(this.iface.calculateField("beneficio"));
        this.iface.bloqueoBeneficio = false;
      }
      break;
    }
    case "beneficio": {
      if (!this.iface.bloqueoBeneficio) {
        this.iface.bloqueoBeneficio = true;
        this.child("fdbPorBeneficio").setValue(this.iface.calculateField("porbeneficio"));
        this.iface.bloqueoBeneficio = false;
      }
      this.child("fdbNeto").setValue(this.iface.calculateField("neto"));
      break;
    }
    default: {
      this.iface.__bufferChanged(fN);
      break;
    }
  }
}

/** \D
Actualiza (borra y reconstruye) los datos referentes a la factura en la tabla de agrupaciones por IVA (lineasivafactcli)
@param curFactura: Cursor posicionado en la factura
\end */
function partidas_actualizarLineasIva(curFactura: FLSqlCursor): Boolean {
  var util: FLUtil = new FLUtil;
  var idFactura: String;
  try {
    idFactura = curFactura.valueBuffer("idfactura");
  } catch (e)
  {
    // Antes se recibía sólo idFactura
    MessageBox.critical(util.translate("scripts", "Hay un problema con la actualización de su personalización.\nPor favor, póngase en contacto con InfoSiAL para solucionarlo"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }

  var porGastos: Number = parseFloat(curFactura.valueBuffer("porgastos"));
  if (isNaN(porGastos))
  {
    porGastos = 0;
  }
  var porBeneficio: Number = parseFloat(curFactura.valueBuffer("porbeneficio"));
  if (isNaN(porBeneficio))
  {
    porBeneficio = 0;
  }
  if (porGastos == 0 && porBeneficio == 0)
  {
    return this.iface.__actualizarLineasIva(curFactura);
  }

  var porDto: Number = parseFloat(curFactura.valueBuffer("pordtoesp"));
  if (isNaN(porDto))
  {
    porDto = 0;
  }

  var porTotal: Number = parseFloat(porBeneficio) + parseFloat(porGastos) - parseFloat(porDto);

  var netoExacto: Number = curFactura.valueBuffer("neto");
  var lineasSinIVA: Number = util.sqlSelect("lineasfacturascli", "SUM(pvptotal)", "idfactura = " + idFactura + " AND iva IS NULL");
  lineasSinIVA = (isNaN(lineasSinIVA) ? 0 : lineasSinIVA);
  netoExacto -= lineasSinIVA;
  netoExacto = util.roundFieldValue(netoExacto, "facturascli", "neto");

  var ivaExacto: Number = util.sqlSelect("lineasfacturascli", "SUM((pvptotal * iva * (100 + " + porTotal + ")) / 100 / 100)", "idfactura = " + idFactura);
  if (!ivaExacto)
    ivaExacto = 0;
  var reExacto: Number = util.sqlSelect("lineasfacturascli", "SUM((pvptotal * recargo * (100 + " + porTotal + ")) / 100 / 100)", "idfactura = " + idFactura);
  if (!reExacto)
    reExacto = 0;

  if (!util.sqlDelete("lineasivafactcli", "idfactura = " + idFactura))
    return false;

  var codImpuestoAnt: Number = 0;
  var codImpuesto: Number = 0;
  var iva: Number;
  var recargo: Number;
  var totalNeto: Number = 0;
  var totalIva: Number = 0;
  var totalRecargo: Number = 0;
  var totalLinea: Number = 0;
  var acumNeto: Number = 0;
  var acumIva: Number = 0;
  var acumRecargo: Number = 0;

  var curLineaIva: FLSqlCursor = new FLSqlCursor("lineasivafactcli");
  var qryLineasFactura: FLSqlQuery = new FLSqlQuery;
  with(qryLineasFactura)
  {
    setTablesList("lineasfacturascli");
    setSelect("codimpuesto, iva, recargo, pvptotal");
    setFrom("lineasfacturascli");
    setWhere("idfactura = " + idFactura + " AND pvptotal <> 0 AND iva IS NOT NULL ORDER BY codimpuesto");
    setForwardOnly(true);
  }
  if (!qryLineasFactura.exec())
    return false;

  while (qryLineasFactura.next())
  {
    codImpuesto = qryLineasFactura.value("codimpuesto");
    if (codImpuestoAnt != 0 && codImpuestoAnt != codImpuesto) {
      totalNeto = (totalNeto * ((100 + porTotal) / 100));
      totalNeto = util.roundFieldValue(totalNeto, "lineasivafactcli", "neto");
      totalIva = util.roundFieldValue((iva * totalNeto) / 100, "lineasivafactcli", "totaliva");
      totalRecargo = util.roundFieldValue((recargo * totalNeto) / 100, "lineasivafactcli", "totalrecargo");
      totalLinea = parseFloat(totalNeto) + parseFloat(totalIva) + parseFloat(totalRecargo);
      totalLinea = util.roundFieldValue(totalLinea, "lineasivafactcli", "totallinea");

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
      if (!curLineaIva.commitBuffer())
        return false;
      totalNeto = 0;
    }
    codImpuestoAnt = codImpuesto;
    iva = parseFloat(qryLineasFactura.value("iva"));
    recargo = parseFloat(qryLineasFactura.value("recargo"));
    totalNeto += parseFloat(qryLineasFactura.value("pvptotal"));
  }

  if (totalNeto != 0)
  {
    totalNeto = util.roundFieldValue(netoExacto - acumNeto, "lineasivafactcli", "neto");
    totalIva = util.roundFieldValue(ivaExacto - acumIva, "lineasivafactcli", "totaliva");
    totalRecargo = util.roundFieldValue(reExacto - acumRecargo, "lineasivafactcli", "totalrecargo");
    totalLinea = parseFloat(totalNeto) + parseFloat(totalIva) + parseFloat(totalRecargo);
    totalLinea = util.roundFieldValue(totalLinea, "lineasivafactcli", "totallinea");

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
    if (!curLineaIva.commitBuffer())
      return false;
  }
  return true;
}

function partidas_insertarLinea()
{
  this.iface.guardar();
  this.child("tdbLineasFacturasCli").cursor().insertRecord();
}

function partidas_editarLinea()
{
  this.iface.guardar();
  this.child("tdbLineasFacturasCli").editRecord();
}

function partidas_borrarLinea()
{
  this.iface.guardar();
  this.child("tdbLineasFacturasCli").deleteRecord();
}

function partidas_guardar()
{
  var cursor: FLSqlCursor = this.cursor();
  var idFactura: String = cursor.valueBuffer("idfactura");

  while (cursor.transactionLevel() > 1) {
    sys.processEvents();
  }
  cursor.commitBuffer();
  cursor.commit();
  cursor.transaction(false);
  cursor.select("idfactura = " + idFactura);
  cursor.first();
  cursor.setModeAccess(cursor.Edit);
  cursor.refreshBuffer();
}

function partidas_calcularTotales()
{
  this.iface.filtrarLineas();
  this.iface.__calcularTotales();
}

function partidas_filtrarLineas()
{
  var util: FLUtil = new FLUtil;
  var filtro: String = "";
  var textoFiltro: String = "";
  var curPartidas: FLSqlCursor = this.child("tdbPartidasFact").cursor();
  var idPartida: String = curPartidas.valueBuffer("idpartidafact");
  if (!idPartida || idPartida == "" || this.child("chkMostrarTodas").checked) {
    textoFiltro = util.translate("scripts", "Mostrando todas las líneas");
  } else {
    var desPartida: String = curPartidas.valueBuffer("descripcion");
    textoFiltro = util.translate("scripts", "Líneas de %1").arg(desPartida);
    filtro = "idpartidafact = " + idPartida;
  }
  this.child("lblFiltro").text = textoFiltro;
  this.child("tdbLineasFacturasCli").setFilter(filtro);
  this.child("tdbLineasFacturasCli").refresh();
}

function partidas_comprobarCapituloActivo(): String {
  var valor: String;
  var curPartidas: FLSqlCursor = this.child("tdbPartidasFact").cursor();
  var idPartida: String = curPartidas.valueBuffer("idpartidafact");
  if (!idPartida || idPartida == "" || this.child("chkMostrarTodas").checked)
  {
    valor = "";
  } else {
    valor = idPartida;
  }
  return valor;
}

//// PARTIDAS_FACT //////////////////////////////////////////////
///////////////////////////////////////////////////////////////
