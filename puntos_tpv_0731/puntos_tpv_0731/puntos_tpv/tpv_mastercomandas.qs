
/** @class_declaration puntosTpv */
/////////////////////////////////////////////////////////////////
//// PUNTOSTPV //////////////////////////////////////////////
class puntosTpv extends ivaIncluido
{
  function puntosTpv(context)
  {
    ivaIncluido(context);
  }
  function dameMasFormasPago(idComanda)
  {
    return this.ctx.puntosTpv_dameMasFormasPago(idComanda);
  }
}
//// PUNTOSTPV //////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition puntosTpv */
/////////////////////////////////////////////////////////////////
//// PUNTOSTPV //////////////////////////////////////////////
function puntosTpv_dameMasFormasPago(idComanda)
{
  var fpPuntos = flfact_tpv.iface.pub_valorDefectoTPV("pagopunto");
  var impPuntos = AQUtil.sqlSelect("tpv_pagoscomanda", "SUM(importe)", "idtpv_comanda = '" + idComanda + "' AND codpago = '" + fpPuntos + "' GROUP BY codpago");

  if (impPuntos) {
    flfact_tpv.iface.impNuevaLinea();
    flfact_tpv.iface.imprimirDatos(sys.translate("Entregado Puntos:"));
    flfact_tpv.iface.imprimirDatos(AQUtil.roundFieldValue(impPuntos, "tpv_comandas", "total"), 10, 2);
  }
}
//// PUNTOSTPV //////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
