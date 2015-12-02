
/** @class_declaration extraescolar */
/////////////////////////////////////////////////////////////////
//// EXTRAESCOLAR //////////////////////////////////////////////
class extraescolar extends oficial
{
  function extraescolar(context)
  {
    oficial(context);
  }
  function afterCommit_fo_asistenciaact(curAsistencia)
  {
    return this.ctx.extraescolar_afterCommit_fo_asistenciaact(curAsistencia);
  }
  function controlTiquesActividadesAs(curAsistencia)
  {
    return this.ctx.extraescolar_controlTiquesActividadesAs(curAsistencia);
  }
  //  function descontarTiquet(curAsistencia) {
  //    return this.ctx.extraescolar_descontarTiquet(curAsistencia);
  //  }
  //  function calcularValoresLinea(idLinea) {
  //    return this.ctx.extraescolar_calcularValoresLinea(idLinea);
  //  }
  //  function asociarAsistenciaLinea(curAsistencia, idLinea) {
  //    return this.ctx.extraescolar_asociarAsistenciaLinea(curAsistencia, idLinea);
  //  }
  //  function calcularSaldoActividad(curAsistencia) {
  //    return this.ctx.extraescolar_calcularSaldoActividad(curAsistencia);
  //  }
  //  function actualizaSaldoTiques(codActividad, codCliente) {
  //    return this.ctx.extraescolar_actualizaSaldoTiques(codActividad, codCliente);
  //  }
  //  function calcularSaldoTiquets(codCliente, codActividad) {
  //    return this.ctx.extraescolar_calcularSaldoTiquets(codCliente, codActividad);
  //  }
  //  function controlarTiquetsEsporadicos(curAsistencia) {
  //    return this.ctx.extraescolar_controlarTiquetsEsporadicos(curAsistencia);
  //  }
  function crearSaldoActividad(codCliente, codActividad)
  {
    return this.ctx.extraescolar_crearSaldoActividad(codCliente, codActividad);
  }
  function mesEnLetra(nodo, campo)
  {
    return this.ctx.extraescolar_mesEnLetra(nodo, campo);
  }
}
//// EXTRAESCOLAR //////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pubExtraescolar */
/////////////////////////////////////////////////////////////////
//// PUB_EXTRAESCOLAR ///////////////////////////////////////////
class pubExtraescolar extends ifaceCtx
{
  function pubExtraescolar(context)
  {
    ifaceCtx(context);
  }
  //  function pub_calcularSaldoActividad(curAsistencia) {
  //    return this.calcularSaldoActividad(curAsistencia);
  //  }
  //  function pub_calcularValoresLinea(idLinea) {
  //    return this.calcularValoresLinea(idLinea);
  //  }
  //  function pub_calcularSaldoTiquets(codCliente, codActividad) {
  //    return this.calcularSaldoTiquets(codCliente, codActividad);
  //  }
  function pub_mesEnLetra(nodo, campo)
  {
    return this.mesEnLetra(nodo, campo);
  }
  //  function pub_actualizaSaldoTiques(codActividad, codCliente) {
  //    return this.actualizaSaldoTiques(codActividad, codCliente);
  //  }
  function pub_crearSaldoActividad(codCliente, codActividad)
  {
    return this.crearSaldoActividad(codCliente, codActividad);
  }
  function pub_controlTiquesActividadesAs(curAsistencia)
  {
    return this.controlTiquesActividadesAs(curAsistencia);
  }
}

//// PUB_EXTRAESCOLAR ///////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition extraescolar */
/////////////////////////////////////////////////////////////////
//// EXTRAESCOLAR ///////////////////////////////////////////////
function extraescolar_afterCommit_fo_asistenciaact(curAsistencia)
{
  //  if (!this.iface.controlarTiquetsEsporadicos(curAsistencia)) {
  //    return false;
  //  }
  if (!this.iface.controlTiquesActividadesAs(curAsistencia)) {
    return false;
  }
  return true;
}

function extraescolar_controlTiquesActividadesAs(curAsistencia)
{
  var util = new FLUtil();

  var codActividad = curAsistencia.valueBuffer("codactividad");
  var codCliente = util.sqlSelect("fo_alumnos", "codcliente", "codalumno = '" + curAsistencia.valueBuffer("codalumno") + "'");
  if (!codCliente) {
    return true; /// Temporal porque hay alumnos sin cliente false;
  }

  var idSaldo = util.sqlSelect("fo_saldotiquetactcli", "id", "codcliente = '" + codCliente + "' AND codactividad = '" + codActividad + "'");
  if (!idSaldo) {
    idSaldo = flformppal.iface.crearSaldoActividad(codCliente, codActividad);
    if (!idSaldo) {
      return false;
    }
  }
  var curSaldo = new FLSqlCursor("fo_saldotiquetactcli");
  curSaldo.select("id = " + idSaldo);
  if (!curSaldo.first()) {
    return false;
  }
  curSaldo.setModeAccess(curSaldo.Edit);
  curSaldo.refreshBuffer();
  curSaldo.setValueBuffer("usado", formRecordfo_saldotiquetactcli.iface.pub_commonCalculateField("usado", curSaldo));
  curSaldo.setValueBuffer("saldo", formRecordfo_saldotiquetactcli.iface.pub_commonCalculateField("saldo", curSaldo));
  if (!curSaldo.commitBuffer()) {
    return false;
  }
  return true;
}

// function extraescolar_controlarTiquetsEsporadicos(curAsistencia)
// {
//  if (curAsistencia.valueBuffer("asistencia") == "E") {
//    switch (curAsistencia.modeAccess()) {
//      case curAsistencia.Insert: {
//        if (!this.iface.descontarTiquet(curAsistencia)) {
//          return false;
//        }
//        break;
//      }
//      case curAsistencia.Edit: {
//        if (curAsistencia.valueBuffer("asistencia") != curAsistencia.valueBufferCopy("asistencia")) {
//          if (!this.iface.descontarTiquet(curAsistencia)) {
//            return false;
//          }
//        }
//        break;
//      }
//      case curAsistencia.Del: {
//        if (curAsistencia.valueBuffer("idlineapedidocli")) {
//          if (!this.iface.calcularValoresLinea(curAsistencia.valueBuffer("idlineapedidocli"))) {
//            return false;
//          }
//        }
//        break;
//      }
//    }
//    if (!this.iface.calcularSaldoActividad(curAsistencia)) {
//      return false;
//    }
//  }
//  return true;
// }
//
//
// function extraescolar_descontarTiquet(curAsistencia)
// {
//  var util = new FLUtil();
//  var codCliente = util.sqlSelect("fo_alumnos", "codcliente", "codalumno = '" + curAsistencia.valueBuffer("codalumno") + "'");
//  var alumno = util.sqlSelect("fo_alumnos", "nombre", "codalumno = '" + curAsistencia.valueBuffer("codalumno") + "'");
//  if (!codCliente || codCliente == ""){
//    MessageBox.information(util.translate("scripts","El alumno %1 no tiene cliente asociado").arg(alumno),MessageBox.Ok, MessageBox.NoButton);
//    return false;
//  }
//  var refEsp = util.sqlSelect("fo_actividades", "refasistenciaesp", "codactividad = '" + curAsistencia.valueBuffer("codactividad") + "'");
//  if (!refEsp || refEsp == "") {
//    MessageBox.information(util.translate("scripts","No tiene artículo asociado en la referencia esporádica de la actividad %1.").arg(curAsistencia.valueBuffer("codactividad")),MessageBox.Ok, MessageBox.NoButton);
//    return false;
//  }
//  var qryLP = new FLSqlQuery;
//  qryLP.setTablesList("pedidoscli,lineaspedidoscli");
//  qryLP.setSelect("idlinea");
//  qryLP.setFrom("pedidoscli p INNER JOIN lineaspedidoscli l ON p.idpedido = l.idpedido");
//  qryLP.setWhere("p.codcliente = '" + codCliente + "' AND l.restante > 0 AND l.referencia = '" + refEsp + "'");
//  qryLP.setForwardOnly(true);
//
//  if (!qryLP.exec()) {
//    return false;
//  }
//  if (qryLP.first()) {
//    if (!this.iface.asociarAsistenciaLinea(curAsistencia, qryLP.value("idlinea"))) {
//      return false;
//    }
//    if (!this.iface.calcularValoresLinea(qryLP.value("idlinea"))) {
//      return false;
//    }
//  } /*else {
//    var cliente = util.sqlSelect("clientes", "nombre", "codcliente = '" + codCliente + "'");
//    var actividad = util.sqlSelect("fo_actividades", "descripcion", "codactividad = '" + curAsistencia.valueBuffer("codactividad") + "'");
//    MessageBox.warning(util.translate("scripts","El cliente %1 no tiene crédito para que %2 asista a %3").arg(cliente).arg(alumno).arg(actividad),MessageBox.Ok, MessageBox.NoButton);
//    return true;
//  }*/
//
//  return true;
// }
//
// function extraescolar_asociarAsistenciaLinea(curAsistencia, idLinea)
// {
//  var curA = new FLSqlCursor("fo_asistenciaact");
//  curA.select("id = " + curAsistencia.valueBuffer("id"));
//  if (!curA.first()) {
//    return false;
//  }
//  curA.setModeAccess(curA.Edit);
//  curA.refreshBuffer();
//  curA.setValueBuffer("idlineapedidocli", idLinea);
//  if (!curA.commitBuffer()) {
//    return false;
//  }
//  return true;
// }
//
// function extraescolar_calcularValoresLinea(idLinea)
// {
//  var curLinea = new FLSqlCursor("lineaspedidoscli");
//  curLinea.select("idlinea = " + idLinea);
//  if (!curLinea.first()) {
//    return false;
//  }
//  curLinea.setActivatedCommitActions(false);
//  curLinea.setModeAccess(curLinea.Edit);
//  curLinea.refreshBuffer();
//  curLinea.setValueBuffer("usado", formRecordlineaspedidoscli.iface.pub_commonCalculateField("usado", curLinea));
//  curLinea.setValueBuffer("restante", formRecordlineaspedidoscli.iface.pub_commonCalculateField("restante", curLinea));
//  if (!curLinea.commitBuffer()) {
//    return false;
//  }
//  return true;
// }
//
// function extraescolar_calcularSaldoActividad(curAsistencia)
// {
//  var util = new FLUtil();
//  var codCliente = util.sqlSelect("fo_alumnos", "codcliente", "codalumno = '" + curAsistencia.valueBuffer("codalumno") + "'");
//  var codActividad = curAsistencia.valueBuffer("codactividad");
//  if (!this.iface.actualizaSaldoTiques(codActividad, codCliente)) {
//    return false;
//  }
//  return true;
// }
//
// function extraescolar_actualizaSaldoTiques(codActividad, codCliente)
// {
//  var util = new FLUtil();
//  var curSaldo = new FLSqlCursor("fo_saldotiquetactcli");
//  curSaldo.select("codcliente = '" + codCliente + "' AND codactividad = '" + codActividad + "'");
//  if (curSaldo.first()) {
//    curSaldo.setModeAccess(curSaldo.Edit);
//    curSaldo.refreshBuffer();
//  } else {
//    curSaldo.setModeAccess(curSaldo.Insert);
//    curSaldo.refreshBuffer();
//    curSaldo.setValueBuffer("codcliente", codCliente);
//    curSaldo.setValueBuffer("codactividad", codActividad);
//  }
//
//  var saldo = this.iface.calcularSaldoTiquets(codCliente, codActividad);
//  curSaldo.setValueBuffer("saldo", saldo);
//  if (!curSaldo.commitBuffer()) {
//    return false;
//  }
//  return true;
// }
//
// function extraescolar_calcularSaldoTiquets(codCliente, codActividad)
// {debug("extraescolar_calcularSaldoTiquets");
//
//  var util = new FLUtil();
//  var refEsp = util.sqlSelect("fo_actividades", "refasistenciaesp",  "codactividad = '" + codActividad + "'");
//  var restanteLineas = util.sqlSelect("lineaspedidoscli l INNER JOIN pedidoscli p ON p.idpedido = l.idpedido", "SUM(l.restante)", "p.codcliente = '" + codCliente + "' AND l.referencia = '" + refEsp + "'", "lineaspedidoscli,pedidoscli");
//  if (!restanteLineas || isNaN(restanteLineas)) {
//    restanteLineas = 0;
//  }
// //   var alumnos = "";
// //   var qryAlumnos = new FLSqlQuery;
// //   qryAlumnos.setTablesList("fo_alumnos");
// //   qryAlumnos.setSelect("codalumno");
// //   qryAlumnos.setFrom("fo_alumnos");
// //   qryAlumnos.setWhere("codcliente = '" + codCliente + "'");
// //   qryAlumnos.setForwardOnly(true);
// //
// //   if (!qryAlumnos.exec()) {
// //     return false;
// //   }
// //   while (qryAlumnos.next()) {
// //     if (alumnos && alumnos != "") {
// //       alumnos += ", ";
// //     }
// //     alumnos += "'" + qryAlumnos.value("codalumno") + "'";
// //   }
//
//  var actSinLinea = util.sqlSelect("fo_asistenciaact ac INNER JOIN fo_alumnos a ON a.codalumno = ac.codalumno", "COUNT(*)", "ac.idlineapedidocli IS NULL AND ac.codactividad = '" + codActividad + "' AND a.codcliente = '" + codCliente + "'", "fo_asistenciaact,fo_alumnos" );
//  if (!actSinLinea || isNaN(actSinLinea)) {
//    actSinLinea = 0;
//  }
//  var saldo = parseFloat(restanteLineas - actSinLinea);
// debug("saldo " + saldo);
//  return saldo;
// }

function extraescolar_crearSaldoActividad(codCliente, codActividad)
{
  var curSaldo = new FLSqlCursor("fo_saldotiquetactcli");
  curSaldo.setModeAccess(curSaldo.Insert);
  curSaldo.refreshBuffer();
  curSaldo.setValueBuffer("codcliente", codCliente);
  curSaldo.setValueBuffer("codactividad", codActividad);
  if (!curSaldo.commitBuffer()) {
    return false;
  }
  return curSaldo.valueBuffer("id");
}

function extraescolar_mesEnLetra(nodo, campo)
{
  var valor;
  switch (nodo.attributeValue(campo)) {
    case "1": {
      valor = "Enero";
      break;
    }
    case "2": {
      valor = "Febrero";
      break;
    }
    case "3": {
      valor = "Marzo";
      break;
    }
    case "4": {
      valor = "Abril";
      break;
    }
    case "5": {
      valor = "Mayo";
      break;
    }
    case "6": {
      valor = "Junio";
      break;
    }
    case "7": {
      valor = "Julio";
      break;
    }
    case "8": {
      valor = "Agosto";
      break;
    }
    case "9": {
      valor = "Septiembre";
      break;
    }
    case "10": {
      valor = "Octubre";
      break;
    }
    case "11": {
      valor = "Noviembre";
      break;
    }
    case "12": {
      valor = "Diciembre";
      break;
    }
  }

  return valor;
}

//// EXTRAESCOLAR ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
