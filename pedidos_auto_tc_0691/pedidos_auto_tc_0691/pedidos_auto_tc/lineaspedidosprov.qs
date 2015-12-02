
/** @class_declaration pedautotc */
/////////////////////////////////////////////////////////////////
//// PEDIDOS_AUTO_TC ////////////////////////////////////////////
class pedautotc extends barCode
{
  function pedautotc(context)
  {
    barCode(context);
  }
  function datosTablaPadre(cursor)
  {
    return this.ctx.pedautotc_datosTablaPadre(cursor);
  }
}
//// PEDIDOS_AUTO_TC ////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition pedautotc */
/////////////////////////////////////////////////////////////////
//// PEDIDOS_AUTO_TC ////////////////////////////////////////////
function pedautotc_datosTablaPadre(cursor)
{
  var util = new FLUtil();
  var datos: Array;
  switch (cursor.table()) {
    case "lineaspedidosaut": {
      datos.where = "idpedidoaut = " + cursor.valueBuffer("idpedidoaut");
      datos.tabla = "pedidosaut";

      var qryDatos: FLSqlQuery = new FLSqlQuery;
      qryDatos.setTablesList(datos.tabla);
      qryDatos.setSelect("coddivisa, codproveedor, fecha, codserie");
      qryDatos.setFrom(datos.tabla);
      qryDatos.setWhere(datos.where);
      qryDatos.setForwardOnly(true);
      if (!qryDatos.exec()) {
        return false;
      }
      if (!qryDatos.first()) {
        return false;
      }
      datos["coddivisa"] = qryDatos.value("coddivisa");
      datos["tasaconv"] = util.sqlSelect("divisas", "tasaconv", "coddivisa = '" + qryDatos.value("coddivisa") + "'");
      datos["codproveedor"] = qryDatos.value("codproveedor");
      datos["fecha"] = qryDatos.value("fecha");
      datos["codserie"] = qryDatos.value("codserie");
      break;
    }
    default: {
      datos = this.iface.__datosTablaPadre(cursor);
    }
  }
  return datos;
}

//// PEDIDOS_AUTO_TC ////////////////////////////////////////////
////////////////////////////////////////////////////////////////
