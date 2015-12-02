
/** @class_declaration lotesTpv */
/////////////////////////////////////////////////////////////////
//// LOTES TPV //////////////////////////////////////////////////
class lotesTpv extends oficial
{
  function lotesTpv(context)
  {
    oficial(context);
  }
  function insertarLineaClicked()
  {
    return this.ctx.lotesTpv_insertarLineaClicked();
  }
  function validateForm(): Boolean {
    return this.ctx.lotesTpv_validateForm();
  }
  function bufferChanged(fN: String)
  {
    return this.ctx.lotesTpv_bufferChanged(fN);
  }
  function insertarMovimientoLote(codLote: String, cantidad: Number)
  {
    return this.ctx.lotesTpv_insertarMovimientoLote(codLote, cantidad);
  }
}
//// LOTES TPV //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition lotesTpv */
/////////////////////////////////////////////////////////////////
//// LOTES TPV //////////////////////////////////////////////////
/** \D Comprueba que el artículo no esté controlado por lotes. Las líneas de estos artículos no pueden ser creadas mediante inserción rápida
\end */
function lotesTpv_insertarLineaClicked()
{
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();
  var referencia: String = cursor.valueBuffer("referencia");
  if (!referencia || referencia == "") {
    return;
  }
  if (util.sqlSelect("articulos", "porlotes", "referencia = '" + referencia + "'")) {
    var codLote: String = util.sqlSelect("lotes", "codlote", "codlote = '" + cursor.valueBuffer("codbarras") + "'");
    if (!codLote) {
      MessageBox.warning(util.translate("scripts", "El artículo seleccionado está controlado por lotes.\nNo puede crear la línea mediante inserción rápida porque debe identificar los lotes de procedencia."), MessageBox.Ok, MessageBox.NoButton);
      return;
    } else {
      var cantidad: Number = this.child("txtCanArticulo").text;
      this.iface.__insertarLineaClicked();
      this.iface.insertarMovimientoLote(codLote, cantidad);
    }
  } else {
    this.iface.__insertarLineaClicked();
  }
}

function lotesTpv_validateForm(): Boolean {
  if (!this.iface.__validateForm())
    return false;

  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();
  var nombreCliente: String = cursor.valueBuffer("nombrecliente");
  if (!nombreCliente || nombreCliente == "")
  {
    if (util.sqlSelect("tpv_lineascomanda lc INNER JOIN articulos a ON lc.referencia = a.referencia", "a.referencia", "lc.idtpv_comanda = " + cursor.valueBuffer("idtpv_comanda") + " AND a.porlotes = true", "tpv_lineascomanda,articulos")) {
      MessageBox.warning(util.translate("scripts", "Al menos uno de los artículos incluidos en la venta está controlado por lotes.\nDebe introducir los datos del cliente para garantizar la trazabilidad de la venta"), MessageBox.Ok, MessageBox.NoButton);
      return false;
    }
  }
  return true;
}

function lotesTpv_bufferChanged(fN: String)
{
  var util: FLUtil = new FLUtil();
  var cursor: FLSqlCursor = this.cursor();
  switch (fN) {
    case "codbarras": {
      var codLote: String = util.sqlSelect("lotes", "codlote", "codlote = '" + cursor.valueBuffer("codbarras") + "'");
      if (codLote) {
        var referencia: String = util.sqlSelect("lotes", "referencia", "codlote = '" + codLote + "'");
        if (referencia) {
          this.child("fdbReferencia").setValue(referencia);
        }
      } else {
        this.iface.__bufferChanged(fN);
      }
      break;
    }
    default: {
      this.iface.__bufferChanged(fN);
    }
  }
}

function lotesTpv_insertarMovimientoLote(codLote: String, cantidad: Number)
{
  var cursor: FLSqlCursor = this.cursor();
  var util: FLUtil = new FLUtil();
  var hoy: Date = new Date();
  var referencia: String = this.iface.curLineas.valueBuffer("referencia");

  var curMoviLote: FLSqlCursor = new FLSqlCursor("movilote");
  curMoviLote.setModeAccess(curMoviLote.Insert);
  curMoviLote.refreshBuffer();
  curMoviLote.setValueBuffer("codlote", codLote);
  curMoviLote.setValueBuffer("fecha", hoy);
  curMoviLote.setValueBuffer("referencia", referencia);
  curMoviLote.setValueBuffer("descripcion", this.iface.curLineas.valueBuffer("descripcion"));
  curMoviLote.setValueBuffer("cantidad", cantidad * -1);
  curMoviLote.setValueBuffer("tipo", "Salida");
  curMoviLote.setValueBuffer("docorigen", "TI");
  curMoviLote.setValueBuffer("idlineavc", this.iface.curLineas.valueBuffer("idtpv_linea"));

  var codAlmacen: String = util.sqlSelect("tpv_comandas c INNER JOIN tpv_puntosventa pv ON c.codtpv_puntoventa = pv.codtpv_puntoventa", "pv.codalmacen",  "c.idtpv_comanda = " + cursor.valueBuffer("idtpv_comanda"), "tpv_puntosventa,tpv_comandas");
  if (!codAlmacen) {
    MessageBox.warning(util.translate("scripts", "No ha establecido un almacén para el punto de venta de esta comanda.\nDebe establecerlo antes de crear movimientos de lotes para que éstos se asocien al stock correcto"), MessageBox.Ok, MessageBox.NoButton);
    return false;
  }
  var idStock: String = util.sqlSelect("stocks", "idstock", "codalmacen = '" + codAlmacen + "' AND referencia = '" + referencia + "'");
  if (!idStock) {
    var oArticulo = new Object();
    oArticulo.referencia = referencia;
    idStock = flfactalma.iface.pub_crearStock(codAlmacen, oArticulo);
    if (!idStock) {
      return false;
    }
  }
  curMoviLote.setValueBuffer("idstock", idStock);
  curMoviLote.commitBuffer();
}

//// LOTES TPV //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
