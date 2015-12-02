
/** @class_declaration presOferta */
/////////////////////////////////////////////////////////////////
//// PRES_OFERTA //////////////////////////////////////////////
class presOferta extends oficial
{
  function presOferta(context)
  {
    oficial(context);
  }
  function init()
  {
    this.ctx.presOferta_init();
  }
  function imprimirOferta(cursor: FLSqlCursor)
  {
    return this.ctx.presOferta_imprimirOferta(cursor);
  }
  function generarOferta(cursor: FLSqlCursor)
  {
    return this.ctx.presOferta_generarOferta(cursor);
  }
  function cargarDatos(contenido: String): String {
    return this.ctx.presOferta_cargarDatos(contenido);
  }
  function sustituyeDato(cadena1: String, cadena2: String, texto: String): String {
    return this.ctx.presOferta_sustituyeDato(cadena1, cadena2, texto);
  }
  function procesarLineasPresupuesto(rutaFichXML: String, cursor: FLSqlCursor, contenido: String)
  {
    return this.ctx.presOferta_procesarLineasPresupuesto(rutaFichXML, cursor, contenido);
  }
  function wherePresupuesto(): String  {
    return this.ctx.presOferta_wherePresupuesto();
  }
  function informarArrayParamPre(): Array {
    return this.ctx.presOferta_informarArrayParamPre();
  }
  function informarArrayParamCli(): Array {
    return this.ctx.presOferta_informarArrayParamCli();
  }
  function sustituirOtrosDatos(contenido: String, cursor: FLSqlCursor): String {
    return this.ctx.presOferta_sustituirOtrosDatos(contenido, cursor);
  }
  function sustituirDatosPresupuesto(contenido: String, cursor: FLSqlCursor): String {
    return this.ctx.presOferta_sustituirDatosPresupuesto(contenido, cursor);
  }
  function sustituirDatosCliente(contenido: String, cursor: FLSqlCursor): String {
    return this.ctx.presOferta_sustituirDatosCliente(contenido, cursor);
  }
  function formatearDatoPres(dato: String, tipo: String, campo: String, tabla: String): String {
    return this.ctx.presOferta_formatearDatoPres(dato, tipo, campo, tabla);
  }
  function mensajeOtrosDatos(): String {
    return this.ctx.presOferta_mensajeOtrosDatos();
  }
  function mensajeDatosPres(): String {
    return this.ctx.presOferta_mensajeDatosPres();
  }
  function mensajeDatosCliente(): String {
    return this.ctx.presOferta_mensajeDatosCliente();
  }
}
//// PRES_OFERTA //////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pubPresOferta */
/////////////////////////////////////////////////////////////////
//// PUB_PRESOFERTA /////////////////////////////////////////////
class pubPresOferta extends head
{
  function pubPresOferta(context)
  {
    head(context);
  }
  function pub_mensajeOtrosDatos(): String {
    return this.mensajeOtrosDatos();
  }
}
//// PUB_PRESOFERTA /////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition presOferta */
/////////////////////////////////////////////////////////////////
//// PRES_OFERTA //////////////////////////////////////////////

function presOferta_init()
{
  this.iface.__init();
  connect(this.child("toolButtonGenerarOferta"), "clicked()", this, "iface.generarOferta");
  connect(this.child("toolButtonPrintOferta"), "clicked()", this, "iface.imprimirOferta");
}


function presOferta_generarOferta(cursor: FLSqlCursor)
{
  if (!cursor) cursor = this.cursor();
  if (!cursor.isValid())
    return;

  var util: FLUtil = new FLUtil();
  var comando: String;
  var oSys: String = util.getOS();

  if (!cursor.valueBuffer("fichplantilla")) {
    MessageBox.warning(util.translate("scripts", "No se ha establecido la plantilla para este presupuesto"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return;
  }

  // Ruta a los documentos de pacientes
  var pathDocumentos: String = util.readSettingEntry("scripts/fllaboppal/pathDocumentos");
  pathDocumentos = util.readSettingEntry("scripts/flfacturac/rutaOfertasOfertas");
  if (!File.isDir(pathDocumentos)) {
    MessageBox.warning(util.translate("scripts", "No se ha establecido la ruta en disco a los documentos,\no bien el directorio no existe\n\nPuede establecerla en las opciones de informes"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return false;
  }

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

  var fichPlantilla: String = pathPlantillas + cursor.valueBuffer("fichplantilla");
  if (!File.exists(fichPlantilla)) {
    MessageBox.warning(util.translate("scripts", "No se encontró la plantilla"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return false;
  }

  var fichDestino: String = "oferta_" + cursor.valueBuffer("codigo") + ".odt";
  if (File.exists(pathDocumentos + fichDestino)) {
    var res = MessageBox.warning(util.translate("scripts", "Esta oferta ya fue generada. ¿Desea sobreescribirla?"), MessageBox.Yes, MessageBox.No, MessageBox.NoButton);
    if (res != MessageBox.Yes)
      return false;
  }

  var date = new Date();
  var dirTmp: String = util.sha1(sys.idSession());

  var objetoDir = new Dir(pathTmp);

  if (File.exists(pathTmp + dirTmp))
    objetoDir.rmdirs(dirTmp);

  if (!File.exists(pathTmp + dirTmp))
    objetoDir.mkdir(dirTmp);
  if (!File.exists(pathTmp + dirTmp + "/images"))
    objetoDir.mkdir(dirTmp + "/images");

  pathTmp += dirTmp + "/";

  if (File.exists(pathTmp + "content.xml"))
    File.remove(pathTmp + "content.xml");
  if (File.exists(pathTmp + fichDestino))
    File.remove(pathTmp + fichDestino);

  // Copiar la plantilla al temporal y al final
  //  sys.copyFile(fichPlantilla, pathTmp + fichDestino);
  //  sys.copyFile(fichPlantilla, pathDocumentos + fichDestino);

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

  if (File.exists(pathDocumentos + fichDestino))
    File.remove(pathDocumentos + fichDestino);

  comando = new Array("cp", fichPlantilla, pathDocumentos + fichDestino);
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
  comando = new Array("unzip", fichDestino, "content.xml");
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

  var contenido: String = File.read(pathTmp + "content.xml");
  if (util.readSettingEntry("scripts/flfacturac/encodingLocal") == "UTF")
    contenido = sys.toUnicode(contenido, "utf8");

  // Cargar los datos del informe y copiar las imágenes
  var curTab: FLSqlCursor = new FLSqlCursor("parampresupuesto");
  curTab.select("idpresupuesto = " + cursor.valueBuffer("idpresupuesto"));
  var paso: Number = 0;

  while (curTab.next()) {

    codParametro = curTab.valueBuffer("codparametro");
    clave = "__" + codParametro + "__";

    if (util.sqlSelect("paraminforme", "tipo", "codigo = '" + codParametro + "'") == "Imagen") {

      fichImagen = curTab.valueBuffer("valor");
      fichObjeto = new File(fichImagen);

      if (!File.exists(fichImagen))
        continue;

      // Copiar imagenes
      // sys.copyFile(fichImagen, pathTmp + "images");
      comando = new Array("cp", fichImagen, pathTmp + "images");
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

      objetoImg = new Pixmap(fichImagen);
      ancho = objetoImg.width / 50;
      alto = objetoImg.height / 50;

      valor = "<draw:frame draw:name=\"grafico" + paso + "\" text:anchor-type=\"paragraph\" draw:z-index=\"0\" svg:width=\"" + ancho + "cm\" svg:height=\"" + alto + "cm\">";
      valor += "<draw:image xlink:href=\"images/" + fichObjeto.name + "\" xlink:type=\"simple\" xlink:show=\"embed\" xlink:actuate=\"onLoad\"/>";
      valor += "</draw:frame>";

      paso++;
    } else {
      valor = curTab.valueBuffer("valor");
      if (util.readSettingEntry("scripts/flfacturac/encodingLocal") == "ISO")
        valor = util.utf8(valor);
    }

    contenido = this.iface.sustituyeDato(clave, valor, contenido);
  }

  contenido = this.iface.sustituirOtrosDatos(contenido, cursor);

  // Volcar el nuevo contenido a content_xxxxx.xml
  File.write(pathTmp + "content.xml", contenido);

  // Meter las líneas de presupuesto en la tabla si corresponde
  this.iface.procesarLineasPresupuesto(pathTmp + "content.xml", cursor);

  comando = new Array("zip", "-uj", pathDocumentos + fichDestino, pathTmp + "content.xml");
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

  comando = new Array("zip", "-r", pathDocumentos + fichDestino, "images");
  proceso.workingDirectory = pathTmp;
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

  res = MessageBox.information(util.translate("scripts", "Se creó el documento de oferta\n¿Desea abrirlo?"), MessageBox.Yes, MessageBox.No, MessageBox.NoButton);
  if (res == MessageBox.Yes) {
    var comandoOOW: String = util.readSettingEntry("scripts/flfacturac/comandoWriter");
    if (!comandoOOW) {
      MessageBox.warning(util.translate("scripts", "No se ha establecido el comando de OpenOffice de documentos de texto\nPuede establecerlo en las opciones de informes"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
      return;
    }

    comando = new Array(comandoOOW, pathDocumentos + fichDestino);
    proceso.arguments = comando;
    try {
      proceso.start();
    } catch (e) {
      MessageBox.critical(comando + "\n\n" + util.translate("scripts", "Falló la ejecución del comando"), MessageBox.Ok, MessageBox.NoButton);
      return false;
    }
  }
}

function presOferta_sustituirOtrosDatos(contenido: String, cursor: FLSqlCursor): String {
  var contProcesado: String = contenido;
  contProcesado = this.iface.sustituirDatosPresupuesto(contProcesado, cursor);
  if (!contProcesado)
  {
    return false;
  }
  contProcesado = this.iface.sustituirDatosCliente(contProcesado, cursor);
  if (!contProcesado)
  {
    return false;
  }
  return contProcesado;
}

function presOferta_sustituirDatosPresupuesto(contenido: String, cursor: FLSqlCursor): String {
  var contProcesado: String = contenido;
  var paramPre: Array = this.iface.informarArrayParamPre();
  var i: Number;
  var dato: String;
  var clave: String;
  for (i = 0; i < paramPre.length; i++)
  {
    clave = "__" + paramPre[i][0] + "__";
    if (cursor.valueBuffer(paramPre[i][0])) {
      dato = cursor.valueBuffer(paramPre[i][0]);
      dato = this.iface.formatearDatoPres(dato, paramPre[i][2], paramPre[i][0], "presupuestoscli");
      contProcesado = this.iface.sustituyeDato(clave, dato, contProcesado);
    } else {
      contProcesado = this.iface.sustituyeDato(clave, "", contProcesado);
    }
  }
  return contProcesado;
}

function presOferta_sustituirDatosCliente(contenido: String, cursor: FLSqlCursor): String {
  var contProcesado: String = contenido;
  var i: Number;
  var dato: String;
  var clave: String;
  var paramCli: Array = this.iface.informarArrayParamCli();
  var miSelect: String = "";
  var arrayMiSelect: Array = [];
  for (var i: Number; i < paramCli.length; i++)
  {
    arrayMiSelect[i] = paramCli[i][0];
  }
  miSelect = arrayMiSelect.join(",");

  var q: FLSqlQuery = new FLSqlQuery;
  q.setTablesList("clientes");
  q.setSelect(miSelect);
  q.setFrom("clientes");
  q.setWhere("codcliente = '" + cursor.valueBuffer("codcliente") + "'");
  q.setForwardOnly(true);
  if (!q.exec())
  {
    return false;
  }
  if (!q.first())
  {
    return contProcesado;
  }

  for (i = 0; i < paramCli.length; i++)
  {
    clave = "__" + paramCli[i][0] + "__";
    if (q.value(paramCli[i][0])) {
      dato = q.value(paramCli[i][0]);
      dato = this.iface.formatearDatoPres(dato, paramCli[i][2], paramCli[i][0], "presupuestoscli");
      contProcesado = this.iface.sustituyeDato(clave, dato, contProcesado);
    } else {
      contProcesado = this.iface.sustituyeDato(clave, "", contProcesado);
    }
  }
  return contProcesado;
}

function presOferta_formatearDatoPres(dato: String, tipo: String, campo: String, tabla: String): String {
  debug("Formateando " + dato + " tipo " + tipo + " campo " + campo + " tabla " + tabla);
  var util: FLUtil = new FLUtil;
  var valor: String;
  switch (tipo)
  {
    case "double": {
      valor = util.roundFieldValue(dato, tabla, campo);
      break;
    }
    case "date": {
      valor = util.dateAMDtoDMA(dato);
      break;
    }
    case "bool": {
      if (dato) {
        valor = util.translate("scripts", "Sí");
      } else {
        valor = util.translate("scripts", "No");
      }
      break;
    }
    default: {
      valor = dato;
    }
  }
  debug("Valor = " + valor);
  return valor;
}

function presOferta_sustituyeDato(cadena1: String, cadena2: String, texto: String): String {
  var regExp: RegExp = new RegExp(cadena1);
  regExp.global = true;
  texto = texto.replace(regExp, cadena2);

  return texto;
}


function presOferta_procesarLineasPresupuesto(rutaFichXML: String, cursor: FLSqlCursor, contenido: String)
{
  if (!cursor) cursor = this.cursor();
  var util: FLUtil = new FLUtil();

  var fichXML = new File(rutaFichXML);
  fichXML.open(File.ReadOnly);
  var xmlTabla = new FLDomDocument();

  if (!contenido) {
    contenido = fichXML.read();
    if (util.readSettingEntry("scripts/flfacturac/encodingLocal") == "UTF")
      contenido = sys.toUnicode(contenido, "utf8");
  }

  xmlTabla.setContent(contenido);
  fichXML.close();

  var fila: String;
  var listaFilas: FLDomNodeList;
  var listaCeldas: FLDomNodeList;
  var tablaPresupuesto: FLDomNode;
  var filaReferencia: FLDomNode;

  listaTablas = xmlTabla.elementsByTagName("table:table");
  if (!listaTablas)
    return;

  // Recorrido por todas las tablas del documento
  for (var iT = 0; iT < listaTablas.length(); iT++) {

    tablaPresupuesto = listaTablas.item(iT);
    listaFilas = tablaPresupuesto.childNodes();

    // Buscamos la fila de referencia
    for (var iF = 0; iF < listaFilas.length(); iF++) {

      if (listaFilas.item(iF).nodeName() != "table:table-row")
        continue;

      if (listaFilas.item(iF).toElement().text().search("__referencia__") > -1) {
        filaReferencia = listaFilas.item(iF);
        break;
      }
    }

    // Encontrado?
    if (filaReferencia.hasChildNodes())
      break;
  }

  if (!filaReferencia.hasChildNodes())
    return;

  var curTab: FLSqlCursor = new FLSqlCursor("lineaspresupuestoscli");
  var where: String = this.iface.wherePresupuesto();
  curTab.select(where);
  while (curTab.next()) {
    filaNueva = filaReferencia.cloneNode(true);
    listaCeldas = filaNueva.childNodes();
    for (var iC = 0; iC < listaCeldas.length(); iC++) {

      if (!listaCeldas.item(iC).hasChildNodes())
        continue;
      if (!listaCeldas.item(iC).firstChild().hasChildNodes())
        continue;

      switch (listaCeldas.item(iC).firstChild().firstChild().nodeValue()) {

        case "__referencia__":
          valor = curTab.valueBuffer("referencia");
          break;

        case "__cantidad__":
          valor = curTab.valueBuffer("cantidad");
          break;

        case "__descripcion__":
          valor = curTab.valueBuffer("descripcion");
          break;

        case "__pvpunitario__":
          valor = curTab.valueBuffer("pvpunitario");
          valor = util.formatoMiles(util.buildNumber(valor, "f", 2));
          break;

        case "__pvpsindto__":
          valor = curTab.valueBuffer("pvpsindto");
          valor = util.formatoMiles(util.buildNumber(valor, "f", 2));
          break;

        case "__iva__":
          valor = curTab.valueBuffer("iva");
          valor = util.formatoMiles(util.buildNumber(valor, "f", 2));
          break;

        case "__dtopor__":
          valor = curTab.valueBuffer("dtopor");
          valor = util.formatoMiles(util.buildNumber(valor, "f", 2)) + "%";
          break;

        case "__pvptotal__":
          valor = curTab.valueBuffer("pvptotal");
          valor = util.formatoMiles(util.buildNumber(valor, "f", 2));
          break;

        default:
          continue;
      }

      if (util.readSettingEntry("scripts/flfacturac/encodingLocal") == "ISO")
        valor = util.utf8(valor);
      listaCeldas.item(iC).firstChild().firstChild().setNodeValue(valor);
    }

    tablaPresupuesto.insertAfter(filaNueva, filaReferencia);
  }

  tablaPresupuesto.removeChild(filaReferencia);

  var contenido: String = xmlTabla.toString();

  // Totales
  contenido = this.iface.sustituyeDato("__total_base__", util.formatoMiles(cursor.valueBuffer("neto")), contenido);
  contenido = this.iface.sustituyeDato("__total_iva__", util.formatoMiles(cursor.valueBuffer("totaliva")), contenido);
  contenido = this.iface.sustituyeDato("__total_total__", util.formatoMiles(cursor.valueBuffer("total")), contenido);

  File.write(rutaFichXML, contenido);
}

function presOferta_wherePresupuesto(): String {
  var cursor: FLSqlCursor = this.cursor();
  var where: String = "idpresupuesto = " + cursor.valueBuffer("idpresupuesto");
  return where;
}

function presOferta_imprimirOferta(cursor: FLSqlCursor)
{
  if (!cursor) cursor = this.cursor();

  if (!cursor.isValid())
    return;

  var util: FLUtil = new FLUtil();

  // Ruta a los documentos de pacientes
  var pathDocumentos: String = util.readSettingEntry("scripts/fllaboppal/pathDocumentos");
  pathDocumentos = util.readSettingEntry("scripts/flfacturac/rutaOfertasOfertas");
  if (!File.isDir(pathDocumentos)) {
    MessageBox.warning(util.translate("scripts", "No se ha establecido la ruta en disco a los documentos,\no bien el directorio no existe\n\nPuede establecerla en las opciones de informes"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return false;
  }

  var fichDestino: String = "oferta_" + cursor.valueBuffer("codigo") + ".odt";
  if (!File.exists(pathDocumentos + fichDestino)) {
    MessageBox.warning(util.translate("scripts", "No existe el fichero de esta oferta. Deberá generarlo"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return false;
  }

  var comandoOOW: String = util.readSettingEntry("scripts/flfacturac/comandoWriter");
  if (!comandoOOW) {
    MessageBox.warning(util.translate("scripts", "No se ha establecido el comando de OpenOffice de documentos de texto\nPuede establecerlo en las opciones de informes"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return;
  }

  var proceso = new Process();
  comando = new Array(comandoOOW, pathDocumentos + fichDestino);
  proceso.arguments = comando;
  try {
    proceso.start();
  } catch (e) {
    MessageBox.critical(comando + "\n\n" + util.translate("scripts", "Falló la ejecución del comando"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
}

function presOferta_informarArrayParamPre(): Array {
  var util: FLUtil = new FLUtil();
  var array: Array = [["nombrecliente", util.translate("scripts", "Nombre del cliente"), "string"],
  ["cifnif", util.translate("scripts", "NIF"), "string"],
  ["direccion", util.translate("scripts", "Dirección"), "string"],
  ["codpostal", util.translate("scripts", "Cod.Postal"), "string"],
  ["ciudad", util.translate("scripts", "Ciudad"), "string"],
  ["provincia", util.translate("scripts", "Provincia"), "string"],
  ["codpais", util.translate("scripts", "País"), "string"],
  ["numero", util.translate("scripts", "Número"), "string"],
  ["fecha", util.translate("scripts", "Fecha"), "date"],
  ["neto", util.translate("scripts", "Neto"), "double"],
  ["totaliva", util.translate("scripts", "I.V.A."), "double"],
  ["total", util.translate("scripts", "Total"), "double"]];
  return array;
}

function presOferta_informarArrayParamCli(): Array {
  var util: FLUtil = new FLUtil();
  var array: Array = [["telefono1", util.translate("scripts", "Teléfono"), "string"],
  ["fax", util.translate("scripts", "Fax"), "string"],
  ["email", util.translate("scripts", "Email"), "string"],
  ["web", util.translate("scripts", "Web"), "string"],
  ["nombrecomercial", util.translate("scripts", "Nombre comercial"), "string"]];
  return array;
}

function presOferta_mensajeOtrosDatos(): String {
  var mensaje: String = "PARÁMETROS PREDEFINIDOS\n\n";
  mensaje += this.iface.mensajeDatosPres();
  mensaje += "\n";
  mensaje += this.iface.mensajeDatosCliente();
  return mensaje;
}

function presOferta_mensajeDatosPres(): String {
  var mensaje: String = "";
  var i: Number;
  var arrayPresupuesto: Array = this.iface.informarArrayParamPre();
  if (arrayPresupuesto)
  {
    mensaje += "DATOS DEL PRESUPUESTO\n"
    for (i = 0; i < arrayPresupuesto.length; i++) {
      mensaje += arrayPresupuesto[i][0] + ":  " + arrayPresupuesto[i][1] + "\n";
    }
  }
  return mensaje;
}

function presOferta_mensajeDatosCliente(): String {
  var mensaje: String = "";
  var i: Number;
  var arrayCliente: Array = formpresupuestoscli.iface.informarArrayParamCli();
  if (arrayCliente)
  {
    mensaje += "DATOS DEL CLIENTE\n"
    for (i = 0; i < arrayCliente.length; i++) {
      mensaje += arrayCliente[i][0] + ":  " + arrayCliente[i][1] + "\n";
    }
  }
  return mensaje;
}


//// PRES_OFERTA //////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
