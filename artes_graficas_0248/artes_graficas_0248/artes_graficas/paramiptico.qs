/***************************************************************************
                 paramiptico.qs  -  description
                             -------------------
    begin                : vie feb 29 2008
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

////////////////////////////////////////////////////////////////////////////
//// DECLARACION ///////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

/** @class_declaration interna */
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
    return this.ctx.interna_init();
  }
  function calculateField(fN: String): String {
    return this.ctx.interna_calculateField(fN);
  }
  function validateForm(): Boolean {
    return this.ctx.interna_validateForm();
  }
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna
{
  var xmlPrecortes_: FLDomDocument;
  var xmlPrecorteActual_: FLDomNode;
  var xmlTPOs_: FLDomDocument;
  var xmlTPOActual_: FLDomNode;
  var xmlTPMSs_: FLDomDocument;
  var xmlTPMSActual_: FLDomNode;

  var curCantidades_: FLSqlCursor;
  var curColores_: FLSqlCursor;
  var cantidad: Number;
  function oficial(context)
  {
    interna(context);
  }
  function cargarDatos()
  {
    return this.ctx.oficial_cargarDatos();
  }
  function cargarDiseno(eDiseno: FLDomElement): Boolean {
    return this.ctx.oficial_cargarDiseno(eDiseno);
  }
  function cargarPlastificado(ePlastificado: FLDomElement): Boolean {
    return this.ctx.oficial_cargarPlastificado(ePlastificado);
  }
  function cargarAreaT(eAreaT: FLDomElement): Boolean {
    return this.ctx.oficial_cargarAreaT(eAreaT);
  }
  function cargarPlegado(ePliegues: FLDomElement): Boolean {
    return this.ctx.oficial_cargarPlegado(ePliegues);
  }
  function cargarSangria(eSangria: FLDomElement): Boolean {
    return this.ctx.oficial_cargarSangria(eSangria);
  }
  function habilitarPorSangria()
  {
    return this.ctx.oficial_habilitarPorSangria();
  }
  function bufferChanged(fN: String)
  {
    return this.ctx.oficial_bufferChanged(fN);
  }
  function tbnPrecorte_clicked()
  {
    return this.ctx.oficial_tbnPrecorte_clicked();
  }
  function cargarPrecortes(): Boolean {
    return this.ctx.oficial_cargarPrecortes();
  }
  function tbnTPO_clicked()
  {
    return this.ctx.oficial_tbnTPO_clicked();
  }
  function cargarTPOs(): Boolean {
    return this.ctx.oficial_cargarTPOs();
  }
  function tbnTPMS_clicked()
  {
    return this.ctx.oficial_tbnTPMS_clicked();
  }
  function cargarTPMSs(): Boolean {
    return this.ctx.oficial_cargarTPMSs();
  }
  function tbnBorrarPrecorte_clicked()
  {
    return this.ctx.oficial_tbnBorrarPrecorte_clicked();
  }
  function tbnBorrarTPO_clicked()
  {
    return this.ctx.oficial_tbnBorrarTPO_clicked();
  }
  function tbnBorrarTPMS_clicked()
  {
    return this.ctx.oficial_tbnBorrarTPMS_clicked();
  }
  function mostrarPrecorte()
  {
    return this.ctx.oficial_mostrarPrecorte();
  }
  function mostrarTPO()
  {
    return this.ctx.oficial_mostrarTPO();
  }
  function mostrarTPMS()
  {
    return this.ctx.oficial_mostrarTPMS();
  }
  function guardarDatos(cursor: FLSqlCursor): FLDomDocument {
    return this.ctx.oficial_guardarDatos(cursor);
  }
  function guardarDiseno(nodoParam: FLDomNode, cursor: FLSqlCursor): Boolean {
    return this.ctx.oficial_guardarDiseno(nodoParam, cursor);
  }
  function guardarPlastificado(nodoParam: FLDomNode, cursor: FLSqlCursor): Boolean {
    return this.ctx.oficial_guardarPlastificado(nodoParam, cursor);
  }
  function guardarPlegado(nodoParam: FLDomNode, cursor: FLSqlCursor): Boolean {
    return this.ctx.oficial_guardarPlegado(nodoParam, cursor);
  }
  function guardarSangrias(nodoParam: FLDomNode, cursor: FLSqlCursor): Boolean {
    return this.ctx.oficial_guardarSangrias(nodoParam, cursor);
  }
  function guardarPliego(nodoParam: FLDomNode, cursor: FLSqlCursor): Boolean {
    return this.ctx.oficial_guardarPliego(nodoParam, cursor);
  }
  function guardarPliegoImpresion(nodoParam: FLDomNode, cursor: FLSqlCursor): Boolean {
    return this.ctx.oficial_guardarPliegoImpresion(nodoParam, cursor);
  }
  function guardarTrabajosPliego(nodoParam: FLDomNode, cursor: FLSqlCursor): Boolean {
    return this.ctx.oficial_guardarTrabajosPliego(nodoParam, cursor);
  }
  function guardarImpresora(nodoParam: FLDomNode, cursor: FLSqlCursor): Boolean {
    return this.ctx.oficial_guardarImpresora(nodoParam, cursor);
  }
  function guardarEstiloImpresion(nodoParam: FLDomNode, cursor: FLSqlCursor): Boolean {
    return this.ctx.oficial_guardarEstiloImpresion(nodoParam, cursor);
  }
  function guardarOtros(nodoParam: FLDomNode, cursor: FLSqlCursor): Boolean {
    return this.ctx.oficial_guardarOtros(nodoParam, cursor);
  }
  function guardarColor(nodoParam: FLDomNode, cursor: FLSqlCursor): Boolean {
    return this.ctx.oficial_guardarColor(nodoParam, cursor);
  }
  function guardarCantidad(nodoParam: FLDomNode, cursor: FLSqlCursor): Boolean {
    return this.ctx.oficial_guardarCantidad(nodoParam, cursor);
  }
  function guardarTroquelado(nodoParam: FLDomNode, cursor: FLSqlCursor): Boolean {
    return this.ctx.oficial_guardarTroquelado(nodoParam, cursor);
  }
  function guardarDatosLibro(nodoParam: FLDomNode, cursor: FLSqlCursor): Boolean {
    return this.ctx.oficial_guardarDatosLibro(nodoParam, cursor);
  }
  function guardarMaculas(nodoParam: FLDomNode, cursor: FLSqlCursor): Boolean {
    return this.ctx.oficial_guardarMaculas(nodoParam, cursor);
  }
  function guardarTareasSaltadas(nodoParam: FLDomNode, cursor: FLSqlCursor): Boolean {
    return this.ctx.oficial_guardarTareasSaltadas(nodoParam, cursor);
  }
  function crearNodoHijo(nodoPadre: FLDomNode, nombreHijo): FLDomNode {
    return this.ctx.oficial_crearNodoHijo(nodoPadre, nombreHijo);
  }
  function validarDatos(xmlProceso: FLDomNode): Boolean {
    return this.ctx.oficial_validarDatos(xmlProceso);
  }
  function datosImpresoraGral(): Array {
    return this.ctx.oficial_datosImpresoraGral();
  }
  function cambiarColor()
  {
    return this.ctx.oficial_cambiarColor();
  }
  function tbnMasPI_clicked()
  {
    return this.ctx.oficial_tbnMasPI_clicked();
  }
  function tbnMasPIMS_clicked()
  {
    return this.ctx.oficial_tbnMasPIMS_clicked();
  }
  function tbnColores_clicked()
  {
    return this.ctx.oficial_tbnColores_clicked();
  }
  function tbnCantidades_clicked()
  {
    return this.ctx.oficial_tbnCantidades_clicked();
  }
  function habilitarBotonColor()
  {
    return this.ctx.oficial_habilitarBotonColor();
  }
  function habilitarPorReferencia()
  {
    return this.ctx.oficial_habilitarPorReferencia();
  }
  function dameArrayDimensiones(area: String): Array {
    return this.ctx.oficial_dameArrayDimensiones(area);
  }
  function cargarCantidades(): Boolean {
    return this.ctx.oficial_cargarCantidades();
  }
  function crearRegistroCantidades(cursor: FLSqlCursor): Boolean {
    return this.ctx.oficial_crearRegistroCantidades(cursor);
  }
  function crearRegistroColor(cursor: FLSqlCursor): Boolean {
    return this.ctx.oficial_crearRegistroColor(cursor);
  }
  function ponerPinza(): Boolean {
    return this.ctx.oficial_ponerPinza();
  }
  function habilitarTroquelado(): Boolean {
    return this.ctx.oficial_habilitarTroquelado();
  }
  function habilitarPelado(): Boolean {
    return this.ctx.oficial_habilitarPelado();
  }
  function habilitarMaculas(): Boolean {
    return this.ctx.oficial_habilitarMaculas();
  }
  function habilitarEnvio(): Boolean {
    return this.ctx.oficial_habilitarEnvio();
  }
  function comprobarRegistroEnvio(): Boolean {
    return this.ctx.oficial_comprobarRegistroEnvio();
  }
  function crearRegistroEnvio(cursor: FLSqlCursor, desdeForm: Boolean): Boolean {
    return this.ctx.oficial_crearRegistroEnvio(cursor, desdeForm);
  }
  function establecerFiltroPliego()
  {
    return this.ctx.oficial_establecerFiltroPliego();
  }
  function validarPlegado(xmlProceso: FLDomNode): Boolean {
    return this.ctx.oficial_validarPlegado(xmlProceso);
  }
  function initControles()
  {
    return this.ctx.oficial_initControles();
  }
  function informarDatosSobre()
  {
    return this.ctx.oficial_informarDatosSobre();
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
  function pub_guardarPlegado(nodoParam: FLDomNode, cursor: FLSqlCursor): Boolean {
    return this.guardarPlegado(nodoParam, cursor);
  }
  function pub_guardarDatos(cursor: FLSqlCursor): FLDomDocument {
    return this.guardarDatos(cursor);
  }
  function pub_crearRegistroCantidades(cursor: FLSqlCursor): Boolean {
    return this.crearRegistroCantidades(cursor);
  }
  function pub_crearRegistroColor(cursor: FLSqlCursor): Boolean {
    return this.crearRegistroColor(cursor);
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
function interna_init()
{
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  this.iface.xmlPrecortes_ = false;
  this.iface.xmlTPOs_ = false;

  connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");
  connect(this.child("chkSangriasInd"), "clicked()", this, "iface.habilitarPorSangria");
  connect(this.child("tbnPrecorte"), "clicked()", this, "iface.tbnPrecorte_clicked");
  connect(this.child("tbnTPO"), "clicked()", this, "iface.tbnTPO_clicked");
  connect(this.child("tbnTPMS"), "clicked()", this, "iface.tbnTPMS_clicked");
  connect(this.child("tbnBorrarPrecorte"), "clicked()", this, "iface.tbnBorrarPrecorte_clicked");
  connect(this.child("tbnBorrarTPO"), "clicked()", this, "iface.tbnBorrarTPO_clicked");
  connect(this.child("tbnBorrarTPMS"), "clicked()", this, "iface.tbnBorrarTPMS_clicked");

  connect(this.child("tbnMasPI"), "clicked()", this, "iface.tbnMasPI_clicked");
  connect(this.child("tbnMasPIMS"), "clicked()", this, "iface.tbnMasPIMS_clicked");
  connect(this.child("tbnColores"), "clicked()", this, "iface.tbnColores_clicked");
  connect(this.child("tbnCantidades"), "clicked()", this, "iface.tbnCantidades_clicked");

  if (this.iface.curCantidades_) {
    delete this.iface.curCantidades_;
  }
  this.iface.curCantidades_ = new FLSqlCursor("paramcantidad");
  connect(this.iface.curCantidades_, "bufferCommited()", this, "iface.cargarCantidades");

  //this.child("pushButtonAccept").enabled = false;
  this.iface.establecerFiltroPliego();
  this.child("fdbRefTroquel").setFilter("codfamilia = 'TROQ'");
  this.child("fdbIdImpresora").setFilter("tipoag = 'Impresora'");

  //  this.iface.bufferChanged("idimpresora");

  switch (cursor.modeAccess()) {
    case cursor.Insert: {
      debug("Insert");
      var idProducto: String = formRecordlineaspresupuestoscli.iface.idProductoSel_;
      if (!idProducto) {
        MessageBox.warning(util.translate("scripts", "No tiene ningún producto seleccionado"), MessageBox.Ok, MessageBox.NoButton);
        this.close();
      }
      if (util.sqlSelect("paramiptico", "id", "idproducto = " + idProducto)) {
        MessageBox.warning(util.translate("scrpts", "Ya hay un registro de parámetros para el producto seleccionado"), MessageBox.Ok, MessageBox.NoButton);
        this.close();
      }
      cursor.setValueBuffer("idproducto", idProducto);
      this.iface.cambiarColor();
      break;
    }
    case cursor.Edit: {
      debug("Edit");
      this.iface.cargarDatos();
      if (!util.sqlSelect("paramcolor", "id", "idparamiptico = " + cursor.valueBuffer("id"))) {
        this.iface.cambiarColor();
      }
      break;
    }
  }

  this.iface.habilitarPorSangria();
  this.iface.habilitarBotonColor();
  this.iface.habilitarPorReferencia();
  this.iface.habilitarTroquelado();
  this.iface.habilitarPelado();
  this.iface.habilitarMaculas();
  this.iface.habilitarEnvio();

  this.iface.initControles();
}

function interna_calculateField(fN: String): String {
  var cursor: FLSqlCursor = this.cursor();
  var valor: String;
  switch (fN)
  {
    case "numcopias": {
      if (cursor.valueBuffer("troquelado")) {
        var trabajosTroquel: Number = parseInt(cursor.valueBuffer("trabajostroquel"));
        if (isNaN(trabajosTroquel) || trabajosTroquel == 0) {
          valor = 0;
          break;
        }
        valor = Math.ceil(parseInt(cursor.valueBuffer("numcopiastroquel")) / trabajosTroquel);
      } else {
        valor = cursor.valueBuffer("numcopias");
      }
      break;
    }
  }
  return valor;
}

function interna_validateForm(): Boolean {
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  var xmlDocParam: FLDomDocument = this.iface.guardarDatos(cursor);
  if (!xmlDocParam)
  {
    return false;
  }

  if (!this.iface.comprobarRegistroEnvio())
  {
    MessageBox.warning(util.translate("scripts", "Error al comprobar los datos de envío"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }

  debug(xmlDocParam.toString());

  if (!this.iface.validarDatos(xmlDocParam.firstChild()))
  {
    return false;
  }

  cursor.setValueBuffer("xml", xmlDocParam.toString());

  return true;
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_tbnMasPI_clicked()
{
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  if (!this.iface.xmlTPOActual_) {
    MessageBox.warning(util.translate("scripts", "No hay una distribución seleccionada"), MessageBox.Ok, MessageBox.NoButton);
    return;
  }

  var xmlDocParam: FLDomDocument = this.iface.guardarDatos(cursor);
  if (!xmlDocParam) {
    return false;
  }

  var idUsuario = sys.nameUser();
  if (!util.sqlDelete("parampliego", "idusuario = '" + idUsuario + "'")) {
    return false;
  }

  var parametros: String = xmlDocParam.toString(4);

  var f: Object = new FLFormSearchDB("parampliego");
  var curPP: FLSqlCursor = f.cursor();

  curPP.setModeAccess(curPP.Insert);
  curPP.refreshBuffer();
  curPP.setValueBuffer("idusuario", idUsuario);
  curPP.setValueBuffer("xml", parametros);
  curPP.setValueBuffer("altopi", cursor.valueBuffer("altopi"));
  curPP.setValueBuffer("anchopi", cursor.valueBuffer("anchopi"));

  f.setMainWidget();
  var xml: String = f.exec("xml");
}

function oficial_tbnMasPIMS_clicked()
{
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  if (!this.iface.xmlTPMSActual_) {
    MessageBox.warning(util.translate("scripts", "No hay una distribución seleccionada"), MessageBox.Ok, MessageBox.NoButton);
    return;
  }

  var xmlDocParam: FLDomDocument = this.iface.guardarDatos(cursor);
  if (!xmlDocParam) {
    return false;
  }

  var idUsuario = sys.nameUser();
  if (!util.sqlDelete("parampliego", "idusuario = '" + idUsuario + "'")) {
    return false;
  }

  var parametros: String = xmlDocParam.toString(4);

  var f: Object = new FLFormSearchDB("parampliego");
  var curPP: FLSqlCursor = f.cursor();

  curPP.setModeAccess(curPP.Insert);
  curPP.refreshBuffer();
  curPP.setValueBuffer("idusuario", idUsuario);
  curPP.setValueBuffer("xml", parametros);
  curPP.setValueBuffer("altopi", cursor.valueBuffer("altopi"));
  curPP.setValueBuffer("anchopi", cursor.valueBuffer("anchopi"));

  f.setMainWidget();
  var xml: String = f.exec("xml");
}


function oficial_cargarDatos()
{
  var cursor: FLSqlCursor = this.cursor();
  var xmlParam: FLDomDocument = new FLDomDocument;
  if (!xmlParam.setContent(cursor.valueBuffer("xml"))) {
    return;
  }

  if (!this.iface.cargarCantidades()) {
    return false;
  }

  var xmlAux: FLDomNode;
  var xmlElemento: FLDomElement;
  var nodoParam: FLDomNode = xmlParam.firstChild();

  xmlElemento = nodoParam.namedItem("PliegoImpresionParam");
  if (xmlElemento && xmlElemento.toElement().attribute("Corte") != "") {
    this.iface.xmlPrecortes_ = new FLDomDocument;
    this.iface.xmlPrecortes_.setContent("<Precortes/>");
    this.iface.xmlPrecortes_.firstChild().appendChild(xmlElemento.cloneNode());
    this.iface.xmlPrecorteActual_ = this.iface.xmlPrecortes_.firstChild().firstChild();
    this.iface.mostrarPrecorte();
    this.child("tbnPrecorte").enabled = false;
  }

  xmlElemento = nodoParam.namedItem("TrabajosPliegoParam");
  if (xmlElemento) {
    if (xmlElemento.toElement().attribute("EjeSim") == "V" || xmlElemento.toElement().attribute("EjeSim") == "H") {
      this.iface.xmlTPMSs_ = new FLDomDocument;
      this.iface.xmlTPMSs_.setContent("<TrabajosPliegoVar/>");
      this.iface.xmlTPMSs_.firstChild().appendChild(xmlElemento.cloneNode());
      this.iface.xmlTPMSActual_ = this.iface.xmlTPMSs_.firstChild().firstChild();
      this.iface.mostrarTPMS();
      this.child("tbnTPMS").enabled = false;
    } else {
      this.iface.xmlTPOs_ = new FLDomDocument;
      this.iface.xmlTPOs_.setContent("<TrabajosPliegoVar/>");
      this.iface.xmlTPOs_.firstChild().appendChild(xmlElemento.cloneNode());
      this.iface.xmlTPOActual_ = this.iface.xmlTPOs_.firstChild().firstChild();
      this.iface.mostrarTPO();
      this.child("tbnTPO").enabled = false;
    }
  }


}

function oficial_cargarCantidades(): Boolean {
  debug("oficial_cargarCantidades");
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  var contenido: String = util.sqlSelect("paramcantidad", "xml", "idparamiptico = " + cursor.valueBuffer("id"));
  if (!contenido)
  {
    return false;
  }
  debug("oficial_cargarCantidades2");
  var xmlParam: FLDomDocument = new FLDomDocument;
  if (!xmlParam.setContent(contenido))
  {
    return;
  }
  debug("oficial_cargarCantidades3:\n" + contenido);
  // flfacturac.iface.distribuirModelosDC(xmlParam);
  var xmlAux: FLDomNode;
  var xmlElemento: FLDomElement;
  var nodoPaginas: FLDomNode = xmlParam.firstChild();

  xmlElemento = nodoPaginas.toElement()
  if (xmlElemento)
  {
    this.child("fdbNumPaginas").setValue(xmlElemento.attribute("NumPaginas"));
    if (xmlElemento.attribute("CantidadesPorModelo") == "true") {
      this.child("chkCantidadesPorModelo").checked = true;
      this.child("fdbNumCopias").setValue("");
      this.child("fdbNumCopias").setDisabled(true);
      this.child("fdbNumPaginas").setDisabled(true);
    } else {
      this.child("chkCantidadesPorModelo").checked = false;
      this.child("fdbNumCopias").setValue(xmlElemento.attribute("NumCopias"));
      this.child("fdbNumCopias").setDisabled(false);
      this.child("fdbNumPaginas").setDisabled(false);
    }
  }
  return true;
}

function oficial_cambiarColor()
{
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  var dosCaras: Boolean;
  var colores: String = cursor.valueBuffer("colores");
  debug("Colores ");
  switch (colores) {
    case "1+1":
    case "4+4": {
      dosCaras = true;
      if (!this.iface.crearRegistroColor(cursor)) {
        return false;
      }
      break;
    }
    case "1+0":
    case "4+0": {
      dosCaras = false;
      if (!this.iface.crearRegistroColor(cursor)) {
        return false;
      }
      break;
    }
    case "Otros": {
      break;
    }
  }

  this.child("fdbDosCaras").setValue(dosCaras);
  this.iface.habilitarBotonColor();
}

function oficial_crearRegistroColor(cursor: FLSqlCursor): Boolean {
  var util: FLUtil = new FLUtil;

  var dosCaras: Boolean;
  var colores: String = cursor.valueBuffer("colores");
  var curColores: FLSqlCursor = new FLSqlCursor("paramcolor");
  //  curColores.select("idparamiptico = " + cursor.valueBuffer("id"));
  switch (colores)
  {
    case "4+4": {
      dosCaras = true;
      if (!util.sqlDelete("paramcolor", "idparamiptico = " + cursor.valueBuffer("id"))) {
        return false;
      }

      curColores.setModeAccess(curColores.Insert);
      curColores.refreshBuffer();
      curColores.setValueBuffer("idparamiptico", cursor.valueBuffer("id"));
      curColores.setValueBuffer("coloresreg", true);
      curColores.setValueBuffer("doscaras", dosCaras);
      curColores.setValueBuffer("colorf1", "Cian");
      curColores.setValueBuffer("colorf2", "Magenta");
      curColores.setValueBuffer("colorf3", "Negro");
      curColores.setValueBuffer("colorf4", "Amarillo");
      curColores.setValueBuffer("colorv1", "Cian");
      curColores.setValueBuffer("colorv2", "Magenta");
      curColores.setValueBuffer("colorv3", "Negro");
      curColores.setValueBuffer("colorv4", "Amarillo");
      xml = formRecordparamcolor.iface.pub_xmlColores(curColores);
      if (!xml) {
        return false;
      }
      curColores.setValueBuffer("xml", xml);
      if (!curColores.commitBuffer()) {
        return false;
      }
      break;
    }
    case "4+0": {
      dosCaras = false;
      if (!util.sqlDelete("paramcolor", "idparamiptico = " + cursor.valueBuffer("id"))) {
        return false;
      }

      curColores.setModeAccess(curColores.Insert);
      curColores.refreshBuffer();
      curColores.setValueBuffer("idparamiptico", cursor.valueBuffer("id"));
      curColores.setValueBuffer("coloresreg", true);
      curColores.setValueBuffer("doscaras", dosCaras);
      curColores.setValueBuffer("colorf1", "Cian");
      curColores.setValueBuffer("colorf2", "Magenta");
      curColores.setValueBuffer("colorf3", "Negro");
      curColores.setValueBuffer("colorf4", "Amarillo");
      xml = formRecordparamcolor.iface.pub_xmlColores(curColores);
      if (!xml) {
        return false;
      }
      curColores.setValueBuffer("xml", xml);
      if (!curColores.commitBuffer()) {
        return false;
      }
      break;
    }
    case "1+1": {
      dosCaras = true;
      if (!util.sqlDelete("paramcolor", "idparamiptico = " + cursor.valueBuffer("id"))) {
        return false;
      }

      curColores.setModeAccess(curColores.Insert);
      curColores.refreshBuffer();
      curColores.setValueBuffer("idparamiptico", cursor.valueBuffer("id"));
      curColores.setValueBuffer("coloresreg", false);
      curColores.setValueBuffer("doscaras", dosCaras);
      curColores.setValueBuffer("colorf1", "Negro");
      curColores.setValueBuffer("colorv1", "Negro");
      xml = formRecordparamcolor.iface.pub_xmlColores(curColores);
      if (!xml) {
        return false;
      }
      curColores.setValueBuffer("xml", xml);
      if (!curColores.commitBuffer()) {
        return false;
      }
      break;
    }
    case "1+0": {
      dosCaras = false;
      if (!util.sqlDelete("paramcolor", "idparamiptico = " + cursor.valueBuffer("id"))) {
        return false;
      }

      curColores.setModeAccess(curColores.Insert);
      curColores.refreshBuffer();
      curColores.setValueBuffer("idparamiptico", cursor.valueBuffer("id"));
      curColores.setValueBuffer("coloresreg", false);
      curColores.setValueBuffer("doscaras", dosCaras);
      curColores.setValueBuffer("colorf1", "Negro");
      xml = formRecordparamcolor.iface.pub_xmlColores(curColores);
      if (!xml) {
        return false;
      }
      curColores.setValueBuffer("xml", xml);
      if (!curColores.commitBuffer()) {
        return false;
      }
      break;
    }
  }
  return true;
}

function oficial_habilitarBotonColor()
{
  debug("oficial_habilitarBotonColor");
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  var colores: String = cursor.valueBuffer("colores");
  switch (colores) {
    case "4+4":
    case "4+0":
    case "1+1":
    case "1+0": {
      this.child("tbnColores").enabled = false;
      this.child("fdbTintas").setValue(colores);
      break;
    }
    default: {
      this.child("tbnColores").enabled = true;
      var otrosColores: String = "";
      var contenidoColor: String = util.sqlSelect("paramcolor", "xml", "idparamiptico = " + cursor.valueBuffer("id"));
      if (contenidoColor) {
        var xmlColor: FLDomDocument = new FLDomDocument;
        if (xmlColor.setContent(contenidoColor)) {
          otrosColores = xmlColor.firstChild().toElement().attribute("Valor");
        }
      }
      this.child("fdbTintas").setValue(otrosColores);
      break;
    }
  }
}

function oficial_cargarDiseno(eDiseno: FLDomElement): Boolean {
  var valor: String = eDiseno.attribute("Valor");
  if (!valor || valor == "")
  {
    this.child("fdbDiseno").setValue(true);
    return true;
  } else {
    if (valor == "true")
    {
      this.child("fdbDiseno").setValue(true);
    } else {
      this.child("fdbDiseno").setValue(false);
    }
  }

  var tiempoDiseno: Number = parseFloat(eDiseno.attribute("TiempoUsuario"));
  if (isNaN(tiempoDiseno))
  {
    this.child("fdbTiempoDiseno").setValue("");
  } else {
    this.child("fdbTiempoDiseno").setValue(tiempoDiseno);
  }
  return true;
}

function oficial_cargarAreaT(eAreaT: FLDomElement): Boolean {
  var valor: String = eAreaT.attribute("Valor");
  if (!valor || valor == "")
  {
    this.child("fdbAnchoT").setValue("");
    this.child("fdbAltoT").setValue("");
    return true;
  }
  var dim: Array = valor.split("x");
  this.child("fdbAnchoT").setValue(dim[0]);
  this.child("fdbAltoT").setValue(dim[1]);

  return true;
}

function oficial_cargarPlastificado(ePlastificado: FLDomElement): Boolean {
  var cursor: FLSqlCursor = this.cursor();

  var valor: String;
  if (!ePlastificado)
  {
    valor = "NN";
  } else {
    valor = ePlastificado.attribute("Valor");
  }

  switch (valor.charAt(0))
  {
    case "B": {
      cursor.setValueBuffer("plasfrente", "Brillo");
      break;
    }
    case "M": {
      cursor.setValueBuffer("plasfrente", "Mate");
      break;
    }
    default: {
      cursor.setValueBuffer("plasfrente", "No");
      break;
    }
  }
  switch (valor.charAt(1))
  {
    case "B": {
      cursor.setValueBuffer("plasvuelta", "Brillo");
      break;
    }
    case "M": {
      cursor.setValueBuffer("plasvuelta", "Mate");
      break;
    }
    default: {
      cursor.setValueBuffer("plasvuelta", "No");
      break;
    }
  }

  return true;
}

function oficial_cargarPlegado(ePliegues: FLDomElement): Boolean {
  var valor: Number = ePliegues.attribute("Horizontales");
  this.child("fdbPlieguesHor").setValue(valor);

  valor = ePliegues.attribute("Verticales");
  this.child("fdbPlieguesVer").setValue(valor);
  return true;
}

function oficial_cargarSangria(eSangria: FLDomElement): Boolean {
  var valor: String = eSangria.attribute("Arriba");
  var unicoValor: String = valor;
  var independientes: Boolean = false;

  this.child("fdbSangriaSup").setValue(valor);

  valor = eSangria.attribute("Abajo");
  if (independientes && unicoValor != valor)
  {
    independientes = true;
  }
  this.child("fdbSangriaInf").setValue(valor);

  valor = eSangria.attribute("Izquierda");
  if (independientes && unicoValor != valor)
  {
    independientes = true;
  }
  this.child("fdbSangriaIzq").setValue(valor);

  valor = eSangria.attribute("Derecha");
  if (independientes && unicoValor != valor)
  {
    independientes = true;
  }
  this.child("fdbSangriaDer").setValue(valor);

  if (independientes)
  {
    this.child("chkSangriasInd").checked = true;
  }
  this.iface.habilitarPorSangria();

  return true;
}

function oficial_habilitarPorSangria()
{
  var cursor: FLSqlCursor = this.cursor();
  if (this.child("chkSangriasInd").checked == true) {
    this.child("fdbSangriaInf").setDisabled(false);
    this.child("fdbSangriaDer").setDisabled(false);
    this.child("fdbSangriaIzq").setDisabled(false);
    this.iface.bufferChanged("sangriasup");
  } else {
    this.child("fdbSangriaInf").setDisabled(true);
    this.child("fdbSangriaDer").setDisabled(true);
    this.child("fdbSangriaIzq").setDisabled(true);
  }
}

function oficial_bufferChanged(fN: String)
{
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();
  switch (fN) {
    case "sangriasup": {
      if (this.child("chkSangriasInd").checked == false) {
        this.child("fdbSangriaInf").setValue(cursor.valueBuffer("sangriasup"));
        this.child("fdbSangriaDer").setValue(cursor.valueBuffer("sangriasup"));
        this.child("fdbSangriaIzq").setValue(cursor.valueBuffer("sangriasup"));
      }
      break;
    }
    case "refpliego": {
      debug("Pliego = " + cursor.valueBuffer("refpliego"));
      var codFormato: String = util.sqlSelect("articulos", "codformato", "referencia = '" + cursor.valueBuffer("refpliego") + "'");
      debug("formato = " + codFormato);
      if (codFormato && codFormato != "" && codFormato.toLowerCase() == "sobre") {
        this.iface.informarDatosSobre();
      } else {
        this.iface.tbnBorrarPrecorte_clicked();
      }
      break;
    }
    case "altot":
    case "anchot": {
      this.iface.tbnBorrarPrecorte_clicked();
      break;
    }
    case "estiloimpresion": {
      if (cursor.valueBuffer("estiloimpresion") == "TiraRetira") {
        this.iface.tbnBorrarTPO_clicked();
      }
      if (!this.iface.ponerPinza()) {
        return false;
      }
      break;
    }
    case "idimpresora": {
      if (!this.iface.ponerPinza()) {
        return false;
      }
      debug("Pinza puesta");
      var idImpresora: String = cursor.valueBuffer("idimpresora");
      if (!idImpresora || idImpresora == "") {
        return;
      }
      var xmlImpresora: FLDomNode = flfacturac.iface.pub_dameParamCentroCoste(idImpresora);
      if (!xmlImpresora) {
        return;
      }
      var datosImpresora: String = util.translate("scripts", "%1\nÁrea máx: %2\nÁrea mín: %3").arg(idImpresora).arg(xmlImpresora.toElement().attribute("AreaMax")).arg(xmlImpresora.toElement().attribute("AreaMin"));
      this.child("lblPliegoImpresion").text = datosImpresora;

      //      this.iface.tbnBorrarTPO_clicked();
      //      this.iface.tbnBorrarTPMS_clicked();
      debug("Validando");
      if (!flfacturac.iface.pub_validarPinzas(xmlProceso.firstChild())) {
        MessageBox.warning(util.translate("scripts", "La distribución escogida no encaja en el pliego de impresión para la impresora y estilo de impresión escogidos"), MessageBox.Ok, MessageBox.NoButton);
        return false;
      }
      debug("Validando OK");
      break;
    }
    case "colores": {
      this.iface.cambiarColor();
      break;
    }
    case "codmarcapapel":
    case "codcalidad":
    case "gramaje": {
      this.iface.establecerFiltroPliego();
      break;
    }
    case "troquelado": {
      this.iface.habilitarTroquelado();
      if (cursor.valueBuffer("troquelado")) {
        this.child("fdbNumCopiasTroquel").setValue(cursor.valueBuffer("numcopias"));
        this.child("fdbTrabajosTroquel").setValue(1);
        //        this.child("fdbNumCopias").setValue(this.iface.calculateField("numcopias"));
      } else {
        this.child("fdbTrabajosTroquel").setValue("");
      }
      break;
    }
    case "pelado": {
      this.iface.habilitarPelado();
      break;
    }
    case "numcopiastroquel":
    case "trabajostroquel": {
      this.child("fdbNumCopias").setValue(this.iface.calculateField("numcopias"));
    }
    case "maculasmanual": {
      this.iface.habilitarMaculas();
      if (!cursor.valueBuffer("maculasmanual")) {
        this.child("fdbTotalMaculas").setValue("");
      }
      break;
    }
    case "ignorarenvio": {
      if (cursor.valueBuffer("ignorarenvio")) {
        this.iface.comprobarRegistroEnvio();
        this.child("tdbParamEnvio").refresh();
      }
      this.iface.habilitarEnvio();
      break;
    }
  }
}

function oficial_establecerFiltroPliego()
{
  var cursor: FLSqlCursor = this.cursor();
  var filtro: String = "codfamilia = 'PAPE'";
  var gramaje: String = cursor.valueBuffer("gramaje");
  if (gramaje && gramaje != "") {
    filtro += " AND gramaje = " + gramaje;
  }
  var codCalidad: String = cursor.valueBuffer("codcalidad");
  if (codCalidad && codCalidad != "") {
    filtro += " AND codcalidad = '" + codCalidad + "'";
  }
  var codMarcaPapel: String = cursor.valueBuffer("codmarcapapel");
  if (codMarcaPapel && codMarcaPapel != "") {
    filtro += " AND codmarcapapel = '" + codMarcaPapel + "'";
  }
  this.child("fdbRefPliego").setFilter(filtro);
}
function oficial_habilitarTroquelado()
{
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  if (cursor.valueBuffer("troquelado")) {
    this.child("gbxTroquelado").enabled = true;
    this.child("fdbNumCopias").setDisabled(true);
    this.child("fdbPelado").setDisabled(false);
  } else {
    this.child("gbxTroquelado").enabled = false
                                          this.child("fdbNumCopias").setDisabled(false);
    this.child("fdbPelado").setValue(false);
    this.child("fdbPelado").setDisabled(true);
  }
}

function oficial_habilitarPelado()
{
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  if (cursor.valueBuffer("pelado")) {
    this.child("gbxPelado").enabled = true;
  } else {
    this.child("gbxPelado").enabled = false
  }
}

                                  function oficial_habilitarMaculas()
{
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  if (cursor.valueBuffer("maculasmanual")) {
    this.child("fdbTotalMaculas").setDisabled(false);
  } else {
    this.child("fdbTotalMaculas").setDisabled(true);
  }
}

function oficial_ponerPinza(): Boolean {
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  var xmlDocParam: FLDomDocument = this.iface.guardarDatos(cursor);
  if (!xmlDocParam)
  {
    return false;
  }
  var xmlProceso: FLDomDocument = new FLDomDocument();
  xmlProceso.setContent("<Proceso/>");
  xmlProceso.firstChild().appendChild(xmlDocParam.firstChild().cloneNode());
  if (!flfacturac.iface.pub_nodoXMLPinza(xmlProceso.firstChild()))
  {
    return false;
  }
  this.iface.mostrarTPO();
  this.iface.mostrarTPMS();
}

function oficial_tbnPrecorte_clicked()
{
  debug(1);
  if (!this.iface.xmlPrecortes_) {
    if (!this.iface.cargarPrecortes())
      return;
    this.iface.xmlPrecorteActual_ = this.iface.xmlPrecortes_.firstChild().firstChild();
    // debug(this.iface.xmlPrecortes_.toString(4));
    // debug(this.iface.xmlPrecorteActual_.nodeName());
  } else {
    this.iface.xmlPrecorteActual_ = this.iface.xmlPrecorteActual_.nextSibling();
  }
  if (!this.iface.xmlPrecorteActual_)
    this.iface.xmlPrecorteActual_ = this.iface.xmlPrecortes_.firstChild().firstChild();

  this.iface.mostrarPrecorte();
  this.iface.tbnBorrarTPO_clicked();
  this.iface.tbnBorrarTPMS_clicked();
}

function oficial_cargarPrecortes(): Boolean {
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  var altoT: String = this.child("fdbAltoT").value();
  if (!altoT || altoT == "")
  {
    MessageBox.warning(util.translate("scripts", "Debe establecer el alto del trabajo"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  var anchoT: String = this.child("fdbAnchoT").value();
  if (!anchoT || anchoT == "")
  {
    MessageBox.warning(util.translate("scripts", "Debe establecer el ancho del trabajo"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  var areaTrabajo: String = anchoT + "x" + altoT;

  var refPliego: String = cursor.valueBuffer("refpliego");
  if (!refPliego || refPliego == "")
  {
    MessageBox.warning(util.translate("scripts", "Debe establecer el pliego a utilizar"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  var anchoP: String = util.sqlSelect("articulos", "anchopliego", "referencia = '" + refPliego + "'");
  var altoP: String = util.sqlSelect("articulos", "altopliego", "referencia = '" + refPliego + "'");
  var areaPliego: String = anchoP + "x" + altoP;

  var codImpresora: String = cursor.valueBuffer("idimpresora");
  if (codImpresora == "")
    codImpresora = false;

  var contenido: String = flfacturac.iface.pub_divisionesPliego(areaTrabajo, areaPliego, codImpresora);
  if (!contenido || contenido == "")
  {
    MessageBox.warning(util.translate("scripts", "No se han obtenido precortes para los datos introducidos"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  contenido = "<Precortes>" + contenido + "</Precortes>";
  this.iface.xmlPrecortes_ = new FLDomDocument;
  this.iface.xmlPrecortes_.setContent(contenido);

  return true;
}

function oficial_tbnBorrarPrecorte_clicked()
{
  delete this.iface.xmlPrecortes_;
  this.iface.xmlPrecortes_ = false;
  this.iface.xmlPrecorteActual_ = false;
  this.iface.mostrarPrecorte();

  this.iface.tbnBorrarTPO_clicked();
  this.iface.tbnBorrarTPMS_clicked();
  this.child("tbnPrecorte").enabled = true;
}

function oficial_tbnBorrarTPO_clicked()
{
  delete this.iface.xmlTPOs_;
  this.iface.xmlTPOs_ = false;
  this.iface.xmlTPOActual_ = false;
  this.iface.mostrarTPO();
  this.child("tbnTPO").enabled = true;
}

function oficial_tbnBorrarTPMS_clicked()
{
  delete this.iface.xmlTPMSs_;
  this.iface.xmlTPMSs_ = false;
  this.iface.xmlTPMSActual_ = false;
  this.iface.mostrarTPMS();
  this.child("tbnTPMS").enabled = true;
}

function oficial_mostrarPrecorte()
{
  var dimPliego: String = this.child("fdbAnchoP").value() + "x" + this.child("fdbAltoP").value();
  if (!this.iface.xmlPrecorteActual_) {
    this.child("fdbPrecorte").setValue("");
    this.child("fdbAltoPI").setValue("");
    this.child("fdbAnchoPI").setValue("");
  } else {
    var precorte: String = this.iface.xmlPrecorteActual_.toElement().attribute("Corte");
    this.child("fdbPrecorte").setValue(precorte);
    var dimPI: Array = this.iface.xmlPrecorteActual_.toElement().attribute("Valor").split("x");
    this.child("fdbAltoPI").setValue(dimPI[1]);
    this.child("fdbAnchoPI").setValue(dimPI[0]);
  }
  flfacturac.iface.pub_mostrarPrecorte(this.child("lblDiagPrecorte"), this.iface.xmlPrecorteActual_, dimPliego);
}


function oficial_tbnTPO_clicked()
{
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();
  if (cursor.valueBuffer("estiloimpresion") == "TiraRetira") {
    MessageBox.warning(util.translate("scripts", "Si el estilo es TiraRetira la distribución debe ser simétrica"), MessageBox.Ok, MessageBox.NoButton);
    return;
  }
  if (!this.iface.xmlTPOs_ || !this.iface.xmlTPOActual_) {
    if (!this.iface.cargarTPOs())
      return;

    if (!this.iface.xmlTPOs_.firstChild().hasChildNodes()) {
      MessageBox.warning(util.translate("scripts", "No existen distribuciones para el las dimensiones de pliego y el precorte indicados"), MessageBox.Ok, MessageBox.NoButton);
      return;
    }
    this.iface.xmlTPOActual_ = flfacturac.iface.pub_dameNodoXML(this.iface.xmlTPOs_.firstChild(), "TrabajosPliegoParam[@Optima=true]");
    if (!this.iface.xmlTPOActual_)
      return;
  } else {
    this.iface.xmlTPOActual_ = this.iface.xmlTPOActual_.nextSibling();
  }
  if (!this.iface.xmlTPOActual_) {
    this.iface.xmlTPOActual_ = this.iface.xmlTPOs_.firstChild().firstChild();
  }

  this.iface.mostrarTPO();
}

function oficial_tbnTPMS_clicked()
{
  var util: FLUtil = new FLUtil;
  if (!this.iface.xmlTPMSs_ || !this.iface.xmlTPMSActual_) {
    if (!this.iface.cargarTPMSs())
      return;

    if (!this.iface.xmlTPMSs_.firstChild().hasChildNodes()) {
      MessageBox.warning(util.translate("scripts", "No existen distribuciones simétricas"), MessageBox.Ok, MessageBox.NoButton);
      return;
    }
    this.iface.xmlTPMSActual_ = this.iface.xmlTPMSs_.firstChild().firstChild();
  } else {
    this.iface.xmlTPMSActual_ = this.iface.xmlTPMSActual_.nextSibling();
  }
  if (!this.iface.xmlTPMSActual_) {
    this.iface.xmlTPMSActual_ = this.iface.xmlTPMSs_.firstChild().firstChild();
  }

  this.iface.mostrarTPMS();
}

function oficial_cargarTPOs(): Boolean {
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  var precorte: String = cursor.valueBuffer("precorte");
  if (!precorte || precorte == "")
  {
    MessageBox.warning(util.translate("scripts", "Debe establecer el precorte"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }

  var xmlDocParam: FLDomDocument = this.iface.guardarDatos(cursor);
  if (!xmlDocParam)
  {
    return false;
  }

  var referencia: String = util.sqlSelect("productoslp", "referencia", "idproducto = " + cursor.valueBuffer("idproducto"));
  var xmlDocProceso: FLDomDocument = new FLDomDocument;
  xmlDocProceso.setContent("<Producto Ref=\"" + referencia + "\"><Proceso/></Producto>");
  var xmlProceso: FLDomNode = xmlDocProceso.firstChild().firstChild();
  xmlProceso.appendChild(xmlDocParam.firstChild());
  // debug("Cargar TPOs " + xmlDocProceso.toString(4));

  this.iface.xmlTPOs_ = new FLDomDocument;
  var nodoOT: FLDomNode = flfacturac.iface.trabajosXPliego(xmlProceso);
  if (!nodoOT)
  {
    return false;
  }

  this.iface.xmlTPOs_.appendChild(nodoOT.cloneNode());
  //debug(xmlDocParam.toString(4));

  return true;
}

function oficial_cargarTPMSs(): Boolean {
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  var precorte: String = cursor.valueBuffer("precorte");
  if (!precorte || precorte == "")
  {
    MessageBox.warning(util.translate("scripts", "Debe establecer el precorte"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }

  var xmlDocParam: FLDomDocument = this.iface.guardarDatos(cursor);
  if (!xmlDocParam)
  {
    return false;
  }

  var referencia: String = util.sqlSelect("productoslp", "referencia", "idproducto = " + cursor.valueBuffer("idproducto"));
  var xmlDocProceso: FLDomDocument = new FLDomDocument;
  xmlDocProceso.setContent("<Producto Ref=\"" + referencia + "\"><Proceso/></Producto>");
  var xmlProceso: FLDomNode = xmlDocProceso.firstChild().firstChild();
  xmlProceso.appendChild(xmlDocParam.firstChild());
  debug(xmlDocProceso.toString(4));
  this.iface.xmlTPMSs_ = new FLDomDocument;
  var nodoOT: FLDomDocument = flfacturac.iface.trabajosXPliegoSim(xmlProceso);
  if (!nodoOT)
  {
    return false;
  }

  this.iface.xmlTPMSs_.appendChild(nodoOT.cloneNode());
  //debug(xmlDocParam.toString(4));

  return true;
}


function oficial_mostrarTPO()
{
  var dimPI: String = this.child("fdbAnchoPI").value() + "x" + this.child("fdbAltoPI").value();

  // debug("oficial_mostrarTPO");
  if (!this.iface.xmlTPOActual_) {
    // debug("oficial_mostrarTPO NO HAY ACTUAL");
    this.child("lblOptimo").text = "";
    flfacturac.iface.pub_mostrarTrabajosPliego(this.child("lblDiagTPO"), false, dimPI, false);
    return;
  }

  var texto: String = "(" + this.iface.xmlTPOActual_.toElement().attribute("Eficiencia") + "%)";
  if (this.iface.xmlTPOActual_.toElement().attribute("Optima") == "true")
    texto += "*";
  this.child("lblOptimo").text = texto;

  var cursor: FLSqlCursor = this.cursor();
  var xmlDocParam: FLDomDocument = this.iface.guardarDatos(cursor);
  if (!xmlDocParam) {
    return false;
  }
  var xmlProceso: FLDomDocument = new FLDomDocument();
  xmlProceso.setContent("<Proceso/>");
  xmlProceso.firstChild().appendChild(xmlDocParam.firstChild().cloneNode());

  // debug(xmlDocParam.toString(4));
  flfacturac.iface.pub_mostrarTrabajosPliego(this.child("lblDiagTPO"), xmlProceso.firstChild(), dimPI, false);

  return true;
}

function oficial_mostrarTPMS()
{
  var dimPI: String = this.child("fdbAnchoPI").value() + "x" + this.child("fdbAltoPI").value();
  // debug("oficial_mostrarTPMS");
  if (!this.iface.xmlTPMSActual_) {
    // debug("oficial_mostrarTPMS NO HAY ACTUAL");
    this.child("lblMejorSim").text = "";
    flfacturac.iface.pub_mostrarTrabajosPliego(this.child("lblDiagTPMS"), false, dimPI, false);
    return;
  }

  var texto: String = "(" + this.iface.xmlTPMSActual_.toElement().attribute("Eficiencia") + "%)";
  if (this.iface.xmlTPMSActual_.toElement().attribute("Optima") == "true")
    texto += "*";
  if (this.iface.xmlTPMSActual_.toElement().attribute("EjeSim") == "H")
    texto += "(H)";
  if (this.iface.xmlTPMSActual_.toElement().attribute("EjeSim") == "V")
    texto += "(V)";
  this.child("lblMejorSim").text = texto;

  var cursor: FLSqlCursor = this.cursor();
  var xmlDocParam: FLDomDocument = this.iface.guardarDatos(cursor);
  if (!xmlDocParam) {
    return false;
  }
  var xmlProceso: FLDomDocument = new FLDomDocument();
  xmlProceso.setContent("<Proceso/>");
  xmlProceso.firstChild().appendChild(xmlDocParam.firstChild().cloneNode());

  //  debug(xmlDocParam.toString(4));

  flfacturac.iface.pub_mostrarTrabajosPliego(this.child("lblDiagTPMS"), xmlProceso.firstChild(), dimPI, false);

  return true;
}

/*
  var factor:Number;
  if (anchoP > altoP) {
    factor = 100 / anchoP;
  } else {
    factor = 100 / altoP;
  }
  anchoP *= factor;
  altoP *= factor;
debug (anchoP + "x" + altoP);

  var lblPix = this.child( "lblDiagTPMS" );
  var pix = new Pixmap();
  var pic = new Picture();
  var devSize = new Size( 100, 100);
  pix.resize(devSize);
  var devRect = new Rect( 0, 0, anchoP, altoP);
  pic.begin();

  pix.resize(devSize);
  pix.fill( new Color(200, 200, 200) );

  if (!this.iface.xmlTPMSActual_) {
    this.child("lblMejorSim").text = "";
    pix = pic.playOnPixmap( pix );
    lblPix.pixmap = pix;
    pic.end();
    return;
  }

  var texto:String = "(" + this.iface.xmlTPMSActual_.toElement().attribute("Eficiencia") + "%)";
  if (this.iface.xmlTPMSActual_.toElement().attribute("Optima") == "true")
    texto += "*";
  if (this.iface.xmlTPMSActual_.toElement().attribute("EjeSim") == "H")
    texto += "(H)";
  if (this.iface.xmlTPMSActual_.toElement().attribute("EjeSim") == "V")
    texto += "(V)";
  this.child("lblMejorSim").text = texto;

  pic.setPen( new Color( 255, 0, 0 ) , 1 );
  pic.setBrush( new Color( 255, 255, 255 ) , 1 );
  pic.drawRect(devRect);
debug(this.iface.xmlTPMSActual_.nodeName());
  var eTP:FLDomElement = this.iface.xmlTPMSActual_.toElement();

  var trabajos:FLDomNodeList = eTP.elementsByTagName("Trabajo");
  var eTrabajo:FLDomElement;
  var w:Number = 0, h:Number = 0, x:Number = 0, y:Number = 0;

  var dibTrabajos:Array = [];
  pic.setPen( new Color( 255, 0, 0 ) , 1 );
  pic.setBrush( new Color( 0, 200, 0 ) , 1 );

  //var svg:String = "<svg width=\"300\" height=\"300\" x=\"0\" y=\"0\" id=\"0\"><g style=\"stroke:rgb(0,0,0);stroke-width:0.9;fill:none;\">";
  for (var i:Number = 0; i < trabajos.length(); i++) {
    eTrabajo = trabajos.item(i).toElement();
    x = parseFloat(eTrabajo.attribute("X")) * factor;
    y = parseFloat(eTrabajo.attribute("Y")) * factor;
    w = parseFloat(eTrabajo.attribute("W")) * factor;
    h = parseFloat(eTrabajo.attribute("H")) * factor;
    dibTrabajos[i] = new Rect(x, y, w, h);
debug("artesG_dibujarTP6");
    pic.drawRect(dibTrabajos[i]);
debug("artesG_dibujarTP7");
    //svg += "<rect width=\"" + eTrabajo.attribute("W") + "\" height=\"" + eTrabajo.attribute("H") + "\" x=\"" + eTrabajo.attribute("X") + "\" y=\"" + eTrabajo.attribute("Y") + "\" id=\"0\" style=\"stroke:rgb(0,0,0);stroke-width:0.9;fill:none;\" />";
  }

  pix = pic.playOnPixmap( pix );
  lblPix.pixmap = pix;
pic.end();
debug("artesG_dibujarTP2");
  //svg += "</g></svg>
//  return true;
}*/

function oficial_guardarDatos(cursor: FLSqlCursor): FLDomDocument {
  var util: FLUtil = new FLUtil;

  var xmlParam: FLDomDocument = new FLDomDocument;
  xmlParam.setContent("<Parametros/>");
  var nodoParam: FLDomNode = xmlParam.firstChild();
  var nodoAux: FLDomNode;

  var gramaje: String = cursor.valueBuffer("gramaje");
  if (!gramaje || gramaje == "" || gramaje == 0)
  {
    MessageBox.warning(util.translate("scripts", "Debe establecer el gramaje"), MessageBox.Ok, MessageBox.NoButton);
    return;
  }

  nodoAux = this.iface.crearNodoHijo(nodoParam, "GramajeParam");
  nodoAux.toElement().setAttribute("Valor", gramaje);

  var codMarcaPapel: String = cursor.valueBuffer("codmarcapapel");
  if (!codMarcaPapel || codMarcaPapel == "")
  {
    MessageBox.warning(util.translate("scripts", "Debe establecer la marca de papel"), MessageBox.Ok, MessageBox.NoButton);
    return;
  }
  nodoAux = this.iface.crearNodoHijo(nodoParam, "CodMarcaPapelParam");
  nodoAux.toElement().setAttribute("Valor", codMarcaPapel);

  var codCalidad: String = cursor.valueBuffer("codcalidad");
  if (!codCalidad || codCalidad == "")
  {
    MessageBox.warning(util.translate("scripts", "Debe establecer la calidad de papel"), MessageBox.Ok, MessageBox.NoButton);
    return;
  }
  nodoAux = this.iface.crearNodoHijo(nodoParam, "CalidadParam");
  nodoAux.toElement().setAttribute("Valor", codCalidad);

  if (!this.iface.guardarDiseno(nodoParam, cursor))
    return false;

  var areaTrabajo: String = cursor.valueBuffer("anchot") + "x" + cursor.valueBuffer("altot");
  if (!areaTrabajo || areaTrabajo.startsWith("x") || areaTrabajo.endsWith("x"))
  {
    MessageBox.warning(util.translate("scripts", "Debe establecer el área del trabajo"), MessageBox.Ok, MessageBox.NoButton);
    return;
  }
  nodoAux = this.iface.crearNodoHijo(nodoParam, "AreaTrabajoParam");
  nodoAux.toElement().setAttribute("Valor", areaTrabajo);

  if (!this.iface.guardarTareasSaltadas(nodoParam, cursor))
  {
    return false;
  }
  if (!this.iface.guardarPlastificado(nodoParam, cursor))
    return false;

  if (!this.iface.guardarPlegado(nodoParam, cursor))
    return false;

  if (!this.iface.guardarSangrias(nodoParam, cursor))
    return false;

  if (!this.iface.guardarPliego(nodoParam, cursor))
    return false;

  if (!this.iface.guardarPliegoImpresion(nodoParam, cursor))
    return false;

  if (!this.iface.guardarTrabajosPliego(nodoParam, cursor))
    return false;

  if (!this.iface.guardarImpresora(nodoParam, cursor))
    return false;

  if (!this.iface.guardarEstiloImpresion(nodoParam, cursor))
    return false;

  if (!flfacturac.iface.pub_nodoXMLPinza(xmlParam))
  {
    debug("!Nodo pinza");
    return false;
  }

  if (!this.iface.guardarColor(nodoParam, cursor))
    return false;

  if (!this.iface.guardarCantidad(nodoParam, cursor))
    return false;

  if (!this.iface.guardarTroquelado(nodoParam, cursor))
    return false;

  if (!this.iface.guardarMaculas(nodoParam, cursor))
    return false;

  if (!this.iface.guardarDatosLibro(nodoParam, cursor))
    return false;

  if (!this.iface.guardarOtros(nodoParam, cursor))
    return false;

  return xmlParam;
}


function oficial_guardarImpresora(nodoParam: FLDomNode, cursor: FLSqlCursor): Boolean {
  var util: FLUtil = new FLUtil;

  var idImpresora: String = cursor.valueBuffer("idimpresora");
  if (!idImpresora || idImpresora == "")
  {
    return true;
  }
  var nodoImpresora: FLDomNode = this.iface.crearNodoHijo(nodoParam, "TipoImpresoraParam");
  var xmlElemento: FLDomElement = nodoImpresora.toElement();

  var paramImpresora: FLDomNode = flfacturac.iface.pub_dameParamCentroCoste(idImpresora);
  if (!paramImpresora)
    return false;

  var refPlancha: String = paramImpresora.toElement().attribute("RefPlancha");
  var numCuerpos: String = paramImpresora.toElement().attribute("NumCuerpos");
  if (!numCuerpos || numCuerpos == "")
    numCuerpos = "0";

  var anchoPinza: String = paramImpresora.toElement().attribute("AnchoPinza");
  var areaPlancha: String = util.sqlSelect("articulos", "dimpliego", "referencia = '" + refPlancha + "'");

  xmlElemento.setAttribute("Valor", idImpresora);
  xmlElemento.setAttribute("AreaPlancha", areaPlancha);
  xmlElemento.setAttribute("RefPlancha", refPlancha);
  xmlElemento.setAttribute("NumCuerpos", numCuerpos);
  xmlElemento.setAttribute("AnchoPinza", anchoPinza);

  if (cursor.valueBuffer("maculasmanual"))
  {
    var totalMaculas: Number = parseInt(cursor.valueBuffer("totalmaculas"));
    if (isNaN(totalMaculas)) {
      totalMaculas = 0;
    }
    xmlElemento.setAttribute("MaculasManual", "true");
    xmlElemento.setAttribute("TotalMaculas", totalMaculas);
  } else {
    xmlElemento.setAttribute("MaculasManual", "false");
  }

  return true;
}

function oficial_guardarMaculas(nodoParam: FLDomNode, cursor: FLSqlCursor): Boolean {
  var util: FLUtil = new FLUtil;

  var nodoImpresora: FLDomNode = this.iface.crearNodoHijo(nodoParam, "MaculasParam");
  var xmlElemento: FLDomElement = nodoImpresora.toElement();

  if (cursor.valueBuffer("maculasmanual"))
  {
    var totalMaculas: Number = parseInt(cursor.valueBuffer("totalmaculas"));
    if (isNaN(totalMaculas)) {
      totalMaculas = 0;
    }
    xmlElemento.setAttribute("MaculasManual", "true");
    xmlElemento.setAttribute("TotalMaculas", totalMaculas);
  } else {
    xmlElemento.setAttribute("MaculasManual", "false");
  }

  return true;
}
function oficial_guardarEstiloImpresion(nodoParam: FLDomNode, cursor: FLSqlCursor): Boolean {
  var util: FLUtil = new FLUtil;

  var estiloImpresion: String = cursor.valueBuffer("estiloimpresion");
  if (estiloImpresion == "(calcular)" || estiloImpresion == "")
  {
    return true;
  }
  var nodoEstiloImpresion: FLDomNode = this.iface.crearNodoHijo(nodoParam, "EstiloImpresionParam");
  var xmlElemento: FLDomElement = nodoEstiloImpresion.toElement();
  xmlElemento.setAttribute("Valor", estiloImpresion);

  return true;
}

function oficial_guardarTroquelado(nodoParam: FLDomNode, cursor: FLSqlCursor): Boolean {
  var util: FLUtil = new FLUtil;

  var hayTroquelado: Boolean = cursor.valueBuffer("troquelado");
  if (!hayTroquelado)
  {
    return true;
  }
  var nodoTroquelado: FLDomNode = this.iface.crearNodoHijo(nodoParam, "TroqueladoParam");
  var xmlElemento: FLDomElement = nodoTroquelado.toElement();

  var trabajosTroquel: Number = parseInt(cursor.valueBuffer("trabajostroquel"));
  xmlElemento.setAttribute("TrabajosTroquel", trabajosTroquel);

  var simetria: Boolean = cursor.valueBuffer("simetriatroquel");
  if (simetria)
  {
    xmlElemento.setAttribute("Simetria", "true");
  } else {
    xmlElemento.setAttribute("Simetria", "false");
  }

  var refTroquel: String = cursor.valueBuffer("reftroquel");
  xmlElemento.setAttribute("RefTroquel", refTroquel);

  if (cursor.isNull("tpreptroquel"))
  {
    xmlElemento.setAttribute("TiempoPrepTroquel", "NULL");
  } else {
    var tPrepTroquel: Number = cursor.valueBuffer("tpreptroquel");
    xmlElemento.setAttribute("TiempoPrepTroquel", tPrepTroquel);
  }

  var costeTroquel: Number = cursor.valueBuffer("costetroquel");
  xmlElemento.setAttribute("CosteTroquel", costeTroquel);

  var altoTroquel: Number = cursor.valueBuffer("altotroquel");
  xmlElemento.setAttribute("AltoTroquel", altoTroquel);

  var anchoTroquel: Number = cursor.valueBuffer("anchotroquel");
  xmlElemento.setAttribute("AnchoTroquel", anchoTroquel);

  var conCosteTroquel: String;
  if (cursor.valueBuffer("concostetroquel"))
  {
    conCosteTroquel = "true";
  } else {
    conCosteTroquel = "false";
  }
  xmlElemento.setAttribute("ConCosteTroquel", conCosteTroquel);

  var hayPelado: Boolean = cursor.valueBuffer("pelado");
  if (!hayPelado)
  {
    return true;
  }
  var nodoPelado: FLDomNode = this.iface.crearNodoHijo(nodoParam, "PeladoParam");
  xmlElemento = nodoPelado.toElement();

  if (cursor.isNull("unihorapelado"))
  {
    xmlElemento.setAttribute("UniHoraPelado", "NULL");
  } else {
    var uniHoraPelado: Number = parseInt(cursor.valueBuffer("unihorapelado"));
    xmlElemento.setAttribute("UniHoraPelado", uniHoraPelado);
  }

  return true;
}

function oficial_guardarDatosLibro(nodoParam: FLDomNode, cursor: FLSqlCursor): Boolean {
  var util: FLUtil = new FLUtil;

  if (cursor.isNull("distpaginastrabajo"))
  {
    return true;
  }

  var nodoDatosLibro: FLDomNode = this.iface.crearNodoHijo(nodoParam, "DatosLibroParam");
  var xmlElemento: FLDomElement = nodoDatosLibro.toElement();

  var distPaginasTrabajo: String = cursor.valueBuffer("distpaginastrabajo");
  xmlElemento.setAttribute("DistPaginasTrabajo", distPaginasTrabajo);

  return true;
}

function oficial_guardarOtros(nodoParam: FLDomNode, cursor: FLSqlCursor): Boolean {
  var util: FLUtil = new FLUtil;

  var nodoOtros: FLDomNode = nodoParam.namedItem("FondosLisosParam");
  if (!nodoOtros)
  {
    nodoOtros = this.iface.crearNodoHijo(nodoParam, "FondosLisosParam");
    if (!nodoOtros)
      return false;
  }
  var fondosLisos: Boolean = cursor.valueBuffer("fondoslisos");
  if (fondosLisos)
  {
    nodoOtros.toElement().setAttribute("Valor", "true");
  } else {
    nodoOtros.toElement().setAttribute("Valor", "false");
  }

  var nodoOtros: FLDomNode = nodoParam.namedItem("NumeracionParam");
  if (!nodoOtros)
  {
    nodoOtros = this.iface.crearNodoHijo(nodoParam, "NumeracionParam");
    if (!nodoOtros)
      return false;
  }
  var numeracion: Boolean = cursor.valueBuffer("numeracion");
  if (numeracion)
  {
    nodoOtros.toElement().setAttribute("Valor", "true");
  } else {
    nodoOtros.toElement().setAttribute("Valor", "false");
  }

  var nodoOtros: FLDomNode = nodoParam.namedItem("CalidadEspecialParam");
  if (!nodoOtros)
  {
    nodoOtros = this.iface.crearNodoHijo(nodoParam, "CalidadEspecialParam");
    if (!nodoOtros)
      return false;
  }
  var calidadEspecial: Boolean = cursor.valueBuffer("calidadespecial");
  if (calidadEspecial)
  {
    nodoOtros.toElement().setAttribute("Valor", "true");
  } else {
    nodoOtros.toElement().setAttribute("Valor", "false");
  }

  var referencia: String = util.sqlSelect("productoslp", "referencia", "idproducto = " + cursor.valueBuffer("idproducto"));
  var nombrePagina: String;
  switch (referencia)
  {
    case "IPTICO":
    case "TAPA_LIBRO": {
      if (cursor.valueBuffer("numpaginas") > 26) {
        nombrePagina = "Numero";
      } else {
        nombrePagina = "Letra";
      }
      break;
    }
    case "PAGINAS_LIBRO": {
      nombrePagina = "Numero";
      break;
    }
  }
  var nodoOtros: FLDomNode = nodoParam.namedItem("NombrePaginaParam");
  if (!nodoOtros)
  {
    nodoOtros = this.iface.crearNodoHijo(nodoParam, "NombrePaginaParam");
    if (!nodoOtros)
      return false;
  }
  nodoOtros.toElement().setAttribute("Valor", nombrePagina);

  return true;
}

/** \C Establece algunos valores  visibles del formulario según sea el producto al que pertenece el íptico
\end */
function oficial_initControles()
{
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();
  var referencia: String = util.sqlSelect("lineaspresupuestoscli", "referencia", "idlinea = " + cursor.valueBuffer("idlinea"));

  switch (referencia) {
    case "IPTICO": {
      try {
        this.child("fdbNumPaginas").setFieldAlias(util.translate("scripts", "Modelos"));
      } catch (e) {}
      break;
    }
    case "LIBRO": {
      try {
        this.child("fdbNumPaginas").setFieldAlias(util.translate("scripts", "Páginas"));
      } catch (e) {}
      break;
    }
  }
}

function oficial_guardarPlastificado(nodoParam: FLDomNode, cursor: FLSqlCursor): Boolean {
  var util: FLUtil = new FLUtil;

  var codPlas: String = "";
  var plasFrente: String = cursor.valueBuffer("plasfrente");
  switch (plasFrente)
  {
    case "Brillo": {
      codPlas += "B";
      break;
    }
    case "Mate": {
      codPlas += "M";
      break;
    }
    default: {
      codPlas += "N";
    }
  }
  var plasVuelta: String = cursor.valueBuffer("plasvuelta");
  switch (plasVuelta)
  {
    case "Brillo": {
      codPlas += "B";
      break;
    }
    case "Mate": {
      codPlas += "M";
      break;
    }
    default: {
      codPlas += "N";
    }
  }

  var xmlPlas: FLDomNode = this.iface.crearNodoHijo(nodoParam, "PlastificadoParam");
  xmlPlas.toElement().setAttribute("Valor", codPlas);

  return true;
}

function oficial_guardarTareasSaltadas(nodoParam: FLDomNode, cursor: FLSqlCursor): Boolean {
  var util: FLUtil = new FLUtil;
  var eParam: FLDomElement = nodoParam.toElement();
  if (cursor.valueBuffer("saltarimpresion"))
  {
    eParam.setAttribute("SaltarImpresion", "true");
  }
  if (cursor.valueBuffer("saltarplanchas"))
  {
    eParam.setAttribute("SaltarPlanchas", "true");
  }
  return true;
}

function oficial_guardarDiseno(nodoParam: FLDomNode, cursor: FLSqlCursor): Boolean {
  var util: FLUtil = new FLUtil;

  var nodoDiseno: FLDomNode = this.iface.crearNodoHijo(nodoParam, "DisenoParam");
  var xmlElemento: FLDomElement = nodoDiseno.toElement();

  var diseno: Boolean = cursor.valueBuffer("diseno");
  if (diseno)
  {
    xmlElemento.setAttribute("Valor", "true");
  } else {
    xmlElemento.setAttribute("Valor", "false");
  }
  if (cursor.isNull("tiempodiseno"))
  {
    xmlElemento.setAttribute("TiempoUsuario", "");
  } else {
    xmlElemento.setAttribute("TiempoUsuario", cursor.valueBuffer("tiempodiseno"));
  }

  return true;
}

function oficial_guardarPlegado(nodoParam: FLDomNode, cursor: FLSqlCursor): Boolean {
  var util: FLUtil = new FLUtil;

  var codTipoPlegado: String = cursor.valueBuffer("codtipoplegado");

  var horizontales: Number = cursor.valueBuffer("pliegueshor");
  if (isNaN(horizontales))
  {
    horizontales = 0;
  }
  var verticales: Number = cursor.valueBuffer("plieguesver");
  if (isNaN(verticales))
  {
    verticales = 0;
  }

  if (horizontales == 0 && verticales == 0)
  {
    return true;
  }

  var alto: String = cursor.valueBuffer("altodob");
  alto = util.roundFieldValue(alto, "paramiptico", "altodob");
  var ancho: String = cursor.valueBuffer("anchodob");
  ancho = util.roundFieldValue(ancho, "paramiptico", "anchodob");

  var nodoPlegado: FLDomNode = this.iface.crearNodoHijo(nodoParam, "PlegadoParam");
  var xmlElemento: FLDomElement = nodoPlegado.toElement();

  xmlElemento.setAttribute("Horizontales", horizontales);
  xmlElemento.setAttribute("Verticales", verticales);
  xmlElemento.setAttribute("AreaPlegado", ancho + "x" + alto);
  xmlElemento.setAttribute("TipoPlegado", codTipoPlegado);

  return true;
}

function oficial_guardarSangrias(nodoParam: FLDomNode, cursor: FLSqlCursor): Boolean {
  var xmlSangrias: FLDomNode = this.iface.crearNodoHijo(nodoParam, "SangriaParam");
  var xmlElemento: FLDomElement = xmlSangrias.toElement();

  var sangria: Number = cursor.valueBuffer("sangriasup");
  xmlElemento.setAttribute("Arriba", sangria);

  var sangria: Number = cursor.valueBuffer("sangriainf");
  xmlElemento.setAttribute("Abajo", sangria);

  var sangria: Number = cursor.valueBuffer("sangriader");
  xmlElemento.setAttribute("Derecha", sangria);

  var sangria: Number = cursor.valueBuffer("sangriaizq");
  xmlElemento.setAttribute("Izquierda", sangria);

  return true;
}

function oficial_guardarColor(nodoParam: FLDomNode, cursor: FLSqlCursor): Boolean {
  var util: FLUtil = new FLUtil;

  var xmlDocColores: FLDomDocument = new FLDomDocument;
  var contenidoColor: String = util.sqlSelect("paramcolor", "xml", "idparamiptico = " + cursor.valueBuffer("id"));
  if (!contenidoColor)
  {
    MessageBox.warning(util.translate("scripts", "Error al guardar los datos de color: No existe el registro de parámetros de color"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }

  if (!xmlDocColores.setContent(contenidoColor))
  {
    MessageBox.warning(util.translate("scripts", "Error al guardar los datos de color: Error al establecer los datos XML"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  nodoParam.appendChild(xmlDocColores.firstChild().cloneNode());

  return true;
}

function oficial_guardarCantidad(nodoParam: FLDomNode, cursor: FLSqlCursor): Boolean {
  var util: FLUtil = new FLUtil;


  if (this.child("chkCantidadesPorModelo") && !this.child("chkCantidadesPorModelo").checked)
  {
    /// Permite poder cambiar cantidad y modelos desde el formulario de íptico.
    if (!this.iface.crearRegistroCantidades(cursor)) {
      return false;
    }
  }

  var xmlDocCantidad: FLDomDocument = new FLDomDocument;
  var contenidoCantidad: String = util.sqlSelect("paramcantidad", "xml", "idparamiptico = " + cursor.valueBuffer("id"));
  if (!contenidoCantidad)
  {
    if (!this.iface.crearRegistroCantidades(cursor)) {
      return false;
    }
    contenidoCantidad = util.sqlSelect("paramcantidad", "xml", "idparamiptico = " + cursor.valueBuffer("id"));
  }

  if (!xmlDocCantidad.setContent(contenidoCantidad))
  {
    MessageBox.warning(util.translate("scripts", "Error al guardar los datos de cantidad: Error al establecer los datos XML"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  nodoParam.appendChild(xmlDocCantidad.firstChild().cloneNode());

  return true;
}

function oficial_guardarPliego(nodoParam: FLDomNode, cursor: FLSqlCursor): Boolean {
  var util: FLUtil = new FLUtil;
  var refPliego: String = cursor.valueBuffer("refpliego");
  if (!refPliego || refPliego == "")
  {
    return true;
  }

  var nodoPliego: FLDomNode = this.iface.crearNodoHijo(nodoParam, "PliegoParam");
  var xmlElemento: FLDomElement = nodoPliego.toElement();

  xmlElemento.setAttribute("Ref", refPliego);
  xmlElemento.setAttribute("Formato", util.sqlSelect("articulos", "codformato", "referencia = '" + refPliego + "'"));

  var dimPliego: String = cursor.valueBuffer("anchop") + "x" + cursor.valueBuffer("altop");
  xmlElemento.setAttribute("AreaPliego", dimPliego);

  return true;
}

function oficial_guardarPliegoImpresion(nodoParam: FLDomNode, cursor: FLSqlCursor): Boolean {
  if (!this.iface.xmlPrecorteActual_)
  {
    return true;
  }

  var precorte: Number = cursor.valueBuffer("precorte");
  if (!precorte || precorte == "")
  {
    return true;
  }
  var xmlParamNode: FLDomNode = this.iface.crearNodoHijo(nodoParam, "PliegoImpresionParam");
  var xmlElemento: FLDomElement = xmlParamNode.toElement();

  xmlElemento.setAttribute("Corte", precorte);

  var dimPrecorte: Array = precorte.split("x");
  var factor: Number = parseInt(dimPrecorte[0]) * parseInt(dimPrecorte[1]);
  xmlElemento.setAttribute("Factor", factor);

  var dimPI: String = cursor.valueBuffer("anchopi") + "x" + cursor.valueBuffer("altopi");
  xmlElemento.setAttribute("Valor", dimPI);

  return true;
}

function oficial_guardarTrabajosPliego(nodoParam: FLDomNode, cursor: FLSqlCursor): Boolean {
  if (!this.iface.xmlTPOActual_ && !this.iface.xmlTPMSActual_)
  {
    return true;
  }
  if (this.iface.xmlTPOActual_)
  {
    nodoParam.appendChild(this.iface.xmlTPOActual_.cloneNode());
  } else if (this.iface.xmlTPMSActual_)
  {
    nodoParam.appendChild(this.iface.xmlTPMSActual_.cloneNode());
  }

  return true;
}

function oficial_crearNodoHijo(nodoPadre: FLDomNode, nombreHijo: String): FLDomNode {
  var xmlDocAux: FLDomDocument = new FLDomDocument;
  xmlDocAux.setContent("<" + nombreHijo + "/>");
  var xmlNodo: FLDomNode = xmlDocAux.firstChild();
  nodoPadre.appendChild(xmlNodo);
  return xmlNodo;
}

function oficial_validarDatos(xmlProceso: FLDomNode): Boolean {
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  if (!this.iface.validarPlegado(xmlProceso))
  {
    return false;
  }

  if (this.iface.xmlTPMSActual_ && this.iface.xmlTPOActual_)
  {
    MessageBox.warning(util.translate("scripts", "No puede establecer dos distribuciones de trabajos en pliego.\nBorre una de ellas"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }

  var codImpresora: String = cursor.valueBuffer("idimpresora");
  debug("codImpresora = " + codImpresora);
  if (!codImpresora || codImpresora == "")
  {
    var datosImp: String = this.iface.datosImpresoraGral();
    if (!datosImp) {
      return false;
    }
    var areaPI: String = cursor.valueBuffer("anchopi") + "x" + cursor.valueBuffer("altopi");
    if (areaPI != "0x0") {
      if (!flfacturac.iface.pub_entraEnArea(datosImp["min"], areaPI)) {
        MessageBox.warning(util.translate("scripts", "El área del pliego de impresión (%1) es inferior al área mínima total (%2).").arg(areaPI).arg(datosImp["min"]), MessageBox.Ok, MessageBox.NoButton);
        return false;
      }
      if (!flfacturac.iface.pub_entraEnArea(areaPI, datosImp["max"])) {
        MessageBox.warning(util.translate("scripts", "El área del pliego de impresión (%1) es superior al área máxima total (%2).").arg(areaPI).arg(datosImp["max"]), MessageBox.Ok, MessageBox.NoButton);
        return false;
      }
    }
  } else {
    var xmlImpresora: FLDomNode = flfacturac.iface.pub_dameParamCentroCoste(codImpresora);
    var msgError: String = flfacturac.iface.pub_validarImpresora(xmlProceso, xmlImpresora);
    debug("msgError = " + msgError);
    if (!msgError)
    {
      return false;
    }
    if (msgError != "OK")
    {
      MessageBox.warning(msgError, MessageBox.Ok, MessageBox.NoButton);
      return false;
    }
  }

  if (cursor.valueBuffer("estiloimpresion") == "TiraRetira")
  {
    if (!flfacturac.iface.pub_tiraRetiraPosible(xmlProceso)) {
      MessageBox.warning(util.translate("scripts", "La configuración de colores no permite el estilo TiraRetira."), MessageBox.Ok, MessageBox.NoButton);
      return false;
    }
  }

  if (!flfacturac.iface.pub_validarPinzas(xmlProceso))
  {
    MessageBox.warning(util.translate("scripts", "La distribución escogida no encaja en el pliego de impresión para la impresora y estilo de impresión escogidos"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }

  return true;
}

function oficial_datosImpresoraGral(): Array {
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();
  var datos: Array = [];
  var texto: String = "";

  //  var idImpresora:String = cursor.valueBuffer("idimpresora");
  //  if (!util.sqlSelect("pr_tiposcentrocoste", "codtipocentro", "codtipocentro = '" + idImpresora + "'")) {
  datos["nombre"] = util.translate("scripts", "(impresora sin definir)");
  datos["min"] = flfacturac.iface.minPliegoImpresion_; //"\n" + util.translate("scripts", "Area min: %1").arg(flfacturac.iface.minPliegoImpresion_);
  datos["max"] = flfacturac.iface.maxPliegoImpresion_;
  //  } else {
  //    var xmlParamImpresora:FLDomNode = flfacturac.iface.pub_dameParamCentroCoste(idImpresora);
  //    if (!xmlParamImpresora)
  //      return false;
  //    var eImpresora:FLDomElement = xmlParamImpresora.toElement();
  //    datos["nombre"] = idImpresora;
  //    datos["min"] = eImpresora.attribute("AnchoMin") + "x" + eImpresora.attribute("AltoMin");
  //    datos["max"] = eImpresora.attribute("AnchoMax") + "x" + eImpresora.attribute("AltoMax");
  //  }
  return datos;
}

function oficial_tbnColores_clicked()
{
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  if (cursor.modeAccess() == cursor.Insert) {
    if (!cursor.commitBuffer()) {
      return false;
    }
    cursor.refresh();
    cursor.setModeAccess(cursor.Edit);
    cursor.refreshBuffer();
  }
  debug(1);
  if (this.iface.curColores_) {
    delete this.iface.curColores_;
  }
  debug(1.1);
  this.iface.curColores_ = new FLSqlCursor("paramcolor");
  debug(2);
  connect(this.iface.curColores_, "bufferCommited()", this, "iface.habilitarBotonColor");
  debug(3);
  this.iface.curColores_.select("idparamiptico = " + cursor.valueBuffer("id"));
  debug(4);
  if (!this.iface.curColores_.first()) {
    debug(5);
    this.iface.curColores_.insertRecord();
  } else {
    debug(6);
    this.iface.curColores_.editRecord();
  }
}

function oficial_tbnCantidades_clicked()
{
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  if (cursor.modeAccess() == cursor.Insert) {
    if (!cursor.commitBuffer()) {
      return false;
    }
    cursor.refresh();
    cursor.setModeAccess(cursor.Edit);
    cursor.refreshBuffer();
  }
  debug("Id param = " + cursor.valueBuffer("id"));

  if (!this.child("chkCantidadesPorModelo").checked) {
    if (!this.iface.crearRegistroCantidades(cursor)) {
      return false;
    }
  }

  this.iface.curCantidades_.select("idparamiptico = " + cursor.valueBuffer("id"));
  if (!this.iface.curCantidades_.first()) {
    if (!this.iface.crearRegistroCantidades(cursor)) {
      return false;
    }
    this.iface.curCantidades_.select("idparamiptico = " + cursor.valueBuffer("id"));
    if (!this.iface.curCantidades_.first()) {
      return false;
    }
  }

  this.iface.curCantidades_.editRecord();
}

function oficial_crearRegistroCantidades(cursor: FLSqlCursor): Boolean {
  debug("oficial_crearRegistroCantidades");
  var util: FLUtil = new FLUtil;

  if (!util.sqlDelete("paramcantidad", "idparamiptico = " + cursor.valueBuffer("id")))
  {
    return false;
  }
  var curCantidades: FLSqlCursor = new FLSqlCursor("paramcantidad");
  curCantidades.setModeAccess(curCantidades.Insert);
  curCantidades.refreshBuffer();
  curCantidades.setValueBuffer("idparamiptico", cursor.valueBuffer("id"));
  curCantidades.setValueBuffer("numcopias", cursor.valueBuffer("numcopias"));
  curCantidades.setValueBuffer("cantidadespormodelo", false);
  curCantidades.setValueBuffer("numpaginas", cursor.valueBuffer("numpaginas"));
  curCantidades.setValueBuffer("total", formRecordparamcantidad.iface.pub_commonCalculateField("total", curCantidades));
  curCantidades.setValueBuffer("xml", formRecordparamcantidad.iface.pub_xmlCantidades(curCantidades));
  if (!curCantidades.commitBuffer())
  {
    return false;
  }
  return true;
}

function oficial_habilitarPorReferencia()
{
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  var referencia: String = util.sqlSelect("productoslp", "referencia", "idproducto = " + cursor.valueBuffer("idproducto"));
  //  formRecordlineaspresupuestoscli.cursor().valueBuffer("referencia");
  var idLinea: String = formRecordlineaspresupuestoscli.cursor().valueBuffer("idlinea");
  switch (referencia) {
    case "IPTICO": {
      break;
    }
    case "PAGINAS_LIBRO": {
      this.child("fdbNumCopias").setDisabled(true);
      this.child("fdbNumPaginas").setDisabled(true);
      this.child("tbnCantidades").enabled = false;
      this.child("fdbAltoT").setDisabled(true);
      this.child("fdbAnchoT").setDisabled(true);
      this.child("fdbGramaje").setDisabled(true);
      this.child("fdbCodMarcaPapel").setDisabled(true);
      break;
    }
    case "TAPA_LIBRO": {
      this.child("fdbNumCopias").setDisabled(true);
      this.child("fdbNumPaginas").setDisabled(true);
      this.child("tbnCantidades").enabled = false;
      this.child("fdbAltoT").setDisabled(true);
      this.child("fdbAnchoT").setDisabled(true);
      break;
    }
  }
}

function oficial_dameArrayDimensiones(area: String): Array {
  if (!area || area == "" || area.toString().find("x") < 0)
  {
    return false;
  }
  var a: Array = area.split("x");
  if (!a || a.length != 2)
  {
    return false;
  }
  var dim: Array = [];
  dim["x"] = a[0];
  dim["y"] = a[1];

  return dim;
}

function oficial_comprobarRegistroEnvio(): Boolean {
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  var referencia: String = util.sqlSelect("lineaspresupuestoscli", "referencia", "idlinea = " + cursor.valueBuffer("idlinea"));
  if (referencia != "IPTICO")
  {
    return true;
  }

  if (cursor.valueBuffer("ignorarenvio"))
  {
    if (!util.sqlDelete("paramenvio", "idparamiptico = " + cursor.valueBuffer("id"))) {
      return false;
    }
  } else {
    if (util.sqlSelect("paramenvio", "id", "idparamiptico = " + cursor.valueBuffer("id")))
    {
      var cantidad: Number = cursor.valueBuffer("numcopias");
      if (!cantidad) {
        cantidad = parseInt(util.sqlSelect("paramcantidad", "total", "idparamiptico = " + cursor.valueBuffer("id")));
      }
      var cantidadEnvio: Number = parseInt(util.sqlSelect("paramenvio", "numcopias", "idparamiptico = " + cursor.valueBuffer("id")));
      debug("cantidad = " + cantidad);
      debug("cantidadEnvio = " + cantidadEnvio);
      if (cantidadEnvio != cantidad) {
        var res: Number = MessageBox.warning(util.translate("scripts", "La cantidad indicada no coincide con la cantidad el envío.\n¿Desea recalcular el registro de envío?"), MessageBox.Yes, MessageBox.No);
        if (res == MessageBox.Yes) {
          if (!this.iface.crearRegistroEnvio(cursor, true)) {
            return false;
          }
        }
      }
    } else {
      if (!this.iface.crearRegistroEnvio(cursor, true))
      {
        return false;
      }
    }
  }
  return true;
}

function oficial_crearRegistroEnvio(cursor: FLSqlCursor, desdeForm: Boolean): Boolean {
  var util: FLUtil = new FLUtil;

  var curEnvio: FLSqlCursor;
  if (desdeForm)
  {
    /// Desparcheado porque si no no se calculan bien los datos del envío en base a los del cursor el íptico
    curEnvio = this.child("tdbParamEnvio").cursor();
  } else {
    curEnvio = new FLSqlCursor("paramenvio");
  }

  if (!util.sqlDelete("paramenvio", "idparamiptico = " + cursor.valueBuffer("id")))
  {
    return false;
  }

  var datosPresupuesto: FLSqlQuery = new FLSqlQuery;
  datosPresupuesto.setTablesList("presupuestoscli,lineaspresupuestoscli");
  datosPresupuesto.setSelect("p.codcliente, p.nombrecliente, p.idpoblacion, p.idprovincia, p.codpais, p.coddir, p.direccion, p.codpostal, p.provincia, p.apartado, p.ciudad");
  datosPresupuesto.setFrom("lineaspresupuestoscli lp INNER JOIN presupuestoscli p ON lp.idpresupuesto = p.idpresupuesto");
  datosPresupuesto.setWhere("lp.idlinea = " + cursor.valueBuffer("idlinea"));
  datosPresupuesto.setForwardOnly(true);
  if (!datosPresupuesto.exec())
  {
    return false;
  }
  if (!datosPresupuesto.first())
  {
    return false;
  }

  var idProvincia: String;
  var idPoblacion: String;

  curEnvio.setModeAccess(curEnvio.Insert);
  curEnvio.refreshBuffer();
  curEnvio.setValueBuffer("idparamiptico", cursor.valueBuffer("id"));
  curEnvio.setValueBuffer("codcliente", datosPresupuesto.value("p.codcliente"));
  curEnvio.setValueBuffer("nombredestino", datosPresupuesto.value("p.nombrecliente"));
  curEnvio.setValueBuffer("direccion", datosPresupuesto.value("p.direccion"));
  curEnvio.setValueBuffer("codpostal", datosPresupuesto.value("p.codpostal"));
  idPoblacion = datosPresupuesto.value("p.idpoblacion");
  if (idPoblacion == "")
  {
    curEnvio.setNull("idpoblacion");
  } else {
    curEnvio.setValueBuffer("idpoblacion", idPoblacion);
  }
  curEnvio.setValueBuffer("ciudad", datosPresupuesto.value("p.ciudad"));
  idProvincia = datosPresupuesto.value("p.idprovincia");
  if (idProvincia == "")
  {
    curEnvio.setNull("idprovincia");
  } else {
    curEnvio.setValueBuffer("idprovincia", idProvincia);
  }
  curEnvio.setValueBuffer("provincia", datosPresupuesto.value("p.provincia"));
  curEnvio.setValueBuffer("apartado", datosPresupuesto.value("p.apartado"));

  var cantidad: Number = cursor.valueBuffer("numcopias");
  if (!cantidad)
  {
    cantidad = parseInt(util.sqlSelect("paramcantidad", "total", "idparamiptico = " + cursor.valueBuffer("id")));
  }
  curEnvio.setValueBuffer("numcopias", cantidad);

  curEnvio.setValueBuffer("pesounidad", formRecordparamenvio.iface.pub_commonCalculateField("pesounidad", curEnvio));
  curEnvio.setValueBuffer("peso", formRecordparamenvio.iface.pub_commonCalculateField("peso", curEnvio));
  curEnvio.setValueBuffer("portes", formRecordparamenvio.iface.pub_commonCalculateField("portes", curEnvio));
  curEnvio.setValueBuffer("codagencia", formRecordparamenvio.iface.pub_commonCalculateField("codagencia", curEnvio));

  var xmlDatos: FLDomDocument = formRecordparamenvio.iface.pub_guardarDatos(curEnvio);
  if (!xmlDatos)
  {
    return false;
  }
  curEnvio.setValueBuffer("xml", xmlDatos.toString(4));

  if (!curEnvio.commitBuffer())
  {
    return false;
  }

  return true;
}

function oficial_habilitarEnvio()
{
  debug("oficial_habilitarEnvio");
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();
  var referencia: String = util.sqlSelect("lineaspresupuestoscli", "referencia", "idlinea = " + cursor.valueBuffer("idlinea"));
  debug("referencia = " + referencia);
  switch (referencia) {
    case "IPTICO": {
      this.child("tbwIptico1").setTabEnabled("envio", true);
      if (cursor.valueBuffer("ignorarenvio")) {
        this.child("gbxEnvio").enabled = false;
      } else {
        this.child("gbxEnvio").enabled = true;
      }
      break;
    }
    default: {
      this.child("tbwIptico1").setTabEnabled("envio", false);
      break;
    }
  }
}

function oficial_validarPlegado(xmlProceso: FLDomNode): Boolean {
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();
  debug("Validando plegado");
  var nodoPlegado: FLDomNode = flfacturac.iface.pub_dameNodoXML(xmlProceso, "PlegadoParam");
  if (nodoPlegado)
  {
    var nodoTroquelado: FLDomNode = flfacturac.iface.pub_dameNodoXML(xmlProceso, "TroqueladoParam");
    if (!nodoTroquelado) {
      var gramaje: Number = parseInt(flfacturac.iface.pub_dameAtributoXML(xmlProceso, "GramajeParam@Valor"));
      if (gramaje > 170) {
        var res: Number = MessageBox.warning(util.translate("scripts", "Ha seleccionado un trabajo plegado de más de 170 gramos, pero no ha establecido los datos de hendido (troquelado).\n¿Desea continuar?"), MessageBox.Yes, MessageBox.No);
        if (res != MessageBox.Yes) {
          return false;
        }
      }
    }
  }
  return true;
}

/** \D Cuando se trata de sobres se calcula automáticamente las sangrías y las dimensiones del trabajo
\end */
function oficial_informarDatosSobre()
{
  debug(oficial_informarDatosSobre);
  var cursor: FLSqlCursor = this.cursor();
  var refSobre: String = cursor.valueBuffer("refpliego");

  var qrySobre: FLSqlQuery = new FLSqlQuery;
  qrySobre.setTablesList("articulos");
  qrySobre.setSelect("anchopliego, altopliego");
  qrySobre.setFrom("articulos");
  qrySobre.setWhere("referencia = '" + refSobre + "'");
  qrySobre.setForwardOnly(true);
  if (!qrySobre.exec()) {
    return false;
  }
  if (qrySobre.first()) {
    this.child("fdbAnchoT").setValue(qrySobre.value("anchopliego"));
    this.child("fdbAltoT").setValue(qrySobre.value("altopliego"));
    this.child("chkSangriasInd").checked = false;
    this.child("fdbSangriaSup").setValue(0);
    this.child("tbnPrecorte").animateClick();
    this.child("tbnTPO").animateClick();
  }
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////