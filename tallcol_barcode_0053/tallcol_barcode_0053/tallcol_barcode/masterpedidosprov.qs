
/** @class_declaration barCode */
/////////////////////////////////////////////////////////////////
//// TALLAS Y COLORES POR BARCODE ///////////////////////////////
class barCode extends oficial
{
  function barCode(context)
  {
    oficial(context);
  }
  function datosLineaAlbaran(curLineaPedido: FLSqlCursor): Boolean {
    return this.ctx.barCode_datosLineaAlbaran(curLineaPedido);
  }
  function dameParamInforme(idPedido)
  {
    return this.ctx.barCode_dameParamInforme(idPedido);
  }
}
//// TALLAS Y COLORES POR BARCODE ///////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition barCode */
/////////////////////////////////////////////////////////////////
//// TALLAS Y COLORES POR BARCODE ///////////////////////////////

/** \D Copia los datos de una línea de pedido en una línea de albarán
@param  curLineaPedido: Cursor que contiene los datos a incluir en la línea de albarán
@return True si la copia se realiza correctamente, false en caso contrario
\end */
function barCode_datosLineaAlbaran(curLineaPedido: FLSqlCursor): Boolean {
  if (!this.iface.__datosLineaAlbaran(curLineaPedido))
    return false;

  with(this.iface.curLineaAlbaran)
  {
    setValueBuffer("barcode", curLineaPedido.valueBuffer("barcode"));
    setValueBuffer("talla", curLineaPedido.valueBuffer("talla"));
    setValueBuffer("color", curLineaPedido.valueBuffer("color"));
  }
  return true;
}

function barCode_dameParamInforme(idPedido)
{
  var _i = this.iface;
  var oParam = _i.__dameParamInforme(idPedido);
  if (flfactinfo.iface.pub_formatoTallasColores(idPedido, "pedidosprov")) {
    oParam.nombreInforme = "i_pedidosprov_tc";
    oParam.groupBy = "empresa.nombre,  empresa.cifnif, empresa.direccion, empresa.logo, empresa.codpostal, empresa.ciudad, 		empresa.provincia, empresa.apartado, empresa.codpais, pedidosprov.idpedido, lineaspedidosprov.idpedido, pedidosprov.codigo, pedidosprov.codserie, pedidosprov.fecha, pedidosprov.total, pedidosprov.totaliva, pedidosprov.totalrecargo, pedidosprov.irpf, pedidosprov.totalirpf, pedidosprov.neto, pedidosprov.coddivisa, pedidosprov.codejercicio, pedidosprov.codpago, pedidosprov.codalmacen, pedidosprov.codproveedor, pedidosprov.nombre, pedidosprov.cifnif, pedidosprov.tasaconv, dirproveedores.direccion, dirproveedores.codpostal, dirproveedores.ciudad, dirproveedores.provincia, dirproveedores.apartado, dirproveedores.codpais, paises.nombre, lineaspedidosprov.referencia,lineaspedidosprov.pvpunitario, lineaspedidosprov.dtopor, lineaspedidosprov.color, lineaspedidosprov.descripcion, lineaspedidosprov.codimpuesto, lineaspedidosprov.iva, lineaspedidosprov.color,articulosprov.refproveedor";
  }

  return oParam;
}
//// TALLAS Y COLORES POR BARCODE ///////////////////////////////
/////////////////////////////////////////////////////////////////
