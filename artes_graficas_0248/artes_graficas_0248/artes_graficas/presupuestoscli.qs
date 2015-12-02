
/** @class_declaration artesG */
/////////////////////////////////////////////////////////////////
//// ARTES GRÁFICAS /////////////////////////////////////////////
class artesG extends oficial
{
  var recalculoHecho_: Boolean;
  var cantidadesAG_: Array;
  var curLineaAG_: FLSqlCursor;
  var refWizard: String;
  function artesG(context)
  {
    oficial(context);
  }
  function init()
  {
    return this.ctx.artesG_init();
  }
  function calcularMinPliegoImpresion()
  {
    return this.ctx.artesG_calcularMinPliegoImpresion();
  }
  function otrasCantidades()
  {
    return this.ctx.artesG_otrasCantidades();
  }
  function copiarProductos(curLinea: FLSqlCursor, numCopias: Number): Boolean {
    return this.ctx.artesG_copiarProductos(curLinea, numCopias);
  }
  function copiarItinerarios(idProdOrigen: String, idProdDestino: String, numCopias: Number, refProducto: String, canOriginal: Number): Boolean {
    return this.ctx.artesG_copiarItinerarios(idProdOrigen, idProdDestino, numCopias, refProducto, canOriginal);
  }
  function copiarTareas(xmlProceso: FLDomNode, idItiDestino: String, numCopias: Number, refProducto: String, canOriginal: Number): Boolean {
    return this.ctx.artesG_copiarTareas(xmlProceso, idItiDestino, numCopias, refProducto, canOriginal);
  }
  function datosLineaAG(curLinea: FLSqlCursor, numCopias: Number): Boolean {
    return this.ctx.artesG_datosLineaAG(curLinea, numCopias);
  }
  function obtenerCantidadesAG(idLineaMatriz: String): Boolean {
    return this.ctx.artesG_obtenerCantidadesAG(idLineaMatriz);
  }
  function aprobarLinea()
  {
    return this.ctx.artesG_aprobarLinea();
  }
  function verificarMismaCantidadPorModelo(): Boolean {
    return this.ctx.artesG_verificarMismaCantidadPorModelo();
  }
  function quitarCostesTareas(xmlProceso: FLDomNode): Boolean {
    return this.ctx.artesG_quitarCostesTareas(xmlProceso);
  }
  function wizardIptico()
  {
    return this.ctx.artesG_wizardIptico();
  }
  function wizardTaco()
  {
    return this.ctx.artesG_wizardTaco();
  }
  function wizardLibro()
  {
    return this.ctx.artesG_wizardLibro();
  }
  function wizard(referencia: String)
  {
    return this.ctx.artesG_wizard(referencia);
  }
  function obtenerRefWizard(): String {
    return this.ctx.artesG_obtenerRefWizard();
  }
  function borrarRefWizard(): Boolean {
    return this.ctx.artesG_borrarRefWizard();
  }
  function marcarRecalculoHecho(hecho: Boolean)
  {
    return this.ctx.artesG_marcarRecalculoHecho(hecho);
  }
  function calcularTotales()
  {
    return this.ctx.artesG_calcularTotales();
  }
  function copiarLineaCantidad(curLinea: FLSqlCursor, cantidad: Number): Boolean {
    return this.ctx.artesG_copiarLineaCantidad(curLinea, cantidad);
  }
  function recalcularLineasCantidad()
  {
    return this.ctx.artesG_recalcularLineasCantidad();
  }
  function modificarCantidadProceso(xmlProceso: FLDomNode, numCopias: Number, refProducto: String, canOriginal: Number): Boolean {
    return this.ctx.artesG_modificarCantidadProceso(xmlProceso, numCopias, refProducto, canOriginal);
  }
}
//// ARTES GRÁFICAS /////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pubArtesG */
/////////////////////////////////////////////////////////////////
//// PUB ARTES GRAFICAS /////////////////////////////////////////
class pubArtesG extends ifaceCtx
{
  function pubArtesG(context)
  {
    ifaceCtx(context);
  }
  function pub_obtenerRefWizard(): String {
    return this.obtenerRefWizard();
  }
  function pub_borrarRefWizard(): Boolean {
    return this.borrarRefWizard();
  }
  function pub_marcarRecalculoHecho(hecho: Boolean)
  {
    return this.marcarRecalculoHecho(hecho);
  }
}
//// PUB ARTES GRAFICAS /////////////////////////////////////////
/////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////
//// DEFINICION ////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

/** @class_definition artesG */
//////////////////////////////////////////////////////////////////
//// ARTES GRÁFICAS //////////////////////////////////////////////
function artesG_init()
{
  this.iface.__init();

  this.iface.recalculoHecho_ = false;

  connect(this.child("tbnCalcularCant"), "clicked()", this, "iface.otrasCantidades");
  connect(this.child("tbnAprobar"), "clicked()", this, "iface.aprobarLinea");
  connect(this.child("tbnIptico"), "clicked()", this, "iface.wizardIptico");
  connect(this.child("tbnTaco"), "clicked()", this, "iface.wizardTaco");
  connect(this.child("tbnLibro"), "clicked()", this, "iface.wizardLibro");

  this.iface.calcularMinPliegoImpresion();

  var columnas: Array = ["aprobado", "cantidad", "pvptotal", "pvpunitario", "descripcion"];
  this.child("tdbLineasPresupuestosCli").setOrderCols(columnas);
}

function artesG_wizardIptico()
{
  this.iface.wizard("IPTICO");
}

function artesG_wizardTaco()
{
  this.iface.wizard("TACO");
}

function artesG_wizardLibro()
{
  this.iface.wizard("LIBRO");

}
function artesG_wizard(referencia: String)
{
  this.iface.refWizard = referencia;
  this.child("toolButtomInsert").animateClick();
}

function artesG_obtenerRefWizard(): String {
  var referencia: String = this.iface.refWizard;
  this.iface.refWizard = false;
  return referencia;
}

function artesG_borrarRefWizard(): Boolean {
  this.iface.refWizard = false;
  return true;
}

function artesG_otrasCantidades()
{
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();
  var curLinea: FLSqlCursor = this.child("tdbLineasPresupuestosCli").cursor();

  var idLineaOrigen: String = curLinea.valueBuffer("idlinea");
  if (!idLineaOrigen) {
    return false;
  }
  debug(1);
  if (!this.iface.verificarMismaCantidadPorModelo()) {
    return false;
  }
  debug(2);
  if (!this.iface.obtenerCantidadesAG(idLineaOrigen)) {
    return false;
  }
  debug(3);
  if (!util.sqlDelete("lineaspresupuestoscli", "idpresupuesto = " + cursor.valueBuffer("idpresupuesto") + " AND idlineamatriz = " + idLineaOrigen)) {
    return false;
  }
  debug(4);
  var idLinea: String;
  util.createProgressDialog(util.translate("scripts", "Generando líneas"), this.iface.cantidadesAG_.length);
  var cantidad: Number;
  for (var i: Number = 0; i < this.iface.cantidadesAG_.length; i++) {
    cantidad = this.iface.cantidadesAG_[i];
    util.setProgress(i);
    if (!this.iface.copiarLineaCantidad(curLinea, cantidad)) {
      return false;
    }
  }
  util.setProgress(this.iface.cantidadesAG_.length);
  util.destroyProgressDialog();
  this.child("tdbLineasPresupuestosCli").refresh();
}

function artesG_obtenerCantidadesAG(idLineaMatriz: String): Boolean {
  var cursor: FLSqlCursor = this.cursor();
  var util: FLUtil = new FLUtil();

  this.iface.cantidadesAG_ = [];
  var qryCantidades: FLSqlQuery = new FLSqlQuery;
  qryCantidades.setTablesList("lineaspresupuestoscli");
  qryCantidades.setSelect("cantidad");
  qryCantidades.setFrom("lineaspresupuestoscli");
  qryCantidades.setWhere("idpresupuesto = " + cursor.valueBuffer("idpresupuesto") + " AND idlineamatriz = " + idLineaMatriz);
  if (!qryCantidades.exec())
  {
    return false;
  }
  var iCan: Number = 0;
  while (qryCantidades.next())
  {
    this.iface.cantidadesAG_[iCan++] = qryCantidades.value("cantidad");
  }

  var f: Object = new FLFormSearchDB("selnumcopiasag");

  f.setMainWidget();
  var id: String = f.exec("cantidad");
  if (!id)
  {
    return false;
  }
  if (this.iface.cantidadesAG_.length == 0)
  {
    return false;
  }
  return true;
}

function artesG_copiarProductos(curLinea: FLSqlCursor, numCopias: Number): Boolean {
  debug("Copiando " + numCopias + " " + curLinea.valueBuffer("descripcion"));
  var util: FLUtil = new FLUtil;

  var canOriginal: Number = curLinea.valueBuffer("cantidad");

  var qryProdOrigen: FLSqlQuery = new FLSqlQuery;
  qryProdOrigen.setTablesList("productoslp");
  qryProdOrigen.setSelect("idproducto, referencia, descripcion, idcomponente, opcion, parteopcion, seleccionado, original");
  qryProdOrigen.setFrom("productoslp");
  qryProdOrigen.setWhere("idlinea = " + curLinea.valueBuffer("idlinea"));
  qryProdOrigen.setForwardOnly(true);
  if (!qryProdOrigen.exec())
  {
    return false;
  }

  var idProdOrigen: String, idProdDestino: String, referencia: String;
  var idLineaDestino: String = this.iface.curLineaAG_.valueBuffer("idlinea");
  var curProdDestino: FLSqlCursor = new FLSqlCursor("productoslp");
  var valoresParam: String, tipoParam: String;
  while (qryProdOrigen.next())
  {
    referencia = qryProdOrigen.value("referencia");
    debug("Copiando producto " + referencia);
    curProdDestino.setModeAccess(curProdDestino.Insert);
    curProdDestino.refreshBuffer();
    curProdDestino.setValueBuffer("referencia", referencia);
    curProdDestino.setValueBuffer("descripcion", qryProdOrigen.value("descripcion"));
    curProdDestino.setValueBuffer("idcomponente", qryProdOrigen.value("idcomponente"));
    curProdDestino.setValueBuffer("original", qryProdOrigen.value("original"));
    curProdDestino.setValueBuffer("seleccionado", qryProdOrigen.value("seleccionado"));
    curProdDestino.setValueBuffer("opcion", qryProdOrigen.value("opcion"));
    curProdDestino.setValueBuffer("parteopcion", qryProdOrigen.value("parteopcion"));
    curProdDestino.setValueBuffer("idlinea", idLineaDestino);
    curProdDestino.setValueBuffer("coste", 0);
    if (!curProdDestino.commitBuffer()) {
      return false;
    }
    idProdOrigen = qryProdOrigen.value("idproducto");
    idProdDestino = curProdDestino.valueBuffer("idproducto");
    if (!this.iface.copiarItinerarios(idProdOrigen, idProdDestino, numCopias, qryProdOrigen.value("referencia"), canOriginal)) {
      return false;
    }

    switch (referencia) {
      case "IPTICO": {
        valoresParam = util.sqlSelect("paramiptico", "xml", "idproducto = " + idProdOrigen);
        if (!valoresParam) {
          valoresParam = util.sqlSelect("paramiptico", "xml", "idlinea = " + curLinea.valueBuffer("idlinea"));
        }
        tipoParam = "paramiptico";
        break;
      }
      case "PAGINAS_LIBRO": {
        valoresParam = util.sqlSelect("paramiptico", "xml", "idproducto = " + idProdOrigen);
        tipoParam = "paramiptico";
        break;
      }
      case "TAPA_LIBRO": {
        valoresParam = util.sqlSelect("paramiptico", "xml", "idproducto = " + idProdOrigen);
        tipoParam = "paramiptico";
        break;
      }
      case "TACO": {
        valoresParam = util.sqlSelect("paramtaco", "xml", "idproducto = " + idProdOrigen);
        if (!valoresParam) {
          valoresParam = util.sqlSelect("paramiptaco", "xml", "idlinea = " + curLinea.valueBuffer("idlinea"));
        }
        tipoParam = "paramtaco";
        break;
      }
      default: {
        valoresParam = "";
        tipoParam = "";
        break;
      }
    }

    var idItinerarioSel: String = util.sqlSelect("itinerarioslp", "iditinerario", "idproducto = " + idProdDestino + " AND estado = 'OK' ORDER BY costetotal");
    if (idItinerarioSel) {
      var costeProd: Number = parseFloat(util.sqlSelect("itinerarioslp", "costetotal", "iditinerario = " + idItinerarioSel));

      curProdDestino.select("idproducto = " + idProdDestino);
      if (!curProdDestino.first()) {
        return false;
      }
      curProdDestino.setModeAccess(curProdDestino.Edit);
      curProdDestino.refreshBuffer();
      curProdDestino.setValueBuffer("coste", costeProd);
      if (!curProdDestino.commitBuffer()) {
        return false;
      }
      if (!util.sqlUpdate("itinerarioslp", "escogido", "true", "iditinerario = " + idItinerarioSel)) {
        return false;
      }
    }
    if (valoresParam != "" && tipoParam != "") {
      var xmlDocParametros: FLDomDocument = new FLDomDocument();
      if (!xmlDocParametros.setContent(valoresParam)) {
        debug("!xmlDocParametros.setContent(valoresParam)");
        return false;
      }
      if (!this.iface.modificarCantidadProceso(xmlDocParametros, numCopias, referencia, canOriginal)) {
        return false;
      }
      if (!flfacturac.iface.pub_guardarCache(xmlDocParametros, idProdDestino, tipoParam, 0)) {
        return false;
      }
    }
  }
  //  if (!flfacturac.iface.pub_seleccionarOpcionProductos(this.iface.curLineaAG_.valueBuffer("idlinea"))) {
  //    return false;
  //  }
  return true;
}

function artesG_copiarItinerarios(idProdOrigen: String, idProdDestino: String, numCopias: Number, refProducto, canOriginal: Number): Boolean {
  debug("Copiando itinerarios de  " + idProdOrigen);
  var util: FLUtil = new FLUtil;

  var qryItiOrigen: FLSqlQuery = new FLSqlQuery;
  qryItiOrigen.setTablesList("itinerarioslp");
  qryItiOrigen.setSelect("iditinerario, estado, xmlparametros");
  qryItiOrigen.setFrom("itinerarioslp");
  qryItiOrigen.setWhere("idproducto = " + idProdOrigen + " AND estado = 'OK'");
  qryItiOrigen.setForwardOnly(true);
  if (!qryItiOrigen.exec())
  {
    return false;
  }

  var idItiOrigen: String;
  var idItiDestino: String;
  var curItiDestino: FLSqlCursor = new FLSqlCursor("itinerarioslp");
  while (qryItiOrigen.next())
  {
    curItiDestino.setModeAccess(curItiDestino.Insert);
    curItiDestino.refreshBuffer();
    curItiDestino.setValueBuffer("idproducto", idProdDestino);
    curItiDestino.setValueBuffer("estado", qryItiOrigen.value("estado"));
    curItiDestino.setValueBuffer("xmlparametros", qryItiOrigen.value("xmlparametros"));
    curItiDestino.setValueBuffer("costetotal", 0);
    curItiDestino.setValueBuffer("costemo", 0);
    curItiDestino.setValueBuffer("costemat", 0);
    curItiDestino.setValueBuffer("idlinea", this.iface.curLineaAG_.valueBuffer("idlinea"));
    if (!curItiDestino.commitBuffer()) {
      return false;
    }
    idItiOrigen = qryItiOrigen.value("iditinerario");
    idItiDestino = curItiDestino.valueBuffer("iditinerario");
    debug("Copiando itinerario " + idItiOrigen);
    var xmlDocParametros: FLDomDocument = new FLDomDocument();
    if (!xmlDocParametros.setContent(qryItiOrigen.value("xmlparametros"))) {
      debug("!setContent copiarIt");
      return false;
    }
    if (!this.iface.copiarTareas(xmlDocParametros.firstChild(), idItiDestino, numCopias, refProducto, canOriginal)) {
      return false;
    }
    curItiDestino.select("iditinerario = " + idItiDestino);
    if (!curItiDestino.first()) {
      return false;
    }
    var xmlPa
    curItiDestino.setModeAccess(curItiDestino.Edit);
    curItiDestino.refreshBuffer();
    curItiDestino.setValueBuffer("xmlparametros", xmlDocParametros.toString(4));
    curItiDestino.setValueBuffer("costemo", formRecorditinerarioslp.iface.pub_commonCalculateField("costemo", curItiDestino));
    curItiDestino.setValueBuffer("costemat", formRecorditinerarioslp.iface.pub_commonCalculateField("costemat", curItiDestino));
    curItiDestino.setValueBuffer("costetotal", formRecorditinerarioslp.iface.pub_commonCalculateField("costetotal", curItiDestino));
    if (!curItiDestino.commitBuffer()) {
      return false;
    }

    if (!formRecorditinerarioslp.iface.pub_actualizarPorBeneficio(curItiDestino)) {
      return false;
    }
    /// Calcular Total
  }
  return true;
}

function artesG_copiarTareas(xmlProceso: FLDomNode, idItiDestino: String, numCopias: Number, refProducto: String, canOriginal: Number): Boolean {
  debug("Copiando tareas para " + idItiDestino);
  var util: FLUtil = new FLUtil;
  if (!this.iface.modificarCantidadProceso(xmlProceso, numCopias, refProducto, canOriginal))
  {
    return false;
  }

  if (!this.iface.quitarCostesTareas(xmlProceso))
  {
    return false;
  }
  if (!formRecordlineaspresupuestoscli.iface.calcularCostesTareas(xmlProceso))
  {
    return false;
  }

  if (!formRecordlineaspresupuestoscli.iface.crearTareasLP(idItiDestino, xmlProceso))
  {
    return false;
  }
  debug("Fin copia");
  return true;
}

function artesG_modificarCantidadProceso(xmlProceso: FLDomNode, numCopias: Number, refProducto: String, canOriginal: Number): Boolean {
  var util: FLUtil = new FLUtil;
  switch (refProducto)
  {
    case "IPTICO": {
      var factor: Number = numCopias / canOriginal;
      var xmlPaginas: FLDomNode = flfacturac.iface.pub_dameNodoXML(xmlProceso, "Parametros/PaginasParam");
      var numCopiasIptico: Number = parseInt(xmlPaginas.toElement().attribute("NumCopias")) * factor;
      numCopiasIptico = Math.ceil(numCopiasIptico);
      var nodoTroquelado: FLDomNode = flfacturac.iface.pub_dameNodoXML(xmlProceso, "Parametros/TroqueladoParam");
      /// No necesario si se aplica el factor
      //      if (nodoTroquelado) {
      //        var trabajosTroquel:Number = parseInt(nodoTroquelado.toElement().attribute("TrabajosTroquel"));
      //        numCopiasIptico = Math.ceil(numCopias / trabajosTroquel);
      //      }
      xmlPaginas.toElement().setAttribute("NumCopias", numCopiasIptico);
      var numPaginas: Number = parseInt(xmlPaginas.toElement().attribute("NumPaginas"));
      var total: Number = numPaginas * numCopiasIptico;
      xmlPaginas.toElement().setAttribute("Total", numCopiasIptico);
      break;
    }
    case "TACO": {
      var numCopiasTaco: Number = numCopias;
      var xmlPaginas: FLDomNode = flfacturac.iface.pub_dameNodoXML(xmlProceso, "Parametros/PaginasParam");
      xmlPaginas.toElement().setAttribute("NumCopias", numCopiasTaco);
      var numPaginas: Number = parseInt(xmlPaginas.toElement().attribute("NumPaginas"));
      var total: Number = numPaginas * numCopiasTaco;
      xmlPaginas.toElement().setAttribute("Total", numCopiasTaco);
      break;
    }
    case "PAGINAS_LIBRO":
    case "TAPA_LIBRO": {
      var xmlPaginas: FLDomNode = flfacturac.iface.pub_dameNodoXML(xmlProceso, "Parametros/PaginasParam");
      xmlPaginas.toElement().setAttribute("NumCopias", numCopias);
      var numPaginas: Number = parseInt(xmlPaginas.toElement().attribute("NumPaginas"));
      var total: Number = numPaginas * numCopias;
      xmlPaginas.toElement().setAttribute("Total", numCopias);
      break;
    }
    case "TAREA_MANUAL": {
      var factor: Number = numCopias / canOriginal;
      var xmlDatosParam: FLDomNode = flfacturac.iface.pub_dameNodoXML(xmlProceso, "Parametros/DatosParam");
      var eDatos: FLDomElement = xmlDatosParam.toElement();
      if (eDatos.attribute("CosteFijo") != "true") {
        var unidades: Number = parseFloat(eDatos.attribute("Unidades"));
        var costeUnidad: Number = parseFloat(eDatos.attribute("CosteUnidad"));
        var costeTotal: Number = parseFloat(eDatos.attribute("CosteTotal"));
        unidades = Math.round(unidades * factor);
        costeTotal = unidades * costeUnidad;
        eDatos.setAttribute("Unidades", unidades);
        eDatos.setAttribute("CosteTotal", costeTotal);
      }
      var xmlConsumosParam: FLDomNode = flfacturac.iface.pub_dameNodoXML(xmlProceso, "Parametros/ConsumosParam");
      if (xmlConsumosParam) {
        var eConsumo: FLDomElement;
        var cantidad: Number;
        for (var xmlConsumo: FLDomNode = xmlConsumosParam.firstChild(); xmlConsumo; xmlConsumo = xmlConsumo.nextSibling()) {
          eConsumo = xmlConsumo.toElement();
          cantidad = eConsumo.attribute("Cantidad");
          cantidad = cantidad * factor;
          cantidad = util.roundFieldValue(cantidad, "consumostareamanual", "cantidad");
          eConsumo.setAttribute("Cantidad", cantidad);
        }
      }
      break;
    }
    case "ENVIO": {
      var xmlDatosEnvio: FLDomNode = flfacturac.iface.pub_dameNodoXML(xmlProceso, "Parametros/DatosParam");
      var pesoUnidad: Number = parseFloat(xmlDatosEnvio.toElement().attribute("PesoUnidad"));
      var peso: Number = pesoUnidad * numCopias;
      var codAgencia: Number = flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/AgenciaTransporteParam@Valor");
      var idPoblacion: String = xmlDatosEnvio.toElement().attribute("IdPoblacion");
      var idProvincia: String = xmlDatosEnvio.toElement().attribute("IdProvincia");
      var codPais: String = xmlDatosEnvio.toElement().attribute("CodPais");
      var portes: Number = flfactppal.iface.pub_obtenerPortesAgencia(codAgencia, peso, idPoblacion, idProvincia, codPais);
      xmlDatosEnvio.toElement().setAttribute("NumCopias", numCopias);
      xmlDatosEnvio.toElement().setAttribute("Peso", util.roundFieldValue(peso, "paramenvio", "peso"));
      xmlDatosEnvio.toElement().setAttribute("Portes", util.roundFieldValue(portes, "paramenvio", "portes"));
      break;
    }
    case "ENCUADERNACION": {
      debug("Copiand encuadernación a " + numCopias + " ...........................................");
      var xmlNumCopias: FLDomNode = flfacturac.iface.pub_dameNodoXML(xmlProceso, "Parametros/NumCopiasParam");
      xmlNumCopias.toElement().setAttribute("Valor", numCopias);

      var xmlTrabExterno: FLDomNode;
      var eTrabExterno: FLDomElement;
      var xmlTrabExternos: FLDomNode = flfacturac.iface.pub_dameNodoXML(xmlProceso, "Parametros/TrabajosExternosParam");

      for (xmlTrabExterno = xmlTrabExternos.firstChild(); xmlTrabExterno; xmlTrabExterno = xmlTrabExterno.nextSibling()) {
        eTrabExterno = xmlTrabExterno.toElement();
        debug("TrabajoExterno");
        debug(eTrabExterno.attribute("IdTipoTarea"));
        if (eTrabExterno.attribute("IdTipoTarea") == "ENCUADERNADO" && eTrabExterno.attribute("CosteFijo") != "true") {

          var codProveedor: String = eTrabExterno.attribute("CodProveedor");
          var nombreProveedor: String = eTrabExterno.attribute("NombreProveedor");
          var datosDirProveedor: Array = flfactppal.iface.pub_ejecutarQry("dirproveedores", "idpoblacion,idprovincia,codpais", "codproveedor = '" + codProveedor + "' AND direccionppal = true");
          if (datosDirProveedor["result"] == 0) {
            debug("!falló dirección para " + codProveedor);
            return false;
          }
          if (datosDirProveedor["result"] == -1) {
            MessageBox.warning(util.translate("scripts", "El proveedor %1 no tiene asociada una dirección principal").arg(codProveedor), MessageBox.Ok, MessageBox.NoButton);
            return false;
          }
          debug("datosDirProveedor = " + datosDirProveedor);
          var peso: Number = parseFloat(eTrabExterno.attribute("Peso"));
          debug("Peso " + peso);
          var codAgencia: String = eTrabExterno.attribute("CodAgencia");
          var cantidad: Number = parseFloat(eTrabExterno.attribute("Cantidad"));
          var nuevoPeso: Number = peso * numCopias / cantidad;
          xmlTrabExterno.toElement().setAttribute("Cantidad", numCopias);
          xmlTrabExterno.toElement().setAttribute("Peso", nuevoPeso);

          var portes: Number = flfactppal.iface.pub_obtenerPortesAgencia(codAgencia, nuevoPeso, datosDirProveedor["idpoblacion"], datosDirProveedor["idprovincia"], datosDirProveedor["codpais"]);
          debug("nuevoPeso " + nuevoPeso);
          debug("Portes " + portes);
          xmlTrabExterno.toElement().setAttribute("Portes", portes);
          var costeTrabajo: Number = Input.getNumber(util.translate("scipts", "Coste de ENCUADERNADO para prov %1-%2 y %3 copias").arg(codProveedor).arg(nombreProveedor).arg(numCopias), false, 2, 0);
          if (isNaN(costeTrabajo)) {
            return false;
          }
          xmlTrabExterno.toElement().setAttribute("PvpTrabajo", costeTrabajo);
          xmlTrabExterno.toElement().setAttribute("PvpTotal", parseFloat(costeTrabajo) + parseFloat(portes));

          xmlTrabExterno.toElement();
          break;
        }
      }
      //      var curLibro:FLSqlCursor = new FLSqlCursor("paramlibro");
      //      curLibro.setValueBuffer("numcopias", numCopias);
      //      curLibro.setValueBuffer("numpaginas", flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/NumPaginasParam@Valor"));
      //      var areaCerrado:String = flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/AreaTrabajoParam@Cerrado")
      //      var dimCerrado:Array = areaCerrado.split("x");
      //      curLibro.setValueBuffer("altocerrado", dimCerrado[1]);
      //      curLibro.setValueBuffer("anchocerrado", dimCerrado[0]);
      //      curLibro.setValueBuffer("totalpliegos", formRecordparamlibro.iface.pub_commonCalculateField("totalpliegos", curLibro));
      //      // ¿gramaje?
      //      curLibro.setValueBuffer("totalpliegos", formRecordparamlibro.iface.pub_commonCalculateField("peso", curLibro));
      break;
    }
  }
  return true;
}

function artesG_quitarCostesTareas(xmlProceso: FLDomNode): Boolean {
  var xmlTareas: FLDomNodeList = xmlProceso.namedItem("Tareas").childNodes();
  if (!xmlTareas)
  {
    debug("!xmlTareas");
    return false;
  }
  var xmlConsumos: FLDomNode;
  //  var consumo:FLDomNode;
  for (var i: Number = 0; i < xmlTareas.length(); i++)
  {
    xmlConsumos = xmlTareas.item(i).namedItem("Consumos");
    if (xmlConsumos) {
      while (xmlConsumos.hasChildNodes()) {
        xmlConsumos.removeChild(xmlConsumos.firstChild());
      }
    }
  }
  return true;
}

function artesG_datosLineaAG(curLinea: FLSqlCursor, numCopias: Number): Boolean {
  with(this.iface.curLineaAG_)
  {
    setValueBuffer("idpresupuesto", curLinea.valueBuffer("idpresupuesto"));
    setValueBuffer("idlineamatriz", curLinea.valueBuffer("idlinea"));
    setValueBuffer("referencia", curLinea.valueBuffer("referencia"));
    setValueBuffer("descripcion", curLinea.valueBuffer("descripcion") + " (" + numCopias + ")");
    setValueBuffer("codimpuesto", curLinea.valueBuffer("codimpuesto"));
    setValueBuffer("iva", curLinea.valueBuffer("iva"));
    setValueBuffer("recargo", curLinea.valueBuffer("recargo"));
    setValueBuffer("irpf", curLinea.valueBuffer("irpf"));
    setValueBuffer("porbeneficio", curLinea.valueBuffer("porbeneficio"));
    setValueBuffer("pvpunitario", formRecordlineaspedidoscli.iface.pub_commonCalculateField("pvpunitario", this));
    setValueBuffer("pvpsindto", formRecordlineaspedidoscli.iface.pub_commonCalculateField("pvpsindto", this));
    setValueBuffer("dtopor", formRecordlineaspedidoscli.iface.pub_commonCalculateField("dtopor", this));
    setValueBuffer("pvptotal", formRecordlineaspedidoscli.iface.pub_commonCalculateField("pvptotal", this));
    setValueBuffer("cantidad", numCopias);
  }

  return true;
}

function artesG_calcularMinPliegoImpresion()
{
  var util: FLUtil = new FLUtil;
  var qryImpresoras: FLSqlQuery = new FLSqlQuery;
  with(qryImpresoras) {
    setTablesList("pr_tiposcentrocoste");
    setSelect("codtipocentro");
    setFrom("pr_tiposcentrocoste");
    setWhere("tipoag = 'Impresora'");
    setForwardOnly(true);
  }
  if (!qryImpresoras.exec())
    return false;

  var altoMin: Number = 5000;
  var anchoMin: Number = 5000;
  var altoMax: Number = 0;
  var anchoMax: Number = 0;
  var alto: Number = 0;
  var ancho: Number;
  var nodoImpresora: FLDomNode;
  while (qryImpresoras.next()) {
    nodoImpresora = flfacturac.iface.pub_dameParamCentroCoste(qryImpresoras.value("codtipocentro"));
    if (!nodoImpresora)
      return false;

    ancho = parseFloat(nodoImpresora.toElement().attribute("AnchoMin"));
    if (!isNaN(ancho) && ancho < anchoMin) {
      anchoMin = ancho;
    }
    ancho = parseFloat(nodoImpresora.toElement().attribute("AnchoMax"));
    if (!isNaN(ancho) && ancho > anchoMax) {
      anchoMax = ancho;
    }
    alto = parseFloat(nodoImpresora.toElement().attribute("AltoMin"));
    if (!isNaN(alto) && alto < altoMin) {
      altoMin = alto;
    }
    alto = parseFloat(nodoImpresora.toElement().attribute("AltoMax"));
    if (!isNaN(alto) && alto > altoMax) {
      altoMax = alto;
    }

  }
  if (anchoMin == 5000 || altoMin == 5000) {
    MessageBox.warning(util.translate("scripts", "Debe establecer el ancho y alto mínimos en los tipos de centro de coste asociados a las impresoras.\nLos cálculos pueden fallar por este motivo."), MessageBox.Ok, MessageBox.NoButton);
    if (anchoMin == 5000)
      anchoMin = 0;
    if (altoMin == 5000)
      altoMin  = 0;
  }
  if (anchoMax == 0 || altoMax == 0) {
    MessageBox.warning(util.translate("scripts", "Debe establecer el ancho y alto máximos en los tipos de centro de coste asociados a las impresoras.\nLos cálculos pueden fallar por este motivo."), MessageBox.Ok, MessageBox.NoButton);
    if (anchoMax == 0)
      anchoMax = 5000;
    if (altoMax == 0)
      altoMax = 5000;
  }
  flfacturac.iface.minPliegoImpresion_ = util.roundFieldValue(anchoMin, "articulos", "anchopliego") + "x" + util.roundFieldValue(altoMin, "articulos", "anchopliego");

  flfacturac.iface.maxPliegoImpresion_ = util.roundFieldValue(anchoMax, "articulos", "anchopliego") + "x" + util.roundFieldValue(altoMax, "articulos", "anchopliego");
  debug(flfacturac.iface.minPliegoImpresion_);
  debug(flfacturac.iface.maxPliegoImpresion_);
}

function artesG_aprobarLinea()
{
  var curLinea: FLSqlCursor = this.child("tdbLineasPresupuestosCli").cursor();
  var idLinea: String = curLinea.valueBuffer("idlinea");
  if (!idLinea) {
    return false;
  }
  var aprobado: Boolean;
  curLinea.setModeAccess(curLinea.Edit);
  curLinea.refreshBuffer();
  aprobado = curLinea.valueBuffer("aprobado") == true;
  curLinea.setValueBuffer("aprobado", !aprobado);
  if (!curLinea.commitBuffer()) {
    return false;
  }
}

function artesG_verificarMismaCantidadPorModelo(): Boolean {
  var util: FLUtil = new FLUtil;
  var curLinea: FLSqlCursor = this.child("tdbLineasPresupuestosCli").cursor();
  var idLineaOrigen: String = curLinea.valueBuffer("idlinea");
  if (!idLineaOrigen)
  {
    return false;
  }
  var referencia: String = curLinea.valueBuffer("referencia");
  if (referencia != "IPTICO")
  {
    return true;
  }

  //  var contenido:String = util.sqlSelect("paramiptico pi INNER JOIN productoslp pl ON pi.idproducto = pl.idproducto", "pi.xml", "pl.idlinea = " + idLineaOrigen, "paramiptico,productoslp");
  var contenido: String = util.sqlSelect("paramiptico", "xml", "idlinea = " + idLineaOrigen);
  debug("idLineaOrigen = " + idLineaOrigen);
  debug("contenido2 = " + contenido);
  var xmlParametros: FLDomDocument = new FLDomDocument;
  if (!xmlParametros.setContent(contenido))
  {
    return false;
  }
  var cantidadesPorModelo: Boolean = (flfacturac.iface.pub_dameAtributoXML(xmlParametros.firstChild(), "PaginasParam@CantidadesPorModelo") == "true");
  if (cantidadesPorModelo)
  {
    MessageBox.warning(util.translate("scripts", "No es posible hacer copias por cantidad de un trabajo con distintas cantidades por modelo"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  return true;
}

function artesG_marcarRecalculoHecho(hecho: Boolean)
{
  this.iface.recalculoHecho_ = hecho;
}

function artesG_calcularTotales()
{
  this.iface.__calcularTotales();

  if (!this.iface.recalcularLineasCantidad()) {
    return false;
  }
}

/** \C Recalcula las líneas asociadas a la línea modificada si el usuario así lo indica
\end */
function artesG_recalcularLineasCantidad()
{
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  var curLinea: FLSqlCursor = this.child("tdbLineasPresupuestosCli").cursor();
  var idLinea: String = curLinea.valueBuffer("idlinea");
  if (this.iface.recalculoHecho_) {
    var qryLineasCantidad: FLSqlQuery = new FLSqlQuery;
    qryLineasCantidad.setTablesList("lineaspresupuestoscli");
    qryLineasCantidad.setSelect("idlinea, cantidad");
    qryLineasCantidad.setFrom("lineaspresupuestoscli");
    qryLineasCantidad.setWhere("idpresupuesto = " + cursor.valueBuffer("idpresupuesto") + " AND idlineamatriz = " + idLinea);
    qryLineasCantidad.setForwardOnly(true);
    if (!qryLineasCantidad.exec()) {
      return false;
    }
    if (qryLineasCantidad.size() > 0) {
      var res: Number = MessageBox.warning(util.translate("scripts", "¿Desea recalcular las líneas de otras cantidades asociadas a la línea modificada?"), MessageBox.Yes, MessageBox.No);
      var recalcular: Boolean = (res == MessageBox.Yes);

      var cantidades: Array = [];
      var iCan: Number = 0;
      while (qryLineasCantidad.next()) {
        cantidades[iCan++] = qryLineasCantidad.value("cantidad");
        if (!util.sqlDelete("lineaspresupuestoscli", "idlinea = " + qryLineasCantidad.value("idlinea"))) {
          return false;
        }
      }
      if (recalcular) {
        for (var i: Number = 0; i < cantidades.length; i++) {
          if (!this.iface.copiarLineaCantidad(curLinea, cantidades[i])) {
            return false;
          }
        }
      }
    }
  }
  this.iface.marcarRecalculoHecho(false);
  return true;
}

/** \C Copia una línea cambiando la cantidad por la indicada y recalculando el mejor itinerario
@param curLinea: Cursor de la línea a copiar
\param cantidad: Cantidad de la línea copiada
\end */
function artesG_copiarLineaCantidad(curLinea: FLSqlCursor, cantidad: Number): Boolean {
  var util: FLUtil = new FLUtil();
  if (!this.iface.curLineaAG_)
  {
    this.iface.curLineaAG_ = new FLSqlCursor("lineaspresupuestoscli");
  }
  this.iface.curLineaAG_.setModeAccess(this.iface.curLineaAG_.Insert);
  this.iface.curLineaAG_.refreshBuffer();
  if (!this.iface.datosLineaAG(curLinea, cantidad))
  {
    util.destroyProgressDialog();
    return false;
  }
  if (!this.iface.curLineaAG_.commitBuffer())
  {
    util.destroyProgressDialog();
    return false;
  }
  if (!this.iface.copiarProductos(curLinea, cantidad))
  {
    util.destroyProgressDialog();
    return false;
  }
  var idLinea: String = this.iface.curLineaAG_.valueBuffer("idlinea");
  this.iface.curLineaAG_.select("idlinea = " + idLinea);
  if (!this.iface.curLineaAG_.first())
  {
    util.destroyProgressDialog();
    return false;
  }
  this.iface.curLineaAG_.setModeAccess(this.iface.curLineaAG_.Edit);
  this.iface.curLineaAG_.refreshBuffer();
  this.iface.curLineaAG_.setValueBuffer("costeprod", formRecordlineaspresupuestoscli.iface.pub_commonCalculateField("costeprod", this.iface.curLineaAG_));
  this.iface.curLineaAG_.setValueBuffer("pvpunitario", formRecordlineaspresupuestoscli.iface.pub_commonCalculateField("pvpunitario", this.iface.curLineaAG_));
  this.iface.curLineaAG_.setValueBuffer("pvpsindto", formRecordlineaspedidoscli.iface.pub_commonCalculateField("pvpsindto", this.iface.curLineaAG_));
  this.iface.curLineaAG_.setValueBuffer("pvptotal", formRecordlineaspedidoscli.iface.pub_commonCalculateField("pvptotal", this.iface.curLineaAG_));
  if (!this.iface.curLineaAG_.commitBuffer())
  {
    util.destroyProgressDialog();
    return false;
  }
  return true;
}
//// ARTES GRÁFICAS //////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
