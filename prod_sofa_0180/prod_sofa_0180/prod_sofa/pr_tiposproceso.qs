
/** @class_declaration prodSofa */
/////////////////////////////////////////////////////////////////
//// PRODSOFA ///////////////////////////////////////////////////
class prodSofa extends prod
{
  function prodSofa(context)
  {
    prod(context);
  }
  function bufferChanged(fN: String)
  {
    return this.ctx.prodSofa_bufferChanged(fN);
  }
}
//// PRODSOFA ///////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition prodSofa */
/////////////////////////////////////////////////////////////////
//// PRODSOFA ///////////////////////////////////////////////////
function prodSofa_bufferChanged(fN: String)
{
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();
  switch (fN) {
      //    case "corte":
      //    case "fabricacion": {
      //      if (cursor.valueBuffer("fabricacion")) {
      //        this.child("fdbTipoObjeto").setValue("lotesstock");
      //        this.child("fdbCorte").setDisabled(false);
      //        if (cursor.valueBuffer("corte"))
      //          this.child("fdbTipoObjeto").setValue("pr_ordenesproduccion");
      //        this.child("fdbTipoObjeto").setDisabled(true);
      //      } else {
      //        if (cursor.valueBuffer("corte")) {
      //          cursor.setValueBuffer("corte",false)
      //          this.child("fdbCorte").setDisabled(true);
      //        }
      //        this.child("fdbTipoObjeto").setValue("");
      //        this.child("fdbTipoObjeto").setDisabled(false);
      //      }
      //    }
    default:
      return this.iface.__bufferChanged(fN);
  }
}
//// PRODSOFA ///////////////////////////////////////////////////
////////////////////////////////////////////////////////////////
