
/** @class_declaration lotesTpv */
/////////////////////////////////////////////////////////////////
//// LOTES EN TPV ///////////////////////////////////////////////
class lotesTpv extends oficial
{
  var porLotes: Boolean;

  function lotesTpv(context)
  {
    oficial(context);
  }
  function init()
  {
    return this.ctx.lotesTpv_init();
  }
  function bufferChanged(fN: String)
  {
    return this.ctx.lotesTpv_bufferChanged(fN);
  }
  function calcularCantidad()
  {
    return this.ctx.lotesTpv_calcularCantidad();
  }
  function calculateField(fN: String): String {
    return this.ctx.lotesTpv_calculateField(fN);
  }
  function habilitarControlesPorLotes()
  {
    return this.ctx.lotesTpv_habilitarControlesPorLotes();
  }
}
//// LOTES EN TPV ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition lotesTpv */
/////////////////////////////////////////////////////////////////
//// LOTES EN TPV ///////////////////////////////////////////////
/** \C La tabla de movimientos mostrará movimientos asociados a la línea de factura. En el caso de que la factura sea automática (provenga de uno o más albaranes), la tabla de movimientos estará vacía.
\end */
function lotesTpv_init()
{
  this.iface.__init();

  if (this.cursor().cursorRelation().valueBuffer("automatica")) {
    this.child("gbxMoviLote").setDisabled(true);
  } else {
    connect(this.child("tdbMoviLote").cursor(), "bufferCommited()", this, "iface.calcularCantidad()");
    this.iface.habilitarControlesPorLotes();
  }
}


/** \C Si el artículo seleccionado está gestionado por lotes se inhabilitará el campo --cantidad--, que tomará el valor de la suma del campo cantidad de los movimientos asociados a la línea. Si no está gestionado por lotes, se inhabilitará la sección 'Movimientos de lotes'.
\end */
function lotesTpv_bufferChanged(fN: String)
{

  switch (fN) {
    case "referencia": {
      this.iface.habilitarControlesPorLotes();
      this.iface.__bufferChanged(fN);
      break;
    }
    default: {
      this.iface.__bufferChanged(fN);
    }
  }
}

/** \D Calcula la cantidad como suma de los movimientos asociados a la línea.

Si hay uno o más movimientos, la referencia no podrá ser modificada
\end */
function lotesTpv_calcularCantidad()
{
  if (this.child("tdbMoviLote").cursor().size() > 0)
    this.child("fdbReferencia").setDisabled(true);
  else
    this.child("fdbReferencia").setDisabled(false);

  this.cursor().setValueBuffer("cantidad", this.iface.calculateField("cantidad"));
}

/** \D Calcula el valor de un campo

@param  fN: Nombre del campo
@return Valor del campo calculado
\end */
function lotesTpv_calculateField(fN: String): String {
  var res: String;
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();
  switch (fN)
  {
    case "cantidad": {
      if (this.iface.porLotes) {
        res = util.sqlSelect("movilote", "SUM(cantidad)", "idlineavc = " + cursor.valueBuffer("idtpv_linea"));
        res = -1 * parseFloat(res);
      } else
        res = this.iface.__calculateField(fN);
      break;
    }
    default: {
      res = this.iface.__calculateField(fN);
    }
  }
  return res;
}

/** \D Habilita y pone los valores iniciales para los controles del formulario en función de si el artículo seleccionado es por lotes o no
\end */
function lotesTpv_habilitarControlesPorLotes()
{
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  var codAlmacen = util.sqlSelect("tpv_comandas c INNER JOIN tpv_puntosventa pv ON c.codtpv_puntoventa = pv.codtpv_puntoventa", "pv.codalmacen", "idtpv_comanda = " + cursor.valueBuffer("idtpv_comanda"), "tpv_comandas,tpv_puntosventa");
  var almacenTrazable: Boolean = util.sqlSelect("almacenes", "trazabilidad", "codalmacen = '" + codAlmacen + "'");
  var articuloTrazable: Boolean = util.sqlSelect("articulos", "porlotes", "referencia = '" + cursor.valueBuffer("referencia") + "'");
  this.iface.porLotes = almacenTrazable && articuloTrazable;
  if (this.iface.porLotes) {
    this.child("gbxMoviLote").setDisabled(false);
    this.child("fdbCantidad").setDisabled(true);
    this.iface.calcularCantidad();
  } else {
    this.child("gbxMoviLote").setDisabled(true);
    this.child("fdbCantidad").setDisabled(false);
    this.child("fdbReferencia").setDisabled(false);
  }
}
//// LOTES EN TPV ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
