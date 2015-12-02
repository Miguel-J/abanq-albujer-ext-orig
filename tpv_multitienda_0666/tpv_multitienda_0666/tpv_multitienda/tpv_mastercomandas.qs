
/** @class_declaration tiendas */
/////////////////////////////////////////////////////////////////
//// TPV MULTITIENDA ////////////////////////////////////////////
class tiendas extends oficial
{
  function tiendas(context)
  {
    oficial(context);
  }
  function datosTiqueEmpresa(qryTicket: FLSqlQuery): Boolean {
    return this.ctx.tiendas_datosTiqueEmpresa(qryTicket);
  }
}
//// TPV MULTITIENDA ////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition tiendas */
/////////////////////////////////////////////////////////////////
//// TPV MULTITIENDA ////////////////////////////////////////////
function tiendas_datosTiqueEmpresa(qryTicket: FLSqlQuery): Boolean {
  flfact_tpv.iface.impLogo();

  flfact_tpv.iface.impResaltar(true);
  flfact_tpv.iface.impSubrayar(true);
  flfact_tpv.iface.imprimirDatos(qryTicket.value("empresa.nombre"));
  flfact_tpv.iface.impResaltar(false);
  flfact_tpv.iface.impSubrayar(false);
  flfact_tpv.iface.impNuevaLinea();
  flfact_tpv.iface.imprimirDatos(qryTicket.value("tpv_tiendas.direccion"));
  flfact_tpv.iface.impNuevaLinea();
  flfact_tpv.iface.imprimirDatos(qryTicket.value("tpv_tiendas.ciudad"));
  flfact_tpv.iface.impNuevaLinea();
  flfact_tpv.iface.imprimirDatos("Telef.  ");
  flfact_tpv.iface.imprimirDatos(qryTicket.value("tpv_tiendas.telefono"));
  flfact_tpv.iface.impNuevaLinea();
  flfact_tpv.iface.imprimirDatos("N.I.F.  ");
  flfact_tpv.iface.imprimirDatos(qryTicket.value("empresa.cifnif"));
  return true;
}
//// TPV MULTITIENDA ////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
