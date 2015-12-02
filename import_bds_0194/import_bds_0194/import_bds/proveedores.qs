
/** @class_declaration importDatosFC */
/////////////////////////////////////////////////////////////////
//// IMPORT DATOS FC ////////////////////////////////////////////
class importDatosFC extends oficial
{
  function importDatosFC(context)
  {
    oficial(context);
  }
  function init()
  {
    this.ctx.importDatosFC_init();
  }
}
//// IMPORT DATOS FC ////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition importDatosFC */
/////////////////////////////////////////////////////////////////
//// IMPORT DATOS FC ////////////////////////////////////////////
function importDatosFC_init()
{
  var _i = this.iface;

  var cursor = this.cursor();
  switch (cursor.modeAccess()) {
    case cursor.Edit: {
      if (AQUtil.sqlSelect("correspondenciasreg", "id", "tabla = 'proveedores' and claveloc = '" + cursor.valueBuffer("codproveedor") + "'")) {
        cursor.setModeAccess(cursor.Browse);
        cursor.refreshBuffer();
      }
      break;
    }
  }
  _i.__init();
}
//// IMPORT DATOS FC ////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
