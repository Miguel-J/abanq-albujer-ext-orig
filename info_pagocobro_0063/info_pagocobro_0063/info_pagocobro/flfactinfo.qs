
/** @class_declaration infoPagoCobro */
/////////////////////////////////////////////////////////////////
//// INFO PAGO COBRO //////////////////////////////////////////////////////
class infoPagoCobro extends oficial
{
  var idInformeActual: Number;
  var nombreInformeActual: String;
  function infoPagoCobro(context)
  {
    oficial(context);
  }
  function pcFormasPago(nodo: FLDomNode, campo: String)
  {
    return this.ctx.infoPagoCobro_pcFormasPago(nodo, campo);
  }
  function establecerInformeActual(id: Number)
  {
    return this.ctx.infoPagoCobro_establecerInformeActual(id);
  }
}
//// INFO PAGO COBRO //////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pubInfoPagoCobro */
/////////////////////////////////////////////////////////////////
//// INFO PAGO COBRO //////////////////////////////////////////////////////
class pubInfoPagoCobro extends infoPagoCobro
{
  function pubInfoPagoCobro(context)
  {
    infoPagoCobro(context);
  }
  function pub_pcFormasPago(nodo: FLDomNode, campo: String)
  {
    return this.pcFormasPago(nodo, campo);
  }
  function pub_establecerInformeActual(id: Number)
  {
    return this.establecerInformeActual(id);
  }
}
//// INFO PAGO COBRO //////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition infoPagoCobro */
/////////////////////////////////////////////////////////////////
//// INFO PAGO COBRO //////////////////////////////////////////////////////

function infoPagoCobro_pcFormasPago(nodo: FLDomNode, campo: String)
{
  var texCampo: String = new String(campo);
  var tipoTexto: String = texCampo.left(3);
  var tabla: String, tablaRec: String;

  switch (texCampo) {

    case "tex_cobro":
    case "val_cobro":
      tabla = "i_prevcobros";
      tablaRec = "reciboscli";
      break;

    case "tex_pago":
    case "val_pago":
      tabla = "i_prevpagos";
      tablaRec = "recibosprov";
      break;
  }


  var util: FLUtil = new FLUtil;
  var curTab: FLSqlCursor = new FLSqlCursor(tabla);
  curTab.select("id = " + this.iface.idInformeActual);

  if (!curTab.first())
    return;

  var where: String = "";

  if (curTab.valueBuffer("emitidos"))
    where += tablaRec + ".estado = '" + util.translate("scripts", "Emitido") + "'";

  if (curTab.valueBuffer("pagados")) {
    if (where)  where += " OR";
    where += " " + tablaRec + ".estado = '" + util.translate("scripts", "Pagado") + "'";
  }

  if (curTab.valueBuffer("devueltos")) {
    if (where)  where += " OR";
    where += " " + tablaRec + ".estado = '" + util.translate("scripts", "Devuelto") + "'";
  }

  if (where)
    where = "(" + where + ")";


  var q: FLSqlQuery = this.iface.establecerConsulta(curTab, tabla + "_fp", "formaspago.codpago", "formaspago.codpago", where);

  if (!q.exec()) {
    debug(util.translate("scripts", "Error en la consulta de totales por forma de pago"));
    return "";
  }

  var texto: String = "";

  if (tipoTexto == "tex")
    while (q.next())
      texto += q.value(0) + "\n";
  else
    while (q.next()) {
      valor = util.formatoMiles(Math.round(100 * parseFloat(q.value(1))) / 100);
      texto += valor + "\n";
    }

  return texto;
}

function infoPagoCobro_establecerInformeActual(id: Number)
{
  debug(id);
  this.iface.idInformeActual = id;
}

//// INFO PAGO COBRO //////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
