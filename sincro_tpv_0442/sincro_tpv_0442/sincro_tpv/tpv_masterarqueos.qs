
/** @class_declaration sincro */
/////////////////////////////////////////////////////////////////
//// SINCRO TPV /////////////////////////////////////////////////
class sincro extends oficial
{
  var conexion_;

  function sincro(context)
  {
    oficial(context);
  }
  function init()
  {
    return this.ctx.sincro_init();
  }
  function abrirCerrarArqueo()
  {
    return this.ctx.sincro_abrirCerrarArqueo();
  }/**
  function tbnSincronizarArqueos_clicked() {
    return this.ctx.sincro_tbnSincronizarArqueos_clicked();
  }*/
  function conectar()
  {
    return this.ctx.sincro_conectar();
  }
  function sincronizar()
  {
    return this.ctx.sincro_sincronizar();
  }

}
//// SINCRO TPV /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition sincro */
/////////////////////////////////////////////////////////////////
//// SINCRO TPV /////////////////////////////////////////////////

function sincro_init()
{
  var _i = this.iface;
  _i.__init();

  ///connect (this.child("tbnSincronizarArqueos"), "clicked()", _i, "tbnSincronizarArqueos_clicked");
  this.child("tbnSincronizarArqueos").close();
}

function sincro_abrirCerrarArqueo()
{
  var _i = this.iface;
  var cursor = this.cursor();

  if (cursor.valueBuffer("sincronizado")) {
    MessageBox.warning(sys.translate("No se pueden abrir arqueos sincronizados con la central.\nEn caso de error contacte con la central para subsanarlo."), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return false;
  }
  _i.__abrirCerrarArqueo();
  return true;
}

/**function sincro_tbnSincronizarArqueos_clicked()
{
  var _i = this.iface;

  var codTienda = AQUtil.sqlSelect("tpv_datosgenerales", "prefijocod", "1 = 1");
  if(!codTienda){
    MessageBox.warning(sys.translate("Debe completar los datos generales de sincronización del TPV en la configuración."), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }

  if (!_i.conectar()) {
    MessageBox.warning(sys.translate("Error en la conexión"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }

  if(!_i.sincronizar()){
    return false;
  }

  return true;
}*/

function sincro_sincronizar()
{
  var _i = this.iface;

  var cxTienda = "default";
  var cxCentral = "remota";

  if (!formtpv_tiendas.iface.pub_sincronizarArqueos(cxCentral, cxTienda)) {
    return false;
  }

  if (!formtpv_tiendas.iface.pub_sincronizarVentas(cxCentral, cxTienda)) {
    return false;
  }

  var msgSincro = formtpv_tiendas.iface.pub_dameMensajeSincro();
  MessageBox.information(msgSincro, MessageBox.Ok, MessageBox.NoButton);
  return true;
}

function sincro_conectar()
{
  debug("Conectando");
  var _i = this.iface;
  if (_i.conexion_) {
    return true;
  }

  var datosConexion = "";
  var nombreBD = flfactalma.iface.pub_valorDefectoAlmacen("basedatos");
  datosConexion += "\n" + sys.translate("Base de datos %1").arg(nombreBD);
  var host = flfactalma.iface.pub_valorDefectoAlmacen("servidor");
  datosConexion += "\n" + sys.translate("Servidor %1").arg(host);
  var driver = flfactalma.iface.pub_valorDefectoAlmacen("driver");
  datosConexion += "\n" + sys.translate("Driver %1").arg(driver);
  var puerto = flfactalma.iface.pub_valorDefectoAlmacen("puerto");
  datosConexion += "\n" + sys.translate("Puerto %1").arg(puerto);

  debug("Conectando1");

  if (!driver || !nombreBD || !host) {
    _i.conexion_ = false;
    MessageBox.warning(sys.translate("Debe indicar los datos de conexión a la base de datos Central en la opción Configuración del módulo de Almacén"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }

  var tipoDriver;
  if (sys.nameDriver().search("PSQL") > -1) {
    tipoDriver = "PostgreSQL";
  } else {
    tipoDriver = "MySQL";
  }
  debug("Conectando2");

  var usuario = sys.nameUser();
  var password = flfactalma.iface.pub_valorDefectoAlmacen("contrasena");
  _i.conexion_ = "remota";
  if (!sys.addDatabase(driver, nombreBD, usuario, password, host, puerto, _i.conexion_)) {
    _i.conexion_ = false;
    MessageBox.warning(sys.translate("Error en la conexión:%1").arg(datosConexion), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  debug("OK");

  return true;
}
//// SINCRO TPV /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
