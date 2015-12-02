/***************************************************************************
                 bloqfacturascli.qs  -  description
                             -------------------
    begin                : vie ago 31 2007
    copyright            : (C) 2007 by InfoSiAL S.L.
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
  var curFactura_: FLSqlCursor;
  var tbInsert: Object;
  var tbDelete: Object;
  var tbInsertTodas: Object;
  var tbDeleteTodas: Object;
  var tbnFiltrarTabla: Object;

  function oficial(context)
  {
    interna(context);
  }
  function insertar(codFactura: String): Boolean {
    return this.ctx.oficial_insertar(codFactura);
  }
  function quitar(codFactura: String): Boolean {
    return this.ctx.oficial_quitar(codFactura);
  }
  function quitarTodas()
  {
    return this.ctx.oficial_quitarTodas();
  }
  function insertarTodas()
  {
    return this.ctx.oficial_insertarTodas();
  }
  function filtrarTabla()
  {
    return this.ctx.oficial_filtrarTabla();
  }
  function establecerFiltro(): String {
    return this.ctx.oficial_establecerFiltro();
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
  this.iface.tbInsert = this.child("tbInsert");
  this.iface.tbDelete = this.child("tbDelete");
  this.iface.tbInsertTodas = this.child("tbInsertTodas");
  this.iface.tbDeleteTodas = this.child("tbDeleteTodas");
  this.iface.tbnFiltrarTabla = this.child("tbnFiltrarTabla");

  connect(this.iface.tbInsert, "clicked()", this, "iface.insertar()");
  connect(this.iface.tbDelete, "clicked()", this, "iface.quitar()");
  connect(this.iface.tbInsertTodas, "clicked()", this, "iface.insertarTodas()");
  connect(this.iface.tbDeleteTodas, "clicked()", this, "iface.quitarTodas()");
  connect(this.iface.tbnFiltrarTabla, "clicked()", this, "iface.filtrarTabla()");

  this.child("tdbTodasFacturas").cursor().setMainFilter("codigo NOT IN (SELECT codfactura FROM facturasbloqueadas WHERE 1 = 1)");

  if (this.cursor().modeAccess() == this.cursor().Edit)
    this.iface.filtrarTabla();
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_insertar(codFactura: String): Boolean {
  var util: FLUtil;

  if (this.cursor().modeAccess() == this.cursor().Insert)
  {
    if (!this.child("tdbFacturasBloqueadas").cursor().commitBufferCursorRelation())
      return false;
  }

  if (!codFactura || codFactura == "")
    codFactura = this.child("tdbTodasFacturas").cursor().valueBuffer("codigo");

  if (!codFactura || codFactura == "")
  {
    MessageBox.information(util.translate("scripts", "No hay ningún registro seleccionado"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }

  var idgrupo: Number = this.cursor().valueBuffer("idgrupo");

  if (!idgrupo || idgrupo == 0)
    return false;

  if (util.sqlSelect("facturasbloqueadas", "id", "codfactura = '" + codFactura + "'"))
    return false;

  var curFacturasBloqueadas: FLSqlCursor = new FLSqlCursor("facturasbloqueadas");
  curFacturasBloqueadas.setModeAccess(curFacturasBloqueadas.Insert);
  curFacturasBloqueadas.refreshBuffer();
  curFacturasBloqueadas.setValueBuffer("idgrupo", idgrupo);
  curFacturasBloqueadas.setValueBuffer("codfactura", codFactura);
  if (!curFacturasBloqueadas.commitBuffer())
    return false;

  this.child("tdbTodasFacturas").refresh();
  this.child("tdbFacturasBloqueadas").refresh();
}

function oficial_quitar(codFactura: String): Boolean {
  var util: FLUtil;

  if (this.cursor().modeAccess() == this.cursor().Insert)
    return false;

  var idgrupo: Number = this.cursor().valueBuffer("idgrupo");

  if (!idgrupo || idgrupo == 0)
    return false;

  if (!codFactura || codFactura == "")
    codFactura = this.child("tdbFacturasBloqueadas").cursor().valueBuffer("codigo");

  if (!codFactura || codFactura == "")
  {
    MessageBox.information(util.translate("scripts", "No hay ningún registro seleccionado"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }

  if (!util.sqlDelete("facturasbloqueadas", "idgrupo = " + idgrupo + " AND codfactura = '" + codFactura + "'"))
  {
    MessageBox.warning(util.translate("scripts", "Hubo un error al eliminar la factura de la lista"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }

  this.child("tdbTodasFacturas").refresh();
  this.child("tdbFacturasBloqueadas").refresh();
}

function oficial_establecerFiltro(): String {
  var filtro: String = "";

  var desdeFactura: String = this.child("fdbDesdeFactura").value();
  var hastaFactura: String = this.child("fdbHastaFactura").value();
  var desdeFecha: String = this.child("fdbDesdeFecha").value();
  var hastaFecha: String = this.child("fdbHastaFecha").value();
  var conSerie: String = this.child("fdbConSerie").value();

  if (desdeFactura && desdeFactura != "")
    filtro += " AND facturascli.codigo >= '" + desdeFactura + "'";

  if (hastaFactura && hastaFactura != "")
    filtro += " AND facturascli.codigo <= '" + hastaFactura + "'";

  if (desdeFecha && desdeFecha != "")
    filtro += " AND facturascli.fecha >= '" + desdeFecha + "'";

  if (hastaFecha && hastaFecha != "")
    filtro += " AND facturascli.fecha <= '" + hastaFecha + "'";

  if (conSerie && conSerie != "")
    filtro += " AND facturascli.codserie = '" + conSerie + "'";

  return filtro;
}

function oficial_filtrarTabla()
{
  var filtro: String = this.iface.establecerFiltro();

  this.child("tdbTodasFacturas").cursor().setMainFilter("codigo NOT IN (SELECT codfactura FROM facturasbloqueadas WHERE 1 = 1)" + filtro);

  this.child("tdbTodasFacturas").refresh();
}

function oficial_insertarTodas()
{
  var util: FLUtil = new FLUtil();
  var curTF: FLSqlCursor = this.child("tdbTodasFacturas").cursor();
  var curFacturasBloqueadas: FLSqlCursor = new FLSqlCursor("facturasbloqueadas");

  var idgrupo: Number = this.cursor().valueBuffer("idgrupo");

  curTF.select();
  var numF: Number = curTF.size();

  if (numF > 500 && !this.iface.establecerFiltro()) {
    res = MessageBox.information(util.translate("scripts", "Se dispone a agregar más de 500 facturas\n y no ha establecido criterios de selección.\n\nEste proceso durar unos minutos.\n¿Desea continuar?"), MessageBox.Yes, MessageBox.No);
    if (res != MessageBox.Yes)
      return;
  }



  util.createProgressDialog(util.translate("scripts", "Insertando facturas..."), curTF.size());
  var paso: Number = 0;

  while (curTF.next()) {

    curFacturasBloqueadas.setModeAccess(curFacturasBloqueadas.Insert);
    curFacturasBloqueadas.refreshBuffer();
    curFacturasBloqueadas.setValueBuffer("idgrupo", idgrupo);
    curFacturasBloqueadas.setValueBuffer("codfactura", curTF.valueBuffer("codigo"));
    if (!curFacturasBloqueadas.commitBuffer())
      return false;

    util.setProgress(paso++);
  }

  util.destroyProgressDialog();
  this.child("tdbFacturasBloqueadas").refresh();
}

function oficial_quitarTodas()
{
  var util: FLUtil = new FLUtil();

  res = MessageBox.information(util.translate("scripts", "Se dispone a quitar todas las facturas\n\n¿Desea continuar?"), MessageBox.Yes, MessageBox.No);
  if (res != MessageBox.Yes)
    return;

  var idgrupo: Number = this.cursor().valueBuffer("idgrupo");

  util.sqlDelete("facturasbloqueadas", "idgrupo = " + idgrupo);

  this.child("tdbTodasFacturas").refresh();
  this.child("tdbFacturasBloqueadas").refresh();
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
