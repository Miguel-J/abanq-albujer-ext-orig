
/** @class_declaration infMultiidioma */
/////////////////////////////////////////////////////////////////
//// INFORMES MULTIIDIOMA ///////////////////////////////////////
class infMultiidioma extends traducciones
{
  function infMultiidioma(context)
  {
    traducciones(context);
  }
  function obtenerIdiomaObjeto(tipo, clave)
  {
    return this.ctx.infMultiidioma_obtenerIdiomaObjeto(tipo, clave);
  }
}
//// INFORMES MULTIIDIOMA ///////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pubInfMulti */
/////////////////////////////////////////////////////////////////
//// PUB INFORMES MULTIIDIOMA ///////////////////////////////////
class pubInfMulti extends ifaceCtx
{
  function pubInfMulti(context)
  {
    ifaceCtx(context);
  }
  function pub_obtenerIdiomaObjeto(tipo, clave)
  {
    return this.obtenerIdiomaObjeto(tipo, clave);
  }
}
//// PUB INFORMES MULTIIDIOMA ///////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition infMultiidioma */
/////////////////////////////////////////////////////////////////
//// INFORMES MULTIIDIOMA ///////////////////////////////////////
function infMultiidioma_obtenerIdiomaObjeto(tipo, clave)
{
  var util = new FLUtil;
  var codIdioma;
  switch (tipo) {
    case "presupuestoscli":
    case "pedidoscli":
    case "albaranescli":
    case "facturascli": {
      var nombrePK;
      switch (tipo) {
        case "presupuestoscli": {
          nombrePK = "idpresupuesto";
          break;
        }
        case "pedidoscli": {
          nombrePK = "idpedido";
          break;
        }
        case "albaranescli": {
          nombrePK = "idalbaran";
          break;
        }
        case "facturascli": {
          nombrePK = "idfactura";
          break;
        }
      }
      var codPais = util.sqlSelect(tipo, "codpais", nombrePK + " = " + clave);
      var idiomaFactura = util.sqlSelect("paises", "codidioma", "codpais = '" + codPais + "'");
      var paisEmpresa = flfactppal.iface.pub_valorDefectoEmpresa("codpais");
      var idiomaEmpresa = util.sqlSelect("paises", "codidioma", "codpais = '" + paisEmpresa + "'");
      if (!codPais || codPais == "" || codPais == paisEmpresa || idiomaFactura == idiomaEmpresa) {
        codIdioma = "";
      } else {
        codIdioma = util.sqlSelect("paises", "codidioma", "codpais = '" + codPais + "'");
      }
      break;
    }
    default: {
      var paisEmpresa = flfactppal.iface.pub_valorDefectoEmpresa("codpais");
      codIdioma = util.sqlSelect("paises", "codidioma", "codpais = '" + paisEmpresa + "'");
    }
  }
  if (codIdioma && codIdioma != "") {
    /// Para la versión antigua de la extensión
    if (!flfactinfo.iface.pub_establecerIdioma(codIdioma)) {
      return false;
    }
    var codIso = util.sqlSelect("idiomas", "codiso", "codidioma = '" + codIdioma + "'");
    codIdioma = codIso ? codIso : codIdioma;
  } else {
    if (!flfactinfo.iface.pub_establecerIdioma("")) {
      return false;
    }
  }
  return codIdioma;
}
//// INFORMES MULTIIDIOMA ///////////////////////////////////////
/////////////////////////////////////////////////////////////////
