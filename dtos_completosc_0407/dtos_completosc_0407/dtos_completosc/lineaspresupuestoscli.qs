
/** @class_declaration dtosCompletosCli */
/////////////////////////////////////////////////////////////////
//// DESCUENTOS COMPLETOS A CLIENTES ////////////////////////////
class dtosCompletosCli extends oficial
{
  function dtosCompletosCli(context)
  {
    oficial(context);
  }
  function init()
  {
    return this.ctx.dtosCompletosCli_init();
  }
}
//// DESCUENTOS COMPLETOS A CLIENTES ////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition dtosCompletosCli */
/////////////////////////////////////////////////////////////////
//// DESCUENTOS COMPLETOS A CLIENTES ////////////////////////////
function dtosCompletosCli_init()
{
  this.iface.__init();

  var util: FLUtil = new FLUtil();
  var cursor: FLSqlCursor = this.cursor();
  switch (cursor.modeAccess()) {
    case cursor.Insert: {
      this.child("fdbDtoPor").setValue(this.iface.calculateField("dtopor"));
      this.child("fdbDtoLineal").setValue(this.iface.calculateField("dtolineal"));
      break;
    }
  }
}
//// DESCUENTOS COMPLETOS A CLIENTES ////////////////////////////
/////////////////////////////////////////////////////////////////
