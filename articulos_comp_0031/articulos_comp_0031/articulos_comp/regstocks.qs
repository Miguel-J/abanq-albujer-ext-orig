
/** @class_declaration kits */
/////////////////////////////////////////////////////////////////
//// ARTICULOS COMPUESTOS ///////////////////////////////////////
class kits extends oficial
{
  function kits(context)
  {
    oficial(context);
  }
  function init()
  {
    return this.ctx.kits_init();
  }
  function commonCalculateField(fN, cursor, oParam)
  {
    return this.ctx.kits_commonCalculateField(fN, cursor, oParam);
  }
  function mostrarListadoMS()
  {
    return this.ctx.kits_mostrarListadoMS();
  }
  function filtrarMovimientos()
  {
    return this.ctx.kits_filtrarMovimientos();
  }
  function dameFiltros()
  {
    return this.ctx.kits_dameFiltros();
  }
  function dameFiltroDesdeUltimaReg()
  {
    return this.ctx.kits_dameFiltroDesdeUltimaReg();
  }
  function dameFiltroExcluirPtes()
  {
    return this.ctx.kits_dameFiltroExcluirPtes();
  }
  function dameFiltroReservada()
  {
    return this.ctx.kits_dameFiltroReservada();
  }
  function dameFiltroPteRecibir()
  {
    return this.ctx.kits_dameFiltroPteRecibir();
  }
  function calcularCantidad()
  {
    return this.ctx.kits_calcularCantidad();
  }
  function tbwStock_currentChanged(tab)
  {
    return this.ctx.kits_tbwStock_currentChanged(tab);
  }
  function tbnVerDocumento_clicked()
  {
    return this.ctx.kits_tbnVerDocumento_clicked();
  }
  function muestraDoc(tabla, where)
  {
    return this.ctx.kits_muestraDoc(tabla, where);
  }
  function ordenColsMS()
  {
    return this.ctx.kits_ordenColsMS();
  }
}
//// ARTICULOS COMPUESTOS ///////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition kits */
/////////////////////////////////////////////////////////////////
//// ARTICULOS COMPUESTOS ///////////////////////////////////////
function kits_init()
{
  var _i = this.iface;
  _i.__init();

  connect(this.child("chkDesdeUltReg"), "clicked()", this, "iface.filtrarMovimientos");
  connect(this.child("chkExcluirPtes"), "clicked()", this, "iface.filtrarMovimientos");
  connect(this.child("chkReservado"), "clicked()", this, "iface.filtrarMovimientos");
  connect(this.child("chkPteRecibir"), "clicked()", this, "iface.filtrarMovimientos");
  connect(this.child("tnbMostrarListadoMS"), "clicked()", this, "iface.mostrarListadoMS");
  connect(this.child("tbwStock"), "currentChanged(QString)", _i, "tbwStock_currentChanged");
  connect(this.child("tbnVerDocumento"), "clicked()", _i, "tbnVerDocumento_clicked");

  var campos = _i.ordenColsMS();
  this.child("tdbMoviStocks").setOrderCols(campos);
  this.iface.filtrarMovimientos();
}

function kits_ordenColsMS()
{
  return ["fechareal", "horareal", "fechaprev", "estado", "concepto", "cantidad"];
}

function kits_tbwStock_currentChanged(tab)
{
  debug("tab " + tab);
}

function kits_mostrarListadoMS()
{
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  var f: Object = new FLFormSearchDB("mostrarlistadoms");
  var curMostrar: FLSqlCursor = f.cursor();
  curMostrar.select("idusuario = '" + sys.nameUser() + "'");
  if (!curMostrar.first()) {
    curMostrar.setModeAccess(curMostrar.Insert);
    curMostrar.refreshBuffer();
    curMostrar.setValueBuffer("idusuario", sys.nameUser());
  } else {
    curMostrar.setModeAccess(curMostrar.Edit);
    curMostrar.refreshBuffer();
  }
  curMostrar.setValueBuffer("idstock", cursor.valueBuffer("idstock"));
  curMostrar.setValueBuffer("codalmacen", cursor.valueBuffer("codalmacen"));
  curMostrar.setValueBuffer("referencia", cursor.valueBuffer("referencia"));
  curMostrar.setValueBuffer("desdeultimareg", true);
  curMostrar.setValueBuffer("pendiente", true);
  curMostrar.setValueBuffer("reservado", true);
  curMostrar.setValueBuffer("hecho", true);
  if (!curMostrar.commitBuffer()) {
    return false;;
  }
  curMostrar.select("idusuario = '" + sys.nameUser() + "' AND idstock = " + cursor.valueBuffer("idstock"));
  if (!curMostrar.first()) {
    return false;
  }
  curMostrar.setModeAccess(curMostrar.Edit);
  curMostrar.refreshBuffer();

  f.setMainWidget();
  curMostrar.refreshBuffer();
  var acpt: String = f.exec("idusuario");
  if (!acpt) {
    return false;
  }
}

function kits_filtrarMovimientos()
{
  var _i = this.iface;

  var filtro = _i.dameFiltros();
  if (!filtro || filtro == "") {
    filtro = "1 = 2";
  } else {
    filtro = "(" + filtro + ")";
  }
  debug("filtro " + filtro);

  this.child("tdbMoviStocks").cursor().setMainFilter(filtro);
  this.child("tdbMoviStocks").refresh();
}

function kits_dameFiltros()
{
  var _i = this.iface;
  var filtro = "";

  //  var filtroUltReg = _i.dameFiltroDesdeUltimaReg();
  //  if(filtroUltReg && filtroUltReg != "")
  //    filtro += "(" + filtroUltReg;

  var filtroHecho =  _i.dameFiltroExcluirPtes();
  if (filtroHecho && filtroHecho != "") {
    //    if(filtro && filtro != "")
    //      filtro += " AND ";
    //    else
    //      filtro += "(";
    //
    filtro += filtroHecho;
  }

  //  if(filtro && filtro != "")
  //      filtro += ")";

  var filttroResesrvada = _i.dameFiltroReservada();
  if (filttroResesrvada && filttroResesrvada != "") {
    if (filtro && filtro != "")
      filtro += " OR ";
    filtro += filttroResesrvada;
  }

  var filttroPteRecibir = _i.dameFiltroPteRecibir();
  if (filttroPteRecibir && filttroPteRecibir != "") {
    if (filtro && filtro != "")
      filtro += " OR ";
    filtro += filttroPteRecibir;
  }

  return filtro;
}

function kits_dameFiltroExcluirPtes()
{
  var _i = this.iface;
  var filtro = "";

  if (this.child("chkExcluirPtes").checked) {
    filtro += "estado = 'HECHO'";
    var fUR = _i.dameFiltroDesdeUltimaReg();
    if (fUR && fUR  != "") {
      filtro = "(" + filtro + " AND " + fUR + ")";
    }
  }
  return filtro;
}

function kits_dameFiltroReservada()
{
  var filtro = "";

  if (this.child("chkReservado").checked) {
    filtro += "(estado = 'PTE' and cantidad < 0)";
  }
  //  else {
  //    filtro += "(estado <> 'PTE' and cantidad < 0)";
  //  }

  return filtro;
}

function kits_dameFiltroPteRecibir()
{
  var filtro = "";

  if (this.child("chkPteRecibir").checked) {
    filtro += "(estado = 'PTE' and cantidad >= 0)";
  }
  //  else {
  //    filtro += "(estado <> 'PTE' and cantidad >= 0)";
  //  }

  return filtro;
}

function kits_dameFiltroDesdeUltimaReg()
{
  var filtro = "";
  var cursor = this.cursor();

  if (this.child("chkDesdeUltReg").checked) {
    var ultFecha = cursor.isNull("fechaultreg") ? false : cursor.valueBuffer("fechaultreg");
    //    util.sqlSelect("lineasregstocks", "fecha", "idstock = " + cursor.valueBuffer("idstock") + " ORDER BY fecha DESC, hora DESC");
    if (ultFecha && ultFecha != "") {
      var ultHora = cursor.isNull("horaultreg") ? false : cursor.valueBuffer("horaultreg");
      //      util.sqlSelect("lineasregstocks", "hora", "idstock = " + cursor.valueBuffer("idstock") + " AND fecha = '" + ultFecha + "' ORDER BY hora DESC");
      if (ultHora && ultHora != "") {
        filtro += "((fechareal IS NULL OR fechareal > '" + ultFecha + "') OR (fechareal = '" + ultFecha + "' AND (horareal > '" + ultHora.toString().right(8) + "' 	OR horareal IS NULL)))";
      }
    }
  }

  return filtro;
}


function kits_calcularCantidad()
{
  var cursor: FLSqlCursor = this.cursor();
  var util: FLUtil = new FLUtil;

  this.iface.calcularValoresUltReg();

  this.child("fdbCantidad").setValue(this.iface.calculateField("cantidad"));
  this.child("fdbReservada").setValue(this.iface.calculateField("reservada"));
  this.child("fdbDisponible").setValue(this.iface.calculateField("disponible"));

  this.iface.filtrarMovimientos();
}

function kits_commonCalculateField(fN, cursor, oParam)
{
  var _i = this.iface;
  var util = new FLUtil;
  var valor;
  var idStock = cursor.valueBuffer("idstock");
  var fechaMax = oParam ? oParam.fechaMax : false;
  switch (fN) {
    case "pterecibir": {
      valor = parseFloat(util.sqlSelect("movistock", "SUM(cantidad)", "idstock = " + idStock + " AND estado = 'PTE' AND cantidad > 0"));
      if (!valor || isNaN(valor)) {
        valor = 0;
      }
      valor = util.roundFieldValue(valor, "stocks", "pterecibir");
      break;
    }
    case "reservada": {
      valor = parseFloat(util.sqlSelect("movistock", "SUM(cantidad)", "idstock = " + idStock + " AND estado = 'PTE' AND cantidad < 0"));
      if (!valor || isNaN(valor)) {
        valor = 0;
      }
      valor *= -1;
      valor = util.roundFieldValue(valor, "stocks", "reservada");
      break;
    }
    case "cantidad": {
      var whereStock = "idstock = " + idStock + " AND estado = 'HECHO'";
      var fUltReg = false, hUltReg = false, cantUltReg = 0;
      if (fechaMax) {
        var fM = fechaMax.toString().left(10);
        var hM = fechaMax.toString().right(8);
        whereStock += " AND (fechareal < '" + fM + "' OR (fechareal = '" + fM + "' AND horareal <= '" + hM + "'))";
        var q = new AQSqlQuery;
        q.setSelect("fecha, hora, cantidadfin");
        q.setFrom("lineasregstocks");
        q.setWhere("idstock = " + cursor.valueBuffer("idstock") + " AND ((fecha < '" + fM + "') OR (fecha = '" + fM + "' AND hora < '" + hM + "')) ORDER BY fecha DESC, hora DESC");
        if (!q.exec()) {
          return false;
        }
        if (q.first()) {
          fUltReg = q.value("fecha").toString().left(10);
          hUltReg = q.value("hora").toString().right(8);
          cantUltReg = q.value("cantidadfin");
        }
      } else {
        fUltReg = cursor.isNull("fechaultreg") ? false : cursor.valueBuffer("fechaultreg").toString().left(10);
        hUltReg = cursor.isNull("horaultreg") ? false : cursor.valueBuffer("horaultreg").toString().right(8);
        cantUltReg = cursor.isNull("cantidadultreg") ? false : cursor.valueBuffer("cantidadultreg");
      }
      if (fUltReg) {
        whereStock += " AND ((fechareal > '" + fUltReg + "') OR (fechareal = '" + fUltReg + "' AND horareal > '" + hUltReg + "'))";
      }
      var cantidadMov = parseFloat(util.sqlSelect("movistock", "SUM(cantidad)", whereStock));
      if (!cantidadMov || isNaN(cantidadMov)) {
        cantidadMov = 0;
      }
      valor = parseFloat(cantUltReg) + parseFloat(cantidadMov);
      valor = util.roundFieldValue(valor, "stocks", "cantidad");
      break;
    }
    default: {
      valor = this.iface.__commonCalculateField(fN, cursor, oParam);
      break;
    }
  }
  return valor;
}

function kits_tbnVerDocumento_clicked()
{
  var _i = this.iface;
  var curMS = this.child("tdbMoviStocks").cursor();
  var idMov = curMS.valueBuffer("idmovimiento");
  if (!idMov) {
    return;
  }
  if (!curMS.isNull("idlineapc")) {
    var idPedido = AQUtil.sqlSelect("lineaspedidoscli", "idpedido", "idlinea = " + curMS.valueBuffer("idlineapc"));
    if (!idPedido) {
      sys.warnMsgBox(sys.translate("Error al localizar el pedido de cliente asociado al movimiento seleccionado"));
      return;
    }
    _i.muestraDoc("pedidoscli", "idpedido = " + idPedido);
  } else if (!curMS.isNull("idlineapp")) {
    var idPedido = AQUtil.sqlSelect("lineaspedidosprov", "idpedido", "idlinea = " + curMS.valueBuffer("idlineapp"));
    if (!idPedido) {
      sys.warnMsgBox(sys.translate("Error al localizar el pedido de proveedor asociado al movimiento seleccionado"));
      return;
    }
    _i.muestraDoc("pedidosprov", "idpedido = " + idPedido);
  } else if (!curMS.isNull("idlineaac")) {
    var idAlbaran = AQUtil.sqlSelect("lineasalbaranescli", "idalbaran", "idlinea = " + curMS.valueBuffer("idlineaac"));
    if (!idAlbaran) {
      sys.warnMsgBox(sys.translate("Error al localizar el albarán de cliente asociado al movimiento seleccionado"));
      return;
    }
    _i.muestraDoc("albaranescli", "idalbaran = " + idAlbaran);
  } else if (!curMS.isNull("idlineaap")) {
    var idAlbaran = AQUtil.sqlSelect("lineasalbaranesprov", "idalbaran", "idlinea = " + curMS.valueBuffer("idlineaap"));
    if (!idAlbaran) {
      sys.warnMsgBox(sys.translate("Error al localizar el albarán de proveedor asociado al movimiento seleccionado"));
      return;
    }
    _i.muestraDoc("albaranesprov", "idalbaran = " + idAlbaran);
  } else if (!curMS.isNull("idlineats")) {
    var idTrans = AQUtil.sqlSelect("lineastransstock", "idtrans", "idlinea = " + curMS.valueBuffer("idlineats"));
    if (!idTrans) {
      sys.warnMsgBox(sys.translate("Error al localizar la transferencia de stock asociado al movimiento seleccionado"));
      return;
    }
    _i.muestraDoc("transstock", "idtrans = " + idTrans);
  } else if (!curMS.isNull("idlineaco")) {
    var idComanda = AQUtil.sqlSelect("tpv_lineascomanda", "idtpv_comanda", "idtpv_linea = " + curMS.valueBuffer("idlineaco"));
    if (!idComanda) {
      sys.warnMsgBox(sys.translate("Error al localizar la venta de TPV asociado al movimiento seleccionado"));
      return;
    }
    _i.muestraDoc("tpv_comandas", "idtpv_comanda = " + idComanda);
  } else if (!curMS.isNull("idproceso")) {
    _i.muestraDoc("pr_procesos", "idproceso = " + curMS.valueBuffer("idproceso"));
  }
}

function kits_muestraDoc(tabla, where)
{
  var curD = new FLSqlCursor(tabla);
  curD.select(where);
  if (!curD.first()) {
    return false;
  }
  curD.browseRecord();
}

//// ARTICULOS COMPUESTOS ///////////////////////////////////////
/////////////////////////////////////////////////////////////////
