
/** @class_declaration barCode */
/////////////////////////////////////////////////////////////////
//// TALLAS Y COLORES POR BARCODE ///////////////////////////////
class barCode extends oficial
{
  function barCode(context)
  {
    oficial(context);
  }
  function datosLineaFactura(curLineaAlbaran: FLSqlCursor): Boolean {
    return this.ctx.barCode_datosLineaFactura(curLineaAlbaran);
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
/** \D Copia los datos de una línea de albarán en una línea de factura
@param  curLineaAlbaran: Cursor que contiene los datos a incluir en la línea de factura
@return True si la copia se realiza correctamente, false en caso contrario
\end */
function barCode_datosLineaFactura(curLineaAlbaran: FLSqlCursor): Boolean {
  if (!this.iface.__datosLineaFactura(curLineaAlbaran))
    return false;

  with(this.iface.curLineaFactura)
  {
    setValueBuffer("barcode", curLineaAlbaran.valueBuffer("barcode"));
    setValueBuffer("talla", curLineaAlbaran.valueBuffer("talla"));
    setValueBuffer("color", curLineaAlbaran.valueBuffer("color"));
  }
  return true;
}

function barCode_dameParamInforme(idAlbaran)
{
  var _i = this.iface;
  var oParam = _i.__dameParamInforme(idAlbaran);
  if (flfactinfo.iface.pub_formatoTallasColores(idAlbaran, "albaranesprov")) {
    oParam.nombreInforme = "i_albaranesprov_tc";
    oParam.groupBy = "empresa.nombre,  empresa.cifnif, empresa.direccion, empresa.logo, empresa.codpostal, empresa.ciudad, 		empresa.provincia, empresa.apartado, empresa.codpais, albaranesprov.idalbaran, lineasalbaranesprov.idalbaran, albaranesprov.codigo, albaranesprov.codserie, albaranesprov.fecha, albaranesprov.total, albaranesprov.totaliva, albaranesprov.totalrecargo, albaranesprov.irpf, albaranesprov.totalirpf, albaranesprov.neto, albaranesprov.coddivisa, albaranesprov.codejercicio, albaranesprov.codpago, albaranesprov.codalmacen, albaranesprov.codproveedor, albaranesprov.nombre, albaranesprov.cifnif, albaranesprov.tasaconv, dirproveedores.direccion, dirproveedores.codpostal, dirproveedores.ciudad, dirproveedores.provincia, dirproveedores.apartado, dirproveedores.codpais, paises.nombre, lineasalbaranesprov.referencia,lineasalbaranesprov.pvpunitario, lineasalbaranesprov.dtopor, lineasalbaranesprov.color, lineasalbaranesprov.descripcion, lineasalbaranesprov.codimpuesto, lineasalbaranesprov.iva, lineasalbaranesprov.color,articulosprov.refproveedor";
  }

  return oParam;
}
//// TALLAS Y COLORES POR BARCODE ///////////////////////////////
/////////////////////////////////////////////////////////////////
