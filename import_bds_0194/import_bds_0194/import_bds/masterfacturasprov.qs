
/** @class_declaration importDatosFC */
/////////////////////////////////////////////////////////////////
//// IMPORT DATOS FC //////////////////////////////////////////////////////
class importDatosFC extends oficial
{
  var leSI: Object;
  function importDatosFC(context)
  {
    oficial(context);
  }
  function init()
  {
    this.ctx.importDatosFC_init();
  }
  function comprobarBloqueo()
  {
    this.ctx.importDatosFC_comprobarBloqueo();
  }
}
//// IMPORT DATOS FC //////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition importDatosFC */
/////////////////////////////////////////////////////////////////
//// IMPORT DATOS FC //////////////////////////////////////////////////////
function importDatosFC_init()
{
  this.iface.__init();

  this.iface.leSI = this.child("leSI");
  connect(this.iface.tdbRecords, "currentChanged()", this, "iface.comprobarBloqueo");
}

function importDatosFC_comprobarBloqueo()
{
  var util: FLUtil = new FLUtil();
  if (util.sqlSelect("seriesimportables", "codserie", "codserie = '" + this.cursor().valueBuffer("codserie") + "'")) {
    this.iface.tdbRecords.setInsertOnly(true);
    this.iface.leSI.text = "FACTURA\nIMPORTADA";
  } else {
    this.iface.tdbRecords.setInsertOnly(false);
    this.iface.leSI.text = "";
  }
}
//// IMPORT DATOS FC //////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
