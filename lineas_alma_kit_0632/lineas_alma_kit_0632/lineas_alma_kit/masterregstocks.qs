
/** @class_declaration lineasAlma */
/////////////////////////////////////////////////////////////////
//// LINEAS ALMACEN ARTICULOS COMPUESTOS ////////////////////////
class lineasAlma extends kits
{
  function lineasAlma(context)
  {
    kits(context);
  }
  function dameQueryPedCli(aDatosArt: Array, codAlmacen: String): FLSqlQuery {
    return this.ctx.lineasAlma_dameQueryPedCli(aDatosArt, codAlmacen);
  }
  function dameQueryPedProv(aDatosArt: Array, codAlmacen: String): FLSqlQuery {
    return this.ctx.lineasAlma_dameQueryPedProv(aDatosArt, codAlmacen);
  }
  function dameQueryAlbCli(aDatosArt: Array, codAlmacen: String): FLSqlQuery {
    return this.ctx.lineasAlma_dameQueryAlbCli(aDatosArt, codAlmacen);
  }
  function dameQueryAlbProv(aDatosArt: Array, codAlmacen: String): FLSqlQuery {
    return this.ctx.lineasAlma_dameQueryAlbProv(aDatosArt, codAlmacen);
  }
  function dameQueryFacCli(aDatosArt: Array, codAlmacen: String): FLSqlQuery {
    return this.ctx.lineasAlma_dameQueryFacCli(aDatosArt, codAlmacen);
  }
  function dameQueryFacProv(aDatosArt: Array, codAlmacen: String): FLSqlQuery {
    return this.ctx.lineasAlma_dameQueryFacProv(aDatosArt, codAlmacen);
  }
  function dameQueryComTPV(aDatosArt: Array, codAlmacen: String): String {
    return this.ctx.lineasAlma_dameQueryComTPV(aDatosArt, codAlmacen);
  }
}
//// LINEAS ALMACEN ARTICULOS COMPUESTOS ////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition lineasAlma */
/////////////////////////////////////////////////////////////////
//// LINEAS ALMACEN ARTICULOS COMPUESTOS ////////////////////////
function lineasAlma_dameQueryPedCli(aDatosArt: Array, codAlmacen: String): FLSqlQuery {
  var qryStock: FLSqlQuery = this.iface.__dameQueryPedCli(aDatosArt, codAlmacen);
  if (!qryStock)
  {
    return false;
  }
  qryStock.setWhere("lp.codalmacen = '" + codAlmacen + "' AND lp.referencia = '" + aDatosArt["referencia"] + "' AND ms.idmovimiento IS NULL");
  return qryStock;
}

function lineasAlma_dameQueryPedProv(aDatosArt: Array, codAlmacen: String): FLSqlQuery {
  var qryStock: FLSqlQuery = this.iface.__dameQueryPedProv(aDatosArt, codAlmacen);
  if (!qryStock)
  {
    return false;
  }
  qryStock.setWhere("lp.codalmacen = '" + codAlmacen + "' AND lp.referencia = '" + aDatosArt["referencia"] + "' AND ms.idmovimiento IS NULL");
  return qryStock;
}

function lineasAlma_dameQueryAlbCli(aDatosArt: Array, codAlmacen: String): FLSqlQuery {
  var qryStock: FLSqlQuery = this.iface.__dameQueryAlbCli(aDatosArt, codAlmacen);
  if (!qryStock)
  {
    return false;
  }
  qryStock.setWhere("la.codalmacen = '" + codAlmacen + "' AND la.referencia = '" + aDatosArt["referencia"] + "' AND ms.idmovimiento IS NULL");
  return qryStock;
}

function lineasAlma_dameQueryAlbProv(aDatosArt: Array, codAlmacen: String): FLSqlQuery {
  var qryStock: FLSqlQuery = this.iface.__dameQueryAlbProv(aDatosArt, codAlmacen);
  if (!qryStock)
  {
    return false;
  }
  qryStock.setWhere("la.codalmacen = '" + codAlmacen + "' AND la.referencia = '" + aDatosArt["referencia"] + "' AND ms.idmovimiento IS NULL");
  return qryStock;
}

function lineasAlma_dameQueryFacCli(aDatosArt: Array, codAlmacen: String): FLSqlQuery {
  var qryStock: FLSqlQuery = this.iface.__dameQueryFacCli(aDatosArt, codAlmacen);
  if (!qryStock)
  {
    return false;
  }
  qryStock.setWhere("lf.codalmacen = '" + codAlmacen + "' AND lf.referencia = '" + aDatosArt["referencia"] + "' AND ms.idmovimiento IS NULL");
  return qryStock;
}

function lineasAlma_dameQueryFacProv(aDatosArt: Array, codAlmacen: String): FLSqlQuery {
  var qryStock: FLSqlQuery = this.iface.__dameQueryFacProv(aDatosArt, codAlmacen);
  if (!qryStock)
  {
    return false;
  }
  qryStock.setWhere("lf.codalmacen = '" + codAlmacen + "' AND lf.referencia = '" + aDatosArt["referencia"] + "' AND ms.idmovimiento IS NULL");
  return qryStock;
}

function lineasAlma_dameQueryComTPV(aDatosArt: Array, codAlmacen: String): FLSqlQuery {
  var qryStock: FLSqlQuery = this.iface.__dameQueryComTPV(aDatosArt, codAlmacen);
  if (!qryStock)
  {
    return false;
  }
  qryStock.setWhere("lc.codalmacen = '" + codAlmacen + "' AND lc.referencia = '" + aDatosArt["referencia"] + "' AND ms.idmovimiento IS NULL");
  return qryStock;
}
//// LINEAS ALMACEN ARTICULOS COMPUESTOS ////////////////////////
////////////////////////////////////////////////////////////////
