
/** @class_declaration multi */
/////////////////////////////////////////////////////////////////
//// MULTIEMPRESA ///////////////////////////////////////////////
class multi extends oficial
{
  function multi(context)
  {
    oficial(context);
  }
  function valorDefectoEmpresa(fN, idEmpresa)
  {
    return this.ctx.multi_valorDefectoEmpresa(fN, idEmpresa);
  }
  function ejercicioActual(): String {
    return this.ctx.multi_ejercicioActual();
  }
  function empresaActual(): String {
    return this.ctx.multi_empresaActual();
  }
  function extension(nE)
  {
    return this.ctx.multi_extension(nE);
  }
}
//// MULTIEMPRESA ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pubMulti */
/////////////////////////////////////////////////////////////////
//// PUBMULTI ////////////////////////////////////////////////
class pubMulti extends ifaceCtx
{
  function pubMulti(context)
  {
    ifaceCtx(context);
  }
  function pub_empresaActual(): String {
    return this.empresaActual();
  }
}
//// PUBMULTI ////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition multi */
/////////////////////////////////////////////////////////////////
//// MULTIEMPRESA ///////////////////////////////////////////////
function multi_valorDefectoEmpresa(fN, idEmpresa)
{
  if (idEmpresa) {
    return AQUtil.sqlSelect("empresa", fN, "id = " + idEmpresa);
  }
  var codEjercicio: String = this.iface.ejercicioActual()
                             var query = new FLSqlQuery();

  query.setTablesList("empresa,ejercicios");
  try {
    query.setForwardOnly(true);
  } catch (e) {}
  query.setSelect("em." + fN);
  query.setFrom("ejercicios ej INNER JOIN empresa em ON ej.idempresa = em.id");
  query.setWhere("ej.codejercicio = '" + codEjercicio + "'");
  if (!query.exec()) {
    return "";
  }
  if (!query.next()) {
    return "";
  }
  return query.value(0);
}

/** \D Devuelve el ejercicio actual para el usuario conectado
@return codEjercicio: Código del ejercicio actual
\end */
function multi_ejercicioActual(): String {
  var util: FLUtil = new FLUtil;
  var codEjercicio: String
  try {
    var settingKey: String = "ejerUsr_" + sys.nameUser();
    codEjercicio = util.readDBSettingEntry(settingKey);
  } catch (e) {}

  if (!codEjercicio)
  {
    /// Se evita un bucle sin fin al no llamar a valorDefectoEmpresa
    codEjercicio = util.sqlSelect("empresa", "codejercicio", "1 = 1");
  }

  return codEjercicio;
}

/** \D Devuelve la empresa actual según el ejercicio actual
@return idEmpresa: Identificador de la empresa actual
\end */
function multi_empresaActual(): String {
  var _i = this.iface;
  var codEjercicio = _i.ejercicioActual();
  if (!codEjercicio || codEjercicio == "")
  {
    MessageBox.warning(AQUtil.translate("scripts", "No se encontró el ejercicio actual"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }

  var idEmpresa = AQUtil.sqlSelect("ejercicios", "idempresa", "codejercicio = '" + codEjercicio + "'");
  if (!idEmpresa)
  {
    MessageBox.warning(AQUtil.translate("scripts", "No se encontró la empresa para el ejercicio actual"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }

  return idEmpresa;
}

function multi_extension(nE)
{
  var _i = this.iface;
  if (nE == "multiempresa") {
    return true;
  }
  return _i.__extension(nE);
}
//// MULTIEMPRESA ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
