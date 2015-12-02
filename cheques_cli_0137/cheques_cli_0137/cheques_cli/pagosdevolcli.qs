
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
  function validateForm()
  {
    return this.ctx.chequesCli_validateForm();
  }
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
  var cursor: FLSqlCursor = this.cursor();
  if (cursor.modeAccess() != cursor.Browse) {
    this.iface.__init();
  }

  var util: FLUtil = new FLUtil();
  if (this.cursor().valueBuffer("tipo") != "Pago")
    this.child("gbxCheque").setDisabled(true);

  if (this.cursor().valueBuffer("idremesacheque") > 0) {
    this.child("gbxCheque").setDisabled(true);
    this.child("leCheque").text = util.translate("scripts", "Cheque remesado en remesa ") + this.cursor().valueBuffer("idremesacheque");
  }

  this.iface.controlDatosCheque();
}

function chequesCli_validateForm(): Boolean {
  var util: FLUtil = new FLUtil();
  var cursor: FLSqlCursor = this.cursor();

  if (cursor.valueBuffer("pagoporcheque") && (!cursor.valueBuffer("numerocheque") || !cursor.valueBuffer("fechavtocheque") || !cursor.valueBuffer("entidadcheque")))
  {
    MessageBox.warning(util.translate("scripts", "Si el pago es por cheque debe rellenar todos los datos del mismo"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
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
