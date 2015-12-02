/***************************************************************************
                 pr_paramimpresora.qs  -  description
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
  //  var COL_ESTILO:Number;
  //  var COL_ARRANQUE:Number;
  //  var COL_PORCOPIA:Number;
  //  var COL_FIN:Number;
  //  var COL_PINZA:Number;
  //  var tblEstilos:Object;

  function oficial(context)
  {
    interna(context);
  }
  function cargarDatos()
  {
    return this.ctx.oficial_cargarDatos();
  }
  function bufferChanged(fN: String)
  {
    return this.ctx.oficial_bufferChanged(fN);
  }
  function guardarDatos(): Boolean {
    return this.ctx.oficial_guardarDatos();
  }
  function tbnOk_clicked()
  {
    return this.ctx.oficial_tbnOk_clicked();
  }
  function validarDatos(): Boolean {
    return this.ctx.oficial_validarDatos();
  }
  //  function configurarTabla() {
  //    return this.ctx.oficial_configurarTabla();
  //  }
  //  function crearEstilo(estilo:String) {
  //    return this.ctx.oficial_crearEstilo(estilo);
  //  }
  //  function tbnInsertEstilo_clicked() {
  //    return this.ctx.oficial_tbnInsertEstilo_clicked();
  //  }
  //  function tbnDeleteEstilo_clicked() {
  //    return this.ctx.oficial_tbnDeleteEstilo_clicked();
  //  }
  //  function existeEstilo(estilo:String):Boolean {
  //    return this.ctx.oficial_existeEstilo(estilo);
  //  }
  //  function elegirOpcion(opciones:Array):Number {
  //    return this.ctx.oficial_elegirOpcion(opciones);
  //  }
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

  var cursor: FLSqlCursor = this.cursor();

  //this.iface.tblEstilos = this.child("tblEstilos");

  //this.iface.configurarTabla();


  connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");
  //  connect(this.child("tbnOk"), "clicked()", this, "iface.tbnOk_clicked");
  //this.child("pushButtonAccept").enabled = false;

  this.child("fdbRefPlancha").setFilter("codfamilia = 'PLAN'");
  debug("Modo = " + cursor.modeAccess());
  switch (cursor.modeAccess()) {
    case cursor.Insert: {
      debug("Insert");
      cursor.setValueBuffer("codtipocentro", formRecordpr_tiposcentrocoste.cursor().valueBuffer("codtipocentro"));
      cursor.setValueBuffer("idusuario", "yo");
      break;
    }
    case cursor.Browse: {
      debug("Browse");
      //      this.iface.cargarDatos();
      break;
    }
  }
}

function interna_validateForm(): Boolean {
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  //  var xmlDocParam:FLDomDocument = this.iface.guardarDatos();
  //  if (!xmlDocParam) {
  //    MessageBox.warning(util.translate("scripts", "Error al guardar los parámetros a formato xml"), MessageBox.Ok, MessageBox.NoButton);
  //    return false;
  //  }
  //  cursor.setValueBuffer("xml", xmlDocParam.toString());
  cursor.setValueBuffer("xml", "");

  return true;
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_cargarDatos()
{
  var cursor: FLSqlCursor = this.cursor();
  var contenido: String = cursor.valueBuffer("xml");
  debug("contenido = " + contenido);
  var xmlParam: FLDomDocument = new FLDomDocument;
  if (!xmlParam.setContent(contenido))
    return;
  debug("OK");
  var xmlAux: FLDomNode;
  var nodoParam: FLDomNode = xmlParam.firstChild();
  var eParam: FLDomElement = nodoParam.toElement();

  this.child("fdbNumCuerpos").setValue(eParam.attribute("NumCuerpos"));

  var tiraVolteo: Boolean = eParam.attribute("Volteo");
  this.child("fdbTiraVolteo").setValue(tiraVolteo);

  this.child("fdbRefPlancha").setValue(eParam.attribute("RefPlancha"));

  this.child("fdbAltoMax").setValue(eParam.attribute("AltoMax"));
  this.child("fdbAnchoMax").setValue(eParam.attribute("AnchoMax"));

  this.child("fdbAltoMin").setValue(eParam.attribute("AltoMin"));
  this.child("fdbAnchoMin").setValue(eParam.attribute("AnchoMin"));

  this.child("fdbColoresReg").setValue(eParam.attribute("ColoresReg") == "true");

  this.child("fdbFondosLisos").setValue(eParam.attribute("FondosLisos") == "true");

  this.child("fdbNumeracion").setValue(eParam.attribute("Numeracion") == "true");

  this.child("fdbCalidadEspecial").setValue(eParam.attribute("CalidadEspecial") == "true");

  this.child("fdbTiempoMinProd").setValue(eParam.attribute("TiempoMinProd"));

  //  this.child("fdbTiempoPlancha").setValue(eParam.attribute("TiempoPlancha"));
  //
  //  this.child("fdbMaculasPlancha").setValue(eParam.attribute("MaculasPlancha"));

  this.child("fdbAnchoPinza").setValue(eParam.attribute("AnchoPinza"));

  this.child("fdbRelAspectoMin").setValue(eParam.attribute("RelAspectoMin"));

}

// function oficial_crearEstilo(estilo:String)
// {
//  var valor:String;
//  if (estilo == "Defecto") {
//    valor = "0";
//  } else {
//    valor = "";
//  }
//  var numFilas:Number = this.iface.tblEstilos.numRows();
//  this.iface.tblEstilos.insertRows(numFilas);
//  this.iface.tblEstilos.setText(numFilas, this.iface.COL_ESTILO, estilo);
//  this.iface.tblEstilos.setText(numFilas, this.iface.COL_ARRANQUE, valor);
//  this.iface.tblEstilos.setText(numFilas, this.iface.COL_PORCOPIA, valor);
//  this.iface.tblEstilos.setText(numFilas, this.iface.COL_FIN, valor);
//  this.iface.tblEstilos.setText(numFilas, this.iface.COL_PINZA, valor);
// }

function oficial_bufferChanged(fN: String)
{
  var cursor: FLSqlCursor = this.cursor();
  switch (fN) {
    case "sangriasup": {
      break;
    }
  }
}


function oficial_guardarDatos(): FLDomDocument {
  debug("GD");
  //var util:FLUtil = new FLUtil;
  var util: FLUtil = new FLUtil;
  debug("GD1");
  var cursor: FLSqlCursor = this.cursor();
  debug("GD2");
  //var xmlParamOriginal:FLDomDocument = new FLDomDocument;
  var xmlParam: FLDomDocument = new FLDomDocument();
  debug("GD3");

  //  if (!xmlParamOriginal.setContent(cursor.valueBuffer("xml"))) {
  //    MessageBox.warning(util.translate("scripts", "Debe establecer el número de cuerpos"), MessageBox.Ok, MessageBox.NoButton);
  //    return false;
  //  }

  //xmlParam.appendChild(xmlParamOriginal.firstChild().cloneNode());
  debug("GD1");
  xmlParam.setContent("<TipoCentroCoste/>");
  debug("setcontent");
  var nodoParam: FLDomNode = xmlParam.firstChild();
  var eParam: FLDomNode = nodoParam.toElement();

  var numCuerpos: String = cursor.valueBuffer("numcuerpos");
  if (!numCuerpos || numCuerpos == "" || numCuerpos == 0)
  {
    MessageBox.warning(util.translate("scripts", "Debe establecer el número de cuerpos"), MessageBox.Ok, MessageBox.NoButton);
    return;
  }
  eParam.setAttribute("NumCuerpos", numCuerpos);

  var refPlancha: String = cursor.valueBuffer("refplancha");
  if (!refPlancha || refPlancha == "")
  {
    MessageBox.warning(util.translate("scripts", "Debe establecer la plancha asociada a la impresora"), MessageBox.Ok, MessageBox.NoButton);
    return;
  }
  eParam.setAttribute("RefPlancha", refPlancha);

  if (cursor.isNull("tiravolteo"))
  {
    eParam.setAttribute("Volteo", "");
  } else {
    eParam.setAttribute("Volteo", cursor.valueBuffer("tiravolteo"));
  }

  var altoMin: String = cursor.valueBuffer("altomin");
  if (isNaN(altoMin))
  {
    altoMin = 0;
  }
  altoMin = util.roundFieldValue(altoMin, "articulos", "altopliego");
  eParam.setAttribute("AltoMin", altoMin);

  var altoMax: String = cursor.valueBuffer("altomax");
  if (isNaN(altoMax))
  {
    altoMax = 0;
  }
  altoMax = util.roundFieldValue(altoMax, "articulos", "altopliego");
  eParam.setAttribute("AltoMax", altoMax);

  var anchoMin: String = cursor.valueBuffer("anchomin");
  if (isNaN(anchoMin))
  {
    anchoMin = 0;
  }
  anchoMin = util.roundFieldValue(anchoMin, "articulos", "anchopliego");
  eParam.setAttribute("AnchoMin", anchoMin);

  var anchoMax: String = cursor.valueBuffer("anchomax");
  if (isNaN(anchoMax))
  {
    anchoMax = 0;
  }
  anchoMax = util.roundFieldValue(anchoMax, "articulos", "anchopliego");
  eParam.setAttribute("AnchoMax", anchoMax);

  if (cursor.valueBuffer("coloresreg"))
  {
    eParam.setAttribute("ColoresReg", "true");
  } else {
    eParam.setAttribute("ColoresReg", "false");
  }

  if (cursor.valueBuffer("fondoslisos"))
  {
    eParam.setAttribute("FondosLisos", "true");
  } else {
    eParam.setAttribute("FondosLisos", "false");
  }

  if (cursor.valueBuffer("numeracion"))
  {
    eParam.setAttribute("Numeracion", "true");
  } else {
    eParam.setAttribute("Numeracion", "false");
  }

  if (cursor.valueBuffer("calidadespecial"))
  {
    eParam.setAttribute("CalidadEspecial", "true");
  } else {
    eParam.setAttribute("CalidadEspecial", "false");
  }

  var tiempoMinProd: String = cursor.valueBuffer("tiempominprod");
  if (isNaN(tiempoMinProd))
  {
    tiempoMinProd = 0;
  }
  tiempoMinProd = util.roundFieldValue(tiempoMinProd, "pr_paramimpresora", "tiempominprod");
  eParam.setAttribute("TiempoMinProd", tiempoMinProd);

  var tiempoPlancha: String = cursor.valueBuffer("tiempoplancha");
  if (isNaN(tiempoPlancha))
  {
    tiempoPlancha = 0;
  }
  tiempoPlancha = util.roundFieldValue(tiempoPlancha, "pr_paramimpresora", "tiempoplancha");
  eParam.setAttribute("TiempoPlancha", tiempoPlancha);

  var maculasPlancha: Number = parseInt(cursor.valueBuffer("maculasplancha"));
  if (isNaN(maculasPlancha))
  {
    maculasPlancha = 0;
  }
  eParam.setAttribute("MaculasPlancha", maculasPlancha);

  var anchoPinza: String = cursor.valueBuffer("anchopinza");
  if (isNaN(anchoPinza))
  {
    anchoPinza = 0;
  }
  anchoPinza = util.roundFieldValue(anchoPinza, "pr_paramimpresora", "anchopinza");
  eParam.setAttribute("AnchoPinza", anchoPinza);

  var relAspectoMin: String = cursor.valueBuffer("relaspectomin");
  if (isNaN(relAspectoMin))
  {
    relAspectoMin = 0;
  }
  relAspectoMin = util.roundFieldValue(relAspectoMin, "pr_paramimpresora", "relaspectomin");
  eParam.setAttribute("RelAspectoMin", relAspectoMin);

  return xmlParam;
}

function oficial_tbnOk_clicked()
{
  if (!this.iface.validarDatos())
    return false;

  var xmlDocParam: FLDomDocument = this.iface.guardarDatos();
  if (!xmlDocParam)
    return false;

  var cursor: FLSqlCursor = this.cursor();
  cursor.setValueBuffer("xml", xmlDocParam.toString());

  this.child("pushButtonAccept").enabled = true;
  this.child("pushButtonAccept").animateClick();
}

function oficial_validarDatos(): Boolean {
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  //  var numFilas:Number = this.iface.tblEstilos.numRows();
  //  var estilo:String;
  //  for (var i:Number = 0; i < numFilas; i++) {
  //    estilo = this.iface.tblEstilos.text(i, this.iface.COL_ESTILO);
  //    if (estilo != "Defecto" && estilo != "Simple" && estilo != "CaraRetira" && estilo != "TiraRetira" && estilo != "TiraVolteo") {
  //      MessageBox.warning(util.translate("scripts", "El estilo %1 no existe").arg(estilo), MessageBox.Ok, MessageBox.NoButton);
  //      return false;
  //    }
  //    if (estilo == "TiraVolteo" && !cursor.valueBuffer("tiravolteo")) {
  //      MessageBox.warning(util.translate("scripts", "La impresora no permite el estilo TiraVolteo"), MessageBox.Ok, MessageBox.NoButton);
  //      return false;
  //    }
  //  }
  return true;
}

/*function oficial_configurarTabla()
{
  this.iface.COL_ESTILO = 0;
  this.iface.COL_ARRANQUE = 1;
  this.iface.COL_PORCOPIA = 2;
  this.iface.COL_FIN = 3;
  this.iface.COL_PINZA = 4;

  this.iface.tblEstilos.setNumCols(5);
  this.iface.tblEstilos.setColumnWidth(this.iface.COL_ESTILO, 100);
  this.iface.tblEstilos.setColumnWidth(this.iface.COL_ARRANQUE, 100);
  this.iface.tblEstilos.setColumnWidth(this.iface.COL_PORCOPIA, 100);
  this.iface.tblEstilos.setColumnWidth(this.iface.COL_FIN, 100);
  this.iface.tblEstilos.setColumnWidth(this.iface.COL_PINZA, 100);
  this.iface.tblEstilos.setColumnLabels("/", "Estilo/T.Arranque (s)/T.Copia (s)/T.Fin (s)/Pinza (cm)");
}

function oficial_tbnInsertEstilo_clicked()
{
  var cursor:FLSqlCursor = this.cursor();
  var listaOpciones:String = "";

  if (!this.iface.existeEstilo("Simple")) {
    if (listaOpciones != "")
      listaOpciones += ",";
    listaOpciones += "Simple";
  }

  if (!this.iface.existeEstilo("CaraRetira")) {
    if (listaOpciones != "")
      listaOpciones += ",";
    listaOpciones += "CaraRetira";
  }

  if (!this.iface.existeEstilo("TiraRetira")) {
    if (listaOpciones != "")
      listaOpciones += ",";
    listaOpciones += "TiraRetira";
  }

  if (!this.iface.existeEstilo("TiraVolteo") && cursor.valueBuffer("TiraVolteo")) {
    if (listaOpciones != "")
      listaOpciones += ",";
    listaOpciones += "TiraVolteo";
  }

  var opciones:Array = listaOpciones.split(",");
  var opcion:Number = this.iface.elegirOpcion(opciones);
  if (opcion >= 0) {
    this.iface.crearEstilo(opciones[opcion]);
  }
}

function oficial_existeEstilo(estilo:String):Boolean
{
  var numFilas:Number = this.iface.tblEstilos.numRows();
  for (var i:Number = 0; i < numFilas; i++) {
    if (this.iface.tblEstilos.text(i, this.iface.COL_ESTILO) == estilo)
      return true;
  }
  return false;
}

/** \D
Da a elegir al usuario entre una serie de opciones
@param  opciones: Array con las n opciones a elegir
@return El índice de la opción elegida si se pulsa Aceptar
    -1 si se pulsa Cancelar
    -2 si hay error
\end
function oficial_elegirOpcion(opciones:Array):Number
{
  var util:FLUtil = new FLUtil();
  var dialog:Dialog = new Dialog;
  dialog.okButtonText = util.translate("scripts","Aceptar");
  dialog.cancelButtonText = util.translate("scripts","Cancelar");
  var bgroup:GroupBox = new GroupBox;
  dialog.add(bgroup);
  var rB:Array = [];
  for (var i:Number = 0; i < opciones.length; i++) {
    rB[i] = new RadioButton;
    bgroup.add(rB[i]);
    rB[i].text = opciones[i];
    if (i == 0)
      rB[i].checked = true;
    else
      rB[i].checked = false;
  }

  if (dialog.exec()) {
    for (var i:Number = 0; i < opciones.length; i++)
      if (rB[i].checked == true)
        return i;
  } else {
    return -1;
  }
}

function oficial_tbnDeleteEstilo_clicked()
{
  var util:FLUtil = new FLUtil;
  var iFila:Number = this.iface.tblEstilos.currentRow();
  if (iFila >= 0) {
    if (this.iface.tblEstilos.text(iFila, this.iface.COL_ESTILO) == "Defecto") {
      MessageBox.warning(util.translate("scripts", "No puede borrar el estilo Defecto"), MessageBox.Ok, MessageBox.NoButton);
      return;
    }
  }
  var res:Number = MessageBox.warning(util.translate("scripts", "¿Desea borrar el estilo seleccionado?"), MessageBox.Yes, MessageBox.No);
  if (res != MessageBox.Yes)
    return;

  this.iface.tblEstilos.removeRow(iFila);
}
*/
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////