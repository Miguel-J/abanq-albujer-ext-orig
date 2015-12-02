
/** @class_declaration pobla */
/////////////////////////////////////////////////////////////////
//// POBLACIONES ////////////////////////////////////////////////
class pobla extends oficial
{
  function pobla(context)
  {
    oficial(context);
  }
  function bufferChanged(fN: String)
  {
    return this.ctx.pobla_bufferChanged(fN);
  }
}
//// POBLACIONES ////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition pobla */
/////////////////////////////////////////////////////////////////
//// POBLACIONES ////////////////////////////////////////////////
function pobla_bufferChanged(fN: String)
{
  var cursor: FLSqlCursor = this.cursor();
  var util: FLUtil = new FLUtil();
  switch (fN) {
    case "ciudad": {
      if (!this.iface.bloqueoProvincia) {
        this.iface.bloqueoProvincia = true;
        flfactppal.iface.pub_obtenerPoblacion(this);
        this.iface.bloqueoProvincia = false;
      }
      break;
    }
    case "idpoblacion": {
      if (cursor.valueBuffer("idpoblacion") == 0) {
        cursor.setNull("idpoblacion");
      }
      break;
    }
    case "coddir": {
      this.child("fdbCiudad").setValue(this.iface.calculateField("ciudad"));
      this.iface.__bufferChanged(fN);
      break;
    }

    default: {
      this.iface.__bufferChanged(fN);
    }
  }
}
//// POBLACIONES ////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
