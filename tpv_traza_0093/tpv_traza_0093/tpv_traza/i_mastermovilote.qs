
/** @class_declaration tpvLotes */
/////////////////////////////////////////////////////////////////
//// TPV + LOTES ////////////////////////////////////////////////
class tpvLotes extends oficial
{
  function tpvLotes(context)
  {
    oficial(context);
  }
  function origenDest(nodo: FLDomNode, campo: String): String {
    return this.ctx.tpvLotes_origenDest(nodo, campo);
  }
}
//// TPV + LOTES ////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition tpvLotes */
/////////////////////////////////////////////////////////////////
//// TPV + LOTES ////////////////////////////////////////////////
/** \D Construye la descripción del documento de destino con sus datos más relevantes
\end */
function tpvLotes_origenDest(nodo: FLDomNode, campo: String): String {
  var util: FLUtil = new FLUtil;

  var docOrigen: String = nodo.attributeValue("movilote.docorigen");
  var valor: String = "";

  switch (docOrigen)
  {
    case "VC" : {
      var idOrigen: String = nodo.attributeValue("movilote.idlineavc");
      var idComanda: String = util.sqlSelect("tpv_lineascomanda", "idtpv_comanda", "idtpv_linea = " + idOrigen);
      if (idComanda)
        valor = util.translate("scripts", "Venta TPV: %1 del cliente %2: %3").arg(util.sqlSelect("tpv_comandas", "codigo", "idtpv_comanda = " + idComanda)).arg(util.sqlSelect("tpv_comandas", "codcliente", "idtpv_comanda = " + idComanda)).arg(util.sqlSelect("tpv_comandas", "nombrecliente", "idtpv_comanda = " + idComanda));
      break;
    }
    default: {
      valor = this.iface.__origenDest(nodo, campo);
    }
  }
  return valor;
}

//// TPV + LOTES ////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
