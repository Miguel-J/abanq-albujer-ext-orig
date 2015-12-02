
/** @class_declaration pagosRemesa */
/////////////////////////////////////////////////////////////////
//// PAGOS_REMESA ///////////////////////////////////////////////
class pagosRemesa extends oficial
{
  function pagosRemesa(context)
  {
    oficial(context);
  }
  function cambiarEstado()
  {
    return this.ctx.pagosRemesa_cambiarEstado();
  }
  function obtenerEstado(idRecibo: String): String {
    return this.ctx.pagosRemesa_obtenerEstado(idRecibo);
  }
}
//// PAGOS_REMESA ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition pagosRemesa */
/////////////////////////////////////////////////////////////////
//// PAGOS_REMESA ///////////////////////////////////////////////
/** \D
Cambia el valor del estado del recibo entre Emitido, Cobrado y Devuelto
\end */
function pagosRemesa_cambiarEstado()
{
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();
  var estado: String = this.iface.calculateField("estado");
  this.child("fdbEstado").setValue(estado);
  if (estado != "Emitido")
    this.child("fdbImporte").setDisabled(true);
  else
    this.child("fdbImporte").setDisabled(false);

  if (util.sqlSelect("pagosdevolcli", "idremesa", "idrecibo = " + cursor.valueBuffer("idrecibo") + " ORDER BY fecha DESC, idpagodevol DESC") != 0) {
    this.child("lblRemesado").text = "REMESADO";
    this.child("fdbFechav").setDisabled(true);
    this.child("fdbImporte").setDisabled(true);
    this.child("fdbCodCuenta").setDisabled(true);
    this.child("coddir").setDisabled(true);
    this.child("tdbPagosDevolCli").setReadOnly(true);
    this.child("pushButtonNext").close();
    this.child("pushButtonPrevious").close();
    this.child("pushButtonFirst").close();
    this.child("pushButtonLast").close();
  }
}

function pagosRemesa_obtenerEstado(idRecibo: String): String {
  var valor: String = "Emitido";
  var curPagosDevol: FLSqlCursor = new FLSqlCursor("pagosdevolcli");
  curPagosDevol.select("idrecibo = " + idRecibo + " ORDER BY fecha DESC, idpagodevol DESC");
  if (curPagosDevol.first())
  {
    curPagosDevol.setModeAccess(curPagosDevol.Browse);
    curPagosDevol.refreshBuffer();
    if (curPagosDevol.valueBuffer("tipo") == "Pago") {
      valor = "Pagado";
    } else {
      if (curPagosDevol.valueBuffer("tipo") == "Devolución") {
        valor = "Devuelto";
      } else {
        if (curPagosDevol.valueBuffer("tipo") == "Remesa")
          valor = "Remesado"
        }
    }
  }
  return valor;
}
//// PAGOS_REMESA ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
