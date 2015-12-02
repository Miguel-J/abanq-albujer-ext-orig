
/** @class_declaration modelo390 */
/////////////////////////////////////////////////////////////////
//// MODELO 390 /////////////////////////////////////////////////
class modelo390 extends oficial
{
  function modelo390(context)
  {
    oficial(context);
  }
  function bufferChanged(fN: String)
  {
    return this.ctx.modelo390_bufferChanged(fN);
  }
}
//// MODELO 390 /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition modelo390 */
/////////////////////////////////////////////////////////////////
//// MODELO 390 /////////////////////////////////////////////////
function modelo390_bufferChanged(fN: String)
{
  var cursor: FLSqlCursor = this.cursor();
  var util: FLUtil = new FLUtil();
  var valor: String = "";
  switch (fN) {
    case "personafisica": {
      if (cursor.valueBuffer("personafisica") == true) {
        this.child("fdbApellidosPF_2").setDisabled(false);
      } else {
        this.child("fdbApellidosPF_2").setValue("");
        this.child("fdbApellidosPF_2").setDisabled(true);
      }
      this.iface.__bufferChanged(fN);
      break;
    }
    case "nombrepf":
    case "apellidospf":
    case "apellidospf2": {
      if (cursor.valueBuffer("apellidospf")) {
        valor += cursor.valueBuffer("apellidospf") + " ";
      }
      if (cursor.valueBuffer("apellidospf2")) {
        valor += cursor.valueBuffer("apellidospf2") + " ";
      }
      if (cursor.valueBuffer("nombrepf")) {
        valor += cursor.valueBuffer("nombrepf");
      }
      this.child("fdbApellidosRS").setValue(valor);
      break;
    }
    default: {
      this.iface.__bufferChanged(fN);
    }
  }
}

//// MODELO 390 /////////////////////////////////////////////////
////////////////////////////////////////////////////////////////
