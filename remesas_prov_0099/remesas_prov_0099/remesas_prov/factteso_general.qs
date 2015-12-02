
/** @class_declaration remesasProv */
/////////////////////////////////////////////////////////////////
//// REMESAS PROVEEDOR //////////////////////////////////////////
class remesasProv extends provee
{
  function remesasProv(context)
  {
    provee(context);
  }
  function calculateField(fN)
  {
    return this.ctx.remesasProv_calculateField(fN);
  }
  function bufferChanged(fN: String)
  {
    return this.ctx.remesasProv_bufferChanged(fN);
  }
  function habilitaPorPagoRemesaProv()
  {
    return this.ctx.remesasProv_habilitaPorPagoRemesaProv();
  }
  function init()
  {
    return this.ctx.remesasProv_init();
  }
}
//// REMESAS PROVEEDOR //////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition remesasProv */
/////////////////////////////////////////////////////////////////
//// REMESAS PROVEEDOR //////////////////////////////////////////
function remesasProv_bufferChanged(fN)
{
  var _i = this.iface;
  switch (fN) {
    case "pagoindirectoprov": {
      this.child("fdbPagoDiferidoProv").setValue(_i.calculateField("pagodiferidoprov"));
      this.child("lblDesPagoRemesasProv").text = _i.calculateField("despagoremesasprov");
      break;
    }
    case "pagodiferidoprov": {
      this.child("fdbPagoIndirectoProv").setValue(_i.calculateField("pagoindirectoprov"));
      this.child("lblDesPagoRemesasProv").text = _i.calculateField("despagoremesasprov");
      _i.habilitaPorPagoRemesaProv()
      break;
    }
    default: {
      _i.__bufferChanged(fN);
    }
  }
}

function remesasProv_calculateField(fN)
{
  var _i = this.iface;
  var cursor = this.cursor();
  var valor;
  switch (fN) {
    case "pagodiferidoprov": {
      if (cursor.valueBuffer("pagoindirectoprov")) {
        valor = true;
      } else {
        valor = cursor.valueBuffer("pagodiferidoprov");
      }
      break;
    }
    case "pagoindirectoprov": {
      if (!cursor.valueBuffer("pagodiferidoprov")) {
        valor = false;
      } else {
        valor = cursor.valueBuffer("pagoindirectoprov");
      }
      break;
    }
    case "despagoremesasprov": {
      if (cursor.valueBuffer("pagoindirectoprov")) {
        valor = sys.translate("Al incluir un recibo de proveedor en una remesa, el correspondiente asiento de pago se asigna a la subcuenta de Efectos comerciales de gestión de pago (E.C.G.P.) asociada a la cuenta bancaria de la remesa. Cuando se recibe la confirmación del banco el usuario inserta un registro de pago para la remesa completa, que lleva las partidas de E.C.G.P. a la subcuenta de la cuenta bancaria.");
      } else if (cursor.valueBuffer("pagodiferidoprov")) {
        valor = sys.translate("Al incluir un recibo de proveedor en una remesa, el correspondiente asiento de pago no se realiza. Cuando se recibe la confirmación del banco el usuario selecciona y marca como pagado cada uno de los recibos de proveedor, indicando su fecha de pago y generándose su correspondiente asiento.");
      } else {
        valor = sys.translate("Al incluir un recibo de proveedor en una remesa, el correspondiente asiento de pago se asigna directamente a la subcuenta de la cuenta bancaria indicada en la remesa.");
      }
      break;
    }
    default: {
      valor = _i.__calculateField(fN);
    }
  }
  return valor;
}

function remesasProv_habilitaPorPagoRemesaProv()
{
  var cursor = this.cursor();
  if (cursor.valueBuffer("pagodiferidoprov")) {
    this.child("fdbPagoIndirectoProv").setDisabled(false);
  } else {
    this.child("fdbPagoIndirectoProv").setDisabled(true);
  }
}

function remesasProv_init()
{
  var _i = this.iface;
  _i.__init();

  _i.bufferChanged("pagoindirectoprov");
  _i.habilitaPorPagoRemesaProv();
}
//// REMESAS PROVEEDOR //////////////////////////////////////////
/////////////////////////////////////////////////////////////////
