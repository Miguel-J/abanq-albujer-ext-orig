
/** @class_declaration sincro */
/////////////////////////////////////////////////////////////////
//// SINCRO TPV /////////////////////////////////////////////////
class sincro extends oficial
{

  function sincro(context)
  {
    oficial(context);
  }
  function init()
  {
    return this.ctx.sincro_init();
  }
  function tbnSincroFacturacion_clicked()
  {
    return this.ctx.sincro_tbnSincroFacturacion_clicked();
  }
}

//// SINCRO TPV /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition sincro */
/////////////////////////////////////////////////////////////////
//// SINCRO TPV /////////////////////////////////////////////////

function sincro_init()
{
  var _i = this.iface;
  _i.__init();

  var tienda = flfact_tpv.iface.pub_valorDefectoTPV("tiendasincro");
  if (tienda) {
    this.child("tbnSincroFacturacion").close();
  } else {
    connect(this.child("tbnSincroFacturacion"), "clicked()", _i, "tbnSincroFacturacion_clicked");
  }
}

function sincro_tbnSincroFacturacion_clicked()
{
  var _i = this.iface;
  var cursor = this.cursor();

  var i = 0;
  var curComanda = new FLSqlCursor("tpv_comandas");
  curComanda.select("ptesincrofactura");
  while (curComanda.next()) {
    curComanda.setModeAccess(curComanda.Edit);
    curComanda.refreshBuffer();
    curComanda.setValueBuffer("ptesincrofactura", false);
    if (!curComanda.commitBuffer()) {
      MessageBox.warning(sys.translate("Ha habido un error al realizar la factura de la venta %1").arg(curComanda.valueBuffer("codigo")), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton, "AbanQ");
      return;
    }
    i++;
  }
  MessageBox.warning(sys.translate("Se han generado %1 facturas de cliente").arg(i), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton, "AbanQ");
}

//// SINCRO TPV /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
