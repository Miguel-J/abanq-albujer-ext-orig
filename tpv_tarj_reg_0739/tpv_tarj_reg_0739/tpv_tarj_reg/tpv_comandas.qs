
/** @class_declaration tarjetaRegalo */
///////////////////////////////////////////////////////////////////
//// TARJETA REGALO ///////////////////////////////////////////////
class tarjetaRegalo extends oficial
{

  function tarjetaRegalo(context)
  {
    oficial(context);
  }
  function init()
  {
    return this.ctx.tarjetaRegalo_init();
  }
  function tbnTarjetaRegaloClicked()
  {
    return this.ctx.tarjetaRegalo_tbnTarjetaRegaloClicked();
  }
  function dameTarjetaRegalo()
  {
    return this.ctx.tarjetaRegalo_dameTarjetaRegalo();
  }
  function insertarLineaRegalo(refTarjReg)
  {
    return this.ctx.tarjetaRegalo_insertarLineaRegalo(refTarjReg);
  }
}
//// TARJETA REGALO //////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_definition tarjetaRegalo */
///////////////////////////////////////////////////////////////////
//// TARJETA REGALO ///////////////////////////////////////////////
function tarjetaRegalo_init()
{
  var _i = this.iface;

  _i.__init();

  if (this.child("tbnTarjetaRegalo")) {
    connect(this.child("tbnTarjetaRegalo"), "clicked()", _i, "tbnTarjetaRegaloClicked()");
  }
}

function tarjetaRegalo_tbnTarjetaRegaloClicked()
{
  var _i = this.iface;
  var cursor = this.cursor();

  var refTarjReg = _i.dameTarjetaRegalo();
  if (!refTarjReg) {
    return false;
  }

  if (!_i.insertarLineaRegalo(refTarjReg)) {
    return false;
  }

  return true;
}

function tarjetaRegalo_dameTarjetaRegalo()
{
  var _i = this.iface;
  var cursor = this.cursor();
  var articulos = new FLFormSearchDB("articulos");

  articulos.setMainWidget();
  articulos.cursor().setMainFilter("tarjetaregalo");
  var refTarjReg = articulos.exec("referencia");
  if (!articulos.accepted()) {
    return false;
  }

  return refTarjReg;
}

function tarjetaRegalo_insertarLineaRegalo(refTarjReg)
{
  var _i = this.iface;
  var cursor = this.cursor();

  cursor.setValueBuffer("referencia", refTarjReg);
  _i.txtCanArticulo.text = -1;
  _i.insertarLineaClicked();

  return true;
}

//// TARJETA REGALO ///////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
