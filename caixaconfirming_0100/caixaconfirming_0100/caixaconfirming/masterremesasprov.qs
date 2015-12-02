
/** @class_declaration caixa */
/////////////////////////////////////////////////////////////////
//// CUADERNO CAIXA CONFIRMING //////////////////////////////////
class caixa extends oficial
{
  function caixa(context)
  {
    oficial(context);
  }
  function init()
  {
    this.ctx.caixa_init();
  }
  function volcarADiscoCC()
  {
    return this.ctx.caixa_volcarADiscoCC();
  }
}
//// CUADERNO CAIXA CONFIRMING //////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition caixa */
/////////////////////////////////////////////////////////////////
//// CUADERNO CAIXA CONFIRMING //////////////////////////////////
function caixa_init()
{
  this.iface.__init();
  connect(this.child("tbnCaixa"), "clicked()", this, "iface.volcarADiscoCC");
}
/** \D Abre el formulario para guardar en disco
\end */
function caixa_volcarADiscoCC()
{
  var cursor: FLSqlCursor = this.cursor();
  cursor.setAction("vdiscocc");
  cursor.editRecord();
  cursor.setAction("remesasprov");
}
//// CUADERNO CAIXA CONFIRMING //////////////////////////////////
/////////////////////////////////////////////////////////////////
