
/** @class_declaration distEjer */
/////////////////////////////////////////////////////////////////
//// DISTRIBUCIÓN ENTRE EJERCICIOS //////////////////////////////
class distEjer extends oficial
{
  var aLineasDist_;
  function distEjer(context)
  {
    oficial(context);
  }
  function init()
  {
    return this.ctx.distEjer_init();
  }
  function tbnDistribuyeEjercicio_clicked()
  {
    return this.ctx.distEjer_tbnDistribuyeEjercicio_clicked();
  }
  function distribuyeEjercicio(cursor)
  {
    return this.ctx.distEjer_distribuyeEjercicio(cursor);
  }
  function dameArrayLineasDist(cursor)
  {
    return this.ctx.distEjer_dameArrayLineasDist(cursor);
  }
  function distribuirAlbaran(oParam)
  {
    return this.ctx.distEjer_distribuirAlbaran(oParam);
  }
  function ponArrayLineasDist(a)
  {
    return this.ctx.distEjer_ponArrayLineasDist(a);
  }
  function copiaLineasDist(curA, curB, cx)
  {
    return this.ctx.distEjer_copiaLineasDist(curA, curB, cx);
  }
  function totalizaLineaDist(curLinea)
  {
    return this.ctx.distEjer_totalizaLineaDist(curLinea);
  }
  function totalizaAlbaranDist(curAlbaran)
  {
    return this.ctx.distEjer_totalizaAlbaranDist(curAlbaran);
  }
  function copiaCabeceraDist(curA, curB)
  {
    return this.ctx.distEjer_copiaCabeceraDist(curA, curB);
  }
  function copiaCampoDist(nombreCampo, curA, curB, campoInformado)
  {
    return this.ctx.distEjer_copiaCampoDist(nombreCampo, curA, curB, campoInformado);
  }
  function deshacerDistribucionAlb(oParam)
  {
    return this.ctx.distEjer_deshacerDistribucionAlb(oParam);
  }
  function datosLineaFactura(curLineaAlbaran)
  {
    return this.ctx.distEjer_datosLineaFactura(curLineaAlbaran);
  }
  function distribucionCompleta(curA)
  {
    return this.ctx.distEjer_distribucionCompleta(curA);
  }
  function compruebaBloqueoDist(curA)
  {
    return this.ctx.distEjer_compruebaBloqueoDist(curA);
  }
}
//// DISTRIBUCIÓN ENTRE EJERCICIOS //////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pubDistEjer */
/////////////////////////////////////////////////////////////////
//// PUB DISTRIBUCIÓN EJERCICIOS ////////////////////////////////
class pubDistEjer extends ifaceCtx
{
  function pubDistEjer(context)
  {
    ifaceCtx(context);
  }
  function pub_ponArrayLineasDist(a)
  {
    return this.ponArrayLineasDist(a);
  }
  function pub_distribuyeEjercicio(cursor)
  {
    return this.distribuyeEjercicio(cursor);
  }
}
//// PUB DISTRIBUCIÓN EJERCICIOS ////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition distEjer */
/////////////////////////////////////////////////////////////////
//// DISTRIBUCIÓN ENTRE EJERCICIOS //////////////////////////////
function distEjer_init()
{
  var _i = this.iface;
  _i.__init();
  connect(this.child("tbnDistribuyeEjercicio"), "clicked()", _i, "tbnDistribuyeEjercicio_clicked");
}

function distEjer_tbnDistribuyeEjercicio_clicked()
{
  var _i = this.iface;
  var cursor = this.cursor();

  if (!_i.distribuyeEjercicio(cursor)) {
    return;
  }
  _i.tdbRecords.refresh();

}

function distEjer_distribuyeEjercicio(cursor)
{
  var _i = this.iface;
  var pteFactura = cursor.valueBuffer("ptefactura");
  if (!pteFactura && cursor.valueBuffer("idfactura")) {
    MessageBox.warning(sys.translate("No puede modificar la distribución de un albarán ya facturado"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton, "AbanQ");
    return;
  }
  if (!flfacturac.iface.pub_conectarDA()) {
    return;
  }
  var cx = flfacturac.iface.pub_conexionDA();
  var idAlbaranComp = cursor.valueBuffer("idalbarancomp");
  if (!idAlbaranComp) {
    var aLineas = _i.dameArrayLineasDist(cursor);
    if (!aLineas) {
      return;
    }
    var oParam = new Object;
    oParam.errorMsg = sys.translate("Error al distribuir el albarán");
    oParam.aLineas = aLineas;
    oParam.cursor = cursor;
    var curT1 = new FLSqlCursor("empresa");
    var curT2 = new FLSqlCursor("empresa", cx);
    curT1.transaction(false);
    curT2.transaction(false);
    try {
      if (_i.distribuirAlbaran(oParam)) {
        curT2.commit();
        curT1.commit();
      } else {
        curT2.rollback();
        curT1.rollback();
        MessageBox.warning(oParam.errorMsg, MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton, "AbanQ");
        return false;
      }
    } catch (e) {
      curT2.rollback();
      curT1.rollback();
      MessageBox.warning(oParam.errorMsg + "\n" + e, MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton, "AbanQ");
      return false;
    }
    //     var f = new Function("oParam", "return formalbaranescli.iface.distribuirAlbaran(oParam)");
    //     if (!sys.runTransaction(f, oParam)) {
    //       return false;
    //     }
    cursor.setModeAccess(cursor.Browse);
    cursor.refreshBuffer();
    var codComp = AQUtil.sqlSelect("albaranescli", "codigo", "idalbaran = " + oParam.idAlbaranComp, "albaranescli", cx);
    MessageBox.information(sys.translate("Albarán distribuido en el albarán %1").arg(codComp), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton, "AbanQ");
  } else {
    var codComp = AQUtil.sqlSelect("albaranescli", "codigo", "idalbaran = " + idAlbaranComp, "albaranescli", cx);
    var pteFacturaComp = AQUtil.sqlSelect("albaranescli", "ptefactura", "idalbaran = " + idAlbaranComp, "albaranescli", cx);
    if (!pteFacturaComp && cursor.valueBuffer("idfactura")) {
      MessageBox.warning(sys.translate("El albarán de distribución %1 está facturado. Debe eliminar la factura asociada antes de continuar").arg(codComp), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton, "AbanQ");
      return;
    }

    var res = MessageBox.information(sys.translate("El albarán ya está distribuido en el albarán %1. ¿Desea deshacer esta distribución?").arg(codComp), MessageBox.Yes, MessageBox.No, MessageBox.NoButton, "AbanQ");
    if (res != MessageBox.Yes) {
      return false;
    }
    var oParam = new Object;
    oParam.errorMsg = sys.translate("Error al deshacer la distribución del albarán");
    oParam.cursor = cursor;
    //     var f = new Function("oParam", "return formalbaranescli.iface.deshacerDistribucionAlb(oParam)");
    //     if (!sys.runTransaction(f, oParam)) {
    //       return false;
    //     }
    var curT1 = new FLSqlCursor("empresa");
    var curT2 = new FLSqlCursor("empresa", cx);
    curT1.transaction(false);
    curT2.transaction(false);
    try {
      if (_i.deshacerDistribucionAlb(oParam)) {
        curT2.commit();
        curT1.commit();
      } else {
        curT2.rollback();
        curT1.rollback();
        MessageBox.warning(oParam.errorMsg, MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton, "AbanQ");
        return false;
      }
    } catch (e) {
      curT2.rollback();
      curT1.rollback();
      MessageBox.warning(oParam.errorMsg + "\n" + e, MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton, "AbanQ");
      return false;
    }
    MessageBox.information(sys.translate("Distribución deshecha"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton, "AbanQ");
  }
  return true;
}

function distEjer_dameArrayLineasDist(cursor)
{
  var _i = this.iface;
  var idAlbaran = cursor.valueBuffer("idalbaran");
  if (!idAlbaran) {
    return false;
  }

  var f = new FLFormSearchDB("distribuiralbaranescli");
  f.setMainWidget();
  var curAlb = f.cursor();
  curAlb.select("idalbaran = " + idAlbaran);
  if (!curAlb.first()) {
    return false;
  }
  curAlb.setModeAccess(curAlb.Browse);
  curAlb.refreshBuffer();

  if (!f.exec("idalbaran")) {
    return false;
  }
  return _i.aLineasDist_;
}

function distEjer_ponArrayLineasDist(a)
{
  var _i = this.iface;
  _i.aLineasDist_ = a;
}

function distEjer_deshacerDistribucionAlb(oParam)
{
  var _i = this.iface;
  var cursor = oParam.cursor;
  var curA = new FLSqlCursor("albaranescli");
  var cx = flfacturac.iface.pub_conexionDA();

  var idA = cursor.valueBuffer("idalbaran");
  var idB = cursor.valueBuffer("idalbarancomp");

  curA.select("idalbaran = " + idA);
  if (!curA.first()) {
    return false;
  }
  if (!curA.valueBuffer("ptefactura")) {
    curA.setUnLock("ptefactura", true);
    curA.select("idalbaran = " + cursor.valueBuffer("idalbaran"));
    if (!curA.first()) {
      return false;
    }
  }

  var curB = new FLSqlCursor("albaranescli", cx);
  curB.setActivatedCommitActions(false);
  curB.select("idalbaran = " + idB);
  if (curB.first()) {
    curB.setModeAccess(curB.Del);
    curB.refreshBuffer();
    if (!curB.commitBuffer()) {
      return false;
    }
  }

  var curLineaA = new FLSqlCursor("lineasalbaranescli");
  curLineaA.select("idalbaran = " + idA);
  while (curLineaA.next()) {
    curLineaA.setModeAccess(curLineaA.Edit);
    curLineaA.refreshBuffer();
    if (curLineaA.valueBuffer("cantidad") == curLineaA.valueBuffer("canfactura")) {
      continue;
    }
    curLineaA.setValueBuffer("canfactura", curLineaA.valueBuffer("cantidad"));
    curLineaA.setValueBuffer("candistibuida", 0);
    if (!_i.totalizaLineaDist(curLineaA)) {
      return false;
    }
    if (!curLineaA.commitBuffer()) {
      return false;
    }
  }
  curA.setModeAccess(curA.Edit);
  curA.refreshBuffer();
  curA.setNull("idalbarancomp");
  if (!_i.totalizaAlbaranDist(curA)) {
    return false;
  }
  if (!curA.commitBuffer()) {
    return false;
  }
  if (!_i.compruebaBloqueoDist(curA)) {
    return false;
  }
  return true;
}

function distEjer_distribuirAlbaran(oParam)
{
  var _i = this.iface;
  var _a = _i.aLineasDist_;
  if (!_a) {
    return;
  }
  var cx = flfacturac.iface.pub_conexionDA();
  var cursor = oParam.cursor;
  var curA = new FLSqlCursor("albaranescli");
  var curB = new FLSqlCursor("albaranescli", cx);
  curB.setActivatedCommitActions(false)

  var idA = cursor.valueBuffer("idalbaran");
  curA.select("idalbaran = " + idA);
  if (!curA.first()) {
    return false;
  }
  if (!curA.valueBuffer("ptefactura")) {
    curA.setUnLock("ptefactura", true);
    curA.select("idalbaran = " + cursor.valueBuffer("idalbaran"));
    if (!curA.first()) {
      return false;
    }
  }

  curB.setModeAccess(curB.Insert);
  curB.refreshBuffer();

  if (!_i.copiaCabeceraDist(curA, curB)) {
    return false;
  }
  var idB = curB.valueBuffer("idalbaran");
  if (!curB.commitBuffer()) {
    return false;
  }

  curB.select("idalbaran = " + idB);
  if (!curB.first()) {
    return false;
  }
  curB.setModeAccess(curB.Edit);
  curB.refreshBuffer();
  if (!_i.copiaLineasDist(curA, curB, cx)) {
    return false;
  }

  curA.setModeAccess(curA.Edit);
  curA.refreshBuffer();
  curA.setValueBuffer("idalbarancomp", idB);
  if (!_i.totalizaAlbaranDist(curA)) {
    return false;
  }
  if (!curA.commitBuffer()) {
    return false;
  }
  if (!_i.compruebaBloqueoDist(curA)) {
    return false;
  }
  curB.select("idalbaran = " + idB);
  if (!curB.first()) {
    return false;
  }
  curB.setModeAccess(curB.Edit);
  curB.refreshBuffer();
  if (!_i.totalizaAlbaranDist(curB)) {
    return false;
  }
  if (!curB.commitBuffer()) {
    return false;
  }
  oParam.idAlbaranComp = idB;
  return true;
}

function distEjer_compruebaBloqueoDist(curA)
{
  var _i = this.iface;
  var idA = curA.valueBuffer("idalbaran");
  if (_i.distribucionCompleta(curA)) {
    curA.select("idalbaran = " + idA);
    if (!curA.first()) {
      return false;
    }
    curA.setUnLock("ptefactura", false);
  }
  return true;
}

function distEjer_distribucionCompleta(curA)
{
  var _i = this.iface;
  var idA = curA.valueBuffer("idalbaran");
  if (AQUtil.sqlSelect("lineasalbaranescli", "idlinea", "idalbaran = " + idA + " AND canfactura <> 0")) {
    return false;
  }
  return true;
}

function distEjer_copiaLineasDist(curA, curB, cx)
{
  var _i = this.iface;
  var _a = _i.aLineasDist_;

  var curLineaA = new FLSqlCursor("lineasalbaranescli");
  var curLineaB = new FLSqlCursor("lineasalbaranescli", cx);
  curLineaB.setActivatedCommitActions(false);

  var cantidad, canB, canA;
  var aCamposLinea = AQUtil.nombreCampos("lineasalbaranescli");
  var totalCampos = aCamposLinea[0];

  var campoInformado;
  for (var i = 0; i < _a.length; i++) {
    canB = _a[i].cantidad;
    curLineaA.select("idlinea = " + _a[i].idlinea);
    if (!curLineaA.first()) {
      return false;
    }
    curLineaA.setModeAccess(curLineaA.Edit);
    curLineaA.refreshBuffer();
    cantidad = parseFloat(curLineaA.valueBuffer("cantidad"));
    canA = cantidad - canB;
    curLineaA.setValueBuffer("candistribuida", canB);
    curLineaA.setValueBuffer("canfactura", canA);

    curLineaB.setModeAccess(curLineaB.Insert);
    curLineaB.refreshBuffer();
    campoInformado = [];
    for (var i = 1; i <= totalCampos; i++) {
      campoInformado[aCamposLinea[i]] = false;
    }
    curLineaB.setValueBuffer("cantidad", canB);
    campoInformado["cantidad"] = true;
    debug("idalbaranb " + curB.valueBuffer("idalbaran"));
    curLineaB.setValueBuffer("idalbaran", curB.valueBuffer("idalbaran"));
    campoInformado["idalbaran"] = true;
    for (var i = 1; i <= totalCampos; i++) {
      if (!_i.copiaCampoDist(aCamposLinea[i], curLineaA, curLineaB, campoInformado)) {
        return false;
      }
    }
    if (!_i.totalizaLineaDist(curLineaA)) {
      return false;
    }
    if (!curLineaA.commitBuffer()) {
      return false;
    }
    if (!_i.totalizaLineaDist(curLineaB)) {
      return false;
    }
    if (!curLineaB.commitBuffer()) {
      return false;
    }
  }
  return true;
}

function distEjer_totalizaLineaDist(curLinea)
{
  curLinea.setValueBuffer("pvpsindto", formRecordlineaspedidoscli.iface.pub_commonCalculateField("pvpsindto", curLinea));
  curLinea.setValueBuffer("pvptotal", formRecordlineaspedidoscli.iface.pub_commonCalculateField("pvptotal", curLinea));
  return true;
}

function distEjer_totalizaAlbaranDist(curAlbaran)
{
  with(curAlbaran) {
    setValueBuffer("neto", formalbaranescli.iface.pub_commonCalculateField("neto", this));
    setValueBuffer("totaliva", formalbaranescli.iface.pub_commonCalculateField("totaliva", this));
    setValueBuffer("totalirpf", formalbaranescli.iface.pub_commonCalculateField("totalirpf", this));
    setValueBuffer("totalrecargo", formalbaranescli.iface.pub_commonCalculateField("totalrecargo", this));
    setValueBuffer("total", formalbaranescli.iface.pub_commonCalculateField("total", this));
    setValueBuffer("totaleuros", formalbaranescli.iface.pub_commonCalculateField("totaleuros", this));
  }
  return true;
}

function distEjer_copiaCabeceraDist(curA, curB)
{
  var _i = this.iface;
  var aCamposLinea = AQUtil.nombreCampos("albaranescli");
  var totalCampos = aCamposLinea[0];

  var campoInformado = [];
  for (var i = 1; i <= totalCampos; i++) {
    campoInformado[aCamposLinea[i]] = false;
  }
  for (var i = 1; i <= totalCampos; i++) {
    if (!_i.copiaCampoDist(aCamposLinea[i], curA, curB, campoInformado)) {
      return false;
    }
  }
  return true;
}

function distEjer_copiaCampoDist(nombreCampo, curA, curB, campoInformado)
{
  var _i = this.iface;
  if (campoInformado[nombreCampo]) {
    return true;
  }
  var nulo = false;

  switch (curA.table()) {
    case "albaranescli": {
      switch (nombreCampo) {
        case "idalbaran":
          //         case "numero":
          //         case "codigo":
        case "ptefactura":
        case "idfactura": {
          return true;
          break;
        }
        /// Estos valores se totalizan al final de la copia
        case "neto":
        case "total":
        case "totaleuros":
        case "totaliva":
        case "totalrecargo":
        case "totalirpf": {
          valor = 0;
          break;
        }
        //         case "codejercicio": {
        //           valor = AQUtil.sqlSelect("ejercicios", "codejerciciocomp", "codejercicio = '" + curA.valueBuffer("codejercicio") + "'");
        //           break;
        //         }
        default: {
          if (curA.isNull(nombreCampo)) {
            nulo = true;
          } else {
            valor = curA.valueBuffer(nombreCampo);
          }
        }
      }
      break;
    }
    case "lineasalbaranescli": {
      switch (nombreCampo) {
        case "idlinea": {
          return true;
          break;
        }
        case "candistribuida": {
          valor = curA.valueBuffer("canfactura");
          break;
        }
        case "canfactura": {
          valor = curA.valueBuffer("candistribuida");
          break;
        }
        /// Estos valores se totalizan al final de la copia
        case "pvpsindto":
        case "pvptotal": {
          valor = 0;
          break;
        }
        default: {
          if (curA.isNull(nombreCampo)) {
            nulo = true;
          } else {
            valor = curA.valueBuffer(nombreCampo);
          }
        }
      }
    }
  }
  if (nulo) {
    curB.setNull(nombreCampo);
  } else {
    curB.setValueBuffer(nombreCampo, valor);
  }
  campoInformado[nombreCampo] = true;

  return true;
}

function distEjer_datosLineaFactura(curLineaAlbaran)
{
  var _i = this.iface;
  if (!_i.__datosLineaFactura(curLineaAlbaran)) {
    return false;
  }
  _i.curLineaFactura.setValueBuffer("cantidad", curLineaAlbaran.valueBuffer("canfactura"));

  return true;
}
//// DISTRIBUCIÓN ENTRE EJERCICIOS //////////////////////////////
/////////////////////////////////////////////////////////////////
