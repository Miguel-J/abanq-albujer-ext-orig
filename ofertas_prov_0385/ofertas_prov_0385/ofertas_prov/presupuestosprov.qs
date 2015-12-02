/***************************************************************************
                 presupuestosprov.qs  -  description
                             -------------------
    begin                : mie sep 2008
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
  function calculateCounter(): String {
    return this.ctx.interna_calculateCounter();
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
  var curArticulosProv_: FLSqlCursor;
  var COL_IDLINEA: Number;
  var COL_REFERENCIA: Number;
  var COL_DESCRIPCION: Number;
  var COL_CANTIDAD: Number;
  var COL_COSTE: Number;
  var COL_DTO: Number;
  var COL_PLAZO: Number;
  var COL_PROVDEFECTO: Number;
  var COL_PROVDEFECTOANT: Number;
  var tablaLineas: FLTable;
  var tipoInsercion_: String;
  function oficial(context)
  {
    interna(context);
  }
  function aceptarOferta_clicked()
  {
    return this.ctx.oficial_aceptarOferta_clicked();
  }
  function altaMasivaDtoProv_clicked()
  {
    return this.ctx.oficial_altaMasivaDtoProv_clicked();
  }
  function altaMasivaDtoProv(curCriterios: FLSqlCursor): String {
    return this.ctx.oficial_altaMasivaDtoProv(curCriterios);
  }
  function actualizarArticulosProv(xmlLinea: FLDomElement, codProveedor: String): Boolean {
    return this.ctx.oficial_actualizarArticulosProv(xmlLinea, codProveedor);
  }
  function generarLineas(datos: String): Boolean {
    return this.ctx.oficial_generarLineas(datos);
  }
  function introduccionDatos(codPresupuesto: String): Boolean {
    return this.ctx.oficial_introduccionDatos(codPresupuesto);
  }
  function guardarPrecios()
  {
    return this.ctx.oficial_guardarPrecios();
  }
  function refrescarTabla()
  {
    return this.ctx.oficial_refrescarTabla();
  }
  function insertarLineaTabla(qryLineasOferta: FLSqlQuery): Boolean {
    return this.ctx.oficial_insertarLineaTabla(qryLineasOferta);
  }
  function marcarProveedorDefecto(fila: Number, col: Number)
  {
    return this.ctx.oficial_marcarProveedorDefecto(fila, col);
  }
  function datosArticuloProv(xmlLinea: FLDomElement): Boolean {
    return this.ctx.oficial_datosArticuloProv(xmlLinea);
  }
  function bufferChanged(fN: String)
  {
    return this.ctx.oficial_bufferChanged(fN);
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
  var cursor: FLSqlCursor = this.cursor();

  connect(this.child("pbnAceptarOferta"), "clicked()", this, "iface.aceptarOferta_clicked()");
  connect(this.child("pbnAltaMasivaDtoProv"), "clicked()", this, "iface.altaMasivaDtoProv_clicked()");
  connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");

  if (cursor.modeAccess() == cursor.Insert) {
    this.child("fdbCodEjercicio").setValue(flfactppal.iface.pub_ejercicioActual());
    this.child("fdbCodSerie").setValue(flfactppal.iface.pub_valorDefectoEmpresa("codserie"));
  }
  if (cursor.modeAccess() == cursor.Edit) {
    this.child("fdbCodSerie").setDisabled(true);
  }

  this.iface.tipoInsercion_ = formpresupuestosprov.iface.tipoInsercion_;
  if (this.iface.tipoInsercion_ == "Precios") {
    formpresupuestosprov.iface.tipoInsercion_ = false;
    this.child("tbwPresupuestosProv").setTabEnabled("lineas", false);
    this.child("tbwPresupuestosProv").setTabEnabled("precios", true);
    this.child("tbwPresupuestosProv").currentPage = 1;
  } else {
    this.child("tbwPresupuestosProv").setTabEnabled("lineas", true);
    this.child("tbwPresupuestosProv").setTabEnabled("precios", false);
    this.child("tbwPresupuestosProv").currentPage = 0;
  }

  this.iface.tablaLineas = this.child("tblValores");
  connect(this.iface.tablaLineas, "doubleClicked(int, int)", this, "iface.marcarProveedorDefecto");
  connect(this.child("tbnGuardarPrecios"), "clicked()", this, "iface.guardarPrecios()");
  this.iface.refrescarTabla();
  this.iface.bufferChanged("codproveedor");

  //  var referencia:String = cursor.valueBuffer("referencia")
  //  if (referencia && referencia != "") {
  //    this.child("fdbReferencia").setValue("");
  //    this.child("fdbReferencia").setValue(referencia);
  //  }
}

/** \D Calcula un nuevo número de oferta
\end */
function interna_calculateCounter()
{
  var util: FLUtil = new FLUtil();
  return util.nextCounter("codigo", this.cursor());
}

function interna_validateForm(): Boolean {
  var util: FLUtil = new FLUtil();

  if (this.iface.tipoInsercion_ == "Precios")
  {
    MessageBox.warning(util.translate("scripts", "Debe pulsar el botón guardar precios para que los cambios se actualicen"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  return true;
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
/** \D Compone una tabla de tantas filas como líneas tiene la oferta seleccionada*/
function oficial_refrescarTabla()
{
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  this.iface.COL_IDLINEA = 0;
  this.iface.COL_REFERENCIA = 1;
  this.iface.COL_DESCRIPCION = 2;
  this.iface.COL_CANTIDAD = 3;
  this.iface.COL_COSTE = 4;
  this.iface.COL_DTO = 5;
  this.iface.COL_PLAZO = 6;
  this.iface.COL_PROVDEFECTO = 7;
  this.iface.COL_PROVDEFECTOANT = 8;

  this.iface.tablaLineas.setNumCols(9);
  this.iface.tablaLineas.setColumnWidth(this.iface.COL_IDLINEA, 0);
  this.iface.tablaLineas.setColumnWidth(this.iface.COL_REFERENCIA, 100);
  this.iface.tablaLineas.setColumnWidth(this.iface.COL_DESCRIPCION, 170);
  this.iface.tablaLineas.setColumnWidth(this.iface.COL_CANTIDAD, 50);
  this.iface.tablaLineas.setColumnWidth(this.iface.COL_COSTE, 80);
  this.iface.tablaLineas.setColumnWidth(this.iface.COL_DTO, 60);
  this.iface.tablaLineas.setColumnWidth(this.iface.COL_PLAZO, 110);
  this.iface.tablaLineas.setColumnWidth(this.iface.COL_PROVDEFECTO, 80);

  this.iface.tablaLineas.setColumnLabels("/", "IdLinea/Referencia/Descripcion/Cant./P.Coste/Dto/Plazo Entrega/P.Defecto/P.Defecto Anterior");
  this.iface.tablaLineas.setColumnReadOnly(this.iface.COL_REFERENCIA, true);
  this.iface.tablaLineas.setColumnReadOnly(this.iface.COL_DESCRIPCION, true);
  this.iface.tablaLineas.setColumnReadOnly(this.iface.COL_CANTIDAD, true);
  this.iface.tablaLineas.setColumnReadOnly(this.iface.COL_PROVDEFECTO, true);
  this.iface.tablaLineas.hideColumn(this.iface.COL_IDLINEA);
  this.iface.tablaLineas.hideColumn(this.iface.COL_PROVDEFECTOANT);

  var codProveedor: String = cursor.valueBuffer("codproveedor");
  var qryLineasOferta: FLSqlQuery = new FLSqlQuery;
  with(qryLineasOferta) {
    setTablesList("lineaspresupuestosprov,articulosprov");
    setSelect("lp.idlinea, lp.referencia, lp.descripcion, lp.cantidad, lp.pvpunitario, lp.dto, lp.plazo, ap.pordefecto");
    setFrom("lineaspresupuestosprov lp LEFT OUTER JOIN articulosprov ap ON (lp.referencia = ap.referencia AND ap.codproveedor = '" + codProveedor + "')");
    setWhere("lp.idpresupuesto = " + cursor.valueBuffer("idpresupuesto"));
    setForwardOnly(true);
  }
  if (!qryLineasOferta.exec()) {
    return false;
  }
  while (qryLineasOferta.next()) {
    if (!this.iface.insertarLineaTabla(qryLineasOferta)) {
      return false;
    }
  }
}

function oficial_insertarLineaTabla(qryLineasOferta: FLSqlQuery): Boolean {
  var util: FLUtil = new FLUtil;
  var numLinea: Number = this.iface.tablaLineas.numRows();
  this.iface.tablaLineas.insertRows(numLinea);

  this.iface.tablaLineas.setText(numLinea, this.iface.COL_IDLINEA, qryLineasOferta.value("lp.idlinea"));
  this.iface.tablaLineas.setText(numLinea, this.iface.COL_REFERENCIA, qryLineasOferta.value("lp.referencia"));
  this.iface.tablaLineas.setText(numLinea, this.iface.COL_DESCRIPCION, qryLineasOferta.value("lp.descripcion"));
  this.iface.tablaLineas.setText(numLinea, this.iface.COL_CANTIDAD, qryLineasOferta.value("lp.cantidad"));
  this.iface.tablaLineas.setText(numLinea, this.iface.COL_COSTE, qryLineasOferta.value("lp.pvpunitario"));
  this.iface.tablaLineas.setText(numLinea, this.iface.COL_DTO, qryLineasOferta.value("lp.dto"));
  this.iface.tablaLineas.setText(numLinea, this.iface.COL_PLAZO, qryLineasOferta.value("lp.plazo"));
  if (qryLineasOferta.value("ap.pordefecto") == true)
  {
    this.iface.tablaLineas.setText(numLinea, this.iface.COL_PROVDEFECTO, "X");
    this.iface.tablaLineas.setText(numLinea, this.iface.COL_PROVDEFECTOANT, "X");
  }

  return true;
}

function oficial_guardarPrecios()
{
  var cursor: FLSqlCursor = this.cursor();
  var util: FLUtil = new FLUtil;
  var datos: String = "";

  datos = "<Lineas>\n";
  var provDefecto: String;
  for (var i: Number = 0; i < this.iface.tablaLineas.numRows(); i++) {
    if (this.iface.tablaLineas.text(i, this.iface.COL_PROVDEFECTO) == "X" && this.iface.tablaLineas.text(i, this.iface.COL_PROVDEFECTOANT) != "X") {
      provDefecto = "true";
    } else {
      provDefecto = "false";
    }
    datos += "<Linea IdLinea = '" + this.iface.tablaLineas.text(i, this.iface.COL_IDLINEA) + "' Referencia = '" + this.iface.tablaLineas.text(i, this.iface.COL_REFERENCIA) + "' Descripcion = '" + this.iface.tablaLineas.text(i, this.iface.COL_DESCRIPCION) + "' Cantidad = '" + this.iface.tablaLineas.text(i, this.iface.COL_CANTIDAD) + "' Coste = '" + this.iface.tablaLineas.text(i, this.iface.COL_COSTE) + "' Dto = '" + this.iface.tablaLineas.text(i, this.iface.COL_DTO) + "' Plazo = '" + this.iface.tablaLineas.text(i, this.iface.COL_PLAZO) + "' ProvDefecto = '" + provDefecto + "'/>\n";
  }
  datos += "</Lineas>";

  if (!this.iface.generarLineas(datos)) {
    return false;
  }
  var res: Number = MessageBox.information(util.translate("scripts", "Los precios indicados han sido actualizados correctamente en las líneas de la oferta.\n¿Desea marcar la oferta como recibida?"), MessageBox.Yes, MessageBox.No);
  if (res == MessageBox.Yes) {
    cursor.setValueBuffer("estado", "Recibida");
  }

  this.child("tbwPresupuestosProv").setTabEnabled("lineas", true);
  this.child("tbwPresupuestosProv").setTabEnabled("precios", false);
  this.child("tbwPresupuestosProv").currentPage = 0;
  this.iface.tipoInsercion_ = "";
}

function oficial_generarLineas(datos: String): Boolean {
  var util: FLUtil = new FLUtil;

  var cursor: FLSqlCursor = this.cursor();
  var docXML: FLDomDocument = new FLDomDocument;
  if (!docXML.setContent(datos))
  {
    return false;
  }

  var codProveedor: String = cursor.valueBuffer("codproveedor");
  var listaXMLLineas: FLDomNodeList = docXML.firstChild().childNodes();
  var xmlLinea: FLDomElement;
  var referencia: String;
  for (var i: Number = 0; i < listaXMLLineas.length(); i++)
  {
    xmlLinea = listaXMLLineas.item(i).toElement();
    referencia = xmlLinea.attribute("Referencia");
    var curLineasOferta: FLSqlCursor = new FLSqlCursor("lineaspresupuestosprov");
    curLineasOferta.select("idlinea = " + xmlLinea.attribute("IdLinea"));
    if (!curLineasOferta.first())
      return false;
    curLineasOferta.setModeAccess(curLineasOferta.Edit);
    curLineasOferta.refreshBuffer();

    curLineasOferta.setValueBuffer("pvpunitario", xmlLinea.attribute("Coste"));
    curLineasOferta.setValueBuffer("dto", xmlLinea.attribute("Dto"));
    curLineasOferta.setValueBuffer("plazo", xmlLinea.attribute("Plazo"));

    if (!curLineasOferta.commitBuffer())
      return false;

    if (this.child("chkActualizarProveedor").checked) {
      if (!this.iface.actualizarArticulosProv(xmlLinea, codProveedor))
        return false;
    }
    if (xmlLinea.attribute("ProvDefecto") == "true") {
      if (!util.sqlSelect("articulosprov", "id", "referencia = '" + referencia + "' AND codproveedor = '" + codProveedor + "'")) {
        MessageBox.warning(util.translate("scripts", "No es posible marcar al proveedor seleccionado como proveedor por defecto de %1.\nPara hacerlo debe activar la casilla de Actualizar datos de provedor").arg(referencia), MessageBox.Ok, MessageBox.NoButton);
      } else {
        if (!formRecordarticulos.iface.pub_establecerProveedorDefecto(referencia, codProveedor)) {
          return false;
        }
      }
    }
  }

  return true;
}

function oficial_actualizarArticulosProv(xmlLinea: FLDomElement, codProveedor: String): Boolean {
  var util: FLUtil = new FLUtil();
  var nombreProveedor: String = util.sqlSelect("proveedores", "nombre", "codproveedor = '" + codProveedor + "'");
  if (!this.iface.curArticulosProv_)
  {
    this.iface.curArticulosProv_ = new FLSqlCursor("articulosprov");
  }
  this.iface.curArticulosProv_.select("referencia = '" + xmlLinea.attribute("Referencia") + "' AND codproveedor = '" + codProveedor + "'");
  if (!this.iface.curArticulosProv_.first())
  {
    with(this.iface.curArticulosProv_) {
      setModeAccess(Insert);
      refreshBuffer();

      setValueBuffer("referencia", xmlLinea.attribute("Referencia"));
      setValueBuffer("codproveedor", codProveedor);
      setValueBuffer("nombre", nombreProveedor);
      setValueBuffer("coddivisa", "EUR");
    }
    if (!this.iface.datosArticuloProv(xmlLinea)) {
      return false;
    }

    if (!this.iface.curArticulosProv_.commitBuffer()) {
      return false;
    }
  } else {
    with(this.iface.curArticulosProv_)
    {
      setModeAccess(Edit);
      refreshBuffer();
    }

    if (!this.iface.datosArticuloProv(xmlLinea))
    {
      return false;
    }

    if (!this.iface.curArticulosProv_.commitBuffer())
    {
      return false;
    }
  }

  return true;
}

function oficial_datosArticuloProv(xmlLinea: FLDomElement): Boolean {
  this.iface.curArticulosProv_.setValueBuffer("coste", xmlLinea.attribute("Coste"));
  this.iface.curArticulosProv_.setValueBuffer("dto", xmlLinea.attribute("Dto"));
  this.iface.curArticulosProv_.setValueBuffer("plazo", xmlLinea.attribute("Plazo"));

  return true;
}

function oficial_aceptarOferta_clicked()
{
  var util: FLUtil = new FLUtil();
  var cursor: FLSqlCursor = this.cursor();
  var dialog: Object = new Dialog(util.translate("scripts", "Aceptar oferta"), 0, "");
  dialog.OKButtonText = util.translate("scripts", "Aceptar");
  dialog.cancelButtonText = util.translate("scripts", "Cancelar");

  var bgroup: Object = new GroupBox;
  dialog.add(bgroup);

  var oferta: Object = new RadioButton;
  oferta.text = "Toda la oferta";
  bgroup.add(oferta);

  var linea: Object = new RadioButton;
  linea.text = "Sólo la línea seleccionada";
  bgroup.add(linea);

  if (!dialog.exec())
    return false;

  if (linea.checked == true) {
    var curLineaOferta: FLSqlCursor = this.child("tdbLineasPresupuestosProv").cursor();
    if (!flfacturac.iface.pub_aceptarOferta(curLineaOferta))
      return false;
  }

  if (oferta.checked == true) {
    var qry: FLSqlQuery = new FLSqlQuery;
    with(qry) {
      setTablesList("lineaspresupuestosprov");
      setSelect("idlinea");
      setFrom("lineaspresupuestosprov");
      setWhere("idpresupuesto = " + cursor.valueBuffer("idpresupuesto"));
      setForwardOnly(true);
    }
    if (!qry.exec())
      return false;

    var curLineaOferta: FLSqlCursor = this.child("tdbLineasPresupuestosProv").cursor();
    while (qry.next()) {
      curLineaOferta.select("idlinea = " + qry.value("idlinea"));
      curLineaOferta.first();
      if (!flfacturac.iface.pub_aceptarOferta(curLineaOferta))
        return false;
    }
  }

  this.child("tdbLineasPresupuestosProv").refresh();

}

function oficial_altaMasivaDtoProv_clicked()
{
  var util: FLUtil = new FLUtil();
  var cursor: FLSqlCursor = this.cursor();

  if (cursor.modeAccess() == cursor.Insert) {
    var curLineasOferta: FLSqlCursor = this.child("tdbLineasPresupuestosProv").cursor();
    if (!curLineasOferta.commitBufferCursorRelation()) {
      return false;
    }
  }

  if (util.sqlSelect("lineaspresupuestosprov", "idlinea", "idpresupuesto = " + cursor.valueBuffer("idpresupuesto"))) {
    var res: Number = MessageBox.information(util.translate("scripts", "¿Desea borrar las líneas ya asociadadas?"), MessageBox.Yes, MessageBox.No);
    if (res == MessageBox.Yes) {
      if (!util.sqlDelete("lineaspresupuestosprov", "idpresupuesto = " + cursor.valueBuffer("idpresupuesto"))) {
        return false;
      }
    }
    this.child("tdbLineasPresupuestosProv").refresh();
  }

  var f: Object = new FLFormSearchDB("altamasivadtoprov");
  var curAltaDto: FLSqlCursor = f.cursor();
  curAltaDto.setModeAccess(curAltaDto.Insert);
  curAltaDto.refreshBuffer();
  curAltaDto.setValueBuffer("usuario", sys.nameUser());
  if (!curAltaDto.commitBuffer())
    return false;;

  curAltaDto.select("usuario = '" + sys.nameUser() + "'");
  if (!curAltaDto.first())
    return false;

  curAltaDto.setModeAccess(curAltaDto.Edit);
  curAltaDto.refreshBuffer();

  f.setMainWidget();
  curAltaDto.refreshBuffer();
  var acpt: String = f.exec("usuario");
  if (!acpt)
    return false;

  var where: String = this.iface.altaMasivaDtoProv(curAltaDto);

  var curLineasOferta: FLSqlCursor = new FLSqlCursor("lineaspresupuestosprov");
  var qry: FLSqlQuery = new FLSqlQuery;
  qry.setTablesList("articulos");
  qry.setSelect("referencia,descripcion");
  qry.setFrom("articulos");
  qry.setWhere(where);
  qry.setForwardOnly(true);

  if (!qry.exec())
    return false;

  while (qry.next()) {
    if (!util.sqlSelect("articulosprov", "id", "referencia = '" + qry.value("referencia") + "' AND codproveedor = '" + cursor.valueBuffer("codproveedor") + "'")) {
      continue;
    }

    curLineasOferta.select("idpresupuesto = " + cursor.valueBuffer("idpresupuesto") + " AND referencia = '" + qry.value("referencia") + "'");
    if (curLineasOferta.first()) {
      curLineasOferta.setModeAccess(curLineasOferta.Edit);
      curLineasOferta.refreshBuffer();
    } else {
      curLineasOferta.setModeAccess(curLineasOferta.Insert);
      curLineasOferta.refreshBuffer();
      curLineasOferta.setValueBuffer("idpresupuesto", cursor.valueBuffer("idpresupuesto"));
      curLineasOferta.setValueBuffer("codproveedor", cursor.valueBuffer("codproveedor"));
      curLineasOferta.setValueBuffer("referencia", qry.value("referencia"));
      curLineasOferta.setValueBuffer("descripcion", qry.value("descripcion"));
      curLineasOferta.setValueBuffer("cantidad", 0);
    }
    curLineasOferta.setValueBuffer("dto", curAltaDto.valueBuffer("dto"));

    if (!curLineasOferta.commitBuffer())
      return false;

    if (!util.sqlUpdate("articulosprov", "dto", curAltaDto.valueBuffer("dto"), "referencia = '" + qry.value("referencia") + "' AND codproveedor = '" + cursor.valueBuffer("codproveedor") + "'")) {
      return false;
    }
  }

  this.child("tdbLineasPresupuestosProv").refresh();
}

function oficial_altaMasivaDtoProv(curCriterios: FLSqlCursor): String {
  var util: FLUtil = new FLUtil();
  var cursor: FLSqlCursor = this.cursor();
  var where: String = "";

  if (curCriterios.valueBuffer("codfamiliadesde"))
  {
    if (where != "") {
      where += " AND ";
    }
    where +=  "codfamilia >= '" + curCriterios.valueBuffer("codfamiliadesde") + "'";
  }

  if (curCriterios.valueBuffer("codfamiliahasta"))
  {
    if (where != "") {
      where += " AND ";
    }
    where += "codfamilia <= '" + curCriterios.valueBuffer("codfamiliahasta") + "'";
  }

  if (curCriterios.valueBuffer("referenciadesde"))
  {
    if (where != "") {
      where += " AND ";
    }
    where += "referencia >= '" + curCriterios.valueBuffer("referenciadesde") + "'";
  }

  if (curCriterios.valueBuffer("referenciahasta"))
  {
    if (where != "") {
      where += " AND ";
    }
    where += "referencia <= '" + curCriterios.valueBuffer("referenciahasta") + "'";
  }

  return where;
}

function oficial_marcarProveedorDefecto(fila: Number, col: Number)
{
  var util: FLUtil = new FLUtil();
  if (this.iface.tablaLineas.numRows() == 0) return;

  if (col != this.iface.COL_PROVDEFECTO) {
    return;
  }

  if (this.iface.tablaLineas.text(fila, this.iface.COL_PROVDEFECTOANT) == "X") {
    MessageBox.warning(util.translate("scripts", "El artículo seleccionado ya tiene asociado como proveedor por defecto el proveedor de la oferta"), MessageBox.Ok, MessageBox.NoButton);
    return;
  }

  if (this.iface.tablaLineas.text(fila, this.iface.COL_PROVDEFECTO) == "X") {
    this.iface.tablaLineas.setText(fila, this.iface.COL_PROVDEFECTO, "");
  } else {
    this.iface.tablaLineas.setText(fila, this.iface.COL_PROVDEFECTO, "X");
  }
}

function oficial_bufferChanged(fN: String)
{
  var cursor: FLSqlCursor = this.cursor();

  switch (fN) {
    case "codproveedor": {
      var codProveedor: String = cursor.valueBuffer("codproveedor");
      if (!codProveedor || codProveedor == "") {
        this.child("fdbCodContacto").setFilter("1 = 2");
      } else {
        this.child("fdbCodContacto").setFilter("codcontacto IN(SELECT codcontacto FROM contactosproveedores WHERE codproveedor = '" + cursor.valueBuffer("codproveedor") + "')");
      }
      break;
    }
  }
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
