
/** @class_declaration venFacturasProv */
/////////////////////////////////////////////////////////////////
//// VENFACTURASPROV ////////////////////////////////////////////
class venFacturasProv extends oficial
{
  function venFacturasProv(context)
  {
    oficial(context);
  }
  function validateForm(): Boolean {
    return this.ctx.venFacturasProv_validateForm();
  }
  function calculateField(fN: String): String {
    return this.ctx.venFacturasProv_calculateField(fN);
  }
  function bufferChanged(fN: String)
  {
    return this.ctx.venFacturasProv_bufferChanged(fN);
  }
}
//// VENFACTURASPROV ////////////////////////////////////////////
/////////////////////////////////////////////////////////////////


/** @class_definition venFacturasProv */
//////////////////////////////////////////////////////////////////
//// VENFACTURASPROV ////////////////////////////////////////////////

function venFacturasProv_validateForm(): Boolean {
  var cursor: FLSqlCursor = this.cursor();
  var totalAplazado: Number = 0;

  /** \C La suma de los importes aplazados de vencimientos debe ser igual al total de la factura"
  \end */

  if (cursor.modeAccess() == cursor.Insert || cursor.modeAccess() == cursor.Edit)
  {
    var query: FLSqlQuery = new FLSqlQuery();
    query.setTablesList("venfacturasprov");
    query.setSelect("SUM(importe)");
    query.setFrom("venfacturasprov");
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

function venFacturasProv_bufferChanged(fN: String)
{
  var cursor: FLSqlCursor = this.cursor();
  switch (fN) {
      /** \C
      Si el usuario selecciona una cuenta bancaria, se tomará su cuenta contable asociada como cuenta contable para el pago. La subcuenta contable por defecto será la asociada a la cuenta bancaria. Si ésta está vacía, será la subcuenta correspondienta a Caja
      \end */
    case "codcuenta":
    case "ctaentidad":
    case "ctaagencia":
    case "cuenta":
      this.child("fdbDc").setValue(this.iface.calculateField("dc"));
      break;

    default:
      return this.iface.__bufferChanged(fN);
  }
}

function venFacturasProv_calculateField(fN: String): String {
  var util: FLUtil = new FLUtil();
  var cursor: FLSqlCursor = this.cursor();
  var res: String;
  switch (fN)
  {
    case "dc":
      var entidad = cursor.valueBuffer("ctaentidad");
      var agencia = cursor.valueBuffer("ctaagencia");
      var cuenta = cursor.valueBuffer("cuenta");
      if (!entidad.isEmpty() && !agencia.isEmpty() && ! cuenta.isEmpty()
      && entidad.length == 4 && agencia.length == 4 && cuenta.length == 10) {
        var dc1 = util.calcularDC(entidad + agencia);
        var dc2 = util.calcularDC(cuenta);
        res = dc1 + dc2;
      }
      break;

    default:
      return this.iface.__calculateField(fN);
  }

  return res;
}

//// VENFACTURASPROV /////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

