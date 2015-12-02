
/** @class_declaration importDatosFC */
/////////////////////////////////////////////////////////////////
//// IMPORT DATOS FC //////////////////////////////////////////////
class importDatosFC extends oficial
{
  var tdbRecords: FLTableDB;
  var lePR: Object;
  function importDatosFC(context)
  {
    oficial(context);
  }
  function init()
  {
    this.ctx.importDatosFC_init();
  }
  function controlPagos()
  {
    return this.ctx.importDatosFC_controlPagos();
  }
}
//// IMPORT DATOS FC //////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition importDatosFC */
/////////////////////////////////////////////////////////////////
//// IMPORT DATOS FC //////////////////////////////////////////////

function importDatosFC_init()
{
  this.iface.__init();

  this.iface.tdbRecords = this.child("tdbPagosDevolCli");
  this.iface.lePR = this.child("lePR");
  this.iface.controlPagos();
}

/** \D Si alguno de los pagos/devoluciones existe en la tabla de correspondencias, ha sido importado
En este caso no se pueden modificar pagos.
*/

function importDatosFC_controlPagos()
{
  var util: FLUtil = new FLUtil;
  if (util.sqlSelect("correspondenciasreg", "id", "tabla = 'pagosdevolcli' AND claveloc IN (select cast (idpagodevol as text) from pagosdevolcli where idrecibo = " + this.cursor().valueBuffer("idrecibo") + ")")) {
    this.iface.tdbRecords.setReadOnly(true);
    this.iface.lePR.text = "PAGOS EN REMOTO";
  }
}

//// IMPORT DATOS FC //////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
