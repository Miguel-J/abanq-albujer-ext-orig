
/** @class_declaration barcode */
/////////////////////////////////////////////////////////////////
//// TALLAS Y COLORES ///////////////////////////////////////////
class barcode extends oficial
{
  function barcode(context)
  {
    oficial(context);
  }
  function init()
  {
    return this.ctx.barcode_init();
  }
  function bufferChanged(fN: String)
  {
    return this.ctx.barcode_bufferChanged(fN);
  }
  function habilitacionesCalculoBarcode()
  {
    return this.ctx.barcode_habilitacionesCalculoBarcode();
  }
  function calculateField(fN: String): String {
    return this.ctx.barcode_calculateField(fN);
  }
}
//// TALLAS Y COLORES ///////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition barcode */
/////////////////////////////////////////////////////////////////
//// TALLAS Y COLORES ///////////////////////////////////////////
function barcode_init()
{
  this.iface.__init();
  this.iface.habilitacionesCalculoBarcode();
}

function barcode_bufferChanged(fN: String)
{
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();
  switch (fN) {
    case "calculobarcode": {
      this.iface.habilitacionesCalculoBarcode();
      this.child("fdbDigitosBarcode").setValue(this.iface.calculateField("digitosbarcode"));
      this.child("fdbPrefijoBarcode").setValue(this.iface.calculateField("prefijobarcode"));
      break;
    }
    default: {
      this.iface.__bufferChanged(fN);
    }
  }
}

function barcode_calculateField(fN: String): String {
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();
  var valor: String;

  switch (fN)
  {
    case "digitosbarcode": {
      switch (cursor.valueBuffer("calculobarcode")) {
        case "Autonumérico": {
          valor = cursor.valueBuffer("digitosbarcode");
          break;
        }
        case "Autonumérico EAN13": {
          valor = 13;
          break;
        }
        case "Autonumérico EAN14": {
          valor = 14;
          break;
        }
        case "Referencia+Talla+Color": {
          valor = "";
          break;
        }
      }
      break;
    }
    case "prefijobarcode": {
      switch (cursor.valueBuffer("calculobarcode")) {
        case "Autonumérico":
        case "Autonumérico EAN13":
        case "Autonumérico EAN14": {
          valor = cursor.valueBuffer("prefijobarcode");
          break;
        }
        case "Referencia+Talla+Color": {
          valor = "";
          break;
        }
      }
      break;
    }
    default: {
      valor = this.iface.__calculateField(fN);
      break;
    }
  }

  return valor;
}


function barcode_habilitacionesCalculoBarcode()
{
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();
  switch (cursor.valueBuffer("calculobarcode")) {
    case "Autonumérico": {
      this.child("fdbDigitosBarcode").setDisabled(false);
      this.child("fdbPrefijoBarcode").setDisabled(false);
      break;
    }
    case "Autonumérico EAN13": {
      this.child("fdbDigitosBarcode").setDisabled(true);
      this.child("fdbPrefijoBarcode").setDisabled(false);
      break;
    }
    case "Referencia+Talla+Color": {
      this.child("fdbDigitosBarcode").setDisabled(true);
      this.child("fdbPrefijoBarcode").setDisabled(true);
      break;
    }
  }
}
//// TALLAS Y COLORES ///////////////////////////////////////////
/////////////////////////////////////////////////////////////////
