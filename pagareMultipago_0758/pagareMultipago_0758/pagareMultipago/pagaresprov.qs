
/** @class_declaration pagaresMultipago */
/////////////////////////////////////////////////////////////////
//// PAGARES MULTIPAGO  /////////////////////////////////////////
class pagaresMultipago extends oficial
{

  function pagaresMultipago(context)
  {
    oficial(context);
  }
  function init()
  {
    this.ctx.pagaresMultipago_init();
  }
  function commonCalculateField(fN, cursor)
  {
    return this.ctx.pagaresMultipago_commonCalculateField(fN, cursor);
  }
}

//// PAGARES MULTIPAGO  /////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition pagaresMultipago */
/////////////////////////////////////////////////////////////////
//// PAGARES MULTIPAGO //////////////////////////////////////////

function pagaresMultipago_init()
{
  var _i = this.iface;
  var cursor = this.cursor();

  _i.__init();

}

function pagaresMultipago_commonCalculateField(fN, cursor)
{
  var _i = this.iface;

  var res;
  switch (fN) {
    case "estado": {
      var sumPagados = AQUtil.sqlSelect("pagospagareprov", "SUM(importe)", "tipo = 'Pago' AND estado = 'Pagado'");
      var sumDevueltos = AQUtil.sqlSelect("pagospagareprov", "SUM(importe)", "tipo = 'Devolución'");

      if (!sumPagados && !sumDevueltos) {
        res = "Emitido";
        break;
      } else {
        if (isNaN(sumPagados)) {
          sumPagados = 0;
        }
        if (isNaN(sumDevueltos)) {
          sumDevueltos = 0;
        }
        res = parseFloat(sumPagados) - parseFloat(sumDevueltos);
        if (res < 0) {
          res = 0;
        }

        switch (res) {
          case 0: {
            res = "Devuelto";
            break;
          }
          case parseFloat(cursor.valueBuffer("total")): {
            res = "Pagado";
            break;
          }
          default: {
            res = "Emitido";
          }
        }
      }
      break;
    }
    default: {
      res = _i.__commonCalculateField(fN, cursor);
    }
  }
  return res;
}
//// PAGARES MULTIPAGO //////////////////////////////////////////
/////////////////////////////////////////////////////////////////
