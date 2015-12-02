
/** @class_declaration dtosCompletosProv */
/////////////////////////////////////////////////////////////////
//// DESCUENTOS COMPLETOS A PROVEEDORES /////////////////////////
class dtosCompletosProv extends oficial
{
  function dtosCompletosProv(context)
  {
    oficial(context);
  }
  function init()
  {
    return this.ctx.dtosCompletosProv_init();
  }
}
//// DESCUENTOS COMPLETOS A PROVEEDORES ////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition dtosCompletosProv */
/////////////////////////////////////////////////////////////////
//// DESCUENTOS COMPLETOS A PROVEEDORES /////////////////////////
function dtosCompletosProv_init()
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
//// DESCUENTOS COMPLETOS A PROVEEDORES /////////////////////////
/////////////////////////////////////////////////////////////////
