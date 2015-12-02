
/** @class_declaration calidadProv */
/////////////////////////////////////////////////////////////////
//// CALIDAD_PROV /////////////////////////////////////////////////
class calidadProv extends oficial
{
  function calidadProv(context)
  {
    oficial(context);
  }
  function afterCommit_seguimientosprov(curSegProv: FLSqlCursor): Boolean {
    return this.ctx.calidadProv_afterCommit_seguimientosprov(curSegProv);
  }
  function beforeCommit_noconformidadesprov(curNoConf: FLSqlCursor): Boolean {
    return this.ctx.calidadProv_beforeCommit_noconformidadesprov(curNoConf);
  }
  function fechaEval(nodo: FLDomNode, campo: String): Boolean {
    return this.ctx.calidadProv_fechaEval(nodo, campo);
  }
}
//// CALIDAD_PROV /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////


/** @class_definition calidadProv */
/////////////////////////////////////////////////////////////////
//// CALIDAD_PROV /////////////////////////////////////////////////

function calidadProv_afterCommit_seguimientosprov(curSegProv)
{
  var nivel, codProveedor, fecha: String;

  codProveedor = curSegProv.valueBuffer("codproveedor");

  var q: FLSqlQuery = new FLSqlQuery();
  q.setFrom("seguimientosprov");
  q.setTablesList("seguimientosprov");
  q.setSelect("fechaevaluacion,resultado");
  q.setWhere("codproveedor = '" + codProveedor + "' order by fechaevaluacion");

  if (!q.exec()) return;
  if (q.first()) { // el primero
    fecha = q.value(0);
    nivel = q.value(1);
  }
  while (q.next()) { // el último
    nivel = q.value(1);
  }

  var curProveedores: FLSqlCursor = new FLSqlCursor("proveedores");
  curProveedores.select("codproveedor = '" + codProveedor + "'");
  if (curProveedores.first()) {
    curProveedores.setModeAccess(curProveedores.Edit);
    curProveedores.refreshBuffer();
    curProveedores.setValueBuffer("nivelactual", nivel);
    curProveedores.setValueBuffer("fechainiciohomol", fecha);
    curProveedores.commitBuffer();
  }
  return true;
}

function calidadProv_beforeCommit_noconformidadesprov(curNoConf)
{
  var util: FLUtil = new FLUtil();
  var curInc: FLSqlCursor = new FLSqlCursor("incidenciasprov");

  switch (curNoConf.modeAccess()) {

    case curNoConf.Edit:
      break;

    case curNoConf.Del:
      var codIncidencia: String = curNoConf.valueBuffer("codincidencia");
      curInc.select("codigo = '" + codIncidencia + "'");
      if (curInc.first()) {
        curInc.setModeAccess(curInc.Del);
        curInc.refreshBuffer();
        curInc.commitBuffer();
      }
      break;

    case curNoConf.Insert:

      var codProveedor: String = curNoConf.valueBuffer("codproveedor");
      var fechaRegistro: String = curNoConf.valueBuffer("fecharegistro");
      var codIncidencia: String = util.nextCounter("codigo", curInc);

      curInc.setModeAccess(curInc.Insert);
      curInc.refreshBuffer();
      curInc.setValueBuffer("codigo", codIncidencia);
      curInc.setValueBuffer("codproveedor", codProveedor);
      curInc.setValueBuffer("fecha", fechaRegistro);
      curInc.setValueBuffer("descripcion", "No conformidad");
      curInc.setValueBuffer("valor", -1);
      curInc.commitBuffer();

      curNoConf.setValueBuffer("codincidencia", codIncidencia);
      break;
  }
  return true;
}

function calidadProv_fechaEval(nodo: FLDomNode, campo: String)
{
  var util: FLUtil = new FLUtil();
  var idEval: Number = nodo.attributeValue("idevaluacion");

  if (idEval) {
    var fecha: String = util.sqlSelect("evalsemestralesprov", "fechaevaluacion", "id = " + idEval);
  } else
    var fecha: String = util.sqlSelect("evalsemestralesprov", "fechaevaluacion", "1=1 order by fechaevaluacion desc");

  if (!fecha)
    return "";

  fecha = util.dateAMDtoDMA(fecha);
  return fecha;
}

//// CALIDAD_PROV /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
