
/** @class_declaration ivaNav */
/////////////////////////////////////////////////////////////////
//// IVA NAV ////////////////////////////////////////////////////
class ivaNav extends oficial
{
  function ivaNav(context)
  {
    oficial(context);
  }
  function commonCalculateField(fN, cursor)
  {
    return this.ctx.ivaNav_commonCalculateField(fN, cursor);
  }
  function datosTablaPadre(cursor)
  {
    return this.ctx.ivaNav_datosTablaPadre(cursor);
  }
  function commonBufferChanged(fN, miForm)
  {
    return this.ctx.ivaNav_commonBufferChanged(fN, miForm);
  }
  function commonInit(miForm)
  {
    return this.ctx.ivaNav_commonInit(miForm);
  }
}
//// IVA NAV ////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition ivaNav */
/////////////////////////////////////////////////////////////////
//// IVA NAV ////////////////////////////////////////////////////
function ivaNav_commonCalculateField(fN, cursor)
{
  var _i = this.iface;
  var valor;
  switch (fN) {
    case "iva": {
      var datosTP = _i.datosTablaPadre(cursor)
                    var codImpuesto = cursor.valueBuffer("codimpuesto");
      valor = flfacturac.iface.pub_campoImpuesto("iva", codImpuesto, datosTP["fecha"], "prov", datosTP["codgrupoivaneg"]);
      if (isNaN(valor)) {
        valor = 0;
      }
      break;
    }
    case "recargo": {
      var datosTP = _i.datosTablaPadre(cursor)
                    var codImpuesto = cursor.valueBuffer("codimpuesto");
      valor = flfacturac.iface.pub_campoImpuesto("recargo", codImpuesto, datosTP["fecha"], "prov", datosTP["codgrupoivaneg"]);
      if (isNaN(valor)) {
        valor = 0;
      }
      break;
    }
    default: {
      valor = _i.__commonCalculateField(fN, cursor);
    }
  }
  return valor;
}

function ivaNav_datosTablaPadre(cursor)
{
  var datos: Array;
  switch (cursor.table()) {
    case "lineaspedidosprov": {
      datos.where = "idpedido = " + cursor.valueBuffer("idpedido");
      datos.tabla = "pedidosprov";
      break;
    }
    case "lineasalbaranesprov": {
      datos.where = "idalbaran = " + cursor.valueBuffer("idalbaran");
      datos.tabla = "albaranesprov";
      break;
    }
    case "lineasfacturasprov": {
      datos.where = "idfactura = " + cursor.valueBuffer("idfactura");
      datos.tabla = "facturasprov";
      break;
    }
  }
  var curRel = cursor.cursorRelation();
  if (curRel && curRel.table() == datos.tabla) {
    switch (cursor.table()) {
      default: {
        datos["codserie"] = curRel.valueBuffer("codserie");
        datos["coddivisa"] = curRel.valueBuffer("coddivisa");
        datos["codgrupoivaneg"] = curRel.valueBuffer("codgrupoivaneg");
      }
    }
    datos["codproveedor"] = curRel.valueBuffer("codproveedor");
    datos["fecha"] = curRel.valueBuffer("fecha");
  } else {
    var qryDatos: FLSqlQuery = new FLSqlQuery;
    qryDatos.setTablesList(datos.tabla);
    switch (cursor.table()) {
      default: {
        qryDatos.setSelect("coddivisa, codproveedor, fecha, codserie, codgrupoivaneg");
      }
    }
    qryDatos.setFrom(datos.tabla);
    qryDatos.setWhere(datos.where);
    qryDatos.setForwardOnly(true);
    if (!qryDatos.exec()) {
      return false;
    }
    if (!qryDatos.first()) {
      return false;
    }
    switch (cursor.table()) {
      default: {
        datos["coddivisa"] = qryDatos.value("coddivisa");
        datos["codserie"] = qryDatos.value("codserie");
        datos["codproveedor"] = qryDatos.value("codproveedor");
        datos["fecha"] = qryDatos.value("fecha");
        datos["codgrupoivaneg"] = qryDatos.value("codgrupoivaneg");
      }
    }
  }
  return datos;
}


function ivaNav_commonBufferChanged(fN, miForm)
{
  var _i = this.iface;
  switch (fN) {
    case "codimpuesto": {
      flfacturac.iface.pub_habilitaPorIva(miForm);
      _i.__commonBufferChanged(fN, miForm);
      break;
    }
    default: {
      _i.__commonBufferChanged(fN, miForm);
    }
  }
}

function ivaNav_commonInit(miForm)
{
  flfacturac.iface.pub_habilitaPorIva(miForm);
}
//// IVA NAV ////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
