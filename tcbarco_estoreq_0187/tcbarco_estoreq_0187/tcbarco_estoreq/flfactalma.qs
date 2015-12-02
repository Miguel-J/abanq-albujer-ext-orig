
/** @class_declaration tcEstoreQ */
/////////////////////////////////////////////////////////////////
//// TC_ESTOREQ /////////////////////////////////////////////////
class tcEstoreQ extends oficial
{
  function tcEstoreQ(context)
  {
    oficial(context);
  }

  function beforeCommit_grupostalla(cursor: FLSqlCursor): Boolean {
    return this.ctx.tcEstoreQ_beforeCommit_grupostalla(cursor);
  }
  function afterCommit_grupostalla(cursor: FLSqlCursor): Boolean {
    return this.ctx.tcEstoreQ_afterCommit_grupostalla(cursor);
  }

  function beforeCommit_colores(cursor: FLSqlCursor): Boolean {
    return this.ctx.tcEstoreQ_beforeCommit_colores(cursor);
  }
  function afterCommit_colores(cursor: FLSqlCursor): Boolean {
    return this.ctx.tcEstoreQ_afterCommit_colores(cursor);
  }

  function beforeCommit_tallas(cursor: FLSqlCursor): Boolean {
    return this.ctx.tcEstoreQ_beforeCommit_tallas(cursor);
  }
  function afterCommit_tallas(cursor: FLSqlCursor): Boolean {
    return this.ctx.tcEstoreQ_afterCommit_tallas(cursor);
  }

  function beforeCommit_atributosarticulos(cursor: FLSqlCursor): Boolean {
    return this.ctx.tcEstoreQ_beforeCommit_atributosarticulos(cursor);
  }
  function afterCommit_atributosarticulos(cursor: FLSqlCursor): Boolean {
    return this.ctx.tcEstoreQ_afterCommit_atributosarticulos(cursor);
  }

  function beforeCommit_setstallas(cursor: FLSqlCursor): Boolean {
    return this.ctx.tcEstoreQ_beforeCommit_setstallas(cursor);
  }
  function afterCommit_setstallas(cursor: FLSqlCursor): Boolean {
    return this.ctx.tcEstoreQ_afterCommit_setstallas(cursor);
  }

  function beforeCommit_tallasset(cursor: FLSqlCursor): Boolean {
    return this.ctx.tcEstoreQ_beforeCommit_tallasset(cursor);
  }
  function afterCommit_tallasset(cursor: FLSqlCursor): Boolean {
    return this.ctx.tcEstoreQ_afterCommit_tallasset(cursor);
  }

  function beforeCommit_setscolores(cursor: FLSqlCursor): Boolean {
    return this.ctx.tcEstoreQ_beforeCommit_setscolores(cursor);
  }
  function afterCommit_setscolores(cursor: FLSqlCursor): Boolean {
    return this.ctx.tcEstoreQ_afterCommit_setscolores(cursor);
  }

  function beforeCommit_coloresset(cursor: FLSqlCursor): Boolean {
    return this.ctx.tcEstoreQ_beforeCommit_coloresset(cursor);
  }
  function afterCommit_coloresset(cursor: FLSqlCursor): Boolean {
    return this.ctx.tcEstoreQ_afterCommit_coloresset(cursor);
  }

}
//// TC_ESTOREQ //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition tcEstoreQ */
/////////////////////////////////////////////////////////////////
//// TC_ESTOREQ /////////////////////////////////////////////////

function tcEstoreQ_beforeCommit_grupostalla(cursor: FLSqlCursor): Boolean {
  this.iface.setModificado(cursor);
}
function tcEstoreQ_afterCommit_grupostalla(cursor: FLSqlCursor): Boolean {
  this.iface.registrarDel(cursor);
}

function tcEstoreQ_beforeCommit_tallas(cursor: FLSqlCursor): Boolean {
  this.iface.setModificado(cursor);
}
function tcEstoreQ_afterCommit_tallas(cursor: FLSqlCursor): Boolean {
  this.iface.registrarDel(cursor);
}

function tcEstoreQ_beforeCommit_colores(cursor: FLSqlCursor): Boolean {
  this.iface.setModificado(cursor);
}
function tcEstoreQ_afterCommit_colores(cursor: FLSqlCursor): Boolean {
  this.iface.registrarDel(cursor);
}

function tcEstoreQ_beforeCommit_atributosarticulos(cursor: FLSqlCursor): Boolean {
  this.iface.setModificado(cursor);
}
function tcEstoreQ_afterCommit_atributosarticulos(cursor: FLSqlCursor): Boolean {
  this.iface.registrarDel(cursor);
}

function tcEstoreQ_beforeCommit_setstallas(cursor: FLSqlCursor): Boolean {
  this.iface.setModificado(cursor);
}
function tcEstoreQ_afterCommit_setstallas(cursor: FLSqlCursor): Boolean {
  this.iface.registrarDel(cursor);
}

function tcEstoreQ_beforeCommit_tallasset(cursor: FLSqlCursor): Boolean {
  this.iface.setModificado(cursor);
}
function tcEstoreQ_afterCommit_tallasset(cursor: FLSqlCursor): Boolean {
  this.iface.registrarDel(cursor);
}

function tcEstoreQ_beforeCommit_setscolores(cursor: FLSqlCursor): Boolean {
  this.iface.setModificado(cursor);
}
function tcEstoreQ_afterCommit_setscolores(cursor: FLSqlCursor): Boolean {
  this.iface.registrarDel(cursor);
}

function tcEstoreQ_beforeCommit_coloresset(cursor: FLSqlCursor): Boolean {
  this.iface.setModificado(cursor);
}
function tcEstoreQ_afterCommit_coloresset(cursor: FLSqlCursor): Boolean {
  this.iface.registrarDel(cursor);
}

//// TC_ESTOREQ /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
