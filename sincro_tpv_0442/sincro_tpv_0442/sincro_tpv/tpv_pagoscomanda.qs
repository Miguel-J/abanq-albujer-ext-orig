
/** @class_declaration sincro */
/////////////////////////////////////////////////////////////////
//// SINCRO TPV /////////////////////////////////////////////////
class sincro extends oficial
{
  function sincro(context)
  {
    oficial(context);
  }
  function validateForm()
  {
    return this.ctx.sincro_validateForm();
  }
  function datosSincro()
  {
    return this.ctx.sincro_datosSincro();
  }
  function commonCalculateField(fN, cursor)
  {
    return this.ctx.sincro_commonCalculateField(fN, cursor);
  }
}
//// SINCRO TPV /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition sincro */
/////////////////////////////////////////////////////////////////
//// SINCRO TPV /////////////////////////////////////////////////
function sincro_validateForm()
{
  var _i = this.iface;
  if (!_i.__validateForm()) {
    return false;
  }
  if (!_i.datosSincro()) {
    return false;
  }
  return true;
}

function sincro_datosSincro()
{
  var _i = this.iface;
  var cursor = this.cursor();
  cursor.setValueBuffer("codcomanda", cursor.cursorRelation().valueBuffer("codigo"));
  cursor.setValueBuffer("idsincro", _i.commonCalculateField("idsincro", cursor));
  return true;
}

function sincro_commonCalculateField(fN, cursor)
{
  var _i = this.iface;
  var valor;
  switch (fN) {
    case "idsincro": {
      valor = cursor.valueBuffer("codcomanda") + "_" + cursor.valueBuffer("idpago").toString();
      break;
    }
    default: {
      valor = _i.__commonCalculateField(fN, cursor);
    }
  }
  return valor;
}
//// SINCRO TPV /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
