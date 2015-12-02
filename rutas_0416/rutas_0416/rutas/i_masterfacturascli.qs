
/** @class_declaration rutas */
/////////////////////////////////////////////////////////////////
//// RUTAS //////////////////////////////////////////////////////
class rutas extends oficial
{
  function rutas(context)
  {
    oficial(context);
  }
  function obtenerParamInforme(): Array {
    return this.ctx.rutas_obtenerParamInforme();
  }
}
//// RUTAS //////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition rutas */
/////////////////////////////////////////////////////////////////
//// RUTAS /////////////////////////////////////////////////////
/** \D Obtiene un array con los parámetros necesarios para establecer el informe
@return array de parámetros o false si hay error
\end */
function rutas_obtenerParamInforme(): Array {
  var paramInforme = flfactinfo.iface.pub_dameParamInforme();
  paramInforme["nombreInforme"] = false;
  paramInforme["orderBy"] = false;
  paramInforme["groupBy"] = false;
  paramInforme["etiquetas"] = false;
  paramInforme["impDirecta"] = false;
  paramInforme["whereFijo"] = false;
  paramInforme["nombreReport"] = false;
  paramInforme["numCopias"] = false;

  var cursor: FLSqlCursor = this.cursor();
  var seleccion: String = cursor.valueBuffer("id");
  if (!seleccion)
    return false;
  paramInforme.nombreInforme = cursor.action();
  paramInforme.orderBy = "";
  var o: String = "";
  for (var i: Number = 1; i < 3; i++)
  {
    o = formi_albaranescli.iface.pub_obtenerOrden(i, cursor, "facturascli");
    if (o) {
      if (paramInforme.orderBy == "")
        paramInforme.orderBy = o;
      else
        paramInforme.orderBy += ", " + o;
    }
  }

  if (paramInforme.nombreInforme != "i_resfacturascli")
  {
    if (paramInforme.orderBy)
      paramInforme.orderBy += ",";
    paramInforme.orderBy += " lineasfacturascli.idalbaran, lineasfacturascli.referencia, lineasfacturascli.idlinea";
  }

  if (cursor.valueBuffer("codintervalo"))
  {
    var intervalo: Array = [];
    intervalo = flfactppal.iface.pub_calcularIntervalo(cursor.valueBuffer("codintervalo"));
    cursor.setValueBuffer("d_facturascli_fecha", intervalo.desde);
    cursor.setValueBuffer("h_facturascli_fecha", intervalo.hasta);
  }

  var where: String = "";
  if (cursor.valueBuffer("deabono"))
  {
    where = "facturascli.deabono";
  }
  if (cursor.valueBuffer("filtrarimportes"))
  {
    if (!cursor.isNull("desdeimporte")) {
      if (where != "") {
        where += " AND ";
      }
      where += "facturascli.total >= " + cursor.valueBuffer("desdeimporte");
    }
    if (!cursor.isNull("hastaimporte")) {
      if (where != "") {
        where += " AND ";
      }
      where += "facturascli.total <= " + cursor.valueBuffer("hastaimporte");
    }
  }
  if (cursor.valueBuffer("codruta"))
  {
    if (where != "") {
      where += " AND ";
    }
    where += "facturascli.coddir IN (SELECT paradas.coddir FROM paradas LEFT OUTER JOIN rutas ON paradas.codruta = rutas.codruta WHERE rutas.codruta = '" + cursor.valueBuffer("codruta") + "')";
  }
  paramInforme.whereFijo = where;

  return paramInforme;
}

//// RUTAS /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
