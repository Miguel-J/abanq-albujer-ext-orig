
/** @class_declaration sincrotpv */
/////////////////////////////////////////////////////////////////
//// SINCRO TPV /////////////////////////////////////////////////
class sincrotpv extends oficial
{
  function sincrotpv(context)
  {
    oficial(context);
  }
  function idViaje()
  {
    return this.ctx.sincrotpv_idViaje();
  }
  function damePrefijo()
  {
    return this.ctx.sincrotpv_damePrefijo();
  }
  function calculateCounter()
  {
    return this.ctx.sincrotpv_calculateCounter();
  }
}
//// SINCRO TPV /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition sincrotpv */
/////////////////////////////////////////////////////////////////
//// SINCRO TPV /////////////////////////////////////////////////
function sincrotpv_calculateCounter()
{
  var _i = this.iface;
  var prefijo = "";
  debug("prefijo " + prefijo);
  //  if (flfact_tpv.iface.pub_esUnaTienda()) {
  //    var codTerminal = flfact_tpv.iface.pub_valorDefectoTPV("codterminal");
  //    prefijo = AQUtil.sqlSelect("tpv_puntosventa pv INNER JOIN tpv_tiendas t ON pv.codtienda = t.codtienda", "t.prefijocod", "pv.codtpv_puntoventa = '" + codTerminal + "'", "tpv_puntosventa");
  //    if (!prefijo) {
  //      MessageBox.warning(sys.translate("No se ha encontrado el prefijo asociado a la tienda local para crear el código de viaje"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton, "AbanQ");
  //      return "";
  //    }
  //  }
  var ultimoNumero = 0;
  var ultimoViaje = AQUtil.sqlSelect("tpv_secuenciascomanda", "valor", "prefijo = 'MT_" + prefijo + "'");
  debug("ultimoViaje " + ultimoViaje);
  if (!ultimoViaje) {
    ultimoViaje = AQUtil.sqlSelect("tpv_multitransstock", "codmultitransstock", "codmultitransstock LIKE '" + prefijo + "%' ORDER BY codmultitransstock DESC");

    if (ultimoViaje) {
      ultimoNumero = parseFloat(ultimoViaje.toString().right(10 - prefijo.length));
    } else {
      ultimoNumero = 0;
    }

    ultimoNumero++;

    var curSecuencia = new FLSqlCursor("tpv_secuenciascomanda");
    curSecuencia.setModeAccess(curSecuencia.Insert);
    curSecuencia.refreshBuffer();
    curSecuencia.setValueBuffer("prefijo", "MT_" + prefijo);
    curSecuencia.setValueBuffer("valor", ultimoNumero);
    if (!curSecuencia.commitBuffer()) {
      return false;
    }
  } else {
    ultimoNumero = ultimoViaje + 1;
    AQUtil.sqlUpdate("tpv_secuenciascomanda", "valor", ultimoNumero, "prefijo = 'MT_" + prefijo + "'");
  }

  var idMulti = prefijo + flfacturac.iface.pub_cerosIzquierda(ultimoNumero, 8 - prefijo.length);
  debug("idMulti " + idMulti);
  return idMulti;
}

function sincrotpv_idViaje()
{
  var _i = this.iface;
  var prefijo = _i.damePrefijo();
  if (!prefijo || prefijo == "")
    return "";

  debug("prefijo " + prefijo);
  //  if (flfact_tpv.iface.pub_esUnaTienda()) {
  //    var codTerminal = flfact_tpv.iface.pub_valorDefectoTPV("codterminal");
  //    prefijo = AQUtil.sqlSelect("tpv_puntosventa pv INNER JOIN tpv_tiendas t ON pv.codtienda = t.codtienda", "t.prefijocod", "pv.codtpv_puntoventa = '" + codTerminal + "'", "tpv_puntosventa");
  //    if (!prefijo) {
  //      MessageBox.warning(sys.translate("No se ha encontrado el prefijo asociado a la tienda local para crear el código de viaje"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton, "AbanQ");
  //      return "";
  //    }
  //  }
  var ultimoNumero = 0;
  var ultimoViaje = AQUtil.sqlSelect("tpv_secuenciascomanda", "valor", "prefijo = 'VT_" + prefijo + "'");
  debug("ultimoViaje " + ultimoViaje);
  if (!ultimoViaje) {
    ultimoViaje = AQUtil.sqlSelect("tpv_viajesmultitransstock", "idviajemultitrans", "idviajemultitrans LIKE '" + prefijo + "%' ORDER BY idviajemultitrans DESC");

    if (ultimoViaje) {
      ultimoNumero = parseFloat(ultimoViaje.toString().right(10 - prefijo.length));
    } else {
      ultimoNumero = 0;
    }

    ultimoNumero++;

    var curSecuencia = new FLSqlCursor("tpv_secuenciascomanda");
    curSecuencia.setModeAccess(curSecuencia.Insert);
    curSecuencia.refreshBuffer();
    curSecuencia.setValueBuffer("prefijo", "VT_" + prefijo);
    curSecuencia.setValueBuffer("valor", ultimoNumero);
    if (!curSecuencia.commitBuffer()) {
      return false;
    }
  } else {
    ultimoNumero = ultimoViaje + 1;
    AQUtil.sqlUpdate("tpv_secuenciascomanda", "valor", ultimoNumero, "prefijo = 'VT_" + prefijo + "'");
  }

  var idViaje = prefijo + flfacturac.iface.pub_cerosIzquierda(ultimoNumero, 10 - prefijo.length);
  debug("idviaje " + idViaje);
  return idViaje;
}

function sincrotpv_damePrefijo()
{
  var _i = this.iface;

  var prefijo = "00";
  if (flfact_tpv.iface.pub_esBDLocal()) {
    var codTerminal = flfact_tpv.iface.pub_valorDefectoTPV("codterminal");
    prefijo = AQUtil.sqlSelect("tpv_puntosventa pv INNER JOIN tpv_tiendas t ON pv.codtienda = t.codtienda", "t.prefijocod", "pv.codtpv_puntoventa = '" + codTerminal + "'", "tpv_puntosventa");
    if (!prefijo) {
      MessageBox.warning(sys.translate("No se ha encontrado el prefijo asociado a la tienda local para crear el código de viaje"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton, "AbanQ");
      return "";
    }
  }

  return prefijo;
}
//// SINCRO TPV /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
