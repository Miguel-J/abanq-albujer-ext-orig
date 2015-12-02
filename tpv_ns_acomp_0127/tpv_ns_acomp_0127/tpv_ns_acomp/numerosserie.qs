
/** @class_declaration tpvNsAcomp */
/////////////////////////////////////////////////////////////////
//// TPV_NS_ACOMP ///////////////////////////////////////////////
class tpvNsAcomp extends oficial
{
  function tpvNsAcomp(context)
  {
    oficial(context);
  }
  function init()
  {
    this.ctx.tpvNsAcomp_init();
  }
  function verComanda()
  {
    return this.ctx.tpvNsAcomp_verComanda();
  }
}
//// TPV_NS_ACOMP ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition tpvNsAcomp */
//////////////////////////////////////////////////////////////////
//// TPV_NS_ACOMP ////////////////////////////////////////////////

function tpvNsAcomp_init()
{
  this.iface.__init();

  var util: FLUtil = new FLUtil();
  connect(this.child("pbnVerComanda"), "clicked()", this, "iface.verComanda");

  var dato: String;
  dato = util.sqlSelect("tpv_comandas", "codigo", "idtpv_comanda = " + this.cursor().valueBuffer("idcomandaventa"));
  if (dato)
    this.child("leComanda").text = util.translate("scripts", "Comanda TPV") + " " + dato;
}

function tpvNsAcomp_verComanda()
{
  var curTab: FLSqlCursor = new FLSqlCursor("tpv_comandas");
  curTab.select("idtpv_comanda = " + this.cursor().valueBuffer("idcomandaventa"));
  if (curTab.first()) {
    curTab.setModeAccess(curTab.Browse);
    curTab.refreshBuffer();
    curTab.browseRecord();
  }
}

//// TPV_NS_ACOMP ////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
