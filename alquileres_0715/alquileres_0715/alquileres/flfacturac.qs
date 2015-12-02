
/** @class_declaration alquiler */
/////////////////////////////////////////////////////////////////
//// ALQUILER ///////////////////////////////////////////////////
class alquiler extends oficial
{
  function alquiler(context)
  {
    oficial(context);
  }
  function beforeCommit_lineaspresupuestoscli(curLP)
  {
    return this.ctx.alquiler_beforeCommit_lineaspresupuestoscli(curLP);
  }
  function afterCommit_lineaspresupuestoscli(curLP)
  {
    return this.ctx.alquiler_afterCommit_lineaspresupuestoscli(curLP);
  }
  function beforeCommit_lineaspedidoscli(curLP)
  {
    return this.ctx.alquiler_beforeCommit_lineaspedidoscli(curLP);
  }
  function afterCommit_lineaspedidoscli(curLP)
  {
    return this.ctx.alquiler_afterCommit_lineaspedidoscli(curLP);
  }
  function beforeCommit_lineasalbaranescli(curLA)
  {
    return this.ctx.alquiler_beforeCommit_lineasalbaranescli(curLA);
  }
  function afterCommit_lineasalbaranescli(curLA)
  {
    return this.ctx.alquiler_afterCommit_lineasalbaranescli(curLA);
  }
  function beforeCommit_lineasfacturascli(curLF)
  {
    return this.ctx.alquiler_beforeCommit_lineasfacturascli(curLF);
  }
  function afterCommit_lineasfacturascli(curLF)
  {
    return this.ctx.alquiler_afterCommit_lineasfacturascli(curLF);
  }
  function creaPeriodoAlquiler(curLinea)
  {
    return this.ctx.alquiler_creaPeriodoAlquiler(curLinea);
  }
  function cambiaPeriodoAlquiler(curLinea)
  {
    return this.ctx.alquiler_cambiaPeriodoAlquiler(curLinea);
  }
  function cambiaPeriodoAlq(curLinea)
  {
    return this.ctx.alquiler_cambiaPeriodoAlq(curLinea);
  }
  function controlPreAlquilerLinea(curLinea)
  {
    return this.ctx.alquiler_controlPreAlquilerLinea(curLinea);
  }
  function controlPosAlquilerLinea(curLinea)
  {
    return this.ctx.alquiler_controlPosAlquilerLinea(curLinea);
  }
  function borraPeriodoAlquiler(idPA)
  {
    return this.ctx.alquiler_borraPeriodoAlquiler(idPA);
  }
}
//// ALQUILER ///////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition alquiler */
/////////////////////////////////////////////////////////////////
//// ALQUILER ///////////////////////////////////////////////////
function alquiler_beforeCommit_lineaspresupuestoscli(curLP)
{
  var _i = this.iface;
  //  if (!_i.__beforeCommit_lineaspresupuestoscli(curLP)) {
  //    return false;
  //  }
  if (!_i.controlPreAlquilerLinea(curLP)) {
    return false;
  }
  return true;
}

function alquiler_afterCommit_lineaspresupuestoscli(curLP)
{
  debug("alquiler_afterCommit_lineaspresupuestoscli");
  var _i = this.iface;
  //if (!_i.__afterCommit_lineaspedidoscli(curLP)) {
  //  return false;
  //}
  if (!_i.controlPosAlquilerLinea(curLP)) {
    return false;
  }
  return true;
}

function alquiler_beforeCommit_lineaspedidoscli(curLP)
{
  var _i = this.iface;
  //  if (!_i.__afterCommit_lineaspedidoscli(curLP)) {
  //    return false;
  //  }
  if (!_i.controlPreAlquilerLinea(curLP)) {
    return false;
  }
  return true;
}

function alquiler_afterCommit_lineaspedidoscli(curLP)
{
  debug("alquiler_afterCommit_lineaspedidoscli");
  var _i = this.iface;
  if (!_i.__afterCommit_lineaspedidoscli(curLP)) {
    return false;
  }
  if (!_i.controlPosAlquilerLinea(curLP)) {
    return false;
  }
  return true;
}

function alquiler_beforeCommit_lineasalbaranescli(curLA)
{
  var _i = this.iface;
  //  if (!_i.__beforeCommit_lineasalbaranescli(curLA)) {
  //    return false;
  //  }
  if (!_i.controlPreAlquilerLinea(curLA)) {
    return false;
  }
  return true;
}

function alquiler_afterCommit_lineasalbaranescli(curLA)
{
  var _i = this.iface;
  if (!_i.__afterCommit_lineasalbaranescli(curLA)) {
    return false;
  }
  if (!_i.controlPosAlquilerLinea(curLA)) {
    return false;
  }
  return true;
}

function alquiler_beforeCommit_lineasfacturascli(curLF)
{
  var _i = this.iface;
  //  if (!_i.__beforeCommit_lineasfacturascli(curLF)) {
  //    return false;
  //  }
  if (!_i.controlPreAlquilerLinea(curLF)) {
    return false;
  }
  return true;
}

function alquiler_afterCommit_lineasfacturascli(curLF)
{
  var _i = this.iface;
  if (!_i.__afterCommit_lineasfacturascli(curLF)) {
    return false;
  }
  if (!_i.controlPosAlquilerLinea(curLF)) {
    return false;
  }
  return true;
}

function alquiler_creaPeriodoAlquiler(curLinea)
{
  var util = new FLUtil;
  var nombreCliente, codCliente, reservado;
  var curRel = curLinea.cursorRelation();
  if (curRel) {
    codCliente = curRel.valueBuffer("codcliente");
    nombreCliente = curRel.valueBuffer("nombrecliente");
  } else {
    switch (curLinea.table()) {
      case "lineaspresupuestoscli": {
        codCliente = util.sqlSelect("presupuestoscli", "codcliente", "idpresupuesto = " + curLinea.valueBuffer("idpresupuesto"));
        nombreCliente = util.sqlSelect("presupuestoscli", "nombrecliente", "idpresupuesto = " + curLinea.valueBuffer("idpresupuesto"));
        reservado = false;
        break;
      }
      case "lineaspedidoscli": {
        codCliente = util.sqlSelect("pedidoscli", "codcliente", "idpedido = " + curLinea.valueBuffer("idpedido"));
        nombreCliente = util.sqlSelect("pedidoscli", "nombrecliente", "idpedido = " + curLinea.valueBuffer("idpedido"));
        reservado = true;
        break;
      }
      case "lineasalbaranescli": {
        codCliente = util.sqlSelect("albaranescli", "codcliente", "idalbaran = " + curLinea.valueBuffer("idalbaran"));
        nombreCliente = util.sqlSelect("albaranescli", "nombrecliente", "idalbaran = " + curLinea.valueBuffer("idalbaran"));
        reservado = true;
        break;
      }
      case "lineasfacturascli": {
        codCliente = util.sqlSelect("facturascli", "codcliente", "idfactura = " + curLinea.valueBuffer("idfactura"));
        nombreCliente = util.sqlSelect("facturascli", "nombrecliente", "idfactura = " + curLinea.valueBuffer("idfactura"));
        reservado = true;
        break;
      }
    }
  }
  var curAlquiler = new FLSqlCursor("alquilerarticulos");
  curAlquiler.setModeAccess(curAlquiler.Insert);
  curAlquiler.refreshBuffer();
  curAlquiler.setValueBuffer("referencia", curLinea.valueBuffer("referencia"));
  curAlquiler.setValueBuffer("fechadesde", curLinea.valueBuffer("fechadesdealq"));
  debug(curLinea.isNull("horadesdealq"));
  curAlquiler.setValueBuffer("horadesde", curLinea.isNull("horadesdealq") ? "00:00:01" : curLinea.valueBuffer("horadesdealq"));
  curAlquiler.setValueBuffer("fechahasta", curLinea.valueBuffer("fechahastaalq"));
  curAlquiler.setValueBuffer("horahasta", curLinea.valueBuffer("horahastaalq"));
  curAlquiler.setValueBuffer("horas", curLinea.valueBuffer("cantidad"));
  curAlquiler.setValueBuffer("codcliente", codCliente);
  curAlquiler.setValueBuffer("nombre", nombreCliente);
  curAlquiler.setValueBuffer("reservado", reservado);
  if (!curAlquiler.commitBuffer()) {
    return false;
  }
  curLinea.setValueBuffer("idperiodoalq", curAlquiler.valueBuffer("idperiodoalq"));
  return true;
}

function alquiler_cambiaPeriodoAlquiler(curLinea)
{
  var curAlquiler = new FLSqlCursor("alquilerarticulos");
  curAlquiler.select("idperiodoalq = " + curLinea.valueBuffer("idperiodoalq"));
  if (!curAlquiler.first()) {
    return false;
  }
  curAlquiler.setModeAccess(curAlquiler.Edit);
  curAlquiler.refreshBuffer();
  curAlquiler.setValueBuffer("referencia", curLinea.valueBuffer("referencia"));
  curAlquiler.setValueBuffer("fechadesde", curLinea.valueBuffer("fechadesdealq"));
  curAlquiler.setValueBuffer("horadesde", curLinea.valueBuffer("horadesdealq"));
  curAlquiler.setValueBuffer("fechahasta", curLinea.valueBuffer("fechahastaalq"));
  curAlquiler.setValueBuffer("horahasta", curLinea.valueBuffer("horahastaalq"));
  curAlquiler.setValueBuffer("horas", curLinea.valueBuffer("cantidad"));
  if (!curAlquiler.commitBuffer()) {
    return false;
  }
  return true;
}

function alquiler_cambiaPeriodoAlq(curLinea)
{
  var cambia = curLinea.valueBuffer("referencia") != curLinea.valueBufferCopy("referencia") || curLinea.valueBuffer("fechadesdealq") != curLinea.valueBufferCopy("fechadesdealq") || curLinea.valueBuffer("horadesdealq") != curLinea.valueBufferCopy("horadesdealq") || curLinea.valueBuffer("fechahastaalq") != curLinea.valueBufferCopy("fechahastaalq") || curLinea.valueBuffer("horahastaalq") != curLinea.valueBufferCopy("horahastaalq") || curLinea.valueBuffer("horasalq") != curLinea.valueBufferCopy("horasalq");
  return cambia;
}

function alquiler_controlPreAlquilerLinea(curLinea)
{
  var util = new FLUtil;
  var _i = this.iface;

  var tabla = curLinea.table();
  switch (curLinea.modeAccess()) {
    case curLinea.Insert: {
      if (curLinea.isNull("idperiodoalq") && !curLinea.isNull("fechadesdealq")) {
        if (!_i.creaPeriodoAlquiler(curLinea)) {
          return false;
        }
      }
      break;
    }
    case curLinea.Edit: {
      debug(1);
      if (_i.cambiaPeriodoAlq(curLinea)) {
        debug(2);
        if (curLinea.isNull("idperiodoalq")) {
          debug(curLinea.valueBuffer("fechadesdealq"));
          if (!curLinea.isNull("fechadesdealq")) {
            debug(4);
            if (!_i.creaPeriodoAlquiler(curLinea)) {
              return false;
            }
          }
        } else {
          debug(55);
          if (!_i.cambiaPeriodoAlquiler(curLinea)) {
            return false;
          }
        }
      }
      break;
    }
  }
  return true;
}

function alquiler_controlPosAlquilerLinea(curLinea)
{
  var util = new FLUtil;
  var _i = this.iface;

  var tabla = curLinea.table();
  switch (curLinea.modeAccess()) {
    case curLinea.Edit: {
      if (curLinea.isNull("idperiodoalq") && curLinea.valueBuffer("idperiodoalq") != curLinea.valueBufferCopy("idperiodoalq")) {
        var idPA = curLinea.valueBufferCopy("idperiodoalq");
        if (!_i.borraPeriodoAlquiler(idPA)) {
          return false;
        }
      }
      break;
    }
    case curLinea.Del: {
      var idPA = curLinea.valueBuffer("idperiodoalq");
      if (!_i.borraPeriodoAlquiler(idPA)) {
        return false;
      }
      break;
    }
  }
  return true;
}

function alquiler_borraPeriodoAlquiler(idPA)
{
  var util = new FLUtil;
  var _i = this.iface;

  if (util.sqlSelect("lineaspedidoscli", "idlinea", "idperiodoalq = " + idPA)) {
    return true;
  }
  if (util.sqlSelect("lineasalbaranescli", "idlinea", "idperiodoalq = " + idPA)) {
    return true;
  }
  if (util.sqlSelect("lineasfacturascli", "idlinea", "idperiodoalq = " + idPA)) {
    return true;
  }
  if (util.sqlSelect("lineaspresupuestoscli", "idlinea", "idperiodoalq = " + idPA)) {
    if (!util.sqlUpdate("alquilerarticulos", "reservado", false, "idperiodoalq = " + idPA)) {
      return false;
    }
    return true;
  }
  if (!util.sqlDelete("alquilerarticulos", "idperiodoalq = " + idPA)) {
    return false;
  }
  return true;
}

//// ALQUILER ///////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
