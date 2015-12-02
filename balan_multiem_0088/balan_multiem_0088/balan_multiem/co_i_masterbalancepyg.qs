
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
  function crearPyG(nombrebd: String, codEjercicio: String, fechaDesde: String, fechaHasta: String): Boolean {
    return this.ctx.bMultiempresa_crearPyG(nombrebd, codEjercicio, fechaDesde, fechaHasta);
  }
  function rellenarDatosPyG(ej: String, nombrebd: String)
  {
    return this.ctx.bMultiempresa_rellenarDatosPyG(ej, nombrebd);
  }
  function informarTablaPyG()
  {
    return this.ctx.bMultiempresa_informarTablaPyG();
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

  // Si es consolidado con la empresa actual, lanzamos el informe normal
  if (cursor.valueBuffer("ejercicioanterior"))
    return this.iface.__lanzar();

  this.iface.idInforme = cursor.valueBuffer("id");
  if (!this.iface.idInforme)
    return;

  this.iface.nombreInforme = cursor.action();

  flcontinfo.iface.pub_establecerInformeActual(this.iface.idInforme, this.iface.nombreInforme);

  this.iface.AB = [];

  this.iface.mostrarEjAnt = false;
  this.iface.ejAnt = false;

  flcontinfo.iface.pub_establecerInformeActual(this.iface.idInforme, this.iface.nombreInforme);

  // Vaciar el buffer
  flcontinfo.iface.pub_vaciarBuffer("co_i_balancepyg_buffer");

  // Recabar datos de esta empresa
  this.iface.crearPyG(sys.nameBD(), cursor.valueBuffer("i_co__subcuentas_codejercicioact"), cursor.valueBuffer("d_co__asientos_fechaact"), cursor.valueBuffer("h_co__asientos_fechaact"));
  this.iface.informarTablaPyG();

  // Recabar datos del resto de empresas
  var curTab: FLSqlCursor = new FLSqlCursor("co_ejerciciosempresas_pyg");
  curTab.select("idbalance = " + cursor.valueBuffer("id"));
  while (curTab.next()) {
    this.iface.crearPyG(curTab.valueBuffer("nombrebd"), curTab.valueBuffer("codejercicio"), curTab.valueBuffer("fechadesde"), curTab.valueBuffer("fechahasta"));
    this.iface.informarTablaPyG();
  }

  // Datos de pérdidas y ganancias
  this.iface.datos = [];
  this.iface.resultadosPyG(2);
  this.iface.rellenarDatosPyG(this.iface.ejAct);
  this.iface.informarTablaPyG();

  /** \D
  Una segunda query es necesaria para elaborar el informe, y se elecuta sobre la tabla co_i_balancepyg_buffer. El where de esta consulta permite obtener las líneas de AI, AII, ... BI, BII... (dentro de los códigos de balance) Buf1 y Buf2 son las tablas buffer para ambos ejercicios
  \end */
  var q: FLSqlQuery = new FLSqlQuery(cursor.action());
  var util: FLUtil = new FLUtil();

  q.setOrderBy("buf.naturaleza, buf.nivel1, buf.nivel2, buf.codcuenta");


  if (q.exec() == false) {
    MessageBox.critical(util.
                        translate("scripts", "Falló la 2ª consulta"),
                        MessageBox.Ok, MessageBox.NoButton,
                        MessageBox.NoButton);
    return;
  } else {
    if (q.first() == false) {
      MessageBox.warning(util.
                         translate("scripts", "No hay registros que cumplan los criterios de búsqueda establecidos"),
                         MessageBox.Ok, MessageBox.NoButton,
                         MessageBox.NoButton);
      return;
    }
  }

  var rptViewer: FLReportViewer = new FLReportViewer();
  rptViewer.setReportTemplate("co_i_balancepyg_multi");
  rptViewer.setReportData(q);
  rptViewer.renderReport();
  rptViewer.exec();
}

/** \D
Establece y ejecuta la consulta principal y así obtiene las líneas del informe correspondientes al último nivel: el de cuenta.
@return True si se pudieron recoger los datos para el informe, false en caso contrario
\end */
function bMultiempresa_crearPyG(nombrebd: String, codEjercicio: String, fechaDesde: String, fechaHasta: String): Boolean {
  var cursor: FLSqlCursor = this.cursor();

  // Si es consolidado con la empresa actual, lanzamos el proceso normal
  if (cursor.valueBuffer("ejercicioanterior"))
    return this.iface.__crearPyG();

  var util: FLUtil = new FLUtil();

  var asientoPyG: Number = -1;
  this.iface.ejAct = codEjercicio;

  // Conectamos
  var q: FLSqlQuery;
  var curRem: FLSqlCursor;
  var conexion: String;

  debug(nombrebd + " " + sys.nameBD());

  if (nombrebd != sys.nameBD())
  {
    conexion = nombrebd + "_conn";
    if (!flcontinfo.iface.pub_conectar(nombrebd))
      return;
    q = new FLSqlQuery("", conexion);
    curRem = new FLSqlCursor("ejercicios", conexion);
  } else {
    conexion = "default";
    q = new FLSqlQuery();
    curRem = new FLSqlCursor("ejercicios");
  }

  // Ignora asiento de cierre?
  if (cursor.valueBuffer("ignorarcierre"))
  {
    curRem.select("codejercicio = '" + this.iface.ejAct + "'");
    if (curRem.first())
      asientoPyG = curRem.valueBuffer("idasientopyg");
  }

  // Ignora asiento de cierre?
  if (cursor.valueBuffer("ignorarcierre"))
  {
    asientoPyg = util.sqlSelect("ejercicios", "idasientopyg", "codejercicio = '" + this.iface.ejAct + "'");
  }

  flcontinfo.iface.pub_establecerEjerciciosPYG(this.iface.ejAct, false, false);

  /** \D
  La consulta es compleja y se ejecuta sobre varias tablas. Las líneas obtenidas son aquellas pertenecientes a las partidas cuya subcuenta está asociada a un código de balance (a través de la cuenta) de naturaleza DEBE o HABER. La consulta extrae la suma del saldo de las subcuentas agrupadas por cuenta. Se extrae además el ejercicio, que se utilzará en caso de comparar o consolidar dos ejercicios.
  \end */

  q.setTablesList
  ("co_cuentas,co_codbalances,co_subcuentas,co_asientos,co_partidas");

  q.setFrom
  ("co_codbalances INNER JOIN co_cuentas ON co_cuentas.codbalance = co_codbalances.codbalance INNER JOIN co_subcuentas ON co_subcuentas.idcuenta = co_cuentas.idcuenta INNER JOIN co_partidas ON co_subcuentas.idsubcuenta = co_partidas.idsubcuenta INNER JOIN co_asientos ON co_partidas.idasiento = co_asientos.idasiento");

  q.setSelect
  ("co_codbalances.codbalance, co_codbalances.naturaleza, co_codbalances.nivel1, co_codbalances.nivel2, co_codbalances.nivel3,	co_codbalances.descripcion1, co_codbalances.descripcion2, co_codbalances.descripcion3, co_cuentas.codcuenta, co_cuentas.descripcion, 	SUM(co_partidas.debe-co_partidas.haber)");

  q.setWhere
  ("(co_codbalances.naturaleza = '" + util.translate("MetaData", "DEBE") + "' OR co_codbalances.naturaleza = '" + util.translate("MetaData", "HABER") + "')"
  + " AND ( ((co_asientos.codejercicio = '" + this.iface.ejAct + "') " +
  " AND (co_asientos.idasiento <> '" + asientoPyG + "')" +
  " AND (co_asientos.fecha >= '" + fechaDesde + "')" +
  " AND (co_asientos.fecha <= '" + fechaHasta + "') ))" +
  " GROUP BY co_codbalances.codbalance, co_codbalances.naturaleza, co_codbalances.nivel1, co_codbalances.nivel2, co_codbalances.nivel3, co_codbalances.descripcion1, co_codbalances.descripcion2, co_codbalances.descripcion3, co_cuentas.codcuenta, co_cuentas.descripcion,  co_asientos.codejercicio ORDER BY co_codbalances.naturaleza, co_codbalances.nivel1, co_codbalances.nivel2, co_codbalances.nivel3, co_cuentas.codcuenta");


  var util: FLUtil = new FLUtil();
  if (!q.exec())
  {
    MessageBox.critical(util.translate("scripts", "Falló la 1ª consulta"),
    MessageBox.Ok, MessageBox.NoButton,
    MessageBox.NoButton);
    return false;
  }

  var registro: Number = 0;
  var encontrados: Boolean = false;
  this.iface.datos = [];

  /** \D
  Los datos procedentes de la consulta se almacenan temporalmente en el array Datos
  \end */
  while (q.next())
  {
    encontrados = true;

    this.iface.datos[registro] = new Array(2);
    this.iface.datos[registro]["codbalance"] = q.value(0);
    this.iface.datos[registro]["naturaleza"] = q.value(1);
    this.iface.datos[registro]["nivel1"] = q.value(2);
    this.iface.datos[registro]["nivel2"] = q.value(3);
    this.iface.datos[registro]["nivel3"] = q.value(4);
    this.iface.datos[registro]["descripcion1"] = q.value(5);
    this.iface.datos[registro]["descripcion2"] = q.value(6);
    this.iface.datos[registro]["descripcion3"] = q.value(7);
    this.iface.datos[registro]["codcuenta"] = q.value(8);
    this.iface.datos[registro]["desccuenta"] = q.value(9);
    this.iface.datos[registro]["suma"] = q.value(10);
    this.iface.datos[registro]["codejercicio"] = codEjercicio;
    this.iface.datos[registro]["nombrebd"] = nombrebd;

    // Control de variación de existencias.
    codCuenta = this.iface.datos[registro]["codcuenta"];
    if (codCuenta.left(2) == "71") {
      suma = flcontinfo.iface.pub_mudarCuentasExistencias(this.iface.datos[registro], conexion);
      this.iface.datos[registro]["suma"] = suma;
    }

    if (q.value(1) == "HABER")
      this.iface.datos[registro]["suma"] = 0 - q.value(10);

    registro++;
  }

  if (!encontrados)
  {
    MessageBox.warning(util.translate("scripts", "No hay registros que cumplan los criterios de búsqueda establecidos"),
                       MessageBox.Ok, MessageBox.NoButton,
                       MessageBox.NoButton);
    return false;
  }

  if (this.iface.datos.length == 0)
    return false;

  return true;
}

/** \D
Añade al array Datos las líneas correspondientes a beneficios y pérdidas: AI ... BVI previamente calculados

@param ej Código del ejercicio cuyos datos serán guardados
\end */
function bMultiempresa_rellenarDatosPyG(ej: String, nombrebd: String)
{
  if (nombrebd == "default")
    return this.iface.__rellenarDatosPyG(ej);

  var util: FLUtil = new FLUtil();
  var indicesAB: Array = new Array("I", "II", "III", "IV", "V", "VI");
  var where: String;
  var descripcion1: String;
  var registro: Number = this.iface.datos.length;
  var codBalance: String;

  for (var i: Number = 0; i < indicesAB.length; i++) {

    // Vale el local
    codBalance = "D-" + indicesAB[i];
    descripcion1 =  util.sqlSelect("co_codbalances", "descripcion1", "codbalance = '" + codBalance + "'");

    this.iface.datos[registro] = new Array(2);
    this.iface.datos[registro]["codbalance"] = codBalance;
    this.iface.datos[registro]["naturaleza"] = "DEBE";
    this.iface.datos[registro]["nivel1"] = indicesAB[i];
    this.iface.datos[registro]["nivel2"] = "";
    this.iface.datos[registro]["nivel3"] = "";
    this.iface.datos[registro]["descripcion1"] = descripcion1;
    this.iface.datos[registro]["descripcion2"] = "";
    this.iface.datos[registro]["descripcion3"] = "";
    this.iface.datos[registro]["codcuenta"] = "";
    this.iface.datos[registro]["desccuenta"] = "";
    this.iface.datos[registro]["suma"] = this.iface.AB["A" + indicesAB[i]];
    this.iface.datos[registro]["codejercicio"] = ej;
    registro++;


    codBalance = "H-" + indicesAB[i];
    descripcion1 =
      util.sqlSelect("co_codbalances", "descripcion1",
                     "codbalance = '" + codBalance + "'");

    this.iface.datos[registro] = new Array(2);
    this.iface.datos[registro]["codbalance"] = "H-" + indicesAB[i];
    this.iface.datos[registro]["naturaleza"] = "HABER";
    this.iface.datos[registro]["nivel1"] = indicesAB[i];
    this.iface.datos[registro]["nivel2"] = "";
    this.iface.datos[registro]["nivel3"] = "";
    this.iface.datos[registro]["descripcion1"] = descripcion1;
    this.iface.datos[registro]["descripcion2"] = "";
    this.iface.datos[registro]["descripcion3"] = "";
    this.iface.datos[registro]["codcuenta"] = "";
    this.iface.datos[registro]["desccuenta"] = "";
    this.iface.datos[registro]["suma"] = this.iface.AB["B" + indicesAB[i]];
    this.iface.datos[registro]["codejercicio"] = ej;
    registro++;
  }
  /** \D
  Al terminar el array Datos ya contiene toda la información necesaria para realizar el informe: las líneas a nivel de cuenta con las sumas de saldos y las líneas de beneficios y pérdidas
  \end */

}

/** \D
Vuelca los datos del Array en la tabla co_i_balancepyg_buffer que actúa como buffer temporal. La consulta definitiva del informe se hará sobre esta tabla
\end */
function bMultiempresa_informarTablaPyG()
{
  if (this.cursor().valueBuffer("ejercicioanterior"))
    return this.iface.__informarTablaPyG();

  var i: Number;
  var suma: Number;
  var cursor: FLSqlCursor = new FLSqlCursor("co_i_balancepyg_buffer");

  for (var i: Number = 0; i < this.iface.datos.length; i++) {

    cursor.select("codcuenta = '" + this.iface.datos[i]["codcuenta"] + "' " +
                  "AND naturaleza = '" + this.iface.datos[i]["naturaleza"] + "' " +
                  "AND nivel1 = '" + this.iface.datos[i]["nivel1"] + "' " +
                  "AND nivel2 = '" + this.iface.datos[i]["nivel2"] + "'");

    if (cursor.first()) {
      cursor.setModeAccess(cursor.Edit);
      cursor.refreshBuffer();
    } else {
      cursor.setModeAccess(cursor.Insert);
      cursor.refreshBuffer();
      cursor.setValueBuffer("codcuenta", this.iface.datos[i]["codcuenta"]);
      cursor.setValueBuffer("codbalance", this.iface.datos[i]["codbalance"]);
      cursor.setValueBuffer("naturaleza", this.iface.datos[i]["naturaleza"]);
      cursor.setValueBuffer("nivel1", this.iface.datos[i]["nivel1"]);
      cursor.setValueBuffer("nivel2", this.iface.datos[i]["nivel2"]);
      cursor.setValueBuffer("nivel3", this.iface.datos[i]["nivel3"]);
      cursor.setValueBuffer("descripcion1", this.iface.datos[i]["descripcion1"]);
      cursor.setValueBuffer("descripcion2", this.iface.datos[i]["descripcion2"]);
      cursor.setValueBuffer("descripcion3", this.iface.datos[i]["descripcion3"]);
      cursor.setValueBuffer("codcuenta", this.iface.datos[i]["codcuenta"]);
      cursor.setValueBuffer("desccuenta", this.iface.datos[i]["desccuenta"]);
    }

    suma = parseFloat(cursor.valueBuffer("sumaact")) + parseFloat(this.iface.datos[i]["suma"]);
    cursor.setValueBuffer("sumaact", suma);
    cursor.commitBuffer();

  }
}

//// FUN_BMULTIEMPRESA /////////////////////////////////////////////////
////////////////////////////////////////////////////////////////
