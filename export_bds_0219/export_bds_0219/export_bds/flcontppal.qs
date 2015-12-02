
/** @class_declaration exportDatosFC */
/////////////////////////////////////////////////////////////////
//// EXPORT DATOS FC //////////////////////////////////////////////
class exportDatosFC extends oficial
{
  function exportDatosFC(context)
  {
    oficial(context);
  }

  //  function beforeCommit_co_subcuentascli(cursor:FLSqlCursor):Boolean {
  //    return this.ctx.exportDatosFC_beforeCommit_co_subcuentascli(cursor);
  //  }
  //  function afterCommit_co_subcuentascli(cursor:FLSqlCursor):Boolean {
  //    return this.ctx.exportDatosFC_afterCommit_co_subcuentascli(cursor);
  //  }

  function beforeCommit_co_subcuentas(cursor: FLSqlCursor): Boolean {
    return this.ctx.exportDatosFC_beforeCommit_co_subcuentas(cursor);
  }
  function afterCommit_co_subcuentas(cursor: FLSqlCursor): Boolean {
    return this.ctx.exportDatosFC_afterCommit_co_subcuentas(cursor);
  }
}
//// EXPORT DATOS FC //////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition exportDatosFC */
/////////////////////////////////////////////////////////////////
//// EXPORT DATOS FC //////////////////////////////////////////////

// function exportDatosFC_beforeCommit_co_subcuentascli(cursor:FLSqlCursor):Boolean {
//  flfactppal.iface.pub_setModificado(cursor);
//  return true;
// }
// function exportDatosFC_afterCommit_co_subcuentascli(cursor:FLSqlCursor):Boolean {
//  flfactppal.iface.pub_setBorrado(cursor);
//  return true;
// }

function exportDatosFC_beforeCommit_co_subcuentas(cursor: FLSqlCursor): Boolean {
  flfactppal.iface.pub_setModificado(cursor);
  return true;
}
function exportDatosFC_afterCommit_co_subcuentas(cursor: FLSqlCursor): Boolean {
  flfactppal.iface.pub_setBorrado(cursor);
  return true;
}

//// EXPORT DATOS FC //////////////////////////////////////////////
/////////////////////////////////////////////////////////////////