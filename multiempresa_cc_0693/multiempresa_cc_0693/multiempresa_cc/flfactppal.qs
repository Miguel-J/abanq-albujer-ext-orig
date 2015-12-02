
/** @class_declaration multiempcc */
/////////////////////////////////////////////////////////////////
//// MULTIEMPRESA + CC ////////////////////////////////////
class multiempcc extends cCoste
{
  function multiempcc(context)
  {
    cCoste(context);
  }
  function validarCCEmpresa(codCentro: String): Boolean {
    return this.ctx.multiempcc_validarCCEmpresa(codCentro);
  }
}
//// MULTIEMPRESA + CC ////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pubMultiCC */
////////////////////////////////////////////////////////////////////////
//// PUB_MULTICC ///////////////////////////////////////////////////
class pubMultiCC extends pubCCoste
{
  function pubMultiCC(context)
  {
    pubCCoste(context);
  }
  function pub_validarCCEmpresa(codCentro)
  {
    return this.validarCCEmpresa(codCentro);
  }
}
//// PUB_MULTICC //////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////

/** @class_definition multiempcc */
/////////////////////////////////////////////////////////////////
//// MULTIEMPRESA + CC ////////////////////////////////////
function multiempcc_validarCCEmpresa(codCentro)
{
  if (!codCentro || codCentro == "") {
    return true;
  }
  var util: FLUtil;

  var codEjercicio = this.iface.ejercicioActual();
  var idEmpresa = util.sqlSelect("ejercicios", "idempresa", "codejercicio = '" + codEjercicio + "'");
  if (!idEmpresa)
    return true;

  if (!util.sqlSelect("centroscoste", "codcentro", "idempresa = " + idEmpresa + " and codcentro = '" + codCentro + "'")) {
    MessageBox.warning(util.translate("scripts", "El centro de coste especificado no pertenece al ejercicio de la empresa"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }

  return true;
}
//// MULTIEMPRESA + CC ////////////////////////////////////
/////////////////////////////////////////////////////////////////
