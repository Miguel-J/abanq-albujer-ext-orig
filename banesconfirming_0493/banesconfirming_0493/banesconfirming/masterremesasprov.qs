
/** @class_declaration banesto */
/////////////////////////////////////////////////////////////////
//// CUADERNO BANESTO CONFIRMING ///////////////////////////////
class banesto extends oficial
{
  function banesto(context)
  {
    oficial(context);
  }
  function init()
  {
    this.ctx.banesto_init();
  }
  function volcarADiscoBC()
  {
    return this.ctx.banesto_volcarADiscoBC();
  }
  function comprobarFechasRecibos()
  {
    return this.ctx.banesto_comprobarFechasRecibos();
  }
}
//// CUADERNO BANESTO CONFIRMING ////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition banesto */
/////////////////////////////////////////////////////////////////
//// CUADERNO BANESTO CONFIRMING ////////////////////////////////
function banesto_init()
{
  this.iface.__init();
  connect(this.child("tbnBanesto"), "clicked()", this, "iface.volcarADiscoBC");
}
/** \D Abre el formulario para guardar en disco
\end */
function banesto_volcarADiscoBC()
{
  if (!this.iface.comprobarFechasRecibos()) {
    return false;
  }

  var cursor: FLSqlCursor = this.cursor();
  cursor.setAction("vdiscobc");
  cursor.editRecord();
  cursor.setAction("remesasprov");
}

function banesto_comprobarFechasRecibos(): Boolean {
  var util: FLUtil = new FLUtil();
  var cursor: FLSqlCursor = this.cursor();
  var curRecibos: FLSqlCursor = new FLSqlCursor("recibosprov");
  curRecibos.select("idrecibo IN (SELECT idrecibo FROM pagosdevolprov WHERE idremesa = " + cursor.valueBuffer("idremesa") + ")");
  while (curRecibos.next())
  {
    if (util.daysTo(curRecibos.valueBuffer("fecha"), curRecibos.valueBuffer("fechav")) < 5) {
      var res: Number = MessageBox.information(util.translate("scripts", "La fecha de vencimiento del recibo %1 debe superar en cinco dias a la fecha de emisión.\n¿Desea continuar?").arg(curRecibos.valueBuffer("codigo")), MessageBox.Yes, MessageBox.No);
      if (res != MessageBox.Yes) {
        return false;
      }
    }
  }
  return true;
}


//// CUADERNO BANESTO CONFIRMING ////////////////////////////////
/////////////////////////////////////////////////////////////////
