
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
  function comprobarStockEnAlbaranado(curLineaPedido: FLSqlCursor, cantidad: Number): Array {
    return this.ctx.barCode_comprobarStockEnAlbaranado(curLineaPedido, cantidad);
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

function barCode_comprobarStockEnAlbaranado(curLineaPedido: FLSqlCursor, cantidad: Number): Array {
  var barCode: String = curLineaPedido.valueBuffer("barcode");

  if (!barCode)
    return this.iface.__comprobarStockEnAlbaranado(curLineaPedido, cantidad);

  var util: FLUtil = new FLUtil;
  var res: Array = [];

  res["haystock"] = true;
  res["cantidad"] = 0;
  res["ok"] = true;
  var referencia: String = curLineaPedido.valueBuffer("referencia");
  if (referencia && referencia != "")
  {
    var controlStock: Boolean = util.sqlSelect("articulos", "controlstock", "referencia = '" + referencia + "'");
    if (!controlStock) {
      var codAlmacen: String;
      if (curLineaPedido.cursorRelation())
        codAlmacen = curLineaPedido.cursorRelation().valueBuffer("codalmacen");
      else
        codAlmacen = util.sqlSelect("pedidoscli", "codalmacen", "idpedido = " + curLineaPedido.valueBuffer("idpedido"));

      var cantidadStock: Number = parseFloat(util.sqlSelect("stocks", "cantidad", "barcode = '" + barCode + "' AND codalmacen = '" + codAlmacen + "'"));
      if (!cantidadStock || isNaN(cantidadStock))
        cantidadStock = 0;

      if (cantidadStock < cantidad) {
        res["haystock"] = false;
        var resCuestion: Number = MessageBox.warning(util.translate("scripts", "El artículo %1 con barcode %2 no permite ventas sin stocks.\nEstá albaranando más cantidad (%3) que la disponible (%4) ahora mismo en el almacén %5.\n¿Desea continuar dejando el pedido parcialmente albaranado?").arg(referencia).arg(barCode).arg(cantidad).arg(cantidadStock).arg(codAlmacen), MessageBox.No, MessageBox.Yes);
        if (resCuestion != MessageBox.Yes) {
          res["ok"] = false;
          return res;
        }
        if (cantidadStock < 0)
          cantidadStock = 0;
        res["cantidad"] = cantidadStock;
      }
    }
  }
  return res;
}

function barCode_dameParamInforme(idPedido)
{
  var _i = this.iface;
  var oParam = _i.__dameParamInforme(idPedido);
  if (flfactinfo.iface.pub_formatoTallasColores(idPedido, "pedidoscli")) {
    oParam.nombreInforme = "i_pedidoscli_tc";
    oParam.groupBy = "empresa.nombre,  empresa.cifnif, empresa.direccion, empresa.logo, empresa.codpostal, empresa.ciudad, 		empresa.provincia, empresa.apartado, empresa.codpais, pedidoscli.idpedido, lineaspedidoscli.idpedido, pedidoscli.codigo, pedidoscli.codserie, pedidoscli.fecha, pedidoscli.total, pedidoscli.totaliva, pedidoscli.totalrecargo, pedidoscli.irpf, pedidoscli.totalirpf, pedidoscli.neto, pedidoscli.coddivisa, pedidoscli.codejercicio, pedidoscli.codpago, pedidoscli.codalmacen, pedidoscli.codcliente, pedidoscli.nombrecliente, pedidoscli.cifnif, pedidoscli.tasaconv, pedidoscli.coddir, pedidoscli.direccion, pedidoscli.codpostal, pedidoscli.ciudad, pedidoscli.provincia, pedidoscli.apartado, pedidoscli.codpais, paises.nombre, lineaspedidoscli.referencia,lineaspedidoscli.pvpunitario, lineaspedidoscli.dtopor, lineaspedidoscli.color, lineaspedidoscli.descripcion, lineaspedidoscli.codimpuesto, lineaspedidoscli.iva, lineaspedidoscli.color";
  }

  return oParam;
}
//// TALLAS Y COLORES POR BARCODE ///////////////////////////////
/////////////////////////////////////////////////////////////////
