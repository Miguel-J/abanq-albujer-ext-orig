
/** @class_declaration cCoste */
/////////////////////////////////////////////////////////////////
//// CENTROS DE COSTE ///////////////////////////////////////////
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
  function tbnActualizarPartidasCC_clicked()
  {
    return this.ctx.cCoste_tbnActualizarPartidasCC_clicked();
  }
}
//// CENTROS DE COSTE ///////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition cCoste */
/////////////////////////////////////////////////////////////////
//// CENTROS DE COSTE ///////////////////////////////////////////
function cCoste_init()
{
  var _i = this.iface;
  _i.__init();

  connect(this.child("tbnActualizarPartidasCC"), "clicked()", _i, "tbnActualizarPartidasCC_clicked");
}

function cCoste_tbnActualizarPartidasCC_clicked()
{
  var util = new FLUtil;
  var r = MessageBox.warning(util.translate("scripts", "Va a generar los registros de la tabla de distibución de partidas por centros de coste para aquellos asientos que:\n1. Tienen centro de coste informado\n2. Algunas de sus partidas son del grupo 6 o 7 y no tienen información de centro de coste.\n¿Está seguro?"), MessageBox.Yes, MessageBox.No, MessageBox.NoButton, "AbanQ");
  if (r != MessageBox.Yes) {
    return true;
  }
  var q = new FLSqlQuery;
  q.setSelect("a.idasiento, a.codcentro, a.codsubcentro");
  q.setFrom("co_asientos a inner join co_partidas p on a.idasiento = p.idasiento left outer join co_partidascc pcc on p.idpartida = pcc.idpartida");
  q.setWhere("a.codcentro is not null and pcc.idpartida is null and (p.codsubcuenta like '6%' OR p.codsubcuenta like '7%')");
  q.setForwardOnly(true);
  if (!q.exec()) {
    return false;
  }
  var idAsiento, codCentro, codSubcentro;
  util.createProgressDialog(util.translate("scripts", "Distribuyendo partidas por centro de coste..."), q.size());
  var paso = 0;
  while (q.next()) {
    util.setProgress(paso++);
    idAsiento = q.value("a.idasiento");

    codCentro = q.value("a.codcentro");
    codSubcentro = q.value("a.codsubcentro");
    if (!flcontppal.iface.pub_crearCentrosCosteAsiento(idAsiento, codCentro, codSubcentro)) {
      util.destroyProgressDialog();
      return false;
    }
    if (!flcontppal.iface.pub_comprobarCentrosCosteGrupos6y7(idAsiento)) {
      util.destroyProgressDialog();
      return false;
    }
  }
  util.destroyProgressDialog();
  MessageBox.information(util.translate("scripts", "Actualización completada. Se distribuyeron %1 asientos").arg(paso), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton, "AbanQ");
  return true;
}
//// CENTROS DE COSTE ///////////////////////////////////////////
/////////////////////////////////////////////////////////////////
