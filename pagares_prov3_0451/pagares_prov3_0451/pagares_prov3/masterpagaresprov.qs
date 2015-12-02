/***************************************************************************
                 masterpagaresprov.qs  -  description
                             -------------------
    begin                : mie ene 31 2006
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
  var tbnImprimir: Object;
  var tdbRecords: FLTableDB;
  var curPagare: FLSqlCursor;
  var pbnAnularPagare: Object;

  function oficial(context)
  {
    interna(context);
  }
  function imprimir()
  {
    return this.ctx.oficial_imprimir();
  }
  function whereAgrupacion(curAgrupar: FLSqlCursor): String {
    return this.ctx.oficial_whereAgrupacion(curAgrupar);
  }
  function botonAnular()
  {
    return this.ctx.oficial_botonAnular();
  }
  function anularPagare_clicked()
  {
    return this.ctx.oficial_anularPagare_clicked();
  }
  function anularPagare(): Boolean {
    return this.ctx.oficial_anularPagare();
  }
  function quitarPagareAnulado(): Boolean {
    return this.ctx.oficial_quitarPagareAnulado();
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
  function pub_whereAgrupacion(curAgrupar: FLSqlCursor): String {
    return this.whereAgrupacion(curAgrupar);
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
Este es el formulario maestro de facturas a cliente.
\end */
function interna_init()
{
  this.iface.pbnAnularPagare = this.child("pbnAnularPagare");
  this.iface.tbnImprimir = this.child("toolButtonPrint");
  this.iface.tdbRecords = this.child("tableDBRecords");

  connect(this.iface.tbnImprimir, "clicked()", this, "iface.imprimir");
  connect(this.iface.tdbRecords, "currentChanged()", this, "iface.botonAnular()");
  connect(this.iface.pbnAnularPagare, "clicked()", this, "iface.anularPagare_clicked()");
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
/** \C
Al pulsar el botón imprimir se lanzará el informe correspondiente al pagaré seleccionado (en caso de que el módulo de informes esté cargado)
\end */
function oficial_imprimir()
{
  if (sys.isLoadedModule("flfactinfo")) {
    var util: FLUtil = new FLUtil;
    var numero: String = this.cursor().valueBuffer("numero");

    var curImprimir: FLSqlCursor = new FLSqlCursor("i_pagaresprov");
    curImprimir.setModeAccess(curImprimir.Insert);
    curImprimir.refreshBuffer();
    curImprimir.setValueBuffer("descripcion", "temp");
    curImprimir.setValueBuffer("i_pagaresprov_numero", numero);
    flfactinfo.iface.pub_lanzarInforme(curImprimir, "i_pagaresprov");
  } else
    flfactppal.iface.pub_msgNoDisponible("Informes");
}

/** \D
Construye la sentencia WHERE de la consulta que buscará los albaranes a agrupar
@param curAgrupar: Cursor de la tabla agruparrecibosprov que contiene los valores de los criterios de búsqueda
@return Sentencia where
\end */
function oficial_whereAgrupacion(curAgrupar: FLSqlCursor): String {
  var codProveedor: String = curAgrupar.valueBuffer("codproveedor");
  var fechaVDesde: String = curAgrupar.valueBuffer("fechavdesde");
  var fechaVHasta: String = curAgrupar.valueBuffer("fechavhasta");
  var where: String = "estado IN ('Emitido', 'Devuelto')";
  if (codProveedor && codProveedor != "")
    where += " AND codproveedor = '" + codProveedor + "'";
  if (fechaVDesde && fechaVDesde != "")
    where += " AND fechav >= '" + fechaVDesde + "'";
  if (fechaVHasta && fechaVHasta != "")
    where += " AND fechav <= '" + fechaVHasta + "'";

  return where;
}



function oficial_botonAnular()
{
  var cursor: FLSqlCursor = this.cursor();
  var util: FLUtil = new FLUtil();

  if (cursor.valueBuffer("estado") == "Emitido") {
    this.iface.pbnAnularPagare.enabled = true;
    this.iface.pbnAnularPagare.text = "Anular";
  } else if (cursor.valueBuffer("estado") == "Anulado") {
    this.iface.pbnAnularPagare.enabled = true;
    this.iface.pbnAnularPagare.text = "No Anular";
  } else {
    this.iface.pbnAnularPagare.enabled = false;
    this.iface.pbnAnularPagare.text = "--";
  }
}

function oficial_anularPagare_clicked()
{
  var cursor: FLSqlCursor = this.cursor();
  var util: FLUtil = new FLUtil();

  if (cursor.valueBuffer("estado") == "Emitido") {
    var res: Number = MessageBox.information(util.translate("scripts", "Va a anular el pagaré número:%1\n¿Está seguro?").arg(cursor.valueBuffer("numero")), MessageBox.Yes, MessageBox.No);
    if (res != MessageBox.Yes)
      return false;

    cursor.transaction(false);

    try {
      if (!this.iface.anularPagare()) {
        cursor.rollback();
        return false;
      }
      cursor.commit();
    } catch (e) {
      cursor.rollback();
      MessageBox.critical(util.translate("scripts", "Hubo un error al anular el pagaré: ") + e, MessageBox.Ok, MessageBox.NoButton);
    }
    return false;
  }

  if (cursor.valueBuffer("estado") == "Anulado") {
    var res: Number = MessageBox.information(util.translate("scripts", "Va quitar el pagaré número:%1\ncomo anulado. ¿Está seguro?").arg(cursor.valueBuffer("numero")), MessageBox.Yes, MessageBox.No);
    if (res != MessageBox.Yes)
      return false;

    cursor.transaction(false);

    try {
      if (!this.iface.quitarPagareAnulado()) {
        cursor.rollback();
        return false;
      }
      cursor.commit();
    } catch (e) {
      cursor.rollback();
      MessageBox.critical(util.translate("scripts", "Hubo un error al quitar el pagaré como anulado: ") + e, MessageBox.Ok, MessageBox.NoButton);
    }
    return false;
  }
}

function oficial_anularPagare(): Boolean {
  var cursor: FLSqlCursor = this.cursor();

  var qryRecibos: FLSqlCursor = new FLSqlQuery;
  qryRecibos.setTablesList("pagosdevolprov");
  qryRecibos.setSelect("idrecibo");
  qryRecibos.setFrom("pagosdevolprov");
  qryRecibos.setWhere("idpagare = " + cursor.valueBuffer("idpagare"));

  if (!qryRecibos.exec())
    return false;

  var hoy: Date = new Date();
  while (qryRecibos.next())
  {
    var curPago: FLSqlCursor = new FLSqlCursor("pagosdevolprov");
    curPago.setModeAccess(curPago.Insert);
    curPago.refreshBuffer();
    curPago.setValueBuffer("fecha", hoy);
    curPago.setValueBuffer("tipo", "Pag.Anulado");
    curPago.setValueBuffer("idrecibo", qryRecibos.value("idrecibo"));
    curPago.setValueBuffer("idpagare", cursor.valueBuffer("idpagare"));

    if (!curPago.commitBuffer())
      return false;

    var curRecibo: FLSqlCursor = new FLSqlCursor("recibosprov");
    curRecibo.select("idrecibo = " + qryRecibos.value("idrecibo"));
    if (!curRecibo.first())
      return false;
    curRecibo.setModeAccess(curRecibo.Edit);
    curRecibo.refreshBuffer();
    curRecibo.setValueBuffer("estado", "Emitido");
    if (!curRecibo.commitBuffer())
      return false;
  }
  cursor.setModeAccess(cursor.Edit);
  cursor.refreshBuffer();
  cursor.setValueBuffer("estado", "Anulado");
  if (!cursor.commitBuffer())
    return false;

  return true;
}

function oficial_quitarPagareAnulado(): Boolean {
  var cursor: FLSqlCursor = this.cursor();
  var util: FLUtil = new FLUtil();
  var codRecibo: String;

  var qryRecibos: FLSqlCursor = new FLSqlQuery;
  qryRecibos.setTablesList("pagosdevolprov");
  qryRecibos.setSelect("idrecibo");
  qryRecibos.setFrom("pagosdevolprov");
  qryRecibos.setWhere("idpagare = " + cursor.valueBuffer("idpagare") + " AND tipo = 'Pag.Anulado'");

  if (!qryRecibos.exec())
    return false;

  while (qryRecibos.next())
  {
    var idPagoDevol: String = util.sqlSelect("pagosdevolprov", "idpagodevol", "idrecibo = " + qryRecibos.value("idrecibo") + " ORDER BY fecha DESC, idpagodevol DESC");
    if (!idPagoDevol || idPagoDevol == "") {
      codRecibo = util.sqlSelect("recibosprov", "codigo", "idrecibo = " + qryRecibos.value("idrecibo"));
      MessageBox.information(util.translate("scripts", "No hay pagos asociados al recibo %1").arg(codRecibo), MessageBox.Ok, MessageBox.NoButton);
      return false;
    }

    var tipo: String = util.sqlSelect("pagosdevolprov", "tipo", "idpagodevol = " + idPagoDevol);
    if (tipo != "Pag.Anulado") {
      codRecibo = util.sqlSelect("recibosprov", "codigo", "idrecibo = " + qryRecibos.value("idrecibo"));
      MessageBox.information(util.translate("scripts", "No hay pagos del tipo Pag.Anulado asociados al recibo %1").arg(codRecibo), MessageBox.Ok, MessageBox.NoButton);
      return false;
    }
    var curPago: FLSqlCursor = new FLSqlCursor("pagosdevolprov");
    curPago.select("idpagodevol = " + idPagoDevol);
    if (!curPago.first())
      return false;
    curPago.setModeAccess(curPago.Del);
    curPago.refreshBuffer();

    if (!curPago.commitBuffer())
      return false;

    var curRecibo: FLSqlCursor = new FLSqlCursor("recibosprov");
    curRecibo.select("idrecibo = " + qryRecibos.value("idrecibo"));
    if (!curRecibo.first())
      return false;
    curRecibo.setModeAccess(curRecibo.Edit);
    curRecibo.refreshBuffer();
    curRecibo.setValueBuffer("estado", "Pagaré");
    if (!curRecibo.commitBuffer())
      return false;

  }
  cursor.setModeAccess(cursor.Edit);
  cursor.refreshBuffer();
  cursor.setValueBuffer("estado", "Emitido");
  if (!cursor.commitBuffer())
    return false;

  return true;
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
