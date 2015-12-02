
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
    return this.ctx.exportDatosFC_procesarEstado();
  }
}
//// EXPORT DATOS FC //////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition exportDatosFC */
/////////////////////////////////////////////////////////////////
//// EXPORT DATOS FC //////////////////////////////////////////////////////
function exportDatosFC_init()
{
  this.iface.leFE = this.child("leFE");
  this.iface.__init();
}

function exportDatosFC_procesarEstado()
{
  if (this.cursor().valueBuffer("ptefactura") == true)
    this.iface.pbnGFactura.setDisabled(false);
  else
    this.iface.pbnGFactura.setDisabled(true);

  var util: FLUtil = new FLUtil();
  if (util.sqlSelect("registrosexportados", "id", "tabla = 'albaranescli' AND clave = '" + this.cursor().valueBuffer("codigo") + "'")) {
    //    this.iface.tdbRecords.setInsertOnly(true);
    this.iface.leFE.text = "ALBARAN\nEXPORTADO";
  } else {
    //    this.iface.tdbRecords.setInsertOnly(false);
    this.iface.leFE.text = "";
  }
}
//// EXPORT DATOS FC //////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
