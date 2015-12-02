
/** @class_declaration artesG */
/////////////////////////////////////////////////////////////////
//// ARTES GRÁFICAS /////////////////////////////////////////////
class artesG extends articuloscomp
{
  var curPresupuesto_: FLSqlCursor;
  var curLineaPresupuesto_: FLSqlCursor;
  var curProducto_: FLSqlCursor;
  var curParamIptico_: FLSqlCursor;
  var curParamLibro_: FLSqlCursor;
  var curParamCantidad_: FLSqlCursor;
  var curParamColor_: FLSqlCursor;
  var curParamEnvio_: FLSqlCursor;
  var curPaginasLibro_: FLSqlCursor;
  var curTrabExterno_: FLSqlCursor;
  var curParamTM_: FLSqlCursor;
  var curParamTaco_: FLSqlCursor;
  var curItinerario_: FLSqlCursor;
  var curTarea_: FLSqlCursor;
  var curConsumosTM_: FLSqlCursor;
  var filtroAnterior_: String;

  function artesG(context)
  {
    articuloscomp(context);
  }
  function init()
  {
    return this.ctx.artesG_init();
  }
  function copiaLineas(idPresupuesto: Number, idPedido: Number): Boolean {
    return this.ctx.artesG_copiaLineas(idPresupuesto, idPedido);
  }
  function tbnBuscar_clicked()
  {
    return this.ctx.artesG_tbnBuscar_clicked();
  }
  function duplicarLineasPresupuesto(idOriginal: String, idCopia: String): Boolean {
    return this.ctx.artesG_duplicarLineasPresupuesto(idOriginal, idCopia);
  }
  function duplicarProductos(idOriginal: String, idCopia: String): Boolean {
    return this.ctx.artesG_duplicarProductos(idOriginal, idCopia);
  }
  function duplicarItinerarios(idOriginal: String, idCopia: String): Boolean {
    return this.ctx.artesG_duplicarItinerarios(idOriginal, idCopia);
  }
  function duplicarTareas(idOriginal: String, idCopia: String): Boolean {
    return this.ctx.artesG_duplicarTareas(idOriginal, idCopia);
  }
  function duplicarParamIptico(idOriginal: String, idCopia: String, campoPadre: String): Boolean {
    return this.ctx.artesG_duplicarParamIptico(idOriginal, idCopia, campoPadre);
  }
  function duplicarParamTaco(idOriginal: String, idCopia: String): Boolean {
    return this.ctx.artesG_duplicarParamTaco(idOriginal, idCopia);
  }
  function duplicarParamLibro(idOriginal: String, idCopia: String): Boolean {
    return this.ctx.artesG_duplicarParamLibro(idOriginal, idCopia);
  }
  function duplicarParamTareaManual(idOriginal: String, idCopia: String): Boolean {
    return this.ctx.artesG_duplicarParamTareaManual(idOriginal, idCopia);
  }
  function duplicarConsumosTM(idOriginal: String, idCopia: String): Boolean {
    return this.ctx.artesG_duplicarConsumosTM(idOriginal, idCopia);
  }
  function duplicarParamCantidad(idOriginal: String, idCopia: String): Boolean {
    return this.ctx.artesG_duplicarParamCantidad(idOriginal, idCopia);
  }
  function duplicarParamColor(idOriginal: String, idCopia: String): Boolean {
    return this.ctx.artesG_duplicarParamColor(idOriginal, idCopia);
  }
  function duplicarParamEnvio(idOriginal: String, idCopia: String, campoPadre: String): Boolean {
    return this.ctx.artesG_duplicarParamEnvio(idOriginal, idCopia, campoPadre);
  }
  function duplicarPaginasLibro(idOriginal: String, idCopia: String): Boolean {
    return this.ctx.artesG_duplicarPaginasLibro(idOriginal, idCopia);
  }
  function duplicarTrabExternosLibro(idOriginal: String, idCopia: String): Boolean {
    return this.ctx.artesG_duplicarTrabExternosLibro(idOriginal, idCopia);
  }
  function copiarCampoPresupuesto(nombreCampo: String, curOriginal: FLSqlCursor, campoInformado: Array): Boolean {
    return this.ctx.artesG_copiarCampoPresupuesto(nombreCampo, curOriginal, campoInformado);
  }
  function copiarCampoLineaPresupuesto(nombreCampo: String, curOriginal: FLSqlCursor, campoInformado: Array): Boolean {
    return this.ctx.artesG_copiarCampoLineaPresupuesto(nombreCampo, curOriginal, campoInformado);
  }
  function copiarCampoProducto(nombreCampo: String, curOriginal: FLSqlCursor, campoInformado: Array): Boolean {
    return this.ctx.artesG_copiarCampoProducto(nombreCampo, curOriginal, campoInformado);
  }
  function copiarCampoParamIptico(nombreCampo: String, curOriginal: FLSqlCursor, campoInformado: Array): Boolean {
    return this.ctx.artesG_copiarCampoParamIptico(nombreCampo, curOriginal, campoInformado);
  }
  function copiarCampoItinerario(nombreCampo: String, curOriginal: FLSqlCursor, campoInformado: Array): Boolean {
    return this.ctx.artesG_copiarCampoItinerario(nombreCampo, curOriginal, campoInformado);
  }
  function copiarCampoTarea(nombreCampo: String, curOriginal: FLSqlCursor, campoInformado: Array): Boolean {
    return this.ctx.artesG_copiarCampoTarea(nombreCampo, curOriginal, campoInformado);
  }
  function copiarCampoParamTaco(nombreCampo: String, curOriginal: FLSqlCursor, campoInformado: Array): Boolean {
    return this.ctx.artesG_copiarCampoParamTaco(nombreCampo, curOriginal, campoInformado);
  }
  function copiarCampoParamLibro(nombreCampo: String, curOriginal: FLSqlCursor, campoInformado: Array): Boolean {
    return this.ctx.artesG_copiarCampoParamLibro(nombreCampo, curOriginal, campoInformado);
  }
  function copiarCampoParamTM(nombreCampo: String, curOriginal: FLSqlCursor, campoInformado: Array): Boolean {
    return this.ctx.artesG_copiarCampoParamTM(nombreCampo, curOriginal, campoInformado);
  }
  function copiarCampoParamCantidad(nombreCampo: String, curOriginal: FLSqlCursor, campoInformado: Array): Boolean {
    return this.ctx.artesG_copiarCampoParamCantidad(nombreCampo, curOriginal, campoInformado);
  }
  function copiarCampoParamColor(nombreCampo: String, curOriginal: FLSqlCursor, campoInformado: Array): Boolean {
    return this.ctx.artesG_copiarCampoParamColor(nombreCampo, curOriginal, campoInformado);
  }
  function copiarCampoParamEnvio(nombreCampo: String, curOriginal: FLSqlCursor, campoInformado: Array): Boolean {
    return this.ctx.artesG_copiarCampoParamEnvio(nombreCampo, curOriginal, campoInformado);
  }
  function copiarCampoConsumosTM(nombreCampo: String, curOriginal: FLSqlCursor, campoInformado: Array): Boolean {
    return this.ctx.artesG_copiarCampoConsumosTM(nombreCampo, curOriginal, campoInformado);
  }
  function copiarCampoPaginaLibro(nombreCampo: String, curOriginal: FLSqlCursor, campoInformado: Array): Boolean {
    return this.ctx.artesG_copiarCampoPaginaLibro(nombreCampo, curOriginal, campoInformado);
  }
  function copiarCampoTrabExterno(nombreCampo: String, curOriginal: FLSqlCursor, campoInformado: Array): Boolean {
    return this.ctx.artesG_copiarCampoTrabExterno(nombreCampo, curOriginal, campoInformado);
  }
  function generarPedido(cursor: FLSqlCursor): Number {
    return this.ctx.artesG_generarPedido(cursor);
  }
  function validarAprobacionesPres(cursor: FLSqlCursor): Boolean {
    return this.ctx.artesG_validarAprobacionesPres(cursor);
  }
  function generarOrdenLinea(qryLinea: FLSqlQuery): Boolean {
    return this.ctx.artesG_generarOrdenLinea(qryLinea);
  }
  function generarOrdenesPedido(idPedido: String): Boolean {
    return this.ctx.artesG_generarOrdenesPedido(idPedido);
  }
}
//// ARTES GRÁFICAS /////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition artesG */
/////////////////////////////////////////////////////////////////
//// ARTES GRÁFICAS /////////////////////////////////////////////
function artesG_init()
{
  this.iface.__init();

  this.iface.filtroAnterior_ = "";

  var util: FLUtil = new FLUtil;

  var columnas: Array = ["codigo", "editable", "fecha", "nombre", "neto", "total"];
  this.iface.tdbRecords.setOrderCols(columnas);
  connect(this.child("tbnBuscar"), "clicked()", this, "iface.tbnBuscar_clicked");
}

function artesG_duplicarLineasPresupuesto(idOriginal: String, idCopia: String): Boolean {
  debug("artesG_duplicarLineasPresupuesto " + idOriginal);
  var util: FLUtil = new FLUtil;

  var camposLinea: Array = util.nombreCampos("lineaspresupuestoscli");
  var totalCampos: Number = camposLinea[0];

  var campoInformado: Array = [];

  if (!this.iface.curLineaPresupuesto_)
  {
    this.iface.curLineaPresupuesto_ = new FLSqlCursor("lineaspresupuestoscli");
  }

  var idLinea: String;
  var curOriginal: FLSqlCursor = new FLSqlCursor("lineaspresupuestoscli");
  curOriginal.select("idpresupuesto = " + idOriginal);
  while (curOriginal.next())
  {
    curOriginal.setModeAccess(curOriginal.Browse);
    curOriginal.refreshBuffer();

    for (var i: Number = 1; i <= totalCampos; i++) {
      campoInformado[camposLinea[i]] = false;
    }
    this.iface.curLineaPresupuesto_.setModeAccess(this.iface.curLineaPresupuesto_.Insert);
    this.iface.curLineaPresupuesto_.refreshBuffer();
    this.iface.curLineaPresupuesto_.setValueBuffer("idpresupuesto", idCopia);
    for (var i: Number = 1; i <= totalCampos; i++) {
      if (!this.iface.copiarCampoLineaPresupuesto(camposLinea[i], curOriginal, campoInformado)) {
        return false;
      }
    }
    if (!this.iface.curLineaPresupuesto_.commitBuffer()) {
      return false;
    }
    idLinea = this.iface.curLineaPresupuesto_.valueBuffer("idlinea");
    if (!this.iface.duplicarParamIptico(curOriginal.valueBuffer("idlinea"), idLinea, "idlinea")) {
      return false;
    }
    if (!this.iface.duplicarParamLibro(curOriginal.valueBuffer("idlinea"), idLinea)) {
      return false;
    }
    if (!this.iface.duplicarParamTaco(curOriginal.valueBuffer("idlinea"), idLinea)) {
      return false;
    }
    if (!this.iface.duplicarProductos(curOriginal.valueBuffer("idlinea"), idLinea)) {
      return false;
    }
  }
  return true;
}

function artesG_duplicarProductos(idOriginal: String, idCopia: String): Boolean {
  debug("artesG_duplicarProductos " + idOriginal);
  var util: FLUtil = new FLUtil;

  var campos: Array = util.nombreCampos("productoslp");
  var totalCampos: Number = campos[0];

  var campoInformado: Array = [];

  if (!this.iface.curProducto_)
  {
    this.iface.curProducto_ = new FLSqlCursor("productoslp");
  }

  var idProducto: String, refProducto: String;
  var curOriginal: FLSqlCursor = new FLSqlCursor("productoslp");
  curOriginal.select("idlinea = " + idOriginal);
  while (curOriginal.next())
  {
    curOriginal.setModeAccess(curOriginal.Browse);
    curOriginal.refreshBuffer();

    for (var i: Number = 1; i <= totalCampos; i++) {
      campoInformado[campos[i]] = false;
    }
    this.iface.curProducto_.setModeAccess(this.iface.curProducto_.Insert);
    this.iface.curProducto_.refreshBuffer();
    this.iface.curProducto_.setValueBuffer("idlinea", idCopia);
    for (var i: Number = 1; i <= totalCampos; i++) {
      if (!this.iface.copiarCampoProducto(campos[i], curOriginal, campoInformado)) {
        return false;
      }
    }
    if (!this.iface.curProducto_.commitBuffer()) {
      return false;
    }
    idProducto = this.iface.curProducto_.valueBuffer("idproducto");
    refProducto = this.iface.curProducto_.valueBuffer("referencia");
    switch (refProducto) {
      case "IPTICO": {
        if (!this.iface.duplicarParamIptico(curOriginal.valueBuffer("idproducto"), idProducto, "idproducto")) {
          return false;
        }
        break;
      }
      //      case "LIBRO": {
      //        if (!this.iface.duplicarParamLibro(curOriginal.valueBuffer("idproducto") ,idProducto)) {
      //          return false;
      //        }
      //        break;
      //      }
      case "TAREA_MANUAL": {
        if (!this.iface.duplicarParamTareaManual(curOriginal.valueBuffer("idproducto"), idProducto)) {
          return false;
        }
        break;
      }
      case "ENVIO": {
        if (!this.iface.duplicarParamEnvio(curOriginal.valueBuffer("idproducto"), idProducto)) {
          return false;
        }
        break;
      }
      //      case "TACO": {
      //        if (!this.iface.duplicarParamTaco(curOriginal.valueBuffer("idproducto") ,idProducto)) {
      //          return false;
      //        }
      //        break;
      //      }
    }
    if (!this.iface.duplicarItinerarios(curOriginal.valueBuffer("idproducto") , idProducto)) {
      return false;
    }
  }
  return true;
}

function artesG_duplicarItinerarios(idOriginal: String, idCopia: String): Boolean {
  debug("artesG_duplicarItinerarios " + idOriginal);
  var util: FLUtil = new FLUtil;

  var campos: Array = util.nombreCampos("itinerarioslp");
  var totalCampos: Number = campos[0];

  var campoInformado: Array = [];

  if (!this.iface.curItinerario_)
  {
    this.iface.curItinerario_ = new FLSqlCursor("itinerarioslp");
  }

  var idItinerario: String;
  var curOriginal: FLSqlCursor = new FLSqlCursor("itinerarioslp");
  curOriginal.select("idproducto = " + idOriginal);
  while (curOriginal.next())
  {
    curOriginal.setModeAccess(curOriginal.Browse);
    curOriginal.refreshBuffer();
    for (var i: Number = 1; i <= totalCampos; i++) {
      campoInformado[campos[i]] = false;
    }
    this.iface.curItinerario_.setModeAccess(this.iface.curItinerario_.Insert);
    this.iface.curItinerario_.refreshBuffer();
    this.iface.curItinerario_.setValueBuffer("idproducto", idCopia);
    for (var i: Number = 1; i <= totalCampos; i++) {
      if (!this.iface.copiarCampoItinerario(campos[i], curOriginal, campoInformado)) {
        return false;
      }
    }
    if (!this.iface.curItinerario_.commitBuffer()) {
      return false;
    }
    idItinerario = this.iface.curItinerario_.valueBuffer("iditinerario");

    if (!this.iface.duplicarTareas(curOriginal.valueBuffer("iditinerario"), idItinerario)) {
      return false;
    }
  }
  return true;
}

function artesG_duplicarTareas(idOriginal: String, idCopia: String): Boolean {
  debug("artesG_duplicarTareas " + idOriginal);
  var util: FLUtil = new FLUtil;

  var campos: Array = util.nombreCampos("tareaslp");
  var totalCampos: Number = campos[0];

  var campoInformado: Array = [];

  if (!this.iface.curTarea_)
  {
    this.iface.curTarea_ = new FLSqlCursor("tareaslp");
  }

  var idTarea: String;
  var curOriginal: FLSqlCursor = new FLSqlCursor("tareaslp");
  curOriginal.select("iditinerario = " + idOriginal);
  while (curOriginal.next())
  {
    curOriginal.setModeAccess(curOriginal.Browse);
    curOriginal.refreshBuffer();
    for (var i: Number = 1; i <= totalCampos; i++) {
      campoInformado[campos[i]] = false;
    }
    this.iface.curTarea_.setModeAccess(this.iface.curTarea_.Insert);
    this.iface.curTarea_.refreshBuffer();
    this.iface.curTarea_.setValueBuffer("iditinerario", idCopia);
    for (var i: Number = 1; i <= totalCampos; i++) {
      if (!this.iface.copiarCampoTarea(campos[i], curOriginal, campoInformado)) {
        return false;
      }
    }
    if (!this.iface.curTarea_.commitBuffer()) {
      return false;
    }
    idTarea = this.iface.curTarea_.valueBuffer("idtarea");
  }
  return true;
}

function artesG_duplicarParamIptico(idOriginal: String, idCopia: String, campoPadre: String): Boolean {
  debug("artesG_duplicarParamIptico " + idOriginal);
  var util: FLUtil = new FLUtil;

  var campos: Array = util.nombreCampos("paramiptico");
  var totalCampos: Number = campos[0];

  var campoInformado: Array = [];

  if (!this.iface.curParamIptico_)
  {
    this.iface.curParamIptico_ = new FLSqlCursor("paramiptico");
  }
  this.iface.curParamIptico_.setActivatedCommitActions(false);

  var idPI: String;
  var curOriginal: FLSqlCursor = new FLSqlCursor("paramiptico");
  curOriginal.select(campoPadre + " = " + idOriginal);
  debug("Select = " + campoPadre + " = " + idOriginal);
  while (curOriginal.next())
  {
    curOriginal.setModeAccess(curOriginal.Browse);
    curOriginal.refreshBuffer();

    for (var i: Number = 1; i <= totalCampos; i++) {
      campoInformado[campos[i]] = false;
    }
    this.iface.curParamIptico_.setModeAccess(this.iface.curParamIptico_.Insert);
    this.iface.curParamIptico_.refreshBuffer();
    this.iface.curParamIptico_.setValueBuffer(campoPadre, idCopia);
    for (var i: Number = 1; i <= totalCampos; i++) {
      if (!this.iface.copiarCampoParamIptico(campos[i], curOriginal, campoInformado)) {
        return false;
      }
    }
    if (!this.iface.curParamIptico_.commitBuffer()) {
      return false;
    }
    idPI = this.iface.curParamIptico_.valueBuffer("id");
    if (!this.iface.duplicarParamCantidad(curOriginal.valueBuffer("id"), idPI)) {
      return false;
    }
    if (!this.iface.duplicarParamColor(curOriginal.valueBuffer("id"), idPI)) {
      return false;
    }
    //    if (!this.iface.duplicarParamEnvio(curOriginal.valueBuffer("id"), idPI, "idparamiptico")) {
    //      return false;
    //    }
  }
  return true;
}

function artesG_duplicarParamTaco(idOriginal: String, idCopia: String): Boolean {
  debug("artesG_duplicarParamTaco " + idOriginal);
  var util: FLUtil = new FLUtil;

  var campos: Array = util.nombreCampos("paramtaco");
  var totalCampos: Number = campos[0];

  var campoInformado: Array = [];

  if (!this.iface.curParamTaco_)
  {
    this.iface.curParamTaco_ = new FLSqlCursor("paramtaco");
  }
  this.iface.curParamTaco_.setActivatedCommitActions(false);

  var idPI: String;
  var curOriginal: FLSqlCursor = new FLSqlCursor("paramtaco");
  curOriginal.select("idlinea = " + idOriginal);
  while (curOriginal.next())
  {
    curOriginal.setModeAccess(curOriginal.Browse);
    curOriginal.refreshBuffer();

    for (var i: Number = 1; i <= totalCampos; i++) {
      campoInformado[campos[i]] = false;
    }
    this.iface.curParamTaco_.setModeAccess(this.iface.curParamTaco_.Insert);
    this.iface.curParamTaco_.refreshBuffer();
    this.iface.curParamTaco_.setValueBuffer("idlinea", idCopia);
    for (var i: Number = 1; i <= totalCampos; i++) {
      if (!this.iface.copiarCampoParamTaco(campos[i], curOriginal, campoInformado)) {
        return false;
      }
    }
    if (!this.iface.curParamTaco_.commitBuffer()) {
      return false;
    }
    idPI = this.iface.curParamTaco_.valueBuffer("id");
    //    if (!this.iface.duplicarParamCantidad(curOriginal.valueBuffer("id"), idPI)) {
    //      return false;
    //    }
    //    if (!this.iface.duplicarParamColor(curOriginal.valueBuffer("id"), idPI)) {
    //      return false;
    //    }
    //    if (!this.iface.duplicarParamEnvio(curOriginal.valueBuffer("id"), idPI, "idparamiptico")) {
    //      return false;
    //    }
  }
  return true;
}

function artesG_duplicarParamLibro(idOriginal: String, idCopia: String): Boolean {
  debug("artesG_duplicarParamLibro" + idOriginal);
  var util: FLUtil = new FLUtil;

  var campos: Array = util.nombreCampos("paramlibro");
  var totalCampos: Number = campos[0];

  var campoInformado: Array = [];

  if (!this.iface.curParamLibro_)
  {
    this.iface.curParamLibro_ = new FLSqlCursor("paramlibro");
  }
  this.iface.curParamLibro_.setActivatedCommitActions(false);

  var idPL: String;
  var curOriginal: FLSqlCursor = new FLSqlCursor("paramlibro");
  curOriginal.select("idlinea = " + idOriginal);
  while (curOriginal.next())
  {
    curOriginal.setModeAccess(curOriginal.Browse);
    curOriginal.refreshBuffer();

    for (var i: Number = 1; i <= totalCampos; i++) {
      campoInformado[campos[i]] = false;
    }
    this.iface.curParamLibro_.setModeAccess(this.iface.curParamLibro_.Insert);
    this.iface.curParamLibro_.refreshBuffer();
    this.iface.curParamLibro_.setValueBuffer("idlinea", idCopia);
    for (var i: Number = 1; i <= totalCampos; i++) {
      if (!this.iface.copiarCampoParamLibro(campos[i], curOriginal, campoInformado)) {
        return false;
      }
    }
    if (!this.iface.curParamLibro_.commitBuffer()) {
      return false;
    }
    idPL = this.iface.curParamLibro_.valueBuffer("id");
    if (!this.iface.duplicarPaginasLibro(curOriginal.valueBuffer("id"), idPL)) {
      return false;
    }
    if (!this.iface.duplicarTrabExternosLibro(curOriginal.valueBuffer("id"), idPL)) {
      return false;
    }
    //    if (!this.iface.duplicarParamEnvio(curOriginal.valueBuffer("id"), idPL, "idparamlibro")) {
    //      return false;
    //    }
  }
  return true;
}

function artesG_duplicarParamTareaManual(idOriginal: String, idCopia: String): Boolean {
  debug("artesG_duplicarParamTareaManual" + idOriginal);
  var util: FLUtil = new FLUtil;

  var campos: Array = util.nombreCampos("paramtareamanual");
  var totalCampos: Number = campos[0];

  var campoInformado: Array = [];

  if (!this.iface.curParamTM_)
  {
    this.iface.curParamTM_ = new FLSqlCursor("paramtareamanual");
  }

  var idTM: String;
  var curOriginal: FLSqlCursor = new FLSqlCursor("paramtareamanual");
  curOriginal.select("idproducto = " + idOriginal);
  while (curOriginal.next())
  {
    curOriginal.setModeAccess(curOriginal.Browse);
    curOriginal.refreshBuffer();
    for (var i: Number = 1; i <= totalCampos; i++) {
      campoInformado[campos[i]] = false;
    }
    this.iface.curParamTM_.setModeAccess(this.iface.curParamTM_.Insert);
    this.iface.curParamTM_.refreshBuffer();
    //    this.iface.curParamTM_.setValueBuffer("idlinea", idCopia);
    this.iface.curParamTM_.setValueBuffer("idproducto", idCopia);
    for (var i: Number = 1; i <= totalCampos; i++) {
      if (!this.iface.copiarCampoParamTM(campos[i], curOriginal, campoInformado)) {
        return false;
      }
    }
    if (!this.iface.curParamTM_.commitBuffer()) {
      return false;
    }
    idTM = this.iface.curParamTM_.valueBuffer("id");
    if (!this.iface.duplicarConsumosTM(curOriginal.valueBuffer("id"), idTM)) {
      return false;
    }
  }
  return true;
}

function artesG_duplicarConsumosTM(idOriginal: String, idCopia: String): Boolean {
  debug("artesG_duplicarConsumosTM" + idOriginal);
  var util: FLUtil = new FLUtil;

  var campos: Array = util.nombreCampos("consumostareamanual");
  var totalCampos: Number = campos[0];

  var campoInformado: Array = [];

  if (!this.iface.curConsumosTM_)
  {
    this.iface.curConsumosTM_ = new FLSqlCursor("consumostareamanual");
  }

  var idConsumoTM: String;
  var curOriginal: FLSqlCursor = new FLSqlCursor("consumostareamanual");
  curOriginal.select("idparamtareamanual = " + idOriginal);
  while (curOriginal.next())
  {
    curOriginal.setModeAccess(curOriginal.Browse);
    curOriginal.refreshBuffer();
    for (var i: Number = 1; i <= totalCampos; i++) {
      campoInformado[campos[i]] = false;
    }
    this.iface.curConsumosTM_.setModeAccess(this.iface.curConsumosTM_.Insert);
    this.iface.curConsumosTM_.refreshBuffer();
    this.iface.curConsumosTM_.setValueBuffer("idparamtareamanual", idCopia);
    for (var i: Number = 1; i <= totalCampos; i++) {
      if (!this.iface.copiarCampoConsumosTM(campos[i], curOriginal, campoInformado)) {
        return false;
      }
    }
    if (!this.iface.curConsumosTM_.commitBuffer()) {
      return false;
    }
    idConsumoTM = this.iface.curConsumosTM_.valueBuffer("id");
    //    if (!this.iface.duplicarParamEnvio(curOriginal.valueBuffer("id"), idPL, "idparamlibro")) {
    //      return false;
    //    }
  }
  return true;
}

function artesG_duplicarParamEnvio(idOriginal: String, idCopia: String): Boolean {
  debug("artesG_duplicarParamEnvio " + idOriginal);
  var util: FLUtil = new FLUtil;

  var campos: Array = util.nombreCampos("paramenvio");
  var totalCampos: Number = campos[0];

  var campoInformado: Array = [];

  if (!this.iface.curParamEnvio_)
  {
    this.iface.curParamEnvio_ = new FLSqlCursor("paramenvio");
  }

  var idPL: String;
  var curOriginal: FLSqlCursor = new FLSqlCursor("paramenvio");
  curOriginal.select("idproducto = " + idOriginal);
  while (curOriginal.next())
  {
    curOriginal.setModeAccess(curOriginal.Browse);
    curOriginal.refreshBuffer();
    for (var i: Number = 1; i <= totalCampos; i++) {
      campoInformado[campos[i]] = false;
    }
    this.iface.curParamEnvio_.setModeAccess(this.iface.curParamEnvio_.Insert);
    this.iface.curParamEnvio_.refreshBuffer();
    //    this.iface.curParamTM_.setValueBuffer("idlinea", idCopia);
    this.iface.curParamEnvio_.setValueBuffer("idproducto", idCopia);
    for (var i: Number = 1; i <= totalCampos; i++) {
      if (!this.iface.copiarCampoParamEnvio(campos[i], curOriginal, campoInformado)) {
        return false;
      }
    }
    if (!this.iface.curParamEnvio_.commitBuffer()) {
      return false;
    }
    idPL = this.iface.curParamEnvio_.valueBuffer("id");
    //    if (!this.iface.duplicarParamEnvio(curOriginal.valueBuffer("id"), idPL, "idparamlibro")) {
    //      return false;
    //    }
  }
  return true;
}

function artesG_duplicarParamCantidad(idOriginal: String, idCopia: String): Boolean {
  debug("artesG_duplicarParamCantidad" + idOriginal);
  var util: FLUtil = new FLUtil;

  var campos: Array = util.nombreCampos("paramcantidad");
  var totalCampos: Number = campos[0];

  var campoInformado: Array = [];

  if (!this.iface.curParamCantidad_)
  {
    this.iface.curParamCantidad_ = new FLSqlCursor("paramcantidad");
  }

  var id: String;
  var curOriginal: FLSqlCursor = new FLSqlCursor("paramcantidad");
  curOriginal.select("idparamiptico = " + idOriginal);
  while (curOriginal.next())
  {
    curOriginal.setModeAccess(curOriginal.Browse);
    curOriginal.refreshBuffer();

    for (var i: Number = 1; i <= totalCampos; i++) {
      campoInformado[campos[i]] = false;
    }
    this.iface.curParamCantidad_.setModeAccess(this.iface.curParamCantidad_.Insert);
    this.iface.curParamCantidad_.refreshBuffer();
    this.iface.curParamCantidad_.setValueBuffer("idparamiptico", idCopia);
    for (var i: Number = 1; i <= totalCampos; i++) {
      if (!this.iface.copiarCampoParamCantidad(campos[i], curOriginal, campoInformado)) {
        return false;
      }
    }
    if (!this.iface.curParamCantidad_.commitBuffer()) {
      return false;
    }
    id = this.iface.curParamCantidad_.valueBuffer("id");
  }
  return true;
}

function artesG_duplicarParamColor(idOriginal: String, idCopia: String): Boolean {
  debug("artesG_duplicarParamColor " + idOriginal);
  var util: FLUtil = new FLUtil;

  var campos: Array = util.nombreCampos("paramcolor");
  var totalCampos: Number = campos[0];

  var campoInformado: Array = [];

  if (!this.iface.curParamColor_)
  {
    this.iface.curParamColor_ = new FLSqlCursor("paramcolor");
  }

  var id: String;
  var curOriginal: FLSqlCursor = new FLSqlCursor("paramcolor");
  curOriginal.select("idparamiptico = " + idOriginal);
  while (curOriginal.next())
  {
    curOriginal.setModeAccess(curOriginal.Browse);
    curOriginal.refreshBuffer();

    for (var i: Number = 1; i <= totalCampos; i++) {
      campoInformado[campos[i]] = false;
    }
    this.iface.curParamColor_.setModeAccess(this.iface.curParamColor_.Insert);
    this.iface.curParamColor_.refreshBuffer();
    this.iface.curParamColor_.setValueBuffer("idparamiptico", idCopia);
    for (var i: Number = 1; i <= totalCampos; i++) {
      if (!this.iface.copiarCampoParamColor(campos[i], curOriginal, campoInformado)) {
        return false;
      }
    }
    if (!this.iface.curParamColor_.commitBuffer()) {
      return false;
    }
    id = this.iface.curParamColor_.valueBuffer("id");
  }
  return true;
}

// function artesG_duplicarParamEnvio(idOriginal:String, idCopia:String, campoPadre:String):Boolean
// {
// debug("artesG_duplicarParamEnvio " + idOriginal);
//  var util:FLUtil = new FLUtil;
//
//  var campos:Array = util.nombreCampos("paramenvio");
//  var totalCampos:Number = campos[0];
//
//  var campoInformado:Array = [];
//
//  if (!this.iface.curParamEnvio_) {
//    this.iface.curParamEnvio_ = new FLSqlCursor("paramenvio");
//  }
//
//  var id:String;
//  var curOriginal:FLSqlCursor = new FLSqlCursor("paramenvio");
//  curOriginal.select(campoPadre + " = " + idOriginal);
//  while (curOriginal.next()) {
//    curOriginal.setModeAccess(curOriginal.Browse);
//    curOriginal.refreshBuffer();
//
//    for (var i:Number = 1; i <= totalCampos; i++) {
//      campoInformado[campos[i]] = false;
//    }
//    this.iface.curParamEnvio_.setModeAccess(this.iface.curParamEnvio_.Insert);
//    this.iface.curParamEnvio_.refreshBuffer();
//    this.iface.curParamEnvio_.setValueBuffer(campoPadre, idCopia);
//    for (var i:Number = 1; i <= totalCampos; i++) {
//      if (!this.iface.copiarCampoParamEnvio(campos[i], curOriginal, campoInformado)) {
//        return false;
//      }
//    }
//    if (!this.iface.curParamEnvio_.commitBuffer()) {
//      return false;
//    }
//    id = this.iface.curParamEnvio_.valueBuffer("id");
//  }
//  return true;
// }

function artesG_duplicarPaginasLibro(idOriginal: String, idCopia: String): Boolean {
  debug("artesG_duplicarPaginasLibro " + idOriginal);
  var util: FLUtil = new FLUtil;

  var campos: Array = util.nombreCampos("grupospliegolibro");
  var totalCampos: Number = campos[0];

  var campoInformado: Array = [];

  if (!this.iface.curPaginasLibro_)
  {
    this.iface.curPaginasLibro_ = new FLSqlCursor("grupospliegolibro");
  }

  var id: String;
  var curOriginal: FLSqlCursor = new FLSqlCursor("grupospliegolibro");
  curOriginal.select("idparamlibro = " + idOriginal);
  while (curOriginal.next())
  {
    curOriginal.setModeAccess(curOriginal.Browse);
    curOriginal.refreshBuffer();

    for (var i: Number = 1; i <= totalCampos; i++) {
      campoInformado[campos[i]] = false;
    }
    this.iface.curPaginasLibro_.setModeAccess(this.iface.curPaginasLibro_.Insert);
    this.iface.curPaginasLibro_.refreshBuffer();
    this.iface.curPaginasLibro_.setValueBuffer("idparamlibro", idCopia);
    for (var i: Number = 1; i <= totalCampos; i++) {
      if (!this.iface.copiarCampoPaginaLibro(campos[i], curOriginal, campoInformado)) {
        return false;
      }
    }
    if (!this.iface.curPaginasLibro_.commitBuffer()) {
      return false;
    }
    id = this.iface.curPaginasLibro_.valueBuffer("id");
  }
  return true;
}

function artesG_duplicarTrabExternosLibro(idOriginal: String, idCopia: String): Boolean {
  debug("artesG_duplicarTrabExternosLibro" + idOriginal);
  var util: FLUtil = new FLUtil;

  var campos: Array = util.nombreCampos("trabexternolibro");
  var totalCampos: Number = campos[0];

  var campoInformado: Array = [];

  if (!this.iface.curTrabExterno_)
  {
    this.iface.curTrabExterno_ = new FLSqlCursor("trabexternolibro");
  }

  var id: String;
  var curOriginal: FLSqlCursor = new FLSqlCursor("trabexternolibro");
  curOriginal.select("idparamlibro = " + idOriginal);
  while (curOriginal.next())
  {
    curOriginal.setModeAccess(curOriginal.Browse);
    curOriginal.refreshBuffer();

    for (var i: Number = 1; i <= totalCampos; i++) {
      campoInformado[campos[i]] = false;
    }
    this.iface.curTrabExterno_.setModeAccess(this.iface.curTrabExterno_.Insert);
    this.iface.curTrabExterno_.refreshBuffer();
    this.iface.curTrabExterno_.setValueBuffer("idparamlibro", idCopia);
    for (var i: Number = 1; i <= totalCampos; i++) {
      if (!this.iface.copiarCampoTrabExterno(campos[i], curOriginal, campoInformado)) {
        return false;
      }
    }
    if (!this.iface.curTrabExterno_.commitBuffer()) {
      return false;
    }
    id = this.iface.curTrabExterno_.valueBuffer("id");
  }
  return true;
}

function artesG_copiarCampoPresupuesto(nombreCampo: String, curOriginal: FLSqlCursor, campoInformado: Array): Boolean {
  var util: FLUtil = new FLUtil;

  if (campoInformado[nombreCampo])
  {
    return true;
  }
  var nulo: Boolean = false;
  var valor;

  switch (nombreCampo)
  {
    case "??": {
      valor = true;
      break;
    }
    default: {
      return this.iface.__copiarCampoPresupuesto(nombreCampo, curOriginal, campoInformado);
    }
  }
  if (nulo)
  {
    this.iface.curPresupuesto_.setNull(nombreCampo);
  } else {
    this.iface.curPresupuesto_.setValueBuffer(nombreCampo, valor);
  }
  campoInformado[nombreCampo] = true;

  return true;
}

function artesG_copiarCampoLineaPresupuesto(nombreCampo: String, curOriginal: FLSqlCursor, campoInformado: Array): Boolean {
  var util: FLUtil = new FLUtil;

  if (campoInformado[nombreCampo])
  {
    return true;
  }
  var nulo: Boolean = false;
  var valor;

  switch (nombreCampo)
  {
    case "idlinea":
    case "idpresupuesto": {
      return true;
      break;
    }
    case "aprobado": {
      valor = false;
      break;
    }
    default: {
      if (curOriginal.isNull(nombreCampo)) {
        nulo = true;
      } else {
        valor = curOriginal.valueBuffer(nombreCampo);
      }
    }
  }
  if (nulo)
  {
    this.iface.curLineaPresupuesto_.setNull(nombreCampo);
  } else {
    this.iface.curLineaPresupuesto_.setValueBuffer(nombreCampo, valor);
  }
  campoInformado[nombreCampo] = true;

  return true;
}

function artesG_copiarCampoProducto(nombreCampo: String, curOriginal: FLSqlCursor, campoInformado: Array): Boolean {
  var util: FLUtil = new FLUtil;

  if (campoInformado[nombreCampo])
  {
    return true;
  }
  var nulo: Boolean = false;
  var valor;

  switch (nombreCampo)
  {
    case "idproducto":
    case "idlinea": {
      return true;
      break;
    }
    default: {
      if (curOriginal.isNull(nombreCampo)) {
        nulo = true;
      } else {
        valor = curOriginal.valueBuffer(nombreCampo);
      }
    }
  }
  if (nulo)
  {
    this.iface.curProducto_.setNull(nombreCampo);
  } else {
    this.iface.curProducto_.setValueBuffer(nombreCampo, valor);
  }
  campoInformado[nombreCampo] = true;

  return true;
}

function artesG_copiarCampoParamIptico(nombreCampo: String, curOriginal: FLSqlCursor, campoInformado: Array): Boolean {
  var util: FLUtil = new FLUtil;

  if (campoInformado[nombreCampo])
  {
    return true;
  }
  var nulo: Boolean = false;
  var valor;

  switch (nombreCampo)
  {
    case "id":
    case "idproducto":
    case "idlinea": {
      return true;
      break;
    }
    case "idoriginal": {
      valor = curOriginal.valueBuffer("id");
      break;
    }
    default: {
      if (curOriginal.isNull(nombreCampo)) {
        nulo = true;
      } else {
        valor = curOriginal.valueBuffer(nombreCampo);
      }
    }
  }
  if (nulo)
  {
    this.iface.curParamIptico_.setNull(nombreCampo);
  } else {
    this.iface.curParamIptico_.setValueBuffer(nombreCampo, valor);
  }
  campoInformado[nombreCampo] = true;

  return true;
}

function artesG_copiarCampoItinerario(nombreCampo: String, curOriginal: FLSqlCursor, campoInformado: Array): Boolean {
  var util: FLUtil = new FLUtil;

  if (campoInformado[nombreCampo])
  {
    return true;
  }
  var nulo: Boolean = false;
  var valor;

  switch (nombreCampo)
  {
    case "iditinerario":
    case "idproducto": {
      return true;
      break;
    }
    case "idlinea": {
      valor = util.sqlSelect("productoslp", "idlinea", "idproducto = " + this.iface.curItinerario_.valueBuffer("idproducto"));
      break;
    }
    default: {
      if (curOriginal.isNull(nombreCampo)) {
        nulo = true;
      } else {
        valor = curOriginal.valueBuffer(nombreCampo);
      }
    }
  }
  if (nulo)
  {
    this.iface.curItinerario_.setNull(nombreCampo);
  } else {
    this.iface.curItinerario_.setValueBuffer(nombreCampo, valor);
  }
  campoInformado[nombreCampo] = true;

  return true;
}

function artesG_copiarCampoTarea(nombreCampo: String, curOriginal: FLSqlCursor, campoInformado: Array): Boolean {
  var util: FLUtil = new FLUtil;

  if (campoInformado[nombreCampo])
  {
    return true;
  }
  var nulo: Boolean = false;
  var valor;

  switch (nombreCampo)
  {
    case "idtarea":
    case "iditinerario": {
      return true;
      break;
    }
    default: {
      if (curOriginal.isNull(nombreCampo)) {
        nulo = true;
      } else {
        valor = curOriginal.valueBuffer(nombreCampo);
      }
    }
  }
  if (nulo)
  {
    this.iface.curTarea_.setNull(nombreCampo);
  } else {
    this.iface.curTarea_.setValueBuffer(nombreCampo, valor);
  }
  campoInformado[nombreCampo] = true;

  return true;
}

function artesG_copiarCampoParamTaco(nombreCampo: String, curOriginal: FLSqlCursor, campoInformado: Array): Boolean {
  var util: FLUtil = new FLUtil;

  if (campoInformado[nombreCampo])
  {
    return true;
  }
  var nulo: Boolean = false;
  var valor;

  switch (nombreCampo)
  {
    case "id":
    case "idproducto":
    case "idlinea": {
      return true;
      break;
    }
    case "idoriginal": {
      valor = curOriginal.valueBuffer("id");
      break;
    }
    default: {
      if (curOriginal.isNull(nombreCampo)) {
        nulo = true;
      } else {
        valor = curOriginal.valueBuffer(nombreCampo);
      }
    }
  }
  if (nulo)
  {
    this.iface.curParamTaco_.setNull(nombreCampo);
  } else {
    this.iface.curParamTaco_.setValueBuffer(nombreCampo, valor);
  }
  campoInformado[nombreCampo] = true;

  return true;
}

function artesG_copiarCampoParamLibro(nombreCampo: String, curOriginal: FLSqlCursor, campoInformado: Array): Boolean {
  var util: FLUtil = new FLUtil;

  if (campoInformado[nombreCampo])
  {
    return true;
  }
  var nulo: Boolean = false;
  var valor;

  switch (nombreCampo)
  {
    case "id":
    case "idproducto":
    case "idlinea": {
      return true;
      break;
    }
    case "idoriginal": {
      valor = curOriginal.valueBuffer("id");
      break;
    }
    default: {
      if (curOriginal.isNull(nombreCampo)) {
        nulo = true;
      } else {
        valor = curOriginal.valueBuffer(nombreCampo);
      }
    }
  }
  if (nulo)
  {
    this.iface.curParamLibro_.setNull(nombreCampo);
  } else {
    this.iface.curParamLibro_.setValueBuffer(nombreCampo, valor);
  }
  campoInformado[nombreCampo] = true;

  return true;
}

function artesG_copiarCampoParamTM(nombreCampo: String, curOriginal: FLSqlCursor, campoInformado: Array): Boolean {
  var util: FLUtil = new FLUtil;

  if (campoInformado[nombreCampo])
  {
    return true;
  }
  var nulo: Boolean = false;
  var valor;

  switch (nombreCampo)
  {
    case "id":
    case "idproducto":
    case "idlinea": {
      return true;
      break;
    }
    case "idparamiptico": {
      if (curOriginal.isNull("idparamiptico")) {
        nulo = true;
      } else {
        valor = util.sqlSelect("productoslp p INNER JOIN lineaspresupuestoscli lp ON p.idlinea = lp.idlinea INNER JOIN paramiptico pi ON lp.idlinea = pi.idlinea", "pi.id", "p.idproducto = " + this.iface.curParamTM_.valueBuffer("idproducto") + " AND pi.idoriginal = " + curOriginal.valueBuffer("idparamiptico"), "productoslp,lineaspresupuestoscli,paramiptico");
        if (!valor) {
          valor = util.sqlSelect("productoslp p INNER JOIN productoslp p2 ON p.idlinea = p2.idlinea INNER JOIN paramiptico pi ON p2.idproducto = pi.idproducto", "pi.id", "p.idproducto = " + this.iface.curParamTM_.valueBuffer("idproducto") + " AND pi.idoriginal = " + curOriginal.valueBuffer("idparamiptico"), "productoslp,lineaspresupuestoscli,paramiptico");
        }
      }
      break;
    }
    case "idparamlibro": {
      if (curOriginal.isNull("idparamlibro")) {
        nulo = true;
      } else {
        valor = util.sqlSelect("productoslp p INNER JOIN lineaspresupuestoscli lp ON p.idlinea = lp.idlinea INNER JOIN paramlibro pl ON lp.idlinea = pl.idlinea", "pl.id", "p.idproducto = " + this.iface.curParamEnvio_.valueBuffer("idproducto") + " AND pl.idoriginal = " + curOriginal.valueBuffer("idparamlibro"), "productoslp,lineaspresupuestoscli,paramlibro");
        if (!valor) {
          valor = util.sqlSelect("productoslp p INNER JOIN productoslp p2 ON p.idlinea = p2.idlinea INNER JOIN paramlibro pl ON p2.idproducto = pl.idproducto", "pl.id", "p.idproducto = " + this.iface.curParamEnvio_.valueBuffer("idproducto") + " AND pl.idoriginal = " + curOriginal.valueBuffer("idparamlibro"), "productoslp,lineaspresupuestoscli,paramlibro");
        }
      }
      break;
    }
    case "idparamtaco": {
      if (curOriginal.isNull("idparamtaco")) {
        nulo = true;
      } else {
        valor = util.sqlSelect("productoslp p INNER JOIN lineaspresupuestoscli lp ON p.idlinea = lp.idlinea INNER JOIN paramtaco pt ON lp.idlinea = pt.idlinea", "pt.id", "p.idproducto = " + this.iface.curParamEnvio_.valueBuffer("idproducto") + " AND pt.idoriginal = " + curOriginal.valueBuffer("idparamtaco"), "productoslp,lineaspresupuestoscli,paramtaco");
        if (!valor) {
          valor = util.sqlSelect("productoslp p INNER JOIN productoslp p2 ON p.idlinea = p2.idlinea INNER JOIN paramtaco pt ON p2.idproducto = pt.idproducto", "pt.id", "p.idproducto = " + this.iface.curParamEnvio_.valueBuffer("idproducto") + " AND pt.idoriginal = " + curOriginal.valueBuffer("idparamtaco"), "productoslp,lineaspresupuestoscli,paramtaco");
        }
      }
      break;
    }
    default: {
      if (curOriginal.isNull(nombreCampo)) {
        nulo = true;
      } else {
        valor = curOriginal.valueBuffer(nombreCampo);
      }
    }
  }
  if (nulo)
  {
    this.iface.curParamTM_.setNull(nombreCampo);
  } else {
    this.iface.curParamTM_.setValueBuffer(nombreCampo, valor);
  }
  campoInformado[nombreCampo] = true;

  return true;
}

function artesG_copiarCampoParamEnvio(nombreCampo: String, curOriginal: FLSqlCursor, campoInformado: Array): Boolean {
  var util: FLUtil = new FLUtil;

  if (campoInformado[nombreCampo])
  {
    return true;
  }
  var nulo: Boolean = false;
  var valor;

  switch (nombreCampo)
  {
    case "id":
    case "idproducto":
    case "idlinea": {
      return true;
      break;
    }
    case "idparamiptico": {
      if (curOriginal.isNull("idparamiptico")) {
        nulo = true;
      } else {
        valor = util.sqlSelect("productoslp p INNER JOIN lineaspresupuestoscli lp ON p.idlinea = lp.idlinea INNER JOIN paramiptico pi ON lp.idlinea = pi.idlinea", "pi.id", "p.idproducto = " + this.iface.curParamEnvio_.valueBuffer("idproducto") + " AND pi.idoriginal = " + curOriginal.valueBuffer("idparamiptico"), "productoslp,lineaspresupuestoscli,paramiptico");
        if (!valor) {
          valor = util.sqlSelect("productoslp p INNER JOIN productoslp p2 ON p.idlinea = p2.idlinea INNER JOIN paramiptico pi ON p2.idproducto = pi.idproducto", "pi.id", "p.idproducto = " + this.iface.curParamEnvio_.valueBuffer("idproducto") + " AND pi.idoriginal = " + curOriginal.valueBuffer("idparamiptico"), "productoslp,lineaspresupuestoscli,paramiptico");
        }
      }
      break;
    }
    case "idparamlibro": {
      if (curOriginal.isNull("idparamlibro")) {
        nulo = true;
      } else {
        valor = util.sqlSelect("productoslp p INNER JOIN lineaspresupuestoscli lp ON p.idlinea = lp.idlinea INNER JOIN paramlibro pl ON lp.idlinea = pl.idlinea", "pl.id", "p.idproducto = " + this.iface.curParamEnvio_.valueBuffer("idproducto") + " AND pl.idoriginal = " + curOriginal.valueBuffer("idparamlibro"), "productoslp,lineaspresupuestoscli,paramlibro");
        if (!valor) {
          valor = util.sqlSelect("productoslp p INNER JOIN productoslp p2 ON p.idlinea = p2.idlinea INNER JOIN paramlibro pl ON p2.idproducto = pl.idproducto", "pl.id", "p.idproducto = " + this.iface.curParamEnvio_.valueBuffer("idproducto") + " AND pl.idoriginal = " + curOriginal.valueBuffer("idparamlibro"), "productoslp,lineaspresupuestoscli,paramlibro");
        }
      }
      break;
    }
    case "idparamtaco": {
      if (curOriginal.isNull("idparamtaco")) {
        nulo = true;
      } else {
        valor = util.sqlSelect("productoslp p INNER JOIN lineaspresupuestoscli lp ON p.idlinea = lp.idlinea INNER JOIN paramtaco pt ON lp.idlinea = pt.idlinea", "pt.id", "p.idproducto = " + this.iface.curParamEnvio_.valueBuffer("idproducto") + " AND pt.idoriginal = " + curOriginal.valueBuffer("idparamtaco"), "productoslp,lineaspresupuestoscli,paramtaco");
        if (!valor) {
          valor = util.sqlSelect("productoslp p INNER JOIN productoslp p2 ON p.idlinea = p2.idlinea INNER JOIN paramtaco pt ON p2.idproducto = pt.idproducto", "pt.id", "p.idproducto = " + this.iface.curParamEnvio_.valueBuffer("idproducto") + " AND pt.idoriginal = " + curOriginal.valueBuffer("idparamtaco"), "productoslp,lineaspresupuestoscli,paramtaco");
        }
      }
      break;
    }
    default: {
      if (curOriginal.isNull(nombreCampo)) {
        nulo = true;
      } else {
        valor = curOriginal.valueBuffer(nombreCampo);
      }
    }
  }
  if (nulo)
  {
    this.iface.curParamEnvio_.setNull(nombreCampo);
  } else {
    this.iface.curParamEnvio_.setValueBuffer(nombreCampo, valor);
  }
  campoInformado[nombreCampo] = true;

  return true;
}

function artesG_copiarCampoConsumosTM(nombreCampo: String, curOriginal: FLSqlCursor, campoInformado: Array): Boolean {
  var util: FLUtil = new FLUtil;

  if (campoInformado[nombreCampo])
  {
    return true;
  }
  var nulo: Boolean = false;
  var valor;

  switch (nombreCampo)
  {
    case "id":
    case "idparamtareamanual": {
      return true;
      break;
    }
    default: {
      if (curOriginal.isNull(nombreCampo)) {
        nulo = true;
      } else {
        valor = curOriginal.valueBuffer(nombreCampo);
      }
    }
  }
  if (nulo)
  {
    this.iface.curConsumosTM_.setNull(nombreCampo);
  } else {
    this.iface.curConsumosTM_.setValueBuffer(nombreCampo, valor);
  }
  campoInformado[nombreCampo] = true;

  return true;
}

function artesG_copiarCampoParamCantidad(nombreCampo: String, curOriginal: FLSqlCursor, campoInformado: Array): Boolean {
  var util: FLUtil = new FLUtil;

  if (campoInformado[nombreCampo])
  {
    return true;
  }
  var nulo: Boolean = false;
  var valor;

  switch (nombreCampo)
  {
    case "id":
    case "idparamiptico": {
      return true;
      break;
    }
    default: {
      if (curOriginal.isNull(nombreCampo)) {
        nulo = true;
      } else {
        valor = curOriginal.valueBuffer(nombreCampo);
      }
    }
  }
  if (nulo)
  {
    this.iface.curParamCantidad_.setNull(nombreCampo);
  } else {
    this.iface.curParamCantidad_.setValueBuffer(nombreCampo, valor);
  }
  campoInformado[nombreCampo] = true;

  return true;
}

function artesG_copiarCampoParamColor(nombreCampo: String, curOriginal: FLSqlCursor, campoInformado: Array): Boolean {
  var util: FLUtil = new FLUtil;

  if (campoInformado[nombreCampo])
  {
    return true;
  }
  var nulo: Boolean = false;
  var valor;

  switch (nombreCampo)
  {
    case "id":
    case "idparamiptico": {
      return true;
      break;
    }
    default: {
      if (curOriginal.isNull(nombreCampo)) {
        nulo = true;
      } else {
        valor = curOriginal.valueBuffer(nombreCampo);
      }
    }
  }
  if (nulo)
  {
    this.iface.curParamColor_.setNull(nombreCampo);
  } else {
    this.iface.curParamColor_.setValueBuffer(nombreCampo, valor);
  }
  campoInformado[nombreCampo] = true;

  return true;
}

// function artesG_copiarCampoParamEnvio(nombreCampo:String, curOriginal:FLSqlCursor, campoInformado:Array):Boolean
// {
//  var util:FLUtil = new FLUtil;
//
//  if (campoInformado[nombreCampo]) {
//    return true;
//  }
//  var nulo:Boolean =false;
//
//  switch (nombreCampo) {case "idproducto":{
//      return true;
//      break;
//    }
//    default: {

//    case "id":
//    case "idparamlibro":
//    case "idparamiptico": {
//      return true;
//      break;
//    }
//    case "idproducto": {
//      var idLinea:String;
//      if (!this.iface.curParamEnvio_.isNull("idparamiptico")) {
//        idLinea = util.sqlSelect("paramiptico", "idlinea", "id = " + this.iface.curParamEnvio_.valueBuffer("idparamiptico"));
//      } else {
//        idLinea = util.sqlSelect("paramlibro", "idlinea", "id = " + this.iface.curParamEnvio_.valueBuffer("idparamlibro"));
//      }
//      valor = util.sqlSelect("productoslp", "idproducto", "idlinea = " + idLinea + " AND referencia = 'ENVIO'");
//      break;
//    }
//    default: {
//      if (curOriginal.isNull(nombreCampo)) {
//        nulo = true;
//      } else {
//        valor = curOriginal.valueBuffer(nombreCampo);
//      }
//    }
//  }
//  if (nulo) {
//    this.iface.curParamEnvio_.setNull(nombreCampo);
//  } else {
//    this.iface.curParamEnvio_.setValueBuffer(nombreCampo, valor);
//  }
//  campoInformado[nombreCampo] = true;
//
//  return true;
// }

function artesG_copiarCampoPaginaLibro(nombreCampo: String, curOriginal: FLSqlCursor, campoInformado: Array): Boolean {
  var util: FLUtil = new FLUtil;

  if (campoInformado[nombreCampo])
  {
    return true;
  }
  var nulo: Boolean = false;
  var valor;

  switch (nombreCampo)
  {
    case "idgrupo":
    case "idparamlibro": {
      return true;
      break;
    }
    default: {
      if (curOriginal.isNull(nombreCampo)) {
        nulo = true;
      } else {
        valor = curOriginal.valueBuffer(nombreCampo);
      }
    }
  }
  if (nulo)
  {
    this.iface.curPaginasLibro_.setNull(nombreCampo);
  } else {
    this.iface.curPaginasLibro_.setValueBuffer(nombreCampo, valor);
  }
  campoInformado[nombreCampo] = true;

  return true;
}

function artesG_copiarCampoTrabExterno(nombreCampo: String, curOriginal: FLSqlCursor, campoInformado: Array): Boolean {
  var util: FLUtil = new FLUtil;

  if (campoInformado[nombreCampo])
  {
    return true;
  }
  var nulo: Boolean = false;
  var valor;

  switch (nombreCampo)
  {
    case "id":
    case "idparamlibro": {
      return true;
      break;
    }
    default: {
      if (curOriginal.isNull(nombreCampo)) {
        nulo = true;
      } else {
        valor = curOriginal.valueBuffer(nombreCampo);
      }
    }
  }
  if (nulo)
  {
    this.iface.curTrabExterno_.setNull(nombreCampo);
  } else {
    this.iface.curTrabExterno_.setValueBuffer(nombreCampo, valor);
  }
  campoInformado[nombreCampo] = true;

  return true;
}

/** \D
Copia las líneas de un pedido como líneas de su albarán asociado
@param idPresupuesto: Identificador del pedido
@param idPedido: Identificador del pedido
\end */
function artesG_copiaLineas(idPresupuesto: Number, idPedido: Number): Boolean {
  var curLineaPresupuesto: FLSqlCursor = new FLSqlCursor("lineaspresupuestoscli");
  curLineaPresupuesto.select("idpresupuesto = " + idPresupuesto + "AND aprobado = true");
  while (curLineaPresupuesto.next())
  {
    curLineaPresupuesto.setModeAccess(curLineaPresupuesto.Browse);
    curLineaPresupuesto.refreshBuffer();
    if (!this.iface.copiaLineaPresupuesto(curLineaPresupuesto, idPedido))
      return false;
  }
  return true;
}

function artesG_generarPedido(cursor: FLSqlCursor): Number {
  if (!this.iface.validarAprobacionesPres(cursor))
  {
    return false;
  }
  var idPedido: Number = this.iface.__generarPedido(cursor);
  if (!idPedido)
  {
    return false;
  }
  if (!this.iface.generarOrdenesPedido(idPedido))
  {
    return false;
  }
  return idPedido;
}

function artesG_validarAprobacionesPres(cursor: FLSqlCursor): Boolean {
  var util: FLUtil = new FLUtil;
  var idPresupuesto: String = cursor.valueBuffer("idpresupuesto");

  var numAprobadas: Number = util.sqlSelect("lineaspresupuestoscli", "COUNT(*)", "idpresupuesto = " + idPresupuesto + " AND aprobado = true");
  if (!numAprobadas || isNaN(numAprobadas))
  {
    MessageBox.warning(util.translate("scripts", "El presupuesto seleccionado no tiene ninguna línea aprobada"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  var qryLineas: FLSqlQuery = new FLSqlQuery;
  qryLineas.setTablesList("lineaspresupuestoscli");
  qryLineas.setSelect("idlinea, referencia, descripcion, aprobado");
  qryLineas.setFrom("lineaspresupuestoscli");
  qryLineas.setWhere("idpresupuesto = " + idPresupuesto + " AND idlineamatriz IS NULL");
  qryLineas.setForwardOnly(true);
  if (!qryLineas.exec())
  {
    return false;
  }

  var lista: String, idLinea: String;
  var numPtes: Number = 0;
  while (qryLineas.next())
  {
    idLinea = qryLineas.value("idlinea");
    if (qryLineas.value("aprobado")) {
      continue;
    }
    if (!util.sqlSelect("lineaspresupuestoscli", "idlinea", "idpresupuesto = " + idPresupuesto + " AND (idlineamatriz = " + qryLineas.value("idlinea") + " OR idlinea = " + idLinea + ") AND aprobado = true")) {
      var curLinea: FLSqlCursor = new FLSqlCursor("lineaspresupuestoscli");
      curLinea.setActivatedCheckIntegrity(false);
      curLinea.setActivatedCommitActions(false);
      curLinea.select("idpresupuesto = " + idPresupuesto + " AND (idlineamatriz = " + qryLineas.value("idlinea") + " OR idlinea = " + idLinea + ")");
      if (curLinea.size() > 1) {
        numPtes++;
        lista += "\n" + qryLineas.value("referencia") + ": " + qryLineas.value("descripcion");
      } else {
        if (!curLinea.first()) {
          return false;
        }
        curLinea.setModeAccess(curLinea.Edit);
        curLinea.refreshBuffer();
        curLinea.setValueBuffer("aprobado", true);
        if (!curLinea.commitBuffer()) {
          return false;
        }
      }
    }
  }
  if (numPtes > 0)
  {
    var res: Number = MessageBox.warning(util.translate("scripts", "Los siguientes productos del presupuesto tienen varias opciones y ninguna de ellas está aprobada: %1 \nEstos productos no pasarán al pedido\n¿Desea continuar?").arg(lista), MessageBox.Yes, MessageBox.No);
    if (res != MessageBox.Yes) {
      return false;
    }
  }

  return true;
}

function artesG_generarOrdenesPedido(idPedido: String): Boolean {
  var qryLineas: FLSqlQuery = new FLSqlQuery;
  qryLineas.setTablesList("lineaspedidoscli,pedidoscli");
  qryLineas.setSelect("lp.idlinea, lp.descripcion, p.fechasalida, p.codigo, p.codcliente, p.nombrecliente");
  qryLineas.setFrom("pedidoscli p INNER JOIN lineaspedidoscli lp ON p.idpedido = lp.idpedido");
  qryLineas.setWhere("p.idpedido = " + idPedido);
  qryLineas.setForwardOnly(true);
  if (!qryLineas.exec())
  {
    return false;
  }
  while (qryLineas.next())
  {
    if (!this.iface.generarOrdenLinea(qryLineas)) {
      return false;
    }
  }
  return true;
}

function artesG_generarOrdenLinea(qryLinea: FLSqlQuery): Boolean {
  var util: FLUtil;
  var idLineaPedido: String = qryLinea.value("lp.idlinea");
  var totalProcesos: Number = util.sqlSelect("pr_procesos", "COUNT(*)", "idlineapedidocli = " + idLineaPedido);
  if (isNaN(totalProcesos) || totalProcesos < 1)
  {
    return true;
  }
  var curOrden: FLSqlCursor = new FLSqlCursor("pr_ordenesproduccion");
  curOrden.setModeAccess(curOrden.Insert);
  curOrden.refreshBuffer();
  var codOrden: String = formRecordpr_ordenesproduccion.iface.calculateCounter();
  debug("codOrden = " + codOrden);
  var hoy: Date = new Date;
  curOrden.setValueBuffer("codorden", codOrden);
  curOrden.setValueBuffer("fecha", hoy.toString());
  curOrden.setValueBuffer("fechaentrega", qryLinea.value("p.fechasalida"));
  curOrden.setValueBuffer("estado", "PTE");
  curOrden.setValueBuffer("totallotes", totalProcesos);
  curOrden.setValueBuffer("idlineapedido", idLineaPedido);
  curOrden.setValueBuffer("descripcion", qryLinea.value("lp.descripcion"));
  curOrden.setValueBuffer("codpedido", qryLinea.value("p.codigo"));
  curOrden.setValueBuffer("codcliente", qryLinea.value("p.codcliente"));
  curOrden.setValueBuffer("nombrecliente", qryLinea.value("p.nombrecliente"));
  if (!curOrden.commitBuffer())
  {
    return false;
  }
  var qryProcesos: FLSqlQuery = new FLSqlQuery();
  qryProcesos.setTablesList("pr_procesos");
  qryProcesos.setSelect("p.idproceso, p.idobjeto");
  qryProcesos.setFrom("pr_procesos p");
  qryProcesos.setWhere("p.idlineapedidocli = " + idLineaPedido);
  qryProcesos.setForwardOnly(true);
  if (!qryProcesos.exec())
  {
    return false;
  }
  var codLote: String;
  var idProceso: String;
  while (qryProcesos.next())
  {
    codLote = qryProcesos.value("p.idobjeto");
    idProceso = qryProcesos.value("p.idproceso");
    if (!flprodppal.iface.pub_incluirProcesoOrden(codOrden, codLote, idProceso)) {
      return false;
    }
  }
  return true;
}

function artesG_tbnBuscar_clicked()
{
  var cursor: FLSqlCursor = this.cursor();
  cursor.setMainFilter("");
  var filtroActual: String = this.iface.tdbRecords.filter();
  debug("filtroActual0 = " + filtroActual);
  if (this.iface.filtroAnterior_) {
    var longFiltro: Number = this.iface.filtroAnterior_.length + 4;
    var iInicio: Number = filtroActual.find(" AND" + this.iface.filtroAnterior_);
    if (iInicio < 0) {
      iInicio: Number = filtroActual.find(this.iface.filtroAnterior_);
      longFiltro = longFiltro - 4;
    }
    if (iInicio >= 0) {
      filtroActual = filtroActual.left(iInicio) + filtroActual.right(filtroActual.length - iInicio - longFiltro);
    }
  }
  debug("filtroActual = " + filtroActual);
  var cadena: String = this.child("ledBuscar").text;
  if (cadena && cadena != "") {
    cadena = cadena.toUpperCase();
    if (filtroActual != "") {
      filtroActual += " AND";
    }
    this.iface.filtroAnterior_ = " idpresupuesto IN (SELECT idpresupuesto FROM lineaspresupuestoscli WHERE UPPER(descripcion) LIKE '%" + cadena + "%')";
  } else {
    this.iface.filtroAnterior_ = "";
  }
  filtroActual += this.iface.filtroAnterior_;
  debug("filtroNuevo = " + filtroActual);
  this.iface.tdbRecords.setFilter(filtroActual);
  this.iface.tdbRecords.refresh();
}
//// ARTES GRÁFICAS /////////////////////////////////////////////
////////////////////////////////////////////////////////////////
