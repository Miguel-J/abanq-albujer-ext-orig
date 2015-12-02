
/** @class_declaration sgaBarcode */
/////////////////////////////////////////////////////////////////
//// SGA_BARCODE ///////////////////////////////////////////////
class sgaBarcode extends sga
{
  function sgaBarcode(context)
  {
    sga(context);
  }
  function buscarArticulo(codBarras: String): Array {
    return this.ctx.sgaBarcode_buscarArticulo(codBarras);
  }
  function buscarArticuloManual(): String {
    return this.ctx.sgaBarcode_buscarArticuloManual();
  }
  function crearUbicacion(referencia: String, barcode: String): String {
    return this.ctx.sgaBarcode_crearUbicacion(referencia, barcode);
  }
  function beforeCommit_ubicacionesarticulo(curUbicacion: FLSqlCursor): Boolean {
    return this.ctx.sgaBarcode_beforeCommit_ubicacionesarticulo(curUbicacion);
  }
  function borrarMovimientosUbicacion(curUbicacionArt: FLSqlCursor)
  {
    return this.ctx.sgaBarcode_borrarMovimientosUbicacion(curUbicacionArt);
  }
}
//// SGA_BARCODE ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pubSgaBarcode */
/////////////////////////////////////////////////////////////////
//// PUB SGA BARCODE ///////////////////////////////////////////
class pubSgaBarcode extends pubSga
{
  function pubSgaBarcode(context)
  {
    pubSga(context);
  }
  function pub_buscarArticulo(codBarras: String): Array {
    return this.buscarArticulo(codBarras);
  }
  function pub_crearUbicacion(referencia: String, barcode: String): String {
    return this.crearUbicacion(referencia, barcode);
  }
}
//// PUB SGA BARCODE ////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition sgaBarcode */
/////////////////////////////////////////////////////////////////
//// SGA_BARCODE ///////////////////////////////////////////////
function sgaBarcode_buscarArticulo(codBarras: String): Array {
  var util: FLUtil = new FLUtil();
  var q: FLSqlQuery = new FLSqlQuery();
  var valores: Array = [];

  valores["error"] = false;
  valores["encontrado"] = false;
  valores["referencia"] = "";
  valores["barcode"] = "";
  valores["talla"] = "";
  valores["color"] = "";
  valores["canenvase"] = 1;

  if (!codBarras || codBarras == "")
    return valores;

  var descripcion: String;
  if (valores["encontrado"] != true)
  {
    q.setTablesList("atributosarticulos,articulos");
    q.setSelect("at.barcode, at.referencia, at.talla, at.color, a.descripcion");
    q.setFrom("atributosarticulos at INNER JOIN articulos a ON at.referencia = a.referencia");
    q.setWhere("at.barcode = '" + codBarras + "'");
    if (!q.exec()) {
      valores["error"] = true;
      return valores;
    }
    if (!q.first()) {
      var qryEnvase: FLSqlQuery = new FLSqlQuery();
      qryEnvase.setTablesList("envasesbarcode,atributosarticulos");
      qryEnvase.setSelect("e.referencia, e.cantidad, e.barcode, a.talla, a.color, e.codbarras");
      qryEnvase.setFrom("envasesbarcode e INNER JOIN atributosarticulos a ON e.barcode = a.barcode");
      qryEnvase.setWhere("e.codbarras = '" + codBarras + "'");
      if (!qryEnvase.exec()) {
        valores["error"] = true;
        return valores;
      }
      if (!qryEnvase.first()) {
        valores = this.iface.__buscarArticulo(codBarras);
        valores["barcode"] = "";
        valores["talla"] = "";
        valores["color"] = "";
        return valores;
      } else {
        descripcion = util.sqlSelect("articulos", "descripcion", "referencia = '" + qryEnvase.value("e.referencia") + "'");
        valores["referencia"] = qryEnvase.value("e.referencia");
        valores["canenvase"] = qryEnvase.value("e.cantidad");
        valores["descripcion"] = descripcion;
        valores["barcode"] = qryEnvase.value("e.barcode");
        valores["talla"] = qryEnvase.value("a.talla");
        valores["color"] = qryEnvase.value("a.color");
        valores["encontrado"] = true;
      }
    } else {
      valores["barcode"] = q.value("at.barcode");
      valores["referencia"] = q.value("at.referencia");
      valores["talla"] = q.value("at.talla");
      valores["color"] = q.value("at.color");
      valores["descripcion"] = q.value("a.descripcion");;
      valores["canenvase"] = "1";
      valores["encontrado"] = true;
    }
  }
  return valores;
}

function sgaBarcode_buscarArticuloManual(): String {
  var f: Object = new FLFormSearchDB("atributosarticulos");
  var curArticulos: FLSqlCursor = f.cursor();
  var util: FLUtil = new FLUtil();

  f.setMainWidget();
  var codBarras: String = f.exec("barcode");
  if (!codBarras)
  {
    MessageBox.information(util.translate("scripts", "El artículo elegido no tiene barcode asignado"), MessageBox.Ok, MessageBox.NoButton);
  }
  return codBarras;
}

function sgaBarcode_crearUbicacion(referencia: String, barcode: String): String {
  var util: FLUtil = new FLUtil;
  var f: Object = new FLFormSearchDB("crearubicacion");
  var curUbicacion: FLSqlCursor = f.cursor();

  var ref: String;
  if (referencia)
  {
    ref = referencia;
  } else {
    ref = util.sqlSelect("atributosarticulos", "referencia", "barcode = '" + barcode + "'");
  }

  var talla: String = util.sqlSelect("atributosarticulos", "talla", "barcode = '" + barcode + "'");
  var color: String = util.sqlSelect("atributosarticulos", "color", "barcode = '" + barcode + "'");
  curUbicacion.setModeAccess(curUbicacion.Insert);
  curUbicacion.refresh();
  curUbicacion.setValueBuffer("referencia", ref);
  curUbicacion.setValueBuffer("barcode", barcode);
  curUbicacion.setValueBuffer("talla", talla);
  curUbicacion.setValueBuffer("color", color);

  f.setMainWidget();
  var codUbicacion: String = f.exec("codubicacion");
  if (curUbicacion.valueBuffer("codubicacion") == "")
    return false;

  if (!curUbicacion.commitBuffer())
    return false;

  var idUbicacion: String = curUbicacion.valueBuffer("id");
  if (!idUbicacion)
    return false;

  return idUbicacion;
}

function sgaBarcode_beforeCommit_ubicacionesarticulo(curUbicacionArt: FLSqlCursor): Boolean {
  var util: FLUtil = new FLUtil();
  if (curUbicacionArt.modeAccess() == curUbicacionArt.Del)
  {
    if (parseFloat(curUbicacionArt.valueBuffer("cantidadactual")) != 0) {
      MessageBox.warning(util.translate("scripts", "No se puede borrar la ubicación.\nLa cantidad actual es distinta de 0"), MessageBox.Ok, MessageBox.NoButton);
      return false;
    }
    this.iface.borrarMovimientosUbicacion(curUbicacionArt);
  }
}

function sgaBarcode_borrarMovimientosUbicacion(curUbicacionArt: FLSqlCursor)
{
  var util: FLUtil = new FLUtil();
  if (!util.sqlDelete("movimat", "idubiarticulo = " + curUbicacionArt.valueBuffer("id"))) {
    return false;
  }
}

//// SGA_BARCODE ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
