
/** @class_declaration sincrotpv */
/////////////////////////////////////////////////////////////////
//// SINCRO TPV /////////////////////////////////////////////////
class sincrotpv extends multitienda
{
  function sincrotpv(context)
  {
    multitienda(context);
  }
  function validateForm()
  {
    return this.ctx.sincrotpv_validateForm();
  }
  function validaPrefijoDoc()
  {
    return this.ctx.sincrotpv_validaPrefijoDoc();
  }
}
//// SINCRO TPV /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition sincrotpv */
/////////////////////////////////////////////////////////////////
//// SINCRO TPV /////////////////////////////////////////////////
function sincrotpv_validateForm()
{
  var _i = this.iface;

  if (!_i.__validateForm()) {
    return false;
  }
  if (!_i.validaPrefijoDoc()) {
    return false;
  }
  return true;
}

function sincrotpv_validaPrefijoDoc()
{
  var _i = this.iface;
  var cursor = this.cursor();

  var pD = cursor.valueBuffer("prefijodoc");
  if (pD == "00") {
    MessageBox.warning(sys.translate("El prefijo 00 está reservado para documentos emitidos desde central de TPV"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton, "AbanQ");
    return false;
  }
  return true;
}
//// SINCRO TPV /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

