
/** @class_declaration norma68 */
/////////////////////////////////////////////////////////////////
//// NORMA 68 ///////////////////////////////////////////////////
class norma68 extends oficial
{
  function norma68(context)
  {
    oficial(context);
  }
  function init()
  {
    this.ctx.norma68_init();
  }
  function volcarADisco68()
  {
    return this.ctx.norma68_volcarADisco68();
  }
}
//// NORMA 68 ///////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition norma68 */
/////////////////////////////////////////////////////////////////
//// NORMA 68 ///////////////////////////////////////////////////
function norma68_init()
{
  this.iface.__init();
  connect(this.child("tbnNorma68"), "clicked()", this, "iface.volcarADisco68");
}
/** \D Abre el formulario para guardar en disco
\end */
function norma68_volcarADisco68()
{
  var cursor: FLSqlCursor = this.cursor();
  cursor.setAction("vdisco68");
  cursor.editRecord();
  cursor.setAction("remesasprov");
}
//// NORMA 68 ///////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
