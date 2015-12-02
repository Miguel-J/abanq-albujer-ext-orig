
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
  function procesarEstado()
  {
    this.ctx.exportDatosFC_procesarEstado();
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
}

function exportDatosFC_procesarEstado()
{
  if (this.cursor().valueBuffer("ptefactura") == true)
    this.iface.pbnGFactura.setEnabled(true);
  else
    this.iface.pbnGFactura.setEnabled(false);

  var util: FLUtil = new FLUtil();
  if (util.sqlSelect("registrosexportados", "id", "tabla = 'albaranesprov' AND clave = '" + this.cursor().valueBuffer("codigo") + "'")) {
    this.child("leFE").text = "ALBARAN\nEXPORTADO";
    this.iface.tdbRecords.setInsertOnly(true);

  } else {
    this.child("leFE").text = "";
    this.iface.tdbRecords.setInsertOnly(false);
  }
}
//// EXPORT DATOS FC //////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
