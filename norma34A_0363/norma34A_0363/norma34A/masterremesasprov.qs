
/** @class_declaration norma34A */
/////////////////////////////////////////////////////////////////
//// NORMA 34A ///////////////////////////////////////////////////
class norma34A extends oficial
{
  function norma34A(context)
  {
    oficial(context);
  }
  function init()
  {
    this.ctx.norma34A_init();
  }
  function volcarADisco34A()
  {
    return this.ctx.norma34A_volcarADisco34A();
  }
}
//// NORMA 34A ///////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition norma34A */
/////////////////////////////////////////////////////////////////
//// NORMA 34A ///////////////////////////////////////////////////
function norma34A_init()
{
  this.iface.__init();
  connect(this.child("tbnNorma34A"), "clicked()", this, "iface.volcarADisco34A");
}
/** \D Abre el formulario para guardar en disco
\end */
function norma34A_volcarADisco34A()
{
  var cursor: FLSqlCursor = this.cursor();
  cursor.setAction("vdisco34A");
  cursor.editRecord();
  cursor.setAction("remesasprov");
}
//// NORMA 34A ///////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
