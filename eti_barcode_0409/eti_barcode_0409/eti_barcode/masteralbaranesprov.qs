
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
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();
  var idAlbaran: String = cursor.valueBuffer("idalbaran");
  if (!idAlbaran) {
    return false;
  }

  var qryLineas: FLSqlQuery = new FLSqlQuery();
  with(qryLineas) {
    setTablesList("lineasalbaranesprov,articulos,atributosarticulos");
    setSelect("la.barcode, la.cantidad, a.descripcion, aa.pvp, aa.pvpespecial, a.pvp, aa.talla, aa.color, a.codbarras");
    setFrom("lineasalbaranesprov la LEFT OUTER JOIN atributosarticulos aa ON la.barcode = aa.barcode LEFT OUTER JOIN articulos a ON la.referencia = a.referencia");
    setWhere("idalbaran = " + idAlbaran + " ORDER BY la.barcode");
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
    cantidad = parseInt(qryLineas.value("la.cantidad"));
    descripcion = qryLineas.value("a.descripcion");
    barcode = qryLineas.value("la.barcode");
    if (barcode && barcode != "") {
      referencia = barcode;
    } else {
      referencia = qryLineas.value("la.referencia");
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
