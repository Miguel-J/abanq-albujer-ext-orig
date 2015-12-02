
/** @class_declaration distEjer */
/////////////////////////////////////////////////////////////////
//// DISTIBUCIÓN EJERCICIOS /////////////////////////////////////
class distEjer extends oficial
{
  var conexionDA_;
  function distEjer(context)
  {
    oficial(context);
  }
  function conectarDA()
  {
    return this.ctx.distEjer_conectarDA();
  }
  function conexionDA()
  {
    return this.ctx.distEjer_conexionDA();
  }
  function beforeCommit_albaranescli(curA)
  {
    return this.ctx.distEjer_beforeCommit_albaranescli(curA);
  }
  function controlBorradoAlbaranDist(curA)
  {
    return this.ctx.distEjer_controlBorradoAlbaranDist(curA);
  }
}
//// DISTIBUCIÓN EJERCICIOS /////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pubDistEjer */
/////////////////////////////////////////////////////////////////
//// PUB DISTIBUCIÓN EJERCICIOS /////////////////////////////////
class pubDistEjer extends ifaceCtx
{
  function pubDistEjer(context)
  {
    ifaceCtx(context);
  }
  function pub_conectarDA()
  {
    return this.conectarDA();
  }
  function pub_conexionDA()
  {
    return this.conexionDA();
  }
}
//// PUB DISTIBUCIÓN EJERCICIOS /////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition distEjer */
/////////////////////////////////////////////////////////////////
//// DISTRIBUCIÓN EJERCICIOS ////////////////////////////////////
function distEjer_conectarDA()
{
  debug("Conectando");
  var _i = this.iface;
  if (_i.conexionDA_) {
    return true;
  }
  var datosConexion: String = "";
  var nombreBD = _i.valorDefecto("basedatosda");
  if (nombreBD == "" || nombreBD == sys.nameBD()) { /// Conexión local
    _i.conexionDA_ = "CX_LOCAL";
    return true;
  }
  datosConexion += "\n" + sys.translate("Base de datos %1").arg(nombreBD);
  var host = _i.valorDefecto("servidorda");
  datosConexion += "\n" + sys.translate("Servidor %1").arg(host);
  var driver = _i.valorDefecto("driverda");
  datosConexion += "\n" + sys.translate("Driver %1").arg(driver);
  var puerto = _i.valorDefecto("puertoda");
  datosConexion += "\n" + sys.translate("Puerto %1").arg(puerto);
  var usuario = _i.valorDefecto("usuarioda");
  datosConexion += "\n" + sys.translate("Puerto %1").arg(puerto);
  var contrasena = _i.valorDefecto("contrasenada");

  if (!driver || !nombreBD || !host) {
    MessageBox.warning(sys.translate("Debe indicar los datos de conexión a la base de datos de distribución de albaranes en la opción Configuración de este módulo"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }

  var tipoDriver: String;
  if (sys.nameDriver().search("PSQL") > -1) {
    tipoDriver = "PostgreSQL";
  } else {
    tipoDriver = "MySQL";
  }
  var conexion = "CX_DA";
  if (!sys.addDatabase(driver, nombreBD, usuario, contrasena, host, puerto, conexion)) {
    MessageBox.warning(sys.translate("Error en la conexión:%1").arg(datosConexion), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  debug("OK " + conexion);
  _i.conexionDA_ = conexion;

  return true;
}

function distEjer_conexionDA()
{
  var _i = this.iface;
  return _i.conexionDA_ == "CX_LOCAL" ? "" : _i.conexionDA_;
}

function distEjer_beforeCommit_albaranescli(curA)
{
  var _i = this.iface;
  if (!_i.controlBorradoAlbaranDist(curA)) {
    return false;
  }
  if (!_i.__beforeCommit_albaranescli(curA)) {
    return false;
  }
  return true;
}

function distEjer_controlBorradoAlbaranDist(curA)
{
  if (curA.modeAccess() == curA.Del && curA.valueBuffer("idalbarancomp")) {
    sys.warnMsgBox(sys.translate("Este albarán está en raparto"));
    return false;
  }
  return true;
}
//// DISTRIBUCIÓN EJERCICIOS ////////////////////////////////////
/////////////////////////////////////////////////////////////////
