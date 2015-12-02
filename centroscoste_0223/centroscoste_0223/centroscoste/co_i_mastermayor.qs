
/** @class_declaration centrosCoste */
//////////////////////////////////////////////////////////////////
//// CENTROS COSTE /////////////////////////////////////////////////
class centrosCoste extends oficial
{
  var subtotalDCC_, subtotalHCC_, whereCC_;
  function centrosCoste(context)
  {
    oficial(context);
  }
  function lanzar()
  {
    return this.ctx.centrosCoste_lanzar();
  }
  function subTotalMayor(nodo: FLDomNode, campo: String): String {
    return this.ctx.centrosCoste_subTotalMayor(nodo, campo);
  }
  function saldoInicial(nodo, campo)
  {
    return this.ctx.centrosCoste_saldoInicial(nodo, campo);
  }
  function saldoActual(nodo, campo)
  {
    return this.ctx.centrosCoste_saldoActual(nodo, campo);
  }
}
//// CENTROS COSTE /////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_definition centrosCoste */
/////////////////////////////////////////////////////////////////
//// CENTROS COSTE /////////////////////////////////////////////
function centrosCoste_lanzar()
{
  var cursor: FLSqlCursor = this.cursor()
                            if (!cursor.isValid())
                              return;

  var idInforme: Number = cursor.valueBuffer("id");

  var q: FLSqlQuery = new FLSqlQuery;

  q.setTablesList("co_i_centrosmayor");
  q.setFrom("co_i_centrosmayor");
  q.setSelect("codcentro");
  q.setWhere("idinforme = " + idInforme);
  if (!q.exec())
    return;

  if (!q.size())
    return this.iface.__lanzar();

  var listaCentros: String = "";
  while (q.next()) {
    if (listaCentros)
      listaCentros += ",";
    listaCentros += "'" + q.value(0) + "'";
  }

  q.setTablesList("co_i_subcentrosmayor");
  q.setFrom("co_i_subcentrosmayor");
  q.setSelect("codsubcentro");
  q.setWhere("idinforme = " + idInforme);
  if (!q.exec())
    return;

  var listaSubcentros: String = "";
  while (q.next()) {
    if (listaSubcentros)
      listaSubcentros += ",";
    listaSubcentros += "'" + q.value(0) + "'";
  }

  var masWhere: String;
  if (listaSubcentros)
    masWhere = " AND co_partidascc.codsubcentro IN (" + listaSubcentros + ")";
  else
    masWhere = " AND co_partidascc.codcentro IN (" + listaCentros + ")";


  this.iface.ultimaSubcuenta = 0;
  this.iface.calcularSaldoInicial = cursor.valueBuffer("saldoinicial");

  var orderBy: String = "";
  var o: String = "";
  for (var i: Number = 1; i <= 1; i++) {
    o = this.iface.obtenerOrden(i, cursor);
    if (o) {
      if (orderBy == "")
        orderBy = o;
      else
        orderBy += ", " + o;
    }
  }
  this.iface.whereCC_ = masWhere;
  var groupBy: String = "co_subcuentas.idsubcuenta, co_subcuentas.codsubcuenta, co_subcuentas.descripcion, co_subcuentas.debe, co_subcuentas.haber, co_subcuentas.saldo, co_asientos.numero, co_asientos.fecha, co_partidas.concepto, co_partidas.debe, co_partidas.haber";

  flcontinfo.iface.pub_lanzarInforme(cursor, "co_i_mayor_cc", "co_i_mayor_cc", orderBy, groupBy, masWhere, cursor.valueBuffer("id"));
}

function centrosCoste_subTotalMayor(nodo: FLDomNode, campo: String): String {
  //debug("centrosCoste_subTotalMayor " + campo);
  if (campo != "subTotalCC")
    return this.iface.__subTotalMayor(nodo, campo);

  var debe: Number = nodo.attributeValue("co_partidas.debe");
  var haber: Number = nodo.attributeValue("co_partidas.haber");

  var saldo = nodo.attributeValue("SUM(co_partidascc.importe)");
  saldo = isNaN(saldo) ? 0 : saldo;
  //debug("D " + debe + " H " + haber + " S " + saldo);
  if (haber != 0)
  {
    this.iface.subtotalHCC_ += parseFloat(saldo);
    saldo = saldo * -1;
  } else {
    this.iface.subtotalDCC_ += parseFloat(saldo);
  }
  this.iface.saldoAcumulado += parseFloat(saldo);
  // debug("saldo " + saldo + " SA " + this.iface.saldoAcumulado);
  return this.iface.saldoAcumulado;
}

function centrosCoste_saldoInicial(nodo, campo)
{
  debug("centrosCoste_saldoInicial " + campo);
  this.iface.subtotalDCC_ = 0;
  this.iface.subtotalHCC_ = 0;

  if (campo != "subTotalCC") {
    return this.iface.__saldoInicial(nodo, campo);
  }
  if (!this.iface.calcularSaldoInicial) {
    this.iface.saldoAcumulado = 0;
    return 0;
  }
  var util: FLUtil;
  var idSubcuenta: Number = nodo.attributeValue("co_subcuentas.idsubcuenta");
  var fecha: String = nodo.attributeValue("co_asientos.fecha");
  var saldoInicialD = util.sqlSelect("co_partidas p INNER JOIN co_asientos a ON p.idasiento = a.idasiento INNER JOIN co_partidascc ON p.idpartida = co_partidascc.idpartida", "SUM(co_partidascc.importe)", "p.idsubcuenta = " + idSubcuenta + " AND a.fecha < '" + fecha + "' AND p.debe >= p.haber" + this.iface.whereCC_, "co_partidas,co_asientos");
  saldoInicialD = isNaN(saldoInicialD) ? 0 : saldoInicialD;
  var saldoInicialH = util.sqlSelect("co_partidas p INNER JOIN co_asientos a ON p.idasiento = a.idasiento INNER JOIN co_partidascc ON p.idpartida = co_partidascc.idpartida", "SUM(co_partidascc.importe)", "p.idsubcuenta = " + idSubcuenta + " AND a.fecha < '" + fecha + "' AND p.haber > p.debe" + this.iface.whereCC_, "co_partidas,co_asientos");
  saldoInicialH = isNaN(saldoInicialH) ? 0 : saldoInicialH;
  saldoInicial = saldoInicialD - saldoInicialH;

  debug("saldoInicialD " + saldoInicialD + " saldoInicialH " + saldoInicialH + " saldoInicial " + saldoInicial);
  this.iface.saldoAcumulado = saldoInicial;
  return saldoInicial;
}

function centrosCoste_saldoActual(nodo, campo)
{
  switch (campo) {
    case "debeCC": {
      return this.iface.subtotalDCC_;
      break;
    }
    case "haberCC": {
      return this.iface.subtotalHCC_;
      break;
    }
    default: {
      return this.iface.__saldoActual(nodo, campo);
      break;
    }
  }
}
//// CENTROS COSTE /////////////////////////////////////////////
////////////////////////////////////////////////////////////////
