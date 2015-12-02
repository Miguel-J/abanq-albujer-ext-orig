
/** @class_declaration barcode */
/////////////////////////////////////////////////////////////////
//// TALLAS Y COLORES COMPUESTOS ////////////////////////////////
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
  function controlesBarcode()
  {
    return this.ctx.barcode_controlesBarcode();
  }
  function bufferChanged(fN)
  {
    return this.ctx.barcode_bufferChanged(fN);
  }
  function calculateField(fN)
  {
    return this.ctx.barcode_calculateField(fN);
  }
}
//// TALLAS Y COLORES COMPUESTOS ////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition barcode */
/////////////////////////////////////////////////////////////////
//// TALLAS Y COLORES COMPUESTOS ////////////////////////////////
function barcode_init()
{
  this.iface.__init();
  this.iface.controlesBarcode();
}

function barcode_controlesBarcode()
{
  var cursor = this.cursor();
  if (cursor.valueBuffer("referencia") == "" || cursor.isNull("referencia")) {
    this.child("fdbBarCode").setFilter("");
  } else {
    this.child("fdbBarCode").setFilter("referencia = '" + cursor.valueBuffer("referencia") + "'");
  }
}

function barcode_bufferChanged(fN)
{
  var util = new FLUtil;
  var cursor = this.cursor();
  switch (fN) {
    case "barcode": {
      this.child("fdbReferencia").setValue(this.iface.calculateField("referencia"));
      break;
    }
    case "referencia": {
      if (cursor.valueBuffer("referencia") == "" || cursor.isNull("referencia")) {
        this.child("fdbBarCode").setFilter("");
      } else {
        this.child("fdbBarCode").setFilter("referencia = '" + cursor.valueBuffer("referencia") + "'");
      }
      this.iface.__bufferChanged(fN);
      break;
    }
    default: {
      this.iface.__bufferChanged(fN);
    }
  }
}

function barcode_calculateField(fN)
{
  var util = new FLUtil;
  var cursor = this.cursor();
  var valor;
  switch (fN) {
    case "referencia": {
      valor = util.sqlSelect("atributosarticulos", "referencia", "barcode = '" + cursor.valueBuffer("barcode") + "'");
      break;
    }
    default: {
      valor = this.iface.__calculateField(fN);
    }
  }

  return valor;
}
