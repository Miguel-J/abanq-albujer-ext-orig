/***************************************************************************
                i_masterdiariomes.qs  -  description
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
////////////////////////////////////////////////////////////////////////////
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
  function oficial(context)
  {
    interna(context);
  }
  function lanzar()
  {
    return this.ctx.oficial_lanzar();
  }
  function rellenarDatosBuffer()
  {
    return this.ctx.oficial_rellenarDatosBuffer();
  }
  function cerosDerecha(numero, totalCifras)
  {
    return this.ctx.oficial_cerosDerecha(numero, totalCifras);
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
  var cursor: FLSqlCursor = this.cursor();

  if (!cursor.isValid())
    return;

  var nombreInforme: String = cursor.action();
  var nombreReport: String = nombreInforme;

  if (!this.iface.rellenarDatosBuffer())
    return false;

  var orderBy = "co_i_diariomes_buffer.id";
  flcontinfo.iface.pub_lanzarInforme(cursor, nombreInforme, nombreReport, orderBy, "", "", cursor.valueBuffer("id"));
}

function oficial_rellenarDatosBuffer()
{
  var util = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  var codEjercicio: String =   cursor.valueBuffer("codejercicio");
  var fechaDesde: String =   cursor.valueBuffer("fechadesde");
  var fechaHasta: String =   cursor.valueBuffer("fechahasta");

  var q: FLSqlQuery = new FLSqlQuery();
  q.setTablesList("ejercicios");
  q.setFrom("ejercicios");
  q.setSelect("idasientoapertura,idasientopyg,idasientocierre");
  q.setWhere("codejercicio = '" + codEjercicio + "'");

  if (!q.exec())
    return 0;

  var idApertura = false;
  var idRegularizacion = false;
  var idCierre = false;

  if (!q.first()) {
    MessageBox.warning(util.translate("scripts", "No se ha encontrado el ejercicio establecido."), MessageBox.Ok, MessageBox.NoButton);
    return;
  }

  var noEncontrados = new Array();
  var asientos = "";
  idApertura = q.value("idasientoapertura");
  if (!idApertura) {
    noEncontrados[noEncontrados.length] = "apertura";
  } else {
    asientos += idApertura;
  }
  idRegularizacion = q.value("idasientopyg");
  if (!idRegularizacion) {
    noEncontrados[noEncontrados.length] = "regularización";
  } else {
    if (asientos && asientos != "")
      asientos += ",";
    asientos += idRegularizacion;
  }
  idCierre = q.value("idasientocierre");
  if (!idCierre) {
    noEncontrados[noEncontrados.length] = "cierre";
  } else {
    if (asientos && asientos != "")
      asientos += ",";
    asientos += idCierre;
  }
  mensaje = "";
  switch (noEncontrados.length) {
    case 0: {
      break;
    }
    case 1: {
      mensaje = "No se ha encontrado el asiento de " + noEncontrados[0] + " para el ejercicio establecido.\nSi este asiento existe debe asociarlo al ejercicio para que se muestre en el informe.\n¿Dese continuar mostrando el informe?";
      break;
    }
    case 2: {
      mensaje = "No se han encontrado los asientos de " + noEncontrados[0] + " y " + noEncontrados[1] + " para el ejercicio establecido.\nSi estos asientos existen debe asociarlos al ejercicio para que se muestren en el informe.\n¿Dese continuar mostrando el informe?";
      break;
    }
    case 3: {
      mensaje = "No se han encontrado los asientos de " + noEncontrados[0] + ", " + noEncontrados[1] + " y " + noEncontrados[2] + " para el ejercicio establecido.\nSi estos asientos existen debe asociarlos al ejercicio para que se muestren en el informe.\n¿Dese continuar mostrando el informe?";
      break;
    }
  }

  if (mensaje != "") {
    var res = MessageBox.warning(util.translate("scripts", mensaje), MessageBox.Yes, MessageBox.No);
    if (res != MessageBox.Yes)
      return false;
  }

  flcontinfo.iface.pub_vaciarBuffer("co_i_diariomes_buffer");

  var debe = 0;
  var haber = 0;
  var cuenta = "";
  var curBuffer: FLSqlCursor = new FLSqlCursor("co_i_diariomes_buffer");

  /////////// ASIENTO DE APERTURA /////////////////////////////////////////////////////////
  if (idApertura && idApertura != 0) {
    var q: FLSqlQuery = new FLSqlQuery();
    q.setTablesList("co_partidas,co_subcuentas,co_asientos");
    q.setFrom("co_asientos INNER JOIN co_partidas ON co_asientos.idasiento = co_partidas.idasiento INNER JOIN co_subcuentas ON co_partidas.idsubcuenta = co_subcuentas.idsubcuenta INNER JOIN co_cuentas ON co_subcuentas.idcuenta = co_cuentas.idcuenta");
    q.setSelect("SUM(co_partidas.debe), SUM(co_partidas.haber), co_cuentas.codcuenta, co_cuentas.descripcion");
    q.setWhere("co_partidas.idasiento = " + idApertura + " AND co_asientos.fecha >= '" + fechaDesde + "' AND co_asientos.fecha <= '" + fechaHasta + "' GROUP BY co_cuentas.codcuenta, co_cuentas.descripcion ORDER BY co_cuentas.codcuenta");
    if (!q.exec())
      return;

    while (q.next()) {
      //var cuenta = q.value("co_subcuentas.codsubcuenta").left(4);
      var cuenta = this.iface.cerosDerecha(q.value("co_cuentas.codcuenta"), 4);
      curBuffer.select("cuenta = '" + cuenta + "' AND mes = 'ASIENTO DE APERTURA'");

      saldo = parseFloat(q.value("SUM(co_partidas.debe)")) - parseFloat(q.value("SUM(co_partidas.haber)"));
      if (saldo > 0) {
        debe = saldo;
        haber = 0;
      } else {
        debe = 0;
        haber = saldo * -1;
      }
      if (curBuffer.first()) {
        curBuffer.setModeAccess(curBuffer.Edit);
        curBuffer.refreshBuffer();
        debe += debe;
        haber += haber;
      } else {
        curBuffer.setModeAccess(curBuffer.Insert);
        curBuffer.refreshBuffer();
        curBuffer.setValueBuffer("mes", "ASIENTO DE APERTURA");
        curBuffer.setValueBuffer("cuenta", cuenta);
        curBuffer.setValueBuffer("descripcion", q.value("co_cuentas.descripcion"));
      }

      curBuffer.setValueBuffer("debe", debe);
      curBuffer.setValueBuffer("haber", haber);

      curBuffer.commitBuffer();
    }
  }

  //////////////// MESES ////////////////////////////////////////////////////////////////////////////////////////////////////////
  var meses = ["", "ENERO", "FEBRERO", "MARZO", "ABRIL", "MAYO", "JUNIO", "JULIO", "AGOSTO", "SEPTIEMBRE", "OCTUBRE", "NOVIEMBRE", "DICIEMBRE"];

  var whereAsientos = "";
  if (asientos && asientos != "") {
    whereAsientos = " AND co_asientos.idasiento NOT IN(" + asientos + ")";
  }
  var q: FLSqlQuery = new FLSqlQuery();
  q.setTablesList("co_asientos,co_partidas,co_subcuentas");
  q.setFrom("co_asientos INNER JOIN co_partidas ON co_asientos.idasiento = co_partidas.idasiento INNER JOIN co_subcuentas ON co_partidas.idsubcuenta = co_subcuentas.idsubcuenta  INNER JOIN co_cuentas ON co_subcuentas.idcuenta = co_cuentas.idcuenta");
  q.setSelect("extract(month from co_asientos.fecha),co_asientos.fecha, SUM(co_partidas.debe), SUM(co_partidas.haber), co_cuentas.codcuenta, co_cuentas.descripcion");
  q.setWhere("co_asientos.codejercicio = '" + codEjercicio + "' AND co_asientos.fecha >= '" + fechaDesde + "' AND co_asientos.fecha <= '" + fechaHasta + "'" + whereAsientos + " GROUP BY extract(month from co_asientos.fecha),co_asientos.fecha, co_cuentas.codcuenta, co_cuentas.descripcion ORDER BY extract(month from co_asientos.fecha),co_asientos.fecha,co_cuentas.codcuenta");
  if (!q.exec())
    return;

  var mes = 0;
  var fecha = "";
  while (q.next()) {
    fecha = new Date(Date.parse(q.value("co_asientos.fecha")));
    mes = q.value("extract(month from co_asientos.fecha)");/*fecha.getMonth();*/
    //var cuenta = q.value("co_subcuentas.codsubcuenta").left(4);
    var cuenta = this.iface.cerosDerecha(q.value("co_cuentas.codcuenta"), 4);
    curBuffer.select("cuenta = '" + cuenta + "' AND mes = '" + meses[mes] + "'");

    saldo = parseFloat(q.value("SUM(co_partidas.debe)")) - parseFloat(q.value("SUM(co_partidas.haber)"));
    if (saldo > 0) {
      debe = saldo;
      haber = 0;
    } else {
      debe = 0;
      haber = saldo * -1;
    }
    if (curBuffer.first()) {
      curBuffer.setModeAccess(curBuffer.Edit);
      curBuffer.refreshBuffer();
      debe += debe;
      haber += haber;
    } else {
      curBuffer.setModeAccess(curBuffer.Insert);
      curBuffer.refreshBuffer();
      curBuffer.setValueBuffer("mes", meses[mes]);
      curBuffer.setValueBuffer("cuenta", cuenta);
      curBuffer.setValueBuffer("descripcion", q.value("co_cuentas.descripcion"))
    }

    curBuffer.setValueBuffer("debe", debe);
    curBuffer.setValueBuffer("haber", haber);

    curBuffer.commitBuffer();
  }

  //////////////// ASIENTO DE REGULARIZACIÓN ////////////////////////////////////////////////////////////////////////////
  if (idRegularizacion && idRegularizacion != 0) {
    var q: FLSqlQuery = new FLSqlQuery();
    q.setTablesList("co_partidas,co_subcuentas,co_asientos");
    q.setFrom("co_asientos INNER JOIN co_partidas ON co_asientos.idasiento = co_partidas.idasiento INNER JOIN co_subcuentas ON co_partidas.idsubcuenta = co_subcuentas.idsubcuenta  INNER JOIN co_cuentas ON co_subcuentas.idcuenta = co_cuentas.idcuenta");
    q.setSelect("SUM(co_partidas.debe), SUM(co_partidas.haber), co_cuentas.codcuenta, co_cuentas.descripcion");
    q.setWhere("co_partidas.idasiento = " + idRegularizacion + "  AND co_asientos.fecha >= '" + fechaDesde + "' AND co_asientos.fecha <= '" + fechaHasta + "' GROUP BY co_cuentas.codcuenta, co_cuentas.descripcion ORDER BY co_cuentas.codcuenta");
    if (!q.exec())
      return;

    while (q.next()) {
      var cuenta = this.iface.cerosDerecha(q.value("co_cuentas.codcuenta"), 4);
      curBuffer.select("cuenta = '" + cuenta + "' AND mes = 'ASIENTO DE REGULARIZACIÓN'");

      saldo = parseFloat(q.value("SUM(co_partidas.debe)")) - parseFloat(q.value("SUM(co_partidas.haber)"));
      if (saldo > 0) {
        debe = saldo;
        haber = 0;
      } else {
        debe = 0;
        haber = saldo * -1;
      }
      if (curBuffer.first()) {
        curBuffer.setModeAccess(curBuffer.Edit);
        curBuffer.refreshBuffer();
        debe += debe;
        haber += haber;
      } else {
        curBuffer.setModeAccess(curBuffer.Insert);
        curBuffer.refreshBuffer();
        curBuffer.setValueBuffer("mes", "ASIENTO DE REGULARIZACIÓN");
        curBuffer.setValueBuffer("cuenta", cuenta);
        curBuffer.setValueBuffer("descripcion", q.value("co_cuentas.descripcion"))
      }

      curBuffer.setValueBuffer("debe", debe);
      curBuffer.setValueBuffer("haber", haber);

      curBuffer.commitBuffer();
    }
  }


  //////////////// CIERRE ////////////////////////////////////////////////////////////////////////////////////////////////////////
  if (idCierre && idCierre != 0) {
    var q: FLSqlQuery = new FLSqlQuery();
    q.setTablesList("co_partidas,co_subcuentas,co_asientos");
    q.setFrom("co_asientos INNER JOIN co_partidas ON co_asientos.idasiento = co_partidas.idasiento INNER JOIN co_subcuentas ON co_partidas.idsubcuenta = co_subcuentas.idsubcuenta  INNER JOIN co_cuentas ON co_subcuentas.idcuenta = co_cuentas.idcuenta");
    q.setSelect("SUM(co_partidas.debe), SUM(co_partidas.haber), co_cuentas.codcuenta, co_cuentas.descripcion");
    q.setWhere("co_partidas.idasiento = " + idCierre + "  AND co_asientos.fecha >= '" + fechaDesde + "' AND co_asientos.fecha <= '" + fechaHasta + "' GROUP BY co_cuentas.codcuenta, co_cuentas.descripcion ORDER BY co_cuentas.codcuenta");
    if (!q.exec())
      return;

    while (q.next()) {
      var cuenta = this.iface.cerosDerecha(q.value("co_cuentas.codcuenta"), 4);
      curBuffer.select("cuenta = '" + cuenta + "' AND mes = 'ASIENTO DE CIERRE'");
      saldo = parseFloat(q.value("SUM(co_partidas.debe)")) - parseFloat(q.value("SUM(co_partidas.haber)"));
      if (saldo > 0) {
        debe = saldo;
        haber = 0;
      } else {
        debe = 0;
        haber = saldo * -1;
      }
      if (curBuffer.first()) {
        curBuffer.setModeAccess(curBuffer.Edit);
        curBuffer.refreshBuffer();
        debe += debe;
        haber += haber;
      } else {
        curBuffer.setModeAccess(curBuffer.Insert);
        curBuffer.refreshBuffer();
        curBuffer.setValueBuffer("mes", "ASIENTO DE CIERRE");
        curBuffer.setValueBuffer("cuenta", cuenta);
        curBuffer.setValueBuffer("descripcion", q.value("co_cuentas.descripcion"))
      }

      curBuffer.setValueBuffer("debe", debe);
      curBuffer.setValueBuffer("haber", haber);

      curBuffer.commitBuffer();
    }
  }

  return true;
}

function oficial_cerosDerecha(texto, totalCifras)
{
  var ret = texto.toString();
  var numCeros = totalCifras - ret.length;
  for (; numCeros > 0 ; --numCeros)
    ret += "0";
  return ret;
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
