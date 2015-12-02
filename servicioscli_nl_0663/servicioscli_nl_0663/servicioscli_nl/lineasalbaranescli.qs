
/** @class_declaration servclinl */
/////////////////////////////////////////////////////////////////
//// NUM LÍNEA POR SERV CLI ////////////////////////////
class servclinl extends oficial
{
  function servclinl(context)
  {
    oficial(context);
  }
  function init()
  {
    return this.ctx.servclinl_init();
  }
}
//// NUM LÍNEA POR SERV CLI ////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition servclinl */
/////////////////////////////////////////////////////////////////
//// NUM LÍNEA POR SERV CLI ////////////////////////////
function servclinl_init()
{
  this.iface.__init();

  var cursor: FLSqlCursor = this.cursor();
  switch (cursor.modeAccess()) {
    case cursor.Insert: {
      this.child("fdbNumLinea").setValue(this.iface.calculateField("numlinea"));
      break;
    }
  }
}
//// NUM LÍNEA POR SERV CLI ////////////////////////////
/////////////////////////////////////////////////////////////////
