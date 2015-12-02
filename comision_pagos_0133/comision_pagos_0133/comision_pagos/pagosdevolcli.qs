
/** @class_declaration comisionPagos */
//////////////////////////////////////////////////////////////////
//// COMISION_PAGOS /////////////////////////////////////////////////
class comisionPagos extends oficial
{
  function comisionPagos(context)
  {
    oficial(context);
  }
  function init()
  {
    this.ctx.comisionPagos_init();
  }
  function validateForm()
  {
    return this.ctx.comisionPagos_validateForm();
  }
  function calculateField(fN: String): String {
    return this.ctx.comisionPagos_calculateField(fN);
  }
  function bufferChanged(fN: String)
  {
    return this.ctx.comisionPagos_bufferChanged(fN);
  }
}
//// COMISION_PAGOS /////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_definition comisionPagos */
/////////////////////////////////////////////////////////////////
//// COMISION_PAGOS /////////////////////////////////////////////////

function comisionPagos_init(fN: String)
{
  this.iface.__init();

  if (this.cursor().valueBuffer("tipo") != "Pago") {
    this.child("gbxGasto").setDisabled(true);
    return;
  }

  var codEjercicio: String = flfactppal.iface.pub_ejercicioActual();
  var ctaGastos = flfacturac.iface.pub_datosCtaEspecial("GTOBCO", codEjercicio);
  if (ctaGastos.error == 0)
    this.child("fdbIdSubcuentaGasto").setValue(ctaGastos.idsubcuenta)
  }

function comisionPagos_bufferChanged(fN: String)
{
  var cursor: FLSqlCursor = this.cursor();
  switch (fN) {
      /** \C
      Si el usuario pulsa la tecla del punto '.', la subcuenta se informa automaticamente con el código de cuenta más tantos ceros como sea necesario para completar la longitud de subcuenta asociada al ejercicio actual.
      \end */
    case "codsubcuentagasto":
      if (!this.iface.bloqueoSubcuenta) {
        this.iface.bloqueoSubcuenta = true;
        this.iface.posActualPuntoSubcuenta = flcontppal.iface.pub_formatearCodSubcta(this, "fdbCodSubcuentaGasto", this.iface.longSubcuenta, this.iface.posActualPuntoSubcuenta);
        this.iface.bloqueoSubcuenta = false;
      }
      if (!this.iface.bloqueoSubcuenta && this.child("fdbCodSubcuentaGasto").value().length == this.iface.longSubcuenta) {
        this.child("fdbIdSubcuentaGasto").setValue(this.iface.calculateField("idsubcuentagasto"));
      }
      break;

    default:
      return this.iface.__bufferChanged(fN);
  }
}

function comisionPagos_calculateField(fN: String): String {
  var util: FLUtil = new FLUtil();
  var cursor: FLSqlCursor = this.cursor();
  var res: String;
  switch (fN)
  {
    case "idsubcuentagasto":
      var codSubcuenta: String = cursor.valueBuffer("codsubcuentagasto").toString();
      if (codSubcuenta.length == this.iface.longSubcuenta)
        res = util.sqlSelect("co_subcuentas", "idsubcuenta",
        "codsubcuenta = '" + codSubcuenta +
        "' AND codejercicio = '" + this.iface.ejercicioActual +
        "'");
      break;

    default:
      return this.iface.__calculateField(fN);
  }
  return res;
}

function comisionPagos_validateForm(): Boolean {
  var cursor: FLSqlCursor = this.cursor();
  var util: FLUtil = new FLUtil();

  /** \C
  Si hay gasto, la subcuenta no puede ser nula
  \end */
  if (cursor.valueBuffer("gasto") && !cursor.valueBuffer("idsubcuentagasto"))
  {
    MessageBox.warning(util.translate("scripts", "Debe indicar una subcuenta de gasto"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return false;
  }

  /** \C
  El gasto no puede ser negativo
  \end */
  if (cursor.valueBuffer("gasto") && cursor.valueBuffer("gasto") < 0)
  {
    MessageBox.warning(util.translate("scripts", "El gasto no puede ser negativo"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return false;
  }

  /** \C
  El gasto no puede ser mayor al importe del recibo
  \end */
  if (cursor.valueBuffer("gasto") > cursor.cursorRelation().valueBuffer("importe"))
  {
    MessageBox.warning(util.translate("scripts", "El gasto no puede ser superior al importe del recibo"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return false;
  }

  return this.iface.__validateForm();
}

//// COMISION_PAGOS ////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
