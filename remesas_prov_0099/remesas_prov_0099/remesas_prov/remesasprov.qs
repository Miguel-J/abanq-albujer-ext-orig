/***************************************************************************
                      remesasprov.qs  -  description
                             -------------------
    begin                : jue dic 21 2006
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
  function validateForm()
  {
    return this.ctx.interna_validateForm();
  }
  function calculateField(fN: String)
  {
    return this.ctx.interna_calculateField(fN);
  }
  function calculateCounter()
  {
    return this.ctx.interna_calculateCounter();
  }
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna
{
  var ejercicioActual: String;
  var bloqueoSubcuenta: Boolean;
  var contabActivada: Boolean;
  var longSubcuenta: Number;
  var posActualPuntoSubcuenta: Number;
  var tblResAsientos: QTable;
  var curPagosDev: FLSqlCursor;
  var pagoIndirecto_: Boolean;
  var pagoDiferido_;
  function oficial(context)
  {
    interna(context);
  }
  function actualizarTotal()
  {
    return this.ctx.oficial_actualizarTotal();
  }
  function agregarRecibo()
  {
    return this.ctx.oficial_agregarRecibo();
  }
  function eliminarRecibo()
  {
    return this.ctx.oficial_eliminarRecibo();
  }
  function bufferChanged(fN: String)
  {
    return this.ctx.oficial_bufferChanged(fN);
  }
  function asientoAcumulado()
  {
    return this.ctx.oficial_asientoAcumulado();
  }
  function asociarReciboRemesa(idRecibo: String, curRemesa: FLSqlCursor)
  {
    return this.ctx.oficial_asociarReciboRemesa(idRecibo, curRemesa);
  }
  function excluirReciboRemesa(idRecibo: String, idRemesa: String)
  {
    return this.ctx.oficial_excluirReciboRemesa(idRecibo, idRemesa);
  }
  function datosPagosDev(idRecibo: String, curRemesa: FLSqlCursor)
  {
    return this.ctx.oficial_datosPagosDev(idRecibo, curRemesa);
  }
  function cambiarEstado()
  {
    return this.ctx.oficial_cambiarEstado();
  }
  function dameFiltroRecibos()
  {
    return this.ctx.oficial_dameFiltroRecibos();
  }
  function tbnPagarRecibo_clicked()
  {
    return this.ctx.oficial_tbnPagarRecibo_clicked();
  }
  function pagarRecibo(idRemesa, estado, datosPago)
  {
    return this.ctx.oficial_pagarRecibo(idRemesa, estado, datosPago);
  }
  function validaReciboEnRemesa(curRecibo)
  {
    return this.ctx.oficial_validaReciboEnRemesa(curRecibo);
  }
  function commonCalculateField(fN, cursor)
  {
    return this.ctx.oficial_commonCalculateField(fN, cursor);
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
  function pub_asociarReciboRemesa(idRecibo: String, curRemesa: FLSqlCursor)
  {
    return this.asociarReciboRemesa(idRecibo, curRemesa);
  }
  function pub_excluirReciboRemesa(idRecibo: String, idRemesa: String)
  {
    return this.excluirReciboRemesa(idRecibo, idRemesa);
  }
  function pub_commonCalculateField(fN, cursor)
  {
    return this.commonCalculateField(fN, cursor);
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
/** \C Los campos de contabilidad sólo aparecen cuando se trabaja con contabilidad integrada
\end */
function interna_init()
{
  var _i = this.iface;
  var cursor = this.cursor();
  var util = new FLUtil;

  this.iface.contabActivada = sys.isLoadedModule("flcontppal") && util.sqlSelect("empresa", "contintegrada", "1 = 1");
  if (this.iface.contabActivada) {
    this.iface.tblResAsientos = this.child("tblResAsientos");
    this.iface.tblResAsientos.setNumCols(4);
    this.iface.tblResAsientos.setColumnWidth(0, 100);
    this.iface.tblResAsientos.setColumnWidth(1, 200);
    this.iface.tblResAsientos.setColumnWidth(2, 100);
    this.iface.tblResAsientos.setColumnWidth(3, 100);
    this.iface.tblResAsientos.setColumnLabels("/", util.translate("scripts", "Subcuenta") + "/" + util.translate("scripts", "Descripción") + "/" +  util.translate("scripts", "Debe") + "/" + util.translate("scripts", "Haber"));
    this.iface.tblResAsientos.readOnly = true;

    this.iface.ejercicioActual = flfactppal.iface.pub_ejercicioActual();
    this.iface.longSubcuenta = util.sqlSelect("ejercicios", "longsubcuenta", "codejercicio = '" + this.iface.ejercicioActual + "'");
    this.child("fdbIdSubcuenta").setFilter("codejercicio = '" + this.iface.ejercicioActual + "'");
    this.iface.posActualPuntoSubcuenta = -1;
    this.child("lblResAsientos").text = util.translate("scripts", "Existe un asiento por pago o devolución de recibo. A continuación se muestra un acumulado de las partidas de todos los asientos asociados a los recibos de la remesa.");
    this.iface.pagoIndirecto_ = util.sqlSelect("factteso_general", "pagoindirectoprov", "1 = 1");
    _i.pagoDiferido_ = flfactteso.iface.pub_valorDefectoTesoreria("pagodiferidoprov");
    if (!_i.pagoDiferido_) {
      this.child("tbwRecibos").setTabEnabled("pagos", false);
    }
  } else {
    this.child("tbwRemesa").setTabEnabled("contabilidad", false);
    this.child("tbwRecibos").setTabEnabled("pagos", false);
    this.iface.pagoIndirecto_ = false;
    _i.pagoDiferido_ = false;
  }
  this.child("tbnPagarRecibo").enabled = (_i.pagoDiferido_ && !_i.pagoIndirecto_);

  connect(this.child("tbInsert"), "clicked()", this, "iface.agregarRecibo");
  connect(this.child("tbDelete"), "clicked()", this, "iface.eliminarRecibo");
  connect(this.child("tbnPagarRecibo"), "clicked()", _i, "tbnPagarRecibo_clicked");
  connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");
  connect(this.child("tdbPagosDevolRemProv").cursor(), "bufferCommited()", this, "iface.cambiarEstado");
  this.iface.bufferChanged("estado");

  /** \D Se muestran sólo los recibos de la remesa
  \end */
  var tdbRecibos = this.child("tdbRecibos");
  tdbRecibos.cursor().setMainFilter("idremesa = " + cursor.valueBuffer("idremesa"));

  /** \C La tabla de recibos se muestra en modo de sólo lectura
  \end */
  tdbRecibos.setReadOnly(true);
  var mA = cursor.modeAccess();
  if (mA == cursor.Insert)
    this.child("fdbCodDivisa").setValue(flfactppal.iface.pub_valorDefectoEmpresa("coddivisa"));

  tdbRecibos.cursor().setMainFilter("idrecibo IN (SELECT idrecibo FROM pagosdevolprov WHERE idremesa = " + cursor.valueBuffer("idremesa") + ")");
  tdbRecibos.refresh();
  this.iface.actualizarTotal();
}

function interna_validateForm()
{
  var util = new FLUtil;
  var cursor = this.cursor();

  /** \C La remesa debe tener al menos un recibo
  \end */
  if (this.child("tdbRecibos").cursor().size() == 0) {
    MessageBox.warning(util.translate("scripts", "La remesa debe tener al menos un recibo."), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return false;
  }

  return true;
}

function interna_calculateField(fN)
{
  var _i = this.iface;
  var cursor = this.cursor();

  var res = _i.commonCalculateField(fN, cursor);
  return res;
}

/** \D Calcula un nuevo código de remesa
\end */
function interna_calculateCounter()
{
  var util = new FLUtil();
  var cadena = util.sqlSelect("remesasprov", "idremesa", "1 = 1 ORDER BY idremesa DESC");
  var valor: Number;
  if (!cadena)
    valor = 1;
  else
    valor = parseFloat(cadena) + 1;

  return valor;
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_actualizarTotal()
{
  this.child("total").setValue(this.iface.calculateField("total"));

  var cursor = this.cursor();
  var _i = this.iface;
  var hayRecibos = this.child("tdbRecibos").cursor().size() > 0;
  if (_i.pagoDiferido_ && !_i.pagoIndirecto_) {
    /// Al no generarse asiento por recibo podemos mantener la cuenta habilitada hasta que la remesa se pague.
    this.child("fdbCodCuenta").setDisabled(cursor.valueBuffer("estado") != "Emitida");
    this.child("fdbCodSubcuenta").setDisabled(cursor.valueBuffer("estado") != "Emitida");
  } else {
    this.child("fdbCodCuenta").setDisabled(hayRecibos);
    this.child("fdbCodSubcuenta").setDisabled(hayRecibos);
  }
  this.child("fdbCodDivisa").setDisabled(hayRecibos);
  this.child("fdbFecha").setDisabled(hayRecibos);
  this.child("gbxContabilidad").setEnabled(hayRecibos);

  if (_i.contabActivada)
    _i.asientoAcumulado();

  //  if (this.child("tdbRecibos").cursor().size() > 0) {
  //    this.child("fdbCodCuenta").setDisabled(true);
  //    this.child("fdbCodDivisa").setDisabled(true);
  //    this.child("fdbFecha").setDisabled(true);
  //    this.child("gbxContabilidad").setEnabled(false);
  //
  //  } else {
  //    this.child("fdbCodCuenta").setDisabled(false);
  //    this.child("fdbCodDivisa").setDisabled(false);
  //    this.child("fdbFecha").setDisabled(false);
  //    this.child("gbxContabilidad").setEnabled(true);
  //  }
  //  if (this.iface.contabActivada)
  //    this.iface.asientoAcumulado();

}

/** \D Se agrega un recibo a la remesa. Si la contabilidad está integrada se comprueba que se ha seleccionado una subcuenta
\end */
function oficial_agregarRecibo()
{
  var util = new FLUtil();

  if (!this.cursor().valueBuffer("codcuenta")) {
    MessageBox.warning(util.translate("scripts", "Debe indicar una cuenta bancaria"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return;
  }

  if (sys.isLoadedModule("flcontppal") && util.sqlSelect("empresa", "contintegrada", "1 = 1") && !this.cursor().valueBuffer("nogenerarasiento") && !this.cursor().valueBuffer("codsubcuenta")) {
    MessageBox.warning(util.translate("scripts", "Debe indicar una subcuenta contable"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return;
  }

  var cursor = this.cursor();
  var f = new FLFormSearchDB("seleccionrecibosprov");
  var curRecibos = f.cursor();
  var fecha = cursor.valueBuffer("fecha");

  var noGenerarAsiento = cursor.valueBuffer("nogenerarasiento");

  if (cursor.modeAccess() != cursor.Browse)
    if (!cursor.checkIntegrity())
      return;

  if (this.iface.contabActivada && this.child("fdbCodSubcuenta").value().isEmpty()) {
    if (cursor.valueBuffer("nogenerarasiento") == false) {
      MessageBox.warning(util.translate("scripts", "Debe seleccionar una subcuenta a la que asignar el asiento de pago o devolución"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
      return false;
    }
  }

  curRecibos.select();
  if (!curRecibos.first())
    curRecibos.setModeAccess(curRecibos.Insert);
  else
    curRecibos.setModeAccess(curRecibos.Edit);

  f.setMainWidget();
  curRecibos.refreshBuffer();
  curRecibos.setValueBuffer("datos", "");
  curRecibos.setValueBuffer("filtro", this.iface.dameFiltroRecibos());

  var datos = f.exec("datos");
  if (!datos || datos == "")
    return false;
  var recibos = datos.toString().split(",");
  var cur = new FLSqlCursor("empresa");
  for (var i = 0; i < recibos.length; i++) {
    cur.transaction(false);
    try {
      if (this.iface.asociarReciboRemesa(recibos[i], cursor)) {
        cur.commit();
      } else {
        cur.rollback();
        var codRecibo = util.sqlSelect("recibosprov", "codigo", "idrecibo = " + recibos[i]);
        MessageBox.warning(util.translate("scripts", "Hubo un error en la asociación del recibo %1 a la remesa").arg(codRecibo), MessageBox.Ok, MessageBox.NoButton);
      }
    } catch (e) {
      cur.rollback();
      MessageBox.critical(util.translate("scripts", "Hubo un error en la asociación del recibo a la remesa:") + "\n" + e, MessageBox.Ok, MessageBox.NoButton);
    }
  }
  this.child("tdbRecibos").refresh();
  this.iface.actualizarTotal();
}

/** \D Se elimina el recibo activo de la remesa. El pago asociado a la remesa debe ser el último asignado al recibo
\end */
function oficial_eliminarRecibo()
{
  var util = new FLUtil;
  if (!this.child("tdbRecibos").cursor().isValid()) {
    return;
  }

  var recibo = this.child("tdbRecibos").cursor().valueBuffer("idrecibo");
  var cur = new FLSqlCursor("empresa");
  cur.transaction(false);
  try {
    if (this.iface.excluirReciboRemesa(recibo, this.cursor().valueBuffer("idremesa"))) {
      cur.commit();
    } else {
      cur.rollback();
      var codRecibo = util.sqlSelect("recibosprov", "codigo", "idrecibo = " + recibo);
      MessageBox.warning(util.translate("scripts", "Hubo un error en la exclusión del recibo %1").arg(codRecibo), MessageBox.Ok, MessageBox.NoButton);
    }
  } catch (e) {
    cur.rollback();
    MessageBox.critical(util.translate("scripts", "Hubo un error en la exlusión del recibo:") + "\n" + e, MessageBox.Ok, MessageBox.NoButton);
  }

  this.child("tdbRecibos").refresh();
  this.iface.actualizarTotal();
}

function oficial_excluirReciboRemesa(idRecibo: String, idRemesa: String)
{
  var util = new FLUtil;

  /*
  var cuentaValida= util.sqlSelect("recibosprov r LEFT OUTER JOIN cuentasbcocli c ON r.codcliente = c.codcliente", "r.idrecibo", "idrecibo = " + idRecibo + " AND (r.codcuenta = c.codcuenta OR r.codcuenta = '' OR r.codcuenta IS NULL)", "reciboscli,cuentasbcocli");
  if (!cuentaValida) {
    var codRecibo= util.sqlSelect("reciboscli", "codigo", "idrecibo = " + idRecibo);
    MessageBox.warning(util.translate("scripts", "La cuenta bancaria del recibo %1 no es una cuenta válida del cliente.\nCambie o borre la cuenta antes de excluir el recibo de la remesa.").arg(codRecibo), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  */

  var idUltimaRemesa = util.sqlSelect("pagosdevolprov", "idremesa", "idrecibo = " + idRecibo + " ORDER BY fecha DESC, idpagodevol DESC")
  if (idUltimaRemesa != idRemesa) {
    var codRecibo = util.sqlSelect("recibosprov", "codigo", "idrecibo = " + idRecibo);
    MessageBox.warning(util.translate("scripts", "Para excluir el recibo %1 de la remesa debe eliminar antes la devolución que se produjo posteriormente").arg(codRecibo), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }

  var curRecibos = new FLSqlCursor("recibosprov");
  var curPagosDev = new FLSqlCursor("pagosdevolprov");
  var curFactura = new FLSqlCursor("facturasprov");
  var idfactura: Number;
  curRecibos.select("idrecibo = " + idRecibo);

  if (!curRecibos.first())
    return false;
  curRecibos.setModeAccess(curRecibos.Edit);
  curRecibos.refreshBuffer();
  idfactura = curRecibos.valueBuffer("idfactura");

  curFactura.select("idfactura = " + idfactura);
  if (curFactura.first())
    curFactura.setUnLock("editable", true);

  curPagosDev.select("idrecibo = " + idRecibo + " ORDER BY fecha,idpagodevol");
  if (curPagosDev.last()) {
    curPagosDev.setModeAccess(curPagosDev.Del);
    curPagosDev.refreshBuffer();
    if (!curPagosDev.commitBuffer())
      return false;
  }

  curPagosDev.select("idrecibo = " + idRecibo + " ORDER BY fecha,idpagodevol");
  if (curPagosDev.last()) {
    curPagosDev.setUnLock("editable", true);
  }
  if (curPagosDev.size() == 0) {
    curRecibos.setValueBuffer("estado", "Emitido");
  } else {
    curRecibos.setValueBuffer("estado", "Devuelto");
  }
  if (!curRecibos.commitBuffer()) {
    return false;
  }
  if (!flfactteso.iface.pub_actualizarTotalesReciboProv(idRecibo)) {
    return false;
  }
  return true;
}

function oficial_bufferChanged(fN: String)
{
  var cursor = this.cursor();
  var util = new FLUtil();
  switch (fN) {
      /** \C En contabilidad integrada, si el usuario pulsa la tecla del punto '.', --codsubcuenta-- se informa automaticamente con el código de cuenta más tantos ceros como sea necesario para completar la longitud de subcuenta asociada al ejercicio actual.
        \end */
    case "codsubcuenta": {
      if (!this.iface.bloqueoSubcuenta) {
        this.iface.bloqueoSubcuenta = true;
        this.iface.posActualPuntoSubcuenta = flcontppal.iface.pub_formatearCodSubcta(this, "fdbCodSubcuenta", this.iface.longSubcuenta, this.iface.posActualPuntoSubcuenta);
        this.iface.bloqueoSubcuenta = false;
      }
      if (!this.iface.bloqueoSubcuenta && this.child("fdbCodSubcuenta").value().length == this.iface.longSubcuenta) {
        this.child("fdbIdSubcuenta").setValue(this.iface.calculateField("idsubcuenta"));
      }
      break;
    }
    /** \D Si el usuario selecciona una cuenta bancaria, se tomará su cuenta contable asociada como --codcuenta-- contable para el pago.
    \end */
    case "codcuenta": {
      this.child("fdbIdSubcuenta").setValue(this.iface.calculateField("idsubcuentadefecto"));
      break;
    }
    case "idsubcuenta": {
      this.child("fdbCodSubcuenta").setValue(this.iface.calculateField("codsubcuenta"));
      break;
    }
    case "nogenerarasiento": {
      if (cursor.valueBuffer("nogenerarasiento") == true) {
        this.child("fdbIdSubcuenta").setValue("");
        this.child("fdbCodSubcuenta").setValue("");
        this.child("fdbDesSubcuenta").setValue("");
        cursor.setNull("idsubcuenta");
        cursor.setNull("codsubcuenta");
        this.child("fdbIdSubcuenta").setDisabled(true);
        this.child("fdbCodSubcuenta").setDisabled(true);
      } else {
        this.child("fdbIdSubcuenta").setDisabled(false);
        this.child("fdbCodSubcuenta").setDisabled(false);
      }
      break;
    }
    case "estado": {
      if (cursor.valueBuffer("estado") == "Pagada") {
        this.child("tbInsert").setDisabled(true);
        this.child("tbDelete").setDisabled(true);
      } else {
        this.child("tbInsert").setDisabled(false);
        this.child("tbDelete").setDisabled(false);
      }
      break;
    }
  }
}

/** \D Rellena la tabla de asiento acumulado de la pestaña de Contabilidad con los datos de contabilidad asociados a los recibos de la remesa
\end */
function oficial_asientoAcumulado()
{
  var util = new FLUtil;
  var totalFilas = this.iface.tblResAsientos.numRows() - 1;
  var fila: Number;
  for (fila = totalFilas; fila >= 0; fila--)
    this.iface.tblResAsientos.removeRow(fila);

  var idRemesa = this.cursor().valueBuffer("idremesa");
  if (!idRemesa)
    return;
  var qryAsientos = new FLSqlQuery();
  qryAsientos.setTablesList("recibosprov,pagosdevolprov,co_partidas");
  qryAsientos.setSelect("p.codsubcuenta, SUM(p.debe), SUM(p.haber)");
  qryAsientos.setFrom("recibosprov r INNER JOIN pagosdevolprov pd ON r.idrecibo = pd.idrecibo INNER JOIN co_partidas p ON pd.idasiento = p.idasiento");
  qryAsientos.setWhere("pd.idremesa = " + idRemesa + " GROUP BY p.codsubcuenta");
  qryAsientos.setOrderBy("p.codsubcuenta");
  if (!qryAsientos.exec())
    return;

  fila = 0;
  while (qryAsientos.next()) {
    this.iface.tblResAsientos.insertRows(fila, 1);
    this.iface.tblResAsientos.setText(fila, 0, qryAsientos.value("p.codsubcuenta"));
    this.iface.tblResAsientos.setText(fila, 1, util.sqlSelect("co_subcuentas", "descripcion", "codsubcuenta = '" + qryAsientos.value("p.codsubcuenta") + "' AND codejercicio = '" + this.iface.ejercicioActual + "'"));
    this.iface.tblResAsientos.setText(fila, 2, util.roundFieldValue(qryAsientos.value("SUM(p.debe)"), "co_partidas", "debe"));
    this.iface.tblResAsientos.setText(fila, 3, util.roundFieldValue(qryAsientos.value("SUM(p.haber)"), "co_partidas", "haber"));
    fila++;
  }
}

/** \D Asocia un recibo a una remesa, marcándolo como Pagado
@param  idRecibo: Identificador del recibo
@param  curRemesa: Cursor posicionado en la remesa
@return true si la asociación se realiza de forma correcta, false en caso contrario
\end */
function oficial_asociarReciboRemesa(idRecibo: String, curRemesa: FLSqlCursor)
{
  var _i = this.iface;
  var util = new FLUtil;
  var idRemesa = curRemesa.valueBuffer("idremesa");

  if (util.sqlSelect("recibosprov", "coddivisa", "idrecibo = " + idRecibo) != curRemesa.valueBuffer("coddivisa")) {
    MessageBox.warning(util.translate("scripts", "No es posible incluir el recibo.\nLa divisa del recibo y de la remesa deben ser la misma."), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return;
  }

  var datosCuenta = flfactppal.iface.pub_ejecutarQry("cuentasbanco", "ctaentidad,ctaagencia,cuenta", "codcuenta = '" + curRemesa.valueBuffer("codcuenta") + "'");
  if (datosCuenta.result != 1)
    return false;
  var dc = util.calcularDC(datosCuenta.ctaentidad + datosCuenta.ctaagencia) + util.calcularDC(datosCuenta.cuenta);

  var curRecibos = new FLSqlCursor("recibosprov");
  var idFactura: Number;

  var fecha = curRemesa.valueBuffer("fecha");
  if (!this.iface.curPagosDev)
    this.iface.curPagosDev = new FLSqlCursor("pagosdevolprov");
  this.iface.curPagosDev.select("idrecibo = " + idRecibo + " ORDER BY fecha,idpagodevol");
  if (this.iface.curPagosDev.last()) {
    if (util.daysTo(this.iface.curPagosDev.valueBuffer("fecha"), fecha) < 0) {
      var codRecibo = util.sqlSelect("recibosprov", "codigo", "idrecibo = " + idRecibo);
      MessageBox.warning(util.translate("scripts", "Existen pagos o devoluciones con fecha igual o porterior a la de la remesa para el recibo %1").arg(codRecibo), MessageBox.Ok, MessageBox.NoButton);
      return false;
    }
  }

  var tipoPD, estadoRecibo;
  if (_i.pagoDiferido_ && !_i.pagoIndirecto_) {
    tipoPD = "Remesado";
    estadoRecibo = "Remesado";
  } else {
    tipoPD = "Pago";
    estadoRecibo = "Pagado";
  }
  curRecibos.select("idrecibo = " + idRecibo);
  if (curRecibos.next()) {
    curRecibos.setActivatedCheckIntegrity(false);
    curRecibos.setModeAccess(curRecibos.Edit);
    curRecibos.refreshBuffer();
    if (!_i.validaReciboEnRemesa(curRecibos)) {
      return false;
    }
    curRecibos.setValueBuffer("idremesa", idRemesa);
    curRecibos.setValueBuffer("estado", estadoRecibo);
    idFactura = curRecibos.valueBuffer("idfactura");
    curRecibos.commitBuffer();
  }

  if (this.iface.curPagosDev.last()) {
    this.iface.curPagosDev.setUnLock("editable", false);
  }
  this.iface.curPagosDev.setModeAccess(this.iface.curPagosDev.Insert);
  this.iface.curPagosDev.refreshBuffer();
  this.iface.curPagosDev.setValueBuffer("idrecibo", idRecibo);
  this.iface.curPagosDev.setValueBuffer("fecha", fecha);
  this.iface.curPagosDev.setValueBuffer("tipo", tipoPD);
  this.iface.curPagosDev.setValueBuffer("codcuenta", curRemesa.valueBuffer("codcuenta"));
  this.iface.curPagosDev.setValueBuffer("ctaentidad", datosCuenta.ctaentidad);
  this.iface.curPagosDev.setValueBuffer("ctaagencia", datosCuenta.ctaagencia);
  this.iface.curPagosDev.setValueBuffer("dc", dc);
  this.iface.curPagosDev.setValueBuffer("cuenta", datosCuenta.cuenta);
  this.iface.curPagosDev.setValueBuffer("idremesa", idRemesa);
  this.iface.curPagosDev.setValueBuffer("nogenerarasiento", curRemesa.valueBuffer("nogenerarasiento"));
  if (parseFloat(curRemesa.valueBuffer("idsubcuenta")) == 0) {
    this.iface.curPagosDev.setNull("idsubcuenta");
    this.iface.curPagosDev.setNull("codsubcuenta");
  } else {
    this.iface.curPagosDev.setValueBuffer("idsubcuenta", curRemesa.valueBuffer("idsubcuenta"));
    this.iface.curPagosDev.setValueBuffer("codsubcuenta", curRemesa.valueBuffer("codsubcuenta"));
  }
  if (!this.iface.datosPagosDev(idRecibo, curRemesa)) {
    return false;
  }
  if (!this.iface.curPagosDev.commitBuffer()) {
    return false;
  }
  if (!flfactteso.iface.pub_actualizarTotalesReciboProv(idRecibo)) {
    return false;
  }
  return true;
}

function oficial_datosPagosDev(idRecibo: String, curRemesa: FLSqlCursor)
{
  return true;
}

function oficial_cambiarEstado()
{
  var _i = this.iface;
  this.child("fdbEstado").setValue(this.iface.calculateField("estado"));
  _i.actualizarTotal();
}

function oficial_dameFiltroRecibos()
{
  var cursor = this.cursor();
  var fecha = cursor.valueBuffer("fecha");
  var filtro = "estado IN ('Emitido', 'Devuelto') AND fecha <= '" + fecha + "'";
  return filtro;
}

function oficial_tbnPagarRecibo_clicked()
{
  var _i = this.iface;
  var cursor = this.cursor();
  var curR = this.child("tdbRecibos").cursor();
  var estado = curR.valueBuffer("estado");
  switch (estado) {
    case "Remesado": {
      var dialog = new Dialog;
      dialog.okButtonText = sys.translate("Aceptar");
      dialog.cancelButtonText = sys.translate("Cancelar");

      var dedFecha = new DateEdit;
      dedFecha.label = sys.translate("Fecha de pago");
      dedFecha.date = new Date;
      dialog.add(dedFecha);
      if (!dialog.exec()) {
        return false;
      }
      var fecha = dedFecha.date;
      var datosPago = new Object;
      datosPago.idrecibo = curR.valueBuffer("idrecibo");
      datosPago.fecha = fecha;
      if (!_i.pagarRecibo(cursor.valueBuffer("idremesa"), "Pago", datosPago)) {
        return false;
      }
      break;
    }
    case "Pagado": {
      var res = MessageBox.warning(sys.translate("Va a eliminar el pago del recibo seleccionado. ¿Está seguro?"), MessageBox.Yes, MessageBox.No, MessageBox.NoButton, "AbanQ");
      if (res != MessageBox.Yes) {
        return false;
      }
      var datosPago = new Object;
      datosPago.idrecibo = curR.valueBuffer("idrecibo");
      if (!_i.pagarRecibo(cursor.valueBuffer("idremesa"), "Remesado", datosPago)) {
        return false;
      }
      break;
    }
    default: {
      MessageBox.warning(sys.translate("El recibo debe estar en estado Remesado o Pagado"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton, "AbanQ");
      return;
    }
  }
  _i.cambiarEstado()
  this.child("tdbRecibos").refresh();
}

function oficial_pagarRecibo(idRemesa, estado, datosPago)
{
  var _i = this.iface;
  var curT = new FLSqlCursor("empresa");
  curT.transaction(false);
  try {
    if (flfactteso.iface.pub_modificaEstadoPagosRemesaProv(idRemesa, estado, datosPago)) {
      curT.commit();
    } else {
      curT.rollback();
      MessageBox.warning(sys.translate("Error al pagar el recibo"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton, "AbanQ");
      return false;
    }
  } catch (e) {
    curT.rollback();
    MessageBox.warning(sys.translate("Error al pagar el recibo: ") + e, MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton, "AbanQ");
    return false;
  }
  return true;
}


function oficial_validaReciboEnRemesa(curRecibo)
{
  if (curRecibo.valueBuffer("estado") == "Pagado") {
    MessageBox.warning(sys.translate("No puede asociar a la remesa un recibo ya pagado (%1)").arg(curRecibo.valueBuffer("codigo")), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton, "AbanQ");
    return false;
  }
  return true;
}

function oficial_commonCalculateField(fN, cursor)
{
  var _i = this.iface;
  var valor;

  switch (fN) {
      /** \D La subcuenta contable por defecto será la asociada a la cuenta bancaria. Si ésta está vacía, será la subcuenta correspondienta a Caja
          \end */
    case "idsubcuentadefecto": {
      if (_i.contabActivada) {
        var codSubcuenta;
        if (_i.pagoIndirecto_) {
          codSubcuenta = AQUtil.sqlSelect("cuentasbanco", "codsubcuentaecgP", "codcuenta = '" + cursor.valueBuffer("codcuenta") + "'");
        } else {
          codSubcuenta = AQUtil.sqlSelect("cuentasbanco", "codsubcuenta", "codcuenta = '" + cursor.valueBuffer("codcuenta") + "'");
        }
        if (codSubcuenta != false) {
          valor = AQUtil.sqlSelect("co_subcuentas", "idsubcuenta", "codsubcuenta = '" + codSubcuenta + "' AND codejercicio = '" + _i.ejercicioActual + "'");
        } else  {
          valor = "";
        }
      }
      break;
    }
    case "idsubcuenta": {
      var codSubcuenta = cursor.valueBuffer("codsubcuenta").toString();
      if (codSubcuenta.length == _i.longSubcuenta)
        valor = AQUtil.sqlSelect("co_subcuentas", "idsubcuenta", "codsubcuenta = '" + codSubcuenta + "' AND codejercicio = '" + _i.ejercicioActual + "'");
      break;
    }
    case "codsubcuenta": {
      valor = "";
      if (cursor.valueBuffer("idsubcuenta"))
        valor = AQUtil.sqlSelect("co_subcuentas", "codsubcuenta", "idsubcuenta = '" + cursor.valueBuffer("idsubcuenta") + "' AND codejercicio = '" + _i.ejercicioActual + "'");
      break;
    }
    case "total": {
      valor = AQUtil.sqlSelect("recibosprov", "SUM(importe)", "idrecibo IN (SELECT idrecibo FROM pagosdevolprov WHERE idremesa = " + cursor.valueBuffer("idremesa") + ")");
      break;
    }
    case "estado": {
      if (_i.pagoIndirecto_) {
        var tipo = AQUtil.sqlSelect("pagosdevolremprov", "tipo", "idremesa = " + cursor.valueBuffer("idremesa"));
        if (!tipo || tipo == "") {
          valor = "Emitida";
        } else {
          valor = "Pagada";
        }
      } else if (_i.pagoDiferido_) {
        if (AQUtil.sqlSelect("pagosdevolprov", "tipo", "idremesa = " + cursor.valueBuffer("idremesa") + " AND tipo = 'Remesado'")) {
          valor = "Emitida";
        } else {
          valor = "Pagada";
        }
      } else {
        valor = "Emitida";
      }
      break;
    }
  }
  return valor;
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
