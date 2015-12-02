
/** @class_declaration cCoste */
/////////////////////////////////////////////////////////////////////
//// CENTROS DE COSTE ///////////////////////////////////////////////
class cCoste extends oficial
{
  function cCoste(context)
  {
    oficial(context);
  }
  function init()
  {
    return this.ctx.cCoste_init();
  }
  function filtrarTabla()
  {
    return this.ctx.cCoste_filtrarTabla();
  }
}
//// CENTROS DE COSTE ///////////////////////////////////////////////
////////////////////////////////////////////////////////////////////

/** @class_definition cCoste */
/////////////////////////////////////////////////////////////////////
//// CENTROS DE COSTE ///////////////////////////////////////////////
function cCoste_init()
{
  this.iface.__init();

  this.iface.filtrarTabla();
}

function cCoste_filtrarTabla()
{
  var util: FLUtil;
  var cursor = this.cursor();

  var idGrupo = util.sqlSelect("flusers", "idgroup", "iduser = '" + sys.nameUser() + "'");
  if (!idGrupo) {
    return;
  }
  var qryP = new FLSqlQuery;
  qryP.setTablesList("gruposusuarioscc,centroscoste");
  qryP.setSelect("cc.factoracceso");
  qryP.setFrom("gruposusuarioscc gc INNER JOIN centroscoste cc ON gc.codcentro = cc.codcentro");
  qryP.setWhere("gc.idgroup = '" + idGrupo + "'");
  qryP.setForwardOnly(true);
  if (!qryP.exec()) {
    return;
  }

  var factorUsuario = 0;
  var factorCC;
  while (qryP.next()) {
    factorCC = qryP.value("cc.factoracceso");
    if (!isNaN(factorCC)) {
      factorUsuario += Math.pow(2, factorCC);
    }
  }
  if (factorUsuario == 0) {
    return;
  }

  var filtro = cursor.mainFilter();
  if (filtro != "")
    filtro += " AND ";
  filtro += "(factoracceso = 0 OR CAST(factoracceso AS BIGINT) & " + factorUsuario + " <> 0)";

  cursor.setMainFilter(filtro);
}
//// CENTROS DE COSTE ///////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
