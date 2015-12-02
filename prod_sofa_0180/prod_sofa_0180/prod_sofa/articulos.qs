
/** @class_declaration sofa */
/////////////////////////////////////////////////////////////////
//// PROD_SOFA //////////////////////////////////////////////////
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
  function bufferChanged(fN: String)
  {
    return this.ctx.sofa_bufferChanged(fN);
  }
  function validateForm(): Boolean {
    return this.ctx.sofa_validateForm();
  }
  function tbnMarcadaDefecto_clicked()
  {
    return this.ctx.sofa_tbnMarcadaDefecto_clicked();
  }
  function calculateField(fN: String): String {
    return this.ctx.sofa_calculateField(fN);
  }
  function construirReferencia(curArticulo: FLSqlCursor): String {
    return this.ctx.sofa_construirReferencia(curArticulo);
  }
  function tbnCrearEsqueleto_clicked()
  {
    return this.ctx.sofa_tbnCrearEsqueleto_clicked();
  }
  function crearEsqueleto(): String {
    return this.ctx.sofa_crearEsqueleto();
  }
  function tbnCrearCorte_clicked()
  {
    return this.ctx.sofa_tbnCrearCorte_clicked();
  }
  function crearCorte(): String {
    return this.ctx.sofa_crearCorte();
  }
}
//// PROD_SOFA //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pubSofa */
/////////////////////////////////////////////////////////////////
//// PUB_SOFA ///////////////////////////////////////////////////
class pubSofa extends ifaceCtx
{
  function pubSofa(context)
  {
    ifaceCtx(context);
  }
  function pub_construirReferencia(curArticulo: FLSqlCursor): String {
    return this.construirReferencia(curArticulo);
  }
}
//// PUB_SOFA ///////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition sofa */
/////////////////////////////////////////////////////////////////
//// PRO_SOFA //////////////////////////////////////////////////
function sofa_init()
{
  this.iface.__init();

  var cursor: FLSqlCursor = this.cursor();

  connect(this.child("tbnMarcadaDefecto"), "clicked()", this, "iface.tbnMarcadaDefecto_clicked");
  connect(this.child("tbnCrearEsqueleto"), "clicked()", this, "iface.tbnCrearEsqueleto_clicked");
  connect(this.child("tbnCrearCorte"), "clicked()", this, "iface.tbnCrearCorte_clicked");

  this.iface.bufferChanged("codfamilia");

  switch (cursor.modeAccess()) {
    case cursor.Insert: {
      this.child("fdbImpuesto").setValue(flfactppal.iface.pub_valorDefectoEmpresa("codimpuesto"));
      break;
    }
    break;
  }
  this.child("fdbSofaCompleto").setDisabled(true);
}

function sofa_tbnMarcadaDefecto_clicked()
{
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  var curMarcada: FLSqlCursor = this.child("tdbMarcadas").cursor();
  if (!curMarcada || !curMarcada.isValid())
    return false;

  var idMarcada: String = this.child("tdbMarcadas").cursor().valueBuffer("id");
  if (!idMarcada || idMarcada == "")
    return false;

  if (!util.sqlUpdate("marcadas", "valordefecto", false, "referencia = '" + cursor.valueBuffer("referencia") + "'"))
    return false;

  if (!util.sqlUpdate("marcadas", "valordefecto", true, "id = " + idMarcada))
    return false;

  this.child("tdbMarcadas").refresh();
}

function sofa_bufferChanged(fN: String)
{
  var cursor: FLSqlCursor = this.cursor();
  var util: FLUtil;

  switch (fN) {
    case "codfamilia": {
      switch (cursor.valueBuffer("codfamilia")) {
        case "CORT": {
          this.child("tbwArticulo").setTabEnabled("sofa", true);

          this.child("fdbIdSerieTela").setValue("");
          this.child("fdbDescSerieTela").setValue("");
          this.child("fdbAnchura").setValue(0);
          this.child("tdbMarcadas").refresh();

          this.child("gbxTela").setDisabled(true);
          if (cursor.modeAccess() == cursor.Insert) {
            this.child("gbxModulo").setDisabled(false);
          } else {
            this.child("gbxModulo").setDisabled(true);
          }
          this.child("gbxMarcadas").setDisabled(false);
          this.child("fdbReferencia").setDisabled(true);
          this.child("fdbLoteUnico").setDisabled(false);
          this.child("fdbTipoStock").setDisabled(false);
        }
        break;
        case "ESQ": {
          this.child("tbwArticulo").setTabEnabled("sofa", true);

          this.child("fdbIdSerieTela").setValue("");
          this.child("fdbDescSerieTela").setValue("");
          this.child("fdbAnchura").setValue(0);
          this.child("tdbMarcadas").refresh();

          this.child("gbxTela").setDisabled(true);
          if (cursor.modeAccess() == cursor.Insert) {
            this.child("gbxModulo").setDisabled(false);
          } else {
            this.child("gbxModulo").setDisabled(true);
          }
          this.child("gbxMarcadas").setDisabled(true);
          this.child("fdbReferencia").setDisabled(true);
          this.child("fdbLoteUnico").setDisabled(false);
          this.child("fdbTipoStock").setDisabled(false);
          break;
        }
        case "MOD": {
          this.child("tbwArticulo").setTabEnabled("sofa", true);

          this.child("fdbIdSerieTela").setValue("");
          this.child("fdbDescSerieTela").setValue("");
          this.child("fdbAnchura").setValue(0);

          this.child("gbxTela").setDisabled(true);
          if (cursor.modeAccess() == cursor.Insert) {
            this.child("gbxModulo").setDisabled(false);
          } else {
            this.child("gbxModulo").setDisabled(true);
          }
          this.child("gbxMarcadas").setDisabled(true);
          this.child("fdbReferencia").setDisabled(true);
          this.child("fdbLoteUnico").setDisabled(false);
          this.child("fdbTipoStock").setDisabled(false);
        }
        break;
        case "TELA": {
          this.child("tbwArticulo").setTabEnabled("sofa", true);

          this.child("fdbIdModelo").setValue("");
          this.child("fdbDescModelo").setValue("");
          this.child("fdbConfiguracion").setValue("");
          this.child("tdbMarcadas").refresh();

          this.child("gbxTela").setDisabled(false);
          this.child("gbxModulo").setDisabled(true);
          this.child("gbxMarcadas").setDisabled(true);
          if (cursor.valueBuffer("tipostock") == "Lotes") {
            cursor.setValueBuffer("loteunico", true);
            this.child("fdbLoteUnico").setDisabled(true);
          }
          this.child("fdbTipoStock").setDisabled(false);
        }
        break;
        case "FIBR":
        case "GOMA":
        case "INCR":
        case "PATA":
        case "VELO": {
          cursor.setValueBuffer("tipostock", "Sin stock");
          this.child("fdbTipoStock").setDisabled(true);
          break;
        }
        default: {
          this.child("fdbIdSerieTela").setValue("");
          this.child("fdbDescSerieTela").setValue("");
          this.child("fdbAnchura").setValue("");
          this.child("fdbIdModelo").setValue("");
          this.child("fdbDescModelo").setValue("");
          this.child("fdbConfiguracion").setValue("");
          this.child("tbwArticulo").setTabEnabled("sofa", false);
          this.child("fdbLoteUnico").setDisabled(false);
          this.child("fdbTipoStock").setDisabled(false);
        }
        break;
      }
      break;
    }
    case "idmodelo":
    case "configuracion": {
      switch (cursor.valueBuffer("codfamilia")) {
        case "MOD":
        case "CORT":
        case "ESQ": {
          this.child("fdbReferencia").setValue(this.iface.calculateField("referencia"));
          break;
        }
      }
      this.child("fdbSofaCompleto").setValue(this.iface.calculateField("sofacompleto"));
      break;
    }
    case "tipostock": {
      if (cursor.valueBuffer("tipostock") != "Lotes") {
        cursor.setValueBuffer("loteunico", false);
        this.child("fdbLoteUnico").setDisabled(true);
      } else {
        if (cursor.valueBuffer("codfamilia") == "TELA") {
          cursor.setValueBuffer("loteunico", true);
          this.child("fdbLoteUnico").setDisabled(true);
        } else
          this.child("fdbLoteUnico").setDisabled(false);
      }
      break;
    }
    default: {
      return this.iface.__bufferChanged(fN);
    }
  }
}

function sofa_validateForm(): Boolean {
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  if (!this.iface.__validateForm())
    return false;

  switch (cursor.valueBuffer("codfamilia"))
  {
    case "MOD":
    case "ESQ":
    case "CORT": {
      if (cursor.valueBuffer("referencia") != this.iface.calculateField("referencia")) {
        MessageBox.warning(util.translate("scripts", "El código del artículo no coincide con la combinación modelo - configuración establecida."), MessageBox.Ok, MessageBox.NoButton);
        return false;
      }
      if (!cursor.valueBuffer("idmodelo") || cursor.valueBuffer("idmodelo") == "") {
        MessageBox.warning(util.translate("scripts", "Debe establecer el modelo."), MessageBox.Ok, MessageBox.NoButton);
        return false;
      }
      if (!cursor.valueBuffer("configuracion") || cursor.valueBuffer("configuracion") == "") {
        MessageBox.warning(util.translate("scripts", "Debe establecer la configuración del modelo."), MessageBox.Ok, MessageBox.NoButton);
        return false;
      }
      break;
    }
    case "TELA": {
      if (!cursor.valueBuffer("idserietela") || cursor.valueBuffer("idserietela") == "") {
        MessageBox.warning(util.translate("scripts", "Debe establecer la serie de tela."), MessageBox.Ok, MessageBox.NoButton);
        return false;
      }
      /*
            if (!cursor.valueBuffer("anchura") || cursor.valueBuffer("anchura") == "" || cursor.valueBuffer("anchura") == 0) {
              MessageBox.warning(util.translate("scripts", "Debe establecer la la anchura de la tela."), MessageBox.Ok, MessageBox.NoButton);
              return false;
            }
      */
      break;
    }
    default: {
    }
    break;
  }

  return true;
}

function sofa_calculateField(fN: String): String {
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  var valor: String;
  switch (fN)
  {
    case "referencia": {
      switch (cursor.valueBuffer("codfamilia")) {
        case "MOD":
        case "ESQ":
        case "CORT": {
          valor = this.iface.construirReferencia(cursor);
          break;
        }
      }
      break;
    }
    case "sofacompleto": {
      var conf: String = cursor.valueBuffer("configuracion");
      if (conf.startsWith("B") && conf.endsWith("B")) {
        valor = true;
      } else {
        valor = false;
      }
      break;
    }
    default: {
      valor = this.iface.__calculateField(fN);
    }
  }
  return valor;
}

function sofa_tbnCrearEsqueleto_clicked()
{
  var util: FLUtil = new FLUtil;
  var cursorTrans: FLSqlCursor = new FLSqlCursor("articulos");

  cursorTrans.transaction(false);
  try {
    this.iface.referenciaComp_ = this.iface.crearEsqueleto();
    if (this.iface.referenciaComp_) {
      cursorTrans.commit();
      this.iface.refrescarArbol();
    } else {
      cursorTrans.rollback();
    }
  } catch (e) {
    cursorTrans.rollback();
    MessageBox.critical(util.translate("scripts", "Error al generar el esqueleto: ") + e, MessageBox.Ok, MessageBox.NoButton);
  }
}

function sofa_crearEsqueleto(): String {
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  if (cursor.modeAccess() == cursor.Insert)
  {
    if (!this.child("tdbArticulosTarifas").cursor().commitBufferCursorRelation())
      return false;

    this.iface.crearArbolComponentes();
    this.iface.crearArbolCompuestos();
  }

  var idTipoProceso: String = cursor.valueBuffer("idtipoproceso");
  var idModelo: String = cursor.valueBuffer("idmodelo");
  var desComponente: String;
  var configuracion: String = cursor.valueBuffer("configuracion");
  var referencia: String = util.sqlSelect("articulos", "referencia", "codfamilia = 'ESQ' AND idmodelo = '" + idModelo + "' AND configuracion = '" + configuracion + "'");
  if (referencia)
  {
    var res: Number = MessageBox.information(util.translate("scripts", "Ya existe un esqueleto con modelo %1 y configuración %2 (%3)\n¿Desea asociarlo al módulo?").arg(idModelo).arg(configuracion).arg(referencia), MessageBox.Yes, MessageBox.No);
    if (res != MessageBox.Yes)
      return false;
    desComponente = util.sqlSelect("articulos", "descripcion", "referencia = '" + referencia + "'");
  } else {
    var curArticulo: FLSqlCursor = new FLSqlCursor("articulos");
    curArticulo.setModeAccess(curArticulo.Insert);
    curArticulo.refreshBuffer();
    curArticulo.setValueBuffer("idmodelo", idModelo);
    curArticulo.setValueBuffer("configuracion", configuracion);
    curArticulo.setValueBuffer("codfamilia", "ESQ");
    referencia = this.iface.construirReferencia(curArticulo);
    curArticulo.setValueBuffer("referencia", referencia);
    desComponente = util.translate("scripts", "Esqueleto modelo %1 - configuración %2").arg(idModelo).arg(configuracion);
    curArticulo.setValueBuffer("descripcion", desComponente);
    if (!curArticulo.commitBuffer())
      return false;
  }

  var curArticuloComp: FLSqlCursor = new FLSqlCursor("articuloscomp");
  curArticuloComp.setModeAccess(curArticuloComp.Insert);
  curArticuloComp.refreshBuffer();
  curArticuloComp.setValueBuffer("refcompuesto", cursor.valueBuffer("referencia"));
  curArticuloComp.setValueBuffer("refcomponente", referencia);
  curArticuloComp.setValueBuffer("desccomponente", desComponente);
  curArticuloComp.setValueBuffer("cantidad", 1);
  curArticuloComp.setValueBuffer("codunidad", util.sqlSelect("familias", "codunidad", "codfamilia = 'ESQ'"));

  var idTipoTareaPro: String = util.sqlSelect("pr_tipostareapro", "idtipotareapro", "idtipoproceso = '" + idTipoProceso + "' AND idtipotarea = 'MONTAJE'");
  if (!idTipoTareaPro)
  {
    MessageBox.information(util.translate("scripts", "No existe tipo de tarea MONTAJE asociada a un tipo de proceso %1.\nDebe establecer estos valores en el módulo de procesos").arg(idTipoProceso), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  curArticuloComp.setValueBuffer("idtipotareapro", idTipoTareaPro);
  curArticuloComp.setValueBuffer("diasantelacion", 0);

  if (!curArticuloComp.commitBuffer())
    return false;

  return referencia;
}

function sofa_tbnCrearCorte_clicked()
{
  var util: FLUtil = new FLUtil;
  var cursorTrans: FLSqlCursor = new FLSqlCursor("articulos");

  cursorTrans.transaction(false);
  try {
    this.iface.referenciaComp_ = this.iface.crearCorte();
    if (this.iface.referenciaComp_) {
      cursorTrans.commit();
      this.iface.refrescarArbol();
    } else {
      cursorTrans.rollback();
    }
  } catch (e) {
    cursorTrans.rollback();
    MessageBox.critical(util.translate("scripts", "Error al generar el corte: ") + e, MessageBox.Ok, MessageBox.NoButton);
  }
}

function sofa_crearCorte(): String {
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  var idTipoProcesoCorte: String = util.sqlSelect("pr_tiposproceso", "idtipoproceso", "corte = true");
  if (!idTipoProcesoCorte)
  {
    MessageBox.warning(util.translate("scripts", "No existe tipo de proceso marcado como proceso de corte."), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  var idTipoOpcionMarcada: String = util.sqlSelect("tiposopcioncomp", "idtipoopcion", "tipo = 'MARCADA'");
  if (!idTipoOpcionMarcada)
  {
    MessageBox.warning(util.translate("scripts", "No tiene definido un tipo de opción MARCADA para artículos compuestos.\nSin esta definición no es posible calcular la tela de los módulos.\nCree un tipo de opción con nombre 'MARCADA' en el módulo de almacén."), MessageBox.Ok, MessageBox.NoButton);
  }

  if (cursor.modeAccess() == cursor.Insert)
  {
    if (!this.child("tdbArticulosTarifas").cursor().commitBufferCursorRelation())
      return false;

    this.iface.crearArbolComponentes();
    this.iface.crearArbolCompuestos();
  }

  var idTipoProceso: String = cursor.valueBuffer("idtipoproceso");
  var idModelo: String = cursor.valueBuffer("idmodelo");
  var desComponente: String;
  var configuracion: String = cursor.valueBuffer("configuracion");
  var referencia: String = util.sqlSelect("articulos", "referencia", "codfamilia = 'CORT' AND idmodelo = '" + idModelo + "' AND configuracion = '" + configuracion + "'");
  if (referencia)
  {
    var res: Number = MessageBox.information(util.translate("scripts", "Ya existe un corte con modelo %1 y configuración %2 (%3)\n¿Desea asociarlo al módulo?").arg(idModelo).arg(configuracion).arg(referencia), MessageBox.Yes, MessageBox.No);
    if (res != MessageBox.Yes)
      return false;
    desComponente = util.sqlSelect("articulos", "descripcion", "referencia = '" + referencia + "'");
  } else {
    var curArticulo: FLSqlCursor = new FLSqlCursor("articulos");
    curArticulo.setModeAccess(curArticulo.Insert);
    curArticulo.refreshBuffer();
    curArticulo.setValueBuffer("idmodelo", idModelo);
    curArticulo.setValueBuffer("configuracion", configuracion);
    curArticulo.setValueBuffer("codfamilia", "CORT");
    referencia = this.iface.construirReferencia(curArticulo);
    curArticulo.setValueBuffer("referencia", referencia);
    curArticulo.setValueBuffer("fabricado", true);
    curArticulo.setValueBuffer("tipostock", "Lotes");
    curArticulo.setValueBuffer("idtipoproceso", idTipoProcesoCorte);
    desComponente = util.translate("scripts", "Corte modelo %1 - configuración %2").arg(idModelo).arg(configuracion);
    curArticulo.setValueBuffer("descripcion", cursor.valueBuffer("descripcion"));
    if (!curArticulo.commitBuffer())
      return false;
  }

  var curArticuloComp: FLSqlCursor = new FLSqlCursor("articuloscomp");
  curArticuloComp.setModeAccess(curArticuloComp.Insert);
  curArticuloComp.refreshBuffer();
  curArticuloComp.setValueBuffer("refcompuesto", cursor.valueBuffer("referencia"));
  curArticuloComp.setValueBuffer("refcomponente", referencia);
  curArticuloComp.setValueBuffer("desccomponente", desComponente);
  curArticuloComp.setValueBuffer("cantidad", 1);
  curArticuloComp.setValueBuffer("codunidad", util.sqlSelect("familias", "codunidad", "codfamilia = 'CORT'"));

  var tipoTarea: String = "";
  switch (idTipoProceso)
  {
    case "MODULO": {
      tipoTarea = "'COSIDOM','COSIDOF'";
      break;
    }
    case "ALMOHADON":
    case "SILLON": {
      tipoTarea = "'COSIDO'";
      break;
    }
    case "METRAJE": {
      tipoTarea = "'EMBALADO'";
      break;
    }
  }

  var idTipoTareaPro: String = util.sqlSelect("pr_tipostareapro", "idtipotareapro", "idtipoproceso = '" + idTipoProceso + "' AND idtipotarea IN (" + tipoTarea + ")");
  if (!idTipoTareaPro)
  {
    MessageBox.information(util.translate("scripts", "No existe tipo de tarea %2 asociada a un tipo de proceso %1.\nDebe establecer estos valores en el módulo de procesos").arg(idTipoProceso).arg(tipoTarea), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  curArticuloComp.setValueBuffer("idtipotareapro", idTipoTareaPro);
  curArticuloComp.setValueBuffer("diasantelacion", 0);

  if (!curArticuloComp.commitBuffer())
    return false;

  var curOpciones: FLSqlCursor = new FLSqlCursor("tiposopcionartcomp");
  curOpciones.setModeAccess(curOpciones.Insert);
  curOpciones.refreshBuffer();
  curOpciones.setValueBuffer("referencia", referencia);
  curOpciones.setValueBuffer("idtipoopcion", idTipoOpcionMarcada);
  curOpciones.setValueBuffer("tipo", util.translate("scripts", "MARCADA"));
  if (!curOpciones.commitBuffer())
    return false;

  return referencia;
}

function sofa_construirReferencia(curArticulo: FLSqlCursor): String {
  var referencia: String = curArticulo.valueBuffer("codfamilia").left(3) + "-" + curArticulo.valueBuffer("idmodelo") + "-" + curArticulo.valueBuffer("configuracion");
  return referencia;
}
//// PRO_SOFA //////////////////////////////////////////////////
////////////////////////////////////////////////////////////////
