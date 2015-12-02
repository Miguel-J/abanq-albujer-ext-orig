
/** @class_declaration multiempcc */
/////////////////////////////////////////////////////////////////
//// MULTIEMPRESA + CC  //////////////////////////////////
class multiempcc extends oficial
{
  function multiempcc(context)
  {
    oficial(context);
  }
  function init()
  {
    this.ctx.multiempcc_init();
  }
  function dameFiltroCC(): String {
    return this.ctx.multiempcc_dameFiltroCC();
  }
}
//// MULTIEMPRESA + CC  //////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition multiempcc */
/////////////////////////////////////////////////////////////////
//// MULTIEMPRESA + CC  //////////////////////////////////
function multiempcc_init()
{
  this.iface.__init();

  connect(this.child("chkTodasEmpresas"), "clicked()", this, "iface.filtrarTabla()");
}

function multiempcc_dameFiltroCC(): String {
  var util: FLUtil;
  var filtro = this.iface.__dameFiltroCC();

  if (this.child("chkTodasEmpresas").checked)
    return filtro;

  var codEjercicio = flfactppal.iface.pub_ejercicioActual();
  var idEmpresa = util.sqlSelect("ejercicios", "idempresa", "codejercicio = '" + codEjercicio + "'");
  if (!idEmpresa)
    return filtro;

  var qry: FLSqlQuery = new FLSqlQuery();
  qry.setTablesList("centroscoste");
  qry.setSelect("codcentro");
  qry.setFrom("centroscoste")
  qry.setWhere("idempresa = " + idEmpresa);
  qry.setForwardOnly(true);
  if (!qry.exec())
    return filtro;

  var listaCC = "";
  while (qry.next())
  {
    if (listaCC != "")
      listaCC += ",";
    listaCC += "'" + qry.value("codcentro") + "'";
  }

  if (listaCC != "")
  {
    if (filtro != "") {
      filtro += " AND "
    }
    filtro += "codcentro IN (" + listaCC + ")";
  } else {
    if (filtro != "")
    {
      filtro += " AND "
    }
    filtro += " 1 = 2";
  }

  return filtro;
}
//// MULTIEMPRESA + CC  //////////////////////////////////
/////////////////////////////////////////////////////////////////
