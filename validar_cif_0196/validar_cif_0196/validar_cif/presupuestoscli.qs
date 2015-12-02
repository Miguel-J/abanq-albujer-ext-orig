
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
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();
  if (!this.iface.__validateForm())
    return false;

  if (!flfactppal.iface.pub_validarCIFDocCli(cursor)) {
    return false;
  }

  return true;
}

//// VALIDACIÓN DE CIF //////////////////////////////////////////
/////////////////////////////////////////////////////////////////

