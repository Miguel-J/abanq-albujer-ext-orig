
/** @class_declaration banesConfirming */
/////////////////////////////////////////////////////////////////
//// BANESCONFIRMING ////////////////////////////////////////////
class banesConfirming extends oficial
{
  function banesConfirming(context)
  {
    oficial(context);
  }
  function quitarEspaciosIntermedios(dato: String): String {
    return this.ctx.banesConfirming_quitarEspaciosIntermedios(dato);
  }
}
//// BANESCONFIRMING ////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pubBanesConfirming */
/////////////////////////////////////////////////////////////////
//// PUB_BANESCONFIRMING ////////////////////////////////////////
class pubBanesConfirming extends ifaceCtx
{
  function pubBanesConfirming(context)
  {
    ifaceCtx(context);
  }
  function pub_quitarEspaciosIntermedios(dato: String): String {
    return this.quitarEspaciosIntermedios(dato);
  }
}

//// PUB_BANESCONFIRMING ////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition banesConfirming */
/////////////////////////////////////////////////////////////////
//// BANESCONFIRMING ////////////////////////////////////////////
function banesConfirming_quitarEspaciosIntermedios(dato: String): String {
  var res: String = "";
  var i: Number;
  var caracter: String;
  for (i = 0; i < dato.length; i++)
  {
    caracter = dato.charAt(i);
    if (caracter && caracter != " ") {
      res += caracter;
    }
  }
  return res;
}

//// BANESCONFIRMING ////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
