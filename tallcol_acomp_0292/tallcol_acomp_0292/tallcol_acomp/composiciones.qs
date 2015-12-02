
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
  function pbnGenerarComposicion_clicked()
  {
    return this.ctx.barcode_pbnGenerarComposicion_clicked();
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

function barcode_pbnGenerarComposicion_clicked()
{
  var cursor = this.cursor();
  var barcode = cursor.valueBuffer("barcode");
  if (!barcode || barcode == "") {
    return this.iface.__pbnGenerarComposicion_clicked();
  }

  var util = new FLUtil;
  if (!this.iface.borrarLineas()) {
    return false;
  }
  var talla = cursor.valueBuffer("talla");
  var color = cursor.valueBuffer("color");
  var qryComp = new FLSqlQuery;
  qryComp.setTablesList("articuloscomp,articulos,atributosarticulos");
  qryComp.setSelect("ac.refcomponente, ac.cantidad, a.descripcion, aa.barcode, aa.talla, aa.color");
  qryComp.setFrom("articuloscomp ac INNER JOIN articulos a ON ac.refcomponente = a.referencia LEFT OUTER JOIN atributosarticulos aa ON (aa.referencia = ac.refcomponente AND aa.talla = '" + talla + "' AND aa.color = '" + color + "')");
  qryComp.setWhere("ac.refcompuesto = '" + cursor.valueBuffer("referencia") + "'");
  qryComp.setForwardOnly(true);
  if (!qryComp.exec()) {
    return false;
  }
  var curLineas = this.child("tdbLineasComposicion").cursor();
  var cantidad = cursor.valueBuffer("cantidad");
  cantidad = isNaN(cantidad) ? 0 : cantidad;
  var canComponente, barcodeComp, refComp, desComp;
  while (qryComp.next()) {
    refComp = qryComp.value("ac.refcomponente");
    barcodeComp = qryComp.value("aa.barcode");
    desComp = qryComp.value("a.descripcion");
    if (!barcodeComp) {
      if (util.sqlSelect("atributosarticulos", "barcode", "referencia = '" + refComp + "'")) {
        var res = MessageBox.warning(util.translate("scripts", "La combinación %1 x %2 no existe para el artículo %3 (%4).\n¿Continuar?").arg(talla).arg(color).arg(refComp).arg(desComp), MessageBox.Yes, MessageBox.No);
        if (res == MessageBox.Yes) {
          continue;
        } else {
          break;
        }
      }
    }
    curLineas.setModeAccess(curLineas.Insert);
    curLineas.refreshBuffer();
    curLineas.setValueBuffer("idcomposicion", cursor.valueBuffer("idcomposicion"));
    curLineas.setValueBuffer("referencia", refComp);
    if (barcodeComp) {
      curLineas.setValueBuffer("barcode", barcodeComp);
      curLineas.setValueBuffer("talla", qryComp.value("aa.talla"));
      curLineas.setValueBuffer("color", qryComp.value("aa.color"));
    }
    curLineas.setValueBuffer("descripcion", desComp);
    canComponente = cantidad * qryComp.value("ac.cantidad");
    canComponente = util.roundFieldValue(canComponente, "articuloscomp", "cantidad");
    curLineas.setValueBuffer("cantidad", canComponente);
    curLineas.setValueBuffer("codalmacen", cursor.valueBuffer("codalmacen"));
    if (!curLineas.commitBuffer()) {
      return false;
    }
  }
}
//// TALLAS Y COLORES COMPUESTOS ////////////////////////////////
/////////////////////////////////////////////////////////////////

