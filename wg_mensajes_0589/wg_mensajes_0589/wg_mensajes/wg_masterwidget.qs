
/** @class_declaration wgMensajes */
/////////////////////////////////////////////////////////////////
//// WG_MENSAJES ////////////////////////////////////////////////
class wgMensajes extends oficial
{
  var fMensaje: Object = false;
  function wgMensajes(context)
  {
    oficial(context);
  }
  function lanzarWidget(): Boolean {
    return this.ctx.wgMensajes_lanzarWidget();
  }
  function lanzarWgMensajes(): Boolean {
    return this.ctx.wgMensajes_lanzarWgMensajes();
  }
}
//// WG_MENSAJES ////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition wgMensajes */
/////////////////////////////////////////////////////////////////
//// WG_MENSAJES ////////////////////////////////////////////////
function wgMensajes_lanzarWidget(): Boolean {
  if (!this.iface.__lanzarWidget())
  {
    return false;
  }

  if (!this.iface.lanzarWgMensajes())
  {
    return false;
  }
  return true;
}

function wgMensajes_lanzarWgMensajes(): Boolean {
  var util: FLUtil = new FLUtil();
  var idUsuario: String = sys.nameUser();
  var usuario: String = util.sqlSelect("usuarios", "idusuario", "idusuario = '" + idUsuario + "'");
  if (!usuario)
  {
    var res: Number = MessageBox.warning(util.translate("scripts", "El usuario actual no existe en la tabla de usuarios.\nDeberá registrarlo antes de mandar un mensaje"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }

  if (this.iface.fMensaje == false)
  {
    this.iface.fMensaje = new FLFormDB("wg_mensajes", 0, 1);
    this.iface.fMensaje.setMainWidget();
  } else {
    if (this.iface.fMensaje)
    {
      try {
        this.iface.fMensaje.close();
      } catch (e) {}
    }
    this.iface.fMensaje = new FLFormDB("wg_mensajes", 0, 1);
    this.iface.fMensaje.setMainWidget();
  }
  this.iface.fMensaje.show();

  return true;
}

//// WG_MENSAJES ////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
