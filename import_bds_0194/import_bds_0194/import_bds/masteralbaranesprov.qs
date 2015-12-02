
/** @class_declaration importDatosFC */
/////////////////////////////////////////////////////////////////
//// IMPORT DATOS FC //////////////////////////////////////////////////////
class importDatosFC extends oficial
{
  var leAI: Object;
  function importDatosFC(context)
  {
    oficial(context);
  }
  function init()
  {
    this.ctx.importDatosFC_init();
  }
  function procesarEstado()
  {
    return this.ctx.importDatosFC_procesarEstado();
  }
}
//// IMPORT DATOS FC //////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition importDatosFC */
/////////////////////////////////////////////////////////////////
//// IMPORT DATOS FC //////////////////////////////////////////////////////
function importDatosFC_init()
{
  this.iface.leAI = this.child("leAI");
  this.iface.__init();
}

function importDatosFC_procesarEstado()
{
  var util: FLUtil = new FLUtil();
  if (util.sqlSelect("seriesimportables", "codserie", "codserie = '" + this.cursor().valueBuffer("codserie") + "'")) {
    this.iface.tdbRecords.setReadOnly(true);
    this.iface.leAI.text = "ALBARAN\nIMPORTADO";
  } else {
    this.iface.tdbRecords.setReadOnly(false);
    this.iface.leAI.text = "";
  }

  if (this.cursor().valueBuffer("ptefactura") == true)
    this.iface.pbnGFactura.setDisabled(false);
  else
    this.iface.pbnGFactura.setDisabled(true);
}
//// IMPORT DATOS FC //////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
