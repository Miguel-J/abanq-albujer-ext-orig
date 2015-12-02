
/** @class_declaration exportDatosFC */
/////////////////////////////////////////////////////////////////
//// EXPORT DATOS FC //////////////////////////////////////
class exportDatosFC extends oficial
{
  var leCE: Object;
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
///////////////////////////////////////////////////////////////////
//// EXPORT DATOS FC ////////////////////////////////////////

function exportDatosFC_init()
{
  this.iface.__init();

  this.iface.tdbRecords = this.child("tableDBRecords");
  this.iface.leCE = this.child("leCE");

  connect(this.iface.tdbRecords, "currentChanged()", this, "iface.comprobarBloqueo");
}

/** \D Si el código de cliente está en las correspondencias, ha sido exportado
*/
function exportDatosFC_comprobarBloqueo()
{
  var util: FLUtil = new FLUtil();
  if (util.sqlSelect("registrosexportados", "id", "tabla = 'clientes' AND clave = '" + this.cursor().valueBuffer("codcliente") + "'")) {
    this.iface.leCE.text = "CLIENTE\nEXPORTADO";
  } else {
    this.iface.leCE.text = "";
  }
}

//// EXPORT DATOS FC ///////////////////////////////////////
/////////////////////////////////////////////////////////////////
