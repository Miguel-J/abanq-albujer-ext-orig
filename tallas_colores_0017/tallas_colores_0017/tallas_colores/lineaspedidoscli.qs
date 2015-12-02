
/** @class_declaration tallasColores */
/////////////////////////////////////////////////////////////////
//// TALLASCOLORES //////////////////////////////////////////////////
class tallasColores extends oficial
{
  function tallasColores(context)
  {
    oficial(context);
  }
  function init()
  {
    this.ctx.tallasColores_init();
  }
  function definirColor()
  {
    this.ctx.tallasColores_definirColor();
  }
}
//// TALLASCOLORES //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition tallasColores */
/////////////////////////////////////////////////////////////////
//// TALLASCOLORES //////////////////////////////////////////////////

function tallasColores_init()
{
  this.iface.__init();

  //  connect(this.child("pbnDefinirColor"), "clicked()", this, "iface.definirColor");
  //  connect(this.child("pbnDefinirTalla"), "clicked()", this, "iface.definirTalla");
}

function tallasColores_definirColor()
{
  var cursor: FLSqlCursor = this.cursor();

  var formColores: Object = new FLFormSearchDB("articuloscolores");
  var curColores: FLSqlCursor = formColores.cursor();
  curColores.setMainFilter("referencia = '" + cursor.valueBuffer("referencia") + "'");

  formColores.setMainWidget();
  var color: String = formColores.exec("color");

  if (!color) return false;

  cursor.setValueBuffer("color", color);
}

//// TALLASCOLORES //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

