/***************************************************************************
                 se_mastercontratos.qs  -  description
                             -------------------
    begin                : lun jun 20 2005
    copyright            : (C) 2005 by InfoSiAL S.L.
    email                : mail@infosial.com
 ***************************************************************************/

/***************************************************************************
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
 ***************************************************************************/

/** @file */
////////////////////////////////////////////////////////////////////////////
//// DECLARACION ///////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

/** @class_declaration interna */
//////////////////////////////////////////////////////////////////
//// INTERNA /////////////////////////////////////////////////////
class interna
{
  var ctx: Object;
  function interna(context)
  {
    this.ctx = context;
  }
  function init()
  {
    this.ctx.interna_init();
  }
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna
{
  var tableDBRecords;
  var chkVigentes;
  var deFecha;
  var curLineaFactura_: FLSqlCursor;
  function oficial(context)
  {
    interna(context);
  }

  function facturar(filtro)
  {
    return this.ctx.oficial_facturar(filtro);
  }
  function facturar_clicked()
  {
    return this.ctx.oficial_facturar_clicked();
  }
  function dameFiltroContratosAFacturar()
  {
    return this.ctx.oficial_dameFiltroContratosAFacturar();
  }
  function contratosPendientes()
  {
    return this.ctx.oficial_contratosPendientes();
  }
  function avisoContratosPendientes()
  {
    return this.ctx.oficial_avisoContratosPendientes();
  }
  function facturarContrato()
  {
    return this.ctx.oficial_facturarContrato();
  }
  function generarPeriodos(curContrato)
  {
    return this.ctx.oficial_generarPeriodos(curContrato);
  }
  function fechaContratoActivo(curCon)
  {
    return this.ctx.oficial_fechaContratoActivo(curCon);
  }
  function generarPeriodo(curCon: FLSqlCursor)
  {
    return this.ctx.oficial_generarPeriodo(curCon);
  }
  function generarFactura(idPeriodo: Number, codCliente: String, codContrato: String, coste: Number)
  {
    return this.ctx.oficial_generarFactura(idPeriodo, codCliente, codContrato, coste);
  }
  function datosFactura(curFactura: FLSqlCursor, codCliente: String, codContrato: String, idPeriodo: String)
  {
    return this.ctx.oficial_datosFactura(curFactura, codCliente, codContrato, idPeriodo);
  }
  function totalesFactura(curFactura: FLSqlCursor)
  {
    return this.ctx.oficial_totalesFactura(curFactura);
  }
  function numMeses(periodo: String)
  {
    return this.ctx.oficial_numMeses(periodo);
  }
  function actualizarPeriodo(idPeriodo, idFactura)
  {
    return this.ctx.oficial_actualizarPeriodo(idPeriodo, idFactura);
  }
  function actualizarContrato(idPeriodo)
  {
    return this.ctx.oficial_actualizarContrato(idPeriodo);
  }
  //  function cambiochkVigentes() {
  //    return this.ctx.oficial_cambiochkVigentes();
  //  }
  function datosLineaFactura(datosPeriodo: Array, codContrato: String)
  {
    return this.ctx.oficial_datosLineaFactura(datosPeriodo, codContrato);
  }
  function datosLineaAdFactura(curAA: FLSqlCursor, codContrato: String)
  {
    return this.ctx.oficial_datosLineaAdFactura(curAA, codContrato);
  }
  function generarContrato()
  {
    return this.ctx.oficial_generarContrato();
  }
  function valorCampoPlantilla(campo: String, cursor: FLSqlCursor)
  {
    return this.ctx.oficial_valorCampoPlantilla(campo, cursor);
  }
  function imprimirContrato()
  {
    return this.ctx.oficial_imprimirContrato();
  }
  function textoFecha(fecha: String)
  {
    return this.ctx.oficial_textoFecha(fecha);
  }
  function filtrarTabla()
  {
    return this.ctx.oficial_filtrarTabla();
  }
  function filtroTabla()
  {
    return this.ctx.oficial_filtroTabla();
  }
}
//// OFICIAL /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////
class head extends oficial
{
  function head(context)
  {
    oficial(context);
  }
}
//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration ifaceCtx */
/////////////////////////////////////////////////////////////////
//// INTERFACE  /////////////////////////////////////////////////
class ifaceCtx extends head
{
  function ifaceCtx(context)
  {
    head(context);
  }
  function pub_avisoContratosPendientes()
  {
    return this.avisoContratosPendientes();
  }
}

const iface = new ifaceCtx(this);
//// INTERFACE  /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition interna */
////////////////////////////////////////////////////////////////////////////
//// DEFINICION ////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
//// INTERNA /////////////////////////////////////////////////////
function interna_init()
{
  this.iface.chkVigentes = this.child("chkVigentes");
  this.iface.tableDBRecords = this.child("tableDBRecords");
  connect(this.child("pbnFacturar"), "clicked()", this, "iface.facturar_clicked");
  connect(this.child("pbnFacturarContrato"), "clicked()", this, "iface.facturarContrato");
  connect(this.iface.chkVigentes, "clicked()", this, "iface.filtrarTabla");
  connect(this.child("toolButtonGenerarContrato"), "clicked()", this, "iface.generarContrato");
  connect(this.child("toolButtonPrintContrato"), "clicked()", this, "iface.imprimirContrato");
  this.iface.chkVigentes.checked = false;

  this.iface.filtrarTabla();
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
/** \D
Genera los períodos de actualización para el contrato seleccionado
\end */
function oficial_facturarContrato()
{
  var cursor = this.cursor();
  if (!cursor.isValid()) {
    return;
  }
  var codigo = cursor.valueBuffer("codigo");
  return this.iface.facturar("codigo = '" + codigo + "'");
}

function oficial_facturar_clicked()
{
  var filtro = this.iface.dameFiltroContratosAFacturar();
  this.iface.facturar(filtro);
}

function oficial_dameFiltroContratosAFacturar()
{
  var cursor = this.cursor();
  return cursor.mainFilter();
}

/** \D
Genera los períodos de actualización para el mes presente y factura.
Se genera un periodo por cada contrato vigente.
\end */
function oficial_facturar(filtro)
{
  var util = new FLUtil();

  var res = MessageBox.information(util.translate("scripts", "A continuación se generarán los períodos a fecha actual y las facturas correspondientes.\n\n¿Continuar?"),
                                   MessageBox.Yes, MessageBox.No, MessageBox.NoButton);
  if (res != MessageBox.Yes)
    return;

  var hoy = new Date();

  var curTab = new FLSqlCursor("contratos");
  var curPed = new FLSqlCursor("periodoscontratos");

  if (filtro) {
    curTab.select("estado = 'Vigente' AND (activodesde IS NULL OR activodesde <= '" + hoy + "') AND " + filtro);
  } else {
    curTab.select("estado = 'Vigente' AND (activodesde IS NULL OR activodesde <= '" + hoy + "')");
  }
  var totalSteps = curTab.size();
  if (!totalSteps) {
    MessageBox.information(util.translate("scripts", "No se encontraron contratos pendientes de facturar"), MessageBox.Ok, MessageBox.NoButton);
    return;
  }

  util.createProgressDialog(util.translate("scripts", "Generando facturación"), totalSteps);
  var step = 0;

  var clientesFacturados = "";

  while (curTab.next()) {

    codContrato = curTab.valueBuffer("codigo");
    codCliente = curTab.valueBuffer("codcliente");

    // Generar período si no existe
    if (!this.iface.generarPeriodos(curTab)) {
      return false;
    }

    // Generar factura si procede de todos los periodos ptes de facturar hasta hoy
    curPed.select("codcontrato ='" + codContrato + "' AND facturado = false AND fechainicio <= '" + hoy + "'");
    var curT = new FLSqlCursor("empresa");
    while (curPed.next()) {
      curT.transaction(false);
      try {
        if (this.iface.generarFactura(curPed.valueBuffer("id"), codCliente, codContrato, curTab.valueBuffer("coste"))) {
          curT.commit();
          clientesFacturados += "\n- Contrato: " + codContrato + "  |  Cliente: " + util.sqlSelect("clientes", "nombre", "codcliente = '" +  codCliente + "'");
        } else {
          curT.rollback();
        }
      } catch (e) {
        curT.rollback();
        MessageBox.critical(util.translate("scripts", "Hubo un error en la generación de la factura para el cliente: %1").arg(util.sqlSelect("clientes", "nombre", "codcliente = '" +  codCliente + "'")) + "\n" + e, MessageBox.Ok, MessageBox.NoButton);
      }

    }

    util.setProgress(step);
    step++;
  }

  sys.AQTimer.singleShot(0, AQUtil.destroyProgressDialog);

  if (clientesFacturados)
    mensaje = util.translate("scripts", "Se facturaron los contratos siguientes:\n") + clientesFacturados;
  else {
    if (curPed.size() == 0)
      mensaje = util.translate("scripts", "No se encontraron contratos pendientes de facturar");
    else
      mensaje = util.translate("scripts", "No se ha facturado ningún contrato.");
  }

  MessageBox.information(mensaje, MessageBox.Ok, MessageBox.NoButton);
}

function oficial_generarPeriodos(curContrato)
{
  var _i = this.iface;
  var hoy = new Date();
  var util = new FLUtil;

  var codContrato = curContrato.valueBuffer("codigo");
  var fechaIni = _i.fechaContratoActivo(curContrato);
  if (curContrato.valueBuffer("factprimeromes")) {
    fechaIni.setDate(1);
  }
  var ultimaFecha = util.sqlSelect("periodoscontratos", "fechafin", "codcontrato ='" + codContrato + "' order by fechafin DESC");

  if (!ultimaFecha || util.daysTo(ultimaFecha, fechaIni) >= 0) {
    ultimaFecha = fechaIni;
  }

  while ((util.daysTo(ultimaFecha, hoy) > 0)) {
    if (!this.iface.generarPeriodo(curContrato)) {
      return false;
    }
    ultimaFecha = util.sqlSelect("periodoscontratos", "fechafin", "codcontrato ='" + codContrato + "' order by fechafin DESC");
  }
  return true;
}

function oficial_avisoContratosPendientes()
{
  var util = new FLUtil;
  var contratos = this.iface.contratosPendientes();
  if (contratos == "") {
    return true;
  }
  var usuario = sys.nameUser();
  var mensaje = util.translate("scripts", "Hola %1.\nLos siguientes contratos están pendientes de facturación:").arg(usuario) + contratos;
  MessageBox.information(mensaje, MessageBox.Ok, MessageBox.NoButton);

  return true;
}

function oficial_contratosPendientes()
{
  var util = new FLUtil;
  var qryContratos = new FLSqlQuery;
  qryContratos.setTablesList("contratos");
  qryContratos.setSelect("codigo, codcliente, nombrecliente");
  qryContratos.setFrom("contratos");
  qryContratos.setWhere("estado = 'Vigente'");
  qryContratos.setForwardOnly(true);
  if (!qryContratos.exec()) {
    return false;
  }
  var listaContratos = "";
  var codContrato: String;
  var hoy = new Date;
  var fechaHoy = hoy.toString().left(10);
  while (qryContratos.next()) {
    codContrato = qryContratos.value("codigo");
    if (util.sqlSelect("periodoscontratos", "id", "codcontrato = '" + codContrato + "' AND fechafin > '" + fechaHoy + "' AND facturado = true")) {
      continue;
    }
    listaContratos += "\n";
    listaContratos += util.translate("scripts", "Contrato %1 para %2 - %3").arg(codContrato).arg(qryContratos.value("codcliente")).arg(qryContratos.value("nombrecliente"));
  }
  return listaContratos;
}

function oficial_fechaContratoActivo(curCon)
{
  var fechaActivo;
  if (curCon.valueBuffer("activodesde") && curCon.valueBuffer("activodesde") != "") {
    fechaActivo = curCon.valueBuffer("activodesde");
  } else {
    fechaActivo = curCon.valueBuffer("fechainicio");
  }
  return fechaActivo;
}

/** \D
Genera el registro correspondiente a un periodo de actualización
@param codContrato Código del contrato al que pertenece el periodo
\end */
function oficial_generarPeriodo(curCon)
{
  var _i = this.iface;
  var util = new FLUtil();

  var fechaFin;
  var fechaInicio;
  var codContrato = curCon.valueBuffer("codigo");
  var mesesPeriodo = this.iface.numMeses(curCon.valueBuffer("periodopago"));
  var fechaActivo = _i.fechaContratoActivo(curCon);

  fechaInicio = AQUtil.sqlSelect("periodoscontratos", "fechafin", "codcontrato = '" + codContrato + "' ORDER BY fechafin DESC");
  if (fechaInicio) {
    if (AQUtil.daysTo(fechaActivo, fechaInicio) > 0) {
      if (curCon.valueBuffer("factprimeromes")) {
        fechaInicio = AQUtil.addMonths(fechaInicio, 1);
      } else {
        fechaInicio = AQUtil.addDays(fechaInicio, 1);
      }
    } else {
      fechaInicio = fechaActivo;
    }
  } else {
    fechaInicio = fechaActivo;
  }
  if (curCon.valueBuffer("factprimeromes")) {
    fechaInicio.setDate(1);
  }
  fechaFin = util.addMonths(fechaInicio, mesesPeriodo);
  fechaFin = util.addDays(fechaFin, -1);

  var curPeriodo = new FLSqlCursor("periodoscontratos");
  with(curPeriodo) {
    setModeAccess(Insert);
    refreshBuffer();
    setValueBuffer("codcontrato", codContrato);
    setValueBuffer("fechainicio", fechaInicio);
    setValueBuffer("fechafin", fechaFin);
    setValueBuffer("facturado", false);
    setValueBuffer("referencia", curCon.valueBuffer("referencia"));
    setValueBuffer("coste", curCon.valueBuffer("coste"));
    setValueBuffer("codimpuesto", curCon.valueBuffer("codimpuesto"));

    if (!commitBuffer()) {
      return false;
    }
  }
  return true;
}
/** \D
Genera la factura correspondiente a un periodo de actualizacion. Si el periodo fue
pagado en una factura anterior por varios meses, busca el id de dicha factura y lo asocia
al periodo

@param idPeriodo Identificador del periodo de actualizacion
@param codCliente Código del cliente al que se factura
@param coste Coste mensual del servicio
\end */
function oficial_generarFactura(idPeriodo: Number, codCliente: String, codContrato: String, coste: Number)
{
  var util = new FLUtil();

  var hoy = new Date();
  var curFactura = new FLSqlCursor("facturascli");

  if (!this.iface.datosFactura(curFactura, codCliente, codContrato, idPeriodo)) {
    return false;
  }
  if (!curFactura.commitBuffer()) {
    return false;
  }

  var idFactura = curFactura.valueBuffer("idfactura");

  var aplicarRecargo = util.sqlSelect("clientes", "recargo", "codcliente = '" + codCliente + "'");
  var datosPeriodo = flfactppal.iface.pub_ejecutarQry("periodoscontratos", "codcontrato,fechainicio,fechafin,referencia,coste,codimpuesto", "id = " + idPeriodo);

  var iva = 0;
  var recargo = 0;
  var datosImpuesto = flfacturac.iface.pub_datosImpuesto(datosPeriodo.codimpuesto, hoy);
  if (datosImpuesto) {
    iva = datosImpuesto.iva;
    if (aplicarRecargo)
      recargo = datosImpuesto.recargo;
  }

  var idFactura = curFactura.valueBuffer("idfactura");
  if (!this.iface.curLineaFactura_) {
    this.iface.curLineaFactura_ = new FLSqlCursor("lineasfacturascli");
  }
  var descripcion = util.sqlSelect("contratos", "descripcion", "codigo = '" + codContrato + "'");
  if (!descripcion)
    descripcion = "";

  /// Para el caso en que está instalada la extensión de IVA incluido
  var ivaIncluido = false;

  var curArt = new FLSqlCursor("articulos");
  var tipoIvaInc  = curArt.fieldType("ivaincluido");
  if (tipoIvaInc == 18) {
    ivaIncluido = util.sqlSelect("articulos", "ivaincluido", "referencia = '" + datosPeriodo.referencia + "'");
  } else {
    ivaIncluido = false;
  }

  var codEjercicio = flfactppal.iface.pub_ejercicioActual();

  /// Para el caso en que está instalada la extensión de subcuenta de ventas
  var datosContabilidad = new Array();
  datosContabilidad["result"] = 0;
  if (this.iface.curLineaFactura_.fieldType("codsubcuenta") == this.iface.curLineaFactura_.fieldType("referencia")) {
    datosContabilidad = flfactppal.iface.pub_ejecutarQry("articulos INNER JOIN co_subcuentas ON articulos.codsubcuentaven = co_subcuentas.codsubcuenta", "codsubcuentaven,idsubcuenta", "referencia = '" + datosPeriodo.referencia + "' AND codejercicio = '" + codEjercicio  + "'", "articulos,co_subcuentas");
  }
  with(this.iface.curLineaFactura_) {
    setModeAccess(Insert);
    refreshBuffer();
    setValueBuffer("idfactura", idFactura);
    setValueBuffer("referencia", datosPeriodo.referencia);
    setValueBuffer("descripcion", descripcion + " / Periodo " + datosPeriodo.fechainicio.toString().left(10) + "-" + datosPeriodo.fechafin.toString().left(10));
    setValueBuffer("codimpuesto", datosPeriodo.codimpuesto);
    setValueBuffer("iva", iva);
    setValueBuffer("recargo", recargo);
    if (ivaIncluido) {
      setValueBuffer("ivaincluido", true);
      setValueBuffer("pvpunitarioiva", datosPeriodo.coste);
      setValueBuffer("pvpunitario", formRecordlineaspedidoscli.iface.pub_commonCalculateField("pvpunitario2", this));
    } else {
      setValueBuffer("pvpunitario", datosPeriodo.coste);
      setValueBuffer("pvpunitarioiva", formRecordlineaspedidoscli.iface.pub_commonCalculateField("pvpunitarioiva2", this));
    }
    setValueBuffer("cantidad", 1);
    setValueBuffer("pvpsindto", formRecordlineaspedidoscli.iface.pub_commonCalculateField("pvpsindto", this));
    setValueBuffer("dtolineal", 0);
    setValueBuffer("dtopor", 0);
    setValueBuffer("pvptotal", formRecordlineaspedidoscli.iface.pub_commonCalculateField("pvptotal", this));
    if (datosContabilidad.result > 0) {
      if (datosContabilidad.idsubcuenta) {
        setValueBuffer("codsubcuenta", datosContabilidad.codsubcuentaven);
        setValueBuffer("idsubcuenta", datosContabilidad.idsubcuenta);
      }
    }
  }
  if (!this.iface.datosLineaFactura(datosPeriodo, codContrato)) {
    return false;
  }
  if (!this.iface.curLineaFactura_.commitBuffer()) {
    return false;
  }

  var numPeriodo = parseInt(util.sqlSelect("periodoscontratos", "COUNT(*)", "codcontrato = '" + codContrato + "'"));
  if (isNaN(numPeriodo)) {
    return false;
  }

  // Articulos adicionales
  var curAA = new FLSqlCursor("articuloscontratos");
  curAA.select("codcontrato = '" + codContrato + "'");
  var periodoDesde: Number;
  var periodoHasta: Number;
  while (curAA.next()) {

    periodoDesde = parseInt(curAA.valueBuffer("periododesde"));
    periodoDesde = (isNaN(periodoDesde) ? 0 : periodoDesde);
    periodoHasta = parseInt(curAA.valueBuffer("periodohesde"));
    periodoHasta = (isNaN(periodoDesde) ? 0 : periodoDesde);
    if (periodoDesde > 0 && periodoDesde > numPeriodo) {
      continue;
    }
    if (periodoHasta > 0 && periodoHasta < numPeriodo) {
      continue;
    }

    iva = 0;
    recargo = 0;
    datosImpuesto = flfacturac.iface.pub_datosImpuesto(curAA.valueBuffer("codimpuesto"), hoy);
    if (datosImpuesto) {
      iva = datosImpuesto.iva;
      if (aplicarRecargo)
        recargo = datosImpuesto.recargo;
    }

    /// Para el caso en que está instalada la extensión de IVA incluido
    if (tipoIvaInc == 18) {
      ivaIncluido = util.sqlSelect("articulos", "ivaincluido", "referencia = '" + curAA.valueBuffer("referencia") + "'");
    } else {
      ivaIncluido = false;
    }

    datosContabilidad = [];
    datosContabilidad["result"] = 0;
    if (this.iface.curLineaFactura_.fieldType("codsubcuenta") == this.iface.curLineaFactura_.fieldType("referencia")) {
      datosContabilidad = flfactppal.iface.pub_ejecutarQry("articulos INNER JOIN co_subcuentas ON articulos.codsubcuentaven = co_subcuentas.codsubcuenta", "codsubcuentaven,idsubcuenta", "referencia = '" + datosPeriodo.referencia + "' AND codejercicio = '" + codEjercicio  + "'", "articulos,co_subcuentas");
    }
    with(this.iface.curLineaFactura_) {
      setModeAccess(Insert);
      refreshBuffer();
      setValueBuffer("idfactura", idFactura);
      setValueBuffer("referencia", curAA.valueBuffer("referencia"));
      setValueBuffer("descripcion", curAA.valueBuffer("descripcion"));
      setValueBuffer("codimpuesto", curAA.valueBuffer("codimpuesto"));
      setValueBuffer("iva", iva);
      setValueBuffer("recargo", recargo);
      if (ivaIncluido) {
        setValueBuffer("ivaincluido", true);
        setValueBuffer("pvpunitarioiva", curAA.valueBuffer("coste"));
        setValueBuffer("pvpunitario", formRecordlineaspedidoscli.iface.pub_commonCalculateField("pvpunitario2", this));
      } else {
        setValueBuffer("pvpunitario", curAA.valueBuffer("coste"));
        setValueBuffer("pvpunitarioiva", formRecordlineaspedidoscli.iface.pub_commonCalculateField("pvpunitarioiva2", this));
      }
      setValueBuffer("cantidad", 1);
      setValueBuffer("pvpsindto", formRecordlineaspedidoscli.iface.pub_commonCalculateField("pvpsindto", this));
      setValueBuffer("dtolineal", 0);
      setValueBuffer("dtopor", 0);
      setValueBuffer("pvptotal", formRecordlineaspedidoscli.iface.pub_commonCalculateField("pvptotal", this));
      if (datosContabilidad.result > 0) {
        if (datosContabilidad.idsubcuenta) {
          setValueBuffer("codsubcuenta", datosContabilidad.codsubcuentaven);
          setValueBuffer("idsubcuenta", datosContabilidad.idsubcuenta);
        }
      }
    }

    if (!this.iface.datosLineaAdFactura(curAA, codContrato)) {
      return false;
    }

    if (!this.iface.curLineaFactura_.commitBuffer()) {
      return false;
    }
  }

  curFactura.select("idfactura = " + idFactura);

  if (!curFactura.first()) {
    return false;
  }

  curFactura.setModeAccess(curFactura.Edit);
  curFactura.refreshBuffer();

  if (!formRecordfacturascli.iface.pub_actualizarLineasIva(curFactura)) {
    return false;
  }

  this.iface.totalesFactura(curFactura);

  if (!curFactura.commitBuffer()) {
    return false;
  }

  this.iface.actualizarPeriodo(idPeriodo, idFactura);
  this.iface.actualizarContrato(idPeriodo);

  return true;
}

function oficial_datosFactura(curFactura: FLSqlCursor, codCliente: String, codContrato: String, idPeriodo: String)
{
  var util = new FLUtil();

  var hoy = new Date();

  var q = new FLSqlQuery();
  q.setTablesList("clientes");
  q.setFrom("clientes");
  q.setSelect("nombre,cifnif,coddivisa,codpago,codserie,codagente,recargo");
  q.setWhere("codcliente = '" + codCliente + "'");

  if (!q.exec()) return false;
  if (!q.first()) {
    MessageBox.warning(util.translate("scripts", "Error al obtener los datos del cliente\nNo se generará la factura de este cliente: ") + codCliente,
                       MessageBox.Ok, MessageBox.NoButton);
    return false;
  }

  var qDir = new FLSqlQuery();
  qDir.setTablesList("dirclientes");
  qDir.setFrom("dirclientes");
  qDir.setSelect("id,direccion,codpostal,ciudad,provincia,apartado,codpais");
  qDir.setWhere("codcliente = '" + codCliente + "' and domfacturacion = '" + true + "'");

  if (!qDir.exec()) return false;
  if (!qDir.first()) {
    MessageBox.warning(util.translate("scripts", "Error al obtener la dirección del cliente\nAsegúrate de que este cliente tiene una dirección de facturación\nNo se generará la factura de este cliente: ") + codCliente,
                       MessageBox.Ok, MessageBox.NoButton);
    return false;
  }

  var codEjercicio = flfactppal.iface.pub_ejercicioActual();
  var numeroFactura = flfacturac.iface.pub_siguienteNumero(q.value(4), codEjercicio, "nfacturacli");

  with(curFactura) {
    setModeAccess(Insert);
    refreshBuffer();

    setValueBuffer("codigo", flfacturac.iface.pub_construirCodigo(q.value(4), codEjercicio, numeroFactura));
    setValueBuffer("numero", numeroFactura);
    setValueBuffer("irpf", util.sqlSelect("series", "irpf", "codserie = '" + q.value(4) + "'"));
    setValueBuffer("recfinanciero", 0);

    setValueBuffer("codcliente", codCliente);
    setValueBuffer("nombrecliente", q.value(0));
    setValueBuffer("cifnif", q.value(1));

    setValueBuffer("codejercicio", codEjercicio);
    setValueBuffer("coddivisa", q.value(2));
    setValueBuffer("codpago", q.value(3));
    setValueBuffer("codalmacen", flfactppal.iface.pub_valorDefectoEmpresa("codalmacen"));
    setValueBuffer("codserie", q.value(4));
    setValueBuffer("tasaconv", util.sqlSelect("divisas", "tasaconv", "coddivisa = '" + q.value(2) + "'"));
    setValueBuffer("fecha", hoy);
    setValueBuffer("hora", hoy);

    setValueBuffer("codagente", q.value(5));
    setValueBuffer("porcomision", util.sqlSelect("agentes", "porcomision", "codagente = '" + q.value(5) + "'"));

    setValueBuffer("coddir", qDir.value(0));
    setValueBuffer("direccion", qDir.value(1));
    setValueBuffer("codpostal", qDir.value(2));
    setValueBuffer("ciudad", qDir.value(3));
    setValueBuffer("provincia", qDir.value(4));
    setValueBuffer("apartado", qDir.value(5));
    setValueBuffer("codpais", qDir.value(6));
  }

  return true;
}

function oficial_datosLineaFactura(datosPeriodo: Array, codContrato: String)
{
  return true;
}

function oficial_datosLineaAdFactura(curAA: FLSqlCursor, codContrato: String)
{
  return true;
}

/** \D
Una vez realizada la factura, actualiza el periodo de actualización marcándolo
como facturado y registrando el número de factura

@param idPeriodo Identificador del periodo de actualizacion
@param idFactura Identificador de la factura
\end */
function oficial_actualizarPeriodo(idPeriodo, idFactura)
{
  var curPeriodo = new FLSqlCursor("periodoscontratos");
  with(curPeriodo) {
    select("id = "  + idPeriodo);
    first();
    setModeAccess(Edit);
    refreshBuffer();
    setValueBuffer("facturado", true);
    setValueBuffer("idfactura", idFactura);
    commitBuffer();
  }
}

/** \D
Actualiza el contrato al que pertenece el período de actualización con la fecha
de último pago.
@param idPeriodo Identificador del periodo de actualizacion
\end */
function oficial_actualizarContrato(idPeriodo)
{
  var util = new FLUtil();
  var codContrato = util.sqlSelect("periodoscontratos", "codcontrato", "id = " + idPeriodo);

  var hoy = new Date();
  var curContrato = new FLSqlCursor("contratos");
  with(curContrato) {
    select("codigo = '" + codContrato + "'");
    first();
    setModeAccess(Edit);
    refreshBuffer();
    setValueBuffer("ultimopago", hoy);
    commitBuffer();
  }
}

/** \D
Devuelve el número de meses de un período

@param periodo Tipo de cuota (mensual, semestral, etc)
@return Número de meses del período
\end */
function oficial_numMeses(periodo: String)
{
  var arrayMeses: Array;
  arrayMeses["Mensual"] = 1;
  arrayMeses["Bimestral"] = 2;
  arrayMeses["Trimestral"] = 3;
  arrayMeses["Semestral"] = 6;
  arrayMeses["Anual"] = 12;
  arrayMeses["Bienal"] = 24;

  return arrayMeses[periodo];
}

/** \D Muestra sólo los períodos pendientes de facturar
\end */
// function oficial_cambiochkVigentes()
// {
//  if(this.iface.chkVigentes.checked == true)
//    this.iface.tableDBRecords.cursor().setMainFilter("estado = 'Vigente'");
//  else
//    this.iface.tableDBRecords.cursor().setMainFilter("");
//
//  this.iface.tableDBRecords.refresh();
// }

function oficial_generarContrato()
{
  var cursor = this.cursor();
  if (!cursor.isValid()) {
    return;
  }

  var util = new FLUtil();
  var comando: String;
  var oSys = util.getOS();

  var plantilla = util.sqlSelect("tiposcontrato", "plantilla", "codigo = '" + cursor.valueBuffer("tipocontrato") + "'");
  if (!plantilla || plantilla == "") {
    MessageBox.warning(util.translate("scripts", "No se ha establecido la plantilla para este contrato"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return;
  }

  // Ruta a los documentos de pacientes
  var pathDocumentos = util.readSettingEntry("scripts/fllaboppal/pathDocumentos");
  pathDocumentos = util.readSettingEntry("scripts/flfacturac/rutaOfertasOfertas");
  if (!File.isDir(pathDocumentos)) {
    MessageBox.warning(util.translate("scripts", "No se ha establecido la ruta en disco a los documentos,\no bien el directorio no existe\n\nPuede establecerla en las opciones de informes"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return false;
  }

  // Ruta a las plantillas de documentos
  var pathPlantillas = util.readSettingEntry("scripts/flfacturac/rutaOfertasPlantillas");
  if (!File.isDir(pathPlantillas)) {
    MessageBox.warning(util.translate("scripts", "No se ha establecido la ruta en disco a las plantillas de documentos,\no bien el directorio no existe\n\nPuede establecerla en las opciones de informes"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return false;
  }

  pathTmp = util.readSettingEntry("scripts/flfacturac/rutaOfertasTmp");
  if (!File.isDir(pathTmp)) {
    MessageBox.warning(util.translate("scripts", "No se ha establecido la ruta en disco al directorio temporal,\no bien el directorio no existe\n\nPuede establecerla en las opciones de informes"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return false;
  }

  var fichPlantilla = pathPlantillas + plantilla;
  if (!File.exists(fichPlantilla)) {
    MessageBox.warning(util.translate("scripts", "No se encontró la plantilla"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return false;
  }

  var fichDestino = util.translate("scripts", "Contrato_%1.odt").arg(cursor.valueBuffer("codigo"));
  if (File.exists(pathDocumentos + fichDestino)) {
    var res = MessageBox.warning(util.translate("scripts", "Este contrato ya fue generado. ¿Desea sobreescribirlo?"), MessageBox.Yes, MessageBox.No);
    if (res != MessageBox.Yes) {
      return false;
    }
  }

  var date = new Date();
  var dirTmp = util.sha1(sys.idSession());

  var objetoDir = new Dir(pathTmp);

  if (File.exists(pathTmp + dirTmp)) {
    objetoDir.rmdirs(dirTmp);
  }

  if (!File.exists(pathTmp + dirTmp)) {
    objetoDir.mkdir(dirTmp);
  }

  pathTmp += dirTmp + "/";

  if (File.exists(pathTmp + "content.xml")) {
    File.remove(pathTmp + "content.xml");
  }
  if (File.exists(pathTmp + fichDestino)) {
    File.remove(pathTmp + fichDestino);
  }

  // Copiar la plantilla al temporal y al final
  comando = new Array("cp", fichPlantilla, pathTmp + fichDestino);
  var proceso = new Process();
  proceso.arguments = comando;
  proceso.workingDirectory = pathTmp;
  try {
    proceso.start();
  } catch (e) {
    MessageBox.critical(comando + "\n\n" + util.translate("scripts", "Falló la ejecución del comando"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }

  while (proceso.running) {
    continue;
  }

  if (File.exists(pathDocumentos + fichDestino)) {
    File.remove(pathDocumentos + fichDestino);
  }

  comando = new Array("cp", fichPlantilla, pathDocumentos + fichDestino);
  var proceso = new Process();
  proceso.arguments = comando;
  proceso.workingDirectory = pathTmp;
  try {
    proceso.start();
  } catch (e) {
    MessageBox.critical(comando + "\n\n" + util.translate("scripts", "Falló la ejecución del comando"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }

  while (proceso.running) {
    continue;
  }

  // Obtener el content.xml de la plantilla odt mediante comando unzip
  comando = new Array("unzip", fichDestino, "content.xml");
  var proceso = new Process();
  proceso.arguments = comando;
  proceso.workingDirectory = pathTmp;
  try {
    proceso.start();
  } catch (e) {
    MessageBox.critical(comando + "\n\n" + util.translate("scripts", "Falló la ejecución del comando"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }

  while (proceso.running) {
    continue;
  }

  var contenido = File.read(pathTmp + "content.xml");
  var codificacion = util.readSettingEntry("scripts/flfacturac/encodingLocal");
  if (codificacion == "UTF") {
    codificacion = "utf8";
  }

  contenido = sys.toUnicode(contenido, codificacion);

  var xmlContenido = new FLDomDocument();
  if (!xmlContenido.setContent(contenido)) {
    MessageBox.critical(util.translate("scripts", "Error al establecer el contenido del documento XML"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  var xmlReferencias = xmlContenido.elementsByTagName("text:reference-ref");
  var xmlRef: FLDomNode;
  var campo: String;
  var valor: String;

  var arrayNodos = [];

  if (xmlReferencias) {
    var totalRef = xmlReferencias.length();
    for (var i = 0; i < totalRef; i++) {
      arrayNodos[i] = xmlReferencias.item(i).toElement();
    }
    for (var i = 0; i < totalRef; i++) {
      campo = arrayNodos[i].attribute("text:ref-name");
      valor = this.iface.valorCampoPlantilla(campo, cursor);
      var nodoT = xmlContenido.createTextNode(valor);
      arrayNodos[i].parentNode().replaceChild(nodoT, arrayNodos[i]);
    }
  }

  contenido = sys.fromUnicode(xmlContenido.toString(4), codificacion);

  // Volcar el nuevo contenido a content_xxxxx.xml
  File.write(pathTmp + "content.xml", contenido);

  comando = new Array("zip", "-uj", pathDocumentos + fichDestino, pathTmp + "content.xml");
  proceso.arguments = comando;
  try {
    proceso.start();
  } catch (e) {
    MessageBox.critical(comando + "\n\n" + util.translate("scripts", "Falló la ejecución del comando"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }

  while (proceso.running) {
    continue;
  }

  res = MessageBox.information(util.translate("scripts", "Se creó el documento de contrato\n¿Desea abrirlo?"), MessageBox.Yes, MessageBox.No, MessageBox.NoButton);
  if (res == MessageBox.Yes) {
    sys.openUrl("file://" + pathDocumentos  + fichDestino);
    //    var comandoOOW= util.readSettingEntry("scripts/flfacturac/comandoWriter");
    //    if (!comandoOOW) {
    //      MessageBox.warning( util.translate( "scripts", "No se ha establecido el comando de OpenOffice de documentos de texto\nPuede establecerlo en las opciones de informes" ), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton );
    //      return;
    //    }
    //
    //    comando = new Array(comandoOOW, pathDocumentos + fichDestino);
    //    proceso.arguments = comando;
    //    try {
    //      proceso.start();
    //    }
    //    catch (e) {
    //      MessageBox.critical(comando + "\n\n" + util.translate("scripts", "Falló la ejecución del comando"), MessageBox.Ok, MessageBox.NoButton);
    //      return false;
    //    }
  }
}

function oficial_valorCampoPlantilla(campo: String, cursor: FLSqlCursor)
{
  var util = new FLUtil;
  var valor: String;
  var campoUp = campo.toUpperCase();
  switch (campoUp) {
    case "NOMBRE_CLIENTE": {
      valor = util.sqlSelect("clientes", "nombre", "codcliente = '" + cursor.valueBuffer("codcliente") + "'");
      break;
    }
    case "NIF_CLIENTE": {
      valor = util.sqlSelect("clientes", "cifnif", "codcliente = '" + cursor.valueBuffer("codcliente") + "'");
      break;
    }
    case "CUENTA_PAGO_CLIENTE": {
      var qryCuentaDom = new FLSqlQuery();
      qryCuentaDom.setTablesList("clientes,cuentasbcocli");
      qryCuentaDom.setSelect("ctaentidad, ctaagencia, cuenta");
      qryCuentaDom.setFrom("clientes c INNER JOIN cuentasbcocli cc ON c.codcuentadom = cc.codcuenta");
      qryCuentaDom.setWhere("c.codcliente = '" + cursor.valueBuffer("codcliente") + "'");
      qryCuentaDom.setForwardOnly(true);
      if (!qryCuentaDom.exec()) {
        return "";
      }
      if (!qryCuentaDom.first()) {
        return "";
      }
      var entidad = qryCuentaDom.value("ctaentidad");
      var agencia = qryCuentaDom.value("ctaagencia");
      var cuenta = qryCuentaDom.value("cuenta");
      valor = entidad + " " + agencia + " " + util.calcularDC(entidad + agencia) + util.calcularDC(cuenta) + " " + cuenta;
      break;
    }
    case "PERIODICIDAD": {
      valor = cursor.valueBuffer("periodopago");
      break;
    }
    case "IMPORTE": {
      valor = cursor.valueBuffer("coste");
      break;
    }
    case "FECHA_INICIO": {
      var fechaInicio = cursor.valueBuffer("fechainicio");
      valor = this.iface.textoFecha(fechaInicio.toString());
      break;
    }
    case "TIPO": {
      valor = util.sqlSelect("tiposcontrato", "nombre", "codigo = '" + cursor.valueBuffer("tipocontrato") + "'");
      break;
    }
    case "DESCRIPCION": {
      valor = cursor.valueBuffer("descripcion");
      break;
    }
    case "OBSERVACIONES": {
      valor = cursor.valueBuffer("observaciones");
      break;
    }
    case "CONDICIONES": {
      valor = cursor.valueBuffer("condiciones");
      break;
    }
    case "DIR_CLIENTE": {
      valor = util.sqlSelect("dirclientes", "direccion", "codcliente = '" + cursor.valueBuffer("codcliente") + "' AND domfacturacion = true");
      break;
    }
    case "CIUDAD_CLIENTE": {
      valor = util.sqlSelect("dirclientes", "ciudad", "codcliente = '" + cursor.valueBuffer("codcliente") + "' AND domfacturacion = true");
      break;
    }
    case "PROVINCIA_CLIENTE": {
      valor = util.sqlSelect("dirclientes", "provincia", "codcliente = '" + cursor.valueBuffer("codcliente") + "' AND domfacturacion = true");
      break;
    }
    case "PAIS_CLIENTE": {
      valor = util.sqlSelect("dirclientes d INNER JOIN paises p ON d.codpais = p.codpais", "p.nombre", "d.codcliente = '" + cursor.valueBuffer("codcliente") + "' AND d.domfacturacion = true", "dirclienes,paises");
      break;
    }
    case "FECHA": {
      var hoy = new Date;
      valor = this.iface.textoFecha(hoy.toString());
    }
  }
  if (!valor) {
    valor = "";
  }
  return valor;
}

function oficial_textoFecha(fecha: String)
{
  var util: FLUtil;
  if (!fecha || fecha == "") {
    return "";
  }
  var mes = fecha.mid(5, 2);
  var textoMes: String;
  switch (mes) {
    case "01": {
      textoMes = util.translate("scripts", "Enero");
      break;
    }
    case "02": {
      textoMes = util.translate("scripts", "Febrero");
      break;
    }
    case "03": {
      textoMes = util.translate("scripts", "Marzo");
      break;
    }
    case "04": {
      textoMes = util.translate("scripts", "Abril");
      break;
    }
    case "05": {
      textoMes = util.translate("scripts", "Mayo");
      break;
    }
    case "06": {
      textoMes = util.translate("scripts", "Junio");
      break;
    }
    case "07": {
      textoMes = util.translate("scripts", "Julio");
      break;
    }
    case "08": {
      textoMes = util.translate("scripts", "Agosto");
      break;
    }
    case "09": {
      textoMes = util.translate("scripts", "Septiembre");
      break;
    }
    case "10": {
      textoMes = util.translate("scripts", "Octubre");
      break;
    }
    case "11": {
      textoMes = util.translate("scripts", "Noviembre");
      break;
    }
    case "12": {
      textoMes = util.translate("scripts", "Diciembre");
      break;
    }
  }
  var dia = parseInt(fecha.mid(8, 2));
  var ano = parseInt(fecha.mid(0, 4));
  var texto = util.translate("scripts", "%1 de %2 de %3").arg(dia.toString()).arg(textoMes).arg(ano);
  return texto;
}

function oficial_imprimirContrato()
{
  var cursor = this.cursor();

  if (!cursor.isValid())
    return;

  var util = new FLUtil();

  // Ruta a los documentos de pacientes
  var pathDocumentos = util.readSettingEntry("scripts/fllaboppal/pathDocumentos");
  pathDocumentos = util.readSettingEntry("scripts/flfacturac/rutaOfertasOfertas");
  if (!File.isDir(pathDocumentos)) {
    MessageBox.warning(util.translate("scripts", "No se ha establecido la ruta en disco a los documentos,\no bien el directorio no existe\n\nPuede establecerla en las opciones de informes"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return false;
  }

  var fichDestino = "Contrato_" + cursor.valueBuffer("codigo") + ".odt";
  if (!File.exists(pathDocumentos + fichDestino)) {
    MessageBox.warning(util.translate("scripts", "No existe el fichero de este contrato. Deberá generarlo"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return false;
  }

  var comandoOOW = util.readSettingEntry("scripts/flfacturac/comandoWriter");
  if (!comandoOOW) {
    MessageBox.warning(util.translate("scripts", "No se ha establecido el comando de OpenOffice de documentos de texto\nPuede establecerlo en las opciones de informes"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return;
  }

  sys.openUrl("file://" + pathDocumentos  + fichDestino);

  //  var proceso = new Process();//
  //  comando = new Array(comandoOOW, pathDocumentos + fichDestino);
  //  proceso.arguments = comando;
  //  try {
  //    proceso.start();
  //  }
  //  catch (e) {
  //    MessageBox.critical(comando + "\n\n" + util.translate("scripts", "Falló la ejecución del comando"), MessageBox.Ok, MessageBox.NoButton);
  //    return false;
  //  }
}

function oficial_totalesFactura(curFactura: FLSqlCursor)
{
  with(curFactura) {
    setModeAccess(Edit);
    refreshBuffer();
    /// Para el caso en que está instalada la extensión de descuento especial
    if (curFactura.fieldType("netosindtoesp") == curFactura.fieldType("neto")) {
      setValueBuffer("netosindtoesp", formfacturascli.iface.pub_commonCalculateField("netosindtoesp", curFactura));
      setValueBuffer("dtoesp", formfacturascli.iface.pub_commonCalculateField("dtoesp", curFactura));
    }
    setValueBuffer("neto", formfacturascli.iface.pub_commonCalculateField("neto", curFactura));
    setValueBuffer("totaliva", formfacturascli.iface.pub_commonCalculateField("totaliva", curFactura));
    setValueBuffer("totalirpf", formfacturascli.iface.pub_commonCalculateField("totalirpf", curFactura));
    setValueBuffer("totalrecargo", formfacturascli.iface.pub_commonCalculateField("totalrecargo", curFactura));
    setValueBuffer("total", formfacturascli.iface.pub_commonCalculateField("total", curFactura));
    setValueBuffer("totaleuros", formfacturascli.iface.pub_commonCalculateField("totaleuros", curFactura));
    setValueBuffer("codigo", formfacturascli.iface.pub_commonCalculateField("codigo", curFactura));
  }
}

function oficial_filtrarTabla()
{
  var cursor = this.cursor();
  var filtro = this.iface.filtroTabla();
  if (filtro != cursor.mainFilter()) {
    cursor.setMainFilter(filtro);
    this.child("tableDBRecords").refresh();
  }
  return true;
}

function oficial_filtroTabla()
{
  var filtro = "";

  if (this.iface.chkVigentes.checked) {
    filtro = "estado = 'Vigente'";
  }
  return filtro;
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
