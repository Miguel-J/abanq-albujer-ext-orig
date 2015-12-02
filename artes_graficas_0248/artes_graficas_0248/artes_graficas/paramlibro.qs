/***************************************************************************
                 paramlibro.qs  -  description
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
  var factorLomo: Number;
  function oficial(context)
  {
    interna(context);
  }
  function cargarDatos()
  {
    return this.ctx.oficial_cargarDatos();
  }
  function cargarAreaCerrado(eAreaCerrado: FLDomElement): Boolean {
    return this.ctx.oficial_cargarAreaCerrado(eAreaCerrado);
  }
  function cargarAreaAbierto(eAreaAbierto: FLDomElement): Boolean {
    return this.ctx.oficial_cargarAreaAbierto(eAreaAbierto);
  }
  function bufferChanged(fN: String)
  {
    return this.ctx.oficial_bufferChanged(fN);
  }
  function guardarDatos(cursor: FLSqlCursor): Boolean {
    return this.ctx.oficial_guardarDatos(cursor);
  }
  function guardarAreaCerrado(nodoParam: FLDomNode): Boolean {
    return this.ctx.oficial_guardarAreaCerrado(nodoParam);
  }
  function guardarAreaAbierto(nodoParam: FLDomNode): Boolean {
    return this.ctx.oficial_guardarAreaAbierto(nodoParam);
  }
  function crearNodoHijo(nodoPadre: FLDomNode, nombreHijo): FLDomNode {
    return this.ctx.oficial_crearNodoHijo(nodoPadre, nombreHijo);
  }
  function validarDatos(xmlProceso: FLDomNode): Boolean {
    return this.ctx.oficial_validarDatos(xmlProceso);
  }
  function calcularFL(): Number {
    return this.ctx.oficial_calcularFL();
  }
  function calcularPaginas()
  {
    return this.ctx.oficial_calcularPaginas();
  }
  function habilitarGrapado()
  {
    return this.ctx.oficial_habilitarGrapado();
  }
  function dameDatosGrapado(grapado: String): Array {
    return this.ctx.oficial_dameDatosGrapado(grapado);
  }
  function guardarGrupos(nodoParam: FLDomNode): Boolean {
    return this.ctx.oficial_guardarGrupos(nodoParam);
  }
  function guardarCombinacionesEnc(nodoParam: FLDomNode): Boolean {
    return this.ctx.oficial_guardarCombinacionesEnc(nodoParam);
  }
  function combinarSiguienteGrupo(eCombi: FLDomElement, nodoGrupo: FLDomNode): Boolean {
    return this.ctx.oficial_combinarSiguienteGrupo(eCombi, nodoGrupo);
  }
  function dameTotalPliegosFact(nodoFact: FLDomNode): Number {
    return this.ctx.oficial_dameTotalPliegosFact(nodoFact);
  }
  function damePliegosPlegado(nodoFact: FLDomNode, eCombi: FLDomElement): Boolean {
    return this.ctx.oficial_damePliegosPlegado(nodoFact, eCombi);
  }
  function guardarTrabajosExternos(nodoParam: FLDomNode): Boolean {
    return this.ctx.oficial_guardarTrabajosExternos(nodoParam);
  }
  function habilitarEnvio(): Boolean {
    return this.ctx.oficial_habilitarEnvio();
  }
  function habilitarSinTapa(): Boolean {
    return this.ctx.oficial_habilitarSinTapa();
  }
  function comprobarRegistroEnvio(): Boolean {
    return this.ctx.oficial_comprobarRegistroEnvio();
  }
  function crearRegistroEnvio(cursor: FLSqlCursor, desdeForm: Boolean): Boolean {
    return this.ctx.oficial_crearRegistroEnvio(cursor, desdeForm);
  }
  function comprobarPesosTExterno(): Boolean {
    return this.ctx.oficial_comprobarPesosTExterno();
  }
  function evaluarOpcionGrupos(grupos: Array, qryGrupos: FLSqlQuery, dimTrabajo: Array, hayPlegado: Boolean): Array {
    return this.ctx.oficial_evaluarOpcionGrupos(grupos, qryGrupos, dimTrabajo, hayPlegado);
  }
  function dameArrayGrupos12(): Array {
    return this.ctx.oficial_dameArrayGrupos12();
  }
  function dameArrayGrupos16(): Array {
    return this.ctx.oficial_dameArrayGrupos16();
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

  connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");
  connect(this.child("tdbGruposPliegoLibro").cursor(), "bufferCommited()", this, "iface.calcularPaginas");

  switch (cursor.modeAccess()) {
    case cursor.Insert: {
      //      var idProducto:String = formRecordlineaspresupuestoscli.iface.idProductoSel_;
      //      if (!idProducto) {
      //        MessageBox.warning(util.translate("scrpts", "No tiene ningún producto seleccionado"), MessageBox.Ok, MessageBox.NoButton);
      //        this.close();
      //      }
      //      if (util.sqlSelect("paramlibro", "id", "idproducto = " + idProducto)) {
      //        MessageBox.warning(util.translate("scrpts", "Ya hay un registro de parámetros para el producto seleccionado"), MessageBox.Ok, MessageBox.NoButton);
      //        this.close();
      //      }
      //      cursor.setValueBuffer("idproducto", idProducto);

      break;
    }
    case cursor.Edit: {
      this.iface.cargarDatos();
      break;
    }
  }
  this.iface.habilitarGrapado();
  this.iface.habilitarEnvio();
  this.iface.habilitarSinTapa();
}

function interna_validateForm(): Boolean {
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();
  debug(1);
  if (!this.iface.validarDatos())
  {
    return false;
  }
  debug(2);
  if (!this.iface.comprobarRegistroEnvio())
  {
    MessageBox.warning(util.translate("scripts", "Error al comprobar los datos de envío"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  debug(3);
  var xmlDocParam: FLDomDocument = this.iface.guardarDatos(cursor);
  if (!xmlDocParam)
    return false;
  debug(4);
  // debug(xmlDocParam.toString());
  cursor.setValueBuffer("xml", xmlDocParam.toString());

  return true;
}

function interna_calculateField(fN: String): String {
  var cursor: FLSqlCursor = this.cursor();
  var valor: String;

  switch (fN)
  {
    case "altoabierto": {
      if (cursor.valueBuffer("anchofijo")) {
        valor = cursor.valueBuffer("altocerrado") * 2;
      } else {
        valor = cursor.valueBuffer("altocerrado");
      }
      break;
    }
    case "anchoabierto": {
      if (cursor.valueBuffer("anchofijo")) {
        valor = cursor.valueBuffer("anchocerrado");
      } else {
        valor = cursor.valueBuffer("anchocerrado") * 2;
      }
      break;
    }
    case "ancholomo": {
      valor = this.iface.factorLomo * cursor.valueBuffer("numpaginas") / 2;
      break;
    }
    case "totalpliegos": {
      var numHojas: Number = parseInt(cursor.valueBuffer("numpaginas") / 2);
      var numCopias: Number = parseInt(cursor.valueBuffer("numcopias"));
      var alto: Number = parseFloat(cursor.valueBuffer("altocerrado"));
      var ancho: Number = parseFloat(cursor.valueBuffer("anchocerrado"));
      var hojasPliego: Number;
      if (alto != 0 && ancho != 0) {
        var hojasPliego1: Number = Math.floor(100 / alto) * Math.floor(70 / ancho);
        var hojasPliego2: Number = Math.floor(100 / ancho) * Math.floor(70 / alto);
        if (hojasPliego1 > hojasPliego2) {
          hojasPliego = hojasPliego1;
        } else {
          hojasPliego = hojasPliego2;
        }
        valor = Math.ceil((numHojas * numCopias) / hojasPliego);
      } else {
        valor = "";
      }
      break;
    }
    case "pesopliegos": {
      valor = cursor.valueBuffer("totalpliegos") * 0.7 * cursor.valueBuffer("gramaje") / 1000;
      break;
    }
    case "anchotapa": {
      if (cursor.valueBuffer("anchofijo")) {
        valor = cursor.valueBuffer("anchoabierto");
      } else {
        valor = parseFloat(cursor.valueBuffer("anchoabierto")) + parseFloat(cursor.valueBuffer("ancholomo"));
      }
      break;
    }
    case "altotapa": {
      if (cursor.valueBuffer("anchofijo")) {
        valor = parseFloat(cursor.valueBuffer("altoabierto")) + parseFloat(cursor.valueBuffer("ancholomo"));
      } else {
        valor = cursor.valueBuffer("altoabierto");
      }
      break;
    }
  }
  return valor;
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_cargarDatos()
{
  var cursor: FLSqlCursor = this.cursor();
  //  var xmlParam:FLDomDocument = new FLDomDocument;
  //  if (!xmlParam.setContent(cursor.valueBuffer("xml")))
  //    return;

  //  var xmlAux:FLDomNode;
  //  var xmlElemento:FLDomElement;
  //  var nodoParam:FLDomNode = xmlParam.firstChild();
}

function oficial_cargarAreaAbierto(eAreaAbierto: FLDomElement): Boolean {
  var valor: String = eAreaAbierto.attribute("Valor");
  if (!valor || valor == "")
  {
    this.child("fdbAnchoAbierto").setValue("");
    this.child("fdbAltoAbierto").setValue("");
    return true;
  }
  var dim: Array = valor.split("x");
  this.child("fdbAnchoAbierto").setValue(dim[0]);
  this.child("fdbAltoAbierto").setValue(dim[1]);

  return true;
}

function oficial_cargarAreaCerrado(eAreaCerrado: FLDomElement): Boolean {
  var valor: String = eAreaCerrado.attribute("Valor");
  if (!valor || valor == "")
  {
    this.child("fdbAnchoCerrado").setValue("");
    this.child("fdbAltoCerrado").setValue("");
    return true;
  }
  var dim: Array = valor.split("x");
  this.child("fdbAnchoCerrado").setValue(dim[0]);
  this.child("fdbAltoCerrado").setValue(dim[1]);

  return true;
}

function oficial_bufferChanged(fN: String)
{
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();
  switch (fN) {
    case "anchofijo": {
      this.child("fdbAnchoAbierto").setValue(this.iface.calculateField("anchoabierto"));
      this.child("fdbAltoAbierto").setValue(this.iface.calculateField("altoabierto"));
      break;
    }
    case "altocerrado": {
      this.child("fdbAltoAbierto").setValue(this.iface.calculateField("altoabierto"));
      this.child("fdbTotalPliegos").setValue(this.iface.calculateField("totalpliegos"));
      break;
    }
    case "anchocerrado": {
      this.child("fdbAnchoAbierto").setValue(this.iface.calculateField("anchoabierto"));
      this.child("fdbTotalPliegos").setValue(this.iface.calculateField("totalpliegos"));
      break;
    }
    case "altoabierto": {
      this.child("fdbAltoTapa").setValue(this.iface.calculateField("altotapa"));
      break;
    }
    case "anchoabierto": {
      this.child("fdbAnchoTapa").setValue(this.iface.calculateField("anchotapa"));
      break;
    }
    case "ancholomo": {
      if (cursor.valueBuffer("anchofijo")) {
        this.child("fdbAltoTapa").setValue(this.iface.calculateField("altotapa"));
      } else {
        this.child("fdbAnchoTapa").setValue(this.iface.calculateField("anchotapa"));
      }
      break;
    }
    case "numpaginas": {
      if (!this.iface.factorLomo) {
        this.iface.factorLomo = this.iface.calcularFL();
      }
      this.child("fdbAnchoLomo").setValue(this.iface.calculateField("ancholomo"));
      this.child("fdbTotalPliegos").setValue(this.iface.calculateField("totalpliegos"));
      break;
    }
    case "numcopias": {
      this.child("fdbTotalPliegos").setValue(this.iface.calculateField("totalpliegos"));
      break;
    }
    case "gramaje": {
      this.iface.factorLomo = this.iface.calcularFL();
      this.child("fdbAnchoLomo").setValue(this.iface.calculateField("ancholomo"));
      this.child("fdbPesoPliegos").setValue(this.iface.calculateField("pesopliegos"));
      break;
    }
    case "totalpliegos": {
      this.child("fdbPesoPliegos").setValue(this.iface.calculateField("pesopliegos"));
      break;
    }
    case "encuadernacion": {
      this.iface.habilitarGrapado();
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
    case "sintapa": {
      this.iface.habilitarSinTapa();
      break;
    }
  }
}

function oficial_habilitarGrapado()
{
  var cursor: FLSqlCursor = this.cursor();
  if (cursor.valueBuffer("encuadernacion") == "Grapado") {
    this.child("fdbGrapado").setDisabled(false);
  } else {
    this.child("fdbGrapado").setValue("");
    this.child("fdbGrapado").setDisabled(true);
  }
}

function oficial_calcularFL(): Number {
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  var fL: Number = parseFloat(util.sqlSelect("gramajes", "grosorunidad", "gramaje = " + cursor.valueBuffer("gramaje")));
  if (isNaN(fL))
  {
    fL = 0;
  }
  return fL;
}

function oficial_guardarDatos(cursor: FLSqlCursor): FLDomDocument {
  var util: FLUtil = new FLUtil;

  var xmlParam: FLDomDocument = new FLDomDocument;
  xmlParam.setContent("<Parametros/>");
  var nodoParam: FLDomNode = xmlParam.firstChild();
  var nodoAux: FLDomNode;

  var numCopias: String = this.child("fdbNumCopias").value();
  if (!numCopias || numCopias == "" || numCopias == 0)
  {
    MessageBox.warning(util.translate("scripts", "Debe establecer el número de copias"), MessageBox.Ok, MessageBox.NoButton);
    return;
  }
  nodoAux = this.iface.crearNodoHijo(nodoParam, "NumCopiasParam");
  nodoAux.toElement().setAttribute("Valor", numCopias);

  var numPaginas: String = this.child("fdbNumPaginas").value();
  if (!numPaginas || numPaginas == "" || numPaginas == 0)
  {
    MessageBox.warning(util.translate("scripts", "Debe establecer el número de páginas"), MessageBox.Ok, MessageBox.NoButton);
    return;
  }
  nodoAux = this.iface.crearNodoHijo(nodoParam, "NumPaginasParam");
  nodoAux.toElement().setAttribute("Valor", numPaginas);

  var gramaje: String = this.child("fdbGramaje").value();
  if (!gramaje || gramaje == "" || gramaje == 0)
  {
    MessageBox.warning(util.translate("scripts", "Debe establecer el gramaje"), MessageBox.Ok, MessageBox.NoButton);
    return;
  }
  nodoAux = this.iface.crearNodoHijo(nodoParam, "GramajeParam");
  nodoAux.toElement().setAttribute("Valor", gramaje);

  var codMarcaPapel: String = this.child("fdbCodMarcaPapel").value();
  if (!codMarcaPapel || codMarcaPapel == "")
  {
    MessageBox.warning(util.translate("scripts", "Debe establecer la marca de papel"), MessageBox.Ok, MessageBox.NoButton);
    return;
  }
  nodoAux = this.iface.crearNodoHijo(nodoParam, "CodMarcaPapelParam");
  nodoAux.toElement().setAttribute("Valor", codMarcaPapel);

  var anchoLomo: Number = this.child("fdbAnchoLomo").value();
  if (isNaN(anchoLomo))
  {
    MessageBox.warning(util.translate("scripts", "Debe establecer el ancho del lomo"), MessageBox.Ok, MessageBox.NoButton);
    return;
  }
  nodoAux = this.iface.crearNodoHijo(nodoParam, "AnchoLomoParam");
  nodoAux.toElement().setAttribute("Valor", anchoLomo);

  var diseno: Number = this.child("fdbDiseno").value();
  nodoAux = this.iface.crearNodoHijo(nodoParam, "DisenoParam");
  if (diseno)
  {
    nodoAux.toElement().setAttribute("Valor", "true");
  } else {
    nodoAux.toElement().setAttribute("Valor", "false");
  }


  var areaCerrado: String = this.child("fdbAnchoCerrado").value() + "x" + this.child("fdbAltoCerrado").value();
  if (!areaCerrado || areaCerrado.startsWith("x") || areaCerrado.endsWith("x"))
  {
    MessageBox.warning(util.translate("scripts", "Debe establecer el área del trabajo cerrado"), MessageBox.Ok, MessageBox.NoButton);
    return;
  }
  var areaAbierto: String = this.child("fdbAnchoAbierto").value() + "x" + this.child("fdbAltoAbierto").value();
  if (!areaAbierto || areaAbierto.startsWith("x") || areaAbierto.endsWith("x"))
  {
    MessageBox.warning(util.translate("scripts", "Debe establecer el área del trabajo abierto"), MessageBox.Ok, MessageBox.NoButton);
    return;
  }
  nodoAux = this.iface.crearNodoHijo(nodoParam, "AreaTrabajoParam");
  nodoAux.toElement().setAttribute("Abierto", areaAbierto);
  nodoAux.toElement().setAttribute("Cerrado", areaCerrado);

  var elementoXml: FLDomElement;

  var encuadernacion: String = cursor.valueBuffer("encuadernacion");
  var grapado: String = cursor.valueBuffer("grapado");
  elementoXml = xmlParam.createElement("EncuadernacionParam");
  elementoXml.setAttribute("Tipo", encuadernacion);

  //  var eGrapado:FLDomElement =

  elementoXml.setAttribute("Grapado", grapado);
  if (encuadernacion == "Grapado")
  {
    var datosGrapado: Array = this.iface.dameDatosGrapado(grapado);
    elementoXml.setAttribute("Cabezales", datosGrapado["cabezales"]);
    elementoXml.setAttribute("CabNormales", datosGrapado["normales"]);
    elementoXml.setAttribute("CabOmega", datosGrapado["omegas"]);
  }

  nodoParam.appendChild(elementoXml);

  if (!this.iface.guardarGrupos(nodoParam))
  {
    return false;
  }
  if (!this.iface.guardarCombinacionesEnc(nodoParam))
  {
    return false;
  }
  if (!this.iface.guardarTrabajosExternos(nodoParam))
  {
    return false;
  }

  if (!cursor.valueBuffer("sintapa"))
  {
    nodoAux = this.iface.crearNodoHijo(nodoParam, "TapaParam");
    nodoAux.toElement().setAttribute("Valor", "true");

    var gramajeTapa: String = this.child("fdbGramajeTapa").value();
    if (!gramajeTapa || gramajeTapa == "" || gramajeTapa == 0) {
      MessageBox.warning(util.translate("scripts", "Debe establecer el gramaje de la tapa"), MessageBox.Ok, MessageBox.NoButton);
      return;
    }
    nodoAux = this.iface.crearNodoHijo(nodoParam, "GramajeTapaParam");
    nodoAux.toElement().setAttribute("Valor", gramajeTapa);

    var codMarcaPapelTapa: String = this.child("fdbCodMarcaPapelTapa").value();
    if (!codMarcaPapelTapa || codMarcaPapelTapa == "") {
      MessageBox.warning(util.translate("scripts", "Debe establecer la marca de papel"), MessageBox.Ok, MessageBox.NoButton);
      return;
    }
    nodoAux = this.iface.crearNodoHijo(nodoParam, "CodMarcaPapelTapaParam");
    nodoAux.toElement().setAttribute("Valor", codMarcaPapelTapa);
  } else {
    nodoAux = this.iface.crearNodoHijo(nodoParam, "TapaParam");
    nodoAux.toElement().setAttribute("Valor", "false");
  }

  // debug(xmlParam.toString(4));

  return xmlParam;
}

function oficial_guardarTrabajosExternos(nodoParam: FLDomNode): Boolean {
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  var eTrabajos: FLDomElement = nodoParam.ownerDocument().createElement("TrabajosExternosParam");
  nodoParam.appendChild(eTrabajos);

  var eTrabajo: FLDomElement;
  var eParamFact: FLDomElement;
  var eParamParteFact: FLDomElement;

  var qryTrabajos: FLSqlQuery = new FLSqlQuery;
  with(qryTrabajos)
  {
    setTablesList("trabexternolibro");
    setSelect("id, idtipotarea, codtipocentro, codproveedor, nombre, cantidad, pvptrabajo, portes, pvptotal, codagencia, peso, costefijo");
    setFrom("trabexternolibro");
    setWhere("idparamlibro = " + cursor.valueBuffer("id"));
    setForwardOnly(true);
  }
  if (!qryTrabajos.exec())
  {
    return false;
  }

  while (qryTrabajos.next())
  {
    eTrabajo = nodoParam.ownerDocument().createElement("TrabajoExterno")
    eTrabajo.setAttribute("IdTrabajo", qryTrabajos.value("id"));
    eTrabajo.setAttribute("IdTipoTarea", qryTrabajos.value("idtipotarea"));
    eTrabajo.setAttribute("CodTipoCentro", qryTrabajos.value("codtipocentro"));
    eTrabajo.setAttribute("CodProveedor", qryTrabajos.value("codproveedor"));
    eTrabajo.setAttribute("NombreProveedor", qryTrabajos.value("nombre"));
    eTrabajo.setAttribute("Cantidad", qryTrabajos.value("cantidad"));
    eTrabajo.setAttribute("PvpTrabajo", qryTrabajos.value("pvptrabajo"));
    eTrabajo.setAttribute("Portes", qryTrabajos.value("portes"));
    eTrabajo.setAttribute("PvpTotal", qryTrabajos.value("pvptotal"));
    eTrabajo.setAttribute("CodAgencia", qryTrabajos.value("codagencia"));
    eTrabajo.setAttribute("Peso", qryTrabajos.value("peso"));
    if (qryTrabajos.value("costefijo")) {
      eTrabajo.setAttribute("CosteFijo", "true");
    } else {
      eTrabajo.setAttribute("CosteFijo", "false");
    }
    eTrabajos.appendChild(eTrabajo);
  }
  return true;
}

function oficial_guardarGrupos(nodoParam: FLDomNode): Boolean {
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  var hayPlegado: Boolean = true;
  if (util.sqlSelect("trabexternolibro", "id", "idparamlibro = " + cursor.valueBuffer("id") + " AND idtipotarea = 'ENCUADERNADO'"))
  {
    hayPlegado = false;
  }

  var numPaginas: Number;
  var numHojas: Number;
  var areaTrabajo: Number = flfacturac.iface.dameAtributoXML(nodoParam, "AreaTrabajoParam@Abierto");

  var eParamGrupos: FLDomElement = nodoParam.ownerDocument().createElement("GruposPaginaParam");
  nodoParam.appendChild(eParamGrupos);

  var eGrupo: FLDomElement;
  var eParamFact: FLDomElement;
  var eParamParteFact: FLDomElement;



  // debug("areaPliegoMax= " + areaPliegoMax);
  // debug("areaPlanchaMax = " + areaTrabajo);
  // debug("numpaginas = " + numPaginas);
  //  var dimPliego:Array = areaPliegoMax.toString().split("x");
  var dimTrabajo: Array = areaTrabajo.toString().split("x");

  var qryGrupos: FLSqlQuery = new FLSqlQuery;
  qryGrupos.setTablesList("grupospliegolibro");
  qryGrupos.setSelect("idgrupo, nombre, numpaginas, colores");
  qryGrupos.setFrom("grupospliegolibro");
  qryGrupos.setWhere("idparamlibro = " + cursor.valueBuffer("id"));
  qryGrupos.setForwardOnly(true);

  if (!qryGrupos.exec())
  {
    return false;
  }


  //  var factorXA:Number;
  //  var factorXB:Number;
  //  var factorYA:Number;
  //  var factorYB:Number;
  //  var totalA:Number;
  //  var totalB:Number;
  //  var pliegosTrabajo:Number;
  //  var dimPliegoTrabajoX:Number;
  //  var dimPliegoTrabajoY:Number;
  //  var factorX:Number;
  //  var factorY:Number;
  var xTrabajo: Number;
  var yTrabajo: Number;

  while (qryGrupos.next())
  {

    numPaginas = parseInt(qryGrupos.value("numpaginas"));
    numHojas = numPaginas / 2;

    eGrupo = nodoParam.ownerDocument().createElement("Grupo")
    eGrupo.setAttribute("IdGrupo", qryGrupos.value("idgrupo"));
    eGrupo.setAttribute("Nombre", qryGrupos.value("nombre"));
    eGrupo.setAttribute("NumPaginas", numPaginas);

    var colores: String = qryGrupos.value("colores");
    eGrupo.setAttribute("Colores", colores);
    var color: Array = colores.split("+");
    if (parseInt(color[1]) > 0) {
      eGrupo.setAttribute("DosCaras", "true");
    } else {
      eGrupo.setAttribute("DosCaras", "false");
    }

    eParamGrupos.appendChild(eGrupo);

    //    eParamFact = nodoParam.ownerDocument().createElement("Factorizacion");
    //    eGrupo.appendChild(eParamFact);

    var arrayGrupos: Array = this.iface.dameArrayGrupos16();
    var datosOpcion16: Array = this.iface.evaluarOpcionGrupos(arrayGrupos, qryGrupos, dimTrabajo, hayPlegado);
    var primerNivel16: Number = datosOpcion16["primernivel"];
    arrayGrupos = this.iface.dameArrayGrupos12();
    var datosOpcion12: Array = this.iface.evaluarOpcionGrupos(arrayGrupos, qryGrupos, dimTrabajo, hayPlegado);
    var primerNivel12: Number = datosOpcion12["primernivel"];
    debug("primerNivel12 = " + primerNivel12)
    debug("primerNivel16 = " + primerNivel16)
    if (primerNivel16 <= primerNivel12) {
      debug("Aplicando 16");
      eGrupo.appendChild(datosOpcion16["nodofact"]);
    } else {
      debug("Aplicando 12");
      eGrupo.appendChild(datosOpcion12["nodofact"]);
    }
  }

  return true;
}

function oficial_dameArrayGrupos16(): Array {
  var grupos: Array = [];
  grupos[0] = [];
  grupos[0]["paginaspliego"] = 64;
  grupos[0]["plegado"] = "2+1";
  grupos[0]["factorx"] = 4;
  grupos[0]["factory"] = 3;
  grupos[1] = [];
  grupos[1]["paginaspliego"] = 32;
  grupos[1]["plegado"] = "2+1";
  grupos[1]["factorx"] = 4;
  grupos[1]["factory"] = 2;
  grupos[2] = [];
  grupos[2]["paginaspliego"] = 16;
  grupos[2]["plegado"] = "1+2";
  grupos[2]["factorx"] = 2;
  grupos[2]["factory"] = 2;
  grupos[3] = [];
  grupos[3]["paginaspliego"] = 8;
  grupos[3]["plegado"] = "1+1";
  grupos[3]["factorx"] = 2;
  grupos[3]["factory"] = 1;
  grupos[4] = [];
  grupos[4]["paginaspliego"] = 4;
  grupos[4]["plegado"] = "1+0";
  grupos[4]["factorx"] = 1;
  grupos[4]["factory"] = 1;
  return grupos;
}

function oficial_dameArrayGrupos12(): Array {
  var grupos: Array = [];
  grupos[0] = [];
  grupos[0]["paginaspliego"] = 48;
  grupos[0]["plegado"] = "2+1";
  grupos[0]["factorx"] = 4;
  grupos[0]["factory"] = 3;
  grupos[1] = [];
  grupos[1]["paginaspliego"] = 24;
  grupos[1]["plegado"] = "4+1";
  grupos[1]["factorx"] = 3;
  grupos[1]["factory"] = 2;
  grupos[2] = [];
  grupos[2]["paginaspliego"] = 12;
  grupos[2]["plegado"] = "2+1";
  grupos[2]["factorx"] = 3;
  grupos[2]["factory"] = 1;
  grupos[3] = [];
  grupos[3]["paginaspliego"] = 8;
  grupos[3]["plegado"] = "1+1";
  grupos[3]["factorx"] = 2;
  grupos[3]["factory"] = 1;
  grupos[4] = [];
  grupos[4]["paginaspliego"] = 4;
  grupos[4]["plegado"] = "1+0";
  grupos[4]["factorx"] = 1;
  grupos[4]["factory"] = 1;
  return grupos;
}

function oficial_evaluarOpcionGrupos(grupos: Array, qryGrupos: FLSqlQuery, dimTrabajo: Array, hayPlegado: Boolean): Array {
  var datos: Array = [];

  var xmlDocFact: FLDomDocument = new FLDomDocument;
  xmlDocFact.setContent("<Factorizacion/>");
  var eParamFact: FLDomElement = xmlDocFact.firstChild().toElement();

  var areaPliegoMax: String = "100x70";
  var xTrabajo: Number;
  var yTrabajo: Number;
  if (dimTrabajo[0] > dimTrabajo[1])
  {
    xTrabajo = dimTrabajo[1];
    yTrabajo = dimTrabajo[0];
  } else {
    xTrabajo = dimTrabajo[0];
    yTrabajo = dimTrabajo[1];
  }
  var numPaginas: Number = parseInt(qryGrupos.value("numpaginas"));
  var numHojas: Number = numPaginas / 2;

  /// Factorización en 16x + 8y + 4z = numHojas
  var resto: Number = numPaginas;
  var areaGrupo: String;
  var totalPliegos: Number;
  var paginasPliego: Number;
  var opcion: String = "";
  var parteOpcion: String = "";

  // debug("resto " + resto);
  // debug("pliegosTrabajo " + pliegosTrabajo);

  var iGrupo: Number = 0;
  var ratioNormal: Number;
  var ratioCruzado: Number;
  var distPaginasTrabajo: String;
  var primerNivel: Number = -1;
  while (resto >= 1)
  {
    paginasPliego = grupos[iGrupo]["paginaspliego"]; //pliegosTrabajo * 4;
    totalPliegos = Math.floor(resto / paginasPliego);
    debug("totalPliegos " + totalPliegos);
    if (totalPliegos > 0) {
      debug("xTrabajo = " + xTrabajo);
      debug("grupos[iGrupo][factorx] = " + grupos[iGrupo]["factorx"]);
      debug("yTrabajo = " + yTrabajo);
      debug("grupos[iGrupo][factory] = " + grupos[iGrupo]["factory"]);
      /// Tomamos la distribución cuyo factor dimMenor/dimMayor se acerca más a 1 (la mayor, la más cuadrada)
      debug("Ratio normal");
      if ((xTrabajo * grupos[iGrupo]["factorx"]) > (yTrabajo * grupos[iGrupo]["factory"])) {
        ratioNormal = (yTrabajo * grupos[iGrupo]["factory"]) / (xTrabajo * grupos[iGrupo]["factorx"]);
        debug(ratioNormal + " = (" + yTrabajo + " * " + grupos[iGrupo]["factory"] + ") / (" + xTrabajo + " * " + grupos[iGrupo]["factorx"] + ")");
      } else {
        ratioNormal = (xTrabajo * grupos[iGrupo]["factorx"]) / (yTrabajo * grupos[iGrupo]["factory"]);
        debug(ratioNormal + " = (" + xTrabajo + " * " + grupos[iGrupo]["factorx"] + ") / (" + yTrabajo + " * " + grupos[iGrupo]["factory"] + ")");
      }
      debug("Ratio cruzado");
      if ((xTrabajo * grupos[iGrupo]["factory"]) > (yTrabajo * grupos[iGrupo]["factorx"])) {
        ratioCruzado = (yTrabajo * grupos[iGrupo]["factorx"]) / (xTrabajo * grupos[iGrupo]["factory"]);
        debug(ratioCruzado + " = (" + yTrabajo + " * " + grupos[iGrupo]["factorx"] + ") / (" + xTrabajo + " * " + grupos[iGrupo]["factory"] + ")");
      } else {
        ratioCruzado = (xTrabajo * grupos[iGrupo]["factory"]) / (yTrabajo * grupos[iGrupo]["factorx"]);
        debug(ratioCruzado + " = (" + xTrabajo + " * " + grupos[iGrupo]["factory"] + ") / (" + yTrabajo + " * " + grupos[iGrupo]["factorx"] + ")");
      }
      if (ratioNormal > ratioCruzado) {
        areaGrupo = xTrabajo * grupos[iGrupo]["factorx"] + "x" + yTrabajo * grupos[iGrupo]["factory"];
        distPaginasTrabajo = grupos[iGrupo]["factorx"] + "x" + grupos[iGrupo]["factory"];
      } else {
        areaGrupo = xTrabajo * grupos[iGrupo]["factory"] + "x" + yTrabajo * grupos[iGrupo]["factorx"];
        distPaginasTrabajo = grupos[iGrupo]["factory"] + "x" + grupos[iGrupo]["factorx"];
      }
      debug("areaGrupo = " + areaGrupo);
      if (!flfacturac.iface.pub_entraEnArea(areaGrupo, areaPliegoMax)) {
        // debug("NO ENTRA 1");
        var dimAux: Number = xTrabajo;
        xTrabajo = yTrabajo;
        yTrabajo = dimAux;
        areaGrupo = xTrabajo * grupos[iGrupo]["factorx"] + "x" + yTrabajo * grupos[iGrupo]["factory"];
        // debug("areaGrupo = " + areaGrupo);
        if (!flfacturac.iface.pub_entraEnArea(areaGrupo, areaPliegoMax)) {
          // debug("NO ENTRA 2");
          iGrupo++;
          continue;
        }
      }
      if (primerNivel == -1) {
        primerNivel = iGrupo;
      }
      eParamParteFact = xmlDocFact.createElement("Parte"); //nodoParam.ownerDocument().createElement("Parte");
      eParamParteFact.setAttribute("NumPliegos", totalPliegos);
      eParamParteFact.setAttribute("PaginasPliego", paginasPliego);
      eParamParteFact.setAttribute("NumPaginas", paginasPliego * totalPliegos);
      eParamParteFact.setAttribute("AreaTrabajo", areaGrupo);
      eParamParteFact.setAttribute("DistPaginasTrabajo", distPaginasTrabajo);
      if (hayPlegado) {
        eParamParteFact.setAttribute("Plegado", grupos[iGrupo]["plegado"]);
      } else {
        eParamParteFact.setAttribute("Plegado", "0+0");
      }
      parteOpcion = paginasPliego + "x" + totalPliegos;
      eParamParteFact.setAttribute("ParteOpcion", parteOpcion);
      eParamFact.appendChild(eParamParteFact);
      if (opcion != "") {
        opcion += " + ";
      }
      opcion += parteOpcion;
    }
    resto -= totalPliegos * paginasPliego;
    debug("resto " + resto);
    iGrupo++;
  }
  if (resto > 0)
  {
    MessageBox.warning(util.translate("scripts", "Error al factorizar los pliegos en %1").arg(opcion), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  eParamFact.setAttribute("Opcion", opcion);
  datos["primernivel"] = primerNivel;
  datos["nodofact"] = eParamFact;

  return datos;
}
/** Combinaciones de encuadernación. Son las distintas posibilidades de combinar las factorizaciones de cada grupo de páginas.
Sólo hay una combinación puesto que cada grupo sólo tiene una opción, según el cálculo 12x o 16x.
\end */
function oficial_guardarCombinacionesEnc(nodoParam: FLDomNode): Boolean {
  var eCombinaciones: FLDomElement = nodoParam.ownerDocument().createElement("CombEncuadernacionParam");
  nodoParam.appendChild(eCombinaciones);
  var numGrupo: Number = 0;
  var nodoGrupos: FLDomNode = nodoParam.namedItem("GruposPaginaParam");
  var nodoGrupo: FLDomNode = nodoGrupos.firstChild();
  var nodosFact: FLDomNodeList = nodoGrupo.childNodes();
  var eCombi: FLDomElement;
  for (var i: Number = 0; i < nodosFact.length(); i++)
  {
    eCombi = nodoParam.ownerDocument().createElement("Combinacion");
    eCombinaciones.appendChild(eCombi);
    eCombi.setAttribute("Opcion", nodosFact.item(i).toElement().attribute("Opcion"));
    eCombi.setAttribute("NumPliegosPlegado", this.iface.dameTotalPliegosFact(nodosFact.item(i)));
    if (!this.iface.damePliegosPlegado(nodosFact.item(i), eCombi)) {
      return false;
    }
    if (!this.iface.combinarSiguienteGrupo(eCombi, nodoGrupo)) {
      return false;
    }
  }
  return true;
}

function oficial_combinarSiguienteGrupo(eCombi: FLDomElement, nodoGrupo: FLDomNode): Boolean {
  nodoGrupo = nodoGrupo.nextSibling();
  if (!nodoGrupo)
  {
    return true;
  }
  var nodosFact: FLDomNodeList = nodoGrupo.childNodes();
  //  var eCombi:FLDomElement;
  var opcionPrevia: String = eCombi.attribute("Opcion");
  var numPPPrevio: Number = parseInt(eCombi.attribute("NumPliegosPlegado"));
  var numPP: Number;
  var opcion: String;
  var nodoCombiClon: FLDomNode;
  var nodoAux: FLDomNode = eCombi.cloneNode();
  for (var i: Number = 0; i < nodosFact.length(); i++)
  {
    opcion = opcionPrevia + " & " + nodosFact.item(i).toElement().attribute("Opcion");
    numPP = numPPPrevio + parseInt(this.iface.dameTotalPliegosFact(nodosFact.item(i)));
    if (i == 0) {
      eCombi.setAttribute("Opcion", opcion);
      eCombi.setAttribute("NumPliegosPlegado", numPP);
      if (!this.iface.damePliegosPlegado(nodosFact.item(i), eCombi)) {
        return false;
      }
      if (!this.iface.combinarSiguienteGrupo(eCombi, nodoGrupo)) {
        return false;
      }
    } else {
      nodoCombiClon = nodoAux.cloneNode();
      eCombi.parentNode().appendChild(nodoCombiClon);
      nodoCombiClon.toElement().setAttribute("Opcion", opcion);
      nodoCombiClon.toElement().setAttribute("NumPliegosPlegado", numPP);
      if (!this.iface.damePliegosPlegado(nodosFact.item(i), nodoCombiClon.toElement())) {
        return false;
      }
      if (!this.iface.combinarSiguienteGrupo(nodoCombiClon.toElement(), nodoGrupo)) {
        return false;
      }
    }
  }

  return true;
}

function oficial_dameTotalPliegosFact(nodoFact: FLDomNode): Number {
  var total: Number = 0;
  for (var nodoParte: FLDomNode = nodoFact.firstChild(); nodoParte; nodoParte = nodoParte.nextSibling())
  {
    total += parseInt(nodoParte.toElement().attribute("NumPliegos"));
  }
  return total;
}

/** \D Asocia a un nodo Combinación nodos de las partes de las factorizaciones asociadas, de forma que para cada combinación se sepa qué tipo de pliegos de plegado hay y en qué cantidad
@param  nodoFact: Nodo factorización asociado a la combinación
@param  nodoCombi: Nodo combinación asociado a la combinación
\end */
function oficial_damePliegosPlegado(nodoFact: FLDomNode, eCombi: FLDomElement): Boolean {
  var total: Number = 0;
  var nPP: FLDomNode;
  var ePP: FLDomElement;
  var paginasPliego: Number;
  var numPliegos: Number;
  var maxPP: Number = parseInt(eCombi.attribute("MaxPaginasPliego"));
  if (isNaN(maxPP))
  {
    maxPP = 0;
  }
  for (var nodoParte: FLDomNode = nodoFact.firstChild(); nodoParte; nodoParte = nodoParte.nextSibling())
  {
    paginasPliego = parseInt(nodoParte.toElement().attribute("PaginasPliego"));
    if (maxPP < paginasPliego) {
      maxPP = paginasPliego;
      eCombi.setAttribute("MaxPaginasPliego", maxPP);
    }
    numPliegos = parseInt(nodoParte.toElement().attribute("NumPliegos"));
    nPP = flfacturac.iface.pub_dameNodoXML(eCombi, "PliegosPlegado[@PaginasPliego=" + paginasPliego + "]");
    if (!nPP) {
      ePP = eCombi.ownerDocument().createElement("PliegosPlegado");
      ePP.setAttribute("PaginasPliego", paginasPliego);
      ePP.setAttribute("NumPliegos", numPliegos);
      ePP.setAttribute("NumPaginas", paginasPliego * numPliegos);
      eCombi.appendChild(ePP);
    } else {
      nPP.toElement().setAttribute("NumPliegos", parseInt(nPP.toElement().attribute("NumPliegos")) + numPliegos);
      nPP.toElement().setAttribute("NumPaginas", parseInt(nPP.toElement().attribute("NumPaginas")) + (numPliegos * paginasPliego));
    }
  }
  return true;
}

function oficial_dameDatosGrapado(grapado: String): Array {
  var res: Array;
  res["normales"] = 0;
  res["omegas"] = 0;
  res["cabezales"] = 0;
  for (var i: Number = 0; i < grapado.length; i++)
  {
    if (grapado.charAt(i).toUpperCase() == "N") {
      res["cabezales"]++;
      res["normales"]++;
    }
    if (grapado.charAt(i).toUpperCase() == "O") {
      res["cabezales"]++;
      res["omegas"]++;
    }
  }
  return res;
}

function oficial_crearNodoHijo(nodoPadre: FLDomNode, nombreHijo: String): FLDomNode {
  var xmlDocAux: FLDomDocument = new FLDomDocument;
  xmlDocAux.setContent("<" + nombreHijo + "/>");
  var xmlNodo: FLDomNode = xmlDocAux.firstChild();
  nodoPadre.appendChild(xmlNodo);
  return xmlNodo;
}

function oficial_validarDatos(): Boolean {
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  if (!this.iface.comprobarPesosTExterno())
  {
    return false;
  }
  var numPaginas: Number = cursor.valueBuffer("numpaginas");
  if (isNaN(numPaginas))
  {
    numPaginas = 0;
  }
  if (numPaginas % 4 != 0)
  {
    MessageBox.warning(util.translate("scripts", "El número de páginas debe ser múltiplo de 4"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }

  var altoCerrado: Number = cursor.valueBuffer("altocerrado");
  debug("altoCerrado = " + altoCerrado);
  if (isNaN(altoCerrado) || altoCerrado == 0)
  {
    MessageBox.warning(util.translate("scripts", "Debe establecer el alto del trabajo"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }

  var anchoCerrado: Number = cursor.valueBuffer("anchocerrado");
  if (isNaN(anchoCerrado) || anchoCerrado == 0)
  {
    MessageBox.warning(util.translate("scripts", "Debe establecer el ancho del trabajo"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }

  return true;
}

function oficial_comprobarPesosTExterno(): Boolean {
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  if (!util.sqlSelect("trabexternolibro", "id", "idparamlibro = " + cursor.valueBuffer("id") + " AND idtipotarea = 'ENCUADERNADO'"))
  {
    return true;
  }
  var pesoPliegos: Number = cursor.valueBuffer("pesopliegos");
  var pesoPliegosTrab: Number = util.sqlSelect("trabexternolibro", "peso", "idparamlibro = " + cursor.valueBuffer("id") + " AND idtipotarea = 'ENCUADERNADO'");
  if (pesoPliegos != pesoPliegosTrab)
  {
    var res: Number = MessageBox.warning(util.translate("scripts", "El peso de los pliegos (%1) ha variado respecto de los indicados en el trabajo externo (%2).¿Desea continuar?").arg(pesoPliegos).arg(pesoPliegosTrab), MessageBox.Yes, MessageBox.No);
    if (res != MessageBox.Yes) {
      return false;
    }
  }
  return true;
}

function oficial_calcularPaginas()
{
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  var numPaginas: Number = parseInt(util.sqlSelect("grupospliegolibro", "SUM(numpaginas)", "idparamlibro = " + cursor.valueBuffer("id")));
  if (isNaN(numPaginas)) {
    numPaginas = 0;
  }
  this.child("fdbNumPaginas").setValue(numPaginas);
}

function oficial_comprobarRegistroEnvio(): Boolean {
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  if (cursor.valueBuffer("ignorarenvio"))
  {
    if (!util.sqlDelete("paramenvio", "idparamlibro= " + cursor.valueBuffer("id"))) {
      return false;
    }
  } else {
    if (util.sqlSelect("paramenvio", "id", "idparamlibro = " + cursor.valueBuffer("id")))
    {
      if (cursor.valueBuffer("numcopias") != cursor.valueBufferCopy("numcopias")) {
        var res: Number = MessageBox.warning(util.translate("scripts", "La cantidad o el peso del trabajo ha variado.\n¿Desea recalcular el registro de envío?"), MessageBox.Yes, MessageBox.No);
        if (res == MessageBox.No) {
          return true;
        }
      }
    }
    if (!this.iface.crearRegistroEnvio(cursor, true))
    {
      return false;
    }
  }
  return true;
}

function oficial_crearRegistroEnvio(cursor: FLSqlCursor, desdeForm: Boolean): Boolean {
  var util: FLUtil = new FLUtil;

  var curEnvio: FLSqlCursor;
  if (desdeForm)
  {
    curEnvio = this.child("tdbParamEnvio").cursor();
  } else {
    curEnvio = new FLSqlCursor("paramenvio");
  }

  if (!util.sqlDelete("paramenvio", "idparamlibro = " + cursor.valueBuffer("id")))
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
  curEnvio.setValueBuffer("idparamlibro", cursor.valueBuffer("id"));
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

  curEnvio.setValueBuffer("numcopias", cursor.valueBuffer("numcopias"));
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
  if (cursor.valueBuffer("ignorarenvio")) {
    this.child("gbxEnvio").enabled = false;
  } else {
    this.child("gbxEnvio").enabled = true;
  }
}

function oficial_habilitarSinTapa()
{
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();
  if (cursor.valueBuffer("sintapa")) {
    this.child("gbxTapa").enabled = false;
  } else {
    this.child("gbxTapa").enabled = true;
  }
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////