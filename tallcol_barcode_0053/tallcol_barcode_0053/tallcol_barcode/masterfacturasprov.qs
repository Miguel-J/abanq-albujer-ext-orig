
/** @class_declaration barCode */
/////////////////////////////////////////////////////////////////
//// TALLAS Y COLORES POR BARCODE ///////////////////////////////
class barCode extends oficial
{
  function barCode(context)
  {
    oficial(context);
  }
  function dameParamInforme(idAlbaran)
  {
    return this.ctx.barCode_dameParamInforme(idAlbaran);
  }
}
//// TALLAS Y COLORES POR BARCODE ///////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition barCode */
/////////////////////////////////////////////////////////////////
//// TALLAS Y COLORES POR BARCODE ///////////////////////////////
function barCode_dameParamInforme(idFactura)
{
  var _i = this.iface;
  var oParam = _i.__dameParamInforme(idFactura);
  if (flfactinfo.iface.pub_formatoTallasColores(idFactura, "facturasprov")) {
    oParam.nombreInforme = "i_facturasprov_tc";
    oParam.groupBy = "empresa.nombre,  empresa.cifnif, empresa.direccion, empresa.logo, empresa.codpostal, empresa.ciudad, 		empresa.provincia, empresa.apartado, empresa.codpais, facturasprov.idfactura, lineasfacturasprov.idfactura, facturasprov.codigo, facturasprov.codserie, facturasprov.fecha, facturasprov.total, facturasprov.totaliva, facturasprov.totalrecargo, facturasprov.irpf, facturasprov.totalirpf, facturasprov.neto, facturasprov.coddivisa, facturasprov.codejercicio, facturasprov.codpago, facturasprov.codalmacen, facturasprov.codproveedor, facturasprov.nombre, facturasprov.cifnif, facturasprov.tasaconv, dirproveedores.direccion, dirproveedores.codpostal, dirproveedores.ciudad, dirproveedores.provincia, dirproveedores.apartado, dirproveedores.codpais, paises.nombre, lineasfacturasprov.referencia,lineasfacturasprov.pvpunitario, lineasfacturasprov.dtopor, lineasfacturasprov.color, lineasfacturasprov.descripcion, lineasfacturasprov.codimpuesto, lineasfacturasprov.iva, lineasfacturasprov.color,articulosprov.refproveedor";
  }

  return oParam;
}
//// TALLAS Y COLORES POR BARCODE ///////////////////////////////
/////////////////////////////////////////////////////////////////
