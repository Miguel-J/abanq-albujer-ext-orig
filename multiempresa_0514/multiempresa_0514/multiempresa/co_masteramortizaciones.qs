
/** @class_declaration multi */
/////////////////////////////////////////////////////////////////
//// MULTIEMPRESA ///////////////////////////////////////////////
class multi extends oficial
{
  function multi(context)
  {
    oficial(context);
  }
  function filtroTabla(): String {
    return this.ctx.multi_filtroTabla();
  }
  function dameFiltroGenerarDotaciones()
  {
    return this.ctx.multi_dameFiltroGenerarDotaciones();
  }
}
//// MULTIEMPRESA ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition multi */
/////////////////////////////////////////////////////////////////
//// MULTIEMPRESA ///////////////////////////////////////////////
function multi_filtroTabla(): String {
  var util: FLUtil = new FLUtil;
  var filtro = this.iface.__filtroTabla();
  var nombre = util.translate("scripts", "Todas las empresas");

  var codEjercicio: String = flfactppal.iface.pub_ejercicioActual();
  var idEmpresa = util.sqlSelect("ejercicios", "idempresa", "codejercicio = '" + codEjercicio + "'");
  if (idEmpresa)
  {
    filtro += filtro != "" ? " AND " : "";
    filtro += "idempresa = " + idEmpresa;
    nombre = util.sqlSelect("empresa", "nombre", "id = " + idEmpresa);
  }
  this.child("lblEmpresa").text = nombre;

  return filtro;
}

function multi_dameFiltroGenerarDotaciones()
{
  var util = new FLUtil;
  var filtro = this.iface.__dameFiltroGenerarDotaciones();
  var codEjercicio: String = flfactppal.iface.pub_ejercicioActual();
  var idEmpresa = util.sqlSelect("ejercicios", "idempresa", "codejercicio = '" + codEjercicio + "'");
  if (idEmpresa) {
    filtro = "idempresa = " + idEmpresa + " AND " + filtro;
  }
  return filtro;
}
//// MULTIEMPRESA ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
