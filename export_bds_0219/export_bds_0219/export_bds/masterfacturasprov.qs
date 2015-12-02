
/** @class_declaration exportDatosFC */
/////////////////////////////////////////////////////////////////
//// EXPORT DATOS FC //////////////////////////////////////////////////////
class exportDatosFC extends oficial
{
  var leFE: Object;
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

  this.iface.leFE = this.child("leFE");
  connect(this.iface.tdbRecords, "currentChanged()", this, "iface.comprobarBloqueo");
}

function exportDatosFC_comprobarBloqueo()
{
  var util: FLUtil = new FLUtil();
  if (util.sqlSelect("registrosexportados", "id", "tabla = 'facturasprov' AND clave = '" + this.cursor().valueBuffer("codigo") + "'")) {
    this.iface.tdbRecords.setInsertOnly(true);
    this.iface.leFE.text = "FACTURA\nEXPORTADA";
  } else {
    this.iface.tdbRecords.setInsertOnly(false);
    this.iface.leFE.text = "";
  }
}
//// EXPORT DATOS FC //////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
