
/** @class_declaration anticiposProv */
/////////////////////////////////////////////////////////////////
//// ANTICIPOS PROV /////////////////////////////////////////////
class anticiposProv extends oficial
{
  function anticiposProv(context)
  {
    oficial(context);
  }
  function datosConceptoAsiento(cur)
  {
    return this.ctx.anticiposProv_datosConceptoAsiento(cur);
  }
}
//// ANTICIPOS PROV /////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition anticiposProv */
/////////////////////////////////////////////////////////////////
//// ANTICIPOS PROV /////////////////////////////////////////////
function anticiposProv_datosConceptoAsiento(cur)
{
  var _i = this.iface;
  var datosAsiento = [];

  switch (cur.table()) {
    case "anticiposprov": {
      if (cur.valueBuffer("concepto")) {
        datosAsiento.concepto = cur.valueBuffer("concepto");
      } else {
        datosAsiento.concepto = sys.translate("Anticipo %1 de proveedor %2").arg(cur.valueBuffer("codigo")).arg(cur.valueBuffer("nombreproveedor"));
      }
      datosAsiento.documento = cur.valueBuffer("codigo");
      datosAsiento.tipoDocumento = "Anticipo de proveedor"; /// aunque no está en el optioslist, para búsquedas sql
      break;
    }
    default: {
      return _i.__datosConceptoAsiento(cur);
    }
  }
  return datosAsiento;
}
//// ANTICIPOS PROV /////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
