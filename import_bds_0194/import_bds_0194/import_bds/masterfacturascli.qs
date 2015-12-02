
/** @class_declaration importDatosFC */
/////////////////////////////////////////////////////////////////
//// IMPORT DATOS FC //////////////////////////////////////////////////////
class importDatosFC extends bloqFacturasCli
{
  var leSI: Object;
  function importDatosFC(context)
  {
    bloqFacturasCli(context);
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
}

function importDatosFC_comprobarBloqueo()
{
  var util: FLUtil = new FLUtil();

  if (util.sqlSelect("facturasbloqueadas", "codfactura", "codfactura = '" + this.cursor().valueBuffer("codigo") + "'")) {
    this.iface.tdbRecords.setInsertOnly(true);
    this.iface.leFB.text = "FACTURA\nBLOQUEADA";
  } else {
    this.iface.tdbRecords.setInsertOnly(false);
    this.iface.leFB.text = "";
  }

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
