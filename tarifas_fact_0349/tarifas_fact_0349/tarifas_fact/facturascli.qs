
/** @class_declaration tarifasFact */
//////////////////////////////////////////////////////////////////
//// tarifasFact //////////////////////////////////////////////////////
class tarifasFact extends oficial
{
  function tarifasFact(context)
  {
    oficial(context);
  }
  function bufferChanged(fN: String)
  {
    return this.ctx.tarifasFact_bufferChanged(fN);
  }
  function validateForm(): Boolean {
    return this.ctx.tarifasFact_validateForm();
  }
}
//// tarifasFact //////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_definition tarifasFact */
/////////////////////////////////////////////////////////////////
//// tarifasFact /////////////////////////////////////////////////////

function tarifasFact_bufferChanged(fN: String)
{
  var cursor: FLSqlCursor = this.cursor();
  switch (fN) {
    case "codcliente":
      this.child("fdbCodTarifa").setValue(formpedidoscli.iface.pub_commonCalculateField("codtarifa", this.cursor()));
      break;
  }

  return this.iface.__bufferChanged(fN);
}


function tarifasFact_validateForm()
{
  if (!this.iface.__validateForm())
    return false;

  if (!flfacturac.iface.validarLineasFacturacion(this.cursor(), "lineasfacturascli", "idfactura"))
    return false;

  return true;
}

//// tarifasFact /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
