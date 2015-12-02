
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
  if (flfactinfo.iface.pub_formatoTallasColores(idAlbaran, "albaranescli")) {
    oParam.nombreInforme = "i_albaranescli_tc";
    oParam.groupBy = "empresa.nombre,  empresa.cifnif, empresa.direccion, empresa.logo, empresa.codpostal, empresa.ciudad, 		empresa.provincia, empresa.apartado, empresa.codpais, albaranescli.idalbaran, lineasalbaranescli.idalbaran, albaranescli.codigo, albaranescli.codserie, albaranescli.fecha, albaranescli.total, albaranescli.totaliva, albaranescli.totalrecargo, albaranescli.irpf, albaranescli.totalirpf, albaranescli.neto, albaranescli.coddivisa, albaranescli.codejercicio, albaranescli.codpago, albaranescli.codalmacen, albaranescli.codcliente, albaranescli.nombrecliente, albaranescli.cifnif, albaranescli.tasaconv, albaranescli.coddir, albaranescli.direccion, albaranescli.codpostal, albaranescli.ciudad, albaranescli.provincia, albaranescli.apartado, albaranescli.codpais, paises.nombre, lineasalbaranescli.referencia,lineasalbaranescli.pvpunitario, lineasalbaranescli.dtopor, lineasalbaranescli.color, lineasalbaranescli.descripcion, lineasalbaranescli.codimpuesto, lineasalbaranescli.iva, lineasalbaranescli.color";
  }

  return oParam;
}
//// TALLAS Y COLORES POR BARCODE ///////////////////////////////
/////////////////////////////////////////////////////////////////
