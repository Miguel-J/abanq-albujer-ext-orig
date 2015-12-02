
/** @class_declaration artesG */
/////////////////////////////////////////////////////////////////
//// ARTES GRÁFICAS /////////////////////////////////////////////
class artesG extends oficial
{
  var curAccion: FLSqlCursor;
  var bloqueoTiempo_: Boolean;
  function artesG(context)
  {
    oficial(context);
  }
  function init()
  {
    return this.ctx.artesG_init();
  }
  function tbnParametros_clicked()
  {
    return this.ctx.artesG_tbnParametros_clicked();
  }
  function mostrarParametros(nodoParam: FLDomNode, accion: String): FLDomNode {
    return this.ctx.artesG_mostrarParametros(nodoParam, accion);
  }
  function calcularXMLCostesImpresora(): FLDomNode {
    return this.ctx.artesG_calcularXMLCostesImpresora();
  }
  function calcularXMLCostesPlegadora(): FLDomNode {
    return this.ctx.artesG_calcularXMLCostesPlegadora();
  }
  function habilitarPorTipoAG()
  {
    return this.ctx.artesG_habilitarPorTipoAG();
  }
  function bufferChanged(fN: String)
  {
    return this.ctx.artesG_bufferChanged(fN);
  }
  function calculateField(fN: String): String {
    return this.ctx.artesG_calculateField(fN);
  }
  function validateForm(): Boolean {
    return this.ctx.artesG_validateForm();
  }
  function guardarXML(): Boolean {
    return this.ctx.artesG_guardarXML();
  }
  function xmlImpresora(): String {
    return this.ctx.artesG_xmlImpresora();
  }
  function xmlGuillotina(): String {
    return this.ctx.artesG_xmlGuillotina();
  }
  function xmlDisenador(): String {
    return this.ctx.artesG_xmlDisenador();
  }
  function xmlPlegadora(): String {
    return this.ctx.artesG_xmlPlegadora();
  }
  function xmlPlastificadora(): String {
    return this.ctx.artesG_xmlPlastificadora();
  }
  function xmlTroqueladora(): String {
    return this.ctx.artesG_xmlTroqueladora();
  }
  function xmlGrapadoraMesa(): String {
    return this.ctx.artesG_xmlGrapadoraMesa();
  }
  function xmlEGC(): String {
    return this.ctx.artesG_xmlEGC();
  }
  function xmlAlzadora(): String {
    return this.ctx.artesG_xmlAlzadora();
  }
  function calcularXMLCostesTroqueladora(): FLDomNode {
    return this.ctx.artesG_calcularXMLCostesTroqueladora();
  }
  function calcularXMLCostesPlastificadora(): FLDomNode {
    return this.ctx.artesG_calcularXMLCostesPlastificadora();
  }
  function calcularXMLCostesEGC(): FLDomNode {
    return this.ctx.artesG_calcularXMLCostesEGC();
  }
}
//// ARTES GRÁFICAS /////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition artesG */
/////////////////////////////////////////////////////////////////
//// ARTES GRÁFICAS /////////////////////////////////////////////
function artesG_init()
{
  this.iface.bloqueoTiempo_ = false;
  this.iface.__init();

  this.child("tbwTipoCentroCoste").setTabEnabled("tiempos", false);

  connect(this.child("tbnParametros"), "clicked()", this, "iface.tbnParametros_clicked");

  this.iface.habilitarPorTipoAG();
}

function artesG_bufferChanged(fN: String)
{
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  switch (fN) {
    case "tipoag": {
      this.iface.habilitarPorTipoAG();
      break;
    }
    case "unidadeshora": {
      if (!this.iface.bloqueoTiempo_) {
        this.iface.bloqueoTiempo_ = true;
        this.child("fdbTiempoUnidad").setValue(this.iface.calculateField("tiempounidad"));
        this.iface.bloqueoTiempo_ = false;
      }
      break;
    }
    case "tiempounidad": {
      if (!this.iface.bloqueoTiempo_) {
        this.iface.bloqueoTiempo_ = true;
        this.child("fdbUnidadesHora").setValue(this.iface.calculateField("unidadeshora"));
        this.iface.bloqueoTiempo_ = false;
      }
      break;
    }
    default: {
      this.iface.__bufferChanged(fN);
    }
  }
}

function artesG_habilitarPorTipoAG()
{
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();
  var tipoAG: String = cursor.valueBuffer("tipoag");

  switch (tipoAG) {
    case "Plastificadora":
    case "Troqueladora":
    case "Impresora": {
      this.child("fdbTiempoUnidad").setValue("");
      this.child("fdbTiempoUnidad").setDisabled(true);
      break;
    }
    default: {
      this.child("fdbTiempoUnidad").setDisabled(false);
    }
  }
}

function artesG_tbnParametros_clicked()
{
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  var contenido: String = cursor.valueBuffer("parametros");
  if (!contenido || contenido == "") {
    contenido = "<TipoCentroCoste/>";
  }
  var xmlParam: FLDomDocument = new FLDomDocument;
  if (!xmlParam.setContent(contenido)) {
    MessageBox.warning(util.translate("scripts", "Error al cargar los parámetros de la línea seleccionada"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }

  var xmlViejosParam: FLDomNode = xmlParam.firstChild();

  //  var xmlNuevosParam:FLDomNode;
  switch (cursor.valueBuffer("tipoag")) {
    case "Impresora": {
      this.iface.mostrarParametros(xmlViejosParam, "pr_paramimpresora");
      break;
    }
    case "Plegadora": {
      this.iface.mostrarParametros(xmlViejosParam, "pr_paramplegadora");
      break;
    }
    case "Guillotina": {
      this.iface.mostrarParametros(xmlViejosParam, "pr_paramguillotina");
      break;
    }
    case "Diseñador": {
      this.iface.mostrarParametros(xmlViejosParam, "pr_paramdisenador");
      break;
    }
    case "Grapadora de mesa": {
      this.iface.mostrarParametros(xmlViejosParam, "pr_paramgrapadoramesa");
      break;
    }
    case "E+G+C": {
      this.iface.mostrarParametros(xmlViejosParam, "pr_paramegc");
      break;
    }
    case "Alzadora": {
      this.iface.mostrarParametros(xmlViejosParam, "pr_paramalzadora");
      break;
    }
    case "Troqueladora": {
      this.iface.mostrarParametros(xmlViejosParam, "pr_paramtroqueladora");
      break;
    }
    default: {
      this.iface.mostrarParametros(xmlViejosParam, "pr_paramplastificadora");
      break;
    }
  }
  //  if (xmlNuevosParam) {
  //    var xmlDocParam:FLDomDocument = new FLDomDocument;
  //    xmlDocParam.appendChild(xmlNuevosParam);
  //    cursor.setValueBuffer("parametros", xmlDocParam.toString(4));
  //  }
}

function artesG_mostrarParametros(nodoParam: FLDomNode, accion: String): FLDomNode {
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  var codTipoCentro: String = cursor.valueBuffer("codtipocentro");

  if (this.iface.curAccion)
  {
    delete this.iface.curAccion;
  }
  this.iface.curAccion = new FLSqlCursor(accion);
  this.iface.curAccion.select("codtipocentro = '" + codTipoCentro + "'");
  if (this.iface.curAccion.size() > 1)
  {
    MessageBox.warning(util.translate("scripts", "Error: hay dos registros de parámetros para este tipo de centro"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }

  connect(this.iface.curAccion, "bufferCommited()", this, "iface.guardarXML");
  if (this.iface.curAccion.first())
  {
    this.iface.curAccion.editRecord();
    return true;
  } else {
    /// Poner cuando se hayan creado todos los registros de parámetros con valores
    if (cursor.modeAccess() == cursor.Insert)
    {
      MessageBox.warning(util.translate("scripts", "Antes de establecer los parámetros guarde el registro actual y vuelva a editarlo"), MessageBox.Ok, MessageBox.NoButton);
      return false;
    }
    this.iface.curAccion.insertRecord();
    return true;
  }
  return true;
}

function artesG_calcularXMLCostesImpresora(): FLDomNode {
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  var contenido: String = "<Costes>";
  var qryCostes: FLSqlQuery = new FLSqlQuery;
  with(qryCostes)
  {
    setTablesList("pr_costesestilosimp");
    setSelect("estilo, codformato, tarranque, tcopia, tfin, anchopinza, copiasmin, copiasmax, tiempoplancha, maculasplancha");
    setFrom("pr_costesestilosimp");
    setWhere("codtipocentro = '" + cursor.valueBuffer("codtipocentro") + "'");
    setForwardOnly(true);
  }
  if (!qryCostes.exec())
  {
    return false;
  }
  var tArranque: String;
  var tCopia: String;
  var tFin: String;
  var anchoPinza: String;
  var copiasMin: String;
  var copiasMax: String;
  var maculasPlancha: Number;
  var tiempoPlanca: Number;
  var eCoste: FLDomElement;
  var xmlDomCostes: FLDomDocument = new FLDomDocument;
  if (!xmlDomCostes.setContent("<Costes/>"))
  {
    return false;
  }
  while (qryCostes.next())
  {
    if (isNaN(qryCostes.value("tarranque"))) {
      tArranque = "0.00";
    } else {
      tArranque = util.roundFieldValue(qryCostes.value("tarranque"), "pr_costesestilosimp", "tarranque");
    }
    if (isNaN(qryCostes.value("tcopia"))) {
      tCopia = "0.00";
    } else {
      tCopia = util.roundFieldValue(qryCostes.value("tcopia"), "pr_costesestilosimp", "tcopia");
    }
    if (isNaN(qryCostes.value("tfin"))) {
      tFin = "0.00";
    } else {
      tFin = util.roundFieldValue(qryCostes.value("tfin"), "pr_costesestilosimp", "tfin");
    }
    if (isNaN(qryCostes.value("anchopinza"))) {
      anchoPinza = "0.00";
    } else {
      anchoPinza = util.roundFieldValue(qryCostes.value("anchopinza"), "pr_costesestilosimp", "anchopinza");
    }
    if (isNaN(qryCostes.value("copiasmin"))) {
      copiasMin = "0";
    } else {
      copiasMin = qryCostes.value("copiasmin");
    }
    if (isNaN(qryCostes.value("copiasmax"))) {
      copiasMax = "";
    } else {
      copiasMax = qryCostes.value("copiasmax");
    }
    debug(qryCostes.value("maculasplancha"));
    if (isNaN(qryCostes.value("maculasplancha"))) {
      maculasPlancha = "0";
    } else {
      maculasPlancha = qryCostes.value("maculasplancha");
    }
    if (isNaN(qryCostes.value("tiempoplancha"))) {
      tiempoPlancha = "0.00";
    } else {
      tiempoPlancha = qryCostes.value("tiempoplancha");
    }
    eCoste = xmlDomCostes.createElement("Coste");
    eCoste.setAttribute("EstiloImpresion", qryCostes.value("estilo"));
    eCoste.setAttribute("Formato", qryCostes.value("codformato"));
    eCoste.setAttribute("PorCopia", tCopia);
    eCoste.setAttribute("Arranque", tArranque);
    eCoste.setAttribute("Fin", tFin);
    eCoste.setAttribute("Pinza", anchoPinza);
    eCoste.setAttribute("CopiasMin", copiasMin);
    eCoste.setAttribute("CopiasMax", copiasMax);
    eCoste.setAttribute("MaculasPlancha", maculasPlancha);
    eCoste.setAttribute("TiempoPlancha", tiempoPlancha);
    xmlDomCostes.firstChild().appendChild(eCoste);
  }

  return xmlDomCostes.firstChild().cloneNode();
}

function artesG_calcularXMLCostesPlegadora(): FLDomNode {
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  var contenido: String = "<Costes>";
  var qryCostes: FLSqlQuery = new FLSqlQuery;
  with(qryCostes)
  {
    setTablesList("pr_costesplegadora");
    setSelect("tarranque, metrosminuto, tfin, copiasmin, copiasmax");
    setFrom("pr_costesplegadora");
    setWhere("codtipocentro = '" + cursor.valueBuffer("codtipocentro") + "'");
    setForwardOnly(true);
  }
  if (!qryCostes.exec())
  {
    return false;
  }
  var tArranque: String;
  var metrosMinuto: String;
  var tFin: String;
  var copiasMin: String;
  var copiasMax: String;
  while (qryCostes.next())
  {
    if (isNaN(qryCostes.value("tarranque"))) {
      tArranque = "0.00";
    } else {
      tArranque = util.roundFieldValue(qryCostes.value("tarranque"), "pr_costesplegadora", "tarranque");
    }
    if (isNaN(qryCostes.value("metrosminuto"))) {
      metrosMinuto = "0.00";
    } else {
      metrosMinuto = util.roundFieldValue(qryCostes.value("metrosminuto"), "pr_costesplegadora", "metrosminuto");
    }
    if (isNaN(qryCostes.value("tfin"))) {
      tFin = "0.00";
    } else {
      tFin = util.roundFieldValue(qryCostes.value("tfin"), "pr_costesplegadora", "tfin");
    }
    if (isNaN(qryCostes.value("copiasmin"))) {
      copiasMin = "0";
    } else {
      copiasMin = qryCostes.value("copiasmin");
    }
    debug("CMax  = " + qryCostes.value("copiasmax"));
    if (isNaN(qryCostes.value("copiasmax")) || qryCostes.value("copiasmax") == 0) {
      copiasMax = "";
    } else {
      copiasMax = qryCostes.value("copiasmax");
    }
    contenido += "<Coste MetrosMinuto=\"" + metrosMinuto + "\" Arranque=\"" + tArranque + "\" Fin=\"" + tFin + "\" CopiasMin=\"" + copiasMin + "\" CopiasMax = \"" + copiasMax + "\" />";
  }
  contenido += "</Costes>";

  var xmlDomCostes: FLDomDocument = new FLDomDocument;
  if (!xmlDomCostes.setContent(contenido))
    return false;

  return xmlDomCostes.firstChild().cloneNode();
}

function artesG_calcularXMLCostesPlastificadora(): FLDomNode {
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  var contenido: String = "<Costes>";
  var qryCostes: FLSqlQuery = new FLSqlQuery;
  with(qryCostes)
  {
    setTablesList("pr_costesplastificadora");
    setSelect("tarranque, metrosminuto, tfin, copiasmin, copiasmax");
    setFrom("pr_costesplastificadora");
    setWhere("codtipocentro = '" + cursor.valueBuffer("codtipocentro") + "'");
    setForwardOnly(true);
  }
  if (!qryCostes.exec())
  {
    return false;
  }
  var tArranque: String;
  var metrosMinuto: String;
  var tFin: String;
  var copiasMin: String;
  var copiasMax: String;
  while (qryCostes.next())
  {
    if (isNaN(qryCostes.value("tarranque"))) {
      tArranque = "0.00";
    } else {
      tArranque = util.roundFieldValue(qryCostes.value("tarranque"), "pr_costesplastificadora", "tarranque");
    }
    if (isNaN(qryCostes.value("metrosminuto"))) {
      metrosMinuto = "0.00";
    } else {
      metrosMinuto = util.roundFieldValue(qryCostes.value("metrosminuto"), "pr_costesplastificadora", "metrosminuto");
    }
    if (isNaN(qryCostes.value("tfin"))) {
      tFin = "0.00";
    } else {
      tFin = util.roundFieldValue(qryCostes.value("tfin"), "pr_costesplastificadora", "tfin");
    }
    if (isNaN(qryCostes.value("copiasmin"))) {
      copiasMin = "0";
    } else {
      copiasMin = qryCostes.value("copiasmin");
    }
    debug("CMax  = " + qryCostes.value("copiasmax"));
    if (isNaN(qryCostes.value("copiasmax")) || qryCostes.value("copiasmax") == 0) {
      copiasMax = "";
    } else {
      copiasMax = qryCostes.value("copiasmax");
    }
    contenido += "<Coste MetrosMinuto=\"" + metrosMinuto + "\" Arranque=\"" + tArranque + "\" Fin=\"" + tFin + "\" CopiasMin=\"" + copiasMin + "\" CopiasMax = \"" + copiasMax + "\" />";
  }
  contenido += "</Costes>";

  var xmlDomCostes: FLDomDocument = new FLDomDocument;
  if (!xmlDomCostes.setContent(contenido))
    return false;

  return xmlDomCostes.firstChild().cloneNode();
}

function artesG_calcularXMLCostesEGC(): FLDomNode {
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  var contenido: String = "<Costes>";
  var qryCostes: FLSqlQuery = new FLSqlQuery;
  with(qryCostes)
  {
    setTablesList("pr_costesegc");
    setSelect("unidadeshora, copiasmin, copiasmax");
    setFrom("pr_costesegc");
    setWhere("codtipocentro = '" + cursor.valueBuffer("codtipocentro") + "'");
    setForwardOnly(true);
  }
  if (!qryCostes.exec())
  {
    return false;
  }
  //  var tArranque:String;
  //  var metrosMinuto:String;
  //  var tFin:String;
  var unidadesHora: String;
  var copiasMin: String;
  var copiasMax: String;
  while (qryCostes.next())
  {
    //    if (isNaN(qryCostes.value("tarranque"))) {
    //      tArranque = "0.00";
    //    } else {
    //      tArranque = util.roundFieldValue(qryCostes.value("tarranque"), "pr_costesplastificadora", "tarranque");
    //    }
    if (isNaN(qryCostes.value("unidadeshora"))) {
      unidadesHora = "0";
    } else {
      unidadesHora = qryCostes.value("unidadeshora");
    }
    //    if (isNaN(qryCostes.value("tfin"))) {
    //      tFin = "0.00";
    //    } else {
    //      tFin = util.roundFieldValue(qryCostes.value("tfin"), "pr_costesplastificadora", "tfin");
    //    }
    if (isNaN(qryCostes.value("copiasmin"))) {
      copiasMin = "0";
    } else {
      copiasMin = qryCostes.value("copiasmin");
    }
    debug("CMax  = " + qryCostes.value("copiasmax"));
    if (isNaN(qryCostes.value("copiasmax")) || qryCostes.value("copiasmax") == 0) {
      copiasMax = "";
    } else {
      copiasMax = qryCostes.value("copiasmax");
    }
    contenido += "<Coste UnidadesHora=\"" + unidadesHora + "\" CopiasMin=\"" + copiasMin + "\" CopiasMax = \"" + copiasMax + "\" />";
  }
  contenido += "</Costes>";

  var xmlDomCostes: FLDomDocument = new FLDomDocument;
  if (!xmlDomCostes.setContent(contenido))
    return false;

  return xmlDomCostes.firstChild().cloneNode();
}

function artesG_calcularXMLCostesTroqueladora(): FLDomNode {
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  var contenido: String = "<Costes>";
  var qryCostes: FLSqlQuery = new FLSqlQuery;
  with(qryCostes)
  {
    setTablesList("pr_costestroqueladora");
    setSelect("tarranque, unidadeshora, tfin, copiasmin, copiasmax");
    setFrom("pr_costestroqueladora");
    setWhere("codtipocentro = '" + cursor.valueBuffer("codtipocentro") + "'");
    setForwardOnly(true);
  }
  if (!qryCostes.exec())
  {
    return false;
  }
  var tArranque: String;
  var metrosMinuto: String;
  var tFin: String;
  var copiasMin: String;
  var copiasMax: String;
  while (qryCostes.next())
  {
    if (isNaN(qryCostes.value("tarranque"))) {
      tArranque = "0.00";
    } else {
      tArranque = util.roundFieldValue(qryCostes.value("tarranque"), "pr_costestroqueladora", "tarranque");
    }
    if (isNaN(qryCostes.value("unidadeshora"))) {
      unidadesHora = "0.00";
    } else {
      unidadesHora = util.roundFieldValue(qryCostes.value("unidadeshora"), "pr_costestroqueladora", "unidadeshora");
    }
    if (isNaN(qryCostes.value("tfin"))) {
      tFin = "0.00";
    } else {
      tFin = util.roundFieldValue(qryCostes.value("tfin"), "pr_costestroqueladora", "tfin");
    }
    if (isNaN(qryCostes.value("copiasmin"))) {
      copiasMin = "0";
    } else {
      copiasMin = qryCostes.value("copiasmin");
    }
    debug("CMax  = " + qryCostes.value("copiasmax"));
    if (isNaN(qryCostes.value("copiasmax")) || qryCostes.value("copiasmax") == 0) {
      copiasMax = "";
    } else {
      copiasMax = qryCostes.value("copiasmax");
    }
    contenido += "<Coste UnidadesHora=\"" + unidadesHora + "\" Arranque=\"" + tArranque + "\" Fin=\"" + tFin + "\" CopiasMin=\"" + copiasMin + "\" CopiasMax = \"" + copiasMax + "\" />";
  }
  contenido += "</Costes>";

  var xmlDomCostes: FLDomDocument = new FLDomDocument;
  if (!xmlDomCostes.setContent(contenido))
    return false;

  return xmlDomCostes.firstChild().cloneNode();
}

function artesG_validateForm(): Boolean {
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  //  if (!this.iface.guardarXML()) {
  //    MessageBox.warning(util.translate("scripts", "Error al guardar el documento XML de parámetros del centro"), MessageBox.Ok, MessageBox.NoButton);
  //    return false;
  //  }
  return true;
}

function artesG_guardarXML(): Boolean {
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  var xml: String;
  switch (cursor.valueBuffer("tipoag"))
  {
    case "Guillotina": {
      xml = this.iface.xmlGuillotina();
      break;
    }
    case "Diseñador": {
      xml = this.iface.xmlDisenador();
      break;
    }
    case "Plegadora": {
      xml = this.iface.xmlPlegadora();
      break;
    }
    case "Impresora": {
      xml = this.iface.xmlImpresora();
      break;
    }
    case "Grapadora de mesa": {
      xml = this.iface.xmlGrapadoraMesa();
      break;
    }
    case "E+G+C": {
      xml = this.iface.xmlEGC();
      break;
    }
    case "Alzadora": {
      xml = this.iface.xmlAlzadora();
      break;
    }
    case "Troqueladora": {
      xml = this.iface.xmlTroqueladora();
      break;
    }
    default: {
      xml = this.iface.xmlPlastificadora();
      break;
    }
  }
  if (!xml)
  {
    debug("!xml : " + xml);
    return false;
  }
  cursor.setValueBuffer("parametros", xml);
  return true;
}

function artesG_xmlImpresora(): String {
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();
  var codTipoCentro: String = cursor.valueBuffer("codtipocentro");
  var curImpresora: FLSqlCursor = new FLSqlCursor("pr_paramimpresora");
  curImpresora.select("codtipocentro = '" + codTipoCentro + "'");
  if (!curImpresora.first())
  {
    return "";
  }

  var xmlParam: FLDomDocument = new FLDomDocument();
  xmlParam.setContent("<TipoCentroCoste/>");
  var nodoParam: FLDomNode = xmlParam.firstChild();
  var eParam: FLDomNode = nodoParam.toElement();

  var numCuerpos: String = curImpresora.valueBuffer("numcuerpos");
  eParam.setAttribute("NumCuerpos", numCuerpos);

  var refPlancha: String = curImpresora.valueBuffer("refplancha");
  eParam.setAttribute("RefPlancha", refPlancha);

  if (curImpresora.isNull("tiravolteo"))
  {
    eParam.setAttribute("Volteo", "");
  } else {
    eParam.setAttribute("Volteo", curImpresora.valueBuffer("tiravolteo"));
  }

  var altoMin: String = curImpresora.valueBuffer("altomin");
  altoMin = util.roundFieldValue(altoMin, "articulos", "altopliego");
  eParam.setAttribute("AltoMin", altoMin);

  var altoMax: String = curImpresora.valueBuffer("altomax");
  altoMax = util.roundFieldValue(altoMax, "articulos", "altopliego");
  eParam.setAttribute("AltoMax", altoMax);

  var anchoMin: String = curImpresora.valueBuffer("anchomin");
  anchoMin = util.roundFieldValue(anchoMin, "articulos", "anchopliego");
  eParam.setAttribute("AnchoMin", anchoMin);

  var anchoMax: String = curImpresora.valueBuffer("anchomax");
  anchoMax = util.roundFieldValue(anchoMax, "articulos", "anchopliego");
  eParam.setAttribute("AnchoMax", anchoMax);

  if (curImpresora.valueBuffer("coloresreg"))
  {
    eParam.setAttribute("ColoresReg", "true");
  } else {
    eParam.setAttribute("ColoresReg", "false");
  }

  if (curImpresora.valueBuffer("fondoslisos"))
  {
    eParam.setAttribute("FondosLisos", "true");
  } else {
    eParam.setAttribute("FondosLisos", "false");
  }

  if (curImpresora.valueBuffer("numeracion"))
  {
    eParam.setAttribute("Numeracion", "true");
  } else {
    eParam.setAttribute("Numeracion", "false");
  }

  if (curImpresora.valueBuffer("calidadespecial"))
  {
    eParam.setAttribute("CalidadEspecial", "true");
  } else {
    eParam.setAttribute("CalidadEspecial", "false");
  }

  var tiempoMinProd: String = curImpresora.valueBuffer("tiempominprod");
  tiempoMinProd = util.roundFieldValue(tiempoMinProd, "pr_paramimpresora", "tiempominprod");
  eParam.setAttribute("TiempoMinProd", tiempoMinProd);

  //  var tiempoPlancha:String = curImpresora.valueBuffer("tiempoplancha");
  //  tiempoPlancha = util.roundFieldValue(tiempoPlancha, "pr_paramimpresora", "tiempoplancha");
  //  eParam.setAttribute("TiempoPlancha", tiempoPlancha);
  //
  //  var maculasPlancha:Number = parseInt(curImpresora.valueBuffer("maculasplancha"));
  //  eParam.setAttribute("MaculasPlancha", maculasPlancha);

  var anchoPinza: String = curImpresora.valueBuffer("anchopinza");
  anchoPinza = util.roundFieldValue(anchoPinza, "pr_paramimpresora", "anchopinza");
  eParam.setAttribute("AnchoPinza", anchoPinza);

  var relAspectoMin: String = curImpresora.valueBuffer("relaspectomin");
  relAspectoMin = util.roundFieldValue(relAspectoMin, "pr_paramimpresora", "relaspectomin");
  eParam.setAttribute("RelAspectoMin", relAspectoMin);

  var tiempoExtraPantone: String = curImpresora.valueBuffer("tiempoextrapantone");
  tiempoExtraPantone = util.roundFieldValue(tiempoExtraPantone, "pr_paramimpresora", "tiempoextrapantone");
  eParam.setAttribute("TiempoExtraPantone", tiempoExtraPantone);

  var qryDimOptimas: FLSqlQuery = new FLSqlQuery;
  with(qryDimOptimas)
  {
    setTablesList("pr_dimoptimasimp");
    setSelect("alto, ancho");
    setFrom("pr_dimoptimasimp");
    setWhere("codtipocentro = '" + codTipoCentro + "'");
    setForwardOnly(true);
  }
  if (!qryDimOptimas.exec())
  {
    return false;
  }
  var contenidoDO: String = "<DimOptimas Penalizacion='" + curImpresora.valueBuffer("tpopennooptima") + "'>";
  while (qryDimOptimas.next())
  {
    contenidoDO += "<DimOptima Alto='" + qryDimOptimas.value("alto") + "' Ancho='" + qryDimOptimas.value("ancho") + "'/>";
  }
  contenidoDO += "</DimOptimas>";
  debug(contenidoDO);
  var docDO: FLDomDocument = new FLDomDocument;
  if (!docDO.setContent(contenidoDO))
  {
    return false;
  }
  nodoParam.appendChild(docDO.firstChild().cloneNode());

  var nodoCostes: FLDomNode = this.iface.calcularXMLCostesImpresora();
  if (!nodoCostes)
  {
    MessageBox.warning(util.translate("scripts", "Error al calcular el nodo XML de costes asociado a la impresora"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  nodoParam.appendChild(nodoCostes);

  return xmlParam.toString();
}

function artesG_xmlGuillotina(): String {
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();
  var codTipoCentro: String = cursor.valueBuffer("codtipocentro");
  var curGuillotina: FLSqlCursor = new FLSqlCursor("pr_paramguillotina");
  curGuillotina.select("codtipocentro = '" + codTipoCentro + "'");
  if (!curGuillotina.first())
  {
    return "";
  }

  var xmlParam: FLDomDocument = new FLDomDocument();
  xmlParam.setContent("<TipoCentroCoste/>");
  var nodoParam: FLDomNode = xmlParam.firstChild();
  var eParam: FLDomNode = nodoParam.toElement();

  var altoMin: String = curGuillotina.valueBuffer("altomin");
  altoMin = util.roundFieldValue(altoMin, "articulos", "altopliego");
  eParam.setAttribute("AltoMin", altoMin);

  var altoMax: String = curGuillotina.valueBuffer("altomax");
  altoMax = util.roundFieldValue(altoMax, "articulos", "altopliego");
  eParam.setAttribute("AltoMax", altoMax);

  var anchoMin: String = curGuillotina.valueBuffer("anchomin");
  anchoMin = util.roundFieldValue(anchoMin, "articulos", "anchopliego");
  eParam.setAttribute("AnchoMin", anchoMin);

  var anchoMax: String = curGuillotina.valueBuffer("anchomax");
  anchoMax = util.roundFieldValue(anchoMax, "articulos", "anchopliego");
  eParam.setAttribute("AnchoMax", anchoMax);

  var maxGrosorCm: String = curGuillotina.valueBuffer("maxgrosorcm");
  maxGrosorCm = util.roundFieldValue(maxGrosorCm, "pr_paramguillotina", "maxgrosorcm");
  eParam.setAttribute("MaxGrosorCm", maxGrosorCm);

  return xmlParam.toString(4);
}

function artesG_xmlDisenador(): String {
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();
  var codTipoCentro: String = cursor.valueBuffer("codtipocentro");
  var curDisenador: FLSqlCursor = new FLSqlCursor("pr_paramdisenador");
  curDisenador.select("codtipocentro = '" + codTipoCentro + "'");
  if (!curDisenador.first())
  {
    return "";
  }

  var xmlParam: FLDomDocument = new FLDomDocument();
  xmlParam.setContent("<TipoCentroCoste/>");
  var nodoParam: FLDomNode = xmlParam.firstChild();
  var eParam: FLDomNode = nodoParam.toElement();

  var tiempoModelo: String = curDisenador.valueBuffer("tiempomodelo");
  tiempoModelo = util.roundFieldValue(tiempoModelo, "pr_paramdisenador", "tiempomodelo");
  eParam.setAttribute("TiempoModelo", tiempoModelo);

  var tiempoAjusteTrab: String = curDisenador.valueBuffer("tiempoajustetrab");
  tiempoAjusteTrab = util.roundFieldValue(tiempoAjusteTrab, "pr_paramdisenador", "tiempoajustetrab");
  eParam.setAttribute("TiempoAjusteTrab", tiempoAjusteTrab);

  var minAjusteTrab: String = curDisenador.valueBuffer("minajustetrab");
  minAjusteTrab = util.roundFieldValue(minAjusteTrab, "pr_paramdisenador", "minajustetrab");
  eParam.setAttribute("MinAjusteTrab", minAjusteTrab);

  return xmlParam.toString(4);
}

function artesG_xmlGrapadoraMesa(): String {
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();
  var codTipoCentro: String = cursor.valueBuffer("codtipocentro");
  var curGrapadoraM: FLSqlCursor = new FLSqlCursor("pr_paramgrapadoramesa");
  curGrapadoraM.select("codtipocentro = '" + codTipoCentro + "'");
  if (!curGrapadoraM.first())
  {
    return "";
  }

  var xmlParam: FLDomDocument = new FLDomDocument();
  xmlParam.setContent("<TipoCentroCoste/>");
  var nodoParam: FLDomNode = xmlParam.firstChild();
  var eParam: FLDomNode = nodoParam.toElement();

  var altoMin: String = curGrapadoraM.valueBuffer("altomin");
  eParam.setAttribute("AltoMin", altoMin);

  var altoMax: String = curGrapadoraM.valueBuffer("altomax");
  eParam.setAttribute("AltoMax", altoMax);

  var anchoMin: String = curGrapadoraM.valueBuffer("anchomin");
  eParam.setAttribute("AnchoMin", anchoMin);

  var anchoMax: String = curGrapadoraM.valueBuffer("anchomax");
  eParam.setAttribute("AnchoMax", anchoMax);

  var espesorMax: Number = curGrapadoraM.valueBuffer("espesormax");
  eParam.setAttribute("EspesorMax", espesorMax);

  var totalCabezales: Number = curGrapadoraM.valueBuffer("totalcabezales");
  eParam.setAttribute("TotalCabezales", totalCabezales);

  var numCabezalesN: Number = curGrapadoraM.valueBuffer("numcabezalesn");
  eParam.setAttribute("NumCabezalesN", numCabezalesN);

  var numCabezalesO: Number = curGrapadoraM.valueBuffer("numcabezaleso");
  eParam.setAttribute("NumCabezalesO", numCabezalesO);

  var tiempoPrepCabNormal: Number = curGrapadoraM.valueBuffer("tiempoprepcabnormal");
  eParam.setAttribute("TiempoPrepCabNormal", tiempoPrepCabNormal);

  var tiempoPrepCabOmega: Number = curGrapadoraM.valueBuffer("tiempoprepcabomega");
  eParam.setAttribute("TiempoPrepCabOmega", tiempoPrepCabOmega);

  var uniHora: Number = curGrapadoraM.valueBuffer("unihora");
  eParam.setAttribute("UniHora", uniHora);

  return xmlParam.toString(4);
}

function artesG_xmlPlegadora(): String {
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();
  var codTipoCentro: String = cursor.valueBuffer("codtipocentro");
  var curPlegadora: FLSqlCursor = new FLSqlCursor("pr_paramplegadora");
  curPlegadora.select("codtipocentro = '" + codTipoCentro + "'");
  if (!curPlegadora.first())
  {
    return "";
  }

  var xmlParam: FLDomDocument = new FLDomDocument();
  xmlParam.setContent("<TipoCentroCoste/>");
  var nodoParam: FLDomNode = xmlParam.firstChild();
  var eParam: FLDomNode = nodoParam.toElement();

  var altoMin: String = curPlegadora.valueBuffer("altomin");
  altoMin = util.roundFieldValue(altoMin, "articulos", "altopliego");
  eParam.setAttribute("AltoMin", altoMin);

  var altoMax: String = curPlegadora.valueBuffer("altomax");
  altoMax = util.roundFieldValue(altoMax, "articulos", "altopliego");
  eParam.setAttribute("AltoMax", altoMax);

  var anchoMin: String = curPlegadora.valueBuffer("anchomin");
  anchoMin = util.roundFieldValue(anchoMin, "articulos", "anchopliego");
  eParam.setAttribute("AnchoMin", anchoMin);

  var anchoMax: String = curPlegadora.valueBuffer("anchomax");
  anchoMax = util.roundFieldValue(anchoMax, "articulos", "anchopliego");
  eParam.setAttribute("AnchoMax", anchoMax);

  var palas: Number = curPlegadora.valueBuffer("palas");
  eParam.setAttribute("Palas", palas);

  var cuchillas: Number = curPlegadora.valueBuffer("cuchillas");
  eParam.setAttribute("Cuchillas", cuchillas);

  var tiempoPrepPala: String = curPlegadora.valueBuffer("tiempopreppala");
  tiempoPrepPala = util.roundFieldValue(tiempoPrepPala, "pr_tiposcentrocoste", "tiempoinicio");
  eParam.setAttribute("TiempoPrepPala", tiempoPrepPala);

  var tiempoPrepCuchilla: String = curPlegadora.valueBuffer("tiempoprepcuchilla");
  tiempoPrepCuchilla = util.roundFieldValue(tiempoPrepCuchilla, "pr_tiposcentrocoste", "tiempoinicio");
  eParam.setAttribute("TiempoPrepCuchilla", tiempoPrepCuchilla);

  var uniHora: Number = curPlegadora.valueBuffer("unihora");
  eParam.setAttribute("UnidadesHora", uniHora);

  var nodoCostes: FLDomNode = this.iface.calcularXMLCostesPlegadora();
  if (!nodoCostes)
  {
    MessageBox.warning(util.translate("scripts", "Error al calcular el nodo XML de costes asociado a la plegadora"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  nodoParam.appendChild(nodoCostes);

  return xmlParam.toString(4);
}

function artesG_xmlPlastificadora(): String {
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();
  var codTipoCentro: String = cursor.valueBuffer("codtipocentro");
  var curPlastificadora: FLSqlCursor = new FLSqlCursor("pr_paramplastificadora");
  curPlastificadora.select("codtipocentro = '" + codTipoCentro + "'");
  if (!curPlastificadora.first())
  {
    return "";
  }

  var xmlParam: FLDomDocument = new FLDomDocument();
  xmlParam.setContent("<TipoCentroCoste/>");
  var nodoParam: FLDomNode = xmlParam.firstChild();
  var eParam: FLDomNode = nodoParam.toElement();

  var altoMin: String = curPlastificadora.valueBuffer("altomin");
  altoMin = util.roundFieldValue(altoMin, "articulos", "altopliego");
  eParam.setAttribute("AltoMin", altoMin);

  var altoMax: String = curPlastificadora.valueBuffer("altomax");
  altoMax = util.roundFieldValue(altoMax, "articulos", "altopliego");
  eParam.setAttribute("AltoMax", altoMax);

  var anchoMin: String = curPlastificadora.valueBuffer("anchomin");
  anchoMin = util.roundFieldValue(anchoMin, "articulos", "anchopliego");
  eParam.setAttribute("AnchoMin", anchoMin);

  var anchoMax: String = curPlastificadora.valueBuffer("anchomax");
  anchoMax = util.roundFieldValue(anchoMax, "articulos", "anchopliego");
  eParam.setAttribute("AnchoMax", anchoMax);

  var gramajeMin: String = curPlastificadora.valueBuffer("gramajemin");
  gramajeMin = util.roundFieldValue(gramajeMin, "pr_paramplastificadora", "gramajemin");
  eParam.setAttribute("GramajeMin", gramajeMin);

  var metrosMinuto: Number = curPlastificadora.valueBuffer("MetrosMinuto");
  eParam.setAttribute("MetrosMinuto", metrosMinuto);

  var margenLargo: String = curPlastificadora.valueBuffer("margenlargo");
  margenLargo = util.roundFieldValue(margenLargo, "pr_paramplastificadora", "margenlargo");
  eParam.setAttribute("MargenLargo", margenLargo);

  var margenAncho: String = curPlastificadora.valueBuffer("margenancho");
  margenAncho = util.roundFieldValue(margenAncho, "pr_paramplastificadora", "margenancho");
  eParam.setAttribute("MargenAncho", margenAncho);

  var nodoCostes: FLDomNode = this.iface.calcularXMLCostesPlastificadora();
  if (!nodoCostes)
  {
    MessageBox.warning(util.translate("scripts", "Error al calcular el nodo XML de costes asociado a la plastificadora"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  nodoParam.appendChild(nodoCostes);

  return xmlParam.toString(4);
}

function artesG_xmlTroqueladora(): String {
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();
  var codTipoCentro: String = cursor.valueBuffer("codtipocentro");
  var curTroqueladora: FLSqlCursor = new FLSqlCursor("pr_paramtroqueladora");
  curTroqueladora.select("codtipocentro = '" + codTipoCentro + "'");
  if (!curTroqueladora.first())
  {
    return "";
  }

  var xmlParam: FLDomDocument = new FLDomDocument();
  xmlParam.setContent("<TipoCentroCoste/>");
  var nodoParam: FLDomNode = xmlParam.firstChild();
  var eParam: FLDomNode = nodoParam.toElement();

  var altoMin: String = curTroqueladora.valueBuffer("altomin");
  altoMin = util.roundFieldValue(altoMin, "articulos", "altopliego");
  eParam.setAttribute("AltoMin", altoMin);

  var altoMax: String = curTroqueladora.valueBuffer("altomax");
  altoMax = util.roundFieldValue(altoMax, "articulos", "altopliego");
  eParam.setAttribute("AltoMax", altoMax);

  var anchoMin: String = curTroqueladora.valueBuffer("anchomin");
  anchoMin = util.roundFieldValue(anchoMin, "articulos", "anchopliego");
  eParam.setAttribute("AnchoMin", anchoMin);

  var anchoMax: String = curTroqueladora.valueBuffer("anchomax");
  anchoMax = util.roundFieldValue(anchoMax, "articulos", "anchopliego");
  eParam.setAttribute("AnchoMax", anchoMax);

  var uniHora: Number = curTroqueladora.valueBuffer("unihora");
  eParam.setAttribute("UnidadesHora", uniHora);

  var nodoCostes: FLDomNode = this.iface.calcularXMLCostesTroqueladora();
  if (!nodoCostes)
  {
    MessageBox.warning(util.translate("scripts", "Error al calcular el nodo XML de costes asociado a la troqueladora"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  nodoParam.appendChild(nodoCostes);

  return xmlParam.toString(4);
}

function artesG_xmlEGC(): String {
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();
  var codTipoCentro: String = cursor.valueBuffer("codtipocentro");
  var curEGC: FLSqlCursor = new FLSqlCursor("pr_paramegc");
  curEGC.select("codtipocentro = '" + codTipoCentro + "'");
  if (!curEGC.first())
  {
    return "";
  }

  var xmlParam: FLDomDocument = new FLDomDocument();
  xmlParam.setContent("<TipoCentroCoste/>");
  var nodoParam: FLDomNode = xmlParam.firstChild();
  var eParam: FLDomNode = nodoParam.toElement();

  var altoMin: String = curEGC.valueBuffer("altomin");
  altoMin = util.roundFieldValue(altoMin, "articulos", "altopliego");
  eParam.setAttribute("AltoMin", altoMin);

  var altoMax: String = curEGC.valueBuffer("altomax");
  altoMax = util.roundFieldValue(altoMax, "articulos", "altopliego");
  eParam.setAttribute("AltoMax", altoMax);

  var anchoMin: String = curEGC.valueBuffer("anchomin");
  anchoMin = util.roundFieldValue(anchoMin, "articulos", "anchopliego");
  eParam.setAttribute("AnchoMin", anchoMin);

  var anchoMax: String = curEGC.valueBuffer("anchomax");
  anchoMax = util.roundFieldValue(anchoMax, "articulos", "anchopliego");
  eParam.setAttribute("AnchoMax", anchoMax);

  var numBandejas: String = curEGC.valueBuffer("numbandejas");
  eParam.setAttribute("NumBandejas", numBandejas);

  var espesorMaxBandeja: Number = curEGC.valueBuffer("espesormaxbandeja");
  eParam.setAttribute("EspesorMaxBandeja", espesorMaxBandeja);

  var espesorMaxGrapa: Number = curEGC.valueBuffer("espesormaxgrapa");
  eParam.setAttribute("EspesorMaxGrapa", espesorMaxGrapa);

  var tiempoPrepBandeja: String = curEGC.valueBuffer("tiempoprepbandeja");
  eParam.setAttribute("TiempoPrepBandeja", tiempoPrepBandeja);

  var tiempoPrepFijo: String = curEGC.valueBuffer("tiempoprepfijo");
  eParam.setAttribute("TiempoPrepFijo", tiempoPrepFijo);

  var nodoCostes: FLDomNode = this.iface.calcularXMLCostesEGC();
  if (!nodoCostes)
  {
    MessageBox.warning(util.translate("scripts", "Error al calcular el nodo XML de costes asociado a máquina EGC"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  nodoParam.appendChild(nodoCostes);

  return xmlParam.toString(4);
}

function artesG_xmlAlzadora(): String {
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();
  var codTipoCentro: String = cursor.valueBuffer("codtipocentro");
  var curEGC: FLSqlCursor = new FLSqlCursor("pr_paramalzadora");
  curEGC.select("codtipocentro = '" + codTipoCentro + "'");
  if (!curEGC.first())
  {
    return "";
  }

  var xmlParam: FLDomDocument = new FLDomDocument();
  xmlParam.setContent("<TipoCentroCoste/>");
  var nodoParam: FLDomNode = xmlParam.firstChild();
  var eParam: FLDomNode = nodoParam.toElement();

  var altoMin: String = curEGC.valueBuffer("altomin");
  altoMin = util.roundFieldValue(altoMin, "articulos", "altopliego");
  eParam.setAttribute("AltoMin", altoMin);

  var altoMax: String = curEGC.valueBuffer("altomax");
  altoMax = util.roundFieldValue(altoMax, "articulos", "altopliego");
  eParam.setAttribute("AltoMax", altoMax);

  var anchoMin: String = curEGC.valueBuffer("anchomin");
  anchoMin = util.roundFieldValue(anchoMin, "articulos", "anchopliego");
  eParam.setAttribute("AnchoMin", anchoMin);

  var anchoMax: String = curEGC.valueBuffer("anchomax");
  anchoMax = util.roundFieldValue(anchoMax, "articulos", "anchopliego");
  eParam.setAttribute("AnchoMax", anchoMax);

  var numBandejas: String = curEGC.valueBuffer("numbandejas");
  eParam.setAttribute("NumBandejas", numBandejas);

  var espesorMaxBandeja: Number = curEGC.valueBuffer("espesormaxbandeja");
  eParam.setAttribute("EspesorMaxBandeja", espesorMaxBandeja);

  var tiempoPrepBandeja: String = curEGC.valueBuffer("tiempoprepbandeja");
  eParam.setAttribute("TiempoPrepBandeja", tiempoPrepBandeja);

  var uniHora: String = curEGC.valueBuffer("unihora");
  eParam.setAttribute("UniHora", uniHora);

  return xmlParam.toString(4);
}

function artesG_calculateField(fN: String): String {
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();
  var valor: String;

  switch (fN)
  {
    case "unidadeshora": {
      var minutosUnidad: Number = cursor.valueBuffer("tiempounidad");
      if (isNaN(minutosUnidad)) {
        minutosUnidad = 0;
      }
      if (minutosUnidad == 0) {
        valor = 0;
      } else {
        valor = 60 / parseFloat(minutosUnidad);
      }
      break;
    }
    case "tiempounidad": {
      var unidadesHora: Number = cursor.valueBuffer("unidadeshora");
      if (isNaN(unidadesHora)) {
        unidadesHora = 0;
      }
      if (unidadesHora == 0) {
        valor = 0;
      } else {
        valor = 60 / parseFloat(unidadesHora);
      }
      break;
    }
  }
  return valor;
}
//// ARTES GRÁFICAS /////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
