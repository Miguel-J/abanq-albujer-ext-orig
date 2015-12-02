
/** @class_declaration prodBarcode */
/////////////////////////////////////////////////////////////////
//// PRODUCCIÓN - BARCODE ///////////////////////////////////////
class prodBarcode extends prod
{
  function prodBarcode(context)
  {
    prod(context);
  }
  function crearStock(codAlmacen: String, datosArt: Array): Number {
    return this.ctx.prodBarcode_crearStock(codAlmacen, datosArt);
  }
  function datosArticuloStock(idStock: String): Array {
    return this.ctx.prodBarcode_datosArticuloStock(idStock);
  }
  function datosArticulo(cursor: FLSqlCursor, prefijo: String): Array {
    return this.ctx.prodBarcode_datosArticulo(cursor, prefijo);
  }
  function datosArticuloMS(datosArt: Array): Boolean {
    return this.ctx.prodBarcode_datosArticuloMS(datosArt);
  }
  function albaranaDatosMoviStock(curMSOrigen: FLSqlCursor): Boolean {
    return this.ctx.prodBarcode_albaranaDatosMoviStock(curMSOrigen);
  }
}
//// PRODUCCIÓN - BARCODE ///////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition prodBarcode */
/////////////////////////////////////////////////////////////////
//// PRODUCCIÓN - BARCODE ///////////////////////////////////////
/** \D Crea un registro de stock para el almacén y artículo especificados
@param  codAlmacen: Almacén
@param  datosArt: Array con los datos del artículo
@return identificador del stock o false si hay error
\end */
function prodBarcode_crearStock(codAlmacen: String, datosArt: Array): Number {
  var util: FLUtil = new FLUtil;
  var curStock: FLSqlCursor = new FLSqlCursor("stocks");
  with(curStock)
  {
    setModeAccess(Insert);
    refreshBuffer();
    setValueBuffer("codalmacen", codAlmacen);
    setValueBuffer("referencia", datosArt["referencia"]);
    if (datosArt["barcode"])
      setValueBuffer("barcode", datosArt["barcode"]);
    else
      setNull("barcode");
    setValueBuffer("nombre", util.sqlSelect("almacenes", "nombre", "codalmacen = '" + codAlmacen + "'"));
    setValueBuffer("cantidad", 0);
    setValueBuffer("reservada", 0)
    setValueBuffer("pterecibir", 0)
    if (!commitBuffer())
      return false;
  }
  return curStock.valueBuffer("idstock");
}

function prodBarcode_datosArticuloStock(idStock: String): Array {
  var util: FLUtil = new FLUtil;
  var res: Array = this.iface.__datosArticuloStock(idStock);
  res["barcode"] = util.sqlSelect("stocks", "barcode", "idstock = " + idStock);
  res["nombre"] = util.translate("scripts", "Artículo: %1 - %2 - Barcode: %3").arg(res["referencia"]).arg(res["descripcion"]).arg(res["barcode"]);
  return res;
}

/** \D Función a sobrecargar por extensiones como la de barcodes
@param  cursor: Cursor que contiene los datos que identifican el artículo
@param  prefijo: Prefijo de la tabla (opcional)
@return array con datos identificativos del artículo
\end */
function prodBarcode_datosArticulo(cursor: FLSqlCursor, prefijo: String): Array {
  var res: Array = [];

  if (prefijo && prefijo != "")
    valorWhere = prefijo + ".";

  var campo: String = "referencia";
  if (cursor.table() == "articuloscomp")
    campo = "refcomponente";

  res["referencia"] = cursor.valueBuffer(campo);
  res["barcode"] = cursor.valueBuffer("barcode");

  res["localizador"] = "referencia = '" + cursor.valueBuffer(campo) + "'";
  if (res["barcode"] && res["barcode"] != "")
  {
    res["localizador"] += " AND barcode = '" + res["barcode"] + "'";
  }
  return res;
}

function prodBarcode_datosArticuloMS(datosArt: Array): Boolean {
  if (!this.iface.__datosArticuloMS(datosArt))
    return false;

  this.iface.curMoviStock.setValueBuffer("barcode", datosArt["barcode"]);
  return true;
}

function prodBarcode_albaranaDatosMoviStock(curMSOrigen: FLSqlCursor): Boolean {
  if (!this.iface.__albaranaDatosMoviStock(curMSOrigen))
    return false;

  with(this.iface.curMoviStock)
  {
    setValueBuffer("barcode", curMSOrigen.valueBuffer("barcode"));
  }

  return true;
}

//// PRODUCCIÓN - BARCODE ///////////////////////////////////////
////////////////////////////////////////////////////////
