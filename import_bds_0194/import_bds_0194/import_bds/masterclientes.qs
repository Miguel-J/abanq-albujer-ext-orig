
/** @class_declaration importDatosFC */
/////////////////////////////////////////////////////////////////
//// IMPORT DATOS FC //////////////////////////////////////////////////////
class importDatosFC extends oficial
{
  var leCI: Object;
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

  this.iface.tdbRecords = this.child("tableDBRecords");
  this.iface.leCI = this.child("leCI");

  connect(this.iface.tdbRecords, "currentChanged()", this, "iface.comprobarBloqueo");
}

/** \D Si el código de cliente está en las correspondencias, ha sido importado
*/
function importDatosFC_comprobarBloqueo()
{
  var util: FLUtil = new FLUtil();
  if (util.sqlSelect("correspondenciasreg", "id", "tabla = 'clientes' and claveloc = '" + this.cursor().valueBuffer("codcliente") + "'")) {
    //    this.iface.tdbRecords.setInsertOnly(true);
    this.iface.leCI.text = "CLIENTE\nIMPORTADO";
  } else {
    //    this.iface.tdbRecords.setInsertOnly(false);
    this.iface.leCI.text = "";
  }
}

//// IMPORT DATOS FC //////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
