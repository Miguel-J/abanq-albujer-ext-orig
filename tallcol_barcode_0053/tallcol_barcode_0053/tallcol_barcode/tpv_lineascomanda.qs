
/** @class_declaration barcode */
//////////////////////////////////////////////////////////////////
//// BARCODE /////////////////////////////////////////////////////
class barcode extends oficial
{
  var bloqueoPrecio: Boolean;
  function barcode(context)
  {
    oficial(context);
  }
  function init()
  {
    return this.ctx.barcode_init();
  }
  function commonCalculateField(fN: String, cursor: FLSqlCursor): String {
    return this.ctx.barcode_commonCalculateField(fN, cursor);
  }
  function bufferChanged(fN: String)
  {
    return this.ctx.barcode_bufferChanged(fN);
  }
}
//// BARCODE /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_definition barcode */
//////////////////////////////////////////////////////////////////
//// BARCODE /////////////////////////////////////////////////////
function barcode_bufferChanged(fN: String)
{
  var util: FLUtil = new FLUtil();
  var cursor: FLSqlCursor = this.cursor();
  return this.iface.__bufferChanged(fN);

  switch (fN) {
    case "referencia": {
      if (cursor.valueBuffer("referencia") == "" || cursor.isNull("referencia")) {
        this.child("fdbBarCode").setFilter("");
      } else {
        this.child("fdbBarCode").setFilter("referencia = '" + cursor.valueBuffer("referencia") + "'");
      }
      this.iface.__bufferChanged(fN);
      break;
    }
    case "barcode": {
      this.child("fdbReferencia").setValue(this.iface.commonCalculateField("referencia", cursor));
      break;
    }
    default: {
      return this.iface.__bufferChanged(fN);
    }
  }
}

function barcode_commonCalculateField(fN, cursor): String {
  var util: FLUtil = new FLUtil();
  var valor: String;
  var referencia: String = cursor.valueBuffer("referencia");

  switch (fN)
  {
    case "referencia": {
      valor = util.sqlSelect("atributosarticulos", "referencia", "barcode = '" + cursor.valueBuffer("barcode") + "'");
      break;
    }
    default: {
      return this.iface.__commonCalculateField(fN, cursor);
    }
  }
  return valor;
}

function barcode_init()
{
  this.iface.__init();

  var cursor: FLSqlCursor = this.cursor();
  if (cursor.valueBuffer("referencia") == "" || cursor.isNull("referencia"))
    this.child("fdbBarCode").setFilter("");
  else
    this.child("fdbBarCode").setFilter("referencia = '" + cursor.valueBuffer("referencia") + "'");
}
//// BARCODE /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
