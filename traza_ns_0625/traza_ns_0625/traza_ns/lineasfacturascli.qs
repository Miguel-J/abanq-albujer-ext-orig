
/** @class_declaration trazaNS */
/////////////////////////////////////////////////////////////////
//// TRAZABILIDAD + NUMEROS SERIE ///////////////////////////////
class trazaNS extends funNumSerie
{
  function trazaNS(context)
  {
    funNumSerie(context);
  }
  function init()
  {
    return this.ctx.trazaNS_init();
  }
  function habilitarCantidadLotesNS()
  {
    return this.ctx.trazaNS_habilitarCantidadLotesNS();
  }
  function bufferChanged(fN: String)
  {
    return this.ctx.trazaNS_bufferChanged(fN);
  }
}
//// TRAZABILIDAD + NUMEROS SERIE ///////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition trazaNS */
/////////////////////////////////////////////////////////////////
//// TRAZABILIDAD + NUMEROS SERIE ///////////////////////////////
function trazaNS_init()
{
  this.iface.__init();
  this.iface.habilitarCantidadLotesNS();
}

function trazaNS_habilitarCantidadLotesNS()
{
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  var porNS: Boolean = util.sqlSelect("articulos", "controlnumserie", "referencia = '" + cursor.valueBuffer("referencia") + "'");
  this.child("fdbCantidad").setDisabled(this.iface.porLotes || porNS);
}

function trazaNS_bufferChanged(fN: String)
{
  switch (fN) {
    case "referencia": {
      this.iface.__bufferChanged(fN);
      this.iface.habilitarCantidadLotesNS()
      break;
    }
    default: {
      this.iface.__bufferChanged(fN);
    }
  }
}
//// TRAZABILIDAD + NUMEROS SERIE ///////////////////////////////
/////////////////////////////////////////////////////////////////
