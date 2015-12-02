
/** @class_declaration agTrans */
/////////////////////////////////////////////////////////////////
//// AGENCIAS TRANSPORTE ////////////////////////////////////////
class agTrans extends pobla
{
  function agTrans(context)
  {
    pobla(context);
  }
  function obtenerPortesMinimos(peso: Number, idPoblacion: String, idProvincia: String, codPais: String): Number {
    return this.ctx.agTrans_obtenerPortesMinimos(peso, idPoblacion, idProvincia, codPais);
  }
  function obtenerPortesAgencia(codAgencia: String, peso: Number, idPoblacion: String, idProvincia: String, codPais: String): Number {
    return this.ctx.agTrans_obtenerPortesAgencia(codAgencia, peso, idPoblacion, idProvincia, codPais);
  }
  function obtenerZona(codAgencia: String, idPoblacion: String, idProvincia: String, codPais: String): Array {
    return this.ctx.agTrans_obtenerZona(codAgencia, idPoblacion, idProvincia, codPais);
  }
  function obtenerPortesZona(codAgencia: String, datosZona: Array, peso: Number): Number {
    return this.ctx.agTrans_obtenerPortesZona(codAgencia, datosZona, peso);
  }
}
//// AGENCIAS TRANSPORTE ////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pub_agTrans */
/////////////////////////////////////////////////////////////////
//// PUB_AGENCIAS TRANSPORTE ////////////////////////////////////
class pub_agTrans extends pub_pobla
{
  function pub_agTrans(context)
  {
    pub_pobla(context);
  }
  function pub_obtenerPortesAgencia(codAgencia: String, peso: Number, idPoblacion: String, idProvincia: String, codPais: String): Number {
    return this.obtenerPortesAgencia(codAgencia, peso, idPoblacion, idProvincia, codPais);
  }
  function pub_obtenerPortesMinimos(peso: Number, idPoblacion: String, idProvincia: String, codPais: String): Number {
    return this.obtenerPortesMinimos(peso, idPoblacion, idProvincia, codPais);
  }
}
//// PUB_AGENCIAS TRANSPORTE ////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition agTrans */
/////////////////////////////////////////////////////////////////
//// AGENCIAS TRANSPORTE ////////////////////////////////////////
function agTrans_obtenerPortesMinimos(peso: Number, idPoblacion: String, idProvincia: String, codPais: String): Array {
  var qryAgencias: FLSqlQuery = new FLSqlQuery;
  qryAgencias.setTablesList("agenciastrans");
  qryAgencias.setSelect("codagencia");
  qryAgencias.setFrom("agenciastrans");
  qryAgencias.setWhere("");
  qryAgencias.setForwardOnly(true);

  if (!qryAgencias.exec())
  {
    return false;
  }

  var portesMin: Number = 0;
  var portes: Number;
  var codAgenciaMin: String;
  while (qryAgencias.next())
  {
    debug("Agencia " + qryAgencias.value("codagencia"));
    portes = this.iface.obtenerPortesAgencia(qryAgencias.value("codagencia"), peso, idPoblacion, idProvincia, codPais);
    debug("Portes " + portes + " . Min " + portesMin);
    if (portes && (portesMin == 0 || portes < portesMin)) {
      debug("Min");
      portesMin = portes;
      codAgenciaMin = qryAgencias.value("codagencia");
    }
  }

  var datosPortes: Array;
  datosPortes["codagencia"] = codAgenciaMin;
  datosPortes["portes"] = portesMin;
  return datosPortes;
}

function agTrans_obtenerPortesAgencia(codAgencia: String, peso: Number, idPoblacion: String, idProvincia: String, codPais: String): Number {
  var util: FLUtil;
  var datosZona: Array = this.iface.obtenerZona(codAgencia, idPoblacion, idProvincia, codPais);
  if (!datosZona)
  {
    return false;
  }
  var portes: Number = this.iface.obtenerPortesZona(codAgencia, datosZona, peso);

  return portes;
}

function agTrans_obtenerZona(codAgencia: String, idPoblacion: String, idProvincia: String, codPais: String): Array {
  var datosZona: Array = [];
  var qryZonas: FLSqlQuery = new FLSqlQuery;
  qryZonas.setTablesList("zonasgeo,zonastrans");
  qryZonas.setSelect("zg.codzona, zg.reexpedicion");
  qryZonas.setFrom("zonasgeo zg INNER JOIN zonastrans zt ON zg.codzona = zt.codzona");

  if (idPoblacion)
  {
    qryZonas.setWhere("zt.codagencia = '" + codAgencia + "' AND zg.idpoblacion = " + idPoblacion);
    qryZonas.setForwardOnly(true);
    if (!qryZonas.exec()) {
      return false;
    }
    if (qryZonas.first()) {
      datosZona["codzona"] = qryZonas.value("zg.codzona");
      datosZona["reexpedicion"] = qryZonas.value("zg.reexpedicion");
      return datosZona;
    }
  }
  if (idProvincia)
  {
    qryZonas.setWhere("zt.codagencia = '" + codAgencia + "' AND zg.idpoblacion IS NULL AND idprovincia = " + idProvincia);
    qryZonas.setForwardOnly(true);
    if (!qryZonas.exec()) {
      return false;
    }
    if (qryZonas.first()) {
      datosZona["codzona"] = qryZonas.value("zg.codzona");
      datosZona["reexpedicion"] = qryZonas.value("zg.reexpedicion");
      return datosZona;
    }
  }
  if (codPais)
  {
    qryZonas.setWhere("zt.codagencia = '" + codAgencia + "' AND zg.idpoblacion IS NULL AND idprovincia IS NULL AND codpais = '" + codPais + "'");
    qryZonas.setForwardOnly(true);
    if (!qryZonas.exec()) {
      return false;
    }
    if (qryZonas.first()) {
      datosZona["codzona"] = qryZonas.value("zg.codzona");
      datosZona["reexpedicion"] = qryZonas.value("zg.reexpedicion");
      return datosZona;
    }
  }
  return false;
}

function agTrans_obtenerPortesZona(codAgencia: String, datosZona: Array, peso: Number): Number {
  var qryPortes: FLSqlQuery = new FLSqlQuery;
  qryPortes.setTablesList("zonaspesoagencia,zonastrans");
  qryPortes.setSelect("zpa.precio, zpa.reexpedicion, at.tipoprecios, zt.preciominimo");
  qryPortes.setFrom("zonaspesoagencia zpa INNER JOIN zonastrans zt ON zpa.codzona = zt.codzona INNER JOIN agenciastrans at ON zt.codagencia = at.codagencia");
  qryPortes.setWhere("zpa.codzona = '" + datosZona["codzona"] + "' AND zpa.pesomin <= " + peso + " AND zpa.pesomax >= " + peso);
  qryPortes.setForwardOnly(true);

  if (!qryPortes.exec())
  {
    return false;
  }

  if (!qryPortes.first())
  {
    return false;
  }

  var precioMinimo: Number = qryPortes.value("zt.preciominimo");
  if (!precioMinimo || isNaN(precioMinimo))
  {
    precioMinimo = -1;
  }
  var tipoPrecios: String = qryPortes.value("at.tipoprecios");
  var portes: Number;
  if (tipoPrecios == "Total")
  {
    portes = parseFloat(qryPortes.value("zpa.precio"));
  } else {
    portes = parseFloat(qryPortes.value("zpa.precio")) * peso;
  }
  if (datosZona["reexpedicion"])
  {
    /// La reexpedición SEUR (creo que todas) no implica multiplicar por precio. Si hay que hacerlo habrá que poner un campo TipoPreciosReexp
    //    if (tipoPrecios == "Total") {
    portes += parseFloat(qryPortes.value("zpa.reexpedicion"));
    //    } else {
    //      portes += parseFloat(qryPortes.value("zpa.reexpedicion")) * peso;
    //    }
  }
  if (precioMinimo > 0 && portes < precioMinimo)
  {
    portes = precioMinimo;
  }

  return portes;
}
//// AGENCIAS TRANSPORTE ////////////////////////////////////////
////////////////////////////////////////////////////////////////
