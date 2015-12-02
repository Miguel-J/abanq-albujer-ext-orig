
/** @class_declaration extraescolar */
/////////////////////////////////////////////////////////////////
//// EXTRAESCOLAR //////////////////////////////////////////
class extraescolar extends calendario
{
  function extraescolar(context)
  {
    calendario(context);
  }
  function afterCommit_usuarios(curU)
  {
    return this.ctx.extraescolar_afterCommit_usuarios(curU);
  }
}
//// EXTRAESCOLAR //////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition extraescolar */
/////////////////////////////////////////////////////////////////
//// EXTRAESCOLAR //////////////////////////////////////////
function extraescolar_afterCommit_usuarios(curU)
{
  var _i = this.iface;
  var util = new FLUtil;

  switch (curU.modeAccess()) {
    case curU.Edit:
    case curU.Insert: {
      var idUsuario = curU.valueBuffer("idusuario");
      if (!util.sqlSelect("usuariospuntoventa", "id", "idusuario = '" + idUsuario + "'")) {
        MessageBox.information(util.translate("scripts", "El usuario %1 no tiene puntos de venta asociado por lo que tendrá acceso a todos").arg(idUsuario), MessageBox.Ok, MessageBox.NoButton);
      }
      break;
    }
  }

  return true;
}
//// EXTRAESCOLAR //////////////////////////////////////////
/////////////////////////////////////////////////////////////////
