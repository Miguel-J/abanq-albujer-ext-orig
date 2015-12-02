
/** @class_declaration barcode */
/////////////////////////////////////////////////////////////////
//// BARCODE /////////////////////////////////////////////////
class barcode extends oficial
{
  function barcode(context)
  {
    oficial(context);
  }
  function incluirDatosLinea(curLinea, curLineaPadre)
  {
    return this.ctx.barcode_incluirDatosLinea(curLinea, curLineaPadre);
  }
}
//// BARCODE /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition barcode */
/////////////////////////////////////////////////////////////////
//// BARCODE /////////////////////////////////////////////////
function barcode_incluirDatosLinea(curLinea, curLineaPadre)
{
  var _i = this.iface;
  var cursor = this.cursor();

  if (!_i.__incluirDatosLinea(curLinea, curLineaPadre))
    return false;

  curLinea.setValueBuffer("talla", curLineaPadre.valueBuffer("talla"));
  curLinea.setValueBuffer("color", curLineaPadre.valueBuffer("color"));
  curLinea.setValueBuffer("barcode", curLineaPadre.valueBuffer("barcode"));

  return true;
}
//// BARCODE /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
