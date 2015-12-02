/***************************************************************************
                 listadotabla.qs  -  description
                             -------------------
    begin                : lun dic 03 2007
    copyright            : (C) 2007 by InfoSiAL S.L.
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
  var tbnExportar: Object;
  var tbnBajar: Object;
  var tbnSubir: Object;
  var tbnIncluir: Object;
  var fdbNombreTabla: Object;
  var tdbCampos: Object;
  var tbnBuscarTabla: Object;
  var campoSeleccionado: Number;
  function oficial(context)
  {
    interna(context);
  }
  function subir()
  {
    return this.ctx.oficial_subir();
  }
  function bajar()
  {
    return this.ctx.oficial_bajar();
  }
  function incluir(fila: Number, col: Number)
  {
    return this.ctx.oficial_incluir(fila, col);
  }
  function exportar()
  {
    return this.ctx.oficial_exportar();
  }
  function bufferChanged(fN: String)
  {
    return this.ctx.oficial_bufferChanged(fN);
  }
  function insertarCampo(indice: Number, campo: String, alias: String, tipo: String): Boolean {
    return this.ctx.oficial_insertarCampo(indice, campo, alias, tipo);
  }
  function mostrarCampos()
  {
    return this.ctx.oficial_mostrarCampos();
  }
  function buscarTabla()
  {
    return this.ctx.oficial_buscarTabla();
  }
  function crearXml(): String {
    return this.ctx.oficial_crearXml();
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
  var util: FLUtil;
  this.iface.tbnBajar = this.child("tbnBajar");
  this.iface.tbnSubir = this.child("tbnSubir");
  this.iface.tbnIncluir = this.child("tbnIncluir");
  this.iface.fdbNombreTabla = this.child("fdbNombreTabla");
  this.iface.tdbCampos = this.child("tdbCampos");
  this.iface.tbnExportar = this.child("tbnExportar");
  this.iface.tbnBuscarTabla = this.child("tbnBuscarTabla");

  connect(this.iface.tbnBuscarTabla, "clicked()", this, "iface.buscarTabla");
  connect(this.cursor(), "bufferChanged(QString)", this, "iface.bufferChanged");
  connect(this.iface.tbnBajar, "clicked()", this, "iface.bajar()");
  connect(this.iface.tbnSubir, "clicked()", this, "iface.subir()");
  connect(this.iface.tbnIncluir, "clicked()", this, "iface.incluir()");
  connect(this.iface.tbnExportar, "clicked()", this, "iface.exportar()");
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_buscarTabla()
{
  var f: Object = new FLFormSearchDB("seleccionartabla");
  var curTablas: FLSqlCursor = f.cursor();
  curTablas.setModeAccess(curTablas.Browse);
  curTablas.refreshBuffer();
  curTablas.setMainFilter("nombre LIKE '%.mtd'");
  f.setMainWidget();
  f.child("tableDBRecords").setReadOnly(true);

  f.exec("nombre");

  if (f.accepted())
    this.iface.fdbNombreTabla.setValue(curTablas.valueBuffer("nombre"));
}

function oficial_subir()
{
  var util: FLUtil;

  var id: Number = this.iface.tdbCampos.cursor().valueBuffer("id");
  var idListado: Number = this.iface.tdbCampos.cursor().valueBuffer("idlistado");
  var indice: Boolean = this.iface.tdbCampos.cursor().valueBuffer("indice");

  if (!id)
    return;

  var idAnterior: Number = util.sqlSelect("listadocampos", "id", "idlistado = " + idListado + " AND indice = " + (indice - 1));
  if (!idAnterior)
    return;

  if (!util.sqlUpdate("listadocampos", "indice", (indice - 1), "id = " + id))
    return false;

  if (!util.sqlUpdate("listadocampos", "indice", indice, "id = " + idAnterior))
    return false;

  this.iface.tdbCampos.refresh();
}

function oficial_bajar()
{
  var util: FLUtil;

  var id: Number = this.iface.tdbCampos.cursor().valueBuffer("id");
  var idListado: Number = this.iface.tdbCampos.cursor().valueBuffer("idlistado");
  var indice: Boolean = this.iface.tdbCampos.cursor().valueBuffer("indice");

  if (!id)
    return;

  var idPosterior: Number = util.sqlSelect("listadocampos", "id", "idlistado = " + idListado + " AND indice = " + (indice + 1));
  if (!idPosterior)
    return;

  if (!util.sqlUpdate("listadocampos", "indice", (indice + 1), "id = " + id))
    return false;

  if (!util.sqlUpdate("listadocampos", "indice", indice, "id = " + idPosterior))
    return false;

  this.iface.tdbCampos.refresh();

}

function oficial_incluir()
{
  var util: FLUtil;

  var id: Number = this.iface.tdbCampos.cursor().valueBuffer("id");
  var incluir: Boolean = this.iface.tdbCampos.cursor().valueBuffer("incluir");

  if (!id)
    return;

  if (incluir)
    incluir = false;
  else
    incluir = true;

  if (!util.sqlUpdate("listadocampos", "incluir", incluir, "id = " + id))
    return false;

  this.iface.tdbCampos.refresh();
}

function oficial_bufferChanged(fN: String)
{
  switch (fN) {
    case "nombretabla": {
      this.iface.mostrarCampos();
    }
    break;
    default:
      break;
  }
}

function oficial_mostrarCampos()
{
  var util: FLUtil;

  if (this.cursor().modeAccess() == this.cursor().Insert) {
    if (!this.iface.tdbCampos.cursor().commitBufferCursorRelation())
      return false;
  }

  var tabla: String = this.cursor().valueBuffer("nombretabla");
  if (!tabla || tabla == "")
    return;

  if (!util.sqlSelect("flfiles", "nombre",  "nombre = '" + tabla + "'"))
    return;

  var contenido: String = util.sqlSelect("flfiles", "contenido",  "nombre = '" + tabla + "'")
                          if (!contenido || contenido == "")
                            return;

  if (!util.sqlDelete("listadocampos", "idlistado = " + this.cursor().valueBuffer("id")))
    return;

  var xmlDoc: FLDomDocument = new FLDomDocument();
  xmlDoc.setContent(contenido);
  var listaNodos: FLDomNodeList = xmlDoc.firstChild().childNodes();
  var indice: Number = 0;
  var campo: String;
  var tipo: String;
  var alias: String;
  var arrayAux: Array = [];
  for (var i = 0; i < listaNodos.length(); i++) {
    if (listaNodos.item(i).nodeName() == "field") {
      campo = listaNodos.item(i).namedItem("name").toElement().text();
      tipo = listaNodos.item(i).namedItem("type").toElement().text();
      alias = listaNodos.item(i).namedItem("alias").toElement().text();
      arrayAux = alias.split("\"");
      if (arrayAux.length > 4)
        alias = arrayAux[3];
      if (this.iface.insertarCampo(indice, campo, alias, tipo))
        return false;
      indice += 1;
    }
  }
  this.iface.campoSeleccionado = 0;
}

function oficial_insertarCampo(indice: Number, campo: String, alias: String, tipo: String): Boolean {
  var idListado: Number = this.cursor().valueBuffer("id");
  var cursor: FLSqlCursor = new FLSqlCursor("listadocampos");

  cursor.setModeAccess(cursor.Insert)
  cursor.refreshBuffer();
  cursor.setValueBuffer("idlistado", idListado);
  cursor.setValueBuffer("indice", indice);
  cursor.setValueBuffer("campo", campo);
  cursor.setValueBuffer("alias", alias);
  cursor.setValueBuffer("incluir", true);
  cursor.setValueBuffer("tipo", tipo);
  if (!cursor.commitBuffer())
    return false;

  this.iface.tdbCampos.refresh();

}

function oficial_crearXml(): String {
  var util: FLUtil;
  var xml: String = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<office:document-content xmlns:office=\"urn:oasis:names:tc:opendocument:xmlns:office:1.0\" xmlns:style=\"urn:oasis:names:tc:opendocument:xmlns:style:1.0\" xmlns:text=\"urn:oasis:names:tc:opendocument:xmlns:text:1.0\" xmlns:table=\"urn:oasis:names:tc:opendocument:xmlns:table:1.0\" xmlns:draw=\"urn:oasis:names:tc:opendocument:xmlns:drawing:1.0\" xmlns:fo=\"urn:oasis:names:tc:opendocument:xmlns:xsl-fo-compatible:1.0\" xmlns:xlink=\"http://www.w3.org/1999/xlink\" xmlns:dc=\"http://purl.org/dc/elements/1.1/\" xmlns:meta=\"urn:oasis:names:tc:opendocument:xmlns:meta:1.0\" xmlns:number=\"urn:oasis:names:tc:opendocument:xmlns:datastyle:1.0\" xmlns:svg=\"urn:oasis:names:tc:opendocument:xmlns:svg-compatible:1.0\" xmlns:chart=\"urn:oasis:names:tc:opendocument:xmlns:chart:1.0\" xmlns:dr3d=\"urn:oasis:names:tc:opendocument:xmlns:dr3d:1.0\" xmlns:math=\"http://www.w3.org/1998/Math/MathML\" xmlns:form=\"urn:oasis:names:tc:opendocument:xmlns:form:1.0\" xmlns:script=\"urn:oasis:names:tc:opendocument:xmlns:script:1.0\" xmlns:ooo=\"http://openoffice.org/2004/office\" xmlns:ooow=\"http://openoffice.org/2004/writer\" xmlns:oooc=\"http://openoffice.org/2004/calc\" xmlns:dom=\"http://www.w3.org/2001/xml-events\" xmlns:xforms=\"http://www.w3.org/2002/xforms\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" office:version=\"1.0\"><office:scripts/><office:font-face-decls><style:font-face style:name=\"DejaVu Sans\" svg:font-family=\"&apos;DejaVu Sans&apos;\" style:font-family-generic=\"swiss\" style:font-pitch=\"variable\"/><style:font-face style:name=\"DejaVu Sans1\" svg:font-family=\"&apos;DejaVu Sans&apos;\" style:font-family-generic=\"system\" style:font-pitch=\"variable\"/><style:font-face style:name=\"Tahoma\" svg:font-family=\"Tahoma\" style:font-family-generic=\"system\" style:font-pitch=\"variable\"/></office:font-face-decls><office:automatic-styles><style:style style:name=\"co1\" style:family=\"table-column\"><style:table-column-properties fo:break-before=\"auto\" style:column-width=\"2.267cm\"/></style:style><style:style style:name=\"ro1\" style:family=\"table-row\"><style:table-row-properties style:row-height=\"0.474cm\" fo:break-before=\"auto\" style:use-optimal-row-height=\"true\"/></style:style><style:style style:name=\"ro2\" style:family=\"table-row\"><style:table-row-properties style:row-height=\"0.453cm\" fo:break-before=\"auto\" style:use-optimal-row-height=\"true\"/></style:style><style:style style:name=\"ta1\" style:family=\"table\" style:master-page-name=\"Default\"><style:table-properties table:display=\"true\" style:writing-mode=\"lr-tb\"/></style:style></office:automatic-styles><office:body><office:spreadsheet><table:table table:name=\"Hoja1\" table:style-name=\"ta1\" table:print=\"false\">";

  var tabla: String = this.cursor().valueBuffer("nombretabla").left(this.cursor().valueBuffer("nombretabla").length - 4);
  debug("Tabla" + tabla);

  var qryCampos: FLSqlQuery = new FLSqlQuery();
  qryCampos.setTablesList("listadocampos");
  qryCampos.setSelect("campo,alias,tipo,");
  qryCampos.setFrom("listadocampos");
  qryCampos.setWhere("idlistado = " + this.cursor().valueBuffer("id") + " AND incluir = true");
  qryCampos.setOrderBy("indice");

  if (!qryCampos.exec())
    return false;

  var nCampos: Number = qryCampos.size();
  if (nCampos == 0)
    return;

  xml += "<table:table-column table:style-name=\"co1\" table:number-columns-repeated=\"" + nCampos + "\" table:default-cell-style-name=\"Default\"/><table:table-row table:style-name=\"ro1\">";
  var campos: Array = [];
  var tipos: Array = [];
  while (qryCampos.next())
  {
    xml += "<table:table-cell office:value-type=\"string\"><text:p>" + util.utf8(qryCampos.value("alias")) + "</text:p></table:table-cell>";
    campos[campos.length] = qryCampos.value("campo");
    switch (qryCampos.value("tipo")) {
      case "double":
      case "uint":
      case "int":
      case "serial": {
        tipos[tipos.length] = "float";
        break;
      }
      case "stringlist": {
        tipos[tipos.length] = "string";
        break;
      }
      case "bool": {
        tipos[tipos.length] = "boolean";
        break;
      }
      default: {
        tipos[tipos.length] = util.utf8(qryCampos.value("tipo"));
        break;
      }
    }
  }

  xml += "</table:table-row>";

  var qryValores: FLSqlQuery = new FLSqlQuery();
  qryValores.setTablesList(tabla);
  qryValores.setSelect(campos.toString());
  qryValores.setFrom(tabla);
  qryValores.setWhere("1 = 1");
  qryValores.setOrderBy(campos.toString());

  if (!qryValores.exec())
    return false;

  while (qryValores.next())
  {
    xml += "<table:table-row table:style-name=\"ro2\">";
    for (var i = 0; i < nCampos; i++) {
      xml += "<table:table-cell office:value-type=\"" + tipos[i] + "\" office:" + tipos[i] + "-value=\"" + util.utf8(qryValores.value(i)) + "\"><text:p>" + util.utf8(qryValores.value(i)) + "</text:p></table:table-cell>";
    }
    xml += "</table:table-row>";
  }

  xml += "</table:table><table:table table:name=\"Hoja2\" table:style-name=\"ta1\" table:print=\"false\"><table:table-column table:style-name=\"co1\" table:default-cell-style-name=\"Default\"/><table:table-row table:style-name=\"ro2\"><table:table-cell/></table:table-row></table:table><table:table table:name=\"Hoja3\" table:style-name=\"ta1\" table:print=\"false\"><table:table-column table:style-name=\"co1\" table:default-cell-style-name=\"Default\"/><table:table-row table:style-name=\"ro2\"><table:table-cell/></table:table-row></table:table></office:spreadsheet></office:body></office:document-content>";

  return xml;
}

function oficial_exportar()
{
  var util: FLUtil;

  var tabla: String = this.cursor().valueBuffer("nombretabla").left(this.cursor().valueBuffer("nombretabla").length - 4);

  var f = new File(util.readSettingEntry("scripts/flfactinfo/rutaExportacionTablas"));

  var pathPlantilla: String = f.path + "/";

  if (!File.isDir(pathPlantilla)) {
    MessageBox.warning(util.translate("scripts", "No se ha establecido la ruta en disco para la exportación de las tablas\no bien el directorio no existe"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return false;
  }

  var fichPlantilla: String = f.name;

  if (!File.exists(pathPlantilla + fichPlantilla)) {
    MessageBox.warning(util.translate("scripts", "No se encontró la plantilla"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return false;
  }
  if (!fichPlantilla.endsWith(".ods")) {
    MessageBox.warning(util.translate("scripts", "Formato de plantilla incorrecto"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return false;
  }

  var objetoDir = new Dir(pathPlantilla);

  // Ruta a la plantillas
  var pathDestino: String = pathPlantilla + "listados/";
  if (!File.exists(pathDestino))
    objetoDir.mkdir("listados/");

  var pathTmp: String = pathPlantilla + "tmp/";
  if (!File.exists(pathTmp))
    objetoDir.mkdir("tmp/");

  var fichDestino: String = tabla + ".ods";
  if (File.exists(pathDestino + fichDestino)) {
    var res = MessageBox.warning(util.translate("scripts", "Esta tabla ya fue exportada. ¿Desea sobreescribirla?"), MessageBox.Yes, MessageBox.No, MessageBox.NoButton);
    if (res != MessageBox.Yes)
      return false;
  }

  if (File.exists(pathTmp + "content.xml"))
    File.remove(pathTmp + "content.xml");
  if (File.exists(pathDestino + fichDestino))
    File.remove(pathDestino + fichDestino);

  comando = new Array("cp", pathPlantilla + fichPlantilla, pathTmp + fichDestino);
  var proceso = new Process();
  proceso.arguments = comando;
  proceso.workingDirectory = pathTmp;
  try {
    proceso.start();
  } catch (e) {
    MessageBox.critical(comando + "\n\n" + util.translate("scripts", "Falló la ejecución del comando"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }

  while (proceso.running) {
    continue;
  }

  comando = new Array("cp", pathPlantilla + fichPlantilla, pathDestino + fichDestino);
  var proceso = new Process();
  proceso.arguments = comando;
  proceso.workingDirectory = pathTmp;
  try {
    proceso.start();
  } catch (e) {
    MessageBox.critical(comando + "\n\n" + util.translate("scripts", "Falló la ejecución del comando"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }

  while (proceso.running) {
    continue;
  }

  // Obtener el content.xml de la plantilla odt mediante comando unzip
  comando = new Array("unzip", pathTmp + fichDestino, "content.xml");
  var proceso = new Process();
  proceso.arguments = comando;
  proceso.workingDirectory = pathTmp;
  try {
    proceso.start();
  } catch (e) {
    MessageBox.critical(comando + "\n\n" + util.translate("scripts", "Falló la ejecución del comando"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }

  while (proceso.running) {
    continue;
  }

  var xml: String = this.iface.crearXml();
  if (!xml || xml == "")
    return false;

  var nombreFichero = pathTmp + "content.xml";
  var archivo = new File(nombreFichero);
  archivo.open(archivo.WriteOnly);
  archivo.writeLine(xml);
  archivo.close();


  comando = new Array("zip", "-uj", pathDestino + fichDestino, pathTmp + "content.xml");
  proceso.arguments = comando;
  try {
    proceso.start();
  } catch (e) {
    MessageBox.critical(comando + "\n\n" + util.translate("scripts", "Falló la ejecución del comando"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }

  while (proceso.running) {
    continue;
  }

  MessageBox.information(util.translate("scripts", "La tabla %1 ha sido exportada al fichero %2").arg(this.cursor().valueBuffer("nombretabla")).arg(pathDestino + fichDestino), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
