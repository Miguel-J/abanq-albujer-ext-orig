
/** @class_declaration estVentasCli */
/////////////////////////////////////////////////////////////////
//// EST VENTAS CLIENTES /////////////////////////////////////////////////
class estVentasCli extends oficial
{
  var tdbVentasCliente: FLTableDB;
  function estVentasCli(context)
  {
    oficial(context);
  }
  function init()
  {
    this.ctx.estVentasCli_init();
  }
  function recalcularVentas(): Boolean { return this.ctx.estVentasCli_recalcularVentas(); }
}
//// EST VENTAS CLIENTES /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition estVentasCli */
/////////////////////////////////////////////////////////////////
//// EST VENTAS CLIENTES /////////////////////////////////////////////////

function estVentasCli_init()
{
  this.iface.__init();

  this.iface.tdbVentasCliente = this.child("tdbVentasCliente");
  this.iface.tdbVentasCliente.setReadOnly(true);
  connect(this.child("pbnRecalcularVentas"), "clicked()", this, "iface.recalcularVentas()");
}

function estVentasCli_recalcularVentas()
{
  var cursor: FLSqlCursor = this.cursor();
  var codCliente: String = cursor.valueBuffer("codcliente");
  var util: FLUtil = new FLUtil();
  var precioUlt: Number, precioMed: Number;
  var paso: Number = 0;

  var q: FLSqlQuery = new FLSqlQuery();
  q.setTablesList("albaranescli,lineasalbaranescli");
  q.setFrom("albaranescli a inner join lineasalbaranescli l on a.idalbaran = l.idalbaran");
  q.setSelect("l.referencia,l.descripcion,sum(l.cantidad),sum(l.pvptotal)");
  q.setWhere("a.codcliente = '" + codCliente + "' group by l.referencia, l.descripcion");

  if (!q.exec())
    return;

  util.createProgressDialog(util.translate("scripts", "Recalculando datos de ventas"), q.size());

  var curTab: FLSqlCursor = new FLSqlCursor("ventasclientes");
  while (q.next()) {

    util.setProgress(paso++);

    precioUlt = util.sqlSelect("albaranescli a inner join lineasalbaranescli l on a.idalbaran = l.idalbaran", "l.pvpunitario", "a.codcliente = '" + codCliente + "' AND l.referencia = '" + q.value(0) + "' ORDER BY a.fecha desc", "albaranescli,lineasalbaranescli");
    if (!precioUlt)
      precioUlt = 0;

    precioMed = parseFloat(q.value(3)) / parseFloat(q.value(2));
    if (!precioMed)
      precioMed = 0;

    curTab.select("codcliente = '" + codCliente + "' AND referencia = '" + q.value(0) + "'");
    if (curTab.first()) {
      curTab.setModeAccess(curTab.Edit);
      curTab.refreshBuffer();
    } else {
      curTab.setModeAccess(curTab.Insert);
      curTab.refreshBuffer();
      curTab.setValueBuffer("referencia", q.value(0));
      curTab.setValueBuffer("codcliente", codCliente);
    }

    curTab.setValueBuffer("descripcion", q.value(1));
    curTab.setValueBuffer("unidades", q.value(2));
    curTab.setValueBuffer("precioultventa", precioUlt);
    curTab.setValueBuffer("preciomedventa", precioMed);
    curTab.setValueBuffer("importepmp", q.value(3));
    curTab.commitBuffer();
  }

  util.destroyProgressDialog();
  this.iface.tdbVentasCliente.refresh()
}

//// EST VENTAS CLIENTES /////////////////////////////////////////////////
////////////////////////////////////////////////////////////////
