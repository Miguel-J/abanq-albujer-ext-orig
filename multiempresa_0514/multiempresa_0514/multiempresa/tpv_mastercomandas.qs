
/** @class_declaration multi */
/////////////////////////////////////////////////////////////////
//// MULTIEMPRESA ///////////////////////////////////////////////
class multi extends oficial
{
  function multi(context)
  {
    oficial(context);
  }
  function dameParamInformeVale(idTpvComanda)
  {
    return this.ctx.multi_dameParamInformeVale(idTpvComanda);
  }
  function dameParamInformeComanda(idTpvComanda)
  {
    return this.ctx.multi_dameParamInformeComanda(idTpvComanda);
  }
  function dameEmpresa()
  {
    return this.ctx.multi_dameEmpresa();
  }
  function dameWhere(codComanda)
  {
    return this.ctx.multi_dameWhere(codComanda);
  }
  function dameWhereRegalo(idComanda, cadenaDatos)
  {
    return this.ctx.multi_dameWhereRegalo(idComanda, cadenaDatos);
  }
  function dameWhereVale(idComanda)
  {
    return this.ctx.multi_dameWhereVale(idComanda);
  }
}
//// MULTIEMPRESA ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition multi */
/////////////////////////////////////////////////////////////////
//// MULTIEMPRESA //////////////////////////////////////////////

function multi_dameParamInformeVale(idTpvComanda)
{
  var _i = this.iface;
  var cursor = this.cursor();

  var oParam = _i.__dameParamInformeVale(idTpvComanda);

  var idEmpresa = _i.dameEmpresa();
  if (!idEmpresa) {
    return false;
  }
  oParam.whereFijo = "empresa.id = " + idEmpresa;
  return oParam;
}

function multi_dameParamInformeComanda(idTpvComanda)
{
  var _i = this.iface;
  var cursor = this.cursor();

  var oParam = _i.__dameParamInformeComanda(idTpvComanda);

  var idEmpresa = _i.dameEmpresa();
  if (!idEmpresa) {
    return false;
  }
  oParam.whereFijo = "empresa.id = " + idEmpresa;
  return oParam;
}

function multi_dameEmpresa()
{
  var _i = this.iface;
  var cursor = this.cursor();

  var ejercicioActual = flfactppal.iface.pub_ejercicioActual();
  var idEmpresa = AQUtil.sqlSelect("ejercicios", "idempresa", "codejercicio = '" + ejercicioActual + "'");

  return idEmpresa;
}

function multi_dameWhere(codComanda)
{
  var _i = this.iface;
  var where = _i.__dameWhere(codComanda);
  where += " AND empresa.id = " + _i.dameEmpresa();

  return where;
}

function multi_dameWhereRegalo(idComanda, cadenaDatos)
{
  var _i = this.iface;
  var where = _i.__dameWhereRegalo(idComanda, cadenaDatos);
  where += " AND empresa.id = " + _i.dameEmpresa();

  return where;
}

function multi_dameWhereVale(idComanda)
{
  var _i = this.iface;
  var where = _i.__dameWhereVale(idComanda);
  where += " AND empresa.id = " + _i.dameEmpresa();

  return where;
}
//// MULTIEMPRESA //////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
