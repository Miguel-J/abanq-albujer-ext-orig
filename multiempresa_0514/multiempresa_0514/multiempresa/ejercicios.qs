
/** @class_declaration multiEmpresa */
/////////////////////////////////////////////////////////////////
//// MULTIEMPRESA ///////////////////////////////////////////////
class multiEmpresa extends pgc2008
{
  function multiEmpresa(context)
  {
    pgc2008(context);
  }
  function validateForm()
  {
    return this.ctx.multiEmpresa_validateForm();
  }
  function validarEmpresa()
  {
    return this.ctx.multiEmpresa_validarEmpresa();
  }
}
//// MULTIEMPRESA ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition multiEmpresa */
/////////////////////////////////////////////////////////////////
//// MULTIEMPRESA ///////////////////////////////////////////////
function multiEmpresa_validateForm()
{
  if (!this.iface.__validateForm()) {
    return false;
  }
  if (!this.iface.validarEmpresa()) {
    return false;
  }
  return true;
}

function multiEmpresa_validarEmpresa()
{
  var util = new FLUtil;
  var cursor = this.cursor();
  var idEmpresa = cursor.valueBuffer("idempresa");
  if (!idEmpresa || idEmpresa == "") {
    MessageBox.warning(util.translate("scripts", "Debe establecer la empresa asociada al ejercicio"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  return true;
}
//// MULTIEMPRESA ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
