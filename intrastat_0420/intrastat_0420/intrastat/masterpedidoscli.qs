
/** @class_declaration intrastat */
/////////////////////////////////////////////////////////////////
//// INTRASTAT //////////////////////////////////////////////////
class intrastat extends oficial
{
  function intrastat(context)
  {
    oficial(context);
  }
  function datosAlbaran(curPedido: FLSqlCursor, where: String, datosAgrupacion: Array): Boolean {
    return this.ctx.intrastat_datosAlbaran(curPedido, where, datosAgrupacion);
  }
}
//// INTRASTAT //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition intrastat */
/////////////////////////////////////////////////////////////////
//// INTRASTAT //////////////////////////////////////////////////
function intrastat_datosAlbaran(curPedido: FLSqlCursor, where: String, datosAgrupacion: Array): Boolean {
  if (!this.iface.__datosAlbaran(curPedido, where, datosAgrupacion))
  {
    return false;
  }
  with(this.iface.curAlbaran)
  {
    setValueBuffer("codprovincia", flfactppal.iface.pub_valorDefectoEmpresa("codprovintrastatcli"));
    setValueBuffer("codcondicionentrega", flfactppal.iface.pub_valorDefectoEmpresa("codentregintrastatcli"));
    setValueBuffer("codnaturaleza", flfactppal.iface.pub_valorDefectoEmpresa("codnaturintrastatcli"));
    setValueBuffer("codmodotransporte", flfactppal.iface.pub_valorDefectoEmpresa("codtranspintrastatcli"));
    setValueBuffer("codpuerto", flfactppal.iface.pub_valorDefectoEmpresa("codpuertointrastatcli"));
    setValueBuffer("codregimen", flfactppal.iface.pub_valorDefectoEmpresa("codregintrastatcli"));
    setValueBuffer("nointrastat", formalbaranescli.iface.pub_commonCalculateField("nointrastat", curPedido));
  }
  return true;
}

//// INTRASTAT //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
