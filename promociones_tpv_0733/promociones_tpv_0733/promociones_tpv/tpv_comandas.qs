
/** @class_declaration promocionesTpv */
/////////////////////////////////////////////////////////////////
//// PROMOCIONES TPV ////////////////////////////////////////////
class promocionesTpv extends ivaIncluido
{
  function promocionesTpv(context)
  {
    ivaIncluido(context);
  }
  function calculateField(fN)
  {
    return this.ctx.promocionesTpv_calculateField(fN);
  }
  function bufferChanged(fN)
  {
    return this.ctx.promocionesTpv_bufferChanged(fN);
  }
  function calcularTotalesPromo()
  {
    return this.ctx.promocionesTpv_calcularTotalesPromo();
  }
  function aplicarPromocion(idPromo)
  {
    return this.ctx.promocionesTpv_aplicarPromocion(idPromo);
  }
  function consultaSQL(idPromo)
  {
    return this.ctx.promocionesTpv_consultaSQL(idPromo);
  }
  function reorganizaLineas(resultados, idPromo, iR)
  {
    return this.ctx.promocionesTpv_reorganizaLineas(resultados, idPromo, iR);
  }
  function ordenaPromocion(p1, p2)
  {
    return this.ctx.promocionesTpv_ordenaPromocion(p1, p2);
  }
  function datosLineaPromocionada(curLinea, resultados, idPromo)
  {
    return this.ctx.promocionesTpv_datosLineaPromocionada(curLinea, resultados, idPromo);
  }
  function datosLineaVenta()
  {
    return this.ctx.promocionesTpv_datosLineaVenta();
  }
  function sumarUno(idLinea)
  {
    return this.ctx.promocionesTpv_sumarUno(idLinea);
  }
  function restarUno(idLinea)
  {
    return this.ctx.promocionesTpv_restarUno(idLinea);
  }
  function incrementaResultados(resultados, promo, q, iP, cantidad)
  {
    return this.ctx.promocionesTpv_incrementaResultados(resultados, promo, q, iP, cantidad);
  }
  function insertarElementosObjeto(resultados, promo, q, cantidad)
  {
    return this.ctx.promocionesTpv_insertarElementosObjeto(resultados, promo, q, cantidad);
  }
  function dameIdArticuloPromo(q)
  {
    return this.ctx.promocionesTpv_dameIdArticuloPromo(q);
  }
}
//// PROMOCIONES TPV ////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pubPromocionesTpv */
/////////////////////////////////////////////////////////////////
//// PUB PROMOCIONES TPV ///////////////////////////////////////////////////
class pubPromocionesTpv extends ifaceCtx
{
  function pubPromocionesTpv(context)
  {
    ifaceCtx(context);
  }

  function pub_calcularTotalesPromo()
  {
    return this.calcularTotalesPromo();
  }
  function pub_aplicarPromocion(idPromo)
  {
    return this.aplicarPromocion(idPromo);
  }
}
//// PUB PROMOCIONES TPV ///////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition promocionesTpv */
//////////////////////////////////////////////////////////////////
//// PROMOCIONES TPV /////////////////////////////////////////////

function promocionesTpv_calculateField(fN)
{
  var _i = this.iface;
  var cursor = this.cursor();
  var valor;

  switch (fN) {
    case "idpromo": {
      var hoy = new Date;
      valor = AQUtil.sqlSelect("promociones p INNER JOIN articulospromociones ap ON p.idpromo = ap.idpromo INNER JOIN clientespromociones cp ON p.idpromo = cp.idpromo", "p.idpromo", "ap.referencia = '" + cursor.valueBuffer("referencia") + "' AND cp.codcliente = '" + cursor.valueBuffer("codcliente") + "' AND '" + hoy + "' BETWEEN p.desde AND p.hasta ORDER by duracion ASC", "promociones,articulospromociones,clientespromociones");
      if (!valor) {
        valor = "";
      }
      break;
    }
    case "desccortapromo": {
      var hoy = new Date;
      valor = AQUtil.sqlSelect("promociones p INNER JOIN articulospromociones ap ON p.idpromo = ap.idpromo INNER JOIN clientespromociones cp ON p.idpromo = cp.idpromo", "p.desccorta", "ap.referencia = '" + cursor.valueBuffer("referencia") + "' AND cp.codcliente = '" + cursor.valueBuffer("codcliente") + "' AND '" + hoy + "' BETWEEN p.desde AND p.hasta ORDER by duracion ASC", "promociones,articulospromociones,clientespromociones");
      if (!valor) {
        valor = "";
      }
      break;
    }
    default: {
      valor = _i.__calculateField(fN);
      break;
    }
  }
  return valor;
}

function promocionesTpv_bufferChanged(fN)
{
  var _i = this.iface;
  var cursor = this.cursor();
  switch (fN) {
    case "codcliente": {
      var codCliente = cursor.valueBuffer("codcliente");
      if (!codCliente || codCliente.length < 6) {
        break;
      }
      if (!AQUtil.sqlSelect("clientes", "codcliente", "codcliente = '" + codCliente + "'")) {
        break;
      }
      this.child("fdbCodDir").setValue("0");
      this.child("fdbCodDir").setValue(_i.calculateField("coddir"));
      _i.actualizarIvaLineas(cursor.valueBuffer("codcliente"));
      _i.mostrarRecargo();
      _i.calcularTotales();
      break;
    }
    case "desarticulo": {
      valor = AQUtil.sqlSelect("articulos", "descripcion", "referencia = '" + cursor.valueBuffer("referencia") + "'");
      if (!valor) {
        _i.__bufferChanged(fN);
      }
      break;
    }
    case "pvparticulo": {
      valor = formRecordtpv_lineascomanda.iface.calcularPvpTarifa(cursor.valueBuffer("referencia"), cursor.valueBuffer("codtarifa"));
      valor = isNaN(valor) ? 0 : valor;
      valor = AQUtil.roundFieldValue(valor, "tpv_lineascomanda", "pvpunitario");
      break;
    }
    default: {
      _i.__bufferChanged(fN);
    }
  }
}

function promocionesTpv_calcularTotalesPromo()
{
  var _i = this.iface;
  _i.__calcularTotales();
  return true;
}

function promocionesTpv_aplicarPromocion(idPromo)
{
  var _i = this.iface;
  var cursor = this.cursor();

  var datosPromo = flfactppal.iface.pub_ejecutarQry("promociones", "cantidad1,dtocantidad1,cantidad2,dtocantidad2,cantidad3,dtocantidad3,cantidad4,dtocantidad4,cantidad5,dtocantidad5", "idpromo = '" + idPromo + "'");
  if (datosPromo.result != 1) {
    /// Error al consultar datos de la promoción %1
    return false;
  }

  var promo = [];
  var pasosPromo = 0;
  for (var i = 0; i < 5; i++) {
    if (datosPromo["cantidad" + (i + 1).toString()]) {
      promo[i] = [];
      promo[i]["cantidad"] = datosPromo["cantidad" + (i + 1).toString()];
      promo[i]["descuento"] = datosPromo["dtocantidad" + (i + 1).toString()];
      pasosPromo++;
    } else {
      break;
    }
  }

  var q = _i.consultaSQL(idPromo);

  q.setForwardOnly(true);
  if (!q.exec()) {
    return false;
  }
  var canLinea, canPromo;
  var iP = 0;
  canPromo = promo[iP]["cantidad"];
  var resultados = new Object;
  var iR = 0;
  var sigue = true;
  if (!q.first()) {
    return true;
  }
  canLinea = q.value("SUM(cantidad)");
  while (sigue) {
    if (canLinea > canPromo) {
      if (!_i.incrementaResultados(resultados, promo, q, iP, canPromo)) {
        return false;
      }

      canLinea -= canPromo;
      iR++;
      iP++;
      if (iP >= pasosPromo) {
        iP = 0;
      }
      canPromo = promo[iP]["cantidad"];
    } else if (canLinea < canPromo) {
      if (!_i.incrementaResultados(resultados, promo, q, iP, canLinea)) {
        return false;
      }

      canPromo -= canLinea;
      iR++;
      sigue = q.next();
      if (sigue) {
        canLinea = q.value("SUM(cantidad)");
      }
    } else {
      if (!_i.incrementaResultados(resultados, promo, q, iP, canLinea)) {
        return false;
      }

      canPromo -= canLinea;
      iP++;
      if (iP >= pasosPromo) {
        iP = 0;
      }
      iR++;
      sigue = q.next();
      if (sigue) {
        canLinea = q.value("SUM(cantidad)");
        canPromo = promo[iP]["cantidad"];
      }
    }
  }

  if (!_i.reorganizaLineas(resultados, idPromo, iR)) {
    return false;
  }
  return true;
}

function promocionesTpv_consultaSQL(idPromo)
{
  var cursor = this.cursor();
  var idComanda = cursor.valueBuffer("idtpv_comanda");

  var q = new FLSqlQuery();
  q.setSelect("referencia, SUM(cantidad), pvpunitarioiva, idpromo, desccortapromo, descripcion, pvpunitario");
  q.setFrom("tpv_lineascomanda");
  q.setWhere("idtpv_comanda = " + idComanda + " AND idpromo = '" + idPromo + "' GROUP BY referencia, pvpunitarioiva, idpromo, desccortapromo, descripcion, pvpunitario ORDER BY pvpunitarioiva DESC");

  debug("************* consultaSQL: " + q.sql());
  return q;
}

function promocionesTpv_incrementaResultados(resultados, promo, q, iP, cantidad)
{
  var _i = this.iface;
  if (!(iP in resultados)) {
    resultados[iP] = new Object();
  }
  var idArticulo = _i.dameIdArticuloPromo(q);
  if (!(idArticulo in resultados[iP])) {
    resultados[iP][idArticulo] = new Object;
    _i.insertarElementosObjeto(resultados[iP][idArticulo], promo[iP], q, cantidad);
  } else {
    resultados[iP][idArticulo]["cantidad"] += parseFloat(cantidad);
  }
  return true;
}

function promocionesTpv_insertarElementosObjeto(resultados, promo, q, cantidad)
{
  var _i = this.iface;
  var cursor = this.cursor();

  var promoSobrePrecio = flfact_tpv.iface.pub_valorDefectoTPV("promosobreprecio");

  resultados["referencia"] = q.value("referencia");
  resultados["desccortapromo"] = q.value("desccortapromo");
  resultados["descripcion"] = q.value("descripcion");
  resultados["cantidad"] = cantidad;

  if (promoSobrePrecio) {
    resultados["pvpunitarioiva"] = AQUtil.roundFieldValue(parseFloat(q.value("pvpunitarioiva")) * (100 - parseFloat(promo["descuento"])) / 100, "tpv_comandas", "neto");
    resultados["pvpunitario"] = AQUtil.roundFieldValue(parseFloat(q.value("pvpunitario")) * (100 - parseFloat(promo["descuento"])) / 100, "tpv_comandas", "neto");
    resultados["dtopor"] = 0;

  } else {
    resultados["pvpunitarioiva"] = q.value("pvpunitarioiva");
    resultados["pvpunitario"] = q.value("pvpunitario");
    resultados["dtopor"] = promo["descuento"];
  }
}

function promocionesTpv_reorganizaLineas(resultados, idPromo, iR)
{
  var _i = this.iface;
  var cursor = this.cursor();
  var curLinea = new FLSqlCursor("tpv_lineascomanda");

  if (!AQUtil.sqlDelete("tpv_lineascomanda", "idpromo = '" + idPromo + "' AND idtpv_comanda = '" + cursor.valueBuffer("idtpv_comanda") + "'")) {
    return false;
  }
  var i, idArticulo;
  for (i in resultados) {
    for (idArticulo in resultados[i]) {
      curLinea.setModeAccess(curLinea.Insert);
      curLinea.refreshBuffer();
      _i.datosLineaPromocionada(curLinea, resultados[i][idArticulo], idPromo);

      if (!curLinea.commitBuffer()) {
        return false;
      }
    }
  }
  this.child("tdbLineasComanda").refresh();
  return true;
}

function promocionesTpv_datosLineaPromocionada(curLinea, resultados, idPromo)
{
  var _i = this.iface;
  var cursor = this.cursor();

  curLinea.setValueBuffer("idtpv_comanda", cursor.valueBuffer("idtpv_comanda"));
  curLinea.setValueBuffer("referencia", resultados["referencia"]);
  curLinea.setValueBuffer("pvpunitarioiva", resultados["pvpunitarioiva"]);
  curLinea.setValueBuffer("cantidad", resultados["cantidad"]);
  curLinea.setValueBuffer("dtopor", resultados["dtopor"]);
  curLinea.setValueBuffer("pvpunitario", resultados["pvpunitario"]);
  curLinea.setValueBuffer("pvpsindto", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("pvpsindto", curLinea));
  curLinea.setValueBuffer("descripcion", resultados["descripcion"]);
  curLinea.setValueBuffer("codimpuesto",  this.iface.calcularIvaLinea(curLinea.valueBuffer("referencia")));
  curLinea.setValueBuffer("iva", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("iva", curLinea));
  curLinea.setValueBuffer("recargo", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("recargo", curLinea));
  curLinea.setValueBuffer("pvpsindtoiva", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("pvpsindtoiva2", curLinea));
  curLinea.setValueBuffer("pvptotal", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("pvptotal", curLinea));
  curLinea.setValueBuffer("pvptotaliva", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("pvptotaliva", curLinea));

  if (idPromo && idPromo != "" && idPromo != 0) {
    curLinea.setValueBuffer("idpromo", idPromo);
    curLinea.setValueBuffer("desccortapromo", resultados["desccortapromo"]);
  }

  if (flfactppal.iface.pub_extension("sincro_tpv")) {
    curLinea.setValueBuffer("codcomanda", cursor.valueBuffer("codigo"));
    curLinea.setValueBuffer("idsincro", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("idsincro", curLinea));
  }
  if (flfactppal.iface.pub_extension("tpv_multitienda")) {
    curLinea.setValueBuffer("codtienda", cursor.valueBuffer("codtienda"));
  }

}

function promocionesTpv_ordenaPromocion(p1, p2)
{
  if (flfactppal.iface.pub_extension("tallcol_barcode")) {
    if (p1["barcode"] > p2["barcode"]) {
      return 1;
    } else if (p1["barcode"] < p2["barcode"]) {
      return -1;
    }
  }
  if (p1["referencia"] > p2["referencia"]) {
    return 1;
  } else if (p1["referencia"] < p2["referencia"]) {
    return -1;
  }
  if (p1["pvpunitarioiva"] > p2["pvpunitarioiva"]) {
    return 1;
  } else if (p1["pvpunitarioiva"] < p2["pvpunitarioiva"]) {
    return -1;
  } else if (p1["dtopor"] > p2["dtopor"]) {
    return 1;
  } else if (p1["dtopor"] < p2["dtopor"]) {
    return -1;
  } else {
    return 0;
  }
}

function promocionesTpv_datosLineaVenta()
{
  var _i = this.iface;
  var cursor = this.cursor();
  if (!_i.__datosLineaVenta()) {
    return false;
  }
  var idPromo = _i.calculateField("idpromo");

  if (idPromo && idPromo != "" && idPromo != 0) {
    _i.curLineas.setValueBuffer("idpromo", _i.calculateField("idpromo"));
    _i.curLineas.setValueBuffer("desccortapromo", _i.calculateField("desccortapromo"));
  }
  return true;
}

function promocionesTpv_sumarUno(idLinea)
{
  var _i = this.iface;
  var cursor = this.cursor();
  _i.__sumarUno(idLinea);
  var idPromo = AQUtil.sqlSelect("tpv_lineascomanda", "idpromo", "idtpv_linea = " + idLinea);
  if (idPromo && idPromo != "" && idPromo != 0) {
    if (!_i.aplicarPromocion(idPromo)) {
      return false;
    }
  }
  _i.calcularTotalesPromo();
  return true;
}

function promocionesTpv_restarUno(idLinea)
{
  var _i = this.iface;
  var cursor = this.cursor();
  if (!idLinea) {
    return false;
  }
  var idPromo = AQUtil.sqlSelect("tpv_lineascomanda", "idpromo", "idtpv_linea = " + idLinea);
  var referencia = AQUtil.sqlSelect("tpv_lineascomanda", "referencia", "idtpv_linea = " + idLinea);
  _i.__restarUno(idLinea);
  if (idPromo) {
    var quedanLineasPromo = AQUtil.sqlSelect("tpv_lineascomanda", "idpromo", "idpromo = '" + idPromo + "' AND referencia = '" + referencia + "'");
    if (quedanLineasPromo) {
      if (!_i.aplicarPromocion(idPromo)) {
        return false;
      }
    }
  }

  _i.calcularTotalesPromo();
  return true;
}

function promocionesTpv_dameIdArticuloPromo(q)
{
  if (flfactppal.iface.pub_extension("tallcol_barcode")) {
    return q.value("barcode");
  }
  return q.value("referencia");
}

//// PROMOCIONES TPV /////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
