
/** @class_declaration lotesTpv */
/////////////////////////////////////////////////////////////////
//// LOTES TPV //////////////////////////////////////////////////
class lotesTpv extends oficial
{
  function lotesTpv(context)
  {
    oficial(context);
  }
  function datosMoviLote(accion: String): Array {
    return this.ctx.lotesTpv_datosMoviLote(accion);
  }
  function docJustificativo()
  {
    return this.ctx.lotesTpv_docJustificativo();
  }
  function pbnConsultarDocClicked()
  {
    return this.ctx.lotesTpv_pbnConsultarDocClicked();
  }
}
//// LOTES TPV //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition lotesTpv */
/////////////////////////////////////////////////////////////////
//// LOTES TPV //////////////////////////////////////////////////
/** \D Muestra los datos del documento justificativo del movimiento en la etiqueta correspondiente
\end */
function lotesTpv_docJustificativo()
{
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  switch (cursor.valueBuffer("docorigen")) {
    case "VC" : {
      var idComanda: String = util.sqlSelect("tpv_lineascomanda", "idtpv_comanda", "idtpv_linea = " + cursor.valueBuffer("idlineavc"));
      if (idComanda)
        this.child("lblDocumento").text = util.translate("scripts", "Venta TPV: %1").arg(util.sqlSelect("tpv_comandas", "codigo", "idtpv_comanda = " + idComanda));
      break;
    }
    default: {
      this.iface.__docJustificativo();
    }
  }
}

/** \D Calcula los datos del movimiento en función de la acción desde donde se llama al formulario
@param  accion: Acción
@return Datos del movimiento
* Tipo (Entrada, Salida, Regularización, etc)
* DocOrigen (AC -Albarán de cliente-, FC -Factura de cliente-, etc.)
* codAlmacen
* idStock
\end */
function lotesTpv_datosMoviLote(accion: String): Array {
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();
  var curRelacionado: FLSqlCursor = cursor.cursorRelation();

  var datos: Array = [];
  var referencia: String = curRelacionado.valueBuffer("referencia");
  switch (accion)
  {
    case "tpv_lineascomanda": {
      datos.tipo = "Salida";
      datos.docOrigen = "VC";
      datos.codAlmacen = util.sqlSelect("tpv_comandas c INNER JOIN tpv_puntosventa pv ON c.codtpv_puntoventa = pv.codtpv_puntoventa", "pv.codalmacen",  "c.idtpv_comanda = " + curRelacionado.valueBuffer("idtpv_comanda"), "tpv_puntosventa,tpv_comandas");
      if (!datos.codAlmacen) {
        MessageBox.warning(util.translate("scripts", "No ha establecido un almacén para el punto de venta de esta comanda.\nDebe establecerlo antes de crear movimientos de lotes para que éstos se asocien al stock correcto"), MessageBox.Ok, MessageBox.NoButton);
        return false;
      }
      datos.idStock = util.sqlSelect("stocks", "idstock", "codalmacen = '" + datos.codAlmacen + "' AND referencia = '" + referencia + "'");
      if (!datos.idStock) {
        var oArticulo = new Object();
        oArticulo.referencia = referencia;
        datos.idStock = flfactalma.iface.pub_crearStock(datos.codAlmacen, oArticulo);
        if (!datos.idStock)
          return false;
      }
      this.child("fdbCodLote").setFilter("referencia = '" + referencia + "' AND enalmacen > 0");
      break;
    }
    default: {
      datos = this.iface.__datosMoviLote(accion);
    }
  }
  return datos;
}

/** \D Muestra los datos del documento justificativo del movimiento en la etiqueta correspondiente
\end */
function lotesTpv_pbnConsultarDocClicked()
{
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  switch (cursor.valueBuffer("docorigen")) {
    case "VC" : {
      var idComanda = util.sqlSelect("tpv_lineascomanda", "idtpv_comanda", "idtpv_linea = " + cursor.valueBuffer("idlineavc"));
      if (idComanda) {
        var curDocumento: FLSqlCursor = new FLSqlCursor("tpv_comandas");
        curDocumento.select("idtpv_comanda = " + idComanda);
        if (curDocumento.first()) {
          try {
            curDocumento.browseRecord();
          } catch (e) {}
        }
      }
      break;
    }
    default: {
      this.iface.__pbnConsultarDocClicked();
    }
  }
}

//// LOTES TPV //////////////////////////////////////////////////
////////////////////////////////////////////////////////////////
