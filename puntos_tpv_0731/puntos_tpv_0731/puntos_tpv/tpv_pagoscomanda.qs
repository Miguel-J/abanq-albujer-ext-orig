
/** @class_declaration puntosTpv */
//////////////////////////////////////////////////////////////////
//// PUNTOSTPV ///////////////////////////////////////////////////
class puntosTpv extends oficial
{
  var codPagoPuntos;
  function puntosTpv(context)
  {
    oficial(context);
  }
  function calculateField(fN)
  {
    return this.ctx.puntosTpv_calculateField(fN);
  }
  function bufferChanged(fN)
  {
    return this.ctx.puntosTpv_bufferChanged(fN);
  }
  function habilitarFormaPago()
  {
    return this.ctx.puntosTpv_habilitarFormaPago();
  }
}
//// PUNTOSTPV ///////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////


/** @class_definition puntosTpv */
/////////////////////////////////////////////////////////////////
//// PUNTOS TPV /////////////////////////////////////////////////
function puntosTpv_bufferChanged(fN)
{
  var _i = this.iface;
  var cursor = this.cursor();
  switch (fN) {
    case "codtarjetapuntos": {
      this.child("fdbImporte").setValue(_i.calculateField("importe"));
      break;
    }
    default: {
      _i.__bufferChanged(fN);
    }
  }
}

function puntosTpv_calculateField(fN)
{
  var _i = this.iface;
  var valor;
  var cursor = this.cursor();

  switch (fN) {
    case "importe": {
      var codTajetaPuntos = cursor.valueBuffer("codtarjetapuntos");
      if (codTajetaPuntos && codTajetaPuntos != "") {
        var pendiente = parseFloat(cursor.cursorRelation().valueBuffer("pendiente"));
        var saldoPuntos = AQUtil.sqlSelect("tpv_tarjetaspuntos", "saldopuntos", "codtarjetapuntos = '" + codTajetaPuntos + "'");
        if (parseFloat(saldoPuntos) > 0) {
          if (saldoPuntos && (parseFloat(saldoPuntos) < parseFloat(pendiente))) {
            pendiente = saldoPuntos;
          }
          valor = pendiente;
        } else {
          MessageBox.warning(sys.translate("La tarjeta seleccionada no tiene puntos positivos para pagar."), MessageBox.Ok, MessageBox.NoButton);
          valor = 0;
        }
      } else {
        valor = _i.__calculateField(fN);
      }
      break;
    }
  }
  return valor;

}

function puntosTpv_habilitarFormaPago()
{
  var _i = this.iface;
  var cursor = this.cursor();

  var codPago = cursor.valueBuffer("codpago");
  var puntos = flfact_tpv.iface.pub_valorDefectoTPV("pagopunto");

  switch (codPago) {
    case puntos: {
      this.child("fdbRefVale").setDisabled(true);
      this.child("fdbCodTarjetaPago").setDisabled(true);
      this.child("fdbCodTarjetaPuntos").setDisabled(false);
      break
    }
    default: {
      _i.__habilitarFormaPago();
      sys.setObjText(this, "fdbCodTarjetaPuntos", "");
      this.child("fdbCodTarjetaPuntos").setDisabled(true);
    }
  }
}
//// PUNTOS TPV /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
