/***************************************************************************
                 t1_principal.qs  -  description
                             -------------------
    begin                : lun sep 13 2010
    copyright            : (C) 2010 by InfoSiAL S.L.
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
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna
{
  ///
  //  var aCols; /// Array de columnas de la tabla
  var h_;
  var w_;
  var mgr_; // Manager BD
  var imgPath_;//
  var curObjetoActual_;

  const ftSTRING_ = 3;
  const ftUINT_ = 17;
  const ftDOUBLE_ = 19;
  const ftDATE_ = 26;
  const ftSERIAL_ = 100;
  const ftUNLOCK_ = 200;

  var xmlActions_, xmlSearch_;

  var CB_TIPO, CB_CLAVE, CB_ICONO, CB_DESC;
  var altoFilaBus_;

  /*
  var CR_IDREL: Number;
  var CR_TIPO: Number;
  var CR_CARD: Number;
  var CR_ICONO: Number;
  var CR_DESC: Number;
  var CR_CLAVEREL: Number;
  */
  /*
  var CER_IDREL: Number;
  var CER_TIPO: Number;
  var CER_CLAVE: Number;
  var CER_ICONO: Number;
  var CER_DES: Number;
  */
  var tblElementosBus_;
  /*
  var tblAcciones_: FLTable;
  var tblAccionesRel_: FLTable;
  var tblRelaciones_: FLTable;
  var tblElementosRel_: FLTable;
  var tdbTabla_: FLTableDB;

  var xAcciones_: Number; /// Número de acciones que caben en una fila de la tabla acciones
  var aAcciones_: Number; /// Array con las acciones asociadas al elemento actual
  var aAccionesRel_: Number; /// Array con las acciones asociadas al elemento relacionado que el usuario tiene seleccionado
  var aRelaciones_: Number; /// Array con las relaciones asociadas al elemento actual
  /// var aElementosRel_:Number; /// Array con los elementos de la relación seleccionada
  */
  var aHistorialElementos_, iElementoHistorial_, xmlElemento_, picElemento_;
  var curObjeto_;
  var curElemento_: FLSqlCursor; /// Cursor posicionado en el elemento actual
  var aElementos_: Array; /// Array que almacena los datos asociados a los tipos de elementos (icono, xml de su picture, etc).
  var aIndiceElementos_: Array; /// Array ordenado para recorrer la lista de elementos.
  var aDatosElemento_: Array; /// Array que almacena los datos del elemento actual
  //  var aIndiceDE_:Array;
  //  var f_: Object;
  //  var posF_: Point;
  //  var sizeF_: Size;
  var idUsuario_, idGrupo_;
  function oficial(context)
  {
    interna(context);
  }
  function iniciarTablas()
  {
    return this.ctx.oficial_iniciarTablas();
  }
  function accelActivated(iAccel)
  {
    return this.ctx.oficial_accelActivated(iAccel);
  }
  /*
  function revisarBD()
  {
    return this.ctx.oficial_revisarBD();
  }
  function dameDatosRelFacturasCli(aDatos: Array, where: String)
  {
    return this.ctx.oficial_dameDatosRelFacturasCli(aDatos, where);
  }
  function dameDatosRelAlbaranesCli(aDatos: Array, where: String)
  {
    return this.ctx.oficial_dameDatosRelAlbaranesCli(aDatos, where);
  }
  function dameDatosRelPedidosCli(aDatos: Array, where: String)
  {
    return this.ctx.oficial_dameDatosRelPedidosCli(aDatos, where);
  }
  function dameDatosRelPresupuestosCli(aDatos: Array, where: String)
  {
    return this.ctx.oficial_dameDatosRelPresupuestosCli(aDatos, where);
  }
    */
  function iniciarTblElementosBus()
  {
    return this.ctx.oficial_iniciarTblElementosBus();
  }
  /*
  function iniciarTblAcciones()
  {
    return this.ctx.oficial_iniciarTblAcciones();
  }
  function iniciarTblAccionesRel()
  {
    return this.ctx.oficial_iniciarTblAccionesRel();
  }
  function iniciarTblRelaciones()
  {
    return this.ctx.oficial_iniciarTblRelaciones();
  }
  function iniciarTblElementosRel()
  {
    return this.ctx.oficial_iniciarTblElementosRel();
  }
  */
  function tbnBuscar_clicked()
  {
    return this.ctx.oficial_tbnBuscar_clicked();
  }
  function buscar(cadena)
  {
    return this.ctx.oficial_buscar(cadena);
  }
  function buscarElementos(cadena)
  {
    return this.ctx.oficial_buscarElementos(cadena);
  }
  function cambiaModo(modo)
  {
    return this.ctx.oficial_cambiaModo(modo);
  }
  /*
  function buscarClientes(cadena: String)
  {
    return this.ctx.oficial_buscarClientes(cadena);
  }
  function buscarContactos(cadena: String)
  {
    return this.ctx.oficial_buscarContactos(cadena);
  }
  function buscarAgentes(cadena: String)
  {
    return this.ctx.oficial_buscarAgentes(cadena);
  }
  */
  function muestraElementoActual()
  {
    return this.ctx.oficial_muestraElementoActual();
  }
  function newObject(clase, p1, p2)
  {
    return this.ctx.oficial_newObject(clase, p1, p2);
  }
  function actualizaDatosForm()
  {
    return this.ctx.oficial_actualizaDatosForm();
  }
  function muestraDashboard()
  {
    return this.ctx.oficial_muestraDashboard();
  }
  function cargaWidgetsDB(accion, idWidget)
  {
    return this.ctx.oficial_cargaWidgetsDB(accion, idWidget);
  }
  function cargaWidgetsDB2(accion, idWidget)
  {
    return this.ctx.oficial_cargaWidgetsDB2(accion, idWidget);
  }
  function cargaWidgetDashboard(w, n)
  {
    return this.ctx.oficial_cargaWidgetDashboard(w, n);
  }
  function borraWidgetsDashboard()
  {
    return this.ctx.oficial_borraWidgetsDashboard();
  }
  /*
  function muestraAcciones()
  {
    return this.ctx.oficial_muestraAcciones();
  }
  function muestraAccionesRel()
  {
    return this.ctx.oficial_muestraAccionesRel();
  }
  function muestraRelaciones()
  {
    return this.ctx.oficial_muestraRelaciones();
  }
  */
  function dameElementoActual()
  {
    return this.ctx.oficial_dameElementoActual();
  }
  function llamaFuncionCursor(nombreF, cur_)
  {
    return this.ctx.oficial_llamaFuncionCursor(nombreF, cur_);
  }

  function cargaAcciones()
  {
    return this.ctx.oficial_cargaAcciones();
  }
  function ponAccion(name, icon, title)
  {
    return this.ctx.oficial_ponAccion(name, icon, title);
  }
  function ponMetodo(action, name, f, icon, alias, iconMethod)
  {
    return this.ctx.oficial_ponMetodo(action, name, f, icon, alias, iconMethod);
  }
  function ponRelacion(action, relAction, join)
  {
    return this.ctx.oficial_ponRelacion(action, relAction, join);
  }
  function eliminarAccels()
  {
    return this.ctx.oficial_eliminarAccels();
  }
  function ponElementoActual(tipo, clave)
  {
    return this.ctx.oficial_ponElementoActual(tipo, clave);
  }
  function guardaElementoHistorial(tipo, clave)
  {
    return this.ctx.oficial_guardaElementoHistorial(tipo, clave);
  }
  function tblElementosBus_clicked(fil, col)
  {
    return this.ctx.oficial_tblElementosBus_clicked(fil, col);
  }
  /*
  function tblAcciones_clicked(fila: Number, col: Number)
  {
    return this.ctx.oficial_tblAcciones_clicked(fila, col);
  }
  function tblAccionesRel_clicked(fila: Number, col: Number)
  {
    return this.ctx.oficial_tblAccionesRel_clicked(fila, col);
  }
  function lanzaAccion(indice)
  {
    return this.ctx.oficial_lanzaAccion(indice);
  }
  function lanzaAccionRel(indice: Number)
  {
    return this.ctx.oficial_lanzaAccionRel(indice);
  }
  function tblRelaciones_clicked(fila: Number, col: Number)
  {
    return this.ctx.oficial_tblRelaciones_clicked(fila, col);
  }
  function tblElementosRel_clicked(fila: Number, col: Number)
  {
    return this.ctx.oficial_tblElementosRel_clicked(fila, col);
  }
  */
  function tbnHome_clicked()
  {
    return this.ctx.oficial_tbnHome_clicked();
  }
  /*
  function muestraElementosRel(tipo: String, clave: String, iRel: Number)
  {
    return this.ctx.oficial_muestraElementosRel(tipo, clave, iRel);
  }
  function dameNombreElemento(tipo: String, clave: String)
  {
    return this.ctx.oficial_dameNombreElemento(tipo, clave);
  }
  function componTextoRel(textoBase: String, aDatos: Array)
  {
    return this.ctx.oficial_componTextoRel(textoBase, aDatos);
  }
  function borrarForm()
  {
    return this.ctx.oficial_borrarForm();
  }
  function dameFiltroPrincipal(clausulaWhere: String, clave: String)
  {
    return this.ctx.oficial_dameFiltroPrincipal(clausulaWhere, clave);
  }
  function cargaDatosElemento(tipo: String, clave: String)
  {
    return this.ctx.oficial_cargaDatosElemento(tipo, clave);
  }
  function dameTablaElemento(tipo: String)
  {
    return this.ctx.oficial_dameTablaElemento(tipo);
  }
  function cargaCampoArrayDE(campo: String, valor)
  {
    return this.ctx.oficial_cargaCampoArrayDE(campo, valor);
  }
  function cargaValorCamposTabla(tabla: String, where: String)
  {
    return this.ctx.oficial_cargaValorCamposTabla(tabla, where);
  }
  function dameValorCamposTabla(tabla: String, clave: String)
  {
    return this.ctx.oficial_dameValorCamposTabla(tabla, clave);
  }
  function dameArrayCamposElementoRel(tipo: String, relacion: String)
  {
    return this.ctx.oficial_dameArrayCamposElementoRel(tipo, relacion);
  }
  */  function cargaSvgElemento(tipo: String, aDatos: Array)
  {
    return this.ctx.oficial_cargaSvgElemento(tipo, aDatos);
  }
  function dibujaTextoSvg(x: Number, y: Number, texto: String, idEstilo: String)
  {
    return this.ctx.oficial_dibujaTextoSvg(x, y, texto, idEstilo);
  }
  /*
  function generarFacturaCli(tipo: String, clave: String)
  {
    return this.ctx.oficial_generarFacturaCli(tipo, clave);
  }
  function imprimirDocumento(tipo: String, clave: String)
  {
    return this.ctx.oficial_imprimirDocumento(tipo, clave);
  }
  function aprobarPresupuestoCli(tipo: String, clave: String)
  {
    return this.ctx.oficial_aprobarPresupuestoCli(tipo, clave);
  }
  function servirPedidoCli(tipo: String, clave: String)
  {
    return this.ctx.oficial_servirPedidoCli(tipo, clave);
  }
  function facturarAlbaranCli(tipo: String, clave: String)
  {
    return this.ctx.oficial_facturarAlbaranCli(tipo, clave);
  }
  function generarPresupuestoCli(tipo: String, clave: String)
  {
    return this.ctx.oficial_generarPresupuestoCli(tipo, clave);
  }
  function generarPedidoCli(tipo: String, clave: String)
  {
    return this.ctx.oficial_generarPedidoCli(tipo, clave);
  }
  function generarAlbaranCli(tipo: String, clave: String)
  {
    return this.ctx.oficial_generarAlbaranCli(tipo, clave);
  }
  */
  function tbnElementoSiguiente_clicked()
  {
    return this.ctx.oficial_tbnElementoSiguiente_clicked();
  }
  /*
  function tbnElemento_clicked()
  {
    return this.ctx.oficial_tbnElemento_clicked();
  }
  */
  function tbnElementoPrevio_clicked()
  {
    return this.ctx.oficial_tbnElementoPrevio_clicked();
  }
  /*
  function dibujarIconoTabla(tabla: String, fila: Number, col: Number, tipo: String)
  {
    return this.ctx.oficial_dibujarIconoTabla(tabla, fila, col, tipo);
  }
  function dibujaPixmapRel(tabla: FLTable, fila: Number, col: Number, aDatos: Array, iRel: Number)
  {
    return this.ctx.oficial_dibujaPixmapRel(tabla, fila, col, aDatos, iRel);
  }
  function dibujaPixmapElementoRel(tabla: FLTable, fila: Number, col: Number, aDatos: Array, iRel: Number)
  {
    return this.ctx.oficial_dibujaPixmapElementoRel(tabla, fila, col, aDatos, iRel);
  }
  function dibujaElemento(tipo: String, clave: String): Picture {
    return this.ctx.oficial_dibujaElemento(tipo, clave);
  }
  //  function cargaPicElemento(pic:Picture, tipo:String) {
  //    return this.ctx.oficial_cargaPicElemento(pic, tipo);
  //  }
  function dibujaPicture(pic: Picture, xmlPic: FLDomDocument, pixSize: Size, aDatos: Array)
  {
    return this.ctx.oficial_dibujaPicture(pic, xmlPic, pixSize, aDatos);
  }
  function damePicElementoDefecto(tipo: String)
  {
    return this.ctx.oficial_damePicElementoDefecto(tipo);
  }
  function damePicRelacionDefecto(iRel: Number)
  {
    return this.ctx.oficial_damePicRelacionDefecto(iRel);
  }
  function damePicElementoRelDefecto(iRel: Number)
  {
    return this.ctx.oficial_damePicElementoRelDefecto(iRel);
  }
  function dibujaTextoPic(r: Rect, texto: String, estilo: String, pic: Picture, alineacion: Number)
  {
    return this.ctx.oficial_dibujaTextoPic(r, texto, estilo, pic, alineacion);
  }
  */
  //  function cargaXMLElemento(tipo:String, clave:String) {
  //    return this.ctx.oficial_cargaXMLElemento(tipo, clave);
  //  }
  /*
  function muestraElemento(tipo: String, clave: String)
  {
    return this.ctx.oficial_muestraElemento(tipo, clave);
  }
  function refrescaRelacion(nombre: String)
  {
    return this.ctx.oficial_refrescaRelacion(nombre);
  }
  function dameIndiceRelacion(nombre: String)
  {
    return this.ctx.oficial_dameIndiceRelacion(nombre);
  }
  function dameFilaRelacion(nombre: String)
  {
    return this.ctx.oficial_dameFilaRelacion(nombre);
  }
  */
  function dameFuente(family, size)
  {
    return this.ctx.oficial_dameFuente(family, size);
  }
  function dameColor(color)
  {
    return this.ctx.oficial_dameColor(color);
  }
  function bufferChanged(fN)
  {
    return this.ctx.oficial_bufferChanged(fN);
  }
  /*
  function editarElementoSel()
  {
    return this.ctx.oficial_editarElementoSel();
  }
  function editarElemento(tipo: String, clave: String)
  {
    return this.ctx.oficial_editarElemento(tipo, clave);
  }
  function cargaElementos()
  {
    return this.ctx.oficial_cargaElementos();
  }
  function recargaElementoActual()
  {
    return this.ctx.oficial_recargaElementoActual();
  }
  function tbnEditaElemento_clicked()
  {
    return this.ctx.oficial_tbnEditaElemento_clicked();
  }
  function tbnEditaElementoUG_clicked()
  {
    return this.ctx.oficial_tbnEditaElementoUG_clicked();
  }
  function tbnEditaRelacionUG_clicked()
  {
    return this.ctx.oficial_tbnEditaRelacionUG_clicked();
  }
  function tbnEditaRelacion_clicked()
  {
    return this.ctx.oficial_tbnEditaRelacion_clicked();
  }
  function recargaPicElementos()
  {
    return this.ctx.oficial_recargaPicElementos();
  }
  function refrescaPicRelacion()
  {
    return this.ctx.oficial_refrescaPicRelacion();
  }
  function refrescaPicElementoRel()
  {
    return this.ctx.oficial_refrescaPicElementoRel();
  }
  function recargaPicRelacion(iRel: Number)
  {
    return this.ctx.oficial_recargaPicRelacion(iRel);
  }
  function recargaPicElementoRel(iRel: Number)
  {
    return this.ctx.oficial_recargaPicElementoRel(iRel);
  }
  function dameColorFila()
  {
    return this.ctx.oficial_dameColorFila();
  }
  */
  function cargaUsuarioYGrupo()
  {
    return this.ctx.oficial_cargaUsuarioYGrupo();
  }
  function tbnRecargar_clicked()
  {
    return this.ctx.oficial_tbnRecargar_clicked();
  }
  /*
  function pbnMR_clicked()
  {
    return this.ctx.oficial_pbnMR_clicked();
  }
  */
  function tbnIncluirRel_clicked()
  {
    return this.ctx.oficial_tbnIncluirRel_clicked();
  }
  function tbnGuardaAcciones_clicked()
  {
    return this.ctx.oficial_tbnGuardaAcciones_clicked();
  }
  function tbnCargaAcciones_clicked()
  {
    return this.ctx.oficial_tbnCargaAcciones_clicked();
  }
  function tbnGuardaCatalogoDB_clicked()
  {
    return this.ctx.oficial_tbnGuardaCatalogoDB_clicked();
  }
  function tbnCargaCatalogoDB_clicked()
  {
    return this.ctx.oficial_tbnCargaCatalogoDB_clicked();
  }
  function tbnGuardaBusqueda_clicked()
  {
    return this.ctx.oficial_tbnGuardaBusqueda_clicked();
  }
  function tbnCargaBusqueda_clicked()
  {
    return this.ctx.oficial_tbnCargaBusqueda_clicked();
  }
  function tbnAddWidget_clicked()
  {
    return this.ctx.oficial_tbnAddWidget_clicked();
  }
  function nuevoMethodSet()
  {
    return this.ctx.oficial_nuevoMethodSet();
  }
  function nuevo2DChart()
  {
    return this.ctx.oficial_nuevo2DChart();
  }
  function nuevoFastFields()
  {
    return this.ctx.oficial_nuevoFastFields();
  }
  function nuevoFastTable()
  {
    return this.ctx.oficial_nuevoFastTable();
  }
  function nuevoFastTable2()
  {
    return this.ctx.oficial_nuevoFastTable2();
  }
  function nuevoMethodSet2()
  {
    return this.ctx.oficial_nuevoMethodSet2();
  }
  function selCamposTablas(arrayTablas)
  {
    return this.ctx.oficial_selCamposTablas(arrayTablas);
  }
  function selMetodosTablas(arrayTablas)
  {
    return this.ctx.oficial_selMetodosTablas(arrayTablas);
  }
  function dameElementoXML(nodoPadre, ruta, debeExistir)
  {
    return this.ctx.oficial_dameElementoXML(nodoPadre, ruta, debeExistir);
  }
  function dameNodoXML(nodoPadre, ruta, debeExistir)
  {
    return this.ctx.oficial_dameNodoXML(nodoPadre, ruta, debeExistir);
  }
  function creaXMLActions()
  {
    return this.ctx.oficial_creaXMLActions();
  }
  function creaXMLSearch()
  {
    return this.ctx.oficial_creaXMLSearch();
  }
  function saveAsDashboardWidget(accion, nombre, xmlElemento, codCatalogo)
  {
    return this.ctx.oficial_saveAsDashboardWidget(accion, nombre, xmlElemento, codCatalogo);
  }
  function eventFilter(o, e)
  {
    return this.ctx.oficial_eventFilter(o, e);
  }
  function editarCursor(tabla, id)
  {
    return this.ctx.oficial_editarCursor(tabla, id);
  }
  function imprimirDoc(tabla, id)
  {
    return this.ctx.oficial_imprimirDoc(tabla, id);
  }
  function tbnConfigBus_clicked()
  {
    return this.ctx.oficial_tbnConfigBus_clicked();
  }
  function mtdNuevoCliente(curOrigen)
  {
    return this.ctx.oficial_mtdNuevoCliente(curOrigen);
  }
  function valoresChartFacturasCli(xGD, xParam)
  {
    return this.ctx.oficial_valoresChartFacturasCli(xGD, xParam);
  }
  function valoresChartHorasUsuario(xGD, xParam)
  {
    return this.ctx.oficial_valoresChartHorasUsuario(xGD, xParam);
  }
  function buscaElementoArray(e, a)
  {
    return this.ctx.oficial_buscaElementoArray(e, a);
  }
  function clientes_enviarEmail(curId, tabla)
  {
    return this.ctx.oficial_clientes_enviarEmail(curId, tabla);
  }
  function dameMailTo(cuerpo, asunto, arrayDest, arrayAttach)
  {
    return this.ctx.oficial_dameMailTo(cuerpo, asunto, arrayDest, arrayAttach);
  }
  function dameCursorObjeto(curId, tabla)
  {
    return this.ctx.oficial_dameCursorObjeto(curId, tabla);
  }
  function cargaConfigFastTable(accion, accionRel, xmlUW)
  {
    return this.ctx.oficial_cargaConfigFastTable(accion, accionRel, xmlUW);
  }
  function geoFastTable(accionRel, accion, xmlUW, q)
  {
    return this.ctx.oficial_geoFastTable(accionRel, accion, xmlUW, q);
  }
  function tituloFastTable(tabla, tablaRel, xmlUW)
  {
    return this.ctx.oficial_tituloFastTable(tabla, tablaRel, xmlUW);
  }
  function colsFastTable(tabla, tablaRel, xmlUW, q)
  {
    return this.ctx.oficial_colsFastTable(tabla, tablaRel, xmlUW, q);
  }
  function colFastTable()
  {
    return this.ctx.oficial_colFastTable();
  }
  function queryFastTable(tabla, tablaRel, xmlUW)
  {
    return this.ctx.oficial_queryFastTable(tabla, tablaRel, xmlUW);
  }
  function whereFastTable(tabla, tablaRel, xmlUW)
  {
    return this.ctx.oficial_whereFastTable(tabla, tablaRel, xmlUW);
  }
  function fromFastTable(tabla, tablaRel)
  {
    return this.ctx.oficial_fromFastTable(tabla, tablaRel);
  }
  function selectFastTable(tabla, tablaRel, xmlUW)
  {
    return this.ctx.oficial_selectFastTable(tabla, tablaRel, xmlUW);
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
  function pub_dameElementoActual()
  {
    return this.dameElementoActual();
  }
  /*
  function pub_dameIndiceRelacionPorRUG(idUG: Number)
  {
    return this.dameIndiceRelacionPorRUG(idUG);
  }
  function pub_dameIndiceRelacionPorR(idRel: Number)
  {
    return this.dameIndiceRelacionPorR(idRel);
  }
  */
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
  debug("interna_init")
  var util = new FLUtil;
  var _i = this.iface;

  _i.mgr_ = aqApp.db().manager();
  _i.imgPath_ = "/home/arodriguez/imagenes/imgsource/";
  _i.creaXMLActions();
  _i.creaXMLSearch();

  this.iface.cargaUsuarioYGrupo();

  var cursor = this.cursor();
  cursor.setModeAccess(cursor.Insert);
  cursor.refreshBuffer();

  //  this.iface.revisarBD();
  this.iface.iniciarTablas();
  //this.iface.pathImagenes = "/home/arodriguez/imagenes/icons";
  var fdbBuscar = this.child("fdbBuscar");

  connect(fdbBuscar, "activatedAccel( int )", this,  "iface.accelActivated()");
  connect(cursor, "bufferChanged(String)", this,  "iface.bufferChanged()");

  this.iface.aHistorialElementos_ = [];
  this.iface.iElementoHistorial_ = -1;

  connect(this.child("tbnBuscar"), "clicked()", this, "iface.tbnBuscar_clicked");
  connect(this.child("tbnElementoPrevio"), "clicked()", this, "iface.tbnElementoPrevio_clicked");
  //  connect(this.child("tbnElemento"), "clicked()", this, "iface.tbnElemento_clicked");
  connect(this.child("tbnElementoSiguiente"), "clicked()", this, "iface.tbnElementoSiguiente_clicked");
  //  connect(this.child("tbnCargarIconos"), "clicked()", this, "iface.tbnCargarIconos_clicked");
  //  connect(this.child("tbnEditaElemento"), "clicked()", this, "iface.tbnEditaElemento_clicked");
  //  connect(this.child("tbnEditaElementoUG"), "clicked()", this, "iface.tbnEditaElementoUG_clicked");
  //  connect(this.child("tbnEditaRelacionUG"), "clicked()", this, "iface.tbnEditaRelacionUG_clicked");
  //  connect(this.child("tbnEditaRelacion"), "clicked()", this, "iface.tbnEditaRelacion_clicked");
  //  connect(this.child("tbnDrillDown"), "clicked()", this, "iface.tblElementosRel_clicked");
  connect(this.child("tbnHome"), "clicked()", this, "iface.tbnHome_clicked");
  connect(this.child("tbnRecargar"), "clicked()", this, "iface.tbnRecargar_clicked");

  connect(this, "closed()", _i, "borraWidgetsDashboard");

  connect(this.child("tbnIncluirRel"), "clicked()", _i, "tbnIncluirRel_clicked");
  connect(this.child("tbnGuardaAcciones"), "clicked()", _i, "tbnGuardaAcciones_clicked");
  connect(this.child("tbnCargaAcciones"), "clicked()", _i, "tbnCargaAcciones_clicked");
  connect(this.child("tbnGuardaCatalogoDB"), "clicked()", _i, "tbnGuardaCatalogoDB_clicked");
  connect(this.child("tbnCargaCatalogoDB"), "clicked()", _i, "tbnCargaCatalogoDB_clicked");
  connect(this.child("tbnGuardaBusqueda"), "clicked()", _i, "tbnGuardaBusqueda_clicked");
  connect(this.child("tbnCargaBusqueda"), "clicked()", _i, "tbnCargaBusqueda_clicked");
  connect(this.child("tbnAddWidget"), "clicked()", _i, "tbnAddWidget_clicked");

  connect(this.iface.tblElementosBus_, "clicked(int, int)", this, "iface.tblElementosBus_clicked");
  //  connect(this.iface.tblAcciones_, "clicked(int, int)", this, "iface.tblAcciones_clicked");
  //  connect(this.iface.tblAccionesRel_, "clicked(int, int)", this, "iface.tblAccionesRel_clicked");
  //  connect(this.iface.tblRelaciones_, "clicked(int, int)", this, "iface.tblRelaciones_clicked");
  //  connect(this.iface.tblElementosRel_, "clicked(int, int)", this, "iface.tblElementosRel_clicked");

  //  this.iface.cargaElementos();

  //this.child("tbnCargarIconos").close();
  this.iface.cambiaModo("visualizacion");

  _i.tbnHome_clicked();
  debug("tbnHome_clicked ok");

  //  connect(this.child("pbnMR"), "clicked()", this, "iface.pbnMR_clicked");

  var px = new QPixmap(formt1_principal.iface.imgPath_ + "config.png");
  this.child("tbnConfigBus").setIconSet(new QIconSet(px));
  connect(this.child("tbnConfigBus"), "clicked()", _i, "tbnConfigBus_clicked");

  this.child("fdbBuscar").setFocus();
  debug("init ok");
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_iniciarTablas()
{
  this.iface.iniciarTblElementosBus();
  /*
  this.iface.iniciarTblAcciones();
  this.iface.iniciarTblAccionesRel();
  this.iface.iniciarTblRelaciones();
  this.iface.iniciarTblElementosRel();
  this.iface.tdbTabla_ = this.child("tdbTabla");
  this.iface.tdbTabla_.setFunctionGetColor("dameColorFila");
  */
}

/*
function oficial_dameColorFila()
{
  return new Array("green", "", "", "");
}
*/

function oficial_accelActivated(iAccel)
{
  /*
  var i: Number;
  for (i = 0; i < this.iface.aAcciones_.length; i++) {
    if (this.iface.aAcciones_[i]["accel"] == iAccel) {
      break;
    }
  }
  if (i < this.iface.aAcciones_.length) {
    if (!this.iface.lanzaAccion(i)) {
      return false;
    }
  }
  */
}

/*
function oficial_iniciarTblRelaciones()
{
  var util = new FLUtil;

  this.iface.tblRelaciones_ = this.child("tblRelaciones");
  try {
    this.iface.tblRelaciones_.setLeftMargin(0);
    this.iface.tblRelaciones_.setTopMargin(0);
  } catch (e) {}
  this.iface.CR_IDREL = 0;
  this.iface.CR_TIPO = 1;
  this.iface.CR_CARD = 2;
  this.iface.CR_CLAVEREL = 3;
  this.iface.CR_ICONO = 4;
  this.iface.CR_DESC = 5;

  this.iface.tblRelaciones_.setNumCols(6);
  var cL = " * * * * * ";
  this.iface.tblRelaciones_.setColumnLabels("*", cL);
  this.iface.tblRelaciones_.hideColumn(this.iface.CR_IDREL);
  this.iface.tblRelaciones_.hideColumn(this.iface.CR_TIPO);
  this.iface.tblRelaciones_.hideColumn(this.iface.CR_CARD);
  this.iface.tblRelaciones_.hideColumn(this.iface.CR_CLAVEREL);
  this.iface.tblRelaciones_.setColumnWidth(this.iface.CR_ICONO, 40);
  this.iface.tblRelaciones_.setColumnWidth(this.iface.CR_DESC, 280);

  //  this.iface.tblRelaciones_.obj_.paletteBackgroundColor = this.child("gbxDatos").paletteBackgroundColor;
  //  this.iface.tblRelaciones_.backgroundMode = 2;
}
*/

/*
function oficial_iniciarTblElementosRel()
{
  var util = new FLUtil;

  this.iface.tblElementosRel_ = this.child("tblElementosRel");
  try {
    this.iface.tblElementosRel_.setLeftMargin(0);
    this.iface.tblElementosRel_.setTopMargin(0);
  } catch (e) {}
  this.iface.CER_IDREL = 0;
  this.iface.CER_TIPO = 1;
  this.iface.CER_CLAVE = 2;
  this.iface.CER_ICONO = 3;
  this.iface.CER_DES = 4;

  this.iface.tblElementosRel_.setNumCols(5);
  var cL = " *" + util.translate("scripts", "Tipo") + "*" + util.translate("scripts", "Clave") + "*" + util.translate("scripts", " ") + "* ";
  this.iface.tblElementosRel_.setColumnLabels("*", cL);
  this.iface.tblElementosRel_.hideColumn(this.iface.CER_IDREL);
  this.iface.tblElementosRel_.hideColumn(this.iface.CER_TIPO);
  this.iface.tblElementosRel_.hideColumn(this.iface.CER_CLAVE);
  this.iface.tblElementosRel_.setColumnWidth(this.iface.CER_ICONO, 40);
  this.iface.tblElementosRel_.setColumnWidth(this.iface.CER_DES, 200);
}
*/

/*
function oficial_iniciarTblAcciones()
{
  var util = new FLUtil;

  this.iface.tblAcciones_ = this.child("tblAcciones");
  try {
    this.iface.tblAcciones_.setLeftMargin(0);
    this.iface.tblAcciones_.setTopMargin(0);
  } catch (e) {}
  this.iface.xAcciones_ = 6;
  var numCols = this.iface.xAcciones_;
  var colWidth = 60;
  var cL = "";
  for (var i = 0; i < numCols; i++) {
    cL += (i == 0 ? " " : "* ");
  }
  this.iface.tblAcciones_.setNumCols(numCols);
  this.iface.tblAcciones_.setColumnLabels("*", cL);
  for (var i = 0; i < numCols; i++) {
    this.iface.tblAcciones_.setColumnWidth(i, colWidth);
  }
}
*/
/*
function oficial_iniciarTblAccionesRel()
{
  var util = new FLUtil;

  this.iface.tblAccionesRel_ = this.child("tblAccionesRel");
  try {
    this.iface.tblAccionesRel_.setLeftMargin(0);
    this.iface.tblAccionesRel_.setTopMargin(0);
  } catch (e) {}
  this.iface.xAcciones_ = 6;
  var numCols = this.iface.xAcciones_;
  var colWidth = 60;
  var cL = "";
  for (var i = 0; i < numCols; i++) {
    cL += (i == 0 ? " " : "* ");
  }
  this.iface.tblAccionesRel_.setNumCols(numCols);
  this.iface.tblAccionesRel_.setColumnLabels("*", cL);
  for (var i = 0; i < numCols; i++) {
    this.iface.tblAccionesRel_.setColumnWidth(i, colWidth);
  }
}
  */

function oficial_iniciarTblElementosBus()
{
  var util = new FLUtil;

  this.iface.tblElementosBus_ = this.child("tblElementosBus");

  try {
    this.iface.tblElementosBus_.setLeftMargin(0);
    this.iface.tblElementosBus_.setTopMargin(0);
  } catch (e) {}

  this.iface.CB_TIPO = 0;
  this.iface.CB_CLAVE = 1;
  this.iface.CB_ICONO = 2;
  this.iface.CB_DESC = 3;

  this.iface.tblElementosBus_.setNumCols(4);
  var cL = " * * * * ";
  this.iface.tblElementosBus_.setColumnLabels("*", cL);
  this.iface.tblElementosBus_.hideColumn(this.iface.CB_TIPO);
  this.iface.tblElementosBus_.hideColumn(this.iface.CB_CLAVE);
  this.iface.tblElementosBus_.setColumnWidth(this.iface.CB_ICONO, 32);
  this.iface.tblElementosBus_.setColumnWidth(this.iface.CB_DESC, 280);
  this.iface.altoFilaBus_ = 40;
}

function oficial_tbnBuscar_clicked()
{
  this.child("fdbBuscar").setFocus();

  var cadena = this.child("fdbBuscar").value();
  if (!this.iface.buscar(cadena)) {
    return false;
  }
  if (!this.iface.guardaElementoHistorial("t1_busq", cadena)) {
    return false;
  }
}

function oficial_buscar(cadena)
{
  if (!cadena || cadena == "") {
    return false;
  }
  cadena = cadena.toUpperCase();

  this.iface.tblElementosBus_.setNumRows(0);
  if (!this.iface.buscarElementos(cadena)) {
    return false;
  }
  var totalFilas = this.iface.tblElementosBus_.numRows();
  switch (totalFilas) {
    case 0: {
      return;
    }
    case 1: {
      this.iface.tblElementosBus_clicked(0);
      break;
    }
    default: {
      this.iface.cambiaModo("busqueda");
    }
  }
  return true;
}

/** \D Cambia al modo indicado, mostrando los elementos relacionados o la lista de elementos encontrados. Los modos son "busqueda" y "visualizacion"
@param  modo: Modo al que hay que cambiar
\end */
function oficial_cambiaModo(modo: String)
{
  var busqueda = modo == "busqueda";
  if (busqueda) {
    //     this.child("gbxVisualizacion").close();
    this.child("gbxFondo").close();
    this.child("gbxBusqueda").show();
  } else {
    //this.child("gbxVisualizacion").show();
    this.child("gbxFondo").show();
    this.child("gbxBusqueda").close();
  }
}

function oficial_buscarElementos(cadena)
{
  var _i = this.iface;
  /*
  var sXmlBus = AQUtil.sqlSelect("t1_busqueda", "xmlbusqueda", "idusuario = '" + sys.nameUser() + "'");
  if (!sXmlBus) {
    sXmlBus = "<ABNSearch>" +
              "<action name='clientes' active='true'>" +
              "<searchfields>" +
              "<searchfield name='nombre' active='true'/>" +
              "</searchfields>" +
              "<showfields>" +
              "<showfield name='codcliente' active='true'/>" +
              "<showfield name='nombre' active='true'/>" +
              "</showfields>" +
              "</action>" +
              "<action name='proveedores' active='true'>" +
              "<searchfields>" +
              "<searchfield name='nombre' active='true'/>" +
              "</searchfields>" +
              "<showfields>" +
              "<showfield name='nombre' active='true'/>" +
              "</showfields>" +
              "</action>" +
              "<action name='articulos' active='true'>" +
              "<searchfields>" +
              "<searchfield name='referencia' active='true'/>" +
              "<searchfield name='descripcion' active='true'/>" +
              "</searchfields>" +
              "<showfields>" +
              "<showfield name='referencia' active='true'/>" +
              "<showfield name='descripcion' active='true'/>" +
              "</showfields>" +
              "</action>" +
              "</ABNSearch>";
    if (!AQSql.insert("t1_busqueda", ["idusuario", "xmlbusqueda"], [sys.nameUser(), sXmlBus])) {
      return false;
    }
  }
  var xmlBus = new QDomDocument();
  if (!xmlBus.setContent(sXmlBus)) {
    debug("!xmlBus.setContent(sXmlBus)");
    return;
  }*/
  _i.borraWidgetsDashboard();

  var xBus = _i.xmlSearch_.firstChild();
  var eAction, tabla, fila, qBus, showField, aShowFields, eShowField, selectBus, eSearchField, whereBus;
  var mtdTabla, pk, descripcionBus;
  for (var xAction = xBus.firstChild(); !xAction.isNull(); xAction = xAction.nextSibling()) {
    eAction = xAction.toElement();
    if (eAction.attribute("active") != "true") {
      continue;
    }
    tabla = eAction.attribute("name");
    mtdTabla = _i.mgr_.metadata(tabla);
    pk = mtdTabla.primaryKey();
    aShowFields = [];
    selectBus = pk;
    for (var xShowField = xAction.namedItem("showfields").firstChild(); !xShowField.isNull(); xShowField = xShowField.nextSibling()) {
      eShowField = xShowField.toElement();
      if (eShowField.attribute("active") != "true") {
        continue;
      }
      showField = eShowField.attribute("name");
      aShowFields.push(showField);
      if (showField != pk) {
        selectBus += ", " + showField;
      }
    }
    whereBus = "";
    for (var xSearchField = xAction.namedItem("searchfields").firstChild(); !xSearchField.isNull(); xSearchField = xSearchField.nextSibling()) {
      eSearchField = xSearchField.toElement();
      if (eSearchField.attribute("active") != "true") {
        continue;
      }
      whereBus += whereBus != "" ? " OR " : "";
      whereBus += "UPPER(" + eSearchField.attribute("name") + ") LIKE '%" + cadena + "%'";
    }
    if (whereBus == "") {
      continue;
    }
    fila = _i.tblElementosBus_.numRows();
    qBus = new FLSqlQuery;
    qBus.setTablesList(tabla);
    qBus.setSelect(selectBus);
    qBus.setFrom(tabla);
    qBus.setWhere(whereBus);
    qBus.setForwardOnly(true);
    debug(qBus.sql());
    if (!qBus.exec()) {
      return false;
    }
    var clave, eAction;
    while (qBus.next()) {
      descripcionBus = "";
      for (var i = 0; i < aShowFields.length; i++) {
        descripcionBus += (i > 0) ? " " : "";
        descripcionBus += qBus.value(aShowFields[i]);
      }
      _i.tblElementosBus_.insertRows(fila);
      _i.tblElementosBus_.setRowHeight(fila, _i.altoFilaBus_);
      _i.tblElementosBus_.setText(fila, _i.CB_TIPO, tabla);
      _i.tblElementosBus_.setText(fila, _i.CB_CLAVE, qBus.value(pk));
      eAction = _i.dameElementoXML(_i.xmlActions_.firstChild(), "action[@name=" + tabla + "]");
      if (!eAction.isNull()) {
        var pixIcono = new QPixmap(_i.imgPath_ + "22x22/" + eAction.attribute("icon"));
        _i.tblElementosBus_.setPixmap(fila, _i.CB_ICONO, pixIcono);
      }
      _i.tblElementosBus_.setText(fila, _i.CB_DESC, descripcionBus);
      fila++;
    }

  }
  /*
  if (!this.iface.buscarClientes(cadena)) {
    return false;
  }
  if (!this.iface.buscarContactos(cadena)) {
    return false;
  }
  if (!this.iface.buscarAgentes(cadena)) {
    return false;
  }
  */
  return true;
}
/*
function oficial_buscarClientes(cadena: String)
{
  var util = new FLUtil;
  var fila = this.iface.tblElementosBus_.numRows();

  var qryClientes = new FLSqlQuery;
  qryClientes.setTablesList("clientes");
  qryClientes.setSelect("codcliente, nombre");
  qryClientes.setFrom("clientes");
  qryClientes.setWhere("UPPER(nombre) LIKE '%" + cadena + "%'");
  qryClientes.setForwardOnly(true);
  if (!qryClientes.exec()) {
    return false;
  }
  var clave: String;
  while (qryClientes.next()) {
    this.iface.tblElementosBus_.insertRows(fila);
    this.iface.tblElementosRel_.setRowHeight(fila, this.iface.altoFilaBus_);
    this.iface.tblElementosBus_.setText(fila, this.iface.CB_TIPO, "clientes");
    this.iface.tblElementosBus_.setText(fila, this.iface.CB_CLAVE, qryClientes.value("codcliente"));
    this.iface.dibujarIconoTabla(this.iface.tblElementosBus_, fila, this.iface.CB_ICONO, "clientes");
    this.iface.tblElementosBus_.setText(fila, this.iface.CB_DESC, qryClientes.value("nombre"));
    fila++;
  }

  return true;
}
*/

/*
function oficial_buscarContactos(cadena: String)
{
  var util = new FLUtil;
  var fila = this.iface.tblElementosBus_.numRows();

  var qryContactos = new FLSqlQuery;
  qryContactos.setTablesList("crm_contactos");
  qryContactos.setSelect("codcontacto, nombre");
  qryContactos.setFrom("crm_contactos");
  qryContactos.setWhere("UPPER(nombre) LIKE '%" + cadena + "%'");
  qryContactos.setForwardOnly(true);
  debug(qryContactos.sql());
  if (!qryContactos.exec()) {
    return false;
  }
  var clave: String;
  while (qryContactos.next()) {
    this.iface.tblElementosBus_.insertRows(fila);
    this.iface.tblElementosRel_.setRowHeight(fila, this.iface.altoFilaBus_);
    this.iface.tblElementosBus_.setText(fila, this.iface.CB_TIPO, "crm_contactos");
    this.iface.tblElementosBus_.setText(fila, this.iface.CB_CLAVE, qryContactos.value("codcontacto"));
    this.iface.dibujarIconoTabla(this.iface.tblElementosBus_, fila, this.iface.CB_ICONO, "crm_contactos");
    this.iface.tblElementosBus_.setText(fila, this.iface.CB_DESC, qryContactos.value("nombre"));
    fila++;
  }

  return true;
}
*/

/*
function oficial_buscarAgentes(cadena: String)
{
  var util = new FLUtil;
  var fila = this.iface.tblElementosBus_.numRows();

  var qryClientes = new FLSqlQuery;
  qryClientes.setTablesList("agentes");
  qryClientes.setSelect("codagente, nombreap");
  qryClientes.setFrom("agentes");
  qryClientes.setWhere("UPPER(nombreap) LIKE '%" + cadena + "%'");
  qryClientes.setForwardOnly(true);
  if (!qryClientes.exec()) {
    return false;
  }
  while (qryClientes.next()) {
    this.iface.tblElementosBus_.insertRows(fila);
    this.iface.tblElementosBus_.setRowHeight(fila, ALTO_F_BUS);
    this.iface.tblElementosBus_.setText(fila, this.iface.CB_TIPO, "agentes");
    this.iface.tblElementosBus_.setText(fila, this.iface.CB_CLAVE, qryClientes.value("codagente"));
    this.iface.dibujarIconoTabla(this.iface.tblElementosBus_, fila, this.iface.CB_ICONO, "agentes");
    this.iface.tblElementosBus_.setText(fila, this.iface.CB_DESC, qryClientes.value("nombreap"));
    fila++;
  }

  return true;
}
*/

function oficial_tblElementosBus_clicked(fila: Number, col: Number)
{
  if (fila < 0) {
    return false;
  }
  this.iface.cambiaModo("visualizacion");
  var tipo = this.iface.tblElementosBus_.text(fila, this.iface.CB_TIPO);
  var clave = this.iface.tblElementosBus_.text(fila, this.iface.CB_CLAVE);
  if (!this.iface.ponElementoActual(tipo, clave)) {
    return false;
  }
}

/*
function oficial_tblAcciones_clicked(fila: Number, col: Number)
{
  if (fila < 0) {
    return false;
  }
  if (!this.iface.aAcciones_) {
    return false;
  }
  var indice = (fila * this.iface.xAcciones_) + col;
  if (indice >= this.iface.aAcciones_.length) {
    return false;
  }
  if (!this.iface.lanzaAccion(indice)) {
    return false;
  }
}
*/
/*
function oficial_tblAccionesRel_clicked(fila: Number, col: Number)
{
  if (fila < 0) {
    return false;
  }
  if (!this.iface.aAccionesRel_) {
    return false;
  }
  var indice = (fila * this.iface.xAcciones_) + col;
  if (indice >= this.iface.aAccionesRel_.length) {
    return false;
  }
  if (!this.iface.lanzaAccionRel(indice)) {
    return false;
  }
}
  */
/*
function oficial_lanzaAccion(indice: Number)
{
  var aElemento = this.iface.dameElementoActual();
  var funcion = this.iface.aAcciones_[indice]["funcion"];
  var llamada = "return formt1_principal.iface." + funcion + "(tipo, clave);";
  var f: Function = new Function("tipo", "clave", llamada);
  if (!(f(aElemento.tipo, aElemento.clave))) {
    return false;
  }

  return true;
}
*/
/*
function oficial_lanzaAccionRel(indice: Number)
{
  var curElementoRel = this.iface.tdbTabla_.cursor();
  var clave = curElementoRel.valueBuffer(curElementoRel.primaryKey());
  var tipo = curElementoRel.table();

  var funcion = this.iface.aAccionesRel_[indice]["funcion"];
  var llamada = "return formt1_principal.iface." + funcion + "(tipo, clave);";
  var f: Function = new Function("tipo", "clave", llamada);
  if (!(f(tipo, clave))) {
    return false;
  }
  this.iface.tdbTabla_.refresh();

  return true;
}
*/
/*
function oficial_tblRelaciones_clicked(fila: Number, col: Number)
{
  debug("1");
  var util = new FLUtil;
  if (fila < 0) {
    return false;
  }
  if (!this.iface.aRelaciones_) {
    return false;
  }
  var indice = this.iface.tblRelaciones_.text(fila, this.iface.CR_IDREL);
  if (indice >= this.iface.aRelaciones_.length) {
    return false;
  }

  var aElemento = this.iface.dameElementoActual();
  var relacion = this.iface.aRelaciones_[indice]["nombre"];
  var tablaRel = this.iface.dameTablaElemento(relacion);
  if (!tablaRel) {
    return false;
  }
  /// Usamos la tabla para el caso de xM con Cuenta = 1 que pasan a 11
  var card = this.iface.tblRelaciones_.text(fila, this.iface.CR_CARD); //this.iface.aRelaciones_[indice]["card"];
  if (card == "1M" || card == "MM") {
    debug("2");
    if (!this.iface.muestraElementosRel(aElemento.tipo, aElemento.clave, indice)) {
      return false;
    }
  } else {
    var claveRel: String;
    var filtroPpal = this.iface.aRelaciones_[indice]["filtroPpal"]
                     debug("filtroPpal = " + filtroPpal);
    if (filtroPpal && filtroPpal != "") {
      var where = filtroPpal; //this.iface.dameFiltroPrincipal(filtroPpal, aElemento["clave"]);
      debug("where = " + where);
      var curT = new FLSqlCursor(tablaRel);
      claveRel = util.sqlSelect(tablaRel, curT.primaryKey(), where);
    } else {
    }
    if (claveRel != "") {
      if (col == this.iface.CR_ICONO) {
        if (!this.iface.ponElementoActual(relacion, claveRel)) {
          return false;
        }
        this.iface.editarElementoSel();
      } else {
        if (!this.iface.muestraElementosRel(aElemento.tipo, aElemento.clave, indice)) {
          return false;
        }
        if (!this.iface.ponElementoActual(relacion, claveRel)) {
          return false;
        }
      }
    }
  }

  return true;
}
*/

function oficial_tbnHome_clicked()
{
  //  var elemento= "usuarios";
  //  var clave= this.iface.idUsuario_;
  var elemento = "usuarios";
  var clave = sys.nameUser();
  if (!this.iface.ponElementoActual(elemento, clave)) {
    return false;
  }
}
/*
function oficial_tblElementosRel_clicked(fila: Number, col: Number)
{
  //  if (this.iface.bloqueoTabla_) {
  //    return true;
  //  }

  if (!this.iface.f_) {
    return;
  }
  var curTabla = this.iface.f_.cursor();
  //  var tipo= curTabla.table();
  var tipo = curTabla.action();
  var pk = curTabla.primaryKey();
  //  var fT= curTabla.fieldType(pk);
  var clave = curTabla.valueBuffer(pk);
  //  if (col == this.iface.CER_ICONO) {
  //    if (!this.iface.editarElemento(tipo, clave)) {
  //      return false;
  //    }
  //  } else {
  if (!this.iface.ponElementoActual(tipo, clave)) {
    return false;
  }
  //  }

  return true;
}
*/
// function oficial_tblElementosRel_clicked3(fila:Number, col:Number)
// {
//
//  var curTabla= this.iface.tdbTabla_.cursor();
//  var tipo= curTabla.table();
//  var pk= curTabla.primaryKey();
//  var clave= curTabla.valueBuffer(pk);
//
//
//  if (!this.iface.ponElementoActual(tipo, clave)) {
//    return false;
//  }
//
//  return true;
// }
//
// function oficial_tblElementosRel_clicked2(fila:Number, col:Number)
// {
//  if (fila < 0) {
//    return false;
//  }
//  var tipo= this.iface.tblElementosRel_.text(fila, this.iface.CER_TIPO);
//  var clave= this.iface.tblElementosRel_.text(fila, this.iface.CER_CLAVE);
//
//  if (col == this.iface.CER_ICONO) {
//    if (!this.iface.editarElemento(tipo, clave)) {
//      return false;
//    }
//  } else {
//    if (!this.iface.ponElementoActual(tipo, clave)) {
//      return false;
//    }
//  }
//
//  return true;
// }
/*
function oficial_dibujaPixmapRel(tabla: FLTable, fila: Number, col: Number, aDatos: Array, iRel: Number)
{
  var util = new FLUtil;

  var pixSize = new Size(tabla.columnWidth(col), 32);
  var pixNew = new Pixmap;
  var clr = new Color;
  clr.setRgb(255, 255, 255);

  pixNew.resize(pixSize);
  pixNew.fill(clr);

  var xmlPic = this.iface.aRelaciones_[iRel]["xmlPicRelacion"];
  if (!xmlPic) {
    xmlPic = this.iface.damePicRelacionDefecto(iRel);
    if (!xmlPic) {
      tabla.setPixmap(fila, col, pixNew);
      return true;
    }
  }

  var pic: Picture = new Picture;
  pic.begin();
  if (!this.iface.dibujaPicture(pic, xmlPic, pixSize, aDatos)) {
    return false;
  }

  pixNew = pic.playOnPixmap(pixNew);
  pic.end();

  tabla.setPixmap(fila, col, pixNew);
  return true;
}
*/
/*
function oficial_dibujaPixmapElementoRel(tabla: FLTable, fila: Number, col: Number, aDatos: Array, iRel: Number)
{
  debug("oficial_dibujaPixmapElementoRel");
  var util = new FLUtil;
  var pixSize = new Size(tabla.columnWidth(col), 32);

  var xmlPic = this.iface.aRelaciones_[iRel]["xmlPicElemento"];
  if (!xmlPic) {
    debug("No hay xmlPic en tabla");
    xmlPic = this.iface.damePicElementoRelDefecto(iRel);
    if (!xmlPic) {
      debug("!oficial_dibujaPixmapRel");
      return false;
    }
  }
  debug(xmlPic.toString());

  var pic: Picture = new Picture;
  pic.begin();
  if (!this.iface.dibujaPicture(pic, xmlPic, pixSize, aDatos)) {
    debug("!!!oficial_dibujaPixmapRel");
    return false;
  }

  var pixNew = new Pixmap;
  var clr = new Color;
  clr.setRgb(255, 255, 255);

  pixNew.resize(pixSize);
  pixNew.fill(clr);
  //  pic.begin();
  //  pic.drawPixmap(0, 0, pixNew);
  pixNew = pic.playOnPixmap(pixNew);
  pic.end();

  tabla.setPixmap(fila, col, pixNew);
  return true;
}
*/
/*
function oficial_dibujarIconoTabla(tabla: FLTable, fila: Number, col: Number, tipo: String)
{
  var util = new FLUtil;
  //  var icono= util.sqlSelect("t1_elementos", "icono", "elemento = '" + tipo + "'");
  //  if (!icono) {
  //    return false;
  //  }
  var pixIcono = this.iface.aElementos_[tipo]["icono"];
  if (!pixIcono) {
    return true;
  }

  var pic = new Picture;
  var pixNew = new Pixmap;
  var clr = new Color;
  clr.setRgb(255, 255, 255);

  //  var pixIcono = sys.toPixmap(icono);
  var pixSize = pixIcono.size;
  pixNew.resize(pixSize);
  pixNew.fill(clr);
  pic.begin();
  pic.drawPixmap(0, 0, pixNew);
  pic.drawPixmap(0, 0, pixIcono);
  pixNew = pic.playOnPixmap(pixNew);
  pic.end();

  tabla.setPixmap(fila, col, pixNew);
  return true;
}
*/
/*
function oficial_muestraElemento(tipo: String, clave: String)
{
  var util = new FLUtil;

  var pic = this.iface.dibujaElemento(tipo, clave);
  if (!pic) {
    return false;
  }
  var pixNew = new Pixmap;
  var clr = new Color;
  clr.setRgb(255, 255, 255);
  //  clr.setRgb(57,57,57);

  var pixSize = this.child("tbnElemento").size;
  /// Evita que el botón vaya creciendo
  pixSize.height -= 4;
  pixSize.width = pixSize.width - 10;
  pixNew.resize(pixSize);
  pixNew.fill(clr);

  //  pic.drawPixmap(0, 0, pixNew);
  //  pic.drawPixmap(0, 0, pixIcono);
  pixNew = pic.playOnPixmap(pixNew);
  pic.end();

  this.child("tbnElemento").pixmap = pixNew;
  return true;
}

function oficial_dibujaElemento(tipo: String, clave: String): Picture {
  var util = new FLUtil;
  var pixSize = this.child("tbnElemento").size;
  /// Evita que el botón vaya creciendo
  pixSize.height -= 4;
  pixSize.width = pixSize.width - 10;

  if (!this.iface.cargaDatosElemento(tipo, clave))
  {
    return false;
  }

  var xmlPic = this.iface.aElementos_[tipo]["xmlPic"];
  if (!xmlPic)
  {
    xmlPic = this.iface.damePicElementoDefecto(tipo);
    if (!xmlPic) {
      return false;
    }
  }

  var pic: Picture = new Picture;
  pic.begin();
  if (!this.iface.dibujaPicture(pic, xmlPic, pixSize, this.iface.aDatosElemento_["c"]))
  {
    return false;
  }
  return pic;
}
*/
// function oficial_cargaPicElemento(pic:Picture, tipo:String)
// {
//  var util= new FLUtil;
//  var pixSize = this.child("tbnElemento").size;
// /*
//  if (this.iface.picElemento_) {
//    this.iface.picElemento_.end();
//    delete this.iface.picElemento_;
//  }
// */
// debug("oficial_cargaPicElemento " + tipo);
//  var r:Rect = new Rect(0, 0, pixSize.width, pixSize.height);
//  var ancho= pixSize.width;
//  var alto= pixSize.height;
//
//  switch (tipo) {
//    case "clientes": {
//      r.height = 30;
//      this.iface.dibujaTextoPic(r, aDatos["c.nombre"], "titulo", pic, pic.AlignCenter);
//
//      var telefono1= aDatos["c.telefono1"];
//      var telefono2= aDatos["c.telefono2"];
//      var email= aDatos["c.email"];
//      var tel= "";
//      if (telefono1 && telefono1 != "") {
//        tel = util.translate("scripts", "Tel. %1").arg(telefono1);
//      }
//      if (telefono2 && telefono2 != "") {
//        tel += tel == "" ? "" : " - ";
//        tel += telefono2;
//      }
//      r.x = 30; r.y = 30; r.height = 20;
//      this.iface.dibujaTextoPic(r, tel, "normal", pic, pic.AlignLeft);
//
//      if (email && email != "") {
//        email = util.translate("scripts", "e-Mail %1").arg(email);
//      }
//      r.y = 50; r.height = 20;
//      this.iface.dibujaTextoPic(r, email, "normal", pic, pic.AlignLeft);
//      break;
//    }
//    case "agentes": {
//      r.height = 30;
//      this.iface.dibujaTextoPic(r, aDatos["a.nombreap"], "titulo", pic, pic.AlignCenter);
//
//      var telefono1= aDatos["a.telefono"];
//      var email= aDatos["a.email"];
//      var tel= "";
//      if (telefono1 && telefono1 != "") {
//        tel = util.translate("scripts", "Tel. %1").arg(telefono1);
//      }
//      r.y = 50; r.x = 30; r.height = 20;
//      this.iface.dibujaTextoPic(r, tel, "normal", pic, pic.AlignLeft);
//
//      if (email && email != "") {
//        email = util.translate("scripts", "e-Mail %1").arg(email);
//      }
//      r.y = 70; r.height = 20;
//      this.iface.dibujaTextoPic(r, email, "normal", pic, pic.AlignLeft);
//
//      r.y = 90; r.height = 20;
//      var porComision= util.translate("scripts", "Comisión: %1").arg(util.roundFieldValue(aDatos["a.porcomision"], "agentes", "porcomision") + "%");
//      this.iface.dibujaTextoPic(r, porComision, "normal", pic, pic.AlignLeft);
//      break;
//    }
//    case "facturascli": {
//      var texto= aDatos["f.codigo"];
//      r.height = 20;
//      this.iface.dibujaTextoPic(r, texto, "normal", pic, pic.AlignLeft);
//
//      texto = util.dateAMDtoDMA(aDatos["f.fecha"]);
//      this.iface.dibujaTextoPic(r, texto, "normal", pic, pic.AlignRight);
//
//      r.y = 20; r.height = 30;
//      texto = util.roundFieldValue(aDatos["f.total"], "facturascli", "total");
//      this.iface.dibujaTextoPic(r, texto, "titulo", pic, pic.AlignCenter);
//
//      r.y = 50; r.height = 30;
//      texto = aDatos["f.editable"] ? util.translate("scripts", "Pendiente") : util.translate("scripts", "Pagada")
//      this.iface.dibujaTextoPic(r, texto, "titulo", pic, pic.AlignCenter);
//      break;
//    }
//    case "albaranescli": {
//      var texto= aDatos["a.codigo"];
//      r.height = 20;
//      this.iface.dibujaTextoPic(r, texto, "normal", pic, pic.AlignLeft);
//
//      texto = util.dateAMDtoDMA(aDatos["a.fecha"]);
//      this.iface.dibujaTextoPic(r, texto, "normal", pic, pic.AlignRight);
//
//      r.y = 20; r.height = 30;
//      texto = util.roundFieldValue(aDatos["a.total"], "albaranescli", "total");
//      this.iface.dibujaTextoPic(r, texto, "titulo", pic, pic.AlignCenter);
//
//      r.y = 50; r.height = 30;
//      texto = aDatos["a.ptefactura"] ? util.translate("scripts", "Pte. Factura") : util.translate("scripts", "Facturado")
//      this.iface.dibujaTextoPic(r, texto, "titulo", pic, pic.AlignCenter);
//      break;
//    }
//    case "pedidoscli": {
//      var texto= aDatos["p.codigo"];
//      r.height = 20;
//      this.iface.dibujaTextoPic(r, texto, "normal", pic, pic.AlignLeft);
//
//      texto = util.dateAMDtoDMA(aDatos["p.fecha"]);
//      this.iface.dibujaTextoPic(r, texto, "normal", pic, pic.AlignRight);
//
//      r.y = 20; r.height = 30;
//      texto = util.roundFieldValue(aDatos["p.total"], "pedidoscli", "total");
//      this.iface.dibujaTextoPic(r, texto, "titulo", pic, pic.AlignCenter);
//
//      r.y = 50; r.height = 30;
//      switch (aDatos["f.servido"]) {
//        case "Sí": { texto = util.translate("scripts", "Servido"); break; }
//        case "No": { texto = util.translate("scripts", "Por Servir"); break; }
//        case "Parcial": { texto = util.translate("scripts", "Parcialmente servido"); break; }
//        default: { texto = "";}
//      }
//      this.iface.dibujaTextoPic(r, texto, "titulo", pic, pic.AlignCenter);
//      break;
//    }
//    case "presupuestoscli": {
//      this.iface.dibujaPicture(pic, tipo, aDatos);
//      break;
//    }
//    default: {
//      var texto= util.translate("scripts", "Formato no definido para %1").arg(tipo);
//      this.iface.dibujaTextoPic(r, texto, "normal", pic, pic.AlignCenter);
//    }
//  }
//
//
// debug(this.iface.xmlElemento_.toString(4));
//  return true;
// }
/*
function oficial_damePicElementoDefecto(tipo: String)
{
  var util = new FLUtil;
  var pixSize = this.child("tbnElemento").size;
  var r: Rect = new Rect(0, 0, pixSize.width, pixSize.height);
  var ancho = pixSize.width;
  var alto = pixSize.height;

  var contenido = "";
  switch (tipo) {
    case "t1_home": {
      contenido = "<Picture>" + "\n\t";
      contenido += "<Text x='0' y='0' width='100%' height='100%' style='titulo' valignment='AlignVCenter' halignment='AlignHCenter'>nombre</Text>";
      contenido += "</Picture>";
      break;
    }
    case "presupuestoscli": {
      contenido = "<Picture>" + "\n\t";
      contenido += "<Text x='0' y='0' width='100%' height='20%' style='normal' halignment='AlignLeft'>presupuestoscli.codigo</Text>" + "\n\t";
      contenido += "<Text x='0' y='0' width='100%' height='20%' style='normal' halignment='AlignRight'>presupuestoscli.fecha</Text>" + "\n\t";
      contenido += "<Text x='0' y='20%' width='100%' height='30%' style='titulo' halignment='AlignCenter'>presupuestoscli.total</Text>" + "\n\t";
      contenido += "<Text x='0' y='50%' width='100%' height='30%' style='titulo' halignment='AlignCenter'>aprobado</Text>" + "\n";
      contenido += "</Picture>";
      break;
    }
    case "clientes": {
      contenido = "<Picture>" + "\n\t";
      contenido += "<Text x='0' y='0' width='100%' height='30%' style='titulo' halignment='AlignCenter'>clientes.nombre</Text>" + "\n\t";
      contenido += "<Text x='0' y='30%' width='100%' height='20%' style='normal' halignment='AlignLeft'>clientes.telefono1</Text>" + "\n\t";
      contenido += "<Text x='0' y='50%' width='100%' height='20%' style='normal' halignment='AlignLeft'>clientes.email</Text>" + "\n\t";
      contenido += "</Picture>";
      break;
    }
    default: {
      contenido = "<Picture>" + "\n\t";
      contenido += "<Text x='0' y='0' width='100%' height='50%' style='titulo' halignment='AlignCenter'>Sin Datos</Text>" + "\n\t";
      contenido += "</Picture>";
    }
    //    case "agentes": {
    //      r.height = 30;
    //      this.iface.dibujaTextoPic(r, aDatos["a.nombreap"], "titulo", pic, pic.AlignCenter);
    //
    //      var telefono1= aDatos["a.telefono"];
    //      var email= aDatos["a.email"];
    //      var tel= "";
    //      if (telefono1 && telefono1 != "") {
    //        tel = util.translate("scripts", "Tel. %1").arg(telefono1);
    //      }
    //      r.y = 50; r.x = 30; r.height = 20;
    //      this.iface.dibujaTextoPic(r, tel, "normal", pic, pic.AlignLeft);
    //
    //      if (email && email != "") {
    //        email = util.translate("scripts", "e-Mail %1").arg(email);
    //      }
    //      r.y = 70; r.height = 20;
    //      this.iface.dibujaTextoPic(r, email, "normal", pic, pic.AlignLeft);
    //
    //      r.y = 90; r.height = 20;
    //      var porComision= util.translate("scripts", "Comisión: %1").arg(util.roundFieldValue(aDatos["a.porcomision"], "agentes", "porcomision") + "%");
    //      this.iface.dibujaTextoPic(r, porComision, "normal", pic, pic.AlignLeft);
    //      break;
    //    }
    //    case "facturascli": {
    //      var texto= aDatos["f.codigo"];
    //      r.height = 20;
    //      this.iface.dibujaTextoPic(r, texto, "normal", pic, pic.AlignLeft);
    //
    //      texto = util.dateAMDtoDMA(aDatos["f.fecha"]);
    //      this.iface.dibujaTextoPic(r, texto, "normal", pic, pic.AlignRight);
    //
    //      r.y = 20; r.height = 30;
    //      texto = util.roundFieldValue(aDatos["f.total"], "facturascli", "total");
    //      this.iface.dibujaTextoPic(r, texto, "titulo", pic, pic.AlignCenter);
    //
    //      r.y = 50; r.height = 30;
    //      texto = aDatos["f.editable"] ? util.translate("scripts", "Pendiente") : util.translate("scripts", "Pagada")
    //      this.iface.dibujaTextoPic(r, texto, "titulo", pic, pic.AlignCenter);
    //      break;
    //    }
    //    case "albaranescli": {
    //      var texto= aDatos["a.codigo"];
    //      r.height = 20;
    //      this.iface.dibujaTextoPic(r, texto, "normal", pic, pic.AlignLeft);
    //
    //      texto = util.dateAMDtoDMA(aDatos["a.fecha"]);
    //      this.iface.dibujaTextoPic(r, texto, "normal", pic, pic.AlignRight);
    //
    //      r.y = 20; r.height = 30;
    //      texto = util.roundFieldValue(aDatos["a.total"], "albaranescli", "total");
    //      this.iface.dibujaTextoPic(r, texto, "titulo", pic, pic.AlignCenter);
    //
    //      r.y = 50; r.height = 30;
    //      texto = aDatos["a.ptefactura"] ? util.translate("scripts", "Pte. Factura") : util.translate("scripts", "Facturado")
    //      this.iface.dibujaTextoPic(r, texto, "titulo", pic, pic.AlignCenter);
    //      break;
    //    }
    //    case "pedidoscli": {
    //      var texto= aDatos["p.codigo"];
    //      r.height = 20;
    //      this.iface.dibujaTextoPic(r, texto, "normal", pic, pic.AlignLeft);
    //
    //      texto = util.dateAMDtoDMA(aDatos["p.fecha"]);
    //      this.iface.dibujaTextoPic(r, texto, "normal", pic, pic.AlignRight);
    //
    //      r.y = 20; r.height = 30;
    //      texto = util.roundFieldValue(aDatos["p.total"], "pedidoscli", "total");
    //      this.iface.dibujaTextoPic(r, texto, "titulo", pic, pic.AlignCenter);
    //
    //      r.y = 50; r.height = 30;
    //      switch (aDatos["f.servido"]) {
    //        case "Sí": { texto = util.translate("scripts", "Servido"); break; }
    //        case "No": { texto = util.translate("scripts", "Por Servir"); break; }
    //        case "Parcial": { texto = util.translate("scripts", "Parcialmente servido"); break; }
    //        default: { texto = "";}
    //      }
    //      this.iface.dibujaTextoPic(r, texto, "titulo", pic, pic.AlignCenter);
    //      break;
    //    }
  }
  if (contenido == "") {
    return false;
  }
  if (!util.sqlUpdate("t1_elementos", "xmlpic", contenido, "elemento = '" + tipo + "'")) {
    return false;
  }
  var xmlDoc: FLDomDocument;
  if (!xmlDoc.setContent(contenido)) {
    return false;
  }
  return xmlDoc;
}

function oficial_damePicRelacionDefecto(iRel: Number)
{
  var util = new FLUtil;
  var contenido = "";
  var aElemento = this.iface.dameElementoActual();
  var tipo = aElemento["tipo"];
  var nombreRel = this.iface.aRelaciones_[iRel]["nombre"];
  switch (tipo) {
    default: {
      switch (nombreRel) {
        case "facturascli": {
          contenido = "<Picture>" + "\n\t";
          contenido += "<Text x='0' y='0' width='100%' height='50%' style='normal' halignment='AlignLeft'>numFacturas</Text>" + "\n\t";
          contenido += "<Text x='0' y='50%' width='100%' height='50%' style='normal' halignment='AlignRight'>total</Text>" + "\n\t";
          contenido += "</Picture>";
          break;
        }
        default: {
          return false;
        }
      }
      break;
    }
  }
  if (contenido == "") {
    return false;
  }
  if (!util.sqlUpdate("t1_relacioneselemento", "xmlpicrelacion", contenido, "idrelacionelemento = " + this.iface.aRelaciones_[iRel]["id"])) {
    return false;
  }
  var xmlDoc: FLDomDocument;
  if (!xmlDoc.setContent(contenido)) {
    return false;
  }
  return xmlDoc;
}

function oficial_damePicElementoRelDefecto(iRel: Number)
{
  var util = new FLUtil;
  var contenido = "";
  var aElemento = this.iface.dameElementoActual();
  var tipo = aElemento["tipo"];
  var nombreRel = this.iface.aRelaciones_[iRel]["nombre"];
  switch (tipo) {
    default: {
      switch (nombreRel) {
        case "facturascli": {
          contenido = "<Picture>" + "\n\t";
          contenido += "<Text x='0' y='0' width='100%' height='50%' style='normal' halignment='AlignLeft'>facturascli.codigo</Text>" + "\n\t";
          contenido += "<Text x='0' y='50%' width='100%' height='50%' style='normal' halignment='AlignRight'>facturascli.fecha</Text>" + "\n\t";
          contenido += "</Picture>";
          break;
        }
        default: {
          return false;
        }
      }
      break;
    }
  }
  if (contenido == "") {
    return false;
  }
  if (!util.sqlUpdate("t1_elementos", "xmlpicelemento", contenido, "elemento = '" + tipo + "'")) {
    return false;
  }
  var xmlDoc: FLDomDocument;
  if (!xmlDoc.setContent(contenido)) {
    return false;
  }
  return xmlDoc;
}
*/
/*
function oficial_dibujaPicture(pic: Picture, xmlPic: FLDomDocument, pixSize: Size, aDatos: Array)
{

  // debug(xmlPic.toString(4));
  //  var pixSize = this.child("tbnElemento").size;
  debug("Dibujando en " + pixSize.width + " x " + pixSize.height);

  var r: Rect = new Rect(0, 0, pixSize.width, pixSize.height);
  var fAncho = pixSize.width / 100;
  var fAlto = pixSize.height / 100;

  var nodoPic = xmlPic.firstChild();
  var nodos = nodoPic.childNodes();
  if (!nodos) {
    return false;
  }

  var canNodos = nodos.length();
  var eNodo: FLDomElement;
  var sX: String, sY: String, sAlto: String, sAncho: String;
  var x: Number, y: Number, alto: Number, ancho: Number;
  var r: Rect, align: Number, texto: String, estilo: String, campo: String;
  var fs, fnt;
  for (var i = 0; i < canNodos; i++) {
    eNodo = nodos.item(i).toElement();
    switch (eNodo.nodeName()) {
      case "Text": {
        campo = eNodo.firstChild().nodeValue();
        //        texto = this.iface.aDatosElemento_[campo];
        try {
          texto = aDatos[campo];
        } catch (e) {
          texto = campo;
        }
        debug(campo + " = " + texto);
        estilo = eNodo.attribute("style");
        sX = eNodo.attribute("x");
        x = sX.toString().endsWith("%") ? parseInt(parseInt(sX.left(sX.length - 1)) * fAncho) : parseInt(sX);
        sY = eNodo.attribute("y");
        y = sY.toString().endsWith("%") ? parseInt(parseInt(sY.left(sY.length - 1)) * fAlto) : parseInt(sY);
        sAncho = eNodo.attribute("width");
        ancho = sAncho.toString().endsWith("%") ? parseInt(parseInt(sAncho.left(sAncho.length - 1)) * fAncho) : parseInt(sAncho);
        sAlto = eNodo.attribute("height");
        alto = sAlto.toString().endsWith("%") ? parseInt(parseInt(sAlto.left(sAlto.length - 1)) * fAlto) : parseInt(sAlto);
        debug("S " + sX + ", " + sY + ", " + sAncho + ", " + sAlto);
        debug("V " + x + ", " + y + ", " + ancho + ", " + alto);
        r = new Rect(x, y, ancho, alto);
        align = 0;
        switch (eNodo.attribute("halignment")) {
          case "AlignLeft": {
            align = pic.AlignLeft;
            break;
          }
          case "AlignRight": {
            align = pic.AlignRight;
            break;
          }
          case "AlignCenter":
          case "AlignHCenter": {
            align = pic.AlignHCenter;
            break;
          }
          default: {
            if (isNaN(texto)) {
              align = pic.AlignLeft;
            } else {
              align = pic.AlignRight;
            }
            break;
          }
        }
        switch (eNodo.attribute("valignment")) {
          case "AlignTop": {
            align = align | pic.AlignLeft;
            break;
          }
          case "AlignBottom": {
            align = align | pic.AlignBottom;
            break;
          }
          case "AlignCenter":
          case "AlignVCenter":
          default: {
            align = align | pic.AlignVCenter;
          }
        }
        switch (estilo) {
          case "titulo": {
            fs = 18;
            var clr = new Color(0, 0, 255);
            fnt = this.iface.dameFuente("verdana", fs);
            pic.setPen(clr);
            break;
          }
          case "normal": {
            fs = 10;
            var clr = new Color(0, 50, 0);
            fnt = this.iface.dameFuente("verdana", fs);
            pic.setPen(clr);
            break;
          }
        }
        var fm;
        fm = new QFontMetrics(fnt);
        while ((fm.width(texto) > r.width || fm.height() > (r.height + 10)) && fs > 4) {
          fnt.pointSize = --fs;
          fm = new QFontMetrics(fnt);
        }
        pic.setFont(fnt);
        pic.drawText(r, align, texto, -1);
        //      pic.drawRect(r);
        break;
      }
    }
  }
  //  debug("Grabando");
  //  pic.save("/home/arodriguez/prueba.svg", "svg");
  //  debug("GOK");
  return true;
}

function oficial_dibujaTextoPic(r: Rect, texto: String, estilo: String, pic: Picture, alineacion: Number)
{
  debug(r.x + ", " + r.y + ", " + r.width + ", " + r.height);
  var pixSize = this.child("tbnElemento").size;
  switch (estilo) {
    case "titulo": {
      var clr = new Color(0, 0, 255);
      var fnt = this.iface.dameFuente("verdana", 18);
      pic.setPen(clr, 1);
      pic.setFont(fnt);
      break;
    }
    case "normal": {
      var clr = new Color(0, 50, 0);
      var fnt = this.iface.dameFuente("verdana", 10);
      pic.setPen(clr, 1);
      pic.setFont(fnt);
      break;
    }
  }
  pic.drawText(r, alineacion, texto, -1);
  return true;
}
*/
function oficial_dameColor(color: String): Color {
  var rgb = new Array;
  if (!color || color == "")
  {
    rgb = [220, 220, 220];
  } else {
    rgb = color.split(",");
  }

  if (!rgb || rgb.length != 3)
  {
    debug("Error al obtener color " + color);
    rgb = [220, 220, 220];
  }

  var clr = new Color();
  clr.setRgb(rgb[0], rgb[1], rgb[2]);

  return clr;
}

function oficial_dameFuente(family: String, size: Number): Font {
  var clf = new Font();
  if (!family || family == "")
  {
    family = "Arial";
  }
  if (!size || size == "")
  {
    size = 10;
  }

  clf.pointSize = size;
  clf.family = family;

  return clf;
}
// function oficial_cargaXMLElemento(tipo:String, clave:String)
// {
//  var util= new FLUtil;
//
//  var aDatos= this.iface.cargaDatosElemento(tipo, clave);
//  if (!aDatos) {
//    return false;
//  }
//
//  if (!this.iface.cargaSvgElemento(tipo, aDatos)) {
//    return false;
//  }
//
//  return true;
// }

function oficial_cargaSvgElemento(tipo: String, aDatos: Array)
{
  var util = new FLUtil;
  var pixSize = this.child("tbnElemento").size;

  if (this.iface.picElemento_) {
    this.iface.picElemento_.end();
    delete this.iface.picElemento_;
  }
  delete this.iface.xmlElemento_;
  this.iface.xmlElemento_ = new FLDomDocument;
  this.iface.xmlElemento_.setContent("<svg width='100%' height='100%' ><image width='20' x='20' xlink:href='/home/arodriguez/imagenes/map_usa.jpeg' y='20' height='20' /></svg>");
  var eSvg = this.iface.xmlElemento_.firstChild().toElement();
  var eG = this.iface.xmlElemento_.createElement("g");
  eSvg.appendChild(eG);

  switch (tipo) {
    case "clientes": {
      this.iface.dibujaTextoSvg(pixSize.width / 2, 30, aDatos["c.nombre"], "titulo");
      var telefono1 = aDatos["c.telefono1"];
      var telefono2 = aDatos["c.telefono2"];
      var email = aDatos["c.email"];
      var tel = "";
      if (telefono1 && telefono1 != "") {
        tel = util.translate("scripts", "Tel. %1").arg(telefono1);
      }
      if (telefono2 && telefono2 != "") {
        tel += tel == "" ? "" : " - ";
        tel += telefono2;
      }
      if (email && email != "") {
        tel += tel == "" ? "" : " - ";
        tel += util.translate("scripts", "e-Mail %1").arg(email);
      }
      this.iface.dibujaTextoSvg(30, 50, tel, "normal");
      break;
    }
    case "agentes": {
      this.iface.dibujaTextoSvg(pixSize.width / 2, 30, aDatos["a.nombreap"], "titulo");
      var telefono1 = aDatos["a.telefono"];
      var email = aDatos["a.email"];
      var tel = "";
      if (telefono1 && telefono1 != "") {
        tel = util.translate("scripts", "Tel. %1").arg(telefono1);
      }
      if (email && email != "") {
        tel += tel == "" ? "" : " - ";
        tel += util.translate("scripts", "e-Mail %1").arg(email);
      }
      this.iface.dibujaTextoSvg(30, 50, tel, "normal");
      var porComision = util.translate("scripts", "Comisión: %1").arg(util.roundFieldValue(aDatos["a.porcomision"], "agentes", "porcomision") + "%");
      this.iface.dibujaTextoSvg(30, 70, porComision, "normal");
      break;
    }
  }
  debug(this.iface.xmlElemento_.toString(4));
  return true;
}

function oficial_dibujaTextoSvg(x: Number, y: Number, texto: String, idEstilo: String)
{
  var eG = this.iface.xmlElemento_.firstChild().namedItem("g").toElement();
  var estilo: String;
  var eText = this.iface.xmlElemento_.createElement("text");
  eG.appendChild(eText);
  eText.setAttribute("id", "TextElement");
  eText.setAttribute("x", x);
  eText.setAttribute("y", y);
  switch (idEstilo) {
    case "titulo": {
      estilo = "font-family:Verdana;font-size:24;stroke:red";
      eText.setAttribute("text-anchor", "middle");
      break;
    }
    case "normal": {
      estilo = "font-family:Verdana;font-size:10";
      break;
    }
    default: {
      estilo = "font-family:Verdana;font-size:10";
    }
  }
  eText.setAttribute("style", estilo);
  var pixSize = this.child("tbnElemento").size;
  //eText.setAttribute("textLength", pixSize.width);
  //eText.setAttribute("lengthAdjust", "spacingAndGlyphs");
  var tTexto = this.iface.xmlElemento_.createTextNode(texto);
  eText.appendChild(tTexto);
  /*
   <g transform="translate(100,100)">
   <text id="TextElement" x="0" y="0" style="font-family:Verdana;font-size:24"> It's SVG!
   <animateMotion path="M 0 0 L 100 100" dur="5s" fill="freeze"/>
   </text>
   </g>
   */

  return true;
}

/** \D
@return Devuelve un array con dos elementos:
c: Array de índice no numérico con los nombres de los campos que podrán usarse en el picture de elementos relacionados
i: Array de índice numérico con una entrada para cada clave del array c
n: Array de índice numérico con los nombres de campos
\end*/
/*
function oficial_dameArrayCamposElementoRel(tipo: String, relacion: String)
{
  var util = new FLUtil;
  var aDatos = [];
  aDatos["c"] = [];
  aDatos["i"] = [];
  aDatos["n"] = [];
  var tabla = relacion;
  var nombreCampo: String;
  switch (tipo) {
    default: {
      var aCampos = util.nombreCampos(tabla);
      var numCampos = aCampos.shift();
      for (var i = 0; i < aCampos.length; i++) {
        nombreCampo = tabla + "." + aCampos[i];
        aDatos["c"][nombreCampo] = false;
        aDatos["i"][i] = nombreCampo;
        aDatos["n"][i] = util.fieldNameToAlias(aCampos[i], tabla);
      }
    }
  }
  return aDatos;
}
*/
/*
function oficial_cargaValorCamposTabla(tabla: String, clave: String)
{
  var aValores = this.iface.dameValorCamposTabla(tabla, clave);
  if (!aValores) {
    return false;
  }
  this.iface.aDatosElemento_ = aValores;
  return true;
}

function oficial_dameValorCamposTabla(tabla: String, clave: String)
{
  if (this.iface.curElemento_) {
    delete this.iface.curElemento_;
  }
  this.iface.curElemento_ = new FLSqlCursor(tabla);

  var util = new FLUtil;
  var aDatos = [];
  aDatos["c"] = [];
  aDatos["i"] = [];
  var aCampos = util.nombreCampos(tabla);
  var numCampos = aCampos.shift();
  var sCampos = aCampos.join(",");

  var campoPK = this.iface.curElemento_.primaryKey();
  var tipoPK = this.iface.curElemento_.fieldType(campoPK);
  var where: String;
  switch (tipoPK) {
    case this.iface.ftSTRING_:
    case this.iface.ftDATE_: {
      where = campoPK + " = '" + clave + "'";
      break;
    }
    default: {
      where = campoPK + " = " + clave;
    }
  }
  this.iface.curElemento_.select(where);
  if (!this.iface.curElemento_.first()) {
    return false;
  }

  var valor: String, campo: String;
  var iCampo = 0, nombreCampo: String;
  for (var i = 0; i < numCampos; i++) {
    campo = aCampos[i];
    valor = this.iface.curElemento_.valueBuffer(campo);
    // debug("Campo " + campo + " = " + valor + " tipo " + cursor.fieldType(campo));
    switch (this.iface.curElemento_.fieldType(campo)) {
      case this.iface.ftSTRING_: {
        break;
      }
      case this.iface.ftUINT_: {
        break;
      }
      case this.iface.ftDOUBLE_: {
        if (isNaN(valor)) {
          valor = 0;
        }
        valor = util.roundFieldValue(valor, tabla, campo);
        break;
      }
      case this.iface.ftDATE_: {
        if (valor) {
          valor = util.dateAMDtoDMA(valor);
        }
        break;
      }
      case this.iface.ftSERIAL_: {
        break;
      }
      case this.iface.ftUNLOCK_: {
        break;
      }
    }
    nombreCampo = tabla + "." + campo;
    debug("Cargando " + nombreCampo);
    aDatos["c"][nombreCampo] = valor;
    aDatos["i"][iCampo++] = nombreCampo;
  }
  return aDatos;
}
*/
/** \D Incluye un nuevo campo y su valor en los array de datos del elemento actual
\end */
/*
function oficial_cargaCampoArrayDE(campo: String, valor)
{
  this.iface.aDatosElemento_["c"][campo] = valor;
  this.iface.aDatosElemento_["i"][this.iface.aDatosElemento_["i"].length] = campo;
  return true;
}
*/
/*
function oficial_dameTablaElemento(tipo: String)
{
  var aElemento: Array;
  try  {
    aElemento = this.iface.aElementos_[tipo];
  } catch (e) {
    return false;
  }
  return aElemento["tabla"];
}
*/

/*
function oficial_cargaDatosElemento(tipo: String, clave: String)
{
  var util = new FLUtil;
  var aDatos = false;

  if (this.iface.aDatosElemento_) {
    delete this.iface.aDatosElemento_;
    //    delete this.iface.aIndiceDE_;
  }
  this.iface.aDatosElemento_ = [];
  //  this.iface.aIndiceDE_ = [];
  var tabla = this.iface.dameTablaElemento(tipo);
  if (!tabla) {
    return false;
  }

  switch (tipo) {
    case "t1_home": {
      var aDatos = [];
      aDatos["c"] = [];
      aDatos["i"] = [];
      aDatos["c"]["nombre"] = sys.nameUser();
      aDatos["i"][0] = "nombre";
      this.iface.aDatosElemento_ = aDatos;
      break;
    }
    case "clientes": {
      if (!this.iface.cargaValorCamposTabla(tabla, clave)) {
        return false;
      }
      //      aDatos = flfactppal.iface.pub_ejecutarQry("clientes c LEFT OUTER JOIN dirclientes dc ON (c.codcliente = dc.codcliente AND dc.domfacturacion = true) LEFT OUTER JOIN paises p ON dc.codpais = p.codpais", "c.nombre,c.codcliente,c.cifnif,c.email,c.contacto,c.telefono1,c.telefono2,dc.direccion,dc.ciudad,dc.codpostal,dc.provincia,p.nombre", "c.codcliente = '" + clave + "'", "clientes,dirclientes,paises");
      break;
    }
    case "agentes": {
      if (!this.iface.cargaValorCamposTabla(tabla, clave)) {
        return false;
      }
      break;
    }
    case "presupuestoscli": {
      if (!this.iface.cargaValorCamposTabla(tabla, clave)) {
        return false;
      }
      var aprobado = this.iface.aDatosElemento_["c"]["presupuestoscli.editable"] ? util.translate("scripts", "Por aprobar") : util.translate("scripts", "Aprobado");
      if (!this.iface.cargaCampoArrayDE("aprobado", aprobado)) {
        return false;
      }
      break;
    }
    case "pedidoscli": {
      if (!this.iface.cargaValorCamposTabla(tabla, clave)) {
        return false;
      }
      break;
    }
    case "albaranescli": {
      if (!this.iface.cargaValorCamposTabla(tabla, clave)) {
        return false;
      }
      break;
    }
    case "facturascli": {
      if (!this.iface.cargaValorCamposTabla(tabla, clave)) {
        return false;
      }
      break;
    }
    case "reciboscli": {
      if (!this.iface.cargaValorCamposTabla(tabla, clave)) {
        return false;
      }
      break;
    }
    default: {
      if (!this.iface.cargaValorCamposTabla(tabla, clave)) {
        return false;
      }
    }
  }
  return true;
}
*/
/*
function oficial_cargaAccionesRel(iRel)
{
  var aRelacion = this.iface.aRelaciones_[iRel];

  var qryAcciones = new FLSqlQuery;
  qryAcciones.setTablesList("t1_accioneselemento");
  qryAcciones.setSelect("accion, funcion, icono, tecla");
  qryAcciones.setFrom("t1_accioneselemento");
  qryAcciones.setWhere("elemento = '" + aRelacion["nombre"] + "'");
  qryAcciones.setForwardOnly(true);
  if (!qryAcciones.exec()) {
    return false;
  }
  var iAccion = 0;
  //  this.iface.eliminarAccels();
  delete this.iface.aAccionesRel_;
  this.iface.aAccionesRel_ = new Array(qryAcciones.size());
  var tecla: String;
  while (qryAcciones.next()) {
    tecla = qryAcciones.value("tecla");
    this.iface.aAccionesRel_[iAccion] = [];
    this.iface.aAccionesRel_[iAccion]["nombre"] = qryAcciones.value("accion");
    this.iface.aAccionesRel_[iAccion]["funcion"] = qryAcciones.value("funcion");
    this.iface.aAccionesRel_[iAccion]["icono"] = qryAcciones.value("icono");
    this.iface.aAccionesRel_[iAccion]["tecla"] = tecla;
    debug("tecla = " + tecla);
    //    this.iface.aAccionesRel_[iAccion]["accel"] = (tecla && tecla != "") ? this.child("fdbBuscar").insertAccel("Ctrl+" + tecla) : 0;
    iAccion++;
  }
  return true;
}
*/
/*
function oficial_borrarForm()
{
  debug("Borrando form");
  disconnect(this.iface.f_, "closed()", this, "iface.borrarForm");
  debug("Borrando form 2");
  this.iface.f_ = false;
  debug("Borrando form OK");
}
*/
/*
function oficial_dameFiltroPrincipal(clausulaWhere: String, clave: String)
{
  if (!clausulaWhere || clausulaWhere == "") {
    return "";
  }
  var sqlWhere = clausulaWhere.replace("#PK#", clave);
  var sqlWhere = sqlWhere.replace("#YO#", sys.nameUser());
  var posAl = sqlWhere.find("#");
  var posAl2: Number, campo: String;
  while (posAl > -1) {
    posAl2 = sqlWhere.find("#", posAl + 1);
    if (posAl2 > -1) {
      campo = sqlWhere.substring(posAl + 1, posAl2);
      sqlWhere = sqlWhere.replace("#" + campo + "#", this.iface.curElemento_.valueBuffer(campo));
    }
    posAl = sqlWhere.find("#", posAl + 1);
  }
  return sqlWhere;
}
*/
/** \D Compone un texto sustituyendo marcas por sus valores
@param  textoBase: Texto con marcas
@param  aDatos: Array de datos
@return texto compuesto
\end */
/*
function oficial_componTextoRel(textoBase: String, aDatos: Array)
{
  if (!textoBase || textoBase == "") {
    return "";
  }
  var texto = textoBase;
  //  var sqlWhere= clausulaWhere.replace("#PK#", clave);
  var posAl = texto.find("#");
  var posAl2: Number, campo: String;
  while (posAl > -1) {
    posAl2 = texto.find("#", posAl + 1);
    if (posAl2 > -1) {
      campo = texto.substring(posAl + 1, posAl2);
      try {
        texto = texto.replace("#" + campo + "#", aDatos["c"][campo]);
      } catch (e) {
        posAl = posAl2;
      }
    }
    posAl = texto.find("#", posAl + 1);
  }
  return texto;
}
*/
/** \C Obtiene el nombre de un elemento
Se toma del campo descripción del array del elemento. El campo debe contener los valores de campos de la tabla del elemento.
\end */
/*
function oficial_dameNombreElemento(tipo: String, clave: String)
{
  var aElemento = this.iface.aElementos_[tipo];
  var descripcion = aElemento["descripcion"];
  if (!descripcion || descripcion == "") {
    return "";
  }
  var tabla = this.iface.dameTablaElemento(tipo);
  if (!tabla) {
    return "";
  }
  var aCampos = descripcion.split(",");
  var nombre = "";
  for (var i = 0; i < aCampos.length; i++) {
    nombre += (i > 0 ? " - " : "");
    try {
      nombre += this.iface.aDatosElemento_["c"][tabla + "." + aCampos[i]];
    } catch (e) {}
  }
  return nombre;
}
*/

/*
function oficial_muestraElementosRel(tipo: String, clave: String, iRel: Number)
{
  var util = new FLUtil;

  var relacion = this.iface.aRelaciones_[iRel]["nombre"];
  if (this.iface.f_ && this.iface.f_.mainWidget()) {
    this.iface.posF_ = this.iface.f_.parentWidget().geometry;
    if (this.iface.f_.cursor().action() != relacion) {
      this.iface.f_.close();
      this.iface.f_ = false;
      debug("Closed por código oK");

      sys.openMasterForm(relacion)
    }
  } else {
    sys.openMasterForm(relacion)
  }

  try {
    this.iface.f_ = eval("form" + relacion);
  } catch (e) {}
  if (!this.iface.f_) {
    return;
  }
  var f = this.iface.f_;
  var cursor = f.cursor();
  if (cursor.table() == "") {
    return false;
  }
  var tablaRel = this.iface.dameTablaElemento(relacion);
  var aCols = this.iface.aRelaciones_[iRel]["orderCols"];
  var filtroPpal = this.iface.aRelaciones_[iRel]["filtroPpal"];
  var filtro = this.iface.aRelaciones_[iRel]["filtro"];
  var titulo = util.tableNameToAlias(tablaRel);
  var nombreElemento = this.iface.dameNombreElemento(tipo, clave);
  if (nombreElemento != "") {
    titulo += " " + util.translate("scripts", "para") + " " + nombreElemento;
  }
  debug("filtroPpal = " + filtroPpal);
  if (filtroPpal) {
    cursor.setMainFilter(filtroPpal);
  } else {
    cursor.setMainFilter("");
  }
  if (aCols) {
    f.child("tableDBRecords").setOrderCols(aCols);
  }
  debug("filtro = " + filtro);
  if (filtro) {
    f.child("tableDBRecords").setFilter(filtro);
  } else {
    f.child("tableDBRecords").setFilter("");
  }
  f.child("tableDBRecords").refresh(true, true);
  if (titulo != "") {
    f.obj().setCaption(titulo);
  }
  if (this.iface.posF_) {
    debug(" X = " + this.iface.posF_.x + " Y = " + this.iface.posF_.y + " W = " + this.iface.posF_.width + " H = " + this.iface.posF_.height);
    f.parentWidget().setGeometry(this.iface.posF_);
  }
  return true;

  //  if (!this.iface.cargaAccionesRel(iRel)) {
  //    return false;
  //  }
  //  if (!this.iface.muestraAccionesRel()) {
  //    return false;
  //  }


}
*/

// function oficial_muestraElementosRel3(tipo:String, clave:String, iRel:Number)
// {
//  if (!this.iface.cargaAccionesRel(iRel)) {
//    return false;
//  }
//  if (!this.iface.muestraAccionesRel()) {
//    return false;
//  }
//  var relacion= this.iface.aRelaciones_[iRel]["nombre"];
//
//  this.iface.tdbTabla_.setTableName(relacion);
//  this.iface.tdbTabla_.cursor().setAction(relacion);
//  var aCols= false;
//  var filtro= false;
//  switch (tipo) {
//    case "clientes": {
//      switch (relacion) {
//        case "facturascli": {
//          aCols = ["fecha", "total", "editable"];
//          var codEjercicio= flfactppal.iface.pub_ejercicioActual();
//          filtro = "codcliente = '" + clave + "' AND codejercicio = '" + codEjercicio + "'";
//          break;
//        }
//        case "albaranescli": {
//          aCols = ["fecha", "total", "ptefactura"];
//          var codEjercicio= flfactppal.iface.pub_ejercicioActual();
//          filtro = "codcliente = '" + clave + "' AND codejercicio = '" + codEjercicio + "'";
//          break;
//        }
//        case "pedidoscli": {
//          aCols = ["fecha", "total", "servido", "editable"];
//          var codEjercicio= flfactppal.iface.pub_ejercicioActual();
//          filtro = "codcliente = '" + clave + "' AND codejercicio = '" + codEjercicio + "'";
//          break;
//        }
//        case "presupuestoscli": {
//          aCols = ["fecha", "total", "editable"];
//          var codEjercicio= flfactppal.iface.pub_ejercicioActual();
//          filtro = "codcliente = '" + clave + "' AND codejercicio = '" + codEjercicio + "'";
//          break;
//        }
//      }
//      break;
//    }
//    case "agentes": {
//      switch (relacion) {
//        case "facturascli": {
//          aCols = ["fecha", "total", "porcomision"];
//          var codEjercicio= flfactppal.iface.pub_ejercicioActual();
//          filtro = "codagente = '" + clave + "' AND codejercicio = '" + codEjercicio + "'";
//          break;
//        }
//      }
//      break;
//    }
//  }
//  if (filtro) {
//    this.iface.tdbTabla_.cursor().setMainFilter(filtro);
//  }
//  this.iface.tdbTabla_.refresh(true, true);
//  if (aCols) {
//    this.iface.tdbTabla_.setOrderCols(aCols);
//  }
//  this.iface.tdbTabla_.refresh();
// }

// function oficial_muestraElementosRel2(tipo:String, clave:String, iRel:Number)
// {
//  var util= new FLUtil;
//
//  var relacion= this.iface.aRelaciones_[iRel]["nombre"];
//  this.iface.tblElementosRel_.setNumRows(0);
//  var qryRel:FLSqlQuery;
//  switch (tipo) {
//    case "clientes": {
//      switch (relacion) {
//        case "facturascli": {
//          var aDatos= this.iface.dameArrayCamposElementoRel(tipo, relacion);
//          if (!aDatos) {
//            return false;
//          }
//          var aCampos= util.nombreCampos(relacion);
//          var numCampos= aCampos.shift();
//          qryRel.setTablesList("facturascli");
//          qryRel.setSelect(aCampos.join(", "));
//          qryRel.setFrom("facturascli");
//          qryRel.setWhere("codcliente = '" + clave + "'");
//          qryRel.setForwardOnly(true);
//          if (!qryRel.exec()) {
//            return false;
//          }
//          var iFila= 0;
//          while (qryRel.next()) {
//            for (var i= 0; i < numCampos; i++) {
//              aDatos["c"][aDatos["i"][i]] = qryRel.value(aCampos[i]);
//            }
//            this.iface.tblElementosRel_.insertRows(iFila);
//            this.iface.tblElementosRel_.setRowHeight(iFila, 32);
//            this.iface.tblElementosRel_.setText(iFila, this.iface.CER_IDREL, iRel);
//            this.iface.tblElementosRel_.setText(iFila, this.iface.CER_TIPO, "facturascli");
//            this.iface.tblElementosRel_.setText(iFila, this.iface.CER_CLAVE, qryRel.value("idfactura"));
//            if (!this.iface.dibujaPixmapElementoRel(this.iface.tblElementosRel_, iFila, this.iface.CER_DES, aDatos["c"], iRel)) {
//              return false;
//            }
//
//            this.iface.dibujarIconoTabla(this.iface.tblElementosRel_, iFila, this.iface.CER_ICONO, "facturascli");
//            iFila++;
//          }
//          break;
//        }
//        case "albaranescli": {
//          qryRel.setTablesList("albaranescli");
//          qryRel.setSelect("idalbaran, codigo, fecha, total, ptefactura");
//          qryRel.setFrom("albaranescli");
//          qryRel.setWhere("codcliente = '" + clave + "'");
//          qryRel.setForwardOnly(true);
//          if (!qryRel.exec()) {
//            return false;
//          }
//          var iFila= 0;
//          while (qryRel.next()) {
//            this.iface.tblElementosRel_.insertRows(iFila);
//            this.iface.tblElementosRel_.setRowHeight(iFila, 32);
//            this.iface.tblElementosRel_.setText(iFila, this.iface.CER_TIPO, "albaranescli");
//            this.iface.tblElementosRel_.setText(iFila, this.iface.CER_CLAVE, qryRel.value("idalbaran"));
//            this.iface.tblElementosRel_.setText(iFila, this.iface.CER_DES, util.translate("scripts", "%1 - %2 - %3").arg(qryRel.value("codigo")).arg(util.dateAMDtoDMA(qryRel.value("fecha"))).arg(qryRel.value("total")))
//            this.iface.dibujarIconoTabla(this.iface.tblElementosRel_, iFila, this.iface.CER_ICONO, "albaranescli");
//            iFila++;
//          }
//          break;
//        }
//        case "pedidoscli": {
//          qryRel.setTablesList("pedidoscli");
//          qryRel.setSelect("idpedido, codigo, fecha, total, editable");
//          qryRel.setFrom("pedidoscli");
//          qryRel.setWhere("codcliente = '" + clave + "'");
//          qryRel.setForwardOnly(true);
//          if (!qryRel.exec()) {
//            return false;
//          }
//          var iFila= 0;
//          while (qryRel.next()) {
//            this.iface.tblElementosRel_.insertRows(iFila);
//            this.iface.tblElementosRel_.setRowHeight(iFila, 32);
//            this.iface.tblElementosRel_.setText(iFila, this.iface.CER_TIPO, "pedidoscli");
//            this.iface.tblElementosRel_.setText(iFila, this.iface.CER_CLAVE, qryRel.value("idpedido"));
//            this.iface.tblElementosRel_.setText(iFila, this.iface.CER_DES, util.translate("scripts", "%1 - %2 - %3").arg(qryRel.value("codigo")).arg(util.dateAMDtoDMA(qryRel.value("fecha"))).arg(qryRel.value("total")))
//            this.iface.dibujarIconoTabla(this.iface.tblElementosRel_, iFila, this.iface.CER_ICONO, "pedidoscli");
//            iFila++;
//          }
//          break;
//        }
//        case "presupuestoscli": {
//          qryRel.setTablesList("presupuestoscli");
//          qryRel.setSelect("idpresupuesto, codigo, fecha, total, editable");
//          qryRel.setFrom("presupuestoscli");
//          qryRel.setWhere("codcliente = '" + clave + "'");
//          qryRel.setForwardOnly(true);
//          if (!qryRel.exec()) {
//            return false;
//          }
//          var iFila= 0;
//          while (qryRel.next()) {
//            this.iface.tblElementosRel_.insertRows(iFila);
//            this.iface.tblElementosRel_.setRowHeight(iFila, 32);
//            this.iface.tblElementosRel_.setText(iFila, this.iface.CER_TIPO, "presupuestoscli");
//            this.iface.tblElementosRel_.setText(iFila, this.iface.CER_CLAVE, qryRel.value("idpresupuesto"));
//            this.iface.tblElementosRel_.setText(iFila, this.iface.CER_DES, util.translate("scripts", "%1 - %2 - %3").arg(qryRel.value("codigo")).arg(util.dateAMDtoDMA(qryRel.value("fecha"))).arg(qryRel.value("total")))
//            this.iface.dibujarIconoTabla(this.iface.tblElementosRel_, iFila, this.iface.CER_ICONO, "presupuestoscli");
//            iFila++;
//          }
//          break;
//        }
//      }
//      break;
//    }
//    case "facturascli": {
//      switch (relacion) {
//        case "reciboscli": {
//          qryRel.setTablesList("reciboscli");
//          qryRel.setSelect("idrecibo, codigo, fecha, importe, estado");
//          qryRel.setFrom("reciboscli");
//          qryRel.setWhere("idfactura = " + clave);
//          qryRel.setForwardOnly(true);
//          if (!qryRel.exec()) {
//            return false;
//          }
//          var iFila= 0;
//          while (qryRel.next()) {
//            this.iface.tblElementosRel_.insertRows(iFila);
//            this.iface.tblElementosRel_.setRowHeight(iFila, 32);
//            this.iface.tblElementosRel_.setText(iFila, this.iface.CER_TIPO, "reciboscli");
//            this.iface.tblElementosRel_.setText(iFila, this.iface.CER_CLAVE, qryRel.value("idrecibo"));
//            this.iface.tblElementosRel_.setText(iFila, this.iface.CER_DES, util.translate("scripts", "%1 - %2 - %3").arg(qryRel.value("codigo")).arg(util.dateAMDtoDMA(qryRel.value("fecha"))).arg(qryRel.value("importe")))
//            iFila++;
//          }
//          break;
//        }
//      }
//      break;
//    }
//    case "agentes": {
//      switch (relacion) {
//        case "clientes": {
//          qryRel.setTablesList("clientes");
//          qryRel.setSelect("codcliente, nombre");
//          qryRel.setFrom("clientes");
//          qryRel.setWhere("codagente = '" + clave + "'");
//          qryRel.setForwardOnly(true);
//          if (!qryRel.exec()) {
//            return false;
//          }
//          var iFila= 0;
//          while (qryRel.next()) {
//            this.iface.tblElementosRel_.insertRows(iFila);
//            this.iface.tblElementosRel_.setRowHeight(iFila, 32);
//            this.iface.tblElementosRel_.setText(iFila, this.iface.CER_TIPO, "clientes");
//            this.iface.tblElementosRel_.setText(iFila, this.iface.CER_CLAVE, qryRel.value("codcliente"));
//            this.iface.tblElementosRel_.setText(iFila, this.iface.CER_DES, util.translate("scripts", "%1 - %2").arg(qryRel.value("codcliente")).arg(qryRel.value("nombre")));
//            this.iface.dibujarIconoTabla(this.iface.tblElementosRel_, iFila, this.iface.CER_ICONO, "clientes");
//            iFila++;
//          }
//          break;
//        }
//      }
//      break;
//    }
//  }
//  return true;
// }

/*
function oficial_refrescaRelacion(nombre: String)
{
  var iFila: Number;
  if (nombre) {
    iFila = this.iface.dameFilaRelacion(nombre);
  } else {
    iFila = this.iface.tblRelaciones_.currentRow();
    nombre = this.iface.tblRelaciones_.text(iFila, this.iface.CR_TIPO);
  }
  if (iFila < 0) {
    return false;
  }
  var iRel = this.iface.tblRelaciones_.text(iFila, this.iface.CR_IDREL);

  var aElemento = this.iface.aHistorialElementos_[this.iface.iElementoHistorial_];

  var aDatosRel = this.iface.dameDatosRelacion(aElemento["tipo"], aElemento["clave"], iRel);
  if (aDatosRel) {
    var textoRel = this.iface.componTextoRel(this.iface.aRelaciones_[iRel]["textoRel"], aDatosRel);
    this.iface.tblRelaciones_.setText(iFila, this.iface.CR_DESC, textoRel);
  }
}
*/
/*
function oficial_dameIndiceRelacion(nombre: String)
{
  if (!this.iface.aRelaciones_) {
    return -1;
  }
  for (var i = 0; i < this.iface.aRelaciones_.length; i++) {
    if (this.iface.aRelaciones_[i]["nombre"] == nombre) {
      return i;
    }
  }
  return -1;
}

function oficial_dameFilaRelacion(nombre: String)
{
  var canFilas = this.iface.tblRelaciones_.numRows();
  for (var i = 0; i < canFilas; i++) {
    if (this.iface.tblRelaciones_.text(i, this.iface.CR_TIPO) == nombre) {
      return i;
    }
  }
  return -1;
}
*/
/*
function oficial_generarFacturaCli(tipo: String, clave: String)
{
  var acciones = [];
  acciones[0] = flcolaproc.iface.pub_arrayAccion("facturascli", "ponCliente");
  acciones[0]["codcliente"] = clave;
  acciones[1] = flcolaproc.iface.pub_arrayAccion("facturascli", "sal");
  acciones[2] = flcolaproc.iface.pub_arrayAccion("facturascli", "llamaFuncion");
  acciones[2]["funcion"] = "formt1_principal.iface.refrescaRelacion(\"facturascli\");";

  flcolaproc.iface.pub_setAccionesAuto(acciones);

  delete this.iface.curObjeto_;
  this.iface.curObjeto_ = new FLSqlCursor("facturascli");
  this.iface.curObjeto_.insertRecord();
  return true;
}
*/
/*
function oficial_imprimirDocumento(tipo: String, clave: String)
{
  var util = new FLUtil;
  switch (tipo) {
    case "facturascli": {
      var codFactura = util.sqlSelect("facturascli", "codigo", "idfactura = '" + clave + "'");
      if (!codFactura) {
        return false;
      }
      formfacturascli.iface.pub_imprimir(codFactura);
      break;
    }
  }
  return true;
}

function oficial_aprobarPresupuestoCli(tipo: String, clave: String)
{
  var util = new FLUtil;

  delete this.iface.curObjeto_;
  this.iface.curObjeto_ = new FLSqlCursor("presupuestoscli");
  this.iface.curObjeto_.select("idpresupuesto = " + clave);
  if (!this.iface.curObjeto_.first()) {
    return false;
  }

  if (formpresupuestoscli.iface.pub_generarPedidoTrans(this.iface.curObjeto_)) {
    this.iface.refrescaRelacion("pedidoscli");
  }
  return true;
}


function oficial_servirPedidoCli(tipo: String, clave: String)
{
  var util = new FLUtil;
  this.iface.curObjeto_ = new FLSqlCursor("pedidoscli");
  this.iface.curObjeto_.select("idpedido = " + clave);
  if (!this.iface.curObjeto_.first()) {
    return false;
  }

  if (formpedidoscli.iface.pub_generarAlbaranTrans(this.iface.curObjeto_)) {
    this.iface.refrescaRelacion("albaranescli");
  }
  return true;
}
*/
/*
function oficial_facturarAlbaranCli(tipo: String, clave: String)
{
  var util = new FLUtil;
  this.iface.curObjeto_ = new FLSqlCursor("albaranescli");
  this.iface.curObjeto_.select("idalbaran = " + clave);
  if (!this.iface.curObjeto_.first()) {
    return false;
  }

  if (formalbaranescli.iface.pub_generarFacturaTrans(this.iface.curObjeto_)) {
    this.iface.tdbTabla_.refresh();
    this.iface.refrescaRelacion("facturascli");
  }
  return true;
}

function oficial_generarAlbaranCli(tipo: String, clave: String)
{
  var acciones = [];
  acciones[0] = flcolaproc.iface.pub_arrayAccion("albaranescli", "ponCliente");
  acciones[0]["codcliente"] = clave;
  acciones[1] = flcolaproc.iface.pub_arrayAccion("albaranescli", "sal");
  acciones[2] = flcolaproc.iface.pub_arrayAccion("albaranescli", "llamaFuncion");
  acciones[2]["funcion"] = "formt1_principal.iface.refrescaRelacion(\"albaranescli\");";

  flcolaproc.iface.pub_setAccionesAuto(acciones);

  delete this.iface.curObjeto_;
  this.iface.curObjeto_ = new FLSqlCursor("albaranescli");
  this.iface.curObjeto_.insertRecord();
  return true;
}

function oficial_generarPedidoCli(tipo: String, clave: String)
{
  var acciones = [];
  acciones[0] = flcolaproc.iface.pub_arrayAccion("pedidoscli", "ponCliente");
  acciones[0]["codcliente"] = clave;
  acciones[1] = flcolaproc.iface.pub_arrayAccion("pedidoscli", "sal");
  acciones[2] = flcolaproc.iface.pub_arrayAccion("pedidoscli", "llamaFuncion");
  acciones[2]["funcion"] = "formt1_principal.iface.refrescaRelacion(\"pedidoscli\");";

  flcolaproc.iface.pub_setAccionesAuto(acciones);

  delete this.iface.curObjeto_;
  this.iface.curObjeto_ = new FLSqlCursor("pedidoscli");
  this.iface.curObjeto_.insertRecord();
  return true;
}

function oficial_generarPresupuestoCli(tipo: String, clave: String)
{
  var acciones = [];
  acciones[0] = flcolaproc.iface.pub_arrayAccion("presupuestoscli", "ponCliente");
  acciones[0]["codcliente"] = clave;
  acciones[1] = flcolaproc.iface.pub_arrayAccion("presupuestoscli", "sal");
  acciones[2] = flcolaproc.iface.pub_arrayAccion("presupuestoscli", "llamaFuncion");
  acciones[2]["funcion"] = "formt1_principal.iface.refrescaRelacion(\"presupuestoscli\");";

  flcolaproc.iface.pub_setAccionesAuto(acciones);

  delete this.iface.curObjeto_;
  this.iface.curObjeto_ = new FLSqlCursor("presupuestoscli");
  this.iface.curObjeto_.insertRecord();
  return true;
}
*/
function oficial_guardaElementoHistorial(tipo, clave)
{
  var aElemento = [];
  aElemento["tipo"] = tipo;
  aElemento["clave"] = clave;

  this.iface.iElementoHistorial_++;
  if (this.iface.aHistorialElementos_.length > this.iface.iElementoHistorial_) {
    var dif = this.iface.aHistorialElementos_.length - this.iface.iElementoHistorial_;
    this.iface.aHistorialElementos_.splice(this.iface.iElementoHistorial_, dif);
  }
  this.iface.aHistorialElementos_[this.iface.iElementoHistorial_] = aElemento;

  return true;
}

function oficial_ponElementoActual(tipo, clave)
{
  var _i = this.iface;
  if (!_i.guardaElementoHistorial(tipo, clave)) {
    return false;
  }
  if (!_i.actualizaDatosForm()) {
    return false;
  }
  return true;
}

function oficial_tbnElementoPrevio_clicked()
{
  if (this.iface.iElementoHistorial_ > 0) {
    this.iface.iElementoHistorial_--;
  }
  if (!this.iface.actualizaDatosForm()) {
    return false;
  }
}

function oficial_tbnElementoSiguiente_clicked()
{
  if ((this.iface.iElementoHistorial_ + 1) < this.iface.aHistorialElementos_.length) {
    this.iface.iElementoHistorial_++;
  }
  if (!this.iface.actualizaDatosForm()) {
    return false;
  }
}

/** \D la pulsación en el botón del elemento actual lanza el formulario de edición de dicho elemento
\end */
/*
function oficial_tbnElemento_clicked()
{
  this.iface.editarElementoSel();
}
*/
function oficial_actualizaDatosForm()
{
  var _i = this.iface;
  var aElemento = _i.dameElementoActual();
  debug("Tipo " + aElemento.tipo);
  if (aElemento.tipo == "t1_busq") {
    _i.cambiaModo("busqueda");
    _i.buscar(aElemento.clave);
  } else {
    _i.cambiaModo("visualizacion");
    if (!_i.muestraDashboard()) {
      return false;
    }
  }
  return true;
}

function oficial_muestraDashboard()
{
  var _i = this.iface;
  _i.borraWidgetsDashboard();

  var aElemento = _i.dameElementoActual();

  _i.curObjetoActual_ = new FLSqlCursor(aElemento.tipo);
  _i.curObjetoActual_.select(_i.curObjetoActual_.primaryKey() + " = '" + aElemento.clave + "'");
  if (!_i.curObjetoActual_.first()) {
    return;
  }

  var accion = aElemento.tipo;
  debug("accion " + accion);
  debug(_i.xmlActions_.toString(4));
  var eAction = _i.dameElementoXML(_i.xmlActions_.firstChild(), "action[@name=" + accion + "]");
  var iconFile = "noicon.png", title = "";
  if (eAction && !eAction.isNull()) {
    title = _i.curObjetoActual_.valueBuffer(eAction.attribute("title"));
    iconFile = eAction.attribute("icon");
    iconFie = iconFile == "" ? "noicon.png" : iconFile;
    //    iconFile = = "48x48/" + iconFile;
  }
  this.child("lblPosActual").text = title;
  var px = new QPixmap(_i.imgPath_ + iconFile);
  this.child("lblImgActual").pixmap = px;

  var px = new QPixmap(_i.imgPath_ + "128x128/" + iconFile);
  this.child("lblImgActualG").pixmap = px;


  /// XXXXX
  _i.cargaWidgetsDB(accion);
  _i.cargaWidgetsDB2(accion);
}

function oficial_cargaWidgetsDB(accion, idWidget)
{
  var _i = this.iface;
  var where = "";
  where += accion ? "db.accion = '" + accion + "'" : "";
  if (idWidget) {
    where += where != "" ? " AND " : "";
    where += "e.idelementodb = " + idWidget;
  }
  var qElementos = new FLSqlQuery;
  qElementos.setSelect("e.xmlelemento, e.nombre, e.idelementodb");
  qElementos.setFrom("t1_dashboardusuario db INNER JOIN  t1_elementosdb e ON db.iddashboardusr = e.iddashboardusr");
  qElementos.setWhere(where);
  qElementos.setForwardOnly(true);
  debug(qElementos.sql());
  if (!qElementos.exec()) {
    return false;
  }
  var xmlE, id, widgetName, iW = 0, w;
  while (qElementos.next()) {
    xmlE = new QDomDocument();
    if (!xmlE.setContent(qElementos.value("e.xmlelemento"))) {
      return false;
    }

    id = qElementos.value("e.idelementodb")
         debug("id " + id);

    xmlWidget = xmlE.firstChild();
    var ABNClass = xmlWidget.nodeName();
    switch (ABNClass) {
      case "ABNFastTable": {
        widgetName = "FT" + id.toString();
        w = new ABNFastTable(this.mainWidget(), widgetName, xmlWidget, _i.curObjetoActual_);
        break;
      }
      case "ABNFastFields": {
        widgetName = "FF" + id.toString();
        w = new ABNFastFields(this.mainWidget(), widgetName, xmlWidget, _i.curObjetoActual_);
        break;
      }
      case "ABNMethodSet": {
        widgetName = "MS" + id.toString();
        w = new ABNMethodSet(this.mainWidget(), widgetName, xmlWidget, _i.curObjetoActual_);
        break;
      }
      case "ABN2DChart": {
        continue;
        widgetName = "2C" + id.toString();
        w = new ABN2DChart(this.mainWidget(), widgetName, xmlWidget, _i.curObjetoActual_);
        break;
      }
      default: {
        continue;
        continue;
      }
    }
    _i.cargaWidgetDashboard(w, widgetName)
  }
  return;
}

function oficial_cargaWidgetsDB2(accion, idWidget)
{
  var _i = this.iface;
  var where = "accion = '" + accion + "' AND usuario = '" + sys.nameUser() + "'";
  var qElementos = new AQSqlQuery;
  qElementos.setSelect("idwidget, nombre, config, accionrel, tipo");
  qElementos.setFrom("t1_widgetsusuario");
  qElementos.setWhere(where);
  debug(qElementos.sql());
  if (!qElementos.exec()) {
    return false;
  }
  var xmlUW, xmlW, id, widgetName, iW = 0, w, nombre;
  var oConfig, iW = 0, c;
  while (qElementos.next()) {
    debug("Tipo " + qElementos.value("tipo"));
    iW++;
    nombre = qElementos.value("nombre");
    config = qElementos.value("config");
    if (config && config != "") {
      xmlUW = new FLDomDocument();
      if (!xmlUW.setContent(qElementos.value("config"))) {
        return false;
      }
    } else {
      xmlUW = undefined;
    }
    oConfig = new Object;
    oConfig.id = qElementos.value("idwidget");
    oConfig.accion = accion;
    oConfig.accionRel = qElementos.value("accionrel");
    oConfig.xml = xmlUW;
    oConfig.cur = _i.curObjetoActual_;

    switch (qElementos.value("tipo")) {
      case "ABNFastTable": {
        widgetName = "FT" + nombre + "_" + iW;
        w = new ABNFastTable2(this.mainWidget(), widgetName, oConfig);
        break;
      }
      case "ABNMethodSet": {
        widgetName = "MS" + nombre + "_" + iW;
        w = new ABNMethodSet2(this.mainWidget(), widgetName, oConfig);
        break;
      }
      default: {
        continue;
      }
    }
    _i.cargaWidgetDashboard(w, widgetName)
  }
  return;
}

function oficial_cargaConfigFastTable(accion, accionRel, xmlUW)
{
  var _i = this.iface;
  var o = new Object;
  o.accion = accion;
  o.accionRel = accionRel;
  o.titulo = _i.tituloFastTable(accion, accionRel, xmlUW);
  o.q = _i.queryFastTable(accionRel, accion, xmlUW);
  o.cols = _i.colsFastTable(accionRel, accion, xmlUW, o.q);
  o.geo = _i.geoFastTable(accionRel, accion, xmlUW, o.q);
  o.xmlUW = xmlUW;
  return o;
}

function oficial_geoFastTable(accionRel, accion, xmlUW, q)
{
  var _i = this.iface;
  var g = new Object;
  if (xmlUW) {
    var eGeo = xmlUW.firstChild().namedItem("geo").toElement();
    g.x = eGeo.attribute("x");
    g.y = eGeo.attribute("y");
    g.w = eGeo.attribute("width");
    g.h = eGeo.attribute("height");
  } else {
    g.x = 20;
    g.y = 20;
    g.w = 300;
    g.h = 200;
  }
  return g;
}

function oficial_tituloFastTable(tabla, tablaRel, xmlUW)
{
  var _i = this.iface;
  var _mgr = _i.mgr_;
  var mtd = _mgr.metadata(tablaRel ? tablaRel : tabla);
  return mtd.alias();
}

function oficial_colsFastTable(tabla, tablaRel, xmlUW, q)
{
  /// Cargar columnas de xmlUW, si las hay. Esto es por si no lo hay
  var _i = this.iface;
  var cols = [];
  var c = 0;

  if (xmlUW) {
    var eCols = xmlUW.firstChild().namedItem("cols").toElement();
    var eCol;
    for (var xCol = eCols.firstChild(); !xCol.isNull(); xCol = xCol.nextSibling()) {
      eCol = xCol.toElement();
      cols[c] = _i.colFastTable();
      cols[c].type = eCol.attribute("type");
      cols[c].method = eCol.attribute("method");
      cols[c].field = eCol.attribute("field");
      cols[c].width = eCol.attribute("width");
      c++;
    }
  } else {
    var s = q.select();
    var aS = s.split(",");
    for (var i = 0; i < aS.length; i++) {
      cols[c] = _i.colFastTable();
      cols[c].field = aS[i];
      c++;
    }
    cols[c] = _i.colFastTable();
    cols[c].type = "method";
    cols[c].method = "editRecord";
  }
  return cols;
}


function oficial_colFastTable()
{
  var c = new Object;
  c.type = "field";
  c.field = undefined;
  c.method = undefined;
  c.alias = undefined;
  c.width = undefined;

  return c;
}



function oficial_queryFastTable(tabla, tablaRel, xmlUW)
{
  /// Función a sobrecargar
  var _i = this.iface;
  var s, f, w;
  switch (tabla) {
    default: {
      s = _i.selectFastTable(tabla, tablaRel, xmlUW);
      if (!s) {
        return false;
      }
      f = _i.fromFastTable(tabla, tablaRel);
      if (!f) {
        return false;
      }
      w = _i.whereFastTable(tabla, tablaRel, xmlUW);
      if (!w) {
        return false;
      }
      break;
    }
  }
  var q = new AQSqlQuery;
  q.setSelect(s);
  q.setFrom(f);
  q.setWhere(w);
  return q;
}

function oficial_whereFastTable(tabla, tablaRel, xmlUW)
{
  var _i = this.iface;

  var eRel = _i.dameElementoXML(_i.xmlActions_.firstChild(), "action[@name=" + tabla + "]/relations/relation[@to=" + tablaRel + "]");
  if (!eRel || eRel.isNull() || eRel.attribute("sqljoin") == "NO") {
    return "1 = 1";
  }
  var eA = _i.dameElementoActual();

  var mtdTabla = _i.mgr_.metadata(tabla);
  var pK = mtdTabla.primaryKey();
  var mtdPK = mtdTabla.field(pK);
  var w = tabla + "." + pK + " = ";
  w += (mtdPK.type() ==  _i.ftSTRING_) ? "'" + eA.clave + "'" : eA.clave;
  return w;
}

function oficial_fromFastTable(tabla, tablaRel)
{
  var _i = this.iface;

  var eRel = _i.dameElementoXML(_i.xmlActions_.firstChild(), "action[@name=" + tabla + "]/relations/relation[@to=" + tablaRel + "]");
  if (!eRel || eRel.isNull() || eRel.attribute("sqljoin") == "NO") {
    return tablaRel;
  }
  return eRel.attribute("sqljoin");
}

function oficial_selectFastTable(tabla, tablaRel, xmlUW)
{
  var _i = this.iface;
  var _mgr = _i.mgr_;
  var s;
  /// Si hay campos en xmlUW, los de xmlUW más la clave primaria de la tabla
  switch (tabla) {
    default: {
      var mainTable = tablaRel;
      var mtd = _mgr.metadata(tabla);
      pk = mtd.primaryKey();
      s = tabla + "." + pk;
      var aCampos = AQUtil.nombreCampos(tabla);
      var numCampos = aCampos.shift();
      var c = 0, mtdCampo;
      for (var i = 0; i < numCampos; i++) {
        mtdCampo = mtd.field(aCampos[i]);
        if (!mtdCampo.visibleGrid()) {
          continue;
        }
        s += ("," + tabla + "." + aCampos[i]);
        if (++c > 5) {
          break;
        }
      }
    }
  }
  return s;
}


function oficial_cargaWidgetDashboard(w, n)
{
  var _i = this.iface;
  debug("______________CARGANDO WIDGET " + n + " : " + _i.h_);
  if (!_i.h_) {
    _i.h_ = [];
  }
  _i.h_[n] = w;
  _i.h_[n].w().show();
  debug("______________CARGANDO WIDGET " + n + " OK");
}

function oficial_borraWidgetsDashboard()
{
  debug("______________BORRANDO WIDGET ");
  var _i = this.iface;
  if (_i.h_) {

    for (var n in _i.h_) {
      debug("______________BORRANDO WIDGET " + n);
      _i.h_[n].close();
      _i.h_[n] = undefined;
    }
  }
  _i.h_ = [];
  return true;
}

function oficial_eventFilter(o, e)
{
  var _i = this.iface;
  if (o.name == "unnamed") {
    return;
  }
  switch (e.type) {
    case AQS.Close: {
      var t = _i.h_[o.name];
      if (t) {
        t.w().removeEventFilter(t.w());
        t.w_ = undefined;
      }
      break;
    }
    case AQS.Paint: {
      /*
      if (o.name == "MS53")  {
        var painter = new QPainter;
        painter.begin(o.paintDevice());
        painter.setWindow(0, 0, 400, 400);
        painter.drawLine(0, 0, 400, 400);
        painter.drawRect(0, 0, 400, 400);
        painter.drawText(200, 200, "XXXX");
        painter.end();
        break;
      }
      */
    }
  }
}
const _this = this;

class ABNWidget
{
  var w_;     // Widget
  var x_;     // Nodo XML
  var name_;
  var parent_;
  var action_;
  var cur_;   // Cursor elemento
  var tbnGuardar_, tbnConfig_, tbnEliminar_, tbnEditar_, tbnMover_;
  var wType_;
  var font_;
  var tB_;  // Toolbar
  var hL_;

  function ABNWidget(parent, name, x, cursor, wType)
  {
    wType_ = wType;
    name_ = name;
    parent_ = parent;
    w_ = new QDialog(parent, name);
    //    w_ = new QFrame(formt1_principal.child("gbxFondo"), name);
    // w_.WFlags = Qt.WStyle_NoBorder;
    w_.paletteBackgroundColor = formt1_principal.parentWidget().paletteBackgroundColor; //new Color("white");
    //w_.resize(260, 130);
    iniciaEstilo();
    cur_ = cursor;
    x_ = x;
    var e = x.toElement();
    action_ = e.attribute("action");
    w_.caption = e.attribute("title");

    ponGeometria();

    w_.eventFilterFunction = "formt1_principal.iface.eventFilter";
    w_.allowedEvents = [ AQS.Close, AQS.Resize, AQS.Paint ];
    w_.installEventFilter(w_);

    creaBotones();
    //    tB_= toolBar();
  }

  function ponGeometria()
  {
    var e = x_.toElement();
    var x = e.attribute("X");
    var y = e.attribute("Y");
    var w = e.attribute("Width");
    debug("Ancho " + w);
    var h = e.attribute("Height");
    if (!isNaN(x) && !isNaN(y)) {
      w_.pos = new Point(x, y);
    }
    if (!isNaN(w) && !isNaN(h)) {
      w_.size = new Size(w, h);
      //w_.setFixedSize(w, h);
    }
  }

  function iniciaEstilo()
  {
    font_ = new Font();
    font_.family = "verdana";
    font_.pixelSize = 12;
    //font_.italic = true;
    w_.font = font_;
  }

  function creaBotones()
  {
    tB_ = new QGroupBox(w_, "ToolBar");
    hL_ = new QHBoxLayout(tB_);

    tbnConfig_ = creaBotonToolbox("tbnConfig", "config.png");
    connect(tbnConfig_, "clicked()", this, "tbnConfig_clicked");
    hL_.addWidget(tbnConfig_);

    tbnGuardar_ = creaBotonToolbox("tbnGuardar", "save.png");
    connect(tbnGuardar_, "clicked()", this, "guardaCatalogo");
    hL_.addWidget(tbnGuardar_);

    tbnEliminar_ = creaBotonToolbox("tbnEliminar", "trash-empty.png");
    connect(tbnEliminar_, "clicked()", this, "eliminar");
    hL_.addWidget(tbnEliminar_);

    tbnMover_ = creaBotonToolbox("tbnEliminar", "trash-empty.png");
    connect(tbnMover_, "clicked()", this, "mover");
    hL_.addWidget(tbnMover_);

    tB_.close();

    tbnEditar_ = new QToolButton(w_, "tbnEditar");
    var px = new QPixmap(formt1_principal.iface.imgPath_ + "16x16/dialog-information.png");
    tbnEditar_.setIconSet(new QIconSet(px));
    tbnEditar_.minimumSize = new Size(16, 16);
    tbnEditar_.maximumSize = new Size(16, 16);
    tbnEditar_.autoRaise = true;
    tbnEditar_.toggleButton = true;

    connect(tbnEditar_, "toggled(bool)", tB_, "setShown()");

  }

  function mover()
  {
    var d = new QDialog(parent_, name_);
    w_.reparent(d);
  }

  function eliminar()
  {
    var e = x_.toElement();
    var id = e.attribute("id");
    if (id != "") {
      if (!AQSql.del("t1_elementosdb", "idelementodb = " + e.attribute("id"))) {
        return false;
      }
    }
    e.setAttribute("id", "");
    w_.close();
  }

  function creaBotonToolbox(n, i)
  {
    var b = new QToolButton(tB_, n);
    var px = new QPixmap(formt1_principal.iface.imgPath_ + i);
    b.setIconSet(new QIconSet(px));
    b.minimumSize = new Size(32, 32);
    b.maximumSize = new Size(32, 32);
    b.autoRaise = true;
    return b;
  }
  /*
    function toolBar()
    {


      return gB;
    }
    */
  /*
  function toolBox()
  {
    var hL = new QHBoxLayout(gB);
    hL.addWidget(tbnGuardar_);
    hL.addWidget(tbnConfig_);
    hL.addWidget(tbnEliminar_);
    return hL;
  }
  */

  function tbnConfig_clicked()
  {
    var xml = new QDomDocument;
    xml.appendChild(x_);
    var d = new Dialog;
    var tE = new TextEdit;
    tE.text = xml.toString(4);
    d.add(tE);
    if (!d.exec()) {
      return;
    }
    var sXML = tE.text;

    var xml2 = new QDomDocument;
    if (!xml2.setContent(sXML)) {
      MessageBox.warning(sys.translate("El XML contiene errores"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton, "AbanQ");
      return;
    }
    x_ = xml2.firstChild().cloneNode(true);

    refresca();
  }

  function refresca() {}

  function guardaCatalogo()
  {
    var xmlG = guardaXml();

    var xml = new QDomDocument;
    xml.setContent(xmlG.toString());

    var curCat = new FLSqlCursor("t1_catalogodb");
    var eG = x_.toElement();
    var e = xml.firstChild().toElement();
    e.setAttribute("id", "");
    var accion = e.attribute("action");
    var codCatalogo = eG.attribute("codcatalogodb");
    if (codCatalogo && codCatalogo != "") {
      if (!AQSql.update("t1_catalogodb", ["xmlbase"], [xml.toString(4)], "codcatalogodb = '" + codCatalogo + "'")) {
        return false;
      }
    } else {
      var codCatalogoDB = Input.getText(sys.translate("Nombre del widget"));
      if (!codCatalogoDB) {
        return;
      }
      e.setAttribute("codcatalogodb", codCatalogoDB);
      eG.setAttribute("codcatalogodb", codCatalogoDB);
      if (!AQSql.insert("t1_catalogodb", ["codcatalogodb", "accion", "xmlbase", "tipowidget"], [codCatalogoDB, accion, xml.toString(4), wType_])) {
        return false;
      }
    }
  }

  function guardaXml()
  {
    if (!x_ || x_.isNull()) {
      return;
    }
    var xml = new QDomDocument;
    xml.appendChild(x_);
    debug("x_ = " + x_);
    var e = x_.toElement();
    if (!e) {
      return;
    }
    e.setAttribute("X", w_.x);
    e.setAttribute("Y", w_.y);
    e.setAttribute("Width", w_.width);
    e.setAttribute("Height", w_.height);
    return xml;


  }

  function guardar()
  {
    if (w_ == undefined) {
      return;
    }
    var xml = guardaXml();
    var e = x_.toElement();
    var accion = e.attribute("action");
    var codCatalogo = e.attribute("codcatalogodb");
    if (!formt1_principal.iface.saveAsDashboardWidget(accion, name_, xml, codCatalogo)) {
      return false;
    }
  }

  function w()
  {
    return this.w_;
  }

  function close()
  {
    if (w_ == undefined) {
      return;
    }
    guardar();
    w_.removeEventFilter(w_);
    w_.close();
    w_ = undefined;
  }
}

class ABNWidget2
{
  var w_;     // Widget
  var c_;     // Configuración
  var name_;
  var parent_;
  var action_;
  var cur_;   // Cursor elemento
  var tbnGuardar_, tbnConfig_, tbnEliminar_, tbnEditar_, tbnMover_;
  var wType_;
  var font_;
  var tB_;  // Toolbar
  var hL_;
  var id_;

  var xml_;
  var geo_;

  function ABNWidget2(parent, name, oConfig, wType)
  {
    id_ = oConfig.id;
    wType_ = wType;
    name_ = name;
    xml_ = oConfig.xml;

    parent_ = parent;
    w_ = new QDialog(parent, name);
    //    w_ = new QFrame(formt1_principal.child("gbxFondo"), name);
    // w_.WFlags = Qt.WStyle_NoBorder;
    w_.paletteBackgroundColor = formt1_principal.parentWidget().paletteBackgroundColor; //new Color("white");
    //w_.resize(260, 130);
    iniciaEstilo();
    cur_ = oConfig.cur;
    c_ = oConfig;
    //     var e = x.toElement();
    action_ = oConfig.accion; //e.attribute("action");
    //     w_.caption = oConfig.titulo; // e.attribute("title");

    ponGeometria();

    w_.eventFilterFunction = "formt1_principal.iface.eventFilter";
    w_.allowedEvents = [ AQS.Close, AQS.Resize, AQS.Paint ];
    w_.installEventFilter(w_);

    creaBotones();
    //    tB_= toolBar();48
  }

  function ponGeometria()
  {
    if (!geo_) {
      geo_ = new Object;
    }

    geo_.x = 20;
    geo_.y = 20;
    geo_.w = 300;
    geo_.h = 200;

    if (xml_) {
      var xGeo = xml_.firstChild().namedItem("geo");
      if (xGeo && !xGeo.isNull()) {
        var eGeo = xGeo.toElement();
        geo_.x = eGeo.attribute("x");
        geo_.y = eGeo.attribute("y");
        geo_.w = eGeo.attribute("width");
        geo_.h = eGeo.attribute("height");
      }
    }

    if (!isNaN(geo_.x) && !isNaN(geo_.y)) {
      w_.pos = new Point(geo_.x, geo_.y);
    }
    if (!isNaN(geo_.w) && !isNaN(geo_.h)) {
      w_.size = new Size(geo_.w, geo_.h);
    }
  }

  function iniciaEstilo()
  {
    font_ = new Font();
    font_.family = "verdana";
    font_.pixelSize = 12;
    //font_.italic = true;
    w_.font = font_;
  }

  function creaBotones()
  {
    tB_ = new QGroupBox(w_, "ToolBar");
    hL_ = new QHBoxLayout(tB_);

    tbnConfig_ = creaBotonToolbox("tbnConfig", "config.png");
    connect(tbnConfig_, "clicked()", this, "tbnConfig_clicked");
    hL_.addWidget(tbnConfig_);

    tbnGuardar_ = creaBotonToolbox("tbnGuardar", "save.png");
    connect(tbnGuardar_, "clicked()", this, "guardaCatalogo");
    hL_.addWidget(tbnGuardar_);

    tbnEliminar_ = creaBotonToolbox("tbnEliminar", "trash-empty.png");
    connect(tbnEliminar_, "clicked()", this, "eliminar");
    hL_.addWidget(tbnEliminar_);

    //    tbnMover_ = creaBotonToolbox("tbnEliminar", "trash-empty.png");
    //     connect(tbnMover_, "clicked()", this, "mover");
    //     hL_.addWidget(tbnMover_);

    tB_.close();

    tbnEditar_ = new QToolButton(w_, "tbnEditar");
    var px = new QPixmap(formt1_principal.iface.imgPath_ + "16x16/dialog-information.png");
    tbnEditar_.setIconSet(new QIconSet(px));
    tbnEditar_.minimumSize = new Size(16, 16);
    tbnEditar_.maximumSize = new Size(16, 16);
    tbnEditar_.autoRaise = true;
    tbnEditar_.toggleButton = true;

    connect(tbnEditar_, "toggled(bool)", tB_, "setShown()");

  }

  function mover()
  {
    var d = new QDialog(parent_, name_);
    w_.reparent(d);
  }

  function eliminar()
  {
    var id = c_.id;
    if (id != "") {
      if (!AQSql.del("t1_widgetsusuario", "idwidget = " + id)) {
        return false;
      }
    }
    w_.close();
  }

  function creaBotonToolbox(n, i)
  {
    var b = new QToolButton(tB_, n);
    var px = new QPixmap(formt1_principal.iface.imgPath_ + i);
    b.setIconSet(new QIconSet(px));
    b.minimumSize = new Size(32, 32);
    b.maximumSize = new Size(32, 32);
    b.autoRaise = true;
    return b;
  }
  /*
    function toolBar()
    {


      return gB;
    }
    */
  /*
  function toolBox()
  {
    var hL = new QHBoxLayout(gB);
    hL.addWidget(tbnGuardar_);
    hL.addWidget(tbnConfig_);
    hL.addWidget(tbnEliminar_);
    return hL;
  }
  */

  function tbnConfig_clicked()
  {
    var xml = guardaXml();

    var d = new Dialog;
    var tE = new TextEdit;
    tE.text = xml;
    d.add(tE);
    if (!d.exec()) {
      return;
    }
    var sXML = tE.text;

    var xml2 = new QDomDocument;
    if (!xml2.setContent(sXML)) {
      MessageBox.warning(sys.translate("El XML contiene errores"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton, "AbanQ");
      return;
    }
    //     x_ = xml2.firstChild().cloneNode(true);
    if (!xml_) {
      xml_ = new QDomDocument;
    }
    xml_.setContent(sXML);
    refresca(true);
  }

  function refresca() {}

  function guardaCatalogo()
  {
    guardar();
    return;

    var xmlG = guardaXml();

    var xml = new QDomDocument;
    xml.setContent(xmlG.toString());

    var curCat = new FLSqlCursor("t1_catalogodb");
    var eG = x_.toElement();
    var e = xml.firstChild().toElement();
    e.setAttribute("id", "");
    var accion = e.attribute("action");
    var codCatalogo = eG.attribute("codcatalogodb");
    if (codCatalogo && codCatalogo != "") {
      if (!AQSql.update("t1_catalogodb", ["xmlbase"], [xml.toString(4)], "codcatalogodb = '" + codCatalogo + "'")) {
        return false;
      }
    } else {
      var codCatalogoDB = Input.getText(sys.translate("Nombre del widget"));
      if (!codCatalogoDB) {
        return;
      }
      e.setAttribute("codcatalogodb", codCatalogoDB);
      eG.setAttribute("codcatalogodb", codCatalogoDB);
      if (!AQSql.insert("t1_catalogodb", ["codcatalogodb", "accion", "xmlbase", "tipowidget"], [codCatalogoDB, accion, xml.toString(4), wType_])) {
        return false;
      }
    }
  }

  function guardaXml()
  {
    if (!xml_ || xml_.isNull()) {
      return;
    }
    var xml = new QDomDocument;
    xml.appendChild(xml_);
    debug("x_ = " + xml_);
    var e = xml_.toElement();
    if (!e) {
      return;
    }
    e.setAttribute("X", w_.x);
    e.setAttribute("Y", w_.y);
    e.setAttribute("Width", w_.width);
    e.setAttribute("Height", w_.height);
    return xml.toString(4);
  }

  function guardar()
  {
    if (w_ == undefined) {
      return;
    }
    var xml = guardaXml();
    if (!xml) {
      return false;
    }
    if (!AQSql.update("t1_widgetsusuario", ["config"], [xml], "idwidget = " + id_)) {
      return false;
    }
    //     var e = x_.toElement();
    //     var accion = e.attribute("action");
    //     var codCatalogo = e.attribute("codcatalogodb");
    //     if (!formt1_principal.iface.saveAsDashboardWidget(accion, name_, xml, codCatalogo)) {
    //       return false;
    //     }
  }

  function w()
  {
    return this.w_;
  }

  function close()
  {
    if (w_ == undefined) {
      return;
    }
    guardar();
    w_.removeEventFilter(w_);
    w_.close();
    w_ = undefined;
  }
}

class ABN2DChart extends ABNWidget
{
  var lblPix_;
  var tbnConfigChart_;

  function ABN2DChart(parent, name, x, cursor)
  {
    ABNWidget(parent, name, x, cursor, "ABN2DChart");

    var vLay = new QVBoxLayout(this.w_);
    vLay.addWidget(tB_);

    lblPix_ = new QLabel(this.w_);
    lblPix_.move(20, 20);
    //vLay.addWidget(lblPix_);

    vLay.addWidget(tbnEditar_);

    w_.caption = x_.toElement().attribute("title");
    refresca();
  }

  function creaBotones()
  {
    // this.ABNWidget.creaBotones(); ¿hay forma de llamar a la función de la clase inferior?

    tB_ = new QGroupBox(w_, "ToolBar");
    hL_ = new QHBoxLayout(tB_);

    tbnConfig_ = creaBotonToolbox("tbnConfig", "config.png");
    connect(tbnConfig_, "clicked()", this, "tbnConfig_clicked");
    hL_.addWidget(tbnConfig_);

    tbnGuardar_ = creaBotonToolbox("tbnGuardar", "save.png");
    connect(tbnGuardar_, "clicked()", this, "guardaCatalogo");
    hL_.addWidget(tbnGuardar_);

    tbnEliminar_ = creaBotonToolbox("tbnEliminar", "trash-empty.png");
    connect(tbnEliminar_, "clicked()", this, "eliminar");
    hL_.addWidget(tbnEliminar_);

    tB_.close();

    tbnEditar_ = new QToolButton(w_, "tbnEditar");
    var px = new QPixmap(formt1_principal.iface.imgPath_ + "16x16/dialog-information.png");
    tbnEditar_.setIconSet(new QIconSet(px));
    tbnEditar_.minimumSize = new Size(16, 16);
    tbnEditar_.maximumSize = new Size(16, 16);
    tbnEditar_.autoRaise = true;
    tbnEditar_.toggleButton = true;

    connect(tbnEditar_, "toggled(bool)", tB_, "setShown()");

    /// ABN2DChart
    tbnConfigChart_ = creaBotonToolbox("tbnConfigChart", "office-chart-bar.png");
    connect(tbnConfigChart_, "clicked()", this, "tbnConfigChart_clicked");
    hL_.addWidget(tbnConfigChart_);

  }

  function tbnConfigChart_clicked()
  {
    var util = new FLUtil;

    var xGrafico = x_.namedItem("Grafico");
    if (!xGrafico || xGrafico.isNull()) {
      return;
    }
    var eGrafico = xGrafico.toElement();

    var tipoGrafico = eGrafico.attribute("Tipo");
    var filtroEdicion = "";
    var accion;
    switch (tipoGrafico) {
      case "2d_barras": {
        accion = "gf_2dbarras";
        break;
      }
      case "lineal": {
        accion = "gf_lineal";
        break;
      }
      case "1daguja": {
        accion = "gf_1daguja";
        break;
      }
      case "2d_tabla": {
        accion = "gf_2dtabla";
        break;
      }
      case "2d_mapa": {
        accion = "gf_2dmapa_edit";
        var codMapa: String;
        var tabla = eGrafico.attribute("Tabla");
        if (util.sqlSelect("gf_2dmapa", "COUNT(*)", "tabla = '" + tabla + "'") > 1) {
          var fMapas = new FLFormSearchDB("gf_2dmapa");
          var curMapa = fMapas.cursor();
          curMapa.setMainFilter("tabla = '" + tabla + "'");
          fMapas.setMainWidget();
          codMapa = fMapas.exec("codmapa");
          if (!fMapas.accepted()) {
            return false;
          }
        } else {
          codMapa = eGrafico.attribute("CodMapa");
        }
        filtroEdicion = "codmapa = '" + codMapa + "'";
        break;
      }
      case "2dtarta": {
        accion = "gf_2dtarta";
        break;
      }
      default: {
        MessageBox.warning(sys.translate("El gráfico tipo %1 no soporta edición.").arg(tipoGrafico), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton, "AbanQ");
        return false;
      }
    }

    var f = new FLFormSearchDB(accion);
    var curGrafico = f.cursor();

    if (filtroEdicion) {
      curGrafico.select(filtroEdicion);
      if (!curGrafico.first()) {
        debug("No se encuentra registro gráfico " + filtroEdicion);
        return false;
      }
      curGrafico.setModeAccess(curGrafico.Edit);
    } else {
      curGrafico.setModeAccess(curGrafico.Insert);
    }
    var xmlGrafico = new QDomDocument;
    xmlGrafico.appendChild(eGrafico.cloneNode(true));
    debug(xmlGrafico.toString());
    curGrafico.refreshBuffer();
    curGrafico.setValueBuffer("xml", xmlGrafico.toString());
    f.setMainWidget();
    f.exec("id");
    if (!f.accepted()) {
      return false;
    }
    xmlGrafico = new QDomDocument;
    xmlGrafico.setContent(curGrafico.valueBuffer("xml"));

    x_.removeChild(xGrafico);
    x_.appendChild(xmlGrafico.firstChild().cloneNode(true));
    refresca();
  }

  function refresca()
  {
    //lblPix_.pixmap = 0;
    //lblPix_.size = new Size (10, 10);
    ponGeometria();
    var w = w_.size.width;// * 0.8;
    var h = w_.size.height * 0.95;
    s = new Size(w, h);
    lblPix_.size = s;

    var devSize = lblPix_.size;
    var clr = w_.paletteBackgroundColor;
    var pix = new Pixmap();
    pix.resize(devSize);
    pix.fill(clr);
    lblPix_.pixmap = pix;
    var pic = damePic(s);
    if (!pic) {
      return;
    }
    pix = pic.playOnPixmap(pix);
    lblPix_.pixmap = pix;
  }

  function damePic(s)
  {
    var x = x_;
    //var _i = this.iface;
    var xGD = new QDomDocument();
    var xChart = x.namedItem("Grafico");
    if (!xChart || xChart.isNull()) {
      var gD = flgraficos.iface.pub_dameGraficoDefecto("2d_barras");
      xGD.setContent(gD);
      xGD.firstChild().namedItem("EjeY").toElement().setAttribute("Medida", "");
    } else {
      xGD.appendChild(xChart);
    }

    var xFun = x.namedItem("DataFunction");
    if (!xFun || xFun.isNull()) {
      return false;
    }
    var xParam = xFun.namedItem("Parameters");
    if (!xParam || xParam.isNull()) {
      return false;
    }

    var eGrafico = xChart.toElement(); //xGD.firstChild().toElement();
    eGrafico.setAttribute("Alto", s.height);
    eGrafico.setAttribute("Ancho", s.width);
    var r = new Rect(0, 0, s.width, s.height);

    var xDF = x_.namedItem("DataFunction");
    if (!xDF || xDF.isNull()) {
      return;
    }
    var eDF = xDF.toElement();
    var fN = eDF.attribute("name");
    var f = new Function("xGD, xParam", "return " + fN + "(xGD, xParam);");
    try {
      if (!f(xGD, xParam)) {
        return false;
      }
    } catch (e) {
      MessageBox.warning(sys.translate("Error al ejecutar la función %1:").arg(fN) + e, MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton, "AbanQ");
      return false;
    }
    /*
    if (!_i.obtenValoresGrafico(xGD, xParam)) {
      return false;
    }
    */
    if (xChart) {
      x.removeChild(xChart);
    }
    x.appendChild(xGD.firstChild().cloneNode(true));

    var pic = flgraficos.iface.pub_dibujarGrafico(xGD, r);

    return pic;

  }
}

class ABNMethodSet extends ABNWidget
{
  var bG_;
  var aBotones_;

  function ABNMethodSet(parent, name, x, cursor)
  {
    debug("constructor " + ABNMethodSet);
    ABNWidget(parent, name, x, cursor, "ABNMethodSet");

    var vLay = new QVBoxLayout(this.w_);
    vLay.addWidget(tB_);
    var hLay = new QHBoxLayout(vLay);
    bG_ = new QHButtonGroup(w_, "BG");
    hLay.addWidget(bG_);

    var vLayEdit = new QVBoxLayout(hLay);
    vLayEdit.addWidget(tbnEditar_);
    hLay.addLayout(vLayEdit);

    w_.caption = x_.toElement().attribute("title");
    refresca();
    connect(w_.child("BG"), "clicked(int)", this, "bG_clicked");
  }


  function refresca()
  {
    aBotones_ = [];
    var e = x_.toElement();
    var accion = e.attribute("action");
    var eMethod, iconM, b, aB = [], i = 0, tt, mName;
    var px, pxMethod, painter, pxB;
    var w = 48, h = 48;
    for (var xMethod = e.firstChild(); !xMethod.isNull(); xMethod = xMethod.nextSibling()) {
      eMethod = xMethod.toElement();
      mName = eMethod.attribute("name");
      debug("Buscando método " + mName);
      var eActionMethod = formt1_principal.iface.dameElementoXML(formt1_principal.iface.xmlActions_.firstChild(), "action[@name=" + accion + "]/methods/method[@name=" + mName + "]");
      if (!eActionMethod || eActionMethod.isNull()) {
        debug("NO encontrado  " + mName);
        continue;
      }
      debug("Sí encontrado  ");
      aBotones_[i] = [];
      aBotones_[i]["funcion"] = eActionMethod.attribute("function");
      aB[i] = new QToolButton(bG_, "B" + i.toString());
      b = aB[i];
      /*
        b.eventFilterFunction = "eventFilter";
        b.allowedEvents = [ AQS.Close, AQS.Resize, AQS.Paint ];
        b.installEventFilter(b);
        */

      pxB = new QPixmap(w, h);

      var c = w_.paletteBackgroundColor;
      pxB.fill(c);
      painter = new Picture;
      painter.begin();

      iconM = eActionMethod.attribute("iconmethod");
      if (iconM != "") {
        pxMethod = new QPixmap(formt1_principal.iface.imgPath_ + "16x16/" + iconM);
        painter.drawPixmap(w * 0.70, h * 0, pxMethod);
      }
      px = new QPixmap(formt1_principal.iface.imgPath_ + "48x48/" + eActionMethod.attribute("icon"));
      painter.drawPixmap(0, 0, px);
      pxB = painter.playOnPixmap(pxB);
      painter.end();
      b.setIconSet(new QIconSet(pxB));

      b.minimumSize = new Size(60, 60);
      b.maximumSize = new Size(60, 60);
      b.usesBigPixmap = true;
      b.autoRaise = true;
      // Fede b.setCursor(QCursor.PointingHandCursor);
      // Fede tt = new QToolTip(b);
      i++;
    }
    return;
  }

  function bG_clicked(i)
  {
    var _i = formt1_principal.iface;
    _i.llamaFuncionCursor(aBotones_[i]["funcion"], cur_);
  }


}


class ABNMethodSet2 extends ABNWidget2
{
  var bG_;
  var aBotones_;
  var vH_;

  function ABNMethodSet2(parent, name, oConfig)
  {
    ABNWidget2(parent, name, oConfig, "ABNMethodSet");

    var vLay = new QVBoxLayout(this.w_);
    vLay.addWidget(tB_);
    var hLay = new QHBoxLayout(vLay);
    orientacion();
    bG_ = vH_ == "H" ? new QHButtonGroup(w_, "BG") : new QVButtonGroup(w_, "BG");
    hLay.addWidget(bG_);

    var vLayEdit = new QVBoxLayout(hLay);
    vLayEdit.addWidget(tbnEditar_);
    hLay.addLayout(vLayEdit);

    if (xml_) {
      w_.caption = xml_.toElement() ? xml_.toElement().attribute("title") : "";
    }

    refresca();
    connect(w_.child("BG"), "clicked(int)", this, "bG_clicked");
  }

  function orientacion()
  {
    debug("orientacion");
    vH_ = "H";
    if (!xml_) {
      debug("orientacion 1");
      return;
    }
    var eGeo = formt1_principal.iface.dameElementoXML(xml_.firstChild(), "geo");
    if (!eGeo || eGeo.isNull()) {
      debug("orientacion 2");
      return;
    }
    vH_ = eGeo.attribute("orientation") == "V" ? "V" : "H";
  }

  function refresca()
  {
    aBotones_ = [];
    if (!xml_) {
      return;
    }
    var e = xml_.firstChild().toElement();
    var accion = c_.accion;
    var eMethod, iconM, b, aB = [], i = 0, tt, mName;
    var px, pxMethod, painter, pxB;
    var w = 48, h = 48;
    debug(xml_.toString());
    debug(e.nodeName());
    for (var xMethod = e.firstChild(); xMethod && !xMethod.isNull(); xMethod = xMethod.nextSibling()) {
      eMethod = xMethod.toElement();
      mName = eMethod.attribute("name");
      // debug("Buscando método " + mName);
      var eActionMethod = formt1_principal.iface.dameElementoXML(formt1_principal.iface.xmlActions_.firstChild(), "action[@name=" + accion + "]/methods/method[@name=" + mName + "]");
      if (!eActionMethod || eActionMethod.isNull()) {
        // debug("NO encontrado  " + mName);
        continue;
      }
      // debug("Sí encontrado  ");
      aBotones_[i] = [];
      aBotones_[i]["funcion"] = eActionMethod.attribute("function");
      aB[i] = new QToolButton(bG_, "B" + i.toString());
      b = aB[i];
      /*
        b.eventFilterFunction = "eventFilter";
        b.allowedEvents = [ AQS.Close, AQS.Resize, AQS.Paint ];
        b.installEventFilter(b);
        */

      pxB = new QPixmap(w, h);

      var c = w_.paletteBackgroundColor;
      pxB.fill(c);
      painter = new Picture;
      painter.begin();

      iconM = eActionMethod.attribute("iconmethod");


      if (iconM != "") {
        var iMPx = AQUtil.sqlSelect("t1_iconos", "i16x16", "nombre = '" + eActionMethod.attribute("iconmethod") + "'");
        debug("iMPx " + iMPx);
        if (iMPx) {
          pxMethod = sys.toPixmap(iMPx);
          painter.drawPixmap(w * 0.70, h * 0, pxMethod);
        }
      }
      var iPx = AQUtil.sqlSelect("t1_iconos", "i48x48", "nombre = '" + eActionMethod.attribute("icon") + "'");
      px = sys.toPixmap(iPx);

      /*
      if (iconM != "") {
        pxMethod = new QPixmap(formt1_principal.iface.imgPath_ + "16x16/" + iconM);
        painter.drawPixmap(w * 0.70, h * 0, pxMethod);
      }
      px = new QPixmap(formt1_principal.iface.imgPath_ + "48x48/" + eActionMethod.attribute("icon"));
      */
      painter.drawPixmap(0, 0, px);
      pxB = painter.playOnPixmap(pxB);
      painter.end();
      b.setIconSet(new QIconSet(pxB));

      b.minimumSize = new Size(60, 60);
      b.maximumSize = new Size(60, 60);
      b.usesBigPixmap = true;
      b.autoRaise = true;
      // Fede b.setCursor(QCursor.PointingHandCursor);
      // Fede tt = new QToolTip(b);
      i++;
    }
    return;
  }

  function bG_clicked(i)
  {
    var _i = formt1_principal.iface;
    _i.llamaFuncionCursor(aBotones_[i]["funcion"], cur_);
  }

  function guardaXml()
  {
    if (!xml_ || xml_.isNull()) {
      xml_ = new FLDomDocument;
      xml_.setContent("<ABNMethodSet/>");
    }
    debug("x_ = " + xml_.nodeName());
    debug("x2_ = " + xml_.firstChild().nodeName());
    var xGeo = xml_.firstChild().namedItem("geo");
    var eGeo;
    if (!xGeo || xGeo.isNull()) {
      eGeo = xml_.createElement("geo");
      eGeo.setAttribute("orientation", "H");
      xml_.firstChild().appendChild(eGeo);
    } else {
      eGeo = xGeo.toElement();
    }
    eGeo.setAttribute("x", w_.x);
    eGeo.setAttribute("y", w_.y);
    eGeo.setAttribute("width", w_.width);
    eGeo.setAttribute("height", w_.height);
    debug(xml_.toString(4));
    return xml_.toString(4);
  }
}

class ABNFastTable extends ABNWidget
{
  var aCols_;   // Array de columnas
  var q_;     // Query
  var b_;
  var tid_;
  var t_;
  var clrFila_; // Colores de fondo para las filas

  function ABNFastTable(parent, name, x, cursor)
  {
    ABNWidget(parent, name, x, cursor, "ABNFastTable");
    creaTabla();

    var vLay = new QVBoxLayout(w_);
    vLay.addWidget(tB_);
    vLay.addWidget(t_);
    vLay.addWidget(tbnEditar_);
  }

  function creaTabla()
  {
    cargaColorFilas();
    t_ = new QTable(w_, "T");
    t_.setColumnMovingEnabled(true);
    t_.font = font_; // w_.font;
    t_.paletteBackgroundColor = w_.paletteBackgroundColor;

    llenaTabla();
  }

  function cargaColorFilas()
  {
    clrFila_ = new Object;
    clrFila_.par = new Color("white");
    clrFila_.impar = new Color("grey");
  }

  function refresca()
  {
    llenaTabla();
  }

  function llenaTabla()
  {
    var x = x_;
    var e = x_.toElement();
    var cursor = cur_;
    debug(x.toString(4));
    var xCols = x.namedItem("cols");
    var nC = xCols.childNodes().count();

    debug(xCols.isNull());
    aCols_ = new Array(nC);
    var cL = new Array(nC);

    t_.setNumCols(nC + 1);
    t_.setNumRows(0);
    t_.hideColumn(0);

    var manager = aqApp.db().manager();
    var mainTable = e.attribute("actionRelated");
    var mtdMT = manager.metadata(mainTable);
    var pkMT = mainTable + "." + mtdMT.primaryKey();

    var  f = t_.font;
    var fM = new QFontMetrics(f);
    var mtdCampo, ancho = 0, anchoCol;
    var labelC, sC = pkMT;

    cL.push("PK");
    aCols_[0] = [];
    aCols_[0]["pkname"] = pkMT;
    var c = 1, num;
    for (var xCol = xCols.firstChild(); !xCol.isNull(); xCol = xCol.nextSibling()) {
      mtdCampo = undefined;
      e = xCol.toElement();
      anchoCol = e.attribute("width");
      anchoCol = anchoCol == "" ? false : anchoCol;
      labelC =  e.attribute("label");
      if (e.attribute("hidden") == "true") {
        this.t_.hideColumn(c);
      }
      switch (e.attribute("type")) {
        case "field": {
          var fN = e.attribute("fieldname");
          debug("fN " + fN);
          sC += (fN == pkMT) ? "" : ", " + fN;
          var tabla = fN.split(".")[0];
          var campo = fN.split(".")[1];

          var mtdTabla = manager.metadata(tabla);
          if (mtdTabla == undefined) {
            return;
          }
          mtdCampo = mtdTabla.field(campo);
          try {
            var tmp = mtdCampo.type();
          } catch (e) {
            MessageBox.warning(sys.translate("Error al obtener los datos del campo %1").arg(fN), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton, "AbanQ");
            return false;
          }
          if (mtdCampo == undefined) {
            return;
          }
          if (!anchoCol) {
            anchoCol = dameAnchoCampo(mtdCampo, fM);
          }
          labelC = labelC == "auto" ? mtdCampo.alias() : labelC;
          break;
        }
        case "method": {
          if (!anchoCol) {
            anchoCol = 30;
          }
          break;
        }
      }
      //      cL.push(labelC);
      //      t_.setColumnWidth(c, anchoCol);

      num = parseInt(e.attribute("num"));
      debug("num " + num);
      aCols_[num] = [];
      aCols_[num]["e"] = e;
      aCols_[num]["mtd"] = mtdCampo;
      cL[num] = labelC;
      t_.setColumnWidth(num, anchoCol);
      ancho += anchoCol;

      /*      aCols_[c] = [];
            aCols_[c]["e"] = e;
            aCols_[c]["mtd"] = mtdCampo;*/
      c++;
    }
    debug("for ended");
    t_.setColumnLabels(cL);
    t_.verticalHeader().close();
    t_.setLeftMargin(0);
    t_.selectionMode = QTable.SingleRow;
    //t_.setSorting(true);

    eQry = x.toElement().namedItem("qry").toElement();
    debug("NN " + x.namedItem("qry").nodeName());
    var oB = eQry.attribute("orderByClause");
    var wC = eQry.attribute("whereClause");
    var p1 = wC.find("**");
    if (p1 >= 0) {
      var p2 = wC.find("**", p1 + 1);
      if (p2 >= 0) {
        var campoW = wC.substring(p1 + 2, p2);
        debug("campoW " + campoW);
        var vCampoW;
        if (campoW == "PK") {
          vCampoW = cursor.valueBuffer(cursor.primaryKey());
        } else {
          vCampoW = cursor.valueBuffer(campoW);
        }
        wC = wC.replace("**" + campoW + "**", vCampoW);
      }
    }
    var eFiltro = formt1_principal.iface.dameElementoXML(x, "filters/filter[@selected=true]");
    if (!eFiltro.isNull()) {
      oB = eFiltro.attribute("orderByClause");
      var wCF = eFiltro.attribute("whereClause");
      if (wCF != "") {
        wC += wC != "" ? " AND " : "";
        wC += wCF;
      }
      w_.caption = eFiltro.attribute("alias");
    }
    q_ = new FLSqlQuery;
    var q = q_;
    q.setTablesList(eQry.attribute("tablesList"));
    q.setSelect(sC);
    q.setFrom(eQry.attribute("fromClause"));
    q.setWhere(wC);
    q.setOrderBy(oB);
    q.setForwardOnly(true);
    debug("Consulta " + q.sql());
    if (!q.exec()) {
      return false;
    }
    var f = 0, texto;
    t_.insertRows(f);
    t_.hideRow(f);
    /// Sirve para comprobar si las columnas se han movido al guardar
    for (var c = 0; c <= nC; c++) {
      t_.setText(f, c, c);
    }
    f++;
    while (q.next()) {
      t_.insertRows(f);
      t_.setRowHeight(f, 25);
      this.llenaFila(f, q);
      f++;
    }

    t_.setShowGrid(false);
    t_.focusStyle = QTable.FollowStyle;
    t_.selectionMode = QTable.NoSelection;
    t_.resize(ancho,   w_.height);

    connect(w_.child("T"), "clicked(int,int,int,const QPoint&)", this, "t_clicked");
  }

  function llenaFila(f, q)
  {
    /*
    var b = new QBrush(new Color("blue"));
    var p = new QPainter;
    p.setBrush(b);
    */

    var x = this.x_;
    var xCols = x.namedItem("cols");
    var nC = xCols.childNodes().count();
    var aR = x.toElement().attribute("actionRelated");
    var c, texto;
    this.t_.setText(f, 0, q.value(aCols_[0]["pkname"]));
    for (c = 1; c <= nC; c++) {
      switch (aCols_[c].e.attribute("type")) {
        case "field": {
          texto = this.formateaTexto(q.value(aCols_[c].e.attribute("fieldname")), aCols_[c].mtd);
          t_.setText(f, c, texto);
          //t_.paintCell(p, f, c);
          break;
        }
        case "method": {
          /// Cambiar por XPath
          var m = aCols_[c].e.attribute("methodname");
          var eActionMethod = formt1_principal.iface.dameElementoXML(formt1_principal.iface.xmlActions_.firstChild(), "action[@name=" + aR + "]/methods/method[@name=" + m + "]");
          if (eActionMethod && !eActionMethod.isNull()) {
            debug("icono para metodo " + m + " en " + formt1_principal.iface.imgPath_ + eActionMethod.attribute("icon"));
            var px = new Pixmap(formt1_principal.iface.imgPath_ + "16x16/" + eActionMethod.attribute("icon"));
            t_.setPixmap(f, c, px);
          }
          break;
        }
      }
    }
  }

  function guardaXml()
  {
    var xml = new QDomDocument;
    xml.appendChild(x_);
    var e = x_.toElement();
    e.setAttribute("X", w_.x);
    e.setAttribute("Y", w_.y);
    e.setAttribute("Width", w_.width);
    e.setAttribute("Height", w_.height);

    var numCols = t_.numCols;
    var aC = new Array(numCols);
    for (var c = 0; c < numCols; c++) {
      aC[c] = t_.text(0, c);
    }

    var eCols = e.namedItem("cols").toElement();
    var lCols = eCols.childNodes();
    var eCol, num, w, numC;
    for (var i = 0; i < lCols.count(); i++) {
      eCol = lCols.item(i).toElement();
      num = eCol.attribute("num");
      numC = aC[parseInt(num)]
             w = t_.columnWidth(parseInt(numC));
      eCol.setAttribute("width", w);
      eCol.setAttribute("num", numC);
    }
    debug(xml.toString(4));
    return xml;
  }


  function formateaTexto(t, mtdCampo)
  {
    var tipo = mtdCampo.type();
    var valor;
    switch (tipo) {
      case 26: { // Fecha
        valor = AQUtil.dateAMDtoDMA(t);
        break;
      }
      case 19: { // Double
        valor = AQUtil.formatoMiles(AQUtil.buildNumber(t, 'f', mtdCampo.partDecimal()));
        break;
      }
      default: {
        valor = t;
      }
    }
    return valor;
  }

  function dameAnchoCampo(mtdCampo, fM)
  {
    //debug("Campo " + campo  + " es tipo " + mtdCampo.type());
    var tipo = mtdCampo.type();
    var c = fM.width("0"), m = 10;
    var a;
    switch (tipo) {
      case 26: { // Fecha
        a = 10 * c;
        break;
      }
      case 3: { // String
        var  l = mtdCampo.length();
        l = l > 25 ? 25 : l;
        a = l * c;
        break;
      }
      case 19: { // Double
        a = (mtdCampo.partInteger() + mtdCampo.partDecimal() + 1) * c
            break;
      }
      default: {
        a = c * 10;
      }
    }
    a += m;
    return a;
  }

  function t_clicked(f, c)
  {
    debug("FT_t_clicked " + f + " " + c);
    if (c < 1) {
      return;
    }
    switch (aCols_[c].e.attribute("type")) {
      case "field": {
        var eXml = this.x_.toElement();
        var clave = t_.text(f, 0);
        var tabla = eXml.attribute("actionRelated");
        debug("tabla  " + tabla);
        if (tabla) {
          formt1_principal.iface.ponElementoActual(tabla , clave);
        }
        break;
      }
      case "method": {
        var m = aCols_[c].e.attribute("methodname");
        debug(m);
        if (!m || m == "") {
          return;
        }
        var tDB = this.x_.toElement().attribute("actionRelated");
        var eActionMethod = formt1_principal.iface.dameElementoXML(formt1_principal.iface.xmlActions_.firstChild(), "action[@name=" + tDB + "]/methods/method[@name=" + m + "]");
        if (!eActionMethod || eActionMethod.isNull()) {
          debug("No encuentra método " + m);
          return;
        }
        var fun = eActionMethod.attribute("function");
        var id = t_.text(f, 0);

        var llamada = fun + "('" + id + "', '" + tDB + "')";
        //var llamada = fun + "(" + id + ", '" + tDB + "')";
        debug("llamada " + llamada);
        try {
          eval(llamada);
        } catch (e) {
          MessageBox.warning(sys.translate("La llamada %1 ha fallado:\n").arg(llamada) + e, MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton, "AbanQ");
          return;
        }
        this.refrescaFila(f);
        break;
      }
    }
  }

  function refrescaFila(f)
  {
    //var q = this.q_;
    var q = new FLSqlQuery;
    q.setSelect(this.q_.select());
    q.setFrom(this.q_.from());
    q.setSelect(this.q_.select());
    q.setSelect(this.q_.select());
    //    var oldWhere = w.where();
    var clave = this.t_.text(f, 0);
    var e = this.x_.toElement();
    var tabla = e.attribute("actionRelated");
    var manager = aqApp.db().manager();
    var mtdRel = manager.metadata(tabla);
    var pk = mtdRel.primaryKey();
    var mtdPK = mtdRel.field(pk);
    var _mainI = formt1_principal.iface;
    var where = tabla + "." + pk + " = ";
    where += (mtdPK.type() ==  _mainI.ftSTRING_) ? "'" + clave + "'" : clave;
    q.setWhere(where);
    q.setForwardOnly(true);
    if (!q.exec()) {
      return;
    }
    if (!q.first()) {
      return;
    }
    this.llenaFila(f, q)
  }

}

class ABNFastTable2 extends ABNWidget2
{
  var t_;
  var pk_;
  var valorPk_;
  var clrFila_; // Colores de fondo para las filas

  var accion_;
  var accionRel_;
  var q_;
  var cols_;
  var geo_;

  function ABNFastTable2(parent, name, oConfig)
  {
    ABNWidget2(parent, name, oConfig, "ABNFastTable");

    accion_ = oConfig.accion;
    accionRel_ = oConfig.accionRel;

    creaTabla();

    var vLay = new QVBoxLayout(w_);
    vLay.addWidget(tB_);
    vLay.addWidget(t_);
    vLay.addWidget(tbnEditar_);
  }

  function configuraTabla()
  {
    construyeQuery();
    columnasTabla();

    var nC = cols_.length; //xCols.childNodes().count();
    var cL = [];

    t_.setNumCols(nC);
    t_.setNumRows(0);
    t_.hideColumn(0);

    var manager = aqApp.db().manager();
    var mainTable = accionRel_; //e.attribute("actionRelated");
    var mtdMT = manager.metadata(mainTable);
    pk_ = mainTable + "." + mtdMT.primaryKey();

    var  f = t_.font;
    var fM = new QFontMetrics(f);
    var mtdCampo, ancho = 0, anchoCol;
    var labelC;

    for (var c = 0; c < nC; c++) {
      // debug("C " + c + " tipo " + cols_[c]["type"]);
      anchoCol = cols_[c]["width"] ? cols_[c]["width"] : 90;
      switch (cols_[c]["type"]) {
        case "field": {
          // debug("Campo " + cols_[c]["field"]);
          var fN = cols_[c]["field"];
          debug("fN " + fN);
          //           sC += (fN == pkMT) ? "" : ", " + fN;
          var tabla = fN.split(".")[0];
          var campo = fN.split(".")[1];

          var mtdTabla = manager.metadata(tabla);
          if (mtdTabla == undefined) {
            return;
          }
          mtdCampo = mtdTabla.field(campo);

          /// Ver dameAnchoCampo si anchoCol = undefined
          labelC = (cols_[c]["alias"] == undefined && mtdCampo) ? mtdCampo.alias() : cols_[c]["alias"];
          break;
        }
        case "method": {
          mtdCampo = undefined;
          labelC = "";
          if (!anchoCol) {
            anchoCol = 30;
          }
          break;
        }
      }
      cols_[c]["mtd"] = mtdCampo;
      t_.setColumnWidth(c, anchoCol);
      ancho += anchoCol;
      cL.push(labelC)
    }
    debug("for ended");

    t_.setColumnLabels(cL);
    t_.verticalHeader().close();
    t_.setLeftMargin(0);
    t_.selectionMode = QTable.SingleRow;
  }

  function columnasTabla()
  {
    cols_ = [];
    var c = 0;

    if (xml_) {
      var eCols = xml_.firstChild().namedItem("cols").toElement();
      var eCol;
      for (var xCol = eCols.firstChild(); xCol && !xCol.isNull(); xCol = xCol.nextSibling()) {
        eCol = xCol.toElement();
        cols_[c] = objetoColumna();
        cols_[c].type = eCol.attribute("type");
        cols_[c].method = eCol.attribute("method");
        cols_[c].field = eCol.attribute("field");
        cols_[c].width = eCol.attribute("width");
        c++;
      }
    } else {
      var s = q_.select();
      var aS = s.split(",");
      for (var i = 0; i < aS.length; i++) {
        cols_[c] = objetoColumna();
        cols_[c].field = aS[i];
        c++;
      }
      cols_[c] = objetoColumna();
      cols_[c].type = "method";
      cols_[c].method = "editRecord";
    }
  }


  function objetoColumna()
  {
    var c = new Object;
    c.type = "field";
    c.field = undefined;
    c.method = undefined;
    c.alias = undefined;
    c.width = undefined;

    return c;
  }

  function construyeQuery()
  {
    var s = construyeSelect();
    if (!s) {
      return false;
    }
    var _i = formt1_principal.iface;
    var f = _i.fromFastTable(accion_, accionRel_);
    if (!f) {
      return false;
    }
    var w = _i.whereFastTable(accion_, accionRel_, xml_);
    if (!w) {
      return false;
    }
    q_ = new AQSqlQuery;
    q_.setSelect(s);
    q_.setFrom(f);
    q_.setWhere(w);
  }

  function construyeSelect()
  {
    var _i = formt1_principal.iface;
    var _mgr = _i.mgr_;
    var s;

    var pk, tabla = accion_, tablaRel = accionRel_;
    if (xml_) {
      var mtd = _mgr.metadata(tablaRel);
      pk = tablaRel + "." + mtd.primaryKey();
      s = pk;

      var eCols = xml_.firstChild().namedItem("cols").toElement();
      var eCol;
      for (var xCol = eCols.firstChild(); xCol && !xCol.isNull(); xCol = xCol.nextSibling()) {
        eCol = xCol.toElement();
        if (eCol.attribute("type") != "field") {
          continue;
        }
        if (eCol.attribute("field") == pk) {
          continue;
        }
        s += ("," + eCol.attribute("field"));
      }
    } else {
      var mtd = _mgr.metadata(tablaRel);
      pk = mtd.primaryKey();
      s = tablaRel + "." + pk;
      var aCampos = AQUtil.nombreCampos(tablaRel);
      var numCampos = aCampos.shift();
      var c = 0, mtdCampo;
      for (var i = 0; i < numCampos; i++) {
        mtdCampo = mtd.field(aCampos[i]);
        if (!mtdCampo.visibleGrid()) {
          continue;
        }
        s += ("," + tablaRel + "." + aCampos[i]);
        if (++c > 5) {
          break;
        }
      }
    }
    return s;
  }


  function creaTabla()
  {
    cargaColorFilas();
    t_ = new QTable(w_, "T");
    t_.setColumnMovingEnabled(true);
    t_.font = font_; // w_.font;
    t_.paletteBackgroundColor = w_.paletteBackgroundColor;

    configuraTabla();
    llenaTabla();
  }

  function cargaColorFilas()
  {
    clrFila_ = new Object;
    clrFila_.par = new Color("white");
    clrFila_.impar = new Color("grey");
  }

  function refresca(estructura)
  {
    if (estructura) {
      configuraTabla();
    }
    llenaTabla();
  }

  function llenaTabla()
  {

    t_.setNumRows(0);
    var nC = cols_.length;
    debug("Consulta " + q_.sql());
    if (!q_.exec()) {
      return false;
    }
    var f = 0, texto;
    valorPk_ = [];

    /// Sirve para comprobar si las columnas se han movido al guardar
    t_.insertRows(f);
    t_.hideRow(f);
    for (var c = 0; c < nC; c++) {
      t_.setText(f, c, c);
    }
    valorPk_[f] = undefined;
    f++;

    while (q_.next()) {
      t_.insertRows(f);
      t_.setRowHeight(f, 25);
      llenaFila(f, q_);
      valorPk_[f] = q_.value(pk_);
      f++;
    }

    t_.setShowGrid(false);
    t_.focusStyle = QTable.FollowStyle;
    t_.selectionMode = QTable.NoSelection;
    //     t_.resize(ancho,   w_.height);

    connect(w_.child("T"), "clicked(int,int,int,const QPoint&)", this, "t_clicked");
  }

  function llenaFila(f, q)
  {
    var nC = cols_.length;
    var aR = accionRel_;
    var c, texto;

    for (c = 0; c < nC; c++) {
      // debug("tipo " + cols[c]["type"] + " f " + cols[c]["field"] + " m " + cols[c]["method"]);
      switch (cols_[c]["type"]) {
        case "field": {
          texto = cols_[c].mtd ? formateaTexto(q.value(cols_[c]["field"]), cols_[c].mtd) : q.value(cols_[c]["field"]);
          t_.setText(f, c, texto);
          break;
        }
        case "method": {
          /// Cambiar por XPath
          var m = cols_[c]["method"];
          var eActionMethod = formt1_principal.iface.dameElementoXML(formt1_principal.iface.xmlActions_.firstChild(), "action[@name=" + aR + "]/methods/method[@name=" + m + "]");
          if (eActionMethod && !eActionMethod.isNull()) {
            debug("icono para metodo " + m + " en " + formt1_principal.iface.imgPath_ + eActionMethod.attribute("icon"));
            var cPx = AQUtil.sqlSelect("t1_iconos", "i16x16", "nombre = '" + eActionMethod.attribute("icon") + "'");
            if (cPx) {
              var px = sys.toPixmap(cPx);
              t_.setPixmap(f, c, px);
            }
          }
          break;
        }
      }
    }
  }

  function guardaXml()
  {
    var xml = new FLDomDocument;
    xml.setContent("<ABNFastTable/>");
    //     xml.appendChild(x_);
    var e = xml.firstChild().toElement();

    var eGeo = xml.createElement("geo");
    eGeo.setAttribute("x", w_.x);
    eGeo.setAttribute("y", w_.y);
    eGeo.setAttribute("width", w_.width);
    eGeo.setAttribute("height", w_.height);
    e.appendChild(eGeo);

    //    var cols_;
    var numCols = t_.numCols;

    var eCols = xml.createElement("cols");
    e.appendChild(eCols);
    var eCol;
    var cI;
    for (var c = 0; c < numCols; c++) {
      cI = t_.text(0, c);
      eCol = xml.createElement("col");
      eCol.setAttribute("num", c);
      eCol.setAttribute("type", cols_[cI]["type"]);
      eCol.setAttribute("field", cols_[cI]["field"]);
      eCol.setAttribute("method", cols_[cI]["method"]);
      eCol.setAttribute("width", t_.columnWidth(parseInt(c)));
      //      eCol.setAttribute("alias", cols[cI]["alias"]);
      eCols.appendChild(eCol);
    }

    debug(xml.toString(4));
    return xml.toString(4);
  }


  function formateaTexto(t, mtdCampo)
  {
    var tipo = mtdCampo.type();
    var valor;
    switch (tipo) {
      case 26: { // Fecha
        valor = AQUtil.dateAMDtoDMA(t);
        break;
      }
      case 19: { // Double
        valor = AQUtil.formatoMiles(AQUtil.buildNumber(t, 'f', mtdCampo.partDecimal()));
        break;
      }
      default: {
        valor = t;
      }
    }
    return valor;
  }

  function dameAnchoCampo(mtdCampo, fM)
  {
    //debug("Campo " + campo  + " es tipo " + mtdCampo.type());
    var tipo = mtdCampo.type();
    var c = fM.width("0"), m = 10;
    var a;
    switch (tipo) {
      case 26: { // Fecha
        a = 10 * c;
        break;
      }
      case 3: { // String
        var  l = mtdCampo.length();
        l = l > 25 ? 25 : l;
        a = l * c;
        break;
      }
      case 19: { // Double
        a = (mtdCampo.partInteger() + mtdCampo.partDecimal() + 1) * c
            break;
      }
      default: {
        a = c * 10;
      }
    }
    a += m;
    return a;
  }

  function t_clicked(f, col)
  {
    debug("FT_t_clicked " + f + " " + col);
    if (col < 1) {
      return;
    }
    c = t_.text(0, col);
    debug("c " + c);
    switch (cols_[c]["type"]) {
      case "field": {
        var tabla = c_.accionRel;
        debug("tabla  " + tabla);
        if (tabla) {
          formt1_principal.iface.ponElementoActual(tabla, valorPk_[f]);
        }
        break;
      }
      case "method": {
        var m = cols_[c]["method"];
        debug(m);
        if (!m || m == "") {
          return;
        }
        var tDB = c_.accionRel;
        var eActionMethod = formt1_principal.iface.dameElementoXML(formt1_principal.iface.xmlActions_.firstChild(), "action[@name=" + tDB + "]/methods/method[@name=" + m + "]");
        if (!eActionMethod || eActionMethod.isNull()) {
          debug("No encuentra método " + m);
          return;
        }
        var fun = eActionMethod.attribute("function");
        var id = valorPk_[f];

        var llamada = fun + "('" + id + "', '" + tDB + "')";
        //var llamada = fun + "(" + id + ", '" + tDB + "')";
        debug("llamada " + llamada);
        try {
          eval(llamada);
        } catch (e) {
          MessageBox.warning(sys.translate("La llamada %1 ha fallado:\n").arg(llamada) + e, MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton, "AbanQ");
          return;
        }
        refrescaFila(f);
        break;
      }
    }
  }

  function refrescaFila(f)
  {
    //var q = this.q_;
    var cQ = q_;
    var q = new FLSqlQuery;
    q.setSelect(cQ.select());
    q.setFrom(cQ.from());
    q.setSelect(cQ.select());
    q.setSelect(cQ.select());
    //    var oldWhere = w.where();
    var clave = valorPk_[f];
    var tabla = c_.accionRel;
    var manager = aqApp.db().manager();
    var mtdRel = manager.metadata(tabla);
    var pk = mtdRel.primaryKey();
    var mtdPK = mtdRel.field(pk);
    var _mainI = formt1_principal.iface;
    var where = tabla + "." + pk + " = ";
    where += (mtdPK.type() ==  _mainI.ftSTRING_) ? "'" + clave + "'" : clave;
    q.setWhere(where);
    q.setForwardOnly(true);
    if (!q.exec()) {
      return;
    }
    if (!q.first()) {
      return;
    }
    llenaFila(f, q)
  }

}

class ABNMethod
{
  var e_;
  var _i = formt1_principal.iface;

  function ABNMethod(action, name)
  {
    e_ = _i.dameElementoXML(_i.xmlActions_.firstChild(), "action[@name=" + action + "]/methods/method[@name=" + name + "]");
    if (!e_ || e_.isNull()) {
      sys.errorMsgBox(sys.translate("Error al buscar el método %1 asociado a la acción %2").arg(name).arg(action));
      return;
    }
  }

  function exec(c)
  {
    _i.llamaFuncionCursor(e_.attribute("function"), c);
  }
}

class ABNFastFields extends ABNWidget
{
  var t_;
  var aRows_;

  function ABNFastFields(parent, name, x, cursor)
  {
    ABNWidget(parent, name, x, cursor, "ABNFastFields");

    creaTabla();

    var vLay = new QVBoxLayout(w_);
    vLay.addWidget(tB_);
    vLay.addWidget(t_);
    vLay.addWidget(tbnEditar_);
  }


  function creaTabla()
  {
    var x = x_;
    var cursor = cur_;
    t_ = new QTable(w_, "T");
    debug(x.toString(4));

    var xRows = x.namedItem("rows");
    var nR = xRows.childNodes().count();
    var rL = [], e, r = 0;
    debug(xRows.isNull());
    aRows_ = new Array(nR);

    t_.setNumCols(4);
    t_.hideColumn(1);
    t_.setNumRows(nR);

    var manager = aqApp.db().manager();
    var  f = this.t_.font;
    var fM = new QFontMetrics(f);
    var fN, fL, label;
    var mtdCampo, ancho = 0, anchoCol;
    var mtdTabla = manager.metadata(cursor.table());
    for (var xRow = xRows.firstChild(); !xRow.isNull(); xRow = xRow.nextSibling()) {
      e = xRow.toElement();
      rL.push(e.attribute("label"));
      switch (e.attribute("type")) {
        case "field": {
          fN = e.attribute("field");
          label = e.attribute("label");
          mtdCampo = mtdTabla.field(fN);
          label = label == "auto" ? mtdCampo.alias() : label;
          fL = e.attribute("fieldlabel") != "" ? e.attribute("fieldlabel") : fN;
          var eActionMethod = formt1_principal.iface.dameElementoXML(formt1_principal.iface.xmlActions_.firstChild(), "action/methods/method@name='" + e.attribute("method") + "'");
          if (eActionMethod && !eActionMethod.isNull()) {
            e.setAttribute("icon", eActionMethod.attribute("icon"));
            e.setAttribute("function", eActionMethod.attribute("function"));
          }
          break;
        }
      }
      aRows_[r] = [];
      aRows_[r]["e"] = e;
      aRows_[r]["mtd"] = mtdCampo;
      aRows_[r]["field"] = fN;
      aRows_[r]["fieldlabel"] = fL;
      aRows_[r]["label"] = label;
      r++;
    }
    debug("for ended");
    t_.setRowLabels(rL);
    t_.verticalHeader().close();
    t_.horizontalHeader().close();
    t_.setLeftMargin(0);
    t_.setTopMargin(0);

    for (r = 0; r < nR; r++) {
      t_.setText(r, 0, aRows_[r]["label"]);
      t_.setText(r, 1, cursor.valueBuffer(aRows_[r]["field"]));
      t_.setText(r, 2, cursor.valueBuffer(aRows_[r]["fieldlabel"]));
      var px = new Pixmap(aRows_[r].e.attribute("icon"), "png");
      t_.setPixmap(r, 3, px);
    }

    t_.setShowGrid(false);
    t_.focusStyle = QTable.FollowStyle;
    t_.selectionMode = QTable.NoSelection;
    connect(w_.child("T"), "clicked(int,int,int,const QPoint&)", this, "t_clicked");
  }


  function t_clicked(r, c)
  {
    var _i = formt1_principal.iface;
    if (c != 2) {
      return;
    }
    debug("FT_t_clicked " + r + " " + c);
    var m = aRows_[r].e.attribute("method");
    debug(m);
    if (!m || m == "") {
      return;
    }
    debug("Metodo fast field " + m);
    switch (m) {
      case "moveDashboard":
      case "moveDashBoard": {
        var mtdCampo = aRows_[r]["mtd"];
        var mtdRelM1 = mtdCampo.relationM1();
        if (!mtdRelM1) {
          return;
        }

        var clave = cur_.valueBuffer(aRows_[r]["field"]);
        var tablaM1 = mtdRelM1.foreignTable();
        if (tablaM1) {
          formt1_principal.iface.ponElementoActual(tablaM1, clave);
        }
        break;
      }
      default: {
        debug("action[@name=" + cur_.table() + "]/methods/method[@name=" + m + "]");
        var oMethod = _i.newObject("ABNMethod", cur_.table(), m);
        oMethod.exec(cur_);

        break;
      }
    }
  }

}

function oficial_newObject(clase, p1, p2)
{
  return eval("new " + clase + "(" + p1 + ", " + p2 + ")"); // new ABNMethod(p1, p2);
}



function oficial_muestraElementoActual()
{
  var aElemento = this.iface.dameElementoActual();
  this.iface.muestraElemento(aElemento.tipo, aElemento.clave);
  return true;
}
/*
function oficial_cargaAcciones()
{
  var aElemento = this.iface.aHistorialElementos_[this.iface.iElementoHistorial_];

  var qryAcciones = new FLSqlQuery;
  qryAcciones.setTablesList("t1_accioneselemento");
  qryAcciones.setSelect("accion, funcion, icono, tecla");
  qryAcciones.setFrom("t1_accioneselemento");
  qryAcciones.setWhere("elemento = '" + aElemento["tipo"] + "'");
  qryAcciones.setForwardOnly(true);
  if (!qryAcciones.exec()) {
    return false;
  }
  var iAccion = 0;
  this.iface.eliminarAccels();
  delete this.iface.aAcciones_;
  this.iface.aAcciones_ = new Array(qryAcciones.size());
  var tecla: String;
  while (qryAcciones.next()) {
    tecla = qryAcciones.value("tecla");
    this.iface.aAcciones_[iAccion] = [];
    this.iface.aAcciones_[iAccion]["nombre"] = qryAcciones.value("accion");
    this.iface.aAcciones_[iAccion]["funcion"] = qryAcciones.value("funcion");
    this.iface.aAcciones_[iAccion]["icono"] = qryAcciones.value("icono");
    this.iface.aAcciones_[iAccion]["tecla"] = tecla;
    debug("tecla = " + tecla);
    this.iface.aAcciones_[iAccion]["accel"] = (tecla && tecla != "") ? this.child("fdbBuscar").insertAccel("Ctrl+" + tecla) : 0;
    iAccion++;
  }
  return true;
}
*/

function oficial_eliminarAccels()
{
  /*
  if (!this.iface.aAcciones_) {
    return true;
  }
  var iAccel: Number;
  for (var i = 0; i < this.iface.aAcciones_.length; i++) {
    iAccel = this.iface.aAcciones_[i]["accel"];
    if (iAccel != 0) {
      this.child("fdbBuscar").removeAccel(iAccel);
    }
  }
  */
}

/** \D Busca el índice de una relación en el array actual para un id de la tabla de relaciones por usuario y grupo
@param  idUG: Id de la tabla de relaciones por usuario y grupo
@return índice en el array o -1 si no se encuentra;
\end */
/*
function oficial_dameIndiceRelacionPorRUG(idUG: Number)
{
  var indice = -1;
  if (!this.iface.aRelaciones_) {
    return indice;
  }
  for (var i = 0; i < this.iface.aRelaciones_.length; i++) {
    if (this.iface.aRelaciones_[i]["idug"] == idUG) {
      indice = i;
      break;
    }
  }
  return indice;
}
*/

/** \D Busca el índice de una relación en el array actual para un id de la tabla de relaciones
@param  idUG: Id de la tabla de relaciones
@return índice en el array o -1 si no se encuentra;
\end */
/*
function oficial_dameIndiceRelacionPorR(idRel: Number)
{
  var indice = -1;
  if (!this.iface.aRelaciones_) {
    return indice;
  }
  for (var i = 0; i < this.iface.aRelaciones_.length; i++) {
    if (this.iface.aRelaciones_[i]["id"] == idRel) {
      indice = i;
      break;
    }
  }
  return indice;
}
*/
/** \Ð Carga el array global de relaciones.
@param  iRelPrevia: Si está informado se recarga únicamente la relación indicada ya existente en el array
\end */
/*
function oficial_cargaRelaciones(iRelPrevia: String)
{
  var util = new FLUtil;
  var aElemento = this.iface.aHistorialElementos_[this.iface.iElementoHistorial_];

  var whereRel = "e.elemento = '" + aElemento["tipo"] + "' AND idusuario = '" + this.iface.idUsuario_ + "'";
  var iRel: Number
  if (iRelPrevia) {
    var idUG = this.iface.aRelaciones_[iRelPrevia]["idug"];
    whereRel += " AND re.idrelacionelementoug = " + idUG;
    iRel = iRelPrevia;
  } else {
    iRel = 0;
  }
  var qryRelaciones = new FLSqlQuery;
  qryRelaciones.setTablesList("t1_relacioneselementoug,t1_elementosug");
  qryRelaciones.setSelect("re.idrelacionelementoug, re.idrelacionelemento, re2.relacion, re2.card, re2.mainfilter, re.xmlpicrelacion, re.xmlpicelemento, e.xmlpicelemento, re.ordercols, re2.ordercols, re.filtro, re.textorel, re2.textorel, re2.solomostrarsihay, e2.elemento");
  qryRelaciones.setFrom("t1_elementosug e INNER JOIN t1_relacioneselementoug re ON e.idelementoug = re.idelementoug INNER JOIN t1_relacioneselemento re2 ON re.idrelacionelemento = re2.idrelacionelemento INNER JOIN t1_elementos e2 ON re2.relacion = e2.elemento");
  qryRelaciones.setWhere(whereRel + " ORDER BY re.orden");
  qryRelaciones.setForwardOnly(true);
  if (!qryRelaciones.exec()) {
    return false;
  }
  debug(qryRelaciones.sql());
  if (!iRelPrevia) {
    delete this.iface.aRelaciones_ ;
    this.iface.aRelaciones_ = new Array(qryRelaciones.size());
  }
  var xmlPic: String, xmlDocPic: FLDomDocument, orderCols: String, filtroPpal: String, filtro: String, filtroCompleto: String;
  while (qryRelaciones.next()) {
    this.iface.aRelaciones_[iRel] = [];
    this.iface.aRelaciones_[iRel]["id"] = qryRelaciones.value("re.idrelacionelemento");
    this.iface.aRelaciones_[iRel]["idug"] = qryRelaciones.value("re.idrelacionelementoug");
    this.iface.aRelaciones_[iRel]["nombre"] = qryRelaciones.value("re2.relacion");
    this.iface.aRelaciones_[iRel]["card"] = qryRelaciones.value("re2.card");
    this.iface.aRelaciones_[iRel]["solomostrarsihay"] = qryRelaciones.value("re2.solomostrarsihay");

    filtroPpal = qryRelaciones.value("re2.mainfilter");
    if (filtroPpal && filtroPpal != "") {
      this.iface.aRelaciones_[iRel]["filtroPpal"] = this.iface.dameFiltroPrincipal(filtroPpal, aElemento["clave"]);
      this.iface.aRelaciones_[iRel]["filtroCompleto"] = "(" + this.iface.aRelaciones_[iRel]["filtroPpal"] + ")";
    } else {
      this.iface.aRelaciones_[iRel]["filtroPpal"] = "";
      this.iface.aRelaciones_[iRel]["filtroCompleto"] = "";
    }

    filtro = qryRelaciones.value("re.filtro");
    if (filtro && filtro != "") {
      this.iface.aRelaciones_[iRel]["filtro"] = filtro;
      if (filtroPpal != "") {
        this.iface.aRelaciones_[iRel]["filtroCompleto"] += "AND (" + filtro + ")";
      } else {
        this.iface.aRelaciones_[iRel]["filtroCompleto"] = filtro;
      }
    } else {
      this.iface.aRelaciones_[iRel]["filtro"] = "";
    }

    xmlPic = qryRelaciones.value("re.xmlpicrelacion");
    if (xmlPic && xmlPic != "") {
      xmlDocPic = new FLDomDocument;
      xmlDocPic.setContent(xmlPic);
    } else {
      xmlDocPic = false;
    }
    this.iface.aRelaciones_[iRel]["xmlPicRelacion"] = xmlDocPic;

    textoRel = qryRelaciones.value("re.textorel");
    if (!textoRel || textoRel == "") {
      textoRel = qryRelaciones.value("re2.textorel");
      if (!textoRel || textoRel == "") {
        textoRel = util.tableNameToAlias(qryRelaciones.value("e2.elemento"));
      }
    }
    this.iface.aRelaciones_[iRel]["textoRel"] = textoRel;

    xmlPic = qryRelaciones.value("re.xmlpicelemento");
    if (!xmlPic || xmlPic == "") {
      xmlDocPic = new FLDomDocument;
      xmlDocPic.setContent(xmlPic);
    } else {
      xmlPic = qryRelaciones.value("e.xmlpicelemento");
      if (xmlPic && xmlPic != "") {
        xmlDocPic = new FLDomDocument;
        xmlDocPic.setContent(xmlPic);
      } else {
        xmlDocPic = false;
      }
    }
    this.iface.aRelaciones_[iRel]["xmlPicElemento"] = xmlDocPic;

    orderCols = qryRelaciones.value("re.ordercols");
    if (!orderCols || orderCols == "") {
      orderCols = qryRelaciones.value("re2.ordercols");
      if (!orderCols || orderCols == "") {
        orderCols = "";
      }
    }
    this.iface.aRelaciones_[iRel]["orderCols"] = (orderCols == "" ? false : orderCols.split(","));

    iRel++;
  }
  return true;
}
*/
/*
function oficial_muestraAcciones()
{
  this.iface.tblAcciones_.setNumRows(0);
  var totalAcciones = this.iface.aAcciones_.length;
  var iFila = 0, iCol = 0;
  var numCols = this.iface.xAcciones_;
  debug("totalAcciones " + totalAcciones);
  for (var iAccion = 0; iAccion < totalAcciones; iAccion++) {
    iFila = Math.floor(iAccion / numCols);
    iCol = iAccion % numCols;
    if (iCol == 0) {
      this.iface.tblAcciones_.insertRows(iFila);
      this.iface.tblAcciones_.setRowHeight(iFila, 32);
    }
    var pixIcono = sys.toPixmap(this.iface.aAcciones_[iAccion]["icono"]);
    this.iface.tblAcciones_.setText(iFila, iCol, this.iface.aAcciones_[iAccion]["tecla"]);
    this.iface.tblAcciones_.setPixmap(iFila, iCol, pixIcono);
  }
  return true;
}
*/
/*
function oficial_muestraAccionesRel()
{
  this.iface.tblAccionesRel_.setNumRows(0);
  var totalAcciones = this.iface.aAccionesRel_.length;
  var iFila = 0, iCol = 0;
  var numCols = this.iface.xAcciones_;
  debug("totalAcciones " + totalAcciones);
  for (var iAccion = 0; iAccion < totalAcciones; iAccion++) {
    iFila = Math.floor(iAccion / numCols);
    iCol = iAccion % numCols;
    if (iCol == 0) {
      this.iface.tblAccionesRel_.insertRows(iFila);
      this.iface.tblAccionesRel_.setRowHeight(iFila, 32);
    }
    var pixIcono = sys.toPixmap(this.iface.aAccionesRel_[iAccion]["icono"]);
    this.iface.tblAccionesRel_.setText(iFila, iCol, this.iface.aAccionesRel_[iAccion]["tecla"]);
    this.iface.tblAccionesRel_.setPixmap(iFila, iCol, pixIcono);
  }
  return true;
}
*/

function oficial_llamaFuncionCursor(nombreF, cur_)
{
  debug("Ejecutando " + nombreF + "(cur_)");
  var f = new Function("c", nombreF + "(c);");
  var res;
  try {
    res = f(cur_);
  } catch (e) {
    sys.errorMsgBox(sys.translate("Error al llamar a la función %1").arg(nombreF) + ":\n" + e);
    res = false;
  }
  return res;
}

function oficial_dameElementoActual()
{
  return this.iface.aHistorialElementos_[this.iface.iElementoHistorial_];
}

/*
function oficial_muestraRelaciones()
{
  this.iface.tblRelaciones_.clear();
  var aElemento = this.iface.dameElementoActual();

  var totalRelaciones = this.iface.aRelaciones_.length;
  var nombreRel: String, card: String, textoRel: String;
  var aDatosRel: Array;
  var iFila = 0;
  for (var iRel = 0; iRel < totalRelaciones; iRel++) {
    nombreRel = this.iface.aRelaciones_[iRel]["nombre"];
    card = this.iface.aRelaciones_[iRel]["card"];
    aDatosRel = this.iface.dameDatosRelacion(aElemento["tipo"], aElemento["clave"], iRel);
    if (aDatosRel) {
      try  {
        if (aDatosRel["c"]["Cuenta"] == 0 && this.iface.aRelaciones_[iRel]["solomostrarsihay"]) {
          continue;
        }
        if (aDatosRel["c"]["Cuenta"] == 1) {
          card = "11";
        }
      } catch (e) {}
    }
    this.iface.tblRelaciones_.insertRows(iFila);
    this.iface.tblRelaciones_.setRowHeight(iFila, 32);
    this.iface.tblRelaciones_.setText(iFila, this.iface.CR_IDREL, iRel);
    this.iface.tblRelaciones_.setText(iFila, this.iface.CR_TIPO, nombreRel);
    this.iface.tblRelaciones_.setText(iFila, this.iface.CR_CARD, card);
    this.iface.dibujarIconoTabla(this.iface.tblRelaciones_, iFila, this.iface.CR_ICONO, this.iface.aRelaciones_[iRel]["nombre"]);

    if (aDatosRel) {
      textoRel = this.iface.componTextoRel(this.iface.aRelaciones_[iRel]["textoRel"], aDatosRel);
      this.iface.tblRelaciones_.setText(iFila, this.iface.CR_DESC, textoRel);
    }
    iFila++;
  }
  return true;
}

function oficial_dameDatosRelacion(tipo: String, clave: String, iRel: Number)
{
  var card = this.iface.aRelaciones_[iRel]["card"];
  var nombreRel = this.iface.aRelaciones_[iRel]["nombre"];
  var filtroCompleto = this.iface.aRelaciones_[iRel]["filtroCompleto"];
  debug("oficial_dameDatosRelacion " + tipo + " nombreRel = " + nombreRel);
  var util = new FLUtil;
  var des = "", claveRel = "";
  var aDatos = [];
  aDatos["c"] = []; /// Array de campos
  aDatos["n"] = []; /// Array de nombres de campo
  aDatos["i"] = []; /// Array de índices
  var codigoRel = tipo + " >> " + nombreRel;
  var tablaRel = this.iface.dameTablaElemento(nombreRel);
  switch (codigoRel) {
    case "clientes >> crm_contactos": {
      var qry = new FLSqlQuery;
      qry.setTablesList("contactosclientes,crm_contactos");
      qry.setSelect("COUNT(*)");
      qry.setFrom("contactosclientes cc INNER JOIN crm_contactos c ON cc.codcontacto = c.codcontacto");
      qry.setWhere("cc.codcliente = '" + clave + "'");
      qry.setForwardOnly(true);
      if (!qry.exec()) {
        return false;
      }
      var numRegistros = 0;
      if (qry.first()) {
        numRegistros = qry.value("COUNT(*)");
      }
      var i = 0;
      aDatos["c"]["Cuenta"] = numRegistros;
      aDatos["n"][i] = util.translate("scripts", "Cuenta");
      aDatos["i"][i] = "Cuenta";
      i++;
      break;
    }
    case "albaranescli >> facturascli":
    case "albaranesprov >> facturasprov": {
      aDatos = this.iface.dameArrayCamposElementoRel(tipo, tablaRel);
      if (!aDatos) {
        return false;
      }
      var qry = new FLSqlQuery;
      qry.setTablesList(nombreRel);
      qry.setSelect(aDatos["i"].concat(","));
      qry.setFrom(nombreRel);
      qry.setWhere(filtroCompleto);
      qry.setForwardOnly(true);
      if (!qry.exec()) {
        return false;
      }
      var cuenta;
      if (qry.first()) {
        cuenta = 1;
        for (var i = 0; i < aDatos["i"].length; i++) {
          aDatos["c"][aDatos["i"][i]] = qry.value(aDatos["i"][i]);
        }
      } else {
        cuenta = 0;
      }
      var iDatos = aDatos["i"].length;
      aDatos["c"]["Cuenta"] = cuenta;
      aDatos["n"][iDatos] = util.translate("scripts", "Cuenta");
      aDatos["i"][iDatos] = "Cuenta";
      break;
    }
   case "t1_home >> facturascli": {
      var cuenta = 0;
      var importe = 0;
      var q = new FLSqlQuery();
      q.setTablesList(tablaRel);
      q.setSelect("COUNT(*), SUM(total)");
      q.setFrom(tablaRel);
      q.setWhere(filtroCompleto);
      q.setForwardOnly(true);
      if (!q.exec()) {
        return false;
      }
      if (q.first()) {
        cuenta = q.value("COUNT(*)");
        importe = q.value("SUM(total)");
        importe = util.roundFieldValue(importe, "facturascli", "total");
      }
      var i = 0;
      aDatos["c"]["Cuenta"] = cuenta;
      aDatos["n"][i] = util.translate("scripts", "Número de facturas");
      aDatos["i"][i] = "Cuenta";
      i++;
      aDatos["c"]["Importe"] = importe;
      aDatos["n"][i] = util.translate("scripts", "Importe total");
      aDatos["i"][i] = "Importe";
      i++;
      break;
    }
    case "t1_home >> crm_oportunidadventa": {
      var cuenta = 0;
      var importe = 0;
      var q = new FLSqlQuery();
      q.setTablesList(tablaRel);
      q.setSelect("COUNT(*), SUM(totalventa * probabilidad)");
      q.setFrom(tablaRel);
      q.setWhere(filtroCompleto);
      q.setForwardOnly(true);
      if (!q.exec()) {
        return false;
      }
      debug(q.sql());
      if (q.first()) {
        cuenta = q.value("COUNT(*)");
        importe = cuenta == 0 ? 0 : q.value("SUM(totalventa * probabilidad)") / (cuenta * 100);
        importe = util.roundFieldValue(importe, "crm_oportunidadventa", "totalventa");
      }
      var i = 0;
      aDatos["c"]["Cuenta"] = cuenta;
      aDatos["n"][i] = util.translate("scripts", "Número oportunidades");
      aDatos["i"][i] = "Cuenta";
      i++;
      aDatos["c"]["Importe"] = importe;
      aDatos["n"][i] = util.translate("scripts", "Importe probable");
      aDatos["i"][i] = "Importe";
      i++;
      break;
    }
    default: {
      if (card == "M1" || card == "11") {
        aDatos = this.iface.dameArrayCamposElementoRel(tipo, tablaRel);
        if (!aDatos) {
          return false;
        }
        var qry = new FLSqlQuery;
        qry.setTablesList(tablaRel);
        qry.setSelect(aDatos["i"].concat(","));
        qry.setFrom(tablaRel);
        qry.setWhere(filtroCompleto);
        qry.setForwardOnly(true);
        if (!qry.exec()) {
          return false;
        }
        if (qry.first()) {
          for (var i = 0; i < aDatos["i"].length; i++) {
            aDatos["c"][aDatos["i"][i]] = qry.value(aDatos["i"][i]);
          }
        }
      } else {
        var cuenta = 0;
        var importe = 0;
        var q = new FLSqlQuery();
        q.setTablesList(tablaRel);
        q.setSelect("COUNT(*)");
        q.setFrom(tablaRel);
        q.setWhere(filtroCompleto);
        q.setForwardOnly(true);
        if (!q.exec()) {
          return false;
        }
        if (q.first()) {
          cuenta = q.value("COUNT(*)");
        }
        var i = 0;
        aDatos["c"]["Cuenta"] = cuenta;
        aDatos["n"][i] = util.translate("scripts", "Número de registros");
        aDatos["i"][i] = "Cuenta";
        i++;
      }
      break;
    }
  }

  return aDatos;
}
*/
/*
function oficial_dameDatosRelFacturasCli(aDatos: Array, where: String)
{
  var util = new FLUtil;
  var qry = new FLSqlQuery;
  qry.setTablesList("facturascli");
  qry.setSelect("COUNT(*), SUM(total)");
  qry.setFrom("facturascli");
  qry.setWhere(where);
  qry.setForwardOnly(true);
  if (!qry.exec()) {
    return false;
  }
  var numFacturas = 0, total = 0;
  if (qry.first()) {
    numFacturas = qry.value("COUNT(*)");
    total = qry.value("SUM(total)");
  }
  var i = 0;
  aDatos["c"]["numFacturas"] = numFacturas;
  aDatos["n"][i] = util.translate("scripts", "Número de facturas");
  aDatos["i"][i] = "numFacturas";
  i++;

  aDatos["c"]["total"] = util.roundFieldValue(total, "facturascli", "total");
  aDatos["n"][i] = util.translate("scripts", "Importe total");
  aDatos["i"][i] = "total";
  i++;
  return true;
}

function oficial_dameDatosRelAlbaranesCli(aDatos: Array, where: String)
{
  var util = new FLUtil;
  var qry = new FLSqlQuery;
  qry.setTablesList("albaranescli");
  qry.setSelect("COUNT(*), SUM(total)");
  qry.setFrom("albaranescli");
  qry.setWhere(where);
  qry.setForwardOnly(true);
  if (!qry.exec()) {
    return false;
  }
  var numRegistros = 0, total = 0;
  if (qry.first()) {
    numRegistros = qry.value("COUNT(*)");
    total = qry.value("SUM(total)");
  }
  var i = 0;
  aDatos["c"]["numAlbaranes"] = numRegistros;
  aDatos["n"][i] = util.translate("scripts", "Número de albaranes");
  aDatos["i"][i] = "numAlbaranes";
  i++;

  aDatos["c"]["total"] = util.roundFieldValue(total, "albaranescli", "total");
  aDatos["n"][i] = util.translate("scripts", "Importe total");
  aDatos["i"][i] = "total";
  i++;
  return true;
}

function oficial_dameDatosRelPedidosCli(aDatos: Array, where: String)
{
  var util = new FLUtil;
  var qry = new FLSqlQuery;
  qry.setTablesList("pedidoscli");
  qry.setSelect("COUNT(*), SUM(total)");
  qry.setFrom("pedidoscli");
  qry.setWhere(where);
  qry.setForwardOnly(true);
  if (!qry.exec()) {
    return false;
  }
  var numRegistros = 0, total = 0;
  if (qry.first()) {
    numRegistros = qry.value("COUNT(*)");
    total = qry.value("SUM(total)");
  }
  var i = 0;
  aDatos["c"]["numPedidos"] = numRegistros;
  aDatos["n"][i] = util.translate("scripts", "Número de pedidos");
  aDatos["i"][i] = "numPedidos";
  i++;

  aDatos["c"]["total"] = util.roundFieldValue(total, "pedidoscli", "total");
  aDatos["n"][i] = util.translate("scripts", "Importe total");
  aDatos["i"][i] = "total";
  i++;
  return true;
}

function oficial_dameDatosRelPresupuestosCli(aDatos: Array, where: String)
{
  var util = new FLUtil;
  var qry = new FLSqlQuery;
  qry.setTablesList("presupuestoscli");
  qry.setSelect("COUNT(*), SUM(total)");
  qry.setFrom("presupuestoscli");
  qry.setWhere(where);
  qry.setForwardOnly(true);
  if (!qry.exec()) {
    return false;
  }
  var numRegistros = 0, total = 0;
  if (qry.first()) {
    numRegistros = qry.value("COUNT(*)");
    total = qry.value("SUM(total)");
  }
  var i = 0;
  aDatos["c"]["numPresupuestos"] = numRegistros;
  aDatos["n"][i] = util.translate("scripts", "Número de presupuestos");
  aDatos["i"][i] = "numPresupuestos";
  i++;

  aDatos["c"]["total"] = util.roundFieldValue(total, "presupuestoscli", "total");
  aDatos["n"][i] = util.translate("scripts", "Importe total");
  aDatos["i"][i] = "total";
  i++;
  return true;
}
*/
/*
function oficial_revisarBD()
{
  var aElementos = flfactppal.iface.pub_dameElementosT1();

  var cursor = new FLSqlCursor("t1_elementos");
  var aElemento: Array, accion: String, tabla: String;
  for (var i = 0; i < aElementos.length; i++) {
    aElemento = aElementos[i];
    accion = aElemento[0];
    if (aElemento.length > 1) {
      tabla = aElemento[1];
    } else {
      tabla = accion;
    }
    cursor.select("elemento = '" + aElementos[i][0] + "'");
    if (!cursor.first()) {
      cursor.setModeAccess(cursor.Insert);
      cursor.refreshBuffer();
      cursor.setValueBuffer("elemento", accion);
      cursor.setValueBuffer("tabla", tabla);
      if (!cursor.commitBuffer()) {
        return false;
      }
    }
  }
  /// Todos los elementos se relacionan con el elemento Home en relación 1-M
  cursor = new FLSqlCursor("t1_relacioneselemento");
  for (var i = 0; i < aElementos.length; i++) {
    cursor.select("elemento = 't1_home' AND relacion = '" + aElementos[i][0] + "'");
    if (!cursor.first()) {
      cursor.setModeAccess(cursor.Insert);
      cursor.refreshBuffer();
      cursor.setValueBuffer("elemento", "t1_home");
      cursor.setValueBuffer("relacion", aElementos[i][0]);
      cursor.setValueBuffer("card", "1M");
      if (!cursor.commitBuffer()) {
        return false;
      }
    }
  }

  var aAcciones = [["clientes", "generarFactura", "generarFacturaCli", "F"],
                   ["clientes", "generarAlbaran", "generarAlbaranCli", "A"],
                   ["clientes", "generarPedido", "generarPedidoCli", "P"],
                   ["clientes", "generarPresupuesto", "generarPresupuestoCli", "R"],
                   ["facturascli", "imprimirFactura", "imprimirDocumento", "I"],
                   ["presupuestoscli", "aprobarPresupuesto", "aprobarPresupuestoCli", "P"],
                   ["pedidoscli", "servirPedido", "servirPedidoCli", "A"],
                   ["albaranescli", "facturarAlbaran", "facturarAlbaranCli", "F"],
                   ["reciboscli", "pagarRecibo", "pagarReciboCli", "P"]];
  cursor = new FLSqlCursor("t1_accioneselemento");
  for (var i = 0; i < aAcciones.length; i++) {
    cursor.select("elemento = '" + aAcciones[i][0] + "' AND accion = '" + aAcciones[i][1] + "'");
    if (!cursor.first()) {
      cursor.setModeAccess(cursor.Insert);
      cursor.refreshBuffer();
      cursor.setValueBuffer("elemento", aAcciones[i][0]);
      cursor.setValueBuffer("accion", aAcciones[i][1]);
      cursor.setValueBuffer("funcion", aAcciones[i][2]);
      cursor.setValueBuffer("tecla", aAcciones[i][3]);
      if (!cursor.commitBuffer()) {
        return false;
      }
    }
  }

  var aRelaciones = flfactppal.iface.pub_dameRelacionesT1();
  cursor = new FLSqlCursor("t1_relacioneselemento");
  var card1: String;
  card2: String;
  for (var i = 0; i < aRelaciones.length; i++) {
    cursor.select("elemento = '" + aRelaciones[i][0] + "' AND relacion = '" + aRelaciones[i][1] + "'");
    if (!cursor.first()) {
      cursor.setModeAccess(cursor.Insert);
      cursor.refreshBuffer();
      cursor.setValueBuffer("elemento", aRelaciones[i][0]);
      cursor.setValueBuffer("relacion", aRelaciones[i][1]);
      if (aRelaciones[i].length > 2) {
        card1 = aRelaciones[i][2];
        card2 = aRelaciones[i][2];
      } else {
        card1 = "1M";
        card2 = "M1";
      }
      cursor.setValueBuffer("card", card1);
      if (!cursor.commitBuffer()) {
        return false;
      }

      cursor.setModeAccess(cursor.Insert);
      cursor.refreshBuffer();
      cursor.setValueBuffer("elemento", aRelaciones[i][1]);
      cursor.setValueBuffer("relacion", aRelaciones[i][0]);
      cursor.setValueBuffer("card", card2);
      if (!cursor.commitBuffer()) {
        return false;
      }
    }
  }
}
*/

function oficial_tbnCargarIconos_clicked()
{
  var util = new FLUtil;
  var directorio = FileDialog.getExistingDirectory("", util.translate("scripts", "Seleccione directorio de iconos"));
  if (!directorio) {
    return false;
  }
  var dDir = new Dir(directorio);
  var aIconos = dDir.entryList("*", Dir.Files);
  var nombre: String, contenido: String;
  var fFichero;
  var curElemento = new FLSqlCursor("t1_elementos");
  var curAccion = new FLSqlCursor("t1_accioneselemento");
  for (var i = 0; i < aIconos.length; i++) {
    fFichero = new File(aIconos[i]);
    if (fFichero.extension != "xpm") {
      continue;
    }
    contenido = File.read(directorio + aIconos[i]);
    nombre = fFichero.baseName;
    prefijo = nombre.left(2);
    nombre = nombre.right(nombre.length - 2);
    switch (prefijo) {
      case "e_": {
        curElemento.select("elemento = '" + nombre + "'");
        if (curElemento.first()) {
          curElemento.setModeAccess(curElemento.Edit);
          curElemento.refreshBuffer();
          curElemento.setValueBuffer("icono", contenido);
          if (!curElemento.commitBuffer()) {
            return false;
          }
        }
        break;
      }
      case "a_": {
        curAccion.select("funcion = '" + nombre + "'");
        if (curAccion.first()) {
          curAccion.setModeAccess(curAccion.Edit);
          curAccion.refreshBuffer();
          curAccion.setValueBuffer("icono", contenido);
          if (!curAccion.commitBuffer()) {
            return false;
          }
        }
        break;
      }
    }

  }
  MessageBox.information(util.translate("scripts", "Iconos cargados correctamente"), MessageBox.Ok, MessageBox.NoButton);
  return true;
}

function oficial_bufferChanged(fN)
{
  switch (fN) {
    case "buscar": {
      break;
    }
  }
}

/*
function oficial_editarElementoSel()
{
  if (this.iface.iElementoHistorial_ == -1) {
    return false;
  }

  var aElemento = this.iface.aHistorialElementos_[this.iface.iElementoHistorial_];
  if (!aElemento) {
    return false;
  }
  this.iface.editarElemento(aElemento["tipo"], aElemento["clave"]);
}

function oficial_editarElemento(tipo: String, clave: String)
{
  if (!this.iface.curObjeto_ || this.iface.curObjeto_.action() != tipo) {
    delete this.iface.curObjeto_;
    this.iface.curObjeto_ = new FLSqlCursor(tipo);
  }
  var campoClave = this.iface.curObjeto_.primaryKey();
  var tipoClave = this.iface.curObjeto_.fieldType(campoClave);
  switch (tipoClave) {
    case 3: {
      this.iface.curObjeto_.select(campoClave + " = '" + clave + "'");
      break;
    }
    default: {
      this.iface.curObjeto_.select(campoClave + " = " + clave);
    }
  }
  if (!this.iface.curObjeto_.first()) {
    return false;
  }
  this.iface.curObjeto_.editRecord();
}
*/
/*
function oficial_recargaElementoActual()
{
  var aElemento = this.iface.aHistorialElementos_[this.iface.iElementoHistorial_];
  if (!aElemento) {
    return false;
  }
  this.iface.cargaElementos(aElemento["tipo"]);
  this.iface.actualizaDatosForm();
}
*/

/** \D Carga el array de elementos en memoria
elemento: Si viene informado, recarga únicamente el elemento indicado
\end */
/*
function oficial_cargaElementos(elemento: String)
{
  if (!elemento) {
    if (this.iface.aElementos_) {
      delete this.iface.aElementos_;
      delete this.iface.aIndiceElementos_;
    }
    this.iface.aElementos_ = [];
    this.iface.aIndiceElementos_ = [];
  }
  var qryElementos = new FLSqlQuery;
  qryElementos.setTablesList("t1_elementos");
  qryElementos.setSelect("elemento, tabla, icono, xmlpic, descripcion");
  qryElementos.setFrom("t1_elementos");
  qryElementos.setWhere(elemento ? "elemento = '" + elemento + "'" : "1 = 1");
  qryElementos.setForwardOnly(true);
  if (!qryElementos.exec()) {
    return false;
  }
  var indice = 0;
  var elemento: String, icono: String, xmlPic: String, tabla: String;
  var xmlDocPic: FLDomDocument, pixIcono: Pixmap;
  while (qryElementos.next()) {
    elemento = qryElementos.value("elemento");
    icono = qryElementos.value("icono");
    pixIcono = icono && icono != "" ? sys.toPixmap(icono) : false;
    tabla = qryElementos.value("tabla");
    tabla = (tabla && tabla != "") ? tabla : elemento;
    xmlPic = qryElementos.value("xmlpic");
    if (xmlPic && xmlPic != "") {
      xmlDocPic = new FLDomDocument;
      xmlDocPic.setContent(xmlPic);
    } else {
      xmlDocPic = false;
    }
    this.iface.aElementos_[elemento] = [];
    this.iface.aElementos_[elemento]["tabla"] = tabla;
    this.iface.aElementos_[elemento]["icono"] = pixIcono;
    this.iface.aElementos_[elemento]["xmlPic"] = xmlDocPic;
    this.iface.aElementos_[elemento]["descripcion"] = qryElementos.value("descripcion");
    if (!elemento) {
      this.iface.aIndiceElementos_[indice++] = elemento;
    }
  }
  return true;
}
*/
/*
function oficial_tbnEditaElementoUG_clicked()
{
  var aElemento = this.iface.aHistorialElementos_[this.iface.iElementoHistorial_];
  if (!aElemento) {
    return false;
  }
  if (this.iface.curObjeto_) {
    delete this.iface.curObjeto_;
  }
  this.iface.curObjeto_ = new FLSqlCursor("t1_elementosug");
  this.iface.curObjeto_.select("elemento = '" + aElemento["tipo"] + "' AND idusuario = '" + this.iface.idUsuario_ + "'");
  if (!this.iface.curObjeto_.first()) {
    this.iface.curObjeto_.setModeAccess(this.iface.curObjeto_.Insert);
    this.iface.curObjeto_.refreshBuffer();
    debug("tipo = " + aElemento["tipo"]);
    this.iface.curObjeto_.setValueBuffer("elemento", aElemento["tipo"]);
    this.iface.curObjeto_.setValueBuffer("idusuario", this.iface.idUsuario_);
    if (!this.iface.curObjeto_.commitBuffer()) {
      return false;
    }
    this.iface.curObjeto_.select("elemento = '" + aElemento["tipo"] + "' AND idusuario = '" + this.iface.idUsuario_ + "'");
    if (!this.iface.curObjeto_.first()) {
      return false;
    }
  }
//  connect(this.iface.curObjeto_, "bufferCommited()", this, "iface.recargaElementoActual");
  this.iface.curObjeto_.editRecord();
}
*/
/*
function oficial_tbnEditaElemento_clicked()
{
  var aElemento = this.iface.aHistorialElementos_[this.iface.iElementoHistorial_];
  if (!aElemento) {
    return false;
  }
  if (this.iface.curObjeto_) {
    delete this.iface.curObjeto_;
  }
  this.iface.curObjeto_ = new FLSqlCursor("t1_elementos");
  this.iface.curObjeto_.select("elemento = '" + aElemento["tipo"] + "'");
  if (!this.iface.curObjeto_.first()) {
    return false;
  }
  connect(this.iface.curObjeto_, "bufferCommited()", this, "iface.recargaElementoActual");
  this.iface.curObjeto_.editRecord();
}
*/
/*
function oficial_tbnEditaRelacionUG_clicked()
{
  var fila = this.iface.tblRelaciones_.currentRow();
  if (fila < 0) {
    return false;
  }
  if (!this.iface.aRelaciones_) {
    return false;
  }
  var idRel = this.iface.tblRelaciones_.text(fila, this.iface.CR_IDREL);
  if (isNaN(idRel) || idRel > this.iface.aRelaciones_.length) {
    return false;
  }

  var aRelacion = this.iface.aRelaciones_[idRel];
  if (this.iface.curObjeto_) {
    delete this.iface.curObjeto_;
  }
  this.iface.curObjeto_ = new FLSqlCursor("t1_relacioneselementoug");
  this.iface.curObjeto_.select("idrelacionelementoug = " + aRelacion["idug"]);
  if (!this.iface.curObjeto_.first()) {
    return false;
  }
  connect(this.iface.curObjeto_, "bufferCommited()", this, "iface.refrescaPicRelacion");
  this.iface.curObjeto_.editRecord();
}
*/
/*
function oficial_tbnEditaRelacion_clicked()
{
  if (!this.iface.aRelaciones_) {
    return false;
  }
  //  var idRel= this.iface.tblElementosRel_.text(this.iface.tblElementosRel_.currentRow(), this.iface.CER_IDREL);
  var fila = this.iface.tblRelaciones_.currentRow();
  if (fila < 0) {
    return false;
  }
  var idRel = this.iface.tblRelaciones_.text(fila, this.iface.CR_IDREL);
  if (isNaN(idRel) || idRel > this.iface.aRelaciones_.length) {
    return false;
  }

  var aRelacion = this.iface.aRelaciones_[idRel];
  if (this.iface.curObjeto_) {
    delete this.iface.curObjeto_;
  }
  this.iface.curObjeto_ = new FLSqlCursor("t1_relacioneselemento");
  this.iface.curObjeto_.select("idrelacionelemento = " + aRelacion["id"]);
  if (!this.iface.curObjeto_.first()) {
    return false;
  }
  //  connect(this.iface.curObjeto_, "bufferCommited()", this, "iface.refrescaPicElementoRel");
  connect(this.iface.curObjeto_, "bufferCommited()", this, "iface.refrescaPicRelacion");
  this.iface.curObjeto_.editRecord();
}

function oficial_refrescaPicRelacion()
{
  debug("oficial_refrescaPicRelacion");
  var iFila = this.iface.tblRelaciones_.currentRow();
  if (iFila < 0) {
    return false;
  }
  debug("oficial_refrescaPicRelacion 1");
  var nombre = this.iface.tblRelaciones_.text(iFila, this.iface.CR_TIPO);
  var iRel = this.iface.tblRelaciones_.text(iFila, this.iface.CR_IDREL);
  //  if (!this.iface.recargaPicRelacion(iRel)) {
  //    return false;
  //  }
  if (!this.iface.cargaRelaciones(iRel)) {
    return false;
  }
  debug("oficial_refrescaPicRelacion 2");
  var aElemento = this.iface.dameElementoActual()
                  var aDatosRel = this.iface.dameDatosRelacion(aElemento["tipo"], aElemento["clave"], iRel);
  if (!aDatosRel) {
    return false;
  }
  debug("oficial_refrescaPicRelacion 3");
  //  if (!this.iface.dibujaPixmapRel(this.iface.tblRelaciones_, iFila, this.iface.CR_DESC, aDatosRel["c"], iRel)) {
  //    return false;
  //  }
  var textoRel = this.iface.componTextoRel(this.iface.aRelaciones_[iRel]["textoRel"], aDatosRel);
  debug("oficial_refrescaPicRelacion" +  textoRel);
  this.iface.tblRelaciones_.setText(iFila, this.iface.CR_DESC, textoRel);

  if (!this.iface.muestraElementosRel(aElemento["tipo"], aElemento["clave"], iRel)) {
    return false;
  }
  return true;
}


function oficial_refrescaPicElementoRel()
{
  var iFila = this.iface.tblRelaciones_.currentRow();
  if (iFila < 0) {
    return false;
  }
  var nombre = this.iface.tblRelaciones_.text(iFila, this.iface.CR_TIPO);
  var iRel = this.iface.tblRelaciones_.text(iFila, this.iface.CR_IDREL);
  if (!this.iface.recargaPicElementoRel(iRel)) {
    return false;
  }

  if (!this.iface.refrescaRelacion(nombre)) {
    return false;
  }
  return true;
}
*/

/*
function oficial_recargaPicElementos()
{
  this.iface.cargaElementos();
  var aElemento = this.iface.aHistorialElementos_[this.iface.iElementoHistorial_];
  if (!aElemento) {
    return false;
  }
  this.iface.muestraElemento(aElemento["tipo"], aElemento["clave"]);
}

function oficial_recargaPicRelacion(iRel: Number)
{
  var util = new FLUtil;

  var idRelUG = this.iface.aRelaciones_[iRel]["idug"];
  var xmlPic = util.sqlSelect("t1_relacioneselementoug", "xmlpicrelacion", "idrelacionelementoug = " + idRelUG);
  var xmlDocPic: FLDomDocument;
  if (xmlPic && xmlPic != "") {
    xmlDocPic = new FLDomDocument;
    xmlDocPic.setContent(xmlPic);
  } else {
    xmlDocPic = false;
  }
  this.iface.aRelaciones_[iRel]["xmlPicRelacion"] = xmlDocPic;

  var orderCols = util.sqlSelect("t1_relacioneselementoug", "ordercols", "idrelacionelementoug = " + idRelUG);
  if (orderCols && orderCols != "") {
    this.iface.aRelaciones_[iRel]["orderCols"] = orderCols.split(",");
  }
  return true;
}

function oficial_recargaPicElementoRel(iRel: Number)
{
  var util = new FLUtil;

  var idRel = this.iface.aRelaciones_[iRel]["id"];
  var xmlPic = util.sqlSelect("t1_relacioneselemento", "xmlpicelemento", "idrelacionelemento = " + idRel);
  var xmlDocPic: FLDomDocument;
  if (xmlPic && xmlPic != "") {
    xmlDocPic = new FLDomDocument;
    xmlDocPic.setContent(xmlPic);
  } else {
    xmlDocPic = false;
  }
  this.iface.aRelaciones_[iRel]["xmlPicElemento"] = xmlDocPic;
  return true;
}
*/
function oficial_cargaUsuarioYGrupo()
{
  var util = new FLUtil;

  this.iface.idUsuario_ = sys.nameUser();
  this.iface.idGrupo_ = util.sqlSelect("flusers", "idgroup", "iduser = '" + this.iface.idUsuario_ + "'");

  debug("Usuario " + this.iface.idUsuario_);
  debug("Grupo " + this.iface.idGrupo_);

  return true;

}

function oficial_tbnRecargar_clicked()
{
  //  this.iface.cargaElementos();
  this.iface.actualizaDatosForm();
}
/*
function oficial_pbnMR_clicked()
{
  if (this.child("pbnMR").on) {
    sys.openMasterForm("t1_mr")
  }
}
*/
function oficial_tbnAddWidget_clicked()
{
  var _i = this.iface;
  var eA = _i.dameElementoActual();
  var accion = eA.tipo;

  var f = new FLFormSearchDB("t1_catalogodb");
  var cur = f.cursor();
  cur.setMainFilter("accion = '" + accion + "'");
  f.setMainWidget();
  var codCatalogo = f.exec("codcatalogodb");
  debug("codCatalogo " + codCatalogo);
  if (!codCatalogo) {
    return;
  }
  var sXml = AQUtil.sqlSelect("t1_catalogodb", "xmlbase", "codcatalogodb = '" + codCatalogo + "'");
  if (!sXml) {
    return;
  }
  var xml = new QDomDocument;
  if (!xml.setContent(sXml)) {
    return;
  }
  xml.firstChild().toElement().setAttribute("id", "");
  debug(xml.firstChild().toElement().attribute("id"));
  var idWidget = _i.saveAsDashboardWidget(accion, "sin uso", xml, codCatalogo);
  if (!idWidget) {
    return false;
  }
  _i.cargaWidgetsDB(accion, idWidget);
}

function oficial_tbnIncluirRel_clicked()
{
  var _i = this.iface;
  var eA = _i.dameElementoActual();

  var opcion = Input.getItem(sys.translate("Tipo del widget"), ["Tabla", "Métodos", "Fast Table", "Fast Fields", "Method Set", "2D Chart"]);
  switch (opcion) {
    case "Tabla": {
      _i.nuevoFastTable2();
      break;
    }
    case "Métodos": {
      _i.nuevoMethodSet2();
      break;
    }
    case "Fast Table": {
      _i.nuevoFastTable();
      break;
    }
    case "Fast Fields": {
      _i.nuevoFastFields();
      break;
    }
    case "Method Set": {
      _i.nuevoMethodSet();
      break;
    }
    case "2D Chart": {
      _i.nuevo2DChart();
      break;
    }
  }
}

function oficial_tbnGuardaAcciones_clicked()
{
  var _i = this.iface;

  if (!_i.xmlActions_) {
    return;
  }
  var s = _i.xmlActions_.toString(4);
  File.write("/home/arodriguez/t1_actions.xml", s);

  if (AQUtil.sqlSelect("t1_principal", "id", "1 = 1")) {
    if (!AQSql.update("t1_principal", ["xmlactions"], [s], "1 = 1")) {
      return false;
    }
  } else {
    if (!AQSql.insert("t1_principal", ["xmlactions"], [s])) {
      return false;
    }
  }

  MessageBox.information(sys.translate("Acciones guardadas"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton, "AbanQ");
}

function oficial_tbnGuardaBusqueda_clicked()
{
  var _i = this.iface;

  if (!_i.xmlSearch_) {
    return;
  }
  var s = _i.xmlSearch_.toString(4);
  File.write("/home/arodriguez/t1_search.xml", s);
  if (AQUtil.sqlSelect("t1_principal", "id", "1 = 1")) {
    if (!AQSql.update("t1_principal", ["xmlsearch"], [s], "1 = 1")) {
      return false;
    }
  } else {
    if (!AQSql.insert("t1_principal", ["xmlsearch"], [s])) {
      return false;
    }
  }
  MessageBox.information(sys.translate("Búsqueda guardada"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton, "AbanQ");
}

function oficial_tbnCargaAcciones_clicked()
{
  var _i = this.iface;

  //   var sA = File.read("/home/arodriguez/t1_actions.xml");

  _i.xmlActions_ = new FLDomDocument;
  _i.xmlActions_.setContent("<actions/>");
  if (!_i.cargaAcciones()) {
    return false;
  }
  var sA = _i.xmlActions_.toString(4);

  //  _i.xmlWidgets_ = new FLDomDocument;
  //  _i.xmlWidgets_.setContent("<widgets/>");
  //   if (!_i.cargaWidgets()) {
  //    return false;
  //  }

  if (AQUtil.sqlSelect("t1_principal", "id", "1 = 1")) {
    debug("Acciones: " + sA);
    if (!AQSql.update("t1_principal", ["xmlactions"], [sA], "1 = 1")) {
      return false;
    }
  } else {
    if (!AQSql.insert("t1_principal", ["xmlactions"], [sA])) {
      return false;
    }
  }
  _i.tbnRecargar_clicked();
  MessageBox.information(sys.translate("Acciones cargadas"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton, "AbanQ");
}

// function oficial_cargaWidgets()
// {
//  var _i = this.iface;
//  _i.widgets_ = undefined;
//  _i.widgets_ = new Object;
//
//  var ws = ["ftfacturascli"];
//  for (var i = 0; i < ws.length; i++) {
//    if (!_i.cargaWidget(ws[i])) {
//      sys.warnMsgBox(sys.translate("Error al cargar el widget %1").arg(ws[i]);
//      return false;
//    }
//  }
//  return true;
// }
//
// function oficial_cargaWidget(wN)
// {
//  var _i = this.iface;
//  switch (wN) {
//    case "ftfacturascli": {
//      var q = _i.cargaQueryFT(wN);
//      if (!q) {
//        return false;
//      }
//
//      break;
//    }
//  }
//  if (!_i.cargaWidget(ws[i])) {
//    sys.warnMsgBox(sys.translate("Error al cargar el widget %1").arg(ws[i]);
//    return false;
//  }
//  _i.widgets_ = undefined;
//  _i.widgets_ = new Object;
//
//  var ws = ["ftfacturascli"];
//  for (var i = 0; i < ws.length; i++) {
//    if (!_i.cargaWidget(ws[i])) {
//      sys.warnMsgBox(sys.translate("Error al cargar el widget %1").arg(ws[i]);
//      return false;
//    }
//  }
//  return true;
// }

function oficial_ponAccion(name, icon, title)
{
  var _i = this.iface;

  var xActions = _i.xmlActions_.firstChild();
  debug("nodexActions " + xActions.nodeName());
  var eAction = _i.dameElementoXML(_i.xmlActions_, "actions/action[@name=" + name + "]");
  debug("eAction " + eAction);// + " eAction.isNull() " + eAction.isNull());
  if (!eAction || eAction.isNull()) {
    eAction = _i.xmlActions_.createElement("action");
    debug("2eAction " + eAction);// + " eAction.isNull() " + eAction.isNull());
    xActions.appendChild(eAction);
  }
  // debug("2 eAction " + eAction + " eAction.isNull() " + eAction.isNull());
  eAction.setAttribute("name", name);
  eAction.setAttribute("icon", icon);
  eAction.setAttribute("title", title);
  return true;
}

function oficial_ponMetodo(action, name, fun, icon, alias, iconMethod)
{
  var _i = this.iface;

  debug(_i.xmlActions_.toString(8));

  var xActions = _i.xmlActions_.firstChild();
  var eAction = _i.dameElementoXML(xActions, "action[@name=" + action + "]");
  if (!eAction || eAction.isNull()) {
    sys.warnMsgBox(sys.translate("No se ha encontrado la acción %1 en el árbol de acciones").arg(action));
    return false;
  }
  var xMethods = eAction.namedItem("methods");
  var eMethods;
  if (!xMethods) {
    eMethods = _i.xmlActions_.createElement("methods");
    eAction.appendChild(eMethods);
  } else {
    eMethods = xMethods.toElement();
  }
  var eMethod = _i.dameElementoXML(eMethods, "method[@name=" + name + "]");
  if (!eMethod || eMethod.isNull()) {
    eMethod = _i.xmlActions_.createElement("method");
    eMethods.appendChild(eMethod);
  }
  eMethod.setAttribute("name", name);
  eMethod.setAttribute("icon", icon);
  eMethod.setAttribute("function", fun);
  eMethod.setAttribute("alias", alias);
  eMethod.setAttribute("iconmethod", iconMethod);
  return true;
}

function oficial_ponRelacion(action, relAction, join)
{
  var _i = this.iface;

  debug(_i.xmlActions_.toString(8));

  var xActions = _i.xmlActions_.firstChild();
  var eAction = _i.dameElementoXML(xActions, "action[@name=" + action + "]");
  if (!eAction || eAction.isNull()) {
    sys.warnMsgBox(sys.translate("No se ha encontrado la acción %1 en el árbol de acciones").arg(action));
    return false;
  }
  var xRels = eAction.namedItem("relations");
  var eRels;
  if (!xRels) {
    eRels = _i.xmlActions_.createElement("relations");
    eAction.appendChild(eRels);
  } else {
    eRels = xRels.toElement();
  }
  var eRel = _i.dameElementoXML(eRels, "relation[@to=" + relAction + "]");
  if (!eRel || eRel.isNull()) {
    eRel = _i.xmlActions_.createElement("relation");
    eRels.appendChild(eRel);
  }
  eRel.setAttribute("from", action);
  eRel.setAttribute("to", relAction);
  eRel.setAttribute("sqljoin", join);
  return true;
}

function oficial_cargaAcciones()
{
  var _i = this.iface;
  _i.ponAccion("facturascli", "facturascli.png", "codigo");
  _i.ponMetodo("facturascli", "editRecord", "formt1_principal.iface.editarCursor", "tools-report-bug", sys.translate("Editar"));
  _i.ponMetodo("facturascli", "printRecord", "formt1_principal.iface.imprimirDoc", "document-print.png", sys.translate("Imprimir"));
  _i.ponRelacion("facturascli", "co_partidas", "facturascli INNER JOIN co_partidas ON facturascli.idasiento = co_partidas.idasiento INNER JOIN co_subcuentas ON co_partidas.idsubcuenta = co_subcuentas.idsubcuenta");

  _i.ponAccion("crm_contactos", "view-pim-contacts.png", "nombre");
  _i.ponMetodo("crm_contactos", "editRecord", "formt1_principal.iface.editarCursor", "document-edit.png", sys.translate("Editar"));

  _i.ponAccion("presupuestoscli", "presupuestoscli.png", "codigo");
  _i.ponMetodo("presupuestoscli", "editRecord", "formt1_principal.iface.editarCursor", "document-edit.png", sys.translate("Editar"));
  _i.ponMetodo("presupuestoscli", "approve", "formpresupuestoscli.iface.pub_metGenerarPedido", "dialog-ok.png", sys.translate("Aprobar"));

  _i.ponAccion("reciboscli", "reciboscli.png", "codigo");
  _i.ponMetodo("reciboscli", "editRecord", "formt1_principal.iface.editarCursor", "document-edit.png", sys.translate("Editar"));

  _i.ponAccion("clientes", "clientes", "nombre");
  _i.ponMetodo("clientes", "editRecord", "formt1_principal.iface.editarCursor", "document-edit.png", sys.translate("Editar"));
  _i.ponMetodo("clientes", "sendEmail", "formt1_principal.iface.clientes_enviarEmail", "mail-send.png", sys.translate("Enviar email"));

  _i.ponAccion("usuarios", "user-identity.png", "nombre");
  _i.ponMetodo("usuarios", "crearCliente", "formt1_principal.iface.mtdNuevoCliente", "clientes", sys.translate("Editar"), "text-x-adasrc");
  _i.ponMetodo("usuarios", "asignarHoras", "flservppal.iface.pub_mtdAsignaHoras", "clock.png", sys.translate("Asignar horas"));
  _i.ponRelacion("usuarios", "facturascli", "NO");

  _i.ponAccion("se_proyectos", "quickopen-function.png", "descripcion");
  _i.ponMetodo("se_proyectos", "editRecord", "formt1_principal.iface.editarCursor", "document-edit.png", sys.translate("Editar"));
  _i.ponMetodo("se_proyectos", "bajarFun", "formmv_funcional.iface.pub_mtdBajarFun", "svn-update.png", sys.translate("Bajar funcionalidad"));

  _i.ponAccion("se_subproyectos", "quickopen-class.png", "descripcion");
  _i.ponMetodo("se_subproyectos", "editRecord", "formt1_principal.iface.editarCursor", "document-edit.png", sys.translate("Editar"));
  _i.ponMetodo("se_subproyectos", "bajarFun", "formmv_funcional.iface.pub_mtdBajarFun", "svn-update.png", sys.translate("Bajar funcionalidad"));
  _i.ponMetodo("se_subproyectos", "subirFun", "formmv_funcional.iface.pub_mtdSubirFun", "svn-commit.png", sys.translate("Subir funcionalidad"));
  _i.ponMetodo("se_subproyectos", "recargarFun", "formmv_funcional.iface.pub_mtdRecargarFun", "view-refresh.png", sys.translate("Recargar funcionalidad"));
  _i.ponMetodo("se_subproyectos", "pruebasFun", "formmv_funcional.iface.pub_mtdProbarFun", "tools-report-bug.png", sys.translate("Crear Pruebas"));
  _i.ponMetodo("se_subproyectos", "importarMail", "flservppal.iface.pub_mtdImportarMail", "mail-receive.png", sys.translate("Importar mail"));
  _i.ponMetodo("se_subproyectos", "enviarMail", "flservppal.iface.pub_mtdEnviarMail", "mail-send.png", sys.translate("Enviar mail"));
  _i.ponMetodo("se_subproyectos", "enviarSW", "flservppal.iface.pub_mtdEnviarSW", "system-run.png", sys.translate("Enviar SW"));
  _i.ponMetodo("se_subproyectos", "crearIncidencia", "flservppal.iface.pub_mtdCrearIncidencia", "dialog-warning.png", sys.translate("Nueva incidencia"), "add.png");

  _i.ponAccion("se_incidencias", "se_incidencias.png", "desccorta");
  _i.ponMetodo("se_incidencias", "editRecord", "formt1_principal.iface.editarCursor", "document-edit.png", sys.translate("Editar"));
  _i.ponMetodo("se_incidencias", "importarMail", "flservppal.iface.pub_mtdImportarMail", "mail-receive.png", sys.translate("Importar mail"));

  _i.ponAccion("se_comunicaciones", "mail-message.png", "asunto");
  _i.ponMetodo("se_comunicaciones", "editRecord", "formt1_principal.iface.editarCursor", "document-edit.png", sys.translate("Editar"));

  _i.ponAccion("pr_tareas", "system-run.png", "descripcion");
  _i.ponMetodo("se_comunicaciones", "editRecord", "formt1_principal.iface.editarCursor", "document-edit.png", sys.translate("Editar"));

  _i.ponAccion("se_horastrabajadas", "clock.png", "descripcion");
  _i.ponMetodo("se_comunicaciones", "editRecord", "formt1_principal.iface.editarCursor", "document-edit.png", sys.translate("Editar"));

  _i.ponAccion("mv_funcional", "preferences-plugin.png", "desccorta");
  _i.ponMetodo("mv_funcional", "bajarFun", "formmv_funcional.iface.pub_mtdBajarFun", "svn-update.png", sys.translate("Bajar funcionalidad"));
  _i.ponMetodo("mv_funcional", "subirFun", "formmv_funcional.iface.pub_mtdSubirFun", "svn-commit.png", sys.translate("Subir funcionalidad"));
  _i.ponMetodo("mv_funcional", "recargarFun", "formmv_funcional.iface.pub_mtdRecargarFun", "view-refresh.png", sys.translate("Recargar funcionalidad"));
  _i.ponMetodo("mv_funcional", "pruebasFun", "formmv_funcional.iface.pub_mtdProbarFun", "tools-report-bug.png", sys.translate("Crear pruebas"));
  _i.ponMetodo("mv_funcional", "editRecord", "formt1_principal.iface.editarCursor", "document-edit.png", sys.translate("Editar"));
  _i.ponMetodo("mv_funcional", "bajarPro", "formmv_funcional.iface.pub_mtdBajarPro", "system-log-out.png", sys.translate("Bajar proyecto"));
  _i.ponMetodo("mv_funcional", "exportarPro", "formmv_funcional.iface.pub_mtdExportarPro", "utilities-file-archiver.png", sys.translate("Exportar proyecto"));
}

function oficial_tbnCargaBusqueda_clicked()
{
  var _i = this.iface;

  var sA = File.read("/home/arodriguez/t1_search.xml");

  if (!_i.xmlSearch_) {
    _i.xmlSearch_ = QDomDocument;
  }
  if (!_i.xmlSearch_.setContent(sA)) {
    return;
  }
  if (AQUtil.sqlSelect("t1_principal", "id", "1 = 1")) {
    if (!AQSql.update("t1_principal", ["xmlsearch"], [sA], "1 = 1")) {
      return false;
    }
  } else {
    if (!AQSql.insert("t1_principal", ["xmlsearch"], [sA])) {
      return false;
    }
  }

  MessageBox.information(sys.translate("Búsqueda cargada"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton, "AbanQ");
}

function oficial_tbnGuardaCatalogoDB_clicked()
{
  var _i = this.iface;
  var qCat = new FLSqlQuery;
  qCat.setSelect("codcatalogodb, accion, tipowidget, xmlbase");
  qCat.setFrom("t1_catalogodb");
  qCat.setWhere("");
  qCat.setForwardOnly(true);
  if (!qCat.exec()) {
    return false;
  }
  var xml = new FLDomDocument;
  var xmlAux = new FLDomDocument;
  xml.setContent("<ABNCatalogue/>");
  var eCI;
  var eRaiz = xml.firstChild().toElement();
  while (qCat.next()) {
    eCI = xml.createElement("ABNCatalogueItem");
    eCI.setAttribute("codcatalogodb", qCat.value("codcatalogodb"));
    eCI.setAttribute("accion", qCat.value("accion"));
    eCI.setAttribute("tipowidget", qCat.value("tipowidget"));
    if (!xmlAux.setContent(qCat.value("xmlbase"))) {
      return false;
    }
    eCI.appendChild(xmlAux.firstChild().cloneNode(true));
    eRaiz.appendChild(eCI);
  }
  debug(xml.toString(4));
  File.write("/home/arodriguez/t1_catalogodb.xml", xml.toString(4));
  MessageBox.information(sys.translate("Catálogo guardado"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton, "AbanQ");
}

function oficial_tbnCargaCatalogoDB_clicked()
{
  var _i = this.iface;
  var sC = File.read("/home/arodriguez/t1_catalogodb.xml");

  var xml = new FLDomDocument;
  if (!xml.setContent(sC)) {
    return;
  }
  var curCat = new FLSqlCursor("t1_catalogodb");
  var eRaiz = xml.firstChild().toElement();
  var xmlCIs = eRaiz.childNodes();
  var totalCI = xmlCIs.count();
  var eCI;
  var xmlAux;
  AQUtil.createProgressDialog(sys.translate("Cargando catálogo"), totalCI);
  for (var i = 0; i < totalCI; i++) {
    eCI = xmlCIs.item(i).toElement();
    AQUtil.setProgress(i);
    curCat.select("codcatalogodb = '" + eCI.attribute("codcatalogodb") + "'");
    if (curCat.first()) {
      curCat.setModeAccess(curCat.Edit);
      curCat.refreshBuffer();
    } else {
      curCat.setModeAccess(curCat.Insert);
      curCat.refreshBuffer();
      curCat.setValueBuffer("codcatalogodb", eCI.attribute("codcatalogodb"));
    }
    curCat.setValueBuffer("accion", eCI.attribute("accion"));
    curCat.setValueBuffer("tipowidget", eCI.attribute("tipowidget"));
    curCat.setValueBuffer("tipowidget", eCI.attribute("tipowidget"));
    xmlAux = new FLDomDocument;
    xmlAux.appendChild(eCI.firstChild().cloneNode(true));
    curCat.setValueBuffer("xmlbase", xmlAux.toString(4));
    if (!curCat.commitBuffer()) {
      AQUtil.destroyProgressDialog();
      return false;
    }
  }
  AQUtil.destroyProgressDialog();
  _i.tbnRecargar_clicked();
  MessageBox.information(sys.translate("Catálogo cargado"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton, "AbanQ");
}

function oficial_nuevoMethodSet()
{
  var _i = this.iface;
  var eA = _i.dameElementoActual();
  var tabla = eA.tipo;

  var mtdTabla = _i.mgr_.metadata(tabla);

  var cur = new FLSqlCursor(tabla);
  cur.select(mtdTabla.primaryKey() + " = '" + eA.clave + "'");
  if (!cur.first()) {
    return false;
  }

  var xmlFF = new FLDomDocument();
  xmlFF.setContent("<ABNMethodSet><method name='' /></ABNMethodSet>");
  xFF = xmlFF.firstChild();
  eFF = xFF.toElement();
  eFF.setAttribute("action", tabla);
  eFF.setAttribute("title", "AbanQ");

  var d = new Dialog;
  var tE = new TextEdit;
  tE.text = xmlFF.toString(4);
  d.add(tE);
  if (!d.exec()) {
    return;
  }
  var sXML = tE.text;

  var aqXmlFF = new QDomDocument;
  if (!aqXmlFF.setContent(sXML)) {
    MessageBox.warning(sys.translate("El XML contiene errores"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton, "AbanQ");
    return;
  }
  debug(sXML);
  /*
  if (!_i.saveAsDashboardWidget(eA.tipo, "sin uso", aqXmlFF)) {
    return false;
  }
  */
  var id = aqXmlFF.firstChild().toElement().attribute("id");
  var widgetName = "MS" + id.toString();
  _i.w_ = new ABNMethodSet(this.mainWidget(), widgetName, aqXmlFF.firstChild(), cur);
  _i.cargaWidgetDashboard(_i.w_, widgetName)

  return;
}

function oficial_nuevo2DChart()
{
  var _i = this.iface;
  var eA = _i.dameElementoActual();
  var tabla = eA.tipo;

  var mtdTabla = _i.mgr_.metadata(tabla);

  var cur = new FLSqlCursor(tabla);
  cur.select(mtdTabla.primaryKey() + " = '" + eA.clave + "'");
  if (!cur.first()) {
    return false;
  }

  var xmlFF = new FLDomDocument();
  xmlFF.setContent("<ABN2DChart><method name='' /></ABN2DChart>");
  xFF = xmlFF.firstChild();
  eFF = xFF.toElement();
  eFF.setAttribute("action", tabla);
  eFF.setAttribute("title", "AbanQ");

  var d = new Dialog;
  var tE = new TextEdit;
  tE.text = xmlFF.toString(4);
  d.add(tE);
  if (!d.exec()) {
    return;
  }
  var sXML = tE.text;

  var aqXmlFF = new QDomDocument;
  if (!aqXmlFF.setContent(sXML)) {
    MessageBox.warning(sys.translate("El XML contiene errores"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton, "AbanQ");
    return;
  }
  debug(sXML);
  /*
  if (!_i.saveAsDashboardWidget(eA.tipo, "sin uso", aqXmlFF)) {
    return false;
  }
  */
  var id = aqXmlFF.firstChild().toElement().attribute("id");
  var widgetName = "2C" + id.toString();
  _i.w_ = new ABN2DChart(this.mainWidget(), widgetName, aqXmlFF.firstChild(), cur);
  _i.cargaWidgetDashboard(_i.w_, widgetName)

  return;
}

function oficial_nuevoFastFields()
{
  var _i = this.iface;
  var eA = _i.dameElementoActual();
  var tabla = eA.tipo;

  var mtdTabla = _i.mgr_.metadata(tabla);

  var cur = new FLSqlCursor(tabla);
  cur.select(mtdTabla.primaryKey() + " = '" + eA.clave + "'");
  if (!cur.first()) {
    return false;
  }

  var xmlFF = new FLDomDocument();
  xmlFF.setContent("<ABNFastFields/>");
  xFF = xmlFF.firstChild();
  eFF = xFF.toElement();
  eFF.setAttribute("action", tabla);
  eFF.setAttribute("title", "AbanQ");

  var eRows = xmlFF.createElement("rows");
  eFF.appendChild(eRows);

  var eRow = xmlFF.createElement("row");
  eRow.setAttribute("type", "field");
  eRow.setAttribute("field", "");
  eRow.setAttribute("fieldlabel", "");
  eRow.setAttribute("label", "");
  eRow.setAttribute("method", "moveDashboard");
  eRows.appendChild(eRow);

  var d = new Dialog;
  var tE = new TextEdit;
  tE.text = xmlFF.toString(4);
  d.add(tE);
  if (!d.exec()) {
    return;
  }
  var sXML = tE.text;

  var aqXmlFF = new QDomDocument;
  if (!aqXmlFF.setContent(sXML)) {
    MessageBox.warning(sys.translate("El XML contiene errores"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton, "AbanQ");
    return;
  }
  debug(sXML);
  var id = aqXmlFF.firstChild().toElement().attribute("id");
  var widgetName = "FF" + id.toString();
  _i.w_ = new ABNFastFields(this.mainWidget(), widgetName, aqXmlFF.firstChild(), cur);
  _i.cargaWidgetDashboard(_i.w_, widgetName)

  return;
}

function oficial_nuevoFastTable()
{
  var _i = this.iface;
  var eA = _i.dameElementoActual();
  var tabla = eA.tipo;

  var sXmlFT = "<ABNFastTable title='Título tabla' Width='300' X='0' Y='0' Height='150' action='" + tabla + "' actionRelated='XXX' >" +
               "<qry fromClause='facturascli' orderByClause='idfactura' whereClause='facturascli.codcliente = **PK**' selectClause='facturascli.idfactura, facturascli.codigo, facturascli.fecha, facturascli.total' />" +
               "<cols>" +
               "<col num='0' fieldname='facturascli.idfactura' hidden='true' type='field' label='temp' />" +
               "<col num='1' fieldname='facturascli.codigo' hidden='false' type='field' label='Código' />" +
               "<col num='2' methodname='facturascli.editRecord' hidden='false' type='method' label='Edit' />" +
               "</cols>" +
               "</ABNFastTable>";

  var xmlFT = new FLDomDocument();
  if (!xmlFT.setContent(sXmlFT)) {
    return false;
  }
  var d = new Dialog;
  var tE = new TextEdit;
  tE.text = xmlFT.toString(4);
  d.add(tE);
  if (!d.exec()) {
    return;
  }
  var sXML = tE.text;

  var aqXmlFT = new QDomDocument;
  if (!aqXmlFT.setContent(sXML)) {
    MessageBox.warning(sys.translate("El XML contiene errores"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton, "AbanQ");
    return;
  }
  debug(sXML);
  var mtdTabla = _i.mgr_.metadata(tabla);

  var cur = new FLSqlCursor(tabla);
  cur.select(mtdTabla.primaryKey() + " = '" + eA.clave + "'");
  if (!cur.first()) {
    return false;
  }
  var id = aqXmlFT.firstChild().toElement().attribute("id");
  var widgetName = "FT" + id.toString();
  _i.w_ = new ABNFastTable(this.mainWidget(), widgetName, aqXmlFT.firstChild(), cur);
  _i.cargaWidgetDashboard(_i.w_, widgetName);

  return;
}

function oficial_nuevoFastTable2()
{
  var _i = this.iface;
  var eA = _i.dameElementoActual();
  var tabla = eA.tipo;

  eRels = _i.dameElementoXML(_i.xmlActions_.firstChild(), "action[@name=" + tabla + "]/relations");
  if (!eRels || eRels.isNull()) {
    sys.warnMsgBox(sys.translate("La acción %1 no tiene relaciones asociadas").arg(tabla));
    return false;
  }
  var aRels = [];
  for (var xRel = eRels.firstChild(); xRel && !xRel.isNull(); xRel = xRel.nextSibling()) {
    aRels.push(xRel.toElement().attribute("to"));
  }
  if (aRels.length == 0) {
    sys.warnMsgBox(sys.translate("La acción %1 no tiene relaciones asociadas").arg(tabla));
    return false;
  }
  var relAction = Input.getItem(sys.translate("Acción relacionada"), aRels);
  if (!relAction) {
    return false;
  }
  var curWU = new FLSqlCursor("t1_widgetsusuario");
  curWU.setModeAccess(curWU.Insert);
  curWU.refreshBuffer();
  curWU.setValueBuffer("nombre", tabla + "_" + relAction);
  curWU.setValueBuffer("accion", tabla);
  curWU.setValueBuffer("accionrel", relAction);
  curWU.setValueBuffer("tipo", "ABNFastTable");
  curWU.setValueBuffer("usuario", sys.nameUser());
  if (!curWU.commitBuffer()) {
    sys.errorMsgBox(sys.translate("Error al crear el control"));
    return false;
  }
  var idWidget = curWU.valueBuffer("idwidget");
  _i.cargaWidgetsDB2(tabla, idWidget);
}

function oficial_nuevoMethodSet2()
{
  var _i = this.iface;
  var eA = _i.dameElementoActual();
  var tabla = eA.tipo;
  /*
  eMets = _i.dameElementoXML(_i.xmlActions_.firstChild(), "action[@name=" + tabla + "]/methods");
  if (!eMets || eMets.isNull()) {
    sys.warnMsgBox(sys.translate("La acción %1 no tiene métodos asociados").arg(tabla));
    return false;
  }
  var aMets = [];
  for (var xMet = eMets.firstChild(); xMet && !xMet.isNull(); xMet = xMet.nextSibling()) {
    aMets.push(xMet.toElement());
  }
  if (aMets.length == 0) {
    sys.warnMsgBox(sys.translate("La acción %1 no tiene métodos asociados").arg(tabla));
    return false;
  }
  var d = new Dialog;
  var aChk = new Array[aMets.length];
  for (var i = 0; i < aMets.length; i++) {
    aChk[i] = new CheckBox;
    aChk[i].text = aMets[i].attribute("alias");
    d.add(aChk[i]);
  }
  if (!d.exec()) {
    return;
  }
  for (var i = 0; i < aMets.length; i++) {

  }
  */

  var curWU = new FLSqlCursor("t1_widgetsusuario");
  curWU.setModeAccess(curWU.Insert);
  curWU.refreshBuffer();
  curWU.setValueBuffer("nombre", tabla);
  curWU.setValueBuffer("accion", tabla);
  //curWU.setValueBuffer("accionrel", relAction);
  curWU.setValueBuffer("tipo", "ABNMethodSet");
  curWU.setValueBuffer("usuario", sys.nameUser());
  if (!curWU.commitBuffer()) {
    sys.errorMsgBox(sys.translate("Error al crear el control"));
    return false;
  }
  var idWidget = curWU.valueBuffer("idwidget");
  _i.cargaWidgetsDB2(tabla, idWidget);
}

function oficial_saveAsDashboardWidget(accion, nombre, xmlElemento, codCatalogo)
{
  var idUsuario = sys.nameUser();
  var idDB = AQUtil.sqlSelect("t1_dashboardusuario", "iddashboardusr", "accion = '" + accion + "' AND idusuario = '" + idUsuario + "'");
  if (!idDB) {
    if (!AQSql.insert("t1_dashboardusuario", ["idusuario", "accion"], [idUsuario, accion])) {
      return false;
    }
    idDB = AQUtil.sqlSelect("t1_dashboardusuario", "iddashboardusr", "accion = '" + accion + "' AND idusuario = '" + idUsuario + "'");
    if (!idDB) {
      return false;
    }
  }
  var eElemento = xmlElemento.firstChild().toElement();
  var idElemento = eElemento.attribute("id");
  var curElementoDB = new FLSqlCursor("t1_elementosdb");
  if (idElemento) {
    curElementoDB.select("idelementodb = " + idElemento);
    if (!curElementoDB.first()) {
      MessageBox.warning(sys.translate("Fallo 1 al guardar el elemento actual"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton, "AbanQ");
      return;
    }
    curElementoDB.setModeAccess(curElementoDB.Edit);
    curElementoDB.refreshBuffer();
  } else {
    curElementoDB.setModeAccess(curElementoDB.Insert);
    curElementoDB.refreshBuffer();
    curElementoDB.setValueBuffer("iddashboardusr", idDB);
    curElementoDB.setValueBuffer("nombre", "pepe");
    curElementoDB.setValueBuffer("codcatalogodb", codCatalogo);
    idElemento = curElementoDB.valueBuffer("idelementodb");
    eElemento.setAttribute("id", idElemento);
  }
  curElementoDB.setValueBuffer("xmlElemento", xmlElemento.toString(2));
  if (!curElementoDB.commitBuffer()) {
    MessageBox.warning(sys.translate("Fallo 2 al guardar el elemento actual"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton, "AbanQ");
    return false;
  }
  return idElemento;
}

function oficial_selCamposTablas(arrayTablas)
{
  var util = new FLUtil();

  var arrayCampos: Array;
  var arrayCamposSel = [];
  if (!arrayTablas)
    return false;

  var dialogo: Dialog = new Dialog;
  dialogo.caption = util.translate("scripts", "Seleccione campos");
  dialogo.okButtonText = util.translate("scripts", "Aceptar");
  dialogo.cancelButtonText = util.translate("scripts", "Cancelar");

  var gbxDialogo = new GroupBox;
  dialogo.add(gbxDialogo);
  var arrayRB = [];
  var arrayNombresCampos = [];
  var arrayTiposCampos = [];
  var indice = 0;
  var indiceColumna = 0;
  var tipo: Number;
  for (var i = 0; i < arrayTablas.length; i++) {
    arrayCampos = util.nombreCampos(arrayTablas[i]);
    for (var k = 1; k <= arrayCampos[0]; k++) {
      tipo = util.fieldType(arrayCampos[k], arrayTablas[i]);
      if (tipo == 100)
        continue;
      arrayRB[indice] = new CheckBox;
      arrayRB[indice].text = util.fieldNameToAlias(arrayCampos[k], arrayTablas[i]);
      gbxDialogo.add(arrayRB[indice]);
      arrayNombresCampos[indice] = arrayTablas[i] + "." + arrayCampos[k];
      arrayTiposCampos[indice] = tipo;
      indice++;
      if (++indiceColumna > 15) {
        gbxDialogo.newColumn();
        indiceColumna = 0;
      }
    }
  }
  if (!dialogo.exec())
    return false;

  var aSel = [];
  for (var i = 0; i < arrayRB.length; i++) {
    if (arrayRB[i].checked) {
      aSel.push(arrayNombresCampos[i]);
    }
  }
  return aSel;
}

function oficial_editarCursor(curId, tabla)
{
  var _i = this.iface;
  var curObjeto = _i.dameCursorObjeto(curId, tabla);
  if (!curObjeto) {
    return false;
  }
  curObjeto.editRecord();
}

function oficial_clientes_enviarEmail(curId, tabla)
{
  var _i = this.iface;
  var curObjeto = _i.dameCursorObjeto(curId, tabla);

  var eMail = curObjeto.valueBuffer("email");
  if (!eMail) {
    sys.warnMsgBox(sys.translate("No hay email asociado al cliente"));
    return false;
  }
  var url = _i.dameMailTo("", "", [eMail])
            sys.openUrl(url);
}

function oficial_dameMailTo(cuerpo, asunto, arrayDest, arrayAttach)
{
  var url = "mailto:";
  var dest = "";
  if (arrayDest) {
    for (var i = 0; i < arrayDest.length; i++) {
      dest += dest != "" ? ";" : "";
      dest += arrayDest[i];
    }
  }
  url += dest;
  url += "?subject=" + asunto;
  url += "&body=" + cuerpo;
  if (arrayAttach) {
    for (var i = 0; i < arrayAttach.length; i++) {
      url += "&attachment=" + arrayAttach[i];
    }
  }
  return url;
}

function oficial_dameCursorObjeto(curId, tabla)
{
  var _i = this.iface;
  var curObjeto;
  if (typeof(curId) == "string" || typeof(curId) == "number") {
    curObjeto = new FLSqlCursor(tabla);
    var campoClave = curObjeto.primaryKey();
    var tipoClave = curObjeto.fieldType(campoClave);
    switch (tipoClave) {
      case _i.ftSTRING_:
      case _i.ftDATE_: {
        curObjeto.select(campoClave + " = '" + curId + "'");
        break;
      }
      default: {
        curObjeto.select(campoClave + " = " + curId);
      }
    }
    if (!curObjeto.first()) {
      return false;
    }
  } else {
    curObjeto = curId;
  }
  return curObjeto;
}

function oficial_imprimirDoc(curId)
{
  var _i = this.iface;
  var codFactura;
  if (typeof(curId) == "string" || typeof(curId) == "number") {
    codFactura = AQUtil.sqlSelect("facturascli", "codigo", "idfactura = " + curId);
  } else {
    codFactura = curId.valueBuffer("codigo");
  }
  formfacturascli.iface.pub_imprimir(codFactura);
}

function oficial_creaXMLActions()
{
  var _i = this.iface;
  _i.tbnCargaAcciones_clicked();
  return;
  var s = AQUtil.sqlSelect("t1_principal", "xmlactions", "1 = 1");
  if (!s) {
    s = "<actions>" +
        "<action name='facturascli' title='codigo' icon='facturascli.png'>" +
        "<methods>" +
        "<method name='facturascli.editRecord' alias='Editar' function='formt1_principal.iface.editarCursor' icon='document-edit.png' />" +
        "<method name='facturascli.printRecord' alias='Imprimir' function='formt1_principal.iface.imprimirDoc' icon='document-print.png' />" +
        "</methods>" +
        "</action>" +
        "<action name='presupuestoscli' title='codigo' icon='presupuestoscli.png'>" +
        "<methods>" +
        "<method name='presupuestoscli.editRecord' alias='Editar' function='formt1_principal.iface.editarCursor' icon='16x16/edit.png' />" +
        "<method name='presupuestoscli.approve' alias='Aprobar' function='formpresupuestoscli.iface.pub_metGenerarPedido' icon='16x16/dialog-ok.png' />" +
        "</methods>" +
        "</action>" +
        "<action name='reciboscli' title='codigo' icon='reciboscli.png'>" +
        "<methods>" +
        "<method name='reciboscli.editRecord' alias='Editar' function='formt1_principal.iface.editarCursor' icon='16x16/edit.png' />" +
        "</methods>" +
        "</action>" +
        "<action name='clientes' title='nombre' icon='clientes'>" +
        "<methods>" +
        "<method name='clientes.editRecord' alias='Editar' function='formt1_principal.iface.editarCursor' icon='16x16/edit.png' />" +
        "</methods>" +
        "</action>" +
        "<action name='usuarios' title='nombre' icon='clientes'>" +
        "<methods>" +
        "<method name='usuarios.crearCliente' alias='Nuevo cliente' function='formt1_principal.iface.mtdNuevoCliente' icon='clientes' iconmethod='add.png'/>" +
        "<method name='usuarios.crearFactura' alias='Nueva factura' function='formt1_principal.iface.mtdNuevaFactura' icon='facturascli.png' />" +
        "</methods>" +
        "</action>" +
        "</actions>";
  }
  _i.xmlActions_ = new QDomDocument();
  if (!_i.xmlActions_.setContent(s)) {
    debug("xml no válido");
    return;
  }
  debug(_i.xmlActions_.toString(4));
}
function oficial_creaXMLSearch()
{
  var _i = this.iface;
  var s = AQUtil.sqlSelect("t1_principal", "xmlsearch", "1 = 1");
  if (!s) {
    s = "<ABNSearch>" +
        "<action name='clientes' active='true'>" +
        "<searchfields>" +
        "<searchfield name='nombre' active='true'/>" +
        "</searchfields>" +
        "<showfields>" +
        "<showfield name='codcliente' active='true'/>" +
        "<showfield name='nombre' active='true'/>" +
        "</showfields>" +
        "</action>" +
        "<action name='proveedores' active='true'>" +
        "<searchfields>" +
        "<searchfield name='nombre' active='true'/>" +
        "</searchfields>" +
        "<showfields>" +
        "<showfield name='nombre' active='true'/>" +
        "</showfields>" +
        "</action>" +
        "<action name='articulos' active='true'>" +
        "<searchfields>" +
        "<searchfield name='referencia' active='true'/>" +
        "<searchfield name='descripcion' active='true'/>" +
        "</searchfields>" +
        "<showfields>" +
        "<showfield name='referencia' active='true'/>" +
        "<showfield name='descripcion' active='true'/>" +
        "</showfields>" +
        "</action>" +
        "</ABNSearch>";
  }
  _i.xmlSearch_ = new QDomDocument();
  if (!_i.xmlSearch_.setContent(s)) {
    debug("xml no válido");
    return;
  }
  debug(_i.xmlSearch_.toString(4));
}

function oficial_selMetodosTablas(arrayTablas)
{
  var util = new FLUtil();
  var _i = this.iface;

  var xActions = _i.xmlActions_.firstChild();
  /// Usar XPAth cuando esté disponible
  var xLActions = xActions.toElement().childNodes();
  var numActions = xLActions.count();
  var i, xLMethods;
  var aMethods = [], aM;
  for (var t = 0; t < arrayTablas.length; t++) {
    for (i = 0; i < numActions; i++) {
      if (xLActions.item(i).toElement().attribute("name") == arrayTablas[t]) {
        break;
      }
    }
    if (i == numActions) continue;
    xLMethods = xLActions.item(i).namedItem("methods").childNodes();
    var numMethods = xLMethods.count();
    for (i = 0; i < numMethods; i++) {
      aMethods.push(xLMethods.item(i).toElement().attribute("name"));
    }
  }
  var dialogo = new Dialog;
  dialogo.caption = util.translate("scripts", "Seleccione métodos");
  dialogo.okButtonText = util.translate("scripts", "Aceptar");
  dialogo.cancelButtonText = util.translate("scripts", "Cancelar");

  var gbxDialogo = new GroupBox;
  dialogo.add(gbxDialogo);
  var arrayRB = [];
  var indice = 0;
  for (var k = 0; k < aMethods.length; k++) {
    arrayRB[indice] = new CheckBox;
    arrayRB[indice].text = aMethods[k];
    gbxDialogo.add(arrayRB[indice]);
    indice++;
    if (++indiceColumna > 15) {
      gbxDialogo.newColumn();
      indiceColumna = 0;
    }
  }

  if (!dialogo.exec())
    return false;

  var aSel = [];
  for (var i = 0; i < arrayRB.length; i++) {
    if (arrayRB[i].checked) {
      aSel.push(aMethods[i]);
    }
  }

  return aSel;
}

function oficial_dameElementoXML(nodoPadre, ruta, debeExistir)
{
  var xmlNodo = formt1_principal.iface.dameNodoXML(nodoPadre, ruta, debeExistir);
  if (!xmlNodo) {
    debug("false");
    return false;
  }
  if (xmlNodo.isNull()) {
    debug("isNull");
    return xmlNodo;
  }
  debug("toElement");
  return xmlNodo.toElement();
}

/** \C Busca un nodo en un nodo y sus nodos hijos
@param  nodoPadre: Nodo que contiene el nodo a buscar (o los nodos hijos que lo contienen)
@param  ruta: Cadena que especifica la ruta a seguir para encontrar el atributo. Su formato es NodoPadre/NodoHijo/NodoNieto/.../Nodo. Puede ser tan larga como sea necesario. Siempre se toma el primer nodo Hijo que tiene el nombre indicado.
@param  debeExistir: Si vale true la funci?®n devuelve false si no encuentra el atributo
@return Nodo buscado o false si hay error o no se encuentra el nodo
\end */
function oficial_dameNodoXML(nodoPadre, ruta, debeExistir)
{
  var util = new FLUtil;

  var valor: String;
  var nombreNodo = ruta.split("/");
  var nodoXML = nodoPadre;
  var i: Number;
  var nombreActual: String;
  var iInicioCorchete: Number
  for (i = 0; i < nombreNodo.length; i++) {
    nombreActual = nombreNodo[i];
    debug("nombreActual  = " + nombreActual);
    iInicioCorchete = nombreActual.find("[");
    if (iInicioCorchete > -1) {
      debug("hay corchete");
      iFinCorchete = nombreActual.find("]");
      var condicion = nombreActual.substring(iInicioCorchete + 1, iFinCorchete);
      var paramCond = condicion.split("=");
      if (!paramCond[0].startsWith("@")) {
        MessageBox.warning(util.translate("scripts", "Error al procesar la ruta XML %1 en %2").arg(ruta).arg(nombreActual), MessageBox.Ok, MessageBox.NoButton);
        return false;
      }
      nombreActual = nombreActual.left(iInicioCorchete);
      var atributo = paramCond[0].right(paramCond[0].length - 1);
      var nodoHijo: FLDomNode;
      for (nodoHijo = nodoXML.firstChild(); (nodoHijo && !nodoHijo.isNull()); nodoHijo = nodoHijo.nextSibling()) {
        debug("buscando en " + nodoXML.nodeName());
        if (nodoHijo.nodeName() == nombreActual && nodoHijo.toElement().attribute(atributo) == paramCond[1]) {
          break;
        }
      }
      if (nodoHijo) {
        nodoXML = nodoHijo;
      } else {
        if (debeExistir) {
          MessageBox.warning(util.translate("scripts", "No se encontró el nodo en la ruta ruta %1").arg(ruta), MessageBox.Ok, MessageBox.NoButton);
        }
        debug("No está");
        return false;
      }
    } else {
      nodoXML = nodoXML.namedItem(nombreActual);
      if (!nodoXML) {
        if (debeExistir) {
          MessageBox.warning(util.translate("scripts", "No se pudo leer el nodo de la ruta:\n%1.\nNo se encuentra el nodo <%2>").arg(ruta).arg(nombreNodo[i]), MessageBox.Ok, MessageBox.NoButton);
        }
        debug("No está");
        return false;
      }
    }
  }
  debug("Sí está");
  return nodoXML;
}

function oficial_tbnConfigBus_clicked()
{
  var _i = this.iface;
  var xml = _i.xmlSearch_;
  var d = new Dialog;
  var tE = new TextEdit;
  tE.text = xml.toString(4);
  d.add(tE);
  if (!d.exec()) {
    return;
  }
  var sXML = tE.text;

  var xml2 = new QDomDocument;
  if (!xml2.setContent(sXML)) {
    MessageBox.warning(sys.translate("El XML contiene errores"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton, "AbanQ");
    return;
  }
  _i.xmlSearch_.setContent(sXML);
  return true;
}

function oficial_mtdNuevoCliente(curOrigen)
{
  var curCliente = new FLSqlCursor("clientes");
  curCliente.insertRecord();
}

function oficial_valoresChartFacturasCli(xGD, xParam)
{
  var _i = this.iface;

  var eGrafico = xGD.firstChild().toElement();
  eGrafico.setAttribute("Titulo", "");

  var ePeriodOption = _i.dameElementoXML(xParam, "Parameter[@name=Period]/Options/Option[@selected=true]");
  if (!ePeriodOption) {
    debug("ePeriodOption");
    return false;
  }
  var periodo = ePeriodOption.attribute("name");

  var eAnnos = _i.dameElementoXML(xParam, "Parameter[@name=Annos]");
  var annos = eAnnos.isNull() ? 1 : eAnnos.attribute("value");
  var hoy = new Date;
  var annoHasta = hoy.getYear();
  var annoDesde = annoHasta - annos + 1;

  var xmlValores = xGD.firstChild().namedItem("Valores");
  if (xmlValores) {
    eGrafico.removeChild(xmlValores);
  }
  var xValores = xGD.createElement("Valores");
  eGrafico.appendChild(xValores);
  var eValores = xValores.toElement();

  var q = new FLSqlQuery;
  var aPeriodos, campoPeriodo;
  switch (periodo) {
    case "Mes": {
      campoPeriodo = "EXTRACT(MONTH FROM f.fecha)";
      aPeriodos = [sys.translate("Enero"), sys.translate("Febrero"), sys.translate("Marzo"), sys.translate("Abril"), sys.translate("Mayo"), sys.translate("Junio"), sys.translate("Julio"), sys.translate("Agosto"), sys.translate("Septiembre"), sys.translate("Octubre"), sys.translate("Noviembre"), sys.translate("Diciembre")];
      break;
    }
    case "Trim": {
      campoPeriodo = "EXTRACT(QUARTER FROM f.fecha)";
      aPeriodos = [sys.translate("T1"), sys.translate("T2"), sys.translate("T3"), sys.translate("T4")];
      break;
    }
    default: {
      return false;
    }
  }
  var campoAnno = "EXTRACT(YEAR FROM f.fecha)";
  var campoMedida = "SUM(f.total)";
  q.setSelect(campoMedida + ", " + campoAnno + ", " + campoPeriodo);
  q.setFrom("facturascli f");
  q.setWhere("EXTRACT(YEAR FROM f.fecha) BETWEEN " + annoDesde + " AND " + annoHasta + " GROUP BY " + campoAnno + ", " + campoPeriodo + " ORDER BY " + campoAnno + ", " + campoPeriodo);
  q.setForwardOnly(true);
  if (!q.exec()) {
    return false;
  }
  var s, i, a, m;
  var nY = aPeriodos.length;

  var aV = new Array(annos);
  var elementosX = [];
  for (s = 0; s < annos; s++) {
    aV[s] = new Array(nY);
    for (i = 0; i < nY; i++) {
      aV[s][i] = 0;
    }
    a = annoDesde + s;
    elementosX.push([s, a]);
  }
  while (q.next()) {
    a = q.value(campoAnno);
    m = q.value(campoPeriodo);
    i = m - 1;
    s = a - annoDesde;
    aV[s][i] = q.value(campoMedida);
  }
  var nombreMedida = sys.translate("Facturación");
  var totalSecuencias = elementosX.length;
  var secuenciasX = [];
  var idSecuencia;
  var eSec;
  for (i = 0; i < totalSecuencias; i++) {
    idSecuencia = elementosX[i][0];
    secuenciasX[idSecuencia] = xGD.createElement("Secuencia");
    debug(secuenciasX[idSecuencia].isNull());
    eValores.appendChild(secuenciasX[idSecuencia]);
    eSec = secuenciasX[idSecuencia].toElement();
    eSec.setAttribute("Id", idSecuencia);
    eSec.setAttribute("Leyenda", elementosX[i][1]);
  }
  eValores.setAttribute("Secuencias", totalSecuencias);

  var xValor, eValor;
  var valor;
  var maxValor = 0;
  var hayDatos = false;
  for (s = 0; s < annos; s++) {
    for (i = 0; i < nY; i++) {
      hayDatos = true;
      xValor = xGD.createElement("Valor");
      secuenciasX[elementosX[s][0]].appendChild(xValor);
      eValor = xValor.toElement();
      valorY = aV[s][i];
      eValor.setAttribute("X", i);
      eValor.setAttribute("Y", valorY);
      valor = parseFloat(aV[s][i]);
      maxValor = (valor > maxValor ? valor : maxValor);
    }
  }
  if (!hayDatos) {
    return false;
  }
  var eEjeX = xGD.firstChild().namedItem("EjeX").toElement();
  eEjeX.setAttribute("Max", aPeriodos.length);
  var xMarca = eEjeX.namedItem("Marca");
  while (xMarca && !xMarca.isNull()) {
    eEjeX.removeChild(xMarca);
    xMarca = eEjeX.namedItem("Marca");
  }
  var eMarca;
  for (i = 0; i < aPeriodos.length; i++) {
    xMarca = xGD.createElement("Marca");
    eMarca = xMarca.toElement();
    eEjeX.appendChild(xMarca);
    eMarca.setAttribute("Id", i);
    eMarca.setAttribute("Label", aPeriodos[i]);
  }
  var eEjeY = xGD.firstChild().namedItem("EjeY").toElement();
  if (eEjeY.attribute("Medida") == "") {
    eEjeY.setAttribute("Medida", nombreMedida);
  }
  debug(xGD.toString(4));
  return true;
}

function oficial_valoresChartHorasUsuario(xGD, xParam)
{
  var _i = this.iface;

  var eGrafico = xGD.firstChild().toElement();
  eGrafico.setAttribute("Titulo", "");

  var aX = [];
  var eUserList = _i.dameElementoXML(xParam, "Parameter[@name=Users]/ItemList");
  if (eUserList.isNull()) {
    debug("eUserList.isNull()");
    return false;
  }
  var userList = "", idUsuario;
  for (var xUser = eUserList.firstChild(); !xUser.isNull(); xUser = xUser.nextSibling()) {
    idUsuario = xUser.toElement().attribute("name");
    userList += userList == "" ? "" : ", ";
    userList += "'" + idUsuario + "'";
    aX.push(idUsuario);
  }

  var hoy = new Date;
  var fecha = hoy.toString().left(10);

  var xmlValores = xGD.firstChild().namedItem("Valores");
  if (xmlValores) {
    eGrafico.removeChild(xmlValores);
  }
  var xValores = xGD.createElement("Valores");
  eGrafico.appendChild(xValores);
  var eValores = xValores.toElement();

  var s, i, u;
  // var aX = ["antonio", "arodriguez", "lorena", "falbujer"];
  var nY = aX.length;

  var aSecuencias =  [[0, sys.translate("Trabajadas")], [1, sys.translate("Facturadas")]];
  var totalSecuencias = aSecuencias.length;
  var aV = new Array(totalSecuencias);
  for (s = 0; s < totalSecuencias; s++) {
    aV[s] = new Array(nY);
    for (i = 0; i < nY; i++) {
      aV[s][i] = 0;
    }
  }

  var q = new FLSqlQuery;
  var campoSecuencia = "codusuario"; //encargado";
  var campoMedida = "SUM(horas)";
  q.setSelect(campoMedida + ", " + campoSecuencia);
  q.setFrom("se_horastrabajadas");
  q.setWhere(campoSecuencia + " IN (" + userList + ") AND fecha = CURRENT_DATE GROUP BY " + campoSecuencia + " ORDER BY " + campoSecuencia);
  q.setForwardOnly(true);
  debug(q.sql());
  if (!q.exec()) {
    return false;
  }

  while (q.next()) {
    u = q.value(campoSecuencia);
    i = _i.buscaElementoArray(aX, u);
    if (i >= 0) {
      aV[0][i] = q.value(campoMedida);
    }
  }

  campoSecuencia = "codencargado";
  campoMedida = "SUM(horas)";
  q.setSelect(campoMedida + ", " + campoSecuencia);
  q.setFrom("se_horasfacturadas");
  q.setWhere(campoSecuencia + " IN (" + userList + ") AND fecha = CURRENT_DATE GROUP BY " + campoSecuencia + " ORDER BY " + campoSecuencia);
  q.setForwardOnly(true);
  debug(q.sql());
  if (!q.exec()) {
    return false;
  }

  while (q.next()) {
    u = q.value(campoSecuencia);
    i = _i.buscaElementoArray(aX, u);
    if (i >= 0) {
      aV[1][i] = q.value(campoMedida);
    }
  }

  var nombreMedida = sys.translate("Horas");
  var secuenciasX = [];
  var idSecuencia;
  var eSec;
  for (i = 0; i < totalSecuencias; i++) {
    idSecuencia = aSecuencias [i][0];
    secuenciasX[idSecuencia] = xGD.createElement("Secuencia");
    debug(secuenciasX[idSecuencia].isNull());
    eValores.appendChild(secuenciasX[idSecuencia]);
    eSec = secuenciasX[idSecuencia].toElement();
    eSec.setAttribute("Id", idSecuencia);
    eSec.setAttribute("Leyenda", aSecuencias[i][1]);
  }
  eValores.setAttribute("Secuencias", totalSecuencias);

  var xValor, eValor;
  var valor;
  var maxValor = 0;
  var hayDatos = false;
  for (s = 0; s < totalSecuencias; s++) {
    for (i = 0; i < nY; i++) {
      hayDatos = true;
      xValor = xGD.createElement("Valor");
      secuenciasX[aSecuencias[s][0]].appendChild(xValor);
      eValor = xValor.toElement();
      valorY = aV[s][i];
      eValor.setAttribute("X", i);
      eValor.setAttribute("Y", valorY);
      valor = parseFloat(aV[s][i]);
      maxValor = (valor > maxValor ? valor : maxValor);
    }
  }
  if (!hayDatos) {
    return false;
  }
  var eEjeX = xGD.firstChild().namedItem("EjeX").toElement();
  eEjeX.setAttribute("Max", aX.length);
  var xMarca = eEjeX.namedItem("Marca");
  while (xMarca && !xMarca.isNull()) {
    eEjeX.removeChild(xMarca);
    xMarca = eEjeX.namedItem("Marca");
  }
  var eMarca;
  for (i = 0; i < aX.length; i++) {
    xMarca = xGD.createElement("Marca");
    eMarca = xMarca.toElement();
    eEjeX.appendChild(xMarca);
    eMarca.setAttribute("Id", i);
    eMarca.setAttribute("Label", aX[i]);
  }
  var eEjeY = xGD.firstChild().namedItem("EjeY").toElement();
  if (eEjeY.attribute("Medida") == "") {
    eEjeY.setAttribute("Medida", nombreMedida);
  }
  debug(xGD.toString(4));
  return true;
}

function oficial_buscaElementoArray(a, e)
{
  var l = a.length;
  for (var i = 0; i < l; i++) {
    if (a[i] == e) {
      return i;
    }
  }
  return -1;
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
////////////////////////////////////////////////////////////////