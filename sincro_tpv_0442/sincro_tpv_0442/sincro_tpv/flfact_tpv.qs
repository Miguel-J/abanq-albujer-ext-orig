
/** @class_declaration sincroTPV */
/////////////////////////////////////////////////////////////////
//// SINCRO TPV //////////////////////////////////////////////////
class sincroTPV extends multi
{
  var cxCentral_, correo_;
  function sincroTPV(context)
  {
    multi(context);
  }
  function damePrefijo(curComanda)
  {
    return this.ctx.sincroTPV_damePrefijo(curComanda);
  }
  function beforeCommit_tpv_comandas(curComanda)
  {
    return this.ctx.sincroTPV_beforeCommit_tpv_comandas(curComanda);
  }
  function comprobarSincronizadaCentral(curComanda)
  {
    return this.ctx.sincroTPV_comprobarSincronizadaCentral(curComanda);
  }
  function sincronizarConFacturacion(curComanda)
  {
    return this.ctx.sincroTPV_sincronizarConFacturacion(curComanda);
  }
  function comprobarSincronizacion(curComanda)
  {
    return this.ctx.sincroTPV_comprobarSincronizacion(curComanda);
  }
  function conectaCentral()
  {
    return this.ctx.sincroTPV_conectaCentral();
  }
  function dameCxCentral()
  {
    return this.ctx.sincroTPV_dameCxCentral();
  }
  function beforeCommit_tpv_lineascomanda(curL)
  {
    return this.ctx.sincroTPV_beforeCommit_tpv_lineascomanda(curL);
  }
  function controlCamposSincroLineaComanda(curL)
  {
    return this.ctx.sincroTPV_controlCamposSincroLineaComanda(curL);
  }
  function datosActualizarSaldo(curC)
  {
    return this.ctx.sincroTPV_datosActualizarSaldo(curC);
  }
  function beforeCommit_tpv_lineasmultitransstock(curL)
  {
    return this.ctx.sincroTPV_beforeCommit_tpv_lineasmultitransstock(curL);
  }
  function controlIdSincroLineaMTS(curL)
  {
    return this.ctx.sincroTPV_controlIdSincroLineaMTS(curL);
  }
  function enviarMailLog(datosMail)
  {
    return this.ctx.sincroTPV_enviarMailLog(datosMail);
  }
  function beforeCommit_tpv_agentes(curA)
  {
    return this.ctx.sincroTPV_beforeCommit_tpv_agentes(curA);
  }
  function gestionSincroAgenteUp(curA)
  {
    return this.ctx.sincroTPV_gestionSincroAgenteUp(curA);
  }
  function statusChanged(msg, code)
  {
    return this.ctx.sincroTPV_statusChanged(msg, code);
  }
}
//// SINCRO TPV //////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration pubSincroTPV */
/////////////////////////////////////////////////////////////////
//// PUB SIN CRO ////////////////////////////////////////////////
class pubSincroTPV extends ifaceCtx
{
  function pubSincroTPV(context)
  {
    ifaceCtx(context);
  }
  function pub_esUnaTienda()
  {
    return this.esUnaTienda();
  }
  function pub_conectaCentral()
  {
    return this.conectaCentral();
  }
  function pub_dameCxCentral()
  {
    return this.dameCxCentral();
  }
  function pub_enviarMailLog(datosMail)
  {
    return this.enviarMailLog(datosMail);
  }
}
//// PUB SIN CRO ////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition sincroTPV */
/////////////////////////////////////////////////////////////////
//// SINCRO TPV /////////////////////////////////////////////////
function sincroTPV_damePrefijo(curComanda)
{
  var _i = this.iface;

  var prefijo = AQUtil.sqlSelect("tpv_tiendas", "prefijocod", "codtienda = '" + curComanda.valueBuffer("codtienda") + "'");
  if (!prefijo) {
    var res = MessageBox.warning(sys.translate("No tienes establecido un prefijo para los códigos de venta.\nLa sincronización con la central puede fallar por esta causa.\nPuede establecer el prefijo en la tabla de tiendas.\n¿Desea continuar creando una venta sin prefijo?"), MessageBox.No, MessageBox.Yes);
    if (res != MessageBox.Yes) {
      return false;
    }
    prefijo = "";
  }
  return prefijo;
}
//  var ultimoTiquet:Number = util.sqlSelect("tpv_secuenciascomanda", "valor", "prefijo = '" + prefijo + "'");
//
//  if (!ultimoTiquet) {
//    var idUltimo:String = util.sqlSelect("tpv_comandas", "codigo", "codigo LIKE '" + prefijo + "%' ORDER BY codigo DESC");
//
//    if (idUltimo) {
//      ultimoTiquet = parseFloat(idUltimo);
//    } else {
//      ultimoTiquet = 0;
//    }
//
//    var pass:String = util.readSettingEntry( "DBA/password");
//    var port:String = util.readSettingEntry( "DBA/port");
//    if (!sys.addDatabase(sys.nameDriver(), sys.nameBD(), sys.nameUser(), pass, sys.nameHost(), port, "conAux")) {
//      MessageBox.warning(sys.translate("Ha habido un error al establecer una conexión auxiliar con la base de datos %1").arg(sys.nameBD()), MessageBox.Ok, MessageBox.NoButton);
//      return false;
//    }
//    ultimoTiquet += 1;
//    var curSecuencia:FLSqlCursor = new FLSqlCursor("tpv_secuenciascomanda", "conAux");
//    curSecuencia.setModeAccess(curSecuencia.Insert);
//    curSecuencia.refreshBuffer();
//    curSecuencia.setValueBuffer("prefijo", prefijo);
//    curSecuencia.setValueBuffer("valor", ultimoTiquet);
//    if (!curSecuencia.commitBuffer()) {
//      return false;
//    }
//  }
//  else {
//    ultimoTiquet += 1;
//    util.sqlUpdate("tpv_secuenciascomanda", "valor", ultimoTiquet, "prefijo = '" + prefijo + "'");
//  }
//
//  var codigo:String = prefijo + flfacturac.iface.pub_cerosIzquierda(ultimoTiquet, 12 - prefijo.length);
//
//  return codigo;
// }


function sincroTPV_beforeCommit_tpv_comandas(curComanda)
{
  var _i = this.iface;

  if (!_i.comprobarSincronizadaCentral(curComanda)) {
    return false;
  }
  if (!_i.__beforeCommit_tpv_comandas(curComanda)) {
    return false;
  }
  return true;
}

function sincroTPV_comprobarSincronizadaCentral(curComanda)
{
  var _i = this.iface;

  switch (curComanda.modeAccess()) {
    case curComanda.Del: {
      if (curComanda.valueBuffer("sincronizada")) {
        MessageBox.warning(sys.translate("La venta está cerrada y sincronizada con la central.\nNo es posible eliminarla."), MessageBox.Ok, MessageBox.NoButton);
        return false;
      }
      if (curComanda.valueBuffer("fechasincro")) {
        MessageBox.warning(sys.translate("La venta está sincronizada con la central.\nNo es posible eliminarla."), MessageBox.Ok, MessageBox.NoButton);
        return false;
      }
      break;
    }
    case curComanda.Edit: {
      var cambiaCliente = (curComanda.valueBuffer("codcliente") != curComanda.valueBufferCopy("codcliente"));
      if (curComanda.valueBuffer("sincronizada") && !curComanda.valueBuffer("ptesincrocli") && !cambiaCliente) {
        MessageBox.warning(sys.translate("La venta está cerrada y sincronizada con la central.\nNo es posible modificarla."), MessageBox.Ok, MessageBox.NoButton);
        return false;
      }
      break;
    }
  }
  return true;
}

function sincroTPV_sincronizarConFacturacion(curComanda)
{
  var _i = this.iface;

  return _i.__sincronizarConFacturacion(curComanda);
}

function sincroTPV_comprobarSincronizacion(curComanda)
{
  var _i = this.iface;
  if (_i.esBDLocal()) {
    return true;
  }
  if (!_i.__comprobarSincronizacion(curComanda)) {
    return false;
  }
  return true;
}

function sincroTPV_conectaCentral()
{
  var _i = this.iface;
  if (flfactalma.iface.pub_conectarSinc("CX_CENTRAL")) {
    _i.cxCentral_ = "CX_CENTRAL";
  } else {
    _i.cxCentral_ = false;
    return false;
  }
  return true;
}

function sincroTPV_dameCxCentral()
{
  var _i = this.iface;
  return _i.cxCentral_ = "CX_CENTRAL";
}

function sincroTPV_beforeCommit_tpv_lineascomanda(curL)
{
  var _i = this.iface;
  /*
  if (!_i.__beforeCommit_tpv_lineascomanda(curL)) {
    return false;
  }
  */
  //   if (!_i.controlCamposSincroLineaComanda(curL)) {
  //     return false;
  //   }
  return true;

}

function sincroTPV_datosActualizarSaldo(curC)
{
  var _i = this.iface;
  curC.setValueBuffer("sincronizada", false);
  if (_i.esBDLocal()) {
    curC.setValueBuffer("saldonosincro", formRecordtpv_comandas.iface.pub_commonCalculateField("saldonosincro", curC));
    curC.setValueBuffer("saldopendiente", formRecordtpv_comandas.iface.pub_commonCalculateField("saldopendiente", curC));
    //    curC.setValueBuffer("ptesaldo", true); No porque se usa l campo sincronizada para controlar también esto
  }
  return true;
}

function sincroTPV_beforeCommit_tpv_lineasmultitransstock(curL)
{
  var _i = this.iface;
  if (!_i.__beforeCommit_tpv_lineasmultitransstock(curL)) {
    return false;
  }
  if (!_i.controlIdSincroLineaMTS(curL)) {
    return false;
  }
  return true;
}

function sincroTPV_controlIdSincroLineaMTS(curL)
{
  var _i = this.iface;
  switch (curL.modeAccess()) {
    case curL.Insert:
    case curL.Edit: {
      if (curL.isNull("idsincro")) {
        var idSincro;
        if (_i.esBDLocal()) {
          var codTerminal = flfact_tpv.iface.pub_valorDefectoTPV("codterminal");
          if (!codTerminal) {
            return false;
          }
          idSincro = codTerminal + "_" + curL.valueBuffer("idlinea");
        } else {
          idSincro = "CENTRAL_" + curL.valueBuffer("idlinea");
        }
        curL.setValueBuffer("idsincro", idSincro);
      }
      break;
    }
  }
  return true;
}

// function sincroTPV_controlCamposSincroLineaComanda(curL)
// {
// debug("sincroTPV_controlCamposSincroLineaComanda");
//   switch (curL.modeAccess()) {
//   case curL.Insert: {
//       var curCom = curL.cursorRelation();
//       if (curCom && curCom.table() == "tpv_comandas") {
//         curL.setValueBuffer("codcomanda", curCom.valueBuffer("codigo"));
//       } else {
//         var q = new AQSqlQuery;
//         q.setSelect("codigo");
//         q.setFrom("tpv_comandas");
//         q.setWhere("idtpv_comanda = " + curL.valueBuffer("idtpv_comanda"));
// debug(q.sql());
//         if (!q.exec()) {
//           return false;
//         }
//         if (!q.first()) {
//           return false;
//         }
//         curL.setValueBuffer("codcomanda", q.value("codigo"));
//       }
//       break;
//     }
//   }
//   return true;
// }


function sincroTPV_enviarMailLog(datosMail)
{
  var _i = this.iface;

  if (!datosMail)
    return false;

  if (!datosMail.to || datosMail.to == "")
    return;

  var arrayTo = datosMail.to.split(",");

  var curSmtp = new FLSqlCursor("tpv_datosgenerales");
  curSmtp.select("1 = 1");
  if (!curSmtp.first()) {
    return false;
  }
  var vB = curSmtp.valueBuffer;

  if (_i.correo_) {
    _i.correo_ = undefined;
  }
  _i.correo_ = [];
  for (var i = 0; i < arrayTo.length; i++) {
    _i.correo_[i] = new AQSmtpClient;
    /// Sólo para depuración
    /// connect(_i.correo_[i], "statusChanged(QString, int)", _i, "statusChanged()");

    _i.correo_[i].setMailServer(vB("hostcorreosaliente"));

    _i.correo_[i].setPort(vB("puertosmtp"));
    switch (vB("tipocxsmtp")) {
      case "SSL": {
        _i.correo_[i].setConnectionType(AQS.SmtpSslConnection);
        break;
      }
      case "TLS": {
        _i.correo_[i].setConnectionType(AQS.SmtpTlsConnection);
        break;
      }
      default: {
      }
    }

    switch (vB("tipoautsmtp")) {
      case "Plain": {
        _i.correo_[i].setAuthMethod(AQS.SmtpAuthPlain);
        break;
      }
      case "Login": {
        _i.correo_[i].setAuthMethod(AQS.SmtpAuthLogin);
        break;
      }
      default: {
        return false;
      }
    }
    //** Tambien se puede usar el método Login
    //** Algunos servidores sólo soportan Login
    //** GMail soporta los dos Plain y Login
    //** _i.correo_.setAuthMethod(AQS.SmtpAuthLogin);

    _i.correo_[i].setUser(vB("usuariosmtp"));
    _i.correo_[i].setPassword(vB("passwordsmtp"));


    try {
      _i.correo_[i].setMimeType("text/plain");
      _i.correo_[i].setBody(datosMail.body);
      //      correo.addTextPart(datosMail.body, "text/plain");
    } catch (e) {
      _i.correo_[i].setBody(datosMail.body);
    }
    _i.correo_[i].setFrom(datosMail.from);
    _i.correo_[i].setTo(arrayTo[i]);
    _i.correo_[i].setSubject(datosMail.subject);
    if ("attach" in datosMail) {
      ///correo.addAttachment(datosMail.attach);
      for (var a = 0; a < datosMail.attach.length; a++) {
        _i.correo_[i].addAttachment(datosMail.attach[a]);
      }
    }
    _i.correo_[i].startSend();
  }

  return true;
}

function sincroTPV_statusChanged(msg, code)
{
  var _i = this.iface;
  switch (code) {
    case AQS.SmtpSendOk: {
      sys.infoMsgBox("El email se ha enviado correctamente");
      break;
    }
    case AQS.SmtpError:
    case AQS.SmtpMxDnsError:
    case AQS.SmtpSocketError:
    case AQS.SmtpAttachError:
    case AQS.SmtpServerError:
    case AQS.SmtpClientError: {
      sys.errorMsgBox(sys.translate("Error al enviar el email"));
      break;
    }
  }
  debug("STATUS CHANGED " + msg + " :  " + code);
}

function sincroTPV_beforeCommit_tpv_agentes(curA)
{
  var _i = this.iface;

  if (!_i.gestionSincroAgenteUp(curA)) {
    return false;
  }
  if (!_i.__beforeCommit_tpv_agentes(curA)) {
    return false;
  }
  return true;
}

function sincroTPV_gestionSincroAgenteUp(curA)
{
  var _i = this.iface;
  if (!_i.esBDLocal()) {
    return true;
  }

  switch (curA.modeAccess()) {
    case curA.Del: {
      if (curA.valueBuffer("sincronizado")) {
        sys.warnMsgBox(sys.translate("El agente ha sido sincronizado con la central. Debe ser eliminado desde la central."));
        return false;
      }
      break;
    }
    case curA.Edit: {
      curA.setValueBuffer("sincronizado", false);
      break;
    }
  }
  return true;
}

//// SINCRO TPV /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
