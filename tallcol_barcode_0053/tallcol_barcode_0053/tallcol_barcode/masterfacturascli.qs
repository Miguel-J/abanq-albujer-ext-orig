
/** @class_declaration barCode */
/////////////////////////////////////////////////////////////////
//// TALLAS Y COLORES POR BARCODE ///////////////////////////////
class barCode extends oficial
{
  function barCode(context)
  {
    oficial(context);
  }
  function dameParamInforme(idPresupuesto)
  {
    return this.ctx.barCode_dameParamInforme(idPresupuesto);
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
  if (flfactinfo.iface.pub_formatoTallasColores(idFactura, "facturascli")) {
    oParam.nombreInforme = "i_facturascli_tc";
    oParam.groupBy = "empresa.nombre,  empresa.cifnif, empresa.direccion, empresa.logo, empresa.codpostal, empresa.ciudad, 		empresa.provincia, empresa.apartado, empresa.codpais, facturascli.idfactura, lineasfacturascli.idfactura, facturascli.codigo, facturascli.codserie, facturascli.fecha, facturascli.total, facturascli.totaliva, facturascli.totalrecargo, facturascli.irpf, facturascli.totalirpf, facturascli.neto, facturascli.coddivisa, facturascli.codejercicio, facturascli.codpago, facturascli.codalmacen, facturascli.codcliente, facturascli.nombrecliente, facturascli.cifnif, facturascli.tasaconv, facturascli.coddir, facturascli.direccion, facturascli.codpostal, facturascli.ciudad, facturascli.provincia, facturascli.apartado, facturascli.codpais, paises.nombre, lineasfacturascli.referencia,lineasfacturascli.pvpunitario, lineasfacturascli.dtopor, lineasfacturascli.color, lineasfacturascli.descripcion, lineasfacturascli.codimpuesto, lineasfacturascli.iva, lineasfacturascli.color, formaspago.descripcion";
  }

  return oParam;
}
//// TALLAS Y COLORES POR BARCODE ///////////////////////////////
/////////////////////////////////////////////////////////////////
