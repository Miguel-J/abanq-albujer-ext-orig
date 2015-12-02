
/** @class_declaration vacacionesCli */
/////////////////////////////////////////////////////////////////
//// VACACIONES CLIENTES ////////////////////////////////////////
class vacacionesCli extends oficial
{
  function vacacionesCli(context)
  {
    oficial(context);
  }
  function calcFechaVencimientoCli(curFactura: FLSqlCursor, numPlazo: Number, diasAplazado: Number): String {
    return this.ctx.vacacionesCli_calcFechaVencimientoCli(curFactura, numPlazo, diasAplazado);
  }
}
//// VACACIONES CLIENTES ////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition vacacionesCli */
/////////////////////////////////////////////////////////////////
//// VACACIONES CLIENTES ////////////////////////////////////////
/**
Calcula la fecha de vencimiento en función de los días de vacaciones asignados al cliente
@param  codCliente: Código de cliente
@param  fechaFactura: Fecha de la factura
@param  fechaVencimiento: Fecha de vencimiento
@return fecha de vencimiento modificada
*/
function vacacionesCli_calcFechaVencimientoCli(curFactura: FLSqlCursor, numPlazo: Number, diasAplazado: Number): String {
  var util: FLUtil = new FLUtil;
  var fechaVencimiento: String = this.iface.__calcFechaVencimientoCli(curFactura, numPlazo, diasAplazado);
  if (!fechaVencimiento)
  {
    return false;
  }

  var codCliente: String = curFactura.valueBuffer("codcliente");
  if (!codCliente || codCliente == "")
  {
    return fechaVencimiento;
  }

  var fechaV: Date = new Date(Date.parse(fechaVencimiento.toString()));

  var vacDesde: String = util.sqlSelect("clientes", "vacdesde", "codcliente = '" + codCliente + "'");
  if (!vacDesde || vacDesde == "")
  {
    return fechaVencimiento;
  }
  var vacHasta: String = util.sqlSelect("clientes", "vachasta", "codcliente = '" + codCliente + "'");
  if (!vacHasta || vacHasta == "")
  {
    return fechaVencimiento;
  }

  var diaMesDesde: Array = vacDesde.split("-");
  var diaMesHasta: Array = vacHasta.split("-");
  var annoDesde: Number, annoHasta: Number;
  var diaV: Number = fechaV.getDate();
  var mesV: Number = fechaV.getMonth();
  var annoV: Number = fechaV.getYear();

  annoDesde = annoV;
  if (parseFloat(diaMesHasta[1]) >= parseFloat(diaMesDesde[1]))
  {
    annoHasta = annoDesde;
  } else {
    annoHasta = annoDesde + 1;
  }

  var fechaDesde: String = annoDesde + "-" + diaMesDesde[1] + "-" + diaMesDesde[0];
  var fechaHasta: String = annoHasta + "-" + diaMesHasta[1] + "-" + diaMesHasta[0];

  // Comprobación de si la fecha de vencimiento cae en el intervalo de vacaciones. Si no es así, la fecha de vencimiento sigue igual
  if (util.daysTo(fechaVencimiento, fechaDesde) > 0)
  {
    return fechaVencimiento;
  }

  if (util.daysTo(fechaHasta, fechaVencimiento) >= 0)
  {
    return fechaVencimiento;
  }

  /** \C Si hay solapamiento, la Fecha de Vencimiento se incrementará un més. Si además el cliente tiene días de pago, se buscará el día de pago más cercano a la nueva fecha que sea posterior a la fecha de fin de vacaciones
  */
  //  var fechaResultado:String = util.addMonths(fechaVencimiento, 1);
  //  if (diasPago != "") {
  //      var fechaAnterior:String = this.iface.procesarDiasPagoAnt(fechaResultado, diasPago);
  //      var fechaPosterior:String = this.iface.procesarDiasPago(fechaResultado, diasPago);
  //      if (util.daysTo(fechaHasta, fechaAnterior) < 0)
  //          fechaResultado = fechaPosterior;
  //      else if (util.daysTo(fechaAnterior, fechaResultado) <  util.daysTo(fechaResultado, fechaPosterior))
  //          fechaResultado = fechaAnterior;
  //      else
  //          fechaResultado = fechaPosterior;
  //  }
  var fechaResultado: String = util.addDays(fechaHasta, 1);

  return fechaResultado;
}
//// VACACIONES CLIENTES ////////////////////////////////////////
/////////////////////////////////////////////////////////////////
