
/** @class_declaration asoPresup */
/////////////////////////////////////////////////////////////////
//// ASOCIAR PRESUPUESTOS ///////////////////////////////////////
class asoPresup extends oficial
{
  function asoPresup(context)
  {
    oficial(context);
  }
  function init()
  {
    return this.ctx.asoPresup_init();
  }
  function habilitacionesPedAuto()
  {
    return this.ctx.asoPresup_habilitacionesPedAuto();
  }
  function bufferChanged(fN: String)
  {
    return this.ctx.asoPresup_bufferChanged(fN);
  }
}
//// ASOCIAR PRESUPUESTOS ///////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition asoPresup */
/////////////////////////////////////////////////////////////////
//// ASOCIAR PRESUPUESTOS ///////////////////////////////////////
/** \C Si el pedido es automático (proviene de presupuestos), se bloquean cliertos datos para mantener su integridad
\end */
function asoPresup_init()
{
  this.iface.__init();
  if (this.cursor().valueBuffer("automatico") == true) {
    this.child("tabWidget3").setTabEnabled("presupuestos", true);
    this.child("tdbPresupuestos").setReadOnly(true);
  } else {
    this.child("tabWidget3").setTabEnabled("presupuestos", false);
  }
  this.iface.habilitacionesPedAuto();
}

function asoPresup_habilitacionesPedAuto()
{
  if (this.cursor().valueBuffer("automatico") == true) {
    this.child("toolButtomInsert").setDisabled(true);
    this.child("toolButtonDelete").setDisabled(true);
    this.child("toolButtonEdit").setDisabled(true);
    this.child("tdbLineasPedidosCli").setReadOnly(true);
    this.child("fdbCodCliente").setDisabled(true);
    this.child("fdbNombreCliente").setDisabled(true);
    this.child("fdbCifNif").setDisabled(true);
    this.child("fdbCodDivisa").setDisabled(true);
    this.child("fdbRecFinanciero").setDisabled(true);
    this.child("fdbTasaConv").setDisabled(true);
  } else {
    this.child("toolButtomInsert").setDisabled(false);
    this.child("toolButtonDelete").setDisabled(false);
    this.child("toolButtonEdit").setDisabled(false);
    this.child("tdbLineasPedidosCli").setReadOnly(false);
    this.child("fdbCodCliente").setDisabled(false);
    this.child("fdbNombreCliente").setDisabled(false);
    this.child("fdbCifNif").setDisabled(false);
    this.child("fdbCodDivisa").setDisabled(false);
    this.child("fdbRecFinanciero").setDisabled(false);
    this.child("fdbTasaConv").setDisabled(false);
  }
}

function asoPresup_bufferChanged(fN: String)
{
  switch (fN) {
    case "automatico": {
      this.iface.habilitacionesPedAuto();
      break;
    }
    default: {
      this.iface.__bufferChanged(fN);
      break;
    }
  }
}

//// ASOCIAR PRESUPUESTOS ///////////////////////////////////////
/////////////////////////////////////////////////////////////////
