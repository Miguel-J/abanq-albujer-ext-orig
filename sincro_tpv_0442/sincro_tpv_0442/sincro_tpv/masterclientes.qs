
/** @class_declaration sincroTpv */
/////////////////////////////////////////////////////////////////
//// SINCRO TPV /////////////////////////////////////////////////
class sincroTpv extends oficial
{
  function sincroTpv(context)
  {
    oficial(context);
  }
  function ordenColumnas()
  {
    return this.ctx.sincroTpv_ordenColumnas();
  }
  function init()
  {
    return this.ctx.sincroTpv_init();
  }
}
//// SINCRO TPV /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition sincroTpv */
/////////////////////////////////////////////////////////////////
//// SINCRO TPV /////////////////////////////////////////////////
function sincroTpv_ordenColumnas()
{
  if (sys.isLoadedModule("flfact_tpv")) {
    var esTienda = flfact_tpv.iface.pub_valorDefectoTPV("tiendasincro");
    if (esTienda) {
      return ["cifnif", "nombre"];
    }
  }
  return ["nombre", "cifnif"];
}

function sincroTpv_init()
{
  var _i = this.iface;
  _i.__init();

  if (flfact_tpv.iface.pub_esUnaTienda()) {
    this.child("tableDBRecords").setReadOnly(true);
  }
}
//// SINCRO TPV /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
