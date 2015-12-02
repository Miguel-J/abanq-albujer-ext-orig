
/** @class_declaration infoVencimtos */
//////////////////////////////////////////////////////////////////
//// INFO VENCIMIENTOS////////////////////////////////////////////
class infoVencimtos extends proveed
{
  function infoVencimtos(context)
  {
    proveed(context);
  }
  function datosReciboCli(curFactura, oRecibo)
  {
    return this.ctx.infoVencimtos_datosReciboCli(curFactura, oRecibo);
  }
  function datosReciboProv(): Boolean {
    return this.ctx.infoVencimtos_datosReciboProv();
  }
}
//// INFO VENCIMIENTOS////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_definition infoVencimtos */
/////////////////////////////////////////////////////////////////
//// INFO VENCIMIENTOS //////////////////////////////////////////
/** \D Informa la cuenta de pago como la cuenta de remesas del cliente
\end */
function infoVencimtos_datosReciboCli(curFactura, oRecibo)
{
  var util: FLUtil = new FLUtil;
  if (!this.iface.__datosReciboCli(curFactura, oRecibo)) {
    return false;
  }
  var codCliente: String = this.iface.curReciboCli.valueBuffer("codcliente");
  if (!codCliente) {
    return true;
  }
  this.iface.curReciboCli.setValueBuffer("codcuentapago", util.sqlSelect("clientes", "codcuentarem", "codcliente = '" + codCliente + "'"));

  return true;
}

/** \D Informa la cuenta de pago como la cuenta de pago del proveedor
\end */
function infoVencimtos_datosReciboProv(): Boolean {
  var util: FLUtil = new FLUtil;
  if (!this.iface.__datosReciboProv())
    return false;
  var codProveedor: String = this.iface.curReciboProv.valueBuffer("codproveedor");
  if (!codProveedor)
    return true;
  this.iface.curReciboProv.setValueBuffer("codcuentapago", util.sqlSelect("proveedores", "codcuentapago", "codproveedor = '" + codProveedor + "'"));

  return true;
}

//// INFO VENCIMIENTOS //////////////////////////////////////////
/////////////////////////////////////////////////////////////////
