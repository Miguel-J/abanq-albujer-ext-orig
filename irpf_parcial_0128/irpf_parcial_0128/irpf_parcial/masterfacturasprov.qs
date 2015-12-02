
/** @class_declaration irpfParcial */
/////////////////////////////////////////////////////////////////
//// IRPF_PARCIAL //////////////////////////////////////////////////
class irpfParcial extends oficial
{
  function irpfParcial(context)
  {
    oficial(context);
  }
  function commonCalculateField(fN: String, cursor: FLSqlCursor): String {
    return this.ctx.irpfParcial_commonCalculateField(fN, cursor);
  }
}
//// IRPF_PARCIAL //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition irpfParcial */
/////////////////////////////////////////////////////////////////
//// IRPF_PARCIAL //////////////////////////////////////////////////

function irpfParcial_commonCalculateField(fN: String, cursor: FLSqlCursor): String {
  var tabla: String = cursor.table();

  if (tabla != "facturascli" && tabla != "facturasprov")
    return this.iface.__commonCalculateField(fN, cursor);

  switch (fN)
  {
    case "totalirpf":

      var util: FLUtil = new FLUtil;
      var netoIRPF = util.sqlSelect("lineas" + tabla, "SUM(pvptotal)", "idfactura = " + cursor.valueBuffer("idfactura") + " AND valorirpf = true");

      valor = (parseFloat(cursor.valueBuffer("irpf")) * parseFloat(netoIRPF)) / 100;
      valor = parseFloat(util.roundFieldValue(valor, "facturascli", "totalirpf"));
      break;

    default:
      return this.iface.__commonCalculateField(fN, cursor);
  }

  return valor;
}

//// IRPF_PARCIAL //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
