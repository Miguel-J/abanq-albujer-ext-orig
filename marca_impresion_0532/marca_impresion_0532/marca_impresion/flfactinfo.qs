
/** @class_declaration marcaImpresion */
/////////////////////////////////////////////////////////////////
//// MARCA_IMPRESION ////////////////////////////////////////////
class marcaImpresion extends oficial
{
  function marcaImpresion(context)
  {
    oficial(context);
  }
  function lanzarInforme(cursor: FLSqlCursor, nombreInforme: String, orderBy: String, groupBy: String, etiquetas: Boolean, impDirecta: Boolean, whereFijo: String, nombreReport: String, numCopias: Number, impresora: String, pdf: Boolean)
  {
    return this.ctx.marcaImpresion_lanzarInforme(cursor, nombreInforme, orderBy, groupBy, etiquetas, impDirecta, whereFijo, nombreReport, numCopias, impresora, pdf);
  }
  function lanzaInforme(cursor, oParam)
  {
    return this.ctx.marcaImpresion_lanzaInforme(cursor, oParam);
  }
  function dameDatosMarcaImpresion(nombreInforme)
  {
    return this.ctx.marcaImpresion_dameDatosMarcaImpresion(nombreInforme);
  }
  function marcarInformeImpreso(nombreInforme, consulta)
  {
    return this.ctx.marcaImpresion_marcarInformeImpreso(nombreInforme, consulta);
  }
}
//// MARCA_IMPRESION ////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition marcaImpresion */
/////////////////////////////////////////////////////////////////
//// MARCA_IMPRESION ////////////////////////////////////////////
function marcaImpresion_lanzarInforme(cursor: FLSqlCursor, nombreInforme: String, orderBy: String, groupBy: String, etiquetas: Boolean, impDirecta: Boolean, whereFijo: String, nombreReport: String, numCopias: Number, impresora: String, pdf: Boolean)
{
  var _i = this.iface;
  var util = new FLUtil();
  var descripcion = cursor.valueBuffer("descripcion");
  if (descripcion != "temp") {
    var res = MessageBox.information(util.translate("scripts", "¿Desea marcar los documentos a mostrar como impresos?"), MessageBox.Yes, MessageBox.No);
    if (res != MessageBox.Yes) {
      this.iface.__lanzarInforme(cursor, nombreInforme, orderBy, groupBy, etiquetas, impDirecta, whereFijo, nombreReport, numCopias, impresora, pdf);
      return;
    }
  }
  this.iface.__lanzarInforme(cursor, nombreInforme, orderBy, groupBy, etiquetas, impDirecta, whereFijo, nombreReport, numCopias, impresora, pdf);
  var q = this.iface.establecerConsulta(cursor, nombreInforme, "", "", whereFijo);
  var comentario: String;
  var select: String;
  switch (nombreInforme) {
    case "i_presupuestoscli": {
      select = "presupuestoscli.idpresupuesto, presupuestoscli.impreso";
      comentario = util.translate("scripts", "Marcando presupuestos como impresos...");
      break;
    }
    case "i_pedidoscli": {
      select = "pedidoscli.idpedido, pedidoscli.impreso";
      comentario = util.translate("scripts", "Marcando pedidos como impresos...");
      break;
    }
    case "i_albaranescli": {
      select = "albaranescli.idalbaran, albaranescli.impreso";
      comentario = util.translate("scripts", "Marcando albaranes como impresos...");
      break;
    }
    case "i_facturascli": {
      select = "facturascli.idfactura, facturascli.impreso";
      comentario = util.translate("scripts", "Marcando facturas como impresas...");
      break;
    }
    case "i_pedidosprov": {
      select = "pedidosprov.idpedido, pedidosprov.impreso";
      comentario = util.translate("scripts", "Marcando pedidos como impresos...");
      break;
    }
    case "i_albaranesprov": {
      select = "albaranesprov.idalbaran, albaranesprov.impreso";
      comentario = util.translate("scripts", "Marcando albaranes como impresos...");
      break;
    }
    case "i_facturasprov": {
      select = "facturasprov.idfactura, facturasprov.impreso";
      comentario = util.translate("scripts", "Marcando facturas como impresas...");
      break;
    }
    default: {
      var aDMI = _i.dameDatosMarcaImpresion(nombreInforme);
      if (!aDMI) {
        return false;
      }
      comentario = aDMI.comentario;
      select = aDMI.select;
      break;
    }
  }

  q.setSelect(select);
  debug(q.sql());
  if (!q.exec()) {
    return;
  }
  var progreso = 0;
  util.createProgressDialog(comentario, q.size());
  while (q.next()) {
    switch (nombreInforme) {
      case "i_presupuestoscli": {
        formpresupuestoscli.iface.pub_marcarPresupuestoImpreso(q.value("presupuestoscli.idpresupuesto"), q.value("presupuestoscli.impreso"));
        break;
      }
      case "i_pedidoscli": {
        formpedidoscli.iface.pub_marcarPedidoImpreso(q.value("pedidoscli.idpedido"), q.value("pedidoscli.impreso"));
        break;
      }
      case "i_albaranescli": {
        formalbaranescli.iface.pub_marcarAlbaranImpreso(q.value("albaranescli.idalbaran"), q.value("albaranescli.impreso"));
        break;
      }
      case "i_facturascli": {
        formfacturascli.iface.pub_marcarFacturaImpresa(q.value("facturascli.idfactura"), q.value("facturascli.impreso"));
        break;
      }
      case "i_pedidosprov": {
        formpedidosprov.iface.pub_marcarPedidoImpreso(q.value("pedidosprov.idpedido"), q.value("pedidosprov.impreso"));
        break;
      }
      case "i_albaranesprov": {
        formalbaranesprov.iface.pub_marcarAlbaranImpreso(q.value("albaranesprov.idalbaran"), q.value("albaranesprov.impreso"));
        break;
      }
      case "i_facturasprov": {
        formfacturasprov.iface.pub_marcarFacturaImpresa(q.value("facturasprov.idfactura"), q.value("facturasprov.impreso"));
        break;
      }
      default: {
        var mI = _i.marcarInformeImpreso(nombreInforme, q);
        if (!mI) {
          return false;
        }
        break;
      }
    }
    progreso++;
  }
  util.destroyProgressDialog();
}

function marcaImpresion_lanzaInforme(cursor, oParam)
{
  var nombreInforme = oParam.nombreInforme;
  var _i = this.iface;

  if (nombreInforme != "i_presupuestoscli" && nombreInforme != "i_pedidoscli" && nombreInforme != "i_albaranescli" && nombreInforme != "i_facturascli" && nombreInforme != "i_pedidosprov" && nombreInforme != "i_albaranesprov" && nombreInforme != "i_facturasprov") {
    return this.iface.__lanzaInforme(cursor, oParam);
  }
  var util = new FLUtil();
  var descripcion = cursor.valueBuffer("descripcion");
  if (descripcion != "temp") {
    var res = MessageBox.information(util.translate("scripts", "¿Desea marcar los documentos a mostrar como impresos?"), MessageBox.Yes, MessageBox.No);
    if (res != MessageBox.Yes) {
      return this.iface.__lanzaInforme(cursor, oParam);
    }
  }
  this.iface.__lanzaInforme(cursor, oParam);
  var q = this.iface.establecerConsulta(cursor, oParam.nombreInforme, "", "", oParam.whereFijo);
  var comentario, select;
  switch (nombreInforme) {
    case "i_presupuestoscli": {
      select = "presupuestoscli.idpresupuesto, presupuestoscli.impreso";
      comentario = util.translate("scripts", "Marcando presupuestos como impresos...");
      break;
    }
    case "i_pedidoscli": {
      select = "pedidoscli.idpedido, pedidoscli.impreso";
      comentario = util.translate("scripts", "Marcando pedidos como impresos...");
      break;
    }
    case "i_albaranescli": {
      select = "albaranescli.idalbaran, albaranescli.impreso";
      comentario = util.translate("scripts", "Marcando albaranes como impresos...");
      break;
    }
    case "i_facturascli": {
      select = "facturascli.idfactura, facturascli.impreso";
      comentario = util.translate("scripts", "Marcando facturas como impresas...");
      break;
    }
    case "i_pedidosprov": {
      select = "pedidosprov.idpedido, pedidosprov.impreso";
      comentario = util.translate("scripts", "Marcando pedidos como impresos...");
      break;
    }
    case "i_albaranesprov": {
      select = "albaranesprov.idalbaran, albaranesprov.impreso";
      comentario = util.translate("scripts", "Marcando albaranes como impresos...");
      break;
    }
    case "i_facturasprov": {
      select = "facturasprov.idfactura, facturasprov.impreso";
      comentario = util.translate("scripts", "Marcando facturas como impresas...");
      break;
    }
    default: {
      var aDMI = _i.dameDatosMarcaImpresion(nombreInforme);
      if (!aDMI) {
        return false;
      }
      comentario = aDMI.comentario;
      select = aDMI.select;
      break;
    }
  }

  q.setSelect(select);
  debug(q.sql());
  if (!q.exec()) {
    return;
  }
  var progreso = 0;
  util.createProgressDialog(comentario, q.size());
  while (q.next()) {
    switch (nombreInforme) {
      case "i_presupuestoscli": {
        formpresupuestoscli.iface.pub_marcarPresupuestoImpreso(q.value("presupuestoscli.idpresupuesto"), q.value("presupuestoscli.impreso"));
        break;
      }
      case "i_pedidoscli": {
        formpedidoscli.iface.pub_marcarPedidoImpreso(q.value("pedidoscli.idpedido"), q.value("pedidoscli.impreso"));
        break;
      }
      case "i_albaranescli": {
        formalbaranescli.iface.pub_marcarAlbaranImpreso(q.value("albaranescli.idalbaran"), q.value("albaranescli.impreso"));
        break;
      }
      case "i_facturascli": {
        formfacturascli.iface.pub_marcarFacturaImpresa(q.value("facturascli.idfactura"), q.value("facturascli.impreso"));
        break;
      }
      case "i_pedidosprov": {
        formpedidosprov.iface.pub_marcarPedidoImpreso(q.value("pedidosprov.idpedido"), q.value("pedidosprov.impreso"));
        break;
      }
      case "i_albaranesprov": {
        formalbaranesprov.iface.pub_marcarAlbaranImpreso(q.value("albaranesprov.idalbaran"), q.value("albaranesprov.impreso"));
        break;
      }
      case "i_facturasprov": {
        formfacturasprov.iface.pub_marcarFacturaImpresa(q.value("facturasprov.idfactura"), q.value("facturasprov.impreso"));
        break;
      }
      default: {
        var mI = _i.marcarInformeImpreso(nombreInforme, q);
        if (!mI) {
          return false;
        }
        break;
      }
    }
    progreso++;
  }
  util.destroyProgressDialog();
}

function marcaImpresion_dameDatosMarcaImpresion(nombreInforme)
{
  switch (nombreInforme) {
    default: {
      return false;
    }
  }
}
function marcaImpresion_marcarInformeImpreso(nombreInforme, consulta)
{
  switch (nombreInforme) {
    default: {
      return false;
    }
  }
}
//// MARCA_IMPRESION ////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
