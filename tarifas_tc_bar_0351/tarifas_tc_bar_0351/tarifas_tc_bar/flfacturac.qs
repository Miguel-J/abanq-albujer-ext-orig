
/** @class_declaration tarifasTCB */
//////////////////////////////////////////////////////////////////
//// TARIFAS TCB /////////////////////////////////////////////////
class tarifasTCB extends tarifasFact
{
  function tarifasTCB(context)
  {
    tarifasFact(context);
  }
  function validarLineasFacturacion(cursor: FLSqlCursor, tablaLineas: String, campoClave: String): Boolean {
    return this.ctx.tarifasTCB_validarLineasFacturacion(cursor, tablaLineas, campoClave);
  }
}
//// TARIFAS TCB /////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_definition tarifasTCB */
/////////////////////////////////////////////////////////////////
//// TARIFAS TCB /////////////////////////////////////////////////////

function tarifasTCB_validarLineasFacturacion(cursor: FLSqlCursor, tablaLineas: String, campoClave: String): Boolean {
  var codTarifa: String = cursor.valueBuffer("codtarifa");
  if (!codTarifa)
    return true;

  var util: FLUtil = new FLUtil();
  var q: FLSqlQuery = new FLSqlQuery();

  q.setTablesList(tablaLineas);
  q.setSelect("distinct referencia,barcode");
  q.setFrom(tablaLineas);
  q.setWhere(campoClave + " = " + cursor.valueBuffer(campoClave) + " and referencia is not null and referencia <> '' ORDER BY referencia, barcode");
  if (!q.exec())
    return false;

  var articulosOT: String = "";
  var barcodesOT: String = "";

  while (q.next())
  {

    // 1. barcode?
    if (q.value(1)) {
      if (!util.sqlSelect("atributostarifas", "barcode", "barcode = '" + q.value(1) +  "' AND codtarifa = '" + codTarifa + "'")) {
        barcodesOT += "\n   ";
        barcodesOT += q.value(1);
      }
      continue;
    }

    // 2. referencia?
    if (!util.sqlSelect("articulostarifas", "referencia", "referencia = '" + q.value(0) +  "' AND codtarifa = '" + codTarifa + "'")) {
      articulosOT += "\n   ";
      articulosOT += q.value(0);
    }
  }

  if (articulosOT)
    articulosOT = util.translate("scripts", "Se detectaron algunas referencias que no corresponden a la tarifa %0:\n%0\n\n").arg(codTarifa).arg(articulosOT);

  if (barcodesOT)
    barcodesOT = util.translate("scripts", "Se detectaron algunos barcodes que no corresponden a la tarifa %0:\n%0\n\n").arg(codTarifa).arg(barcodesOT);

  if (articulosOT || barcodesOT)
  {
    res = MessageBox.warning(articulosOT + barcodesOT + util.translate("scripts", "¿continuar?"), MessageBox.Yes, MessageBox.No, MessageBox.NoButton);
    if (res != MessageBox.Yes)
      return false;
  }

  return true;
}

//// TARIFAS TCB /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
