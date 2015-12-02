
/** @class_declaration scab */
/////////////////////////////////////////////////////////////////
//// CONTROL STOCK CABECERA /////////////////////////////////////
class scab extends oficial
{
  var aStocksAfectados_;
  function scab(context)
  {
    oficial(context);
  }
  function controlStockPedidosCli(curLP: FLSqlCursor): Boolean {
    return this.ctx.scab_controlStockPedidosCli(curLP);
  }
  function controlStockProv(curLP: FLSqlCursor): Boolean {
    return this.ctx.scab_controlStockPedidosProv(curLP);
  }
  function controlStockAlbaranesCli(curLA: FLSqlCursor): Boolean {
    return this.ctx.scab_controlStockAlbaranesCli(curLA);
  }
  function controlStockAlbaranesProv(curLA: FLSqlCursor): Boolean {
    return this.ctx.scab_controlStockAlbaranesProv(curLA);
  }
  function controlStockFacturasCli(curLF: FLSqlCursor): Boolean {
    return this.ctx.scab_controlStockFacturasCli(curLF);
  }
  function controlStockComandasCli(curLV: FLSqlCursor): Boolean {
    return this.ctx.scab_controlStockComandasCli(curLV);
  }
  function controlStockValesTPV(curLinea: FLSqlCursor): Boolean {
    return this.ctx.scab_controlStockValesTPV(curLinea);
  }
  function controlStockFacturasProv(curLF: FLSqlCursor): Boolean {
    return this.ctx.scab_controlStockFacturasProv(curLF);
  }
  function controlStockLineasTrans(curLTS: FLSqlCursor): Boolean {
    return this.ctx.scab_controlStockLineasTrans(curLTS);
  }
  function arraySocksAfectados(arrayInicial: Array, arrayFinal: Array): Array {
    return this.ctx.scab_arraySocksAfectados(arrayInicial, arrayFinal);
  }
  function compararArrayStock(a: Array, b: Array): Number {
    return this.ctx.scab_compararArrayStock(a, b);
  }
  function actualizarStockFisico(aArticulo: Array, codAlmacen: String, campo: String): Boolean {
    return this.ctx.scab_actualizarStockFisico(aArticulo, codAlmacen, campo);
  }
  function actualizarStockReservado(aArticulo: Array, codAlmacen: String, idPedido: String): Boolean {
    return this.ctx.scab_actualizarStockReservado(aArticulo, codAlmacen, idPedido);
  }
  function actualizarStockPteRecibir(aArticulo: Array, codAlmacen: String, idPedido: String): Boolean {
    return this.ctx.scab_actualizarStockPteRecibir(aArticulo, codAlmacen, idPedido);
  }
  function controlStockFisico(curLinea: FLSqlCursor, codAlmacen: String, campo): Boolean {
    return this.ctx.scab_controlStockFisico(curLinea, codAlmacen, campo);
  }
  function afterCommit_transstock(curTrans)
  {
    return this.ctx.scab_afterCommit_transstock(curTrans);
  }
  function ponStocksAfectados(aSA)
  {
    return this.ctx.scab_ponStocksAfectados(aSA);
  }
  function procesaStocksAfectados(campo)
  {
    return this.ctx.scab_procesaStocksAfectados(campo);
  }
}
//// CONTROL STOCK CABECERA /////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pubScab */
/////////////////////////////////////////////////////////////////
//// PUB SCAB ///////////////////////////////////////////////////
class pubScab extends ifaceCtx
{
  function pubScab(context)
  {
    ifaceCtx(context);
  }
  function pub_arraySocksAfectados(arrayInicial: Array, arrayFinal: Array): Array {
    return this.arraySocksAfectados(arrayInicial, arrayFinal);
  }
  function pub_actualizarStockReservado(aArticulo: Array, codAlmacen: String, idPedido: String): Boolean {
    return this.actualizarStockReservado(aArticulo, codAlmacen, idPedido);
  }
  function pub_actualizarStockPteRecibir(aArticulo: Array, codAlmacen: String, idPedido: String): Boolean {
    return this.actualizarStockPteRecibir(aArticulo, codAlmacen, idPedido);
  }
  function pub_actualizarStockFisico(aArticulo, codAlmacen: String, campo: String): Boolean {
    return this.actualizarStockFisico(aArticulo, codAlmacen, campo);
  }
  function pub_ponStocksAfectados(aSA)
  {
    return this.ponStocksAfectados(aSA);
  }
  function pub_procesaStocksAfectados(campo)
  {
    return this.procesaStocksAfectados(campo);
  }
}
//// PUB SCAB ///////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition scab */
/////////////////////////////////////////////////////////////////
//// CONTROL STOCKS CABECERA ////////////////////////////////////
/** \C
Actualiza el stock correspondiente al artículo seleccionado en la línea
\end */
function scab_controlStockPedidosCli(curLP: FLSqlCursor): Boolean {
  var util: FLUtil = new FLUtil;
  var curRel: FLSqlCursor = curLP.cursorRelation();
  if (curRel && curRel.action() == "pedidoscli")
  {
    return true;
  }

  if (!this.iface.__controlStockPedidosCli(curLP))
  {
    return false;
  }

  return true;
}

function scab_controlStockPedidosProv(curLP: FLSqlCursor): Boolean {
  var util: FLUtil = new FLUtil;
  var curRel: FLSqlCursor = curLP.cursorRelation();
  if (curRel && curRel.action() == "pedidosprov")
  {
    return true;
  }

  if (!this.iface.__controlStockPedidosProv(curLP))
  {
    return false;
  }

  return true;
}

function scab_controlStockAlbaranesCli(curLA: FLSqlCursor): Boolean {
  var util: FLUtil = new FLUtil;
  var curRel: FLSqlCursor = curLA.cursorRelation();
  if (curRel && curRel.action() == "albaranescli")
  {
    return true;
  }

  var codAlmacen: String = util.sqlSelect("albaranescli", "codalmacen", "idalbaran = " + curLA.valueBuffer("idalbaran"));
  if (!codAlmacen || codAlmacen == "")
  {
    return true;
  }

  if (!this.iface.controlStockFisico(curLA, codAlmacen, "cantidadac"))
  {
    return false;
  }

  return true;
}

function scab_controlStockAlbaranesProv(curLA: FLSqlCursor): Boolean {
  var util: FLUtil = new FLUtil;
  var curRel: FLSqlCursor = curLA.cursorRelation();
  if (curRel && curRel.action() == "albaranesprov")
  {
    return true;
  }

  var codAlmacen: String = util.sqlSelect("albaranesprov", "codalmacen", "idalbaran = " + curLA.valueBuffer("idalbaran"));
  if (!codAlmacen || codAlmacen == "")
  {
    return true;
  }

  if (!this.iface.controlStockFisico(curLA, codAlmacen, "cantidadap"))
  {
    return false;
  }

  return true;
}

function scab_controlStockFacturasCli(curLF: FLSqlCursor): Boolean {
  var util: FLUtil = new FLUtil;
  var curRel: FLSqlCursor = curLF.cursorRelation();
  if (curRel && curRel.action() == "facturascli")
  {
    return true;
  }

  if (util.sqlSelect("facturascli", "automatica", "idfactura = " + curLF.valueBuffer("idfactura")))
  {
    return true;
  }

  var codAlmacen: String = util.sqlSelect("facturascli", "codalmacen", "idfactura = " + curLF.valueBuffer("idfactura"));
  if (!codAlmacen || codAlmacen == "")
  {
    return true;
  }

  if (!this.iface.controlStockFisico(curLF, codAlmacen, "cantidadfc"))
  {
    return false;
  }

  return true;
}

function scab_controlStockFacturasProv(curLF: FLSqlCursor): Boolean {
  var util: FLUtil = new FLUtil;
  var curRel: FLSqlCursor = curLF.cursorRelation();
  if (curRel && curRel.action() == "facturasprov")
  {
    return true;
  }

  if (util.sqlSelect("facturasprov", "automatica", "idfactura = " + curLF.valueBuffer("idfactura")))
  {
    return true;
  }

  var codAlmacen: String = util.sqlSelect("facturasprov", "codalmacen", "idfactura = " + curLF.valueBuffer("idfactura"));
  if (!codAlmacen || codAlmacen == "")
  {
    return true;
  }

  if (!this.iface.controlStockFisico(curLF, codAlmacen, "cantidadfp"))
  {
    return false;
  }

  return true;
}

function scab_controlStockComandasCli(curLV: FLSqlCursor): Boolean {
  var util: FLUtil = new FLUtil();

  var curRel: FLSqlCursor = curLV.cursorRelation();
  if (curRel && curRel.action() == "tpv_comandas")
  {
    return true;
  }
  var codAlmacen = util.sqlSelect("tpv_comandas c INNER JOIN tpv_puntosventa pv ON c.codtpv_puntoventa = pv.codtpv_puntoventa", "pv.codalmacen", "idtpv_comanda = " + curLV.valueBuffer("idtpv_comanda"), "tpv_comandas,tpv_puntosventa");
  if (!codAlmacen || codAlmacen == "")
  {
    return true;
  }

  if (!this.iface.controlStockFisico(curLV, codAlmacen, "cantidadtpv"))
  {
    return false;
  }

  return true;
}

function scab_controlStockValesTPV(curLV: FLSqlCursor): Boolean {
  var util: FLUtil = new FLUtil();

  var codAlmacen = curLV.valueBuffer("codalmacen");
  if (!codAlmacen || codAlmacen == "")
  {
    return true;
  }

  if (!this.iface.controlStockFisico(curLV, codAlmacen, "cantidadval"))
  {
    return false;
  }

  return true;
}

function scab_controlStockLineasTrans(curLTS: FLSqlCursor): Boolean {
  debug("scab_controlStockLineasTrans");
  var util: FLUtil = new FLUtil();

  var curRel: FLSqlCursor = curLTS.cursorRelation();
  if (curRel && curRel.action() == "transstock")
  {
    return true;
  }
  debug("scab_controlStockLineasTrans pasa");
  var codAlmacenOrigen: String = util.sqlSelect("transstock", "codalmaorigen", "idtrans = " + curLTS.valueBuffer("idtrans"));
  if (!codAlmacenOrigen || codAlmacenOrigen == "")
  {
    return true;
  }

  var codAlmacenDestino: String = util.sqlSelect("transstock", "codalmadestino", "idtrans = " + curLTS.valueBuffer("idtrans"));
  if (!codAlmacenDestino || codAlmacenDestino == "")
  {
    return true;
  }

  if (!this.iface.controlStockFisico(curLTS, codAlmacenOrigen, "cantidadts"))
  {
    return false;
  }

  if (!this.iface.controlStockFisico(curLTS, codAlmacenDestino, "cantidadts"))
  {
    return false;
  }

  return true;
}


function scab_arraySocksAfectados(arrayInicial: Array, arrayFinal: Array): Array {
  var arrayAfectados: Array = [];
  var iAA: Number = 0;
  var iAI: Number = 0;
  var iAF: Number = 0;
  var longAI: Number = arrayInicial.length;
  var longAF: Number = arrayFinal.length;

  // debug("ARRAY INICIAL");
  // for (var i:Number = 0; i < arrayInicial.length; i++) {
  //  debug(" " + arrayInicial[i]["articulo"]["referencia"] + "-" + arrayInicial[i]["codalmacen"]);
  // }
  // debug("ARRAY FINAL");
  // for (var i:Number = 0; i < arrayFinal.length; i++) {
  //  debug(" " + arrayFinal[i]["articulo"]["referencia"] + "-" + arrayFinal[i]["codalmacen"]);
  // }

  arrayInicial.sort(this.iface.compararArrayStock);
  arrayFinal.sort(this.iface.compararArrayStock);

  // debug("ARRAY INICIAL ORDENADO");
  // for (var i:Number = 0; i < arrayInicial.length; i++) {
  //  debug(" " + arrayInicial[i]["articulo"]["referencia"] + "-" + arrayInicial[i]["codalmacen"]);
  // }
  // debug("ARRAY FINAL ORDENADO");
  // for (var i:Number = 0; i < arrayFinal.length; i++) {
  //  debug(" " + arrayFinal[i]["articulo"]["referencia"] + "-" + arrayFinal[i]["codalmacen"]);
  // }
  var comparacion: Number;
  while (iAI < longAI || iAF < longAF)
  {
    if (iAI < longAI && iAF < longAF) {
      comparacion = this.iface.compararArrayStock(arrayInicial[iAI], arrayFinal[iAF]);
    } else if (iAF < longAF) {
      comparacion = 1;
    } else if (iAI < longAI) {
      comparacion = -1;
    }
    switch (comparacion) {
      case 1: {
        arrayAfectados[iAA] = [];
        arrayAfectados[iAA]["articulo"] = [];
        arrayAfectados[iAA]["articulo"]["referencia"] = arrayFinal[iAF]["articulo"]["referencia"];
        arrayAfectados[iAA]["codalmacen"] = arrayFinal[iAF]["codalmacen"];
        iAF++;
        iAA++;
        break;
      }
      case -1: {
        arrayAfectados[iAA] = [];
        arrayAfectados[iAA]["articulo"] = [];
        arrayAfectados[iAA]["articulo"]["referencia"] = arrayInicial[iAI]["articulo"]["referencia"];
        arrayAfectados[iAA]["codalmacen"] = arrayInicial[iAI]["codalmacen"];
        iAI++;
        iAA++;
        break;
      }
      case 0: {
        if (arrayInicial[iAI]["cantidad"] != arrayFinal[iAF]["cantidad"]) {
          arrayAfectados[iAA] = [];
          arrayAfectados[iAA]["articulo"] = [];
          arrayAfectados[iAA]["articulo"]["referencia"] = arrayFinal[iAI]["articulo"]["referencia"];
          arrayAfectados[iAA]["codalmacen"] = arrayFinal[iAI]["codalmacen"];
          iAA++;
        }
        iAI++;
        iAF++;
        break;
      }
    }
  }
  return arrayAfectados;
}

/** \D Compara dos pares de datos idArticulo / codAlmacen que definen un stock
\end */
function scab_compararArrayStock(a: Array, b: Array): Number {
  var resultado: Number = 0;
  if (a["codalmacen"] > b["codalmacen"])
  {
    resultado = 1;
  } else if (a["codalmacen"] < b["codalmacen"])
  {
    resultado = -1;
  } else if (a["codalmacen"] == b["codalmacen"])
  {
    if (a["articulo"]["referencia"] > b["articulo"]["referencia"])  {
      resultado = 1;
    } else if (a["articulo"]["referencia"] < b["articulo"]["referencia"])  {
      resultado = -1;
    }
  }
  return resultado;
}

function scab_controlStockFisico(curLinea: FLSqlCursor, codAlmacen: String, campo: String): Boolean {
  var util: FLUtil = new FLUtil;

  var referencia: String = curLinea.valueBuffer("referencia");
  if (util.sqlSelect("articulos", "nostock", "referencia = '" + referencia  + "'"))
  {
    return true;
  }
  var aArticulo: Array = [];
  aArticulo["referencia"] = referencia;
  debug("Referencia = " + aArticulo["referencia"]);
  if (aArticulo["referencia"] && aArticulo["referencia"] != "")
  {
    debug("Llamando");
    if (!this.iface.actualizarStockFisico(aArticulo, codAlmacen, campo)) {
      return false;
    }
  }

  var aArticuloPrevio: Array = [];
  aArticuloPrevio["referencia"] = curLinea.valueBufferCopy("referencia");
  if (aArticuloPrevio["referencia"] && aArticuloPrevio["referencia"] != "" && aArticuloPrevio["referencia"] != aArticulo["referencia"])
  {
    if (!this.iface.actualizarStockFisico(aArticuloPrevio, codAlmacen, campo)) {
      return false;
    }
  }

  return true;
}

function scab_actualizarStockFisico(aArticulo: Array, codAlmacen: String, campo: String): Boolean {
  debug("scab_actualizarStockFisico para " + campo);
  var util: FLUtil = new FLUtil;
  var referencia: String = aArticulo["referencia"];

  if (util.sqlSelect("articulos", "nostock", "referencia = '" + referencia  + "'"))
  {
    return true;
  }
  var idStock: String = util.sqlSelect("stocks", "idstock", "referencia = '" + referencia + "' AND codalmacen = '" + codAlmacen + "'");
  if (!idStock)
  {
    idStock = this.iface.crearStock(codAlmacen, aArticulo);
    if (!idStock) {
      return false;
    }
  }

  var curStock: FLSqlCursor = new FLSqlCursor("stocks");
  curStock.select("idstock = " + idStock);
  if (!curStock.first())
  {
    return false;
  }
  var stockFisico: Number;
  curStock.setModeAccess(curStock.Edit);
  curStock.refreshBuffer();
  curStock.setValueBuffer(campo, formRecordregstocks.iface.pub_commonCalculateField(campo, curStock));

  stockFisico = formRecordregstocks.iface.pub_commonCalculateField("cantidad", curStock);
  if (stockFisico < 0)
  {
    if (!util.sqlSelect("articulos", "controlstock", "referencia = '" + referencia + "'")) {
      MessageBox.warning(util.translate("scripts", "El artículo %1 no permite ventas sin stock. Este movimiento dejaría el stock de %2 con un valor de %3.\n").arg(referencia).arg(codAlmacen).arg(stockFisico), MessageBox.Ok, MessageBox.NoButton);
      return false;
    }
  }
  curStock.setValueBuffer("cantidad", stockFisico);
  curStock.setValueBuffer("disponible", formRecordregstocks.iface.pub_commonCalculateField("disponible", curStock));
  if (!curStock.commitBuffer())
  {
    return false;
  }
  return true;
}

function scab_actualizarStockReservado(aArticulo: Array, codAlmacen: String, idPedido: String): Boolean {
  var util: FLUtil = new FLUtil;

  var referencia: String = aArticulo["referencia"];
  if (util.sqlSelect("articulos", "nostock", "referencia = '" + referencia  + "'"))
  {
    return true;
  }
  var idStock: String = util.sqlSelect("stocks", "idstock", "referencia = '" + referencia + "' AND codalmacen = '" + codAlmacen + "'");
  if (!idStock)
  {
    idStock = this.iface.crearStock(codAlmacen, aArticulo);
    if (!idStock) {
      return false;
    }
  }

  var curStock: FLSqlCursor = new FLSqlCursor("stocks");
  curStock.select("idstock = " + idStock);
  if (!curStock.first())
  {
    return false;
  }
  var oS = formRecordregstocks.iface.pub_dameParamStock();
  oS.idPedido = idPedido
                var stockFisico: Number;
  curStock.setModeAccess(curStock.Edit);
  curStock.refreshBuffer();
  curStock.setValueBuffer("reservada", formRecordregstocks.iface.pub_commonCalculateField("reservada", curStock, oS));
  curStock.setValueBuffer("disponible", formRecordregstocks.iface.pub_commonCalculateField("disponible", curStock));
  if (!curStock.commitBuffer())
  {
    return false;
  }

  return true;
}

function scab_actualizarStockPteRecibir(aArticulo: Array, codAlmacen: String, idPedido: String): Boolean {
  var util: FLUtil = new FLUtil;
  var referencia: String = aArticulo["referencia"]
  ;
  if (util.sqlSelect("articulos", "nostock", "referencia = '" + referencia  + "'"))
  {
    return true;
  }
  var idStock: String = util.sqlSelect("stocks", "idstock", "referencia = '" + referencia + "' AND codalmacen = '" + codAlmacen + "'");
  if (!idStock)
  {
    idStock = this.iface.crearStock(codAlmacen, aArticulo);
    if (!idStock) {
      return false;
    }
  }
  var curStock: FLSqlCursor = new FLSqlCursor("stocks");
  curStock.select("idstock = " + idStock);
  if (!curStock.first())
  {
    return false;
  }
  var oS = formRecordregstocks.iface.pub_dameParamStock();
  oS.idPedido = idPedido
                var stockFisico: Number;
  curStock.setModeAccess(curStock.Edit);
  curStock.refreshBuffer();
  curStock.setValueBuffer("pterecibir", formRecordregstocks.iface.pub_commonCalculateField("pterecibir", curStock, oS));
  if (!curStock.commitBuffer())
  {
    return false;
  }
  return true;
}

function scab_afterCommit_transstock(curTrans)
{
  if (!this.iface.procesaStocksAfectados("cantidadts")) {
    return false;
  }
  return true;
}

function scab_ponStocksAfectados(aSA)
{
  this.iface.aStocksAfectados_ = aSA;
}

function scab_procesaStocksAfectados(campo)
{
  if (!this.iface.aStocksAfectados_ || this.iface.aStocksAfectados_ == undefined) {
    return true;
  }
  var aSA = this.iface.aStocksAfectados_;
  for (var i = 0; i < aSA.length; i++) {
    switch (campo) {
      default: {
        if (!this.iface.actualizarStockFisico(aSA[i]["articulo"], aSA[i]["codalmacen"], campo)) {
          return false;
        }
        break;
      }
    }
  }
  this.iface.ponStocksAfectados(false);
  return true;
}

//// CONTROL STOCKS CABECERA ////////////////////////////////////
/////////////////////////////////////////////////////////////////
