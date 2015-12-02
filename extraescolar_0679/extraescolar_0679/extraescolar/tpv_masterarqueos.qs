
/** @class_declaration extraescolar */
/////////////////////////////////////////////////////////////////
//// EXTRAESCOLAR //////////////////////////////////////////
class extraescolar extends oficial
{
  function extraescolar(context)
  {
    oficial(context);
  }
  function filtrarArqueos()
  {
    this.ctx.extraescolar_filtrarArqueos();
  }
}
//// EXTRAESCOLAR //////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition extraescolar */
/////////////////////////////////////////////////////////////////
//// EXTRAESCOLAR //////////////////////////////////////////
function extraescolar_filtrarArqueos()
{
  var _i = this.iface;
  var util = new FLUtil;
  var cursor = this.cursor();
  var filtro = "";
  if (this.iface.ckbSoloPV.checked) {
    var codTerminal =  flfact_tpv.iface.pub_valorDefectoTPV("codterminal");
    if (codTerminal) {
      filtro += "ptoventa = '" + codTerminal + "'";
    }
  }

  var idUsuario = sys.nameUser();
  if (idUsuario && idUsuario != "") {
    if (util.sqlSelect("usuariospuntoventa", "id", "idusuario = '" + idUsuario + "'")) {
      if (filtro && filtro != "")
        filtro += " AND ";
      filtro += "ptoventa IN (select codtpv_puntoventa FROM usuariospuntoventa WHERE idusuario = '" + idUsuario + "')";
    }
  }

  cursor.setMainFilter(filtro);
  this.iface.tdbRecords.refresh();
}
//// EXTRAESCOLAR //////////////////////////////////////////
/////////////////////////////////////////////////////////////////
