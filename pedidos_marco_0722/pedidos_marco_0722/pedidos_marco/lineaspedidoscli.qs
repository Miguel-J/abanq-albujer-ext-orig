
/** @class_declaration pedMarco */
/////////////////////////////////////////////////////////////////
//// PEDIDOS MARCO //////////////////////////////////////////////
class pedMarco extends oficial
{
  function pedMarco(context)
  {
    oficial(context);
  }
  function commonBufferChanged(fN, miForm)
  {
    return this.ctx.pedMarco_commonBufferChanged(fN, miForm);
  }
  function commonCalculateField(fN, cursor)
  {
    return this.ctx.pedMarco_commonCalculateField(fN, cursor);
  }
}
//// PEDIDOS MARCO //////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition pedMarco */
/////////////////////////////////////////////////////////////////
//// PEDIDOS MARCO //////////////////////////////////////////////
function pedMarco_commonBufferChanged(fN, miForm)
{
  var _i = this.iface;
  var cursor = miForm.cursor();
  switch (fN) {
    case "referencia": {
      if (cursor.table() == "lineaspedidoscli" || cursor.table() == "lineaspresupuestoscli") {
        var idLineaPM = _i.commonCalculateField("idlineapedidomarco", cursor);
        if (idLineaPM) {
          cursor.setValueBuffer("idlineapedidomarco", idLineaPM);
        } else {
          cursor.setNull("idlineapedidomarco");
          _i.commonBufferChanged("idlineapedidomarco", miForm);
        }
      }
      _i.__commonBufferChanged(fN, miForm);
      break;
    }
    case "idlineapedidomarco": {
      miForm.child("fdbCodPedidoMarco").setValue(_i.commonCalculateField("codpedidomarco", cursor));
      return false;
    }
    default: {
      _i.__commonBufferChanged(fN, miForm);
    }
  }
}

function pedMarco_commonCalculateField(fN, cursor)
{
  var _i = this.iface;
  var valor;
  switch (fN) {
    case "idlineapedidomarco": {
      var referencia = cursor.valueBuffer("referencia");
      var fecha = cursor.cursorRelation().valueBuffer("fecha");
      var codCliente = cursor.cursorRelation().valueBuffer("codcliente");
      valor = AQUtil.sqlSelect("pedidosmarcocli pm INNER JOIN lineaspedidomarcocli lpm ON pm.codpedidomarco = lpm.codpedidomarco", "lpm.idlinea", "pm.codcliente = '" + codCliente + "' AND pm.activo AND pm.validezdesde <= '" + fecha  + "' AND pm.validezhasta >= '" + fecha + "' AND lpm.referencia = '" + referencia + "'", "pedidosmarcocli,lineaspedidomarcocli");
      break;
    }
    case "codpedidomarco": {
      if (cursor.isNull("idlineapedidomarco")) {
        valor = "";
        break;
      }
      valor = AQUtil.sqlSelect("lineaspedidomarcocli", "codpedidomarco", "idlinea = " + cursor.valueBuffer("idlineapedidomarco"));
      break;
    }
    case "pvpunitario": {
      if (cursor.table() == "lineaspedidoscli" || cursor.table() == "lineaspresupuestoscli") {
        if (cursor.isNull("idlineapedidomarco")) {
          valor = _i.__commonCalculateField(fN, cursor);
        } else {
          valor = AQUtil.sqlSelect("lineaspedidomarcocli", "pvpunitario", "idlinea = " + cursor.valueBuffer("idlineapedidomarco"));
        }
      } else {
        valor = _i.__commonCalculateField(fN, cursor);
      }
      break;
    }
    default: {
      valor = _i.__commonCalculateField(fN, cursor);
    }
  }
  return valor;
}
//// PEDIDOS MARCO //////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
