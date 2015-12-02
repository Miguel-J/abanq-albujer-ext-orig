
/** @class_declaration multiE */
/////////////////////////////////////////////////////////////////
//// MULTIEMPRESA ///////////////////////////////////////////////
class multiE extends oficial
{
  function multiE(context)
  {
    oficial(context);
  }
  function filtroTabla()
  {
    return this.ctx.multiE_filtroTabla();
  }
}
//// MULTIEMPRESA ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition multiE */
/////////////////////////////////////////////////////////////////
//// MULTIEMPRESA ///////////////////////////////////////////////
function multiE_filtroTabla()
{
  var util: FLUtil = new FLUtil;
  var filtro = this.iface.__filtroTabla();
  var nombre = util.translate("scripts", "Todas las empresas");

  var codEjercicio: String = flfactppal.iface.pub_ejercicioActual();
  var idEmpresa = util.sqlSelect("ejercicios", "idempresa", "codejercicio = '" + codEjercicio + "'");
  if (idEmpresa) {
    filtro += filtro != "" ? " AND " : "";
    filtro += "idempresa = " + idEmpresa;
    nombre = util.sqlSelect("empresa", "nombre", "id = " + idEmpresa);
  }
  this.child("lblEmpresa").text = nombre;

  return filtro;
}
//// MULTIEMPRESA ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
