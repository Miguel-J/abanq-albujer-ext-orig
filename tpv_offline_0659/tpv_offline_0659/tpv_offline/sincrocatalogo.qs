
/** @class_declaration offline */
/////////////////////////////////////////////////////////////////
//// TPV OFFLINE ////////////////////////////////////////////////
class offline extends oficial
{
  function offline(context)
  {
    oficial(context);
  }
  function sincronizar(silent)
  {
    return this.ctx.offline_sincronizar(silent);
  }
  function datosRegistro(curO, curD, campo)
  {
    return this.ctx.offline_datosRegistro(curO, curD, campo);
  }
  function dameWhereTabla(tabla)
  {
    return this.ctx.offline_dameWhereTabla(tabla);
  }
}
//// TPV OFFLINE ////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition offline */
/////////////////////////////////////////////////////////////////
//// TPV OFFLINE ////////////////////////////////////////////////
function offline_sincronizar(silent)
{
  if (!this.iface.__sincronizar(silent)) {
    return false;
  }

  var aDatos: Array = [];
  if (!this.iface.sincronizarTabla("formaspago", aDatos, silent)) {
    return false;
  }
  this.iface.aDatos_.push(aDatos);

  aDatos = [];
  if (!this.iface.sincronizarTabla("almacenes", aDatos, silent)) {
    return false;
  }
  this.iface.aDatos_.push(aDatos);

  aDatos = [];
  if (!this.iface.sincronizarTabla("tpv_tiendas", aDatos, silent)) {
    return false;
  }
  this.iface.aDatos_.push(aDatos);

  aDatos = [];
  if (!this.iface.sincronizarTabla("tpv_agentes", aDatos, silent)) {
    return false;
  }
  this.iface.aDatos_.push(aDatos);

  aDatos = [];
  if (!this.iface.sincronizarTabla("departamentos", aDatos, silent)) {
    return false;
  }
  this.iface.aDatos_.push(aDatos);

  aDatos = [];
  if (!this.iface.sincronizarTabla("tpv_puntosventa", aDatos, silent)) {
    return false;
  }
  this.iface.aDatos_.push(aDatos);

  return true;
}

function offline_dameWhereTabla(tabla)
{
  var _i = this.iface;
  var w;
  switch (tabla) {
    default: {
      w = _i.__dameWhereTabla(tabla);
      break;
    }
  }
  return w;
}

function offline_datosRegistro(curO, curD, campo)
{
  var _i = this.iface;
  if (!campo || campo == "") {
    return false;
  }
  var tabla: String = curO.table();
  switch (tabla) {
    case "formaspago": {
      switch (campo) {
        case "codcuenta": {
          return true;
        }
        default : {
          if (!_i.sincronizarCampo(curO, curD, campo)) {
            return false;
          }
          break;
        }
      }
      break;
    }
    case "tpv_tiendas": {
      switch (campo) {
        case "codcliente":
        case "contrasena": {
          return true;
        }
        default : {
          if (!_i.sincronizarCampo(curO, curD, campo)) {
            return false;
          }
          break;
        }
      }
      break;
    }
    default: {
      if (!_i.__datosRegistro(curO, curD, campo)) {
        return false;
      }
    }
  }
  return true;
}
//// TPV OFFLINE ////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
