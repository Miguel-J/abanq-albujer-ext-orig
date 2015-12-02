
/** @class_declaration alquiler */
/////////////////////////////////////////////////////////////////
//// ALQUILER ///////////////////////////////////////////////////
class alquiler extends oficial
{
  function alquiler(context)
  {
    oficial(context);
  }
  function init()
  {
    return this.ctx.alquiler_init();
  }
  function tbnCalendario_clicked()
  {
    return this.ctx.alquiler_tbnCalendario_clicked();
  }
  function dameFiltroReferencia()
  {
    return this.ctx.alquiler_dameFiltroReferencia();
  }
}
//// ALQUILER ///////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition alquiler */
/////////////////////////////////////////////////////////////////
//// ALQUILER ///////////////////////////////////////////////////
function alquiler_init()
{
  var _i = this.iface;
  _i.__init();

  connect(this.child("tbnCalendario"), "clicked()", _i, "tbnCalendario_clicked");
  var cursor = this.cursor();
  switch (cursor.modeAccess()) {
    case cursor.Edit: {
      break;
    }
  }
  _i.calculateField("sealquila");
  formRecordlineaspedidoscli.iface.pub_habilitaPorAlquiler(this);
}

function alquiler_tbnCalendario_clicked()
{
  formRecordlineaspedidoscli.iface.pub_commonTbnCalendario_clicked(this);
}

function alquiler_dameFiltroReferencia()
{
  return "(sevende OR sealquila)";
}
//// ALQUILER ///////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
