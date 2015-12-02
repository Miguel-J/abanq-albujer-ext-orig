
/** @class_declaration extraescolar */
/////////////////////////////////////////////////////////////////
//// EXTRAESCOLAR //////////////////////////////////////////////
class extraescolar extends ivaIncluido
{
  function extraescolar(context)
  {
    ivaIncluido(context);
  }
  function init()
  {
    return this.ctx.extraescolar_init();
  }
  function commonBufferChanged(fN, miForm)
  {
    return this.ctx.extraescolar_commonBufferChanged(fN, miForm);
  }
  function obtenerTarifa(codCliente, cursor)
  {
    return this.ctx.extraescolar_obtenerTarifa(codCliente, cursor);
  }
  function commonCalculateField(fN, cursor)
  {
    return this.ctx.extraescolar_commonCalculateField(fN, cursor);
  }
}
//// EXTRAESCOLAR //////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition extraescolar */
/////////////////////////////////////////////////////////////////
//// EXTRAESCOLAR //////////////////////////////////////////////
function extraescolar_init()
{
  this.iface.__init();
}

function extraescolar_commonBufferChanged(fN, miForm)
{
  var cursor = miForm.cursor();
  switch (fN) {
    default: {
      this.iface.__commonBufferChanged(fN, miForm);
    }
  }
}

function extraescolar_commonCalculateField(fN, cursor)
{
  var util = new FLUtil;
  var valor;

  switch (fN) {
    case "pvpunitario":
    case "pvpunitarioiva": { /// En el TPV sólo se calcula el precio de los artículos asociados a la tarifa de venta
      if (cursor.table() == "tpv_lineascomanda") {
        var referencia = cursor.valueBuffer("referencia");
        var curRel = cursor.cursorRelation();
        var codTarifa = curRel ? curRel.valueBuffer("codtarifa") : util.sqlSelect("tpv_comandas", "codtarifa", "idtpv_comanda = " + cursor.valueBuffer("idtpv_comanda"));
        if (codTarifa && codTarifa != "") {
          if (!util.sqlSelect("articulostarifas", "referencia", "codtarifa = '" + codTarifa + "' AND referencia = '" + referencia + "'")) {
            valor = 0
                    break;
          }
        }
      }
      valor = this.iface.__commonCalculateField(fN, cursor);
      break;
    }
    default: {
      valor = this.iface.__commonCalculateField(fN, cursor);
    }
  }
  return valor;
}

function extraescolar_obtenerTarifa(codCliente, cursor)
{
  var util = new FLUtil;
  var codTarifa;
  switch (cursor.table()) {
    default: {
      codTarifa = this.iface.__obtenerTarifa(codCliente, cursor);
    }
  }
  return codTarifa;
}
//// EXTRAESCOLAR //////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
