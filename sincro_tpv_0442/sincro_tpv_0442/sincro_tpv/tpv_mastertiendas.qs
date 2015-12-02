
/** @class_declaration sincro */
//////////////////////////////////////////////////////////////////
//// SINCRO TPV //////////////////////////////////////////////////

class sincro extends oficial
{
  var curArqueoCentral_;
  var curPagoCentral_;
  var curComandaCentral_;
  var curLineaComandaCentral_;
  var curMovimientoCentral_;
  var tbnSincronizar;
  var msgSincro_;
  var aCx_, silent_, mgr_;
  var nombreLog_;
  var nombreFile_;

  function sincro(context)
  {
    oficial(context);
  }
  function init()
  {
    this.ctx.sincro_init();
  }/**
  function tbnSincroAuto_clicked() {
    this.ctx.sincro_tbnSincroAuto_clicked();
  }*//**
  function sincroAuto(silent) {
    this.ctx.sincro_sincroAuto(silent);
  }*/
  function sincronizarTiendas(esquema, otros)
  {
    this.ctx.sincro_sincronizarTiendas(esquema, otros);
  }/**
  function tbnSincronizar_clicked() {
    return this.ctx.sincro_tbnSincronizar_clicked();
  }*/
  function dameEmailEmpresa()
  {
    return this.ctx.sincro_dameEmailEmpresa();
  }
  function sincronizar(cxRemota, silent)
  {
    return this.ctx.sincro_sincronizar(cxRemota, silent);
  }
  function conectar(codTienda, silent)
  {
    return this.ctx.sincro_conectar(codTienda, silent);
  }
  function desconectar(codTienda, silent)
  {
    return this.ctx.sincro_desconectar(codTienda, silent);
  }
  function sincronizarArqueos(cxCentral, cxTienda)
  {
    return this.ctx.sincro_sincronizarArqueos(cxCentral, cxTienda);
  }
  function sincronizarVentas(cxCentral, cxTienda)
  {
    return this.ctx.sincro_sincronizarVentas(cxCentral, cxTienda);
  }
  function sincronizarArqueo(codArqueo, cxCentral, cxTienda)
  {
    return this.ctx.sincro_sincronizarArqueo(codArqueo, cxCentral, cxTienda);
  }
  function sincroCampoArqueo(nombreCampo, curOriginal, campoInformado)
  {
    return this.ctx.sincro_sincroCampoArqueo(nombreCampo, curOriginal, campoInformado);
  }
  function sincronizarPagosComanda(curVentasTienda, cxCentral, cxTienda)
  {
    return this.ctx.sincro_sincronizarPagosComanda(curVentasTienda, cxCentral, cxTienda);
  }
  function sincroCampoPago(nombreCampo, curOriginal, campoInformado)
  {
    return this.ctx.sincro_sincroCampoPago(nombreCampo, curOriginal, campoInformado);
  }
  function sincronizarCabeceraComanda(curVentasTienda, cxCentral, cxTienda)
  {
    return this.ctx.sincro_sincronizarCabeceraComanda(curVentasTienda, cxCentral, cxTienda);
  }
  function marcarComandaSincronizada(curVentasTienda, cxCentral, cxTienda)
  {
    return this.ctx.sincro_marcarComandaSincronizada(curVentasTienda, cxCentral, cxTienda);
  }
  function sincroCampoComanda(nombreCampo, curOriginal, campoInformado)
  {
    return this.ctx.sincro_sincroCampoComanda(nombreCampo, curOriginal, campoInformado);
  }
  function sincronizarLineasComanda(curVentasTienda, cxCentral, cxTienda)
  {
    return this.ctx.sincro_sincronizarLineasComanda(curVentasTienda, cxCentral, cxTienda);
  }
  function sincroCampoLineaComanda(nombreCampo, curOriginal, campoInformado)
  {
    return this.ctx.sincro_sincroCampoLineaComanda(nombreCampo, curOriginal, campoInformado);
  }
  function sincronizarMovimientos(codArqueo, cxCentral, cxTienda)
  {
    return this.ctx.sincro_sincronizarMovimientos(codArqueo, cxCentral, cxTienda);
  }
  function sincroCampoMovimiento(nombreCampo, curOriginal, campoInformado)
  {
    return this.ctx.sincro_sincroCampoMovimiento(nombreCampo, curOriginal, campoInformado);
  }
  function listaArqueosTienda(codTienda, cxTienda)
  {
    return this.ctx.sincro_listaArqueosTienda(codTienda, cxTienda);
  }
  function dameCurVentasTienda(cxTienda)
  {
    return this.ctx.sincro_dameCurVentasTienda(cxTienda);
  }
  function sincronizarComanda(curVentasTienda, cxCentral, cxTienda)
  {
    return this.ctx.sincro_sincronizarComanda(curVentasTienda, cxCentral, cxTienda);
  }
  function dameMensajeSincro()
  {
    return this.ctx.sincro_dameMensajeSincro();
  }
  function tbnSincronizarTienda_clicked()
  {
    return this.ctx.sincro_tbnSincronizarTienda_clicked();
  }
  function lanzaSincronizacion(cursor)
  {
    return this.ctx.sincro_lanzaSincronizacion(cursor);
  }
  function dameNombreLog(esquema)
  {
    return this.ctx.sincro_dameNombreLog(esquema);
  }
  function sincronizacion(cursor, conRemota, esquema, otros, silent)
  {
    return this.ctx.sincro_sincronizacion(cursor, conRemota, esquema, otros, silent);
  }
  function muestraMensaje()
  {
    return this.ctx.sincro_muestraMensaje();
  }
  function silentSincro(tiendas, esquema, otros)
  {
    return this.ctx.sincro_silentSincro(tiendas, esquema, otros);
  }
  //  function silentSincroCatalogo(tiendas, total) {
  //    return this.ctx.sincro_silentSincroCatalogo(tiendas, total);
  //  }
  function esquemaSincro(cursor, esquema, otros)
  {
    return this.ctx.sincro_esquemaSincro(cursor, esquema, otros);
  }
  function posiblesEsquemasSincro()
  {
    return this.ctx.sincro_posiblesEsquemasSincro();
  }
  function actualizacionesEsquema(oParamEsquema, cursor)
  {
    return this.ctx.sincro_actualizacionesEsquema(oParamEsquema, cursor);
  }
  function paramEsquema(esquema, cursor, otros)
  {
    return this.ctx.sincro_paramEsquema(esquema, cursor, otros);
  }
}
//// SINCRO TPV //////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration pub_sincro */
/////////////////////////////////////////////////////////////////
//// PUB_SINCRO  ///////////////////////////////////////////////
class pub_sincro extends ifaceCtx
{
  function pub_sincro(context)
  {
    ifaceCtx(context);
  }
  function pub_sincronizarArqueos(cxCentral, cxTienda)
  {
    return this.sincronizarArqueos(cxCentral, cxTienda);
  }
  function pub_sincronizarVentas(Central, cxTienda)
  {
    return this.sincronizarVentas(cxCentral, cxTienda);
  }
  function pub_dameMensajeSincro()
  {
    return this.dameMensajeSincro();
  }
  function pub_dameEmailEmpresa()
  {
    return this.dameEmailEmpresa();
  }
  function pub_silentSincro(tiendas, esquema, otros)
  {
    return this.silentSincro(tiendas, esquema, otros);
  }
  //  function pub_silentSincroCatalogo(tiendas, total) {
  //    return this.silentSincroCatalogo(tiendas, total);
  //  }
  function pub_sincronizacion(cursor, conRemota, esquema, otros, silent)
  {
    return this.sincronizacion(cursor, conRemota, esquema, otros, silent);
  }
}

//// PUB_SINCRO  /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition sincro */
//////////////////////////////////////////////////////////////////
//// SINCRO TPV //////////////////////////////////////////////////
function sincro_init()
{
  var _i = this.iface;

  _i.tbnSincronizar = this.child("tbnSincronizar");
  ///connect (_i.tbnSincronizar, "clicked()", _i, "tbnSincronizar_clicked");
  ///connect (this.child("tbnSincroAuto"), "clicked()", _i, "tbnSincroAuto_clicked");
  connect(this.child("tbnSincronizarTienda"), "clicked()", _i, "tbnSincronizarTienda_clicked");

  this.child("tbnSincroAuto").close();
  this.child("lblSincroAuto").close();
  this.child("tbnSincronizar").close();

  var esTienda = flfact_tpv.iface.pub_valorDefectoTPV("tiendasincro");

  if (esTienda) {
    this.child("tbnSincronizarTienda").close();
  }
  _i.msgSincro_ = "";
}

function sincro_silentSincro(tiendas, esquema, otros)
{
  var _i = this.iface;

  try {
    var nombreLog = _i.dameNombreLog(esquema);
    _i.nombreLog_ = flfactalma.iface.pub_ponLogName(nombreLog);
    var dirLog = flfact_tpv.iface.pub_valorDefectoTPV("dirlogs");

    if (!dirLog || dirLog == "") {
      dirLog = Dir.home;
    }
    if (dirLog.endsWith("/")) {
      _i.nombreFile_ = dirLog + nombreLog;
    } else {
      _i.nombreFile_ = dirLog + "/" + nombreLog;
    }
    if (!flfactppal.iface.pub_abreLogFile(_i.nombreLog_, _i.nombreFile_)) {
      sys.infoMsgBox("No se ha creado el fichero del log de la sincronización.");
    }
    if (!flfactppal.iface.pub_appendTextToLogFile(_i.nombreLog_, "Sincronización de tiendas: " + tiendas)) {
      sys.infoMsgBox("Sincronización de tiendas: " + tiendas);
    }

    if (!esquema || esquema == "") {
      if (!flfactppal.iface.pub_appendTextToLogFile(_i.nombreLog_, "Debe especificar un esquema de sincronización")) {
        sys.infoMsgBox("Debe especificar un esquema de sincronización");
      }
      return;
    }
    if (!flfactppal.iface.pub_appendTextToLogFile(_i.nombreLog_, "Esquema:" + esquema)) {
      sys.infoMsgBox("Esquema:" + esquema);
    }
    _i.silent_ = true;
    _i.mgr_ = aqApp.db().manager();
    _i.aCx_ = [];

    var aT = tiendas.split(",");
    aT.sort();
    var codTienda;
    if (!flfactppal.iface.pub_appendTextToLogFile(_i.nombreLog_, "Conectando...")) {
      sys.infoMsgBox("Conectando...");
    }
    for (var i = 0; i < aT.length; i++) {
      codTienda = aT[i];
      //    if (!_i.conectar(codTienda, true)) {
      // debug("NO conectado a tienda " + codTienda);
      //      continue;
      //    }
      // debug("Conectado con éxito a tienda " + codTienda);
      _i.aCx_.push(codTienda);
      //    AQUtil.sqlUpdate("tpv_tiendas", ["sincronizando"], [true], "codtienda = '" + codTienda + "'");
    }
    _i.sincronizarTiendas(esquema, otros);
  } catch (e) {
    sys.infoMsgBox("Error sincro_silentSincro(): " + e);
    return;
  }
}

// function sincro_silentSincroCatalogo(tiendas, total)
// {
//  debug("sincro_silentSincroCatálogo  " + tiendas);
//  var _i = this.iface;
//
//  _i.mgr_ = aqApp.db().manager();
//  _i.silent_ = true;
//  _i.aCx_ = [];
//
//  var aT = tiendas.split(",");
//  var codTienda;
//  for (var i = 0; i < aT.length; i++) {
//    codTienda = aT[i];
// debug("codTienda " + codTienda );
//    if (!_i.conectar(codTienda, true)) {
//      continue;
//    }
//    _i.aCx_.push(codTienda);
// //     AQUtil.sqlUpdate("tpv_tiendas", ["sincronizando"], [true], "codtienda = '" + codTienda + "'");
//  }
// debug((total == "T") ? "TOTAL" : "INCREMENTAL");
//  var curT = new FLSqlCursor("tpv_tiendas");
//  var oParam = new Object;
//  for (var i = 0; i < _i.aCx_.length; i++) {
//    curT.select("codtienda = '" + _i.aCx_[i] + "'");
//    if (!curT.first()) {
//      continue;
//    }
//    curT.setModeAccess(curT.Edit);
//    curT.refreshBuffer();
//    oParam.filtroFecha = (total == "T") ? undefined == true : curT.valueBuffer("fechasinccatalogo");
//    oParam.codTienda = curT.valueBuffer("codtienda");
//    flfactalma.iface.pub_ponTiendaActual(oParam);
//    flfactalma.iface.pub_establecerConexionesSinc("default", oParam.codTienda);
//    if (!flfactalma.iface.pub_sincronizarTrans()) {
//      return false;
//    }
// debug(flfactalma.iface.pub_dameResultadosSincro());
//    var d = new Date;
//    curT.setValueBuffer("fechasinccatalogo", d.toString());
//    if (!curT.commitBuffer()) {
//      return false;
//    }
//  }
//  return true;
// }

/**function sincro_tbnSincroAuto_clicked()
{
  var _i = this.iface;

  var cols = ["codtienda", "sincronizando", "fechasinc", "horasinc", "descripcion"];
  this.child("tableDBRecords").setOrderCols(cols);
  this.child("tableDBRecords").refresh();

  _i.mgr_ = aqApp.db().manager();
  _i.silent_ = false;
  _i.sincroAuto()
}*/

/**function sincro_sincroAuto()
{
  var _i = this.iface;

  if (this.child("tbnSincroAuto").on) {
    _i.aCx_ = [];
    var curT = new FLSqlCursor("tpv_tiendas");
    curT.select();
    var codTienda;
    while (curT.next()) {
      curT.setModeAccess(curT.Browse);
      curT.refreshBuffer();
      codTienda = curT.valueBuffer("codtienda");
debug("codTienda " + codTienda );
      if (!_i.conectar(codTienda, true)) {
        continue;
      }
      _i.aCx_.push(codTienda);
      AQUtil.sqlUpdate("tpv_tiendas", ["sincronizando"], [true], "codtienda = '" + codTienda + "'");
    }
    if (!_i.silent_) {
      this.child("lblSincroAuto").text = sys.translate("Sincronización activada");
    }
    startTimer( 5000, _i.sincronizarTiendas);
  } else {
    killTimers();
    AQUtil.sqlUpdate("tpv_tiendas", ["sincronizando"], [false], "1 = 1");
    if (!_i.silent_) {
      this.child("lblSincroAuto").text = "";
      this.child("tableDBRecords").refresh();
    }
  }
}*/

function sincro_sincronizarTiendas(esquema, otros)
{
  var _i = this.iface;

  var h = new Date;
  var inicio = AQUtil.dateAMDtoDMA(h);
  h = new Date;
  inicio += "  " + h.toString().right(8);

  if (!flfactppal.iface.pub_appendTextToLogFile(_i.nombreLog_, h.toString() + ": Sincronizando tiendas ")) {
    sys.infoMsgBox(h.toString() + ": Sincronizando tiendas ");
  }

  if (!_i.aCx_ || _i.aCx_.length == 0) {
    if (!flfactppal.iface.pub_appendTextToLogFile(_i.nombreLog_, "No hay ninguna tienda con conexión abierta")) {
      sys.infoMsgBox("No hay ninguna tienda con conexión abierta");
    }
    return;
  }
  var pull = [], codTP;
  var aTiendasOK = [];
  var aTiendasKO = [];
  var aTiendasSC = [];

  for (var i = 0; i < _i.aCx_.length; i++) {
    codTP = _i.aCx_[i];
    pull[codTP] = new Object;
    pull[codTP]["nombre"] = _i.aCx_[i];
    pull[codTP]["ok"] = false;
    pull[codTP]["intentos"] = 0;
  }
  var curTienda = new FLSqlCursor("tpv_tiendas");
  var codTienda, codTiendaAnt = false;
  var okTotal = false;
  var maxIntentos = 3, msEspera = 60 * 1000; /// 1min
  while (!okTotal) {
    okTotal = true;
    curTienda.select("codtienda IN ('" + _i.aCx_.join("', '") + "') ORDER BY codtienda");
    while (curTienda.next()) {
      codTienda = curTienda.valueBuffer("codtienda");
      if (pull[codTienda]["ok"]) {
        continue;
      }
      if (codTiendaAnt == codTienda) {
        var t1 = new Date;
        var t2;
        if (!flfactppal.iface.pub_appendTextToLogFile(_i.nombreLog_, "Esperando " + msEspera + "ms para volver a conectar a " + codTienda + "...")) {
          sys.infoMsgBox("Esperando " + msEspera + "ms para volver a conectar a " + codTienda + "...");
        }
        do {
          t2 = new Date;
        } while (t2.getTime() - t1.getTime() < msEspera);
      }
      codTiendaAnt = codTienda;
      if (!_i.conectar(codTienda, true)) {
        pull[codTienda]["intentos"]++;
        if (pull[codTienda]["intentos"] >= maxIntentos) {
          pull[codTienda]["ok"] = true;
          aTiendasSC.push(codTienda);
        } else {
          okTotal = false;
        }
        if (!flfactppal.iface.pub_appendTextToLogFile(_i.nombreLog_, "NO conectado a tienda " + codTienda)) {
          sys.infoMsgBox("NO conectado a tienda " + codTienda);
        }
        continue;
      }
      h = new Date;
      if (!flfactppal.iface.pub_appendTextToLogFile(_i.nombreLog_, h.toString() + ": Sincronizando tienda " + codTienda)) {
        sys.infoMsgBox(h.toString() + ": Sincronizando tienda " + codTienda);
      }
      if (_i.sincronizacion(curTienda, codTienda, esquema, otros, true)) {
        pull[codTienda]["ok"] = true;
        h = new Date;
        if (!flfactppal.iface.pub_appendTextToLogFile(_i.nombreLog_, h.toString() + ": Tienda " + codTienda + " sincronizada con éxito")) {
          sys.infoMsgBox(h.toString() + ": Tienda " + codTienda + " sincronizada con éxito");
        }
        aTiendasOK.push(codTienda);
      } else {
        pull[codTienda]["intentos"]++;
        if (pull[codTienda]["intentos"] >= maxIntentos) {
          aTiendasKO.push(codTienda);
          pull[codTienda]["ok"] = true;
        } else {
          okTotal = false;
        }
        h = new Date;
        if (!flfactppal.iface.pub_appendTextToLogFile(_i.nombreLog_, h.toString() + ": Fallo en la sincronización de tienda " + codTienda)) {
          sys.infoMsgBox(h.toString() + ": Fallo en la sincronización de tienda " + codTienda);
        }
      }
      if (!_i.desconectar(codTienda, true)) {
        h = new Date;
        if (!flfactppal.iface.pub_appendTextToLogFile(_i.nombreLog_, h.toString() + ": Fallo en la desconexión de la tienda " + codTienda)) {
          sys.infoMsgBox(h.toString() + ": Fallo en la desconexión de la tienda " + codTienda);
        }
      }
    }
  }
  var sOk = aTiendasOK.join(", ");
  var sKo = aTiendasKO.join(", ");
  var sSc = aTiendasSC.join(", ");

  var msg = "";
  msg += (aTiendasOK.length > 0) ? ("\n" + sys.translate("Se han sincronizado correctamente " + aTiendasOK.length + " tiendas: " + sOk + ".")) : "";
  msg += (aTiendasKO.length > 0) ? ("\n" + sys.translate("NO se han sincronizado " + aTiendasKO.length + " tiendas: " + sKo + ".")) : "";
  msg += (aTiendasSC.length > 0) ? ("\n" + sys.translate("NO se pudo establecer la conexión con " + aTiendasSC.length + " tiendas: " + sSc + ".")) : "";

  if (!flfactppal.iface.pub_appendTextToLogFile(_i.nombreLog_, msg)) {
    sys.infoMsgBox(msg);
  }

  h = new Date;
  var fin = AQUtil.dateAMDtoDMA(h);
  h = new Date;
  fin += "  " + h.toString().right(8);

  if (aTiendasKO.length > 0 || aTiendasSC.length > 0) {
    var datosMail = [];
    datosMail["subject"] = "Sincro El Ganso Abanq: " + esquema;
    datosMail["body"] = "Esquema sincronizado: " + esquema + "\nInicio: " + inicio + "\nFin: " + fin + "\n" + msg + "\n";
    datosMail["from"] = _i.dameEmailEmpresa();

    datosMail["to"] = AQUtil.sqlSelect("tpv_datosgenerales", "emaillogs", "1 = 1");
    datosMail["server"] = AQUtil.sqlSelect("tpv_datosgenerales", "hostcorreosaliente", "1 = 1");

    var attachment = _i.nombreFile_.split(",");
    datosMail["attach"] = attachment;
    flfact_tpv.iface.pub_enviarMailLog(datosMail);
  }

}

function sincro_dameEmailEmpresa()
{
  var _i = this.iface;
  var cursor = this.cursor();

  return flfactppal.iface.pub_valorDefectoEmpresa("email");
}

/**function sincro_tbnSincronizar_clicked()
{
  var _i = this.iface;
  var cursor = this.cursor();

  if (!_i.mgr_) {
    _i.mgr_ = aqApp.db().manager();
  }

  var codTienda = cursor.valueBuffer("codtienda");

  if(!codTienda){
    return false;
  }

  if (!_i.conectar(codTienda)) {
    return false;
  }

  if(!_i.sincronizar(codTienda)){
    return false;
  }

  return true;
}*/

function sincro_sincronizar(cxTienda, silent)
{
  var _i = this.iface;
  //  var cxTienda = "remota";
  var cxCentral = "default";

  if (!_i.sincronizarArqueos(cxCentral, cxTienda)) {
    return false;
  }

  if (!_i.sincronizarVentas(cxCentral, cxTienda)) {
    return false;
  }
  if (!flfactppal.iface.pub_appendTextToLogFile(_i.nombreLog_, i.msgSincro_)) {
    sys.infoMsgBox(i.msgSincro_);
  }
  _i.msgSincro_ = "";
  return true;
}

function sincro_conectar(codTienda, silent)
{
  var _i = this.iface;

  var cxTienda = codTienda;
  var dbTienda = AQSql.database(cxTienda);

  if (dbTienda.connectionName() == cxTienda && dbTienda.isOpen()) {
    if (!flfactppal.iface.pub_appendTextToLogFile(_i.nombreLog_, "Conexión con " + codTienda + " ya establecida")) {
      if (silent) {
        sys.infoMsgBox("Conexión con " + codTienda + " ya establecida");
      }
    }
    return true;
  }

  var cursor = new FLSqlCursor("tpv_tiendas");
  cursor.select("codtienda = '" + codTienda + "'");
  cursor.setModeAccess(cursor.Browse);
  cursor.refreshBuffer();

  if (!cursor.first()) {
    if (!flfactppal.iface.pub_appendTextToLogFile(_i.nombreLog_, "La tienda " + codTienda + " no existe")) {
      sys.infoMsgBox("La tienda " + codTienda + " no existe");
    }
    return false;
  }

  var driver = cursor.valueBuffer("driver");
  var nombreBD = cursor.valueBuffer("nombrebd");
  var usuario = cursor.valueBuffer("usuario");
  var host = cursor.valueBuffer("servidor");
  var puerto = cursor.valueBuffer("puerto");
  var password = cursor.valueBuffer("contrasena");

  var tipoDriver;
  if (sys.nameDriver().search("PSQL") > -1) {
    tipoDriver = "PostgreSQL";
  } else {
    tipoDriver = "MySQL";
  }
  var msg;
  if (host == sys.nameHost() && nombreBD == sys.nameBD() && driver == tipoDriver) {
    if (!flfactppal.iface.pub_appendTextToLogFile(_i.nombreLog_, "La tienda " + codTienda + " no existe")) {
      sys.infoMsgBox("La tienda " + codTienda + " no existe");
    }
    return false;
  }

  if (!driver || !nombreBD || !usuario || !host || !password) {
    if (!flfactppal.iface.pub_appendTextToLogFile(_i.nombreLog_, "Debe indicar los datos de conexión de la tienda " + codTienda + ".")) {
      sys.infoMsgBox("Debe indicar los datos de conexión de la tienda " + codTienda + ".");
    }
    return false;
  }

  if (!flfactppal.iface.pub_appendTextToLogFile(_i.nombreLog_, "Conectando a " + codTienda)) {
    if (silent) {
      sys.infoMsgBox("Conectando a " + codTienda);
    }
  }

  var sTimeOut = 10;
  var masParamCon = "connect_timeout=" + sTimeOut.toString();
  masParamCon += silent ? ";nogui" : "";

  try {
    if (!AQSql.addDatabase(driver, nombreBD, usuario, password, host, puerto, codTienda, masParamCon)) {
      if (!flfactppal.iface.pub_appendTextToLogFile(_i.nombreLog_, "Error al abrir la conexión de " + codTienda)) {
        sys.infoMsgBox("Error al abrir la conexión de " + codTienda);
      }
      return false;
    }
  } catch (e) {
    if (!flfactppal.iface.pub_appendTextToLogFile(_i.nombreLog_, "Error al abrir la conexión de " + codTienda)) {
      sys.infoMsgBox("Error al abrir la conexión de " + codTienda);
    }
    return false;
  }

  if (!flfactppal.iface.pub_appendTextToLogFile(_i.nombreLog_, "Conectado a " + codTienda)) {
    if (silent) {
      sys.infoMsgBox("Conectado a " + codTienda);
    }
  }
  return true;

}

function sincro_desconectar(codTienda, silent)
{
  var _i = this.iface;

  var cxTienda = codTienda;
  var dbTienda = AQSql.database(cxTienda);

  if (dbTienda.connectionName() == cxTienda && !dbTienda.isOpen()) {
    msg = sys.translate("Conexión con " + codTienda + " no establecida");
    if (!flfactppal.iface.pub_appendTextToLogFile(_i.nombreLog_, msg)) {
      sys.infoMsgBox(msg);
    }
    return true;
  }

  if (!sys.removeDatabase(codTienda)) {
    if (!flfactppal.iface.pub_appendTextToLogFile(_i.nombreLog_, "Error en la desconexión")) {
      sys.infoMsgBox("Error en la desconexión");
    }
    return false;
  }
  if (!flfactppal.iface.pub_appendTextToLogFile(_i.nombreLog_, "Desconectado de " + codTienda)) {
    sys.infoMsgBox("Desconectado de " + codTienda);
  }
  return true;
}

function sincro_sincronizarArqueos(cxCentral, cxTienda)
{
  var _i = this.iface;

  var listaArqueos = _i.listaArqueosTienda(cxTienda);
  if (!listaArqueos) {
    return false;
  }
  var totalArqueos = listaArqueos.length;
  if (totalArqueos == 0) {
    return false;
  }
  var curTransaccion = new FLSqlCursor("tpv_datosgenerales", cxCentral);
  var listaOK = "";
  var listaMal = "";
  for (var i = 0; i < totalArqueos; i++) {
    curTransaccion.transaction(false);
    try {
      if (_i.sincronizarArqueo(listaArqueos[i], cxCentral, cxTienda)) {
        curTransaccion.commit();
        if (listaOK != "") {
          listaOK += ", ";
        }
        listaOK += listaArqueos[i];
      } else {
        curTransaccion.rollback();
        if (listaMal != "") {
          listaMal += ", ";
        }
        listaMal += listaArqueos[i];
        if (!_i.silent_) {
          var res = MessageBox.warning(sys.translate("Ha habido un error en la sicronización con el arqueo %1\n¿Desea continuar con el siguiente, si lo hay?").arg(listaArqueos[i]), MessageBox.Yes, MessageBox.No);
          if (res != MessageBox.Yes) {
            break;
          }
        }
      }
    } catch (e) {
      curTransaccion.rollback();
      if (listaMal != "") {
        listaMal += ", ";
      }
      listaMal += listaArqueos[i];
      if (!_i.silent_) {
        var res = MessageBox.warning(sys.translate("Ha habido un error en la sicronización con el arqueo %1\n¿Desea continuar con el siguiente, si lo hay?").arg(listaArqueos[i]), MessageBox.Yes, MessageBox.No);
        if (res != MessageBox.Yes) {
          break;
        }
      }
    }
  }
  if (listaOK == "") {
    listaOK = sys.translate("(ninguno)");
  }
  if (listaMal == "") {
    listaMal = sys.translate("(ninguno)");
  }
  _i.msgSincro_ = "";
  var mensaje = sys.translate("Arqueos sincronizados: %1\nArqueos NO sincronizados: %2").arg(listaOK).arg(listaMal);
  _i.msgSincro_ += mensaje + "\n";
  return true;
}

function sincro_sincronizarVentas(cxCentral, cxTienda)
{
  var _i = this.iface;

  var listaOK = "";
  var listaMal = "";

  var curVentasTienda = _i.dameCurVentasTienda(cxTienda); /// Devuelve cursor sobre las ventas no sincronizadas
  var curT = new FLSqlCursor("empresa", cxTienda);
  var curC = new FLSqlCursor("empresa", cxCentral);
  while (curVentasTienda.next()) {
    curVentasTienda.setModeAccess(curVentasTienda.Browse);
    curVentasTienda.refreshBuffer();
    curT.transaction(false);
    curC.transaction(false);
    try {
      if (_i.sincronizarComanda(curVentasTienda, cxCentral, cxTienda)) {
        curC.commit();
        curT.commit();
        if (listaOK != "") {
          listaOK += ", ";
        }
        listaOK += curVentasTienda.valueBuffer("codigo");
      } else {
        curC.rollback();
        curT.rollback();
        if (listaMal != "") {
          listaMal += ", ";
        }
        listaMal += curVentasTienda.valueBuffer("codigo");
        if (!_i.silent_) {
          var res = MessageBox.warning(sys.translate("Ha habido un error en la sicronización de la venta %1\n¿Desea continuar con el siguiente, si lo hay?").arg(curVentasTienda.valueBuffer("codigo")), MessageBox.Yes, MessageBox.No);
          if (res != MessageBox.Yes) {
            break;
          }
        }
      }
    } catch (e) {
      curC.rollback();
      curT.rollback();
      if (listaMal != "") {
        listaMal += ", ";
      }
      listaMal += curVentasTienda.valueBuffer("codigo");
      if (!flfactppal.iface.pub_appendTextToLogFile(_i.nombreLog_, e)) {
        sys.infoMsgBox(e);
      }
      if (!_i.silent_) {
        var res = MessageBox.warning(sys.translate("Ha habido un error en la sicronización de la venta %1\n¿Desea continuar con el siguiente, si lo hay?").arg(curVentasTienda.valueBuffer("codigo")), MessageBox.Yes, MessageBox.No);
        if (res != MessageBox.Yes) {
          break;
        }
      }
    }
  }
  if (listaOK == "") {
    listaOK = sys.translate("(ninguna)");
  }
  if (listaMal == "") {
    listaMal = sys.translate("(ninguna)");
  }
  var mensaje = sys.translate("Ventas sincronizadas: %1\nVentas NO sincronizadas: %2").arg(listaOK).arg(listaMal);
  _i.msgSincro_ += mensaje + "\n";
  return true;
}

function sincro_listaArqueosTienda(cxTienda)
{
  var _i = this.iface;
  var cursor = this.cursor();

  var qryArqueoTienda = new FLSqlQuery("", cxTienda);
  qryArqueoTienda.setTablesList("tpv_arqueos");
  qryArqueoTienda.setSelect("idtpv_arqueo, diadesde, diahasta");
  qryArqueoTienda.setFrom("tpv_arqueos");
  qryArqueoTienda.setWhere("sincronizado <> true ORDER BY diadesde");
  qryArqueoTienda.setForwardOnly(true);
  if (!qryArqueoTienda.exec()) {
    return false;
  }
  var totalArqueos = qryArqueoTienda.size();
  if (totalArqueos == 0) {
    MessageBox.warning(sys.translate("No hay arqueos que sincronizar en la tienda %1.").arg(cursor.valueBuffer("codtienda")), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  /** Muestra un cuadro de diálogo con casillas donde seleccionar los arqueos a sincronizar. Se comenta porque se quieren sincronizar todos.
  Se cambia todo el código por el escrito abajo.

  var listaArqueos = new Array(totalArqueos);

  var dialogo = new Dialog;
  dialogo.okButtonText = sys.translate("Aceptar");
  dialogo.cancelButtonText = sys.translate("Cancelar");

  var gbxDialogo = new GroupBox;
  gbxDialogo.title = sys.translate("Seleccione los arqueos a sincronizar");

  var chkArqueo = new Array(totalArqueos);
  var i = 0;
  var codArqueo;
  while (qryArqueoTienda.next()) {
    codArqueo = qryArqueoTienda.value("idtpv_arqueo");
    chkArqueo[i] = new CheckBox;
    chkArqueo[i].text = sys.translate("Arqueo %1 del %2 al %3").arg(codArqueo).arg(AQUtil.dateAMDtoDMA(qryArqueoTienda.value("diadesde"))).arg(AQUtil.dateAMDtoDMA(qryArqueoTienda.value("diahasta")));
    chkArqueo[i].checked = false;
    gbxDialogo.add(chkArqueo[i]);
    listaArqueos[i] = codArqueo;
    i++
  }

  dialogo.add(gbxDialogo);
  if (!dialogo.exec()) {
    return false;
  }
  var listaSeleccionados = [];
  for (var k = 0; k < totalArqueos; k++) {
    if (chkArqueo[k].checked) {
      listaSeleccionados[listaSeleccionados.length] = listaArqueos[k];
    }
  }
  return listaSeleccionados;*/

  var listaArqueos = new Array(totalArqueos);
  var i = 0;

  while (qryArqueoTienda.next()) {
    codArqueo = qryArqueoTienda.value("idtpv_arqueo");
    listaArqueos[i] = codArqueo;
    i++;
  }

  return listaArqueos;
}

function sincro_sincronizarArqueo(codArqueo, cxCentral, cxTienda)
{
  var _i = this.iface;

  var curArqueoTienda = new FLSqlCursor("tpv_arqueos", cxTienda);
  curArqueoTienda.setActivatedCommitActions(false);
  curArqueoTienda.setActivatedCheckIntegrity(false);
  curArqueoTienda.select("idtpv_arqueo = '" + codArqueo + "'");
  if (!curArqueoTienda.first()) {
    MessageBox.warning(sys.translate("Error al obtener el arqueo remoto %1").arg(codArqueo), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  curArqueoTienda.setModeAccess(curArqueoTienda.Edit);
  curArqueoTienda.refreshBuffer();

  var abierto = curArqueoTienda.valueBuffer("abierta");

  if (!_i.curArqueoCentral_) {
    _i.curArqueoCentral_ = new FLSqlCursor("tpv_arqueos", cxCentral);
  }

  ///Si no existe el arqueo en la central se pone en modo insert, y si existe en modo edit.
  _i.curArqueoCentral_.select("idtpv_arqueo = '" + codArqueo + "'");
  if (!_i.curArqueoCentral_.first()) {
    _i.curArqueoCentral_.setModeAccess(_i.curArqueoCentral_.Insert);
  } else {
    _i.curArqueoCentral_.setModeAccess(_i.curArqueoCentral_.Edit);
  }
  _i.curArqueoCentral_.refreshBuffer();
  _i.curArqueoCentral_.setUnLock("abierta", true);

  var campos = AQUtil.nombreCampos("tpv_arqueos");
  var totalCampos = campos[0];

  var campoInformado = [];
  for (var i = 1; i <= totalCampos; i++) {
    campoInformado[campos[i]] = false;
  }
  for (var i = 1; i <= totalCampos; i++) {
    if (!_i.sincroCampoArqueo(campos[i], curArqueoTienda, campoInformado)) {
      return false;
    }
  }
  if (!_i.curArqueoCentral_.commitBuffer()) {
    return false;
  }

  if (!_i.sincronizarMovimientos(codArqueo, cxCentral, cxTienda)) {
    return false;
  }
  //  _i.curArqueoCentral_.select("idtpv_arqueo = '" + codArqueo + "'");
  //  if (!_i.curArqueoCentral_.first()) {
  //    return false;
  //  }
  //  _i.curArqueoCentral_.setModeAccess(_i.curArqueoCentral_.Edit);
  //  _i.curArqueoCentral_.refreshBuffer();
  //  var fechaHasta = _i.curArqueoCentral_.valueBuffer("diahasta");
  //  if(!fechaHasta){
  //    fechaHasta = new Date();
  //  }
  //  _i.curArqueoCentral_.setValueBuffer("diahasta", fechaHasta);
  //  _i.curArqueoCentral_.setValueBuffer("abierta", false);
  //  if (!_i.curArqueoCentral_.commitBuffer()) {
  //    return false;
  //  }

  if (!abierto) {
    curArqueoTienda.setUnLock("abierta", true);
    curArqueoTienda.select("idtpv_arqueo = '" + codArqueo + "'");
    if (!curArqueoTienda.first()) {
      return false,
    }
           curArqueoTienda.setModeAccess(curArqueoTienda.Edit);
    curArqueoTienda.refreshBuffer();
    curArqueoTienda.setValueBuffer("sincronizado", true);
    if (!curArqueoTienda.commitBuffer()) {
      return false;
    }
    curArqueoTienda.select("idtpv_arqueo = '" + codArqueo + "'");
    if (!curArqueoTienda.first()) {
      return false,
    }
           curArqueoTienda.setUnLock("abierta", false);
  }
  return true;
}

function sincro_sincronizarMovimientos(codArqueo, cxCentral, cxTienda)
{
  var _i = this.iface;

  if (!_i.curMovimientoCentral_) {
    _i.curMovimientoCentral_ = new FLSqlCursor("tpv_movimientos", cxCentral);
    _i.curMovimientoCentral_.setActivatedCommitActions(false);
    _i.curMovimientoCentral_.setActivatedCheckIntegrity(false);
  }
  /*
  _i.curMovimientoCentral_.select("idtpv_arqueo = '" + codArqueo + "'");
  if (_i.curMovimientoCentral_.first()) {
    _i.curMovimientoCentral_.setModeAccess(_i.curMovimientoCentral_.Del);
    _i.curMovimientoCentral_.refreshBuffer();
    if (!_i.curMovimientoCentral_.commitBuffer()) {
      return false;
    }
  }*/

  if (!AQUtil.sqlDelete("tpv_movimientos", "idtpv_arqueo = '" + codArqueo + "'", cxCentral)) {
    return false;
  }

  var campos = AQUtil.nombreCampos("tpv_movimientos");
  var totalCampos = campos[0];
  var campoInformado = [];

  var curMovimientoTienda = new FLSqlCursor("tpv_movimientos", cxTienda);
  curMovimientoTienda.setActivatedCommitActions(false);
  curMovimientoTienda.setActivatedCheckIntegrity(false);
  curMovimientoTienda.select("idtpv_arqueo = '" + codArqueo + "'");
  while (curMovimientoTienda.next()) {
    curMovimientoTienda.setModeAccess(curMovimientoTienda.Browse);
    curMovimientoTienda.refreshBuffer();

    _i.curMovimientoCentral_.setModeAccess(_i.curMovimientoCentral_.Insert);
    _i.curMovimientoCentral_.refreshBuffer();

    for (var i = 1; i <= totalCampos; i++) {
      campoInformado[campos[i]] = false;
    }
    for (var i = 1; i <= totalCampos; i++) {
      if (!_i.sincroCampoMovimiento(campos[i], curMovimientoTienda, campoInformado)) {
        return false;
      }
    }
    if (!_i.curMovimientoCentral_.commitBuffer()) {
      return false;
    }
  }

  return true;
}

function sincro_sincronizarComanda(curVentasTienda, cxCentral, cxTienda)
{
  var _i = this.iface;
  /// NOTA. El cursor curComandaCentral_ debe quedar en modo Edit tras la sincronización de cabecera para que otras llamadas asociadas a los after / beforecommir (como la gestión de puntos) funcionen y pueda accederse a los datos de la comanda.
  if (!_i.sincronizarCabeceraComanda(curVentasTienda, cxCentral, cxTienda)) {
    return false;
  }
  if (!_i.sincronizarLineasComanda(curVentasTienda, cxCentral, cxTienda)) {
    return false;
  }
  if (!_i.sincronizarPagosComanda(curVentasTienda, cxCentral, cxTienda)) {
    return false;
  }
  if (!_i.marcarComandaSincronizada(curVentasTienda, cxCentral, cxTienda)) {
    return false;
  }

  return true;
}

function sincro_sincronizarCabeceraComanda(curVentasTienda, cxCentral, cxTienda)
{
  var _i = this.iface;

  if (!_i.curComandaCentral_) {
    _i.curComandaCentral_ = new FLSqlCursor("tpv_comandas", cxCentral);
    _i.curComandaCentral_.setActivatedCommitActions(false);
    _i.curComandaCentral_.setActivatedCheckIntegrity(false);
  }

  var campos = AQUtil.nombreCampos("tpv_comandas");
  var totalCampos = campos[0];
  var campoInformado = [];

  curVentasTienda.setActivatedCommitActions(false);
  curVentasTienda.setActivatedCheckIntegrity(false);

  curVentasTienda.setModeAccess(curVentasTienda.Edit);
  curVentasTienda.refreshBuffer();

  var codComanda = curVentasTienda.valueBuffer("codigo");

  for (var i = 1; i <= totalCampos; i++) {
    campoInformado[campos[i]] = false;
  }

  _i.curComandaCentral_.select("codigo = '" + codComanda + "'");
  if (_i.curComandaCentral_.first()) {
    _i.curComandaCentral_.setModeAccess(_i.curComandaCentral_.Edit);
  } else {
    _i.curComandaCentral_.setModeAccess(_i.curComandaCentral_.Insert);
  }
  _i.curComandaCentral_.refreshBuffer();

  for (var i = 1; i <= totalCampos; i++) {
    if (!_i.sincroCampoComanda(campos[i], curVentasTienda, campoInformado)) {
      return false;
    }
  }
  var idComandaCentral = _i.curComandaCentral_.valueBuffer("idtpv_comanda");
  if (!_i.curComandaCentral_.commitBuffer()) {
    return false;
  }

  /// Se pone el cursor con modo Edit para su uso posterior
  _i.curComandaCentral_.select("idtpv_comanda = " + idComandaCentral);
  if (!_i.curComandaCentral_.first()) {
    return false;
  }
  _i.curComandaCentral_.setModeAccess(_i.curComandaCentral_.Edit);
  _i.curComandaCentral_.refreshBuffer();

  return true;
}

function sincro_marcarComandaSincronizada(curVentasTienda, cxCentral, cxTienda)
{
  var _i = this.iface;

  curVentasTienda.setActivatedCommitActions(false);
  curVentasTienda.setActivatedCheckIntegrity(false);

  curVentasTienda.setModeAccess(curVentasTienda.Edit);
  curVentasTienda.refreshBuffer();

  var codComanda = curVentasTienda.valueBuffer("codigo");

  var hoy = new Date();
  curVentasTienda.setValueBuffer("fechasincro", hoy);
  if (curVentasTienda.valueBuffer("estado") == "Cerrada") {
    curVentasTienda.setValueBuffer("sincronizada", true);
  }
  if (!curVentasTienda.commitBuffer()) {
    return false;
  }

  return true;
}

function sincro_sincronizarLineasComanda(curVentasTienda, cxCentral, cxTienda)
{
  var _i = this.iface;

  var idComanda = curVentasTienda.valueBuffer("idtpv_comanda");
  var codComanda = curVentasTienda.valueBuffer("codigo");

  //  _i.curComandaCentral_.select("codigo = '" + codComanda + "'");
  //  _i.curComandaCentral_.setModeAccess(_i.curComandaCentral_.Browse);
  //  _i.curComandaCentral_.refreshBuffer();
  var idComandaCentral = _i.curComandaCentral_.valueBuffer("idtpv_comanda");

  if (!_i.curLineaComandaCentral_) {
    _i.curLineaComandaCentral_ = new FLSqlCursor("tpv_lineascomanda", cxCentral);
  }
  _i.curLineaComandaCentral_.select("idtpv_comanda = " + idComandaCentral);
  while (_i.curLineaComandaCentral_.next()) {
    _i.curLineaComandaCentral_.setModeAccess(_i.curLineaComandaCentral_.Del);
    _i.curLineaComandaCentral_.refreshBuffer();
    if (!_i.curLineaComandaCentral_.commitBuffer()) {
      return false;
    }
  }

  var campos = AQUtil.nombreCampos("tpv_lineascomanda");
  var totalCampos = campos[0];
  var campoInformado = [];

  var curLineaTienda = new FLSqlCursor("tpv_lineascomanda", cxTienda);
  curLineaTienda.setActivatedCommitActions(false);
  curLineaTienda.setActivatedCheckIntegrity(false);
  curLineaTienda.select("idtpv_comanda = '" + idComanda + "'");

  while (curLineaTienda.next()) {
    curLineaTienda.setModeAccess(curLineaTienda.Browse);
    curLineaTienda.refreshBuffer();

    _i.curLineaComandaCentral_.setModeAccess(_i.curLineaComandaCentral_.Insert);
    _i.curLineaComandaCentral_.refreshBuffer();

    _i.curLineaComandaCentral_.setValueBuffer("idtpv_comanda", idComandaCentral);
    for (var i = 1; i <= totalCampos; i++) {
      campoInformado[campos[i]] = false;
    }
    for (var i = 1; i <= totalCampos; i++) {
      if (!_i.sincroCampoLineaComanda(campos[i], curLineaTienda, campoInformado)) {
        return false;
      }
    }
    if (!_i.curLineaComandaCentral_.commitBuffer()) {
      return false;
    }
  }
  return true;
}

function sincro_sincroCampoArqueo(nombreCampo, curOriginal, campoInformado)
{
  var _i = this.iface;

  if (campoInformado[nombreCampo]) {
    return true;
  }
  var nulo = false;

  switch (nombreCampo) {
    case "idasiento": {
      return true;
      break;
    }
    case "abierta": {
      valor = true;
      break;
    }
    default: {
      if (curOriginal.isNull(nombreCampo)) {
        var mtd = _i.mgr_.metadata(curOriginal.table());
        var mtdF = mtd.field(nombreCampo);
        if (!mtdF.allowNull()) {
          valor = mtdF.defaultValue();
        } else {
          nulo = true;
        }
      } else {
        valor = curOriginal.valueBuffer(nombreCampo);
      }
    }
  }
  if (nulo) {
    _i.curArqueoCentral_.setNull(nombreCampo);
  } else {
    _i.curArqueoCentral_.setValueBuffer(nombreCampo, valor);
  }
  campoInformado[nombreCampo] = true;

  return true;
}

function sincro_sincronizarPagosComanda(curVentasTienda, cxCentral, cxTienda)
{
  var _i = this.iface;
  var idComanda = curVentasTienda.valueBuffer("idtpv_comanda");
  var codComanda = curVentasTienda.valueBuffer("codigo");

  //  _i.curComandaCentral_.select("codigo = '" + codComanda + "'");
  //  _i.curComandaCentral_.setModeAccess(_i.curComandaCentral_.Browse);
  //  _i.curComandaCentral_.refreshBuffer();//
  var idComandaCentral = _i.curComandaCentral_.valueBuffer("idtpv_comanda");

  if (!_i.curPagoCentral_) {
    _i.curPagoCentral_ = new FLSqlCursor("tpv_pagoscomanda", cxCentral);
    /// Para que se ejecuten funciones como la asignación de puntos de tarjeta
    //    _i.curPagoCentral_.setActivatedCommitActions(false);
    //    _i.curPagoCentral_.setActivatedCheckIntegrity(false);
  }

  if (!AQUtil.sqlDelete("tpv_pagoscomanda", "idtpv_comanda = " + idComandaCentral, cxCentral)) {
    return false;
  }

  var campos = AQUtil.nombreCampos("tpv_pagoscomanda");
  var totalCampos = campos[0];
  var campoInformado = [];


  var curPagoTienda = new FLSqlCursor("tpv_pagoscomanda", cxTienda);
  curPagoTienda.setActivatedCommitActions(false);
  curPagoTienda.setActivatedCheckIntegrity(false);
  curPagoTienda.select("idtpv_comanda = '" + idComanda + "'");

  while (curPagoTienda.next()) {
    curPagoTienda.setModeAccess(curPagoTienda.Browse);
    curPagoTienda.refreshBuffer();

    _i.curPagoCentral_.setModeAccess(_i.curPagoCentral_.Insert);
    _i.curPagoCentral_.refreshBuffer();

    _i.curPagoCentral_.setValueBuffer("idtpv_comanda", idComandaCentral);
    for (var i = 1; i <= totalCampos; i++) {
      campoInformado[campos[i]] = false;
    }
    for (var i = 1; i <= totalCampos; i++) {
      if (!_i.sincroCampoPago(campos[i], curPagoTienda, campoInformado)) {
        return false;
      }
    }
    if (!_i.curPagoCentral_.commitBuffer()) {
      return false;
    }
  }
  return true;
}

function sincro_sincroCampoPago(nombreCampo, curOriginal, campoInformado)
{
  var _i = this.iface;

  if (campoInformado[nombreCampo]) {
    return true;
  }
  var nulo = false;

  switch (nombreCampo) {
    case "idtpv_comanda":
    case "idpago": {
      return true;
      break;
    }
    default: {
      if (curOriginal.isNull(nombreCampo)) {
        var mtd = _i.mgr_.metadata(curOriginal.table());
        var mtdF = mtd.field(nombreCampo);
        if (!mtdF.allowNull()) {
          valor = mtdF.defaultValue();
        } else {
          nulo = true;
        }
      } else {
        valor = curOriginal.valueBuffer(nombreCampo);
      }
    }
  }
  if (nulo) {
    _i.curPagoCentral_.setNull(nombreCampo);
  } else {
    _i.curPagoCentral_.setValueBuffer(nombreCampo, valor);
  }
  campoInformado[nombreCampo] = true;

  return true;
}

function sincro_sincroCampoMovimiento(nombreCampo, curOriginal, campoInformado)
{
  var _i = this.iface;

  if (campoInformado[nombreCampo]) {
    return true;
  }
  var nulo = false;

  switch (nombreCampo) {
    case "idtpv_comanda": {
      return true;
      break;
    }
    default: {
      if (curOriginal.isNull(nombreCampo)) {
        var mtd = _i.mgr_.metadata(curOriginal.table());
        var mtdF = mtd.field(nombreCampo);
        if (!mtdF.allowNull()) {
          valor = mtdF.defaultValue();
        } else {
          nulo = true;
        }
      } else {
        valor = curOriginal.valueBuffer(nombreCampo);
      }
    }
  }
  if (nulo) {
    _i.curMovimientoCentral_.setNull(nombreCampo);
  } else {
    _i.curMovimientoCentral_.setValueBuffer(nombreCampo, valor);
  }
  campoInformado[nombreCampo] = true;

  return true;
}

function sincro_sincroCampoComanda(nombreCampo, curOriginal, campoInformado)
{
  var _i = this.iface;

  if (campoInformado[nombreCampo]) {
    return true;
  }
  var nulo = false;

  switch (nombreCampo) {
    case "idtpv_comanda": {
      return true;
      break;
    }
    default: {
      if (curOriginal.isNull(nombreCampo)) {
        var mtd = _i.mgr_.metadata(curOriginal.table());
        var mtdF = mtd.field(nombreCampo);
        if (!mtdF.allowNull()) {
          valor = mtdF.defaultValue();
        } else {
          nulo = true;
        }
      } else {
        valor = curOriginal.valueBuffer(nombreCampo);
      }
    }
  }
  if (nulo) {
    _i.curComandaCentral_.setNull(nombreCampo);
  } else {
    _i.curComandaCentral_.setValueBuffer(nombreCampo, valor);
  }
  campoInformado[nombreCampo] = true;

  return true;
}

function sincro_sincroCampoLineaComanda(nombreCampo, curOriginal, campoInformado)
{
  var _i = this.iface;

  if (campoInformado[nombreCampo]) {
    return true;
  }
  var nulo = false;

  switch (nombreCampo) {
    case "idtpv_comanda":
    case "idtpv_linea": {
      return true;
      break;
    }
    default: {
      if (curOriginal.isNull(nombreCampo)) {
        var mtd = _i.mgr_.metadata(curOriginal.table());
        var mtdF = mtd.field(nombreCampo);
        if (!mtdF.allowNull()) {
          valor = mtdF.defaultValue();
        } else {
          nulo = true;
        }
      } else {
        valor = curOriginal.valueBuffer(nombreCampo);
      }
    }
  }
  if (nulo) {
    _i.curLineaComandaCentral_.setNull(nombreCampo);
  } else {
    _i.curLineaComandaCentral_.setValueBuffer(nombreCampo, valor);
  }
  campoInformado[nombreCampo] = true;

  return true;
}

function sincro_dameCurVentasTienda(cxTienda)
{
  var _i = this.iface;

  var curVentas = new FLSqlCursor("tpv_comandas", cxTienda);
  curVentas.select("NOT sincronizada AND tipodoc <> 'PRESUPUESTO'");

  return curVentas;
}

function sincro_dameMensajeSincro()
{
  var _i = this.iface;

  return _i.msgSincro_;
}

function sincro_tbnSincronizarTienda_clicked()
{
  var _i = this.iface;
  var cursor = this.cursor();
  _i.silent_ = false;

  if (!_i.lanzaSincronizacion(cursor)) {
    return false;
  }
  return true;
}

function sincro_lanzaSincronizacion(cursor)
{
  var _i = this.iface;

  if (!_i.mgr_) {
    _i.mgr_ = aqApp.db().manager();
  }

  var codTienda = cursor.valueBuffer("codtienda");
  if (!codTienda) {
    return false;
  }
  try {
    if (!_i.conectar(codTienda)) {
      return false;
    }

    if (!_i.sincronizacion(cursor, codTienda, false, false, false)) {
      return false;
    }
    return true;
  } catch (e) {
    sys.infoMsgBox("Errores al lanzar la sincronización: " + e);
    return false;
  }
}

function sincro_dameNombreLog(esquema)
{
  var _i = this.iface;
  var cursor = this.cursor()

               var fecha = new Date();
  var dia = fecha.getDate().toString();
  if (dia.length < 2) {
    dia = "0" + dia;
  }
  var mes = fecha.getMonth().toString();
  if (mes.length < 2) {
    mes = "0" + mes;
  }
  var anyo = fecha.getYear().toString();
  var hora = fecha.getHours().toString();
  if (hora.length < 2) {
    hora = "0" + hora;
  }
  var minuto = fecha.getMinutes().toString();
  if (minuto.length < 2) {
    minuto = "0" + minuto;
  }
  var prefijo;
  if (esquema && esquema != "") {
    prefijo = esquema;
  } else {
    prefijo = "sincroTpv";
  }

  var nombreFichero = prefijo + "_" + anyo + mes + dia + hora + minuto + ".txt"

                      return nombreFichero;
}

function sincro_sincronizacion(cursor, conRemota, esquema, otros, silent)
{
  var _i = this.iface;

  if (silent) {
    if (!flfactppal.iface.pub_appendTextToLogFile(_i.nombreLog_, "Cargando esquema " + esquema)) {
      sys.infoMsgBox("Cargando esquema " + esquema);
    }
  }
  var oParamEsquema = _i.esquemaSincro(cursor, esquema, otros);
  if (!oParamEsquema) {
    return false;
  }
  if (!silent) {
    var nombreLog = _i.dameNombreLog(oParamEsquema.esquema);
    _i.nombreLog_ = flfactalma.iface.pub_ponLogName(nombreLog);
    var dirLog = flfact_tpv.iface.pub_valorDefectoTPV("dirlogs");

    if (!dirLog || dirLog == "") {
      dirLog = Dir.home;
    }
    if (dirLog.endsWith("/")) {
      _i.nombreFile_ = dirLog + nombreLog;
    } else {
      _i.nombreFile_ = dirLog + "/" + nombreLog;
    }

    if (!flfactppal.iface.pub_abreLogFile(_i.nombreLog_, _i.nombreFile_)) {
      return false;
    }
  }

  esquema = oParamEsquema.esquema;
  flfactppal.iface.pub_appendTextToLogFile(_i.nombreLog_, "Esquema " + esquema + " cargado con éxito\nSilent " + silent);
  flfactalma.iface.pub_ponTiendaActual(oParamEsquema);
  flfactalma.iface.pub_establecerConexionesSinc("default", conRemota);
  flfactppal.iface.pub_appendTextToLogFile(_i.nombreLog_, "Iniciando sincronización de esquema " + esquema);
  if (!flfactalma.iface.pub_sincronizarTrans(silent, oParamEsquema.esquema)) {
    if (!flfactppal.iface.pub_appendTextToLogFile(_i.nombreLog_, "Falló la sincronización del esquema " + esquema)) {
      sys.infoMsgBox("Falló la sincronización del esquema " + esquema);
    }
    return false;
  }
  flfactppal.iface.pub_appendTextToLogFile(_i.nombreLog_, "Esquema " + esquema + " sincronizado con éxito");
  if (!_i.actualizacionesEsquema(oParamEsquema, cursor)) {
    if (!flfactppal.iface.pub_appendTextToLogFile(_i.nombreLog_, "Falló la actualización de datos tras la sincronización del esquema " + esquema)) {
      sys.infoMsgBox("Falló la actualización de datos tras la sincronización del esquema " + esquema);
    }
    return false;
  }

  _i.muestraMensaje();

  return true;
}

function sincro_muestraMensaje()
{
  var _i = this.iface;
  var result = flfactalma.iface.pub_dameResultadosSincro();

  if (!flfactppal.iface.pub_appendTextToLogFile(_i.nombreLog_, "\n" + result + "\n")) {
    sys.infoMsgBox(result);
    return;
  }
  if (!_i.silent_) {
    sys.infoMsgBox(result);
  }
}

function sincro_actualizacionesEsquema(oParamEsquema, cursor)
{
  var _i = this.iface;

  switch (oParamEsquema.esquema) {
    case "CATALOGO": {
      var d = new Date;
      cursor.setModeAccess(cursor.Edit);
      cursor.refreshBuffer();
      cursor.setValueBuffer("fechasinccatalogo", d.toString());
      if (!cursor.commitBuffer()) {
        return false;
      }
      break;
    }
  }
  return true;
}

function sincro_paramEsquema(esquema, cursor, otros)
{
  var _i = this.iface;

  var oParam = new Object;
  switch (esquema) {
    case "CATALOGO": {
      oParam.esquema = esquema;
      oParam.codTienda = cursor.valueBuffer("codtienda");
      oParam.curTienda = cursor;
      if (_i.silent_) {
        oParam.sincroTotal = (otros == "T");
      } else {
        var dialog = new Dialog(sys.translate("Sincronizar catálogo en tiendas"), 0, "sincro");
        dialog.OKButtonText = sys.translate("Aceptar");
        dialog.cancelButtonText = sys.translate("Cancelar");
        var bgroup = new GroupBox;
        dialog.add(bgroup);
        var chkTotal = new CheckBox;
        chkTotal.text = sys.translate("Sincronización total");
        chkTotal.checked = false;
        bgroup.add(chkTotal);
        if (!dialog.exec()) {
          return false;
        }
        oParam.sincroTotal = chkTotal.checked;
      }
      /// Por hacer. Función que en función del esquema seleccionado tome los parámetros correctos.
      oParam.filtroFecha = oParam.sincroTotal ? false : cursor.valueBuffer("fechasinccatalogo");
      oParam.fechaVentasTPV = oParam.sincroTotal ? false : cursor.valueBuffer("fechasinccatalogo");
      break;
    }
    default: {
      oParam.esquema = esquema;
      oParam.codTienda = cursor.valueBuffer("codtienda");
      oParam.curTienda = cursor;
      break;
    }
  }
  return oParam;
}

function sincro_esquemaSincro(cursor, esquema, otros)
{
  var _i = this.iface;
  var oParam;

  var esquemaSel;
  if (_i.silent_) {
    esquemaSel = esquema;
  } else {
    var esquemas = _i.posiblesEsquemasSincro();
    var nombres = [];
    for (var i = 0; i < esquemas.length; i++) {
      nombres.push(esquemas[i][1]);
    }
    var iEsquema = flfactppal.iface.pub_elegirOpcion(nombres, sys.translate("Seleccione esquema de sincronización"));
    if (iEsquema < 0) {
      return;
    }
    esquemaSel = esquemas[iEsquema][0];
  }
  flfactppal.iface.pub_appendTextToLogFile(_i.nombreLog_, "Esquema Seleccionado " + esquemaSel);
  var oParam = _i.paramEsquema(esquemaSel, cursor, otros);
  if (!oParam) {
    return false;
  }
  oParam.masParam = otros;
  return oParam;
}

function sincro_posiblesEsquemasSincro()
{
  var e = [["VENTAS_TPV", sys.translate("Recepción de ventas")],
           ["RX_GENERAL", sys.translate("Recepción de datos general (ventas, inventarios, envíos y recepciones realizadas)")],
           ["TX_GENERAL", sys.translate("Transmisión de datos general (vales, stocks, envíos y recepciones pendientes)")],
           ["CATALOGO", sys.translate("Envío de catálogo de artículos")],
           ["STOCKS", sys.translate("Envío stocks")],
           ["DEVOLUCIONES", sys.translate("Envío de saldos de vales por devolución")],
           ["INVENTARIOS", sys.translate("Recepción de inventarios")],
           ["TPV_ENVIO_MULTITRANS", sys.translate("Envío de tranferencias a enviar y recibir por las tiendas")],
           ["TPV_RECEPCION_MULTITRANS", sys.translate("Recepción de envíos y recepciones realizados por las tiendas")],
           ["TX_CLIENTES", sys.translate("Envío de datos de clientes")],
           ["RX_CLIENTES", sys.translate("Recepción de datos de clientes")],
           ["TABLAS_BASE", sys.translate("Envío de tablas principales y de inicio")]];

  if (!sys.isLoadedModule("flcontacce")) {
    e[e.length] = ["CONTROL_ACCESO", sys.translate("Control de Acceso")]
  }

                return e;
}

//// SINCRO TPV //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
