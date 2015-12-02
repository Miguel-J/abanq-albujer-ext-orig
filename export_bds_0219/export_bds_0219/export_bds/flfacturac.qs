
/** @class_declaration exportDatosFC */
/////////////////////////////////////////////////////////////////
//// EXPORT DATOS FC //////////////////////////////////////////////
class exportDatosFC extends oficial
{
  function exportDatosFC(context)
  {
    oficial(context);
  }

  function beforeCommit_facturascli(cursor: FLSqlCursor): Boolean {
    return this.ctx.exportDatosFC_beforeCommit_facturascli(cursor);
  }
  function afterCommit_facturascli(cursor: FLSqlCursor): Boolean {
    return this.ctx.exportDatosFC_afterCommit_facturascli(cursor);
  }

  function beforeCommit_albaranescli(cursor: FLSqlCursor): Boolean {
    return this.ctx.exportDatosFC_beforeCommit_albaranescli(cursor);
  }
  function afterCommit_albaranescli(cursor: FLSqlCursor): Boolean {
    return this.ctx.exportDatosFC_afterCommit_albaranescli(cursor);
  }

  function beforeCommit_facturasprov(cursor: FLSqlCursor): Boolean {
    return this.ctx.exportDatosFC_beforeCommit_facturasprov(cursor);
  }
  function afterCommit_facturasprov(cursor: FLSqlCursor): Boolean {
    return this.ctx.exportDatosFC_afterCommit_facturasprov(cursor);
  }

  function beforeCommit_albaranesprov(cursor: FLSqlCursor): Boolean {
    return this.ctx.exportDatosFC_beforeCommit_albaranesprov(cursor);
  }
  function afterCommit_albaranesprov(cursor: FLSqlCursor): Boolean {
    return this.ctx.exportDatosFC_afterCommit_albaranesprov(cursor);
  }

}
//// EXPORT DATOS FC //////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition exportDatosFC */
/////////////////////////////////////////////////////////////////
//// EXPORT DATOS FC //////////////////////////////////////////////

function exportDatosFC_beforeCommit_facturascli(cursor: FLSqlCursor): Boolean {
  flfactppal.iface.pub_setModificado(cursor);
  return this.iface.__beforeCommit_facturascli(cursor);
}
function exportDatosFC_afterCommit_facturascli(cursor: FLSqlCursor): Boolean {
  flfactppal.iface.pub_setBorrado(cursor);
  return this.iface.__afterCommit_facturascli(cursor);
}

function exportDatosFC_beforeCommit_albaranescli(cursor: FLSqlCursor): Boolean {
  flfactppal.iface.pub_setModificado(cursor);
  return this.iface.__beforeCommit_albaranescli(cursor);
}
function exportDatosFC_afterCommit_albaranescli(cursor: FLSqlCursor): Boolean {
  flfactppal.iface.pub_setBorrado(cursor);
  return true;
}

function exportDatosFC_beforeCommit_facturasprov(cursor: FLSqlCursor): Boolean {
  flfactppal.iface.pub_setModificado(cursor);
  return this.iface.__beforeCommit_facturasprov(cursor);
}
function exportDatosFC_afterCommit_facturasprov(cursor: FLSqlCursor): Boolean {
  flfactppal.iface.pub_setBorrado(cursor);
  return this.iface.__afterCommit_facturasprov(cursor);
}

function exportDatosFC_beforeCommit_albaranesprov(cursor: FLSqlCursor): Boolean {
  flfactppal.iface.pub_setModificado(cursor);
  return this.iface.__beforeCommit_albaranesprov(cursor);
}
function exportDatosFC_afterCommit_albaranesprov(cursor: FLSqlCursor): Boolean {
  flfactppal.iface.pub_setBorrado(cursor);
  return true;
}
//// EXPORT DATOS FC //////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
