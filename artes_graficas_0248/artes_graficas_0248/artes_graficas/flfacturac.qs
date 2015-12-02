
/** @class_declaration artesG */
/////////////////////////////////////////////////////////////////
//// ARTES GRÁFICAS /////////////////////////////////////////////
class artesG extends prod
{
  var minPliegoImpresion_: String;
  var maxPliegoImpresion_: String;
  var xMaxTPI_: Number;
  var yMaxTPI_: Number;
  function artesG(context)
  {
    prod(context);
  }
  function divisionesPliego(areaTrabajo: String, areaPliego: String, codImpresora: String): String {
    return this.ctx.artesG_divisionesPliego(areaTrabajo, areaPliego, codImpresora);
  }
  function trabajosXPliego(xmlProceso: FLDomNode): FLDomNode {
    return this.ctx.artesG_trabajosXPliego(xmlProceso);
  }
  function trabajosXPliegoSim(xmlProceso: FLDomNode): FLDomNode {
    return this.ctx.artesG_trabajosXPliegoSim(xmlProceso);
  }
  function colocarTrabajo(nodoTP: FLDomNode, xmlProceso: FLDomNode, xP: Number, yP: Number, xT: Number, yT: Number, xOff: Number, yOff: Number): String {
    return this.ctx.artesG_colocarTrabajo(nodoTP, xmlProceso, xP, yP, xT, yT, xOff, yOff);
  }
  //  function colocarTrabajoNxM(nodoTP:FLDomNode, xmlProceso:FLDomNode, xP:Number, yP:Number, xT:Number, yT:Number, xOff:Number, yOff:Number):String {
  //    return this.ctx.artesG_colocarTrabajoNxM(nodoTP, xmlProceso, xP, yP, xT, yT, xOff, yOff);
  //  }
  function distribuirTrabajosV(nodoTP: FLDomNode, xT: Number, yT: Number, yP: Number, xOff: Number, yOff: Number): String {
    return this.ctx.artesG_distribuirTrabajosV(nodoTP, xT, yT, yP, xOff, yOff);
  }
  function distribuirTrabajosH(nodoTP: FLDomNode, xT: Number, yT: Number, xP: Number, xOff: Number, yOff: Number): String {
    return this.ctx.artesG_distribuirTrabajosH(nodoTP, xT, yT, xP, xOff, yOff);
  }
  function distribuirTrabajosHV(nodoTP: FLDomNode, xT: Number, yT: Number, xP: Number, yP: Number, xOff: Number, yOff: Number): String {
    return this.ctx.artesG_distribuirTrabajosHV(nodoTP, xT, yT, xP, yP, xOff, yOff);
  }
  function dameAtributoXML(nodoPadre: FLDomNode, ruta: String, debeExistir: Boolean): String {
    return this.ctx.artesG_dameAtributoXML(nodoPadre, ruta, debeExistir);
  }
  function dameNodoXML(nodoPadre: FLDomNode, ruta: String, debeExistir: Boolean): FLDomNode {
    return this.ctx.artesG_dameNodoXML(nodoPadre, ruta, debeExistir);
  }
  function centrarTrabajosPliego(nodoTP: FLDomNode, xP: Number, yP: Number)
  {
    return this.ctx.artesG_centrarTrabajosPliego(nodoTP, xP, yP);
  }
  function formatearTrabajosPliego(xmlProceso: FLDomNode, xmlNodoTP: FLDomNode): Boolean {
    return this.ctx.artesG_formatearTrabajosPliego(xmlProceso, xmlNodoTP);
  }
  function areaTrabajoConSangria(xmlProceso: FLDomNode): Array {
    return this.ctx.artesG_areaTrabajoConSangria(xmlProceso);
  }
  function areaTrabajoSinSangria(xmlProceso: FLDomNode): Array {
    return this.ctx.artesG_areaTrabajoSinSangria(xmlProceso);
  }
  function areaPIConPinzas(xmlProceso: FLDomNode, ejeSimetria: String): Array {
    return this.ctx.artesG_areaPIConPinzas(xmlProceso, ejeSimetria);
  }
  function generarSimetricos(nodoPliegosVar: FLDomNode, ejeSim: String, areaPliego: Array): Boolean {
    return this.ctx.artesG_generarSimetricos(nodoPliegosVar, ejeSim, areaPliego);
  }
  function mostrarParamIptico(nodoParam: FLDomNode): FLDomNode {
    return this.ctx.artesG_mostrarParamIptico(nodoParam);
  }
  function mostrarParamColor(nodoColor: FLDomNode): FLDomNode {
    return this.ctx.artesG_mostrarParamColor(nodoColor);
  }
  function mostrarPrecorte(lblPix: Object, xmlPrecorte: FLDomNode, dimPliego: String): Boolean {
    return this.ctx.artesG_mostrarPrecorte(lblPix, xmlPrecorte, dimPliego);
  }
  function mostrarTrabajosPliego(lblPix: Object, xmlParametros: FLDomNode, dimPliegoImpresion: String, dimPix: Array): Boolean {
    return this.ctx.artesG_mostrarTrabajosPliego(lblPix, xmlParametros, dimPliegoImpresion, dimPix);
  }
  function dameParamCentroCoste(nombre: String): FLDomNode {
    return this.ctx.artesG_dameParamCentroCoste(nombre);
  }
  function entraEnArea(sAreaContenido: String, sAreaContinente: String): Boolean {
    return this.ctx.artesG_entraEnArea(sAreaContenido, sAreaContinente);
  }
  function dameVectorPos(posicion: String): Array {
    return this.ctx.artesG_dameVectorPos(posicion);
  }
  function rotar90(vector: Array): Array {
    return this.ctx.artesG_rotar90(vector);
  }
  function aplicarMatriz(vector: Array, matriz: Array): Array {
    return this.ctx.artesG_aplicarMatriz(vector, matriz);
  }
  function dameCorte(x1: Number, y1: Number, x2: Number, y2: Number): String {
    return this.ctx.artesG_dameCorte(x1, y1, x2, y2);
  }
  //  function dameTrabajo(x:Number, y:Number, w:Number, h:Number):String {
  //    return this.ctx.artesG_dameTrabajo(x, y, w, h);
  //  }
  function dameTrabajo(x: Number, y: Number, w: Number, h: Number, sangrias: Array, alineado: Boolean): String {
    return this.ctx.artesG_dameTrabajo(x, y, w, h, sangrias, alineado);
  }
  function tiraRetiraPosible(xmlProceso: FLDomNode): Boolean {
    return this.ctx.artesG_tiraRetiraPosible(xmlProceso);
  }
  //  function opcionesImpresoraEstilo(xmlProceso:FLDomNode):Boolean {
  //    return this.ctx.artesG_opcionesImpresoraEstilo(xmlProceso);
  //  }
  function valoresVariante(nombreVariante: String, xmlProceso: FLDomNode): FLDomNodeList {
    return this.ctx.artesG_valoresVariante(nombreVariante, xmlProceso);
  }
  function opcionesPliego(xmlProceso: FLDomNode): FLDomNode {
    return this.ctx.artesG_opcionesPliego(xmlProceso);
  }
  function opcionesPliegoImpresion(xmlProceso: FLDomNode): FLDomNode {
    return this.ctx.artesG_opcionesPliegoImpresion(xmlProceso);
  }
  function opcionesEstiloImpresion(xmlProceso: FLDomNode): FLDomNode {
    return this.ctx.artesG_opcionesEstiloImpresion(xmlProceso);
  }
  function opcionesTipoimpresora(xmlProceso: FLDomNode): FLDomNode {
    return this.ctx.artesG_opcionesTipoimpresora(xmlProceso);
  }
  function opcionesTipoPlastificadora(xmlProceso: FLDomNode): FLDomNode {
    return this.ctx.artesG_opcionesTipoPlastificadora(xmlProceso);
  }
  function opcionesTipoPlegadora(xmlProceso: FLDomNode): FLDomNode {
    return this.ctx.artesG_opcionesTipoPlegadora(xmlProceso);
  }
  function opcionesTipoTroqueladora(xmlProceso: FLDomNode): FLDomNode {
    return this.ctx.artesG_opcionesTipoTroqueladora(xmlProceso);
  }
  function opcionesTipoPeladora(xmlProceso: FLDomNode): FLDomNode {
    return this.ctx.artesG_opcionesTipoPeladora(xmlProceso);
  }
  function opcionesTrabajosPliego(xmlProceso: FLDomNode): FLDomNode {
    return this.ctx.artesG_opcionesTrabajosPliego(xmlProceso);
  }
  function opcionesDistPlanchas(xmlProceso: FLDomNode): FLDomNode {
    return this.ctx.artesG_opcionesDistPlanchas(xmlProceso);
  }
  function opcionesTipoGrapadora(xmlProceso: FLDomNode): FLDomNode {
    return this.ctx.artesG_opcionesTipoGrapadora(xmlProceso);
  }
  function opcionesTipoEGC(xmlProceso: FLDomNode): FLDomNode {
    return this.ctx.artesG_opcionesTipoEGC(xmlProceso);
  }
  function opcionesTipoAlzadora(xmlProceso: FLDomNode): FLDomNode {
    return this.ctx.artesG_opcionesTipoAlzadora(xmlProceso);
  }
  function distribuirPlanchas(xmlProceso: FLDomNode, planchasExtra: Number): FLDomNode {
    return this.ctx.artesG_distribuirPlanchas(xmlProceso, planchasExtra);
  }
  function nombrePagina(indice: Number, frente: Boolean, numeros: Boolean): String {
    return this.ctx.artesG_nombrePagina(indice, frente, numeros);
  }
  function calcularPasadasPorPlancha(xmlOpcion: FLDomNode, xmlProceso: FLDomNode): Boolean {
    return this.ctx.artesG_calcularPasadasPorPlancha(xmlOpcion, xmlProceso);
  }
  function dameRepeticionesEnPlancha(xmlPlancha: FLDomNode): Number {
    return this.ctx.artesG_dameRepeticionesEnPlancha(xmlPlancha);
  }
  function trabajosPorPliego(xmlProceso: FLDomNode, areaTrabajo: String, areaPliego: String, anchoPinza: Number): String {
    return this.ctx.artesG_trabajosPorPliego(xmlProceso, areaTrabajo, areaPliego, anchoPinza);
  }
  function ponXmlParametroProceso(xmlProceso: FLDomNode, xmlParametro: FLDomNode): Boolean {
    return this.ctx.artesG_ponXmlParametroProceso(xmlProceso, xmlParametro);
  }
  function ponXmlSiguientesTareas(xmlProceso: FLDomNode, xmlST: FLDomNode): Boolean {
    return this.ctx.artesG_ponXmlSiguientesTareas(xmlProceso, xmlST);
  }
  function nodoXMLPinza(xmlProceso: FLDomNode): String {
    return this.ctx.artesG_nodoXMLPinza(xmlProceso);
  }
  function planchasPorColor(xmlOpcion: FLDomNode, xmlProceso: FLDomNode): FLDomNode {
    return this.ctx.artesG_planchasPorColor(xmlOpcion, xmlProceso);
  }
  function anadirOtraCara(xmlOpcionDist: FLDomNode): Boolean {
    return this.ctx.artesG_anadirOtraCara(xmlOpcionDist);
  }
  function distCaraVuelta(distribucion: String): String {
    return this.ctx.artesG_distCaraVuelta(distribucion);
  }
  function nombreCaraVuelta(nombrePagina: String): String {
    return this.ctx.artesG_nombreCaraVuelta(nombrePagina);
  }
  function distSimetrica(distribucion: String, ejeSim: String): String {
    return this.ctx.artesG_distSimetrica(distribucion, ejeSim);
  }
  function anadirSimetrica(xmlOpcionDist: FLDomNode, ejeSim: String): Boolean {
    return this.ctx.artesG_anadirSimetrica(xmlOpcionDist, ejeSim);
  }
  function mostrarSVG(lblPix: Object, svg: String, dimPix: Array): Boolean {
    return this.ctx.artesG_mostrarSVG(lblPix, svg, dimPix);
  }
  function crearNodoHijo(nodoPadre: FLDomNode, textoNodoHijo: String): Boolean {
    return this.ctx.artesG_crearNodoHijo(nodoPadre, textoNodoHijo);
  }
  function svgPinzas(xmlProceso: FLDomNode, dimPix: Array): String {
    return this.ctx.artesG_svgPinzas(xmlProceso, dimPix);
  }
  function validarPinzas(xmlProceso: FLDomNode): Boolean {
    return this.ctx.artesG_validarPinzas(xmlProceso);
  }
  function validarImpresora(xmlParamPliego: FLDomNode, xmlParamImpresora: FLDomNode): String {
    return this.ctx.artesG_validarImpresora(xmlParamPliego, xmlParamImpresora);
  }
  function crearNodoHijoVacio(nodoPadre: FLDomNode, nombreHijo: String): FLDomNode {
    return this.ctx.artesG_crearNodoHijoVacio(nodoPadre, nombreHijo);
  }
  function esPantone(color: String): Boolean {
    return this.ctx.artesG_esPantone(color);
  }
  function afterCommit_paramlibro(curPL: FLSqlCursor): Boolean {
    return this.ctx.artesG_afterCommit_paramlibro(curPL);
  }
  function afterCommit_paramiptico(curPL: FLSqlCursor): Boolean {
    return this.ctx.artesG_afterCommit_paramiptico(curPL);
  }
  function afterCommit_paramtaco(curPT: FLSqlCursor): Boolean {
    return this.ctx.artesG_afterCommit_paramtaco(curPT);
  }
  function afterCommit_paramtareamanual(curPTM: FLSqlCursor): Boolean {
    return this.ctx.artesG_afterCommit_paramtareamanual(curPTM);
  }
  function afterCommit_paramenvio(curPE: FLSqlCursor): Boolean {
    return this.ctx.artesG_afterCommit_paramenvio(curPE);
  }
  function actualizarDescripcionProducto(curParam: FLSqlCursor): Boolean {
    return this.ctx.artesG_actualizarDescripcionProducto(curParam);
  }
  function crearParamPaginas(curPL: FLSqlCursor): Boolean {
    return this.ctx.artesG_crearParamPaginas(curPL);
  }
  function seleccionarOpcionProductos(idLinea: String): Boolean {
    return this.ctx.artesG_seleccionarOpcionProductos(idLinea);
  }
  function regenerarIptico(curPI: FLSqlCursor): Boolean {
    return this.ctx.artesG_regenerarIptico(curPI);
  }
  function regenerarTaco(curPT: FLSqlCursor): Boolean {
    return this.ctx.artesG_regenerarTaco(curPT);
  }
  function regenerarPaginasLibro(curPL: FLSqlCursor): Boolean {
    return this.ctx.artesG_regenerarPaginasLibro(curPL);
  }
  //  function regenerarEnvioLibro(curPL:FLSqlCursor):Boolean {
  //    return this.ctx.artesG_regenerarEnvioLibro(curPL);
  //  }
  function regenerarEnvioProducto(curPI: FLSqlCursor): Boolean {
    return this.ctx.artesG_regenerarEnvioProducto(curPI);
  }
  //  function regenerarTMProducto(curParam:FLSqlCursor):Boolean {
  //    return this.ctx.artesG_regenerarTMProducto(curParam);
  //  }
  function regenerarTapaLibro(curPL: FLSqlCursor): Boolean {
    return this.ctx.artesG_regenerarTapaLibro(curPL);
  }
  //  function regenerarTMLibro(curPL:FLSqlCursor):Boolean {
  //    return this.ctx.artesG_regenerarTMLibro(curPL);
  //  }
  function regenerarEncuadernacion(curPL: FLSqlCursor): Boolean {
    return this.ctx.artesG_regenerarEncuadernacion(curPL);
  }
  //  function distribuirModelosDC(xmlProceso:FLDomNode, numPlanchas:Number, trabPlancha:Number):Array {
  //    return this.ctx.artesG_distribuirModelosDC(xmlProceso, numPlanchas, trabPlancha);
  //  }
  function dameArrayDist(xmlProceso: FLDomNode): Array {
    return this.ctx.artesG_dameArrayDist(xmlProceso);
  }
  function dameArrayDistPlanchas(arrayDist: Array, numPlanchas: Number): Array {
    return this.ctx.artesG_dameArrayDistPlanchas(arrayDist, numPlanchas);
  }
  function resolverDistribucionDC(cantidades: Array, numTrabajosPlancha: Number, rellenar: Boolean): Array {
    return this.ctx.artesG_resolverDistribucionDC(cantidades, numTrabajosPlancha, rellenar);
  }
  function opcionesSiguienteTarea(xmlProceso: FLDomNode): FLDomNode {
    return this.ctx.artesG_opcionesSiguienteTarea(xmlProceso);
  }
  function compatibleTareaProceso(xmlProceso: FLDomNode, idTipoTareaSiguiente: String): Boolean {
    return this.ctx.artesG_compatibleTareaProceso(xmlProceso, idTipoTareaSiguiente);
  }
  function regenerarProcesosIptico(curPI: FLSqlCursor): Boolean {
    return this.ctx.artesG_regenerarProcesosIptico(curPI);
  }
  function regenerarProcesosTaco(curPT: FLSqlCursor): Boolean {
    return this.ctx.artesG_regenerarProcesosTaco(curPT);
  }
  function regenerarProcesosLibro(curPL: FLSqlCursor): Boolean {
    return this.ctx.artesG_regenerarProcesosLibro(curPL);
  }
  function opcionesTipoGuillotinaPA(xmlProceso: FLDomNode): FLDomNode {
    return this.ctx.artesG_opcionesTipoGuillotinaPA(xmlProceso);
  }
  function opcionesTipoGuillotinaPWO(xmlProceso: FLDomNode): FLDomNode {
    return this.ctx.artesG_opcionesTipoGuillotinaPWO(xmlProceso);
  }
  function opcionesTipoGuillotinaPOSWO(xmlProceso: FLDomNode): FLDomNode {
    return this.ctx.artesG_opcionesTipoGuillotinaPOSWO(xmlProceso);
  }
  function opcionesTipoGuillotinaTri(xmlProceso: FLDomNode): FLDomNode {
    return this.ctx.artesG_opcionesTipoGuillotinaTri(xmlProceso);
  }
  function opcionesGuillotina(nombre: String, alto: Number, ancho: Number): FLDomNode {
    return this.ctx.artesG_opcionesGuillotina(nombre, alto, ancho);
  }
  function opcionesTipoMaquinaWireO(xmlProceso: FLDomNode): FLDomNode {
    return this.ctx.artesG_opcionesTipoMaquinaWireO(xmlProceso);
  }
  function opcionesTipoEncuadernadora(xmlProceso: FLDomNode): FLDomNode {
    return this.ctx.artesG_opcionesTipoEncuadernadora(xmlProceso);
  }
  function opcionesAgenciaTransporte(xmlProceso: FLDomNode): FLDomNode {
    return this.ctx.artesG_opcionesAgenciaTransporte(xmlProceso);
  }
  function contieneColor(arrayColores: Array, color: String): Number {
    return this.ctx.artesG_contieneColor(arrayColores, color);
  }
  function svnPaginasTrabajo(x: Number, y: Number, w: Number, h: Number, distPaginasTrabajo: String, apaisado: Boolean): String {
    return this.ctx.artesG_svnPaginasTrabajo(x, y, w, h, distPaginasTrabajo, apaisado);
  }
  function troqueladoSimetrico(xmlProceso: FLDomNode): Boolean {
    return this.ctx.artesG_troqueladoSimetrico(xmlProceso);
  }
  function obtenerCombiModeloPlancha(numModelos: Number, numPlanchas: Number, prefijo: String, tope: Number): Array {
    return this.ctx.artesG_obtenerCombiModeloPlancha(numModelos, numPlanchas, prefijo, tope);
  }
  function dameArrayCombiModelos(numModelos: Number): Array {
    return this.ctx.artesG_dameArrayCombiModelos(numModelos);
  }
  function combiModelos(combi: Array): Array {
    return this.ctx.artesG_combiModelos(combi);
  }
  function copiarArrayCombi(combi: Array, iExcepcion: Number): Array {
    return this.ctx.artesG_copiarArrayCombi(combi, iExcepcion);
  }
  function distOptimaModelosPlanchas(nodoPaginas: FLDomNode, numPlanchas: Number, numTrabajosPlancha: Number): Array {
    return this.ctx.artesG_distOptimaModelosPlanchas(nodoPaginas, numPlanchas, numTrabajosPlancha);
  }
  function evaluarCombiModelo(combiModeloPlancha: String, arrayCombiModelos: Array, cantidadesModelo: Array, numTrabajosPlancha: Number): Array {
    return this.ctx.artesG_evaluarCombiModelo(combiModeloPlancha, arrayCombiModelos, cantidadesModelo, numTrabajosPlancha);
  }
  function calcularCombiPlancha(numModeloPlancha: Array, numTrabajosPlancha: Number): Array {
    return this.ctx.artesG_calcularCombiPlancha(numModeloPlancha, numTrabajosPlancha);
  }
  function afterCommit_tareaslp(curTarea: FLSqlCursor): Boolean {
    return this.ctx.artesG_afterCommit_tareaslp(curTarea);
  }
  function afterCommit_consumoslp(curConsumo: FLSqlCursor): Boolean {
    return this.ctx.artesG_afterCommit_consumoslp(curConsumo);
  }
  function guardarCache(xmlDocValoresParam: FLDomDocument, idProducto: String, tipoParam: String, idParam: String): Boolean {
    return this.ctx.artesG_guardarCache(xmlDocValoresParam, idProducto, tipoParam, idParam);
  }
  function beforeCommit_productoslp(curProd: FLSqlCursor): Boolean {
    return this.ctx.artesG_beforeCommit_productoslp(curProd);
  }
  function borrarElementosProducto(curProd: FLSqlCursor): Boolean {
    return this.ctx.artesG_borrarElementosProducto(curProd);
  }
  function beforeCommit_itinerarioslp(curIt: FLSqlCursor): Boolean {
    return this.ctx.artesG_beforeCommit_itinerarioslp(curIt);
  }
  function borrarElementosItinerario(curIt: FLSqlCursor): Boolean {
    return this.ctx.artesG_borrarElementosItinerario(curIt);
  }
}
//// ARTES GRÁFICAS /////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pubArtesG */
/////////////////////////////////////////////////////////////////
//// ARTES GRÁFICAS /////////////////////////////////////////////
class pubArtesG extends ifaceCtx
{
  function pubArtesG(context)
  {
    ifaceCtx(context);
  }
  function pub_divisionesPliego(areaTrabajo: String, areaPliego: String, codImpresora: String): String {
    return this.divisionesPliego(areaTrabajo, areaPliego, codImpresora);
  }
  function pub_dameAtributoXML(nodoPadre: FLDomNode, ruta: String, debeExistir: Boolean): String {
    return this.dameAtributoXML(nodoPadre, ruta, debeExistir);
  }
  function pub_dameNodoXML(nodoPadre: FLDomNode, ruta: String, debeExistir: Boolean): FLDomNode {
    return this.dameNodoXML(nodoPadre, ruta, debeExistir);
  }
  function pub_mostrarParamIptico(nodoParam: FLDomNode): FLDomNode {
    return this.mostrarParamIptico(nodoParam);
  }
  function pub_mostrarParamColor(nodoColor: FLDomNode): FLDomNode {
    return this.mostrarParamColor(nodoColor);
  }
  function pub_mostrarPrecorte(lblPix: Object, xmlPrecorte: FLDomNode, dimPliego: String): Boolean {
    return this.mostrarPrecorte(lblPix, xmlPrecorte, dimPliego);
  }
  function pub_mostrarTrabajosPliego(lblPix: Object, xmlParametros: FLDomNode, dimPliegoImpresion: String, dimPix: Array): Boolean {
    return this.mostrarTrabajosPliego(lblPix, xmlParametros, dimPliegoImpresion, dimPix);
  }
  function pub_dameParamCentroCoste(nombre: String): FLDomNode {
    return this.dameParamCentroCoste(nombre);
  }
  function pub_entraEnArea(sAreaContenido: String, sAreaContinente: String): Boolean {
    return this.entraEnArea(sAreaContenido, sAreaContinente);
  }
  function pub_tiraRetiraPosible(xmlProceso: FLDomNode): Boolean {
    return this.tiraRetiraPosible(xmlProceso);
  }
  function pub_areaTrabajoConSangria(xmlProceso: FLDomNode): Array {
    return this.areaTrabajoConSangria(xmlProceso);
  }
  function pub_valoresVariante(nombreVariante: String, xmlProceso: FLDomNode): FLDomNodeList {
    return this.valoresVariante(nombreVariante, xmlProceso);
  }
  function pub_opcionesPliego(xmlProceso: FLDomNode): FLDomNode {
    return this.opcionesPliego(xmlProceso);
  }
  function pub_opcionesPliegoImpresion(xmlProceso: FLDomNode): FLDomNode {
    return this.opcionesPliegoImpresion(xmlProceso);
  }
  function pub_opcionesEstiloImpresion(xmlProceso: FLDomNode): FLDomNode {
    return this.opcionesEstiloImpresion(xmlProceso);
  }
  function pub_opcionesTipoPlastificadora(xmlProceso: FLDomNode): FLDomNode {
    return this.opcionesTipoPlastificadora(xmlProceso);
  }
  function pub_opcionesTipoPlegadora(xmlProceso: FLDomNode): FLDomNode {
    return this.opcionesTipoPlegadora(xmlProceso);
  }
  function pub_opcionesTrabajosPliego(xmlProceso: FLDomNode): FLDomNode {
    return this.opcionesTrabajosPliego(xmlProceso);
  }
  function pub_opcionesDistPlanchas(xmlProceso: FLDomNode): FLDomNode {
    return this.opcionesDistPlanchas(xmlProceso);
  }
  function pub_ponXmlParametroProceso(xmlProceso: FLDomNode, xmlParametro: FLDomNode): Boolean {
    return this.ponXmlParametroProceso(xmlProceso, xmlParametro);
  }
  function pub_ponXmlSiguientesTareas(xmlProceso: FLDomNode, xmlST: FLDomNode): Boolean {
    return this.ponXmlSiguientesTareas(xmlProceso, xmlST);
  }
  function pub_mostrarSVG(lblPix: Object, svg: String, dimPix: Array): Boolean {
    return this.mostrarSVG(lblPix, svg, dimPix);
  }
  function pub_svgPinzas(xmlProceso: FLDomNode, dimPix: Array): String {
    return this.svgPinzas(xmlProceso, dimPix);
  }
  function pub_validarPinzas(xmlProceso: FLDomNode): Boolean {
    return this.validarPinzas(xmlProceso);
  }
  function pub_nodoXMLPinza(xmlProceso: FLDomNode): String {
    return this.nodoXMLPinza(xmlProceso);
  }
  function pub_validarImpresora(xmlParamPliego: FLDomNode, xmlParamImpresora: FLDomNode): String {
    return this.validarImpresora(xmlParamPliego, xmlParamImpresora);
  }
  function pub_crearNodoHijoVacio(nodoPadre: FLDomNode, nombreHijo: String): FLDomNode {
    return this.crearNodoHijoVacio(nodoPadre, nombreHijo);
  }
  function pub_seleccionarOpcionProductos(idLinea: String): Boolean {
    return this.seleccionarOpcionProductos(idLinea);
  }
  function pub_svnPaginasTrabajo(x: Number, y: Number, w: Number, h: Number, distPaginasTrabajo: String, apaisado: Boolean): String {
    return this.svnPaginasTrabajo(x, y, w, h, distPaginasTrabajo, apaisado);
  }
  function pub_troqueladoSimetrico(xmlProceso: FLDomNode): Boolean {
    return this.troqueladoSimetrico(xmlProceso);
  }
  function pub_guardarCache(xmlDocValoresParam: FLDomDocument, idProducto: String, tipoParam: String, idParam: String): Boolean {
    return this.guardarCache(xmlDocValoresParam, idProducto, tipoParam, idParam);
  }
}
const iface = new pubArtesG(this);
//// ARTES GRÁFICAS /////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition artesG */
/////////////////////////////////////////////////////////////////
//// ARTES GRÁFICAS /////////////////////////////////////////////
/** \C Genera una cadena con el texto de un nodo XML que contiene las posibles divisiones (cortes) de un pliego que pueden hacerse antes imprimir
@param  areaTrabajo: Área del trabajo
@param  areaPliego: Área del pliego original
@param  referencia: Referencia del pliego como artículo
@return Cadena con los parámetros XML de tipo PliegoImpresionParam
\end */
function artesG_divisionesPliego(areaTrabajo: String, areaPliego: String, codImpresora: String): String {
  var util: FLUtil = new FLUtil;
  var factorX: Number = 1;
  var factorY: Number = 1;
  var dimTrabajo: Array = areaTrabajo.split("x");
  var trabajoX: Number = parseFloat(dimTrabajo[0]);
  var trabajoY: Number = parseFloat(dimTrabajo[1]);
  var dimPliego: Array = areaPliego.split("x");
  var pliegoX: Number = parseFloat(dimPliego[0]);
  var pliegoY: Number = parseFloat(dimPliego[1]);

  var maxX: Number;
  var maxY: Number;
  var minX: Number;
  var minY: Number;
  if (!codImpresora)
  {
    var dimMaxima: Array = this.iface.maxPliegoImpresion_.split("x");
    maxX = parseFloat(dimMaxima[0]);
    maxY = parseFloat(dimMaxima[1]);
    var dimMinima: Array = this.iface.minPliegoImpresion_.split("x");
    minX = parseFloat(dimMinima[0]);
    minY = parseFloat(dimMinima[1]);
  } else {
    var xmlParamImpresora: FLDomNode = this.iface.dameParamCentroCoste(codImpresora);
    if (!xmlParamImpresora)
      return false;
    var eImpresora: FLDomElement = xmlParamImpresora.toElement();
    maxX = eImpresora.attribute("AnchoMax");
    maxY = eImpresora.attribute("AltoMax");
    minX = eImpresora.attribute("AnchoMin");
    minY = eImpresora.attribute("AltoMin");
  }

  var x: Number = pliegoX / factorX;
  var y: Number = pliegoY / factorY;

  var contenido: String = "";
  var detalle: String;
  while ((x >= minX || x >= minY) && (x >= trabajoX || x >= trabajoY))
  {
    while ((y >= minY || y >= minX) && (y >= trabajoX || y >= trabajoY)) {
      if (((x >= trabajoX && y >= trabajoY) || (x >= trabajoY && y >= trabajoX)) && ((x <= maxX && y <= maxY) || (x <= maxY && y <= maxX)) && ((x >= minX && y >= minY) || (x >= minY && y >= minX))) {

        factor = factorX * factorY;
        if (factor == 1) {
          detalle = util.translate("scripts", "Se usarán pliegos completos (sin precorte)");
        } else {
          detalle = util.translate("scripts", "Precorte según el esquema %3x%4. Los pliegos de impresión resultantes medirán %5x%6").arg(factorX).arg(factorY).arg(x).arg(y);
        }
        contenido += "\t<PliegoImpresionParam Valor=\"" + util.roundFieldValue(x, "articulos", "anchopliego") + "x" + util.roundFieldValue(y, "articulos", "anchopliego") + "\" Corte=\"" + factorX + "x" + factorY + "\" Factor=\"" + factor + "\" Detalle=\"" + detalle + "\"/>\n"
      }
                   factorY++;
      y = pliegoY / factorY;
    }
    factorY = 1;
    y = pliegoY / factorY;
    factorX++;
    x = pliegoX / factorX;
  }
  return contenido;
}

/** \C <br/> <i><b>POSIBLES DISTRIBUCIONES DE TRABAJOS EN PLIEGO DE IMPRESIÓN </b></i><br/>
De todas las posibles distribuciones de trabajos en el pliego de impresión se toma la que optimiza el papel y la mejor simétrica (para los Tira - Retira)<br/>
Parámetros necesarios:<br/>
AreaTrabajoParam<br/>
PliegoImpresionParam<br/>
Variantes obtenidas:<br/>
Nodos TrabajosPliego para todas las prensas posibles
@param  xmlProceso: Nodo XML del proceso
@param  valor: Nodo de opciones
\end */
function artesG_trabajosXPliego(xmlProceso: FLDomNode): FLDomNode {
  var areaTrabajo: Array = this.iface.areaTrabajoSinSangria(xmlProceso);
  var xT: Number = areaTrabajo.x;
  var yT: Number = areaTrabajo.y;

  //  if (!this.iface.opcionesImpresoraEstilo(xmlProceso))
  //    return false;

  var areaPliego: Array = this.iface.areaPIConPinzas(xmlProceso);
  var xP: Number = areaPliego.x;
  var yP: Number = areaPliego.y;

  var xOff: Number = 0;
  var yOff: Number = 0;

  //var trabajosPliego:String = "<TrabajosPliegoVar><TrabajosPliegoParam/></TrabajosPliegoVar>";
  var trabajosPliego: String = "<TrabajosPliegoVar></TrabajosPliegoVar>";
  var xmlTPDoc: FLDomDocument = new FLDomDocument();
  xmlTPDoc.setContent(trabajosPliego);

  //var nodoTP:FLDomNode = xmlTPDoc.firstChild().firstChild();
  var nodoTP: FLDomNode = xmlTPDoc.firstChild();

  if (!this.iface.colocarTrabajo(nodoTP, xmlProceso, xP, yP, xT, yT, xOff, yOff))
  {
    return false;
  }

  if (!this.iface.formatearTrabajosPliego(xmlProceso, xmlTPDoc.firstChild()))
    return false;

  return xmlTPDoc.firstChild();
}

/** \C <br/> <i><b>POSIBLES DISTRIBUCIONES SIMÉTRICAS DE TRABAJOS EN PLIEGO DE IMPRESIÓN </b></i><br/>
De todas las posibles distribuciones de trabajos en el pliego de impresión se toma la que optimiza el papel y la mejor simétrica (para los Tira - Retira)<br/>
Parámetros necesarios:<br/>
AreaTrabajoParam<br/>
PliegoImpresionParam<br/>
Variantes obtenidas:<br/>
Nodos TrabajosPliego para todas las prensas posibles
@param  xmlProceso: Nodo XML del proceso
@param  valor: Nodo de opciones
\end */
function artesG_trabajosXPliegoSim(xmlProceso: FLDomNode): FLDomNode {
  var areaTrabajo: Array = this.iface.areaTrabajoSinSangria(xmlProceso);
  var xT: Number = areaTrabajo.x;
  var yT: Number = areaTrabajo.y;

  //  var areaPliego:Array = this.iface.areaPIConPinzas(xmlProceso);
  var areaPliegoH: Array = this.iface.areaPIConPinzas(xmlProceso, "H");
  var xPH: Number = areaPliegoH.x;
  var yPH: Number = areaPliegoH.y;

  var areaPliegoV: Array = this.iface.areaPIConPinzas(xmlProceso, "V");
  var xPV: Number = areaPliegoV.x;
  var yPV: Number = areaPliegoV.y;

  var xOff: Number = 0;
  var yOff: Number = 0;

  var trabajosPliegoH: String = "<TrabajosPliegoVar></TrabajosPliegoVar>";

  var xmlTPDocH: FLDomDocument = new FLDomDocument();
  xmlTPDocH.setContent(trabajosPliegoH);

  var nodoTP: FLDomNode = xmlTPDocH.firstChild();
  if (!this.iface.colocarTrabajo(nodoTP, xmlProceso, xPH, (yPH / 2), xT, yT, xOff, yOff))
  {
    return false;
  }

  if (!this.iface.generarSimetricos(xmlTPDocH.firstChild(), "H", areaPliegoH))
  {
    return false;
  }

  var trabajosPliegoV: String = "<TrabajosPliegoVar></TrabajosPliegoVar>";

  var xmlTPDocV: FLDomDocument = new FLDomDocument();
  xmlTPDocV.setContent(trabajosPliegoV);

  nodoTP = xmlTPDocV.firstChild();
  if (!this.iface.colocarTrabajo(nodoTP, xmlProceso, (xPV / 2), yPV, xT, yT, xOff, yOff))
  {
    return false;
  }

  if (!this.iface.generarSimetricos(xmlTPDocV.firstChild(), "V", areaPliegoV))
  {
    return false;
  }

  for (nodoTP = xmlTPDocV.firstChild().firstChild(); nodoTP; nodoTP = nodoTP.nextSibling())
  {
    if (nodoTP.namedItem("Trabajo")) {
      xmlTPDocH.firstChild().appendChild(nodoTP.cloneNode());
    }
  }

  if (!this.iface.formatearTrabajosPliego(xmlProceso, xmlTPDocH.firstChild()))
    return false;
  // debug(xmlTPDocH.toString());
  return xmlTPDocH.firstChild();
}

function artesG_generarSimetricos(nodoPliegosVar: FLDomNode, ejeSim: String, areaPliego: Array): Boolean {
  // debug("GSim " + ejeSim);
  // var xmlDoc:FLDomDocument = new FLDomDocument;
  // xmlDoc.appendChild(nodoPliegosVar.cloneNode());
  // debug(xmlDoc.toString(4));

  var listaParam: FLDomNodeList = nodoPliegosVar.toElement().elementsByTagName("TrabajosPliegoParam");
  if (!listaParam)
  {
    //  debug("!listaParam");
    return true;
  }

  var xP: Number = areaPliego.x;
  var yP: Number = areaPliego.y;

  var listaElementos: FLDomNodeList;
  var nElemento: FLDomNode;
  var eElemento: FLDomElement;
  var totalElementos: Number;
  var nSimetrico: FLDomNode;
  var eSimetrico: FLDomElement;
  var y: Number;
  var x: Number;
  var w: Number;
  var h: Number;
  var x2: Number;
  var y2: Number;
  var dimMin: String;
  var areaMin: Array;
  var eTP: FLDomElement;
  var offsetX: Number;
  var offsetY: Number;
  for (var iPP: Number = 0; iPP < listaParam.length(); iPP++)
  {
    listaElementos = listaParam.item(iPP).childNodes();
    eTP = listaParam.item(iPP).toElement();
    eTP.setAttribute("EjeSim", ejeSim);
    areaMin = eTP.attribute("DimMin").split("x");
    if (ejeSim == "H") {
      offsetX = (xP - parseFloat(areaMin[0]));
      offsetY = ((yP / 2) - parseFloat(areaMin[1]));
    } else {
      offsetX = ((xP / 2) - parseFloat(areaMin[0]));
      offsetY = (yP - parseFloat(areaMin[1]));
    }
    /*debug("xP = " + xP);
    debug("yP = " + yP);
    debug("DM = " + eTP.attribute("DimMin"));
    debug("offsetX = " + offsetX);
    debug("offsetY = " + offsetY);*/
    if (!listaElementos) {
      debug("!listaElementos");
      continue;
    }
    totalElementos = listaElementos.length();
    for (var iElemento: Number = 0; iElemento < totalElementos; iElemento++) {
      nElemento = listaElementos.item(iElemento);
      eElemento = nElemento.toElement();
      if (nElemento.nodeName() == "Trabajo") {
        y = parseFloat(eElemento.attribute("Y"));
        y = y + offsetY;
        x = parseFloat(eElemento.attribute("X"));
        x = x + offsetX;
        eElemento.setAttribute("Y", y);
        eElemento.setAttribute("X", x);
        nSimetrico = nElemento.cloneNode();
        eSimetrico = nSimetrico.toElement();
        if (ejeSim == "H") {
          h = parseFloat(eElemento.attribute("H"));
          y = yP - y - h;
          eSimetrico.setAttribute("Y", y)
        } else {
          w = parseFloat(eElemento.attribute("W"));
          x = xP - x - w;
          eSimetrico.setAttribute("X", x)
        }
      } else if (nElemento.nodeName() == "Corte") {
        x = parseFloat(eElemento.attribute("X1"));
        x2 = parseFloat(eElemento.attribute("X2"));
        y = parseFloat(eElemento.attribute("Y1"));
        y2 = parseFloat(eElemento.attribute("Y2"));
        y = y + offsetY;
        y2 = y2 + offsetY;
        x = x + offsetX;
        x2 = x2 + offsetX;
        eElemento.setAttribute("Y1", y);
        eElemento.setAttribute("Y2", y2);
        eElemento.setAttribute("X1", x);
        eElemento.setAttribute("X2", x2);
        nSimetrico = nElemento.cloneNode();
        eSimetrico = nSimetrico.toElement();
        if (ejeSim == "H") {
          y = yP - y;
          y2 = yP - y2;
          eSimetrico.setAttribute("Y1", y);
          eSimetrico.setAttribute("Y2", y2);
        } else {
          x = xP - x;
          x2 = xP - x2;
          eSimetrico.setAttribute("X1", x);
          eSimetrico.setAttribute("X2", x2);
        }
      }
      listaParam.item(iPP).appendChild(nSimetrico);
    }
    var dimMin: Array = eTP.attribute("DimMin").split("x");
    if (ejeSim == "H") {
      dimMin[1] *= 2;
      eTP.setAttribute("SimX", "true");
    } else {
      dimMin[0] *= 2;
      eTP.setAttribute("SimY", "true");
    }
    eTP.setAttribute("DimMin", dimMin[0] + "x" + dimMin[1]);
  }
  return true;
}

function artesG_areaTrabajoConSangria(xmlProceso: FLDomNode): Array {
  var area: Array = [];
  var areaTrabajo: String = this.iface.dameAtributoXML(xmlProceso, "Parametros/AreaTrabajoParam@Valor");

  var coordTrabajo: Array = areaTrabajo.split("x");
  var sangriaArriba: Number = parseFloat(this.iface.dameAtributoXML(xmlProceso, "Parametros/SangriaParam@Arriba"));
  var sangriaAbajo: Number = parseFloat(this.iface.dameAtributoXML(xmlProceso, "Parametros/SangriaParam@Abajo"));
  var sangriaIzquierda: Number = parseFloat(this.iface.dameAtributoXML(xmlProceso, "Parametros/SangriaParam@Izquierda"));
  var sangriaDerecha: Number = parseFloat(this.iface.dameAtributoXML(xmlProceso, "Parametros/SangriaParam@Derecha"));

  area.x = parseFloat(coordTrabajo[0]) + sangriaIzquierda + sangriaDerecha;
  area.y = parseFloat(coordTrabajo[1]) + sangriaArriba + sangriaAbajo;

  area.x = Math.round(area.x * 100) / 100;
  area.y = Math.round(area.y * 100) / 100;

  return area;
}

function artesG_areaTrabajoSinSangria(xmlProceso: FLDomNode): Array {
  var area: Array = [];
  var areaTrabajo: String = this.iface.dameAtributoXML(xmlProceso, "Parametros/AreaTrabajoParam@Valor");

  var coordTrabajo: Array = areaTrabajo.split("x");
  area.x = parseFloat(coordTrabajo[0]);
  area.y = parseFloat(coordTrabajo[1]);

  area.x = Math.round(area.x * 100) / 100;
  area.y = Math.round(area.y * 100) / 100;

  return area;
}

function artesG_areaPIConPinzas(xmlProceso: FLDomNode, ejeSimetria: String): Array {
  // debug("artesG_areaPIConPinzas");
  // var doc:FLDomDocument = new FLDomDocument;
  // doc.appendChild(xmlProceso.cloneNode());
  // debug(doc.toString(4));
  var area: Array = [];

  var areaPliego = this.iface.dameAtributoXML(xmlProceso, "Parametros/PliegoImpresionParam@Valor");
  var anchoPinza: Number = parseFloat(this.iface.dameAtributoXML(xmlProceso, "Parametros/TipoImpresoraParam@AnchoPinza"));
  var dimPI: Array;
  if (isNaN(anchoPinza) || anchoPinza == 0)
  {
    dimPI = areaPliego.split("x");
  } else {
    var estilo: String = this.iface.dameAtributoXML(xmlProceso, "Parametros/EstiloImpresionParam@Valor");
    // debug("estilo = " + estilo);
    dimPI = areaPliego.split("x");
    var ejePinza: String;
    if (parseFloat(dimPI[0]) > parseFloat(dimPI[1]))
    {
      ejePinza = "H";
    } else {
      ejePinza = "V";
    }
    if (ejePinza == "H")
    {
      dimPI[1] = dimPI[1] - anchoPinza;
    } else {
      dimPI[0] = dimPI[0] - anchoPinza;
    }
    if ((estilo == "TiraRetira" && ejeSimetria == ejePinza) || estilo == "TiraVolteo")
    {
      if (ejePinza == "H") {
        dimPI[1] = dimPI[1] - anchoPinza;
      } else {
        dimPI[0] = dimPI[0] - anchoPinza;
      }
    }
  }

  area.x = parseFloat(dimPI[0]);
  area.y = parseFloat(dimPI[1]);

  // debug(area.x + " x " + area.y);

  return area;
}


function artesG_formatearTrabajosPliego(xmlProceso: FLDomNode, xmlNodoTP: FLDomNode): Boolean {
  var areaTrabajo: Array = this.iface.areaTrabajoConSangria(xmlProceso);
  var xT: Number = areaTrabajo.x;
  var yT: Number = areaTrabajo.y;

  var areaPliego = this.iface.dameAtributoXML(xmlProceso, "Parametros/PliegoImpresionParam@Valor");
  var dimPI: Array = areaPliego.split("x");
  //  var areaPliego:Array = this.iface.areaPIConPinzas(xmlProceso);
  var xP: Number = dimPI[0];
  var yP: Number = dimPI[1];
  //var supTrabajo:Number = parseFloat(coordTrabajo[0]) * parseFloat(coordTrabajo[1]);
  var supTrabajo: Number = parseFloat(xT) * parseFloat(yT);
  var supPliego: Number = parseFloat(xP) * parseFloat(yP);
  var listaTP: FLDomNodeList = xmlNodoTP.toElement().elementsByTagName("TrabajosPliegoParam");
  if (!listaTP)
    return true;
  var listaTrabajos: FLDomNodeList;
  var supOcupada: Number;
  var eficiencia: Number;
  var mejorNodo: FLDomNode = false;
  var mejorEficiencia: Number = 0;;
  var numTrabajos: Number;
  var maxNumTrabajos: Number;
  var numCortes: Number;
  var minNumCortes: Number;
  for (var i: Number = 0; i < listaTP.length(); i++)
  {
    if (!this.iface.centrarTrabajosPliego(listaTP.item(i), xP, yP)) {
      return false;
    }

    supOcupada = 0;
    listaTrabajos = listaTP.item(i).toElement().elementsByTagName("Trabajo");
    if (!listaTrabajos)
      continue;
    numTrabajos = listaTrabajos.length();

    listaCortes = listaTP.item(i).toElement().elementsByTagName("Corte");
    if (listaCortes)
      numCortes = listaCortes.length();

    supOcupada = supTrabajo * numTrabajos;
    eficiencia = parseInt(supOcupada * 100 / supPliego);
    listaTP.item(i).toElement().setAttribute("Eficiencia", eficiencia);
    listaTP.item(i).toElement().setAttribute("NumTrabajos", numTrabajos);
    listaTP.item(i).toElement().setAttribute("NumCortes", numCortes);
    // debug("numTrabajos " + numTrabajos);
    // debug("numCortes " + numCortes);
    if (numTrabajos > maxNumTrabajos || (numTrabajos == maxNumTrabajos && numCortes < minNumCortes) || !mejorNodo) {
      mejorNodo = listaTP.item(i);
      mejorEficiencia = eficiencia;
      maxNumTrabajos = numTrabajos;
      minNumCortes = numCortes;
    }
    // debug("maxNumTrabajos " + maxNumTrabajos);
    // debug("minNumCortes " + minNumCortes);
  }
  if (mejorNodo)
    mejorNodo.toElement().setAttribute("Optima", "true");

  return true;
}

function artesG_centrarTrabajosPliego(nodoTP: FLDomNode, xP: Number, yP: Number): Boolean {
  // debug("xP " + xP);
  // debug("yP " + yP);
  var util: FLUtil = new FLUtil;
  var minX: Number = xP;
  var maxX: Number = 0;
  var minY: Number = yP;
  var maxY: Number = 0;
  var x: Number = 0;
  var w: Number = 0;
  var x1: Number = 0;
  var y: Number = 0;
  var h: Number = 0;
  var y1: Number = 0;
  var offsetX: Number;
  var offsetY: Number;
  var idTrabajo: Number = 1;
  var xmlTrabajos: FLDomNodeList = nodoTP.toElement().elementsByTagName("Trabajo");
  if (!xmlTrabajos)
    return true;
  /*var d:FLDomDocument = new FLDomDocument;
  d.appendChild(nodoTP.cloneNode());*/
  // debug(d.toString(4));
  var eTrabajo: FLDomElement;
  for (var i: Number = 0; i < xmlTrabajos.length(); i++)
  {
    eTrabajo = xmlTrabajos.item(i).toElement();
    x = parseFloat(eTrabajo.attribute("X"));
    // debug("xPrevio = " + x);
    w = parseFloat(eTrabajo.attribute("W"));
    if (minX > x) {
      minX = x;
    }
    if (maxX < (x + w)) {
      maxX = (x + w);
    }
    y = parseFloat(eTrabajo.attribute("Y"));
    h = parseFloat(eTrabajo.attribute("H"));
    if (minY > y) {
      minY = y;
    }
    if (maxY < (y + h)) {
      maxY = (y + h);
    }
  }

  /// El trabajo se desplaza a una esquina para facilitar el uso de pinzas
  var mDe: Number;
  var mIz: Number;
  if (nodoTP.toElement().attribute("EjeSim") == "V")
  {
    offsetX = ((minX + (xP - maxX)) / 2) - minX;
    mIz = parseFloat(minX) + parseFloat(offsetX);
    mDe = parseFloat(minX) + parseFloat(offsetX);
  } else {
    offsetX = 0 - parseFloat(minX);
    mIz = 0;
    mDe = minX + (xP - maxX);
  }
  var margenDerecho: String = util.roundFieldValue(mDe, "articulos", "anchopliego");
  var margenIzquierdo: String = util.roundFieldValue(mIz, "articulos", "anchopliego");
  offsetX = Math.round(offsetX * 100) / 100;

  var mSu: Number;
  var mIz: Number;
  if (nodoTP.toElement().attribute("EjeSim") == "H")
  {
    offsetY = ((minY + (yP - maxY)) / 2) - minY;
    mSu = parseFloat(minY) + parseFloat(offsetY);
    mIn = parseFloat(minY) + parseFloat(offsetY);
  } else {
    offsetY = 0 - parseFloat(minY);
    mSu = 0;
    mIn = minY + (yP - maxY);
  }
  var margenSuperior: String = util.roundFieldValue(mSu, "articulos", "anchopliego");
  var margenInferior: String = util.roundFieldValue(mIn, "articulos", "anchopliego");
  offsetY = Math.round(offsetY * 100) / 100;

  // debug("maxX = " + maxX);
  // debug("minX = " + minX);
  // debug("maxY = " + maxY);
  // debug("minY = " + minY);
  // debug("xP = " + xP);
  // debug("yP = " + yP);
  // debug("offsetX = " + offsetX);
  // debug("offsetY = " + offsetY);
  // debug("mIz = " + mIz);
  // debug("mDe = " + mDe);
  // debug("mSu = " + mSu);
  // debug("mIn = " + mIn);

  var eTP: FLDomElement = nodoTP.toElement();
  eTP.setAttribute("MargenDerecho", margenDerecho);
  eTP.setAttribute("MargenIzquierdo", margenIzquierdo);
  eTP.setAttribute("MargenSuperior", margenSuperior);
  eTP.setAttribute("MargenInferior", margenInferior);

  var xmlListaElementos: FLDomNodeList = nodoTP.childNodes();
  var eElemento: FLDomElement;
  var x1: String, x2: String, y1: String, y2: String, x: String, y: String;
  var numX1: Number, numX2: Number, numY1: Number, numY2: Number;
  for (var i: Number = 0; i < xmlListaElementos.length(); i++)
  {
    if (xmlListaElementos.item(i).nodeName() == "Corte") {
      eElemento = xmlListaElementos.item(i).toElement();
      numX1 = parseFloat(eElemento.attribute("X1"));
      numX2 = parseFloat(eElemento.attribute("X2"));
      numY1 = parseFloat(eElemento.attribute("Y1"));
      numY2 = parseFloat(eElemento.attribute("Y2"));
      if (numY1 == numY2 && numX1 == 0) {
        x1 = util.roundFieldValue(numX1, "articulos", "anchopliego");
      } else {
        x1 = util.roundFieldValue(numX1 + parseFloat(offsetX), "articulos", "anchopliego");
      }
      if (numY1 == numY2 && numX2 == xP) {
        x2 = util.roundFieldValue(numX2, "articulos", "anchopliego");
      } else {
        x2 = util.roundFieldValue(numX2 + parseFloat(offsetX), "articulos", "anchopliego");
      }
      if (numX1 == numX2 && numY1 == 0) {
        y1 = util.roundFieldValue(numY1, "articulos", "anchopliego");
      } else {
        y1 = util.roundFieldValue(numY1 + parseFloat(offsetY), "articulos", "anchopliego");
      }
      if (numX1 == numX2 && numY2 == yP) {
        y2 = util.roundFieldValue(numY2, "articulos", "anchopliego");
      } else {
        y2 = util.roundFieldValue(numY2 + parseFloat(offsetY), "articulos", "anchopliego");
      }
      /*debug("X1 = " + eElemento.attribute("X1"));
      debug("numX1 = " + numX1);
      debug("x1 = " + x1);
      debug("X2 = " + eElemento.attribute("X2"));
      debug("numX2 = " + numX2);
      debug("x2 = " + x2);*/
      eElemento.setAttribute("X1", x1);
      eElemento.setAttribute("X2", x2);
      eElemento.setAttribute("Y1", y1);
      eElemento.setAttribute("Y2", y2);
    } else if (xmlListaElementos.item(i).nodeName() == "Trabajo") {
      eElemento = xmlListaElementos.item(i).toElement();
      // debug("x = " + eElemento.attribute("X"));
      // debug("x = " + parseFloat(eElemento.attribute("X")));
      // debug("Offset " + offsetX);
      // debug(parseFloat(eElemento.attribute("X") + parseFloat(offsetX)));
      x = util.roundFieldValue(parseFloat(eElemento.attribute("X")) + parseFloat(offsetX), "articulos", "anchopliego");
      y = util.roundFieldValue(parseFloat(eElemento.attribute("Y")) + parseFloat(offsetY), "articulos", "anchopliego");
      // debug("xF = " + x);
      eElemento.setAttribute("X", x);
      eElemento.setAttribute("Y", y);
      eElemento.setAttribute("Id", (idTrabajo++));
    }
  }

  return true;
}

function artesG_colocarTrabajo(nodoTP: FLDomNode, xmlProceso: FLDomNode, xP: Number, yP: Number, xT: Number, yT: Number, xOff: Number, yOff: Number): String {
  var util: FLUtil = new FLUtil;
  var x1Corte: Number;
  var x2Corte: Number;
  var y1Corte: Number;
  var y2Corte: Number;
  var res: String;
  var xmlDocAux: FLDomDocument = new FLDomDocument;
  var numClon: Number = 0;

  var xmlSangria: FLDomElement = this.iface.dameNodoXML(xmlProceso, "Parametros/SangriaParam");
  var sangriaAr: Number = parseFloat(xmlSangria.toElement().attribute("Arriba"));
  if (isNaN(sangriaAr))
    sangriaAr = 0;
  var sangriaAb: Number = parseFloat(xmlSangria.toElement().attribute("Abajo"));
  if (isNaN(sangriaAb))
    sangriaAb = 0;
  var sangriaIz: Number = parseFloat(xmlSangria.toElement().attribute("Izquierda"));
  if (isNaN(sangriaIz))
    sangriaIz = 0;
  var sangriaDe: Number = parseFloat(xmlSangria.toElement().attribute("Derecha"));
  if (isNaN(sangriaDe))
    sangriaDe = 0;

  var sangrias: Array = [];
  sangrias.ar = sangriaAr;
  sangrias.ab = sangriaAb;
  sangrias.iz = sangriaIz;
  sangrias.de = sangriaDe;

  var dimMenor: Number;
  var dimMayor: Number;
  var sangriaX: Number = sangrias.de + sangrias.iz;
  var sangriaY: Number = sangrias.ar + sangrias.ab;

  xT = xT + sangrias.iz + sangrias.de;
  yT = yT + sangrias.ar + sangrias.ab;

  // debug("xP = " + xP);
  // debug("yP = " + yP);
  // debug("xT = " + xT);
  // debug("yT = " + yT);
  this.iface.xMaxTPI_ = 0;
  this.iface.yMaxTPI_ = 0;

  var mejorOrientacion: String;
  var idMejor: Number = -1;
  var numTrabajos: Number;
  var numCortes: Number;
  var numTrabajosYTraves: Number = 0;
  var numTrabajosXTraves: Number = 0;
  var numTrabajosXAlineado: Number = 0;
  var numTrabajosYAlineado: Number = 0;
  var maxTrabajos: Number = 0;
  var minCortes: Number = 1000000;
  var maxTrabajosYTraves: Number = 0;
  var maxTrabajosXTraves: Number = 0;
  var maxTrabajosXAlineado: Number = 0;
  var maxTrabajosYAlineado: Number = 0;

  var referencia: String = xmlProceso.parentNode().toElement().attribute("Ref");
  // debug(referencia);
  var desde: Number;
  var hasta: Number

  var indice: Number;
  var iSuperiorV: Number = Math.floor(yP / yT);
  var unaDim: Boolean; /// Indica si la distribución se hace con todos los trabajos alineados de la misma forma.

  if (xP >= xT)
  {
    // debug("****V****");
    switch (referencia) {
      case "PAGINAS_LIBRO": {
        desde = iSuperiorV;
        hasta = iSuperiorV;
        break;
      }
      default: {
        desde = 0;
        hasta = iSuperiorV;
      }
    }
    for (indice = desde; indice <= hasta; indice++) {
      numTrabajosXAlineado = Math.floor(xP / xT);
      numTrabajosYTraves = Math.floor((yP - indice * yT) / xT);
      numTrabajosXTraves = Math.floor(xP / yT);
      numTrabajos = (indice * numTrabajosXAlineado) + (numTrabajosYTraves * numTrabajosXTraves);

      /// Cortes sección alineada
      if (sangriaX > 0) {
        if (indice > 0) {
          numCortes += parseInt(numTrabajosXAlineado * 2);
        }
      } else {
        if (indice > 0) {
          numCortes += parseInt(numTrabajosXAlineado);
        }
      }
      if (sangriaY > 0) {
        if (numTrabajosXAlineado > 0) {
          numCortes += parseInt(indice * 2);
        }
      } else {
        if (numTrabajosXAlineado > 0) {
          numCortes += parseInt(indice);
        }
      }
      /// Cortes sección través
      if (sangriaX > 0) {
        if (numTrabajosXTraves > 0) {
          numCortes += parseInt(numTrabajosYTraves * 2);
        }
      } else {
        if (numTrabajosXTraves > 0) {
          numCortes += parseInt(numTrabajosYTraves);
        }
      }
      if (sangriaY > 0) {
        if (numTrabajosYTraves > 0) {
          numCortes += parseInt(numTrabajosXTraves * 2);
        }
      } else {
        if (numTrabajosYTraves > 0) {
          numCortes +=  parseInt(numTrabajosXTraves);
        }
      }

      unaDim = (indice == 0 || numTrabajosYTraves == 0 || numTrabajosXTraves == 0 || numTrabajosXAlineado == 0);

      // debug("numTrabajosYAlineado (i) = " + indice );
      // debug("numTrabajosXAlineado = " + numTrabajosXAlineado );
      // debug("numTrabajosYTraves = " + numTrabajosYTraves );
      // debug("numTrabajosXTraves = " + numTrabajosXTraves);
      // debug("numTrabajos = " + numTrabajos );
      // debug("numCortes= " + numCortes );
      // debug("unaDim= " + unaDim);
      if (numTrabajos > maxTrabajos || (numTrabajos ==  maxTrabajos && numCortes < minCortes) || (numTrabajos ==  maxTrabajos && numCortes == minCortes && unaDim)) {
        maxTrabajos = numTrabajos;
        minCortes = numCortes;
        // debug("maxTrabajos = " + maxTrabajos );
        mejorOrientacion = "V";
        idMejor = indice;
        maxTrabajosYTraves = numTrabajosYTraves ;
        maxTrabajosXTraves = numTrabajosXTraves;
        maxTrabajosYAlineado = indice;
        maxTrabajosXAlineado = numTrabajosXAlineado;
      }
    }
  }

  var iSuperiorH: Number = Math.floor(xP / xT);
  if (yP >= yT)
  {
    // debug("****H****");
    switch (referencia) {
      case "PAGINAS_LIBRO": {
        desde = iSuperiorH;
        hasta = iSuperiorH;
        break;
      }
      default: {
        desde = 0;
        hasta = iSuperiorH;
      }
    }
    for (indice = desde; indice <= hasta; indice++) {
      numTrabajosXTraves = Math.floor((xP - (indice * xT)) / yT);
      numTrabajosYTraves = Math.floor(yP / xT);
      numTrabajosYAlineado = Math.floor(yP / yT);

      numTrabajos = (numTrabajosYAlineado * indice) + (numTrabajosYTraves * numTrabajosXTraves)

                    numCortes = 0;
      /// Cortes sección alineada
      if (sangriaY > 0) {
        if (indice > 0) {
          numCortes += parseInt(numTrabajosYAlineado * 2);
        }
      } else {
        if (indice > 0) {
          numCortes += parseInt(numTrabajosYAlineado);
        }
      }
      if (sangriaX > 0) {
        if (numTrabajosYAlineado > 0) {
          numCortes += parseInt(indice * 2);
        }
      } else {
        if (numTrabajosYAlineado > 0) {
          numCortes += parseInt(indice);
        }
      }

      /// Cortes sección través
      if (sangriaY > 0) {
        if (numTrabajosYTraves > 0) {
          numCortes += parseInt(numTrabajosXTraves * 2);
        }
      } else {
        if (numTrabajosYTraves > 0) {
          numCortes += parseInt(numTrabajosXTraves);
        }
      }
      if (sangriaX > 0) {
        if (numTrabajosXTraves > 0) {
          numCortes += parseInt(numTrabajosYTraves * 2);
        }
      } else {
        if (numTrabajosXTraves > 0) {
          numCortes += parseInt(numTrabajosYTraves);
        }
      }

      unaDim = (indice == 0 || numTrabajosYTraves == 0 || numTrabajosXTraves == 0 || numTrabajosYAlineado == 0);
      debug("numTrabajosXAlineado (i) = " + indice);
      debug("numTrabajosYAlineado = " + numTrabajosYAlineado);
      debug("numTrabajosYTraves = " + numTrabajosYTraves);
      debug("numTrabajosXTraves = " + numTrabajosXTraves);
      debug("numTrabajos = " + numTrabajos);
      debug("numCortes= " + numCortes);
      debug("unaDim= " + unaDim);

      if (numTrabajos > maxTrabajos || (numTrabajos == maxTrabajos && numCortes < minCortes) || (numTrabajos == maxTrabajos && numCortes == minCortes && unaDim)) {
        maxTrabajos = numTrabajos;
        minCortes = numCortes;
        mejorOrientacion = "H";
        idMejor = indice;
        maxTrabajosYTraves = numTrabajosYTraves ;
        maxTrabajosXTraves = numTrabajosXTraves;
        maxTrabajosYAlineado = numTrabajosYAlineado;
        maxTrabajosXAlineado = indice;
      }
    }
  }
  debug("mejorOrientacion = " + mejorOrientacion);
  debug("idMejor = " + idMejor);

  var contenido: String = "";
  var x: Number = 0;
  var y: Number = 0;
  var iX: Number;
  var iY: Number;
  var yCorte: Number;
  var xCorte: Number;
  var simX: Boolean = true;
  var simY: Boolean = true;
  // debug("maxTrabajosXAlineado = " + maxTrabajosXAlineado);
  // debug("maxTrabajosXTraves = " + maxTrabajosXTraves);
  // debug("maxTrabajosYAlineado = " + maxTrabajosYAlineado);
  // debug("maxTrabajosYTraves = " + maxTrabajosYTraves);

  if (mejorOrientacion == "V")
  {
    if (maxTrabajosXAlineado > 0 && maxTrabajosXTraves > 0 && maxTrabajosXAlineado > 0 && maxTrabajosXTraves > 0) {
      simX = false;
    }
    if ((maxTrabajosYAlineado > 0 && maxTrabajosXAlineado % 2 != 0) || (maxTrabajosYTraves > 0 && maxTrabajosXTraves % 2 != 0)) {
      simY = false;
    }
    if (maxTrabajosXAlineado > 0) {
      for (iY = 0; iY < maxTrabajosYAlineado; iY++) {
        contenido += this.iface.dameCorte(0, y + sangrias.ar, xP, y + sangrias.ar);
        x = 0;
        yCorte = maxTrabajosYAlineado * yT;
        for (iX = 0; iX < maxTrabajosXAlineado; iX++) {
          if (iY == 0) {
            contenido += this.iface.dameCorte(x + sangrias.iz, 0, x + sangrias.iz, yCorte);
          }
          contenido += this.iface.dameTrabajo(x, y, xT, yT, sangrias, true);
          x += parseFloat(xT);
          if (iY == 0 && sangriaY > 0) {
            contenido += this.iface.dameCorte(x - sangrias.de, 0, x - sangrias.de, yCorte);
          }
        }
        y += yT;
        if (sangriaY > 0) {
          contenido += this.iface.dameCorte(0, y - sangrias.ab, xP, y - sangrias.ab);
        }
      }
    }
    // debug("Contenido = " + contenido);
    if (maxTrabajosXTraves > 0) {
      for (iY = 0; iY < maxTrabajosYTraves; iY++) {
        // debug("Traves Y" + iY);
        contenido += this.iface.dameCorte(0, y + sangrias.iz, xP, y + sangrias.iz);
        //  debug("Contenido2 = " + contenido);
        x = 0;
        for (iX = 0; iX < maxTrabajosXTraves; iX++) {
          // debug("Traves X" + iX);
          if (iY == 0) {
            contenido += this.iface.dameCorte(x + sangrias.ar, y, x + sangrias.ar, yP);
            //  debug("Contenido3 = " + contenido);
          }
          contenido += this.iface.dameTrabajo(x, y, yT, xT, sangrias, false);
          x += parseFloat(yT);
          contenido += this.iface.dameCorte(x - sangrias.ab, y, x - sangrias.ab, yP);
          //  debug("Contenido4 = " + contenido);
        }
        y += xT;
        contenido += this.iface.dameCorte(0, y - sangrias.de, xP, y - sangrias.de);
        //  debug("Contenido5 = " + contenido);
      }
    }
  } else {
    if (maxTrabajosXAlineado > 0 && maxTrabajosXTraves > 0 && maxTrabajosXAlineado > 0 && maxTrabajosXTraves > 0)
    {
      simY = false;
    }
    if ((maxTrabajosXAlineado > 0 && maxTrabajosYAlineado % 2 != 0) || (maxTrabajosXTraves > 0 && maxTrabajosYTraves % 2 != 0))
    {
      simX = false;
    }

    if (maxTrabajosYAlineado > 0)
    {
      for (iX = 0; iX < maxTrabajosXAlineado; iX++) {
        contenido += this.iface.dameCorte(x + sangrias.iz, 0, x + sangrias.iz, yP);
        y = 0;
        xCorte = maxTrabajosXAlineado * xT;
        for (iY = 0; iY < maxTrabajosYAlineado; iY++) {
          //  debug("Trabajo alineado");
          if (iX == 0) {
            contenido += this.iface.dameCorte(0, y + sangrias.ar, xCorte, y + sangrias.ar);
          }
          contenido += this.iface.dameTrabajo(x, y, xT, yT, sangrias, true);
          y += parseFloat(yT);
          if (iX == 0 && sangriaX > 0) {
            contenido += this.iface.dameCorte(0, y - sangrias.ab, xCorte, y - sangrias.ab);
          }
        }
        x += xT;
        contenido += this.iface.dameCorte(x - sangrias.de, 0, x - sangrias.de, yP);
      }
    }
    y = 0;
    if (maxTrabajosYTraves > 0)
    {
      for (iX = 0; iX < maxTrabajosXTraves; iX++) {
        y = 0;
        contenido += this.iface.dameCorte(x + sangrias.ar, 0, x + sangrias.ar, yP);
        for (iY = 0; iY < maxTrabajosYTraves; iY++) {
          // debug("Trabajo traves");
          if (iX == 0) {
            contenido += this.iface.dameCorte(x, y + sangrias.iz, xP, y + sangrias.iz);
          }
          contenido += this.iface.dameTrabajo(x, y, yT, xT, sangrias, false);
          y += parseFloat(xT);
          contenido += this.iface.dameCorte(x, y - sangrias.de, xP, y - sangrias.de);
        }
        x += yT;
        contenido += this.iface.dameCorte(x - sangrias.ab, 0, x - sangrias.ab, yP);
      }
    }
  }
  if (contenido == "")
    return true;

  // debug("simX = " + simX);
  // debug("simY = " + simY);
  // debug("Contenido final = " + contenido);
  var contPadre: String = "<TrabajosPliegoParam DimMin=\"" + this.iface.xMaxTPI_ + "x" + this.iface.yMaxTPI_ + "\"";
  if (simX)
  {
    contPadre += " SimX=\"true\"";
  }
  if (simY)
  {
    contPadre += " SimY=\"true\"";
  }
  contPadre += ">" + contenido + "</TrabajosPliegoParam>";
  // debug("Trabajos por pliego = " + contPadre);

  xmlDocAux.setContent(contPadre);
  nodoTP.appendChild(xmlDocAux.firstChild().cloneNode());
  return true;
}

function artesG_colocarTrabajo2(nodoTP: FLDomNode, xmlProceso: FLDomNode, xP: Number, yP: Number, xT: Number, yT: Number, xOff: Number, yOff: Number): String {
  var util: FLUtil = new FLUtil;
  var x1Corte: Number;
  var x2Corte: Number;
  var y1Corte: Number;
  var y2Corte: Number;
  var res: String;
  var xmlDocAux: FLDomDocument = new FLDomDocument;
  var numClon: Number = 0;

  var xmlSangria: FLDomElement = this.iface.dameNodoXML(xmlProceso, "Parametros/SangriaParam");
  var sangriaAr: Number = parseFloat(xmlSangria.toElement().attribute("Arriba"));
  if (isNaN(sangriaAr))
    sangriaAr = 0;
  var sangriaAb: Number = parseFloat(xmlSangria.toElement().attribute("Abajo"));
  if (isNaN(sangriaAb))
    sangriaAb = 0;
  var sangriaIz: Number = parseFloat(xmlSangria.toElement().attribute("Izquierda"));
  if (isNaN(sangriaIz))
    sangriaIz = 0;
  var sangriaDe: Number = parseFloat(xmlSangria.toElement().attribute("Derecha"));
  if (isNaN(sangriaDe))
    sangriaDe = 0;

  var sangrias: Array = [];
  sangrias.ar = sangriaAr;
  sangrias.ab = sangriaAb;
  sangrias.iz = sangriaIz;
  sangrias.de = sangriaDe;

  var dimMenor: Number;
  var dimMayor: Number;
  var sangriaMayor: Number;
  var sangriaMenor: Number;
  var horizontalEsMayor: Boolean;

  xT = xT + sangrias.iz + sangrias.de;
  yT = yT + sangrias.ar + sangrias.ab;

  // debug("xP = " + xP);
  // debug("yP = " + yP);
  // debug("xT = " + xT);
  // debug("yT = " + yT);
  this.iface.xMaxTPI_ = 0;
  this.iface.yMaxTPI_ = 0;

  if (xT > yT)
  {
    dimMenor = yT;
    dimMayor = xT;
    sangriaMayor = sangrias.de + sangrias.iz;
    sangriaMenor = sangrias.ar + sangrias.ab;
    horizontalEsMayor = true;
  } else {
    dimMenor = xT;
    dimMayor = yT;
    sangriaMayor = sangrias.ar + sangrias.ab;
    sangriaMenor = sangrias.de + sangrias.iz;
    horizontalEsMayor = false;
  }

  var mejorOrientacion: String;
  var idMejor: Number = -1;
  var numTrabajos: Number;
  var numCortes: Number;
  var numTrabajosYTraves: Number = 0;
  var numTrabajosXTraves: Number = 0;
  var numTrabajosXAlineado: Number = 0;
  var numTrabajosYAlineado: Number = 0;
  var maxTrabajos: Number = 0;
  var minCortes: Number = 1000000;
  var maxTrabajosYTraves: Number = 0;
  var maxTrabajosXTraves: Number = 0;
  var maxTrabajosXAlineado: Number = 0;
  var maxTrabajosYAlineado: Number = 0;

  var referencia: String = xmlProceso.parentNode().toElement().attribute("Ref");
  // debug(referencia);
  var desde: Number;
  var hasta: Number

  var indice: Number;
  var iSuperiorV: Number = Math.floor(yP / dimMenor);

  if (xP >= dimMayor)
  {
    // debug("****V****");
    switch (referencia) {
      case "PAGINAS_LIBRO": {
        desde = iSuperiorV;
        hasta = iSuperiorV;
        break;
      }
      default: {
        desde = 0;
        hasta = iSuperiorV;
      }
    }
    for (indice = desde; indice <= hasta; indice++) {
      numTrabajosYTraves = Math.floor((yP - indice * dimMenor) / dimMayor);
      numTrabajosXTraves = Math.floor(xP / dimMenor);
      numTrabajosXAlineado = Math.floor(xP / dimMayor);
      numTrabajos = (indice * numTrabajosXAlineado) + (numTrabajosYTraves * numTrabajosXTraves);

      if (sangriaMayor > 0) {
        numCortes = (numTrabajosXAlineado + indice) * 2;
      } else {
        numCortes = numTrabajosXAlineado + indice;
      }
      if (sangriaMenor > 0) {
        numCortes += (numTrabajosXTraves + numTrabajosYTraves) * 2;
      } else {
        numCortes += numTrabajosXTraves + numTrabajosYTraves;
      }
      // debug("indice = " + indice );
      // debug("numTrabajosYTraves = " + numTrabajosYTraves );
      // debug("numTrabajosXTraves = " + numTrabajosXTraves);
      // debug("numTrabajosXAlineado = " + numTrabajosXAlineado );
      // debug("numTrabajos = " + numTrabajos );
      // debug("numCortes= " + numCortes );
      if (numTrabajos > maxTrabajos || (numTrabajos ==  maxTrabajos && numCortes < minCortes)) {
        maxTrabajos = numTrabajos;
        minCortes = numCortes;
        // debug("maxTrabajos = " + maxTrabajos );
        mejorOrientacion = "V";
        idMejor = indice;
        maxTrabajosYTraves = numTrabajosYTraves ;
        maxTrabajosXTraves = numTrabajosXTraves;
        maxTrabajosYAlineado = indice;
        maxTrabajosXAlineado = numTrabajosXAlineado;
      }
    }
  }

  var iSuperiorH: Number = Math.floor(xP / dimMenor);
  if (yP >= dimMayor)
  {
    // debug("****H****");
    switch (referencia) {
      case "PAGINAS_LIBRO": {
        desde = iSuperiorH;
        hasta = iSuperiorH;
        break;
      }
      default: {
        desde = 0;
        hasta = iSuperiorH;
      }
    }
    for (indice = desde; indice <= hasta; indice++) {
      numTrabajosXTraves = Math.floor((xP - (indice * dimMenor)) / dimMayor);
      numTrabajosYTraves = Math.floor(yP / dimMenor);
      numTrabajosYAlineado = Math.floor(yP / dimMayor);
      // debug("");
      // debug("indice = " + indice );
      // debug("numTrabajosYTraves = " + numTrabajosYTraves );
      // debug("numTrabajosXTraves = " + numTrabajosXTraves);
      // debug("numTrabajosYAlineado = " + numTrabajosYAlineado );

      numTrabajos = (numTrabajosYAlineado * indice) + (numTrabajosYTraves * numTrabajosXTraves)

      if (sangriaMayor > 0) {
        numCortes = (numTrabajosYAlineado + indice) * 2;
      } else {
        numCortes = numTrabajosYAlineado + indice;
      }
      if (sangriaMenor > 0) {
        numCortes += (numTrabajosXTraves + numTrabajosYTraves) * 2;
      } else {
        numCortes += numTrabajosXTraves + numTrabajosYTraves;
      }

      numCortes = indice + numTrabajosYAlineado + numTrabajosXTraves + numTrabajosYTraves + 2;
      // debug("numTrabajos = " + numTrabajos );
      // debug("numCortes= " + numCortes );
      if (numTrabajos > maxTrabajos || (numTrabajos ==  maxTrabajos && numCortes < minCortes)) {
        maxTrabajos = numTrabajos;
        minCortes = numCortes;
        // debug("maxTrabajos = " + maxTrabajos );
        mejorOrientacion = "H";
        idMejor = indice;
        maxTrabajosYTraves = numTrabajosYTraves ;
        maxTrabajosXTraves = numTrabajosXTraves;
        maxTrabajosYAlineado = numTrabajosYAlineado;
        maxTrabajosXAlineado = indice;
      }
    }
  }
  //  debug("mejorOrientacion = " + mejorOrientacion );
  //  debug("idMejor = " + idMejor );

  var contenido: String = "";
  var x: Number = 0;
  var y: Number = 0;
  var iX: Number;
  var iY: Number;
  var yCorte: Number;
  var xCorte: Number;
  var simX: Boolean = true;
  var simY: Boolean = true;
  // debug("maxTrabajosXAlineado = " + maxTrabajosXAlineado);
  // debug("maxTrabajosXTraves = " + maxTrabajosXTraves);
  // debug("maxTrabajosYAlineado = " + maxTrabajosYAlineado);
  // debug("maxTrabajosYTraves = " + maxTrabajosYTraves);

  if (mejorOrientacion == "V")
  {
    if (maxTrabajosXAlineado > 0 && maxTrabajosXTraves > 0 && maxTrabajosXAlineado > 0 && maxTrabajosXTraves > 0) {
      simX = false;
    }
    if ((maxTrabajosYAlineado > 0 && maxTrabajosXAlineado % 2 != 0) || (maxTrabajosYTraves > 0 && maxTrabajosXTraves % 2 != 0)) {
      simY = false;
    }
    for (iY = 0; iY < maxTrabajosYAlineado; iY++) {
      contenido += this.iface.dameCorte(0, y + sangrias.ar, xP, y + sangrias.ar);
      x = 0;
      yCorte = maxTrabajosYAlineado * dimMenor;
      for (iX = 0; iX < maxTrabajosXAlineado; iX++) {
        if (iY == 0) {
          contenido += this.iface.dameCorte(x + sangrias.iz, 0, x + sangrias.iz, yCorte);
        }
        contenido += this.iface.dameTrabajo(x, y, dimMayor, dimMenor, sangrias, true);
        x += parseFloat(dimMayor);
        if (iY == 0 && sangriaMayor > 0) {
          contenido += this.iface.dameCorte(x - sangrias.de, 0, x - sangrias.de, yCorte);
        }
      }
      y += dimMenor;
      if (sangriaMenor > 0) {
        contenido += this.iface.dameCorte(0, y - sangrias.ab, xP, y - sangrias.ab);
      }
    }

    for (iY = 0; iY < maxTrabajosYTraves; iY++) {
      // debug("Traves Y" + iY);
      contenido += this.iface.dameCorte(0, y + sangrias.iz, xP, y + sangrias.iz);
      x = 0;
      for (iX = 0; iX < maxTrabajosXTraves; iX++) {
        // debug("Traves X" + iX);
        if (iY == 0) {
          contenido += this.iface.dameCorte(x + sangrias.ar, y, x + sangrias.ar, yP);
        }
        contenido += this.iface.dameTrabajo(x, y, dimMenor, dimMayor, sangrias, false);
        x += parseFloat(dimMenor);
        contenido += this.iface.dameCorte(x - sangrias.ab, y, x - sangrias.ab, yP);
      }
      y += dimMayor;
      contenido += this.iface.dameCorte(0, y - sangrias.de, xP, y - sangrias.de);
    }
  } else {
    if (maxTrabajosXAlineado > 0 && maxTrabajosXTraves > 0 && maxTrabajosXAlineado > 0 && maxTrabajosXTraves > 0)
    {
      simY = false;
    }
    if ((maxTrabajosXAlineado > 0 && maxTrabajosYAlineado % 2 != 0) || (maxTrabajosXTraves > 0 && maxTrabajosYTraves % 2 != 0))
    {
      simX = false;
    }

    for (iX = 0; iX < maxTrabajosXAlineado; iX++)
    {
      contenido += this.iface.dameCorte(x + sangrias.iz, 0, x + sangrias.iz, yP);
      y = 0;
      xCorte = maxTrabajosXAlineado * dimMenor;
      for (iY = 0; iY < maxTrabajosYAlineado; iY++) {
        //  debug("Trabajo alineado");
        if (iX == 0) {
          contenido += this.iface.dameCorte(0, y + sangrias.ar, xCorte, y + sangrias.ar);
        }
        contenido += this.iface.dameTrabajo(x, y, dimMenor, dimMayor, sangrias, true);
        y += parseFloat(dimMayor);
        if (iX == 0 && sangriaMayor > 0) {
          contenido += this.iface.dameCorte(0, y - sangrias.ab, xCorte, y - sangrias.ab);
        }
      }
      x += dimMenor;
      contenido += this.iface.dameCorte(x - sangrias.de, 0, x - sangrias.de, yP);
    }
    y = 0;
    for (iX = 0; iX < maxTrabajosXTraves; iX++)
    {
      y = 0;
      contenido += this.iface.dameCorte(x + sangrias.ar, 0, x + sangrias.ar, yP);
      for (iY = 0; iY < maxTrabajosYTraves; iY++) {
        // debug("Trabajo traves");
        if (iX == 0) {
          contenido += this.iface.dameCorte(x, y + sangrias.iz, xP, y + sangrias.iz);
        }
        contenido += this.iface.dameTrabajo(x, y, dimMayor, dimMenor, sangrias, false);
        y += parseFloat(dimMenor);
        contenido += this.iface.dameCorte(x, y - sangrias.de, xP, y - sangrias.de);
      }
      x += dimMayor;
      contenido += this.iface.dameCorte(x - sangrias.ab, 0, x - sangrias.ab, yP);
    }
  }
  if (contenido == "")
    return true;

  // debug("simX = " + simX);
  // debug("simY = " + simY);

  var contPadre: String = "<TrabajosPliegoParam DimMin=\"" + this.iface.xMaxTPI_ + "x" + this.iface.yMaxTPI_ + "\"";
  if (simX)
  {
    contPadre += " SimX=\"true\"";
  }
  if (simY)
  {
    contPadre += " SimY=\"true\"";
  }
  contPadre += ">" + contenido + "</TrabajosPliegoParam>";
  // debug("Trabajos por pliego = " + contPadre);

  xmlDocAux.setContent(contPadre);
  nodoTP.appendChild(xmlDocAux.firstChild().cloneNode());
  return true;
}

function artesG_dameCorte(x1: Number, y1: Number, x2: Number, y2: Number): String {
  var util: FLUtil = new FLUtil;
  var resultado: String = "<Corte X1=\"" + util.roundFieldValue(x1, "articulos", "anchopliego") + "\" Y1=\"" + util.roundFieldValue(y1, "articulos", "anchopliego") + "\" X2=\"" + util.roundFieldValue(x2, "articulos", "anchopliego") + "\" Y2=\"" + util.roundFieldValue(y2, "articulos", "anchopliego") + "\"/>\n";
  return resultado;
}

function artesG_dameTrabajo(x: Number, y: Number, w: Number, h: Number, sangrias: Array, alineado: Boolean): String {
  var util: FLUtil = new FLUtil;

  var yh: Number = y + h;
  if (yh > this.iface.yMaxTPI_)
  {
    this.iface.yMaxTPI_ = yh;
  }

  var xw: Number = x + w;
  if (xw > this.iface.xMaxTPI_)
  {
    this.iface.xMaxTPI_ = xw;
  }

  if (alineado)
  {
    x += sangrias.iz;
    w -= (sangrias.iz + sangrias.de);
    y += sangrias.ar;
    h -= (sangrias.ar + sangrias.ab);
  } else {
    x += sangrias.ar;
    w -= (sangrias.ar + sangrias.ab);
    y += sangrias.iz;
    h -= (sangrias.iz + sangrias.de);
  }
  var apaisado: String;
  if (alineado)
  {
    apaisado = "false";
  } else {
    apaisado = "true";
  }
  var res: String = "<Trabajo X=\"" + util.roundFieldValue(x, "articulos", "anchopliego") + "\" Y=\"" + util.roundFieldValue(y, "articulos", "anchopliego") + "\" W=\"" + util.roundFieldValue(w, "articulos", "anchopliego") + "\" H=\"" + util.roundFieldValue(h, "articulos", "anchopliego") + "\" Apaisado=\"" + apaisado + "\"/>\n";

  return res;
}

// function artesG_dameTrabajo(x:Number, y:Number, w:Number, h:Number):String
// {
//  var util:FLUtil = new FLUtil;
//  var res:String = "<Trabajo X=\"" + util.roundFieldValue(x, "articulos", "anchopliego") + "\" Y=\"" + util.roundFieldValue(y, "articulos", "anchopliego") + "\" W=\"" + util.roundFieldValue(w, "articulos", "anchopliego") + "\" H=\"" + util.roundFieldValue(h, "articulos", "anchopliego") + "\"/>\n";
//
//  var yh:Number = y + h;
//  if (yh > this.iface.yMaxTPI_) {
//    this.iface.yMaxTPI_ = yh;
//  }
//
//  var xw:Number = x + w;
//  if (xw > this.iface.xMaxTPI_) {
//    this.iface.xMaxTPI_ = xw;
//  }
//  return res;
// }

function artesG_distribuirTrabajosHV(nodoTP: FLDomNode, xT: Number, yT: Number, xP: Number, yP: Number, xOff: Number, yOff: Number): String {
  // debug("distribuir HV");

  var x1Corte: Number;
  var x2Corte: Number;
  var y1Corte: Number;
  var y2Corte: Number;
  var res: String = "";
  var xmlDocAux: FLDomDocument = new FLDomDocument;

  var numTrabajosY: Number = Math.floor(yP / yT);
  var initY: Number = 0;
  if (numTrabajosY % 2 == 0)
  {
    initY = (yP / 2) - (numTrabajosY / 2) * yT;
  } else {
    initY = (yP / 2) - ((numTrabajosY - 1)/ 2) * yT - (yT / 2);
  }
  var numTrabajosX: Number = Math.floor(xP / xT);
  var initX: Number = 0;
  if (numTrabajosX % 2 == 0)
  {
    initX = (xP / 2) - (numTrabajosX / 2) * xT;
  } else {
    initX = (xP / 2) - ((numTrabajosX - 1)/ 2) * xT - (xT / 2);
  }

  for (var i: Number = 0; i < numTrabajosY; i++)
  {
    x1Corte = parseFloat(xOff);
    x2Corte = parseFloat(xOff) + parseFloat(xT);
    y1Corte = parseFloat(yOff) + initY + (i * yT);
    y2Corte = y1Corte;

    x1Corte = Math.round(x1Corte * 100) / 100;
    x2Corte = Math.round(x2Corte * 100) / 100;
    y1Corte = Math.round(y1Corte * 100) / 100;
    y2Corte = Math.round(y2Corte * 100) / 100;

    xmlDocAux.setContent("<Corte Eje=\"H\" X1=\"" + x1Corte + "\" X2=\"" + x2Corte + "\" Y1=\"" + y1Corte + "\" Y2=\"" + y2Corte + "\"/>\n");
    nodoTP.appendChild(xmlDocAux.firstChild().cloneNode());

    for (var k: Number = 0; k < numTrabajosX; k++) {
      x1Corte = parseFloat(xOff) + initX + (k * xT);
      x2Corte = x1Corte;
      y2Corte = y1Corte + yT;

      x1Corte = Math.round(x1Corte * 100) / 100;
      x2Corte = Math.round(x2Corte * 100) / 100;
      y1Corte = Math.round(y1Corte * 100) / 100;
      y2Corte = Math.round(y2Corte * 100) / 100;

      xmlDocAux.setContent("<Trabajo X=\"" + x1Corte + "\" Y=\"" + y1Corte + "\" W=\"" + xT + "\" H=\"" + yT + "\"/>\n");
      nodoTP.appendChild(xmlDocAux.firstChild().cloneNode());

      xmlDocAux.setContent("<Corte Eje=\"H\" X1=\"" + x1Corte + "\" X2=\"" + x2Corte + "\" Y1=\"" + y1Corte + "\" Y2=\"" + y2Corte + "\"/>\n");
      nodoTP.appendChild(xmlDocAux.firstChild().cloneNode());
    }

    x1Corte = parseFloat(xOff) + initX + (numTrabajosX * xT);
    x2Corte = x1Corte;
    y2Corte = y1Corte + yT;

    x1Corte = Math.round(x1Corte * 100) / 100;
    x2Corte = Math.round(x2Corte * 100) / 100;
    y1Corte = Math.round(y1Corte * 100) / 100;
    y2Corte = Math.round(y2Corte * 100) / 100;

    xmlDocAux.setContent("<Corte Eje=\"H\" X1=\"" + x1Corte + "\" X2=\"" + x2Corte + "\" Y1=\"" + y1Corte + "\" Y2=\"" + y2Corte + "\"/>\n");
    nodoTP.appendChild(xmlDocAux.firstChild().cloneNode());
  }
  y1Corte = parseFloat(yOff) + initY + (numTrabajosY * yT);
  y2Corte = y1Corte;

  x1Corte = Math.round(x1Corte * 100) / 100;
  x2Corte = Math.round(x2Corte * 100) / 100;
  y1Corte = Math.round(y1Corte * 100) / 100;
  y2Corte = Math.round(y2Corte * 100) / 100;

  xmlDocAux.setContent("<Corte Eje=\"H\" X1=\"" + x1Corte + "\" X2=\"" + x2Corte + "\" Y1=\"" + y1Corte + "\" Y2=\"" + y2Corte + "\"/>\n");
  nodoTP.appendChild(xmlDocAux.firstChild().cloneNode());

  return true;
}

function artesG_distribuirTrabajosV(nodoTP: FLDomNode, xT: Number, yT: Number, yP: Number, xOff: Number, yOff: Number): String {
  var x1Corte: Number;
  var x2Corte: Number;
  var y1Corte: Number;
  var y2Corte: Number;
  var res: String = "";
  var xmlDocAux: FLDomDocument = new FLDomDocument;

  var numTrabajos: Number = Math.floor(yP / yT);
  var initY: Number = 0;

  if (numTrabajos % 2 == 0)
  {
    initY = (yP / 2) - (numTrabajos / 2) * yT;
  } else {
    initY = (yP / 2) - ((numTrabajos - 1)/ 2) * yT - (yT / 2);
  }

  x1Corte = parseFloat(xOff);
  x2Corte = parseFloat(xOff) + parseFloat(xT);
  for (var i: Number = 0; i < numTrabajos; i++)
  {
    y1Corte = parseFloat(yOff) + initY + (i * yT);
    y2Corte = y1Corte;

    x1Corte = Math.round(x1Corte * 100) / 100;
    x2Corte = Math.round(x2Corte * 100) / 100;
    y1Corte = Math.round(y1Corte * 100) / 100;
    y2Corte = Math.round(y2Corte * 100) / 100;

    xmlDocAux.setContent("<Corte Eje=\"H\" X1=\"" + x1Corte + "\" X2=\"" + x2Corte + "\" Y1=\"" + y1Corte + "\" Y2=\"" + y2Corte + "\"/>\n");
    nodoTP.appendChild(xmlDocAux.firstChild().cloneNode());
    xmlDocAux.setContent("<Trabajo X=\"" + x1Corte + "\" Y=\"" + y1Corte + "\" W=\"" + xT + "\" H=\"" + yT + "\"/>\n");
    nodoTP.appendChild(xmlDocAux.firstChild().cloneNode());
  }
  y1Corte = parseFloat(yOff) + initY + (numTrabajos * yT);
  y2Corte = y1Corte;

  x1Corte = Math.round(x1Corte * 100) / 100;
  x2Corte = Math.round(x2Corte * 100) / 100;
  y1Corte = Math.round(y1Corte * 100) / 100;
  y2Corte = Math.round(y2Corte * 100) / 100;

  xmlDocAux.setContent("<Corte Eje=\"H\" X1=\"" + x1Corte + "\" X2=\"" + x2Corte + "\" Y1=\"" + y1Corte + "\" Y2=\"" + y2Corte + "\"/>\n");
  nodoTP.appendChild(xmlDocAux.firstChild().cloneNode());

  return true;
}

function artesG_distribuirTrabajosH(nodoTP: FLDomNode, xT: Number, yT: Number, xP: Number, xOff: Number, yOff: Number): String {
  var x1Corte: Number;
  var x2Corte: Number;
  var y1Corte: Number;
  var y2Corte: Number;
  var res: String = "";
  var xmlDocAux: FLDomDocument = new FLDomDocument;

  var numTrabajos: Number = Math.floor(xP / xT);
  var initX: Number = 0;

  if (numTrabajos % 2 == 0)
  {
    initX = (xP / 2) - (numTrabajos / 2) * xT;
  } else {
    initX = (xP / 2) - ((numTrabajos - 1)/ 2) * xT - (xT / 2);
  }

  y1Corte = parseFloat(yOff);
  y2Corte = parseFloat(yOff) + parseFloat(yT);
  for (var i: Number = 0; i < numTrabajos; i++)
  {
    x1Corte = parseFloat(xOff) + initX + (i * xT);
    x2Corte = x1Corte;

    x1Corte = Math.round(x1Corte * 100) / 100;
    x2Corte = Math.round(x2Corte * 100) / 100;
    y1Corte = Math.round(y1Corte * 100) / 100;
    y2Corte = Math.round(y2Corte * 100) / 100;

    xmlDocAux.setContent("<Corte Eje=\"V\" X1=\"" + x1Corte + "\" X2=\"" + x2Corte + "\" Y1=\"" + y1Corte + "\" Y2=\"" + y2Corte + "\"/>\n");
    nodoTP.appendChild(xmlDocAux.firstChild().cloneNode());
    xmlDocAux.setContent("<Trabajo X=\"" + x1Corte + "\" Y=\"" + y1Corte + "\" W=\"" + xT + "\" H=\"" + yT + "\"/>\n");
    nodoTP.appendChild(xmlDocAux.firstChild().cloneNode());
  }
  x1Corte = parseFloat(xOff) + initX + (numTrabajos * xT);
  x2Corte = x1Corte;

  x1Corte = Math.round(x1Corte * 100) / 100;
  x2Corte = Math.round(x2Corte * 100) / 100;
  y1Corte = Math.round(y1Corte * 100) / 100;
  y2Corte = Math.round(y2Corte * 100) / 100;

  xmlDocAux.setContent("<Corte Eje=\"V\" X1=\"" + x1Corte + "\" X2=\"" + x2Corte + "\" Y1=\"" + y1Corte + "\" Y2=\"" + y2Corte + "\"/>\n");
  nodoTP.appendChild(xmlDocAux.firstChild().cloneNode());

  return true;
}

/** \C Buscar un atributo en un nodo y sus nodos hijos
@param  nodoPadre: Nodo que contiene el atributo (o los nodos hijos que lo contienen)
@param  ruta: Cadena que especifica la ruta a seguir para encontrar el atributo. Su formato es NodoPadre/NodoHijo/NodoNieto/.../Nodo@Atributo. Puede ser tan larga como sea necesario. Siempre se toma el primer nodo Hijo que tiene el nombre indicado.
@param  debeExistir: Si vale true la función devuelve false si no encuentra el atributo
@return Valor del atributo o false si hay error
\end */
function artesG_dameAtributoXML(nodoPadre: FLDomNode, ruta: String, debeExistir: Boolean): String {
  var util: FLUtil = new FLUtil;

  var valor: String;
  var nombreNodo: Array = ruta.split("/");
  var nombreAtributo: String;
  var nodoXML: FLDomNode = nodoPadre;
  var i: Number;
  var iAtributo: Number;
  for (i = 0; i < nombreNodo.length; i++)
  {
    iAtributo = nombreNodo[i].find("@");
    if (iAtributo > -1) {
      nombreAtributo = nombreNodo[i].right(nombreNodo[i].length - iAtributo - 1);
      // debug("nombreAtributo = " + nombreAtributo );
      nombreNodo[i] = nombreNodo[i].left(iAtributo);
    }
    if (nombreNodo[i] != "") {
      // debug("nombreNodo[i] = " + nombreNodo[i] );
      nodoXML = nodoXML.namedItem(nombreNodo[i]);
    }
    if (!nodoXML) {
      if (debeExistir) {
        MessageBox.warning(util.translate("scripts", "No se pudo leer el nodo de la ruta:\n%1.\nNo se encuentra el nodo <%2>").arg(ruta).arg(nombreNodo[i]), MessageBox.Ok, MessageBox.NoButton);
      }
      return false;
    }
  }

  valor = nodoXML.toElement().attribute(nombreAtributo);
  return valor;
}

/** \C Busca un nodo en un nodo y sus nodos hijos
@param  nodoPadre: Nodo que contiene el nodo a buscar (o los nodos hijos que lo contienen)
@param  ruta: Cadena que especifica la ruta a seguir para encontrar el atributo. Su formato es NodoPadre/NodoHijo/NodoNieto/.../Nodo. Puede ser tan larga como sea necesario. Siempre se toma el primer nodo Hijo que tiene el nombre indicado.
@param  debeExistir: Si vale true la función devuelve false si no encuentra el atributo
@return Nodo buscado o false si hay error o no se encuentra el nodo
\end */
function artesG_dameNodoXML(nodoPadre: FLDomNode, ruta: String, debeExistir: Boolean): FLDomNode {

  // debug("ruta " + ruta);
  // var doc:FLDomDocument = new FLDomDocument;
  // doc.appendChild(nodoPadre.cloneNode());
  // debug(doc.toString(4));

  var util: FLUtil = new FLUtil;

  var valor: String;
  var nombreNodo: Array = ruta.split("/");
  var nodoXML: FLDomNode = nodoPadre;
  var i: Number;
  var nombreActual: String;
  var iInicioCorchete: Number
  for (i = 0; i < nombreNodo.length; i++)
  {
    nombreActual = nombreNodo[i];
    iInicioCorchete = nombreActual.find("[");
    if (iInicioCorchete > -1) {
      iFinCorchete = nombreActual.find("]");
      var condicion: String = nombreActual.substring(iInicioCorchete + 1, iFinCorchete);
      var paramCond: Array = condicion.split("=");
      if (!paramCond[0].startsWith("@")) {
        MessageBox.warning(util.translate("scripts", "Error al procesar la ruta XML %1 en %2").arg(ruta).arg(nombreActual), MessageBox.Ok, MessageBox.NoButton);
        return false;
      }
      nombreActual = nombreActual.left(iInicioCorchete);
      var atributo: String = paramCond[0].right(paramCond[0].length - 1);
      var nodoHijo: FLDomNode;
      for (nodoHijo = nodoXML.firstChild(); nodoHijo; nodoHijo = nodoHijo.nextSibling()) {
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
        return false;
      }
    } else {
      // debug("Buscando " + nombreActual + " en " + nodoXML.nodeName());
      nodoXML = nodoXML.namedItem(nombreActual);
      if (!nodoXML) {
        if (debeExistir) {
          MessageBox.warning(util.translate("scripts", "No se pudo leer el nodo de la ruta:\n%1.\nNo se encuentra el nodo <%2>").arg(ruta).arg(nombreNodo[i]), MessageBox.Ok, MessageBox.NoButton);
        }
        return false;
      }
    }
  }
  return nodoXML;
}

function artesG_mostrarParamIptico(nodoParam: FLDomNode): FLDomNode {
  var util: FLUtil = new FLUtil;
  var idUsuario = sys.nameUser();
  if (!util.sqlDelete("paramiptico", "idusuario = '" + idUsuario + "'"))
    return false;

  var xmlParam: FLDomDocument = new FLDomDocument;
  xmlParam.appendChild(nodoParam.cloneNode());
  var parametros: String = xmlParam.toString(4);

  var f: Object = new FLFormSearchDB("paramiptico");
  var curPI: FLSqlCursor = f.cursor();

  curPI.setModeAccess(curPI.Insert);
  curPI.refreshBuffer();
  curPI.setValueBuffer("idusuario", idUsuario);
  curPI.setValueBuffer("xml", parametros);
  f.setMainWidget();
  var xml: String = f.exec("xml");

  if (!xml)
  {
    return false;
  }

  var xmlDocProducto: FLDomDocument = new FLDomDocument;
  if (!xmlDocProducto.setContent(xml))
    return false;

  return xmlDocProducto.firstChild();
}

function artesG_mostrarParamColor(nodoColor: FLDomNode): FLDomNode {
  var util: FLUtil = new FLUtil;
  var idUsuario = sys.nameUser();
  if (!util.sqlDelete("paramcolor", "idusuario = '" + idUsuario + "'"))
    return false;

  var xmlParam: FLDomDocument = new FLDomDocument;
  xmlParam.appendChild(nodoColor.cloneNode());
  var parametros: String = xmlParam.toString(4);

  var f: Object = new FLFormSearchDB("paramcolor");
  var curPC: FLSqlCursor = f.cursor();

  curPC.setModeAccess(curPC.Insert);
  curPC.refreshBuffer();
  curPC.setValueBuffer("idusuario", idUsuario);
  curPC.setValueBuffer("xml", parametros);
  f.setMainWidget();
  var xml: String = f.exec("xml");

  if (!xml)
  {
    return false;
  }

  var xmlDocColor: FLDomDocument = new FLDomDocument;
  if (!xmlDocColor.setContent(xml))
    return false;

  return xmlDocColor.firstChild();
}


function artesG_mostrarPrecorte(lblPix: Object, xmlPrecorte: FLDomNode, dimPliego: String): Boolean {
  var coordPliego: Array = dimPliego.split("x");
  var anchoP: Number = parseFloat(coordPliego[0]);
  var altoP: Number = parseFloat(coordPliego[1]);
  var factor: Number;
  if (anchoP > altoP)
  {
    factor = 100 / anchoP;
  } else {
    factor = 100 / altoP;
  }
  /*debug(anchoP);
  debug(altoP);
  debug(factor);*/
  anchoP *= factor;
  altoP *= factor;
  // debug(anchoP);
  // debug(altoP);

  var pix = new Pixmap();
  var pic = new Picture();
  var devSize = new Size(100, 100);
  pix.resize(devSize);
  var devRect = new Rect(0, 0, anchoP, altoP);
  pic.begin();

  pix.resize(devSize);
  pix.fill(new Color(200, 200, 200));

  if (!xmlPrecorte)
  {
    pix = pic.playOnPixmap(pix);
    lblPix.pixmap = pix;
    pic.end();
    return;
  }

  pic.setPen(new Color(255, 0, 0) , 1);
  pic.setBrush(new Color(255, 255, 255) , 1);
  pic.drawRect(devRect);


  var precorte: String = xmlPrecorte.toElement().attribute("Corte");

  var dimCorte: Array = precorte.split("x");
  var factorX: Number = dimCorte[0];
  var factorY: Number = dimCorte[1];

  var coordX: Number;
  var coordY: Number;

  for (var cortesX: Number = 1; cortesX < factorX; cortesX++)
  {
    coordX = (anchoP / factorX) * cortesX;
    pic.drawLine(coordX, 0, coordX, altoP);
  }
  for (var cortesY: Number = 1; cortesY < factorY; cortesY++)
  {
    coordY = (altoP / factorY) * cortesY;
    pic.drawLine(0, coordY, anchoP, coordY);
  }
  pix = pic.playOnPixmap(pix);
  lblPix.pixmap = pix;
  pic.end();
}

function artesG_mostrarTrabajosPliego(lblPix: Object, xmlProceso: FLDomNode, dimPliegoImpresion: String, dimPix: Array): Boolean {
  // debug("dimPliegoImpresion = " + dimPliegoImpresion);
  var coordPliego: Array = dimPliegoImpresion.split("x");
  var anchoP: Number = parseFloat(coordPliego[0]);
  var altoP: Number = parseFloat(coordPliego[1]);

  var anchoPix: Number;
  var altoPix: Number;
  if (!dimPix)
  {
    dimPix = [];
    dimPix["x"] = 100;
    dimPix["y"] = 100;
  }
  anchoPix = dimPix["x"];
  altoPix = dimPix["y"];

  var factor: Number;
  if (anchoP > altoP)
  {
    factor = anchoPix / anchoP;
  } else {
    factor = altoPix / altoP;
  }

  // debug("factor = " + factor);
  var svg: String = "<svg width='" + anchoPix + "' height='" + altoPix + "' version='1.1' xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink'>";

  anchoP *= factor;
  altoP *= factor;

  //  var pix = new Pixmap();
  //  var pic = new Picture();
  //  var devSize = new Size( anchoPix, altoPix);
  //  pix.resize(devSize);
  //  var devRect = new Rect( 0, 0, anchoP, altoP);
  //  pic.begin();
  //
  //  pix.resize(devSize);
  //  pix.fill( new Color(200, 200, 200) );
  //
  // debug("MTP");
  var xmlTrabajosPliego: FLDomNode = false;
  if (xmlProceso)
  {
    xmlTrabajosPliego = this.iface.dameNodoXML(xmlProceso, "Parametros/TrabajosPliegoParam");
  }
  if (!xmlTrabajosPliego)
  {
    // debug("!MTP");
    //    this.child("lblOptimo").text = "";
    //    pix = pic.playOnPixmap( pix );
    //    lblPix.pixmap = pix;
    //    pic.end();
    svg += "</svg>";
    this.iface.mostrarSVG(lblPix, svg, dimPix);
    return;
  }

  //  pic.setPen( new Color( 255, 0, 0 ) , 1 );
  //  pic.setBrush( new Color( 255, 255, 255 ) , 1 );
  //  pic.drawRect(devRect);
  svg += "<g stroke-width='0' stroke='white' fill='white' >\n";
  svg += "<rect x='" + 0 + "' width='" + anchoP + "' y='" + 0 + "' height='" + altoP + "'/>\n";
  svg += "</g>\n";

  var eTP: FLDomElement = xmlTrabajosPliego.toElement();

  var trabajos: FLDomNodeList = eTP.elementsByTagName("Trabajo");
  var eTrabajo: FLDomElement;
  var w: Number = 0, h: Number = 0, x: Number = 0, y: Number = 0;

  //  var dibTrabajos:Array = [];
  //  pic.setPen( new Color( 255, 0, 0 ) , 1 );
  //  pic.setBrush( new Color( 200, 250, 140 ) , 1 );

  //var svg:String = "<svg width=\"300\" height=\"300\" x=\"0\" y=\"0\" id=\"0\"><g style=\"stroke:rgb(0,0,0);stroke-width:0.9;fill:none;\">";
  svg += "<g stroke-width='1' stroke='red' fill='yellow' >\n";
  for (var i: Number = 0; i < trabajos.length(); i++)
  {
    eTrabajo = trabajos.item(i).toElement();
    x = parseFloat(eTrabajo.attribute("X")) * factor;
    y = parseFloat(eTrabajo.attribute("Y")) * factor;
    w = parseFloat(eTrabajo.attribute("W")) * factor;
    h = parseFloat(eTrabajo.attribute("H")) * factor;
    svg += "<rect x='" + x + "' width='" + w + "' y='" + y + "' height='" + h + "'/>\n";
    //    dibTrabajos[i] = new Rect(x, y, w, h);
    //    pic.drawRect(dibTrabajos[i]);
  }
  svg += "</g>\n";

  var cortes: FLDomNodeList = eTP.elementsByTagName("Corte");
  var eCorte: FLDomElement;
  var x1: Number = 0, y1: Number = 0, x2: Number = 0, y2: Number = 0;

  //  pic.setPen( new Color( 0, 255, 0 ) , 1 );

  if (cortes)
  {
    svg += "<g stroke-width='1' stroke='green' >\n";
    for (var i: Number = 0; i < cortes.length(); i++) {
      eCorte = cortes.item(i).toElement();
      x1 = parseFloat(eCorte.attribute("X1")) * factor;
      y1 = parseFloat(eCorte.attribute("Y1")) * factor;
      x2 = parseFloat(eCorte.attribute("X2")) * factor;
      y2 = parseFloat(eCorte.attribute("Y2")) * factor;
      svg += "<line x1='" + x1 + "' y1='" + y1 + "' x2='" + x2 + "' y2='" + y2 + "' />\n";
      //      pic.drawLine(x1, y1, x2, y2);
    }
    svg += "</g>\n";
  }
  // debug("HAy xmlProceso??");
  if (xmlProceso)
  {
    // debug("HAy xmlProceso");
    var svgPinzas: String = this.iface.svgPinzas(xmlProceso, dimPix);
    /*if (!svgPinzas) {
    debug("!svgPinzas");
      return false;
    }
    */
    svg += svgPinzas;
  }
  svg += "</svg>\n";
  // debug("svg = " + svg);
  this.iface.mostrarSVG(lblPix, svg, dimPix);
  return true;
}

function artesG_mostrarSVG(lblPix: Object, svg: String, dimPix: Array): Boolean {

  File.write("dib.svg", svg);

  var anchoPix: Number;
  var altoPix: Number;
  if (dimPix)
  {
    anchoPix = dimPix["x"];
    altoPix = dimPix["y"];
  } else {
    anchoPix = 100;
    altoPix = 100;
  }
  var pix = new Pixmap();
  var devSize = new Size(anchoPix, altoPix);
  var devRect = new Rect(0, 0, anchoPix, altoPix);
  var tux = new Picture();
  var pic = new Picture();

  pix.resize(devSize);
  pix.fill(new Color(200, 200, 200));

  pic.begin();

  pix = pic.playOnPixmap(pix);
  lblPix.pixmap = pix;

  tux.load("dib.svg", "svg");

  pic.setWindow(devRect);
  pic.setViewport(devRect);
  pic.drawPicture(tux);

  pix = pic.playOnPixmap(pix);
  lblPix.pixmap = pix;

  pic.end();
}/*
//  var coordPliego:Array = dimPliegoImpresion.split("x");
//  var anchoP:Number = parseFloat(coordPliego[0]);
//  var altoP:Number = parseFloat(coordPliego[1]);

  var anchoPix:Number;
  var altoPix:Number;
  if (dimPix) {
    anchoPix = dimPix["x"];
    altoPix = dimPix["y"];
  } else {
    anchoPix = 100;
    altoPix = 100;
  }
//  var factor:Number;
//  if (anchoP > altoP) {
//    factor = anchoPix / anchoP;
//  } else {
//    factor = altoPix / altoP;
//  }
//  anchoP *= factor;
//  altoP *= factor;

  var pix = new Pixmap();
  var pic = new Picture();
  var devSize = new Size( anchoPix, altoPix);
  pix.resize(devSize);
  var devRect = new Rect( 0, 0, anchoP, altoP);
  pic.begin();

  pix.resize(devSize);
  pix.fill( new Color(200, 200, 200) );

  if (!xmlTrabajosPliego) {
    //this.child("lblOptimo").text = "";
    pix = pic.playOnPixmap( pix );
    lblPix.pixmap = pix;
    pic.end();
    return;
  }
//  var texto:String = "(" + this.iface.xmlTPOActual_.toElement().attribute("Eficiencia") + "%)";
//  if (this.iface.xmlTPOActual_.toElement().attribute("Optima") == "true")
//    texto += "*";
//  this.child("lblOptimo").text = texto;

  pic.setPen( new Color( 255, 0, 0 ) , 1 );
  pic.setBrush( new Color( 255, 255, 255 ) , 1 );
  pic.drawRect(devRect);

  var eTP:FLDomElement = xmlTrabajosPliego.toElement();

  var trabajos:FLDomNodeList = eTP.elementsByTagName("Trabajo");
  var eTrabajo:FLDomElement;
  var w:Number = 0, h:Number = 0, x:Number = 0, y:Number = 0;

  var dibTrabajos:Array = [];
  pic.setPen( new Color( 255, 0, 0 ) , 1 );
  pic.setBrush( new Color( 200, 250, 140 ) , 1 );

  //var svg:String = "<svg width=\"300\" height=\"300\" x=\"0\" y=\"0\" id=\"0\"><g style=\"stroke:rgb(0,0,0);stroke-width:0.9;fill:none;\">";
  for (var i:Number = 0; i < trabajos.length(); i++) {
    eTrabajo = trabajos.item(i).toElement();
    x = parseFloat(eTrabajo.attribute("X")) * factor;
    y = parseFloat(eTrabajo.attribute("Y")) * factor;
    w = parseFloat(eTrabajo.attribute("W")) * factor;
    h = parseFloat(eTrabajo.attribute("H")) * factor;
    dibTrabajos[i] = new Rect(x, y, w, h);
    pic.drawRect(dibTrabajos[i]);
  }

  var cortes:FLDomNodeList = eTP.elementsByTagName("Corte");
  var eCorte:FLDomElement;
  var x1:Number = 0, y1:Number = 0, x2:Number = 0, y2:Number = 0;

  //var dibCortes:Array = [];
  pic.setPen( new Color( 0, 255, 0 ) , 1 );
  //pic.setBrush( new Color( 200, 250, 140 ) , 1 );

  if (cortes) {
    for (var i:Number = 0; i < cortes.length(); i++) {
      eCorte = cortes.item(i).toElement();
      x1 = parseFloat(eCorte.attribute("X1")) * factor;
      y1 = parseFloat(eCorte.attribute("Y1")) * factor;
      x2 = parseFloat(eCorte.attribute("X2")) * factor;
      y2 = parseFloat(eCorte.attribute("Y2")) * factor;
      //dibCortes[i] = new Rect(x1, y1, x2, y2);
      pic.drawLine(x1, y1, x2, y2);
    }
  }

  pix = pic.playOnPixmap( pix );
  lblPix.pixmap = pix;
  pic.end();

  return true;
}*/


/** \C Obtiene el nodo XML de parámetros asociado a un centro de coste
@param  nombre: Nombre del centro de coste
@return Nodo con los parámetros
\end */
function artesG_dameParamCentroCoste(nombre: String): FLDomNode {
  // debug("artesG_dameParamCentroCoste " + nombre);
  var util: FLUtil = new FLUtil;

  var paramCC: String = util.sqlSelect("pr_tiposcentrocoste", "parametros", "codtipocentro = '" + nombre + "'");
  if (!paramCC)
  {
    MessageBox.warning(util.translate("scripts", "Error al obtener los parámetros del centro de coste tipo %1").arg(nombre), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  var xmlParamCC: FLDomDocument = new FLDomDocument;
  if (!xmlParamCC.setContent(paramCC))
  {
    MessageBox.warning(util.translate("scripts", "Error al leer los parámetros del tipo de centro de coste %1.\nEl formato XML no es válido").arg(nombre), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  // debug(xmlParamCC.toString());
  return xmlParamCC.firstChild();
}

function artesG_entraEnArea(sAreaContenido: String, sAreaContinente: String): Boolean {
  // debug("Entra en area contenido " + sAreaContenido + " en continente " + sAreaContinente);
  var areaContenido: Array = this.iface.dameVectorPos(sAreaContenido);
  var areaContinente: Array = this.iface.dameVectorPos(sAreaContinente);

  if (areaContenido["x"] <= areaContinente["x"] && areaContenido["y"] <= areaContinente["y"])
    return true;

  areaContenido = this.iface.rotar90(areaContenido);

  if (areaContenido["x"] <= areaContinente["x"] && areaContenido["y"] <= areaContinente["y"])
    return true;

  return false;
}

function artesG_dameVectorPos(posicion: String): Array {
  var temp: Array = posicion.split("x");
  var vector: Array = [];
  vector["x"] = parseFloat(temp[0]);
  vector["y"] = parseFloat(temp[1]);
  vector["z"] = 1;
  return vector;
}

function artesG_rotar90(vector: Array): Array {
  var matriz: Array = [[0, 1, 0], [1, 0, 0], [0, 0, 1]];
  return this.iface.aplicarMatriz(vector, matriz);
}

function artesG_aplicarMatriz(vector: Array, matriz: Array): Array {
  var nuevoVector: Array = [];
  nuevoVector["x"] = vector["x"] * matriz[0][0] + vector["y"] * matriz[1][0] + vector["z"] * matriz[2][0];
  nuevoVector["y"] = vector["x"] * matriz[0][1] + vector["y"] * matriz[1][1] + vector["z"] * matriz[2][1];
  nuevoVector["z"] = vector["x"] * matriz[0][2] + vector["y"] * matriz[1][2] + vector["z"] * matriz[2][2];

  return nuevoVector;
}

function artesG_tiraRetiraPosible(xmlProceso: FLDomNode): Boolean {
  // var xmlDoc:FLDomDocument = new FLDomDocument;
  // xmlDoc.appendChild(xmlProceso.cloneNode());
  // debug(xmlDoc.toString(4));
  var posible: Boolean = false;
  // debug("TRPosible                                                                                             ?????");
  /// No se usa porque cuando se llama TrabajosPliegoParam no existe
  //  var ejeSim:String = this.iface.dameAtributoXML(xmlProceso, "Parametros/TrabajosPliegoParam@EjeSim");
  // debug("ejeSim = " + ejeSim);
  //  if (ejeSim == "H" || ejeSim == "V") {
  var xmlColores: FLDomNode;
  if (xmlProceso.nodeName() == "Parametros")
  {
    xmlColores = this.iface.dameNodoXML(xmlProceso, "ColoresParam");
  } else {
    xmlColores = this.iface.dameNodoXML(xmlProceso, "Parametros/ColoresParam");
  }
  var config: String = xmlColores.toElement().attribute("Valor");
  // debug("Config = " + config);
  var arrayConfig = config.split("+");
  if (xmlColores.toElement().attribute("DosCaras") != "true")
  {
    // debug("!Dos caras");
    posible = false;
  } else if (xmlColores.toElement().attribute("Cuatricromia") == "true")
  {
    // debug("Cuatri");
    posible = true;
  } else {
    var configColoresFrente: FLDomNode = this.iface.dameNodoXML(xmlColores, "ConfigColores[@Cara=Frente]");
    var configColoresVuelta: FLDomNode = this.iface.dameNodoXML(xmlColores, "ConfigColores[@Cara=Vuelta]");

    var coloresFrente: FLDomNodeList = configColoresFrente.toElement().elementsByTagName("Color");
    var coloresVuelta: FLDomNodeList = configColoresVuelta.toElement().elementsByTagName("Color");
    var contenidos: Boolean = true;
    if (arrayConfig[0] > arrayConfig[1])
    {
      for (var i: Number = 0; i < coloresVuelta.length(); i++) {
        if (!this.iface.dameNodoXML(configColoresFrente, "Color[@Nombre=" + coloresVuelta.item(i).toElement().attribute("Nombre") + "]")) {
          contenidos = false;
          break;
        }
      }
    } else {
      for (var i: Number = 0; i < coloresFrente.length(); i++)
      {
        if (!this.iface.dameNodoXML(configColoresVuelta, "Color[@Nombre=" + coloresFrente.item(i).toElement().attribute("Nombre") + "]")) {
          contenidos = false;
          break;
        }
      }
    }
    if (contenidos)
    {
      posible = true;
    }
  }
  //  }

  //  debug("posible = " + posible);
  return posible;
}

function artesG_valoresVariante(nombreVariante: String, xmlProceso: FLDomNode): FLDomNodeList {
  var util: FLUtil = new FLUtil;
  var nodoVariante: FLDomNode;

  switch (nombreVariante)
  {
    case "TipoImpresoraVar": {
      nodoVariante = this.iface.opcionesTipoimpresora(xmlProceso);
      if (!nodoVariante)
        return false;
      break;
    }
    case "DistPlanchaVar": {
      nodoVariante = this.iface.opcionesDistPlanchas(xmlProceso);
      if (!nodoVariante)
        return false;
      break;
    }
    case "PliegoVar": {
      nodoVariante = this.iface.opcionesPliego(xmlProceso);
      if (!nodoVariante)
        return false;
      break;
    }
    case "PliegoImpresionVar": {
      nodoVariante = this.iface.opcionesPliegoImpresion(xmlProceso);
      if (!nodoVariante)
        return false;
      break;
    }
    case "TrabajosPliegoVar": {
      nodoVariante = this.iface.opcionesTrabajosPliego(xmlProceso);
      if (!nodoVariante)
        return false;
      break;
    }
    case "EstiloImpresionVar": {
      nodoVariante = this.iface.opcionesEstiloImpresion(xmlProceso);
      if (!nodoVariante)
        return false;
      break;
    }
    case "TipoPlastificadoraVar": {
      nodoVariante = this.iface.opcionesTipoPlastificadora(xmlProceso);
      if (!nodoVariante)
        return false;
      break;
    }
    case "TipoTroqueladoraVar": {
      nodoVariante = this.iface.opcionesTipoTroqueladora(xmlProceso);
      if (!nodoVariante)
        return false;
      break;
    }
    case "TipoPeladoraVar": {
      nodoVariante = this.iface.opcionesTipoPeladora(xmlProceso);
      if (!nodoVariante)
        return false;
      break;
    }
    case "TipoPlegadoraVar": {
      nodoVariante = this.iface.opcionesTipoPlegadora(xmlProceso);
      if (!nodoVariante)
        return false;
      break;
    }
    case "TipoGrapadoraVar": {
      nodoVariante = this.iface.opcionesTipoGrapadora(xmlProceso);
      if (!nodoVariante)
        return false;
      break;
    }
    case "TipoEGCVar": {
      nodoVariante = this.iface.opcionesTipoEGC(xmlProceso);
      if (!nodoVariante)
        return false;
      break;
    }
    case "TipoAlzadoraVar": {
      nodoVariante = this.iface.opcionesTipoAlzadora(xmlProceso);
      if (!nodoVariante)
        return false;
      break;
    }
    case "TipoGuillotinaPAVar": {
      nodoVariante = this.iface.opcionesTipoGuillotinaPA(xmlProceso);
      if (!nodoVariante)
        return false;
      break;
    }
    case "TipoGuillotinaPWOVar": {
      nodoVariante = this.iface.opcionesTipoGuillotinaPWO(xmlProceso);
      if (!nodoVariante)
        return false;
      break;
    }
    case "TipoGuillotinaPOSWOVar": {
      nodoVariante = this.iface.opcionesTipoGuillotinaPOSWO(xmlProceso);
      if (!nodoVariante)
        return false;
      break;
    }
    case "TipoGuillotinaTriVar": {
      nodoVariante = this.iface.opcionesTipoGuillotinaTri(xmlProceso);
      if (!nodoVariante)
        return false;
      break;
    }
    case "TipoMaquinaWireOVar": {
      nodoVariante = this.iface.opcionesTipoMaquinaWireO(xmlProceso);
      if (!nodoVariante)
        return false;
      break;
    }
    case "TipoEncuadernadoraVar": {
      nodoVariante = this.iface.opcionesTipoEncuadernadora(xmlProceso);
      if (!nodoVariante)
        return false;
      break;
    }
    case "AgenciaTransporteVar": {
      nodoVariante = this.iface.opcionesAgenciaTransporte(xmlProceso);
      if (!nodoVariante)
        return false;
      break;
    }
    case "SiguienteTareaVar": {
      nodoVariante = this.iface.opcionesSiguienteTarea(xmlProceso);
      if (!nodoVariante)
        return false;
      break;
    }
    default: {
      // debug(nombreVariante);
      var nodoVariantes: FLDomNode = this.iface.cargarVariantes();
      nodoVariante = nodoVariantes.namedItem(nombreVariante);
      if (!nodoVariante) {
        MessageBox.warning(util.translate("scripts", "Error al obtener las variantes para  %1").arg(nombreVariante), MessageBox.Ok, MessageBox.NoButton);
        return false;
      }
    }
  }
  return nodoVariante.childNodes();
}

/** \C <br/> <i><b>POSIBLES PLIEGOS DE IMPRESIÓN</b></i><br/>
Las dimensiones consideradas son las de los artículos de tipo PLIE (pliegos) que tienen suficiente área (indicada en AreaTrabajoParam) y el gramaje indicado en GramajeParam. Se consideran tambien como pliego de impresión las posibles divisiones enteras de los pliegos seleccionados que continúan cumpliendo las condiciones.<br/>
Parámetros necesarios:<br/>
GramajeParam<br/>
AreaTrabajoParam<br/><br/>
Variantes obtenidas:<br/>
Nodos PliegoImpresionParam para todos los pliegos de impresión posibles.
@param  xmlProceso: Nodo XML del proceso
@param  valor: Nodo de opciones
\end */
function artesG_opcionesPliegoImpresion(xmlProceso: FLDomNode): FLDomNode {
  var util: FLUtil = new FLUtil;

  var idTipoProceso: String = xmlProceso.parentNode().toElement().attribute("IdTipoProceso");
  debug("idTipoProceso = " + idTipoProceso);
  var areaTrabajo: String, areaPliego: String, codImpresora: String;
  switch (idTipoProceso)
  {
    case "TACO": {
      areaTrabajo = this.iface.dameAtributoXML(xmlProceso, "Parametros/AreaTrabajoParam@Valor");
      areaPliego = this.iface.dameAtributoXML(xmlProceso, "Parametros/PapelParam@AreaPliego");
      codImpresora = this.iface.dameAtributoXML(xmlProceso, "Parametros/TipoImpresoraParam@Valor");
      if (codImpresora == "") {
        codImpresora = false;
      }
      break;
    }
    default: {
      areaTrabajo = this.iface.dameAtributoXML(xmlProceso, "Parametros/AreaTrabajoParam@Valor");
      areaPliego = this.iface.dameAtributoXML(xmlProceso, "Parametros/PliegoParam@AreaPliego");
      codImpresora = this.iface.dameAtributoXML(xmlProceso, "Parametros/TipoImpresoraParam@Valor");
      if (codImpresora == "") {
        codImpresora = false;
      }
      break;
    }
  }

  var opcionesDP: FLDomDocument = new FLDomDocument;
  var contenido: String = "<PliegoImpresionVar>\n"
                          contenido += this.iface.divisionesPliego(areaTrabajo, areaPliego, codImpresora);
  contenido += "</PliegoImpresionVar>"
               if (!opcionesDP.setContent(contenido))
  {
    return false;
  }
  return opcionesDP.firstChild();
}

/** \C <br/> <i><b>POSIBLES DISTRIBUCIONES DE TRABAJO EN PLIEGO DE IMPRESON</b></i><br/>
Se toma la mejor distribución en cuanto a papel y la mejor distribución simétrica (que puede optimizar las planchas) Si la eficiencia de ambas distribuciones es igual se toma sólo la simétrica.<br/>
PliegoImpresionParam:<br/>
AreaTrabajoParam<br/><br/>
Variantes obtenidas:<br/>
Nodos TrabajosPliegoParam para las distribuciones óptimas
@param  xmlProceso: Nodo XML del proceso
@param  valor: Nodo de opciones
\end */
function artesG_opcionesTrabajosPliego(xmlProceso: FLDomNode): FLDomNode {
  //debug("artesG_opcionesTrabajosPliego");
  var util: FLUtil = new FLUtil;

  var detalleTarea: String = "";
  var opcionesDP: FLDomDocument = new FLDomDocument;
  var contenido: String = "<TrabajosPliegoVar>\n"
  contenido += "</TrabajosPliegoVar>"
  if (!opcionesDP.setContent(contenido))
    return false;

  var eficiencia: Number;
  var eficienciaSim: Number;

  var xmlTrabajosVar: FLDomNode = this.iface.trabajosXPliego(xmlProceso);
  var xmlTrabajoOptimo: FLDomNode = this.iface.dameNodoXML(xmlTrabajosVar, "TrabajosPliegoParam[@Optima=true]");
  if (xmlTrabajoOptimo)
  {
    eficiencia = xmlTrabajoOptimo.toElement().attribute("Eficiencia");
  }
  //debug("e o = " + eficiencia );

  xmlTrabajosVar = this.iface.trabajosXPliegoSim(xmlProceso);
  var xmlTrabajoOptimoSim: FLDomNode = this.iface.dameNodoXML(xmlTrabajosVar, "TrabajosPliegoParam[@Optima=true]");
  if (xmlTrabajoOptimoSim)
  {
    opcionesDP.firstChild().appendChild(xmlTrabajoOptimoSim.cloneNode());
    eficienciaSim = xmlTrabajoOptimoSim.toElement().attribute("Eficiencia");
  }
  //debug("e s = " + eficienciaSim );
  if (eficiencia && eficiencia > eficienciaSim)
  {
    //debug("append");
    opcionesDP.firstChild().appendChild(xmlTrabajoOptimo.cloneNode());
  }
  //debug(opcionesDP.toString(4));
  return opcionesDP.firstChild();
}


/** \C <br/> <i><b>POSIBLES PLIEGOS DE IMPRESIÓN</b></i><br/>
Las dimensiones consideradas son las de los artículos de tipo PLIE (pliegos) que tienen suficiente área (indicada en AreaTrabajoParam) y el gramaje indicado en GramajeParam. Se consideran tambien como pliego de impresión las posibles divisiones enteras de los pliegos seleccionados que continúan cumpliendo las condiciones.<br/>
Parámetros necesarios:<br/>
GramajeParam<br/>
AreaTrabajoParam<br/><br/>
Variantes obtenidas:<br/>
Nodos PliegoImpresionParam para todos los pliegos de impresión posibles.
@param  xmlProceso: Nodo XML del proceso
@param  valor: Nodo de opciones
\end */
function artesG_opcionesPliego(xmlProceso: FLDomNode): FLDomNode {
  //debug("artesG_opcionesPliego");
  var util: FLUtil = new FLUtil;

  var detalleTarea: String = "";
  var opcionesDP: FLDomDocument = new FLDomDocument;
  var contenido: String = "<PliegoVar>\n"

  var gramaje: Number = this.iface.dameAtributoXML(xmlProceso, "Parametros/GramajeParam@Valor");
  var codMarcaPapel: String = this.iface.dameAtributoXML(xmlProceso, "Parametros/CodMarcaPapelParam@Valor");
  var areaTrabajo: String = this.iface.dameAtributoXML(xmlProceso, "Parametros/AreaTrabajoParam@Valor");
  var codCalidad: String = this.iface.dameAtributoXML(xmlProceso, "Parametros/CalidadParam@Valor");

  var qryPliegos: FLSqlQuery = new FLSqlQuery;
  with(qryPliegos)
  {
    setTablesList("articulos");
    setSelect("referencia, dimpliego, codformato");
    setFrom("articulos");
    setWhere("codfamilia = 'PAPE' AND gramaje = " + gramaje + " AND codmarcapapel = '" + codMarcaPapel + "' AND codcalidad = '" + codCalidad + "'");
    setForwardOnly(true);
  }
  //debug("artesG_opcionesPliego 1");
  if (!qryPliegos.exec())
    return false;
  //debug("artesG_opcionesPliego 2");

  var areaPliego: String, codFormato: String;
  var referencia: String;
  var hayPliegos: Boolean = false;
  while (qryPliegos.next())
  {
    areaPliego = qryPliegos.value("dimpliego");
    referencia = qryPliegos.value("referencia");
    codFormato = qryPliegos.value("codformato");

    if (!this.iface.entraEnArea(areaTrabajo, areaPliego)) {
      continue;
    }
    contenido += "\t<PliegoParam Ref=\"" + referencia + "\" AreaPliego=\"" + areaPliego + "\" Formato = \"" + codFormato + "\"/>\n";
    hayPliegos = true;
  }
  if (!hayPliegos)
  {
    MessageBox.warning(util.translate("scripts", "No hay pliegos de papel para las dimensiones de trabajo %1, gramaje = %2 y marca = %3").arg(areaTrabajo).arg(gramaje).arg(codMarcaPapel), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  contenido += "</PliegoVar>"
               //debug("artesG_opcionesPliego contenido = " + contenido);
               if (!opcionesDP.setContent(contenido))
                 return false;

  return opcionesDP.firstChild();
}


/** \C <br/> <i><b>POSIBLES ESTILOS DE IMPRESIÓN</b></i><br/>
Los estilos de impresión dependen de si el trabajo va a una o dos caras y de la impresora a usar. Los trabajos a una cara van siempre en estilo Simple. Los trabajos a dos caras van en CaraRetira, o en TiraRetira (si la distribución de trabajos en plancha es simétrica) o en TiraVolteo (si la prensa lo permite)<br/>
Parámetros necesarios:<br/>
ColoresParam<br/>
TipoImpresoraParam<br/><br/>
Variantes obtenidas:<br/>
Nodos EstiloImpresionParam para todos los estilos de impresión posibles.
@param  xmlProceso: Nodo XML del proceso
@param  valor: Nodo de opciones
\end */
function artesG_opcionesEstiloImpresion(xmlProceso: FLDomNode): FLDomNode {
  var util: FLUtil = new FLUtil;

  var opcionesDP: FLDomDocument = new FLDomDocument;
  var contenido: String = "<EstiloImpresionVar>\n"

  var idTipoProceso: String = xmlProceso.parentNode().toElement().attribute("IdTipoProceso");
  var dosCaras: Boolean, impresora: String, nodoColores: FLDomNode, nodoFrente: FLDomNode, nodoVuelta: FLDomNode;
  switch (idTipoProceso)
  {
    default: {
      dosCaras = (this.iface.dameAtributoXML(xmlProceso, "Parametros/ColoresParam@DosCaras") == "true");
      impresora = this.iface.dameAtributoXML(xmlProceso, "Parametros/TipoImpresoraParam@Valor");
      nodoColores = this.iface.dameNodoXML(xmlProceso, "Parametros/ColoresParam");
      nodoFrente = this.iface.dameNodoXML(xmlProceso, "Parametros/ColoresParam/ConfigColores[@Cara=Frente]");
      nodoVuelta = this.iface.dameNodoXML(xmlProceso, "Parametros/ColoresParam/ConfigColores[@Cara=Vuelta]");
    }
  }


  if (dosCaras)
  {
    /// CaraRetira (siempre)
    contenido += "\t<EstiloImpresionParam Valor=\"CaraRetira\"/>\n";

    /// TiraRetira (Sólo si la distribución de trabajos en pliego de impresión es simétrica y el número de colores por cara coincide)
    if (this.iface.tiraRetiraPosible(xmlProceso)) {
      contenido += "\t<EstiloImpresionParam Valor=\"TiraRetira\"/>\n";
    }

    /// TiraVolteo (Si la impresora lo permite)
    var paramimpresora: FLDomNode = this.iface.dameParamCentroCoste(impresora);
    if (!paramimpresora) {
      return false;
    }
    var volteo: Number = parseInt(this.iface.dameAtributoXML(paramimpresora, "@Volteo"));
    if (!isNaN(volteo) && volteo > 0) {
      var numCuerpos: Number = this.iface.dameAtributoXML(paramimpresora, "@NumCuerpos");
      if (!isNaN(numCuerpos)) {
        var cV: Number = numCuerpos - volteo;
        if (nodoFrente) {
          var coloresFrente: Number = nodoFrente.toElement().attribute("Total");
          if (nodoVuelta) {
            var coloresVuelta: Number = nodoVuelta.toElement().attribute("Total");
            if ((coloresFrente <= volteo && coloresVuelta <= cV) || (coloresFrente <= cV && coloresVuelta <= volteo)) {
              contenido += "\t<EstiloImpresionParam Valor=\"TiraVolteo\"/>\n";
            }
          }
        }
      }
    }
  } else {
    contenido += "\t<EstiloImpresionParam Valor=\"Simple\"/>\n";
  }
  contenido += "</EstiloImpresionVar>"
  if (!opcionesDP.setContent(contenido))
  {
    return false;
  }
  return opcionesDP.firstChild();
}

/** \C <br/> <i><b>POSIBLES PRENSAS (MÁQUINAS DE IMPRIMIR)</b></i><br/>
Se desechan aquellas para las que el área de su plancha asociada (en los parámetros del tipo centro de coste asociado a la prensa) es menor que el pliego de impresión<br/>
Parámetros necesarios:<br/>
AreaTrabajoParam<br/>
Variantes obtenidas:<br/>
Nodos TipoImpresoraParam para todas las prensas posibles
@param  xmlProceso: Nodo XML del proceso
@param  valor: Nodo de opciones
\end */
function artesG_opcionesTipoimpresora(xmlProceso: FLDomNode): FLDomNode {
  //debug("artesG_opcionesTipoimpresora");
  var util: FLUtil = new FLUtil;

  var opcionesTI: FLDomDocument = new FLDomDocument;
  var contenido: String = "<TipoImpresoraVar>\n"

  var qryimpresoras: FLSqlQuery = new FLSqlQuery;
  with(qryimpresoras)
  {
    setTablesList("pr_tiposcentrocoste");
    setSelect("codtipocentro, parametros");
    setFrom("pr_tiposcentrocoste");
    setWhere("tipoag = 'Impresora'");
    setForwardOnly(true);
  }
  if (!qryimpresoras.exec())
    return false;

  var paramimpresora: FLDomNode;
  var refPlancha: String;
  var nombreImpresora: String;
  var contenidoParam: String;
  var hayImpresoras: Boolean = false;
  var areaPlancha: String;
  var trabajosPlancha: String
  var numCuerpos: String;
  var anchoPinza: String;
  var eImpresora: FLDomElement;
  var impresoraOK: String;
  var idTipoProceso: String = xmlProceso.parentNode().toElement().attribute("IdTipoProceso");
  var areaPliego: String, areaTrabajo: String;
  switch (idTipoProceso)
  {
    default: {
      areaPliego = this.iface.dameAtributoXML(xmlProceso, "Parametros/PliegoImpresionParam@Valor");
      areaTrabajo = this.iface.dameAtributoXML(xmlProceso, "Parametros/AreaTrabajoParam@Valor");
    }
  }
  while (qryimpresoras.next())
  {
    nombreImpresora = qryimpresoras.value("codtipocentro");
    paramImpresora = this.iface.dameParamCentroCoste(nombreImpresora);
    if (!paramImpresora)
      return false;

    // debug("nombreimpresora = " + nombreImpresora);
    impresoraOK = this.iface.validarImpresora(xmlProceso.namedItem("Parametros"), paramImpresora);
    if (!impresoraOK) {
      return false;
    }
    if (impresoraOK != "OK") {
      continue;
    }
    eImpresora = paramImpresora.toElement();

    refPlancha = eImpresora.attribute("RefPlancha");
    numCuerpos = eImpresora.attribute("NumCuerpos");
    if (!numCuerpos || numCuerpos == "") {
      numCuerpos = "0";
    }

    anchoPinza = eImpresora.attribute("AnchoPinza");

    areaPlancha = util.sqlSelect("articulos", "dimpliego", "referencia = '" + refPlancha + "'");
    if (!areaPlancha) {
      MessageBox.warning(util.translate("scripts", "Error al buscar el área de la plancha %1 asociada a la impresora %1").arg(refPlancha).arg(nombreImpresora), MessageBox.Ok, MessageBox.NoButton);
      return false;
    }

    trabajosPlancha = this.iface.trabajosPorPliego(xmlProceso, areaTrabajo, areaPliego, anchoPinza);

    contenido += "\t<TipoImpresoraParam Valor=\"" + nombreImpresora + "\" AreaPlancha=\"" + areaPlancha + "\" RefPlancha=\"" + refPlancha + "\"" + " TrabajosPlancha=\"" + trabajosPlancha + "\" NumCuerpos=\"" + numCuerpos + "\" AnchoPinza=\"" + anchoPinza + "\"/>\n";
    hayImpresoras = true;
  }
  //  if (!hayImpresoras) {
  //    MessageBox.warning(util.translate("scripts", "No hay impresoras para las dimensiones de pliego de impresión %1").arg(areaPliego), MessageBox.Ok, MessageBox.NoButton);
  //    return false;
  //  }
  contenido += "</TipoImpresoraVar>";
  if (!opcionesTI.setContent(contenido))
  {
    return false;
  }
  return opcionesTI.firstChild();
}

function artesG_validarImpresora(xmlParamPliego: FLDomNode, xmlParamImpresora: FLDomNode): String {
  var util: FLUtil = new FLUtil;
  /*var d:FLDomDocument = new FLDomDocument;
  d.appendChild(xmlParamPliego.cloneNode());
  debug(d.toString());*/
  var errorMsg: String = "OK";
  var areaPliego: String = this.iface.dameAtributoXML(xmlParamPliego, "PliegoImpresionParam@Valor");
  var coloresReg: Boolean = this.iface.dameAtributoXML(xmlParamPliego, "ColoresParam@ColoresReg") == "true";
  var fondosLisos: Boolean = this.iface.dameAtributoXML(xmlParamPliego, "FondosLisosParam@Valor") == "true";
  var numeracion: Boolean = this.iface.dameAtributoXML(xmlParamPliego, "NumeracionParam@Valor") == "true";
  var calidadEspecial: Boolean = this.iface.dameAtributoXML(xmlParamPliego, "CalidadEspecialParam@Valor") == "true";

  var eImpresora: FLDomElement = xmlParamImpresora.toElement();

  var dimPIS: String = this.iface.dameAtributoXML(xmlParamPliego, "PliegoImpresionParam@Valor");
  if (dimPIS && dimPIS != "")
  {
    var dimPI: Array = dimPIS.split("x");
    var relAspecto: Number;
    if (parseFloat(dimPI[0]) > parseFloat(dimPI[1])) {
      relAspecto = dimPI[1] / dimPI[0];
    } else {
      relAspecto = dimPI[0] / dimPI[1];
    }
    /*  debug("Dim  = " + dimPIS );
      debug("relAspecto  = " + relAspecto );*/


    var minRelAspecto: Number = parseFloat(eImpresora.attribute("RelAspectoMin"));
    //  debug("minRelAspecto  = " + minRelAspecto );
    if (!isNaN(minRelAspecto) && minRelAspecto > relAspecto) {
      errorMsg = util.translate("scripts", "El pliego de impresión (%1) no cumple la relación de aspecto mínima (%2)").arg(relAspecto).arg(minRelAspecto);
      return errorMsg;
    }
  }

  if (areaPliego && areaPliego != "")
  {
    var areaMin: String = eImpresora.attribute("AnchoMin") + "x" + eImpresora.attribute("AltoMin");
    var areaMax: String = eImpresora.attribute("AnchoMax") + "x" + eImpresora.attribute("AltoMax");

    //  debug("entraEnArea" );
    if (!this.iface.entraEnArea(areaPliego, areaMax)) {
      errorMsg = util.translate("scripts", "El área del pliego de impresión (%1) es superior al área máxima de la impresora (%2)").arg(areaPliego).arg(areaMax);
      return errorMsg;
    }
    //  debug("entraEnArea2" );
    if (!this.iface.entraEnArea(areaMin, areaPliego)) {
      errorMsg = util.translate("scripts", "El área del pliego de impresión (%1) es inferior al área mínima de la impresora (%2)").arg(areaPliego).arg(areaMin);
      return errorMsg;
    }
  }

  // debug("coloresReg " + coloresReg);
  // debug("impresora reg" + eImpresora.attribute("ColoresReg"));
  if (coloresReg)
  {
    if (eImpresora.attribute("ColoresReg") != "true") {
      errorMsg = util.translate("scripts", "La impresora no admite colores registrados");
      return errorMsg;
    }
  }
  // debug("fondosLisos" );
  if (fondosLisos)
  {
    if (eImpresora.attribute("FondosLisos") != "true") {
      errorMsg = util.translate("scripts", "La impresora no admite colores fondos lisos");
      return errorMsg;
    }
  }
  // debug("numeracion" );
  if (numeracion)
  {
    if (eImpresora.attribute("Numeracion") != "true") {
      errorMsg = util.translate("scripts", "La impresora no admite numeración");
      return errorMsg;
    }
  }
  // debug("calidadEspecial" );
  if (calidadEspecial)
  {
    if (eImpresora.attribute("CalidadEspecial") != "true") {
      errorMsg = util.translate("scripts", "La impresora no admite trabajos de calidad especial");
      return errorMsg;
    }
  }

  return "OK";
}

/** \C <br/> <i><b>POSIBLES PLASTIFICADORAS</b></i><br/>
Se desechan aquellas para las que el área máxima o mínima no sea suficienta para los pliegos de papel, así como aquellas que no permiten el gramaje del papel usado<br/>
Parámetros necesarios:<br/>
GramajeParam<br/>
Variantes obtenidas:<br/>
Nodos TipoPlastificadoraParam para todas las plastificadoras posibles
@param  xmlProceso: Nodo XML del proceso
@param  valor: Nodo de opciones
\end */
function artesG_opcionesTipoPlastificadora(xmlProceso: FLDomNode): FLDomNode {
  // debug("artesG_opcionesTipoPlastificadora");
  var util: FLUtil = new FLUtil;

  var opcionesTP: FLDomDocument = new FLDomDocument;
  var contenido: String = "<TipoPlastificadoraVar>\n"

  var gramaje: Number = parseInt(this.iface.dameAtributoXML(xmlProceso, "Parametros/GramajeParam@Valor"));
  var qryPlastificadoras: FLSqlQuery = new FLSqlQuery;
  with(qryPlastificadoras)
  {
    setTablesList("pr_tiposcentrocoste");
    setSelect("codtipocentro, parametros");
    setFrom("pr_tiposcentrocoste");
    setWhere("tipoag = 'Plastificadora'");
    setForwardOnly(true);
  }
  if (!qryPlastificadoras.exec())
    return false;

  var paramPlas: FLDomNode;
  var gramajeMin: Number;
  var anchoPinza: String;
  var areaMin: String;
  var areaMax: String;
  var ePlas: FLDomElement;
  var nombrePlas: String;
  while (qryPlastificadoras.next())
  {
    // debug(qryPlastificadoras.value("codtipocentro"));
    nombrePlas = qryPlastificadoras.value("codtipocentro");
    paramPlas = this.iface.dameParamCentroCoste(nombrePlas);
    if (!paramPlas)
      return false;

    ePlas = paramPlas.toElement();

    //areaMin = eImpresora.attribute("AnchoMin") + "x" + eImpresora.attribute("AltoMin");
    //areaMax = eImpresora.attribute("AnchoMax") + "x" + eImpresora.attribute("AltoMax");
    gramajeMin = parseInt(ePlas.attribute("GramajeMin"));
    if (gramajeMin && !isNaN(gramajeMin)) {
      if (gramajeMin > gramaje) {
        continue;
      }
    }
    contenido += "\t<TipoPlastificadoraParam Valor=\"" + nombrePlas + "\" />\n";
  }
  contenido += "</TipoPlastificadoraVar>";
  if (!opcionesTP.setContent(contenido))
    return false;

  return opcionesTP.firstChild();
}

/** \C <br/> <i><b>POSIBLES TROQUELADORAS </b></i><br/>
Se desechan aquellas para las que el área máxima o mínima no sea suficienta para los pliegos de papel, así como aquellas que no permiten el gramaje del papel usado<br/>
Parámetros necesarios:<br/>
GramajeParam<br/>
Variantes obtenidas:<br/>
Nodos TipoPlastificadoraParam para todas las plastificadoras posibles
@param  xmlProceso: Nodo XML del proceso
@param  valor: Nodo de opciones
\end */
function artesG_opcionesTipoTroqueladora(xmlProceso: FLDomNode): FLDomNode {
  // debug("artesG_opcionesTipoPlastificadora");
  var util: FLUtil = new FLUtil;

  var opcionesTT: FLDomDocument = new FLDomDocument;
  var contenido: String = "<TipoTroqueladoraVar>\n"

  var qryTroqueladoras: FLSqlQuery = new FLSqlQuery;
  with(qryTroqueladoras)
  {
    setTablesList("pr_tiposcentrocoste");
    setSelect("codtipocentro, parametros");
    setFrom("pr_tiposcentrocoste");
    setWhere("tipoag = 'Troqueladora'");
    setForwardOnly(true);
  }
  if (!qryTroqueladoras.exec())
  {
    return false;
  }

  var paramTroq: FLDomNode;
  var anchoPinza: String;
  var areaPliegoTroq: String = this.iface.dameAtributoXML(xmlProceso, "Parametros/AreaTrabajoParam@Valor");
  var areaMin: String;
  var areaMax: String;
  var eTroq: FLDomElement;
  var nombreTroq: String;
  while (qryTroqueladoras.next())
  {
    // debug(qryPlastificadoras.value("codtipocentro"));
    nombreTroq = qryTroqueladoras.value("codtipocentro");
    paramTroq = this.iface.dameParamCentroCoste(nombreTroq);
    if (!paramTroq) {
      return false;
    }
    eTroq = paramTroq.toElement();

    if (areaPliegoTroq && areaPliegoTroq != "") {
      var areaMin: String = eTroq.attribute("AnchoMin") + "x" + eTroq.attribute("AltoMin");
      var areaMax: String = eTroq.attribute("AnchoMax") + "x" + eTroq.attribute("AltoMax");

      //  debug("entraEnArea" );
      if (!this.iface.entraEnArea(areaPliegoTroq, areaMax)) {
        continue;
        //        errorMsg = util.translate("scripts", "El área del pliego de troquel (%1) es superior al área máxima de la troqueladora (%2)").arg(areaPliegoTroq).arg(areaMax);
        //        return errorMsg;
      }
      //  debug("entraEnArea2" );
      if (!this.iface.entraEnArea(areaMin, areaPliegoTroq)) {
        continue;
        //        errorMsg = util.translate("scripts", "El área del pliego de troquel (%1) es inferior al área mínima de la troqueladora (%2)").arg(areaPliegoTroq).arg(areaMin);
        //        return errorMsg;
      }
    }
    //areaMin = eImpresora.attribute("AnchoMin") + "x" + eImpresora.attribute("AltoMin");
    //areaMax = eImpresora.attribute("AnchoMax") + "x" + eImpresora.attribute("AltoMax");
    contenido += "\t<TipoTroqueladoraParam Valor=\"" + nombreTroq + "\" />\n";
  }
  contenido += "</TipoTroqueladoraVar>";
  if (!opcionesTT.setContent(contenido))
  {
    return false;
  }

  return opcionesTT.firstChild();
}

/** \C <br/> <i><b>POSIBLES CENTROS DE PELADO </b></i><br/>
Dado que esta tarea es un manipulado, se obtienen todos los centros existentes sin restricciones<br/>
Parámetros necesarios:<br/>
GramajeParam<br/>
Variantes obtenidas:<br/>
Nodos TipoPeladoraParam para todas las peladoras posibles
@param  xmlProceso: Nodo XML del proceso
@param  valor: Nodo de opciones
\end */
function artesG_opcionesTipoPeladora(xmlProceso: FLDomNode): FLDomNode {
  // debug("artesG_opcionesTipoPeladora");
  var util: FLUtil = new FLUtil;

  var opcionesTP: FLDomDocument = new FLDomDocument;
  var contenido: String = "<TipoPeladoraVar>\n"

  var qryPeladoras: FLSqlQuery = new FLSqlQuery;
  with(qryPeladoras)
  {
    setTablesList("pr_tiposcentrocoste");
    setSelect("codtipocentro, parametros");
    setFrom("pr_tiposcentrocoste");
    setWhere("tipoag = 'Peladora'");
    setForwardOnly(true);
  }
  if (!qryPeladoras.exec())
  {
    return false;
  }

  var paramPela: FLDomNode;
  var ePela: FLDomElement;
  var nombrePela: String;
  while (qryPeladoras.next())
  {
    // debug(qryPlastificadoras.value("codtipocentro"));
    nombrePela = qryPeladoras.value("codtipocentro");
    //    paramPela = this.iface.dameParamCentroCoste(nombrePela);
    //    if (!paramPela) {
    //      return false;
    //    }
    //    ePela = paramPela.toElement();

    contenido += "\t<TipoPeladoraParam Valor=\"" + nombrePela + "\" />\n";
  }
  contenido += "</TipoPeladoraVar>";
  if (!opcionesTP.setContent(contenido))
  {
    return false;
  }

  return opcionesTP.firstChild();
}

/** \C <br/> <i><b>POSIBLES PLEGADORAS</b></i><br/>
Se desechan aquellas para las que el área máxima o mínima no sea suficienta para los pliegos de papel, así como aquellas que no permiten realizar los pliegues previstos<br/>
Parámetros necesarios:<br/>
GramajeParam<br/>
Variantes obtenidas:<br/>
Nodos TipoPlastificadoraParam para todas las plastificadoras posibles
@param  xmlProceso: Nodo XML del proceso
@param  valor: Nodo de opciones
\end */
function artesG_opcionesTipoPlegadora(xmlProceso: FLDomNode): FLDomNode {
  // debug("artesG_opcionesTipoPlegadora");
  var util: FLUtil = new FLUtil;

  var opcionesTD: FLDomDocument = new FLDomDocument;
  var contenido: String = "<TipoPlegadoraVar>\n"

  var gramaje: Number = parseInt(this.iface.dameAtributoXML(xmlProceso, "Parametros/GramajeParam@Valor"));
  var qryPlegadoras: FLSqlQuery = new FLSqlQuery;
  with(qryPlegadoras)
  {
    setTablesList("pr_tiposcentrocoste");
    setSelect("codtipocentro, parametros");
    setFrom("pr_tiposcentrocoste");
    setWhere("tipoag = 'Plegadora'");
    setForwardOnly(true);
  }
  if (!qryPlegadoras.exec())
    return false;

  var paramDob: FLDomNode;
  var areaMin: String;
  var areaMax: String;
  var eDob: FLDomElement;
  var nombreDob: String;
  while (qryPlegadoras.next())
  {
    // debug(qryPlegadoras.value("codtipocentro"));
    nombreDob = qryPlegadoras.value("codtipocentro");
    paramDob = this.iface.dameParamCentroCoste(nombreDob);
    if (!paramDob)
      return false;

    eDob = paramDob.toElement();

    //areaMin = eImpresora.attribute("AnchoMin") + "x" + eImpresora.attribute("AltoMin");
    //areaMax = eImpresora.attribute("AnchoMax") + "x" + eImpresora.attribute("AltoMax");
    contenido += "\t<TipoPlegadoraParam Valor=\"" + nombreDob + "\" />\n";
  }
  contenido += "</TipoPlegadoraVar>";
  if (!opcionesTD.setContent(contenido))
    return false;

  return opcionesTD.firstChild();
}

/** \C <br/> <i><b>POSIBLES GRAPADORAS</b></i><br/>
Se desechan aquellas para las que el área máxima o mínima no sea suficienta para las dimensiones del libro cerrado, así como aquellas cuyo espesor máximo es menor que el espesor del libro<br/>
Variantes obtenidas:<br/>
Nodos TipoGrapadoraParam para todas las grapadoras posibles
@param  xmlProceso: Nodo XML del proceso
@param  valor: Nodo de opciones
\end */
function artesG_opcionesTipoGrapadora(xmlProceso: FLDomNode): FLDomNode {
  // debug("artesG_opcionesTipoGrapadora");
  var util: FLUtil = new FLUtil;

  var opcionesTG: FLDomDocument = new FLDomDocument;
  var contenido: String = "<TipoGrapadoraVar>\n"

  var qryGrapadoras: FLSqlQuery = new FLSqlQuery;
  with(qryGrapadoras)
  {
    setTablesList("pr_tiposcentrocoste");
    setSelect("codtipocentro, parametros");
    setFrom("pr_tiposcentrocoste");
    setWhere("tipoag = 'Grapadora de mesa'");
    setForwardOnly(true);
  }
  if (!qryGrapadoras.exec())
  {
    return false;
  }

  var areaLibro: String = this.iface.dameAtributoXML(xmlProceso, "Parametros/AreaTrabajoParam@Cerrado");
  var dimLibro: Array = areaLibro.split("x");
  var anchoLibro: Number = dimLibro[0];
  var altoLibro: Number = dimLibro[1];

  var anchoLomo: Number = parseFloat(this.iface.dameAtributoXML(xmlProceso, "Parametros/AnchoLomoParam@Valor"));
  var paramGra: FLDomNode;
  var altoMin: Number;
  var altoMax: Number;
  var anchoMin: Number;
  var anchoMax: Number;
  var espesorMax: Number;
  var eDob: FLDomElement;
  var nombreGra: String;
  while (qryGrapadoras.next())
  {
    // debug(qryGrapadoras.value("codtipocentro"));
    nombreGra = qryGrapadoras.value("codtipocentro");
    paramGra = this.iface.dameParamCentroCoste(nombreGra);
    if (!paramGra) {
      return false;
    }
    eGra = paramGra.toElement();

    altoMin = parseFloat(eGra.attribute("AltoMin"));
    altoMax = parseFloat(eGra.attribute("AltoMax"));
    if (altoLibro > altoMax || altoLibro < altoMin) {
      continue;
    }
    anchoMin = parseFloat(eGra.attribute("AnchoMin"));
    anchoMax = parseFloat(eGra.attribute("AnchoMax"));
    if (anchoLibro > anchoMax || anchoLibro < anchoMin) {
      continue;
    }
    espesorMax = parseFloat(eGra.attribute("EspesorMax"));
    if (anchoLomo > espesorMax) {
      continue;
    }
    contenido += "\t<TipoGrapadoraParam Valor=\"" + nombreGra + "\" />\n";
  }
  contenido += "</TipoGrapadoraVar>";
  if (!opcionesTG.setContent(contenido))
  {
    return false;
  }

  return opcionesTG.firstChild();
}

/** \C <br/> <i><b>POSIBLES MÄQUINAS DE EMBUCHADO + GRAPADO + CORTE</b></i><br/>
Se desechan aquellas para las que el área máxima o mínima no sea suficienta para las dimensiones del libro cerrado, así como aquellas cuyo espesor máximo es menor que el espesor del libro<br/>
Variantes obtenidas:<br/>
Nodos TipoEGCParam para todas las grapadoras posibles
@param  xmlProceso: Nodo XML del proceso
@param  valor: Nodo de opciones
\end */
function artesG_opcionesTipoEGC(xmlProceso: FLDomNode): FLDomNode {
  // debug("artesG_opcionesTipoEGC");
  var util: FLUtil = new FLUtil;

  var opcionesTEGC: FLDomDocument = new FLDomDocument;
  var contenido: String = "<TipoEGCVar>\n"

  var qryEGC: FLSqlQuery = new FLSqlQuery;
  with(qryEGC)
  {
    setTablesList("pr_tiposcentrocoste");
    setSelect("codtipocentro, parametros");
    setFrom("pr_tiposcentrocoste");
    setWhere("tipoag = 'E+G+C'");
    setForwardOnly(true);
  }
  if (!qryEGC.exec())
  {
    return false;
  }

  var areaLibro: String = this.iface.dameAtributoXML(xmlProceso, "Parametros/AreaTrabajoParam@Cerrado");
  var dimLibro: Array = areaLibro.split("x");
  var anchoLibro: Number = dimLibro[0];
  var altoLibro: Number = dimLibro[1];

  var anchoLomo: Number = parseFloat(this.iface.dameAtributoXML(xmlProceso, "Parametros/AnchoLomoParam@Valor"));
  var paramGra: FLDomNode;
  var altoMin: Number;
  var altoMax: Number;
  var anchoMin: Number;
  var anchoMax: Number;
  var espesorMax: Number;
  var eDob: FLDomElement;
  var nombreGra: String;
  while (qryEGC.next())
  {
    // debug(qryEGC.value("codtipocentro"));
    nombreGra = qryEGC.value("codtipocentro");
    paramGra = this.iface.dameParamCentroCoste(nombreGra);
    if (!paramGra) {
      return false;
    }
    eGra = paramGra.toElement();

    altoMin = parseFloat(eGra.attribute("AltoMin"));
    altoMax = parseFloat(eGra.attribute("AltoMax"));
    if (altoLibro > altoMax || altoLibro < altoMin) {
      continue;
    }
    anchoMin = parseFloat(eGra.attribute("AnchoMin"));
    anchoMax = parseFloat(eGra.attribute("AnchoMax"));
    if (anchoLibro > anchoMax || anchoLibro < anchoMin) {
      continue;
    }
    espesorMax = parseFloat(eGra.attribute("EspesorMaxGrapa"));
    if (anchoLomo > espesorMax) {
      continue;
    }
    contenido += "\t<TipoEGCParam Valor=\"" + nombreGra + "\" />\n";
  }
  contenido += "</TipoEGCVar>";
  if (!opcionesTEGC.setContent(contenido))
  {
    return false;
  }

  return opcionesTEGC.firstChild();
}

/** \C <br/> <i><b>POSIBLES ALZADORAS</b></i><br/>
Se desechan aquellas para las que el área máxima o mínima no sea suficienta para las dimensiones del libro cerrado<br/>
Variantes obtenidas:<br/>
Nodos TipoEGCParam para todas las grapadoras posibles
@param  xmlProceso: Nodo XML del proceso
@param  valor: Nodo de opciones
\end */
function artesG_opcionesTipoAlzadora(xmlProceso: FLDomNode): FLDomNode {
  // debug("artesG_opcionesTipoAlzadora");
  var util: FLUtil = new FLUtil;

  var opcionesTAlzadora: FLDomDocument = new FLDomDocument;
  var contenido: String = "<TipoAlzadoraVar>\n"

  var qryAlzadora: FLSqlQuery = new FLSqlQuery;
  with(qryAlzadora)
  {
    setTablesList("pr_tiposcentrocoste");
    setSelect("codtipocentro, parametros");
    setFrom("pr_tiposcentrocoste");
    setWhere("tipoag = 'Alzadora'");
    setForwardOnly(true);
  }
  if (!qryAlzadora.exec())
  {
    return false;
  }

  var idTipoProceso: String = xmlProceso.parentNode().toElement().attribute("IdTipoProceso");
  var areaTrabajo: String;
  switch (idTipoProceso)
  {
    case "TACO": {
      areaTrabajo = this.iface.dameAtributoXML(xmlProceso, "Parametros/AreaTrabajoParam@Valor");
      break;
    }
    default: {
      areaTrabajo = this.iface.dameAtributoXML(xmlProceso, "Parametros/AreaTrabajoParam@Abierto");
    }
  }

  var dimTrabajo: Array = areaTrabajo.split("x");
  var anchoTrabajo: Number = dimTrabajo[0];
  var altoTrabajo: Number = dimTrabajo[1];

  var paramGra: FLDomNode;
  var altoMin: Number;
  var altoMax: Number;
  var anchoMin: Number;
  var anchoMax: Number;
  var espesorMax: Number;
  var eDob: FLDomElement;
  var nombreGra: String;
  while (qryAlzadora.next())
  {
    nombreGra = qryAlzadora.value("codtipocentro");
    paramGra = this.iface.dameParamCentroCoste(nombreGra);
    if (!paramGra) {
      return false;
    }
    eGra = paramGra.toElement();

    altoMin = parseFloat(eGra.attribute("AltoMin"));
    altoMax = parseFloat(eGra.attribute("AltoMax"));
    if (altoTrabajo > altoMax || altoTrabajo < altoMin) {
      continue;
    }
    anchoMin = parseFloat(eGra.attribute("AnchoMin"));
    anchoMax = parseFloat(eGra.attribute("AnchoMax"));
    if (anchoTrabajo > anchoMax || anchoTrabajo < anchoMin) {
      continue;
    }
    contenido += "\t<TipoAlzadoraParam Valor=\"" + nombreGra + "\" />\n";
  }
  contenido += "</TipoAlzadoraVar>";
  if (!opcionesTAlzadora.setContent(contenido))
  {
    return false;
  }

  return opcionesTAlzadora.firstChild();
}

/** \C <br/> <i><b>POSIBLES GUILLOTINAS PARA PRECORTE ALZADO</b></i><br/>
Variantes obtenidas:<br/>
Nodos TipoGuillotinaPAParam para todas las guillotinas posibles
@param  xmlProceso: Nodo XML del proceso
@param  valor: Nodo de opciones
\end */
function artesG_opcionesTipoGuillotinaPA(xmlProceso: FLDomNode): FLDomNode {
  // debug("artesG_opcionesGuillotinaPA");
  var util: FLUtil = new FLUtil;

  var areaLibro: String = this.iface.dameAtributoXML(xmlProceso, "Parametros/AreaTrabajoParam@Abierto");
  var dimLibro: Array = areaLibro.split("x");
  var anchoLibro: Number = dimLibro[0];
  var altoLibro: Number = dimLibro[1];
  var maxPP: Number = 0;
  var xmlProducto: FLDomNode = xmlProceso.parentNode();
  //  var opcion:String = xmlProducto.toElement().attribute("Opcion");
  //  var nodoCombi:FLDomNode = flfacturac.iface.pub_dameNodoXML(xmlProceso, "Parametros/CombEncuadernacionParam/Combinacion[@Opcion=" + opcion + "]");
  var nodoCombi: FLDomNode = flfacturac.iface.pub_dameNodoXML(xmlProceso, "Parametros/CombEncuadernacionParam/Combinacion");
  var pliegosPlegado: FLDomNodeList = nodoCombi.childNodes();
  var paginasPliego: Number;
  for (var i: Number = 0; i < pliegosPlegado.length(); i++)
  {
    paginasPliego = parseInt(pliegosPlegado.item(i).toElement().attribute("PaginasPliego"));
    if (paginasPliego > maxPP) {
      maxPP = paginasPliego;
    }
  }
  switch (maxPP)
  {
    case 4: {
      break;
    }
    case 8: {
      altoLibro = altoLibro * 2; /// Tener en cuenta orientación
      break;
    }
    case 16: {
      altoLibro = altoLibro * 2;
      anchoLibro = anchoLibro * 2;
      break;
    }
  }
  var nodoVariantes: FLDomNode = this.iface.opcionesGuillotina("TipoGuillotinaPA", altoLibro, anchoLibro);
  if (!nodoVariantes)
  {
    return false;
  }
  return nodoVariantes;
}

/** \C <br/> <i><b>POSIBLES GUILLOTINAS PARA PRECORTE WIRE-O</b></i><br/>
Variantes obtenidas:<br/>
Nodos TipoGuillotinaPWOParam para todas las guillotinas posibles
@param  xmlProceso: Nodo XML del proceso
@param  valor: Nodo de opciones
\end */
function artesG_opcionesTipoGuillotinaPWO(xmlProceso: FLDomNode): FLDomNode {
  // debug("artesG_opcionesGuillotinaPWO");
  var util: FLUtil = new FLUtil;

  var areaLibro: String = this.iface.dameAtributoXML(xmlProceso, "Parametros/AreaTrabajoParam@Abierto");
  var dimLibro: Array = areaLibro.split("x");
  var anchoLibro: Number = dimLibro[0];
  var altoLibro: Number = dimLibro[1];
  var maxPP: Number = 0;
  var xmlProducto: FLDomNode = xmlProceso.parentNode();
  var opcion: String = xmlProducto.toElement().attribute("Opcion");
  var nodoCombi: FLDomNode = flfacturac.iface.pub_dameNodoXML(xmlProceso, "Parametros/CombEncuadernacionParam/Combinacion[@Opcion=" + opcion + "]");
  var pliegosPlegado: FLDomNodeList = nodoCombi.childNodes();
  var paginasPliego: Number;
  for (var i: Number = 0; i < pliegosPlegado.length(); i++)
  {
    paginasPliego = parseInt(pliegosPlegado.item(i).toElement().attribute("PaginasPliego"));
    if (paginasPliego > maxPP) {
      maxPP = paginasPliego;
    }
  }
  switch (maxPP)
  {
    case 4: {
      break;
    }
    case 8: {
      altoLibro = altoLibro * 2; /// Tener en cuenta orientación
      break;
    }
    case 16: {
      altoLibro = altoLibro * 2;
      anchoLibro = anchoLibro * 2;
      break;
    }
  }
  var nodoVariantes: FLDomNode = this.iface.opcionesGuillotina("TipoGuillotinaPWO", altoLibro, anchoLibro);
  if (!nodoVariantes)
  {
    return false;
  }
  return nodoVariantes;
}

/** \C <br/> <i><b>POSIBLES GUILLOTINAS PARA POSCORTE WIRE-O</b></i><br/>
Variantes obtenidas:<br/>
Nodos TipoGuillotinaPWOParam para todas las guillotinas posibles
@param  xmlProceso: Nodo XML del proceso
@param  valor: Nodo de opciones
\end */
function artesG_opcionesTipoGuillotinaPOSWO(xmlProceso: FLDomNode): FLDomNode {
  // debug("artesG_opcionesGuillotinaPOSWO");
  var util: FLUtil = new FLUtil;

  var areaLibro: String = this.iface.dameAtributoXML(xmlProceso, "Parametros/AreaTrabajoParam@Cerrado");
  var dimLibro: Array = areaLibro.split("x");
  var anchoLibro: Number = dimLibro[0];
  var altoLibro: Number = dimLibro[1];

  var nodoVariantes: FLDomNode = this.iface.opcionesGuillotina("TipoGuillotinaPOSWO", altoLibro, anchoLibro);
  if (!nodoVariantes)
  {
    return false;
  }
  return nodoVariantes;
}

/** \C <br/> <i><b>POSIBLES GUILLOTINAS PARA CORTE TRILATERAL</b></i><br/>
Variantes obtenidas:<br/>
Nodos TipoGuillotinaPWOParam para todas las guillotinas posibles
@param  xmlProceso: Nodo XML del proceso
@param  valor: Nodo de opciones
\end */
function artesG_opcionesTipoGuillotinaTri(xmlProceso: FLDomNode): FLDomNode {
  // debug("artesG_opcionesGuillotinaTri");
  var util: FLUtil = new FLUtil;

  var areaLibro: String = this.iface.dameAtributoXML(xmlProceso, "Parametros/AreaTrabajoParam@Cerrado");
  var dimLibro: Array = areaLibro.split("x");
  var anchoLibro: Number = dimLibro[0];
  var altoLibro: Number = dimLibro[1];

  var nodoVariantes: FLDomNode = this.iface.opcionesGuillotina("TipoGuillotinaTri", altoLibro, anchoLibro);
  if (!nodoVariantes)
  {
    return false;
  }
  return nodoVariantes;
}
/** \C <br/> <i><b>POSIBLES ENCUADERNADORAS WIRE-O</b></i><br/>
Variantes obtenidas:<br/>
Nodos TipoMaquinaWireOParam para todas las guillotinas posibles
@param  xmlProceso: Nodo XML del proceso
@param  valor: Nodo de opciones
\end */
function artesG_opcionesTipoMaquinaWireO(xmlProceso: FLDomNode): FLDomNode {
  // debug("artesG_opcionesTipoMaquinaWireOParam");
  var util: FLUtil = new FLUtil;

  var opcionesWireO: FLDomDocument = new FLDomDocument;
  var contenido: String = "<TipoMaquinaWireOVar>\n"

  var qryWireO: FLSqlQuery = new FLSqlQuery;
  with(qryWireO)
  {
    setTablesList("pr_tiposcentrocoste");
    setSelect("codtipocentro, parametros");
    setFrom("pr_tiposcentrocoste");
    setWhere("tipoag = 'Wire-o'");
    setForwardOnly(true);
  }
  if (!qryWireO.exec())
  {
    return false;
  }

  var altoMin: Number;
  var altoMax: Number;
  var anchoMin: Number;
  var anchoMax: Number;
  var espesorMax: Number;
  var eWireO: FLDomElement;
  var nombreWireO: String;
  var paramWireO: FLDomNode;
  while (qryWireO.next())
  {
    nombreWireO = qryWireO.value("codtipocentro");
    //    paramWireO = this.iface.dameParamCentroCoste(nombreWireO);
    //    if (!paramWireO) {
    //      return false;
    //    }
    //    eWireO = paramWireO.toElement();
    //
    //    altoMin = parseFloat(eWireO.attribute("AltoMin"));
    //    altoMax = parseFloat(eWireO.attribute("AltoMax"));
    //    if (alto > altoMax || alto < altoMin) {
    // debug("alto");
    //      continue;
    //    }
    //    anchoMin = parseFloat(eWireO.attribute("AnchoMin"));
    //    anchoMax = parseFloat(eWireO.attribute("AnchoMax"));
    //    if (ancho > anchoMax || ancho < anchoMin) {
    // debug("ancho");
    //      continue;
    //    }
    contenido += "\t<TipoMaquinaWireOParam Valor=\"" + nombreWireO + "\" />\n";
  }
  contenido += "</TipoMaquinaWireOVar>";
  // debug("contenido = " + contenido );
  if (!opcionesWireO.setContent(contenido))
  {
    return false;
  }

  return opcionesWireO.firstChild();
}

/** \C <br/> <i><b>POSIBLES ENCUADERNADORAS (FRESADO Y RÚSTICA)</b></i><br/>
Variantes obtenidas:<br/>
Nodos TipoMaquinaWireOParam para todas las guillotinas posibles
@param  xmlProceso: Nodo XML del proceso
@param  valor: Nodo de opciones
\end */
function artesG_opcionesTipoEncuadernadora(xmlProceso: FLDomNode): FLDomNode {
  // debug("artesG_opcionesTipoEncuadernadora");
  var util: FLUtil = new FLUtil;

  var opcionesTE: FLDomDocument = new FLDomDocument;
  var contenido: String = "<TipoEncuadernadoraVar>\n"

  var qryTE: FLSqlQuery = new FLSqlQuery;
  with(qryTE)
  {
    setTablesList("pr_tiposcentrocoste");
    setSelect("codtipocentro, parametros, tipotrabajo");
    setFrom("pr_tiposcentrocoste");
    setWhere("tipoag = 'Encuadernadora'");
    setForwardOnly(true);
  }
  if (!qryTE.exec())
  {
    return false;
  }

  var altoMin: Number;
  var altoMax: Number;
  var anchoMin: Number;
  var anchoMax: Number;
  var espesorMax: Number;
  var eTE: FLDomElement;
  var nombreTE: String;
  var paramTE: FLDomNode;
  while (qryTE.next())
  {
    nombreTE = qryTE.value("codtipocentro");
    if (qryTE.value("tipotrabajo") == "Trabajo externo") {
      contenido += "\t<TipoEncuadernadoraParam Valor=\"" + nombreTE + "\" TipoTrabajo=\"Trabajo externo\"/>\n";
    } else {

      //    paramWireO = this.iface.dameParamCentroCoste(nombreWireO);
      //    if (!paramWireO) {
      //      return false;
      //    }
      //    eWireO = paramWireO.toElement();
      //
      //    altoMin = parseFloat(eWireO.attribute("AltoMin"));
      //    altoMax = parseFloat(eWireO.attribute("AltoMax"));
      //    if (alto > altoMax || alto < altoMin) {
      // debug("alto");
      //      continue;
      //    }
      //    anchoMin = parseFloat(eWireO.attribute("AnchoMin"));
      //    anchoMax = parseFloat(eWireO.attribute("AnchoMax"));
      //    if (ancho > anchoMax || ancho < anchoMin) {
      // debug("ancho");
      //      continue;
      //    }
      contenido += "\t<TipoEncuadernadoraParam Valor=\"" + nombreTE + "\" />\n";
    }
  }
  contenido += "</TipoEncuadernadoraVar>";
  // debug("contenido = " + contenido );
  if (!opcionesTE.setContent(contenido))
  {
    return false;
  }

  return opcionesTE.firstChild();
}

/** \C <br/> <i><b>POSIBLES AGENCIAS DE TRANSPORTE</b></i><br/>
Variantes obtenidas:<br/>
Nodos AgenciaTransporeParam para todas las agencias posibles
@param  xmlProceso: Nodo XML del proceso
@param  valor: Nodo de opciones
\end */
function artesG_opcionesAgenciaTransporte(xmlProceso: FLDomNode): FLDomNode {
  // debug("artesG_opcionesAgenciaTransporte");
  var util: FLUtil = new FLUtil;

  var opcionesAT: FLDomDocument = new FLDomDocument;
  var contenido: String = "<AgenciaTransporteVar>\n"

  var qryAT: FLSqlQuery = new FLSqlQuery;
  with(qryAT)
  {
    setTablesList("agenciastrans");
    setSelect("codagencia");
    setFrom("agenciastrans");
    setWhere("1 = 1");
    setForwardOnly(true);
  }
  if (!qryAT.exec())
  {
    return false;
  }

  //  var altoMin:Number;
  //  var altoMax:Number;
  //  var anchoMin:Number;
  //  var anchoMax:Number;
  //  var espesorMax:Number;
  //  var eTE:FLDomElement;
  var nombreAT: String;
  var paramAT: FLDomNode;
  while (qryAT.next())
  {
    nombreAT = qryAT.value("codagencia");
    contenido += "\t<AgenciaTransporteParam Valor=\"" + nombreAT + "\"/>\n";
  }
  contenido += "</AgenciaTransporteVar>";
  // debug("contenido = " + contenido );
  if (!opcionesAT.setContent(contenido))
  {
    return false;
  }

  return opcionesAT.firstChild();
}

function artesG_opcionesGuillotina(nombre: String, alto: Number, ancho: Number): FLDomNode {
  // debug("artesG_opcionesGuillotina " + nombre + " " + alto + " " + ancho);
  var opcionesGuillotina: FLDomDocument = new FLDomDocument;
  var contenido: String = "<" + nombre + "Var>\n"

  var qryGuillotina: FLSqlQuery = new FLSqlQuery;
  with(qryGuillotina)
  {
    setTablesList("pr_tiposcentrocoste");
    setSelect("codtipocentro, parametros");
    setFrom("pr_tiposcentrocoste");
    setWhere("tipoag = 'Guillotina'");
    setForwardOnly(true);
  }
  if (!qryGuillotina.exec())
  {
    return false;
  }

  var altoMin: Number;
  var altoMax: Number;
  var anchoMin: Number;
  var anchoMax: Number;
  var espesorMax: Number;
  var eGui: FLDomElement;
  var nombreGui: String;
  while (qryGuillotina.next())
  {
    nombreGui = qryGuillotina.value("codtipocentro");
    paramGui = this.iface.dameParamCentroCoste(nombreGui);
    if (!paramGui) {
      return false;
    }
    eGui = paramGui.toElement();

    altoMin = parseFloat(eGui.attribute("AltoMin"));
    altoMax = parseFloat(eGui.attribute("AltoMax"));
    if (alto > altoMax || alto < altoMin) {
      // debug("alto");
      continue;
    }
    anchoMin = parseFloat(eGui.attribute("AnchoMin"));
    anchoMax = parseFloat(eGui.attribute("AnchoMax"));
    if (ancho > anchoMax || ancho < anchoMin) {
      // debug("ancho");
      continue;
    }
    contenido += "\t<" + nombre + "Param Valor=\"" + nombreGui + "\" />\n";
  }
  contenido += "</" + nombre + "Var>";
  // debug("contenido = " + contenido );
  if (!opcionesGuillotina.setContent(contenido))
  {
    return false;
  }

  return opcionesGuillotina.firstChild();
}

/** \C <br/> <i><b>POSIBLES SIGUIENTES TAREAS</b></i><br/>
Esta variante se usa para crear clones del proceso que indican cuál es la siguiente tarea a realizar. Se usa en puntos en los que el proceso se bifurca y hay que evaluar cada rama por separado<br/>
Parámetros necesarios:<br/>
Variantes obtenidas:<br/>
Nodos SiguienteTarea para todas las tareas compatibles con e proceso
@param  xmlProceso: Nodo XML del proceso
@param  valor: Nodo de opciones
\end */
function artesG_opcionesSiguienteTarea(xmlProceso: FLDomNode): FLDomNode {
  // debug("artesG_opcionesSiguienteTarea");
  var util: FLUtil = new FLUtil;
  var idTipoProceso: String = xmlProceso.parentNode().toElement().attribute("IdTipoProceso");
  var idTipoTarea: String = xmlProceso.toElement().attribute("IdTipoTareaActual");
  var idTipoTareaPro: String = xmlProceso.toElement().attribute("IdTipoTareaProActual");

  var opcionesTD: FLDomDocument = new FLDomDocument;
  var contenido: String = "<SiguienteTareaVar>\n"

  var qrySiguienteTarea: FLSqlQuery = new FLSqlQuery;
  with(qrySiguienteTarea)
  {
    setTablesList("pr_secuencias,pr_tipostareapro");
    setSelect("s.tareafin, ttp.idtipotarea");
    setFrom("pr_secuencias s INNER JOIN pr_tipostareapro ttp ON s.tareafin = ttp.idtipotareapro");
    setWhere("s.tareainicio = " + idTipoTareaPro);
    setForwardOnly(true);
  }
  if (!qrySiguienteTarea.exec())
  {
    return false;
  }

  var idSiguienteTarea: String;
  var idTipoTarea: String;
  while (qrySiguienteTarea.next())
  {
    idSiguienteTarea = qrySiguienteTarea.value("s.tareafin");
    idTipoTarea = qrySiguienteTarea.value("ttp.idtipotarea");
    if (!this.iface.compatibleTareaProceso(xmlProceso, idTipoTarea)) {
      continue;
    }
    /// Por hacer: Definir grupos de siguientes tarea (no sólo una tarea por param)
    contenido += "\t<SiguienteTarea IdTipoTarea=\"" + idTipoTarea + "\" IdTipoTareaPro=\"" + idSiguienteTarea + "\" />\n";
  }

  contenido += "</SiguienteTareaVar>";
  if (!opcionesTD.setContent(contenido))
    return false;

  return opcionesTD.firstChild();
}

function artesG_compatibleTareaProceso(xmlProceso: FLDomNode, idTipoTareaSiguiente: String): Boolean {
  var idTipoTareaActual: String = xmlProceso.toElement().attribute("IdTipoTareaActual");
  var codTipoTareaProActual: String = xmlProceso.toElement().attribute("CodTipoTareaProActual");
  var compatible: Boolean;
  var tarea: String = ((codTipoTareaProActual && codTipoTareaProActual != "") ? codTipoTareaProActual : idTipoTareaActual);
  debug("TAREA COMPATIBLE -------------------------------------------------_> " + tarea);
  switch (tarea)
  {
    case "?ENCUADERNACION": {
      var encuadernacion: String = this.iface.dameAtributoXML(xmlProceso, "Parametros/EncuadernacionParam@Tipo");
      switch (idTipoTareaSiguiente) {
        case "EMBUCHADO": {
          switch (encuadernacion) {
            case "Rústica":
            case "Fresado": {
              compatible = false;
              break;
            }
            default: {
              compatible = true;
            }
          }
          break;
        }
        case "E+G+C": {
          switch (encuadernacion) {
            case "Rústica":
            case "Fresado": {
              compatible = false;
              break;
            }
            default: {
              compatible = true;
            }
          }
          break;
        }
        case "PRECORTE ALZADO": {
          switch (encuadernacion) {
            case "Rústica":
            case "Fresado": {
              compatible = false;
              break;
            }
            default: {
              compatible = true;
            }
          }
          break;
        }
        case "ENCUADERNADO": {
          switch (encuadernacion) {
            case "Wire-o":
            case "Grapado": {
              compatible = false;
              break;
            }
            default: {
              compatible = true;
            }
          }
          break;
        }
      }
      break;
    }
    case "?WIRE-O": {
      var encuadernacion: String = this.iface.dameAtributoXML(xmlProceso, "Parametros/EncuadernacionParam@Tipo");
      // debug(idTipoTareaActual + " --> " + idTipoTareaSiguiente + " (" + encuadernacion + ")");
      switch (idTipoTareaSiguiente) {
        case "PRECORTE W-O": {
          switch (encuadernacion) {
            case "Wire-o": {
              compatible = true;
              break;
            }
            default: {
              compatible = false;
            }
          }
          break;
        }
        case "GRAPADO": {
          switch (encuadernacion) {
            case "Wire-o": {
              compatible = false;
              break;
            }
            default: {
              compatible = true;
            }
          }
          break;
        }
      }
      break;
    }
    case "?WIRE-O2": {
      var encuadernacion: String = this.iface.dameAtributoXML(xmlProceso, "Parametros/EncuadernacionParam@Tipo");
      // debug(idTipoTareaActual + " --> " + idTipoTareaSiguiente + " (" + encuadernacion + ")");
      switch (idTipoTareaSiguiente) {
        case "WIRE-O2": {
          switch (encuadernacion) {
            case "Wire-o": {
              compatible = true;
              break;
            }
            default: {
              compatible = false;
            }
          }
          break;
        }
        case "GRAPADO2": {
          switch (encuadernacion) {
            case "Wire-o": {
              compatible = false;
              break;
            }
            default: {
              compatible = true;
            }
          }
          break;
        }
      }
      break;
    }
    case "TACO_?TACO_PEGADO": {
      var tipoTaco: String = this.iface.dameAtributoXML(xmlProceso, "Parametros/PaginasParam@TipoTaco");
      switch (idTipoTareaSiguiente) {
        case "PRECORTE_ENGOMADO": {
          compatible = (tipoTaco != "Grapado y perforado");
          break;
        }
        case "PERFORADO": {
          compatible = (tipoTaco == "Grapado y perforado");
          break;
        }
      }
      break;
    }
  }

  return compatible;
}

/** \C <br/> <i><b>POSIBLES DISTRIBUCIONES DE TRABAJOS EN PLANCHA</b></i><br/>
Se obtienen las distribuciones para distinto número de planchas. Se parte de un mínimo calculado como el número de modelos del trabajo / trabajos por plancha, y se va incrementando hasta que la distribución obtenida tenga una eficiencia del 100%.<br/>
Parámetros necesarios:<br/>
La eficiencia de una distribución se calcula dividiendo los trabajos realmente distribuidos en todas las planchas entre el número máximo de trabajos que pueden distribuirse<br/>
TipoImpresoraParam<br/>
EstiloImpresionParam<br/>
PaginasParam<br/>
Variantes obtenidas:<br/>
Nodos DistPlanchaParam para todas las distribuciones posibles
@param  xmlProceso: Nodo XML del proceso
@param  valor: Nodo de opciones
\end */
function artesG_opcionesDistPlanchas(xmlProceso: FLDomNode): FLDomNode {
  var util: FLUtil = new FLUtil;

  var opcionesDP: FLDomDocument = new FLDomDocument;
  opcionesDP.setContent("<DistPlanchaVar/>");

  var numPaginas: Number = parseInt(this.iface.dameAtributoXML(xmlProceso, "Parametros/PaginasParam@NumPaginas"));
  var totalTP: Number = parseInt(this.iface.dameAtributoXML(xmlProceso, "Parametros/TrabajosPliegoParam@NumTrabajos"));
  var numPlanchas = Math.ceil(numPaginas / totalTP);

  var xmlOpcion: FLDomNode;
  var xmlOpcionColor: FLDomNode;
  var planchasExtra: Number = 0;

  var iControl: Number = 0;
  do {
    xmlOpcion = this.iface.distribuirPlanchas(xmlProceso, planchasExtra);
    // debug(0);
    if (!xmlOpcion)
      return false;
    // debug(1);

    planchasExtra++;

    /// Revisar
    //    if (!this.iface.calcularPasadasPorPlancha(xmlOpcion, xmlProceso))
    //      return false;
    // debug(2);
    xmlOpcionColor = this.iface.planchasPorColor(xmlOpcion, xmlProceso);
    //    if (!xmlOpcionColor)
    //      return false;
    // debug(3);
    opcionesDP.firstChild().appendChild(xmlOpcionColor.cloneNode());
    // opcionesDP.firstChild().appendChild(xmlOpcion.cloneNode());

    if (++iControl > numPaginas)
    {
      MessageBox.warning(util.translate("scripts", "Error al obtener las posibles distribuciones para uno de los procesos"), MessageBox.Ok, MessageBox.NoButton);
      return false;
    }
  } while (parseFloat(xmlOpcion.toElement().attribute("Eficiencia")) < "95" && (numPlanchas + planchasExtra) < numPaginas);
  // debug(opcionesDP.toString());
  return opcionesDP.firstChild();
}

function artesG_distribuirPlanchas(xmlProceso: FLDomNode, planchasExtra: Number): FLDomNode {
  var distri: FLDomDocument = new FLDomDocument;

  var nodoPaginas: FLDomNode = this.iface.dameNodoXML(xmlProceso, "Parametros/PaginasParam", true);
  var numPaginas: Number = parseInt(nodoPaginas.toElement().attribute("NumPaginas"));
  // debug("numPaginas = " + numPaginas);
  var nodoTrabajosPliego: FLDomNode = this.iface.dameNodoXML(xmlProceso, "Parametros/TrabajosPliegoParam");
  var nombreNumeros: Boolean = (this.iface.dameAtributoXML(xmlProceso, "Parametros/NombrePaginaParam@Valor") == "Numero" || numPaginas > 25);
  var nodosTrabajoPliego: FLDomNodeList = nodoTrabajosPliego.toElement().elementsByTagName("Trabajo");
  var totalTP: Number = nodosTrabajoPliego.length();

  var cantidadesPorModelo: Boolean = (this.iface.dameAtributoXML(xmlProceso, "Parametros/PaginasParam@CantidadesPorModelo") == "true");
  var rellenar: Boolean;
  if (cantidadesPorModelo)
  {
    rellenar = true;
  } else {
    rellenar = false;
  }

  /// Cuando el troquel es simétrico el trabajo admite tira retira aunque el número de trabajos por pliegos sea 1
  var troquelSimetrico: Boolean = this.iface.troqueladoSimetrico(xmlProceso);

  var estiloImpresion: String = this.iface.dameAtributoXML(xmlProceso, "Parametros/EstiloImpresionParam@Valor");
  // debug("estiloImpresion = " + estiloImpresion);
  switch (estiloImpresion)
  {
    case "TiraRetira": {
      if (troquelSimetrico) {
        break;
      }
      totalTP = totalTP / 2;
      break;
    }
  }

  // var x:FLDomDocument = new FLDomDocument;
  // x.appendChild(xmlProceso);
  // debug(x.toString(4));
  var numPlanchas = Math.ceil(numPaginas / totalTP);
  numPlanchas += planchasExtra;

  var contenido: String = "";
  var distPlancha: String;
  var distPlanchaSim: String;
  var distPlanchaVuelta: String;
  var iModelo: Number = 0;
  var iModeloPlancha: Number = 0;
  var hayHuecos: Boolean = false;
  var numPaginasPlancha: Number; /// Modelos a usar en la plancha actual
  var numPaginasRestantes: Number = numPaginas; /// Modelos por distibuir
  var factor: Number; /// Número de repeticiones del mismo modelo en la plancha actual
  var numHuecos: Number; /// Número de lugares que quedan vacíos en la plancha
  var nombrePagina: String;
  var nombrePaginaVuelta: String;

  var iPlancha: Number = 1;
  var iPlanchaV: Number = 1;
  var iTrabajoPlancha: Number;
  var iModelo: Number = 0;

  //  var arrayDist:Array = this.iface.dameArrayDist(nodoPaginas);
  //  var arrayDistPlanchas:Array = this.iface.dameArrayDistPlanchas(arrayDist, numPlanchas);
  var distOptima: Array = this.iface.distOptimaModelosPlanchas(nodoPaginas, numPlanchas, totalTP);
  var eficiencia: Number = 0;
  var tirada: Number = 0;
  for (var i: Number = 0; i < distOptima.length; i++)
  {
    //  for (var i:Number = 0; i < numPlanchas; i++) {
    //    var distModelos:Array = this.iface.resolverDistribucionDC(arrayDistPlanchas[i], totalTP, rellenar);
    //    tirada = distModelos.pop();
    //    eficiencia += distModelos.pop();

    eficiencia += distOptima[i].pop();
    tirada = distOptima[i].pop()
             //    if (estiloImpresion == "TiraRetira" && !troquelSimetrico) {
             //      tirada = Math.ceil(tirada / 2;
             //    }

             distPlancha = "\n\t<Plancha Numero=\"" + (iPlancha++) + "\" Cara=\"Frente\" NumPliegos=\"" + tirada + "\" >\n";
    distPlanchaSim = "";
    distPlanchaVuelta = "\n\t<Plancha Numero=\"" + (iPlanchaV++) + "\" Cara=\"Vuelta\" NumPliegos=\"" + tirada + "\" >\n";
    iTrabajoPlancha = 0;

    //    for (var j:Number = 0; j < distModelos.length; j++) {
    for (var j: Number = 0; j < distOptima[i].length; j++) {
      iModelo = distOptima[i][j]["modelo"];
      nombrePagina = this.iface.nombrePagina(iModelo, true, nombreNumeros);
      nombrePaginaVuelta = this.iface.nombrePagina(iModelo, false, nombreNumeros);

      //      for (var k:Number = 0; k < distModelos[j]; k++) {
      for (var k: Number = 0; k < distOptima[i][j]["cantidad"]; k++) {
        distPlancha += "<TrabajoPlancha Pagina=\"" + nombrePagina + "\" IdTrabajo=\"" + nodosTrabajoPliego.item(iTrabajoPlancha).toElement().attribute("Id") + "\" />\n";

        switch (estiloImpresion) {
          case "TiraRetira": {
            if (troquelSimetrico) {
              break;
            }
            distPlanchaSim += "<TrabajoPlancha Pagina=\"" + nombrePaginaVuelta + "\" IdTrabajo=\"" + nodosTrabajoPliego.item(iTrabajoPlancha + totalTP).toElement().attribute("Id") + "\" />\n";
            break;
          }
          case "CaraRetira":
          case "TiraVolteo": {
            distPlanchaVuelta += "<TrabajoPlancha Pagina=\"" + nombrePaginaVuelta + "\" IdTrabajo=\"" + nodosTrabajoPliego.item(iTrabajoPlancha).toElement().attribute("Id") + "\" />\n";
            break;
          }
        }
        iTrabajoPlancha++;
      }
      iModelo++;
    }
    switch (estiloImpresion) {
      case "TiraRetira": {
        distPlancha += "\n" + distPlanchaSim;
        distPlancha += "\n</Plancha>"
                       break;
      }
      case "CaraRetira":
      case "TiraVolteo": {
        distPlancha += "\n</Plancha>";
        distPlancha += distPlanchaVuelta;
        distPlancha += "\n</Plancha>";
        break;
      }
      default: {
        distPlancha += "\n</Plancha>";
      }
    }
    contenido += distPlancha;
  }
  eficiencia = eficiencia / numPlanchas;
  // debug("=============================> eficiencia  = " + eficiencia + "(" + numPlanchas + ")") ;
  contenido = "<DistPlanchaParam Eficiencia=\"" + eficiencia.toString() + "\">\n" + contenido + "\n</DistPlanchaParam>";
  //debug(contenido);


  if (!distri.setContent(contenido))
    return false;
  // if (numPlanchas == 2) {
  // debug(distri.toString(4));
  // return false;
  // }
  return distri.firstChild();
}

/** \C Genera el nombre de la página
@param  indice: Indice de la página
@param  frente: Indica si la página es la frontal de su hoja
@param  numeros: Indica si se usan números o letras
@return nodo XML con la distribución
\end */
function artesG_nombrePagina(indice: Number, frente: Boolean, numeros: Boolean): String {
  var res: String;
  if (numeros)
  {
    if (frente) {
      res = ((indice * 2) + 1).toString();
    } else {
      res = ((indice * 2) + 2).toString();
    }
  } else {
    var arrayLetras: String = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"];
    if (frente)
    {
      res = arrayLetras[indice];
    } else {
      res = arrayLetras[indice] + "'";
    }
  }
  return res;
}

/** \C Calcula el parámetro de NumPasadas para cada nodo Plancha de una distribución
@param  xmlOpcion: XML con la opción de distribución de planchas
@param  xmlProceso: XML con los datos del proceso
\end */
function artesG_calcularPasadasPorPlancha(xmlOpcion: FLDomNode, xmlProceso: FLDomNode): Boolean {
  // var d:FLDomDocument = new FLDomDocument;
  // d.appendChild(xmlOpcion.cloneNode(true));
  // debug("Opción = " + d.toString());

  var xmlOpcionColor: FLDomNode = xmlOpcion.cloneNode(false);

  var numCopias: Number = parseInt(this.iface.dameAtributoXML(xmlProceso, "Parametros/PaginasParam@NumCopias"));
  var cantidadesPorModelo: Boolean = (this.iface.dameAtributoXML(xmlProceso, "Parametros/PaginasParam@CantidadesPorModelo") == "true");

  var estiloImpresion: String = this.iface.dameAtributoXML(xmlProceso, "Parametros/EstiloImpresionParam@Valor");
  var xmlPlanchas: FLDomNodeList = xmlOpcion.toElement().elementsByTagName("Plancha");
  var totalPlanchas: Number = xmlPlanchas.length();
  var ePlancha: FLDomElement;
  var repeticiones: Number;
  //  var numPasadasPlancha:Number;
  var numPliegosPlancha: Number;
  var numPliegos: Number = 0;
  var numPasadas: Number = 0;
  //  var numMaculas:Number = 0;
  var numJuego: Number = -1;
  var totalJuegos: Number = parseInt(xmlOpcion.toElement().attribute("NumJuegos"));

  var nombreImpresora: String = this.iface.dameAtributoXML(xmlProceso, "Parametros/TipoImpresoraParam@Valor");
  var paramImpresora: FLDomNode = this.iface.dameParamCentroCoste(nombreImpresora);
  if (!paramImpresora)
  {
    return false;
  }
  eImpresora = paramImpresora.toElement();

  var nodoTroquelado: FLDomNode = this.iface.dameNodoXML(xmlProceso, "Parametros/TroqueladoParam");
  var troquelado: Boolean = false;
  if (nodoTroquelado)
  {
    troquelado = true;
    //    var troquelSimetrico:Boolean = this.iface.troqueladoSimetrico(xmlProceso);
  }


  var numCuerpos: Number = parseInt(eImpresora.attribute("NumCuerpos"));
  if (isNaN(numCuerpos) || numCuerpos == 0)
  {
    // debug("El número de cuerpos de " + nombreImpresora + " no es un número o es 0");
    return false;
  }
  var coloresJuego: Number = 0;
  var pliegosJuego: Number = 0;
  var pasadasJuego: Number = 0;
  var primeraDelJuego: Boolean;
  debug("totalJuegos = " + totalJuegos);
  for (var iJuego: Number = 1; iJuego <= totalJuegos; iJuego++)
  {
    coloresJuego = 0;
    debug("iJuego = " + iJuego);
    primeraDelJuego = true;
    for (var iPlancha: Number = 0; iPlancha < totalPlanchas; iPlancha++) {
      ePlancha = xmlPlanchas.item(iPlancha).toElement();
      if (iJuego != parseInt(ePlancha.attribute("Juego"))) {
        continue;
      }
      coloresJuego++;
      if (primeraDelJuego) {
        primeraDelJuego = false;
        pliegosJuego = 0;
        pasadasJuego = 0;
        if (cantidadesPorModelo) {
          numPliegosPlancha = parseInt(ePlancha.attribute("NumPliegos"));
        } else {
          repeticiones = this.iface.dameRepeticionesEnPlancha(xmlPlanchas.item(iPlancha));
          if (estiloImpresion == "TiraRetira") { /// && !troquelado) { por orden de Jesús
            numPliegosPlancha = Math.ceil(numCopias / (repeticiones * 2));
          } else {
            numPliegosPlancha = Math.ceil(numCopias / repeticiones);
          }
        }
      }
    }
    debug("coloresJuego = " + coloresJuego);
    if (coloresJuego == 0) {
      continue;
    }
    pliegosJuego = 0;
    pasadasJuego = 0;
    switch (estiloImpresion) {
      case "Simple": {
        pliegosJuego = numPliegosPlancha;
        pasadasJuego = numPliegosPlancha * Math.ceil(coloresJuego / numCuerpos);
        break;
      }
      case "CaraRetira": {
        if (iJuego % 2 != 0) { /// Sólo se contabiliza una de las caras
          pliegosJuego = numPliegosPlancha;
        }
        debug("pliegosJuego " + pliegosJuego);
        pasadasJuego = numPliegosPlancha * Math.ceil(coloresJuego / numCuerpos);
        break;
      }
      case "TiraRetira": {
        pliegosJuego = numPliegosPlancha;
        pasadasJuego = numPliegosPlancha * Math.ceil(coloresJuego / numCuerpos) * 2;
        break;
      }
      case "TiraVolteo": {
        pliegosJuego = numPliegosPlancha;
        pasadasJuego = numPliegosPlancha * Math.ceil(coloresJuego / numCuerpos);
        break;
      }
    }
    numPasadas += pasadasJuego;
    numPliegos += pliegosJuego;
    debug("numPliegos " + numPliegos);
  }
  xmlOpcion.toElement().setAttribute("NumPliegos", numPliegos);
  xmlOpcion.toElement().setAttribute("NumPasadas", numPasadas);

  return true;
}


/** \C Calcula cuántas páginas de un mismo tipo hay en una distribución en plancha
@param  nodo con la distribución de la plancha
@return Veces que los elementos se repiten
\end */
function artesG_dameRepeticionesEnPlancha(xmlPlancha: FLDomNode): Number {
  // var d:FLDomDocument = new FLDomDocument;
  // d.appendChild(xmlPlancha.cloneNode(true));
  // debug(d.toString());
  var patron: String = xmlPlancha.firstChild().toElement().attribute("Pagina");
  var listaTrabajosPlancha: FLDomNodeList = xmlPlancha.toElement().elementsByTagName("TrabajoPlancha");
  var veces: Number = 0;
  for (var i: Number = 0; i < listaTrabajosPlancha.length(); i++)
  {
    if (listaTrabajosPlancha.item(i).toElement().attribute("Pagina") == patron)
      veces++;
  }
  return veces;
}

function artesG_ponXmlParametroProceso(xmlProceso: FLDomNode, xmlParametro: FLDomNode): Boolean {
  //debug("artesG_ponXmlParametroProceso");
  var util: FLUtil = new FLUtil;

  var xmlNodoParams: FLDomNode = xmlProceso.namedItem("Parametros");
  if (!xmlNodoParams)
  {
    MessageBox.warning(util.translate("scripts", "Error al asignar el parámetro al proceso:\nEl proceso no tiene un nodo Parametros"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  //debug(xmlNodoParams.childNodes().length());
  xmlNodoParams.appendChild(xmlParametro.cloneNode());
  //debug(xmlNodoParams.childNodes().length());
  return  true;
}

function artesG_ponXmlSiguientesTareas(xmlProceso: FLDomNode, xmlST: FLDomNode): Boolean {
  //debug("artesG_ponXmlParametroProceso");
  var util: FLUtil = new FLUtil;
  var idTipoTareaPro: String = this.iface.dameAtributoXML(xmlProceso, "@IdTipoTareaProActual");

  var xmlNodoTarea: FLDomNode = this.iface.dameNodoXML(xmlProceso, "Tareas/Tarea[@IdTipoTareaPro=" + idTipoTareaPro + "]");
  if (!xmlNodoTarea)
  {
    MessageBox.warning(util.translate("scripts", "Error al asignar el parámetro al proceso:\nEl proceso no tiene un nodo Tarea con IdTipoTaraPro = %1").arg(idTipoTareaPro), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  xmlNodoTarea.appendChild(xmlST.cloneNode());

  return  true;
}

/** \C Calcula cuántos trabajos caben a lo ancho y a lo alto de un pliego. El cálculo se realiza en las dos orientaciones y se devuelve el valor mayor
@param xmlProceso: Nodo xml que contiene los datos del proceso actual
@param  areaTrabajo: Área del trabajo en formato X x Y
@param  areaPliego: Área del pliego en formato X x Y
@param  anchoPinza: Ancho de la pinza de la máquina a descontar
@return: Número de trabajos que caben en cada coordenada en formato N x M
\end */
function artesG_trabajosPorPliego(xmlProceso: FLDomNode, areaTrabajo: String, areaPliego: String, anchoPinza: Number): String {
  var idTipoProceso: String = xmlProceso.parentNode().toElement().attribute("IdTipoProceso");
  var sangriaArriba: Number, sangriaAbajo: Number, sangriaIzquierda: Number, sangriaDerecha: Number;
  switch (idTipoProceso)
  {
    default: {
      sangriaArriba = parseFloat(this.iface.dameAtributoXML(xmlProceso, "Parametros/SangriaParam@Arriba"));
      sangriaAbajo = parseFloat(this.iface.dameAtributoXML(xmlProceso, "Parametros/SangriaParam@Abajo"));
      sangriaIzquierda = parseFloat(this.iface.dameAtributoXML(xmlProceso, "Parametros/SangriaParam@Izquierda"));
      sangriaDerecha = parseFloat(this.iface.dameAtributoXML(xmlProceso, "Parametros/SangriaParam@Derecha"));
      break;
    }
  }

  var coordTrabajo: Array = areaTrabajo.split("x");
  coordTrabajo[0] = parseFloat(coordTrabajo[0]) + sangriaIzquierda + sangriaDerecha;
  coordTrabajo[1] = parseFloat(coordTrabajo[1]) + sangriaArriba + sangriaAbajo;

  var coordPliego: Array = areaPliego.split("x");
  if (coordPliego[0] > coordPliego[1])
  {
    coordPliego[0] = parseFloat(coordPliego[0]) - parseFloat(anchoPinza);
  } else {
    coordPliego[1] = parseFloat(coordPliego[1]) - parseFloat(anchoPinza);
  }

  var numXOpcion1: Number = Math.floor(coordPliego[0] / coordTrabajo[0]);
  var numYOpcion1: Number = Math.floor(coordPliego[1] / coordTrabajo[1]);
  var totalOpcion1 = numXOpcion1 * numYOpcion1;

  var numXOpcion2: Number = Math.floor(coordPliego[0] / coordTrabajo[1]);
  var numYOpcion2: Number = Math.floor(coordPliego[1] / coordTrabajo[0]);
  var totalOpcion2 = numXOpcion2 * numYOpcion2;

  var res: String;
  if (totalOpcion1 > totalOpcion2)
  {
    res = numXOpcion1 + "x" + numYOpcion1;
  } else {
    res = numXOpcion2 + "x" + numYOpcion2;
  }
  return res;
}

// function artesG_opcionesImpresoraEstilo(xmlProceso:FLDomNode):Boolean
// {
//  var util:FLUtil = new FLUtil;
//  var nodoAux:FLDomNode = xmlProceso.cloneNode(true);
//  var listaImpresoras:FLDomNodeList = this.iface.valoresVariante("TipoImpresoraVar", nodoAux);
//  if (!listaImpresoras) {
//    MessageBox.warning(util.translate("scripts", "No hay impresoras válidas para los parámetros especificados"), MessageBox.Ok, MessageBox.NoButton);
//    return false;
//  }
//  var contenido:String = "";
//  var nodoTI:FLDomNode;
//  var nodoEI:FLDomNode;
//  var listaEstilos:FLDomNodeList;
//  var eEstilo:FLDomElement;
//  var nodoPinza:String;
//  for (var i:Number = 0; i < listaImpresoras.length(); i++) {
//    nodoTI = this.iface.dameNodoXML(nodoAux, "Parametros/TipoImpresoraParam");
//    if (nodoTI) {
//      nodoAux.namedItem("Parametros").removeChild(nodoTI);
//    }
//    if (!this.iface.ponXmlParametroProceso(nodoAux, listaImpresoras.item(i)))
//      return false;
//
//    listaEstilos = this.iface.valoresVariante("EstiloImpresionVar", nodoAux);
//    if (!listaEstilos) {
//      continue;
//    }
//    for (var k:Number = 0; k < listaEstilos.length(); k++) {
//      nodoEI = this.iface.dameNodoXML(nodoAux, "Parametros/EstiloImpresionParam");
//      if (nodoEI) {
//        nodoAux.namedItem("Parametros").removeChild(nodoEI);
//      }
//      if (!this.iface.ponXmlParametroProceso(nodoAux, listaEstilos.item(k))) {
//        return false;
//      }
//      nodoPinza = this.iface.nodoXMLPinza(nodoAux);
//      eEstilo = listaEstilos.item(k).toElement();
//      contenido += "<IE TipoImpresora=\"" + listaImpresoras.item(i).toElement().attribute("Valor") + "\" EstiloImpresion=\"" + eEstilo.attribute("Valor") + "\"/>";
//      contenido += "\n";
//    }
//  }
//  debug(contenido);
//  return true;
// }

function artesG_nodoXMLPinza(xmlProceso: FLDomNode): Boolean {
  // debug("artesG_nodoXMLPinza");
  // var doc:FLDomDocument = new FLDomDocument;
  // doc.appendChild(xmlProceso.cloneNode());
  // debug(doc.toString(4));
  var util: FLUtil = new FLUtil;

  /// Los sobres no tienen en cuenta la pinza
  var codFormato: String = this.iface.dameAtributoXML(xmlProceso, "Parametros/PliegoParam@Formato");
  if (codFormato && codFormato != "")
  {
    if (codFormato.toLowerCase() == "sobre") {
      return true;
    }
  }

  var nodoPI: FLDomNode = this.iface.dameNodoXML(xmlProceso, "Parametros/PliegoImpresionParam");
  if (!nodoPI)
  {
    return true;
  }
  // debug("Hay nodoPI");

  var areaPI: String = nodoPI.toElement().attribute("Valor");
  nodoPI.toElement().setAttribute("AreaEfectiva", areaPI);
  var nodoPinzas: FLDomNode = this.iface.dameNodoXML(xmlProceso, "Parametros/PliegoImpresionParam/Pinzas");
  if (nodoPinzas)
  {
    nodoPI.removeChild(nodoPinzas);
  }

  var nodoTP: FLDomNode = flfacturac.iface.pub_dameNodoXML(xmlProceso, "Parametros/TrabajosPliegoParam");
  if (!nodoTP)
  {
    //  debug("!nodoTP");
    return true;
  }

  var tipoImpresora: String = this.iface.dameAtributoXML(xmlProceso, "Parametros/TipoImpresoraParam@Valor");
  if (!tipoImpresora)
  {
    //  debug("!tipoimpresora");
    return true;
  }
  var ejeTR: String = "";
  var estilo: String = this.iface.dameAtributoXML(xmlProceso, "Parametros/EstiloImpresionParam@Valor");
  if (estilo == "TiraRetira")
  {
    ejeTR = flfacturac.iface.pub_dameAtributoXML(xmlProceso, "Parametros/TrabajosPliegoParam@EjeSim");
  }

  var doc: FLDomDocument = nodoPI.ownerDocument();
  var ePinzas: FLDomElement = doc.createElement("Pinzas");
  nodoPI.appendChild(ePinzas);

  var dimPI: Array = areaPI.split("x");
  var ejePinza: String;
  // debug("ejeTR = " + ejeTR);

  //  if (estilo == "TiraRetira" && ejeTR != "") {
  //    ejePinza = ejeTR;
  //  } else {
  if (parseFloat(dimPI[0]) > parseFloat(dimPI[1]))
  {
    ejePinza = "H";
  } else {
    ejePinza = "V";
  }
  //  }

  var xmlParamImpresora: FLDomNode = this.iface.dameParamCentroCoste(tipoImpresora);
  var pinza: Number = xmlParamImpresora.toElement().attribute("AnchoPinza");

  var areaEfectivaX: Number = dimPI[0];
  var areaEfectivaY: Number = dimPI[1];
  var areaEfectiva: String;

  var ePinza: FLDomElement = doc.createElement("Pinza");
  ePinzas.appendChild(ePinza);
  ePinza.setAttribute("Eje", ejePinza);
  ePinza.setAttribute("Ancho", pinza);
  ePinza.setAttribute("Lado", "0"); /// 0 = Derecha / arriba y 1 = Izquierda / abajo

  if (ejePinza == "H")
  {
    areaEfectivaY = areaEfectivaY - pinza;
  } else {
    areaEfectivaX = areaEfectivaX - pinza;
  }

  if ((estilo == "TiraRetira" && ejeTR == ejePinza) || estilo == "TiraVolteo")
  {
    ePinza = doc.createElement("Pinza");
    ePinzas.appendChild(ePinza);
    ePinza.setAttribute("Eje", ejePinza);
    ePinza.setAttribute("Ancho", pinza);
    ePinza.setAttribute("Lado", "1");

    if (ejePinza == "H") {
      areaEfectivaY = areaEfectivaY - pinza;
    } else {
      areaEfectivaX = areaEfectivaX - pinza;
    }
  }

  areaEfectiva = areaEfectivaX + "x" + areaEfectivaY;
  nodoPI.toElement().setAttribute("AreaEfectiva", areaEfectiva);

  //  var pinzaImpresion:String = "<Pinza Eje=\"" + dimMayor + "\" Ancho=\"" + pinza + "\"/>";
  //  if (!this.iface.crearNodoHijo(nodoPI, pinzaImpresion))
  //    return false;

  //  debug("Pinza de " + pinza + " sobre el eje " + dimMayor);
  // debug ("Doc pinzas " + doc.toString(4));
  return true;
}

function artesG_contieneColor(arrayColores: Array, color: String): Number {
  // debug("arrayColores = " + arrayColores);
  // debug("color = " + color);
  for (var i: Number = 0; i < arrayColores.length; i++)
  {
    if (arrayColores[i] == color) {
      // debug(i);
      return i;
    }
  }
  // debug(-1);
  return -1;
}

/** \C Crea copias de un conjunto de planchas, tantas como colores sean necesarios
@param  xmlOpcion: XML con la opción de distribución de planchas
@param  xmlProceso: XML con los datos del proceso
@return XML con la lista completa de planchas por color
\end */
function artesG_planchasPorColor(xmlOpcion: FLDomNode, xmlProceso: FLDomNode): FLDomNode {
  // debug("artesG_planchasPorColor");
  // var d:FLDomDocument = new FLDomDocument;
  // d.appendChild(xmlOpcion.cloneNode(true));
  // debug("opción = " + d.toString(4));

  var xmlOpcionColor: FLDomNode = xmlOpcion.cloneNode(false);

  var xmlParamColores: FLDomNode = this.iface.dameNodoXML(xmlProceso, "Parametros/ColoresParam");
  if (!xmlParamColores)
  {
    return false;
  }

  var numCuerpos: Number = this.iface.dameAtributoXML(xmlProceso, "Parametros/TipoImpresoraParam/@NumCuerpos");
  var factorCuerpos: Number = numCuerpos;
  var estiloImpresion: Number = this.iface.dameAtributoXML(xmlProceso, "Parametros/EstiloImpresionParam/@Valor");
  if (estiloImpresion == "TiraVolteo")
    factorCuerpos = factorCuerpos / 2;

  var xmlConfigColores: FLDomNodeList = xmlParamColores.toElement().elementsByTagName("ConfigColores");
  if (!xmlConfigColores)
  {
    return false;
  }
  var totalConfig: Number = xmlConfigColores.length();

  var xmlPlanchas: FLDomNodeList = xmlOpcion.toElement().elementsByTagName("Plancha");
  var totalPlanchas: Number = xmlPlanchas.length();
  var totalPasadas: Number = 0;

  var xmlColores: FLDomNodeList;
  var iPlanchaColor: Number = 0;
  var iJuego: Number = 1;
  var xmlPlanchaColor: FLDomNode;
  var totalColoresJuego: Number;
  var numPasadas: Number;
  var numMaculas: Number = 0;
  var coincide: Boolean = false;
  var color: String;
  var numPantones: Number = 0;
  var caras: Array;
  if (estiloImpresion == "Simple")
  {
    caras = ["Frente"];
  } else {
    caras = ["Frente", "Vuelta"];
  }

  var coloresEnFrente: Array = [];
  var configColoresCara: FLDomNode;

  // debug("estiloImpresion ******************** = " + estiloImpresion);
  for (var iPlancha: Number = 0; iPlancha < totalPlanchas; iPlancha++)
  {
    // debug("Iplancha = " + iPlancha);
    for (var iConfig: Number = 0; iConfig < caras.length; iConfig++) {
      // debug("iConfig = " + caras[iConfig]);
      configColoresCara = this.iface.dameNodoXML(xmlParamColores, "ConfigColores[@Cara=" + caras[iConfig] + "]");
      if (!configColoresCara) {
        continue;
      }
      xmlColores = configColoresCara.toElement().elementsByTagName("Color");
      for (var iColor: Number = 0; iColor < xmlColores.length(); iColor++) {
        // debug("iColor = " + iColor);
        color = xmlColores.item(iColor).toElement().attribute("Nombre");
        if (iConfig == 0) {
          coloresEnFrente[coloresEnFrente.length] = color;
        }
        if ((configColoresCara.toElement().attribute("Cara") == xmlPlanchas.item(iPlancha).toElement().attribute("Cara")) || (estiloImpresion == "TiraRetira" && caras[iConfig] == "Vuelta" && this.iface.contieneColor(coloresEnFrente, color) < 0)) {
          xmlPlanchaColor = xmlPlanchas.item(iPlancha).cloneNode();
          xmlPlanchaColor.toElement().setAttribute("Numero", iPlanchaColor++);
          xmlPlanchaColor.toElement().setAttribute("Juego", iJuego);
          xmlPlanchaColor.toElement().setAttribute("Color", color);
          if (this.iface.esPantone(color)) {
            xmlPlanchaColor.toElement().setAttribute("Pantone", "true");
            numPantones++;
          } else {
            xmlPlanchaColor.toElement().setAttribute("Pantone", "false");
          }
          xmlOpcionColor.appendChild(xmlPlanchaColor);
        }
      }
    }
    iJuego++;
  }
  xmlOpcionColor.toElement().setAttribute("NumPlanchas", iPlanchaColor);
  xmlOpcionColor.toElement().setAttribute("NumJuegos", --iJuego);
  xmlOpcionColor.toElement().setAttribute("NumPantones", numPantones);

  return xmlOpcionColor;
}

function artesG_esPantone(color: String): Boolean {
  var util: FLUtil = new FLUtil;
  var pantone: Boolean;

  if (util.sqlSelect("coloresag", "nombre", "nombre = '" + color + "' AND cuatricromia = true"))
  {
    pantone = false;
  } else {
    pantone = true;
  }
  return pantone;
}

/** \C Modifica una opción de distribución de trabajos en plancha añadiendo los datos de las vueltas de las páginas en planchas distintas. Se usa con el estilo CaraRetira
@param  xmlOpcionDist: XML con la opción de distribución
\end */
function artesG_anadirOtraCara(xmlOpcionDist: FLDomNode): Boolean {
  var listaPlanchas: FLDomNodeList = xmlOpcionDist.childNodes();
  var nodoPlanchaSim: FLDomNode;
  var distribucion: String;
  var totalPlanchas: Number = listaPlanchas.length();
  var numPlancha: Number = totalPlanchas;
  for (var i: Number = 0; i < totalPlanchas; i++)
  {
    nodoPlanchaSim = listaPlanchas.item(i).cloneNode();
    distribucion = nodoPlanchaSim.toElement().attribute("Dist");
    distribucion = this.iface.distCaraVuelta(distribucion);
    nodoPlanchaSim.toElement().setAttribute("Dist", distribucion);
    nodoPlanchaSim.toElement().setAttribute("Numero", numPlancha++);
    nodoPlanchaSim.toElement().setAttribute("Cara", "Vuelta");
    xmlOpcionDist.appendChild(nodoPlanchaSim);
  }
  return true;
}

/** \C Modifica una opción de distribución de trabajos en plancha añadiendo los datos de las vueltas de las páginas en la misma plancha, usando el eje de simetría indicado. Se usa con el estilo TiraRetira
@param  xmlOpcionDist: XML con la opción de distribución
\end */
function artesG_anadirSimetrica(xmlOpcionDist: FLDomNode, ejeSim: String): Boolean {
  var listaPlanchas: FLDomNodeList = xmlOpcionDist.childNodes();
  var nodoPlanchaSim: FLDomNode;
  var distribucion: String;
  var totalPlanchas: Number = listaPlanchas.length();
  for (var i: Number = 0; i < totalPlanchas; i++)
  {
    nodoPlanchaSim = listaPlanchas.item(i);
    distribucion = nodoPlanchaSim.toElement().attribute("Dist");
    distribucion = this.iface.distSimetrica(distribucion, ejeSim);
    nodoPlanchaSim.toElement().setAttribute("Dist", distribucion);
  }
  return true;
}

function artesG_distCaraVuelta(distribucion: String): String {
  var res: String = "";
  var lineas: Array = distribucion.split("*");
  var elementos: Array;
  var nombrePagina: String;
  for (var i: Number = 0; i < (lineas.length - 1); i++)
  {
    elementos = lineas[i].toString().split(" ");
    for (var k: Number = 0; k < (elementos.length - 1); k++) {
      nombrePagina = this.iface.nombreCaraVuelta(elementos[k]);
      res += nombrePagina + " ";
    }
    res += "*";
  }
  return res;
}

function artesG_nombreCaraVuelta(nombrePagina: String): String {
  var res: String;
  if (isNaN(nombrePagina))
  {
    res = nombrePagina + "'";
  } else {
    if (nombrePagina != 0)
    {
      res = (parseInt(nombrePagina) + 1).toString();
    } else {
      res = 0;
    }
  }
  return res;
}

function artesG_distSimetrica(distribucion: String, ejeSim: String): String {
  var res: String = "";
  var lineas: Array = distribucion.split("*");
  var elementos: Array;
  var nombrePagina: String;
  var lineaSim: String;

  if (ejeSim == "H")
  {
    res = distribucion;
    for (var i: Number = (lineas.length - 2); i >= 0; i--) {
      elementos = lineas[i].toString().split(" ");
      for (var k: Number = 0; k < (elementos.length - 1); k++) {
        res += this.iface.nombreCaraVuelta(elementos[k]) + " ";
      }
      res += "*";
    }
  } else {
    for (var i: Number = 0; i < (lineas.length - 1); i++)
    {
      elementos = lineas[i].toString().split(" ");
      lineaSim = lineas[i].toString();
      for (var k: Number = elementos.length - 2; k >= 0; k--) {
        lineaSim += this.iface.nombreCaraVuelta(elementos[k]) + " ";
      }
      res += lineaSim + "*";
    }
  }
  return res;
}

function artesG_svgPinzas(xmlProceso: FLDomNode, dimPix: Array): String {
  var svg: String = "";
  // var doc:FLDomDocument = new FLDomDocument;
  // doc.appendChild(xmlProceso.cloneNode());
  // debug(doc.toString(4));
  var nodoPI: FLDomNode = this.iface.dameNodoXML(xmlProceso, "Parametros/PliegoImpresionParam");
  if (!nodoPI)
  {
    return "";
  }
  var ePI: FLDomElement = nodoPI.toElement();

  var coordPliego: Array = ePI.attribute("Valor").split("x");
  var anchoP: Number = parseFloat(coordPliego[0]);
  var altoP: Number = parseFloat(coordPliego[1]);

  var factor: Number;
  if (anchoP > altoP)
  {
    factor = dimPix.x / anchoP;
  } else {
    factor = dimPix.y / altoP;
  }
  anchoP *= factor;
  altoP *= factor;

  var nodoPinzas: FLDomNode = ePI.namedItem("Pinzas");
  if (!nodoPinzas)
  {
    return "";
  }
  var pinzas: FLDomNodeList = nodoPinzas.toElement().elementsByTagName("Pinza");
  var ePinza: FLDomElement;
  var anchoPinza: Number;
  if (pinzas)
  {
    svg += "<g stroke-width='0' stroke='blue' fill='none' >\n";
    for (var i: Number = 0; i < pinzas.length(); i++) {
      //Pinza Eje=\"" + dimMayor + "\" Ancho=\"" + pinza + "\"/>";
      ePinza = pinzas.item(i).toElement();
      anchoPinza = parseFloat(ePinza.attribute("Ancho")) * factor;
      if (ePinza.attribute("Eje") == "V") {
        if (ePinza.attribute("Lado") == "0") {
          svg += "<rect x='" + parseFloat(anchoP - anchoPinza) + "' width='" + anchoPinza + "' y='" + 0 + "' height='" + altoP + "'/>\n";
        } else {
          svg += "<rect x='" + 0 + "' width='" + anchoPinza + "' y='" + 0 + "' height='" + altoP + "'/>\n";
        }
      } else {
        if (ePinza.attribute("Lado") == "0") {
          svg += "<rect x='" + 0 + "' width='" + anchoP + "' y='" + parseFloat(altoP - anchoPinza) + "' height='" + anchoPinza + "'/>\n";
        } else {
          svg += "<rect x='" + 0 + "' width='" + anchoP + "' y='" + 0 + "' height='" + anchoPinza + "'/>\n";
        }
      }
      // debug("anchoP = " + anchoP);
      // debug("anchoPinza = " + anchoPinza);
    }
    svg += "</g>\n";
  }
  // debug("svg pinzas = " + svg);
  return svg;
}

function artesG_crearNodoHijo(nodoPadre: FLDomNode, textoNodoHijo: String): Boolean {
  var xmlDocAux: FLDomDocument = new FLDomDocument;
  if (!xmlDocAux.setContent(textoNodoHijo))
  {
    return false;
  }
  nodoPadre.appendChild(xmlDocAux.firstChild());

  delete xmlDocAux;
  return true;
}

/** \D Indica si el itinerario es válido en cuanto a si la distribución obtenida encaja en el pliego de impresión una vez descontadas las pinzas
\end */
function artesG_validarPinzas(xmlProceso: FLDomNode): Boolean {
  // debug("artesG_validarPinzas");
  var nodoParam: FLDomNode;
  if (xmlProceso.nodeName() == "Parametros")
  {
    nodoParam = xmlProceso;
  } else {
    nodoParam = xmlProceso.namedItem("Parametros");
  }
  var areaMinTP: String = this.iface.dameAtributoXML(nodoParam , "TrabajosPliegoParam@DimMin");
  if (!areaMinTP)
  {
    return true;
  }
  var areaSinPinzas: String = this.iface.dameAtributoXML(nodoParam , "PliegoImpresionParam@AreaEfectiva");
  // debug("areaSinPinzas = " + areaSinPinzas);
  if (!areaSinPinzas || areaSinPinzas == "")
  {
    areaSinPinzas = this.iface.dameAtributoXML(nodoParam , "PliegoImpresionParam@Valor");
  }
  // debug("areaSinPinzas = " + areaSinPinzas);
  // debug("areaMinTP = " + areaMinTP);

  if (!this.iface.entraEnArea(areaMinTP, areaSinPinzas))
    return false;

  return true;
}

function artesG_crearNodoHijoVacio(nodoPadre: FLDomNode, nombreHijo: String): FLDomNode {
  var xmlDocAux: FLDomDocument = new FLDomDocument;
  xmlDocAux.setContent("<" + nombreHijo + "/>");
  var xmlNodo: FLDomNode = xmlDocAux.firstChild();
  nodoPadre.appendChild(xmlNodo);
  return xmlNodo;
}

function artesG_afterCommit_paramlibro(curPL: FLSqlCursor): Boolean {
  switch (curPL.modeAccess())
  {
    case curPL.Edit: {
      if (!this.iface.regenerarProcesosLibro(curPL)) {
        return false;
      }
      break;
    }
  }
  return true;
}

function artesG_regenerarProcesosLibro(curPL: FLSqlCursor): Boolean {
  var util: FLUtil = new FLUtil;
  var idLinea: String = curPL.valueBuffer("idlinea");
  //  if (!util.sqlDelete("productoslp", "idlinea = " + idLinea + " AND referencia <> 'TAREA_MANUAL'")) {
  //    return false;
  //  }

  if (!this.iface.regenerarPaginasLibro(curPL))
  {
    return false;
  }
  //  if (!this.iface.regenerarEnvioLibro(curPL)) {
  if (!this.iface.regenerarEnvioProducto(curPL))
  {
    return false;
  }
  if (!this.iface.regenerarEncuadernacion(curPL))
  {
    return false;
  }
  if (!this.iface.regenerarTapaLibro(curPL))
  {
    return false;
  }
  //  if (!this.iface.regenerarTMProducto(curPL)) {
  //    return false;
  //  }
  return true;
}

function artesG_afterCommit_tareaslp(curTarea: FLSqlCursor): Boolean {
  var curRel: FLSqlCursor = curTarea.cursorRelation();
  if (curRel)
  {
    return true;
  }
  var curItinerario: FLSqlCursor = new FLSqlCursor("itinerarioslp")
  curItinerario.select("iditinerario = " + curTarea.valueBuffer("iditinerario"));
  if (!curItinerario.first())
  {
    return false;
  }
  curItinerario.setModeAccess(curItinerario.Edit);
  curItinerario.refreshBuffer();
  curItinerario.setValueBuffer("costemo", formRecorditinerarioslp.iface.pub_commonCalculateField("costemo", curItinerario));
  curItinerario.setValueBuffer("costemat", formRecorditinerarioslp.iface.pub_commonCalculateField("costemat", curItinerario));
  curItinerario.setValueBuffer("costetotal", formRecorditinerarioslp.iface.pub_commonCalculateField("costetotal", curItinerario));
  if (!curItinerario.commitBuffer())
  {
    return false;
  }

  return true;
}

function artesG_afterCommit_consumoslp(curConsumo: FLSqlCursor): Boolean {
  var curRel: FLSqlCursor = curConsumo.cursorRelation();
  if (curRel)
  {
    return true;
  }
  var curTarea: FLSqlCursor = new FLSqlCursor("tareaslp")
  curTarea.select("idtarea = " + curConsumo.valueBuffer("idtarea"));
  if (!curTarea.first())
  {
    return false;
  }
  curTarea.setModeAccess(curTarea.Edit);
  curTarea.refreshBuffer();
  curTarea.setValueBuffer("costemat", formRecordtareaslp.iface.pub_commonCalculateField("costemat", curTarea));
  curTarea.setValueBuffer("costetotal", formRecordtareaslp.iface.pub_commonCalculateField("costetotal", curTarea));
  if (!curTarea.commitBuffer())
  {
    return false;
  }
  return true;
}

function artesG_regenerarPaginasLibro(curPL: FLSqlCursor): Boolean {
  // debug("artesG_regenerarPaginasLibro");
  var util: FLUtil = new FLUtil;

  var idLinea: String = curPL.valueBuffer("idlinea");
  // debug("idLinea =" + idLinea);

  var idComponente: Number = util.sqlSelect("articuloscomp", "id", "refcompuesto = 'LIBRO' AND refcomponente = 'PAGINAS_LIBRO'");
  var idProducto: String;

  var xmlPL: FLDomDocument = new FLDomDocument();
  if (!xmlPL.setContent(curPL.valueBuffer("xml")))
  {
    return false;
  }
  // debug(xmlPL.toString());
  var xmlGrupos: FLDomNodeList = xmlPL.elementsByTagName("Grupo");
  var xmlFact: FLDomNodeList;
  var xmlPartes: FLDomNodeList;
  var eGrupo: FLDomElement;
  var eFact: FLDomElement;
  var eParte: FLDomElement;
  var plegado: Array;
  var areaTrabajo: Array;

  var curPP: FLSqlCursor = new FLSqlCursor("paramiptico");
  var curProducto: FLSqlCursor = new FLSqlCursor("productoslp");

  curProducto.select("idlinea = " + idLinea + " AND referencia = 'PAGINAS_LIBRO'");
  curProducto.setForwardOnly(true);
  while (curProducto.next())
  {
    curProducto.setModeAccess(curProducto.Del);
    curProducto.refreshBuffer();
    if (!curProducto.commitBuffer()) {
      return false;
    }
  }

  for (var i: Number = 0; i < xmlGrupos.length(); i++)
  {
    eGrupo = xmlGrupos.item(i).toElement();
    xmlFact = eGrupo.elementsByTagName("Factorizacion");
    for (var k: Number = 0; k < xmlFact.length(); k++) {
      eFact = xmlFact.item(k).toElement();
      xmlPartes = eFact.childNodes();
      for (var m: Number = 0; m < xmlPartes.length(); m++) {
        eParte = xmlPartes.item(m).toElement();

        curProducto.setModeAccess(curProducto.Insert);
        curProducto.refreshBuffer();
        curProducto.setValueBuffer("idlinea", idLinea);
        curProducto.setValueBuffer("referencia", "PAGINAS_LIBRO");
        curProducto.setValueBuffer("descripcion", eGrupo.attribute("Nombre") + " " + curPL.valueBuffer("descripcion"));
        curProducto.setValueBuffer("idcomponente", idComponente);
        curProducto.setValueBuffer("original", true);
        curProducto.setValueBuffer("seleccionado", true);
        curProducto.setValueBuffer("opcion", eFact.attribute("Opcion"));
        curProducto.setValueBuffer("parteopcion", eParte.attribute("ParteOpcion"));
        curProducto.setValueBuffer("idgrupocalculo", eGrupo.attribute("IdGrupo"));
        if (!curProducto.commitBuffer()) {
          return false;
        }
        idProducto = curProducto.valueBuffer("idproducto");
        areaTrabajo = eParte.attribute("AreaTrabajo").split("x");

        curPP.setModeAccess(curPP.Insert);
        curPP.refreshBuffer();
        curPP.setValueBuffer("descripcion", eGrupo.attribute("Nombre") + " " + curPL.valueBuffer("descripcion"));
        curPP.setValueBuffer("idproducto", idProducto);
        curPP.setValueBuffer("numcopias", curPL.valueBuffer("numcopias"));
        curPP.setValueBuffer("numpaginas", eParte.attribute("NumPliegos"));
        curPP.setValueBuffer("distpaginastrabajo", eParte.attribute("DistPaginasTrabajo"));
        curPP.setValueBuffer("anchot", areaTrabajo[0]);
        curPP.setValueBuffer("altot", areaTrabajo[1]);
        curPP.setValueBuffer("gramaje", curPL.valueBuffer("gramaje"));
        curPP.setValueBuffer("diseno", curPL.valueBuffer("diseno"));
        curPP.setValueBuffer("codmarcapapel", curPL.valueBuffer("codmarcapapel"));
        curPP.setValueBuffer("codcalidad", curPL.valueBuffer("codcalidad"));
        curPP.setValueBuffer("colores", eGrupo.attribute("Colores"));
        curPP.setValueBuffer("doscaras", (eGrupo.attribute("DosCaras") == "true"));


        /// Pliegues para pliegos de dos páginas
        plegado = eParte.attribute("Plegado").split("+");
        curPP.setValueBuffer("pliegueshor", plegado[0]);
        curPP.setValueBuffer("plieguesver", plegado[1]);

        if (!curPP.commitBuffer()) {
          return false;
        }
        var idPP: String = curPP.valueBuffer("id");
        curPP.select("id = " + idPP);
        if (!curPP.first()) {
          return false;
        }
        curPP.setModeAccess(curPP.Edit);
        curPP.refreshBuffer();

        if (!formRecordparamiptico.iface.pub_crearRegistroColor(curPP)) {
          return false;
        }
        if (!formRecordparamiptico.iface.pub_crearRegistroCantidades(curPP)) {
          return false;
        }

        xmlDocParam = formRecordparamiptico.iface.pub_guardarDatos(curPP);
        if (!xmlDocParam) {
          return false;
        }
        curPP.setValueBuffer("xml", xmlDocParam.toString());
        if (!curPP.commitBuffer()) {
          return false;
        }
      }
    }
  }
  return true;
}

// function artesG_regenerarEnvioLibro(curPL:FLSqlCursor):Boolean
// {
//  var util:FLUtil = new FLUtil;
//
//  var idLinea:String = curPL.valueBuffer("idlinea");
//  var idParamLibro:String = curPL.valueBuffer("id");
//
//  var idComponente:Number = util.sqlSelect("articuloscomp", "id", "refcompuesto = 'LIBRO' AND refcomponente = 'ENVIO'");
//  if (!idComponente) {
//    MessageBox.warning(util.translate("scripts", "No existe el componente ENVIO para el compuesto LIBRO.\nDebe editar el artículo LIBRO y asociarle un componente con referencia ENVIO"), MessageBox.Ok, MessageBox.NoButton);
//    return false;
//  }
//
//  var idProducto:String;
//
//  var curProducto:FLSqlCursor = new FLSqlCursor("productoslp");
//  var curPE:FLSqlCursor = new FLSqlCursor("paramenvio");
//  curPE.select("idparamlibro = " + idParamLibro);
//  if (curPE.size() == 0) {
//    return true;
//  }
//  while (curPE.next()) {
//    curProducto.setModeAccess(curProducto.Insert);
//    curProducto.refreshBuffer();
//    curProducto.setValueBuffer("idlinea", idLinea);
//    curProducto.setValueBuffer("referencia", "ENVIO");
//    curProducto.setValueBuffer("descripcion", util.translate("scripts", "Envío a %1").arg(curPE.valueBuffer("ciudad")));
//    curProducto.setValueBuffer("idcomponente", idComponente);
//    curProducto.setValueBuffer("original", true);
//    curProducto.setValueBuffer("seleccionado", true);
//    curProducto.setNull("opcion");
//    curProducto.setNull("parteopcion");
//    curProducto.setNull("idgrupocalculo");
//    if (!curProducto.commitBuffer()) {
//      return false;
//    }
//    idProducto = curProducto.valueBuffer("idproducto");
//
//    curPE.setModeAccess(curPE.Edit);
//    curPE.refreshBuffer();
//    curPE.setValueBuffer("idproducto", idProducto);
//
//    if (!curPE.commitBuffer()) {
//      return false;
//    }
//  }
//  return true;
// }

function artesG_regenerarEnvioProducto(curParam: FLSqlCursor): Boolean {
  // debug("artesG_regenerarEnvioProducto");
  var util: FLUtil = new FLUtil;

  var tipoProd: String = curParam.table();
  var refProd: String;
  var campoIdProd: String;
  switch (tipoProd)
  {
    case "paramiptico": {
      refProd = "IPTICO";
      campoIdProd = "idparamiptico";
      break;
    }
    case "paramlibro": {
      refProd = "LIBRO";
      campoIdProd = "idparamlibro";
      break;
    }
    case "paramtaco": {
      refProd = "TACO";
      campoIdProd = "idparamtaco";
      break;
    }
    default: {
      return false;
    }
  }
  var idLinea: String = curParam.valueBuffer("idlinea");
  var idParam: String = curParam.valueBuffer("id");

  var qryEnviosABorrar: FLSqlQuery = new FLSqlQuery;
  qryEnviosABorrar.setTablesList("productoslp," + tipoProd);
  qryEnviosABorrar.setSelect("p.idproducto");
  qryEnviosABorrar.setFrom("productoslp p LEFT OUTER JOIN " + tipoProd + " pi ON p.idproducto = pi.idproducto");
  qryEnviosABorrar.setWhere("p.idlinea = " + idLinea + " AND p.referencia = 'ENVIO' AND pi.idproducto IS NULL");
  qryEnviosABorrar.setForwardOnly(true);
  if (!qryEnviosABorrar.exec())
  {
    return false;
  }
  var idProducto: String;
  var curProducto: FLSqlCursor = new FLSqlCursor("productoslp");
  while (qryEnviosABorrar.next())
  {
    var idProducto: String = qryEnviosABorrar.value("p.idproducto");
    curProducto.select("idproducto = " + idProducto);
    if (!curProducto.first()) {
      return false;
    }
    curProducto.setModeAccess(curProducto.Del);
    curProducto.refreshBuffer();
    if (!curProducto.commitBuffer()) {
      return false;
    }
  }

  var idComponente: Number = util.sqlSelect("articuloscomp", "id", "refcompuesto = '" + refProd + "' AND refcomponente = 'ENVIO'");
  if (!idComponente)
  {
    MessageBox.warning(util.translate("scripts", "No existe el componente ENVIO para el compuesto IPTICO.\nDebe editar el artículo %1 y asociarle un componente con referencia ENVIO").arg(refProd), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }

  var idProducto: String;

  var curProducto: FLSqlCursor = new FLSqlCursor("productoslp");
  var curPE: FLSqlCursor = new FLSqlCursor("paramenvio");
  curPE.select(campoIdProd + " = " + idParam);
  if (curPE.size() == 0)
  {
    return true;
  }
  while (curPE.next())
  {
    curProducto.setModeAccess(curProducto.Insert);
    curProducto.refreshBuffer();
    curProducto.setValueBuffer("idlinea", idLinea);
    curProducto.setValueBuffer("referencia", "ENVIO");
    curProducto.setValueBuffer("descripcion", util.translate("scripts", "Envío a %1 %2").arg(curPE.valueBuffer("ciudad")).arg(curParam.valueBuffer("descripcion")));
    curProducto.setValueBuffer("idcomponente", idComponente);
    curProducto.setValueBuffer("original", true);
    curProducto.setValueBuffer("seleccionado", true);
    curProducto.setNull("opcion");
    curProducto.setNull("parteopcion");
    curProducto.setNull("idgrupocalculo");
    if (!curProducto.commitBuffer()) {
      return false;
    }
    idProducto = curProducto.valueBuffer("idproducto");

    curPE.setModeAccess(curPE.Edit);
    curPE.refreshBuffer();
    curPE.setValueBuffer("idproducto", idProducto);

    if (!curPE.commitBuffer()) {
      return false;
    }
  }
  return true;
}

// function artesG_regenerarTMProducto(curParam:FLSqlCursor):Boolean
// {
//  var util:FLUtil = new FLUtil;
//
//  var tipoProd:String = curParam.table();
//  var refProd:String;
//  var campoIdProd:String;
//  switch (tipoProd) {
//    case "paramiptico": { refProd = "IPTICO"; campoIdProd = "idparamiptico"; break; }
//    case "paramlibro": { refProd = "LIBRO"; campoIdProd = "idparamlibro"; break; }
//    case "paramtaco": { refProd = "TACO"; campoIdProd = "idparamtaco"; break; }
//    default: { return false; }
//  }
//  var idLinea:String = curParam.valueBuffer("idlinea");
//  var idParamIptico:String = curParam.valueBuffer("id");
//
//  var idComponente:Number = util.sqlSelect("articuloscomp", "id", "refcompuesto = '" + refProd + "' AND refcomponente = 'TAREA_MANUAL'");
//  if (!idComponente) {
//    MessageBox.warning(util.translate("scripts", "No existe el componente TAREA_MANUAL para el compuesto %1.\nDebe editar el artículo IPTICO y asociarle un componente con referencia TAREA_MANUAL").arg(refProd), MessageBox.Ok, MessageBox.NoButton);
//    return false;
//  }
//
//  var idProducto:String;
//
//  var curProducto:FLSqlCursor = new FLSqlCursor("productoslp");
//  var curPTM:FLSqlCursor = new FLSqlCursor("paramtareamanual");
//  curPTM.select(campoIdProd + " = " + idParamIptico);
//  if (curPTM.size() == 0) {
//    return true;
//  }
//  while (curPTM.next()) {
//    curProducto.setModeAccess(curProducto.Insert);
//    curProducto.refreshBuffer();
//    curProducto.setValueBuffer("idlinea", idLinea);
//    curProducto.setValueBuffer("referencia", "TAREA_MANUAL");
//    curProducto.setValueBuffer("descripcion", curPTM.valueBuffer("descripcion"));
//    curProducto.setValueBuffer("idcomponente", idComponente);
//    curProducto.setValueBuffer("original", true);
//    curProducto.setValueBuffer("seleccionado", true);
//    curProducto.setNull("opcion");
//    curProducto.setNull("parteopcion");
//    curProducto.setNull("idgrupocalculo");
//    if (!curProducto.commitBuffer()) {
//      return false;
//    }
//    idProducto = curProducto.valueBuffer("idproducto");
//
//    curPTM.setModeAccess(curPTM.Edit);
//    curPTM.refreshBuffer();
//    curPTM.setValueBuffer("idproducto", idProducto);
//
//    if (!curPTM.commitBuffer()) {
//      return false;
//    }
//  }
//  return true;
// }

// function artesG_regenerarTMLibro(curPL:FLSqlCursor):Boolean
// {
// //  debug("artesG_regenerarTMLibro");
//  var util:FLUtil = new FLUtil;
//
//  var idLinea:String = curPL.valueBuffer("idlinea");
//  var idParamLibro:String = curPL.valueBuffer("id");
//
//  var idComponente:Number = util.sqlSelect("articuloscomp", "id", "refcompuesto = 'LIBRO' AND refcomponente = 'TAREA_MANUAL'");
//  if (!idComponente) {
//    MessageBox.warning(util.translate("scripts", "No existe el componente TAREA_MANUAL para el compuesto LIBRO.\nDebe editar el artículo LIBRO y asociarle un componente con referencia TAREA_MANUAL"), MessageBox.Ok, MessageBox.NoButton);
//    return false;
//  }
//
//  var idProducto:String;
//
//  var curProducto:FLSqlCursor = new FLSqlCursor("productoslp");
//  var curPTM:FLSqlCursor = new FLSqlCursor("paramtareamanual");
//  curPTM.select("idparamlibro = " + idParamLibro);
//  if (curPTM.size() == 0) {
//    return true;
//  }
//  while (curPTM.next()) {
//    curProducto.setModeAccess(curProducto.Insert);
//    curProducto.refreshBuffer();
//    curProducto.setValueBuffer("idlinea", idLinea);
//    curProducto.setValueBuffer("referencia", "TAREA_MANUAL");
//    curProducto.setValueBuffer("descripcion", curPTM.valueBuffer("descripcion"));
//    curProducto.setValueBuffer("idcomponente", idComponente);
//    curProducto.setValueBuffer("original", true);
//    curProducto.setValueBuffer("seleccionado", true);
//    curProducto.setNull("opcion");
//    curProducto.setNull("parteopcion");
//    curProducto.setNull("idgrupocalculo");
//    if (!curProducto.commitBuffer()) {
//      return false;
//    }
//    idProducto = curProducto.valueBuffer("idproducto");
//
//    curPTM.setModeAccess(curPTM.Edit);
//    curPTM.refreshBuffer();
//    curPTM.setValueBuffer("idproducto", idProducto);
//
//    if (!curPTM.commitBuffer()) {
//      return false;
//    }
//  }
//  return true;
// }

function artesG_regenerarEncuadernacion(curPL: FLSqlCursor): Boolean {
  var util: FLUtil = new FLUtil;

  var idLinea: String = curPL.valueBuffer("idlinea");
  var curProducto: FLSqlCursor = new FLSqlCursor("productoslp");

  /// Busca el producto Encuadernación principal
  var idProducto: String = util.sqlSelect("productoslp p LEFT OUTER JOIN paramlibro pl ON p.idproducto = pl.idproducto", "p.idproducto", "p.idlinea = " + idLinea + " AND p.referencia = 'ENCUADERNACION' AND pl.idproducto IS NULL", "productoslp,paramlibro");
  var curProducto: FLSqlCursor = new FLSqlCursor("productoslp");
  if (idProducto)
  {
    curProducto.select("idproducto = " + idProducto);
    if (!curProducto.first()) {
      return false;
    }
    curProducto.setModeAccess(curProducto.Del);
    curProducto.refreshBuffer();
    if (!curProducto.commitBuffer()) {
      return false;
    }
  }

  var idComponente: Number = util.sqlSelect("articuloscomp", "id", "refcompuesto = 'LIBRO' AND refcomponente = 'ENCUADERNACION'");

  var xmlPL: FLDomDocument = new FLDomDocument();
  if (!xmlPL.setContent(curPL.valueBuffer("xml")))
  {
    return false;
  }

  var nodosCombi: FLDomNodeList = xmlPL.elementsByTagName("Combinacion");
  //  var xmlFact:FLDomNodeList;
  //  var xmlPartes:FLDomNodeList;
  //  var eGrupo:FLDomElement;
  //  var eFact:FLDomElement;
  //  var eParte:FLDomElement;
  var eCombi: FLDomElement;

  /// Función recursiva en paramlibro para obtener las combinaciones de factorizaciones / grupos.

  for (var i: Number = 0; i < nodosCombi.length(); i++)
  {
    eCombi = nodosCombi.item(i).toElement();
    curProducto.setModeAccess(curProducto.Insert);
    curProducto.refreshBuffer();
    curProducto.setValueBuffer("idlinea", idLinea);
    curProducto.setValueBuffer("referencia", "ENCUADERNACION");
    curProducto.setValueBuffer("descripcion", util.translate("scripts", "Encuadernación") + " " + curPL.valueBuffer("descripcion"));
    curProducto.setValueBuffer("idcomponente", idComponente);
    curProducto.setValueBuffer("original", false);
    curProducto.setValueBuffer("seleccionado", false);
    curProducto.setValueBuffer("opcion", eCombi.attribute("Opcion"));
    curProducto.setNull("parteopcion");

    if (!curProducto.commitBuffer()) {
      return false;
    }
  }
  return true;
}

function artesG_regenerarTapaLibro(curPL: FLSqlCursor): Boolean {
  var util: FLUtil = new FLUtil;

  var curProducto: FLSqlCursor = new FLSqlCursor("productoslp");
  var idLinea: String = curPL.valueBuffer("idlinea");

  curProducto.select("idlinea = " + idLinea + " AND referencia = 'TAPA_LIBRO'");
  curProducto.setForwardOnly(true);
  while (curProducto.next())
  {
    curProducto.setModeAccess(curProducto.Del);
    curProducto.refreshBuffer();
    if (!curProducto.commitBuffer()) {
      return false;
    }
  }

  if (curPL.valueBuffer("sintapa"))
  {
    return true;
  }

  /// Como páginas libro pero sólo 1 producto

  //  debug("artesG_regenerarTapaLibro");
  var util: FLUtil = new FLUtil;

  var idComponente: Number = util.sqlSelect("articuloscomp", "id", "refcompuesto = 'LIBRO' AND refcomponente = 'TAPA_LIBRO'");
  var idProducto: String;

  var xmlPL: FLDomDocument = new FLDomDocument();
  if (!xmlPL.setContent(curPL.valueBuffer("xml")))
  {
    return false;
  }

  curProducto.setModeAccess(curProducto.Insert);
  curProducto.refreshBuffer();
  curProducto.setValueBuffer("idlinea", idLinea);
  curProducto.setValueBuffer("referencia", "TAPA_LIBRO");
  curProducto.setValueBuffer("descripcion", util.translate("scripts", "Tapa del libro") + " " + curPL.valueBuffer("descripcion"));
  curProducto.setValueBuffer("idcomponente", idComponente);
  curProducto.setValueBuffer("original", true);
  curProducto.setValueBuffer("seleccionado", true);
  curProducto.setNull("opcion");
  curProducto.setNull("parteopcion");
  curProducto.setNull("idgrupocalculo");
  if (!curProducto.commitBuffer())
  {
    return false;
  }
  idProducto = curProducto.valueBuffer("idproducto");
  //  areaTrabajo = eParte.attribute("AreaTrabajo").split("x");

  var curPP: FLSqlCursor = new FLSqlCursor("paramiptico");
  curPP.setModeAccess(curPP.Insert);
  curPP.refreshBuffer();
  curPP.setValueBuffer("idproducto", idProducto);
  curPP.setValueBuffer("descripcion", util.translate("scripts", "Tapa del libro") + " " + curPL.valueBuffer("descripcion"));
  curPP.setValueBuffer("numcopias", curPL.valueBuffer("numcopias"));
  curPP.setValueBuffer("numpaginas", 1);
  curPP.setValueBuffer("anchot", curPL.valueBuffer("anchotapa"));
  curPP.setValueBuffer("altot", curPL.valueBuffer("altotapa"));
  // debug("Gramaje = " + curPL.valueBuffer("gramajetapa"));
  curPP.setValueBuffer("gramaje", curPL.valueBuffer("gramajetapa"));
  curPP.setValueBuffer("diseno", curPL.valueBuffer("disenotapa"));
  curPP.setValueBuffer("codmarcapapel", curPL.valueBuffer("codmarcapapeltapa"));
  curPP.setValueBuffer("codcalidad", curPL.valueBuffer("codcalidadtapa"));
  var colores: String = curPL.valueBuffer("colorestapa");
  curPP.setValueBuffer("colores", colores);
  var color: Array = colores.split("+");
  if (parseInt(color[1]) > 0)
  {
    curPP.setValueBuffer("doscaras", true);
  } else {
    curPP.setValueBuffer("doscaras", false);
  }

  // Pliegues para pliegos de dos páginas
  //  plegado = eParte.attribute("Plegado").split("+");
  //  curPP.setValueBuffer("pliegueshor", plegado[0]);
  //  curPP.setValueBuffer("plieguesver", plegado[1]);

  if (!curPP.commitBuffer())
  {
    return false;
  }
  var idPP: String = curPP.valueBuffer("id");
  curPP.select("id = " + idPP);
  if (!curPP.first())
  {
    return false;
  }
  curPP.setModeAccess(curPP.Edit);
  curPP.refreshBuffer();

  if (!formRecordparamiptico.iface.pub_crearRegistroColor(curPP))
  {
    return false;
  }
  if (!formRecordparamiptico.iface.pub_crearRegistroCantidades(curPP))
  {
    return false;
  }

  xmlDocParam = formRecordparamiptico.iface.pub_guardarDatos(curPP);
  if (!xmlDocParam)
  {
    return false;
  }
  curPP.setValueBuffer("xml", xmlDocParam.toString());
  if (!curPP.commitBuffer())
  {
    return false;
  }

  return true;
}

/** \D Escoge y marca como seleccionado uno de los posibles productos para la lína
(OBSOLETA)
@param  idLinea: Id. Línea de presupuesto
\end */
function artesG_seleccionarOpcionProductos(idLinea: String): Boolean {
  var util: FLUtil = new FLUtil;

  var qryProductos: FLSqlCursor = new FLSqlQuery;
  with(qryProductos)
  {
    setTablesList("productoslp");
    setSelect("idcomponente, idgrupocalculo, opcion, SUM(coste)");
    setFrom("productoslp");
    setWhere("idlinea = " + idLinea + " GROUP BY idcomponente, idgrupocalculo, opcion ORDER BY SUM(coste)");
    setForwardOnly(true);
  }
  if (!qryProductos.exec())
  {
    return false;
  }
  var idCompPrevio: String = "";
  var idComponente: String;
  var opcion: String;
  var whereSeleccionado: String;
  while (qryProductos.next())
  {
    idComponente = qryProductos.value("idcomponente");
    idGrupoCalculo = qryProductos.value("idgrupocalculo");
    opcion = qryProductos.value("opcion");
    if (idComponente == idCompPrevio) {
      continue;
    }
    if (!util.sqlUpdate("productoslp", "seleccionado", false, "idlinea = " + idLinea + " AND idcomponente = " + idComponente + " AND idgrupocalculo = " + idGrupoCalculo)) {
      return false;
    }
    whereSeleccionado = "idlinea = " + idLinea + " AND idcomponente = " + idComponente;
    if (opcion && opcion != "") {
      whereSeleccionado += " AND opcion = '" + opcion + "'";
    } else {
      whereSeleccionado += " AND opcion IS NULL";
    }
    if (idGrupoCalculo && idGrupoCalculo != "") {
      whereSeleccionado += " AND idgrupocalculo = " + idGrupoCalculo;
    } else {
      whereSeleccionado += " AND idgrupocalculo IS NULL";
    }
    if (!util.sqlUpdate("productoslp", "seleccionado", true,  whereSeleccionado)) {
      return false;
    }
    idCompPrevio = idComponente;
  }
  return true;
}

/** \D Construye un array que contiene, para cada modelo, la cantidad del mismo a incluir en una plancha. Hay dos posiciones extra: La eficiencia de la distribución y la tirada (número de pliegos necesarios para obtener la cantidad requerida)
@param  cantidades: Array con las cantidades (una por modelo) a incluir en la plancha
@param  numTrabajosPlancha: Cantidad de trabajos que caben en una plancha
@param  rellenar: Indica si hay distintas cantidades por modelo, y por tanto se crearán huecos en la distribución que es necesario rellenar
\end */
function artesG_resolverDistribucionDC(cantidades: Array, numTrabajosPlancha: Number, rellenar: Boolean): Array {
  var solucion: Array = new Array(cantidades.length + 2);
  var excedentes: Array = new Array(cantidades.length);
  var totalCantidad: Number = 0;
  for (var i: Number = 0; i < cantidades.length; i++)
  {
    totalCantidad += parseInt(cantidades[i]);
  }
  // debug("Total cantidad = " + totalCantidad);
  var totalSolucion: Number = 0;
  var tirada: Number = 0;
  var iTirada: Number = 0;
  for (var i: Number = 0; i < cantidades.length; i++)
  {
    // debug("Can[i] = " + cantidades[i]);
    // debug("tirada = " + tirada);
    solucion[i] = Math.floor(cantidades[i] / totalCantidad * numTrabajosPlancha);
    if (solucion[i] == 0) {
      solucion[i] = 1;
    }

    if ((cantidades[i] / solucion[i]) > tirada) {
      tirada = cantidades[i] / solucion[i];
      iTirada = i;
    }
    totalSolucion += parseInt(solucion[i]);
  }

  /*debug("Tirada " + tirada);
  debug("Primera solucion: " + solucion);*/
  var numHuecos: Number = numTrabajosPlancha - totalSolucion;
  // debug("NH = " + numHuecos);
  if (rellenar)
  {
    for (var j: Number = 0; j < numHuecos; j++) {
      solucion[iTirada]++;
      tirada = 0;
      iTirada = -1;
      for (var i: Number = 0; i < cantidades.length; i++) {
        if ((cantidades[i] / solucion[i]) > tirada) {
          iTirada = i;
          tirada = cantidades[i] / solucion[i];
        }
      }
    }
  }

  tirada = Math.ceil(tirada);
  /*debug("Tirada final: " + tirada);
  debug("Solución completa: " + solucion);*/

  var eficiencia: Number;
  if (rellenar)
  {
    var totalExcedente: Number = 0;
    for (var i: Number = 0; i < cantidades.length; i++) {
      excedente = (solucion[i] * tirada) - cantidades[i];
      totalExcedente += parseInt(excedente);
    }
    eficiencia = Math.round((totalCantidad / (totalCantidad + totalExcedente)) * 100);
  } else {
    eficiencia = Math.round(((numTrabajosPlancha - numHuecos) / numTrabajosPlancha) * 100);
  }
  solucion[cantidades.length] = eficiencia;
  solucion[cantidades.length + 1] = tirada;

  return solucion;
}

/** Construye un array de una dimensión en el que cada índice corresponde con un modelo, y la cantidad guardada con la cantidad a realizar de dicho modelo.
@param  NodoPaginas: Nodo con los datos de páginas del trabajo
@return array
\end */
function artesG_dameArrayDist(nodoPaginas: FLDomNode): Array {
  // var d:FLDomDocument; d.appendChild(nodoPaginas.cloneNode()); debug(d.toString(4));
  var res: Array;
  if (nodoPaginas.toElement().attribute("CantidadesPorModelo") == "true")
  {
    var xmlModelos: FLDomNode = this.iface.dameNodoXML(nodoPaginas, "Modelos");
    var xmlListaModelos: FLDomNodeList = xmlModelos.childNodes();
    var numModelos: Number = xmlListaModelos.length();
    res = new Array(numModelos);
    for (var i: Number = 0; i < numModelos; i++) {
      res[i] = xmlListaModelos.item(i).toElement().attribute("Cantidad");
    }
  } else {
    var numPaginas: Number = parseInt(nodoPaginas.toElement().attribute("NumPaginas"));
    var numCopias: Number = parseInt(nodoPaginas.toElement().attribute("NumCopias"));
    res = new Array(numPaginas);
    for (var i: Number = 0; i < numPaginas; i++)
    {
      res[i] = numCopias;
    }
  }

  return res;
}

/** \D Compone un array de dos dimensiones. La primera es la plancha, la segunda el modelo incluido en dicha plancha, indicando en cada índice la cantidad de trabajos de dicho modelo
@param arrayDist: Distribución de trabajos en plancha
@param numPlanchas: Número de planchas disponibles
@return Array de distribución
\end */
function artesG_dameArrayDistPlanchas(arrayDist: Array, numPlanchas: Number): Array {
  /*debug("artesG_dameArrayDistPlanchas");
  debug("AD = " + arrayDist);*/
  var longitud: Number = arrayDist.length;
  /*debug("longitud = " + longitud);
  debug("numPlanchas = " + numPlanchas);*/
  var cantidadPorPlancha: Number = Math.floor(longitud / numPlanchas);
  var resto: Number = longitud % numPlanchas;
  /*debug("cantidadPorPlancha  = " + cantidadPorPlancha );*/
  var i: Number = 0;
  var res: Array = new Array(numPlanchas);
  for (var nP: Number = 0; nP < numPlanchas; nP++)
  {
    res[nP] = [];
    if (nP < resto) {
      for (var nDP: Number = 0; nDP < (cantidadPorPlancha + 1); nDP++) {
        res[nP][nDP] = arrayDist[i++];
      }
    } else {
      for (var nDP: Number = 0; nDP < cantidadPorPlancha; nDP++) {
        res[nP][nDP] = arrayDist[i++];
      }
    }
    // debug("AD" + nP + " = " + res[nP]);
  }
  return res;
}

function artesG_afterCommit_paramiptico(curPI: FLSqlCursor): Boolean {
  switch (curPI.modeAccess())
  {
    case curPI.Edit: {
      if (curPI.valueBuffer("idlinea") == 0 || curPI.isNull("idlinea")) {
        if (!this.iface.actualizarDescripcionProducto(curPI)) {
          return false;
        }
        break;
      }
      if (!this.iface.regenerarProcesosIptico(curPI)) {
        return false;
      }
      break;
    }
  }
  return true;
}

function artesG_actualizarDescripcionProducto(curParam: FLSqlCursor): Boolean {
  var idProducto: String = curParam.valueBuffer("idproducto");
  var curProducto: FLSqlCursor = new FLSqlCursor("productoslp");
  curProducto.setActivatedCommitActions(false);
  curProducto.setActivatedCheckIntegrity(false);
  curProducto.select("idproducto = " + idProducto);
  if (!curProducto.first())
  {
    return false;
  }
  curProducto.setModeAccess(curProducto.Edit);
  curProducto.refreshBuffer();
  curProducto.setValueBuffer("descripcion", curParam.valueBuffer("descripcion"));
  if (!curProducto.commitBuffer())
  {
    return false;
  }
  return true;
}

function artesG_afterCommit_paramtaco(curPT: FLSqlCursor): Boolean {
  switch (curPT.modeAccess())
  {
    case curPT.Edit: {
      if (curPT.valueBuffer("idlinea") == 0 || curPT.isNull("idlinea")) {
        if (!this.iface.actualizarDescripcionProducto(curPE)) {
          return false;
        }
        break;
      }
      if (!this.iface.regenerarProcesosTaco(curPT)) {
        return false;
      }
      break;
    }
  }
  return true;
}

function artesG_afterCommit_paramtareamanual(curPTM: FLSqlCursor): Boolean {
  switch (curPTM.modeAccess())
  {
    case curPTM.Edit: {
      if (curPTM.valueBufferCopy("descripcion") != curPTM.valueBuffer("descripcion")) {
        if (!this.iface.actualizarDescripcionProducto(curPTM)) {
          return false;
        }
      }
      break;
    }
  }
  return true;
}

function artesG_afterCommit_paramenvio(curPE: FLSqlCursor): Boolean {
  switch (curPE.modeAccess())
  {
    case curPE.Edit: {
      if (curPE.valueBufferCopy("descripcion") != curPE.valueBuffer("descripcion")) {
        if (!this.iface.actualizarDescripcionProducto(curPE)) {
          return false;
        }
      }
      break;
    }
  }
  return true;
}

function artesG_regenerarProcesosIptico(curPI: FLSqlCursor): Boolean {
  var util: FLUtil = new FLUtil;
  var idLinea: String = curPI.valueBuffer("idlinea");
  //  if (!util.sqlDelete("productoslp", "idlinea = " + idLinea + " AND referencia <> 'TAREA_MANUAL'")) {
  //    return false;
  //  }

  if (!this.iface.regenerarIptico(curPI))
  {
    return false;
  }
  if (!this.iface.regenerarEnvioProducto(curPI))
  {
    return false;
  }
  //  if (!this.iface.regenerarTMProducto(curPI)) {
  //    return false;
  //  }
  return true;
}

function artesG_regenerarProcesosTaco(curPT: FLSqlCursor): Boolean {
  var util: FLUtil = new FLUtil;
  var idLinea: String = curPT.valueBuffer("idlinea");
  //  if (!util.sqlDelete("productoslp", "idlinea = " + idLinea + " AND referencia <> 'TAREA_MANUAL'")) {
  //    return false;
  //  }

  if (!this.iface.regenerarTaco(curPT))
  {
    return false;
  }
  if (!this.iface.regenerarEnvioProducto(curPT))
  {
    return false;
  }
  //  if (!this.iface.regenerarTMProducto(curPT)) {
  //    return false;
  //  }
  return true;
}

function artesG_regenerarIptico(curPI: FLSqlCursor): Boolean {
  var util: FLUtil = new FLUtil;

  var idLinea: String = curPI.valueBuffer("idlinea");

  /// Busca el producto Iptico principal
  var idProducto: String = util.sqlSelect("productoslp p LEFT OUTER JOIN paramiptico pi ON p.idproducto = pi.idproducto", "p.idproducto", "p.idlinea = " + idLinea + " AND p.referencia = 'IPTICO' AND pi.idproducto IS NULL", "productoslp,paramiptico");
  var curProducto: FLSqlCursor = new FLSqlCursor("productoslp");
  if (idProducto)
  {
    curProducto.select("idproducto = " + idProducto);
    if (!curProducto.first()) {
      return false;
    }
    curProducto.setModeAccess(curProducto.Del);
    curProducto.refreshBuffer();
    if (!curProducto.commitBuffer()) {
      return false;
    }
  }

  var idComponente: Number = 0;

  curProducto.setModeAccess(curProducto.Insert);
  curProducto.refreshBuffer();
  curProducto.setValueBuffer("idlinea", idLinea);
  curProducto.setValueBuffer("referencia", "IPTICO");
  curProducto.setValueBuffer("descripcion", curPI.valueBuffer("descripcion"));
  curProducto.setValueBuffer("idcomponente", idComponente);
  curProducto.setValueBuffer("original", true);
  curProducto.setValueBuffer("seleccionado", true);
  if (!curProducto.commitBuffer())
  {
    return false;
  }
  return true;
}

function artesG_regenerarTaco(curPT: FLSqlCursor): Boolean {
  var util: FLUtil = new FLUtil;

  var idLinea: String = curPT.valueBuffer("idlinea");

  var curProducto: FLSqlCursor = new FLSqlCursor("productoslp");
  var idComponente: Number = 0;

  /// Busca el producto Taco principal
  var idProducto: String = util.sqlSelect("productoslp p LEFT OUTER JOIN paramtaco pt ON p.idproducto = pt.idproducto", "p.idproducto", "p.idlinea = " + idLinea + " AND p.referencia = 'TACO' AND pt.idproducto IS NULL", "productoslp,paramtaco");
  var curProducto: FLSqlCursor = new FLSqlCursor("productoslp");
  if (idProducto)
  {
    curProducto.select("idproducto = " + idProducto);
    if (!curProducto.first()) {
      return false;
    }
    curProducto.setModeAccess(curProducto.Del);
    curProducto.refreshBuffer();
    if (!curProducto.commitBuffer()) {
      return false;
    }
  }

  curProducto.setModeAccess(curProducto.Insert);
  curProducto.refreshBuffer();
  curProducto.setValueBuffer("idlinea", idLinea);
  curProducto.setValueBuffer("referencia", "TACO");
  curProducto.setValueBuffer("descripcion", curPT.valueBuffer("descripcion"));
  curProducto.setValueBuffer("idcomponente", idComponente);
  curProducto.setValueBuffer("original", true);
  curProducto.setValueBuffer("seleccionado", true);
  if (!curProducto.commitBuffer())
  {
    return false;
  }
  return true;
}

function artesG_svnPaginasTrabajo(x: Number, y: Number, w: Number, h: Number, distPaginasTrabajo: String, apaisado: Boolean): String {
  // debug("distPaginasTrabajo = " + distPaginasTrabajo);
  var svg: String = "";

  var dist: Array = distPaginasTrabajo.split("x");
  var paginasX: Number;
  var paginasY: Number;
  if (apaisado)
  {
    paginasX = parseInt(dist[1]);
    paginasY = parseInt(dist[0]);
  } else {
    paginasX = parseInt(dist[0]);
    paginasY = parseInt(dist[1]);
  }
  // debug("paginasX = " + paginasX);
  // debug("paginasY = " + paginasY);
  var xPag: Number;
  var yPag: Number;
  var wPag: Number = parseInt(w / paginasX);
  var hPag: Number = parseInt(h / paginasY);
  for (var i: Number = 0; i < paginasX; i++)
  {
    xPag = x + (i * wPag);
    if (i > 0) {
      svg += "<line x1='" + xPag + "' x2='" + xPag + "' y1='" + y + "' y2='" + parseInt(y + h) + "' stroke='cyan' />\n";
    }
  }
  for (var k: Number = 0; k < paginasY; k++)
  {
    yPag = y + (k * hPag);
    if (k > 0) {
      svg += "<line x1='" + x + "' x2='" + parseInt(x + w) + "' y1='" + yPag + "' y2='" + yPag + "' stroke='cyan' />\n";
    }
    //      svg += "<rect x='" + parseInt(xPag + 2) + "' width='" + (wPag - 4) + "' y='" + parseInt(yPag + 2) + "' height='" + (hPag - 4) + "' fill='cyan' />\n";
    //      svg += "<line x1='" + xPag + "' x2='" + parseInt(xPag + wPag) + "' y1='" + yPag + "' y2='" + parseInt(yPag + hPag) + "' />\n";
    //      svg += "<line x1='" + xPag + "' x2='" + parseInt(xPag + wPag) + "' y1='" + parseInt(yPag + hPag) + "' y2='" + yPag + "' />\n";
  }
  return svg;
}

/// Cuando el troquel es simétrico y el número de trabajos por pliego es 1 el trabajo admite tira retira
function artesG_troqueladoSimetrico(xmlProceso: FLDomNode): Boolean {
  var troquelSimetrico: Boolean = false;
  var nodoTrabajosPliego: FLDomNode = this.iface.dameNodoXML(xmlProceso, "Parametros/TrabajosPliegoParam");
  var nodosTrabajoPliego: FLDomNodeList = nodoTrabajosPliego.toElement().elementsByTagName("Trabajo");
  var totalTP: Number = nodosTrabajoPliego.length();
  if (totalTP == 1)
  {
    var nodoTroquelado: FLDomNode = this.iface.dameNodoXML(xmlProceso, "Parametros/TroqueladoParam");
    if (nodoTroquelado && nodoTroquelado.toElement().attribute("Simetria") == "true") {
      troquelSimetrico = true;
    }
  }
  return troquelSimetrico;
}

/** \C Construye un array con las posibles distribuciones de modelos en planchas. Por ejemplo, 4 modelos en 2 planchas se pueden distribuir como "3 + 1", "2 + 2".
@param  numModelo: Número de modelos
@param  numPlanchas: Número de planchas
@return array con el formato ["3+1", "2+2"]
(Esta función puede cachearse)
\end */
function artesG_obtenerCombiModeloPlancha(numModelos: Number, numPlanchas: Number, prefijo: String, tope: Number): Array {
  // debug("artesG_obtenerCombiModeloPlancha ");
  // debug("modelos =  " + numModelos);
  // debug("planchas =  " + numPlanchas);
  // debug("prefijo=  " + prefijo);
  // debug("tope =  " + tope);
  // MessageBox.information("pausa", MessageBox.Ok, MessageBox.NoButton);
  var combi: Array = [];

  if (numModelos == numPlanchas)
  {
    if (prefijo && prefijo != "") {
      combi[0] = prefijo + "+";
    } else {
      combi[0] = "";
    }
    for (var m: Number = 0; m < numModelos; m++) {
      if (m > 0) {
        combi[0] += "+";
      }
      combi[0] += "1";
    }
  } else if (numPlanchas == 1)
  {
    debug("numPlanchas == 1 tope = " + tope);
    if (!tope || numModelos <= tope) {
      if (prefijo && prefijo != "") {
        combi[0] = prefijo + "+" + numModelos.toString();
      } else {
        combi[0] = numModelos;
      }
      debug("combi[0] = " + combi[0]);
    }
  } else {
    var valorInicial: Number = numModelos - numPlanchas + 1;
    if (tope && valorInicial > tope)
    {
      valorInicial = tope;
    }
    var valorFin: Number = Math.ceil(numModelos / numPlanchas);
    var nuevoPrefijo: String;
    //    for (var i:Number = valorInicial; i >= numPlanchas; i--) {
    for (var i: Number = valorInicial; i >= valorFin; i--)
    {
      if (prefijo && prefijo != "") {
        nuevoPrefijo = prefijo + "+" + i.toString();
      } else {
        nuevoPrefijo = i.toString();
      }
      combi = combi.concat(this.iface.obtenerCombiModeloPlancha(numModelos - i, numPlanchas - 1, nuevoPrefijo, i));
    }
  }
  debug("Combi modelo plancha para Planchas " + numPlanchas + " modelos " + numModelos);
  for (var l: Number = 0; l < combi.length; l++)
  {
    debug(combi[l]);
  }
  return combi;
}

/** \C Obtiene la distribución de modelos en plancha que minimiza las pasadas necesarias
@param  nodoPaginas: Nodo XML que contiene la información de modelos y cantidades
@param  numPlanchas: Número de planchas
@param  numTrabajosPlancha: Número de trabajos en cada plancha
@return (POR HACER) array con elementos que a su vez son un array:
Plancha:
 - iModelo
 - numTrabajos
(Esta función puede cachearse)
\end */
function artesG_distOptimaModelosPlanchas(nodoPaginas: FLDomNode, numPlanchas: Number, numTrabajosPlancha: Number): Array {
  debug("artesG_distOptimaModelosPlanchas Planchas = " + numPlanchas + " TP = " + numTrabajosPlancha);
  var resultado: Array = new Array(numPlanchas);
  var canPorModelo: Boolean = (nodoPaginas.toElement().attribute("CantidadesPorModelo") == "true");
  var tirada: Number;
  var eficiencia: Number;
  var minTirada: Number;

  var optimo: Array;
  var ordenOptimo: Array;
  var combiOptima: String;
  var cantidadesModelo: Array = this.iface.dameArrayDist(nodoPaginas);
  var canModeloPlancha: Array = [];
  if (!canPorModelo)
  {
    var numModelos: Number = parseInt(nodoPaginas.toElement().attribute("NumPaginas"));
    var modelosRestantes: Number = numModelos;
    var iModelo: Number = 0;
    var m: Number;
    ordenOptimo = [];
    for (var i: Number = 0; i < numModelos; i++) {
      ordenOptimo[i] = i;
    }
    combiOptima = "";
    var modelosDistintosPlancha: Number;
    for (var p: Number = 0; p < numPlanchas; p++) {
      modelosDistintosPlancha = Math.ceil(modelosRestantes / (numPlanchas - p));
      modelosRestantes -= parseInt(modelosDistintosPlancha);
      if (p > 0) {
        combiOptima += "+";
      }
      combiOptima += modelosDistintosPlancha.toString();
    }
    optimo = this.iface.evaluarCombiModelo(combiOptima, ordenOptimo, cantidadesModelo, numTrabajosPlancha);
    optimo.pop();
  } else {
    var minPasadas: Number = -1;
    var numModelos: Number = cantidadesModelo.length;
    var combiModeloPlancha: Array = this.iface.obtenerCombiModeloPlancha(numModelos, numPlanchas, "", numTrabajosPlancha);
    if (combiModeloPlancha.length == 0) return false;
    var arrayCombiModelos: Array = this.iface.dameArrayCombiModelos(numModelos);
    var iOptimo: Number = -1;
    var kOptimo: Number = -1;
    for (var i: Number = 0; i < combiModeloPlancha.length; i++)
    {
      for (var k: Number = 0; k < arrayCombiModelos.length; k++) {
        canModeloPlancha = this.iface.evaluarCombiModelo(combiModeloPlancha[i], arrayCombiModelos[k], cantidadesModelo, numTrabajosPlancha);
        numPasadas = canModeloPlancha.pop();
        debug("numPasadas = " + numPasadas);
        if (minPasadas == -1 || numPasadas < minPasadas) {
          debug("Mínimo ");
          for (var indice: Number = 0; indice < canModeloPlancha.length; indice++) {
            optimo[indice] = canModeloPlancha[indice];
          }
          minPasadas = numPasadas;
          iOptimo = i;
          kOptimo = k;
        }
      }
    }
    ordenOptimo = arrayCombiModelos[kOptimo];
    combiOptima = combiModeloPlancha[iOptimo];
  }
  debug("Optima -_____________");
  debug("CanModelo= " + cantidadesModelo.join("-"));
  if (ordenOptimo)
  {
    //    debug("Orden= " + arrayCombiModelos[kOptimo].join("-"));
    debug("Orden= " + ordenOptimo.join("-"));
  }
  debug("Optimo = " + optimo.join("-"));

  //  debug("Dist = " + combiModeloPlancha[iOptimo]);
  debug("Dist = " + combiOptima);

  //  debug("Pasadas = " + minPasadas);
  var iModelo: Number = 0;
  var arrayCMP: Array = combiOptima.toString().split("+");
  var m: Number;
  var canNecesaria: Number;
  var canReal: Number;
  for (var p: Number = 0; p < numPlanchas; p++)
  {
    resultado[p] = [];
    minTirada = 0;
    canNecesaria = 0;
    for (m = 0; m < arrayCMP[p]; m++) {
      resultado[p][m] = [];
      resultado[p][m]["modelo"] = ordenOptimo[iModelo];
      resultado[p][m]["cantidad"] = optimo[iModelo];
      debug("Plancha " + p + " Modelo " + ordenOptimo[iModelo] + " cantidad " + optimo[iModelo]);
      iModelo++;
      tirada = Math.ceil(cantidadesModelo[resultado[p][m]["modelo"]] / resultado[p][m]["cantidad"]);
      if (tirada > minTirada) {
        minTirada = tirada;
      }
      canNecesaria += parseInt(cantidadesModelo[resultado[p][m]["modelo"]]);
    }
    resultado[p].push(minTirada);
    canReal = minTirada * numTrabajosPlancha;
    eficiencia = (100 * canNecesaria) / canReal;
    resultado[p].push(eficiencia);
    debug("Tirada " + tirada);
    debug("Can real " + canReal);
    debug("Can necesaria " + canNecesaria);
    debug("Eficiencia " + eficiencia);
  }

  return resultado;
}

/** \C Evalúa las pasadas necesarias para una determinada distribucion de modelos
@param  combiModelosPlancha: String que contiene la distribución en cantidades de los modelos en todas las planchas. Ej. 3 + 1 + 1
@param  arrayCombiModelos: Array que contiene el orden en el que ir tomando los modelos. Ej. [0, 2, 3, 4, 1]
@param  cantidadesModelo: Array que contiene las cantidades a producir para cada modelo. Ej. [10, 12, 24, 12, 50]
@param  numTrabajosPlancha: Número de trabajos en cada plancha
@return Array con las cantidades de cada modelo a incluir en cada plancha. Ej [1, 2, 1, 4, 4] (los tres primeros en la primera pancha y los demás uno en cada plancha.
----(Datos de ejemplo no reales ni comprobados)
\end */
function artesG_evaluarCombiModelo(combiModeloPlancha: String, arrayCombiModelos: Array, cantidadesModelo: Array, numTrabajosPlancha: Number): Array {
  var numModelosXPlancha: Array = combiModeloPlancha.toString().split("+");
  debug("evaluando " + combiModeloPlancha + " para " + arrayCombiModelos.join("-"));
  var numModeloPlancha: Array;
  var canModeloPlanchas: Array = [];
  //  iModeloPlanchas:Number = 0;
  var iCombi: Number = 0;
  var pasadas: Number = 0;
  var totalPasadas: Number = 0;
  for (var iPlancha: Number = 0; iPlancha < numModelosXPlancha.length; iPlancha++)
  {
    numModeloPlancha = [];
    for (var iModPlancha: Number = 0; iModPlancha < parseInt(numModelosXPlancha[iPlancha]); iModPlancha++) {
      numModeloPlancha[iModPlancha] = cantidadesModelo[arrayCombiModelos[iCombi]];
      iCombi++;
    }
    canModeloPlanchas = canModeloPlanchas.concat(this.iface.calcularCombiPlancha(numModeloPlancha, numTrabajosPlancha));
    pasadas = canModeloPlanchas.pop();
    totalPasadas += parseInt(pasadas);
  }
  canModeloPlanchas.push(totalPasadas);
  debug("resultado = " + canModeloPlanchas.join("-"));
  return canModeloPlanchas;
}

/** \C Calcula la distribución de tabajos en una única plancha, así como el número mínimo de pasadas necesarias
@param  numModeloPlancha: Array con el número de copas necesarias para cada modelo. Ej. 90, 30
@param  numTrabajosPlancha: Número de trabajos en cada plancha
@return Array con las cantidades de cada modelo a incluir la plancha, más un parámetro extra que es el número de pasadas . Ej [3, 1, 30]]
\end */
function artesG_calcularCombiPlancha(numModeloPlancha: Array, numTrabajosPlancha: Number): Array {
  debug("artesG_calcularCombiPlancha de " + numModeloPlancha.join("-") + " en " + numTrabajosPlancha + " trabajos");
  var resultado: Array = [];
  var pasadas: Number;
  var maxPasadas: Number = 0;
  var totalCopias: Number = 0;
  var totalModelos: Number = numModeloPlancha.length;
  var cantidadesIguales: Boolean = true;
  var cantidadMP: Number = 0;
  for (var i: Number = 0; i < totalModelos; i++)
  {
    if (cantidadMP != 0 && cantidadMP != numModeloPlancha[i]) {
      cantidadesIguales = false;
    }
    cantidadMP = numModeloPlancha[i];
    totalCopias += parseInt(cantidadMP);
  }
  // debug("totalCopias = " + totalCopias);
  /// Cuando cantidadesIguales está activo no tiene sentido dejar huecos, ya que el número de pasadas será el mismo.
  var ocupados: Number = 0;
  for (var i: Number = 0; i < totalModelos; i++)
  {
    //    if (i == (totalModelos - 1) && !cantidadesIguales) {
    //      resultado[i] = numTrabajosPlancha - ocupados;
    //    } else {
    //      if (cantidadesIguales) {
    resultado[i] = Math.floor(numModeloPlancha[i] * numTrabajosPlancha / totalCopias);
    //      } else {
    //        resultado[i] = Math.round(numModeloPlancha[i] * numTrabajosPlancha / totalCopias);
    debug("resultado[i] = " + resultado[i]);
    //      }
    if (resultado[i] == 0) {
      resultado[i] = 1;
    }
    ocupados += parseInt(resultado[i]);
    //    }
    // debug("resultado[" + i + "] = " + resultado[i]);
    //    pasadas = Math.ceil(numModeloPlancha[i] / resultado[i]);
    // debug("pasadas = " + pasadas);
    // debug("pasadas = " + pasadas);
    //    if (pasadas > maxPasadas) {
    //      maxPasadas = pasadas;
    //    }
  }
  if (!cantidadesIguales)
  {
    var iMax: Number;
    while (ocupados < numTrabajosPlancha) {
      maxPasadas = 0;
      iMax = -1
      for (var i: Number = 0; i < resultado.length; i++) {
        pasadas = Math.ceil(numModeloPlancha[i] / resultado[i]);
        if (pasadas > maxPasadas) {
          maxPasadas = pasadas;
          iMax = i;
        }
      }
      resultado[iMax]++;
      ocupados++;
    }
    while (ocupados > numTrabajosPlancha) {
      maxPasadas = 0;
      iMax = -1;
      for (var i: Number = 0; i < resultado.length; i++) {
        if (resultado[i] == 1) {
          continue;
        }
        pasadas = Math.ceil(numModeloPlancha[i] / resultado[i]);
        if (pasadas > maxPasadas) {
          maxPasadas = pasadas;
          iMax = i;
        }
      }
      resultado[iMax]--;
      ocupados--;
    }
    maxPasadas = 0;
    for (var i: Number = 0; i < resultado.length; i++) {
      pasadas = Math.ceil(numModeloPlancha[i] / resultado[i]);
      if (pasadas > maxPasadas) {
        maxPasadas = pasadas;
      }
    }
  } else {
    maxPasadas = Math.ceil(numModeloPlancha[0] / resultado[0]);
  }

  resultado.push(maxPasadas);
  debug("resultado + pasadas = " + resultado.join("-"));
  return resultado;
}

/** \C Genera un array de arrays con todas las combinaciones posibles de un determinado número de modelos
@param  numModelos: Número de modelos
@return Array con combinacion. Para numModelos = 3 el resultado es [[0,1,2],[0,2,1],[1,0,2],[1,2,0],[2,0,1],[2,1,0]]
Función cacheable
\end */
function artesG_dameArrayCombiModelos(numModelos: Number): Array {
  var combi: Array = [];
  for (var i: Number = 0; i < numModelos; i++)
  {
    combi[i] = i;
  }
  var combinaciones: Array = this.iface.combiModelos(combi);
  for (var i: Number = 0; i < combinaciones.length; i++)
  {
    debug(combinaciones[i].join("-"));
  }
  return combinaciones;
}

/** \C Función recursiva usada por dameArrayCombiModels
@param  combi: Array a combinar
@return array lista de combinaciones
\end */
function artesG_combiModelos(combi: Array): Array {
  debug("Combi modelos para " + combi.join("-"));
  var combinaciones: Array = [];
  var numElementos: Number = combi.length;
  var arrayCopia: Array;
  var combinacionesAnt: Array;
  if (numElementos == 1)
  {
    combinaciones[0] = [];
    combinaciones[0][0] = combi[0];
  } else {
    var indice: Number = 0;
    for (var i: Number = 0; i < numElementos; i++)
    {
      arrayCopia = this.iface.copiarArrayCombi(combi, i);
      combinacionesAnt = this.iface.combiModelos(arrayCopia);
      for (var k: Number = 0; k < combinacionesAnt.length; k++) {
        // debug("Combi antes = " + combinacionesAnt[k].join("-"));
        combinacionesAnt[k].unshift(combi[i]);
        // debug("Combi despues = " + combinacionesAnt[k].join("-"));
        // debug("");
        combinaciones[indice] = combinacionesAnt[k];
        indice++;
      }
    }
  }
  return combinaciones;
}

/** \C Copia un array en otro excluyendo uno de sus elementos
@param  combi: Array a copiar
@param  iExcepcion: Índice del elemento a excluir
@return Array copia
\end */
function artesG_copiarArrayCombi(combi: Array, iExcepcion: Number): Array {
  var res: Array = [];
  var iCopia: Number = 0;
  for (var i: Number = 0; i < combi.length; i++)
  {
    if (i != iExcepcion) {
      res[iCopia++] = combi[i];
    }
  }
  return res;
}

/** \D Guarda un problema resuelto en la tabla de caché
@param xmlDocValoresParam: Doc. XML de parámetros que definen el problema.
@param idProducto: Identificador del producto cuya solución se ha calculado
@param tipoParam: Tipo de parámetros del productos
@param idParam: Id. del registro de parametros que los guarda.
\end */
function artesG_guardarCache(xmlDocValoresParam: FLDomDocument, idProducto: String, tipoParam: String, idParam: String): Boolean {
  debug("artesG_guardarCache");
  var util: FLUtil = new FLUtil;
  var mejorIt: String = util.sqlSelect("itinerarioslp", "xmlparametros", "idproducto = " + idProducto + " AND escogido = true");
  if (!mejorIt)
  {
    debug("sin solucion");
    return false;
  }
  var xmlMejorIt: FLDomDocument = new FLDomDocument;
  xmlMejorIt.setContent(mejorIt);
  var nodoParam: FLDomNode = xmlMejorIt.firstChild().namedItem("Parametros");
  var xmlSolucion: FLDomDocument = new FLDomDocument;
  xmlSolucion.appendChild(nodoParam.cloneNode());
  var solucion: String = xmlSolucion.toString();
  var problema: String = xmlDocValoresParam.toString();
  var sha: String = util.sha1(problema);
  var curCache: FLSqlCursor = new FLSqlCursor("cachetrabajos");
  curCache.select("id = '" + sha + "'");
  if (curCache.first())
  {
    curCache.setModeAccess(curCache.Edit);
    curCache.refreshBuffer();
  } else {
    curCache.setModeAccess(curCache.Insert);
    curCache.refreshBuffer();
    curCache.setValueBuffer("id", sha);
    curCache.setValueBuffer("problema", problema);
    curCache.setValueBuffer("tipotrabajo", tipoParam);
    curCache.setValueBuffer("idparametros", idParam);
  }
  curCache.setValueBuffer("solucion", solucion);
  curCache.commitBuffer();
  debug("OK");
  return true;
}

function artesG_beforeCommit_productoslp(curProd: FLSqlCursor): Boolean {
  if (!this.iface.borrarElementosProducto(curProd))
  {
    return false;
  }
  return true;
}

function artesG_borrarElementosProducto(curProd: FLSqlCursor): Boolean {
  switch (curProd.modeAccess())
  {
    case curProd.Del: {
      var curItinerario: FLSqlCursor = new FLSqlCursor("itinerarioslp");
      curItinerario.setActivatedCheckIntegrity(false);
      curItinerario.select("idproducto = " + curProd.valueBuffer("idproducto"));
      curItinerario.setForwardOnly(true);
      while (curItinerario.next()) {
        curItinerario.setModeAccess(curItinerario.Del);
        curItinerario.refreshBuffer();
        if (!curItinerario.commitBuffer()) {
          return false;
        }
      }
      break;
    }
  }
  return true;
}

function artesG_beforeCommit_itinerarioslp(curIt: FLSqlCursor): Boolean {
  if (!this.iface.borrarElementosItinerario(curIt))
  {
    return false;
  }
  return true;
}

function artesG_borrarElementosItinerario(curIt: FLSqlCursor): Boolean {
  switch (curIt.modeAccess())
  {
    case curIt.Del: {
      var curTarea: FLSqlCursor = new FLSqlCursor("tareaslp");
      curTarea.setActivatedCheckIntegrity(false);
      curTarea.select("iditinerario = " + curIt.valueBuffer("iditinerario"));
      curTarea.setForwardOnly(true);
      while (curTarea.next()) {
        curTarea.setModeAccess(curTarea.Del);
        curTarea.refreshBuffer();
        if (!curTarea.commitBuffer()) {
          return false;
        }
      }
      break;
    }
  }
  return true;
}
//// ARTES GRÁFICAS /////////////////////////////////////////////
////////////////////////////////////////////////////////////////
