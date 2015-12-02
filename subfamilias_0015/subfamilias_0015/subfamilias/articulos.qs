
/** @class_declaration sfamilia */
//////////////////////////////////////////////////////////////////
//// SUBFAMILIA //////////////////////////////////////////////////
class sfamilia extends oficial
{
  function sfamilia(context)
  {
    oficial(context);
  }
  function bufferChanged(fN)
  {
    return this.ctx.sfamilia_bufferChanged(fN);
  }
  function calculateField(fN)
  {
    return this.ctx.sfamilia_calculateField(fN);
  }
  function validateForm()
  {
    return this.ctx.sfamilia_validateForm();
  }
  function comprobarSubfamilia()
  {
    return this.ctx.sfamilia_comprobarSubfamilia();
  }
}
//// SUBFAMILIA //////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_definition sfamilia */
/////////////////////////////////////////////////////////////////
//// SUBFAMILIA /////////////////////////////////////////////////
function sfamilia_bufferChanged(fN)
{
  switch (fN) {
    case "codsubfamilia":
      this.child("fdbCodFamilia").setValue(this.iface.calculateField("codfamilia"));
      break;
    default:
      this.iface.__bufferChanged(fN);
  }
}

function sfamilia_calculateField(fN)
{
  var _i = this.iface;
  var valor;

  switch (fN) {
    case "codfamilia": {
      valor =  AQUtil.sqlSelect("subfamilias", "codfamilia", "codsubfamilia='" + this.cursor().valueBuffer("codsubfamilia") + "';");
      break;
    }
    default: {
      valor = _i.__calculateField(fN);
    }
  }
  return valor;
}

function sfamilia_validateForm()
{
  var _i = this.iface;

  if (!_i.__validateForm()) {
    return false;
  }

  if (!_i.comprobarSubfamilia()) {
    return false;
  }

  return true;
}

function sfamilia_comprobarSubfamilia()
{
  var _i = this.iface;
  var cursor = this.cursor();

  var codFamilia = cursor.valueBuffer("codfamilia");
  var codSubfamilia = cursor.valueBuffer("codsubfamilia");

  if (!codFamilia || !codSubfamilia) {
    return true;
  }

  var codFamiliaSF = AQUtil.sqlSelect("subfamilias", "codfamilia", "codsubfamilia='" + codSubfamilia + "';");

  if (codFamiliaSF != codFamilia) {
    MessageBox.critical(sys.translate("La subfamilia no pertenece a la familia"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }

  return true;
}

//// SUBFAMILIA /////////////////////////////////////////////////
////////////////////////////////////////////////////////////////