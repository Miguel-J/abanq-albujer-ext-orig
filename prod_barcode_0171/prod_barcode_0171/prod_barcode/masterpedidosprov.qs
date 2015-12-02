
/** @class_declaration prodBarcode */
/////////////////////////////////////////////////////////////////
//// PRODUCCIÓN BARCODE /////////////////////////////////////////
class prodBarcode extends prod
{
  function prodBarcode(context)
  {
    prod(context);
  }
  function generarArrayLineaRotura(arrayAux: Array): Array {
    return this.ctx.prodBarcode_generarArrayLineaRotura(arrayAux);
  }
  function datosLineaRS(arrayLinea: Array): Boolean {
    return this.ctx.prodBarcode_datosLineaRS(arrayLinea);
  }
}
//// PRODUCCIÓN BARCODE /////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition prodBarcode */
/////////////////////////////////////////////////////////////////
//// PRODUCCIÓN BARCODE /////////////////////////////////////////
function prodBarcode_generarArrayLineaRotura(arrayAux: Array): Array {
  arrayLinea = [];
  arrayLinea["codproveedor"] = arrayAux[1];
  arrayLinea["referencia"] = arrayAux[2];
  arrayLinea["barcode"] = arrayAux[3];
  arrayLinea["fechapedido"] = arrayAux[4];
  arrayLinea["fechaentrada"] = arrayAux[5];
  arrayLinea["cantidad"] = arrayAux[6];
  return arrayLinea;
}

function prodBarcode_datosLineaRS(arrayLinea: Array): Boolean {
  var util: FLUtil = new FLUtil;
  var barcode: String = arrayLinea["barcode"];

  this.iface.curLineaRS.setValueBuffer("barcode", barcode);
  if (barcode && barcode != "")
  {
    var talla: String = util.sqlSelect("atributosarticulos", "talla", "barcode = '" + barcode + "'");
    this.iface.curLineaRS.setValueBuffer("talla", talla);
    var color: String = util.sqlSelect("atributosarticulos", "color", "barcode = '" + barcode + "'");
    this.iface.curLineaRS.setValueBuffer("color", color);
  }
  if (!this.iface.__datosLineaRS(arrayLinea))
    return false;

  return true;
}
//// PRODUCCIÓN BARCODE /////////////////////////////////////////
/////////////////////////////////////////////////////////////////
