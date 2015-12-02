/**************************************************************************
                 seleccionchequescli.qs  -  description
                             -------------------
    begin                : mar feb 21 2006
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
  var tdbCheques: Object;
  var tdbChequesSel: Object;

  function oficial(context)
  {
    interna(context);
  }
  function seleccionar()
  {
    return this.ctx.oficial_seleccionar();
  }
  function quitar()
  {
    return this.ctx.oficial_quitar();
  }
  function refrescarTablas()
  {
    return this.ctx.oficial_refrescarTablas();
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
/** \C
Este formulario muestra una lista de cheques de cliente que cumplen un determinado filtro, y permite al usuario seleccionar uno o más cheques de la lista
\end */
function interna_init()
{
  this.iface.tdbCheques = this.child("tdbCheques");
  this.iface.tdbChequesSel = this.child("tdbChequesSel");

  this.iface.tdbCheques.setReadOnly(true);
  this.iface.tdbChequesSel.setReadOnly(true);

  var columnas: Array;
  columnas[0] = "numerocheque";
  columnas[1] = "entidadcheque";
  columnas[2] = "fechavtocheque";

  this.iface.tdbCheques.setOrderCols(columnas);
  this.iface.tdbChequesSel.setOrderCols(columnas);

  var filtro: String = this.cursor().valueBuffer("filtro");
  var importeDesde: Number = this.cursor().valueBuffer("importedesde");
  var importeHasta: Number = this.cursor().valueBuffer("importehasta");

  // Excluir los que quedan fuera del rango de importes
  if (importeDesde || importeHasta) {

    var filtroImportes: String;
    if (importeDesde)
      filtroImportes += " AND r.importe >= " + importeDesde;
    if (importeHasta)
      filtroImportes += " AND r.importe <= " + importeHasta;

    var q: FLSqlQuery = new FLSqlQuery;
    q.setTablesList("reciboscli,pagosdevolcli");
    q.setSelect("pd.idpagodevol")
    q.setFrom("reciboscli r INNER JOIN pagosdevolcli pd ON r.idrecibo = pd.idrecibo")
    q.setWhere(filtro + filtroImportes);

    debug(q.sql());

    q.exec();

    filtroImportes = "";
    var paso: Number = 0;
    while (q.next()) {
      if (paso++ == 0)
        filtroImportes += "idpagodevol IN (";
      else
        filtroImportes += ",";
      filtroImportes += q.value(0);
    }

    if (filtroImportes)
      filtro = filtroImportes + ")";
    else
      filtro = "1=2";
  }

  this.cursor().setValueBuffer("filtro", filtro)

  this.iface.tdbCheques.cursor().setMainFilter(filtro);
  this.iface.tdbChequesSel.cursor().setMainFilter(filtro);

  this.iface.refrescarTablas();

  connect(this.iface.tdbCheques.cursor(), "recordChoosed()", this, "iface.seleccionar()");
  connect(this.iface.tdbChequesSel.cursor(), "recordChoosed()", this, "iface.quitar()");
  connect(this.child("pbnSeleccionar"), "clicked()", this, "iface.seleccionar()");
  connect(this.child("pbnQuitar"), "clicked()", this, "iface.quitar()");
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
/** \D Refresca las tablas, en función del filtro y de los datos seleccionados hasta el momento
*/
function oficial_refrescarTablas()
{
  var datos: String = this.cursor().valueBuffer("datos");
  var filtro: String = this.cursor().valueBuffer("filtro");
  if (filtro && filtro != "")
    filtro += " AND ";

  if (!datos || datos == "") {
    this.iface.tdbCheques.cursor().setMainFilter(filtro + "1 = 1");
    this.iface.tdbChequesSel.cursor().setMainFilter(filtro + "1 = 2");
  } else {
    this.iface.tdbCheques.cursor().setMainFilter(filtro + "idpagodevol NOT IN (" + datos + ")");
    this.iface.tdbChequesSel.cursor().setMainFilter(filtro + "idpagodevol IN (" + datos + ")");
  }
  this.iface.tdbCheques.refresh();
  this.iface.tdbChequesSel.refresh();
}

/** \D Incluye un cheque en la lista de datos
*/
function oficial_seleccionar()
{
  var cursor: FLSqlCursor = this.cursor();
  var datos: String = cursor.valueBuffer("datos");
  var idPago: String = this.iface.tdbCheques.cursor().valueBuffer("idpagodevol");
  if (!idPago)
    return;
  if (!datos || datos == "")
    datos = idPago;
  else
    datos += "," + idPago;

  cursor.setValueBuffer("datos", datos);

  this.iface.refrescarTablas();
}

/** \D Quita un cheque de la lista de datos
*/
function oficial_quitar()
{
  var cursor: FLSqlCursor = this.cursor();
  var datos: String = cursor.valueBuffer("datos");
  var idPago: String = this.iface.tdbChequesSel.cursor().valueBuffer("idpagodevol");
  if (!idPago)
    return;

  if (!datos)
    return;

  var cheques: Array = datos.split(",");
  var datosNuevos: String = "";
  for (var i: Number = 0; i < cheques.length; i++) {
    if (cheques[i] != idPago) {
      if (datosNuevos == "")
        datosNuevos = cheques[i];
      else
        datosNuevos += "," + cheques[i];
    }
  }
  cursor.setValueBuffer("datos", datosNuevos);
  this.iface.refrescarTablas();
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
