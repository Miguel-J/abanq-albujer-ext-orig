
/** @class_declaration infMultiidioma */
/////////////////////////////////////////////////////////////////
//// INF_MULTIIDIOMA ////////////////////////////////////////////
class infMultiidioma extends oficial
{
  var codIdiomaInforme_: String;
  function infMultiidioma(context)
  {
    oficial(context);
  }
  function afterCommit_i_tradetiquetasinforme(curEtiqueta: FLSqlCursor): Boolean {
    return this.ctx.infMultiidioma_afterCommit_i_tradetiquetasinforme(curEtiqueta);
  }
  function traducirEtiqueta(nodo: FLDomNode, campo: String): String {
    return this.ctx.infMultiidioma_traducirEtiqueta(nodo, campo);
  }
  function traducirEtiquetaLabel(campo)
  {
    return this.ctx.infMultiidioma_traducirEtiquetaLabel(campo);
  }
  function establecerIdioma(codIdioma: String): Boolean {
    return this.ctx.infMultiidioma_establecerIdioma(codIdioma);
  }
  function porIVA(nodo: FLDomNode, campo: String): String {
    return this.ctx.infMultiidioma_porIVA(nodo, campo);
  }
  function traducirDescripcion(nodo: FLDomNode, campo: String): String {
    return this.ctx.infMultiidioma_traducirDescripcion(nodo, campo);
  }
  function traducirFecha(fecha: Date): String {
    return this.ctx.infMultiidioma_traducirFecha(fecha);
  }
  function obtenerDiaSemana(fecha: Date): String {
    return this.ctx.infMultiidioma_obtenerDiaSemana(fecha);
  }
  function obtenerDiaMes(fecha: Date): String {
    return this.ctx.infMultiidioma_obtenerDiaMes(fecha);
  }
  function obtenerMes(fecha: Date): String {
    return this.ctx.infMultiidioma_obtenerMes(fecha);
  }
  function obtenerAno(fecha: Date): String {
    return this.ctx.infMultiidioma_obtenerAno(fecha);
  }
}
//// INF_MULTIIDIOMA ////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pub_infMultiidioma */
/////////////////////////////////////////////////////////////////
//// PUB_INF_MULTIIDIOMA ////////////////////////////////////////
class pub_infMultiidioma extends head
{
  function pub_infMultiidioma(context)
  {
    head(context);
  }
  function pub_traducirEtiqueta(nodo: FLDomNode, campo: String): String {
    return this.traducirEtiqueta(nodo, campo);
  }
  function pub_traducirEtiquetaLabel(campo)
  {
    return this.traducirEtiquetaLabel(campo);
  }
  function pub_establecerIdioma(codIdioma: String): Boolean {
    return this.establecerIdioma(codIdioma);
  }
  function pub_porIVA(nodo: FLDomNode, campo: String): String {
    return this.porIVA(nodo, campo);
  }
  function pub_traducirDescripcion(nodo: FLDomNode, campo: String): String {
    return this.traducirDescripcion(nodo, campo);
  }
}
//// PUB_INF_MULTIIDIOMA ////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition infMultiidioma */
/////////////////////////////////////////////////////////////////
//// INF_MULTIIDIOMA ///////////////////////////////////////////
function infMultiidioma_afterCommit_i_tradetiquetasinforme(curEtiqueta: FLSqlCursor): Boolean {
  var util: FLUtil = new FLUtil();
  if (curEtiqueta.modeAccess() == curEtiqueta.Del)
  {
    if (!util.sqlDelete("traducciones", "idcampo = '" + curEtiqueta.valueBuffer("etiqueta") + "'")) {
      return false;
    }
  }
  return true;
}

function infMultiidioma_establecerIdioma(codIdioma: String): Boolean {
  var util: FLUtil = new FLUtil();

  if (codIdioma == "")
  {
    this.iface.codIdiomaInforme_ = false;
    return true;
  } else {
    this.iface.codIdiomaInforme_ = codIdioma;
  }
  return true;
}

function infMultiidioma_traducirEtiqueta(nodo: FLDomNode, campo: String): String {
  var util: FLUtil = new FLUtil;
  if (!this.iface.codIdiomaInforme_)
  {
    return campo;
  }

  var tabla: String = "i_tradetiquetasinforme";
  var qry: FLSqlQuery = new FLSqlQuery();
  with(qry)
  {
    setTablesList("i_tradetiquetasinforme,traducciones");
    setSelect("t.traduccion");
    setFrom("i_tradetiquetasinforme e INNER JOIN traducciones t ON (t.tabla = '" + tabla + "' AND CAST(e.id AS CHAR(10)) = t.idcampo)");
  }
  qry.setWhere("e.etiqueta = '" + campo + "' AND t.codidioma = '" + this.iface.codIdiomaInforme_ + "'");
  if (!qry.exec())
  {
    return false;
  }
  if (!qry.first())
  {
    traduccion = campo;
  } else {
    traduccion = qry.value("t.traduccion");
  }

  return traduccion;
}

function infMultiidioma_traducirEtiquetaLabel(campo)
{
  debug("infMultiidioma_traducirEtiquetaLabel(" + campo + ")");
  var util: FLUtil = new FLUtil;
  if (!this.iface.codIdiomaInforme_) {
    return campo;
  }

  var tabla: String = "i_tradetiquetasinforme";
  var qry: FLSqlQuery = new FLSqlQuery();
  with(qry) {
    setTablesList("i_tradetiquetasinforme,traducciones");
    setSelect("t.traduccion");
    setFrom("i_tradetiquetasinforme e INNER JOIN traducciones t ON (t.tabla = '" + tabla + "' AND CAST(e.id AS CHAR(10)) = t.idcampo)");
  }
  qry.setWhere("e.etiqueta = '" + campo + "' AND t.codidioma = '" + this.iface.codIdiomaInforme_ + "'");
  if (!qry.exec()) {
    return false;
  }
  if (!qry.first()) {
    traduccion = campo;
  } else {
    traduccion = qry.value("t.traduccion");
  }
  debug("tr = " + traduccion);
  return traduccion;
}


function infMultiidioma_traducirDescripcion(nodo: FLDomNode, campo: String): String {
  var util: FLUtil = new FLUtil;
  var valor: String;
  var idtabla: String = nodo.attributeValue(campo);
  var datosTabla: Array = campo.split(".");
  switch (datosTabla[0])
  {
    case "lineaspresupuestoscli": {
      valor = nodo.attributeValue("lineaspresupuestoscli.descripcion");
      break;
    }
    case "lineaspedidoscli": {
      valor = nodo.attributeValue("lineaspedidoscli.descripcion");
      break;
    }
    case "lineasalbaranescli": {
      valor = nodo.attributeValue("lineasalbaranescli.descripcion");
      break;
    }
    case "lineasfacturascli": {
      valor = nodo.attributeValue("lineasfacturascli.descripcion");
      break;
    }
    default: {
      valor = util.sqlSelect("articulos", "descripcion", "referencia = '" + idtabla + "'");
    }
  }
  if (this.iface.codIdiomaInforme_ && this.iface.codIdiomaInforme_ != "")
  {
    valorTrad = flfactppal.iface.pub_traducirValorIdTabla(idtabla, "articulos", this.iface.codIdiomaInforme_);
    if (valorTrad && valorTrad != "") {
      valor = valorTrad;
    }
  }

  return valor;
}

function infMultiidioma_porIVA(nodo: FLDomNode, campo: String): String {
  var util: FLUtil = new FLUtil;
  var idDocumento: String;
  var tablaPadre: String;
  var tabla: String;
  var campoClave: String;
  var porIva: String;
  switch (campo)
  {
    case "facturacli": {
      tablaPadre = "facturascli";
      tabla = "lineasfacturascli";
      campoClave = "idfactura";
      break;
    }
    case "facturaprov": {
      tablaPadre = "facturasprov";
      tabla = "lineasfacturasprov";
      campoClave = "idfactura";
      break;
    }
  }
  idDocumento = nodo.attributeValue(tablaPadre + "." + campoClave);
  this.iface.variosIvas_ = false;
  porIva = parseFloat(util.sqlSelect(tabla, "iva", campoClave + " = " + idDocumento));
  if (!porIva)
    porIva = 0;

  if (util.sqlSelect(tabla, "iva", campoClave + " = " + idDocumento + " AND iva <> " + porIva))
  {
    this.iface.variosIvas_ = true;
    porIva = 0;
  }

  var tabla: String = "i_tradetiquetasinforme";
  var tradIva: String;
  var qrytradIva: FLSqlQuery = new FLSqlQuery();
  with(qrytradIva)
  {
    setTablesList("i_tradetiquetasinforme,traducciones");
    setSelect("t.traduccion");
    setFrom("i_tradetiquetasinforme e INNER JOIN traducciones t ON (t.tabla = '" + tabla + "' AND CAST(e.id AS CHAR(10)) = t.idcampo)");
  }
  qrytradIva.setWhere("e.etiqueta = 'I.V.A.' AND t.codidioma = '" + this.iface.codIdiomaInforme_ + "'");
  if (!qrytradIva.exec())
  {
    return false;
  }
  if (!qrytradIva.first())
  {
    tradIva = "I.V.A.";
  } else {
    tradIva = qrytradIva.value("t.traduccion");
  }

  return tradIva + " " + porIva.toString() + "%";
}

function infMultiidioma_traducirFecha(fecha: Date): String {
  var util: FLUtil = new FLUtil();
  var valor: String = util.dateAMDtoDMA(fecha);

  if (!this.iface.codIdiomaInforme_)
    return valor;

  var formatoFecha: String = util.sqlSelect("idiomas", "formatofecha", "codidioma = '" + this.iface.codIdiomaInforme_ + "'");

  if (!formatoFecha || formatoFecha == "")
    return valor;

  var pos: String = formatoFecha.find("%S");
  if (pos > -1)
  {
    var diaSemana: String = this.iface.obtenerDiaSemana(fecha);
    if (diaSemana && diaSemana != "")
      formatoFecha = formatoFecha.left(pos) + diaSemana + formatoFecha.right(formatoFecha.length - (pos + 2));
  }

  pos = formatoFecha.find("%D");
  if (pos > -1)
  {
    var diaMes: String = this.iface.obtenerDiaMes(fecha);
    if (diaMes)
      formatoFecha = formatoFecha.left(pos) + diaMes + formatoFecha.right(formatoFecha.length - (pos + 2));
  }

  pos = formatoFecha.find("%M");
  if (pos > -1)
  {
    var mes: String = this.iface.obtenerMes(fecha);
    if (mes && mes != "")
      formatoFecha = formatoFecha.left(pos) + mes + formatoFecha.right(formatoFecha.length - (pos + 2));
  }

  pos = formatoFecha.find("%A");
  if (pos > -1)
  {
    var ano: String = this.iface.obtenerAno(fecha);
    if (ano)
      formatoFecha = formatoFecha.left(pos) + ano + formatoFecha.right(formatoFecha.length - (pos + 2));
  }

  return formatoFecha;
}

function infMultiidioma_obtenerDiaSemana(fecha: Date): String {
  var util: FLUtil = new FLUtil();

  if (!fecha)
    fecha = new Date();

  var dia: String = fecha.getDay();
  var valor: String;
  switch (dia)
  {
    case 1: {
      valor = "Lunes";
      break;
    }
    case 2: {
      valor = "Martes";
      break;
    }
    case 3: {
      valor = "Miércoles";
      break;
    }
    case 4: {
      valor = "Jueves";
      break;
    }
    case 5: {
      valor = "Viernes";
      break;
    }
    case 6: {
      valor = "Sábado";
      break;
    }
    case 7: {
      valor = "Domingo";
      break;
    }
  }

  if (this.iface.codIdiomaInforme_)
  {
    var tabla: String = "i_tradetiquetasinforme";
    var qry: FLSqlQuery = new FLSqlQuery();
    with(qry) {
      setTablesList("i_tradetiquetasinforme,traducciones");
      setSelect("t.traduccion");
      setFrom("i_tradetiquetasinforme e INNER JOIN traducciones t ON (t.tabla = '" + tabla + "' AND CAST(e.id AS CHAR(10)) = t.idcampo)");
    }

    qry.setWhere("e.etiqueta = '" + valor + "' AND t.codidioma = '" + this.iface.codIdiomaInforme_ + "'");
    if (qry.exec())
      if (qry.first())
        valor = qry.value("t.traduccion");
  }

  return valor;
}

function infMultiidioma_obtenerDiaMes(fecha: Date): String {
  if (!fecha)
    fecha = new Date();

  var valor: String = fecha.getDate();
  return valor;
}

function infMultiidioma_obtenerMes(fecha: Date): String {
  if (!fecha)
    fecha = new Date();

  var mes: String = fecha.getMonth();
  var valor: String;
  switch (mes)
  {
    case 1: {
      valor = "Enero";
      break;
    }
    case 2: {
      valor = "Febrero";
      break;
    }
    case 3: {
      valor = "Marzo";
      break;
    }
    case 4: {
      valor = "Abril";
      break;
    }
    case 5: {
      valor = "Mayo";
      break;
    }
    case 6: {
      valor = "Junio";
      break;
    }
    case 7: {
      valor = "Julio";
      break;
    }
    case 8: {
      valor = "Agosto";
      break;
    }
    case 9: {
      valor = "Septiembre";
      break;
    }
    case 10: {
      valor = "Octubre";
      break;
    }
    case 11: {
      valor = "Noviembre";
      break;
    }
    case 12: {
      valor = "Diciembre";
      break;
    }
  }

  if (this.iface.codIdiomaInforme_)
  {
    var tabla: String = "i_tradetiquetasinforme";
    var qry: FLSqlQuery = new FLSqlQuery();
    with(qry) {
      setTablesList("i_tradetiquetasinforme,traducciones");
      setSelect("t.traduccion");
      setFrom("i_tradetiquetasinforme e INNER JOIN traducciones t ON (t.tabla = '" + tabla + "' AND CAST(e.id AS CHAR(10)) = t.idcampo)");
    }

    qry.setWhere("e.etiqueta = '" + valor + "' AND t.codidioma = '" + this.iface.codIdiomaInforme_ + "'");
    if (qry.exec())
      if (qry.first())
        valor = qry.value("t.traduccion");
  }

  return valor;
}

function infMultiidioma_obtenerAno(fecha: Date): String {
  if (!fecha)
    fecha = new Date();

  var valor: String = fecha.getYear();
  return valor;
}
//// INF_MULTIIDIOMA ///////////////////////////////////////////
/////////////////////////////////////////////////////////////////
