
/** @class_declaration valCif */
/////////////////////////////////////////////////////////////////
//// VALIDACIÓN DE CIF //////////////////////////////////////////
class valCif extends oficial
{
  function valCif(context)
  {
    oficial(context);
  }
  function init()
  {
    return this.ctx.valCif_init();
  }
  function validateForm(): Boolean {
    return this.ctx.valCif_validateForm();
  }
}
//// VALIDACIÓN DE CIF //////////////////////////////////////////
/////////////////////////////////////////////////////////////////


/** @class_definition valCif */
///////////////////////////// ////////////////////////////////////
//// VALIDACIÓN DE CIF //////////////////////////////////////////

function valCif_init()
{
  this.iface.__init();
}

function valCif_validateForm()
{
  var cursor: FLSqlCursor = this.cursor();
  var util: FLUtil = new FLUtil();
  if (!this.iface.__validateForm())
    return false;

  var cif: String = cursor.valueBuffer("cifnif");
  var idFiscal: String = cursor.valueBuffer("tipoidfiscal");
  var codPais: String = util.sqlSelect("dirproveedores", "codpais", "codproveedor = '" + cursor.valueBuffer("codproveedor") + "' AND direccionppal = true");

  var res: String = flfactppal.iface.pub_validarCif(cif, idFiscal, codPais);
  if (res != "OK") {
    MessageBox.warning(res, MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  return true;
}

//// VALIDACIÓN DE CIF //////////////////////////////////////////
/////////////////////////////////////////////////////////////////

