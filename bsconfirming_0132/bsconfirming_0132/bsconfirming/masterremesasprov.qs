
/** @class_declaration bsc */
/////////////////////////////////////////////////////////////////
//// CUADERNO BS CONFIRMING /////////////////////////////////////
class bsc extends oficial
{
  function bsc(context)
  {
    oficial(context);
  }
  function init()
  {
    this.ctx.bsc_init();
  }
  function volcarADiscoBSC()
  {
    return this.ctx.bsc_volcarADiscoBSC();
  }
}
//// CUADERNO BS CONFIRMING /////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition bsc */
/////////////////////////////////////////////////////////////////
//// BS /////////////////////////////////////////////////////////
function bsc_init()
{
  this.iface.__init();
  connect(this.child("tbnBS"), "clicked()", this, "iface.volcarADiscoBSC");
}
/** \D Abre el formulario para guardar en disco
\end */
function bsc_volcarADiscoBSC()
{
  var cursor: FLSqlCursor = this.cursor();
  cursor.setAction("vdiscobsc");
  cursor.editRecord();
  cursor.setAction("remesasprov");
}
//// BS /////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
