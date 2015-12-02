
/** @class_declaration exportDatosFC */
/////////////////////////////////////////////////////////////////
//// EXPORT DATOS FC //////////////////////////////////////////////
class exportDatosFC extends oficial
{
  function exportDatosFC(context)
  {
    oficial(context);
  }

  function setModificado(cursor: FLSqlCursor)
  {
    return this.ctx.exportDatosFC_setModificado(cursor);
  }
  function setBorrado(cursor: FLSqlCursor)
  {
    return this.ctx.exportDatosFC_setBorrado(cursor);
  }

  function beforeCommit_clientes(cursor: FLSqlCursor): Boolean {
    return this.ctx.exportDatosFC_beforeCommit_clientes(cursor);
  }
  function afterCommit_clientes(cursor: FLSqlCursor): Boolean {
    return this.ctx.exportDatosFC_afterCommit_clientes(cursor);
  }

  function beforeCommit_proveedores(cursor: FLSqlCursor): Boolean {
    return this.ctx.exportDatosFC_beforeCommit_proveedores(cursor);
  }
  function afterCommit_proveedores(cursor: FLSqlCursor): Boolean {
    return this.ctx.exportDatosFC_afterCommit_proveedores(cursor);
  }

  function beforeCommit_dirclientes(cursor: FLSqlCursor): Boolean {
    return this.ctx.exportDatosFC_beforeCommit_dirclientes(cursor);
  }
  function afterCommit_dirclientes(cursor: FLSqlCursor): Boolean {
    return this.ctx.exportDatosFC_afterCommit_dirclientes(cursor);
  }

  function beforeCommit_dirproveedores(cursor: FLSqlCursor): Boolean {
    return this.ctx.exportDatosFC_beforeCommit_dirproveedores(cursor);
  }
  function afterCommit_dirproveedores(cursor: FLSqlCursor): Boolean {
    return this.ctx.exportDatosFC_afterCommit_dirproveedores(cursor);
  }

  function beforeCommit_cuentasbcocli(cursor: FLSqlCursor): Boolean {
    return this.ctx.exportDatosFC_beforeCommit_cuentasbcocli(cursor);
  }
  function afterCommit_cuentasbcocli(cursor: FLSqlCursor): Boolean {
    return this.ctx.exportDatosFC_afterCommit_cuentasbcocli(cursor);
  }
  function beforeCommit_cuentasbcopro(cursor: FLSqlCursor): Boolean {
    return this.ctx.exportDatosFC_beforeCommit_cuentasbcopro(cursor);
  }
  function afterCommit_cuentasbcopro(cursor: FLSqlCursor): Boolean {
    return this.ctx.exportDatosFC_afterCommit_cuentasbcopro(cursor);
  }
}
//// EXPORT DATOS FC //////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pubImportDatosFC */
/////////////////////////////////////////////////////////////////
//// PUB EXPORT DATOS FC ////////////////////////////////////////

class pubImportDatosFC extends ifaceCtx
{
  function pubImportDatosFC(context)
  {
    ifaceCtx(context);
  }
  function pub_setModificado(cursor: FLSqlCursor)
  {
    return this.setModificado(cursor);
  }
  function pub_setBorrado(cursor: FLSqlCursor)
  {
    return this.setBorrado(cursor);
  }
}
//// PUB EXPORT DATOS FC ////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition exportDatosFC */
/////////////////////////////////////////////////////////////////
//// EXPORT DATOS FC //////////////////////////////////////////////

function exportDatosFC_beforeCommit_clientes(cursor: FLSqlCursor): Boolean {
  this.iface.setModificado(cursor);
  return this.iface.__beforeCommit_clientes(cursor);
}
function exportDatosFC_afterCommit_clientes(cursor: FLSqlCursor): Boolean {
  this.iface.setBorrado(cursor);
  return this.iface.__afterCommit_clientes(cursor);
}

function exportDatosFC_beforeCommit_dirclientes(cursor: FLSqlCursor): Boolean {
  this.iface.setModificado(cursor);
  return true;
}
function exportDatosFC_afterCommit_dirclientes(cursor: FLSqlCursor): Boolean {
  this.iface.setBorrado(cursor);
  return true;
}

function exportDatosFC_beforeCommit_cuentasbcocli(cursor: FLSqlCursor): Boolean {
  this.iface.setModificado(cursor);
  return true;
}
function exportDatosFC_afterCommit_cuentasbcocli(cursor: FLSqlCursor): Boolean {
  this.iface.setBorrado(cursor);
  return true;
}


function exportDatosFC_beforeCommit_proveedores(cursor: FLSqlCursor): Boolean {
  this.iface.setModificado(cursor);
  return this.iface.__beforeCommit_proveedores(cursor);
}
function exportDatosFC_afterCommit_proveedores(cursor: FLSqlCursor): Boolean {
  this.iface.setBorrado(cursor);
  return this.iface.__afterCommit_proveedores(cursor);
}

function exportDatosFC_beforeCommit_dirproveedores(cursor: FLSqlCursor): Boolean {
  this.iface.setModificado(cursor);
  return true;
}
function exportDatosFC_afterCommit_dirproveedores(cursor: FLSqlCursor): Boolean {
  this.iface.setBorrado(cursor);
  return true;
}

function exportDatosFC_beforeCommit_cuentasbcopro(cursor: FLSqlCursor): Boolean {
  this.iface.setModificado(cursor);
  return true;
}
function exportDatosFC_afterCommit_cuentasbcopro(cursor: FLSqlCursor): Boolean {
  this.iface.setBorrado(cursor);
  return true;
}

function exportDatosFC_setModificado(cursor: FLSqlCursor)
{
  if (!cursor.isModifiedBuffer() && cursor.modeAccess() != cursor.Insert)
    return;

  var curMod: FLSqlCursor = new FLSqlCursor("registrosmodificados");
  curMod.select("tabla = '" + cursor.table() + "' AND clave = '" + cursor.valueBuffer(cursor.primaryKey()) + "'")

  if (!curMod.first()) {
    curMod.setModeAccess(curMod.Insert);
    curMod.refreshBuffer();
    curMod.setValueBuffer("tabla", cursor.table());
    curMod.setValueBuffer("clave", cursor.valueBuffer(cursor.primaryKey()));
    curMod.setValueBuffer("modificado", true);
    curMod.setValueBuffer("borrado", false);
    curMod.commitBuffer();
  }
}

/** \D Marca el registro como borrado. Se utiliza para actualizar los datos en
la base de datos remota
*/
function exportDatosFC_setBorrado(cursor: FLSqlCursor)
{
  if (cursor.modeAccess() != cursor.Del)
    return;

  var curMod: FLSqlCursor = new FLSqlCursor("registrosmodificados");
  curMod.select("tabla = '" + cursor.table() + "' AND clave = '" + cursor.valueBuffer(cursor.primaryKey()) + "'")

  if (curMod.first()) {
    curMod.setModeAccess(curMod.Edit);
    curMod.refreshBuffer();
    curMod.setValueBuffer("borrado", true);
    curMod.commitBuffer();
  }

  else {
    curMod.setModeAccess(curMod.Insert);
    curMod.refreshBuffer();
    curMod.setValueBuffer("tabla", cursor.table());
    curMod.setValueBuffer("clave", cursor.valueBuffer(cursor.primaryKey()));
    curMod.setValueBuffer("modificado", true);
    curMod.setValueBuffer("borrado", true);
    curMod.commitBuffer();
  }
}

//// EXPORT DATOS FC //////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
