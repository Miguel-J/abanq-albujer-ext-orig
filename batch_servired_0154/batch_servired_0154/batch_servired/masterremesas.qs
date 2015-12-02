
/** @class_declaration batchServired */
//////////////////////////////////////////////////////////////////
//// BATCH_SERVIRED //////////////////////////////////////////////
class batchServired extends oficial
{
  function batchServired(context)
  {
    oficial(context);
  }

  function init()
  {
    this.ctx.batchServired_init();
  }
  function volcarADiscoSR()
  {
    return this.ctx.batchServired_volcarADiscoSR();
  }
}
//// BATCH_SERVIRED ///////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_definition batchServired */
//////////////////////////////////////////////////////////////////
//// BATCH_SERVIRED /////////////////////////////////////////////

function batchServired_init()
{
  this.iface.__init();

  connect(this.child("pbnADiscoSR"), "clicked()", this, "iface.volcarADiscoSR");
}

function batchServired_volcarADiscoSR()
{
  var cursor: FLSqlCursor = this.cursor();
  cursor.setAction("vdiscosr");
  cursor.editRecord();
  cursor.setAction("remesas");
}

//// BATCH_SERVIRED //////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
