
/** @class_declaration proveed */
//////////////////////////////////////////////////////////////////
//// PROVEED /////////////////////////////////////////////////////
class proveed extends oficial
{
  function proveed(context)
  {
    oficial(context);
  }

  function cargaEvolCuenta(codCuentaBancaria, fechaD, fechaH)
  {
    return this.ctx.proveed_cargaEvolCuenta(codCuentaBancaria, fechaD, fechaH);
  }
  function cargaEvolRecibosProv(codCuentaBancaria, fechaD, fechaH)
  {
    return this.ctx.proveed_cargaEvolRecibosProv(codCuentaBancaria, fechaD, fechaH);
  }
  function dameSelect(tabla, codCuentaBancaria, fechaD, fechaH)
  {
    return this.ctx.proveed_dameSelect(tabla, codCuentaBancaria, fechaD, fechaH);
  }
  function dameFrom(tabla, codCuentaBancaria, fechaD, fechaH)
  {
    return this.ctx.proveed_dameFrom(tabla, codCuentaBancaria, fechaD, fechaH);
  }
  function dameWhere(tabla, codCuentaBancaria, fechaD, fechaH)
  {
    return this.ctx.proveed_dameWhere(tabla, codCuentaBancaria, fechaD, fechaH);
  }
}
//// PROVEED /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_definition proveed */
/////////////////////////////////////////////////////////////////
//// PROVEED ////////////////////////////////////////////////////

function proveed_cargaEvolCuenta(codCuentaBancaria, fechaD, fechaH)
{
  var _i = this.iface;
  var cursor = this.cursor();

  if (!_i.cargaEvolRecibosProv(codCuentaBancaria, fechaD, fechaH)) {
    return false;
  }

  if (!_i.__cargaEvolCuenta(codCuentaBancaria, fechaD, fechaH)) {
    return false;
  }

  return true;
}

function proveed_cargaEvolRecibosProv(codCuentaBancaria, fechaD, fechaH)
{
  var _i = this.iface;
  var cursor = this.cursor();

  var select = _i.dameSelect("recibosprov", codCuentaBancaria, fechaD, fechaH);
  var from = _i.dameFrom("recibosprov", codCuentaBancaria, fechaD, fechaH);
  var where = _i.dameWhere("recibosprov", codCuentaBancaria, fechaD, fechaH);

  var q = new FLSqlQuery;
  q.setSelect(select);
  q.setFrom(from);
  q.setWhere(where);

  q.setForwardOnly(true);
  if (!q.exec()) {
    return;
  }

  var p = 0;

  flfactppal.iface.pub_creaDialogoProgreso(sys.translate("Buscando recibos de clientes..."), q.size());

  var i = _i.aDatos_.length;

  while (q.next()) {
    AQUtil.setProgress(p++);
    _i.aDatos_[i] = _i.dameObjetoRecibo();
    _i.aDatos_[i]["tabla"] = "recibosprov";
    _i.aDatos_[i]["clave"] = q.value("idrecibo");
    _i.aDatos_[i]["fecha"] = q.value("fechav");
    _i.aDatos_[i]["concepto"] = "Recibo " + q.value("codigo") + " del proveedor " + q.value("codproveedor");
    _i.aDatos_[i]["importe"] = q.value("importe");
    _i.aDatos_[i]["esIngreso"] = false;
    i++;
  }
  sys.AQTimer.singleShot(0, AQUtil.destroyProgressDialog);
  return true;
}

function proveed_dameSelect(tabla, codCuentaBancaria, fechaD, fechaH)
{
  var _i = this.iface;
  var cursor = this.cursor();

  var select = "";

  switch (tabla) {
    case "recibosprov": {
      select = "idrecibo,codigo,importe,fecha,fechav,codproveedor";
      break;
    }
    default: {
      select = _i.__dameSelect(tabla, codCuentaBancaria, fechaD, fechaH);
    }
  }
  return select;
}

function proveed_dameFrom(tabla, codCuentaBancaria, fechaD, fechaH)
{
  var _i = this.iface;
  var cursor = this.cursor();

  var from = "";

  switch (tabla) {
    case "recibosprov": {
      from = tabla;
      break;
    }
    default: {
      from = _i.__dameFrom(tabla, codCuentaBancaria, fechaD, fechaH);
    }
  }
  return from;
}

function proveed_dameWhere(tabla, codCuentaBancaria, fechaD, fechaH)
{
  var _i = this.iface;
  var cursor = this.cursor();

  var where = "";

  switch (tabla) {
    case "recibosprov": {
      where = "fechav BETWEEN '" + fechaD + "' AND '" + fechaH + "' AND codcuentapagoprov = '" + codCuentaBancaria + "' AND estado IN ('Emitido', 'Devuelto', 'Remesado')";
      break;
    }
    default: {
      where = _i.__dameWhere(tabla, codCuentaBancaria, fechaD, fechaH);
    }
  }
  return where;
}
//// PROVEED ////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
