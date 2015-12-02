
/** @class_declaration lineasAlma */
/////////////////////////////////////////////////////////////////
//// ALMACÉN EN LÍNEAS //////////////////////////////////////////
class lineasAlma extends scab
{
  function lineasAlma(context)
  {
    scab(context);
  }
  function commonCalculateField(fN: String, cursor: FLSqlCursor, idPedido: String): String {
    return this.ctx.lineasAlma_commonCalculateField(fN, cursor, idPedido);
  }
  function cargarAlbaranesCli(): Boolean {
    return this.ctx.lineasAlma_cargarAlbaranesCli();
  }
  function cargarFacturasCli(): Boolean {
    return this.ctx.lineasAlma_cargarFacturasCli();
  }
  function cargarAlbaranesProv(): Boolean {
    return this.ctx.lineasAlma_cargarAlbaranesProv();
  }
  function cargarFacturasProv(): Boolean {
    return this.ctx.lineasAlma_cargarFacturasProv();
  }
}

//// ALMACÉN EN LÍNEAS //////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition lineasAlma */
/////////////////////////////////////////////////////////////////
//// ALMACÉN EN LÍNEAS //////////////////////////////////////////
function lineasAlma_commonCalculateField(fN: String, cursor: FLSqlCursor, idPedido: String): String {
  var util: FLUtil = new FLUtil;
  var valor: String;
  switch (fN)
  {
    case "cantidadac": {
      var whereStock: String = this.iface.dameWhereStock(cursor, "ld.codalmacen");
      valor = util.sqlSelect("lineasalbaranescli ld INNER JOIN albaranescli d ON ld.idalbaran = d.idalbaran", "SUM(ld.cantidad)", whereStock, "lineasalbaranescli,albaranescli");
      if (isNaN(valor)) {
        valor = 0;
      }
      break;
    }
    case "cantidadap": {
      var whereStock: String = this.iface.dameWhereStock(cursor, "ld.codalmacen");
      valor = util.sqlSelect("lineasalbaranesprov ld INNER JOIN albaranesprov  d ON ld.idalbaran = d.idalbaran", "SUM(ld.cantidad)", whereStock, "lineasalbaranesprov,albaranesprov");
      if (isNaN(valor)) {
        valor = 0;
      }
      break;
    }
    case "cantidadfc": {
      var whereStock: String = this.iface.dameWhereStock(cursor, "ld.codalmacen");
      valor = util.sqlSelect("lineasfacturascli ld INNER JOIN facturascli d ON ld.idfactura = d.idfactura", "SUM(ld.cantidad)", whereStock + " AND d.automatica <> true", "lineasfacturascli,facturascli");
      if (isNaN(valor)) {
        valor = 0;
      }
      break;
    }
    case "cantidadfp": {
      var whereStock: String = this.iface.dameWhereStock(cursor, "ld.codalmacen");
      valor = util.sqlSelect("lineasfacturasprov ld INNER JOIN facturasprov d ON ld.idfactura = d.idfactura", "SUM(ld.cantidad)", whereStock + " AND d.automatica <> true", "lineasfacturasprov,facturasprov");
      if (isNaN(valor)) {
        valor = 0;
      }
      break;
    }
    case "reservada": {
      var codAlmacen: String = cursor.valueBuffer("codalmacen");
      var referencia: String = cursor.valueBuffer("referencia");
      var where: String = "lp.codalmacen = '" + codAlmacen + "' AND lp.referencia = '" + referencia + "' AND (lp.cerrada IS NULL OR lp.cerrada = false)";
      if (idPedido && idPedido != "") {
        where += " AND (p.servido IN ('No', 'Parcial') OR p.idpedido = " + idPedido + ")";
      } else {
        where += " AND p.servido IN ('No', 'Parcial')";
      }
      valor = util.sqlSelect("lineaspedidoscli lp INNER JOIN pedidoscli p ON lp.idpedido = p.idpedido", "sum(lp.cantidad - lp.totalenalbaran)", where, "lineaspedidoscli,pedidoscli");
      if (isNaN(valor)) {
        valor = 0;
      }
      break;
    }
    case "pterecibir": {
      var codAlmacen: String = cursor.valueBuffer("codalmacen");
      var referencia: String = cursor.valueBuffer("referencia");
      var where: String = "lp.codalmacen = '" + codAlmacen + "' AND lp.referencia = '" + referencia + "' AND (lp.cerrada IS NULL OR lp.cerrada = false)";
      if (idPedido && idPedido != "") {
        where += " AND (p.servido IN ('No', 'Parcial') OR p.idpedido = " + idPedido + ")";
      } else {
        where += " AND p.servido IN ('No', 'Parcial')";
      }
      valor = util.sqlSelect("lineaspedidosprov lp INNER JOIN pedidosprov p ON lp.idpedido = p.idpedido", "sum(lp.cantidad - lp.totalenalbaran)", where, "lineaspedidosprov,pedidosprov");
      if (isNaN(valor)) {
        valor = 0;
      }
      break;
    }
    default: {
      valor = this.iface.__commonCalculateField(fN, cursor, idPedido);
    }
  }
  return valor;
}

function lineasAlma_cargarAlbaranesCli(): Boolean {
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  var qryMovimientos: FLSqlQuery = new FLSqlQuery;
  qryMovimientos.setTablesList("albaranescli,lineasalbaranescli");
  qryMovimientos.setSelect("d.fecha, d.hora, ld.cantidad, d.codigo, d.idalbaran");
  qryMovimientos.setFrom("albaranescli d INNER JOIN lineasalbaranescli ld ON d.idalbaran = ld.idalbaran");
  qryMovimientos.setWhere(this.iface.dameWhereStock(cursor, "ld.codalmacen"));
  qryMovimientos.setForwardOnly(true);
  if (!qryMovimientos.exec())
  {
    return false;
  }
  var iMovimiento: Number = this.iface.listaMovimientos_.length;
  while (qryMovimientos.next())
  {
    this.iface.listaMovimientos_[iMovimiento] = this.iface.crearMovimiento(qryMovimientos, -1, "AC");
    iMovimiento++;
  }
  return true;
}

function lineasAlma_cargarFacturasCli(): Boolean {
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  var qryMovimientos: FLSqlQuery = new FLSqlQuery;
  qryMovimientos.setTablesList("facturascli,lineasfacturascli");
  qryMovimientos.setSelect("d.fecha, d.hora, ld.cantidad, d.codigo, d.idfactura");
  qryMovimientos.setFrom("facturascli d INNER JOIN lineasfacturascli ld ON d.idfactura = ld.idfactura");
  qryMovimientos.setWhere(this.iface.dameWhereStock(cursor, "ld.codalmacen") + " AND d.automatica <> true");
  qryMovimientos.setForwardOnly(true);
  if (!qryMovimientos.exec())
  {
    return false;
  }
  var iMovimiento: Number = this.iface.listaMovimientos_.length;
  while (qryMovimientos.next())
  {
    this.iface.listaMovimientos_[iMovimiento] = this.iface.crearMovimiento(qryMovimientos, -1, "FC");
    iMovimiento++;
  }
  return true;
}

function lineasAlma_cargarAlbaranesProv(): Boolean {
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  var qryMovimientos: FLSqlQuery = new FLSqlQuery;
  qryMovimientos.setTablesList("albaranesprov,lineasalbaranesprov");
  qryMovimientos.setSelect("d.fecha, d.hora, ld.cantidad, d.codigo, d.idalbaran");
  qryMovimientos.setFrom("albaranesprov d INNER JOIN lineasalbaranesprov ld ON d.idalbaran = ld.idalbaran");
  qryMovimientos.setWhere(this.iface.dameWhereStock(cursor, "ld.codalmacen"));
  qryMovimientos.setForwardOnly(true);
  if (!qryMovimientos.exec())
  {
    return false;
  }
  var iMovimiento: Number = this.iface.listaMovimientos_.length;
  while (qryMovimientos.next())
  {
    this.iface.listaMovimientos_[iMovimiento] = this.iface.crearMovimiento(qryMovimientos, 1, "AP");
    iMovimiento++;
  }
  return true;
}

function lineasAlma_cargarFacturasProv(): Boolean {
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  var qryMovimientos: FLSqlQuery = new FLSqlQuery;
  qryMovimientos.setTablesList("facturasprov,lineasfacturasprov");
  qryMovimientos.setSelect("d.fecha, d.hora, ld.cantidad, d.codigo, d.idfactura");
  qryMovimientos.setFrom("facturasprov d INNER JOIN lineasfacturasprov ld ON d.idfactura = ld.idfactura");
  qryMovimientos.setWhere(this.iface.dameWhereStock(cursor, "ld.codalmacen") + " AND d.automatica <> true");
  qryMovimientos.setForwardOnly(true);
  if (!qryMovimientos.exec())
  {
    return false;
  }
  var iMovimiento: Number = this.iface.listaMovimientos_.length;
  while (qryMovimientos.next())
  {
    this.iface.listaMovimientos_[iMovimiento] = this.iface.crearMovimiento(qryMovimientos, 1, "FP");
    iMovimiento++;
  }
  return true;
}

//// ALMACÉN EN LÍNEAS //////////////////////////////////////////
////////////////////////////////////////////////////////////////
