
/** @class_declaration promoTpv */
/////////////////////////////////////////////////////////////////
//// PROMOCIONES TPV ////////////////////////////////////////////
class promoTpv extends ivaincluido
{
  function promoTpv(context)
  {
    ivaincluido(context);
  }
  function incluirDatosLinea(curLinea, curLineaPadre)
  {
    return this.ctx.promoTpv_incluirDatosLinea(curLinea, curLineaPadre);
  }
}
//// PROMOCIONES TPV ////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition promoTpv */
/////////////////////////////////////////////////////////////////
//// PROMOCIONES TPV ////////////////////////////////////////////
function promoTpv_incluirDatosLinea(curLinea, curLineaPadre)
{
  var _i = this.iface;
  var cursor = this.cursor();

  if (!_i.__incluirDatosLinea(curLinea, curLineaPadre)) {
    return false;
  }

  if (curLineaPadre.valueBuffer("idpromo") && curLineaPadre.valueBuffer("idpromo") != 0 && curLineaPadre.valueBuffer("idpromo") != "") {
    curLinea.setValueBuffer("idpromo", curLineaPadre.valueBuffer("idpromo"));
    curLinea.setValueBuffer("desccortapromo", curLineaPadre.valueBuffer("desccortapromo"));
  }

  return true;
}
//// PROMOCIONES TPV ////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
