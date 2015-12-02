
/** @class_declaration chequesCli */
/////////////////////////////////////////////////////////////////
//// CHEQUES DE CLIENTE /////////////////////////////////////////
class chequesCli extends oficial
{
  function chequesCli(context)
  {
    oficial(context);
  }
  function commonCalculateField(fN: String, cursor: FLSqlCursor)
  {
    return this.ctx.chequesCli_commonCalculateField(fN, cursor);
  }
  function tdbReciboscli_bufferCommited()
  {
    return this.ctx.chequesCli_tdbReciboscli_bufferCommited();
  }
}
//// CHEQUES DE CLIENTE /////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition chequesCli */
/////////////////////////////////////////////////////////////////
//// CHEQUES DE CLIENTE /////////////////////////////////////////
function chequesCli_commonCalculateField(fN, cursor)
{
  var util = new FLUtil();
  var valor: String;
  switch (fN) {
    case "pagoporcheque": {
      valor = util.sqlSelect("pagosdevolcli", "pagoporcheque", "idrecibo = " + cursor.valueBuffer("idrecibo") + " ORDER by idpagodevol DESC");
      break;
    }
    default: {
      valor = this.iface.__commonCalculateField(fN, cursor);
    }
  }

  return valor;
}

function chequesCli_tdbReciboscli_bufferCommited()
{
  var cursor = this.cursor();
  cursor.setValueBuffer("pagoporcheque", this.iface.calculateField("pagoporcheque"));
  this.iface.__tdbReciboscli_bufferCommited();
}

//// CHEQUES DE CLIENTE /////////////////////////////////////////
/////////////////////////////////////////////////////////////////
