
/** @class_declaration tarifasFact */
//////////////////////////////////////////////////////////////////
//// tarifasFact //////////////////////////////////////////////////////
class tarifasFact extends oficial
{
  function tarifasFact(context)
  {
    oficial(context);
  }
  function validarLineasFacturacion(cursor: FLSqlCursor, tablaLineas: String, campoClave: String): Boolean {
    return this.ctx.tarifasFact_validarLineasFacturacion(cursor, tablaLineas, campoClave);
  }
}
//// tarifasFact //////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_definition tarifasFact */
/////////////////////////////////////////////////////////////////
//// tarifasFact /////////////////////////////////////////////////////

/** Verifica que las referencias de las líneas tienen tarifa asociada igual
a la del documento padre
*/

function tarifasFact_validarLineasFacturacion(cursor: FLSqlCursor, tablaLineas: String, campoClave: String): Boolean {
  var codTarifa: String = cursor.valueBuffer("codtarifa");
  if (!codTarifa)
    return true;

  var util: FLUtil = new FLUtil();
  var q: FLSqlQuery = new FLSqlQuery();

  q.setTablesList(tablaLineas);
  q.setSelect("distinct referencia");
  q.setFrom(tablaLineas);
  q.setWhere(campoClave + " = " + cursor.valueBuffer(campoClave) + " and referencia is not null ORDER BY referencia");
  if (!q.exec())
    return false;

  var articulosOT: String = "";
  var referencia: String;

  while (q.next())
  {
    if (!util.sqlSelect("articulostarifas", "referencia", "referencia = '" + q.value(0) +  "' AND codtarifa = '" + codTarifa + "'")) {
      articulosOT += "\n";
      articulosOT += q.value(0);
    }
  }

  if (articulosOT)
  {
    res = MessageBox.warning(util.translate("scripts", "Se detectaron algunos artículos que no corresponden a la tarifa %0:\n%0\n\n¿continuar?").arg(codTarifa).arg(articulosOT), MessageBox.Yes, MessageBox.No, MessageBox.NoButton);
    if (res != MessageBox.Yes)
      return false;
  }

  return true;
}

//// tarifasFact /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
