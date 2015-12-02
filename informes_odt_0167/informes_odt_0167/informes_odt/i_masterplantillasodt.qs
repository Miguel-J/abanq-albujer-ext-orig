/***************************************************************************
                 flfactinfo.qs  -  description
                             -------------------
    begin                : lun abr 26 2004
    copyright            : (C) 2004 by InfoSiAL S.L.
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
/////////////////////////////////////////////////////////////////
//// OFICIAL ////////////////////////////////////////////////

class oficial extends interna
{
  var qryOdt: FLSqlQuery;
  var calcTotales: Array;
  var calcParciales: Array;
  var filasDetail: Array;
  var filasFooter: Array;
  var filasHeader: Array;
  var camposNivel: Array;
  var parametros: Array;
  var sep: String = "__";
  var regExpCampo = new RegExp(sep + "[A-Za-z0-9]+" + sep);

  function oficial(context)
  {
    interna(context);
  }
  function generarOdt(cursor: FLSqlCursor, nombreInforme: String, orderBy: String, groupBy: String, etiquetas: Boolean, impDirecta: Boolean, whereFijo: String, nombreReport: String, numCopias: Number, impresora: String)
  {
    return this.ctx.oficial_generarOdt(cursor, nombreInforme, orderBy, groupBy, etiquetas, impDirecta, whereFijo, nombreReport, numCopias, impresora);
  }
  function procesarTextoXML(rutaFichXML: String, nombreInforme: String, procesarLineas: Boolean)
  {
    return this.ctx.oficial_procesarTextoXML(rutaFichXML, nombreInforme, procesarLineas);
  }
  function procesarLineasXML(contenido: String, nombreInforme: String)
  {
    return this.ctx.oficial_procesarLineasXML(contenido, nombreInforme);
  }
  function insertarLineaDetalle(tablaLineas: FLDomNode, ultimaFila: FLDomNode, nivel: Number)
  {
    return this.ctx.oficial_insertarLineaDetalle(tablaLineas, ultimaFila, nivel);
  }
  function insertarLineaFooter(tablaLineas: FLDomNode, ultimaFila: FLDomNode, nivel: Number)
  {
    return this.ctx.oficial_insertarLineaFooter(tablaLineas, ultimaFila, nivel);
  }
  function insertarLineaHeader(tablaLineas: FLDomNode, ultimaFila: FLDomNode, nivel: Number)
  {
    return this.ctx.oficial_insertarLineaHeader(tablaLineas, ultimaFila, nivel);
  }
  function sustituyeDato(cadena1: String, cadena2: String, texto: String): String {
    return this.ctx.oficial_sustituyeDato(cadena1, cadena2, texto);
  }
  function formatoValor(valor, nomCampo: String): String {
    return this.ctx.oficial_formatoValor(valor, nomCampo);
  }
  function procesarTablaXML(tablaLineas: FLDomNode, nombreInforme: String, nivel: Number): FLDomNode {
    return this.ctx.oficial_procesarTablaXML(tablaLineas, nombreInforme, nivel);
  }
  function popularTablasPlantilla(tablaLineas): Boolean {
    return this.ctx.oficial_popularTablasPlantilla(tablaLineas);
  }
  function popularCamposNivel(nombreInforme: String): Boolean {
    return this.ctx.oficial_popularCamposNivel(nombreInforme);
  }
  function popularParametros(nombreInforme: String): Boolean {
    return this.ctx.oficial_popularParametros(nombreInforme);
  }
  function subTotales(fila: FLDomNode, nivel: Number): Boolean {
    return this.ctx.oficial_subTotales(fila, nivel);
  }
}
//// OFICIAL ////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

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
  function pub_generarOdt(cursor: FLSqlCursor, nombreInforme: String, orderBy: String, groupBy: String, etiquetas: Boolean, impDirecta: Boolean, whereFijo: String, nombreReport: String, numCopias: Number, impresora: String)
  {
    return this.generarOdt(cursor, nombreInforme, orderBy, groupBy, etiquetas, impDirecta, whereFijo, nombreReport, numCopias, impresora);
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
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
/////////////////////////////////////////////////////////////////
//// OFICIAL ////////////////////////////////////////////////

function oficial_generarOdt(cursor: FLSqlCursor, nombreInforme: String, orderBy: String, groupBy: String, etiquetas: Boolean, impDirecta: Boolean, whereFijo: String, nombreReport: String, numCopias: Number, impresora: String)
{

  //  return pruebas();


  var util: FLUtil = new FLUtil();

  this.iface.qryOdt = new FLSqlQuery();
  this.iface.qryOdt = flfactinfo.iface.establecerConsulta(cursor, nombreInforme, orderBy, groupBy, whereFijo);

  if (!this.iface.qryOdt.exec()) {
    MessageBox.critical(util.translate("scripts", "Falló la consulta"), MessageBox.Ok, MessageBox.NoButton);
    return;
  } else {
    if (!this.iface.qryOdt.size()) {
      MessageBox.warning(util.translate("scripts", "No hay registros que cumplan los criterios de búsqueda establecidos"), MessageBox.Ok, MessageBox.NoButton);
      return;
    }
  }

  var comando: String;

  // Ruta a las plantillas de documentos
  var pathPlantillas: String = util.readSettingEntry("scripts/flfacturac/rutaOfertasPlantillas");
  if (!File.isDir(pathPlantillas)) {
    MessageBox.warning(util.translate("scripts", "No se ha establecido la ruta en disco a las plantillas de documentos,\no bien el directorio no existe\n\nPuede establecerla en las opciones de informes"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return false;
  }

  pathTmp = util.readSettingEntry("scripts/flfacturac/rutaOfertasTmp");
  if (!File.isDir(pathTmp)) {
    MessageBox.warning(util.translate("scripts", "No se ha establecido la ruta en disco al directorio temporal,\no bien el directorio no existe\n\nPuede establecerla en las opciones de informes"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return false;
  }

  var fichero = util.sqlSelect("i_plantillasodt", "fichero", "informe = '" + nombreInforme + "'");
  if (!fichero) {
    MessageBox.information(util.translate("scripts", "No se encuentra ninguna plantilla con parámetros asociada a este documento"), MessageBox.Ok, MessageBox.NoButton);
    return;
  }

  var fichPlantilla: String = pathPlantillas + fichero;
  if (!File.exists(fichPlantilla)) {
    MessageBox.warning(util.translate("scripts", "No se encontró el fichero de la plantilla"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return false;
  }

  var fichDestino: String = nombreInforme + ".odt";

  var date = new Date();
  var dirTmp: String = util.sha1(sys.idSession());

  var objetoDir = new Dir(pathTmp);
  if (!File.exists(pathTmp + dirTmp))
    objetoDir.mkdir(dirTmp);
  if (!File.exists(pathTmp + dirTmp + "/images"))
    objetoDir.mkdir(dirTmp + "/images");

  pathTmp += dirTmp + "/";

  if (File.exists(pathTmp + "content.xml"))
    File.remove(pathTmp + "content.xml");
  if (File.exists(pathTmp + "styles.xml"))
    File.remove(pathTmp + "styles.xml");
  if (File.exists(pathTmp + fichDestino))
    File.remove(pathTmp + fichDestino);

  // Copiar la plantilla al temporal y al final
  //    util.copyFile(fichPlantilla, pathTmp + fichDestino, false, false);

  // Obtener el content.xml de la plantilla odt mediante comando unzip
  comando = new Array("cp", fichPlantilla, pathTmp + fichDestino);
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
  comando = new Array("unzip", fichDestino, "styles.xml", "content.xml");
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

  this.iface.popularCamposNivel(nombreInforme);
  this.iface.popularParametros(nombreInforme);

  this.iface.procesarTextoXML(pathTmp + "content.xml", nombreInforme, true);
  this.iface.procesarTextoXML(pathTmp + "styles.xml", nombreInforme);

  comando = new Array("zip", "-uj", pathTmp + fichDestino, pathTmp + "content.xml", pathTmp + "styles.xml");
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

  var comandoOOW: String = util.readSettingEntry("scripts/flfacturac/comandoWriter");
  if (!comandoOOW) {
    MessageBox.warning(util.translate("scripts", "No se ha establecido el comando de OpenOffice de documentos de texto\nPuede establecerlo en las opciones de informes"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return;
  }

  comando = new Array(comandoOOW, "-view", pathTmp + fichDestino);
  proceso.arguments = comando;
  try {
    proceso.start();
  } catch (e) {
    MessageBox.critical(comando + "\n\n" + util.translate("scripts", "Falló la ejecución del comando"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
}


function oficial_procesarTextoXML(rutaFichXML: String, nombreInforme: String, procesarLineas: Boolean)
{
  var util: FLUtil = new FLUtil();

  var fichXML = new File(rutaFichXML);
  fichXML.open(File.ReadOnly);
  var contenido: String = fichXML.read();
  fichXML.close();


  if (procesarLineas)
    contenido = this.iface.procesarLineasXML(contenido, nombreInforme);

  this.iface.qryOdt.exec();
  if (!this.iface.qryOdt.first())
    return;

  debug("101");

  // Datos globales del informe
  var contenidoAOR: String = util.sqlSelect("flfiles", "contenido", "nombre = '" + nombreInforme + ".aor.kut'");
  var nombre: String;

  var xmlCampos = new FLDomDocument();
  xmlCampos.setContent(contenidoAOR);

  listaCampos = xmlCampos.elementsByTagName("field");
  debug("T1");
  for (var i = 0; i < listaCampos.length(); i++) {

    debug("T12");
    campo = listaCampos.item(i);
    nombre = campo.namedItem("name").toElement().text();
    queryname = campo.namedItem("queryname").toElement().text();

    calculation = "";
    if (campo.namedItem("calculation"))
      calculation = campo.namedItem("calculation").toElement().text();

    switch (calculation) {
      case "sum":
        valor = this.iface.calcTotales[nombre];
        break;

      default:
        valor = this.iface.qryOdt.value(queryname);
    }

    debug("T13");
    valor = this.iface.formatoValor(valor, nombre);
    debug("T14");
    valor = util.utf8(valor);
    debug("T15");
    contenido = this.iface.sustituyeDato(this.iface.sep + nombre + this.iface.sep, valor, contenido);
    debug("T16");
  }

  File.write(rutaFichXML, contenido);
}


function oficial_procesarLineasXML(contenido: String, nombreInforme: String)
{
  var util: FLUtil = new FLUtil();

  var xmlTabla = new FLDomDocument();
  xmlTabla.setContent(contenido);

  this.iface.popularTablasPlantilla(xmlTabla);

  var tablaLineas: FLDomNode;

  listaTablas = xmlTabla.elementsByTagName("table:table");
  if (!listaTablas)
    return contenido;

  var esta: Boolean = false;

  // Recorrido por todas las tablas del documento. Buscamos la del nivel 1
  for (var iT = 0; iT < listaTablas.length(); iT++) {
    tablaLineas = listaTablas.item(iT);
    if (tablaLineas.attributeValue("table:name") == "Detail1") {
      esta = true;
      break;
    }
  }

  if (!esta)
    return contenido;

  this.iface.procesarTablaXML(tablaLineas, nombreInforme, 1);

  contenido = xmlTabla.toString();
  return contenido;
}


function oficial_procesarTablaXML(tablaLineas: FLDomNode, nombreInforme: String, nivel: Number)
{
  var util: FLUtil = new FLUtil();

  var listaFilas: FLDomNodeList;
  var filaReferencia: FLDomNode, ultimaFila: FLDomNode;

  listaFilas = tablaLineas.childNodes();

  // Buscamos la fila
  for (var iF = 0; iF < listaFilas.length(); iF++) {
    if (listaFilas.item(iF).nodeName() != "table:table-row")
      continue;
    filaReferencia = listaFilas.item(iF);
    break;
  }

  ultimaFila = filaReferencia;
  ultimoCampoNivel = "";

  util.createProgressDialog(util.translate("scripts", "Procesando informe"), this.iface.qryOdt.size());
  util.setProgress(1);
  var paso: Number = 0;

  // Recorrer las filas de la query e introducir los nodos en la tabla

  // Dos niveles
  if (this.iface.camposNivel.length) {

    while (this.iface.qryOdt.next()) {

      util.setProgress(paso++);

      if (!ultimoCampoNivel)
        ultimoCampoNivel = this.iface.qryOdt.value(this.iface.camposNivel[nivel - 1]);

      // Detalle 1
      ultimaFila = this.iface.insertarLineaDetalle(tablaLineas, ultimaFila, nivel);

      // Encabezado 2
      ultimaFila = this.iface.insertarLineaHeader(tablaLineas, ultimaFila, nivel + 1);

      // Detalle 2
      ultimaFila = this.iface.insertarLineaDetalle(tablaLineas, ultimaFila, nivel + 1);

      while (this.iface.qryOdt.next()) {

        if (this.iface.qryOdt.value(this.iface.camposNivel[nivel - 1]) != ultimoCampoNivel) {
          ultimoCampoNivel = this.iface.qryOdt.value(this.iface.camposNivel[nivel - 1]);
          this.iface.qryOdt.prev();
          break;
        }

        // + Detalles 2
        ultimaFila = this.iface.insertarLineaDetalle(tablaLineas, ultimaFila, nivel + 1);
        util.setProgress(paso++);
      }

      // Pie 2
      ultimaFila = this.iface.insertarLineaFooter(tablaLineas, ultimaFila, nivel + 1);
    }
  }

  // Un nivel
  else
    while (this.iface.qryOdt.next()) {
      ultimaFila = this.iface.insertarLineaDetalle(tablaLineas, ultimaFila, nivel);
      util.setProgress(paso++);
    }

  this.iface.insertarLineaFooter(tablaLineas, ultimaFila, nivel);
  tablaLineas.removeChild(filaReferencia);

  util.destroyProgressDialog();
  return true;
}

function oficial_insertarLineaDetalle(tablaLineas: FLDomNode, ultimaFila: FLDomNode, nivel: Number)
{
  var util: FLUtil = new FLUtil();
  var filaDetalle, filaNueva: FLDomNode;

  debug("L1");

  filaDetalle = this.iface.filasDetail[nivel - 1];
  filaNueva = filaDetalle.cloneNode(true);

  listaCeldas = filaNueva.childNodes();

  debug("L2");

  for (var iC = 0; iC < listaCeldas.length(); iC++) {

    debug("L3");
    if (this.iface.regExpCampo.search(listaCeldas.item(iC).toElement().text()) == -1)
      continue;

    nomCampo = listaCeldas.item(iC).firstChild().firstChild().nodeValue();

    debug("L31");

    if (this.iface.regExpCampo.search(nomCampo) == -1)
      continue;

    nomCampo = this.iface.sustituyeDato(this.iface.sep, "", nomCampo);

    debug("L32");
    valor = this.iface.qryOdt.value(this.iface.parametros[nomCampo]["queryname"]);

    if (!valor && this.iface.parametros[nomCampo]["blankzero"])
      return ultimaFila;

    debug("L33");

    switch (this.iface.parametros[nomCampo]["calculation"]) {
      case "sum":
        this.iface.calcTotales[nomCampo] += parseFloat(valor);
        this.iface.calcParciales[nomCampo] += parseFloat(valor);
        break;
    }

    debug("L34");

    valor = this.iface.formatoValor(valor, nomCampo);
    debug("L35");
    valor = util.utf8(valor);

    debug("L36 - " + valor);
    listaCeldas.item(iC).firstChild().firstChild().setNodeValue(valor);
  }

  tablaLineas.insertAfter(filaNueva, ultimaFila);
  return filaNueva;
}


function oficial_insertarLineaFooter(tablaLineas: FLDomNode, ultimaFila: FLDomNode, nivel: Number)
{
  var util: FLUtil = new FLUtil();
  var filaFooter, filaNueva: FLDomNode;

  debug("Footer nivel " + nivel);
  filaFooter = this.iface.filasFooter[nivel - 1];
  if (!filaFooter)
    return ultimaFila;

  filaNueva = filaFooter.cloneNode(true);
  debug(filaNueva.toElement().text())

  listaCeldas = filaNueva.childNodes();

  for (var iC = 0; iC < listaCeldas.length(); iC++) {

    debug("001");

    if (!listaCeldas.item(iC).hasChildNodes())
      continue;
    if (!listaCeldas.item(iC).firstChild().hasChildNodes())
      continue;

    debug("002");
    nomCampo = listaCeldas.item(iC).firstChild().firstChild().nodeValue();
    if (!nomCampo)
      continue;

    if (this.iface.regExpCampo.search(nomCampo) == -1)
      continue;

    debug("003");
    nomCampo = this.iface.sustituyeDato(this.iface.sep, "", nomCampo);

    valor = this.iface.qryOdt.value(this.iface.parametros[nomCampo]["queryname"]);

    if (!valor && this.iface.parametros[nomCampo]["blankzero"])
      return ultimaFila;

    switch (this.iface.parametros[nomCampo]["calculation"]) {
      case "sum":
        if (nivel == 1)
          valor = this.iface.calcTotales[nomCampo];
        else {
          valor = this.iface.calcParciales[nomCampo];
          this.iface.calcParciales[nomCampo] = 0;
        }
        break;
    }

    debug("004");
    valor = this.iface.formatoValor(valor, nomCampo);
    valor = util.utf8(valor);

    debug("005");
    listaCeldas.item(iC).firstChild().firstChild().setNodeValue(valor);
    debug("006");
  }

  debug("007");
  tablaLineas.insertAfter(filaNueva, ultimaFila);
  debug("008");
  return filaNueva;
}


function oficial_insertarLineaHeader(tablaLineas: FLDomNode, ultimaFila: FLDomNode, nivel: Number)
{
  var util: FLUtil = new FLUtil();
  var filaHeader, filaNueva: FLDomNode;

  debug("Hader nivel " + nivel);
  filaHeader = this.iface.filasHeader[nivel - 1];
  if (!filaHeader)
    return ultimaFila;

  filaNueva = filaHeader.cloneNode(true);
  debug(filaNueva.toElement().text())

  listaCeldas = filaNueva.childNodes();

  for (var iC = 0; iC < listaCeldas.length(); iC++) {

    if (!listaCeldas.item(iC).hasChildNodes())
      continue;
    if (!listaCeldas.item(iC).firstChild().hasChildNodes())
      continue;

    nomCampo = listaCeldas.item(iC).firstChild().firstChild().nodeValue();
    if (!nomCampo)
      continue;

    if (this.iface.regExpCampo.search(nomCampo) == -1)
      continue;

    nomCampo = this.iface.sustituyeDato(this.iface.sep, "", nomCampo);

    valor = this.iface.qryOdt.value(this.iface.parametros[nomCampo]["queryname"]);

    switch (this.iface.parametros[nomCampo]["calculation"]) {
      case "sum":
        if (nivel == 1)
          valor = this.iface.calcTotales[nomCampo];
        else {
          valor = this.iface.calcParciales[nomCampo];
          this.iface.calcParciales[nomCampo] = 0;
        }
        break;
    }

    valor = this.iface.formatoValor(valor, nomCampo);
    valor = util.utf8(valor);

    listaCeldas.item(iC).firstChild().firstChild().setNodeValue(valor);
  }

  tablaLineas.insertAfter(filaNueva, ultimaFila);
  return filaNueva;
}



function oficial_popularTablasPlantilla(xmlTabla)
{
  var tablaLineas: FLDomNode;

  this.iface.filasDetail = [];
  this.iface.filasFooter = [];
  this.iface.filasHeader = [];

  listaTablas = xmlTabla.elementsByTagName("table:table");
  if (!listaTablas)
    return false;

  // Buscamos hasta 5 niveles
  for (var nivel: Number = 1; nivel <= 5; nivel++) {

    this.iface.filasDetail[nivel - 1] = "";
    this.iface.filasHeader[nivel - 1] = "";
    this.iface.filasFooter[nivel - 1] = "";

    // Recorrido por todas las tablas del documento. Buscamos la del nivel por nombre
    for (var iT = 0; iT < listaTablas.length(); iT++) {

      tabla = listaTablas.item(iT);
      listaFilas = tabla.childNodes();

      switch (tabla.attributeValue("table:name")) {
        case "Detail" + nivel:

          // Buscamos la fila
          for (var iF = 0; iF < listaFilas.length(); iF++) {
            if (listaFilas.item(iF).nodeName() != "table:table-row") continue;
            this.iface.filasDetail[nivel - 1] = listaFilas.item(iF);
            if (nivel > 1) tabla.removeChild(listaFilas.item(iF));
          }


          break;

        case "Footer" + nivel:

          // Buscamos la fila
          for (var iF = 0; iF < listaFilas.length(); iF++) {
            if (listaFilas.item(iF).nodeName() != "table:table-row") continue;
            this.iface.filasFooter[nivel - 1] = listaFilas.item(iF);
            tabla.removeChild(listaFilas.item(iF));
          }
          break;

        case "Header" + nivel:

          // Buscamos la fila
          for (var iF = 0; iF < listaFilas.length(); iF++) {
            if (listaFilas.item(iF).nodeName() != "table:table-row") continue;
            this.iface.filasHeader[nivel - 1] = listaFilas.item(iF);
            tabla.removeChild(listaFilas.item(iF));
          }
          break;

      }

    }

  }

  return true;
}



function oficial_popularCamposNivel(nombreInforme: String)
{
  var util: FLUtil = new FLUtil();
  this.iface.camposNivel = [];

  var agrupacion: String = util.sqlSelect("i_plantillasodt", "agrupacion", "informe = '" + nombreInforme + "'", "");

  if (!agrupacion)
    return;

  this.iface.camposNivel = agrupacion.split(",");
}


function oficial_formatoValor(valor, nomCampo: String): String {
  var util: FLUtil = new FLUtil();
  switch (this.iface.parametros[nomCampo]["type"])
  {
    case "number":
      valor = util.formatoMiles(util.buildNumber(valor, "f", this.iface.parametros[nomCampo]["partD"]));
      break;
    case "date":
      valor = valor.toString().left(10);
      valor = util.dateAMDtoDMA(valor);
      break;
  }
  return valor;
}

function oficial_sustituyeDato(cadena1: String, cadena2: String, texto: String): String {
  var regExp: RegExp = new RegExp(cadena1);
  regExp.global = true;
  texto = texto.replace(regExp, cadena2);

  return texto;
}

/** \D Cargamos los parámetros y sus características en un array global
para utilizarlos más ágilmente en todas las filas del informe
*/
function oficial_popularParametros(nombreInforme: String)
{
  var util: FLUtil = new FLUtil();
  var contenidoAOR: String = util.sqlSelect("flfiles", "contenido", "nombre = '" + nombreInforme + ".aor.kut'");

  if (!contenidoAOR) {
    MessageBox.critical(util.translate("scripts", "No se encontró el fichero de definición de parámetros para este informe"), MessageBox.Ok, MessageBox.NoButton);
    return;
  }

  var nombre: String;
  this.iface.parametros = [];

  var xmlCampos = new FLDomDocument();
  xmlCampos.setContent(contenidoAOR);

  listaCampos = xmlCampos.elementsByTagName("field");
  var propiedades = new Array("queryname", "type", "partD", "calculation", "blankzero");

  this.iface.calcTotales = [];
  this.iface.calcParciales = [];

  for (var i = 0; i < listaCampos.length(); i++) {

    campo = listaCampos.item(i);
    debug("+++++++++++++ " + nombre);

    nombre = campo.namedItem("name").toElement().text();
    this.iface.parametros[nombre] = new Array(propiedades.length);

    for (j = 0; j < propiedades.length; j++) {
      propiedad = propiedades[j];
      if (campo.namedItem(propiedad))
        this.iface.parametros[nombre][propiedad] = campo.namedItem(propiedad).toElement().text();
      else
        this.iface.parametros[nombre][propiedad] = "";

      debug(propiedad + " " + this.iface.parametros[nombre][propiedad]);
    }

    this.iface.calcTotales[nombre] = 0
                                     this.iface.calcParciales[nombre] = 0
  }
}


                                                                    function pruebas()
{
  var xmlDoc = new FLDomDocument();

  contenido = "";

  contenido += "<table>";
  contenido += "<tr>";
  contenido += "<td>cell11</td>";
  contenido += "<td>cell12</td>";
  contenido += "</tr>";
  contenido += "<tr>";
  contenido += "<td>cell21</td>";
  contenido += "<td>cell22</td>";
  contenido += "</tr>";
  contenido += "</table>";

  xmlDoc.setContent(contenido);
  listaTablas = xmlDoc.elementsByTagName("table");

  nodoTabla = listaTablas.item(0);

  nodoFila = nodoTabla.firstChild();

  textoFila = nodoFila.getText();
  debug(textoFila);

}

//// OFICIAL ////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////


/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
////////////////////////////////////////////////////////////////