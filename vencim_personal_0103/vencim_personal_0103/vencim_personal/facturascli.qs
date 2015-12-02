
/** @class_declaration venFacturasCli */
/////////////////////////////////////////////////////////////////
//// VENFACTURASCLI ///////////////////////////////////////////////
class venFacturasCli extends oficial
{
  function venFacturasCli(context)
  {
    oficial(context);
  }
  function validateForm(): Boolean {
    return this.ctx.venFacturasCli_validateForm();
  }
}
//// VENFACTURASCLI ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////


/** @class_definition venFacturasCli */
//////////////////////////////////////////////////////////////////
//// VENFACTURASCLI ////////////////////////////////////////////////

function venFacturasCli_validateForm(): Boolean {
  var cursor: FLSqlCursor = this.cursor();
  var totalAplazado: Number = 0;

  /** \C La suma de los importes aplazados de vencimientos debe ser igual al total de la factura"
  \end */

  if (cursor.modeAccess() == cursor.Insert || cursor.modeAccess() == cursor.Edit)
  {
    var query: FLSqlQuery = new FLSqlQuery();
    query.setTablesList("venfacturascli");
    query.setSelect("SUM(importe)");
    query.setFrom("venfacturascli");
    query.setWhere("idfactura = " + cursor.valueBuffer("idfactura"));
    if (!query.exec())
      return false;


    if (query.first())
      totalAplazado = parseFloat(query.value("SUM(importe)"));

    if (!totalAplazado)
      return this.iface.__validateForm();

    var totalFactura: String = cursor.valueBuffer("total");
    if (totalAplazado != totalFactura) {
      MessageBox.critical("La suma de los importes aplazados debe ser igual al total de la factura",
      MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
      return false;
    }
  }

  return this.iface.__validateForm();
}

//// VENFACTURASCLI ////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

