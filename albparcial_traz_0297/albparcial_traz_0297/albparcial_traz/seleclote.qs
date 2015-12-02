
/** @class_declaration parcialLotes */
/////////////////////////////////////////////////////////////////
//// PARCIALLOTES ///////////////////////////////////////////////
class parcialLotes extends oficial
{
  function parcialLotes(context)
  {
    oficial(context);
  }
  function init()
  {
    return this.ctx.parcialLotes_init();
  }
}
//// PARCIALLOTES ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition parcialLotes */
/////////////////////////////////////////////////////////////////
//// PARCIALLOTES ///////////////////////////////////////////////
function parcialLotes_init()
{
  this.iface.__init();

  if (this.cursor().cursorRelation() && this.cursor().cursorRelation().action() == "pedidosprovparciales")
    this.child("fdbCodLote").setFilter("(caducidad IS NULL OR caducidad > CURRENT_DATE) AND referencia = '" + this.cursor().valueBuffer("referencia") + "'");
  else
    this.child("fdbCodLote").setFilter("(caducidad IS NULL OR caducidad > CURRENT_DATE) AND enalmacen > 0 AND referencia = '" + this.cursor().valueBuffer("referencia") + "'");
}
//// PARCIALLOTES ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
