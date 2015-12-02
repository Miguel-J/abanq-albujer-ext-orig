
/** @class_declaration extraescolar */
/////////////////////////////////////////////////////////////////
//// EXTRAESCOLAR //////////////////////////////////////////
class extraescolar extends oficial
{
  function extraescolar(context)
  {
    oficial(context);
  }
  function init()
  {
    this.ctx.extraescolar_init();
  }
}
//// EXTRAESCOLAR //////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition extraescolar */
/////////////////////////////////////////////////////////////////
//// EXTRAESCOLAR //////////////////////////////////////////
function extraescolar_init()
{
  var _i = this.iface;
  var util = new FLUtil();

  _i.__init();

  var idUsuario = sys.nameUser();
  if (idUsuario && idUsuario != "") {
    if (util.sqlSelect("usuariospuntoventa", "id", "idusuario = '" + idUsuario + "'")) {
      var filtro = "codtpv_puntoventa IN (select codtpv_puntoventa FROM usuariospuntoventa WHERE idusuario = '" + idUsuario + "')";
      this.child("tableDBRecords").setFilter(filtro);
      this.child("tableDBRecords").refresh();
    }
  }
}
//// EXTRAESCOLAR //////////////////////////////////////////
/////////////////////////////////////////////////////////////////
