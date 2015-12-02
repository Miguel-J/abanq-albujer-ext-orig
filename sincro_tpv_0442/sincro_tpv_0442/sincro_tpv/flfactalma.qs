
/** @class_declaration sincrotpv */
/////////////////////////////////////////////////////////////////
//// SINCRO TPV /////////////////////////////////////////////////
class sincrotpv extends sincrocat
{
  var paramSincro_, filtroComandasActual_, filtroExViajes_, filtroRxViajes_;
  function sincrotpv(context)
  {
    sincrocat(context);
  }
  function controlStockComandasCli(curLV)
  {
    return this.ctx.sincrotpv_controlStockComandasCli(curLV);
  }
  function datosStockLineaCambian(curL)
  {
    return this.ctx.sincrotpv_datosStockLineaCambian(curL);
  }
  function dameOrdenTablas(esquema)
  {
    return this.ctx.sincrotpv_dameOrdenTablas(esquema);
  }
  function filtroLista(t, w, campoId, reverse)
  {
    return this.ctx.sincrotpv_filtroLista(t, w, campoId, reverse);
  }
  function dameDatosTabla(t, esquema)
  {
    return this.ctx.sincrotpv_dameDatosTabla(t, esquema);
  }
  function ponTiendaActual(oParam)
  {
    return this.ctx.sincrotpv_ponTiendaActual(oParam);
  }
  function filtroFechas(t)
  {
    return this.ctx.sincrotpv_filtroFechas(t);
  }
  function afterSincronizarTabla(oTabla, aResultados, silent)
  {
    return this.ctx.sincrotpv_afterSincronizarTabla(oTabla, aResultados, silent);
  }
  function marcarArqueosSincro(oTabla, aResultados, silent)
  {
    return this.ctx.sincrotpv_marcarArqueosSincro(oTabla, aResultados, silent);
  }
  function marcarComandasSincro(oTabla, aResultados, silent)
  {
    return this.ctx.sincrotpv_marcarComandasSincro(oTabla, aResultados, silent);
  }
  function filtroListaLineasComanda()
  {
    return this.ctx.sincrotpv_filtroListaLineasComanda();
  }
  function filtroListaPagosComanda()
  {
    return this.ctx.sincrotpv_filtroListaPagosComanda();
  }
  function calculaCampoSincro(curDestino, oTabla, campo)
  {
    return this.ctx.sincrotpv_calculaCampoSincro(curDestino, oTabla, campo);
  }
  function afterSincLineasComanda(oTabla, aResultados, silent)
  {
    return this.ctx.sincrotpv_afterSincLineasComanda(oTabla, aResultados, silent);
  }
  function afterSincPagosComanda(oTabla, aResultados, silent)
  {
    return this.ctx.sincrotpv_afterSincPagosComanda(oTabla, aResultados, silent);
  }
  function afterSincRxMultitrans(oTabla, aResultados, silent)
  {
    return this.ctx.sincrotpv_afterSincRxMultitrans(oTabla, aResultados, silent);
  }
  function controlExViajeMultitrans(oTabla, aResultados, silent)
  {
    return this.ctx.sincrotpv_controlExViajeMultitrans(oTabla, aResultados, silent);
  }
  function afterSincExMultitrans(oTabla, aResultados, silent)
  {
    return this.ctx.sincrotpv_afterSincExMultitrans(oTabla, aResultados, silent);
  }
  function afterSincRxViajes(oTabla, aResultados, silent)
  {
    return this.ctx.sincrotpv_afterSincRxViajes(oTabla, aResultados, silent);
  }
  function controlViajeMultitrans(oTabla, aResultados, silent)
  {
    return this.ctx.sincrotpv_controlViajeMultitrans(oTabla, aResultados, silent);
  }
  function controlLineasRxTienda(oTabla, aResultados, silent)
  {
    return this.ctx.sincrotpv_controlLineasRxTienda(oTabla, aResultados, silent);
  }
  function controlRxViajeTienda(oTabla, aResultados, silent)
  {
    return this.ctx.sincrotpv_controlRxViajeTienda(oTabla, aResultados, silent);
  }
  function controlStockMultiSinc(oTabla, aResultados, silent)
  {
    return this.ctx.sincrotpv_controlStockMultiSinc(oTabla, aResultados, silent);
  }
  function controlStockSincLineasComanda(oTabla, aResultados, silent)
  {
    return this.ctx.sincrotpv_controlStockSincLineasComanda(oTabla, aResultados, silent);
  }
  function controlPuntosPagosComandaSinc(oTabla, aResultados, silent)
  {
    return this.ctx.sincrotpv_controlPuntosPagosComandaSinc(oTabla, aResultados, silent);
  }
  function filtroPuntosPagoSinc()
  {
    return this.ctx.sincrotpv_filtroPuntosPagoSinc();
  }
  function afterSincComandas(oTabla, aResultados, silent)
  {
    return this.ctx.sincrotpv_afterSincComandas(oTabla, aResultados, silent);
  }
  function controlPuntosComandasSinc(oTabla, aResultados, silent)
  {
    return this.ctx.sincrotpv_controlPuntosComandasSinc(oTabla, aResultados, silent);
  }
  function controlDevolComandasSinc(oTabla, aResultados, silent)
  {
    return this.ctx.sincrotpv_controlDevolComandasSinc(oTabla, aResultados, silent);
  }
  function controlClientesComanda(oTabla, aResultados, silent)
  {
    return this.ctx.sincrotpv_controlClientesComanda(oTabla, aResultados, silent);
  }
  function sincronizaClienteComanda(curC)
  {
    return this.ctx.sincrotpv_sincronizaClienteComanda(curC);
  }
  function datosClienteComanda(curCliente, curComanda)
  {
    return this.ctx.sincrotpv_datosClienteComanda(curCliente, curComanda);
  }
  function datosDirClienteComanda(curDC, curCliente, curComanda)
  {
    return this.ctx.sincrotpv_datosDirClienteComanda(curDC, curCliente, curComanda);
  }
  function filtroPuntosComandaSinc()
  {
    return this.ctx.sincrotpv_filtroPuntosComandaSinc();
  }
  function afterCommit_stocks(curS)
  {
    return this.ctx.sincrotpv_afterCommit_stocks(curS);
  }
  function controlSincroStockTiendas(curS)
  {
    return this.ctx.sincrotpv_controlSincroStockTiendas(curS);
  }
  function datosControlSincroSTCambian(curS)
  {
    return this.ctx.sincrotpv_datosControlSincroSTCambian(curS);
  }
  function controlSincroDevolTiendas(curC)
  {
    return this.ctx.sincrotpv_controlSincroDevolTiendas(curC);
  }
  function afterSincStocks(oTabla, aResultados, silent)
  {
    return this.ctx.sincrotpv_afterSincStocks(oTabla, aResultados, silent);
  }
  function afterSincRegStock(oTabla, aResultados, silent)
  {
    return this.ctx.sincrotpv_afterSincRegStock(oTabla, aResultados, silent);
  }
  function marcarRegStockSincro(oTabla, aResultados, silent)
  {
    return this.ctx.sincrotpv_marcarRegStockSincro(oTabla, aResultados, silent);
  }
  function marcaStocksSincro(oTabla, aResultados, silent)
  {
    return this.ctx.sincrotpv_marcaStocksSincro(oTabla, aResultados, silent);
  }
  function afterSincComandasDevol(oTabla, aResultados, silent)
  {
    return this.ctx.sincrotpv_afterSincComandasDevol(oTabla, aResultados, silent);
  }
  function marcaDevolSincro(oTabla, aResultados, silent)
  {
    return this.ctx.sincrotpv_marcaDevolSincro(oTabla, aResultados, silent);
  }
  function calculaRegStockSincro(oTabla, aResultados, silent)
  {
    return this.ctx.sincrotpv_calculaRegStockSincro(oTabla, aResultados, silent);
  }
  function datosStockLineaMTOCambian(curL)
  {
    return this.ctx.sincrotpv_datosStockLineaMTOCambian(curL);
  }
  function datosStockLineaMTDCambian(curL)
  {
    return this.ctx.sincrotpv_datosStockLineaMTDCambian(curL);
  }
  function marcarComandasSincroCli(oTabla, aResultados, silent)
  {
    return this.ctx.sincrotpv_marcarComandasSincroCli(oTabla, aResultados, silent);
  }
  function afterSincComandasCli(oTabla, aResultados, silent)
  {
    return this.ctx.sincrotpv_afterSincComandasCli(oTabla, aResultados, silent);
  }
}
//// SINCRO TPV /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pubSincrotpv */
/////////////////////////////////////////////////////////////////
//// PUB SINCRO TPV /////////////////////////////////////////////
class pubSincrotpv extends pubSincrocat
{
  function pubSincrotpv(context)
  {
    pubSincrocat(context);
  }
  function pub_ponTiendaActual(oParam)
  {
    return this.ponTiendaActual(oParam);
  }
}
//// PUB SINCRO TPV /////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition sincrotpv */
/////////////////////////////////////////////////////////////////
//// SINCRO TPV /////////////////////////////////////////////////
function sincrotpv_controlStockComandasCli(curLV)
{
  var _i = this.iface;
  return _i.__controlStockComandasCli(curLV);
}

function sincrotpv_datosStockLineaCambian(curL)
{
  var _i = this.iface;
  if (curL.table() == "tpv_lineascomanda" && curL.valueBuffer("ptestock")) {
    return true;
  }
  if (!_i.__datosStockLineaCambian(curL)) {
    return false;
  }
  return true;
}

function sincrotpv_dameOrdenTablas(esquema)
{
  var _i = this.iface;

  var oT;
  switch (esquema) {
    case "VENTAS_TPV": {
      oT = ["tpv_arqueos", "tpv_comandas", "tpv_lineascomanda", "tpv_pagoscomanda"];
      break;
    }
    case "RX_GENERAL": {
      var e1 = _i.dameOrdenTablas("VENTAS_TPV");
      var e2 = _i.dameOrdenTablas("INVENTARIOS");
      var e3 = _i.dameOrdenTablas("TPV_RECEPCION_MULTITRANS");
      oT = e1.concat(e2, e3);
      break;
    }
    case "TX_GENERAL": {
      var e1 = _i.dameOrdenTablas("STOCKS");
      var e2 = _i.dameOrdenTablas("DEVOLUCIONES");
      var e3 = _i.dameOrdenTablas("TPV_ENVIO_MULTITRANS");
      oT = e1.concat(e2, e3);
      break;
    }
    case "TX_PUNTOS": {
      oT = ["tpv_tarjetaspuntos", "tpv_movpuntosnosinc"];
      break;
    }
    case "CATALOGO": {
      oT = ["impuestos", "familias", "articulos", "almacenes", "tarifas", "articulostarifas"];
      if (flfactppal.iface.pub_extension("subfamilias")) {
        oT.push("subfamilias");
      }
      if (flfactppal.iface.pub_extension("tallcol_barcode")) {
        oT = oT.concat(["grupostalla", "setstallas", "tallas", "colores", "temporadas", "gruposmoda", "annostc", "tiposprenda", "grupostc", "atributosarticulos"]);
      }
      break;
    }
    case "STOCKS": {
      oT = ["stocks"];
      break;
    }
    case "DEVOLUCIONES": {
      oT = ["tpv_comandas_devol"];
      break;
    }
    case "INVENTARIOS": {
      oT = ["lineasregstocks"];
      break;
    }
    case "TABLAS_BASE": {
      oT = ["empresa", "ejercicios", "series", "formaspago", "factalma_general", "impuestos", "familias", "almacenes", "tarifas", "flgroups", "flusers", "usuarios", "tpv_datosgenerales", "tpv_tiendas", "tpv_almacenestienda", "tpv_puntosventa", "tpv_agentes", "tpv_tarjetaspago"];
      break;
    }
    case "TPV_ENVIO_MULTITRANS": {
      oT = ["tpv_envio_viajes", "tpv_envio_multitrans"];
      break;
    }
    case "TPV_RECEPCION_MULTITRANS": {
      oT = ["tpv_recepcion_viajes", "tpv_recepcion_multitrans"];
      break;
    }
    case "TX_CLIENTES": {
      oT = ["clientes", "dirclientes"];
      break;
    }
    case "RX_CLIENTES": {
      oT = ["tpv_comandas_cli"];
      break;
    }
    case "CUSTOM": {
      if ("masParam" in _i.paramSincro_) {
        var lista = _i.paramSincro_.masParam;
        oT = lista.split(",");
      } else {
        return false;
      }
      break;
    }
    default: {
      oT = _i.__dameOrdenTablas(esquema);
      break;
    }
  }
  return oT;
}

function sincrotpv_dameDatosTabla(t, esquema)
{
  var _i = this.iface;
  var _pS = _i.paramSincro_;
  var oT;
  switch (t) {
    case "clientes": {
      oT = _i.dameElementoSincro(t);
      oT.tabla = t;
      oT.camposEx = ["codsubcuenta"];
      oT.filtro = "sincrotpv";
      break;
    }
    case "dirclientes": {
      oT = _i.dameElementoSincro(t);
      oT.tabla = t;
      oT.filtro = "codcliente IN (SELECT codcliente FROM clientes WHERE sincrotpv)";
      break;
    }
    case "articulos":
    case "tarifas":
    case "articulostarifas": {
      oT = _i.dameElementoSincro(t);
      oT.tabla = t;
      oT.filtro = _i.filtroFechas(t);
      break;
    }
    case "tpv_arqueos": {
      oT = _i.dameElementoSincro(t);
      oT.tabla = t;
      oT.reverse = true;
      var w = "NOT sincronizado";
      if (flfactppal.iface.pub_extension("tpv_multitienda")) {
        if (!_i.paramSincro_.codTienda) {
          return false;
        }
        w += " AND codtienda = '" + _i.paramSincro_.codTienda + "'";
      }
      oT.filtro = _i.filtroLista(oT.tabla, w, false, oT.reverse);
      if (!oT.filtro) {
        return false;
      }
      oT.camposEx = ["idasiento", "nogenerarasiento", "sincronizado", "abierta"];
      break;
    }
    case "tpv_comandas": {
      oT = _i.dameElementoSincro(t);
      oT.tabla = t;
      oT.clave = ["codigo"];
      oT.reverse = true;
      var w = "NOT sincronizada AND tipodoc <> 'PRESUPUESTO'";
      if (flfactppal.iface.pub_extension("tpv_multitienda")) {
        if (!_i.paramSincro_.codTienda) {
          return false;
        }
        /// w += " AND codtienda = '" + _i.paramSincro_.codTienda + "'"; No porque queremos también recibir las devoluciones originadas en otras tiendas
      }
      oT.filtro = _i.filtroLista(oT.tabla, w, "codigo", oT.reverse);
      if (!oT.filtro) {
        return false;
      }
      _i.filtroComandasActual_ = oT.filtro;
      oT.camposEx = ["idtpv_comanda", "idfactura", "abierta", "ptepuntos", "ptesaldo", "saldonosincro"];
      oT.camposCalcInsert = ["ptepuntos", "ptesaldo"];
      oT.camposCalcEdit = ["ptepuntos", "ptesaldo", "saldonosincro"];
      break;
    }
    case "tpv_comandas_cli": {
      oT = _i.dameElementoSincro(t);
      oT.tabla = "tpv_comandas";
      oT.clave = ["codigo"];
      oT.reverse = true;
      oT.borradoOff = true;
      var w = "ptesincrocli";
      if (flfactppal.iface.pub_extension("tpv_multitienda")) {
        if (!_i.paramSincro_.codTienda) {
          return false;
        }
      }
      oT.filtro = _i.filtroLista(oT.tabla, w, "codigo", oT.reverse);
      if (!oT.filtro) {
        return false;
      }
      _i.filtroComandasActual_ = oT.filtro;
      oT.campos = ["ptesincrocli", "codcliente", "nombrecliente", "cifnif", "direccion", "ciudad", "codpostal", "provincia", "codpais"];
      break;
    }
    case "tpv_comandas_devol": {
      oT = _i.dameElementoSincro(t);
      oT.tabla = "tpv_comandas";
      oT.clave = ["codigo"];
      oT.borradoOff = true;
      var q = new AQSqlQuery("", _i.conOrigen_);
      q.setSelect("c.codigo");
      q.setFrom("tpv_comandas c INNER JOIN tpv_sincrodevoltienda sdt ON c.idtpv_comanda = sdt.idtpv_comanda");
      q.setWhere("sdt.codtienda = '" + _pS.curTienda.valueBuffer("codtienda") + "' AND NOT sdt.sincronizado");
      if (!q.exec()) {
        return false;
      }
      var l = [];
      while (q.next()) {
        l.push("'" + q.value("c.codigo") + "'");
      }
      oT.filtro = l.length > 0 ? ("codigo IN (" + l.join(", ") + ")") : "(1 = 2)";
      _i.filtroComandasActual_ = oT.filtro;
      oT.camposEx = ["idtpv_comanda", "idfactura", "abierta", "ptepuntos", "sincronizada"];
      oT.camposCalcInsert = ["sincronizada"];
      break;
    }
    case "tpv_lineascomanda": {
      oT = _i.dameElementoSincro(t);
      oT.tabla = t;
      oT.clave = ["idsincro"];
      oT.reverse = true;
      oT.filtro = _i.filtroListaLineasComanda();
      if (!oT.filtro) {
        return false;
      }
      oT.camposEx = ["idtpv_linea", "idtpv_comanda", "ptestock"];
      oT.camposCalcInsert = ["idtpv_comanda", "ptestock"];
      oT.camposCalcEdit = ["ptestock"];
      break;
    }
    case "tpv_pagoscomanda": {
      oT = _i.dameElementoSincro(t);
      oT.tabla = t;
      oT.reverse = true;
      oT.clave = ["idsincro"];
      /// Llevar a elganso
      if (!_i.paramSincro_.codTienda) {
        return false;
      }
      //oT.filtro = _i.filtroLista(oT.tabla, "codtienda = '" + _i.paramSincro_.codTienda + "' AND NOT sincronizado", false, oT.reverse);
      oT.filtro = _i.filtroListaPagosComanda();
      if (!oT.filtro) {
        return false;
      }
      oT.camposEx = ["idpago", "idtpv_comanda", "idasiento", "nogenerarasiento", "ptepuntos", "editable"];
      oT.camposCalcInsert = ["idtpv_comanda", "ptepuntos"];
      oT.camposCalcEdit = ["ptepuntos"];
      break;
    }
    case "stocks": {
      oT = _i.dameElementoSincro(t);
      oT.tabla = t;
      oT.clave = ["idsincro"];
      if (!("sincroTotal" in _i.paramSincro_) || (!_i.paramSincro_.sincroTotal)) {
        var q = new AQSqlQuery;
        q.setSelect("s.idsincro");
        q.setFrom("stocks s INNER JOIN sincrostockstienda sst ON s.idstock = sst.idstock");
        q.setWhere("sst.codtienda = '" + _pS.curTienda.valueBuffer("codtienda") + "' AND NOT sst.sincronizado");
        if (!q.exec()) {
          return false;
        }
        var l = [];
        while (q.next()) {
          l.push(q.value("s.idsincro"));
        }
        oT.filtro = (l.length > 0) ? ("idsincro IN ('" + l.join("', '") + "')") : "(1 = 2)";
      }
      oT.camposEx = ["idstock", "fechaultreg", "horaultreg", "cantidadultreg"];
      oT.camposCalcInsert = ["fechaultreg", "horaultreg", "cantidadultreg"];
      oT.camposCalcEdit = ["fechaultreg", "horaultreg", "cantidadultreg"];
      break;
    }
    case "tpv_datosgenerales": {
      oT = _i.dameElementoSincro(t);
      oT.tabla = t;
      oT.camposEx = ["tiendasincro"];
      oT.camposCalcInsert = ["tiendasincro"];
      oT.camposCalcEdit = ["tiendasincro"];
      break;
    }
    case "lineasregstocks": {
      oT = _i.dameElementoSincro(t);
      oT.tabla = t;
      oT.clave = ["idsincro"];
      oT.reverse = true;
      var q = new FLSqlQuery("", _i.conDestino_);
      q.setSelect("l.idsincro");
      q.setFrom("lineasregstocks l INNER JOIN stocks s ON l.idstock = s.idstock");
      q.setWhere("NOT l.sincronizado");
      if (!q.exec()) {
        return false;
      }
      var l = [];
      while (q.next()) {
        l.push("'" + q.value("l.idsincro") + "'");
      }
      oT.filtro = l.length > 0 ? ("idsincro IN (" + l.join(", ") + ")") : "(1 = 2)";
      oT.camposEx = ["id", "idstock, ptecalculo", "sincronizado"];
      oT.camposCalcInsert = ["idstock", "ptecalculo"];
      oT.camposCalcEdit = ["idstock", "ptecalculo"];
      break;
    }
    case "tpv_envio_multitrans": { /// Envío se refiere a que es CENTRAL->Tienda, rx es porque se envían recepciones pendientes en tienda
      oT = _i.dameElementoSincro(t);
      oT.tabla = "tpv_lineasmultitransstock";
      oT.clave = ["idsincro"];
      var q = new FLSqlQuery("", _i.conOrigen_);
      q.setSelect("lm.idsincro");
      q.setFrom("tpv_lineasmultitransstock lm INNER JOIN tpv_viajesmultitransstock v ON lm.idviajemultitrans = v.idviajemultitrans");
      q.setWhere("((lm.rxtienda = 'PTE' AND lm.codalmadestino = '" + _pS.curTienda.valueBuffer("codalmacen") + "' AND v.estado NOT IN ('PTE ENVIO', 'ENVIADO PARCIAL') AND v.ptesincroenvio) OR (lm.extienda = 'PTE' AND lm.codalmaorigen = '" + _pS.curTienda.valueBuffer("codalmacen") + "'))");
      if (!q.exec()) {
        return false;
      }
      var l = [];
      while (q.next()) {
        l.push("'" + q.value("lm.idsincro") + "'");
      }
      oT.filtro = l.length > 0 ? ("idsincro IN (" + l.join(", ") + ")") : "(1 = 2)";
      oT.camposEx = ["idlinea", "codmultitransstock", "cantrecibida"];
      oT.camposExEdit = ["estado", "codagenterx", "fecharx", "horarx", "cerradorx"];
      break;
    }
    case "tpv_envio_viajes": {
      oT = _i.dameElementoSincro(t);
      oT.tabla = "tpv_viajesmultitransstock";
      var q = new FLSqlQuery("", _i.conOrigen_);
      q.setSelect("v.idviajemultitrans");
      q.setFrom("tpv_lineasmultitransstock lm INNER JOIN tpv_viajesmultitransstock v ON lm.idviajemultitrans = v.idviajemultitrans");
      q.setWhere("((lm.rxtienda = 'PTE' AND lm.codalmadestino = '" + _pS.curTienda.valueBuffer("codalmacen") + "' AND v.estado NOT IN ('PTE ENVIO', 'ENVIADO PARCIAL') AND v.ptesincroenvio) OR (lm.extienda = 'PTE' AND lm.codalmaorigen = '" + _pS.curTienda.valueBuffer("codalmacen") + "')) GROUP BY v.idviajemultitrans");
      if (!q.exec()) {
        return false;
      }
      var l = [];
      while (q.next()) {
        l.push("'" + q.value("v.idviajemultitrans") + "'");
      }
      //        q.setSelect("idviajemultitrans");
      //         q.setFrom("tpv_lineasmultitransstock");
      //         q.setWhere("(rxtienda = 'PTE' AND codalmadestino = '" + _pS.curTienda.valueBuffer("codalmacen") + "') OR (extienda = 'PTE' AND codalmaorigen = '" + _pS.curTienda.valueBuffer("codalmacen") + "') GROUP BY idviajemultitrans");
      //         if (!q.exec()) {
      //           return false;
      //        }
      //        var l = [];
      //        while (q.next()) {
      //          l.push("'" + q.value("idviajemultitrans") + "'");
      //        }
      oT.filtro = l.length > 0 ? ("idviajemultitrans IN (" + l.join(", ") + ")") : "(1 = 2)";
      _i.filtroExViajes_ = oT.filtro;
      oT.camposEx = ["codmultitransstock", "ptesincroenvio"];
      break;
    }
    case "tpv_recepcion_multitrans": { /// Es posible que se dé que mientras leen barcode se realiza una actualización automática y se borre lo hecho. ver posibilidad de hacerlo manual desde tiendas
      oT = _i.dameElementoSincro(t);
      oT.tabla = "tpv_lineasmultitransstock";
      oT.reverse = true;
      oT.clave = ["idsincro"];
      //         var q = new FLSqlQuery("", _i.conDestino_);
      //         q.setSelect("idsincro");
      //         q.setFrom("tpv_lineasmultitransstock");
      //         q.setWhere("(rxtienda = 'OK' AND rxcentral = 'PTE' AND codalmadestino = '" + _pS.curTienda.valueBuffer("codalmacen") + "') OR (extienda = 'OK' AND excentral = 'PTE' AND codalmaorigen = '" + _pS.curTienda.valueBuffer("codalmacen") + "')");
      //         if (!q.exec()) {
      //           return false;
      //         }
      //         var l = [];
      //         while (q.next()) {
      //           l.push("'" + q.value("idsincro") + "'");
      //         }
      var q = new FLSqlQuery("", _i.conDestino_);
      q.setSelect("lm.idsincro");
      q.setFrom("tpv_lineasmultitransstock lm INNER JOIN tpv_viajesmultitransstock v ON lm.idviajemultitrans = v.idviajemultitrans");
      q.setWhere("((lm.rxtienda = 'OK' AND lm.rxcentral = 'PTE' AND lm.codalmadestino = '" + _pS.curTienda.valueBuffer("codalmacen") + "' ) OR (lm.extienda = 'OK' AND lm.excentral = 'PTE' AND lm.codalmaorigen = '" + _pS.curTienda.valueBuffer("codalmacen") + "' AND v.estado NOT IN ('PTE ENVIO', 'ENVIADO PARCIAL') AND v.ptesincroenvio))");
      if (!q.exec()) {
        return false;
      }
      var l = [];
      while (q.next()) {
        l.push("'" + q.value("lm.idsincro") + "'");
      }
      oT.filtro = l.length > 0 ? ("idsincro IN (" + l.join(", ") + ")") : "(1 = 2)";
      oT.camposEx = ["idlinea", "codmultitransstock", "rxcentral", "ptestockrx", "excentral", "ptestockex"];
      oT.camposCalcInsert = ["rxcentral", "ptestockrx", "excentral", "ptestockex"];
      oT.camposCalcEdit = ["rxcentral", "ptestockrx", "excentral", "ptestockex"];
      break;
    }
    case "tpv_recepcion_viajes": {
      oT = _i.dameElementoSincro(t);
      oT.tabla = "tpv_viajesmultitransstock";
      oT.reverse = true;
      //         var q = new FLSqlQuery("", _i.conDestino_);
      //         q.setSelect("idviajemultitrans");
      //         q.setFrom("tpv_lineasmultitransstock");
      //         q.setWhere("(rxtienda = 'OK' AND rxcentral = 'PTE' AND codalmadestino = '" + _pS.curTienda.valueBuffer("codalmacen") + "') OR (extienda = 'OK' AND excentral = 'PTE' AND codalmaorigen = '" + _pS.curTienda.valueBuffer("codalmacen") + "') GROUP BY idviajemultitrans");
      //         if (!q.exec()) {
      //           return false;
      //        }
      //        var l = [];
      //        while (q.next()) {
      //          l.push("'" + q.value("idviajemultitrans") + "'");
      //        }
      var q = new FLSqlQuery("", _i.conDestino_);
      q.setSelect("v.idviajemultitrans");
      q.setFrom("tpv_lineasmultitransstock lm INNER JOIN tpv_viajesmultitransstock v ON lm.idviajemultitrans = v.idviajemultitrans");
      q.setWhere("((lm.rxtienda = 'OK' AND lm.rxcentral = 'PTE' AND lm.codalmadestino = '" + _pS.curTienda.valueBuffer("codalmacen") + "' ) OR (lm.extienda = 'OK' AND lm.excentral = 'PTE' AND lm.codalmaorigen = '" + _pS.curTienda.valueBuffer("codalmacen") + "' AND v.estado NOT IN ('PTE ENVIO', 'ENVIADO PARCIAL') AND v.ptesincroenvio)) GROUP BY v.idviajemultitrans");
      debug(q.sql());
      if (!q.exec()) {
        return false;
      }
      var l = [];
      while (q.next()) {
        l.push("'" + q.value("v.idviajemultitrans") + "'");
      }
      oT.filtro = l.length > 0 ? ("idviajemultitrans IN (" + l.join(", ") + ")") : "(1 = 2)";
      _i.filtroRxViajes_ = oT.filtro;
      oT.camposEx = ["codmultitransstock"];
      break;
    }
    case "tpv_puntosventa": {
      oT = _i.dameElementoSincro(t);
      oT.tabla = t;
      oT.camposEx = ["codtpv_agente"]; /// El agente se cambia localmente en cada tienda
      break;
    }

    default: {
      oT = _i.__dameDatosTabla(t, esquema);
    }
  }
  return oT;
}

/// Pasar a sincrotpv_catalogo
/** Elabora una sentenca WHERE campoid IN (lista) con los campos identificativos de una tabla que cumplen un determinado filtro
  @param t: Tabla
  @param w: Filtro
  @param reverse: Indica si hay que conectar a origen (false) o a destino (true)
  @param campoId: Campo identificativo de la tabla. Si no está informado se toma la clave primaria.
  */
function sincrotpv_filtroLista(t, w, campoId, reverse)
{
  var _i = this.iface;

  var mtd = _i.mgr_.metadata(t);
  var pK = campoId ? campoId : mtd.primaryKey();
  var mtdPK = mtd.field(pK);
  if (!mtdPK) {
    return false;
  }

  var q;
  if (reverse) {
    if (!_i.conDestino_) {
      return false;
    }
    q = new FLSqlQuery("", _i.conDestino_);
  } else {
    if (!_i.conOrigen_) {
      return false;
    }
    q = new FLSqlQuery("", _i.conOrigen_);
  }
  q.setSelect(pK);
  q.setFrom(t);
  q.setWhere(w);
  if (!q.exec()) {
    return false;
  }
  var l = "";
  while (q.next()) {
    l += l != "" ? ", " : "";
    if (mtdPK.type() == _i.tSTRING_) {
      l += ("'" + q.value(pK) + "'");
    } else {
      l += q.value(pK);
    }
  }
  var filtro;
  if (l == "") {
    filtro = "(1 = 2)";
  } else {
    filtro = pK + " IN (" + l + ")";
  }
  return filtro;
}

function sincrotpv_filtroListaLineasComanda()
{
  var _i = this.iface;

  var pK = "lc.idsincro";
  var reverse = true;

  var q;
  if (reverse) {
    if (!_i.conDestino_) {
      return false;
    }
    q = new FLSqlQuery("", _i.conDestino_);
  } else {
    if (!_i.conOrigen_) {
      return false;
    }
    q = new FLSqlQuery("", _i.conOrigen_);
  }
  var w = "NOT c.sincronizada AND c.tipodoc <> 'PRESUPUESTO'";
  if (flfactppal.iface.pub_extension("tpv_multitienda")) {
    if (!_i.paramSincro_.codTienda) {
      return false;
    }
    w += " AND c.codtienda = '" + _i.paramSincro_.codTienda + "'";
  }

  q.setSelect(pK);
  q.setFrom("tpv_comandas c INNER JOIN tpv_lineascomanda lc ON c.idtpv_comanda = lc.idtpv_comanda");
  q.setWhere(w);
  if (!q.exec()) {
    return false;
  }
  var l = "";
  while (q.next()) {
    l += l != "" ? ", " : "";
    l += ("'" + q.value(pK) + "'");
  }
  var filtro;
  if (l == "") {
    filtro = "(1 = 2)";
  } else {
    filtro = "idsincro IN (" + l + ")";
  }
  return filtro;
}

function sincrotpv_filtroListaPagosComanda()
{
  var _i = this.iface;

  var pK = "pc.idsincro";
  var reverse = true;

  var q;
  if (reverse) {
    if (!_i.conDestino_) {
      return false;
    }
    q = new FLSqlQuery("", _i.conDestino_);
  } else {
    if (!_i.conOrigen_) {
      return false;
    }
    q = new FLSqlQuery("", _i.conOrigen_);
  }
  var w = "NOT c.sincronizada";
  if (flfactppal.iface.pub_extension("tpv_multitienda")) {
    if (!_i.paramSincro_.codTienda) {
      return false;
    }
    w += " AND c.codtienda = '" + _i.paramSincro_.codTienda + "'";
  }
  q.setSelect(pK);
  q.setFrom("tpv_comandas c INNER JOIN tpv_pagoscomanda pc ON c.idtpv_comanda = pc.idtpv_comanda");
  q.setWhere(w);
  if (!q.exec()) {
    return false;
  }
  var l = "";
  while (q.next()) {
    l += l != "" ? ", " : "";
    l += ("'" + q.value(pK) + "'");
  }
  var filtro;
  if (l == "") {
    filtro = "(1 = 2)";
  } else {
    filtro = "idsincro IN (" + l + ")";
  }
  return filtro;
}

function sincrotpv_ponTiendaActual(oParam)
{
  var _i = this.iface;
  _i.paramSincro_ = oParam;
  //  _i.idEmpresaActual_ = AQUtil.sqlSelect("tpv_tiendas", "idempresa", "codtienda = '" + _i.paramSincro_.codTienda + "'");
}

function sincrotpv_filtroFechas(t)
{
  var _i = this.iface;
  if (!("filtroFecha" in _i.paramSincro_)) {
    return "(1 = 1)";
  }
  if (!_i.paramSincro_.filtroFecha) {
    return "(1 = 1)";
  }

  var mtd = _i.mgr_.metadata(t);
  var pK = mtd.primaryKey();
  var mtdPK = mtd.field(pK);

  var q = _i.conOrigen_ ? new FLSqlQuery() : new FLSqlQuery("", _i.conOrigen_);
  q.setSelect(pK);
  q.setFrom(t);
  q.setWhere("fechamod >= '" + _i.paramSincro_.filtroFecha + "'");
  if (!q.exec()) {
    return false;
  }
  var l = "";
  while (q.next()) {
    l += l != "" ? ", " : "";
    if (mtdPK.type() == _i.tSTRING_) {
      l += ("'" + q.value(pK) + "'");
    } else {
      l += q.value(pK);
    }
  }
  var filtro;
  if (l == "") {
    filtro = "(1 = 2)";
  } else {
    filtro = pK + " IN (" + l + ")";
  }
  return filtro;
}

function sincrotpv_afterSincronizarTabla(oTabla, aResultados, silent)
{
  var _i = this.iface;
  switch (oTabla.nombre) {
    case "tpv_arqueos": {
      if (!_i.marcarArqueosSincro(oTabla, aResultados, silent)) {
        return false;
      }
      break;
    }
    case "tpv_comandas": {
      if (!_i.afterSincComandas(oTabla, aResultados, silent)) {
        return false;
      }
      break;
    }
    case "tpv_comandas_cli": {
      if (!_i.afterSincComandasCli(oTabla, aResultados, silent)) {
        return false;
      }
      break;
    }
    case "tpv_comandas_devol": {
      if (!_i.afterSincComandasDevol(oTabla, aResultados, silent)) {
        return false;
      }
      break;
    }
    case "tpv_lineascomanda": {
      if (!_i.afterSincLineasComanda(oTabla, aResultados, silent)) {
        return false;
      }
      break;
    }
    case "tpv_pagoscomanda": {
      if (!_i.afterSincPagosComanda(oTabla, aResultados, silent)) {
        return false;
      }
      break;
    }
    case "stocks": {
      if (!_i.afterSincStocks(oTabla, aResultados, silent)) {
        return false;
      }
      break;
    }
    case "lineasregstocks": {
      if (!_i.afterSincRegStock(oTabla, aResultados, silent)) {
        return false;
      }
      break;
    }
    case "tpv_recepcion_multitrans": {
      if (!_i.afterSincRxMultitrans(oTabla, aResultados, silent)) {
        return false;
      }
      break;
    }
    case "tpv_recepcion_viajes": {
      if (!_i.afterSincRxViajes(oTabla, aResultados, silent)) {
        return false;
      }
      break;
    }
    case "tpv_envio_multitrans": {
      if (!_i.afterSincExMultitrans(oTabla, aResultados, silent)) {
        return false;
      }
      break;
    }
    case "tpv_envio_viajes": {
      //      if (!_i.afterSincExMultitrans(oTabla, aResultados, silent)) {
      //         return false;
      //       }
      break;
    }
    default: {
      if (!_i.__afterSincronizarTabla(oTabla, aResultados, silent)) {
        return false;
      }
    }
  }
  return true;
}

function sincrotpv_afterSincPagosComanda(oTabla, aResultados, silent)
{
  var _i = this.iface;

  /// Se pone aquí porque los saldos se calculan despues de cargar los pagos con vale
  if (!_i.controlDevolComandasSinc(oTabla, aResultados, silent)) {
    return false;
  }

  if (flfactppal.iface.pub_extension("puntos_tpv")) {
    if (!_i.controlPuntosPagosComandaSinc(oTabla, aResultados, silent)) {
      return false;
    }
  }

  /// Esto puede moverse al proceso que genere las facturas de los arqueos y las facturas a clientes y rectificativas
  if (!_i.controlClientesComanda(oTabla, aResultados, silent)) {
    return false;
  }

  /// Esta llamada debe ser la última de todas las tablas sincronizadas que tienen que ver con comandas con sincronizada = false
  if (!_i.marcarComandasSincro(oTabla, aResultados, silent)) {
    return false;
  }
  return true;
}

function sincrotpv_afterSincRxMultitrans(oTabla, aResultados, silent)
{
  var _i = this.iface;

  if (!_i.controlStockMultiSinc(oTabla, aResultados, silent)) {
    return false;
  }
  if (!_i.controlViajeMultitrans(oTabla, aResultados, silent)) {
    return false;
  }
  if (!_i.controlLineasRxTienda(oTabla, aResultados, silent)) {
    return false;
  }
  if (!_i.controlRxViajeTienda(oTabla, aResultados, silent)) {
    return false;
  }

  return true;
}

function sincrotpv_afterSincExMultitrans(oTabla, aResultados, silent)
{
  var _i = this.iface;

  if (!_i.controlExViajeMultitrans(oTabla, aResultados, silent)) {
    return false;
  }

  return true;
}

function sincrotpv_afterSincRxViajes(oTabla, aResultados, silent)
{
  var _i = this.iface;



  return true;
}



function sincrotpv_controlStockMultiSinc(oTabla, aResultados, silent)
{
  var _i = this.iface;
  var curP = new FLSqlCursor("tpv_lineasmultitransstock", _i.conOrigen_);
  curP.setActivatedCheckIntegrity(false);
  curP.setActivatedCommitActions(false);

  curP.select(oTabla.filtro + " AND (ptestockrx OR ptestockex)");
  while (curP.next()) {
    curP.setModeAccess(curP.Edit);
    curP.refreshBuffer();
    if (!_i.controlStockMultitrans(curP)) {
      return false;
    }
    curP.setValueBuffer("ptestockex", false);
    curP.setValueBuffer("ptestockrx", false);
    if (!curP.commitBuffer()) {
      return false;
    }
  }
  return true;
}

function sincrotpv_controlViajeMultitrans(oTabla, aResultados, silent)
{
  var _i = this.iface;
  var curP = new FLSqlCursor("tpv_lineasmultitransstock", _i.conOrigen_);
  curP.setActivatedCheckIntegrity(false);
  curP.setActivatedCommitActions(false);

  curP.select(oTabla.filtro);
  while (curP.next()) {
    curP.setModeAccess(curP.Edit);
    curP.refreshBuffer();
    if (!flfact_tpv.iface.pub_comprobarViaje(curP)) {
      return false;
    }
    if (!curP.commitBuffer()) {
      return false;
    }
  }
  return true;
}

function sincrotpv_controlLineasRxTienda(oTabla, aResultados, silent)
{
  var _i = this.iface;
  if (!AQUtil.execSql("UPDATE tpv_lineasmultitransstock SET rxcentral = 'OK' WHERE " + oTabla.filtro + " AND rxtienda = 'OK'", _i.conDestino_)) {
    return false;
  }
  return true;
}

function sincrotpv_controlRxViajeTienda(oTabla, aResultados, silent)
{
  var _i = this.iface;
  if (!AQUtil.execSql("UPDATE tpv_viajesmultitransstock SET ptesincroenvio = false WHERE " + _i.filtroRxViajes_ + " AND ptesincroenvio", _i.conDestino_)) {
    return false;
  }
  return true;
}


function sincrotpv_controlExViajeMultitrans(oTabla, aResultados, silent)
{
  var _i = this.iface;
  var curP = new FLSqlCursor("tpv_viajesmultitransstock", _i.conOrigen_);
  curP.setActivatedCheckIntegrity(false);
  curP.setActivatedCommitActions(false);

  curP.select(_i.filtroExViajes_);
  while (curP.next()) {
    curP.setModeAccess(curP.Edit);
    curP.refreshBuffer();
    curP.setValueBuffer("ptesincroenvio", false);
    if (!curP.commitBuffer()) {
      return false;
    }
  }
  return true;
}

function sincrotpv_controlPuntosPagosComandaSinc(oTabla, aResultados, silent)
{
  var _i = this.iface;
  var curP = new FLSqlCursor("tpv_pagoscomanda");
  curP.setActivatedCheckIntegrity(false);
  curP.setActivatedCommitActions(false);

  curP.select(_i.filtroPuntosPagoSinc());
  while (curP.next()) {
    curP.setModeAccess(curP.Edit);
    curP.refreshBuffer();
    if (!flfact_tpv.iface.pub_gestionPuntosPago(curP)) {
      return false;
    }
    curP.setValueBuffer("ptepuntos", false);
    if (!curP.commitBuffer()) {
      return false;
    }
  }
  return true;
}

function sincrotpv_filtroPuntosPagoSinc()
{
  var _i = this.iface;
  var f = "ptepuntos";
  if (flfactppal.iface.pub_extension("tpv_multitienda")) {
    f += " AND codtienda = '" + _i.paramSincro_.codTienda + "'";
  }
  return f;
}

function sincrotpv_afterSincComandas(oTabla, aResultados, silent)
{
  var _i = this.iface;

  if (flfactppal.iface.pub_extension("puntos_tpv")) {
    if (!_i.controlPuntosComandasSinc(oTabla, aResultados, silent)) {
      return false;
    }
  }

  return true;
}

function sincrotpv_afterSincComandasCli(oTabla, aResultados, silent)
{
  var _i = this.iface;

  if (!_i.controlClientesComanda(oTabla, aResultados, silent)) {
    return false;
  }
  if (!_i.marcarComandasSincroCli(oTabla, aResultados, silent)) {
    return false;
  }
  return true;
}

function sincrotpv_afterSincStocks(oTabla, aResultados, silent)
{
  var _i = this.iface;

  if (!_i.marcaStocksSincro(oTabla, aResultados, silent)) {
    return false;
  }

  return true;
}

function sincrotpv_afterSincRegStock(oTabla, aResultados, silent)
{
  var _i = this.iface;

  if (!_i.calculaRegStockSincro(oTabla, aResultados, silent)) {
    return false;
  }
  if (!_i.marcarRegStockSincro(oTabla, aResultados, silent)) {
    return false;
  }

  return true;
}

function sincrotpv_marcaStocksSincro(oTabla, aResultados, silent)
{
  var _i = this.iface;
  var _pS = _i.paramSincro_;

  var curSST = new FLSqlCursor("sincrostockstienda");
  curSST.setActivatedCheckIntegrity(false);
  curSST.setActivatedCommitActions(false);

  curSST.select("codtienda = '" + _pS.curTienda.valueBuffer("codtienda") + "'");
  while (curSST.next()) {
    curSST.setModeAccess(curSST.Edit);
    curSST.refreshBuffer();
    curSST.setValueBuffer("sincronizado", true);
    if (!curSST.commitBuffer()) {
      return false;
    }
  }
  return true;
}

function sincrotpv_calculaRegStockSincro(oTabla, aResultados, silent)
{
  var _i = this.iface;
  var _pS = _i.paramSincro_;

  var curL = new FLSqlCursor("lineasregstocks", _i.conOrigen_);
  curL.setActivatedCheckIntegrity(false);
  curL.setActivatedCommitActions(false);

  var curStock = new FLSqlCursor("stocks", _i.conOrigen_);
  var cF = formRecordregstocks.iface.pub_commonCalculateField;
  curL.select("ptecalculo = true");
  while (curL.next()) {
    curL.setModeAccess(curL.Edit);
    curL.refreshBuffer();
    curStock.select("idstock = " + curL.valueBuffer("idstock"));
    if (!curStock.first()) {
      return false;
    }
    curStock.setModeAccess(curStock.Edit);
    curStock.refreshBuffer();

    var fechaUltReg = cF("fechaultreg", curStock);
    if (fechaUltReg) {
      curStock.setValueBuffer("fechaultreg", fechaUltReg);
      curStock.setValueBuffer("horaultreg", cF("horaultreg", curStock));
      curStock.setValueBuffer("cantidadultreg", cF("cantidadultreg", curStock));
    } else {
      curStock.setNull("fechaultreg");
      curStock.setNull("horaultreg");
      curStock.setValueBuffer("cantidadultreg", 0);
    }
    curStock.setValueBuffer("cantidad", cF("cantidad", curStock));
    curStock.setValueBuffer("disponible", cF("disponible", curStock));
    if (!curStock.commitBuffer()) {
      return false;
    }
    curL.setValueBuffer("ptecalculo", false);
    curL.setValueBuffer("sincronizado", true);
    if (!curL.commitBuffer()) {
      return false;
    }
  }
  return true;
}

function sincrotpv_marcarRegStockSincro(oTabla, aResultados, silent)
{
  var _i = this.iface;
  var curL = new FLSqlCursor("lineasregstocks", _i.conDestino_);
  curL.setActivatedCheckIntegrity(false);
  curL.setActivatedCommitActions(false);

  curL.select(oTabla.filtro);
  while (curL.next()) {
    curL.setModeAccess(curL.Edit);
    curL.refreshBuffer();
    curL.setValueBuffer("sincronizado", true);
    if (!curL.commitBuffer()) {
      return false;
    }
  }
  return true;
}

function sincrotpv_afterSincComandasDevol(oTabla, aResultados, silent)
{
  var _i = this.iface;

  if (!_i.marcaDevolSincro(oTabla, aResultados, silent)) {
    return false;
  }

  return true;
}

function sincrotpv_marcaDevolSincro(oTabla, aResultados, silent)
{
  var _i = this.iface;
  var _pS = _i.paramSincro_;

  var curSST = new FLSqlCursor("tpv_sincrodevoltienda");
  curSST.setActivatedCheckIntegrity(false);
  curSST.setActivatedCommitActions(false);

  curSST.select("codtienda = '" + _pS.curTienda.valueBuffer("codtienda") + "'");
  while (curSST.next()) {
    curSST.setModeAccess(curSST.Edit);
    curSST.refreshBuffer();
    curSST.setValueBuffer("sincronizado", true);
    if (!curSST.commitBuffer()) {
      return false;
    }
  }
  return true;
}

function sincrotpv_controlPuntosComandasSinc(oTabla, aResultados, silent)
{
  var _i = this.iface;
  var curC = new FLSqlCursor("tpv_comandas");
  curC.setActivatedCheckIntegrity(false);
  curC.setActivatedCommitActions(false);

  curC.select(_i.filtroPuntosComandaSinc());
  while (curC.next()) {
    curC.setModeAccess(curC.Edit);
    curC.refreshBuffer();
    if (!flfact_tpv.iface.pub_gestionPuntos(curC)) {
      return false;
    }
    curC.setValueBuffer("ptepuntos", false);
    if (!curC.commitBuffer()) {
      return false;
    }
  }
  return true;
}

function sincrotpv_controlDevolComandasSinc(oTabla, aResultados, silent)
{
  var _i = this.iface;
  var curC = new FLSqlCursor("tpv_comandas");
  curC.setActivatedCheckIntegrity(false);
  curC.setActivatedCommitActions(false);

  var f = "ptesaldo";
  if (flfactppal.iface.pub_extension("tpv_multitienda")) {
    /// f += " AND codtienda = '" + _i.paramSincro_.codTienda + "'"; La devolución a procesar puede ser originaria de otra tienda
  }
  curC.select(f);
  while (curC.next()) {
    curC.setModeAccess(curC.Edit);
    curC.refreshBuffer();
    if (!_i.controlSincroDevolTiendas(curC)) {
      return false;
    }
    curC.setValueBuffer("saldoconsumido", formRecordtpv_comandas.iface.pub_commonCalculateField("saldoconsumido", curC));
    curC.setValueBuffer("saldopendiente", formRecordtpv_comandas.iface.pub_commonCalculateField("saldopendiente", curC));
    curC.setValueBuffer("ptesaldo", false);
    if (!curC.commitBuffer()) {
      return false;
    }
  }
  return true;
}

function sincrotpv_controlClientesComanda(oTabla, aResultados, silent)
{
  var _i = this.iface;
  var curC = new FLSqlCursor("tpv_comandas");
  curC.setActivatedCheckIntegrity(false);
  curC.setActivatedCommitActions(false);

  var f = "ptesincrocli";
  curC.select(f);
  while (curC.next()) {
    curC.setModeAccess(curC.Edit);
    curC.refreshBuffer();
    if (!_i.sincronizaClienteComanda(curC)) {
      return false;
    }
    curC.setValueBuffer("ptesincrocli", false);
    if (!curC.commitBuffer()) {
      return false;
    }
  }
  return true;
}

function sincrotpv_sincronizaClienteComanda(curC)
{
  debug("sincrotpv_sincronizaClienteComanda " + curC.valueBuffer("codigo"));
  var _i = this.iface;
  var codCliente = curC.valueBuffer("codcliente");
  var cifNif = curC.valueBuffer("cifnif");
  var curCliente = new FLSqlCursor("clientes");
  if (codCliente && codCliente != "") {
    codCliente = AQUtil.sqlSelect("clientes", "codcliente", "codcliente = '" + codCliente + "'");
  }
  if (!codCliente || codCliente == "") {
    codCliente = AQUtil.sqlSelect("clientes", "codcliente", "cifnif = '" + cifNif + "'");
  }
  if (codCliente && codCliente != "") {
    curCliente.select("codcliente = '" + codCliente + "'");
    if (!curCliente.first()) {
      return false;
    }
    curCliente.setModeAccess(curCliente.Edit);
    curCliente.refreshBuffer();
  } else {
    curCliente.setModeAccess(curCliente.Insert);
    curCliente.refreshBuffer();
    codCliente = formRecordclientes.iface.pub_obtenerCodigoCliente(curCliente);
    curCliente.setValueBuffer("codcliente", codCliente);
  }
  if (!_i.datosClienteComanda(curCliente, curC)) {
    return false;
  }
  if (!curCliente.commitBuffer()) {
    return false;
  }
  var codDir = AQUtil.sqlSelect("dirclientes", "id", "codcliente = '" + codCliente + "' AND domfacturacion");
  var curDC = new FLSqlCursor("dirclientes");
  if (codDir) {
    curDC.select("id = " + codDir);
    if (!curDC.first()) {
      return false;
    }
    curDC.setModeAccess(curDC.Edit);
    curDC.refreshBuffer();
  } else {
    curDC.setModeAccess(curDC.Insert);
    curDC.refreshBuffer();
  }
  if (!_i.datosDirClienteComanda(curDC, curCliente, curC)) {
    return false;
  }
  if (!curDC.commitBuffer()) {
    return false;
  }
  curC.setValueBuffer("codcliente", codCliente);
  return true;
}

function sincrotpv_datosClienteComanda(curCliente, curComanda)
{
  if (curCliente.modeAccess() == curCliente.Insert) {
    curCliente.setValueBuffer("codpago", flfactppal.iface.valorDefectoEmpresa("codpago"));
    curCliente.setValueBuffer("coddivisa", flfactppal.iface.valorDefectoEmpresa("coddivisa"));
    curCliente.setValueBuffer("codserie", flfactppal.iface.valorDefectoEmpresa("codserie"));
    curCliente.setValueBuffer("regimeniva", "General");
    var codEjercicio = flfactppal.iface.pub_ejercicioActual();
    var longSubcuenta = AQUtil.sqlSelect("ejercicios", "longsubcuenta", "codejercicio = '" + codEjercicio + "'");
    curCliente.setValueBuffer("codsubcuenta", formRecordclientes.iface.calcularSubcuentaCli(curCliente, longSubcuenta));
  }
  curCliente.setValueBuffer("sincrotpv", true);
  curCliente.setValueBuffer("nombre", curComanda.valueBuffer("nombrecliente"));
  curCliente.setValueBuffer("cifnif", curComanda.valueBuffer("cifnif"));
  curCliente.setValueBuffer("nombre", curComanda.valueBuffer("nombrecliente"));
  curCliente.setValueBuffer("nombre", curComanda.valueBuffer("nombrecliente"));
  curCliente.setValueBuffer("nombre", curComanda.valueBuffer("nombrecliente"));
  return true;
}

function sincrotpv_datosDirClienteComanda(curDC, curCliente, curComanda)
{
  if (curDC.modeAccess() == curDC.Insert) {
    curDC.setValueBuffer("codcliente", curCliente.valueBuffer("codcliente"));
    curDC.setValueBuffer("domfacturacion", true);
    curDC.setValueBuffer("domenvio", true);
    curDC.setValueBuffer("descripcion", sys.translate("Dirección principal"));
  }
  curDC.setValueBuffer("direccion", curComanda.valueBuffer("direccion"));
  curDC.setValueBuffer("codpostal", curComanda.valueBuffer("codpostal"));
  curDC.setValueBuffer("ciudad", curComanda.valueBuffer("ciudad"));
  curDC.setValueBuffer("provincia", curComanda.valueBuffer("provincia"));
  curDC.setValueBuffer("codpais", curComanda.valueBuffer("codpais"));
  return true;
}

function sincrotpv_filtroPuntosComandaSinc()
{
  var _i = this.iface;
  var f = "ptepuntos";
  if (flfactppal.iface.pub_extension("tpv_multitienda")) {
    f += " AND codtienda = '" + _i.paramSincro_.codTienda + "'";
  }
  return f;
}

function sincrotpv_afterSincLineasComanda(oTabla, aResultados, silent)
{
  var _i = this.iface;

  if (!_i.controlStockSincLineasComanda(oTabla, aResultados, silent)) {
    return false;
  }
  return true;
}

function sincrotpv_controlStockSincLineasComanda(oTabla, aResultados, silent)
{
  var _i = this.iface;
  var curL = new FLSqlCursor("tpv_lineascomanda");
  curL.setActivatedCheckIntegrity(false);
  curL.setActivatedCommitActions(false);

  /// NOCHE. Cambiar select en elganso / multitienda para incluir tienda
  curL.select("ptestock");
  while (curL.next()) {
    curL.setModeAccess(curL.Edit);
    curL.refreshBuffer();
    if (!flfactalma.iface.pub_controlStockComandasCli(curL)) { /// Comprobar si se ejecuta en Edit sin nada cambiado respecto a bufferCopy
      debug("Falló pub_controlStockComandasCli para idsincro " + curL.valueBuffer("idsincro"));
      return false;
    }
    curL.setValueBuffer("ptestock", false);
    if (!curL.commitBuffer()) {
      debug("falló ptestock = false para idsincro " + curL.valueBuffer("idsincro"));
      return false;
    }
  }

  return true;
}

function sincrotpv_marcarArqueosSincro(oTabla, aResultados, silent)
{
  var _i = this.iface;
  var curArqueo = new FLSqlCursor("tpv_arqueos", _i.conDestino_);
  curArqueo.setActivatedCheckIntegrity(false);
  curArqueo.setActivatedCommitActions(false);

  curArqueo.select(oTabla.filtro);
  while (curArqueo.next()) {
    curArqueo.setModeAccess(curArqueo.Edit);
    curArqueo.refreshBuffer();
    if (curArqueo.valueBuffer("abierta")) {
      continue;
    } else {
      if (!AQUtil.execSql("UPDATE tpv_arqueos SET sincronizado = true WHERE idtpv_arqueo = '" + curArqueo.valueBuffer("idtpv_arqueo") + "'", _i.conOrigen_)) {
        return false;
      }
      if (!AQUtil.execSql("UPDATE tpv_arqueos SET sincronizado = true WHERE idtpv_arqueo = '" + curArqueo.valueBuffer("idtpv_arqueo") + "'", _i.conDestino_)) {
        return false;
      }
    }
  }
  return true;
}

function sincrotpv_marcarComandasSincro(oTabla, aResultados, silent)
{
  var _i = this.iface;
  var curComanda = new FLSqlCursor("tpv_comandas", _i.conDestino_);
  curComanda.setActivatedCheckIntegrity(false);
  curComanda.setActivatedCommitActions(false);

  var curComandaB = new FLSqlCursor("tpv_comandas", _i.conDestino_);
  curComandaB.setActivatedCheckIntegrity(false);
  curComandaB.setActivatedCommitActions(false);

  curComanda.select(_i.filtroComandasActual_);
  while (curComanda.next()) {
    curComanda.setModeAccess(curComanda.Edit);
    curComanda.refreshBuffer();
    if (curComanda.valueBuffer("editable") && curComanda.valueBuffer("estado") == "Cerrada") {
      curComanda.setValueBuffer("sincronizada", true);
      curComanda.setValueBuffer("ptesincrocli", false);
      if (!curComanda.commitBuffer()) {
        return false;
      }
    } else {
      curComanda.setValueBuffer("sincronizada", false);
      if (!curComanda.commitBuffer()) {
        return false;
      }
      /*
      curComandaB.select("idtpv_comanda = " + curComanda.valueBuffer("idtpv_comanda"));
      if (!curComandaB.first()) {
        return false;
      }
      curComandaB.setUnLock("abierta", true);
      curComandaB.select("idtpv_comanda = " + curComanda.valueBuffer("idtpv_comanda"));
      if (!curComandaB.first()) {
        return false;
      }
      curComandaB.setModeAccess(curComanda.Edit);
      curComandaB.refreshBuffer();
      curComandaB.setValueBuffer("sincronizada", true);
      curComandaB.setValueBuffer("editable", false);
      if (!curComandaB.commitBuffer()) {
        return false;
      }*/
    }
  }
  return true;
}

function sincrotpv_marcarComandasSincroCli(oTabla, aResultados, silent)
{
  var _i = this.iface;

  if (!AQUtil.execSql("UPDATE tpv_comandas SET ptesincrocli = false WHERE " + oTabla.filtro, _i.conDestino_)) {
    return false;
  }
  return true;
}

function sincrotpv_calculaCampoSincro(curDestino, oTabla, campo)
{
  var _i = this.iface;
  var valor;
  switch (oTabla.nombre) {
    case "tpv_lineascomanda": {
      switch (campo) {
        case "idtpv_comanda": {
          valor = AQUtil.quickSqlSelect("tpv_comandas", "idtpv_comanda", "codigo = '" + curDestino.valueBuffer("codcomanda") + "'");
          curDestino.setValueBuffer(campo, valor);
          break;
        }
        case "ptestock": {
          curDestino.setValueBuffer(campo, true);
          break;
        }
        default: {
          return _i.__calculaCampoSincro(curDestino, oTabla, campo);
        }
      }
      break;
    }
    case "tpv_comandas": {
      switch (campo) {
        case "ptepuntos": {
          curDestino.setValueBuffer(campo, true);
          break;
        }
        case "ptesaldo": {
          var saldo = curDestino.valueBuffer("saldopendiente");
          var total = curDestino.valueBuffer("total");
          var pte = false;
          if (total < 0) {
            if ((curDestino.modeAccess() == curDestino.Insert && saldo > 0) || (curDestino.modeAccess() == curDestino.Edit && curDestino.valueBufferCopy("saldopendiente") != saldo)) {
              pte = true;
            }
          }
          curDestino.setValueBuffer(campo, pte);
          break;
        }
        case "saldonosincro": {
          curDestino.setValueBuffer(campo, 0);
          break;
        }
        default: {
          return _i.__calculaCampoSincro(curDestino, oTabla, campo);
        }
      }
      break;
    }
    case "tpv_comandas_devol": {
      switch (campo) {
        case "sincronizada": { /// Solo debe ser llamada en modo insert
          curDestino.setValueBuffer(campo, true);
          break;
        }
        //         case "saldonosincro": {
        //           curDestino.setValueBuffer(campo, 0);
        //           break;
        //         }
        default: {
          return _i.__calculaCampoSincro(curDestino, oTabla, campo);
        }
      }
      break;
    }
    case "tpv_pagoscomanda": {
      switch (campo) {
        case "idtpv_comanda": {
          valor = AQUtil.quickSqlSelect("tpv_comandas", "idtpv_comanda", "codigo = '" + curDestino.valueBuffer("codcomanda") + "'");
          curDestino.setValueBuffer(campo, valor);
          break;
        }
        case "ptepuntos": {
          curDestino.setValueBuffer(campo, true);
          break;
        }
        default: {
          return _i.__calculaCampoSincro(curDestino, oTabla, campo);
        }
      }
      break;
    }
    case "lineasregstocks": {
      switch (campo) {
        case "ptecalculo": {
          curDestino.setValueBuffer(campo, true);
          break;
        }
        case "idstock": {
          var idStock = AQUtil.sqlSelect("stocks", "idstock", "idsincro = '" + curDestino.valueBuffer("idsincrostock") + "'");
          if (!idStock) {
            var idSincro = curDestino.valueBuffer("idsincrostock");
            var e = idSincro.split("_");
            var aDatosArt = new Object;
            aDatosArt.referencia = e[1];
            aDatosArt.barcode = e[2];
            idStock = _i.crearStock(e[0], aDatosArt);
            if (!idStock) {
              debug("No encontrado idstock para idsincro " + idSincro);
              return false;
            }
          }
          curDestino.setValueBuffer(campo, idStock);
          break;
        }
        default: {
          return _i.__calculaCampoSincro(curDestino, oTabla, campo);
        }
      }
      break;
    }
    case "stocks": {
      switch (campo) {
        case "cantidadultreg": {
          curDestino.setValueBuffer(campo, curDestino.valueBuffer("cantidad"));
          break;
        }
        case "fechaultreg": {
          curDestino.setValueBuffer(campo, curDestino.valueBuffer("fechaultmov"));
          break;
        }
        case "horaultreg": {
          curDestino.setValueBuffer(campo, curDestino.valueBuffer("horaultmov"));
          break;
        }
        default: {
          return _i.__calculaCampoSincro(curDestino, oTabla, campo);
        }
      }
      break;
    }
    case "tpv_datosgenerales": {
      switch (campo) {
        case "tiendasincro": {
          curDestino.setValueBuffer(campo, true);
          break;
        }
        default: {
          return _i.__calculaCampoSincro(curDestino, oTabla, campo);
        }
      }
      break;
    }
    case "tpv_recepcion_multitrans": {
      switch (campo) {
        case "rxcentral": {
          curDestino.setValueBuffer(campo, curDestino.valueBuffer("rxtienda"));
          break;
        }
        case "excentral": {
          curDestino.setValueBuffer(campo, curDestino.valueBuffer("extienda"));
          break;
        }
        case "ptestockrx": {
          curDestino.setValueBuffer(campo, (curDestino.valueBuffer("rxtienda") == "OK"));
          break;
        }
        case "ptestockex": {
          curDestino.setValueBuffer(campo, (curDestino.valueBuffer("extienda") == "OK"));
          break;
        }
        default: {
          return _i.__calculaCampoSincro(curDestino, oTabla, campo);
        }
      }
      break;
    }

    default: {
      return _i.__calculaCampoSincro(curDestino, oTabla, campo);
    }
  }
  return true;
}

function sincrotpv_afterCommit_stocks(curS)
{
  var _i = this.iface;
  if (!_i.__afterCommit_stocks(curS)) {
    return false;
  }
  if (!_i.controlSincroStockTiendas(curS)) {
    return false;
  }
  return true;
}

function sincrotpv_datosControlSincroSTCambian(curS)
{
  var cambian = (curS.valueBuffer("cantidad") != curS.valueBufferCopy("cantidad"));
  return cambian;
}

function sincrotpv_controlSincroStockTiendas(curS)
{
  var _i = this.iface;
  if (flfact_tpv.iface.pub_esBDLocal()) {
    return true;
  }
  switch (curS.modeAccess()) {
    case curS.Edit: {
      if (!_i.datosControlSincroSTCambian(curS)) {
        break;
      }
    }
    case curS.Insert: {
      var q = new FLSqlQuery;
      q.setSelect("codtienda");
      q.setFrom("tpv_tiendas");
      q.setWhere("codalmacen <> '" + curS.valueBuffer("codalmacen") + "'");
      if (!q.exec()) {
        return false;
      }
      var curSST = new FLSqlCursor("sincrostockstienda");
      while (q.next()) {
        curSST.select("codtienda = '" + q.value("codtienda") + "' AND idstock = " + curS.valueBuffer("idstock"));
        if (curSST.first()) {
          curSST.setModeAccess(curSST.Edit);
          curSST.refreshBuffer();
          if (!curSST.valueBuffer("sincronizado")) {
            continue;
          }
        } else {
          curSST.setModeAccess(curSST.Insert);
          curSST.refreshBuffer();
          curSST.setValueBuffer("codtienda", q.value("codtienda"));
          curSST.setValueBuffer("idstock", curS.valueBuffer("idstock"));
        }
        curSST.setValueBuffer("sincronizado", false);
        if (!curSST.commitBuffer()) {
          return false;
        }
      }
      break;
    }
  }
  return true;
}

function sincrotpv_controlSincroDevolTiendas(curC)
{
  if (flfact_tpv.iface.pub_esBDLocal()) {
    return true;
  }
  switch (curC.modeAccess()) {
    case curC.Insert:
    case curC.Edit: {
      var q = new FLSqlQuery;
      q.setSelect("codtienda");
      q.setFrom("tpv_tiendas");
      q.setWhere("servidor IS NOT NULL");/// Distingue las tiendas activas
      if (!q.exec()) {
        return false;
      }
      var curSST = new FLSqlCursor("tpv_sincrodevoltienda");
      while (q.next()) {
        curSST.select("codtienda = '" + q.value("codtienda") + "' AND idtpv_comanda = " + curC.valueBuffer("idtpv_comanda"));
        if (curSST.first()) {
          curSST.setModeAccess(curSST.Edit);
          curSST.refreshBuffer();
          if (!curSST.valueBuffer("sincronizado")) {
            continue;
          }
        } else {
          curSST.setModeAccess(curSST.Insert);
          curSST.refreshBuffer();
          curSST.setValueBuffer("codtienda", q.value("codtienda"));
          curSST.setValueBuffer("idtpv_comanda", curC.valueBuffer("idtpv_comanda"));
        }
        curSST.setValueBuffer("sincronizado", false);
        if (!curSST.commitBuffer()) {
          return false;
        }
      }
      break;
    }
  }
  return true;
}

function sincrotpv_datosStockLineaMTOCambian(curL)
{
  var _i = this.iface;
  if (curL.valueBuffer("ptestockex")) {
    return true;
  }
  return _i.__datosStockLineaMTOCambian(curL);
}

function sincrotpv_datosStockLineaMTDCambian(curL)
{
  var _i = this.iface;
  if (curL.valueBuffer("ptestockrx")) {
    return true;
  }
  return _i.__datosStockLineaMTDCambian(curL);
}
//// SINCRO TPV /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
