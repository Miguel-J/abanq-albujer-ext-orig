
/** @class_declaration puntosTpv */
//////////////////////////////////////////////////////////////////
//// PUNTOSTPV ///////////////////////////////////////////////////
class puntosTpv extends oficial
{
  function puntosTpv(context)
  {
    oficial(context);
  }
  function init()
  {
    return this.ctx.puntosTpv_init();
  }
  function habilitarPuntos()
  {
    return this.ctx.puntosTpv_habilitarPuntos();
  }
  function validateForm()
  {
    return this.ctx.puntosTpv_validateForm();
  }
  function bufferChanged(fN: String)
  {
    return this.ctx.puntosTpv_bufferChanged(fN);
  }
}

//// PUNTOSTPV ///////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////


/** @class_definition puntosTpv */
/////////////////////////////////////////////////////////////////
//// PUNTOS TPV /////////////////////////////////////////////////
function puntosTpv_init()
{
  var _i = this.iface;
  var cursor = this.cursor();
  _i.habilitarPuntos();
  _i.__init();
}

function puntosTpv_habilitarPuntos()
{
  var cursor = this.cursor();
  if (cursor.valueBuffer("programapuntosespeciales")) {
    this.child("fdbValorPuntosEspeciales").setDisabled(false);
  } else {
    this.child("fdbValorPuntosEspeciales").setDisabled(true);
  }
}

function puntosTpv_bufferChanged(fN: String)
{
  var _i = this.iface;
  var cursor = this.cursor();

  switch (fN) {
    case "programapuntosespeciales": {
      _i.habilitarPuntos();
      break;
    }
    default: {
      _i.__bufferChanged(fN);
    }
  }
}

function puntosTpv_validateForm()
{

  var _i = this.iface;
  var cursor = this.cursor();

  if (!_i.__validateForm()) {
    return false;
  }

  if (cursor.valueBuffer("programapuntosespeciales")) {
    debug("nulo " + cursor.isNull("valorpuntosespeciales"));
    if (cursor.isNull("valorpuntosespeciales")) {
      debug("valorpuntosespeciales: " + cursor.valueBuffer("valorpuntosespeciales"));
      MessageBox.warning(AQUtil.translate("scripts", "Si activa los puntos especiales debe introducir un valor."), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton, "AbanQ");
      return false;
    }
  }
  return true;
}

//// PUNTOS TPV /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

