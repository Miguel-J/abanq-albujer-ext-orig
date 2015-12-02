
/** @class_declaration sgaBarcode */
/////////////////////////////////////////////////////////////////
//// SGA_BARCODE ///////////////////////////////////////////////
class sgaBarcode extends oficial
{
  function sgaBarcode(context)
  {
    oficial(context);
  }
  function crearSalidaCesta(curLineaPP: FLSqlCursor, cantidad: Number): Boolean {
    return this.ctx.sgaBarcode_crearSalidaCesta(curLineaPP, cantidad);
  }
}
//// SGA_BARCODE ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition sgaBarcode */
/////////////////////////////////////////////////////////////////
//// SGA_BARCODE ///////////////////////////////////////////////
function sgaBarcode_crearSalidaCesta(curLineaPP: FLSqlCursor, cantidad: Number): Boolean {
  var curMoviMat: FLSqlCursor = new FLSqlCursor("movimat");

  var hoy: Date = new Date;
  var idUsuario: String = sys.nameUser();

  curMoviMat.setModeAccess(curMoviMat.Insert);
  curMoviMat.refreshBuffer();
  curMoviMat.setValueBuffer("fecha", hoy);
  curMoviMat.setValueBuffer("hora", hoy.toString().right(8));
  curMoviMat.setValueBuffer("idubiarticulo", curLineaPP.valueBuffer("idcestaubicacion"));
  curMoviMat.setValueBuffer("codubicacion", curLineaPP.valueBuffer("codcestaubicacion"));
  curMoviMat.setValueBuffer("tipo", "Salida");
  curMoviMat.setValueBuffer("cantidad", cantidad * -1);
  curMoviMat.setValueBuffer("usuario", idUsuario);
  curMoviMat.setValueBuffer("referencia", curLineaPP.valueBuffer("referencia"));
  curMoviMat.setValueBuffer("barcode", curLineaPP.valueBuffer("barcode"));
  curMoviMat.setValueBuffer("talla", curLineaPP.valueBuffer("talla"));
  curMoviMat.setValueBuffer("color", curLineaPP.valueBuffer("color"));

  if (!curMoviMat.commitBuffer())
    return false;

  return true;
}

//// SGA_BARCODE ///////////////////////////////////////////////
////////////////////////////////////////////////////////////////
