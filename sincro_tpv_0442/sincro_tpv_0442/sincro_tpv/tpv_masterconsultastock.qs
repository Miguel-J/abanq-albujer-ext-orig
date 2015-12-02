
/** @class_declaration sincroTPV */
/////////////////////////////////////////////////////////////////
//// SINCROO TPV ////////////////////////////////////////////////
class sincroTPV extends oficial
{
  function sincroTPV(context)
  {
    oficial(context);
  }
  function dameNuevaConsulta()
  {
    return this.ctx.sincroTPV_dameNuevaConsulta();
  }
  function controlCxCentral()
  {
    return this.ctx.sincroTPV_controlCxCentral();
  }
  function init()
  {
    return this.ctx.sincroTPV_init();
  }
}
//// SINCROO TPV ////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition sincroTPV */
/////////////////////////////////////////////////////////////////
//// SINCRO TPV /////////////////////////////////////////////////
function sincroTPV_init()
{
  var _i = this.iface;

  _i.__init();
  _i.controlCxCentral();
}

function sincroTPV_controlCxCentral()
{
  if (flfact_tpv.iface.pub_esUnaTienda()) {
    if (this.child("chkConsultaCentral")) {
      this.child("chkConsultaCentral").checked = true;
    }
  } else {
    if (this.child("chkConsultaCentral")) {
      this.child("chkConsultaCentral").close();
    }
  }
}

function sincroTPV_dameNuevaConsulta()
{
  if (!flfact_tpv.iface.pub_esUnaTienda()) {
    return new FLSqlQuery;
  }
  if (!this.child("chkConsultaCentral").checked) {
    return new FLSqlQuery;
  }
  if (!flfact_tpv.iface.pub_conectaCentral()) {
    MessageBox.warning(sys.translate("Error al conectar a la base de datos central"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return false;
  }
  return new FLSqlQuery("", flfact_tpv.iface.dameCxCentral());
}
//// SINCRO TPV /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
