
/** @class_declaration wgAgenda */
/////////////////////////////////////////////////////////////////
//// WG_AGENDA //////////////////////////////////////////////////
class wgAgenda extends oficial
{
  function wgAgenda(context)
  {
    oficial(context);
  }
  function init()
  {
    return this.ctx.wgAgenda_init();
  }
  function configurarAgendaUsuario()
  {
    return this.ctx.wgAgenda_configurarAgendaUsuario();
  }
}
//// WG_AGENDA //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition wgAgenda */
/////////////////////////////////////////////////////////////////
//// WG_AGENDA ///////////////////////////////////////////////////
function wgAgenda_init()
{
  var cursor: FLSqlCursor = this.cursor();
  connect(this.child("tbnConfigurarAgenda"), "clicked()", this, "iface.configurarAgendaUsuario()");
  if (cursor.modeAccess() == cursor.Insert) {
    this.child("tbnConfigurarAgenda").setDisabled(true);
  } else {
    this.child("tbnConfigurarAgenda").setDisabled(false);
  }
}

function wgAgenda_configurarAgendaUsuario()
{
  formRecordwg_agenda.iface.configurarAgenda();
}

//// WG_AGENDA ///////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
