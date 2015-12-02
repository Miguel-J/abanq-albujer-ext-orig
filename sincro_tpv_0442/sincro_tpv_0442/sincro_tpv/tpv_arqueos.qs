
/** @class_declaration sincro */
/////////////////////////////////////////////////////////////////
//// SINCRO TPV /////////////////////////////////////////////////
class sincro extends multi
{
  function sincro(context)
  {
    multi(context);
  }
  function valoresInitTienda()
  {
    return this.ctx.sincro_valoresInitTienda();
  }
  function codigoArqueo(cursor)
  {
    return this.ctx.sincro_codigoArqueo(cursor);
  }
  function prefijoArqueo(cursor)
  {
    return this.ctx.sincro_prefijoArqueo(cursor);
  }
}
//// SINCRO TPV /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition sincro */
/////////////////////////////////////////////////////////////////
//// SINCRO TPV /////////////////////////////////////////////////
function sincro_valoresInitTienda()
{
  var _i = this.iface;
  var cursor = this.cursor();

  _i.__valoresInitTienda();

  if (cursor.modeAccess() == cursor.Insert) {
    var codArqueo = _i.codigoArqueo(cursor);
    if (!codArqueo) {
      return false;
    }
    cursor.setValueBuffer("idtpv_arqueo", codArqueo);
  }
  return true;
}

function sincro_codigoArqueo(cursor)
{
  var _i = this.iface;
  var prefijo = _i.prefijoArqueo(cursor);
  if (!prefijo) {
    return false;
  }
  var ultimoNumero: Number = 0;
  var ultimoArqueo: Number = AQUtil.sqlSelect("tpv_arqueos", "idtpv_arqueo", "idtpv_arqueo LIKE '" + prefijo + "%' ORDER BY idtpv_arqueo DESC");
  if (ultimoArqueo) {
    ultimoNumero = parseFloat(ultimoArqueo.toString().right(8 - prefijo.length));
  }
  ultimoNumero++;
  var codArqueo: String = prefijo + flfacturac.iface.pub_cerosIzquierda(ultimoNumero, 8 - prefijo.length);
  return codArqueo;
}

function sincro_prefijoArqueo(cursor)
{
  var codTienda = cursor.valueBuffer("codtienda");
  if (!codTienda) {
    return false;
  }
  var pre = AQUtil.sqlSelect("tpv_tiendas", "prefijocod", "codtienda = '" + codTienda + "'");
  return pre;
}
//// SINCRO TPV /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
