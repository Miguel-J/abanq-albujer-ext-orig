
/** @class_declaration etiBarcode */
/////////////////////////////////////////////////////////////////
//// ETIQUETAS DE BARCODES //////////////////////////////////////
class etiBarcode extends etiArticulo
{
  function etiBarcode(context)
  {
    etiArticulo(context);
  }
  function imprimirEtiquetas()
  {
    return this.ctx.etiBarcode_imprimirEtiquetas();
  }
}
//// ETIQUETAS DE BARCODES //////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition etiBarcode */
/////////////////////////////////////////////////////////////////2
//// ETIQUETAS POR BARCODE //////////////////////////////////////
/** \D Imprime las etiquetas correspondientes a todas las líneas del albarán seleccionado
\end */
function etiBarcode_imprimirEtiquetas()
{
  var _i = this.iface;
  var cursor = this.cursor();
  var idPedido = cursor.valueBuffer("idpedido");
  if (!idPedido) {
    return false;
  }

  var qryLineas: FLSqlQuery = new FLSqlQuery();
  with(qryLineas) {
    setTablesList("lineaspedidosprov,articulos,atributosarticulos");
    setSelect("lp.barcode, lp.cantidad, a.descripcion, aa.pvp, aa.pvpespecial, a.pvp, aa.talla, aa.color, a.codbarras");
    setFrom("lineaspedidosprov lp LEFT OUTER JOIN atributosarticulos aa ON lp.barcode = aa.barcode LEFT OUTER JOIN articulos a ON lp.referencia = a.referencia");
    setWhere("idpedido = " + idPedido + " ORDER BY lp.barcode");
    setForwardOnly(true);
  }
  if (!qryLineas.exec()) {
    return false;
  }

  var xmlKD: FLDomDocument = new FLDomDocument;
  xmlKD.setContent("<!DOCTYPE KUGAR_DATA><KugarData/>");
  var eRow: FLDomElement;
  var cantidad: Number;
  var descripcion: String = "";
  var talla: String;
  var color: String;
  var referencia: String, barcode: String;
  while (qryLineas.next()) {
    cantidad = parseInt(qryLineas.value("lp.cantidad"));
    descripcion = qryLineas.value("a.descripcion");
    barcode = qryLineas.value("lp.barcode");
    if (barcode && barcode != "") {
      referencia = barcode;
    } else {
      referencia = qryLineas.value("lp.referencia");
      barcode = qryLineas.value("a.codbarras");
    }
    talla = qryLineas.value("aa.talla");
    if (talla && talla != "") {
      descripcion += ", " + talla;
    }
    color = qryLineas.value("aa.color");
    if (color && color != "") {
      descripcion += ", " + color;
    }

    for (var i: Number = 0; i < cantidad; i++) {
      eRow = xmlKD.createElement("Row");
      eRow.setAttribute("barcode", barcode);
      eRow.setAttribute("referencia", referencia);
      eRow.setAttribute("descripcion", descripcion);
      if (qryLineas.value("aa.pvpespecial")) {
        eRow.setAttribute("pvp", qryLineas.value("aa.pvp"));
      } else {
        eRow.setAttribute("pvp", qryLineas.value("a.pvp"));
      }
      eRow.setAttribute("level", 0);
      xmlKD.firstChild().appendChild(eRow);
    }
  }

  if (!flfactalma.iface.pub_lanzarEtiArticulo(xmlKD)) {
    return false;
  }
}
//// ETIQUETAS POR BARCODE //////////////////////////////////////
/////////////////////////////////////////////////////////////////
