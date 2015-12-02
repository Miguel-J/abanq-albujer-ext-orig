
/** @class_declaration multiempcc */
/////////////////////////////////////////////////////////////////
//// MULTIEMPRESA + CC ///////////////////////////////////
class multiempcc extends centroscoste
{
  function multiempcc(context)
  {
    centroscoste(context);
  }
  function beforeCommit_co_asientos(curAsiento: FLSqlCursor)
  {
    return this.ctx.multiempcc_beforeCommit_co_asientos(curAsiento);
  }
}
//// MULTIEMPRESA + CC ///////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition multiempcc */
/////////////////////////////////////////////////////////////////
//// MULTIEMPRESA + CC ///////////////////////////////////
function multiempcc_beforeCommit_co_asientos(curAsiento: FLSqlCursor)
{
  if (!this.iface.__beforeCommit_co_asientos(curAsiento))
    return false;

  switch (curAsiento.modeAccess()) {
    case curAsiento.Edit:
    case curAsiento.Insert: {
      var codCentro = curAsiento.valueBuffer("codcentro");
      if (!flfactppal.iface.pub_validarCCEmpresa(codCentro))
        return false;
      break;
    }
  }
  return true;
}
//// MULTIEMPRESA + CC ///////////////////////////////////
/////////////////////////////////////////////////////////////////
