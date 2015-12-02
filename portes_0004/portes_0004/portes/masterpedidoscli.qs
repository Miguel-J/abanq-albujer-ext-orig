
/** @class_declaration portes */
/////////////////////////////////////////////////////////////////
//// PORTES /////////////////////////////////////////////////////
class portes extends oficial
{
  function portes(context)
  {
    oficial(context);
  }
  function commonCalculateField(fN: String, cursor: FLSqlCursor): String {
    return this.ctx.portes_commonCalculateField(fN, cursor);
  }
  function datosAlbaran(curPedido: FLSqlCursor, where: String, datosAgrupacion: Array): Boolean {
    return this.ctx.portes_datosAlbaran(curPedido, where, datosAgrupacion);
  }
  function totalesAlbaran(): Boolean {
    return this.ctx.portes_totalesAlbaran();
  }

}
//// PORTES /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition portes */
/////////////////////////////////////////////////////////////////
//// PORTES /////////////////////////////////////////////////////
function portes_commonCalculateField(fN: String, cursor: FLSqlCursor)
{
  var util: FLUtil = new FLUtil();
  var valor: String;

  switch (fN) {

    case "neto": {
      var netoPortes: Number = parseFloat(cursor.valueBuffer("netoportes"));
      valor = this.iface.__commonCalculateField(fN, cursor);
      valor += netoPortes;
      valor = parseFloat(util.roundFieldValue(valor, "pedidoscli", "neto"));
      break;
    }

    case "totaliva": {
      var totalIvaPortes: Number = parseFloat(cursor.valueBuffer("totalivaportes"));
      valor = this.iface.__commonCalculateField(fN, cursor);
      valor += totalIvaPortes;
      valor = parseFloat(util.roundFieldValue(valor, "pedidoscli", "totaliva"));
      break;
    }

    case "totalrecargo": {
      var totalRePortes: Number = parseFloat(cursor.valueBuffer("totalreportes"));
      valor = this.iface.__commonCalculateField(fN, cursor);
      valor += totalRePortes;
      valor = parseFloat(util.roundFieldValue(valor, "pedidoscli", "totalrecargo"));
      break;
    }

    case "totalivaportes": {
      var regIva: String = flfacturac.iface.pub_regimenIVACliente(cursor);
      if (regIva == "U.E." || regIva == "Exento") {
        valor = 0;
        break;
      }
      var portes: Number = parseFloat(cursor.valueBuffer("netoportes"));
      var ivaportes: Number = parseFloat(cursor.valueBuffer("ivaportes"));
      valor = (portes * ivaportes) / 100;
      valor = parseFloat(util.roundFieldValue(valor, "pedidoscli", "totalivaportes"));
      break;
    }

    case "ivaportes": {
      valor = flfacturac.iface.pub_campoImpuesto("iva", cursor.valueBuffer("codimpuestoportes"), cursor.valueBuffer("fecha"));
      valor = parseFloat(util.roundFieldValue(valor, "pedidoscli", "ivaportes"));
      break;
    }
    case "reportes": {
      var aplicarRecEq: Boolean = util.sqlSelect("clientes", "recargo", "codcliente = '" + cursor.valueBuffer("codcliente") + "'");
      if (aplicarRecEq) {
        valor = flfacturac.iface.pub_campoImpuesto("recargo", cursor.valueBuffer("codimpuestoportes"), cursor.valueBuffer("fecha"));
      } else {
        valor = 0;
      }
      valor = parseFloat(util.roundFieldValue(valor, "pedidoscli", "reportes"));
      break;
    }

    case "totalreportes": {
      var aplicarRecEq: Boolean = util.sqlSelect("clientes", "recargo", "codcliente = '" + cursor.valueBuffer("codcliente") + "'");
      if (aplicarRecEq) {
        var regIva: String = flfacturac.iface.pub_regimenIVACliente(cursor);
        if (regIva == "U.E." || regIva == "Exento") {
          valor = 0;
          break;
        }
        var portes: Number = parseFloat(cursor.valueBuffer("netoportes"));
        var reportes: Number = parseFloat(cursor.valueBuffer("reportes"));
        valor = (portes * reportes) / 100;
      } else
        valor = 0;
      valor = parseFloat(util.roundFieldValue(valor, "pedidoscli", "totalreportes"));
      break;
    }

    case "totalportes": {
      var portes: Number = parseFloat(cursor.valueBuffer("netoportes"));
      var totalIvaPortes: Number = parseFloat(cursor.valueBuffer("totalivaportes"));
      var totalRePortes: Number = parseFloat(cursor.valueBuffer("totalreportes"));
      valor = portes + totalIvaPortes + totalRePortes;
      valor = parseFloat(util.roundFieldValue(valor, "pedidoscli", "totalportes"));
      break;
    }

    default: {
      valor = this.iface.__commonCalculateField(fN, cursor);
      break;
    }
  }
  return valor;
}

/** \D Informa los datos de un albarán a partir de los de uno o varios pedidos
@param  curPedido: Cursor que contiene los datos a incluir en el albarán
@return True si el cálculo se realiza correctamente, false en caso contrario
\end */
function portes_datosAlbaran(curPedido: FLSqlCursor, where: String, datosAgrupacion: Array): Boolean {
  var util: FLUtil = new FLUtil;
  if (!this.iface.__datosAlbaran(curPedido, where, datosAgrupacion))
  {
    return false;
  }

  var netoPortes: Number = util.sqlSelect("pedidoscli", "SUM(netoportes)", where);
  if (isNaN(netoPortes))
  {
    netoPortes = 0;
  }
  netoPortes = util.roundFieldValue(netoPortes, "albaranescli", "netoportes");

  var codImpuesto: String = curPedido.valueBuffer("codimpuestoportes");
  var iva: Number, recargo: Number;
  this.iface.curAlbaran.setValueBuffer("netoportes", netoPortes);
  this.iface.curAlbaran.setValueBuffer("codimpuestoportes", codImpuesto);
  if (curPedido.isNull("ivaportes"))
  {
    this.iface.curAlbaran.setNull("ivaportes");
  } else {
    iva = curPedido.valueBuffer("ivaportes");
    if (iva != 0 && codImpuesto && codImpuesto != "")
    {
      iva = flfacturac.iface.pub_campoImpuesto("iva", codImpuesto, this.iface.curAlbaran.valueBuffer("fecha"));
    }
    this.iface.curAlbaran.setValueBuffer("ivaportes", iva);
  }
  if (curPedido.isNull("reportes"))
  {
    this.iface.curAlbaran.setNull("reportes");
  } else {
    recargo = curPedido.valueBuffer("reportes");
    if (recargo != 0 && codImpuesto && codImpuesto != "")
    {
      recargo = flfacturac.iface.pub_campoImpuesto("recargo", codImpuesto, this.iface.curAlbaran.valueBuffer("fecha"));
    }
    this.iface.curAlbaran.setValueBuffer("reportes", recargo);
  }

  return true;
}

/** \D Informa los datos de un albarana referentes a totales (I.V.A., neto, etc.) de portes
@return True si el cálculo se realiza correctamente, false en caso contrario
\end */
function portes_totalesAlbaran(): Boolean {
  this.iface.curAlbaran.setValueBuffer("totalivaportes", formalbaranescli.iface.commonCalculateField("totalivaportes", this.iface.curAlbaran));
  this.iface.curAlbaran.setValueBuffer("totalreportes", formalbaranescli.iface.commonCalculateField("totalreportes", this.iface.curAlbaran));
  this.iface.curAlbaran.setValueBuffer("totalportes", formalbaranescli.iface.commonCalculateField("totalportes", this.iface.curAlbaran));

  if (!this.iface.__totalesAlbaran())
  {
    return false;
  }

  return true;
}

//// PORTES /////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////