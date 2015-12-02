
/** @class_declaration etiBarcode */
/////////////////////////////////////////////////////////////////
//// ETIQUETAS DE BARCODE ///////////////////////////////////////
class etiBarcode extends barCode
{
  function etiBarcode(context)
  {
    barCode(context);
  }
  function init()
  {
    return this.ctx.etiBarcode_init();
  }
  function imprimirEtiquetas()
  {
    return this.ctx.etiBarcode_imprimirEtiquetas();
  }
}
//// ETIQUETAS DE BARCODE ///////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition etiBarcode */
/////////////////////////////////////////////////////////////////
//// ETIQUETAS POR BARCODE //////////////////////////////////////
function etiBarcode_init()
{
  this.iface.__init();

  connect(this.child("tbnEtiquetas"), "clicked()", this, "iface.imprimirEtiquetas");
}

/** \D Imprime las etiquetas correspondientes a todas las líneas del albarán seleccionado
\end */
function etiBarcode_imprimirEtiquetas()
{
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();
  var curBarcode: FLSqlCursor = this.child("tdbAtributosArticulos").cursor();
  var barcode: String = curBarcode.valueBuffer("barcode");
  if (!barcode) {
    return false;
  }

  var cantidad: Number = Input.getNumber(util.translate("scripts", "Nº etiquetas"), 1, 0, 1, 100000, util.translate("scripts", "Imprimir etiquetas"));
  if (!cantidad) {
    return false;
  }

  var descripcion: String = cursor.valueBuffer("descripcion");
  var talla: String = curBarcode.valueBuffer("talla");
  if (talla && talla != "") {
    descripcion += ", " + talla;
  }
  var color: String = curBarcode.valueBuffer("color");
  if (color && color != "") {
    descripcion += ", " + color;
  }

  var xmlKD: FLDomDocument = new FLDomDocument;
  xmlKD.setContent("<!DOCTYPE KUGAR_DATA><KugarData/>");
  var eRow: FLDomElement;
  for (var i: Number = 0; i < cantidad; i++) {
    eRow = xmlKD.createElement("Row");
    eRow.setAttribute("barcode", curBarcode.valueBuffer("barcode"));
    eRow.setAttribute("referencia", curBarcode.valueBuffer("referencia"));
    eRow.setAttribute("descripcion", descripcion);
    if (curBarcode.valueBuffer("pvpespecial")) {
      eRow.setAttribute("pvp", curBarcode.valueBuffer("pvp"));
    } else {
      eRow.setAttribute("pvp", cursor.valueBuffer("pvp"));
    }
    eRow.setAttribute("level", 0);
    xmlKD.firstChild().appendChild(eRow);
  }

  if (!flfactalma.iface.pub_lanzarEtiArticulo(xmlKD)) {
    return false;
  }
}
//// ETIQUETAS POR BARCODE //////////////////////////////////////
/////////////////////////////////////////////////////////////////
