
/** @class_declaration anticipos */
/////////////////////////////////////////////////////////////////
//// ANTICIPOS //////////////////////////////////////////////////
class anticipos extends oficial
{
  function anticipos(context)
  {
    oficial(context);
  }
  function datosConceptoAsiento(cur)
  {
    return this.ctx.anticipos_datosConceptoAsiento(cur);
  }
}
//// ANTICIPOS //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition anticipos */
/////////////////////////////////////////////////////////////////
//// ANTICIPOS //////////////////////////////////////////////////
function anticipos_datosConceptoAsiento(cur)
{
  var _i = this.iface;
  var datosAsiento = [];

  switch (cur.table()) {
    case "anticiposcli": {
      if (cur.valueBuffer("concepto")) {
        datosAsiento.concepto = cur.valueBuffer("concepto");
      } else {
        datosAsiento.concepto = sys.translate("Anticipo %1 de cliente %2").arg(cur.valueBuffer("codigo")).arg(cur.valueBuffer("nombrecliente"));
      }
      datosAsiento.documento = cur.valueBuffer("codigo");
      datosAsiento.tipoDocumento = "Anticipo de cliente"; /// aunque no está en el optioslist, para búsquedas sql
      break;
    }
    default: {
      return _i.__datosConceptoAsiento(cur);
    }
  }
  return datosAsiento;
}
//// ANTICIPOS //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
