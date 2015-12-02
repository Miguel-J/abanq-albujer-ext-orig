
/** @class_declaration balanMul08 */
/////////////////////////////////////////////////////////////////
//// BALANMUL08 //////////////////////////////////////////////////
class balanMul08 extends pgc2008
{
  function balanMul08(context)
  {
    pgc2008(context);
  }
  function popularBuffer(ejercicio: String, posicion: String, idBalance: Number, fechaDesde: String, fechaHasta: String, tablaCB: String, masWhere: String)
  {
    return this.ctx.balanMul08_popularBuffer(ejercicio, posicion, idBalance, fechaDesde, fechaHasta, tablaCB, masWhere);
  }
  /*
  function popularBufferMulti(ejercicio:String, posicion:String, idBalance:Number, fechaDesde:String, fechaHasta:String, tablaCB:String, masWhere:String, nombrebd:String) {
    return this.ctx.balanMul08_popularBufferMulti(ejercicio, posicion, idBalance, fechaDesde, fechaHasta, tablaCB, masWhere, nombrebd);
  }
  */
  function populaBuffer(oDatos)
  {
    return this.ctx.balanMul08_populaBuffer(oDatos);
  }
}
//// BALANMUL08 //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition balanMul08 */
/////////////////////////////////////////////////////////////////
//// BALANMUL08 /////////////////////////////////////////////////

function balanMul08_popularBuffer(ejercicio, posicion, idBalance, fechaDesde, fechaHasta, tablaCB, masWhere)
{
  var _i = this.iface;
  var oDatos = _i.dameDatosBuffer();
  oDatos.ejercicio = ejercicio;
  oDatos.posicion = posicion;
  oDatos.idBalance = idBalance;
  oDatos.fechaDesde = fechaDesde;
  oDatos.fechaHasta = fechaHasta;
  oDatos.tablaCB = tablaCB;
  oDatos.masWhere = masWhere;
  return _i.populaBuffer(oDatos);
}

function balanMul08_populaBuffer(oDatos)
{
  var _i = this.iface;

  /*
  var ejercicio = oDatos.ejercicio;
  var posicion = oDatos.posicion;
  var idBalance = oDatos.idBalance;
  var fechaDesde = oDatos.fechaDesde;
  var fechaHasta = oDatos.fechaHasta;
  var tablaCB = oDatos.tablaCB;
  var masWhere = oDatos.masWhere;
  var tablaCBPlan = oDatos.tablaCBPlan;
  var nombreBD = oDatos.nombreBD;
  */

  // Esta empresa
  _i.__populaBuffer(oDatos);
  //  this.iface.popularBufferMulti(ejercicio, posicion, idBalance, fechaDesde, fechaHasta, tablaCB, masWhere, sys.nameBD());


  // Otras empresas
  var curTab;
  if (oDatos.posicion == "saldoant") {
    curTab = new FLSqlCursor("co_ejerciciosempresas_08_ant");
  } else {
    curTab = new FLSqlCursor("co_ejerciciosempresas_08");
  }
  curTab.select("idbalance = " + oDatos.idBalance);
  while (curTab.next()) {
    oDatos.ejercicio = curTab.valueBuffer("codejercicio");
    oDatos.nombreBD = curTab.valueBuffer("nombrebd");
    _i.__populaBuffer(oDatos);
    //this.iface.popularBufferMulti(curTab.valueBuffer("codejercicio"), posicion, idBalance, fechaDesde, fechaHasta, tablaCB, masWhere, curTab.valueBuffer("nombrebd"));
  }
}

/*
function balanMul08_popularBufferMulti(ejercicio:String, posicion:String, idBalance:Number, fechaDesde:String, fechaHasta:String, tablaCB:String, masWhere:String, nombrebd:String)
{
  var util:FLUtil = new FLUtil();
  var from:String = "";
  var where:String = "";
  var codBalance:String;
  var codCuentaCB:String;

  var curTab:FLSqlCursor = new FLSqlCursor("co_i_balances08_datos");

  var q:FLSqlQuery = new FLSqlQuery();


  // Conectamos
  var curRem:FLSqlCursor;
  var conexion:String;
  if (nombrebd != sys.nameBD()) {
    conexion = nombrebd + "_conn";
    if (!flcontinfo.iface.pub_conectar(nombrebd))
      return;
    q = new FLSqlQuery("", conexion);
    curRem = new FLSqlCursor("ejercicios", conexion);
  }
  else {
    conexion = "default";
    q = new FLSqlQuery();
  }


  // Todas las naturalezas, se filtra más tarde
  where = "s.codejercicio = '" + ejercicio + "'";

  var idAsientoCierre:Number = util.sqlSelect("ejercicios", "idasientocierre", "codejercicio = '" + ejercicio + "'", "", conexion);
  if (idAsientoCierre)
    where += " AND a.idasiento <> " + idAsientoCierre;

  var idAsientoPyG:Number = util.sqlSelect("ejercicios", "idasientopyg", "codejercicio = '" + ejercicio + "'", "", conexion);
  if (idAsientoPyG)
    where += " AND a.idasiento <> " + idAsientoPyG;

  if (masWhere)
    where += masWhere;

  from = "co_subcuentas s INNER JOIN co_partidas p ON s.idsubcuenta = p.idsubcuenta " +
      "INNER JOIN co_asientos a ON p.idasiento = a.idasiento";

  if (fechaDesde) where += " AND a.fecha >= '" + fechaDesde + "'";
  if (fechaHasta) where += " AND a.fecha <= '" + fechaHasta + "'";

  q.setTablesList("co_subcuentas,co_asientos,co_partidas");
  q.setFrom(from);
  q.setSelect("sum(p.debe)-sum(p.haber)");


  // Bucle principal
  var qCB:FLSqlQuery = new FLSqlQuery();
  qCB.setTablesList(tablaCB + ",co_codbalances08");
  qCB.setFrom(tablaCB + " ccb INNER JOIN co_codbalances08 cb ON ccb.codbalance = cb.codbalance");
  qCB.setSelect("cb.codbalance,cb.naturaleza,ccb.codcuenta");
  qCB.setWhere("1=1 ORDER BY cb.naturaleza, cb.nivel1, cb.nivel2, cb.orden3, cb.nivel4");

  if (!qCB.exec()) {
    MessageBox.critical(util.translate("scripts", "Falló la consulta de códigos por cuenta"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return;
  }

  var paso:Number = 0;
  var suma:Number, sumaActual:Number;

  util.createProgressDialog( util.translate( "scripts", "Recabando datos..." ), qCB.size());

  while (qCB.next()) {

    codBalance = qCB.value(0);
    naturaleza = qCB.value(1);
    codCuentaCB = qCB.value(2);

    util.setProgress(paso++);
    util.setLabelText(util.translate( "scripts", "Recabando datos de la empresa %0 para el ejercicio %0\n\nAnalizando código de balance\n" ).arg(nombrebd).arg(ejercicio) + codBalance);

    // Evitamos contar dos veces casos como 281 y 2811
    q.setWhere(where + " and s.codcuenta like '" + codCuentaCB + "%' and s.codcuenta not in (select codcuenta from " + tablaCB + " where codcuenta like '" + codCuentaCB + "%' and codcuenta <> '" + codCuentaCB + "')");

    if (!q.exec()) {
      debug(util.translate("scripts", "Error buscando cuentas ") + codCuentaCB, MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
      continue;
    }

    suma = 0;
    while (q.next()) {
      suma += parseFloat(q.value(0));
    }

    // El pasivo cambia de signo
    // Si es PG siempre cambia de signo
    if (naturaleza == "P" || naturaleza == "PG")
      suma = 0 - suma;

    curTab.select("codbalance = '" + codBalance + "' and idbalance = " + idBalance);
    if (curTab.first()) {
      curTab.setModeAccess(curTab.Edit);
      curTab.refreshBuffer();
      sumaActual = parseFloat(curTab.valueBuffer(posicion));
    }
    else {
      curTab.setModeAccess(curTab.Insert);
      curTab.refreshBuffer();
      curTab.setValueBuffer("codbalance", codBalance);
      curTab.setValueBuffer("idbalance", idBalance);
      sumaActual = 0;
    }

    suma += sumaActual;

    curTab.setValueBuffer(posicion, suma);
    curTab.commitBuffer();
  }

  util.destroyProgressDialog();

  return true;
}
*/

//// BALANMUL08 /////////////////////////////////////////////////
//////////////////////////////////////////////////////////
