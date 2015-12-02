
/** @class_declaration barCode */
/////////////////////////////////////////////////////////////////
//// TALLAS Y COLORES POR BARCODE ///////////////////////////////
class barCode extends oficial
{
  var curColorArticulo: FLSqlCursor;
  var curAtributoArticulo: FLSqlCursor;
  var curAtributoTarifa: FLSqlCursor;
  var curBarcodeProv: FLSqlCursor;
  function barCode(context)
  {
    oficial(context);
  }
  function copiarAnexosArticulo(refOriginal: String, refNueva: String): Boolean {
    return this.ctx.barCode_copiarAnexosArticulo(refOriginal, refNueva);
  }
  function copiarTablaAtributosArticulos(refOriginal: String, refNueva: String): Boolean {
    return this.ctx.barCode_copiarTablaAtributosArticulos(refOriginal, refNueva);
  }
  function datosAtributoArticulo(cursor: FLSqlCursor, campo: String): Boolean {
    return this.ctx.barCode_datosAtributoArticulo(cursor, campo);
  }
  function copiarTablaColoresArticulo(refOriginal: String, refNueva: String): Boolean {
    return this.ctx.barCode_copiarTablaColoresArticulo(refOriginal, refNueva);
  }
  function datosColorArticulo(cursor: FLSqlCursor, campo: String): Boolean {
    return this.ctx.barCode_datosColorArticulo(cursor, campo);
  }
  function copiarTablaAtributosTarifas(barcodeOrigen: String, nuevoBarcode: String): Boolean {
    return this.ctx.barCode_copiarTablaAtributosTarifas(barcodeOrigen, nuevoBarcode);
  }
  function datosAtributoTarifa(cursor: FLSqlCursor, campo: String): Boolean {
    return this.ctx.barCode_datosAtributoTarifa(cursor, campo);
  }
  function copiarTablaBarcodeProv(barcodeOrigen: String, nuevoBarcode: String): Boolean {
    return this.ctx.barCode_copiarTablaBarcodeProv(barcodeOrigen, nuevoBarcode);
  }
  function datosBarcodeProv(cursor: FLSqlCursor, campo: String): Boolean {
    return this.ctx.barCode_datosBarcodeProv(cursor, campo);
  }
}
//// TALLAS Y COLORES POR BARCODE ///////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition barCode */
/////////////////////////////////////////////////////////////////
//// TALLAS Y COLORES POR BARCODE ///////////////////////////////
function barCode_copiarAnexosArticulo(refOriginal: String, refNueva: String): Boolean {
  if (!this.iface.__copiarAnexosArticulo(refOriginal, refNueva))
  {
    return false;
  }
  if (!this.iface.copiarTablaAtributosArticulos(refOriginal, refNueva))
  {
    return false;
  }
  if (!this.iface.copiarTablaColoresArticulo(refOriginal, refNueva))
  {
    return false;
  }
  return true;
}

function barCode_copiarTablaAtributosArticulos(refOriginal: String, refNueva: String): Boolean {
  var util: FLUtil;

  if (!this.iface.curAtributoArticulo)
  {
    this.iface.curAtributoArticulo = new FLSqlCursor("atributosarticulos");
  }

  var campos: Array = util.nombreCampos("atributosarticulos");
  var totalCampos: Number = campos[0];

  var curAtributoArticuloOrigen: FLSqlCursor = new FLSqlCursor("atributosarticulos");
  curAtributoArticuloOrigen.select("referencia = '" + refOriginal + "'");
  var barcodeOrigen: String;

  formRecordarticulos.iface.calculoBarcode_ = flfactalma.iface.pub_valorDefectoAlmacen("calculobarcode");
  formRecordarticulos.iface.digitosBarcode_ = flfactalma.iface.pub_valorDefectoAlmacen("digitosbarcode");
  formRecordarticulos.iface.prefijoBarcode_ = flfactalma.iface.pub_valorDefectoAlmacen("prefijobarcode");

  while (curAtributoArticuloOrigen.next())
  {
    curAtributoArticuloOrigen.setModeAccess(curAtributoArticuloOrigen.Browse);
    curAtributoArticuloOrigen.refreshBuffer();

    this.iface.curAtributoArticulo.setModeAccess(this.iface.curAtributoArticulo.Insert);
    this.iface.curAtributoArticulo.refreshBuffer();
    this.iface.curAtributoArticulo.setValueBuffer("referencia", refNueva);

    var barcode: String = formRecordarticulos.iface.obtenerBarcode(refNueva, curAtributoArticuloOrigen.valueBuffer("talla"), curAtributoArticuloOrigen.valueBuffer("color"));
    if (!barcode) {
      return false;
    }
    this.iface.curAtributoArticulo.setValueBuffer("barcode", barcode);

    for (var i: Number = 1; i <= totalCampos; i++) {
      if (!this.iface.datosAtributoArticulo(curAtributoArticuloOrigen, campos[i])) {
        return false;
      }
    }

    if (!this.iface.curAtributoArticulo.commitBuffer()) {
      return false;
    }
    barcodeOrigen = curAtributoArticuloOrigen.valueBuffer("barcode");
    if (!this.iface.copiarTablaAtributosTarifas(barcodeOrigen, barcode)) {
      return false;
    }

    if (!this.iface.copiarTablaBarcodeProv(barcodeOrigen, barcode)) {
      return false;
    }
  }

  return true;
}

function barCode_datosAtributoArticulo(cursorOrigen: FLSqlCursor, campo: String): Boolean {
  if (!campo || campo == "")
  {
    return false;
  }

  switch (campo)
  {
    case "id":
    case "barcode":
    case "referencia": {
      return true;
      break;
    }
    default: {
      if (cursorOrigen.isNull(campo)) {
        this.iface.curAtributoArticulo.setNull(campo);
      } else {
        this.iface.curAtributoArticulo.setValueBuffer(campo, cursorOrigen.valueBuffer(campo));
      }
    }
  }
  return true;
}

function barCode_copiarTablaColoresArticulo(refOriginal: String, refNueva: String): Boolean {
  var util: FLUtil;

  if (!this.iface.curColorArticulo)
  {
    this.iface.curColorArticulo = new FLSqlCursor("coloresarticulo");
  }

  var campos: Array = util.nombreCampos("coloresarticulo");
  var totalCampos: Number = campos[0];

  var curColorArticuloOrigen: FLSqlCursor = new FLSqlCursor("coloresarticulo");
  curColorArticuloOrigen.select("referencia = '" + refOriginal + "'");
  while (curColorArticuloOrigen.next())
  {
    this.iface.curColorArticulo.setModeAccess(this.iface.curColorArticulo.Insert);
    this.iface.curColorArticulo.refreshBuffer();
    this.iface.curColorArticulo.setValueBuffer("referencia", refNueva);

    for (var i: Number = 1; i <= totalCampos; i++) {
      if (!this.iface.datosColorArticulo(curColorArticuloOrigen, campos[i])) {
        return false;
      }
    }

    if (!this.iface.curColorArticulo.commitBuffer())
      return false;
  }
  return true;
}

function barCode_datosColorArticulo(cursorOrigen: FLSqlCursor, campo: String): Boolean {
  if (!campo || campo == "")
  {
    return false;
  }
  switch (campo)
  {
    case "id":
    case "referencia": {
      return true;
      break;
    }
    default: {
      if (cursorOrigen.isNull(campo)) {
        this.iface.curColorArticulo.setNull(campo);
      } else {
        this.iface.curColorArticulo.setValueBuffer(campo, cursorOrigen.valueBuffer(campo));
      }
    }
  }

  return true;
}

function barCode_copiarTablaAtributosTarifas(barcodeOrigen: String, nuevoBarcode: String): Boolean {
  var util: FLUtil;

  if (!this.iface.curAtributoTarifa)
  {
    this.iface.curAtributoTarifa = new FLSqlCursor("atributostarifas");
  }

  var campos: Array = util.nombreCampos("atributostarifas");
  var totalCampos: Number = campos[0];

  var curAtributoTarifaOrigen: FLSqlCursor = new FLSqlCursor("atributostarifas");
  curAtributoTarifaOrigen.select("barcode = '" + barcodeOrigen + "'");
  while (curAtributoTarifaOrigen.next())
  {
    this.iface.curAtributoTarifa.setModeAccess(this.iface.curAtributoTarifa.Insert);
    this.iface.curAtributoTarifa.refreshBuffer();
    this.iface.curAtributoTarifa.setValueBuffer("barcode", nuevoBarcode);

    for (var i: Number = 1; i <= totalCampos; i++) {
      if (!this.iface.datosAtributoTarifa(curAtributoTarifaOrigen, campos[i])) {
        return false;
      }
    }

    if (!this.iface.curAtributoTarifa.commitBuffer()) {
      return false;
    }
  }
  return true;
}

function barCode_datosAtributoTarifa(cursorOrigen: FLSqlCursor, campo: String): Boolean {
  if (!campo || campo == "")
  {
    return false;
  }
  switch (campo)
  {
    case "id":
    case "barcode": {
      return true;
      break;
    }
    default: {
      if (cursorOrigen.isNull(campo)) {
        this.iface.curAtributoTarifa.setNull(campo);
      } else {
        this.iface.curAtributoTarifa.setValueBuffer(campo, cursorOrigen.valueBuffer(campo));
      }
    }
  }

  return true;
}

function barCode_copiarTablaBarcodeProv(barcodeOrigen: String, nuevoBarcode: String): Boolean {
  var util: FLUtil;

  if (!this.iface.curBarcodeProv)
  {
    this.iface.curBarcodeProv = new FLSqlCursor("barcodeprov");
  }

  var campos: Array = util.nombreCampos("barcodeprov");
  var totalCampos: Number = campos[0];

  var curBarcodeProvOrigen: FLSqlCursor = new FLSqlCursor("barcodeprov");
  curBarcodeProvOrigen.select("barcode = '" + barcodeOrigen + "'");
  while (curBarcodeProvOrigen.next())
  {
    this.iface.curBarcodeProv.setModeAccess(this.iface.curBarcodeProv.Insert);
    this.iface.curBarcodeProv.refreshBuffer();
    this.iface.curBarcodeProv.setValueBuffer("barcode", nuevoBarcode);

    for (var i: Number = 1; i <= totalCampos; i++) {
      if (!this.iface.datosBarcodeProv(curBarcodeProvOrigen, campos[i])) {
        return false;
      }
    }

    if (!this.iface.curBarcodeProv.commitBuffer()) {
      return false;
    }
  }

  return true;
}

function barCode_datosBarcodeProv(cursorOrigen: FLSqlCursor, campo: String): Boolean {
  if (!campo || campo == "")
  {
    return false;
  }
  switch (campo)
  {
    case "id":
    case "barcode": {
      return true;
      break;
    }
    default: {
      if (cursorOrigen.isNull(campo)) {
        this.iface.curBarcodeProv.setNull(campo);
      } else {
        this.iface.curBarcodeProv.setValueBuffer(campo, cursorOrigen.valueBuffer(campo));
      }
    }
  }

  return true;
}
//// TALLAS Y COLORES POR BARCODE ///////////////////////////////
/////////////////////////////////////////////////////////////////
