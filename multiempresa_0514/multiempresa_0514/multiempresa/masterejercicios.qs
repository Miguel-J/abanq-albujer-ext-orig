
/** @class_declaration multiE */
/////////////////////////////////////////////////////////////////
//// FUNDACIONMF /////////////////////////////////////////
class multiE extends oficial
{
  function multiE(context)
  {
    oficial(context);
  }
  function init()
  {
    return this.ctx.multiE_init();
  }
}
//// FUNDACIONMF /////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition multiE */
/////////////////////////////////////////////////////////////////
//// MULTIEMPRESA ///////////////////////////////////////////////
function multiE_init()
{
  this.iface.__init();
  /// Se pone el return para que todos los grupos puedan ver todas las series de facturación. Esto es a raíz de la importación de datos para Juguetilandia que en algunas empresas ponía grupos de usuarios por defecto.
  return;
  var util: FLUtil;
  var filtro = "";

  var idUsuario: String = sys.nameUser();
  if (idUsuario && idUsuario != "") {
    var idGrupo: String = util.sqlSelect("flusers", "idgroup", "iduser = '" + idUsuario + "'");
    if (idGrupo && idGrupo != "") {
      filtro = "idempresa IN (SELECT idempresa FROM gruposusuariosempresa WHERE idgroup = '" + idGrupo + "')";
      if (filtro && filtro != "") {
        this.child("tableDBRecords").cursor().setMainFilter(filtro);
      }
    }
  }
}
//// MULTIEMPRESA ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
