
/** @class_declaration extra */
/////////////////////////////////////////////////////////////////
//// EXTRAESC0LAR ///////////////////////////////////////////////
class extra extends oficial
{
  function extra(context)
  {
    oficial(context);
  }
  function init()
  {
    return this.ctx.extra_init();
  }
  function controlCentroUsuario()
  {
    return this.ctx.extra_controlCentroUsuario();
  }
}
//// EXTRAESC0LAR ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition extra */
/////////////////////////////////////////////////////////////////
//// EXTRAESCOLAR ///////////////////////////////////////////////
function extra_init()
{
  var _i = this.iface;

  _i.__init();
  _i.controlCentroUsuario();
}

function extra_controlCentroUsuario()
{
  var util = new FLUtil;

  var codCentro = util.sqlSelect("usuarios", "codcentroesc", "idusuario = '" + sys.nameUser() + "'");
  if (codCentro && codCentro != "") {
    var cursor = this.cursor();
    if (cursor.modeAccess() == cursor.Insert) {
      this.child("fdbCodCentro").setValue(codCentro);
    }
    this.child("fdbCodCentro").setDisabled(true);
  }
}
//// EXTRAESCOLAR ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
