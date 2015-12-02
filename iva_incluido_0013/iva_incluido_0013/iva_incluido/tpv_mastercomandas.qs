
/** @class_declaration ivaIncluido */
//////////////////////////////////////////////////////////////////
//// IVAINCLUIDO /////////////////////////////////////////////////
class ivaIncluido extends oficial
{
  function ivaIncluido(context)
  {
    oficial(context);
  }

  function imprimirPagosComanda(qryTicket)
  {
    return this.ctx.ivaIncluido_imprimirPagosComanda(qryTicket);
  }
  function imprimirTotalesComanda(qryTicket)
  {
    return this.ctx.ivaIncluido_imprimirTotalesComanda(qryTicket);
  }
  function imprimirIvas(qryTicket)
  {
    return this.ctx.ivaIncluido_imprimirIvas(qryTicket);
  }
  function imprimirLineaTicket(qryTicket)
  {
    return this.ctx.ivaIncluido_imprimirLineaTicket(qryTicket);
  }
}
//// IVAINCLUIDO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition ivaIncluido */
//////////////////////////////////////////////////////////////////
//// IVAINCLUIDO /////////////////////////////////////////////////

function ivaIncluido_imprimirLineaTicket(qryTicket)
{

  var cantidad = qryTicket.value("tpv_lineascomanda.cantidad");
  //  var pvpUnitarioIva = qryTicket.value("tpv_lineascomanda.pvpunitarioiva");
  var pvp = qryTicket.value("tpv_lineascomanda.pvptotaliva");
  var totalLinea = AQUtil.roundFieldValue(pvp, "tpv_comandas", "total");
  var descripcion = qryTicket.value("tpv_lineascomanda.descripcion");

  flfact_tpv.iface.imprimirDatos(descripcion, 20);
  flfact_tpv.iface.imprimirDatos(cantidad, 10, 2);
  flfact_tpv.iface.imprimirDatos(totalLinea, 10, 2);
  flfact_tpv.iface.impNuevaLinea();
}

function ivaIncluido_imprimirPagosComanda(qryTicket)
{
  return;
}

function ivaIncluido_imprimirIvas(qryTicket)
{
  var _i = this.iface;
  return _i.__imprimirIvas(qryTicket); /// Lo exige la nueva norma
}

function ivaIncluido_imprimirTotalesComanda(qryTicket)
{
  var total = AQUtil.roundFieldValue(qryTicket.value("tpv_comandas.total"), "tpv_comandas", "total");

  flfact_tpv.iface.impNuevaLinea();
  flfact_tpv.iface.imprimirDatos("Total Ticket.", 30);
  flfact_tpv.iface.imprimirDatos(total, 10, 2);
}

//// IVAINCLUIDO /////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
