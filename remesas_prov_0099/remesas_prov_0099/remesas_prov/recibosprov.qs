
/** @class_declaration remesas */
/////////////////////////////////////////////////////////////////
//// REMESAS DE RECIBOS DE PROVEEDOR ////////////////////////////
class remesas extends proveed
{
  function remesas(context)
  {
    proveed(context);
  }
  function cambiarEstado()
  {
    return this.ctx.remesas_cambiarEstado();
  }
  function commonCalculateField(fN, cursor)
  {
    return this.ctx.remesas_commonCalculateField(fN, cursor);
  }
}
//// REMESAS DE RECIBOS DE PROVEEDOR ////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition remesas */
/////////////////////////////////////////////////////////////////
//// REMESAS DE RECIBOS DE PROVEEDOR ////////////////////////////
/** \D
Cambia el valor del estado del recibo entre Emitido, Cobrado y Devuelto
\end */
function remesas_cambiarEstado()
{
  var _i = this.iface;
  this.iface.__cambiarEstado();
  var util: FLUtil = new FLUtil;
  var cursor: FLSqlCursor = this.cursor();

  if (util.sqlSelect("pagosdevolprov", "idremesa", "idrecibo = " + cursor.valueBuffer("idrecibo") + " ORDER BY fecha DESC, idpagodevol DESC") != 0) {
    this.child("lblRemesado").text = "REMESADO";
    this.child("fdbFechav").setDisabled(true);
    this.child("fdbImporte").setDisabled(true);
    this.child("fdbCodCuenta").setDisabled(true);
    //this.child("coddir").setDisabled(true);
    this.child("tdbPagosDevolProv").setInsertOnly(true);
    this.child("pushButtonNext").close();
    this.child("pushButtonPrevious").close();
    this.child("pushButtonFirst").close();
    this.child("pushButtonLast").close();
  }
  var estado = _i.calculateField("estado");
  if (estado == "Remesado") {
    this.child("gbxPagDev").enabled = false,
  } else {
    this.child("gbxPagDev").enabled = true,
  }
}

                        function remesas_commonCalculateField(fN, cursor)
{
  var _i = this.iface;
  var util = new FLUtil();
  var valor: String;
  switch (fN) {
    case "estado": {
      valor = "Emitido";
      var curPagosDevol = new FLSqlCursor("pagosdevolprov");
      curPagosDevol.select("idrecibo = " + cursor.valueBuffer("idrecibo") +
                           " ORDER BY fecha DESC, idpagodevol DESC");
      if (curPagosDevol.first()) {
        curPagosDevol.setModeAccess(curPagosDevol.Browse);
        curPagosDevol.refreshBuffer();
        switch (curPagosDevol.valueBuffer("tipo")) {
          case "Pago": {
            valor = "Pagado";
            break;
          }
          case "Remesado": {
            valor = "Remesado";
            break;
          }
          default: {
            valor = "Devuelto";
            break;
          }
        }
      }
      break;
    }
    case "situacion": {
      var q = new FLSqlQuery;
      q.setSelect("idremesa");
      q.setFrom("pagosdevolprov");
      q.setWhere("idrecibo = " + cursor.valueBuffer("idrecibo") + " ORDER BY fecha DESC, idpagodevol DESC");
      q.setForwardOnly(true);
      if (!q.exec()) {
        return false;
      }
      if (q.first()) {
        if (q.value("idremesa") != 0) {
          valor = "En remesa";
        } else {
          valor = "En cartera";
        }
      } else {
        valor = "En cartera";
      }
      break;
    }
    default: {
      valor = _i.__commonCalculateField(fN, cursor);
    }
  }
  return valor;
}

//// REMESAS DE RECIBOS DE PROVEEDOR ////////////////////////////
/////////////////////////////////////////////////////////////////
