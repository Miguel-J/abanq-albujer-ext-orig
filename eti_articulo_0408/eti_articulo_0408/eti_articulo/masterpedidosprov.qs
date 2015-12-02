
/** @class_declaration etiArticulo */
/////////////////////////////////////////////////////////////////
//// ETIQUETAS DE ARTÍCULOS /////////////////////////////////////
class etiArticulo extends oficial
{
  var tbnEtiquetas: Object;
  function etiArticulo(context)
  {
    oficial(context);
  }
  function init()
  {
    return this.ctx.etiArticulo_init();
  }
  function imprimirEtiquetas()
  {
    return this.ctx.etiArticulo_imprimirEtiquetas();
  }
}
//// ETIQUETAS DE ARTÍCULOS /////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition etiArticulo */
/////////////////////////////////////////////////////////////////
//// ETIQUETAS POR ARTÍCULO /////////////////////////////////////
function etiArticulo_init()
{
  this.iface.__init();
  this.iface.tbnEtiquetas = this.child("tbnEtiquetas");

  connect(this.iface.tbnEtiquetas, "clicked()", this, "iface.imprimirEtiquetas");
}

/** \D Imprime las etiquetas correspondientes a todas las líneas del albarán seleccionado
\end */
function etiArticulo_imprimirEtiquetas()
{
  var _i = this.iface;
  var cursor = this.cursor();
  var idPedido = cursor.valueBuffer("idpedido");
  if (!idPedido) {
    return false;
  }

  var qryLineas: FLSqlQuery = new FLSqlQuery();
  with(qryLineas) {
    setTablesList("lineaspedidosprov,articulos");
    setSelect("lp.referencia, lp.cantidad, lp.descripcion, a.codbarras, a.pvp");
    setFrom("lineaspedidosprov lp LEFT OUTER JOIN articulos a ON lp.referencia = a.referencia");
    setWhere("idpedido = " + idPedido + " ORDER BY lp.referencia");
    setForwardOnly(true);
  }
  if (!qryLineas.exec()) {
    return false;
  }

  var xmlKD: FLDomDocument = new FLDomDocument;
  xmlKD.setContent("<!DOCTYPE KUGAR_DATA><KugarData/>");
  var eRow: FLDomElement;
  var cantidad: Number;
  while (qryLineas.next()) {
    cantidad = parseInt(qryLineas.value("lp.cantidad"));
    for (var i: Number = 0; i < cantidad; i++) {
      eRow = xmlKD.createElement("Row");
      eRow.setAttribute("barcode", qryLineas.value("a.codbarras"));
      eRow.setAttribute("referencia", qryLineas.value("lp.referencia"));
      eRow.setAttribute("descripcion", qryLineas.value("lp.descripcion"));
      eRow.setAttribute("pvp", qryLineas.value("a.pvp"));
      eRow.setAttribute("level", 0);
      xmlKD.firstChild().appendChild(eRow);
    }
  }

  if (!flfactalma.iface.pub_lanzarEtiArticulo(xmlKD)) {
    return false;
  }
}
//// ETIQUETAS POR ARTÍCULO /////////////////////////////////////
/////////////////////////////////////////////////////////////////
