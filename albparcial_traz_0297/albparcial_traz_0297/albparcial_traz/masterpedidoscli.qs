
/** @class_declaration parcialLotes */
/////////////////////////////////////////////////////////////////
//// PARCIALLOTES ///////////////////////////////////////////////
class parcialLotes extends lotes
{
  function parcialLotes(context)
  {
    lotes(context);
  }
  function copiaLineaPedidoParcial(curLineaPedido: FLSqlCursor, idAlbaran: Number): Number {
    return this.ctx.parcialLotes_copiaLineaPedidoParcial(curLineaPedido, idAlbaran);
  }
}
//// PARCIALLOTES ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition parcialLotes */
/////////////////////////////////////////////////////////////////
//// PARCIALLOTES ///////////////////////////////////////////////
function parcialLotes_copiaLineaPedidoParcial(curLineaPedido: FLSqlCursor, idAlbaran: Number): Number {
  var util: FLUtil = new FLUtil;

  var idLineaAlbaran: Number = this.iface.__copiaLineaPedidoParcial(curLineaPedido, idAlbaran);
  if (!idLineaAlbaran)
    return false;

  var curMoviLote: FLSqlCursor = new FLSqlCursor("movilote");
  var fecha: Date = util.sqlSelect("albaranescli", "fecha", "idalbaran = " + idAlbaran);
  var codAlmacen: String = util.sqlSelect("albaranescli", "codalmacen", "idalbaran = " + idAlbaran);
  var referencia: String = curLineaPedido.valueBuffer("referencia");
  var idStock: Number = util.sqlSelect("stocks", "idstock", "codalmacen = '" + codAlmacen + "' AND referencia = '" + referencia + "'");
  if (!idStock)
  {
    var oArticulo = new Object();
    oArticulo.referencia = referencia;
    idStock = flfactalma.iface.pub_crearStock(codAlmacen, oArticulo);
    if (!idStock) {
      return false;
    }
  }
  var lotesAlbaran: String = curLineaPedido.valueBuffer("lotesalbaran");
  if (!lotesAlbaran || lotesAlbaran == "")
    return idLineaAlbaran;

  var arrayLotes = lotesAlbaran.split("|");

  for (var i = 0; i < arrayLotes.length; i++)
  {
    if (!util.sqlUpdate("movilote", "idlineaac", idLineaAlbaran, "id = " + arrayLotes[i]))
      return false;
    if (!util.sqlUpdate("movilote", "fecha", fecha, "id = " + arrayLotes[i]))
      return false;
    //    var lote:Array = arrayLotes[i].split("/");
    //
    //    curMoviLote.setModeAccess(curMoviLote.Insert);
    //    curMoviLote.refreshBuffer();
    //    curMoviLote.setValueBuffer("codlote", lote[0]);
    //    curMoviLote.setValueBuffer("fecha", fecha);
    //    curMoviLote.setValueBuffer("tipo", "Salida");
    //    curMoviLote.setValueBuffer("docorigen", "AC");
    //    curMoviLote.setValueBuffer("idlineaac", idLineaAlbaran);
    //    curMoviLote.setValueBuffer("idstock", idStock);
    //    curMoviLote.setValueBuffer("cantidad", lote[1]);
    //
    //    if (lote[1] >= 0) {
    //      var res:Number = MessageBox.warning(util.translate("scripts", "Se va a generar un movimiento con cantidad positiva para un documento de Salida.\n¿Desea continuar?"),MessageBox.Yes, MessageBox.No);
    //      if (res != MessageBox.Yes)
    //        return false;
    //    }
    //
    //    var cantidadLote:Number = util.sqlSelect("movilote", "SUM(cantidad)", "idstock = " + idStock + " AND codlote = '" + lote[0] + "' AND (idlineaac IS NULL OR idlineaac <> " + idLineaAlbaran + ")");
    //      if ((lote[1] * -1) > cantidadLote) {
    //        var resp = MessageBox.warning(util.translate("scripts", "No hay suficiente cantidad de artículos con referencia %1 del lote %2\nen el almacén %3 \n¿Desea continuar generando un stock negativo?").arg(referencia).arg(lote[0]).arg(codAlmacen), MessageBox.Yes, MessageBox.No);
    //        if (resp != MessageBox.Yes)
    //          return false;
    //      }
    //
    //    if(!curMoviLote.commitBuffer())
    //      return false;
  }

  curLineaPedido.setValueBuffer("lotesalbaran", "");

  return idLineaAlbaran;
}

//// PARCIALLOTES ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
