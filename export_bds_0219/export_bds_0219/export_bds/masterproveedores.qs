
/** @class_declaration exportDatosFC */
/////////////////////////////////////////////////////////////////
//// EXPORT DATOS FC //////////////////////////////////////
class exportDatosFC extends oficial
{
  var lePE: Object;
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
//// EXPORT DATOS FC ///////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition exportDatosFC */
/////////////////////////////////////////////////////////////////
//// EXPORT DATOS FC //////////////////////////////////////
function exportDatosFC_init()
{
  this.iface.__init();

  this.iface.tdbRecords = this.child("tableDBRecords");
  this.iface.lePE = this.child("lePE");

  connect(this.iface.tdbRecords, "currentChanged()", this, "iface.comprobarBloqueo");
}

/** \D Si el código de cliente está en las correspondencias, ha sido exportado
*/
function exportDatosFC_comprobarBloqueo()
{
  var util: FLUtil = new FLUtil();
  if (util.sqlSelect("registrosexportados", "id", "tabla = 'proveedores' AND clave = '" + this.cursor().valueBuffer("codproveedor") + "'")) {
    this.iface.lePE.text = "PROVEEDOR\nEXPORTADO";
  } else {
    this.iface.lePE.text = "";
  }
}

//// EXPORT DATOS FC ///////////////////////////////////////
/////////////////////////////////////////////////////////////////
