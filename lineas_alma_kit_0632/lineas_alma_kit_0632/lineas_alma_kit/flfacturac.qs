
/** @class_declaration lineasAlma */
/////////////////////////////////////////////////////////////////
//// ALMACÉN POR LÍNEA //////////////////////////////////////////
class lineasAlma extends oficial
{
  function lineasAlma(context)
  {
    oficial(context);
  }
  function init()
  {
    return this.ctx.lineasAlma_init();
  }
  function informarAlmacenLinea()
  {
    return this.ctx.lineasAlma_informarAlmacenLinea();
  }
}
//// ALMACÉN POR LÍNEA //////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition lineasAlma */
/////////////////////////////////////////////////////////////////
//// ALMACÉN POR LÍNEA //////////////////////////////////////////
function lineasAlma_init()
{
  var util: FLUtil = new FLUtil();
  if (util.sqlSelect("lineasalbaranesprov la INNER JOIN albaranesprov a ON a.idalbaran = la.idalbaran", "la.codalmacen", "1 = 1", "lineasalbaranesprov,albaranesprov") == "NULL" || util.sqlSelect("lineasalbaranescli la INNER JOIN albaranescli a ON a.idalbaran = la.idalbaran", "la.codalmacen", "1 = 1", "lineasalbaranescli,albaranescli") == "NULL"  || util.sqlSelect("lineaspedidoscli lp INNER JOIN pedidoscli p ON lp.idpedido = p.idpedido", "lp.codalmacen", "1 = 1", "lineaspedidoscli,pedidoscli") == "NULL" || util.sqlSelect("lineaspedidosprov lp INNER JOIN pedidosprov p ON lp.idpedido = p.idpedido", "lp.codalmacen", "1 = 1", "lineaspedidosprov,pedidosprov") == "NULL" || util.sqlSelect("lineasfacturascli lf INNER JOIN facturascli f ON lf.idfactura = f.idfactura", "lf.codalmacen", "1 = 1", "lineasfacturascli,facturascli") == "NULL" ||  util.sqlSelect("lineasfacturasprov lf INNER JOIN facturasprov f ON lf.idfactura = f.idfactura", "lf.codalmacen", "1 = 1", "lineasfacturasprov,facturasprov") == "NULL") {
    this.iface.informarAlmacenLinea();
  }
}

function lineasAlma_informarAlmacenLinea()
{
  var util: FLUtil = new FLUtil();
  var cont: Number = 1;
  var res: Number = MessageBox.information(util.translate("scripts", "A continuación vamos a actualizar los códigos de almacén de las líneas de los documentos.\n¿Desea continuar?"), MessageBox.Yes, MessageBox.No);
  if (res != MessageBox.Yes) {
    return false;
  }
  //  var curAlmacen:FLSqlCursor = new FLSqlCursor("almacenes");
  //  curAlmacen.setModeAccess(curAlmacen.Insert);
  //  curAlmacen.refreshBuffer();
  //  curAlmacen.setValueBuffer("codalmacen", "NULL");
  //  curAlmacen.setValueBuffer("nombre", "NULL");
  //  curAlmacen.commitBuffer();
  debug("hola2 ");
  //PRESUPUESTOS
  var qryPresupuestos: FLSqlQuery = new FLSqlQuery();
  qryPresupuestos.setTablesList("presupuestoscli,lineaspresupuestoscli");
  qryPresupuestos.setSelect("l.idlinea,p.codalmacen");
  qryPresupuestos.setFrom("presupuestoscli p INNER JOIN lineaspresupuestoscli l ON p.idpresupuesto = l.idpresupuesto");
  qryPresupuestos.setWhere("l.codalmacen = 'NULL'");
  qryPresupuestos.setForwardOnly(true);

  if (!qryPresupuestos.exec()) {
    return false;
  }
  debug("presupuestos " + qryPresupuestos.sql());
  util.createProgressDialog(util.translate("scripts", "Actualizando códigos de almacén para presupuestos"), qryPresupuestos.size());
  util.setProgress(0);
  cont = 1;

  var curLineaPr: FLSqlCursor = new FLSqlCursor("lineaspresupuestoscli");
  curLineaPr.setActivatedCommitActions(false);
  curLineaPr.setActivatedCheckIntegrity(false);
  while (qryPresupuestos.next()) {
    util.setProgress(cont);
    cont += 1;
    curLineaPr.select("idlinea = " + qryPresupuestos.value("l.idlinea"));
    curLineaPr.first();
    curLineaPr.setModeAccess(curLineaPr.Edit);
    curLineaPr.refreshBuffer();
    curLineaPr.setValueBuffer("codalmacen", qryPresupuestos.value("p.codalmacen"));
    if (!curLineaPr.commitBuffer()) {
      util.destroyProgressDialog();
      return false;
    }
  }
  util.destroyProgressDialog();

  //PEDIDOS
  var qryPedidosCli: FLSqlQuery = new FLSqlQuery();
  qryPedidosCli.setTablesList("pedidoscli,lineaspedidoscli");
  qryPedidosCli.setSelect("l.idlinea,p.codalmacen");
  qryPedidosCli.setFrom("pedidoscli p INNER JOIN lineaspedidoscli l ON p.idpedido = l.idpedido");
  qryPedidosCli.setWhere("l.codalmacen = 'NULL'");
  qryPedidosCli.setForwardOnly(true);

  if (!qryPedidosCli.exec()) {
    return false;
  }
  util.createProgressDialog(util.translate("scripts", "Actualizando códigos de almacén para pedidos de cliente"), qryPedidosCli.size());
  util.setProgress(0);
  cont = 1;

  var curLineaPe: FLSqlCursor = new FLSqlCursor("lineaspedidoscli");
  curLineaPe.setActivatedCommitActions(false);
  curLineaPe.setActivatedCheckIntegrity(false);
  while (qryPedidosCli.next()) {
    util.setProgress(cont);
    cont += 1;
    curLineaPe.select("idlinea = " + qryPedidosCli.value("l.idlinea"));
    curLineaPe.first();
    curLineaPe.setModeAccess(curLineaPe.Edit);
    curLineaPe.refreshBuffer();
    curLineaPe.setValueBuffer("codalmacen", qryPedidosCli.value("p.codalmacen"));
    if (!curLineaPe.commitBuffer()) {
      return false;
    }
  }
  util.destroyProgressDialog();

  var qryPedidosProv: FLSqlQuery = new FLSqlQuery();
  qryPedidosProv.setTablesList("pedidosprov,lineaspedidosprov");
  qryPedidosProv.setSelect("l.idlinea,p.codalmacen");
  qryPedidosProv.setFrom("pedidosprov p INNER JOIN lineaspedidosprov l ON p.idpedido = l.idpedido");
  qryPedidosProv.setWhere("l.codalmacen = 'NULL'");
  qryPedidosProv.setForwardOnly(true);

  if (!qryPedidosProv.exec()) {
    return false;
  }
  util.createProgressDialog(util.translate("scripts", "Actualizando códigos de almacén para pedidos de proveedor"), qryPedidosProv.size());
  util.setProgress(0);
  cont = 1;

  var curLineaPe: FLSqlCursor = new FLSqlCursor("lineaspedidosprov");
  curLineaPe.setActivatedCommitActions(false);
  curLineaPe.setActivatedCheckIntegrity(false);
  while (qryPedidosProv.next()) {
    util.setProgress(cont);
    cont += 1;
    curLineaPe.select("idlinea = " + qryPedidosProv.value("l.idlinea"));
    curLineaPe.first();
    curLineaPe.setModeAccess(curLineaPe.Edit);
    curLineaPe.refreshBuffer();
    curLineaPe.setValueBuffer("codalmacen", qryPedidosProv.value("p.codalmacen"));
    if (!curLineaPe.commitBuffer()) {
      return false;
    }
  }
  util.destroyProgressDialog();

  //ALBARANES
  var qryAlbaranesCli: FLSqlQuery = new FLSqlQuery();
  qryAlbaranesCli.setTablesList("albaranescli,lineasalbaranescli");
  qryAlbaranesCli.setSelect("l.idlinea,a.codalmacen");
  qryAlbaranesCli.setFrom("albaranescli a INNER JOIN lineasalbaranescli l ON a.idalbaran = l.idalbaran");
  qryAlbaranesCli.setWhere("l.codalmacen = 'NULL'");
  qryAlbaranesCli.setForwardOnly(true);

  if (!qryAlbaranesCli.exec()) {
    return false;
  }
  util.createProgressDialog(util.translate("scripts", "Actualizando códigos de almacén para albaranes de cliente"), qryAlbaranesCli.size());
  util.setProgress(0);
  cont = 1;

  var curLineaAl: FLSqlCursor = new FLSqlCursor("lineasalbaranescli");
  curLineaAl.setActivatedCommitActions(false);
  curLineaAl.setActivatedCheckIntegrity(false);
  while (qryAlbaranesCli.next()) {
    util.setProgress(cont);
    cont += 1;
    curLineaAl.select("idlinea = " + qryAlbaranesCli.value("l.idlinea"));
    curLineaAl.first();
    curLineaAl.setModeAccess(curLineaAl.Edit);
    curLineaAl.refreshBuffer();
    curLineaAl.setValueBuffer("codalmacen", qryAlbaranesCli.value("a.codalmacen"));
    if (!curLineaAl.commitBuffer()) {
      return false;
    }
  }
  util.destroyProgressDialog();

  var qryAlbaranesProv: FLSqlQuery = new FLSqlQuery();
  qryAlbaranesProv.setTablesList("albaranesprov,lineasalbaranesprov");
  qryAlbaranesProv.setSelect("l.idlinea,a.codalmacen");
  qryAlbaranesProv.setFrom("albaranesprov a INNER JOIN lineasalbaranesprov l ON a.idalbaran = l.idalbaran");
  qryAlbaranesProv.setWhere("l.codalmacen = 'NULL'");
  qryAlbaranesProv.setForwardOnly(true);

  if (!qryAlbaranesProv.exec()) {
    return false;
  }
  util.createProgressDialog(util.translate("scripts", "Actualizando códigos de almacén para albaranes de proveedor"), qryAlbaranesProv.size());
  util.setProgress(0);
  cont = 1;

  var curLineaAl: FLSqlCursor = new FLSqlCursor("lineasalbaranesprov");
  curLineaAl.setActivatedCommitActions(false);
  curLineaAl.setActivatedCheckIntegrity(false);
  while (qryAlbaranesProv.next()) {
    util.setProgress(cont);
    cont += 1;
    curLineaAl.select("idlinea = " + qryAlbaranesProv.value("l.idlinea"));
    curLineaAl.first();
    curLineaAl.setModeAccess(curLineaAl.Edit);
    curLineaAl.refreshBuffer();
    curLineaAl.setValueBuffer("codalmacen", qryAlbaranesProv.value("a.codalmacen"));
    if (!curLineaAl.commitBuffer()) {
      return false;
    }
  }
  util.destroyProgressDialog();

  //FACTURAS
  var qryFacturasCli: FLSqlQuery = new FLSqlQuery();
  qryFacturasCli.setTablesList("facturascli,lineasfacturascli");
  qryFacturasCli.setSelect("l.idlinea,f.codalmacen");
  qryFacturasCli.setFrom("facturascli f INNER JOIN lineasfacturascli l ON f.idfactura = l.idfactura");
  qryFacturasCli.setWhere("l.codalmacen = 'NULL'");
  qryFacturasCli.setForwardOnly(true);

  if (!qryFacturasCli.exec()) {
    return false;
  }
  util.createProgressDialog(util.translate("scripts", "Actualizando códigos de almacén para facturas de cliente"), qryFacturasCli.size());
  util.setProgress(0);
  cont = 1;

  var curLineaF: FLSqlCursor = new FLSqlCursor("lineasfacturascli");
  curLineaF.setActivatedCommitActions(false);
  curLineaF.setActivatedCheckIntegrity(false);
  while (qryFacturasCli.next()) {
    util.setProgress(cont);
    cont += 1;
    curLineaF.select("idlinea = " + qryFacturasCli.value("l.idlinea"));
    curLineaF.first();
    curLineaF.setModeAccess(curLineaF.Edit);
    curLineaF.refreshBuffer();
    curLineaF.setValueBuffer("codalmacen", qryFacturasCli.value("f.codalmacen"));
    if (!curLineaF.commitBuffer()) {
      return false;
    }
  }
  util.destroyProgressDialog();

  var qryFacturasProv: FLSqlQuery = new FLSqlQuery();
  qryFacturasProv.setTablesList("facturasprov,lineasfacturasprov");
  qryFacturasProv.setSelect("l.idlinea,f.codalmacen");
  qryFacturasProv.setFrom("facturasprov f INNER JOIN lineasfacturasprov l ON f.idfactura = l.idfactura");
  qryFacturasProv.setWhere("l.codalmacen = 'NULL'");
  qryFacturasProv.setForwardOnly(true);

  if (!qryFacturasProv.exec()) {
    return false;
  }
  util.createProgressDialog(util.translate("scripts", "Actualizando códigos de almacén para facturas de proveedor"), qryFacturasProv.size());
  util.setProgress(0);
  cont = 1;

  var curLineaF: FLSqlCursor = new FLSqlCursor("lineasfacturasprov");
  curLineaF.setActivatedCommitActions(false);
  curLineaF.setActivatedCheckIntegrity(false);
  while (qryFacturasProv.next()) {
    util.setProgress(cont);
    cont += 1;
    curLineaF.select("idlinea = " + qryFacturasProv.value("l.idlinea"));
    curLineaF.first();
    curLineaF.setModeAccess(curLineaF.Edit);
    curLineaF.refreshBuffer();
    curLineaF.setValueBuffer("codalmacen", qryFacturasProv.value("f.codalmacen"));
    if (!curLineaF.commitBuffer()) {
      return false;
    }
  }
  util.destroyProgressDialog();
}

//// ALMACÉN POR LÍNEA //////////////////////////////////////////
/////////////////////////////////////////////////////////////////
