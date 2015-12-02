
/** @class_declaration norma34 */
/////////////////////////////////////////////////////////////////
//// NORMA 34 ///////////////////////////////////////////////////
class norma34 extends oficial
{
  function norma34(context)
  {
    oficial(context);
  }
  function init()
  {
    this.ctx.norma34_init();
  }
  function volcarADisco34()
  {
    return this.ctx.norma34_volcarADisco34();
  }
}
//// NORMA 34 ///////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition norma34 */
/////////////////////////////////////////////////////////////////
//// NORMA 34 ///////////////////////////////////////////////////
function norma34_init()
{
  this.iface.__init();
  connect(this.child("tbnNorma34"), "clicked()", this, "iface.volcarADisco34");
}
/** \D Abre el formulario para guardar en disco
\end */
function norma34_volcarADisco34()
{
  var cursor: FLSqlCursor = this.cursor();
  cursor.setAction("vdisco34");
  cursor.editRecord();
  cursor.setAction("remesasprov");
}
//// NORMA 34 ///////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
