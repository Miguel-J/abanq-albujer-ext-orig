
/** @class_declaration artesG */
/////////////////////////////////////////////////////////////////
//// ARTES GRÁFICAS /////////////////////////////////////////////
class artesG extends prod
{
  var bloqueoCosteMedio_: Boolean
  function artesG(context)
  {
    prod(context);
  }
  function init()
  {
    return this.ctx.artesG_init();
  }
  function bufferChanged(fN: String)
  {
    return this.ctx.artesG_bufferChanged(fN);
  }
  function calculateField(fN: String): String {
    return this.ctx.artesG_calculateField(fN);
  }
  function validateForm(): Boolean {
    return this.ctx.artesG_validateForm();
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

  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  this.iface.bloqueoCosteMedio_ = false;

  if (cursor.action() == "papeles") {
    this.child("fdbCodFamilia").setDisabled(true);
    if (cursor.modeAccess() == cursor.Insert) {
      this.child("fdbCodFamilia").setValue("PAPE");
    }
  }

  this.iface.bufferChanged("codfamilia");
}

function artesG_bufferChanged(fN: String)
{
  debug("bCh " + fN);
  var cursor: FLSqlCursor = this.cursor();
  switch (fN) {
    case "codfamilia": {
      var codFamilia = cursor.valueBuffer("codfamilia");
      switch (codFamilia) {
        case "PAPE": {
          this.child("tbwArticulo").setTabEnabled("graficas", true);
          this.child("fdbAnchoPliego").setDisabled(false);
          this.child("fdbAltoPliego").setDisabled(false);
          this.child("fdbDimPliego").setDisabled(true);
          this.child("fdbGramaje").setDisabled(false);
          this.child("fdbCodMarcaPapel").setDisabled(false);
          this.child("fdbUnidadesGr").setDisabled(false);
          this.child("fdbCmsGr").setDisabled(false);
          this.child("fdbGrosorUnidad").setDisabled(false);
          this.child("fdbTipoPlas").setDisabled(true);
          this.child("fdbCodFormato").setDisabled(false);
          this.child("fdbCodCalidad").setDisabled(false);
          this.child("gbxTroquel").enabled = false;
          this.child("gbxPapel").enabled = true;
          break;
        }
        case "PLAN": {
          this.child("tbwArticulo").setTabEnabled("graficas", true);
          this.child("fdbAnchoPliego").setDisabled(false);
          this.child("fdbAltoPliego").setDisabled(false);
          this.child("fdbDimPliego").setDisabled(true);
          this.child("fdbGramaje").setDisabled(true);
          this.child("fdbCodMarcaPapel").setDisabled(true);
          this.child("fdbUnidadesGr").setDisabled(true);
          this.child("fdbCmsGr").setDisabled(true);
          this.child("fdbGrosorUnidad").setDisabled(true);
          this.child("fdbTipoPlas").setDisabled(true);
          this.child("fdbCodFormato").setDisabled(true);
          this.child("fdbCodCalidad").setDisabled(true);
          this.child("gbxTroquel").enabled = false;
          this.child("gbxPapel").enabled = false;
          break;
        }
        case "PLAS": {
          this.child("tbwArticulo").setTabEnabled("graficas", true);
          this.child("fdbAnchoPliego").setDisabled(false);
          this.child("fdbAltoPliego").setDisabled(true);
          this.child("fdbDimPliego").setDisabled(true);
          this.child("fdbGramaje").setDisabled(true);
          this.child("fdbCodMarcaPapel").setDisabled(true);
          this.child("fdbUnidadesGr").setDisabled(true);
          this.child("fdbCmsGr").setDisabled(true);
          this.child("fdbGrosorUnidad").setDisabled(true);
          this.child("fdbTipoPlas").setDisabled(false);
          this.child("fdbCodFormato").setDisabled(true);
          this.child("fdbCodCalidad").setDisabled(true);
          this.child("gbxTroquel").enabled = false;
          this.child("gbxPapel").enabled = false;
          break;
        }
        case "PROD": {
          this.child("tbwArticulo").setTabEnabled("graficas", true);
          this.child("fdbAnchoPliego").setDisabled(true);
          this.child("fdbAltoPliego").setDisabled(true);
          this.child("fdbDimPliego").setDisabled(true);
          this.child("fdbGramaje").setDisabled(true);
          this.child("fdbCodMarcaPapel").setDisabled(true);
          this.child("fdbUnidadesGr").setDisabled(true);
          this.child("fdbCmsGr").setDisabled(true);
          this.child("fdbGrosorUnidad").setDisabled(true);
          this.child("fdbTipoPlas").setDisabled(true);
          this.child("fdbCodFormato").setDisabled(true);
          this.child("fdbCodCalidad").setDisabled(true);
          this.child("gbxTroquel").enabled = false;
          this.child("gbxPapel").enabled = false;
          break;
        }
        case "TROQ": {
          this.child("tbwArticulo").setTabEnabled("graficas", true);
          this.child("fdbAnchoPliego").setDisabled(false);
          this.child("fdbAltoPliego").setDisabled(false);
          this.child("fdbDimPliego").setDisabled(true);
          this.child("fdbGramaje").setDisabled(true);
          this.child("fdbCodMarcaPapel").setDisabled(true);
          this.child("fdbUnidadesGr").setDisabled(true);
          this.child("fdbCmsGr").setDisabled(true);
          this.child("fdbGrosorUnidad").setDisabled(true);
          this.child("fdbTipoPlas").setDisabled(true);
          this.child("fdbCodFormato").setDisabled(true);
          this.child("fdbCodCalidad").setDisabled(true);
          this.child("gbxTroquel").enabled = true;
          this.child("gbxPapel").enabled = false;
          break;
        }
        default: {
          this.child("tbwArticulo").setTabEnabled("graficas", false);
        }
      }
      break;
    }
    case "unidadesgr": {
      this.child("lblPesoPliegos").text = this.iface.calculateField("pesopliegos");
      this.child("fdbGrosorUnidad").setValue(this.iface.calculateField("grosorunidad"));
      break;
    }
    case "cmsgr": {
      this.child("fdbGrosorUnidad").setValue(this.iface.calculateField("grosorunidad"));
      break;
    }
    case "anchopliego":
    case "altopliego": {
      this.child("fdbDimPliego").setValue(this.iface.calculateField("dimpliego"));
      this.child("lblPesoPliegos").text = this.iface.calculateField("pesopliegos");
      break;
    }
    case "gramaje": {
      this.child("lblPesoPliegos").text = this.iface.calculateField("pesopliegos");
      this.child("fdbUnidadesGr").setValue(this.iface.calculateField("unidadesgr"));
      this.child("fdbCmsGr").setValue(this.iface.calculateField("cmsgr"));
      this.child("fdbGrosorUnidad").setValue(this.iface.calculateField("grosorunidad2"));
      break;
    }
    case "codcalidad": {
      this.child("fdbUnidadesGr").setValue(this.iface.calculateField("unidadesgr"));
      this.child("fdbCmsGr").setValue(this.iface.calculateField("cmsgr"));
      this.child("fdbGrosorUnidad").setValue(this.iface.calculateField("grosorunidad2"));
      break;
    }
    case "costemedio": {
      if (!this.iface.bloqueoCosteMedio_) {
        this.iface.bloqueoCosteMedio_ = true;
        this.child("fdbCosteMedioET").setValue(this.iface.calculateField("costemedioet"));
        this.iface.bloqueoCosteMedio_ = false;
      }
      break;
    }
    case "costemedioet": {
      if (!this.iface.bloqueoCosteMedio_) {
        this.iface.bloqueoCosteMedio_ = true;
        this.child("fdbCosteMedio").setValue(this.iface.calculateField("costemedio"));
        this.iface.bloqueoCosteMedio_ = false;
      }
      break;
    }
    default: {
      this.iface.__bufferChanged(fN);
    }
  }
  debug("Fin BCH");
}

function artesG_calculateField(fN: String): String {
  debug("CF " + fN);
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();
  var valor: String;

  switch (fN)
  {
    case "unidadesgr": {
      var codCalidad: String = cursor.valueBuffer("codcalidad");
      var gramaje: String = cursor.valueBuffer("gramaje");
      valor = util.sqlSelect("gramajescalidad", "unidadesgr", "codcalidad = '" + codCalidad + "' AND gramaje = " + gramaje);
      if (!valor) {
        valor = util.sqlSelect("gramajes", "unidadesgr", "gramaje = " + gramaje);
      }
      break;
    }
    case "cmsgr": {
      var codCalidad: String = cursor.valueBuffer("codcalidad");
      var gramaje: String = cursor.valueBuffer("gramaje");
      valor = util.sqlSelect("gramajescalidad", "cmsgr", "codcalidad = '" + codCalidad + "' AND gramaje = " + gramaje);
      if (!valor) {
        valor = util.sqlSelect("gramajes", "cmsgr", "gramaje = " + gramaje);
      }
      break;
    }
    case "grosorunidad2": {
      var codCalidad: String = cursor.valueBuffer("codcalidad");
      var gramaje: String = cursor.valueBuffer("gramaje");
      valor = util.sqlSelect("gramajescalidad", "grosorunidad", "codcalidad = '" + codCalidad + "' AND gramaje = " + gramaje);
      if (!valor) {
        valor = util.sqlSelect("gramajes", "grosorunidad", "gramaje = " + gramaje);
      }
      break;
    }
    case "grosorunidad": {
      debug(1);
      var unidades: Number = parseFloat(cursor.valueBuffer("unidadesgr"));
      debug("unidades = " + unidades);
      if (unidades != 0) {
        debug("unidades != 0");
        valor = parseFloat(cursor.valueBuffer("cmsgr")) / unidades;
        debug("valor = " + valor);
      } else {
        debug("unidades == 0");
        valor = 0;
      }
      break;
    }
    case "dimpliego": {
      valor = util.roundFieldValue(cursor.valueBuffer("anchopliego"), "articulos", "anchopliego") + "x" + util.roundFieldValue(cursor.valueBuffer("altopliego"), "articulos", "altopliego");
      break;
    }
    case "costemedioet": {
      var ancho: Number = parseFloat(cursor.valueBuffer("anchopliego"));
      if (isNaN(ancho) || ancho == 0) {
        valor = 0;
        break;
      }
      var alto: Number = parseFloat(cursor.valueBuffer("altopliego"));
      if (isNaN(alto) || alto == 0) {
        valor = 0;
        break;
      }
      var gramaje: Number = parseFloat(cursor.valueBuffer("gramaje"));
      if (isNaN(gramaje) || gramaje == 0) {
        valor = 0;
        break;
      }
      valor = parseFloat(cursor.valueBuffer("costemedio")) / ((ancho / 100) * (alto / 100) * (gramaje * 0.000001));
      break;
    }
    case "costemedio": {
      var ancho: Number = parseFloat(cursor.valueBuffer("anchopliego"));
      if (isNaN(ancho) || ancho == 0) {
        valor = 0;
        break;
      }
      var alto: Number = parseFloat(cursor.valueBuffer("altopliego"));
      if (isNaN(alto) || alto == 0) {
        valor = 0;
        break;
      }
      var gramaje: Number = parseFloat(cursor.valueBuffer("gramaje"));
      if (isNaN(gramaje) || gramaje == 0) {
        valor = 0;
        break;
      }
      valor = parseFloat(cursor.valueBuffer("costemedioet")) * ((ancho / 100) * (alto / 100) * (gramaje * 0.000001));
      break;
    }
    case "pesopliegos": {
      var ancho: Number = parseFloat(cursor.valueBuffer("anchopliego"));
      if (isNaN(ancho)) {
        ancho = 0;
      }
      var alto: Number = parseFloat(cursor.valueBuffer("altopliego"));
      if (isNaN(alto)) {
        alto = 0;
      }
      var gramaje: Number = parseFloat(cursor.valueBuffer("gramaje"));
      if (isNaN(gramaje)) {
        gamaje = 0;
      }
      valor = alto * ancho * gramaje * parseFloat(cursor.valueBuffer("unidadesgr")) / 10000000;
      valor =  util.roundFieldValue(valor, "articulos", "altopliego")
               break;
    }
    default: {
      valor = this.iface.__calculateField(fN);
    }
  }
  // debug("valor =  " + valor);
  return valor;
}

function artesG_validateForm(): Boolean {
  if (!this.iface.__validateForm())
    return false;

  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();
  var codFamilia: String = cursor.valueBuffer("codfamilia");
  switch (codFamilia)
  {
    case "PAPE": {
      var gramaje: Number = parseInt(cursor.valueBuffer("gramaje"));
      if (isNaN(gramaje) || gramaje == 0) {
        MessageBox.warning(util.translate("scripts", "Si la familia del artículo es %1 debe establecer el gramaje del pliego").arg(codFamilia), MessageBox.Ok, MessageBox.NoButton);
        return false;
      }
      var codMarcaPapel: String = cursor.valueBuffer("codmarcapapel");
      if (!codMarcaPapel || codMarcaPapel == "") {
        MessageBox.warning(util.translate("scripts", "Si la familia del artículo es %1 debe establecer la marca del papel").arg(codFamilia), MessageBox.Ok, MessageBox.NoButton);
        return false;
      }
      //      var grosorUnidad:Number = parseFloat(cursor.valueBuffer("grosorunidad"));
      //      if (isNaN(grosorUnidad) || grosorUnidad == 0) {
      //        MessageBox.warning(util.translate("scripts", "Si la familia del artículo es %1 debe establecer los cms/unidad del pliego").arg(codFamilia), MessageBox.Ok, MessageBox.NoButton);
      //        return false;
      //      }
    }
    case "PLAN": {
      var dimPliego: String = cursor.valueBuffer("dimpliego");
      if (!dimPliego || dimPliego == "") {
        MessageBox.warning(util.translate("scripts", "Si la familia del artículo es %1 debe establecer las dimensiones del pliego o plancha").arg(codFamilia), MessageBox.Ok, MessageBox.NoButton);
        return false;
      }
      var dimensiones: Array = dimPliego.split("x");
      if (dimensiones.length != 2) {
        MessageBox.warning(util.translate("scripts", "El formato de las dimensiones del pliego o plancha debe ser NxM"), MessageBox.Ok, MessageBox.NoButton);
        return false;
      }
      if (isNaN(dimensiones[0]) || isNaN(dimensiones[1])) {
        MessageBox.warning(util.translate("scripts", "El formato de las dimensiones del pliego debe ser NxM"), MessageBox.Ok, MessageBox.NoButton);
        return false;
      }
      break;
    }
    case "PLAS": {
      var anchoPlas: Number = parseFloat(cursor.valueBuffer("anchopliego"));
      if (isNaN(anchoPlas) || anchoPlas == 0) {
        MessageBox.warning(util.translate("scripts", "Si la familia del artículo es %1 debe establecer la anchura del rollo").arg(codFamilia), MessageBox.Ok, MessageBox.NoButton);
        return false;
      }
      var tipoPlas: String = cursor.valueBuffer("tipoplas");
      if (tipoPlas != "Mate" && tipoPlas != "Brillo") {
        MessageBox.warning(util.translate("scripts", "Si la familia del artículo es %1 debe establecer el tipo de plástico (Mate/Brillo)").arg(codFamilia), MessageBox.Ok, MessageBox.NoButton);
        return false;
      }
      break;
    }
  }

  return true;
}

//// ARTES GRÁFICAS /////////////////////////////////////////////
////////////////////////////////////////////////////////////
