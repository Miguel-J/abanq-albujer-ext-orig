
/** @class_declaration tallcolComp */
/////////////////////////////////////////////////////////////////
//// TALLCOLLACOMP //////////////////////////////////////////////////
class tallcolComp extends articomp
{
  function tallcolComp(context)
  {
    articomp(context);
  }
  function datosArticulo(cursor, codLote, curLinea)
  {
    return this.ctx.tallcolComp_datosArticulo(cursor, codLote, curLinea);
  }
  function datosArticuloMS(aDatosArt)
  {
    return this.ctx.tallcolComp_datosArticuloMS(aDatosArt);
  }
  function albaranaDatosMoviStock(curMSOrigen)
  {
    return this.ctx.tallcolComp_albaranaDatosMoviStock(curMSOrigen);
  }
  function datosStockLineaCambian(curLinea)
  {
    return this.ctx.tallcolComp_datosStockLineaCambian(curLinea);
  }
  function crearStock(codAlmacen, aDatosArt)
  {
    return this.ctx.tallcolComp_crearStock(codAlmacen, aDatosArt);
  }
}
//// TALLCOLLACOMP //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition tallcolComp */
/////////////////////////////////////////////////////////////////
//// TALLCOLACOMP //////////////////////////////////////////////////


/** \D Función a sobrecargar por extensiones como la de barcodes
@param  cursor: Cursor que contiene los datos que identifican el artículo
@param  codLote: Código del lote del artículo
@return array con datos identificativos del artículo
\end */
function tallcolComp_datosArticulo(cursor, codLote, curLinea)
{
  var util: FLUtil = new FLUtil;
  var res: Array = [];
  var referencia: String = "", barcode = "";

  switch (cursor.table()) {
    case "articuloscomp": {
      referencia = cursor.valueBuffer("refcomponente");
      barcode = cursor.valueBuffer("barcode");
      if (curLinea && (!barcode || barcode == "")) {
        var barcodeCompuesto = curLinea.valueBuffer("barcode");
        if (barcodeCompuesto && barcodeCompuesto != "") {
          var talla = curLinea.valueBuffer("talla");
          var color = curLinea.valueBuffer("color");
          barcode = util.sqlSelect("atributosarticulos", "barcode", "referencia = '" + referencia + "' AND talla = '" + talla + "' AND color = '"
                                   + color + "'");
        }
      }

      break;
    }
    default: {
      referencia = cursor.valueBuffer("referencia");
      barcode = cursor.valueBuffer("barcode");
      break;
    }
  }
  if (barcode && barcode != "") {
    res["localizador"] = "barcode = '" + barcode + "'";
  } else {
    res["localizador"] = "referencia = '" + referencia + "'";
  }
  res["referencia"] = referencia;
  res["barcode"] = barcode;

  return res;
}

function tallcolComp_datosArticuloMS(aDatosArt)
{
  this.iface.curMoviStock.setValueBuffer("referencia", aDatosArt["referencia"]);
  this.iface.curMoviStock.setValueBuffer("barcode", aDatosArt["barcode"]);
  return true;
}

function tallcolComp_albaranaDatosMoviStock(curMSOrigen)
{
  this.iface.curMoviStock.setValueBuffer("barcode", curMSOrigen.valueBuffer("barcode"));
  if (!this.iface.__albaranaDatosMoviStock(curMSOrigen)) {
    return false;
  }
  return true;
}

/** \D Indica si los datos de un cursor de línea de facturación han variado con respecto a su stock
@param  curLinea: Cursor con la línea
@return true indica que los datos varían.
\end */
function tallcolComp_datosStockLineaCambian(curLinea)
{
  var cambian = this.iface.__datosStockLineaCambian(curLinea);

  var barcode: String = curLinea.valueBuffer("barcode");
  var barcodeAnterior: String = curLinea.valueBufferCopy("barcode");
  cambian = cambian || (barcode != barcodeAnterior);
  return cambian;
}

function tallcolComp_crearStock(codAlmacen, aDatosArt)
{
  var util: FLUtil = new FLUtil;
  var curStock: FLSqlCursor = new FLSqlCursor("stocks");
  with(curStock) {
    setModeAccess(Insert);
    refreshBuffer();
    setValueBuffer("codalmacen", codAlmacen);
    setValueBuffer("referencia", aDatosArt["referencia"]);
    setValueBuffer("barcode", aDatosArt["barcode"]);
    setValueBuffer("nombre", util.sqlSelect("almacenes", "nombre", "codalmacen = '" + codAlmacen + "'"));
    setValueBuffer("cantidad", 0);
    if (!commitBuffer()) {
      return false;
    }
  }
  return curStock.valueBuffer("idstock");
}


//// TALLCOLACOMP //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
