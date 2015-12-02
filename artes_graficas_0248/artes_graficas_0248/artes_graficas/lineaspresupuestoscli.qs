
/** @class_declaration artesG */
/////////////////////////////////////////////////////////////////
//// ARTES GRAFICAS /////////////////////////////////////////////
class artesG extends prod
{
  var log: Object;
  var xmlTrabajosPliego_: FLDomDocument;
  var idProductoSel_: Number;
  var curParametros: FLSqlCursor;
  var curItinerario: FLSqlCursor;
  var refPortes: String;
  var refWizard: String;
  var listaItResumen: String;
  var curTareaLP: FLSqlCursor;
  var curConsumoLP: FLSqlCursor;
  var xmlItinerarioRes: FLDomDocument;
  var iPlanchaRes: Number;

  function artesG(context)
  {
    prod(context);
  }
  function init()
  {
    return this.ctx.artesG_init();
  }
  function calcularCostes(usarCache: Boolean)
  {
    return this.ctx.artesG_calcularCostes(usarCache);
  }
  function calcularCostesTareas(xmlProceso: FLDomNode): Boolean {
    return this.ctx.artesG_calcularCostesTareas(xmlProceso);
  }
  function calcularCostes_clicked()
  {
    return this.ctx.artesG_calcularCostes_clicked();
  }
  function tbnCalcularSinCache_clicked()
  {
    return this.ctx.artesG_tbnCalcularSinCache_clicked();
  }
  function evaluarVariantes(xmlProceso: FLDomNode): Boolean {
    return this.ctx.artesG_evaluarVariantes(xmlProceso);
  }
  function evaluarVariantesTarea(xmlProceso: FLDomNode): Boolean {
    return this.ctx.artesG_evaluarVariantesTarea(xmlProceso);
  }
  function cargarVariantes(): FLDomNode {
    return this.ctx.artesG_cargarVariantes();
  }
  function clonarProcesoPorVar(xmlProceso: FLDomNode, nombreVar: String): Boolean {
    return this.ctx.artesG_clonarProcesoPorVar(xmlProceso, nombreVar);
  }
  function ponXmlTareaProceso(xmlProceso: FLDomNode, idTipoTareaPro: String): FLDomNode {
    return this.ctx.artesG_ponXmlTareaProceso(xmlProceso, idTipoTareaPro);
  }
  function ponCosteXmlTarea(xmlTarea: FLDomNode): Boolean {
    return this.ctx.artesG_ponCosteXmlTarea(xmlTarea);
  }
  function existeXmlTareaProceso(xmlProceso: FLDomNode, idTipoTarea: String): Booelan {
    return this.ctx.artesG_existeXmlTareaProceso(xmlProceso, idTipoTarea);
  }
  function continuarProceso(xmlProceso: FLDomNode): Boolean {
    return this.ctx.artesG_continuarProceso(xmlProceso);
  }
  function marcarProcesoInviable(xmlProceso: FLDomNode, causa: String)
  {
    return this.ctx.artesG_marcarProcesoInviable(xmlProceso, causa);
  }
  function ponValorParametroProceso(xmlProceso: FLDomNode, parametro: String, valor): Boolean {
    return this.ctx.artesG_ponValorParametroProceso(xmlProceso, parametro, valor);
  }
  function costesPorCentroTarea(codTipoCentro: String, idTipoTareaPro: String): Array {
    return this.ctx.artesG_costesPorCentroTarea(codTipoCentro, idTipoTareaPro);
  }
  function saltarTarea(xmlTarea: FLDomNode): Boolean {
    return this.ctx.artesG_saltarTarea(xmlTarea);
  }
  function bufferChanged(fN: String)
  {
    return this.ctx.artesG_bufferChanged(fN);
  }
  function calculateField(fN: String): String {
    return this.ctx.artesG_calculateField(fN);
  }
  function calcularParametrosDefecto()
  {
    return this.ctx.artesG_calcularParametrosDefecto();
  }
  function paramDefectoComponentes(referencia: String): String {
    return this.ctx.artesG_paramDefectoComponentes(referencia);
  }
  function volcarDatosProducto(xmlProducto: FLDomNode, idProductoOpcion: String): Boolean {
    return this.ctx.artesG_volcarDatosProducto(xmlProducto, idProductoOpcion);
  }
  function filtrarItinerarios()
  {
    return this.ctx.artesG_filtrarItinerarios();
  }
  function escogerItinerario(idItinerario: String)
  {
    return this.ctx.artesG_escogerItinerario(idItinerario);
  }
  function ponDetalleTarea(xmlProceso: FLDomNode, texto: String, atributo: String): Boolean {
    return this.ctx.artesG_ponDetalleTarea(xmlProceso, texto, atributo);
  }
  function quitaDetalleTarea(xmlProceso: FLDomNode, atributo: String): Boolean {
    return this.ctx.artesG_quitaDetalleTarea(xmlProceso, atributo);
  }
  function lanzarLog(accion: String)
  {
    return this.ctx.artesG_lanzarLog(accion);
  }
  function instruccionesPlanchas(xmlProceso: FLDomNode): String {
    return this.ctx.artesG_instruccionesPlanchas(xmlProceso);
  }
  function instruccionesJuegosPlancha(xmlProceso: FLDomNode): String {
    return this.ctx.artesG_instruccionesJuegosPlancha(xmlProceso);
  }
  function cargarParametros(): Boolean {
    return this.ctx.artesG_cargarParametros();
  }
  function tbnParametros_clicked()
  {
    return this.ctx.artesG_tbnParametros_clicked();
  }
  function tbnParamProceso_clicked()
  {
    return this.ctx.artesG_tbnParamProceso_clicked();
  }
  function tbnParametrosIt_clicked()
  {
    return this.ctx.artesG_tbnParametrosIt_clicked();
  }
  function tbnVerItinerario_clicked()
  {
    return this.ctx.artesG_tbnVerItinerario_clicked();
  }
  function escogerItinerario_clicked()
  {
    return this.ctx.artesG_escogerItinerario_clicked();
  }
  function marcarMejorItinerario(idProducto: String)
  {
    return this.ctx.artesG_marcarMejorItinerario(idProducto);
  }
  function actualizarCosteProd()
  {
    return this.ctx.artesG_actualizarCosteProd();
  }
  function crearTareasLP(idItinerario: String, xmlProceso: FLDomNode): Boolean {
    return this.ctx.artesG_crearTareasLP(idItinerario, xmlProceso);
  }
  function crearConsumosLP(idTarea: String, eTarea: FLDomElement): Boolean {
    return this.ctx.artesG_crearConsumosLP(idTarea, eTarea);
  }
  function commonCalculateField(fN: String, cursor: FLSqlCursor): String {
    return this.ctx.artesG_commonCalculateField(fN, cursor);
  }
  function ponConsumoTarea(xmlTarea: FLDomNode, referencia: String, cantidad: Number, costeUnidad: Number, cantidadAux: Number, porBeneficio: Number): Boolean {
    return this.ctx.artesG_ponConsumoTarea(xmlTarea, referencia, cantidad, costeUnidad, cantidadAux, porBeneficio);
  }
  function dameTiempoExtraPantone(xmlParamImpresora: FLDomNode, xmlProceso: FLDomNode): Array {
    return this.ctx.artesG_dameTiempoExtraPantone(xmlParamImpresora, xmlProceso);
  }
  //  function clonarProductoPorVar(curProducto:FLSqlCursor):Boolean {
  //    return this.ctx.artesG_clonarProductoPorVar(curProducto);
  //  }
  //  function copiarProducto(curProducto:FLSqlCursor, opcion:String, parteOpcion:String):Number {
  //    return this.ctx.artesG_copiarProducto(curProducto, opcion, parteOpcion);
  //  }
  //  function copiarIptico(idProducto:String, idProductoNuevo:String):Boolean {
  //    return this.ctx.artesG_copiarIptico(idProducto, idProductoNuevo);
  //  }
  function actualizarIpticoPorOpcion(idProducto: String, parametro: String, opcion: Array): Boolean {
    return this.ctx.artesG_actualizarIpticoPorOpcion(idProducto, parametro, opcion);
  }
  function tbnSiguienteOpcion_clicked()
  {
    return this.ctx.artesG_tbnSiguienteOpcion_clicked();
  }
  function refrescarProductos()
  {
    return this.ctx.artesG_refrescarProductos();
  }
  function tandasGuillotina(xmlParamGuillotina: FLDomNode, refPliego: String, numCopias: Number, tabla: String): Number {
    return this.ctx.artesG_tandasGuillotina(xmlParamGuillotina, refPliego, numCopias, tabla);
  }
  function resumenTrabajo()
  {
    return this.ctx.artesG_resumenTrabajo();
  }
  function formatoTiempo(minutos: Number): String {
    return this.ctx.artesG_formatoTiempo(minutos);
  }
  function formatoTexto(datos: String, maxLon: Number, alineacion: Number): String {
    return this.ctx.artesG_formatoTexto(datos, maxLon, alineacion);
  }
  function espaciosIzquierda(texto: String, totalLongitud: Number): String {
    return this.ctx.artesG_espaciosIzquierda(texto, totalLongitud);
  }
  function wizard()
  {
    return this.ctx.artesG_wizard();
  }
  function descripcionIptico(): String {
    return this.ctx.artesG_descripcionIptico();
  }
  function descripcionTaco(): String {
    return this.ctx.artesG_descripcionTaco();
  }
  function descripcionPlastificado(curIptico: FLSqlCursor): String {
    return this.ctx.artesG_descripcionPlastificado(curIptico);
  }
  function establecerFiltrosResumen()
  {
    return this.ctx.artesG_establecerFiltrosResumen();
  }
  function iniciarFiltroResumen()
  {
    return this.ctx.artesG_iniciarFiltroResumen();
  }
  function totalizarTareasResumen()
  {
    return this.ctx.artesG_totalizarTareasResumen();
  }
  function resTareas_bufferCommited()
  {
    return this.ctx.artesG_resTareas_bufferCommited();
  }
  function resConsumos_bufferCommited()
  {
    return this.ctx.artesG_resConsumos_bufferCommited();
  }
  function editarTarea()
  {
    return this.ctx.artesG_editarTarea();
  }
  function editarConsumo()
  {
    return this.ctx.artesG_editarConsumo();
  }
  function actualizarCosteProducto(idProducto: String, idItinerario: String): Boolean {
    return this.ctx.artesG_actualizarCosteProducto(idProducto, idItinerario);
  }
  function tdbResProductos_newBuffer()
  {
    return this.ctx.artesG_tdbResProductos_newBuffer();
  }
  function mostrarPrecorte(curProducto: FLSqlCursor): Boolean {
    return this.ctx.artesG_mostrarPrecorte(curProducto);
  }
  function cargarPlanchas(idProducto: String): Boolean {
    return this.ctx.artesG_cargarPlanchas(idProducto);
  }
  function tbnDistPlancha_clicked()
  {
    return this.ctx.artesG_tbnDistPlancha_clicked();
  }
  function borrarDiagramas()
  {
    return this.ctx.artesG_borrarDiagramas();
  }
  function tbnInsertarProducto_clicked()
  {
    return this.ctx.artesG_tbnInsertarProducto_clicked();
  }
  function buscarCache(xmlDocValoresParam: FLDomDocument): String {
    return this.ctx.artesG_buscarCache(xmlDocValoresParam);
  }
  function pliegosImpresionIptico(xmlProceso: FLDomNode): Number {
    return this.ctx.artesG_pliegosImpresionIptico(xmlProceso);
  }
}
//// ARTES GRAFICAS /////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pubArtesG */
/////////////////////////////////////////////////////////////////
//// PUB_ARTES_GRAFICAS /////////////////////////////////////////
class pubArtesG extends ifaceCtx
{
  function pubArtesG(context)
  {
    ifaceCtx(context);
  }
  function pub_instruccionesPlanchas(xmlProceso: FLDomNode): String {
    return this.instruccionesPlanchas(xmlProceso);
  }
  function pub_instruccionesJuegosPlancha(xmlProceso: FLDomNode): String {
    return this.instruccionesJuegosPlancha(xmlProceso);
  }
  function pub_commonCalculateField(fN: String, cursor: FLSqlCursor): String {
    return this.commonCalculateField(fN, cursor);
  }
}

const iface = new pubArtesG(this);
//// PUB_ARTES_GRAFICAS /////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition artesG */
/////////////////////////////////////////////////////////////////
//// ARTES GRÁFICAS /////////////////////////////////////////////
/** \C <b>PARÁMETROS</b><br/>
<b>NumCopiasParam</b>: Número de copias del trabajo.<br/>
Origen: Usuario<br/>
Atributos:<br/>
<ul>
<li>Valor: (numérico) Número de copias.</li>
</ul>

<b>NumPaginasParam</b>: Número de modelos del trabajo.<br/>
Origen: Usuario<br/>
Atributos:<br/>
<ul>
<li>Valor: (numérico) Número de copias.</li>
</ul>

<b>GramajeParam</b>: Gramaje del papel a usar.<br/>
Origen: Usuario<br/>
Atributos:<br/>
<ul>
<li>Valor: (numérico) Gramaje.</li>
</ul>

<b>AreaTrabajoParam</b>: Área del trabajo.<br/>
Origen: Usuario<br/>
Atributos:<br/>
<ul>
<li>Valor: (area NxM) Área del trabajo.</li>
</ul>

<b>PlastificadoParam</b>: Plastificado.<br/>
Origen: Usuario<br/>
Atributos:<br/>
<ul>
<li>Valor: (cadena) Cadena compuesta por dos códigos de plastificado de una letra. El primer código hace referencia a la cara frontal del trabajo y la segunda a la vuelta. Los posibles valores de estos códigos son:
<ul>
<li>N: Sin plastificado</li>
<li>B: Plastificado en brillo</li>
<li>M: Plastificado en mate</li>
</ul>
</li>
</ul>

<b>ColoresParam</b>: Distribución de colores del trabajo.<br/>
Origen: Usuario<br/>
Atributos:<br/>
<ul>
<li>Valor: (cadena) Resumen de la estructura.</li>
</ul>
Estructura:<br/>
<ul>
<li>ConfigColores: Configuración de colores por cara. El atributo Cara indica si se trata de la configuración de la cara frontal (valor Frente) o de la trasera (valor Vuelta).
<ul>
<li>Color: Color dentro de una configuración por cara.  El atributo Nombre indica el color a usar
</li>
</ul>
</li>
</ul>

<b>SangriaParam</b>: Medidas de la sangría.<br/>
Origen: Usuario<br/>
Atributos:<br/>
<ul>
<li>Arriba: (numérico) Valor en cms de la sangria superior.</li>
<li>Abajo: (numérico) Valor en cms de la sangria inferior.</li>
<li>Izquierda: (numérico) Valor en cms de la sangria izquierda.</li>
<li>Derecha: (numérico) Valor en cms de la sangria derecha.</li>
</ul>

<b>PliegoImpresionParam</b>: Pliego de impresión a usar. Indica qué artículo de la familia Pliego debe usarse, así como los cortes a realizar (si los hay) sobre él antes de realizar la impresión.<br/>
Origen: Calculado<br/>
Atributos:<br/>
<ul>
<li>Valor: (area NxM) Área del pliego de impresión cortado.</li>
<li>AreaPliego: (area NxM) Área del pliego original (antes del corte).</li>
<li>Corte: (NxM) Distribución de los cortes a realizar.</li>
<li>Factor: (numérico) Numero de pliegos de impresión en los que se divide el pliego original.</li>
<li>Ref: (cadena) Referencia del artículo correspondiente al pliego en la tabla de artículos.</li>
</ul>

<b>TipoImpresoraParam</b>: Prensa a usar. Indica la impresora y sus características.<br/>
Origen: Calculado<br/>
Atributos:<br/>
<ul>
<li>Valor: (cadena) Nombre del tipo de centro de coste asociado a la prensa.</li>
<li>AreaPlancha: (area NxM) Área de las planchas que la prensa usa.</li>
<li>RefPlancha: (cadena) Referencia del artículo correspondiente a la plancha que usa la prensa.</li>
<li>TrabajosPlancha: (numérico) Número de trabajos que admite cada plancha.</li>
<li>NumCuerpos: (numérico) Número de cuerpos de la impresora.</li>
</ul>

<b>EstiloImpresionParam</b>: Estilo de impresión a usar. <br/>
Origen: Calculado<br/>
Atributos:<br/>
<ul>
<li>Valor: (cadena) Nombre del estilo. Los estilos admitidos son Simple, CaraRetira, TiraRetira y TiraVolteo.</li>
<li>EjeSim: (cadena) Indicador de si el eje de simetría es vertical (valor V) u horizontal (valor H). Tiene sentido para el estilo TiraRetira</li>
</ul>

<b>DistPlanchaParam</b>: Distribución de los trabajos en las planchas. <br/>
Origen: Calculado<br/>
Atributos:<br/>
<ul>
<li>Eficiencia: (porcentaje) Grado de ocupación de las planchas en base a su potencial máxima ocupación.</li>
<li>NumPliegos: (numérico) Número total de pliegos de impresión a utilizar</li>
<li>NumPasadas: (numérico) Número total de impresiones de plancha sobre pliego</li>
<li>NumPlanchas: (numérico) Número de planchas a utilizar</li>
</ul>
Estructura:<br/>
<ul>
<li>Plancha: Distribución para cada plancha. Sus atributos son:
<ul>
<li>Numero: (numérico) Identificador de la plancha.</li>
<li>NumPasadas: (numérico) Número de copias a realizar con la plancha</li>
<li>Dist: (cadena) Distribución de trabajos en la plancha.</li>
<li>Cara: (cadena) Indica si la plancha es para el Frente o para la Vuelta. Si el estilo de impresión es TiraRetira este valor es Frente</li>
<li>Color: (cadena) Color asociado a la plancha.</li>
</ul>
</li>
</ul>
*/
function artesG_init()
{
  this.iface.__init();

  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();
  connect(this.child("tbnCalcular"), "clicked()", this, "iface.calcularCostes_clicked");
  connect(this.child("tbnCalcularSinCache"), "clicked()", this, "iface.tbnCalcularSinCache_clicked");
  connect(this.child("tbnItiEscogido"), "clicked()", this, "iface.escogerItinerario_clicked");
  connect(this.child("tdbProductos").cursor(), "newBuffer()", this, "iface.filtrarItinerarios");
  connect(this.child("tbnParametros"), "clicked()", this, "iface.tbnParametros_clicked");
  connect(this.child("tbnParamProceso"), "clicked()", this, "iface.tbnParamProceso_clicked");
  connect(this.child("tbnParametrosIt"), "clicked()", this, "iface.tbnParametrosIt_clicked");
  connect(this.child("tbnVerItinerario"), "clicked()", this, "iface.tbnVerItinerario_clicked");
  connect(this.child("tdbItinerarios").cursor(), "bufferCommited()", this, "iface.actualizarCosteProd");
  connect(this.child("tbnSiguienteOpcion"), "clicked()", this, "iface.tbnSiguienteOpcion_clicked");
  connect(this.child("chkMostrarInviables"), "clicked()", this, "iface.filtrarItinerarios");
  connect(this.child("tdbResProductos"), "primaryKeyToggled(QVariant, bool)", this, "iface.establecerFiltrosResumen");
  connect(this.child("tbnEditTarea"), "clicked()", this, "iface.editarTarea()");
  connect(this.child("tbnEditConsumo"), "clicked()", this, "iface.editarConsumo()");
  connect(this.child("tdbResProductos").cursor(), "newBuffer()", this, "iface.tdbResProductos_newBuffer()");
  connect(this.child("tbnDistPlancha"), "clicked()", this, "iface.tbnDistPlancha_clicked()"),
          connect(this.child("tbnInsertarProducto"), "clicked()", this, "iface.tbnInsertarProducto_clicked()"),

          this.iface.filtrarItinerarios();
  formRecordpresupuestoscli.iface.pub_marcarRecalculoHecho(false);

  this.iface.refPortes = flfactppal.iface.pub_valorDefectoEmpresa("refportes");
  if (!this.iface.refPortes || this.iface.refPortes == "") {
    MessageBox.warning(util.translate("scripts", "No tiene establecido un artículo de portes en el formulario de empresa.\nEste dato es necesario para contabilizar el consumo de portes.\nCree dicho artículo si no existe ya e indíquelo en el formulario de empresa"), MessageBox.Ok, MessageBox.NoButton);
    this.close();
  }

  var filtroReferencia: String = ""; //this.child("fdbReferencia").filter();
  if (filtroReferencia != "") {
    filtroReferencia += " AND ";
  }
  filtroReferencia += "fabricado AND sevende";
  this.child("fdbReferencia").setFilter(filtroReferencia);

  this.iface.resumenTrabajo();

  switch (cursor.modeAccess()) {
    case cursor.Insert: {
      this.child("fdbPorBeneficio").setValue(this.iface.calculateField("porbeneficio"));
      var referenciaWizard: String = formRecordpresupuestoscli.iface.pub_obtenerRefWizard();
      if (referenciaWizard) {
        this.iface.refWizard = referenciaWizard;
        try {
          connect(this, "formReady()", this, "iface.wizard");
        } catch (e) {
          startTimer(2000, this.iface.wizard);
        }
      }
      break;
    }
  }
  this.child("fdbCantidadRes").setDisabled(true);
  this.child("fdbCosteRes").setDisabled(true);
  this.child("fdbDescripcionRes").setDisabled(true);
}

function artesG_wizard()
{
  if (!this.iface.refWizard) {
    return;
  }
  killTimers();
  this.child("fdbReferencia").setValue(this.iface.refWizard);
  sys.processEvents()
  debug("borrando");
  formRecordpresupuestoscli.iface.pub_borrarRefWizard();
  this.iface.refWizard = false;
  this.iface.tbnParametros_clicked();

}

function artesG_actualizarCosteProd()
{
  var curItinerario: FLSqlCursor = this.child("tdbItinerarios").cursor();
  var idItinerario: String = curItinerario.valueBuffer("iditinerario");
  if (!idItinerario) {
    return false;
  }
  if (curItinerario.valueBuffer("escogido")) {
    this.iface.escogerItinerario(idItinerario)
  }
}

/** \C
<br/><i><b>DESCRIPICIÓN DE TAREAS</b></i><br/>
*/
function artesG_evaluarVariantesTarea(xmlProceso: FLDomNode): Boolean {
  var util: FLUtil = new FLUtil;
  var idTipoProceso: String = xmlProceso.toElement().attribute("IdTipoProceso");
  var idTipoTarea: String = xmlProceso.toElement().attribute("IdTipoTareaActual");
  var idTipoTareaPro: String = xmlProceso.toElement().attribute("IdTipoTareaProActual");
  var codTipoTareaPro: String = xmlProceso.toElement().attribute("CodTipoTareaProActual");
  var instrucciones: String = "";

  var xmlTarea: FLDomNode = flfacturac.iface.pub_dameNodoXML(xmlProceso, "Tareas/Tarea[@IdTipoTareaPro=" + idTipoTareaPro + "]");
  if (!xmlTarea)
  {
    xmlTarea = this.iface.ponXmlTareaProceso(xmlProceso, idTipoTareaPro);
    if (!xmlTarea)
      return false;
  }
  //this.iface.log.child("log").append(util.translate("scripts", "Evaluando tarea %1").arg(idTipoTarea));

  debug("Evaluando tarea " + idTipoTareaPro + " - " + idTipoTarea);

  if (xmlTarea.toElement().attribute("ControlFlujo") == "true")
  {
    var xmlST: FLDomNode = flfacturac.iface.pub_dameNodoXML(xmlTarea, "SiguienteTarea");
    if (!xmlST) {
      if (!this.iface.clonarProcesoPorVar(xmlProceso, "SiguienteTareaVar"))
        return false;
      return true;
    }
    if (!this.iface.saltarTarea(xmlTarea)) {
      return false;
    }
  }

  // var d:FLDomDocument = new FLDomDocument;
  // d.appendChild(xmlProceso.cloneNode());
  // debug(d.toString(4));
  var tarea: String = ((codTipoTareaPro && codTipoTareaPro != "") ? codTipoTareaPro : idTipoTarea);
  switch (tarea)
  {
    case "DISEÑO": {
      /** <b>TAREA DE DISEÑO</b><br/>
      DESCRIPCIÓN<br/>
      Es la tarea inicial. Consiste en el diseño de los trabajos encargados.<br/>
      BIFURCACIÓN DE ITINERARIOS:<br/>
      Se genera un itinerario por posible pliego de impresión utilizado (parámetro PliegoImpresionParam).
      */
      var refPliego: String = flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/PliegoParam@Ref");
      if (!refPliego) {
        if (!this.iface.clonarProcesoPorVar(xmlProceso, "PliegoVar")) {
          return false;
        }
        return true;
      }

      var areaPliegoImpresion: String = flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/PliegoImpresionParam@Valor");
      if (!areaPliegoImpresion) {
        if (!this.iface.clonarProcesoPorVar(xmlProceso, "PliegoImpresionVar")) {
          return false;
        }
        return true;
      }
      var estiloImpresion: String;
      var saltarImp: String = flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros@SaltarImpresion");
      if (saltarImp != "true") {
        var xmlParamTI: FLDomNode = flfacturac.iface.pub_dameNodoXML(xmlProceso, "Parametros/TipoImpresoraParam");
        if (!xmlParamTI) {
          if (!this.iface.clonarProcesoPorVar(xmlProceso, "TipoImpresoraVar"))
            return false;
          return true;
        }

        estiloImpresion = flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/EstiloImpresionParam@Valor");
        if (!estiloImpresion) {
          if (!this.iface.clonarProcesoPorVar(xmlProceso, "EstiloImpresionVar"))
            return false;
          return true;
        }

        if (!flfacturac.iface.pub_nodoXMLPinza(xmlProceso)) {
          return false;
        }
      }

      var trabajosPliego: FLDomNode = flfacturac.iface.pub_dameNodoXML(xmlProceso, "Parametros/TrabajosPliegoParam");
      if (!trabajosPliego) {
        if (!this.iface.clonarProcesoPorVar(xmlProceso, "TrabajosPliegoVar"))
          return false;
        return true;
      }

      if (saltarImp != "true") {
        if (estiloImpresion == "TiraRetira") {
          var troquelSimetrico: Boolean = flfacturac.iface.pub_troqueladoSimetrico(xmlProceso);

          var ejeSim: String = flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/TrabajosPliegoParam@EjeSim");

          // debug("TROQUEL SIMETRICO " + troquelSimetrico);
          if (!troquelSimetrico && (!ejeSim || ejeSim == "")) {
            this.iface.marcarProcesoInviable(xmlProceso, util.translate("scripts", "El estilo de impresión TiraRetira no es compatible con distribuciones no simétricas"));
            return true
          }
        }

        if (!flfacturac.iface.pub_validarPinzas(xmlProceso)) {
          this.iface.marcarProcesoInviable(xmlProceso, util.translate("scripts", "La distribución escogida no encaja en el pliego de impresión para la impresora y estilo de impresión escogidos"));
          return true
        }
      }
             break;
    }
    case "TACO_DISEÑO": {
      //      var refPliego:String = flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/PliegoParam@Ref");
      //      if (!refPliego) {
      //        if (!this.iface.clonarProcesoPorVar(xmlProceso, "PliegoVar"))
      //          return false;
      //        return true;
      //      }

      var areaPliegoImpresion: String = flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/PliegoImpresionParam@Valor");
      if (!areaPliegoImpresion) {
        if (!this.iface.clonarProcesoPorVar(xmlProceso, "PliegoImpresionVar")) {
          return false;
        }
        return true;
      }

      var xmlParamTI: FLDomNode = flfacturac.iface.pub_dameNodoXML(xmlProceso, "Parametros/TipoImpresoraParam");
      if (!xmlParamTI) {
        if (!this.iface.clonarProcesoPorVar(xmlProceso, "TipoImpresoraVar"))
          return false;
        return true;
      }

      var estiloImpresion: String = flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/EstiloImpresionParam@Valor");
      if (!estiloImpresion) {
        if (!this.iface.clonarProcesoPorVar(xmlProceso, "EstiloImpresionVar")) {
          return false;
        }
        return true;
      }

      //      if (estiloImpresion == "TiraRetira") {
      //        var ejeSim:String = flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/TrabajosPliegoParam@EjeSim");
      //      }

      if (!flfacturac.iface.pub_nodoXMLPinza(xmlProceso)) {
        return false;
      }
      var trabajosPliego: FLDomNode = flfacturac.iface.pub_dameNodoXML(xmlProceso, "Parametros/TrabajosPliegoParam");
      if (!trabajosPliego) {
        if (!this.iface.clonarProcesoPorVar(xmlProceso, "TrabajosPliegoVar")) {
          return false;
        }
        return true;
      }

      if (estiloImpresion == "TiraRetira") {
        var troquelSimetrico: Boolean = flfacturac.iface.pub_troqueladoSimetrico(xmlProceso);
        var ejeSim: String = flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/TrabajosPliegoParam@EjeSim");

        // debug("TROQUEL SIMETRICO " + troquelSimetrico);
        if (!troquelSimetrico && (!ejeSim || ejeSim == "")) {
          this.iface.marcarProcesoInviable(xmlProceso, util.translate("scripts", "El estilo de impresión TiraRetira no es compatible con distribuciones no simétricas"));
          return true
        }
      }

      if (!flfacturac.iface.pub_validarPinzas(xmlProceso)) {
        this.iface.marcarProcesoInviable(xmlProceso, util.translate("scripts", "La distribución escogida no encaja en el pliego de impresión para la impresora y estilo de impresión escogidos"));
        return true
      }
             break;
    }
    case "PLANCHAS": {
      var saltar: String = flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros@SaltarPlanchas");
      if (saltar == "true") {
        if (!this.iface.saltarTarea(xmlTarea)) {
          return false;
        }
      } else {
        var xmlParamDP: FLDomNode = flfacturac.iface.pub_dameNodoXML(xmlProceso, "Parametros/DistPlanchaParam");
        if (!xmlParamDP) {
          if (!this.iface.clonarProcesoPorVar(xmlProceso, "DistPlanchaVar"))
            return false;
          return true;
        }
      }
      break;
    }
    case "TACO_PLANCHAS": {
      var xmlParamDP: FLDomNode = flfacturac.iface.pub_dameNodoXML(xmlProceso, "Parametros/DistPlanchaParam");
      if (!xmlParamDP) {
        if (!this.iface.clonarProcesoPorVar(xmlProceso, "DistPlanchaVar"))
          return false;
        return true;
      }

      break;
    }
    case "PRECORTE": /// Corte previo (se realiza cuando hay que cortar el papel)
    case "TACO_PRECORTE": {
      /** <b>TAREA DE CORTE PREVIO (PRECORTE)</b><br/>
      DESCRIPCIÓN<br/>
      Consiste en el corte de los pliegos que se realiza antes de la impresión. Su objetivo es adaptar el tamaño del pliego de trabajo a la prensa a utilizar.<br/>
      TAREA OPCIONAL:<br/>
      La tarea se realiza únicamente cuando el atributo Corte del parámetro PliegoImpresionParam es distinto de 1x1, es decir, cuando hay uno o más cortes especificados.<br/>
      BIFURCACIÓN DE ITINERARIOS:<br/>
      No hay bifurcaciones
      */
      var corte: String = flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/PliegoImpresionParam@Corte");
      if (corte == "1x1") {
        if (!this.iface.saltarTarea(xmlTarea))
          return false;
      }
      break;
    }
    case "IMPRESION": {
      var saltar: String = flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros@SaltarImpresion");
      if (saltar == "true") {
        if (!this.iface.saltarTarea(xmlTarea)) {
          return false;
        }
      }
      break;
    }
    case "TACO_IMPRESION": {
      /** <b>TAREA DE IMPRESIÓN</b><br/>
      DESCRIPCIÓN<br/>
      Consiste en el la impresión de los trabajos en la prensa seleccionada.<br/>
      BIFURCACIÓN DE ITINERARIOS:<br/>
      No hay bifurcaciones
      */
      break;
    }
    case "CORTEPLAS": {
      /** <b>TAREA DE CORTE PREVIO AL PLASTIFICADO (CORTEPLAS)</b><br/>
      DESCRIPCIÓN<br/>
      Consiste el corte del pliego de trabajo antes del plastificado cuando cada cara va en un tipo de plastificado distinto o una va plastificada y la otra no.<br/>
      BIFURCACIÓN DE ITINERARIOS:<br/>
      No hay bifurcaciones<br/>
      TAREA OPCIONAL:<br/>
      La tarea se realiza cuando:
      <ul>
      <li>Cada pliego impreso contienen ambas caras (parametro EstiloImpresionParam con atributo valor igual a TiraRetira). </li>
      <li>El trabajo necesita plastificado sólo en una cara o necesita un plastificado distinto en cada cara</li>
      </ul>
      */
      var dimPliegoImp: String = flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/PliegoImpresionParam@Valor");
      var areaPliegoPlas: Array = dimPliegoImp.split("x");
      xmlProceso.namedItem("Parametros").namedItem("PlastificadoParam").toElement().setAttribute("AreaPliegoPlas", areaPliegoPlas[0] + "x" + areaPliegoPlas[1]);
      xmlProceso.namedItem("Parametros").namedItem("PlastificadoParam").toElement().setAttribute("FactorCortePlas", "1");

      var estiloImpresion: String = flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/EstiloImpresionParam@Valor");
      if (estiloImpresion == "TiraRetira") {
        var plastificado: String = flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/PlastificadoParam@Valor");
        if (!plastificado || plastificado == "NN" || plastificado == "BB" || plastificado == "MM") {
          if (!this.iface.saltarTarea(xmlTarea))
            return false;
        } else {
          var ejeCorte: String = flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/TrabajosPliegoParam@EjeSim");
          var factorCortePlas: Number = 1;
          if (ejeCorte == "H") {
            areaPliegoPlas[1] /= 2;
            factorCortePlas = 2;
          } else if (ejeCorte == "V") {
            areaPliegoPlas[0] /= 2;
            factorCortePlas = 2;
          }
          xmlProceso.namedItem("Parametros").namedItem("PlastificadoParam").toElement().setAttribute("AreaPliegoPlas", areaPliegoPlas[0] + "x" + areaPliegoPlas[1]);
          xmlProceso.namedItem("Parametros").namedItem("PlastificadoParam").toElement().setAttribute("FactorCortePlas", factorCortePlas);
        }
      } else {
        if (!this.iface.saltarTarea(xmlTarea))
          return false;
      }
      break;
    }
    case "PLASTIFICADO": {
      /** <b>TAREA DE PLASTIFICADO</b><br/>
      DESCRIPCIÓN<br/>
      Consiste en el plastificado de una o dos caras del trabajo.<br/>
      BIFURCACIÓN DE ITINERARIOS:<br/>
      No hay bifurcaciones<br/>
      TAREA OPCIONAL:<br/>
      La tarea se realiza cuando así se especifica en el parámetro PlastificadoParam o si el atributo Valor del parámetro es NN
      */
      var plastificado: String = flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/PlastificadoParam@Valor");
      if (!plastificado || plastificado == "NN") {
        if (!this.iface.saltarTarea(xmlTarea))
          return false;
        break;
      }

      var xmlParamTP: FLDomNode = flfacturac.iface.pub_dameNodoXML(xmlProceso, "Parametros/TipoPlastificadoraParam");
      if (!xmlParamTP) {
        if (!this.iface.clonarProcesoPorVar(xmlProceso, "TipoPlastificadoraVar"))
          return false;
        return true;
      }

      break;
    }
    case "TROQUELADO": {
      /** <b>TAREA DE TROQUELADO</b><br/>
      DESCRIPCIÓN<br/>
      Consiste en la aplicación de un troquel a los pliegos.<br/>
      BIFURCACIÓN DE ITINERARIOS:<br/>
      No hay bifurcaciones<br/>
      TAREA OPCIONAL:<br/>
      La tarea se realiza cuando así se especifica en el parámetro TroqueladoParam
      */
      var troquelado: String = flfacturac.iface.pub_dameNodoXML(xmlProceso, "Parametros/TroqueladoParam");
      if (!troquelado) {
        if (!this.iface.saltarTarea(xmlTarea))
          return false;
        break;
      }

      var xmlParamTT: FLDomNode = flfacturac.iface.pub_dameNodoXML(xmlProceso, "Parametros/TipoTroqueladoraParam");
      if (!xmlParamTT) {
        if (!this.iface.clonarProcesoPorVar(xmlProceso, "TipoTroqueladoraVar"))
          return false;
        return true;
      }
      break;
    }
    case "PELADO": {
      /** <b>TAREA DE PELADO</b><br/>
      DESCRIPCIÓN<br/>
      Consiste en la sacar las piezas troqueladas de los pliegos de troquelado.<br/>
      BIFURCACIÓN DE ITINERARIOS:<br/>
      No hay bifurcaciones<br/>
      TAREA OPCIONAL:<br/>
      La tarea se realiza cuando así se especifica en el parámetro TroqueladoParam
      */
      var pelado: FLDomNode = flfacturac.iface.pub_dameNodoXML(xmlProceso, "Parametros/PeladoParam");
      if (!pelado) {
        if (!this.iface.saltarTarea(xmlTarea)) {
          return false;
        }
        break;
      }

      var xmlParamTP: FLDomNode = flfacturac.iface.pub_dameNodoXML(xmlProceso, "Parametros/TipoPeladoraParam");
      if (!xmlParamTP) {
        if (!this.iface.clonarProcesoPorVar(xmlProceso, "TipoPeladoraVar")) {
          return false;
        }
        return true;
      }
      break;
    }
    case "CORTE": {
      /** <b>TAREA DE CORTE</b><br/>
      DESCRIPCIÓN<br/>
      Consiste en el corte de los pliegos para extraer los trabajos impresos.<br/>
      BIFURCACIÓN DE ITINERARIOS:<br/>
      No hay bifurcaciones
      */
      var codFormato: String = flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/PliegoParam@Formato");
      if (codFormato && codFormato != "") {
        if (codFormato.toLowerCase() == "sobre") {
          if (!this.iface.saltarTarea(xmlTarea)) {
            return false;
          }
        }
      }
      break;
    }
    case "PLEGADO": {
      /** <b>TAREA DE PLEGADO</b><br/>
      DESCRIPCIÓN<br/>
      Consiste en el corte de los pliegos para extraer los trabajos impresos.<br/>
      BIFURCACIÓN DE ITINERARIOS:<br/>
      No hay bifurcaciones<br/>
      TAREA OPCIONAL:<br/>
      La tarea se realiza cuando así se especifica en el parámetro PlegadoParam
      */
      var plieguesVer: Number = parseInt(flfacturac.iface.dameAtributoXML(xmlProceso, "Parametros/PlegadoParam@Verticales"));
      if (isNaN(plieguesVer))
        plieguesVer = 0;
      var plieguesHor: Number = parseInt(flfacturac.iface.dameAtributoXML(xmlProceso, "Parametros/PlegadoParam@Horizontales"));
      if (isNaN(plieguesHor))
        plieguesHor = 0;

      if (plieguesVer == 0 && plieguesHor == 0) {
        if (!this.iface.saltarTarea(xmlTarea))
          return false;
      } else {
        var xmlParamTD: FLDomNode = flfacturac.iface.pub_dameNodoXML(xmlProceso, "Parametros/TipoPlegadoraParam");
        if (!xmlParamTD) {
          if (!this.iface.clonarProcesoPorVar(xmlProceso, "TipoPlegadoraVar"))
            return false;
          return true;
        }
      }
      break;
    }
    case "PRECORTE ALZADO": { /// Corte previo al alzado
      var xmlProducto: FLDomNode = xmlProceso.parentNode();
      //      var opcion:String = xmlProducto.toElement().attribute("Opcion");
      //      var nodoCombi:FLDomNode = flfacturac.iface.pub_dameNodoXML(xmlProceso, "Parametros/CombEncuadernacionParam/Combinacion[@Opcion=" + opcion + "]");
      var nodoCombi: FLDomNode = flfacturac.iface.pub_dameNodoXML(xmlProceso, "Parametros/CombEncuadernacionParam/Combinacion");

      var tipoEncuadernacion: String = flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/EncuadernacionParam@Tipo");

      if (tipoEncuadernacion != "Wire-o" && nodoCombi.toElement().attribute("MaxPaginasPliego") == "4") {
        if (!this.iface.saltarTarea(xmlTarea)) {
          return false;
        }
      }
      var xmlParamG: FLDomNode = flfacturac.iface.pub_dameNodoXML(xmlProceso, "Parametros/TipoGuillotinaPAParam");
      if (!xmlParamG) {
        if (!this.iface.clonarProcesoPorVar(xmlProceso, "TipoGuillotinaPAVar")) {
          return false;
        }
        return true;
      }
      break;
    }
    case "PRECORTE W-O": { /// Corte previo al encuadernado con wire-o
      var xmlParamG: FLDomNode = flfacturac.iface.pub_dameNodoXML(xmlProceso, "Parametros/TipoGuillotinaPWOParam");
      if (!xmlParamG) {
        if (!this.iface.clonarProcesoPorVar(xmlProceso, "TipoGuillotinaPWOVar")) {
          return false;
        }
        return true;
      }
      break;
    }
    case "CORTE TRILATERAL": /// Corte posterior al grapado
    case "CORTE TRILATERAL2": {
      var xmlParamG: FLDomNode = flfacturac.iface.pub_dameNodoXML(xmlProceso, "Parametros/TipoGuillotinaTriParam");
      if (!xmlParamG) {
        if (!this.iface.clonarProcesoPorVar(xmlProceso, "TipoGuillotinaTriVar")) {
          return false;
        }
        return true;
      }
      break;
    }
    case "ALZADO":
    case "TACO_ALZADO": {
      var xmlParamTA: FLDomNode = flfacturac.iface.pub_dameNodoXML(xmlProceso, "Parametros/TipoAlzadoraParam");
      if (!xmlParamTA) {
        if (!this.iface.clonarProcesoPorVar(xmlProceso, "TipoAlzadoraVar")) {
          return false;
        }
        return true;
      }
      break;
    }
    case "ENCUADERNADO": {
      var xmlParamTE: FLDomNode = flfacturac.iface.pub_dameNodoXML(xmlProceso, "Parametros/TipoEncuadernadoraParam");
      if (!xmlParamTE) {
        if (!this.iface.clonarProcesoPorVar(xmlProceso, "TipoEncuadernadoraVar")) {
          return false;
        }
        return true;
      }
      break;
    }
    case "EMPAQUETADO": {
      break;
    }
    case "?ENCUADERNACION": {
      break;
    }
    case "EMBUCHADO": {
      /** <b>TAREA DE PLEGADO</b><br/>
      DESCRIPCIÓN<br/>
      Consiste en el embuchado manual de trabajos plegados unos en otros.<br/>
      */
      break;
    }
    case "GRAPADO":
    case "GRAPADO2": {
      /** <b>TAREA DE GRAPADO</b><br/>
      DESCRIPCIÓN<br/>
      Consiste en el grapado de libros con grapadora de mesa.<br/>
      */
      var xmlParamTG: FLDomNode = flfacturac.iface.pub_dameNodoXML(xmlProceso, "Parametros/TipoGrapadoraParam");
      if (!xmlParamTG) {
        if (!this.iface.clonarProcesoPorVar(xmlProceso, "TipoGrapadoraVar"))
          return false;
        return true;
      }
    }
    case "CORTE_FIN_ENC3": {
      break;
    }
    case "E+G+C": {
      var xmlParamTE: FLDomNode = flfacturac.iface.pub_dameNodoXML(xmlProceso, "Parametros/TipoEGCParam");
      if (!xmlParamTE) {
        if (!this.iface.clonarProcesoPorVar(xmlProceso, "TipoEGCVar"))
          return false;
        return true;
      }
      break;
    }
    case "WIRE-O":
    case "WIRE-O2": {
      var xmlParamWO: FLDomNode = flfacturac.iface.pub_dameNodoXML(xmlProceso, "Parametros/TipoMaquinaWireOParam");
      if (!xmlParamWO) {
        if (!this.iface.clonarProcesoPorVar(xmlProceso, "TipoMaquinaWireOVar")) {
          return false;
        }
        return true;
      }
      break;
    }
    case "POSCORTE W-O": {
      var encuadernacion: String = flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/EncuadernacionParam@Tipo");
      if (encuadernacion != "Wire-o") {
        if (!this.iface.saltarTarea(xmlTarea)) {
          return false;
        }
      }
      var xmlParamG: FLDomNode = flfacturac.iface.pub_dameNodoXML(xmlProceso, "Parametros/TipoGuillotinaPOSWOParam");
      if (!xmlParamG) {
        if (!this.iface.clonarProcesoPorVar(xmlProceso, "TipoGuillotinaPOSWOVar")) {
          return false;
        }
        return true;
      }
      break;
    }
    case "ENVIO": {
      var xmlParamAgencia: FLDomNode = flfacturac.iface.pub_dameNodoXML(xmlProceso, "Parametros/AgenciaTransporteParam");
      if (!xmlParamAgencia) {
        if (!this.iface.clonarProcesoPorVar(xmlProceso, "AgenciaTransporteVar")) {
          return false;
        }
        return true;
      }
    }
    default: {
      // debug("Datos de evaluación no encontrados para tarea " + tarea + " de proceso " + idTipoProceso);
    }
  }

  debug("continuando");
  if (!this.iface.continuarProceso(xmlProceso))
    return false;

  if (xmlProceso.toElement().attribute("Estado") == "")
  {
    xmlProceso.toElement().setAttribute("Estado", "OK");
  }

  return true;
}

/** \C
<br/><i><b>COSTES POR TAREA</b></i><br/>
*/
function artesG_ponCosteXmlTarea(xmlTarea: FLDomNode): Boolean {
  var util: FLUtil = new FLUtil;

  var idTipoTarea: String = xmlTarea.toElement().attribute("IdTipoTarea");
  var idTipoTareaPro: String = xmlTarea.toElement().attribute("IdTipoTareaPro");
  var codTipoTareaPro: String = xmlTarea.toElement().attribute("CodTipoTareaPro");
  var xmlProceso: FLDomNode = xmlTarea.parentNode().parentNode();
  var xmlProducto: FLDomNode = xmlProceso.parentNode();
  var costeMat: Number = 0;
  var tiempoMO: Number;
  var tiempoReal: Number = -1;
  var coste: Number;
  var instrucciones: String = "";
  var detalleCoste: String = "";
  var detalleCosteMat: String = "";
  var porBeneficio: Number;
  var porBeneficioMat: Number;
  var costeUT: Number
  var codTipoCentro: String;
  var numPasadas: Number = 0;

  var estado: String = flfacturac.iface.pub_dameAtributoXML(xmlTarea, "@Estado");
  //debug(estado);
  // debug("Inicio cálculo coste " + idTipoTarea);
  if (estado == "Saltada")
  {
    return true;
  }
  if (!this.iface.quitaDetalleTarea(xmlTarea, "Instrucciones"))
  {
    return false;
  }
  if (!this.iface.quitaDetalleTarea(xmlTarea, "DetalleCoste"))
  {
    return false;
  }
  debug("CodTipoTareaPro = " + codTipoTareaPro);
  debug("idTipoTarea = " + idTipoTarea);
  var tarea: String = ((codTipoTareaPro && codTipoTareaPro != "") ? codTipoTareaPro : idTipoTarea);
  debug("tarea = " + tarea);
  switch (tarea)
  {
    case "DISEÑO":
    case "TACO_DISEÑO": {
      /** <b>TAREA DE DISEÑO</b><br/>
      COSTE MANO DE OBRA<br/>
      Se aplica la fórmula CMO = ((Coste inicial + (Coste por Unidad x numPaginas)) x Coste por minuto) + Beneficio, donde:<br/>
      <ul>
      <li>Coste inicial, Coste por unidad y Coste por minuto son parámetros asociados al tipo de centro de  coste DISEÑADOR</li>
      <li>numPaginas es el número de modelos del trabajo. Si el trabajo es a dos caras el número de modelos se multiplica por dos</li>
      <li>Beneficio es el resultado de aplicar el porcentaje de beneficio asociado al centro de coste al primer sumando de la fórmula</li>
      </ul>
      COSTE MATERIAL:<br/>
      No hay coste de material en esta tarea
      */
      instrucciones += util.translate("scripts", "\nSe usarán planchas %1 de %2.").arg(flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/TipoImpresoraParam@RefPlancha")).arg(flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/TipoImpresoraParam@AreaPlancha"));

      var estiloImpresion: String = flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/EstiloImpresionParam@Valor");
      instrucciones += util.translate("scripts", "\nSe usará el estilo de impresión %1.").arg(estiloImpresion);

      if (estiloImpresion == "TiraRetira") {
        instrucciones += util.translate("scripts", " sobre el eje de simetría %2.").arg(flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/EstiloImpresionParam@EjeSim"));
      }

      instrucciones += this.iface.instruccionesJuegosPlancha(xmlProceso);

      var diseno: Boolean = (flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/DisenoParam@Valor") == "true");
      var tiempoUsuario: Number = parseFloat(flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/DisenoParam@TiempoUsuario"));
      if (isNaN(tiempoUsuario)) {
        tiempoUsuario = 0;
      }

      codTipoCentro = "DISEÑADOR";
      xmlTarea.toElement().setAttribute("CodTipoCentro", codTipoCentro);
      // debug(codTipoCentro);
      var costesDiseno: Array = this.iface.costesPorCentroTarea(codTipoCentro, idTipoTareaPro);
      if (!costesDiseno)
        return false;

      if (tiempoUsuario != 0) {
        instrucciones += util.translate("scripts", "\nSe emplearán %1 minutos en el diseño (tiempo indicado manualmente por el usuario)").arg(tiempoUsuario);
        tiempoMO = tiempoUsuario;
      } else {
        var xmlParamDisenador: FLDomNode = flfacturac.iface.pub_dameParamCentroCoste(codTipoCentro);
        if (!xmlParamDisenador)
          return false;

        var dosCaras: Boolean = (flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/ColoresParam@DosCaras") == "true");
        if (diseno) {
          var tiempoModelo: Number = parseFloat(xmlParamDisenador.toElement().attribute("TiempoModelo"));
          if (isNaN(tiempoModelo)) {
            // debug("!tiempoModelo en coste de DISEÑO");
            return false;
          }
          var numPaginas: Number = parseInt(flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/PaginasParam@NumPaginas"));

          instrucciones += util.translate("scripts", "\nSe diseñarán %1 páginas de tamaño %2.").arg(numPaginas).arg(flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/AreaTrabajoParam@Valor"));
          if (dosCaras) {
            instrucciones += util.translate("scripts", "\nEl trabajo es a dos caras");
            detalleCoste += util.translate("scripts", "\nCOSTE MANO DE OBRA:\nFórmula: TInicial de %1 + (numPaginas x TPagina de %2 x 2 caras)").arg(codTipoCentro).arg(codTipoCentro);
            tiempoMO = costesDiseno["inicial"] + (numPaginas * costesDiseno["unidad"] * 2);
            detalleCoste += util.translate("scripts", "\n%1 + (%2 x %3 x 2) = %3").arg(costesDiseno["inicial"]).arg(numPaginas).arg(util.roundFieldValue(tiempoModelo, "pr_paramdisenador", "tiempomodelo")).arg(util.roundFieldValue(tiempoMO, "tareaslp", "costemo"));
          } else {
            instrucciones += util.translate("scripts", "\nEl trabajo es a una cara");
            tiempoMO = costesDiseno["inicial"] + (numPaginas * costesDiseno["unidad"]);
            detalleCoste += util.translate("scripts", "\n%1 + (%2 x %3) = %3").arg(costesDiseno["inicial"]).arg(numPaginas).arg(util.roundFieldValue(tiempoModelo, "pr_paramdisenador", "tiempomodelo")).arg(util.roundFieldValue(tiempoMO, "tareaslp", "costemo"));
          }
        } else {
          instrucciones += util.translate("scripts", "\nNo hay trabajos de diseño (sólo de ajustes)");
          var tiempoAjusteTrab: Number = parseFloat(xmlParamDisenador.toElement().attribute("TiempoAjusteTrab"));
          if (isNaN(tiempoAjusteTrab)) {
            // debug("!tiempoAjusteTrab en coste de DISEÑO");
            return false;
          }
          var trabajoPI: Number = parseInt(flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/TrabajosPliegoParam@NumTrabajos"))
                                  var numPaginas: Number = parseInt(flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/PaginasParam@NumPaginas"))
                                                           var factorCaras: Number;
          if (dosCaras) {
            factorCaras = 2;
          } else {
            factorCaras = 1;
          }
          detalleCoste += util.translate("scripts", "\nCOSTE MANO DE OBRA:\nFórmula: TAjustePorTrabajo x NumTrabajosPliego x NumPáginas x NumCaras");
          tiempoMO = tiempoAjusteTrab * trabajoPI * numPaginas * factorCaras;
          detalleCoste += util.translate("scripts", "\n%1 x %2 x %3 x %4 = %5").arg(util.roundFieldValue(tiempoAjusteTrab, "pr_paramdisenador", "tiempoajustetrab")).arg(trabajoPI).arg(numPaginas).arg(factorCaras).arg(util.roundFieldValue(tiempoMO, "tareaslp", "costemo"));

          var tiempoMinimo: Number = costesDiseno["tiempominimo"];
          if (isNaN(tiempoMinimo)) {
            tiempoMinimo = 0;
          }
          if (tiempoMO < tiempoMinimo) {
            tiempoReal = tiempoMO;
            tiempoMO = tiempoMinimo;
            detalleCoste += util.translate("scripts", "\nAplicando tiempo mínimo de %1: Tiempo = %2").arg(codTipoCentro).arg(tiempoMinimo);
          }

          //          var minAjusteTrab:Number = parseFloat(xmlParamDisenador.toElement().attribute("MinAjusteTrab"));
          //          if (tiempoAjusteTrab && !isNaN(tiempoAjusteTrab)) {
          //            if (minAjusteTrab > tiempoMO) {
          //              detalleCoste += util.translate("scripts", "\nAplicando mínimo tiempo de ajuste para %1: %2").arg(codTipoCentro).arg(util.roundFieldValue(minAjusteTrab, "pr_paramdisenador", "minajustetrab"));
          //              tiempoReal = tiempoMO;
          //              tiempoMO = minAjusteTrab;
          //            }
          //          }
        }
      }

      costeUT = parseFloat(costesDiseno["costetiempo"]);
      porBeneficio = parseFloat(costesDiseno["porbeneficio"]);

      break;
    }
    case "PLANCHAS":
    case "TACO_PLANCHAS": {
      /** <b>TAREA DE DISEÑO</b><br/>
      COSTE MANO DE OBRA<br/>
      Se aplica la fórmula CMO = ((Coste inicial + (Coste por Unidad x numPlanchas)) x Coste por minuto) + Beneficio, donde:<br/>
      <ul>
      <li>Coste inicial, Coste por unidad y Coste por minuto son parámetros asociados al tipo de centro de  coste PLANCHAS</li>
      <li>numPlanchas es el número de planchas necesarias para realizar el trabajo (atributo numPlanchas del parámetro DistPlanchasParam</li>
      <li>Beneficio es el resultado de aplicar el porcentaje de beneficio asociado al centro de coste al primer sumando de la fórmula</li>
      </ul>
      */
      var xmlDistPlanchas: FLDomNode = flfacturac.iface.pub_dameNodoXML(xmlProceso, "Parametros/DistPlanchaParam");
      if (!xmlDistPlanchas) {
        MessageBox.warning(util.translate("scripts", "Error al obtener el nodo de distribución de planchas"), MessageBox.Ok, MessageBox.NoButton);
        return false;
      }
      if (!flfacturac.iface.calcularPasadasPorPlancha(xmlDistPlanchas, xmlProceso))
        return false;

      instrucciones += this.iface.instruccionesJuegosPlancha(xmlProceso);
      //xmlDistPlanchas.appendChild(xmlOpcionColor.cloneNode());

      codTipoCentro = "PLANCHAS";
      xmlTarea.toElement().setAttribute("CodTipoCentro", codTipoCentro);
      var costesPlanchaMO: Array = this.iface.costesPorCentroTarea(codTipoCentro, idTipoTareaPro);
      if (!costesPlanchaMO)
        return false;

      var numPlanchas: Number = parseInt(flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/DistPlanchaParam@NumPlanchas"));

      detalleCoste += util.translate("scripts", "\nCOSTE MANO DE OBRA:\nFórmula: TInicial de %1 + (numPlanchas x TUnidad de %2)").arg(codTipoCentro).arg(codTipoCentro);
      tiempoMO = costesPlanchaMO["inicial"] + (numPlanchas * costesPlanchaMO["unidad"]);
      detalleCoste += util.translate("scripts", "\n%1 + (%2 x %3) = %3").arg(costesPlanchaMO["inicial"]).arg(numPlanchas).arg(costesPlanchaMO["unidad"]).arg(util.roundFieldValue(tiempoMO, "tareaslp", "costemo"));

      var tiempoMinimo: Number = costesPlanchaMO["tiempominimo"];
      if (isNaN(tiempoMinimo)) {
        tiempoMinimo = 0;
      }
      if (tiempoMO < tiempoMinimo) {
        tiempoReal = tiempoMO;
        tiempoMO = tiempoMinimo;
        detalleCoste += util.translate("scripts", "\nAplicando tiempo mínimo de %1: Tiempo = %2").arg(codTipoCentro).arg(tiempoMinimo);
      }

      costeUT = parseFloat(costesPlanchaMO["costetiempo"]);
      porBeneficio = parseFloat(costesPlanchaMO["porbeneficio"]);

      /** COSTE MATERIAL:<br/>
      Se aplica la fórmula CM = Coste Plancha x numPlanchas, donde:<br/>
      <ul>
      <li>Coste Plancha es el coste medio del artículo plancha usado (atributo RefPlancha del parámetro TipoImpresoraParam)</li>
      <li>numPlanchas es el número de planchas necesarias para realizar el trabajo (atributo numPlanchas del parámetro DistPlanchasParam</li>
      </ul>
      */
      var refPlancha: String = flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/TipoImpresoraParam@RefPlancha");
      var datosArticulo: Array = flfactppal.iface.ejecutarQry("articulos a INNER JOIN familias f ON a.codfamilia = f.codfamilia", "a.costemedio,f.codfamilia,f.porbeneficio", "a.referencia = '" + refPlancha + "'" , "articulos,familias");
      if (datosArticulo["result"] != 1) {
        MessageBox.warning(util.translate("scripts", "Error al obtener los datos de familia y beneficio para el artículo %1").arg(refPlancha), MessageBox.Ok, MessageBox.NoButton);
        return false;
      }

      detalleCosteMat += util.translate("scripts", "\nCOSTE MATERIAL:\nFórmula: Coste Plancha x numPlanchas");

      var costePlancha: Number = parseFloat(datosArticulo["a.costemedio"]) * (100 + parseFloat(datosArticulo["f.porbeneficio"])) / 100;
      costePlancha = util.roundFieldValue(costePlancha, "consumoslp", "costeunidad");
      detalleCosteMat += util.translate("scripts", "\nCostePlancha = CosteMedio de %1 aplicando beneficio de %2").arg(refPlancha).arg(datosArticulo["f.porbeneficio"]);
      detalleCosteMat += util.translate("scripts", "\n%1 x (100 + %2) / 100 = %3").arg(datosArticulo["a.costemedio"]).arg(datosArticulo["f.porbeneficio"]).arg(costePlancha);


      costeMat = costePlancha * numPlanchas;
      detalleCosteMat += util.translate("scripts", "\nCostePlancha = CostePlancha * NumPlanchas");
      detalleCosteMat += util.translate("scripts", "\n%1 x %2 = %3").arg(costePlancha).arg(numPlanchas).arg(util.roundFieldValue(costeMat, "tareaslp", "costemat"));

      if (!this.iface.ponConsumoTarea(xmlTarea, refPlancha, numPlanchas, datosArticulo["a.costemedio"], false, datosArticulo["f.porbeneficio"])) {
        return false;
      }
      break;
    }
    case "PRECORTE": {
      /** <b>TAREA DE CORTE PREVIO (PRECORTE)</b><br/>
      COSTE MANO DE OBRA<br/>
      Se aplica la fórmula CMO = ((Coste inicial + (Coste por Unidad x numCortes)) x Coste por minuto) + Beneficio, donde:<br/>
      <ul>
      <li>Coste inicial, Coste por unidad y Coste por minuto son parámetros asociados al tipo de centro de  coste CORTE para la tarea PRECORTE</li>
      <li>numCortes es el número de cortes a realizar sobre el pliego para obtener los pliegos de impresión que entrarán en la prensa (atributo Corte del parámetro PliegoImpresionParam)</li>
      <li>Beneficio es el resultado de aplicar el porcentaje de beneficio asociado al centro de coste al primer sumando de la fórmula</li>
      </ul>
      COSTE MATERIAL:<br/>
      No hay coste de material en esta tarea
      */
      codTipoCentro = "GUILLOTINA";
      xmlTarea.toElement().setAttribute("CodTipoCentro", codTipoCentro);
      var xmlParamGuillotina: FLDomNode = flfacturac.iface.pub_dameParamCentroCoste(codTipoCentro);
      if (!xmlParamGuillotina) {
        return false;
      }
      var maxGrosorCM: Number = parseFloat(flfacturac.iface.pub_dameAtributoXML(xmlParamGuillotina, "@MaxGrosorCm"));
      if (!maxGrosorCM || maxGrosorCM == 0) {
        MessageBox.warning(util.translate("scripts", "No tiene configurado el atributo MaxGrosorCm (máximo grosor que admite la guillotina)\npara el tipo de centro de coste %1").arg(codTipoCentro), MessageBox.Ok, MessageBox.NoButton);
        return false;
      }
      var costesCorteMO: Array = this.iface.costesPorCentroTarea(codTipoCentro, idTipoTareaPro);
      if (!costesCorteMO) {
        return false;
      }
      var cortes: String = flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/PliegoImpresionParam@Corte");
      if (cortes == "1x1") {
        tiempoMO = 0;
        break;
      }
      var numPliegos: Number = this.iface.pliegosImpresionIptico(xmlProceso);

      var refPliego: String = flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/PliegoParam@Ref");

      var numCortes: Number = (cortes.split("x")[0] - 1) + (cortes.split("x")[1] - 1);
      var factor: Number = parseInt(flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/PliegoImpresionParam@Factor"));

      instrucciones += util.translate("scripts", "\nSe realizarán %1 cortes en un esquema %2 sobre pliegos tipo %3 de tamaño %4 para obtener %5 pliegos de impresión de tamaño %6").arg(numCortes).arg(cortes).arg(refPliego).arg(flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/PliegoParam@AreaPliego")).arg(factor).arg(flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/PliegoImpresionParam@Valor"));

      var gramaje: Number = flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/GramajeParam@Valor");
      var grosorPliego: Number = parseFloat(util.sqlSelect("articulos", "grosorunidad", "referencia = '" + refPliego + "'"));
      if (isNaN(grosorPliego)) {
        return false;
      }
      numPliegos = numPliegos / factor;

      var anchoACortar = numPliegos * grosorPliego;
      var numTandas: Number = Math.ceil(anchoACortar / maxGrosorCM);
      var pliegosTanda: Number = Math.ceil(numPliegos / numTandas);

      instrucciones += util.translate("scripts", "\nSe cortarán %1 pliegos en %2 tandas de %3 pliegos cada una para obtener %4 pliegos de impresión").arg(numPliegos).arg(numTandas).arg(pliegosTanda).arg(numPliegos * factor);

      detalleCoste += util.translate("scripts", "\nCOSTE MANO DE OBRA:\nFórmula: TInicial de %1 + (numCortes x numTandas x TCorte de %2)").arg(codTipoCentro).arg(codTipoCentro);

      tiempoMO = costesCorteMO["inicial"] + numCortes * numTandas * costesCorteMO["unidad"];
      detalleCoste += util.translate("scripts", "\n%1 + (%2 x %3 x %4) = %5").arg(costesCorteMO["inicial"]).arg(numCortes).arg(numTandas).arg(costesCorteMO["unidad"]).arg(tiempoMO);

      costeUT = parseFloat(costesCorteMO["costetiempo"]);
      porBeneficio = parseFloat(costesCorteMO["porbeneficio"]);

      break;
    }
    case "TACO_PRECORTE": {
      codTipoCentro = "GUILLOTINA";
      xmlTarea.toElement().setAttribute("CodTipoCentro", codTipoCentro);
      var xmlParamGuillotina: FLDomNode = flfacturac.iface.pub_dameParamCentroCoste(codTipoCentro);
      if (!xmlParamGuillotina) {
        return false;
      }
      var maxGrosorCM: Number = parseFloat(flfacturac.iface.pub_dameAtributoXML(xmlParamGuillotina, "@MaxGrosorCm"));
      if (!maxGrosorCM || maxGrosorCM == 0) {
        MessageBox.warning(util.translate("scripts", "No tiene configurado el atributo MaxGrosorCm (máximo grosor que admite la guillotina)\npara el tipo de centro de coste %1").arg(codTipoCentro), MessageBox.Ok, MessageBox.NoButton);
        return false;
      }
      var costesCorteMO: Array = this.iface.costesPorCentroTarea(codTipoCentro, idTipoTareaPro);
      if (!costesCorteMO) {
        return false;
      }
      var cortes: String = flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/PliegoImpresionParam@Corte");
      if (cortes == "1x1") {
        tiempoMO = 0;
        break;
      }

      var numCortes: Number = (cortes.split("x")[0] - 1) + (cortes.split("x")[1] - 1);
      var factor: Number = parseInt(flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/PliegoImpresionParam@Factor"));
      var numPliegos: Number = this.iface.pliegosImpresionIptico(xmlProceso)
                               var numPliegosCorte: Number = numPliegos / factor;
      var gramaje: Number = flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/GramajeParam@Valor");

      var nodoPapelParam: FLDomNode = flfacturac.iface.pub_dameNodoXML(xmlProceso, "Parametros/PapelParam");
      var ePapelParam: FLDomElement = nodoPapelParam.toElement();
      var areaPliego: String = ePapelParam.attribute("AreaPliego");
      // var refPliego:String = flfacturac.iface.pub_dameAtributoXML(nodoPapelParam, "Capa@Ref"); /// Se toma el papel de la primera capa para el cálculo
      //      var numCapas:Number = parseInt(ePapelParam.attribute("Capas"));

      var ePapel: FLDomElement, refPliego: String, grosorPliego: Number, tiempoPapel: Number, anchoACortar: Number, numTandas: Number, pliegosTanda: Number;
      tiempoMO = 0;
      detalleCoste += "\n" + util.translate("scripts", "COSTE MANO DE OBRA:\nFórmula: TInicial de %1 + (numCortes x numTandas x TCorte de %2)").arg(codTipoCentro).arg(codTipoCentro);
      instrucciones += "\n" + util.translate("scripts", "Se realizarán %1 cortes en un esquema %2 sobre pliegos de tamaño %3 para obtener %4 pliegos de impresión de tamaño %5").arg(numCortes).arg(cortes).arg(areaPliego).arg(factor).arg(flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/PliegoImpresionParam@Valor"));

      for (var nodoPapel: FLDomNode = nodoPapelParam.firstChild(); nodoPapel; nodoPapel = nodoPapel.nextSibling()) {
        if (nodoPapel.nodeName() != "Papel") {
          continue;
        }
        ePapel = nodoPapel.toElement();
        refPliego = ePapel.attribute("Ref");

        grosorPliego = parseFloat(util.sqlSelect("articulos", "grosorunidad", "referencia = '" + refPliego + "'"));
        if (isNaN(grosorPliego)) {
          return false;
        }

        anchoACortar = numPliegosCorte * grosorPliego;
        numTandas = Math.ceil(anchoACortar / maxGrosorCM);
        pliegosTanda = Math.ceil(numPliegos / numTandas);

        instrucciones += "\n" + util.translate("scripts", "Papel %1: Se cortarán %2 pliegos en %3 tandas de %4 pliegos cada una para obtener %5 pliegos de impresión").arg(refPliego).arg(numPliegos).arg(numTandas).arg(pliegosTanda).arg(numPliegos * factor);

        tiempoPapel = costesCorteMO["inicial"] + numCortes * numTandas * costesCorteMO["unidad"];
        detalleCoste += "\n" + util.translate("scripts", "Papel %1: %2 + (%3 x %4 x %5) = %6").arg(refPliego).arg(costesCorteMO["inicial"]).arg(numCortes).arg(numTandas).arg(costesCorteMO["unidad"]).arg(tiempoPapel);

        tiempoMO += parseFloat(tiempoPapel);
      }
      detalleCoste += "\n" + util.translate("scripts", "Tiempo total = %1").arg(tiempoMO);

      costeUT = parseFloat(costesCorteMO["costetiempo"]);
      porBeneficio = parseFloat(costesCorteMO["porbeneficio"]);

      break;
    }
    case "TACO_IMPRESION": {
      /** <b>TAREA DE IMPRESIÓN</b><br/>
      COSTE MANO DE OBRA<br/>
      Se aplica la fórmula CMO = ((Coste inicial + (Coste por copia x numPasadas) + (Coste por plancha x numPlanchasExtra) + Coste final) x Coste por minuto) + Beneficio, donde:<br/>
      <ul>
      <li>Coste inicial, Coste por copia y Coste final son parámetros asociados al tipo de centro de coste de tipo A.G. Prensa asociado a la prensa seleccionada (TipoImpresoraParam) y al estilo de impresión (EstiloImpresionParam) </li>
      <li>numPlanchasExtra es el número de planchas que no se colocan en la configuración inicial, calculado como número total de planchas menos número de cuerpos</li>
      <li>Coste por minuto es un valor asociado al tipo de centro de coste de tipo A.G. Prensa asociado a la prensa seleccionada</li>
      <li>numPasadas es el número de pliegos de impresión que pasarán por la prensa (atributo NumPasadas del parámetro DistPlanchaParam)</li>
      <li>Beneficio es el resultado de aplicar el porcentaje de beneficio asociado al centro de coste al primer sumando de la fórmula</li>
      </ul>
      */
      instrucciones += util.translate("scripts", "\nEl trabajo se imprimirá en la impresora %1 usando planchas %2 de %3.").arg(flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/TipoImpresoraParam@Valor")).arg(flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/TipoImpresoraParam@RefPlancha")).arg(flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/TipoImpresoraParam@AreaPlancha"));

      instrucciones += util.translate("scripts", "\nSe usará el estilo de impresión %1.").arg(flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/EstiloImpresionParam@Valor"));

      //      instrucciones += this.iface.instruccionesPlanchas(xmlProceso);

      codTipoCentro = flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/TipoImpresoraParam@Valor");
      xmlTarea.toElement().setAttribute("CodTipoCentro", codTipoCentro);

      var costesImpresionMO: Array = this.iface.costesPorCentroTarea(codTipoCentro, idTipoTareaPro);
      if (!costesImpresionMO)
        return false;

      var estiloImpresion: String = flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/EstiloImpresionParam@Valor");
      var dimPIS: String = flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/PliegoImpresionParam@Valor");

      var nodoPapelParam: FLDomNode = flfacturac.iface.pub_dameNodoXML(xmlProceso, "Parametros/PapelParam");
      var ePapelParam: FLDomElement = nodoPapelParam.toElement();
      var refPliego: String = flfacturac.iface.pub_dameAtributoXML(nodoPapelParam, "Capa@Ref"); /// Se toma el papel de la primera capa para el cálculo
      var numCapas: Number = parseInt(ePapelParam.attribute("Capas"));
      var formatoPliego: String = util.sqlSelect("articulos", "codformato", "referencia = '" + refPliego + "'");
      if (!formatoPliego) {
        formatoPliego = "";
      }
      var xmlParamImpresora: FLDomNode = flfacturac.iface.pub_dameParamCentroCoste(codTipoCentro);
      if (!xmlParamImpresora) {
        MessageBox.warning(util.translate("scripts", "Error al obtener los parámetros de la impresora %1").arg(codTipoCentro), MessageBox.Ok, MessageBox.NoButton);
        return false;
      }

      var numPasadas: Number = flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/DistPlanchaParam@NumPasadas");
      var numPlanchas: Number = flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/DistPlanchaParam@NumPlanchas");

      var numCuerpos: Number = parseInt(xmlParamImpresora.toElement().attribute("NumCuerpos"));
      if (isNaN(numCuerpos)) {
        numCuerpos = 0;
      }
      var numPlanchasExtra = numPlanchas - numCuerpos;
      if (numPlanchasExtra < 0) {
        numPlanchasExtra = 0;
      }

      //      var tiempoPlancha:Number = parseFloat(xmlParamImpresora.toElement().attribute("TiempoPlancha"));
      //      if (isNaN(tiempoPlancha))
      //        tiempoPlancha = 0;

      var xmlListaCostes: FLDomNodeList = xmlParamImpresora.toElement().elementsByTagName("Coste");
      if (!xmlListaCostes) {
        MessageBox.warning(util.translate("scripts", "Error al obtener los costes de la impresora %1").arg(codTipoCentro), MessageBox.Ok, MessageBox.NoButton);
        return false;
      }
      var iDefecto: Number = -1;
      var iDefectoEstilo: Number = -1;
      var iDefectoFormato: Number = -1;
      var iEstiloFormato: Number = -1;
      var eCoste: FLDomElement;
      for (var i: Number = 0; i < xmlListaCostes.length(); i++) {
        eCoste = xmlListaCostes.item(i).toElement();
        if (numPasadas < parseInt(eCoste.attribute("CopiasMin"))) {
          continue;
        }
        if (eCoste.attribute("CopiasMax") != "" && numPasadas > parseInt(eCoste.attribute("CopiasMax"))) {
          continue;
        }
        if (eCoste.attribute("EstiloImpresion") == estiloImpresion && eCoste.attribute("Formato") == formatoPliego) {
          iEstiloFormato = i;
          break;
        } else if (eCoste.attribute("EstiloImpresion") == "Defecto" && eCoste.attribute("Formato") == formatoPliego) {
          iDefectoEstilo = i;
        } else if (eCoste.attribute("EstiloImpresion") == estiloImpresion && eCoste.attribute("Formato") == "") {
          iDefectoFormato = i;
        } else if (eCoste.attribute("EstiloImpresion") == "Defecto" && eCoste.attribute("Formato") == "") {
          iDefecto = i;
        }
      }
      if (iEstiloFormato == -1) {
        if (iDefectoEstilo > -1) {
          iEstiloFormato = iDefectoEstilo;
        } else if (iDefectoFormato > -1) {
          iEstiloFormato = iDefectoFormato;
        } else if (iDefecto > -1) {
          iEstiloFormato = iDefecto;
        } else {
          MessageBox.warning(util.translate("scripts", "Tarea de impresión:\nNo se ha encontrado un registro de tiempos para los siguientes valores:\nImpresora: %1\nEstilo: %2 \nFormato papel: %3\nPasadas: %4\nEsto hará que los cálculos no sean exactos.").arg(codTipoCentro).arg(estiloImpresion).arg(formatoPliego).arg(numPasadas), MessageBox.Ok, MessageBox.NoButton);
          return false;
        }
      }
      var costeArranque: Number = 0;
      var costePorCopia: Number = 0;
      var costeFin: Number = 0;
      var intervalo: String = util.translate("scripts", "-Indefinido-");
      var copiasHora: Number = 0;
      var maculasPlancha: Number;
      var tiempoPlancha: Number;
      if (iEstiloFormato >= 0) {
        eCoste = xmlListaCostes.item(iEstiloFormato).toElement();
        costeArranque = eCoste.attribute("Arranque");
        if (isNaN(costeArranque) || costeArranque == "")
          costeArranque = 0;

        costePorCopia = eCoste.attribute("PorCopia");
        if (isNaN(costePorCopia) || costePorCopia == "")
          costePorCopia = 0;
        copiasHora = costePorCopia;
        if (copiasHora == 0) {
          MessageBox.warning(util.translate("scripts", "El centro de coste %1 tiene definida una velocidad de 0 copias por hora.\nEsto hace inviable el cálculo de costes.").arg(codTipoCentro), MessageBox.Ok, MessageBox.NoButton);
          return false;
        }
        costePorCopia = 60 / copiasHora;

        costeFin = eCoste.attribute("Fin");
        if (isNaN(costeFin) || costeFin == "")
          costeFin = 0;

        maculasPlancha = parseInt(eCoste.attribute("MaculasPlancha"));
        tiempoPlancha = parseFloat(eCoste.attribute("TiempoPlancha"));
        intervalo = eCoste.attribute("CopiasMin") + " - " + eCoste.attribute("CopiasMax");
      }
      // debug("IestiloFormato  = " + iEstiloFormato);
      detalleCoste += util.translate("scripts", "\nCOSTE MANO DE OBRA:\nFórmula: Capas x [TInicial de %1 + (numPasadas x TPasada de %2) + (numPlanchasExtra x TPlancha) + TFinal de %3].").arg(codTipoCentro).arg(codTipoCentro).arg(codTipoCentro);
      detalleCoste += util.translate("scripts", "\n(los costes son los asociados al estilo %1,  al formato '%2' y al intervalo de copias %3, a %4 copias/hora).").arg(estiloImpresion).arg(formatoPliego).arg(intervalo).arg(copiasHora);
      tiempoMO = numCapas * (parseFloat(costeArranque) + (parseFloat(costePorCopia) * parseFloat(numPasadas)) + (parseFloat(numPlanchasExtra) * parseFloat(tiempoPlancha)) + parseFloat(costeFin));

      costePorCopia = Math.round(costePorCopia * 10000);
      costePorCopia = costePorCopia / 10000;
      detalleCoste += util.translate("scripts", "\n%1 x [%2 + (%3 x %4) + (%5 x %6) + %7] = %7").arg(numCapas).arg(costeArranque).arg(numPasadas).arg(costePorCopia).arg(numPlanchasExtra).arg(util.roundFieldValue(tiempoPlancha, "pr_costesestilosimp", "tiempoplancha")).arg(costeFin).arg(util.roundFieldValue(tiempoMO, "tareaslp", "costemo"));

      var dimPliego: Array = dimPIS.split("x");
      var xmlDimOptimas: FLDomNodeList = xmlParamImpresora.toElement().elementsByTagName("DimOptima");
      if (xmlDimOptimas) {
        var eDO: FLDomElement;
        var dimOptima: Boolean = false;
        for (var i: Number = 0; i < xmlDimOptimas.length(); i++) {
          eDO = xmlDimOptimas.item(i).toElement();
          if ((parseFloat(eDO.attribute("Alto")) == parseFloat(dimPliego[0]) && parseFloat(eDO.attribute("Ancho")) == parseFloat(dimPliego[1])) || (parseFloat(eDO.attribute("Alto")) == parseFloat(dimPliego[1]) && parseFloat(eDO.attribute("Ancho")) == parseFloat(dimPliego[0]))) {
            dimOptima = true;
            break;
          }
        }
        if (!dimOptima) {
          var penalizacion: String = xmlParamImpresora.namedItem("DimOptimas").toElement().attribute("Penalizacion");
          tiempoMO += (parseFloat(penalizacion) * numCapas);
          detalleCoste += util.translate("scripts", "\nAplicando penalización por dimensión no óptima de %1 x %2 capas. Coste = %3").arg(penalizacion).arg(numCapas).arg(tiempoMO);
        }
      }

      var datosPantones: Array = this.iface.dameTiempoExtraPantone(xmlParamImpresora, xmlProceso);
      if (!datosPantones) {
        return false;
      }
      if (datosPantones["tiempototal"] > 0) {
        tiempoMO += (parseFloat(datosPantones["tiempototal"]) * numCapas);
        detalleCoste += util.translate("scripts", "\nTiempo extra por pantone: (%1 x %2 pantones) x %3 capas = %4. Total = %5").arg(datosPantones["tiempopantone"]).arg(datosPantones["numpantones"]).arg(numCapas).arg(datosPantones["tiempototal"]).arg(util.roundFieldValue(tiempoMO, "tareaslp", "costemo"));
      }

      var tiempoMinProd: Number = costesImpresionMO["tiempominimo"]; //xmlParamImpresora.toElement().attribute("TiempoMinProd");
      if (isNaN(tiempoMinProd)) {
        tiempoMinProd = 0;
      }
      var tiempoMinProdTotal: Number = (parseFloat(tiempoMinProd) + parseFloat((numPlanchasExtra * tiempoPlancha))) * numCapas;
      if (tiempoMO < tiempoMinProdTotal) {
        tiempoReal = tiempoMO;
        tiempoMO = tiempoMinProdTotal;
        detalleCoste += util.translate("scripts", "\nAplicando tiempo mínimo de producción: (%1 + Tiempo planchas extra %2 x %3) x %4 capas = %5").arg(tiempoMinProd).arg(numPlanchasExtra).arg(tiempoPlancha).arg(numCapas).arg(tiempoMinProdTotal);
      }

      var costeTiempo: Number = parseFloat(costesImpresionMO["costetiempo"]);
      if (isNaN(costeTiempo)) {
        costeTiempo = 0;
      }
      porBeneficio = parseFloat(costesImpresionMO["porbeneficio"]);
      if (isNaN(porBeneficio)) {
        porBeneficio = 0;
      }
      costeUT = parseFloat(costeTiempo);
      porBeneficio = parseFloat(porBeneficio);

      /** COSTE MATERIAL:<br/>
      Se aplica la fórmula CM = Coste Pliego x numPliegos, donde:<br/>
      <ul>
      <li>Coste Pliego es el coste medio del artículo pliego usado (atributo Ref del parámetro PliegoImpresionParam)</li>
      <li>numPliegos es el número de pliegos (de pliegos sin cortar) utilizados</li>
      </ul>
      */
      var xmlParamPI: FLDomNode = flfacturac.iface.pub_dameNodoXML(xmlProceso, "Parametros/PliegoImpresionParam");
      var factor: Number = flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/PliegoImpresionParam@Factor");

      var xmlParamDP: FLDomNode = flfacturac.iface.pub_dameNodoXML(xmlProceso, "Parametros/DistPlanchaParam");
      detalleCosteMat += util.translate("scripts", "\nCOSTE MATERIAL:\nFórmula: Coste Pliego x numPliegos");

      var numPliegos: Number = this.iface.pliegosImpresionIptico(xmlProceso);
      detalleCosteMat += util.translate("scripts", "\nNumPliegosImpresion = %1").arg(numPliegos);

      var numMaculas: Number;
      var maculasManual: Boolean = (flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/MaculasParam@MaculasManual") == "true");
      if (maculasManual) {
        numMaculas = parseInt(flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/MaculasParam@TotalMaculas"));
        detalleCosteMat += util.translate("scripts", "\nNumMaculas (cálculo manual) = %1").arg(numMaculas);
      } else {
        numMaculas = numPlanchas * maculasPlancha;
        detalleCosteMat += util.translate("scripts", "\nNumMaculas = NumPlanchas x MaculasPlancha");
        detalleCosteMat += util.translate("scripts", "\n%1 x %2 = %3").arg(numPlanchas).arg(maculasPlancha).arg(numMaculas);
      }
      var totalMaculas: Number = Math.ceil(numMaculas / factor);

      var totalPliegosImpresion: Number = numPliegos + numMaculas;
      detalleCosteMat += util.translate("scripts", "\nTotalPliegosImpresion = NumPliegosImpresion + NumMaculas");
      detalleCosteMat += util.translate("scripts", "\n%1 + %2 = %3").arg(numPliegos).arg(numMaculas).arg(totalPliegosImpresion);

      var totalPliegos = Math.ceil(totalPliegosImpresion / factor);
      detalleCosteMat += util.translate("scripts", "\nTotalPliegos = TotalPliegosImpresion / factorPrecorte");
      detalleCosteMat += util.translate("scripts", "\n%1 / %2 = %3").arg(totalPliegosImpresion).arg(factor).arg(totalPliegos);

      var lCapas: FLDomNodeList = ePapelParam.elementsByTagName("Papel");
      var costePliego: Number, costeCapa: Number, refCapa: String, datosArticulo: Array;
      var costeMat: Number = 0;
      for (var iCapa: Number = 0; iCapa < lCapas.length(); iCapa++) {
        refCapa = lCapas.item(iCapa).toElement().attribute("Ref");

        instrucciones += "\n" + util.translate("scripts", "Papel %1: Se usarán %2 pliegos de impresión (%3 para impresión + %4 para máculas)").arg(refCapa).arg(totalPliegosImpresion).arg(numPliegos).arg(numMaculas);

        datosArticulo = flfactppal.iface.ejecutarQry("articulos a INNER JOIN familias f ON a.codfamilia = f.codfamilia", "a.costemedio,f.codfamilia,f.porbeneficio", "a.referencia = '" + refCapa + "'" , "articulos,familias");
        if (datosArticulo["result"] != 1) {
          MessageBox.warning(util.translate("scripts", "Error al obtener los datos de familia y beneficio para el artículo %1").arg(refCapa), MessageBox.Ok, MessageBox.NoButton);
          return false;
        }
        costePliego = parseFloat(datosArticulo["a.costemedio"]) * (100 + parseFloat(datosArticulo["f.porbeneficio"])) / 100;
        costePliego = util.roundFieldValue(costePliego, "consumoslp", "costeunidad");
        detalleCosteMat += util.translate("scripts", "\nCosteUnidad = CosteMedio de %1 * (% Beneficio de %2)").arg(refCapa).arg(datosArticulo["f.codfamilia"]);
        detalleCosteMat += util.translate("scripts", "\n%1 x (100 + %2) / 100 = %3").arg(util.roundFieldValue(datosArticulo["a.costemedio"], "articulosprov", "coste")).arg(datosArticulo["f.porbeneficio"]).arg(costePliego);

        if (!this.iface.ponConsumoTarea(xmlTarea, refCapa, totalPliegos, datosArticulo["a.costemedio"], totalMaculas, datosArticulo["f.porbeneficio"])) {
          return false;
        }
        costeCapa = totalPliegos * costePliego;
        detalleCosteMat += util.translate("scripts", "\nCosteCapa %1 = TotalPliegos * CosteUnidad").arg(iCapa);
        detalleCosteMat += util.translate("scripts", "\n%1 x %2 = %3").arg(totalPliegos).arg(util.roundFieldValue(costePliego, "articulosprov", "coste")).arg(util.roundFieldValue(costeCapa, "tareaslp", "costemat"));

        costeMat += costeCapa;
      }
      detalleCosteMat += util.translate("scripts", "\nCoste total capas = %1").arg(util.roundFieldValue(costeMat, "tareaslp", "costemat"));

      break;
    }
    case "IMPRESION": {
      instrucciones += util.translate("scripts", "\nEl trabajo se imprimirá en la impresora %1 usando planchas %2 de %3.").arg(flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/TipoImpresoraParam@Valor")).arg(flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/TipoImpresoraParam@RefPlancha")).arg(flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/TipoImpresoraParam@AreaPlancha"));

      instrucciones += util.translate("scripts", "\nSe usará el estilo de impresión %1.").arg(flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/EstiloImpresionParam@Valor"));

      //      instrucciones += this.iface.instruccionesPlanchas(xmlProceso);

      codTipoCentro = flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/TipoImpresoraParam@Valor");
      xmlTarea.toElement().setAttribute("CodTipoCentro", codTipoCentro);

      var costesImpresionMO: Array = this.iface.costesPorCentroTarea(codTipoCentro, idTipoTareaPro);
      if (!costesImpresionMO) {
        return false;
      }
      var estiloImpresion: String = flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/EstiloImpresionParam@Valor");
      var dimPIS: String = flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/PliegoImpresionParam@Valor");

      var refPliego: String = flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/PliegoParam@Ref");
      var formatoPliego: String = util.sqlSelect("articulos", "codformato", "referencia = '" + refPliego + "'");
      if (!formatoPliego) {
        formatoPliego = "";
      }
      var xmlParamImpresora: FLDomNode = flfacturac.iface.pub_dameParamCentroCoste(codTipoCentro);
      if (!xmlParamImpresora) {
        MessageBox.warning(util.translate("scripts", "Error al obtener los parámetros de la impresora %1").arg(codTipoCentro), MessageBox.Ok, MessageBox.NoButton);
        return false;
      }

      var numPasadas: Number = flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/DistPlanchaParam@NumPasadas");
      var numPlanchas: Number = flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/DistPlanchaParam@NumPlanchas");

      var numCuerpos: Number = parseInt(xmlParamImpresora.toElement().attribute("NumCuerpos"));
      if (isNaN(numCuerpos)) {
        numCuerpos = 0;
      }
      var numPlanchasExtra = numPlanchas - numCuerpos;
      if (numPlanchasExtra < 0) {
        numPlanchasExtra = 0;
      }

      //      var tiempoPlancha:Number = parseFloat(xmlParamImpresora.toElement().attribute("TiempoPlancha"));
      //      if (isNaN(tiempoPlancha))
      //        tiempoPlancha = 0;

      var xmlListaCostes: FLDomNodeList = xmlParamImpresora.toElement().elementsByTagName("Coste");
      if (!xmlListaCostes) {
        MessageBox.warning(util.translate("scripts", "Error al obtener los costes de la impresora %1").arg(codTipoCentro), MessageBox.Ok, MessageBox.NoButton);
        return false;
      }
      var iDefecto: Number = -1;
      var iDefectoEstilo: Number = -1;
      var iDefectoFormato: Number = -1;
      var iEstiloFormato: Number = -1;
      var eCoste: FLDomElement;
      for (var i: Number = 0; i < xmlListaCostes.length(); i++) {
        eCoste = xmlListaCostes.item(i).toElement();
        if (numPasadas < parseInt(eCoste.attribute("CopiasMin"))) {
          continue;
        }
        if (eCoste.attribute("CopiasMax") != "" && numPasadas > parseInt(eCoste.attribute("CopiasMax"))) {
          continue;
        }
        if (eCoste.attribute("EstiloImpresion") == estiloImpresion && eCoste.attribute("Formato") == formatoPliego) {
          iEstiloFormato = i;
          break;
        } else if (eCoste.attribute("EstiloImpresion") == "Defecto" && eCoste.attribute("Formato") == formatoPliego) {
          iDefectoEstilo = i;
        } else if (eCoste.attribute("EstiloImpresion") == estiloImpresion && eCoste.attribute("Formato") == "") {
          iDefectoFormato = i;
        } else if (eCoste.attribute("EstiloImpresion") == "Defecto" && eCoste.attribute("Formato") == "") {
          iDefecto = i;
        }
      }
      if (iEstiloFormato == -1) {
        if (iDefectoEstilo > -1) {
          iEstiloFormato = iDefectoEstilo;
        } else if (iDefectoFormato > -1) {
          iEstiloFormato = iDefectoFormato;
        } else if (iDefecto > -1) {
          iEstiloFormato = iDefecto;
        } else {
          MessageBox.warning(util.translate("scripts", "Tarea de impresión:\nNo se ha encontrado un registro de tiempos para los siguientes valores:\nImpresora: %1\nEstilo: %2 \nFormato papel: %3\nPasadas: %4\nEsto hará que los cálculos no sean exactos.").arg(codTipoCentro).arg(estiloImpresion).arg(formatoPliego).arg(numPasadas), MessageBox.Ok, MessageBox.NoButton);
          return false;
        }
      }
      var costeArranque: Number = 0;
      var costePorCopia: Number = 0;
      var costeFin: Number = 0;
      var intervalo: String = util.translate("scripts", "-Indefinido-");
      var copiasHora: Number = 0;
      var maculasPlancha: Number;
      var tiempoPlancha: Number;
      if (iEstiloFormato >= 0) {
        eCoste = xmlListaCostes.item(iEstiloFormato).toElement();
        costeArranque = eCoste.attribute("Arranque");
        if (isNaN(costeArranque) || costeArranque == "")
          costeArranque = 0;

        costePorCopia = eCoste.attribute("PorCopia");
        if (isNaN(costePorCopia) || costePorCopia == "")
          costePorCopia = 0;
        copiasHora = costePorCopia;
        if (copiasHora == 0) {
          MessageBox.warning(util.translate("scripts", "El centro de coste %1 tiene definida una velocidad de 0 copias por hora.\nEsto hace inviable el cálculo de costes.").arg(codTipoCentro), MessageBox.Ok, MessageBox.NoButton);
          return false;
        }
        costePorCopia = 60 / copiasHora;

        costeFin = eCoste.attribute("Fin");
        if (isNaN(costeFin) || costeFin == "")
          costeFin = 0;

        maculasPlancha = parseInt(eCoste.attribute("MaculasPlancha"));
        tiempoPlancha = parseFloat(eCoste.attribute("TiempoPlancha"));
        intervalo = eCoste.attribute("CopiasMin") + " - " + eCoste.attribute("CopiasMax");
      }
      // debug("IestiloFormato  = " + iEstiloFormato);
      detalleCoste += util.translate("scripts", "\nCOSTE MANO DE OBRA:\nFórmula: TInicial de %1 + (numPasadas x TPasada de %2) + (numPlanchasExtra x TPlancha) + TFinal de %3.").arg(codTipoCentro).arg(codTipoCentro).arg(codTipoCentro);
      detalleCoste += util.translate("scripts", "\n(los costes son los asociados al estilo %1,  al formato '%2' y al intervalo de copias %3, a %4 copias/hora).").arg(estiloImpresion).arg(formatoPliego).arg(intervalo).arg(copiasHora);
      tiempoMO = parseFloat(costeArranque) + (parseFloat(costePorCopia) * parseFloat(numPasadas)) + (parseFloat(numPlanchasExtra) * parseFloat(tiempoPlancha)) + parseFloat(costeFin);

      costePorCopia = Math.round(costePorCopia * 10000);
      costePorCopia = costePorCopia / 10000;
      detalleCoste += util.translate("scripts", "\n%1 + (%2 x %3) + (%4 x %5) + %6 = %7").arg(costeArranque).arg(numPasadas).arg(costePorCopia).arg(numPlanchasExtra).arg(util.roundFieldValue(tiempoPlancha, "pr_costesestilosimp", "tiempoplancha")).arg(costeFin).arg(util.roundFieldValue(tiempoMO, "tareaslp", "costemo"));

      var dimPliego: Array = dimPIS.split("x");
      var xmlDimOptimas: FLDomNodeList = xmlParamImpresora.toElement().elementsByTagName("DimOptima");
      if (xmlDimOptimas) {
        var eDO: FLDomElement;
        var dimOptima: Boolean = false;
        for (var i: Number = 0; i < xmlDimOptimas.length(); i++) {
          eDO = xmlDimOptimas.item(i).toElement();
          if ((parseFloat(eDO.attribute("Alto")) == parseFloat(dimPliego[0]) && parseFloat(eDO.attribute("Ancho")) == parseFloat(dimPliego[1])) || (parseFloat(eDO.attribute("Alto")) == parseFloat(dimPliego[1]) && parseFloat(eDO.attribute("Ancho")) == parseFloat(dimPliego[0]))) {
            dimOptima = true;
            break;
          }
        }
        if (!dimOptima) {
          var penalizacion: String = xmlParamImpresora.namedItem("DimOptimas").toElement().attribute("Penalizacion");
          tiempoMO += parseFloat(penalizacion);
          detalleCoste += util.translate("scripts", "\nAplicando penalización por dimensión no óptima de %1. Coste = %2").arg(penalizacion).arg(tiempoMO);
        }
      }

      var datosPantones: Array = this.iface.dameTiempoExtraPantone(xmlParamImpresora, xmlProceso);
      if (!datosPantones) {
        return false;
      }
      if (datosPantones["tiempototal"] > 0) {
        tiempoMO += parseFloat(datosPantones["tiempototal"]);
        detalleCoste += util.translate("scripts", "\nTiempo extra por pantone: %1 x %2 pantones = %3. Total = %4").arg(datosPantones["tiempopantone"]).arg(datosPantones["numpantones"]).arg(datosPantones["tiempototal"]).arg(util.roundFieldValue(tiempoMO, "tareaslp", "costemo"));
      }

      var tiempoMinProd: Number = costesImpresionMO["tiempominimo"]; //xmlParamImpresora.toElement().attribute("TiempoMinProd");
      if (isNaN(tiempoMinProd)) {
        tiempoMinProd = 0;
      }
      var tiempoMinProdTotal: Number = parseFloat(tiempoMinProd) + parseFloat((numPlanchasExtra * tiempoPlancha));
      if (tiempoMO < tiempoMinProdTotal) {
        tiempoReal = tiempoMO;
        tiempoMO = tiempoMinProdTotal;
        detalleCoste += util.translate("scripts", "\nAplicando tiempo mínimo de producción: %1 + Tiempo planchas extra %2 x %3 = %4").arg(tiempoMinProd).arg(numPlanchasExtra).arg(tiempoPlancha).arg(tiempoMinProdTotal);
      }

      var costeTiempo: Number = parseFloat(costesImpresionMO["costetiempo"]);
      if (isNaN(costeTiempo))
        costeTiempo = 0;

      porBeneficio = parseFloat(costesImpresionMO["porbeneficio"]);
      if (isNaN(porBeneficio))
        porBeneficio = 0;

      costeUT = parseFloat(costeTiempo);
      porBeneficio = parseFloat(porBeneficio);

      /** COSTE MATERIAL:<br/>
      Se aplica la fórmula CM = Coste Pliego x numPliegos, donde:<br/>
      <ul>
      <li>Coste Pliego es el coste medio del artículo pliego usado (atributo Ref del parámetro PliegoImpresionParam)</li>
      <li>numPliegos es el número de pliegos (de pliegos sin cortar) utilizados</li>
      </ul>
      */
      var xmlParamPI: FLDomNode = flfacturac.iface.pub_dameNodoXML(xmlProceso, "Parametros/PliegoImpresionParam");
      var factor: Number = flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/PliegoImpresionParam@Factor");
      var refPliego: Number = flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/PliegoParam@Ref");

      var xmlParamDP: FLDomNode = flfacturac.iface.pub_dameNodoXML(xmlProceso, "Parametros/DistPlanchaParam");


      // debug("numPlanchas = " + numPlanchas);

      detalleCosteMat += util.translate("scripts", "\nCOSTE MATERIAL:\nFórmula: Coste Pliego x numPliegos");

      var numPliegos: Number = this.iface.pliegosImpresionIptico(xmlProceso);
      detalleCosteMat += util.translate("scripts", "\nNumPliegosImpresion = %1").arg(numPliegos);

      var numMaculas: Number;
      var maculasManual: Boolean = (flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/MaculasParam@MaculasManual") == "true");
      if (maculasManual) {
        numMaculas = parseInt(flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/MaculasParam@TotalMaculas"));
        detalleCosteMat += util.translate("scripts", "\nNumMaculas (cálculo manual) = %1").arg(numMaculas);
      } else {
        numMaculas = numPlanchas * maculasPlancha;
        detalleCosteMat += util.translate("scripts", "\nNumMaculas = NumPlanchas x MaculasPlancha");
        detalleCosteMat += util.translate("scripts", "\n%1 x %2 = %3").arg(numPlanchas).arg(maculasPlancha).arg(numMaculas);
      }

      var totalPliegosImpresion: Number = numPliegos + numMaculas;
      detalleCosteMat += util.translate("scripts", "\nTotalPliegosImpresion = NumPliegosImpresion + NumMaculas");
      detalleCosteMat += util.translate("scripts", "\n%1 + %2 = %3").arg(numPliegos).arg(numMaculas).arg(totalPliegosImpresion);

      var totalPliegos = Math.ceil(totalPliegosImpresion / factor);
      detalleCosteMat += util.translate("scripts", "\nTotalPliegos = TotalPliegosImpresion / factorPrecorte");
      detalleCosteMat += util.translate("scripts", "\n%1 / %2 = %3").arg(totalPliegosImpresion).arg(factor).arg(totalPliegos);

      instrucciones += util.translate("scripts", "\nSe usarán %1 pliegos de impresión (%2 para impresión + %3 para máculas)").arg(totalPliegosImpresion).arg(numPliegos).arg(numMaculas);

      var costeMedio: Number = parseFloat(util.sqlSelect("articulos", "costemedio", "referencia = '" + refPliego + "'"));
      if (isNaN(costePliego)) {
        costePliego = 0;
      }
      var datosArticulo: Array = flfactppal.iface.ejecutarQry("articulos a INNER JOIN familias f ON a.codfamilia = f.codfamilia", "a.costemedio,f.codfamilia,f.porbeneficio", "a.referencia = '" + refPliego + "'" , "articulos,familias");
      if (datosArticulo["result"] != 1) {
        MessageBox.warning(util.translate("scripts", "Error al obtener los datos de familia y beneficio para el artículo %1").arg(refPliego), MessageBox.Ok, MessageBox.NoButton);
        return false;
      }

      var costePliego: Number = parseFloat(datosArticulo["a.costemedio"]) * (100 + parseFloat(datosArticulo["f.porbeneficio"])) / 100;
      costePliego = util.roundFieldValue(costePliego, "consumoslp", "costeunidad");
      detalleCosteMat += util.translate("scripts", "\nCosteUnidad = CosteMedio de %1 * (% Beneficio de %2)").arg(refPliego).arg(datosArticulo["f.codfamilia"]);
      detalleCosteMat += util.translate("scripts", "\n%1 x (100 + %2) / 100 = %3").arg(util.roundFieldValue(costeMedio, "articulosprov", "coste")).arg(datosArticulo["f.porbeneficio"]).arg(costePliego);

      var totalMaculas: Number = Math.ceil(numMaculas / factor);
      if (!this.iface.ponConsumoTarea(xmlTarea, refPliego, totalPliegos, datosArticulo["a.costemedio"], totalMaculas, datosArticulo["f.porbeneficio"])) {
        return false;
      }

      costeMat = costePliego * totalPliegos;
      detalleCosteMat += util.translate("scripts", "\nCostePliegos = TotalPliegos * CosteUnidad");
      detalleCosteMat += util.translate("scripts", "\n%1 x %2 = %3").arg(totalPliegos).arg(util.roundFieldValue(costePliego, "articulosprov", "coste")).arg(util.roundFieldValue(costeMat, "tareaslp", "costemat"));

      break;
    }
    //    case "TACO_
    case "CORTEPLAS": {
      /** <b>TAREA DE CORTE PREVIO AL PLASTIFICADO (CORTEPLAS)</b><br/>
      Esta tarea consiste en realizar un único corte por pliego de impresión para separar una cara de otra<br/>
      Se aplica la fórmula CMO = ((Coste inicial + (Coste por Unidad x NumTandas)) x Coste por minuto) + Beneficio, donde:<br/>
      <ul>
      <li>Coste inicial, Coste por unidad y Coste por minuto son parámetros asociados al tipo de centro de  coste GUILLOTINA</li>
      <li>Beneficio es el resultado de aplicar el porcentaje de beneficio asociado al centro de coste al primer sumando de la fórmula</li>
      <li>numTandas es el número agrupaciones de pliegos que se pasarán a la máquina de corte de manera que el ancho de la agrupación no supere el máximo valor de la máquina</li>
      </ul>
      COSTE MATERIAL:<br/>
      No hay coste de material en esta tarea
      */
      var ejeCorte: String = flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/TrabajosPliegoParam@EjeSim");
      instrucciones += util.translate("scripts", "\nSe realizará un corte por el eje %1 de los pliegos de impresión.").arg(ejeCorte);

      instrucciones += util.translate("scripts", "\nDimensiones pliego plastificado: %1").arg(flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/PlastificadoParam@AreaPliegoPlas"));

      codTipoCentro = "GUILLOTINA";
      xmlTarea.toElement().setAttribute("CodTipoCentro", codTipoCentro);

      var xmlParamGuillotina: FLDomNode = flfacturac.iface.pub_dameParamCentroCoste(codTipoCentro);
      if (!xmlParamGuillotina)
        return false;

      var maxGrosorCM: Number = parseFloat(flfacturac.iface.pub_dameAtributoXML(xmlParamGuillotina, "@MaxGrosorCm"));
      if (!maxGrosorCM || maxGrosorCM == 0) {
        MessageBox.warning(util.translate("scripts", "No tiene configurado el atributo MaxGrosorCm (máximo grosor que admite la guillotina)\npara el tipo de centro de coste %1").arg(codTipoCentro), MessageBox.Ok, MessageBox.NoButton);
        return false;
      }

      var refPliego: Number = flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/PliegoParam@Ref");
      var gramaje: Number = flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/GramajeParam@Valor");
      var grosorPliego: Number = parseFloat(util.sqlSelect("articulos", "grosorunidad", "referencia = '" + refPliego + "'"));
      if (isNaN(grosorPliego)) {
        return false;
      }

      var numPliegos: Number = this.iface.pliegosImpresionIptico(xmlProceso);
      var anchoACortar = numPliegos * grosorPliego;
      var numTandas: Number = Math.ceil(anchoACortar / maxGrosorCM);
      var pliegosTanda: Number = Math.ceil(numPliegos / numTandas);

      var costesCorteMO: Array = this.iface.costesPorCentroTarea(codTipoCentro, idTipoTareaPro);
      if (!costesCorteMO)
        return false;

      var trabajosPlancha: String = flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/TipoImpresoraParam@TrabajosPlancha");

      instrucciones += util.translate("scripts", "\nSe cortarán %1 pliegos en %2 tandas de %3 pliegos cada una para obtener %4 pliegos de plastificado.").arg(numPliegos).arg(numTandas).arg(pliegosTanda).arg(numPliegos * 2);

      // debug(instrucciones);
      detalleCoste += util.translate("scripts", "\nCOSTE MANO DE OBRA:\nFórmula: TInicial de %1 + (numTandas x TCorte de %2)").arg(codTipoCentro).arg(codTipoCentro);
      // debug(detalleCoste);

      tiempoMO = costesCorteMO["inicial"] + numTandas * costesCorteMO["unidad"];
      detalleCoste += util.translate("scripts", "\n%1 + (%2 x %3) = %4").arg(costesCorteMO["inicial"]).arg(numTandas).arg(costesCorteMO["unidad"]).arg(tiempoMO);
      // debug(detalleCoste);
      costeUT = parseFloat(costesCorteMO["costetiempo"]);
      porBeneficio = parseFloat(costesCorteMO["porbeneficio"]);

      break;
    }
    case "PLASTIFICADO": {
      /** <b>TAREA DE PLASTIFICADO</b><br/>
      Se aplica la fórmula CMO = ((Coste inicial + (Coste por Unidad x numPliegos x numCaras)) x Coste por minuto) + Beneficio, donde:<br/>
      <ul>
      <li>Coste inicial, Coste por unidad y Coste por minuto son parámetros asociados al tipo de centro de  coste PLASTIFICADORA</li>
      <li>numPliegos es el número de pliegos a plastificar (atributo numPlietos del parámetro DistPlanchaParam) </li>
      <li>numCaras es 1 ó 2 en función de si hay que plastificar una o dos caras</li>
      <li>Beneficio es el resultado de aplicar el porcentaje de beneficio asociado al centro de coste al primer sumando de la fórmula</li>
      </ul>
      */
      var areaPliego: String = flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/PlastificadoParam@AreaPliegoPlas");
      var dimPliego: Array = areaPliego.split("x");

      instrucciones += util.translate("scripts", "\nDimensiones pliego plastificado: %1").arg(areaPliego);

      var plastificado: String = flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/PlastificadoParam@Valor");
      switch (plastificado.charAt(0)) {
        case "N": {
          instrucciones += util.translate("scripts", "\nFrente no plastificado");
          break;
        }
        case "B": {
          instrucciones += util.translate("scripts", "\nFrente plastificado en brillo");
          break;
        }
        case "M": {
          instrucciones += util.translate("scripts", "\nFrente plastificado en mate");
          break;
        }
      }
      switch (plastificado.charAt(1)) {
        case "N": {
          instrucciones += util.translate("scripts", "\nVuelta no plastificada");
          break;
        }
        case "B": {
          instrucciones += util.translate("scripts", "\nVuelta plastificada en brillo");
          break;
        }
        case "M": {
          instrucciones += util.translate("scripts", "\nVuelta plastificada en mate");
          break;
        }
      }

      codTipoCentro = "PLASTIFICADORA";
      xmlTarea.toElement().setAttribute("CodTipoCentro", codTipoCentro);
      var costesPlastificadoMO: Array = this.iface.costesPorCentroTarea(codTipoCentro, idTipoTareaPro);
      if (!costesPlastificadoMO)
        return false;

      var numPliegos: Number = this.iface.pliegosImpresionIptico(xmlProceso);
      var factorCortePlas: Number = parseInt(flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/PlastificadoParam@FactorCortePlas"));
      numPliegos = numPliegos * factorCortePlas;

      var numCaras: Number = 1;
      switch (plastificado) {
        case "BB":
        case "MM":
        case "BM":
        case "MB": { // Son necesarias dos pasadas por pliego (una por cara)
          numCaras = 2;
          break;
        }
      }

      var dimMenor: Number;
      var dimMayor: Number;
      if (dimPliego[0] < dimPliego[1]) {
        dimMenor = parseFloat(dimPliego[0]);
        dimMayor = parseFloat(dimPliego[1]);
      } else {
        dimMenor = parseFloat(dimPliego[1]);
        dimMayor = parseFloat(dimPliego[0]);
      }

      numPasadas = numPliegos * numCaras;

      instrucciones += util.translate("scripts", "\nSe plastificarán %1 pliegos de ancho %2 y largo %3").arg(numPliegos).arg(dimMayor).arg(dimMenor);

      codTipoCentro = flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/TipoPlastificadoraParam@Valor");
      var xmlParamPlasti: FLDomNode = flfacturac.iface.pub_dameParamCentroCoste(codTipoCentro);
      if (!xmlParamPlasti)
        return false;

      //      var metrosMinuto:Number = parseFloat(flfacturac.iface.pub_dameAtributoXML(xmlParamPlasti, "@MetrosMinuto"));
      //      if (isNaN(metrosMinuto) || metrosMinuto == "") {
      //        metrosMinuto = 0;
      //      }

      var xmlListaCostes: FLDomNodeList = xmlParamPlasti.toElement().elementsByTagName("Coste");
      if (!xmlListaCostes) {
        MessageBox.warning(util.translate("scripts", "Error al obtener los costes de la plastificadora %1").arg(codTipoCentro), MessageBox.Ok, MessageBox.NoButton);
        return false;
      }
      var iIntervalo: Number = -1;
      var eCoste: FLDomElement;
      for (var i: Number = 0; i < xmlListaCostes.length(); i++) {
        eCoste = xmlListaCostes.item(i).toElement();
        if (numPliegos < parseInt(eCoste.attribute("CopiasMin"))) {
          continue;
        }
        if (eCoste.attribute("CopiasMax") != "" && numPliegos > parseInt(eCoste.attribute("CopiasMax"))) {
          continue;
        }
        iIntervalo = i;
        break;
      }
      // debug("Inter = " + iIntervalo);
      if (iIntervalo == -1) {
        MessageBox.warning(util.translate("scripts", "Tarea de plastificado:\nNo se ha encontrado un registro de tiempos para los siguientes valores:\nPlastificadora: %1\nCopias: %2\nEsto hará que los cálculos no sean exactos.").arg(codTipoCentro).arg(numPliegos), MessageBox.Ok, MessageBox.NoButton);
      }
      var costeArranque: Number = 0;
      var costePorCopia: Number = 0;
      var copiasHora: Number = 0;
      var costeFin: Number = 0;
      var intervalo: String = util.translate("scripts", "-Indefinido-");
      var metrosMinuto: Number = 0;
      if (iIntervalo >= 0) {
        eCoste = xmlListaCostes.item(iIntervalo).toElement();
        costeArranque = eCoste.attribute("Arranque");
        if (isNaN(costeArranque) || costeArranque == "") {
          costeArranque = 0;
        }
        metrosMinuto = eCoste.attribute("MetrosMinuto");
        if (isNaN(metrosMinuto) || metrosMinuto == "") {
          metrosMinuto = 0;
        }
        costeFin = eCoste.attribute("Fin");
        if (isNaN(costeFin) || costeFin == "") {
          costeFin = 0;
        }
        intervalo = eCoste.attribute("CopiasMin") + " - " + eCoste.attribute("CopiasMax");
      }
      if (metrosMinuto == 0) {
        MessageBox.warning(util.translate("scripts", "El centro de coste %1 tiene definida una velocidad de 0 metros por minuto.\nEsto hace inviable el cálculo de costes.").arg(codTipoCentro), MessageBox.Ok, MessageBox.NoButton);
        return false;
      }
      //      var costePorCopia:Number = 60 / unidadesHora;

      var anchoMaxPl: Number = parseFloat(flfacturac.iface.pub_dameAtributoXML(xmlParamPlasti, "@AnchoMax"));
      var anchoMinPl: Number = parseFloat(flfacturac.iface.pub_dameAtributoXML(xmlParamPlasti, "@AnchoMin"));
      var altoMaxPl: Number = parseFloat(flfacturac.iface.pub_dameAtributoXML(xmlParamPlasti, "@AltoMax"));
      var altoMinPl: Number = parseFloat(flfacturac.iface.pub_dameAtributoXML(xmlParamPlasti, "@AltoMin"));

      /** COSTE MATERIAL:<br/>
      Se aplica la fórmula CM = Coste metro plástico x LonTrabajo x numPliegos, donde:<br/>
      <ul>
      <li>Coste metro plástico es el coste medio del artículo plástico usado. Se toma el plástico de tipo y anchura acordes al trabajo</li>
      <li>LonTrabajo es la longitud del trabajo. Se intenta pasar los trabajos con su lado más largo paralelo a la boca de la plastificadora. Se tiene en cuenta el posible corte previo que haya habido</li>
      <li>numPliegos es el número de pliegos que pasan por la plastificadora. Si ha sido necesario realizar un corte previo al plastificado, el número de pliegos se multiplica por dos (reduciéndose el área) </li>
      </ul>
      Si el trabajo va plastificado por ambas caras, la fórmula se aplica dos veces
      */
      var codPlas: String;
      var refRolloPlas: String;
      var tipoPlas: String;
      var costePlas: Number;
      var anchoPlas: Number;
      costeMat = 0;
      var costeCara: Number;
      var margenLargo: Number = parseFloat(flfacturac.iface.pub_dameAtributoXML(xmlParamPlasti, "@MargenLargo"));
      if (isNaN(margenLargo)) {
        margenLargo = 0;
      }
      var margenAncho: Number = parseFloat(flfacturac.iface.pub_dameAtributoXML(xmlParamPlasti, "@MargenAncho"));
      if (isNaN(margenAncho)) {
        margenAncho = 0;
      }

      detalleCosteMat += util.translate("scripts", "\nCOSTE MATERIAL:");
      var longRollo: Number;
      var arrayRefRollo: Array = new Array(2);
      var arrayLongRollo: Array  = new Array(2);
      var arrayCostePlas: Array  = new Array(2);
      var tiempoCara: Number = 0;
      var tiempoVuelta: Number = 0;
      var porBeneficioPlas: Number;
      for (var iCodPlas: Number = 0; iCodPlas < plastificado.length; iCodPlas++) {
        arrayRefRollo[iCodPlas] = false;
        arrayLongRollo[iCodPlas] = false;
        codPlas = plastificado.charAt(iCodPlas);
        switch (codPlas) {
          case "B": {
            tipoPlas = "Brillo";
            break;
          }
          case "M": {
            tipoPlas = "Mate";
            break;
          }
          default: {
            continue;
          }
        }
        /** Se intenta colocar el pliego a lo ancho (la mayor dimensión del pliego paralela a la entrada de la máquina). Si no cabe de esta forma en la plastificadora, el pliego se rota */
        var ok: Boolean = false;
        if (dimMayor > anchoMaxPl || dimMayor < anchoMinPl || dimMenor > altoMaxPl || dimMenor < altoMinPl) {
          instrucciones += util.translate("scripts", "Los trabajos no pueden entrar por el ancho porque exceden el tamaño mínimo o máximo de la plastificadora.");
        } else {
          refRolloPlas = util.sqlSelect("articulos", "referencia", "codfamilia = 'PLAS' AND anchopliego >= " + parseFloat(dimMayor + margenAncho) + " AND tipoplas = '" + tipoPlas + "' ORDER BY anchopliego");
          if (refRolloPlas) {
            ok = true;
            instrucciones += util.translate("scripts", "\nLos trabajos deben entrar a la máquina por el ancho");
          } else {
            instrucciones += util.translate("scripts", "\nLos trabajos no pueden entrar por el ancho porque no hay rollos de plástico tipo %1 con una anchura superior a %2 + %3 (margen anchura máquina)").arg(tipoPlas).arg(dimMayor).arg(margenAncho)
          }
        }
                         var longPliegoPlastificadora: Number = dimMayor;
        if (!ok) {
          var dimAux: Number = dimMenor;
          dimMenor = dimMayor;
          dimMayor = dimAux;
          if (dimMenor > anchoMaxPl || dimMenor < anchoMinPl || dimMayor > altoMaxPl || dimMayor < altoMinPl) {
            var plasti: String = codTipoCentro + " Ancho (" + anchoMinPl + " - " + anchoMaxPl + "), Largo (" + altoMinPl + " - " + altoMaxPl + ")";
            this.iface.marcarProcesoInviable(xmlProceso, util.translate("scripts", "Las dimensiones del pliego (%1) exceden las dimensiones máximas o mínimas de la plastificadora:\n%2").arg(areaPliego).arg(plasti));
            return true;
          } else {
            refRolloPlas = util.sqlSelect("articulos", "referencia", "codfamilia = 'PLAS' AND anchopliego >= " + parseFloat(dimMayor + margenAncho) + " AND tipoplas = '" + tipoPlas + "' ORDER BY anchopliego");
            if (!refRolloPlas) {
              this.iface.marcarProcesoInviable(xmlProceso, util.translate("scripts", "No hay rollos de plástico tipo %1 con una anchura superior a %2 + %3 (margen anchura máquina)").arg(tipoPlas).arg(dimMayor).arg(margenAncho));
              return true;
            } else {
              instrucciones += util.translate("scripts", "\nLos trabajos deben entrar a la máquina por el largo");
            }
          }
        }
        var datosArticulo: Array = flfactppal.iface.ejecutarQry("articulos a INNER JOIN familias f ON a.codfamilia = f.codfamilia", "a.anchopliego,a.costemedio,f.codfamilia,f.porbeneficio", "a.referencia = '" + refRolloPlas + "'" , "articulos,familias");
        if (datosArticulo["result"] != 1) {
          MessageBox.warning(util.translate("scripts", "Error al obtener los datos de familia y beneficio para el artículo %1)").arg(refRolloPlas), MessageBox.Ok, MessageBox.NoButton);
          return false;
        }
        porBeneficioPlas = datosArticulo["f.porbeneficio"];
        anchoPlas = parseFloat(datosArticulo["a.anchopliego"]);
        costePlas = parseFloat(datosArticulo["a.costemedio"]);
        if (isNaN(costePlas)) {
          costePlas = 0;
        }

        if (iCodPlas == 0) {
          detalleCosteMat += util.translate("scripts", "\nFrente: ");
        } else {
          detalleCosteMat += util.translate("scripts", "\nVuelta: ");
        }

        detalleCosteMat += util.translate("scripts", "Se usará plástico %1 de referencia %2 y ancho %3".arg(tipoPlas).arg(refRolloPlas).arg(anchoPlas));

        var costeUnidad: Number = costePlas * ((100 + porBeneficioPlas) / 100) * (anchoPlas / 100);
        costeUnidad = util.roundFieldValue(costeUnidad, "consumoslp", "costeunidad");

        detalleCosteMat += util.translate("scripts", "\nCosteUnidad = (CosteMedio m2 de %1 x %2% x Anchura rollo)").arg(refRolloPlas).arg(porBeneficioPlas);
        detalleCosteMat += util.translate("scripts", "\n(%1 x ((100 + %2) / 100) x (%3 / 100) = %4").arg(costePlas).arg(porBeneficioPlas).arg(anchoPlas).arg(costeUnidad);

        longRollo = ((dimMayor + margenLargo) / 100) * numPliegos;
        detalleCosteMat += util.translate("scripts", "\nLongitud = (Ancho + margen) x numPliegos");
        detalleCosteMat += util.translate("scripts", "\n(%1 + %2) * %3 = %4").arg(dimMayor).arg(margenLargo).arg(numPliegos).arg(longRollo);

        costeCara = costeUnidad * longRollo;
        detalleCosteMat += util.translate("scripts", "\nCosteCara = CosteUnidad * Longitud");
        detalleCosteMat += util.translate("scripts", "\n%1 x %2 = %3").arg(costeUnidad).arg(longRollo).arg(util.roundFieldValue(costeCara, "tareaslp", "costemat"));

        //        detalleCosteMat += util.translate("scripts", "\nFórmula: Coste metro cuadrado Plástico x anchoRollo(m) x (longitudPliego + margen largo de %1)(m) x numPliegos").arg(codTipoCentro);
        //        longRollo = ((dimMayor + margenLargo) / 100) * numPliegos;
        //        costeCara = costePlas * (anchoPlas / 100) * longRollo;
        //        detalleCosteMat += util.translate("scripts", "\n%1 x %2 x (%3 + %4) x %5 = %6").arg(util.roundFieldValue(costePlas, "articulosprov", "coste")).arg(anchoPlas / 100).arg(dimMenor / 100).arg(margenLargo / 100).arg(numPliegos).arg(util.roundFieldValue(costeCara , "tareaslp", "costemat"));
        //
        //        porBeneficioMat = parseFloat(util.sqlSelect("articulos a INNER JOIN familias f ON a.codfamilia = f.codfamilia", "f.porbeneficio", "a.referencia = '" + refRolloPlas + "'", "articulos,familias"));
        //        if (isNaN(porBeneficioMat))
        //          porBeneficioMat = 0;

        costeMat += costeCara;

        arrayRefRollo[iCodPlas] = refRolloPlas;
        arrayLongRollo[iCodPlas] = longRollo;
        arrayCostePlas[iCodPlas] = costeUnidad;

        if (iCodPlas == 0) {
          detalleCoste += util.translate("scripts", "\nT.Plastificado cara = numPliegos x (Longitud pliego + Margen) / m/minuto de %2.").arg(codTipoCentro);
          tiempoCara = numPliegos * ((dimMayor + margenLargo) / 100) / metrosMinuto;
          detalleCoste += util.translate("scripts", "\n%1 x (%2 + %3) / 100 /  %4 = %5").arg(numPliegos).arg(dimMayor).arg(margenLargo).arg(util.roundFieldValue(metrosMinuto, "pr_paramplastificadora", "MetrosMinuto")).arg(util.roundFieldValue(tiempoCara, "tareaslp", "costemo"));
        } else {
          detalleCoste += util.translate("scripts", "\nT.Plastificado vuelta = numPliegos x (Longitud pliego + Margen) / m/minuto de %2.").arg(codTipoCentro);
          tiempoVuelta = numPliegos * ((dimMayor + margenLargo) / 100) / metrosMinuto;
          detalleCoste += util.translate("scripts", "\n%1 x (%2 + %3) / 100 /  %4 = %5").arg(numPliegos).arg(dimMayor).arg(margenLargo).arg(util.roundFieldValue(metrosMinuto, "pr_paramplastificadora", "MetrosMinuto")).arg(util.roundFieldValue(tiempoVuelta, "tareaslp", "costemo"));
        }

      }

      if (numCaras == 1) {
        detalleCoste += util.translate("scripts", "\nCOSTE MANO DE OBRA:\nFórmula: TArranque + T.Plastificado cara + TFin de %1").arg(codTipoCentro);
        tiempoMO = parseFloat(costeArranque) + parseFloat(tiempoCara) + parseFloat(costeFin);
        detalleCoste += util.translate("scripts", "\n%1 + %2 + %3 = %4").arg(costeArranque).arg(tiempoCara).arg(costeFin).arg(tiempoMO);
      } else {
        detalleCoste += util.translate("scripts", "\nCOSTE MANO DE OBRA:\nFórmula: TArranque + (T.Plastificado cara + T.Plastificado vuelta) + TFin de %1").arg(codTipoCentro);
        tiempoMO = parseFloat(costeArranque) + parseFloat(tiempoCara) + parseFloat(tiempoVuelta) + parseFloat(costeFin);
        detalleCoste += util.translate("scripts", "\n%1 + (%2 + %3) + %4 = %5").arg(costeArranque).arg(tiempoCara).arg(tiempoVuelta).arg(costeFin).arg(tiempoMO);
      }
      detalleCoste += util.translate("scripts", "\n(los costes son los asociados al intervalo de copias %1, a %2 metros/minuto).").arg(intervalo).arg(metrosMinuto);

      var tiempoMinimo: Number = costesPlastificadoMO["tiempominimo"];
      if (isNaN(tiempoMinimo)) {
        tiempoMinimo = 0;
      }
      if (tiempoMO < tiempoMinimo) {
        tiempoReal = tiempoMO;
        tiempoMO = tiempoMinimo;
        detalleCoste += util.translate("scripts", "\nAplicando tiempo mínimo de %1: Tiempo = %2").arg(codTipoCentro).arg(tiempoMinimo);
      }

      costeUT = parseFloat(costesPlastificadoMO["costetiempo"]);
      porBeneficio = parseFloat(costesPlastificadoMO["porbeneficio"]);

      detalleCosteMat += util.translate("scripts", "\nTotal coste material %1.").arg(util.roundFieldValue(costeMat, "tareaslp", "costemat"));

      // debug("RR 0 = " + arrayRefRollo[0]);
      // debug("RR 1 = " + arrayRefRollo[1]);
      if (arrayRefRollo[0] && arrayRefRollo[1] && arrayRefRollo[0] == arrayRefRollo[1]) {
        var longTotal: Number = parseFloat(arrayLongRollo[0]) + parseFloat(arrayLongRollo[1]);
        if (!this.iface.ponConsumoTarea(xmlTarea, arrayRefRollo[0], longTotal, arrayCostePlas[0], false, porBeneficioPlas)) {
          return false;
        }
      } else {
        if (arrayRefRollo[0]) {
          if (!this.iface.ponConsumoTarea(xmlTarea, arrayRefRollo[0], arrayLongRollo[0], arrayCostePlas[0], false, porBeneficioPlas)) {
            return false;
          }
        }
        if (arrayRefRollo[1]) {
          if (!this.iface.ponConsumoTarea(xmlTarea, arrayRefRollo[1], arrayLongRollo[1], arrayCostePlas[1], false, porBeneficioPlas)) {
            return false;
          }
        }
      }

      break;
    }
    case "CORTE": {
      /** <b>TAREA DE CORTE</b><br/>
      Se aplica la fórmula CMO = ((Coste inicial + (Coste por Unidad x numCortes x NumTandas)) x Coste por minuto) + Beneficio, donde:<br/>
      <ul>
      <li>Coste inicial, Coste por unidad y Coste por minuto son parámetros asociados al tipo de centro de  coste GUILLOTINA</li>
      <li>Beneficio es el resultado de aplicar el porcentaje de beneficio asociado al centro de coste al primer sumando de la fórmula</li>
      <li>numCortes es el número de cortes a realizar en cada pliego</li>
      <li>numTandas es el número agrupaciones de pliegos que se pasarán a la máquina de corte de manera que el ancho de la agrupación no supere el máximo valor de la máquina</li>
      </ul>
      COSTE MATERIAL:<br/>
      No hay coste de material en esta tarea
      */
      debug(1);
      codTipoCentro = "GUILLOTINA";
      xmlTarea.toElement().setAttribute("CodTipoCentro", codTipoCentro);

      var xmlParamGuillotina: FLDomNode = flfacturac.iface.pub_dameParamCentroCoste(codTipoCentro);
      if (!xmlParamGuillotina) {
        debug(2);
        return false;
      }

      var costesCorteMO: Array = this.iface.costesPorCentroTarea(codTipoCentro, idTipoTareaPro);
      if (!costesCorteMO) {
        debug(3);
        return false;
      }

      var refPliego: Number = flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/PliegoParam@Ref");
      var gramaje: Number = flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/GramajeParam@Valor");

      var saltarPlanchas: Boolean = (flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros@SaltarPlanchas") == "true");
      var saltarImpresion: Boolean = (flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros@SaltarImpresion") == "true");

      var numCortes: Number = flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/TrabajosPliegoParam@NumCortes");
      var trabajosPI: Number = flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/TrabajosPliegoParam@NumTrabajos");
      //      var totalPaginas:Number = flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/PaginasParam@Total");

      var numPliegos: Number = this.iface.pliegosImpresionIptico(xmlProceso);
      if (!numPliegos) {
        MessageBox.warning(util.translate("scripts", "El número de pliegos a cortar es 0"), MessageBox.Ok, MessageBox.NoButton);
        return false;
      }

      var numTandas: Number = this.iface.tandasGuillotina(xmlParamGuillotina, refPliego, numPliegos);
      if (!numTandas) {
        debug(4);
        return false;
      }
      var pliegosTanda: Number = Math.ceil(numPliegos / numTandas);

      instrucciones += util.translate("scripts", "\nSe cortarán %1 pliegos en %2 tandas de %3 pliegos cada una para obtener %4 trabajos (a %5 trabajos por pliego).").arg(numPliegos).arg(numTandas).arg(pliegosTanda).arg(numPliegos * trabajosPI).arg(trabajosPI);
      instrucciones += util.translate("scripts", "\nSon necesarios %1 cortes por tanda.").arg(numCortes);

      detalleCoste += util.translate("scripts", "\nCOSTE MANO DE OBRA:\nFórmula: TInicial de %1 + (numCortes x numTandas x TCorte de %2)").arg(codTipoCentro).arg(codTipoCentro);

      tiempoMO = costesCorteMO["inicial"] + numCortes * numTandas * costesCorteMO["unidad"];
      detalleCoste += util.translate("scripts", "\n%1 + (%2 x %3 x %4) = %5").arg(costesCorteMO["inicial"]).arg(numCortes).arg(numTandas).arg(costesCorteMO["unidad"]).arg(tiempoMO);

      costeUT = parseFloat(costesCorteMO["costetiempo"]);
      porBeneficio = parseFloat(costesCorteMO["porbeneficio"]);

      /// Material (se cuenta sólo si no hay impresión (si la hay se cuenta en dicha tarea)
      if (saltarImpresion) {
        detalleCosteMat += util.translate("scripts", "\nCOSTE MATERIAL:\nFórmula: Coste Pliego x numPliegos");

        var datosArticulo: Array = flfactppal.iface.ejecutarQry("articulos a INNER JOIN familias f ON a.codfamilia = f.codfamilia", "a.costemedio,f.codfamilia,f.porbeneficio", "a.referencia = '" + refPliego + "'" , "articulos,familias");
        if (datosArticulo["result"] != 1) {
          MessageBox.warning(util.translate("scripts", "Error al obtener los datos de familia y beneficio para el artículo %1").arg(refPliego), MessageBox.Ok, MessageBox.NoButton);
          return false;
        }
        var costePliego: Number = parseFloat(datosArticulo["a.costemedio"]) * (100 + parseFloat(datosArticulo["f.porbeneficio"])) / 100;
        costePliego = util.roundFieldValue(costePliego, "consumoslp", "costeunidad");
        detalleCosteMat += util.translate("scripts", "\nCosteUnidad = CosteMedio de %1 * (% Beneficio de %2)").arg(refPliego).arg(datosArticulo["f.codfamilia"]);
        detalleCosteMat += util.translate("scripts", "\n%1 x (100 + %2) / 100 = %3").arg(util.roundFieldValue(datosArticulo["a.costemedio"], "articulosprov", "coste")).arg(datosArticulo["f.porbeneficio"]).arg(costePliego);

        if (!this.iface.ponConsumoTarea(xmlTarea, refPliego, numPliegos, datosArticulo["a.costemedio"], 0, datosArticulo["f.porbeneficio"])) {
          return false;
        }

        costeMat = costePliego * numPliegos;
        detalleCosteMat += util.translate("scripts", "\nCostePliegos = NumPliegos * CosteUnidad");
        detalleCosteMat += util.translate("scripts", "\n%1 x %2 = %3").arg(numPliegos).arg(util.roundFieldValue(costePliego, "articulosprov", "coste")).arg(util.roundFieldValue(costeMat, "tareaslp", "costemat"));
      }

      break;
    }
    case "PLEGADO": {
      /** <b>TAREA DE PLEGADO</b><br/>
      COSTE MANO DE OBRA<br/>
      Se aplica la fórmula CMO = ((Coste inicial por pala + Coste inicial por cuchilla + (Coste por Unidad x numTrabajos)) x Coste por minuto) + Beneficio, donde:<br/>
      <ul>
      <li>Coste inicial por pala y cuchilla son parámetros de la plegadora</li>
      <li>Coste por unidad se obtiene del parámetro Unidades por hora de la plegadora</li>
      <li>numTrabajos es el número de pliegos a plegar</li>
      <li>Beneficio es el resultado de aplicar el porcentaje de beneficio asociado al centro de coste al primer sumando de la fórmula</li>
      </ul>
      */
      var codTipoPlegado: String = flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/PlegadoParam@TipoPlegado");
      if (codTipoPlegado && codTipoPlegado != "") {
        instrucciones += util.translate("scripts", "\nTipo de plegado: %1").arg(codTipoPlegado);
      }
      var numVer: Number = parseInt(flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/PlegadoParam@Verticales"));
      if (isNaN(numVer)) {
        numVer = 0;
      }
      var numHor: Number = parseInt(flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/PlegadoParam@Horizontales"));
      if (isNaN(numHor)) {
        numHor = 0;
      }
      areaPlegado = flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/PlegadoParam@AreaPlegado");
      var areaTrabajo: String = flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/AreaTrabajoParam@Valor");
      var dimTrabajo: Array = areaTrabajo.split("x");
      var altoTrabajo: Number = parseFloat(dimTrabajo[1]);

      instrucciones += util.translate("scripts", "\nPliegues horizontales: %1").arg(numHor);
      instrucciones += util.translate("scripts", "\nPliegues verticales: %1").arg(numVer);
      instrucciones += util.translate("scripts", "\nArea pliego plegado: %1").arg(areaPlegado);

      codTipoCentro = flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/TipoPlegadoraParam@Valor");
      xmlTarea.toElement().setAttribute("CodTipoCentro", codTipoCentro);

      var costesPlegadoraMO: Array = this.iface.costesPorCentroTarea(codTipoCentro, idTipoTareaPro);
      if (!costesPlegadoraMO)
        return false;

      var xmlParamPlegadora: FLDomNode = flfacturac.iface.pub_dameParamCentroCoste(codTipoCentro);
      if (!xmlParamPlegadora)
        return false;

      var numCopias: Number = parseInt(flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/PaginasParam@NumCopias"));
      var numPaginas: Number = parseInt(flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/PaginasParam@NumPaginas"));
      var numTrabajos: Number = parseInt(flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/PaginasParam@Total"));
      numPasadas = numTrabajos;

      var nodoTroquelado: FLDomNode = flfacturac.iface.pub_dameNodoXML(xmlProceso, "Parametros/TroqueladoParam");
      if (nodoTroquelado) {
        var eTroquelado: FLDomElement = nodoTroquelado.toElement();
        var trabajosTroquel: Number = parseInt(eTroquelado.attribute("TrabajosTroquel"));
        numTrabajos = numTrabajos * trabajosTroquel;
      }

      // Asumimos que todos los cortes se hacen con las palas
      var numVer: Number = parseInt(flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/PlegadoParam@Verticales"));
      if (isNaN(numVer))
        numVer = 0;
      var numHor: Number = parseInt(flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/PlegadoParam@Horizontales"));
      if (isNaN(numHor))
        numHor = 0;
      var numPliegues: Number = numVer + numHor;

      var tPrepPala: Number = parseFloat(flfacturac.iface.pub_dameAtributoXML(xmlParamPlegadora, "@TiempoPrepPala"));
      var tPrepCuchilla: Number = parseFloat(flfacturac.iface.pub_dameAtributoXML(xmlParamPlegadora, "@TiempoPrepCuchilla"));

      detalleCoste += util.translate("scripts", "\nCOSTE MANO DE OBRA:\nPreparación:\nFórmula: (TPrep. Pala x Pliegues con pala) + (TPrep. Cuchilla x pliegues con cuchilla) para %1").arg(codTipoCentro);
      var costePrep: Number = tPrepPala * numPliegues + tPrepCuchilla * 0;
      detalleCoste += util.translate("scripts", "\n(%1 x %2) + (%3 x %4) = %5").arg(tPrepPala).arg(numPliegues).arg(tPrepCuchilla).arg(0).arg(util.roundFieldValue(costePrep, "tareaslp", "costemo"));
      // debug("CP = " + costePrep);
      var xmlListaCostes: FLDomNodeList = xmlParamPlegadora.toElement().elementsByTagName("Coste");
      if (!xmlListaCostes) {
        MessageBox.warning(util.translate("scripts", "Error al obtener los costes de la plegadora %1").arg(codTipoCentro), MessageBox.Ok, MessageBox.NoButton);
        return false;
      }
      var iIntervalo: Number = -1;
      var eCoste: FLDomElement;
      for (var i: Number = 0; i < xmlListaCostes.length(); i++) {
        eCoste = xmlListaCostes.item(i).toElement();
        if (numTrabajos < parseInt(eCoste.attribute("CopiasMin"))) {
          continue;
        }
        if (eCoste.attribute("CopiasMax") != "" && numTrabajos > parseInt(eCoste.attribute("CopiasMax"))) {
          continue;
        }
        iIntervalo = i;
        break;
      }
      // debug("Inter = " + iIntervalo);
      if (iIntervalo == -1) {
        MessageBox.warning(util.translate("scripts", "Tarea de plegado:\nNo se ha encontrado un registro de tiempos para los siguientes valores:\nPlegadora: %1\nCopias: %2\nEsto hará que los cálculos no sean exactos.").arg(codTipoCentro).arg(numTrabajos), MessageBox.Ok, MessageBox.NoButton);
      }
      var costeArranque: Number = 0;
      var costePorCopia: Number = 0;
      var copiasHora: Number = 0;
      var costeFin: Number = 0;
      var intervalo: String = util.translate("scripts", "-Indefinido-");
      var metrosMinuto: Number = 0;
      if (iIntervalo >= 0) {
        eCoste = xmlListaCostes.item(iIntervalo).toElement();
        costeArranque = eCoste.attribute("Arranque");
        if (isNaN(costeArranque) || costeArranque == "") {
          costeArranque = 0;
        }
        metrosMinuto = eCoste.attribute("MetrosMinuto");
        if (isNaN(metrosMinuto) || metrosMinuto == "") {
          metrosMinuto = 0;
        }
        costeFin = eCoste.attribute("Fin");
        if (isNaN(costeFin) || costeFin == "") {
          costeFin = 0;
        }
        intervalo = eCoste.attribute("CopiasMin") + " - " + eCoste.attribute("CopiasMax");
      }

      var costeDob: Number = parseFloat(costeArranque) + (parseFloat(numTrabajos) * parseFloat(altoTrabajo) / 100 / parseFloat(metrosMinuto)) + parseFloat(costeFin);
      detalleCoste += util.translate("scripts", "\nCoste de plegado:\nFórmula: TInicial + (numTrabajos x longTrabajo / m/minuto) + TFinal de %3).").arg(codTipoCentro);
      detalleCoste += util.translate("scripts", "\n%1 + (%2 x %3 / 100 / %4) + %5 = %6").arg(costeArranque).arg(numTrabajos).arg(altoTrabajo).arg(metrosMinuto).arg(costeFin).arg(util.roundFieldValue(costeDob, "tareaslp", "costemo"));
      detalleCoste += util.translate("scripts", "\n(los costes son los asociados al intervalo de copias %1, a %2 metros/minuto).").arg(intervalo).arg(metrosMinuto);

      tiempoMO = costePrep + costeDob;

      detalleCoste += util.translate("scripts", "\nTotal:\nFórmula: Coste preparación + Coste plegado");
      detalleCoste += util.translate("scripts", "\n%1 + %2 = %3").arg(util.roundFieldValue(costePrep, "tareaslp", "costemo")).arg(util.roundFieldValue(costeDob, "tareaslp", "costemo")).arg(util.roundFieldValue(tiempoMO, "tareaslp", "costemo"));

      var tiempoMinimo: Number = costesPlegadoraMO["tiempominimo"];
      if (isNaN(tiempoMinimo)) {
        tiempoMinimo = 0;
      }
      if (tiempoMO < tiempoMinimo) {
        tiempoReal = tiempoMO;
        tiempoMO = tiempoMinimo;
        detalleCoste += util.translate("scripts", "\nAplicando tiempo mínimo de %1: Tiempo = %2").arg(codTipoCentro).arg(tiempoMinimo);
      }

      //      var unidadesHora:Number = parseFloat(flfacturac.iface.pub_dameAtributoXML(xmlParamPlegadora, "@UnidadesHora"));
      //      if (isNaN(unidadesHora) || unidadesHora == "")
      //        unidadesHora = 0;
      //      if (unidadesHora == 0) {
      //        MessageBox.warning(util.translate("scripts", "El centro de coste %1 tiene definida una velocidad de 0 copias por hora.\nEsto hace inviable el cálculo de costes.").arg(codTipoCentro), MessageBox.Ok, MessageBox.NoButton);
      //        return false;
      //      }
      //      var costeCopia = 60 / unidadesHora;

      costeUT = parseFloat(costesPlegadoraMO["costetiempo"]);
      porBeneficio = parseFloat(costesPlegadoraMO["porbeneficio"]);
      break;
    }
    case "ENCUADERNADO": {
      var xmlTipoCentro: FLDomNode = flfacturac.iface.pub_dameNodoXML(xmlProceso, "Parametros/TipoEncuadernadoraParam");
      if (!xmlTipoCentro) {
        return false;
      }
      xmlTarea.toElement().setAttribute("CodTipoCentro", codTipoCentro);

      var eTipoCentro: FLDomElement = xmlTipoCentro.toElement();
      codTipoCentro = eTipoCentro.attribute("Valor");

      var costesEncuadernadoMO: Array = this.iface.costesPorCentroTarea(codTipoCentro, idTipoTareaPro);
      if (!costesEncuadernadoMO)
        return false;

      var xmlTrabExterno: FLDomNode;
      if (eTipoCentro.attribute("TipoTrabajo") == "Trabajo externo") {
        var xmlTrabExternos: FLDomNode = flfacturac.iface.pub_dameNodoXML(xmlProceso, "Parametros/TrabajosExternosParam");
        for (xmlTrabExterno = xmlTrabExternos.firstChild(); xmlTrabExterno; xmlTrabExterno = xmlTrabExterno.nextSibling()) {
          if (xmlTrabExterno.toElement().attribute("IdTipoTarea") == "ENCUADERNADO" && xmlTrabExterno.toElement().attribute("CodTipoCentro") == codTipoCentro) {
            break;
          }
        }
        if (!xmlTrabExterno) {
          MessageBox.warning(util.translate("scripts", "No ha establecido los parámetros del trabajo externo para la tarea ENCUADERNADO y el centro de coste %1").arg(codTipoCentro), MessageBox.Ok, MessageBox.NoButton);
          return false;
        }
        // debug(util.translate("scripts", "SI ha establecido los parámetros del trabajo externo para la tarea ENCUADERNADO y el centro de coste %1").arg(codTipoCentro));

        var numCopias: Number = parseInt(flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/NumCopiasParam@Valor"));
        var codProveedor: String = xmlTrabExterno.toElement().attribute("CodProveedor");
        var portes: Number = parseFloat(xmlTrabExterno.toElement().attribute("Portes"));
        var nombreProveedor: String = util.sqlSelect("proveedores", "nombre", "codproveedor = '" + codProveedor + "'");

        instrucciones += util.translate("scripts", "\nSe enviarán %1 copias al proveedor %2 %3 para su encuadernado.").arg(numCopias).arg(codProveedor).arg(nombreProveedor);

        detalleCoste += util.translate("scripts", "\nCOSTE TRABAJO EXTERNO:");
        var pvpTrabajo: Number = parseFloat(xmlTrabExterno.toElement().attribute("PvpTrabajo"));
        detalleCoste += util.translate("scripts", "\nTrabajo externo = %1").arg(pvpTrabajo);
        tiempoMO = 1;
        costeUT = pvpTrabajo;
        porBeneficio = porBeneficio = parseFloat(costesEncuadernadoMO["porbeneficio"]);;

        detalleCosteMat += util.translate("scripts", "\nCOSTE MATERIAL:");

        var portes: Number = parseFloat(xmlTrabExterno.toElement().attribute("Portes"));
        detalleCosteMat += util.translate("scripts", "\n\nValor portes: %1").arg(portes);

        porBeneficioMat = parseFloat(util.sqlSelect("articulos a INNER JOIN familias f ON a.codfamilia = f.codfamilia", "f.porbeneficio", "a.referencia = '" + this.iface.refPortes + "'", "articulos,familias"));
        if (isNaN(porBeneficioMat)) {
          porBeneficioMat = 0;
        }

        costeMat = portes;
        detalleCosteMat += util.translate("scripts", "\nCostePortes = ValorPortes").arg(this.iface.refPortes);
        detalleCosteMat += util.translate("scripts", "\n%1 = %2").arg(portes).arg(costeMat);

        if (!this.iface.ponConsumoTarea(xmlTarea, this.iface.refPortes, 1, costeMat, false, porBeneficioMat)) {
          return false;
        }
      } else {
        /// Trabajo interno
      }
      break;
    }
    //    case "EMPAQUETADO": {
    //      codTipoCentro = "EMPAQUETADORA";
    //      xmlTarea.toElement().setAttribute("CodTipoCentro", codTipoCentro);
    // //       var xmlParamGuillotina:FLDomNode = flfacturac.iface.pub_dameParamCentroCoste(codTipoCentro);
    // //       if (!xmlParamGuillotina)
    // //         return false;
    //
    //      var costesEmpaquetadoMO:Array = this.iface.costesPorCentroTarea(codTipoCentro, idTipoTareaPro);
    //      if (!costesEmpaquetadoMO)
    //        return false;
    //
    //      instrucciones += util.translate("scripts", "\nInstrucciones empaquetadora no definidas");
    //
    //      var numCopias:Number = parseInt(flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/PaginasParam@NumCopias"));
    //
    //      detalleCoste += util.translate("scripts", "\nCOSTE MANO DE OBRA:\nFórmula: TInicial de %1 + (NumCopias x T.Empaquetado de %2)").arg(codTipoCentro).arg(codTipoCentro);
    //
    //      tiempoMO = costesEmpaquetadoMO["inicial"] + numCopias * costesEmpaquetadoMO["unidad"];
    //      detalleCoste += util.translate("scripts", "\n%1 + (%2 x %3) = %5").arg(costesEmpaquetadoMO["inicial"]).arg(numCopias).arg(costesEmpaquetadoMO["unidad"]).arg(tiempoMO);
    //
    //      costeUT = parseFloat(costesEmpaquetadoMO["costetiempo"]);
    //      porBeneficio = parseFloat(costesEmpaquetadoMO["porbeneficio"]);
    //      break;
    //    }
    case "TROQUELADO": {
      /** <b>TAREA DE TROQUELADO</b><br/>
      COSTE MANO DE OBRA<br/>
      Se aplica la fórmula CMO = (Coste inicial + (Coste por Unidad x numTrabajos)) x Coste por minuto) + Beneficio, donde:<br/>
      <ul>
      <li>Coste inicial es parámetro del centro de coste de troquelado</li>
      <li>Coste por unidad se obtiene del parámetro Unidades por hora o minutos por unidad del centro de coste</li>
      <li>numTrabajos es el número de pliegos a troquelar</li>
      <li>Beneficio es el resultado de aplicar el porcentaje de beneficio asociado al centro de coste al primer sumando de la fórmula</li>
      </ul>
      */
      var xmlTipoCentro: FLDomNode = flfacturac.iface.pub_dameNodoXML(xmlProceso, "Parametros/TipoTroqueladoraParam");
      if (!xmlTipoCentro) {
        return false;
      }
      var eTipoCentro: FLDomElement = xmlTipoCentro.toElement();
      codTipoCentro = eTipoCentro.attribute("Valor");
      xmlTarea.toElement().setAttribute("CodTipoCentro", codTipoCentro);
      var costesTroqueladoMO: Array = this.iface.costesPorCentroTarea(codTipoCentro, idTipoTareaPro);
      if (!costesTroqueladoMO) {
        return false;
      }

      var xmlParamTroqueladora: FLDomNode = flfacturac.iface.pub_dameParamCentroCoste(codTipoCentro);
      if (!xmlParamTroqueladora) {
        MessageBox.warning(util.translate("scripts", "Error al obtener los parámetros de la troqueladora %1").arg(codTipoCentro), MessageBox.Ok, MessageBox.NoButton);
        return false;
      }

      var nodoTroquelado: FLDomNode = flfacturac.iface.pub_dameNodoXML(xmlProceso, "Parametros/TroqueladoParam");
      if (!nodoTroquelado) {
        //        debug("!nodoTroquelado");
        return false;
      }
      var eTroquelado: FLDomElement = nodoTroquelado.toElement();
      var cantidadesPorModelo: Boolean = flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/PaginasParam@CantidadesPorModelo") == "true";
      var numCopias: Number = parseInt(flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/PaginasParam@NumCopias"));
      var totalTrabajos: Number = parseInt(flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/PaginasParam@Total"));
      var numModelos: Number = parseInt(flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/PaginasParam@NumPaginas"));
      var trabajosTroquel: Number = parseInt(eTroquelado.attribute("TrabajosTroquel"));
      var numTroquelados: Number;

      detalleCoste += util.translate("scripts", "\nCOSTE MANO DE OBRA:");
      if (cantidadesPorModelo) {
        numTroquelados = totalTrabajos * trabajosTroquel;
        numPasadas =  totalTrabajos;
        detalleCoste += util.translate("scripts", "\nTrabajos troquelados = Num.Trabajos x Trabajos por troquel");
        detalleCoste += util.translate("scripts", "\n%1 = %2 x %3").arg(numTroquelados).arg(totalTrabajos).arg(trabajosTroquel);
      } else {
        numTroquelados = numCopias * numModelos * trabajosTroquel;
        numPasadas =  numCopias * numModelos;
        detalleCoste += util.translate("scripts", "\nTrabajos troquelados = Num.Copias x Num.Modelos x Trabajos por troquel");
        detalleCoste += util.translate("scripts", "\n%1 = %2 x %3 x %4").arg(numTroquelados).arg(numCopias).arg(numModelos).arg(trabajosTroquel);
      }

      var xmlListaCostes: FLDomNodeList = xmlParamTroqueladora.toElement().elementsByTagName("Coste");
      if (!xmlListaCostes) {
        MessageBox.warning(util.translate("scripts", "Error al obtener los costes de la plegadora %1").arg(codTipoCentro), MessageBox.Ok, MessageBox.NoButton);
        return false;
      }
      var eCoste: FLDomElement;
      for (var i: Number = 0; i < xmlListaCostes.length(); i++) {
        eCoste = xmlListaCostes.item(i).toElement();
        if (numPasadas < parseInt(eCoste.attribute("CopiasMin"))) {
          continue;
        }
        if (eCoste.attribute("CopiasMax") != "" && numPasadas > parseInt(eCoste.attribute("CopiasMax"))) {
          continue;
        }
        iIntervalo = i;
        break;
      }
      // debug("Inter = " + iIntervalo);
      if (iIntervalo == -1) {
        MessageBox.warning(util.translate("scripts", "Tarea de troquelado:\nNo se ha encontrado un registro de tiempos para los siguientes valores:\nTroqueladora: %1\nCopias: %2\nEsto hará que los cálculos no sean exactos.").arg(codTipoCentro).arg(numTrabajos), MessageBox.Ok, MessageBox.NoButton);
      }
      var costeArranque: Number = 0;
      var costePorCopia: Number = 0;
      var copiasHora: Number = 0;
      var costeFin: Number = 0;
      var intervalo: String = util.translate("scripts", "-Indefinido-");
      var unidadesHora: Number = 0;
      if (iIntervalo >= 0) {
        eCoste = xmlListaCostes.item(iIntervalo).toElement();
        costeArranque = eCoste.attribute("Arranque");
        if (isNaN(costeArranque) || costeArranque == "") {
          costeArranque = 0;
        }
        unidadesHora = eCoste.attribute("UnidadesHora");
        if (isNaN(unidadesHora) || unidadesHora == "") {
          unidadesHora = 0;
        }
        costeFin = eCoste.attribute("Fin");
        if (isNaN(costeFin) || costeFin == "") {
          costeFin = 0;
        }
        intervalo = eCoste.attribute("CopiasMin") + " - " + eCoste.attribute("CopiasMax");
      }
      minutosUnidad = 60 / unidadesHora
                      var tiempoInicial: Number;
      if (eTroquelado.attribute("TiempoPrepTroquel") == "NULL") {
        tiempoInicial = costeArranque;
      } else {
        tiempoInicial = parseFloat(eTroquelado.attribute("TiempoPrepTroquel"));
      }
      var tiempoFinal: Number = costeFin;

      if (cantidadesPorModelo) {
        tiempoMO = parseFloat(tiempoInicial) + parseFloat(totalTrabajos * minutosUnidad) + parseFloat(tiempoFinal);
        detalleCoste += util.translate("scripts", "\nFórmula: TInicial de %1 + (NumTrabajos x T.Troquelado de %2) + TFinal").arg(codTipoCentro).arg(codTipoCentro);
        detalleCoste += util.translate("scripts", "\n%1 + (%2 x %3) + %4 = %5 (a %6 Unidades/Hora)").arg(tiempoInicial).arg(totalTrabajos).arg(minutosUnidad).arg(tiempoFinal).arg(tiempoMO).arg(unidadesHora);
      } else {
        tiempoMO = parseFloat(tiempoInicial) + parseFloat(numCopias * numModelos * minutosUnidad) + parseFloat(tiempoFinal);
        detalleCoste += util.translate("scripts", "\nFórmula: TInicial de %1 + (NumCopias x NumModelos x T.Troquelado de %2) + TFinal").arg(codTipoCentro).arg(codTipoCentro);
        detalleCoste += util.translate("scripts", "\n%1 + (%2 x %3 x %4) + %5 = %6 (a %7 Unidades/Hora)").arg(tiempoInicial).arg(numCopias).arg(numModelos).arg(minutosUnidad).arg(tiempoFinal).arg(tiempoMO).arg(unidadesHora);
      }
      detalleCoste += util.translate("scripts", "\n(los costes son los asociados al intervalo de copias %1, a %2 copias/hora).").arg(intervalo).arg(unidadesHora);

      var tiempoMinimo: Number = costesTroqueladoMO["tiempominimo"];
      if (isNaN(tiempoMinimo)) {
        tiempoMinimo = 0;
      }
      if (tiempoMO < tiempoMinimo) {
        tiempoReal = tiempoMO;
        tiempoMO = tiempoMinimo;
        detalleCoste += util.translate("scripts", "\nAplicando tiempo mínimo de %1: Tiempo = %2").arg(codTipoCentro).arg(tiempoMinimo);
      }

      instrucciones += util.translate("scripts", "\nSe troquelarán %1 pliegos de troquel con %2 trabajos por troquel").arg(totalTrabajos).arg(trabajosTroquel);
      var refTroquel: String = eTroquelado.attribute("RefTroquel");
      if (refTroquel && refTroquel != "") {
        instrucciones += util.translate("scripts", "\nSe usará el troquel %1").arg(refTroquel);
      }

      detalleCosteMat += util.translate("scripts", "\nCOSTE MATERIAL:");
      if (eTroquelado.attribute("ConCosteTroquel") == "true") {
        var costeTroquel: Number = parseFloat(eTroquelado.attribute("CosteTroquel"));
        detalleCosteMat += util.translate("scripts", "\nCoste troquel %1: %2").arg(refTroquel).arg(costeTroquel);

        porBeneficioMat = parseFloat(util.sqlSelect("familias", "porbeneficio", "codfamilia = 'TROQ'"));

        costeMat = costeTroquel * (100 + parseFloat(porBeneficioMat)) / 100;
        detalleCosteMat += util.translate("scripts", "\nCosteMaterial = CosteTroquel");
        detalleCosteMat += util.translate("scripts", "\n%1 = %2").arg(costeTroquel).arg(costeMat);

        if (!this.iface.ponConsumoTarea(xmlTarea, refTroquel, 1, costeMat, false, porBeneficioMat)) {
          return false;
        }
      } else {
        detalleCosteMat += util.translate("scripts", "\nNo se incluye en coste del troquel.");
        costeMat = 0;
      }
      costeUT = parseFloat(costesTroqueladoMO["costetiempo"]);
      porBeneficio = parseFloat(costesTroqueladoMO["porbeneficio"]);
      break;
    }
    case "PELADO": {
      /** <b>TAREA DE PELADO</b><br/>
      COSTE MANO DE OBRA<br/>
      Se aplica la fórmula CMO = (Coste inicial + (Coste por Unidad x numPliegosTroquelado)) x Coste por minuto) + Beneficio, donde:<br/>
      <ul>
      <li>Coste inicial es parámetro del centro de coste de pelado</li>
      <li>Coste por unidad se obtiene del parámetro Unidades por hora o minutos por unidad del centro de coste. Si el trabajo tiene establecido un coste por unidad, se toma el del trabajo</li>
      <li>numPliegosTroquelado es el número de pliegos a troquelar</li>
      <li>Beneficio es el resultado de aplicar el porcentaje de beneficio asociado al centro de coste al primer sumando de la fórmula</li>
      </ul>
      */
      var xmlTipoCentro: FLDomNode = flfacturac.iface.pub_dameNodoXML(xmlProceso, "Parametros/TipoPeladoraParam");
      if (!xmlTipoCentro) {
        return false;
      }
      var eTipoCentro: FLDomElement = xmlTipoCentro.toElement();
      codTipoCentro = eTipoCentro.attribute("Valor");
      xmlTarea.toElement().setAttribute("CodTipoCentro", codTipoCentro);
      // debug("Codtipocentro = " + codTipoCentro);
      var costesPeladoMO: Array = this.iface.costesPorCentroTarea(codTipoCentro, idTipoTareaPro);
      if (!costesPeladoMO) {
        return false;
      }

      // debug("Unihora = " + costesPeladoMO["unidadeshora"]);
      var nodoTroquelado: FLDomNode = flfacturac.iface.pub_dameNodoXML(xmlProceso, "Parametros/TroqueladoParam");
      if (!nodoTroquelado) {
        //        debug("!nodoTroquelado");
        return false;
      }
      var eTroquelado: FLDomElement = nodoTroquelado.toElement();

      var nodoPelado: FLDomNode = flfacturac.iface.pub_dameNodoXML(xmlProceso, "Parametros/PeladoParam");
      if (!nodoPelado) {
        //        debug("!nodoPelado");
        return false;
      }
      var ePelado: FLDomElement = nodoPelado.toElement();

      var numCopias: Number = parseInt(flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/PaginasParam@NumCopias"));
      var numModelos: Number = parseInt(flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/PaginasParam@NumPaginas"));
      var trabajosTroquel: Number = parseInt(eTroquelado.attribute("TrabajosTroquel"));
      var numPliegosTroq: Number = numCopias * numModelos;
      numPasadas = numCopias * numModelos;

      detalleCoste += util.translate("scripts", "\nCOSTE MANO DE OBRA:");
      detalleCoste += util.translate("scripts", "\nPliegos de troquel = Num.Copias x Num.Modelos");
      detalleCoste += util.translate("scripts", "\n%1 = %2 x %3").arg(numPliegosTroq).arg(numCopias).arg(numModelos);

      var unidadesHora: Number
      if (ePelado.attribute("UniHoraPelado") != "NULL") {
        unidadesHora = parseInt(ePelado.attribute("UniHoraPelado"));
      } else {
        unidadesHora = costesPeladoMO["unidadeshora"];
      }

      var minutosUnidad: Number;
      if (unidadesHora > 0) {
        minutosUnidad = 60 / unidadesHora;
      } else {
        minutosUnidad = 0;
      }
      var tiempoInicial = costesPeladoMO["inicial"];

      tiempoMO = tiempoInicial + (numPliegosTroq * minutosUnidad);
      detalleCoste += util.translate("scripts", "\nFórmula: TInicial de %1 + (Pliegos de troquel x T.Pelado)").arg(codTipoCentro);
      detalleCoste += util.translate("scripts", "\n%1 + (%2 x %3) = %4 (a %5 Unidades/Hora)").arg(tiempoInicial).arg(numPliegosTroq).arg(minutosUnidad).arg(tiempoMO).arg(unidadesHora);
      // debug("Detalle coste pelado = " + detalleCoste);

      var tiempoMinimo: Number = costesPeladoMO["tiempominimo"];
      if (isNaN(tiempoMinimo)) {
        tiempoMinimo = 0;
      }
      if (tiempoMO < tiempoMinimo) {
        tiempoReal = tiempoMO;
        tiempoMO = tiempoMinimo;
        detalleCoste += util.translate("scripts", "\nAplicando tiempo mínimo de %1: Tiempo = %2").arg(codTipoCentro).arg(tiempoMinimo);
      }

      instrucciones += util.translate("scripts", "\nSe pelarán %1 pliegos de troquel obteniendo %2 trabajos por troquel").arg(numPliegosTroq).arg(trabajosTroquel);

      costeUT = parseFloat(costesPeladoMO["costetiempo"]);
      porBeneficio = parseFloat(costesPeladoMO["porbeneficio"]);
      break;
    }
    case "EMBUCHADO": {
      /** <b>TAREA DE EMBUCHADO</b><br/>
      COSTE MANO DE OBRA<br/>
      Se aplica la fórmula CMO = (Coste inicial + (Coste por Unidad x numTrabajos)) x Coste por minuto) + Beneficio, donde:<br/>
      <ul>
      <li>Coste inicial es parámetro del centro de coste de embuchado manual</li>
      <li>Coste por unidad se obtiene del parámetro Unidades por hora o minutos por unidad del centro de coste</li>
      <li>numTrabajos es el número de pliegos a embuchar</li>
      <li>Beneficio es el resultado de aplicar el porcentaje de beneficio asociado al centro de coste al primer sumando de la fórmula</li>
      </ul>
      */
      codTipoCentro = "EMBUCHADO MANUAL";
      xmlTarea.toElement().setAttribute("CodTipoCentro", codTipoCentro);

      var costesEmbuchadoMO: Array = this.iface.costesPorCentroTarea(codTipoCentro, idTipoTareaPro);
      if (!costesEmbuchadoMO)
        return false;

      var numCopias: Number = parseInt(flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/NumCopiasParam@Valor"));
      //      var opcion:String = xmlProducto.toElement().attribute("Opcion");
      //      var nodoCombi:FLDomNode = flfacturac.iface.pub_dameNodoXML(xmlProceso, "Parametros/CombEncuadernacionParam/Combinacion[@Opcion=" + opcion + "]");
      var nodoCombi: FLDomNode = flfacturac.iface.pub_dameNodoXML(xmlProceso, "Parametros/CombEncuadernacionParam/Combinacion");
      var embuchesCopia: Number = parseInt(nodoCombi.toElement().attribute("NumPliegosPlegado"));

      detalleCoste += util.translate("scripts", "\nCOSTE MANO DE OBRA:\nEmbuches por copia = %1").arg(embuchesCopia);

      var numPliegosAEmbuchar: Number = embuchesCopia * numCopias;
      numPasadas = numPliegosAEmbuchar;
      detalleCoste += util.translate("scripts", "\nNúmero de embuches = NumCopias x Embuches por copia");
      detalleCoste += util.translate("scripts", "\n%1 x %2 = %3").arg(numCopias).arg(embuchesCopia).arg(numPliegosAEmbuchar);

      tiempoMO = costesEmbuchadoMO["inicial"] + numPliegosAEmbuchar * costesEmbuchadoMO["unidad"];
      detalleCoste += util.translate("scripts", "\nFórmula: TInicial de %1 + (Embuches x T.Embuchado de %2)").arg(codTipoCentro).arg(codTipoCentro);
      detalleCoste += util.translate("scripts", "\n%1 + (%2 x %3) = %4 (a %5 Unidades/Hora)").arg(costesEmbuchadoMO["inicial"]).arg(numPliegosAEmbuchar).arg(costesEmbuchadoMO["unidad"]).arg(tiempoMO).arg(costesEmbuchadoMO["unidadeshora"]);

      instrucciones += util.translate("scripts", "\nSe embucharán %1 copias de %2 pliegos de embuchado cada una (%3 embuches)").arg(numCopias).arg(embuchesCopia).arg(numPliegosAEmbuchar);

      costeUT = parseFloat(costesEmbuchadoMO["costetiempo"]);
      porBeneficio = parseFloat(costesEmbuchadoMO["porbeneficio"]);
      break;
    }
    case "GRAPADO":
    case "GRAPADO2": {
      /** <b>TAREA DE GRAPADO</b><br/>
      COSTE MANO DE OBRA<br/>
      Se aplica la fórmula CMO = Tiempo preparación + NumCopias x Tiempo por unidad, donde:<br/>
      <ul>
      <li>Tiempo preparación = Tiempo prep. cabezal normal x Num. Cabezales normales + Tiempo prep. cabezal omega x Num. Cabezales omega</li>
      <li>numCopias es el número de libros</li>
      </ul>
      */
      codTipoCentro = flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/TipoGrapadoraParam@Valor");

      xmlTarea.toElement().setAttribute("CodTipoCentro", codTipoCentro);

      var costesGrapadoMO: Array = this.iface.costesPorCentroTarea(codTipoCentro, idTipoTareaPro);
      if (!costesGrapadoMO) {
        return false;
      }

      var xmlParamGrapadora: FLDomNode = flfacturac.iface.pub_dameParamCentroCoste(codTipoCentro);
      if (!xmlParamGrapadora) {
        return false;
      }

      var numCopias: Number = parseInt(flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/NumCopiasParam@Valor"));
      numPasadas = numCopias;

      var xmlGrapado: FLDomNode = flfacturac.iface.pub_dameNodoXML(xmlProceso, "Parametros/EncuadernacionParam");
      var eGrapado: FLDomElement = xmlGrapado.toElement();

      detalleCoste += util.translate("scripts", "\nCOSTE MANO DE OBRA:");

      var esquemaGrapado: String = eGrapado.attribute("Grapado");
      var tPrepNormal: Number = parseFloat(xmlParamGrapadora.toElement().attribute("TiempoPrepCabNormal"));
      var tPrepOmega: Number = parseFloat(xmlParamGrapadora.toElement().attribute("TiempoPrepCabOmega"));
      var grapasNormal: Number = parseInt(eGrapado.attribute("CabNormales"));
      var grapasOmega: Number = parseInt(eGrapado.attribute("CabOmega"));

      var tPreparacion: Number = (tPrepNormal * grapasNormal) + (tPrepOmega * grapasOmega);
      detalleCoste += util.translate("scripts", "\nTiempo preparación = (T.Prep.Normal x Cabezales normales) + (T.Prep.Omega x Cabezales omega)");
      detalleCoste += util.translate("scripts", "\n(%1 x %2) + (%3 x %4) = %5").arg(tPrepNormal).arg(grapasNormal).arg(tPrepOmega).arg(grapasOmega).arg(tPreparacion);

      var uniHora: Number = parseInt(xmlParamGrapadora.toElement().attribute("UniHora"));
      var tUnidad: Number;
      if (uniHora != 0) {
        tUnidad = 60 / uniHora;
      } else {
        tUnidad = 0;
      }
      tUnidad = util.roundFieldValue(tUnidad, "pr_costestarea", "costeunidad")
                tiempoMO = tPreparacion + (numCopias * tUnidad);
      tiempoMO = util.roundFieldValue(tiempoMO, "pr_costestarea", "costeunidad")
                 detalleCoste += util.translate("scripts", "\nTiempo = T.Preparación + (NumCopias x T.Unidad)");
      detalleCoste += util.translate("scripts", "\n%1 + (%2 x %3) = %4 (a %5 unidades/hora)").arg(tPreparacion).arg(numCopias).arg(tUnidad).arg(tiempoMO).arg(uniHora);

      var tiempoMinimo: Number = costesGrapadoMO["tiempominimo"];
      if (isNaN(tiempoMinimo)) {
        tiempoMinimo = 0;
      }
      if (tiempoMO < tiempoMinimo) {
        tiempoReal = tiempoMO;
        tiempoMO = tiempoMinimo;
        detalleCoste += util.translate("scripts", "\nAplicando tiempo mínimo de %1: Tiempo = %2").arg(codTipoCentro).arg(tiempoMinimo);
      }

      instrucciones += util.translate("scripts", "\nSe graparán %1 copias según el esquema %2").arg(numCopias).arg(esquemaGrapado);

      costeUT = parseFloat(costesGrapadoMO["costetiempo"]);
      porBeneficio = parseFloat(costesGrapadoMO["porbeneficio"]);
      break;
    }
    case "E+G+C": {
      /** <b>TAREA DE EMBUCHADO + GRAPADO + CORTE</b><br/>
      COSTE MANO DE OBRA<br/>
      Se aplica la fórmula CMO = Tiempo preparación + NumCopias x Tiempo por unidad, donde:<br/>
      <ul>
      <li></li>
      <li></li>
      </ul>
      */
      codTipoCentro = flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/TipoEGCParam@Valor");

      xmlTarea.toElement().setAttribute("CodTipoCentro", codTipoCentro);

      var costesEGCMO: Array = this.iface.costesPorCentroTarea(codTipoCentro, idTipoTareaPro);
      if (!costesEGCMO) {
        return false;
      }

      var xmlParamEGC: FLDomNode = flfacturac.iface.pub_dameParamCentroCoste(codTipoCentro);
      if (!xmlParamEGC) {
        return false;
      }

      //      var opcion:String = xmlProducto.toElement().attribute("Opcion");
      //      var nodoCombi:FLDomNode = flfacturac.iface.pub_dameNodoXML(xmlProceso, "Parametros/CombEncuadernacionParam/Combinacion[@Opcion=" + opcion + "]");
      var nodoCombi: FLDomNode = flfacturac.iface.pub_dameNodoXML(xmlProceso, "Parametros/CombEncuadernacionParam/Combinacion");
      var hayTapa: Boolean = (flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/TapaParam@Valor") == "true");
      //      var gramaje:String = flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/GramajeParam@Valor");
      //      var espesorPapel:Number = parseFloat(util.sqlSelect("gramajes", "grosorunidad", "gramaje = " + gramaje));
      //      if (isNaN(espesorPapel)) {
      //        return false;
      //      }

      //      var maxPagPliego:Number = parseInt(nodoCombi.toElement().attribute("MaxPaginasPliego"));
      var totalPliegos: Number = parseInt(nodoCombi.toElement().attribute("NumPliegosPlegado"));
      if (hayTapa) {
        totalPliegos++;
      }
      var numBandejas: Number = parseInt(xmlParamEGC.toElement().attribute("NumBandejas"));
      var numTandas: Number = Math.ceil(totalPliegos / numBandejas);

      detalleCoste += util.translate("scripts", "\nCOSTE MANO DE OBRA:");

      detalleCoste += util.translate("scripts", "\nNumTandas = TotalPliegos / NumBandejas");
      detalleCoste += util.translate("scripts", "\n%1 / %2 = %3").arg(totalPliegos).arg(numBandejas).arg(numTandas);

      var numCopias: Number = parseInt(flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/NumCopiasParam@Valor"));


      var tPrepFijo: Number = parseFloat(xmlParamEGC.toElement().attribute("TiempoPrepFijo"));
      var tPrepBandeja: Number = parseFloat(xmlParamEGC.toElement().attribute("TiempoPrepBandeja"));
      var espesorMaxBandeja: Number = parseFloat(xmlParamEGC.toElement().attribute("EspesorMaxBandeja"));


      var tPreparacion: Number = tPrepFijo + (tPrepBandeja * (totalPliegos - 1));
      detalleCoste += util.translate("scripts", "\nTiempo preparación = T.Prep.Fijo + (T.Prep.Bandeja x (TotalPliegos - 1))");
      detalleCoste += util.translate("scripts", "\n%1 + (%2 x (%3 - 1)) = %4").arg(tPrepFijo).arg(tPrepBandeja).arg(totalPliegos).arg(tPreparacion);

      var xmlListaCostes: FLDomNodeList = xmlParamEGC.toElement().elementsByTagName("Coste");
      if (!xmlListaCostes) {
        MessageBox.warning(util.translate("scripts", "Error al obtener los costes de la encuadernadora %1").arg(codTipoCentro), MessageBox.Ok, MessageBox.NoButton);
        return false;
      }
      var iIntervalo: Number = -1;
      var eCoste: FLDomElement;
      for (var i: Number = 0; i < xmlListaCostes.length(); i++) {
        eCoste = xmlListaCostes.item(i).toElement();
        if (numCopias < parseInt(eCoste.attribute("CopiasMin"))) {
          continue;
        }
        if (eCoste.attribute("CopiasMax") != "" && numCopias > parseInt(eCoste.attribute("CopiasMax"))) {
          continue;
        }
        iIntervalo = i;
        break;
      }
      // debug("Inter = " + iIntervalo);
      if (iIntervalo == -1) {
        MessageBox.warning(util.translate("scripts", "Tarea de encuadernado (E+G+C):\nNo se ha encontrado un registro de tiempos para los siguientes valores:\nMáquina: %1\nCopias: %2\nEsto hará que los cálculos no sean exactos.").arg(codTipoCentro).arg(numCopias), MessageBox.Ok, MessageBox.NoButton);
      }
      //      var costeArranque:Number = 0;
      //      var costePorCopia:Number = 0;
      //      var copiasHora:Number = 0;
      //      var costeFin:Number = 0;
      var intervalo: String = util.translate("scripts", "-Indefinido-");
      var unidadesHora: Number = 0;
      if (iIntervalo >= 0) {
        eCoste = xmlListaCostes.item(iIntervalo).toElement();
        //        costeArranque = eCoste.attribute("Arranque");
        //        if (isNaN(costeArranque) || costeArranque == "") {
        //          costeArranque = 0;
        //        }
        unidadesHora = eCoste.attribute("UnidadesHora");
        if (isNaN(unidadesHora) || unidadesHora == "") {
          unidadesHora = 0;
        }
        //        costeFin = eCoste.attribute("Fin");
        //        if (isNaN(costeFin) || costeFin == "") {
        //          costeFin = 0;
        //        }
        intervalo = eCoste.attribute("CopiasMin") + " - " + eCoste.attribute("CopiasMax");
      }
      if (unidadesHora == 0) {
        MessageBox.warning(util.translate("scripts", "El centro de coste %1 tiene definida una velocidad de 0 unidades por hora.\nEsto hace inviable el cálculo de costes.").arg(codTipoCentro), MessageBox.Ok, MessageBox.NoButton);
        return false;
      }



      //      var uniHora:Number = parseInt(xmlParamEGC.toElement().attribute("UniHora"));
      var tUnidad: Number;
      if (unidadesHora != 0) {
        tUnidad = 60 / unidadesHora;
      } else {
        tUnidad = 0;
      }
      tUnidad = util.roundFieldValue(tUnidad, "pr_costestarea", "costeunidad")
                tiempoMO = tPreparacion + (numCopias * numTandas * tUnidad);
      tiempoMO = util.roundFieldValue(tiempoMO, "pr_costestarea", "costeunidad")
                 detalleCoste += util.translate("scripts", "\nTiempo = T.Preparación + (Núm. Copias x NumTandas x T.Unidad)");
      detalleCoste += util.translate("scripts", "\n%1 + (%2 x %3 x %4) = %5 (a %6 unidades/hora)").arg(tPreparacion).arg(numCopias).arg(numTandas).arg(tUnidad).arg(tiempoMO).arg(unidadesHora);

      //      numPasadas = numCopias * rondasCopia;

      var tiempoMinimo: Number = costesEGCMO["tiempominimo"];
      if (isNaN(tiempoMinimo)) {
        tiempoMinimo = 0;
      }
      if (tiempoMO < tiempoMinimo) {
        tiempoReal = tiempoMO;
        tiempoMO = tiempoMinimo;
        detalleCoste += util.translate("scripts", "\nAplicando tiempo mínimo de %1: Tiempo = %2").arg(codTipoCentro).arg(tiempoMinimo);
      }

      instrucciones += util.translate("scripts", "\nSe procesarán %1 copias en la máquina %2, distribuidas en %3 tandas.\n").arg(numCopias).arg(codTipoCentro).arg(numTandas);

      costeUT = parseFloat(costesEGCMO["costetiempo"]);
      porBeneficio = parseFloat(costesEGCMO["porbeneficio"]);
      break;
    }
    case "PRECORTE ALZADO": {
      /** <b>TAREA DE CORTE PREVIO AL ALZADO</b><br/>
      COSTE MANO DE OBRA<br/>
      Se aplica la fórmula CMO = Tiempo preparación + NumCopias x Tiempo por unidad, donde:<br/>
      <ul>
      <li></li>
      <li></li>
      </ul>
      */
      codTipoCentro = flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/TipoGuillotinaPAParam@Valor");
      xmlTarea.toElement().setAttribute("CodTipoCentro", codTipoCentro);

      var costesGuillotinaMO: Array = this.iface.costesPorCentroTarea(codTipoCentro, idTipoTareaPro);
      if (!costesGuillotinaMO) {
        return false;
      }

      var xmlParamGuillotina: FLDomNode = flfacturac.iface.pub_dameParamCentroCoste(codTipoCentro);
      if (!xmlParamGuillotina) {
        return false;
      }

      var numCopias: Number = parseInt(flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/NumCopiasParam@Valor"));
      //      var opcion:String = xmlProducto.toElement().attribute("Opcion");
      //      var nodoCombi:FLDomNode = flfacturac.iface.pub_dameNodoXML(xmlProceso, "Parametros/CombEncuadernacionParam/Combinacion[@Opcion=" + opcion + "]");
      var nodoCombi: FLDomNode = flfacturac.iface.pub_dameNodoXML(xmlProceso, "Parametros/CombEncuadernacionParam/Combinacion");
      var pliegosPlegado: FLDomNodeList = nodoCombi.childNodes();
      var paginasPliego: Number;

      var gramaje: String = flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/GramajeParam@Valor");

      instrucciones += util.translate("scripts", "\nSe cortarán los pliegos de impresión obtenidos de la siguiente forma:");
      detalleCoste += util.translate("scripts", "\nCOSTE MANO DE OBRA:\nFórmula: TInicial de %1 + (numCortes x TCorte de %2)").arg(codTipoCentro).arg(codTipoCentro);

      var tipoEncuadernacion: String = flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/EncuadernacionParam@Tipo");
      var paginasPliego: Number;
      var pliegos: Number;
      var numTandas: Number;
      var esquemaCorte: String;
      var cortesTanda: Number;
      var numCortes: Number;
      var totalCortes: Number = 0;
      for (var i: Number = 0; i < pliegosPlegado.length(); i++) {
        pliegos = parseInt(pliegosPlegado.item(i).toElement().attribute("NumPliegos"));
        pliegos = pliegos * numCopias;
        paginasPliego = parseInt(pliegosPlegado.item(i).toElement().attribute("PaginasPliego"));
        switch (paginasPliego) {
          case 4: {
            if (tipoEncuadernacion == "Wire-o") {
              esquemaCorte = "1x0";
              cortesTanda = 1;
            } else {
              continue;
            }
          }
          case 8: {
            if (tipoEncuadernacion == "Wire-o") {
              esquemaCorte = "1x1";
              cortesTanda = 2;
            } else {
              esquemaCorte = "0x1";
              cortesTanda = 1;
            }
            break;
          }
          case 16: {
            if (tipoEncuadernacion == "Wire-o") {
              esquemaCorte = "2x1";
              cortesTanda = 3;
            } else {
              esquemaCorte = "1x1";
              cortesTanda = 2;
            }
            break;
          }
        }
        numTandas = this.iface.tandasGuillotina(xmlParamGuillotina, gramaje, pliegos, "gramajes");
        if (!numTandas) {
          return false;
        }
        numCortes = cortesTanda * numTandas;
        totalCortes += numCortes;
        instrucciones += util.translate("scripts", "\n%1 pliegos con corte de %2 páginas según esquema %3. %4 tandas de %5 pliegos").arg(pliegos).arg(paginasPliego).arg(esquemaCorte).arg(numTandas).arg(Math.ceil(pliegos / numTandas));
        detalleCoste += util.translate("scripts", "\n%1 pliegos con corte de %2 páginas según esquema %3: %4 cortes x %5 tandas = %6 cortes").arg(pliegos).arg(paginasPliego).arg(esquemaCorte).arg(cortesTanda).arg(numTandas).arg(numCortes);
      }
      if (tipoEncuadernacion == "Wire-o") {
        instrucciones += util.translate("scripts", "\nNOTA: Por ser encuadernación Wire-o es necesario cortar a tamaño de libro cerrado");
      }

      tiempoMO = costesGuillotinaMO["inicial"] + numCortes * costesGuillotinaMO["unidad"];
      tiempoMO = util.roundFieldValue(tiempoMO, "pr_costestarea", "costeunidad")

                 detalleCoste += util.translate("scripts", "\n%1 + (%2 x %3) = %4").arg(costesGuillotinaMO["inicial"]).arg(totalCortes).arg(costesGuillotinaMO["unidad"]).arg(tiempoMO);

      costeUT = parseFloat(costesGuillotinaMO["costetiempo"]);
      porBeneficio = parseFloat(costesGuillotinaMO["porbeneficio"]);
      break;
    }
    case "PRECORTE W-O": {
      /** <b>TAREA DE CORTE PREVIO AL ENCUADERNADO CON WIRE-O</b><br/>
      COSTE MANO DE OBRA<br/>
      Se aplica la fórmula CMO = Tiempo preparación + NumCopias x Tiempo por unidad, donde:<br/>
      <ul>
      <li></li>
      <li></li>
      </ul>
      */
      codTipoCentro = flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/TipoGuillotinaPWOParam@Valor");
      xmlTarea.toElement().setAttribute("CodTipoCentro", codTipoCentro);

      var costesGuillotinaMO: Array = this.iface.costesPorCentroTarea(codTipoCentro, idTipoTareaPro);
      if (!costesGuillotinaMO) {
        return false;
      }

      var xmlParamGuillotina: FLDomNode = flfacturac.iface.pub_dameParamCentroCoste(codTipoCentro);
      if (!xmlParamGuillotina) {
        return false;
      }

      var numCopias: Number = parseInt(flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/NumCopiasParam@Valor"));
      //      var opcion:String = xmlProducto.toElement().attribute("Opcion");
      //      var nodoCombi:FLDomNode = flfacturac.iface.pub_dameNodoXML(xmlProceso, "Parametros/CombEncuadernacionParam/Combinacion[@Opcion=" + opcion + "]");
      var nodoCombi: FLDomNode = flfacturac.iface.pub_dameNodoXML(xmlProceso, "Parametros/CombEncuadernacionParam/Combinacion");
      var pliegosPlegado: FLDomNodeList = nodoCombi.childNodes();
      var paginasPliego: Number;

      var gramaje: String = flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/GramajeParam@Valor");

      instrucciones += util.translate("scripts", "\nSe cortarán los pliegos de impresión obtenidos de la siguiente forma:");
      detalleCoste += util.translate("scripts", "\nCOSTE MANO DE OBRA:\nFórmula: TInicial de %1 + (numCortes x TCorte de %2)").arg(codTipoCentro).arg(codTipoCentro);

      var paginasPliego: Number;
      var pliegos: Number;
      var numTandas: Number;
      var esquemaCorte: String;
      var cortesTanda: Number;
      var numCortes: Number;
      var totalCortes: Number = 0;
      for (var i: Number = 0; i < pliegosPlegado.length(); i++) {
        pliegos = parseInt(pliegosPlegado.item(i).toElement().attribute("NumPliegos"));
        pliegos = pliegos * numCopias;
        paginasPliego = parseInt(pliegosPlegado.item(i).toElement().attribute("PaginasPliego"));
        switch (paginasPliego) {
          case 4: {
            esquemaCorte = "1x0";
            cortesTanda = 1;
            break;
          }
          case 8: {
            esquemaCorte = "1x1";
            cortesTanda = 2;
            break;
          }
          case 16: {
            esquemaCorte = "2x1";
            cortesTanda = 3;
            break;
          }
        }
        numTandas = this.iface.tandasGuillotina(xmlParamGuillotina, gramaje, pliegos, "gramajes");
        if (!numTandas) {
          return false;
        }
        numCortes = cortesTanda * numTandas;
        totalCortes += numCortes;
        instrucciones += util.translate("scripts", "\n%1 pliegos con corte de %2 páginas según esquema %3. %4 tandas de %5 pliegos").arg(pliegos).arg(paginasPliego).arg(esquemaCorte).arg(numTandas).arg(Math.ceil(pliegos / numTandas));
        detalleCoste += util.translate("scripts", "\n%1 pliegos con corte de %2 páginas según esquema %3: %4 cortes x %5 tandas = %6 cortes").arg(pliegos).arg(paginasPliego).arg(esquemaCorte).arg(cortesTanda).arg(numTandas).arg(numCortes);
      }

      tiempoMO = costesGuillotinaMO["inicial"] + numCortes * costesGuillotinaMO["unidad"];
      tiempoMO = util.roundFieldValue(tiempoMO, "pr_costestarea", "costeunidad")

                 detalleCoste += util.translate("scripts", "\n%1 + (%2 x %3) = %4").arg(costesGuillotinaMO["inicial"]).arg(totalCortes).arg(costesGuillotinaMO["unidad"]).arg(tiempoMO);

      costeUT = parseFloat(costesGuillotinaMO["costetiempo"]);
      porBeneficio = parseFloat(costesGuillotinaMO["porbeneficio"]);
      break;
    }
    case "WIRE-O":
    case "WIRE-O2": {
      codTipoCentro = flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/TipoMaquinaWireOParam@Valor");
      xmlTarea.toElement().setAttribute("CodTipoCentro", codTipoCentro);

      var costesWireO: Array = this.iface.costesPorCentroTarea(codTipoCentro, idTipoTareaPro);
      if (!costesWireO) {
        return false;
      }

      //      var xmlParamWire0:FLDomNode = flfacturac.iface.pub_dameParamCentroCoste(codTipoCentro);
      //      if (!xmlParamWire0) {
      //        return false;
      //      }

      var numCopias: Number = parseInt(flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/NumCopiasParam@Valor"));
      numPasadas = numCopias;

      instrucciones += util.translate("scripts", "\nSe encuadernarán en wire-o los %1 libros").arg(numCopias);
      detalleCoste += util.translate("scripts", "\nCOSTE MANO DE OBRA:\nFórmula: TInicial de %1 + (numCopias x TCorte de %2)").arg(codTipoCentro).arg(codTipoCentro);

      tiempoMO = costesWireO["inicial"] + numCopias * costesWireO["unidad"];
      tiempoMO = util.roundFieldValue(tiempoMO, "pr_costestarea", "costeunidad")

                 detalleCoste += util.translate("scripts", "\n%1 + (%2 x %3) = %4").arg(costesWireO["inicial"]).arg(numCopias).arg(costesWireO["unidad"]).arg(tiempoMO);

      var tiempoMinimo: Number = costesWireO["tiempominimo"];
      if (isNaN(tiempoMinimo)) {
        tiempoMinimo = 0;
      }
      if (tiempoMO < tiempoMinimo) {
        tiempoReal = tiempoMO;
        tiempoMO = tiempoMinimo;
        detalleCoste += util.translate("scripts", "\nAplicando tiempo mínimo de %1: Tiempo = %2").arg(codTipoCentro).arg(tiempoMinimo);
      }

      costeUT = parseFloat(costesWireO["costetiempo"]);
      porBeneficio = parseFloat(costesWireO["porbeneficio"]);
      break;
    }
    case "POSCORTE W-O": {
      /** <b>TAREA DE CORTE POSTERIOR AL ENCUADERNADO CON WIRE-O (4º corte)</b><br/>
      COSTE MANO DE OBRA<br/>
      Se aplica la fórmula CMO = Tiempo preparación + NumCopias x Tiempo por unidad, donde:<br/>
      <ul>
      <li></li>
      <li></li>
      </ul>
      */
      codTipoCentro = flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/TipoGuillotinaPOSWOParam@Valor");
      xmlTarea.toElement().setAttribute("CodTipoCentro", codTipoCentro);

      var costesGuillotinaMO: Array = this.iface.costesPorCentroTarea(codTipoCentro, idTipoTareaPro);
      if (!costesGuillotinaMO) {
        return false;
      }

      var xmlParamGuillotina: FLDomNode = flfacturac.iface.pub_dameParamCentroCoste(codTipoCentro);
      if (!xmlParamGuillotina) {
        return false;
      }

      var numCopias: Number = parseInt(flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/NumCopiasParam@Valor"));

      var numPaginas: Number = parseInt(flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/NumPaginasParam@Valor"));
      var numHojas: Number = numPaginas / 2;

      var gramaje: String = flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/GramajeParam@Valor");

      var numTandas: Number;
      numTandas = this.iface.tandasGuillotina(xmlParamGuillotina, gramaje, numHojas, "gramajes");
      if (!numTandas) {
        return false;
      }

      if (numTandas > 1) {
        this.iface.marcarProcesoInviable(xmlProceso, util.translate("scripts", "El grosor del libro no permite su corte en %1").arg(codTipoCentro));
        return true;
      }

      instrucciones += util.translate("scripts", "\nSe realizará el cuarto corte de %1 libros en wire-o.").arg(numCopias);
      detalleCoste += util.translate("scripts", "\nCOSTE MANO DE OBRA:\nFórmula: TInicial de %1 + (numCopias x TCorte de %2)").arg(codTipoCentro).arg(codTipoCentro);

      tiempoMO = costesGuillotinaMO["inicial"] + numCopias * costesGuillotinaMO["unidad"];
      tiempoMO = util.roundFieldValue(tiempoMO, "pr_costestarea", "costeunidad")

                 detalleCoste += util.translate("scripts", "\n%1 + (%2 x %3) = %4").arg(costesGuillotinaMO["inicial"]).arg(numCopias).arg(costesGuillotinaMO["unidad"]).arg(tiempoMO);

      costeUT = parseFloat(costesGuillotinaMO["costetiempo"]);
      porBeneficio = parseFloat(costesGuillotinaMO["porbeneficio"]);
      break;
    }
    case "CORTE TRILATERAL": /// Corte posterior al grapado
    case "CORTE TRILATERAL2": {
      /** <b>TAREA DE CORTE POSTERIOR AL ENCUADERNADO CON WIRE-O (4º corte)</b><br/>
      COSTE MANO DE OBRA<br/>
      Se aplica la fórmula CMO = Tiempo preparación + NumCopias x Tiempo por unidad, donde:<br/>
      <ul>
      <li></li>
      <li></li>
      </ul>
      */
      codTipoCentro = flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/TipoGuillotinaTriParam@Valor");
      xmlTarea.toElement().setAttribute("CodTipoCentro", codTipoCentro);

      var costesGuillotinaMO: Array = this.iface.costesPorCentroTarea(codTipoCentro, idTipoTareaPro);
      if (!costesGuillotinaMO) {
        return false;
      }

      var xmlParamGuillotina: FLDomNode = flfacturac.iface.pub_dameParamCentroCoste(codTipoCentro);
      if (!xmlParamGuillotina) {
        return false;
      }

      var numCopias: Number = parseInt(flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/NumCopiasParam@Valor"));

      instrucciones += util.translate("scripts", "\nSe realizará el corte de trilateral de %1 libros").arg(numCopias);
      detalleCoste += util.translate("scripts", "\nCOSTE MANO DE OBRA:\nFórmula: TInicial de %1 + (numCopias x TCorte de %2 x 3)").arg(codTipoCentro).arg(codTipoCentro);

      tiempoMO = costesGuillotinaMO["inicial"] + numCopias * 3 * costesGuillotinaMO["unidad"];
      tiempoMO = util.roundFieldValue(tiempoMO, "pr_costestarea", "costeunidad")

                 detalleCoste += util.translate("scripts", "\n%1 + (%2 x %3 x3) = %4").arg(costesGuillotinaMO["inicial"]).arg(numCopias).arg(costesGuillotinaMO["unidad"]).arg(tiempoMO);

      costeUT = parseFloat(costesGuillotinaMO["costetiempo"]);
      porBeneficio = parseFloat(costesGuillotinaMO["porbeneficio"]);
      break;
    }
    case "ALZADO": {
      /** <b>TAREA DE ALZADO</b><br/>
      COSTE MANO DE OBRA<br/>
      <br/>
      <ul>
      <li></li>
      <li></li>
      </ul>
      */
      codTipoCentro = flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/TipoAlzadoraParam@Valor");

      xmlTarea.toElement().setAttribute("CodTipoCentro", codTipoCentro);

      var costesAlzadoraMO: Array = this.iface.costesPorCentroTarea(codTipoCentro, idTipoTareaPro);
      if (!costesAlzadoraMO) {
        return false;
      }

      var xmlParamAlzadora: FLDomNode = flfacturac.iface.pub_dameParamCentroCoste(codTipoCentro);
      if (!xmlParamAlzadora) {
        return false;
      }

      var numPaginas: Number = flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/NumPaginasParam@Valor");
      var tipoEncuadernacion: String = flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/EncuadernacionParam@Tipo");

      detalleCoste += util.translate("scripts", "\nCOSTE MANO DE OBRA:");
      var numPliegosAlzadora: Number;
      if (tipoEncuadernacion == "Wire-o") {
        numPliegosAlzadora = numPaginas / 2; /// Con wire-o se alza a tamaño cerrado.
        detalleCoste += util.translate("scripts", "\nPliegos alzadora = NumPaginas / 2 (con wire-o se alza a tamaño cerrado");
        detalleCoste += util.translate("scripts", "\n%1 / 2 = %2").arg(numPaginas).arg(numPliegosAlzadora);
      } else {
        numPliegosAlzadora = numPaginas / 4;
        detalleCoste += util.translate("scripts", "\nPliegos alzadora = NumPaginas / 4");
        detalleCoste += util.translate("scripts", "\n%1 / 4 = %2").arg(numPaginas).arg(numPliegosAlzadora);
      }

      var numCopias: Number = parseInt(flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/NumCopiasParam@Valor"));
      var numBandejas: Number = parseInt(xmlParamAlzadora.toElement().attribute("NumBandejas"));
      var espesorMaxBandeja: Number = parseFloat(xmlParamAlzadora.toElement().attribute("EspesorMaxBandeja"));

      var gramaje: String = flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/GramajeParam@Valor");
      var espesorPapel: Number = parseFloat(util.sqlSelect("gramajes", "grosorunidad", "gramaje = " + gramaje));
      if (isNaN(espesorPapel)) {
        return false;
      }
      var espesorPliegos: Number = espesorPapel * numCopias;
      detalleCoste += util.translate("scripts", "\nEspesor pliegos = EspesorPapel x NumCopias (el gramaje es %1)").arg(gramaje);
      detalleCoste += util.translate("scripts", "\n%1cm x %2 = %3cm").arg(espesorPapel).arg(numCopias).arg(espesorPliegos);

      var numBandejasAUsar: Number = numPliegosAlzadora * Math.ceil(espesorPliegos / espesorMaxBandeja);
      detalleCoste += util.translate("scripts", "\nBandejas a usar = PliegosAlzadora x (EspesorPliegos / EspesorMaximoBandeja)");
      detalleCoste += util.translate("scripts", "\n%1 x (%2cm / %3cm) = %4").arg(numPliegosAlzadora).arg(espesorPliegos).arg(espesorMaxBandeja).arg(numBandejasAUsar);

      var tPrepBandeja: Number = parseFloat(xmlParamAlzadora.toElement().attribute("TiempoPrepBandeja"));
      var tPreparacion: Number = tPrepBandeja * numBandejasAUsar;
      detalleCoste += util.translate("scripts", "\nTiempo preparación = T.Prep.Bandeja x BandejasAUsar");
      detalleCoste += util.translate("scripts", "\n%1 x %2 = %3").arg(tPrepBandeja).arg(numBandejasAUsar).arg(tPreparacion);

      var numAlzados: Number = Math.ceil(numPliegosAlzadora / numBandejas) * numCopias;
      detalleCoste += util.translate("scripts", "\nAlzados = (NumPliegosAlzadora / NumBandejas) x NumCopias");
      detalleCoste += util.translate("scripts", "\n(%1 / %2) x %3 = %4").arg(numPliegosAlzadora).arg(numBandejas).arg(numCopias).arg(numAlzados);

      numPasadas = numAlzados;

      var uniHora: Number = parseInt(xmlParamAlzadora.toElement().attribute("UniHora"));
      var tUnidad: Number;
      if (uniHora != 0) {
        tUnidad = 60 / uniHora;
      } else {
        tUnidad = 0;
      }
      tUnidad = util.roundFieldValue(tUnidad, "pr_costestarea", "costeunidad")
                tiempoMO = tPreparacion + (numAlzados * tUnidad);
      tiempoMO = util.roundFieldValue(tiempoMO, "pr_costestarea", "costeunidad")
                 detalleCoste += util.translate("scripts", "\nTiempo = T.Preparación + (Alzados x T.Unidad)");
      detalleCoste += util.translate("scripts", "\n%1 + (%2 x %3) = %4 (a %5 alzados/hora)").arg(tPreparacion).arg(numAlzados).arg(tUnidad).arg(tiempoMO).arg(uniHora);

      var tiempoMinimo: Number = costesAlzadoraMO["tiempominimo"];
      if (isNaN(tiempoMinimo)) {
        tiempoMinimo = 0;
      }
      if (tiempoMO < tiempoMinimo) {
        tiempoReal = tiempoMO;
        tiempoMO = tiempoMinimo;
        detalleCoste += util.translate("scripts", "\nAplicando tiempo mínimo de %1: Tiempo = %2").arg(codTipoCentro).arg(tiempoMinimo);
      }

      instrucciones += util.translate("scripts", "\nSe procesarán %1 copias en la máquina %2.\n").arg(numCopias).arg(codTipoCentro);

      costeUT = parseFloat(costesAlzadoraMO["costetiempo"]);
      porBeneficio = parseFloat(costesAlzadoraMO["porbeneficio"]);
      break;
    }
    case "ENVIO": {
      /** <b>TAREA DE ENVIO</b><br/>
      COSTE MANO DE OBRA<br/>
      <br/>
      <ul>
      <li></li>
      <li></li>
      </ul>
      */
      var codTipoCentro = "ENVIO";
      xmlTarea.toElement().setAttribute("CodTipoCentro", codTipoCentro);


      var peso: Number = flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/DatosParam@Peso");
      var nombre: String = flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/DatosParam@Nombre");
      var numCopias: Number = flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/DatosParam@NumCopias");
      var direccion: String = flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/DatosParam@Direccion");
      var idPoblacion: String = flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/DatosParam@IdPoblacion");
      var idProvincia: String = flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/DatosParam@IdProvincia");
      var poblacion: String = flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/DatosParam@Poblacion");
      var provincia: String = flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/DatosParam@Provincia");
      var codPostal: String = flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/DatosParam@CodPostal");
      var codPais: String = flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/DatosParam@CodPais");
      var codAgencia: String = flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/AgenciaTransporteParam@Valor");
      var idaYVuelta: Boolean = (flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/DatosParam@IdaYVuelta") == "true");

      var pais: String = "";
      if (codPais && codPais != "") {
        pais = util.sqlSelect("paises", "nombre", "codpais = '" + codPais + "'");
      }
      var direccion: String = util.translate("scripts", "%1\n%2 %3 (%4) %5").arg(direccion).arg(poblacion).arg(codPostal).arg(provincia).arg(pais);
      instrucciones += util.translate("scripts", "\nSe enviarán %1 copias (%2 Kg) a:\n%3\n%4\npor la agencia %5").arg(numCopias).arg(peso).arg(nombre).arg(direccion).arg(codAgencia);

      detalleCoste += util.translate("scripts", "\nCOSTE MANO DE OBRA:");
      tiempoMO = 0;
      tiempoMO = util.roundFieldValue(tiempoMO, "pr_costestarea", "costeunidad")
                 detalleCoste += util.translate("scripts", "\nTiempo = 0");

      costeUT = 0;
      porBeneficio = 0;

      detalleCosteMat += util.translate("scripts", "\nCOSTE SERVICIO (PORTES):");
      var portes: Number = flfactppal.iface.pub_obtenerPortesAgencia(codAgencia, peso, idPoblacion, idProvincia, codPais);
      detalleCosteMat += util.translate("scripts", "\nEnvío de %1 Kg a:\n%2\npor la agencia %3").arg(peso).arg(direccion).arg(codAgencia);
      detalleCosteMat += util.translate("scripts", "\nValor portes: %1").arg(portes);
      if (idaYVuelta) {
        portes *= 2;
        detalleCosteMat += util.translate("scripts", "\nIda y vuelta (x2): %1").arg(portes);
      }

      porBeneficioMat = parseFloat(util.sqlSelect("articulos a INNER JOIN familias f ON a.codfamilia = f.codfamilia", "f.porbeneficio", "a.referencia = '" + this.iface.refPortes + "'", "articulos,familias"));
      if (isNaN(porBeneficioMat)) {
        porBeneficioMat = 0;
      }

      costeMat = portes * (100 + parseFloat(porBeneficioMat)) / 100;
      detalleCosteMat += util.translate("scripts", "\nCostePortes = ValorPortes aplicando beneficio de %2").arg(this.iface.refPortes).arg(porBeneficioMat);
      detalleCosteMat += util.translate("scripts", "\n%1 x (100 + %2) / 100 = %3").arg(portes).arg(porBeneficioMat).arg(costeMat);

      if (!this.iface.ponConsumoTarea(xmlTarea, this.iface.refPortes, 1, portes, porBeneficioMat)) {
        return false;
      }

      break;
    }
    case "TAREA_MANUAL": {
      codTipoCentro = "TAREA_MANUAL";
      xmlTarea.toElement().setAttribute("CodTipoCentro", codTipoCentro);

      var unidades: Number = parseFloat(flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/DatosParam@Unidades"));
      var costeUnidad: Number = parseFloat(flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/DatosParam@CosteUnidad"));
      var costeTotal: Number = parseFloat(flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/DatosParam@CosteTotal"));
      var descripcion: String = flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/DatosParam@Descripcion");

      detalleCoste += util.translate("scripts", "\nCOSTE MANO DE OBRA:");
      tiempoMO = costeTotal;
      tiempoMO = util.roundFieldValue(tiempoMO, "pr_costestarea", "costeunidad")
                 detalleCoste += util.translate("scripts", "\nCosteTotal = CosteUnidad * Unidades");
      detalleCoste += util.translate("scripts", "\n%1 = %2 * %3").arg(tiempoMO).arg(costeUnidad).arg(unidades);
      // debug("Tiempo = " + tiempo);
      // debug("costeUT = " + costeUT);
      instrucciones += util.translate("scripts", "Se realizará la tarea %1").arg(descripcion);
      costeUT = 1; /// Los costes ya vienen dados en Euros
      porBeneficio = parseFloat(util.sqlSelect("articulos a INNER JOIN familias f ON a.codfamilia = f.codfamilia", "f.porbeneficio", "a.referencia = 'TAREA_MANUAL'", "articulos,familias"));
      if (isNaN(porBeneficio)) {
        porBeneficio = 0;
      }

      costeMat = 0;
      detalleCosteMat += util.translate("scripts", "\nCOSTE MATERIAL:");
      detalleCosteMat += util.translate("scripts", "\nCoste = (Coste Unitario x Cantidad) x (100 + PorBeneficio) / 100");
      var nodoConsumos: FLDomNode = flfacturac.iface.pub_dameNodoXML(xmlProceso, "Parametros/ConsumosParam");
      if (nodoConsumos) {
        var eConsumo: FLDomElement;
        var referencia: String, desReferencia: String;
        var coste: Number,  cantidad: Number, porBeneficio: Number, totalConsumo: Number;
        var numConsumos: Number = 0;
        for (var nodoConsumo: FLDomNode = nodoConsumos.firstChild(); nodoConsumo; nodoConsumo = nodoConsumo.nextSibling()) {
          eConsumo = nodoConsumo.toElement();
          referencia = eConsumo.attribute("Referencia");
          coste = parseFloat(eConsumo.attribute("Coste"));
          cantidad = parseFloat(eConsumo.attribute("Cantidad"));
          porBeneficio = parseFloat(eConsumo.attribute("PorBeneficio"));
          totalConsumo = coste * cantidad * (100 + porBeneficio) / 100;
          totalConsumo = util.roundFieldValue(totalConsumo, "consumostareamanual", "total");
          desReferencia = util.sqlSelect("articulos", "descripcion", "referencia = '" + referencia + "'");
          detalleCosteMat += util.translate("scripts", "\n%1 - %2: Coste = (%3 x %4) x (100 + %5) / 100 = %6").arg(referencia).arg(desReferencia).arg(coste).arg(cantidad).arg(porBeneficio).arg(totalConsumo);
          if (!this.iface.ponConsumoTarea(xmlTarea, referencia, cantidad, coste, 0, porBeneficio)) {
            return false;
          }
          costeMat += parseFloat(totalConsumo);
          numConsumos++;
        }
        if (numConsumos == 0) {
          detalleCosteMat += util.translate("scripts", "\n(No hay consumos en esta tarea manual)");
        }
      } else {
        detalleCosteMat += util.translate("scripts", "\n(No hay consumos en esta tarea manual)");
      }
      break;
    }
  }
  var costeMO: Number;
  if (tiempoReal == -1)
  {
    tiempoReal = tiempoMO;
  }
  if (tiempoMO != 0)
  {
    costeMO = tiempoMO * costeUT;
    detalleCoste += util.translate("scripts", "\nAplicando %1 Euros/min de %2: %3").arg(costeUT).arg(codTipoCentro).arg(util.roundFieldValue(costeMO, "tareaslp", "costemo"));

    costeMO = costeMO * (100 + porBeneficio) / 100;
    detalleCoste += util.translate("scripts", "\nAplicando %1% de beneficio de %2: %3").arg(porBeneficio).arg(codTipoCentro).arg(util.roundFieldValue(costeMO, "tareaslp", "costemo"));
    //debug(detalleCoste);
    if (!this.iface.ponDetalleTarea(xmlTarea, detalleCoste, "DetalleCoste"))
      return false;
  }
  if (costeMat != 0)
  {
    //debug(detalleCoste);
    if (!this.iface.ponDetalleTarea(xmlTarea, detalleCosteMat, "DetalleCoste"))
      return false;
  }

  xmlTarea.toElement().setAttribute("CodTipoCentro", codTipoCentro);
  xmlTarea.toElement().setAttribute("TiempoPres", util.roundFieldValue(tiempoMO, "lineaspresupuestoscli", "pvptotal"));
  xmlTarea.toElement().setAttribute("Tiempo", util.roundFieldValue(tiempoReal, "lineaspresupuestoscli", "pvptotal"));
  xmlTarea.toElement().setAttribute("CosteTiempo", util.roundFieldValue(costeUT, "lineaspresupuestoscli", "pvptotal"));
  xmlTarea.toElement().setAttribute("PorBenTiempo", util.roundFieldValue(porBeneficio, "lineaspresupuestoscli", "pvptotal"));
  xmlTarea.toElement().setAttribute("CosteMO", util.roundFieldValue(costeMO, "lineaspresupuestoscli", "pvptotal"));
  xmlTarea.toElement().setAttribute("CosteMat", util.roundFieldValue(costeMat, "lineaspresupuestoscli", "pvptotal"));
  xmlTarea.toElement().setAttribute("NumPasadas", numPasadas);
  xmlTarea.toElement().setAttribute("Estado", "OK");

  if (!this.iface.ponDetalleTarea(xmlTarea, instrucciones, "Instrucciones"))
  {
    return false;
  }

  debug("Fin cálculo coste " + tarea);
  return true;
}

function artesG_tandasGuillotina(xmlParamGuillotina: FLDomNode, refPliegoGramaje: String, numCopias: Number, tabla: String): Number {
  var util: FLUtil;

  var maxGrosorCM: Number = parseFloat(flfacturac.iface.pub_dameAtributoXML(xmlParamGuillotina, "@MaxGrosorCm"));
  if (!maxGrosorCM || maxGrosorCM == 0)
  {
    MessageBox.warning(util.translate("scripts", "No tiene configurado el atributo MaxGrosorCm (máximo grosor que admite la guillotina)\npara el tipo de centro de coste %1").arg(codTipoCentro), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }

  var grosorPliego: Number;
  if (tabla == "gramajes")
  {
    grosorPliego = parseFloat(util.sqlSelect("gramajes", "grosorunidad", "gramaje = " + refPliegoGramaje));
    if (isNaN(grosorPliego) || grosorPliego == 0) {
      MessageBox.warning(util.translate("scripts", "No tiene definido el grosor para el gramaje %1").arg(refPliegoGramaje), MessageBox.Ok, MessageBox.NoButton);
      return false;
    }
  } else {
    grosorPliego = parseFloat(util.sqlSelect("articulos", "grosorunidad", "referencia = '" + refPliegoGramaje + "'"));
    if (isNaN(grosorPliego) || grosorPliego == 0)
    {
      MessageBox.warning(util.translate("scripts", "No tiene definido el grosor para el pliego %1").arg(refPliegoGramaje), MessageBox.Ok, MessageBox.NoButton);
      return false;
    }
  }
  debug("grosorPliego = " + grosorPliego);
  debug("numCopias = " + numCopias);
  var anchoACortar = numCopias * grosorPliego;
  debug("anchoACortar = " + anchoACortar);
  var numTandas: Number = Math.ceil(anchoACortar / maxGrosorCM);
  debug("numTandas = " + numTandas);
  return numTandas;
}

function artesG_saltarTarea(xmlTarea: FLDomNode): Boolean {
  xmlTarea.toElement().setAttribute("Estado", "Saltada");
  return true;
}

function artesG_calcularCostes_clicked()
{
  this.iface.calcularCostes(true);
  this.iface.resumenTrabajo();
}

function artesG_tbnCalcularSinCache_clicked()
{
  this.iface.calcularCostes(false);
  this.iface.resumenTrabajo();
}

function artesG_calcularCostes(usarCache: Boolean)
{
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  var curProductos: FLSqlCursor = this.child("tdbProductos").cursor();
  var idProducto: String = curProductos.valueBuffer("idproducto");
  if (!idProducto) {
    return false;
  }
  debug("idProducto = "  + idProducto);
  if (!util.sqlDelete("itinerarioslp", "idproducto = " + idProducto)) {
    return;
  }

  var referencia: String = curProductos.valueBuffer("referencia");
  debug("referencia = "  + referencia);
  var idTipoProceso: String = util.sqlSelect("articulos", "idtipoproceso", "referencia = '" + referencia + "'");
  if (!idTipoProceso) {
    MessageBox.warning(util.translate("scripts", "El artículo indicado (%1) no tiene asignado un tipo de proceso").arg(referencia), MessageBox.Ok, MessageBox.NoButton);
    return;
  }

  var valoresParam: String;
  var xmlDocValoresParam = new FLDomDocument;
  var xmlDocProducto: FLDomDocument = new FLDomDocument;
  var xmlProducto: FLDomNode;
  var xmlValoresParam: FLDomNode;
  var xmlItinerarioProd: FLDomNode;
  var xmlResultado: FLDomDocument = new FLDomDocument;

  var paso: Number = 0;
  var idParam: String;
  var tipoParam: String = "";

  switch (referencia) {
    case "IPTICO": {
      valoresParam = util.sqlSelect("paramiptico", "xml", "idproducto = " + idProducto);
      if (!valoresParam) {
        valoresParam = util.sqlSelect("paramiptico", "xml", "idlinea = " + cursor.valueBuffer("idlinea"));
      }
      idParam = util.sqlSelect("paramiptico", "id", "idproducto = " + idProducto);
      tipoParam = "paramiptico";
      break;
    }
    case "PAGINAS_LIBRO": {
      valoresParam = util.sqlSelect("paramiptico", "xml", "idproducto = " + idProducto);
      idParam = util.sqlSelect("paramiptico", "id", "idproducto = " + idProducto);
      tipoParam = "paramiptico";
      break;
    }
    case "TAPA_LIBRO": {
      valoresParam = util.sqlSelect("paramiptico", "xml", "idproducto = " + idProducto);
      idParam = util.sqlSelect("paramiptico", "id", "idproducto = " + idProducto);
      tipoParam = "paramiptico";
      break;
    }
    case "ENCUADERNACION": {
      valoresParam = util.sqlSelect("paramlibro", "xml", "idproducto = " + idProducto);
      if (!valoresParam) {
        valoresParam = util.sqlSelect("paramlibro", "xml", "idlinea = " + cursor.valueBuffer("idlinea"));
      }
      break;
    }
    case "TACO": {
      valoresParam = util.sqlSelect("paramtaco", "xml", "idproducto = " + idProducto);
      if (!valoresParam) {
        valoresParam = util.sqlSelect("paramtaco", "xml", "idlinea = " + cursor.valueBuffer("idlinea"));
      }
      idParam = util.sqlSelect("paramtaco", "id", "idproducto = " + idProducto);
      tipoParam = "paramtaco";
      break;
    }
    case "ENVIO": {
      valoresParam = util.sqlSelect("paramenvio", "xml", "idproducto = " + idProducto);
      break;
    }
    case "TAREA_MANUAL": {
      valoresParam = util.sqlSelect("paramtareamanual", "xml", "idproducto = " + idProducto);
      break;
    }
  }

  if (!valoresParam) {
    MessageBox.warning(util.translate("scripts", "Error: Los parámetros del producto no están definidos"), MessageBox.Ok, MessageBox.NoButton);
    return;
  }
  if (xmlDocValoresParam) {
    delete xmlDocValoresParam;
  }
  if (!xmlDocValoresParam.setContent(valoresParam)) {
    MessageBox.warning(util.translate("scripts", "Error al parsear el documento XML de parámetros de la línea"), MessageBox.Ok, MessageBox.NoButton);
    return;
  }

  var desProducto: String = curProductos.valueBuffer("descripcion") + " - " + cursor.cursorRelation().valueBuffer("nombrecliente") + " - " + cursor.valueBuffer("descripcion");

  if (xmlDocProducto) {
    delete xmlDocProducto;
  }
  if (!xmlDocProducto.setContent("<Producto IdTipoProceso='" + idTipoProceso + "' Ref='" + referencia + "'><Itinerario Desc='" + desProducto + "'><Tareas/></Itinerario></Producto>")) {
    return false;
  }
  var docCache: String = "";
  var xmlDocCache: FLDomDocument;
  if (usarCache && tipoParam == "paramiptico") {
    docCache = this.iface.buscarCache(xmlDocValoresParam);
    if (docCache && docCache != "") {
      debug("Encontrado cache: " + docCache);
      xmlDocCache = new FLDomDocument;
      xmlDocCache.setContent(docCache);
    }
  }
  xmlProducto = xmlDocProducto.firstChild();
  //  xmlProducto.toElement().setAttribute("Opcion", qryProductos.value("opcion"));
  //  xmlProducto.toElement().setAttribute("ParteOpcion", qryProductos.value("parteopcion"));
  if (docCache && docCache != "") {
    xmlProducto.firstChild().appendChild(xmlDocCache.firstChild().cloneNode());
  } else {
    xmlProducto.firstChild().appendChild(xmlDocValoresParam.firstChild().cloneNode());
  }
  debug("evaluando " + xmlDocValoresParam.toString(4));

  xmlItinerarioProd = xmlProducto.namedItem("Itinerario");
  if (!this.iface.evaluarVariantes(xmlItinerarioProd)) {
    MessageBox.warning(util.translate("scripts", "Error al evaluar los itinerarios para el producto %1").arg(xmlProducto.toElement().attribute("Ref")), MessageBox.Ok, MessageBox.NoButton);
    xmlResultado.appendChild(xmlProducto.cloneNode());
    return;
  } else {
    //      MessageBox.information(util.translate("scripts", "Proceso de evaluación OK"), MessageBox.Ok, MessageBox.NoButton);
  }

  xmlResultado.appendChild(xmlProducto.cloneNode());

  Dir.current = Dir.home;
  File.write("costesproceso.xml", xmlResultado.toString(4));

  if (!this.iface.volcarDatosProducto(xmlProducto, idProducto)) {
    return false;
  }
  if (!this.iface.marcarMejorItinerario(idProducto)) {
    return false;
  }
  if (!flfacturac.iface.pub_guardarCache(xmlDocValoresParam, idProducto, tipoParam, idParam)) {
    return false;
  }

  MessageBox.information(util.translate("scripts", "Cálculo finalizado"), MessageBox.Ok, MessageBox.NoButton);

  if (!flfacturac.iface.pub_seleccionarOpcionProductos(cursor.valueBuffer("idlinea"))) {
    return false;
  }

  this.child("tdbProductos").refresh();
  this.child("tdbItinerarios").refresh();
  this.child("fdbCosteProd").setValue(this.iface.calculateField("costeprod"));

  return true;
}

// function artesG_OLD_calcularCostes(usarCache:Boolean)
// {
//  var util:FLUtil = new FLUtil;
//  var cursor:FLSqlCursor = this.cursor();
//
//  var curProductos:FLSqlCursor = this.child("tdbProductos").cursor();
//  var idProducto:String = curProductos.valueBuffer("idproducto");
//  if (!idProducto) {
//    return false;
//  }
// debug("idProducto = "  + idProducto);
//  if (!util.sqlDelete("itinerarioslp", "idproducto = " + idProducto)) {
//    return;
//  }
//
// //   var idComponente:String = curProductos.valueBuffer("idcomponente");
// //   var idGrupoCalculo:String = curProductos.valueBuffer("idgrupocalculo");
//
//  var referencia:String = curProductos.valueBuffer("referencia");
// debug("referencia = "  + referencia);
//  var idTipoProceso:String = util.sqlSelect("articulos", "idtipoproceso", "referencia = '" + referencia + "'");
//  if (!idTipoProceso) {
//    MessageBox.warning(util.translate("scripts", "El artículo indicado (%1) no tiene asignado un tipo de proceso").arg(referencia), MessageBox.Ok, MessageBox.NoButton);
//    return;
//  }
//
// //   if (!this.iface.clonarProductoPorVar(curProductos)) {
// //     return false;
// //   }
//
// //   switch (referencia) {
// //     case "PAGINAS_LIBRO": {
// //       break;
// //     }
// //   }
//  var valoresParam:String;
//  var xmlDocValoresParam = new FLDomDocument;
//  var xmlDocProducto:FLDomDocument = new FLDomDocument;
//  var xmlProducto:FLDomNode;
//  var xmlValoresParam:FLDomNode;
//  var xmlItinerarioProd:FLDomNode;
//  var xmlResultado:FLDomDocument = new FLDomDocument;
// //   var idProductoOpcion:String;
// //   var whereProductos:String = "idlinea = " + cursor.valueBuffer("idlinea");
// //   if (idComponente && idComponente != "") {
// //     whereProductos += " AND idcomponente = " + idComponente;
// //     if (idGrupoCalculo && idGrupoCalculo != "") {
// //       whereProductos += " AND idgrupocalculo = " + idGrupoCalculo;
// //     } else {
// //       whereProductos += " AND idgrupocalculo IS NULL";
// //     }
// //   } else {
// //     whereProductos += " AND idproducto = " + idProducto;
// //   }
// //   var qryProductos:FLSqlQuery = new FLSqlQuery;
// //   with (qryProductos) {
// //     setTablesList("productoslp");
// //     setSelect("idproducto, opcion, parteopcion");
// //     setFrom("productoslp");
// //     setWhere(whereProductos);
// //     setForwardOnly(true);
// //   }
// //   if (!qryProductos.exec()) {
// //     return false;
// //   }
// //   util.createProgressDialog(util.translate("scripts", "Calculando productos"), qryProductos.size());
//  var paso:Number = 0;
//  var idParam:String;
//  var tipoParam:String = "";
// //   while (qryProductos.next()) {
// //     util.setProgress(paso++);
// //     idProductoOpcion = qryProductos.value("idproducto");
// // debug("efereb " + referencia);
//    switch (referencia) {
//      case "IPTICO": {
// //         valoresParam = util.sqlSelect("paramiptico", "xml", "idlinea = " + cursor.valueBuffer("idlinea"));
// debug("ipticccccco");
//        valoresParam = util.sqlSelect("paramiptico", "xml", "idproducto = " + idProducto);
//        idParam = util.sqlSelect("paramiptico", "id", "idproducto = " + idProducto);
//        tipoParam = "iptico";
//        break;
//      }
//      case "PAGINAS_LIBRO": {
// //         valoresParam = util.sqlSelect("paramiptico", "xml", "idproducto = " + idProductoOpcion);
//        valoresParam = util.sqlSelect("paramiptico", "xml", "idproducto = " + idProducto);
//        idParam = util.sqlSelect("paramiptico", "id", "idproducto = " + idProducto);
//        tipoParam = "iptico";
//        break;
//      }
//      case "TAPA_LIBRO": {
// //         valoresParam = util.sqlSelect("paramiptico", "xml", "idproducto = " + idProductoOpcion);
//        valoresParam = util.sqlSelect("paramiptico", "xml", "idproducto = " + idProducto);
//        idParam = util.sqlSelect("paramiptico", "id", "idproducto = " + idProducto);
//        tipoParam = "iptico";
//        break;
//      }
// //       case "LIBRO": {
// //         valoresParam = util.sqlSelect("paramlibro", "xml", "idproducto = " + idProductoOpcion);
// //         break;
// //       }
//      case "ENCUADERNACION": {
// //         valoresParam = util.sqlSelect("paramlibro", "xml", "idlinea= " + cursor.valueBuffer("idlinea"));
//        valoresParam = util.sqlSelect("paramlibro", "xml", "idproducto = " + idProducto);
//        break;
//      }
//      case "ENVIO": {
// //         valoresParam = util.sqlSelect("paramenvio", "xml", "idproducto = " + idProductoOpcion);
//        valoresParam = util.sqlSelect("paramenvio", "xml", "idproducto = " + idProducto);
//        break;
//      }
//      case "TAREA_MANUAL": {
// //         valoresParam = util.sqlSelect("paramtareamanual", "xml", "idproducto = " + idProductoOpcion);
//        valoresParam = util.sqlSelect("paramtareamanual", "xml", "idproducto = " + idProducto);
//        break;
//      }
//    }
// // debug("valoresParam " + valoresParam);
//    if (!valoresParam) {
// //       util.destroyProgressDialog();
//      MessageBox.warning(util.translate("scripts", "Error: Los parámetros del producto no están definidos"), MessageBox.Ok, MessageBox.NoButton);
//      return;
//    }
//    if (xmlDocValoresParam) {
//      delete xmlDocValoresParam;
//    }
//    if (!xmlDocValoresParam.setContent(valoresParam)) {
// //       util.destroyProgressDialog();
//      MessageBox.warning(util.translate("scripts", "Error al parsear el documento XML de parámetros de la línea"), MessageBox.Ok, MessageBox.NoButton);
//      return;
//    }
//
//    var desProducto:String = cursor.cursorRelation().valueBuffer("nombrecliente") + " - " + cursor.valueBuffer("descripcion");
//
//    if (xmlDocProducto) {
//      delete xmlDocProducto;
//    }
// // debug("<Producto IdTipoProceso='" + idTipoProceso + "' IdComp='" + idComponente + "' Ref='" + referencia + "' Opcion='" + qryProductos.value("opcion") + "' ParteOpcion='" + qryProductos.value("parteopcion") + "'><Itinerario Desc='" + desProducto + "'><Tareas/></Itinerario></Producto>");
// //     if (!xmlDocProducto.setContent("<Producto IdTipoProceso='" + idTipoProceso + "' IdComp='" + idComponente + "' Ref='" + referencia + "'><Itinerario Desc='" + desProducto + "'><Tareas/></Itinerario></Producto>")) {
// //       util.destroyProgressDialog();
// // debug("fallo");
//    /*  return false;
//    */}
//    if (!xmlDocProducto.setContent("<Producto IdTipoProceso='" + idTipoProceso + "' Ref='" + referencia + "'><Itinerario Desc='" + desProducto + "'><Tareas/></Itinerario></Producto>")) {
//      return false;
//    }
//    var docCache:String = "";
//    var xmlDocCache:FLDomDocument;
//    if (usarCache && tipoParam == "iptico") {
//      docCache = this.iface.buscarCache(xmlDocValoresParam, idParam, tipoParam);
//      if (docCache && docCache != "") {
//  debug("Encontrado cache: " + docCache);
//        xmlDocCache = new FLDomDocument;
//        xmlDocCache.setContent(docCache);
//  // debug("PARAM " + xmlDocCache.toString(4));
//      }
//    }
//    xmlProducto = xmlDocProducto.firstChild();
//    xmlProducto.toElement().setAttribute("Opcion", qryProductos.value("opcion"));
//    xmlProducto.toElement().setAttribute("ParteOpcion", qryProductos.value("parteopcion"));
//    if (docCache && docCache != "") {
//      xmlProducto.firstChild().appendChild(xmlDocCache.firstChild().cloneNode());
//    } else {
//      xmlProducto.firstChild().appendChild(xmlDocValoresParam.firstChild().cloneNode());
//    }
// debug("evaluando " + xmlDocValoresParam.toString(4));
// // return false;
//    xmlItinerarioProd = xmlProducto.namedItem("Itinerario");
//    if (!this.iface.evaluarVariantes(xmlItinerarioProd)) {
// //       util.destroyProgressDialog();
//      MessageBox.warning(util.translate("scripts", "Error al evaluar los itinerarios para el producto %1").arg(xmlProducto.toElement().attribute("Ref")), MessageBox.Ok, MessageBox.NoButton);
//      xmlResultado.appendChild(xmlProducto.cloneNode());
//      return;
//    } else {
// //       MessageBox.information(util.translate("scripts", "Proceso de evaluación OK"), MessageBox.Ok, MessageBox.NoButton);
//    }
//
//    xmlResultado.appendChild(xmlProducto.cloneNode());
//
//    Dir.current = Dir.home;
//    File.write("costesproceso.xml", xmlResultado.toString(4));
//
// //     if (!this.iface.volcarDatosProducto(xmlProducto, idProductoOpcion)) {
//    if (!this.iface.volcarDatosProducto(xmlProducto, idProducto)) {
// //       util.destroyProgressDialog();
//      return false;
//    }
// //     if (!this.iface.marcarMejorItinerario(idProductoOpcion)) {
//    if (!this.iface.marcarMejorItinerario(idProducto)) {
// //       util.destroyProgressDialog();
//      return false;
//    }
//    this.iface.guardarCache(xmlDocValoresParam, idProducto);
// /* }
//  util.destroyProgressDialog();*/
//
//  MessageBox.information(util.translate("scripts", "Cálculo finalizado"), MessageBox.Ok, MessageBox.NoButton);
//
//  if (!flfacturac.iface.pub_seleccionarOpcionProductos(cursor.valueBuffer("idlinea"))) {
//    return false;
//  }
//
//  this.child("tdbProductos").refresh();
//  this.child("tdbItinerarios").refresh();
//  this.child("fdbCosteProd").setValue(this.iface.calculateField("costeprod"));
//
//  return true;
// }

// function artesG_clonarProductoPorVar(curProducto:FLSqlCursor):Boolean
// {
//  var util:FLUtil = new FLUtil;
//  var cursor:FLSqlCursor = this.cursor();
//
//  if (!util.sqlDelete("productoslp", "idlinea = " + cursor.valueBuffer("idlinea") + " AND idcomponente = " + curProducto.valueBuffer("idcomponente") + " AND idgrupocalculo = " + curProducto.valueBuffer("idgrupocalculo") + " AND original <> true")) {
//    return false;
//  }
//  var idProductoOriginal:String = curProducto.valueBuffer("idproducto");
//  var idProducto:String;
//  switch (curProducto.valueBuffer("referencia")) {
//    case "PAGINAS_LIBRO": {
//      var valoresParam:String = util.sqlSelect("paramiptico", "xml", "idproducto = " + idProductoOriginal);
//      if (!valoresParam || valoresParam == "") {
//        MessageBox.warning(util.translate("scripts", "No tiene definidos los parámetros del producto seleccionado"), MessageBox.Ok, MessageBox.NoButton);
//        return false;
//      }
//      var xmlDoc:FLDomDocument = new FLDomDocument;
//      if (!xmlDoc.setContent(valoresParam)) {
//        return false;
//      }
//      var xmlParam:FLDomNode = xmlDoc.firstChild();
//      var numPaginas:Number = parseInt(flfacturac.iface.pub_dameAtributoXML(xmlParam, "PaginasParam@NumPaginas"));
//      var areaTrabajo:Array = flfacturac.iface.pub_dameAtributoXML(xmlParam, "AreaTrabajoParam@Valor");
// debug("numPaginas = " + numPaginas);
//      var opciones:Array = this.iface.factorizarPorPlanchas(numPaginas, areaTrabajo);
//      if (!opciones) {
//        return false;
//      }
//      for (var i:Number = 1; i < opciones.length; i++) {
// debug("opcion " + i);
//        idProducto = this.iface.copiarProducto(curProducto, opciones[i]["opcion"], opciones[i]["parteopcion"]);
//        if (!idProducto) {
//          return false;
//        }
//        if (!this.iface.actualizarIpticoPorOpcion(idProducto, "PaginasParam@NumPaginas", opciones[i])) {
//          return false;
//        }
//      }
//      break;
//    }
//  }
//  return true;
// }

function artesG_actualizarIpticoPorOpcion(idProducto: String, parametro: String, opcion: Array): Boolean {
  var util: FLUtil = new FLUtil;
  var contenido: String = util.sqlSelect("paramiptico", "xml", "idproducto = " + idProducto);
  if (!contenido)
  {
    return false;
  }

  var xmlDocParametros: FLDomDocument = new FLDomDocument();
  if (!xmlDocParametros.setContent(contenido))
  {
    // debug("!setContent");
    return false;
  }
  var xmlParametros: FLDomNode = xmlDocParametros.firstChild();
  var nodo: FLDomNode = flfacturac.iface.pub_dameNodoXML(xmlParametros, "PaginasParam");
  if (!nodo)
  {
    return false;
  }
  nodo.toElement().setAttribute("NumPaginas", opcion["numpaginas"]);

  nodo = flfacturac.iface.pub_dameNodoXML(xmlParametros, "AreaTrabajoParam");
  if (!nodo)
  {
    return false;
  }
  nodo.toElement().setAttribute("Valor", opcion["areatrabajo"]);

  if (opcion["plegado"] != "")
  {
    var pliegues: Array = opcion["plegado"].split("+");
    var curParamIptico: FLSqlCursor = new FLSqlCursor("paramiptico");
    curParamIptico.setModeAccess(curParamIptico.Insert);
    curParamIptico.refreshBuffer();
    curParamIptico.setValueBuffer("pliegueshor", pliegues[0]);
    curParamIptico.setValueBuffer("plieguesver", pliegues[1]);
    if (!formRecordparamiptico.iface.pub_guardarPlegado(xmlParametros, curParamIptico)) {
      return false;
    }
  }

  if (!util.sqlUpdate("paramiptico", "xml", xmlDocParametros.toString(4), "idproducto = " + idProducto))
  {
    // debug("!updatye");
    return false;
  }
  // debug(xmlDocParametros.toString(4));
  return true;
}

function artesG_volcarDatosProducto(xmlProducto: FLDomNode, idProductoOpcion: String): Boolean {
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  var curProducto: FLSqlCursor = new FLSqlCursor("productoslp");
  var curItinerario: FLSqlCursor = new FLSqlCursor("itinerarioslp");
  var curTarea: FLSqlCursor = new FLSqlCursor("tareaslp");

  curProducto.select("idproducto = " + idProductoOpcion);
  if (!curProducto.first())
  {
    MessageBox.warning(util.translate("scripts", "Error al buscar el producto con idComp = %1").arg(xmlProducto.toElement().attribute("IdComp")), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  curProducto.setModeAccess(curProducto.Edit);
  curProducto.refreshBuffer();

  var idProducto: String = curProducto.valueBuffer("idproducto");
  var idItinerario: String = false;

  var xmlItinerarios: FLDomNodeList = xmlProducto.childNodes();
  var xmlTareas: FLDomNodeList;
  var eTarea: FLDomElement;
  var costeItinerario: Number;
  var costeItinerarioMO: Number;
  var costeItinerarioMat: Number;
  var costeTareaMO: Number;
  var costeTareaMat: Number;
  var costeTarea: Number;
  var detalleTarea: String;
  var porCosteTarea: Number;
  var secuencia: Number;
  var xmlDocItinerario: FLDomDocument;
  for (var i: Number = 0; i < xmlItinerarios.length(); i++)
  {
    if (xmlItinerarios.item(i).nodeName() != "Itinerario") {
      continue;
    }
    eItinerario = xmlItinerarios.item(i).toElement();
    xmlDocItinerario = new FLDomDocument;
    xmlDocItinerario.appendChild(xmlItinerarios.item(i).cloneNode());
    curItinerario.setModeAccess(curItinerario.Insert);
    curItinerario.refreshBuffer();
    curItinerario.setValueBuffer("idlinea", cursor.valueBuffer("idlinea"));
    curItinerario.setValueBuffer("idproducto", idProducto);
    curItinerario.setValueBuffer("itinerario", eItinerario.attribute("IdItinerario"));
    curItinerario.setValueBuffer("xmlparametros", xmlDocItinerario.toString(4));
    curItinerario.setValueBuffer("estado", eItinerario.attribute("Estado"));
    delete xmlDocItinerario;

    if (!curItinerario.commitBuffer())
      return false;

    idItinerario = curItinerario.valueBuffer("iditinerario");

    if (!this.iface.crearTareasLP(idItinerario, xmlItinerarios.item(i))) {
      return false;
    }

    curItinerario.select("iditinerario = " + idItinerario);
    if (!curItinerario.first()) {
      return false;
    }
    curItinerario.setModeAccess(curItinerario.Edit);
    curItinerario.refreshBuffer();
    curItinerario.setValueBuffer("costemo", formRecorditinerarioslp.iface.pub_commonCalculateField("costemo", curItinerario));
    curItinerario.setValueBuffer("costemat", formRecorditinerarioslp.iface.pub_commonCalculateField("costemat", curItinerario));
    curItinerario.setValueBuffer("costetotal", formRecorditinerarioslp.iface.pub_commonCalculateField("costetotal", curItinerario));
    if (!curItinerario.commitBuffer()) {
      return false;
    }

    if (!formRecorditinerarioslp.iface.pub_actualizarPorBeneficio(curItinerario)) {
      return false;
    }
  }
  if (!idItinerario)
  {
    MessageBox.warning(util.translate("scripts", "No se han encontrado itinerarios para el producto seleccionado"), MessageBox.Ok, MessageBox.NoButton);
  }
  return true;
}

function artesG_crearTareasLP(idItinerario: String, xmlProceso: FLDomNode): Boolean {
  var costeTareaMO: Number;
  var costeTareaMat: Number;
  var costeTarea: Number;

  var xmlTareas: FLDomNodeList = xmlProceso.namedItem("Tareas").childNodes();
  var secuencia: Number = 1;
  var idTarea: String;
  var curTarea: FLSqlCursor = new FLSqlCursor("tareaslp");
  curTarea.setActivatedCommitActions(false);
  for (var k: Number = 0; k < xmlTareas.length(); k++)
  {
    if (xmlTareas.item(k).nodeName() != "Tarea") {
      continue;
    }
    eTarea = xmlTareas.item(k).toElement();
    if (eTarea.attribute("Estado") == "Saltada") {
      continue;
    }
    if (eTarea.attribute("ControlFlujo") == "true") {
      continue;
    }
    costeTareaMO = parseFloat(eTarea.attribute("CosteMO"));
    costeTareaMat = parseFloat(eTarea.attribute("CosteMat"));
    costeTarea = costeTareaMO + costeTareaMat;
    curTarea.setModeAccess(curTarea.Insert);
    curTarea.refreshBuffer();
    curTarea.setValueBuffer("iditinerario", idItinerario);
    curTarea.setValueBuffer("secuencia", secuencia);
    curTarea.setValueBuffer("descripcion", eTarea.attribute("Descripcion"));
    curTarea.setValueBuffer("costemo", costeTareaMO);
    curTarea.setValueBuffer("costemat", costeTareaMat);
    curTarea.setValueBuffer("tiempo", eTarea.attribute("TiempoPres"));
    curTarea.setValueBuffer("tiemporeal", eTarea.attribute("Tiempo"));
    curTarea.setValueBuffer("porbentiempo", eTarea.attribute("PorBenTiempo"));
    curTarea.setValueBuffer("costetiempo", eTarea.attribute("CosteTiempo"));
    curTarea.setValueBuffer("costetotal", costeTarea);
    curTarea.setValueBuffer("instrucciones", eTarea.attribute("Instrucciones"));
    curTarea.setValueBuffer("detallecoste", eTarea.attribute("DetalleCoste"));
    curTarea.setValueBuffer("codtipocentro", eTarea.attribute("CodTipoCentro"));
    curTarea.setValueBuffer("pasadas", eTarea.attribute("NumPasadas"));
    if (!curTarea.commitBuffer()) {
      return false;
    }
    idTarea = curTarea.valueBuffer("idtarea");
    if (!this.iface.crearConsumosLP(idTarea, eTarea)) {
      return false;
    }
    secuencia++;
  }
  return true;
}

function artesG_crearConsumosLP(idTarea: String, eTarea: FLDomElement): Boolean {
  var costeTareaMO: Number;
  var costeTareaMat: Number;
  var costeTarea: Number;

  var xmlConsumos: FLDomNodeList = eTarea.namedItem("Consumos").childNodes();
  if (!xmlConsumos)
  {
    return true;
  }
  var secuencia: Number = 1;
  var curConsumo: FLSqlCursor = new FLSqlCursor("consumoslp");
  curConsumo.setActivatedCommitActions(false);
  var eConsumo: FLDomElement;
  for (var k: Number = 0; k < xmlConsumos.length(); k++)
  {
    if (xmlConsumos.item(k).nodeName() != "Consumo") {
      continue;
    }
    eConsumo = xmlConsumos.item(k).toElement();
    curConsumo.setModeAccess(curConsumo.Insert);
    curConsumo.refreshBuffer();
    curConsumo.setValueBuffer("idtarea", idTarea);
    curConsumo.setValueBuffer("referencia", eConsumo.attribute("Referencia"));
    curConsumo.setValueBuffer("cantidad", eConsumo.attribute("Cantidad"));
    curConsumo.setValueBuffer("cantidadaux", eConsumo.attribute("CantidadAux"));
    curConsumo.setValueBuffer("cantidadneta", formRecordconsumoslp.iface.pub_commonCalculateField("cantidadneta", curConsumo));
    curConsumo.setValueBuffer("costeunidad", eConsumo.attribute("CosteUnidad"));
    curConsumo.setValueBuffer("costeneto", eConsumo.attribute("CosteNeto"));
    curConsumo.setValueBuffer("porbeneficio", eConsumo.attribute("PorBeneficio"));
    curConsumo.setValueBuffer("costetotal", eConsumo.attribute("CosteTotal"));
    if (!curConsumo.commitBuffer()) {
      return false;
    }
  }
  return true;
}

function artesG_evaluarVariantes(xmlProceso: FLDomNode): Boolean {
  var util: FLUtil = new FLUtil;
  var idTipoProceso: String = xmlProceso.parentNode().toElement().attribute("IdTipoProceso");
  var idTareaInicial = flcolaproc.iface.pub_tareaInicialProceso(idTipoProceso);
  if (!idTareaInicial)
  {
    MessageBox.warning(util.translate("scripts", "Error al obtener la tarea inicial del proceso %1").arg(idTipoProceso), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }

  xmlProceso.toElement().setAttribute("IdTipoTareaActual", util.sqlSelect("pr_tipostareapro", "idtipotarea", "idtipotareapro = " + idTareaInicial));
  xmlProceso.toElement().setAttribute("CodTipoTareaProActual", util.sqlSelect("pr_tipostareapro", "codtipotareapro", "idtipotareapro = " + idTareaInicial));
  xmlProceso.toElement().setAttribute("IdTipoTareaProActual", idTareaInicial);
  if (!this.iface.evaluarVariantesTarea(xmlProceso))
  {
    return false;
  }
  return true;
}

function artesG_calcularCostesTareas(xmlProceso: FLDomNode): Boolean {
  // var xmlDoc:FLDomDocument = new FLDomDocument;
  // xmlDoc.appendChild(xmlProceso.cloneNode());
  // debug(xmlDoc.toString(4));
  // return false;
  var util: FLUtil = new FLUtil;
  var estadoProceso: String = flfacturac.iface.pub_dameAtributoXML(xmlProceso, "@Estado");
  if (estadoProceso != "Inviable")
  {
    var tareas: FLDomNodeList = xmlProceso.namedItem("Tareas").toElement().elementsByTagName("Tarea");
    if (!tareas) {
      return false;
    }
    for (var i: Number = 0; i < tareas.length(); i++) {
      if (!this.iface.ponCosteXmlTarea(tareas.item(i))) {
        var idTipoTarea: String = tareas.item(i).toElement().attribute("IdTipoTarea");
        var codTipoTareaPro: String = tareas.item(i).toElement().attribute("CodTipoTareaPro");
        var tarea: String = ((codTipoTareaPro && codTipoTareaPro != "") ? codTipoTareaPro : idTipoTarea);
        MessageBox.warning(util.translate("scripts", "Error al obtener el coste de la tarea %1").arg(tarea), MessageBox.Ok, MessageBox.NoButton);
        return false;
      }
    }
  }
  return true;
}

function artesG_continuarProceso(xmlProceso: FLDomNode): Boolean {
  var estadoProceso: String = flfacturac.iface.pub_dameAtributoXML(xmlProceso, "@Estado");
  if (estadoProceso == "Inviable")
  {
    return true;
  }

  var idTipoTareaPro: String = xmlProceso.toElement().attribute("IdTipoTareaProActual");
  var xmlTarea: FLDomNode = flfacturac.iface.pub_dameNodoXML(xmlProceso, "Tareas/Tarea[@IdTipoTareaPro=" + idTipoTareaPro + "]");
  var xmlSiguiente: FLDomNode = flfacturac.iface.pub_dameNodoXML(xmlTarea, "SiguienteTarea");
  if (xmlSiguiente)
  {
    xmlProceso.toElement().setAttribute("IdTipoTareaProActual", xmlSiguiente.toElement().attribute("IdTipoTareaPro"));
    xmlProceso.toElement().setAttribute("CodTipoTareaProActual", xmlSiguiente.toElement().attribute("CodTipoTareaPro"));
    xmlProceso.toElement().setAttribute("IdTipoTareaActual", xmlSiguiente.toElement().attribute("IdTipoTarea"));
    if (!this.iface.evaluarVariantesTarea(xmlProceso)) {
      return false;
    }
  } else {
    var idTipoTareaPro: String = xmlProceso.toElement().attribute("IdTipoTareaProActual");

    var qrySiguienteTarea: FLSqlQuery = new FLSqlQuery;
    with(qrySiguienteTarea)
    {
      setTablesList("pr_secuencias,pr_tipostareapro");
      setSelect("s.tareafin, ttp.idtipotarea, ttp.codtipotareapro");
      setFrom("pr_secuencias s INNER JOIN pr_tipostareapro ttp ON s.tareafin = ttp.idtipotareapro");
      setWhere("s.tareainicio = " + idTipoTareaPro);
      setForwardOnly(true);
    }
    if (!qrySiguienteTarea.exec())
    {
      return false;
    }
    if (qrySiguienteTarea.size() == 0)
    {
      if (!this.iface.calcularCostesTareas(xmlProceso)) {
        return false;
      }
      // debug("PROCESO: oooooooooooooooo");
      // var d:FLDomDocument = new FLDomDocument;
      // d.appendChild(xmlProceso.cloneNode());
      // debug(d.toString(4));
      return true;
    }
    var idSiguienteTarea: String, codTipoTareaPro: String;
    var idTipoTarea: String;
    var doc: FLDomDocument = xmlProceso.ownerDocument();
    var eSiguienteT: FLDomElement = new FLDomElement;
    while (qrySiguienteTarea.next())
    {
      idSiguienteTarea = qrySiguienteTarea.value("s.tareafin");
      idTipoTarea = qrySiguienteTarea.value("ttp.idtipotarea");
      codTipoTareaPro = qrySiguienteTarea.value("ttp.codtipotareapro");
      if (this.iface.existeXmlTareaProceso(xmlProceso, idSiguienteTarea)) {
        return true;
      }

      eSiguienteT = doc.createElement("SiguienteTarea");
      eSiguienteT.setAttribute("IdTipoTareaPro", idSiguienteTarea);
      eSiguienteT.setAttribute("IdTipoTarea", idTipoTarea);
      eSiguienteT.setAttribute("CodTipoTareaPro", codTipoTareaPro);
      xmlTarea.appendChild(eSiguienteT);

      xmlProceso.toElement().setAttribute("IdTipoTareaProActual", idSiguienteTarea);
      xmlProceso.toElement().setAttribute("IdTipoTareaActual", idTipoTarea);
      xmlProceso.toElement().setAttribute("CodTipoTareaProActual", codTipoTareaPro);
      if (!this.iface.evaluarVariantesTarea(xmlProceso)) {
        return false;
      }
    }
  }

  return true;
}


/** \C Genera un array con los costes inicial y por unidad de una tarea en un determinado tipo de centro de coste
@param  codTipoCentro: Código de tipo de centro de coste
@param  idTipoTareaPro: Identificador del tipo de tarea
@return Array con los costes inicial y por unidad
\end */
function artesG_costesPorCentroTarea(codTipoCentro: String, idTipoTareaPro: String): Array {
  var util: FLUtil = new FLUtil;

  var res: Array;
  var qryCostesD: FLSqlQuery = new FLSqlQuery;
  with(qryCostesD)
  {
    setTablesList("pr_costestarea,pr_tiposcentrocoste");
    setSelect("tcc.costetiempo, tcc.porbeneficio, tcc.tiempoinicio, tcc.tiempounidad, tcc.unidadeshora, tcc.tiempominprod, ct.costeinicial, ct.costeunidad, ct.idtipotareapro");
    setFrom("pr_tiposcentrocoste tcc LEFT OUTER JOIN pr_costestarea ct ON (ct.codtipocentro = tcc.codtipocentro AND ct.idtipotareapro = " + idTipoTareaPro + ")");
    setWhere("tcc.codtipocentro = '" + codTipoCentro + "'");
    setForwardOnly(true);
  }
  if (!qryCostesD.exec())
    return false;
  if (!qryCostesD.first())
  {
    var idTipoTarea: String = util.sqlSelect("pr_tipostareapro", "idtipotarea", "idtipotareapro = " + idTipoTareaPro);
    MessageBox.warning(util.translate("scripts", "Error al calcular el coste de la tarea:\nNo existe ningún registro de coste por tarea para el tipo de centro de coste %1 y la tarea %2").arg(codTipoCentro).arg(idTipoTarea), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  if (qryCostesD.value("ct.idtipotareapro") != "")
  {
    res["inicial"] = parseFloat(qryCostesD.value("ct.costeinicial"));
    res["unidad"] = parseFloat(qryCostesD.value("ct.costeunidad"));
    if (res["unidad"] != 0) {
      res["unidadeshora"] = 60 / res["unidad"];
    } else {
      res["unidadeshora"] = 0;
    }
  } else {
    res["inicial"] = parseFloat(qryCostesD.value("tcc.tiempoinicio"));
    res["unidad"] = parseFloat(qryCostesD.value("tcc.tiempounidad"));
    res["unidadeshora"] = parseFloat(qryCostesD.value("tcc.unidadeshora"));
  }
  if (isNaN(res["inicial"]))
  {
    res["inicial"] = 0;
  }
  if (isNaN(res["unidad"]))
  {
    res["unidad"] = 0;
  }

  res["tiempominimo"] = parseFloat(qryCostesD.value("tcc.tiempominprod"));
  res["costetiempo"] = parseFloat(qryCostesD.value("tcc.costetiempo"));
  if (isNaN(res["costetiempo"]))
    res["costetiempo"] = 0;
  res["porbeneficio"] = parseFloat(qryCostesD.value("tcc.porbeneficio"));
  if (isNaN(res["porbeneficio"]))
    res["porbeneficio"] = 0;

  return res;
}

function artesG_clonarProcesoPorVar(xmlProceso: FLDomNode, nombreVar: String): Boolean {
  var util: FLUtil = new FLUtil;
  debug("Clonando por " + nombreVar);
  //this.iface.log.child("log").append(util.translate("scripts", "Clonando itinerario por %1").arg(nombreVar));

  var indiceIt: Number = 1;
  var idTipoProceso: String = xmlProceso.parentNode().toElement().attribute("IdTipoProceso");
  var idItinerario: String = xmlProceso.toElement().attribute("IdItinerario");

  if (idItinerario)
  {
    idItinerario += " ";
  } else {
    idItinerario = "";
  }
  var xmlProcesoTratado: FLDomNode;
  var xmlVariantes: FLDomNodeList = flfacturac.iface.pub_valoresVariante(nombreVar, xmlProceso);
  if (!xmlVariantes)
  {
    this.iface.marcarProcesoInviable(xmlProceso, util.translate("scripts", "No se han encontrado variantes del tipo %1").arg(nombreVar));
    return true;
  }
  debug("Variantes " + xmlVariantes.length());
  for (var i: Number = 0; i < xmlVariantes.length(); i++)
  {
    debug("Variante " + i + " " + xmlVariantes.item(i).nodeName());
    if (i < (xmlVariantes.length() - 1)) {
      xmlProcesoTratado = xmlProceso.cloneNode();
      xmlProceso.parentNode().appendChild(xmlProcesoTratado);
    } else {
      xmlProcesoTratado = xmlProceso;
    }
    if (!this.iface.ponDetalleTarea(xmlProcesoTratado, xmlVariantes.item(i).toElement().attribute("Detalle"), "Detalle")) {
      return false;
    }
    xmlVariantes.item(i).toElement().setAttribute("Detalle", "");
    //debug("poniendo valor");
    if (nombreVar == "SiguienteTareaVar") {
      if (!flfacturac.iface.pub_ponXmlSiguientesTareas(xmlProcesoTratado, xmlVariantes.item(i))) {
        return false;
      }
    } else {
      if (!flfacturac.iface.pub_ponXmlParametroProceso(xmlProcesoTratado, xmlVariantes.item(i))) {
        return false;
      }
    }

    //this.iface.log.child("log").append(util.translate("scripts", "Itinerario %1. Clon %2 = %3").arg(idItinerario + indiceIt).arg(nombreVar).arg(xmlVariantes.item(i).toElement().attribute("Valor")));

    xmlProcesoTratado.toElement().setAttribute("IdItinerario", idItinerario + indiceIt);
    indiceIt++;
    if (!this.iface.evaluarVariantesTarea(xmlProcesoTratado))
      return false;
  }
  return true;
}

function artesG_ponXmlTareaProceso(xmlProceso: FLDomNode, idTipoTareaPro: String): FLDomNode {
  var util: FLUtil = new FLUtil;
  var qryTipoTarea: FLSqlQuery = new FLSqlQuery;
  with(qryTipoTarea)
  {
    setTablesList("pr_tipostareapro");
    setSelect("idtipotarea, descripcion, controlflujo, codtipotareapro");
    setFrom("pr_tipostareapro");
    setWhere("idtipotareapro = " + idTipoTareaPro);
    setForwardOnly(true);
  }
  if (!qryTipoTarea.exec())
  {
    return false;
  }
  if (!qryTipoTarea.first())
  {
    return false;
  }

  var desTarea: String = qryTipoTarea.value("descripcion");
  var idTipoTarea: String = qryTipoTarea.value("idtipotarea");
  var codTipoTareaPro: String = qryTipoTarea.value("codtipotareapro");

  var xmlNodoTareas: FLDomNode = xmlProceso.namedItem("Tareas");
  if (!xmlNodoTareas)
  {
    MessageBox.warning(util.translate("scripts", "Error al asignar el la tareas al proceso:\nEl proceso no tiene un nodo Tareas"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }

  var eTarea: FLDomElement = xmlProceso.ownerDocument().createElement("Tarea");
  xmlNodoTareas.appendChild(eTarea);
  eTarea.setAttribute("Estado", "PTE");
  eTarea.setAttribute("IdTipoTarea", idTipoTarea);
  eTarea.setAttribute("Descripcion", desTarea);
  eTarea.setAttribute("IdTipoTareaPro", idTipoTareaPro);
  eTarea.setAttribute("CodTipoTareaPro", codTipoTareaPro);
  eTarea.setAttribute("ControlFlujo", (qryTipoTarea.value("controlflujo") ? "true" : "false"));
  var eConsumos: FLDomElement = xmlProceso.ownerDocument().createElement("Consumos");
  eTarea.appendChild(eConsumos);

  //  var xmlDocTemp:FLDomDocument = new FLDomDocument;
  //  xmlDocTemp.setContent("<Tarea Estado=\"PTE\" IdTipoTarea=\"" + idTipoTarea + "\" Descripcion=\"" + desTarea + "\" IdTipoTareaPro=\"" + idTipoTareaPro + "\"><Consumos/></Tarea>");
  //  var xmlTarea:FLDomNode = xmlDocTemp.firstChild().cloneNode();
  //  delete xmlDocTemp;
  //
  //  xmlNodoTareas.appendChild(xmlTarea);
  //  if (qryTipoTarea.value("controlflujo")) {
  //    xmlTarea.toElement().setAttribute("ControlFlujo", "true");
  //  }

  //  return xmlTarea;
  return eTarea;
}

function artesG_existeXmlTareaProceso(xmlProceso: FLDomNode, idTipoTareaPro: String): Booelan {
  var xmlNodoTareas: FLDomNode = xmlProceso.namedItem("Tareas");
  if (!xmlNodoTareas)
  {
    MessageBox.warning(util.translate("scripts", "Error al buscar la tarea en el proceso:\nEl proceso no tiene un nodo Tareas"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  if (!xmlNodoTareas.hasChildNodes())
    return false;

  var xmlTarea: FLDomNode;
  for (xmlTarea = xmlNodoTareas.firstChild(); xmlTarea; xmlTarea = xmlTarea.nextSibling())
  {
    if (xmlTarea.toElement().attribute("IdTipoTareaPro") == idTipoTareaPro)
      return true;
  }

  return false;
}

/** \C Devuelve el nodo de las posibles variantes. Está siendo sustituida por funciones específicas para cada tipo de variante
@return Nodo de variantes
\end */
function artesG_cargarVariantes(): FLDomNode {
  var variantes: String = "<Variantes>\n" +
  "\t<PliegoImpresionVar>\n" +
  "\t\t<PliegoImpresionParam Valor=\"45x100\"/>" +
  "\t\t<PliegoImpresionParam Valor=\"35x90\"/>" +
  "\t\t<PliegoImpresionParam Valor=\"22.5x50\"/>" +
  "\t\t<PliegoImpresionParam Valor=\"17.5x45\"/>" +
  "\t</PliegoImpresionVar>\n" +
  "\t<TipoImpresoraVar>\n" +
  "\t\t<TipoImpresoraParam Valor=\"HAMADA\" AreaPlancha=\"22.5x50\"/>" +
  "\t\t<TipoImpresoraParam Valor=\"SPEED-MASTER\" AreaPlancha=\"45x100\"/>" +
  "\t</TipoImpresoraVar>\n" +
  "\t<EstiloImpresionVar>\n" +
  "\t\t<EstiloImpresionParam Valor=\"Simple\"/>" +
  "\t\t<EstiloImpresionParam Valor=\"CaraRetira\"/>" +
  "\t\t<EstiloImpresionParam Valor=\"TiraRetira\"/>" +
  "\t\t<EstiloImpresionParam Valor=\"TiraVolteo\"/>" +
  "\t</EstiloImpresionVar>\n" +
  "</Variantes>\n";

  var xmlDocVariantes: FLDomDocument = new FLDomDocument;
  xmlDocVariantes.setContent(variantes);

  return xmlDocVariantes.firstChild()
}

function artesG_marcarProcesoInviable(xmlProceso: FLDomNode, causa: String)
{
  xmlProceso.toElement().setAttribute("Estado", "Inviable");
  xmlProceso.toElement().setAttribute("Causa", causa);
}

/** \C Añade un nodo de parámetro al proceso
@param  xmlProceso: Nodo XML del proceso
@param  parametro: Nombre del nodo parámetro
@param  valor: Valor del atributo Valor del nodo parámetro
\end */
function artesG_ponValorParametroProceso(xmlProceso: FLDomNode, parametro: String, valor): Boolean {
  var xmlDoc: FLDomDocument = new FLDomDocument;
  if (!xmlDoc.setContent("<" + parametro + " Valor=\"" + valor + "\"/>"))
    return false;;

  if (!flfacturac.iface.pub_ponXmlParametroProceso(xmlProceso, xmlDoc.firstChild()))
    return false;

  delete xmlDoc;
  return true;
}


function artesG_bufferChanged(fN: String)
{
  //debug(fN);
  switch (fN) {
    case "referencia": {
      this.iface.__bufferChanged(fN);
      break;
    }
    case "xmlparametros": {
      delete this.iface.xmlTrabajosPliego_;
      this.iface.xmlTrabajosPliego_ = false;
      break;
    }
    case "costeprod":
    case "porbeneficio":
    case "cantidad": {
      this.child("fdbPvpUnitario").setValue(this.iface.calculateField("pvpunitario"));
      break;
    }
    case "refcliente": {
      this.child("fdbDescripcion").setValue(this.iface.calculateField("descripcion"));
      break;
    }
    default: {
      this.iface.__bufferChanged(fN);
    }
  }
}

function artesG_cargarParametros(): Boolean {
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();
  var parametros: String = this.iface.calcularParametrosDefecto();
  if (!parametros)
    return false;

  this.child("fdbXmlParametros").setValue(parametros);

  if (cursor.modeAccess() == cursor.Insert)
  {
    if (!this.child("tdbProductos").cursor().commitBufferCursorRelation())
      return false;
  }

  var xmlDocParametros: FLDomDocument = new FLDomDocument;
  xmlDocParametros.setContent(parametros);
  var listaProductos: FLDomNodeList = xmlDocParametros.elementsByTagName("Producto");
  if (listaProductos)
  {
    var eProducto: FLDomElement;
    var curProducto: FLSqlCursor = new FLSqlCursor("productoslp");
    for (var i: Number = 0; i < listaProductos.length(); i++) {
      eProducto = listaProductos.item(i).toElement();
      with(curProducto) {
        setModeAccess(Insert);
        refreshBuffer();
        setValueBuffer("idlinea", cursor.valueBuffer("idlinea"));
        setValueBuffer("referencia", eProducto.attribute("Ref"));
        setValueBuffer("descripcion", eProducto.attribute("Desc"));
        setValueBuffer("idcomponente", eProducto.attribute("IdComp"));
        setValueBuffer("original", true);
        setValueBuffer("seleccionado", true);
      }
      if (!curProducto.commitBuffer())
        return false;
    }
  }
  this.child("tdbProductos").refresh();
  return true;
}

function artesG_calculateField(fN: String): String {
  debug("Calculando " + fN);
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();
  var valor: String;

  switch (fN)
  {
    case "porbeneficio": {
      var codCliente: String = cursor.cursorRelation().valueBuffer("codcliente");
      if (codCliente && codCliente != "") {
        valor = util.sqlSelect("clientes", "porbeneficio", "codcliente = '" + codCliente + "'");
      }
      if (!valor) {
        valor = flfactppal.iface.pub_valorDefectoEmpresa("porbeneficio");
      }
      break;
    }
    case "descripcion": {
      switch (cursor.valueBuffer("referencia")) {
        case "IPTICO": {
          valor = this.iface.descripcionIptico();
          break;
        }
        case "TACO": {
          valor = this.iface.descripcionTaco();
          break;
        }
        default: {
          valor = cursor.valueBuffer("descripcion");
        }
      }
      break;
    }
    case "cantidad": {
      var referencia: String = cursor.valueBuffer("referencia");
      switch (referencia) {
        case "IPTICO": {
          var curIptico: FLSqlCursor = new FLSqlCursor("paramiptico");
          curIptico.select("idlinea = " + cursor.valueBuffer("idlinea"));
          if (!curIptico.first()) {
            break;
          }
          curIptico.setModeAccess(curIptico.Browse);
          curIptico.refreshBuffer();
          if (curIptico.valueBuffer("troquelado")) {
            valor = curIptico.valueBuffer("numcopiastroquel");
          } else {
            valor = curIptico.valueBuffer("numcopias");
            if (!valor) {
              valor = util.sqlSelect("paramcantidad", "total", "idparamiptico = " + curIptico.valueBuffer("id"));
            }
          }
          if (!valor || isNaN(valor)) {
            valor = 0;
          }
          break;
        }
        case "LIBRO": {
          valor = util.sqlSelect("paramlibro", "numcopias", "idlinea = " + cursor.valueBuffer("idlinea"));
          if (!valor || isNaN(valor)) {
            valor = 0;
          }
          break;
        }
        case "TACO": {
          valor = util.sqlSelect("paramtaco", "numcopias", "idlinea = " + cursor.valueBuffer("idlinea"));
          if (!valor || isNaN(valor)) {
            valor = 0;
          }
          break;
        }
      }
      break;
    }
    default: {
      valor = this.iface.commonCalculateField(fN, cursor);
    }
  }
  debug("Valor " + valor);
  return valor;
}

function artesG_descripcionIptico(): String {
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();
  var descripcion: String = "";
  var curIptico: FLSqlCursor = new FLSqlCursor("paramiptico");
  curIptico.select("idlinea = " + cursor.valueBuffer("idlinea"));
  if (!curIptico.first())
  {
    return false;
  }
  descripcion = util.sqlSelect("articulos", "descripcion", "referencia = '" + cursor.valueBuffer("referencia") + "'");
  descripcion += " ";
  var refCliente: String = cursor.valueBuffer("refcliente");
  if (refCliente != "")
  {
    descripcion += "\"" + refCliente + "\" ";
  }
  var modelos: Number = parseInt(curIptico.valueBuffer("numpaginas"));
  if (modelos == 1)
  {
    /// Por petición de Jesús (las copias ya se ven en el campo Cantidad)
    //    descripcion += util.translate("scripts", "Copias: %1.").arg(curIptico.valueBuffer("numcopias"));
  } else {
    descripcion += util.translate("scripts", "Modelos: %1. Un/modelo: %2.").arg(modelos).arg(curIptico.valueBuffer("numcopias"));
  }
  descripcion += " ";
  var anchoDob: Number = parseFloat(curIptico.valueBuffer("anchodob"));
  if (isNaN(anchoDob) || anchoDob == 0)
  {
    descripcion += util.translate("scripts", "Tamaño: %1 x %2.").arg(curIptico.valueBuffer("anchot")).arg(curIptico.valueBuffer("altot"));
  } else {
    descripcion += util.translate("scripts", "Tamaño abierto: %1 x %2. Tamaño cerrado: %3 x %4.").arg(curIptico.valueBuffer("anchot")).arg(curIptico.valueBuffer("altot")).arg(curIptico.valueBuffer("anchodob")).arg(curIptico.valueBuffer("altodob"));
  }
  descripcion += " ";
  var tintas: String = curIptico.valueBuffer("tintas");
  if (!tintas || tintas == "")
  {
    tintas = curIptico.valueBuffer("colores");
  }
  descripcion += util.translate("scripts", "Tintas: %1.").arg(tintas);
  var refPliego: String = curIptico.valueBuffer("refpliego");
  if (refPliego && refPliego != "")
  {
    descripcion += " ";
    descripcion += util.translate("scripts", "Papel: %1.").arg(util.sqlSelect("articulos", "descripcion", "referencia = '" + refPliego + "'"));
  } else {
    var codCalidad: String = curIptico.valueBuffer("codcalidad");
    if (codCalidad && codCalidad != "")
    {
      descripcion += " ";
      descripcion += util.translate("scripts", "Calidad: %1.").arg(util.sqlSelect("calidadespapel", "descripcion", "codcalidad = '" + codCalidad + "'"));
    }
  }
  descripcion += " ";
  descripcion += util.translate("scripts", "Gramaje: %1.").arg(curIptico.valueBuffer("gramaje"));
  var acabados: String = "";
  var plastificado: String = this.iface.descripcionPlastificado(curIptico);
  if (plastificado != "")
  {
    acabados += " ";
    acabados += plastificado;
  }
  if (curIptico.valueBuffer("troquelado"))
  {
    acabados += " ";
    acabados +=  util.translate("scripts", "Troquelado.");
  }
  if (acabados != "")
  {
    descripcion += " ";
    descripcion += util.translate("scripts", "Acabados: %1.").arg(acabados);
  }
  return descripcion;
}

function artesG_descripcionTaco(): String {
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();
  var descripcion: String = "";
  var curTaco: FLSqlCursor = new FLSqlCursor("paramtaco");
  curTaco.select("idlinea = " + cursor.valueBuffer("idlinea"));
  if (!curTaco.first())
  {
    return false;
  }
  descripcion = util.sqlSelect("articulos", "descripcion", "referencia = '" + cursor.valueBuffer("referencia") + "'");
  descripcion += " ";
  var refCliente: String = cursor.valueBuffer("refcliente");
  if (refCliente != "")
  {
    descripcion += "\"" + refCliente + "\" ";
  }
  var modelos: Number = parseInt(curTaco.valueBuffer("numpaginas"));
  if (modelos != 1)
  {
    descripcion += util.translate("scripts", "Modelos: %1. Un/modelo: %2.").arg(modelos).arg(curTaco.valueBuffer("numcopias"));
  }
  descripcion += " ";
  descripcion += util.translate("scripts", "Tamaño: %1 x %2.").arg(curTaco.valueBuffer("anchot")).arg(curTaco.valueBuffer("altot"));
  descripcion += " ";
  descripcion += util.translate("scripts", "Tintas: %1.").arg(curTaco.valueBuffer("colores"));

  var codCalidad: String = curTaco.valueBuffer("codcalidad");
  if (codCalidad && codCalidad != "")
  {
    descripcion += " ";
    descripcion += util.translate("scripts", "Calidad: %1.").arg(util.sqlSelect("calidadespapel", "descripcion", "codcalidad = '" + codCalidad + "'"));
  }
  descripcion += " ";
  descripcion += util.translate("scripts", "Gramaje: %1.").arg(curTaco.valueBuffer("gramaje"));
  return descripcion;
}

function artesG_descripcionPlastificado(curIptico: FLSqlCursor): String {
  var util: FLUtil = new FLUtil;
  var descripcion: String;
  switch (curIptico.valueBuffer("plasfrente"))
  {
    case "Mate": {
      switch (curIptico.valueBuffer("plasvuelta")) {
        case "Mate": {
          descripcion = util.translate("scripts", "Plastificado mate a dos caras");
          break;
        }
        case "Brillo": {
          descripcion = util.translate("scripts", "Plastificado mate (frente) y brillo (vuelta)");
          break;
        }
        default: {
          descripcion = util.translate("scripts", "Plastificado mate a una cara (frente)");
          break;
        }
      }
      break;
    }
    case "Brillo": {
      switch (curIptico.valueBuffer("plasvuelta")) {
        case "Mate": {
          descripcion = util.translate("scripts", "Plastificado brillo (frente) y mate (vuelta)");
          break;
        }
        case "Brillo": {
          descripcion = util.translate("scripts", "Plastificado brillo a dos caras");
          break;
        }
        default: {
          descripcion = util.translate("scripts", "Plastificado brillo a una cara (frente)");
          break;
        }
      }
      break;
    }
    default: {
      switch (curIptico.valueBuffer("plasvuelta")) {
        case "Mate": {
          descripcion = util.translate("scripts", "Plastificado mate a una cara (vuelta)");
          break;
        }
        case "Brillo": {
          descripcion = util.translate("scripts", "Plastificado brillo a una cara (vuelta)");
          break;
        }
        default: {
          descripcion = "";
          break;
        }
      }
      break;
    }
  }
  return descripcion;
}

function artesG_commonCalculateField(fN: String, cursor: FLSqlCursor): String {
  debug("artesG_commonCalculateField " + fN);
  var util: FLUtil = new FLUtil;
  var res: String;
  switch (fN)
  {
    case "xmlparametros": {
      res = this.iface.calcularParametrosDefecto();
      break;
    }
    case "costeprod": {
      res = util.sqlSelect("productoslp", "SUM(coste)", "idlinea = " + cursor.valueBuffer("idlinea"));
      break;
    }
    case "pvpunitario": {
      var referencia: String = cursor.valueBuffer("referencia");
      if (referencia == "IPTICO" || referencia == "LIBRO" || referencia == "TACO") {
        var costeProd: Number = parseFloat(cursor.valueBuffer("costeprod"));
        var porBeneficio: Number = parseFloat(cursor.valueBuffer("porBeneficio"));
        porBeneficio = (isNaN(porBeneficio) ? 0 : porBeneficio);
        costeProd = costeProd * (100 + porBeneficio) / 100;
        var cantidad: Number = parseFloat(cursor.valueBuffer("cantidad"));
        if (!isNaN(cantidad) && cantidad != 0) {
          res = costeProd / cantidad;
        }
      } else {
        res = this.iface.__calculateField(fN);
      }
      break;
    }
    default: {
      res = this.iface.__calculateField(fN);
    }
  }
  return res;
}

function artesG_calcularParametrosDefecto()
{
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  var referencia: String = cursor.valueBuffer("referencia");

  var qryArticulo: FLSqlQuery = new FLSqlQuery;
  qryArticulo.setTablesList("articulos");
  qryArticulo.setSelect("referencia, descripcion, xmlparametros, fabricado, idtipoproceso");
  qryArticulo.setFrom("articulos");
  qryArticulo.setWhere("referencia = '" + referencia + "'");
  qryArticulo.setForwardOnly(true);
  if (!qryArticulo.exec())
    return false;

  if (!qryArticulo.first())
    return false;

  var componentes: String;
  var parametros: String = "<ParametrosLinea>";
  parametros += "<Producto Ref=\"" + referencia + "\" IdComp=\"1\" Desc=\"" + qryArticulo.value("descripcion") + "\" IdTipoProceso=\"" + qryArticulo.value("idtipoproceso") + "\">";
  parametros += util.sqlSelect("articulos", "xmlparametros", "referencia = '" + referencia + "'");
  componentes = this.iface.paramDefectoComponentes(referencia);
  if (!componentes) {
    MessageBox.warning(util.translate("scripts", "Error al obtener los componentes del producto %1").arg(referencia), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  parametros += "</Producto>";
  if (componentes != "vacio") {
    parametros += componentes;
  }
  parametros += "</ParametrosLinea>";

  var xmlParametros: FLDomDocument = new FLDomDocument;
  if (!xmlParametros.setContent(parametros)) {
    //debug(parametros);
    MessageBox.warning(util.translate("scripts", "Error al generar el nodo XML de parámetros. En formato no es válido"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }

  parametros = xmlParametros.toString(4);
  return parametros;
}

function artesG_paramDefectoComponentes(referencia: String): String {
  var util: FLUtil = new FLUtil;
  var parametros: String = "";

  var qryComponentes: FLSqlQuery = new FLSqlQuery;
  qryComponentes.setTablesList("articuloscomp,articulos");
  qryComponentes.setSelect("ac.id, a.referencia, ac.desccomponente, a.xmlparametros, a.fabricado, a.idtipoproceso");
  qryComponentes.setFrom("articuloscomp ac INNER JOIN articulos a ON ac.refcomponente = a.referencia");
  qryComponentes.setWhere("ac.refcompuesto = '" + referencia + "'");
  qryComponentes.setForwardOnly(true);
  if (!qryComponentes.exec())
    return false;

  var componentes: String;
  var vacio: Boolean = true;
  while (qryComponentes.next())
  {
    vacio = false;
    parametros += "<Producto Ref=\"" + qryComponentes.value("a.referencia") + "\" IdComp=\"" + qryComponentes.value("ac.id") + "\" Desc=\"" + qryComponentes.value("ac.desccomponente") + "\" IdTipoProceso=\"" + qryComponentes.value("a.idtipoproceso") + "\">";
    parametros += qryComponentes.value("a.xmlparametros");
    parametros += "</Producto>";
    if (qryComponentes.value("a.fabricado")) {
      componentes = this.iface.paramDefectoComponentes(qryComponentes.value("a.referencia"));
      //debug(componentes);
      if (!componentes) {
        MessageBox.warning(util.translate("scripts", "Error al obtener los componentes del producto %1").arg(qryComponentes.value("a.referencia")), MessageBox.Ok, MessageBox.NoButton);
        return false;
      }
      if (componentes != "vacio") {
        parametros += componentes;
      }
    }
  }
  if (vacio)
    parametros = "vacio";
  return parametros;
}

function artesG_filtrarItinerarios()
{
  var curProducto: FLSqlCursor = this.child("tdbProductos").cursor();
  var idProducto: String = curProducto.valueBuffer("idproducto");
  var filtro: String = "";

  if (!idProducto) {
    filtro = "idproducto = -1";
    //    this.child("tdbItinerarios").cursor().setMainFilter("idproducto = -1");
  } else {
    filtro = "idproducto = " + idProducto;
    //    this.child("tdbItinerarios").cursor().setMainFilter("idproducto = " + idProducto);
  }
  if (!this.child("chkMostrarInviables").checked) {
    filtro += " AND estado = 'OK'";
  }
  this.child("tdbItinerarios").setFilter(filtro);
  this.child("tdbItinerarios").refresh();
}

function artesG_escogerItinerario_clicked()
{
  var util: FLUtil = new FLUtil;
  var curItinerario: FLSqlCursor = this.child("tdbItinerarios").cursor();
  var idItinerario: String = curItinerario.valueBuffer("iditinerario");
  if (!idItinerario)
    return;

  this.iface.escogerItinerario(idItinerario);

  this.child("tdbProductos").refresh();
  this.child("tdbItinerarios").refresh();
  this.iface.resumenTrabajo();
}

function artesG_escogerItinerario(idItinerario: String)
{
  var util: FLUtil = new FLUtil;

  var idProducto: String = util.sqlSelect("itinerarioslp", "idproducto", "iditinerario = " + idItinerario);

  if (!util.sqlUpdate("itinerarioslp", "escogido", "false", "idproducto = " + idProducto)) {
    return false;
  }

  if (!util.sqlUpdate("itinerarioslp", "escogido", "true", "iditinerario = " + idItinerario)) {
    return false;
  }
  this.iface.actualizarCosteProducto(idProducto, idItinerario);
}

function artesG_actualizarCosteProducto(idProducto: String, idItinerario: String): Boolean {
  var util: FLUtil = new FLUtil;
  var curProducto: FLSqlCursor = new FLSqlCursor("productoslp");
  curProducto.select("idproducto = " + idProducto);
  if (!curProducto.first())
  {
    return false;
  }

  var coste: Number = parseFloat(util.sqlSelect("itinerarioslp", "costetotal", "iditinerario = " + idItinerario));
  if (isNaN(coste))
  {
    coste = 0;
  }

  curProducto.setModeAccess(curProducto.Edit);
  curProducto.refreshBuffer();
  curProducto.setValueBuffer("coste", coste);
  if (!curProducto.commitBuffer())
  {
    return;
  }

  this.child("fdbCosteProd").setValue(this.iface.calculateField("costeprod"));
  return true;
}

function artesG_ponDetalleTarea(xmlProceso: FLDomNode, detalle: String, atributo: String): Boolean {
  var xmlTarea: FLDomNode;
  if (xmlProceso.nodeName() == "Tarea")
  {
    xmlTarea = xmlProceso;
  } else {
    var idTipoTareaPro: String = xmlProceso.toElement().attribute("IdTipoTareaProActual");
    xmlTarea = flfacturac.iface.pub_dameNodoXML(xmlProceso, "Tareas/Tarea[@IdTipoTareaPro=" + idTipoTareaPro + "]");
    if (!xmlTarea)
      return false;
  }

  var detalleTarea: String = xmlTarea.toElement().attribute(atributo);
  if (!detalleTarea)
    detalleTarea == "";

  detalleTarea = detalleTarea + "\n" + detalle;

  while (detalleTarea.startsWith("\n"))
  {
    detalleTarea = detalleTarea.right(detalleTarea.length - 1);
  }

  xmlTarea.toElement().setAttribute(atributo, detalleTarea);

  return true;
}

function artesG_quitaDetalleTarea(xmlProceso: FLDomNode, atributo: String): Boolean {
  var xmlTarea: FLDomNode;
  if (xmlProceso.nodeName() == "Tarea")
  {
    xmlTarea = xmlProceso;
  } else {
    var idTipoTareaPro: String = xmlProceso.toElement().attribute("IdTipoTareaProActual");
    xmlTarea = flfacturac.iface.pub_dameNodoXML(xmlProceso, "Tareas/Tarea[@IdTipoTareaPro=" + idTipoTareaPro + "]");
    if (!xmlTarea)
    {
      return false;
    }
  }

  xmlTarea.toElement().setAttribute(atributo, "");

  return true;
}

/** \D Lanza el formulario de log, estableciendo antes en una variable global el tipo de acción a realizar
\end */
function artesG_lanzarLog(accion: String)
{
  var miVar: FLVar = new FLVar();
  miVar.set("ACCIONAG", accion);
  return;
  this.iface.log = new FLFormSearchDB("logag");
  var cursor: FLSqlCursor = this.iface.log.cursor();
  cursor.select();
  cursor.first();
  cursor.setModeAccess(cursor.Browse);
  this.iface.log.setMainWidget();
  cursor.refreshBuffer();
  this.iface.log.exec("id");
  this.iface.log.close();
}

// function artesG_calcular_clicked()
// {
//
// debug(1);
//  if (!this.iface.xmlTrabajosPliego_) {
//    if (!this.iface.calcularTrabajosPorPliego()) {
//      return false;
//    }
// debug(2);
//    this.iface.idTPActual_ = -1;
//  }
// debug(3);
//  var xmlTP:FLDomNodeList = this.iface.xmlTrabajosPliego_.elementsByTagName("TrabajosPliegoParam");
//  var totalTP:Number = xmlTP.length();
// debug("totalTP = " + totalTP);
//  if (totalTP == 0)
//    return false;
//
//  this.iface.idTPActual_++;
//  if (this.iface.idTPActual_ == totalTP)
//    this.iface.idTPActual_ = 0;
// debug(this.iface.idTPActual_);
//  this.iface.dibujarTP();
//  this.child("lblNumTP").text = this.iface.idTPActual_ + " de " + totalTP;
// }
//
// function artesG_dibujarTP()
// {
// debug("artesG_dibujarTP");
//  var util = new FLUtil();
//  var nodoTP:FLDomNode = this.iface.xmlTrabajosPliego_.elementsByTagName("TrabajosPliegoParam").item(this.iface.idTPActual_);
//  var eTP:FLDomElement = nodoTP.toElement();
//
// debug("artesG_dibujarTP2");
//  var lblPix = this.child( "lblDiagrama" );
//  var pix = new Pixmap();
//  var pic = new Picture();
//  var clr = new Color();
//  var devSize = new Size( 300, 300);
//  var devRect = new Rect( 0, 0, 300, 300 );
//  pic.begin();
// debug("artesG_dibujarTP3");
//  pix.resize(devSize);
//  clr.setRgb( 255, 255, 255 );
//  pix.fill( clr );
//
//  var trabajos:FLDomNodeList = eTP.elementsByTagName("Trabajo");
//  var eTrabajo:FLDomElement;
//  var w = 0, h = 0, x = 0, y = 0;
//  var dibTrabajos:Array = [];
// debug("artesG_dibujarTP4");
//  pic.setPen( new Color( 255, 0, 0 ) , 1 );
// debug("artesG_dibujarTP5");
//  //var svg:String = "<svg width=\"300\" height=\"300\" x=\"0\" y=\"0\" id=\"0\"><g style=\"stroke:rgb(0,0,0);stroke-width:0.9;fill:none;\">";
//  for (var i:Number = 0; i < trabajos.length(); i++) {
//    eTrabajo = trabajos.item(i).toElement();
//    dibTrabajos[i] = new Rect(eTrabajo.attribute("X"), eTrabajo.attribute("Y"), eTrabajo.attribute("W"), eTrabajo.attribute("H"));
// debug("artesG_dibujarTP6");
//    pic.drawRect(dibTrabajos[i]);
// debug("artesG_dibujarTP7");
//    //svg += "<rect width=\"" + eTrabajo.attribute("W") + "\" height=\"" + eTrabajo.attribute("H") + "\" x=\"" + eTrabajo.attribute("X") + "\" y=\"" + eTrabajo.attribute("Y") + "\" id=\"0\" style=\"stroke:rgb(0,0,0);stroke-width:0.9;fill:none;\" />";
//  }
//
//  pix = pic.playOnPixmap( pix );
//  lblPix.pixmap = pix;
// pic.end();
// debug("artesG_dibujarTP2");
//  //svg += "</g></svg>
// var docxml= new FLDomDocument;
// docxml.appendChild(nodoTP.cloneNode());
// debug(docxml.toString(4));
//
// }

function artesG_instruccionesPlanchas(xmlProceso: FLDomNode): String {
  return "";
  /// Obsoleto, ya ho se calculan las máculas en la distribución sino como MaculasPorPlancha x TotalPlanchas. Parece que las pasadas tampoco
  var util: FLUtil = new FLUtil;
  var instrucciones: String = "";
  var numPliegos: Number = parseInt(flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/DistPlanchaParam@NumPliegos"));
  var numMaculas: Number = parseInt(flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/DistPlanchaParam@NumMaculas"));
  var totalPliegos: Number = numPliegos + numMaculas;
  instrucciones += util.translate("scripts", "\nSe consumirán %1 pliegos de impresión (%2 para impresión + %3 para máculas).").arg(totalPliegos).arg(numPliegos).arg(numMaculas);

  var xmlPlanchas: FLDomNodeList = xmlProceso.namedItem("Parametros").namedItem("DistPlanchaParam").childNodes();
  var juego: String = "";
  var ePlancha: FLDomElement;
  var distJuego: Array;
  instrucciones += util.translate("scripts", "\nPasadas:");
  for (var i: Number; i < xmlPlanchas.length(); i++)
  {
    ePlancha = xmlPlanchas.item(i).toElement();
    if (ePlancha.attribute("Juego") != juego) {
      juego = ePlancha.attribute("Juego");
      instrucciones += util.translate("scripts", "\nJuego %1: %2 pasadas.").arg(juego).arg(ePlancha.attribute("NumPasadas"));
    }
  }
  instrucciones += util.translate("scripts", "\nTotal pasadas: %1").arg(flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/DistPlanchaParam@NumPasadas"));
  return instrucciones;
}

function artesG_instruccionesJuegosPlancha(xmlProceso: FLDomNode): String {
  var util: FLUtil = new FLUtil;
  var instrucciones: String = "";

  instrucciones += util.translate("scripts", "\nTotal de planchas necesarias: %1 (%2 juegos).").arg(flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/DistPlanchaParam@NumPlanchas")).arg(flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/DistPlanchaParam@NumJuegos"));
  /*
    var xmlPlanchas:FLDomElement = flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/DistPlanchaParam");
    if (!xmlPlanchas) {
      return "";
    }
    var ePlanchas:FLDomElement = xmlPlanchas.toElement();
    var totalJuegos:Number = parseInt(ePlanchas.attribute("NumJuegos"));
    var totalPlanchas:Number = parseInt(ePlanchas.attribute("NumPlanchas"));
    var primeraDelJuego:Boolean = false;
    instrucciones += "\n";
    for (var iJuego:Number = 1; iJuego <= totalJuegos; iJuego++) {
      instrucciones += util.translate("scripts", "Juego %1. %2 Pliegos. Planchas: ").arg(iJuego).arg(numPliegos)
  //    coloresJuego = 0;
  debug("iJuego = " + iJuego);
  //    primeraDelJuego = true;
      for (var iPlancha:Number = 0; iPlancha < totalPlanchas; iPlancha++) {
        ePlancha = xmlPlanchas.item(iPlancha).toElement();
        if (iJuego != parseInt(ePlancha.attribute("Juego"))) {
          continue;
        }
  //      coloresJuego++;
        if (primeraDelJuego) {
          primeraDelJuego = false;
          pliegosJuego = 0;
          pasadasJuego = 0;
          if (cantidadesPorModelo) {
            numPliegosPlancha = parseInt(ePlancha.attribute("NumPliegos"));
          } else {
            repeticiones = this.iface.dameRepeticionesEnPlancha(xmlPlanchas.item(iPlancha));
            if (estiloImpresion == "TiraRetira" && !troquelado) {
              numPliegosPlancha = Math.ceil(numCopias / (repeticiones * 2));
            } else {
              numPliegosPlancha = Math.ceil(numCopias / repeticiones);
            }
          }
        }
      }*/
  return instrucciones;
}

function artesG_tbnParamProceso_clicked()
{
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  var curProducto: FLSqlCursor = this.child("tdbProductos").cursor();
  var idComp: String = curProducto.valueBuffer("idcomponente");
  //  if (!idComp) {
  //    return false;
  //  }

  this.iface.idProductoSel_ = curProducto.valueBuffer("idproducto");

  var referencia: String = curProducto.valueBuffer("referencia");
  var accion: String;
  switch (referencia) {
    case "PAGINAS_LIBRO": {
      accion = "paramiptico";
      break;
    }
    case "TAPA_LIBRO": {
      accion = "paramiptico";
      break;
    }
    case "ENVIO": {
      accion = "paramenvio";
      break;
    }
    case "TAREA_MANUAL": {
      accion = "paramtareamanual";
      break;
    }
    case "TACO": {
      accion = "paramtaco";
      break;
    }
    case "IPTICO": {
      accion = "paramiptico";
      break;
    }
    case "LIBRO": {
      accion = "paramlibro";
      break;
    }
    default: {
      return;
    }
  }
  debug("id producto = " + this.iface.idProductoSel_);
  this.iface.curParametros = new FLSqlCursor(accion);
  this.iface.curParametros.select("idproducto = " + this.iface.idProductoSel_);
  if (!this.iface.curParametros.first()) {
    var crearProducto: Boolean = false;
    if (curProducto.valueBuffer("referencia") == cursor.valueBuffer("referencia")) {
      this.iface.curParametros.select("idlinea = " + cursor.valueBuffer("idlinea"));
      crearProducto = !this.iface.curParametros.first();
    } else {
      crearProducto = true;
    }
    if (crearProducto) {
      this.iface.curParametros.setModeAccess(this.iface.curParametros.Insert);
      this.iface.curParametros.refreshBuffer();
      this.iface.curParametros.setValueBuffer("idproducto", this.iface.idProductoSel_);
      if (!this.iface.curParametros.commitBuffer()) {
        return false;
      }
      this.iface.curParametros.select("idproducto = " + this.iface.idProductoSel_);
      if (!this.iface.curParametros.first()) {
        return false;
      }
    }
  }
  this.iface.curParametros.editRecord();
}

function artesG_tbnParametros_clicked()
{
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  var curProducto: FLSqlCursor = this.child("tdbProductos").cursor();
  if (cursor.modeAccess() == cursor.Insert) {
    if (!curProducto.commitBufferCursorRelation()) {
      return false;
    }
  }

  var referencia: String = cursor.valueBuffer("referencia");
  var accion: String;
  switch (referencia) {
    case "IPTICO": {
      accion = "paramiptico";
      break;
    }
    case "LIBRO": {
      accion = "paramlibro";
      break;
    }
    case "TACO": {
      accion = "paramtaco";
      break;
    }
    default: {
      return;
    }
  }
  var idLinea: String = cursor.valueBuffer("idlinea");
  this.iface.curParametros = new FLSqlCursor(accion);
  /// Sólo el registro de parámetros asociado al producto principal (la referencia de la línea tiene idlinea, los demás tienen idproducto
  this.iface.curParametros.select("idlinea = " + idLinea);

  if (!this.iface.curParametros.first()) {
    debug("No encotrada " + accion + " para linea " + idLinea);
    this.iface.curParametros.setModeAccess(this.iface.curParametros.Insert);
    this.iface.curParametros.refreshBuffer();
    this.iface.curParametros.setValueBuffer("idlinea", idLinea);
    switch (accion) {
      case "paramiptico": {
        var sangriaDefecto: Number = flfactalma.iface.pub_valorDefectoAlmacen("sangriaipticos");
        this.iface.curParametros.setValueBuffer("sangriasup", sangriaDefecto);
        this.iface.curParametros.setValueBuffer("sangriainf", sangriaDefecto);
        this.iface.curParametros.setValueBuffer("sangriader", sangriaDefecto);
        this.iface.curParametros.setValueBuffer("sangriaizq", sangriaDefecto);
        var codCalidad: String = flfactalma.iface.pub_valorDefectoAlmacen("codcalidad");
        this.iface.curParametros.setValueBuffer("codcalidad", codCalidad);
        break;
      }
      case "paramtaco": {
        var sangriaDefecto: Number = flfactalma.iface.pub_valorDefectoAlmacen("sangriaipticos");
        this.iface.curParametros.setValueBuffer("sangriasup", sangriaDefecto);
        this.iface.curParametros.setValueBuffer("sangriainf", sangriaDefecto);
        this.iface.curParametros.setValueBuffer("sangriader", sangriaDefecto);
        this.iface.curParametros.setValueBuffer("sangriaizq", sangriaDefecto);
        var codCalidad: String = flfactalma.iface.pub_valorDefectoAlmacen("codcalidad");
        this.iface.curParametros.setValueBuffer("codcalidad", codCalidad);
        break;
      }
      case "paramlibro": {
        var codCalidad: String = flfactalma.iface.pub_valorDefectoAlmacen("codcalidad");
        this.iface.curParametros.setValueBuffer("codcalidad", codCalidad);
        this.iface.curParametros.setValueBuffer("codcalidadtapa", codCalidad);
        break;
      }
    }
    if (!this.iface.curParametros.commitBuffer()) {
      return false;
    }
    this.iface.curParametros.select("idlinea = " + cursor.valueBuffer("idlinea"));
    if (!this.iface.curParametros.first()) {
      return false;
    }
  }
  connect(this.iface.curParametros, "bufferCommited()", this, "iface.refrescarProductos");
  this.iface.curParametros.editRecord();
}

function artesG_tbnParametrosIt_clicked()
{
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  var idComp: String = this.child("tdbProductos").cursor().valueBuffer("idcomponente");
  if (!idComp)
    return false;

  var xmlParam: FLDomDocument = new FLDomDocument;
  if (!xmlParam.setContent(cursor.valueBuffer("xmlparametros"))) {
    MessageBox.warning(util.translate("scripts", "Error al cargar los parámetros de la línea seleccionada"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  var nodoProducto: FLDomNode = flfacturac.iface.pub_dameNodoXML(xmlParam.firstChild(), "Producto[@IdComp=" + idComp + "]");
  //debug(nodoProducto);
  //debug(nodoProducto.nodeName());

  var idTipoProceso: String = nodoProducto.toElement().attribute("IdTipoProceso");
  if (!idTipoProceso) {
    return false;
  }
  delete xmlParam;
  var xmlParam2: FLDomDocument = new FLDomDocument;
  if (!xmlParam2.setContent(this.child("tdbItinerarios").cursor().valueBuffer("xmlparametros")))
    return false;;
  //xmlParam.firstChild().removeChild(xmlParam.firstChild().namedItem("Tareas"));
  var nodoProducto2: FLDomNode = xmlParam2.firstChild();

  //debug(idTipoProceso);
  switch (idTipoProceso) {
    case "TRIP": {
      flfacturac.iface.pub_mostrarParamIptico(nodoProducto2);
      break;
    }
  }
}

function artesG_tbnVerItinerario_clicked()
{
  var util: FLUtil = new FLUtil;
  var curProducto: FLSqlCursor = this.child("tdbProductos").cursor();
  var idProducto: String = curProducto.valueBuffer("idproducto");
  if (!idProducto) {
    return false;
  }
  var curItinerario: FLSqlCursor = this.child("tdbItinerarios").cursor();
  curItinerario.select("idproducto = " + idProducto + " AND escogido = true");
  if (!curItinerario.first()) {
    MessageBox.warning(util.translate("scripts", "No hay un itinerario escogido para el producto seleccionado"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  curItinerario.editRecord();
}

function artesG_marcarMejorItinerario(idProducto: String): Boolean {
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  //  var curProducto:FLSqlCursor = this.child("tdbProductos").cursor();
  //  var idProducto:String = curProducto.valueBuffer("idproducto");
  //  if (!idProducto) {
  //    return false;
  //  }
  // debug("idproducto = " + idProducto);
  var idItinerarioSel: String = util.sqlSelect("itinerarioslp", "iditinerario", "idproducto = " + idProducto + " AND estado = 'OK' ORDER BY costetotal");
  if (!idItinerarioSel)
  {
    MessageBox.warning(util.translate("scripts", "No se ha obtenido ningún itinerario viable"), MessageBox.Ok, MessageBox.NoButton);
    if (!util.sqlUpdate("productoslp", "coste", "0", "idproducto = " + idProducto)) {
      return false;
    }
  } else {
    this.iface.escogerItinerario(idItinerarioSel);
  }
  return true;
}

function artesG_ponConsumoTarea(xmlTarea: FLDomNode, referencia: String, cantidad: Number, costeUnidad: Number, cantidadAux: Number, porBeneficio: Number): Boolean {
  var util: FLUtil = new FLUtil;
  //  var nodoConsumo:FLDomNode = flfacturac.iface.pub_crearNodoHijoVacio(xmlTarea.namedItem("Consumos"), "Consumo");
  //  nodoConsumo.toElement().setAttribute("Referencia", referencia);
  //  nodoConsumo.toElement().setAttribute("Cantidad", cantidad);

  var eConsumo: FLDomElement = xmlTarea.ownerDocument().createElement("Consumo")
  xmlTarea.namedItem("Consumos").appendChild(eConsumo);
  eConsumo.setAttribute("Referencia", referencia);
  eConsumo.setAttribute("Cantidad", cantidad);
  eConsumo.setAttribute("CantidadAux", cantidadAux);
  eConsumo.setAttribute("PorBeneficio", porBeneficio);
  eConsumo.setAttribute("CosteUnidad", costeUnidad);
  var costeNeto: Number = costeUnidad * cantidad;
  var costeTotal: Number = costeNeto * (100 + porBeneficio) / 100;
  eConsumo.setAttribute("CosteNeto", util.roundFieldValue(costeNeto, "consumoslp", "costeneto"));
  eConsumo.setAttribute("CosteTotal", util.roundFieldValue(costeTotal, "consumoslp", "costetotal"));
  return true;
}

function artesG_dameTiempoExtraPantone(xmlParamImpresora: FLDomNode, xmlProceso: FLDomNode): Array {
  var res: Array = [];
  res["tiempototal"] = false;
  res["numpantones"] = false;
  res["tiempopantone"] = 0;

  var tiempoExtra: Number = xmlParamImpresora.toElement().attribute("TiempoExtraPantone");
  if (isNaN(tiempoExtra) || tiempoExtra == 0)
  {
    res["tiempototal"] = 0;
    return res;
  }
  var numPantones: Number = parseFloat(flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/DistPlanchaParam@NumPantones"));
  if (isNaN(numPantones) || numPantones == 0)
  {
    res["tiempototal"] = 0;
    return res;
  }
  res["numpantones"] = numPantones;
  res["tiempopantone"] = tiempoExtra;
  res["tiempototal"] = tiempoExtra * numPantones;

  return res;
}

function artesG_tbnSiguienteOpcion_clicked()
{
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  var curProducto: FLSqlCursor = this.child("tdbProductos").cursor();
  var idComponente: String = curProducto.valueBuffer("idcomponente");
  if (!idComponente) {
    return false;
  }
  var idGrupoCalculo: String = curProducto.valueBuffer("idgrupocalculo");
  var opcion: String = curProducto.valueBuffer("opcion");
  var qryOpciones: FLSqlQuery = new FLSqlQuery;
  with(qryOpciones) {
    setTablesList("productoslp");
    setSelect("opcion, SUM(coste)");
    setFrom("productoslp");
    setWhere("idlinea = " + cursor.valueBuffer("idlinea") + " AND idcomponente = " + idComponente + " AND idgrupocalculo = " + idGrupoCalculo + " GROUP BY opcion ORDER BY opcion");
  }
  if (!qryOpciones.exec()) {
    return false;
  }
  var encontrado: Boolean = false;
  while (qryOpciones.next()) {
    if (opcion == qryOpciones.value("opcion")) {
      if (!qryOpciones.next()) {
        if (!qryOpciones.first()) {
          return false;
        }
      }
      encontrado = true;
      break;
    }
  }
  if (!encontrado) {
    return false;
  }
  var siguienteOpcion: String = qryOpciones.value("opcion");
  if (!util.sqlUpdate("productoslp", "seleccionado", false, "idlinea = " + cursor.valueBuffer("idlinea") + " AND idcomponente = " + idComponente + " AND idgrupocalculo = " + idGrupoCalculo)) {
    return false;
  }
  if (!siguienteOpcion || siguienteOpcion == "") {
    if (!util.sqlUpdate("productoslp", "seleccionado", true, "idlinea = " + cursor.valueBuffer("idlinea") + " AND idcomponente = " + idComponente + " AND idgrupocalculo = " + idGrupoCalculo + " AND (opcion = '' OR opcion IS NULL)")) {
      return false;
    }
  } else {
    if (!util.sqlUpdate("productoslp", "seleccionado", true, "idlinea = " + cursor.valueBuffer("idlinea") + " AND idcomponente = " + idComponente + " AND idgrupocalculo = " + idGrupoCalculo + " AND opcion = '" + siguienteOpcion + "'")) {
      return false;
    }
  }
  this.child("fdbCosteProd").setValue(this.iface.calculateField("costeprod"));
  this.child("lblCosteOpcion").text = qryOpciones.value("SUM(coste)");

  this.child("tdbProductos").refresh();
  return;
}

function artesG_refrescarProductos()
{
  debug("artesG_refrescarProductos");
  this.child("tdbProductos").refresh();
  this.child("fdbDescripcion").setValue(this.iface.calculateField("descripcion"));
  this.child("fdbCantidad").setValue(this.iface.calculateField("cantidad"));
  formRecordpresupuestoscli.iface.pub_marcarRecalculoHecho(true);
}

function artesG_resumenTrabajo()
{
  this.iface.iniciarFiltroResumen();

  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  var idLinea: String = cursor.valueBuffer("idlinea");

  var qryTareas: FLSqlQuery = new FLSqlQuery;
  qryTareas.setTablesList("productoslp,itinerarioslp");
  qryTareas.setSelect("t.codtipocentro, tcc.tipotrabajo, SUM(t.tiempo), SUM(t.costemo), SUM(t.pasadas)");
  qryTareas.setFrom("productoslp p INNER JOIN itinerarioslp i ON (p.idproducto = i.idproducto AND i.escogido = true) INNER JOIN tareaslp t ON i.iditinerario = t.iditinerario LEFT OUTER JOIN pr_tiposcentrocoste tcc ON t.codtipocentro = tcc.codtipocentro");
  qryTareas.setWhere("p.idlinea = " + idLinea + " GROUP BY tcc.tipotrabajo, t.codtipocentro ORDER BY tcc.tipotrabajo, t.codtipocentro");
  qryTareas.setForwardOnly(true);
  if (!qryTareas.exec()) {
    return false;
  }
  var costeTarea: Number;
  // debug(qryTareas.sql());
  var refAnterior: String;
  var codTipoCentroAnterior: String;
  var codTipoTrabajoAnterior: String;
  var informeTareas: String = util.translate("scripts", "\n\nTAREAS: ");
  informeTareas += "\n";
  var datosTareas: Array = [];
  //  var totalRefImpresion:Number = 0;
  //  var totalRefManipulado:Number = 0;
  //  var totalRefEncuadernacion:Number = 0;
  //  var totalImpresion:Number = 0;
  //  var totalManipulado:Number = 0;
  //  var totalEncuadernacion:Number = 0;
  //  var tiempoRefImpresion:Number = 0;
  //  var tiempoRefManipulado:Number = 0;
  //  var tiempoRefEncuadernacion:Number = 0;
  //  var tiempoImpresion:Number = 0;
  //  var tiempoManipulado:Number = 0;
  //  var tiempoEncuadernacion:Number = 0;
  var tiempo: Number;
  var coste: Number;
  var tipoTrabajo: String;
  var tipoTrabajoAnterior: String = "";
  var costeTipoTrabajo: Number = 0;
  var porcentaje: Number;
  var costeTotal: Number = parseFloat(cursor.valueBuffer("costeprod"));
  var pasadas: Number;
  while (qryTareas.next()) {
    coste = parseFloat(qryTareas.value("SUM(t.costemo)"));
    if (isNaN(coste)) {
      coste = 0;
    }
    if (coste == 0) {
      continue;
    }
    tipoTrabajo = qryTareas.value("tcc.tipotrabajo");
    if (tipoTrabajo != tipoTrabajoAnterior) {
      if (tipoTrabajoAnterior != "") {
        porcentaje = (costeTipoTrabajo * 100) / costeTotal;
        porcentaje = util.roundFieldValue(porcentaje, "tareaslp", "costetiempo");
        costeTipoTrabajo = util.roundFieldValue(costeTipoTrabajo, "tareaslp", "costetiempo")
                           informeTareas += this.iface.formatoTexto("", 4, 1);
        informeTareas += this.iface.formatoTexto(util.translate("scripts", "Total %1:").arg(tipoTrabajoAnterior), 40, 1);
        informeTareas += this.iface.formatoTexto(util.translate("scripts", "Coste: "), 8, 1);
        informeTareas += this.iface.formatoTexto(costeTipoTrabajo, 8, 2);
        informeTareas += this.iface.formatoTexto("(" + porcentaje + "%)", 10, 2);
        informeTareas += "\n\n";
        costeTipoTrabajo = 0;
      }
      tipoTrabajoAnterior = tipoTrabajo;
      informeTareas += util.translate("scripts", "%1:").arg(tipoTrabajoAnterior);
      informeTareas += "\n";
    }
    tiempo = parseFloat(qryTareas.value("SUM(t.tiempo)"));
    if (isNaN(tiempo)) {
      tiempo = 0;
    }
    costeTipoTrabajo += parseFloat(coste);
    // debug("Ref " + qryTareas.value("p.referencia") + " Coste = " + coste + " Tiempo " + tiempo);
    // debug(qryTareas.value("tcc.tipotrabajo"));
    informeTareas += this.iface.formatoTexto("", 4, 1);
    informeTareas += this.iface.formatoTexto(qryTareas.value("t.codtipocentro") + ":   ", 20, 1);
    pasadas = qryTareas.value("SUM(t.pasadas)");
    if (!isNaN(pasadas) && pasadas > 0) {
      informeTareas += this.iface.formatoTexto("Pasadas:", 8, 1);
      informeTareas += this.iface.formatoTexto(qryTareas.value("SUM(t.pasadas)"), 8, 2);
    } else {
      informeTareas += this.iface.formatoTexto("Tiempo:", 8, 1);
      informeTareas += this.iface.formatoTexto(this.iface.formatoTiempo(tiempo), 8, 2);
    }
    informeTareas += this.iface.formatoTexto("", 4, 1);
    informeTareas += this.iface.formatoTexto("Coste:", 8, 1);
    informeTareas += this.iface.formatoTexto(util.roundFieldValue(coste, "tareaslp", "costetiempo"), 8, 2);
    informeTareas += "\n";
  }
  // debug(informeTareas);

  var datos: Array = [];
  datos["totalpapel"] = 0;
  datos["papelportada"] = 0;
  datos["numpliegosportada"] = 0;
  datos["nummaculasportada"] = 0;
  datos["papelinterior"] = 0;
  datos["numpliegosinterior"] = 0;
  datos["nummaculasinterior"] = 0;
  datos["totalplancha"] = 0;
  datos["planchaportada"] = 0;
  datos["numplanchasportada"] = 0;
  datos["planchainterior"] = 0;
  datos["numplanchasinterior"] = 0;
  datos["totalresto"] = 0;
  datos["restoportada"] = 0;
  datos["restointerior"] = 0;
  datos["portes"] = 0;

  var qryConsumos: FLSqlQuery = new FLSqlQuery;
  qryConsumos.setTablesList("productoslp,itinerarioslp");
  qryConsumos.setSelect("p.idproducto, p.referencia, c.costetotal, c.referencia, a.codfamilia, c.cantidad, c.cantidadaux");
  qryConsumos.setFrom("productoslp p INNER JOIN itinerarioslp i ON (p.idproducto = i.idproducto AND i.escogido = true) INNER JOIN tareaslp t ON i.iditinerario = t.iditinerario INNER JOIN consumoslp c ON c.idtarea = t.idtarea LEFT OUTER JOIN articulos a ON c.referencia = a.referencia");
  qryConsumos.setWhere("p.idlinea = " + idLinea + " ORDER BY p.idproducto, i.iditinerario, t.idtarea, c.idconsumo");
  qryConsumos.setForwardOnly(true);
  if (!qryConsumos.exec()) {
    return false;
  }

  var codFamiliaConsumo: String;
  var costeConsumo: Number;
  var cantidad: Number;
  var cantidadAux: Number;
  debug(qryConsumos.sql());
  while (qryConsumos.next()) {
    codFamiliaConsumo = qryConsumos.value("a.codfamilia");
    costeConsumo = parseFloat(qryConsumos.value("c.costetotal"));
    cantidad = parseInt(qryConsumos.value("c.cantidad"));
    cantidadAux = parseInt(qryConsumos.value("c.cantidadaux"));
    // debug("ref = " + qryConsumos.value("c.referencia") + " coste = " + costeConsumo);
    switch (codFamiliaConsumo) {
      case "PORT": {
        datos["portes"] += costeConsumo;
        break;
      }
      case "PAPE": {
        switch (qryConsumos.value("p.referencia")) {
          case "IPTICO": {
            datos["totalpapel"] += costeConsumo;
            datos["numpliegosinterior"] += cantidad;
            datos["nummaculasinterior"] += cantidadAux;
            break;
          }
          case "PAGINAS_LIBRO": {
            datos["papelinterior"] += costeConsumo;
            datos["totalpapel"] += costeConsumo;
            datos["numpliegosinterior"] += cantidad;
            datos["nummaculasinterior"] += cantidadAux;
            break;
          }
          case "TAPA_LIBRO": {
            datos["papelportada"] += costeConsumo;
            datos["totalpapel"] += costeConsumo;
            datos["numpliegosportada"] += cantidad;
            datos["nummaculasportada"] += cantidadAux;
            break;
          }
          case "TACO": {
            datos["totalpapel"] += costeConsumo;
            datos["numpliegosinterior"] += cantidad;
            datos["nummaculasinterior"] += cantidadAux;
            break;
          }
          default: {
            /// NO debería entrar nunca aquí
            datos["totalpapel"] += costeConsumo;
            break;
          }
        }
        break;
      }
      case "PLAN": {
        switch (qryConsumos.value("p.referencia")) {
          case "IPTICO": {
            datos["totalplancha"] += costeConsumo;
            datos["numplanchasinterior"] += cantidad;
            break;
          }
          case "PAGINAS_LIBRO": {
            datos["planchainterior"] += costeConsumo;
            datos["totalplancha"] += costeConsumo;
            datos["numplanchasinterior"] += cantidad;
            break;
          }
          case "TAPA_LIBRO": {
            datos["planchaportada"] += costeConsumo;
            datos["totalplancha"] += costeConsumo;
            datos["numplanchasportada"] += cantidad;
            break;
          }
          case "TACO": {
            datos["totalplancha"] += costeConsumo;
            datos["numplanchasinterior"] += cantidad;
            break;
          }
          default: {
            /// NO debería entrar nunca aquí
            datos["totalplancha"] += costeConsumo;
            break;
          }
        }
        break;
      }
      default: {
        switch (qryConsumos.value("p.referencia")) {
          case "IPTICO": {
            datos["totalresto"] += costeConsumo;
            break;
          }
          case "PAGINAS_LIBRO": {
            datos["restointerior"] += costeConsumo;
            datos["totalresto"] += costeConsumo;
            break;
          }
          case "TAPA_LIBRO": {
            datos["restoportada"] += costeConsumo;
            datos["totalresto"] += costeConsumo;
            break;
          }
          case "TACO": {
            datos["totalresto"] += costeConsumo;
            break;
          }
          default: {
            /// NO debería entrar nunca aquí
            datos["totalresto"] += costeConsumo;
            break;
          }
        }
        break;
      }
    }
  }

  var informe: String = "";
  var numPliegosSM: Number;
  switch (cursor.valueBuffer("referencia")) {
    case "LIBRO": {
      informe += util.translate("scripts", "MATERIAL:\n");
      informe += util.translate("scripts", "Papel: \n");
      numPliegosSM = datos["numpliegosinterior"] - datos["nummaculasinterior"];
      informe += this.iface.formatoTexto(util.translate("scripts", "  Interior:  Pliegos:"), 20, 1);
      informe += this.iface.formatoTexto(util.translate("scripts", "%1 + %2 = %3").arg(numPliegosSM).arg(datos["nummaculasinterior"]).arg(datos["numpliegosinterior"]), 20, 2);
      informe += this.iface.formatoTexto("", 4, 1);
      informe += this.iface.formatoTexto(util.translate("scripts", "Coste: "), 6, 1);
      informe += this.iface.formatoTexto(util.roundFieldValue(datos["papelinterior"], "tareaslp", "costetiempo"), 8, 2);
      informe += "\n";

      numPliegosSM = datos["numpliegosportada"] - datos["nummaculasportada"];
      informe += this.iface.formatoTexto(util.translate("scripts", "  Portada:   Pliegos:"), 20, 1);
      informe += this.iface.formatoTexto(util.translate("scripts", "%1 + %2 = %3").arg(numPliegosSM).arg(datos["nummaculasportada"]).arg(datos["numpliegosportada"]), 20, 2);
      informe += this.iface.formatoTexto("", 4, 1);
      informe += this.iface.formatoTexto(util.translate("scripts", "Coste: "), 6, 1);
      informe += this.iface.formatoTexto(util.roundFieldValue(datos["papelportada"], "tareaslp", "costetiempo"), 8, 2);
      informe += "\n";

      informe += this.iface.formatoTexto(util.translate("scripts", "  Total papel:"), 20, 1);
      informe += this.iface.formatoTexto("", 24, 2);
      informe += this.iface.formatoTexto(util.translate("scripts", "Total:"), 6, 1);
      informe += this.iface.formatoTexto(util.roundFieldValue(datos["totalpapel"], "tareaslp", "costetiempo"), 8, 2);
      porcentaje = (datos["totalpapel"] * 100) / costeTotal;
      porcentaje = util.roundFieldValue(porcentaje, "tareaslp", "costetiempo");
      informe += this.iface.formatoTexto("(" + porcentaje + "%)", 10, 2);
      informe += "\n";

      informe += "\n";
      informe += util.translate("scripts", "Planchas: \n");
      informe += this.iface.formatoTexto(util.translate("scripts", "  Interior:  Planchas:"), 22, 1);
      informe += this.iface.formatoTexto(datos["numplanchasinterior"], 6, 2);
      informe += this.iface.formatoTexto("", 4, 1);
      informe += this.iface.formatoTexto(util.translate("scripts", "Coste: "), 6, 1);
      informe += this.iface.formatoTexto(util.roundFieldValue(datos["planchainterior"], "tareaslp", "costetiempo"), 8, 2);
      informe += "\n";

      informe += this.iface.formatoTexto(util.translate("scripts", "  Portada:   Planchas:"), 22, 1);
      informe += this.iface.formatoTexto(datos["numplanchasportada"], 6, 2);
      informe += this.iface.formatoTexto("", 4, 1);
      informe += this.iface.formatoTexto(util.translate("scripts", "Coste: "), 6, 1);
      informe += this.iface.formatoTexto(util.roundFieldValue(datos["planchaportada"], "tareaslp", "costetiempo"), 8, 2);
      informe += "\n";

      informe += this.iface.formatoTexto(util.translate("scripts", "  Total planchas:"), 22, 1);
      informe += this.iface.formatoTexto("", 10, 2);
      informe += this.iface.formatoTexto(util.translate("scripts", "Total:"), 6, 1);
      informe += this.iface.formatoTexto(util.roundFieldValue(datos["totalplancha"], "tareaslp", "costetiempo"), 8, 2);
      porcentaje = (datos["totalplancha"] * 100) / costeTotal;
      porcentaje = util.roundFieldValue(porcentaje, "tareaslp", "costetiempo");
      informe += this.iface.formatoTexto("(" + porcentaje + "%)", 10, 2);
      informe += "\n";

      informe += "\n";
      informe += util.translate("scripts", "Resto: \n");
      informe += this.iface.formatoTexto(util.translate("scripts", "  Interior:"), 15, 1);
      informe += this.iface.formatoTexto(util.roundFieldValue(datos["restointerior"], "tareaslp", "costetiempo"), 8, 2);
      informe += "\n";
      informe += this.iface.formatoTexto(util.translate("scripts", "  Portada:"), 15, 1);
      informe += this.iface.formatoTexto(util.roundFieldValue(datos["restoportada"], "tareaslp", "costetiempo"), 8, 2);
      informe += "\n";
      informe += this.iface.formatoTexto(util.translate("scripts", "  Total:"), 15, 1);
      informe += this.iface.formatoTexto(util.roundFieldValue(datos["totalresto"], "tareaslp", "costetiempo"), 8, 2);
      porcentaje = (datos["totalresto"] * 100) / costeTotal;
      porcentaje = util.roundFieldValue(porcentaje, "tareaslp", "costetiempo");
      informe += this.iface.formatoTexto("(" + porcentaje + "%)", 10, 2);
      informe += "\n";
      break;
    }
    case "IPTICO": {
      informe += util.translate("scripts", "Papel: \n");
      numPliegosSM = datos["numpliegosinterior"] - datos["nummaculasinterior"];
      informe += this.iface.formatoTexto(util.translate("scripts", "Pliegos:"), 15, 1);
      informe += this.iface.formatoTexto(util.translate("scripts", "%1 + %2 = %3").arg(numPliegosSM).arg(datos["nummaculasinterior"]).arg(datos["numpliegosinterior"]), 20, 2);
      informe += this.iface.formatoTexto("", 4, 1);
      informe += this.iface.formatoTexto(util.translate("scripts", "Coste: "), 6, 1);
      informe += this.iface.formatoTexto(util.roundFieldValue(datos["totalpapel"], "tareaslp", "costetiempo"), 8, 2);
      porcentaje = (datos["totalpapel"] * 100) / costeTotal;
      porcentaje = util.roundFieldValue(porcentaje, "tareaslp", "costetiempo");
      informe += this.iface.formatoTexto("(" + porcentaje + "%)", 10, 2);
      informe += "\n";

      informe += this.iface.formatoTexto(util.translate("scripts", "Planchas:"), 15, 1);
      informe += this.iface.formatoTexto(datos["numplanchasinterior"], 8, 2);
      informe += this.iface.formatoTexto("", 4, 1);
      informe += this.iface.formatoTexto(util.translate("scripts", "Coste: "), 6, 1);
      informe += this.iface.formatoTexto(util.roundFieldValue(datos["totalplancha"], "tareaslp", "costetiempo"), 8, 2);
      porcentaje = (datos["totalplancha"] * 100) / costeTotal;
      porcentaje = util.roundFieldValue(porcentaje, "tareaslp", "costetiempo");
      informe += this.iface.formatoTexto("(" + porcentaje + "%)", 10, 2);
      informe += "\n";

      informe += this.iface.formatoTexto(util.translate("scripts", "Resto:"), 15, 1);
      informe += this.iface.formatoTexto("", 4, 1);
      informe += this.iface.formatoTexto(util.translate("scripts", "Coste: "), 6, 1);
      informe += this.iface.formatoTexto(util.roundFieldValue(datos["totalresto"], "tareaslp", "costetiempo"), 8, 2);
      porcentaje = (datos["totalresto"] * 100) / costeTotal;
      porcentaje = util.roundFieldValue(porcentaje, "tareaslp", "costetiempo");
      informe += this.iface.formatoTexto("(" + porcentaje + "%)", 10, 2);
      informe += "\n";
      break;
    }
    case "TACO": {
      informe += util.translate("scripts", "Papel: \n");
      numPliegosSM = datos["numpliegosinterior"] - datos["nummaculasinterior"];
      informe += this.iface.formatoTexto(util.translate("scripts", "Pliegos:"), 15, 1);
      informe += this.iface.formatoTexto(util.translate("scripts", "%1 + %2 = %3").arg(numPliegosSM).arg(datos["nummaculasinterior"]).arg(datos["numpliegosinterior"]), 20, 2);
      informe += this.iface.formatoTexto("", 4, 1);
      informe += this.iface.formatoTexto(util.translate("scripts", "Coste: "), 6, 1);
      informe += this.iface.formatoTexto(util.roundFieldValue(datos["totalpapel"], "tareaslp", "costetiempo"), 8, 2);
      porcentaje = (datos["totalpapel"] * 100) / costeTotal;
      porcentaje = util.roundFieldValue(porcentaje, "tareaslp", "costetiempo");
      informe += this.iface.formatoTexto("(" + porcentaje + "%)", 10, 2);
      informe += "\n";

      informe += this.iface.formatoTexto(util.translate("scripts", "Planchas:"), 15, 1);
      informe += this.iface.formatoTexto(datos["numplanchasinterior"], 8, 2);
      informe += this.iface.formatoTexto("", 4, 1);
      informe += this.iface.formatoTexto(util.translate("scripts", "Coste: "), 6, 1);
      informe += this.iface.formatoTexto(util.roundFieldValue(datos["totalplancha"], "tareaslp", "costetiempo"), 8, 2);
      porcentaje = (datos["totalplancha"] * 100) / costeTotal;
      porcentaje = util.roundFieldValue(porcentaje, "tareaslp", "costetiempo");
      informe += this.iface.formatoTexto("(" + porcentaje + "%)", 10, 2);
      informe += "\n";

      informe += this.iface.formatoTexto(util.translate("scripts", "Resto:"), 15, 1);
      informe += this.iface.formatoTexto("", 4, 1);
      informe += this.iface.formatoTexto(util.translate("scripts", "Coste: "), 6, 1);
      informe += this.iface.formatoTexto(util.roundFieldValue(datos["totalresto"], "tareaslp", "costetiempo"), 8, 2);
      porcentaje = (datos["totalresto"] * 100) / costeTotal;
      porcentaje = util.roundFieldValue(porcentaje, "tareaslp", "costetiempo");
      informe += this.iface.formatoTexto("(" + porcentaje + "%)", 10, 2);
      informe += "\n";
      break;
    }
  }
  //  debug(informe);
  this.child("txtResumen").text = informeTareas + "\n\n" + informe;
}

function artesG_formatoTexto(datos: String, maxLon: Number, alineacion: Number): String {
  var texto: String = "";

  if (!datos)
  {
    datos = "";
  } else {
    datos = datos.toString();
  }

  if (maxLon && maxLon != 0)
  {
    texto = datos.left(maxLon);
    if (texto.length < maxLon) {
      if (alineacion == 2) {
        texto = this.iface.espaciosIzquierda(texto, maxLon);
      } else {
        texto = flfactppal.iface.pub_espaciosDerecha(texto, maxLon);
      }
    }
  }

  return texto;
}

function artesG_espaciosIzquierda(texto: String, totalLongitud: Number): String {
  var ret: String = ""
  var numEspacios: Number = totalLongitud - texto.toString().length;
  for (; numEspacios > 0 ; --numEspacios)
    ret += " ";
  ret += texto.toString();
  return ret;
}

function artesG_formatoTiempo(minutos: Number): String {
  var horas: Number = Math.floor(minutos / 60);
  var minRestantes: Number = Math.round(minutos - (horas * 60));
  var valor: String;
  if (horas > 0)
  {
    valor = flfactppal.iface.pub_cerosIzquierda(horas, 2) + "H:" + flfactppal.iface.pub_cerosIzquierda(minRestantes, 2) + "m";
  } else {
    valor = flfactppal.iface.pub_cerosIzquierda(minRestantes, 2) + "m";
  }
  return valor;
}

function artesG_iniciarFiltroResumen()
{
  var cursor: FLSqlCursor = this.cursor();
  var qryProductos: FLSqlQuery = new FLSqlQuery;
  qryProductos.setTablesList("productoslp");
  qryProductos.setSelect("idproducto");
  qryProductos.setFrom("productoslp");
  qryProductos.setWhere("idlinea = " + cursor.valueBuffer("idlinea"));
  qryProductos.setForwardOnly(true);
  if (!qryProductos.exec()) {
    return false;
  }
  while (qryProductos.next()) {
    this.child("tdbResProductos").setPrimaryKeyChecked(qryProductos.value("idproducto"), true);
  }
}

function artesG_establecerFiltrosResumen()
{
  var arrayProd: Array = this.child("tdbResProductos").primarysKeysChecked();
  var listaProd: String = arrayProd.join(",");
  var cursor: FLSqlCursor = this.cursor();
  var qryIt: FLSqlQuery = new FLSqlQuery;
  qryIt.setTablesList("itinerarioslp");
  qryIt.setSelect("iditinerario");
  qryIt.setFrom("itinerarioslp");
  var miWhere: String = "escogido = true";
  if (listaProd && listaProd != "") {
    miWhere += " AND idproducto IN (" + listaProd + ")";
  } else {
    miWhere += " AND 1 = 2";
  }
  qryIt.setWhere(miWhere);
  qryIt.setForwardOnly(true);
  if (!qryIt.exec()) {
    return false;
  }
  this.iface.listaItResumen = "";
  while (qryIt.next()) {
    if (this.iface.listaItResumen != "") {
      this.iface.listaItResumen += ", ";
    }
    this.iface.listaItResumen += qryIt.value("iditinerario");
  }
  var filtroTareas: String;
  if (this.iface.listaItResumen && this.iface.listaItResumen != "") {
    filtroTareas = "iditinerario IN (" + this.iface.listaItResumen + ")";
  } else {
    filtroTareas = "1 = 2";
  }
  this.child("tdbResTareas").setFilter(filtroTareas);
  this.child("tdbResTareas").refresh();
  this.iface.totalizarTareasResumen();

  var filtroConsumos: String;
  if (this.iface.listaItResumen && this.iface.listaItResumen != "") {
    filtroConsumos = "idtarea IN (SELECT idtarea FROM tareaslp WHERE iditinerario IN (" + this.iface.listaItResumen + "))";
  } else {
    filtroConsumos = "1 = 2";
  }
  this.child("tdbResConsumos").setFilter(filtroConsumos);
  this.child("tdbResConsumos").refresh();
}

function artesG_totalizarTareasResumen()
{
  var util: FLUtil = new FLUtil;

  var qryTareas: FLSqlQuery = new FLSqlQuery();
  qryTareas.setTablesList("tareaslp");
  qryTareas.setSelect("SUM(costetotal), SUM(costemo), SUM(costemat), SUM(tiempo)");
  qryTareas.setFrom("tareaslp");
  if (this.iface.listaItResumen && this.iface.listaItResumen != "") {
    qryTareas.setWhere("iditinerario IN (" + this.iface.listaItResumen + ")");
  } else {
    qryTareas.setWhere("1 = 2");
  }
  qryTareas.setForwardOnly(true);
  if (!qryTareas.exec()) {
    return true;
  }
  var acumTiempo: Number = 0;
  var acumMO: Number = 0;
  var acumMat: Number = 0;
  var acumTotal: Number = 0;
  if (qryTareas.first()) {
    acumTiempo = qryTareas.value("SUM(tiempo)");
    acumMO = qryTareas.value("SUM(costemo)");
    acumMat = qryTareas.value("SUM(costemat)");
    acumTotal = qryTareas.value("SUM(costetotal)");
  }
  this.child("lblAcumTiempo").text = util.roundFieldValue(acumTiempo, "lineaspresupuestoscli", "pvptotal");
  this.child("lblAcumMO").text = util.roundFieldValue(acumMO, "lineaspresupuestoscli", "pvptotal");
  this.child("lblAcumMat").text = util.roundFieldValue(acumMat, "lineaspresupuestoscli", "pvptotal");
  this.child("lblAcumTotal").text = util.roundFieldValue(acumTotal, "lineaspresupuestoscli", "pvptotal");
}

function artesG_resTareas_bufferCommited()
{
  var util: FLUtil = new FLUtil;
  var idItinerario: String = this.child("tdbResTareas").cursor().valueBuffer("iditinerario")
  if (!idItinerario || idItinerario == "") {
    return false;
  }
  var idProducto: String = util.sqlSelect("itinerarioslp", "idproducto", "iditinerario = " + idItinerario);
  this.iface.actualizarCosteProducto(idProducto, idItinerario);
  this.iface.totalizarTareasResumen();
  this.child("tdbResTareas").refresh();
  this.child("tdbResProductos").refresh();
  this.child("tdbProductos").refresh();
}

function artesG_resConsumos_bufferCommited()
{
  var util: FLUtil = new FLUtil;
  var idTarea: String = this.child("tdbResConsumos").cursor().valueBuffer("idtarea")
  if (!idTarea || idTarea == "") {
    return false;
  }
  var idItinerario: String = util.sqlSelect("tareaslp", "iditinerario", "idtarea = " + idTarea);
  var idProducto: String = util.sqlSelect("itinerarioslp", "idproducto", "iditinerario = " + idItinerario);
  this.iface.actualizarCosteProducto(idProducto, idItinerario);
  this.iface.totalizarTareasResumen();
  this.child("tdbResConsumos").refresh();
  this.child("tdbResTareas").refresh();
  this.child("tdbResProductos").refresh();
  this.child("tdbProductos").refresh();
}

function artesG_editarTarea()
{
  var curTareas: FLSqlCursor = this.child("tdbResTareas").cursor();
  if (!curTareas) {
    return false;
  }
  var idTarea: String = curTareas.valueBuffer("idtarea");
  if (!idTarea || idTarea == "") {
    return false;
  }
  if (!this.iface.curTareaLP) {
    this.iface.curTareaLP = new FLSqlCursor("tareaslp");
  }
  disconnect(this.iface.curTareaLP, "bufferCommited()", this, "iface.resTareas_bufferCommited");

  connect(this.iface.curTareaLP, "bufferCommited()", this, "iface.resTareas_bufferCommited");
  this.iface.curTareaLP.select("idtarea = " + idTarea);
  if (!this.iface.curTareaLP.first()) {
    return false;
  }
  this.iface.curTareaLP.editRecord();
}

function artesG_editarConsumo()
{
  var curConsumos: FLSqlCursor = this.child("tdbResConsumos").cursor();
  var idConsumo: String = curConsumos.valueBuffer("idconsumo");
  if (!idConsumo || idConsumo == "") {
    return false;
  }
  if (!this.iface.curConsumoLP) {
    this.iface.curConsumoLP = new FLSqlCursor("consumoslp");
  }
  disconnect(this.iface.curConsumoLP, "bufferCommited()", this, "iface.resConsumos_bufferCommited");

  connect(this.iface.curConsumoLP, "bufferCommited()", this, "iface.resConsumos_bufferCommited");
  this.iface.curConsumoLP.select("idconsumo = " + idConsumo);
  if (!this.iface.curConsumoLP.first()) {
    return false;
  }
  this.iface.curConsumoLP.editRecord();
}

function artesG_tdbResProductos_newBuffer()
{
  var util: FLUtil = new FLUtil;
  var curProducto: FLSqlCursor = this.child("tdbResProductos").cursor();
  var idProducto: String = curProducto.valueBuffer("idproducto");
  var refProducto: String = curProducto.valueBuffer("referencia");
  var idTipoProceso: String = util.sqlSelect("articulos", "idtipoproceso", "referencia = '" + refProducto + "'");
  switch (idTipoProceso) {
    case "TRIP": {
      this.iface.mostrarPrecorte(curProducto);
      this.iface.cargarPlanchas(idProducto);
      break;
    }
    case "TACO": {
      this.iface.mostrarPrecorte(curProducto);
      this.iface.cargarPlanchas(idProducto);
      break;
    }
    default: {
      this.iface.borrarDiagramas();
      break;
    }
  }
}

function artesG_mostrarPrecorte(curProducto: FLSqlCursor): Boolean {
  var util: FLUtil = new FLUtil;

  var idProducto: String = curProducto.valueBuffer("idproducto");
  var refProducto: String = curProducto.valueBuffer("referencia");

  var contenidoXMLIt: String = util.sqlSelect("itinerarioslp", "xmlparametros", "idproducto = " + idProducto + " AND escogido = true");
  if (!contenidoXMLIt)
  {
    return false;
  }
  var xmlItinerario: FLDomDocument = new FLDomDocument;
  if (!xmlItinerario.setContent(contenidoXMLIt))
  {
    return false;
  }
  var dimPliego: String;
  switch (refProducto)
  {
    case "TACO": {
      dimPliego = flfacturac.iface.pub_dameAtributoXML(xmlItinerario.firstChild(), "Parametros/PapelParam@AreaPliego");
      break;
    }
    default: {
      dimPliego = flfacturac.iface.pub_dameAtributoXML(xmlItinerario.firstChild(), "Parametros/PliegoParam@AreaPliego");
    }
  }
  var xmlPliegoImpresionParam: FLDomNode = flfacturac.iface.pub_dameNodoXML(xmlItinerario.firstChild(), "Parametros/PliegoImpresionParam");
  if (!xmlPliegoImpresionParam)
  {
    return false;
  }

  flfacturac.iface.pub_mostrarPrecorte(this.child("lblDiagPrecorte"), xmlPliegoImpresionParam, dimPliego);

  return true;
}

function artesG_cargarPlanchas(idProducto: String): Boolean {
  var util: FLUtil = new FLUtil;
  var contenidoXMLIt: String = util.sqlSelect("itinerarioslp", "xmlparametros", "idproducto = " + idProducto + " AND escogido = true");
  if (!contenidoXMLIt)
  {
    return false;
  }
  if (this.iface.xmlItinerarioRes)
  {
    delete this.iface.xmlItinerarioRes;
  }
  this.iface.xmlItinerarioRes = new FLDomDocument;
  debug("contenidoXMLIt" + contenidoXMLIt);
  if (!this.iface.xmlItinerarioRes.setContent(contenidoXMLIt))
  {
    debug("Falló setContent");
    return false;
  }

  this.iface.iPlanchaRes = 0;
  this.iface.tbnDistPlancha_clicked();

  return true;
}

function artesG_tbnDistPlancha_clicked()
{
  var util: FLUtil = new FLUtil;

  var xmlDistPlancha: FLDomNode = flfacturac.iface.pub_dameNodoXML(this.iface.xmlItinerarioRes.firstChild(), "Parametros/DistPlanchaParam");
  if (!xmlDistPlancha) {
    return;
  }

  var xmlPlanchas: FLDomNodeList = xmlDistPlancha.toElement().elementsByTagName("Plancha");

  if (!xmlPlanchas.item(this.iface.iPlanchaRes)) {
    this.iface.iPlanchaRes = 0;
  }

  var ePlancha: FLDomElement = xmlPlanchas.item(this.iface.iPlanchaRes).toElement();
  var juego: String = ePlancha.attribute("Juego");
  var texto: String = util.translate("scripts", "Juego %1. Planchas ").arg(juego);
  var numPasadas: String = ePlancha.attribute("NumPasadas");

  var hayComa: Boolean = false;
  while (ePlancha.attribute("Juego") == juego) {
    if (hayComa) {
      texto += ", ";
    }
    texto += ePlancha.attribute("Numero") + "(" + ePlancha.attribute("Color") + ") "
             this.iface.iPlanchaRes++;
    if (!xmlPlanchas.item(this.iface.iPlanchaRes)) {
      break;
    }
    ePlancha = xmlPlanchas.item(this.iface.iPlanchaRes).toElement();
    hayComa = true;
  }
  texto += util.translate("scripts", "\n%1 pasadas.").arg(numPasadas);
  this.child("lblDistPlancha").text = texto;

  var lblPix: Object = this.child("lblDiagDistPlancha");
  formRecorditinerarioslp.iface.pub_mostrarDistPlanchas(xmlPlanchas.item(this.iface.iPlanchaRes - 1), this.iface.xmlItinerarioRes, lblPix);

  return true;
}

function artesG_borrarDiagramas()
{
  var dimPix: Array = [];
  dimPix.x = 100;
  dimPix.y = 100;

  var svg: String = "<svg/>";
  var lblPix: Object = this.child("lblDiagDistPlancha");
  flfacturac.iface.pub_mostrarSVG(lblPix, svg, dimPix);
  lblPix = this.child("lblDiagPrecorte");
  flfacturac.iface.pub_mostrarSVG(lblPix, svg, dimPix);
  return true;
}

function artesG_tbnInsertarProducto_clicked()
{
  var util: FLUtil = new FLUtil();
  var cursor: FLSqlCursor = this.cursor();

  var f = new FLFormSearchDB("articulos");
  var curArticulos: FLSqlCursor = f.cursor();

  curArticulos.setMainFilter("referencia IN ('ENVIO', 'TAREA_MANUAL', 'IPTICO', 'LIBRO')");
  f.setMainWidget();

  var referencia: String = f.exec("referencia");
  if (!referencia) {
    return;
  }
  var accion: String;
  switch (referencia) {
    case "ENVIO": {
      accion = "paramenvio";
      break;
    }
    case "TAREA_MANUAL": {
      accion = "paramtareamanual";
      break;
    }
    case "IPTICO": {
      accion = "paramiptico";
      break;
    }
    case "LIBRO": {
      accion = "paramlibro";
      break;
    }
    default: {
      return;
    }
  }
  var idLinea: String = cursor.valueBuffer("idlinea");
  var curProducto: FLSqlCursor = new FLSqlCursor("productoslp");
  curProducto.setModeAccess(curProducto.Insert);
  curProducto.refreshBuffer();
  curProducto.setValueBuffer("idlinea", idLinea);
  curProducto.setValueBuffer("referencia", referencia);
  curProducto.setValueBuffer("descripcion", util.sqlSelect("articulos", "descripcion", "referencia = '" + referencia + "'"));
  if (!curProducto.commitBuffer()) {
    return false;
  }
  var idProducto: String = curProducto.valueBuffer("idproducto");

  this.iface.curParametros = new FLSqlCursor(accion);
  this.iface.curParametros.setModeAccess(this.iface.curParametros.Insert);
  this.iface.curParametros.refreshBuffer();
  this.iface.curParametros.setValueBuffer("idproducto", idProducto);
  switch (referencia) {
    case "ENVIO": {
      this.iface.curParametros.setValueBuffer("numcopias", 0);
      this.iface.curParametros.setValueBuffer("direccion", "");
      break;
    }
  }
  if (!this.iface.curParametros.commitBuffer()) {
    return false;
  }
  this.iface.curParametros.select("idproducto = " + idProducto);
  if (!this.iface.curParametros.first()) {
    return false;
  }
  connect(this.iface.curParametros, "bufferCommited()", this, "iface.refrescarProductos");
  this.iface.curParametros.editRecord();
}

/** \D Comprueba si el problema a resolver (nodo Parametros) está ya resuelto en la tabla de caché
@param xmlDocValoresParam: Doc. XML de parámetros.
@return Cadena que contiene el nodo XML de parámetros resuelto.
\end */
function artesG_buscarCache(xmlDocValoresParam: FLDomDocument): String {
  var util: FLUtil = new FLUtil;
  var problema: String = xmlDocValoresParam.toString();
  var sha: String = util.sha1(problema);
  var curCache: FLSqlCursor = new FLSqlCursor("cachetrabajos");
  curCache.select("id = '" + sha + "'");
  if (!curCache.first())
  {
    return false;
  }
  curCache.setModeAccess(curCache.Edit);
  curCache.refreshBuffer();
  var solucion: String = curCache.valueBuffer("solucion");
  var usos: Number = parseInt(curCache.valueBuffer("usos"));
  usos++;
  curCache.setValueBuffer("usos", usos);
  curCache.commitBuffer();
  return solucion;
}

/** \D Calcula el número de pliegos de impresión. Si la tarea de planchas está activa, lo saca de la distribución. Si no lo está lo calcula como el número de trabajos partido por el número de trabajos por pliego de impresión
@param  xmlProceso: Nodo del íptico calculado
\end */
function artesG_pliegosImpresionIptico(xmlProceso: FLDomNode): Number {
  var numPliegos: Number;
  var totalPaginas: Number = flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/PaginasParam@Total");
  var trabajosPI: Number = flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/TrabajosPliegoParam@NumTrabajos");
  var saltarPlanchas: Boolean = (flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros@SaltarPlanchas") == "true");
  if (saltarPlanchas)
  {
    numPliegos = Math.ceil(totalPaginas / trabajosPI);
  } else {
    numPliegos = parseInt(flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/DistPlanchaParam@NumPliegos"));
  }
  return numPliegos;
}

//// ARTES GRÁFICAS /////////////////////////////////////////////
////////////////////////////////////////////////////////////////

