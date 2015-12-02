
/** @class_declaration bMultiempresa */
/////////////////////////////////////////////////////////////////
//// FUN_BMULTIEMPRESA //////////////////////////////////////////////////
class bMultiempresa extends oficial
{
  function bMultiempresa(context)
  {
    oficial(context);
  }
  function lanzar()
  {
    return this.ctx.bMultiempresa_lanzar();
  }
  function datosInforme(nombrebd: String, codEjercicio: String, fechaDesde: String, fechaHasta: String, subcuentaDesde: String, subcuentaHasta: String)
  {
    return this.ctx.bMultiempresa_datosInforme(nombrebd, codEjercicio, fechaDesde, fechaHasta, subcuentaDesde, subcuentaHasta);
  }
  function calcularValorPyG(ej: String, desde: String, hasta: String, nombrebd: String)
  {
    return this.ctx.bMultiempresa_calcularValorPyG(ej, desde, hasta, nombrebd);
  }
  function informarTablaSit()
  {
    return this.ctx.bMultiempresa_informarTablaSit();
  }
}
//// FUN_BMULTIEMPRESA //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition bMultiempresa */
/////////////////////////////////////////////////////////////////
//// FUN_BMULTIEMPRESA //////////////////////////////////////////////////

/** \D
Se recaban datos para el balance de varias empresas, se introducen en la tabla buffer y se lanza el informe sobre la nueva tabla
\end */
function bMultiempresa_lanzar()
{
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor()
                            if (!cursor.isValid())
                              return;
  this.iface.idInforme = cursor.valueBuffer("id");
  if (!this.iface.idInforme)
    return;

  // Si es consolidado con la empresa actual, lanzamos el informe normal
  if (cursor.valueBuffer("ejercicioanterior"))
    return this.iface.__lanzar();

  this.iface.nombreInforme = cursor.action();
  flcontinfo.iface.pub_establecerInformeActual(this.iface.idInforme, this.iface.nombreInforme);
  this.iface.nombreInforme += "_u";

  // Vaciar el buffer
  flcontinfo.iface.pub_vaciarBuffer("co_i_balancesit_buffer");

  // Recabar datos de esta empresa
  this.iface.datosInforme(sys.nameBD(), cursor.valueBuffer("i_co__subcuentas_codejercicioact"), cursor.valueBuffer("d_co__asientos_fechaact"), cursor.valueBuffer("h_co__asientos_fechaact"));
  this.iface.informarTablaSit();

  // Recabar datos del resto de empresas
  var curTab: FLSqlCursor = new FLSqlCursor("co_ejerciciosempresas_sit");
  curTab.select("idbalance = " + cursor.valueBuffer("id"));
  while (curTab.next()) {
    this.iface.datosInforme(curTab.valueBuffer("nombrebd"), curTab.valueBuffer("codejercicio"), curTab.valueBuffer("fechadesde"), curTab.valueBuffer("fechahasta"));
    this.iface.informarTablaSit();
  }

  var q: FLSqlQuery = new FLSqlQuery(cursor.action());
  var util: FLUtil = new FLUtil();

  q.setWhere("(cbl.naturaleza = 'ACTIVO' OR cbl.naturaleza = 'PASIVO') AND buf.sumaact != 0 AND c.codejercicio = '" + this.iface.ejAct + "' GROUP BY buf.sumaact, buf.sumaant, empresa.nombre, cbl.naturaleza, cbl.descripcion1, cbl.descripcion2, cbl.descripcion3, cbl.nivel1, cbl.nivel2, c.descripcion, c.codcuenta");
  q.setOrderBy("cbl.naturaleza, cbl.descripcion1, cbl.descripcion2, cbl.descripcion3, c.codcuenta");

  if (!q.exec()) {
    MessageBox.critical(util.translate("scripts", "Falló la 2ª consulta"),
                        MessageBox.Ok, MessageBox.NoButton,
                        MessageBox.NoButton);
    return;
  } else {
    if (!q.first()) {
      MessageBox.warning(util.translate("scripts", "No hay registros que cumplan los criterios de búsqueda establecidos"),
                         MessageBox.Ok, MessageBox.NoButton,
                         MessageBox.NoButton);
      return;
    }
  }

  var rptViewer: FLReportViewer = new FLReportViewer();
  rptViewer.setReportTemplate("co_i_balancesit_multi");
  rptViewer.setReportData(q);
  rptViewer.renderReport();
  rptViewer.exec();
}


/** \D
Se recaban datos para el balance de varias empresas, se introducen en la tabla buffer
y se lanza el informe sobre la nueva tabla
\end */
function bMultiempresa_datosInforme(nombrebd: String, codEjercicio: String, desdeAct: String, hastaAct: String)
{
  var cursor: FLSqlCursor = this.cursor();
  var util: FLUtil = new FLUtil();

  var asientoCierreAct: Number = -1;
  var asientoPygAct: Number = -1;
  var asientoApeAct: Number = -1;

  this.iface.ejAct = codEjercicio;

  // Conectamos
  var q: FLSqlQuery;
  var curRem: FLSqlCursor;
  var conexion: String;
  if (nombrebd != sys.nameBD()) {
    conexion = nombrebd + "_conn";
    if (!flcontinfo.iface.pub_conectar(nombrebd))
      return;
    q = new FLSqlQuery("", conexion);
    curRem = new FLSqlCursor("ejercicios", conexion);
  } else {
    conexion = "default";
    q = new FLSqlQuery();
  }

  // No tendremos en cuenta los asientos de cierre en el balance
  if (cursor.valueBuffer("ignorarcierre")) {
    curRem.select("codejercicio = '" + this.iface.ejAct + "'");
    if (curRem.first()) {
      asientoPygAct = curRem.valueBuffer("idasientopyg");
      asientoCierreAct = curRem.valueBuffer("idasientocierre");
      asientoApeAct = curRem.valueBuffer("idasientoapertura");
    }
  }

  flcontinfo.iface.pub_establecerEjerciciosPYG(this.iface.ejAct, false, false);

  /** \D
  La consulta es compleja y se ejecuta sobre varias tablas. Las líneas obtenidas son aquellas pertenecientes a las partidas cuya subcuenta está asociada a un código de balance (a través de la cuenta) de naturaleza ACTIVO o PASIVO. La consulta extrae la suma del saldo de las subcuentas agrupadas por cuenta. Se extrae además el ejercicio, que se utilzará en caso de comparar o consolidar dos ejercicios.
  \end */
  q.setTablesList("co_cuentas,co_codbalances,co_subcuentas,co_asientos,co_partidas");

  q.setFrom("co_codbalances INNER JOIN co_cuentas ON co_cuentas.codbalance = co_codbalances.codbalance INNER JOIN co_subcuentas ON co_subcuentas.idcuenta = co_cuentas.idcuenta  INNER JOIN co_partidas ON co_subcuentas.idsubcuenta = co_partidas.idsubcuenta INNER JOIN co_asientos ON co_partidas.idasiento = co_asientos.idasiento");

  q.setSelect("co_cuentas.codcuenta, co_asientos.codejercicio, SUM(co_partidas.debe-co_partidas.haber), co_codbalances.naturaleza");

  q.setWhere("(co_codbalances.naturaleza = 'ACTIVO' OR co_codbalances.naturaleza = 'PASIVO')"
             + " AND ( ((co_asientos.codejercicio = '" + this.iface.ejAct + "') " +
             " AND (co_asientos.idasiento <> '" + asientoCierreAct + "')" +
             " AND (co_asientos.idasiento <> '" + asientoPygAct + "')" +
             " AND (co_asientos.idasiento <> '" + asientoApeAct + "')" +
             " AND (co_asientos.fecha >= '" + desdeAct + "')" +
             " AND (co_asientos.fecha <= '" + hastaAct + "')) )" +
             " GROUP BY co_cuentas.codcuenta, co_asientos.codejercicio, co_codbalances.naturaleza, co_codbalances.nivel1, co_codbalances.nivel2, co_codbalances.nivel3 ORDER BY co_codbalances.naturaleza, co_codbalances.nivel1, co_codbalances.nivel2, co_codbalances.nivel3, co_cuentas.codcuenta");

  var util: FLUtil = new FLUtil();
  if (!q.exec()) {
    MessageBox.critical(util.translate("scripts", "Falló la 1ª consulta"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return false;
  }

  /** \D
  Los datos procedentes de la consulta se almacenan temporalmente en el array Datos
  \end */
  var registro: Number = 0;
  var encontrados: Boolean = false;
  this.iface.datos = [];

  while (q.next()) {

    encontrados = true;

    this.iface.datos[registro] = new Array(4);

    this.iface.datos[registro]["codcuenta"] = q.value(0);
    this.iface.datos[registro]["codejercicio"] = q.value(1);
    this.iface.datos[registro]["suma"] = q.value(2);
    this.iface.datos[registro]["nombrebd"] = nombrebd;

    if (q.value(3) == "PASIVO")
      this.iface.datos[registro]["suma"] = 0 - q.value(2);

    registro++;

  }

  if (!encontrados) {
    MessageBox.warning(util.translate("scripts", "No hay registros que cumplan los criterios de búsqueda establecidos"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return false;
  }

  /** \D
  Para cada ejercicio se calcula el valor de pérdidas y ganancias, que irá a la cuenta de pérdidas y ganancias del informe (cuenta 129)
  \end */
  this.iface.calcularValorPyG(this.iface.ejAct, desdeAct, hastaAct, nombrebd);

  return true;
}


/** \D
Calcula el valor del saldo de la cuenta de pérdidas y ganancias, necesario para cuadrar el balance de situación. Hace un llamada a la función flcontinfo.resultadosEjercicio y calcula el saldo como la diferencia entre las pérdidas totales y ganancias totales

@param ej Ejercicio sobre el que se calcula el valor de pérdidas y ganancias
@param desde Fecha inicial del intervalo de cálculo dentro del ejercicio
@param hasta Fecha final del intervalo de cálculo dentro del ejercicio
@return Valor del saldo de la cuenta de pérdidas y ganancias
\end */
function bMultiempresa_calcularValorPyG(ej: String, desde: String, hasta: String, nombrebd: String)
{
  var cursor: FLSqlCursor = this.cursor();
  var valorPyG: Number = 0;
  var AB: Array = [];

  var conexion: String = "";
  if (nombrebd != sys.nameBD())
    conexion = nombrebd + "_conn";
  else
    conexion = "default";

  if (flcontinfo.iface.resultadosEjercicio(AB, ej, desde, hasta, cursor.valueBuffer("ignorarcierre"), conexion)) {
    var AVI = AB["AVI"];
    var BVI = AB["BVI"];

    if (AVI > BVI)
      valorPyG = AVI
                 else
                   valorPyG = 0 - BVI;

  }

  var registro: Number = this.iface.datos.length;
  this.iface.datos[registro] = new Array(3);
  this.iface.datos[registro]["codcuenta"] = 129;
  this.iface.datos[registro]["suma"] = valorPyG;
  this.iface.datos[registro]["codejercicio"] = ej;
  this.iface.datos[registro]["nombrebd"] = nombrebd;
}

function bMultiempresa_informarTablaSit()
{
  var cursor: FLSqlCursor = new FLSqlCursor("co_i_balancesit_buffer");
  var suma: Number;

  for (var i: Number = 0; i < this.iface.datos.length; i++) {

    cursor.select("codcuenta = '" + this.iface.datos[i]["codcuenta"] + "'");
    if (cursor.first()) {
      cursor.setModeAccess(cursor.Edit);
      cursor.refreshBuffer();
    } else {
      cursor.setModeAccess(cursor.Insert);
      cursor.refreshBuffer();
      cursor.setValueBuffer("codcuenta", this.iface.datos[i]["codcuenta"]);
    }

    suma = parseFloat(cursor.valueBuffer("sumaact")) + parseFloat(this.iface.datos[i]["suma"]);
    cursor.setValueBuffer("sumaact", suma);

    cursor.commitBuffer();
  }

}


//// FUN_BMULTIEMPRESA /////////////////////////////////////////////////
////////////////////////////////////////////////////////////////
