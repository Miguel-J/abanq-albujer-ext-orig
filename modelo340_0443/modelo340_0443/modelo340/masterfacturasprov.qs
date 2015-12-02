
/** @class_declaration modelo340 */
/////////////////////////////////////////////////////////////////
//// MODELO 340 /////////////////////////////////////////////////
class modelo340 extends modelos
{
  function modelo340(context)
  {
    modelos(context);
  }
  function configurarBotonModelos()
  {
    return this.ctx.modelo340_configurarBotonModelos();
  }
  function commonCalculateField(fN, cursor)
  {
    return this.ctx.modelo340_commonCalculateField(fN, cursor);
  }
  function calculaClave340(cursor)
  {
    return this.ctx.modelo340_calculaClave340(cursor);
  }
  function clave340PorArticulo(cursor)
  {
    return this.ctx.modelo340_clave340PorArticulo(cursor);
  }
  function clave340C(cursor)
  {
    return this.ctx.modelo340_clave340C(cursor);
  }
}
//// MODELO 340 /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition modelo340 */
/////////////////////////////////////////////////////////////////
//// MODELO 340 /////////////////////////////////////////////////
function modelo340_configurarBotonModelos()
{
  var _i = this.iface;
  return _i.__configurarBotonModelos();
}

function modelo340_commonCalculateField(fN, cursor)
{
  var _i = this.iface;
  var valor;
  switch (fN) {
    case "claveoperacion340": {
      if (cursor.valueBuffer("manual340")) {
        valor = cursor.valueBuffer("claveoperacion340");
      } else {
        valor = _i.calculaClave340(cursor);
      }
      break;
    }
    case "desglose340": {
      if (cursor.valueBuffer("claveoperacion340") == "C") {
        valor = AQUtil.sqlSelect("lineasivafactprov", "COUNT(*)", "idfactura = " + cursor.valueBuffer("idfactura"));
      } else {
        valor = 1;
      }
      break;
    }
    default: {
      valor = _i.__commonCalculateField(fN, cursor);
    }
  }
  return valor;
}

/// Sobrecargar para cambiar orden de prioridad
function modelo340_calculaClave340(cursor)
{
  var _i = this.iface;
  var valor = "";
  valor = _i.clave340PorArticulo(cursor);
  if (valor != "") {
    return valor;
  }
  valor = _i.clave340C(cursor);
  if (valor != "") {
    return valor;
  }
  return "";
}

function modelo340_clave340C(cursor) /// Si la factura tiene varios IVA
{
  var _i = this.iface;
  var valor = "";
  var numIVA = AQUtil.sqlSelect("lineasivafactprov", "COUNT(*)", "idfactura = " + cursor.valueBuffer("idfactura"));
  if (numIVA > 1) {
    valor = "C";
  }
  return valor;
}

function modelo340_clave340PorArticulo(cursor)
{
  var valor;
  var q = new FLSqlQuery;
  q.setSelect("a.claveoperacion340");
  q.setFrom("lineasfacturasprov lf INNER JOIN articulos a ON lf.referencia = a.referencia");
  q.setWhere("lf.idfactura = " + cursor.valueBuffer("idfactura") + " AND a.claveoperacion340 IS NOT NULL GROUP BY a.claveoperacion340");
  q.setForwardOnly(true);
  if (!q.exec()) {
    return false;
  }
  if (q.size() == 0) {
    return "";
  } else if (q.size() > 1) {
    return "?"; /// Este valor hará fallar la inserción de la factura
  } else {
    if (!q.first()) {
      return "";
    }
    valor = q.value("a.claveoperacion340");
  }
  return valor;
}
//// MODELO 340 /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
