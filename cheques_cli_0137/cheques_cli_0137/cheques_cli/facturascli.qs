
/** @class_declaration chequesCli */
//////////////////////////////////////////////////////////////////
//// CHEQUES CLI ///////////////////////////////////////////
class chequesCli extends oficial
{
  function chequesCli(context)
  {
    oficial(context);
  }
  function init()
  {
    this.ctx.chequesCli_init();
  }
  function validateForm(): Boolean { return this.ctx.chequesCli_validateForm(); }
  function bufferChanged(fN: String)
  {
    return this.ctx.chequesCli_bufferChanged(fN);
  }
  function controlDatosCheque()
  {
    return this.ctx.chequesCli_controlDatosCheque();
  }
}
//// CHEQUES CLI ///////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_definition chequesCli */
/////////////////////////////////////////////////////////////////
//// CHEQUES CLI //////////////////////////////////////////

function chequesCli_init()
{
  this.iface.__init();
  this.iface.controlDatosCheque();
}

/** \C
Si la factura se paga por cheque todos los datos del cheque deben rellenarse,
y la forma de pago debe ser tal que genere los recibos como pagados y sea
de plazo únino
\end */
function chequesCli_validateForm()
{
  if (!this.cursor().valueBuffer("pagoporcheque"))
    return this.iface.__validateForm();

  var util: FLUtil = new FLUtil();
  var cursor: FLSqlCursor = this.cursor();

  if (!cursor.valueBuffer("numerocheque") || !cursor.valueBuffer("fechavtocheque") || !cursor.valueBuffer("entidadcheque")) {
    MessageBox.warning(util.translate("scripts", "Si el pago es por cheque debe rellenar todos los datos del mismo"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return false;
  }

  if (util.sqlSelect("formaspago", "genrecibos", "codpago = '" + cursor.valueBuffer("codpago") + "'") != "Pagados") {
    MessageBox.warning(util.translate("scripts", "Si el pago es por cheque la forma de pago de la factura\ndeberá generar recibos como pagados"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return false;
  }

  if (util.sqlSelect("plazos", "count(id)", "codpago = '" + cursor.valueBuffer("codpago") + "'") > 1) {
    MessageBox.warning(util.translate("scripts", "Si el pago es por cheque la forma de pago debe ser a plazo único"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return false;
  }

  return this.iface.__validateForm();
}

function chequesCli_bufferChanged(fN: String)
{
  var cursor: FLSqlCursor = this.cursor();
  switch (fN) {
    case "pagoporcheque":
      this.iface.controlDatosCheque();
      break;
    default:
      return this.iface.__bufferChanged(fN);
  }
}

/** \D Habilita o inhabilita los campos de pago por cheque
\end */
function chequesCli_controlDatosCheque()
{
  var cursor: FLSqlCursor = this.cursor();

  var bloqueo: Boolean = true;
  if (this.cursor().valueBuffer("pagoporcheque"))
    bloqueo = false;

  this.child("fdbEntidadCheque").setDisabled(bloqueo);
  this.child("fdbNumeroCheque").setDisabled(bloqueo);
  this.child("fdbFechaVtoCheque").setDisabled(bloqueo);
}

//// CHEQUES CLI //////////////////////////////////////////
/////////////////////////////////////////////////////////////////
