
/** @class_declaration liqAgentes */
/////////////////////////////////////////////////////////////////
//// LIQUIDACIÓN A AGENTES //////////////////////////////////////
class liqAgentes extends oficial
{
  function liqAgentes(context)
  {
    oficial(context);
  }
  function calcularLiquidacionAgente(where: String, docLiquidacion: String): Number {
    return this.ctx.liqAgentes_calcularLiquidacionAgente(where, docLiquidacion);
  }
  function obtenFiltroFacturas(codAgente: String, desde: String, hasta: String, codEjercicio: String, docLiquidacion: String): String {
    return this.ctx.liqAgentes_obtenFiltroFacturas(codAgente, desde, hasta, codEjercicio, docLiquidacion);
  }
  function asociarFacturasLiq(filtro: String, codLiquidacion: String, docLiquidacion: String): Boolean {
    return this.ctx.liqAgentes_asociarFacturasLiq(filtro, codLiquidacion, docLiquidacion);
  }
  function asociarFacturaLiq(idFactura: String, codLiquidacion: String, docLiquidacion: String): Boolean {
    return this.ctx.liqAgentes_asociarFacturaLiq(idFactura, codLiquidacion, docLiquidacion);
  }
}
//// LIQUIDACIÓN A AGENTES //////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pubLiqAgentes */
/////////////////////////////////////////////////////////////////
//// PUB LIQ AGENTES ////////////////////////////////////////////
class pubLiqAgentes extends ifaceCtx
{
  function pubLiqAgentes(context)
  {
    ifaceCtx(context);
  }
  function pub_calcularLiquidacionAgente(where: String, docLiquidacion: String): Boolean {
    return this.calcularLiquidacionAgente(where, docLiquidacion);
  }
  function pub_obtenFiltroFacturas(codAgente: String, desde: String, hasta: String, codEjercicio: String, docLiquidacion: String): String {
    return this.obtenFiltroFacturas(codAgente, desde, hasta, codEjercicio, docLiquidacion);
  }
  function pub_asociarFacturasLiq(filtro: String, codLiquidacion: String, docLiquidacion: String): Boolean {
    return this.asociarFacturasLiq(filtro, codLiquidacion, docLiquidacion);
  }
  function pub_asociarFacturaLiq(idFactura: String, codLiquidacion: String, docLiquidacion): Boolean {
    return this.asociarFacturaLiq(idFactura, codLiquidacion, docLiquidacion);
  }
}
//// PUB LIQ AGENTES ////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition liqAgentes */
/////////////////////////////////////////////////////////////////
//// LIQUIDACIÓN A AGENTES //////////////////////////////////////
function liqAgentes_calcularLiquidacionAgente(where: String, docLiquidacion: String): Number {
  var _i = this.iface;
  var util = new FLUtil();

  var tablaDoc, tablaLineaDoc: String, claveTablaDoc: String;
  switch (docLiquidacion)
  {
    case "Albaranes": {
      tablaDoc = "albaranescli";
      tablaLineaDoc = "lineasalbaranescli";
      claveTablaDoc = "idalbaran";
      break;
    }
    default: {
      tablaDoc = "facturascli";
      tablaLineaDoc = "lineasfacturascli";
      claveTablaDoc = "idfactura";
      break;
    }
  }

  var qryDoc: FLSqlQuery = new FLSqlQuery();
  qryDoc.setTablesList(tablaDoc + "," + tablaLineaDoc);
  qryDoc.setSelect("coddivisa, tasaconv, " + tablaDoc + ".porcomision, " + tablaLineaDoc + ".porcomision, neto, " + tablaDoc + "." + claveTablaDoc + ", " + tablaLineaDoc + ".pvptotal");
  qryDoc.setFrom(tablaDoc + " INNER JOIN " + tablaLineaDoc + " ON " + tablaDoc + "." + claveTablaDoc + " = " + tablaLineaDoc + "." + claveTablaDoc);
  qryDoc.setWhere(where);
  qryDoc.setForwardOnly(true);
  debug("liqAgentes_calcularLiquidacionAgente");
  debug(qryDoc.sql());
  if (!qryDoc.exec())
  {
    return false;
  }
  var total: Number = 0;
  var comision: Number = 0;
  var descuento, factorDto;
  var tasaconv: Number = 0;
  var divisaEmpresa: String = util.sqlSelect("empresa", "coddivisa", "1 = 1");
  var idDoc: Number = 0;
  var comisionDoc: Boolean = false;
  var extDescuento = _i.extension("dto_especial");
  while (qryDoc.next())
  {
    if (!idDoc || idDoc != qryDoc.value(tablaDoc + "." + claveTablaDoc)) {
      idfactura = qryDoc.value(tablaDoc + "." + claveTablaDoc);
      if (parseFloat(qryDoc.value(tablaDoc + ".porcomision"))) {
        comisionDoc = true;
        comision = parseFloat(qryDoc.value(tablaDoc + ".porcomision")) * parseFloat(qryDoc.value("neto")) / 100;
        tasaconv = parseFloat(qryDoc.value("tasaconv"));
        if (qryDoc.value("coddivisa") == divisaEmpresa) {
          total += comision;
        } else {
          total += comision * tasaconv;
        }
      } else {
        comisionDoc = false;
      }
    }
    if (!comisionDoc) {
      descuento = extDescuento ? parseFloat(qryFacturas.value(tablaLineaDoc + ".pordtoesp")) : 0;
      factorDto = (isNaN(descuento) ? 1 : ((100 - descuento) / 100));
      //      comision = parseFloat(qryFacturas.value("lineasfacturascli.porcomision")) * (parseFloat(qryFacturas.value("lineasfacturascli.pvptotal") * factorDto)) / 100;

      comision = parseFloat(qryDoc.value(tablaLineaDoc + ".porcomision")) * parseFloat(qryDoc.value(tablaLineaDoc + ".pvptotal") * factorDto) / 100;
      tasaconv = parseFloat(qryDoc.value("tasaconv"));
      if (qryDoc.value("coddivisa") == divisaEmpresa) {
        total += comision;
      } else {
        total += comision * tasaconv ;
      }
    }
  }
  return total;
}

/** \D Establece el filtro sobre la tabla de facturas que deben cumplir los documentos a incluir en una liquidación
@param  codAgente: Agente
@param  desde: Fecha desde
@param  hasta: Fecha hasta
@param  codEjercicio: Ejercicio (opcional)
@param  docLiquidacion: Tipo de documento
@return filtro
\end */
function liqAgentes_obtenFiltroFacturas(codAgente: String, desde: String, hasta: String, codEjercicio: String, docLiquidacion: String): String {
  var filtro: String;
  var tablaDoc: String, tablaLineaDoc: String, claveTablaDoc: String;
  switch (docLiquidacion)
  {
    case "Albaranes": {
      tablaDoc = "albaranescli";
      tablaLineaDoc = "lineasalbaranescli";
      claveTablaDoc = "idalbaran";
      break;
    }
    default: {
      tablaDoc = "facturascli";
      tablaLineaDoc = "lineasfacturascli";
      claveTablaDoc = "idfactura";
      break;
    }
  }
  filtro = tablaDoc + "." + claveTablaDoc + " IN (SELECT DISTINCT " + tablaDoc + "." + claveTablaDoc + " FROM " + tablaDoc + " INNER JOIN " + tablaLineaDoc + " ON " + tablaDoc + "." + claveTablaDoc + " = " + tablaLineaDoc + "." + claveTablaDoc + " WHERE 1 = 1";
  if (codAgente && codAgente != "")
  {
    filtro += " AND " + tablaDoc + ".codagente = '" + codAgente + "'";
  }
  if (codEjercicio && codEjercicio != "")
  {
    filtro += " AND " + tablaDoc + ".codejercicio = '" + codEjercicio + "'";
  }
  filtro += " AND (" + tablaDoc + ".codliquidacion = '' OR " + tablaDoc + ".codliquidacion IS NULL) AND (" + tablaDoc + ".porcomision > 0 OR " + tablaLineaDoc + ".porcomision > 0) AND " + tablaDoc + ".fecha >= '" + desde + "' AND " + tablaDoc + ".fecha <= '" + hasta + "')";
  debug(filtro);
  return filtro;
}

/** \D Asocia los documentos que cumplen el filtro a la liquidación indicada
@param  filtro: Sentencia where a aplicar sobre la tabla de documentos de cliente
@param  codLiquidación: Código de la liquidación a la que asociar los documentos
@param  docLiquidacion: Tipo de documento
\end */
function liqAgentes_asociarFacturasLiq(filtro: String, codLiquidacion: String, docLiquidacion: String): Boolean {
  var _i = this.iface;
  var util: FLUtil = new FLUtil;

  var tablaDoc: String;
  var claveTablaDoc: String;
  var nombreDoc: String;
  switch (docLiquidacion)
  {
    case "Albaranes": {
      tablaDoc = "albaranescli";
      nombreDoc = util.translate("scripts", "albaranes");
      claveTablaDoc = "idalbaran";
      break;
    }
    default: {
      tablaDoc = "facturascli";
      nombreDoc = util.translate("scripts", "facturas");
      claveTablaDoc = "idfactura";
      if (_i.valorDefecto("liqpagadas")) {
        filtro += " AND NOT facturascli.editable";
      }
      break;
    }
  }
  var qryDocs: FLSqlQuery = new FLSqlQuery;
  qryDocs.setTablesList(tablaDoc);
  qryDocs.setSelect(claveTablaDoc);
  qryDocs.setFrom(tablaDoc);
  qryDocs.setWhere(filtro);
  qryDocs.setForwardOnly(true);
  if (!qryDocs.exec())
  {
    return false;
  }
  util.createProgressDialog(util.translate("scripts", "Asociando %1 pendientes de liquidar...").arg(nombreDoc), qryDocs.size());
  var i: Number = 0;

  while (qryDocs.next())
  {
    if (!this.iface.asociarFacturaLiq(qryDocs.value(claveTablaDoc), codLiquidacion, docLiquidacion)) {
      util.destroyProgressDialog();
      return false;
    }

    util.setProgress(i);
    sys.processEvents();
    i++;
  }

  util.destroyProgressDialog();
  return true;
}

/** \D Asocia un documento a una liquidación de agentes comerciales
@param  idDoc: Identificador del documento
@param  codLiquidacion: Identificador de la liquidación
@param  docLiquidacion: Tipo de documento
@return true si la asociación se raliza correctamente, false en caso contrario
\end */
function liqAgentes_asociarFacturaLiq(idDoc: String, codLiquidacion: String, docLiquidacion: String): Boolean {
  var tablaDoc: String, claveTablaDoc: String, campoLock: String;
  switch (docLiquidacion)
  {
    case "Albaranes": {
      tablaDoc = "albaranescli";
      claveTablaDoc = "idalbaran";
      campoLock = "ptefactura";
      break;
    }
    default: {
      tablaDoc = "facturascli";
      claveTablaDoc = "idfactura";
      campoLock = "editable";
      break;
    }
  }
  var curDoc: FLSqlCursor = new FLSqlCursor(tablaDoc);
  var editable: Boolean = true;

  curDoc.select(claveTablaDoc + " = " + idDoc);
  if (!curDoc.first())
  {
    return false;
  }
  curDoc.setModeAccess(curDoc.Browse);
  curDoc.refreshBuffer();

  curDoc.setActivatedCommitActions(false);
  if (!curDoc.valueBuffer(campoLock))
  {
    editable = false;
    curDoc.setUnLock(campoLock, true);
    curDoc.select(claveTablaDoc + " = " + idDoc);
    if (!curDoc.first())
      return false;
  }

  curDoc.setModeAccess(curDoc.Edit);
  curDoc.refreshBuffer();
  curDoc.setValueBuffer("codliquidacion", codLiquidacion);
  if (!curDoc.commitBuffer())
  {
    return false;
  }
  if (editable == false)
  {
    curDoc.select(claveTablaDoc + " = " + idDoc);
    if (!curDoc.first()) {
      return false;
    }
    curDoc.setUnLock(campoLock, false);
  }

  return true;
}


//// LIQUIDACIÓN A AGENTES //////////////////////////////////////
/////////////////////////////////////////////////////////////////
