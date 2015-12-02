
/** @class_declaration exportDatosFC */
/////////////////////////////////////////////////////////////////
//// EXPORT DATOS FC //////////////////////////////////////////////
class exportDatosFC extends oficial
{
  function exportDatosFC(context)
  {
    oficial(context);
  }

  function beforeCommit_pagosdevolcli(cursor: FLSqlCursor): Boolean {
    return this.ctx.exportDatosFC_beforeCommit_pagosdevolcli(cursor);
  }
  function afterCommit_pagosdevolcli(cursor: FLSqlCursor): Boolean {
    return this.ctx.exportDatosFC_afterCommit_pagosdevolcli(cursor);
  }

  function beforeCommit_pagosdevolprov(cursor: FLSqlCursor): Boolean {
    return this.ctx.exportDatosFC_beforeCommit_pagosdevolprov(cursor);
  }
  function afterCommit_pagosdevolprov(cursor: FLSqlCursor): Boolean {
    return this.ctx.exportDatosFC_afterCommit_pagosdevolprov(cursor);
  }

  function beforeCommit_remesas(cursor: FLSqlCursor): Boolean {
    return this.ctx.exportDatosFC_beforeCommit_remesas(cursor);
  }
  function afterCommit_remesas(cursor: FLSqlCursor): Boolean {
    return this.ctx.exportDatosFC_afterCommit_remesas(cursor);
  }

}
//// EXPORT DATOS FC //////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition exportDatosFC */
/////////////////////////////////////////////////////////////////
//// EXPORT DATOS FC //////////////////////////////////////////////

function exportDatosFC_beforeCommit_pagosdevolcli(cursor: FLSqlCursor): Boolean {
  flfactppal.iface.pub_setModificado(cursor);
  return this.iface.__beforeCommit_pagosdevolcli(cursor);
}
function exportDatosFC_afterCommit_pagosdevolcli(cursor: FLSqlCursor): Boolean {
  flfactppal.iface.pub_setBorrado(cursor);
  return this.iface.__afterCommit_pagosdevolcli(cursor);
}

function exportDatosFC_beforeCommit_pagosdevolprov(cursor: FLSqlCursor): Boolean {
  flfactppal.iface.pub_setModificado(cursor);
  return this.iface.__beforeCommit_pagosdevolprov(cursor);
}
function exportDatosFC_afterCommit_pagosdevolprov(cursor: FLSqlCursor): Boolean {
  flfactppal.iface.pub_setBorrado(cursor);
  return this.iface.__afterCommit_pagosdevolprov(cursor);
}

function exportDatosFC_beforeCommit_remesas(cursor: FLSqlCursor): Boolean {
  flfactppal.iface.pub_setModificado(cursor);
  return this.iface.__beforeCommit_remesas(cursor);
}
function exportDatosFC_afterCommit_remesas(cursor: FLSqlCursor): Boolean {
  flfactppal.iface.pub_setBorrado(cursor);
  return true;
}

//// EXPORT DATOS FC //////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
