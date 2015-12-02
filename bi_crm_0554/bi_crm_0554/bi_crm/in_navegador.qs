
/** @class_declaration biCrm */
/////////////////////////////////////////////////////////////////
//// BI_CRM /////////////////////////////////////////////////////
class biCrm extends oficial
{
  function biCrm(context)
  {
    oficial(context);
  }
  function nombreCubo(idCubo: String): String {
    return this.ctx.biCrm_nombreCubo(idCubo);
  }
  function informarArrayCubos(aCubos: Array): Boolean {
    return this.ctx.biCrm_informarArrayCubos(aCubos);
  }
  function cargarCubo(): Boolean {
    return this.ctx.biCrm_cargarCubo();
  }
  function cargarCuboIncidencias(): Boolean {
    return this.ctx.biCrm_cargarCuboIncidencias();
  }
}
//// BI_CRM /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition biCrm */
/////////////////////////////////////////////////////////////////
//// BI_CRM /////////////////////////////////////////////////////
function biCrm_nombreCubo(idCubo: String): String {
  var util: FLUtil = new FLUtil;
  var nombre: String;
  switch (idCubo)
  {
    case "in_h_incidencias": {
      nombre = util.translate("scripts", "C.R.M.");
      break;
    }
    default: {
      nombre = this.iface.__nombreCubo(idCubo);
    }
  }
  return nombre;
}

function biCrm_informarArrayCubos(aCubos: Array): Boolean {
  this.iface.__informarArrayCubos(aCubos);

  aCubos[aCubos.length] = "in_h_incidencias";
  return true;
}

function biCrm_cargarCubo(): Boolean {
  switch (this.iface.cubo_)
  {
    case "in_h_incidencias": {
      if (!this.iface.cargarCuboIncidencias()) {
        return false;
      }
      break;
    }
    default: {
      if (!this.iface.cargarCubo()) {
        return false;
      }
    }
  }
  return true;
}

function biCrm_cargarCuboIncidencias(): Boolean {
  var util: FLUtil = new FLUtil;
  var curIncidencias: FLSqlCursor = (this.iface.conexionBI_ ? new FLSqlCursor("in_h_incidencias", this.iface.conexionBI_) : new FLSqlCursor("in_h_incidencias"));

  var anoDesde: Number = parseInt(fldireinne.iface.pub_valorConfiguracion("anomin"));
  var anoHasta: Number = parseInt(fldireinne.iface.pub_valorConfiguracion("anomax"));
  if (isNaN(anoDesde) || isNaN(anoHasta))
  {
    MessageBox.warning(util.translate("scripts", "No tiene definidos los años mínimo y/o máximo en el formulario de configuración del módulo"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }

  var util: FLUtil = new FLUtil;
  var opciones: Array = [];
  var indice: Number = 0;

  for (var ano: Number = anoDesde; ano <= anoHasta; ano++)
  {
    opciones[indice] = [];
    opciones[indice][0] = ano;
    opciones[indice][1] = "";
    indice++;
  }

  var anos: String = this.iface.obtenerOpcionEF(opciones);
  if (anos == "")
  {
    return false;
  }

  curIncidencias.select("SUBSTR(d_mes, 1, 4) IN (" + anos + ")");
  util.createProgressDialog(util.translate("scripts", "Borrando cubo"), curIncidencias.size());
  var paso: Number = 0;
  while (curIncidencias.next())
  {
    curIncidencias.setModeAccess(curIncidencias.Del);
    curIncidencias.refreshBuffer();
    if (!curIncidencias.commitBuffer()) {
      return false;
    }
    util.setProgress(paso++);
  }
  util.destroyProgressDialog();

  var qryIncidencias: FLSqlQuery;
  if (this.iface.conexion_)
  {
    qryIncidencias = new FLSqlQuery("", this.iface.conexion_);
  } else {
    qryIncidencias = new FLSqlQuery();
  }
  qryIncidencias.setTablesList("crm_incidencias,crm_subcatincidencias");
  qryIncidencias.setSelect("SUM(sc.valor), COUNT(i.codincidencia), i.codcliente, i.fecha, i.codcategoria, i.codsubcategoria, i.idusuario, i.estado");
  qryIncidencias.setFrom("crm_incidencias i INNER JOIN crm_subcatincidencias sc ON i.codsubcategoria = sc.codsubcategoria");
  qryIncidencias.setWhere("EXTRACT(YEAR FROM i.fecha) IN (" + anos + ") GROUP BY i.codcliente, i.fecha, i.codcategoria, i.codsubcategoria, i.idusuario, i.estado");
  qryIncidencias.setForwardOnly(true);
  debug(qryIncidencias.sql());
  if (!qryIncidencias.exec())
  {
    debug("error");
    return false;
  }

  util.createProgressDialog(util.translate("scripts", "Creando cubo"), qryIncidencias.size());
  paso = 0;
  var fecha: Date;
  var mes: String;
  var anno: String;
  while (qryIncidencias.next())
  {
    curIncidencias.setModeAccess(curIncidencias.Insert);
    curIncidencias.refreshBuffer();
    curIncidencias.setValueBuffer("m_valor", qryIncidencias.value("SUM(sc.valor)"));
    curIncidencias.setValueBuffer("m_cantidad", qryIncidencias.value("COUNT(i.codincidencia)"));
    curIncidencias.setValueBuffer("d_codcliente", qryIncidencias.value("i.codcliente"));
    curIncidencias.setValueBuffer("d_codcategoria", qryIncidencias.value("i.codcategoria"));
    curIncidencias.setValueBuffer("d_codsubcategoria", qryIncidencias.value("i.codsubcategoria"));
    curIncidencias.setValueBuffer("d_idusuario", qryIncidencias.value("i.idusuario"));
    curIncidencias.setValueBuffer("d_estado", qryIncidencias.value("i.estado"));
    fecha = qryIncidencias.value("i.fecha");
    mes = fecha.getMonth().toString();
    if (mes.length == 1) {
      mes = "0" + mes;
    }
    anno = fecha.getYear().toString();
    mes = anno + mes;
    curIncidencias.setValueBuffer("d_mes", mes);
    if (!curIncidencias.commitBuffer()) {
      return false;
    }
    util.setProgress(paso++);
  }
  util.destroyProgressDialog();
  return true;
}

//// BI_CRM /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
