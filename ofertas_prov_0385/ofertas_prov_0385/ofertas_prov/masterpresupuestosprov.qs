/***************************************************************************
                 masterpresupuestosprov.qs  -  description
                             -------------------
    begin                : lun sep 08 2008
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
    return this.ctx.interna_init();
  }
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna
{
  var tdbRecords: FLTableDB;
  var chkPendiente: Object;
  var chkEnviada: Object;
  var chkRecibida: Object;
  var chkAnulada: Object;
  var chkTodas: Object;
  var filtroProcedencia_: String;
  var filtroEstado_: String;
  var valor_: String;
  var curLineaOferta: FLSqlCursor;
  var tipoInsercion_: String;
  var pbnGenerarPedido: Object;
  var curPedido: FLSqlCursor;
  var curLineaPedido: FLSqlCursor;

  function oficial(context)
  {
    interna(context);
  }
  function imprimir(codPresupuesto: String)
  {
    return this.ctx.oficial_imprimir(codPresupuesto);
  }
  function filtrarTabla()
  {
    return this.ctx.oficial_filtrarTabla();
  }
  function filtroEstado(): String {
    return this.ctx.oficial_filtroEstado();
  }
  function filtroProcedencia()
  {
    return this.ctx.oficial_filtroProcedencia();
  }
  function refrescarFiltro(opcion: String)
  {
    return this.ctx.oficial_refrescarFiltro(opcion);
  }
  function introduccionDatos_clicked()
  {
    return this.ctx.oficial_introduccionDatos_clicked();
  }
  //  function introduccionDatos(codPresupuesto:String):Boolean {
  //    return this.ctx.oficial_introduccionDatos(codPresupuesto);
  //  }
  //  function generarLineas(curDatos:FLSqlCursor):Boolean {
  //    return this.ctx.oficial_generarLineas(curDatos);
  //  }
  //  function actualizarArticulosProv(xmlLinea:FLDomElement, codProveedor:String):Boolean {
  //    return this.ctx.oficial_actualizarArticulosProv(xmlLinea, codProveedor);
  //  }
  function commonCalculateField(fN: String, cursor: FLSqlCursor): String {
    return this.ctx.oficial_commonCalculateField(fN, cursor);
  }
  function generarPedido_clicked()
  {
    return this.ctx.oficial_generarPedido_clicked();
  }
  function generarPedido(curPresupuesto: FLSqlCursor): Number {
    return this.ctx.oficial_generarPedido(curPresupuesto);
  }
  function datosPedido(curPresupuesto: FLSqlCursor): Boolean {
    return this.ctx.oficial_datosPedido(curPresupuesto);
  }
  function copiaLineas(idPresupuesto: Number, idPedido: Number): Boolean {
    return this.ctx.oficial_copiaLineas(idPresupuesto, idPedido);
  }
  function copiaLineaPresupuesto(curLineaPresupuesto: FLSqlCursor, idPedido: Number): Number {
    return this.ctx.oficial_copiaLineaPresupuesto(curLineaPresupuesto, idPedido);
  }
  function totalesPedido(): Boolean {
    return this.ctx.oficial_totalesPedido();
  }
  function datosLineaPedido(curLineaPresupuesto: FLSqlCursor): Boolean {
    return this.ctx.oficial_datosLineaPedido(curLineaPresupuesto);
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
  function pub_imprimir(codPresupuesto: String)
  {
    return this.imprimir(codPresupuesto);
  }
  function pub_commonCalculateField(fN: String, cursor: FLSqlCursor): String {
    return this.commonCalculateField(fN, cursor);
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
  this.iface.chkPendiente = this.child("chkPendiente");
  this.iface.chkEnviada = this.child("chkEnviada");
  this.iface.chkRecibida = this.child("chkRecibida");
  this.iface.chkAnulada = this.child("chkAnulada");
  this.iface.chkTodas = this.child("chkTodas");
  this.iface.tdbRecords = this.child("tableDBRecords");
  this.iface.pbnGenerarPedido = this.child("pbnGenerarPedido");

  connect(this.child("toolButtonPrint"), "clicked()", this, "iface.imprimir");
  connect(this.child("tbnOferta"), "clicked()", this, "iface.filtroProcedencia()");
  connect(this.child("gbnOfertas"), "clicked(int)", this, "iface.refrescarFiltro()");
  connect(this.child("tbnIntroduccionDatos"), "clicked()", this, "iface.introduccionDatos_clicked()");
  connect(this.iface.pbnGenerarPedido, "clicked()", this, "iface.generarPedido_clicked");

  if (this.iface.chkPendiente)
    connect(this.iface.chkPendiente, "clicked()", this, "iface.filtroEstado()");
  if (this.iface.chkEnviada)
    connect(this.iface.chkEnviada, "clicked()", this, "iface.filtroEstado()");
  if (this.iface.chkRecibida)
    connect(this.iface.chkRecibida, "clicked()", this, "iface.filtroEstado()");
  if (this.iface.chkAnulada)
    connect(this.iface.chkAnulada, "clicked()", this, "iface.filtroEstado()");
  if (this.iface.chkTodas)
    connect(this.iface.chkTodas, "clicked()", this, "iface.filtroEstado()");

  this.iface.tipoInsercion_ = false;
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
/** \C
Al pulsar el botón imprimir se lanzará el informe correspondiente a la oferta seleccionada (en caso de que el módulo de informes esté cargado)
\end */
function oficial_imprimir(codPresupuesto: String)
{
  if (sys.isLoadedModule("flfactinfo")) {
    var codigo: String;
    if (codPresupuesto) {
      codigo = codPresupuesto;
    } else {
      if (!this.cursor().isValid())
        return;
      codigo = this.cursor().valueBuffer("codigo");
    }
    var curImprimir: FLSqlCursor = new FLSqlCursor("i_presupuestosprov");
    curImprimir.setModeAccess(curImprimir.Insert);
    curImprimir.refreshBuffer();
    curImprimir.setValueBuffer("descripcion", "temp");
    curImprimir.setValueBuffer("d_presupuestosprov_codigo", codigo);
    curImprimir.setValueBuffer("h_presupuestosprov_codigo", codigo);
    flfactinfo.iface.pub_lanzarInforme(curImprimir, "i_presupuestosprov");
  } else
    flfactppal.iface.pub_msgNoDisponible("Informes");
}

function oficial_filtrarTabla()
{
  var filtro: String = "";
  if (this.iface.filtroProcedencia_ && this.iface.filtroProcedencia_ != "") {
    filtro = this.iface.filtroProcedencia_;
  }
  if (this.iface.filtroEstado_ && this.iface.filtroEstado_ != "") {
    if (filtro != "")
      filtro += " AND ";
    filtro += this.iface.filtroEstado_;
  }
  if (!this.iface.filtroProcedencia_ && !this.iface.filtroEstado_) {
    filtro = "";
  }
  debug("FILTRO " + filtro);
  this.iface.tdbRecords.cursor().setMainFilter(filtro);
  this.iface.tdbRecords.refresh();
}

function oficial_filtroProcedencia()
{
  var util: FLUtil = new FLUtil();
  var cursor: FLSqlCursor = this.cursor();

  var opcion: Number = this.child("gbnOfertas").selectedId;
  switch (opcion) {
    case 0: {
      var proveedor: Object = new FLFormSearchDB("proveedores");
      var curProveedor: FLSqlCursor = proveedor.cursor();
      proveedor.setMainWidget();
      var codProveedor: String = proveedor.exec("codproveedor");
      if (codProveedor) {
        var nombre: String = util.sqlSelect("proveedores", "nombre", "codproveedor = '" + codProveedor + "'");
        this.child("txtValor").setText(codProveedor + ":  " + nombre);
      } else {
        this.child("txtValor").setText(this.iface.valor_);
      }
      this.iface.filtroProcedencia_ = "codproveedor = '" + codProveedor + "'";
      break;
    }
    case 1: {
      var presupuesto: Object = new FLFormSearchDB("presupuestoscli");
      var curPresupuesto: FLSqlCursor = presupuesto.cursor();
      presupuesto.setMainWidget();
      var codPresupuesto: String = presupuesto.exec("codigo");
      if (codPresupuesto) {
        this.child("txtValor").setText(codPresupuesto);
      } else {
        this.child("txtValor").setText(this.iface.valor_);
      }
      this.iface.filtroProcedencia_ = "codpresupuestocli = '" + codPresupuesto + "'";
      break;
    }
    case 2: {
      var articulo: Object = new FLFormSearchDB("articulos");
      //      var curPresupuesto:FLSqlCursor = articulo.cursor();
      articulo.setMainWidget();
      var referencia: String = articulo.exec("referencia");
      if (referencia) {
        this.child("txtValor").setText(referencia + ": " + util.sqlSelect("articulos", "descripcion", "referencia = '" + referencia + "'"));
      } else {
        this.child("txtValor").setText(this.iface.valor_);
      }
      this.iface.filtroProcedencia_ = "idpresupuesto IN (SELECT idpresupuesto FROM lineaspresupuestosprov WHERE referencia = '" + referencia + "')";
      break;
    }
  }
  this.iface.filtrarTabla();
}

function oficial_filtroEstado()
{
  var filtro: String = "";
  var listaEstados = "";

  if (this.iface.chkPendiente && this.iface.chkPendiente.checked)
    listaEstados += "'Pendiente'";

  if (this.iface.chkEnviada && this.iface.chkEnviada.checked) {
    if (listaEstados != "")
      listaEstados += ", ";
    listaEstados += "'Enviada'";
  }

  if (this.iface.chkRecibida && this.iface.chkRecibida.checked) {
    if (listaEstados != "")
      listaEstados += ", ";
    listaEstados += "'Recibida'";
  }

  if (this.iface.chkAnulada && this.iface.chkAnulada.checked) {
    if (listaEstados != "")
      listaEstados += ", ";
    listaEstados += "'Anulada'";
  }

  if (listaEstados != "") {
    filtro = "estado IN (" + listaEstados + ")";
  } /*else {
    filtro = "1 = 2";
  }*/

  this.iface.filtroEstado_ = filtro;
  this.iface.filtrarTabla();
}

function oficial_refrescarFiltro(opcion: Number)
{
  var util: FLUtil = new FLUtil();
  var cursor: FLSqlCursor = this.cursor();

  switch (opcion) {
    case 0: {
      this.iface.valor_ = util.translate("scripts", "Indique proveedor...");
      break;
    }
    case 1: {
      this.iface.valor_ = util.translate("scripts", "Indique presupuesto...");
      break;
    }
    case 2: {
      this.iface.valor_ = util.translate("scripts", "Indique artículo...");
      break;
    }
  }
  this.child("txtValor").setText(this.iface.valor_);
  this.iface.filtroProcedencia_ = "";
  this.iface.filtrarTabla();
}

function oficial_introduccionDatos_clicked()
{
  var cursor: FLSqlCursor = this.cursor();
  var util: FLUtil = new FLUtil();

  this.iface.tipoInsercion_ = "Precios";

  this.child("toolButtonEdit").animateClick();
  //  var curOferta:FLSqlCursor = this.iface.tdbRecords.cursor();
  //  var codPresupuesto:String = util.sqlSelect("presupuestosprov", "codigo", "idpresupuesto = " + curOferta.valueBuffer("idpresupuesto"));
  //
  //  if (!this.iface.introduccionDatos(codPresupuesto))
  //    return;
  //
  //  this.iface.tdbRecords.refresh();
}

// function oficial_introduccionDatos(codPresupuesto:String):Boolean
// {
//  var util:FLUtil = new FLUtil();
//  util.sqlDelete("datosofertaprov", "usuario = '" + sys.nameUser() + "'");
//
//  var f:Object = new FLFormSearchDB("datosofertaprov");
//  var curDatos:FLSqlCursor = f.cursor();
//  curDatos.setModeAccess(curDatos.Insert);
//  curDatos.refreshBuffer();
//  curDatos.setValueBuffer("usuario", sys.nameUser());
//
//  var idPresupuesto:String = util.sqlSelect("presupuestosprov", "idpresupuesto", "codigo = '" + codPresupuesto + "'");
//  curDatos.setValueBuffer("idpresupuestoprov", idPresupuesto);
//  curDatos.setValueBuffer("codpresupuestoprov", codPresupuesto);
//  var codProveedor:String = util.sqlSelect("presupuestosprov", "codproveedor", "codigo = '" + codPresupuesto + "'");
//  if (codProveedor)
//    curDatos.setValueBuffer("codproveedor", codProveedor);
//
//  if (!curDatos.commitBuffer())
//    return false;;
//
//  curDatos.select("usuario = '" + sys.nameUser() + "'");
//  if (!curDatos.first())
//    return false;
//
//  curDatos.setModeAccess(curDatos.Edit);
//  curDatos.refreshBuffer();
//
//  f.setMainWidget();
//  curDatos.refreshBuffer();
//  var acpt:String = f.exec("usuario");
//  if (!acpt)
//    return false;
//
//  var idBuffer:String = curDatos.valueBuffer("id");
//  curDatos.commitBuffer();
//  curDatos.select("id = " + idBuffer);
//  if (!curDatos.first())
//    return false;
//
//  curDatos.setModeAccess(curDatos.Browse);
//  curDatos.refreshBuffer();
//
//  curDatos.transaction(false);
//  try {
//    if (this.iface.generarLineas(curDatos)) {
//      curDatos.commit();
//    } else {
//      curDatos.rollback();
//    }
//  }
//  catch (e) {
//    curDatos.rollback();
//    MessageBox.critical(util.translate("scripts", "Hubo un error en la generación de las líneas:\n%1").arg(e), MessageBox.Ok, MessageBox.NoButton);
//  }
//  return true;
// }

// function oficial_generarLineas(curDatos:FLSqlCursor):Boolean
// {
//  var util:FLUtil = new FLUtil;
//
//  var cursor:FLSqlCursor = this.cursor();
//  var codProveedor:String = cursor.valueBuffer("codproveedor");
//  var contenido:String = curDatos.valueBuffer("datos");
//  var docXML:FLDomDocument = new FLDomDocument;
//  if (!docXML.setContent(contenido)) {
//    return false;
//  }
//
//  var listaXMLLineas:FLDomNodeList = docXML.firstChild().childNodes();
//  var xmlLinea:FLDomElement;
//  for (var i:Number = 0; i < listaXMLLineas.length(); i++) {
//    xmlLinea = listaXMLLineas.item(i).toElement();
//    var curLineasOferta:FLSqlCursor = new FLSqlCursor("lineaspresupuestosprov");
//    curLineasOferta.select("idlinea = " + xmlLinea.attribute("IdLinea"));
//    if (!curLineasOferta.first())
//      return false;
//    curLineasOferta.setModeAccess(curLineasOferta.Edit);
//    curLineasOferta.refreshBuffer();
//
//    curLineasOferta.setValueBuffer("pvpunitario", xmlLinea.attribute("Coste"));
//    curLineasOferta.setValueBuffer("dto", xmlLinea.attribute("Dto"));
//    curLineasOferta.setValueBuffer("plazo", xmlLinea.attribute("Plazo"));
//
//    if (!curLineasOferta.commitBuffer())
//      return false;
//
//    if (curDatos.valueBuffer("actualizarprov") == true) {
//      if (!this.iface.actualizarArticulosProv(xmlLinea, codProveedor))
//        return false;
//    }
//  }
//
//  return true;
// }

// function oficial_actualizarArticulosProv(xmlLinea:FLDomElement, codProveedor:String):Boolean
// {
//  var util:FLUtil = new FLUtil();
//  var nombreProveedor:String = util.sqlSelect("proveedores", "nombre", "codproveedor = '" + codProveedor + "'");
//  var curArticulosProv:FLSqlCursor = new FLSqlCursor("articulosprov");
//  curArticulosProv.select("referencia = '" + xmlLinea.attribute("Referencia") + "' AND codproveedor = '" + codProveedor + "'");
//  if (!curArticulosProv.first()) {
//    curArticulosProv.setModeAccess(curArticulosProv.Insert);
//    curArticulosProv.refreshBuffer();
//
//    curArticulosProv.setValueBuffer("referencia", xmlLinea.attribute("Referencia"));
//    curArticulosProv.setValueBuffer("codproveedor", codProveedor);
//    curArticulosProv.setValueBuffer("nombre", nombreProveedor);
//    curArticulosProv.setValueBuffer("coste", xmlLinea.attribute("Coste"));
//    curArticulosProv.setValueBuffer("dto", xmlLinea.attribute("Dto"));
//    curArticulosProv.setValueBuffer("plazo", xmlLinea.attribute("Plazo"));
//    curArticulosProv.setValueBuffer("coddivisa", "EUR");
//
//    if (!curArticulosProv.commitBuffer())
//      return false;
//  }
//  curArticulosProv.setModeAccess(curArticulosProv.Edit);
//  curArticulosProv.refreshBuffer();
//
//  curArticulosProv.setValueBuffer("coste", xmlLinea.attribute("Coste"));
//  curArticulosProv.setValueBuffer("dto", xmlLinea.attribute("Dto"));
//  curArticulosProv.setValueBuffer("plazo", xmlLinea.attribute("Plazo"));
//
//  if (!curArticulosProv.commitBuffer())
//    return false;
//
//  return true;
// }

function oficial_commonCalculateField(fN: String, cursor: FLSqlCursor): String {
  var util: FLUtil = new FLUtil();
  var valor: String;

  switch (fN)
  {
      /** \C
      El --código-- se construye como la concatenación de --codserie--, --codejercicio-- y --numero--
      \end */
    case "codigo": {
      valor = flfacturac.iface.pub_construirCodigo(cursor.valueBuffer("codserie"), cursor.valueBuffer("codejercicio"), cursor.valueBuffer("numero"));
      break;
    }
  }
  return valor;
}

function oficial_generarPedido_clicked()
{
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  cursor.transaction(false);
  try {
    if (this.iface.generarPedido(cursor))
      cursor.commit();
    else
      cursor.rollback();
  } catch (e) {
    cursor.rollback();
    MessageBox.critical(util.translate("scripts", "Hubo un error en la generación del pedido:") + "\n" + e, MessageBox.Ok, MessageBox.NoButton);
  }
  this.iface.tdbRecords.refresh();
}

function oficial_generarPedido(curPresupuesto: FLSqlCursor): Number {
  var util: FLUtil;

  var idPresupuesto: String = curPresupuesto.valueBuffer("idpresupuesto");
  if (!idPresupuesto)
    return false;

  if (curPresupuesto.valueBuffer("estado") != "Recibida")
  {
    MessageBox.warning(util.translate("scripts", "Para poder generar el pedido la oferta debe estar en estado Recibida."), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }

  if (!util.sqlSelect("lineaspresupuestosprov", "idlinea", "idpresupuesto = " + idPresupuesto + " AND aprobado"))
  {
    MessageBox.warning(util.translate("scripts", "La oferta seleccionada no contiene ninguna línea aprobada."), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }

  if (!this.iface.curPedido)
    this.iface.curPedido = new FLSqlCursor("pedidosprov");

  this.iface.curPedido.setModeAccess(this.iface.curPedido.Insert);
  this.iface.curPedido.refreshBuffer();
  this.iface.curPedido.setValueBuffer("idpresupuesto", idPresupuesto);

  if (!this.iface.datosPedido(curPresupuesto))
    return false;

  if (!this.iface.curPedido.commitBuffer())
    return false;

  var idPedido: Number = this.iface.curPedido.valueBuffer("idpedido");

  if (!this.iface.copiaLineas(idPresupuesto, idPedido))
    return false;

  this.iface.curPedido.select("idpedido = " + idPedido);
  if (this.iface.curPedido.first())
  {
    this.iface.curPedido.setModeAccess(this.iface.curPedido.Edit);
    this.iface.curPedido.refreshBuffer();

    if (!this.iface.totalesPedido())
      return false;

    if (this.iface.curPedido.commitBuffer() == false)
      return false;
  }

  return idPedido;
}

/** \D Informa los datos de un pedido a partir de los de un presupuesto
@param  curPresupuesto: Cursor que contiene los datos a incluir en el pedido
@return True si el cálculo se realiza correctamente, false en caso contrario
\end */
function oficial_datosPedido(curPresupuesto: FLSqlCursor): Boolean {
  var util: FLUtil;

  var hoy: Date = new Date();
  var fecha: String = hoy.toString();

  var codEjercicio: String = curPresupuesto.valueBuffer("codejercicio");

  var datosDoc: Array = flfacturac.iface.pub_datosDocFacturacion(fecha, codEjercicio, "pedidosprov");
  if (!datosDoc.ok)
    return false;
  if (datosDoc.modificaciones == true)
  {
    codEjercicio = datosDoc.codEjercicio;
    fecha = datosDoc.fecha;
  }

  var codProveedor: String = curPresupuesto.valueBuffer("codproveedor");
  var cifNif: String = util.sqlSelect("proveedores", "cifnif", "codproveedor = '" + codProveedor + "'");
  var codPago: String = util.sqlSelect("proveedores", "codpago", "codproveedor = '" + codProveedor + "'");
  if (!codPago || codPago == "")
    codPago = flfactppal.iface.pub_valorDefectoEmpresa("codpago");
  var codDivisa: String = util.sqlSelect("proveedores", "coddivisa", "codproveedor = '" + codProveedor + "'");
  if (!codDivisa || codDivisa == "")
    codDivisa = flfactppal.iface.pub_valorDefectoEmpresa("coddivisa");
  var tasaConv: Number = util.sqlSelect("divisas", "tasaconv", "coddivisa = '" + codDivisa + "'");

  with(this.iface.curPedido)
  {
    setValueBuffer("codserie", curPresupuesto.valueBuffer("codserie"));
    setValueBuffer("codejercicio", codEjercicio);
    setValueBuffer("irpf", curPresupuesto.valueBuffer("irpf"));
    setValueBuffer("fecha", fecha);
    setValueBuffer("codalmacen", flfactppal.iface.pub_valorDefectoEmpresa("codalmacen"));
    setValueBuffer("codpago", codPago);
    setValueBuffer("coddivisa", codDivisa);
    setValueBuffer("tasaconv", tasaConv);
    setValueBuffer("codproveedor", codProveedor);
    setValueBuffer("cifnif", cifNif);
    setValueBuffer("nombre", curPresupuesto.valueBuffer("nombre"));
    setValueBuffer("recfinanciero", 0);
    setValueBuffer("observaciones", curPresupuesto.valueBuffer("observaciones"));
  }

  return true;
}

/** \D
Copia las líneas de un pedido como líneas de su albarán asociado
@param idPresupuesto: Identificador del pedido
@param idPedido: Identificador del pedido
\end */
function oficial_copiaLineas(idPresupuesto: Number, idPedido: Number): Boolean {
  var curLineaPresupuesto: FLSqlCursor = new FLSqlCursor("lineaspresupuestosprov");
  curLineaPresupuesto.select("idpresupuesto = " + idPresupuesto + " AND aprobado");
  while (curLineaPresupuesto.next())
  {
    curLineaPresupuesto.setModeAccess(curLineaPresupuesto.Browse);
    curLineaPresupuesto.refreshBuffer();
    if (!this.iface.copiaLineaPresupuesto(curLineaPresupuesto, idPedido))
      return false;
  }
  return true;
}

function oficial_copiaLineaPresupuesto(curLineaPresupuesto: FLSqlCursor, idPedido: Number): Number {
  if (!this.iface.curLineaPedido)
    this.iface.curLineaPedido = new FLSqlCursor("lineaspedidosprov");

  with(this.iface.curLineaPedido)
  {
    setModeAccess(Insert);
    refreshBuffer();
    setValueBuffer("idpedido", idPedido);
  }

  if (!this.iface.datosLineaPedido(curLineaPresupuesto))
    return false;

  if (!this.iface.curLineaPedido.commitBuffer())
    return false;

  return this.iface.curLineaPedido.valueBuffer("idlinea");
}

/** \D Copia los datos de una línea de presupuesto en una línea de pedido
@param  curLineaPresupuesto: Cursor que contiene los datos a incluir en la línea de pedido
@return True si la copia se realiza correctamente, false en caso contrario
\end */
function oficial_datosLineaPedido(curLineaPresupuesto: FLSqlCursor): Boolean {
  var dto: Number = curLineaPresupuesto.valueBuffer("dto");
  with(this.iface.curLineaPedido)
  {
    setValueBuffer("idlineapresupuesto", curLineaPresupuesto.valueBuffer("idlinea"));
    setValueBuffer("pvpunitario", curLineaPresupuesto.valueBuffer("pvpunitario"));
    setValueBuffer("cantidad", curLineaPresupuesto.valueBuffer("cantidad"));
    setValueBuffer("referencia", curLineaPresupuesto.valueBuffer("referencia"));
    setValueBuffer("descripcion", curLineaPresupuesto.valueBuffer("descripcion"));
    if (dto)
      setValueBuffer("dtopor", dto);
    else
      setValueBuffer("dtopor", 0);
    setValueBuffer("codimpuesto", formRecordlineaspedidosprov.iface.pub_commonCalculateField("codimpuesto", this));
    setValueBuffer("iva", formRecordlineaspedidosprov.iface.pub_commonCalculateField("iva", this));
    setValueBuffer("recargo", formRecordlineaspedidosprov.iface.pub_commonCalculateField("recargo", this));
    setValueBuffer("irpf", formRecordlineaspedidosprov.iface.pub_commonCalculateField("irpf", this));
    setValueBuffer("pvpsindto", formRecordlineaspedidosprov.iface.pub_commonCalculateField("pvpsindto", this));
    setValueBuffer("pvptotal", formRecordlineaspedidosprov.iface.pub_commonCalculateField("pvptotal", this));
  }
  return true;
}

/** \D Informa los datos de un pedido referentes a totales (I.V.A., neto, etc.)
@return True si el cálculo se realiza correctamente, false en caso contrario
\end */
function oficial_totalesPedido(): Boolean {
  with(this.iface.curPedido)
  {
    setValueBuffer("neto", formpedidosprov.iface.pub_commonCalculateField("neto", this));
    setValueBuffer("totaliva", formpedidosprov.iface.pub_commonCalculateField("totaliva", this));
    setValueBuffer("totalirpf", formpedidosprov.iface.pub_commonCalculateField("totalirpf", this));
    setValueBuffer("totalrecargo", formpedidosprov.iface.pub_commonCalculateField("totalrecargo", this));
    setValueBuffer("total", formpedidoscli.iface.pub_commonCalculateField("total", this));
    setValueBuffer("totaleuros", formpedidosprov.iface.pub_commonCalculateField("totaleuros", this));
  }
  return true;
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////


/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
