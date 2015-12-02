
/** @class_declaration numerosLinea */
/////////////////////////////////////////////////////////////////
//// NUMEROS LINEA /////////////////////////////////////////////
class numerosLinea extends oficial
{
  function numerosLinea(context)
  {
    oficial(context);
  }
  function init()
  {
    return this.ctx.numerosLinea_init();
  }
  function tbnSubir()
  {
    return this.ctx.numerosLinea_tbnSubir();
  }
  function tbnBajar()
  {
    return this.ctx.numerosLinea_tbnBajar();
  }
}
//// NUMEROS LINEA /////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition numerosLinea */
/////////////////////////////////////////////////////////////////
//// NUMEROS LINEA /////////////////////////////////////////////
function numerosLinea_init()
{
  debug("Init");
  connect(this.child("tbnSubir"), "clicked()", this, "iface.tbnSubir");
  connect(this.child("tbnBajar"), "clicked()", this, "iface.tbnBajar");

  this.child("tdbLineasAlbaranesCli").putFirstCol("numlinea");

  this.iface.__init();
}

/** \D Mueve la línea seleccionada hacia arriba (antes) en el orden
\end */
function numerosLinea_tbnSubir()
{
  var cursor = this.child("tdbLineasAlbaranesCli").cursor();
  var row = this.child("tdbLineasAlbaranesCli").currentRow();

  if (!flfacturac.iface.intercambiarOrden(cursor, -1, "idalbaran")) {
    return false;
  }
  this.child("tdbLineasAlbaranesCli").refresh();
  row += -1;
  this.child("tdbLineasAlbaranesCli").setCurrentRow(row);
}

/** \D Mueve la línea seleccionada hacia abajo (después) en el orden
\end */
function numerosLinea_tbnBajar()
{
  var cursor = this.child("tdbLineasAlbaranesCli").cursor();
  var row = this.child("tdbLineasAlbaranesCli").currentRow();

  if (!flfacturac.iface.intercambiarOrden(cursor, 1, "idalbaran")) {
    return false;
  }
  this.child("tdbLineasAlbaranesCli").refresh();
  row += 1;
  this.child("tdbLineasAlbaranesCli").setCurrentRow(row);
}
//// NUMEROS LINEA /////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
