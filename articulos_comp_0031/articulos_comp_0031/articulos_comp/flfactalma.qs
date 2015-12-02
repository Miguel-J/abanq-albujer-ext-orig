
/** @class_declaration articomp */
/////////////////////////////////////////////////////////////////
//// ARTICULOSCOMP //////////////////////////////////////////////
class articomp extends medidas
{
  var calculoStockBloqueado_: Boolean;
  var curMoviStock: FLSqlCursor;
  function articomp(context)
  {
    medidas(context);
  }
  //  function cambiarStock(codAlmacen:String, referencia:String, variacion:Number, campo:String):Boolean {
  //    return this.ctx.articomp_cambiarStock(codAlmacen, referencia, variacion, campo);
  //  }
  function pvpCompuesto(referencia: String): Number {
    return this.ctx.articomp_pvpCompuesto(referencia);
  }
  function beforeCommit_articulos(curArticulo: FLSqlCursor): Boolean {
    return this.ctx.articomp_beforeCommit_articulos(curArticulo);
  }
  function actualizarUnidad(referencia: String, unidad: String): Boolean {
    return this.ctx.articomp_actualizarUnidad(referencia, unidad);
  }
  function calcularFiltroReferencia(referencia: String): String {
    return this.ctx.articomp_calcularFiltroReferencia(referencia);
  }
  function afterCommit_articuloscomp(curAC: FLSqlCursor): Boolean {
    return this.ctx.articomp_afterCommit_articuloscomp(curAC);
  }
  function controlArticuloVariable(curAC)
  {
    return this.ctx.articomp_controlArticuloVariable(curAC);
  }
  function afterCommit_tiposopcionartcomp(curTOAC: FLSqlCursor): Boolean {
    return this.ctx.articomp_afterCommit_tiposopcionartcomp(curTOAC);
  }
  function comprobarPadresVariables(referencia: String): Boolean {
    return this.ctx.articomp_comprobarPadresVariables(referencia);
  }
  function beforeCommit_opcionesarticulocomp(curOP: FLSqlCursor): Boolean {
    return this.ctx.articomp_beforeCommit_opcionesarticulocomp(curOP);
  }
  function datosArticulo(cursor, codLote, curLinea)
  {
    return this.ctx.articomp_datosArticulo(cursor, codLote, curLinea);
  }
  function establecerCantidad(curLinea: FLSqlCursor): Number {
    return this.ctx.articomp_establecerCantidad(curLinea);
  }
  function dameDatosStockLinea(curLinea: FLSqlCursor, curArticuloComp: FLSqlCursor): Array {
    return this.ctx.articomp_dameDatosStockLinea(curLinea, curArticuloComp);
  }
  function datosArticuloMS(datosArt, aDatosStockLinea)
  {
    return this.ctx.articomp_datosArticuloMS(datosArt, aDatosStockLinea);
  }
  function generarMoviStockComponentes(aDatosArt: Array, idProceso): Boolean {
    return this.ctx.articomp_generarMoviStockComponentes(aDatosArt, idProceso);
  }
  function generarMoviStock(curLinea: FLSqlCursor, codLote: String, cantidad: Number, curArticuloComp: FLSqlCursor, idProceso: String): Boolean {
    return this.ctx.articomp_generarMoviStock(curLinea, codLote, cantidad, curArticuloComp, idProceso);
  }
  function dameIdStock(codAlmacen, aDatosArt)
  {
    return this.ctx.articomp_dameIdStock(codAlmacen, aDatosArt);
  }
  function creaRegMoviStock(curLinea: FLSqlCursor, aDatosArt: Array, aDatosStockLinea: Array, curArticuloComp: FLSqlCursor): Boolean {
    return this.ctx.articomp_creaRegMoviStock(curLinea, aDatosArt, aDatosStockLinea, curArticuloComp);
  }
  function actualizarStocksMoviStock(curMS: FLSqlCursor): Boolean {
    return this.ctx.articomp_actualizarStocksMoviStock(curMS);
  }
  function actualizarStockPteRecibir(idStock: Number): Boolean {
    return this.ctx.articomp_actualizarStockPteRecibir(idStock);
  }
  function actualizarStockPteServir(idStock: Number): Boolean {
    return this.ctx.articomp_actualizarStockPteServir(idStock);
  }
  function actualizarStock(idStock: Number): Boolean {
    return this.ctx.articomp_actualizarStock(idStock);
  }
  function afterCommit_movistock(curMS: FLSqlCursor): Boolean {
    return this.ctx.articomp_afterCommit_movistock(curMS);
  }
  function crearStock(codAlmacen: String, datosArt: Array): Number {
    return this.ctx.articomp_crearStock(codAlmacen, datosArt);
  }
  function generarEstructura(curLinea: FLSqlCursor): Boolean {
    return this.ctx.articomp_generarEstructura(curLinea);
  }
  function borrarEstructura(curLP: FLSqlCursor): Boolean {
    return this.ctx.articomp_borrarEstructura(curLP);
  }
  function borrarMoviStock(curLinea: FLSqlCursor): Boolean {
    return this.ctx.articomp_borrarMoviStock(curLinea);
  }
  function datosStockLineaCambian(curLinea)
  {
    return this.ctx.articomp_datosStockLineaCambian(curLinea);
  }
  function controlStockPresupuestosCli(curLP: FLSqlCursor): Boolean {
    return this.ctx.articomp_controlStockPresupuestosCli(curLP);
  }
  function controlStockPedidosCli(curLP: FLSqlCursor): Boolean {
    return this.ctx.articomp_controlStockPedidosCli(curLP);
  }
  function controlStockBCPedidosCli(curLP)
  {
    return this.ctx.articomp_controlStockBCPedidosCli(curLP);
  }
  function controlStockComandasCli(curLV: FLSqlCursor): Boolean {
    return this.ctx.articomp_controlStockComandasCli(curLV);
  }
  function controlStockPedidosProv(curLP: FLSqlCursor): Boolean {
    return this.ctx.articomp_controlStockPedidosProv(curLP);
  }
  function controlStockBCPedidosProv(curLP)
  {
    return this.ctx.articomp_controlStockBCPedidosProv(curLP);
  }
  function controlStockLineasTrans(curLTS: FLSqlCursor): Boolean {
    return this.ctx.articomp_controlStockLineasTrans(curLTS);
  }
  function controlStockLineasComp(curLC)
  {
    return this.ctx.articomp_controlStockLineasComp(curLC);
  }
  function controlStockComposiciones(curComp)
  {
    return this.ctx.articomp_controlStockComposiciones(curComp);
  }
  function controlStockValesTPV(curLinea: FLSqlCursor): Boolean {
    return this.ctx.articomp_controlStockValesTPV(curLinea);
  }
  function controlStockAlbaranesCli(curLA)
  {
    return this.ctx.articomp_controlStockAlbaranesCli(curLA);
  }
  function controlStockBCAlbaranesCli(curLA)
  {
    return this.ctx.articomp_controlStockBCAlbaranesCli(curLA);
  }
  function controlStockAlbaranesProv(curLA)
  {
    return this.ctx.articomp_controlStockAlbaranesProv(curLA);
  }
  function controlStockBCAlbaranesProv(curLA)
  {
    return this.ctx.articomp_controlStockBCAlbaranesProv(curLA);
  }
  function controlStockFacturasCli(curLF)
  {
    return this.ctx.articomp_controlStockFacturasCli(curLF);
  }
  function controlStockBCFacturasCli(curLF)
  {
    return this.ctx.articomp_controlStockBCFacturasCli(curLF);
  }
  function controlStockFacturasProv(curLF)
  {
    return this.ctx.articomp_controlStockFacturasProv(curLF);
  }
  function controlStockBCFacturasProv(curLF)
  {
    return this.ctx.articomp_controlStockBCFacturasProv(curLF);
  }
  function albaranarLineaPedCli(curLA)
  {
    return this.ctx.articomp_albaranarLineaPedCli(curLA);
  }
  function albaranarLineaPedProv(curLA)
  {
    return this.ctx.articomp_albaranarLineaPedProv(curLA);
  }
  function desalbaranarLineaPedCli(curLA)
  {
    return this.ctx.articomp_desalbaranarLineaPedCli(curLA);
  }
  function datosDesalbaranarLPC(curLA)
  {
    return this.ctx.articomp_datosDesalbaranarLPC(curLA);
  }
  function desalbaranarLineaPedProv(curLA)
  {
    return this.ctx.articomp_desalbaranarLineaPedProv(curLA);
  }
  function datosDesalbaranarLineaPedProv(curLA)
  {
    return this.ctx.articomp_datosDesalbaranarLineaPedProv(curLA);
  }
  function unificarMovPtePC(idLineaPedido: String): Boolean {
    return this.ctx.articomp_unificarMovPtePC(idLineaPedido);
  }
  function unificarMovPtePP(idLineaPedido: String): Boolean {
    return this.ctx.articomp_unificarMovPtePP(idLineaPedido);
  }
  //  function albaranarParcialLPC(idLineaPedido:String, curLA:FLSqlCursor):Boolean {
  //    return this.ctx.articomp_albaranarParcialLPC(idLineaPedido, curLA);
  //  }
  //  function albaranarParcialLPP(idLineaPedido:String, curLA:FLSqlCursor):Boolean {
  //    return this.ctx.articomp_albaranarParcialLPP(idLineaPedido, curLA);
  //  }
  function albaranaDatosMoviStock(curMSOrigen, curLA)
  {
    return this.ctx.articomp_albaranaDatosMoviStock(curMSOrigen, curLA);
  }
  function bloquearCalculoStock(bloquear: Boolean)
  {
    return this.ctx.articomp_bloquearCalculoStock(bloquear);
  }
  function afterCommit_lineascomposicion(curLC)
  {
    return this.ctx.articomp_afterCommit_lineascomposicion(curLC);
  }
  function afterCommit_composiciones(curComp)
  {
    return this.ctx.articomp_afterCommit_composiciones(curComp);
  }
  function consistenciaLinea(curLinea)
  {
    return this.ctx.articomp_consistenciaLinea(curLinea);
  }
  function controlStockCabComandas(curComanda)
  {
    return this.ctx.articomp_controlStockCabComandas(curComanda);
  }
}
//// ARTICULOSCOMP //////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pubArticulosComp */
/////////////////////////////////////////////////////////////////
//// PUB_ARTICULOSCOMP //////////////////////////////////////////
class pubArticulosComp extends ifaceCtx
{
  function pubArticulosComp(context)
  {
    ifaceCtx(context);
  }
  function pub_controlStockBCPedidosCli(curLP)
  {
    return this.controlStockBCPedidosCli(curLP);
  }
  function pub_controlStockBCPedidosProv(curLP)
  {
    return this.controlStockBCPedidosProv(curLP);
  }
  function pub_controlStockBCAlbaranesCli(curLA)
  {
    return this.controlStockBCAlbaranesCli(curLA);
  }
  function pub_controlStockBCAlbaranesProv(curLA)
  {
    return this.controlStockBCAlbaranesProv(curLA);
  }
  function pub_controlStockBCFacturasCli(curLF)
  {
    return this.controlStockBCFacturasCli(curLF);
  }
  function pub_controlStockBCFacturasProv(curLF)
  {
    return this.controlStockBCFacturasProv(curLF);
  }
  function pub_pvpCompuesto(referencia: String): Number {
    return this.pvpCompuesto(referencia);
  }
  function pub_calcularFiltroReferencia(referencia: String): String {
    return this.calcularFiltroReferencia(referencia);
  }
  function pub_bloquearCalculoStock(bloquear: Boolean)
  {
    return this.bloquearCalculoStock(bloquear);
  }
  function pub_datosArticulo(cursor, codLote: String): Array {
    return this.datosArticulo(cursor, codLote);
  }
  function pub_desalbaranarLineaPedCli(curLA)
  {
    return this.desalbaranarLineaPedCli(curLA);
  }
  function pub_desalbaranarLineaPedProv(curLA)
  {
    return this.desalbaranarLineaPedProv(curLA);
  }
  function pub_albaranarLineaPedCli(curLA)
  {
    return this.albaranarLineaPedCli(curLA);
  }
  function pub_albaranarLineaPedProv(curLA)
  {
    return this.albaranarLineaPedProv(curLA);
  }
  function pub_dameIdStock(codAlmacen, aDatosArt)
  {
    return this.dameIdStock(codAlmacen, aDatosArt);
  }
  function pub_dameDatosStockLinea(curLinea, curArticuloComp)
  {
    return this.dameDatosStockLinea(curLinea, curArticuloComp);
  }
}
//// PUB_ARTICULOSCOMP //////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition articomp */
/////////////////////////////////////////////////////////////////
//// ARTICULOSCOMP //////////////////////////////////////////////
// function articomp_cambiarStock(codAlmacen:String, referencia:String, variacion:Number, campo:String):Boolean
// {
//  var util:FLUtil = new FLUtil();
//
//  if (!util.sqlSelect("articuloscomp","refcompuesto","refcompuesto = '" + referencia + "'")){
//    if (!this.iface.__cambiarStock(codAlmacen,referencia,variacion,campo))
//      return false;
//  } else {
//    var qry:FLSqlQuery = new FLSqlQuery();
//    qry.setTablesList("articuloscomp");
//    qry.setSelect("refcomponente, cantidad");
//    qry.setFrom("articuloscomp");
//    qry.setWhere("refcompuesto = '" + referencia + "' AND (idtipoopcionart IS NULL OR idtipoopcionart = 0)");
//
//    if (!qry.exec())
//      return false;
//
//    var refComp:String = "";
//    var cantidad:Number = 0;
//
//    while (qry.next()) {
//      refComp = qry.value(0);
//      cantidad = variacion * parseFloat(qry.value(1));
//      if (!this.iface.cambiarStock(codAlmacen, refComp, cantidad, campo))
//        return false;
//    }
//  }
//
//  return true;
//
// }

/** \D Calcula el precio de un artículo compuesto como suma de los precios de sus componentes
@param  referencia: Referencia del artículo cuyo precio se desea calcular
@return: Precio calculado o false si hay error
\end */
function articomp_pvpCompuesto(referencia: String): Number {
  var util: FLUtil = new FLUtil();

  var qry: FLSqlQuery = new FLSqlQuery();
  qry.setTablesList("articuloscomp,articulos");
  qry.setSelect("SUM(a.pvp * ac.cantidad)");
  qry.setFrom("articuloscomp ac INNER JOIN articulos a ON ac.refcomponente = a.referencia");
  qry.setWhere("ac.refcompuesto = '" + referencia + "'");

  if (!qry.exec())
    return false;

  if (!qry.first())
    return false;

  var resultado: Number = util.roundFieldValue(qry.value(0), "articulos", "pvp");
  return resultado;
}

function articomp_beforeCommit_articulos(curArticulo: FLSqlCursor): Boolean {
  var util: FLUtil;

  switch (curArticulo.modeAccess())
  {
    case curArticulo.Edit:
      var unidadAnterior: String = curArticulo.valueBufferCopy("codunidad");
      var unidadActual: String = curArticulo.valueBuffer("codunidad");
      if (unidadAnterior != unidadActual) {
        MessageBox.information(util.translate("scripts", "Ha cambiado la unidad del artículo. Se va a actualizar esta unidad para los artículos compuestos."), MessageBox.Ok, MessageBox.NoButton);
        if (!this.iface.actualizarUnidad(curArticulo.valueBuffer("referencia"), unidadActual))
          return false;
      }
    case curArticulo.Insert:
      /// Parcheado ¿por qué hay que ponerloa a cero?
      // Si es un compuesto el stockminimo se pone a cero
      //      if (util.sqlSelect("articuloscomp","id","refcompuesto = '" + curArticulo.valueBuffer("referencia") + "'")) {
      //        if (curArticulo.valueBuffer("stockmin") != 0)
      //          curArticulo.setValueBuffer("stockmin", 0);
      //        if (curArticulo.valueBuffer("stockmax") != 0)
      //          curArticulo.setValueBuffer("stockmax", 0);
      //      }
      break;
  }

  if (!this.iface.__beforeCommit_articulos(curArticulo))
  {
    return false;
  }

  return true;
}

function articomp_actualizarUnidad(referencia: String, unidad: String): Boolean {
  var curArticulosComp: FLSqlCursor = new FLSqlCursor("articuloscomp");
  curArticulosComp.select("refcomponente = '" + referencia + "'");
  if (!curArticulosComp.first())
    return true;

  do {
    curArticulosComp.setModeAccess(curArticulosComp.Edit);
    curArticulosComp.refreshBuffer();
    curArticulosComp.setValueBuffer("codunidad", unidad);
    if (!curArticulosComp.commitBuffer())
      return false;

  } while (curArticulosComp.next());

  return true;
}

function articomp_calcularFiltroReferencia(referencia: String): String {
  if (!referencia || referencia == "")
    return "";

  var lista: String = "'" + referencia + "'";
  var refCompuesto: String = referencia;

  if (refCompuesto && refCompuesto != "")
  {
    var q: FLSqlQuery = new FLSqlQuery();
    q.setTablesList("articuloscomp");
    q.setSelect("refcompuesto");
    q.setFrom("articuloscomp");
    q.setWhere("refcomponente = '" + refCompuesto + "'");
    if (!q.exec())
      return;

    while (q.next())
      lista = lista + ", " + this.iface.calcularFiltroReferencia(q.value("refcompuesto"));
  }

  return lista;
}

function articomp_afterCommit_tiposopcionartcomp(curTOAC: FLSqlCursor): Boolean {
  var util: FLUtil;

  var referencia: String = curTOAC.valueBuffer("referencia");
  var variable: Boolean = false;

  if (formRecordarticulos.iface.pub_esArticuloVariable(referencia))
  {
    variable = true;
  }

  if (!util.sqlUpdate("articulos", "variable", variable, "referencia = '" + referencia + "'"))
    return false;
  if (!this.iface.comprobarPadresVariables(referencia))
    return false;

  return true;
}

function articomp_afterCommit_articuloscomp(curAC)
{
  var _i = this.iface;
  if (!_i.controlArticuloVariable(curAC)) {
    return false;
  }
  return true;
}

function articomp_controlArticuloVariable(curAC)
{
  var util: FLUtil;

  var referencia: String = curAC.valueBuffer("refcompuesto");
  var variable: Boolean = false;

  if (formRecordarticulos && formRecordarticulos.iface.pub_esArticuloVariable(referencia)) {
    variable = true;
  }

  if (!util.sqlUpdate("articulos", "variable", variable, "referencia = '" + referencia + "'"))
    return false;

  if (!this.iface.comprobarPadresVariables(referencia))
    return false;

  return true;
}

function articomp_comprobarPadresVariables(referencia: String): Boolean {
  var util: FLUtil;

  var q: FLSqlQuery = new FLSqlQuery();
  q.setTablesList("articuloscomp");
  q.setSelect("refcompuesto");
  q.setFrom("articuloscomp");
  q.setWhere("refcomponente = '" + referencia + "'");
  if (!q.exec())
    return;

  var variable: Boolean;
  var refCompuesto: String
  while (q.next())
  {
    refCompuesto = q.value("refcompuesto");
    variable = false;

    if (formRecordarticulos.iface.pub_esArticuloVariable(q.value("refcompuesto"))) {
      variable = true;
    }

    if (!util.sqlUpdate("articulos", "variable", variable, "referencia = '" + refCompuesto + "'"))
      return false;
    if (!this.iface.comprobarPadresVariables(refCompuesto))
      return false;
  }

  return true;
}

function articomp_beforeCommit_opcionesarticulocomp(curOP: FLSqlCursor): Boolean {
  var util: FLUtil;

  if (curOP.modeAccess() == curOP.Insert || curOP.modeAccess() == curOP.Edit)
  {
    var idOpcion: Number = curOP.valueBuffer("idopcion");
    var idTipoOpcionArt: Number = curOP.valueBuffer("idtipoopcionart");
    var idOpcionArticulo: Number = curOP.valueBuffer("idopcionarticulo");

    if (util.sqlSelect("opcionesarticulocomp", "idopcionarticulo", "idopcion = " + idOpcion + " AND idtipoopcionart = " + idTipoOpcionArt + " AND idopcionarticulo <> " + idOpcionArticulo)) {
      MessageBox.warning(util.translate("scripts", "Ya existe una opción de este tipo para este artículo"), MessageBox.Ok, MessageBox.NoButton);
      return false;
    }
  }

  return true;
}



/// //////////////////////
/** \D Genera la estructura de lotes de stock y salidas programadas asociada a los artículos pedidos
\end */
function articomp_generarEstructura(curLinea)
{
  var _i = this.iface;
  var util: FLUtil = new FLUtil;
  var referencia: String = curLinea.valueBuffer("referencia");
  if (!referencia || referencia == "") {
    return true;
  }

  if (!this.iface.generarMoviStock(curLinea, false)) {
    return false;
  }

  if (!_i.consistenciaLinea(curLinea)) {
    return false;
  }

  return true;
}

/** \D Función a sobrecargar por extensiones como la de barcodes
@param  cursor: Cursor que contiene los datos que identifican el artículo
@param  codLote: Código del lote del artículo
@param  curLinea: Cursor con los datos del artículos compuesto, si es el caso
@return array con datos identificativos del artículo
\end */
function articomp_datosArticulo(cursor, codLote, curLinea)
{
  var util: FLUtil = new FLUtil;
  var res: Array = [];
  var referencia: String = "";

  switch (cursor.table()) {
    case "articuloscomp": {
      referencia = cursor.valueBuffer("refcomponente")
                   break;
    }
    default: {
      referencia = cursor.valueBuffer("referencia")
                   break;
    }
  }
  res["localizador"] = "referencia = '" + referencia + "'";
  res["referencia"] = referencia;

  return res;
}

/** Establece la cantidad de un movimiento de stock para pedidos parciales
\end */
function articomp_establecerCantidad(curLinea)
{
  var cantidad: Number;
  switch (curLinea.table()) {
    case "lineaspedidoscli":
    case "lineaspedidosprov": {
      var totalAlbaran = curLinea.valueBuffer("totalenalbaran");
      totalAlbaran = isNaN(totalAlbaran) ? 0 : totalAlbaran;
      cantidad = parseFloat(curLinea.valueBuffer("cantidad")) - totalAlbaran;
      if (totalAlbaran != 0 && cantidad < 0) {
        cantidad = 0;  /// Evita generar cantidades pendientes negativas cuando se ha recibido más de lo solicitado
      }
      break;
    }
    default: {
      cantidad = curLinea.valueBuffer("cantidad");
      break;
    }
    return cantidad;
  }
  return cantidad;
}

/** \D Desactiva el cáculo de stocks al modificarse movimientos de stock. Usar con cuidado
\end */
function articomp_bloquearCalculoStock(bloquear: Boolean)
{
  this.iface.calculoStockBloqueado_ = bloquear;
}

/** \D Obtiene los datos de almacén y fecha correspondientes a los movimientos asociados a una línea de facturación
@param  curLinea: Cursor de la línea
@param  curArticuloComp: Cursor de la composición
@return array con los datos:
\end */
function articomp_dameDatosStockLinea(curLinea, curArticuloComp)
{
  debug("articomp_dameDatosStockLinea");
  var util: FLUtil = new FLUtil;
  var aDatos: Array = [];
  var aAux: Array;
  var tabla: String = curLinea.table();
  var curRelation: FLSqlCursor = curLinea.cursorRelation();
  var tablaRel: String = curRelation ? curRelation.table() : "";
  var codAlmacen: String, hora: String;

  switch (tabla) {
    case "lineaspedidoscli": {
      aDatos.idLinea = curLinea.valueBuffer("idlinea");
      if (tablaRel == "pedidoscli") {
        aDatos.codAlmacen = curRelation.valueBuffer("codalmacen");
        aDatos.fechaPrev = curRelation.valueBuffer("fechasalida");
        aDatos.concepto = curRelation.valueBuffer("codigo");
        aDatos.concepto += " " + curRelation.valueBuffer("nombrecliente");
      } else {
        aAux = flfactppal.iface.pub_ejecutarQry("pedidoscli", "codalmacen,fechasalida,codigo,nombrecliente", "idpedido = " + curLinea.valueBuffer("idpedido"));
        if (aAux.result != 1) {
          return false;
        }
        aDatos.codAlmacen = aAux.codalmacen;
        aDatos.fechaPrev = aAux.fechasalida;
        aDatos.concepto = aAux.codigo;
        aDatos.concepto += " " + aAux.nombrecliente;
      }
      aDatos.concepto = sys.translate("Pedido cliente %1").arg(aDatos.concepto);
      break;
    }
    case "lineaspedidosprov": {
      aDatos.idLinea = curLinea.valueBuffer("idlinea");
      if (tablaRel == "pedidosprov") {
        aDatos.codAlmacen = curRelation.valueBuffer("codalmacen");
        aDatos.fechaPrev = curRelation.valueBuffer("fechaentrada");
        aDatos.concepto = curRelation.valueBuffer("codigo");
        aDatos.concepto += " " + curRelation.valueBuffer("nombre");
      } else {
        aAux = flfactppal.iface.pub_ejecutarQry("pedidosprov", "codalmacen,fechaentrada,codigo,nombre", "idpedido = " + curLinea.valueBuffer("idpedido"));
        if (aAux.result != 1) {
          return false;
        }
        aDatos.codAlmacen = aAux.codalmacen;
        aDatos.fechaPrev = aAux.fechaentrada;
        aDatos.concepto = aAux.codigo;
        aDatos.concepto += " " + aAux.nombre;
      }
      aDatos.concepto = sys.translate("Pedido proveedor %1").arg(aDatos.concepto);
      break;
    }
    case "tpv_lineascomanda": {
      aDatos.idLinea = curLinea.valueBuffer("idtpv_linea");
      if (tablaRel == "tpv_comandas") {
        aDatos.codAlmacen = curRelation.valueBuffer("codalmacen");
        aDatos.fechaReal = curRelation.valueBuffer("fecha");
        hora = curRelation.valueBuffer("hora");
        aDatos.concepto = curRelation.valueBuffer("codigo");
        aDatos.concepto += " " + curRelation.valueBuffer("nombrecliente");
      } else {
        aAux = flfactppal.iface.pub_ejecutarQry("tpv_comandas", "codalmacen,fecha,hora,codigo,nombrecliente", "idtpv_comanda = " + curLinea.valueBuffer("idtpv_comanda"));
        if (aAux.result != 1) {
          return false;
        }
        aDatos.codAlmacen = aAux.codalmacen;
        aDatos.fechaReal = aAux.fecha;
        hora = aAux.hora;
        aDatos.concepto = aAux.codigo;
        aDatos.concepto += " " + aAux.nombrecliente;
      }
      aDatos.horaReal = hora.toString().right(8);
      aDatos.concepto = sys.translate("Venta TPV %1").arg(aDatos.concepto);
      break;
    }
    case "tpv_lineasvale": {
      aDatos.idLinea = curLinea.valueBuffer("idlinea");
      aDatos.fechaReal = curLinea.valueBuffer("fecha");
      hora = curLinea.valueBuffer("hora");
      aDatos.horaReal = hora.toString().right(8);
      aDatos.codAlmacen = curLinea.valueBuffer("codalmacen");
      aDatos.concepto = sys.translate("Vale TPV");
      break;
    }
    case "lineasalbaranescli": {
      aDatos.idLinea = curLinea.valueBuffer("idlinea");
      if (tablaRel == "albaranescli") {
        aDatos.codAlmacen = curRelation.valueBuffer("codalmacen");
        aDatos.fechaReal = curRelation.valueBuffer("fecha");
        hora = curRelation.valueBuffer("hora");
        aDatos.concepto = curRelation.valueBuffer("codigo");
        aDatos.concepto += " " + curRelation.valueBuffer("nombrecliente");
      } else {
        aAux = flfactppal.iface.pub_ejecutarQry("albaranescli", "codalmacen,fecha,hora,codigo,nombrecliente", "idalbaran = " + curLinea.valueBuffer("idalbaran"));
        if (aAux.result != 1) {
          return false;
        }
        aDatos.codAlmacen = aAux.codalmacen;
        aDatos.fechaReal = aAux.fecha;
        hora = aAux.hora;
        aDatos.concepto = aAux.codigo;
        aDatos.concepto += " " + aAux.nombrecliente;
      }
      aDatos.horaReal = hora.toString().right(8);
      aDatos.concepto = sys.translate("Albarán cliente %1").arg(aDatos.concepto);
      break;
    }
    case "lineasalbaranesprov": {
      aDatos.idLinea = curLinea.valueBuffer("idlinea");
      if (tablaRel == "albaranesprov") {
        aDatos.codAlmacen = curRelation.valueBuffer("codalmacen");
        aDatos.fechaReal = curRelation.valueBuffer("fecha");
        hora = curRelation.valueBuffer("hora");
        aDatos.concepto = curRelation.valueBuffer("codigo");
        aDatos.concepto += " " + curRelation.valueBuffer("nombre");
      } else {
        aAux = flfactppal.iface.pub_ejecutarQry("albaranesprov", "codalmacen,fecha,hora,codigo,nombre", "idalbaran = " + curLinea.valueBuffer("idalbaran"));
        if (aAux.result != 1) {
          return false;
        }
        aDatos.codAlmacen = aAux.codalmacen;
        aDatos.fechaReal = aAux.fecha;
        hora = aAux.hora;
        aDatos.concepto = aAux.codigo;
        aDatos.concepto += " " + aAux.nombre;
      }
      aDatos.horaReal = hora.toString().right(8);
      aDatos.concepto = sys.translate("Albarán proveedor %1").arg(aDatos.concepto);
      break;
    }
    case "lineasfacturascli": {
      aDatos.idLinea = curLinea.valueBuffer("idlinea");
      if (tablaRel == "facturascli") {
        aDatos.codAlmacen = curRelation.valueBuffer("codalmacen");
        aDatos.fechaReal = curRelation.valueBuffer("fecha");
        hora = curRelation.valueBuffer("hora");
        aDatos.concepto = curRelation.valueBuffer("codigo");
        aDatos.concepto += " " + curRelation.valueBuffer("nombrecliente");
      } else {
        aAux = flfactppal.iface.pub_ejecutarQry("facturascli", "codalmacen,fecha,hora,codigo,nombrecliente", "idfactura = " + curLinea.valueBuffer("idfactura"));
        if (aAux.result != 1) {
          return false;
        }
        aDatos.codAlmacen = aAux.codalmacen;
        aDatos.fechaReal = aAux.fecha;
        hora = aAux.hora;
        aDatos.concepto = aAux.codigo;
        aDatos.concepto += " " + aAux.nombrecliente;
      }
      aDatos.horaReal = hora.toString().right(8);
      aDatos.concepto = sys.translate("Factura cliente %1").arg(aDatos.concepto);
      break;
    }
    case "lineasfacturasprov": {
      aDatos.idLinea = curLinea.valueBuffer("idlinea");
      if (tablaRel == "facturasprov") {
        aDatos.codAlmacen = curRelation.valueBuffer("codalmacen");
        aDatos.fechaReal = curRelation.valueBuffer("fecha");
        hora = curRelation.valueBuffer("hora");
        aDatos.concepto = curRelation.valueBuffer("codigo");
        aDatos.concepto += " " + curRelation.valueBuffer("nombre");
      } else {
        aAux = flfactppal.iface.pub_ejecutarQry("facturasprov", "codalmacen,fecha,hora,codigo,nombre", "idfactura = " + curLinea.valueBuffer("idfactura"));
        if (aAux.result != 1) {
          return false;
        }
        aDatos.codAlmacen = aAux.codalmacen;
        aDatos.fechaReal = aAux.fecha;
        hora = aAux.hora;
        aDatos.concepto = aAux.codigo;
        aDatos.concepto += " " + aAux.nombre;
      }
      aDatos.horaReal = hora.toString().right(8);
      aDatos.concepto = sys.translate("Factura proveedor %1").arg(aDatos.concepto);
      break;
    }
    case "lineastransstock": {
      aDatos.idLinea = curLinea.valueBuffer("idlinea");
      if (tablaRel == "transstock") {
        aDatos.codAlmaOrigen = curRelation.valueBuffer("codalmaorigen");
        aDatos.codAlmaDestino = curRelation.valueBuffer("codalmadestino");
        aDatos.fechaReal = curRelation.valueBuffer("fecha");
        hora = curRelation.valueBuffer("hora");
      } else {
        aAux = flfactppal.iface.pub_ejecutarQry("transstock", "codalmaorigen,codalmadestino,fecha,hora", "idtrans = " + curLinea.valueBuffer("idtrans"));
        if (aAux.result != 1) {
          return false;
        }
        aDatos.codAlmaOrigen = aAux.codalmaorigen;
        aDatos.codAlmaDestino = aAux.codalmadestino;
        aDatos.fechaReal = aAux.fecha;
        hora = aAux.hora;
      }
      aDatos.horaReal = hora.toString().right(8);
      aDatos.concepto = sys.translate("Transferencia %1 desde %2 hasta %3").arg(curLinea.valueBuffer("idtrans")).arg(aDatos.codAlmaOrigen).arg(aDatos.codAlmaDestino);
      break;
    }
    case "composiciones": {
      aDatos.idLinea = curLinea.valueBuffer("idcomposicion");
      aDatos.codAlmacen = curLinea.valueBuffer("codalmacen");
      aDatos.fechaReal = curLinea.valueBuffer("fecha");
      hora = curLinea.valueBuffer("hora");;
      aDatos.horaReal = hora.toString().right(8);
      break;
    }
    case "lineascomposicion": {
      aDatos.idLinea = curLinea.valueBuffer("idlinea");
      aDatos.codAlmacen = curLinea.valueBuffer("codalmacen");
      if (tablaRel == "composiciones") {
        aDatos.fechaReal = curRelation.valueBuffer("fecha");
        hora = curRelation.valueBuffer("hora");
      } else {
        aAux = flfactppal.iface.pub_ejecutarQry("composiciones", "fecha,hora", "idcomposicion = " + curLinea.valueBuffer("idcomposicion"));
        if (aAux.result != 1) {
          return false;
        }
        aDatos.fechaReal = aAux.fecha;
        hora = aAux.hora;
      }
      aDatos.horaReal = hora.toString().right(8);
      break;
    }
    default: {
      aDatos = false;
    }
  }
  return aDatos;
}

function articomp_datosArticuloMS(datosArt, aDatosStockLinea)
{
  var _i = this.iface;
  _i.curMoviStock.setValueBuffer("referencia", datosArt["referencia"]);
  if (aDatosStockLinea) {
    if ("concepto" in aDatosStockLinea) {
      _i.curMoviStock.setValueBuffer("concepto", aDatosStockLinea.concepto);
    }
  }
  return true;
}

/** Indica si hay que generar o no movimientos de stock para los componentes del artículo
@param  aDatosArt: Array con los datos de identificación del artículo
@param  idProceso: Proceso al que asociar el movimiento
\end */
function articomp_generarMoviStockComponentes(aDatosArt: Array, idProceso: String): Boolean {
  var util: FLUtil = new FLUtil;
  var generar: Boolean = false;
  if (util.sqlSelect("articulos a INNER JOIN articuloscomp ac ON a.referencia = ac.refcompuesto", "a.stockcomp", "a.referencia = '" + aDatosArt["referencia"] + "'", "articulos,articuloscomp"))
  {
    generar = true;
  }
  return generar;
}

/** Genera uno o más movimientos de stock asociados a una línea de documento de facturación
\end */
function articomp_generarMoviStock(curLinea: FLSqlCursor, codLote: String, cantidad: Number, curArticuloComp: FLSqlCursor, idProceso: String): Boolean {
  var util: FLUtil = new FLUtil;

  var idLinea: String;
  var idPadre: String;
  var fechaPrev: String;
  var fechaReal: String;
  var horaReal: String;
  var codAlmacen: String;
  var codAlmacenOrigen: String;
  var codAlmacenDestino: String;
  var referencia: String;
  var datosArt: Array;

  var tabla: String = curLinea.table();

  switch (tabla)
  {
    case "lineaspedidoscli":  {
      if (curLinea.valueBuffer("cerrada")) {
        return true;
      }
      break;

      /// Se usa en la regeneración automática de stocks. Fuerza la creación de un movimiento pendiente que luego será albaranado
      //       if (curLinea.valueBuffer("cerrada")) {
      //        var totalAlb = curLinea.valueBuffer("totalenalbaran");
      //        if (totalAlb > 0) {
      //          var canMov = parseFloat(AQUtil.sqlSelect("movistock", "SUM(cantidad)", "idlineapc = " + curLinea.valueBuffer("idlinea") + " AND estado = 'HECHO'"));
      //          canMov = isNaN(canMov) ? 0 : canMov;
      //          canMov *= -1;
      //          var resto = totalAlb - canMov;
      //          if (resto > 0) {
      //            cantidad = resto;
      //            break;
      //          }
      //        }
      //        return true;
      //      }
    }
    case "lineaspedidosprov": {
      if (curLinea.valueBuffer("cerrada")) {
        return true;
      }
      break;
      //      if (curLinea.valueBuffer("cerrada")) {
      //        var totalAlb = curLinea.valueBuffer("totalenalbaran");
      //        if (totalAlb > 0) {
      //          var canMov = parseFloat(AQUtil.sqlSelect("movistock", "SUM(cantidad)", "idlineapp = " + curLinea.valueBuffer("idlinea") + " AND estado = 'HECHO'"));
      //          canMov = isNaN(canMov) ? 0 : canMov;
      //          var resto = totalAlb - canMov;
      //          if (resto > 0) {
      //            cantidad = resto;
      //            break;
      //          }
      //        }
      //        return true;
      //      }
      //      break;
    }
    case "tpv_lineascomanda": {
      var curR = curLinea.cursorRelation();
      var tipoDoc = curR ? curR.valueBuffer("tipodoc") : AQUtil.sqlSelect("tpv_comandas", "tipodoc", "idtpv_comanda = " + curLinea.valueBuffer("idtpv_comanda"));

      debug("tpv_lineascomanda tipoDoc: " + tipoDoc);

      if (tipoDoc == "presupuesto") {
        return true;
      }
      break;
    }
  }

  if (curArticuloComp)
  {
    datosArt = this.iface.datosArticulo(curArticuloComp, false, curLinea);
  } else {
    datosArt = this.iface.datosArticulo(curLinea, codLote);
  }
  if (datosArt["referencia"] == "")
  {
    return true;
  }
  if (!cantidad || isNaN(cantidad))
  {
    cantidad = this.iface.establecerCantidad(curLinea);
  }
  if (!cantidad)
  {
    return true;
  }
  /** Para artículos compuestos que no son fabricados, se crean tantos movimientos de stock como componentes haya */
  if (this.iface.generarMoviStockComponentes(datosArt, idProceso))
  {
    var nuevaCantidad: Number;
    var curAC: FLSqlCursor = new FLSqlCursor("articuloscomp");
    curAC.select("refcompuesto = '" + datosArt["referencia"] + "'");
    var hayComponentes = false;
    while (curAC.next()) {
      hayComponentes = true;
      curAC.setModeAccess(curAC.Browse);
      curAC.refreshBuffer();
      nuevaCantidad = cantidad * curAC.valueBuffer("cantidad");
      if (!this.iface.generarMoviStock(curLinea, codLote, nuevaCantidad, curAC)) {
        return false;
      }
    }
    if (hayComponentes) {
      return true;
    }
  }
  var aDatosStockLinea: Array = this.iface.dameDatosStockLinea(curLinea, curArticuloComp);
  if (!aDatosStockLinea)
  {
    return false;
  }

  if (!this.iface.curMoviStock)
  {
    this.iface.curMoviStock = new FLSqlCursor("movistock");
  }

  aDatosStockLinea.cantidad = cantidad;
  aDatosStockLinea.idProceso = idProceso;
  aDatosStockLinea.codLote = codLote;

  if (!this.iface.creaRegMoviStock(curLinea, datosArt, aDatosStockLinea, curArticuloComp))
  {
    return false;
  }

  return true;
}

function articomp_dameIdStock(codAlmacen, aDatosArt)
{
  var _i = this.iface;
  if (!codAlmacen || codAlmacen == "") {
    MessageBox.critical(AQUtil.translate("scripts", "Error: Intenta generar un movimiento de stock sin especificar el almacén asociado"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  var where = "codalmacen = '" + codAlmacen + "'";
  if ("barcode" in aDatosArt) {
    if (aDatosArt.barcode && aDatosArt.barcode != "") {
      where += " AND barcode = '" + aDatosArt.barcode + "'";
    } else {
      where += " AND referencia = '" + aDatosArt.referencia + "'";
    }
  } else {
    where += " AND referencia = '" + aDatosArt.referencia + "'";
  }
  var idStock: String = AQUtil.sqlSelect("stocks", "idstock", where);
  if (!idStock || idStock == "") {
    idStock = _i.crearStock(codAlmacen, aDatosArt);
  }
  if (!idStock || idStock == "") {
    MessageBox.critical(sys.translate("Error: No pudo crearse el stock para el artículo %1 y el almacén %2").arg(aDatosArt["referencia"]).arg(codAlmacen), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  return idStock;
}

function articomp_creaRegMoviStock(curLinea, aDatosArt, aDatosStockLinea, curArticuloComp)
{
  var tabla: String = curLinea.table();
  var cantidad: Number = aDatosStockLinea.cantidad;
  var idLinea: String = aDatosStockLinea.idLinea;
  var idStock: String;
  switch (tabla) {
    case "lineaspresupuestoscli": {
      idStock = this.iface.dameIdStock(aDatosStockLinea.codAlmacen, aDatosArt);
      if (!idStock) {
        return false;
      }
      cantidad = parseFloat(cantidad) * -1;
      this.iface.curMoviStock.setModeAccess(this.iface.curMoviStock.Insert);
      this.iface.curMoviStock.refreshBuffer();
      this.iface.curMoviStock.setValueBuffer("idlineapr", idLinea);
      this.iface.curMoviStock.setValueBuffer("estado", "PTE");
      this.iface.curMoviStock.setValueBuffer("fechaprev", aDatosStockLinea.fechaPrev);
      this.iface.curMoviStock.setValueBuffer("cantidad", cantidad);
      this.iface.curMoviStock.setValueBuffer("idstock", idStock);

      if (!this.iface.datosArticuloMS(aDatosArt, aDatosStockLinea)) {
        return false;
      }
      if (aDatosStockLinea.codLote) {
        this.iface.curMoviStock.setValueBuffer("codlote", aDatosStockLinea.codLote);
      } else {
        this.iface.curMoviStock.setNull("codlote");
      }
      if (!this.iface.curMoviStock.commitBuffer()) {
        return false;
      }
      break;
    }
    case "lineaspedidoscli": {
      idStock = this.iface.dameIdStock(aDatosStockLinea.codAlmacen, aDatosArt);
      if (!idStock) {
        return false;
      }
      cantidad = parseFloat(cantidad) * -1;
      this.iface.curMoviStock.setModeAccess(this.iface.curMoviStock.Insert);
      this.iface.curMoviStock.refreshBuffer();
      this.iface.curMoviStock.setValueBuffer("idlineapc", idLinea);
      this.iface.curMoviStock.setValueBuffer("estado", "PTE");
      this.iface.curMoviStock.setValueBuffer("fechaprev", aDatosStockLinea.fechaPrev);
      this.iface.curMoviStock.setValueBuffer("cantidad", cantidad);
      this.iface.curMoviStock.setValueBuffer("idstock", idStock);
      if (!this.iface.datosArticuloMS(aDatosArt, aDatosStockLinea)) {
        return false;
      }
      if (aDatosStockLinea.codLote) {
        this.iface.curMoviStock.setValueBuffer("codlote", aDatosStockLinea.codLote);
      } else {
        this.iface.curMoviStock.setNull("codlote");
      }
      if (!this.iface.curMoviStock.commitBuffer()) {
        return false;
      }
      break;
    }
    case "lineaspedidosprov": {
      idStock = this.iface.dameIdStock(aDatosStockLinea.codAlmacen, aDatosArt);
      if (!idStock) {
        return false;
      }
      cantidad = parseFloat(cantidad);
      this.iface.curMoviStock.setModeAccess(this.iface.curMoviStock.Insert);
      this.iface.curMoviStock.refreshBuffer();
      this.iface.curMoviStock.setValueBuffer("idlineapp", idLinea);
      this.iface.curMoviStock.setValueBuffer("estado", "PTE");
      this.iface.curMoviStock.setValueBuffer("fechaprev", aDatosStockLinea.fechaPrev);
      this.iface.curMoviStock.setValueBuffer("cantidad", cantidad);
      this.iface.curMoviStock.setValueBuffer("idstock", idStock);
      if (!this.iface.datosArticuloMS(aDatosArt, aDatosStockLinea)) {
        return false;
      }
      if (aDatosStockLinea.codLote) {
        this.iface.curMoviStock.setValueBuffer("codlote", aDatosStockLinea.codLote);
      } else {
        this.iface.curMoviStock.setNull("codlote");
      }
      if (!this.iface.curMoviStock.commitBuffer()) {
        return false;
      }
      break;
    }
    case "tpv_lineascomanda": {
      idStock = this.iface.dameIdStock(aDatosStockLinea.codAlmacen, aDatosArt);
      if (!idStock) {
        return false;
      }
      cantidad = parseFloat(cantidad) * -1;
      this.iface.curMoviStock.setModeAccess(this.iface.curMoviStock.Insert);
      this.iface.curMoviStock.refreshBuffer();
      this.iface.curMoviStock.setValueBuffer("cantidad", cantidad);
      this.iface.curMoviStock.setValueBuffer("idlineaco", idLinea);
      this.iface.curMoviStock.setValueBuffer("estado", "HECHO");
      this.iface.curMoviStock.setValueBuffer("fechareal", aDatosStockLinea.fechaReal);
      this.iface.curMoviStock.setValueBuffer("horareal", aDatosStockLinea.horaReal);
      this.iface.curMoviStock.setValueBuffer("idstock", idStock);
      if (!this.iface.datosArticuloMS(aDatosArt, aDatosStockLinea)) {
        return false;
      }
      if (aDatosStockLinea.codLote) {
        this.iface.curMoviStock.setValueBuffer("codlote", aDatosStockLinea.codLote);
      } else {
        this.iface.curMoviStock.setNull("codlote");
      }
      if (!this.iface.curMoviStock.commitBuffer()) {
        return false;
      }
      break;
    }
    case "lineasalbaranescli": {
      cantidad = parseFloat(cantidad) * -1;
      var idLineaPedido: String = curLinea.valueBuffer("idlineapedido");
      idStock = this.iface.dameIdStock(aDatosStockLinea.codAlmacen, aDatosArt);
      if (!idStock) {
        return false;
      }
      this.iface.curMoviStock.setModeAccess(this.iface.curMoviStock.Insert);
      this.iface.curMoviStock.refreshBuffer();
      this.iface.curMoviStock.setValueBuffer("cantidad", cantidad);
      this.iface.curMoviStock.setValueBuffer("idstock", idStock);
      if (!this.iface.datosArticuloMS(aDatosArt, aDatosStockLinea)) {
        return false;
      }
      this.iface.curMoviStock.setValueBuffer("idlineaac", idLinea);
      this.iface.curMoviStock.setValueBuffer("estado", "HECHO");
      this.iface.curMoviStock.setValueBuffer("fechareal", aDatosStockLinea.fechaReal);
      this.iface.curMoviStock.setValueBuffer("horareal", aDatosStockLinea.horaReal);
      if (aDatosStockLinea.codLote) {
        this.iface.curMoviStock.setValueBuffer("codlote", aDatosStockLinea.codLote);
      } else {
        this.iface.curMoviStock.setNull("codlote");
      }
      if (!this.iface.curMoviStock.commitBuffer()) {
        return false;
      }
      break;
    }
    case "lineasfacturascli": {
      idStock = this.iface.dameIdStock(aDatosStockLinea.codAlmacen, aDatosArt);
      if (!idStock) {
        return false;
      }
      cantidad = parseFloat(cantidad) * -1;
      this.iface.curMoviStock.setModeAccess(this.iface.curMoviStock.Insert);
      this.iface.curMoviStock.refreshBuffer();
      this.iface.curMoviStock.setValueBuffer("cantidad", cantidad);
      this.iface.curMoviStock.setValueBuffer("idlineafc", idLinea);
      this.iface.curMoviStock.setValueBuffer("estado", "HECHO");
      this.iface.curMoviStock.setValueBuffer("fechareal", aDatosStockLinea.fechaReal);
      this.iface.curMoviStock.setValueBuffer("horareal", aDatosStockLinea.horaReal);
      this.iface.curMoviStock.setValueBuffer("idstock", idStock);
      if (!this.iface.datosArticuloMS(aDatosArt, aDatosStockLinea)) {
        return false;
      }
      if (aDatosStockLinea.codLote) {
        this.iface.curMoviStock.setValueBuffer("codlote", aDatosStockLinea.codLote);
      } else {
        this.iface.curMoviStock.setNull("codlote");
      }
      if (!this.iface.curMoviStock.commitBuffer()) {
        return false;
      }
      break;
    }
    case "lineasfacturasprov": {
      idStock = this.iface.dameIdStock(aDatosStockLinea.codAlmacen, aDatosArt);
      if (!idStock) {
        return false;
      }
      cantidad = parseFloat(cantidad);
      this.iface.curMoviStock.setModeAccess(this.iface.curMoviStock.Insert);
      this.iface.curMoviStock.refreshBuffer();
      this.iface.curMoviStock.setValueBuffer("cantidad", cantidad);
      this.iface.curMoviStock.setValueBuffer("idlineafp", idLinea);
      this.iface.curMoviStock.setValueBuffer("estado", "HECHO");
      this.iface.curMoviStock.setValueBuffer("fechareal", aDatosStockLinea.fechaReal);
      this.iface.curMoviStock.setValueBuffer("horareal", aDatosStockLinea.horaReal);
      this.iface.curMoviStock.setValueBuffer("idstock", idStock);
      if (!this.iface.datosArticuloMS(aDatosArt, aDatosStockLinea)) {
        return false;
      }
      if (aDatosStockLinea.codLote) {
        this.iface.curMoviStock.setValueBuffer("codlote", aDatosStockLinea.codLote);
      } else {
        this.iface.curMoviStock.setNull("codlote");
      }
      if (!this.iface.curMoviStock.commitBuffer()) {
        return false;
      }
      break;
    }
    case "tpv_lineasvale": {
      idStock = this.iface.dameIdStock(aDatosStockLinea.codAlmacen, aDatosArt);
      if (!idStock) {
        return false;
      }
      cantidad = parseFloat(cantidad);
      this.iface.curMoviStock.setModeAccess(this.iface.curMoviStock.Insert);
      this.iface.curMoviStock.refreshBuffer();
      this.iface.curMoviStock.setValueBuffer("cantidad", cantidad);
      this.iface.curMoviStock.setValueBuffer("idlineava", idLinea);
      this.iface.curMoviStock.setValueBuffer("estado", "HECHO");
      this.iface.curMoviStock.setValueBuffer("fechareal", aDatosStockLinea.fechaReal);
      this.iface.curMoviStock.setValueBuffer("horareal", aDatosStockLinea.horaReal);
      this.iface.curMoviStock.setValueBuffer("idstock", idStock);
      if (!this.iface.datosArticuloMS(aDatosArt, aDatosStockLinea)) {
        return false;
      }
      if (aDatosStockLinea.codLote) {
        this.iface.curMoviStock.setValueBuffer("codlote", aDatosStockLinea.codLote);
      } else {
        this.iface.curMoviStock.setNull("codlote");
      }
      if (!this.iface.curMoviStock.commitBuffer()) {
        return false;
      }
      break;
    }
    case "lineasalbaranesprov": {
      cantidad = parseFloat(cantidad);
      var idLineaPedido: String = curLinea.valueBuffer("idlineapedido");
      idStock = this.iface.dameIdStock(aDatosStockLinea.codAlmacen, aDatosArt);
      if (!idStock) {
        return false;
      }
      this.iface.curMoviStock.setModeAccess(this.iface.curMoviStock.Insert);
      this.iface.curMoviStock.refreshBuffer();
      this.iface.curMoviStock.setValueBuffer("cantidad", cantidad);
      this.iface.curMoviStock.setValueBuffer("idstock", idStock);
      if (!this.iface.datosArticuloMS(aDatosArt, aDatosStockLinea)) {
        return false;
      }
      this.iface.curMoviStock.setValueBuffer("idlineaap", idLinea);
      this.iface.curMoviStock.setValueBuffer("estado", "HECHO");
      this.iface.curMoviStock.setValueBuffer("fechareal", aDatosStockLinea.fechaReal);
      this.iface.curMoviStock.setValueBuffer("horareal", aDatosStockLinea.horaReal);
      if (aDatosStockLinea.codLote) {
        this.iface.curMoviStock.setValueBuffer("codlote", aDatosStockLinea.codLote);
      } else {
        this.iface.curMoviStock.setNull("codlote");
      }
      if (!this.iface.curMoviStock.commitBuffer()) {
        return false;
      }
      debug("case lineasalbaranesprov: {");
      break;
    }
    case "lineastransstock": {
      idStock = this.iface.dameIdStock(aDatosStockLinea.codAlmaOrigen, aDatosArt);
      if (!idStock) {
        return false;
      }
      cantidad = parseFloat(cantidad);
      this.iface.curMoviStock.setModeAccess(this.iface.curMoviStock.Insert);
      this.iface.curMoviStock.refreshBuffer();
      this.iface.curMoviStock.setValueBuffer("idlineats", idLinea);
      this.iface.curMoviStock.setValueBuffer("estado", "HECHO");
      this.iface.curMoviStock.setValueBuffer("fechareal", aDatosStockLinea.fechaReal);
      this.iface.curMoviStock.setValueBuffer("horareal", aDatosStockLinea.horaReal);
      this.iface.curMoviStock.setValueBuffer("cantidad", (cantidad * -1));
      this.iface.curMoviStock.setValueBuffer("idstock", idStock);
      if (!this.iface.datosArticuloMS(aDatosArt, aDatosStockLinea)) {
        return false;
      }
      if (aDatosStockLinea.codLote) {
        this.iface.curMoviStock.setValueBuffer("codlote", aDatosStockLinea.codLote);
      } else {
        this.iface.curMoviStock.setNull("codlote");
      }
      if (!this.iface.curMoviStock.commitBuffer()) {
        MessageBox.critical(util.translate("scripts", "Error: No pudo crearse el movimiento de stock para el artículo %1 y el almacén %2").arg(aDatosArt["referencia"]).arg(aDatosStockLinea.codAlmaOrigen), MessageBox.Ok, MessageBox.NoButton);
        return false;
      }

      var idStockDestino: String = this.iface.dameIdStock(aDatosStockLinea.codAlmaDestino, aDatosArt);
      if (!idStockDestino) {
        return false;
      }
      this.iface.curMoviStock.setModeAccess(this.iface.curMoviStock.Insert);
      this.iface.curMoviStock.refreshBuffer();
      this.iface.curMoviStock.setValueBuffer("idlineats", idLinea);
      this.iface.curMoviStock.setValueBuffer("estado", "HECHO");
      this.iface.curMoviStock.setValueBuffer("fechareal", aDatosStockLinea.fechaReal);
      this.iface.curMoviStock.setValueBuffer("horareal", aDatosStockLinea.horaReal);
      this.iface.curMoviStock.setValueBuffer("cantidad", cantidad);
      this.iface.curMoviStock.setValueBuffer("idstock", idStockDestino);
      if (!this.iface.datosArticuloMS(aDatosArt, aDatosStockLinea)) {
        return false;
      }
      if (aDatosStockLinea.codLote) {
        this.iface.curMoviStock.setValueBuffer("codlote", aDatosStockLinea.codLote);
      } else {
        this.iface.curMoviStock.setNull("codlote");
      }
      if (!this.iface.curMoviStock.commitBuffer()) {
        MessageBox.critical(util.translate("scripts", "Error: No pudo crearse el movimiento de stock para el artículo %1 y el almacén %2").arg(aDatosArt["referencia"]).arg(aDatosStockLinea.codAlmaDestino), MessageBox.Ok, MessageBox.NoButton);
        return false;
      }
      break;
    }
    case "composiciones": {
      idStock = this.iface.dameIdStock(aDatosStockLinea.codAlmacen, aDatosArt);
      if (!idStock) {
        return false;
      }
      cantidad = parseFloat(cantidad);
      this.iface.curMoviStock.setModeAccess(this.iface.curMoviStock.Insert);
      this.iface.curMoviStock.refreshBuffer();
      this.iface.curMoviStock.setValueBuffer("cantidad", cantidad);
      this.iface.curMoviStock.setValueBuffer("idcomposicion", idLinea);
      this.iface.curMoviStock.setValueBuffer("estado", "HECHO");
      this.iface.curMoviStock.setValueBuffer("fechareal", aDatosStockLinea.fechaReal);
      this.iface.curMoviStock.setValueBuffer("horareal", aDatosStockLinea.horaReal);
      this.iface.curMoviStock.setValueBuffer("idstock", idStock);
      if (!this.iface.datosArticuloMS(aDatosArt, aDatosStockLinea)) {
        return false;
      }
      if (aDatosStockLinea.codLote) {
        this.iface.curMoviStock.setValueBuffer("codlote", aDatosStockLinea.codLote);
      } else {
        this.iface.curMoviStock.setNull("codlote");
      }
      if (!this.iface.curMoviStock.commitBuffer()) {
        return false;
      }
      break;
    }
    case "lineascomposicion": {
      idStock = this.iface.dameIdStock(aDatosStockLinea.codAlmacen, aDatosArt);
      if (!idStock) {
        return false;
      }
      cantidad = parseFloat(cantidad) * -1;
      this.iface.curMoviStock.setModeAccess(this.iface.curMoviStock.Insert);
      this.iface.curMoviStock.refreshBuffer();
      this.iface.curMoviStock.setValueBuffer("cantidad", cantidad);
      this.iface.curMoviStock.setValueBuffer("idlineacm", idLinea);
      this.iface.curMoviStock.setValueBuffer("estado", "HECHO");
      this.iface.curMoviStock.setValueBuffer("fechareal", aDatosStockLinea.fechaReal);
      this.iface.curMoviStock.setValueBuffer("horareal", aDatosStockLinea.horaReal);
      this.iface.curMoviStock.setValueBuffer("idstock", idStock);
      if (!this.iface.datosArticuloMS(aDatosArt, aDatosStockLinea)) {
        return false;
      }
      if (aDatosStockLinea.codLote) {
        this.iface.curMoviStock.setValueBuffer("codlote", aDatosStockLinea.codLote);
      } else {
        this.iface.curMoviStock.setNull("codlote");
      }
      if (!this.iface.curMoviStock.commitBuffer()) {
        return false;
      }
      break;
    }

  }
  return true;
}

function articomp_crearStock(codAlmacen: String, aDatosArt: Array): Number {
  var util: FLUtil = new FLUtil;
  var curStock: FLSqlCursor = new FLSqlCursor("stocks");
  with(curStock)
  {
    setModeAccess(Insert);
    refreshBuffer();
    setValueBuffer("codalmacen", codAlmacen);
    setValueBuffer("referencia", aDatosArt["referencia"]);
    setValueBuffer("nombre", util.sqlSelect("almacenes", "nombre", "codalmacen = '" + codAlmacen + "'"));
    setValueBuffer("cantidad", 0);
    if (!commitBuffer())
      return false;
  }
  return curStock.valueBuffer("idstock");
}

function articomp_afterCommit_movistock(curMS: FLSqlCursor): Boolean {
  if (!this.iface.actualizarStocksMoviStock(curMS))
  {
    return false;
  }
  return true;
}

function articomp_actualizarStocksMoviStock(curMS: FLSqlCursor): Boolean {
  if (this.iface.calculoStockBloqueado_)
  {
    return true;
  }

  var idStock: String =  curMS.valueBuffer("idstock");
  var estado: String = curMS.valueBuffer("estado");
  var cantidad: Number = curMS.valueBuffer("cantidad");

  switch (curMS.modeAccess())
  {
    case curMS.Insert:
    case curMS.Del: {
      if (estado == "PTE") {
        if (cantidad > 0) {
          if (!this.iface.actualizarStockPteRecibir(idStock)) {
            return false;
          }
        }
        if (cantidad < 0) {
          if (!this.iface.actualizarStockPteServir(idStock)) {
            return false;
          }
        }
      } else {
        if (!this.iface.actualizarStock(idStock)) {
          return false;
        }
      }
      break;
    }
    case curMS.Edit: {
      var estadoPrevio: String = curMS.valueBufferCopy("estado");
      var cantidadPrevia: Number = curMS.valueBufferCopy("cantidad");
      if (estado != estadoPrevio) {
        if (estadoPrevio == "PTE") {
          if (cantidad > 0 || cantidadPrevia > 0) {
            if (!this.iface.actualizarStockPteRecibir(idStock)) {
              return false;
            }
          }
          if (cantidad < 0 || cantidadPrevia < 0) {
            if (!this.iface.actualizarStockPteServir(idStock)) {
              return false;
            }
          }
        } else {
          if (!this.iface.actualizarStock(idStock)) {
            return false;
          }
        }
      }
      if (estado == "PTE") {
        if (cantidad > 0 || cantidadPrevia > 0) {
          if (!this.iface.actualizarStockPteRecibir(idStock)) {
            return false;
          }
        }
        if (cantidad < 0 || cantidadPrevia < 0) {
          if (!this.iface.actualizarStockPteServir(idStock)) {
            return false;
          }
        }
      } else {
        if (!this.iface.actualizarStock(idStock)) {
          return false;
        }
      }
      break;
    }
  }
  return true;
}

function articomp_actualizarStockPteRecibir(idStock: Number): Boolean {
  var util: FLUtil = new FLUtil;

  var curStock: FLSqlCursor = new FLSqlCursor("stocks");
  curStock.select("idstock = " + idStock);
  if (!curStock.first())
  {
    return false;
  }
  curStock.setModeAccess(curStock.Edit);
  curStock.refreshBuffer();
  curStock.setValueBuffer("pterecibir", formRecordregstocks.iface.pub_commonCalculateField("pterecibir", curStock));
  if (!curStock.commitBuffer())
  {
    return false;
  }
  return true;
}

function articomp_actualizarStockPteServir(idStock: Number): Boolean {
  var util: FLUtil = new FLUtil;

  var curStock: FLSqlCursor = new FLSqlCursor("stocks");
  curStock.select("idstock = " + idStock);
  if (!curStock.first())
  {
    return false;
  }
  curStock.setModeAccess(curStock.Edit);
  curStock.refreshBuffer();
  curStock.setValueBuffer("reservada", formRecordregstocks.iface.pub_commonCalculateField("reservada", curStock));
  curStock.setValueBuffer("disponible", formRecordregstocks.iface.pub_commonCalculateField("disponible", curStock));
  if (!curStock.commitBuffer())
  {
    return false;
  }
  return true;
}

function articomp_actualizarStock(idStock)
{
  var curStock: FLSqlCursor = new FLSqlCursor("stocks");
  curStock.select("idstock = " + idStock);
  if (!curStock.first()) {
    return false;
  }
  curStock.setModeAccess(curStock.Edit);
  curStock.refreshBuffer();
  curStock.setValueBuffer("cantidad", formRecordregstocks.iface.pub_commonCalculateField("cantidad", curStock));
  curStock.setValueBuffer("disponible", formRecordregstocks.iface.pub_commonCalculateField("disponible", curStock));
  if (!curStock.commitBuffer()) {
    return false;
  }
  return true;
}

function articomp_controlStockPedidosCli(curLP)
{
  var util: FLUtil = new FLUtil;
  if (util.sqlSelect("articulos", "nostock", "referencia = '" + curLP.valueBuffer("referencia") + "'")) {
    return true;
  }
  switch (curLP.modeAccess()) {
    case curLP.Insert: {
      if (!this.iface.generarEstructura(curLP)) {
        return false;
      }
      break;
    }
    case curLP.Edit: {
      if (this.iface.datosStockLineaCambian(curLP)) {
        if (!this.iface.borrarEstructura(curLP)) {
          return false;
        }
        if (!this.iface.generarEstructura(curLP)) {
          return false;
        }
      }
      break;
    }
    //    case curLP.Del: {
    //      if (!this.iface.borrarEstructura(curLP)) {
    //        return false;
    //      }
    //      break;
    //    }
  }

  return true;
}

function articomp_controlStockBCPedidosCli(curLP)
{
  var _i = this.iface;
  switch (curLP.modeAccess()) {
    case curLP.Del: {
      if (!_i.borrarEstructura(curLP)) {
        return false;
      }
      break;
    }
  }
  return true;
}

/** \D Indica si los datos de un cursor de línea de facturación han variado con respecto a su stock
@param  curLinea: Cursor con la línea
@return true indica que los datos varían.
\end */
function articomp_datosStockLineaCambian(curLinea)
{
  var cantidad: String = curLinea.valueBuffer("cantidad");
  var cantidadAnterior: String = curLinea.valueBufferCopy("cantidad");
  var referencia: String = curLinea.valueBuffer("referencia");
  var referenciaAnterior: String = curLinea.valueBufferCopy("referencia");
  var cambian = (cantidad != cantidadAnterior || referencia != referenciaAnterior);
  switch (curLinea.table()) {
    case "lineaspedidoscli":
    case "lineaspedidosprov": {
      var cerrada = curLinea.valueBuffer("cerrada");
      var cerradaAnterior = curLinea.valueBufferCopy("cerrada");
      cambian = cambian || (cerrada != cerradaAnterior);
      var enAlbaran = curLinea.valueBuffer("totalenalbaran");
      var enAlbaranAnterior = curLinea.valueBufferCopy("totalenalbaran");
      cambian = cambian || (enAlbaran != enAlbaranAnterior);
      break;
    }
    default: {
    }
  }
  return cambian;
}

function articomp_controlStockComandasCli(curLC: FLSqlCursor): Boolean {
  switch (curLC.modeAccess())
  {
    case curLC.Insert: {
      if (!this.iface.generarEstructura(curLC)) {
        return false;
      }
      break;
    }
    case curLC.Edit: {
      if (this.iface.datosStockLineaCambian(curLC)) {
        if (!this.iface.borrarEstructura(curLC)) {
          return false;
        }
        if (!this.iface.generarEstructura(curLC)) {
          return false;
        }
      }
      break;
    }
    case curLC.Del: {
      if (!this.iface.borrarEstructura(curLC)) {
        return false;
      }
      break;
    }
  }
  return true;
}

function articomp_controlStockValesTPV(curLV: FLSqlCursor): Boolean {
  switch (curLV.modeAccess())
  {
    case curLV.Insert: {
      if (!this.iface.generarEstructura(curLV)) {
        return false;
      }
      break;
    }
    case curLV.Edit: {
      if (this.iface.datosStockLineaCambian(curLV)) {
        if (!this.iface.borrarEstructura(curLV)) {
          return false;
        }
        if (!this.iface.generarEstructura(curLV)) {
          return false;
        }
      }
      break;
    }
    case curLV.Del: {
      if (!this.iface.borrarEstructura(curLV)) {
        return false;
      }
      break;
    }
  }
  return true;
}

function articomp_controlStockPedidosProv(curLP: FLSqlCursor): Boolean {
  var util: FLUtil = new FLUtil;
  if (util.sqlSelect("articulos", "nostock", "referencia = '" + curLP.valueBuffer("referencia") + "'"))
  {
    return true;
  }
  switch (curLP.modeAccess())
  {
    case curLP.Insert: {
      if (!this.iface.generarEstructura(curLP)) {
        return false;
      }
      break;
    }
    case curLP.Edit: {
      if (this.iface.datosStockLineaCambian(curLP)) {
        if (!this.iface.borrarEstructura(curLP)) {
          return false;
        }
        if (!this.iface.generarEstructura(curLP)) {
          return false;
        }
      }
      break;
    }
    //    case curLP.Del: {
    //      if (!this.iface.borrarEstructura(curLP)) {
    //        return false;
    //      }
    //      break;
    //    }
  }
  return true;
}
function articomp_controlStockBCPedidosProv(curLP)
{
  var _i = this.iface;
  switch (curLP.modeAccess()) {
    case curLP.Del: {
      if (!_i.borrarEstructura(curLP)) {
        return false;
      }
      break;
    }
  }

  return true;
}


function articomp_controlStockAlbaranesCli(curLA)
{
  if (AQUtil.sqlSelect("articulos", "nostock", "referencia = '" + curLA.valueBuffer("referencia") + "'")) {
    return true;
  }
  var _i = this.iface;
  var idLineaPedido: String = curLA.valueBuffer("idlineapedido");
  var idLineaAlbaran: String = curLA.valueBuffer("idlinea");

  //  if (idLineaPedido && idLineaPedido != "" && idLineaPedido != 0) {
  //    switch (curLA.modeAccess()) {
  //      case curLA.Insert: {
  //        if (!this.iface.albaranarLineaPedCli(curLA)) {
  //          return false;
  //        }
  //        break;
  //      }
  //      case curLA.Edit: {
  //        if (this.iface.datosStockLineaCambian(curLA)) {
  //          if (!this.iface.desalbaranarLineaPedCli(curLA)) {
  //            return false;
  //          }
  //          if (!this.iface.albaranarLineaPedCli(curLA)) {
  //            return false;
  //          }
  //        }
  //        break;
  //      }
  //    }
  //  } else {
  switch (curLA.modeAccess()) {
    case curLA.Insert: {
      if (!this.iface.generarEstructura(curLA)) {
        return false;
      }
      break;
    }
    case curLA.Edit: {
      if (this.iface.datosStockLineaCambian(curLA)) {
        if (!this.iface.borrarEstructura(curLA)) {
          return false;
        }
        if (!this.iface.generarEstructura(curLA)) {
          return false;
        }
      }
      break;
    }
  }
  //  }
  return true;
}

function articomp_controlStockBCAlbaranesCli(curLA)
{
  if (AQUtil.sqlSelect("articulos", "nostock", "referencia = '" + curLA.valueBuffer("referencia") + "'")) {
    return true;
  }
  var _i = this.iface;
  var idLineaPedido = curLA.valueBuffer("idlineapedido");
  var idLineaAlbaran = curLA.valueBuffer("idlinea");

  //  if (idLineaPedido && idLineaPedido != "" && idLineaPedido != 0) {
  //    switch (curLA.modeAccess()) {
  //      case curLA.Del: {
  //        if (!this.iface.desalbaranarLineaPedCli(curLA)) {
  //          return false;
  //        }
  //        break;
  //      }
  //    }
  //  } else {
  switch (curLA.modeAccess()) {
    case curLA.Del: {
      if (!this.iface.borrarEstructura(curLA)) {
        return false;
      }
      break;
    }
  }
  //  }
  return true;
}

function articomp_controlStockAlbaranesProv(curLA)
{
  if (AQUtil.sqlSelect("articulos", "nostock", "referencia = '" + curLA.valueBuffer("referencia") + "'")) {
    return true;
  }
  var _i = this.iface;
  var idLineaPedido = curLA.valueBuffer("idlineapedido");
  var idLineaAlbaran = curLA.valueBuffer("idlinea");

  //  if (idLineaPedido && idLineaPedido != "" && idLineaPedido != 0) {
  //    switch (curLA.modeAccess()) {
  //      case curLA.Insert: {
  //        if (!this.iface.albaranarLineaPedProv(curLA)) {
  //          return false;
  //        }
  //        break;
  //      }
  //      case curLA.Edit: {
  //        if (this.iface.datosStockLineaCambian(curLA)) {
  //          if (!this.iface.desalbaranarLineaPedProv(curLA)) {
  //            return false;
  //          }
  //          if (!this.iface.albaranarLineaPedProv(curLA)) {
  //            return false;
  //          }
  //        }
  //        break;
  //      }
  //    }
  //  } else {
  switch (curLA.modeAccess()) {
    case curLA.Insert: {
      if (!this.iface.generarEstructura(curLA)) {
        return false;
      }
      break;
    }
    case curLA.Edit: {
      if (this.iface.datosStockLineaCambian(curLA)) {
        if (!this.iface.borrarEstructura(curLA)) {
          return false;
        }
        if (!this.iface.generarEstructura(curLA)) {
          return false;
        }
      }
      break;
    }
    //      case curLA.Del: {
    //        if (!this.iface.borrarEstructura(curLA)) {
    //          return false;
    //        }
    //        break;
    //      }
  }
  //  }
  return true;
}

function articomp_controlStockBCAlbaranesProv(curLA)
{
  if (AQUtil.sqlSelect("articulos", "nostock", "referencia = '" + curLA.valueBuffer("referencia") + "'")) {
    return true;
  }
  var _i = this.iface;
  var idLineaPedido = curLA.valueBuffer("idlineapedido");
  var idLineaAlbaran = curLA.valueBuffer("idlinea");

  //  if (idLineaPedido && idLineaPedido != "" && idLineaPedido != 0) {
  //    switch (curLA.modeAccess()) {
  //      case curLA.Del: {
  //        if (!this.iface.desalbaranarLineaPedProv(curLA)) {
  //          return false;
  //        }
  //        break;
  //      }
  //    }
  //  } else {
  switch (curLA.modeAccess()) {
    case curLA.Del: {
      if (!this.iface.borrarEstructura(curLA)) {
        return false;
      }
      break;
    }
  }
  //  }
  return true;
}

function articomp_controlStockFacturasCli(curLF)
{
  var _i = this.iface;
  if (AQUtil.sqlSelect("articulos", "nostock", "referencia = '" + curLF.valueBuffer("referencia") + "'")) {
    return true;
  }
  if (AQUtil.sqlSelect("articulos", "nostock", "referencia = '" + curLF.valueBuffer("referencia") + "'")) {
    return true;
  }
  if (AQUtil.sqlSelect("facturascli", "automatica", "idfactura = " + curLF.valueBuffer("idfactura"))) {
    return true;
  }
  switch (curLF.modeAccess()) {
    case curLF.Insert: {
      if (!_i.generarEstructura(curLF)) {
        return false;
      }
      break;
    }
    case curLF.Edit: {
      if (_i.datosStockLineaCambian(curLF)) {
        if (!_i.borrarEstructura(curLF)) {
          return false;
        }
        if (!_i.generarEstructura(curLF)) {
          return false;
        }
      }
      break;
    }
    //    case curLF.Del: {
    //      if (!_i.borrarEstructura(curLF)) {
    //        return false;
    //      }
    //      break;
    //    }
  }
  return true;
}

function articomp_controlStockBCFacturasCli(curLF)
{
  var _i = this.iface;
  if (AQUtil.sqlSelect("articulos", "nostock", "referencia = '" + curLF.valueBuffer("referencia") + "'")) {
    return true;
  }
  if (AQUtil.sqlSelect("articulos", "nostock", "referencia = '" + curLF.valueBuffer("referencia") + "'")) {
    return true;
  }
  if (AQUtil.sqlSelect("facturascli", "automatica", "idfactura = " + curLF.valueBuffer("idfactura"))) {
    return true;
  }
  switch (curLF.modeAccess()) {
    case curLF.Del: {
      if (!_i.borrarEstructura(curLF)) {
        return false;
      }
      break;
    }
  }
  return true;
}

function articomp_controlStockFacturasProv(curLF)
{
  var _i = this.iface;
  if (AQUtil.sqlSelect("articulos", "nostock", "referencia = '" + curLF.valueBuffer("referencia") + "'")) {
    return true;
  }
  if (AQUtil.sqlSelect("facturasprov", "automatica", "idfactura = " + curLF.valueBuffer("idfactura"))) {
    return true;
  }
  switch (curLF.modeAccess()) {
    case curLF.Insert: {
      if (!_i.generarEstructura(curLF)) {
        return false;
      }
      break;
    }
    case curLF.Edit: {
      if (_i.datosStockLineaCambian(curLF)) {
        if (!_i.borrarEstructura(curLF)) {
          return false;
        }
        if (!_i.generarEstructura(curLF)) {
          return false;
        }
      }
      break;
    }
    //    case curLF.Del: {
    //      if (!_i.borrarEstructura(curLF)) {
    //        return false;
    //      }
    //      break;
    //    }
  }
  return true;
}

function articomp_controlStockBCFacturasProv(curLF)
{
  var _i = this.iface;
  if (AQUtil.sqlSelect("articulos", "nostock", "referencia = '" + curLF.valueBuffer("referencia") + "'")) {
    return true;
  }
  if (AQUtil.sqlSelect("facturasprov", "automatica", "idfactura = " + curLF.valueBuffer("idfactura"))) {
    return true;
  }
  switch (curLF.modeAccess()) {
    case curLF.Del: {
      if (!_i.borrarEstructura(curLF)) {
        return false;
      }
      break;
    }
  }
  return true;
}

function articomp_controlStockLineasTrans(curLTS: FLSqlCursor): Boolean {
  var util: FLUtil = new FLUtil;

  if (util.sqlSelect("articulos", "nostock", "referencia = '" + curLTS.valueBuffer("referencia") + "'"))
  {
    return true;
  }
  switch (curLTS.modeAccess())
  {
    case curLTS.Insert: {
      if (!this.iface.generarEstructura(curLTS)) {
        return false;
      }
      break;
    }
    case curLTS.Edit: {
      if (this.iface.datosStockLineaCambian(curLTS)) {
        if (!this.iface.borrarEstructura(curLTS)) {
          return false;
        }
        if (!this.iface.generarEstructura(curLTS)) {
          return false;
        }
      }
      break;
    }
    case curLTS.Del: {
      if (!this.iface.borrarEstructura(curLTS)) {
        return false;
      }
      break;
    }
  }

  return true;
}

/** \C Marca como PTE los movimientos asociados a un línea de albaran, y los desasocia de la línea. Si hay otros movimientos en estado PTE asociados a la línea de pedido, los unifica
@param  curLA: Cursor posicionado en la línea de albarán
\end */
function articomp_desalbaranarLineaPedCli(curLA)
{
  var _i = this.iface;
  var util: FLUtil = new FLUtil;

  var idLineaPedido = curLA.valueBuffer("idlineapedido");
  var idLineaAlbaran = curLA.valueBuffer("idlinea");

  if (!_i.curMoviStock) {
    _i.curMoviStock = new FLSqlCursor("movistock");
  }
  var curMS = _i.curMoviStock;
  curMS.select("idlineaac = " + idLineaAlbaran);
  var idMovimientoPte;
  while (curMS.next()) {
    curMS.setModeAccess(curMS.Edit);
    curMS.refreshBuffer();
    curMS.setValueBuffer("estado", "PTE");
    curMS.setNull("fechareal");
    curMS.setNull("horareal");
    curMS.setNull("idlineaac");
    if (!_i.datosDesalbaranarLPC(curLA)) {
      return false;
    }
    if (!curMS.commitBuffer()) {
      return false;
    }
  }
  if (!_i.unificarMovPtePC(idLineaPedido)) {
    return false;
  }
  var curLP = new FLSqlCursor("lineaspedidoscli");
  curLP.select("idlinea = " + idLineaPedido);
  if (!curLP.first()) {
    return false;
  }
  if (!curLP.valueBuffer("cerrada")) {
    if (!_i.consistenciaLinea(curLP)) {
      return false;
    }
  }
  return true;
}

function articomp_datosDesalbaranarLPC(curLA)
{
  return true;
}

/** \C Marca como PTE los movimientos asociados a un línea de albaran, y los desasocia de la línea. Si hay otros movimientos en estado PTE asociados a la línea de pedido, los unifica
@param  idLineaPedido: Identificador de la línea de pedido
@param  idLineaAlbaran: Identificador de la línea de albarán
\end */
function articomp_desalbaranarLineaPedProv(curLA)
{
  var _i = this.iface;
  var util: FLUtil = new FLUtil;

  var idLineaPedido = curLA.valueBuffer("idlineapedido");
  var idLineaAlbaran = curLA.valueBuffer("idlinea");

  if (!_i.curMoviStock) {
    _i.curMoviStock = new FLSqlCursor("movistock");
  }
  _i.curMoviStock.select("idlineaap = " + idLineaAlbaran);
  var idMovimientoPte;
  while (_i.curMoviStock.next()) {
    _i.curMoviStock.setModeAccess(_i.curMoviStock.Edit);
    _i.curMoviStock.refreshBuffer();
    _i.curMoviStock.setValueBuffer("estado", "PTE");
    _i.curMoviStock.setNull("fechareal");
    _i.curMoviStock.setNull("horareal");
    _i.curMoviStock.setNull("idlineaap");
    if (!_i.datosDesalbaranarLineaPedProv(curLA)) {
      return false;
    }
    if (!_i.curMoviStock.commitBuffer()) {
      return false;
    }
  }
  if (!_i.unificarMovPtePP(idLineaPedido)) {
    return false;
  }
  var curLP = new FLSqlCursor("lineaspedidosprov");
  curLP.select("idlinea = " + idLineaPedido);
  if (!curLP.first()) {
    return false;
  }
  if (!curLP.valueBuffer("cerrada")) {
    if (!_i.consistenciaLinea(curLP)) {
      return false;
    }
  }
  return true;
}

function articomp_datosDesalbaranarLineaPedProv(curLA)
{
  return true;
}

/** \C Unifica en un único movimiento todos los movimientos pendientes asociados a la misma línea de pedido y lote (para cada referencia -esto se usa cuando el artículo es compuesto-)
@param  idLineaPedido: Identificador de la línea de pedido
\end */
function articomp_unificarMovPtePC(idLineaPedido: String): Boolean {
  var util: FLUtil = new FLUtil;
  var qryReferencia: FLSqlQuery = new FLSqlQuery;
  with(qryReferencia)
  {
    setTablesList("movistock");
    setSelect("idstock, codlote, SUM(cantidad)");
    setFrom("movistock");
    setWhere("idlineapc = " + idLineaPedido + " AND estado = 'PTE' GROUP BY idstock, codlote");
    setForwardOnly(true);
  }
  if (!qryReferencia.exec())
  {
    return false;
  }
  var cantidadPte: Number;
  var idMovimiento: String;
  var codLote: String;
  var whereMov: String;
  while (qryReferencia.next())
  {
    cantidadPte = parseFloat(qryReferencia.value("SUM(cantidad)"));
    if (!cantidadPte || isNaN(cantidadPte)) {
      return true;
    }
    whereMov = "idlineapc = " + idLineaPedido + " AND estado = 'PTE' AND idstock = " + qryReferencia.value("idstock");
    codLote = qryReferencia.value("codlote");
    if (codLote && codLote != "") {
      whereMov += " AND codlote = '" + qryReferencia.value("codlote") + "'";
    }
    idMovimiento = util.sqlSelect("movistock", "idmovimiento", whereMov);
    if (!idMovimiento) {
      return true;
    }
    if (!util.sqlDelete("movistock", whereMov + " AND idmovimiento <> " + idMovimiento)) {
      //    "idlineapc = " + idLineaPedido + " AND estado = 'PTE' AND idmovimiento <> " + idMovimiento + " AND idstock = " + qryReferencia.value("idstock") + " AND codlote = '" + qryReferencia.value("codlote") + "'")) {
      return false;
    }
    if (!util.sqlUpdate("movistock", "cantidad", cantidadPte, "idmovimiento = " + idMovimiento)) {
      return false;
    }
  }
  return true;
}

/** \C Unifica en un único movimiento todos los movimientos pendientes asociados a una línea de pedido (para cada referencia -esto se usa cuando el artículo es compuesto-)
@param  idLineaPedido: Identificador de la línea de pedido
\end */
function articomp_unificarMovPtePP(idLineaPedido: String): Boolean {
  var util: FLUtil = new FLUtil;
  var qryReferencia: FLSqlQuery = new FLSqlQuery;
  with(qryReferencia)
  {
    setTablesList("movistock");
    setSelect("idstock, codlote, SUM(cantidad)");
    setFrom("movistock");
    setWhere("idlineapp = " + idLineaPedido + " AND estado = 'PTE' GROUP BY idstock, codlote");
    setForwardOnly(true);
  }
  if (!qryReferencia.exec())
  {
    return false;
  }
  var cantidadPte: Number;
  var idMovimiento: String;
  var codLote: String;
  var whereMov: String;
  while (qryReferencia.next())
  {
    cantidadPte = parseFloat(qryReferencia.value("SUM(cantidad)"));
    if (!cantidadPte || isNaN(cantidadPte)) {
      return true;
    }
    whereMov = "idlineapp = " + idLineaPedido + " AND estado = 'PTE' AND idstock = " + qryReferencia.value("idstock");
    codLote = qryReferencia.value("codlote");
    if (codLote && codLote != "") {
      whereMov += " AND codlote = '" + qryReferencia.value("codlote") + "'";
    }
    idMovimiento = util.sqlSelect("movistock", "idmovimiento", whereMov);
    if (!idMovimiento) {
      return true;
    }
    if (!util.sqlDelete("movistock", whereMov + " AND idmovimiento <> " + idMovimiento)) {
      //    "idlineapp = " + idLineaPedido + " AND estado = 'PTE' AND idmovimiento <> " + idMovimiento + " AND idstock = " + qryReferencia.value("idstock"))) {
      return false;
    }
    if (!util.sqlUpdate("movistock", "cantidad", cantidadPte, "idmovimiento = " + idMovimiento)) {
      return false;
    }
  }
  return true;
}

/** \C Divide los movimientos pendientes de una línea de pedido y asocia la parte correspondiente a una línea de albarán
@param  idLineaPedido: Identificador de la línea de pedido
@param  curLA: Cursor posicionado en la línea de albarán
\end */
//function articomp_albaranarParcialLPC(idLineaPedido:String, curLA:FLSqlCursor):Boolean
/// Eliminamos la antigua función albaranarLineaPedCli y usamos siempre la de albaranar parcial, que pasa a llamarse simplemente albaranarLineaPedCli
function articomp_albaranarLineaPedCli(curLA)
{
  var _i = this.iface;
  var util: FLUtil = new FLUtil;

  var idLineaPedido = curLA.valueBuffer("idlineapedido");
  if (!this.iface.curMoviStock)
    this.iface.curMoviStock = new FLSqlCursor("movistock");

  var cantidadPedido: Number = parseFloat(util.sqlSelect("lineaspedidoscli", "cantidad", "idlinea = "  + idLineaPedido));

  var fechaAlbaran, horaAlbaran, codAlmacen;
  var curAlbaran: FLSqlCursor = curLA.cursorRelation();
  if (curAlbaran) {
    fechaAlbaran = curAlbaran.valueBuffer("fecha");
    horaAlbaran = curAlbaran.valueBuffer("hora");
    codAlmacen = curAlbaran.valueBuffer("codalmacen");
  } else {
    fechaAlbaran = util.sqlSelect("albaranescli", "fecha", "idalbaran = " + curLA.valueBuffer("idalbaran"));
    horaAlbaran = util.sqlSelect("albaranescli", "hora", "idalbaran = " + curLA.valueBuffer("idalbaran"));
    codAlmacen = util.sqlSelect("albaranescli", "codalmacen", "idalbaran = " + curLA.valueBuffer("idalbaran"));
  }

  var referencia = curLA.valueBuffer("referencia");
  var idStock;
  idStock = util.sqlSelect("stocks", "idstock", "referencia = '" + referencia + "' AND codalmacen = '" + codAlmacen + "'");
  if (!idStock) {
    var oArticulo = new Object;
    oArticulo["referencia"] = referencia;
    idStock = _i.crearStock(codAlmacen, oArticulo);
    if (!idStock) {
      return false;
    }
  }

  if (!fechaAlbaran) {
    return false;
  }
  horaAlbaran = horaAlbaran.toString();
  var hora = horaAlbaran.right(8);

  var cantidadAlb = curLA.valueBuffer("cantidad") ;
  if (cantidadAlb == 0) {
    return false;
  }
  cantidadAlb = util.roundFieldValue(cantidadAlb, "movistock", "cantidad");
  var referencia = curLA.valueBuffer("referencia");

  var curMSOrigen: FLSqlCursor = new FLSqlCursor("movistock");
  if (util.sqlSelect("articulos", "stockcomp", "referencia = '" + referencia + "'")) {
    var qry: FLSqlQuery = new FLSqlQuery();
    qry.setTablesList("articuloscomp");
    qry.setSelect("refcomponente, cantidad");
    qry.setFrom("articuloscomp");
    qry.setWhere("refcompuesto = '" + referencia + "' AND (idtipoopcionart IS NULL OR idtipoopcionart = 0)");

    if (!qry.exec())
      return false;

    var refComp: String = "";
    var cantComp = 0;

    while (qry.next()) {
      cantComp = cantidadAlb * parseFloat(qry.value("cantidad"));
      refComp = qry.value("refcomponente")

                curMSOrigen.select("idlineapc = " + idLineaPedido + " AND referencia = '" + refComp + "' AND estado = 'PTE'");
      if (curMSOrigen.size() > 1) {
        if (!_i.unificarMovPtePC(idLineaPedido)) {
          return false;
        }
        curMSOrigen.select("idlineapc = " + idLineaPedido + " AND estado = 'PTE'");
        if (curMSOrigen.size() > 1) {
          return false;
        }
      }
      if (!curMSOrigen.first()) {
        debug(4);
        return false;
      }

      var cantidadPte = curMSOrigen.valueBuffer("cantidad");
      cantidadPte = isNaN(cantidadPte) ? 0 : cantidadPte;
      cantidadPte *= -1;

      cantidadPte -= cantComp;
      if (cantidadPte < 0) {
        MessageBox.warning(util.translate("scripts", "No puede establecer una cantidad albaranada superior a la cantidad de la línea de pedido asociada.\nSi realmente va a servir más cantidad que la pedida indíquelo en una nueva línea de albarán"), MessageBox.Ok,  MessageBox.NoButton);
        return false;
      }
      cantidadPte = util.roundFieldValue(cantidadPte, "movistock", "cantidad");
      cantComp = util.roundFieldValue(cantComp, "movistock", "cantidad");

      this.iface.curMoviStock.setModeAccess(this.iface.curMoviStock.Insert);
      this.iface.curMoviStock.refreshBuffer();

      cantComp *= -1;
      this.iface.curMoviStock.setValueBuffer("cantidad", cantComp);
      this.iface.curMoviStock.setValueBuffer("fechareal", fechaAlbaran);
      this.iface.curMoviStock.setValueBuffer("horareal", hora);
      this.iface.curMoviStock.setValueBuffer("idstock", idStock);
      this.iface.curMoviStock.setValueBuffer("idlineaac", curLA.valueBuffer("idlinea"));
      this.iface.curMoviStock.setValueBuffer("idlineapc", curMSOrigen.valueBuffer("idlineapc"));

      if (!this.iface.albaranaDatosMoviStock(curMSOrigen, curLA)) {
        return false;
      }

      if (!_i.curMoviStock.commitBuffer()) {
        return false;
      }

      if (parseFloat(cantidadPte) == 0) {
        curMSOrigen.setModeAccess(curMSOrigen.Del);
        curMSOrigen.refreshBuffer();
      } else {
        cantidadPte *= -1;
        curMSOrigen.setModeAccess(curMSOrigen.Edit);
        curMSOrigen.refreshBuffer();
        curMSOrigen.setValueBuffer("cantidad", cantidadPte);
      }

      if (!curMSOrigen.commitBuffer()) {
        return false;
      }
    }
  } else {
    var curMSOrigen: FLSqlCursor = new FLSqlCursor("movistock");
    curMSOrigen.select("idlineapc = " + idLineaPedido + " AND estado = 'PTE'");
    if (curMSOrigen.size() > 1) {
      if (!_i.unificarMovPtePC(idLineaPedido)) {
        return false;
      }
      curMSOrigen.select("idlineapc = " + idLineaPedido + " AND estado = 'PTE'");
      if (curMSOrigen.size() > 1) {
        return false;
      }
    }
    if (!curMSOrigen.first()) {
      debug(4);
      return false;
    }

    var cantidadPte = curMSOrigen.valueBuffer("cantidad");
    cantidadPte = isNaN(cantidadPte) ? 0 : cantidadPte;
    cantidadPte *= -1;

    cantidadPte -= cantidadAlb;
    if (cantidadPte < 0) {
      MessageBox.warning(util.translate("scripts", "No puede establecer una cantidad albaranada superior a la cantidad de la línea de pedido asociada.\nSi realmente va a servir más cantidad que la pedida indíquelo en una nueva línea de albarán"), MessageBox.Ok,  MessageBox.NoButton);
      return false;
    }
    cantidadPte = util.roundFieldValue(cantidadPte, "movistock", "cantidad");

    this.iface.curMoviStock.setModeAccess(this.iface.curMoviStock.Insert);
    this.iface.curMoviStock.refreshBuffer();

    cantidadAlb *= -1;
    this.iface.curMoviStock.setValueBuffer("cantidad", cantidadAlb);
    this.iface.curMoviStock.setValueBuffer("fechareal", fechaAlbaran);
    this.iface.curMoviStock.setValueBuffer("horareal", hora);
    this.iface.curMoviStock.setValueBuffer("idstock", idStock);
    this.iface.curMoviStock.setValueBuffer("idlineaac", curLA.valueBuffer("idlinea"));
    this.iface.curMoviStock.setValueBuffer("idlineapc", curMSOrigen.valueBuffer("idlineapc"));

    if (!this.iface.albaranaDatosMoviStock(curMSOrigen, curLA)) {
      return false;
    }

    if (!_i.curMoviStock.commitBuffer()) {
      return false;
    }

    if (parseFloat(cantidadPte) == 0) {
      curMSOrigen.setModeAccess(curMSOrigen.Del);
      curMSOrigen.refreshBuffer();
    } else {
      cantidadPte *= -1;
      curMSOrigen.setModeAccess(curMSOrigen.Edit);
      curMSOrigen.refreshBuffer();
      curMSOrigen.setValueBuffer("cantidad", cantidadPte);
    }

    if (!curMSOrigen.commitBuffer()) {
      return false;
    }
  }

  if (!_i.consistenciaLinea(curLA)) {
    return false;
  }
  return true;
}


function articomp_consistenciaLinea(curLinea)
{
  if (curLinea.valueBuffer("referencia") == "" || curLinea.isNull("referencia")) {
    return true;
  }

  var util = new FLUtil;

  if (util.sqlSelect("articulos", "stockcomp", "referencia = '" + curLinea.valueBuffer("referencia") + "'"))
    return true;

  var idLinea = curLinea.valueBuffer("idlinea");
  var tabla = curLinea.table();

  var ok = true;
  var mensaje = "";

  switch (tabla) {
    case "lineaspedidoscli": {
      var totalCan;
      if (curLinea.valueBuffer("cerrada")) {
        //         totalCan = parseFloat(util.sqlSelect("movistock", "SUM(cantidad)", "idlineapc = " + curLinea.valueBuffer("idlinea") + " AND estado = 'HECHO'"));
        //         totalCan = isNaN(totalCan) ? 0 : totalCan;
        //         totalCan *= -1;
        //         if (totalCan != parseFloat(curLinea.valueBuffer("totalenalbaran"))) {
        //           if (totalCan == 0 && util.sqlSelect("articulos", "nostock", "referencia = '" + curLinea.valueBuffer("referencia") + "'")) {
        //             return true;
        //           }
        //           mensaje = util.translate("scritps", "Error de consistencia en la línea de pedido cerrada. La cantidad de movimientos en estado HECHO (%1) es distinta de la cantidad del campo Total en albarán (%2)").arg(totalCan).arg(curLinea.valueBuffer("totalenalbaran"));
        //           ok = false;
        //           break;
        //         }
        if (AQUtil.sqlSelect("movistock", "idmovimiento", "idlineapc = " + curLinea.valueBuffer("idlinea") + " AND estado = 'PTE'")) {
          mensaje = sys.translate("Error de consistencia en la línea de pedido cerrada. La línea tiene movimientos en estado PTE");
          ok = false;
          break;
        }
      } else {
        totalCan = parseFloat(util.sqlSelect("movistock", "SUM(cantidad)", "idlineapc = " + curLinea.valueBuffer("idlinea")));
        totalCan = isNaN(totalCan) ? 0 : totalCan;
        totalCan *= -1;
        var canPendiente = parseFloat(curLinea.valueBuffer("cantidad")) - parseFloat(curLinea.valueBuffer("totalenalbaran"));
        canPendiente = isNaN(canPendiente) ? 0 : canPendiente;
        if (totalCan != canPendiente) {
          if (totalCan == 0 && util.sqlSelect("articulos", "nostock", "referencia = '" + curLinea.valueBuffer("referencia") + "'")) {
            return true;
          }
          mensaje = util.translate("scritps", "Error de consistencia en la línea de pedido. La cantidad en movimientos (%1) es distinta de la cantidad de la línea (%2)").arg(totalCan).arg(canPendiente);
          ok = false;
          break;
        }
      }
      break;
    }
    case "lineaspedidosprov": {
      var totalCan;
      if (curLinea.valueBuffer("cerrada")) {
        //         totalCan = parseFloat(util.sqlSelect("movistock", "SUM(cantidad)", "idlineapp = " + curLinea.valueBuffer("idlinea") + " AND estado = 'HECHO'"));
        //         totalCan = isNaN(totalCan) ? 0 : totalCan;
        //         if (totalCan != parseFloat(curLinea.valueBuffer("totalenalbaran"))) {
        //           if (totalCan == 0 && util.sqlSelect("articulos", "nostock", "referencia = '" + curLinea.valueBuffer("referencia") + "'")) {
        //             return true;
        //           }
        // debug("línea " + curLinea.valueBuffer("idlinea") + " pedido " + curLinea.valueBuffer("idpedido"));
        //           mensaje = util.translate("scritps", "Error de consistencia en la línea de pedido cerrada. La cantidad de movimientos en estado HECHO (%1) es distinta de la cantidad del campo Total en albarán (%2)").arg(totalCan).arg(curLinea.valueBuffer("totalenalbaran"));
        //           ok = false;
        //           break;
        //         }
        if (AQUtil.sqlSelect("movistock", "idmovimiento", "idlineapp = " + curLinea.valueBuffer("idlinea") + " AND estado = 'PTE'")) {
          mensaje = sys.translate("Error de consistencia en la línea de pedido cerrada. La línea tiene movimientos en estado PTE");
          ok = false;
          break;
        }
      } else {
        totalCan = parseFloat(util.sqlSelect("movistock", "SUM(cantidad)", "idlineapp = " + curLinea.valueBuffer("idlinea")));
        totalCan = isNaN(totalCan) ? 0 : totalCan;
        var canPendiente = parseFloat(curLinea.valueBuffer("cantidad")) - parseFloat(curLinea.valueBuffer("totalenalbaran"));
        canPendiente = isNaN(canPendiente) ? 0 : canPendiente;
        if (totalCan != canPendiente) {
          if (totalCan == 0 && util.sqlSelect("articulos", "nostock", "referencia = '" + curLinea.valueBuffer("referencia") + "'")) {
            return true;
          }
          mensaje = util.translate("scritps", "Error de consistencia en la línea de pedido. La cantidad en movimientos (%1) es distinta de la cantidad de la línea (%2)").arg(totalCan).arg(canPendiente);
          ok = false;
          break;
        }
      }
      break;
    }
    case "lineasalbaranescli": {
      var totalCan: Number = parseFloat(util.sqlSelect("movistock", "SUM(cantidad)", "idlineaac = " + curLinea.valueBuffer("idlinea")));
      if (!totalCan || isNaN(totalCan))
        totalCan = 0;
      totalCan = totalCan * -1;
      if (totalCan != parseFloat(curLinea.valueBuffer("cantidad"))) {
        if (totalCan == 0 && util.sqlSelect("articulos", "nostock", "referencia = '" + curLinea.valueBuffer("referencia") + "'")) {
          return true;
        }
        mensaje = util.translate("scritps", "Error de consistencia en la línea de albarán. La cantidad de movimientos (%1) es distinta de la cantidad de la línea (%2)").arg(totalCan).arg(curLinea.valueBuffer("cantidad"));
        ok = false;
        break;
      }
      break;
    }
    case "lineasalbaranesprov": {
      var totalCan: Number = parseFloat(util.sqlSelect("movistock", "SUM(cantidad)", "idlineaap = " + curLinea.valueBuffer("idlinea")));
      if (!totalCan || isNaN(totalCan))
        totalCan = 0;
      if (totalCan != parseFloat(curLinea.valueBuffer("cantidad"))) {
        if (totalCan == 0 && util.sqlSelect("articulos", "nostock", "referencia = '" + curLinea.valueBuffer("referencia") + "'")) {
          return true;
        }
        mensaje = util.translate("scritps", "Error de consistencia en la línea de albarán. La cantidad de movimientos (%1) es distinta de la cantidad de la línea (%2)").arg(totalCan).arg(curLinea.valueBuffer("cantidad"));
        ok = false;
        break;
      }
      break;
    }
  }
  if (!ok) {
    MessageBox.warning(mensaje, MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton, "AbanQ");
    return false;
  }

  return true;
}

/** \C Divide los movimientos pendientes de una línea de pedido y asocia la parte correspondiente a una línea de albarán
@param  idLineaPedido: Identificador de la línea de pedido
@param  curLA: Cursor posicionado en la línea de albarán
\end */
//function articomp_albaranarParcialLPP(idLineaPedido:String, curLA:FLSqlCursor):Boolean
/// Eliminamos la antigua función albaranarLineaPedProv y usamos siempre la de albaranar parcial, que pasa a llamarse simplemente albaranarLineaPedProv
function articomp_albaranarLineaPedProv(curLA)
{
  var util: FLUtil = new FLUtil;
  var _i = this.iface;

  var idLineaPedido = curLA.valueBuffer("idlineapedido");

  if (!this.iface.curMoviStock) {
    this.iface.curMoviStock = new FLSqlCursor("movistock");
  }
  var cantidadPedido: Number = parseFloat(util.sqlSelect("lineaspedidosprov", "cantidad", "idlinea = "  + idLineaPedido));

  var fechaAlbaran, horaAlbaran, codAlmacen;
  var curAlbaran: FLSqlCursor = curLA.cursorRelation();
  if (curAlbaran) {
    fechaAlbaran = curAlbaran.valueBuffer("fecha");
    horaAlbaran = curAlbaran.valueBuffer("hora");
    codAlmacen = curAlbaran.valueBuffer("codalmacen");
  } else {
    fechaAlbaran = util.sqlSelect("albaranesprov", "fecha", "idalbaran = " + curLA.valueBuffer("idalbaran"));
    horaAlbaran = util.sqlSelect("albaranesprov", "hora", "idalbaran = " + curLA.valueBuffer("idalbaran"));
    codAlmacen = util.sqlSelect("albaranesprov", "codalmacen", "idalbaran = " + curLA.valueBuffer("idalbaran"));
  }

  var referencia = curLA.valueBuffer("referencia");
  var idStock;
  idStock = util.sqlSelect("stocks", "idstock", "referencia = '" + referencia + "' AND codalmacen = '" + codAlmacen + "'");
  if (!idStock) {
    var oArticulo = new Object;
    oArticulo["referencia"] = referencia;
    idStock = _i.crearStock(codAlmacen, oArticulo);
    if (!idStock) {
      return false;
    }
  }

  if (!fechaAlbaran) {
    return false;
  }
  horaAlbaran = horaAlbaran.toString();
  var hora = horaAlbaran.right(8);

  var cantidadAlb = curLA.valueBuffer("cantidad") ;
  if (cantidadAlb == 0) {
    return false;
  }

  cantidadAlb = util.roundFieldValue(cantidadAlb, "movistock", "cantidad");
  var referencia = curLA.valueBuffer("referencia");

  var curMSOrigen: FLSqlCursor = new FLSqlCursor("movistock");
  if (util.sqlSelect("articulos", "stockcomp", "referencia = '" + referencia + "'")) {
    var qry: FLSqlQuery = new FLSqlQuery();
    qry.setTablesList("articuloscomp");
    qry.setSelect("refcomponente, cantidad");
    qry.setFrom("articuloscomp");
    qry.setWhere("refcompuesto = '" + referencia + "' AND (idtipoopcionart IS NULL OR idtipoopcionart = 0)");

    if (!qry.exec())
      return false;

    var refComp: String = "";
    var cantComp = 0;

    while (qry.next()) {
      cantComp = cantidadAlb * parseFloat(qry.value("cantidad"));
      refComp = qry.value("refcomponente")

                curMSOrigen.select("idlineapp = " + idLineaPedido + " AND referencia = '" + refComp + "' AND estado = 'PTE'");
      if (curMSOrigen.size() > 1) {
        if (!_i.unificarMovPtePC(idLineaPedido)) {
          return false;
        }
        curMSOrigen.select("idlineapp = " + idLineaPedido + " AND estado = 'PTE'");
        if (curMSOrigen.size() > 1) {
          return false;
        }
      }
      if (!curMSOrigen.first()) {
        return false;
      }

      var cantidadPte = curMSOrigen.valueBuffer("cantidad");
      cantidadPte = isNaN(cantidadPte) ? 0 : cantidadPte;

      cantidadPte -= cantComp;
      if (cantidadPte < 0) {
        MessageBox.warning(util.translate("scripts", "No puede establecer una cantidad albaranada superior a la cantidad de la línea de pedido asociada.\nSi realmente va a servir más cantidad que la pedida indíquelo en una nueva línea de albarán"), MessageBox.Ok,  MessageBox.NoButton);
        return false;
      }
      cantidadPte = util.roundFieldValue(cantidadPte, "movistock", "cantidad");
      cantComp = util.roundFieldValue(cantComp, "movistock", "cantidad");

      this.iface.curMoviStock.setModeAccess(this.iface.curMoviStock.Insert);
      this.iface.curMoviStock.refreshBuffer();

      this.iface.curMoviStock.setValueBuffer("cantidad", cantComp);
      this.iface.curMoviStock.setValueBuffer("fechareal", fechaAlbaran);
      this.iface.curMoviStock.setValueBuffer("horareal", hora);
      this.iface.curMoviStock.setValueBuffer("idstock", idStock);
      this.iface.curMoviStock.setValueBuffer("idlineaap", curLA.valueBuffer("idlinea"));
      this.iface.curMoviStock.setValueBuffer("idlineapp", curMSOrigen.valueBuffer("idlineapp"));

      if (!this.iface.albaranaDatosMoviStock(curMSOrigen, curLA)) {
        return false;
      }

      if (!_i.curMoviStock.commitBuffer()) {
        return false;
      }

      if (parseFloat(cantidadPte) == 0) {
        curMSOrigen.setModeAccess(curMSOrigen.Del);
        curMSOrigen.refreshBuffer();
      } else {
        curMSOrigen.setModeAccess(curMSOrigen.Edit);
        curMSOrigen.refreshBuffer();
        curMSOrigen.setValueBuffer("cantidad", cantidadPte);
      }

      if (!curMSOrigen.commitBuffer()) {
        return false;
      }
    }
  } else {
    curMSOrigen.select("idlineapp = " + idLineaPedido + " AND estado = 'PTE'");
    if (curMSOrigen.size() > 1) {
      if (!_i.unificarMovPtePP(idLineaPedido)) {
        return false;
      }
      curMSOrigen.select("idlineapp = " + idLineaPedido + " AND estado = 'PTE'");
      if (curMSOrigen.size() > 1) {
        return false;
      }
    }
    if (!curMSOrigen.first()) {
      return false;
    }

    var cantidadPte = curMSOrigen.valueBuffer("cantidad");
    cantidadPte = isNaN(cantidadPte) ? 0 : cantidadPte;
    cantidadPte -= cantidadAlb;
    if (cantidadPte < 0) {
      MessageBox.warning(util.translate("scripts", "No puede establecer una cantidad albaranada superior a la cantidad de la línea de pedido asociada.\nSi realmente va a servir más cantidad que la pedida indíquelo en una nueva línea de albarán"), MessageBox.Ok,  MessageBox.NoButton);
      return false;
    }
    cantidadPte = util.roundFieldValue(cantidadPte, "movistock", "cantidad");

    this.iface.curMoviStock.setModeAccess(this.iface.curMoviStock.Insert);
    this.iface.curMoviStock.refreshBuffer();

    this.iface.curMoviStock.setValueBuffer("cantidad", cantidadAlb);
    this.iface.curMoviStock.setValueBuffer("fechareal", fechaAlbaran);
    this.iface.curMoviStock.setValueBuffer("horareal", hora);
    this.iface.curMoviStock.setValueBuffer("idstock", idStock);
    this.iface.curMoviStock.setValueBuffer("idlineaap", curLA.valueBuffer("idlinea"));
    this.iface.curMoviStock.setValueBuffer("idlineapp", curMSOrigen.valueBuffer("idlineapp"));

    if (!this.iface.albaranaDatosMoviStock(curMSOrigen, curLA)) {
      return false;
    }

    if (!_i.curMoviStock.commitBuffer()) {
      return false;
    }

    if (parseFloat(cantidadPte) == 0) {
      curMSOrigen.setModeAccess(curMSOrigen.Del);
      curMSOrigen.refreshBuffer();
    } else {
      curMSOrigen.setModeAccess(curMSOrigen.Edit);
      curMSOrigen.refreshBuffer();
      curMSOrigen.setValueBuffer("cantidad", cantidadPte);
    }

    if (!curMSOrigen.commitBuffer()) {
      return false;
    }
  }


  if (!_i.consistenciaLinea(curLA)) {
    return false;
  }

  return true;
  /*
  var cantidadPte:Number;
  var cantidadAlb:Number;
  var factor:Number;
  var cantidadMovi:Number;
  while (curMSOrigen.next()) {
    curMSOrigen.setModeAccess(curMSOrigen.Edit);
    curMSOrigen.refreshBuffer();

    cantidadMovi = parseFloat(util.sqlSelect("movistock", "SUM(cantidad)", "idlineapp = "  + idLineaPedido + " AND idstock = " + curMSOrigen.valueBuffer("idstock")));
    if (isNaN(cantidadMovi)) {
      cantidadMovi = 0;
    }
    factor = cantidadMovi / cantidadPedido;

    cantidadPte = curMSOrigen.valueBuffer("cantidad");
    cantidadAlb = curLA.valueBuffer("cantidad") * factor;
    cantidadPte -= cantidadAlb;
    if (cantidadPte < 0) {
      MessageBox.warning(util.translate("scripts", "No puede establecer una cantidad albaranada superior a la cantidad de la línea de pedido asociada.\nSi realmente va a servir más cantidad que la pedida indíquelo en una nueva línea de albarán"), MessageBox.Ok,  MessageBox.NoButton);
      return false;
    }
    cantidadPte = util.roundFieldValue(cantidadPte, "movistock", "cantidad");
    cantidadAlb = util.roundFieldValue(cantidadAlb, "movistock", "cantidad");

    if (cantidadAlb == 0)
      return false;

    this.iface.curMoviStock.setModeAccess(this.iface.curMoviStock.Insert);
    this.iface.curMoviStock.refreshBuffer();

    this.iface.curMoviStock.setValueBuffer("cantidad", cantidadAlb);
    this.iface.curMoviStock.setValueBuffer("fechareal", fechaAlbaran);
    this.iface.curMoviStock.setValueBuffer("horareal", hora);
    this.iface.curMoviStock.setValueBuffer("idlineaap", curLA.valueBuffer("idlinea"));
    this.iface.curMoviStock.setValueBuffer("idlineapp", curMSOrigen.valueBuffer("idlineapp"));

    if (!this.iface.albaranaDatosMoviStock(curMSOrigen)) {
      return false;
    }

    if (parseFloat(cantidadPte) == 0) {
      curMSOrigen.setModeAccess(curMSOrigen.Del);
      curMSOrigen.refreshBuffer();
    } else {
      curMSOrigen.setValueBuffer("cantidad", cantidadPte);
    }

    if (!curMSOrigen.commitBuffer())
      return false;

    if (!this.iface.curMoviStock.commitBuffer())
      return false;
  }
  return true;
  */
}

function articomp_albaranaDatosMoviStock(curMSOrigen, curLA)
{
  with(this.iface.curMoviStock) {
    setValueBuffer("referencia", curMSOrigen.valueBuffer("referencia"));
    setValueBuffer("estado", "HECHO");
    setValueBuffer("fechaprev", curMSOrigen.valueBuffer("fechaprev"));
    setValueBuffer("codlote", curMSOrigen.valueBuffer("codlote"));
    setValueBuffer("codloteprod", curMSOrigen.valueBuffer("codloteprod"));
  }
  if (curMSOrigen.isNull("idarticulocomp")) {
    this.iface.curMoviStock.setNull("idarticulocomp");
  } else {
    this.iface.curMoviStock.setValueBuffer("idarticulocomp", curMSOrigen.valueBuffer("idarticulocomp"));
  }
  if (curMSOrigen.isNull("idtipotareapro")) {
    this.iface.curMoviStock.setNull("idtipotareapro");
  } else {
    this.iface.curMoviStock.setValueBuffer("idtipotareapro", curMSOrigen.valueBuffer("idtipotareapro"));
  }

  return true;
}


/** \D Borra la estructura de lotes de stock y salidas programadas asociada a los artículos pedidos
\end */
function articomp_borrarEstructura(curLinea: FLSqlCursor): Boolean {
  var util: FLUtil = new FLUtil;
  var referencia: String = curLinea.valueBuffer("referencia");
  if (!referencia || referencia == "")
  {
    return true;
  }
  if (!this.iface.borrarMoviStock(curLinea))
  {
    return false;
  }
  return true;
}

/** \D Borra los movimientos de stock asociados a una línea de pedido
@param  idLinea: Identificador de la línea de pedido
@return true si los movimientos se borrar correctamente, false en caso contrario
\end */
function articomp_borrarMoviStock(curLinea: FLSqlCursor): Boolean {
  var util: FLUtil = new FLUtil;

  var tabla: String = curLinea.table();
  var idLinea: String;

  switch (tabla)
  {
    case "lineaspresupuestoscli": {
      idLinea = curLinea.valueBuffer("idlinea");
      if (!util.sqlDelete("movistock", "idlineapr = " + idLinea))
        return false;
      break;
    }
    case "lineaspedidoscli": {
      idLinea = curLinea.valueBuffer("idlinea");
      if (!util.sqlDelete("movistock", "idlineapc = " + idLinea + " AND (idlineaac IS NULL OR idlineaac = 0)"))
        return false;
      break;
    }
    case "lineaspedidosprov": {
      idLinea = curLinea.valueBuffer("idlinea");
      if (!util.sqlDelete("movistock", "idlineapp = " + idLinea + " AND (idlineaap IS NULL OR idlineaap = 0)"))
        return false;
      break;
    }
    case "lineastransstock": {
      idLinea = curLinea.valueBuffer("idlinea");
      if (!util.sqlDelete("movistock", "idlineats = " + idLinea))
        return false;
      break;
    }
    case "tpv_lineascomanda": {
      idLinea = curLinea.valueBuffer("idtpv_linea");
      if (!util.sqlDelete("movistock", "idlineaco = " + idLinea))
        return false;
      break;
    }
    case "tpv_lineasvale": {
      idLinea = curLinea.valueBuffer("idlinea");
      if (!util.sqlDelete("movistock", "idlineava = " + idLinea))
        return false;
      break;
    }
    case "lineasalbaranescli": {
      idLinea = curLinea.valueBuffer("idlinea");
      if (!util.sqlDelete("movistock", "idlineaac = " + idLinea))
        return false;
      break;
    }
    case "lineasalbaranesprov": {
      idLinea = curLinea.valueBuffer("idlinea");
      if (!util.sqlDelete("movistock", "idlineaap = " + idLinea))
        return false;
      break;
    }
    case "lineasfacturascli": {
      idLinea = curLinea.valueBuffer("idlinea");
      if (!util.sqlDelete("movistock", "idlineafc = " + idLinea + " AND (idlineaac IS NULL OR idlineaac = 0)"))
        return false;
      break;
    }
    case "lineasfacturasprov": {
      idLinea = curLinea.valueBuffer("idlinea");
      if (!util.sqlDelete("movistock", "idlineafp = " + idLinea + " AND (idlineaap IS NULL OR idlineaap = 0)"))
        return false;
      break;
    }
    case "lineascomposicion": {
      idLinea = curLinea.valueBuffer("idlinea");
      if (!util.sqlDelete("movistock", "idlineacm = " + idLinea))
        return false;
      break;
    }
    case "composiciones": {
      var idComposicion = curLinea.valueBuffer("idcomposicion");
      if (!util.sqlDelete("movistock", "idcomposicion = " + idComposicion))
        return false;
      break;
    }
  }

  return true;
}

function articomp_afterCommit_lineascomposicion(curLC)
{
  debug("articomp_afterCommit_lineascomposicion");
  if (!this.iface.controlStockLineasComp(curLC)) {
    return false;
  }
  return true;
}

function articomp_controlStockLineasComp(curLC)
{
  switch (curLC.modeAccess()) {
    case curLC.Insert: {
      if (!this.iface.generarEstructura(curLC)) {
        return false;
      }
      break;
    }
    case curLC.Edit: {
      if (this.iface.datosStockLineaCambian(curLC)) {
        if (!this.iface.borrarEstructura(curLC)) {
          return false;
        }
        if (!this.iface.generarEstructura(curLC)) {
          return false;
        }
      }
      break;
    }
    case curLC.Del: {
      if (!this.iface.borrarEstructura(curLC)) {
        return false;
      }
      break;
    }
  }
  return true;
}

function articomp_afterCommit_composiciones(curComp)
{
  if (!this.iface.controlStockComposiciones(curComp)) {
    return false;
  }
  return true;
}

function articomp_controlStockComposiciones(curComp)
{
  switch (curComp.modeAccess()) {
    case curComp.Insert: {
      if (!this.iface.generarEstructura(curComp)) {
        return false;
      }
      break;
    }
    case curComp.Edit: {
      if (this.iface.datosStockLineaCambian(curComp)) {
        if (!this.iface.borrarEstructura(curComp)) {
          return false;
        }
        if (!this.iface.generarEstructura(curComp)) {
          return false;
        }
      }
      break;
    }
    case curComp.Del: {
      if (!this.iface.borrarEstructura(curComp)) {
        return false;
      }
      break;
    }
  }
  return true;
}

function articomp_controlStockCabComandas(curComanda)
{
  debug("articomp_controlStockCabComandas");
  var _i = this.iface;
  if (curComanda.modeAccess() != curComanda.Edit) {
    return true;
  }
  var tipoDocAct = curComanda.valueBuffer("tipodoc");
  var tipoDocAnt = curComanda.valueBufferCopy("tipodoc");

  debug("articomp_controlStockCabComandas tipoDocAct: " + tipoDocAct);
  debug("articomp_controlStockCabComandas tipoDocAnt: " + tipoDocAnt);

  if (!tipoDocAct == tipoDocAnt) {
    debug(1);
    return true;
  }
  if (tipoDocAct != "presupuesto" && tipoDocAnt != "presupuesto") {
    debug(2);
    return true;
  }

  var cantidad, referencia;
  var curLineaComanda = new FLSqlCursor("tpv_lineascomanda");
  curLineaComanda.select("idtpv_comanda = " + curComanda.valueBuffer("idtpv_comanda"));
  while (curLineaComanda.next()) {
    if (!_i.borrarEstructura(curLineaComanda)) {
      return false;
    }
    if (!_i.generarEstructura(curLineaComanda)) {
      return false;
    }
  }
  return true;
}

//// ARTICULOSCOMP //////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
