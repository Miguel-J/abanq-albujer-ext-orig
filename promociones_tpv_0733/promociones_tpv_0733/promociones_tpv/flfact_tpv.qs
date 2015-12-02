
/** @class_declaration promocionesTpv */
/////////////////////////////////////////////////////////////////
//// PROMOCIONES TPV ////////////////////////////////////////////
class promocionesTpv extends ivaIncluido
{
  function promocionesTpv(context)
  {
    ivaIncluido(context);
  }
  function afterCommit_tpv_lineascomanda(curLinea)
  {
    return this.ctx.promocionesTpv_afterCommit_tpv_lineascomanda(curLinea);
  }
  function controlTotalesVenta(curLinea)
  {
    return this.ctx.promocionesTpv_controlTotalesVenta(curLinea);
  }
  function controlPromociones(curLinea)
  {
    return this.ctx.promocionesTpv_controlPromociones(curLinea);
  }
}
//// PROMOCIONES TPV ////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition promocionesTpv */
/////////////////////////////////////////////////////////////////
//// PROMOCIONES TPV ////////////////////////////////////////////
function promocionesTpv_afterCommit_tpv_lineascomanda(curLinea)
{
  var _i = this.iface;
  if (!_i.__afterCommit_tpv_lineascomanda(curLinea)) {
    return false;
  }
  if (!_i.controlPromociones(curLinea)) {
    return false;
  }
  if (!_i.controlTotalesVenta(curLinea)) {
    return false;
  }
  return true;
}

function promocionesTpv_controlTotalesVenta(curLinea)
{
  if (!curLinea.cursorRelation()) {
    return true;
  }
  var _i = this.iface;
  if (!formRecordtpv_comandas.iface.pub_calcularTotalesPromo()) {
    return false;
  }
  return true;
}

function promocionesTpv_controlPromociones(curLinea)
{
  if (!curLinea.cursorRelation()) {
    return true;
  }
  var _i = this.iface;
  var idPromo = curLinea.valueBuffer("idpromo");
  switch (curLinea.modeAccess()) {
    case curLinea.Insert:
    case curLinea.Del: {
      if (idPromo && idPromo != "" && idPromo != 0) {
        if (!formRecordtpv_comandas.iface.pub_aplicarPromocion(idPromo)) {
          return false;
        }
      }
      break;
    }

    case curLinea.Edit: {
      var idPromoPrevia = curLinea.valueBufferCopy("idpromo");
      if (idPromo && idPromo != "" && idPromo != 0) {
        if (!formRecordtpv_comandas.iface.pub_aplicarPromocion(idPromo)) {
          return false;
        }
      }
      if (idPromoPrevia && idPromoPrevia != idPromo) {
        if (!formRecordtpv_comandas.iface.pub_aplicarPromocion(idPromoPrevia)) {
          return false;
        }
      }
      break;
    }
  }
  return true;
}
//// PROMOCIONES TPV ////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
