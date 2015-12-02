
/** @class_declaration navegador */
/////////////////////////////////////////////////////////////////
//// CONF NAVEGADOR /////////////////////////////////////////////
class navegador extends oficial
{
  function navegador(context)
  {
    oficial(context);
  }
  function init()
  {
    return this.ctx.navegador_init();
  }
  function cambiarNavegador()
  {
    return this.ctx.navegador_cambiarNavegador();
  }
}
//// CONF NAVEGADOR /////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition navegador */
/////////////////////////////////////////////////////////////////
//// CONF NAVEGADOR /////////////////////////////////////////////
function navegador_init()
{
  this.iface.__init();

  var util: FLUtil = new FLUtil();
  this.child("lblNombreNavegador").text = util.readSettingEntry("scripts/flfactinfo/nombrenavegador");
  connect(this.child("pbnCambiarNavegador"), "clicked()", this, "iface.cambiarNavegador");
}

function navegador_cambiarNavegador()
{
  var util: FLUtil = new FLUtil();
  var nombreNavegador: String = Input.getText(util.translate("scripts", "Nombre del navegador o ruta de acceso:"));
  if (!nombreNavegador) {
    return;
  }

  this.child("lblNombreNavegador").text = nombreNavegador;
  util.writeSettingEntry("scripts/flfactinfo/nombrenavegador", nombreNavegador);
}

//// CONF NAVEGADOR /////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
