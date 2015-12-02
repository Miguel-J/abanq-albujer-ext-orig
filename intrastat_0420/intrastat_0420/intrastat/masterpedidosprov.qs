
/** @class_declaration intrastat */
/////////////////////////////////////////////////////////////////
//// INTRASTAT /////////////////////////////////////////////////
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
//// INTRASTAT /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition intrastat */
/////////////////////////////////////////////////////////////////
//// INTRASTAT //////////////////////////////////////////////////
function intrastat_datosAlbaran(curPedido: FLSqlCursor, where: String, datosAgrupacion: Array): Boolean {
  var util = new FLUtil();
  var _i = this.iface;
  if (!_i.__datosAlbaran(curPedido, where, datosAgrupacion))
  {
    return false;
  }
  var codPais = util.sqlSelect("dirproveedores", "codpais", "codproveedor = '" + curPedido.valueBuffer("codproveedor") + "' AND direccionppal");
  if (!codPais || codPais == "")
  {
    MessageBox.warning(util.translate("scripts", "Para establecer los datos de Intrastat, el proveedor debe tener informado el campo País en su dirección principal"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton, "AbanQ");
    return false;
  }
  with(_i.curAlbaran)
  {
    setValueBuffer("codpais", codPais);
    setValueBuffer("codprovincia", flfactppal.iface.pub_valorDefectoEmpresa("codprovintrastatprov"));
    setValueBuffer("codcondicionentrega", flfactppal.iface.pub_valorDefectoEmpresa("codentregintrastatprov"));
    setValueBuffer("codnaturaleza", flfactppal.iface.pub_valorDefectoEmpresa("codnaturintrastatprov"));
    setValueBuffer("codmodotransporte", flfactppal.iface.pub_valorDefectoEmpresa("codtranspintrastatprov"));
    setValueBuffer("codpuerto", flfactppal.iface.pub_valorDefectoEmpresa("codpuertointrastatprov"));
    setValueBuffer("codregimen", flfactppal.iface.pub_valorDefectoEmpresa("codregintrastatprov"));
    setValueBuffer("nointrastat", formalbaranesprov.iface.pub_commonCalculateField("nointrastat", curPedido));
  }
  return true;
}

//// INTRASTAT //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

