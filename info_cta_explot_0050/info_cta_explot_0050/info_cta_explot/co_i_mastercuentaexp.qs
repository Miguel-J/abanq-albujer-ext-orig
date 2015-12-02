/***************************************************************************
                 i_mastercuentaexp.qs  -  description
                             -------------------
    begin                : lun abr 26 2004
    copyright            : (C) 2004 by InfoSiAL S.L.
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

/** @class_declaration interna */
//////////////////////////
//// DECLARACION ///////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

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
  var datos: Array;
  var sumas: Array;
  var totales: Array;
  var nombreInforme: String;
  var idInforme: Number;
  function oficial(context)
  {
    interna(context);
  }
  function lanzar()
  {
    return this.ctx.oficial_lanzar();
  }
  function limpiarTablaBuff()
  {
    return this.ctx.oficial_limpiarTablaBuff();
  }
  function informarTablaBuff(ejercicio: String)
  {
    return this.ctx.oficial_informarTablaBuff(ejercicio);
  }
  function obtenerDatos(ejercicio: String)
  {
    return this.ctx.oficial_obtenerDatos(ejercicio);
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
/** \C El botón de impresión lanza el informe
\end */
function interna_init()
{
  connect(this.child("toolButtonPrint"), "clicked()", this, "iface.lanzar()");
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
/** \D Lanza el informe
\end */
function oficial_lanzar()
{
  var util: FLUtil = new FLUtil();
  var cursor: FLSqlCursor = this.cursor()
                            if (!cursor.isValid())
                              return;

  if (!util.sqlSelect("co_codcuentaexp1", "codigo", "1=1")) {
    MessageBox.warning(util.translate("scripts", "No existen datos de códigos para la cuenta de explotación.\nAbra el módulo principal de contabilidad para cargarlos"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return false;
  }

  this.iface.limpiarTablaBuff();

  // Acciones previas
  if (!this.iface.obtenerDatos("ej1"))
    return;
  if (!this.iface.obtenerDatos("ej2"))
    return;
  if (!this.iface.informarTablaBuff())
    return;

  flcontinfo.iface.pub_establecerDatos();

  this.iface.idInforme = cursor.valueBuffer("id");
  if (!this.iface.idInforme)
    return;
  this.iface.nombreInforme = cursor.action();
  flcontinfo.iface.pub_establecerInformeActual(this.iface.idInforme, this.iface.nombreInforme);

  var q: FLSqlQuery = new FLSqlQuery(this.iface.nombreInforme);
  q.setOrderBy("e1.orden,buf.codcuenta1,buf.codcuenta2");

  if (!q.exec()) {
    MessageBox.critical(util.translate("scripts", "Falló la 3ª consulta"),
                        MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return;
  } else {
    if (!q.first()) {
      MessageBox.warning(util.translate("scripts", "No hay registros que cumplan los criterios de búsqueda establecidos"),
                         MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
      return;
    }
  }

  var nombreReport: String = this.iface.nombreInforme;
  if (!cursor.valueBuffer("codejercicio2"))
    nombreReport += "_u";

  var rptViewer: FLReportViewer = new FLReportViewer();
  rptViewer.setReportTemplate(nombreReport);
  rptViewer.setReportData(q);
  rptViewer.renderReport();
  rptViewer.exec();
}

/** \D
Realiza las consultas y rellena los resultados en el array datos
\end */
function oficial_obtenerDatos(ejercicio: String): Boolean {
  var util: FLUtil = new FLUtil();
  var cursor: FLSqlCursor = this.cursor()

  var codEjercicio: String;
  var fechaDesde: String, fechaHasta: String;

  this.iface.datos = [];
  this.iface.sumas = [];
  this.iface.totales = [];

  switch (ejercicio)
  {
    case "ej1":
      codEjercicio = cursor.valueBuffer("codejercicio");
      fechaDesde = cursor.valueBuffer("fechadesde");
      fechaHasta = cursor.valueBuffer("fechahasta");
      break;
    case "ej2":
      codEjercicio = cursor.valueBuffer("codejercicio2");
      fechaDesde = cursor.valueBuffer("fechadesde2");
      fechaHasta = cursor.valueBuffer("fechahasta2");
      break;
  }

  if (!util.sqlSelect("ejercicios", "codejercicio", "codejercicio = '" + codEjercicio + "'"))
    return true;

  //Usamos estas funciones del balance de PyG para las cebeceras del informe
  flcontinfo.iface.pub_establecerEjerciciosPYG(cursor.valueBuffer("codejercicio"), cursor.valueBuffer("codejercicio2"), true)

  var asientoPyG: Number = -1;
  asientoPyG = util.sqlSelect("ejercicios", "idasientopyg", "codejercicio = '" + codEjercicio + "'");
  var asientoCierre: Number = -1;
  asientoCierre = util.sqlSelect("ejercicios", "idasientocierre", "codejercicio = '" + codEjercicio + "'");

  var codCuenta1: String, descCuenta1: String;
  var codCuenta2: String, descCuenta2: String;
  var hayDatos: Boolean = false;
  var ultCodCuenta1: String = "";
  var sumaCodCuenta1: Number = 0;
  var registro: Number = 0;

  // Query para obtener la suma de saldos
  var q = new FLSqlQuery();
  q.setTablesList("co_subcuentas,co_asientos,co_partidas");
  q.setFrom("co_subcuentas s " +
  "INNER JOIN co_partidas p ON s.idsubcuenta = p.idsubcuenta " +
  "INNER JOIN co_asientos a ON p.idasiento = a.idasiento");
  q.setSelect("sum(p.debe-p.haber)");

  // Query sobre los tipos de código
  var q0 = new FLSqlQuery();
  q0.setTablesList("co_codcuentaexp1,co_codcuentaexp2");
  q0.setFrom("co_codcuentaexp1 e1 INNER JOIN co_codcuentaexp2 e2 ON e1.codigo = e2.codpadre");
  q0.setSelect("e1.codigo,e1.descripcion,e2.codigo,e2.descripcion");
  q0.setWhere("1 = 1 ORDER BY e1.orden,e2.codigo");

  if (!q0.exec())
  {
    MessageBox.critical(util.translate("scripts", "Falló la 1ª consulta"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return false;
  }

  var paso: Number = 0;
  util.createProgressDialog(util.translate("scripts", "Calculando datos"), q0.size());
  util.setProgress(0);

  var datos682_1: Boolean, datos682_2: Boolean, datos682_3: Boolean, datos681: Boolean, datos682: Boolean;

  var ventasBrutas: Number = 0;
  var devolucionesVentas: Number = 0;
  var variacionExistencias: Number = 0;
  var amortizacionesProviciones: Number = 0;

  while (q0.next())
  {
    codCuenta1 = q0.value(0);
    descCuenta1 = q0.value(1);
    codCuenta2 = q0.value(2);
    descCuenta2 = q0.value(3);

    util.setLabelText(util.translate("scripts", "Calculando datos del ejercicio ") + codEjercicio + "\n" + descCuenta1.upper());
    util.setProgress(paso++);

    q.setWhere("s.codcuentaexp = '" + codCuenta2 + "' " +
    "AND a.codejercicio = '" + codEjercicio + "' " +
    "AND a.idasiento <> '" + asientoPyG + "' " +
    "AND a.idasiento <> '" + asientoCierre + "' " +
    "AND a.fecha >= '" + fechaDesde + "' " +
    "AND a.fecha <= '" + fechaHasta + "' ");

    if (!q.exec()) {
      MessageBox.critical(util.translate("scripts", "Falló la 2ª consulta"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
      return false;
    }

    // Guardamos los datos en un array para su procesado posterior
    if (q.first()) {
      this.iface.datos[registro] = new Array(2);
      this.iface.datos[registro]["codCuenta1"] = codCuenta1;
      this.iface.datos[registro]["descCuenta1"] = descCuenta1;
      this.iface.datos[registro]["codCuenta2"] = codCuenta2;
      this.iface.datos[registro]["descCuenta2"] = descCuenta2;
      this.iface.datos[registro]["suma"] = Math.abs(q.value(0));
      this.iface.datos[registro]["por"] = 0;
      registro++;

      // Para indexar las sumas por código
      this.iface.sumas[codCuenta2] = new Array(2);
      this.iface.sumas[codCuenta2]["suma"] = Math.abs(q.value(0));

      switch (codCuenta2) {
        case "682.1":
          datos682_1 = true;
          break
        case "682.2":
          datos682_2 = true;
          break
        case "682.3":
          datos682_3 = true;
          break
        case "681":
          datos681 = true;
          break
        case "682":
          datos682 = true;
          break
      }

      hayDatos = true;

      switch (codCuenta1) {
        case "VB":
          ventasBrutas += Math.abs(q.value(0));
          break;
        case "DV":
          devolucionesVentas += Math.abs(q.value(0));
          break;
        case "VE":
          variacionExistencias += Math.abs(q.value(0));
          break;
        case "AP":
          amortizacionesProviciones += Math.abs(q.value(0));
          break;
      }

    }
  }

  // Amortizaciones
  this.iface.datos[registro] = new Array(2);
  this.iface.datos[registro]["codCuenta1"] = "AP";
  this.iface.datos[registro]["descCuenta1"] = "Amortizaciones y provisiones";
  this.iface.datos[registro]["codCuenta2"] = "682.3";
  this.iface.datos[registro]["descCuenta2"] = "Amortizaciones";

  this.iface.datos[registro]["suma"] = 0;
  if (datos682_1)
    this.iface.datos[registro]["suma"] += this.iface.sumas["682.1"]["suma"];
  if (datos682_2)
    this.iface.datos[registro]["suma"] += this.iface.sumas["682.2"]["suma"];
  if (datos682_3)
    this.iface.datos[registro]["suma"] += this.iface.sumas["682.3"]["suma"];
  if (datos681)
    this.iface.datos[registro]["suma"] += this.iface.sumas["681"]["suma"]
                                          if (datos682)
                                            this.iface.datos[registro]["suma"] += this.iface.sumas["682"]["suma"];

  this.iface.datos[registro]["por"] = 0;
  registro++;


  // Cuentas de existencias
  var saldoEx: Number = util.sqlSelect("co_partidas p inner join co_asientos a on p.idasiento=a.idasiento inner join co_subcuentas s on p.idsubcuenta=s.idsubcuenta inner join co_cuentas c on c.idcuenta=s.idcuenta", "sum(p.debe-p.haber)", "a.codejercicio = '" + codEjercicio + "' and a.fecha < '" + fechaDesde + "' and c.codepigrafe = '30'", "co_partidas,co_asientos,co_subcuentas,co_cuentas");

  this.iface.datos[registro] = new Array(2);
  this.iface.datos[registro]["codCuenta1"] = "CM";
  this.iface.datos[registro]["descCuenta1"] = "Consumos";
  this.iface.datos[registro]["codCuenta2"] = "650";
  this.iface.datos[registro]["descCuenta2"] = "Existencia inicial materias primas";
  this.iface.datos[registro]["suma"] = Math.abs(saldoEx);
  this.iface.datos[registro]["por"] = 0;
  registro++;

  saldoEx = util.sqlSelect("co_partidas p inner join co_asientos a on p.idasiento=a.idasiento inner join co_subcuentas s on p.idsubcuenta=s.idsubcuenta inner join co_cuentas c on c.idcuenta=s.idcuenta", "sum(p.debe-p.haber)", "a.codejercicio = '" + codEjercicio + "' and a.fecha <= '" + fechaHasta + "' and c.codepigrafe = '30'", "co_partidas,co_asientos,co_subcuentas,co_cuentas");

  this.iface.datos[registro] = new Array(2);
  this.iface.datos[registro]["codCuenta1"] = "CM";
  this.iface.datos[registro]["descCuenta1"] = "Consumos";
  this.iface.datos[registro]["codCuenta2"] = "651";
  this.iface.datos[registro]["descCuenta2"] = "Existencia final materias primas";
  this.iface.datos[registro]["suma"] = Math.abs(saldoEx);
  this.iface.datos[registro]["por"] = 0;
  registro++;


  util.destroyProgressDialog();

  if (!hayDatos)
  {
    MessageBox.warning(util.translate("scripts", "No hay registros que cumplan los criterios de búsqueda establecidos"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return false;
  }

  var ventasNetas: Number = ventasBrutas - devolucionesVentas;
  var valorProduccion: Number = ventasNetas + variacionExistencias;

  // Cálculo de porcentajes sobre el VP
  for (i = 0; i < this.iface.datos.length; i++)
  {
    codCuenta2 = this.iface.datos[i]["codCuenta2"];
    if (valorProduccion)
      this.iface.datos[i]["por"] = this.iface.datos[i]["suma"] * 100 / valorProduccion;
  }

  this.iface.informarTablaBuff(ejercicio);
  return true;
}

/** \D
Vuelca los datos del Array en la tabla de buffer. La consulta definitiva del informe se hará sobre esta tabla
\end */
function oficial_informarTablaBuff(ejercicio: String): Boolean {
  var cursor: FLSqlCursor = new FLSqlCursor("co_i_cuentaexp_buffer");

  for (var i: Number = 0; i < this.iface.datos.length; i++)
  {

    cursor.select("codcuenta1 = '" + this.iface.datos[i]["codCuenta1"] + "' AND codcuenta2 = '" + this.iface.datos[i]["codCuenta2"] + "'");
    if (!cursor.first()) {
      cursor.setModeAccess(cursor.Insert);
      cursor.refreshBuffer();
      cursor.setValueBuffer("codcuenta1", this.iface.datos[i]["codCuenta1"]);
      cursor.setValueBuffer("desccuenta1", this.iface.datos[i]["descCuenta1"]);
      cursor.setValueBuffer("codcuenta2", this.iface.datos[i]["codCuenta2"]);
      cursor.setValueBuffer("desccuenta2", this.iface.datos[i]["descCuenta2"]);
    } else {
      cursor.setModeAccess(cursor.Edit);
      cursor.refreshBuffer();
    }

    if (ejercicio == "ej1") {
      cursor.setValueBuffer("sumaact", this.iface.datos[i]["suma"]);
      cursor.setValueBuffer("poract", this.iface.datos[i]["por"]);
    } else {
      cursor.setValueBuffer("sumaant", this.iface.datos[i]["suma"]);
      cursor.setValueBuffer("porant", this.iface.datos[i]["por"]);
    }

    cursor.setValueBuffer("sumatot", cursor.valueBuffer("sumaact") + cursor.valueBuffer("sumaant"));
    cursor.setValueBuffer("portot", 0);
    cursor.commitBuffer();
  }

  return true;
}

/** \D Vaciado de la tabla de buffer
*/
function oficial_limpiarTablaBuff(): Boolean {
  var cursor: FLSqlCursor = new FLSqlCursor("co_i_cuentaexp_buffer");

  cursor.select("");
  while (cursor.next())
  {
    with(cursor) {
      setModeAccess(cursor.Del);
      refreshBuffer();
      commitBuffer();
    }
  }

  return true;
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
