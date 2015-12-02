
/** @class_declaration masFormasPago */
/////////////////////////////////////////////////////////////////
//// MAS_FORMASPAGO ////////////////////////////////////////////
class masFormasPago extends oficial
{
  function masFormasPago(context)
  {
    oficial(context);
  }
  function validateForm(): Boolean {
    return this.ctx.masFormasPago_validateForm();
  }
}
//// MAS_FORMASPAGO ////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition masFormasPago */
/////////////////////////////////////////////////////////////////
//// MAS_FORMASPAGO ////////////////////////////////////////////
function masFormasPago_validateForm(): Boolean {
  if (!this.iface.__validateForm())
    return false;

  var cursor: FLSqlCursor = this.cursor();
  var totalAplazado: Number = 0;

  /** \C no puede haber ningún plazo posterior a los tipos de plazo "Número de plazos" ni tras "Importe fijo"
  \end */

  if (cursor.modeAccess() == cursor.Insert || cursor.modeAccess() == cursor.Edit)
  {
    var curPlazos: FLSqlCursor = new FLSqlCursor("plazos");
    curPlazos.select("codpago = '" + cursor.valueBuffer("codPago") + "'  ORDER BY dias");
    while (curPlazos.next()) {
      if (curPlazos.valueBuffer("tipoplazo") != 0 && curPlazos.at() < (curPlazos.size() - 1)) {
        MessageBox.critical("No pueden existir plazos posteriores a un plazo de tipo Número de plazos o de tipo Importe fijo",
        MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
        return false;
      }
    }
  }

  return true;
}
//// MAS_FORMASPAGO ////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
