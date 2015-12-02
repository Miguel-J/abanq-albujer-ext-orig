
/** @class_declaration compTC */
/////////////////////////////////////////////////////////////////
//// ARTICULOS COMPUESTOS Y POR TALLAS Y COLORES ////////////////
class compTC extends oficial
{
  var bloqueoBarCode_;
  function compTC(context)
  {
    oficial(context);
  }
  function commonCalculateField(fN, cursor)
  {
    return this.ctx.compTC_commonCalculateField(fN, cursor);
  }
  function bufferChanged(fN)
  {
    return this.ctx.compTC_bufferChanged(fN);
  }
}
//// ARTICULOS COMPUESTOS Y POR TALLAS Y COLORES ////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition compTC */
/////////////////////////////////////////////////////////////////
//// ARTICULOS COMPUESTOS Y POR TALLAS Y COLORES ////////////////
function compTC_commonCalculateField(fN, cursor)
{
  var _i = this.iface;
  var valor;
  switch (fN) {
    case "refcomponente": {
      valor = AQUtil.sqlSelect("atributosarticulos", "referencia", "barcode = '" + cursor.valueBuffer("barcode") + "'");
      if (!valor) {
        valor = "";
      }
      break;
    }
    case "barcodeunico": {
      valor = parseFloat(AQUtil.sqlSelect("atributosarticulos", "COUNT(barcode)", "referencia = '" + cursor.valueBuffer("refcomponente") + "'"));
      if (valor == 1) {
        valor = AQUtil.sqlSelect("atributosarticulos", "barcode", "referencia = '" + cursor.valueBuffer("referencia") + "'");
      } else {
        valor = false;
      }
      break
    }
    default: {
      valor = _i.__commonCalculateField(fN, cursor)
    }
  }

          return valor;
}

function compTC_bufferChanged(fN)
{
  var _i = this.iface;
  var cursor = this.cursor();
  switch (fN) {
    case "barcode": {
      if (!_i.bloqueoBarCode_) {
        _i.bloqueoBarCode_ = true;
        if (cursor.valueBuffer("barcode") == "" || cursor.isNull("barcode")) {
          this.child("fdbTalla").setValue("");
          this.child("fdbColor").setValue("");
        } else {
          var ref = _i.commonCalculateField("refcomponente", cursor);
          if (ref && ref != "") {
            this.child("fdbRefComponente").setValue(ref);
          }
        }
        _i.bloqueoBarCode_ = false;
      }
      break;
    }
    case "refcomponente": {
      if (cursor.valueBuffer("refcomponente") == "" || cursor.isNull("refcomponente")) {
        this.child("fdbBarCode").setFilter("");
        this.child("fdbBarCode").setValue("");
        this.child("fdbTalla").setValue("");
        this.child("fdbColor").setValue("");
      } else {
        var referencia = cursor.valueBuffer("refcomponente");
        this.child("fdbBarCode").setFilter("referencia = '" + referencia + "'");

        var barCodeUnico = _i.commonCalculateField("barcodeunico", cursor);
        if (barCodeUnico) {
          sys.setObjText(this, "fdbBarCode", barCodeUnico);
        }
        if (!AQUtil.sqlSelect("atributosarticulos", "referencia", "barcode = '" + cursor.valueBuffer("barcode") + "' AND referencia = '" + referencia + "'")) {
          if (!_i.bloqueoBarCode_) {
            _i.bloqueoBarCode_ = true;
            this.child("fdbBarCode").setValue("");
            this.child("fdbTalla").setValue("");
            this.child("fdbColor").setValue("");
            _i.bloqueoBarCode_ = false;
          }
        }
      }
      _i.__bufferChanged(fN);
      break;
    }
    default: {
    }
  }
}
//// ARTICULOS COMPUESTOS Y POR TALLAS Y COLORES ////////////////
/////////////////////////////////////////////////////////////////
