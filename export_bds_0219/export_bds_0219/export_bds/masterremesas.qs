
/** @class_declaration exportDatosFC */
/////////////////////////////////////////////////////////////////
//// EXPORT DATOS FC //////////////////////////////////////////////////////
class exportDatosFC extends oficial
{
  var leRE: Object;
  var tdbRecords: FLTableDB;
  function exportDatosFC(context)
  {
    oficial(context);
  }
  function init()
  {
    this.ctx.exportDatosFC_init();
  }
  function comprobarBloqueo()
  {
    this.ctx.exportDatosFC_comprobarBloqueo();
  }
}
//// EXPORT DATOS FC //////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition exportDatosFC */
/////////////////////////////////////////////////////////////////
//// EXPORT DATOS FC //////////////////////////////////////////////////////
function exportDatosFC_init()
{
  this.iface.__init();

  this.iface.leRE = this.child("leRE");
  this.iface.tdbRecords = this.child("tableDBRecords");
  connect(this.iface.tdbRecords, "currentChanged()", this, "iface.comprobarBloqueo");
}

function exportDatosFC_comprobarBloqueo()
{
  var util: FLUtil = new FLUtil();
  if (util.sqlSelect("registrosexportados", "id", "tabla = 'remesas' AND clave = '" + this.cursor().valueBuffer("idremesa") + "'")) {
    this.iface.tdbRecords.setInsertOnly(true);
    this.iface.leRE.text = "REMESA\nEXPORTADA";
  } else {
    this.iface.tdbRecords.setInsertOnly(false);
    this.iface.leRE.text = "";
  }
}
//// EXPORT DATOS FC //////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
