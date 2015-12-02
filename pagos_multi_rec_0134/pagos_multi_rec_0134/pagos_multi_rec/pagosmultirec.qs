/***************************************************************************
                 pagosmultirec.qs  -  description
                             -------------------
    begin                : lun mar 19 2007
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
  function main()
  {
    this.ctx.interna_main();
  }
  function init()
  {
    this.ctx.interna_init();
  }
  function calculateField(fN: String): String {
    return this.ctx.interna_calculateField(fN);
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
  function agregarRecibo(): Boolean {
    return this.ctx.oficial_agregarRecibo();
  }
  function agregarReciboLista(idRecibo: String): Boolean {
    return this.ctx.oficial_agregarReciboLista(idRecibo);
  }
  function eliminarRecibo(): Boolean {
    return this.ctx.oficial_eliminarRecibo();
  }
  function eliminarReciboLista(idRecibo: String): Boolean {
    return this.ctx.oficial_eliminarReciboLista(idRecibo);
  }
  function pagarRecibo(idRecibo: String, cursor: FLSqlCursor): Boolean {
    return this.ctx.oficial_pagarRecibo(idRecibo, cursor);
  }
  function pagarRecibos(cursor: FLSqlCursor): Boolean {
    return this.ctx.oficial_pagarRecibos(cursor);
  }
  function refrescarTabla()
  {
    return this.ctx.oficial_refrescarTabla();
  }
  function actualizarTotal()
  {
    return this.ctx.oficial_actualizarTotal();
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
function interna_main()
{
  var util: FLUtil = new FLUtil;
  var f: Object = new FLFormSearchDB("pagosmultirec");
  var cursor: FLSqlCursor = f.cursor();

  var idUsuario: String = sys.nameUser();
  cursor.select("idusuario = '" + idUsuario + "'");
  if (!cursor.first())
    cursor.setModeAccess(cursor.Insert);
  else
    cursor.setModeAccess(cursor.Edit);

  f.setMainWidget();

  cursor.refreshBuffer();
  var curTransaccion: FLSqlCursor = new FLSqlCursor("empresa");
  var listaRecibos: String;
  listaRecibos = f.exec("listarecibos");
  if (!listaRecibos)
    return;
  curTransaccion.transaction(false);
  try {
    if (!this.iface.pagarRecibos(cursor)) {
      curTransaccion.rollback();
    } else {
      curTransaccion.commit();
      MessageBox.information(util.translate("scripts", "Se han pagado los recibos seleccionados"), MessageBox.Ok, MessageBox.NoButton);
    }
  } catch (e) {
    curTransaccion.rollback();
    MessageBox.critical(util.translate("scripts", "Ha habido un error al pagar los recibos:\n") + e, MessageBox.Ok, MessageBox.NoButton);
  }
}

function interna_init()
{
  var cursor: FLSqlCursor = this.cursor();

  connect(this.child("tbInsert"), "clicked()", this, "iface.agregarRecibo");
  connect(this.child("tbDelete"), "clicked()", this, "iface.eliminarRecibo");
  this.iface.refrescarTabla();

  var mA = cursor.modeAccess();
  if (mA == cursor.Insert)
    this.child("fdbCodDivisa").setValue(flfactppal.iface.pub_valorDefectoEmpresa("coddivisa"));


}

function interna_calculateField(fN: String): String {
  var util: FLUtil = new FLUtil();
  var cursor = this.cursor();

  var res: String;
  var listaR: String = cursor.valueBuffer("listarecibos");
  switch (fN)
  {
    case "total": {
      if (listaR && listaR != "") {
        res = parseFloat(util.sqlSelect("reciboscli", "SUM(importe)", "idrecibo IN (" + listaR + ")"));
        if (!res || isNaN(res))
          res = 0;
      } else {
        res = 0;
      }
      break;
    }
  }
  return res;
}

//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////

function oficial_agregarRecibo(): Boolean {
  var util: FLUtil = new FLUtil();

  if (!this.cursor().valueBuffer("codcuenta"))
  {
    MessageBox.warning(util.translate("scripts", "Debe indicar una cuenta bancaria"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return;
  }
  var f: Object = new FLFormSearchDB("seleccionreciboscli");
  var cursor: FLSqlCursor = f.cursor();

  cursor.select();
  if (!cursor.first())
    cursor.setModeAccess(cursor.Insert);
  else
    cursor.setModeAccess(cursor.Edit);

  f.setMainWidget();
  cursor.refreshBuffer();
  cursor.setValueBuffer("datos", "");
  cursor.setValueBuffer("filtro", "estado IN ('Emitido', 'Devuelto') ");

  var datos: String = f.exec("datos");
  if (!datos || datos == "")
    return false;
  var recibos: Array = datos.toString().split(",");

  for (var i: Number = 0; i < recibos.length; i++)
  {
    if (!this.iface.agregarReciboLista(recibos[i]))
      return false;
  }

  this.iface.refrescarTabla();
  this.iface.actualizarTotal();
}

function oficial_agregarReciboLista(idRecibo: String): Boolean {
  var cursor: FLSqlCursor = this.cursor();
  var lista: String = cursor.valueBuffer("listarecibos");
  if (!lista || lista == "")
    lista = idRecibo;
  else
    lista += "," + idRecibo;

  cursor.setValueBuffer("listarecibos", lista);

  return true;
}

function oficial_eliminarRecibo()
{
  if (!this.child("tdbRecibos").cursor().isValid())
    return;

  var recibo: String = this.child("tdbRecibos").cursor().valueBuffer("idrecibo");
  if (!this.iface.eliminarReciboLista(recibo))
    return;

  this.iface.refrescarTabla();
  this.iface.actualizarTotal();
}

function oficial_eliminarReciboLista(idRecibo: String): Boolean {
  var cursor: FLSqlCursor = this.cursor();
  var lista: String = cursor.valueBuffer("listarecibos");
  if (!lista || lista == "")
    return true;
  var recibos: Array = lista.split(",");
  var nuevaLista: String = "";
  for (var i: Number = 0; i < recibos.length; i++)
  {
    if (recibos[i] != idRecibo) {
      if (!nuevaLista || nuevaLista == "")
        nuevaLista = recibos[i];
      else
        nuevaLista += "," + recibos[i];
    }
  }
  cursor.setValueBuffer("listarecibos", nuevaLista);
  return true;
}

function oficial_pagarRecibos(cursor: FLSqlCursor): Boolean {
  var util: FLUtil = new FLUtil;
  var lista: String = cursor.valueBuffer("listarecibos");
  if (!lista || lista == "")
    return true;
  var recibos: Array = lista.split(",");

  util.createProgressDialog(util.translate("scripts", "Pagando recibos"), recibos.length);
  util.setProgress(0);

  for (var i: Number = 0; i < recibos.length; i++)
  {
    util.setProgress(i);
    if (!this.iface.pagarRecibo(recibos[i], cursor)) {
      util.destroyProgressDialog();
      return false;
    }
  }

  util.destroyProgressDialog();
  return true;
}

/** \D Asocia un recibo a un pago, marcándolo como Pagado
@param  idRecibo: Identificador del recibo
@param  cursor: Cursor posicionado en el pago
@return true si la asociación se realiza de forma correcta, false en caso contrario
\end */
function oficial_pagarRecibo(idRecibo: String, cursor: FLSqlCursor): Boolean {
  var util: FLUtil = new FLUtil;
  var contintegrada: Boolean = flfactppal.iface.pub_valorDefectoEmpresa("contintegrada");
  var ejercicioActual: String = flfactppal.iface.pub_ejercicioActual();

  if (util.sqlSelect("reciboscli", "coddivisa", "idrecibo = " + idRecibo) != cursor.valueBuffer("coddivisa"))
  {
    MessageBox.warning(util.translate("scripts", "No es posible pagar el recibo %1.\nLa divisa del recibo y la del formulario deben ser la misma.").arg(util.sqlSelect("reciboscli", "codigo", "idrecibo = " + idRecibo)), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }

  var datosCuenta: Array = flfactppal.iface.pub_ejecutarQry("cuentasbanco", "ctaentidad,ctaagencia,cuenta", "codcuenta = '" + cursor.valueBuffer("codcuenta") + "'");
  if (datosCuenta.result != 1)
    return false;

  var dc: String = util.calcularDC(datosCuenta.ctaentidad + datosCuenta.ctaagencia) + util.calcularDC(datosCuenta.cuenta);

  var curRecibos: FLSqlCursor = new FLSqlCursor("reciboscli");
  var idFactura: Number;
  var codCuenta: String = cursor.valueBuffer("codcuenta");

  var fecha: String = cursor.valueBuffer("fecha");
  var curPagosDev: FLSqlCursor = new FLSqlCursor("pagosdevolcli");
  curPagosDev.select("idrecibo = " + idRecibo + " ORDER BY fecha,idpagodevol");
  if (curPagosDev.last())
  {
    if (util.daysTo(curPagosDev.valueBuffer("fecha"), fecha) < 0) {
      var codRecibo: String = util.sqlSelect("reciboscli", "codigo", "idrecibo = " + idRecibo);
      MessageBox.warning(util.translate("scripts", "Existen pagos o devoluciones con fecha igual o posterior a del formulario para el recibo %1").arg(codRecibo), MessageBox.Ok, MessageBox.NoButton);
      return false;
    }
  }

  curRecibos.select("idrecibo = " + idRecibo);
  if (curRecibos.next())
  {
    curRecibos.setActivatedCheckIntegrity(false);
    curRecibos.setModeAccess(curRecibos.Edit);
    curRecibos.refreshBuffer();
    curRecibos.setValueBuffer("estado", "Pagado");
    idFactura = curRecibos.valueBuffer("idfactura");
    curRecibos.commitBuffer();
  }

  if (curPagosDev.last())
  {
    curPagosDev.setUnLock("editable", false);
  }
  curPagosDev.setModeAccess(curPagosDev.Insert);
  curPagosDev.refreshBuffer();
  curPagosDev.setValueBuffer("idrecibo", idRecibo);
  curPagosDev.setValueBuffer("fecha", fecha);
  curPagosDev.setValueBuffer("tipo", "Pago");
  curPagosDev.setValueBuffer("codcuenta", codCuenta);
  curPagosDev.setValueBuffer("ctaentidad", datosCuenta.ctaentidad);
  curPagosDev.setValueBuffer("ctaagencia", datosCuenta.ctaagencia);
  curPagosDev.setValueBuffer("dc", dc);
  curPagosDev.setValueBuffer("cuenta", datosCuenta.cuenta);
  curPagosDev.setValueBuffer("nogenerarasiento", !contintegrada);
  if (contintegrada)
  {
    if (codCuenta && codCuenta != "") {
      var codSubcuenta: String = util.sqlSelect("cuentasbanco", "codsubcuenta", "codcuenta = '" + codCuenta + "'");
      if (!codSubcuenta) {
        MessageBox.warning(util.translate("scripts", "No tiene definida una subcuenta contable para la cuenta %1").arg(codCuenta), MessageBox.Ok, MessageBox.NoButton);
        return false;
      }
      var idSubcuenta: String = util.sqlSelect("co_subcuentas", "idsubcuenta", "codsubcuenta = '" + codSubcuenta + "' AND codejercicio = '" + ejercicioActual + "'");
      if (!idSubcuenta) {
        MessageBox.warning(util.translate("scripts", "No tiene definida la subcuenta %1 en el ejercicio %2").arg(codSubcuenta).arg(codEjercicio), MessageBox.Ok, MessageBox.NoButton);
        return false;
      }
      curPagosDev.setValueBuffer("idsubcuenta", idSubcuenta);
      curPagosDev.setValueBuffer("codsubcuenta", codSubcuenta);
    }
  } else {
    curPagosDev.setNull("idsubcuenta");
    curPagosDev.setNull("codsubcuenta");
  }

  if (!curPagosDev.commitBuffer())
    return false;

  return true;
}

function oficial_actualizarTotal()
{
  this.child("total").setValue(this.iface.calculateField("total"));
  if (this.child("tdbRecibos").cursor().size() > 0) {
    this.child("fdbCodCuenta").setDisabled(true);
    this.child("fdbCodDivisa").setDisabled(true);
    this.child("fdbFecha").setDisabled(true);

  } else {
    this.child("fdbCodCuenta").setDisabled(false);
    this.child("fdbCodDivisa").setDisabled(false);
    this.child("fdbFecha").setDisabled(false);
  }
}

function oficial_refrescarTabla()
{
  var cursor: FLSqlCursor = this.cursor();
  var listaR: String = cursor.valueBuffer("listarecibos");
  if (listaR && listaR != "")
    this.child("tdbRecibos").cursor().setMainFilter("idrecibo IN (" + listaR + ")");
  else
    this.child("tdbRecibos").cursor().setMainFilter("1 = 2");
  this.child("tdbRecibos").refresh();
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
