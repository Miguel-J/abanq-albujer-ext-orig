
/** @class_declaration sga */
/////////////////////////////////////////////////////////////////
//// SGA ////////////////////////////////////////////////////////
class sga extends oficial
{
  var valoresRegMat_ : Array = [];
  function sga(context)
  {
    oficial(context);
  }
  function buscarArticuloManual(): String {
    return this.ctx.sga_buscarArticuloManual();
  }
  function buscarArticulo(codBarras: String): Array {
    return this.ctx.sga_buscarArticulo(codBarras);
  }
  function establecerValoresRegMat(valores: Array): Boolean {
    return this.ctx.sga_establecerValoresRegMat(valores);
  }
  function obtenerValoresRegMat(): Array {
    return this.ctx.sga_obtenerValoresRegMat();
  }
  function crearUbicacion(referencia: String): String {
    return this.ctx.sga_crearUbicacion(referencia);
  }
  function afterCommit_movimat(curM: FLSqlCursor): Boolean {
    return this.ctx.sga_afterCommit_movimat(curM);
  }
  function actualizarCantidadUbicacion(idUbiArtculo: String): Boolean {
    return this.ctx.sga_actualizarCantidadUbicacion(idUbiArtculo);
  }
  function afterCommit_lineasreposicion(curLinea: FLSqlCursor): Boolean {
    return this.ctx.sga_afterCommit_lineasreposicion(curLinea);
  }
  function afterCommit_lineaspedidospicking(curLinea: FLSqlCursor): Boolean {
    return this.ctx.sga_afterCommit_lineaspedidospicking(curLinea);
  }
  function seleccionarUbicacion(tipoZona: String): String {
    return this.ctx.sga_seleccionarUbicacion(tipoZona);
  }
  function controlStockAlbaranesCli(curLA: FLSqlCursor): Boolean {
    return this.ctx.sga_controlStockAlbaranesCli(curLA);
  }
  function controlStockFacturasCli(curLF: FLSqlCursor): Boolean {
    return this.ctx.sga_controlStockFacturasCli(curLF);
  }
  function afterCommit_ubicacionesarticulo(curUbicacion: FLSqlCursor): Boolean {
    return this.ctx.sga_afterCommit_ubicacionesarticulo(curUbicacion);
  }
}
//// SGA ////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pubSga */
/////////////////////////////////////////////////////////////////
//// PUB SGA ////////////////////////////////////////////////////
class pubSga extends ifaceCtx
{
  function pubSga(context)
  {
    ifaceCtx(context);
  }
  function pub_buscarArticuloManual(): String {
    return this.buscarArticuloManual();
  }
  function pub_buscarArticulo(codBarras: String): Array {
    return this.buscarArticulo(codBarras);
  }
  function pub_establecerValoresRegMat(valores: Array): Boolean {
    return this.establecerValoresRegMat(valores);
  }
  function pub_obtenerValoresRegMat(): Array {
    return this.obtenerValoresRegMat();
  }
  function pub_crearUbicacion(referencia: String): String {
    return this.crearUbicacion(referencia);
  }
  function pub_seleccionarUbicacion(tipoZona: String): String {
    return this.seleccionarUbicacion(tipoZona);
  }
}
//// PUB SGA ////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition sga */
/////////////////////////////////////////////////////////////////
//// SGA ////////////////////////////////////////////////////////
function sga_buscarArticuloManual(): String {
  var f: Object = new FLFormSearchDB("articulos");
  var curArticulos: FLSqlCursor = f.cursor();
  var util: FLUtil = new FLUtil();

  f.setMainWidget();
  var codBarras: String = f.exec("codbarras");

  if (codBarras == "")
    MessageBox.information(util.translate("scripts", "El artículo elegido no tiene código de barras asignado"), MessageBox.Ok, MessageBox.NoButton);

  return codBarras;
}

function sga_buscarArticulo(codBarras: String): Array {
  var util: FLUtil = new FLUtil();
  var q: FLSqlQuery = new FLSqlQuery();
  var valores: Array = [];

  valores["error"] = false;
  valores["encontrado"] = false;
  valores["referencia"] = "";
  valores["canenvase"] = 1;

  if (!codBarras || codBarras == "")
    return valores;

  if (valores["encontrado"] != true)
  {
    q.setTablesList("articulos");
    q.setSelect("referencia, descripcion");
    q.setFrom("articulos");
    q.setWhere("codbarras = '" + codBarras + "'");
    if (!q.exec()) {
      valores["error"] = true;
      return valores;
    }
    if (!q.first()) {
      var qryEnvase: FLSqlQuery = new FLSqlQuery();
      qryEnvase.setTablesList("envases");
      qryEnvase.setSelect("referencia, cantidad");
      qryEnvase.setFrom("envases");
      qryEnvase.setWhere("codbarras = '" + codBarras + "'");
      if (!qryEnvase.exec()) {
        valores["error"] = true;
        return valores;
      }
      if (!qryEnvase.first()) {
        MessageBox.information(util.translate("scripts", "No existe ningún artículo con estas condiciones"), MessageBox.Ok);
        valores["error"] = true;
        return valores;
      } else {
        var descripcion: String = util.sqlSelect("articulos", "descripcion", "referencia = '" + qryEnvase.value("referencia") + "'");
        valores["referencia"] = qryEnvase.value("referencia");
        valores["descripcion"] = descripcion;
        valores["canenvase"] = qryEnvase.value("cantidad");
        valores["encontrado"] = true;
      }
    } else {
      valores["referencia"] = q.value("referencia");
      valores["descripcion"] = q.value("descripcion");
      valores["canenvase"] = "1";
      valores["encontrado"] = true;
    }
  }
  return valores;
}

function sga_establecerValoresRegMat(valores: Array): Boolean {
  this.iface.valoresRegMat_ = valores;
}

function sga_obtenerValoresRegMat(): Array {
  return this.iface.valoresRegMat_;
}

function sga_crearUbicacion(referencia: String): String {
  var util: FLUtil = new FLUtil;
  var f: Object = new FLFormSearchDB("crearubicacion");
  var curUbicacion: FLSqlCursor = f.cursor();

  curUbicacion.setModeAccess(curUbicacion.Insert);
  curUbicacion.refresh();
  curUbicacion.setValueBuffer("referencia", referencia);

  f.setMainWidget();
  var codUbicacion: String = f.exec("codubicacion");
  if (curUbicacion.valueBuffer("codubicacion") == "")
    return false;

  if (!curUbicacion.commitBuffer())
    return false;

  var idUbicacion: String = curUbicacion.valueBuffer("id");
  if (!idUbicacion)
    return false;

  return idUbicacion;
}

function sga_afterCommit_movimat(curM: FLSqlCursor): Boolean {
  var idUbiArtculo: String = curM.valueBuffer("idubiarticulo");

  if (!this.iface.actualizarCantidadUbicacion(idUbiArtculo))
    return false;

  return true;
}

function sga_actualizarCantidadUbicacion(idUbiArtculo: String): Boolean {
  var util: FLUtil = new FLUtil();
  var cantUbicacion: Number = parseFloat(util.sqlSelect("movimat", "SUM(cantidad)", "idubiarticulo = " + idUbiArtculo));
  if (!cantUbicacion || isNaN(cantUbicacion))
    cantUbicacion = 0;
  if (!util.sqlUpdate("ubicacionesarticulo", "cantidadactual", cantUbicacion, "id = " + idUbiArtculo))
    return false;
  return true;
}

function sga_afterCommit_lineasreposicion(curLinea: FLSqlCursor): Boolean {
  var util: FLUtil = new FLUtil();
  var idReposicion: String = curLinea.valueBuffer("idreposicion");
  if (!idReposicion)
    return false;
  var idLinea: String = util.sqlSelect("lineasreposicion", "idlineareposicion", "idreposicion = " + idReposicion + " AND (estadoentrada = 'PTE' OR estadosalida = 'PTE')");
  if (idLinea)
  {
    if (!util.sqlUpdate("reposicion", "estado", 'PTE', "idreposicion = " + idReposicion))
      return false;
  } else {
    if (!util.sqlUpdate("reposicion", "estado", 'TERMINADO', "idreposicion = " + idReposicion))
      return false;
  }
  return true;
}

function sga_afterCommit_lineaspedidospicking(curLinea: FLSqlCursor): Boolean {
  var util: FLUtil = new FLUtil();
  var codPedidoPicking: String = curLinea.valueBuffer("codpedidopicking");
  if (!codPedidoPicking)
    return false;

  var idLineaPte: String = util.sqlSelect("lineaspedidospicking", "idlineapedidopicking", "codpedidopicking = '" + codPedidoPicking + "' AND estado = 'PTE CESTAS'");
  var idLineaAct: String = util.sqlSelect("lineaspedidospicking", "idlineapedidopicking", "codpedidopicking = '" + codPedidoPicking + "' AND estado = 'ACTIVO'");
  var idLineaEnCesta: String = util.sqlSelect("lineaspedidospicking", "idlineapedidopicking", "codpedidopicking = '" + codPedidoPicking + "' AND estado = 'EN CESTA'");

  if (idLineaPte)
  {
    if (!util.sqlUpdate("pedidospicking", "estado", 'PTE CESTAS', "codpedidopicking = '" + codPedidoPicking + "'"))
      return false;
  } else if (idLineaAct)
  {
    if (!util.sqlUpdate("pedidospicking", "estado", 'ACTIVO', "codpedidopicking = '" + codPedidoPicking + "'"))
      return false;
  } else if (idLineaEnCesta)
  {
    if (!util.sqlUpdate("pedidospicking", "estado", 'EN CESTA', "codpedidopicking = '" + codPedidoPicking + "'"))
      return false;
  } else {
    if (!util.sqlUpdate("pedidospicking", "estado", 'TERMINADO', "codpedidopicking = '" + codPedidoPicking + "'"))
      return false;
  }
  return true;
}

function sga_seleccionarUbicacion(tipoZona: String): String {
  var fUbicaciones: Object = new FLFormSearchDB("ubicaciones");
  var curUbicaciones: FLSqlCursor = fUbicaciones.cursor();
  if (tipoZona && tipoZona != "")
    curUbicaciones.setMainFilter("codzona IN (SELECT codzona FROM zonas WHERE tipo = '" + tipoZona + "')");

  fUbicaciones.setMainWidget();
  var codUbicacion: String = fUbicaciones.exec("codUbicacion");

  return codUbicacion;
}

function sga_controlStockAlbaranesCli(curLA: FLSqlCursor): Boolean {
  return true;
}

function sga_controlStockFacturasCli(curLF: FLSqlCursor): Boolean {
  return true;
}

function sga_afterCommit_ubicacionesarticulo(curUbicacionArt: FLSqlCursor): Boolean {
  var util: FLUtil = new FLUtil;
  var referencia: String = curUbicacionArt.valueBuffer("referencia");
  if (!referencia)
  {
    return false;
  }

  var codAlmacen: String = util.sqlSelect("ubicaciones u INNER JOIN zonas z ON z.codzona = u.codzona", "z.codalmacen", "u.codubicacion = '" + curUbicacionArt.valueBuffer("codubicacion") + "'", "ubicaciones,zonas");
  if (!codAlmacen)
  {
    return false;
  }

  var cantidad: Number = util.sqlSelect("ubicacionesarticulo ua INNER JOIN ubicaciones u ON ua.codubicacion = u.codubicacion INNER JOIN zonas z ON u.codzona = z.codzona", "SUM(ua.cantidadactual)", "ua.referencia = '" + referencia + "' AND z.codalmacen = '" + codAlmacen + "'", "ubicacionesarticulo,ubicaciones,zonas");
  if (cantidad)
  {
    var curStock: FLSqlCursor = new FLSqlCursor("stocks");
    curStock.select("referencia = '" + referencia + "' AND codalmacen = '" + codAlmacen + "'");
    if (!curStock.first()) {
      return false;
    }
    curStock.setModeAccess(curStock.Edit);
    curStock.refreshBuffer();
    curStock.setValueBuffer("cantidad", parseFloat(cantidad));
    if (!curStock.commitBuffer()) {
      return false;
    }
  }
  return true;
}

//// SGA ////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
