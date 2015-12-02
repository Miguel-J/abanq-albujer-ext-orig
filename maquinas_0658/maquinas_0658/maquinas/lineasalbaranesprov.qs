
/** @class_declaration maquinas */
//////////////////////////////////////////////////////////////////
// MAQUINAS ////////////////////////////////////////////////
class maquinas extends oficial
{
  function maquinas(context)
  {
    oficial(context);
  }
  function bufferChanged(fN)
  {
    return this.ctx.maquinas_bufferChanged(fN);
  }
}
// MAQUINAS //////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_definition maquinas */
/////////////////////////////////////////////////////////////////
//// MAQUINAS //////////////////////////////////////////////
function maquinas_bufferChanged(fN: String)
{
  var util: FLUtil = new FLUtil();
  var cursor: FLSqlCursor = this.cursor();

  switch (fN) {
    case "codmaquina": {
      var referencia: String = util.sqlSelect("cl_maquinas", "referencia", "codmaquina = '" + cursor.valueBuffer("codmaquina") + "'");
      if (referencia)
        this.child("fdbReferencia").setValue(referencia);
      break;
    }
    default: {
      this.iface.__bufferChanged(fN);
      break;
    }
  }
}

//// MAQUINAS //////////////////////////////////////////////
////////////////////////////////////////////////////////////////
