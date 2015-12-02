
/** @class_declaration importDatosFC */
/////////////////////////////////////////////////////////////////
//// IMPORT DATOS FC //////////////////////////////////////////////////////
class importDatosFC extends oficial
{
  var leRI: Object;
  var tdbRecords: FLTableDB;
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

  this.iface.leRI = this.child("leRI");
  this.iface.tdbRecords = this.child("tableDBRecords");
  connect(this.iface.tdbRecords, "currentChanged()", this, "iface.comprobarBloqueo");
}

function importDatosFC_comprobarBloqueo()
{
  var util: FLUtil = new FLUtil();
  if (util.sqlSelect("correspondenciasreg", "id", "tabla = 'remesas' and claveloc = '" + this.cursor().valueBuffer("idremesa") + "'")) {
    this.iface.tdbRecords.setInsertOnly(true);
    this.iface.leRI.text = "REMESA\nIMPORTADA";
  } else {
    this.iface.tdbRecords.setInsertOnly(false);
    this.iface.leRI.text = "";
  }
}
//// IMPORT DATOS FC //////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
