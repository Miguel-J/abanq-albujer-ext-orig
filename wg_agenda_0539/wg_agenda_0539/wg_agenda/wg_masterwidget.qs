
/** @class_declaration wgAgenda */
//////////////////////////////////////////////////////////////////
//// WG_AGENDA ///////////////////////////////////////////////////
class wgAgenda extends oficial
{
  var fAgenda: Object = false;
  function wgAgenda(context)
  {
    oficial(context);
  }
  function lanzarWidget(): Boolean {
    return this.ctx.wgAgenda_lanzarWidget();
  }
  function lanzarWgAgenda(): Boolean {
    return this.ctx.wgAgenda_lanzarWgAgenda();
  }
}

//// WG_AGENDA ///////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////


/** @class_definition wgAgenda */
/////////////////////////////////////////////////////////////////
//// WG_AGENDA ///////////////////////////////////////////////////
function wgAgenda_lanzarWidget(): Boolean {
  if (!this.iface.__lanzarWidget())
  {
    return false;
  }

  if (!this.iface.lanzarWgAgenda())
  {
    return false;
  }
  return true;
}

function wgAgenda_lanzarWgAgenda(): Boolean {
  var util: FLUtil = new FLUtil();
  var idUsuario: String = sys.nameUser();
  var usuario: String = util.sqlSelect("usuarios", "idusuario", "idusuario = '" + idUsuario + "'");
  if (!usuario)
  {
    var res: Number = MessageBox.warning(util.translate("scripts", "El usuario actual no existe en la tabla de usuarios.\nDeberá registrarlo antes de utilizar su agenda"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  var activo: Boolean = util.sqlSelect("wg_agendaconfig", "activo", "idusuario = '" + idUsuario + "'");
  if (!activo)
  {
    return true;
  }

  if (this.iface.fAgenda == false)
  {
    this.iface.fAgenda = new FLFormDB("wg_agenda", 0, 1);
    this.iface.fAgenda.setMainWidget();
  } else {
    if (this.iface.fAgenda)
    {
      try {
        this.iface.fAgenda.close();
      } catch (e) {}
    }
    this.iface.fAgenda = new FLFormDB("wg_agenda", 0, 1);
    this.iface.fAgenda.setMainWidget();

  }
  this.iface.fAgenda.show();

  return true;
}

//// WG_AGENDA ///////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

