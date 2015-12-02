
/** @class_declaration barCode */
/////////////////////////////////////////////////////////////////
//// TALLAS Y COLORES POR BARCODE ///////////////////////////////
class barCode extends oficial
{
  function barCode(context)
  {
    oficial(context);
  }
  function datosLineaPedido(curLineaPresupuesto: FLSqlCursor): Boolean {
    return this.ctx.barCode_datosLineaPedido(curLineaPresupuesto);
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

/** \D Copia los datos de una línea de presupuesto en una línea de pedido
@param  curLineaPresupuesto: Cursor que contiene los datos a incluir en la línea de pedido
@return True si la copia se realiza correctamente, false en caso contrario
\end */
function barCode_datosLineaPedido(curLineaPresupuesto: FLSqlCursor): Boolean {
  if (!this.iface.__datosLineaPedido(curLineaPresupuesto))
    return false;

  with(this.iface.curLineaPedido)
  {
    setValueBuffer("barcode", curLineaPresupuesto.valueBuffer("barcode"));
    setValueBuffer("talla", curLineaPresupuesto.valueBuffer("talla"));
    setValueBuffer("color", curLineaPresupuesto.valueBuffer("color"));
  }
  return true;
}

function barCode_dameParamInforme(idPresupuesto)
{
  var _i = this.iface;
  var oParam = _i.__dameParamInforme(idPresupuesto);
  if (flfactinfo.iface.pub_formatoTallasColores(idPresupuesto, "presupuestoscli")) {
    oParam.nombreInforme = "i_presupuestoscli_tc";
    oParam.groupBy = "empresa.nombre,  empresa.cifnif, empresa.direccion, empresa.logo, empresa.codpostal, empresa.ciudad, 		empresa.provincia, empresa.apartado, empresa.codpais, presupuestoscli.idpresupuesto, lineaspresupuestoscli.idpresupuesto, presupuestoscli.codigo, presupuestoscli.codserie, presupuestoscli.fecha, presupuestoscli.total, presupuestoscli.totaliva, presupuestoscli.totalrecargo, presupuestoscli.irpf, presupuestoscli.totalirpf, presupuestoscli.neto, presupuestoscli.coddivisa, presupuestoscli.codejercicio, presupuestoscli.codpago, presupuestoscli.codalmacen, presupuestoscli.codcliente, presupuestoscli.nombrecliente, presupuestoscli.cifnif, presupuestoscli.tasaconv, presupuestoscli.coddir, presupuestoscli.direccion, presupuestoscli.codpostal, presupuestoscli.ciudad, presupuestoscli.provincia, presupuestoscli.apartado, presupuestoscli.codpais, paises.nombre, lineaspresupuestoscli.referencia,lineaspresupuestoscli.pvpunitario, lineaspresupuestoscli.dtopor, lineaspresupuestoscli.color, lineaspresupuestoscli.descripcion, lineaspresupuestoscli.codimpuesto, lineaspresupuestoscli.iva, lineaspresupuestoscli.color";
  }

  return oParam;
}
//// TALLAS Y COLORES POR BARCODE ///////////////////////////////
/////////////////////////////////////////////////////////////////
