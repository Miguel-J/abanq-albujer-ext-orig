
/** @class_declaration nsServicios */
//////////////////////////////////////////////////////////////////
//// NS_SERVICIOS /////////////////////////////////////////////////////
class nsServicios extends oficial
{
  function nsServicios(context)
  {
    oficial(context);
  }
  function init()
  {
    return this.ctx.nsServicios_init();
  }
  function verServicioCli()
  {
    return this.ctx.nsServicios_verServicioCli();
  }
}
//// NS_SERVICIOS /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_definition nsServicios */
/////////////////////////////////////////////////////////////////
//// NS_SERVICIOS /////////////////////////////////////////////////

function nsServicios_init()
{
  this.iface.__init();

  connect(this.child("pbnVerServicioCli"), "clicked()", this, "iface.verServicioCli");

  var util: FLUtil = new FLUtil();
  var dato: String;

  dato = util.sqlSelect("servicioscli", "numservicio", "idservicio = " + this.cursor().valueBuffer("idservicioventa"));
  if (dato)
    this.child("leServicioVenta").text = util.translate("scripts", "Servicio") + " " + dato;
}

function nsServicios_verServicioCli()
{
  var curTab: FLSqlCursor = new FLSqlCursor("servicioscli");
  curTab.select("idservicio = " + this.cursor().valueBuffer("idservicioventa"));
  if (curTab.first()) {
    curTab.setModeAccess(curTab.Browse);
    curTab.refreshBuffer();
    curTab.browseRecord();
  }
}

//// NS_SERVICIOS /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
