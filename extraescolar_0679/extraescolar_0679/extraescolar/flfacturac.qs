
/** @class_declaration extraescolar */
/////////////////////////////////////////////////////////////////
//// EXTRAESCOLAR //////////////////////////////////////////////
class extraescolar extends factPeriodica
{
  function extraescolar(context)
  {
    factPeriodica(context);
  }
  function afterCommit_lineasfacturascli(curLF)
  {
    return this.ctx.extraescolar_afterCommit_lineasfacturascli(curLF);
  }
  function controlTiquesActividadesLF(curLP)
  {
    return this.ctx.extraescolar_controlTiquesActividadesLF(curLP);
  }
}
//// EXTRAESCOLAR //////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition extraescolar */
/////////////////////////////////////////////////////////////////
//// EXTRAESCOLAR //////////////////////////////////////////////
function extraescolar_afterCommit_lineasfacturascli(curLF)
{
  if (!this.iface.__afterCommit_lineasfacturascli(curLF)) {
    return false;
  }

  if (!this.iface.controlTiquesActividadesLF(curLF)) {
    return false;
  }
  return true;
}

/** \D Crea o modifica el saldo de tiques de un cliente en función del artículo comprado. La compra puede venir de un pedido (compra web) o del TPV.
@param  curLF: Cursor posicionado en una línea de factura de cliente
\end */
function extraescolar_controlTiquesActividadesLF(curLF)
{
  var util = new FLUtil();

  var referencia = curLF.valueBuffer("referencia");
  if (!referencia || referencia == "") {
    return true;
  }
  var codActividad = util.sqlSelect("fo_actividades", "codactividad", "refasistenciaesp = '" + referencia + "'");
  if (!codActividad) {
    return true;
  }

  var codCliente = curLF.cursorRelation() ?
                   curLF.cursorRelation().valueBuffer("codcliente") :
                   util.sqlSelect("facturascli", "codcliente", "idfactura = " + curLF.valueBuffer("idfactura"));

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
  curSaldo.setValueBuffer("comprado", formRecordfo_saldotiquetactcli.iface.pub_commonCalculateField("comprado", curSaldo));
  curSaldo.setValueBuffer("saldo", formRecordfo_saldotiquetactcli.iface.pub_commonCalculateField("saldo", curSaldo));
  if (!curSaldo.commitBuffer()) {
    return false;
  }
  return true;
}
//// EXTRAESCOLAR //////////////////////////////////////////////
////////////////////////////////////////////////////////////////
