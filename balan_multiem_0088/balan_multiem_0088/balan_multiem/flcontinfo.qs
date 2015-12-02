
/** @class_declaration bMultiempresa */
/////////////////////////////////////////////////////////////////
//// FUN_BMULTIEMPRESA //////////////////////////////////////////////////
class bMultiempresa extends oficial
{
  function bMultiempresa(context)
  {
    oficial(context);
  }

  function conectar(nombrebd: String): Boolean {
    return this.ctx.bMultiempresa_conectar(nombrebd);
  }
  function desconectar(bd: String)
  {
    return this.ctx.bMultiempresa_desconectar(bd);
  }
  function vaciarBuffer(tabla: String): Boolean {
    return this.ctx.bMultiempresa_vaciarBuffer(tabla);
  }
  function cabeceraInforme(nodo: FLDomNode, campo: String): String {
    return this.ctx.bMultiempresa_cabeceraInforme(nodo, campo);
  }
  function mudarCuentasExistencias(registro: Array, conexion: String): Number {
    return this.ctx.bMultiempresa_mudarCuentasExistencias(registro, conexion);
  }
  function resultadosEjercicio(AB: Array, ej: String, desde: String, hasta: String, ignorarCierre: Boolean, conexion: String): Boolean {
    return this.ctx.bMultiempresa_resultadosEjercicio(AB, ej, desde, hasta, ignorarCierre, conexion);
  }
}
//// FUN_BMULTIEMPRESA //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pubbMultiempresa */
/////////////////////////////////////////////////////////////////
//// FUN_BMULTIEMPRESA //////////////////////////////////////////////////
class pubbMultiempresa extends ifaceCtx
{
  function pubbMultiempresa(context)
  {
    ifaceCtx(context);
  }

  function pub_conectar(nombrebd: String): Boolean {
    return this.conectar(nombrebd);
  }
  function pub_desconectar(bd: String)
  {
    return this.desconectar(bd);
  }
  function pub_resultadosEjercicio(AB: Array, ej: String, desde: String, hasta: String, ignorarCierre: Boolean, conexion: String): Boolean {
    return this.resultadosEjercicio(AB, ej, desde, hasta, ignorarCierre, conexion);
  }
}
//// FUN_BMULTIEMPRESA //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition bMultiempresa */
/////////////////////////////////////////////////////////////////
//// FUN_BMULTIEMPRESA //////////////////////////////////////////////////

function bMultiempresa_conectar(nombrebd: String): Boolean {
  var util: FLUtil = new FLUtil();

  var curEmpresa: FLSqlCursor = new FLSqlCursor("co_empresas");
  curEmpresa.select("nombrebd = '" + nombrebd + "'");
  if (!curEmpresa.first())
  {
    MessageBox.information(util.translate("scripts", "No se encontró la empresa"),
    MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return false;
  }

  var driver: String = curEmpresa.valueBuffer("driver");
  var nombreBD: String = curEmpresa.valueBuffer("nombrebd");
  var usuario: String = curEmpresa.valueBuffer("usuario");
  var host: String = curEmpresa.valueBuffer("host");
  var puerto: String = curEmpresa.valueBuffer("puerto");

  var conexion: String = curEmpresa.valueBuffer("nombrebd") + "_conn";

  var tipoDriver: String;
  if (sys.nameDriver().search("PSQL") > -1)
    tipoDriver = "PostgreSQL";
  else
    tipoDriver = "MySQL";

  //  if (host == sys.nameHost() && nombreBD == sys.nameBD() && driver == tipoDriver) {
  //    MessageBox.warning(util.translate("scripts",
  //      "Los datos de conexión son los de la presente base de datos\nDebe indicar los datos de conexión de la base de datos remota"),
  //      MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
  //    return false;
  //  }

  if (!driver || !nombreBD || !usuario || !host)
  {
    MessageBox.warning(util.translate("scripts",
    "Debe indicar el tipo de base de datos, nombre de la misma, usuario y servidor"),
    MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return false;
  }

  var password: String = Input.getText(util.translate("scripts", "Password de conexión para %0 (en caso necesario)").arg(nombreBD));

  if (!sys.addDatabase(driver, nombreBD, usuario, password, host, puerto, conexion))
    return false;

  return true;
}

function bMultiempresa_desconectar(bd: String): Boolean {
  if (!sys.removeDatabase(bd + "_conn"));
  return false;

  return true;
}

function bMultiempresa_vaciarBuffer(tabla: String): Boolean {
  var util: FLUtil = new FLUtil();

  var util: FLUtil = new FLUtil();
  if (util.sqlDelete(tabla, "1=1"))
    return true;

  return false
}

function bMultiempresa_cabeceraInforme(nodo: FLDomNode, campo: String): String {
  var texCampo: String = new String(campo);

  var util: FLUtil = new FLUtil();
  var desc: String;
  var ejAct: String, ejAnt: String;
  var fchDesde: String, fchHasta: String;
  var fchDesdeAnt: String, fchHastaAnt: String;
  var sctDesde: String, sctHasta: String;
  var asiDesde: Number, asiHasta: Number;

  var texto: String;
  var sep: String = "       ";

  var qCondiciones: FLSqlQuery = new FLSqlQuery();

  qCondiciones.setTablesList(this.iface.nombreInformeActual);
  qCondiciones.setFrom(this.iface.nombreInformeActual);
  qCondiciones.setWhere("id = " + this.iface.idInformeActual);

  switch (texCampo)
  {

    case "balancesis":

      qCondiciones.setSelect("descripcion,i_co__subcuentas_codejercicio,d_co__asientos_fecha,h_co__asientos_fecha,d_co__subcuentas_codsubcuenta,h_co__subcuentas_codsubcuenta,ejercicioanterior");

      if (!qCondiciones.exec())
        return "";
      if (!qCondiciones.first())
        return "";

      if (qCondiciones.value(6))
        return this.iface.__cabeceraInforme(nodo, campo);

      desc = qCondiciones.value(0);
      ejAct = qCondiciones.value(1);

      fchDesde = qCondiciones.value(2).toString().left(10);
      fchHasta = qCondiciones.value(3).toString().left(10);
      fchDesde = util.dateAMDtoDMA(fchDesde);
      fchHasta = util.dateAMDtoDMA(fchHasta);

      sctDesde = qCondiciones.value(4);
      sctHasta = qCondiciones.value(5);

      texto = "[ " + desc + " ]" + sep + "Periodo  " + fchDesde + " - " + fchHasta;
      texto += sep + "Subcuentas  " + sctDesde + " - " + sctHasta;

      texto += "\nEMPRESAS / EJERCICIOS:" + sep + sys.nameBD() + " / " + ejAct + sep;

      var q: FLSqlQuery = new FLSqlQuery();
      q.setTablesList("co_ejerciciosempresas_sis");
      q.setFrom("co_ejerciciosempresas_sis");
      q.setSelect("nombrebd,codejercicio");
      q.setWhere("idbalance = " + this.iface.idInformeActual);

      q.exec();
      while (q.next())
        texto += q.value(0) + " / " + q.value(1) + sep;

      break;


    case "balancesit":

      qCondiciones.setSelect("descripcion,i_co__subcuentas_codejercicioact,d_co__asientos_fechaact,h_co__asientos_fechaact");

      if (!qCondiciones.exec())
        return "";
      if (!qCondiciones.first())
        return "";

      if (qCondiciones.value(6))
        return this.iface.__cabeceraInforme(nodo, campo);

      desc = qCondiciones.value(0);
      ejAct = qCondiciones.value(1);

      fchDesde = qCondiciones.value(2).toString().left(10);
      fchHasta = qCondiciones.value(3).toString().left(10);
      fchDesde = util.dateAMDtoDMA(fchDesde);
      fchHasta = util.dateAMDtoDMA(fchHasta);

      sctDesde = qCondiciones.value(4);
      sctHasta = qCondiciones.value(5);

      texto = "[ " + desc + " ]" + sep + "Periodo  " + fchDesde + " - " + fchHasta;
      texto += "\nEMPRESAS / EJERCICIOS:" + sep + sys.nameBD() + " / " + ejAct + sep;

      var q: FLSqlQuery = new FLSqlQuery();
      q.setTablesList("co_ejerciciosempresas_sit");
      q.setFrom("co_ejerciciosempresas_sit");
      q.setSelect("nombrebd,codejercicio");
      q.setWhere("idbalance = " + this.iface.idInformeActual);

      q.exec();
      while (q.next())
        texto += q.value(0) + " / " + q.value(1) + sep;

      break;


    case "balancepyg":

      qCondiciones.setSelect("descripcion,i_co__subcuentas_codejercicioact,d_co__asientos_fechaact,h_co__asientos_fechaact");

      if (!qCondiciones.exec())
        return "";
      if (!qCondiciones.first())
        return "";

      desc = qCondiciones.value(0);
      ejAct = qCondiciones.value(1);

      fchDesde = qCondiciones.value(2).toString().left(10);
      fchHasta = qCondiciones.value(3).toString().left(10);
      fchDesde = util.dateAMDtoDMA(fchDesde);
      fchHasta = util.dateAMDtoDMA(fchHasta);

      texto = flfactppal.iface.pub_valorDefectoEmpresa("nombre") + sep;
      texto += "[ " + desc + " ]" + sep + "Periodo  " + fchDesde + " - " + fchHasta;

      var q: FLSqlQuery = new FLSqlQuery();
      q.setTablesList("co_ejerciciosempresas_pyg");
      q.setFrom("co_ejerciciosempresas_pyg");
      q.setSelect("nombrebd,codejercicio");
      q.setWhere("idbalance = " + this.iface.idInformeActual);

      i = 0;
      q.exec();
      while (q.next()) {
        if (i++ == 0)
          texto += "\nEMPRESAS / EJERCICIOS:" + sep + sys.nameBD() + " / " + ejAct + sep;
        texto += q.value(0) + " / " + q.value(1) + sep;
      }

      break;


    case "numpag":

      this.iface.numPag++;
      return "página " + this.iface.numPag + " ";
      break;

    default:
      return this.iface.__cabeceraInforme(nodo, campo);
  }

  debug(texto);
  return texto;
}

/** \D A la hora de obtener los balances las cuentas 71... van al debe o
al haber en función del saldo
 \end */
function bMultiempresa_mudarCuentasExistencias(registro: Array, conexion: String): Number {
  if (!conexion)
    conexion = "default";

  var suma: String = registro["suma"];

  if (registro["codbalance"] != "D-A-1" && registro["codbalance"] != "H-B-2")
    return suma;

  var util: FLUtil = new FLUtil();
  var codEjercicio: String = flfactppal.iface.pub_ejercicioActual();

  // Nuevos valores
  var codBalance: String;
  var naturaleza: String;
  var nivel1: String;
  var nivel2: String;
  var cambio: Boolean = false;

  // Del debe al haber
  if (registro["codbalance"] == "D-A-1" && registro["suma"] < 0)
  {
    codBalance = "H-B-2";
    naturaleza = "HABER";
    nivel1 = "B";
    nivel2 = "2";
    cambio = true;
  }

  // Del haber al debe
  if (registro["codbalance"] == "H-B-2" && registro["suma"] > 0)
  {
    codBalance = "D-A-1";
    naturaleza = "DEBE";
    nivel1 = "A";
    nivel2 = "1";
    suma = 0 - suma;
    cambio = true;
  }

  if (!cambio)
    return suma;

  // Mudamos las cuentas
  var curCue: FLSqlCursor = new FLSqlCursor("co_cuentas", conexion);
  curCue.select("codbalance = '" + registro["codbalance"] + "' AND codejercicio = '" + codEjercicio + "'");
  while (curCue.next())
  {
    curCue.setModeAccess(curCue.Edit);
    curCue.refreshBuffer();
    curCue.setValueBuffer("codbalance", codBalance);
    if (!curCue.commitBuffer()) {
      debug("Error al mudar el código de balance de la cuenta para el código " + registro["codbalance"]);
      return suma;
    }
  }

  return suma;
}

/** \D Realiza el cálculo de resultados del ejercicio en cuanto a pérdidas y ganancias.

@param AB Array pasado por variable donde se guardarán los resultados
@param ej Ejercicio sobre el que se calculan los datos
@param desde Fecha inicial del intervalo de cálculo
@param hasta Fecha final del intervalo de cálculo
\end */
function bMultiempresa_resultadosEjercicio(AB: Array, ej: String, desde: String, hasta: String, ignorarCierre: Boolean, conexion: String): Boolean {
  var A: Array = [];
  var B: Array = [];
  var dat: Array = [];

  var util: FLUtil = new FLUtil();

  /** \D En primer lugar se realiza una consulta para obtener los totales de saldos de subcuentas agrupadas por cuenta, para aquellas cuentas cuyo código de balance sea 'DEBE' o 'HABER'
  \end */
  var asientoPyG: Number = -1;
  var asientoCierre: Number = -1;
  if (ignorarCierre)
  {
    curRem = new FLSqlCursor("ejercicios", conexion);
    curRem.select("codejercicio = '" + this.iface.ejAct + "'");
    if (curRem.first()) {
      asientoPyG = curRem.valueBuffer("idasientopyg");
      asientoCierre = curRem.valueBuffer("idasientocierre");
    }
  }

  q = new FLSqlQuery("", conexion);
  q.setTablesList
  ("co_cuentas,co_codbalances,co_subcuentas,co_asientos,co_partidas");

  q.setFrom
  ("co_codbalances INNER JOIN co_cuentas ON co_cuentas.codbalance = co_codbalances.codbalance INNER JOIN co_subcuentas ON co_subcuentas.idcuenta = co_cuentas.idcuenta INNER JOIN co_partidas ON co_subcuentas.idsubcuenta = co_partidas.idsubcuenta INNER JOIN co_asientos ON co_partidas.idasiento = co_asientos.idasiento");

  q.setSelect
  ("co_codbalances.codbalance, co_codbalances.naturaleza, co_codbalances.nivel1, co_codbalances.nivel2, co_codbalances.nivel3,	co_codbalances.descripcion1, co_codbalances.descripcion2, co_codbalances.descripcion3, co_cuentas.codcuenta, co_cuentas.descripcion, SUM(co_partidas.debe-co_partidas.haber), co_asientos.codejercicio");

  q.setWhere
  ("(co_codbalances.naturaleza = 'DEBE' OR co_codbalances.naturaleza = 'HABER')"
   + " AND ( ((co_asientos.codejercicio = '" + ej + "') " +
   " AND (co_asientos.idasiento <> '" + asientoPyG + "')" +
   " AND (co_asientos.idasiento <> '" + asientoCierre + "')" +
   " AND (co_asientos.fecha >= '" + desde + "')" +
   " AND (co_asientos.fecha <= '" + hasta + "') ))" +
   " GROUP BY co_codbalances.codbalance, co_codbalances.naturaleza, co_codbalances.nivel1, co_codbalances.nivel2, co_codbalances.nivel3,	co_codbalances.descripcion1, co_codbalances.descripcion2, co_codbalances.descripcion3, co_cuentas.codcuenta, co_cuentas.descripcion, co_asientos.codejercicio ORDER BY co_codbalances.naturaleza, co_codbalances.nivel1, co_codbalances.nivel2, co_codbalances.nivel3, co_cuentas.codcuenta");

  var util: FLUtil = new FLUtil();
  if (!q.exec())
    return false;

  var registro: Number = 0;
  var encontrados: Boolean = false;

  /** \D El resultado de la consulta se almacena en un array bidimensional
  \end */
  while (q.next())
  {

    encontrados = true;

    dat[registro] = new Array(2);
    dat[registro]["codbalance"] = q.value(0);
    dat[registro]["naturaleza"] = q.value(1);
    dat[registro]["nivel1"] = q.value(2);
    dat[registro]["nivel2"] = q.value(3);
    dat[registro]["nivel3"] = q.value(4);
    dat[registro]["descripcion1"] = q.value(5);
    dat[registro]["descripcion2"] = q.value(6);
    dat[registro]["descripcion3"] = q.value(7);
    dat[registro]["codcuenta"] = q.value(8);
    dat[registro]["desccuenta"] = q.value(9);
    dat[registro]["suma"] = q.value(10);
    dat[registro]["codejercicio"] = q.value(11);

    // Control de variación de existencias.
    codCuenta = dat[registro]["codcuenta"];
    if (codCuenta.left(2) == "71") {
      suma = this.iface.mudarCuentasExistencias(dat[registro]);
      dat[registro]["suma"] = suma;
    }

    if (q.value(1) == "HABER")
      dat[registro]["suma"] = 0 - q.value(10);
    registro++;
  }

  if (!encontrados)
    return false;

  var i: Number;

  /** \D Se calculan las sumas de valores de cuentas (previamente obtenidos) agrupados por código de balance mediante la función 'sumarPyG'. Estos valores se almacenan en los arrarys A[] y B[]
  \end */
  for (i = 1; i <= 8; i++)
  {

    A[i] = this.iface.sumarPyG(dat, "DEBE", "A", i, ej);
  }

  for (i = 7; i <= 9; i++)
  {

    A[i] = this.iface.sumarPyG(dat, "DEBE", "I", i, ej);
  }

  for (i = 10; i <= 14; i++)
  {

    A[i] = this.iface.sumarPyG(dat, "DEBE", "III", i - 10, ej);
  }

  // Impuesto sobre beneficios. Puede ser negativo
  A[15] = this.iface.sumarPyGNoAbs(dat, "DEBE", "V", 5, ej);
  A[16] = this.iface.sumarPyG(dat, "DEBE", "V", 6, ej);


  for (i = 1; i <= 4; i++)
  {

    B[i] = this.iface.sumarPyG(dat, "HABER", "B", i, ej);
  }

  for (i = 5; i <= 8; i++)
  {

    B[i] = this.iface.sumarPyG(dat, "HABER", "I", i, ej);
  }

  B[9] = this.iface.sumarPyG(dat, "HABER", "III", "A", ej);
  B[10] = this.iface.sumarPyG(dat, "HABER", "III", "B", ej);
  B[11] = this.iface.sumarPyG(dat, "HABER", "III", "C", ej);
  B[12] = this.iface.sumarPyG(dat, "HABER", "III", "D", ej);
  B[13] = this.iface.sumarPyG(dat, "HABER", "III", "E", ej);

  AB["AA"] = 0;
  for (i = 1; i < A.length; i++)
  {
    AB["AA"] += A[i];
  }

  AB["BB"] = 0;
  for (i = 1; i < B.length; i++)
  {
    AB["BB"] += B[i];
  }

  /** \D Se aplican las fórmulas contables para calcular los valores AI - BVI que aparecerán en el informe de pérdidas y ganancias:

  AI BENEFICIOS DE EXPLOTACION (B1+B2+B3+B4-A1-A2-A3-A4-A5-A6)

  AII RESULTADOS FINANCIEROS POSITIVOS (B5+B6+B7+B8-A7-A8-A9)

  AIII BENEFICIOS DE LAS ACTIVIDADES ORDINARIAS (AI+AII-BI-BII)

  AIV RESULTADOS EXTRAORDINARIOS POSITIVOS(B9+B10+B11+B12+B13-A10-A11-A12-A13-A14)

  AV BENEFICIOS ANTES DE IMPUESTOS (AIII+AIV-BIII-BIV)

  AVI RESULTADOS DEL EJERCICIO (BENEFICIOS) (AV-A15-A16)

  BI PERDIDAS DE EXPLOTACION (A1+A2+A3+A4+A5+A6-B1-B2-B3-B4)

  BII RESULTADOS FINANCIEROS NEGATIVOS (A7+A8+A9-B5-B6-B7-B8)

  BIII PERDIDAS DE LAS ACTIVIDADES ORDINARIAS (BI+BII-AI-AII)

  BIV RESULTADOS EXTRAORDINARIOS NEGATIVOS (A10+A11+A12+A13+A14-B9-B10-B11-B12-B13)

  BV PERDIDAS ANTES DE IMPUESTOS (BIII+BIV-AIII-AIV)

  BVI RESULTADO DEL EJERCICIO (PERDIDAS) (BV+A15+A16)
  \end */
  AB["AI"] =
    B[1] + B[2] + B[3] + B[4] - A[1] - A[2] - A[3] - A[4] - A[5] -
    A[6];
  AB["AII"] = B[5] + B[6] + B[7] + B[8] - A[7] - A[8] - A[9];
  if (AB["AI"] < 0)
    AB["AI"] = 0;
  if (AB["AII"] < 0)
    AB["AII"] = 0;

  AB["BI"] =
    A[1] + A[2] + A[3] + A[4] + A[5] + A[6] - B[1] - B[2] - B[3] -
    B[4];

  AB["BII"] = A[7] + A[8] + A[9] - B[5] - B[6] - B[7] - B[8];
  if (AB["BI"] < 0)
    AB["BI"] = 0;
  if (AB["BII"] < 0)
    AB["BII"] = 0;

  AB["AIII"] = parseFloat(AB["AI"] + AB["AII"] - AB["BI"] - AB["BII"]);
  AB["AIV"] =
    B[9] + B[10] + B[11] + B[12] + B[13] - A[10] - A[11] - A[12] -
    A[13] - A[14];
  if (AB["AIII"] < 0)
    AB["AIII"] = 0;
  if (AB["AIV"] < 0)
    AB["AIV"] = 0;

  AB["BIII"] = AB["BI"] + AB["BII"] - AB["AI"] - AB["AII"];
  AB["BIV"] =
    A[10] + A[11] + A[12] + A[13] + A[14] - B[9] - B[10] - B[11] -
    B[12] - B[13];
  if (AB["BIII"] < 0)
    AB["BIII"] = 0;
  if (AB["BIV"] < 0)
    AB["BIV"] = 0;

  AB["AV"] = AB["AIII"] + AB["AIV"] - AB["BIII"] - AB["BIV"];
  AB["BV"] = AB["BIII"] + AB["BIV"] - AB["AIII"] - AB["AIV"];
  if (AB["AV"] < 0)
    AB["AV"] = 0;
  if (AB["BV"] < 0)
    AB["BV"] = 0;

  AB["AVI"] = AB["AV"] - A[15] - A[16];
  AB["BVI"] = AB["BV"] + A[15] + A[16];
  if (AB["AVI"] < 0)
    AB["AVI"] = 0;
  if (AB["BVI"] < 0 || AB["AVI"] > 0)
    AB["BVI"] = 0;

  return true;
}

//// FUN_BMULTIEMPRESA /////////////////////////////////////////////////
////////////////////////////////////////////////////////////////

