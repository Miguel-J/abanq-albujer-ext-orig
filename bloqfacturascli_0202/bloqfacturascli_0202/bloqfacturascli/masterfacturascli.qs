
/** @class_declaration bloqFacturasCli */
/////////////////////////////////////////////////////////////////
//// BLOQFACCLI //////////////////////////////////////////////////////
class bloqFacturasCli extends oficial
{
  function bloqFacturasCli(context)
  {
    oficial(context);
  }
  var leFB: Object;
  function init()
  {
    this.ctx.bloqFacturasCli_init();
  }
  function comprobarBloqueo()
  {
    this.ctx.bloqFacturasCli_comprobarBloqueo();
  }
}
//// BLOQFACCLI //////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition bloqFacturasCli */
/////////////////////////////////////////////////////////////////
//// BLOQFACCLI //////////////////////////////////////////////////////
function bloqFacturasCli_init()
{
  this.iface.__init();

  this.iface.leFB = this.child("leFB");
  connect(this.iface.tdbRecords, "currentChanged()", this, "iface.comprobarBloqueo");
}

function bloqFacturasCli_comprobarBloqueo()
{
  var util: FLUtil = new FLUtil;
  if (util.sqlSelect("facturasbloqueadas", "codfactura", "codfactura = '" + this.cursor().valueBuffer("codigo") + "'")) {
    this.iface.tdbRecords.setInsertOnly(true);
    this.iface.leFB.text = "FACTURA\nBLOQUEADA";
  } else {
    this.iface.tdbRecords.setInsertOnly(false);
    this.iface.leFB.text = "";
  }
}
//// BLOQFACCLI //////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
