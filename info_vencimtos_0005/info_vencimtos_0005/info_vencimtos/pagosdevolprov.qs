
/** @class_declaration infoVencimtos */
//////////////////////////////////////////////////////////////////
//// INFO VENCIMIENTOS ///////////////////////////////////////////
class infoVencimtos extends proveed
{
  function infoVencimtos(context)
  {
    proveed(context);
  }
  function calculateField(fN: String): String {
    return this.ctx.infoVencimtos_calculateField(fN);
  }
}
//// INFO VENCIMIENTOS ///////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_definition infoVencimtos */
/////////////////////////////////////////////////////////////////
//// INFO VENCIMIENTOS //////////////////////////////////////////
/** \D La cuenta de pago por defecto es la del recibo
\end */
function infoVencimtos_calculateField(fN: String): String {
  var cursor: FLSqlCursor = this.cursor();
  var res: String;
  switch (fN)
  {
    case "codcuenta": {
      res = cursor.cursorRelation().valueBuffer("codcuentapago");
      if (!res || res == "")
        res = this.iface.__calculateField(fN);
      break;
    }
    default: {
      res = this.iface.__calculateField(fN);
      break;
    }
  }
  return res;
}
//// INFO VENCIMIENTOS //////////////////////////////////////////
/////////////////////////////////////////////////////////////////
