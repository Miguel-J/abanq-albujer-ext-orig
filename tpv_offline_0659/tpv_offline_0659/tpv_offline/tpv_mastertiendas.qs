
/** @class_declaration offline */
/////////////////////////////////////////////////////////////////
//// TPV_OFFLINE ////////////////////////////////////////////////
class offline extends oficial
{
  var tbnSincronizar: Object;
  var tdbRecords: FLTableDB;
  var conexion_: String;
  var numVentasSincro_: Number;
  var curVenDestino_: FLSqlCursor;
  var curLVDestino_: FLSqlCursor;
  var curPagDestino_: FLSqlCursor;
  function offline(context)
  {
    oficial(context);
  }
  function init()
  {
    return this.ctx.offline_init();
  }
  function tbnSincronizar_clicked()
  {
    return this.ctx.offline_tbnSincronizar_clicked();
  }
  function sincronizar(codTienda: String): Boolean {
    return this.ctx.offline_sincronizar(codTienda);
  }
  function conectar(curTienda: FLSqlCursor): Boolean {
    return this.ctx.offline_conectar(curTienda);
  }
  function datosVenta(cursor: FLSqlCursor, campo: String, aCampoInformado: Array): Boolean {
    return this.ctx.offline_datosVenta(cursor, campo, aCampoInformado);
  }
  function datosLineaVenta(cursor: FLSqlCursor, campo: String): Boolean {
    return this.ctx.offline_datosLineaVenta(cursor, campo);
  }
  function datosPagoVenta(cursor: FLSqlCursor, campo: String): Boolean {
    return this.ctx.offline_datosPagoVenta(cursor, campo);
  }
  function crearVentaDestino(curVenOrigen: FLSqlCursor): String {
    return this.ctx.offline_crearVentaDestino(curVenOrigen);
  }
  function copiaHijosVenta(idVenOrigen: String, idVenDestino: String): Boolean {
    return this.ctx.offline_copiaHijosVenta(idVenOrigen, idVenDestino);
  }
  function copiaLineasVenta(idVenOrigen: String, idVenDestino: String): Boolean {
    return this.ctx.offline_copiaLineasVenta(idVenOrigen, idVenDestino);
  }
  function copiaPagosVenta(idVenOrigen: String, idVenDestino: String): Boolean {
    return this.ctx.offline_copiaPagosVenta(idVenOrigen, idVenDestino);
  }
  function sincroCatalogo(curTienda: FLSqlCursor): Boolean {
    return this.ctx.offline_sincroCatalogo(curTienda);
  }
}
//// TPV_OFFLINE ////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pubOffline */
/////////////////////////////////////////////////////////////////
//// PUB OFFLINE /////////////////////////////////////////////////
class pubOffline extends ifaceCtx
{
  function pubOffline(context)
  {
    ifaceCtx(context);
  }
  function pub_conectar(curTienda: FLSqlCursor): Boolean {
    return this.conectar(curTienda);
  }
  function pub_sincroCatalogo(curTienda: FLSqlCursor): Boolean {
    return this.sincroCatalogo(curTienda);
  }
}
//// PUB OFFLINE /////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_definition offline */
//////////////////////////////////////////////////////////////////
//// TPV OFFLINE ////////////////////////////////////////////////
function offline_init()
{
  this.iface.__init();

  var util: FLUtil = new FLUtil;
  this.iface.tdbRecords = this.child("tableDBRecords");
  this.iface.tbnSincronizar = this.child("tbnSincronizar");
  connect(this.iface.tbnSincronizar, "clicked()", this, "iface.tbnSincronizar_clicked()");
  if (flfact_tpv.iface.pub_valorDefectoTPV("bdoffline")) {
    //MessageBox.warning(util.translate("scripts","El formulario de tiendas sólo tiene sentido cuando la base de datos local no es una BD offline"),MessageBox.Ok, MessageBox.NoButton);
    //this.close();
    this.child("tbnSincronizar").close();
  }
}

function offline_tbnSincronizar_clicked()
{
  var util: FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  if (!cursor.isValid()) {
    MessageBox.information(util.translate("scripts", "No hay ningún registro seleccionado"), MessageBox.Ok, MessageBox.NoButton);
    return;
  }

  var codTienda: String = cursor.valueBuffer("codtienda");
  if (!codTienda) {
    MessageBox.information(util.translate("scripts", "No hay ningún registro seleccionado"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }

  if (!this.iface.conectar(cursor)) {
    MessageBox.warning(util.translate("scripts", "Error en la conexión"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }

  var curTLocal: FLSqlCursor = new FLSqlCursor("empresa");
  var curTRemota: FLSqlCursor = new FLSqlCursor("empresa", this.iface.conexion_);
  curTLocal.transaction(false);
  curTRemota.transaction(false);

  try {
    if (this.iface.sincronizar(codTienda)) {
      curTRemota.commit();
      curTLocal.commit();

    } else {
      curTRemota.rollback();
      curTLocal.rollback();
      MessageBox.warning(util.translate("scripts", "Hubo un error al sincronizar la tienda %1").arg(codTienda), MessageBox.Ok, MessageBox.NoButton);
      return false;
    }
  } catch (e) {
    curTRemota.rollback();
    curTLocal.rollback();
    MessageBox.critical(util.translate("scripts", "Hubo un error al sincronizar la tienda %1").arg(codTienda) + ":\n" + e, MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  if (this.iface.numVentasSincro_ > 0) {
    MessageBox.information(util.translate("scripts", "La tienda %1 ha sincronizado %1 ventas").arg(codTienda).arg(this.iface.numVentasSincro_), MessageBox.Ok, MessageBox.NoButton);
  } else {
    MessageBox.information(util.translate("scripts", "No hay ventas que sincronizar para la tienda %1").arg(codTienda), MessageBox.Ok, MessageBox.NoButton);
  }
  this.iface.tdbRecords.refresh();

  return true;
}

function offline_sincronizar(codTienda: String): Boolean {
  var util: FLUtil = new FLUtil;
  this.iface.numVentasSincro_ = 0;
  var progreso: Number = 0;

  var curVenOrigen: FLSqlCursor = new FLSqlCursor("tpv_comandas", this.iface.conexion_);
  curVenOrigen.setForwardOnly(true);
  curVenOrigen.select("sincronizada = false ORDER BY idtpv_comanda");

  if (!this.iface.curVenDestino_)
  {
    this.iface.curVenDestino_ = new FLSqlCursor("tpv_comandas");
  }
  util.createProgressDialog(util.translate("scripts", "Sincronizando ventas..."), curVenOrigen.size());
  var codVentaDestino: String;
  while (curVenOrigen.next())
  {
    curVenOrigen.setModeAccess(curVenOrigen.Edit);
    curVenOrigen.refreshBuffer();
    debug("curVenOrigen (estado) = " + curVenOrigen.valueBuffer("estado"));
    codVentaDestino = this.iface.crearVentaDestino(curVenOrigen);
    if (!codVentaDestino) {
      util.destroyProgressDialog();
      return false;
    }
    curVenOrigen.setValueBuffer("sincronizada", true);
    curVenOrigen.setValueBuffer("codigosincro", codVentaDestino);
    if (!curVenOrigen.commitBuffer()) {
      return false;
    }
    this.iface.numVentasSincro_++;
    util.setProgress(progreso++);
  }
  util.destroyProgressDialog();
  return true;
}

function offline_crearVentaDestino(curVenOrigen: FLSqlCursor): String {
  var util: FLUtil = new FLUtil;
  this.iface.curVenDestino_.setModeAccess(this.iface.curVenDestino_.Insert);
  this.iface.curVenDestino_.refreshBuffer();

  var campos: Array = util.nombreCampos("tpv_comandas");
  var totalCampos: Number = campos[0];
  var aCampoInformado: Array = [];
  for (var i: Number = 1; i <= totalCampos; i++)
  {
    aCampoInformado[campos[i]] = false;
  }
  for (var i: Number = 1; i <= totalCampos; i++)
  {
    if (!this.iface.datosVenta(curVenOrigen, campos[i], aCampoInformado)) {
      return false;
    }
  }

  if (!this.iface.curVenDestino_.commitBuffer())
  {
    return false;
  }
  var codVentaDestino: String = this.iface.curVenDestino_.valueBuffer("codigo");
  var idVenOrigen: String = curVenOrigen.valueBuffer("idtpv_comanda");
  var idVenDestino: String = this.iface.curVenDestino_.valueBuffer("idtpv_comanda");
  if (!this.iface.copiaHijosVenta(idVenOrigen, idVenDestino))
  {
    return false;
  }
  if (!flfact_tpv.iface.pub_modificarFactura(this.iface.curVenDestino_, this.iface.curVenDestino_.valueBuffer("idfactura")))
  {
    return false;
  }
  if (!flfact_tpv.iface.pub_generarRecibos(this.iface.curVenDestino_))
  {
    return false;
  }
  return codVentaDestino;
}

function offline_copiaHijosVenta(idVenOrigen: String, idVenDestino: String): Boolean {
  if (!this.iface.copiaLineasVenta(idVenOrigen, idVenDestino))
  {
    return false;
  }
  if (!this.iface.copiaPagosVenta(idVenOrigen, idVenDestino))
  {
    return false;
  }
  return true;
}

function offline_copiaLineasVenta(idVenOrigen: String, idVenDestino: String): Boolean {
  var util: FLUtil;

  if (!this.iface.curLVDestino_)
  {
    this.iface.curLVDestino_ = new FLSqlCursor("tpv_lineascomanda");
  }

  var campos: Array = util.nombreCampos("tpv_lineascomanda");
  var totalCampos: Number = campos[0];

  var curLVOrigen: FLSqlCursor = new FLSqlCursor("tpv_lineascomanda",  this.iface.conexion_);
  curLVOrigen.select("idtpv_comanda = " + idVenOrigen);
  while (curLVOrigen.next())
  {
    this.iface.curLVDestino_.setModeAccess(this.iface.curLVDestino_.Insert);
    this.iface.curLVDestino_.refreshBuffer();
    this.iface.curLVDestino_.setValueBuffer("idtpv_comanda", idVenDestino);

    for (var i: Number = 1; i <= totalCampos; i++) {
      if (!this.iface.datosLineaVenta(curLVOrigen, campos[i])) {
        return false;
      }
    }
    if (!this.iface.curLVDestino_.commitBuffer()) {
      return false;
    }
  }

  return true;
}

function offline_copiaPagosVenta(idVenOrigen: String, idVenDestino: String): Boolean {
  var util: FLUtil;

  if (!this.iface.curPagDestino_)
  {
    this.iface.curPagDestino_ = new FLSqlCursor("tpv_pagoscomanda");
  }

  var campos: Array = util.nombreCampos("tpv_pagoscomanda");
  var totalCampos: Number = campos[0];

  var curPagOrigen: FLSqlCursor = new FLSqlCursor("tpv_pagoscomanda",  this.iface.conexion_);
  curPagOrigen.select("idtpv_comanda = " + idVenOrigen);
  while (curPagOrigen.next())
  {
    this.iface.curPagDestino_.setModeAccess(this.iface.curPagDestino_.Insert);
    this.iface.curPagDestino_.refreshBuffer();
    this.iface.curPagDestino_.setValueBuffer("idtpv_comanda", idVenDestino);

    for (var i: Number = 1; i <= totalCampos; i++) {
      if (!this.iface.datosPagoVenta(curPagOrigen, campos[i])) {
        return false;
      }
    }
    if (!this.iface.curPagDestino_.commitBuffer()) {
      return false;
    }
  }

  return true;
}

function offline_datosVenta(cursor: FLSqlCursor, campo: String, aCampoInformado: Array): Boolean {
  var util: FLUtil = new FLUtil;

  var valor: String;
  var nulo: Boolean = false;
  if (aCampoInformado[campo])
  {
    return true;
  }
  if (!campo || campo == "")
  {
    return false;
  }
  switch (campo)
  {
    case "idtpv_comanda": {
      return true;
      break;
    }
    case "codigo": {
      valor = 0;
      break;
    }
    case "idfactura": {
      nulo = true;
      break;
    }
    case "sincronizada": {
      valor = true;
      break;
    }
    case "codigosincro": {
      valor = cursor.valueBuffer("codigo");
      break;
    }
    default: {
      if (cursor.isNull(campo)) {
        nulo = true;
      } else {
        valor = cursor.valueBuffer(campo);
      }
    }
  }
  if (nulo)
  {
    this.iface.curVenDestino_.setNull(campo);
  } else {
    this.iface.curVenDestino_.setValueBuffer(campo, valor);
  }
  aCampoInformado[campo] = true;
  return true;
}

function offline_datosLineaVenta(cursor: FLSqlCursor, campo: String): Boolean {
  var util: FLUtil = new FLUtil;

  var valor: String;
  var nulo: Boolean = false;
  if (!campo || campo == "")
  {
    return false;
  }
  switch (campo)
  {
    case "idtpv_linea":
    case "idtpv_comanda": {
      return true;
      break;
    }
    default: {
      if (cursor.isNull(campo)) {
        nulo = true;
      } else {
        valor = cursor.valueBuffer(campo);
      }
    }
  }
  if (nulo)
  {
    this.iface.curLVDestino_.setNull(campo);
  } else {
    this.iface.curLVDestino_.setValueBuffer(campo, valor);
  }
  return true;
}

function offline_datosPagoVenta(cursor: FLSqlCursor, campo: String): Boolean {
  var util: FLUtil = new FLUtil;

  var valor: String;
  var nulo: Boolean = false;
  if (!campo || campo == "")
  {
    return false;
  }
  switch (campo)
  {
    case "idpago":
    case "idtpv_arqueo":
    case "idtpv_comanda": {
      return true;
      break;
    }
    case "idrecibo": {
      nulo = true;
      break;
    }
    default: {
      if (cursor.isNull(campo)) {
        nulo = true;
      } else {
        valor = cursor.valueBuffer(campo);
      }
    }
  }
  if (nulo)
  {
    this.iface.curPagDestino_.setNull(campo);
  } else {
    this.iface.curPagDestino_.setValueBuffer(campo, valor);
  }
  return true;
}

function offline_conectar(curTienda: FLSqlCursor): Boolean {
  var util: FLUtil = new FLUtil();

  var codTienda: String = curTienda.valueBuffer("codtienda");
  if (!codTienda)
  {
    return false;
  }
  var datosConexion: String = "";
  var nombreBD: String = curTienda.valueBuffer("basedatos");
  datosConexion += "\n" + util.translate("scripts", "Base de datos %1").arg(nombreBD);
  var host: String = curTienda.valueBuffer("servidor");
  datosConexion += "\n" + util.translate("scripts", "Servidor %1").arg(host);
  var driver: String = curTienda.valueBuffer("driver");
  datosConexion += "\n" + util.translate("scripts", "Driver %1").arg(driver);
  var puerto: String = curTienda.valueBuffer("puerto");
  datosConexion += "\n" + util.translate("scripts", "Puerto %1").arg(puerto);
  var usuario: String = curTienda.valueBuffer("usuario");
  datosConexion += "\n" + util.translate("scripts", "Usuario %1").arg(usuario);
  var contrasena: String = curTienda.valueBuffer("contrasena");


  if (!driver || !nombreBD || !host || !usuario)
  {
    MessageBox.warning(util.translate("scripts", "Debe indicar los datos de conexión a la base de datos de la tienda %1").arg(codTienda), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }

  var tipoDriver: String;
  if (sys.nameDriver().search("PSQL") > -1)
  {
    tipoDriver = "PostgreSQL";
  } else {
    tipoDriver = "MySQL";
  }

  debug("Conectando..");

  this.iface.conexion_ = "CX";
  if (!sys.addDatabase(driver, nombreBD, usuario, contrasena, host, puerto, this.iface.conexion_))
  {
    MessageBox.warning(util.translate("scripts", "Error en la conexión:%1").arg(datosConexion), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }

  //  if (contrasena && contrasena != "") {
  //    formRecordsincrocatalogo.iface.password_ = contrasena;
  //  } else {
  //    formRecordsincrocatalogo.iface.password_ = "";
  //  }

  return true;
}

function offline_sincroCatalogo(curTienda: FLSqlCursor): Boolean {
  if (!this.iface.conectar(curTienda))
  {
    return false;
  }
  if (!formRecordsincrocatalogo.iface.pub_establecerConexiones(false, this.iface.conexion_))
  {
    return false;
  }
  if (!formRecordsincrocatalogo.iface.pub_sincronizarTrans())
  {
    return false;
  }
  var resultado: String = formRecordsincrocatalogo.iface.pub_dameResultadosSincro();
  MessageBox.information(resultado, MessageBox.Ok, MessageBox.NoButton);
  return true;
}
//// TPV OFFLINE ////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
