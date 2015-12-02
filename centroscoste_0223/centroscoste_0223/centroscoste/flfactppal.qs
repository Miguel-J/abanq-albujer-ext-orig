
/** @class_declaration cCoste */
/////////////////////////////////////////////////////////////////
//// CENTROS COSTE //////////////////////////////////////////////
class cCoste extends oficial
{
  function cCoste(context)
  {
    oficial(context);
  }
  //  function valorDefectoEmpresa(fN) {
  //    return this.ctx.cCoste_valorDefectoEmpresa(fN);
  //  }
  function validarCentroCoste(codCentro: String): Boolean {
    return this.ctx.cCoste_validarCentroCoste(codCentro);
  }
}
//// CENTROS COSTE //////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pubCCoste */
////////////////////////////////////////////////////////////////////////
//// PUB_FUNDACIONMF //////////////////////////////////////////
class pubCCoste extends ifaceCtx
{
  function pubCCoste(context)
  {
    ifaceCtx(context);
  }
  function pub_validarCentroCoste(codCentro)
  {
    return this.validarCentroCoste(codCentro);
  }
}
//// PUB_FUNDACIONMF //////////////////////////////////////////
///////////////////////////////////////////////////////////////////////

/** @class_definition cCoste */
/////////////////////////////////////////////////////////////////
//// CENTROS COSTE //////////////////////////////////////////////
// function cCoste_valorDefectoEmpresa(fN)
// {
//  var valor;
//  switch (fN) {
//    case "validarpartidascc": {
//      valor = this.iface.valorDefecto(fN);
//      break;
//    }
//    default: {
//      valor = this.iface.__valorDefectoEmpresa(fN);
//    }
//  }
//  return valor;
// }
function cCoste_validarCentroCoste(codCentro: String): Boolean {
  var util: FLUtil;
  if (true)   /// Comprobar configuración y ver si hay que validar usuarios
  {
    if (codCentro && codCentro != "") {
      var idUsuario: String = sys.nameUser();
      if (idUsuario && idUsuario != "") {
        var idGrupo: String = util.sqlSelect("flusers", "idgroup", "iduser = '" + idUsuario + "'");
        if (idGrupo && idGrupo != "") {
          if (!util.sqlSelect("gruposusuarioscc", "id", "idgroup = '" + idGrupo + "' AND codcentro = '" + codCentro + "'")) {
            MessageBox.warning(util.translate("scripts", "El centro de coste establecido no es correcto"), MessageBox.Ok, MessageBox.NoButton);
            return false;
          }
        }
      }
    }
  }

  return true;
}
//// CENTROS COSTE //////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
