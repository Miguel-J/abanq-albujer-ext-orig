
/** @class_declaration redondeo */
/////////////////////////////////////////////////////////////////
//// REDONDEO ///////////////////////////////////////////////////
class redondeo extends oficial
{
  function redondeo(context)
  {
    oficial(context);
  }
  function init()
  {
    return this.ctx.redondeo_init();
  }
  function redondearEjercicio()
  {
    return this.ctx.redondeo_redondearEjercicio();
  }
  function comprobarSaldos(codEjercicio): Boolean {
    return this.ctx.redondeo_comprobarSaldos(codEjercicio);
  }
}
//// REDONDEO ///////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition redondeo */
//////////////////////////////////////////////////////////////////
//// REDONDEO ////////////////////////////////////////////////////
function redondeo_init()
{
  this.iface.__init();

  var tbnRedondear: Object = this.child("tbnRedondear");
  if (tbnRedondear) {
    connect(tbnRedondear, "clicked()", this, "iface.redondearEjercicio");
  }
}

function redondeo_redondearEjercicio()
{
  var codEjercicio: String = flfactppal.iface.pub_ejercicioActual();
  var util: FLUtil = new FLUtil;

  var res: Number = MessageBox.warning(util.translate("scripts", "Va a redondear los asientos del ejercicio %1\n¿Está seguro?").arg(codEjercicio), MessageBox.Yes, MessageBox.No);
  if (res != MessageBox.Yes)
    return;
  var qryAsientos: FLSqlQuery = new FLSqlQuery();
  with(qryAsientos) {
    setTablesList("co_asientos");
    setSelect("idasiento");
    setFrom("co_asientos");
    setWhere("codejercicio = '" + codEjercicio + "'");
    setForwardOnly(true);
  }
  if (!qryAsientos.exec())
    return false;

  util.createProgressDialog(util.translate("sctips", "Redondeando asientos ejercicio %1").arg(codEjercicio), qryAsientos.size());
  var progreso: Number = 0;
  var curPartidas: FLSqlCursor = new FLSqlCursor("co_partidas");
  curPartidas.setActivatedCommitActions(false);
  var numPartidas: Number;
  var totalPartidas: Number;
  var acumDebe: Number;
  var acumHaber: Number;
  var debe: Number;
  var haber: Number;
  var saldo: Number;
  while (qryAsientos.next()) {
    curPartidas.select("idasiento = " + qryAsientos.value("idasiento"));
    totalPartidas = curPartidas.size();
    acumDebe = 0;
    acumHaber = 0;
    numPartidas = 0;
    while (curPartidas.next()) {
      curPartidas.setModeAccess(curPartidas.Edit);
      curPartidas.refreshBuffer();
      numPartidas++;
      if (numPartidas < totalPartidas) {
        debe = parseFloat(curPartidas.valueBuffer("debe"));
        if (!debe || isNaN(debe))
          debe = 0;
        debe = util.roundFieldValue(debe, "co_partidas", "debe");
        acumDebe += parseFloat(debe);
        haber = parseFloat(curPartidas.valueBuffer("haber"));
        if (!haber || isNaN(haber))
          haber = 0;
        haber = util.roundFieldValue(haber, "co_partidas", "haber");
        acumHaber += parseFloat(haber);
        curPartidas.setValueBuffer("debe", debe);
        curPartidas.setValueBuffer("haber", haber);
      } else {
        saldo = acumDebe - acumHaber;
        if (parseFloat(curPartidas.valueBuffer("debe")) == 0) {
          curPartidas.setValueBuffer("debe", util.roundFieldValue(0, "co_partidas", "debe"));
          curPartidas.setValueBuffer("haber", util.roundFieldValue(saldo, "co_partidas", "haber"));
        } else {
          saldo = saldo * -1;
          curPartidas.setValueBuffer("debe", util.roundFieldValue(saldo, "co_partidas", "debe"));
          curPartidas.setValueBuffer("haber", util.roundFieldValue(0, "co_partidas", "haber"));
        }
      }
      if (!curPartidas.commitBuffer())
        return false;
    }
    util.setProgress(++progreso);
  }
  util.destroyProgressDialog();
  this.iface.comprobarSaldos(codEjercicio);
}

function redondeo_comprobarSaldos(codEjercicio: String): Boolean {
  var util: FLUtil = new FLUtil;

  var qrySaldos: FLSqlQuery = new FLSqlQuery;
  qrySaldos.setTablesList("co_subcuentas");
  qrySaldos.setSelect("idsubcuenta");
  qrySaldos.setFrom("co_subcuentas");
  qrySaldos.setWhere("codejercicio = '" + codEjercicio + "'");
  qrySaldos.setForwardOnly(true);
  if (!qrySaldos.exec())
    return false;

  util.createProgressDialog(util.translate("scripts", "Revisando saldos"), qrySaldos.size());
  var progress: Number = 0;
  while (qrySaldos.next())
  {
    util.setProgress(progress++);
    if (!flcontppal.iface.pub_calcularSaldo(qrySaldos.value(0))) {
      util.destroyProgressDialog();
      return false;
    }
  }
  util.destroyProgressDialog();
  return true;
}
//// REDONDEO ////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////