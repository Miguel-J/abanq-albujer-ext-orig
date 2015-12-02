
/** @class_declaration sofa */
/////////////////////////////////////////////////////////////////
//// SOFA ///////////////////////////////////////////////////////
class sofa extends prod
{
  function sofa(context)
  {
    prod(context);
  }
  function init()
  {
    return this.ctx.sofa_init();
  }
  function datosIniciales(): Boolean {
    return this.ctx.sofa_datosIniciales();
  }
  function datosArticulo(cursor: FLSqlCursor, codLote: String): Array {
    return this.ctx.sofa_datosArticulo(cursor, codLote);
  }
  //  function crearComposicion(curLoteStock:FLSqlCursor, curComponente:FLSqlCursor):Boolean {
  //    return this.ctx.sofa_crearComposicion(curLoteStock, curComponente);
  //  }
  function revisarComponente(curComponente: FLSqlCursor, idLinea: Number): Array {
    return this.ctx.sofa_revisarComponente(curComponente, idLinea);
  }
  function controlStockPedidosCli(curLP: FLSqlCursor): Boolean {
    return this.ctx.sofa_controlStockPedidosCli(curLP);
  }
  function obtenerOpcionLote(qryOpciones: FLSqlQuery, codLote: String): Number {
    return this.ctx.sofa_obtenerOpcionLote(qryOpciones, codLote);
  }
  function afterCommit_lotesstock(curLS: FLSqlCursor): Boolean {
    return this.ctx.sofa_afterCommit_lotesstock(curLS);
  }
  function generarLoteStock(curLinea: FLSqlCursor, cantidad: Number, curArticuloComp: FLSqlCursor): Boolean {
    return this.ctx.sofa_generarLoteStock(curLinea, cantidad, curArticuloComp);
  }
  function consistenciaLinea(curLinea: FLSqlCursor, comprobar: Boolean): Boolean {
    return this.ctx.sofa_consistenciaLinea(curLinea, comprobar);
  }
  function controlStockAlbaranesCli(curLA: FLSqlCursor): Boolean {
    return this.ctx.sofa_controlStockAlbaranesCli(curLA);
  }
  function datosEvolStock(idStock: String, fechaDesde: String, avisar: Boolean): Array {
    return this.ctx.sofa_datosEvolStock(idStock, fechaDesde, avisar);
  }
  function crearLote(datosArt: Array, cantidad: Number, idLinea: Number): String {
    return this.ctx.sofa_crearLote(datosArt, cantidad, idLinea);
  }
  //  function buscarLoteDisponible(curLinea:FLSqlCursor, cantidad:Number, curArticuloComp:FLSqlCursor):Boolean {
  //    return this.ctx.sofa_buscarLoteDisponible(curLinea, cantidad, curArticuloComp);
  //  }
  function borrarLote(codLote, curMS)
  {
    return this.ctx.sofa_borrarLote(codLote, curMS);
  }
  function preguntarSiFabricado(referencia: String): Boolean {
    return this.ctx.sofa_preguntarSiFabricado(referencia);
  }
}
//// SOFA ///////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition sofa */
/////////////////////////////////////////////////////////////////
//// SOFA ///////////////////////////////////////////////////////
/** \D Si no hay ninguna familia creada se llama a la función que introduce las familias por defecto
\end */
function sofa_init()
{
  this.iface.__init();

  var util: FLUtil = new FLUtil;
  if (util.sqlSelect("familias", "codfamilia", "1 = 1"))
    return;

  MessageBox.information(util.translate("scripts", "Producción de sofás: Se insertarán algunos valores iniciales para empezar a trabajar."), MessageBox.Ok, MessageBox.NoButton);
  this.iface.datosIniciales();
}

function sofa_datosIniciales(): Boolean {
  var curFamilias: FLSqlCursor = new FLSqlCursor("familias");
  var familias: Array = [["MOD", "Módulos"], ["TELA", "Telas"],
  ["ESQ", "Esqueletos"], ["CORT", "Cortes de tela"],
  ["XTRA", "Extras"]];
  for (var i: Number = 0; i < familias.length; i++)
  {
    with(curFamilias) {
      setModeAccess(Insert);
      refreshBuffer();
      setValueBuffer("codfamilia", familias[i][0]);
      setValueBuffer("descripcion", familias[i][1]);
      if (!commitBuffer())
        return false;
    }
  }
  return true;
}

function sofa_datosArticulo(cursor: FLSqlCursor, codLote: String): Array {
  var res: Array = new Array();
  var referencia: String = "";

  if (codLote && codLote != "")
  {
    var util: FLUtil;
    referencia = util.sqlSelect("lotesstock", "referencia", "codlote = '" + codLote + "'");

    if (!referencia || referencia == "")
      return false;

    res["localizador"] = "referencia = '" + referencia + "'";
    res["referencia"] = referencia;
    debug("ObservCorte " + util.sqlSelect("lotesstock", "observacionescorte", "codlote = '" + codLote + "'"));
    res["observacionescorte"] = util.sqlSelect("lotesstock", "observacionescorte", "codlote = '" + codLote + "'");
    res["observacionesmontaje"] = util.sqlSelect("lotesstock", "observacionesmontaje", "codlote = '" + codLote + "'");

    return res;
  } else {

    res = this.iface.__datosArticulo(cursor, codLote);
    //    res["observacionescorte"] = cursor.valueBuffer("observacionescorte");
    //    res["observacionesmontaje"] = cursor.valueBuffer("observacionesmontaje");
  }

  return res;
}

// function sofa_crearLote(datosArt:Array, cantidad:Number):String
// {
//  var codLote:String = this.iface.__crearLote(datosArt, cantidad);
//  if (!codLote)
//    return false;
//
// //   var util:FLUtil = new FLUtil;
// //
// //   if (util.sqlSelect("articulos", "codfamilia", "referencia = '" + datosArt["referencia"] + "'") == "CORT") {
// //     if (!this.iface.crearConsumosTela(codLote, referencia))
// //       return false;
// //   }
//
//  return codLote;
// }

function sofa_crearLote(datosArt: Array, cantidad: Number, idLinea: Number): String {
  var util: FLUtil;

  var curLoteStock: FLSqlCursor = new FLSqlCursor("lotesstock");
  curLoteStock.setModeAccess(curLoteStock.Insert);
  curLoteStock.refreshBuffer();
  curLoteStock.setValueBuffer("referencia", datosArt["referencia"]);
  var codLote: String = formRecordlotesstock.iface.pub_calculateCounter(curLoteStock);
  curLoteStock.setValueBuffer("codlote", codLote);
  curLoteStock.setValueBuffer("estado", "PTE");
  curLoteStock.setValueBuffer("canlote", cantidad);
  curLoteStock.setValueBuffer("cantotal", 0);
  curLoteStock.setValueBuffer("canusada", 0);
  curLoteStock.setValueBuffer("candisponible", 0);
  if (idLinea && idLinea != 0)
    curLoteStock.setValueBuffer("idlineapc", idLinea);

  var codFamilia: String = util.sqlSelect("articulos", "codfamilia", "referencia = '" + datosArt["referencia"] + "'");
  if ((codFamilia == "CORT" || codFamilia == "MOD") && formRecordlineaspedidoscli.cursor().isValid())
  {
    curLoteStock.setValueBuffer("observacionescorte", formRecordlineaspedidoscli.cursor().valueBuffer("observacionescorte"));
    curLoteStock.setValueBuffer("observacionesmontaje", formRecordlineaspedidoscli.cursor().valueBuffer("observacionesmontaje"));
  }
  if (!curLoteStock.commitBuffer())
    return false;

  return codLote;
}


/** \D Crea los movimientos de stock asociados al consumo de tela de un corte en función de la marcada escogida en la línea de pedido y los tipos de tela seleccionados
@param  codLote: Código de lote del corte
@param  referencia: Referencia del corte
\end */
// function sofa_crearConsumosTela(codLote:String, referencia:String):Boolean
// {
//  var util:FLUtil = new FLUtil;
//
//  var codTela:String;
//  var idMarcada:String = formRecordlineaspedidoscli.iface.pub_obtenerMarcada(tipoCorte);
//  if (!idMarcada || idMarcada == "") {
//    MessageBox.warning(util.translate("scripts", "Error al asociar telas a los cortes:\nNo ha especificado la marcada a usar"), MessageBox.Ok, MessageBox.NoButton);
//    return false;
//  }
//
//  var qryMarcada:FLSqlQuery = new FLSqlQuery;
//  with (qryMarcada) {
//    setTablesList("marcadas");
//    setSelect("lonfundas,lonmantas,lonbrazos,loncojines");
//    setFrom("marcadas");
//    setWhere("id = " + idMarcada);
//    setForwardOnly(true);
//  }
//  if (!qryMarcada.exec())
//    return false;
//
//  if (!qryMarcada.first())
//    return false;
//
//  var lonFundas:Number = parseFloat(qryMarcada.value("lonfundas"));
//  var curArticuloComp:FLSqlCursor = new FLSqlCursor("articuloscomp");
//  curArticuloComp.setModeAccess(curArticuloComp.Insert);
//  curArticuloComp.refreshBuffer();
//
//  if (lonFundas > 0) {
//    codTela = formRecordlineaspedidoscli.iface.pub_obtenerTela("Fundas");
//    if (!codTela || codTela == "") {
//      MessageBox.warning(util.translate("scripts", "Debe especificar un valor para la tela de Fundas"), MessageBox.Ok, MessageBox.NoButton);
//      return false;
//    }
//
//
//  }
//  var tipoCorte:String = util.sqlSelect("articulos","partecorte","referencia = '" + refCompuesto + "'");
//  var codTela:String = "";
//
//  codTela = formRecordlineaspedidoscli.iface.pub_obtenerTela(tipoCorte);
//
//  res["referencia"] = codTela;
//  var anchura:String = parseFloat(util.sqlSelect("articulos","anchura","referencia = '" + codTela + "'"));
//
//  res["cantidad"] = parseFloat(util.sqlSelect("telascorte","longitud","referencia = '" + refCompuesto + "' AND anchura = " + anchura));
//
//  if (!res["cantidad"]) {
//    MessageBox.warning(util.translate("scripts", "No hay establecido ningún corte para la tela " + codTela + " con anchura " + anchura), MessageBox.Ok, MessageBox.NoButton);
//    return false;
//  }
//
// }

// function sofa_crearComposicion(curLoteStock:FLSqlCursor, curComponente:FLSqlCursor):Boolean
// {
//  if (!this.iface.__crearComposicion(curLoteStock, curComponente))
//    return false;
//
//  var util:FLUtil = new FLUtil;
//
//  if (util.sqlSelect("articulos", "codfamilia", "referencia = '" + curLoteStock.valueBuffer("referencia") + "'") == "CORT") {
//    var codTela:String;
//    var idMarcada:String = formRecordlineaspedidoscli.iface.pub_obtenerMarcada();
//    if (!idMarcada || idMarcada == "") {
//      MessageBox.warning(util.translate("scripts", "Error al asociar telas a los cortes:\nNo ha especificado la marcada a usar"), MessageBox.Ok, MessageBox.NoButton);
//      return false;
//    }
//
//    var qryMarcada:FLSqlQuery = new FLSqlQuery;
//    with (qryMarcada) {
//      setTablesList("marcadas");
//      setSelect("lonfundas, lonmantas, lonrespaldo, lonbrazos, loncojines");
//      setFrom("marcadas");
//      setWhere("id = " + idMarcada);
//      setForwardOnly(true);
//    }
//    if (!qryMarcada.exec())
//      return false;
//
//    if (!qryMarcada.first())
//      return false;
//
//    var idTipoTareaCorte:String = util.sqlSelect("pr_tipostareapro", "idtipotareapro", "idtipoproceso = 'CORTE'");
//    if (!idTipoTareaCorte || idTipoTareaCorte == "") {
//      MessageBox.warning(util.translate("scripts", "Error al asociar telas a los cortes:\nNo existe un proceso llamado corte o el proceso no tiene tareas"), MessageBox.Ok, MessageBox.NoButton);
//      return false;
//    }
//
//    var curArticuloComp:FLSqlCursor = new FLSqlCursor("articuloscomp");
//    curArticuloComp.setModeAccess(curArticuloComp.Insert);
//    curArticuloComp.refreshBuffer();
//    curArticuloComp.setValueBuffer("refcompuesto", curLoteStock.valueBuffer("referencia"));
//    curArticuloComp.setValueBuffer("diasantelacion", 0);
//    curArticuloComp.setValueBuffer("idtipotareapro", idTipoTareaCorte);
//
//    var lonFundas:Number = parseFloat(qryMarcada.value("lonfundas"));
//    if (lonFundas > 0) {
//      codTela = formRecordlineaspedidoscli.iface.pub_obtenerTela("Fundas");
//      if (!codTela || codTela == "") {
//        MessageBox.warning(util.translate("scripts", "Debe especificar un valor para la tela de Fundas"), MessageBox.Ok, MessageBox.NoButton);
//        return false;
//      }
//      curArticuloComp.setValueBuffer("refcomponente", codTela);
//
//      if (!this.iface.buscarLoteDisponible(curLoteStock, lonFundas, curArticuloComp))
//        return false;
//    }
//
//    var lonMantas:Number = parseFloat(qryMarcada.value("lonmantas"));
//    if (lonMantas > 0) {
//      codTela = formRecordlineaspedidoscli.iface.pub_obtenerTela("Mantas");
//      if (!codTela || codTela == "") {
//        MessageBox.warning(util.translate("scripts", "Debe especificar un valor para la tela de Mantas"), MessageBox.Ok, MessageBox.NoButton);
//        return false;
//      }
//      curArticuloComp.setValueBuffer("refcomponente", codTela);
//
//      if (!this.iface.buscarLoteDisponible(curLoteStock, lonMantas, curArticuloComp))
//        return false;
//    }
//
//    var lonRespaldo:Number = parseFloat(qryMarcada.value("lonrespaldo"));
//    if (lonRespaldo > 0) {
//      codTela = formRecordlineaspedidoscli.iface.pub_obtenerTela("Respaldo");
//      if (!codTela || codTela == "") {
//        MessageBox.warning(util.translate("scripts", "Debe especificar un valor para la tela del Respaldo"), MessageBox.Ok, MessageBox.NoButton);
//        return false;
//      }
//      curArticuloComp.setValueBuffer("refcomponente", codTela);
//
//      if (!this.iface.buscarLoteDisponible(curLoteStock, lonRespaldo, curArticuloComp))
//        return false;
//    }
//
//    var lonBrazos:Number = parseFloat(qryMarcada.value("lonbrazos"));
//    if (lonBrazos > 0) {
//      codTela = formRecordlineaspedidoscli.iface.pub_obtenerTela("Brazos");
//      if (!codTela || codTela == "") {
//        MessageBox.warning(util.translate("scripts", "Debe especificar un valor para la tela de Brazos"), MessageBox.Ok, MessageBox.NoButton);
//        return false;
//      }
//      curArticuloComp.setValueBuffer("refcomponente", codTela);
//
//      if (!this.iface.buscarLoteDisponible(curLoteStock, lonBrazos, curArticuloComp))
//        return false;
//    }
//
//    var lonCojines:Number = parseFloat(qryMarcada.value("loncojines"));
//    if (lonCojines > 0) {
//      codTela = formRecordlineaspedidoscli.iface.pub_obtenerTela("Cojines");
//      if (!codTela || codTela == "") {
//        MessageBox.warning(util.translate("scripts", "Debe especificar un valor para la tela de Cojines"), MessageBox.Ok, MessageBox.NoButton);
//        return false;
//      }
//      curArticuloComp.setValueBuffer("refcomponente", codTela);
//
//      if (!this.iface.buscarLoteDisponible(curLoteStock, lonCojines, curArticuloComp))
//        return false;
//    }
//  }
//  return true;
// }

/** \D Si se trata de un componente de familia Patas, toma el valor del formulario de líneas de pedido de cliente
@param  cursor: Cursor del componente
\end */
function sofa_revisarComponente(curComponente: FLSqlCursor, idLinea: Number): Array {
  var util: FLUtil;
  var res: Array = new Array();

  var codFamilia: String = curComponente.valueBuffer("codfamiliacomponente");

  switch (codFamilia)
  {
    case "PATA": {
      res["cantidad"] = curComponente.valueBuffer("cantidad");
      var idPatas: String = formRecordlineaspedidoscli.iface.pub_obtenerPatas(idLinea);
      if (!idPatas || idPatas == "") {
        MessageBox.warning(util.translate("scripts", "Debe especificar un valor para las patas"), MessageBox.Ok, MessageBox.NoButton);
        return false;
      }
      res["referencia"] = idPatas;
      break;
    }
    case "TELA": {
      res["cantidad"] = curComponente.valueBuffer("cantidad");
      var idTela: String = formRecordlineaspedidoscli.iface.pub_obtenerTela(curComponente.valueBuffer("id"), idLinea);
      if (!idTela || idTela == "") {
        res = this.iface.__revisarComponente(curComponente, idLinea);
      }
      if (idTela == "-1")
        return false;
      res["referencia"] = idTela;
      break;
    }
    default: {
      res = this.iface.__revisarComponente(curComponente, idLinea);
    }
  }

  return res;
}

/** \D Para los artículos de la familia Módulo se realiza la generación de estructura de acuerdo con el modo en el que se arrancó el formulario
\end */
function sofa_controlStockPedidosCli(curLP: FLSqlCursor): Boolean {
  var util: FLUtil = new FLUtil();

  if (util.sqlSelect("articulos", "codfamilia", "referencia = '" + curLP.valueBuffer("referencia") + "'") != "MOD")
  {
    return this.iface.__controlStockPedidosCli(curLP);
  }

  switch (curLP.modeAccess())
  {
    case curLP.Insert: {
      break;
    }
    case curLP.Edit: {
      var modoOriginal: String = formpedidoscli.iface.pub_getModoOriginal();
      if (!modoOriginal || modoOriginal == "")
        modoOriginal = "Edit";
      switch (modoOriginal) {
        case "Insert": {
          var idLineaPresupuesto: String = curLP.valueBuffer("idlineapresupuesto");
          var idLineaPedido: String = curLP.valueBuffer("idlinea");

          if (idLineaPresupuesto && idLineaPresupuesto != "" && idLineaPresupuesto != 0) {
            if (util.sqlSelect("movistock", "idmovimiento", "idlineapr = " + idLineaPresupuesto)) {
              if (!this.iface.pedirLineaPresCli(idLineaPresupuesto, curLP))
                return false;
            } else {
              if (!this.iface.generarEstructura(curLP))
                return false;
            }
          } else {
            if (!this.iface.generarEstructura(curLP))
              return false;
          }
          break;
        }
        case "Edit": {
          var cantidad: String = curLP.valueBuffer("cantidad");
          var cantidadAnterior: String = curLP.valueBufferCopy("cantidad");
          if (cantidad != cantidadAnterior) {
            if (!this.iface.borrarEstructura(curLP))
              return false;
            if (!this.iface.generarEstructura(curLP))
              return false;
          }
          break;
        }
        case "Browse": {
          break;
        }
        default: {
          return false;
        }
      }
      break;
    }
    case curLP.Del: {
      if (!this.iface.__controlStockPedidosCli(curLP))
        return false;
      break;
    }
  }

  return true;
}

/** \C Establece la opción de marcada escogida por el usuario en el pedido, para el caso de lotes de tipo corte que son parte de un módulo incluido en un pedido
@param curLS: Lote de stock
@param qryOpciones: Consulta con las opciones del lote
\end */
function sofa_obtenerOpcionLote(qryOpciones: FLSqlQuery, codLote: String): Number {
  var util: FLUtil = new FLUtil;
  var referencia: String = util.sqlSelect("lotesstock", "referencia", "codlote = '" + codLote + "'");

  if (!referencia || referencia == "")
    return false;

  var codFamilia: String = util.sqlSelect("articulos", "codfamilia", "referencia = '" + referencia + "'");

  if (codFamilia != "CORT")
    return this.iface.__obtenerOpcionLote(qryOpciones, codLote);

  var idTipoOpcion: String
  var idMarcada: String;

  if (formRecordlineaspedidoscli.cursor())
  {
    idTipoOpcion = formRecordlineaspedidoscli.iface.obtenerIdTipoOpcionArtMarcada();

    if (!idTipoOpcion)
      return this.iface.__obtenerOpcionLote(qryOpciones, codLote);

    var idOpcionArtQry: Number = util.sqlSelect("tiposopcionartcomp", "idtipoopcionart", "idtipoopcion = " + qryOpciones.value("idtipoopcion") + " AND referencia = '" + referencia + "'");
    if (idOpcionArtQry != idTipoOpcion)
      return this.iface.__obtenerOpcionLote(qryOpciones, codLote);

    idMarcada = formRecordlineaspedidoscli.iface.pub_obtenerMarcada();

    if (!idMarcada)
      return false;
  } else {
    var idLinea: Number = util.sqlSelect("pr_procesos", "idlineapedidocli", "idobjeto = '" + codLote + "'");
    if (!idLinea)
      return false;
    idMarcada = util.sqlSelect("lineaspedidoscli", "idopcionarticulo", "idlinea = " + idLinea);
  }

  var idOpcion: Number = util.sqlSelect("opcionesarticulocomp", "idopcion", "idopcionarticulo = " + idMarcada);
  if (!idOpcion)
    return false;

  return idOpcion;
}

function sofa_afterCommit_lotesstock(curLS: FLSqlCursor): Boolean {
  var util: FLUtil = new FLUtil;

  if (!this.iface.__afterCommit_lotesstock(curLS))
    return false;

  return true;
}

function sofa_generarLoteStock(curLinea: FLSqlCursor, cantidad: Number, curArticuloComp: FLSqlCursor): Boolean {
  var util: FLUtil = new FLUtil;
  var codLote: String;
  var referencia: String
  switch (curLinea.table())
  {
    case "lineaspedidoscli": {
      if (util.sqlSelect("articulos", "codfamilia", "referencia = '" + curLinea.valueBuffer("referencia") + "'") == "MOD") {
        var canPedido: Number = curLinea.valueBuffer("cantidad");
        var referenciaMetraje: String = flfactppal.iface.pub_valorDefectoEmpresa("articulometraje");

        if (curLinea.valueBuffer("referencia") != referenciaMetraje) {
          for (var i: Number = 0; i < canPedido; i++) {
            if (!this.iface.__generarLoteStock(curLinea, 1))
              return false;
          }
        } else {
          if (!this.iface.__generarLoteStock(curLinea, canPedido))
            return false;
        }
      } else {
        if (!this.iface.__generarLoteStock(curLinea, cantidad, curArticuloComp))
          return false;
      }
      break;
    }
    default: {
      if (!this.iface.__generarLoteStock(curLinea, cantidad, curArticuloComp))
        return false;
    }
  }

  return true;
}

function sofa_consistenciaLinea(curLinea: FLSqlCursor, comprobar: Boolean): Boolean {
  if (comprobar)
  {
    return this.iface.__consistenciaLinea(curLinea);
  }

  return true;
}

function sofa_controlStockAlbaranesCli(curLA: FLSqlCursor): Boolean {
  var util: FLUtil = new FLUtil;
  if (!util.sqlSelect("articulos", "codfamilia", "referencia = '" + curLA.valueBuffer("referencia") + "'") == "MOD")
  {
    return this.iface.__controlStockAlbaranesCli(curLA);
  }

  var idLineaPedido: String = curLA.valueBuffer("idlineapedido");
  var idLineaAlbaran: String = curLA.valueBuffer("idlinea");

  if (idLineaPedido && idLineaPedido != "" && idLineaPedido != 0)
  {
    switch (curLA.modeAccess()) {
      case curLA.Insert:
      case curLA.Del: {
        if (!this.iface.__controlStockAlbaranesCli(curLA))
          return false;
        break;
      }
      case curLA.Edit: {
        /// \D No se hace nada, el cambio de cantidad se controla desde la línea de albarán.
        break;
        break;
      }
    }
  } else {
    if (!this.iface.__controlStockAlbaranesCli(curLA))
      return false;
  }
  return true;
}

function sofa_datosEvolStock(idStock: String, fechaDesde: String, avisar: Boolean): Array {
  var util: FLUtil;
  var referencia: String = util.sqlSelect("stocks", "referencia", "idstock = " + idStock);

  var familia: String = util.sqlSelect("articulos", "codfamilia", "referencia = '" + referencia + "'");

  var stock: String = util.sqlSelect("articulos", "tipostock", "referencia = '" + referencia + "'");

  var esRollo: Boolean = false;
  if (familia == "TELA" && stock == "Lotes")
    esRollo = true;

  if (!esRollo)
    return this.iface.__datosEvolStock(idStock, fechaDesde, avisar);

  var hoy: Date = new Date();

  var stockSS: Number = parseFloat(util.sqlSelect("articulos", "stockmin", "referencia = '" + referencia + "'"));
  if (!stockSS || isNaN(stockSS))
    stockSS = 0;

  var pte: Number = parseFloat(util.sqlSelect("movistock", "SUM(cantidad)", "idstock = " + idStock + " AND estado = 'PTE' and cantidad < 0 AND (fechaprev IS NULL OR fechaprev <= '" + hoy.toString() + "')")) * -1;
  if (!pte)
    pte = 0;

  var pteRecibir: Number = parseFloat(util.sqlSelect("movistock", "SUM(cantidad)", "idstock = " + idStock + " AND estado = 'PTE' and cantidad > 0 AND (fechaprev IS NULL OR fechaprev <= '" + hoy.toString() + "')"));
  if (!pteRecibir)
    pteRecibir = 0;

  var arrayEvolStock: Array = [];
  arrayEvolStock["avisar"] = avisar;
  arrayEvolStock[0] = this.iface.initPeriodoStock();
  arrayEvolStock[0]["fecha"] = hoy.toString().left(10) + "T00:00:00";
  arrayEvolStock[0]["stock"] = stock;
  arrayEvolStock[0]["D"] = 0;
  arrayEvolStock[0]["NB"] = pte;
  arrayEvolStock[0]["RP"] = pteRecibir;
  arrayEvolStock[0]["SS"] = stockSS;
  arrayEvolStock[0]["NN"] = arrayEvolStock[0]["NB"] - arrayEvolStock[0]["D"] + arrayEvolStock[0]["SS"] - arrayEvolStock[0]["RP"];
  if (arrayEvolStock[0]["NN"] < 0)
    arrayEvolStock[0]["NN"] = 0;

  return arrayEvolStock;
}

// function sofa_buscarLoteDisponible(curLinea:FLSqlCursor, cantidad:Number, curArticuloComp:FLSqlCursor):Boolean
// {debug("sofa_buscarLoteDisponible");
//  var util:FLUtil = new FLUtil;
//  var codLote:String;
//  var referencia:String
//  var datosArt:Array;
//
//
//  datosArt = this.iface.datosArticulo(curLinea);
//  if (!cantidad)
//    cantidad = curLinea.valueBuffer("cantidad");
//
//  var referenciaMetraje:String = flfactppal.iface.pub_valorDefectoEmpresa("articulometraje");
//
// debug("referenciaMetraje " + referenciaMetraje);
// debug("datosArt['referencia'] " + datosArt["referencia"]);
//
//  if(datosArt["referencia"] != referenciaMetraje)
//    return this.iface.__buscarLoteDisponible(curLinea,cantidad,curArticuloComp);
//
// debug("METRAJE -+----------------");
//  var fabricado:Boolean = util.sqlSelect("articulos", "fabricado", "referencia = '" + datosArt["referencia"] + "'");
//  var hayDisponible:Boolean = false;
//
//  if (fabricado && curLinea.table() == "lineaspresupuestoscli") {
//    // Por hacer
//    MessageBox.warning(util.translate("scripts", "No pueden presupuestarse artículos de fabricación"), MessageBox.Ok, MessageBox.NoButton);
//    return false;
//  }
//
// debug("crearLote");
//
//  codLote = this.iface.crearLote(datosArt, cantidad);
// debug("Lote " + codLote);
//
//  if (!codLote)
//    return false;
//
//  if (!this.iface.generarMoviStock(curLinea, codLote, cantidad, curArticuloComp))
//    return false;
//
//  return true;
// }

function sofa_borrarLote(codLote, curMS)
{
  var util: FLUtil;

  var idMov = curMS.valueBuffer("idmovimiento");
  if (!util.sqlSelect("movistock", "idmovimiento", "codlote = '" + codLote + "' AND idmovimiento <> " + idMov + " AND (idproceso = 0 OR idproceso IS NULL)")) {
    if (!this.iface.sacarDeOrdenProd(codLote))
      return false;

    if (!util.sqlDelete("lotesstock", "codlote = '" + codLote + "'"))
      return false;
  }

  return true;
}

function sofa_preguntarSiFabricado(referencia: String): Boolean {
  //En prod_sofa siempre que un lote sea de fabricación se fabrica aunque esté definido también como lote de compra.
  return true;
}
//// SOFA ///////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
