
/** @class_declaration extra */
/////////////////////////////////////////////////////////////////
//// EXTRAESCOLAR ///////////////////////////////////////////////
class extra extends ivaIncluido
{
  function extra(context)
  {
    ivaIncluido(context);
  }
  function filtroVentas()
  {
    return this.ctx.extra_filtroVentas();
  }
}
//// EXTRAESCOLAR ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition extra */
/////////////////////////////////////////////////////////////////
//// EXTRAESCOLAR ///////////////////////////////////////////////
function extra_filtroVentas()
{
  var _i = this.iface;
  var filtro = _i.__filtroVentas();

  var util = new FLUtil;
  var idUsuario = sys.nameUser();
  var codCentroEsc = util.sqlSelect("usuarios", "codcentroesc", "idusuario = '" + idUsuario + "'");
  if (codCentroEsc) {
    filtro += filtro != "" ? " AND " : "";
    filtro += "codcentroesc = '" + codCentroEsc + "'";
  }

  if (idUsuario && idUsuario != "") {
    if (util.sqlSelect("usuariospuntoventa", "id", "idusuario = '" + idUsuario + "'")) {
      filtro += filtro != "" ? " AND " : "";
      filtro += "codtpv_puntoventa IN (select codtpv_puntoventa FROM usuariospuntoventa WHERE idusuario = '" + idUsuario + "')";
    }
  }
  return filtro;
}
//// EXTRAESCOLAR ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
