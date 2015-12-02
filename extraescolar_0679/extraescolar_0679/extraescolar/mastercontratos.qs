
/** @class_declaration extraescolar */
/////////////////////////////////////////////////////////////////
//// EXTRAESCOLAR ///////////////////////////////////////////////
class extraescolar extends oficial
{
  var aMesesFac_;
  var codCentroEsc_;
  var bloqueoG_;
  function extraescolar(context)
  {
    oficial(context);
  }
  function init()
  {
    return this.ctx.extraescolar_init();
  }
  function establecerCentro()
  {
    return this.ctx.extraescolar_establecerCentro();
  }
  function tdbGrupos_primaryKeyToggled(pK, on)
  {
    return this.ctx.extraescolar_tdbGrupos_primaryKeyToggled(pK, on);
  }
  function filtroTabla()
  {
    return this.ctx.extraescolar_filtroTabla();
  }
  function generarFactura(idPeriodo, codCliente, codContrato, coste)
  {
    return this.ctx.extraescolar_generarFactura(idPeriodo, codCliente, codContrato, coste);
  }
  function crearLineaFacturaActividad(aDatosLinea)
  {
    return this.ctx.extraescolar_crearLineaFacturaActividad(aDatosLinea);
  }
  function datosLineaFacturaActividad(aDatosLinea)
  {
    return this.ctx.extraescolar_datosLineaFacturaActividad(aDatosLinea);
  }
  function calcularDiasActividad(codActividad, codAlumno, fInicio, fFin)
  {
    return this.ctx.extraescolar_calcularDiasActividad(codActividad, codAlumno, fInicio, fFin);
  }
  function facturar(filtro)
  {
    return this.ctx.extraescolar_facturar(filtro);
  }
  function generarFacturaBecador(idPeriodo, codCliente, codContrato, coste)
  {
    return this.ctx.extraescolar_generarFacturaBecador(idPeriodo, codCliente, codContrato, coste);
  }
  function dameMasWhereFacturaBecador(idPeriodo, codCliente, codContrato)
  {
    return this.ctx.extraescolar_dameMasWhereFacturaBecador(idPeriodo, codCliente, codContrato);
  }
  function generarPeriodos(curContrato)
  {
    return this.ctx.extraescolar_generarPeriodos(curContrato);
  }
  function establecerMesesFacturacion()
  {
    return this.ctx.extraescolar_establecerMesesFacturacion();
  }
  function dameFiltroContratosAFacturar()
  {
    return this.ctx.extraescolar_dameFiltroContratosAFacturar();
  }
  function lineasAdicionalesBecador(codContrato, idFactura)
  {
    return this.ctx.extraescolar_lineasAdicionalesBecador(codContrato, idFactura);
  }
  function dameDesLineaContrato(aActividad, tipoAsistencia)
  {
    return this.ctx.extraescolar_dameDesLineaContrato(aActividad, tipoAsistencia);
  }
  function filtrarGrupos()
  {
    return this.ctx.extraescolar_filtrarGrupos();
  }
  function filtrarAlumnos()
  {
    return this.ctx.extraescolar_filtrarAlumnos();
  }
  function chkTodosGrupos_clicked(on)
  {
    return this.ctx.extraescolar_chkTodosGrupos_clicked(on);
  }
  function datosFactura(curFactura, codCliente, codContrato, idPeriodo)
  {
    return this.ctx.extraescolar_datosFactura(curFactura, codCliente, codContrato, idPeriodo);
  }
}
//// EXTRAESCOLAR ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition extraescolar */
/////////////////////////////////////////////////////////////////
//// EXTRAESCOLAR //////////////////////////////////////////////
function extraescolar_facturar(filtro)
{
  if (!this.iface.establecerMesesFacturacion()) {
    return false;
  }
  var cursor = this.cursor();
  var util = new FLUtil();

  var masFiltro = "codcliente IN (SELECT codcliente FROM clientes WHERE becador <> false)";
  if (!filtro) {
    filtro = masFiltro;
  }

  this.iface.__facturar(filtro);
}
function extraescolar_establecerMesesFacturacion()
{
  var util = new FLUtil;
  var hoy = new Date;
  var numMeses = 4
                 hoy.setDate(1);
  var mes = util.addMonths(hoy, (numMeses - 1) * -1);
  var dialogo = new Dialog;
  dialogo.caption = util.translate("scripts", "Indique los meses a facturar");
  dialogo.okButtonText = util.translate("scripts", "OK");
  dialogo.cancelButtonText = util.translate("scripts", "Cancelar");
  var chBox = new Array(numMeses);
  var aFechas = new Array(numMeses);
  this.iface.aMesesFac_ = [];
  for (i = 0; i < numMeses; i++) {
    chBox[i] = new CheckBox;
    chBox[i].text = util.translate("scripts", "Mes %1 de %2").arg(mes.getMonth()).arg(mes .getYear());
    aFechas[i] = new Date(Date.parse(mes.toString()));
    mes = util.addMonths(mes, 1);
    dialogo.add(chBox[i]);
  }
  if (!dialogo.exec()) {
    return false;
  }
  for (i = 0; i < numMeses; i++) {
    if (chBox[i].checked) {
      this.iface.aMesesFac_.push(new Date(Date.parse(aFechas[i].toString())));
    }
  }
  if (this.iface.aMesesFac_.length == 0) {
    return false;
  }
  return true;
}

function extraescolar_generarPeriodos(curContrato)
{
  if (this.iface.aMesesFac_ == undefined) {
    return false;
  }
  var util = new FLUtil;
  var fechaInicio;
  var fechaFin;
  var curPeriodo = new FLSqlCursor("periodoscontratos");
  var codContrato = curContrato.valueBuffer("codigo");
  for (var i = 0; i < this.iface.aMesesFac_.length; i++) {
    fechaInicio = this.iface.aMesesFac_[i];
    fechaFin = util.addMonths(fechaInicio, 1);
    fechaFin = util.addDays(fechaFin, -1);
    if (util.sqlSelect("periodoscontratos", "id", "codcontrato = '" + codContrato + "' AND fechainicio = '" + fechaInicio.toString().left(10) + "'")) {
      continue;
    }
    with(curPeriodo) {
      setModeAccess(Insert);
      refreshBuffer();
      setValueBuffer("codcontrato", codContrato);
      setValueBuffer("fechainicio", fechaInicio);
      setValueBuffer("fechafin", fechaFin);
      setValueBuffer("facturado", false);
      setValueBuffer("referencia", curContrato.valueBuffer("referencia"));
      setValueBuffer("coste", curContrato.valueBuffer("coste"));
      setValueBuffer("codimpuesto", curContrato.valueBuffer("codimpuesto"));
      if (!commitBuffer()) {
        return false;
      }
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
function extraescolar_generarFactura(idPeriodo, codCliente, codContrato, coste)
{
  var util = new FLUtil();

  if (util.sqlSelect("clientes", "becador", "codcliente = '" + codCliente + "'")) {
    return this.iface.generarFacturaBecador(idPeriodo, codCliente, codContrato, coste);
  }

  var hoy = new Date();
  var curFactura = new FLSqlCursor("facturascli");

  if (!this.iface.datosFactura(curFactura, codCliente, codContrato, idPeriodo)) {
    return false;
  }
  if (!curFactura.commitBuffer()) {
    return false;
  }

  var datosPeriodo = flfactppal.iface.pub_ejecutarQry("periodoscontratos", "codcontrato,fechainicio,fechafin,referencia,coste,codimpuesto", "id = " + idPeriodo);
  if (datosPeriodo.result != 1) {
    MessageBox.warning(util.translate("scripts", "Error al obtener los datos del período asociado al contrato %1").arg(codContrato), MessageBox.Ok, MessageBox.NoButton);
  }

  var idFactura = curFactura.valueBuffer("idfactura");
  if (!this.iface.curLineaFactura_) {
    this.iface.curLineaFactura_ = new FLSqlCursor("lineasfacturascli");
  }

  var qryActividades = new FLSqlQuery;
  qryActividades.setTablesList("fo_alumnosactividad");
  qryActividades.setSelect("aa.codactividad, aa.codalumno, aa.codtarifa, aa.codbecador, a.descripcion, al.nombre");
  qryActividades.setFrom("fo_alumnosactividad aa INNER JOIN fo_actividades a ON aa.codactividad = a.codactividad INNER JOIN fo_alumnos al ON aa.codalumno = al.codalumno");
  qryActividades.setWhere("aa.codcontrato = '" + codContrato + "'");
  qryActividades.setForwardOnly(true);
  if (!qryActividades.exec()) {
    return false;
  }
  var aActividades = new Array();
  var i = 0;
  while (qryActividades.next()) {
    aActividades[i] = [];
    aActividades[i]["codactividad"] = qryActividades.value("aa.codactividad");
    aActividades[i]["desactividad"] = qryActividades.value("a.descripcion");
    aActividades[i]["nombrealumno"] = qryActividades.value("al.nombre");
    aActividades[i]["codalumno"] = qryActividades.value("aa.codalumno");
    aActividades[i]["asistencia"] = this.iface.calcularDiasActividad(qryActividades.value("aa.codactividad"), qryActividades.value("aa.codalumno"), datosPeriodo.fechainicio, datosPeriodo.fechafin);
    aActividades[i]["codbecador"] = qryActividades.value("aa.codbecador");
    i++;
  }
  var aDatosLinea, referencia, codTarifa, nombreAlumno;
  var hayAlumnosEnfermos = false;
  var desLinea;
  for (i = 0; i < aActividades.length; i++) {
    aDatosLinea = [];
    if (aActividades[i]["asistencia"]["X"] > 0) {
      desLinea = this.iface.dameDesLineaContrato(aActividades[i], "X");
      aDatosLinea["dias"] = aActividades[i]["asistencia"]["X"];
      aDatosLinea["idfactura"] = idFactura;
      aDatosLinea["codactividad"] = aActividades[i]["codactividad"];
      aDatosLinea["tipoasistencia"] = "Asiste";
      referencia = util.sqlSelect("fo_actividades", "refasistenciacon", "codactividad = '" + aActividades[i]["codactividad"] + "'");
      if (!referencia || referencia == "") {
        MessageBox.information(util.translate("scripts", "No tiene definida la referencia Artículo asistencia para la actividad %1").arg(aActividades[i]["codactividad"]), MessageBox.Ok, MessageBox.NoButton);
        return false;
      }
      aDatosLinea["referencia"] = referencia;
      nombreAlumno = util.sqlSelect("fo_alumnos", "nombre", "codalumno = '" + aActividades[i]["codalumno"] + "'");
      aDatosLinea["descripcion"] = desLinea; //"Actividad " + aActividades[i]["codactividad"] + " para " + nombreAlumno + " con tipo de asistencia: " + aDatosLinea["tipoasistencia"];
      codTarifa = util.sqlSelect("fo_alumnosactividad", "codtarifa", "codcontrato = '" + codContrato + "' AND codalumno = '" + aActividades[i]["codalumno"] + "' AND codactividad = '" + aActividades[i]["codactividad"] + "'");
      debug("codcontrato = '" + codContrato + "' AND codalumno = '" + aActividades[i]["codalumno"] + "' AND codactividad = '" + aActividades[i]["codactividad"] + "'");
      if (!codTarifa || codTarifa == "") {
        MessageBox.information(util.translate("scripts", "No tiene definida la tarifa actividad %1 y el alumno %2 en el contrato %3").arg(aActividades[i]["codactividad"]).arg(aActividades[i]["codalumno"]).arg(codContrato), MessageBox.Ok, MessageBox.NoButton);
        return false;
      }
      var tipoTarifa = util.sqlSelect("tarifas", "tipo", "codtarifa = '" + codTarifa + "'");
      if (tipoTarifa == "Mensual") {
        aDatosLinea["dias"] = 1;
      }
      aDatosLinea["pvpunitario"] = util.sqlSelect("articulostarifas", "pvp", "referencia = '" + referencia + "' AND codtarifa = '" + codTarifa + "'");
      aDatosLinea["codalumno"] = aActividades[i]["codalumno"];
      aDatosLinea["codbecador"] = aActividades[i]["codbecador"];
      aDatosLinea["codtarifa"] = codTarifa;
      aDatosLinea["codcontrato"] = codContrato;
      if (!this.iface.crearLineaFacturaActividad(aDatosLinea)) {
        return false;
      }
    }
    if (aActividades[i]["asistencia"]["FC"] > 0) {
      desLinea = this.iface.dameDesLineaContrato(aActividades[i], "FC");
      aDatosLinea["dias"] = aActividades[i]["asistencia"]["FC"];
      aDatosLinea["idfactura"] = idFactura;
      aDatosLinea["codactividad"] = aActividades[i]["codactividad"];
      aDatosLinea["tipoasistencia"] = "Falta con preaviso";
      referencia = util.sqlSelect("fo_actividades", "refnoasisprecon", "codactividad = '" + aActividades[i]["codactividad"] + "'");
      if (!referencia || referencia == "") {
        MessageBox.information(util.translate("scripts", "No tiene definida la referencia Artículo no asistencia con preaviso para la actividad %1").arg(aActividades[i]["codactividad"]), MessageBox.Ok, MessageBox.NoButton);
        return false;
      }
      aDatosLinea["referencia"] = referencia;
      nombreAlumno = util.sqlSelect("fo_alumnos", "nombre", "codalumno = '" + aActividades[i]["codalumno"] + "'");
      aDatosLinea["descripcion"] = desLinea; //"Actividad " + aActividades[i]["codactividad"] + " para " + nombreAlumno + " con tipo de asistencia: " + aDatosLinea["tipoasistencia"];
      codTarifa = util.sqlSelect("fo_alumnosactividad", "codtarifa", "codcontrato = '" + codContrato + "' AND codalumno = '" + aActividades[i]["codalumno"] + "' AND codactividad = '" + aActividades[i]["codactividad"] + "'");
      debug("codcontrato = '" + codContrato + "' AND codalumno = '" + aActividades[i]["codalumno"] + "' AND codactividad = '" + aActividades[i]["codactividad"] + "'");
      if (!codTarifa || codTarifa == "") {
        MessageBox.information(util.translate("scripts", "No tiene definida la tarifa actividad %1 y el alumno %2 en el contrato %3").arg(aActividades[i]["codactividad"]).arg(aActividades[i]["codalumno"]).arg(codContrato), MessageBox.Ok, MessageBox.NoButton);
        return false;
      }
      aDatosLinea["pvpunitario"] = util.sqlSelect("articulostarifas", "pvp", "referencia = '" + aDatosLinea["referencia"] + "' AND codtarifa = '" + codTarifa + "'");
      aDatosLinea["codalumno"] = aActividades[i]["codalumno"];
      aDatosLinea["codbecador"] = aActividades[i]["codbecador"];
      aDatosLinea["codtarifa"] = codTarifa;
      aDatosLinea["codcontrato"] = codContrato;
      if (!this.iface.crearLineaFacturaActividad(aDatosLinea)) {
        return false;
      }
    }
    if (aActividades[i]["asistencia"]["FS"] > 0) {
      desLinea = this.iface.dameDesLineaContrato(aActividades[i], "FS");
      aDatosLinea["dias"] = aActividades[i]["asistencia"]["FS"];
      aDatosLinea["idfactura"] = idFactura;
      aDatosLinea["codactividad"] = aActividades[i]["codactividad"];
      aDatosLinea["tipoasistencia"] = "Falta sin preaviso";
      referencia = util.sqlSelect("fo_actividades", "refnoasiscon", "codactividad = '" + aActividades[i]["codactividad"] + "'");
      if (!referencia || referencia == "") {
        MessageBox.information(util.translate("scripts", "No tiene definida la referencia Artículo no asistencia sin preaviso para la actividad %1").arg(aActividades[i]["codactividad"]), MessageBox.Ok, MessageBox.NoButton);
        return false;
      }
      aDatosLinea["referencia"] = referencia;
      nombreAlumno = util.sqlSelect("fo_alumnos", "nombre", "codalumno = '" + aActividades[i]["codalumno"] + "'");
      aDatosLinea["descripcion"] = desLinea; //"Actividad " + aActividades[i]["codactividad"] + " para " + nombreAlumno + " con tipo de asistencia: " + aDatosLinea["tipoasistencia"];
      codTarifa = util.sqlSelect("fo_alumnosactividad", "codtarifa", "codcontrato = '" + codContrato + "' AND codalumno = '" + aActividades[i]["codalumno"] + "' AND codactividad = '" + aActividades[i]["codactividad"] + "'");
      if (!codTarifa || codTarifa == "") {
        MessageBox.information(util.translate("scripts", "No tiene definida la tarifa actividad %1 y el alumno %2 en el contrato %3").arg(aActividades[i]["codactividad"]).arg(aActividades[i]["codalumno"]).arg(codContrato), MessageBox.Ok, MessageBox.NoButton);
        return false;
      }
      aDatosLinea["pvpunitario"] = util.sqlSelect("articulostarifas", "pvp", "referencia = '" + aDatosLinea["referencia"] + "' AND codtarifa = '" + codTarifa + "'");
      aDatosLinea["codalumno"] = aActividades[i]["codalumno"];
      aDatosLinea["codbecador"] = aActividades[i]["codbecador"];
      aDatosLinea["codtarifa"] = codTarifa;
      aDatosLinea["codcontrato"] = codContrato;
      if (!this.iface.crearLineaFacturaActividad(aDatosLinea)) {
        return false;
      }
    }
    if (aActividades[i]["asistencia"]["O"] > 0) {
      hayAlumnosEnfermos = true;
    }
  }

  var curAA = new FLSqlCursor("articuloscontratos");
  curAA.select("codcontrato = '" + codContrato + "'");
  var periodoDesde: Number;
  var periodoHasta: Number;
  while (curAA.next()) {
    aDatosLinea["dias"] = 1;
    aDatosLinea["idfactura"] = idFactura;
    aDatosLinea["descripcion"] = curAA.valueBuffer("descripcion");
    aDatosLinea["referencia"] = curAA.valueBuffer("referencia");
    aDatosLinea["pvpunitario"] = curAA.valueBuffer("coste");
    aDatosLinea["codalumno"] = " ";
    aDatosLinea["codactividad"] = " ";
    aDatosLinea["codbecador"] = " ";
    aDatosLinea["codtarifa"] = " ";
    aDatosLinea["codcontrato"] = codContrato;
    if (!this.iface.crearLineaFacturaActividad(aDatosLinea)) {
      return false;
    }
  }
  /// No se generan facturas sin líneas
  if (!util.sqlSelect("lineasfacturascli", "idlinea", "idfactura = " + idFactura)) {
    if (!util.sqlDelete("facturascli", "idfactura = " + idFactura)) {
      return false;
    }
    /// Así no se incluye la factura en el listado de contratos facturados
    return false;
  }

  curFactura.select("idfactura = " + idFactura);

  if (!curFactura.first()) {
    return false;
  }
  curFactura.setModeAccess(curFactura.Edit);
  curFactura.refreshBuffer();

  this.iface.totalesFactura(curFactura);

  if (!curFactura.commitBuffer()) {
    return false;
  }

  if (hayAlumnosEnfermos) {
    MessageBox.information(util.translate("scripts", "Hay alumnos enfermos durante el periodo de facturación.\nSe debe revisar la factura %1").arg(curFactura.valueBuffer("codigo")), MessageBox.Ok, MessageBox.NoButton);
  }

  this.iface.actualizarPeriodo(idPeriodo, idFactura);
  this.iface.actualizarContrato(idPeriodo);
  return true;
}

function extraescolar_crearLineaFacturaActividad(aDatosLinea)
{
  debug(aDatosLinea["descripcion"] + " "  + aDatosLinea["dias"]);
  var util = new FLUtil;
  var _i = this.iface;
  var ivaIncluido = util.sqlSelect("articulos", "ivaincluido", "referencia = '" + aDatosLinea["referencia"] + "'");

  _i.curLineaFactura_.setModeAccess(_i.curLineaFactura_.Insert);
  _i.curLineaFactura_.refreshBuffer();
  _i.curLineaFactura_.setValueBuffer("idfactura", aDatosLinea["idfactura"]);
  _i.curLineaFactura_.setValueBuffer("referencia", aDatosLinea["referencia"]);
  _i.curLineaFactura_.setValueBuffer("descripcion", aDatosLinea["descripcion"]);
  _i.curLineaFactura_.setValueBuffer("codimpuesto", formRecordlineaspedidoscli.iface.pub_commonCalculateField("codimpuesto", _i.curLineaFactura_));
  _i.curLineaFactura_.setValueBuffer("iva", formRecordlineaspedidoscli.iface.pub_commonCalculateField("iva", _i.curLineaFactura_));
  _i.curLineaFactura_.setValueBuffer("recargo", formRecordlineaspedidoscli.iface.pub_commonCalculateField("recargo", _i.curLineaFactura_));
  _i.curLineaFactura_.setValueBuffer("cantidad", aDatosLinea["dias"]);
  _i.curLineaFactura_.setValueBuffer("dtolineal", 0);
  _i.curLineaFactura_.setValueBuffer("dtopor", 0);
  if (ivaIncluido) {
    _i.curLineaFactura_.setValueBuffer("ivaincluido", true);
    _i.curLineaFactura_.setValueBuffer("pvpunitarioiva", aDatosLinea["pvpunitario"]);
    _i.curLineaFactura_.setValueBuffer("pvpunitario", formRecordlineaspedidoscli.iface.pub_commonCalculateField("pvpunitario2", _i.curLineaFactura_));
    _i.curLineaFactura_.setValueBuffer("pvpsindtoiva", formRecordlineaspedidoscli.iface.pub_commonCalculateField("pvpsindtoiva2", _i.curLineaFactura_));
    _i.curLineaFactura_.setValueBuffer("pvpsindto", formRecordlineaspedidoscli.iface.pub_commonCalculateField("pvpsindto2", _i.curLineaFactura_));
    _i.curLineaFactura_.setValueBuffer("pvptotaliva", formRecordlineaspedidoscli.iface.pub_commonCalculateField("pvptotaliva2", _i.curLineaFactura_));
    _i.curLineaFactura_.setValueBuffer("pvptotal", formRecordlineaspedidoscli.iface.pub_commonCalculateField("pvptotal2", _i.curLineaFactura_));
  } else {
    _i.curLineaFactura_.setValueBuffer("pvpunitario", aDatosLinea["pvpunitario"]);
    _i.curLineaFactura_.setValueBuffer("pvpunitarioiva", formRecordlineaspedidoscli.iface.pub_commonCalculateField("pvpunitarioiva2", _i.curLineaFactura_));
    _i.curLineaFactura_.setValueBuffer("pvpsindto", formRecordlineaspedidoscli.iface.pub_commonCalculateField("pvpsindto", _i.curLineaFactura_));
    _i.curLineaFactura_.setValueBuffer("pvpsindtoiva", formRecordlineaspedidoscli.iface.pub_commonCalculateField("pvpsindtoiva", _i.curLineaFactura_));
    _i.curLineaFactura_.setValueBuffer("pvptotal", formRecordlineaspedidoscli.iface.pub_commonCalculateField("pvptotal", _i.curLineaFactura_));
    _i.curLineaFactura_.setValueBuffer("pvptotaliva", formRecordlineaspedidoscli.iface.pub_commonCalculateField("pvptotaliva", _i.curLineaFactura_));
  }

  _i.curLineaFactura_.setValueBuffer("codalumno", aDatosLinea["codalumno"]);
  _i.curLineaFactura_.setValueBuffer("codactividad", aDatosLinea["codactividad"]);
  _i.curLineaFactura_.setValueBuffer("codbecador", aDatosLinea["codbecador"]);
  _i.curLineaFactura_.setValueBuffer("codtarifa", aDatosLinea["codtarifa"]);

  if (!_i.datosLineaFacturaActividad(aDatosLinea)) {
    return fales;
  }

  if (!_i.curLineaFactura_.commitBuffer()) {
    return false;
  }
  return true;
}

function extraescolar_datosLineaFacturaActividad(aDatosLinea)
{
  return true;
}

/** \D
Función que me devuelve un array con el número de veces que asiste en cada modalidad (X, FC, FS) el alumno en la actividad para el intervalo de fechas del contrato

@param codActividad Código de la actividad
@param codAlumno Código del alumno que asiste
@param fInicio Fecha inicio del intervalo
@param fFin Fecha fin del intervalo
\end */
function extraescolar_calcularDiasActividad(codActividad, codAlumno, fInicio, fFin)
{
  var util = new FLUtil();
  var aDias = new Array();
  aDias["X"] = util.sqlSelect("fo_asistenciaact", "COUNT(*)", "codactividad = '" + codActividad + "' AND codalumno = '" + codAlumno + "' AND fecha BETWEEN '" + fInicio + "' AND '" + fFin + "' AND asistencia = 'X'");
  aDias["X"] = isNaN(aDias["X"]) ? 0 : aDias["X"];

  aDias["FC"] = util.sqlSelect("fo_asistenciaact", "COUNT(*)", "codactividad = '" + codActividad + "' AND codalumno = '" + codAlumno + "' AND fecha BETWEEN '" + fInicio + "' AND '" + fFin + "' AND asistencia = 'FC'");
  aDias["FC"] = isNaN(aDias["FC"]) ? 0 : aDias["FC"];

  aDias["FS"] = util.sqlSelect("fo_asistenciaact", "COUNT(*)", "codactividad = '" + codActividad + "' AND codalumno = '" + codAlumno + "' AND fecha BETWEEN '" + fInicio + "' AND '" + fFin + "' AND asistencia = 'FS'");
  aDias["FS"] = isNaN(aDias["FS"]) ? 0 : aDias["FS"];

  aDias["O"] = util.sqlSelect("fo_asistenciaact", "COUNT(*)", "codactividad = '" + codActividad + "' AND codalumno = '" + codAlumno + "' AND fecha BETWEEN '" + fInicio + "' AND '" + fFin + "' AND asistencia = 'O'");
  aDias["O"] = isNaN(aDias["O"]) ? 0 : aDias["O"];
  return aDias;
}

function extraescolar_dameMasWhereFacturaBecador(idPeriodo, codCliente, codContrato)
{
  return true;
}

function extraescolar_generarFacturaBecador(idPeriodo, codCliente, codContrato, coste)
{
  var util = new FLUtil();
  var _i = this.iface;
  var curFactura = new FLSqlCursor("facturascli");

  if (!_i.datosFactura(curFactura, codCliente, codContrato, idPeriodo)) {
    return false;
  }
  if (!curFactura.commitBuffer()) {
    return false;
  }

  var idFactura = curFactura.valueBuffer("idfactura");
  if (!_i.curLineaFactura_) {
    _i.curLineaFactura_ = new FLSqlCursor("lineasfacturascli");
  }

  var aDatosLinea, pvpUnitario;
  var datosPeriodo = flfactppal.iface.pub_ejecutarQry("periodoscontratos", "codcontrato,fechainicio,fechafin,referencia,coste,codimpuesto", "id = " + idPeriodo);
  if (datosPeriodo.result != 1) {
    MessageBox.warning(util.translate("scripts", "Error al obtener los datos del período asociado al contrato %1").arg(codContrato), MessageBox.Ok, MessageBox.NoButton);
  }
  var masWhere = _i.dameMasWhereFacturaBecador(idPeriodo, codCliente, codContrato);
  var qryLineas = new FLSqlQuery;
  qryLineas.setTablesList("lineasfacturascli,facturascli,periodoscontratos,contratos");
  qryLineas.setSelect("lf.referencia, lf.descripcion, lf.cantidad, lf.codactividad, lf.codalumno, lf.codbecador, lf.codtarifa");
  qryLineas.setFrom("lineasfacturascli lf inner join facturascli f ON lf.idfactura = f.idfactura inner join periodoscontratos pc on pc.idfactura = f.idfactura inner join contratos c on pc.codcontrato = c.codigo");
  qryLineas.setWhere("lf.codbecador = '" + codCliente + "' AND f.fecha BETWEEN '" + datosPeriodo.fechainicio + "' AND '" + datosPeriodo.fechafin + "' AND c.estado = 'Vigente'");
  qryLineas.setForwardOnly(true);
  if (!qryLineas.exec()) {
    return false;
  }
  while (qryLineas.next()) {
    aDatosLinea = [];
    aDatosLinea["dias"] = qryLineas.value("lf.cantidad");
    aDatosLinea["idfactura"] = idFactura;
    aDatosLinea["codactividad"] = qryLineas.value("lf.codactividad");
    aDatosLinea["referencia"] = qryLineas.value("lf.referencia");
    aDatosLinea["descripcion"] = qryLineas.value("lf.descripcion");
    aDatosLinea["codalumno"] = qryLineas.value("lf.codalumno");
    aDatosLinea["codbecador"] = qryLineas.value("lf.codbecador");
    aDatosLinea["codtarifa"] = qryLineas.value("lf.codtarifa");
    pvpUnitario = util.sqlSelect("articulostarifas", "pvpconsell", "referencia = '" + aDatosLinea["referencia"] + "' AND codtarifa = '" + aDatosLinea["codtarifa"] + "'");
    aDatosLinea["pvpunitario"] = (isNaN(pvpUnitario) || !pvpUnitario ? 0 : pvpUnitario);
    aDatosLinea["codcontrato"] = codContrato;
    if (!_i.crearLineaFacturaActividad(aDatosLinea)) {
      return false;
    }
  }
  if (!_i.lineasAdicionalesBecador(codContrato, idFactura)) {
    return false;
  }

  curFactura.select("idfactura = " + idFactura);

  if (!curFactura.first()) {
    return false;
  }
  curFactura.setModeAccess(curFactura.Edit);
  curFactura.refreshBuffer();

  _i.totalesFactura(curFactura);

  if (!curFactura.commitBuffer()) {
    return false;
  }

  _i.actualizarPeriodo(idPeriodo, idFactura);
  _i.actualizarContrato(idPeriodo);
  return true;
}

function extraescolar_lineasAdicionalesBecador(codContrato, idFactura)
{
  var util = new FLUtil;
  var qryArt = new FLSqlQuery;
  qryArt.setTablesList("articuloscontratos,articulos");
  qryArt.setSelect("ac.referencia, ac.coste, ac.codimpuesto, a.descripcion");
  qryArt.setFrom("articuloscontratos ac INNER JOIN articulos a ON ac.referencia = a.referencia");
  qryArt.setWhere("ac.codcontrato = '" + codContrato + "'");
  qryArt.setForwardOnly(true);

  var qryLineas = new FLSqlQuery;
  qryLineas.setTablesList("lineasfacturascli");
  qryLineas.setSelect("codtarifa, SUM(cantidad)");
  qryLineas.setFrom("lineasfacturascli");
  qryLineas.setWhere("idfactura = " + idFactura + " GROUP BY codtarifa");
  qryLineas.setForwardOnly(true);
  if (!qryLineas.exec()) {
    return false;
  }
  var cantidad, codTarifa, referencia;
  var aDatosLinea;
  while (qryLineas.next()) {
    cantidad = qryLineas.value("SUM(cantidad)");
    codTarifa = qryLineas.value("codtarifa");
    if (!qryArt.exec()) {
      return false;
    }
    while (qryArt.next()) {
      referencia = qryArt.value("ac.referencia");
      aDatosLinea = [];
      aDatosLinea["dias"] = cantidad;
      aDatosLinea["idfactura"] = idFactura;
      aDatosLinea["codactividad"] = "";
      aDatosLinea["referencia"] = referencia;
      aDatosLinea["descripcion"] = qryArt.value("a.descripcion");
      aDatosLinea["codalumno"] = "";
      aDatosLinea["codbecador"] = "";
      aDatosLinea["codtarifa"] = codTarifa;
      pvpUnitario = util.sqlSelect("articulostarifas", "pvpconsell", "referencia = '" + referencia + "' AND codtarifa = '" + codTarifa + "'");
      aDatosLinea["pvpunitario"] = (isNaN(pvpUnitario) || !pvpUnitario ? 0 : pvpUnitario);
      if (!this.iface.crearLineaFacturaActividad(aDatosLinea)) {
        return false;
      }
    }
  }
  return true;
}

function extraescolar_dameFiltroContratosAFacturar()
{
  var _i = this.iface;
  var util = new FLUtil();
  var cursor = this.cursor();

  var filtro = this.iface.__dameFiltroContratosAFacturar();
  var codCentro;
  if (_i.codCentroEsc_) {
    codCentro = _i.codCentroEsc_;
  } else {
    var f = new FLFormSearchDB("seleccioncentrocon");
    var curSel = f.cursor();
    curSel.select();
    if (curSel.first()) {
      curSel.setModeAccess(curSel.Edit);
    } else {
      curSel.setModeAccess(curSel.Insert);
    }
    curSel.refreshBuffer();
    curSel.setValueBuffer("codcentro", "");

    f.setMainWidget();
    var id = f.exec("id");
    if (!id) {
      return;
    }
    codCentro = curSel.valueBuffer("codcentro");
  }

  var filtroCC = "";
  if (codCentro && codCentro != "") {
    filtroCC = "codcentroesc = '" + codCentro + "'";
    filtro += ((filtro && filtro != "") ? " AND " : "") + filtroCC;
  }
  return filtro;
}

function extraescolar_init()
{
  var _i = this.iface;
  _i.__init();

  _i.bloqueoG_ = false;
  _i.establecerCentro();
  _i.filtrarGrupos();
  _i.filtrarAlumnos();

  var gCols = ["codigo", "codcurso", "codnivel"];
  this.child("tdbGrupos").setOrderCols(gCols);

  connect(this.child("tdbGrupos"), "primaryKeyToggled(QVariant, bool)", this, "iface.tdbGrupos_primaryKeyToggled");
  connect(this.child("tdbAlumnos"), "primaryKeyToggled(QVariant, bool)", this, "iface.filtrarTabla");
  connect(this.child("chkTodosGrupos"), "toggled(bool)", this, "iface.chkTodosGrupos_clicked");
}

function extraescolar_establecerCentro()
{
  var util = new FLUtil;
  var _i = this.iface;
  _i.codCentroEsc_ = util.sqlSelect("usuarios", "codcentroesc", "idusuario = '" + sys.nameUser() + "'");
  if (_i.codCentroEsc_ == "") {
    _i.codCentroEsc_ = false;
  }
}

function extraescolar_filtrarGrupos()
{
  var _i = this.iface;
  var filtroG = "";
  if (_i.codCentroEsc_) {
    filtroG += filtroG != "" ? " AND " : "";
    filtroG += "codcentro = '" + _i.codCentroEsc_ + "'";
  }
  this.child("tdbGrupos").setFilter(filtroG);
  this.child("tdbGrupos").refresh();
}

function extraescolar_tdbGrupos_primaryKeyToggled(pK, on)
{
  var _i = this.iface;
  if (_i.bloqueoG_) {
    return;
  }
  _i.filtrarAlumnos();
}

function extraescolar_filtrarAlumnos()
{
  var _i = this.iface;

  var filtroAlumnos = "";
  if (_i.codCentroEsc_) {
    filtroAlumnos += filtroAlumnos != "" ? " AND " : "";
    filtroAlumnos += "codcentro = '" + _i.codCentroEsc_ + "'";
  }

  var aPk = this.child("tdbGrupos").primarysKeysChecked();
  if (aPk && aPk.length > 0) {
    var filtroGrupo = aPk.length > 1 ? "IN (" + aPk.join(",") + ")" : " = " + aPk[0]
                      filtroAlumnos += filtroAlumnos != "" ? " AND " : "";
    filtroAlumnos += "codalumno IN (SELECT codalumno FROM fo_alumnosgrupocurso WHERE idgrupo " + filtroGrupo + ")";
  }
  this.child("tdbAlumnos").setFilter(filtroAlumnos);
  this.child("tdbAlumnos").refresh();
  this.iface.filtrarTabla();
}

function extraescolar_filtroTabla()
{
  var _i = this.iface;
  var filtro = _i.__filtroTabla();
  if (_i.codCentroEsc_) {
    filtro += filtro != "" ? " AND " : "";
    filtro += "codcentroesc = '" + _i.codCentroEsc_ + "'";
  }

  var filtroAlumnos = "";
  var aPk = this.child("tdbAlumnos").primarysKeysChecked();
  if (aPk && aPk.length > 0) {
    var filtroAlumno = aPk.length > 1 ? "IN ('" + aPk.join("', '") + "')" : " = '" + aPk[0] + "'";
    filtroAlumnos = "codcliente IN (SELECT codcliente FROM fo_alumnos WHERE codalumno " + filtroAlumno + ")";
    filtro += filtro != "" ? " AND " : "";
    filtro += filtroAlumnos;
  }

  var filtroGrupos = "";
  var aPk = this.child("tdbGrupos").primarysKeysChecked();
  if (aPk && aPk.length > 0) {
    var filtroGrupos = aPk.length > 1 ? "IN (" + aPk.join(", ") + ")" : " = " + aPk[0];
    filtroGrupos = "codcliente IN (SELECT codcliente FROM fo_alumnos a INNER JOIN fo_alumnosgrupocurso g ON a.codalumno = g.codalumno WHERE g.idgrupo " + filtroGrupos + ")";
    filtro += filtro != "" ? " AND " : "";
    filtro += filtroGrupos;
  }
  debug("Filtro = " + filtro);
  return filtro;
}

function extraescolar_dameDesLineaContrato(aActividad, tipoAsistencia)
{
  var util = new FLUtil;
  var asistencia = "";
  switch (tipoAsistencia) {
    case "X": {
      asistencia = util.translate("scripts", "assistencia");
      break;
    }
    case "FC": {
      asistencia = util.translate("scripts", "falta amb preavis");
      break;
    }
    case "FS": {
      asistencia = util.translate("scripts", "falta sense avis");
      break;
    }
  }
  var desLinea = asistencia != ""
                 ? util.translate("scripts", "%1 per %2 amb %3").arg(aActividad["desactividad"]).arg(aActividad["nombrealumno"]).arg(asistencia)
                 : util.translate("scripts", "%1 per %2").arg(aActividad["desactividad"]).arg(aActividad["nombrealumno"]);

  return desLinea;
}

function extraescolar_chkTodosGrupos_clicked(on)
{
  var _i = this.iface;

  _i.bloqueoG_ = true;
  if (on) {
    var filtro = this.child("tdbGrupos").filter();

    var qryGrupos = new FLSqlQuery();
    qryGrupos.setTablesList("fo_gruposcurso");
    qryGrupos.setSelect("idgrupo");
    qryGrupos.setFrom("fo_gruposcurso");
    qryGrupos.setWhere(filtro);
    qryGrupos.setForwardOnly(true);
    if (!qryGrupos.exec()) {
      return false;
    }
    while (qryGrupos.next()) {
      this.child("tdbGrupos").setPrimaryKeyChecked(qryGrupos.value("idgrupo"), true);
    }
  } else {
    this.child("tdbGrupos").clearChecked();
  }
  _i.bloqueoG_ = false;
  this.child("tdbGrupos").refresh();
  _i.filtrarAlumnos();
}

function extraescolar_datosFactura(curFactura, codCliente, codContrato, idPeriodo)
{
  var util = new FLUtil();
  var _i = this.iface;
  if (!_i.__datosFactura(curFactura, codCliente, codContrato, idPeriodo)) {
    return false;
  }
  var codCentroEsc = util.sqlSelect("contratos", "codcentroesc", "codigo = '" + codContrato + "'");
  if (codCentroEsc) {
    curFactura.setValueBuffer("codcentroesc", codCentroEsc);
  }
  return true;
}
//// EXTRAESCOLAR //////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
