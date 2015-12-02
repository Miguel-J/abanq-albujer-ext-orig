
/** @class_declaration ivaNav */
/////////////////////////////////////////////////////////////////
//// IVA NAV ////////////////////////////////////////////////////
class ivaNav extends oficial
{
  var gruposIvaNeg_, iGruposIvaNeg_, codGrupoIvaNegAnt_;
  var totalCuota_, totalCuotaRev_, totalBase_, totalCuotaGN_, totalCuotaRevGN_, totalBaseGN_, muestraBase_;
  function ivaNav(context)
  {
    oficial(context);
  }
  function acumularGruposIvaEmi(nodo, campo)
  {
    return this.ctx.ivaNav_acumularGruposIvaEmi(nodo, campo);
  }
  function acumularGruposIvaRec(nodo, campo)
  {
    return this.ctx.ivaNav_acumularGruposIvaRec(nodo, campo);
  }
  function iniciarValores(nodo, campo)
  {
    return this.ctx.ivaNav_iniciarValores(nodo, campo);
  }
  function ordenarAcumGruposIva()
  {
    return this.ctx.ivaNav_ordenarAcumGruposIva();
  }
  function compararAcumGruposIva(a, b)
  {
    return this.ctx.ivaNav_compararAcumGruposIva(a, b);
  }
  function mostrarGruposIva(nodo, campo)
  {
    return this.ctx.ivaNav_mostrarGruposIva(nodo, campo);
  }
  function cabeceraInforme(nodo, campo)
  {
    return this.ctx.ivaNav_cabeceraInforme(nodo, campo);
  }
  function totalGrupoIva(nodo, campo)
  {
    return this.ctx.ivaNav_totalGrupoIva(nodo, campo);
  }
  function baseImponibleEmiRec(nodo, campo)
  {
    return this.ctx.ivaNav_baseImponibleEmiRec(nodo, campo);
  }
}
//// IVA NAV ////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition ivaNav */
/////////////////////////////////////////////////////////////////
//// IVA NAV ////////////////////////////////////////////////////
function ivaNav_acumularGruposIvaEmi(nodo, campo)
{
  var _i = this.iface;
  var codGrupoIvaNeg = nodo.attributeValue("co_partidas.codgrupoivaneg");
  if (codGrupoIvaNeg != _i.codGrupoIvaNegAnt_) {
    _i.totalBaseGN_ = 0;
    _i.totalCuotaGN_ = 0;
    _i.totalCuotaRevGN_ = 0;
  }
  var codImpuesto = nodo.attributeValue("co_partidas.codimpuesto");
  var ivaCod = nodo.attributeValue("co_partidas.iva");
  var recargoCod = nodo.attributeValue("co_partidas.recargo");
  var codId = codGrupoIvaNeg + " - " + codImpuesto + " - " + ivaCod + "% - " + recargoCod + "%";
  var valor;
  var indice;
  var base = 0, cuota = 0;
  var iva = parseFloat(nodo.attributeValue("co_partidas.iva"));
  iva = isNaN(iva) ? 0 : iva;
  cuota = parseFloat(nodo.attributeValue("(co_partidas.haber - co_partidas.debe)"))
  if (codId in _i.iGruposIvaNeg_) {
    indice = _i.iGruposIvaNeg_[codId];
    if (!_i.gruposIvaNeg_[indice]["recargo"] || nodo.attributeValue("co_partidas.codsubcuenta") != _i.gruposIvaNeg_[indice]["codsubcuentarec"] || iva != 0) { /// Añadido IVA != 0 para partidas importadas de Euromoda
      base = parseFloat(nodo.attributeValue("co_partidas.baseimponible"));
    }
    _i.gruposIvaNeg_[indice]["base"] += base;
    _i.gruposIvaNeg_[indice]["cuota"] += cuota;
  } else {
    indice = _i.gruposIvaNeg_.length;
    _i.iGruposIvaNeg_[codId] = indice;
    _i.gruposIvaNeg_[indice] = new Object;
    _i.gruposIvaNeg_[indice]["nombre"] = codId;
    _i.gruposIvaNeg_[indice]["base"] = base;
    _i.gruposIvaNeg_[indice]["cuota"] = cuota;
    _i.gruposIvaNeg_[indice]["recargo"] = false;
    _i.gruposIvaNeg_[indice]["codsubcuentarec"] = "";
    if (parseFloat(AQUtil.sqlSelect("gruposcontablesivaproneg", "recargo", "codimpuesto = '" + codImpuesto + "' AND codgrupoivaneg = '" + codGrupoIvaNeg + "'")) != 0) {
      _i.gruposIvaNeg_[indice]["recargo"] = true;
      _i.gruposIvaNeg_[indice]["codsubcuentarec"] = AQUtil.sqlSelect("gruposcontablesivaproneg", "codsubcuentarec", "codimpuesto = '" + codImpuesto + "' AND codgrupoivaneg = '" + codGrupoIvaNeg + "'");
    }
    if (!_i.gruposIvaNeg_[indice]["recargo"] || nodo.attributeValue("co_partidas.codsubcuenta") != _i.gruposIvaNeg_[indice]["codsubcuentarec"] || iva != 0) { /// Añadido IVA != 0 para partidas importadas de Euromoda
      base = parseFloat(nodo.attributeValue("co_partidas.baseimponible"));
    } else {
      base = 0;
    }
    _i.gruposIvaNeg_[indice]["base"] = base;
    _i.gruposIvaNeg_[indice]["cuota"] = cuota;
  }
  _i.totalBase_ += base;
  _i.totalCuota_ += cuota;
  _i.totalBaseGN_ += base;
  _i.totalCuotaGN_ += cuota;
  _i.codGrupoIvaNegAnt_ = codGrupoIvaNeg;
  _i.muestraBase_ = (base != 0);
  return "";
}

function ivaNav_acumularGruposIvaRec(nodo, campo)
{
  var _i = this.iface;
  var codGrupoIvaNeg = nodo.attributeValue("co_partidas.codgrupoivaneg");
  if (codGrupoIvaNeg != _i.codGrupoIvaNegAnt_) {
    _i.totalBaseGN_ = 0;
    _i.totalCuotaGN_ = 0;
    _i.totalCuotaRevGN_ = 0;
  }
  var codImpuesto = nodo.attributeValue("co_partidas.codimpuesto");
  var ivaCod = nodo.attributeValue("co_partidas.iva");
  var recargoCod = nodo.attributeValue("co_partidas.recargo");
  var codId = codGrupoIvaNeg + " - " + codImpuesto + " - " + ivaCod + "% - " + recargoCod + "%";
  var valor;
  var indice;
  var base = 0, cuota = 0;
  base = parseFloat(nodo.attributeValue("co_partidas.baseimponible"));
  cuota = parseFloat(nodo.attributeValue("(co_partidas.debe - co_partidas.haber)"));
  debug("cuota " + cuota);
  if (codId in _i.iGruposIvaNeg_) {
    indice = _i.iGruposIvaNeg_[codId];
    //    if (!_i.gruposIvaNeg_[indice]["reversion"] || nodo.attributeValue("co_partidas.codsubcuenta") != _i.gruposIvaNeg_[indice]["codsubcuentarev"]) {
    //      base = parseFloat(nodo.attributeValue("co_partidas.baseimponible"));
    //    }
    //    cuota = parseFloat(nodo.attributeValue("(co_partidas.debe - co_partidas.haber)"));
    //    _i.gruposIvaNeg_[indice]["base"] += base;
    //    _i.gruposIvaNeg_[indice]["cuota"] += cuota;
  } else {
    indice = _i.gruposIvaNeg_.length;

    _i.iGruposIvaNeg_[codId] = indice;
    _i.gruposIvaNeg_[indice] = new Object;
    _i.gruposIvaNeg_[indice]["nombre"] = codId;
    _i.gruposIvaNeg_[indice]["reversion"] = false;
    _i.gruposIvaNeg_[indice]["codsubcuentarev"] = "";

    _i.gruposIvaNeg_[indice]["base"] = 0;
    _i.gruposIvaNeg_[indice]["cuota"] = 0;
    _i.gruposIvaNeg_[indice]["cuotarev"] = 0;
    if (nodo.attributeValue("gpn.tipocalculo") == "Reversión") {
      _i.gruposIvaNeg_[indice]["reversion"] = true;
      _i.gruposIvaNeg_[indice]["codsubcuentarev"] = nodo.attributeValue("gpn.codsubcuentarev");
    }
  }
  if (!_i.gruposIvaNeg_[indice]["reversion"] || nodo.attributeValue("co_partidas.codsubcuenta") != _i.gruposIvaNeg_[indice]["codsubcuentarev"]) {
    _i.gruposIvaNeg_[indice]["base"] += base;
    _i.gruposIvaNeg_[indice]["cuota"] += cuota;
    _i.totalCuotaGN_ += cuota;
  } else {
    base = 0;
    _i.gruposIvaNeg_[indice]["cuotarev"] += cuota;
    _i.totalCuotaRevGN_ += cuota;
  }
  _i.totalBase_ += base;
  _i.totalBaseGN_ += base;
  _i.totalCuota_ += cuota;
  _i.codGrupoIvaNegAnt_ = codGrupoIvaNeg;
  _i.muestraBase_ = (base != 0);
  return "";
}

function ivaNav_iniciarValores(nodo, campo)
{
  var _i = this.iface;
  _i.totalBase_ = 0;
  _i.totalCuota_ = 0;
  _i.totalCuotaRev_ = 0;
  _i.__iniciarValores(nodo, campo);
  _i.iGruposIvaNeg_ = new Object;
  _i.gruposIvaNeg_ = [];
  _i.codGrupoIvaNegAnt_ = false;
}

function ivaNav_ordenarAcumGruposIva()
{
  var _i = this.iface;
  _i.gruposIvaNeg_.sort(_i.compararAcumGruposIva);
}

function ivaNav_compararAcumGruposIva(a, b)
{
  if (a["nombre"] > b["nombre"]) {
    return 1;
  } else if (a["nombre"] < b["nombre"]) {
    return -1
  } else {
    return 0;
  }
}

function ivaNav_mostrarGruposIva(nodo, campo)
{
  var _i = this.iface;
  var valor: String = "";
  switch (campo) {
    case "nombres": {
      for (var i = 0; i < _i.gruposIvaNeg_.length; i++) {
        valor += _i.gruposIvaNeg_[i]["nombre"] + "\n";
        if ("reversion" in _i.gruposIvaNeg_[i]) {
          valor += _i.gruposIvaNeg_[i]["reversion"] ? "\n" : "";
        }
      }
      break;
    }
    case "bases": {
      for (var i = 0; i < _i.gruposIvaNeg_.length; i++) {
        valor += AQUtil.roundFieldValue(_i.gruposIvaNeg_[i]["base"], "co_partidas", "baseimponible") + "\n";
        if ("reversion" in _i.gruposIvaNeg_[i]) {
          valor += _i.gruposIvaNeg_[i]["reversion"] ? "\n" : "";
        }
      }
      break;
    }
    case "cuotas": {
      for (var i = 0; i < _i.gruposIvaNeg_.length; i++) {
        valor += AQUtil.roundFieldValue(_i.gruposIvaNeg_[i]["cuota"], "co_partidas", "debe") + "\n";
        if ("reversion" in _i.gruposIvaNeg_[i]) {
          valor += _i.gruposIvaNeg_[i]["reversion"] ? (AQUtil.roundFieldValue(_i.gruposIvaNeg_[i]["cuotarev"], "co_partidas", "debe") + "\n") : "";
        }
      }
      break;
    }
  }
  return valor;
}

function ivaNav_cabeceraInforme(nodo, campo)
{
  var _i = this.iface;
  var texCampo = new String(campo);
  var texto;

  switch (texCampo) {
    case "facturasemi":
    case "facturasrec": {
      var desc: String;
      var ejAct, ejAnt;
      var fchDesde, fchHasta;
      var fchDesdeAnt, fchHastaAnt;
      var sctDesde, sctHasta;
      var asiDesde, asiHasta;

      var sep = "       ";

      var qCondiciones = new FLSqlQuery();
      qCondiciones.setTablesList(this.iface.nombreInformeActual);
      qCondiciones.setFrom(this.iface.nombreInformeActual);
      qCondiciones.setWhere("id = " + this.iface.idInformeActual);
      qCondiciones.setSelect("descripcion,i_co__asientos_codejercicio,d_co__asientos_fecha,h_co__asientos_fecha");

      if (!qCondiciones.exec()) {
        return "";
      }
      if (!qCondiciones.first()) {
        return "";
      }
      desc = qCondiciones.value(0);
      ejAct = qCondiciones.value(1);
      fchDesde = qCondiciones.value(2).toString().left(10);
      fchHasta = qCondiciones.value(3).toString().left(10);
      fchDesde = AQUtil.dateAMDtoDMA(fchDesde);
      fchHasta = AQUtil.dateAMDtoDMA(fchHasta);

      texto = "[ " + desc + " ]" + sep + "Ejercicio " + ejAct + sep + "Periodo  " + fchDesde + " - " + fchHasta;
      break;
    }
    default: {
      texto = _i.__cabeceraInforme(nodo, campo);
    }
  }
  return texto;
}

function ivaNav_totalGrupoIva(nodo, campo)
{
  var _i = this.iface;
  var valor = "";
  switch (campo) {
    case "cuota": {
      valor = _i.totalCuota_;
      break;
    }
    case "cuotarev": {
      valor = _i.totalCuotaRev_;
      break;
    }
    case "base": {
      valor = _i.totalBase_;
      break;
    }
    case "cuotagn": {
      valor = _i.totalCuotaGN_;
      break;
    }
    case "cuotarevgn": {
      valor = _i.totalCuotaRevGN_;
      break;
    }
    case "basegn": {
      valor = _i.totalBaseGN_;
      break;
    }
  }
  return valor;
}

function ivaNav_baseImponibleEmiRec(nodo, campo)
{
  var _i = this.iface;
  var base = "";
  if (_i.muestraBase_) {
    base = nodo.attributeValue("co_partidas.baseimponible");
    base = AQUtil.roundFieldValue(base, "co_partidas", "baseimponible");
    base = AQUtil.formatoMiles(base);
  }
  return base;
}
//// IVA NAV ////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
