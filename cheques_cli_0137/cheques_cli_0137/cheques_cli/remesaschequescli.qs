/***************************************************************************
                      remesaschequescli.qs  -  description
                             -------------------
    begin                : lun may 31 2004
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
  var curPagosDev: FLSqlCursor;

  function oficial(context)
  {
    interna(context);
  }
  function actualizarTotal()
  {
    return this.ctx.oficial_actualizarTotal();
  }
  function agregarCheque()
  {
    return this.ctx.oficial_agregarCheque();
  }
  function eliminarCheque()
  {
    return this.ctx.oficial_eliminarCheque();
  }
  function bufferChanged(fN: String)
  {
    return this.ctx.oficial_bufferChanged(fN);
  }
  function asociarChequeRemesa(idPago: String, curRemesa: FLSqlCursor)
  {
    return this.ctx.oficial_asociarChequeRemesa(idPago, curRemesa);
  }
  function excluirChequeRemesa(idPago: String, idRemesa: String)
  {
    return this.ctx.oficial_excluirChequeRemesa(idPago, idRemesa);
  }
  function datosPagosDev(idRecibo: String, curRemesa: FLSqlCursor)
  {
    return this.ctx.oficial_datosPagosDev(idRecibo, curRemesa);
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
  function pub_asociarChequeRemesa(idPago: String, curRemesa: FLSqlCursor)
  {
    return this.asociarChequeRemesa(idPago, curRemesa);
  }
  function pub_excluirChequeRemesa(idPago: String, idRemesa: String)
  {
    return this.excluirChequeRemesa(idPago, idRemesa);
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

  var cursor = this.cursor();
  var util = new FLUtil;

  this.iface.contabActivada = sys.isLoadedModule("flcontppal") && util.sqlSelect("empresa", "contintegrada", "1 = 1");
  if (this.iface.contabActivada) {
    this.child("tdbPartidas").setReadOnly(true);
    this.iface.ejercicioActual = flfactppal.iface.pub_ejercicioActual();
    this.iface.longSubcuenta = util.sqlSelect("ejercicios", "longsubcuenta", "codejercicio = '" + this.iface.ejercicioActual + "'");
    this.child("fdbIdSubcuenta").setFilter("codejercicio = '" + this.iface.ejercicioActual + "'");
    this.iface.posActualPuntoSubcuenta = -1;
  } else {
    this.child("tbwRemesa").setTabEnabled("contabilidad", false);
  }

  connect(this.child("tbInsert"), "clicked()", this, "iface.agregarCheque");
  connect(this.child("tbDelete"), "clicked()", this, "iface.eliminarCheque");
  connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");

  var tdbCheques = this.child("tdbCheques");

  /** \C La tabla de recibos se muestra en modo de sólo lectura
  \end */
  tdbCheques.setReadOnly(true);
  var mA = cursor.modeAccess();
  if (mA == cursor.Insert)
    this.child("fdbCodDivisa").setValue(flfactppal.iface.pub_valorDefectoEmpresa("coddivisa"));

  var columnas: Array;
  columnas[0] = "numerocheque";
  columnas[1] = "entidadcheque";
  columnas[2] = "fechavtocheque";
  tdbCheques.setOrderCols(columnas);

  tdbCheques.cursor().setMainFilter("idrecibo IN (SELECT idrecibo FROM pagosdevolcli WHERE idremesacheque = " + cursor.valueBuffer("idremesa") + ")");
  tdbCheques.refresh();

  this.iface.actualizarTotal();
}

function interna_validateForm()
{
  var util = new FLUtil;
  var cursor = this.cursor();

  /** \C La remesa debe tener al menos un recibo
  \end */
  if (this.child("tdbCheques").cursor().size() == 0) {
    MessageBox.warning(util.translate("scripts", "La remesa debe tener al menos un cheque"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return false;
  }

  return true;
}

function interna_calculateField(fN: String)
{
  var util = new FLUtil();
  var cursor = this.cursor();

  var res: String;
  switch (fN) {
      /** \D La subcuenta contable por defecto será la asociada a la cuenta bancaria. Si ésta está vacía, será la subcuenta correspondienta a Caja
          \end */
    case "idsubcuentadefecto":
      if (this.iface.contabActivada) {
        var codSubcuenta = util.sqlSelect("cuentasbanco", "codsubcuenta", "codcuenta = '" + cursor. valueBuffer("codcuenta") + "'");
        if (codSubcuenta != false)
          res = util.sqlSelect("co_subcuentas", "idsubcuenta", "codsubcuenta = '" + codSubcuenta + "' AND codejercicio = '" + this.iface.ejercicioActual + "'");
        else
          res = "";
      }
      break;
    case "idsubcuenta":
      var codSubcuenta = cursor.valueBuffer("codsubcuenta").toString();
      if (codSubcuenta.length == this.iface.longSubcuenta)
        res = util.sqlSelect("co_subcuentas", "idsubcuenta", "codsubcuenta = '" + codSubcuenta + "' AND codejercicio = '" + this.iface.ejercicioActual + "'");
      break;
    case "codsubcuenta":
      res = "";
      if (cursor.valueBuffer("idsubcuenta"))
        res = util.sqlSelect("co_subcuentas", "codsubcuenta", "idsubcuenta = '" + cursor.valueBuffer("idsubcuenta") + "' AND codejercicio = '" + this.iface.ejercicioActual + "'");
      break;
    case "total": {
      res = util.sqlSelect("reciboscli", "SUM(importe)", "idrecibo IN (SELECT idrecibo FROM pagosdevolcli WHERE idremesacheque = " + cursor.valueBuffer("idremesa") + ")");
      break;
    }
  }
  return res;
}

/** \D Calcula un nuevo código de remesa
\end */
function interna_calculateCounter()
{
  var util = new FLUtil();
  var cadena = util.sqlSelect("remesaschequescli", "idremesa", "1 = 1 ORDER BY idremesa DESC");
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
  if (this.child("tdbCheques").cursor().size() > 0) {
    this.child("fdbCodCuenta").setDisabled(true);
    this.child("fdbCodDivisa").setDisabled(true);
    this.child("fdbFecha").setDisabled(true);
    this.child("gbxContabilidad").setEnabled(false);

  } else {
    this.child("fdbCodCuenta").setDisabled(false);
    this.child("fdbCodDivisa").setDisabled(false);
    this.child("fdbFecha").setDisabled(false);
    this.child("gbxContabilidad").setEnabled(true);
  }
}

/** \D Se agrega un cheque a la remesa. Si la contabilidad está integrada se comprueba que se ha seleccionado una subcuenta
\end */
function oficial_agregarCheque()
{
  var util = new FLUtil();

  if (!this.cursor().valueBuffer("codcuenta")) {
    MessageBox.warning(util.translate("scripts", "Debe indicar una cuenta bancaria"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return;
  }

  if (sys.isLoadedModule("flcontppal") && !this.cursor().valueBuffer("nogenerarasiento") && !this.cursor().valueBuffer("codsubcuenta")) {
    MessageBox.warning(util.translate("scripts", "Debe indicar una subcuenta contable"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return;
  }

  var cursor = this.cursor();
  var f = new FLFormSearchDB("seleccionchequescli");
  var curCheques = f.cursor();
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

  var filtro = "(idremesacheque IS NULL OR idremesacheque = 0) AND pagosdevolcli.pagoporcheque = true";
  var entidad = cursor.valueBuffer("entidad");
  var fechaVtoDesde = cursor.valueBuffer("fechavtodesde");
  var fechaVtoHasta = cursor.valueBuffer("fechavtohasta");
  if (entidad)
    filtro += " AND entidadcheque = '" + entidad + "'";
  if (fechaVtoDesde)
    filtro += " AND fechavtocheque >= '" + fechaVtoDesde + "'";
  if (fechaVtoHasta)
    filtro += " AND fechavtocheque <= '" + fechaVtoHasta + "'";

  curCheques.select();
  if (!curCheques.first())
    curCheques.setModeAccess(curCheques.Insert);
  else
    curCheques.setModeAccess(curCheques.Edit);

  f.setMainWidget();
  curCheques.refreshBuffer();
  curCheques.setValueBuffer("datos", "");
  curCheques.setValueBuffer("filtro", filtro);
  curCheques.setValueBuffer("importedesde", cursor.valueBuffer("importedesde"));
  curCheques.setValueBuffer("importehasta", cursor.valueBuffer("importehasta"));
  var datos = f.exec("datos");
  if (!datos || datos == "")
    return false;
  var cheques = datos.toString().split(",");
  for (var i = 0; i < cheques.length; i++) {
    if (!this.iface.asociarChequeRemesa(cheques[i], cursor))
      return false;
  }
  this.child("tdbCheques").refresh();
  this.iface.actualizarTotal();
}

/** \D Se elimina el recibo activo de la remesa. El pago asociado a la remesa debe ser el último asignado al recibo
\end */
function oficial_eliminarCheque()
{
  if (!this.child("tdbCheques").cursor().isValid())
    return;

  var idPago = this.child("tdbCheques").cursor().valueBuffer("idpagodevol");
  if (!this.iface.excluirChequeRemesa(idPago))
    return

      this.child("tdbCheques").refresh();
  this.iface.actualizarTotal();
}

function oficial_excluirChequeRemesa(idPago: String, idRemesa: String)
{
  var util = new FLUtil;

  var curCheques = new FLSqlCursor("pagosdevolcli");
  curCheques.setActivatedCommitActions(false);
  curCheques.select("idpagodevol = " + idPago);

  if (!curCheques.first()) {
    return false;
  }
  curCheques.setModeAccess(curCheques.Edit);
  curCheques.refreshBuffer();
  idRecibo = curCheques.valueBuffer("idrecibo");
  curCheques.setNull("idremesacheque");
  if (!curCheques.commitBuffer()) {
    return false;
  }
  if (!flfactteso.iface.pub_actualizarTotalesReciboCli(idRecibo)) {
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
    case "codsubcuenta":
      if (!this.iface.bloqueoSubcuenta) {
        this.iface.bloqueoSubcuenta = true;
        this.iface.posActualPuntoSubcuenta = flcontppal.iface.pub_formatearCodSubcta(this, "fdbCodSubcuenta", this.iface.longSubcuenta, this.iface.posActualPuntoSubcuenta);
        this.iface.bloqueoSubcuenta = false;
      }
      if (!this.iface.bloqueoSubcuenta && this.child("fdbCodSubcuenta").value().length == this.iface.longSubcuenta) {
        this.child("fdbIdSubcuenta").setValue(this.iface.calculateField("idsubcuenta"));
      }
      break;
      /** \D Si el usuario selecciona una cuenta bancaria, se tomará su cuenta contable asociada como --codcuenta-- contable para el pago.
        \end */
    case "codcuenta":
      this.child("fdbIdSubcuenta").setValue(this.iface.calculateField("idsubcuentadefecto"));
      break;
    case "idsubcuenta":
      this.child("fdbCodSubcuenta").setValue(this.iface.calculateField("codsubcuenta"));
      break;
    case "nogenerarasiento":
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
}
/** \D Asocia un recibo a una remesa, marcándolo como Pagado
@param  idRecibo: Identificador del recibo
@param  curRemesa: Cursor posicionado en la remesa
@return true si la asociación se realiza de forma correcta, false en caso contrario
\end */
function oficial_asociarChequeRemesa(idPago: String, curRemesa: FLSqlCursor)
{
  var util = new FLUtil;
  var idRemesa = curRemesa.valueBuffer("idremesa");

  //  if (util.sqlSelect("reciboscli", "coddivisa", "idrecibo = " + idRecibo) != curRemesa.valueBuffer("coddivisa")) {
  //    MessageBox.warning(util.translate("scripts", "No es posible incluir el recibo.\nLa divisa del recibo y de la remesa deben ser la misma."), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
  //    return;
  //  }

  var curCheques = new FLSqlCursor("pagosdevolcli");
  curCheques.setActivatedCommitActions(false);
  var idRecibo;
  curCheques.select("idpagodevol = " + idPago);
  if (curCheques.next()) {
    curCheques.setModeAccess(curCheques.Edit);
    curCheques.refreshBuffer();
    idRecibo = curCheques.valueBuffer("idrecibo");
    curCheques.setValueBuffer("idremesacheque", idRemesa);
    curCheques.commitBuffer();
  }
  if (!flfactteso.iface.pub_actualizarTotalesReciboCli(idRecibo)) {
    return false;
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
