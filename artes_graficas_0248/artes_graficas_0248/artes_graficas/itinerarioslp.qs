/***************************************************************************
                 itinerarioslp.qs  -  description
                             -------------------
    begin                : vie 15 02 2008
    copyright            : (C) 2008 by InfoSiAL S.L.
    email                : mail@infosial.com
 ***************************************************************************/
/***************************************************************************
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
 ***************************************************************************/

/** @file */

/** @class_declaration interna */
////////////////////////////////////////////////////////////////////////////
//// DECLARACION ///////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
//// INTERNA /////////////////////////////////////////////////////
class interna
{
  var ctx: Object;
  function interna(context)
  {
    this.ctx = context;
  }
  function init()
  {
    this.ctx.interna_init();
  }
  function calculateField(fN: String): String {
    return this.ctx.interna_calculateField(fN);
  }
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna
{
  var xmlItinerario: FLDomDocument;
  var iPlancha: Number;
  function oficial(context)
  {
    interna(context);
  }
  function construirResumenIptico(): String {
    return this.ctx.oficial_construirResumenIptico();
  }
  function resumenIptico(xmlDocParam: FLDomDocument): String {
    return this.ctx.oficial_resumenIptico(xmlDocParam);
  }
  function construirResumenLibro(): String {
    return this.ctx.oficial_construirResumenLibro();
  }
  function resumenLibro(xmlDocParam: FLDomDocument): String {
    return this.ctx.oficial_resumenLibro(xmlDocParam);
  }
  function tbnDistPlancha_clicked()
  {
    return this.ctx.oficial_tbnDistPlancha_clicked();
  }
  function mostrarPrecorte()
  {
    return this.ctx.oficial_mostrarPrecorte();
  }
  function cargarPlanchas()
  {
    return this.ctx.oficial_cargarPlanchas();
  }
  function mostrarDistPlanchas(nodoPlancha: FLDomNode, xmlItinerario: FLDomDocument, lblPix: Object)
  {
    return this.ctx.oficial_mostrarDistPlanchas(nodoPlancha, xmlItinerario, lblPix);
  }
  function actualizarTotales()
  {
    return this.ctx.oficial_actualizarTotales();
  }
  function commonCalculateField(fN: String, cursor: FLSqlCursor): String {
    return this.ctx.oficial_commonCalculateField(fN, cursor);
  }
  function actualizarPorBeneficio(cursor: FLSqlCursor): Boolean {
    return this.ctx.oficial_actualizarPorBeneficio(cursor);
  }
}
//// OFICIAL /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////


/** @class_declaration head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////
class head extends oficial
{
  function head(context)
  {
    oficial(context);
  }
}
//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration ifaceCtx */
/////////////////////////////////////////////////////////////////
//// INTERFACE  /////////////////////////////////////////////////
class ifaceCtx extends head
{
  function ifaceCtx(context)
  {
    head(context);
  }
  function pub_commonCalculateField(fN: String, cursor: FLSqlCursor): String {
    return this.commonCalculateField(fN, cursor);
  }
  function pub_actualizarPorBeneficio(cursor: FLSqlCursor): Boolean {
    return this.actualizarPorBeneficio(cursor);
  }
  function pub_mostrarDistPlanchas(nodoPlancha: FLDomNode, xmlItinerario: FLDomDocument, lblPix: Object)
  {
    return this.mostrarDistPlanchas(nodoPlancha, xmlItinerario, lblPix);
  }
  function pub_resumenIptico(xmlDocParam: FLDomDocument): String {
    return this.resumenIptico(xmlDocParam);
  }
  function pub_resumenLibro(xmlDocParam: FLDomDocument): String {
    return this.resumenLibro(xmlDocParam);
  }
}

const iface = new ifaceCtx(this);
//// INTERFACE  /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition interna */
////////////////////////////////////////////////////////////////////////////
//// DEFINICION ////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
//// INTERNA /////////////////////////////////////////////////////
/** \C
Este formulario realiza la gestión de las líneas de presupuestos a clientes.
\end */
function interna_init()
{
  var util: FLUtil = new FLUtil();
  var cursor: FLSqlCursor = this.cursor();

  connect(this.child("tdbTareas").cursor(), "bufferCommited()", this, "iface.actualizarTotales()"),

          var refComponente: String = util.sqlSelect("productoslp", "referencia", "idproducto = " + cursor.valueBuffer("idproducto"));
  var idTipoProceso: String = util.sqlSelect("articulos", "idtipoproceso", "referencia = '" + refComponente + "'");
  switch (idTipoProceso) {
    case "TRIP": {
      this.iface.mostrarPrecorte();
      this.iface.cargarPlanchas();
      connect(this.child("tbnDistPlancha"), "clicked()", this, "iface.tbnDistPlancha_clicked()"),
              this.child("lblResumen").text = this.iface.construirResumenIptico();
      break;
    }
    case "ENCUADERNACION": {
      this.child("lblResumen").text = this.iface.construirResumenLibro();
      break;
    }
  }
}

function interna_calculateField(fN: String): String {
  var cursor: FLSqlCursor = this.cursor();
  var valor: String;

  valor = this.iface.commonCalculateField(fN, cursor);

  return valor;
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_construirResumenIptico(): String {
  debug("oficial_construirResumenIptico");
  var util: FLUtil = new FLUtil();
  var cursor: FLSqlCursor = this.cursor();

  var xmlDocParam: FLDomDocument = new FLDomDocument;
  xmlDocParam.setContent(cursor.valueBuffer("xmlparametros"));

  var resumen: String = this.iface.resumenIptico(xmlDocParam);
  return resumen;
}

function oficial_resumenIptico(xmlDocParam: FLDomDocument): String {
  var util: FLUtil = new FLUtil();
  var resumen: String = "<ul>";
  debug("xmlDocParam = " + xmlDocParam.toString(4));

  var xmlProceso: FLDomNode = xmlDocParam.firstChild();
  var xmlParametros: FLDomNode = xmlProceso.namedItem("Parametros");
  var xmlParam: FLDomNode;
  var eParam: FLDomElement;
  var lineaResumen: String;
  var factorPI: Number;
  var refPliego: String;
  xmlParam = xmlParametros.namedItem("PaginasParam");
  if (xmlParam)
  {
    eParam = xmlParam.toElement();
    if (eParam.attribute("CantidadesPorModelo") == "true") {
      lineaResumen = util.translate("scripts", "Cantidades:");
      var eModelo: FLDomElement;
      for (var nodoModelo: FLDomNode = eParam.namedItem("Modelos").firstChild(); nodoModelo; nodoModelo = nodoModelo.nextSibling()) {
        eModelo = nodoModelo.toElement();
        lineaResumen += util.translate("scripts", " Modelo %1: %2.").arg(eModelo.attribute("Nombre")).arg(eModelo.attribute("Cantidad"));
      }
      lineaResumen += util.translate("scripts", " Total %1").arg(eParam.attribute("Total"));
    } else {
      lineaResumen = util.translate("scripts", "%1 Copias x %2 Páginas = %3 Trabajos").arg(eParam.attribute("NumCopias")).arg(eParam.attribute("NumPaginas")).arg(eParam.attribute("Total"));
    }
    resumen += "<li>" + lineaResumen + "</li>";
  }
  xmlParam = xmlParametros.namedItem("GramajeParam");
  if (xmlParam)
  {
    eParam = xmlParam.toElement();
    lineaResumen = util.translate("scripts", "Gramaje: %1").arg(eParam.attribute("Valor"));
    resumen += "<li>" + lineaResumen + "</li>";
  }
  xmlParam = xmlParametros.namedItem("DosCarasParam");
  if (xmlParam)
  {
    eParam = xmlParam.toElement();
    if (eParam.attribute("Valor") == "true") {
      lineaResumen = util.translate("scripts", "Dos caras");
    } else {
      lineaResumen = util.translate("scripts", "Una cara");
    }
    resumen += "<li>" + lineaResumen + "</li>";
  }
  xmlParam = xmlParametros.namedItem("AreaTrabajoParam");
  if (xmlParam)
  {
    eParam = xmlParam.toElement();
    var areaConSangrias: String = "";
    var areaTS: Array = flfacturac.iface.pub_areaTrabajoConSangria(xmlProceso);
    if (areaTS) {
      areaConSangrias = areaTS["x"] + "x" + areaTS["y"];
    }
    lineaResumen = util.translate("scripts", "Área del trabajo: %1 (%2 con sangrías)").arg(eParam.attribute("Valor")).arg(areaConSangrias);
    resumen += "<li>" + lineaResumen + "</li>";
  }
  xmlParam = xmlParametros.namedItem("PlastificadoParam");
  if (xmlParam)
  {
    eParam = xmlParam.toElement();
    lineaResumen = util.translate("scripts", "Plastificado: %1").arg(eParam.attribute("Valor"));
    resumen += "<li>" + lineaResumen + "</li>";
  }
  xmlParam = xmlParametros.namedItem("ColoresParam");
  if (xmlParam)
  {
    eParam = xmlParam.toElement();
    lineaResumen = util.translate("scripts", "Colores: %1").arg(eParam.attribute("Valor"));
    resumen += "<li>" + lineaResumen + "</li>";
  }
  xmlParam = xmlParametros.namedItem("PliegoParam");
  if (xmlParam)
  {
    eParam = xmlParam.toElement();
    refPliego = eParam.attribute("Ref");
    refPliego += ": " + util.sqlSelect("articulos", "descripcion", "referencia = '" + refPliego + "'");
    lineaResumen = util.translate("scripts", "Pliego %1 de %2").arg(refPliego).arg(eParam.attribute("AreaPliego"));
    resumen += "<li>" + lineaResumen + "</li>";
  }
  xmlParam = xmlParametros.namedItem("PliegoImpresionParam");
  if (xmlParam)
  {
    eParam = xmlParam.toElement();
    lineaResumen =  util.translate("scripts", "Precorte en %1.").arg(eParam.attribute("Corte")) + "\n";
    lineaResumen += util.translate("scripts", "Área pliego impresión: %1 ").arg(eParam.attribute("Valor"));
    factorPI = eParam.attribute("Factor");
    resumen += "<li>" + lineaResumen + "</li>";
  }
  xmlParam = xmlParametros.namedItem("TrabajosPliegoParam");
  if (xmlParam)
  {
    eParam = xmlParam.toElement();
    lineaResumen = util.translate("scripts", "Trabajos por pliego de impresión: %1").arg(eParam.elementsByTagName("Trabajo").length());
    resumen += "<li>" + lineaResumen + "</li>";
  }
  xmlParam = xmlParametros.namedItem("TipoImpresoraParam");
  if (xmlParam)
  {
    eParam = xmlParam.toElement();
    lineaResumen = util.translate("scripts", "Impresora %1 de plancha %2 (%3).").arg(eParam.attribute("Valor")).arg(eParam.attribute("RefPlancha")).arg(eParam.attribute("AreaPlancha"));
    resumen += "<li>" + lineaResumen + "</li>";
  }
  xmlParam = xmlParametros.namedItem("EstiloImpresionParam");
  if (xmlParam)
  {
    eParam = xmlParam.toElement();
    lineaResumen = util.translate("scripts", "Estilo impresión: %1 ").arg(eParam.attribute("Valor"));
    resumen += "<li>" + lineaResumen + "</li>";
  }
  xmlParam = xmlParametros.namedItem("DistPlanchaParam");
  if (xmlParam)
  {
    eParam = xmlParam.toElement();
    lineaResumen = util.translate("scripts", "Planchas necesarias: %1 (%2 juegos) ").arg(eParam.attribute("NumPlanchas")).arg(eParam.attribute("NumJuegos")) + "\n";
    var numPliegosImpresion: Number = eParam.attribute("NumPliegos");
    var numPliegos: Number = Math.ceil(numPliegosImpresion / factorPI);
    lineaResumen += util.translate("scripts", "Pliegos de impresión necesarios: %1 ").arg(numPliegosImpresion) + "\n";
    lineaResumen += util.translate("scripts", "Pliegos (%1) necesarios: %2 ").arg(refPliego).arg(numPliegos) + "\n";
    lineaResumen += util.translate("scripts", "Total pasadas: : %1 ").arg(eParam.attribute("NumPasadas"));
    resumen += "<li>" + lineaResumen + "</li>";
  }
  xmlParam = xmlParametros.namedItem("TroqueladoParam");
  if (xmlParam)
  {
    eParam = xmlParam.toElement();
    lineaResumen = util.translate("scripts", "Troquelado. %1 trabajos por troquel").arg(eParam.attribute("TrabajosTroquel"));
    resumen += "<li>" + lineaResumen + "</li>";
  }
  xmlParam = xmlParametros.namedItem("PlegadoParam");
  if (xmlParam)
  {
    eParam = xmlParam.toElement();
    lineaResumen = util.translate("scripts", "Plegado. H: %1, V: %2").arg(eParam.attribute("Horizontales")).arg(eParam.attribute("Verticales"));
    resumen += "<li>" + lineaResumen + "</li>";
  }
  resumen += "</ul>\n";
  debug(resumen);
  return resumen;
}

function oficial_construirResumenLibro(): String {
  debug("oficial_construirResumenLibro");
  var util: FLUtil = new FLUtil();
  var cursor: FLSqlCursor = this.cursor();
  var resumen: String = "";

  var xmlDocParam: FLDomDocument = new FLDomDocument;
  xmlDocParam.setContent(cursor.valueBuffer("xmlparametros"));


  var resumen: String = this.iface.resumenLibro(xmlDocParam);
  return resumen;
}

function oficial_resumenLibro(xmlDocParam: FLDomDocument): String {
  var util: FLUtil = new FLUtil();
  var resumen: String = "<ul>";

  var xmlProceso: FLDomNode = xmlDocParam.firstChild();
  var xmlParams: FLDomNodeList = xmlProceso.namedItem("Parametros").childNodes();
  var xmlParam: FLDomNode;
  var eParam: FLDomElement;
  var lineaResumen: String;
  var factorPI: Number;
  var refPliego: String;
  for (var i: Number = 0; i < xmlParams.length(); i++)
  {
    lineaResumen = "";
    xmlParam = xmlParams.item(i);
    eParam = xmlParam.toElement();
    switch (xmlParam.nodeName()) {
      case "PaginasParam": {
        lineaResumen = util.translate("scripts", "%1 Copias").arg(eParam.attribute("NumCopias"));
        lineaResumen = util.translate("scripts", "%1 Páginas").arg(eParam.attribute("NumPaginas"));
        break;
      }
      case "AreaTrabajoParam": {
        lineaResumen = util.translate("scripts", "Área del trabajo abierto: %1").arg(eParam.attribute("Abierto"));
        lineaResumen += "\n" + util.translate("scripts", "Área del trabajo cerrado: %1").arg(eParam.attribute("Cerrado"));
        break;
      }
      case "EncuadernacionParam": {
        var tipoEncuadernacion: String = eParam.attribute("Tipo");
        lineaResumen = util.translate("scripts", "Tipo de encuadernación: %1").arg(tipoEncuadernacion);
        if (tipoEncuadernacion == "Grapado") {
          lineaResumen += "\n" + util.translate("scripts", "Grapado según esquema: %1").arg(eParam.attribute("Grapado"));
        }
        break;
      }
      case "TipoGrapadoraParam": {
        lineaResumen = util.translate("scripts", "Se realizará el grapado en la grapadora: %1").arg(eParam.attribute("Valor"));
        break;
      }
    }
    if (lineaResumen != "") {
      resumen += "<li>" + lineaResumen + "</li>";
    }
  }
  resumen += "</ul>";
  return resumen;
}


function oficial_tbnDistPlancha_clicked()
{
  var util: FLUtil = new FLUtil;

  var xmlDistPlancha: FLDomNode = flfacturac.iface.pub_dameNodoXML(this.iface.xmlItinerario.firstChild(), "Parametros/DistPlanchaParam");
  if (!xmlDistPlancha)
    return;

  var xmlPlanchas: FLDomNodeList = xmlDistPlancha.toElement().elementsByTagName("Plancha");

  if (!xmlPlanchas.item(this.iface.iPlancha))
    this.iface.iPlancha = 0;

  var ePlancha: FLDomElement = xmlPlanchas.item(this.iface.iPlancha).toElement();
  var juego: String = ePlancha.attribute("Juego");
  var texto: String = util.translate("scripts", "Juego %1. Planchas ").arg(juego);
  var numPliegos: String = ePlancha.attribute("NumPliegos");

  var hayComa: Boolean = false;
  while (ePlancha.attribute("Juego") == juego) {
    if (hayComa)
      texto += ", ";
    texto += ePlancha.attribute("Numero") + "(" + ePlancha.attribute("Color") + ") "
             this.iface.iPlancha++;
    if (!xmlPlanchas.item(this.iface.iPlancha)) {
      break;
    }
    ePlancha = xmlPlanchas.item(this.iface.iPlancha).toElement();
    hayComa = true;
  }
  texto += util.translate("scripts", "\n%1 pliegos.").arg(numPliegos);
  this.child("lblDistPlancha").text = texto;

  var lblPix: Object = this.child("lblDiagDistPlancha");
  this.iface.mostrarDistPlanchas(xmlPlanchas.item(this.iface.iPlancha - 1), this.iface.xmlItinerario, lblPix);
}

function oficial_cargarPlanchas()
{
  var cursor: FLSqlCursor = this.cursor();

  this.iface.xmlItinerario = new FLDomDocument;
  this.iface.xmlItinerario.setContent(cursor.valueBuffer("xmlparametros"));

  /*var dimPliego:String = flfacturac.iface.pub_dameAtributoXML(this.iface.xmlItinerario.firstChild(), "Parametros/PliegoImpresionParam@Valor");

  var xmlTrabajosPliegoParam:FLDomNode = flfacturac.iface.pub_dameNodoXML(this.iface.xmlItinerario.firstChild(), "Parametros/TrabajosPliegoParam");
  if (!xmlTrabajosPliegoParam)
    return false;

  flfacturac.iface.pub_mostrarTrabajosPliego(this.child( "lblDiagDistPlancha" ), xmlTrabajosPliegoParam, dimPliego)*/;

  this.iface.iPlancha = 0;
  this.iface.tbnDistPlancha_clicked();
}

function oficial_mostrarDistPlanchas(nodoPlancha: FLDomNode, xmlItinerario: FLDomDocument, lblPix: Object)
{
  var xmlProceso: FLDomNode = xmlItinerario.firstChild();
  var xmlTrabajosPliego: FLDomNode = flfacturac.iface.pub_dameNodoXML(xmlProceso, "Parametros/TrabajosPliegoParam");
  if (!xmlTrabajosPliego)
    return false;

  var dimPliegoImpresion: String = flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/PliegoImpresionParam@Valor");

  var coordPliego: Array = dimPliegoImpresion.split("x");
  var anchoP: Number = parseFloat(coordPliego[0]);
  var altoP: Number = parseFloat(coordPliego[1]);

  var dimPix: Array = [];
  dimPix.x = 100;
  dimPix.y = 100;

  var factor: Number;
  if (anchoP > altoP) {
    factor = dimPix.x / anchoP;
  } else {
    factor = dimPix.y / altoP;
  }
  anchoP *= factor;
  altoP *= factor;

  //  var lblPix:Object = this.child("lblDiagDistPlancha");
  var anchoPix: Number = 100;
  var altoPix: Number = 100;
  var svg: String = "<svg width='" + dimPix.x + "' height='" + dimPix.y + "' version='1.1' xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink'>";


  if (!xmlTrabajosPliego) {
    svg += "</svg>";
    flfacturac.iface.pub_mostrarSVG(lblPix, svg);
    return;
  }
  svg += "<g stroke-width='0' stroke='white' fill='white' >\n";
  svg += "<rect x='" + 0 + "' width='" + anchoP + "' y='" + 0 + "' height='" + altoP + "'/>\n";
  svg += "</g>\n";

  var eTP: FLDomElement = xmlTrabajosPliego.toElement();

  var trabajos: FLDomNodeList = eTP.elementsByTagName("Trabajo");
  var eTrabajo: FLDomElement;
  var w: Number = 0, h: Number = 0, x: Number = 0, y: Number = 0;

  var dibTrabajos: Array = [];
  var xTexto: Number;
  var yTexto: Number;
  var pagina: String;
  var nodoPagina: FLDomNode;
  var colorPagina: String;
  var distPaginasTrabajo: String = flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/DatosLibroParam@DistPaginasTrabajo");
  if (distPaginasTrabajo == "") {
    distPaginasTrabajo = false;
  }
  svg += "<g stroke-width='1' stroke='red' fill='yellow' >\n";
  var apaisado: Boolean;
  for (var i: Number = 0; i < trabajos.length(); i++) {
    eTrabajo = trabajos.item(i).toElement();
    x = parseFloat(eTrabajo.attribute("X")) * factor;
    y = parseFloat(eTrabajo.attribute("Y")) * factor;
    w = parseFloat(eTrabajo.attribute("W")) * factor;
    h = parseFloat(eTrabajo.attribute("H")) * factor;
    apaisado = (eTrabajo.attribute("Apaisado") == "true");
    dibTrabajos[i] = new Rect(x, y, w, h);

    xTexto = x + (w / 2) - 5;
    yTexto = y + (h / 2) + 5;
    nodoPagina = flfacturac.iface.pub_dameNodoXML(nodoPlancha, "TrabajoPlancha[@IdTrabajo=" + eTrabajo.attribute("Id") + "]");

    if (nodoPagina) {
      pagina = nodoPagina.toElement().attribute("Pagina");
      if (pagina.endsWith("'")) {
        pagina = pagina.left(pagina.length - 1) + "&apos;";
      }
      colorPagina = "yellow";
    } else {
      pagina = "";
      colorPagina = "grey";
    }
    svg += "<rect x='" + x + "' width='" + w + "' y='" + y + "' height='" + h + "' fill='" + colorPagina + "' />\n";

    if (distPaginasTrabajo) {
      svg += flfacturac.iface.pub_svnPaginasTrabajo(x, y, w, h, distPaginasTrabajo, apaisado);
    }

    svg += "<text x='" + xTexto + "' y='" + yTexto + "' font-family='Verdana' font-size='10' fill='red'>" + pagina + "</text>\n";
  }
  svg += "</g>\n";

  var svgPinzas: String = flfacturac.iface.pub_svgPinzas(xmlProceso, dimPix);
  if (!svgPinzas) {
    return false;
  }
  svg += svgPinzas;

  svg += "</svg>\n";
  debug(svg);
  flfacturac.iface.pub_mostrarSVG(lblPix, svg, dimPix);
}

function oficial_mostrarPrecorte()
{
  var cursor: FLSqlCursor = this.cursor();

  var xmlItinerario: FLDomDocument = new FLDomDocument;
  xmlItinerario.setContent(cursor.valueBuffer("xmlparametros"));

  var dimPliego: String = flfacturac.iface.pub_dameAtributoXML(xmlItinerario.firstChild(), "Parametros/PliegoParam@AreaPliego");

  var xmlPliegoImpresionParam: FLDomNode = flfacturac.iface.pub_dameNodoXML(xmlItinerario.firstChild(), "Parametros/PliegoImpresionParam");
  if (!xmlPliegoImpresionParam)
    return false;

  flfacturac.iface.pub_mostrarPrecorte(this.child("lblDiagPrecorte"), xmlPliegoImpresionParam, dimPliego);
}

function oficial_actualizarTotales()
{
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();
  var idItinerario: String = cursor.valueBuffer("iditinerario");

  var costeMO: Number = util.sqlSelect("tareaslp", "SUM(costemo)", "iditinerario = " + idItinerario);
  var costeMat: Number = util.sqlSelect("tareaslp", "SUM(costemat)", "iditinerario = " + idItinerario);
  var costeTotal: Number = parseFloat(costeMO) + parseFloat(costeMat);

  this.child("fdbCosteMO").setValue(this.iface.calculateField("costemo"));
  this.child("fdbCosteMat").setValue(this.iface.calculateField("costemat"));
  this.child("fdbCosteTotal").setValue(this.iface.calculateField("costetotal"));

  this.iface.actualizarPorBeneficio(cursor);

  this.child("tdbTareas").refresh();
}

function oficial_actualizarPorBeneficio(cursor: FLSqlCursor): Boolean {
  var costeTotal: Number = parseFloat(cursor.valueBuffer("costetotal"));
  var curTarea: FLSqlCursor = new FLSqlCursor("tareaslp");
  curTarea.select("iditinerario = " + cursor.valueBuffer("iditinerario"));
  var porCoste: Number;
  while (curTarea.next())
  {
    porCoste = curTarea.valueBuffer("costetotal") * 100 / costeTotal;
    curTarea.setModeAccess(curTarea.Edit);
    curTarea.refreshBuffer();
    curTarea.setValueBuffer("porcoste", porCoste);
    if (!curTarea.commitBuffer()) {
      return false;
    }
  }
  return true;
}

function oficial_commonCalculateField(fN: String, cursor: FLSqlCursor): String {
  var util: FLUtil = new FLUtil;
  var valor: String;
  var idItinerario: String = cursor.valueBuffer("iditinerario");

  switch (fN)
  {
    case "costemo": {
      valor = parseFloat(util.sqlSelect("tareaslp", "SUM(costemo)", "iditinerario = " + idItinerario));
      if (!valor || isNaN(valor)) {
        valor = 0;
      }
      valor = util.roundFieldValue(valor, "itinerarioslp", "costemo");
      break;
    }
    case "costemat": {
      valor = parseFloat(util.sqlSelect("tareaslp", "SUM(costemat)", "iditinerario = " + idItinerario));
      if (!valor || isNaN(valor)) {
        valor = 0;
      }
      valor = util.roundFieldValue(valor, "itinerarioslp", "costemat");
      break;
    }
    case "costetotal": {
      valor = parseFloat(cursor.valueBuffer("costemo")) + parseFloat(cursor.valueBuffer("costemat"));
      if (!valor || isNaN(valor)) {
        valor = 0;
      }
      valor = util.roundFieldValue(valor, "itinerarioslp", "costetotal");
      break;
    }
  }

  return valor;
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
////////////////////////////////////////////////////////////////