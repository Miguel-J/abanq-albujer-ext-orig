
/** @class_declaration packing */
/////////////////////////////////////////////////////////////////
//// PACKING ////////////////////////////////////////////////////
class packing extends oficial
{
  function packing(context)
  {
    oficial(context);
  }
  function controlStockEmbalajes(curEB: FLSqlCursor): Boolean {
    return this.ctx.packing_controlStockEmbalajes(curEB);
  }
}
//// PACKING ////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pubPacking */
/////////////////////////////////////////////////////////////////
//// PUB PACKING ////////////////////////////////////////////////
class pubPacking extends ifaceCtx
{
  function pubPacking(context)
  {
    ifaceCtx(context);
  }
  function pub_controlStockEmbalajes(curEB: FLSqlCursor): Boolean {
    return this.controlStockEmbalajes(curEB);
  }
}
//// PUB PACKING ////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition packing */
/////////////////////////////////////////////////////////////////
//// PACKING ////////////////////////////////////////////////////
/** \C
Actualiza el stock correspondiente al artículo seleccionado en la línea de embalaje
\end */
function packing_controlStockEmbalajes(curEB: FLSqlCursor): Boolean {
  var util: FLUtil = new FLUtil();

  var codAlmacen: String = util.sqlSelect("bultosdespacho bd INNER JOIN despachos d ON bd.iddespacho = d.iddespacho", "d.codalmacen", "bd.idbulto = " + curEB.valueBuffer("idbulto"), "bultosdespacho,despachos");
  if (!codAlmacen || codAlmacen == "")
  {
    return true;
  }

  if (util.sqlSelect("articulos", "nostock", "referencia = '" + curEB.valueBuffer("referencia") + "'"))
  {
    return true;
  }

  if (!this.iface.controlStock(curEB, "cantidad", -1, codAlmacen))
  {
    return false;
  }

  return true;
}

//// PACKING ////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
