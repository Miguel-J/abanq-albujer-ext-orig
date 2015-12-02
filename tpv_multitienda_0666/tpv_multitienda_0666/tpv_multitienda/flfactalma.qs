
/** @class_declaration multitpv */
/////////////////////////////////////////////////////////////////
//// TPV MULTITIENDA ////////////////////////////////////////////
class multitpv extends articomp
{
  function multitpv(context)
  {
    articomp(context);
  }
  function controlStockMultitrans(curL)
  {
    return this.ctx.multitpv_controlStockMultitrans(curL);
  }
  function controlStockBCMultitrans(curL)
  {
    return this.ctx.multitpv_controlStockBCMultitrans(curL);
  }
  function borrarEstructuraMTDestino(curL)
  {
    return this.ctx.multitpv_borrarEstructuraMTDestino(curL);
  }
  function borrarEstructuraMTOrigen(curL)
  {
    return this.ctx.multitpv_borrarEstructuraMTOrigen(curL);
  }
  function datosStockLineaMTOCambian(curL)
  {
    return this.ctx.multitpv_datosStockLineaMTOCambian(curL);
  }
  function datosStockLineaMTDCambian(curL)
  {
    return this.ctx.multitpv_datosStockLineaMTDCambian(curL);
  }
  function generarEstructuraMTOrigen(curL)
  {
    return this.ctx.multitpv_generarEstructuraMTOrigen(curL);
  }
  function generarEstructuraMTDestino(curL)
  {
    return this.ctx.multitpv_generarEstructuraMTDestino(curL);
  }
}
//// TPV MULTITIENDA ////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pubMultitpv */
/////////////////////////////////////////////////////////////////
//// PUB TPV MULTITIENDA ////////////////////////////////////////
class pubMultitpv extends pubMedidas
{
  function pubMultitpv(context)
  {
    pubMedidas(context);
  }
  function pub_controlStockMultitrans(curL)
  {
    return this.controlStockMultitrans(curL);
  }
  function pub_controlStockBCMultitrans(curL)
  {
    return this.controlStockBCMultitrans(curL);
  }
}
//// PUB TPV MULTITIENDA ////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition multitpv */
/////////////////////////////////////////////////////////////////
//// TPV MULTITIENDA ////////////////////////////////////////////
function multitpv_controlStockMultitrans(curL)
{
  //  if (AQUtil.sqlSelect("articulos", "nostock", "referencia = '" + curLA.valueBuffer("referencia") + "'")) {
  //    return true;
  //  }
  var _i = this.iface;
  switch (curL.modeAccess()) {
    case curL.Insert: {
      if (!this.iface.generarEstructuraMTOrigen(curL)) {
        return false;
      }
      if (!this.iface.generarEstructuraMTDestino(curL)) {
        return false;
      }
      break;
    }
    case curL.Edit: {
      if (this.iface.datosStockLineaMTOCambian(curL)) {
        if (!this.iface.borrarEstructuraMTOrigen(curL)) {
          return false;
        }
        if (!this.iface.generarEstructuraMTOrigen(curL)) {
          return false;
        }
      }
      if (this.iface.datosStockLineaMTDCambian(curL)) {
        if (!this.iface.borrarEstructuraMTDestino(curL)) {
          return false;
        }
        if (!this.iface.generarEstructuraMTDestino(curL)) {
          return false;
        }
      }
      break;
    }
  }
  return true;
}

function multitpv_controlStockBCMultitrans(curL)
{
  //  if (AQUtil.sqlSelect("articulos", "nostock", "referencia = '" + curLA.valueBuffer("referencia") + "'")) {
  //    return true;
  //  }
  var _i = this.iface;
  switch (curL.modeAccess()) {
    case curL.Del: {
      if (!_i.borrarEstructuraMTOrigen(curL)) {
        return false;
      }
      if (!_i.borrarEstructuraMTDestino(curL)) {
        return false;
      }
      break;
    }
  }
  return true;
}

function multitpv_borrarEstructuraMTDestino(curL)
{
  if (!AQSql.del("movistock", "idlineattd = " + curL.valueBuffer("idlinea"))) {
    return false;
  }
  return true;
}

function multitpv_borrarEstructuraMTOrigen(curL)
{
  if (!AQSql.del("movistock", "idlineatto = " + curL.valueBuffer("idlinea"))) {
    return false;
  }
  return true;
}

function multitpv_datosStockLineaMTOCambian(curL)
{
  var cambia = (curL.valueBuffer("codalmaorigen") != curL.valueBufferCopy("codalmaorigen") || curL.valueBuffer("cantpteenvio") != curL.valueBufferCopy("cantpteenvio") || curL.valueBuffer("cantenviada") != curL.valueBufferCopy("cantenviada") || curL.valueBuffer("referencia") != curL.valueBufferCopy("referencia") || curL.valueBuffer("cerradaex") != curL.valueBufferCopy("cerradaex") || curL.valueBuffer("fechaex") != curL.valueBufferCopy("fechaex") || curL.valueBuffer("horaex") != curL.valueBufferCopy("horaex"));
  if (flfactppal.iface.pub_extension("tallcol_barcode")) {
    cambia = cambia || (curL.valueBuffer("barcode") != curL.valueBufferCopy("barcode"));
  }
  return cambia;
}

function multitpv_datosStockLineaMTDCambian(curL)
{
  var cambia = (curL.valueBuffer("codalmadestino") != curL.valueBufferCopy("codalmadestino") || curL.valueBuffer("cantpterecibir") != curL.valueBufferCopy("cantpterecibir") || curL.valueBuffer("cantrecibida") != curL.valueBufferCopy("cantrecibida") || curL.valueBuffer("referencia") != curL.valueBufferCopy("referencia") || curL.valueBuffer("cerradarx") != curL.valueBufferCopy("cerradarx") || curL.valueBuffer("fecharx") != curL.valueBufferCopy("fecharx") || curL.valueBuffer("horarx") != curL.valueBufferCopy("horarx"));
  if (flfactppal.iface.pub_extension("tallcol_barcode")) {
    cambia = cambia || (curL.valueBuffer("barcode") != curL.valueBufferCopy("barcode"));
  }
  return cambia;
}

function multitpv_generarEstructuraMTOrigen(curL)
{
  var _i = this.iface;
  var cantPteEnvio = parseFloat(curL.valueBuffer("cantpteenvio"));
  var cantEnviada = parseFloat(curL.valueBuffer("cantenviada"));
  var canPte = cantPteEnvio - cantEnviada;
  debug("cantPteEnvio " + cantPteEnvio);
  debug("cantEnviada " + cantEnviada);
  debug("canPte " + canPte);
  if (cantPteEnvio == 0 && cantEnviada == 0) {
    return true;
  }

  var curMS = new FLSqlCursor("movistock");
  var oDatos = new Object;
  oDatos.referencia = curL.valueBuffer("referencia")
                      var idStock;
  var codAlmacen = curL.valueBuffer("codalmaorigen");
  if (flfactppal.iface.pub_extension("tallcol_barcode")) {
    oDatos.barcode = curL.valueBuffer("barcode")
  }
                   idStock = _i.dameIdStock(codAlmacen, oDatos);
  if (!idStock) {
    return false;
  }
  if (canPte > 0 && !curL.valueBuffer("cerradoex")) {
    curMS.setModeAccess(curMS.Insert);
    curMS.refreshBuffer();
    canPte = AQUtil.roundFieldValue(canPte * -1, "stocks", "cantidad");
    debug("canPte " + canPte);
    curMS.setValueBuffer("referencia", curL.valueBuffer("referencia"));
    if (flfactppal.iface.pub_extension("tallcol_barcode")) {
      curMS.setValueBuffer("barcode", curL.valueBuffer("barcode"));
    }
    curMS.setValueBuffer("estado", "PTE");
    curMS.setValueBuffer("cantidad", canPte);
    curMS.setValueBuffer("idstock", idStock);
    curMS.setValueBuffer("idlineatto", curL.valueBuffer("idlinea"));
    if (!curMS.commitBuffer()) {
      return false;
    }
  }
  if (cantEnviada > 0) {
    cantEnviada = AQUtil.roundFieldValue(cantEnviada * -1, "stocks", "cantidad");
    curMS.setModeAccess(curMS.Insert);
    curMS.refreshBuffer();
    curMS.setValueBuffer("referencia", curL.valueBuffer("referencia"));
    if (flfactppal.iface.pub_extension("tallcol_barcode")) {
      curMS.setValueBuffer("barcode", curL.valueBuffer("barcode"));
    }
    curMS.setValueBuffer("estado", "HECHO");
    curMS.setValueBuffer("fechareal", curL.valueBuffer("fechaex"));
    curMS.setValueBuffer("horareal", curL.valueBuffer("horaex"));
    curMS.setValueBuffer("cantidad", cantEnviada);
    curMS.setValueBuffer("idstock", idStock);
    curMS.setValueBuffer("idlineatto", curL.valueBuffer("idlinea"));
    if (!curMS.commitBuffer()) {
      return false;
    }
  }
  return true;
}

function multitpv_generarEstructuraMTDestino(curL)
{
  var _i = this.iface;
  var cantPteRecibir = parseFloat(curL.valueBuffer("cantpterecibir"));
  var cantRecibida = parseFloat(curL.valueBuffer("cantrecibida"));
  var canPte = cantPteRecibir - cantRecibida;
  if (cantPteRecibir == 0 && cantRecibida == 0) {
    return true;
  }

  var curMS = new FLSqlCursor("movistock");
  var oDatos = new Object;
  oDatos.referencia = curL.valueBuffer("referencia")
                      var idStock;
  var codAlmacen = curL.valueBuffer("codalmadestino");
  if (flfactppal.iface.pub_extension("tallcol_barcode")) {
    oDatos.barcode = curL.valueBuffer("barcode")
  }
                   idStock = _i.dameIdStock(codAlmacen, oDatos);
  if (!idStock) {
    return false;
  }
  if (canPte > 0 && !curL.valueBuffer("cerradorx")) {
    curMS.setModeAccess(curMS.Insert);
    curMS.refreshBuffer();
    curMS.setValueBuffer("referencia", curL.valueBuffer("referencia"));
    if (flfactppal.iface.pub_extension("tallcol_barcode")) {
      curMS.setValueBuffer("barcode", curL.valueBuffer("barcode"));
    }
    curMS.setValueBuffer("estado", "PTE");
    curMS.setValueBuffer("cantidad", canPte);
    curMS.setValueBuffer("idstock", idStock);
    curMS.setValueBuffer("idlineattd", curL.valueBuffer("idlinea"));
    if (!curMS.commitBuffer()) {
      return false;
    }
  }
  if (cantRecibida > 0) {
    curMS.setModeAccess(curMS.Insert);
    curMS.refreshBuffer();
    curMS.setValueBuffer("referencia", curL.valueBuffer("referencia"));
    if (flfactppal.iface.pub_extension("tallcol_barcode")) {
      curMS.setValueBuffer("barcode", curL.valueBuffer("barcode"));
    }
    curMS.setValueBuffer("estado", "HECHO");
    curMS.setValueBuffer("fechareal", curL.valueBuffer("fecharx"));
    curMS.setValueBuffer("horareal", curL.valueBuffer("horarx"));
    curMS.setValueBuffer("cantidad", cantRecibida);
    curMS.setValueBuffer("idstock", idStock);
    curMS.setValueBuffer("idlineattd", curL.valueBuffer("idlinea"));
    if (!curMS.commitBuffer()) {
      return false;
    }
  }
  return true;
}
//// TPV MULTITIENDA ////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
