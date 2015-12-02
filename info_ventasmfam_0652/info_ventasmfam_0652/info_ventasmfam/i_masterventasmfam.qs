/***************************************************************************
                 i_masterventasmensual.qs  -  description
                             -------------------
    begin                : mie jun 7 2006
    copyright            : (C) 2006 by InfoSiAL S.L.
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
  function obtenerOrden(nivel: Number, cursor: FLSqlCursor): String {
    return this.ctx.oficial_obtenerOrden(nivel, cursor);
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
function interna_init()
{
  connect(this.child("toolButtonPrint"), "clicked()", this, "iface.lanzar()");
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////

function oficial_obtenerOrden(nivel: Number, cursor: FLSqlCursor): String {
  var util: FLUtil = new FLUtil();
  var ret: String = "";
  var orden: String = cursor.valueBuffer("orden" + nivel.toString());
  switch (nivel)
  {
    case 1:
      switch (orden) {
        case util.translate("scripts", "Código de familia"):
          ret += "i_ventasmfam_buffer.codfamilia";
          break;
        case util.translate("scripts", "Descripción de familia"):
          ret += "i_ventasmfam_buffer.nombre";
          break;
        case util.translate("scripts", "Volumen de ventas"):
          ret += "sum(ventasfam)";
          break;
      }
      break;
      break;
  }

  if (ret)
  {
    var tipoOrden: String = cursor.valueBuffer("tipoorden" + nivel.toString());
    switch (tipoOrden) {
      case util.translate("scripts", "Descendente"):
        ret += " DESC";
        break;
    }
  }

  return ret;
}

function oficial_lanzar()
{
  var util: FLUtil = new FLUtil();
  var cursor: FLSqlCursor = this.cursor();
  var seleccion: String = cursor.valueBuffer("id");
  if (!seleccion)
    return;

  var codEjercicio = cursor.valueBuffer("codejercicio");
  var familiaDesde = cursor.valueBuffer("familiadesde");
  var familiaHasta = cursor.valueBuffer("familiahasta");
  var codSerie = cursor.valueBuffer("codserie");
  var fechaInicio = cursor.valueBuffer("fechainicio");
  var fechaFin = cursor.valueBuffer("fechafin");
  var iva: Number;

  var preciosConIVA: Boolean = cursor.valueBuffer("preciosconiva");

  var whereEjercicio: String = "";
  if (codEjercicio)
    whereEjercicio = " AND f.codejercicio = '" + codEjercicio + "' ";

  var whereSerie: String = "";
  if (codSerie)
    whereSerie = " AND f.codserie = '" + codSerie + "' ";

  var whereFecha: String = "";
  if (fechaInicio)
    whereFecha += " AND f.fecha >= '" + fechaInicio + "' ";
  if (fechaFin)
    whereFecha += " AND f.fecha <= '" + fechaFin + "' ";

  var whereFamilia: String = "";
  if (familiaDesde)
    whereFamilia += " AND fm.codfamilia >= '" + familiaDesde + "' ";
  if (familiaHasta)
    whereFamilia += " AND fm.codfamilia <= '" + familiaHasta + "' ";

  var q: FLSqlQuery = new FLSqlQuery;
  q.setTablesList("familias,articulos,facturascli,lineasfacturascli");
  q.setSelect("fm.codfamilia,fm.descripcion,f.fecha,l.iva,l.pvptotal,l.codimpuesto");
  q.setFrom("familias fm inner join articulos a on fm.codfamilia = a.codfamilia inner join lineasfacturascli l on a.referencia=l.referencia inner join facturascli f on l.idfactura = f.idfactura");
  q.setWhere("1=1 " + whereFecha + whereFamilia + whereEjercicio + whereSerie);

  var contenido: Number = 0;
  var partesFecha: Array, fecha: String, codFamilia: String, nomFamilia: String, ventas: Number;
  var curTab: FLSqlCursor = new FLSqlCursor("i_ventasmfam_buffer");
  var paso: Number = 0;

  // Vaciar la tabla
  util.sqlDelete("i_ventasmfam_buffer", "1=1");

  paso = 0;

  debug(q.sql())

  if (!q.exec()) {
    MessageBox.critical(util.translate("scripts", "Falló la consulta"),
                        MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return;
  }

  util.createProgressDialog(util.translate("scripts", "Recabando datos de ventas..."), q.size());

  while (q.next()) {

    util.setProgress(paso++);

    codFamilia = q.value("fm.codfamilia");
    partesFecha = q.value("f.fecha").toString().split("-");
    mes = partesFecha[1];
    nomFamilia = q.value("fm.descripcion");

    iva = 0;
    if (preciosConIVA) {
      iva = util.sqlSelect("impuestos", "iva", "codimpuesto = '" + q.value("l.codimpuesto") + "'");
      iva = iva ? iva : 0;
    }

    ventas = parseFloat(q.value("l.pvptotal")) * (100 + iva) / 100;

    debug(mes + " - " + codFamilia + " - " + ventas);
    util.setLabelText(util.translate("scripts", "Recabando datos de ventas\nFamilia ") + codFamilia);

    curTab.setModeAccess(curTab.Insert);
    curTab.refreshBuffer();
    curTab.setValueBuffer("codfamilia", codFamilia);
    curTab.setValueBuffer("nombre", nomFamilia);
    curTab.setValueBuffer("ventas" + mes, ventas);
    curTab.setValueBuffer("ventasfam", ventas);
    curTab.commitBuffer();
  }

  util.destroyProgressDialog();

  if (paso == 0) {
    MessageBox.warning(util.translate("scripts",
                                      "No hay registros que cumplan los criterios de búsqueda establecidos"),
                       MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return;
  }

  var nombreInforme: String = cursor.action();

  var orderBy: String = "";
  var o: String = "";
  o = this.iface.obtenerOrden(1, cursor);
  if (o) {
    if (orderBy == "")
      orderBy = o;
    else
      orderBy += ", " + o;
  }

  flfactinfo.iface.pub_lanzarInforme(cursor, nombreInforme, orderBy, "codfamilia,i_ventasmfam_buffer.nombre,empresa.nombre,i_ventasmfam.fechainicio,i_ventasmfam.fechafin,i_ventasmfam.codejercicio,i_ventasmfam.familiadesde,i_ventasmfam.familiahasta,i_ventasmfam.codserie", false, false, "i_ventasmfam.id = " + seleccion);

  util.sqlDelete("i_ventasmfam_buffer", "1=1");
}


//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
